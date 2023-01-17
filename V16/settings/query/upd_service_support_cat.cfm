<cfquery name="UPDSUPPORT" datasource="#DSN#">
	UPDATE 
		SETUP_SUPPORT 
	SET 
		SUPPORT_CAT='#attributes.support_cat#',
		UPDATE_IP = '#cgi.remote_addr#', 
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#
	WHERE 
		SUPPORT_CAT_ID = #support_cat_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_service_support_cat" addtoken="no">
