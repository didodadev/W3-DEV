<cfsetting showdebugoutput="no">
<cf_date tarih = 'attributes.date'>
<cf_date tarih = 'attributes.date2'>
<cfset main_category_list = 'SALES,PURCHASE,SALES_RETURN,PURCHASE_RETURN,POS_SALES,POS_SALES_RETURN,CURRENCY_PRICE_DUE_SALES,CURRENCY_PRICE_DUE_PURCHASE,CONSIGMENT_SALES'>
<cfset query_cell_list = '_PAPER_COUNT,_AMOUNT,_NETTOTAL,_OTHER_MONEY_VALUE,_DATE_DIFF'>
<!--- <cfloop list="#main_category_list#" index="mci">
    <cfloop list="#query_cell_list#" index="qci">
       <cfoutput>#mci##qci#</cfoutput><br/>
    </cfloop>
</cfloop><cfabort> --->
<!---GÖNDERİLEN DEĞERE GÖRE STOK BAZINDA veya MÜŞTERİ BAZINDA MASTER TABLO OLUŞTURULUYOR. --->
<cfif attributes.table_name is 'SALES_PURCHASE_CUSTOMER_MONTH'><!--- MÜŞTERİ BAZINDA İSE --->
	<cfset _group_by_id_ ='I.COMPANY_ID,I.CONSUMER_ID'>
    <cfset _where_parameter_ ='AND (COMPANY_ID IS NOT NULL OR CONSUMER_ID  IS NOT NULL)'>
<cfelse><!--- STOK BAZINDA İSE --->
	<cfset _group_by_id_ ='IR.STOCK_ID'>
   <cfset _where_parameter_ ='AND IR.STOCK_ID IS NOT NULL'>
