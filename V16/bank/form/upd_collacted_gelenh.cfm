<cfif not isdefined("attributes.new_dsn3")><cfset new_dsn3 = dsn3><cfelse><cfset new_dsn3 = attributes.new_dsn3></cfif>
<cfif not isdefined("attributes.new_dsn2")><cfset new_dsn2 = dsn2><cfelse><cfset new_dsn2 = attributes.new_dsn2></cfif>
<cfif not isdefined("session_basket_kur_ekle")>
	<cfinclude template="../../objects/functions/get_basket_money_js.cfm">  <!---rate1Array, rate2Array bu fonksiyonda tanımlanıyor.--->
	<cfscript>session_basket_kur_ekle(action_id=attributes.multi_id,table_type_id:1,process_type:1);</cfscript>
</cfif>
<cf_xml_page_edit fuseact="bank.add_collacted_gelenh">
<cf_get_lang_set module_name="bank">
<cfset paper_type = 1>
<cfset str_money_bskt_main = session.ep.money>
<cfif paper_type eq 1>
	<cfset select_input = 'account_id'>
	<cfset auto_paper_type = "incoming_transfer">
<cfelseif paper_type eq 2>
	<cfset select_input = 'account_id'>
	<cfset auto_paper_type = "outgoing_transfer">
<cfelseif paper_type eq 3>
	<cfset select_input = 'cash_action_to_cash_id'>
	<cfset auto_paper_type = "revenue_receipt">
<cfelseif paper_type eq 4>
	<cfset select_input = 'cash_action_from_cash_id'>
	<cfset auto_paper_type = "cash_payment">
<cfelseif paper_type eq 5>
	<cfset select_input = 'action_currency_id'>
	<cfset auto_paper_type = "debit_claim">
