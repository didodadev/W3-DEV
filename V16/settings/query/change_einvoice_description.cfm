<cfquery name="e_invoice_data" datasource="#DSN2#">
	UPDATE
    	EINVOICE_NUMBER 
   	SET
   		EINVOICE_NUMBER='#attributes.e_invoice_number#'
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.change_einvoice_description" addtoken="no">
