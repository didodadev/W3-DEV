<cfquery name="GET_PARTNER" datasource="#dsn#">
	SELECT 
		PARTNER_ID,
		COMPANY_PARTNER_NAME,
		COMPANY_PARTNER_SURNAME
	FROM 
		COMPANY_PARTNER
	WHERE
		PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#">
</cfquery>