</cfif>
<cfquery name="get_action_detail" datasource="#dsn2#">
	SELECT
		BAM.*,
		BA.ACTION_FROM_COMPANY_ID AS ACTION_COMPANY_ID,
		BA.ACTION_FROM_CONSUMER_ID AS ACTION_CONSUMER_ID,
		BA.ACTION_FROM_EMPLOYEE_ID AS ACTION_EMPLOYEE_ID,
		ISNULL(C.FULLNAME,ISNULL(CM.CONSUMER_NAME+' '+CM.CONSUMER_SURNAME,E.EMPLOYEE_NAME +' '+E.EMPLOYEE_SURNAME )) AS NAME_COMPANY,
		OTHER_CASH_ACT_VALUE AS ACTION_VALUE_OTHER,
		BA.SUBSCRIPTION_ID,
		(SELECT SUBSCRIPTION_NO FROM #dsn3_alias#.SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID =BA.SUBSCRIPTION_ID ) AS SUBSCRIPTION_NO,
		BA.PAPER_NO,
		BA.PROJECT_ID,
		PP.PROJECT_HEAD,
		BA.ACTION_ID,
		BA.ACTION_VALUE,
		BA.ACTION_DETAIL,
		BA.OTHER_MONEY AS ACTION_CURRENCY,
		BAM.UPD_STATUS,
		BA.MASRAF,
		BA.TO_BRANCH_ID,
		BA.EXPENSE_CENTER_ID,
		EC.EXPENSE,
		BA.EXPENSE_ITEM_ID,
		EI.EXPENSE_ITEM_NAME,
		BA.FROM_BRANCH_ID,
		BA.ASSETP_ID,
		AP.ASSETP,
		BA.SPECIAL_DEFINITION_ID,
		BA.ACC_DEPARTMENT_ID AS DEPARTMENT_ID,
		BA.ACC_TYPE_ID,
		SA.ACC_TYPE_NAME,
		SAA.ACCOUNT_TYPE,
		BA.AVANS_ID,
		BA.BANK_ORDER_ID,
		C.MEMBER_CODE,
		BA.ACTION_CURRENCY_ID AS ACTION_CURRENCY2,
		BA.IBAN_NO AS IBAN_NO,
		CASE WHEN BA.SYSTEM_ACTION_VALUE > 0 AND BA.ACTION_VALUE > 0 THEN (BA.SYSTEM_ACTION_VALUE - BA.MASRAF * (BA.SYSTEM_ACTION_VALUE / BA.ACTION_VALUE )) ELSE 0 END SYSTEM_ACTION_VALUE
	FROM
		BANK_ACTIONS_MULTI BAM
		LEFT JOIN BANK_ACTIONS BA ON BAM.MULTI_ACTION_ID = BA.MULTI_ACTION_ID 
		LEFT JOIN #dsn_alias#.COMPANY C ON BA.ACTION_FROM_COMPANY_ID=C.COMPANY_ID
		LEFT JOIN #dsn_alias#.CONSUMER CM ON CM.CONSUMER_ID = BA.ACTION_FROM_CONSUMER_ID
		LEFT JOIN #dsn_alias#.EMPLOYEES E ON E.EMPLOYEE_ID = BA.ACTION_FROM_EMPLOYEE_ID
		LEFT JOIN #dsn_alias#.PRO_PROJECTS PP ON BA.PROJECT_ID = PP.PROJECT_ID
		LEFT JOIN #dsn_alias#.ASSET_P AP ON BA.ASSETP_ID = AP.ASSETP_ID
		LEFT JOIN EXPENSE_CENTER EC ON EC.EXPENSE_ID = BA.EXPENSE_CENTER_ID
		LEFT JOIN EXPENSE_ITEMS EI ON EI.EXPENSE_ITEM_ID = BA.EXPENSE_ITEM_ID
		LEFT JOIN #dsn_alias#.SETUP_ACC_TYPE SA ON SA.ACC_TYPE_ID = BA.ACC_TYPE_ID
		LEFT JOIN #dsn_alias#.ACCOUNT_TYPES SAA ON SAA.ACCOUNT_TYPE_ID = BA.ACC_TYPE_ID
	WHERE
			BAM.MULTI_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.multi_id#">
</cfquery>
<!--- toplu gelen havale ile ilgili kapama isleminin olup olmadigina bakilir --->
<cfif len(get_action_detail.action_id) and len(get_action_detail.action_type_id)>
	<cfquery name="get_closed" datasource="#dsn2#">
		SELECT 
			CARI_CLOSED.CLOSED_ID,
			CARI_CLOSED.IS_DEMAND,
			CARI_CLOSED.IS_ORDER,
			CARI_CLOSED.IS_CLOSED
		FROM 
			CARI_CLOSED_ROW,
				CARI_CLOSED
		WHERE 
			CARI_CLOSED.CLOSED_ID = CARI_CLOSED_ROW.CLOSED_ID AND
			CARI_CLOSED.IS_CLOSED = 1 AND
			CARI_CLOSED_ROW.ACTION_ID IN (#Trim(valueList(get_action_detail.action_id,','))#) AND <!--- Queryparam list parametresi max limitini astigi icin kaldirildi --->
			CARI_CLOSED_ROW.ACTION_TYPE_ID = 24
	</cfquery>
</cfif>
<cfif not get_action_detail.recordcount>
	<br/><font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
	<cfexit method="exittemplate">
</cfif>

<cfquery name="get_money" datasource="#dsn2#">
	SELECT MONEY_TYPE AS MONEY,*,RATE2 RATE3 FROM BANK_ACTION_MULTI_MONEY WHERE ACTION_ID = #attributes.multi_id# ORDER BY ACTION_MONEY_ID
</cfquery>

<cfif not GET_MONEY.recordcount>
	<cfquery name="get_money" datasource="#dsn2#">
		SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE MONEY_STATUS=1 ORDER BY MONEY_ID
	</cfquery>
</cfif>
<cfquery name="GET_SPECIAL_DEFINITION" datasource="#DSN#">
	SELECT SPECIAL_DEFINITION_ID,SPECIAL_DEFINITION FROM SETUP_SPECIAL_DEFINITION <cfif listfind("2,4",paper_type)> WHERE SPECIAL_DEFINITION_TYPE = 2<cfelseif listfind("1,3",paper_type)>WHERE SPECIAL_DEFINITION_TYPE = 1</cfif>
</cfquery>
<cfscript>
	sepet = StructNew();
	sepet.satir = ArrayNew(1);
	for(i=1;i<=get_action_detail.recordcount;i++)
	{
		sepet.satir[i] = StructNew();
		sepet.satir[i].MEMBER_CODE = get_action_detail.MEMBER_CODE[i];
		if(get_action_detail.ACTION_COMPANY_ID[i] != '')
		sepet.satir[i].MEMBER_TYPE = 'partner';
		else if(get_action_detail.ACTION_EMPLOYEE_ID[i] != '')
		sepet.satir[i].MEMBER_TYPE = 'employee';
		else
		sepet.satir[i].MEMBER_TYPE = 'consumer';
		if(len(get_action_detail.ACC_TYPE_ID[i]) and len(get_action_detail.ACTION_COMPANY_ID[i]))
			sepet.satir[i].ACTION_COMPANY_ID = get_action_detail.ACTION_COMPANY_ID[i] & '_' & get_action_detail.ACC_TYPE_ID[i];
		else
			sepet.satir[i].ACTION_COMPANY_ID = get_action_detail.ACTION_COMPANY_ID[i];
		if(len(get_action_detail.ACC_TYPE_ID[i]) and len(get_action_detail.ACTION_CONSUMER_ID[i]))
			sepet.satir[i].ACTION_CONSUMER_ID = get_action_detail.ACTION_CONSUMER_ID[i] & '_' & get_action_detail.ACC_TYPE_ID[i];
		else
			sepet.satir[i].ACTION_CONSUMER_ID = get_action_detail.ACTION_CONSUMER_ID[i];
		if(len(get_action_detail.ACC_TYPE_ID[i]) and len(get_action_detail.ACTION_EMPLOYEE_ID[i]))
			sepet.satir[i].ACTION_EMPLOYEE_ID = get_action_detail.ACTION_EMPLOYEE_ID[i] & '_' & get_action_detail.ACC_TYPE_ID[i];
		else
			sepet.satir[i].ACTION_EMPLOYEE_ID = get_action_detail.ACTION_EMPLOYEE_ID[i];
		if(len(get_action_detail.ACC_TYPE_NAME[i]) AND LEN(get_action_detail.ACTION_EMPLOYEE_ID[i]))
			sepet.satir[i].COMP_NAME = get_action_detail.NAME_COMPANY[i] & '-' & get_action_detail.ACC_TYPE_NAME[i];
		else if (len(get_action_detail.ACCOUNT_TYPE[i]) AND not LEN(get_action_detail.ACTION_EMPLOYEE_ID[i]))
			sepet.satir[i].COMP_NAME = get_action_detail.NAME_COMPANY[i] & '-' & get_action_detail.ACCOUNT_TYPE[i];
		else
			sepet.satir[i].COMP_NAME = get_action_detail.NAME_COMPANY[i];
		sepet.satir[i].IBAN_NO = get_action_detail.IBAN_NO[i];
		sepet.satir[i].PAPER_NUMBER = get_action_detail.PAPER_NO[i];
		sepet.satir[i].ACTION_VALUE = get_action_detail.ACTION_VALUE[i] - get_action_detail.MASRAF[i];
		sepet.satir[i].ACTION_VALUE_OTHER = get_action_detail.ACTION_VALUE_OTHER[i];
		sepet.satir[i].ACTION_DETAIL = get_action_detail.ACTION_DETAIL[i];
		sepet.satir[i].PROJECT_HEAD = get_action_detail.PROJECT_HEAD[i];
		sepet.satir[i].ASSET_ID = get_action_detail.ASSETP_ID[i];
		sepet.satir[i].ASSET_NAME = get_action_detail.ASSETP[i];
		sepet.satir[i].SUBSCRIPTION_ID = get_action_detail.SUBSCRIPTION_ID[i];
		sepet.satir[i].SUBSCRIPTION_NO = get_action_detail.SUBSCRIPTION_NO[i];
		sepet.satir[i].EXPENSE_AMOUNT = get_action_detail.MASRAF[i];
		sepet.satir[i].ACTION_CURRENCY = get_action_detail.ACTION_CURRENCY[i];
		sepet.satir[i].ROW_EXP_CENTER_ID = get_action_detail.EXPENSE_CENTER_ID[i];
		sepet.satir[i].ROW_EXP_CENTER_NAME = get_action_detail.EXPENSE[i];
		sepet.satir[i].ROW_EXP_ITEM_ID = get_action_detail.EXPENSE_ITEM_ID[i];
		sepet.satir[i].ROW_EXP_ITEM_NAME = get_action_detail.EXPENSE_ITEM_NAME[i];
		sepet.satir[i].AVANS_ID = get_action_detail.AVANS_ID[i];
		sepet.satir[i].DETAIL = get_action_detail.ACTION_DETAIL[i];
		sepet.satir[i].PROJECT_ID = get_action_detail.PROJECT_ID[i];
		sepet.satir[i].ACTION_ID = get_action_detail.ACTION_ID[i];
		sepet.satir[i].ACTION_CURRENCY2 = get_action_detail.ACTION_CURRENCY2[i];
		sepet.satir[i].SPECIAL_DEFINITION_ID = get_action_detail.SPECIAL_DEFINITION_ID[i];
		sepet.satir[i].SYSTEM_AMOUNT = get_action_detail.SYSTEM_ACTION_VALUE[i];
		sepet.satir[i].ROW_KONTROL = 1;
		sepet.satir[i].ACT_ROW_ID = get_action_detail.ACTION_ID[i];
	}
	
</cfscript>
<cfif paper_type neq 3>
	<cfquery name="get_row_multi_paper" datasource="#dsn3#">
		SELECT * FROM GENERAL_PAPERS WHERE PAPER_TYPE IS NULL
	</cfquery>
<cfelse>
	<cfquery name="get_row_multi_paper" datasource="#dsn3#">
		SELECT * FROM PAPERS_NO WHERE EMPLOYEE_ID = #session.ep.userid# ORDER BY PAPER_ID DESC
	</cfquery>
</cfif>
<cfif get_row_multi_paper.recordcount and len(evaluate('get_row_multi_paper.#auto_paper_type#_NUMBER'))>
		<cfset paper_code = evaluate('get_row_multi_paper.#auto_paper_type#_NO')>
		<cfset paper_number = evaluate('get_row_multi_paper.#auto_paper_type#_NUMBER') +1>
	<cfelse>
		<cfset paper_code = "">
		<cfset paper_number = "">
	</cfif>
<cfloop index="aaa" from="1" to="#arrayLen(sepet.satir)#">
<cfset sepet.satir[aaa].MONEY_ID = ''>
<cfset sepet.satir[aaa].SPECIAL_DEFINATION = ''>

	<cfset money_list = ''>
	<cfset special_defination_list = ''>
	
	<cfoutput query="get_money">
		<cfset money_list = listappend(money_list,'#money#;#rate1#;#rate2#')>
	</cfoutput>
	<cfoutput query="get_special_definition">
		<cfset special_defination_list = listappend(special_defination_list,'#special_definition_id#;#special_definition#')>
	</cfoutput>


	<cfif len(sepet.satir[aaa].ACTION_CURRENCY2)>
		<cfset sepet.satir[aaa].MONEY_ID_EXTRA = '<option value="">#getLang("main",322)#</option>'>
	<cfelse>
		<cfset sepet.satir[aaa].MONEY_ID_EXTRA = '<option value="" selected="selected">#getLang("main",322)#</option>'>
	</cfif>
	
	<cfif len(sepet.satir[aaa].SPECIAL_DEFINITION_ID)>
		<cfset sepet.satir[aaa].SPECIAL_DEFINATION = '<option value="">#getLang("main",322)#</option>'>
	<cfelse>
		<cfset sepet.satir[aaa].SPECIAL_DEFINATION = '<option value="" selected="selected">#getLang("main",322)#</option>'>
	</cfif>
	
	<cfloop list="#money_list#" index="info_list">
		<cfif StructKeyExists(sepet.satir[aaa],'ACTION_CURRENCY') and listfirst(info_list,';') eq sepet.satir[aaa].ACTION_CURRENCY>
			<cfset selected_ = 'selected="selected"'>
		<cfelse>
			<cfset selected_ = ''>
		</cfif>
		<!---<cfset sepet.satir[aaa].MONEY_ID = sepet.satir[aaa].MONEY_ID>--->
		<cfset sepet.satir[aaa].MONEY_ID_EXTRA = sepet.satir[aaa].MONEY_ID_EXTRA & "<option value='#info_list#' #selected_#>#listfirst(info_list,';')#</option>">
	</cfloop>
	<cfset sepet.satir[aaa].MONEY_ID = sepet.satir[aaa].ACTION_CURRENCY>
	
	<cfloop list="#special_defination_list#" index="special_list">
		<cfif StructKeyExists(sepet.satir[aaa],'SPECIAL_DEFINITION_ID') and sepet.satir[aaa].SPECIAL_DEFINITION_ID eq listfirst(special_list,';')>
			<cfset selected_ = 'selected="selected"'>
		<cfelse>
			<cfset selected_ = ''>
		</cfif>
		<cfset sepet.satir[aaa].SPECIAL_DEFINATION = sepet.satir[aaa].SPECIAL_DEFINATION & "<option value='#listfirst(special_list,';')#' #selected_#>#listlast(special_list,';')#</option>">
	</cfloop>
</cfloop>
<cfset basketCollected = serializeJSON(sepet.satir)>
<cfif left(basketCollected, 2) is "//"><cfset basketCollected = mid(basketCollected, 3, len(basketCollected) - 2)></cfif>
<cfset basketCollected = URLEncodedFormat(basketCollected, "utf-8")>
<cfset pageHead = getLang('main',1750)& ' : '& get_action_detail.multi_action_id><!--- Toplu Gelen Havale --->
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="add_process" method="post" action="#request.self#?fuseaction=objects.emptypopup_basket_converter">
			<div id="basket_main_div">
				<cf_basket_form id="collacted_gelenh">
					<input name="record_num" id="record_num" type="hidden" value="">
					<input type="hidden" name="paperNumber" id="paperNumber" value="<cfoutput>#paper_number#</cfoutput>" />
					<input type="hidden" id="form_action_address" name="form_action_address" value="<cfoutput>bank.emptypopup_upd_collacted_gelenh</cfoutput>" />
					<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
					<input type="hidden" name="multi_id" id="multi_id" value="<cfoutput>#get_action_detail.multi_action_id#</cfoutput>">
					<input type="hidden" name="pageDelEvent" id="pageDelEvent" value="delMulti" />
					<cf_box_elements>
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
							<div class="form-group" id="item-action_date">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'>*</label>
								<div class="col col-8 col-xs-12">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfsavecontent>
									<div class="input-group">
										<cfinput type="text" name="action_date"  value="#dateformat(get_action_detail.action_date,dateformat_style)#" validate="#validate_style#" required="Yes" message="#message#" onblur="change_money_info('add_process','action_date');">
										<span class="input-group-addon"><cf_wrk_date_image date_field="action_date" call_function="change_money_info" function_currency_type="#xml_money_type#"></span>
									</div>                                	
								</div>
							</div>
							<div class="form-group" id="item-process_cat">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.işlem tipi'>*</label>
								<div class="col col-8 col-xs-12">
									<cf_workcube_process_cat process_cat="#get_action_detail.process_cat#">                               	
								</div>
							</div>
							<div class="form-group" id="item-to_account_id">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48706.Banka/Hesap'>*</label>
								<div class="col col-8 col-xs-12">
									<cf_wrkBankAccounts call_function='kur_ekle_f_hesapla' selected_value='#get_action_detail.to_account_id#' is_upd='1'>
								</div>
							</div>
						</div>
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
							<cfif session.ep.isBranchAuthorization eq 0>
								<div class="form-group" id="item-to_branch_id">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57453.Şube'></label>
									<div class="col col-8 col-xs-12">
										<cf_wrkDepartmentBranch fieldId='branch_id' is_branch='1' selected_value='#get_action_detail.to_branch_id#'>
									</div>
								</div>
							</cfif>
							<div class="form-group" id="item-acc_department_id">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
								<div class="col col-8 col-xs-12">
									<cf_wrkDepartmentBranch fieldId='acc_department_id' is_department='1' selected_value='#get_action_detail.department_id#'>
								</div>
							</div>
						</div>
					</cf_box_elements>
					<cf_box_footer>
						<div class="col col-6 col-xs-12">
							<cf_record_info query_name='get_action_detail'>
						</div>
						<div class="col col-6 col-xs-12">
							<cfif not(session.ep.our_company_info.is_paper_closer eq 1 and isdefined("get_closed") and get_closed.recordcount neq 0)>
								<cf_workcube_buttons
									is_upd='1'
									add_function='control_form()'
									update_status='#get_action_detail.upd_status#'
									del_function_for_submit='control_del_form()'
									delete_page_url='#request.self#?fuseaction=bank.form_add_gelenh&event=delMulti&multi_id=#attributes.multi_id#&old_process_type=#get_action_detail.action_type_id#&active_period=#session.ep.period_id#'>
							</cfif>
							<cfif (session.ep.our_company_info.is_paper_closer eq 1 and isdefined("get_closed") and get_closed.recordcount neq 0)>
								<table style="text-align:right;">
									<tr>
										<td style="text-align:right;">
											<cfif get_closed.is_closed eq 1>
												<font color="##FF0000"><cf_get_lang dictionary_id="52412.Fatura Kapama İşlemi Yapıldığı İçin Belge Güncellenemez">.</font>
											<cfelseif get_closed.is_demand eq 1>
												<font color="##FF0000"><cf_get_lang dictionary_id="52504.Ödeme Talebi İşlemi Yapıldığı İçin Belge Güncellenemez">.</font>
											<cfelseif get_closed.is_order eq 1>
												<font color="##FF0000"><cf_get_lang dictionary_id="52519.Ödeme Emri İşlemi Yapıldığı İçin Belge Güncellenemez">.</font>
											</cfif>
										</td>
									</tr>
								</table>	
							</cfif>
						</div>
					</cf_box_footer>
				<cf_basket id="collacted_gelenh_bask">
					<cf_grid_list id="add_period" name="add_period">
						<thead id="tblBasket" class="basket_list" cellpadding="0" cellspacing="0" style="table-layout:fixed; width:99%; height:99%;">
							<tr>
								<th width="25"></th>
								<th style="text-align:center;" width="35"><a href="javascript://" onClick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='57582.Ekle'>"></i></a></th>
								<th><cf_get_lang dictionary_id='57519.Cari Hesap'>*</th>
								<th><cf_get_lang dictionary_id='54332.IBAN No'></th>
								<th><cf_get_lang dictionary_id='57880.Belge No'>*</th>
								<th><cf_get_lang dictionary_id='57673.Tutar'>*</th>
								<th><cf_get_lang dictionary_id='57489.Para Birimi'>*</th>
								<th><cf_get_lang dictionary_id='58056.Dövizli Tutar'>*</th>
								<th><cf_get_lang dictionary_id='57489.Para Birimi'>*</th>
								<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
								<th><cf_get_lang dictionary_id='57416.Proje'><cfif isdefined("x_required_project") and x_required_project eq 1>*</cfif></th>
								<th><cf_get_lang dictionary_id ='29502.Abone No'></th>
								<cfif session.ep.our_company_info.asset_followup eq 1>
									<th><cf_get_lang dictionary_id ='58833.Fiziki Varlık'></th>
								</cfif>
								<cfif isDefined("x_select_type_info") and x_select_type_info neq 0><th><cf_get_lang dictionary_id='58929.Tahsilat Tipi'><cfif x_select_type_info eq 2>*</cfif></th></cfif>
								<th><cf_get_lang dictionary_id='58930.Masraf'></th>
								<th><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th>
								<th><cf_get_lang dictionary_id='58551.Gider Kalemi'></th>
							</tr>
						</thead>
						<tbody id="basketItemBase" style="display:none;">
							<tr ItemRow>
								<td style="text-align:center;"><span id="rowNr">1</span></td>
								<td>
									<input type="hidden" name="row_kontrol" id="row_kontrol" value="">
									<input type="hidden" name="act_row_id" id="act_row_id" value=""><!--- belge kapama işlemlernde sıkıntı oluşturgu için satırlar update edilecek --->
									<cfif (isdefined("attributes.collacted_havale_list") and len(attributes.collacted_havale_list)) or (isdefined("get_action_detail.bank_order_id") and len(get_action_detail.bank_order_id))>
										<cfquery name="get_bank_order_type" datasource="#dsn2#">
											SELECT BANK_ORDER_TYPE_ID FROM BANK_ORDERS WHERE BANK_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_action_detail.bank_order_id#"> 
										</cfquery>
										<input type="hidden" name="bank_order_process_cat" id="bank_order_process_cat" value="#get_bank_order_type.bank_order_type_id#"> <!--- Gelen Banka Talimatı process type --->
										<input type="hidden" name="bank_order_id" id="bank_order_id" value="#get_action_detail.bank_order_id#">	
									</cfif>
									<ul class="ui-icon-list">
										<li><a href="javascript://" id="btnDelete"><i class="fa fa-minus"></i></a></li>
										<li><a href="javascript://" id="copy_basket_row_id" onclick="copy_row('#currentrow#');" title="<cf_get_lang dictionary_id='58972.Satır Kopyala'>"><i class="fa fa-copy"></i></a></li>
									</ul>
								</td>
								<td>
									<input type="hidden" name="related_action_id" id="related_action_id" value="">
									<input type="hidden" name="related_action_type" id="related_action_type" value="">
									<input type="hidden" name="avans_id" id="avans_id" value="">
									<input type="hidden" name="member_code" id="member_code" value="">
									<input type="hidden" name="member_type" id="member_type" value="">
									<input type="hidden" name="action_employee_id" id="action_employee_id" value="">
									<input type="hidden" name="action_company_id" id="action_company_id" value="">
									<input type="hidden" name="action_consumer_id" id="action_consumer_id" value="">
									<div class="form-group">
										<div class="input-group medium">
											<input type="text" name="comp_name" id="comp_name"  value="">
										</div>
									</div>
								</td>
								<td>
									<div class="form-group medium">
										<input type="text" name="iban_no" id="iban_no" value="">
									</div>
								</td>
								<cfif isdefined("is_copy")>
									<td><div class="form-group"><input type="text" id="paper_number" name="paper_number" readonly="readonly" value=""></div></td>
									<cfif len(paper_number)>
										<cfset paper_number = paper_number + 1>
									</cfif>
								<cfelse>
									<td><div class="form-group"><input type="text" id="paper_number" name="paper_number" readonly="readonly" value=""></td>
								</cfif>	
								<td nowrap="nowrap"><div class="form-group"><input type="hidden" name="system_amount" id="system_amount" value="0">
								<input type="text" name="action_value" id="action_value" value="" onkeyup="return(FormatCurrency(this,event));" maxlength="20" class="moneybox"></div>
								</td>
								<td nowrap="nowrap">
									<div class="form-group small"><input type="text" name="tl_value" id="tl_value" value="" readonly="readonly"></div>
								</td>
								<td nowrap="nowrap"><div class="form-group small"><input type="text" name="action_value_other" id="action_value_other" value="" maxlength="20" onkeyup="return(FormatCurrency(this,event));" class="moneybox" ></td></div>
								<td><div class="form-group small"><select name="money_id" id="money_id"></select></div></td>
								<td><div class="form-group"><input type="text" name="action_detail" id="action_detail" value=""></div></td>
								<td nowrap>
									<div class="form-group">
										<div class="input-group">
											<input name="project_id" id="project_id" type="hidden" value="" class="boxtext">
											<input name="project_head" id="project_head" value="" class="boxtext">
										</div>
									</div>
								</td>
								<td>
									<div class="form-group">
										<div class="input-group">
											<input type="hidden" name="subscription_id" id="subscription_id" />
											<input type="text" name="subscription_no" id="subscription_no" class="boxtext" />		
										</div>
									</div>
								</td>
								<cfif session.ep.our_company_info.asset_followup eq 1>
									<td>
										<div class="form-group">
											<div class="input-group">
												<input name="asset_id" id="asset_id" type="hidden" value="" class="boxtext">
												<input id="asset_name" name="asset_name"  value="" class="boxtext">
											</div>
										</div>
									</td>
								</cfif>
								<cfif isDefined("x_select_type_info") and x_select_type_info neq 0><td><div class="form-group medium"><select name="special_definition_id" id="special_definition_id"></select></div></td></cfif>
								<td  nowrap="nowrap">
									<div class="form-group"><input type="text" name="expense_amount" id="expense_amount" value="" onkeyup="return(FormatCurrency(this,event));" maxlength="20" class="moneybox"></div>
								</td>
								<td>
									<div class="form-group">
										<div class="input-group medium">
											<input type="hidden" name="expense_center_id" id="expense_center_id" value="" >
											<input type="text"  name="expense_center_name" id="expense_center_name" onFocus="exp_center(#currentrow#,1);" value="">
										</div>
									</div>
								</td>
								<td>
									<div class="form-group">
										<div class="input-group medium">
											<input type="hidden" name="expense_item_id" id="expense_item_id" value="">
											<input type="text" name="expense_item_name" id="expense_item_name" value="">
										</div>
									</div>
								</td>
							</tr>
						</tbody>
					</cf_grid_list>
					<div class="ui-pagination basket_row_count">
						<div class="pagi-left basket_row_button">
							<ul>
								<li class="pagesButtonPassive"><a href="javascript://" name="btnPrevLast" id="btnPrevLast" value=""><i class="fa fa-angle-double-left"></i></a></li>
								<li class="pagesButtonPassive"><a href="javascript://" name="btnPrev" id="btnPrev" value=""><i class="fa fa-angle-left"></i></a></li>
								<li><input type="text" id="pageInf" name="pageInf" value=""  style="width:25px;" onBlur="goPage();"/></li>
								<li class="pagesButtonActive"><a href="javascript://" name="btnNext" id="btnNext" value=""><i class="fa fa-angle-right"></i></a></li>
								<li><a href="javascript://" name="btnNextLast" id="btnNextLast" value=""><i class="fa fa-angle-double-right"></i></a></li>
								
							</ul>
						</div>
						<div class="rowCountText">
							<span class="txtbold"><b><cf_get_lang dictionary_id="44423.Satır Sayısı"></b>: </span><span id="itemCount" class="txtbold">0</span>
							<span class="txtbold"><b><cf_get_lang dictionary_id="57581.Sayfa"></b>: </span><span id="itemPageCount" class="txtbold">0</span>
						</div>
					</div> 
					<div basket_footer style="width:100%;" align="left">
						<div class="ui-row">
							<div id="sepetim_total" class="padding-0">
								<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
									<div class="totalBox">
										<div class="totalBoxHead font-grey-mint">
											<span class="headText"> <cf_get_lang dictionary_id='57677.Döviz'> </span>
											<div class="collapse">
												<span class="icon-minus"></span>
											</div>
										</div>
										<div class="totalBoxBody">
											<table cellspacing="0" id="money_rate_table">
												<cfoutput>
													<input id="kur_say" type="hidden" name="kur_say" value="#get_money.recordcount#">
													<cfloop query="get_money">
														<cfif isdefined("xml_money_type") and xml_money_type eq 0>
															<cfset currency_rate_ = RATE2>
														<cfelseif isdefined("xml_money_type") and xml_money_type eq 1>
															<cfset currency_rate_ = RATE3>
														<cfelseif isdefined("xml_money_type") and xml_money_type eq 2>
															<cfset currency_rate_ = RATE2>
														</cfif>	                
														<cfif is_selected eq 1><cfset str_money_bskt_main = money></cfif>
															<tr>
															<td>
																<cfif session.ep.rate_valid eq 1>
																	<cfset readonly_info = "yes">
																<cfelse>
																	<cfset readonly_info = "no">
																</cfif>
																<input type="hidden" name="hidden_rd_money_#currentrow#" value="#money#" id="hidden_rd_money_#currentrow#">
																<input type="hidden" name="txt_rate1_#currentrow#" value="#rate1#" id="txt_rate1_#currentrow#">
																<input type="radio" name="rd_money" id="rd_money" value="#money#,#currentrow#,#rate1#,#rate2#" onClick="toplam_hesapla();" <cfif str_money_bskt_main eq money>checked</cfif>>#money#
															</td>
															<td valign="bottom">#TLFormat(rate1,0)#/<input type="text" class="box" id="txt_rate2_#currentrow#" <cfif readonly_info>readonly</cfif> name="txt_rate2_#currentrow#" <cfif money eq session.ep.money>readonly="yes"</cfif> value="#TLFormat(rate2,rate_round_num_info)#" style="width:65px;" onKeyUp="return(FormatCurrency(this,event,'#rate_round_num_info#'));" onBlur="if(filterNum(this.value,'#rate_round_num_info#') <=0) this.value=commaSplit(1);kur_ekle_f_hesapla('#select_input#',false);"></td>
															</tr>
													</cfloop>
												</cfoutput>                   	
											</table>
										</div>
									</div>
								</div>
								<div class="col col-5 col-md-5 col-sm-5 col-xs-12">
									<div class="totalBox">
										<div class="totalBoxHead font-grey-mint">
											<span class="headText"> <cf_get_lang dictionary_id='57492.Toplam'> </span>
											<div class="collapse">
												<span class="icon-minus"></span>
											</div>
										</div>
										<div class="totalBoxBody"> 
											<table>
												<tr>
													<td style="text-align:right;">
														<input type="text" name="total_amount" class="box" readonly value="0" id="total_amount">&nbsp;
														<input type="text" name="tl_value1" id="tl_value1" class="box" readonly="readonly" value="<cfoutput>#session.ep.money#</cfoutput>" style="width:40px;">
													</td>
												</tr>
											</table>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</cf_basket>
				
			</cf_basket_form>
			</div>
		</cfform>
	</cf_box>
</div>
<script>
	var datapage = 1;
	$(document).ready(function(){
		$("#btnNext,#btnNextLast, #btnPrev, #btnPrevLast").bind("click", showBasketItems);
		$("#pageInf").val(datapage);
		$("paperNumber").val();
		init();
		showBasketItems();
	});
	
		function init()
		{
			window.basket = {
				header: {},
				footer : {
							row_kontrol : <cfoutput>1</cfoutput>,
							kur_say : <cfoutput>#get_money.recordcount#</cfoutput>
						},
				items: $.evalJSON(decodeURIComponent("<cfoutput>#basketCollected#</cfoutput>")),
				scrollIndex: 0,
				pageSize: <cfoutput>#session.ep.maxrows#</cfoutput>
			}
			window.basket.items.rows_ = window.basket.items.length
				
		}
	
		
	
	function showBasketItems(e)
	{
		
		if(window.basket.scrollIndex == Math.min(window.basket.items.length, window.basket.scrollIndex + window.basket.pageSize))
			deletedPage = 1;
		else
			deletedPage = 0;
		
		if (e != null && $(e.currentTarget).attr("id") == "btnNext") 
		{
			window.basket.scrollIndex = parseFloat($("#basket_main_div #pageInf").val())*window.basket.pageSize;
			$("#basket_main_div #pageInf").val(parseFloat($("#basket_main_div #pageInf").val())+1);
			datapage++;
			$("#pageInf").val(datapage);
		}
		if ((e != null && $(e.currentTarget).attr("id") == "btnPrev") || deletedPage == 1) 
		{
			window.basket.scrollIndex = Math.max(0, window.basket.scrollIndex - window.basket.pageSize);
			$("#basket_main_div #pageInf").val(parseFloat($("#basket_main_div #pageInf").val())-1);
			datapage--;
			$("#pageInf").val(datapage);
		}
		if (e != null && $(e.currentTarget).attr("id") == "btnPrevLast")
		{ 
			window.basket.scrollIndex = 0;
			$("#basket_main_div #pageInf").val(Math.floor(1));
			datapage = Math.ceil(1);
			$("#pageInf").val(datapage);
		}
			if (e != null && $(e.currentTarget).attr("id") == "btnNextLast")
		{
			if(window.basket.items.length % window.basket.pageSize == 0)
			{
				window.basket.scrollIndex = (Math.floor(window.basket.items.length / window.basket.pageSize)-1) * window.basket.pageSize;
				$("#basket_main_div #pageInf").val(Math.floor(window.basket.items.length / window.basket.pageSize));
			}
			else
			{
				window.basket.scrollIndex = (Math.floor(window.basket.items.length / window.basket.pageSize)) * window.basket.pageSize;
				$("#basket_main_div #pageInf").val(Math.floor(window.basket.items.length / window.basket.pageSize)+1);
			}
		}
		
		if((window.basket.scrollIndex+window.basket.pageSize) >= window.basket.items.length)
			$("#btnNext, #btnLast").attr('disabled', 'disabled');
		else
			$("#btnNext, #btnLast").removeAttr("disabled");
			
		if(window.basket.scrollIndex == 0)
			$("#btnPrev, #btnPrevLast").attr('disabled', 'disabled');
		else
			$("#btnPrev, #btnPrevLast").removeAttr("disabled");
		
		$("#tblBasket tr[ItemRow]").remove();
		document.getElementById('record_num').value = window.basket.items.length ;
		
		for (var i = window.basket.scrollIndex; i < Math.min(window.basket.items.length, window.basket.scrollIndex + window.basket.pageSize); i++)
			{
				
				$("#tblBasket").append($("#basketItemBase").html());
				var item = $("#tblBasket tr[ItemRow]").last();
				var data = window.basket.items[i];
				$(item).find("#rowNr").text(i + 1);
				$(item).attr("itemIndex", i);
				fillArrayField('row_kontrol',data['ROW_KONTROL'],data['ROW_KONTROL'],i);
				fillArrayField('act_row_id',data['ACTION_ID'],data['ACTION_ID'],i);
				fillArrayField('comp_name',data['COMP_NAME'],data['COMP_NAME'],i);
				fillArrayField('member_code',data['MEMBER_CODE'],data['MEMBER_CODE'],i);
				fillArrayField('avans_id',data['AVANS_ID'],data['AVANS_ID'],i);
				if(data['ACTION_EMPLOYEE_ID'] != null){
					fillArrayField('action_employee_id',data['ACTION_EMPLOYEE_ID'],data['ACTION_EMPLOYEE_ID'],i);
					fillArrayField('member_type','employee','employee',i);
				}
				if(data['ACTION_COMPANY_ID'] != null){
					fillArrayField('action_company_id',data['ACTION_COMPANY_ID'],data['ACTION_COMPANY_ID'],i);
					fillArrayField('member_type','partner','partner',i);
				}
				if(data['ACTION_CONSUMER_ID'] != null){
					fillArrayField('action_consumer_id',data['ACTION_CONSUMER_ID'],data['ACTION_CONSUMER_ID'],i);
					fillArrayField('member_type','consumer','consumer',i);
				}
				$(item).find("#comp_name").after('<span class="input-group-addon icon-ellipsis" onclick="pencere_ac_company('+i+')"></span>');
				fillArrayField('iban_no',data['IBAN_NO'],data['IBAN_NO'],i);
				fillArrayField('paper_number',data['PAPER_NUMBER'],data['PAPER_NUMBER'],i);
				fillArrayField('system_amount',data['SYSTEM_ACTION_VALUE'],data['SYSTEM_ACTION_VALUE'],i);
				fillArrayField('tl_value',data['ACTION_CURRENCY2'],data['ACTION_CURRENCY2'],i);
				document.getElementById('tl_value1').value=data['ACTION_CURRENCY2'];
				fillArrayField('action_value_other',parseFloat(data['ACTION_VALUE_OTHER']),commaSplit(data['ACTION_VALUE_OTHER'],2),i);
				fillArrayField('action_detail',data['DETAIL'],data['DETAIL'],i);
				fillArrayField('action_detail',data['ACTION_DETAIL'],data['ACTION_DETAIL'],i);
				fillArrayField('action_value',parseFloat(data['ACTION_VALUE']),commaSplit(data['ACTION_VALUE'],2),i);
				fillArrayField('project_id',data['PROJECT_ID'],data['PROJECT_ID'],i);
				fillArrayField('project_head',data['PROJECT_HEAD'],data['PROJECT_HEAD'],i);
				$(item).find("#project_head").after('<span class="input-group-addon icon-ellipsis" onclick="open_basket_project_popup('+i+')"></span>');
				fillArrayField('subscription_id',data['SUBSCRIPTION_ID'],data['SUBSCRIPTION_ID'],i);
				fillArrayField('subscription_no',data['SUBSCRIPTION_NO'],data['SUBSCRIPTION_NO'],i);
				$(item).find("#subscription_no").after('<span class="input-group-addon icon-ellipsis" onclick="open_basket_subscription_popup('+i+')"></span>');
				fillArrayField('asset_id',data['ASSET_ID'],data['ASSET_ID'],i);
				fillArrayField('asset_name',data['ASSET_NAME'],data['ASSET_NAME'],i);
				$(item).find("#asset_name").after('<span class="input-group-addon icon-ellipsis" onclick="pencere_ac_asset('+i+')"></span>');
				if(data['EXPENSE_AMOUNT']!=null && data['EXPENSE_AMOUNT']!='')
					fillArrayField('expense_amount',data['EXPENSE_AMOUNT'],commaSplit(data['EXPENSE_AMOUNT'],2),i);
				else
					fillArrayField('expense_amount',commaSplit(parseFloat(0),2),commaSplit(parseFloat(0),2),i);
				fillArrayField('expense_center_id',data['ROW_EXP_CENTER_ID'],data['ROW_EXP_CENTER_ID'],i);
				fillArrayField('expense_center_name',data['ROW_EXP_CENTER_NAME'],data['ROW_EXP_CENTER_NAME'],i);
				$(item).find("#expense_center_name").after('<span class="input-group-addon icon-ellipsis" onclick="pencere_ac_exp('+i+')"></span>');
				fillArrayField('expense_item_id',data['ROW_EXP_ITEM_ID'],data['ROW_EXP_ITEM_ID'],i);
				fillArrayField('expense_item_name',data['ROW_EXP_ITEM_NAME'],data['ROW_EXP_ITEM_NAME'],i);
				$(item).find("#expense_item_name").after('<span class="input-group-addon icon-ellipsis" onclick="pencere_ac_exp2('+i+')"></span>');
				if (data.MONEY_ID_EXTRA != null) 
				{
					$(item).find("#money_id").html(data.MONEY_ID_EXTRA);
					fillArrayField('money_id',data['ACTION_CURRENCY'],data['ACTION_CURRENCY'],i,2);		
					//console.log(data);
				}
				
				if (data.SPECIAL_DEFINATION != null) 
					$(item).find("#special_definition_id").html(data.SPECIAL_DEFINATION);
				
				if(data['ROW_KONTROL'] == 0)
				{
					$("#tblBasket tr[ItemRow]").eq(i).css('display','none');
				}
				
				$(item).find("#action_value").bind("blur", formatField);
				$(item).find("#expense_amount").bind("blur", formatField1);
				$(item).find("#iban_no").bind("blur", formatField1);
				$(item).find("#paper_number").bind("blur", formatField1);
				$(item).find("#action_detail").bind("blur", formatField1);
				$(item).find("#special_definition_id").bind("change", formatField1);
				$(item).find("#action_value_other").bind("blur", formatField);
				$(item).find("#money_id").bind("change", formatField);
				$(item).find("#rd_money").bind("click", formatField);
				$(item).find("#btnDelete").bind("click", deleteBasketItem);
				$(item).find("#copy_basket_row_id").attr("onclick",'copy_basket_row('+i+')');
				$(item).find("#comp_name").bind("blur", formatField1);
				$(item).find("#project_head").bind("blur", formatField1);
				$(item).find("#subscription_no").bind("blur", formatField1);
				$(item).find("#expense_center_name").bind("blur", formatField1);
				$(item).find("#expense_item_name").bind("blur", formatField1);
				
			}
		
		$("#itemCount").text(window.basket.items.length);

		if(window.basket.items.length % window.basket.pageSize == 0)
			$("#itemPageCount").text(Math.floor(window.basket.items.length / window.basket.pageSize));
		else
			$("#itemPageCount").text(Math.floor(window.basket.items.length / window.basket.pageSize)+1);

		if (window.basket.items.length > window.basket.pageSize)
		{
			$("#btnNext, #btnPrev, #btnNextLast, #btnPrevLast").show();
		} else {
			$("#btnNext, #btnPrev, #btnNextLast, #btnPrevLast").hide();
		}
		toplam_hesapla();
	}
	
function goPage()
{
	if(parseFloat($("#basket_main_div #pageNumber").val()) < 1)
		$("#basket_main_div #pageNumber").val(1);
	window.basket.scrollIndex = (parseFloat($("#basket_main_div #pageNumber").val()) * window.basket.pageSize) - window.basket.pageSize;
	if(window.basket.scrollIndex > window.basket.items.length)
		window.basket.scrollIndex = window.basket.items.length - window.basket.pageSize;
	else if(window.basket.scrollIndex + window.basket.pageSize == window.basket.items.length)
		$("#btnNext, #btnLast").attr('disabled', 'disabled');
	else
		$("#btnNext, #btnLast").removeAttr("disabled");
	showBasketItems();
}
	
function add_row()
{
	
	paperNumber = $("#paperNumber").val();
	paperNumber = parseInt(paperNumber);
	paper_number = '<cfoutput>#paper_code#-</cfoutput>'+paperNumber;
	$("#paperNumber").val(paperNumber+1);
	window.basket.items.push({
		
		ACTION_COMPANY_ID : '',
		ACTION_CONSUMER_ID : '',
		ACTION_EMPLOYEE_ID : '',
		COMP_NAME : '',
		IBAN_NO : '',
		AVANS_ID : '',
		ACTION_DETAIL : '',
		MEMBER_CODE:'',
		PROJECT_ID : '',
		MEMBER_TYPE: '',
		ASSET_ID : '',
		ASSET_NAME : '',
		ROW_KONTROL : 1,
		PAPER_NUMBER :paper_number,
		ACTION_VALUE : 0,
		ACTION_VALUE_OTHER : 0,
		ACTION_DETAIL : '',
		PROJECT_HEAD : '', 
		SUBSCRIPTION_ID : '',
		SUBSCRIPTION_NO : '',
		EXPENSE_CENTER_ID : '',
		EXPENSE : '',
		SYSTEM_ACTION_VALUE : 0,
		SYSTEM_AMOUNT: 0,
		ROW_EXP_ITEM_ID : '',
		ROW_EXP_ITEM_NAME : '',
		EXPENSE_AMOUNT : 0,
		ACTION_CURRENCY : '<cfoutput>#listFirst(listFirst(money_list,","),";")#</cfoutput>',
		ACTION_CURRENCY2 : '<cfoutput>#get_action_detail.action_currency2#</cfoutput>',
		MONEY_ID_EXTRA: "<cfoutput>'<cfloop list='#money_list#' index='info_list'>'<option value='#info_list#'>#listfirst(info_list,';')#</option></cfloop></cfoutput>",
		SPECIAL_DEFINITION_ID: '',
		SPECIAL_DEFINATION :"<cfoutput>'<option value=''>Seçiniz</option>'<cfloop query='get_special_definition'>SPECIAL_DEFINATION=SPECIAL_DEFINATION+'<option value='#SPECIAL_DEFINITION_ID#'>#SPECIAL_DEFINITION#</option>'</cfloop></cfoutput>"
	});
	showBasketItems(); 
	toplam_hesapla();
}
Number.prototype.format = function(n, x) {
	var re = '\\d(?=(\\d{' + (x || 3) + '})+' + (n > 0 ? '\\.' : '$') + ')';
	return this.toFixed(Math.max(0, ~~n)).replace(new RegExp(re, 'g'), '$&,');
};
	
	function formatField(e)
	{
			rowNumber = Number($(e.target).closest("tr[ItemRow]").attr("itemIndex"));
			fixedRowNumber = rowNumber - window.basket.scrollIndex ;
			//console.log(fixedRowNumber);
			newId = $(e.target).attr("id");
			switch ($(e.target).attr("id")){
				case "action_value":
				if($("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#action_value").val()=='' || $("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#action_value").val()== 0)
					{
						fillArrayField('action_value',parseFloat(0),commaSplit(parseFloat(0),2),rowNumber,1);
						fillArrayField('action_value_other',parseFloat(0),commaSplit(parseFloat(0),2),rowNumber,1);
						fillArrayField('system_amount',parseFloat(0),commaSplit(parseFloat(0),2),rowNumber,1);
						kur_ekle_f_hesapla('action_value',false,rowNumber);
					}
				else
				{
					fillArrayField('action_value',parseFloat(filterNum($("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#action_value").val())),commaSplit(parseFloat(filterNum($("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#action_value").val())),2),rowNumber,1);
					kur_ekle_f_hesapla('action_value',false,rowNumber);
					fillArrayField('action_value_other',parseFloat(filterNum($("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#action_value_other").val())),$("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#action_value_other").val(),rowNumber,1);
				}
				break;
				case "action_value_other":
				if($("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#action_value_other").val()=='' || $("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#action_value_other").val()== 0 || $("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#action_value_other").val()== commaSplit(parseFloat(0),2))
					{
						fillArrayField('action_value',parseFloat(0),commaSplit(parseFloat(0),2),rowNumber,1);
						fillArrayField('action_value_other',parseFloat(0),commaSplit(parseFloat(0),2),rowNumber,1);
						fillArrayField('system_amount',parseFloat(0),commaSplit(parseFloat(0),2),rowNumber,1);
						kur_hesapla2('action_value_other',rowNumber);
					}
				else
				{
					fillArrayField('action_value_other',parseFloat(filterNum($("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#action_value_other").val())),commaSplit(parseFloat(filterNum($("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#action_value_other").val())),2),rowNumber,1);
					kur_hesapla2('action_value_other',rowNumber);
					fillArrayField('action_value',parseFloat(filterNum($("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#action_value").val())),$("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#action_value").val(),rowNumber,1);
				}
				//fillArrayField('action_value',$("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#action_value").val(),111111..format(2),rowNumber,1);
				break;
				case "money_id":
				fillArrayField('money_id',$("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#money_id").find(":selected").val(),$("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#money_id").find(":selected").val(),rowNumber,1);
				fillArrayField('action_value',parseFloat(filterNum($("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#action_value").val())),$("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#action_value").val(),rowNumber,1);
				kur_ekle_f_hesapla('action_value',false,rowNumber);
				fillArrayField('action_value_other',parseFloat(filterNum($("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#action_value_other").val())),$("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#action_value_other").val(),rowNumber,1);
				data.MONEY_ID_EXTRA = data.MONEY_ID_EXTRA.replace(' selected="selected"','');
				data.MONEY_ID_EXTRA = data.MONEY_ID_EXTRA.replace(data.MONEY_ID+"'",data.MONEY_ID + "'" + ' selected="selected"');
				break;
				case "rd_money":
				toplam_hesapla();
					break;
				
			}
		//	console.log(data);
	}
	
	function formatField1(e)
	{
			
			rowNumber = Number($(e.target).closest("tr[ItemRow]").attr("itemIndex"));
			fixedRowNumber = rowNumber - window.basket.scrollIndex ;
			newId = $(e.target).attr("id");
			switch ($(e.target).attr("id")){
				
				case "action_detail":
				fillArrayField('action_detail',$("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#action_detail").val(),$("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#action_detail").val(),rowNumber,1);
				break;
				case "expense_amount":
				fillArrayField('expense_amount',parseFloat(filterNum($("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#expense_amount").val())),commaSplit(parseFloat(filterNum($("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#expense_amount").val())),2),rowNumber,1);
				if($("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#expense_amount").val() == '' || $("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#expense_amount").val()  == 0)
					fillArrayField('expense_amount',commaSplit(parseFloat(0),2),commaSplit(parseFloat(0),2),rowNumber);
				else
					fillArrayField('expense_amount',parseFloat(filterNum($("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#expense_amount").val())),commaSplit(parseFloat(filterNum($("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#expense_amount").val())),2),rowNumber,1);
				break;
				case "special_definition_id" :
				fillArrayField('special_definition_id',$("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#special_definition_id").find(":selected").val(),$("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#special_definition_id").find(":selected").val(),rowNumber,1);
				data.SPECIAL_DEFINATION = data.SPECIAL_DEFINATION.replace(' selected="selected"','');
				data.SPECIAL_DEFINATION = data.SPECIAL_DEFINATION.replace(data.SPECIAL_DEFINITION_ID+"'",data.SPECIAL_DEFINITION_ID + "'" + ' selected="selected"');
				break;
				case "comp_name":
				fillArrayField('comp_name',$("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#comp_name").val(),$("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#comp_name").val(),rowNumber,1);
				break;
				case "iban_no":
				fillArrayField('iban_no',$("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#iban_no").val(),$("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#iban_no").val(),rowNumber,1);
				break;
				case "project_head":
				fillArrayField('project_head',$("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#project_head").val(),$("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#project_head").val(),rowNumber,1);
				if(window.basket.items[rowNumber]['PROJECT_HEAD'] == null || window.basket.items[rowNumber]['PROJECT_HEAD']  == '')
				fillArrayField('project_id','','',rowNumber,1);
				break;
				case "subscription_no":
				fillArrayField('subscription_no',$("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#subscription_no").val(),$("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#subscription_no").val(),rowNumber,1);
				if(window.basket.items[rowNumber]['SUBSCRIPTION_NO'] == null || window.basket.items[rowNumber]['SUBSCRIPTION_NO']  == '')
				fillArrayField('subscription_id','','',rowNumber,1);
				break;
				case "expense_center_name":
				fillArrayField('expense_center_name',$("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#expense_center_name").val(),$("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#expense_center_name").val(),rowNumber,1);
				if(window.basket.items[rowNumber]['ROW_EXP_CENTER_NAME'] == null || window.basket.items[rowNumber]['ROW_EXP_CENTER_NAME'] == '')
				fillArrayField('expense_center_id','','',rowNumber,1);
				break;
				case "expense_item_name":
				fillArrayField('expense_item_name',$("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#expense_item_name").val(),$("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#expense_item_name").val(),rowNumber,1);
				if(window.basket.items[rowNumber]['ROW_EXP_ITEM_NAME']  == null || window.basket.items[rowNumber]['ROW_EXP_ITEM_NAME'] == '')
				fillArrayField('expense_item_id','','',rowNumber,1);
				break;
				
							
			}
	}
	function fillArrayField(fieldName,ArrayValue,FieldValue,rowNumber,notArray,extraFunction)  // Bu fonksiyon her seferinde array ve ekrandaki inputları tek tek doldurmamak için tek bir yere taşındı.
{
	
	if(fieldName == 'Tax')
		new_fieldName = 'tax_percent';
	else if(fieldName == 'OTV')
		new_fieldName = 'otv_oran';
	else
		new_fieldName = fieldName;
	
	data = window.basket.items[rowNumber];
	rowNumber -= window.basket.scrollIndex; 
	//Baskete yeni satır eklerken karma koli olma durumuna göre bazı durumlarda Amount alanı readonly olabiliyor yada hesaplayı tetikleyebilecek tarzda olabiliyor. Bu ayrımı yapmak için eklendi.
	if(extraFunction)
		$("#tblBasket tr[ItemRow]").eq(rowNumber).find("#"+fieldName).attr($.trim(ListFirst(extraFunction,'=')),$.trim(ListLast(extra_function,'=')));
	
	if(notArray == 1) // Hem array'i hem ekranı günceller.
	{
		arrayText = new_fieldName.toUpperCase();
		data[arrayText] = ArrayValue;
		$("#tblBasket tr[ItemRow]").eq(rowNumber).find("#"+fieldName).val(FieldValue);

	}
	else if(notArray == 2) // Sadece array'i günceller. Hesapla fonksiyonunda kullanılıyor. Hesapla işlemleri array üzerinden yazıldığı için ekrandan girilen değer array'i güncellemesi lazım.
	{
		arrayText = new_fieldName.toUpperCase();
		data[arrayText] = ArrayValue;
	}
	else
	{
		$("#tblBasket tr[ItemRow]").eq(rowNumber).find("#"+fieldName).val(FieldValue);
	}
	
}


function pencere_ac_company(satir)
	{
		var field_company_name_ = 'comp_name';
		var field_company_id_ ='action_company_id';
		var field_employee_id_ ='action_employee_id';
		var field_consumer_id_ ='action_consumer_id';
		var field_member_code_ ='member_code';
		var field_member_type_ ='member_type';
		windowopen('index.cfm?fuseaction=objects.popup_list_pars&is_multi_act=1&is_cari_action=1&select_list=1,2,3,9&field_comp_id=form.'+field_company_id_+'&field_member_name=form.'+field_company_name_+'&field_member_account_code=form.'+ field_member_code_ +'&field_type=from.' + field_member_type_ + '&field_name=form.' + field_company_name_ +'&field_emp_id=form.'+ field_employee_id_ +'&field_consumer=from.'+ field_consumer_id_ +'&satir='+satir,'list');
	}
	function open_basket_project_popup(satir)
	{
		var field_project_name_ = 'project_head';
		var field_project_id_='project_id';
		openBoxDraggable('index.cfm?fuseaction=objects.popup_list_projects&project_id=form.'+field_project_id_+'&project_head=form.'+field_project_name_+'&satir='+satir);
	}

function pencere_ac_asset(satir)
	{
		var field_asset_name_ = 'asset_name';
		var field_asset_id_ ='asset_id';
		windowopen('index.cfm?fuseaction=assetcare.popup_list_assetps&field_id=form.'+field_asset_id_+'&field_name=form.'+field_asset_name_+'&event_id=0&motorized_vehicle=0&satir='+satir,'list');
	}
function pencere_ac_exp(satir)
	{
		var field_project_name_ = 'expense_center_name';
		var field_project_id_ ='expense_center_id';
		windowopen('index.cfm?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=form.' + field_project_id_ +'&field_name=form.' + field_project_name_+'&satir='+satir,'list');
	}
function open_basket_subscription_popup(satir){
		var field_name_ = 'subscription_no';
		var field_id_='subscription_id';
		windowopen('index.cfm?fuseaction=objects.popup_list_subscription&&field_id=form.'+field_id_+'&field_no=form.'+field_name_+'&satir='+satir,'list');
}
function pencere_ac_exp2(satir)
	{
		var field_project_name_ = 'expense_item_name';
		var field_project_id_ ='expense_item_id';
		windowopen('index.cfm?fuseaction=objects.popup_list_exp_item&field_id=form.' + field_project_id_ +'&field_name=form.' + field_project_name_+'&satir='+satir,'list');
	}
function deleteBasketItem(e,satir){
		var itemIndex = $(e.target).closest("#tblBasket tr[ItemRow]").attr("itemIndex");
		
		window.basket.items.splice(itemIndex, 1);
		
	
	
			showBasketItems();
			toplam_hesapla();
}
function copy_basket_row(from_row_no,act_row_id)
{
	
		var cloned = {};
		for (var prop in window.basket.items[from_row_no]) // Array'in ilgili elemanları döndürülüyor
		{
			if(prop != 'ACT_ROW_ID')
				cloned[prop] = window.basket.items[from_row_no][prop];
			
		}
		

		//Üst tarafta kopyalanan satır olduğu gibi kopyalandı. Alt tarafta ise bazı menuel değişecek alanları değiştiriyoruz.
		paperNumber = $("#paperNumber").val();
		paperNumber = parseInt(paperNumber);
		cloned.PAPER_NUMBER= '<cfoutput>#paper_code#-</cfoutput>'+paperNumber;
		paperNumber = paperNumber + 1;
		$("#paperNumber").val(paperNumber);
		window.basket.items.push(cloned);
	//	window.basket.items.splice(from_row_no+1,0,cloned); Araya ekleme için
		//window.basket.scrollIndex = Math.floor(window.basket.items.length / window.basket.pageSize);
		showBasketItems();
	
}
function control_del_form()
	{
		<cfif isdefined("is_update")>
			if(!control_account_process(<cfoutput>'#get_action_detail.multi_action_id#','#get_action_detail.action_type_id#'</cfoutput>)) return false;
		</cfif>
		return true;
	}
function kur_ekle_f_hesapla(select_input,doviz_tutar,satir)
	{
		//debugger;
		<cfif not isdefined("attributes.is_other_act")>
			if(satir != undefined)
			{
				if(window.basket.items[satir]['ACTION_VALUE'] == '' ||window.basket.items[satir]['ACTION_VALUE'] == null )
				{
					window.basket.items[satir]['ACTION_VALUE'] =0;
					fillArrayField('action_value',commaSplit(parseFloat(0),2),commaSplit(parseFloat(0),2),satir);
				}
		
				fixedRowNumber = rowNumber - window.basket.scrollIndex ;
				if(!doviz_tutar) doviz_tutar=false;
				var currency_type = eval($("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#"+select_input).find(":selected").val());
				
				if(document.getElementById('currency_id') != undefined)
				{	
					currency_type = document.getElementById('currency_id').value;
				}
				else
					currency_type = list_getat(currency_type,2,';');
				row_currency = list_getat($("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#money_id").find(":selected").val(),1,';');
				var other_money_value_eleman=window.basket.items[satir]['ACTION_VALUE_OTHER'];
				var temp_act,temp_base_act,rate1_eleman,rate2_eleman;
				if(doviz_tutar && ( other_money_value_eleman.value.length==0 || filterNum(other_money_value_eleman.value)==0) )
				{
					other_money_value_eleman.value = '';
					return false;
				}
				if(doviz_tutar == false && window.basket.items[satir]['ACTION_VALUE'] != "" && currency_type != "")
				{	
				
					for(var i=1;i<=add_process.kur_say.value;i++)
					{	
						rate1_eleman = parseFloat(filterNum(eval('add_process.txt_rate1_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>'));
						rate2_eleman = parseFloat(filterNum(eval('add_process.txt_rate2_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>'));
						
						if( eval('add_process.hidden_rd_money_'+i).value == currency_type)
						{
							
							temp_act=window.basket.items[satir]['ACTION_VALUE']*(rate2_eleman/rate1_eleman); 
							window.basket.items[satir]['SYSTEM_AMOUNT'] = temp_act;
							
						}
					}
					for(var i=1;i<=add_process.kur_say.value;i++)
					{
						rate1_eleman = parseFloat(filterNum(eval('add_process.txt_rate1_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>'));
						rate2_eleman = parseFloat(filterNum(eval('add_process.txt_rate2_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>'));
						if(eval('add_process.hidden_rd_money_'+i).value == row_currency)
						{
							fillArrayField('action_value_other',parseFloat(wrk_round(window.basket.items[satir]['SYSTEM_AMOUNT']*(rate1_eleman/rate2_eleman))),commaSplit(wrk_round(window.basket.items[satir]['SYSTEM_AMOUNT']*(rate1_eleman/rate2_eleman)),2),satir);
							window.basket.items[satir]['SYSTEM_AMOUNT'] = wrk_round(window.basket.items[satir]['SYSTEM_AMOUNT']);
						}
					}
				}
			}
			else
			{	
				if(!doviz_tutar) doviz_tutar=false;
				var currency_type = eval('add_process.'+select_input+'.options[add_process.'+select_input+'.selectedIndex]').value;	
				if(document.getElementById('currency_id') != undefined)
					currency_type = document.getElementById('currency_id').value;
				else
					currency_type = list_getat(currency_type,2,';');
				for(var kk=0;kk<window.basket.items.length;kk++)
				{  
					window.basket.items[kk]['ACTION_CURRENCY2']=currency_type;
					fillArrayField('tl_value',currency_type,currency_type,kk);
					document.getElementById('tl_value1').value=currency_type;
					var other_money_value_eleman=window.basket.items[kk]['ACTION_VALUE_OTHER'];
					var temp_act,temp_base_act,rate1_eleman,rate2_eleman;
					row_currency = list_getat(window.basket.items[kk]['MONEY_ID'],1,';');
					if(doviz_tutar && ( other_money_value_eleman.value.length==0 || filterNum(other_money_value_eleman.value)==0) )
					{
						other_money_value_eleman.value = '';
						return false;
					}
					
					if(doviz_tutar == false && window.basket.items[kk]['ACTION_VALUE'] != "" && currency_type != "")
					{	
						
						for(var i=1;i<=add_process.kur_say.value;i++)
						{	
							rate1_eleman = filterNum(eval('add_process.txt_rate1_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
							rate2_eleman = filterNum(eval('add_process.txt_rate2_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
							
							if( eval('add_process.hidden_rd_money_'+i).value == currency_type)
							{ 
								temp_act=parseFloat(window.basket.items[kk]['ACTION_VALUE'])*(rate2_eleman/rate1_eleman); 
								window.basket.items[kk]['SYSTEM_AMOUNT'] = temp_act;
								
							}
						}
						for(var i=1;i<=add_process.kur_say.value;i++)
						{
							rate1_eleman = filterNum(eval('add_process.txt_rate1_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
							rate2_eleman = filterNum(eval('add_process.txt_rate2_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
							
							if(eval('add_process.hidden_rd_money_'+i).value == row_currency)
							{ 
								fillArrayField('action_value_other',parseFloat(wrk_round(window.basket.items[kk]['SYSTEM_AMOUNT']*(rate1_eleman/rate2_eleman))),commaSplit(parseFloat(wrk_round(window.basket.items[kk]['SYSTEM_AMOUNT']*(rate1_eleman/rate2_eleman))),2),(kk),1);
								
								window.basket.items[kk]['SYSTEM_AMOUNT'] = parseFloat(wrk_round(window.basket.items[kk]['SYSTEM_AMOUNT']));
								
							}
						}
								
					}
				}
			}
			
			toplam_hesapla();
		</cfif>
			return true;
	}
	
	function kur_hesapla2(select_input,satir){ 
		
		if(window.basket.items[satir]['ACTION_VALUE_OTHER'] == '' ||window.basket.items[satir]['ACTION_VALUE_OTHER'] == null )
		{
			window.basket.items[satir]['ACTION_VALUE_OTHER'] =0;
			fillArrayField('action_value_other',0,0,satir);
		}
		
		fixedRowNumber = rowNumber - window.basket.scrollIndex ; 
		var currency_type = eval($("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#"+select_input).find(":selected").val());
		if(document.getElementById('currency_id') != undefined)
			currency_type = document.getElementById('currency_id').value;
		else
			currency_type = list_getat(currency_type,2,';');
		for(var kk=1;kk<=add_process.record_num.value;kk++)
		{
			row_currency = $("#tblBasket tr[ItemRow]").eq(fixedRowNumber).find("#money_id").find(":selected").val();
			for(var i=1;i<=add_process.kur_say.value;i++)
			{	
				rate1_eleman = filterNum(eval('add_process.txt_rate1_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
				rate2_1 = list_getat(row_currency,3,';');
				rate2_2 = parseFloat(filterNum(eval('add_process.txt_rate2_' + i).value,'<cfoutput>#rate_round_num_info#</cfoutput>'));
				
				if(eval('add_process.hidden_rd_money_'+i).value == currency_type)
				{  
					var aaa= wrk_round(parseFloat(window.basket.items[satir]['ACTION_VALUE_OTHER']*(rate2_1/rate2_2)));
					window.basket.items[satir]['ACTION_VALUE'] = wrk_round(parseFloat(aaa));
					fillArrayField('action_value',parseFloat(aaa),commaSplit(wrk_round(aaa),2),satir);
					temp_act=window.basket.items[satir]['ACTION_VALUE']*rate2_2/rate1_eleman;
					window.basket.items[satir]['SYSTEM_AMOUNT'] = temp_act;
				}
			}
		}
	toplam_hesapla();
	return true;
	}
	
	
	function toplam_hesapla()
	{
		rate2_value = 0;
		deger_diger_para = '<cfoutput>#session.ep.money#</cfoutput>';
		for (var t=1; t<=document.getElementById('kur_say').value; t++)
		{
			if(document.add_process.rd_money[t-1].checked == true)
			{
				for(k=1;k<=add_process.record_num.value;k++)
				{
					rate2_value = filterNum(eval("document.add_process.txt_rate2_"+t).value,'<cfoutput>#rate_round_num_info#</cfoutput>');
					deger_diger_para = list_getat(document.add_process.rd_money[t-1].value,1,',');
				}
			}
		}
		var total_amount = 0;
		for(j=1;j<=add_process.record_num.value;j++)
		{ 
			if(eval(window.basket.items[j-1]['ROW_KONTROL'])==1)
			{	
				total_amount += parseFloat(window.basket.items[j-1]['ACTION_VALUE']);
				<cfif isdefined("attributes.debt_claim")>
				fillArrayField('action_value_other',0,0,j);
				<cfelseif isdefined('get_action_detail')>
					var selected_ptype = document.add_process.process_cat.options[document.add_process.process_cat.selectedIndex].value;
					if (selected_ptype != '')
						eval('var proc_control = document.add_process.ct_process_type_'+selected_ptype+'.value');
					else
						var proc_control = '';
					if(proc_control != '' && (proc_control == 45 || proc_control == 46))
						fillArrayField('action_value_other',0,0,j);
					else
					{
						<cfif isdefined("attributes.is_other_act")>
							fillArrayField('action_value_other',0,0,j);
						</cfif>
					}
				</cfif>
				var selected_ptype = document.add_process.process_cat.options[document.add_process.process_cat.selectedIndex].value;
				if (selected_ptype != '')
					eval('var proc_control = document.add_process.ct_process_type_'+selected_ptype+'.value');
				else
					var proc_control = '';
				if(proc_control != '' && (proc_control == 45 || proc_control == 46))
					fillArrayField('action_value_other',0,0,j);
				else
				{
					<cfif isdefined("attributes.is_other_act")>
						fillArrayField('action_value_other',0,0,j);
					</cfif>
				}
			}
		}
		if(rate2_value==0)
			other_total_amount=0;
		else
			other_total_amount = total_amount/rate2_value;
		add_process.total_amount.value = commaSplit(total_amount);
		
	}
	
function updateBasketItemFromPopup(index, data){
			for (var prop in data){
				window.basket.items[index][prop] = data[prop];
				//console.log(data[prop]+'-'+prop);
			}
		//	console.log(data);
			if (data['ROW_SUBSCRIPTION_NAME'] != null) fillArrayField('subscription_no',data['ROW_SUBSCRIPTION_NAME'],data['ROW_SUBSCRIPTION_NAME'],index,1);
			if (data['ROW_SUBSCRIPTION_ID'] != null) fillArrayField('subscription_id',Number(data['ROW_SUBSCRIPTION_ID']),Number(data['ROW_SUBSCRIPTION_ID']),index,1);

			if (data['ROW_PROJECT_NAME'] != null) fillArrayField('project_head',data['ROW_PROJECT_NAME'],data['ROW_PROJECT_NAME'],index,1);
			if (data['ROW_PROJECT_ID'] != null) fillArrayField('project_id',Number(data['ROW_PROJECT_ID']),Number(data['ROW_PROJECT_ID']),index,1);
			
			if (data['NAME_COMPANY'] != null) fillArrayField('comp_name',data['NAME_COMPANY'],data['NAME_COMPANY'],index,1);
			
			if ( data['COMPANY_ID'] != null )
			{
			
				fillArrayField('action_company_id',data['COMPANY_ID'],data['COMPANY_ID'],index,1);
				fillArrayField('action_employee_id','','',index,1);
				fillArrayField('member_type','partner','partner',index,1);
				fillArrayField('member_code',data['MEMBER_CODE'],data['MEMBER_CODE'],index,1);
			}
			if (data['CONSUMER_ID'] != null)
			{
					fillArrayField('action_consumer_id',data['CONSUMER_ID'],data['CONSUMER_ID'],index,1);
					fillArrayField('action_employee_id','','',index,1);
					fillArrayField('action_company_id','','',index,1);
				fillArrayField('member_code',data['MEMBER_ACCOUNT_CODE'],data['MEMBER_ACCOUNT_CODE'],index,1);
				fillArrayField('member_type','consumer','consumer',index,1);
			}
			if (data['CONSUMER_NAME'] != null) fillArrayField('comp_name',data['CONSUMER_NAME'],data['CONSUMER_NAME'],index,1);
			
			
			if (data['ASSETP_ID'] != null) fillArrayField('asset_id',Number(data['ASSETP_ID']),Number(data['ASSETP_ID']),index,1);
			if (data['ASSETP'] != null) fillArrayField('asset_name',data['ASSETP'],data['ASSETP'],index,1);
			
			if (data['ROW_EXP_CENTER_ID'] != null) fillArrayField('expense_center_id',Number(data['ROW_EXP_CENTER_ID']),Number(data['ROW_EXP_CENTER_ID']),index,1);
			if (data['ROW_EXP_CENTER_NAME'] != null) fillArrayField('expense_center_name',data['ROW_EXP_CENTER_NAME'],data['ROW_EXP_CENTER_NAME'],index,1);
			
			if (data['ROW_EXP_ITEM_ID'] != null) fillArrayField('expense_item_id',Number(data['ROW_EXP_ITEM_ID']),Number(data['ROW_EXP_ITEM_ID']),index,1);
			if (data['ROW_EXP_ITEM_NAME'] != null) fillArrayField('expense_item_name',data['ROW_EXP_ITEM_NAME'],data['ROW_EXP_ITEM_NAME'],index,1);
			
			if (data.BASKET_EMPLOYEE != null) fillArrayField('comp_name',data.BASKET_EMPLOYEE,data.BASKET_EMPLOYEE,index,1);
			if (data.BASKET_EMPLOYEE_ID != null){
				fillArrayField('action_employee_id',data.BASKET_EMPLOYEE_ID,data.BASKET_EMPLOYEE_ID,index,1);
				fillArrayField('member_type','employee','employee',index,1);		
				fillArrayField('action_company_id','','',index,1);
				fillArrayField('member_code',data['ROW_ACC_CODE'],data['ROW_ACC_CODE'],index,1);
			}
			
		}
	function control_form()
	{ 
		if(!chk_process_cat('add_process')) return false;
		if(!check_display_files('add_process')) return false;
		if(!chk_period(add_process.action_date,'İşlem')) return false;
	
		if(!window.basket.items.length)
			{
				alert("<cf_get_lang dictionary_id='48664.Lütfen Satır Ekleyiniz'>!");
				return false;
			}
			
			for(a=0 ; a<window.basket.items.length ; a++)
			{	
				if((window.basket.items[a].COMP_NAME ==null || window.basket.items[a].COMP_NAME == '') && window.basket.items[a].ROW_KONTROL !=0 )
				{
					alert("<cf_get_lang dictionary_id='56329.Cari Seçmelisiniz'>! <cf_get_lang dictionary_id='58230.Satır No'>:" +(a+1)+"");	
					return false;
				}
				
				if((window.basket.items[a].PAPER_NUMBER ==null || window.basket.items[a].PAPER_NUMBER == '') && window.basket.items[a].ROW_KONTROL !=0)
				{
					alert("<cf_get_lang dictionary_id='54868.Belge No Girmelisiniz'>! <cf_get_lang dictionary_id='58230.Satır No'>:" +(a+1)+ "");	
					return false;
				}
				
				if((window.basket.items[a].MONEY_ID == null || window.basket.items[a].MONEY_ID == '') && window.basket.items[a].ROW_KONTROL !=0)
				{
					
					alert("<cf_get_lang dictionary_id='41991.Para Birimi Girmelisiniz'>! <cf_get_lang dictionary_id='58230.Satır No'>:" +(a+1)+ "");	
					return false;
				}
				<cfif x_required_project eq 1>
					if((window.basket.items[a].PROJECT_ID == null || window.basket.items[a].PROJECT_HEAD == '') && window.basket.items[a].ROW_KONTROL !=0)
					{
						
						alert("<cf_get_lang dictionary_id='56404.Proje Girmelisiniz'>! <cf_get_lang dictionary_id='58230.Satır No'>" +(a+1)+ "");	
						return false;
					}
				</cfif>
				<cfif x_select_type_info eq 2>
					if((window.basket.items[a].SPECIAL_DEFINITION_ID == null || window.basket.items[a].SPECIAL_DEFINITION_ID == '') && window.basket.items[a].ROW_KONTROL !=0)
					{
						alert("<cf_get_lang dictionary_id='48792.Ödeme Tipi Seçmelisiniz'>! <cf_get_lang dictionary_id='58230.Satır No'>" +(a+1)+ "");	
						return false;
					}
				</cfif>	
				if(window.basket.items[a].EXPENSE_AMOUNT != 0 && window.basket.items[a].ROW_KONTROL != 0){				
					if((window.basket.items[a].ROW_EXP_CENTER_ID == '' && window.basket.items[a].ROW_EXP_CENTER_NAME == '') || (window.basket.items[a].ROW_EXP_ITEM_ID == '' && window.basket.items[a].ROW_EXP_ITEM_NAME== ''))	
					{
						alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='1048.Masraf Merkezi'> <cf_get_lang_main no='577.Ve'> <cf_get_lang_main no='1139.Gider Kalemi'> <cf_get_lang_main no='818.Satır No'>: "+ (a+1));
						return false;
					}
				}	
			}
			if(!paper_no_control(document.getElementById('record_num').value,'<cfoutput>#dsn2#</cfoutput>','BANK_ACTIONS','ACTION_TYPE_ID*24','PAPER_NO','INCOMING_TRANSFER','ROW_KONTROL','PAPER_NUMBER','ACTION_ID-ACT_ROW_ID')) return false;
				
			//console.log(window.basket.items);			
			//waitForDisableAction($('#wrk_submit_button'));
			//timeDelay('saveInputTime');
			$("#basket_main_div div[basket_header]").find("input,select,textarea").each(function(index,element){
				if($(element).is("input") && $(element).attr("type") == "checkbox")
				{
					if($(element).is(":checked")) window.basket.header[$(element).attr("name")] = 1;
				}
				else if($(element).is("input") && $(element).attr("type") == "radio")
				{
					if ($(element).is(":checked")) window.basket.header[$(element).attr("name")] = $(element).val();
				}
				else
				{
					window.basket.header[$(element).attr("name")] = $(element).val();
				}
			})
			$("#basket_main_div div[basket_footer]").find("input,select,textarea").each(function(index,element){
				if($(element).is("input") && $(element).attr("type") == "checkbox")
				{
					if($(element).is(":checked")) window.basket.footer[$(element).attr("name")] = 1;
				}
				else if($(element).is("input") && $(element).attr("type") == "radio")
				{
					if ($(element).is(":checked")) window.basket.footer[$(element).attr("name")] = $(element).val();
				}
				else
				{
						val_ = $(element).val();
					window.basket.footer[$(element).attr("name")] = val_;
				}
			})
			/*$("#basket_main_div tr[basketCurrency]").find("input,select,textarea").each(function(index,element){
				if($(element).is("input") && $(element).attr("type") == "checkbox")
				{
					if($(element).is(":checked")) window.basket.footer[$(element).attr("name")] = 1;
				}
				else if($(element).is("input") && $(element).attr("type") == "radio")
				{
					if ($(element).is(":checked")) window.basket.footer[$(element).attr("name")] = $(element).val();
				}
				else
				{
					if(listfind('stopaj',$(element).attr("name")) != -1)
						val_ = filterNumBasket($(element).val(),price_round_number);
					else if(listfind('stopaj_yuzde',$(element).attr("name")) != -1)
						val_ = filterNumBasket($(element).val(),2)
					else if(listfind('genel_indirim_',$(element).attr("name")) != -1)
						val_ = filterNumBasket($(element).val(),basket_total_round_number);
					else if($(element).attr("name").indexOf('txt_rate') > -1)
						val_ = filterNumBasket($(element).val(),basket_rate_round_number);
					else if(listfind('tevkifat_oran',$(element).attr("name")) != -1)
						val_ = filterNum($(element).val(),8);
					else
						val_ = $(element).val();
					window.basket.footer[$(element).attr("name")] = val_;
				}
			})*/
			
			$("#hidden_fields").find("input").each(function(index,element){
				window.basket.footer[$(element).attr("name")] = $(element).val();
			})
			//console.log(window.basket.footer);
			//			timeDelay('saveInputTime');
			//			callURL("<cfoutput>#request.self#?fuseaction=objects.emptypopup_basket_converter&ajax=1</cfoutput>",handlerPost,{ page:"<cfoutput>#fusebox.circuit#.#fusebox.fuseaction#</cfoutput>", basket: encodeURIComponent($.toJSON(window.basket)) });			
			callURL("<cfoutput>#request.self#?fuseaction=objects.emptypopup_basket_converter&isAjax=1&ajax=1&xmlhttp=1&_cf_nodebug=true</cfoutput>",handlerPost,{ basket: encodeURIComponent($.toJSON(window.basket)) });
			return false;
	}
function callURL(url, callback, data, target, async)
{   
	// Make method POST if data parameter is specified
	var method = (data != null) ? "POST": "GET";
	$.ajax({
		async: async != null ? async: true,
		url: url,
		type: method,
		data: data,
		success: function(responseData, status, jqXHR)
		{ 
			callback(target, responseData, status, jqXHR); 
		}
		/*,
		error: function(xhr, opt, err)
		{
			// If error string is empty, it means page redirected to another url before ajax process done. Skip the process on this situation
			if (err != null && err.toString().length != 0) callback(target, err, opt, xhr); 
		}
		*/
	});
}
function handlerPost(target, responseData, status, jqXHR){
	responseData = $.trim(responseData);
	
	$('#working_div_main').css("display", "none");
	
	if(responseData.substr(0,2) == '//') responseData = responseData.substr(2,responseData.length-2);
	//console.log(responseData);

	ajax_request_script(responseData);
	
	var SCRIPT_REGEX = /<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi;
	while (SCRIPT_REGEX.test(responseData)) {
		responseData = responseData.replace(SCRIPT_REGEX, "");
	}
	responseData = responseData.replace(/<!-- sil -->/g, '');
	responseData = responseData.replace(/(\r\n|\n|\r)/gm,'');
	if($.trim(responseData).length > 10) /* İşlem Başarılı, işlem hatalı gibi geri dönüş değerleri kontrol ediliyor. */
		alert($.trim(responseData));
	
	/*
	if (responseData.indexOf("İşlem Başarılı")){
		sonuc_ = responseData.substr(responseData.indexOf("İşlem Başarılı"),responseData.length);
		
		request_page = responseData.substr(responseData.indexOf("İşlem Başarılı")+15,(responseData.indexOf("█") - responseData.indexOf("İşlem Başarılı") - 15));	
		
		
		
		if(request_page.indexOf('index.cfm?fuseaction') == 0)
			window.location.href = request_page;
		else if (responseData.indexOf('window.location.href="'))
		{
			startCharacter = responseData.indexOf('window.location.href="');
			newResponseData = responseData.substr(responseData.indexOf('window.location.href="'),responseData.length);
			lastCharacter = newResponseData.indexOf('";');
			request_page = newResponseData.substr(22,lastCharacter-22);
			window.location.href = request_page;
			
		}
	} else {
		//document.getElementById('note').value = responseData;
		alert('İşleminiz Sırasında Hata oluşmuştur');
	}
	*/
}
	</script>
