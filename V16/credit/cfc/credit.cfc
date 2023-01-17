<!--- fuseaction=credit.list_credit_contract --->
<!--- Kredi listeleme sayfasında include ile çekilen query cfc ye alınarak cte yapısına geçildi . Taşdemir 03082015 --->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cfset DSN1=DSN&"_product">
	<cfset DSN2=DSN & "_"&session.ep.period_year&"_"&session.ep.company_id>
	<cfset DSN3=DSN&"_"&session.ep.company_id>


	<cffunction name="get_setup_process_cat_fusename" returntype="query" access="public">
        <cfquery name="get_setup_process_cat_fusename" datasource="#this.dsn3#">
            SELECT
            	SPC.PROCESS_CAT_ID,
                SPC.PROCESS_TYPE,
                #dsn#.Get_Dynamic_Language(SPC.PROCESS_CAT_ID,'#session.ep.language#','SETUP_PROCESS_CAT','PROCESS_CAT',NULL,NULL,SPC.PROCESS_CAT) AS PROCESS_CAT
            FROM
                SETUP_PROCESS_CAT_FUSENAME AS SPCF,
                SETUP_PROCESS_CAT SPC
            WHERE
                SPC.PROCESS_CAT_ID = SPCF.PROCESS_CAT_ID AND			
                SPCF.FUSE_NAME = 'credit.upd_credit_contract'
            ORDER BY
                SPC.PROCESS_CAT	
        </cfquery>
    	<cfreturn get_setup_process_cat_fusename>
    </cffunction>
    <cffunction name="getCredit" returntype="query" access="public">
        <cfargument name="is_detail_credit_contract" default="0">
        <cfargument name="listing_type" default="">
        <cfargument name="company_id" default="">
        <cfargument name="company" default="">
        <cfargument name="keyword" default="">
        <cfargument name="credit_employee_id" default="">
        <cfargument name="credit_employee" default="">
        <cfargument name="start_date" default="">
        <cfargument name="finish_date" default="">
        <cfargument name="is_active" default="">
        <cfargument name="process_type" default="">
        <cfargument name="credit_limit_id" default="">
        <cfargument name="credit_type_id" default="">
        <cfargument name="startrow" default="1">
   		<cfargument name="maxrows" default="#session.ep.maxrows#">
        <cfargument name="is_scenario_control">
		<cfquery name="get_credit" datasource="#this.dsn3#">
            WITH CTE1 AS
            (
                SELECT
                    CC.CREDIT_CONTRACT_ID ,
                    CC.CREDIT_NO ,
                    CC.RECORD_EMP ,
                    CC.MONEY_TYPE ,
                    CC.AGREEMENT_NO AS AGREEMENT_NO ,
                    SCT.CREDIT_TYPE AS CREDIT_TYPE ,
                    CC.RECORD_DATE AS RECORD_DATE ,
                    CC.CREDIT_DATE AS CREDIT_DATE ,
                    C.NICKNAME AS NICKNAME ,
                    C.COMPANY_ID ,
                    CC.DETAIL AS DETAIL ,
                    (E.EMPLOYEE_NAME+E.EMPLOYEE_SURNAME) AS SORUMLU ,
                    CC.CREDIT_EMP_ID ,
				<cfif arguments.listing_type eq 1>
                    CC.TOTAL_REVENUE AS ROW_TOTAL_REVENUE ,
                    SUM(CASE WHEN (CCR.PROCESS_TYPE = 292 AND CCR.CREDIT_CONTRACT_TYPE = 2 AND IS_PAID=1) THEN TOTAL_PRICE ELSE 0 END) AS REALIZED_COLLECTION ,
                    CC.TOTAL_PAYMENT AS ROW_TOTAL_PAYMENT ,
                    SUM(CASE WHEN (CCR.PROCESS_TYPE IN (120,291) AND CCR.CREDIT_CONTRACT_TYPE = 1 AND IS_PAID=1) THEN TOTAL_PRICE ELSE 0 END) AS PAYMENT_REALIZED ,
                    SUM(CASE  WHEN (CCR.IS_PAID=1 AND CCR.CREDIT_CONTRACT_TYPE = 1) THEN CCR.DELAY_PRICE ELSE 0 END) AS DELAY_PRICE ,
                </cfif>
                    (TOTAL_REVENUE-TOTAL_PAYMENT) AS FARK,
                    CC.MONEY_TYPE AS PARA_BIRIMI
				<cfif arguments.listing_type eq 2>
                    ,PROCESS_DATE
                    ,CASE WHEN CCR.CREDIT_CONTRACT_TYPE = 1 THEN TOTAL_PRICE ELSE 0 END AS ROW_TOTAL_PAYMENT1,
                    CASE WHEN CCR.CREDIT_CONTRACT_TYPE = 2 THEN TOTAL_PRICE ELSE 0 END AS ROW_TOTAL_REVENUE1,
                    PROCESS_DATE ROW_PROCESS_DATE
                </cfif>
                FROM
                	CREDIT_CONTRACT CC
                    LEFT JOIN CREDIT_CONTRACT_ROW CCR ON CCR.CREDIT_CONTRACT_ID = CC.CREDIT_CONTRACT_ID
                    LEFT JOIN #dsn#.SETUP_CREDIT_TYPE SCT ON CC.CREDIT_TYPE=SCT.CREDIT_TYPE_ID
                    LEFT JOIN #dsn#.COMPANY C ON CC.COMPANY_ID=C.COMPANY_ID
                    LEFT JOIN #dsn#.EMPLOYEES E ON E.EMPLOYEE_ID=CC.CREDIT_EMP_ID
                WHERE 
             		CC.CREDIT_CONTRACT_ID IS NOT NULL
				<cfif arguments.listing_type eq 2>
                    AND CCR.IS_PAID IS NOT NULL
                    AND CCR.IS_PAID_ROW IS NULL
                </cfif>
                <cfif len(arguments.company_id) and len(arguments.company)>
                    AND CC.COMPANY_ID = #arguments.company_id#
                </cfif>
                <cfif len(arguments.keyword)>
                    AND (CC.CREDIT_NO LIKE '%#arguments.keyword#%' OR CC.REFERENCE LIKE '%#arguments.keyword#%' OR CC.AGREEMENT_NO LIKE '%#arguments.keyword#%')
                </cfif>
                <cfif len(arguments.credit_employee_id) and len(arguments.credit_employee)>
                    AND CC.CREDIT_EMP_ID = #arguments.credit_employee_id#
                </cfif>
                <cfif isdate(arguments.start_date) and len(arguments.start_date) >
                    AND CC.RECORD_DATE >= #arguments.start_date# 
                </cfif>
                <cfif isdate(arguments.finish_date)  and len(arguments.finish_date) >
                    AND CC.RECORD_DATE <= #arguments.finish_date# 
                </cfif>
                <cfif len(arguments.is_active)>
                    AND CC.IS_ACTIVE = #arguments.is_active#
                </cfif>
                <cfif len(arguments.process_type)>
                    AND CC.PROCESS_CAT = #arguments.process_type#
                </cfif>
                <cfif len(arguments.credit_limit_id)>
                    AND CC.CREDIT_LIMIT_ID = #arguments.credit_limit_id#
                </cfif>
                <cfif len(arguments.credit_type_id)>
                    AND CC.CREDIT_TYPE = #arguments.credit_type_id#
                </cfif>
                <cfif arguments.is_scenario_control eq 1>
                	AND CC.IS_SCENARIO = 1
                </cfif>
				<cfif arguments.listing_type eq 1>
                     GROUP BY
                        CC.CREDIT_NO,
                        CC.AGREEMENT_NO,
                        SCT.CREDIT_TYPE,
                        CC.RECORD_DATE,
                        C.NICKNAME,
                        CC.DETAIL,
                        CC.CREDIT_EMP_ID,
                        CC.TOTAL_REVENUE,
                        CC.TOTAL_PAYMENT,
                        CC.MONEY_TYPE,
                        CC.CREDIT_DATE,
                        CC.RECORD_EMP,
                        CC.CREDIT_CONTRACT_ID,
                        E.EMPLOYEE_NAME,
                        E.EMPLOYEE_SURNAME,
                        C.COMPANY_ID
                    </cfif>
                    ),
			CTE2 AS
                (
                	SELECT 
                        CTE1.*,
					<cfif arguments.listing_type eq 1>
                        SUM(ROW_TOTAL_REVENUE) OVER (PARTITION BY PARA_BIRIMI ORDER BY PARA_BIRIMI) AS TOTAL_COLLECTION_PLANNED ,
                        SUM(REALIZED_COLLECTION) OVER (PARTITION BY PARA_BIRIMI ORDER BY PARA_BIRIMI) AS TOTAL_REALIZED_COLLECTION ,
                        SUM(ROW_TOTAL_PAYMENT) OVER (PARTITION BY PARA_BIRIMI  ORDER BY PARA_BIRIMI) AS PAYMENT_TOTAL_PLANNED ,
                        SUM(CTE1.PAYMENT_REALIZED) OVER (PARTITION BY PARA_BIRIMI ORDER BY PARA_BIRIMI) AS PAYMENT_TOTAL_REALIZED ,
                        SUM(DELAY_PRICE) OVER (PARTITION BY PARA_BIRIMI ORDER BY PARA_BIRIMI) AS TOTAL_AMOUNT_OF_DELAY ,
                        SUM(ROW_TOTAL_REVENUE-REALIZED_COLLECTION) OVER (PARTITION BY PARA_BIRIMI ORDER BY PARA_BIRIMI) AS  REMAINING_TOTAL_COLLECTION,
                        SUM(ROW_TOTAL_PAYMENT-PAYMENT_REALIZED) OVER (PARTITION BY PARA_BIRIMI ORDER BY PARA_BIRIMI) AS  REMAINING_TOTAL_PAYMENT ,
                       
                        (CTE1.ROW_TOTAL_REVENUE - CTE1.REALIZED_COLLECTION) AS REMAINING_COLLECTIONS ,
                        (CTE1.ROW_TOTAL_PAYMENT + CTE1.DELAY_PRICE - CTE1.PAYMENT_REALIZED) AS REMAINING_PAYMENT ,
                    </cfif>
                    <cfif arguments.listing_type eq 2>
                        SUM(ROW_TOTAL_PAYMENT1) OVER (PARTITION BY PARA_BIRIMI ORDER BY PARA_BIRIMI) AS ROW_TAHSILAT,
                        SUM(ROW_TOTAL_REVENUE1) OVER (PARTITION BY PARA_BIRIMI  ORDER BY PARA_BIRIMI) AS ROW_ODEME,
                     </cfif>
                         ROW_NUMBER() OVER (ORDER BY <cfif   arguments.listing_type eq 2>ROW_PROCESS_DATE <cfelse>CREDIT_DATE</cfif>) AS RowNum,
                         (SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                	FROM
                    	CTE1
                )
                 	SELECT
                    	CTE2.*
               		FROM
                    	CTE2
            		WHERE
               			 RowNum BETWEEN #arguments.startrow# and #arguments.startrow#+(#arguments.maxrows#-1)
		</cfquery>
        <cfreturn get_credit>
    </cffunction>
    <cffunction name="getTotalCreditPayment" returntype="query" access="public">
		<cfargument name="is_detail_credit_contract" default="0">
        <cfargument name="listing_type" default="">
        <cfargument name="company_id" default="">
        <cfargument name="keyword" default="">
        <cfargument name="credit_employee_id" default="">
        <cfargument name="start_date" default="">
        <cfargument name="finish_date" default="">
        <cfargument name="is_active" default="">
        <cfargument name="process_type" default="">
        <cfargument name="credit_limit_id" default="">
        <cfargument name="credit_type_id" default="">
        <cfargument name="startrow" default="1">
        <cfargument name="is_scenario_control" default="0">
   		<cfargument name="maxrows" default="#session.ep.maxrows#">
        <cfquery name="get_credit" datasource="#this.dsn3#">
            WITH CTE1 AS
            (
                SELECT
                 	CC.MONEY_TYPE AS PARA_BIRIMI,
                    (TOTAL_REVENUE-TOTAL_PAYMENT) AS FARK,
                    <cfif arguments.listing_type eq 1>
                        CC.TOTAL_REVENUE AS ROW_TOTAL_REVENUE,
                        SUM(CASE WHEN (CCR.PROCESS_TYPE = 292 AND CCR.CREDIT_CONTRACT_TYPE = 2 AND IS_PAID=1) THEN TOTAL_PRICE ELSE 0 END) AS GERCEKLESEN_TAHSILAT,
                        CC.TOTAL_PAYMENT AS ROW_TOTAL_PAYMENT,
                        SUM(CASE WHEN (CCR.PROCESS_TYPE IN (120,291) AND CCR.CREDIT_CONTRACT_TYPE = 1 AND IS_PAID=1) THEN TOTAL_PRICE ELSE 0 END) AS GERCEKLESEN_ODEME,
                        SUM(CASE  WHEN (CCR.IS_PAID=1 AND CCR.CREDIT_CONTRACT_TYPE = 1) THEN CCR.DELAY_PRICE ELSE 0 END) AS DELAY_PRICE,
                    </cfif>
                   	CC.CREDIT_TYPE,
                    CC.CREDIT_DATE
                   	<cfif arguments.listing_type eq 2>
                    	,PROCESS_DATE
                        ,CASE WHEN CCR.CREDIT_CONTRACT_TYPE = 1 THEN TOTAL_PRICE ELSE 0 END AS ROW_TOTAL_PAYMENT1,
                        CASE WHEN CCR.CREDIT_CONTRACT_TYPE = 2 THEN TOTAL_PRICE ELSE 0 END AS ROW_TOTAL_REVENUE1,
                        PROCESS_DATE ROW_PROCESS_DATE
					</cfif>
                FROM
                	CREDIT_CONTRACT CC
                    LEFT JOIN CREDIT_CONTRACT_ROW CCR ON CCR.CREDIT_CONTRACT_ID = CC.CREDIT_CONTRACT_ID
                WHERE 
             		CC.CREDIT_CONTRACT_ID IS NOT NULL
				<cfif arguments.listing_type eq 2>
                    AND CCR.IS_PAID IS NOT NULL
                    AND CCR.IS_PAID_ROW IS NULL
                </cfif>
                <cfif len(arguments.company_id) and len(arguments.company)>
                    AND CC.COMPANY_ID = #arguments.company_id#
                </cfif>
                <cfif len(arguments.keyword)>
                    AND (CC.CREDIT_NO LIKE '%#arguments.keyword#%' OR CC.REFERENCE LIKE '%#arguments.keyword#%' OR CC.AGREEMENT_NO LIKE '%#arguments.keyword#%')
                </cfif>
                <cfif len(arguments.credit_employee_id) and len(arguments.credit_employee)>
                    AND CC.CREDIT_EMP_ID = #arguments.credit_employee_id#
                </cfif>
               <cfif isdate(arguments.start_date) and len(arguments.start_date) >
                        AND CC.RECORD_DATE >= #arguments.start_date# 

                </cfif>
                <cfif isdate(arguments.finish_date)  and len(arguments.finish_date) >
                        AND CC.RECORD_DATE <= #arguments.finish_date# 
                </cfif>
                <cfif len(arguments.is_active)>
                    AND CC.IS_ACTIVE = #arguments.is_active#
                </cfif>
                <cfif len(arguments.process_type)>
                    AND CC.PROCESS_CAT = #arguments.process_type#
                </cfif>
                <cfif len(arguments.credit_limit_id)>
                    AND CC.CREDIT_LIMIT_ID = #arguments.credit_limit_id#
                </cfif>
                <cfif len(arguments.credit_type_id)>
                    AND CC.CREDIT_TYPE = #arguments.credit_type_id#
                </cfif>
                <cfif len(arguments.is_scenario_control) and arguments.is_scenario_control eq 1>
                	AND CC.IS_SCENARIO = 1
                </cfif>
             	<cfif   arguments.listing_type eq 1>
            		GROUP BY
                        CC.CREDIT_TYPE,
                        CC.TOTAL_REVENUE,
                        CC.CREDIT_NO,
                        CC.TOTAL_PAYMENT,
                        CC.MONEY_TYPE,
                        CC.CREDIT_DATE
				</cfif>
                    ),
			CTE2 AS
                (
                	SELECT DISTINCT
                    	PARA_BIRIMI,
					<cfif arguments.listing_type eq 1>
                        SUM(ROW_TOTAL_REVENUE) OVER (PARTITION BY PARA_BIRIMI ORDER BY PARA_BIRIMI) AS TOTAL_COLLECTION_PLANNED ,
                        SUM(GERCEKLESEN_TAHSILAT) OVER (PARTITION BY PARA_BIRIMI ORDER BY PARA_BIRIMI) AS TOTAL_REALIZED_COLLECTION ,
                        SUM(ROW_TOTAL_PAYMENT) OVER (PARTITION BY PARA_BIRIMI  ORDER BY PARA_BIRIMI) AS PAYMENT_TOTAL_PLANNED ,
                        SUM(CTE1.GERCEKLESEN_ODEME) OVER (PARTITION BY PARA_BIRIMI ORDER BY PARA_BIRIMI) AS PAYMENT_TOTAL_REALIZED ,
                        SUM(DELAY_PRICE) OVER (PARTITION BY PARA_BIRIMI ORDER BY PARA_BIRIMI) AS TOTAL_AMOUNT_OF_DELAY ,
                        SUM(ROW_TOTAL_REVENUE-GERCEKLESEN_TAHSILAT) OVER (PARTITION BY PARA_BIRIMI ORDER BY PARA_BIRIMI) AS  REMAINING_TOTAL_COLLECTION,
                        SUM(ROW_TOTAL_PAYMENT-GERCEKLESEN_ODEME) OVER (PARTITION BY PARA_BIRIMI ORDER BY PARA_BIRIMI) AS  REMAINING_TOTAL_PAYMENT ,
                         SUM(FARK) OVER (PARTITION BY PARA_BIRIMI ORDER BY PARA_BIRIMI) AS TOPLAM_FARK
                    </cfif>
                    <cfif arguments.listing_type eq 2>
                        SUM(ROW_TOTAL_PAYMENT1) OVER (PARTITION BY PARA_BIRIMI ORDER BY PARA_BIRIMI) AS ROW_TAHSILAT,
                        SUM(ROW_TOTAL_REVENUE1) OVER (PARTITION BY PARA_BIRIMI  ORDER BY PARA_BIRIMI) AS ROW_ODEME
                    </cfif>
                	FROM
                   		CTE1
              	)
                 SELECT
                	 CTE2.*
                 FROM
                    CTE2
         </cfquery>
        <cfreturn get_credit>
    </cffunction>
    
    <!--- Menkul Kıymet Hareketler Listeme Sayfası için  yapıldı . Taşdemir 03082015 --->
    <cffunction name="getStockbondData" returntype="query" access="public">
    	<cfargument name="start_date" default="">
        <cfargument name="finish_date" default="">
        <cfargument name="cat" default="">
        <cfargument name="company_id" default="">
        <cfargument name="company_name" default="">
        <cfargument name="employee_id" default="">
        <cfargument name="employee_name" default="">
        <cfargument name="startrow" default="1">
   		<cfargument name="maxrows" default="#session.ep.maxrows#">
    	<cfquery name="GET_STOCKBOND" datasource="#this.dsn3#">
            WITH CTE1 AS
                (
                    SELECT 
                        SS.ACTION_ID,
                        SS.PROCESS_TYPE,
                        SS.PAPER_NO,
                        SS.ACTION_DATE,
                        SS.COMPANY_ID,
                        SS.EMPLOYEE_ID,
                        SS.NET_TOTAL,
                        SS.OTHER_MONEY_VALUE,
                        E.EMPLOYEE_NAME,
                        E.EMPLOYEE_SURNAME,
                        E.EMPLOYEE_ID AS EMPLOYEE_ID_,
                        C.FULLNAME,
                        C.COMPANY_ID AS COMPANY_ID_,
                        ROW_NUMBER() OVER (ORDER BY ACTION_DATE DESC ) AS RowNum
                   	FROM
                        STOCKBONDS_SALEPURCHASE SS
                        LEFT JOIN #dsn#.EMPLOYEES E ON E.EMPLOYEE_ID = SS.EMPLOYEE_ID
                        LEFT JOIN #dsn#.COMPANY C ON C.COMPANY_ID = SS.COMPANY_ID
                    WHERE
                        ACTION_ID IS NOT NULL
					<cfif isdate(arguments.start_date) and isdate(arguments.finish_date)>
                        AND ACTION_DATE BETWEEN #arguments.start_date# AND #arguments.finish_date#
                    </cfif>
                    <cfif  len(arguments.cat)>
                        AND PROCESS_TYPE = #arguments.cat#
                    </cfif>
                    <cfif len(arguments.company_id) and len(arguments.company_name)>
                        AND SS.COMPANY_ID = #arguments.company_id#
                    </cfif>
                    <cfif len(arguments.employee_id) and len(arguments.employee_name)>
                        AND SS.EMPLOYEE_ID = #arguments.employee_id#
                    </cfif>
                )
                SELECT 
                    CTE1.*,
                    (SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                FROM 
                    CTE1
                WHERE
               		RowNum BETWEEN #arguments.startrow# and #arguments.startrow#+(#arguments.maxrows#-1)
    	</cfquery>
        <cfreturn get_stockbond>
    </cffunction>
    
    <!--- Menkul Kıymet  Listeme Sayfası için  yapıldı . Taşdemir 03082015 --->
    <cffunction name="getStockbond" returntype="query" access="public">
    	<cfargument name="keyword" default="">
        <cfargument name="stockbond_type_id" default="">
        <cfargument name="startrow" default="1">
        <cfargument name="type_group" default="">
   		<cfargument name="maxrows" default="#session.ep.maxrows#">
        <cfquery name="GET_STOCKBOND" datasource="#this.dsn3#">
        <cfif not len(arguments.type_group)>
			WITH CTE1 AS
                
            	(
                    SELECT 
                        S.*,
                        SST.STOCKBOND_TYPE_ID,
                        SST.STOCKBOND_TYPE  AS STOCKBOND_TYPE_,
                        ROW_NUMBER() OVER (ORDER BY S.RECORD_DATE DESC ) AS RowNum,
                        (SELECT SUM(ISNULL(STOCKBOND_IN,0))-SUM(ISNULL(STOCKBOND_OUT,0)) FROM STOCKBONDS_INOUT WHERE STOCKBONDS_INOUT.STOCKBOND_ID = S.STOCKBOND_ID) AS NET_QUANTITY
                    FROM
                         STOCKBONDS S
                         LEFT JOIN #dsn#.SETUP_STOCKBOND_TYPE SST ON S.STOCKBOND_TYPE = SST.STOCKBOND_TYPE_ID
                    WHERE 
                        STOCKBOND_ID IS NOT NULL
					<cfif len(arguments.keyword)>
                        AND S.STOCKBOND_CODE LIKE '%#arguments.keyword#%'
                    </cfif>
                    <cfif len(arguments.stockbond_type_id)>
                        AND S.STOCKBOND_TYPE = #arguments.stockbond_type_id#
                    </cfif>
				)
                    SELECT 
                        CTE1.*,
                        (SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT,
                        ROW_NUMBER() OVER (ORDER BY RECORD_DATE DESC ) AS RowNum
                    FROM
                        CTE1
                    WHERE
                        RowNum BETWEEN #arguments.startrow# and #arguments.startrow#+(#arguments.maxrows#-1)
         <cfelse>
                SELECT
                    STOCKBOND_CODE,
                    SUM(NOMINAL_VALUE) AS NOMINAL_VALUE,
                    SUM(OTHER_NOMINAL_VALUE) AS OTHER_NOMINAL_VALUE,
                    SUM(PURCHASE_VALUE) AS PURCHASE_VALUE,
                    SUM(OTHER_PURCHASE_VALUE) AS OTHER_PURCHASE_VALUE,
                    (SUM(ISNULL(STOCKBOND_IN,0))-SUM(ISNULL(STOCKBOND_OUT,0))) AS NET_QUANTITY,
                    SUM(ACTUAL_VALUE) AS ACTUAL_VALUE,
                    SUM(OTHER_ACTUAL_VALUE) AS OTHER_ACTUAL_VALUE,
                    SUM(TOTAL_PURCHASE) AS TOTAL_PURCHASE,
                    SUM(OTHER_TOTAL_PURCHASE) AS OTHER_TOTAL_PURCHASE
                FROM 
                    STOCKBONDS AS S
                    LEFT JOIN STOCKBONDS_INOUT ON STOCKBONDS_INOUT.STOCKBOND_ID = S.STOCKBOND_ID
                    LEFT JOIN  ( SELECT STOCKBOND_ID FROM STOCKBONDS_VALUE_CHANGES SVC WHERE ACTUAL_VALUE = (SELECT MAX(ACTUAL_VALUE) FROM STOCKBONDS_VALUE_CHANGES WHERE STOCKBOND_ID = SVC.STOCKBOND_ID) ) AS SVC ON SVC.STOCKBOND_ID = S.STOCKBOND_ID
                WHERE 
                    1=1
                    <cfif len(arguments.keyword)>
                        AND S.STOCKBOND_CODE LIKE '%#arguments.keyword#%'
                    </cfif>
                    <cfif len(arguments.stockbond_type_id)>
                        AND S.STOCKBOND_TYPE = #arguments.stockbond_type_id#
                    </cfif>
            GROUP BY 
                    S.STOCKBOND_CODE
        </cfif>
    	</cfquery>
    	<cfreturn GET_STOCKBOND>
    </cffunction>

    <!--- Menkul Kıymet Getiri Listesi.. İlker Altındal 30122019 --->
    <cf_date tarih='arguments.date1'>
    <cf_date tarih='arguments.date2'>
    <cffunction name="GET_YIELD_PLAN_ROWS" returntype="any">
        <cfquery name="GET_YIELD_PLAN_ROWS" datasource="#dsn3#">
            SELECT 
                SYPR.*, 
                STCK.*, 
                SST.STOCKBOND_TYPE AS STOCKBOND_TYPE_,
                SSLP.PAPER_NO AS SLP_PAPER_NO, 
                NULL COMPANY_ID,
                (SELECT TOP 1 STOCKBONDS_VALUATION_DATE FROM STOCKBONDS_YIELD_VALUATION WHERE STOCKBONDS_ROWS_ID = SYPR.YIELD_PLAN_ROWS_ID ORDER BY STOCKBONDS_VALUATION_ID DESC ) AS REESKONT_DATE,
                (SELECT SUM(ISNULL(STOCKBOND_IN,0))-SUM(ISNULL(STOCKBOND_OUT,0)) FROM STOCKBONDS_INOUT WHERE STOCKBONDS_INOUT.STOCKBOND_ID = STCK.STOCKBOND_ID) AS NET_QUANTITY,
                BA.ACTION_ID AS BA_ACTION_ID,
                BA.ACTION_VALUE AS BA_ACTION_VALUE,
                BA.MASRAF AS BA_MASRAF,
                BA.ACTION_TYPE_ID AS BA_ACTION_TYPE_ID,
                BA.ACTION_DATE AS BA_ACTION_DATE,
                NULL CR_ACTION_ID,
                NULL CR_ACTION_VALUE,
                NULL CR_ACTION_TYPE_ID,
                NULL CR_ACTION_DATE
            FROM STOCKBONDS_YIELD_PLAN_ROWS AS SYPR 
                LEFT JOIN STOCKBONDS_SALEPURCHASE_ROW AS STCK_R ON SYPR.STOCKBOND_ID = STCK_R.STOCKBOND_ID
                LEFT JOIN STOCKBONDS_SALEPURCHASE AS SSLP ON STCK_R.SALES_PURCHASE_ID = SSLP.ACTION_ID
                LEFT JOIN STOCKBONDS AS STCK ON SYPR.STOCKBOND_ID = STCK.STOCKBOND_ID
                LEFT JOIN #dsn#.SETUP_STOCKBOND_TYPE SST ON STCK.STOCKBOND_TYPE = SST.STOCKBOND_TYPE_ID
                INNER JOIN #DSN2#.BANK_ACTIONS AS BA ON STCK.BANK_ACTION_ID = BA.ACTION_ID
            WHERE 
                SSLP.IS_SALES_PURCHASE = 0
                AND (SELECT SUM(ISNULL(STOCKBOND_IN,0))-SUM(ISNULL(STOCKBOND_OUT,0)) FROM STOCKBONDS_INOUT WHERE STOCKBONDS_INOUT.STOCKBOND_ID = STCK.STOCKBOND_ID) > 0
                <cfif len(arguments.date1) and not len(arguments.date2)>
                    AND SYPR.BANK_ACTION_DATE >= #arguments.date1#
                <cfelseif not len(arguments.date1) and len(arguments.date2)>
                    AND SYPR.BANK_ACTION_DATE <= #arguments.date2#
                <cfelseif len(arguments.date1) and len(arguments.date2)>
                    AND SYPR.BANK_ACTION_DATE >= #arguments.date1# AND SYPR.BANK_ACTION_DATE <= #arguments.date2#
                </cfif>
                <cfif len(arguments.record_date) and not len(arguments.record_date2)>
                    AND BA.ACTION_DATE >= #arguments.record_date#
                <cfelseif not len(arguments.record_date) and len(arguments.record_date2)>
                    AND BA.ACTION_DATE <= #arguments.record_date2#
                <cfelseif len(arguments.record_date) and len(arguments.record_date2)>
                    AND BA.ACTION_DATE >= #arguments.record_date# AND BA.ACTION_DATE <= #arguments.record_date2#
                </cfif>
                <cfif len(arguments.tahsil_status)>
                    AND SYPR.IS_PAYMENT = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.tahsil_status#">
                </cfif>
                <cfif len(arguments.keyword) gt 3>
                    AND ( SSLP.PAPER_NO LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.keyword#"> OR
                    STCK.STOCKBOND_CODE LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.keyword#"> )
                </cfif>
                <cfif len(arguments.record_emp_id)>
                    AND BA.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.record_emp_id#">
                </cfif>
        UNION ALL
            SELECT
                SYPR.*,
                STCK.*,
                SST.STOCKBOND_TYPE AS STOCKBOND_TYPE_,
                SSLP.PAPER_NO AS SLP_PAPER_NO,
                SSLP.COMPANY_ID,
                (SELECT TOP 1 STOCKBONDS_VALUATION_DATE FROM STOCKBONDS_YIELD_VALUATION WHERE STOCKBONDS_ROWS_ID = SYPR.YIELD_PLAN_ROWS_ID ORDER BY STOCKBONDS_VALUATION_ID DESC ) AS REESKONT_DATE,
                (SELECT SUM(ISNULL(STOCKBOND_IN,0))-SUM(ISNULL(STOCKBOND_OUT,0)) FROM STOCKBONDS_INOUT WHERE STOCKBONDS_INOUT.STOCKBOND_ID = STCK_R.STOCKBOND_ID) AS NET_QUANTITY,
                NULL ACTION_ID, 
                NULL ACTION_VALUE, 
                NULL MASRAF, 
                NULL ACTION_TYPE_ID, 
                NULL ACTION_DATE,
                CR.ACTION_ID AS CR_ACTION_ID,
                CR.ACTION_VALUE AS CR_ACTION_VALUE,
                CR.ACTION_TYPE_ID AS CR_ACTION_TYPE_ID,
                CR.ACTION_DATE AS CR_ACTION_DATE
            FROM
                STOCKBONDS_YIELD_PLAN_ROWS AS SYPR 
                LEFT JOIN STOCKBONDS_SALEPURCHASE_ROW AS STCK_R ON SYPR.STOCKBOND_ID = STCK_R.STOCKBOND_ID
                LEFT JOIN STOCKBONDS_SALEPURCHASE AS SSLP ON STCK_R.SALES_PURCHASE_ID = SSLP.ACTION_ID
                LEFT JOIN STOCKBONDS AS STCK ON STCK.STOCKBOND_ID = STCK_R.STOCKBOND_ID
                LEFT JOIN #dsn#.SETUP_STOCKBOND_TYPE SST ON STCK.STOCKBOND_TYPE = SST.STOCKBOND_TYPE_ID
                INNER JOIN #dsn2#.CARI_ROWS AS CR ON SSLP.ACTION_ID = CR.ACTION_ID
            WHERE
                CR.ACTION_TABLE = 'STOCKBONDS_SALEPURCHASE'
                AND SSLP.IS_SALES_PURCHASE = 0
                AND (SELECT SUM(ISNULL(STOCKBOND_IN,0))-SUM(ISNULL(STOCKBOND_OUT,0)) FROM STOCKBONDS_INOUT WHERE STOCKBONDS_INOUT.STOCKBOND_ID = STCK.STOCKBOND_ID) > 0
                <cfif len(arguments.keyword) gt 3>
                    AND ( SSLP.PAPER_NO LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.keyword#"> OR
                    STCK.STOCKBOND_CODE LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.keyword#"> )
                </cfif>
                <cfif len(arguments.tahsil_status)>
                    AND SYPR.IS_PAYMENT = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.tahsil_status#">
                </cfif>
        UNION ALL
            SELECT
                SYPR.*,
                STCK.*,
                SST.STOCKBOND_TYPE AS STOCKBOND_TYPE_,
                SSLP.PAPER_NO AS SLP_PAPER_NO,
                SSLP.COMPANY_ID,
                (SELECT TOP 1 STOCKBONDS_VALUATION_DATE FROM STOCKBONDS_YIELD_VALUATION WHERE STOCKBONDS_ROWS_ID = SYPR.YIELD_PLAN_ROWS_ID ORDER BY STOCKBONDS_VALUATION_ID DESC ) AS REESKONT_DATE,
                (SELECT SUM(ISNULL(STOCKBOND_IN,0))-SUM(ISNULL(STOCKBOND_OUT,0)) FROM STOCKBONDS_INOUT WHERE STOCKBONDS_INOUT.STOCKBOND_ID = STCK.STOCKBOND_ID) AS NET_QUANTITY,
                NULL BA_ACTION_ID, 
                NULL BA_ACTION_VALUE, 
                NULL BA_MASRAF, 
                NULL BA_ACTION_TYPE_ID, 
                NULL BA_ACTION_DATE,
                NULL CR_ACTION_ID,
                NULL CR_ACTION_VALUE,
                NULL CR_ACTION_TYPE_ID,
                NULL CR_ACTION_DATE
            FROM 
                STOCKBONDS_YIELD_PLAN_ROWS AS SYPR 
                LEFT JOIN STOCKBONDS_SALEPURCHASE_ROW AS STCK_R ON SYPR.STOCKBOND_ID = STCK_R.STOCKBOND_ID
                LEFT JOIN STOCKBONDS_SALEPURCHASE AS SSLP ON STCK_R.SALES_PURCHASE_ID = SSLP.ACTION_ID
                LEFT JOIN STOCKBONDS AS STCK ON STCK.STOCKBOND_ID = STCK_R.STOCKBOND_ID
                LEFT JOIN #dsn#.SETUP_STOCKBOND_TYPE SST ON STCK.STOCKBOND_TYPE = SST.STOCKBOND_TYPE_ID
            WHERE 
                SSLP.COMPANY_ID IS NOT NULL AND SSLP.ACTION_ID NOT IN (SELECT ACTION_ID FROM #dsn2#.CARI_ROWS WHERE ACTION_TABLE = 'STOCKBONDS_SALEPURCHASE')
                AND (SELECT SUM(ISNULL(STOCKBOND_IN,0))-SUM(ISNULL(STOCKBOND_OUT,0)) FROM STOCKBONDS_INOUT WHERE STOCKBONDS_INOUT.STOCKBOND_ID = STCK.STOCKBOND_ID) > 0
                AND SSLP.IS_SALES_PURCHASE = 0
                <cfif len(arguments.keyword) gt 3>
                    AND ( SSLP.PAPER_NO LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.keyword#"> OR
                    STCK.STOCKBOND_CODE LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.keyword#"> )
                </cfif>
                <cfif len(arguments.tahsil_status)>
                    AND SYPR.IS_PAYMENT = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.tahsil_status#">
                </cfif>
        ORDER BY SYPR.BANK_ACTION_DATE ASC
        </cfquery>
        <cfreturn GET_YIELD_PLAN_ROWS>
    </cffunction>

    <cffunction name="GET_STOCKBONDS_DAD" returntype="any">
        <cfquery name="GET_STOCKBONDS_DAD" datasource="#dsn3#">
            WITH CTE1 AS
            	(
                    SELECT 
                        S.*,
                        SST.STOCKBOND_TYPE_ID,
                        SST.STOCKBOND_TYPE AS STOCKBOND_TYPE_,
                        SSLP.OTHER_MONEY,
                        SSLP.ACCOUNT_CODE,
                        ROW_NUMBER() OVER (ORDER BY S.RECORD_DATE DESC ) AS RowNum,
                        ( SELECT SUM(ISNULL(STOCKBOND_IN,0))-SUM(ISNULL(STOCKBOND_OUT,0)) FROM STOCKBONDS_INOUT WHERE STOCKBONDS_INOUT.STOCKBOND_ID = S.STOCKBOND_ID ) AS NET_QUANTITY,
                        ( SELECT TOP 1 ACTUAL_VALUE FROM STOCKBONDS_VALUE_CHANGES AS SVC WHERE SVC.STOCKBOND_ID = S.STOCKBOND_ID ORDER BY DATE DESC ) AS LAST_ACTUAL_VALUE,
                        ( SELECT TOP 1 OTHER_ACTUAL_VALUE FROM STOCKBONDS_VALUE_CHANGES AS SVC WHERE SVC.STOCKBOND_ID = S.STOCKBOND_ID ORDER BY DATE DESC ) AS LAST_OTHER_ACTUAL_VALUE,
                        ( SELECT TOP 1 DATE FROM STOCKBONDS_VALUE_CHANGES AS SVC WHERE SVC.STOCKBOND_ID = S.STOCKBOND_ID  ORDER BY DATE DESC ) AS LAST_ACTUAL_DATE,
                        ( SELECT TOP 1 ACTUAL_VALUE FROM STOCKBONDS_VALUE_CHANGES AS SVC WHERE SVC.STOCKBOND_ID = S.STOCKBOND_ID AND IS_DAD_ACCOUNT = 1 AND IS_DAD_ACCOUNT IS NOT NULL ORDER BY DATE DESC ) AS IS_DAD_LAST_ACTUAL_VALUE,
                        ( SELECT TOP 1 OTHER_ACTUAL_VALUE FROM STOCKBONDS_VALUE_CHANGES AS SVC WHERE SVC.STOCKBOND_ID = S.STOCKBOND_ID AND IS_DAD_ACCOUNT = 1 AND IS_DAD_ACCOUNT IS NOT NULL ORDER BY DATE DESC ) AS IS_DAD_LAST_OTHER_ACTUAL_VALUE,
                        ( SELECT TOP 1 IS_DAD_ACCOUNT_DATE FROM STOCKBONDS_VALUE_CHANGES AS SVC WHERE SVC.STOCKBOND_ID = S.STOCKBOND_ID AND IS_DAD_ACCOUNT = 1 AND IS_DAD_ACCOUNT IS NOT NULL ORDER BY DATE DESC ) AS IS_DAD_LAST_ACTUAL_DATE
                    FROM
                        STOCKBONDS_SALEPURCHASE_ROW AS STCK_R
                        LEFT JOIN STOCKBONDS_SALEPURCHASE AS SSLP ON STCK_R.SALES_PURCHASE_ID = SSLP.ACTION_ID
                        LEFT JOIN STOCKBONDS AS S ON S.STOCKBOND_ID = STCK_R.STOCKBOND_ID
                        LEFT JOIN #dsn#.SETUP_STOCKBOND_TYPE SST ON S.STOCKBOND_TYPE = SST.STOCKBOND_TYPE_ID
                        --LEFT JOIN STOCKBONDS_SALEPURCHASE SSP ON SSP.BANK_ACTION_ID = S.BANK_ACTION_ID 
                        <cfif len(arguments.AllRow)>
                            INNER JOIN STOCKBONDS_VALUE_CHANGES VLC ON VLC.STOCKBOND_ID = S.STOCKBOND_ID 
                        </cfif>
                    WHERE 
                        S.STOCKBOND_ID IS NOT NULL
                        AND SSLP.IS_SALES_PURCHASE = 0
                        <cfif len(arguments.Allrow)>
                            AND VLC.HISTORY_ID IN (#arguments.Allrow#)    
                        </cfif>
                        AND (SELECT SUM(ISNULL(STOCKBOND_IN,0))-SUM(ISNULL(STOCKBOND_OUT,0)) FROM STOCKBONDS_INOUT WHERE STOCKBONDS_INOUT.STOCKBOND_ID = S.STOCKBOND_ID) > 0
                    <cfif len(arguments.stockbond_type_id)>
                        AND S.STOCKBOND_TYPE = #arguments.stockbond_type_id#
                    </cfif>
				)
                SELECT 
                	CTE1.*,
                    (SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT,
                    ROW_NUMBER() OVER (ORDER BY RECORD_DATE DESC ) AS RowNum
                FROM
                	CTE1
                WHERE
               		RowNum BETWEEN #arguments.startrow# and #arguments.startrow#+(#arguments.maxrows#-1)
        </cfquery>
        <cfreturn GET_STOCKBONDS_DAD>
    </cffunction>


    <cffunction name="get_acc_code_exp" returntype="any">
        <cfquery name="get_acc_code_exp" datasource="#dsn2#">
            SELECT 
                ACCOUNT_CODE
             FROM 
                EXPENSE_ITEMS 
            WHERE 
                EXPENSE_ITEM_ID = #arguments.expense_item_id#
        </cfquery>
        <cfreturn get_acc_code_exp>
    </cffunction>

    <cffunction name="GET_MONEY" returntype="any">
        <cfquery name="GET_MONEY" datasource="#dsn#">
            SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1
        </cfquery>
        <cfreturn GET_MONEY>
    </cffunction>

    <cffunction name="GET_ACCOUNTS" returntype="any"> <!--- Banka Hesapları // Listeleme Sayfası --->
        <cfquery name="GET_ACCOUNTS" datasource="#dsn3#">
            SELECT
                ACCOUNT_ID,
            <cfif session.ep.period_year lt 2009>
                CASE WHEN(ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNT_CURRENCY_ID END AS ACCOUNT_CURRENCY_ID,
            <cfelse>
                ACCOUNT_CURRENCY_ID,
            </cfif>
                ACCOUNT_NAME
            FROM
                ACCOUNTS
            WHERE
                ACCOUNT_STATUS = 1
            <cfif session.ep.isBranchAuthorization>
                AND ACCOUNT_ID IN(SELECT AB.ACCOUNT_ID FROM ACCOUNTS_BRANCH AB WHERE AB.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">)
            </cfif>
            ORDER BY
                ACCOUNT_NAME
        </cfquery>
        <cfreturn GET_ACCOUNTS>
    </cffunction>
    
    <!--- Kredi Limitleri  Listeme Sayfası için  yapıldı. Taşdemir 03082015 --->
     <cffunction name="getCreditLimit" returntype="query" access="public">
     	<cfargument name="credit_type" default="">
        <cfargument name="account_id" default="">
        <cfargument name="startrow" default="1">
   		<cfargument name="maxrows" default="#session.ep.maxrows#">
     		<cfquery name="get_credit_limit" datasource="#this.dsn3#">
               WITH CTE1 AS( SELECT DISTINCT
                    CR.CREDIT_LIMIT_ID, 
                    CR.CREDIT_TYPE, 
                    CR.ACCOUNT_ID, 
                    CR.CREDIT_LIMIT, 
                    CR.MONEY_TYPE, 
                    CR.LIMIT_HEAD, 
                    A.ACCOUNT_NAME,
                    SCT.CREDIT_TYPE CREDIT_TYPE_NAME,
                    CR.RECORD_DATE
                 /*   SUM(CASE WHEN CCI.PROCESS_TYPE = 292 THEN CAPITAL_PRICE ELSE 0 END ) AS REVENUE_TOTAL,
                    SUM(CASE WHEN CCI.PROCESS_TYPE = 291 THEN CAPITAL_PRICE ELSE 0 END ) AS PAYMENT_TOTAL */
                FROM
                    CREDIT_LIMIT CR
                    LEFT JOIN ACCOUNTS A ON A.ACCOUNT_ID = CR.ACCOUNT_ID
                    LEFT JOIN #dsn#.SETUP_CREDIT_TYPE SCT ON CR.CREDIT_TYPE = SCT.CREDIT_TYPE_ID
                 /*   LEFT JOIN CREDIT_CONTRACT CC ON CC.CREDIT_LIMIT_ID = CR.CREDIT_LIMIT_ID
                    LEFT JOIN #dsn2#.CREDIT_CONTRACT_PAYMENT_INCOME CCI ON CC.CREDIT_CONTRACT_ID = CCI.CREDIT_CONTRACT_ID */
                  -- ilgili muhasebe döneminden değil, period id üzerinden tüm verileri çekebilecek şekilde düzenlendi..( list_credit_limit sayfasyında.) İlker A*/
                WHERE
                    1=1
				<cfif len(arguments.credit_type)>
                    AND CR.CREDIT_TYPE = #arguments.credit_type#
                </cfif>
                <cfif len(arguments.account_id)>
                    AND CR.ACCOUNT_ID = #arguments.account_id#
                </cfif>
                GROUP BY 
                     	CR.CREDIT_LIMIT_ID,
                        CR.CREDIT_TYPE,
                        CR.ACCOUNT_ID, 
                        CR.CREDIT_LIMIT,
                        CR.MONEY_TYPE,
                        CR.LIMIT_HEAD, 
                        SCT.CREDIT_TYPE,
                        CR.RECORD_DATE,
                 /*     CC.CREDIT_LIMIT_ID,
                      CC.CREDIT_CONTRACT_ID, */
                        A.ACCOUNT_NAME
               ), 
                    CTE2 AS
                    (
                        SELECT CTE1.*,
                        	ROW_NUMBER() OVER (ORDER BY RECORD_DATE) AS RowNum,
                        	(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                        FROM 
                            CTE1
                     )
                     SELECT 
                     	CTE2.*
                     FROM 
                     	CTE2
                     WHERE
               			RowNum BETWEEN #arguments.startrow# and #arguments.startrow#+(#arguments.maxrows#-1)
			</cfquery>
     		<cfreturn get_credit_limit>
     </cffunction>
     
     <cffunction name="getCreditLimitTotal" returntype="query" access="public">
     	<cfquery name="deneme" datasource="#this.dsn3#">
            SELECT 
               CR.MONEY_TYPE,
               SUM(CR.CREDIT_LIMIT) AS TOP_LIMIT
              --  SUM(CASE WHEN CCI.PROCESS_TYPE = 292 THEN CAPITAL_PRICE ELSE 0 END ) AS REVENUE_TOTAL1,
              --  SUM(CASE WHEN CCI.PROCESS_TYPE = 291 THEN CAPITAL_PRICE ELSE 0 END ) AS PAYMENT_TOTAL1
         	FROM 
                CREDIT_LIMIT CR
            GROUP BY 
                CR.MONEY_TYPE
               -- LEFT JOIN CREDIT_CONTRACT CC ON CC.CREDIT_LIMIT_ID = CR.CREDIT_LIMIT_ID
               -- LEFT JOIN #dsn2#.CREDIT_CONTRACT_PAYMENT_INCOME CCI ON CC.CREDIT_CONTRACT_ID = CCI.CREDIT_CONTRACT_ID
                -- ilgili muhasebe döneminden değil, period id üzerinden tüm verileri çekebilecek şekilde düzenlendi..( list_credit_limit sayfasyında.) İlker A*/
		/*	GROUP BY
				CR.MONEY_TYPE,
				CR.CREDIT_LIMIT,CR.CREDIT_LIMIT_ID
                ),
                CTE2 AS
                (
                	SELECT DISTINCT 
                    	MONEY_TYPE,
                        SUM(CREDIT_LIMIT) OVER (PARTITION BY MONEY_TYPE ORDER BY MONEY_TYPE) AS TOTAL_PLANLANAN_TAHSILAT,
                        SUM(REVENUE_TOTAL1) OVER (PARTITION BY MONEY_TYPE ORDER BY MONEY_TYPE) AS TOPLAM_GERCEKLESEN_TAHSILAT,
                        SUM(PAYMENT_TOTAL1) OVER (PARTITION BY MONEY_TYPE  ORDER BY MONEY_TYPE) AS TOTAL_PLANLANAN_ODEME
                    FROM 
                    	CTE1
                )
                SELECT 
                	CTE2.*
                FROM
                	CTE2 */
		</cfquery>
        <cfreturn deneme>
     </cffunction>
</cfcomponent>
