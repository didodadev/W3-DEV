<cfquery name="del_salary_plan" datasource="#dsn#">
	DELETE FROM EMPLOYEES_SALARY_PLAN WHERE SALARY_PLAN_ID = #attributes.salary_plan_id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
