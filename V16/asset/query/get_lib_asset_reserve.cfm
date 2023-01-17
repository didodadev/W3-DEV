<cfquery name="GET_LIB_ASSET_INFO" datasource="#DSN#">
	SELECT 
		LAR.* , 
		LA.LIB_ASSET_NAME 
	FROM 
		LIBRARY_ASSET_RESERVE AS LAR, 
		LIBRARY_ASSET AS LA 
	WHERE 
		LAR.LIBRARY_ASSET_ID = LA.LIB_ASSET_ID
	<cfif len(attributes.lib_asset_id)>
		AND LAR.LIBRARY_ASSET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.lib_asset_id#">
	</cfif>
	<cfif len(attributes.keyword) and len(attributes.keyword) eq 1>
		AND LA.LIB_ASSET_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
	<cfelseif len(attributes.keyword) and len(attributes.keyword) gt 1>
		AND LA.LIB_ASSET_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
	</cfif>
	ORDER BY 
		LAR.STARTDATE	
</cfquery>
