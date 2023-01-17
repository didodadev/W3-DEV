<cfquery name="ACCOUNT" datasource="#dsn2#">
	SELECT 
		* 
	FROM 
		ACCOUNT_PLAN
	WHERE
		ACCOUNT_ID = #attributes.ACCOUNT_ID#
</cfquery>
