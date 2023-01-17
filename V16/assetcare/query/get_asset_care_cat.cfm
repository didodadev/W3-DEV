<cfquery name="GET_CARE_CAT" datasource="#dsn#">
	SELECT 
		ASSET_CARE_ID,
		ASSET_CARE 
	FROM	
		ASSET_CARE_CAT
</cfquery>

