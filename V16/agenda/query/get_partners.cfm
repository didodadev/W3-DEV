<cfquery name="GET_PARTNERS" datasource="#DSN#">
	SELECT 
		PARTNER_ID,
		COMPANY_PARTNER_NAME,
		COMPANY_PARTNER_SURNAME
	FROM 
		COMPANY_PARTNER
	WHERE
		COMPANY_PARTNER_STATUS = 1
		<cfif isDefined("attributes.companycat_id")>
            AND COMPANYCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.companycat_id#">
        <cfelseif isDefined("attributes.partner_ids")>
            AND PARTNER_ID IN (#attributes.partner_ids#)
        </cfif>
</cfquery>
