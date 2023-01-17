<!--- File: list_hr.cfc
    Author: Canan Ebret <cananebret@workcube.com>
    Date: 12.09.2019
    Controller: -
    Description: kim kimdir sayfası için list_hr.cfm de ve ajax_hr_list.cfm çagırılmak uzere queryler olusturulmustur.​
 --->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="GetEmployeeDetail" access="public" returntype="query">
        <cfargument name="mobiltel_list" default="">
        <cfquery name="get_employee_detail" datasource="#dsn#">
            SELECT
               EMPLOYEE_ID,MOBILCODE_SPC, 
               MOBILTEL_SPC 
            FROM 
               EMPLOYEES_DETAIL
            WHERE 
               EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#mobiltel_list#">)
            ORDER BY EMPLOYEE_ID
        </cfquery>
        <cfreturn get_employee_detail>
    </cffunction>
    <cffunction name="GetPositions" access="public" returntype="query"> 
        <cfargument name="employee_list" default="">   
        <cfquery name="get_positions" datasource="#dsn#">
            SELECT
                DEPARTMENT.DEPARTMENT_HEAD,
                EMPLOYEE_POSITIONS.POSITION_NAME,
                EMPLOYEE_POSITIONS.EMPLOYEE_ID,
                SETUP_POSITION_CAT.POSITION_CAT
            FROM
                EMPLOYEE_POSITIONS,
                DEPARTMENT,
                SETUP_POSITION_CAT
            WHERE
                SETUP_POSITION_CAT.POSITION_CAT_ID = EMPLOYEE_POSITIONS.POSITION_CAT_ID
            AND
                EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
            AND
                EMPLOYEE_POSITIONS.POSITION_STATUS = 1
            AND 
                EMPLOYEE_POSITIONS.EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#employee_list#">)
        </cfquery>
        <cfreturn get_positions>
    </cffunction>
    <cffunction name="GetPosition" access="public" returntype="query"> 
        <cfargument name="employee_id" default="">  
        <cfquery name="get_position" dbtype="query" maxrows="1">
            SELECT 
               DEPARTMENT_HEAD,
               POSITION_NAME,
               POSITION_CAT 
            FROM 
               GET_POSITIONS 
            WHERE  
               EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#employee_id#">
        </cfquery>
        <cfreturn get_position>
    </cffunction>
    <cffunction name="TITLES" access="public" returntype="query">
        <cfquery name="get_titles" datasource="#dsn#">
            SELECT 
               TITLE_ID,
               TITLE 
            FROM 
               SETUP_TITLE 
            WHERE 
               IS_ACTIVE = 1 
            ORDER BY TITLE
        </cfquery>
        <cfreturn get_titles>
    </cffunction>
</cfcomponent>