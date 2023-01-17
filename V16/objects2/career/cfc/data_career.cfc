<cfcomponent extends="cfc.queryJSONConverter">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset upload_folder = application.systemParam.systemParam().upload_folder>
    <cfset dir_seperator = application.systemParam.systemParam().dir_seperator>

    <cfsavecontent variable="warning">
        <cf_get_lang dictionary_id='62565.Kayıt İşlemi Gerçekleşti, Yönlendiriliyorsunuz'>
    </cfsavecontent>

    <cffunction name="GET_ID_CARD_CATS" access="remote" returntype="query" output="no">
        <cfquery name="GET_ID_CARD_CATS" datasource="#DSN#">
            SELECT IDENTYCAT_ID, IDENTYCAT FROM SETUP_IDENTYCARD
        </cfquery>
        <cfreturn GET_ID_CARD_CATS>
    </cffunction>

    <cffunction name="GET_COUNTRY" access="remote" returntype="query" output="no">
        <cfargument  name="county_id" default="">
        <cfquery name="GET_COUNTRY" datasource="#DSN#">
            SELECT 
                COUNTRY_ID, 
                COUNTRY_NAME, 
                IS_DEFAULT 
            FROM 
                SETUP_COUNTRY 
            WHERE
                1 = 1
                <cfif len(arguments.county_id)>
                    and COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.county_id#"> 
                </cfif>
            ORDER BY COUNTRY_NAME
        </cfquery>
        <cfreturn GET_COUNTRY>
    </cffunction>

    <cffunction name="GET_COMPANIES" access="remote" returntype="query" output="no">
        <cfargument  name="company_id" default="">
        <cfquery name="GET_COMPANIES" datasource="#DSN#">
            SELECT 
                COMP_ID, 
                COMPANY_NAME, 
                ASSET_FILE_NAME2, 
                ASSET_FILE_NAME2_SERVER_ID,
                NICK_NAME,
                ASSET_FILE_NAME3
            FROM 
                OUR_COMPANY
            WHERE
                1 = 1
                <cfif len(arguments.company_id)>
                    AND COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
                </cfif>
        </cfquery>
        
        <cfreturn GET_COMPANIES>
    </cffunction>

    <cffunction name="GET_POSITIONS" access="remote" returntype="query" output="no">
        <cfquery name="GET_POSITIONS" datasource="#DSN#">	
            SELECT POSITION_ID, POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE POSITION_STATUS = 1
        </cfquery>
        <cfreturn GET_POSITIONS>
    </cffunction>
    
    <cffunction name="GET_CITY" access="remote" returntype="query" output="no">
        <cfargument  name="county_id" default="">
        <cfargument  name="city_id" default="">
        <cfargument  name="keyword" default="">
        <cfquery name="GET_CITY" datasource="#DSN#">
            SELECT 
                *
            FROM 
                SETUP_CITY 
            WHERE
                1 = 1
            <cfif len(arguments.county_id)>
                AND COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.county_id#">
            </cfif>
            <cfif len(arguments.city_id)>
                AND CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.city_id#">
            </cfif>
            <cfif len(arguments.keyword)>
                AND CITY_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#%">
            </cfif>
            ORDER BY CITY_NAME
        </cfquery>
        <cfreturn GET_CITY>
    </cffunction>

    <cffunction name="GET_APP" access="remote" returntype="query" output="no">
        <cfargument  name="empapp_id" default="#session.cp.userid#">

        <cfquery name="GET_APP" datasource="#DSN#">
            SELECT
                *
            FROM
                EMPLOYEES_APP
            WHERE
                <cfif isdefined("arguments.empapp_id") and len(arguments.empapp_id)>
                    EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.empapp_id#">
                <cfelse>
                    1=0
                </cfif>
        </cfquery>
        <cfreturn GET_APP>
    </cffunction>

    <cffunction name="GET_MOBILCAT" access="remote" returntype="query" output="no">
        <cfquery name="GET_MOBILCAT" datasource="#DSN#">
            SELECT 
                MOBILCAT_ID, 
                MOBILCAT 
            FROM 
                SETUP_MOBILCAT
            ORDER BY
                MOBILCAT
        </cfquery>
        <cfreturn GET_MOBILCAT>
    </cffunction>
    
   <cffunction name="get_app_identy" access="remote" returntype="query" output="no">
        <cfquery name="GET_APP_IDENTY" datasource="#DSN#">
            SELECT
                *
            FROM
                EMPLOYEES_IDENTY
            WHERE
                <cfif isdefined("session.cp.userid")>
                    EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
                <cfelse>
                    EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
                </cfif>	
        </cfquery>
    
        <cfreturn get_app_identy>
    </cffunction>

    <cffunction name="GET_IM" access="remote" returntype="query" output="no">
        <cfquery name="GET_IM" datasource="#DSN#">
            SELECT 
                IMCAT_ID, 
                IMCAT 
            FROM 
                SETUP_IM
        </cfquery>
        <cfreturn GET_IM>
    </cffunction>

    <cffunction name="GET_EDU_LEVEL" access="remote" returntype="query" output="no">
        <cfargument  name="edu_level_id" default="">
        <cfquery name="GET_EDU_LEVEL" datasource="#DSN#">
            SELECT 
                EDU_LEVEL_ID, 
                EDUCATION_NAME 
            FROM 
                SETUP_EDUCATION_LEVEL
            WHERE 
                1 = 1
                <cfif len(arguments.edu_level_id)>
                    AND EDU_LEVEL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.edu_level_id#">
                </cfif>
        </cfquery>
        <cfreturn GET_EDU_LEVEL>
    </cffunction>

    <cffunction name="KNOW_LEVELS" access="remote" returntype="query" output="no">
        <cfquery name="KNOW_LEVELS" datasource="#DSN#">
            SELECT KNOWLEVEL_ID, KNOWLEVEL FROM SETUP_KNOWLEVEL
        </cfquery>
        <cfreturn KNOW_LEVELS>
    </cffunction>

    <cffunction name="GET_SCHOOL" access="remote" returntype="query" output="no">
        <cfquery name="GET_SCHOOL" datasource="#DSN#">
            SELECT SCHOOL_ID, SCHOOL_NAME FROM SETUP_SCHOOL ORDER BY SCHOOL_NAME
        </cfquery>
        <cfreturn GET_SCHOOL>
    </cffunction>
    
    <cffunction name="GET_SCHOOL_PART" access="remote" returntype="query" output="no">
        <cfquery name="GET_SCHOOL_PART" datasource="#DSN#">
            SELECT PART_ID, PART_NAME FROM SETUP_SCHOOL_PART ORDER BY PART_NAME
        </cfquery>
        <cfreturn GET_SCHOOL_PART>
    </cffunction>
    
   <cffunction name="GET_HIGH_SCHOOL_PART" access="remote" returntype="query" output="no">
        <cfquery name="GET_HIGH_SCHOOL_PART" datasource="#DSN#">
            SELECT HIGH_PART_ID, HIGH_PART_NAME FROM SETUP_HIGH_SCHOOL_PART ORDER BY HIGH_PART_NAME
        </cfquery>
        <cfreturn GET_HIGH_SCHOOL_PART>
    </cffunction>
    
    <cffunction name="GET_LANGUAGES" access="remote" returntype="query" output="no">
        <cfquery name="GET_LANGUAGES" datasource="#DSN#">
            SELECT LANGUAGE_ID,LANGUAGE_SET FROM SETUP_LANGUAGES
        </cfquery>        
        <cfreturn GET_LANGUAGES>
    </cffunction>

    <cffunction name="GET_DRIVER_LIS" access="remote" returntype="query" output="no">
        <cfargument  name="licensecat_id" default="">
        <cfquery name="GET_DRIVER_LIS" datasource="#DSN#">
            SELECT 
                LICENCECAT_ID,
                LICENCECAT 
            FROM 
                SETUP_DRIVERLICENCE 
            <cfif len(licensecat_id)>
                WHERE
                    LICENCECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.licencecat_id#">
            </cfif>
            ORDER BY LICENCECAT
        </cfquery>    
        <cfreturn GET_DRIVER_LIS>
    </cffunction>

    <cffunction name="GET_EMP_COURSE" access="remote" returntype="query" output="no">
        <cfquery name="GET_EMP_COURSE" datasource="#DSN#">
            SELECT 
                EMPAPP_ID,
                COURSE_SUBJECT,
                COURSE_LOCATION,
                COURSE_EXPLANATION,
                COURSE_YEAR,
                COURSE_PERIOD
            FROM 
                EMPLOYEES_COURSE 
            WHERE 
                EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
        </cfquery>     
        <cfreturn GET_EMP_COURSE>
    </cffunction>
    
    <cffunction name="GET_EDU_INFO" access="remote" returntype="query" output="no">
        <cfargument  name="type" default="">
        <cfargument  name="empapp_id" default="#session.cp.userid#">
        <cfquery name="GET_EDU_INFO" datasource="#DSN#">
            SELECT
                EDU_TYPE,
                EMPAPP_EDU_ROW_ID,
                EDU_ID,
                EDU_START,
                EDU_FINISH,
                EDU_RANK,
                EDU_PART_ID,
                IS_EDU_CONTINUE,
                EDU_NAME,
                EDU_PART_NAME
            FROM
                EMPLOYEES_APP_EDU_INFO
            WHERE
                <cfif isdefined("arguments.empapp_id") and len(arguments.empapp_id)>
                    EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.empapp_id#">
                    <cfif len(arguments.type)>
                        AND EDU_TYPE IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.type#" list="yes">)
                    </cfif>
                <cfelse>
                     1=0
                </cfif>
        </cfquery>
        <cfreturn GET_EDU_INFO>
    </cffunction>

    <cffunction name="GET_APP_LANG" access="remote" returntype="query" output="no">
        <cfquery name="GET_APP_LANG" datasource="#DSN#">
            SELECT
                ID,
                LANG_ID,
                LANG_SPEAK,
                LANG_MEAN,
                LANG_WRITE,
                LANG_WHERE
            FROM
                EMPLOYEES_APP_LANGUAGE
            WHERE
                EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
        </cfquery>      
        <cfreturn GET_APP_LANG>
    </cffunction>

    <cffunction name="GET_PARTNER_POSITIONS" access="remote" returntype="query" output="no">
        <cfquery name="GET_PARTNER_POSITIONS" datasource="#dsn#">
            SELECT * FROM SETUP_PARTNER_POSITION ORDER BY PARTNER_POSITION
        </cfquery>
        <cfreturn GET_PARTNER_POSITIONS>
    </cffunction>

    <cffunction name="GET_RELATIVES" access="remote" returntype="query" output="no">
        <cfargument  name="empapp_id" default="#session.cp.userid#">
        <cfquery name="GET_RELATIVES" datasource="#DSN#">
            SELECT 
                NAME, SURNAME, RELATIVE_LEVEL, RELATIVE_ID 
            FROM 
                EMPLOYEES_RELATIVES 
            WHERE 
                EMPAPP_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.empapp_id#"> ORDER BY BIRTH_DATE, NAME, SURNAME, RELATIVE_LEVEL
        </cfquery>
        <cfreturn GET_RELATIVES>
    </cffunction>

    <cffunction name="GET_EMP_REFERENCE" access="remote" returntype="query" output="no">
        <cfquery name="GET_EMP_REFERENCE" datasource="#DSN#">
            SELECT EMPAPP_ID, REFERENCE_TYPE, REFERENCE_NAME, REFERENCE_COMPANY, REFERENCE_TELCODE, REFERENCE_TEL, REFERENCE_POSITION, REFERENCE_EMAIL FROM EMPLOYEES_REFERENCE WHERE EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
        </cfquery>
        <cfreturn GET_EMP_REFERENCE>
    </cffunction>

    <cffunction name="get_reference_type" access="remote" returntype="query" output="no">
        <cfquery name="get_reference_type" datasource="#dsn#">
            SELECT REFERENCE_TYPE_ID,REFERENCE_TYPE FROM SETUP_REFERENCE_TYPE
        </cfquery>
        <cfreturn get_reference_type>
    </cffunction>

    <cffunction name="GET_WORK_INFO" access="remote" returntype="query" output="no">
        <cfargument  name="empapp_id" default="#session.cp.userid#">
        <cfquery name="GET_WORK_INFO" datasource="#DSN#">
            SELECT
                *
            FROM
                EMPLOYEES_APP_WORK_INFO
            WHERE
                EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.empapp_id#">
        </cfquery>
        <cfreturn GET_WORK_INFO>
    </cffunction>

    <cffunction name="GET_APP_UNIT" access="remote" returntype="query" output="no">
        <cfargument  name="empapp_id" default="#session.cp.userid#">
        <cfquery name="GET_APP_UNIT" datasource="#DSN#"> 
            SELECT UNIT_ID,UNIT_ROW FROM EMPLOYEES_APP_UNIT WHERE EMPAPP_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.empapp_id#">
        </cfquery>
        <cfreturn GET_APP_UNIT>
    </cffunction>

    <cffunction name="GET_CV_UNIT" access="remote" returntype="query" output="no">
        <cfquery name="GET_CV_UNIT" datasource="#DSN#">
            SELECT UNIT_ID, UNIT_NAME FROM SETUP_CV_UNIT WHERE IS_VIEW = 1
        </cfquery>
        <cfreturn GET_CV_UNIT>
    </cffunction>

    <cffunction name="GET_CV_UNIT_MAX" access="remote" returntype="query" output="no">
        <cfquery name="GET_CV_UNIT_MAX" datasource="#DSN#">
            SELECT MAX(UNIT_ID) AS MAX_ID FROM SETUP_CV_UNIT
        </cfquery>
        <cfreturn GET_CV_UNIT_MAX>
    </cffunction>

    <cffunction name="GET_TEACHER_INFO" access="remote" returntype="query" output="no">
        <cfquery name="GET_TEACHER_INFO" datasource="#DSN#">
            SELECT * FROM EMPLOYEES_APP_TEACHER_INFO WHERE EMPAPP_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
        </cfquery>
        <cfreturn GET_TEACHER_INFO>
    </cffunction>

    <cffunction name="GET_ADD_INFO" access="remote" returntype="query" output="no">
        <cfquery name="GET_ADD_INFO" datasource="#DSN#">
            SELECT 
                BRANCHES_ID, 
                BRANCHES_ROW_ID, 
                BRANCHES_ROW_OTHER 
            FROM 
                EMPLOYEES_APP_INFO 
            WHERE 
                EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
        </cfquery>
        <cfreturn GET_ADD_INFO>
    </cffunction>

    <cffunction name="GET_ADD_INFO_WITH_BRANCH" access="remote" returntype="query" output="no">
        <cfargument  name="emppapp_id" default="#session.cp.userid#">
        <cfquery name="GET_ADD_INFO_WITH_BRANCH" datasource="#DSN#">
            SELECT 
                SPP.BRANCHES_ID
            FROM 
                EMPLOYEES_APP_INFO EP,
                SETUP_APP_BRANCHES_ROWS SPP
            WHERE 
                EP.BRANCHES_ROW_ID = SPP.BRANCHES_ROW_ID AND
                <cfif isdefined("arguments.emppapp_id") and len(arguments.emppapp_id)>
                    EP.EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.emppapp_id#">
                <cfelse>
                    1=0
                </cfif>
        </cfquery>
        <cfreturn GET_ADD_INFO_WITH_BRANCH>
    </cffunction>

    <cffunction name="GET_BRANCHES_ROWS" access="remote" returntype="query" output="no">
        <cfargument  name="branches_id" default="">
        <cfquery name="GET_BRANCHES_ROWS" datasource="#DSN#">
            SELECT BRANCHES_ROW_ID, BRANCHES_NAME_ROW FROM SETUP_APP_BRANCHES_ROWS WHERE BRANCHES_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branches_id#"> AND BRANCHES_STATUS_ROW = 1
        </cfquery>
        <cfreturn GET_BRANCHES_ROWS>
    </cffunction>

    <cffunction name="GET_ASSET" access="remote" returntype="query" output="no">
        <cfargument  name="empapp_id" default="#session.cp.userid#">
        <cfquery name="GET_ASSET" datasource="#DSN#">
            SELECT
                ASSET_ID,
                ASSET_DETAIL,
                ASSET_FILE_NAME
            FROM
                ASSET
            WHERE
                ASSET.ACTION_SECTION = 'EMPLOYEES_APP_ID' AND
                ASSET.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.empapp_id#"> AND
                ASSET.RECORD_PUB = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.empapp_id#">
        </cfquery>
        <cfreturn GET_ASSET>
    </cffunction>

    <cffunction name="GET_EMPAPP_MAIL" access="remote" returntype="query" output="no">
        <cfargument  name="empapp_id" default="#session.cp.userid#">
        <cfargument  name="app_pos_id" default="#session.cp.userid#">
        <cfquery name="GET_EMPAPP_MAIL" datasource="#DSN#">
            SELECT 
                * 
            FROM 
                EMPLOYEES_APP_MAILS 
            WHERE 
                EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.EMPAPP_ID#"> 
                AND APP_POS_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.app_pos_id#"> 
                AND LIST_ID IS NULL
        </cfquery>
        <cfreturn GET_EMPAPP_MAIL>
    </cffunction>

    <cffunction name="MOBIL_CATS" access="remote" returntype="query" output="no">
        <cfquery name="MOBIL_CATS" datasource="#DSN#">
            SELECT MOBILCAT FROM SETUP_MOBILCAT ORDER BY MOBILCAT
        </cfquery>
        <cfreturn MOBIL_CATS>
    </cffunction>

    <cffunction name="GET_SECTOR" access="remote" returntype="query" output="no">
        <cfquery name="GET_SECTOR" datasource="#DSN#">
            SELECT SECTOR_CAT_ID,SECTOR_CAT FROM SETUP_SECTOR_CATS ORDER BY SECTOR_CAT_ID
        </cfquery>
        <cfreturn GET_SECTOR>
    </cffunction>

    <cffunction name="GET_TASK" access="remote" returntype="query" output="no">
        <cfargument  name="partner_pos_id" default="">
        <cfquery name="GET_TASK" datasource="#DSN#">
            SELECT 
                PARTNER_POSITION_ID,PARTNER_POSITION 
            FROM 
                SETUP_PARTNER_POSITION 
            WHERE
                1 = 1
                <cfif len(arguments.partner_pos_id)>
                    PARTNER_POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_pos_id#">
                </cfif>
            ORDER BY PARTNER_POSITION_ID
        </cfquery>
        <cfreturn GET_TASK>
    </cffunction>
    
    <cffunction name="GET_BRANCH" access="remote" returntype="query" output="no">
        <cfargument  name="branch_list" default="">
        <cfquery name="GET_BRANCH" datasource="#DSN#">
            SELECT BRANCH_ID, BRANCH_NAME, BRANCH_CITY FROM BRANCH WHERE IS_INTERNET = 1 <cfif len(arguments.branch_list)>AND  BRANCH_ID IN (#branch_list#)</cfif> 
        </cfquery>
        <cfreturn GET_BRANCH>
    </cffunction>

    <cffunction name="GET_COMPUTER_INFO" access="remote" returntype="query" output="no">
        <cfargument  name="comp_edu_list" default="">
        <cfquery name="GET_COMPUTER_INFO" datasource="#DSN#">
            SELECT 
                COMPUTER_INFO_ID, COMPUTER_INFO_NAME 
            FROM 
                SETUP_COMPUTER_INFO 
            WHERE 
                COMPUTER_INFO_STATUS = 1
                <cfif len(arguments.comp_edu_list)>
                    AND COMPUTER_INFO_ID IN (#comp_edu_list#)
                </cfif>
        </cfquery>
        <cfreturn GET_COMPUTER_INFO>
    </cffunction>

    <cffunction name="FIRE_REASONS" access="remote" returntype="query" output="no">
        <cfquery name="FIRE_REASONS" datasource="#DSN#">
            SELECT REASON_ID, REASON FROM SETUP_EMPLOYEE_FIRE_REASONS ORDER BY REASON
        </cfquery>
        <cfreturn FIRE_REASONS>
    </cffunction>

    <cffunction name="GET_BRANCHES" access="remote" returntype="query" output="no">
        <cfquery name="GET_BRANCHES" datasource="#DSN#">
            SELECT BRANCHES_ID, BRANCHES_ROW_TYPE, BRANCHES_NAME FROM SETUP_APP_BRANCHES WHERE BRANCHES_STATUS = 1 ORDER BY BRANCHES_ROW_LINE 
        </cfquery>
        <cfreturn GET_BRANCHES>
    </cffunction>

    <cffunction name="GET_COUNTY" access="remote" returntype="query" output="no">
        <cfargument  name="city" default="">
        <cfargument  name="county_id" default="">
        <cfquery name="GET_COUNTY" datasource="#DSN#">
            SELECT 
                COUNTY_ID, 
                COUNTY_NAME 
            FROM 
                SETUP_COUNTY 
            WHERE 
                1 = 1
                <cfif len(arguments.city)>
                   and CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.city#">
                </cfif>
                <cfif len(arguments.county_id)>
                   and  COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.county_id#">
                </cfif>
        </cfquery>
        <cfreturn GET_COUNTY>
    </cffunction>

    <cffunction name="GET_COUNTY_WITH_CITY" access="remote" returntype="query" output="no">
        <cfargument  name="city_id" default="">
        <cfargument  name="keyword" default="">
        <cfquery name="GET_COUNTY_WITH_CITY" datasource="#dsn#">
            SELECT
                SC.COUNTY_ID,
                SC.COUNTY_NAME,
                S.CITY_NAME
            FROM
                SETUP_COUNTY SC,
                SETUP_CITY S
            WHERE
                SC.CITY = S.CITY_ID
                <cfif isdefined("arguments.city_id") and len(arguments.city_id)>AND SC.CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.city_id#"></cfif>
                <cfif len(arguments.keyword)>AND SC.COUNTY_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"></cfif>
            ORDER BY
                SC.COUNTY_NAME
        </cfquery>
        <cfreturn GET_COUNTY_WITH_CITY>
    </cffunction>

    <cffunction name="GET_MONEYS" access="remote" returntype="query" output="no">
        <cfargument  name="period_id" default="#session.cp.period_id#">
        <cfquery name="GET_MONEYS" datasource="#DSN#">
            SELECT
                MONEY_ID,
                MONEY
            FROM
                SETUP_MONEY
            WHERE
                PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_id#">
        </cfquery>
        <cfreturn GET_MONEYS>
    </cffunction>

    <cffunction name="GET_COMMETHODS" access="remote" returntype="query" output="no">
        <cfquery name="GET_COMMETHODS" datasource="#dsn#">
            SELECT * FROM SETUP_COMMETHOD ORDER BY COMMETHOD
        </cfquery>
        <cfreturn GET_COMMETHODS>
    </cffunction>

    <cfset result = StructNew()>
    <!--- Özgeçmişim / Kimlik ve İletişim Bilgileri (Stage : 1) --->
    <cffunction name="add_cv_1" access="public" returntype="string" returnformat="json">
        <cftry>       
            <cfif len(arguments.empapp_password)>
                <cf_cryptedpassword password="#arguments.empapp_password#" output="sifre">
            </cfif>
            <cfif len(arguments.birth_date)>
                <cf_date tarih="arguments.birth_date">
            <cfelse>
                <cfset arguments.birth_date = "NULL">
            </cfif>
            <cfquery name="UPD_CV_1" datasource="#DSN#">
                UPDATE 
                    EMPLOYEES_APP
                SET
                    NAME = '#arguments.emp_name#',
                    SURNAME = '#arguments.emp_surname#',
                    WORKTELCODE = <cfif len(arguments.worktelcode)>'#arguments.worktelcode#'<cfelse>NULL</cfif>,
                    WORKTEL = <cfif len(arguments.worktel)>'#arguments.worktel#'<cfelse>NULL</cfif>,
                    EMAIL = <cfif len(arguments.email)>'#arguments.email#'<cfelse>NULL</cfif>,
                    MOBILCODE = <cfif len(arguments.mobilcode)>'#arguments.mobilcode#'<cfelse>NULL</cfif>,
                    MOBIL = <cfif len(arguments.mobil)> '#arguments.mobil#'<cfelse>NULL</cfif>,
                    MOBILCODE2 = <cfif len(arguments.mobilcode2)>'#arguments.mobilcode2#'<cfelse>NULL</cfif>,
                    MOBIL2 = <cfif len(arguments.mobil2)> '#arguments.mobil2#'<cfelse>NULL</cfif>,
                    HOMETELCODE = <cfif len(arguments.hometelcode)>'#arguments.hometelcode#'<cfelse>NULL</cfif>,
                    HOMETEL = <cfif len(arguments.hometel)>'#arguments.hometel#'<cfelse>NULL</cfif>,
                    HOMEADDRESS = '#arguments.homeaddress#',
                    HOMEPOSTCODE = '#arguments.homepostcode#',
                    HOMECOUNTY = '#arguments.homecounty#',
                    <cfif len(arguments.empapp_password)>EMPAPP_PASSWORD ='#sifre#',</cfif>
                    HOMECITY=<cfif len(arguments.homecity)>#arguments.homecity#<cfelse>NULL</cfif>,
                    HOMECOUNTRY = <cfif len(arguments.homecountry)>#arguments.homecountry#<cfelse>NULL</cfif>,
                    HOME_STATUS = <cfif isdefined('arguments.home_status') and len(arguments.home_status)>#arguments.home_status#<cfelse>NULL</cfif>,
                    EXTENSION = <cfif len(arguments.extension)> '#arguments.extension#'<cfelse>NULL</cfif>,
                    TAX_OFFICE = <cfif len(arguments.tax_office)>'#arguments.tax_office#'<cfelse>NULL</cfif>,
                    TAX_NUMBER = <cfif len(arguments.tax_number)>#arguments.tax_number#<cfelse>NULL</cfif>,
                    NATIONALITY = <cfif isdefined('arguments.nationality') and len(arguments.nationality)>#arguments.nationality#,<cfelse>NULL,</cfif>
                    IDENTYCARD_CAT = <cfif len(arguments.identycard_cat)>#arguments.identycard_cat#<cfelse>NULL</cfif>, 
                    IMCAT_ID = <cfif len(arguments.imcat_id)>#arguments.imcat_id#<cfelse>NULL</cfif>,
                    IM = <cfif len(arguments.im)>'#arguments.im#'<cfelse>NULL</cfif>,
                    IDENTYCARD_NO = <cfif len(arguments.identycard_no)>'#arguments.identycard_no#'<cfelse>NULL</cfif>,
                    UPDATE_DATE = NULL,
                    UPDATE_IP = NULL,
                    UPDATE_EMP = NULL,
                    UPDATE_APP_DATE = #now()#,
                    UPDATE_APP_IP = '#cgi.remote_addr#',
                    UPDATE_APP = #session.cp.userid#
                WHERE
                    EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
            </cfquery>
        
            <cfquery name="UPD_IDENTY_1" datasource="#DSN#">
                UPDATE
                    EMPLOYEES_IDENTY
                SET
                    TC_IDENTY_NO = '#arguments.tc_identy_no#',
                    BIRTH_DATE = <cfif len(arguments.birth_date)>#arguments.birth_date#<cfelse>NULL</cfif>,
                    BIRTH_PLACE = '#arguments.birth_place#',
                    CITY = <cfif len(arguments.city)>'#arguments.city#'<cfelse>NULL</cfif>,
                    UPDATE_DATE = #now()#,
                    UPDATE_IP = '#cgi.remote_addr#'
                WHERE
                    EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
            </cfquery>          
            <cfset result.status = true>
            <cfset result.success_message = warning>
            <cfset result.identity = "">
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
                <cfset result.error = cfcatch >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <!--- Özgeçmişim / Kişisel Bilgilerim (Stage : 2) --->
    <cffunction name="add_cv_2" access="public" returntype="string" returnformat="json">
        <cftry>
            <cfif len(arguments.military_finishdate)>
                <cf_date tarih="arguments.military_finishdate">
            <cfelse>
                <cfset arguments.military_finishdate = "NULL">
            </cfif>
            
            <cfif len(arguments.military_delay_date)>
                <cf_date tarih="arguments.military_delay_date">
            <cfelse>
                <cfset arguments.military_delay_date = "NULL">
            </cfif>
            <cfif len(arguments.licence_start_date)>
                <cf_date tarih="arguments.licence_start_date">
            <cfelse>
                <cfset arguments.licence_start_date = "NULL">
            </cfif>
        
            <cfquery name="UPD_CV_2" datasource="#DSN#">
                UPDATE 
                    EMPLOYEES_APP
                SET
                <cfif isdefined("arguments.defected")>
                    DEFECTED = #arguments.defected#,
                    <cfif isdefined('arguments.defected_level')>DEFECTED_LEVEL=#arguments.defected_level#,</cfif>
                <cfelse>
                    DEFECTED = 0,
                    DEFECTED_LEVEL = 0,
                </cfif>
                <cfif isDefined("arguments.sentenced")>
                    SENTENCED = #arguments.sentenced#,
                <cfelse>
                    SENTENCED = 0,
                </cfif>
                    <cfif isdefined("arguments.sex") and len(arguments.sex)>SEX = #arguments.sex#<cfelse>SEX = 0</cfif>,
                    MILITARY_STATUS = <cfif isdefined("arguments.military_status") and len(arguments.military_status)>#arguments.military_status#<cfelse>0</cfif>,
                    MILITARY_DELAY_REASON = <cfif isdefined("arguments.military_status") and arguments.military_status eq 4>'#arguments.military_delay_reason#'<cfelse>NULL</cfif>,
                    MILITARY_DELAY_DATE = <cfif isdefined("arguments.military_status") and arguments.military_status eq 4 and len(arguments.military_delay_date)>#arguments.military_delay_date#<cfelse>NULL</cfif>,
                    MILITARY_FINISHDATE = <cfif isdefined("arguments.military_status") and arguments.military_status eq 1 and len(arguments.military_finishdate)>#arguments.military_finishdate#<cfelse>NULL</cfif>,
                    MILITARY_EXEMPT_DETAIL = <cfif isdefined("arguments.military_status") and len(arguments.military_exempt_detail) and arguments.military_status eq 2>'#arguments.military_exempt_detail#'<cfelse>NULL</cfif>,
                    MILITARY_MONTH = <cfif isdefined("arguments.military_status") and arguments.military_status eq 1 and len(arguments.military_month)>#arguments.military_month#<cfelse>NULL</cfif>,
                    MILITARY_RANK = <cfif isdefined("arguments.military_status") and arguments.military_status eq 1 and isdefined('arguments.military_rank')>#arguments.military_rank#<cfelse>NULL</cfif>,
                    USE_CIGARETTE = <cfif isdefined('arguments.use_cigarette') and len(arguments.use_cigarette)>#arguments.use_cigarette#<cfelse>NULL</cfif>,
                    IMMIGRANT = <cfif isdefined('arguments.immigrant') and len(arguments.immigrant)>#arguments.immigrant#<cfelse>NULL</cfif>,
                    DEFECTED_PROBABILITY = <cfif isdefined('arguments.defected_probability') and len(arguments.defected_probability)>#arguments.defected_probability#<cfelse>NULL</cfif>,
                    MARTYR_RELATIVE = <cfif isdefined('arguments.martyr_relative') and len(arguments.martyr_relative)>#arguments.martyr_relative#<cfelse>NULL</cfif>,
                    PARTNER_COMPANY = '#arguments.partner_company#',
                    PARTNER_NAME = <cfif isdefined('arguments.partner_name') and len(arguments.partner_name)>'#arguments.partner_name#',<cfelse>NULL,</cfif>
                    PARTNER_POSITION = <cfif isdefined('arguments.partner_position') and len(arguments.partner_position)>'#arguments.partner_position#',<cfelse>NULL,</cfif>
                    LICENCE_START_DATE = <cfif isdefined('arguments.licence_start_date') and len(arguments.licence_start_date)>#arguments.licence_start_date#<cfelse>NULL</cfif>,
                    LICENCECAT_ID = <cfif isdefined('arguments.driver_licence_type') and  len(arguments.driver_licence_type)>#arguments.driver_licence_type#<cfelse>NULL</cfif>,
                    DRIVER_LICENCE_ACTIVED = <cfif  isdefined('arguments.driver_licence_actived') and  len(arguments.driver_licence_actived)>#arguments.driver_licence_actived#,<cfelse>NULL,</cfif>
                    INVESTIGATION = <cfif isdefined('arguments.investigation') and len(arguments.investigation)>'#arguments.investigation#'<cfelse>NULL</cfif>,
                    ILLNESS_PROBABILITY = <cfif isdefined("arguments.illness_probability") and len(arguments.illness_probability)>#arguments.illness_probability#,<cfelse>0,</cfif>  	
                       ILLNESS_DETAIL = <cfif isdefined("arguments.illness_detail") and len(arguments.illness_detail)>'#arguments.illness_detail#',<cfelse>NULL,</cfif>
                    SURGICAL_OPERATION = <cfif isdefined("arguments.surgical_operation") and len(arguments.surgical_operation)>'#arguments.surgical_operation#',<cfelse>NULL,</cfif>
                    CHILD = <cfif isdefined("arguments.child") and len(arguments.child)>#arguments.child#<cfelse> NULL</cfif>,
                    DRIVER_LICENCE = <cfif isdefined("arguments.driver_licence") and len(arguments.driver_licence)>'#arguments.driver_licence#'<cfelse>NULL</cfif>,
                    UPDATE_DATE = NULL,
                    UPDATE_IP = NULL,
                    UPDATE_EMP = NULL,
                    UPDATE_APP_DATE = #now()#,
                    UPDATE_APP_IP = '#cgi.remote_addr#',
                    UPDATE_APP = #session.cp.userid#
                WHERE
                    EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
            </cfquery>
            <cfif not isdefined("arguments.married")>
                <cfset arguments.married = 0>
            </cfif>
            <cfquery name="UPD_IDENTY_2" datasource="#DSN#">
                UPDATE
                    EMPLOYEES_IDENTY
                SET
                    MARRIED = <cfif isdefined("arguments.married") and len(arguments.married)>#arguments.married#<cfelse>NULL</cfif>,
                    UPDATE_DATE = #now()#,
                    UPDATE_IP = '#cgi.REMOTE_ADDR#'
                WHERE
                    EMPAPP_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
            </cfquery>
            <cfset result.status = true>
            <cfset result.success_message = warning>
            <cfset result.identity = "">
        <cfcatch type="any">
            <cfset result.status = false>
            <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
            <cfset result.error = cfcatch >
        </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <!--- Özgeçmişim / Diğer Kimlik Bilgilerim (Stage : 3) --->
    <cffunction name="add_cv_3" access="public" returntype="string" returnformat="json">
        <cftry>
            <cfif len(arguments.given_date)>
                <cf_date tarih="arguments.given_date">
            </cfif>
            <cfquery name="UPD_IDENTY" datasource="#DSN#">
                UPDATE 
                    EMPLOYEES_IDENTY
                SET
                    SERIES = <cfif len(arguments.series)>'#arguments.series#',<cfelse>NULL,</cfif>
                    NUMBER = <cfif len(arguments.number)>'#arguments.number#',<cfelse>NULL,</cfif>
                    BLOOD_TYPE = <cfif len(arguments.blood_type)>#arguments.blood_type#,<cfelse>NULL,</cfif> 
                    FATHER = <cfif len(arguments.father)>'#arguments.father#',<cfelse>NULL,</cfif> 
                    MOTHER = <cfif len(arguments.mother)>'#arguments.mother#',<cfelse>NULL,</cfif> 
                    LAST_SURNAME = <cfif len(arguments.last_surname)>'#arguments.last_surname#',<cfelse>NULL,</cfif> 
                    RELIGION = <cfif len(arguments.religion)>'#arguments.religion#',<cfelse>NULL,</cfif>  
                    COUNTY = <cfif len(arguments.county)>'#arguments.county#',<cfelse>NULL,</cfif>  
                    BINDING = <cfif len(arguments.binding)>'#arguments.binding#',<cfelse>NULL,</cfif> 
                    WARD = <cfif len(arguments.ward)>'#arguments.ward#',<cfelse>NULL,</cfif> 
                    FAMILY = <cfif len(arguments.family)>'#arguments.family#',<cfelse>NULL,</cfif> 
                    VILLAGE = <cfif len(arguments.village)>'#arguments.village#',<cfelse>NULL,</cfif> 
                    GIVEN_PLACE = <cfif len(arguments.given_place)>'#arguments.given_place#',<cfelse>NULL,</cfif> 
                    GIVEN_DATE = <cfif len(arguments.given_date)>#arguments.given_date#,<cfelse>NULL,</cfif> 
                    GIVEN_REASON = <cfif len(arguments.given_reason)>'#arguments.given_reason#',<cfelse>NULL,</cfif> 
                    RECORD_NUMBER = <cfif len(arguments.record_number)>'#arguments.record_number#',<cfelse>NULL,</cfif> 
                    FATHER_JOB = <cfif len(arguments.father_job)>'#arguments.father_job#',<cfelse>NULL,</cfif>
                    MOTHER_JOB = <cfif len(arguments.mother_job)>'#arguments.mother_job#',<cfelse>NULL,</cfif>
                    CUE = <cfif len(arguments.cue)>'#arguments.cue#'<cfelse>NULL</cfif>  
                WHERE 
                    EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
            </cfquery>
            <cfset result.status = true>
            <cfset result.success_message = warning>
            <cfset result.identity = "">
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
                <cfset result.error = cfcatch >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <!--- Özgeçmişim / Eğitim Bilgilerim (Stage:4) --->
    <cffunction name="add_cv_4" access="public" returntype="string" returnformat="json">
        <cftry>
            <cfset GET_TEACHER_INFO = this.GET_TEACHER_INFO()>
            
            <cfif get_teacher_info.recordcount and len(get_teacher_info.COMPUTER_EDUCATION)>
                <cfset comp_edu_list = listsort(get_teacher_info.COMPUTER_EDUCATION,"numeric","ASC",",")>
            </cfif>
            <cfif isdefined('arguments.comp_exp') and len(arguments.comp_exp)>
                <cfif get_teacher_info.recordcount>
                    <cfif len(get_teacher_info.COMPUTER_EDUCATION)>
                        <cfset comp_edu_list=listappend(comp_edu_list,-1)>
                        <cfquery name="UPD_TEACHER_INFO" datasource="#dsn#">
                            UPDATE
                                EMPLOYEES_APP_TEACHER_INFO
                            SET
                                COMPUTER_EDUCATION = ',#comp_edu_list#,'
                            WHERE
                                 EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
                        </cfquery>
                    </cfif>
                <cfelse>
                    <cfquery name="ADD_TEACHER_INFO" datasource="#dsn#">
                        INSERT INTO 
                            EMPLOYEES_APP_TEACHER_INFO
                        (
                            EMPAPP_ID,
                            COMPUTER_EDUCATION
                        )
                        VALUES
                        (
                            #session.cp.userid#,
                            ',-1,'
                        )
                    </cfquery>
                </cfif>
            <cfelseif not len(arguments.comp_exp) and get_teacher_info.recordcount and len(get_teacher_info.COMPUTER_EDUCATION) and listfind(comp_edu_list,-1,',')>
                <cfset comp_edu_list=listdeleteat(comp_edu_list,listfindnocase(comp_edu_list,-1))>
                <cfquery name="UPD_TEACHER_INFO" datasource="#dsn#">
                    UPDATE
                        EMPLOYEES_APP_TEACHER_INFO
                    SET
                        COMPUTER_EDUCATION = ',#comp_edu_list#,'
                    WHERE
                         EMPAPP_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
                </cfquery>
            </cfif>
            <cfquery name="upd_cv_3" datasource="#dsn#">
                UPDATE 
                    EMPLOYEES_APP
                SET
                    TRAINING_LEVEL=<cfif isdefined("arguments.training_level") and len(arguments.training_level)>#arguments.training_level#<cfelse>NULL</cfif>,
                    <cfif isdefined('arguments.lang1') and len(arguments.lang1)>
                        _LANG1 = #arguments.lang1#,
                        _LANG1_SPEAK = #arguments.lang1_speak#,
                        _LANG1_MEAN = #arguments.lang1_mean#,
                        _LANG1_WRITE = #arguments.lang1_write#,
                        _LANG1_WHERE = '#arguments.lang1_where#',
                    <cfelse>
                        _LANG1 =NULL,
                        _LANG1_SPEAK =NULL,
                        _LANG1_MEAN =NULL,
                        _LANG1_WRITE =NULL,
                        _LANG1_WHERE = NULL,
                    </cfif>
                    <cfif isdefined('arguments.lang2') and len(arguments.lang2)>
                        _LANG2 = #arguments.lang2#,
                        _LANG2_SPEAK = #arguments.lang2_speak#,
                        _LANG2_MEAN = #arguments.lang2_mean#,
                        _LANG2_WRITE = #arguments.lang2_write#,
                        _LANG2_WHERE = '#arguments.lang2_where#',
                    <cfelse>
                        _LANG2 =NULL,
                        _LANG2_SPEAK =NULL,
                        _LANG2_MEAN =NULL,
                        _LANG2_WRITE =NULL,
                        _LANG2_WHERE = NULL,
                    </cfif>
                    <cfif isdefined('arguments.lang3') and len(arguments.lang3)>
                        _LANG3 = #arguments.lang3#,
                        _LANG3_SPEAK = #arguments.lang3_speak#,
                        _LANG3_MEAN = #arguments.lang3_mean#,
                        _LANG3_WRITE = #arguments.lang3_write#,
                        _LANG3_WHERE = '#arguments.lang3_where#',
                    <cfelse>
                        _LANG3 =NULL,
                        _LANG3_SPEAK =NULL,
                        _LANG3_MEAN =NULL,
                        _LANG3_WRITE =NULL,
                        _LANG3_WHERE = NULL,
                    </cfif>
                    <cfif isdefined('arguments.lang4') and len(arguments.lang4)>
                        _LANG4 = #arguments.lang4#,
                        _LANG4_SPEAK = #arguments.lang4_speak#,
                        _LANG4_MEAN = #arguments.lang4_mean#,
                        _LANG4_WRITE = #arguments.lang4_write#,
                        _LANG4_WHERE = '#arguments.lang4_where#',
                    <cfelse>
                        _LANG4 =NULL,
                        _LANG4_SPEAK =NULL,
                        _LANG4_MEAN =NULL,
                        _LANG4_WRITE =NULL,
                        _LANG4_WHERE = NULL,
                    </cfif>
                    <cfif isdefined('arguments.lang5') and len(arguments.lang5)>
                        _LANG5 = #arguments.lang5#,
                        _LANG5_SPEAK = #arguments.lang5_speak#,
                        _LANG5_MEAN = #arguments.lang5_mean#,
                        _LANG5_WRITE = #arguments.lang5_write#,
                        _LANG5_WHERE = '#arguments.lang5_where#',
                    <cfelse>
                        _LANG5 =NULL,
                        _LANG5_SPEAK =NULL,
                        _LANG5_MEAN =NULL,
                        _LANG5_WRITE =NULL,
                        _LANG5_WHERE = NULL,
                    </cfif>
                    COMP_EXP=<cfif len(arguments.comp_exp)>'#arguments.comp_exp#'<cfelse>NULL</cfif>,
                    UPDATE_DATE = NULL,
                    UPDATE_IP = NULL,
                    UPDATE_EMP = NULL,
                    UPDATE_APP_DATE = #now()#,
                    UPDATE_APP_IP = '#cgi.remote_addr#',
                    UPDATE_APP = #session.cp.userid#
                WHERE
                    EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
            </cfquery>
            <!--- Eğitim Bilgileri --->
                <cfloop from="1" to="#arguments.row_edu#" index="j">
                    <cfif isdefined("arguments.row_kontrol_edu#j#") and evaluate("arguments.row_kontrol_edu#j#")>
                        <cfif isdefined("arguments.edu_high_part_id#j#") and  len(evaluate('arguments.edu_high_part_id#j#'))  and evaluate('arguments.edu_type#j#') eq 3>
                            <cfset bolum_id = evaluate('arguments.edu_high_part_id#j#')>
                        <cfelseif isdefined("arguments.edu_part_id#j#") and len(evaluate('arguments.edu_part_id#j#')) >
                            <cfset bolum_id = evaluate('arguments.edu_part_id#j#')>
                        <cfelse>
                            <cfset bolum_id = -1>
                        </cfif>
                        <cfif isDefined("arguments.empapp_edu_row_id#j#") and len(evaluate("arguments.empapp_edu_row_id#j#"))>
                            <cfquery name="UPD_EMPLOYEES_APP_EDU_INFO" datasource="#DSN#">
                                    UPDATE
                                        EMPLOYEES_APP_EDU_INFO
                                    SET
                                        EDU_TYPE = #evaluate('arguments.edu_type#j#')#,
                                        EDU_ID = <cfif isdefined("arguments.edu_id#j#") and len(evaluate('arguments.edu_id#j#'))>#evaluate('arguments.edu_id#j#')#<cfelse>-1</cfif>,
                                        EDU_NAME = <cfif isdefined("arguments.edu_name#j#") and len(evaluate('arguments.edu_name#j#'))>'#evaluate('arguments.edu_name#j#')#'<cfelse>NULL</cfif>,
                                        EDU_PART_ID = <cfif isdefined("bolum_id") and len(bolum_id)>#bolum_id#<cfelse>NULL</cfif>,
                                        EDU_PART_NAME = <cfif isdefined("arguments.edu_part_name#j#") and len(evaluate('arguments.edu_part_name#j#'))>'#evaluate('arguments.edu_part_name#j#')#'<cfelse>NULL</cfif>,
                                        EDU_START = <cfif isdefined("arguments.edu_start#j#") and len(evaluate('arguments.edu_start#j#'))>#evaluate('arguments.edu_start#j#')#<cfelse>NULL</cfif>,
                                        EDU_FINISH = <cfif isdefined("arguments.edu_finish#j#") and len(evaluate('arguments.edu_finish#j#'))>#evaluate('arguments.edu_finish#j#')#<cfelse>NULL</cfif>,
                                        EDU_RANK = <cfif isdefined("arguments.edu_rank#j#") and len(evaluate('arguments.edu_rank#j#'))>'#evaluate('arguments.edu_rank#j#')#'<cfelse>NULL</cfif>,
                                        EMPAPP_ID = #session.cp.userid#,
                                        IS_EDU_CONTINUE= <cfif isdefined("arguments.is_edu_continue#j#") and evaluate('arguments.is_edu_continue#j#') eq 1>1<cfelse>0</cfif>
                                    WHERE
                                        EMPAPP_EDU_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("arguments.empapp_edu_row_id#j#")#">
                            </cfquery>
                        <cfelse>
                            <cfquery name="ADD_EMPLOYEES_APP_EDU_INFO" datasource="#dsn#">
                                INSERT INTO
                                    EMPLOYEES_APP_EDU_INFO
                                (
                                    EMPAPP_ID,
                                    EDU_TYPE,
                                    EDU_ID,
                                    EDU_NAME,
                                    EDU_PART_ID,
                                    EDU_PART_NAME,
                                    EDU_START,
                                    EDU_FINISH,
                                    EDU_RANK,
                                    IS_EDU_CONTINUE
                                )
                                VALUES
                                (
                                    #session.cp.userid#,
                                    #evaluate('arguments.edu_type#j#')#,
                                    <cfif isdefined("arguments.edu_id#j#") and len(evaluate('arguments.edu_id#j#'))>#evaluate('arguments.edu_id#j#')#<cfelse>-1</cfif>,
                                    <cfif isdefined("arguments.edu_name#j#") and len(evaluate('arguments.edu_name#j#'))>'#evaluate('arguments.edu_name#j#')#'<cfelse>NULL</cfif>,
                                    <cfif isdefined("bolum_id") and len(bolum_id)>#bolum_id#<cfelse>NULL</cfif>,
                                    <cfif isdefined("arguments.edu_part_name#j#") and len(evaluate('arguments.edu_part_name#j#'))>'#evaluate('arguments.edu_part_name#j#')#'<cfelse>NULL</cfif>,
                                    <cfif isdefined("arguments.edu_start#j#") and len(evaluate('arguments.edu_start#j#'))>#evaluate('arguments.edu_start#j#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined("arguments.edu_finish#j#") and len(evaluate('arguments.edu_finish#j#'))>#evaluate('arguments.edu_finish#j#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined("arguments.edu_rank#j#") and len(evaluate('arguments.edu_rank#j#'))>'#evaluate('arguments.edu_rank#j#')#'<cfelse>NULL</cfif>,
                                    <cfif isdefined("arguments.is_edu_continue#j#") and evaluate('arguments.is_edu_continue#j#') eq 1>1<cfelse>0</cfif>
                                )
                            </cfquery>
                        </cfif>
                    <cfelse>
                        <cfif isDefined("arguments.empapp_edu_row_id#j#") and len(evaluate("arguments.empapp_edu_row_id#j#"))>
                            <cfquery name="del_empapp_edu_info" datasource="#dsn#">
                                DELETE FROM
                                    EMPLOYEES_APP_EDU_INFO
                                WHERE
                                    EMPAPP_EDU_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("arguments.empapp_edu_row_id#j#")#">
                            </cfquery>
                        </cfif>
                    </cfif>
                </cfloop>
                <!--- Eğitim Bilgileri --->
                <cfquery name="DELETE_EMP_COUR" datasource="#DSN#">
                    DELETE EMPLOYEES_COURSE WHERE EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
                </cfquery>
            <cfloop from="1" to="#arguments.extra_course#" index="z">
                <cfif isdefined('arguments.del_course_prog#z#') and  evaluate('arguments.del_course_prog#z#') eq 1><!--- silinmemiş ise.. --->
                    <cfif len(evaluate('arguments.kurs1_yil#z#')) and len(evaluate('arguments.kurs1_#z#'))>
                        <cfquery name="add_employees_course" datasource="#dsn#">
                            INSERT 
                            INTO
                                EMPLOYEES_COURSE
                             (
                                EMPAPP_ID,
                                EMPLOYEE_ID,
                                COURSE_SUBJECT,
                                COURSE_EXPLANATION,
                                COURSE_YEAR,
                                COURSE_LOCATION,
                                COURSE_PERIOD
                             )
                             VALUES
                             (
                                #session.cp.userid#,
                                NULL,
                                '#evaluate('arguments.kurs1_#z#')#',
                                '#evaluate('arguments.kurs1_exp#z#')#',
                                {ts '#evaluate('arguments.kurs1_yil#z#')#-01-01 00:00:00'},
                                '#evaluate('arguments.kurs1_yer#z#')#',
                                '#evaluate('arguments.kurs1_gun#z#')#'
                             )
                        </cfquery>
                    </cfif>
                </cfif>
            </cfloop>
            <cfset result.status = true>
            <cfset result.success_message = warning>
            <cfset result.identity = "">
        <cfcatch type="any">
            <cfset result.status = false>
            <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
            <cfset result.error = cfcatch >
            <cfdump var="#cfcatch#">
        </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <!--- Özgeçmişim / İş Tecrübelerim (Stage: 5) --->
    <cffunction name="add_cv_5" access="public" returntype="string" returnformat="json">
        <cftry>
            <cfif not isdefined("arguments.is_exp")><!---tecrübe yok şeçilmediyse ise--->
                <!--- İş Tecrübeleri --->
                <cfloop from="1" to="#arguments.row_count#" index="k">
                    <cfif isdefined("arguments.row_kontrol#k#") and evaluate("arguments.row_kontrol#k#")>
                        <cfif isdate(evaluate('arguments.exp_start#k#'))>
                            <cfset arguments.exp_start=evaluate('arguments.exp_start#k#')>
                            <cf_date tarih="arguments.exp_start">
                        <cfelse>
                            <cfset arguments.exp_start="">
                        </cfif>
                        <cfif isdate(evaluate('arguments.exp_finish#k#'))>
                            <cfset arguments.exp_finish=evaluate('arguments.exp_finish#k#')>
                            <cf_date tarih="arguments.exp_finish">
                        <cfelse>
                            <cfset arguments.exp_finish="">
                        </cfif>
                        <cfif len(arguments.exp_start) gt 9 and len(arguments.exp_finish) gt 9>
                               <cfset arguments.exp_fark = datediff("d",arguments.exp_start,arguments.exp_finish)>
                        <cfelse>
                            <cfset arguments.exp_fark="">
                        </cfif>
                        <cfif isDefined("arguments.empapp_row_id#k#") and len(evaluate("arguments.empapp_row_id#k#"))>
                            <cfset exp_name_ = evaluate("arguments.exp_name#k#")>
                            <cfquery name="UPD_EMPLOYEES_APP_WORK_INFO" datasource="#DSN#">
                                UPDATE
                                    EMPLOYEES_APP_WORK_INFO
                                SET
                                    EXP = <cfif len(exp_name_)>'#exp_name_#'<cfelse>NULL</cfif>,
                                    <!--- FS 20080805 tirnak hatasi veriyordu bu sekilde duzenledim, sorun ortadan kalkti
                                    EXP = <cfif len(evaluate('arguments.exp_name#k#'))>'#wrk_eval('arguments.exp_name#k#')#'<cfelse>NULL</cfif>, --->
                                    EXP_POSITION = <cfif len(evaluate('arguments.exp_position#k#'))>'#wrk_eval('arguments.exp_position#k#')#'<cfelse>NULL</cfif>,
                                    EXP_START = <cfif isdate(arguments.exp_start)>#arguments.exp_start#<cfelse>NULL</cfif>,
                                    EXP_FINISH = <cfif isdate(arguments.exp_finish)>#arguments.exp_finish#<cfelse>NULL</cfif>,
                                    EXP_FARK = <cfif len(arguments.exp_fark)>#arguments.exp_fark#<cfelse>NULL</cfif>,
                                    EXP_REASON = <cfif len(evaluate('arguments.exp_reason#k#'))>'#Replace(evaluate('arguments.exp_reason#k#'),"'"," ","all")#'<cfelse>NULL</cfif>,
                                    EXP_EXTRA = <cfif len(evaluate('arguments.exp_extra#k#'))>'#Replace(evaluate('arguments.exp_extra#k#'),"'"," ","all")#'<cfelse>NULL</cfif>,
                                    EXP_TELCODE = <cfif len(evaluate('arguments.exp_telcode#k#'))>'#wrk_eval('arguments.exp_telcode#k#')#'<cfelse>NULL</cfif>,
                                    EXP_TEL = <cfif len(evaluate('arguments.exp_tel#k#'))>'#wrk_eval('arguments.exp_tel#k#')#'<cfelse>NULL</cfif>,
                                    EXP_SECTOR_CAT= <cfif len(evaluate('arguments.exp_sector_cat#k#'))>#evaluate('arguments.exp_sector_cat#k#')#<cfelse>NULL</cfif>,
                                    EXP_MONEY_TYPE = <cfif len(evaluate('arguments.exp_money_type#k#')) and evaluate('arguments.exp_money_type#k#') gt 0>'#evaluate('arguments.exp_money_type#k#')#'<cfelse>NULL</cfif>,
                                    EXP_SALARY = <cfif len(evaluate('arguments.exp_salary#k#')) and evaluate('arguments.exp_salary#k#') gt 0>#evaluate('arguments.exp_salary#k#')#<cfelse>NULL</cfif>,
                                    EXP_EXTRA_SALARY = <cfif len(evaluate('arguments.exp_extra_salary#k#')) and evaluate('arguments.exp_extra_salary#k#') gt 0>'#wrk_eval('arguments.exp_extra_salary#k#')#'<cfelse>NULL</cfif>,
                                    EXP_TASK_ID = <cfif len(evaluate('arguments.exp_task_id#k#'))>#evaluate('arguments.exp_task_id#k#')#<cfelse>NULL</cfif>,
                                    EMPAPP_ID = #session.cp.userid#,
                                    IS_CONT_WORK= <cfif isdefined("arguments.is_cont_work#k#") and evaluate('arguments.is_cont_work#k#') eq 1>1<cfelse>0</cfif>
                                WHERE
                                    EMPAPP_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("arguments.empapp_row_id#k#")#">
                            </cfquery>
                        <cfelse>
                            <cfset exp_name_ = evaluate("arguments.exp_name#k#")>
                            <cfquery name="ADD_EMPLOYEES_APP_WORK_INFO" datasource="#DSN#">
                                INSERT INTO
                                    EMPLOYEES_APP_WORK_INFO
                                (
                                    EMPAPP_ID,
                                    EXP,
                                    EXP_POSITION,
                                    EXP_START,
                                    EXP_FINISH,
                                    EXP_FARK,
                                    EXP_REASON,
                                    EXP_EXTRA,
                                    EXP_TELCODE,
                                    EXP_TEL,
                                    EXP_SECTOR_CAT,
                                    EXP_MONEY_TYPE,
                                    EXP_SALARY,
                                    EXP_EXTRA_SALARY,
                                    EXP_TASK_ID,
                                    IS_CONT_WORK
                                )
                                VALUES
                                (
                                    #session.cp.userid#,
                                    <cfif len(exp_name_)>'#exp_name_#'<cfelse>NULL</cfif>,
                                    <!--- <cfif len(evaluate('arguments.exp_name#k#'))>'#wrk_eval('arguments.exp_name#k#')#'<cfelse>NULL</cfif>, --->
                                    <cfif len(evaluate('arguments.exp_position#k#'))>'#wrk_eval('arguments.exp_position#k#')#'<cfelse>NULL</cfif>,
                                    <cfif isdate(arguments.exp_start)>#arguments.exp_start#<cfelse>NULL</cfif>,
                                    <cfif isdate(arguments.exp_finish)>#arguments.exp_finish#<cfelse>NULL</cfif>,
                                    <cfif len(arguments.exp_fark)>#arguments.exp_fark#<cfelse>NULL</cfif>,
                                    <cfif len(evaluate('arguments.exp_reason#k#'))>'#Replace(evaluate('arguments.exp_reason#k#'),"'"," ","all")#'<cfelse>NULL</cfif>,
                                    <cfif len(evaluate('arguments.exp_extra#k#'))>'#Replace(evaluate('arguments.exp_extra#k#'),"'"," ","all")#'<cfelse>NULL</cfif>,
                                    <cfif len(evaluate('arguments.exp_telcode#k#'))>'#wrk_eval('arguments.exp_telcode#k#')#'<cfelse>NULL</cfif>,
                                    <cfif len(evaluate('arguments.exp_tel#k#'))>'#wrk_eval('arguments.exp_tel#k#')#'<cfelse>NULL</cfif>,			
                                    <cfif len(evaluate('arguments.exp_sector_cat#k#'))>#evaluate('arguments.exp_sector_cat#k#')#<cfelse>NULL</cfif>,
                                    <cfif len(evaluate('arguments.exp_money_type#k#')) and evaluate('arguments.exp_money_type#k#') gt 0>'#evaluate('arguments.exp_money_type#k#')#'<cfelse>NULL</cfif>,
                                    <cfif len(evaluate('arguments.exp_salary#k#')) and evaluate('arguments.exp_salary#k#') gt 0>#evaluate('arguments.exp_salary#k#')#<cfelse>NULL</cfif>,
                                    <cfif len(evaluate('arguments.exp_extra_salary#k#')) and evaluate('arguments.exp_extra_salary#k#') gt 0>'#wrk_eval('arguments.exp_extra_salary#k#')#'<cfelse>NULL</cfif>,
                                    <cfif len(evaluate('arguments.exp_task_id#k#'))>#evaluate('arguments.exp_task_id#k#')#<cfelse>NULL</cfif>,
                                    <cfif isdefined("arguments.is_cont_work#k#") and evaluate('arguments.is_cont_work#k#') eq 1>1<cfelse>0</cfif>
                                )
                            </cfquery>
                        </cfif>
                    <cfelse>
                        <cfif isDefined("arguments.empapp_row_id#k#") and len(evaluate("arguments.empapp_row_id#k#"))>
                            <cfquery name="DEL_EMPAPP_WORK_INFO" datasource="#DSN#">
                                DELETE FROM
                                    EMPLOYEES_APP_WORK_INFO
                                WHERE
                                    EMPAPP_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("arguments.empapp_row_id#k#")#">
                            </cfquery>
                        </cfif>
                     </cfif>
                </cfloop>
                <cfquery name="DELETE_EMP_REFERENCE" datasource="#DSN#">
                    DELETE EMPLOYEES_REFERENCE WHERE EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
                </cfquery>		
                <cfloop from="1" to="#arguments.add_ref_info#" index="r">
                    <cfif isdefined('arguments.del_ref_info#r#') and  evaluate('arguments.del_ref_info#r#') eq 1><!--- silinmemiş ise.. --->
                        <cfquery name="ADD_EMPLOYEES_REFERENCE" datasource="#DSN#">
                            INSERT INTO
                                EMPLOYEES_REFERENCE
                                 (
                                    EMPAPP_ID,
                                    EMPLOYEE_ID,
                                    REFERENCE_TYPE,
                                    REFERENCE_NAME,
                                    REFERENCE_COMPANY,
                                    REFERENCE_POSITION,
                                    REFERENCE_TELCODE,
                                    REFERENCE_TEL,
                                    REFERENCE_EMAIL
                                 )
                                 VALUES
                                 (
                                    #session.cp.userid#,
                                    NULL,
                                    <cfif len(evaluate('arguments.ref_type#r#'))>#wrk_eval('arguments.ref_type#r#')#<cfelse>NULL</cfif>,
                                    '#wrk_eval('arguments.ref_name#r#')#',
                                    '#wrk_eval('arguments.ref_company#r#')#',
                                    '#wrk_eval('arguments.ref_position#r#')#',
                                    '#wrk_eval('arguments.ref_telcode#r#')#',
                                    '#wrk_eval('arguments.ref_tel#r#')#',
                                    '#wrk_eval('arguments.ref_mail#r#')#'
                                 )
                        </cfquery>
                    </cfif>
                </cfloop>
                <cfquery name="UPD_CV_5" datasource="#DSN#">
                    UPDATE 
                        EMPLOYEES_APP
                    SET
                        UPDATE_DATE = NULL,
                        UPDATE_IP = NULL,
                        UPDATE_EMP = NULL,
                        UPDATE_APP_DATE = #now()#,
                        UPDATE_APP_IP = '#cgi.remote_addr#',
                        UPDATE_APP = #session.cp.userid#
                    WHERE
                        EMPAPP_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
                </cfquery>
                <!--- İş Tecrübeleri --->
            </cfif>
            <cfquery name="UPD_CV_6" datasource="#DSN#">
                UPDATE 
                    EMPLOYEES_APP
                SET
                    CLUB='#arguments.club#',
                    HOBBY='#arguments.hobby#'
                WHERE
                    EMPAPP_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
            </cfquery>
            <cfset result.status = true>
            <cfset result.success_message = warning>
            <cfset result.identity = "">
        <cfcatch type="any">
            <cfset result.status = false>
            <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
            <cfset result.error = cfcatch >
        </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <!--- Özgeçmişim / Çalışma Tercihlerim (Stage : 6) --->
    <cffunction name="add_cv_6" access="public" returntype="string" returnformat="json">
        <cftry>
            <cfquery name="UPD_CV_9" datasource="#DSN#">
                UPDATE 
                    EMPLOYEES_APP
                SET
                    <!---PHOTO=<cfif len(arguments.photo)>'#arguments.photo#',<cfelse>NULL,</cfif>
                    PHOTO_SERVER_ID=<cfif len(arguments.photo)>#fusebox.server_machine#,<cfelse>NULL,</cfif>--->
                    PREFERED_CITY =<cfif isdefined("arguments.prefered_city") and len(arguments.prefered_city)>',#arguments.prefered_city#,',<cfelse>NULL,</cfif>
                    IS_TRIP = #arguments.is_trip#,
                    EXPECTED_PRICE =<cfif isDefined("arguments.expected_price") and len(arguments.expected_price)>#replace(EXPECTED_PRICE,',','','all')#<cfelse>NULL</cfif>,
                    EXPECTED_MONEY_TYPE = <cfif isDefined("arguments.expected_money_type") and len(arguments.expected_money_type)>'#EXPECTED_MONEY_TYPE#'</cfif>,
                    APPLICANT_NOTES = '#arguments.applicant_notes#',
                    UPDATE_IP=NULL,
                    UPDATE_DATE=NULL,
                    UPDATE_EMP = NULL,
                    UPDATE_APP_DATE = #now()#,
                    UPDATE_APP_IP = '#cgi.remote_addr#',
                    UPDATE_APP = #session.cp.userid#
                WHERE
                    EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
            </cfquery>
            
            <!--- çalışmak istediği birimler--->
            <cfquery name="del_app_unit" datasource="#dsn#"> 
                DELETE FROM EMPLOYEES_APP_UNIT WHERE EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
            </cfquery>
            <cfquery name="get_cv_unit" datasource="#DSN#">
                SELECT * FROM SETUP_CV_UNIT
            </cfquery>
            <cfoutput query="get_cv_unit">
                <cfif isdefined('unit#get_cv_unit.unit_id#') and len(evaluate('unit#get_cv_unit.unit_id#'))>
                    <cfquery name="add_unit" datasource="#dsn#">
                        INSERT 
                            INTO EMPLOYEES_APP_UNIT
                            (
                                EMPAPP_ID,
                                UNIT_ID,
                                UNIT_ROW
                            )
                            VALUES
                            (
                                #session.cp.userid#,
                                #get_cv_unit.unit_id#,
                                #evaluate('unit#get_cv_unit.unit_id#')#
                            )
                    </cfquery> 
                </cfif>
            </cfoutput>
            <cfset result.status = true>
            <cfset result.success_message = warning>
            <cfset result.identity = "">
        <cfcatch type="any">
            <cfset result.status = false>
            <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
            <cfset result.error = cfcatch >
        </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>  

    <cffunction name="add_cv_7" access="public" returntype="string" returnformat="json">
        <cftry>
            <!---kayıtları sayfa içined popuplar yaptığı için query yok--->
            <cfquery name="UPD_CV_10" datasource="#DSN#">
                UPDATE 
                    EMPLOYEES_APP
                SET
                    APP_STATUS = <cfif isdefined('arguments.app_status')>#arguments.app_status#</cfif>,
                    UPDATE_IP = NULL,
                    UPDATE_DATE = NULL,
                    UPDATE_EMP = NULL,
                    UPDATE_APP_IP = '#cgi.remote_addr#',
                    UPDATE_APP_DATE = #now()#,
                    UPDATE_APP = #session.cp.userid#
                WHERE
                    EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
            </cfquery>
            <cfset result.status = true>
            <cfset result.success_message = warning>
            <cfset result.identity = "">
        <cfcatch type="any">
            <cfset result.status = false>
            <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
            <cfset result.error = cfcatch >
        </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction> 

    <cffunction name="fast_cv" access="public" returntype="string" returnformat="json">
        <cftry>
            <cfset upload_folder = "#upload_folder#hr#dir_seperator#">
            <cfif isdefined("arguments.old_photo") and len(arguments.old_photo)>
                <cfif len(arguments.photo)>
                    <cffile action="delete" file="#upload_folder##arguments.old_photo#">
                    <cfset arguments.old_photo = "">
                <cfelse>
                    <cfif isdefined("del_photo")>
                        <cffile action="delete" file="#upload_folder##arguments.old_photo#">
                        <cfset arguments.old_photo = "">
                    </cfif>
                </cfif>
            </cfif>
            <cfif isdefined("arguments.photo") and  len(arguments.photo)>
                <cftry>
                    <cffile action = "upload"
                        filefield = "photo"
                        destination = "#upload_folder#" 
                        nameconflict = "MakeUnique" 
                        accept="image/*"
                        mode="777">

                    <cfset file_name = createUUID()>
                    <cffile action="rename" source="#upLOAD_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
                    <cfset arguments.photo = '#file_name#.#cffile.serverfileext#'>
                
                    <cfcatch type="Any">
                        <script type="text/javascript">
                            alert("<cf_get_lang no ='1412.Resim yüklenemedi lütfen tekrar deneyiniz'>!");
                            history.back();
                        </script>
                        <cfabort>
                    </cfcatch>
                </cftry>
            <cfelseif isdefined("arguments.old_photo") and  len(arguments.old_photo)>
                <cfset arguments.photo = arguments.old_photo>
            <cfelse>
                <cfset arguments.photo = "">
            </cfif>
            <!--- FS 20080806 ucasede tirnakli ifadeler kaydedilirken sorun oluyor bu yuzden once baska bi yerde tanimlamak gerekiyor --->
            <cfif len(arguments.head_cv)><cfset head_cv_ = this.UCASETR(arguments.head_cv)></cfif>
            <cfif len(arguments.lang1)><cfset lang1_where_ = this.UCASETR(arguments.lang1_where)></cfif>
            <cfif len(arguments.lang2)><cfset lang2_where_ = this.UCASETR(arguments.lang2_where)></cfif>
            <cfif len(arguments.lang3)><cfset lang3_where_ = this.UCASETR(arguments.lang3_where)></cfif>
            <cfif len(arguments.kurs1)><cfset kurs1_ = this.UCASETR(arguments.kurs1)></cfif>
            <cfif len(arguments.kurs2)><cfset kurs2_ = this.UCASETR(arguments.kurs2)></cfif>
            <cfif len(arguments.kurs3)><cfset kurs3_ = this.UCASETR(arguments.kurs3)></cfif>
            <cfif len(arguments.kurs1_yer)><cfset kurs1_yer_ = this.UCASETR(arguments.kurs1_yer)></cfif>
            <cfif len(arguments.kurs2_yer)><cfset kurs2_yer_ = this.UCASETR(arguments.kurs2_yer)></cfif>
            <cfif len(arguments.kurs3_yer)><cfset kurs3_yer_ = this.UCASETR(arguments.kurs3_yer)></cfif>
            <cfif isdefined("arguments.comp_exp") and len(arguments.comp_exp)><cfset comp_exp_ = this.UCASETR(arguments.comp_exp)></cfif>
            <cfif len(arguments.licence_start_date)><cf_date tarih="arguments.licence_start_date"></cfif>

            <cflock timeout="20">
                <cftransaction>
                    <cfquery name="UPD_FAST_CV" datasource="#DSN#">
                        UPDATE 
                            EMPLOYEES_APP
                        SET
                            HEAD_CV = <cfif len(arguments.head_cv)>'#head_cv_#'<cfelse>NULL</cfif>,
                            NAME = '#this.UCASETR(arguments.emp_name)#',
                            SURNAME = '#this.UCASETR(arguments.emp_surname)#',
                            PHOTO= <cfif len(arguments.photo)>'#arguments.photo#'<cfelse>NULL</cfif>,
                            PHOTO_SERVER_ID= <cfif len(arguments.photo)>#fusebox.server_machine#<cfelse>NULL</cfif>,
                            SEX = <cfif isdefined("arguments.sex") and len(arguments.sex)>#arguments.sex#<cfelse>0</cfif>,
                            <cfif isdefined("arguments.defected")>
                                DEFECTED = #arguments.defected#,
                                <cfif isdefined('arguments.defected_level')>DEFECTED_LEVEL = #arguments.defected_level#,</cfif>
                            <cfelse>
                                DEFECTED = 0,
                                DEFECTED_LEVEL = 0,
                            </cfif>
                            LICENCECAT_ID = <cfif len(arguments.driver_licence_type)>#arguments.driver_licence_type#<cfelse>NULL</cfif>,
                            LICENCE_START_DATE = <cfif len(arguments.licence_start_date)>#arguments.licence_start_date#<cfelse>NULL</cfif>,
                            MILITARY_STATUS = <cfif isdefined("arguments.military_status") and len(arguments.military_status)>#arguments.military_status#<cfelse>0</cfif>,
                            MOBILCODE = <cfif len(arguments.mobilcode)>'#arguments.mobilcode#'<cfelse>NULL</cfif>,
                            MOBIL = <cfif len(arguments.mobil)> '#arguments.mobil#'<cfelse>NULL</cfif>,
                            HOMETELCODE = <cfif len(arguments.hometelcode)>'#arguments.hometelcode#'<cfelse>NULL</cfif>,
                            HOMETEL = <cfif len(arguments.hometel)>'#arguments.hometel#'<cfelse>NULL</cfif>,
                            EMAIL = <cfif len(arguments.email)>'#arguments.email#'<cfelse>NULL</cfif>,
                            HOMEADDRESS = '#arguments.homeaddress#',
                            HOMECOUNTY = '#arguments.homecounty#',
                            HOMECITY= <cfif len(arguments.homecity)>#arguments.homecity#<cfelse>NULL</cfif>,
                            HOMECOUNTRY = <cfif len(arguments.homecountry)>#arguments.homecountry#<cfelse>NULL</cfif>,
                            PREFERENCE_BRANCH = <cfif isdefined("arguments.preference_branch") and len(arguments.preference_branch)>',#arguments.preference_branch#,'<cfelse>NULL</cfif>,
                            TRAINING_LEVEL = <cfif len(arguments.training_level)>#arguments.training_level#<cfelse>NULL</cfif>,
                            KURS1 = <cfif len(arguments.kurs1)>'#kurs1_#'<cfelse>NULL</cfif>,
                            KURS1_YIL = <cfif len(arguments.kurs1_yil) eq 4>{TS '#arguments.kurs1_yil#-01-01 00:00:00'}<cfelse>NULL</cfif>,
                            KURS1_YER = <cfif len(arguments.kurs1_yer)>'#kurs1_yer_#'<cfelse>NULL</cfif>,
                            KURS1_GUN = <cfif len(arguments.kurs1_gun)>'#arguments.kurs1_gun#'<cfelse>NULL</cfif>,
                            KURS2 = <cfif len(arguments.kurs2)>'#kurs2_#'<cfelse>NULL</cfif>,
                            KURS2_YIL = <cfif len(arguments.kurs2_yil) eq 4>{TS '#arguments.kurs2_yil#-01-01 00:00:00'}<cfelse>NULL</cfif>,
                            KURS2_YER = <cfif len(arguments.kurs2_yer)>'#kurs2_yer_#'<cfelse>NULL</cfif>,
                            KURS2_GUN = <cfif len(arguments.kurs2_gun)>'#arguments.kurs2_gun#'<cfelse>NULL</cfif>,
                            KURS3 = <cfif len(arguments.kurs3)>'#kurs3_#'<cfelse>NULL</cfif>,
                            KURS3_YIL = <cfif len(arguments.kurs3_yil) eq 4>{TS '#arguments.kurs3_yil#-01-01 00:00:00'}<cfelse>NULL</cfif>,
                            KURS3_YER = <cfif len(arguments.kurs3_yer)>'#kurs3_yer_#'<cfelse>NULL</cfif>,
                            KURS3_GUN = <cfif len(arguments.kurs3_gun)>'#arguments.kurs3_gun#'<cfelse>NULL</cfif>,
                            COMP_EXP = <cfif isdefined("arguments.comp_exp") and len(arguments.comp_exp)>'#comp_exp_#'<cfelse>NULL</cfif>,
                            APP_STATUS = 1,
                            UPDATE_IP = '#cgi.REMOTE_ADDR#',
                            UPDATE_DATE = #now()#,
                            UPDATE_EMP = NULL,
                            UPDATE_APP_DATE = #now()#,
                            UPDATE_APP_IP = '#cgi.remote_addr#',
                            UPDATE_APP = #session.cp.userid#
                        WHERE
                            EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
                    </cfquery>

                    <cfloop from="1" to="5" index="i">
                        <cfif (not len(evaluate('arguments.lang_id#i#'))) and len(evaluate('arguments.lang#i#'))>
                            <cfquery name="ADD_LANGS" datasource="#DSN#">
                                INSERT INTO
                                    EMPLOYEES_APP_LANGUAGE
                                    (
                                        EMPAPP_ID,
                                        LANG_ID,
                                        LANG_SPEAK,
                                        LANG_MEAN,
                                        LANG_WRITE,
                                        LANG_WHERE,
                                        RECORD_DATE,
                                        RECORD_IP
                                    )
                                    VALUES
                                    (
                                        #session.cp.userid#,
                                        #evaluate('arguments.lang#i#')#,
                                        <cfif len(evaluate('arguments.lang#i#_speak'))>#evaluate('arguments.lang#i#_speak')#<cfelse>NULL</cfif>,
                                        <cfif len(evaluate('arguments.lang#i#_mean'))>#evaluate('arguments.lang#i#_mean')#<cfelse>NULL</cfif>,
                                        <cfif len(evaluate('arguments.lang#i#_write'))>#evaluate('arguments.lang#i#_write')#<cfelse>NULL</cfif>,
                                        <cfif len(evaluate('arguments.lang#i#_where'))>'#evaluate('arguments.lang#i#_where')#'<cfelse>NULL</cfif>	,
                                        #now()#,
                                        '#cgi.remote_addr#'	
                                    )
                            </cfquery>
                        <cfelseif len(evaluate('arguments.lang_id#i#')) and len(evaluate('arguments.lang#i#'))>
                            <cfquery name="UPDA_LANG" datasource="#DSN#">
                                UPDATE
                                    EMPLOYEES_APP_LANGUAGE
                                SET
                                    LANG_SPEAK = <cfif len(evaluate('arguments.lang#i#_speak'))>#evaluate('arguments.lang#i#_speak')#<cfelse>NULL</cfif>,
                                    LANG_MEAN = <cfif len(evaluate('arguments.lang#i#_mean'))>#evaluate('arguments.lang#i#_mean')#<cfelse>NULL</cfif>,
                                    LANG_WRITE = <cfif len(evaluate('arguments.lang#i#_write'))>#evaluate('arguments.lang#i#_write')#<cfelse>NULL</cfif>,
                                    LANG_WHERE = <cfif len(evaluate('arguments.lang#i#_where'))>'#evaluate('arguments.lang#i#_where')#'<cfelse>NULL</cfif>,
                                    UPDATE_DATE = #now()#,
                                    UPDATE_IP = '#cgi.remote_addr#'
                                WHERE
                                    EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#"> AND
                                    ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('arguments.lang_id#i#')#">
                            </cfquery>
                        <cfelseif (not len(evaluate('arguments.lang#i#'))) and len(evaluate('arguments.lang_id#i#'))>
                            <cfquery name="DEL_LANGS" datasource="#DSN#">
                                DELETE FROM EMPLOYEES_APP_LANGUAGE
                                WHERE
                                    EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#"> AND
                                    ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('arguments.lang_id#i#')#">
                            </cfquery>
                        </cfif>
                    </cfloop>
                        
                    <cfquery name="DELETE_EMP_REFERENCE" datasource="#DSN#">
                        DELETE EMPLOYEES_REFERENCE WHERE EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
                    </cfquery>		
                    <cfloop from="1" to="#arguments.add_ref_info#" index="r">
                        <cfif isdefined('arguments.del_ref_info#r#') and  evaluate('arguments.del_ref_info#r#') eq 1><!--- silinmemiş ise.. --->
                            <cfquery name="ADD_EMPLOYEES_REFERENCE" datasource="#DSN#">
                                INSERT INTO
                                    EMPLOYEES_REFERENCE
                                    (
                                        EMPAPP_ID,
                                        EMPLOYEE_ID,
                                        REFERENCE_TYPE,
                                        REFERENCE_NAME,
                                        REFERENCE_COMPANY,
                                        REFERENCE_POSITION,
                                        REFERENCE_TELCODE,
                                        REFERENCE_TEL,
                                        REFERENCE_EMAIL
                                    )
                                    VALUES
                                    (
                                        #session.cp.userid#,
                                        NULL,
                                        <cfif len(wrk_eval('arguments.ref_type#r#'))>#wrk_eval('arguments.ref_type#r#')#<cfelse>NULL</cfif>,<!--- '#wrk_eval('arguments.ref_type#r#')#', --->
                                        <cfif len(wrk_eval('arguments.ref_name#r#'))>'#wrk_eval('arguments.ref_name#r#')#'<cfelse>NULL</cfif>,
                                        <cfif len(wrk_eval('arguments.ref_company#r#'))>'#wrk_eval('arguments.ref_company#r#')#'<cfelse>NULL</cfif>,
                                        <cfif len(wrk_eval('arguments.ref_position#r#'))>'#wrk_eval('arguments.ref_position#r#')#'<cfelse>NULL</cfif>,
                                        <cfif len(wrk_eval('arguments.ref_telcode#r#'))>'#wrk_eval('arguments.ref_telcode#r#')#'<cfelse>NULL</cfif>,
                                        <cfif len(wrk_eval('arguments.ref_tel#r#'))>'#wrk_eval('arguments.ref_tel#r#')#'<cfelse>NULL</cfif>,
                                        <cfif len(wrk_eval('arguments.ref_mail#r#'))>'#wrk_eval('arguments.ref_mail#r#')#'<cfelse>NULL</cfif>
                                    )
                            </cfquery>
                        </cfif>
                    </cfloop>
                        
                    <cfif len(arguments.birth_date)>
                        <cf_date tarih="arguments.birth_date">
                    </cfif>
                    <cfif not isdefined("arguments.married")>
                        <cfset arguments.married = 0>
                    </cfif>
                    <cfquery name="UPD_IDENTY" datasource="#DSN#">
                        UPDATE
                            EMPLOYEES_IDENTY
                        SET
                            <cfif len(arguments.tc_identy_no)>
                                TC_IDENTY_NO = '#arguments.tc_identy_no#',
                            <cfelse>
                                TC_IDENTY_NO = NULL, 
                            </cfif>
                            BIRTH_DATE = <cfif len(arguments.birth_date)>#arguments.birth_date#<cfelse>NULL</cfif>,
                            BIRTH_PLACE = '#arguments.birth_place#',
                            MARRIED = #arguments.married#,
                            UPDATE_DATE = #now()#,
                            UPDATE_IP = '#cgi.remote_addr#',
                            UPDATE_EMP = #session.cp.userid#
                        WHERE
                            EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
                    </cfquery>
                    
                        <!--- Egitim Bilgileri Lise --->
                    <cfif isdefined("arguments.edu_id_lise") and len(arguments.edu_id_lise) and isdefined("arguments.empapp_edu_row_id_lise")>
                        <cfif isdefined("arguments.edu_part_id_lise") and len(arguments.edu_part_id_lise) and arguments.edu_part_id_lise neq -1>
                            <cfquery name="GET_EDU_HIGH_PART_NAME" datasource="#DSN#">
                                SELECT HIGH_PART_ID, HIGH_PART_NAME FROM SETUP_HIGH_SCHOOL_PART WHERE HIGH_PART_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.edu_part_id_lise#">
                            </cfquery>
                            <cfset 'arguments.edu_part_name_lise' = get_edu_high_part_name.high_part_name>
                        <cfelse>
                            <cfset 'arguments.edu_part_name_lise' = arguments.edu_part_name_lise>
                        </cfif>
                        <cfif isdefined("arguments.edu_id_lise") and len(arguments.edu_id_lise) and isdefined("arguments.edu_name_lise") and len(arguments.edu_name_lise)>
                            <cfquery name="UPD_EMPLOYEES_APP_EDU_INFO" datasource="#DSN#">
                                UPDATE
                                    EMPLOYEES_APP_EDU_INFO
                                SET
                                    EDU_TYPE = 3,
                                    EDU_ID = <cfif isdefined("arguments.edu_id_lise") and len(arguments.edu_id_lise)>#arguments.edu_id_lise#<cfelse>-1</cfif>,
                                    EDU_NAME = <cfif isdefined("arguments.edu_name_lise") and len(evaluate('arguments.edu_name_lise'))>'#arguments.edu_name_lise#'<cfelse>NULL</cfif>,
                                    EDU_PART_ID = <cfif isdefined("arguments.edu_part_id_lise") and len(evaluate('arguments.edu_part_id_lise'))>#arguments.edu_part_id_lise#<cfelse>NULL</cfif>,
                                    EDU_PART_NAME = <cfif isdefined("arguments.edu_part_name_lise") and len(evaluate('arguments.edu_part_name_lise'))>'#arguments.edu_part_name_lise#'<cfelse>NULL</cfif>,
                                    EDU_START = <cfif isdefined("arguments.edu_start_lise") and len(arguments.edu_start_lise)>#arguments.edu_start_lise#<cfelse>NULL</cfif>,
                                    EDU_FINISH = <cfif isdefined("arguments.edu_finish_lise") and len(arguments.edu_finish_lise)>#arguments.edu_finish_lise#<cfelse>NULL</cfif>,
                                    EMPAPP_ID = #session.cp.userid#,
                                    IS_EDU_CONTINUE = 0
                                WHERE
                                    EMPAPP_EDU_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.empapp_edu_row_id_lise#">
                            </cfquery>
                        </cfif>
                    <cfelseif isdefined("arguments.edu_id_lise") and len(arguments.edu_id_lise) and not isdefined("arguments.empapp_edu_row_id_lise")>
                        <cfif isdefined("arguments.edu_part_id_lise") and len(arguments.edu_part_id_lise) and arguments.edu_part_id_lise neq -1>
                            <cfquery name="GET_EDU_HIGH_PART_NAME" datasource="#DSN#">
                                SELECT HIGH_PART_ID, HIGH_PART_NAME FROM SETUP_HIGH_SCHOOL_PART WHERE HIGH_PART_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.edu_part_id_lise#">
                            </cfquery>
                            <cfset 'arguments.edu_part_name_lise' = get_edu_high_part_name.high_part_name>
                        <cfelse>
                            <cfset 'arguments.edu_part_name_lise' = arguments.edu_part_name_lise>
                        </cfif>
                        <cfif isdefined("arguments.edu_id_lise") and listlen(evaluate("arguments.edu_id_lise"),';') and isdefined("arguments.edu_name_lise") and len(evaluate("arguments.edu_name_lise"))>
                            <cfquery name="ADD_EMPLOYEES_APP_EDU_INFO" datasource="#DSN#">
                                INSERT INTO
                                    EMPLOYEES_APP_EDU_INFO
                                (
                                    EMPAPP_ID,
                                    EDU_TYPE,
                                    EDU_ID,
                                    EDU_NAME,
                                    EDU_PART_ID,
                                    EDU_PART_NAME,
                                    EDU_START,
                                    EDU_FINISH,
                                    IS_EDU_CONTINUE
                                )
                                VALUES
                                (
                                    #session.cp.userid#,
                                    3,
                                    #arguments.edu_id_lise#,
                                    <cfif isdefined("arguments.edu_name_lise") and len(arguments.edu_name_lise)>'#this.UCASETR(arguments.edu_name_lise)#'<cfelse>NULL</cfif>,
                                    <cfif isdefined("arguments.edu_part_id_lise") and len(arguments.edu_part_id_lise)>#arguments.edu_part_id_lise#<cfelse>NULL</cfif>,
                                    <cfif isdefined("arguments.edu_part_name_lise") and len(arguments.edu_part_name_lise)>'#this.UCASETR(arguments.edu_part_name_lise)#'<cfelse>NULL</cfif>,
                                    <cfif isdefined("arguments.edu_start_lise") and len(arguments.edu_start_lise)>#arguments.edu_start_lise#<cfelse>NULL</cfif>,
                                    <cfif isdefined("arguments.edu_finish_lise") and len(arguments.edu_finish_lise)>#arguments.edu_finish_lise#<cfelse>NULL</cfif>,
                                    0
                                )
                            </cfquery>
                        </cfif>
                    <cfelseif not (isdefined("arguments.edu_id_lise") and len(arguments.edu_id_lise)) and isdefined("arguments.empapp_edu_row_id_lise")>
                        <cfquery name="DEL_EMPLOYEES_APP_EDU_INFO" datasource="#DSN#">
                            DELETE FROM
                                EMPLOYEES_APP_EDU_INFO
                            WHERE
                                EMPAPP_EDU_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.empapp_edu_row_id_lise#">
                        </cfquery>
                    </cfif>
                    
                    <!--- is Tecrubeleri --->
                    <cfif not isdefined("arguments.is_exp")>
                        <cfloop from="1" to="#arguments.row_count#" index="k">
                            <cfif isdefined("arguments.row_kontrol#k#") and evaluate("arguments.row_kontrol#k#")>
                                <cfif isdate(evaluate('arguments.exp_start#k#'))>
                                    <cfset arguments.exp_start=evaluate('arguments.exp_start#k#')>
                                    <cf_date tarih="arguments.exp_start">
                                <cfelse>
                                    <cfset arguments.exp_start="">
                                </cfif>
                                <cfif isdate(evaluate('arguments.exp_finish#k#'))>
                                    <cfset arguments.exp_finish=evaluate('arguments.exp_finish#k#')>
                                    <cf_date tarih="arguments.exp_finish">
                                <cfelse>
                                    <cfset arguments.exp_finish="">
                                </cfif>
                                <cfif len(arguments.exp_start) gt 9 and len(arguments.exp_finish) gt 9>
                                <cfset arguments.exp_fark = datediff("d",arguments.exp_start,arguments.exp_finish)>
                                <cfelse>
                                    <cfset arguments.exp_fark="">
                                </cfif>
                                <cfif isDefined("arguments.empapp_row_id#k#") and len(evaluate("arguments.empapp_row_id#k#"))>
                                    <cfif len(evaluate('arguments.exp_name#k#'))>
                                        <cfset exp_name_ = this.UCASETR(evaluate('arguments.exp_name#k#'))>
                                        <cfquery name="UPD_EMPLOYEES_APP_WORK_INFO" datasource="#DSN#">
                                            UPDATE
                                                EMPLOYEES_APP_WORK_INFO
                                            SET
                                                EXP = <cfif len(evaluate('arguments.exp_name#k#'))>'#exp_name_#'<cfelse>NULL</cfif>,
                                                EXP_START = <cfif isdate(arguments.exp_start)>#arguments.exp_start#<cfelse>NULL</cfif>,
                                                EXP_FINISH = <cfif isdate(arguments.exp_finish)>#arguments.exp_finish#<cfelse>NULL</cfif>,
                                                EXP_FARK = <cfif len(arguments.exp_fark)>#arguments.exp_fark#<cfelse>NULL</cfif>,
                                                EXP_REASON_ID = <cfif len(evaluate('arguments.exp_reason_id#k#'))>#evaluate('arguments.exp_reason_id#k#')#<cfelse>NULL</cfif>,
                                                EXP_SECTOR_CAT= <cfif len(evaluate('arguments.exp_sector_cat#k#'))>#evaluate('arguments.exp_sector_cat#k#')#<cfelse>NULL</cfif>,
                                                EXP_TASK_ID = <cfif len(evaluate('arguments.exp_task_id#k#'))>#evaluate('arguments.exp_task_id#k#')#<cfelse>NULL</cfif>,
                                                IS_CONT_WORK = <cfif isdefined("arguments.is_cont_work#k#") and evaluate('arguments.is_cont_work#k#') eq 1>1<cfelse>0</cfif>,
                                                EMPAPP_ID = #session.cp.userid#
                                            WHERE
                                                EMPAPP_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("arguments.empapp_row_id#k#")#">
                                        </cfquery>
                                    <cfelse>
                                        <cfquery name="DEL_EMPLOYEES_APP_WORK_INFO" datasource="#DSN#">
                                            DELETE FROM
                                                EMPLOYEES_APP_WORK_INFO
                                            WHERE
                                                EMPAPP_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("arguments.empapp_row_id#k#")#">
                                        </cfquery>
                                    </cfif>
                                <cfelseif len(evaluate('arguments.exp_name#k#'))>
                                    <cfset exp_name_ = this.UCASETR(evaluate('arguments.exp_name#k#'))>
                                    <cfquery name="ADD_EMPLOYEES_APP_WORK_INFO" datasource="#DSN#">
                                        INSERT INTO
                                            EMPLOYEES_APP_WORK_INFO
                                            (
                                                EMPAPP_ID,
                                                EXP,
                                                EXP_START,
                                                EXP_FINISH,
                                                EXP_FARK,
                                                EXP_REASON_ID,
                                                EXP_SECTOR_CAT,
                                                EXP_TASK_ID,
                                                IS_CONT_WORK
                                                )
                                            VALUES
                                            (
                                                #session.cp.userid#,
                                                <cfif len(evaluate('arguments.exp_name#k#'))>'#exp_name_#'<cfelse>NULL</cfif>,
                                                <cfif isdate(arguments.exp_start)>#arguments.exp_start#<cfelse>NULL</cfif>,
                                                <cfif isdate(arguments.exp_finish)>#arguments.exp_finish#<cfelse>NULL</cfif>,
                                                <cfif len(arguments.exp_fark)>#arguments.exp_fark#<cfelse>NULL</cfif>,
                                                <cfif len(evaluate('arguments.exp_reason_id#k#'))>'#this.UCASETR(evaluate('arguments.exp_reason_id#k#'))#'<cfelse>NULL</cfif>,
                                                <cfif len(evaluate('arguments.exp_sector_cat#k#'))>#evaluate('arguments.exp_sector_cat#k#')#<cfelse>NULL</cfif>,
                                                <cfif len(evaluate('arguments.exp_task_id#k#'))>#evaluate('arguments.exp_task_id#k#')#<cfelse>NULL</cfif>,
                                                <cfif isdefined("arguments.is_cont_work#k#") and evaluate('arguments.is_cont_work#k#') eq 1>1<cfelse>0</cfif>
                                            )
                                    </cfquery>
                                </cfif>
                            </cfif>
                        </cfloop>
                    </cfif>
                    <!--- EGitim Bilgileri --->
                    <cfloop from="1" to="#arguments.row_edu#" index="j">
                        <cfif isdefined("arguments.row_kontrol_edu#j#") and evaluate("arguments.row_kontrol_edu#j#")>
                            <cfif isdefined("arguments.edu_part_id#j#") and len(evaluate('arguments.edu_part_id#j#')) >
                                <cfset bolum_id = evaluate('arguments.edu_part_id#j#')>
                            <cfelse>
                                <cfset bolum_id = -1>
                            </cfif>
                            <cfif isDefined("arguments.empapp_edu_row_id#j#") and len(evaluate("arguments.empapp_edu_row_id#j#"))>
                                <cfif len(evaluate('arguments.edu_name#j#'))>
                                    <cfquery name="UPD_EMPLOYEES_APP_EDU_INFO" datasource="#DSN#">
                                            UPDATE
                                                EMPLOYEES_APP_EDU_INFO
                                            SET
                                                EDU_TYPE = #evaluate('arguments.edu_type#j#')#,
                                                EDU_ID = <cfif isdefined("arguments.edu_id#j#") and len(evaluate('arguments.edu_id#j#'))>#evaluate('arguments.edu_id#j#')#<cfelse>-1</cfif>,
                                                EDU_NAME = <cfif isdefined("arguments.edu_name#j#") and len(evaluate('arguments.edu_name#j#'))>'#this.UCASETR(evaluate('arguments.edu_name#j#'))#'<cfelse>NULL</cfif>,
                                                EDU_PART_ID = <cfif isdefined("bolum_id") and len(bolum_id)>#bolum_id#<cfelse>NULL</cfif>,
                                                EDU_PART_NAME = <cfif isdefined("arguments.edu_part_name#j#") and len(evaluate('arguments.edu_part_name#j#'))>'#this.UCASETR(evaluate('arguments.edu_part_name#j#'))#'<cfelse>NULL</cfif>,
                                                EDU_START = <cfif isdefined("arguments.edu_start#j#") and len(evaluate('arguments.edu_start#j#'))>#evaluate('arguments.edu_start#j#')#<cfelse>NULL</cfif>,
                                                EDU_FINISH = <cfif isdefined("arguments.edu_finish#j#") and len(evaluate('arguments.edu_finish#j#'))>#evaluate('arguments.edu_finish#j#')#<cfelse>NULL</cfif>,
                                                EMPAPP_ID = #session.cp.userid#
                                            WHERE
                                                EMPAPP_EDU_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("arguments.empapp_edu_row_id#j#")#">
                                    </cfquery>
                                <cfelse>
                                    <cfif isDefined("arguments.empapp_edu_row_id#j#") and len(evaluate("arguments.empapp_edu_row_id#j#"))>
                                        <cfquery name="DEL_EMPLOYEES_APP_EDU_INFO" datasource="#DSN#">
                                            DELETE FROM
                                                EMPLOYEES_APP_EDU_INFO
                                            WHERE
                                                EMPAPP_EDU_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("arguments.empapp_edu_row_id#j#")#">
                                        </cfquery>
                                    </cfif>
                                </cfif>
                            <cfelseif len(evaluate('arguments.edu_name#j#'))>
                                <cfquery name="ADD_EMPLOYEES_APP_EDU_INFO" datasource="#DSN#">
                                    INSERT INTO
                                        EMPLOYEES_APP_EDU_INFO
                                    (
                                        EMPAPP_ID,
                                        EDU_TYPE,
                                        EDU_ID,
                                        EDU_NAME,
                                        EDU_PART_ID,
                                        EDU_PART_NAME,
                                        EDU_START,
                                        EDU_FINISH
                                    )
                                        VALUES
                                    (
                                        #session.cp.userid#,
                                        #evaluate('arguments.edu_type#j#')#,
                                        <cfif isdefined("arguments.edu_id#j#") and len(evaluate('arguments.edu_id#j#'))>#evaluate('arguments.edu_id#j#')#<cfelse>-1</cfif>,
                                        <cfif isdefined("arguments.edu_name#j#") and len(evaluate('arguments.edu_name#j#'))>'#this.UCASETR(evaluate('arguments.edu_name#j#'))#'<cfelse>NULL</cfif>,
                                        <cfif isdefined("bolum_id") and len(bolum_id)>#bolum_id#<cfelse>NULL</cfif>,
                                        <cfif isdefined("arguments.edu_part_name#j#") and len(evaluate('arguments.edu_part_name#j#'))>'#this.UCASETR(evaluate('arguments.edu_part_name#j#'))#'<cfelse>NULL</cfif>,
                                        <cfif isdefined("arguments.edu_start#j#") and len(evaluate('arguments.edu_start#j#'))>#evaluate('arguments.edu_start#j#')#<cfelse>NULL</cfif>,
                                        <cfif isdefined("arguments.edu_finish#j#") and len(evaluate('arguments.edu_finish#j#'))>#evaluate('arguments.edu_finish#j#')#<cfelse>NULL</cfif>
                                    )
                                </cfquery>
                            </cfif>
                        </cfif>
                    </cfloop>
                    
                    <!---dosya sil--->
                    <cfif isdefined("arguments.old_asset_file") and len(arguments.old_asset_file) and isdefined("arguments.del_asset_file") and len(arguments.del_asset_file)>
                        <cfset upload_folder = "#upload_folder#">
                        <cfif FileExists("#upload_folder##arguments.old_asset_file#")>
                            <cffile action="delete" file="#upload_folder##arguments.old_asset_file#">
                        </cfif>
                        <cfquery name="DEL_ASSET" datasource="#DSN#">
                            DELETE FROM ASSET WHERE ASSET_ID = #arguments.del_asset_file#
                        </cfquery>
                    </cfif>
                    
                    <!---dosya ekle--->
                    <cfif isdefined("arguments.asset_file") and len(arguments.asset_file) and isdefined('arguments.asset_file_name') and len(arguments.asset_file_name)>
                        <cfset upload_folder = "#upload_folder##dir_seperator#">
                        <cftry>
                            <cfset file_name = createUUID()>
                            <cffile action="UPLOAD" nameconflict="MAKEUNIQUE" filefield="asset_file" destination="#upload_folder#" mode="777">
                            <cffile action="rename" source="#upload_folder##dir_seperator##cffile.serverfile#" destination="#upload_folder##dir_seperator##file_name#.#cffile.serverfileext#">
                            <!---Script dosyalarını engelle  02092010 FA-ND --->
                            <cfset assetTypeName = listlast(cffile.serverfile,'.')>
                            <cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
                            <cfif listfind(blackList,assetTypeName,',')>
                                <cffile action="delete" file="#upload_folder##dir_seperator##file_name#.#cffile.serverfileext#">
                                <script type="text/javascript">
                                    alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
                                    history.back();
                                </script>
                                <cfabort>
                            </cfif>
                            <cfcatch type="any">
                                <script type="text/javascript">
                                    alert("<cf_get_lang_main no='43.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'> !");
                                    history.back();
                                </script>
                                <cfabort>
                            </cfcatch>
                        </cftry>
                        <!--- PROPERTY_ID belge tipi 1 set ediliyor ancak 1 olmaya bilir dbde kariyer belgeleri için seçilen belge no ona göre ayarlanmalı--->
                        <cfquery name="ADD_ASSET" datasource="#DSN#">
                            INSERT INTO 
                                ASSET
                                (
                                MODULE_NAME,
                                MODULE_ID,
                                ACTION_SECTION,
                                ACTION_ID,
                                ASSETCAT_ID, 
                                ASSET_NAME,
                                ASSET_FILE_NAME,
                                ASSET_FILE_SIZE,
                                ASSET_DETAIL,
                                IS_SPECIAL,
                                RECORD_DATE,
                                RECORD_PUB,
                                RECORD_IP,
                                PROPERTY_ID,
                                COMPANY_ID,
                                ASSET_FILE_SERVER_ID
                                )
                                VALUES
                                (
                                'HR',
                                3,
                                'EMPLOYEES_APP_ID',
                                #session.cp.userid#,
                                -8,
                                <cfif isdefined('arguments.asset_file_name') and len(arguments.asset_file_name)>'#arguments.asset_file_name#'<cfelse>NULL</cfif>,
                                '#file_name#.#cffile.serverfileext#',
                                #ROUND(CFFILE.FILESIZE/1024)#,
                                'Kariyer portalından eklenen dosya',
                                0,
                                #now()#,
                                #session.cp.userid#,
                                '#CGI.REMOTE_ADDR#',
                                1,
                                1,
                                #fusebox.server_machine#
                                )
                        </cfquery>
                    </cfif>
                    
                    <!--- Brans Bilgileri --->
                    <cfquery name="DEL_EMPLOYEES_APP_INFO" datasource="#DSN#"> 
                        DELETE FROM EMPLOYEES_APP_INFO WHERE EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
                    </cfquery>
                    <cfif isdefined("arguments.branch_row_count")>
                        <cfloop from="1" to="#arguments.branch_row_count#" index="i">
                            <cfset branches_id = evaluate("arguments.branches_id_#i#")>
                            <cfif isdefined('arguments.emp_app_info_#branches_id#') and len(evaluate("arguments.emp_app_info_#branches_id#"))>
                                <cfset row_branches_id = evaluate("arguments.emp_app_info_#branches_id#")>
                                <cfloop list="#row_branches_id#" delimiters="," index="row_i">
                                    <cfif isDefined('arguments.other_branches_name_#branches_id#')>
                                        <cfset other_branches_name_id_ = evaluate('arguments.other_branches_name_#branches_id#')>
                                        <cfquery name="ADD_EMPLOYEES_APP_INFO" datasource="#DSN#">
                                            INSERT INTO 
                                                EMPLOYEES_APP_INFO
                                            (
                                                EMPAPP_ID,
                                                BRANCHES_ID,
                                                BRANCHES_ROW_ID,
                                                BRANCHES_ROW_OTHER
                                            )
                                            VALUES
                                            (
                                                #session.cp.userid#,
                                                #branches_id#,
                                                #row_i#,
                                                <cfif isdefined("arguments.other_branches_name_#branches_id#") and len(evaluate('arguments.other_branches_name_#branches_id#'))>'#other_branches_name_id_#'<cfelse>NULL</cfif>
                                            )
                                        </cfquery>
                                    </cfif>
                                </cfloop>
                            </cfif>
                        </cfloop>
                    </cfif>
                    
                    <cfif arguments.teacher_info_record eq 0>
                        <cfquery name="ADD_TEACHER_INFO" datasource="#DSN#">
                            INSERT INTO 
                                EMPLOYEES_APP_TEACHER_INFO
                            (
                                EMPAPP_ID,
                                COMPUTER_EDUCATION,
                                SALARY_RANGE,
                                IS_FORMATION,
                                INTERNSHIP,
                                FORMATION_TYPE
                            )
                            VALUES
                            (
                                #session.cp.userid#,
                                <cfif isdefined("arguments.computer_education") and len(arguments.computer_education)>',#arguments.computer_education#,'<cfelse>NULL</cfif>,
                                <cfif isdefined("arguments.salary_range") and len(arguments.salary_range)>'#arguments.salary_range#'<cfelse>NULL</cfif>,
                                <cfif isdefined("arguments.formation") and len(arguments.formation)>#arguments.formation#<cfelse>NULL</cfif>,
                                <cfif isdefined("arguments.internship") and len(arguments.internship)>#arguments.internship#<cfelse>NULL</cfif>,
                                <cfif isdefined("arguments.formation_typee") and len(arguments.formation_typee)>',#arguments.formation_typee#,'<cfelse>NULL</cfif>
                            )
                        </cfquery>
                    <cfelse>
                        <cfquery name="UPD_TEACHER_INFO" datasource="#DSN#">
                            UPDATE
                                EMPLOYEES_APP_TEACHER_INFO
                            SET
                                COMPUTER_EDUCATION = <cfif isdefined("arguments.computer_education") and len(arguments.computer_education)>',#arguments.computer_education#,'<cfelse>NULL</cfif>,
                                SALARY_RANGE =  <cfif isdefined("arguments.salary_range") and len(arguments.salary_range)>'#arguments.salary_range#'<cfelse>NULL</cfif>,
                                IS_FORMATION = <cfif isdefined("arguments.formation") and len(arguments.formation)>#arguments.formation#<cfelse>NULL</cfif>,
                                INTERNSHIP = <cfif isdefined("arguments.internship") and len(arguments.internship)>#arguments.internship#<cfelse>NULL</cfif>,
                                FORMATION_TYPE = <cfif isdefined("arguments.formation_typee") and len(arguments.formation_typee)>',#arguments.formation_typee#,'<cfelse>NULL</cfif>
                            WHERE
                                EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
                        </cfquery>
                    </cfif>
                    
                    <!--- calısmak istedigi birimler--->
                    <cfquery name="DEL_EMPLOYEES_APP_UNIT" datasource="#DSN#"> 
                        DELETE FROM 
                            EMPLOYEES_APP_UNIT 
                        WHERE 
                            EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
                    </cfquery>
                    <cfquery name="GET_CV_UNIT" datasource="#DSN#">
                        SELECT 
                            UNIT_ID 
                        FROM 
                            SETUP_CV_UNIT
                    </cfquery>
                    <cfoutput query="get_cv_unit">
                        <cfif isdefined('unit#get_cv_unit.unit_id#') and len(evaluate('unit#get_cv_unit.unit_id#'))>
                            <cfquery name="add_unit" datasource="#DSN#">
                                INSERT 
                                    INTO EMPLOYEES_APP_UNIT
                                    (
                                        EMPAPP_ID,
                                        UNIT_ID,
                                        UNIT_ROW
                                    )
                                    VALUES
                                    (
                                        #session.cp.userid#,
                                        #get_cv_unit.unit_id#,
                                        #evaluate('unit#get_cv_unit.unit_id#')#
                                    )
                            </cfquery> 
                        </cfif>
                    </cfoutput>
                </cftransaction>
            </cflock>
            <cfset result.status = true>
            <cfset result.success_message = warning>
            <cfset result.identity = "">
        <cfcatch type="any">
            <cfset result.status = false>
            <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
            <cfset result.error = cfcatch >
            <cfdump var="#cfcatch#">
        </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="CAREER_REQUEST" access="remote" returntype="any" returnFormat="json">
        <cftry>
            <cfif len(arguments.careerName) and len(arguments.careerSurname) and len(arguments.careerMail) and len(arguments.careerPhone)>
                <cfset createId = createUUID()/>
                <cfset fileExtension = ucase(ListLast(arguments.careerCV,".")) />
                <cfset fileName = createId & "." & fileExtension />
                <cfset filePath = "#upload_folder#\hr\" />
                <cfset filefullPath = "#upload_folder#\hr\#fileName#" />
                <cffile action="upload" destination="#filefullPath#"  result="careerFile" NAMECONFLICT="Overwrite">
                <cffile action="rename" source="#careerFile.SERVERDIRECTORY#\#careerFile.SERVERFILE#" destination="#careerFile.SERVERDIRECTORY#\#createId#.#careerFile.CLIENTFILEEXT#" attributes="normal">	

                <cfset whiteList = 'pdf'>
                <cfif listfind(whiteList,careerFile.CLIENTFILEEXT,',')>
                    <cfset newFileName = "#createId#.#careerFile.CLIENTFILEEXT#" /> 
                    <cfquery name="get_empapp_mail" datasource="#dsn#">
                        SELECT EMAIL FROM EMPLOYEES_APP WHERE EMAIL='#arguments.careerMail#'
                    </cfquery>
                    <cfif get_empapp_mail.recordcount>
                        <cfset result.status = false>
                        <cfset result.danger_message =  "Girdiğiniz mail adresine ait bir kullanıcı mevcut! Aynı mail adresi ile farklı bir başvuru yapamazsınız!">     
                    <cfelse>
                        <cftransaction>
                            <cfquery name="ADD_EMP_APP" datasource="#dsn#" result="career_result">
                                INSERT INTO 
                                    EMPLOYEES_APP
                                    (
                                        CV_STAGE,
                                        STEP_NO,
                                        APP_STATUS,
                                        NAME,
                                        SURNAME,
                                        HOMECOUNTRY,
                                        HOMECITY,
                                        MOBILCODE,
                                        MOBIL,
                                        EMAIL,
                                        RECORD_DATE,
                                        RECORD_IP,
                                        HOMECOUNTY
                                    )
                                    VALUES(
                                        568,
                                        -1,
                                        1,
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.careerName#">,
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.careerSurname#">,
                                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.country_id#">,
                                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.city_id#">,
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.careerPhoneCode#">,
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.careerPhone#">,
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.careerMail#">,
                                        #NOW()#,
                                        '#CGI.REMOTE_ADDR#',
                                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.county_id#">
                                    )
                            </cfquery>
                            <cfquery name="GET_MAIN_PAPER" datasource="#dsn#">
                                SELECT * FROM GENERAL_PAPERS_MAIN WHERE EMPLOYEE_NUMBER IS NOT NULL
                            </cfquery>
                            <cfset paper_code = evaluate('get_main_paper.ASSET_no')>
                            <cfset paper_number = evaluate('get_main_paper.ASSET_number') +1>
                            <cfset system_paper_no2=paper_code & '-' & paper_number>
                            <cfset moduleName="hr">
                            <cfset moduleId=3>
                            <cfset actionSection="EMPLOYEES_APP_ID">
                            <cfset assetName = "CV-#arguments.careerName##arguments.careerSurname#">
                            <cfquery name="ADD_ASSET" datasource="#dsn#" result="GET_MAX_ASSET">
                                INSERT INTO 
                                    ASSET
                                (
                                    ASSETCAT_ID,
                                    IS_ACTIVE,	
                                    IS_SPECIAL,
                                    IS_INTERNET,
                                    ASSET_NO,
                                    MODULE_NAME,
                                    MODULE_ID,
                                    ACTION_SECTION,
                                    ACTION_ID,
                                    COMPANY_ID,
                                    ASSET_NAME,
                                    ASSET_FILE_NAME,
                                    ASSET_FILE_REAL_NAME,
                                    SERVER_NAME,
                                    ASSET_FILE_SIZE,
                                    ASSET_FILE_SERVER_ID,
                                    RECORD_EMP,
                                    RECORD_DATE,
                                    RECORD_IP,
                                    PROPERTY_ID
                                )
                                VALUES
                                (
                                    -8,
                                    1,	
                                    0,
                                    1,
                                    '#system_paper_no2#',
                                    '#moduleName#',
                                    #moduleId#,
                                    '#actionSection#',
                                    #career_result.IDENTITYCOL#,
                                    5,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#assetName#">,
                                    '#newFileName#',
                                    '#careerFile.CLIENTFILENAME#',
                                    '#cgi.http_host#',
                                    10,
                                    1,
                                    0,
                                    #now()#,
                                    '#cgi.remote_addr#',
                                    1
                                )
                            </cfquery>
                        </cftransaction>   
                    </cfif>
                </cfif>
            </cfif>
            <cfset result.status = true>
            <cfset result.success_message = warning>
            <cfset result.identity = "">
        <cfcatch type="any">
            <cfset result.status = false>
            <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
            <cfset result.error = cfcatch >
            <cfdump var="#cfcatch#">
        </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <!--- Küçük harfleri büyütüyoruz. --->
    <cffunction name="UCASETR" returntype="string" output="false">
    	<cfargument name="arguments_list" required="yes">
        <cfscript>
			var return_value = '';
			return_value = replacelist(arguments_list,'a,b,c,ç,d,e,f,g,ğ,h,ı,i,j,k,l,m,n,o,ö,p,r,s,ş,t,u,ü,v,w,y,z,q,x','A,B,C,Ç,D,E,F,G,Ğ,H,I,İ,J,K,L,M,N,O,Ö,P,R,S,Ş,T,U,Ü,V,W,Y,Z,Q,X');
		</cfscript>
        <cfreturn return_value>
    </cffunction>
</cfcomponent>