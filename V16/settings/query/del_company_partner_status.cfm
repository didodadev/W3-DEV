<cfquery name="DEL_PARTNER_STATUS" datasource="#dsn#">
	DELETE 
	FROM 
		COMPANY_PARTNER_STATUS 
	WHERE 
		CPS_ID = #attributes.cps_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_company_partner_status" addtoken="no">
