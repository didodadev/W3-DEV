<cfquery name="UPDPRO_rolles" datasource="#dsn3#">
	UPDATE 
		SETUP_CAMPAIGN_ROLES 
	SET 
		CAMPAIGN_ROLE ='#CAMPAIGN_ROLE#',
		DETAIL = '#DETAIL#',
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_DATE = #now()#
	WHERE 
	CAMPAIGN_ROLE_ID=#CAMPAIGN_ROLE_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_camp_rol" addtoken="no">

