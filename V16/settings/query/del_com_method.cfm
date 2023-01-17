<cfquery name="DELCOMMETHOD" datasource="#dsn#">
	DELETE 
	FROM 
		SETUP_COMMETHOD	
	WHERE 
		COMMETHOD_ID=#COMMETHOD_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_com_method" addtoken="no">
