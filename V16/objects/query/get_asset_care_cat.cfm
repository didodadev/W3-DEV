<cfquery name="get_care_cat" datasource="#dsn#">
	SELECT 
		ASSET_CARE 
	FROM	
		ASSET_CARE_CAT
	WHERE
		ASSET_CARE_ID = #attributes.ASSET_CARE_ID#
</cfquery>
