<cfquery name="DELCORRCAT" datasource="#dsn#">
	DELETE 
	FROM 
		SETUP_CORR 
	WHERE 
		CORRCAT_ID=#CORRCAT_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_corr_cat" addtoken="no">
