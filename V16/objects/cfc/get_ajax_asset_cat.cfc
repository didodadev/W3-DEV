<!--- File: get_ajax_asset.cfc
    Author: -
    Date: 18.09.2019
    Controller: -
    Description: Dijital arsive sayfasi tüm kategoriler popup'ı icin sorgular cfc'ye tasindi
 --->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name = "DigitalAssetGroupPerm" access="public" returntype="query">
        <cfquery name ="digital_asset_group_perm" datasource = "#dsn#">
            SELECT 
                GROUP_ID 
            FROM 
                DIGITAL_ASSET_GROUP_PERM 
            WHERE 
                POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
        </cfquery>
         <cfreturn digital_asset_group_perm>
    </cffunction>    
    <cffunction name="GetAssetCat" access="public" returntype="query">
        <cfargument name="bottomCat" default="" required="no">
        <cfquery name = "get_asset_cat" datasource = "#dsn#">
            SELECT
                DISTINCT ASSCAT.ID,
                CASE
                    WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
                    ELSE ASSCAT.ASSETCAT
                END AS ASSETCAT,
                ASSCAT.ASSETCAT_ID,
                ASSCAT.ASSETCAT,
                ASSCAT.ASSETCAT_PATH,
                ASSCAT.ASSETCAT_DETAIL
            FROM
                ASSET_CAT ASSCAT
                LEFT JOIN SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = ASSCAT.ASSETCAT_ID
                AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="ASSETCAT">
                AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="ASSET_CAT">
                AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
                <cfif session.ep.admin neq 1 and isdefined("x_show_by_digital_asset_group") and x_show_by_digital_asset_group eq 1>
                JOIN DIGITAL_ASSET_GROUP_PERM DAGP
                    ON ASSCAT.ASSETCAT_ID = DAGP.ASSETCAT_ID 
                    AND DAGP.GROUP_ID IN (SELECT GROUP_ID FROM DIGITAL_ASSET_GROUP_PERM WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)  
                </cfif>
            WHERE 
                1 = 1
                <cfif len(arguments.bottomCat)>
                    AND ASSCAT.ASSETCAT_MAIN_ID = <cfqueryparam value = "#arguments.bottomCat#" cfsqltype="cf_sql_varchar">
                <cfelse>
                    AND ASSCAT.ASSETCAT_MAIN_ID IS NULL
                </cfif>
            ORDER BY ASSCAT.ASSETCAT ASC
        </cfquery>
        <cfreturn get_asset_cat>
    </cffunction>  
    <cffunction name="get_asset_cat_file" access="public" returntype="query">  
        <cfargument name="assetcat_id" default="" required="no">
        <cfquery name="get_asset_cat_file" datasource="#dsn#">         
            SELECT
                SUM(ASSET.ASSET_FILE_SIZE) AS SUM_FILE_SIZE, 
                COUNT(ASSET.ASSET_NO) AS ASSET_NO_COUNT
            FROM 
                ASSET,
                ASSET_CAT
            WHERE
                ASSET.ASSETCAT_ID = ASSET_CAT.ASSETCAT_ID 
                <cfif isDefined("arguments.assetcat_id") and len(arguments.assetcat_id)>
                    AND ASSET.ASSETCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.assetcat_id#">
                </cfif>
        </cfquery>
        <cfreturn get_asset_cat_file>
    </cffunction>
</cfcomponent>