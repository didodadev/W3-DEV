<cfquery name="ADD_SMS_CONT" datasource="#dsn3#">
	INSERT INTO
		CAMPAIGN_SMS_CONT
		(
			CAMP_ID,
			SMS_BODY,
			SMS_HEAD,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP
		)
	VALUES
		(
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.camp_id#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.sms_body#">,
			<cfif isdefined("attributes.sms_head") and len(attributes.sms_head)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.sms_head#"><cfelse>NULL</cfif>,
			<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_add#">
		)
</cfquery>	
<script type="text/javascript">
	<cfif isdefined('attributes.draggable')>
		location.href = document.referrer;
	<cfelse>
		wrk_opener_reload();
		window.close();
	</cfif>
</script>
