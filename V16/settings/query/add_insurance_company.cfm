<cfquery name="ADD_COMPANY" datasource="#dsn#">
	INSERT 
	INTO 
		SETUP_INSURANCE_COMPANY
	(
		COMPANY_NAME,
		COMPANY_DETAIL,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP
	) 
		VALUES 
	(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#ATTRIBUTES.COMPANY_NAME#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#ATTRIBUTES.COMPANY_DETAIL#">,
		#NOW()#,
		#SESSION.EP.USERID#,
		'#CGI.REMOTE_ADDR#'
	)
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	self.close();
</script>




