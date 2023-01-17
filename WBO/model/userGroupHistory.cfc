<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Ömer Turhan			Developer	: Gülbahar İnan		
Analys Date : 22/01/2021			Dev Date	: 26/01/2021		
Description :
	Bu component işyeri denetim işlemleri objesine ait history fonksiyonlarını içerir.
----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <!--- GET_USER_GROUP_HISTORY --->
    <cffunction name="GET_USER_GROUP_HISTORY" access="public" returntype="query">
        <cfargument name="user_group_id" required="true" default="">
        <cfquery name="GET_USER_GROUP_HISTORY" datasource="#dsn#">
            SELECT
               UGH.USER_GROUP_HIST_ID
              ,UGH.USER_GROUP_ID
              ,UG.USER_GROUP_NAME
              ,UGH.USER_GROUP_PERMISSIONS
              ,UGH.USER_GROUP_PERMISSIONS_EXTRA
              ,UGH.RECORD_DATE
              ,UGH.RECORD_EMP
              ,UGH.RECORD_IP
              ,UGH.UPDATE_DATE
              ,UGH.UPDATE_EMP
              ,UGH.UPDATE_IP
              ,UGH.IS_DEFAULT
              ,UGH.IS_BRANCH_AUTHORIZATION
              ,UGH.POWERUSER
              ,UGH.REPORT_USER_LEVEL
              ,UGH.SENSITIVE_USER_LEVEL
              ,UGH.DATA_LEVEL
              ,UGH.WRK_MENU
            FROM
                USER_GROUP_HISTORY UGH,
                USER_GROUP UG
            WHERE
                UGH.USER_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.user_group_id#"> AND 
                UG.USER_GROUP_ID = UGH.USER_GROUP_ID
            ORDER BY
                UGH.USER_GROUP_HIST_ID DESC
        </cfquery>
        <cfreturn GET_USER_GROUP_HISTORY>
    </cffunction>
    <!--- GET_USER_GROUP_HISTORY --->
     <!--- GET_USER_GROUP_EMP_HIST --->
     <cffunction name="GET_USER_GROUP_EMP_HIST" access="public" returntype="query">
        <cfargument name="user_group_id" required="true" default="">
        <cfquery name="GET_USER_GROUP_EMP_HIST" datasource="#DSN#">
            SELECT
                UGEH.USER_GROUP_ID,
                UGEH.RECORD_DATE,
                UGEH.RECORD_EMP,
                UGEH.UPDATE_EMP,
                UGEH.UPDATE_DATE
            FROM
                USER_GROUP_EMPLOYEE_HISTORY UGEH,
                USER_GROUP_EMPLOYEE UGE
            WHERE
                UGEH.USER_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.user_group_id#"> 
            GROUP BY
                UGEH.RECORD_DATE,
                UGEH.USER_GROUP_ID,
                UGEH.RECORD_EMP,
                UGEH.UPDATE_EMP,
                UGEH.UPDATE_DATE
        </cfquery>
        <cfreturn GET_USER_GROUP_EMP_HIST>
    </cffunction>
    <!--- GET_USER_GROUP_EMP_HIST --->
    <!--- GET_EMP_NAME_HIST --->
    <cffunction name="GET_EMP_NAME_HIST" access="public" returntype="query">
        <cfargument name="user_group_id" required="true" default="">
        <cfargument name="record_date" required="true" default="">
        <cfquery name="GET_EMP_NAME_HIST" datasource="#DSN#">
            SELECT
                UGEH.EMPLOYEE_ID
            FROM
                USER_GROUP_EMPLOYEE_HISTORY UGEH
            WHERE
                UGEH.USER_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.user_group_id#"> 
                AND UGEH.RECORD_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.RECORD_DATE#"> 
        </cfquery>
        <cfreturn GET_EMP_NAME_HIST>
    </cffunction>
    <!--- GET_EMP_NAME_HIST --->
     <!--- GET_USER_GROUP_OBJECT_HIST --->
     <cffunction name="GET_USER_GROUP_OBJECT_HIST" access="public" returntype="query">
        <cfargument name="user_group_id" required="true" default="">
        <cfquery name="GET_USER_GROUP_OBJECT_HIST" datasource="#DSN#">
            SELECT
            UGOH.USER_GROUP_ID
            ,UGOH.OBJECT_NAME
            ,UGOH.LIST_OBJECT
            ,UGOH.ADD_OBJECT
            ,UGOH.UPDATE_OBJECT
            ,UGOH.DELETE_OBJECT
            ,UGOH.RECORD_EMP
            ,UGOH.RECORD_IP
            ,UGOH.RECORD_DATE
            FROM
                USER_GROUP_OBJECT_HISTORY UGOH
                LEFT JOIN  USER_GROUP_OBJECT UGO ON UGOH.USER_GROUP_OBJECT_ID = UGO.USER_GROUP_OBJECT_ID
            WHERE
                UGOH.USER_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.user_group_id#"> 
            GROUP BY
                UGOH.USER_GROUP_ID
                ,UGOH.OBJECT_NAME
                ,UGOH.LIST_OBJECT
                ,UGOH.ADD_OBJECT
                ,UGOH.UPDATE_OBJECT
                ,UGOH.DELETE_OBJECT
                ,UGOH.RECORD_EMP
                ,UGOH.RECORD_IP
                ,UGOH.RECORD_DATE
            ORDER BY
                UGOH.RECORD_DATE
        </cfquery>
        <cfreturn GET_USER_GROUP_OBJECT_HIST>
    </cffunction>
    <!--- GET_USER_GROUP_OBJECT_HIST --->
</cfcomponent>