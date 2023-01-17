<cfquery name="GET_LIB_ASSET_NAME" datasource="#DSN#">
	SELECT 
		LIB_ASSET_NAME
	FROM 
		LIBRARY_ASSET
	WHERE 
		LIB_ASSET_ID = #attributes.lib_asset_id# 
</cfquery>
