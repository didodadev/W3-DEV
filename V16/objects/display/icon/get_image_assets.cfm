<cfscript>
    ids = "";
	module = 1;
	for(ind = 1 ; ind lte ListLen(session.ep.user_level,",") ; ind = ind + 1){		
		if (not (ListGetAt(session.ep.user_level, ind) eq 0))	ids = ids & "," & module;
		module = module + 1;
	}
	ids = Right(ids,(Len(ids) - 1));
</cfscript>

<cfquery name="GET_ASSETSS" datasource="#dsn#">
		SELECT 
			ASSET.ASSET_ID                    ,
			ASSET.ASSET_NAME                  ,
			ASSET.ASSET_FILE_NAME             ,
			ASSET.ASSET_FILE_SIZE             ,
			ASSET.ASSET_FILE_SERVER_ID        ,
			ASSET.UPDATE_DATE                 ,
			ASSET.UPDATE_EMP                  ,
			ASSET.UPDATE_PAR                  ,			
			ASSET_CAT.ASSETCAT                ,
			ASSET_CAT.ASSETCAT_PATH           ,
			ASSET_DETAIL AS DESCRIPTION       ,
			ASSET.ASSETCAT_ID
		FROM 
			ASSET,
			ASSET_CAT
		WHERE
			ASSET.ASSETCAT_ID = ASSET_CAT.ASSETCAT_ID
			AND
			MODULE_ID IN (#ids#)
			AND
			(
			ASSET.ASSET_FILE_NAME LIKE '%jpg'
			OR
			ASSET.ASSET_FILE_NAME LIKE '%gif'
			OR
			ASSET.ASSET_FILE_NAME LIKE '%png'
			)				
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			AND
			(
			ASSET.ASSET_NAME LIKE '%#attributes.keyword#%'
			OR
			ASSET.ASSET_FILE_NAME LIKE '%#attributes.keyword#%'
			)
		</cfif>
	<cfif get_module_user(7)>	
		UNION ALL
		(
		<!--- içerik --->
			SELECT
				CONTIMAGE_ID AS ASSET_ID,
				CNT_IMG_NAME AS ASSET_NAME,
				CONTIMAGE_SMALL AS ASSET_FILE_NAME,
				ASSET_FILE_SIZE,
				IMAGE_SERVER_ID AS ASSET_FILE_SERVER_ID,
				UPDATE_DATE,
				UPDATE_EMP,
				UPDATE_PAR,
				'İçerik' AS ASSETCAT,
				'CONTENT' AS ASSETCAT_PATH,
				DETAIL AS DESCRIPTION,
				-7 AS ASSETCAT_ID
			FROM
				CONTENT_IMAGE
            WHERE			
			(
			CONTIMAGE_SMALL LIKE '%jpg'
			OR
			CONTIMAGE_SMALL LIKE '%gif'
			OR
			CONTIMAGE_SMALL LIKE '%png'
			)				
			<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			AND
				CONTIMAGE_SMALL LIKE '%#attributes.keyword#%'
			</cfif>
		)		
	</cfif>
	<cfif get_module_user(5)>	
		UNION ALL
		(
		<!--- içerik --->
			SELECT
				PRODUCT_IMAGEID AS ASSET_ID,
				'Product Image' AS ASSET_NAME,
				PATH AS ASSET_FILE_NAME,
				IMAGE_SIZE AS ASSET_FILE_SIZE,
				PATH_SERVER_ID AS ASSET_FILE_SERVER_ID,
				UPDATE_DATE,
				UPDATE_EMP,
				UPDATE_PAR,
				'Product' AS ASSETCAT,
				'product' AS ASSETCAT_PATH,
				DETAIL AS DESCRIPTION,
				-3 AS ASSETCAT_ID
			FROM
				#DSN3#.PRODUCT_IMAGES
            WHERE			
			(
			PATH LIKE '%jpg'
			OR
			PATH LIKE '%gif'
			OR
			PATH LIKE '%png'
			)				
			<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			AND
				PATH LIKE '%#attributes.keyword#%'
			</cfif>
		)		
	</cfif>			
</cfquery>
