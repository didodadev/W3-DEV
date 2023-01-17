<cfquery name="UPD_SMS_CONT" datasource="#dsn3#">
	UPDATE
		CAMPAIGN_SMS_CONT
	SET
		SMS_BODY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.sms_body#">,
		SMS_HEAD = <cfif isdefined("attributes.sms_head") and len(attributes.sms_head)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.sms_head#"><cfelse>NULL</cfif>,
		UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
		UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_add#">
	WHERE
		SMS_CONT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sms_cont_id#">
</cfquery>	
<script type="text/javascript">
	<cfif isdefined('attributes.draggable')>
		location.href = document.referrer;
	<cfelse>
		wrk_opener_reload();
		window.close();
	</cfif>
</script>
