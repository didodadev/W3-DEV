
<cfcomponent>    
    <cfif isdefined("session.pp")>
        <cfset session_base = evaluate('session.pp')>
        <cfset company_id = session.pp.our_company_id>
        <cfset period_year = session.pp.period_year>
        <cfset language = session.pp.language>
    <cfelseif isdefined("session.ep")>
        <cfset session_base = evaluate('session.ep')>
        <cfset company_id = session.ep.our_company_id>
        <cfset period_year = session.ep.period_year>
        <cfset language = session.ep.language>
    <cfelseif isdefined("session.cp")>
        <cfset session_base = evaluate('session.cp')>
    <cfelseif isdefined("session.ww")>
        <cfset session_base = evaluate('session.ww')>
        <cfset company_id = session.ww.our_company_id>
        <cfset period_year = session.ww.period_year>
        <cfset language = session.ww.language>
    <cfelse>
        <cfset session_base = evaluate('session.qq')>
        <cfset company_id = session.qq.our_company_id>
        <cfset period_year = session.qq.period_year>
        <cfset language = session.qq.language>
    </cfif>
    
    <cfset dsn = application.systemParam.systemParam().dsn>
	<cfset dsn1_alias = "#dsn#_product">

    <cffunction name="GET_BANNER" returntype="query">
        <cfargument name="banner_id" type="any">
        <cfargument name="product_id" type="any">
        <cfargument name="camp_id" type="numeric">
        <cfargument name="slider_max_number" type="string">
        <cfargument name="content_cat_id" type="string">
        <cfargument name="content_chap_id" type="string">
        <cfargument name="start_date" type="date" required="yes" default="#now()#">
        <cfargument name="site" default="">
        <cfargument name="banner_type" default="">
        <cfquery name="GET_BANNER" datasource="#DSN#">
            SELECT <cfif isdefined('slider_max_number') and len(slider_max_number)>TOP #slider_max_number#</cfif>
                CB.BANNER_ID,
                CB.BANNER_FILE,
                CB.MOBILE_BANNER_FILE,
                CB.URL_PATH,
                CB.URL,
                CB.BANNER_TARGET,
                CB.BANNER_NAME,
                CB.DETAIL,
                CB.CONTENT,
                CB.BANNER_PRODUCT_ID,
                CB.BANNER_PRODUCTCAT_ID,
                CB.BANNER_BRAND_ID,
                C.CONT_HEAD,
                C.CONT_SUMMARY,
                C.CONT_BODY,
                C.CONTENT_ID,
                CCAT.CONTENTCAT,
                CCAT.CONTENTCAT_ID,
                CC.CHAPTER,
                CC.CHAPTER_ID,
                P.PRODUCT_ID,
                COALESCE(SLIPN.ITEM,P.PRODUCT_NAME) AS PRODUCT_NAME,
                P.PRODUCT_CODE_2,
                COALESCE(SLIPD.ITEM,P.PRODUCT_DETAIL) AS PRODUCT_DETAIL,
                COALESCE(SLIPD2.ITEM,P.PRODUCT_DETAIL2) AS PRODUCT_DETAIL2,
                UFU.USER_FRIENDLY_URL                
            FROM
                CONTENT_CHAPTER AS CC, 
                CONTENT_CAT AS CCAT,                
                CONTENT_BANNERS CB
                LEFT JOIN CONTENT AS C ON CB.CONTENT_ID = C.CONTENT_ID
                    OUTER APPLY(
                    SELECT TOP 1 UFU.USER_FRIENDLY_URL 
                    FROM #dsn#.USER_FRIENDLY_URLS UFU 
                    WHERE UFU.ACTION_TYPE = 'cntid' 
                    AND UFU.ACTION_ID = C.CONTENT_ID 		
                    AND UFU.PROTEIN_SITE = #arguments.site#
                    AND OPTIONS_DATA LIKE '%"LANGUAGE":"%#session_base.language#%"%') UFU 
                LEFT JOIN #dsn1_alias#.PRODUCT AS P ON CB.BANNER_PRODUCT_ID = P.PRODUCT_ID
                LEFT JOIN #dsn#.SETUP_LANGUAGE_INFO SLIPN 
                        ON SLIPN.UNIQUE_COLUMN_ID = P.PRODUCT_ID 
                        AND SLIPN.COLUMN_NAME ='PRODUCT_NAME'
                        AND SLIPN.TABLE_NAME = 'PRODUCT'
                        AND SLIPN.LANGUAGE = '#session_base.language#' 
                LEFT JOIN #dsn#.SETUP_LANGUAGE_INFO SLIPD
                    ON SLIPD.UNIQUE_COLUMN_ID = P.PRODUCT_ID 
                    AND SLIPD.COLUMN_NAME ='PRODUCT_DETAIL'
                    AND SLIPD.TABLE_NAME = 'PRODUCT'
                    AND SLIPD.LANGUAGE = '#session_base.language#'
                LEFT JOIN #dsn#.SETUP_LANGUAGE_INFO SLIPD2
                    ON SLIPD2.UNIQUE_COLUMN_ID = P.PRODUCT_ID 
                    AND SLIPD2.COLUMN_NAME ='PRODUCT_DETAIL2'
                    AND SLIPD2.TABLE_NAME = 'PRODUCT'
                    AND SLIPD2.LANGUAGE = '#session_base.language#'
                LEFT JOIN CONTENT_BANNERS_USERS AS CBU ON CB.BANNER_ID = CBU.BANNER_ID            
            WHERE            
                <cfif isdefined("arguments.banner_id") and len(arguments.banner_id)>
                    CB.BANNER_ID IN (<cfqueryparam value="#arguments.banner_id#" cfsqltype="cf_sql_integer" list="true">) AND
                </cfif>
                <cfif isdefined("arguments.content_cat_id") and len(arguments.content_cat_id)>
                    CCAT.CONTENTCAT_ID IN (<cfqueryparam value="#arguments.content_cat_id#" cfsqltype="cf_sql_integer" list="true">) AND
                </cfif>
                <cfif isdefined("arguments.content_chap_id") and len(arguments.content_chap_id)>
                    CB.CHAPTER_ID IN (<cfqueryparam value="#arguments.content_chap_id#" cfsqltype="cf_sql_integer" list="true">) AND
                </cfif>
                <cfif isdefined("arguments.product_id") and len(arguments.product_id) and listLen(attributes.product_id) eq 1>
                    P.PRODUCT_ID IN (<cfqueryparam value="#arguments.product_id#" cfsqltype="cf_sql_integer" list="yes">) AND
                </cfif>
                <cfif isdefined("arguments.site") and len(arguments.site) >
                    <cfif not len(arguments.banner_id)>
                        CB.MENU_ID = <cfqueryparam value="#arguments.site#" cfsqltype="cf_sql_integer"> AND
                        CB.LANGUAGE LIKE <cfqueryparam value="%#session_base.language#%" cfsqltype="cf_sql_varchar"> AND
                    </cfif>
                    CBU.CONSCAT_ID = <cfqueryparam value="#arguments.site#" cfsqltype="cf_sql_integer"> AND
                </cfif>
                <cfif isDefined("arguments.banner_type") and arguments.banner_type eq 1>
                    CB.BANNER_AREA_ID = 1 AND
                </cfif>                
                <cfif isDefined("arguments.banner_type") and arguments.banner_type eq 2>
                    CB.BANNER_AREA_ID = 2 AND
                </cfif>                
                <cfif isDefined("arguments.banner_type") and arguments.banner_type eq 3>
                    CB.BANNER_AREA_ID = 3 AND
                </cfif>                
                <cfif isDefined("arguments.banner_type") and arguments.banner_type eq 4>
                    CB.BANNER_AREA_ID = 4 AND
                </cfif>                
                CB.CHAPTER_ID = CC.CHAPTER_ID AND
                CB.CONTENTCAT_ID = CCAT.CONTENTCAT_ID AND                
                CB.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#start_date#"> 
                AND CB.IS_ACTIVE = 1
            ORDER BY
                <cfif isDefined("arguments.slide_sort") and arguments.slide_sort eq 0>
                    CB.RECORD_DATE DESC
                <cfelseif isDefined("arguments.slide_sort") and arguments.slide_sort eq 1>
                    CB.UPDATE_DATE DESC
                <cfelseif isDefined("arguments.slide_sort") and arguments.slide_sort eq 2>
                    CB.RECORD_DATE ASC
                <cfelse>
                    CB.START_DATE DESC
                </cfif>    
                
        </cfquery>
        <cfreturn GET_BANNER>
    </cffunction>
    
    <cffunction name="GET_LAST_3_SPOT" returntype="query">
        <cfargument name="banner_id" type="string">
        <cfargument name="product_id" type="any">
        <cfargument name="slider_max_number" type="string">
        <cfargument name="content_cat_id" type="string">
        <cfargument name="content_chap_id" type="string">
        <cfargument name="start_date" type="date" required="yes" default="#now()#">
        <cfargument name="site" default="">
        <cfargument name="banner_type" default="">
        <cfquery name="GET_LAST_3_SPOT" datasource="#DSN#">
            SELECT TOP 3
                CB.BANNER_ID,
                CB.BANNER_FILE,
                CB.URL_PATH,
                CB.URL,
                CB.BANNER_TARGET,
                CB.BANNER_NAME,
                CB.DETAIL,
                CB.CONTENT,
                CB.BANNER_PRODUCT_ID,
                CB.BANNER_PRODUCTCAT_ID,
                CB.BANNER_BRAND_ID,
                C.CONT_HEAD,
                C.CONT_SUMMARY,
                C.CONT_BODY,
                C.CONTENT_ID,
                C.SPOT,
                CCAT.CONTENTCAT,
                CCAT.CONTENTCAT_ID,
                CC.CHAPTER,
                CC.CHAPTER_ID,
                P.PRODUCT_ID,
                P.PRODUCT_NAME,
                P.PRODUCT_CODE_2,
                P.PRODUCT_DETAIL,
                P.PRODUCT_DETAIL2,
                UFU.USER_FRIENDLY_URL                
            FROM
                CONTENT_CHAPTER AS CC, 
                CONTENT_CAT AS CCAT,                
                CONTENT_BANNERS CB
                LEFT JOIN CONTENT AS C ON CB.CONTENT_ID = C.CONTENT_ID
                    OUTER APPLY(
                    SELECT TOP 1 UFU.USER_FRIENDLY_URL 
                    FROM #dsn#.USER_FRIENDLY_URLS UFU 
                    WHERE UFU.ACTION_TYPE = 'cntid' 
                    AND UFU.ACTION_ID = C.CONTENT_ID 		
                    AND UFU.PROTEIN_SITE = #arguments.site#) UFU 
                LEFT JOIN #dsn1_alias#.PRODUCT AS P ON CB.BANNER_PRODUCT_ID = P.PRODUCT_ID
                LEFT JOIN CONTENT_BANNERS_USERS AS CBU ON CB.BANNER_ID = CBU.BANNER_ID            
            WHERE            
                <cfif isdefined("arguments.banner_id") and len(arguments.banner_id)>
                    CB.BANNER_ID IN (<cfqueryparam value="#arguments.banner_id#" cfsqltype="cf_sql_integer" list="true">) AND
                </cfif>
                <cfif isdefined("arguments.content_cat_id") and len(arguments.content_cat_id)>
                    CCAT.CONTENTCAT_ID IN (<cfqueryparam value="#arguments.content_cat_id#" cfsqltype="cf_sql_integer" list="true">) AND
                </cfif>
                <cfif isdefined("arguments.content_chap_id") and len(arguments.content_chap_id)>
                    CB.CHAPTER_ID IN (<cfqueryparam value="#arguments.content_chap_id#" cfsqltype="cf_sql_integer" list="true">) AND
                </cfif>
                <cfif isdefined("arguments.product_id") and len(arguments.product_id)>
                    P.PRODUCT_ID = <cfqueryparam value="#arguments.product_id#" cfsqltype="cf_sql_integer"> AND
                </cfif>  
                <cfif isdefined("arguments.site") and len(arguments.site)>
                    CBU.CONSCAT_ID = <cfqueryparam value="#arguments.site#" cfsqltype="cf_sql_integer"> AND
                </cfif>
                <cfif isDefined("arguments.banner_type") and arguments.banner_type eq 1>
                    CB.BANNER_AREA_ID = 1 AND
                </cfif>                
                <cfif isDefined("arguments.banner_type") and arguments.banner_type eq 2>
                    CB.BANNER_AREA_ID = 2 AND
                </cfif>                
                <cfif isDefined("arguments.banner_type") and arguments.banner_type eq 3>
                    CB.BANNER_AREA_ID = 3 AND
                </cfif>                
                <cfif isDefined("arguments.banner_type") and arguments.banner_type eq 4>
                    CB.BANNER_AREA_ID = 4 AND
                </cfif>                
                CB.CHAPTER_ID = CC.CHAPTER_ID AND
                CB.CONTENTCAT_ID = CCAT.CONTENTCAT_ID AND                
                CB.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#start_date#"> 
                AND CB.IS_ACTIVE = 1
                AND C.SPOT = 1
            ORDER BY
                CB.START_DATE DESC
        </cfquery>
        <cfreturn GET_LAST_3_SPOT>
    </cffunction>
</cfcomponent>