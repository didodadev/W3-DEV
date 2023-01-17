<!--- masraf-gelir-bakım fişi ve sağlık anlaşmalı kurum faturası display popup ıdır --->
<cf_get_lang_set module_name="cost">
<cfif isdefined("attributes.period_id") and len(attributes.period_id)>
	<cfquery name="get_period" datasource="#DSN#">
		SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = #attributes.period_id#
	</cfquery>
	<cfset db_adres = "#dsn#_#get_period.period_year#_#get_period.our_company_id#">
<cfelse>
	<cfset db_adres = "#dsn2#">
</cfif>
<cfquery name="get_expense_money" datasource="#db_adres#">
	SELECT MONEY_TYPE AS MONEY,* FROM EXPENSE_ITEM_PLANS_MONEY WHERE ACTION_ID = #attributes.id# 
</cfquery>
<cfquery name="GET_EXPENSE" datasource="#db_adres#">
	SELECT 
    	EIP.*,
        SPC.INVOICE_TYPE_CODE
    FROM 
    	EXPENSE_ITEM_PLANS EIP,
        #dsn3_alias#.SETUP_PROCESS_CAT SPC
          
    WHERE 
		EIP.PROCESS_CAT = SPC.PROCESS_CAT_ID AND
    	EIP.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery>
<cfquery name="get_efatura_det" datasource="#dsn2#">
	SELECT 
		RECEIVING_DETAIL_ID
	FROM
		EINVOICE_RECEIVING_DETAIL
	WHERE
		EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
	ORDER BY
		RECEIVING_DETAIL_ID DESC
</cfquery>
<cfquery name="get_earchive_det" datasource="#db_adres#">
	SELECT 
		EARCHIVE_ID
	FROM
		EARCHIVE_RELATION
	WHERE
		ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
        AND ACTION_TYPE = 'EXPENSE_ITEM_PLANS'
        AND ISNULL(STATUS,1) <> 0
</cfquery>
<cfif len(get_expense.ch_company_id) and get_expense.ch_company_id neq 0>
	<cfquery name="get_expense_COMP" datasource="#DSN#">
		SELECT 
			COMPANY_ID,
            COMPANYCAT_ID,
			TAXOFFICE,
			TAXNO,
			COMPANY_ADDRESS,
			COUNTY,
			CITY,
			COUNTRY,
			FULLNAME,
			COMPANY_TELCODE,
			COMPANY_TEL1,
			COMPANY_FAX,
			COMPANY_ADDRESS,
			COMPANY_EMAIL,
			MEMBER_CODE,
			IMS_CODE_ID,
            USE_EFATURA,
            EFATURA_DATE
		FROM
			COMPANY
		WHERE 
			COMPANY.COMPANY_ID = #get_expense.ch_company_id#
	</cfquery>
<cfelseif len(get_expense.ch_consumer_id)>
	<cfquery name="GET_CONS_NAME" datasource="#DSN#">
		SELECT 
			CONSUMER_ID,
            CONSUMER_CAT_ID,
			COMPANY,
			MEMBER_CODE,
			TC_IDENTY_NO,
			CONSUMER_NAME,
			CONSUMER_SURNAME,
			CONSUMER_WORKTELCODE,
			CONSUMER_WORKTEL,
			CONSUMER_FAX,
			CONSUMER_EMAIL,
			MOBIL_CODE,
			MOBILTEL,
			TAX_ADRESS,
			TAX_CITY_ID,
			TAX_COUNTY_ID,
			TAX_COUNTRY_ID,
			TAX_NO,
			TAX_OFFICE,
			VOCATION_TYPE_ID,
			IMS_CODE_ID,
            USE_EFATURA,
            EFATURA_DATE
		FROM 
			CONSUMER
		WHERE 
			CONSUMER_ID = #get_expense.ch_consumer_id#
	</cfquery>		
</cfif>
<cfif not get_expense.recordcount>
	<br/><font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'>!</font>
	<cfexit method="exittemplate">
