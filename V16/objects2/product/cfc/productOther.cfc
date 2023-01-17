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
    <cfset dsn1 = '#dsn#_product'>
    <cfset dsn2 = '#dsn#_#session_base.period_year#_#session_base.our_company_id#'>
    <cfset dsn3 = '#dsn#_#session_base.our_company_id#'>

    <cffunction name="GET_ALTERNATE_PRODUCT" access="remote" returntype="any" hint="Alternatif Ürünleri Getirir">
        <cfargument name="pid" required="true" type="integer">
        <cfargument name="maxrows" required="false" type="any">
        <cfquery name="GET_ALTERNATE_PRODUCT" datasource="#DSN3#">
            SELECT
                <cfif IsDefined("arguments.maxrows") and len(arguments.maxrows)>
                TOP #arguments.maxrows#
                </cfif>
                AP.ALTERNATIVE_PRODUCT_ID,
                P.PRODUCT_NAME,
                P.PRODUCT_DETAIL,
                P.PRODUCT_DETAIL2,
                P.PRODUCT_ID,
                S.STOCK_ID,
                S.PROPERTY,
                PS.PRICE,
                PS.PRICE_KDV,
                PS.MONEY,
                PC.PRODUCT_CAT,
                (SELECT TOP 1 PIMG.PATH FROM PRODUCT_IMAGES PIMG WHERE P.PRODUCT_ID = PIMG.PRODUCT_ID AND (PIMG.IMAGE_SIZE = 0 OR PIMG.IMAGE_SIZE =1 OR PIMG.IMAGE_SIZE = 2)) AS IMAGE_PATH,
                '' AS SORTER
            FROM
                PRODUCT P,
                PRICE_STANDART PS,
                STOCKS S, 
                ALTERNATIVE_PRODUCTS AP,
                PRODUCT_CAT PC,
                #dsn1#.PRODUCT_CAT_OUR_COMPANY PCO
            WHERE
                PS.PRODUCT_ID = AP.ALTERNATIVE_PRODUCT_ID AND
                PS.PRICESTANDART_STATUS = 1 AND
                PS.PURCHASESALES = 1 AND
                PCO.PRODUCT_CATID = PC.PRODUCT_CATID AND
                PCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#"> AND
                S.PRODUCT_ID = P.PRODUCT_ID AND
                AP.ALTERNATIVE_PRODUCT_ID = P.PRODUCT_ID AND
                AP.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pid#"> AND
                P.PRODUCT_CATID = PC.PRODUCT_CATID AND
                <cfif isdefined("session.pp")>P.IS_EXTRANET = 1 AND<cfelse>P.IS_INTERNET = 1 AND</cfif>
                P.PRODUCT_STATUS = 1 AND
                S.STOCK_STATUS = 1
        </cfquery>
        <cfreturn GET_ALTERNATE_PRODUCT>
    </cffunction>

    <cffunction name="GET_RELATED_PRODUCT" access="remote" returntype="any" hint="Ürünle İlişkili Ürünleri Getirir">
        <cfargument name="site" default="">
        <cfquery name="GET_RELATED_PRODUCT" datasource="#DSN3#">
            WITH T1 AS(SELECT 
                P.PRODUCT_ID,
                P.PRODUCT_NAME,
                P.PRODUCT_DETAIL,
                P.PRODUCT_DETAIL2,
                <cfif isDefined("arguments.site") and len(arguments.site)> UFU.USER_FRIENDLY_URL,<cfelse>
                P.USER_FRIENDLY_URL,
                S.STOCK_ID,
                S.PRODUCT_UNIT_ID,
                S.PROPERTY,
                </cfif>
                PS.PRICE,
                PS.PRICE_KDV,
                PS.MONEY,
                <!--- IMAGE_SIZE 0 , 1 OR 2 --->
                (SELECT TOP 1 PI.PATH FROM PRODUCT_IMAGES PI WHERE PI.PRODUCT_ID = P.PRODUCT_ID AND  (PI.IMAGE_SIZE = 0 OR PI.IMAGE_SIZE =1 OR PI.IMAGE_SIZE = 2)) PIMAGE,
                <!---IMAGE_SIZE 3 - Icon - logo --->
                ISNULL((SELECT TOP 1 PI.PATH FROM PRODUCT_IMAGES PI WHERE PI.PRODUCT_ID = P.PRODUCT_ID AND  PI.IMAGE_SIZE = 3),0) PIMAGEICON 
            FROM 
                RELATED_PRODUCT RP,
                PRODUCT P
                <cfif isDefined("arguments.site") and len(arguments.site)>
                OUTER APPLY(
                        SELECT TOP 1 UFU.USER_FRIENDLY_URL 
                        FROM #dsn#.USER_FRIENDLY_URLS UFU 
                        WHERE UFU.ACTION_TYPE = 'PRODUCT_ID' 
                    AND UFU.ACTION_ID = P.PRODUCT_ID 		
                    AND UFU.PROTEIN_SITE = #arguments.site#) UFU
                </cfif>
                <cfif isdefined("arguments.last_user_price_list") and len(arguments.last_user_price_list) and isnumeric(arguments.last_user_price_list)>
                    ,PRICE AS PS,
                <cfelse>
                    ,PRICE_STANDART PS,
                </cfif>
                 <cfif not len(arguments.site)>
                STOCKS S,
                PRODUCT_UNIT PU,
                </cfif>
                PRODUCT_CAT PC,
                #dsn1#.PRODUCT_CAT_OUR_COMPANY PCO
            WHERE 
                PS.PRODUCT_ID = RP.RELATED_PRODUCT_ID AND
                PCO.PRODUCT_CATID = PC.PRODUCT_CATID AND
                <cfif not len(arguments.site)>
                PU.PRODUCT_ID = S.PRODUCT_ID AND
                S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                PU.IS_MAIN = 1 AND
                </cfif>
                <cfif isdefined("session.ep")>
                    PCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                <cfelse>
                    PCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#"> AND
                </cfif>
                <cfif isdefined("arguments.last_user_price_list") and len(arguments.last_user_price_list) and isnumeric(arguments.last_user_price_list)>
                    PS.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.last_user_price_list#"> AND
                    PS.PRICE > <cfqueryparam value="0" cfsqltype="cf_sql_float"> AND
                    PS.PRODUCT_ID = S.PRODUCT_ID AND
                    ISNULL(PS.STOCK_ID,0)=0 AND
                    ISNULL(PS.SPECT_VAR_ID,0)=0 AND
                    (PS.FINISHDATE IS NULL OR PS.FINISHDATE >= #NOW()#) AND
                    PU.PRODUCT_UNIT_ID = PS.UNIT AND
                <cfelse>
                    PS.PRICE ><cfqueryparam value="0" cfsqltype="cf_sql_float"> AND
                    PS.PRICESTANDART_STATUS = 1	AND
                    PS.PURCHASESALES = 1 AND
                <!---  PU.PRODUCT_UNIT_ID = PS.UNIT_ID AND --->
                </cfif>	
                <cfif not len(arguments.site)>
                S.PRODUCT_ID = P.PRODUCT_ID AND
                RP.RELATED_PRODUCT_ID = S.PRODUCT_ID AND
                <cfelse>
                RP.RELATED_PRODUCT_ID = P.PRODUCT_ID AND
                </cfif>
                RP.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pid#"> AND
                P.PRODUCT_CATID = PC.PRODUCT_CATID AND
                <!---PC.IS_PUBLIC = 1 AND---> <!--- İlişkili ürünler gelmiyordu.Test etmek için yoruma alındı. ---->
                <cfif isdefined("session.pp")>P.IS_EXTRANET = 1 AND<cfelse>P.IS_INTERNET = 1 AND</cfif>
                P.PRODUCT_STATUS = 1
            )
            
            SELECT
                T.PRODUCT_ID,
                COALESCE(SLIPD.ITEM,T.PRODUCT_DETAIL) AS PRODUCT_DETAIL,
                COALESCE(SLIPD2.ITEM,T.PRODUCT_DETAIL2) AS PRODUCT_DETAIL2,
                COALESCE(SLIPN.ITEM,T.PRODUCT_NAME) AS PRODUCT_NAME,
                <cfif isDefined("arguments.site") and len(arguments.site)>T.USER_FRIENDLY_URL,<cfelse>
                    T.USER_FRIENDLY_URL,
                    T.STOCK_ID,
                    T.PRODUCT_UNIT_ID,
                    T.PROPERTY,
                </cfif>
                T.PRICE,
                T.PRICE_KDV,
                T.MONEY,                
                T.PIMAGE,
                T.PIMAGEICON                 
            FROM
            T1 T
            LEFT JOIN #dsn#.SETUP_LANGUAGE_INFO SLIPN 
                ON SLIPN.UNIQUE_COLUMN_ID = T.PRODUCT_ID 
                AND SLIPN.COLUMN_NAME ='PRODUCT_NAME'
                AND SLIPN.TABLE_NAME = 'PRODUCT'
                AND SLIPN.LANGUAGE = '#session_base.language#'
            LEFT JOIN #dsn#.SETUP_LANGUAGE_INFO SLIPD 
                ON SLIPD.UNIQUE_COLUMN_ID = T.PRODUCT_ID 
                AND SLIPD.COLUMN_NAME ='PRODUCT_DETAIL'
                AND SLIPD.TABLE_NAME = 'PRODUCT'
                AND SLIPD.LANGUAGE = '#session_base.language#'
            LEFT JOIN #dsn#.SETUP_LANGUAGE_INFO SLIPD2
                ON SLIPD2.UNIQUE_COLUMN_ID = T.PRODUCT_ID 
                AND SLIPD2.COLUMN_NAME ='PRODUCT_DETAIL2'
                AND SLIPD2.TABLE_NAME = 'PRODUCT'
                AND SLIPD2.LANGUAGE = '#session_base.language#'
        </cfquery>
        <cfreturn GET_RELATED_PRODUCT>
    </cffunction>

    <cffunction name="GET_RELATED_MIXED_PRODUCT" access="remote" returntype="any" hint="Ürünle İlişkili Karma Kolileri Getirir">
        <cfquery name="GET_RELATED_MIXED_PRODUCT" datasource="#DSN1#">
            SELECT
                <!--- IMAGE_SIZE 0 , 1 OR 2 --->
                (SELECT TOP 1 PI.PATH FROM PRODUCT_IMAGES PI WHERE PI.PRODUCT_ID = KP.PRODUCT_ID AND  (PI.IMAGE_SIZE = 0 OR PI.IMAGE_SIZE =1 OR PI.IMAGE_SIZE = 2)) PIMAGE,
                <!---IMAGE_SIZE 3 - Icon - logo --->
                ISNULL((SELECT TOP 1 PI.PATH FROM PRODUCT_IMAGES PI WHERE PI.PRODUCT_ID = KP.PRODUCT_ID AND  PI.IMAGE_SIZE = 3),0) PIMAGEICON,                
                KP.KARMA_PRODUCT_ID,
                KP.PRODUCT_ID,
                KP.STOCK_ID,
                KP.PRODUCT_AMOUNT,
                KP.UNIT,
                P.PRODUCT_DETAIL,
                P.PRODUCT_CODE_2,
                COALESCE(SLIPN.ITEM,KP.PRODUCT_NAME) AS PRODUCT_NAME,
                UFU.USER_FRIENDLY_URL          
            FROM 
                #dsn1#.KARMA_PRODUCTS AS KP
                LEFT JOIN PRODUCT AS PK ON KP.KARMA_PRODUCT_ID = PK.PRODUCT_ID
                LEFT JOIN PRODUCT AS P ON KP.PRODUCT_ID = P.PRODUCT_ID
                LEFT JOIN #dsn#.SETUP_LANGUAGE_INFO SLIPN 
                        ON SLIPN.UNIQUE_COLUMN_ID = KP.PRODUCT_ID 
                        AND SLIPN.COLUMN_NAME ='PRODUCT_NAME'
                        AND SLIPN.TABLE_NAME = 'PRODUCT'
                        AND SLIPN.LANGUAGE = '#session_base.language#' 
                <cfif isdefined('arguments.site')>OUTER APPLY(
                    SELECT TOP 1 UFU.USER_FRIENDLY_URL 
                    FROM #dsn#.USER_FRIENDLY_URLS UFU 
                    WHERE UFU.ACTION_TYPE = 'PRODUCT_ID' 
                    AND UFU.ACTION_ID = KP.PRODUCT_ID 		
                    AND UFU.PROTEIN_SITE = #arguments.site#
                    AND OPTIONS_DATA LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value='%"LANGUAGE":"#session_base.language#"%'>) UFU</cfif>               
            WHERE
                PK.IS_KARMA = 1 AND                
                PK.PRODUCT_STATUS = 1 AND                
                KP.KARMA_PRODUCT_ID = #arguments.pid#                
        </cfquery>
        <cfreturn GET_RELATED_MIXED_PRODUCT>
    </cffunction>
    <cffunction name="GET_RELATED_MIXED_CONTENT" access="remote" returntype="any" hint="Ürünle İlişkili içerikleri Getirir">
        <cfquery name="GET_RELATED_MIXED_CONTENT" datasource="#DSN#">
            SELECT 
			CONTENT_RELATION.*, 
			C.CONT_HEAD,
			C.CONT_SUMMARY,
			C.CONT_BODY,
			C.IS_DSP_HEADER,
			C.IS_DSP_SUMMARY,
			C.USER_FRIENDLY_URL,
			C.CONTENT_PROPERTY_ID,
            UFU.USER_FRIENDLY_URL,
            (SELECT TOP 1 CI.CONTIMAGE_SMALL FROM CONTENT_IMAGE CI WHERE C.CONTENT_ID = CI.CONTENT_ID AND (CI.IMAGE_SIZE = 0 OR CI.IMAGE_SIZE =1 OR CI.IMAGE_SIZE = 2) ORDER BY <cfif isDefined("UPDATE_DATE") and len(UPDATE_DATE)>UPDATE_DATE<cfelse>RECORD_DATE</cfif> DESC) AS CONTIMAGE_SMALL_NEW
		FROM 
			CONTENT_RELATION 
            LEFT JOIN CONTENT C ON CONTENT_RELATION.CONTENT_ID = C.CONTENT_ID
            <cfif isdefined('arguments.site')>
                OUTER APPLY(
                    SELECT 
                        TOP 1 UFU.USER_FRIENDLY_URL 
                    FROM
                        #dsn#.USER_FRIENDLY_URLS UFU 
                    WHERE 
                        UFU.ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="cntid"> AND
                        UFU.ACTION_ID = CONTENT_RELATION.CONTENT_ID AND
                        UFU.PROTEIN_SITE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.site#"> AND
                        OPTIONS_DATA LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value='%"LANGUAGE":"%#session_base.language#%"%'>
                ) UFU
            </cfif>  
		WHERE 
			C.CONTENT_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="1"> AND
			C.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.language#"> AND
			CONTENT_RELATION.ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pid#"> AND
			CONTENT_RELATION.ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="PRODUCT_ID"> AND
			(INTERNET_VIEW = <cfqueryparam cfsqltype="cf_sql_bit" value="1"> OR C.COMPANY_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session_base.company_category#,%">) AND
            UFU.USER_FRIENDLY_URL IS NOT NULL
        </cfquery>
        <cfreturn GET_RELATED_MIXED_CONTENT>
    </cffunction>


</cfcomponent>