<cfquery name="UPD_SOCIETY" datasource="#dsn#">
	UPDATE 
		SETUP_SOCIAL_SOCIETY 
	SET 
		SOCIETY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ATTRIBUTES.SOCIETY#">,
		SOCIETY_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ATTRIBUTES.SOCIETY_DETAIL#">,
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_DATE = #NOW()#,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
	WHERE 
		SOCIETY_ID = #ATTRIBUTES.SOCIETY_ID#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	self.close();
</script>


