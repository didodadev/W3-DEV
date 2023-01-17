<cfif isdate(attributes.test_date)>
	<cf_date tarih="attributes.test_date">
<cfelse>
	<cfset attributes.test_date = "null">
</cfif>
<cfquery name="add_result" datasource="#dsn#">
	INSERT INTO
		EMPLOYEES_APP_TEST_RESULTS
		(
			EMPAPP_ID,
			TEST_ID,
			TEST_FINAL_POINT,
			POINT_BASE_TYPE,
			RECORD_EMP,
			RECORD_DATE,
			RECORD_IP,
            TEST_DATE
		)
		VALUES
		(
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.empapp_id#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.test_type#">,
			<cfqueryparam cfsqltype="cf_sql_float" value="#attributes.test_final_point#">,
			<cfif len(attributes.point_base_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.point_base_type#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" null="yes" value=""></cfif>,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
            <cfif len(attributes.test_date) and isdate(attributes.test_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.test_date#"><cfelse><cfqueryparam cfsqltype="cf_sql_timestamp" null="yes" value=""></cfif>
		)
</cfquery>
<script type="text/javascript">
	location.href= document.referrer;
</script>
