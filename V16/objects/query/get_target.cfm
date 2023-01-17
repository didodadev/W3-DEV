<cfquery name="GET_TARGET" datasource="#DSN#">
	SELECT 
    	*
    FROM 
    	TARGET 
    WHERE 
    	TARGET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.target_id#">
</cfquery>
