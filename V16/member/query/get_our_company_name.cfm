<cfquery name="GET_OUR_COMPANY_NAME" datasource="#dsn#">
	SELECT 
	    COMP_ID,
		COMPANY_NAME 
	FROM 
	    OUR_COMPANY
	WHERE
		COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_id#">
</cfquery>
