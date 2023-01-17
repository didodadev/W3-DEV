<cfquery name="ADD_SOCIAL_SOCIETY" datasource="#dsn#">
	INSERT 
	INTO 
		SETUP_SOCIAL_SOCIETY
	(
		SOCIETY,
		SOCIETY_DETAIL,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP
	) 
		VALUES 
	(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#ATTRIBUTES.SOCIETY#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#ATTRIBUTES.SOCIETY_DETAIL#">,
		#NOW()#,
		#SESSION.EP.USERID#,
		'#CGI.REMOTE_ADDR#'
	)
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	self.close();
</script>




