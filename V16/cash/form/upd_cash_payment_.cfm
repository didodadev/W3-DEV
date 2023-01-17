<cf_get_lang_set module_name="cash"><!--- sayfanin en altinda kapanisi var --->
<cfset attributes.TABLE_NAME = "CASH_ACTIONS">
<cfif isdefined("attributes.period_id") and len(attributes.period_id) >
	<cfquery name="get_period" datasource="#DSN#">
		SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = #attributes.period_id#
	</cfquery>
	<cfset db_adres = "#dsn#_#get_period.period_year#_#get_period.our_company_id#">
<cfelse>
	<cfset db_adres = "#dsn2#">
</cfif>
<cfinclude template="../query/get_action_detail.cfm">
<cfif not get_action_detail.recordcount>
    <cfset hata  = 11>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57997.Şube Yetkiniz Uygun Değil'> <cf_get_lang dictionary_id='57998.Veya'> <cf_get_lang dictionary_id='58943.Böyle Bir Kayıt Bulunmamaktadır'> !</cfsavecontent>
    <cfset hata_mesaj  = message>
    <cfinclude template="../../dsp_hata.cfm">
<cfelse>
<cfquery name="GET_COST_WITH_EXPENSE_ROWS_ID" datasource="#iif(fusebox.use_period,'db_adres','dsn')#">
	SELECT 
		* 
	FROM 
		EXPENSE_ITEMS_ROWS 
	WHERE	
		ACTION_ID=#attributes.ID#
		AND EXPENSE_COST_TYPE = 32
</cfquery>
<cfif len(get_cost_with_expense_rows_id.expense_center_id)>
  <cfquery name="GET_EXPENSE" datasource="#iif(fusebox.use_period,'db_adres','dsn')#">
	  SELECT 
		  * 
	  FROM 
		  EXPENSE_CENTER 
	  WHERE 
		  EXPENSE_ID='#GET_COST_WITH_EXPENSE_ROWS_ID.EXPENSE_CENTER_ID#'
  </cfquery>
</cfif>
<cfif len(get_cost_with_expense_rows_id.expense_item_id)>
<cfquery name="GET_EXPENSE_ITEM" datasource="#iif(fusebox.use_period,'db_adres','dsn')#">
	SELECT * FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #GET_COST_WITH_EXPENSE_ROWS_ID.EXPENSE_ITEM_ID#
</cfquery>
</cfif>
<cfquery name="GET_CARD" datasource="#dsn2#">
	SELECT
		ACS.CARD_ID,
        ACS.ACTION_ID,
        ACS.ACTION_TYPE
	FROM
		ACCOUNT_CARD ACS
	WHERE
    	<cfif len(get_action_detail.multi_action_id)>
            ACS.ACTION_TYPE = 320
            AND ACS.ACTION_ID = #get_action_detail.multi_action_id#
        <cfelse>
            ACS.ACTION_TYPE = 32
            AND ACS.ACTION_ID = #get_action_detail.action_id#
        </cfif>
</cfquery>
<cfsavecontent variable="right">
	<cfif GET_CARD.recordcount  and isdefined("session.ep.user_level") and listgetat(session.ep.user_level,22)>
		<li><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=account.popup_list_card_rows&action_id=#GET_CARD.ACTION_ID#&process_cat=#GET_CARD.ACTION_TYPE#</cfoutput>','page');" title="<cf_get_lang dictionary_id='59032.Muhasebe Hareketleri'>"><i class="icon-fa fa-table"></i></a></li>
    </cfif>
