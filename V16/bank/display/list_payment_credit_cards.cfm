<cf_get_lang_set module_name="bank">
<cf_xml_page_edit>
<cfparam name="attributes.record_emp_id" default="">
<cfparam name="attributes.record_emp_name" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.cons_id" default="">
<cfparam name="attributes.par_id" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.date_1" default="">
<cfparam name="attributes.date_2" default="">
<cfparam name="attributes.bank_account" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.action_type_" default="">
<cfparam name="attributes.payment_status" default="">
<cfparam name="attributes.bank_action_date" default="1">
<cfif len(attributes.date_1)>
	<cf_date tarih='attributes.date_1'>
</cfif>
<cfif len(attributes.date_2)>
	<cf_date tarih='attributes.date_2'>
</cfif>
<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT 
		BRANCH_ID, 
		BRANCH_NAME 
	FROM 
		BRANCH 
	WHERE
		BRANCH_STATUS=1
		<cfif session.ep.isBranchAuthorization>
			AND BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#
		</cfif>
	ORDER BY 
		BRANCH_NAME
</cfquery>
<cfquery name="BANK_ACCOUNTS" datasource="#dsn3#">
	SELECT 
		ACCOUNT_ID, 
		ACCOUNT_NAME
	FROM 
		ACCOUNTS
	WHERE
		ACCOUNT_STATUS = 1 AND
		<cfif session.ep.period_year lt 2009>
			ACCOUNT_CURRENCY_ID = 'TL'<!--- tüm pos işlemlerinde sadece ytl işlemler alınabiliyor sisteme --->
		<cfelse>
			ACCOUNT_CURRENCY_ID = '#session.ep.money#'
		</cfif>
		<cfif session.ep.isBranchAuthorization>
			AND ACCOUNT_ID IN(SELECT AB.ACCOUNT_ID FROM ACCOUNTS_BRANCH AB WHERE AB.BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#)
		</cfif>
	ORDER BY 
		ACCOUNT_NAME
</cfquery>
<cfif isdefined("attributes.is_submitted")>
	<cfif (session.ep.isBranchAuthorization) or (isdefined('attributes.branch_id') and len(attributes.branch_id))>
		<cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
			<cfset control_branch_id = attributes.branch_id>
		<cfelse>
			<cfset control_branch_id = ListGetAt(session.ep.user_location,2,"-")>
		</cfif>
	</cfif>
	<cfset arama_yapilmali = 0>
	<cfquery name="GET_CREDIT_MAIN" datasource="#DSN3#" cachedwithin="#fusebox.general_cached_time#">
		SELECT 
			CREDIT_CARD_BANK_PAYMENTS_ROWS.*,
			CREDIT_CARD_BANK_PAYMENTS.CREDITCARD_PAYMENT_ID,
			CREDIT_CARD_BANK_PAYMENTS.ACTION_FROM_COMPANY_ID,
			CREDIT_CARD_BANK_PAYMENTS.CONSUMER_ID,
			CREDIT_CARD_BANK_PAYMENTS.STORE_REPORT_DATE,
			CREDIT_CARD_BANK_PAYMENTS.SALES_CREDIT,
			CREDIT_CARD_BANK_PAYMENTS.TO_BRANCH_ID,
			ACCOUNTS.ACCOUNT_NAME AS ACCOUNT_BRANCH,
			ACCOUNTS.ACCOUNT_ID,
			CREDITCARD_PAYMENT_TYPE.CARD_NO,
			CREDIT_CARD_BANK_PAYMENTS.ACTION_TYPE,
			CREDIT_CARD_BANK_PAYMENTS.ACTION_TYPE_ID
		FROM
			CREDIT_CARD_BANK_PAYMENTS_ROWS,
			CREDIT_CARD_BANK_PAYMENTS,
			ACCOUNTS,
			CREDITCARD_PAYMENT_TYPE
		WHERE
			CREDIT_CARD_BANK_PAYMENTS_ROWS.CREDITCARD_PAYMENT_ID = CREDIT_CARD_BANK_PAYMENTS.CREDITCARD_PAYMENT_ID AND
			CREDIT_CARD_BANK_PAYMENTS.PAYMENT_TYPE_ID = CREDITCARD_PAYMENT_TYPE.PAYMENT_TYPE_ID AND
			CREDIT_CARD_BANK_PAYMENTS.ACTION_TO_ACCOUNT_ID = ACCOUNTS.ACCOUNT_ID AND
			CREDIT_CARD_BANK_PAYMENTS.STORE_REPORT_ID IS NULL AND
			CREDIT_CARD_BANK_PAYMENTS_ROWS.AMOUNT > 0  AND 
			ISNULL(CREDIT_CARD_BANK_PAYMENTS.IS_VOID,0) <> 1 AND	<!--- bir kredi karti tahsilat islemine ait iptal varsa, hem o tahsilat isleminin hem de iptal isleminin gelmemesi saglandi --->
			ISNULL(CREDIT_CARD_BANK_PAYMENTS.RELATION_CREDITCARD_PAYMENT_ID,0) NOT IN (SELECT CCBP.CREDITCARD_PAYMENT_ID FROM CREDIT_CARD_BANK_PAYMENTS CCBP WHERE ISNULL(CCBP.IS_VOID,0) = 1)
 			<cfif len(attributes.record_emp_id) and len(attributes.record_emp_name)>AND CREDIT_CARD_BANK_PAYMENTS.RECORD_EMP = #attributes.record_emp_id#</cfif>
			<cfif len(attributes.keyword)>AND CREDITCARD_PAYMENT_TYPE.CARD_NO LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI</cfif>
			<cfif len(attributes.date_1)>AND CREDIT_CARD_BANK_PAYMENTS_ROWS.BANK_ACTION_DATE >= #attributes.date_1#</cfif>
			<cfif len(attributes.date_2)>AND CREDIT_CARD_BANK_PAYMENTS_ROWS.BANK_ACTION_DATE < #DATEADD("d",1,attributes.date_2)#</cfif>
			<cfif len(attributes.bank_account)>AND CREDITCARD_PAYMENT_TYPE.BANK_ACCOUNT = #attributes.bank_account#</cfif>
			<cfif (session.ep.isBranchAuthorization) or (isdefined('attributes.branch_id') and len(attributes.branch_id))>
				AND CREDIT_CARD_BANK_PAYMENTS.TO_BRANCH_ID = #control_branch_id#
			</cfif>
			<cfif len(attributes.company_id) and len(attributes.member_name)>
				AND CREDIT_CARD_BANK_PAYMENTS.ACTION_FROM_COMPANY_ID = #attributes.company_id#
			<cfelseif len(attributes.cons_id) and len(attributes.member_name)>
				AND CREDIT_CARD_BANK_PAYMENTS.CONSUMER_ID = #attributes.cons_id#
			</cfif>
			<cfif attributes.payment_status eq 1>AND CREDIT_CARD_BANK_PAYMENTS_ROWS.BANK_ACTION_ID IS NOT NULL<cfelseif attributes.payment_status eq 2>AND CREDIT_CARD_BANK_PAYMENTS_ROWS.BANK_ACTION_ID IS NULL</cfif>
			<cfif len(attributes.action_type_)>
				AND CREDIT_CARD_BANK_PAYMENTS.ACTION_TYPE_ID = #attributes.action_type_#
			</cfif>
		ORDER BY
			<cfif attributes.bank_action_date eq 1>
			 	CREDIT_CARD_BANK_PAYMENTS_ROWS.BANK_ACTION_DATE,
			<cfelseif attributes.bank_action_date eq 2>
				CREDIT_CARD_BANK_PAYMENTS_ROWS.BANK_ACTION_DATE DESC,
			</cfif>
			CREDIT_CARD_BANK_PAYMENTS.CREDITCARD_PAYMENT_ID DESC
	</cfquery>
<cfelse>
  	<cfset arama_yapilmali = 1>
  	<cfset GET_CREDIT_MAIN.recordcount = 0>
</cfif>
<cfparam name="attributes.totalrecords" default='#GET_CREDIT_MAIN.recordcount#'>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="search_form" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_payment_credit_cards" method="post">
			<input type="hidden" name="is_submitted" id="is_submitted" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="text" name="keyword" style="width:100px;" placeholder="Filtre" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group">
					<select name="payment_status" id="payment_status" style="width:130px;">
						<option value=""><cf_get_lang dictionary_id ='48938.Hesaba Geçiş Durumu'></option>
						<option value="1" <cfif attributes.payment_status eq 1>selected</cfif>><cf_get_lang dictionary_id ='48939.Hesaba Geçmiş İşlemler'></option>
						<option value="2" <cfif attributes.payment_status eq 2>selected</cfif>><cf_get_lang dictionary_id ='48940.Hesaba Geçmemiş İşlemler'></option>
					</select>
				</div>
				<div class="form-group">
					<select name="action_type_" id="action_type_" style="width:125px;">
						<option value=""><cf_get_lang dictionary_id='57800.İşlem Tipi'></option>
						<option value="241" <cfif attributes.action_type_ eq 241>selected</cfif>><cf_get_lang dictionary_id='57836.Kredi Kartı Tahsilat'></option>
						<option value="245" <cfif attributes.action_type_ eq 245>selected</cfif>><cf_get_lang dictionary_id='29552.Kredi Kartı Tahsilat İptal'></option>
						<option value="52" <cfif attributes.action_type_ eq 52>selected</cfif>><cf_get_lang dictionary_id ='48932.Perakende Sat Faturası Tahsilatı'></option>
						<option value="69" <cfif attributes.action_type_ eq 69>selected</cfif>><cf_get_lang dictionary_id ='48933.Z Raporu Tahsilatı'></option>
					</select>
				</div>
				<div class="form-group">
					<select name="branch_id" id="branch_id" style="width:120px;">
						<option value=""><cf_get_lang dictionary_id='29434.Şubeler'></option>
						<cfoutput query="get_branch">
							<option value="#branch_id#" <cfif attributes.branch_id eq branch_id>selected</cfif>>#branch_name#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<select name="bank_action_date" id="bank_action_date" style="width:85px;">
						<option value="1" <cfif attributes.bank_action_date eq 1>selected</cfif>><cf_get_lang dictionary_id='57925.Artan Tarih'></option>
						<option value="2" <cfif attributes.bank_action_date eq 2>selected</cfif>><cf_get_lang dictionary_id='57926.Azalan Tarih'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" onKeyUp="isNumber(this)" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function='kontrol()'>
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-member_name">
						<label class="col col-12"><cf_get_lang dictionary_id='57519.cari Hesap'></label>
						<div class="col col-12">
							<div class="input-group">
							<input type="hidden" name="par_id" id="par_id" value="<cfoutput>#attributes.par_id#</cfoutput>">
							<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
							<input type="hidden" name="cons_id" id="cons_id" value="<cfoutput>#attributes.cons_id#</cfoutput>">
							<input name="member_name" type="text" id="member_name"  style="width:100px;" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',0,0,0','PARTNER_ID,COMPANY_ID,CONSUMER_ID','par_id,company_id,cons_id','','3','250');" value="<cfoutput>#attributes.member_name#</cfoutput>" autocomplete="off">
							<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_member_name=search_form.member_name&field_partner=search_form.par_id&field_consumer=search_form.cons_id&field_comp_id=search_form.company_id<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2,3</cfoutput>','list');" title="<cf_get_lang dictionary_id='57519.cari Hesap'>"></span>
							</div>
						</div>                
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-record_emp_id">
						<label class="col col-12"><cf_get_lang dictionary_id='57899.Kaydeden'></label>
						<div class="col col-12">
							<div class="input-group">
							<input type="hidden" name="record_emp_id" id="record_emp_id" value="<cfif len(attributes.record_emp_id)><cfoutput>#attributes.record_emp_id#</cfoutput></cfif>">
							<input name="record_emp_name" type="text" id="record_emp_name" style="width:100px;" onFocus="AutoComplete_Create('record_emp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','record_emp_id','','3','135');" value="<cfif len(attributes.record_emp_name)><cfoutput>#attributes.record_emp_name#</cfoutput></cfif>" autocomplete="off">
							<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=search_form.record_emp_name&field_emp_id=search_form.record_emp_id<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,9','list');return false" title="<cf_get_lang dictionary_id='57899.Kaydeden'>"></span>
							</div>
						</div>                
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-bank_account">
						<label class="col col-12"><cf_get_lang dictionary_id='29449.Banka Hesabı'></label>
						<div class="col col-12">
							<select name="bank_account" id="bank_account" style="width:270px;">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="bank_accounts">
									<option value="#account_id#" <cfif attributes.bank_account eq account_id>selected</cfif>>#bank_accounts.account_name#</option>
								</cfoutput>
							</select>
						</div>                
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
					<div class="form-group" id="item-date_1">
						<label class="col col-12"><cfoutput>#getLang(89,'Başlangıç',57501)# - #getLang(90,'Bitiş',57502)# #getLang(1181,'Tarihi',58593)#</cfoutput></label>
						<div class="col col-12">
							<div class="input-group">
								<!---<cfsavecontent variable="message"><cf_get_lang dictionary_id='326.başlama girmelisiniz'></cfsavecontent>--->
								<cfinput type="text" name="date_1" value="#dateformat(attributes.date_1,dateformat_style)#" maxlength="10" validate="#validate_style#" required="no">
								<span class="input-group-addon"><cf_wrk_date_image date_field="date_1"></span>
								<span class="input-group-addon no-bg"></span>
							<!--- <cfsavecontent variable="message"><cf_get_lang dictionary_id='327.bitiş tarihi girmelisiniz'></cfsavecontent>--->
								<cfinput type="text" name="date_2" value="#dateformat(attributes.date_2,dateformat_style)#" maxlength="10" validate="#validate_style#" required="no">
								<span class="input-group-addon"><cf_wrk_date_image date_field="date_2"></span>
							</div>
						</div>                
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>

	<cf_box title="#getLang(1751,'Kredi Kartı Hesaba Geçiş',29548)#" uidrop="1" hide_table_column="1">
	<!-- sil --><form name="add_action_bank" action="" method="post"><!-- sil -->
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='57630.Tip'></th>
					<th><cf_get_lang dictionary_id='57453.Şube'></th>
					<th><cf_get_lang dictionary_id='57692.İşlem'></th>
					<th><cf_get_lang dictionary_id='57652.Hesap'></th>
					<th><cf_get_lang dictionary_id='58061.Cari'></th>
					<th><cf_get_lang dictionary_id='57879.İşlem Tarihi'></th>
					<th><cf_get_lang dictionary_id='48897.Hesaba Geçiş Tarihi'> </th>
					<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
					<th><cf_get_lang dictionary_id='57673.Tutar'></th>
					<cfif isdefined("xml_show_commission_amount") and xml_show_commission_amount eq 1>
						<th><cf_get_lang dictionary_id="48904.Komisyon Tutarı"></th>
						<th><cf_get_lang dictionary_id="48719.Net Hesaba Geçeçek Tutar"></th>
					</cfif>
					<!-- sil --><th width="20" class="header_icn_none"><cfif get_credit_main.recordcount><input type="Checkbox" name="all_view" id="all_view" value="1" onclick="hepsi_view();"></cfif></th><!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfset alt_toplam = 0>
				<cfset alt_toplam_ = 0>
				<cfset commission_total = 0>
				<cfif get_credit_main.recordcount>
					<cfset company_id_list=''>
					<cfset consumer_id_list=''>
					<cfset branch_id_list=''>
					<cfoutput query="get_credit_main" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(ACTION_FROM_COMPANY_ID) and not listfind(company_id_list,ACTION_FROM_COMPANY_ID)>
							<cfset company_id_list=listappend(company_id_list,ACTION_FROM_COMPANY_ID)>
						<cfelseif len(CONSUMER_ID) and not listfind(consumer_id_list,CONSUMER_ID)>
							<cfset consumer_id_list=listappend(consumer_id_list,CONSUMER_ID)>
						</cfif>
						<cfif len(TO_BRANCH_ID) and not listfind(branch_id_list,TO_BRANCH_ID)>
							<cfset branch_id_list=listappend(branch_id_list,TO_BRANCH_ID)>
						</cfif>
					</cfoutput>
					<cfif len(company_id_list)>
						<cfset company_id_list=listsort(company_id_list,"numeric","ASC",",")>
						<cfquery name="get_company_detail" datasource="#dsn#">
							SELECT					
								FULLNAME
							FROM 
								COMPANY
							WHERE 
								COMPANY_ID IN (#company_id_list#) 
							ORDER BY
								COMPANY_ID
						</cfquery>
					</cfif>
					<cfif len(consumer_id_list)>
						<cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",",")>
						<cfquery name="get_consumer_detail" datasource="#dsn#">
							SELECT 
								CONSUMER_ID,
								CONSUMER_NAME,
								CONSUMER_SURNAME 
							FROM 
								CONSUMER
							WHERE 
								CONSUMER_ID IN (#consumer_id_list#)
							ORDER BY
								CONSUMER_ID
						</cfquery>
					</cfif>
					<cfif len(branch_id_list)>
						<cfset branch_id_list=listsort(branch_id_list,"numeric","ASC",",")>
						<cfquery name="get_branch_" datasource="#dsn#">
							SELECT 
								BRANCH_ID, 
								BRANCH_NAME 
							FROM 
								BRANCH
							WHERE 
								BRANCH_ID IN (#branch_id_list#)
							ORDER BY
								BRANCH_ID
						</cfquery>
					</cfif>
					<!-- sil -->
					<input type="hidden" name="start_date" id="start_date" value="<cfoutput>#attributes.date_1#</cfoutput>">
					<input type="hidden" name="finish_date" id="finish_date" value="<cfoutput>#attributes.date_2#</cfoutput>">
					<!-- sil -->
						<cfoutput query="GET_CREDIT_MAIN" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<tr>
								<td>#currentrow#</td>
								<td>
									<cfif get_credit_main.action_type_id eq 52>
										<cf_get_lang dictionary_id='57765.Perakende Satış Faturası'>
									<cfelse>
										<cfif get_credit_main.action_type_id eq 245><font color="red">#action_type#</font><cfelse>#action_type#</cfif>
									</cfif>
								</td>
								<td><cfif len(TO_BRANCH_ID)>#get_branch_.BRANCH_NAME[listfind(branch_id_list,TO_BRANCH_ID,',')]#</cfif></td>
								<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_payment_plans&id=#creditcard_payment_id#','medium');" class="tableyazi">#card_no#</a></td>
								<td>#account_branch#</td>
								<td>			
								<cfif len(GET_CREDIT_MAIN.ACTION_FROM_COMPANY_ID)>
									<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#ACTION_FROM_COMPANY_ID#','medium');">#get_company_detail.fullname[listfind(company_id_list,ACTION_FROM_COMPANY_ID,',')]#</a>
									<cfset key_type = '#GET_CREDIT_MAIN.ACTION_FROM_COMPANY_ID#'>
								<cfelseif len(GET_CREDIT_MAIN.CONSUMER_ID)>
									<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#CONSUMER_ID#','medium');">#get_consumer_detail.CONSUMER_NAME[listfind(consumer_id_list,CONSUMER_ID,',')]# #get_consumer_detail.CONSUMER_SURNAME[listfind(consumer_id_list,CONSUMER_ID,',')]#</a>
									<cfset key_type = '#GET_CREDIT_MAIN.CONSUMER_ID#'>
								</cfif>
									</td>
								<td>#dateformat(store_report_date,dateformat_style)#</td>
								<td>#dateformat(bank_action_date,dateformat_style)#</td>
								<td>#operation_name#</td>
								<td style="text-align:right;"><cfif GET_CREDIT_MAIN.ACTION_TYPE_ID eq 245><font color="red">-#TLFormat(AMOUNT)#</font><cfelse>#TLFormat(AMOUNT)#</cfif></td>
								<cfif isdefined("xml_show_commission_amount") and xml_show_commission_amount eq 1>
									<td style="text-align:right;"><cfif GET_CREDIT_MAIN.ACTION_TYPE_ID eq 245><font color="red">-#TLFormat(COMMISSION_AMOUNT)#</font><cfelse>#TLFormat(COMMISSION_AMOUNT)#</cfif></td>
									<td style="text-align:right;"><cfif GET_CREDIT_MAIN.ACTION_TYPE_ID eq 245><font color="red">-#TLFormat(AMOUNT - COMMISSION_AMOUNT)#</font><cfelse>#TLFormat(AMOUNT - COMMISSION_AMOUNT)#</cfif></td>
								</cfif>
								<cfif GET_CREDIT_MAIN.ACTION_TYPE_ID eq 245><!--- İPTAL işlemler --->
									<cfset alt_toplam = alt_toplam - amount>
									<cfset alt_toplam_ = alt_toplam_ - (amount - commission_amount)>
								<cfelse>
									<cfset alt_toplam = alt_toplam + amount>
									<cfset alt_toplam_ = alt_toplam_ + (amount - commission_amount)>
								</cfif>
								<cfif GET_CREDIT_MAIN.ACTION_TYPE_ID eq 245>
									<cfset commission_total = commission_total - commission_amount>
								<cfelse>
									<cfset commission_total = commission_total + commission_amount>
								</cfif> 
								
								<!-- sil -->
								<td class="header_icn_none">
									<cfif not len(bank_action_id)>
										<input type="checkbox" name="checked_value" id="checked_value" value="#cc_bank_payment_rows_id#" checked>
										<input type="hidden" name="kontrol_act_type" id="kontrol_act_type" value="<cfif GET_CREDIT_MAIN.ACTION_TYPE_ID eq 245>0<cfelse>1</cfif>" checked>
									</cfif>
								</td>
								<!-- sil -->
							</tr>
						</cfoutput>
						<tfoot>
							<tr>
								<td colspan="9" style="text-align:right;" class="txtbold"><cf_get_lang dictionary_id="57492.Toplam"></td>
								<td style="text-align:right;" nowrap="nowrap" class="txtbold"><cfoutput>#TLFormat(alt_toplam)# #session.ep.money#</cfoutput></td><!--- eskiden dövizli işlemde vardı ama kaldırıldı,oyüzdne ep deki eski kayıtlar saçma olabilir,bilginize.. --->
								<cfif isdefined("xml_show_commission_amount") and xml_show_commission_amount eq 1>
									<td style="text-align:right;" nowrap="nowrap" class="txtbold"><cfoutput>#TLFormat(commission_total)# #session.ep.money#</cfoutput></td>
									<td style="text-align:right;" nowrap="nowrap" class="txtbold"><cfoutput>#TLFormat(alt_toplam_)# #session.ep.money#</cfoutput></td>
								</cfif>
								<!-- sil --><td></td><!-- sil -->
							</tr>
							<!-- sil -->
							<tr>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id ='48941.Banka Hesabına Aktar'></cfsavecontent>
								<td colspan="<cfif isdefined("xml_show_commission_amount") and xml_show_commission_amount eq 1>13<cfelse>11</cfif>" style="text-align:right;">
									<cf_workcube_buttons type_format="1" is_upd='0' insert_info="#message#" is_cancel='0' add_function='hesaba_aktar()'>
								</td>
							</tr>
						</tfoot>
					<!-- sil -->
				<cfelse>
					<tr>
						<td colspan="<cfif isdefined("xml_show_commission_amount") and xml_show_commission_amount eq 1>13<cfelse>11</cfif>">
							<cfif arama_yapilmali neq 1><cf_get_lang dictionary_id='57484.Kayıt Yok'>!
							<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif> 
						</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		</form>
		<cfif GET_CREDIT_MAIN.recordcount>
			<cfset url_str = "">
			<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
			</cfif>
			<cfif isdefined("attributes.date_format") and len(attributes.date_format)>
			<cfset url_str = "#url_str#&date_format=#attributes.date_format#">
			</cfif>
			<cfif isdefined("attributes.date_1") and len(attributes.date_1)>
			<cfset url_str = "#url_str#&date_1=#dateformat(attributes.date_1,dateformat_style)#">
			</cfif>
			<cfif isdefined("attributes.date_2") and len(attributes.date_2)>
			<cfset url_str = "#url_str#&date_2=#dateformat(attributes.date_2,dateformat_style)#">
			</cfif>
			<cfif isdefined("attributes.branch_ids") and len(attributes.branch_ids)>
			<cfset url_str = "#url_str#&branch_ids=#attributes.branch_ids#">
			</cfif>
			<cfif isdefined("attributes.bank_account") and len(attributes.bank_account)>
			<cfset url_str = "#url_str#&bank_account=#attributes.bank_account#">
			</cfif>
			<cfif isdefined("attributes.operation_type") and len(attributes.operation_type)>
			<cfset url_str = "#url_str#&operation_type=#attributes.operation_type#">
			</cfif>
			<cfif isdefined("attributes.record_emp_id") and len(attributes.record_emp_id)>
			<cfset url_str = "#url_str#&record_emp_id=#attributes.record_emp_id#">
			<cfset url_str = "#url_str#&record_emp_name=#attributes.record_emp_name#">
			</cfif>
			<cfif len(attributes.par_id)>
				<cfset url_str = "#url_str#&par_id=#attributes.par_id#">
			</cfif>
			<cfif len(attributes.company_id)>
				<cfset url_str = "#url_str#&company_id=#attributes.company_id#">
			</cfif>
			<cfif len(attributes.cons_id)>
				<cfset url_str = "#url_str#&cons_id=#attributes.cons_id#">
			</cfif>
			<cfif len(attributes.member_name)>
				<cfset url_str = "#url_str#&member_name=#attributes.member_name#">
			</cfif>
			<cfif len(attributes.payment_status)>
				<cfset url_str = "#url_str#&payment_status=#attributes.payment_status#">
			</cfif>
			<cfif isdefined("attributes.action_to_account_id") and len(attributes.action_to_account_id)>
			<cfset url_str = "#url_str#&action_to_account_id=#attributes.action_to_account_id#">
			</cfif>
			<cfif len(attributes.action_type_)>
				<cfset url_str = "#url_str#&action_type_=#attributes.action_type_#">
			</cfif>
			<cfif len(attributes.bank_action_date)>
				<cfset url_str = "#url_str#&bank_action_date=#attributes.bank_action_date#">
			</cfif>
			<cfif len(attributes.branch_id)>
				<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
			</cfif>
			<cfif (attributes.totalrecords gt attributes.maxrows)>
			<table width="99%" align="center">
				<tr>
					<td>
						<cf_paging 
							page="#attributes.page#" 
							maxrows="#attributes.maxrows#" 
							totalrecords="#attributes.totalrecords#" 
							startrow="#attributes.startrow#" 
							adres="#listgetat(attributes.fuseaction,1,'.')#.list_payment_credit_cards#url_str#&is_submitted=1">
					</td>
				<!-- sil -->
				<td style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#GET_CREDIT_MAIN.recordcount# - <cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
				<!-- sil -->
				</tr>
			</table>
			</cfif>
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function kontrol()
	{
		if ( (search_form.date_1.value.length != 0)&&(search_form.date_2.value.length != 0) )
			return date_check(search_form.date_1,search_form.date_2,"<cf_get_lang dictionary_id ='48942.Başlama Tarihi Bitiş Tarihinden Önce Olmalıdır'>!");
		return true;
	}
	function hepsi_view()
	{
		if(document.add_action_bank.all_view.checked)
		{
			if (add_action_bank.checked_value.length > 1)
				for(i=0; i<add_action_bank.checked_value.length; i++) add_action_bank.checked_value[i].checked = true;
			else
				add_action_bank.checked_value.checked = true;
		}
		else
		{
			if (add_action_bank.checked_value.length > 1)
				for(i=0; i<add_action_bank.checked_value.length; i++) add_action_bank.checked_value[i].checked = false;
			else
				add_action_bank.checked_value.checked = false;
		}
	}
	function hesaba_aktar()
	{	
		kontrol_row = 0;
		if(document.add_action_bank.checked_value != undefined)
		{
			if (add_action_bank.checked_value.length > 1)
			{
				first_checked_value = "";
				for(i=0; i<add_action_bank.checked_value.length; i++)
				{
					if(add_action_bank.checked_value[i].checked == true)
					{
						if(first_checked_value=="")
							first_checked_value = document.getElementsByName('kontrol_act_type')[i].value;
						if(first_checked_value != document.getElementsByName('kontrol_act_type')[i].value)
						{
							alert("<cf_get_lang dictionary_id="51583.Kredi Kartı Tahsilat ve Kredi Kartı Tahsilat İptal işlem tipleri birlikte seçilemez !">");
							return false;
						}	
						kontrol_row = 1;
					}
				}
			}
			else
				if(add_action_bank.checked_value.checked == true)
				{
					kontrol_row = 1;
				}
		}
		if(document.add_action_bank.checked_value != undefined && kontrol_row == 1)
		{
			windowopen('','large','cc_paym');
			add_action_bank.action='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_payment_credit_cards&event=add</cfoutput>';
			add_action_bank.target='cc_paym';
			add_action_bank.submit();
		}
		else
		{
			alert("<cf_get_lang dictionary_id="51563.İşlem Seçmelisiniz !">");
			return false;
		}
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
