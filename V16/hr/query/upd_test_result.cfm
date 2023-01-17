<cfquery name="add_result" datasource="#dsn#">
	UPDATE
		EMPLOYEES_APP_TEST_RESULTS
	SET	
		TEST_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.test_type#">,
		TEST_FINAL_POINT = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.test_final_point#">,
		POINT_BASE_TYPE = <cfif len(attributes.point_base_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.point_base_type#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" null="yes" value=""></cfif>,
		UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
		UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
        TEST_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.test_date#">
	WHERE	
		ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery>
<script type="text/javascript">
	location.href= document.referrer;
</script>
