<cf_get_lang_set module_name="cheque"><!--- sayfanin en altinda kapanisi var --->
<cfset var_="upd_payroll">
<cfset ATTRIBUTES.TABLE_NAME= "PAYROLL">
<cfif isdefined("attributes.ID")>
<cfset attributes.CHEQUE_PAYROLL_ID = attributes.ID>
</cfif>
<cfinclude template="../query/get_money_rate.cfm">
<cfif isdefined("attributes.period_id") and len(attributes.period_id) >
	<cfquery name="get_period" datasource="#DSN#">
		SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = #attributes.period_id#
	</cfquery>
	<cfset db_adres = "#dsn#_#get_period.period_year#_#get_period.our_company_id#">
<cfelse>
	<cfset db_adres = "#dsn2#">
</cfif>
<cfquery name="GET_ACTION_DETAIL" datasource="#db_adres#">
	SELECT * FROM PAYROLL WHERE ACTION_ID=#URL.ID# AND PAYROLL_TYPE = 95
</cfquery>
<cfquery name="GET_CHEQUE_DETAIL" datasource="#db_adres#">
	SELECT 
		CHEQUE.CHEQUE_NO,
		CHEQUE.BANK_NAME,
		CHEQUE.BANK_BRANCH_NAME,
		CHEQUE.CHEQUE_DUEDATE,
		CHEQUE.CHEQUE_VALUE,
		CHEQUE.CURRENCY_ID,
		CHEQUE.OTHER_MONEY_VALUE,
		CHEQUE.OTHER_MONEY	
	FROM 
		CHEQUE_HISTORY,
		CHEQUE 
	WHERE 
		PAYROLL_ID = #attributes.CHEQUE_PAYROLL_ID# AND 
		CHEQUE.CHEQUE_ID = CHEQUE_HISTORY.CHEQUE_ID
</cfquery>
<cfquery name="GET_CARD" datasource="#dsn2#">
	SELECT
		ACS.CARD_ID
	FROM
		ACCOUNT_CARD ACS
	WHERE
    	ACS.ACTION_TYPE = 95
		AND ACS.ACTION_ID = #attributes.id#
</cfquery>
<cfsavecontent variable="right">
	<cfif GET_CARD.recordcount  and isdefined("session.ep.user_level") and listgetat(session.ep.user_level,22)>
        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=account.popup_list_card_rows&action_id=#attributes.id#&process_cat=95</cfoutput>','page');"><img src="/images/extre.gif"  border="0" title="<cfoutput>#getLang('main',2577)#</cfoutput>"></a>
    </cfif>
</cfsavecontent>
<cf_popup_box title="#getLang('main',444)#" right_images="#right#"><!--- Cek Giris Iade Bordrosu --->
	<table>
		<tr>
			<td width="60" class="txtbold"><cf_get_lang no='11.Bordro No'></td>
			<td width="165"><cfoutput>#get_action_detail.PAYROLL_NO#</cfoutput></td>
			<td width="60" class="txtbold"><cf_get_lang_main no='330.Tarih'></td>
			<td><cfif len(get_action_detail.payroll_revenue_date)><cfoutput>#dateformat(get_action_detail.payroll_revenue_date,dateformat_style)#</cfoutput></cfif></td>
		</tr>
		<tr>
			<td class="txtbold"><cf_get_lang_main no='108.Kasa'></td>
			<td>
				<cfset cash_id=get_action_detail.PAYROLL_CASH_ID>
				<cfinclude template="../query/get_action_cash.cfm">
				<cfoutput>#get_action_cash.CASH_NAME#</cfoutput> 
			</td>
			<td class="txtbold"><cf_get_lang_main no='162.Firma'></td>
			<td>
				<cfoutput>#get_par_info(GET_ACTION_DETAIL.COMPANY_ID,1,1,0)#</cfoutput>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr> 
		<tr height="22" class="txtbold">
			<td><cf_get_lang no='25.Çek No'></td>
			<td><cf_get_lang_main no='109.Banka'></td>
			<td><cf_get_lang_main no='1529.Subesi'></td>
			<td><cf_get_lang_main no='228.Vade'></td>
			<td><cf_get_lang no='77.İşlem Para Br.'></td>
			<td><cf_get_lang no='68.Sistem Para Br.'></td>
		</tr>
		<!--- Burasi cek sayisi kadar artacak..--->
		<cfoutput>
			<cfloop query="GET_CHEQUE_DETAIL">
				<tr>
					<td>#CHEQUE_NO#</td>
					<td>#BANK_NAME#</td>
					<td>#BANK_BRANCH_NAME#</td>
					<td>#dateformat(CHEQUE_DUEDATE,dateformat_style)#</td>
					<td>#TLFormat(CHEQUE_VALUE)# #CURRENCY_ID#</td>
					<td>#TLFormat(OTHER_MONEY_VALUE)# #OTHER_MONEY#</td>
				</tr>
				<tr valign="top">
					<td colspan="6"><hr></td>
				</tr>
			</cfloop>
			<br/>
		</cfoutput>
        <tr><td>&nbsp;</td></tr> 
		<tr><td>&nbsp;</td></tr>   
		<tr>
			<td width="50"><strong><cf_get_lang_main no='1233.Nakit'></strong></td>
			<td width="150">:</td>
			<td width="75"><strong><cf_get_lang no='38.Tahsil Eden'></strong></td>
			<td>:
				<cfif isdefined("get_action_detail.REVENUE_COLLECTOR_ID") and len(get_action_detail.REVENUE_COLLECTOR_ID)>
					<cfoutput>#get_emp_info(get_action_detail.REVENUE_COLLECTOR_ID,0,0)#</cfoutput>
				</cfif>
			</td>
		</tr>
		<tr>
			<td><strong><cf_get_lang_main no='595.Çek'></strong></td>
			<td>: <cfoutput>#TLFormat(get_action_detail.PAYROLL_TOTAL_VALUE)# #get_money_rate.MONEY#</cfoutput></td>
			<td><strong><cf_get_lang_main no='80.Toplam'></strong></td>
			<td>: <cfoutput>#TLFormat(get_action_detail.PAYROLL_TOTAL_VALUE)# #get_money_rate.MONEY#</cfoutput></td>
		</tr>
	</table>
	<cf_popup_box_footer>
		<cf_record_info query_name="get_action_detail">
	</cf_popup_box_footer>
</cf_popup_box>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
