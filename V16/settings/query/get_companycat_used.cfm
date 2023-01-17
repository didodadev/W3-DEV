<cfquery name="COMPANYCAT_USED" datasource="#DSN#">
	SELECT 
		COMPANYCAT_ID
	FROM 
		COMPANY
	WHERE
		COMPANYCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.companycat_id#">
</cfquery>
