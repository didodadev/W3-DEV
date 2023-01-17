<cfquery name="get_video" datasource="#dsn#">
	SELECT
		ASSET.MODULE_NAME,
		ASSET.ACTION_SECTION,
		ASSET.ACTION_ID,
		ASSET.ASSET_ID,
		ASSET.ASSET_NAME,
		ASSET.ASSET_FILE_NAME,
		ASSET.ASSET_FILE_PATH_NAME,
		ASSET.ASSET_FILE_SERVER_ID,
		ASSET.ASSET_FILE_SIZE,
		ASSET.RECORD_DATE,
		ASSET.RECORD_PUB,
		ASSET.RECORD_EMP,
		ASSET.RECORD_PAR,
		ASSET.SERVER_NAME,
		ASSET.UPDATE_DATE,
		ASSET.UPDATE_EMP,
		ASSET.UPDATE_PAR,
		ASSET_CAT.ASSETCAT,
		ASSET_CAT.ASSETCAT_PATH,
		ASSET.ASSET_DETAIL,
		ASSET.ASSET_DESCRIPTION,
		ASSET.ASSETCAT_ID,
		ASSET.PROPERTY_ID,
		ASSET.DURATION,
		ASSET.IS_LIVE, 
		ASSET.RATING, 
		ASSET.FEATURED, 
		ASSET.DOWNLOAD_COUNT, 
		ASSET.COMMENT_COUNT, 
		ASSET.FAVORITE_COUNT, 
		ASSET.RATING_COUNT, 
		ASSET.CONSUMER_ID,
		ASSET_CAT.ASSETCAT,
		ASSET.ASSETCAT_ID
	FROM
		ASSET
		RIGHT JOIN ASSET_CAT ON ASSET.ASSETCAT_ID = ASSET_CAT.ASSETCAT_ID 
		LEFT JOIN ASSET_SITE_DOMAIN ON ASSET_SITE_DOMAIN.ASSET_ID = ASSET.ASSET_ID 
	WHERE
		ASSET.ASSET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.video_id#"> AND 
		ASSET.ASSET_FILE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.flv%"> AND 
		ASSET.IS_INTERNET = 1 
</cfquery>