</cfif>
<cfquery name="GET_ALL_SALES_PURCHASE" datasource="#attributes.new_donem_data_source#">
INSERT INTO #dsn_report_alias#.#attributes.table_name#
(
	<cfif attributes.table_name is 'SALES_PURCHASE_CUSTOMER_MONTH'><!--- MÜŞTERİ BAZINDA İSE --->
        COMPANY_ID,
        CONSUMER_ID,
        OUR_COMPANY_ID,
        PERIOD_YEAR,
        PERIOD_MONTH,
        MEMBER_CODE,
        MEMBER_NAME
    <cfelse><!--- STOK BAZINDA İSE --->
        STOCK_ID,
        OUR_COMPANY_ID,
        PERIOD_YEAR,
        PERIOD_MONTH,
        PRODUCT_ID,
        PRODUCT_CODE,
        PRODUCT_NAME
    </cfif>
     <cfloop list="#main_category_list#" index="mci">
        <cfloop list="#query_cell_list#" index="qci">
           <cfoutput>,#mci##qci#</cfoutput>
        </cfloop>
    </cfloop>
	,SALES_COST
	,SALES_OTHER_COST
)
SELECT
	<cfif attributes.table_name is 'SALES_PURCHASE_CUSTOMER_MONTH'><!--- MÜŞTERİ BAZINDA İSE --->
    COMPANY_ID,
    CONSUMER_ID,
    #attributes.period_our_company_id#,
    #attributes.period_year#,
    #attributes.period_month#,
    NULL,<!--- MEMBER_CODE, ---><!--- BU DEĞER AŞAĞIDA UPDATE EDİLİCEK TOPLU HALDE --->
    NULL<!--- MEMBER_NAME ---><!--- BU DEĞER AŞAĞIDA UPDATE EDİLİCEK TOPLU HALDE --->
    <cfelse><!--- STOK BAZINDA İSE --->
    STOCK_ID,
    #attributes.period_our_company_id#,
    #attributes.period_year#,
    #attributes.period_month#,
    NULL,<!--- BU DEĞER AŞAĞIDA UPDATE EDİLİCEK TOPLU HALDE --->
    NULL,<!--- BU DEĞER AŞAĞIDA UPDATE EDİLİCEK TOPLU HALDE --->
    NULL<!--- BU DEĞER AŞAĞIDA UPDATE EDİLİCEK TOPLU HALDE --->
    </cfif>
    <cfloop list="#main_category_list#" index="mci">
        <cfloop list="#query_cell_list#" index="qci">
           <cfoutput>,SUM(#mci##qci#) AS #mci##qci#</cfoutput>
        </cfloop>
    </cfloop>
    ,SUM(SALES_COST) AS SALES_COST
    ,SUM(SALES_OTHER_COST) AS SALES_OTHER_COST
    FROM (
            SELECT 
                #_group_by_id_#
                <cfloop list="#main_category_list#" index="mci">
                    <cfif mci eq 'SALES'>
                    	,1 SALES_PAPER_COUNT
                        ,IR.AMOUNT SALES_AMOUNT
                        ,CASE WHEN (I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)=0  THEN IR.NETTOTAL ELSE (1- ISNULL(I.SA_DISCOUNT,0)/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL END AS SALES_NETTOTAL
                        ,CASE WHEN (I.OTHER_MONEY_VALUE-I.TAXTOTAL+I.SA_DISCOUNT)=0  THEN IR.OTHER_MONEY_VALUE ELSE (1- ISNULL(I.SA_DISCOUNT,0)/(I.OTHER_MONEY_VALUE-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.OTHER_MONEY_VALUE END AS SALES_OTHER_MONEY_VALUE
                        ,CASE WHEN DATEDIFF(day,I.INVOICE_DATE,ISNULL(I.DUE_DATE,I.INVOICE_DATE)) = 0 THEN 1 ELSE  DATEDIFF(day,I.INVOICE_DATE,ISNULL(I.DUE_DATE,I.INVOICE_DATE)) END AS SALES_DATE_DIFF
                    <cfelse>
                        <cfloop list="#query_cell_list#" index="qci">
                            ,0 AS <cfoutput>#mci##qci#</cfoutput>
                        </cfloop>
                    </cfif>
                </cfloop>
                ,ISNULL(
                        (
                            SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)
                            FROM 
                                #attributes.NEW_SIRKET_DATA_SOURCE#.PRODUCT_COST PRODUCT_COST
                            WHERE 
                                PRODUCT_COST.PRODUCT_ID=IR.PRODUCT_ID AND
                                ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM #attributes.NEW_SIRKET_DATA_SOURCE#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID=IR.SPECT_VAR_ID),0) AND
                                PRODUCT_COST.START_DATE <= I.INVOICE_DATE
                                
                            ORDER BY
                                PRODUCT_COST.START_DATE DESC,
                                PRODUCT_COST.RECORD_DATE DESC,
                                PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
                        ),0) SALES_COST
                ,ISNULL(
                        (
                            SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                            FROM 
                                #attributes.NEW_SIRKET_DATA_SOURCE#.PRODUCT_COST PRODUCT_COST
                            WHERE 
                                PRODUCT_COST.PRODUCT_ID=IR.PRODUCT_ID AND
                                ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM #attributes.NEW_SIRKET_DATA_SOURCE#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID=IR.SPECT_VAR_ID),0) AND
                                PRODUCT_COST.START_DATE <= I.INVOICE_DATE
                                
                            ORDER BY
                                PRODUCT_COST.START_DATE DESC,
                                PRODUCT_COST.RECORD_DATE DESC,
                                PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
                        ),0) SALES_OTHER_COST
            FROM 
                INVOICE I,
                INVOICE_ROW IR
            WHERE 
                I.INVOICE_ID=IR.INVOICE_ID
                AND I.IS_IPTAL = 0
                AND I.INVOICE_CAT IN (53,52,56,561,66,531)
                #_where_parameter_#
                AND I.INVOICE_DATE >= #attributes.date#
                AND I.INVOICE_DATE <= #attributes.date2#
            UNION ALL
              SELECT
                #_group_by_id_#
                <cfloop list="#main_category_list#" index="mci">
                    <cfif mci eq 'PURCHASE'>
                    	,1 PURCHASE_PAPER_COUNT
                        ,IR.AMOUNT PURCHASE_AMOUNT
                        ,CASE WHEN (I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)=0  THEN IR.NETTOTAL ELSE (1- ISNULL(I.SA_DISCOUNT,0)/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL END AS PURCHASE_NETTOTAL
                        ,CASE WHEN (I.OTHER_MONEY_VALUE-I.TAXTOTAL+I.SA_DISCOUNT)=0  THEN IR.OTHER_MONEY_VALUE ELSE (1- ISNULL(I.SA_DISCOUNT,0)/(I.OTHER_MONEY_VALUE-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.OTHER_MONEY_VALUE END AS PURCHASE_OTHER_MONEY_VALUE
                        ,CASE WHEN DATEDIFF(day,I.INVOICE_DATE,ISNULL(I.DUE_DATE,I.INVOICE_DATE)) = 0 THEN 1 ELSE  DATEDIFF(day,I.INVOICE_DATE,ISNULL(I.DUE_DATE,I.INVOICE_DATE)) END AS PURCHASE_DATE_DIFF
                    <cfelse>
                        <cfloop list="#query_cell_list#" index="qci">
                            ,0 AS <cfoutput>#mci##qci#</cfoutput>
                        </cfloop>
                    </cfif>
                </cfloop>
                ,0 AS SALES_COST,0 AS SALES_OTHER_COST
            FROM 
                INVOICE I,
                INVOICE_ROW IR
            WHERE 
                I.INVOICE_ID=IR.INVOICE_ID
                AND I.IS_IPTAL = 0
                AND I.INVOICE_CAT IN (59,60,601,64,65,68,690,691,591,592)
                #_where_parameter_#
                AND I.INVOICE_DATE >= #attributes.date#
                AND I.INVOICE_DATE <= #attributes.date2#
            UNION ALL
              SELECT
                #_group_by_id_#
                <cfloop list="#main_category_list#" index="mci">
                    <cfif mci eq 'SALES_RETURN'>
                       ,1 SALES_RETURN_PAPER_COUNT
                       ,IR.AMOUNT SALES_RETURN_AMOUNT
                       ,CASE WHEN (I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)=0  THEN IR.NETTOTAL ELSE (1- ISNULL(I.SA_DISCOUNT,0)/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL END AS SALES_RETURN_NETTOTAL
                       ,CASE WHEN (I.OTHER_MONEY_VALUE-I.TAXTOTAL+I.SA_DISCOUNT)=0  THEN IR.OTHER_MONEY_VALUE ELSE (1- ISNULL(I.SA_DISCOUNT,0)/(I.OTHER_MONEY_VALUE-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.OTHER_MONEY_VALUE END AS SALES_RETURN_OTHER_MONEY_VALUE
                       ,CASE WHEN DATEDIFF(day,I.INVOICE_DATE,ISNULL(I.DUE_DATE,I.INVOICE_DATE)) = 0 THEN 1 ELSE  DATEDIFF(day,I.INVOICE_DATE,ISNULL(I.DUE_DATE,I.INVOICE_DATE)) END AS SALES_RETURN_DATE_DIFF
                    <cfelse>
                        <cfloop list="#query_cell_list#" index="qci">
                            ,0 AS <cfoutput>#mci##qci#</cfoutput>
                        </cfloop>
                    </cfif>
                </cfloop>
                ,0 AS SALES_COST,0 AS SALES_OTHER_COST
            FROM 
                INVOICE I,
                INVOICE_ROW IR
            WHERE 
                I.INVOICE_ID=IR.INVOICE_ID
                AND I.IS_IPTAL = 0
                AND I.INVOICE_CAT IN (54,55)
                #_where_parameter_#
                AND I.INVOICE_DATE >= #attributes.date#
                AND I.INVOICE_DATE <= #attributes.date2#
            UNION ALL
                SELECT
                #_group_by_id_#
                <cfloop list="#main_category_list#" index="mci">
                    <cfif mci eq 'PURCHASE_RETURN'>
                    	,1 PURCHASE_RETURN_PAPER_COUNT
                        ,IR.AMOUNT PURCHASE_RETURN_AMOUNT
                        ,CASE WHEN (I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)=0  THEN IR.NETTOTAL ELSE (1- ISNULL(I.SA_DISCOUNT,0)/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL END AS PURCHASE_RETURN_NETTOTAL
                        ,CASE WHEN (I.OTHER_MONEY_VALUE-I.TAXTOTAL+I.SA_DISCOUNT)=0  THEN IR.OTHER_MONEY_VALUE ELSE (1- ISNULL(I.SA_DISCOUNT,0)/(I.OTHER_MONEY_VALUE-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.OTHER_MONEY_VALUE END AS PURCHASE_RETURN_OTHER_MONEY_VALUE
                        ,CASE WHEN DATEDIFF(day,I.INVOICE_DATE,ISNULL(I.DUE_DATE,I.INVOICE_DATE)) = 0 THEN 1 ELSE  DATEDIFF(day,I.INVOICE_DATE,ISNULL(I.DUE_DATE,I.INVOICE_DATE)) END AS PURCHASE_RETURN_DATE_DIFF
                    <cfelse>
                        <cfloop list="#query_cell_list#" index="qci">
                            ,0 AS <cfoutput>#mci##qci#</cfoutput>
                        </cfloop>
                    </cfif>
                </cfloop>
                ,0 AS SALES_COST,0 AS SALES_OTHER_COST
            FROM 
                INVOICE I,
                INVOICE_ROW IR
            WHERE 
                I.INVOICE_ID=IR.INVOICE_ID
                AND I.IS_IPTAL = 0
                AND I.INVOICE_CAT IN (62)
                #_where_parameter_#
                AND I.INVOICE_DATE >= #attributes.date#
                AND I.INVOICE_DATE <= #attributes.date2#
            UNION ALL
            SELECT
                #_group_by_id_#
                <cfloop list="#main_category_list#" index="mci">
                    <cfif mci eq 'POS_SALES'>
                    	,1 POS_SALES_PAPER_COUNT
                        ,IR.AMOUNT POS_SALES_AMOUNT
                        ,CASE WHEN (I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)=0  THEN IR.NETTOTAL ELSE (1- ISNULL(I.SA_DISCOUNT,0)/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL END AS POS_SALES_NETTOTAL
                        ,CASE WHEN (I.OTHER_MONEY_VALUE-I.TAXTOTAL+I.SA_DISCOUNT)=0  THEN IR.OTHER_MONEY_VALUE ELSE (1- ISNULL(I.SA_DISCOUNT,0)/(I.OTHER_MONEY_VALUE-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.OTHER_MONEY_VALUE END AS POS_SALES_OTHER_MONEY_VALUE
                        ,CASE WHEN DATEDIFF(day,I.INVOICE_DATE,ISNULL(I.DUE_DATE,I.INVOICE_DATE)) = 0 THEN 1 ELSE  DATEDIFF(day,I.INVOICE_DATE,ISNULL(I.DUE_DATE,I.INVOICE_DATE)) END AS POS_SALES_DATE_DIFF
                    <cfelse>
                        <cfloop list="#query_cell_list#" index="qci">
                            ,0 AS <cfoutput>#mci##qci#</cfoutput>
                        </cfloop>
                    </cfif>
                </cfloop>
                ,ISNULL(
                        (
                            SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)
                            FROM 
                                #attributes.NEW_SIRKET_DATA_SOURCE#.PRODUCT_COST PRODUCT_COST
                            WHERE 
                                PRODUCT_COST.PRODUCT_ID=IR.PRODUCT_ID AND
                                PRODUCT_COST.START_DATE <= I.INVOICE_DATE
                                
                            ORDER BY
                                PRODUCT_COST.START_DATE DESC,
                                PRODUCT_COST.RECORD_DATE DESC,
                                PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
                        ),0) SALES_COST
                ,ISNULL(
                        (
                            SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM_2+PURCHASE_EXTRA_COST_SYSTEM_2)
                            FROM 
                                #attributes.NEW_SIRKET_DATA_SOURCE#.PRODUCT_COST PRODUCT_COST
                            WHERE 
                                PRODUCT_COST.PRODUCT_ID=IR.PRODUCT_ID AND
                                PRODUCT_COST.START_DATE <= I.INVOICE_DATE
                                
                            ORDER BY
                                PRODUCT_COST.START_DATE DESC,
                                PRODUCT_COST.RECORD_DATE DESC,
                                PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
                        ),0) SALES_OTHER_COST
            FROM 
                INVOICE I,
                INVOICE_ROW_POS IR
            WHERE 
                I.INVOICE_ID=IR.INVOICE_ID
                AND I.IS_IPTAL = 0
                AND I.INVOICE_CAT IN (69,67)
                #_where_parameter_#
                AND ROW_TYPE IS NULL<!--- SATIŞ --->
                AND I.INVOICE_DATE >= #attributes.date#
                AND I.INVOICE_DATE <= #attributes.date2#
            UNION ALL
            SELECT
                #_group_by_id_#
                <cfloop list="#main_category_list#" index="mci">
                    <cfif mci eq 'POS_SALES_RETURN'>
                    	,1 POS_SALES_RETURN_PAPER_COUNT
                        ,IR.AMOUNT POS_SALES_RETURN_AMOUNT
                        ,CASE WHEN (I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)=0  THEN IR.NETTOTAL ELSE (1- ISNULL(I.SA_DISCOUNT,0)/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL END AS POS_SALES_RETURN_NETTOTAL
                        ,CASE WHEN (I.OTHER_MONEY_VALUE-I.TAXTOTAL+I.SA_DISCOUNT)=0  THEN IR.OTHER_MONEY_VALUE ELSE (1- ISNULL(I.SA_DISCOUNT,0)/(I.OTHER_MONEY_VALUE-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.OTHER_MONEY_VALUE END AS POS_SALES_RETURN_OTHER_MONEY_VALUE
                        ,CASE WHEN DATEDIFF(day,I.INVOICE_DATE,ISNULL(I.DUE_DATE,I.INVOICE_DATE)) = 0 THEN 1 ELSE  DATEDIFF(day,I.INVOICE_DATE,ISNULL(I.DUE_DATE,I.INVOICE_DATE)) END AS POS_SALES_RETURN_DATE_DIFF
                    <cfelse>
                        <cfloop list="#query_cell_list#" index="qci">
                            ,0 AS <cfoutput>#mci##qci#</cfoutput>
                        </cfloop>
                    </cfif>
                </cfloop>
                ,0 AS SALES_COST,0 AS SALES_OTHER_COST
            FROM 
                INVOICE I,
                INVOICE_ROW_POS IR
            WHERE 
                I.INVOICE_ID=IR.INVOICE_ID
                AND I.IS_IPTAL = 0
                AND I.INVOICE_CAT IN (69,67)
                #_where_parameter_#
                AND ROW_TYPE = 0<!--- RETURN --->
                AND I.INVOICE_DATE >= #attributes.date#
                AND I.INVOICE_DATE <= #attributes.date2#
            UNION ALL
            SELECT
                #_group_by_id_#
                <cfloop list="#main_category_list#" index="mci">
                    <cfif mci eq 'CURRENCY_PRICE_DUE_SALES'>
                    	,1 CURRENCY_PRICE_DUE_SALES_PAPER_COUNT
                        ,IR.AMOUNT CURRENCY_PRICE_DUE_SALES_AMOUNT
                        ,CASE WHEN (I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)=0  THEN IR.NETTOTAL ELSE (1- ISNULL(I.SA_DISCOUNT,0)/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL END AS CURRENCY_PRICE_DUE_SALES_NETTOTAL
                        ,CASE WHEN (I.OTHER_MONEY_VALUE-I.TAXTOTAL+I.SA_DISCOUNT)=0  THEN IR.OTHER_MONEY_VALUE ELSE (1- ISNULL(I.SA_DISCOUNT,0)/(I.OTHER_MONEY_VALUE-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.OTHER_MONEY_VALUE END AS CURRENCY_PRICE_DUE_SALES_OTHER_MONEY_VALUE
                       ,CASE WHEN DATEDIFF(day,I.INVOICE_DATE,ISNULL(I.DUE_DATE,I.INVOICE_DATE)) = 0 THEN 1 ELSE  DATEDIFF(day,I.INVOICE_DATE,ISNULL(I.DUE_DATE,I.INVOICE_DATE)) END AS CURRENCY_PRICE_DUE_SALES_DATE_DIFF
                    <cfelse>
                        <cfloop list="#query_cell_list#" index="qci">
                            ,0 AS <cfoutput>#mci##qci#</cfoutput>
                        </cfloop>
                    </cfif>
                </cfloop>
                ,0 AS SALES_COST,0 AS SALES_OTHER_COST
            FROM 
                INVOICE I,
                INVOICE_ROW IR
            WHERE 
                I.INVOICE_ID=IR.INVOICE_ID
                AND I.IS_IPTAL = 0
                AND I.INVOICE_CAT IN (58,48,50)
                #_where_parameter_#
                AND I.INVOICE_DATE >= #attributes.date#
                AND I.INVOICE_DATE <= #attributes.date2#
       UNION ALL
            SELECT
                #_group_by_id_#
                <cfloop list="#main_category_list#" index="mci">
                    <cfif mci eq 'CURRENCY_PRICE_DUE_PURCHASE'>
                    	,1 CURRENCY_PRICE_DUE_PURCHASE_PAPER_COUNT
                        ,IR.AMOUNT CURRENCY_PRICE_DUE_PURCHASE_AMOUNT
                        ,CASE WHEN (I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)=0  THEN IR.NETTOTAL ELSE (1- ISNULL(I.SA_DISCOUNT,0)/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL END AS CURRENCY_PRICE_DUE_PURCHASE_NETTOTAL
                        ,CASE WHEN (I.OTHER_MONEY_VALUE-I.TAXTOTAL+I.SA_DISCOUNT)=0  THEN IR.OTHER_MONEY_VALUE ELSE (1- ISNULL(I.SA_DISCOUNT,0)/(I.OTHER_MONEY_VALUE-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.OTHER_MONEY_VALUE END AS CURRENCY_PRICE_DUE_PURCHASE_OTHER_MONEY_VALUE
                        ,CASE WHEN DATEDIFF(day,I.INVOICE_DATE,ISNULL(I.DUE_DATE,I.INVOICE_DATE)) = 0 THEN 1 ELSE  DATEDIFF(day,I.INVOICE_DATE,ISNULL(I.DUE_DATE,I.INVOICE_DATE)) END AS CURRENCY_PRICE_DUE_PURCHASE_DATE_DIFF
                    <cfelse>
                        <cfloop list="#query_cell_list#" index="qci">
                            ,0 AS <cfoutput>#mci##qci#</cfoutput>
                        </cfloop>
                    </cfif>
                </cfloop>
                ,0 AS SALES_COST,0 AS SALES_OTHER_COST
            FROM 
                INVOICE I,
                INVOICE_ROW IR
            WHERE 
                I.INVOICE_ID=IR.INVOICE_ID
                AND I.IS_IPTAL = 0
                AND I.INVOICE_CAT IN (63,51,49)
                #_where_parameter_#
                AND I.INVOICE_DATE >= #attributes.date#
                AND I.INVOICE_DATE <= #attributes.date2#
            UNION ALL
            SELECT
                #_group_by_id_#
                <cfloop list="#main_category_list#" index="mci">
                    <cfif mci eq 'CONSIGMENT_SALES'>
                    	,1 CONSIGMENT_SALES_PAPER_COUNT
                        ,IR.AMOUNT CONSIGMENT_SALES_AMOUNT
                        ,CASE WHEN (I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)=0  THEN IR.NETTOTAL ELSE (1- ISNULL(I.SA_DISCOUNT,0)/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL END AS CONSIGMENT_SALES_NETTOTAL
                        ,CASE WHEN (I.OTHER_MONEY_VALUE-I.TAXTOTAL+I.SA_DISCOUNT)=0  THEN IR.OTHER_MONEY_VALUE ELSE (1- ISNULL(I.SA_DISCOUNT,0)/(I.OTHER_MONEY_VALUE-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.OTHER_MONEY_VALUE END AS CONSIGMENT_SALES_OTHER_MONEY_VALUE
                        ,CASE WHEN DATEDIFF(day,I.INVOICE_DATE,ISNULL(I.DUE_DATE,I.INVOICE_DATE)) = 0 THEN 1 ELSE  DATEDIFF(day,I.INVOICE_DATE,ISNULL(I.DUE_DATE,I.INVOICE_DATE)) END AS CONSIGMENT_SALES_DATE_DIFF
                    <cfelse>
                        <cfloop list="#query_cell_list#" index="qci">
                            ,0 AS <cfoutput>#mci##qci#</cfoutput>
                        </cfloop>
                    </cfif>
                </cfloop>
                ,0 AS SALES_COST,0 AS SALES_OTHER_COST
            FROM 
                INVOICE I,
                INVOICE_ROW IR
            WHERE 
                I.INVOICE_ID=IR.INVOICE_ID
                AND I.IS_IPTAL = 0
                AND I.INVOICE_CAT IN (532)
                #_where_parameter_#
                AND I.INVOICE_DATE >= #attributes.date#
                AND I.INVOICE_DATE <= #attributes.date2#
		) TABLE_1
GROUP BY
<cfif attributes.table_name is 'SALES_PURCHASE_CUSTOMER_MONTH'>
    COMPANY_ID,CONSUMER_ID
<cfelse>
    STOCK_ID
</cfif>
</cfquery>
<cfquery name="UPD_ALL_SALES_PRODUCT_INFO" datasource="#DSN_REPORT#">
	<cfif attributes.table_name is 'SALES_PURCHASE_CUSTOMER_MONTH'><!--- MÜŞTERİ BAZINDA İSE! --->
        UPDATE
            SALES_PURCHASE_CUSTOMER_MONTH
        SET 
            MEMBER_CODE=(SELECT C1.MEMBER_CODE FROM #dsn_alias#.COMPANY C1 WHERE C1.COMPANY_ID=SALES_PURCHASE_CUSTOMER_MONTH.COMPANY_ID AND SALES_PURCHASE_CUSTOMER_MONTH.COMPANY_ID IS NOT NULL),
            MEMBER_NAME=(SELECT C2.FULLNAME FROM #dsn_alias#.COMPANY C2 WHERE C2.COMPANY_ID=SALES_PURCHASE_CUSTOMER_MONTH.COMPANY_ID AND SALES_PURCHASE_CUSTOMER_MONTH.COMPANY_ID IS NOT NULL)
        WHERE
            (MEMBER_CODE IS NULL OR MEMBER_NAME IS NULL)
    
        UPDATE
            SALES_PURCHASE_CUSTOMER_MONTH
        SET 
            MEMBER_CODE=(SELECT C3.MEMBER_CODE FROM #dsn_alias#.CONSUMER C3 WHERE C3.CONSUMER_ID=SALES_PURCHASE_CUSTOMER_MONTH.CONSUMER_ID AND SALES_PURCHASE_CUSTOMER_MONTH.CONSUMER_ID IS NOT NULL),
            MEMBER_NAME=(SELECT C4.CONSUMER_NAME+' '+C4.CONSUMER_SURNAME FROM #dsn_alias#.CONSUMER C4 WHERE C4.CONSUMER_ID=SALES_PURCHASE_CUSTOMER_MONTH.CONSUMER_ID AND SALES_PURCHASE_CUSTOMER_MONTH.CONSUMER_ID IS NOT NULL)
        WHERE
            (MEMBER_CODE IS NULL OR MEMBER_NAME IS NULL)
    <cfelse>
        UPDATE
            SALES_PURCHASE_PRODUCT_MONTH
        SET 
            PRODUCT_NAME=(SELECT S1.PRODUCT_NAME FROM #attributes.NEW_SIRKET_DATA_SOURCE#.STOCKS S1 WHERE S1.STOCK_ID=SALES_PURCHASE_PRODUCT_MONTH.STOCK_ID),
            PRODUCT_CODE=(SELECT S2.STOCK_CODE FROM #attributes.NEW_SIRKET_DATA_SOURCE#.STOCKS S2 WHERE S2.STOCK_ID=SALES_PURCHASE_PRODUCT_MONTH.STOCK_ID),
            PRODUCT_ID=(SELECT S3.PRODUCT_ID FROM #attributes.NEW_SIRKET_DATA_SOURCE#.STOCKS S3 WHERE S3.STOCK_ID=SALES_PURCHASE_PRODUCT_MONTH.STOCK_ID)
        WHERE
            (PRODUCT_NAME IS NULL OR PRODUCT_ID IS NULL)
	</cfif>
        AND PERIOD_YEAR = #attributes.period_year#
        AND PERIOD_MONTH = #attributes.period_month# 
        AND OUR_COMPANY_ID = #attributes.period_our_company_id#
</cfquery>
<cfquery name="get_recordcount" datasource="#DSN_REPORT#">
    SELECT 
        (SUM(SALES_PAPER_COUNT)+	SUM(PURCHASE_PAPER_COUNT)+SUM(SALES_RETURN_PAPER_COUNT)+SUM(PURCHASE_RETURN_PAPER_COUNT)+SUM(POS_SALES_PAPER_COUNT)+SUM(POS_SALES_RETURN_PAPER_COUNT)+SUM(CURRENCY_PRICE_DUE_SALES_PAPER_COUNT)+SUM(CURRENCY_PRICE_DUE_PURCHASE_PAPER_COUNT)+SUM(CONSIGMENT_SALES_PAPER_COUNT)) AS RECORD_COUNT 
    FROM 
        #attributes.table_name# WHERE  PERIOD_YEAR = #attributes.period_year#  AND PERIOD_MONTH = #attributes.period_month#  AND OUR_COMPANY_ID = #attributes.period_our_company_id#
</cfquery>
<script type="text/javascript">
	user_info_show_div(1,1,1);
</script>
<cfquery name="UPD_FLAG_STOCK_MONTHLY" datasource="#DSN_REPORT#"><!--- BELİRTİLEN AY BAZINDA KÜMÜLE RAPOR HAZIRLANDI BU SEBEBLE FINIS_DATE'I DOLDURUYORUZ.FINISH_DATE YOKSA  RAPOR YARIM KALMIŞ DEMEKTİR... --->
    UPDATE 
        REPORT_SYSTEM 
    SET 
        PROCESS_FINISH_DATE = #NOW()#,
        PROCESS_ROW_COUNT = <cfif len(get_recordcount.RECORD_COUNT)>#get_recordcount.RECORD_COUNT#<cfelse>0</cfif>
    WHERE 
        REPORT_TABLE = '#attributes.table_name#' AND 
        PERIOD_YEAR = #attributes.period_year# AND 
        PERIOD_MONTH = #attributes.period_month# AND 
        OUR_COMPANY_ID = #attributes.period_our_company_id#
</cfquery>
