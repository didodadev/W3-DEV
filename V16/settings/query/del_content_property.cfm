<cfquery name="DEL_CONTENT_PROPERTY" datasource="#dsn#">
	DELETE FROM 
		CONTENT_PROPERTY 
	WHERE 
		CONTENT_PROPERTY_ID=#CONTENT_PROPERTY_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_content_property" addtoken="no">
