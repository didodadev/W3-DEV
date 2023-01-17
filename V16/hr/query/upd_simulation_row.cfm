<cfquery name="ADD_SIMULATION_ROW" datasource="#dsn#">
UPDATE 
	ORGANIZATION_SIMULATION_ROWS
SET
	<cfif len(attributes.employee_id)>EMPLOYEE_ID = #attributes.employee_id#,</cfif>
	POSITION_CODE = #attributes.position_code#,
	POSITION_TYPE = #attributes.position_cat_id#,
	STAGE_ID = #attributes.organization_step_id#
WHERE
	ROW_ID = #attributes.row_id#		
</cfquery>
<script type="text/javascript">
wrk_opener_reload();
window.close();
</script>
