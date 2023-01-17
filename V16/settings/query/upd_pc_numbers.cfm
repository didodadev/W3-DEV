<cfquery name="UPD_COMPUTERS" datasource="#DSN#">
	UPDATE 
		SETUP_PC_NUMBER
	SET 
		UNIT_NAME = '#attributes.unit_name#',
		UNIT_DESC = '#attributes.unit_desc#',
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#	 
	WHERE 
		UNIT_ID= #attributes.u_id#
</cfquery>
<cflocation addtoken="no" url="#request.self#?fuseaction=settings.form_add_pc_number">
