<cfcomponent displayname="Board"  hint="Proje component">
    <cfset dsn = application.systemParam.systemParam().dsn>

    <cfif isDefined('session.pp.userid')>
        <cfset userid = "#session.pp.userid#">
        <cfset our_company_id = "#session.pp.our_company_id#">
        <cfset period_id = session.pp.period_id>
     <cfelseif isDefined('session.ep.userid') and isdefined("session.ep.company_id")> 
        <cfset userid = "#session.ep.userid#">
        <cfset period_id = session.ep.period_id>
        <cfset our_company_id = "#session.ep.company_id#">
     <cfelseif isDefined('session.ww.userid')>    
        <cfset userid = "#session.ep.userid#">
        <cfset period_id = session.ww.period_id>
        <cfset our_company_id = "#session.ww.our_company_id#"> 
     </cfif>
    <cffunction name="GET_CAT" access="remote" returntype="query">
        <cfargument name="keyword" default="process_cat">
        <cfquery name="GET_CAT" datasource="#dsn#">
            SELECT MAIN_PROCESS_CAT FROM SETUP_MAIN_PROCESS_CAT WHERE MAIN_PROCESS_CAT_ID = #arguments.process_cat#
        </cfquery>
        <cfreturn GET_CAT>
    </cffunction> 
    <cffunction name="GET_PROCESS" access="remote" returntype="query">
        <cfquery name="GET_PROCESS" datasource="#DSN#">
            SELECT STAGE FROM PROCESS_TYPE,PROCESS_TYPE_ROWS WHERE PROCESS_TYPE_ROWS.PROCESS_ID = PROCESS_TYPE.PROCESS_ID AND PROCESS_TYPE_ROWS.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pro_currency_id#"> 
        </cfquery>
        <cfreturn GET_PROCESS>
    </cffunction> 
    <cffunction name="EMPLOYEE_PHOTO" access="remote" returntype="query"><!----sonradan email ve telefon numarası eklendiği için numara ve email bu queryden çekildi.----->
        <cfargument name="employee_id" default="">
        <cfquery name="EMPLOYEE_PHOTO" datasource="#DSN#">
            SELECT 
                E.PHOTO,
                E2.SEX,
                EP.POSITION_NAME AS POSITION,
                E.EMPLOYEE_EMAIL,
                E.MOBILCODE,
                E.MOBILTEL,
                E2.MOBILCODE_SPC,
                E2.MOBILTEL_SPC
            FROM 
                EMPLOYEES AS E 
                LEFT JOIN EMPLOYEES_DETAIL AS E2 ON E2.EMPLOYEE_ID = E.EMPLOYEE_ID                
                LEFT JOIN EMPLOYEE_POSITIONS AS EP ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID   
            WHERE E.EMPLOYEE_ID = #arguments.employee_id#
        </cfquery>
        <cfreturn EMPLOYEE_PHOTO>
    </cffunction>
    <cffunction name="PARTNER_PHOTO" access="remote" returntype="query">
        <cfargument name="partner_id" default="">
        <cfquery name="PARTNER_PHOTO" datasource="#DSN#">
            SELECT 
                CP.PHOTO,
                CP.SEX,
                CP.MOBIL_CODE,
                CP.MOBILTEL,
                CP.COMPANY_PARTNER_EMAIL,
                CP.COMPANY_PARTNER_TELCODE,
                CP.COMPANY_PARTNER_TEL
            FROM 
                COMPANY_PARTNER CP
            WHERE CP.PARTNER_ID = #arguments.partner_id#
        </cfquery>
        <cfreturn PARTNER_PHOTO>
    </cffunction>
    <cffunction name="CONSUMER_PHOTO" access="remote" returntype="query">
        <cfargument name="consumer_id" default="">
        <cfquery name="CONSUMER_PHOTO" datasource="#DSN#">
            SELECT 
                C.PICTURE,
                C.SEX,
                C.CONSUMER_EMAIL,
                C.CONSUMER_WORKTELCODE,
                C.CONSUMER_WORKTEL,
                C.MOBIL_CODE,
                C.MOBILTEL
            FROM 
                CONSUMER C
            WHERE C.CONSUMER_ID = #arguments.consumer_id#
        </cfquery>
        <cfreturn CONSUMER_PHOTO>
    </cffunction>
    <cffunction name="GET_CONSUMER" access="remote" returntype="query">
        <cfargument name="consumer_id" default="">
        <cfquery name="GET_CONSUMER" datasource="#DSN#">
            SELECT 
                C.CONSUMER_ID,
                C.CONSUMER_NAME,
                C.CONSUMER_SURNAME
            FROM 
                CONSUMER C
            WHERE C.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
        </cfquery>
        <cfreturn GET_CONSUMER>
    </cffunction>
    <cffunction name="GET_EMP_NAME" access="remote" returntype="query">
        <cfargument name="employee_id" default="">
        <cfquery NAME="GET_EMP_NAME" DATASOURCE="#DSN#">
            SELECT
                EMPLOYEE_NAME,
                EMPLOYEE_SURNAME
            FROM
                EMPLOYEES
            WHERE
                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.EMPLOYEE_ID#">
        </cfquery>
        <cfreturn GET_EMP_NAME>
    </cffunction>
    <cffunction name="GET_PROJECT_WORKGROUP" access="remote" returntype="query">
        <cfargument name="project_id" default="">        
        <cfquery name="GET_PROJECT_WORKGROUP" datasource="#dsn#" maxrows="1">
            SELECT * FROM WORK_GROUP WHERE PROJECT_ID = #arguments.project_id#
        </cfquery>
        <cfreturn GET_PROJECT_WORKGROUP>        
    </cffunction>
    <cffunction name="GET_MONEY" access="remote" returntype="query">
        <cfquery name="GET_MONEY" datasource="#DSN#">
            SELECT
                MONEY
            FROM
                SETUP_MONEY
            WHERE
                PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#period_id#"> AND
                MONEY_STATUS = 1
            ORDER BY
                MONEY DESC
        </cfquery>
        <cfreturn GET_MONEY>        
    </cffunction>
    <cffunction name="GET_ACTION_WORKGROUP" access="remote" returntype="query">
        <cfargument name="action_field" default="">
        <cfargument name="action_id" default="">
        <cfquery name="GET_ACTION_WORKGROUP" datasource="#dsn#" maxrows="1">
            SELECT * FROM WORK_GROUP WHERE ACTION_FIELD = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.action_field#"> AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
        </cfquery>
        <cfreturn GET_ACTION_WORKGROUP>
    </cffunction>
    <cffunction name="GET_PROJECT_HEAD" access="remote" returntype="query">
        <cfargument name="project_id" default="">   
        <cfquery name="GET_PROJECT_HEAD" datasource="#dsn#" maxrows="1">
            SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #arguments.project_id#
        </cfquery>
        <cfreturn GET_PROJECT_HEAD>                
    </cffunction>
    <cffunction name="GET_GOOGLE_PROJECT_FOLDER_ID" access="remote" returntype="query">
        <cfargument name="project_id" default="">   
        <cfquery name="GET_GOOGLE_PROJECT_FOLDER_ID" datasource="#dsn#" maxrows="1">
            SELECT GOOGLE_PROJECT_FOLDER_ID FROM PRO_PROJECTS WHERE PROJECT_ID = #arguments.project_id#
        </cfquery>
        <cfreturn GET_GOOGLE_PROJECT_FOLDER_ID>                
    </cffunction>
    <cffunction name="GET_EMPS" access="remote" returntype="query">   
        <cfargument name="WORKGROUP_ID" default="">    
        <cfquery name="GET_EMPS" datasource="#dsn#">
            SELECT * FROM WORKGROUP_EMP_PAR WHERE WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.WORKGROUP_ID#"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#our_company_id#"> ORDER BY HIERARCHY
        </cfquery>
        <cfreturn GET_EMPS>                
    </cffunction>
    <cffunction name="GET_COMPANY_PARTNER" access="remote" returntype="query">    
        <cfargument name="PARTNER_ID" default="">           
        <cfquery name="GET_COMPANY_PARTNER" datasource="#dsn#">
            SELECT 
                COMPANY_PARTNER.PARTNER_ID,
                COMPANY_PARTNER_NAME,
                COMPANY_PARTNER_SURNAME,
                NICKNAME,
                COMPANY.COMPANY_ID
            FROM
                COMPANY,
                COMPANY_PARTNER
            WHERE
                COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
                COMPANY_PARTNER.PARTNER_ID = #arguments.PARTNER_ID#
        </cfquery>
        <cfreturn GET_COMPANY_PARTNER>                        
    </cffunction>  
    <cffunction name="GET_ROLES" access="remote" returntype="query">
        <cfargument name="PROJECT_ROLES_ID" default="">                         
        <cfquery name="GET_ROLES" datasource="#dsn#">
            SELECT * FROM SETUP_PROJECT_ROLES 
                <cfif len(arguments.PROJECT_ROLES_ID)>
                    WHERE PROJECT_ROLES_ID = #arguments.PROJECT_ROLES_ID#
                </cfif>
        </cfquery>
        <cfreturn GET_ROLES>                                
    </cffunction>       
    <cffunction name= "GET_EMP_DEL_BUTTONS" access="remote" returntype="any">
        <cfargument name="module_name" default="">                                               
        <cfargument name="position_id" default="">                         
        <cfargument name="user_id" default="">    
        <cfargument name="object_name" default="">                          
        <cfquery name="GET_EMP_DEL_BUTTONS" datasource="#DSN#">
            SELECT
                ED.DENIED_PAGE,
                ED.IS_DELETE
            FROM
                EMPLOYEE_POSITIONS_DENIED ED,
                EMPLOYEE_POSITIONS E
            WHERE
                (ED.IS_DELETE = 1) AND
                ED.DENIED_TYPE = 1 AND
                ED.MODULE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.module_name#"> AND
                ED.DENIED_PAGE = 'project.works' AND
                ED.DENIED_PAGE NOT IN
                (
                    SELECT
                        DENIED_PAGE
                    FROM
                        EMPLOYEE_POSITIONS_DENIED EPD,
                        EMPLOYEE_POSITIONS EP
                    WHERE
                        (EPD.IS_DELETE = 1) AND
                        EPD.DENIED_TYPE = 1 AND
                        EPD.MODULE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.module_name#"> AND
                        EPD.DENIED_PAGE =<cfqueryparam cfsqltype="cf_sql_varchar" value='project.works'> AND
                        EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_id#"> AND
                        (
                            EPD.POSITION_CODE = EP.POSITION_CODE OR
                            EPD.POSITION_CAT_ID = EP.POSITION_CAT_ID OR
                            EPD.USER_GROUP_ID = EP.USER_GROUP_ID
                        )
                )
                    UNION 
                    SELECT
                        U.OBJECT_NAME AS DENIED_PAGE,
                        DELETE_OBJECT AS IS_DELETE
                    FROM
                        EMPLOYEE_POSITIONS AS E
                        LEFT JOIN USER_GROUP_OBJECT AS U ON E.USER_GROUP_ID = U.USER_GROUP_ID
                    WHERE
                        E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.user_id#">
                        AND U.OBJECT_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value='#arguments.object_name#'>
        </cfquery>
        <cfreturn GET_EMP_DEL_BUTTONS>
    </cffunction>   
    <cffunction name= "EMPLOYEE_DENIED" access="remote" returntype="any">
        <cfargument name="position_id" default="">  
        <cfargument name="fuseaction" default="">                                  
        <cfquery name="EMPLOYEE_DENIED" datasource="#DSN#">         
            SELECT
                EPD.IS_DELETE,
                EPD.IS_INSERT,
                EPD.DENIED_PAGE
            FROM
                EMPLOYEE_POSITIONS_DENIED AS EPD,
                EMPLOYEE_POSITIONS AS EP
            WHERE
                EPD.DENIED_TYPE <> 1 AND
                EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_id#"> AND
                EPD.DENIED_PAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fuseaction#"> AND
                (
                    EPD.POSITION_CODE = EP.POSITION_CODE OR
                    EPD.POSITION_CAT_ID = EP.POSITION_CAT_ID OR
                    EPD.USER_GROUP_ID = EP.USER_GROUP_ID
                )
        </cfquery>
        <cfreturn EMPLOYEE_DENIED>
    </cffunction>  
</cfcomponent>