<cfquery name="GET_COMPANY_NAME" datasource="#DSN#">
	SELECT 
		NICKNAME,
		MEMBER_CODE,
		FULLNAME,
		COMPANY_ID
	FROM 
		COMPANY 
	WHERE 
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
</cfquery>

