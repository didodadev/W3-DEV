<cfquery name="DEL_SHELF" datasource="#DSN#">
	DELETE
	FROM
    		SHELF
	WHERE 
		SHELF_MAIN_ID=#attributes.DEL_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_shelf" addtoken="no">
