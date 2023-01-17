<cfquery name="ASSET_CAT_USED" datasource="#DSN#" maxrows="1">
	SELECT 
		ASSETCAT_ID
	FROM 
		ASSET
	WHERE
		ASSETCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery>
