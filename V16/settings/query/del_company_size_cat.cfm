<cfquery name="DEL_COMPANY_SIZE_CAT" datasource="#dsn#">
	DELETE 
	FROM 
		SETUP_COMPANY_SIZE_CATS 
	WHERE 
		COMPANY_SIZE_CAT_ID=#COMPANY_SIZE_CAT_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_company_size_cat" addtoken="no">
