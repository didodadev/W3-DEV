<cfquery name="ADD_SIMULATION" datasource="#dsn#">
	UPDATE 
		ORGANIZATION_SIMULATION 
	SET
		POSITION_ID = #attributes.position_id#,
		SIMULATION_HEAD = '#attributes.head#',
		POSITION_CODE =  #attributes.position_code#,
		EMPLOYEE_ID =  #attributes.employee_id#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_DATE = #now()#,
		UPDATE_IP = '#cgi.remote_addr#'
	WHERE 
		SIMULATION_ID = #attributes.simulation_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=hr.dsp_simulation_schema&event=upd&simulation_id=#attributes.simulation_id#" addtoken="no">
