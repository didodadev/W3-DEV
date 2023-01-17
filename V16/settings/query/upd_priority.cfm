<cfquery name="UPDPRIORITY" datasource="#DSN#">
	UPDATE 
		SETUP_PRIORITY 
	SET 
		PRIORITY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.priority#">,
		COLOR = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.colourp#">,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#	 
	WHERE 
		PRIORITY_ID = #PRIORITY_ID#
</cfquery>
<script>
	location.href = document.referrer;
</script>