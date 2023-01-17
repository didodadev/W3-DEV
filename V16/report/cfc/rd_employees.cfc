<!---
    File: rd_employees.cfc
    Author: Esma R. UYSAL
    Description:
       Rapora seçilen ayda ücret kartında 5746 kanun maddeleri seçilen çalışanlar geliyor. 
--->
<cfcomponent displayname="Arge"  hint="Arge">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn3 = "#dsn#_#session.ep.company_id#">
    <cfset dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    
    <cffunction name="GET_RD_EMPLOYEES" access="remote"  returntype="any">
        <cfargument name="employee_id">
        <cfargument name="employee_name">
        <cfargument name="sal_mon">
        <cfargument name="sal_year">
        <cfargument name="comp_ids">
        <cfargument name="department_id">
        <cfargument name="branch_ids">
        <cfquery name="GET_RD_EMPLOYEES" datasource="#dsn#">
            SELECT
                EPR.*,
				(EPR.DAMGA_VERGISI_INDIRIMI_5746 / 7.59 * 1000) AS DVM_MATRAH_5746,
                EIO.LAW_NUMBERS,
                EI.TC_IDENTY_NO,
                EIO.START_DATE AS IN_OUT_START_DATE,
                ISNULL((SELECT SUM(VERGI_ISTISNA_AMOUNT) FROM EMPLOYEES_PUANTAJ_ROWS_EXT EEP WHERE EEP.EMPLOYEE_PUANTAJ_ID = EPR.EMPLOYEE_PUANTAJ_ID AND EEP.EXT_TYPE = 2),0) VERGI_ISTISNA_AMOUNT
            FROM   
                EMPLOYEES_PUANTAJ_ROWS EPR 
                    INNER JOIN EMPLOYEES_PUANTAJ EP ON EPR.PUANTAJ_ID = EP.PUANTAJ_ID
		            INNER JOIN EMPLOYEES_IN_OUT EIO ON EIO.IN_OUT_ID = EPR.IN_OUT_ID 
                    INNER JOIN EMPLOYEES_IDENTY EI ON EI.EMPLOYEE_ID = EIO.EMPLOYEE_ID	
                    INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EPR.EMPLOYEE_ID
                    INNER JOIN BRANCH B ON EP.SSK_BRANCH_ID = B.BRANCH_ID	
            WHERE
                <cfif len(arguments.employee_id) and len(arguments.employee_name)> 
                    EPR.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#"> AND
                </cfif>
                <cfif len(arguments.sal_mon)> 
                    EP.SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_mon#"> AND
                </cfif>
                <cfif len(arguments.sal_year)> 
                    EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sal_year#"> AND
                </cfif>
                <cfif len(arguments.branch_ids)> 
                    B.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_ids#" list="yes">) AND
                </cfif>
                <cfif not session.ep.ehesap>
                    B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#) AND
                    B.COMPANY_ID IN (SELECT DISTINCT BR.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH BR ON BR.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) AND
                </cfif>
                <cfif len(arguments.department_id)> 
                    EPR.POSITION_DEPARTMENT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#" list="yes">) AND
                </cfif>
                <cfif isdefined("arguments.comp_ids") and len(arguments.comp_ids)>
                    B.COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.comp_ids#" list="yes">) AND	
                </cfif>
                    EP.PUANTAJ_TYPE =  <cfqueryparam cfsqltype="cf_sql_integer" value="-1"> AND 
                    (EIO.LAW_NUMBERS LIKE 'ARGE%' AND
					(EPR.SSK_DAYS_5746 > 0 OR EPR.TAX_DAYS_5746 > 0) OR EIO.LAW_NUMBERS LIKE '5746%')
			ORDER BY
				E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME
        </cfquery>
        <cfreturn GET_RD_EMPLOYEES>
    </cffunction>
    <cffunction name="get_active_tax_slice" access="remote"  returntype="any">
        <cfargument name="sal_year">
        <cfquery name="get_active_tax_slice" datasource="#dsn#">
            SELECT 
            TAX_SL_ID, 
            NAME, 
            STARTDATE, 
            FINISHDATE, 
            STATUS, 
            MIN_PAYMENT_1, 
            MAX_PAYMENT_1, 
            RATIO_1, 
            MIN_PAYMENT_2, 
            MAX_PAYMENT_2, 
            RATIO_2,
            MIN_PAYMENT_3, 
            MAX_PAYMENT_3, 
            RATIO_3, 
            MIN_PAYMENT_4, 
            MAX_PAYMENT_4, 
            RATIO_4, 
            MIN_PAYMENT_5,
            MAX_PAYMENT_5, 
            RATIO_5, 
            MIN_PAYMENT_6, 
            MAX_PAYMENT_6, 
            RATIO_6, 
            RECORD_DATE, 
            RECORD_IP,
            RECORD_EMP, 
            SAKAT1,
            SAKAT2, 
            SAKAT3 
        FROM 
            SETUP_TAX_SLICES 
        WHERE 
            YEAR(STARTDATE) = <cfqueryparam value = "#arguments.sal_year#" CFSQLType = "cf_sql_integer">
    </cfquery>
        <cfreturn get_active_tax_slice>
    </cffunction>
</cfcomponent>