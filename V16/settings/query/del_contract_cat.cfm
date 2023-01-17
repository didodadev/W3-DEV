<cfquery name="DEL_CONTRACT_CAT" datasource="#dsn3#">
	DELETE 
	FROM 
		CONTRACT_CAT 
	WHERE 
		CONTRACT_CAT_ID=#CONTRACT_CAT_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_contract_cat" addtoken="no">
