<cfquery name="GET_PARTNER" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		COMPANY_PARTNER 
	WHERE 
		PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
</cfquery>

<cfquery name="GET_COMPANY" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		COMPANY 
	WHERE 
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.company_id#">
</cfquery>
