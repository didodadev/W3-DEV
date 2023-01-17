<cfquery name="get_employee_info" datasource="#dsn#">
	SELECT EMPLOYEE_EMAIL,EMPLOYEE_PASSWORD FROM EMPLOYEES AS e WHERE e.EMPLOYEE_ID = #session.ep.userid#
</cfquery>
<cflocation url="#reportman_url#?UserName=#get_employee_info.EMPLOYEE_EMAIL#&password=#get_employee_info.EMPLOYEE_PASSWORD#" addtoken="no">
<script type="text/javascript">
	window.close();
</script>
