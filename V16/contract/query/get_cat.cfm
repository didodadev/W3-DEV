<cfquery name="GET_CAT" datasource="#dsn3#">
	SELECT 
		* 
	FROM 
		CONTRACT_CAT
		<cfif isDefined("attributes.CONTRACT_CAT_ID") and len(attributes.CONTRACT_CAT_ID)>
	WHERE
		CONTRACT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.CONTRACT_CAT_ID#">
		</cfif>
	ORDER BY
		CONTRACT_CAT
</cfquery>
