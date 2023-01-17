<!---
    File: v16\hr\ehesap\cfc\delete_payroll.cfc
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 2020-11-13
    Description: Puantaj Satır Silme
        
    History:
        
    To Do:

--->
<cfcomponent displayname="DELETE_PAYROLL">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dir_seperator = application.systemParam.systemParam().dir_seperator>
    <cfset response = "">
    <cfset data = "">
    <cfset serializedStr = "">
    <!--- Çalışan puantaj Silme--->
    <cffunction name="DEL_PAYROLL_ROW" access="remote" returntype="any">
        <cfquery name="get_puantaj_" datasource="#dsn#">
            SELECT 
                EP.PUANTAJ_TYPE,
                EP.PUANTAJ_ID,
                EP.SAL_MON,
                EP.SAL_YEAR,
                EPR.IN_OUT_ID,
                EPR.SSK_DEVIR,
                EPR.SSK_DEVIR_LAST,
                EP.SSK_OFFICE,
                EP.SSK_OFFICE_NO,
                EP.SSK_BRANCH_ID,
                EPR.EMPLOYEE_ID,
                EP.STAGE_ROW_ID
            FROM 
                EMPLOYEES_PUANTAJ_ROWS EPR,
                EMPLOYEES_PUANTAJ EP
            WHERE 
                EP.PUANTAJ_ID = EPR.PUANTAJ_ID AND
                EPR.EMPLOYEE_PUANTAJ_ID = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.EMPLOYEE_PUANTAJ_ID#">
        </cfquery>
        <cfif len(get_puantaj_.stage_row_id)>
            <cfset x_select_process=1>
        <cfelse>
            <cfset x_select_process=0>
        </cfif>
        <cfquery name="control" datasource="#dsn#">
            SELECT 
                EP.SAL_MON,
                EP.SAL_YEAR,
                EP.PUANTAJ_TYPE,
                EPR.IN_OUT_ID,
                EPR.SSK_DEVIR,
                EPR.SSK_DEVIR_LAST,
                EP.SSK_OFFICE,
                EP.SSK_OFFICE_NO,
                EPR.EMPLOYEE_ID
            FROM 
                EMPLOYEES_PUANTAJ_ROWS EPR,
                EMPLOYEES_PUANTAJ EP
            WHERE 
                EP.PUANTAJ_ID = EPR.PUANTAJ_ID AND
                (
                (EPR.SSK_DEVIR IS NOT NULL AND EPR.SSK_DEVIR > 0)
                OR
                (EPR.SSK_DEVIR_LAST IS NOT NULL AND EPR.SSK_DEVIR_LAST > 0)
                )
                AND
                EPR.EMPLOYEE_PUANTAJ_ID = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.EMPLOYEE_PUANTAJ_ID#">
        </cfquery>
        <cfif control.recordcount>
            <cfoutput query="control">
                <cfset arguments.sal_mon = SAL_MON>
                <cfset arguments.sal_year = SAL_YEAR>
                <cfif len(ssk_devir) and ssk_devir gt 0>
                    <cfquery name="upd_" datasource="#dsn#">
                        UPDATE 
                            EMPLOYEES_PUANTAJ_ROWS_ADD
                        SET 
                            AMOUNT_USED = (AMOUNT_USED - #ssk_devir#) 
                        WHERE
                            PUANTAJ_ID IN (SELECT PUANTAJ_ID FROM EMPLOYEES_PUANTAJ WHERE <cfif len(control.puantaj_type)>PUANTAJ_TYPE = #control.puantaj_type#<cfelse>PUANTAJ_TYPE = -1</cfif>) AND
                            EMPLOYEE_ID = #EMPLOYEE_ID# AND
                            <cfif arguments.sal_mon gt 2>
                            (
                            SAL_YEAR = #arguments.sal_year# AND
                            SAL_MON = #arguments.sal_mon - 1# 
                            )
                            <cfelseif arguments.sal_mon eq 1>
                            (
                            SAL_YEAR = #arguments.sal_year-1# AND
                            SAL_MON = 12
                            )
                            <cfelseif arguments.sal_mon eq 2>
                            SAL_YEAR = #arguments.sal_year# AND 
                            SAL_MON = 1		
                            </cfif>
                    </cfquery>
                </cfif>
                <cfif len(ssk_devir_last) and ssk_devir_last gt 0>
                    <cfquery name="upd_" datasource="#dsn#">
                        UPDATE 
                            EMPLOYEES_PUANTAJ_ROWS_ADD
                        SET 
                            AMOUNT_USED = (AMOUNT_USED - #ssk_devir_last#) 
                        WHERE					
                            PUANTAJ_ID IN (SELECT PUANTAJ_ID FROM EMPLOYEES_PUANTAJ WHERE <cfif len(control.puantaj_type)>PUANTAJ_TYPE = #control.puantaj_type#<cfelse>PUANTAJ_TYPE = -1</cfif>) AND
                            EMPLOYEE_ID = #EMPLOYEE_ID# AND
                            <cfif arguments.sal_mon gt 2>
                            (
                            SAL_YEAR = #arguments.sal_year# AND
                            SAL_MON = #arguments.sal_mon - 2#
                            )
                            <cfelseif arguments.sal_mon eq 1>
                            (
                            SAL_YEAR = #arguments.sal_year-1# AND
                            SAL_MON = 11
                            )
                            <cfelseif arguments.sal_mon eq 2>
                            (
                            (SAL_YEAR = #arguments.sal_year-1# AND SAL_MON = 12)
                            )
                            </cfif>
                    </cfquery>
                </cfif>
            </cfoutput>
        </cfif>
        <cflock timeout="20">
            <cftransaction>
                <cfquery name="del_puantaj_rows" datasource="#dsn#">
                DELETE FROM EMPLOYEES_PUANTAJ_ROWS WHERE EMPLOYEE_PUANTAJ_ID = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.EMPLOYEE_PUANTAJ_ID#">
                </cfquery>
                <cfquery name="del_puantaj_rows_officer" datasource="#dsn#">
                    DELETE FROM OFFICER_PAYROLL_ROW WHERE  EMPLOYEE_PAYROLL_ID = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.EMPLOYEE_PUANTAJ_ID#">
                </cfquery>
                <cfquery name="DEL_PUANTAJ_ROWS_EXT" datasource="#DSN#">
                DELETE FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE EMPLOYEE_PUANTAJ_ID = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.EMPLOYEE_PUANTAJ_ID#">
                </cfquery>
                <cfquery name="DEL_PUANTAJ_ROWS_EXT" datasource="#DSN#">
                DELETE FROM EMPLOYEES_PUANTAJ_ROWS_ADD WHERE EMPLOYEE_PUANTAJ_ID = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.EMPLOYEE_PUANTAJ_ID#">
                </cfquery>
                <cfquery name="upd_payrol_job" datasource="#dsn#">
                    UPDATE
                        PAYROLL_JOB   
                    SET
                        PERCENT_COMPLETED  = <cfqueryparam CFSQLType = "cf_sql_bit" value = "0">,
                        PAYROLL_DRAFT  = NULL,
                        EMPLOYEE_PAYROLL_ID = NULL,
                        ACCOUNT_COMPLETED  = <cfqueryparam CFSQLType = "cf_sql_bit" value = "0">,
                        ACCOUNT_DRAFT = NULL,
                        BUDGET_COMPLETED = <cfqueryparam CFSQLType = "cf_sql_bit" value = "0">,
                        BUDGET_DRAFT = NULL
                    WHERE 
                        EMPLOYEE_PAYROLL_ID = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.EMPLOYEE_PUANTAJ_ID#">
                </cfquery>
                <cf_add_log  log_type="-1" action_id="#arguments.EMPLOYEE_PUANTAJ_ID#" fuseact="ehesap.list_puantaj" dsn_alias="#dsn#" action_name="#get_puantaj_.IN_OUT_ID# - #get_puantaj_.ssk_office# - #get_puantaj_.ssk_office_no# / #get_puantaj_.sal_year# - #get_puantaj_.sal_mon# (#get_puantaj_.PUANTAJ_TYPE#) Puantaj Satırı Silindi.">
            </cftransaction>
        </cflock>
        <cfquery name="control_other_rows" datasource="#dsn#">
            SELECT EMPLOYEE_ID FROM EMPLOYEES_PUANTAJ_ROWS WHERE PUANTAJ_ID = #get_puantaj_.PUANTAJ_ID#
        </cfquery>
        <cfif not control_other_rows.recordcount>
            <cfset arguments.puantaj_id = get_puantaj_.PUANTAJ_ID>
            <cfinclude template="delet_puantaj.cfm">
        </cfif>
        <cfreturn 1>
    </cffunction>
</cfcomponent>