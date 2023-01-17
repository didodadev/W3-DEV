<cf_xml_page_edit fuseact="myhome.welcome">
<cfquery name="GET_BUY_SELL" datasource="#DSN#">
	SELECT 
		MY_BUYERS,
		MY_SELLERS,
		REPORT, 
		MY_VALIDS 
	FROM 
		MY_SETTINGS 
	WHERE 
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
</cfquery>

<cfsavecontent variable="m_dil_1"><cf_get_lang dictionary_id='57413.gundem'></cfsavecontent>
<cfsavecontent variable="m_dil_2"><cf_get_lang dictionary_id='30761.onaylarım'></cfsavecontent>
<cfsavecontent variable="m_dil_3"><cf_get_lang dictionary_id='30766.Uyarilarim'></cfsavecontent>
<cfsavecontent variable="m_dil_4"><cf_get_lang dictionary_id='31355.Üyelerim'></cfsavecontent>
<cfsavecontent variable="m_dil_5"><cf_get_lang dictionary_id='30764.raporlarım'></cfsavecontent>
<cfsavecontent variable="m_dil_6"><cf_get_lang dictionary_id='57563.ben'></cfsavecontent>
<cfsavecontent variable="m_dil_7"><cf_get_lang dictionary_id='57430.ayarlarım'></cfsavecontent>
<cfif ((get_buy_sell.my_buyers eq 1) or (get_buy_sell.my_sellers eq 1)) and (get_module_user(4) or (not get_module_user(4) and isdefined('xml_is_my_members') and xml_is_my_members eq 1))>
	<cfset add_com_ = "myhome.my_companies*0*0*#m_dil_4#">
<cfelse>
	<cfset add_com_ = "">
</cfif>
<cfif (get_buy_sell.report eq 1)>
	<cfset add_rep_ = "myhome.my_reports*0*0*#m_dil_5#">
<cfelse>
	<cfset add_rep_ = "">
</cfif>
<cfset f_n_action_list = "myhome.myhome*0*0*#m_dil_1#,myhome.list_confirms*0*0*#m_dil_2#,myhome.list_warnings*0*0*#m_dil_3#,#add_com_#,#add_rep_#,myhome.timecost_calendar*0*0*#m_dil_6#,myhome.mysettings*0*0*#m_dil_7#">
<cfset menu_module_layer = "myhome">
<cfinclude template="../../design/module_menu.cfm">
