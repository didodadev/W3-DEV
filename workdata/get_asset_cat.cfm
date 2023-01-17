<!---
	Author 		: Uğur Hamurpet
	Description : This function return asset categories by the asset category name
	parameters 	:	{
		assetcat_name(required)	:	Asset category name
	}
--->
<cf_xml_page_edit fuseact="settings.asset_cat">
<cffunction name="get_asset_cat" access="public" returntype="query" output="no">
	<cfargument name="assetcat_name" required="yes" type="string">
	<cfquery name="GET_ASSET_CAT" datasource="#dsn#">
		SELECT
			ASSCAT.ASSETCAT_ID,
			ASSCAT.ASSETCAT,
			ASSCAT.ASSETCAT_PATH
		FROM
			ASSET_CAT ASSCAT
			<cfif isdefined("x_show_by_digital_asset_group") and x_show_by_digital_asset_group eq 1>
			JOIN DIGITAL_ASSET_GROUP_PERM DAGP
				ON ASSCAT.ASSETCAT_ID = DAGP.ASSETCAT_ID 
				AND DAGP.GROUP_ID = (SELECT GROUP_ID FROM DIGITAL_ASSET_GROUP_PERM WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)  
			</cfif>
		WHERE
			ASSCAT.ASSETCAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.assetcat_name#%">
		ORDER BY
			ASSCAT.ASSETCAT ASC 
	</cfquery>
	<cfreturn GET_ASSET_CAT>
</cffunction>

