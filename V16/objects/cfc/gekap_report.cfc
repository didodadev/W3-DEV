<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn1 = dsn & "_product">
    <cfset dsn2 = dsn & "_" & session.ep.period_year & "_" & session.ep.company_id>
    <cfset dsn3 = dsn & "_" & session.ep.company_id>
    <cfset dsn3_alias = dsn & "_" & session.ep.company_id>
    <cfset dsn_alias = dsn >
    <cfset dsn1_alias = dsn & "_product">
    <cffunction name = "getPeriods"  access="public" returntype="query">
        <cfquery name="GET_PERIODS" datasource="#dsn#">
            SELECT PERIOD_YEAR FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> ORDER BY PERIOD_YEAR DESC
        </cfquery>
        <cfreturn GET_PERIODS>
    </cffunction>
    <cffunction name="get_invoice" access="public" returntype="query">
		<cfargument name="year" default="">
		<cfargument name="period" default="">
		<cfargument name="invoice_cat" default="">
		<cfquery name="get_invoice" datasource="#dsn2#">
            SELECT 
                RSG.RECYCLE_GROUP_ID
                ,I.INVOICE_CAT
                ,SUM(IR.AMOUNT) AS SALES_QUANTITY,
                CASE WHEN RSG.KG_PRICE != 0 THEN SUM(IR.AMOUNT*RSG.KG_PRICE) ELSE SUM(IR.AMOUNT*RSG.NUMBER_PRICE) END AS SALES_TOTAL,
                MONTH(I.INVOICE_DATE) AS SALES_MONTH,
                P.COMPANY_ID
            FROM 
                INVOICE I
                JOIN INVOICE_ROW IR ON I.INVOICE_ID = IR.INVOICE_ID 
                JOIN #dsn1_alias#.PRODUCT P ON P.PRODUCT_ID = IR.PRODUCT_ID
                JOIN #dsn_alias#.RECYCLE_SUB_GROUP RSG ON P.RECYCLE_GROUP_ID = RSG.RECYCLE_SUB_GROUP_ID
            WHERE (I.INVOICE_CAT IN (52,53,531))
                AND IR.PRODUCT_ID IS NOT NULL
                AND P.RECYCLE_GROUP_ID IS NOT NULL
                AND RSG.RECYCLE_GROUP_ID = 3
                AND I.PURCHASE_SALES = 1
                <cfif isDefined('arguments.year') and len(arguments.year)>
                    AND YEAR(I.INVOICE_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.year#">
                </cfif>
                <cfif isDefined('arguments.period') and len(arguments.period) and len(arguments.startdate) and len(arguments.finishdate)>
                    AND I.INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startdate#"> 
                    AND I.INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finishdate#">
                </cfif>
            GROUP BY 
                RSG.RECYCLE_GROUP_ID		
                ,I.INVOICE_CAT
                ,RSG.KG_PRICE
                ,MONTH(I.INVOICE_DATE)
                ,P.COMPANY_ID
            UNION ALL
            SELECT 
                RSG.RECYCLE_GROUP_ID
                ,I.INVOICE_CAT
                ,SUM(IRP.AMOUNT) AS SALES_QUANTITY,
                CASE WHEN RSG.KG_PRICE != 0 THEN SUM(IRP.AMOUNT*RSG.KG_PRICE) ELSE SUM(IRP.AMOUNT*RSG.NUMBER_PRICE) END AS SALES_TOTAL,
                MONTH(I.INVOICE_DATE) AS SALES_MONTH,
                P.COMPANY_ID
            FROM 
                INVOICE I
                JOIN INVOICE_ROW_POS IRP ON I.INVOICE_ID = IRP.INVOICE_ID 
                LEFT JOIN #dsn1_alias#.PRODUCT P ON P.PRODUCT_ID = IRP.PRODUCT_ID
                LEFT JOIN #dsn_alias#.RECYCLE_SUB_GROUP RSG ON P.RECYCLE_GROUP_ID = RSG.RECYCLE_SUB_GROUP_ID
            WHERE (I.INVOICE_CAT IN (69))
                AND IRP.PRODUCT_ID IS NOT NULL
                AND P.RECYCLE_GROUP_ID IS NOT NULL
                AND RSG.RECYCLE_GROUP_ID = 3
                AND I.PURCHASE_SALES = 1
                <cfif isDefined('arguments.year') and len(arguments.year)>
                    AND YEAR(I.INVOICE_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.year#">
                </cfif>
                <cfif isDefined('arguments.period') and len(arguments.period) and len(arguments.startdate) and len(arguments.finishdate)>
                    AND I.INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startdate#"> 
                    AND I.INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finishdate#">
                </cfif>
            GROUP BY 
                RSG.RECYCLE_GROUP_ID		
                ,I.INVOICE_CAT
                ,RSG.KG_PRICE
                ,MONTH(I.INVOICE_DATE)
                ,P.COMPANY_ID
        </cfquery>
		<cfreturn get_invoice>
	</cffunction>
    <cffunction name="get_invoice_domestic" access="public" returntype="query">
		<cfargument name="year" default="">
		<cfargument name="period" default="">
		<cfquery name="get_invoice_domestic" datasource="#dsn2#">
            SELECT 
                RSG.RECYCLE_GROUP_ID,
                P.PRODUCT_ID,
                SUM(IR.AMOUNT) AS SALES_QUANTITY,
                CASE WHEN RSG.KG_PRICE != 0 THEN SUM(IR.AMOUNT*RSG.KG_PRICE) ELSE SUM(IR.AMOUNT*RSG.NUMBER_PRICE) END AS SALES_TOTAL,
                MONTH(I.INVOICE_DATE) AS SALES_MONTH,
                I.INVOICE_CAT,
                P.IS_PRODUCTION,
                P.PRODUCT_NAME,
                RSG.RECYCLE_SUB_GROUP,
                CASE WHEN RSG.KG_PRICE != 0 THEN RSG.KG_PRICE ELSE RSG.NUMBER_PRICE END AS SALES_UNIT_AMOUNT
            FROM 
                INVOICE I
                JOIN INVOICE_ROW IR ON I.INVOICE_ID = IR.INVOICE_ID 
                JOIN #dsn1_alias#.PRODUCT P ON P.PRODUCT_ID = IR.PRODUCT_ID
                JOIN #dsn_alias#.RECYCLE_SUB_GROUP RSG ON P.RECYCLE_GROUP_ID = RSG.RECYCLE_SUB_GROUP_ID
                JOIN #dsn_alias#.RECYCLE_GROUP RG ON RG.RECYCLE_GROUP_ID = RSG.RECYCLE_GROUP_ID
            WHERE I.INVOICE_CAT IN (52,53,531)
                AND IR.PRODUCT_ID IS NOT NULL
                AND P.RECYCLE_GROUP_ID IS NOT NULL
                AND RSG.RECYCLE_GROUP_ID != 3
                AND P.IS_PRODUCTION = 1
                AND I.PURCHASE_SALES = 1
                <cfif isDefined('arguments.year') and len(arguments.year)>
                    AND YEAR(I.INVOICE_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.year#">
                </cfif>
                <cfif isDefined('arguments.period') and len(arguments.period) and len(arguments.startdate) and len(arguments.finishdate)>
                    AND I.INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startdate#"> 
                    AND I.INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finishdate#">
                </cfif>
            GROUP BY 
            RSG.RECYCLE_GROUP_ID,
                P.PRODUCT_ID,
                MONTH(I.INVOICE_DATE),
                I.INVOICE_CAT,
                P.IS_PRODUCTION,
                P.PRODUCT_NAME,
                RSG.RECYCLE_SUB_GROUP,
                RSG.KG_PRICE,
                RSG.NUMBER_PRICE
            UNION ALL
            SELECT 
                RSG.RECYCLE_GROUP_ID,
                P.PRODUCT_ID,
                SUM(IRP.AMOUNT) AS SALES_QUANTITY,
                CASE WHEN RSG.KG_PRICE != 0 THEN SUM(IRP.AMOUNT*RSG.KG_PRICE) ELSE SUM(IRP.AMOUNT*RSG.NUMBER_PRICE) END AS SALES_TOTAL,
                MONTH(I.INVOICE_DATE) AS SALES_MONTH,
                I.INVOICE_CAT,
                P.IS_PRODUCTION,
                P.PRODUCT_NAME,
                RSG.RECYCLE_SUB_GROUP,
                CASE WHEN RSG.KG_PRICE != 0 THEN RSG.KG_PRICE ELSE RSG.NUMBER_PRICE END AS SALES_UNIT_AMOUNT
            FROM 
                INVOICE I
                JOIN INVOICE_ROW_POS IRP ON I.INVOICE_ID = IRP.INVOICE_ID 
                JOIN #dsn1_alias#.PRODUCT P ON P.PRODUCT_ID = IRP.PRODUCT_ID
                JOIN #dsn_alias#.RECYCLE_SUB_GROUP RSG ON P.RECYCLE_GROUP_ID = RSG.RECYCLE_SUB_GROUP_ID
                JOIN #dsn_alias#.RECYCLE_GROUP RG ON RG.RECYCLE_GROUP_ID = RSG.RECYCLE_GROUP_ID
            WHERE I.INVOICE_CAT IN (69)
                AND IRP.PRODUCT_ID IS NOT NULL
                AND P.RECYCLE_GROUP_ID IS NOT NULL
                AND RSG.RECYCLE_GROUP_ID != 3
                AND P.IS_PRODUCTION = 1
                AND I.PURCHASE_SALES = 1
                <cfif isDefined('arguments.year') and len(arguments.year)>
                    AND YEAR(I.INVOICE_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.year#">
                </cfif>
                <cfif isDefined('arguments.period') and len(arguments.period) and len(arguments.startdate) and len(arguments.finishdate)>
                    AND I.INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startdate#"> 
                    AND I.INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finishdate#">
                </cfif>
            GROUP BY 
                RSG.RECYCLE_GROUP_ID,
                P.PRODUCT_ID,
                MONTH(I.INVOICE_DATE),
                I.INVOICE_CAT,
                P.IS_PRODUCTION,
                P.PRODUCT_NAME,
                RSG.RECYCLE_SUB_GROUP,
                RSG.KG_PRICE,
                RSG.NUMBER_PRICE
        </cfquery>
		<cfreturn get_invoice_domestic>
	</cffunction>
    <cffunction name="get_invoice_imported" access="public" returntype="query">
		<cfargument name="year" default="">
		<cfargument name="period" default="">
		<cfquery name="get_invoice_imported" datasource="#dsn2#">
            SELECT 
                RSG.RECYCLE_GROUP_ID,
                P.PRODUCT_ID,
                SUM(IR.AMOUNT) AS SALES_QUANTITY,
                CASE WHEN RSG.KG_PRICE != 0 THEN SUM(IR.AMOUNT*RSG.KG_PRICE) ELSE SUM(IR.AMOUNT*RSG.NUMBER_PRICE) END AS SALES_TOTAL,
                MONTH(I.INVOICE_DATE) AS SALES_MONTH,
                I.INVOICE_CAT,
                P.IS_PRODUCTION,
                P.PRODUCT_NAME,
                RSG.RECYCLE_SUB_GROUP,
                CASE WHEN RSG.KG_PRICE != 0 THEN RSG.KG_PRICE ELSE RSG.NUMBER_PRICE END AS SALES_UNIT_AMOUNT
            FROM 
                INVOICE I
                JOIN INVOICE_ROW IR ON I.INVOICE_ID = IR.INVOICE_ID 
                JOIN #dsn1_alias#.PRODUCT P ON P.PRODUCT_ID = IR.PRODUCT_ID
                JOIN #dsn_alias#.RECYCLE_SUB_GROUP RSG ON P.RECYCLE_GROUP_ID = RSG.RECYCLE_SUB_GROUP_ID
                JOIN #dsn_alias#.RECYCLE_GROUP RG ON RG.RECYCLE_GROUP_ID = RSG.RECYCLE_GROUP_ID
            WHERE I.INVOICE_CAT IN (52,53,591)
                AND IR.PRODUCT_ID IS NOT NULL
                AND P.RECYCLE_GROUP_ID IS NOT NULL
                AND RSG.RECYCLE_GROUP_ID != 3
                AND P.IS_IMPORTED = 1
                AND I.PURCHASE_SALES = 1
                <cfif isDefined('arguments.year') and len(arguments.year)>
                    AND YEAR(I.INVOICE_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.year#">
                </cfif>
                <cfif isDefined('arguments.period') and len(arguments.period) and len(arguments.startdate) and len(arguments.finishdate)>
                    AND I.INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startdate#"> 
                    AND I.INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finishdate#">
                </cfif>
            GROUP BY 
            RSG.RECYCLE_GROUP_ID,
                P.PRODUCT_ID,
                MONTH(I.INVOICE_DATE),
                I.INVOICE_CAT,
                P.IS_PRODUCTION,
                P.PRODUCT_NAME,
                RSG.RECYCLE_SUB_GROUP,
                RSG.KG_PRICE,
                RSG.NUMBER_PRICE
            UNION ALL
            SELECT 
                RSG.RECYCLE_GROUP_ID,
                P.PRODUCT_ID,
                SUM(IRP.AMOUNT) AS SALES_QUANTITY,
                CASE WHEN RSG.KG_PRICE != 0 THEN SUM(IRP.AMOUNT*RSG.KG_PRICE) ELSE SUM(IRP.AMOUNT*RSG.NUMBER_PRICE) END AS SALES_TOTAL,
                MONTH(I.INVOICE_DATE) AS SALES_MONTH,
                I.INVOICE_CAT,
                P.IS_PRODUCTION,
                P.PRODUCT_NAME,
                RSG.RECYCLE_SUB_GROUP,
                CASE WHEN RSG.KG_PRICE != 0 THEN RSG.KG_PRICE ELSE RSG.NUMBER_PRICE END AS SALES_UNIT_AMOUNT
            FROM 
                INVOICE I
                JOIN INVOICE_ROW_POS IRP ON I.INVOICE_ID = IRP.INVOICE_ID 
                JOIN #dsn1_alias#.PRODUCT P ON P.PRODUCT_ID = IRP.PRODUCT_ID
                JOIN #dsn_alias#.RECYCLE_SUB_GROUP RSG ON P.RECYCLE_GROUP_ID = RSG.RECYCLE_SUB_GROUP_ID
                JOIN #dsn_alias#.RECYCLE_GROUP RG ON RG.RECYCLE_GROUP_ID = RSG.RECYCLE_GROUP_ID
            WHERE I.INVOICE_CAT IN (69)
                AND IRP.PRODUCT_ID IS NOT NULL
                AND P.RECYCLE_GROUP_ID IS NOT NULL
                AND RSG.RECYCLE_GROUP_ID != 3
                AND P.IS_IMPORTED = 1
                AND I.PURCHASE_SALES = 1
                <cfif isDefined('arguments.year') and len(arguments.year)>
                    AND YEAR(I.INVOICE_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.year#">
                </cfif>
                <cfif isDefined('arguments.period') and len(arguments.period) and len(arguments.startdate) and len(arguments.finishdate)>
                    AND I.INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startdate#"> 
                    AND I.INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finishdate#">
                </cfif>
            GROUP BY 
                RSG.RECYCLE_GROUP_ID,
                P.PRODUCT_ID,
                MONTH(I.INVOICE_DATE),
                I.INVOICE_CAT,
                P.IS_PRODUCTION,
                P.PRODUCT_NAME,
                RSG.RECYCLE_SUB_GROUP,
                RSG.KG_PRICE,
                RSG.NUMBER_PRICE
        </cfquery>
		<cfreturn get_invoice_imported>
	</cffunction>
    <cffunction name="get_invoice_last_year" access="public" returntype="query">
		<cfargument name="year" default="">
		<cfargument name="period" default="">
        <cfargument name="last_year" default="">
		<cfquery name="get_invoice_last_year" datasource="#dsn2#">
            SELECT 
                RSG.RECYCLE_GROUP_ID,
                P.PRODUCT_ID,
                SUM(IR.AMOUNT) AS SALES_QUANTITY,
                CASE WHEN RSG.KG_PRICE != 0 THEN SUM(IR.AMOUNT*RSG.KG_PRICE) ELSE SUM(IR.AMOUNT*RSG.NUMBER_PRICE) END AS SALES_TOTAL,
                MONTH(I.INVOICE_DATE) AS SALES_MONTH,
                I.INVOICE_CAT,
                P.PRODUCT_NAME,
                RSG.RECYCLE_SUB_GROUP,
                CASE WHEN RSG.KG_PRICE != 0 THEN RSG.KG_PRICE ELSE RSG.NUMBER_PRICE END AS SALES_UNIT_AMOUNT
            FROM 
                INVOICE I
                JOIN INVOICE_ROW IR ON I.INVOICE_ID = IR.INVOICE_ID 
                JOIN #dsn1_alias#.PRODUCT P ON P.PRODUCT_ID = IR.PRODUCT_ID
                JOIN #dsn_alias#.RECYCLE_SUB_GROUP RSG ON P.RECYCLE_GROUP_ID = RSG.RECYCLE_SUB_GROUP_ID
                JOIN #dsn_alias#.RECYCLE_GROUP RG ON RG.RECYCLE_GROUP_ID = RSG.RECYCLE_GROUP_ID
            WHERE I.INVOICE_CAT IN (52,53,591,531)
                AND IR.PRODUCT_ID IS NOT NULL
                AND P.RECYCLE_GROUP_ID IS NOT NULL
                AND I.PURCHASE_SALES = 0
                <cfif isDefined('arguments.last_year') and len(arguments.last_year)>
                    AND YEAR(I.INVOICE_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.last_year#">
                </cfif>
                <cfif isDefined('arguments.period') and len(arguments.period) and len(arguments.startdate) and len(arguments.finishdate)>
                    AND I.INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startdate#"> 
                    AND I.INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finishdate#">
                </cfif>
            GROUP BY 
            RSG.RECYCLE_GROUP_ID,
                P.PRODUCT_ID,
                MONTH(I.INVOICE_DATE),
                I.INVOICE_CAT,
                P.PRODUCT_NAME,
                RSG.RECYCLE_SUB_GROUP,
                RSG.KG_PRICE,
                RSG.NUMBER_PRICE
            UNION ALL
            SELECT 
                RSG.RECYCLE_GROUP_ID,
                P.PRODUCT_ID,
                SUM(IRP.AMOUNT) AS SALES_QUANTITY,
                CASE WHEN RSG.KG_PRICE != 0 THEN SUM(IRP.AMOUNT*RSG.KG_PRICE) ELSE SUM(IRP.AMOUNT*RSG.NUMBER_PRICE) END AS SALES_TOTAL,
                MONTH(I.INVOICE_DATE) AS SALES_MONTH,
                I.INVOICE_CAT,
                P.PRODUCT_NAME,
                RSG.RECYCLE_SUB_GROUP,
                CASE WHEN RSG.KG_PRICE != 0 THEN RSG.KG_PRICE ELSE RSG.NUMBER_PRICE END AS SALES_UNIT_AMOUNT
            FROM 
                INVOICE I
                JOIN INVOICE_ROW_POS IRP ON I.INVOICE_ID = IRP.INVOICE_ID 
                JOIN #dsn1_alias#.PRODUCT P ON P.PRODUCT_ID = IRP.PRODUCT_ID
                JOIN #dsn_alias#.RECYCLE_SUB_GROUP RSG ON P.RECYCLE_GROUP_ID = RSG.RECYCLE_SUB_GROUP_ID
                JOIN #dsn_alias#.RECYCLE_GROUP RG ON RG.RECYCLE_GROUP_ID = RSG.RECYCLE_GROUP_ID
            WHERE I.INVOICE_CAT IN (69)
                AND IRP.PRODUCT_ID IS NOT NULL
                AND P.RECYCLE_GROUP_ID IS NOT NULL
                AND I.PURCHASE_SALES = 0
                <cfif isDefined('arguments.last_year') and len(arguments.last_year)>
                    AND YEAR(I.INVOICE_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.last_year#">
                </cfif>
                <cfif isDefined('arguments.period') and len(arguments.period) and len(arguments.startdate) and len(arguments.finishdate)>
                    AND I.INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startdate#"> 
                    AND I.INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finishdate#">
                </cfif>
            GROUP BY 
                RSG.RECYCLE_GROUP_ID,
                P.PRODUCT_ID,
                MONTH(I.INVOICE_DATE),
                I.INVOICE_CAT,
                P.PRODUCT_NAME,
                RSG.RECYCLE_SUB_GROUP,
                RSG.KG_PRICE,
                RSG.NUMBER_PRICE
        </cfquery>
		<cfreturn get_invoice_last_year>
	</cffunction>
    <cffunction name="get_invoice_return" access="public" returntype="query">
		<cfargument name="year" default="">
		<cfargument name="period" default="">
		<cfquery name="get_invoice_return" datasource="#dsn2#">
            SELECT 
                RSG.RECYCLE_GROUP_ID
                ,I.INVOICE_CAT
                ,SUM(IR.AMOUNT) AS SALES_QUANTITY,
                CASE WHEN RSG.KG_PRICE != 0 THEN SUM(IR.AMOUNT*RSG.KG_PRICE) ELSE SUM(IR.AMOUNT*RSG.NUMBER_PRICE) END AS SALES_TOTAL,
                MONTH(I.INVOICE_DATE) AS SALES_MONTH,
                P.COMPANY_ID
            FROM 
                INVOICE I
                JOIN INVOICE_ROW IR ON I.INVOICE_ID = IR.INVOICE_ID 
                JOIN #dsn1_alias#.PRODUCT P ON P.PRODUCT_ID = IR.PRODUCT_ID
                JOIN #dsn_alias#.RECYCLE_SUB_GROUP RSG ON P.RECYCLE_GROUP_ID = RSG.RECYCLE_SUB_GROUP_ID
            WHERE (I.INVOICE_CAT IN (54,55))
                AND IR.PRODUCT_ID IS NOT NULL
                AND P.RECYCLE_GROUP_ID IS NOT NULL
                AND RSG.RECYCLE_GROUP_ID != 3
                AND I.PURCHASE_SALES = 1
                <cfif isDefined('arguments.year') and len(arguments.year)>
                    AND YEAR(I.INVOICE_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.year#">
                </cfif>
                <cfif isDefined('arguments.period') and len(arguments.period) and len(arguments.startdate) and len(arguments.finishdate)>
                    AND I.INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startdate#"> 
                    AND I.INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finishdate#">
                </cfif>
            GROUP BY 
                RSG.RECYCLE_GROUP_ID		
                ,I.INVOICE_CAT
                ,RSG.KG_PRICE
                ,MONTH(I.INVOICE_DATE)
                ,P.COMPANY_ID
        </cfquery>
		<cfreturn get_invoice_return>
	</cffunction>
    <cffunction name="get_recycle_group_sales" access="public" returntype="query">
		<cfargument name="year" default="">
		<cfargument name="period" default="">
        <cfargument name="recycle_id" default="">
		<cfquery name="get_recycle_group_sales" datasource="#dsn2#">
         WITH T1 AS(   
            SELECT 
                RSG.RECYCLE_GROUP_ID,
                CASE WHEN RSG.KG_PRICE != 0 THEN SUM(IR.AMOUNT*RSG.KG_PRICE) ELSE SUM(IR.AMOUNT*RSG.NUMBER_PRICE) END AS SALES_TOTAL
            FROM 
                INVOICE I
                JOIN INVOICE_ROW IR ON I.INVOICE_ID = IR.INVOICE_ID 
                JOIN #dsn1_alias#.PRODUCT P ON P.PRODUCT_ID = IR.PRODUCT_ID
                JOIN #dsn_alias#.RECYCLE_SUB_GROUP RSG ON P.RECYCLE_GROUP_ID = RSG.RECYCLE_SUB_GROUP_ID
            WHERE (I.INVOICE_CAT IN (52,53,531,591))
                AND IR.PRODUCT_ID IS NOT NULL
                AND P.RECYCLE_GROUP_ID IS NOT NULL
                AND RSG.RECYCLE_GROUP_ID != 3 
                AND I.PURCHASE_SALES = 1
                <cfif isDefined('arguments.recycle_id') and len(arguments.recycle_id)>
                    AND  RSG.RECYCLE_GROUP_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.recycle_id#">
                </cfif>
                <cfif isDefined('arguments.year') and len(arguments.year)>
                    AND YEAR(I.INVOICE_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.year#">
                </cfif>
                <cfif isDefined('arguments.period') and len(arguments.period) and len(arguments.startdate) and len(arguments.finishdate)>
                    AND I.INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startdate#"> 
                    AND I.INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finishdate#">
                </cfif>
            GROUP BY 
                RSG.RECYCLE_GROUP_ID
                ,RSG.KG_PRICE
            UNION ALL 
            SELECT 
                RSG.RECYCLE_GROUP_ID,
                CASE WHEN RSG.KG_PRICE != 0 THEN SUM(IRP.AMOUNT*RSG.KG_PRICE) ELSE SUM(IRP.AMOUNT*RSG.NUMBER_PRICE) END AS SALES_TOTAL
            FROM 
                INVOICE I
                JOIN INVOICE_ROW_POS IRP ON I.INVOICE_ID = IRP.INVOICE_ID 
                JOIN #dsn1_alias#.PRODUCT P ON P.PRODUCT_ID = IRP.PRODUCT_ID
                JOIN #dsn_alias#.RECYCLE_SUB_GROUP RSG ON P.RECYCLE_GROUP_ID = RSG.RECYCLE_SUB_GROUP_ID
            WHERE (I.INVOICE_CAT IN (69))
                AND IRP.PRODUCT_ID IS NOT NULL
                AND P.RECYCLE_GROUP_ID IS NOT NULL
                AND RSG.RECYCLE_GROUP_ID != 3
                AND I.PURCHASE_SALES = 1
                <cfif isDefined('arguments.recycle_id') and len(arguments.recycle_id)>
                    AND  RSG.RECYCLE_GROUP_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.recycle_id#">
                </cfif>
                <cfif isDefined('arguments.year') and len(arguments.year)>
                    AND YEAR(I.INVOICE_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.year#">
                </cfif>
                <cfif isDefined('arguments.period') and len(arguments.period) and len(arguments.startdate) and len(arguments.finishdate)>
                    AND I.INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startdate#"> 
                    AND I.INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finishdate#">
                </cfif>
            GROUP BY 
                RSG.RECYCLE_GROUP_ID
                ,RSG.KG_PRICE
         )
         SELECT RECYCLE_GROUP_ID,ISNULL(SUM(SALES_TOTAL),0) AS TOTAL_ FROM T1 GROUP BY RECYCLE_GROUP_ID
        </cfquery>
		<cfreturn get_recycle_group_sales>
	</cffunction>
    <cffunction name="get_comp_info" access="public" returntype="query">
        <cfargument name="company_list" default="">
		<cfquery name="get_comp_info" datasource="#dsn#">
            SELECT C.COMPANY_ID,SC.CITY_NAME,TC_IDENTITY,TAXNO,C.MEMBER_CODE+' - '+C.FULLNAME AS COMPANY_NAME FROM COMPANY C JOIN COMPANY_PARTNER CP ON CP.COMPANY_ID=C.COMPANY_ID JOIN SETUP_CITY SC ON SC.CITY_ID = C.CITY WHERE C.COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_list#" list="yes">)
		</cfquery>
		<cfreturn get_comp_info>
	</cffunction>
    <cffunction name="GET_COMPANY_CITY" returntype="query">
        <cfargument name="city_list" default="">
        <cfquery name="GET_COMPANY_CITY" datasource="#DSN#">
            SELECT
                CITY_ID,
                CITY_NAME
            FROM
                SETUP_CITY
            WHERE
                CITY_ID IN (#arguments.city_list#)
            ORDER BY
                CITY_ID
        </cfquery>
        <cfreturn GET_COMPANY_CITY>
    </cffunction>
</cfcomponent>