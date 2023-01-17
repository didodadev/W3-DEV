<!---
File: offtimes.cfc
Author: Workcube-Esma Uysal <esmauysal@workcube.com>
Controller: -
Description: Offtime Query Functions
Date: 23/10/2019
--->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <!--- İzinler --->
	<cffunction name="GET_OFFTIMES" access="public" returntype="query">
        <cfargument name="employee_id">
        <cfargument name="list_upper_emp_ids">
        <cfargument name="startdate">
        <cfargument name="finishdate">
		<cfquery name="GET_OFFTIMES" datasource="#DSN#">
            SELECT 
                OFFTIME.*,
                SETUP_OFFTIME.OFFTIMECAT,
                SETUP_OFFTIME.IS_PAID,
                SETUP_OFFTIME.IS_YEARLY,
                SETUP_OFFTIME.EBILDIRGE_TYPE_ID,
                SETUP_OFFTIME.CALC_CALENDAR_DAY,
                CASE 
            WHEN ISNULL(OFFTIME.SUB_OFFTIMECAT_ID,0) <> 0 THEN (SELECT top 1 OFFTIMECAT FROM SETUP_OFFTIME A WHERE A.OFFTIMECAT_ID = OFFTIME.SUB_OFFTIMECAT_ID)
            WHEN ISNULL(OFFTIME.SUB_OFFTIMECAT_ID,0) = 0 THEN (SELECT top 1  OFFTIMECAT FROM OFFTIME B WHERE B.OFFTIMECAT_ID = OFFTIME.OFFTIMECAT_ID)
        END AS NEW_CAT_NAME
            FROM 
                OFFTIME,
                EMPLOYEES,
                SETUP_OFFTIME
            WHERE
                OFFTIME.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
                OFFTIME.OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID AND
                <cfif isdefined("arguments.startdate") and len(arguments.startdate)>
                    OFFTIME.STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp"  value="#arguments.startdate#">  AND
                </cfif>
                <cfif isdefined("arguments.finishdate") and len(arguments.finishdate)>
                    OFFTIME.FINISHDATE < #dateadd('d',1,arguments.finishdate)# AND
                </cfif>
                <cfif len(arguments.employee_id)>
                    OFFTIME.EMPLOYEE_ID = <cfqueryparam value="#arguments.employee_id#" cfsqltype="cf_sql_integer" > AND
                <cfelse>
                    EMPLOYEES.EMPLOYEE_ID IN (<cfqueryparam value="#arguments.list_upper_emp_ids#" cfsqltype="cf_sql_integer" list = "yes" >) AND
                </cfif>
                <cfif isDefined("arguments.offtimecat_id") and len(arguments.offtimecat_id)>
                    SETUP_OFFTIME.OFFTIMECAT_ID = <cfqueryparam value="#arguments.offtimecat_id#" cfsqltype="cf_sql_integer" > AND
                </cfif>
                (
                    OFFTIME.IS_PLAN <> 1 OR OFFTIME.IS_PLAN IS NULL
                )
            ORDER BY
                OFFTIME.STARTDATE DESC
        </cfquery>
        <cfreturn GET_OFFTIMES>
    </cffunction>
    <cffunction name="GET_OFFTIMES_" access="public" returntype="query">
        <cfargument name="employee_id">
        <cfargument name="list_upper_emp_ids">
        <cfargument name="startdate">
        <cfargument name="finishdate">
		<cfquery name="GET_OFFTIMES_" datasource="#DSN#">
            SELECT 
                FINISHDATE,
                STARTDATE,
                EMPLOYEE_ID
            FROM 
                OFFTIME
            WHERE   
                VALID = 1 AND             
                <cfif len(arguments.employee_id)>
                    EMPLOYEE_ID = <cfqueryparam value="#arguments.employee_id#" cfsqltype="cf_sql_integer" > AND
                </cfif>
                <cfif isDefined("arguments.offtimecat_id") and len(arguments.offtimecat_id)>
                    OFFTIMECAT_ID = <cfqueryparam value="#arguments.offtimecat_id#" cfsqltype="cf_sql_integer">                    
                </cfif>
        </cfquery>
        <cfif GET_OFFTIMES_.recordcount eq 0>
            <cfquery name="GET_OFFTIMES_" datasource="#DSN#">
                SELECT 
                    FINISHDATE,
                    STARTDATE
                FROM 
                    OFFTIME
                WHERE   
                    VALID = 1 AND             
                    <cfif len(arguments.employee_id)>
                        EMPLOYEE_ID = <cfqueryparam value="#arguments.employee_id#" cfsqltype="cf_sql_integer"> AND
                    </cfif>
                    <cfif isDefined("arguments.offtimecat_id") and len(arguments.offtimecat_id)>
                        SUB_OFFTIMECAT_ID = <cfqueryparam value="#arguments.offtimecat_id#" cfsqltype="cf_sql_integer">
                    </cfif>
            </cfquery>
        </cfif>
        <cfreturn GET_OFFTIMES_>
    </cffunction>
    <!--- İptal Talebi Oluşturma --->
    <cffunction name="UPDATE_OFFTIMES_CANCEL" access="remote" returntype="query">
        <cfargument name="offtime_id">
		<cfquery name="UPDATE_OFFTIMES_CANCEL" datasource="#DSN#">
            UPDATE OFFTIME SET IS_CANCEL = 1 WHERE OFFTIME_ID = <cfqueryparam value="#arguments.offtime_id#" cfsqltype="cf_sql_integer" >
        </cfquery>
        <cfreturn 1>
	</cffunction>

    <cffunction name="GET_OFFTIME_DATE" access="public" returntype="query">
        <cfargument name="employee_id">
        <cfargument name="startdate">
        <cfargument name="finishdate">
		<cfquery name="GET_OFFTIME_DATE" datasource="#DSN#">
            SELECT 
                EMPLOYEE_ID
            FROM 
                OFFTIME
            WHERE
                VALID = 1 
                <cfif len(arguments.employee_id)>
                    AND EMPLOYEE_ID = <cfqueryparam value="#arguments.employee_id#" cfsqltype="cf_sql_integer"> 
                </cfif>
                AND
                (
                    (STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startdate#"> AND 
                    FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startdate#">)
                    OR
                    (STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finishdate#"> AND 
                    FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finishdate#">)
                    OR
                    (STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startdate#"> AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finishdate#">)
                    OR
                    (STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startdate#"> AND STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finishdate#">)
                )
        </cfquery>
        <cfreturn GET_OFFTIME_DATE>
    </cffunction>
</cfcomponent>