</cfif>
<cfquery name="get_process_cat" datasource="#dsn3#">
	SELECT 
		PROCESS_CAT,
		PROCESS_TYPE 
	FROM 
		SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_TYPE = #get_expense.action_type# AND 
		PROCESS_CAT_ID= #get_expense.process_cat#
</cfquery>
<cfquery name="get_rows" datasource="#iif(fusebox.use_period,'db_adres','dsn')#">
	SELECT * FROM EXPENSE_ITEMS_ROWS WHERE EXPENSE_ID = #get_expense.expense_id#
</cfquery>
<cfif len(get_expense.paper_type)>
	<cfquery name="get_document_type" datasource="#dsn#">
		SELECT
			SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_ID,
			SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_NAME
		FROM
			SETUP_DOCUMENT_TYPE,
			SETUP_DOCUMENT_TYPE_ROW
		WHERE
			SETUP_DOCUMENT_TYPE_ROW.DOCUMENT_TYPE_ID =  SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_ID AND
			SETUP_DOCUMENT_TYPE_ROW.FUSEACTION LIKE '%#fuseaction#%' AND
			SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_ID = #get_expense.paper_type#
		ORDER BY
			DOCUMENT_TYPE_NAME
	</cfquery>
</cfif>
<cfif len(get_expense.paymethod_id)>
	<cfquery name="get_paymethod" datasource="#dsn#">
		SELECT PAYMETHOD_ID, PAYMETHOD FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = #get_expense.paymethod_id#
	</cfquery>
</cfif>
<cfquery name="GET_CARD" datasource="#dsn2#">
	SELECT
		ACS.CARD_ID
	FROM
		ACCOUNT_CARD ACS
	WHERE
		ACS.ACTION_TYPE = #get_expense.action_type#
		AND ACS.ACTION_ID = #attributes.id#
</cfquery>

<cfsavecontent variable="head">
	<cfif get_process_cat.process_type eq 120>
		<cf_get_lang_main no='652.Masraf Fisi'>
	<cfelseif get_process_cat.process_type eq 121>
		<cf_get_lang_main no='653.Gelir Fişi'>
	<cfelseif get_process_cat.process_type eq 122>
		<cf_get_lang dictionary_id='29644.Bakım Fişi'>
	<cfelseif get_process_cat.process_type eq 1201>
		<cf_get_lang dictionary_id='46609.Anlaşmalı Kurum Faturası'>
	</cfif>
</cfsavecontent>
<cfsavecontent variable="right">
	<cfoutput>
		<cfif isdefined("get_expense.REQUEST_ID") and len(get_expense.REQUEST_ID)>
			<!--- harcama talebi varsa uyarılar için --->
			<a href="#request.self#?fuseaction=objects.workflowpages&tab=3&action=cost.list_expense_requests&action_name=request_id&action_id=#get_expense.REQUEST_ID#" target="_blank" title="Harcama Talebi Uyarılar"><i class="icon-bell"></i></a>
		</cfif>
		<cfif get_process_cat.process_type eq 120>
			<a href="#request.self#?fuseaction=objects.workflowpages&tab=3&action=cost.form_add_expense_cost&action_name=request_id&action_id=#attributes.id#" target="_blank" title="Uyarılar"><i class="icon-bell"></i></a>
		<cfelseif get_process_cat.process_type eq 121>
			<a href="#request.self#?fuseaction=objects.workflowpages&tab=3&action=cost.add_income_cost&action_name=request_id&action_id=#attributes.id#" target="_blank" title="Uyarılar"><i class="icon-bell"></i></a>
		<cfelseif get_process_cat.process_type eq 122>
			<a href="#request.self#?fuseaction=objects.workflowpages&tab=3&action=assetcare.form_add_expense_cost&action_name=request_id&action_id=#attributes.id#" target="_blank" title="Uyarılar"><i class="icon-bell"></i></a>
		<cfelseif get_process_cat.process_type eq 1201>
			<a href="#request.self#?fuseaction=objects.workflowpages&tab=3&action=health.expenses&action_name=request_id&action_id=#attributes.id#" target="_blank" title="Uyarılar"><i class="icon-bell"></i></a>
		</cfif>
	</cfoutput>
	<cfif (GET_EXPENSE.INVOICE_TYPE_CODE eq 'SATIS' OR GET_EXPENSE.INVOICE_TYPE_CODE eq 'IADE') and (len(get_expense.ch_company_id) and get_expense_comp.use_efatura eq 1 and datediff('d',get_expense_comp.efatura_date,get_expense.expense_date) gte 0) or (len(get_expense.ch_consumer_id) and get_cons_name.use_efatura eq 1 and datediff('d',get_cons_name.efatura_date,get_expense.expense_date) gte 0) >
		<cf_wrk_efatura_display action_id="#attributes.id#" action_type="EXPENSE_ITEM_PLANS" is_display="1">
	</cfif>
    <cfif get_card.recordcount and get_module_user(22)><!--- Module ID'ye göre yetki kontrolüne bakıyor. --->
        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.id#&process_cat=#get_expense.action_type#</cfoutput>','page');"><img src="/images/extre.gif"  border="0" title="<cfoutput>#getLang('main',2577)#</cfoutput>"></a>
    </cfif>
	<cfif get_efatura_det.recordcount>
		<cfoutput><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_dsp_efatura_detail&event=det&receiving_detail_id=#get_efatura_det.receiving_detail_id#&type=1','wwide');" class="tableyazi"><img src="../images/icons/efatura_black.gif" alt="<cf_get_lang_main no='345.Uyarılar'>" title="<cf_get_lang_main no='345.Uyarılar'>" border="0"></a></cfoutput>
	</cfif>
	<cfif get_earchive_det.recordcount>
    	<cf_wrk_earchive_display action_id="#attributes.id#" action_type="EXPENSE_ITEM_PLANS" action_date="#GET_EXPENSE.expense_date#" is_display="1" period_id="#attributes.period_id#">
    </cfif>
