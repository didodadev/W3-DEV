<cfif isdefined("attributes.is_sms") and attributes.is_sms eq 1>
	<cfquery name="DEL_CONTENT_REL" datasource="#DSN3#">
		DELETE CAMPAIGN_SMS_CONT WHERE CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.camp_id#"> AND SMS_CONT_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sms_cont_id#">
	</cfquery>
<cfelse>
	<cfquery name="DEL_CONTENT_REL" datasource="#DSN#">
		DELETE CONTENT_RELATION WHERE CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cont_id#"> AND ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.camp_id#">  AND COMPANY_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#"> 
	</cfquery>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