</cfsavecontent>
<div class="col col-12 col-xs-12">
	<cf_box title='#getLang('cash',53)#' right_images="#right#" scroll="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#"> 
	<cf_box_elements>
		<cfoutput>
			<div class="col col-4 col-md-8 col-xs-12">
				<div class="form-group">
					<label class="col col-4 col-md-8 col-xs-12"><b><cf_get_lang dictionary_id='35570.Makbuz No'></b></label>
				<label class="col col-8 col-xs-12">: #get_action_detail.PAPER_NO#</label>
			</div>
			</div>
			<div class="col col-4 col-md-8 col-xs-12">
				<div class="form-group">
					<label class="col col-4 col-md-8 col-xs-12"><b><cf_get_lang dictionary_id='57742.Tarih'></b></label>
				<label class="col col-8 col-xs-12">: #dateformat(get_action_detail.ACTION_DATE,dateformat_style)#</label>
			</div>
			</div>
			<div class="col col-4 col-md-8 col-xs-12">
				<div class="form-group">
					<label class="col col-4 col-md-8 col-xs-12"><b><cf_get_lang dictionary_id='31166.Ödeme Yapan'></b></label>
				<label class="col col-8 col-xs-12">: <cfif len(get_action_detail.payer_id)>#get_emp_info(get_action_detail.payer_id,0,0)#</cfif></label>
			</div>
			</div>
			<div class="col col-4 col-md-8 col-xs-12">
				<div class="form-group">
				<cfset cash_id = get_action_detail.CASH_ACTION_FROM_CASH_ID>
				<label class="col col-4 col-md-8 col-xs-12"><b><cf_get_lang dictionary_id='57520.Kasa'></b></label>
				<label class="col col-8 col-xs-12">: 
					<cfif len(get_action_detail.CASH_ACTION_FROM_CASH_ID)>
						<cfinclude template="../query/get_action_cash.cfm">							
						#get_action_cash.CASH_NAME#
					</cfif>
				</label>
			</div>
			</div>
			<cfif len(get_action_detail.CASH_ACTION_TO_COMPANY_ID)>
				<div class="col col-4 col-md-8 col-xs-12">
					<div class="form-group">
					<label class="col col-4 col-md-8 col-xs-12"><b><cf_get_lang dictionary_id='57574.Firma'></b></label>
					<label class="col col-8 col-xs-12">: #get_par_info(get_action_detail.CASH_ACTION_TO_COMPANY_ID,1,1,0)#</label>
				</div>
			</div>
			</cfif>
			<cfif len(get_action_detail.CASH_ACTION_TO_EMPLOYEE_ID)>
				<div class="col col-4 col-md-8 col-xs-12">
					<div class="form-group">
					<label class="col col-4 col-md-8 col-xs-12"><b><cf_get_lang dictionary_id='57576.Çalışan'></b></label>
					<label class="col col-8 col-xs-12">: #get_emp_info(get_action_detail.CASH_ACTION_TO_EMPLOYEE_ID,0,0)#</label>
				</div>
			</div>
			</cfif>
			<cfif len(get_action_detail.CASH_ACTION_TO_CONSUMER_ID)>
				<div class="col col-4 col-md-8 col-xs-12">
					<div class="form-group">
					<label class="col col-4 col-md-8 col-xs-12"><b><cf_get_lang dictionary_id='57658.Üye'></b></label>
					<label class="col col-8 col-xs-12">: #get_cons_info(get_action_detail.CASH_ACTION_TO_CONSUMER_ID,0,0)#</label>
				</div>
			</div>
			</cfif>
			<div class="col col-4 col-md-8 col-xs-12">
				<div class="form-group">
				<label class="col col-4 col-md-8 col-xs-12"><b><cf_get_lang dictionary_id='58460.Masraf Merkezi'></b></label>
				<label class="col col-8 col-xs-12">: <cfif len(get_cost_with_expense_rows_id.expense_center_id)>#get_expense.expense#</cfif></label>
			</div>
			</div>
			<div class="col col-4 col-md-8 col-xs-12">
				<div class="form-group">
				<label class="col col-4 col-md-8 col-xs-12"><b><cf_get_lang dictionary_id='58551.Gider Kalemi'></b></label>
				<label class="col col-8 col-xs-12">: <cfif len(get_cost_with_expense_rows_id.expense_item_id)>#get_expense_item.expense_item_name#</cfif></label>
			</div>
			</div>
			<div class="col col-4 col-md-8 col-xs-12">
				<div class="form-group">
				<label class="col col-4 col-md-8 col-xs-12"><b><cf_get_lang dictionary_id='57673.Tutar'></b></label>
				<label class="col col-8 col-xs-12">: #TLFormat(get_action_detail.CASH_ACTION_VALUE)# #get_action_detail.CASH_ACTION_CURRENCY_ID#</label>
			</div>
			</div>
			<div class="col col-4 col-md-8 col-xs-12">
				<div class="form-group">
				<label class="col col-4 col-md-8 col-xs-12"><b><cf_get_lang dictionary_id='58056.Dövizli Tutar'></b></label>
				<label class="col col-8 col-xs-12">: #TLFormat(get_action_detail.OTHER_CASH_ACT_VALUE)#&nbsp;#get_action_detail.OTHER_MONEY#</label>
			</div>
			</div>
			<div class="col col-4 col-md-8 col-xs-12">
				<div class="form-group">
				<label class="col col-4 col-md-8 col-xs-12"><b><cf_get_lang dictionary_id='57629.Açıklama'></b></label>
				<label class="col col-8 col-xs-12">: #get_action_detail.ACTION_DETAIL#</label>
			</div>
			</div>
		</cfoutput>
	</cf_box_elements>
	<cf_box_footer>
		<cfif len(get_action_detail.RECORD_EMP)>
			<cf_record_info query_name="get_action_detail">
		</cfif>
	</cf_box_footer>
</cf_box>
</div>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
</cfif>
