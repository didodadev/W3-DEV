<cfquery name="GET_PARTNER" datasource="#DSN#">
	SELECT 
		COMPANY_PARTNER_NAME,
		COMPANY_PARTNER_SURNAME,
		PARTNER_ID 
	FROM 
		COMPANY_PARTNER 
	WHERE 
		PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#">
</cfquery>

