<cfquery name="UPD_company" datasource="#dsn#">
	UPDATE 
		SETUP_INSURANCE_COMPANY
		SET 
		COMPANY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ATTRIBUTES.COMPANY_NAME#">,
		COMPANY_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ATTRIBUTES.COMPANY_DETAIL#">,
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_DATE = #NOW()#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#'
	WHERE 
		COMPANY_ID = #ATTRIBUTES.COMPANY_ID#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	self.close();
</script>


