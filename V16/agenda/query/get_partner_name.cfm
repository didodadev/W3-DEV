<cfquery name="GET_PARTNER_NAME" datasource="#DSN#">
	SELECT 
		COMPANY_PARTNER.PARTNER_ID,
		COMPANY.NICKNAME,
		COMPANY_PARTNER.COMPANY_PARTNER_NAME, 
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME
	FROM 
		COMPANY_PARTNER,
		COMPANY
	WHERE
		COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
		COMPANY_PARTNER.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#">
</cfquery>
