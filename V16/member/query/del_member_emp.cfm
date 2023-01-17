<cfquery name="del_group_emp" datasource="#DSN#">
	DELETE FROM 
		WORKGROUP_EMP_PAR
	WHERE
		POSITION_CODE = #URL.position_code# AND
		COMPANY_ID = #URL.cp_id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
