<cfquery name="del_analyze" datasource="#DSN#">
    DELETE FROM REFINERY_TEST WHERE REFINERY_TEST_ID = #attributes.id#
</cfquery>
<cfquery name="del_parameters" datasource="#DSN#">
    DELETE FROM REFINERY_TEST_ROWS WHERE PARAMETER_TEST_ROW_ID = #attributes.id#
</cfquery>
<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=recycle.analysis_template</cfoutput>';
</script>