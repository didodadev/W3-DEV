<!---
    File: employees_in_out.cfc
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 2021-05-24
    Description: Employees In Out Query Functions
        
    History:
        
    To Do:

--->
 
<cfcomponent displayname="EMPLOYEES_IN_OUT">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cfset dsn3 = '#dsn#_#session.ep.company_id#'>

    <cffunction name="get_emp_branch" access="public" returntype="any">
        <cfquery name="get_emp_branch" datasource="#DSN#">
            SELECT
                EMPLOYEE_POSITION_BRANCHES.BRANCH_ID,
                EMPLOYEE_POSITION_BRANCHES.POSITION_CODE                
            FROM
                EMPLOYEE_POSITION_BRANCHES,
                BRANCH
            WHERE
                EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#
                AND EMPLOYEE_POSITION_BRANCHES.BRANCH_ID = BRANCH.BRANCH_ID
            ORDER BY
                BRANCH.BRANCH_NAME
        </cfquery>
        <cfreturn get_emp_branch>
    </cffunction>

    <!--- Çalışan durum kontrol --->
    <cffunction name="IN_OUT_OFFICER" access="public" returntype="any">
        <cfargument  name="employee_id" default="" required="yes">
        <cfargument  name="use_ssk" default="" required="yes">
        <cfquery name="IN_OUT_OFFICER" datasource="#DSN#">
            SELECT
                IN_OUT_ID
            FROM
                EMPLOYEES_IN_OUT
            WHERE
                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
                AND USE_SSK = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.use_ssk#">
        </cfquery>

        <cfreturn IN_OUT_OFFICER>
    </cffunction>

    <cffunction name="GET_OTHER_PERIOD" access="public" returntype="any">
        <cfargument  name="period_id" default="" required="yes">
        <cfquery name="GET_OTHER_PERIOD" datasource="#DSN#">
            SELECT	
                * 
            FROM 
                SETUP_PERIOD 
            WHERE 
                OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_id#">
        </cfquery>
        <cfreturn GET_OTHER_PERIOD>
    </cffunction>

    <cffunction name="get_in_out_info" access="public" returntype="any">
        <cfargument  name="department_id" default="" required="yes">
        <cfquery name="get_in_out_info" datasource="#dsn#">
            SELECT
                DEPARTMENT.DEPARTMENT_HEAD,
                BRANCH.BRANCH_NAME,
                DEPARTMENT.DEPARTMENT_ID,
                BRANCH.BRANCH_ID,
                BRANCH.BRANCH_NAME,
                BRANCH.SSK_OFFICE,
                BRANCH.SSK_NO,
                OUR_COMPANY.NICK_NAME
            FROM
                DEPARTMENT
                INNER JOIN BRANCH ON DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
                INNER JOIN OUR_COMPANY ON BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID
            WHERE
                DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#">
        </cfquery>
        <cfreturn get_in_out_info>
    </cffunction>
    

    <cffunction name="GET_EMP_SSK" access="public" returntype="any">
        <cfargument  name="in_out_id" default="" required="yes">
        <cfquery name="GET_EMP_SSK" datasource="#dsn#">
            SELECT
                EIO.EMPLOYEE_ID,
                EIO.BRANCH_ID,
                EIO.DEPARTMENT_ID,
                EIO.PAYMETHOD_ID,
                EIO.BUSINESS_CODE_ID,
                EIO.IN_OUT_ID,
                EIO.USE_SSK,
                EIO.START_DATE,
                EIO.FINISH_DATE,
                EIO.TRADE_UNION,
                EIO.TRADE_UNION_NO,
                EIO.IS_5510,
                EIO.IS_START_CUMULATIVE_TAX,
                EIO.KISMI_ISTIHDAM_GT_GUN,
                EIO.DUTY_TYPE_COMPANY_ID,
                EIO.SOCIALSECURITY_NO,
                EIO.SSK_STATUTE,
                EIO.RETIRED_SGDP_NUMBER,
                EIO.DUTY_TYPE,
                EIO.KISMI_ISTIHDAM_GUN,
                EIO.KISMI_ISTIHDAM_SAAT,
                EIO.IS_VARDIYA,
                EIO.FIRST_SSK_DATE,
                EIO.SURELI_IS_AKDI,
                EIO.SURELI_IS_FINISHDATE,
                EIO.SHIFT_ID,
                EIO.USE_PDKS,
                EIO.PDKS_NUMBER,
                EIO.PDKS_TYPE_ID,
                EIO.CUMULATIVE_TAX_TOTAL,
                EIO.START_CUMULATIVE_TAX,
                EIO.SABIT_PRIM,
                EIO.IS_TAX_FREE,
                EIO.IS_DAMGA_FREE,
                EIO.GROSS_NET,
                EIO.USE_TAX,
                EIO.SALARY_TYPE,
                EIO.DEFECTION_LEVEL,
                EIO.DEFECTION_RATE,
                EIO.FAZLA_MESAI_SAAT,
                EIO.EFFECTED_CORPORATE_CHANGE,
                EIO.DAYS_5746,
                EIO.IS_DISCOUNT_OFF ,
                EIO.IS_5084,
                EIO.IS_PUANTAJ_OFF,
                EIO.DATE_5763,
                EIO.LAW_NUMBERS,
                EIO.RECORD_EMP,
                EIO.UPDATE_EMP,
                EIO.RECORD_DATE,
                EIO.UPDATE_DATE,
                EIO.TRANSPORT_TYPE_ID,
                EIO.DATE_6111,
                EIO.DATE_6111_SELECT,
                EIO.START_MON_6645,
                EIO.START_YEAR_6645,
                EIO.END_MON_6645,
                EIO.END_YEAR_6645,
                EIO.PUANTAJ_GROUP_IDS,
                EIO.IS_6486,
                EIO.IS_6322,
                EIO.IS_25510,
                EIO.IS_14857,
                EIO.IS_6645,
                EIO.IN_OUT_STAGE,
                EIO.DAYS_4691,
                EIO.WORKING_ABROAD,
                SBC.BUSINESS_CODE,
                SBC.BUSINESS_CODE_NAME,
                EIO.IS_46486,
                EIO.IS_56486,
                EIO.IS_66486,
                EIO.MONTHLY_AVERAGE_NET,
                ISNULL(EIO.BENEFIT_DAY_7252,0) AS BENEFIT_DAY_7252,
                EIO.IS_TAX_FREE_687,
                ISNULL(EIO.BENEFIT_MONTH_7103,0) AS BENEFIT_MONTH_7103,
                EIO.STARTDATE_7256,
                EIO.FINISHDATE_7256,
                REGISTRY_NO,
                RETIRED_REGISTRY_NO,
                GRADE,
                STEP,
                ADDITIONAL_SCORE,
                ADMINISTRATIVE_INDICATOR_SCORE,
                EXECUTIVE_INDICATOR_SCORE,
                PRIVATE_SERVICE_SCORE,
                ADMINISTRATIVE_FUNCTION_ALLOWANCE,
                LANGUAGE_ALLOWANCE_1,
                LANGUAGE_ALLOWANCE_2,
                LANGUAGE_ALLOWANCE_3,
                LANGUAGE_ALLOWANCE_4,
                LANGUAGE_ALLOWANCE_5,
                UNIVERSITY_ALLOWANCE,
                MINIMUM_COURSE_HOURS,
                DIRECTOR_SHARE,
                EMPLOYEE_SHARE,
                PERQUISITE_SCORE,
                ACADEMIC_INCENTIVE_ALLOWANCE,
                HIGH_EDUCATION_COMPENSATION,
                LANGUAGE_ID_1,
                LANGUAGE_ID_2,
                LANGUAGE_ID_3,
                LANGUAGE_ID_4,
                LANGUAGE_ID_5,
                ADDITIONAL_COURSE_POSITION,
                STARTDATE_SHIFT,
                FINISHDATE_SHIFT,
                ADDITIONAL_INDICATOR_COMPENSATION,
                IS_EDUCATION_ALLOWANCE,
                GRADE_NORMAL,
                STEP_NORMAL,
                ADDITIONAL_SCORE_NORMAL,
                WORK_DIFFICULTY,
                BUSINESS_RISK_EMP,
                JUL_DIFFICULTIES,
                FINANCIAL_RESPONSIBILITY,
                SEVERANCE_PENSION_SCORE,
                ADMINISTRATIVE_ACADEMIC,
                IS_PENANCE_DEDUCTION,
                IS_AUDIT_COMPENSATION,
                AUDIT_COMPENSATION,
                IS_SUSPENSION,
                SUSPENSION_STARTDATE,
                SUSPENSION_FINISHDATE,
                IS_VETERAN,
                DEFECTION_STARTDATE,
    		    DEFECTION_FINISHDATE,
                PAST_AGI_DAY,
                LAND_COMPENSATION_SCORE,
                LAND_COMPENSATION_PERIOD,
                SERVICE_CLASS,
                SERVICE_TITLE,
                JURY_MEMBERSHIP,
                JURY_MEMBERSHIP_PERIOD,
                JURY_NUMBER,
                USE_MINIMUM_WAGE,
                IS_USE_506,
				ISNULL(START_CUMULATIVE_WAGE_TOTAL,0) START_CUMULATIVE_WAGE_TOTAL
            FROM
                EMPLOYEES_IN_OUT EIO
                LEFT JOIN SETUP_BUSINESS_CODES SBC ON SBC.BUSINESS_CODE_ID = EIO.BUSINESS_CODE_ID
            WHERE
                EIO.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.in_out_id#">
        </cfquery>
        <cfreturn GET_EMP_SSK>
    </cffunction>

    <cffunction name="get_factor_definition" access="public" returntype="any">
        <cfargument  name="startdate" default="">
        <cfargument  name="finishdate" default="">
        <cfargument  name="factor_id" default="">
        <cfquery name="get_factor_definition" datasource="#dsn#">
            SELECT
                *
            FROM
                SALARY_FACTOR_DEFINITION
            WHERE
                1 = 1
            <cfif isdefined('arguments.factor_id') and len(arguments.factor_id)>
                AND ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.factor_id#"> 
            </cfif>
            <cfif isdefined("arguments.startdate") and len(arguments.startdate)>
                AND STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startdate#">
                AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finishdate#"> 
            </cfif>
            ORDER BY
                RECORD_DATE DESC
        </cfquery>
        
        <cfreturn get_factor_definition>
    </cffunction>

</cfcomponent>