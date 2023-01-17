<cfquery name="ADD_SIMULATION_ROW" datasource="#dsn#" result="MAX_ID">
INSERT 
    INTO 
        ORGANIZATION_SIMULATION_ROWS
        (
            UP_POSITION_ID,
            SIMULATION_ID,
            <cfif len(attributes.employee_id)>EMPLOYEE_ID,</cfif>
            POSITION_CODE,
            POSITION_TYPE,
            STAGE_ID
        )
        VALUES
        (
            
            #attributes.up_position_id#,
            #attributes.simulation_id#,
            <cfif len(attributes.employee_id)>#attributes.employee_id#,</cfif>
            #attributes.position_code#,
            #attributes.position_cat_id#,
            #attributes.organization_step_id#
        )		
</cfquery>
<cfif isdefined("attributes.hierarchy")>
	<cfquery name="UPD_HIERARCHY" datasource="#dsn#">
		UPDATE
			ORGANIZATION_SIMULATION_ROWS
		SET
			HIERARCHY = '#attributes.hierarchy#.#MAX_ID.IDENTITYCOL#'
		WHERE 
			ROW_ID = #MAX_ID.IDENTITYCOL#
	</cfquery>
<cfelse>
	<cfquery name="UPD_HIERARCHY" datasource="#dsn#">
		UPDATE
			ORGANIZATION_SIMULATION_ROWS
		SET
			HIERARCHY = '#attributes.up_position_id#.#MAX_ID.IDENTITYCOL#'
		WHERE 
			ROW_ID = #MAX_ID.IDENTITYCOL#
	</cfquery>
</cfif>
<script type="text/javascript">
wrk_opener_reload();
window.close();
</script>
