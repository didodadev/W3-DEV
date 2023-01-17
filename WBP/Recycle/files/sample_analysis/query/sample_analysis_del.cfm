<cfquery name="del_lab_test" datasource="#DSN#">
    DELETE FROM REFINERY_LAB_TESTS WHERE REFINERY_LAB_TEST_ID = <cfqueryparam value="#attributes.id#" cfsqltype="cf_sql_integer">
</cfquery>
<cfquery name="del_lab_test_params" datasource="#dsn#">
    DELETE FROM REFINERY_LAB_TESTS_ROW WHERE REFINERY_LAB_TEST_ID = <cfqueryparam value="#attributes.id#" cfsqltype="cf_sql_integer">
</cfquery>
<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=lab.sample_analysis</cfoutput>';
</script>