</cfsavecontent>
<cf_box title='#head#' popup_box="#iif(isdefined("attributes.draggable"),1,0)#" right_images="#right#">
	<cf_box_elements>
	<cfoutput>
	<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
		<div class="form-group" id="item-process_cat">
			<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang_main no='388.Islem Tipi'></label>
			<div class="col col-8 col-md-6 col-xs-12">
				: #get_process_cat.process_cat#
			</div>
		</div>
		<div class="form-group" id="item-paper_no">
			<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang_main no='468.Belge No'></label>
			<div class="col col-8 col-md-6 col-xs-12">
				: #get_expense.paper_no#
			</div>
		</div>
		<div class="form-group" id="item-paper_type">
			<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang_main no='1166.Belge Türü'></label>
			<div class="col col-8 col-md-6 col-xs-12">
				: <cfif len(get_expense.paper_type)>#get_document_type.document_type_name#</cfif>
			</div>
		</div>
		<div class="form-group" id="item-system_relation">
			<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang_main no='1267.Sistem Iliskisi'></label>
			<div class="col col-8 col-md-6 col-xs-12">
				: <cfif len(get_expense.system_relation)>#get_expense.system_relation#</cfif>
			</div>
		</div>
		<div class="form-group" id="item-paymethod_id">
			<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang_main no='1104.Ödeme Yöntemi'></label>
			<div class="col col-8 col-md-6 col-xs-12">
				: <cfif len(get_expense.paymethod_id)>#get_paymethod.paymethod#</cfif>
			</div>
		</div>
		<div class="form-group" id="item-detail">
			<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang_main no= '217.Açıklama'></label>
			<div class="col col-8 col-md-6 col-xs-12">
				: #get_expense.detail#
			</div>
		</div>
	</div>
	<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
		<div class="form-group" id="item-expense_date">
			<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang no='4.Belge Tarihi'></label>
			<div class="col col-8 col-md-6 col-xs-12">
				: #dateformat(get_expense.expense_date,dateformat_style)#
			</div>
		</div>
		<div class="form-group" id="item-">
			<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang_main no='107.Cari Hesap'></label>
			<div class="col col-8 col-md-6 col-xs-12">
				: 
					<cfif len(get_expense.ch_company_id)>
						<cfset ch_member_type="partner">
					<cfelseif len(get_expense.ch_consumer_id)>
						<cfset ch_member_type="consumer">
					<cfelse>
						<cfset ch_member_type="">
					</cfif>
					<cfif ch_member_type eq "partner">
						#get_par_info(get_expense.ch_company_id,1,1,0)#
					<cfelseif ch_member_type eq "consumer">
						#get_cons_info(get_expense.ch_consumer_id,2,0)#
					</cfif>
			</div>
		</div>
		<div class="form-group" id="item-">
			<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang_main no='166.Yetkili'></label>
			<div class="col col-8 col-md-6 col-xs-12">
				: 
					<cfif ch_member_type eq "partner">
						#get_par_info(get_expense.ch_partner_id,0,-1,0)#
					<cfelseif ch_member_type eq "consumer">
						#get_cons_info(get_expense.ch_consumer_id,0,0)#
					</cfif>
			</div>
		</div>
		<div class="form-group" id="item-">
			<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang no='9.Ödeme Yapan'></label>
			<div class="col col-8 col-md-6 col-xs-12">
				: <cfif len(get_expense.emp_id)>#get_emp_info(get_expense.emp_id,0,0)#</cfif>
			</div>
		</div>
	</div>
