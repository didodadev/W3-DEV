<cfquery name="UPD_COST_TYPE" datasource="#DSN#">
	UPDATE 
   		SETUP_COST_TYPE
	SET
		COST_TYPE_NAME='#attributes.cost_type_name#',
		COST_TYPE_DETAIL='#attributes.cost_type_detail#',
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#	 
	WHERE 
		COST_TYPE_ID=#attributes.cost_type_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_cost_type" addtoken="no">
