<cf_get_lang_set module_name="cheque">
<cfinclude template="../query/get_money_rate.cfm">
<cfif isdefined("attributes.period_id") and len(attributes.period_id) >
	<cfquery name="get_period" datasource="#DSN#">
		SELECT 
        	PERIOD_ID, 
            PERIOD, 
            PERIOD_YEAR, 
            IS_INTEGRATED, 
            OUR_COMPANY_ID, 
            PERIOD_DATE, 
            OTHER_MONEY, 
            STANDART_PROCESS_MONEY, 
            RECORD_DATE, 
            RECORD_IP, 
            RECORD_EMP, 
            UPDATE_DATE, 
            UPDATE_IP, 
            UPDATE_EMP, 
            IS_LOCKED, 
            PROCESS_DATE 
        FROM 
        	SETUP_PERIOD 
        WHERE
        	PERIOD_ID = #attributes.period_id#
	</cfquery>
	<cfset db_adres = "#dsn#_#get_period.period_year#_#get_period.our_company_id#">
<cfelse>
	<cfset db_adres = "#dsn2#">
</cfif>
<cfquery name="GET_ACTION_DETAIL" datasource="#db_adres#">
	SELECT * FROM VOUCHER_PAYROLL WHERE ACTION_ID=#URL.ID#
</cfquery>
<cfquery name="GET_VOUCHER_DETAIL" datasource="#db_adres#">
	SELECT 
		VOUCHER.VOUCHER_NO,
		VOUCHER.VOUCHER_DUEDATE,
		VOUCHER.VOUCHER_VALUE,
		VOUCHER.CURRENCY_ID,
		VOUCHER.OTHER_MONEY_VALUE,
		VOUCHER.OTHER_MONEY	
	FROM 
		VOUCHER_HISTORY,
		VOUCHER 
	WHERE 
		PAYROLL_ID = #URL.ID# AND 
		VOUCHER.VOUCHER_ID = VOUCHER_HISTORY.VOUCHER_ID
</cfquery>
<cfif GET_ACTION_DETAIL.PAYROLL_TYPE  eq 97>
	<cfset baslik = "#getLang('main',598)#"><!--- Senet Giriş Bordrosu --->
<cfelseif GET_ACTION_DETAIL.PAYROLL_TYPE  eq 98>
	<cfset baslik = "#getLang('main',599)#"><!--- Senet Çıkış Bordrosu --->
<cfelseif GET_ACTION_DETAIL.PAYROLL_TYPE  eq 99>
	<cfset baslik = "#getLang('main',1803)#"><!--- Senet Çıkış Bordrosu-Banka Tahsil--->
<cfelseif GET_ACTION_DETAIL.PAYROLL_TYPE  eq 100>
	<cfset baslik = "#getLang('main',1804)#"><!--- Senet Çıkış Bordrosu-Banka Teminat--->
<cfelseif GET_ACTION_DETAIL.PAYROLL_TYPE  eq 101>
	<cfset baslik = "#getLang('main',600)#"><!--- Senet İade Çıkış Bordrosu --->
<cfelseif GET_ACTION_DETAIL.PAYROLL_TYPE  eq 104>
	<cfset baslik = "#getLang('main',1808)#"><!--- Senet Çıkış Bordrosu-Tahsil--->
<cfelseif GET_ACTION_DETAIL.PAYROLL_TYPE  eq 108>
	<cfset baslik = "#getLang('main',601)#"><!--- Senet İade Giriş Bordrosu --->
<cfelseif GET_ACTION_DETAIL.PAYROLL_TYPE  eq 109>
	<cfset baslik = "#getLang('main',601)#-#getLang('main',109)#"><!--- Senet İade Giriş Bordrosu-Banka --->
<cfelseif GET_ACTION_DETAIL.PAYROLL_TYPE  eq 1057>
	<cfset baslik = "#getLang('main',1823)#"><!--- Senet İade Giriş Bordrosu-Banka --->
</cfif>
<cfquery name="GET_CARD" datasource="#dsn2#">
	SELECT
		ACS.CARD_ID,
        ACTION_TYPE,
        ACTION_ID
	FROM
		ACCOUNT_CARD ACS
	WHERE
    	ACS.ACTION_TYPE = #GET_ACTION_DETAIL.PAYROLL_TYPE#
		AND ACS.ACTION_ID = #attributes.id#
</cfquery>
<cfsavecontent variable="right">
	<cfif GET_CARD.recordcount  and isdefined("session.ep.user_level") and listgetat(session.ep.user_level,22)>
        <a href="javascript://" onclick="windowopen('<cfoutput></cfoutput>','page');"><img src="/images/extre.gif"  border="0" title="<cfoutput>#getLang('main',2577)#</cfoutput>"></a>
    </cfif>
</cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#baslik#" list_href="#iif(GET_CARD.recordcount  and isdefined('session.ep.user_level') and listgetat(session.ep.user_level,22),DE('#request.self#?fuseaction=account.popup_list_card_rows&action_id=#GET_CARD.ACTION_ID#&process_cat=#GET_CARD.ACTION_TYPE#'),DE(''))#" list_href_title="#getLang('main',2577)#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cf_box_elements>
			<div class="form-group col col-9 col-md-9 col-sm-12 col-xs-12">
				<label class="col col-3 col-md-3 col-sm-6 col-xs-12 bold"><cf_get_lang no='11.Bordro No'></label>
				<label class="col col-3 col-md-3 col-sm-6 col-xs-12">: <cfoutput>#get_action_detail.PAYROLL_NO#</cfoutput></label>
				<label class="col col-3 col-md-3 col-sm-6 col-xs-12 bold"><cf_get_lang_main no='330.Tarih'></label>
				<label class="col col-3 col-md-3 col-sm-6 col-xs-12">: <cfif len(get_action_detail.payroll_revenue_date)><cfoutput>#dateformat(get_action_detail.payroll_revenue_date,dateformat_style)#</cfoutput></cfif></label>
			</div>
			<div class="form-group col col-9 col-md-9 col-sm-12 col-xs-12">
				<label class="col col-3 col-md-3 col-sm-6 col-xs-12 bold"><cf_get_lang_main no='108.Kasa'></label>
				<label class="col col-3 col-md-3 col-sm-6 col-xs-12">: 
					<cfset cash_id=get_action_detail.PAYROLL_CASH_ID>
					<cfinclude template="../query/get_action_cash.cfm">
					<cfoutput>#get_action_cash.CASH_NAME#</cfoutput> 
				</label>
				<label class="col col-3 col-md-3 col-sm-6 col-xs-12 bold"><cf_get_lang_main no='162.Firma'></label>
				<label class="col col-3 col-md-3 col-sm-6 col-xs-12">: <cfoutput>#get_par_info(GET_ACTION_DETAIL.COMPANY_ID,1,1,0)#</cfoutput></label>
				</div>
		</cf_box_elements>
		<cf_grid_list>
			<thead>
				<tr height="22" class="bold">
					<th><cf_get_lang_main no='1090.Senet No'></th>
					<th><cf_get_lang_main no='228.Vade'></th>
					<th nowrap="nowrap"><cf_get_lang no='77.İşlem Para Br.'></th>
					<th><cf_get_lang no='68.Sistem Para Br.'></th>
				</tr>
			</thead>
			<tbody>
				<cfoutput>
					<cfloop query="GET_VOUCHER_DETAIL">
						<tr>
							<td>#VOUCHER_NO#</td>
							<td>#dateformat(VOUCHER_DUEDATE,dateformat_style)#</td>
							<td>#TLFormat(VOUCHER_VALUE)# #CURRENCY_ID#</td>
							<td>#TLFormat(OTHER_MONEY_VALUE)# #OTHER_MONEY#</td>
						</tr>
					</cfloop>
				</cfoutput>
			</tbody>
			<tfoot>
				<tr>
					<td width="50"><strong><cf_get_lang_main no='1233.Nakit'></strong></td>
					<td width="150"></td>
					<td width="75"><strong><cf_get_lang no='38.Tahsil Eden'></strong></td>
					<td>
						<cfif isdefined("get_action_detail.REVENUE_COLLECTOR_ID") and len(get_action_detail.REVENUE_COLLECTOR_ID)>
							<cfoutput>#get_emp_info(get_action_detail.REVENUE_COLLECTOR_ID,0,0)#</cfoutput>
						</cfif>
					</td>
				</tr>
				<tr>
					<td><strong><cf_get_lang_main no="596.Senet"></strong></td>
					<td><cfoutput>#TLFormat(get_action_detail.PAYROLL_TOTAL_VALUE)# #get_money_rate.MONEY#</cfoutput></td>
					<td><strong><cf_get_lang_main no='80.Toplam'></strong></td>
					<td><cfoutput>#TLFormat(get_action_detail.PAYROLL_TOTAL_VALUE)# #get_money_rate.MONEY#</cfoutput></td>
				</tr>
			</tfoot>			
		</cf_grid_list>
		<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
			<cf_box_footer>
				<cfif len(get_action_detail.record_emp)>
					<cf_record_info query_name="get_action_detail">
				</cfif>
			</cf_box_footer>
		</div>		
	</cf_box>
</div>

<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
