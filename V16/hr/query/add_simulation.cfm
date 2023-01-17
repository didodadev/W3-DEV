<cfquery name="ADD_SIMULATION" datasource="#dsn#" result="MAX_ID">
INSERT 
INTO 
	ORGANIZATION_SIMULATION 
	(
		SIMULATION_HEAD,
		POSITION_ID,
		POSITION_CODE,
		EMPLOYEE_ID,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP
	)
	VALUES
	(
		'#attributes.head#',
		 #attributes.position_id#,
		 #attributes.position_code#,
		 #attributes.employee_id#,
		 #session.ep.userid#,
		 #now()#,
		 '#cgi.remote_addr#'
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=hr.dsp_simulation_schema&event=upd&simulation_id=#MAX_ID.IDENTITYCOL#" addtoken="no">
