<cfquery name="GET_LAST_DATE_INFO" datasource="#DSN#">
	SELECT 
		MAX(LAR.FINISHDATE) MAX_DATE
	FROM 
		LIBRARY_ASSET_RESERVE LAR, 
		LIBRARY_ASSET LA 
	WHERE 
		LAR.LIBRARY_ASSET_ID = #attributes.lib_asset_id# AND 
		LAR.LIBRARY_ASSET_ID = LA.LIB_ASSET_ID
</cfquery>
