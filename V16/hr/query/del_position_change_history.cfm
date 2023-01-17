<cfquery name="del_position_history" datasource="#dsn#">
	DELETE FROM EMPLOYEE_POSITIONS_CHANGE_HISTORY WHERE ID = #attributes.id#
</cfquery>
<script type="text/javascript">
	location.href = document.referrer;
</script>
