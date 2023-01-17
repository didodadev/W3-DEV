<!---
    File :          kdv_beyan.cfc
    Author :        Halit Yurttaş <halityurttas@gmail.com>
    Date :          22.01.2020
    Description :   KDV Beyanamesi için veri katmanı
    Notes :         
--->
<cfcomponent extends="WMO.functions">

    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn1 = dsn & '_product'>
    <cfset dsn2 = dsn & '_' & session.ep.PERIOD_YEAR & '_' & session.ep.COMPANY_ID>
    <cfset dsn3 = dsn & '_' & session.ep.COMPANY_ID>

    <cffunction name="get_tevkifatsiz_islemler" access="public" returntype="query">
        <cfargument name="is_account" type="numeric" default="1">
        <cfargument name="sal_mon" type="string" default="">
        <cfargument name="sal_year" type="string" default="">
        <cfargument name="to_mon" type="string" default="">
        
        <cfquery name="query_tevkifatsiz_islemler" datasource="#dsn#">
            SELECT
                TAX,
                SUM(TAXTOTAL) TAXTOTAL,
                SUM(NETTOTAL) NETTOTAL,
                ACTION_TYPE,
                COUNT(INVOICE_ROW_ID) AS ROW_CNT
                FROM
                (
                    SELECT
                        IR.TAX,
                        CASE WHEN(IR.NETTOTAL = 0) THEN
                            SUM(IR.TAXTOTAL)
                        ELSE
                            SUM(((1- I.SA_DISCOUNT/#dsn#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL )*TAX/100 - (((1- I.SA_DISCOUNT/#dsn#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL )*TAX/100*ISNULL(1-(I.TEVKIFAT_ORAN),0))) 
                        END AS TAXTOTAL,
                        CASE WHEN(IR.NETTOTAL = 0) THEN
                            SUM(IR.NETTOTAL)
                        ELSE
                            SUM(((1- I.SA_DISCOUNT/#dsn#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) 
                        END AS NETTOTAL,
                        I.INVOICE_CAT AS ACTION_TYPE,
                        IR.INVOICE_ROW_ID
                    FROM
                        #dsn2#.INVOICE I
                        INNER JOIN #dsn2#.INVOICE_ROW IR ON I.INVOICE_ID = IR.INVOICE_ID
                    WHERE
                        I.INVOICE_CAT IN (48,50,52,53,56,58,69,121,561,640,680) AND 
                        IR.TAX IS NOT NULL AND
                        IR.NETTOTAL IS NOT NULL AND
                        I.IS_IPTAL = 0 AND
                        (I.TEVKIFAT_ORAN IS NULL OR I.TEVKIFAT_ORAN = 0)
                        <cfif len(arguments.is_account)>
                        AND (
                            I.INVOICE_ID IN(SELECT AC.ACTION_ID FROM #dsn2#.ACCOUNT_CARD AC WHERE I.INVOICE_ID =AC.ACTION_ID AND I.INVOICE_CAT = AC.ACTION_TYPE)
                        )
                        </cfif>
                        <cfif len(arguments.sal_mon)>
                        AND ( DATEPART(MONTH, I.INVOICE_DATE) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_mon#'> )
                        </cfif>
                        <cfif len(arguments.to_mon)>
                        AND ( DATEPART(MONTH, I.INVOICE_DATE) <= <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.to_mon#'> )
                        </cfif>
                        <cfif len(arguments.sal_year)>
                        AND ( DATEPART(YEAR, I.INVOICE_DATE) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_year#'> )
                        </cfif>
                       
                    GROUP BY
                        IR.TAX,
                        I.INVOICE_CAT,
                        IR.NETTOTAL,
                        IR.INVOICE_ROW_ID

                    UNION ALL
                    SELECT
                        ER.KDV_RATE,
                        CASE WHEN (ER.TOTAL_AMOUNT = 0) THEN
                            SUM(ER.AMOUNT_KDV)
                        ELSE
                            SUM(ER.AMOUNT_KDV - ISNULL(ER.AMOUNT_TEVKIFAT, 0))
                        END AS TAXTOTAL,
                        SUM(ER.TOTAL_AMOUNT) AS NETTOTAL,
                        E.ACTION_TYPE,
                        ER.EXP_ITEM_ROWS_ID
                    FROM #dsn2#.EXPENSE_ITEM_PLANS E
                        INNER JOIN #dsn2#.EXPENSE_ITEMS_ROWS ER ON E.EXPENSE_ID = ER.EXPENSE_ID
                    WHERE 
                        E.ACTION_TYPE IN (48,50,52,53,56,58,69,121,561,640,680) AND
                        ER.KDV_RATE IS NOT NULL AND
                        ER.TOTAL_AMOUNT IS NOT NULL AND
                        E.IS_IPTAL = 0 AND
                        (E.TEVKIFAT_ORAN IS NULL OR E.TEVKIFAT_ORAN = 0) 
                        <cfif len(arguments.is_account)>
                        AND (
                            E.EXPENSE_ID IN (SELECT AC.ACTION_ID FROM #dsn2#.ACCOUNT_CARD AC WHERE E.EXPENSE_ID = AC.ACTION_ID AND E.ACTION_TYPE = AC.ACTION_TYPE)
                        )
                        </cfif>
                        <cfif len(arguments.sal_mon)>
                        AND ( DATEPART(MONTH, E.EXPENSE_DATE) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_mon#'> )
                        </cfif>
                        <cfif len(arguments.to_mon)>
                        AND ( DATEPART(MONTH, E.EXPENSE_DATE) <= <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.to_mon#'> )
                        </cfif>
                        <cfif len(arguments.sal_year)>
                        AND ( DATEPART(YEAR, E.EXPENSE_DATE) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_year#'> )
                        </cfif>
                    GROUP BY
                        ER.KDV_RATE,
                        E.ACTION_TYPE,
                        ER.TOTAL_AMOUNT,
                        ER.EXP_ITEM_ROWS_ID
                ) T1
            GROUP BY
                TAX,
                ACTION_TYPE
        </cfquery>

        <cfreturn query_tevkifatsiz_islemler>
    </cffunction>

    <cffunction name="get_tevkifatli_islemler" access="public" returntype="query">
        <cfargument name="is_account" type="numeric" default="1">
        <cfargument name="sal_mon" type="string" default="">
        <cfargument name="sal_year" type="string" default="">
        <cfargument name="to_mon" type="string" default="">

        <cfquery name="query_tevkifatli_islemler" datasource="#dsn#">
            SELECT
                TAX,
                TEVKIFAT_CODE,
                TEVKIFAT_CODE_NAME,
                TEVKIFAT_ORAN,
                SUM(TAXTOTAL) TAXTOTAL,
                SUM(NETTOTAL) NETTOTAL
                FROM
                (
                    SELECT
                        IR.TAX,
                        CASE WHEN(IR.NETTOTAL = 0) THEN
                            SUM(IR.TAXTOTAL)
                        ELSE
                            SUM(((1- I.SA_DISCOUNT/#dsn#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL )*TAX/100 - (((1- I.SA_DISCOUNT/#dsn#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL )*TAX/100*ISNULL(1-(I.TEVKIFAT_ORAN),0)))
                        END AS TAXTOTAL,
                        CASE WHEN(IR.NETTOTAL = 0) THEN
                            SUM(IR.NETTOTAL)
                        ELSE
                            SUM(((1- I.SA_DISCOUNT/#dsn#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) 
                        END AS NETTOTAL,
                        I.INVOICE_CAT AS ACTION_TYPE,
                        IR.INVOICE_ROW_ID,
                        ST.TEVKIFAT_CODE,
                        ST.TEVKIFAT_CODE_NAME,
                        I.TEVKIFAT_ORAN
                    FROM
                        #dsn2#.INVOICE I
                        INNER JOIN #dsn2#.INVOICE_ROW IR ON I.INVOICE_ID = IR.INVOICE_ID
                        INNER JOIN #dsn3#.SETUP_TEVKIFAT ST ON I.TEVKIFAT_ID = ST.TEVKIFAT_ID
                    WHERE
                        I.INVOICE_CAT IN (48,50,52,53,56,58,69,121,561,640,680) AND 
                        IR.TAX IS NOT NULL AND
                        IR.NETTOTAL IS NOT NULL AND
                        I.IS_IPTAL = 0 AND
                        (I.TEVKIFAT_ORAN IS NOT NULL AND I.TEVKIFAT_ORAN > 0)
                        <cfif len(arguments.is_account)>
                        AND (
                            I.INVOICE_ID IN(SELECT AC.ACTION_ID FROM #dsn2#.ACCOUNT_CARD AC WHERE I.INVOICE_ID =AC.ACTION_ID AND I.INVOICE_CAT = AC.ACTION_TYPE)
                            OR
                            I.INVOICE_ID IN(SELECT AC.ACTION_ID FROM #dsn2#.ACCOUNT_CARD_SAVE AC WHERE I.INVOICE_ID = AC.ACTION_ID AND I.INVOICE_CAT = AC.ACTION_TYPE)
                                
                        )
                        </cfif>
                        <cfif len(arguments.sal_mon)>
                        AND ( DATEPART(MONTH, I.INVOICE_DATE) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_mon#'> )
                        </cfif>
                        <cfif len(arguments.to_mon)>
                        AND ( DATEPART(MONTH, I.INVOICE_DATE) <= <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.to_mon#'> )
                        </cfif>
                        <cfif len(arguments.sal_year)>
                        AND ( DATEPART(YEAR, I.INVOICE_DATE) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_year#'> )
                        </cfif>
                       
                    GROUP BY
                        IR.TAX,
                        I.INVOICE_CAT,
                        IR.NETTOTAL,
                        IR.INVOICE_ROW_ID,
                        ST.TEVKIFAT_CODE,
                        ST.TEVKIFAT_CODE_NAME,
                        I.TEVKIFAT_ORAN
                    UNION ALL
                    SELECT
                        ER.KDV_RATE,
                        CASE WHEN (ER.TOTAL_AMOUNT = 0) THEN
                            SUM(ER.AMOUNT_KDV)
                        ELSE
                            SUM(ER.AMOUNT_KDV - ISNULL(ER.AMOUNT_TEVKIFAT, 0))
                        END AS TAXTOTAL,
                        SUM(ER.TOTAL_AMOUNT) AS NETTOTAL,
                        E.ACTION_TYPE,
                        ER.EXP_ITEM_ROWS_ID,
                        ST.TEVKIFAT_CODE,
                        ST.TEVKIFAT_CODE_NAME,
                        E.TEVKIFAT_ORAN
                    FROM #dsn2#.EXPENSE_ITEM_PLANS E
                        INNER JOIN #dsn2#.EXPENSE_ITEMS_ROWS ER ON E.EXPENSE_ID = ER.EXPENSE_ID
                        INNER JOIN #dsn3#.SETUP_TEVKIFAT ST ON E.TEVKIFAT_ID = ST.TEVKIFAT_ID
                    WHERE 
                        E.ACTION_TYPE IN (48,50,52,53,56,58,69,121,561,640,680) AND
                        ER.KDV_RATE IS NOT NULL AND
                        ER.TOTAL_AMOUNT IS NOT NULL AND
                        E.IS_IPTAL = 0 AND
                        (E.TEVKIFAT_ORAN IS NOT NULL AND E.TEVKIFAT_ORAN > 0) 
                        <cfif len(arguments.is_account)>
                        AND (
                            E.EXPENSE_ID IN (SELECT AC.ACTION_ID FROM #dsn2#.ACCOUNT_CARD AC WHERE E.EXPENSE_ID = AC.ACTION_ID AND E.ACTION_TYPE = AC.ACTION_TYPE)
                        )
                        </cfif>
                        <cfif len(arguments.sal_mon)>
                        AND ( DATEPART(MONTH, E.EXPENSE_DATE) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_mon#'> )
                        </cfif>
                        <cfif len(arguments.to_mon)>
                        AND ( DATEPART(MONTH, E.EXPENSE_DATE) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.to_mon#'> )
                        </cfif>
                        <cfif len(arguments.sal_year)>
                        AND ( DATEPART(YEAR, E.EXPENSE_DATE) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_year#'> )
                        </cfif>
                    GROUP BY
                        ER.KDV_RATE,
                        E.ACTION_TYPE,
                        ER.TOTAL_AMOUNT,
                        ER.EXP_ITEM_ROWS_ID,
                        ST.TEVKIFAT_CODE,
                        ST.TEVKIFAT_CODE_NAME,
                        E.TEVKIFAT_ORAN
                ) T1
            GROUP BY
                TAX,
                TEVKIFAT_ORAN,
                TEVKIFAT_CODE,
                TEVKIFAT_CODE_NAME
        </cfquery>

        <cfreturn query_tevkifatli_islemler>
    </cffunction>

    <cffunction name="get_ilave_edilecek_kdv" access="public" returntype="query">
        <cfargument name="is_account" type="numeric" default="1">
        <cfargument name="sal_mon" type="string" default="">
        <cfargument name="sal_year" type="string" default="">
        <cfargument name="to_mon" type="string" default="">

        <cfquery name="query_ilave_edilecek_kdv" datasource="#dsn#">
            SELECT
                SUM(TAXTOTAL) TAXTOTAL,
                SUM(NETTOTAL) NETTOTAL,
                ACTION_TYPE,
                COUNT(INVOICE_ROW_ID) AS ROW_CNT
                FROM
                (
                    SELECT
                        CASE WHEN(IR.NETTOTAL = 0) THEN
                            SUM(IR.TAXTOTAL)
                        ELSE
                            SUM(((1- I.SA_DISCOUNT/#dsn#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL )*TAX/100 - (((1- I.SA_DISCOUNT/#dsn#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL )*TAX/100*ISNULL(1-(I.TEVKIFAT_ORAN),0))) 
                        END AS TAXTOTAL,
                        CASE WHEN(IR.NETTOTAL = 0) THEN
                            SUM(IR.NETTOTAL)
                        ELSE
                            SUM(((1- I.SA_DISCOUNT/#dsn#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) 
                        END AS NETTOTAL,
                        I.INVOICE_CAT AS ACTION_TYPE,
                        IR.INVOICE_ROW_ID
                    FROM
                        #dsn2#.INVOICE I
                        INNER JOIN #dsn2#.INVOICE_ROW IR ON I.INVOICE_ID = IR.INVOICE_ID
                    WHERE
                        I.INVOICE_CAT IN (62) AND 
                        IR.TAX IS NOT NULL AND
                        IR.NETTOTAL IS NOT NULL AND
                        I.IS_IPTAL = 0
                        <cfif len(arguments.is_account)>
                        AND (
                            I.INVOICE_ID IN(SELECT AC.ACTION_ID FROM #dsn2#.ACCOUNT_CARD AC WHERE I.INVOICE_ID =AC.ACTION_ID AND I.INVOICE_CAT = AC.ACTION_TYPE)
                            OR
                            I.INVOICE_ID IN(SELECT AC.ACTION_ID FROM #dsn2#.ACCOUNT_CARD_SAVE AC WHERE I.INVOICE_ID = AC.ACTION_ID AND I.INVOICE_CAT = AC.ACTION_TYPE)
                        )
                        </cfif>
                        <cfif len(arguments.sal_mon)>
                        AND ( DATEPART(MONTH, I.INVOICE_DATE) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_mon#'> )
                        </cfif>
                        <cfif len(arguments.to_mon)>
                        AND ( DATEPART(MONTH, I.INVOICE_DATE) <= <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.to_mon#'> )
                        </cfif>
                        <cfif len(arguments.sal_year)>
                        AND ( DATEPART(YEAR, I.INVOICE_DATE) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_year#'> )
                        </cfif>
                       
                    GROUP BY
                        I.INVOICE_CAT,
                        IR.NETTOTAL,
                        IR.INVOICE_ROW_ID
                ) T1
            GROUP BY
                ACTION_TYPE
        </cfquery>

        <cfreturn query_ilave_edilecek_kdv>
    </cffunction>

    <cffunction name="get_sabit_kiymet_satisi" access="public" returntype="query">
        <cfargument name="is_account" type="numeric" default="1">
        <cfargument name="sal_mon" type="string" default="">
        <cfargument name="sal_year" type="string" default="">
        

        <cfquery name="query_sabit_kiymet_satisi" datasource="#dsn#">
            SELECT
                SUM(TAXTOTAL) TAXTOTAL,
                SUM(NETTOTAL) NETTOTAL,
                ACTION_TYPE,
                COUNT(INVOICE_ROW_ID) AS ROW_CNT
                FROM
                (
                    SELECT
                        CASE WHEN(IR.NETTOTAL = 0) THEN
                            SUM(IR.TAXTOTAL)
                        ELSE
                            SUM(((1- I.SA_DISCOUNT/#dsn#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL )*TAX/100 - (((1- I.SA_DISCOUNT/#dsn#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL )*TAX/100*ISNULL(1-(I.TEVKIFAT_ORAN),0))) 
                        END AS TAXTOTAL,
                        CASE WHEN(IR.NETTOTAL = 0) THEN
                            SUM(IR.NETTOTAL)
                        ELSE
                            SUM(((1- I.SA_DISCOUNT/#dsn#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) 
                        END AS NETTOTAL,
                        I.INVOICE_CAT AS ACTION_TYPE,
                        IR.INVOICE_ROW_ID
                    FROM
                        #dsn2#.INVOICE I
                        INNER JOIN #dsn2#.INVOICE_ROW IR ON I.INVOICE_ID = IR.INVOICE_ID
                    WHERE
                        I.INVOICE_CAT IN (66) AND 
                        IR.TAX IS NOT NULL AND
                        IR.NETTOTAL IS NOT NULL AND
                        I.IS_IPTAL = 0
                        <cfif len(arguments.is_account)>
                        AND (
                            I.INVOICE_ID IN(SELECT AC.ACTION_ID FROM #dsn2#.ACCOUNT_CARD AC WHERE I.INVOICE_ID =AC.ACTION_ID AND I.INVOICE_CAT = AC.ACTION_TYPE)
                            OR
                            I.INVOICE_ID IN(SELECT AC.ACTION_ID FROM #dsn2#.ACCOUNT_CARD_SAVE AC WHERE I.INVOICE_ID = AC.ACTION_ID AND I.INVOICE_CAT = AC.ACTION_TYPE)
                        )
                        </cfif>
                        <cfif len(arguments.sal_mon)>
                        AND ( DATEPART(MONTH, I.INVOICE_DATE) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_mon#'> )
                        </cfif>
                        <cfif len(arguments.sal_year)>
                        AND ( DATEPART(YEAR, I.INVOICE_DATE) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_year#'> )
                        </cfif>
                       
                    GROUP BY
                        I.INVOICE_CAT,
                        IR.NETTOTAL,
                        IR.INVOICE_ROW_ID
                ) T1
            GROUP BY
                ACTION_TYPE
        </cfquery>

        <cfreturn query_sabit_kiymet_satisi>
    </cffunction>

    <cffunction name="get_bavul_ticareti" access="public" returntype="query">
        <cfargument name="is_account" type="numeric" default="1">
        <cfargument name="sal_mon" type="string" default="">
        <cfargument name="sal_year" type="string" default="">
        <cfargument name="to_mon" type="string" default="">
        

        <cfquery name="query_bavul_ticareti" datasource="#dsn#">
            SELECT
                SUM(TAXTOTAL) TAXTOTAL,
                SUM(NETTOTAL) NETTOTAL,
                ACTION_TYPE,
                COUNT(INVOICE_ROW_ID) AS ROW_CNT
                FROM
                (
                    SELECT
                        CASE WHEN(IR.NETTOTAL = 0) THEN
                            SUM(IR.TAXTOTAL)
                        ELSE
                            SUM(((1- I.SA_DISCOUNT/#dsn#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL )*TAX/100 - (((1- I.SA_DISCOUNT/#dsn#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL )*TAX/100*ISNULL(1-(I.TEVKIFAT_ORAN),0))) 
                        END AS TAXTOTAL,
                        CASE WHEN(IR.NETTOTAL = 0) THEN
                            SUM(IR.NETTOTAL)
                        ELSE
                            SUM(((1- I.SA_DISCOUNT/#dsn#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) 
                        END AS NETTOTAL,
                        I.INVOICE_CAT AS ACTION_TYPE,
                        IR.INVOICE_ROW_ID
                    FROM
                        #dsn2#.INVOICE I
                        INNER JOIN #dsn2#.INVOICE_ROW IR ON I.INVOICE_ID = IR.INVOICE_ID
                    WHERE
                        I.INVOICE_CAT IN (5312) AND 
                        IR.TAX IS NOT NULL AND
                        IR.NETTOTAL IS NOT NULL AND
                        I.IS_IPTAL = 0
                        <cfif len(arguments.is_account)>
                        AND (
                            I.INVOICE_ID IN(SELECT AC.ACTION_ID FROM #dsn2#.ACCOUNT_CARD AC WHERE I.INVOICE_ID =AC.ACTION_ID AND I.INVOICE_CAT = AC.ACTION_TYPE)
                            OR
                            I.INVOICE_ID IN(SELECT AC.ACTION_ID FROM #dsn2#.ACCOUNT_CARD_SAVE AC WHERE I.INVOICE_ID = AC.ACTION_ID AND I.INVOICE_CAT = AC.ACTION_TYPE)
                        )
                        </cfif>
                        <cfif len(arguments.sal_mon)>
                        AND ( DATEPART(MONTH, I.INVOICE_DATE) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_mon#'> )
                        </cfif>
                        <cfif len(arguments.to_mon)>
                        AND ( DATEPART(MONTH, I.INVOICE_DATE) <= <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.to_mon#'> )
                        </cfif>
                        <cfif len(arguments.sal_year)>
                        AND ( DATEPART(YEAR, I.INVOICE_DATE) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_year#'> )
                        </cfif>
                       
                    GROUP BY
                        I.INVOICE_CAT,
                        IR.NETTOTAL,
                        IR.INVOICE_ROW_ID
                ) T1
            GROUP BY
                ACTION_TYPE
        </cfquery>

        <cfreturn query_bavul_ticareti>
    </cffunction>

    <cffunction name="get_indirilecek_islemler" access="public" returntype="query">
        <cfargument name="is_account" type="numeric" default="1">
        <cfargument name="sal_mon" type="string" default="">
        <cfargument name="sal_year" type="string" default="">
        <cfargument name="codes" type="string" default="">
        <cfargument name="is_taxtotal" type="string" default="">
        <cfquery name="query_indirilecek_islemler" datasource="#dsn#">
            SELECT
                TAX,
                SUM(TAXTOTAL) TAXTOTAL,
                SUM(NETTOTAL) NETTOTAL,
                ACTION_TYPE,
                COUNT(INVOICE_ROW_ID) AS ROW_CNT
                FROM
                (
                    SELECT
                        IR.TAX,
                        CASE WHEN(IR.NETTOTAL = 0) THEN
                            SUM(IR.TAXTOTAL*(ISNULL(I.TEVKIFAT_ORAN,0)))
                        ELSE
                            SUM(((1- I.SA_DISCOUNT/#dsn#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL )*TAX/100 - (((1- I.SA_DISCOUNT/#dsn#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL )*TAX/100*ISNULL(1-(I.TEVKIFAT_ORAN),0))*(ISNULL(I.TEVKIFAT_ORAN,0))) 
                        END AS TAXTOTAL,
                        CASE WHEN(IR.NETTOTAL = 0) THEN
                            SUM(IR.NETTOTAL)
                        ELSE
                            SUM(((1- I.SA_DISCOUNT/#dsn#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) 
                        END AS NETTOTAL,
                        I.INVOICE_CAT AS ACTION_TYPE,
                        IR.INVOICE_ROW_ID
                    FROM
                        #dsn2#.INVOICE I
                        INNER JOIN #dsn2#.INVOICE_ROW IR ON I.INVOICE_ID = IR.INVOICE_ID
                    WHERE
                    <!--- 51,59,60,63,64,120,122,296,592,601,1201,1202,1203 --->
                        I.INVOICE_CAT IN (#arguments.codes#) AND 
                        IR.TAX IS NOT NULL AND
                        IR.NETTOTAL IS NOT NULL AND
                        I.IS_IPTAL = 0
                        <cfif len(arguments.is_account)>
                        AND (
                            I.INVOICE_ID IN(SELECT AC.ACTION_ID FROM #dsn2#.ACCOUNT_CARD AC WHERE I.INVOICE_ID =AC.ACTION_ID AND I.INVOICE_CAT = AC.ACTION_TYPE)
                            OR
                            I.INVOICE_ID IN(SELECT AC.ACTION_ID FROM #dsn2#.ACCOUNT_CARD_SAVE AC WHERE I.INVOICE_ID = AC.ACTION_ID AND I.INVOICE_CAT = AC.ACTION_TYPE)
                        )
                        </cfif>
                        <cfif len(arguments.sal_mon)>
                        AND ( DATEPART(MONTH, I.INVOICE_DATE) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_mon#'> )
                        </cfif>
                        <cfif len(arguments.sal_year)>
                        AND ( DATEPART(YEAR, I.INVOICE_DATE) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_year#'> )
                        </cfif>
                       
                    GROUP BY
                        IR.TAX,
                        I.INVOICE_CAT,
                        IR.NETTOTAL,
                        IR.INVOICE_ROW_ID

                    UNION ALL
                    SELECT
                        ER.KDV_RATE,
                        <cfif len(arguments.is_taxtotal)>
                            SUM(ER.AMOUNT_KDV),
                        <cfelse>
                            CASE WHEN (ER.TOTAL_AMOUNT = 0) THEN
                                SUM(ER.AMOUNT_KDV*(1-ISNULL(E.TEVKIFAT_ORAN,0)))
                            ELSE
                                SUM((ER.AMOUNT_KDV - ISNULL(ER.AMOUNT_TEVKIFAT, 0))*(1-ISNULL(E.TEVKIFAT_ORAN,0)))
                            END AS TAXTOTAL,
                        </cfif>
                        SUM(ER.TOTAL_AMOUNT) AS NETTOTAL,
                        E.ACTION_TYPE,
                        ER.EXP_ITEM_ROWS_ID
                    FROM #dsn2#.EXPENSE_ITEM_PLANS E
                        INNER JOIN #dsn2#.EXPENSE_ITEMS_ROWS ER ON E.EXPENSE_ID = ER.EXPENSE_ID
                    WHERE
                        E.ACTION_TYPE IN (#arguments.codes#) AND
                        ER.KDV_RATE IS NOT NULL AND
                        ER.TOTAL_AMOUNT IS NOT NULL AND
                        E.IS_IPTAL = 0
                        <cfif len(arguments.is_account)>
                        AND (
                            E.EXPENSE_ID IN (SELECT AC.ACTION_ID FROM #dsn2#.ACCOUNT_CARD AC WHERE E.EXPENSE_ID = AC.ACTION_ID AND E.ACTION_TYPE = AC.ACTION_TYPE)
                        )
                        </cfif>
                        <cfif len(arguments.sal_mon)>
                        AND ( DATEPART(MONTH, E.EXPENSE_DATE) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_mon#'> )
                        </cfif>
                        <cfif len(arguments.sal_year)>
                        AND ( DATEPART(YEAR, E.EXPENSE_DATE) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_year#'> )
                        </cfif>
                    GROUP BY
                        ER.KDV_RATE,
                        E.ACTION_TYPE,
                        ER.TOTAL_AMOUNT,
                        ER.EXP_ITEM_ROWS_ID
                ) T1
            GROUP BY
                TAX,
                ACTION_TYPE
        </cfquery>
        
        <cfreturn query_indirilecek_islemler>
    </cffunction>

    <cffunction name="get_satistan_iadeler" access="public" returntype="query">
        <cfargument name="is_account" type="numeric" default="1">
        <cfargument name="sal_mon" type="string" default="">
        <cfargument name="sal_year" type="string" default="">
        

        <cfquery name="query_satistan_iadeler" datasource="#dsn#">
            SELECT
                SUM(TAXTOTAL) TAXTOTAL,
                SUM(NETTOTAL) NETTOTAL,
                ACTION_TYPE,
                COUNT(INVOICE_ROW_ID) AS ROW_CNT
                FROM
                (
                    SELECT
                        CASE WHEN(IR.NETTOTAL = 0) THEN
                            SUM(IR.TAXTOTAL)
                        ELSE
                            SUM(((1- I.SA_DISCOUNT/#dsn#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL )*TAX/100 - (((1- I.SA_DISCOUNT/#dsn#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL )*TAX/100*ISNULL(1-(I.TEVKIFAT_ORAN),0))) 
                        END AS TAXTOTAL,
                        CASE WHEN(IR.NETTOTAL = 0) THEN
                            SUM(IR.NETTOTAL)
                        ELSE
                            SUM(((1- I.SA_DISCOUNT/#dsn#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) 
                        END AS NETTOTAL,
                        I.INVOICE_CAT AS ACTION_TYPE,
                        IR.INVOICE_ROW_ID
                    FROM
                        #dsn2#.INVOICE I
                        INNER JOIN #dsn2#.INVOICE_ROW IR ON I.INVOICE_ID = IR.INVOICE_ID
                    WHERE
                        I.INVOICE_CAT IN (54,55,591,690,691) AND 
                        IR.TAX IS NOT NULL AND
                        IR.NETTOTAL IS NOT NULL AND
                        I.IS_IPTAL = 0
                        <cfif len(arguments.is_account)>
                        AND (
                            I.INVOICE_ID IN(SELECT AC.ACTION_ID FROM #dsn2#.ACCOUNT_CARD AC WHERE I.INVOICE_ID =AC.ACTION_ID AND I.INVOICE_CAT = AC.ACTION_TYPE)
                            OR
                            I.INVOICE_ID IN(SELECT AC.ACTION_ID FROM #dsn2#.ACCOUNT_CARD_SAVE AC WHERE I.INVOICE_ID = AC.ACTION_ID AND I.INVOICE_CAT = AC.ACTION_TYPE)
                        )
                        </cfif>
                        <cfif len(arguments.sal_mon)>
                        AND ( DATEPART(MONTH, I.INVOICE_DATE) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_mon#'> )
                        </cfif>
                        <cfif len(arguments.sal_year)>
                        AND ( DATEPART(YEAR, I.INVOICE_DATE) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_year#'> )
                        </cfif>
                       
                    GROUP BY
                        I.INVOICE_CAT,
                        IR.NETTOTAL,
                        IR.INVOICE_ROW_ID
                ) T1
            GROUP BY
                ACTION_TYPE
        </cfquery>

        <cfreturn query_satistan_iadeler>
    </cffunction>

    <cffunction name="get_ihracat_kayitli_islemler" access="public" returntype="query">
        <cfargument name="is_account" type="numeric" default="1">
        <cfargument name="sal_mon" type="string" default="">
        <cfargument name="sal_year" type="string" default="">
        
 
        <cfquery name="query_ihracat_kayitli_islemler" datasource="#dsn#">
            SELECT
                TAX,
                SUM(TAXTOTAL) TAXTOTAL,
                SUM(NETTOTAL) NETTOTAL,
                ISLEMTURU
                FROM
                (
                    SELECT
                        IR.TAX,
                        CASE WHEN(IR.NETTOTAL = 0) THEN
                            SUM(IR.TAXTOTAL)
                        ELSE
                            SUM(((1- I.SA_DISCOUNT/#dsn#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL )*TAX/100 - (((1- I.SA_DISCOUNT/#dsn#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL )*TAX/100*ISNULL(1-(I.TEVKIFAT_ORAN),0))) 
                        END AS TAXTOTAL,
                        CASE WHEN(IR.NETTOTAL = 0) THEN
                            SUM(IR.NETTOTAL)
                        ELSE
                            SUM(((1- I.SA_DISCOUNT/#dsn#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) 
                        END AS NETTOTAL,
                        I.INVOICE_CAT AS ACTION_TYPE,
                        CASE
                            WHEN I.IS_EXPORT_REGISTRATION = 1 THEN '#getlang("","Dahilde İşlem",44261)#'
                            WHEN I.IS_EXPORT_PRODUCT = 1 THEN '#getlang("","Nihai Ürün",886)#'
                        END AS ISLEMTURU
                    FROM
                        #dsn2#.INVOICE I
                        INNER JOIN #dsn2#.INVOICE_ROW IR ON I.INVOICE_ID = IR.INVOICE_ID
                    WHERE
                        I.INVOICE_CAT IN (5311) AND 
                        IR.TAX IS NOT NULL AND
                        IR.NETTOTAL IS NOT NULL AND
                        I.IS_IPTAL = 0 AND
                        (I.IS_EXPORT_REGISTRATION = 1 OR I.IS_EXPORT_PRODUCT = 1)
                        <cfif len(arguments.is_account)>
                        AND (
                            I.INVOICE_ID IN(SELECT AC.ACTION_ID FROM #dsn2#.ACCOUNT_CARD AC WHERE I.INVOICE_ID =AC.ACTION_ID AND I.INVOICE_CAT = AC.ACTION_TYPE)
                            OR
                            I.INVOICE_ID IN(SELECT AC.ACTION_ID FROM #dsn2#.ACCOUNT_CARD_SAVE AC WHERE I.INVOICE_ID = AC.ACTION_ID AND I.INVOICE_CAT = AC.ACTION_TYPE)
                        )
                        </cfif>
                        <cfif len(arguments.sal_mon)>
                        AND ( DATEPART(MONTH, I.INVOICE_DATE) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_mon#'> )
                        </cfif>
                        <cfif len(arguments.sal_year)>
                        AND ( DATEPART(YEAR, I.INVOICE_DATE) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_year#'> )
                        </cfif>
                       
                    GROUP BY
                        IR.TAX,
                        I.INVOICE_CAT,
                        IR.NETTOTAL,
                        I.IS_EXPORT_REGISTRATION,
                        I.IS_EXPORT_PRODUCT
                ) T1
            GROUP BY
                TAX,
                ISLEMTURU
        </cfquery>

        <cfreturn query_ihracat_kayitli_islemler>
    </cffunction>

    <cffunction name="get_ihracat_faturalari" access="public" returntype="query">
        <cfargument name="is_account" type="numeric" default="1">
        <cfargument name="sal_mon" type="string" default="">
        <cfargument name="sal_year" type="string" default="">
        

        <cfquery name="query_ihracat_faturalari" datasource="#dsn#">
            SELECT
                SUM(NETTOTAL) NETTOTAL,
                ACTION_TYPE,
                COUNT(INVOICE_ROW_ID) AS ROW_CNT
                FROM
                (
                    SELECT
                        CASE WHEN(IR.NETTOTAL = 0) THEN
                            SUM(IR.NETTOTAL)
                        ELSE
                            SUM(((1- I.SA_DISCOUNT/#dsn#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) 
                        END AS NETTOTAL,
                        I.INVOICE_CAT AS ACTION_TYPE,
                        IR.INVOICE_ROW_ID
                    FROM
                        #dsn2#.INVOICE I
                        INNER JOIN #dsn2#.INVOICE_ROW IR ON I.INVOICE_ID = IR.INVOICE_ID
                    WHERE
                        I.INVOICE_CAT IN (531) AND 
                        IR.NETTOTAL IS NOT NULL AND
                        I.IS_IPTAL = 0
                        <cfif len(arguments.is_account)>
                        AND (
                            I.INVOICE_ID IN(SELECT AC.ACTION_ID FROM #dsn2#.ACCOUNT_CARD AC WHERE I.INVOICE_ID =AC.ACTION_ID AND I.INVOICE_CAT = AC.ACTION_TYPE)
                            OR
                            I.INVOICE_ID IN(SELECT AC.ACTION_ID FROM #dsn2#.ACCOUNT_CARD_SAVE AC WHERE I.INVOICE_ID = AC.ACTION_ID AND I.INVOICE_CAT = AC.ACTION_TYPE)
                        )
                        </cfif>
                        <cfif len(arguments.sal_mon)>
                        AND ( DATEPART(MONTH, I.INVOICE_DATE) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_mon#'> )
                        </cfif>
                        <cfif len(arguments.sal_year)>
                        AND ( DATEPART(YEAR, I.INVOICE_DATE) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_year#'> )
                        </cfif>
                       
                    GROUP BY
                        I.INVOICE_CAT,
                        IR.NETTOTAL,
                        IR.INVOICE_ROW_ID
                ) T1
            GROUP BY
                ACTION_TYPE
        </cfquery>

        <cfreturn query_ihracat_faturalari>
    </cffunction>

    <cffunction name="get_our_company" access="public" returntype="query">
        <cfargument name="comp_id">

        <cfquery name="query_get_ourcompany" datasource="#dsn#">
            SELECT * FROM OUR_COMPANY WHERE COMP_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.comp_id#'>
        </cfquery>
        <cfreturn query_get_ourcompany>
    </cffunction>

    <cffunction name="get_muhasebe_indirilecek_kdv" access="public" returntype="query">
        <cfargument name="is_account" type="numeric" default="1">
        <cfargument name="sal_mon" type="string" default="">
        <cfargument name="sal_year" type="string" default="">

        <cfquery name="query_muhasebe_indirilecek_kdv" datasource="#dsn#">
            SELECT *, 
            CASE
                WHEN ISNULL(TAX, 0) > 0 THEN KDV * 100 / TAX
                ELSE 0
            END AS MATRAH
            FROM 
            (
            SELECT
                    SUM(AR.AMOUNT) AS KDV,
                    COUNT(AR.AMOUNT) AS MIKTAR,
                    AR.ACCOUNT_ID,
                    AP.ACCOUNT_NAME,
                    TX.TAX
                FROM
                    #dsn2#.ACCOUNT_CARD A
                    INNER JOIN #dsn2#.ACCOUNT_CARD_ROWS AR ON A.CARD_ID = AR.CARD_ID
                    INNER JOIN #dsn2#.ACCOUNT_PLAN AP ON AR.ACCOUNT_ID = AP.ACCOUNT_CODE
                    LEFT OUTER JOIN #dsn2#.SETUP_TAX TX ON AR.ACCOUNT_ID = TX.SALE_CODE_IADE
                WHERE
                    AR.ACCOUNT_ID LIKE '191.%'
                    AND A.ACTION_TYPE NOT IN (48,50,52,53,56,58,62,66,69,121,533,561,640,680)
                    <cfif len(arguments.sal_mon)>
                    AND ( DATEPART(MONTH, A.ACTION_DATE) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_mon#'> )
                    </cfif>
                    <cfif len(arguments.sal_year)>
                    AND ( DATEPART(YEAR, A.ACTION_DATE) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_year#'> )
                    </cfif>
                GROUP BY
                    AR.ACCOUNT_ID,
                    AP.ACCOUNT_NAME,
                    TX.TAX
            ) AS T
            ORDER BY ACCOUNT_ID
        </cfquery>
        <cfreturn query_muhasebe_indirilecek_kdv>
    </cffunction>

    <cffunction name="get_muhasebe_hesaplanan_kdv" access="public" returntype="query">
        <cfargument name="is_account" type="numeric" default="1">
        <cfargument name="sal_mon" type="string" default="">
        <cfargument name="sal_year" type="string" default="">

        <cfquery name="query_muhasebe_indirilecek_kdv" datasource="#dsn#">
            SELECT *, 
            CASE
                WHEN ISNULL(TAX, 0) > 0 THEN KDV * 100 / TAX
                ELSE 0
            END AS MATRAH
            FROM 
            (
             SELECT 
                SUM(R.KDV) AS KDV,
                COUNT(R.MIKTAR) AS MIKTAR,
                R.ACCOUNT_ID,
                R.ACCOUNT_NAME,
                R.TAX
            FROM
            (
                        SELECT
                            AR.AMOUNT AS KDV,
                            AR.AMOUNT AS MIKTAR,
                            AR.ACCOUNT_ID,
                            AP.ACCOUNT_NAME,
                            TX.TAX
                        FROM
                            #dsn2#.ACCOUNT_CARD A
                            INNER JOIN #dsn2#.ACCOUNT_CARD_ROWS AR ON A.CARD_ID = AR.CARD_ID
                            INNER JOIN #dsn2#.ACCOUNT_PLAN AP ON AR.ACCOUNT_ID = AP.ACCOUNT_CODE
                            LEFT OUTER JOIN #dsn2#.SETUP_TAX TX ON AR.ACCOUNT_ID = TX.PURCHASE_CODE_IADE
                        WHERE
                            AR.ACCOUNT_ID LIKE '391.%' 
                            AND A.IS_CANCEL=0
                            AND A.ACTION_TYPE NOT IN (51,54,55,59,60,63,64,120,122,296,531,591,592,601,690,691,1201,1202,1203,5311)
                            <cfif len(arguments.sal_mon)>
                            AND ( DATEPART(MONTH, A.ACTION_DATE) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_mon#'> )
                            </cfif>
                            <cfif len(arguments.sal_year)>
                            AND ( DATEPART(YEAR, A.ACTION_DATE) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_year#'> )
                            </cfif> 
                     UNION ALL
                        SELECT
                            AR.AMOUNT*-1 AS KDV,
                            AR.AMOUNT*-1 AS MIKTAR,
                            AR.ACCOUNT_ID,
                            AP.ACCOUNT_NAME,
                            TX.TAX
                        FROM
                            #dsn2#.ACCOUNT_CARD A
                            INNER JOIN #dsn2#.ACCOUNT_CARD_ROWS AR ON A.CARD_ID = AR.CARD_ID
                            INNER JOIN #dsn2#.ACCOUNT_PLAN AP ON AR.ACCOUNT_ID = AP.ACCOUNT_CODE
                            LEFT OUTER JOIN #dsn2#.SETUP_TAX TX ON AR.ACCOUNT_ID = TX.PURCHASE_CODE_IADE
                        WHERE
                            AR.ACCOUNT_ID LIKE '391.%' 
                            AND A.IS_CANCEL=1
                            AND A.ACTION_TYPE NOT IN (51,54,55,59,60,63,64,120,122,296,531,591,592,601,690,691,1201,1202,1203,5311)
                            <cfif len(arguments.sal_mon)>
                            AND ( DATEPART(MONTH, A.ACTION_DATE) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_mon#'> )
                            </cfif>
                            <cfif len(arguments.sal_year)>
                            AND ( DATEPART(YEAR, A.ACTION_DATE) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_year#'> )
                            </cfif>
            )
            AS R
            GROUP BY R.ACCOUNT_ID,
                R.ACCOUNT_NAME,
                R.TAX
            ) AS T
            ORDER BY ACCOUNT_ID
        </cfquery>
        <cfreturn query_muhasebe_indirilecek_kdv>
    </cffunction>

    <cffunction name="get_kdv_kesintisi_yapilan_saticilar" access="public" returntype="query">
        <cfargument name="sal_mon" type="string" default="">
        <cfargument name="sal_year" type="string" default="">

        <cfquery name="query_kdv_kesintisi_yapilan_saticilar" datasource="#dsn#">
            SELECT 
            FIRMA, TCKN, VERGINO, UNVAN1, UNVAN2, SUM(GROSSTOTAL) AS TOTAL, ISNULL(SUM(TEVKIFAT),0) AS TOTALTEVKIFAT, COUNT(INVOICE_ID) AS ADET
            FROM (
                SELECT
                I.INVOICE_ID,
                CASE
                    WHEN I.COMPANY_ID IS NOT NULL THEN CMP.FULLNAME
                    WHEN I.CONSUMER_ID IS NOT NULL THEN CONCAT(CNS.CONSUMER_NAME, ' ', CNS.CONSUMER_SURNAME)
                    WHEN I.EMPLOYEE_ID IS NOT NULL THEN CONCAT(EMP.EMPLOYEE_NAME, ' ', EMP.EMPLOYEE_SURNAME)
                END AS FIRMA
                ,CASE
                    WHEN I.COMPANY_ID IS NOT NULL AND CMP.IS_PERSON = 1 THEN CMP_P.TC_IDENTITY
                    WHEN I.CONSUMER_ID IS NOT NULL THEN CNS.TC_IDENTY_NO
                    WHEN I.EMPLOYEE_ID IS NOT NULL THEN EMP_IDEN.TC_IDENTY_NO
                END AS TCKN,
                CASE
                    WHEN I.COMPANY_ID IS NOT NULL AND CMP.IS_PERSON = 0 THEN CMP.TAXNO
                    WHEN I.CONSUMER_ID IS NOT NULL THEN NULL
                    WHEN I.EMPLOYEE_ID IS NOT NULL THEN NULL
                END AS VERGINO
                ,CASE 
                    WHEN I.COMPANY_ID IS NOT NULL AND LEN(CMP.FULLNAME) > 30 THEN SUBSTRING(CMP.FULLNAME, 1, 30)
                    WHEN I.COMPANY_ID IS NOT NULL AND LEN(CMP.FULLNAME) <= 30 THEN CMP.FULLNAME
                    WHEN I.CONSUMER_ID IS NOT NULL THEN CNS.CONSUMER_SURNAME
                    WHEN I.EMPLOYEE_ID IS NOT NULL THEN EMP.EMPLOYEE_SURNAME
                END AS UNVAN1
                ,CASE 
                    WHEN I.COMPANY_ID IS NOT NULL AND LEN(CMP.FULLNAME) > 30 THEN SUBSTRING(CMP.FULLNAME, 31, LEN(CMP.FULLNAME) - 30)
                    WHEN I.COMPANY_ID IS NOT NULL AND LEN(CMP.FULLNAME) <= 30 THEN ''
                    WHEN I.CONSUMER_ID IS NOT NULL THEN CNS.CONSUMER_NAME
                    WHEN I.EMPLOYEE_ID IS NOT NULL THEN EMP.EMPLOYEE_NAME
                END AS UNVAN2
                ,CASE WHEN(IR.NETTOTAL = 0) THEN
                    SUM(IR.NETTOTAL)
                ELSE
                    SUM(((1- I.SA_DISCOUNT/#dsn#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) 
                END AS GROSSTOTAL
               
                ,SUM((IR.TAXTOTAL) * CASE WHEN I.TEVKIFAT_ORAN = 0 then 1 else 1-I.TEVKIFAT_ORAN end) AS TEVKIFAT
                FROM
                    #dsn2#.INVOICE I
                    INNER JOIN #dsn2#.INVOICE_ROW IR ON I.INVOICE_ID = IR.INVOICE_ID
                    LEFT OUTER JOIN #dsn#.COMPANY CMP ON I.COMPANY_ID = CMP.COMPANY_ID
                    LEFT OUTER JOIN #dsn#.COMPANY_PARTNER CMP_P ON I.COMPANY_ID = CMP_P.COMPANY_ID AND CMP_P.PARTNER_ID = CMP.MANAGER_PARTNER_ID
                    LEFT OUTER JOIN #dsn#.CONSUMER CNS ON I.CONSUMER_ID = CNS.CONSUMER_ID
                    LEFT OUTER JOIN #dsn#.EMPLOYEES EMP ON I.EMPLOYEE_ID = EMP.EMPLOYEE_ID
                    LEFT OUTER JOIN #dsn#.EMPLOYEES_IDENTY EMP_IDEN ON I.EMPLOYEE_ID = EMP_IDEN.EMPLOYEE_ID                    
                WHERE
                    I.INVOICE_CAT IN (49,51,55,59,60,61,63,64,65,68,120,122,1201,1202,1203,592,601,269,690,691)
                    AND (
                            I.INVOICE_ID IN(SELECT AC.ACTION_ID FROM #dsn2#.ACCOUNT_CARD AC WHERE I.INVOICE_ID =AC.ACTION_ID AND I.INVOICE_CAT = AC.ACTION_TYPE)
                            OR
                            I.INVOICE_ID IN(SELECT AC.ACTION_ID FROM #dsn2#.ACCOUNT_CARD_SAVE AC WHERE I.INVOICE_ID = AC.ACTION_ID AND I.INVOICE_CAT = AC.ACTION_TYPE)  
                        )
                    AND I.TEVKIFAT = 1
                    <cfif len(arguments.sal_mon)>
                    AND ( DATEPART(MONTH,ISNULL(I.PROCESS_DATE,I.INVOICE_DATE)) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_mon#'> )
                    </cfif>
                    <cfif len(arguments.sal_year)>
                    AND ( DATEPART(YEAR,ISNULL(I.PROCESS_DATE,I.INVOICE_DATE)) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_year#'> )
                    </cfif>
                GROUP BY I.INVOICE_ID, IR.NETTOTAL, I.COMPANY_ID, I.CONSUMER_ID, I.EMPLOYEE_ID, CMP.FULLNAME, CNS.CONSUMER_NAME, 
                CNS.CONSUMER_SURNAME, EMP.EMPLOYEE_NAME, EMP.EMPLOYEE_SURNAME, CMP.TAXNO, CNS.TC_IDENTY_NO, CMP.IS_PERSON, EMP_IDEN.TC_IDENTY_NO,CMP_P.TC_IDENTITY
            
                UNION ALL 
                
                SELECT
                    I.EXPENSE_ID AS INVOICE_ID,
                    CASE
                        WHEN I.CH_COMPANY_ID IS NOT NULL THEN CMP.FULLNAME
                        WHEN I.CH_CONSUMER_ID IS NOT NULL THEN CONCAT(CNS.CONSUMER_NAME, ' ', CNS.CONSUMER_SURNAME)
                        WHEN I.CH_EMPLOYEE_ID IS NOT NULL THEN CONCAT(EMP.EMPLOYEE_NAME, ' ', EMP.EMPLOYEE_SURNAME)
                    END AS FIRMA
                    ,CASE
                        WHEN I.CH_COMPANY_ID IS NOT NULL AND CMP.IS_PERSON = 1 THEN CMP_P.TC_IDENTITY
                        WHEN I.CH_CONSUMER_ID IS NOT NULL THEN CNS.TC_IDENTY_NO
                        WHEN I.CH_EMPLOYEE_ID IS NOT NULL THEN EMP_IDEN.TC_IDENTY_NO
                    END AS TCKN,
                    CASE
                        WHEN I.CH_COMPANY_ID IS NOT NULL AND CMP.IS_PERSON = 0 THEN CMP.TAXNO
                        WHEN I.CH_CONSUMER_ID IS NOT NULL THEN NULL
                        WHEN I.CH_EMPLOYEE_ID IS NOT NULL THEN NULL
                    END AS VERGINO
                    ,CASE 
                        WHEN I.CH_COMPANY_ID IS NOT NULL AND LEN(CMP.FULLNAME) > 30 THEN SUBSTRING(CMP.FULLNAME, 1, 30)
                        WHEN I.CH_COMPANY_ID IS NOT NULL AND LEN(CMP.FULLNAME) <= 30 THEN CMP.FULLNAME
                        WHEN I.CH_CONSUMER_ID IS NOT NULL THEN CNS.CONSUMER_SURNAME
                        WHEN I.CH_EMPLOYEE_ID IS NOT NULL THEN EMP.EMPLOYEE_SURNAME
                    END AS UNVAN1
                    ,CASE 
                        WHEN I.CH_COMPANY_ID IS NOT NULL AND LEN(CMP.FULLNAME) > 30 THEN SUBSTRING(CMP.FULLNAME, 31, LEN(CMP.FULLNAME) - 30)
                        WHEN I.CH_COMPANY_ID IS NOT NULL AND LEN(CMP.FULLNAME) <= 30 THEN ''
                        WHEN I.CH_CONSUMER_ID IS NOT NULL THEN CNS.CONSUMER_NAME
                        WHEN I.CH_EMPLOYEE_ID IS NOT NULL THEN EMP.EMPLOYEE_NAME
                    END AS UNVAN2
                    ,SUM(ER.AMOUNT * ER.QUANTITY) as GROSSTOTAL
                    ,SUM((ER.AMOUNT_KDV) * CASE WHEN I.TEVKIFAT_ORAN = 0 then 1 else 1-I.TEVKIFAT_ORAN END) AS TEVKIFAT
                    FROM
                        #dsn2#.EXPENSE_ITEM_PLANS I
                        INNER JOIN #dsn2#.EXPENSE_ITEMS_ROWS ER ON I.EXPENSE_ID = ER.EXPENSE_ID
                        LEFT OUTER JOIN #dsn#.COMPANY CMP ON I.CH_COMPANY_ID = CMP.COMPANY_ID
                        LEFT OUTER JOIN #dsn#.COMPANY_PARTNER CMP_P ON I.CH_COMPANY_ID = CMP_P.COMPANY_ID AND CMP_P.PARTNER_ID = CMP.MANAGER_PARTNER_ID
                        LEFT OUTER JOIN #dsn#.CONSUMER CNS ON I.CH_CONSUMER_ID = CNS.CONSUMER_ID
                        LEFT OUTER JOIN #dsn#.EMPLOYEES EMP ON I.CH_EMPLOYEE_ID = EMP.EMPLOYEE_ID
                        LEFT OUTER JOIN #dsn#.EMPLOYEES_IDENTY EMP_IDEN ON I.CH_EMPLOYEE_ID = EMP_IDEN.EMPLOYEE_ID                    
                    WHERE
                    (
                            I.EXPENSE_ID IN(SELECT AC.ACTION_ID FROM #dsn2#.ACCOUNT_CARD AC WHERE I.EXPENSE_ID =AC.ACTION_ID AND I.ACTION_TYPE = AC.ACTION_TYPE)
                            OR
                            I.EXPENSE_ID IN(SELECT AC.ACTION_ID FROM #dsn2#.ACCOUNT_CARD_SAVE AC WHERE I.EXPENSE_ID = AC.ACTION_ID AND I.ACTION_TYPE = AC.ACTION_TYPE)  
                        )
                        AND I.TEVKIFAT = 1
                        <cfif len(arguments.sal_mon)>
                        AND ( DATEPART(MONTH,ISNULL(I.PROCESS_DATE,I.EXPENSE_DATE)) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_mon#'> )
                        </cfif>
                        <cfif len(arguments.sal_year)>
                        AND ( DATEPART(YEAR,ISNULL(I.PROCESS_DATE,I.EXPENSE_DATE)) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_year#'> )
                        </cfif>
                    GROUP BY I.EXPENSE_ID, I.CH_COMPANY_ID, I.CH_CONSUMER_ID, I.CH_EMPLOYEE_ID, CMP.FULLNAME, CNS.CONSUMER_NAME, 
                    CNS.CONSUMER_SURNAME, EMP.EMPLOYEE_NAME, EMP.EMPLOYEE_SURNAME, CMP.TAXNO, CNS.TC_IDENTY_NO, CMP.IS_PERSON, EMP_IDEN.TC_IDENTY_NO,CMP_P.TC_IDENTITY
                ) T
            GROUP BY FIRMA, TCKN, VERGINO, UNVAN1, UNVAN2
        </cfquery>
        <cfreturn query_kdv_kesintisi_yapilan_saticilar>
    </cffunction>

    <cffunction name="get_tevkifatli_alislar" access="public" returntype="query">
        <cfargument name="is_tamtevkifat" type="numeric" default="1">
        <cfargument name="sal_mon" type="string" default="">
        <cfargument name="sal_year" type="string" default="">
        <cfargument name="to_mon" type="string" default="">

        <cfquery name="query_tevkifatli_alislar" datasource="#dsn#">
            SELECT
                TAX,
                TEVKIFAT_CODE,
                TEVKIFAT_CODE_NAME,
                TEVKIFAT_ORAN,
                SUM(TAXTOTAL) TAXTOTAL,
                SUM(NETTOTAL) NETTOTAL
                FROM
                (
                    SELECT
                        IR.TAX,
                        CASE WHEN(IR.NETTOTAL = 0) THEN
                            SUM(IR.TAXTOTAL)
                        ELSE
                            SUM((((1- I.SA_DISCOUNT/#dsn#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL )*TAX/100*ISNULL(1-(I.TEVKIFAT_ORAN),0)))
                        END AS TAXTOTAL,
                        CASE WHEN(IR.NETTOTAL = 0) THEN
                            SUM(IR.NETTOTAL)
                        ELSE
                            SUM(((1- I.SA_DISCOUNT/#dsn#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) 
                        END AS NETTOTAL,
                        I.INVOICE_CAT AS ACTION_TYPE,
                        IR.INVOICE_ROW_ID,
                        ST.TEVKIFAT_CODE,
                        ST.TEVKIFAT_CODE_NAME,
                        I.TEVKIFAT_ORAN
                    FROM
                        #dsn2#.INVOICE I
                        INNER JOIN #dsn2#.INVOICE_ROW IR ON I.INVOICE_ID = IR.INVOICE_ID
                        INNER JOIN #dsn3#.SETUP_TEVKIFAT ST ON I.TEVKIFAT_ID = ST.TEVKIFAT_ID
                    WHERE
                        I.INVOICE_CAT IN (49,51,55,59,60,61,63,64,65,68,120,122,1201,1202,1203,592,601,269,690,691) AND 
                        IR.TAX > 0 AND
                        IR.NETTOTAL IS NOT NULL AND
                        I.IS_IPTAL = 0 AND
                        (
                            I.TEVKIFAT_ORAN IS NOT NULL 
                           
                            AND 
                            <cfif arguments.is_tamtevkifat eq 1>
                            I.TEVKIFAT_ORAN = 0
                            <cfelse>
                            I.TEVKIFAT_ORAN >= 0
                            </cfif>
                        )
                        AND (
                            I.INVOICE_ID IN(SELECT AC.ACTION_ID FROM #dsn2#.ACCOUNT_CARD AC WHERE I.INVOICE_ID =AC.ACTION_ID AND I.INVOICE_CAT = AC.ACTION_TYPE)
                            OR
                            I.INVOICE_ID IN(SELECT AC.ACTION_ID FROM #dsn2#.ACCOUNT_CARD_SAVE AC WHERE I.INVOICE_ID = AC.ACTION_ID AND I.INVOICE_CAT = AC.ACTION_TYPE)  
                        )
                        <cfif len(arguments.sal_mon)>
                        AND ( DATEPART(MONTH, ISNULL(I.PROCESS_DATE,I.INVOICE_DATE)) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_mon#'> )
                        </cfif>
                        <cfif len(arguments.to_mon)>
                        AND ( DATEPART(MONTH, ISNULL(I.PROCESS_DATE,I.INVOICE_DATE)) <= <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.to_mon#'> )
                        </cfif>
                        <cfif len(arguments.sal_year)>
                        AND ( DATEPART(YEAR, ISNULL(I.PROCESS_DATE,I.INVOICE_DATE)) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_year#'> )
                        </cfif>
                       
                    GROUP BY
                        IR.TAX,
                        I.INVOICE_CAT,
                        IR.NETTOTAL,
                        IR.INVOICE_ROW_ID,
                        ST.TEVKIFAT_CODE,
                        ST.TEVKIFAT_CODE_NAME,
                        I.TEVKIFAT_ORAN

                UNION ALL 
                SELECT
                    ER.KDV_RATE,
                    CASE WHEN(ER.AMOUNT = 0) THEN
                        SUM(ER.AMOUNT_KDV)
                    ELSE
                        SUM(AMOUNT_KDV*(1-ISNULL(E.TEVKIFAT_ORAN,0)))
                    END AS TAXTOTAL,
                    SUM(ER.AMOUNT) as NETTOTAL,
                    E.ACTION_TYPE AS ACTION_TYPE,
                    ER.EXP_ITEM_ROWS_ID,
                    ST.TEVKIFAT_CODE,
                    ST.TEVKIFAT_CODE_NAME,
                    E.TEVKIFAT_ORAN					
                FROM #dsn2#.EXPENSE_ITEM_PLANS E
                    INNER JOIN #dsn2#.EXPENSE_ITEMS_ROWS ER ON E.EXPENSE_ID = ER.EXPENSE_ID
                    INNER JOIN #dsn3#.SETUP_TEVKIFAT ST ON E.TEVKIFAT_ID = ST.TEVKIFAT_ID
                WHERE 
                    ER.KDV_RATE > 0 AND
                    ER.TOTAL_AMOUNT IS NOT NULL AND
                    E.IS_IPTAL = 0 AND
                    (
                        E.TEVKIFAT_ORAN IS NOT NULL 
                        
                        AND 
                        <cfif arguments.is_tamtevkifat eq 1>
                        E.TEVKIFAT_ORAN = 0
                        <cfelse>
                        E.TEVKIFAT_ORAN >= 0
                        </cfif>
                    )
                    AND (
                        E.EXPENSE_ID IN(SELECT AC.ACTION_ID FROM #dsn2#.ACCOUNT_CARD AC WHERE E.EXPENSE_ID =AC.ACTION_ID AND  E.ACTION_TYPE = AC.ACTION_TYPE)
                        OR
                        E.EXPENSE_ID IN(SELECT AC.ACTION_ID FROM #dsn2#.ACCOUNT_CARD_SAVE AC WHERE E.EXPENSE_ID = AC.ACTION_ID AND  E.ACTION_TYPE = AC.ACTION_TYPE)
                    )
                    <cfif len(arguments.sal_mon)>
                    AND ( DATEPART(MONTH, ISNULL(E.PROCESS_DATE,E.EXPENSE_DATE)) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_mon#'> )
                    </cfif>
                    <cfif len(arguments.to_mon)>
                    AND ( DATEPART(MONTH, ISNULL(E.PROCESS_DATE,E.EXPENSE_DATE)) <= <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.to_mon#'> )
                    </cfif>
                    <cfif len(arguments.sal_year)>
                    AND ( DATEPART(YEAR, ISNULL(E.PROCESS_DATE,E.EXPENSE_DATE)) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_year#'> )
                    </cfif>
                       

                GROUP BY
                    ER.AMOUNT,
                    ER.KDV_RATE,
                    E.ACTION_TYPE,
                    ER.EXP_ITEM_ROWS_ID,
                    ST.TEVKIFAT_CODE,
                    ST.TEVKIFAT_CODE_NAME,
                    E.TEVKIFAT_ORAN
                    
                ) T1
            GROUP BY
                TAX,
                TEVKIFAT_ORAN,
                TEVKIFAT_CODE,
                TEVKIFAT_CODE_NAME
        </cfquery>

        <cfreturn query_tevkifatli_alislar>
    </cffunction>

</cfcomponent>