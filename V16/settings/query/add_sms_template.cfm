<cfquery name="set_sms_template" datasource="#dsn#" result="MAX_ID">
	INSERT INTO
		SMS_TEMPLATE
		(
			SMS_TEMPLATE_NAME,
			SMS_TEMPLATE_BODY,
			IS_ACTIVE,
			IS_CHANGE,
			IS_EDIT_SEND_DATE,
			SMS_FUSEACTION,
			RECORD_EMP,
			RECORD_DATE,
			RECORD_IP
		)
	 VALUES
		(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.template_name#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.sms_body#">,
			<cfif isdefined('attributes.is_active')>1<cfelse>0</cfif>,
			<cfif isdefined('attributes.is_change')>1<cfelse>0</cfif>,
			<cfif isdefined('attributes.is_edit_send_date')>1<cfelse>0</cfif>,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.fuseaction_name#">,
			#session.ep.userid#,
			#now()#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.userid#">
		)
</cfquery>
<script>
	location.href = document.referrer;
</script>