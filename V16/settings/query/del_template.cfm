<cfquery name="DEL_TEMPLATE" datasource="#dsn#">
	DELETE	
	FROM 
		  TEMPLATE_FORMS
	WHERE
		     	TEMPLATE_ID = #attributes.TEMPLATE_ID#  
				   
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_template" addtoken="no">
