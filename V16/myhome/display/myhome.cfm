<cfsetting showdebugoutput="yes">
<cfif not isdefined("fuseaction")>
	<cfset fuseaction = "myhome.welcome">
</cfif>
<cf_xml_page_edit fuseact="myhome.welcome">
<cfif isdefined("is_one_day") and is_one_day eq 1>
	<cfset attributes.date_interval = 1>
<cfelse>
	<cfset attributes.date_interval = 8>
</cfif>
<cfset attributes.apply_date = now()>
<cfif isdefined("session.ep.menu_id") and session.ep.menu_id gt 0>
	<cfquery name="GET_MY_FILE" datasource="#DSN#">
		SELECT MYHOME_FILE FROM MAIN_MENU_SETTINGS WHERE MENU_ID = #session.ep.menu_id#
	</cfquery>
	<cfif len(get_my_file.myhome_file)>
		<cfinclude template="#file_web_path#templates/#get_my_file.myhome_file#">
	<cfelse>
		<cfinclude template="myhome_ic.cfm">
	</cfif>
<cfelse>
	<cfinclude template="myhome_ic.cfm">
</cfif>
<cfsetting showdebugoutput="NO">

