<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Göksenin Sönmez Özkorucu		
Analys Date : 01/04/2016			Dev Date	: 20/05/2016		
Description :
	Bu component işyeri denetim işlemleri objesine ait CRUD ve list fonksiyonlarını gerceklestirir.
----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <!--- GET_USER_GROUPS --->
    <cffunction name="GET_USER_GROUPS" access="public" returntype="query">
        <cfquery name="GET_USER_GROUPS" datasource="#DSN#">
            SELECT 
                USER_GROUP_ID, 
                USER_GROUP_NAME, 
                USER_GROUP_PERMISSIONS, 
                USER_GROUP_PERMISSIONS_EXTRA, 
                RECORD_DATE, 
                RECORD_EMP, 
                RECORD_IP, 
                UPDATE_DATE, 
                UPDATE_EMP, 
                UPDATE_IP, 
                IS_DEFAULT,
                WRK_MENU,
                (SELECT COUNT(*) FROM USER_GROUP_EMPLOYEE WHERE USER_GROUP_EMPLOYEE.USER_GROUP_ID = USER_GROUP.USER_GROUP_ID) USER_COUNT
            FROM 
                USER_GROUP
            ORDER BY 
                USER_GROUP_NAME
        </cfquery>
        <cfreturn GET_USER_GROUPS>
    </cffunction>
    <!--- GET_USER_GROUPS --->
    
    <!--- GET_OBJECTS_INFO --->
    <cffunction name="GET_OBJECTS_INFO" access="public" returntype="query">
        <cfargument name="OBJECT_NAME" hint="OBJECT_NAME"  required="yes">
            <cfquery name="GET_OBJECTS_INFO" datasource="#DSN#">
                SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = '#arguments.OBJECT_NAME#'
            </cfquery>
        <cfreturn GET_OBJECTS_INFO>
    </cffunction>
    <!--- GET_OBJECTS_INFO --->
    
    <!--- GET_MODULES --->
    <cffunction name="GET_MODULES" access="public" returntype="query">
        <cfquery name="GET_MODULES" datasource="#DSN#">
            SELECT
            	ISNULL(Replace(S3.ITEM_#UCASE(session.ep.language)#,'''',''),WS.SOLUTION) AS SOLUTION,
                ISNULL(Replace(S2.ITEM_#UCASE(session.ep.language)#,'''',''),WF.FAMILY) AS FAMILY,
                ISNULL(Replace(S1.ITEM_#UCASE(session.ep.language)#,'''',''),WM.MODULE) AS MODULE,
                WM.MODULE_NO AS MODUL_NO,
                WM.MODULE_TYPE
            FROM
                WRK_MODULE AS WM
                LEFT JOIN SETUP_LANGUAGE_TR AS S1 ON WM.MODULE_DICTIONARY_ID = S1.DICTIONARY_ID
                LEFT JOIN WRK_FAMILY AS WF ON WM.FAMILY_ID = WF.WRK_FAMILY_ID
                LEFT JOIN SETUP_LANGUAGE_TR AS S2 ON WF.FAMILY_DICTIONARY_ID = S2.DICTIONARY_ID
                LEFT JOIN WRK_SOLUTION AS WS ON WF.WRK_SOLUTION_ID = WS.WRK_SOLUTION_ID
                LEFT JOIN SETUP_LANGUAGE_TR AS S3 ON WS.SOLUTION_DICTIONARY_ID = S3.DICTIONARY_ID
           <!--- WHERE
            	ISNULL(WS.IS_MENU,1) = 1 AND
                ISNULL(WF.IS_MENU,1) = 1 AND
                ISNULL(WM.IS_MENU,1) = 1--->
            ORDER BY
                Replace(S3.ITEM_#UCASE(session.ep.language)#,'''',''),
                Replace(S2.ITEM_#UCASE(session.ep.language)#,'''',''),
                Replace(S1.ITEM_#UCASE(session.ep.language)#,'''','')
        </cfquery>
        <cfreturn GET_MODULES>
    </cffunction>
    <!--- GET_MODULES --->
    <!--- GET_MODULES_NAME --->
    <cffunction name="GET_MODULES_NAME" access="remote" returntype="query">
        <cfargument name="module_no" hint="module_no"  required="yes">
        <cfquery name="GET_MODULES_NAME" datasource="#DSN#">
            SELECT
                ISNULL(Replace(S1.ITEM_#UCASE(session.ep.language)#,'''',''),WM.MODULE) AS MODULE,
                WM.MODULE_NO AS MODUL_NO,
                WM.MODULE_TYPE
            FROM
                WRK_MODULE AS WM
                LEFT JOIN SETUP_LANGUAGE_TR AS S1 ON WM.MODULE_DICTIONARY_ID = S1.DICTIONARY_ID

            WHERE MODULE_NO IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.module_no#" list="true">)
            ORDER BY
                Replace(S1.ITEM_#UCASE(session.ep.language)#,'''','')
        </cfquery>
        <cfreturn GET_MODULES_NAME>
    </cffunction>
    <!--- GET_MODULES_NAME --->
    <!--- GET_USER_GROUP --->
    <cffunction name="GET_USER_GROUP" access="public" returntype="query">
    	<cfargument name="ID" hint="UserGroup ID" required="yes">
        <cfquery name="GET_USER_GROUP" datasource="#DSN#">
            SELECT
                *
            FROM
                USER_GROUP
            WHERE
                USER_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ID#">
        </cfquery>
        <cfreturn GET_USER_GROUP>
    </cffunction>
    <!--- GET_USER_GROUP --->

    <!--- GET_OBJECT --->
    <cffunction name="GET_OBJECT" access="public" returntype="query">
    	<cfargument name="ID" hint="UserGroup ID" required="yes">
        <cfquery name="GET_OBJECT" datasource="#DSN#">
            SELECT
                USER_GROUP_ID,
                OBJECT_NAME,
                LIST_OBJECT,
                ADD_OBJECT,
                UPDATE_OBJECT,
                DELETE_OBJECT,
                MODULE_NO
            FROM
                USER_GROUP_OBJECT
            WHERE
                USER_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ID#">
        </cfquery>
        <cfreturn GET_OBJECT>
    </cffunction>
    <!--- GET_OBJECT --->

    <!--- GET_GROUP_EMP_COUNT --->
    <cffunction name="GET_GROUP_EMP_COUNT" access="public" returntype="query">
    	<cfargument name="ID" hint="UserGroup ID" required="yes">
        <cfquery name="GET_GROUP_EMP_COUNT" datasource="#DSN#">
            SELECT 
                COUNT(USER_GROUP_ID) AS TOTAL 
            FROM 
                USER_GROUP_EMPLOYEE
            WHERE 
                USER_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ID#">
        </cfquery>
        <cfreturn GET_GROUP_EMP_COUNT>
    </cffunction>
    <!--- GET_GROUP_EMP_COUNT --->

    <!--- GET_GROUP_EMP_COUNT --->
    <cffunction name="GET_USER_GROUP_MEMBER" access="public" returntype="query">
    	<cfargument name="ID" hint="EmployeeId" required="yes">
        <cfquery name="GET_USER_GROUP_MEMBER" datasource="#DSN#">
            SELECT
            	DISTINCT
            	EP.EMPLOYEE_ID,
                EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME AS EMPLOYEE,
                EP.POSITION_NAME,
                EP.POSITION_ID
			FROM
            	USER_GROUP_EMPLOYEE AS UGE
                LEFT JOIN EMPLOYEE_POSITIONS AS EP ON UGE.POSITION_ID = EP.POSITION_ID
			WHERE
            	UGE.USER_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ID#">
        </cfquery>
        <cfreturn GET_USER_GROUP_MEMBER>
    </cffunction>
    <!--- GET_GROUP_EMP_COUNT --->

    <!--- GET_MENUS --->
    <cffunction name="GET_MENUS" access="public" returntype="query">
        <cfquery name="GET_MENUS" datasource="#DSN#">
            SELECT 
                WRK_MENU_ID, 
                WRK_MENU_NAME
            FROM 
                WRK_MENU
            WHERE
                MENU_STATUS = 1
            ORDER BY 
                WRK_MENU_NAME
        </cfquery>
        <cfreturn GET_MENUS>
    </cffunction>
    <!--- GET_MENUS --->

    <!---GDPR Authorization ---->
    <cffunction name="GET_GDPR_AUTHORIZATION" access="public" returntype="query">
        <cfquery name="GET_GDPR_AUTHORIZATION" datasource="#DSN#">
            SELECT 
                SENSITIVITY_LABEL,
                SENSITIVITY_LABEL_ID,
                SENSITIVITY_LABEL_NO
            FROM 
                GDPR_SENSITIVITY_LABEL
            ORDER BY 
                SENSITIVITY_LABEL_ID,
                SENSITIVITY_LABEL
        </cfquery>
        <cfreturn GET_GDPR_AUTHORIZATION>
    </cffunction>

     <!---GDPR Authorization NAME ---->
     <cffunction name="GET_GDPR_NAME" access="public" returntype="query">
        <cfargument name="sensitivity_id" hint="EmployeeId" required="yes">
        <cfquery name="GET_GDPR_NAME" datasource="#DSN#">
            SELECT 
                SENSITIVITY_LABEL,
                SENSITIVITY_LABEL_ID,
                SENSITIVITY_LABEL_NO
            FROM 
                GDPR_SENSITIVITY_LABEL
            WHERE SENSITIVITY_LABEL_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sensitivity_id#" list="true">)
            ORDER BY 
                SENSITIVITY_LABEL
        </cfquery>
        <cfreturn GET_GDPR_NAME>
    </cffunction>
</cfcomponent>