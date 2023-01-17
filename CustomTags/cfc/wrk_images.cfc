<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn1 = '#application.systemParam.systemParam().dsn#_product'>
    <cfset dsn3 = '#dsn#_#session.ep.company_id#'>
    <cffunction name="GET_IMAGES" access="remote" returntype="query">
        <cfquery name="GET_IMAGES" datasource="#DSN1#">
            SELECT 
                PI.IMAGE_SIZE,
                PI.PRODUCT_IMAGEID,
                PI.PATH,
                PI.PRD_IMG_NAME AS NAME,
                PI.DETAIL,
                PI.PATH_SERVER_ID,
                PI.STOCK_ID,
                PI.IS_EXTERNAL_LINK,
                PI.VIDEO_LINK,
                PI.VIDEO_PATH,
                PI.IMAGE_SIZE,
                P.PRODUCT_NAME
            FROM
                PRODUCT_IMAGES PI,
                PRODUCT P
            WHERE
                P.PRODUCT_ID = PI.PRODUCT_ID AND
                PI.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pid#">
            ORDER BY
                PI.PRODUCT_IMAGEID DESC   
        </cfquery>
        <cfreturn GET_IMAGES>
    </cffunction> 
    <cffunction name="GET_BRANDS_IMAGES" access="remote" returntype="query">
        <cfquery name="GET_BRANDS_IMAGES" datasource="#DSN1#">
            SELECT 
                PBI.IMAGE_SIZE,
                PBI.BRAND_IMAGEID AS PRODUCT_IMAGEID,
                PBI.PATH,
                PI.PRD_IMG_NAME AS NAME,
                PBI.DETAIL,
                PBI.PATH_SERVER_ID,
                PBI.IS_EXTERNAL_LINK,
                PB.BRAND_NAME
            FROM
                PRODUCT_BRANDS_IMAGES PBI,
                PRODUCT_BRANDS PB
            WHERE
                PB.BRAND_ID = PBI.BRAND_ID AND
                PBI.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.brand_id#">
            ORDER BY
                PRODUCT_IMAGEID DESC
        </cfquery>
        <cfreturn GET_BRANDS_IMAGES>
    </cffunction> 
    <cffunction name="GET_IMAGE_CONT" access="remote" returntype="query">
        <cfquery name="GET_IMAGE_CONT" datasource="#DSN#">
                SELECT 
                    CNT_IMG_NAME AS NAME,
                    CONTIMAGE_ID, 
                    CONTIMAGE_SMALL AS PATH, 
                    IMAGE_SERVER_ID,
                    IMAGE_SIZE, 
                    IS_EXTERNAL_LINK,
                    PATH AS VIDEO_PATH, 
                    VIDEO_LINK
                FROM 
                    CONTENT_IMAGE 
                WHERE 
                    CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.contentId#">
        </cfquery>
        <cfreturn GET_IMAGE_CONT>
    </cffunction> 
    <cffunction name="GET_STOCKS" access="remote" returntype="query">
        <cfquery name="GET_STOCKS" datasource="#DSN1#">
            SELECT STOCK_CODE,STOCK_ID,PROPERTY FROM STOCKS WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stocksId#">
        </cfquery>
        <cfreturn GET_STOCKS>
    </cffunction>
    <cffunction name="GET_LANGUAGE" access="remote" returntype="query">
        <cfquery name="GET_LANGUAGE" datasource="#DSN#">
            SELECT LANGUAGE_SHORT,LANGUAGE_SET FROM SETUP_LANGUAGE ORDER BY LANGUAGE_ID ASC
        </cfquery>
        <cfreturn GET_LANGUAGE>
    </cffunction>

    
    <cffunction name="GET_IMAGE_" access="remote" returntype="query">
        <cfquery name="GET_IMAGE_" datasource="#DSN1#">
            SELECT 
            PRODUCT_ID
            ,PRODUCT_IMAGEID 
            ,PATH
            ,#dsn#.#dsn#.Get_Dynamic_Language(#arguments.action_id#,'#ucase(session.ep.language)#','#table#','DETAIL',NULL,NULL,DETAIL) AS DETAIL
            ,IMAGE_SIZE
            ,UPDATE_DATE
            ,UPDATE_EMP
            ,UPDATE_IP
            ,PROPERTY_ID
            ,UPDATE_PAR
            ,IS_INTERNET
            ,PATH_SERVER_ID
            ,STOCK_ID
            ,IS_EXTERNAL_LINK
            ,LANGUAGE_ID
            ,VIDEO_LINK
            ,VIDEO_PATH
            ,LIST_NO
            ,#dsn#.#dsn#.Get_Dynamic_Language(#arguments.action_id#,'#ucase(session.ep.language)#','#table#','PRD_IMG_NAME',NULL,NULL,PRD_IMG_NAME) AS PRD_IMG_NAME
             FROM #table#
              WHERE #arguments.identity_column# = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
        </cfquery>
        
        <cfreturn GET_IMAGE_>
    </cffunction>
 
    <cffunction name="GET_IMAGE_CONTENT" access="remote" returntype="query">
        <cfquery name="GET_IMAGE_CONTENT" datasource="#DSN#">
                SELECT 
                    CNT_IMG_NAME AS NAME,
                    CONTIMAGE_ID, 
                    CONTIMAGE_SMALL AS PATH, 
                    IMAGE_SERVER_ID,
                    IMAGE_SIZE, 
                    IS_EXTERNAL_LINK,
                    PATH AS VIDEO_PATH, 
                    VIDEO_LINK,
                    LANGUAGE_ID,
                    CNT_IMG_NAME ,
                    DETAIL,
                    UPDATE_EMP,
                    UPDATE_DATE,
                    CONTENT_ID 
                FROM 
                    CONTENT_IMAGE 
                WHERE 
                    CONTIMAGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
        </cfquery>
        <cfreturn GET_IMAGE_CONTENT>
    </cffunction> 

    <cffunction name="GET_TRAINING_CLASS_IMG" access="remote" returntype="query">
        <cfargument name="class_id" default="#action_id#">
        <cfquery name="GET_TRAINING_CLASS_IMG" datasource="#DSN#">
                SELECT 
                    CLASS_ID,
                    PATH,
                    IS_EXTERNAL_LINK,
                    TRN_IMG_NAME AS NAME,
                    TRN_IMG_DETAIL AS DETAIL,
                    IMAGE_SIZE,
                    VIDEO_PATH,
                    VIDEO_LINK,
                    UPDATE_DATE,
                    UPDATE_EMP,
                    UPDATE_IP,
                    LANGUAGE AS LANGUAGE_ID
                FROM 
                    TRAINING_CLASS 
                WHERE 
                    CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.class_id#">
        </cfquery>
        <cfreturn GET_TRAINING_CLASS_IMG>
    </cffunction> 

    <cffunction name="GET_TRAINING_SUBJECT_IMG" access="remote" returntype="query">
        <cfargument name="train_id" default="#action_id#">
        <cfquery name="GET_TRAINING_SUBJECT_IMG" datasource="#DSN#">
                SELECT 
                    TRAIN_ID,
                    PATH,
                    IS_EXTERNAL_LINK,
                    TRN_IMG_NAME AS NAME,
                    TRN_IMG_DETAIL AS DETAIL,
                    IMAGE_SIZE,
                    VIDEO_PATH,
                    VIDEO_LINK,
                    UPDATE_DATE,
                    UPDATE_EMP,
                    UPDATE_IP,
                    LANGUAGE AS LANGUAGE_ID
                FROM 
                    TRAINING 
                WHERE 
                    TRAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.train_id#">
        </cfquery>
        <cfreturn GET_TRAINING_SUBJECT_IMG>
    </cffunction> 

    <cffunction name="DEL_TRAINING_IMG" access="remote" returntype="any"  result="query_result">
        <cfargument name="class_id" default="#action_id#">
        <cfquery name="DEL_TRAINING_IMG" datasource="#DSN#">
            UPDATE 
                TRAINING_CLASS 
            SET 
                IMAGE_SIZE = NULL,
                TRN_IMG_NAME = NULL,
                PATH=NULL,
                TRN_IMG_DETAIL=NULL,
                IS_EXTERNAL_LINK=NULL,
                VIDEO_LINK=NULL,
                VIDEO_PATH=NULL 
            WHERE CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.class_id#">
        </cfquery>
        <cfreturn DEL_TRAINING_IMG>
    </cffunction>

    <cffunction name="GET_TRAINING_CLASS_GROUPS_IMG" access="remote" returntype="query">
        <cfargument name="train_group_id" default="#action_id#">
        <cfquery name="GET_TRAINING_CLASS_GROUPS_IMG" datasource="#DSN#">
                SELECT 
                    TRAIN_GROUP_ID,
                    PATH,
                    IS_EXTERNAL_LINK,
                    TRN_IMG_NAME AS NAME,
                    TRN_IMG_DETAIL AS DETAIL,
                    IMAGE_SIZE,
                    VIDEO_PATH,
                    VIDEO_LINK,
                    UPDATE_DATE,
                    UPDATE_EMP,
                    UPDATE_IP,
                    LANGUAGE AS LANGUAGE_ID
                FROM 
                    TRAINING_CLASS_GROUPS 
                WHERE 
                    TRAIN_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.train_group_id#">
        </cfquery>
        <cfreturn GET_TRAINING_CLASS_GROUPS_IMG>
    </cffunction> 

    <cffunction name="DEL_TRAINING_GROUP_IMG" access="remote" returntype="any"  result="query_result">
        <cfargument name="train_group_id" default="#action_id#">
        <cfquery name="DEL_TRAINING_GROUP_IMG" datasource="#DSN#">
            UPDATE 
                TRAINING_CLASS_GROUPS 
            SET 
                IMAGE_SIZE = NULL,
                TRN_IMG_NAME = NULL,
                PATH=NULL,
                TRN_IMG_DETAIL=NULL,
                IS_EXTERNAL_LINK=NULL,
                VIDEO_LINK=NULL,
                VIDEO_PATH=NULL 
            WHERE TRAIN_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.train_group_id#">
        </cfquery>
        <cfreturn DEL_TRAINING_GROUP_IMG>
    </cffunction>

    <cffunction name="DEL_TRAIN_SUBJECT_IMG" access="remote" returntype="any"  result="query_result">
        <cfargument name="train_id" default="#action_id#">
        <cfquery name="DEL_TRAIN_SUBJECT_IMG" datasource="#DSN#">
            UPDATE 
                TRAINING 
            SET 
                IMAGE_SIZE = NULL,
                TRN_IMG_NAME = NULL,
                PATH=NULL,
                TRN_IMG_DETAIL=NULL,
                IS_EXTERNAL_LINK=NULL,
                VIDEO_LINK=NULL,
                VIDEO_PATH=NULL 
            WHERE TRAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.train_id#">
        </cfquery>
        <cfreturn DEL_TRAIN_SUBJECT_IMG>
    </cffunction>
    <cffunction name="GET_PRODUCT_SAMPLE_IMAGE" access="remote" returntype="query">
        <cfquery name="GET_PRODUCT_SAMPLE_IMAGE" datasource="#dsn3#">
                SELECT 
                PRODUCT_SAMPLE_IMAGE_ID 
                ,PRODUCT_SAMPLE_ID
                , PRODUCT_SAMPLE_FILE_NAME  AS PATH
                , IS_EXTERNAL_LINK 
                , PRODUCT_SAMPLE_IMG_NAME AS NAME
                , PRODUCT_SAMPLE_IMG_DETAIL  AS DETAIL
                , IMAGE_SIZE 
                ,IMAGE_SERVER_ID
                , VIDEO_PATH 
                , VIDEO_LINK 
                , LANGUAGE_ID 
                , UPDATE_EMP 
                , UPDATE_DATE 
                , UPDATE_IP 
                FROM 
                PRODUCT_SAMPLE_IMAGE 
                WHERE 
                PRODUCT_SAMPLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PRODUCT_SAMPLE_ID#">
        </cfquery>
        <cfreturn GET_PRODUCT_SAMPLE_IMAGE>
    </cffunction> 
    <cffunction name="GET_PRODUCT_SAMPLE_IMG" access="remote" returntype="query">
        
        <cfquery name="GET_PRODUCT_SAMPLE_IMG" datasource="#dsn3#">
                SELECT 
                PRODUCT_SAMPLE_IMAGE_ID 
                ,PRODUCT_SAMPLE_ID
                , PRODUCT_SAMPLE_FILE_NAME AS PATH
                , IS_EXTERNAL_LINK 
                , PRODUCT_SAMPLE_IMG_NAME AS NAME
                , PRODUCT_SAMPLE_IMG_DETAIL  AS DETAIL
                , IMAGE_SIZE 
                , VIDEO_PATH 
                ,IMAGE_SERVER_ID
                , VIDEO_LINK 
                , LANGUAGE_ID 
                , UPDATE_EMP 
                , UPDATE_DATE 
                , UPDATE_IP 
                FROM 
                PRODUCT_SAMPLE_IMAGE 
                WHERE 
                PRODUCT_SAMPLE_IMAGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
        </cfquery>
        <cfreturn GET_PRODUCT_SAMPLE_IMG>
    </cffunction> 
</cfcomponent>