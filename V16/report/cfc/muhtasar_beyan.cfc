<!---
    File :          muhtasar_beyan.cfc
    Author :        Halit Yurttaş <halityurttas@gmail.com>
    Date :          10.02.2020
    Description :   Muhtasar Beyanamesi için veri katmanı
    Notes :         
--->
<cfcomponent>
    
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2 = dsn & '_product'>
    <cfset dsn2 = dsn & '_' & session.ep.PERIOD_YEAR & '_' & session.ep.COMPANY_ID>
    <cfset dsn3 = dsn & '_' & session.ep.COMPANY_ID>

    <cffunction name="get_muhtasar_alis_gider" access="public">
        <cfargument name="sal_mon" type="string" default="">
        <cfargument name="sal_year" type="string" default="">

        <cfquery name="query_muhtasar_alis_gider" datasource="#dsn2#">
        SELECT
            SUM(STOPAJ) STOPAJ,
            SUM(NETTOTAL) NETTOTAL,
            ACTION_TYPE,
            TAX_CODE_NAME
            FROM
            (
                SELECT
                    I.STOPAJ,
                    CASE WHEN(IR.NETTOTAL = 0) THEN
                        SUM(IR.NETTOTAL)
                    ELSE
                        SUM(((1- I.SA_DISCOUNT/#dsn#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) 
                    END AS NETTOTAL,
                    SPC.PROCESS_CAT AS ACTION_TYPE,
                    SR.TAX_CODE_NAME
                FROM
                    INVOICE I
                    INNER JOIN INVOICE_ROW IR ON I.INVOICE_ID = IR.INVOICE_ID
                    INNER JOIN SETUP_STOPPAGE_RATES SR ON I.STOPAJ_RATE_ID = SR.STOPPAGE_RATE_ID
                    INNER JOIN #dsn3#.SETUP_PROCESS_CAT SPC ON I.INVOICE_CAT = SPC.PROCESS_CAT_ID
                WHERE
                    I.INVOICE_CAT IN (49,51,54,55,59,60,63,64,65,68,69,592,5313,601,690,691) AND 
                    IR.NETTOTAL IS NOT NULL AND
                    ISNULL(I.IS_IPTAL,0) = 0 AND
                    I.PURCHASE_SALES = 0 AND
                    (I.STOPAJ IS NOT NULL AND I.STOPAJ > 0) AND 
                    (
                        I.INVOICE_ID IN(SELECT AC.ACTION_ID FROM ACCOUNT_CARD AC WHERE I.INVOICE_ID =AC.ACTION_ID AND I.INVOICE_CAT = AC.ACTION_TYPE)
                    )
                    <cfif len(arguments.sal_mon)>
                    AND ( DATEPART(MONTH, I.INVOICE_DATE) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_mon#'> )
                    </cfif>
                    <cfif len(arguments.sal_year)>
                    AND ( DATEPART(YEAR, I.INVOICE_DATE) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_year#'> )
                    </cfif>
                GROUP BY
                    SPC.PROCESS_CAT,
                    IR.NETTOTAL,
                    SR.TAX_CODE_NAME,
                    I.STOPAJ
                UNION ALL
                SELECT
                    E.STOPAJ,
                    SUM(ER.TOTAL_AMOUNT) AS NETTOTAL,
                    SPC.PROCESS_CAT,
                    SR.TAX_CODE_NAME
                FROM EXPENSE_ITEM_PLANS E
                    INNER JOIN EXPENSE_ITEMS_ROWS ER ON E.EXPENSE_ID = ER.EXPENSE_ID
                    INNER JOIN SETUP_STOPPAGE_RATES SR ON E.STOPAJ_RATE_ID = SR.STOPPAGE_RATE_ID
                    INNER JOIN #dsn3#.SETUP_PROCESS_CAT SPC ON E.ACTION_TYPE = SPC.PROCESS_CAT_ID
                WHERE 
                    E.ACTION_TYPE IN (120,1201,1202,1203,122) AND
                    ER.KDV_RATE IS NOT NULL AND
                    ER.TOTAL_AMOUNT IS NOT NULL AND
                    ISNULL(E.IS_IPTAL,0) = 0 AND
                    (E.TEVKIFAT_ORAN IS NULL OR E.TEVKIFAT_ORAN = 0) AND
                    (
                        E.EXPENSE_ID IN (SELECT AC.ACTION_ID FROM ACCOUNT_CARD AC WHERE E.EXPENSE_ID = AC.ACTION_ID AND E.ACTION_TYPE = AC.ACTION_TYPE)
                    )
                    <cfif len(arguments.sal_mon)>
                    AND ( DATEPART(MONTH, E.EXPENSE_DATE) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_mon#'> )
                    </cfif>
                    <cfif len(arguments.sal_year)>
                    AND ( DATEPART(YEAR, E.EXPENSE_DATE) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_year#'> )
                    </cfif>
                GROUP BY
                    SPC.PROCESS_CAT,
                    ER.TOTAL_AMOUNT,
                    SR.TAX_CODE_NAME,
                    E.STOPAJ
            ) T1
        GROUP BY
            ACTION_TYPE,
            TAX_CODE_NAME
        </cfquery>
        <cfreturn query_muhtasar_alis_gider>
    </cffunction>

    <cffunction name="get_insurance" access="public">
        <cfargument name="puantaj_start">
        <cfargument name="puantaj_finish">

        <cfquery name="query_insurance" datasource="#dsn#">
            SELECT MIN_GROSS_PAYMENT_NORMAL FROM INSURANCE_PAYMENT 
    	    WHERE STARTDATE <= <cfqueryparam cfsqltype='CF_SQL_DATE' value='#arguments.puantaj_start#'> 
                AND FINISHDATE >= <cfqueryparam cfsqltype='CF_SQL_DATE' value='#arguments.puantaj_finish#'>
        </cfquery>

        <cfreturn query_insurance>
    </cffunction>

    <cffunction name="get_branches" access="public">
        <cfargument name="asgari_ucret">
        <cfargument name="asgari_ucret_net">
        <cfargument name="s_branch_id">
        <cfargument name="companyid">
        <cfargument name="yearid">
        <cfargument name="monthid">

        <cfquery name="query_branches" datasource="#dsn#">
            SELECT
                ISNULL((
                    SELECT
                        COUNT(E.EMPLOYEE_ID)
                    FROM 
                        EMPLOYEES E,
                        EMPLOYEES_DETAIL ED,
                        EMPLOYEES_PUANTAJ_ROWS EPR,
                        EMPLOYEES_IN_OUT EIO
                    WHERE
                        EIO.IN_OUT_ID = EPR.IN_OUT_ID AND
                        E.EMPLOYEE_ID = ED.EMPLOYEE_ID AND
                        EPR.EMPLOYEE_ID = E.EMPLOYEE_ID AND
                        EPR.PUANTAJ_ID = EP.PUANTAJ_ID AND
                        ISNULL(ED.SEX,1) = 0 AND
                        (
                            (EIO.GROSS_NET = 0 AND EPR.SALARY = <cfqueryparam cfsqltype='CF_SQL_FLOAT' value='#arguments.asgari_ucret#'>)
                        OR
                            (EIO.GROSS_NET = 1 AND EPR.SALARY = <cfqueryparam cfsqltype='CF_SQL_FLOAT' value='#arguments.asgari_ucret_net#'>)
                        )
                ),0) AS ASGARI_KADIN,
                ISNULL((
                    SELECT
                        COUNT(E.EMPLOYEE_ID)
                    FROM 
                        EMPLOYEES E,
                        EMPLOYEES_DETAIL ED,
                        EMPLOYEES_PUANTAJ_ROWS EPR,
                        EMPLOYEES_IN_OUT EIO
                    WHERE
                        EIO.IN_OUT_ID = EPR.IN_OUT_ID AND
                        E.EMPLOYEE_ID = ED.EMPLOYEE_ID AND
                        EPR.EMPLOYEE_ID = E.EMPLOYEE_ID AND
                        EPR.PUANTAJ_ID = EP.PUANTAJ_ID AND
                        ISNULL(ED.SEX,1) = 1 AND
                        (
                            (EIO.GROSS_NET = 0 AND EPR.SALARY = <cfqueryparam cfsqltype='CF_SQL_FLOAT' value='#arguments.asgari_ucret#'>)
                        OR
                            (EIO.GROSS_NET = 1 AND EPR.SALARY = <cfqueryparam cfsqltype='CF_SQL_FLOAT' value='#arguments.asgari_ucret_net#'>)
                        )
                ),0) AS ASGARI_ERKEK,
                ISNULL((
                    SELECT
                        COUNT(E.EMPLOYEE_ID)
                    FROM 
                        EMPLOYEES E,
                        EMPLOYEES_DETAIL ED,
                        EMPLOYEES_PUANTAJ_ROWS EPR,
                        EMPLOYEES_IN_OUT EIO
                    WHERE
                        EIO.IN_OUT_ID = EPR.IN_OUT_ID AND
                        E.EMPLOYEE_ID = ED.EMPLOYEE_ID AND
                        EPR.EMPLOYEE_ID = E.EMPLOYEE_ID AND
                        EPR.PUANTAJ_ID = EP.PUANTAJ_ID AND
                        ISNULL(EIO.DEFECTION_LEVEL,0) > 0 AND
                        (
                            (EIO.GROSS_NET = 0 AND EPR.SALARY = <cfqueryparam cfsqltype='CF_SQL_FLOAT' value='#arguments.asgari_ucret#'>)
                        OR
                            (EIO.GROSS_NET = 1 AND EPR.SALARY = <cfqueryparam cfsqltype='CF_SQL_FLOAT' value='#arguments.asgari_ucret_net#'>)
                        )
                ),0) AS ASGARI_ENGELLI,
                ISNULL((
                    SELECT
                        COUNT(E.EMPLOYEE_ID)
                    FROM 
                        EMPLOYEES E,
                        EMPLOYEES_DETAIL ED,
                        EMPLOYEES_PUANTAJ_ROWS EPR,
                        EMPLOYEES_IN_OUT EIO
                    WHERE
                        EIO.IN_OUT_ID = EPR.IN_OUT_ID AND
                        E.EMPLOYEE_ID = ED.EMPLOYEE_ID AND
                        EPR.EMPLOYEE_ID = E.EMPLOYEE_ID AND
                        EPR.PUANTAJ_ID = EP.PUANTAJ_ID AND
                        ISNULL(ED.SEX,1) = 0 AND
                        (
                            (EIO.GROSS_NET = 0 AND EPR.SALARY <> <cfqueryparam cfsqltype='CF_SQL_FLOAT' value='#arguments.asgari_ucret#'>)
                        OR
                            (EIO.GROSS_NET = 1 AND EPR.SALARY <> <cfqueryparam cfsqltype='CF_SQL_FLOAT' value='#arguments.asgari_ucret_net#'>)
                        )
                ),0) AS DIGER_KADIN,
                ISNULL((
                    SELECT
                        COUNT(E.EMPLOYEE_ID)
                    FROM 
                        EMPLOYEES E,
                        EMPLOYEES_DETAIL ED,
                        EMPLOYEES_PUANTAJ_ROWS EPR,
                        EMPLOYEES_IN_OUT EIO
                    WHERE
                        EIO.IN_OUT_ID = EPR.IN_OUT_ID AND
                        E.EMPLOYEE_ID = ED.EMPLOYEE_ID AND
                        EPR.EMPLOYEE_ID = E.EMPLOYEE_ID AND
                        EPR.PUANTAJ_ID = EP.PUANTAJ_ID AND
                        ISNULL(ED.SEX,1) = 1 AND
                        (
                            (EIO.GROSS_NET = 0 AND EPR.SALARY <> <cfqueryparam cfsqltype='CF_SQL_FLOAT' value='#arguments.asgari_ucret#'>)
                        OR
                            (EIO.GROSS_NET = 1 AND EPR.SALARY <> <cfqueryparam cfsqltype='CF_SQL_FLOAT' value='#arguments.asgari_ucret_net#'>)
                        )
                ),0) AS DIGER_ERKEK,
                ISNULL((
                    SELECT
                        COUNT(E.EMPLOYEE_ID)
                    FROM 
                        EMPLOYEES E,
                        EMPLOYEES_DETAIL ED,
                        EMPLOYEES_PUANTAJ_ROWS EPR,
                        EMPLOYEES_IN_OUT EIO
                    WHERE
                        EIO.IN_OUT_ID = EPR.IN_OUT_ID AND
                        E.EMPLOYEE_ID = ED.EMPLOYEE_ID AND
                        EPR.EMPLOYEE_ID = E.EMPLOYEE_ID AND
                        EPR.PUANTAJ_ID = EP.PUANTAJ_ID AND
                        ISNULL(EIO.DEFECTION_LEVEL,0) > 0 AND
                        (
                            (EIO.GROSS_NET = 0 AND EPR.SALARY <> <cfqueryparam cfsqltype='CF_SQL_FLOAT' value='#arguments.asgari_ucret#'>)
                        OR
                            (EIO.GROSS_NET = 1 AND EPR.SALARY <> <cfqueryparam cfsqltype='CF_SQL_FLOAT' value='#arguments.asgari_ucret_net#'>)
                        )
                ),0) AS DIGER_ENGELLI,
                ISNULL((
                    SELECT
                        COUNT(E.EMPLOYEE_ID)
                    FROM 
                        EMPLOYEES E,
                        EMPLOYEES_DETAIL ED,
                        EMPLOYEES_PUANTAJ_ROWS EPR,
                        EMPLOYEES_IN_OUT EIO
                    WHERE
                        EIO.IN_OUT_ID = EPR.IN_OUT_ID AND
                        E.EMPLOYEE_ID = ED.EMPLOYEE_ID AND
                        EPR.EMPLOYEE_ID = E.EMPLOYEE_ID AND
                        EPR.PUANTAJ_ID = EP.PUANTAJ_ID AND
                        ISNULL(ED.SEX,1) = 0 AND
                        (
                        ISNULL(EPR.KIDEM_AMOUNT,0) + ISNULL(EPR.IHBAR_AMOUNT,0) > 0
                        OR
                        (EPR.SSK_ISVEREN_HISSESI + EPR.SSDF_ISVEREN_HISSESI = 0 AND EPR.SSK_DAYS > 0)
                        )
                ),0) AS SGK_MUAF_KADIN,
                ISNULL((
                    SELECT
                        COUNT(E.EMPLOYEE_ID)
                    FROM 
                        EMPLOYEES E,
                        EMPLOYEES_DETAIL ED,
                        EMPLOYEES_PUANTAJ_ROWS EPR,
                        EMPLOYEES_IN_OUT EIO
                    WHERE
                        EIO.IN_OUT_ID = EPR.IN_OUT_ID AND
                        E.EMPLOYEE_ID = ED.EMPLOYEE_ID AND
                        EPR.EMPLOYEE_ID = E.EMPLOYEE_ID AND
                        EPR.PUANTAJ_ID = EP.PUANTAJ_ID AND
                        ISNULL(ED.SEX,1) = 1 AND
                        (
                            ISNULL(EPR.KIDEM_AMOUNT,0) + ISNULL(EPR.IHBAR_AMOUNT,0) > 0
                            OR
                            (EPR.SSK_ISVEREN_HISSESI + EPR.SSDF_ISVEREN_HISSESI = 0 AND EPR.SSK_DAYS > 0)
                        )
                ),0) AS SGK_MUAF_ERKEK,
                ISNULL((
                    SELECT
                        COUNT(E.EMPLOYEE_ID)
                    FROM 
                        EMPLOYEES E,
                        EMPLOYEES_DETAIL ED,
                        EMPLOYEES_PUANTAJ_ROWS EPR,
                        EMPLOYEES_IN_OUT EIO
                    WHERE
                        EIO.IN_OUT_ID = EPR.IN_OUT_ID AND
                        E.EMPLOYEE_ID = ED.EMPLOYEE_ID AND
                        EPR.EMPLOYEE_ID = E.EMPLOYEE_ID AND
                        EPR.PUANTAJ_ID = EP.PUANTAJ_ID AND
                (
                        ISNULL(EIO.DEFECTION_LEVEL,0) > 0 AND
                        (
                        ISNULL(EPR.KIDEM_AMOUNT,0) + ISNULL(EPR.IHBAR_AMOUNT,0) > 0
                        OR
                        (EPR.SSK_ISVEREN_HISSESI + EPR.SSDF_ISVEREN_HISSESI = 0 AND EPR.SSK_DAYS > 0)
                        )
                )
                ),0) AS SGK_MUAF_ENGELLI,
                ISNULL((
                    SELECT
                        COUNT(E.EMPLOYEE_ID)
                    FROM 
                        EMPLOYEES E,
                        EMPLOYEES_DETAIL ED,
                        EMPLOYEES_PUANTAJ_ROWS EPR,
                        EMPLOYEES_IN_OUT EIO
                    WHERE
                        <!---EIO.IN_OUT_ID = -1 AND  bilerek sifirlandi 24022015 ugur bey --->
                        EIO.IN_OUT_ID = EPR.IN_OUT_ID AND
                        E.EMPLOYEE_ID = ED.EMPLOYEE_ID AND
                        EPR.EMPLOYEE_ID = E.EMPLOYEE_ID AND
                        EPR.PUANTAJ_ID = EP.PUANTAJ_ID AND
                        ISNULL(ED.SEX,1) = 0 AND
                        (
                            ISNULL(EPR.KIDEM_AMOUNT,0) > 0
                        )
                ),0) AS GV_MUAF_KADIN,
                ISNULL((
                    SELECT
                        COUNT(E.EMPLOYEE_ID)
                    FROM 
                        EMPLOYEES E,
                        EMPLOYEES_DETAIL ED,
                        EMPLOYEES_PUANTAJ_ROWS EPR,
                        EMPLOYEES_IN_OUT EIO
                    WHERE
                        <!---EIO.IN_OUT_ID = -1 AND  bilerek sifirlandi 24022015 ugur bey --->
                        EIO.IN_OUT_ID = EPR.IN_OUT_ID AND
                        E.EMPLOYEE_ID = ED.EMPLOYEE_ID AND
                        EPR.EMPLOYEE_ID = E.EMPLOYEE_ID AND
                        EPR.PUANTAJ_ID = EP.PUANTAJ_ID AND
                        ISNULL(ED.SEX,1) = 1 AND
                        (
                            ISNULL(EPR.KIDEM_AMOUNT,0) > 0
                        )
                ),0) AS GV_MUAF_ERKEK,
                ISNULL((
                    SELECT
                        COUNT(E.EMPLOYEE_ID)
                    FROM 
                        EMPLOYEES E,
                        EMPLOYEES_DETAIL ED,
                        EMPLOYEES_PUANTAJ_ROWS EPR,
                        EMPLOYEES_IN_OUT EIO
                    WHERE
                        <!---EIO.IN_OUT_ID = -1 AND  bilerek sifirlandi 24022015 ugur bey --->
                        EIO.IN_OUT_ID = EPR.IN_OUT_ID AND
                        E.EMPLOYEE_ID = ED.EMPLOYEE_ID AND
                        EPR.EMPLOYEE_ID = E.EMPLOYEE_ID AND
                        EPR.PUANTAJ_ID = EP.PUANTAJ_ID AND
                        (ISNULL(EIO.DEFECTION_LEVEL,0) > 0 AND ISNULL(EPR.KIDEM_AMOUNT,0) > 0)
                ),0) AS GV_MUAF_ENGELLI,
                B.*
            FROM
                BRANCH B,
                EMPLOYEES_PUANTAJ EP
            WHERE
                EP.SSK_OFFICE = B.SSK_OFFICE AND
                EP.SSK_OFFICE_NO = B.SSK_NO AND 
                EP.SAL_YEAR = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.yearid#'> AND
                EP.SAL_MON = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.monthid#'>
                <cfif isdefined("attributes.s_branch_id") and listlen(attributes.s_branch_id)>
                    AND B.BRANCH_ID IN (#arguments.s_branch_id#)
                </cfif>
                <cfif isdefined("attributes.companyid") and listlen(attributes.companyid)>
                    AND B.COMPANY_ID IN (#arguments.companyid#)
                </cfif>
                <cfif not session.ep.ehesap>
                    AND B.BRANCH_ID IN 
                    (
                        SELECT
                            BRANCH_ID
                        FROM
                            EMPLOYEE_POSITION_BRANCHES
                        WHERE
                            EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#
                    )
                </cfif>
        </cfquery>

        <cfreturn query_branches>
    </cffunction>

    <cffunction name="get_ourcompany" access="public">
        
        <cfquery name="query_ourcompany" datasource="#dsn#">
            SELECT COMP_ID, COMPANY_NAME FROM OUR_COMPANY WHERE COMP_STATUS = 1 ORDER BY COMPANY_NAME
        </cfquery>
        <cfreturn query_ourcompany>
    </cffunction>

    <cffunction name="get_tevkifat_odeme" access="public">
        <cfargument name="invoice_cat">
        <cfargument name="sal_mon" default="">
        <cfargument name="sal_year" default="">

        <cfquery name="query_tevkifat_odeme" datasource="#dsn#">
            SELECT
            CASE
            WHEN I.CONSUMER_ID IS NOT NULL THEN CONCAT(CN.CONSUMER_NAME, CONCAT(' ', CN.CONSUMER_SURNAME))
            WHEN I.COMPANY_ID IS NOT NULL THEN CO.FULLNAME
            WHEN I.EMPLOYEE_ID IS NOT NULL THEN CONCAT(EM.EMPLOYEE_NAME, CONCAT(' ', EM.EMPLOYEE_SURNAME))
            ELSE ''
            END AS CUSTOMER_TITLE,
            CASE
            WHEN I.CONSUMER_ID IS NOT NULL THEN CN.TC_IDENTY_NO
            WHEN I.COMPANY_ID IS NOT NULL THEN ISNULL(CO.TAXNO,(SELECT TC_IDENTITY FROM #dsn#.COMPANY_PARTNER COMP_PART WHERE COMP_PART.COMPANY_ID = CO.COMPANY_ID AND COMP_PART.PARTNER_ID = CO.MANAGER_PARTNER_ID ))
            WHEN I.EMPLOYEE_ID IS NOT NULL THEN EM.OZEL_KOD
            ELSE ''
            END AS CUSTOMER_TAXNR,
            CASE
            WHEN I.CONSUMER_ID IS NOT NULL THEN CN.TAX_ADRESS
            WHEN I.COMPANY_ID IS NOT NULL THEN CO.COMPANY_ADDRESS
            WHEN I.EMPLOYEE_ID IS NOT NULL THEN EM.OZEL_KOD
            ELSE ''
            END AS CUSTOMER_ADDRES,
            ST.DETAIL AS TEVKIFAT_CODE,
            I.SERIAL_NO,
            I.SERIAL_NUMBER,
            I.INVOICE_CAT AS PROCESS_CAT,
            I.INVOICE_DATE,
            I.GROSSTOTAL  TAXTOTAL,
			I.STOPAJ AS TEVKIFAT_TUTAR,
            I.INVOICE_NUMBER
            FROM
            #dsn2#.INVOICE I
            INNER JOIN #dsn2#.SETUP_STOPPAGE_RATES ST ON I.STOPAJ_RATE_ID = ST.STOPPAGE_RATE_ID
            LEFT OUTER JOIN #dsn#.COMPANY CO ON I.COMPANY_ID = CO.COMPANY_ID
            LEFT OUTER JOIN #dsn#.CONSUMER CN ON I.CONSUMER_ID = CN.CONSUMER_ID
            LEFT OUTER JOIN #dsn#.EMPLOYEES EM ON I.EMPLOYEE_ID = EM.EMPLOYEE_ID
            WHERE
			(I.STOPAJ IS NOT NULL AND I.STOPAJ > 0) AND 
            I.INVOICE_CAT IN (#arguments.invoice_cat#)
            AND I.IS_IPTAL = 0
            AND DATEPART(MONTH, I.INVOICE_DATE) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_mon#'>
            AND DATEPART(YEAR, I.INVOICE_DATE) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_year#'>
            UNION ALL
            SELECT
            CASE
            WHEN EP.CH_CONSUMER_ID IS NOT NULL THEN CONCAT(CN.CONSUMER_NAME, CONCAT(' ', CN.CONSUMER_SURNAME))
            WHEN EP.CH_COMPANY_ID IS NOT NULL THEN CO.FULLNAME
            WHEN EP.CH_EMPLOYEE_ID IS NOT NULL THEN CONCAT(EM.EMPLOYEE_NAME, CONCAT(' ', EM.EMPLOYEE_SURNAME))
            ELSE ''
            END AS CUSTOMER_TITLE,
            CASE
            WHEN EP.CH_CONSUMER_ID IS NOT NULL THEN CN.TC_IDENTY_NO
            WHEN EP.CH_COMPANY_ID IS NOT NULL THEN ISNULL(CO.TAXNO,(SELECT TC_IDENTITY FROM #dsn#.COMPANY_PARTNER COMP_PART WHERE COMP_PART.COMPANY_ID = CO.COMPANY_ID AND COMP_PART.PARTNER_ID = CO.MANAGER_PARTNER_ID ))
            WHEN EP.CH_EMPLOYEE_ID IS NOT NULL THEN EM.OZEL_KOD
            ELSE ''
            END AS CUSTOMER_TAXNR,
            CASE
            WHEN EP.CH_CONSUMER_ID IS NOT NULL THEN CN.TAX_ADRESS
            WHEN EP.CH_COMPANY_ID IS NOT NULL THEN CO.COMPANY_ADDRESS
            WHEN EP.CH_EMPLOYEE_ID IS NOT NULL THEN EM.OZEL_KOD
            ELSE ''
            END AS CUSTOMER_ADDRES,
			ST.DETAIL AS TEVKIFAT_CODE,
            EP.SERIAL_NO,
            EP.SERIAL_NUMBER,
            EP.EXPENSE_COST_TYPE,
            EP.EXPENSE_DATE,
			EP.TOTAL_AMOUNT TAXTOTAL,
            EP.STOPAJ AS TEVKIFAT_TUTAR,
            CONVERT(NVARCHAR(100), EP.EXPENSE_ID)
            FROM
            #dsn2#.EXPENSE_ITEM_PLANS EP
			INNER JOIN #dsn2#.SETUP_STOPPAGE_RATES ST ON EP.STOPAJ_RATE_ID = ST.STOPPAGE_RATE_ID
            LEFT OUTER JOIN #dsn#.COMPANY CO ON EP.CH_COMPANY_ID = CO.COMPANY_ID
            LEFT OUTER JOIN #dsn#.CONSUMER CN ON EP.CH_CONSUMER_ID = CN.CONSUMER_ID
            LEFT OUTER JOIN #dsn#.EMPLOYEES EM ON EP.CH_EMPLOYEE_ID = EM.EMPLOYEE_ID
            WHERE
			(EP.STOPAJ IS NOT NULL AND EP.STOPAJ > 0) AND 
            EP.EXPENSE_COST_TYPE IN (#arguments.invoice_cat#)
            AND EP.IS_IPTAL = 0
            AND DATEPART(MONTH, EP.EXPENSE_DATE) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_mon#'>
            AND DATEPART(YEAR, EP.EXPENSE_DATE) = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.sal_year#'>
        </cfquery>
        <cfreturn query_tevkifat_odeme>
    </cffunction>

</cfcomponent>