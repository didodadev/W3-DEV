<cfcomponent>
    <cfset dsn = application.SystemParam.SystemParam().dsn>

    <cffunction name="get_xml_files_f" access="public" returntype="query">
        <cfargument name="xml_id" default="" required="no">
        <cfquery name="get_xml_files" datasource="#DSN#">
            SELECT * FROM WEX_FILES<cfif len(arguments.xml_id)> WHERE WEX_FILE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.xml_id#"></cfif>
        </cfquery>
        <cfreturn get_xml_files>
    </cffunction>

    <cffunction name="add_file_info_f" access="public" returntype="any">
        <cfargument name="file_path" default="">
        <cfargument name="desciription" default="">
        <cfargument name="root" default="">
        <cfargument name="item" default="">
        <cfargument name="money_type" default="">
        <cfquery name="add_file_info" datasource="#dsn#" result="add_r">
            INSERT INTO 
                WEX_FILES <!--- WEX_FILE_PATH --->
                (
                    WEX_FILE_NAME,
                    WEX_FILE_PATH,
                    WEX_DETAIL,
                    WEX_ROOT,
                    WEX_ITEM,
                    WEX_MONEY_TYPE,
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_IP
                )
            VALUES
                (
                    '',
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.file_path#">,
                    <cfif len(arguments.desciription)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.desciription#"><cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.root#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.item#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.money_type#">,
                    #now()#,
                    #session.ep.userid#,
                    '#cgi.remote_addr#'
                )
        </cfquery>
        <cfreturn add_r>
    </cffunction>

    <cffunction name="upd_file_info_f" access="public">
        <cfargument name="file_name" default="">
        <cfargument name="xml_id" default="">
        <cfquery name="upd_file_info" datasource="#dsn#">
            UPDATE 
                WEX_FILES
            SET
                WEX_FILE_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.file_name#">
            WHERE
                WEX_FILE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.xml_id#">
        </cfquery>
    </cffunction>

    <cffunction name="add_rows_f" access="public">
        <cfargument name="xml_id" default="">
        <cfargument name="text_id" default="">
        <cfargument name="text_name" default="">
        <cfquery name="add_rows" datasource="#dsn#">
			INSERT INTO
				WEX_FILES_ROWS
				(
                    WEX_FILE_ID,
                    WEX_ROW_ID,
                    WEX_ROW_TEXT_NAME
				)
			VALUES
				(
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.xml_id#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.text_id#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.text_name#">
				)
		</cfquery>
    </cffunction>

    <cffunction name="DEL_PRODUCT_XML_F" access="public">
        <cfargument name="xml_id" default="">
        <cfquery name="DEL_XML_FILES" datasource="#dsn#">
            DELETE FROM WEX_FILES WHERE WEX_FILE_ID  = #arguments.xml_id#
        </cfquery>
        <cfquery name="DEL_XML_FILES_ROWS" datasource="#dsn#">
            DELETE FROM WEX_FILES_ROWS WHERE WEX_FILE_ID  = #arguments.xml_id#
        </cfquery>
    </cffunction>

    <cffunction name="GET_PRODUCT_PRICE_F" access="public" returntype="query">
        <cfargument name="dsn1" default="">
        <cfargument name="dsn_alias" default="">
        <cfargument name="dsn3_alias" default="">
        <cfargument name="dsn1_alias" default="">
        <cfargument name="dsn2_alias" default="">
        <cfargument name="period_id" default="">
        <cfargument name="price_catid" default="">
        <cfquery name="GET_PRODUCT_PRICE" datasource="#arguments.dsn1#">
            SELECT
                P.PRODUCT_ID AS PRODUCT_ID,
                P.PRODUCT_CODE_2 AS URUNKODU,
                S.STOCK_ID,
                S.STOCK_CODE_2 AS STOCKCODE,
                P.PRODUCT_NAME AS LABEL,
                PS.PRICE AS PRICE1,
                PS.MONEY AS CURRENCYABBR,
                'BELIRSIZ' AS MAINCATEGORY,
                '' AS CATEGORYTREE,
                0 AS DM3,
                0 AS PRICEPSF,
                '' AS BRAND,
                '' AS CATEGORY,
                '' AS SUBCATEGORY,
                '' AS DETAILS,
                P.TAX AS TAX,
                '' AS BUYINGPRICE,
                (PS.PRICE_KDV * (SELECT SM.RATE2/SM.RATE1 FROM #arguments.dsn_alias#.SETUP_MONEY SM WHERE SM.MONEY_STATUS = 1 AND SM.MONEY = PS.MONEY AND SM.PERIOD_ID = #arguments.period_id#)) AS CONVERTED_TL_PRICE_KDV,
                #arguments.dsn_alias#.uf_listgetat(P.PRODUCT_CODE,1,'.') AS FIRST_LEVEL_CATEGORY,
                #arguments.dsn_alias#.uf_listgetat(P.PRODUCT_CODE,1,'.') + '.' + #arguments.dsn_alias#.uf_listgetat(P.PRODUCT_CODE,2,'.') AS SECOND_LEVEL_CATEGORY,
                #arguments.dsn_alias#.uf_listgetat(P.PRODUCT_CODE,1,'.') + '.' + #arguments.dsn_alias#.uf_listgetat(P.PRODUCT_CODE,2,'.') + '.' + #arguments.dsn_alias#.uf_listgetat(P.PRODUCT_CODE,3,'.') AS THIRD_LEVEL_CATEGORY,
                P.PRODUCT_DETAIL AS PRODUCT_DETAIL_INFO,
                S.STOCK_CODE_2 AS BARCODE,
                PU.MAIN_UNIT AS STOCKTYPE,
                PU.DIMENTION AS PRODUCT_DESI,
                <cfif isDefined("arguments.price_catid") and len(arguments.price_catid) and (arguments.price_catid neq -1) and (arguments.price_catid neq -2)>
                    PR.PRICE AS SECOND_PRICE,
                <cfelse>
                    PS.PRICE AS SECOND_PRICE,
                </cfif>
                (GT.SALEABLE_STOCK + ISNULL((SELECT TOP 1 CASE WHEN (PIP.PROPERTY2 = '' OR PIP.PROPERTY2 IS NULL) THEN 0 ELSE PIP.PROPERTY2 END AS PROPERTY2 FROM #arguments.dsn3_alias#.PRODUCT_INFO_PLUS PIP WHERE S.PRODUCT_ID=PIP.PRODUCT_ID),0)) AS STOCKAMOUNT,
                p.SHELF_LIFE AS WARRANTY,
                (SELECT SUPPORT_DURATION FROM #arguments.dsn3_alias#.PRODUCT_GUARANTY PG WHERE PG.PRODUCT_ID = P.PRODUCT_ID) AS WARRANTY_ASIL,
                (SELECT TOP 1 PATH FROM #arguments.dsn1_alias#.PRODUCT_IMAGES PI WHERE PI.PRODUCT_ID = S.PRODUCT_ID AND (LIST_NO = 1 OR LIST_NO IS NULL)) AS PICTURE1PATH,
                (SELECT TOP 1 PATH FROM #arguments.dsn1_alias#.PRODUCT_IMAGES PI WHERE PI.PRODUCT_ID = S.PRODUCT_ID AND (LIST_NO = 2 OR LIST_NO IS NULL)) AS PICTURE2PATH,
                (SELECT TOP 1 PATH FROM #arguments.dsn1_alias#.PRODUCT_IMAGES PI WHERE PI.PRODUCT_ID = S.PRODUCT_ID AND (LIST_NO = 3 OR LIST_NO IS NULL)) AS PICTURE3PATH,
                (SELECT TOP 1 PATH FROM #arguments.dsn1_alias#.PRODUCT_IMAGES PI WHERE PI.PRODUCT_ID = S.PRODUCT_ID AND (LIST_NO = 4 OR LIST_NO IS NULL)) AS PICTURE4PATH,
                (SELECT TOP 1 PATH FROM #arguments.dsn1_alias#.PRODUCT_IMAGES PI WHERE PI.PRODUCT_ID = S.PRODUCT_ID AND (LIST_NO = 5 OR LIST_NO IS NULL)) AS PICTURE5PATH,
                (SELECT TOP 1 PATH FROM #arguments.dsn1_alias#.PRODUCT_IMAGES PI WHERE PI.PRODUCT_ID = S.PRODUCT_ID AND (LIST_NO = 6 OR LIST_NO IS NULL)) AS PICTURE6PATH,
                (SELECT PROVISION_TIME FROM #arguments.dsn3_alias#.STOCK_STRATEGY SS WHERE SS.STOCK_ID = S.STOCK_ID) AS SHIPPING_TIME,
                ICERIK.CONT_HEAD AS CONTENTHEAD,
                ICERIK.CONT_BODY AS ACIKLAMA,
                ICERIK.CONT_SUMMARY AS CONTENTSUMMARY,
                ICERIK.CONTENT_ID AS CONTENTID,
                (SELECT 
                    TOP 1 PRICE
                FROM 
                    #arguments.dsn3_alias#.PRICE PR
                WHERE 
                    PR.PRODUCT_ID = P.PRODUCT_ID AND
                    ISNULL(PR.STOCK_ID,0)=0 AND
                    ISNULL(PR.SPECT_VAR_ID,0)=0 AND
                    PR.PRICE_CATID = 9 AND
                    PR.STARTDATE <= #now()# AND
                    (PR.FINISHDATE >= #now()# OR PR.FINISHDATE IS NULL)) AS PRICE2,
                (SELECT 
                    TOP 1 PRICE
                FROM 
                    #arguments.dsn3_alias#.PRICE PR
                WHERE 
                    PR.PRODUCT_ID = P.PRODUCT_ID AND
                    ISNULL(PR.STOCK_ID,0)=0 AND
                    ISNULL(PR.SPECT_VAR_ID,0)=0 AND
                    PR.PRICE_CATID = 10 AND
                    PR.STARTDATE <= #now()# AND
                    (PR.FINISHDATE >= #now()# OR PR.FINISHDATE IS NULL)) AS PRICE3
                
            FROM
                PRODUCT P
                LEFT JOIN PRODUCT_BRANDS PB ON P.BRAND_ID = PB.BRAND_ID
                OUTER APPLY 
                (
                    SELECT TOP 1
                        C.CONT_HEAD,
                        C.CONT_BODY,
                        C.CONT_SUMMARY,
                        C.CONTENT_ID
                    FROM
                        #arguments.dsn_alias#.CONTENT C,
                        #arguments.dsn_alias#.CONTENT_RELATION PCR
                    WHERE
                        C.CONTENT_ID = PCR.CONTENT_ID AND
                        PCR.ACTION_TYPE_ID IS NOT NULL AND
                        PCR.ACTION_TYPE = 'PRODUCT_ID' AND
                        PCR.ACTION_TYPE_ID = P.PRODUCT_ID
                ) AS ICERIK
                ,
                STOCKS S,
                PRICE_STANDART PS,
                PRODUCT_CAT PC,
                PRODUCT_UNIT PU,
                <cfif isDefined("arguments.price_catid") and len(arguments.price_catid) and (arguments.price_catid neq -1) and (arguments.price_catid neq -2)>
                    #arguments.dsn3_alias#.PRICE PR,
                </cfif>
                    #arguments.dsn2_alias#.GET_STOCK_LAST GT
                <cfif isdefined("session.ep.isBranchAuthorization") and session.ep.isBranchAuthorization>
                       ,PRODUCT_BRANCH PBR
                </cfif>
            WHERE
                P.PRODUCT_ID=S.PRODUCT_ID AND
                <cfif isDefined("arguments.price_catid") and len(arguments.price_catid) and (arguments.price_catid eq -1)>
                    PS.PURCHASESALES = 0 AND
                <cfelse>
                    PS.PURCHASESALES = 1 AND
                </cfif>
                P.PRODUCT_STATUS = 1 AND
                P.IS_INTERNET = 1 AND
                PS.PRICESTANDART_STATUS = 1 AND
                P.PRODUCT_ID = PS.PRODUCT_ID AND
                PC.PRODUCT_CATID = P.PRODUCT_CATID AND
                P.PRODUCT_ID = PU.PRODUCT_ID AND
                PU.IS_MAIN=1 AND
                <cfif isDefined("arguments.price_catid") and len(arguments.price_catid) and (arguments.price_catid neq -1) and (arguments.price_catid neq -2)>
                    PR.PRODUCT_ID = P.PRODUCT_ID AND
                    ISNULL(PR.STOCK_ID,0)=0 AND
                    ISNULL(PR.SPECT_VAR_ID,0)=0 AND
                    PR.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.price_catid#"> AND
                    PR.STARTDATE <= #now()# AND
                    (PR.FINISHDATE >= #now()# OR PR.FINISHDATE IS NULL) AND
                </cfif>
                <cfif isdefined("session.ep.isBranchAuthorization") and session.ep.isBranchAuthorization>
                    AND PBR.PRODUCT_ID = P.PRODUCT_ID
                    AND PBR.BRANCH_ID IN  (SELECT
                                                B.BRANCH_ID
                                            FROM 
                                                #arguments.dsn_alias#.BRANCH B, 
                                                #arguments.dsn_alias#.EMPLOYEE_POSITION_BRANCHES EPB
                                            WHERE 
                                                EPB.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND
                                                EPB.BRANCH_ID = B.BRANCH_ID )
                </cfif>
                P.PRODUCT_ID = GT.PRODUCT_ID
        </cfquery>
        <cfreturn GET_PRODUCT_PRICE>
    </cffunction>

    <cffunction name="get_product_images_f" access="public" returntype="query">
        <cfargument name="dsn1_alias" default="">
        <cfargument name="PRODUCT_ID" default="">
        <cfquery name="get_product_images" datasource="#dsn#">
            SELECT LIST_NO,REPLACE(PATH,'documents/product/','') AS PATH FROM #arguments.dsn1_alias#.PRODUCT_IMAGES PI WHERE PI.PRODUCT_ID = #arguments.PRODUCT_ID# ORDER BY ISNULL(LIST_NO,999) ASC
        </cfquery>
        <cfreturn get_product_images>
    </cffunction>

    <cffunction name="GET_WO_FILE_PATH" access="public" returntype="query">
        <cfargument name="full_fuseaction" default="">
        <cfquery name="get_wo_filePath" datasource="#dsn#">
            SELECT FILE_PATH FROM WRK_OBJECTS WHERE FULL_FUSEACTION = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.full_fuseaction#">
        </cfquery>
        <cfreturn get_wo_filePath>
    </cffunction>
</cfcomponent>