<cfquery name="UPD_COUNTER_TYPE" datasource="#DSN3#">
	UPDATE 
		SETUP_COUNTER_TYPE
	SET 
		COUNTER_TYPE = '#attributes.counter_type#',
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#cgi.remote_addr#'
	WHERE 
		COUNTER_TYPE_ID = #attributes.counter_type_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.add_counter_type" addtoken="no">
