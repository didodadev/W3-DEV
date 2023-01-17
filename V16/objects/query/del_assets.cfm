<cfset path=''>
<cfquery name="GET_ASSETS" datasource="#DSN#">
	SELECT
		ASSET.ASSET_FILE_NAME,
		ASSET.ASSET_FILE_SERVER_ID,
		ASSET.MODULE_NAME,
		ASSET.ASSET_ID,
		ASSET.ASSETCAT_ID,
		ASSET_CAT.ASSETCAT_PATH		
	FROM
		ASSET,
		ASSET_CAT
	WHERE
		ASSET.ACTION_SECTION = '#UCASE(attributes.action_section)#' AND
		ASSET.ACTION_ID = #attributes.action_id# AND
		ASSET.ASSETCAT_ID = ASSET_CAT.ASSETCAT_ID
</cfquery>


<cfoutput query="get_assets">
	<cfif ASSETCAT_ID gte 0>
		<cfset path = assetcat_path>
	</cfif>
	<cfif len(path)>
		<cfset folder="asset/#path#">
	<cfelse>
		<cfset folder="#assetcat_path#">
	</cfif>
		
	<cfquery name="CONTROL_" datasource="#DSN#">
		SELECT
			ASSET_ID
		FROM
			ASSET
		WHERE
			ASSET_ID <> #get_assets.asset_id# AND
			ASSET_FILE_NAME = '#get_assets.asset_file_name#'
	</cfquery>
		
	<cfif control_.recordcount>
		<!--- dosya birden fazla varlik tarafindan kullanildigi icin silinmiyor --->
	<cfelse>
		<cf_del_server_file output_file="#folder#/#asset_file_name#" output_server="#asset_file_server_id#">
	</cfif>
</cfoutput>

<cfquery name="DEL_ASSETS" datasource="#DSN#">
	DELETE FROM
		ASSET
	WHERE
		ACTION_SECTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCASE(attributes.action_section)#"> AND
		ACTION_ID = #attributes.action_id#
</cfquery>
