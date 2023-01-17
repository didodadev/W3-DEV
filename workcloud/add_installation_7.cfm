<cfset getParameter = parameter.getParameter() />
<cfset dsn = getParameter.dsn />
<cftry>
    <cftransaction>
        <cf_cryptedpassword password="#attributes.employee_password#" output="userPassword" mod="1">
        <cfquery name="GETPOSCAT" datasource="#dsn#">
            SELECT * FROM SETUP_POSITION_CAT
        </cfquery>
        <cfif not GETPOSCAT.recordcount>
            <cfquery name="INSPOSITION" datasource="#dsn#">
                INSERT INTO SETUP_POSITION_CAT
                (
                    POSITION_CAT,
                    POSITION_CAT_DETAIL,
                    HIERARCHY,
                    POSITION_CAT_TYPE,
                    POSITION_CAT_UPPER_TYPE,
                    POSITION_CAT_STATUS,
                    RECORD_EMP,
                    RECORD_DATE,
                    RECORD_IP
                )
                VALUES 
                (
                    <cfqueryparam value = "#attributes.position_cat#" CFSQLType = "cf_sql_varchar">,
                    NULL,
                    NULL,
                    1,
                    1,
                    1,
                    1,
                    #NOW()#,
                    '#CGI.REMOTE_ADDR#'
                )
            </cfquery>
            <cfquery name="INSTITLE" datasource="#dsn#">
                INSERT INTO SETUP_TITLE
                (
                    IS_ACTIVE,
                    TITLE,
                    TITLE_DETAIL,
                    HIERARCHY,
                    RECORD_EMP,
                    RECORD_DATE,
                    RECORD_IP
                ) 
                VALUES 
                (
                    1,
                    <cfqueryparam value = "#attributes.employee_username#" CFSQLType = "cf_sql_varchar">,
                    NULL,
                    NULL,
                    1,
                    #NOW()#,
                    '#CGI.REMOTE_ADDR#'
                )
            </cfquery>
            <cfquery name="ADD_USER_GROUP" datasource="#dsn#">
                INSERT INTO USER_GROUP
                (
                    IS_DEFAULT,
                    USER_GROUP_NAME,			
                    USER_GROUP_PERMISSIONS,
                    USER_GROUP_PERMISSIONS_EXTRA,
                    POWERUSER,
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_IP
                )
                VALUES
                (
                    0,
                    'System Admin',
                    '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87',
                    NULL,
                    '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87',
                    #now()#,
                    1,
                    '#cgi.remote_addr#'
                ),
                (
                    1,
                    'Standart',
                    '6,8,10,29,43,45,80,81,82',
                    NULL,
                    NULL,
                    #now()#,
                    1,
                    '#cgi.remote_addr#'
                )
            </cfquery>
            <cfquery name="ADD_POSITION" datasource="#dsn#">
                INSERT INTO EMPLOYEE_POSITIONS
                (
                    PERIOD_ID,
                    ADMIN_STATUS,
                    LEVEL_ID,
                    POWER_USER_LEVEL_ID,
                    POWER_USER,
                    IN_COMPANY_REASON_ID,
                    POSITION_CODE,
                    POSITION_CAT_ID,
                    COLLAR_TYPE,
                    POSITION_STATUS,
                    POSITION_NAME,
                    DETAIL,
                    USER_GROUP_ID,
                    EMPLOYEE_ID,
                    EMPLOYEE_NAME,
                    EMPLOYEE_SURNAME,
                    EMPLOYEE_EMAIL,
                    ANNOUNCE_COM,
                    DEPARTMENT_ID,
                    EHESAP,
                    IS_VEKALETEN,
                    VEKALETEN_DATE,
                    TITLE_ID,
                    IS_CRITICAL,
                    ORGANIZATION_STEP_ID,
                    OZEL_KOD,
                    HIERARCHY,
                    DYNAMIC_HIERARCHY,
                    DYNAMIC_HIERARCHY_ADD,
                    IS_MASTER,
                    UPPER_POSITION_CODE,
                    UPPER_POSITION_CODE2,
                    IS_ORG_VIEW,
                    FUNC_ID
                )
                VALUES
                (
                    1,
                    1,
                    '1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1',
                    '1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1',
                    1,
                    NULL,
                    1,
                    1,
                    0,
                    1,	
                    '#attributes.position_cat#',
                    NULL,
                    1,
                    1,
                    'System',
                    'Admin',
                    <cfqueryparam value = "#attributes.employee_email#" CFSQLType = "cf_sql_nvarchar">,
                    0,
                    1,
                    1,
                    0,
                    NULL,
                    1,
                    1,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    1,
                    NULL,
                    NULL,
                    1,
                    NULL
                )
            </cfquery>
            <cfquery name="ADD_EMPLOYEES" datasource="#dsn#">
                INSERT INTO EMPLOYEES
                (
                    EMPLOYEE_NO,
                    EMPLOYEE_STATUS,
                    EMPLOYEE_NAME,
                    EMPLOYEE_SURNAME,
                    EMPLOYEE_EMAIL,
                    EMPLOYEE_USERNAME,
                    EMPLOYEE_PASSWORD,
                    RECORD_DATE, 
                    RECORD_EMP, 
                    RECORD_IP,
                    HIERARCHY,
                    OZEL_KOD2,
                    OZEL_KOD,
                    IN_COMPANY_REASON_ID,
                    CORBUS_TEL,
                    IS_CRITICAL,
                    EXPIRY_DATE,
                    MEMBER_CODE
                )
                VALUES
                (
                    'EMP-1',
                    1,
                    'System',
                    'Admin',
                    <cfqueryparam value = "#attributes.employee_email#" CFSQLType = "cf_sql_nvarchar">,
                    <cfqueryparam value = "#attributes.employee_username#" CFSQLType = "cf_sql_nvarchar">,
                    '#userPassword#',
                    #now()#,
                    1,
                    '#CGI.REMOTE_ADDR#',
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    1,
                    NULL,
                    'E1'
                )
            </cfquery>
            <cfquery name="ADD_EMPLOYEES_DETAIL" datasource="#dsn#">
                INSERT INTO EMPLOYEES_DETAIL
                (
                    EMPLOYEE_ID,
                    SEX,
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_IP
                )
                VALUES
                (			
                    1,
                    1,
                    #now()#,
                    1,
                    '#CGI.REMOTE_ADDR#'
                )
            </cfquery>
            <cfquery name="ADD_IDENTY" datasource="#dsn#">
                INSERT INTO EMPLOYEES_IDENTY
                (
                    EMPLOYEE_ID,
                    TC_IDENTY_NO,
                    RECORD_DATE,
                    RECORD_IP,
                    RECORD_EMP
                )
                VALUES
                (
                    1,	
                    '1',
                    #now()#,
                    '#cgi.REMOTE_ADDR#',
                    1
                )
            </cfquery>
            <cfquery name="ADD_TIME_ZONE" datasource="#dsn#">
                INSERT INTO MY_SETTINGS
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
                    1,
                    1,
                    1,
                    2,
                    'tr',
                    4,
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
            <cfset attributes.ini_employee_id = 1>
            <cfinclude template="../V16/myhome/query/initialize_menu_positions.cfm">
            <cfquery name="UPD_GEN_PAP" datasource="#dsn#">
                UPDATE GENERAL_PAPERS_MAIN SET EMPLOYEE_NUMBER = 1 WHERE EMPLOYEE_NUMBER IS NOT NULL
            </cfquery>
            <cfquery name="ADD_COMPANY_PERIODS" datasource="#dsn#">
                INSERT INTO EMPLOYEE_POSITION_PERIODS
                (
                    POSITION_ID,  
                    PERIOD_ID,
                    RECORD_EMP,
                    RECORD_DATE,
                    RECORD_IP
                )
                VALUES
                (
                    1,
                    1,
                    1,
                    #now()#,
                    '#cgi.remote_addr#' 			
                )	
            </cfquery>
            <cfquery name="add_employee_position_branches" datasource="#dsn#">
                INSERT INTO EMPLOYEE_POSITION_BRANCHES
                (
                    POSITION_CODE,
                    BRANCH_ID,
                    RECORD_EMP,
                    RECORD_DATE,
                    RECORD_IP
                )
                VALUES
                (
                    1,
                    1,
                    1,
                    #now()#,
                    '#cgi.remote_addr#'
                )
            </cfquery>
        </cfif>
    </cftransaction>
    <!--- Bilgiler networg.workcube.com üzerinden mail olark gönderilir --->
    <cfhttp url="https://networg.workcube.com/web_services/uhtil854o2018.cfc?method=SET_SUBSCRIPTION_INFORMATION" result="response" charset="utf-8">
        <cfhttpparam name="api_key" type="formfield" value="20180911HjPo356h">
        <cfhttpparam name="domain_address" type="formfield" value="#getParameter.employee_url#">
	    <cfhttpparam name="license_code" type="formfield" value="#getParameter.license_code#">
        <cfhttpparam name="employee_name" type="formfield" value="System">
        <cfhttpparam name="employee_surname" type="formfield" value="Admin">
        <cfhttpparam name="employee_email" type="formfield" value="#attributes.employee_email#">
        <cfhttpparam name="employee_username" type="formfield" value="#attributes.employee_username#">
        <cfhttpparam name="employee_password" type="formfield" value="#attributes.employee_password#">
        <cfhttpparam name="position_cat" type="formfield" value="#attributes.position_cat#">
    </cfhttp>
    <!--- <cfdump var = "#response#" abort> --->
    <cflocation url = "#installUrl#?installation_type=8" addToken = "no">
    <cfcatch type="any">
        There was a problem, when your user creating!
    </cfcatch>
</cftry>