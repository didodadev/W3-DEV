<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>

    <cffunction name="GET_POS_DETAIL" access="public" returntype="any">
        <cfquery name="GET_POSITION_DETAIL" datasource="#DSN#">
            SELECT
                EMPLOYEE_POSITIONS.POSITION_CODE,
                EMPLOYEE_POSITIONS.USER_GROUP_ID,
                EMPLOYEE_POSITIONS.LEVEL_ID,
                EMPLOYEE_POSITIONS.LEVEL_EXTRA_ID,
                EMPLOYEE_POSITIONS.POWER_USER_LEVEL_ID,
                EMPLOYEE_POSITIONS.UPDATE_EMP,
                EMPLOYEE_POSITIONS.UPDATE_DATE,
                EMPLOYEE_POSITIONS.WRK_MENU,
                EPH.RECORD_DATE,
                EPH.RECORD_EMP
            FROM
                EMPLOYEE_POSITIONS 
                LEFT JOIN EMPLOYEE_POSITIONS_HISTORY EPH ON EPH.POSITION_ID=EMPLOYEE_POSITIONS.POSITION_ID AND EPH.HISTORY_ID = (SELECT TOP 1 EPH2.HISTORY_ID FROM EMPLOYEE_POSITIONS_HISTORY EPH2 WHERE EPH2.POSITION_ID = #session.ep.POSITION_CODE# ORDER BY EPH2.HISTORY_ID ASC)
            WHERE
                EMPLOYEE_POSITIONS.POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.POSITION_CODE#">
        </cfquery>
        <cfreturn GET_POSITION_DETAIL>
    </cffunction>

    <!--- Start of Employee Functions --->
    <cffunction name="add_employee" access="public" returntype="any">
        <cfargument name="EMPLOYEE_STATUS" default="">
        <cfargument name="EMPLOYEE_NAME" default="">
        <cfargument name="EMPLOYEE_SURNAME" default="">
        <cfargument name="EMPLOYEE_EMAIL" default="">
        <cfargument name="EMPLOYEE_USERNAME" default="">
        <cfargument name="EMPLOYEE_PASSWORD" default="">
        <cfargument name="EMPLOYEE_STAGE" default="">
        <cfargument name="EMPLOYEE_NO" default="">
        <cfargument name="sifreli" default="">
        <cfquery name="ADD_EMPLOYEES" datasource="#DSN#" result="my_result">
            INSERT INTO
                EMPLOYEES
            (
                <cfif len(arguments.EMPLOYEE_STATUS)> EMPLOYEE_STATUS,</cfif>
                <cfif len(arguments.EMPLOYEE_NAME)> EMPLOYEE_NAME,</cfif>
                <cfif len(arguments.EMPLOYEE_SURNAME)> EMPLOYEE_SURNAME,</cfif>
                EMPLOYEE_EMAIL,
                <cfif len(arguments.EMPLOYEE_USERNAME)> EMPLOYEE_USERNAME,</cfif>
                <cfif len(arguments.EMPLOYEE_PASSWORD )> EMPLOYEE_PASSWORD,</cfif>
                EMPLOYEE_NO,
                RECORD_DATE, 
                RECORD_EMP, 
                RECORD_IP,
                EMPLOYEE_STAGE
            )
            VALUES
            (
                <cfif len(arguments.EMPLOYEE_STATUS)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.EMPLOYEE_STATUS#">,</cfif>
                <cfif len(arguments.EMPLOYEE_NAME)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.EMPLOYEE_NAME#">,</cfif>
                <cfif len(arguments.EMPLOYEE_SURNAME)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.EMPLOYEE_SURNAME#">,</cfif>
                <cfif len(arguments.EMPLOYEE_EMAIL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.EMPLOYEE_EMAIL#"><cfelse>NULL</cfif>,
                <cfif len(arguments.EMPLOYEE_USERNAME)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.EMPLOYEE_USERNAME#">,</cfif>
                <cfif len(arguments.EMPLOYEE_PASSWORD)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sifreli#">,</cfif>
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.EMPLOYEE_NO#">,
                #now()#,
                #SESSION.EP.USERID#,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.EMPLOYEE_STAGE#">
            )
        </cfquery>
        <cfquery name="LAST_ID" datasource="#DSN#">
            SELECT MAX(EMPLOYEE_ID) AS LATEST_RECORD_ID FROM EMPLOYEES
        </cfquery>
        <cfreturn LAST_ID>
    </cffunction>

    <cffunction name="add_employee_detail" access="public" returntype="any">
        <cfargument name="EMPLOYEE_ID" default="">
        <cfargument name="SEX" default="">
        <cfargument name="employee_email_spc" default="">
        <cfquery name="ADD_EMPLOYEES_DETAIL" datasource="#DSN#">
            INSERT INTO 
                EMPLOYEES_DETAIL
            (
                EMPLOYEE_ID,
                SEX,
                EMAIL_SPC,
                RECORD_DATE,
                RECORD_EMP,
                RECORD_IP
            )
            VALUES
            (			
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.EMPLOYEE_ID#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.SEX#">,
                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.employee_email_spc#">,
                #now()#,
                #SESSION.EP.USERID#,
                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#CGI.REMOTE_ADDR#">
            )
        </cfquery>
    </cffunction>

    <cffunction name="upd_member_code_f" access="public" returntype="any">
        <cfargument name="EMPLOYEE_ID" default="">
        <cfquery name="UPD_MEMBER_CODE" datasource="#DSN#">
            UPDATE EMPLOYEES SET MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="E#arguments.EMPLOYEE_ID#"> WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.EMPLOYEE_ID#">
        </cfquery>
    </cffunction>

    <cffunction name="ADD_IDENTY_F" access="public" returntype="any">
        <cfargument name="EMPLOYEE_ID" default="">
        <cfargument name="TC_IDENTY_NO" default="">
        <cfquery name="ADD_IDENTY" datasource="#dsn#">
            INSERT INTO
                EMPLOYEES_IDENTY
            (
                EMPLOYEE_ID,
                TC_IDENTY_NO,
                RECORD_DATE,
                RECORD_IP,
                RECORD_EMP
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.EMPLOYEE_ID#">,	
                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.TC_IDENTY_NO#">,
                #now()#,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
                #session.ep.userid#
            )
        </cfquery>
        <cfquery name="add_healty" datasource="#DSN#">
            INSERT INTO
                EMPLOYEE_HEALTY
            (
                EMPLOYEE_ID,
                STATUS,
                RECORD_DATE,
                RECORD_EMP,
                RECORD_IP
            )
            VALUES
            (
                #arguments.EMPLOYEE_ID#,	
                1,
                #NOW()#,
                #SESSION.EP.USERID#,
                '#CGI.REMOTE_USER#'
            )
        </cfquery>
    </cffunction>

    <cffunction name="ADD_TIME_ZONE_F" access="public" returntype="any">
        <cfargument name="EMPLOYEE_ID" default="">
        <cfargument name="TIME_ZONE" default="">
        <cfargument name="LANGUAGE" default="">
        <cfargument name="DESIGN_ID" default="">
        <cfquery name="ADD_TIME_ZONE" datasource="#DSN#">
            INSERT INTO
                MY_SETTINGS
            (
                EMPLOYEE_ID,
                DAY_AGENDA,
                MAIN_NEWS,
                TIME_ZONE,
                LANGUAGE_ID,
                INTERFACE_ID,
                INTERFACE_COLOR,
                AGENDA,
                POLL_NOW,
                MYWORKS,
                MY_VALIDS,
                MY_BUYERS,
                MY_SELLERS,
                MAXROWS,
                TIMEOUT_LIMIT
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.EMPLOYEE_ID#">,
                1,
                1,
                <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.TIME_ZONE#">,
                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.LANGUAGE#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.DESIGN_ID#">,
                1,
                1,
                1,
                1,
                1,
                1,
                1,
                20,
                30
            )
        </cfquery>
    </cffunction>

    <cffunction name="UPD_GEN_PAP_F" access="public" returntype="any">
        <cfargument name="system_paper_no_add" default="">
        <cfquery name="UPD_GEN_PAP" datasource="#DSN#">
            UPDATE GENERAL_PAPERS_MAIN SET EMPLOYEE_NUMBER = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.system_paper_no_add#"> WHERE EMPLOYEE_NUMBER IS NOT NULL
        </cfquery>
    </cffunction>

    <cffunction name="pass_control" access="public" returntype="any">
        <cfquery name="GET_PASSWORD_STYLE" datasource="#DSN#">
            SELECT * FROM PASSWORD_CONTROL WHERE PASSWORD_STATUS = 1
        </cfquery>
        <cfreturn GET_PASSWORD_STYLE>
    </cffunction>
    <!--- End of Employee Functions --->

    <!--- Start of Position Functions --->
    <cffunction name="get_module" access="public" returntype="any">
        <cfquery  name="GET_MODULE_ID" datasource="#dsn#">
            SELECT MAX(MODULE_ID) AS MODULE_ID FROM MODULES ORDER BY MODULE_ID 
        </cfquery>
        <cfreturn GET_MODULE_ID>
    </cffunction>

    <cffunction name="get_upper" access="public" returntype="any">
        <cfargument name="department_id" default="">
        <cfquery name="get_uppers" datasource="#dsn#">
            SELECT 
                O.HIERARCHY AS HIE1,
                Z.HIERARCHY AS HIE2,
                O.HIERARCHY2 AS HIE3,
                B.HIERARCHY AS HIE4,
                D.HIERARCHY AS HIE5
            FROM
                DEPARTMENT D
                INNER JOIN BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
                INNER JOIN OUR_COMPANY O ON B.COMPANY_ID = O.COMP_ID
                INNER JOIN ZONE Z ON B.ZONE_ID = Z.ZONE_ID
            WHERE
                D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#">
        </cfquery>
        <cfreturn get_uppers>
    </cffunction>

    <cffunction name="get_pos_cat" access="public" returntype="any">
        <cfargument name="POSITION_CAT_ID" default="">
        <cfquery name="get_position_cat" datasource="#dsn#">
            SELECT HIERARCHY FROM SETUP_POSITION_CAT WHERE POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.POSITION_CAT_ID#">
        </cfquery>
        <cfreturn get_position_cat>
    </cffunction>

    <cffunction name="get_titles" access="public" returntype="any">
        <cfargument name="TITLE_ID" default="">
        <cfquery name="get_title" datasource="#dsn#">
            SELECT HIERARCHY,TITLE FROM SETUP_TITLE WHERE TITLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TITLE_ID#">
        </cfquery>
        <cfreturn get_title>
    </cffunction>

    <cffunction name="get_employee_name" access="public" returntype="any">
        <cfargument name="EMPLOYEE_ID" default="">
        <cfquery name="GET_EMP_NAME" datasource="#dsn#">
            SELECT * FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.EMPLOYEE_ID#">
        </cfquery>
        <cfreturn GET_EMP_NAME>
    </cffunction>

    <cffunction name="get_pos_max" access="public" returntype="any">
        <cfquery name="GET_MAX_POS" datasource="#dsn#">
			SELECT
				MAX(POSITION_CODE) AS PCODE
			FROM
				EMPLOYEE_POSITIONS
        </cfquery>
        <cfreturn GET_MAX_POS>
    </cffunction>

    <cffunction name="add_emp_pos" access="public" returntype="any">
        <cfargument name="pcode" default="">
        <cfargument name="position_cat_id" default="">
        <cfargument name="status" default="">
        <cfargument name="position_name" default="">
        <cfargument name="group_id1" default="">
        <cfargument name="employee_id" default="">
        <cfargument name="employee_name" default="">
        <cfargument name="employee_surname" default="">
        <cfargument name="employee_email_spc" default="">
        <cfargument name="department_id" default="">
        <cfargument name="title_id" default="">
        <cfargument name="new_hie_" default="">
        <cfargument name="process_stage2" default="">
        <cfquery name="ADD_POSITION" datasource="#dsn#">
			INSERT INTO
				EMPLOYEE_POSITIONS
				(
					POSITION_CODE,
					POSITION_CAT_ID,
					POSITION_STATUS,
					POSITION_NAME,
					<cfif len(arguments.GROUP_ID1)>USER_GROUP_ID,</cfif>
					EMPLOYEE_ID,
					EMPLOYEE_NAME,
					EMPLOYEE_SURNAME,
					EMPLOYEE_EMAIL,
					DEPARTMENT_ID,
					TITLE_ID,
					DYNAMIC_HIERARCHY,
					POSITION_STAGE,
                    IS_MASTER,
                    EHESAP,
                    IS_ORG_VIEW
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pcode#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_cat_id#">,
				    <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.status#">,
					<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.position_name#">,
					<cfif len(arguments.group_id1)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.group_id1#">,</cfif>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">,
					<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.employee_name#">,
					<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.employee_surname#">,
					<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.employee_email_spc#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.title_id#">,
					<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.new_hie_#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage2#">,
                    1,
                    0,
                    1
				)
        </cfquery>
        <cfquery name="GET_LAST_ID" datasource="#dsn#">
			SELECT MAX(POSITION_ID) AS POSITION_ID FROM EMPLOYEE_POSITIONS
        </cfquery>
        <cfreturn GET_LAST_ID>
    </cffunction>

    <cffunction name="ADD_USER_GROUP_PERM" access="public" returntype="any">
        <cfargument name="POSITION_ID" default="">
        <cfargument name="employee_id" default="">
        <cfargument name="group_id1" default="">
        <cfquery name="ADD_USER_GROUP_PERMISSION" datasource="#dsn#">
            INSERT INTO USER_GROUP_EMPLOYEE
            (
                POSITION_ID,
                EMPLOYEE_ID,
                USER_GROUP_ID
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.POSITION_ID#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.group_id1#">
            )
        </cfquery>
    </cffunction>
    <!--- End of Position Functions --->

    <!--- Start of Period Functions --->
    <cffunction name="get_position" access="public" returntype="any">
        <cfargument name="pos_id" default="">
        <cfquery name="GET_POS" datasource="#DSN#">
            SELECT
                LEVEL_ID,
                LEVEL_EXTRA_ID,
                USER_GROUP_ID,
                EMPLOYEE_ID
            FROM
                EMPLOYEE_POSITIONS
            WHERE
                POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pos_id#">
        </cfquery>
        <cfreturn GET_POS>
    </cffunction>

    <cffunction name="GET_POS_2" access="public" returntype="any">
        <cfargument name="employee_id" default="">
        <cfargument name="pos_id" default="">
        <cfargument name="group_id2" default="">
        <cfargument name="menu_id" default="">
        <cfargument name="emp_emp_ids" default="">
        <cfquery name="GET_POS2" datasource="#DSN#">
            DELETE FROM USER_GROUP_EMPLOYEE WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#"> AND POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pos_id#">
            INSERT INTO USER_GROUP_EMPLOYEE (EMPLOYEE_ID,POSITION_ID,USER_GROUP_ID) VALUES (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">,<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pos_id#">,<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.group_id2#">)
            UPDATE 
                EMPLOYEE_POSITIONS 
            SET
                USER_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.group_id2#">,
                WRK_MENU = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.menu_id#">
            WHERE 
                POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pos_id#">
            DELETE FROM WRK_SESSION WHERE USERID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#arguments.emp_emp_ids#">) AND USER_TYPE = 0
        </cfquery>
    </cffunction>

    <cffunction name="DEL_CONSUMER_PERIOD" access="public" returntype="any">
        <cfargument name="emp_pos_ids" default="">
        <cfquery name="DEL_CONSUMER_PERIODS" datasource="#DSN#">
            DELETE FROM
                EMPLOYEE_POSITION_PERIODS
            WHERE
                POSITION_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#arguments.emp_pos_ids#">)
        </cfquery>
    </cffunction>

    <cffunction name="UPD_CONSUMER_PERIODS" access="public" returntype="any">
        <cfargument name="period_default" default="">
        <cfargument name="emp_pos_ids" default="">
        <cfquery name="UPD_CONSUMER_PERIODS_DEFAULT" datasource="#DSN#">
			UPDATE
				EMPLOYEE_POSITIONS
			SET
				PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_default#">
			WHERE
				POSITION_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#arguments.emp_pos_ids#">)
		</cfquery>
    </cffunction>

    <cffunction name="UPD_POSITION_EMPLOYEE" access="public" returntype="any">
        <cfargument name="position_cat_id" default="">
        <cfargument name="status" default="">
        <cfargument name="employee_id" default="">
        <cfargument name="employee_name" default="">
        <cfargument name="employee_surname" default="">
        <cfargument name="employee_email_spc" default="">
        <cfargument name="department_id" default="">
        <cfargument name="title_id" default="">
        <cfargument name="process_stage2" default="">
        <cfquery name="UPD_POSITION_EMPLOYEE" datasource="#DSN#">
			UPDATE
				EMPLOYEE_POSITIONS
			SET
                POSITION_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_cat_id#">,
                POSITION_STATUS = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.status#">,
                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">,
                EMPLOYEE_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.employee_name#">,
                EMPLOYEE_SURNAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.employee_surname#">,
                EMPLOYEE_EMAIL = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.employee_email_spc#">,
                DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#">,
                TITLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.title_id#">,
                POSITION_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage2#">,
                IS_MASTER = 1
			WHERE
				POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_id#">
		</cfquery>
    </cffunction>

    <cffunction name="del_wrk_apps" access="public" returntype="any">
        <cfargument name="emp_emp_ids" default="">
        <cfquery name="del_wrk_app" datasource="#dsn#">
            DELETE FROM WRK_SESSION WHERE USERID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#arguments.emp_emp_ids#">) AND USER_TYPE = 0
        </cfquery>
    </cffunction>
    <!--- End of Period Functions --->
</cfcomponent>