</cfoutput>
</cf_box_elements>
	<br/>
	<cf_grid_list>
		<thead>
			<tr>
				<th><cf_get_lang_main no= '217.Açıklama'></th>
				<th>
					<cfif isDefined("attributes.is_income")>
						<cf_get_lang_main no='760.Gelir Merkezi'>	
					<cfelse>
						<cf_get_lang_main no='1048.Masraf Merkezi'>
					</cfif>
				</th>					
				<th>
					<cfif isDefined("attributes.is_income")>
						<cf_get_lang_main no='761.Gelir Kalemi'>
					<cfelse>
						<cf_get_lang_main no='1139.Gider Kalemi'>
					</cfif>
				</th>
				<th><cf_get_lang_main no='245.Ürün'></th>
				<th><cf_get_lang_main no='224.Birim'></th>
				<th><cf_get_lang_main no='223.Miktar'></th>
				<th><cf_get_lang_main no= '261.Tutar'></th>
				<th><cf_get_lang_main no= '227.KDV%'></th>
				<th><cf_get_lang no='7.KDV Tutar'></th>
				<th><cf_get_lang_main no= '268.KDV li Toplam'></th>
				<th><cf_get_lang_main no='644.Dövizli Tutar'></th>
				<th><cf_get_lang_main no='77.Para Birimi'></th>
				<th><cf_get_lang no='15.Aktivite Tipi'></th>
				<th>
					<cfif isDefined("attributes.is_income")>
						<cf_get_lang no='6.Satış Yapan'>
					<cfelse>
						<cf_get_lang no= '5.Harcama Yapan'>
					</cfif>
				</th>
				<th><cf_get_lang_main no='1421.Fiziki Varlik'></th>
				<th><cf_get_lang_main no= '4.Proje'></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_rows.recordcount>
			<cfset expense_center_list = "">
			<cfset expense_item_list = "">
			<cfset activity_list = "">
			<cfset assetp_list = "">
			<cfset project_list = "">
			<cfset product_id_list = "">
				<cfoutput query="get_rows">
					<cfif len(expense_center_id) and not listfind(expense_center_list,expense_center_id)>
						<cfset expense_center_list = listappend(expense_center_list,expense_center_id)>
					</cfif>
					<cfif len(expense_item_id) and not listfind(expense_item_list,expense_item_id)>
						<cfset expense_item_list = listappend(expense_item_list,expense_item_id)>
					</cfif>
					<cfif len(activity_type) and not listfind(activity_list,activity_type)>
						<cfset activity_list = listappend(activity_list,activity_type)>
					</cfif>
					<cfif len(pyschical_asset_id) and not listfind(assetp_list,pyschical_asset_id)>
						<cfset assetp_list = listappend(assetp_list,pyschical_asset_id)>
					</cfif>
					<cfif len(project_id) and not listfind(project_list,project_id)>
						<cfset project_list = listappend(project_list,project_id)>
					</cfif>
					<cfif len(product_id) and not listfind(product_id_list,product_id)>
						<cfset product_id_list = listappend(product_id_list,product_id)>
					</cfif>
				</cfoutput>
			<cfif len(expense_center_list)>
				<cfquery name="get_expense_center" datasource="#dsn2#">
					SELECT EXPENSE_ID,EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ID IN (#expense_center_list#) ORDER BY EXPENSE_ID
				</cfquery>
				<cfset expense_center_list = listsort(listdeleteduplicates(valuelist(get_expense_center.expense_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(expense_item_list)>
				<cfquery name="get_expense_item" datasource="#dsn2#">
					SELECT
						EXPENSE_ITEM_ID,
						EXPENSE_ITEM_NAME
					FROM
						EXPENSE_ITEMS
					WHERE
					<cfif isDefined("attributes.is_income")>
						INCOME_EXPENSE = 1 AND
					<cfelse>
						IS_EXPENSE = 1 AND
					</cfif>
						EXPENSE_ITEM_ID IN (#expense_item_list#)
					ORDER BY
						EXPENSE_ITEM_ID
				</cfquery>
			<cfset expense_item_list = listsort(listdeleteduplicates(valuelist(get_expense_item.expense_item_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(activity_list)>
				<cfquery name="get_activity_types" datasource="#dsn#">
					SELECT ACTIVITY_ID,ACTIVITY_NAME FROM SETUP_ACTIVITY WHERE ACTIVITY_ID IN (#activity_list#) ORDER BY ACTIVITY_ID
				</cfquery>
				<cfset activity_list = listsort(listdeleteduplicates(valuelist(get_activity_types.activity_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(assetp_list)>
				<cfquery name="get_assetp_name" datasource="#dsn#">
					SELECT ASSETP_ID,ASSETP FROM ASSET_P WHERE ASSETP_ID IN (#assetp_list#) ORDER BY ASSETP_ID
				</cfquery>
				<cfset assetp_list = listsort(listdeleteduplicates(valuelist(get_assetp_name.assetp_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(project_list)>
				<cfquery name="get_project" datasource="#dsn#">
					SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_list#) ORDER BY PROJECT_ID
				</cfquery>
				<cfset project_list = listsort(listdeleteduplicates(valuelist(get_project.project_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(product_id_list)>
				<cfquery name="get_product" datasource="#dsn1#">
					SELECT PRODUCT_ID,PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID IN (#product_id_list#) ORDER BY PRODUCT_ID
				</cfquery>
				<cfset product_id_list = listsort(listdeleteduplicates(valuelist(get_product.product_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfoutput query="get_rows">
				<tr>
					<td>#get_rows.detail#</td>
					<td><cfif len(expense_center_list)>#get_expense_center.expense[listfind(expense_center_list,expense_center_id,',')]#</cfif></td>
					<td><cfif len(expense_item_list)>#get_expense_item.expense_item_name[listfind(expense_item_list,expense_item_id,',')]#</cfif></td>
					<td><cfif len(product_id_list) and len(product_id)>#get_product.product_name[listfind(product_id_list,product_id,',')]#</cfif></td>
					<td>#get_rows.unit#</td>
					<td>#tlformat(get_rows.quantity)#</td>
					<td><cfif len(get_rows.amount)>#tlformat(get_rows.amount)#</cfif></td>
					<td>#get_rows.kdv_rate#</td>
					<td><cfif len(get_rows.amount_kdv)>#tlformat(get_rows.amount_kdv)#</cfif></td>
					<td><cfif len(get_rows.total_amount)>#tlformat(get_rows.total_amount)#</cfif></td>
					<td><cfif len(get_rows.other_money_value)>#tlformat(get_rows.other_money_gross_total)#</cfif></td>
					<td>#get_rows.money_currency_id#</td>
					<td><cfif len(activity_list)>#get_activity_types.activity_name[listfind(activity_list,activity_type,',')]#</cfif></td>
					<td><cfif get_rows.member_type eq 'partner'>
							#get_par_info(get_rows.company_partner_id,0,-1,0)#
						<cfelseif get_rows.member_type eq 'consumer'>
							#get_cons_info(get_rows.company_partner_id,0,0)#
						<cfelseif get_rows.member_type eq 'employee'>
							#get_emp_info(get_rows.company_partner_id,0,0)#
						<cfelse>&nbsp;</cfif>
					</td>
					<td><cfif len(assetp_list)>#get_assetp_name.assetp[listfind(assetp_list,pyschical_asset_id,',')]#</cfif></td>
					<td><cfif len(project_list)>#get_project.project_head[listfind(project_list,project_id,',')]#</cfif></td>
				</tr>
			</cfoutput>
			</cfif>
		</tbody>
	</cf_grid_list>
	<div class="ui-row">
		<div id="sepetim_total" class="padding-0">
			<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
				<div class="totalBox">
					<div class="totalBoxHead font-grey-mint">
						<span class="headText"> Döviz </span>
						<div class="collapse">
							<span class="icon-minus"></span>
						</div>
					</div>
					<div class="totalBoxBody" style="display: block;">
					<input type="hidden" id="kur_say" name="kur_say" value="4">
							<table cellspacing="0" id="money_rate_table">
								<tbody>
								<cfif get_expense_money.recordcount>
								<cfoutput query="get_expense_money">
								<tr>
								<td nowrap="nowrap"><input type="radio" class="rdMoney" id="rd_money" name="rd_money" <cfif get_expense.other_money eq money>checked="checked"<cfelse>disabled="disabled"</cfif>></td>
								<td nowrap="nowrap">#MONEY_TYPE#</td>
								<td nowrap="nowrap">#TLFormat(rate1,0)#/</td>
								<td nowrap="nowrap"><input disabled="disabled" type="text" id="txt_rate2_1" name="txt_rate2_1" value="#TLFormat(RATE2,session.ep.our_company_info.rate_round_num)#" style="width:100%;" class="box"></td>
							</cfoutput>
						</cfif>		
					</tbody></table>
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
						<cfoutput> 
						<table>
							<tbody><tr>
								<td width="100" class="txtbold"> <cf_get_lang dictionary_id='57492.Toplam'> </td>
								<td width="75" id="total_default" style="text-align:right;" name="total_default">#tlformat(get_expense.total_amount)# #session.ep.money#</td>
								
							</tr>

							<tr> 
								<td class="txtbold"><cf_get_lang_main no='712.Döviz Toplam'> </td>
								<td width="75" id="total_discount_default" style="text-align:right;" name="total_discount_default">#tlformat(get_expense.other_money_amount)# #get_expense.other_money#</td>
							
							</tr>

							<tr> 
								<td class="txtbold"><cf_get_lang no='13.Toplam KDV'>  </td>
								<td width="75" id="total_discount_default" style="text-align:right;" name="total_discount_default">#tlformat(get_expense.kdv_total)# #session.ep.money#</td>
							
							</tr>
							
							<tr> 
								<td class="txtbold"> <cf_get_lang no='27.Döviz KDV'> </td>
								<td width="75" id="brut_total_default" style="text-align:right;" name="total_discount_default">#tlformat(get_expense.other_money_kdv)# #get_expense.other_money#</td>
							</tr>
							<tr> 
								<td class="txtbold"><cf_get_lang_main no='268.Genel Toplam'></td>
								<td id="total_tax_default" style="text-align:right;" name="total_tax_default">#tlformat(get_expense.total_amount_kdvli)# #session.ep.money#</td>
							</tr>
							<tr> 
								<td class="txtbold"><cf_get_lang_main no='265.Döviz'> <cf_get_lang_main no='268.Genel Toplam'></td>
								<td id="total_otv_default" style="text-align:right;" name="total_otv_default">#tlformat(get_expense.other_money_net_total)# #get_expense.other_money#</td>
							
							</tr>
						</tbody>
					</table>    
					</cfoutput>        
					</div>
				</div>
			</div>
		</div>
	</div>
	<cf_box_footer>
		<cf_record_info query_name="get_expense">
	</cf_box_footer>
</cf_box>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
