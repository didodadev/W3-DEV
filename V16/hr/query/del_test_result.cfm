<cfquery name="del_result" datasource="#dsn#">
	DELETE FROM EMPLOYEES_APP_TEST_RESULTS WHERE ID = #attributes.id#
</cfquery>
<script type="text/javascript">
 	location.href= document.referrer;
</script>
