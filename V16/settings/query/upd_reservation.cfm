<cfquery name="UPDRESERVATION" datasource="#DSN#">
	UPDATE 
		SETUP_RESERVATION 
	SET 
		RESERVATION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.reservation#">,
		COLOR = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.colourp#">,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#	 
	WHERE 
		RESERVATION_ID = #reservation_id#
</cfquery>
<script>
	location.href = document.referrer;
</script>
