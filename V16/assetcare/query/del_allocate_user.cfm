<cfquery name="delete_allocate_user" datasource="#dsn#">
	DELETE FROM
		ASSET_P_KM_CONTROL_USERS
	WHERE
		EMPLOYEE_ID = #attributes.emp_id# AND 
		KM_CONTROL_ID = #attributes.km_control_id#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload(); 
	self.close();
</script>
