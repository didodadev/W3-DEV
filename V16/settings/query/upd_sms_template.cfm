<cfquery name="UPD_SMS_TEMPLATE" datasource="#dsn#">
	UPDATE
		SMS_TEMPLATE
	SET
		IS_ACTIVE = <cfif isdefined('attributes.is_active')>1<cfelse>0</cfif>,
		IS_CHANGE = <cfif isdefined('attributes.is_change')>1<cfelse>0</cfif>,
		IS_EDIT_SEND_DATE = <cfif isdefined('attributes.is_edit_send_date')>1<cfelse>0</cfif>,
		SMS_TEMPLATE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#template_name#">,
		SMS_TEMPLATE_BODY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#sms_body#">,
		SMS_FUSEACTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.fuseaction_name#">,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_DATE = #now()#,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
	WHERE 
    	SMS_TEMPLATE_ID = #attributes.sms_template_id#
</cfquery>
<script>
	location.href = document.referrer;
</script>