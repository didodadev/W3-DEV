<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn3 = "#dsn#_#session.ep.company_id#">
    <cfset dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
		<cffunction name="GET_ASSET_CAT" returntype="query">
            <cfquery name="GET_ASSET_CAT" datasource="#dsn#">
                SELECT
                    AC.ASSETP_CAT,
                    A.ASSETP_CATID,
                    COUNT(*) AS COUNT_CAT,
                    SUM(COUNT(*)) OVER() AS total_count 
                FROM
                    ASSET_P A
                LEFT  JOIN ASSET_P_CAT AC ON AC.ASSETP_CATID = A.ASSETP_CATID
                WHERE
                    A.ASSETP_CATID <> ''
                    AND A.ASSETP_CATID is not null
                GROUP BY A.ASSETP_CATID,AC.ASSETP_CAT
            </cfquery>
            <cfreturn GET_ASSET_CAT>
        </cffunction>
		<cffunction name="GET_ASSET_STATUS" returntype="query">
            <cfquery name="GET_ASSET_STATUS" datasource="#dsn#">
                SELECT
                    AST.ASSET_STATE,
                    A.ASSETP_STATUS,
                    COUNT(*) AS COUNT_STATUS,
                    SUM(COUNT(*)) OVER() AS TOTAL_STATUS 
                FROM
                    ASSET_P A
                LEFT  JOIN ASSET_STATE AST ON AST.ASSET_STATE_ID=A.ASSETP_STATUS
                WHERE
                    A.ASSETP_STATUS <> ''
                    AND A.ASSETP_STATUS is not null
                GROUP BY A.ASSETP_STATUS,AST.ASSET_STATE
            </cfquery>
            <cfreturn GET_ASSET_STATUS>
        </cffunction>
		<cffunction name="GET_ASSET_PROPERTY" returntype="query">
            <cfquery name="GET_ASSET_PROPERTY" datasource="#dsn#">
                SELECT
                    A.PROPERTY,
                    COUNT(*) AS COUNT_PROPERTY,
                    SUM(COUNT(*)) OVER() AS TOTAL_PROPERTY 
                FROM
                    ASSET_P A
                
                WHERE
                    A.PROPERTY <> ''
                    AND A.PROPERTY is not null
                GROUP BY A.PROPERTY
            </cfquery>
            <cfreturn GET_ASSET_PROPERTY>
        </cffunction>
        <cffunction name="GET_ASSET_GROUP" returntype="query">
            <cfquery name="GET_ASSET_GROUP" datasource="#dsn#">
                SELECT
                    SAG.GROUP_NAME,
                    A.ASSETP_GROUP,
                    COUNT(*) AS COUNT_GROUP,
                    SUM(COUNT(*)) OVER() AS TOTAL_GROUP 
                FROM
                    ASSET_P A
                LEFT JOIN SETUP_ASSETP_GROUP SAG ON SAG.GROUP_ID=A.ASSETP_GROUP
                WHERE
                    A.ASSETP_GROUP <> ''
                    AND A.ASSETP_GROUP is not null
                GROUP BY A.ASSETP_GROUP,SAG.GROUP_NAME
            </cfquery>
            <cfreturn GET_ASSET_GROUP>
        </cffunction>
        <cffunction name="GET_ASSET_BRAND" returntype="query">
            <cfquery name="GET_ASSET_BRAND" datasource="#dsn#">
                SELECT
                    SB.BRAND_NAME,
                    A.BRAND_ID,
                    COUNT(*) AS COUNT_BRAND,
                    SUM(COUNT(*)) OVER() AS TOTAL_BRAND 
                FROM
                    ASSET_P A
                LEFT JOIN SETUP_BRAND SB ON SB.BRAND_ID=A.BRAND_ID
                WHERE
                    A.BRAND_ID <> ''
                    AND A.BRAND_ID is not null
                GROUP BY A.BRAND_ID,SB.BRAND_NAME
                ORDER BY COUNT(A.BRAND_ID) DESC
            </cfquery>
            <cfreturn GET_ASSET_BRAND>
        </cffunction>
        <cffunction name="get_failure_using_code" returntype="query">
            <cfquery name="get_failure_using_code" datasource="#dsn3#">
                SELECT
                    SETUP_SERVICE_CODE.SERVICE_CODE,
                    COUNT(*) AS COUNT_SERVICE,
                    SUM(COUNT(*)) OVER() AS TOTAL_SERVICE 
                FROM 
                    #dsn#.FAILURE_CODE_ROWS FAILURE_CODE_ROWS,
                    SETUP_SERVICE_CODE
                WHERE 
                    FAILURE_CODE_ROWS.FAILURE_CODE_ID = SETUP_SERVICE_CODE.SERVICE_CODE_ID
                    GROUP BY  SETUP_SERVICE_CODE.SERVICE_CODE
            </cfquery>
             <cfreturn get_failure_using_code>
        </cffunction>
        <cffunction name="get_asset_failure" returntype="query">
            <cfquery name="get_asset_failure" datasource="#dsn#">
                SELECT
                    A.ASSETP
                FROM
                    ASSET_FAILURE_NOTICE AFN,
                    ASSET_P A,
                    ASSET_CARE_CAT
                WHERE
                    A.STATUS IS NOT NULL
                    AND ASSET_CARE_CAT.ASSET_CARE_ID = AFN.ASSET_CARE_ID
                    AND A.ASSETP_ID = AFN.ASSETP_ID
                    GROUP BY  A.ASSETP
            </cfquery>
             <cfreturn get_asset_failure>
        </cffunction>
        <cffunction name="GET_EXPENSE" returntype="query">
            <cfquery name="GET_EXPENSE" datasource="#dsn2#">
                WITH t1 AS
                (
                    SELECT
                    MONTH(EP.EXPENSE_DATE) EXPENSE_MONTH
                    ,
                    ISNULL(SUM(EP.TOTAL_AMOUNT_KDVLI),0) AS TOPLAM
                    
                    FROM
                        EXPENSE_ITEM_PLANS EP
                        
                        left join #dsn3#.SETUP_PROCESS_CAT SPC on SPC.PROCESS_CAT_ID = EP.PROCESS_CAT
                    WHERE
                        SPC.PROCESS_CAT_ID =103
                
                    GROUP BY  MONTH(EP.EXPENSE_DATE)
                    UNION ALL
                            SELECT 1 EXPENSE_MONTH, 0 TOPLAM
                            UNION ALL
                            SELECT 2 EXPENSE_MONTH, 0 TOPLAM
                            UNION ALL
                            SELECT 3 EXPENSE_MONTH, 0 TOPLAM
                            UNION ALL
                            SELECT 4 EXPENSE_MONTH, 0 TOPLAM
                            UNION ALL
                            SELECT 5 EXPENSE_MONTH, 0 TOPLAM
                            UNION ALL
                            SELECT 6 EXPENSE_MONTH, 0 TOPLAM
                            UNION ALL
                            SELECT 7 EXPENSE_MONTH, 0 TOPLAM
                            UNION ALL
                            SELECT 8 EXPENSE_MONTH, 0 TOPLAM
                            UNION ALL
                            SELECT 9 EXPENSE_MONTH, 0 TOPLAM
                            UNION ALL
                            SELECT 10 EXPENSE_MONTH, 0 TOPLAM
                            UNION ALL
                            SELECT 11 EXPENSE_MONTH, 0 TOPLAM
                            UNION ALL
                            SELECT 12 EXPENSE_MONTH, 0 TOPLAM
                )
                SELECT
                            EXPENSE_MONTH,
                            ISNULL(SUM(TOPLAM),0) AS TOPLAM
                        FROM
                            t1
                        GROUP BY
                        EXPENSE_MONTH
            </cfquery>
             <cfreturn GET_EXPENSE>
        </cffunction>
        <cffunction name="total_expense" returntype="query">
            <cfquery name="total_expense" dbtype="query">
                SELECT
                    SUM(TOPLAM) AS TOTAL FROM GET_EXPENSE
            </cfquery>
             <cfreturn total_expense>
        </cffunction>
</cfcomponent>