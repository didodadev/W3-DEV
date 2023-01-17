<cfcomponent>

    <cfset dsn = application.systemParam.systemParam().dsn>
	<cfset dsn3="#dsn#_#session.ep.company_id#">
    <cfset dsn2="#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cfset dsn1="#dsn#_product">

    <cffunction name="get_prodreq_list" access="public">
        <cfargument name="project_id" default="">
        <cfargument name="company_id" default="">
        <cfargument name="consumer_id" default="">
        <cfargument name="start_date_order" default="">
        <cfargument name="finish_date_order" default="">
        <cfargument name="start_date" default="">
        <cfargument name="finish_date" default="">

        <cfquery name="query_list" datasource="#dsn3#">
            SELECT NMN.COMPANY_ORDER_NO, NMN.PROJECT_HEAD, NMN.PROJECT_COMPANY, 
            ASSET.ASSET_ID, ASSET.ASSETCAT_ID, ASSET.ASSET_FILE_NAME,
            PRD.PRODUCT_ID, PRD.PRODUCT_NAME, PRD.PRODUCT_CODE, PRD.PRODUCT_CODE_2,
            ORD.ORDER_NUMBER, ORD.ORDER_DATE, ORD.ORDER_ID, PRM.AMOUNT, PUN.ADD_UNIT,
            PRM.MARGIN, NMN.REQ_TYPE_ID, ORD.COMPANY_ID, ORD.CONSUMER_ID, PRM.PRODREQID

            FROM TEXTILE_PRODUCTION_REQUEST_MAIN PRM
            LEFT OUTER JOIN ORDER_ROW ORW ON PRM.ORDER_ID = ORW.ORDER_ID
            LEFT OUTER JOIN ORDERS ORD ON PRM.ORDER_ID = ORD.ORDER_ID
            LEFT OUTER JOIN #dsn1#.PRODUCT PRD ON ORW.PRODUCT_ID = PRD.PRODUCT_ID
            LEFT OUTER JOIN #dsn1#.PRODUCT_UNIT PUN ON PRD.PRODUCT_ID = PUN.PRODUCT_ID
            OUTER APPLY (
                SELECT
                    TOP 1 
                        R.REQ_ID,
                        R.REQ_NO,
                        R.REQ_TYPE_ID,
                        R.COMPANY_ORDER_NO,
                        R.COMPANY_MODEL_NO,
                        PRO_PROJECTS.PROJECT_HEAD,
                        COMPANY.FULLNAME AS PROJECT_COMPANY
                    FROM
                        TEXTILE_SAMPLE_REQUEST R
                        LEFT JOIN #dsn#.PRO_PROJECTS ON  PRO_PROJECTS.PROJECT_ID=R.PROJECT_ID
                        LEFT JOIN #dsn#.COMPANY ON COMPANY.COMPANY_ID=PRO_PROJECTS.COMPANY_ID
                        WHERE 
                            R.REQ_ID=ORW.RELATED_ACTION_ID
                            <cfif len(arguments.project_id)>
                                and PRO_PROJECTS.PROJECT_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.project_id#'>
                            </cfif>
            ) NMN
            OUTER APPLY (
                SELECT
                    TOP 1 
                    ASSET_ID,
                    ASSETCAT_ID,
                    ASSET_FILE_NAME
                FROM
                    #dsn#.ASSET
                WHERE
                    ACTION_SECTION = 'REQ_ID' AND 
                    ACTION_ID = NMN.REQ_ID AND
                    IS_IMAGE = 1 AND
                    MODULE_NAME='textile'
                ORDER BY ASSET_ID
            ) ASSET
            WHERE
            ORW.RELATED_ACTION_TABLE='TEXTILE_SAMPLE_REQUEST' AND
            ORW.ORDER_ROW_CURRENCY = -5 AND
            NMN.REQ_ID IS NOT NULL
            <cfif len(arguments.company_id)>
                AND ORD.COMPANY_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.company_id#'>
            </cfif>
            <cfif len(arguments.consumer_id)>
                AND ORD.CONSUMER_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.consumer_id#'>
            </cfif>
            <cfif len(arguments.start_date_order)>
                AND ORD.ORDER_DATE >= '#arguments.start_date_order#'
            </cfif>
            <cfif len(arguments.finish_date_order)>
                AND ORD.ORDER_DATE <= '#arguments.finish_date_order#'
            </cfif>
            GROUP BY
            NMN.COMPANY_ORDER_NO, NMN.PROJECT_HEAD, NMN.PROJECT_COMPANY, 
            ASSET.ASSET_ID, ASSET.ASSETCAT_ID, ASSET.ASSET_FILE_NAME,
            PRD.PRODUCT_ID, PRD.PRODUCT_NAME, PRD.PRODUCT_CODE, PRD.PRODUCT_CODE_2,
            ORD.ORDER_NUMBER, ORD.ORDER_DATE, ORD.ORDER_ID, PRM.AMOUNT, PUN.ADD_UNIT,
            PRM.MARGIN, NMN.REQ_TYPE_ID, ORD.COMPANY_ID, ORD.CONSUMER_ID, PRM.PRODREQID
        </cfquery>

        <cfreturn query_list>
    </cffunction>

    <cffunction name="set_prodreq" access="public">
        <cfargument name="order_id" default="">
        <cfargument name="project_id" default="">
        <cfargument name="req_id" default="">
        <cfargument name="amount" default="">
        <cfargument name="is_send" default="0">

        <cfquery name="query_set" datasource="#dsn3#">
            INSERT INTO TEXTILE_PRODUCTION_REQUEST_MAIN
                (ORDER_ID
                ,PROJECT_ID
                ,REQ_ID
                ,AMOUNT
                ,IS_SEND
                ,RECORD_DATE
                ,RECORD_EMP
                ,RECORD_IP
                ,UPDATE_DATE
                ,UPDATE_EMP
                ,UPDATE_IP)
            VALUES
                (<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.order_id#' null="#len(arguments.order_id)?'no':'yes'#">,
                ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.project_id#' null="#len(arguments.project_id)?'no':'yes'#">
                ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.req_id#' null="#len(arguments.req_id)?'no':'yes'#">
                ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.amount#' null="#len(arguments.amount)?'no':'yes'#">
                ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.is_send#'>
                ,#now()#
                ,#session.ep.userid#
                ,'#cgi.REMOTE_ADDR#'
        </cfquery>
    </cffunction>

    <cffunction name="upd_prodreq" access="public">
        <cfargument name="prodreq_id">
        <cfargument name="order_id" default="">
        <cfargument name="project_id" default="">
        <cfargument name="req_id" default="">
        <cfargument name="amount" default="">
        <cfargument name="is_send" default="0">
        
        <cfquery name="query_upd" datasource="#dsn3#">
            UPDATE TEXTILE_PRODUCTION_REQUEST_MAIN
            SET RECORD_DATE = RECORD_DATE
            <cfif len(arguments.order_id)>
                ,ORDER_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.order_id#'>
            </cfif>
            <cfif len(arguments.project_id)>
                ,PROJECT_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.project_id#'>
            </cfif>
            <cfif len(arguments.req_id)>
                ,REQ_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.req_id#'>
            </cfif>
            <cfif len(arguments.amount)>
                ,AMOUNT = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.amount#'>
            </cfif>
            <cfif len(arguments.is_send)>
                ,IS_SEND = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.is_send#'>
            </cfif>
                ,UPDATE_DATE = #now()#
                ,UPDATE_EMP = #session.ep.userid#
                ,UPDATE_IP = '#cgi.REMOTE_ADDR#'
            WHERE PRODREQID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.prodreq_id#'>
        </cfquery>
    </cffunction>

    <cffunction name="del_prodreq" access="public">
        <cfargument name="prodreq_id">

        <cfquery name="query_del" datasource="#dsn3#">
            DELETE FROM TEXTILE_PRODUCTION_REQUEST_MAIN
            WHERE PRODREQID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.prodreq_id#'>
        </cfquery>
    </cffunction>

    <cffunction name="get_sample_request_type" access="public">
        <cfquery name="query_sample_request_type" datasource="#DSN3#">
            SELECT
                OPPORTUNITY_TYPE_ID,
                CASE
                    WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
                    ELSE OPPORTUNITY_TYPE
                END AS OPPORTUNITY_TYPE
            FROM
                SETUP_OPPORTUNITY_TYPE
                LEFT JOIN #dsn#.SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = SETUP_OPPORTUNITY_TYPE.OPPORTUNITY_TYPE_ID
                AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="OPPORTUNITY_TYPE">
                AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_OPPORTUNITY_TYPE">
                AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
            ORDER BY
                OPPORTUNITY_TYPE
        </cfquery>
        <cfreturn query_sample_request_type>
    </cffunction>

    <cffunction name="get_company_names">
        <cfargument name="compids">
        <cfargument name="consumerids">
        <cfquery name="query_companies" datasource="#dsn#">
            <cfif len(arguments.compids)>
            SELECT 1 AS CTYPE, FULLNAME, COMPANY_ID FROM COMPANY WHERE COMPANY_ID IN (#arguments.compids#)
            </cfif>
            <cfif len(arguments.compids) and len(arguments.consumerids)>
            UNION
            </cfif>
            <cfif len(arguments.consumerids)>
            SELECT 2 AS CTYPE, CONSUMER_NAME + ' ' + CONSUMER_SURNAME AS FULLNAME, CONSUMER_ID AS COMPANY_ID FROM CONSUMER WHERE CONSUMER_ID IN (#arguments.consumerids#)
            </cfif>
        </cfquery>
        <cfreturn query_companies>
    </cffunction>

</cfcomponent>