<cfquery name="GET_ASSET" datasource="#DSN#">
	SELECT 
        ASSET.MODULE_NAME,
        ASSET.MODULE_ID,
        ASSET.ACTION_SECTION,
        ASSET.ACTION_ID,
        ASSET.ACTION_VALUE,
        ASSET.ASSETCAT_ID,
        ASSET.ASSET_ID,
        ASSET.ASSET_FILE_NAME,
        ASSET.ASSET_FILE_SIZE,
        ASSET.ASSET_FILE_SERVER_ID,
        ASSET.ASSET_FILE_FORMAT,
        ASSET.ASSET_NAME,
        ASSET.ASSET_DESCRIPTION,
        ASSET.ASSET_DETAIL,
        ASSET.PROPERTY_ID,
        ASSET.COMPANY_ID,
        ASSET.RECORD_DATE,
        ASSET.RECORD_PAR,
        ASSET.RECORD_PUB,
        ASSET.RECORD_EMP,
        ASSET.RECORD_IP,
        ASSET.UPDATE_DATE,
        ASSET.UPDATE_PAR,
        ASSET.UPDATE_PUB,
        ASSET.UPDATE_EMP,
        ASSET.UPDATE_IP,
        ASSET.IS_INTERNET,
        ASSET.SERVER_NAME,
        ASSET.DEPARTMENT_ID,
        ASSET.BRANCH_ID,
        ASSET.IS_IMAGE,
        ASSET.IMAGE_SIZE,
        ASSET.IS_SPECIAL,
        ASSET.RESPONSED_ASSET_ID,
        ASSET.IS_LIVE,
        ASSET.FEATURED,
        ASSET.DURATION,
        ASSET.RATING,
        ASSET.DOWNLOAD_COUNT,
        ASSET.COMMENT_COUNT,
        ASSET.FAVORITE_COUNT,
        ASSET.RATING_COUNT,
        ASSET.CONSUMER_ID,
        ASSET.ASSET_FILE_REAL_NAME,
        ASSET.ASSET_FILE_PATH_NAME,
        ASSET.ASSET_STAGE,
        ASSET.MAIL_RECEIVER_ID,
        ASSET.MAIL_CC_ID,
        ASSET.MAIL_RECEIVER_IS_EMP,
        ASSET.MAIL_CC_IS_EMP,
        ASSET.ASSET_NO,
        ASSET.EMBEDCODE_URL,
        ASSET.PERIOD_ID,
        ASSET.PROJECT_ID,
        ASSET.RECORD_CON,
        ISNULL(ASSET.REVISION_NO,0) REVISION_NO,
        ASSET.IS_DPL,
        ASSET.IS_ACTIVE,
        ASSET.PRODUCT_ID,
        (SELECT COALESCE(PRO.PRODUCT_CODE_2 +' - ' +PRO.PRODUCT_NAME,PRO.PRODUCT_NAME) FROM #DSN3#.PRODUCT PRO WHERE ASSET.PRODUCT_ID = PRO.PRODUCT_ID) PRODUCT_NAME,
		ASSET_CAT.ASSETCAT,
		ASSET_CAT.ASSETCAT_ID,
        ASSET.LIVE,
        ASSET.RELATED_ASSET_ID,
		ASSET.RELATED_COMPANY_ID,
		ASSET.RELATED_CONSUMER_ID,
        ASSET.PROJECT_MULTI_ID,
        ASSET.VALIDATE_START_DATE,
        ASSET.VALIDATE_FINISH_DATE,
        ASSET.PASSWORD
	FROM 
		ASSET,
		ASSET_CAT
	WHERE
		ASSET.ASSETCAT_ID = ASSET_CAT.ASSETCAT_ID AND
		ASSET.ASSET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.asset_id#">
</cfquery>
