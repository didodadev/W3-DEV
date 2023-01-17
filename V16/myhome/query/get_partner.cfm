<cfquery name="GET_PARTNER" datasource="#dsn#">
	SELECT 
		PARTNER_ID,
		COMPANY_PARTNER_NAME,
		COMPANY_PARTNER_SURNAME
	FROM 
		COMPANY_PARTNER
	WHERE 
		<cfif isdefined("attributes.partner_id")>
		PARTNER_ID = #attributes.PARTNER_ID#
		<cfelse>
		PARTNER_ID IN (#LISTSORT(attributes.COMP_PAR_IDS,"NUMERIC")#)
		</cfif>
</cfquery>
