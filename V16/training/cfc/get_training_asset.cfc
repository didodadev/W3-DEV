<cffunction name="get_training_asset_fnc" returntype="query">
	<cfargument name="class_id" default="">
    <cfquery name="get_training_asset" datasource="#this.DSN#">
		SELECT
			A.ASSET_FILE_NAME,
			A.MODULE_NAME,
			A.ASSET_ID,
			A.ASSETCAT_ID,
			A.ASSET_NAME,
			A.IMAGE_SIZE,
			A.ASSET_FILE_SERVER_ID,
			ASSET_CAT.ASSETCAT,
			ASSET_CAT.ASSETCAT_PATH,
			CP.NAME
		FROM
			ASSET A,
			CONTENT_PROPERTY CP,
			ASSET_CAT
		WHERE
			A.ASSETCAT_ID = ASSET_CAT.ASSETCAT_ID 
			AND A.ACTION_SECTION = 'CLASS_ID'
			AND A.PROPERTY_ID = CP.CONTENT_PROPERTY_ID
			<cfif isdefined("arguments.class_id") and len(arguments.class_id)>
			AND A.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.class_id#">
			</cfif>
		ORDER BY 
			A.RECORD_DATE DESC 	
    </cfquery>
    <cfreturn get_training_asset>
</cffunction>
