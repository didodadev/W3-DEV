<cfquery name="get_asset_state" datasource="#DSN#">
	SELECT 
		ASSET_STATE 
	FROM 
		ASSET_STATE
	WHERE
		ASSET_STATE_ID = #attributes.ASSET_STATE_ID#
</cfquery>
