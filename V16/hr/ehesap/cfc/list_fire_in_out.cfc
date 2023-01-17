<!---
    File: list_fire_in_out.cfc
    Author: Esma R. UYSAL
    Description:
       İşe Giriş Çıkış Query'leri
--->
<cfcomponent displayname="LIST_FIRE_IN_OUT"  hint="Arge" extends="WMO.functions">
    <cfset dsn = application.systemParam.systemParam().dsn>
    
    <cffunction name="GET_EMPLOYEE_IN" access="remote"  returntype="any">
        <cfargument name="in_out_ids" >
        <cfargument name="type" default="2">
        <cfquery name="GET_IN_OUTS" datasource="#dsn#">
            SELECT 
                (SELECT SBC.BUSINESS_CODE FROM SETUP_BUSINESS_CODES SBC WHERE SBC.BUSINESS_CODE_ID = EMPLOYEES_IN_OUT.BUSINESS_CODE_ID) AS BUSINESS_CODE,
                EMPLOYEES_IN_OUT.VALID,		
                EMPLOYEES_IN_OUT.IN_OUT_ID,
                EMPLOYEES_IN_OUT.IS_5084,
                EMPLOYEES_IN_OUT.START_DATE,
                EMPLOYEES_IN_OUT.FINISH_DATE,
                EMPLOYEES_IN_OUT.KIDEM_AMOUNT,
                EMPLOYEES_IN_OUT.IHBAR_AMOUNT,
                EMPLOYEES_IN_OUT.RECORD_DATE,
                EMPLOYEES_IN_OUT.UPDATE_DATE,
                EMPLOYEES_IN_OUT.EXPLANATION_ID,
                EMPLOYEES_IN_OUT.EX_IN_OUT_ID,
                CASE 
                    WHEN EMPLOYEES_IN_OUT.SSK_STATUTE = 1 THEN 0
                    WHEN EMPLOYEES_IN_OUT.SSK_STATUTE = 2 THEN 8
                    WHEN EMPLOYEES_IN_OUT.SSK_STATUTE = 3 THEN 19
                    WHEN EMPLOYEES_IN_OUT.SSK_STATUTE = 4 THEN 7
                ELSE 1 END AS SIGORTAKOLU,
                CASE 
                    WHEN EMPLOYEES_IN_OUT.DUTY_TYPE = 0 THEN 1
                    WHEN EMPLOYEES_IN_OUT.DUTY_TYPE = 1 THEN 1
                    WHEN (EMPLOYEES_IN_OUT.SSK_STATUTE = 3 OR EMPLOYEES_IN_OUT.SSK_STATUTE = 4) THEN 5
                ELSE 2 END AS GOREVKODU,		
                BRANCH.BRANCH_WORK,
                EMPLOYEES_IDENTY.TC_IDENTY_NO,
                EMPLOYEES.KIDEM_DATE,
                EMPLOYEES.EMPLOYEE_NAME,
                EMPLOYEES.EMPLOYEE_SURNAME,
                EMPLOYEES.EMPLOYEE_ID,
                BRANCH.BRANCH_NAME,
                BRANCH.BRANCH_FULLNAME,
                BRANCH.BRANCH_ID,
                BRANCH.SSK_OFFICE,
                BRANCH.SSK_NO,
                BRANCH.BRANCH_ADDRESS,
                BRANCH.SSK_AGENT,
                SS.DECLARATION_ID AS OGRENIMKODU,
                EGITIM.EDU_FINISH,
                EGITIM.EDU_PART_NAME,
                CASE WHEN (EMPLOYEES_DETAIL.DEFECTED = 1) THEN 'E' ELSE 'H' END AS OZURLUKODU,
                CASE WHEN (EMPLOYEES_DETAIL.SENTENCED = 1) THEN 'E' ELSE 'H' END AS ESKIHUKUMLU,
                BRANCH.SSK_M + '' + BRANCH.SSK_JOB + '' + BRANCH.SSK_BRANCH + '' + BRANCH.SSK_BRANCH_OLD + '' + BRANCH.SSK_NO + '' + BRANCH.SSK_CITY + '' + BRANCH.SSK_COUNTRY AS SSK_ISYERI,
                BRANCH.SSK_M + '' + BRANCH.SSK_JOB + '' + BRANCH.SSK_BRANCH + '' + BRANCH.SSK_BRANCH_OLD + '' + BRANCH.SSK_NO + '' + BRANCH.SSK_CITY + '' + BRANCH.SSK_COUNTRY + '' +BRANCH.SSK_CD + '' + BRANCH.SSK_AGENT AS SSK_SICIL,
                BB.SSK_M + '' + BB.SSK_JOB + '' + BB.SSK_BRANCH + '' + BB.SSK_BRANCH_OLD + '' + BB.SSK_NO + '' + BB.SSK_CITY + '' + BB.SSK_COUNTRY + '' +BB.SSK_CD + '' + BB.SSK_AGENT  AS TRANSFER_SSK_SICIL,
                D.DEPARTMENT_HEAD
            FROM 
                EMPLOYEES_IN_OUT
                LEFT JOIN EMPLOYEES_IN_OUT AA ON AA.IN_OUT_ID = EMPLOYEES_IN_OUT.EX_IN_OUT_ID
                LEFT JOIN BRANCH BB ON BB.BRANCH_ID = AA.BRANCH_ID,
                EMPLOYEES
                    OUTER APPLY
                        (SELECT TOP 1 EDU_TYPE,EDU_PART_NAME,EDU_FINISH FROM EMPLOYEES_APP_EDU_INFO WHERE EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID ORDER BY EDU_FINISH DESC) EGITIM
                LEFT JOIN SETUP_EDUCATION_LEVEL SS ON SS.EDU_LEVEL_ID = EGITIM.EDU_TYPE
                ,
                EMPLOYEES_DETAIL,
                EMPLOYEES_IDENTY,
                BRANCH,
                DEPARTMENT D
            WHERE
                EMPLOYEES_IN_OUT.DEPARTMENT_ID = D.DEPARTMENT_ID AND
                EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID AND
                EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IDENTY.EMPLOYEE_ID AND
                EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_DETAIL.EMPLOYEE_ID AND
                EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID 
                <cfif arguments.type eq 2>
                    AND EMPLOYEES_IN_OUT.IN_OUT_ID in (#arguments.in_out_ids#)
                <cfelse>
                    AND EMPLOYEES_IN_OUT.EX_IN_OUT_ID in (#arguments.in_out_ids#)
                </cfif>
            ORDER BY
                BRANCH.BRANCH_NAME,
                EMPLOYEES.EMPLOYEE_NAME,
                EMPLOYEES.EMPLOYEE_SURNAME,
                EMPLOYEES_IN_OUT.START_DATE
        </cfquery>
        <cfreturn GET_IN_OUTS>
    </cffunction>
    <cffunction name="GET_EMPLOYEE_OUT" access="remote"  returntype="any">
        <cfargument name="in_out_ids" >
        <cfquery name="GET_IN_OUTS" datasource="#dsn#">
            SELECT 
                (SELECT SBC.BUSINESS_CODE FROM SETUP_BUSINESS_CODES SBC WHERE SBC.BUSINESS_CODE_ID = EMPLOYEES_IN_OUT.BUSINESS_CODE_ID) AS BUSINESS_CODE,
                EMPLOYEES_IN_OUT.VALID,
                EMPLOYEES_IN_OUT.DUTY_TYPE,		
                EMPLOYEES_IN_OUT.IN_OUT_ID,
                EMPLOYEES_IN_OUT.IS_5084,
                EMPLOYEES_IN_OUT.START_DATE,
                EMPLOYEES_IN_OUT.FINISH_DATE,
                EMPLOYEES_IN_OUT.KIDEM_AMOUNT,
                EMPLOYEES_IN_OUT.IHBAR_AMOUNT,
                EMPLOYEES_IN_OUT.RECORD_DATE,
                EMPLOYEES_IN_OUT.UPDATE_DATE,
                EMPLOYEES_IN_OUT.EXPLANATION_ID,
                EMPLOYEES_IN_OUT.EX_IN_OUT_ID,
                EMPLOYEES_IN_OUT.SSK_STATUTE,
                EMPLOYEES_IDENTY.TC_IDENTY_NO,
                EMPLOYEES.KIDEM_DATE,
                EMPLOYEES.EMPLOYEE_NAME,
                EMPLOYEES.EMPLOYEE_SURNAME,
                EMPLOYEES.EMPLOYEE_ID,
                BRANCH.BRANCH_NAME,
                BRANCH.BRANCH_FULLNAME,
                BRANCH.BRANCH_ID,
                BRANCH.SSK_OFFICE,
                BRANCH.SSK_NO,
                BRANCH.BRANCH_ADDRESS,
                BRANCH.SSK_AGENT,
                BRANCH.BRANCH_WORK,
                BRANCH.SSK_M + '' + BRANCH.SSK_JOB + '' + BRANCH.SSK_BRANCH + '' + BRANCH.SSK_BRANCH_OLD + '' + BRANCH.SSK_NO + '' + BRANCH.SSK_CITY + '' + BRANCH.SSK_COUNTRY AS SSK_ISYERI,
                BRANCH.SSK_M + '' + BRANCH.SSK_JOB + '' + BRANCH.SSK_BRANCH + '' + BRANCH.SSK_BRANCH_OLD + '' + BRANCH.SSK_NO + '' + BRANCH.SSK_CITY + '' + BRANCH.SSK_COUNTRY + '' +BRANCH.SSK_CD + '' + BRANCH.SSK_AGENT AS SSK_SICIL,
                BB.SSK_M + '' + BB.SSK_JOB + '' + BB.SSK_BRANCH + '' + BB.SSK_BRANCH_OLD + '' + BB.SSK_NO + '' + BB.SSK_CITY + '' + BB.SSK_COUNTRY + '' +BB.SSK_CD + '' + BB.SSK_AGENT  AS TRANSFER_SSK_SICIL,
                D.DEPARTMENT_HEAD,
                BUDONEM.*,
                GECMISDONEM.*
            FROM 
                EMPLOYEES_IN_OUT
                    OUTER APPLY
                    (
                    SELECT TOP 1
                        EPR.SSK_MATRAH AS BUDONEM_MATRAH,
                        EPR.TOTAL_DAYS AS BUDONEM_GUN,
                        EPR.IZIN AS BUDONEM_IZIN,
                        (EPR.TOTAL_SALARY - (EPR.SSK_DEVIR + EPR.SSK_DEVIR_LAST + EPR.TOTAL_PAY_TAX + EPR.KIDEM_AMOUNT + EPR.IHBAR_AMOUNT + EPR.TOTAL_PAY)) AS BUDONEM_TOTAL_KAZANC,
                        (EPR.TOTAL_PAY_SSK_TAX + EPR.TOTAL_PAY_SSK + EPR.SSK_DEVIR + EPR.SSK_DEVIR_LAST) AS BUDONEM_TOTAL_IKRAMIYE
                    FROM
                        EMPLOYEES_PUANTAJ EP,
                        EMPLOYEES_PUANTAJ_ROWS EPR
                    WHERE
                        EP.PUANTAJ_ID = EPR.PUANTAJ_ID AND
                        EPR.IN_OUT_ID = EMPLOYEES_IN_OUT.IN_OUT_ID AND
                        EP.SAL_YEAR = YEAR(EMPLOYEES_IN_OUT.FINISH_DATE) AND
                        EP.SAL_MON = MONTH(EMPLOYEES_IN_OUT.FINISH_DATE)
                    ) AS BUDONEM
                    OUTER APPLY
                    (
                    SELECT TOP 1
                        EPR.SSK_MATRAH AS GDONEM_MATRAH,
                        EPR.TOTAL_DAYS AS GDONEM_GUN,
                        EPR.IZIN AS GDONEM_IZIN,
                        (EPR.TOTAL_SALARY - (EPR.SSK_DEVIR + EPR.SSK_DEVIR_LAST + EPR.TOTAL_PAY_TAX + EPR.KIDEM_AMOUNT + EPR.IHBAR_AMOUNT + EPR.TOTAL_PAY)) AS GDONEM_TOTAL_KAZANC,
                        (EPR.TOTAL_PAY_SSK_TAX + EPR.TOTAL_PAY_SSK + EPR.SSK_DEVIR + EPR.SSK_DEVIR_LAST) AS GDONEM_TOTAL_IKRAMIYE,
                        EP.SAL_MON AS G_SAL_MON,
                        EP.SAL_YEAR AS G_SAL_YEAR
                    FROM
                        EMPLOYEES_PUANTAJ EP,
                        EMPLOYEES_PUANTAJ_ROWS EPR
                    WHERE
                        EP.PUANTAJ_ID = EPR.PUANTAJ_ID AND
                        EPR.IN_OUT_ID = EMPLOYEES_IN_OUT.IN_OUT_ID AND
                        EP.SAL_MON <> MONTH(EMPLOYEES_IN_OUT.FINISH_DATE)
                    ORDER BY
                        EP.SAL_YEAR DESC,
                        EP.SAL_MON DESC
                    ) AS GECMISDONEM
                    LEFT JOIN EMPLOYEES_IN_OUT AA ON AA.EX_IN_OUT_ID = EMPLOYEES_IN_OUT.IN_OUT_ID
                    LEFT JOIN BRANCH BB ON BB.BRANCH_ID = AA.BRANCH_ID
                ,
                EMPLOYEES,
                EMPLOYEES_IDENTY,
                BRANCH,
                DEPARTMENT D
            WHERE
                EMPLOYEES_IN_OUT.DEPARTMENT_ID = D.DEPARTMENT_ID AND
                EMPLOYEES_IN_OUT.BRANCH_ID = BRANCH.BRANCH_ID AND
                EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IDENTY.EMPLOYEE_ID AND
                EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID AND
                EMPLOYEES_IN_OUT.FINISH_DATE IS NOT NULL 
                AND EMPLOYEES_IN_OUT.IN_OUT_ID in (#arguments.in_out_ids#)
            ORDER BY
                BRANCH.BRANCH_NAME,
                EMPLOYEES.EMPLOYEE_NAME,
                EMPLOYEES.EMPLOYEE_SURNAME,
                EMPLOYEES_IN_OUT.START_DATE
        </cfquery>
        <cfreturn GET_IN_OUTS>
    </cffunction>

    <cffunction name="get_assetps" access="remote"  returntype="any">
        <cfargument name="employee_id" >
        <cfquery name="get_assetps" datasource="#dsn#">
            SELECT
                ASSET_P.ASSETP_ID,
                ASSET_P.ASSETP,
                ASSET_P_CAT.ASSETP_CAT
            FROM
                ASSET_P
                LEFT JOIN ASSET_P_CAT ON ASSET_P.ASSETP_CATID = ASSET_P_CAT.ASSETP_CATID
            WHERE
                ASSET_P.STATUS = 1 AND
                ASSET_P.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
            ORDER BY
                ASSET_P.ASSETP
        </cfquery>
        <cfreturn get_assetps>
    </cffunction>

    <cffunction name="get_debits" access="remote"  returntype="any">
        <cfargument name="employee_id" >
        <cfquery name="get_debits" datasource="#dsn#">
            SELECT 
                ERZR.* 
            FROM 
                EMPLOYEES_INVENT_ZIMMET_ROWS ERZR,
                EMPLOYEES_INVENT_ZIMMET EIZ
            WHERE 
                ERZR.ZIMMET_ID = EIZ.ZIMMET_ID AND
                EIZ.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
        </cfquery>
        <cfreturn get_debits>
    </cffunction>

    <cffunction name="get_execution" access="remote"  returntype="any">
        <cfargument name="employee_id" >
        <cfquery name="get_execution" datasource="#dsn#">
            SELECT 
                EMPLOYEE_ID
            FROM 
                COMMANDMENT
            WHERE 
                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
                AND (COMMANDMENT_VALUE - ISNULL(PRE_COMMANDMENT_VALUE,0) - ISNULL(ODENEN,0)) > 0
        </cfquery>
        <cfreturn get_execution.RECORDCOUNT>
    </cffunction>

    <cffunction name="get_execution_detail" access="remote"  returntype="any">
        <cfargument name="employee_id">
        <cfargument name="sal_mon">
        <cfargument name="sal_year">
        <cfquery name="get_execution_detail" datasource="#dsn#">
            SELECT 
                *,
                (COMMANDMENT_VALUE - ISNULL(PRE_COMMANDMENT_VALUE,0) - ISNULL(ODENEN,0) + ISNULL(CLOSED_AMOUNT,0)) AS REMAINING
            FROM 
                COMMANDMENT C
                LEFT JOIN COMMANDMENT_ROWS CR ON CR.COMMANDMENT_ID = C.COMMANDMENT_ID AND CR.SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_mon#"> AND CR.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_year#">
            WHERE 
                C.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
                AND (COMMANDMENT_VALUE - ISNULL(PRE_COMMANDMENT_VALUE,0) - ISNULL(ODENEN,0) + ISNULL(CLOSED_AMOUNT,0)) > 0
                AND COMMANDMENT_TYPE = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
        </cfquery>
        <cfreturn get_execution_detail>
    </cffunction>

    <cffunction name="upd_execution_detail" access="remote"  returntype="any"  returnformat="JSON">
        <cfargument name="employee_id_">
        <cfset responseStruct = structNew()>
        <cftry>
            <cfloop list="#arguments.id_list#" index="row_id">
                <cfquery name="upd_execution_detail" datasource="#dsn#">
                    UPDATE
                        COMMANDMENT
                    SET
                        PAY_COMMANDMENT_VALUE = <cfif isdefined('arguments.PAY_COMMANDMENT_VALUE_#row_id#') and len(evaluate("arguments.PAY_COMMANDMENT_VALUE_#row_id#"))><cfqueryparam cfsqltype="cf_sql_float" value="#filternum(evaluate("arguments.PAY_COMMANDMENT_VALUE_#row_id#"))#"><cfelse>0</cfif>
                    WHERE
                        COMMANDMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#row_id#">
                </cfquery>
            </cfloop>
            <cfset responseStruct.message = "İşlem Başarılı">
            <cfset responseStruct.status = true>
            <cfset responseStruct.error = {}>
            <cfset responseStruct.identity = ''>
        <cfcatch type="database">
            <cftransaction action="rollback">
            <cfset responseStruct.message = "İşlem Hatalı">
            <cfset responseStruct.status = false>
            <cfset responseStruct.error = cfcatch>
        </cfcatch>
        </cftry>
        <cfreturn Replace(SerializeJSON(responseStruct),'//','')>>
    </cffunction>
</cfcomponent>