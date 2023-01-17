<cfquery name="del_wrk_emps" datasource="#DSN3#">
	DELETE FROM
		SERVICE_EMPLOYEES
	WHERE
		SERVICE_ID = #attributes.service_id# AND
		EMPLOYEE_ID = #attributes.emp_id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>

