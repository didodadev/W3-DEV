<cfquery name="ADD_CAMP_TYPES" datasource="#dsn3#">
	UPDATE
		CAMPAIGN_TYPES
	SET
		CAMP_TYPE = '#attributes.camp_type#',
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#	 
	WHERE
		CAMP_TYPE_ID = #attributes.type_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_camp_types" addtoken="no">
