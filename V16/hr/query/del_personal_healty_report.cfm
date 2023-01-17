<cfquery NAME="DEL_EMP_HEALTY_REPORT" DATASOURCE="#DSN#">
	DELETE
	FROM
		EMPLOYEE_HEALTY_REPORT
	WHERE 
		HEALTY_REPORT_ID=#attributes.HEALTY_REPORT_ID#
</cfquery>
<script type="text/javascript">
    wrk_opener_reload();
	window.close();
</script>

