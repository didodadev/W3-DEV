<cfquery name="GET_PAYMETHOD" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		SETUP_PAYMETHOD
	WHERE
		PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PAYMETHOD_ID#">
</cfquery>
