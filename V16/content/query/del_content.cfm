<cfset getComponent = createObject('component','V16.content.cfc.get_content')>
<cfset get_content = getComponent.get_content(
	cntid:attributes.cntid)>
<!--- <cfquery name="get_content" datasource="#dsn#">
	SELECT CONT_HEAD as HEAD FROM CONTENT WHERE CONTENT_ID = #attributes.CNTID#
</cfquery> --->
<cfset DEL_CONTENT = getComponent.DEL_CONTENT(
	cntid:attributes.cntid)>
<!--- <cfquery name="DEL_CONTENT" datasource="#dsn#">
	DELETE FROM CONTENT WHERE CONTENT_ID = #attributes.CNTID#
</cfquery> --->
<cfset del_content_history = getComponent.del_content_history(
	cntid:attributes.cntid)>
<!--- <cfquery name="del_content_history" datasource="#dsn#">
	DELETE FROM CONTENT_HISTORY WHERE CONTENT_ID = #attributes.CNTID#
</cfquery> --->
<cfset del_user_friendly = getComponent.del_user_friendly(
	cntid:attributes.cntid)>
<!--- <cfquery name="del_user_friendly" datasource="#dsn#">
	DELETE FROM USER_FRIENDLY_URLS WHERE ACTION_ID = #attributes.CNTID# AND ACTION_TYPE = 'CONTENT_ID'
</cfquery> --->
<cfif not isdefined("attributes.cat")>
	<cfset attributes.cat = 1>
</cfif>
<!--- <cf_add_log employee_id="#session.ep.userid#" log_type="-1" action_id="#attributes.cntid#" action_name="#get_content.head# " period_id="#session.ep.period_id#" process_type="#attributes.cat#"> acınca çalışmıyor --->
<script>
	window.location.href = "<cfoutput>#request.self#?fuseaction=content.list_content</cfoutput>";
</script>
