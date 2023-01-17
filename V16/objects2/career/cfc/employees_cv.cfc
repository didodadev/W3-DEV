<cfcomponent extends="cfc.queryJSONConverter">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset upload_folder = application.systemParam.systemParam().upload_folder>
    <cfset dir_seperator = application.systemParam.systemParam().dir_seperator>

    <cfsavecontent variable="warning">
        <cf_get_lang dictionary_id='62565.Kayıt İşlemi Gerçekleşti, Yönlendiriliyorsunuz'>
    </cfsavecontent>
    
    <cffunction name="get_position" access="remote" returntype="query" output="no">
        <cfargument  name="employee_id" default="">
        <cfquery name="get_position" datasource="#dsn#">
            SELECT 
                EMPLOYEE_POSITIONS.POSITION_NAME,
                EMPLOYEE_POSITIONS.TITLE_ID,
                DEPARTMENT.DEPARTMENT_HEAD,
                BRANCH.BRANCH_NAME,
                OUR_COMPANY.COMPANY_NAME
            FROM
                EMPLOYEE_POSITIONS,
                DEPARTMENT,
                BRANCH,
                OUR_COMPANY
            WHERE
                EMPLOYEE_POSITIONS.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#"> AND
                EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
                BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID AND 
                BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID 
        </cfquery>
        <cfreturn get_position>
    </cffunction>

    <cffunction name="get_in_outs" access="remote" returntype="query" output="no">
        <cfargument  name="employee_id" default="">
        <cfquery name="get_in_outs" datasource="#dsn#" maxrows="1">
            SELECT 
                START_DATE,
                FINISH_DATE 
            FROM 
                EMPLOYEES_IN_OUT 
            WHERE 
                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
        </cfquery>
        <cfreturn get_in_outs>
    </cffunction>

    <cffunction name="contract" access="remote" returntype="query" output="no">
        <cfargument  name="employee_id" default="">
        <cfquery name="contract" datasource="#dsn#">
            SELECT 
                CONTRACT_DATE,
                CONTRACT_FINISHDATE
            FROM
                EMPLOYEES_CONTRACT
            WHERE
                EMPLOYEES_CONTRACT.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
        </cfquery>
        <cfreturn contract>
    </cffunction>

    <cffunction name="lang" access="remote" returntype="query" output="no">
        <cfargument  name="language_id" default="">
        <cfquery name="lang" datasource="#dsn#">
            SELECT 
                LANGUAGE_SET
            FROM 
                SETUP_LANGUAGES
            WHERE 
                LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.language_id#">
        </cfquery>
        <cfreturn lang>
    </cffunction>

    <cffunction name="get_TITLE" access="remote" returntype="query" output="no">
        <cfargument  name="title_id" default="">
        <cfquery name="get_TITLE" datasource="#dsn#">
            SELECT 
                TITLE_ID,
                TITLE
            FROM
                SETUP_TITLE
            WHERE
                TITLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.title_id#">
        </cfquery>
        <cfreturn get_TITLE>
    </cffunction>

    <cffunction name="get_edu_info" access="remote" returntype="query" output="no">
        <cfargument  name="employee_id" default="">
        <cfquery name="get_edu_info" datasource="#dsn#">
            SELECT
                *
            FROM
                EMPLOYEES_APP_EDU_INFO
            WHERE
                EDU_TYPE NOT IN (1,2) AND
                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
        </cfquery>
        <cfreturn get_edu_info>
    </cffunction>

    <cffunction name="egitim" access="remote" returntype="query" output="no">
        <cfargument  name="employee_id" default="">
        <cfquery name="egitim" datasource="#dsn#">
            SELECT
                EMP_ID,
                CLASS_ID
            FROM
                TRAINING_CLASS_ATTENDER
            WHERE 
                TRAINING_CLASS_ATTENDER.EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
        </cfquery>
        <cfreturn egitim>
    </cffunction>

    <cffunction name="get_trainer_class" access="remote" returntype="query" output="no">
        <cfargument  name="class_id" default="">
        <cfquery name="get_trainer_class" datasource="#dsn#">
            SELECT 
                TRAINING_CLASS.CLASS_NAME,
                TRAINING_CLASS.CLASS_TARGET,
                TRAINING_CLASS.START_DATE,
                TRAINING_CLASS.FINISH_DATE,
                TRAINING_CLASS.DATE_NO,
                TRAINING_CLASS.HOUR_NO,
                TRAINING_CLASS.TRAINER_EMP,
                EMPLOYEES.EMPLOYEE_NAME,
                EMPLOYEES.EMPLOYEE_SURNAME,
                TRAINING_CLASS.TRAINER_PAR,
                TRAINING_CLASS.TRAINER_CONS
            FROM
                TRAINING_CLASS,
                EMPLOYEES
            WHERE 
                TRAINING_CLASS.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.class_id#"> AND
                TRAINING_CLASS.TRAINER_EMP = EMPLOYEES.EMPLOYEE_ID   
        </cfquery>
        <cfreturn get_trainer_class>
    </cffunction>

    <cffunction name="get_trainer_par" access="remote" returntype="query" output="no">
        <cfargument  name="class_id" default="">
        <cfquery name="get_trainer_par" datasource="#dsn#">
            SELECT
                TRAINING_CLASS.TRAINER_PAR,
                COMPANY_PARTNER.COMPANY_PARTNER_NAME,
                COMPANY_PARTNER.COMPANY_PARTNER_SURNAME
            FROM
                TRAINING_CLASS,
                COMPANY,
                COMPANY_PARTNER
            WHERE
                TRAINING_CLASS.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.class_id#"> AND
                TRAINING_CLASS.TRAINER_PAR = COMPANY_PARTNER.PARTNER_ID AND
                COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID 
        </cfquery>
        <cfreturn get_trainer_par>
    </cffunction>

    <cffunction name="get_trainer_cons" access="remote" returntype="query" output="no">
        <cfargument  name="class_id" default="">
        <cfquery name="get_trainer_cons" datasource="#dsn#">
            SELECT
                TRAINING_CLASS.TRAINER_CONS,
                CONSUMER.CONSUMER_NAME,
                CONSUMER.CONSUMER_SURNAME
            FROM
                CONSUMER,
                TRAINING_CLASS
            WHERE
                TRAINING_CLASS.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.class_id#"> AND
                TRAINING_CLASS.TRAINER_CONS = CONSUMER.CONSUMER_ID
        </cfquery>
        <cfreturn get_trainer_cons>
    </cffunction>

    <cffunction name="emp_relatives" access="remote" returntype="query" output="no">
        <cfargument  name="employee_id" default="">
        <cfquery name="emp_relatives" datasource="#dsn#">
            SELECT
                RELATIVE_LEVEL,
                NAME,
                SURNAME,
                BIRTH_DATE,
                BIRTH_PLACE,
                TC_IDENTY_NO,
                EDUCATION,
                JOB,
                COMPANY,
                JOB_POSITION
            FROM
                EMPLOYEES_RELATIVES
            WHERE
                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.EMPLOYEE_ID#">
            ORDER BY
                BIRTH_DATE,NAME,SURNAME,RELATIVE_LEVEL
          </cfquery>
        <cfreturn emp_relatives>
    </cffunction>

    <cffunction name="pos_history" access="remote" returntype="query" output="no">
        <cfargument  name="employee_id" default="">
        <cfquery name="pos_history" datasource="#dsn#">
            SELECT 
                EMPLOYEE_POSITIONS_HISTORY.POSITION_NAME,
                EMPLOYEE_POSITIONS_HISTORY.START_DATE,
                EMPLOYEE_POSITIONS_HISTORY.FINISH_DATE,
                EMPLOYEE_POSITIONS_HISTORY.RECORD_DATE,
                OUR_COMPANY.NICK_NAME, 
                DEPARTMENT.DEPARTMENT_HEAD,
                BRANCH.BRANCH_NAME 
            FROM 
                EMPLOYEE_POSITIONS_HISTORY,
                OUR_COMPANY,
                DEPARTMENT ,
                BRANCH
            WHERE 
                EMPLOYEE_POSITIONS_HISTORY.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
                AND EMPLOYEE_POSITIONS_HISTORY.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
                AND DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
                AND BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID
            ORDER BY
                EMPLOYEE_POSITIONS_HISTORY.VALID_DATE DESC
        </cfquery>
        <cfreturn pos_history>
    </cffunction>

    <cffunction name="GET_EMPLOYEE" access="remote" returntype="query" output="no">
        <cfargument  name="employee_id" default="">
        <cfquery name="GET_EMPLOYEE" datasource="#dsn#">
            SELECT 
                EMPLOYEES.EMPLOYEE_NO,
                EMPLOYEES.EMPLOYEE_NAME, 
                EMPLOYEES.EMPLOYEE_SURNAME,
                EMPLOYEES.PHOTO,
                EMPLOYEES_DETAIL.LAST_SCHOOL,
                EMPLOYEES_IDENTY.BIRTH_DATE,
                EMPLOYEES_IDENTY.BIRTH_PLACE,
                EMPLOYEES_DETAIL.STARTDATE,
                EMPLOYEES_DETAIL.MILITARY_FINISHDATE,
                EMPLOYEES_DETAIL.MILITARY_DELAY_REASON,
                EMPLOYEES_DETAIL.MILITARY_DELAY_DATE,
                EMPLOYEES_DETAIL.MILITARY_STATUS,
                /* EMPLOYEES_DETAIL.DRIVER_LICENCE_TYPE,	 */
                EMPLOYEES_DETAIL.PARTNER_POSITION,
                EMPLOYEES_DETAIL.HOMEADDRESS,
                EMPLOYEES_DETAIL.HOMETEL,
                EMPLOYEES_DETAIL.HOMETEL_CODE,
                EMPLOYEES.MOBILCODE,
                EMPLOYEES.MOBILTEL,
                EMPLOYEES_DETAIL.HOMEPOSTCODE,
                EMPLOYEES_DETAIL.HOMECOUNTY,
                EMPLOYEES.GROUP_STARTDATE,
                EMPLOYEES_DETAIL.CHILD_0,
                EMPLOYEES.EMPLOYEE_ID,
                EMPLOYEES_DETAIL._LANG1,
                EMPLOYEES_DETAIL._LANG2,
                EMPLOYEES_DETAIL._LANG3,
                EMPLOYEES_DETAIL._LANG4,
                EMPLOYEES_DETAIL._LANG5,
                <!--- EMPLOYEES_DETAIL.EDU3,
                EMPLOYEES_DETAIL.EDU3_START,
                EMPLOYEES_DETAIL.EDU3_FINISH,
                EMPLOYEES_DETAIL.EDU3_RANK,
                EMPLOYEES_DETAIL.EDU3_PART,
                EMPLOYEES_DETAIL.EDU4_ID,
                EMPLOYEES_DETAIL.EDU4,
                EMPLOYEES_DETAIL.EDU4_PART,
                EMPLOYEES_DETAIL.EDU4_PART,
                EMPLOYEES_DETAIL.EDU4_START,
                EMPLOYEES_DETAIL.EDU4_FINISH,
                EMPLOYEES_DETAIL.EDU4_RANK,
                EMPLOYEES_DETAIL.EDU4_ID_2,
                EMPLOYEES_DETAIL.EDU4_START_2,
                EMPLOYEES_DETAIL.EDU4_FINISH_2,
                EMPLOYEES_DETAIL.EDU4_RANK_2,
                EMPLOYEES_DETAIL.EDU4_PART_ID,
                  EMPLOYEES_DETAIL.EDU4_PART_ID_2,
                EMPLOYEES_DETAIL.EDU5,
                EMPLOYEES_DETAIL.EDU5_PART,
                EMPLOYEES_DETAIL.EDU5_FINISH,
                EMPLOYEES_DETAIL.EDU5_START,
                EMPLOYEES_DETAIL.EDU5_RANK,
                EMPLOYEES_DETAIL.EDU6,
                EMPLOYEES_DETAIL.EDU7,
                 EMPLOYEES_DETAIL.EDU7_PART,
                EMPLOYEES_DETAIL.EDU7_START,
                EMPLOYEES_DETAIL.EDU7_FINISH, --->
                EMPLOYEES_DETAIL.HOMECITY,
                EMPLOYEES_DETAIL.HOMECOUNTRY,
                EMPLOYEES_DETAIL.DEFECTED_LEVEL,
                EMPLOYEES_DETAIL.DEFECTED,
                EMPLOYEES_IDENTY.MARRIED
            FROM 
                EMPLOYEES, 
                EMPLOYEES_DETAIL,
                EMPLOYEES_IDENTY
            WHERE 
                EMPLOYEES.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#"> AND 
                EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_DETAIL.EMPLOYEE_ID AND
                EMPLOYEES_IDENTY.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID 
        </cfquery>
        <cfreturn GET_EMPLOYEE>
    </cffunction>
</cfcomponent>