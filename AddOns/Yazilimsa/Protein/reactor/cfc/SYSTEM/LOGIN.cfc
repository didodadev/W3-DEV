<cfcomponent extends="cfc.queryJSONConverter">

    <cfheader name="Access-Control-Allow-Origin" value="*" />
    <cfheader name="Access-Control-Allow-Methods" value="GET,POST" />
    <cfheader name="Access-Control-Allow-Headers" value="Content-Type" /> 

    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset result = StructNew()>
    <cfset MAIN = createObject('component','cfc.SYSTEM.MAIN')>
    <cfset GET_SITE = MAIN.GET_SITE()>
    <cfset ACCESS_DATA = #deserializeJSON(GET_SITE.ACCESS_DATA)#>   
    <cffunction name="GET_SESSION" access="remote" returntype="query">
        <cfargument name="USERID" default="">
        <cfargument name="threeDGate_token" default="">
        <cfquery name="GET_SESSION_QUERY" datasource="#dsn#">
            SELECT
                * 
            FROM 
                WRK_SESSION
            WHERE 
                (CFTOKEN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cftoken#"> 
                AND CFID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cfid#">
                <cfif ACCESS_DATA.COMPANY.STATUS>                
                    AND USER_TYPE = 1               
                <cfelseif ACCESS_DATA.CONSUMER.STATUS>
                    AND USER_TYPE = 2 
                <cfelseif ACCESS_DATA.CARIER.STATUS>
                    AND USER_TYPE = 3 
                <cfelse>
                    AND USER_TYPE = -1
                </cfif>
                )
                <cfif isdefined("USERID") and len(USERID)>
                    OR USERID = <cfqueryparam cfsqltype="cf_sql_integer" value="#USERID#">
                </cfif>
                <cfif isdefined("threeDGate_token") and len(threeDGate_token)>
                    OR CFID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#int(threeDGate_token)#">
                </cfif>                
        </cfquery>
        <cfreturn GET_SESSION_QUERY>
    </cffunction>

    <cffunction name="GET_P_MENU_" returntype="query">
        <cfargument name="companycat_id" default="">
        <cfargument name="partner_id" default="">
        <cfquery name="GET_P_MENU" datasource="#dsn#" maxrows="1">
            SELECT 
                MMS.MENU_ID,
                MMS.LANGUAGE_ID,
                MMS.MENU_STYLE ,
                MMS.DEPARTMENT_IDS
            FROM 
                MAIN_MENU_SETTINGS MMS,
                COMPANY_CONSUMER_DOMAINS CCD
            WHERE 
                MMS.IS_ACTIVE = 1 AND 
                MMS.COMPANY_CAT_IDS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#companycat_id#%"> AND 
                MMS.SITE_DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.http_host#"> AND
                CCD.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#partner_id#">
            ORDER BY 
                MENU_ID DESC
        </cfquery>
        <cfreturn GET_P_MENU>
    </cffunction>

    <cffunction name="ADD_LAST_LOGIN_">
        <cfargument name="server_machine" default="000000">
        <cfargument name="userid" default="">
        <cfargument name="browser_info" default="NAN"> 
        <cfquery name="ADD_LAST_LOGIN_QUERY" datasource="#dsn#">
            INSERT INTO 
                WRK_LOGIN
            (
                SERVER_MACHINE,
                DOMAIN_NAME,
                PARTNER_ID,
                IN_OUT,
                IN_OUT_TIME,
                LOGIN_IP,
                LOGIN_BROWSER
            )
            VALUES
            (
                #server_machine#,
                '#cgi.http_host#',
                #userid#,
                1,
                #NOW()#,
                '#cgi.remote_addr#',
                '#browser_info#'
            )
        </cfquery>
    </cffunction>

    <cffunction name="ADD_WRK_SESSION_TO_DB_">
        <cfargument name="session_text" default="">
        <cfset session_base = evaluate(arguments.session_text)>        
        <cfquery name="ADD_WRK_SESSION_TO_DB_QUERY" datasource="#dsn#">
            INSERT INTO 
                WRK_SESSION
            (
                CFID,
                CFTOKEN,
                WORKCUBE_ID,
                USERID,
                USER_TYPE,
                USERNAME,
                NAME,
                SURNAME,
                POSITION_CODE,
                MONEY,
                TIME_ZONE,
                POSITION_NAME,
                LANGUAGE_ID,
                DESIGN_ID,
                MENU_ID,
                DESIGN_COLOR,
                COMPANY_ID,
                COMPANY,
                COMPANY_EMAIL,
                COMPANY_NICK,
                EHESAP,
                MAXROWS,
                USER_LOCATION,
                USERKEY,
                PERIOD_ID,
                PERIOD_YEAR,
                IS_INTEGRATED,
                USER_LEVEL,
                WORKCUBE_SECTOR,
                IS_PAPER_CLOSER,
                IS_COST,
                ERROR_TEXT,
                SESSIONID,
                OUR_COMPANY_ID,
                OUR_COMPANY,
                OUR_COMPANY_NICK,
                COMPANY_CATEGORY,
                ADMIN_STATUS,
                POWER_USER,
                POWER_USER_LEVEL_ID,
                PERIOD_DATE,
                PROCESS_DATE,
                TIMEOUT_MIN,
                ACTION_PAGE,
                FUSEACTION,
                PARTNER_OR_CONSUMER,
                USER_IP,
                IS_GUARANTY_FOLLOWUP,
                IS_PROJECT_FOLLOWUP,
                IS_ASSET_FOLLOWUP,
                IS_SALES_ZONE_FOLLOWUP,
                IS_SMS,
                IS_UNCONDITIONAL_LIST,
                AUTHORITY_CODE_HR,
                IS_SUBSCRIPTION_CONTRACT,
                MONEY2,
                SPECT_TYPE,
                SERVER_MACHINE,
                DOMAIN_NAME,
                IS_IFRS,
                RATE_ROUND_NUM,
                DISCOUNT_VALID,
                PRICE_DISPLAY_VALID,
                COST_DISPLAY_VALID,
                RATE_VALID,
                PRICE_VALID,
                DUEDATE_VALID,
                CONSUMER_PRIORITY,
                IS_MAXROWS_CONTROL_OFF,
                ACTION_DATE,
                IS_LOCATION_FOLLOW,
                PURCHASE_PRICE_ROUND_NUM,
                SALES_PRICE_ROUND_NUM,
                IS_PROD_COST_TYPE,
                IS_PROJECT_GROUP,
                SPECIAL_MENU_FILE,
                <!--- SCREEN_HEIGHT, --->
                MEMBER_VIEW_CONTROL,
                IS_ADD_INFORMATIONS,
                IS_EFATURA,
                START_DATE,
                FINISH_DATE
            )
            VALUES
            (
                '#CFID#',
                '#CFTOKEN#',
                '#trim(session_base.workcube_id)#',
                #session_base.userid#,
            <cfif isdefined("session.ep") or isdefined("session.mobile")>
                0,
            <cfelseif isdefined("session.pp")>
                1,
            <cfelseif isdefined("session.ww")>
                2,
            <cfelseif isdefined("session.cp")>
                3,
            <cfelseif isdefined("session.wp")>
                4,
            <cfelseif isdefined("session.pda")>
                5,
            <cfelse>
                2,
            </cfif>
                '#session_base.username#',
                '#session_base.name#',
                '#session_base.surname#',
                <cfif isdefined("session_base.position_code")>#session_base.position_code#<cfelse>NULL</cfif>,
                '#session_base.money#',
                #session_base.time_zone#,
                <cfif isdefined("session_base.position_name")>'#session_base.position_name#'<cfelse>NULL</cfif>,
                '#session_base.language#',
                <cfif isdefined("session_base.design_id")>#session_base.design_id#<cfelse>NULL</cfif>,
                <cfif isdefined("session_base.menu_id") and len(session_base.menu_id)>#session_base.menu_id#<cfelse>0</cfif>,
                <cfif isdefined("session_base.design_color")>#session_base.design_color#<cfelse>NULL</cfif>,
                <cfif isdefined("session_base.company_id")>#session_base.company_id#<cfelse>NULL</cfif>,
                <cfif isdefined("session_base.company")>'#left(session_base.company,200)#'<cfelse>NULL</cfif>,
                <cfif isdefined("session_base.company_email")>'#left(session_base.company_email,50)#'<cfelse>NULL</cfif>,
                <cfif isdefined("session_base.company_nick")>'#left(session_base.company_nick,75)#'<cfelse>NULL</cfif>,
                <cfif isdefined("session_base.ehesap")>#session_base.ehesap#<cfelse>NULL</cfif>,
                <cfif isdefined("session_base.maxrows")>#session_base.maxrows#<cfelse>NULL</cfif>,
                <cfif isdefined("session_base.user_location")>'#session_base.user_location#'<cfelse>NULL</cfif>,
                '#session_base.userkey#',
                <cfif isdefined("session_base.period_id")>#session_base.period_id#<cfelse>NULL</cfif>,
                <cfif isdefined("session_base.period_year")>#session_base.period_year#<cfelse>#year(now())#</cfif>,
                <cfif isdefined("session_base.period_is_integrated") and len(session_base.period_is_integrated)>#session_base.period_is_integrated#<cfelse>0</cfif>,
                <cfif isdefined("session_base.user_level")>'#session_base.user_level#'<cfelse>NULL</cfif>,
                <cfif isdefined("session_base.our_company_info.workcube_sector")>'#session_base.our_company_info.workcube_sector#'<cfelse>NULL</cfif>,
                <cfif isdefined("session_base.our_company_info.is_paper_closer") and len(session_base.our_company_info.is_paper_closer)>#session_base.our_company_info.is_paper_closer#<cfelse>0</cfif>,
                <cfif isdefined("session_base.our_company_info.is_cost") and len(session_base.our_company_info.is_cost)>#session_base.our_company_info.is_cost#<cfelse>0</cfif>,
                '',
                <cfif isDefined("session.sessionid")>
                '#session.sessionid#',
                <cfelse>
                '#cookie.jsessionid#',
                </cfif>
                <cfif isdefined("session_base.our_company_id")>'#session_base.our_company_id#'<cfelse>NULL</cfif>,
                <cfif isdefined("session_base.our_name")>'#session_base.our_name#'<cfelse>NULL</cfif>,
                <cfif isdefined("session_base.our_nick")>'#session_base.our_nick#'<cfelse>NULL</cfif>,
                <cfif isdefined("session_base.company_category")>'#session_base.our_company_id#'<cfelse>NULL</cfif>,
                <cfif isdefined("session_base.admin") and len(session_base.admin)>#session_base.admin#<cfelse>0</cfif>,
                <cfif isdefined("session_base.power_user") and len(session_base.power_user)>#session_base.power_user#<cfelse>0</cfif>,
                <cfif isdefined("session_base.power_user_level_id") and len(session_base.power_user_level_id)>'#session_base.power_user_level_id#'<cfelse>''</cfif>,
                <cfif isdefined("session_base.period_date") and len(session_base.period_date)>#createodbcdatetime(session_base.period_date)#<cfelse>NULL</cfif>,
                <cfif isdefined("session_base.process_date") and len(session_base.process_date)>#createodbcdatetime(session_base.process_date)#<cfelse>NULL</cfif>,
                <cfif isdefined("session_base.timeout_min") and len(session_base.timeout_min)>#session_base.timeout_min#<cfelse>30</cfif>,
                null,
                null,
                <cfif isdefined("session_base.partner_or_consumer") and len(session_base.partner_or_consumer)>'#session_base.partner_or_consumer#'<cfelse>NULL</cfif>,
                <!--- <cfif isdefined("session_base.user_ip") and len(session_base.user_ip)>'#session_base.user_ip#'<cfelse>NULL</cfif>, --->
                '#cgi.remote_addr#',
                <cfif isdefined("session_base.our_company_info.guaranty_followup") and len(session_base.our_company_info.guaranty_followup)>#session_base.our_company_info.guaranty_followup#<cfelse>0</cfif>,
                <cfif isdefined("session_base.our_company_info.project_followup") and len(session_base.our_company_info.project_followup)>#session_base.our_company_info.project_followup#<cfelse>0</cfif>,
                <cfif isdefined("session_base.our_company_info.asset_followup") and len(session_base.our_company_info.asset_followup)>#session_base.our_company_info.asset_followup#<cfelse>0</cfif>,
                <cfif isdefined("session_base.our_company_info.sales_zone_followup") and len(session_base.our_company_info.sales_zone_followup)>#session_base.our_company_info.sales_zone_followup#<cfelse>0</cfif>,
                <cfif isdefined("session_base.our_company_info.sms") and len(session_base.our_company_info.sms)>#session_base.our_company_info.sms#<cfelse>0</cfif>,
                <cfif isdefined("session_base.our_company_info.unconditional_list") and len(session_base.our_company_info.unconditional_list)>#session_base.our_company_info.unconditional_list#<cfelse>0</cfif>,
                <cfif isdefined("session_base.authority_code_hr")>'#session_base.authority_code_hr#'<cfelse>NULL</cfif>,
                <cfif isdefined("session_base.our_company_info.subscription_contract") and len(session_base.our_company_info.subscription_contract)>#session_base.our_company_info.subscription_contract#<cfelse>0</cfif>,
                '#session_base.money2#',
                #session_base.our_company_info.spect_type#,
                <cfif isdefined("session_base.server_machine")>NULL<cfelse>NULL</cfif>,
                '#cgi.http_host#',
                <cfif isdefined("session_base.our_company_info.is_ifrs")>#session_base.our_company_info.is_ifrs#<cfelse>0</cfif>,
                <cfif isdefined("session_base.our_company_info.rate_round_num")>#session_base.our_company_info.rate_round_num#<cfelse>4</cfif>,
                <cfif isdefined("session_base.discount_valid") and len(session_base.discount_valid)>#session_base.discount_valid#<cfelse>0</cfif>,
                <cfif isdefined("session_base.price_display_valid") and len(session_base.price_display_valid)>#session_base.price_display_valid#<cfelse>0</cfif>,
                <cfif isdefined("session_base.cost_display_valid") and len(session_base.cost_display_valid)>#session_base.cost_display_valid#<cfelse>0</cfif>,
                <cfif isdefined("session_base.rate_valid") and len(session_base.rate_valid)>#session_base.rate_valid#<cfelse>0</cfif>,
                <cfif isdefined("session_base.price_valid") and len(session_base.price_valid)>#session_base.price_valid#<cfelse>0</cfif>,
                <cfif isdefined("session_base.duedate_valid") and len(session_base.duedate_valid)>#session_base.duedate_valid#<cfelse>0</cfif>,
                <cfif isdefined("session_base.consumer_priority") and len(session_base.consumer_priority)>#session_base.consumer_priority#<cfelse>0</cfif>,
                <cfif isdefined("session_base.our_company_info.is_maxrows_control_off") and len(session_base.our_company_info.is_maxrows_control_off)>#session_base.our_company_info.is_maxrows_control_off#<cfelse>0</cfif>,
                #now()#,
                <cfif isdefined("session_base.our_company_info.is_location_follow") and len(session_base.our_company_info.is_location_follow)>#session_base.our_company_info.is_location_follow#<cfelse>0</cfif>,
                <cfif isdefined("session_base.purchase_price_round_num") and len(session_base.purchase_price_round_num)>#session_base.purchase_price_round_num#<cfelse>4</cfif>,
                <cfif isdefined("session_base.sales_price_round_num") and len(session_base.sales_price_round_num)>#session_base.sales_price_round_num#<cfelse>2</cfif>,
                <cfif isdefined("session_base.is_prod_cost_type") and len(session_base.is_prod_cost_type)>#session_base.is_prod_cost_type#<cfelse>0</cfif>,
                <cfif isdefined("session_base.is_project_group") and len(session_base.is_project_group)>#session_base.is_project_group#<cfelse>0</cfif>,
                <cfif isdefined("session_base.special_menu_file") and len(session_base.special_menu_file)>'#session_base.special_menu_file#'<cfelse>NULL</cfif>,
                <!--- <cfif isdefined("session_base.screen_height") and len(session_base.screen_height)>#session_base.screen_height#<cfelse>-1</cfif>, --->
                <cfif isdefined("session_base.view_member_control") and len(session_base.view_member_control)>1<cfelse>0</cfif>,
                <cfif isdefined("session_base.our_company_info.is_add_informations") and len(session_base.our_company_info.is_add_informations)>#session_base.our_company_info.is_add_informations#<cfelse>0</cfif>,
                <cfif isdefined("session_base.our_company_info.is_efatura") and len(session_base.our_company_info.is_efatura)>#session_base.our_company_info.is_efatura#<cfelse>0</cfif>,
                <cfif isdefined("session_base.period_start_date") and len(session_base.period_start_date)>#createodbcdatetime(session_base.period_start_date)#<cfelse>NULL</cfif>,
                <cfif isdefined("session_base.period_finish_date") and len(session_base.period_finish_date)>#createodbcdatetime(session_base.period_finish_date)#<cfelse>NULL</cfif>
            )
        </cfquery>
    </cffunction>

    <cffunction name="LOGIN_PP" access="remote" returnFormat="json">
            <cfargument name="username" default="">
            <cfargument name="member_password" default="">
            <cfargument name="member_code" default="">
            <cfargument name="userid" default="">
            <cfargument name="threeDGateLogin" default="">           
            <cftry>                
                <cfquery name="login" datasource="#dsn#">
                    SELECT
                        COMPANY.NICKNAME,
                        COMPANY.FULLNAME,
                        COMPANY.COMPANYCAT_ID,
                        COMPANY_PARTNER.COMPANY_ID,
                        COMPANY_PARTNER.PARTNER_ID, 
                        MY_SETTINGS_P.TIME_ZONE,
                        MY_SETTINGS_P.LANGUAGE_ID,
                        MY_SETTINGS_P.LOGIN_TIME,
                        MY_SETTINGS_P.MAXROWS,
                        MY_SETTINGS_P.TIMEOUT_LIMIT,
                        COMPANY_PARTNER.COMPANY_PARTNER_NAME,
                        COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
                        COMPANY_PARTNER.COMPANY_PARTNER_USERNAME,
                        COMPANY_PARTNER.COMPANY_PARTNER_PASSWORD,
                        COMPANY_PARTNER.COMPANY_PARTNER_EMAIL,
                        SETUP_PERIOD.PERIOD_ID,
                        SETUP_PERIOD.PERIOD_YEAR,
                        SETUP_PERIOD.OUR_COMPANY_ID,
                        SETUP_PERIOD.OTHER_MONEY,
                        SETUP_PERIOD.STANDART_PROCESS_MONEY,
                        OUR_COMPANY.COMPANY_NAME,
                        OUR_COMPANY.EMAIL,
                        OUR_COMPANY.NICK_NAME,
                        OUR_COMPANY_INFO.SPECT_TYPE,
                        OUR_COMPANY_INFO.IS_USE_IFRS,
                        OUR_COMPANY_INFO.RATE_ROUND_NUM,
                        ISNULL((SELECT TOP 1 WRK_MESSAGE.RECEIVER_ID FROM WRK_MESSAGE WHERE WRK_MESSAGE.RECEIVER_ID = COMPANY_PARTNER.PARTNER_ID AND WRK_MESSAGE.RECEIVER_TYPE = 1),0) AS CONTROL_MESSAGE,
                        SETUP_MONEY.MONEY
                    FROM 
                        COMPANY_PARTNER,
                        COMPANY,
                        COMPANY_PERIOD,
                        MY_SETTINGS_P,
                        SETUP_PERIOD,
                        SETUP_MONEY,
                        OUR_COMPANY,
                        OUR_COMPANY_INFO
                    WHERE
                        COMPANY.COMPANY_ID = COMPANY_PERIOD.COMPANY_ID AND
                        COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND                        
                        COMPANY_PARTNER.COMPANY_PARTNER_STATUS = 1 AND
                        COMPANY.COMPANY_STATUS = 1 AND
                        COMPANY.ISPOTANTIAL = 0 AND                        
                        COMPANY_PARTNER.PARTNER_ID = MY_SETTINGS_P.PARTNER_ID AND
                        OUR_COMPANY.COMP_ID = OUR_COMPANY_INFO.COMP_ID AND
                        SETUP_PERIOD.OUR_COMPANY_ID = OUR_COMPANY.COMP_ID AND
                        <!---- SETUP_PERIOD.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#default_company_id_#"> AND ---->
                        SETUP_PERIOD.PERIOD_YEAR = #year(now())# AND
                        COMPANY_PERIOD.PERIOD_ID = SETUP_PERIOD.PERIOD_ID AND
                        SETUP_MONEY.RATE1 = SETUP_MONEY.RATE2 AND
                        SETUP_MONEY.PERIOD_ID = SETUP_PERIOD.PERIOD_ID AND
                        <cfif isdefined("threeDGateLogin") AND threeDGateLogin EQ 1>
                            (
                                COMPANY_PARTNER.COMPANY_PARTNER_USERNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#username#"> AND
                                COMPANY_PARTNER.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#userid#">
                             )
                        <cfelse>
                            COMPANY.MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#member_code#"> AND
                            COMPANY_PARTNER.COMPANY_PARTNER_USERNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#username#"> AND
                            COMPANY_PARTNER.COMPANY_PARTNER_PASSWORD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#member_password#">
                        </cfif>
                </cfquery>            
                <cfquery name="DEL_WRK_APP" datasource="#dsn#">
                    DELETE FROM WRK_SESSION WHERE USERID = <cfqueryparam cfsqltype="cf_sql_integer" value="#login.partner_id#"> AND USER_TYPE = 1
                    DELETE FROM WRK_SESSION WHERE CFTOKEN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CFTOKEN#"> AND CFID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CFID#">
                </cfquery>
                <cfset get_p_menu = GET_P_MENU_(login.companycat_id,login.partner_id)>
                <cfscript>
                    session.pp = StructNew();
                    session.pp.userid = login.partner_id;
                    session.pp.username = login.company_partner_username;
                    session.pp.userkey = "p-#login.partner_id#";
                    session.pp.money = login.money;
                    session.pp.money2 = login.other_money;
                    if(len(login.standart_process_money))
                        session.pp.other_money = login.standart_process_money;
                    else
                        session.pp.other_money = login.other_money;
                    session.pp.company_id = login.company_id;
                    session.pp.company = login.fullname;
                    session.pp.company_nick = login.nickname;
                    session.pp.company_category = login.companycat_id;
                    session.pp.name = login.company_partner_name;
                    session.pp.surname = login.company_partner_surname;
                    session.pp.email = login.company_partner_email;
                    session.pp.our_name = login.company_name;
                    session.pp.our_company_email = login.email;
                    session.pp.our_nick = login.nick_name;
                    session.pp.our_company_id = GET_SITE.COMPANY;
                    session.pp.time_zone = login.time_zone;
                    session.pp.language = login.language_id;
                    session.pp.period_id = login.period_id;
                    session.pp.period_year = login.period_year;
                    session.pp.maxrows = login.maxrows;
                    if(isDefined("session.SESSIONID"))
                        session.pp.workcube_id = session.SESSIONID;
                    else
                        session.pp.workcube_id = cookie.JSESSIONID;
                    session.pp.our_company_info = StructNew();
                    session.pp.our_company_info.spect_type = login.spect_type;
                    session.pp.our_company_info.is_ifrs = login.is_use_ifrs;
                    session.pp.our_company_info.rate_round_num = login.rate_round_num;
                    session.pp.timeout_min = login.timeout_limit;
                    session.pp.menu_id = get_p_menu.menu_id;
                    session.pp.is_order_closed = 0;//siparişin ödemesi kontrolu içim eklendi
                    session.pp.list_type = '';
                    session.pp.department_ids = get_p_menu.DEPARTMENT_IDS;
                    session.pp.member_type = 'partner';
                </cfscript>
                <cfset ADD_LAST_LOGIN = ADD_LAST_LOGIN_(userid:session.pp.userid)>
                <cfset ADD_WRK_SESSION_TO_DB = ADD_WRK_SESSION_TO_DB_(session_text:"session.pp")>
                <cfset response = true>
                <cfcatch type="any">
                    <cfdump  var="#cfcatch#">
                    <cfset response = false>
                </cfcatch>  
            </cftry>
            <cfreturn response>            
    </cffunction>

    <cffunction name="get_login_control_pp" returntype="query">
        <cfargument name="member_code" default=""/>
        <cfargument name="username" default="">
        <cfargument name="member_password" default="">
        <cfquery name="LOGIN_CONTROL" datasource="#dsn#">
                SELECT
                    COMPANY_PARTNER.PARTNER_ID
                FROM
                    COMPANY_PARTNER,
                    COMPANY
                WHERE
                    COMPANY.MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#member_code#"> AND 
                    COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
                    COMPANY_PARTNER.COMPANY_PARTNER_USERNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#username#"> AND
                    COMPANY_PARTNER.COMPANY_PARTNER_PASSWORD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#member_password#">
        </cfquery>
        <cfreturn LOGIN_CONTROL/>
    </cffunction>

    <cffunction name="GET_PERIOD_YEAR_" returntype="query">
        <cfargument name="period_id" default="">
        <cfquery name="GET_PERIOD_YEAR" datasource="#dsn#">
            SELECT PERIOD_YEAR,IS_INTEGRATED,PERIOD_DATE FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#period_id#">
        </cfquery>
        <cfreturn GET_PERIOD_YEAR>
    </cffunction>

    <cffunction name="LOGIN_CP" access="remote" returnFormat="json">
        <cfargument name="username" default="">
        <cfargument name="member_password" default="">
        <cftry>
            <cfset response = true>
            <cfquery name="LOGIN" datasource="#dsn#">
                SELECT
                    EA.EMPAPP_ID,
                    EA.NAME,
                    EA.SURNAME,
                    EA.EMAIL,
                    EA.EMPAPP_PASSWORD,
                    O.COMPANY_NAME,
                    O.EMAIL AS OUR_COMPANY_EMAIL,
                    O.NICK_NAME,
                    SP.PERIOD_YEAR,
                    SP.PERIOD_ID,
                    SM.MONEY,
                    OI.SPECT_TYPE
                FROM
                    EMPLOYEES_APP EA,
                    OUR_COMPANY O,
                    SETUP_PERIOD SP,
                    SETUP_MONEY SM,
                    OUR_COMPANY_INFO OI
                WHERE
                    EA.EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#username#"> AND
                    EA.EMPAPP_PASSWORD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#member_password#"> AND
                    SP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_SITE.COMPANY#"> AND
                    O.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_SITE.COMPANY#"> AND
                    SP.PERIOD_YEAR = #year(now())# AND
                    SP.PERIOD_ID = SM.PERIOD_ID AND
                    SM.RATE1 = SM.RATE2 AND
                    OI.COMP_ID = O.COMP_ID
            </cfquery> 
            <cfquery name="DEL_WRK_APP" datasource="#dsn#">
                DELETE FROM WRK_SESSION WHERE USERID = <cfqueryparam cfsqltype="cf_sql_integer" value="#login.EMPAPP_ID#"> AND USER_TYPE = 3
                DELETE FROM WRK_SESSION WHERE CFTOKEN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CFTOKEN#"> AND CFID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CFID#">
            </cfquery>
            <cfscript>
                session.cp = StructNew();
                session.cp.userid = login.empapp_id;
                session.cp.username = login.email;
                session.cp.userkey = "i-#login.empapp_id#";
                session.cp.money = "#login.money#";
                session.cp.money2 = "EURO";
                session.cp.name = login.name;
                session.cp.email = login.email;
                session.cp.surname = login.surname;
                session.cp.time_zone = 3;
                session.cp.language = "tr";
                session.cp.period_year = login.period_year;
                session.cp.our_company_id = GET_SITE.COMPANY;
                session.cp.company_id = GET_SITE.COMPANY;
                session.cp.our_name = login.company_name;
                session.cp.our_company_email = login.our_company_email;
                session.cp.our_nick = login.nick_name;
                session.cp.period_id = login.period_id;
                session.cp.maxrows = 20;
                session.cp.timeout_min = 60;
                session.cp.workcube_id = listlast(cgi.HTTP_COOKIE,'=');
                session.cp.our_company_info = StructNew();
                session.cp.our_company_info.spect_type = login.spect_type;
                session.cp.user_ip = cgi.remote_addr;
                session.cp.server_machine = '';
                session.cp.member_type = 'employee';
            </cfscript>
            
            <cfset GET_PERIOD_YEAR = GET_PERIOD_YEAR_(login.period_id)>
        
            <cfif len(get_period_year.period_date)>
                <cfset session.cp.period_date =dateformat(get_period_year.period_date,'yyyy-mm-dd')>	
            <cfelse>
                <cfset session.cp.period_date = "#get_period_year.period_year#-01-01">
            </cfif>
            <cfset ADD_WRK_SESSION_TO_DB = ADD_WRK_SESSION_TO_DB_(session_text:"session.cp")>
            <cfcatch type="any">
                <cfdump  var="#cfcatch#">
                <cfset response = false>
            </cfcatch>  
        </cftry>
        <cfreturn response>
    </cffunction>
    
    <cffunction name="get_login_control_cp" returntype="query">
        <cfargument name="username" default="">
        <cfargument name="member_password" default="">
        <cfquery name="LOGIN_CONTROL" datasource="#dsn#">
            SELECT
                EA.EMPAPP_ID,
                EA.NAME,
                EA.SURNAME,
                EA.EMAIL,
                EA.EMPAPP_PASSWORD,
                O.COMPANY_NAME,
                O.EMAIL,
                O.NICK_NAME,
                SP.PERIOD_YEAR,
                SP.PERIOD_ID,
                SM.MONEY,
                OI.SPECT_TYPE
            FROM
                EMPLOYEES_APP EA,
                OUR_COMPANY O,
                SETUP_PERIOD SP,
                SETUP_MONEY SM,
                OUR_COMPANY_INFO OI
            WHERE
                EA.EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#username#"> AND
                EA.EMPAPP_PASSWORD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#member_password#"> AND
                SP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_SITE.COMPANY#"> AND
                O.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_SITE.COMPANY#"> AND
                SP.PERIOD_YEAR = #year(now())# AND
                SP.PERIOD_ID = SM.PERIOD_ID AND
                SM.RATE1 = SM.RATE2 AND
                OI.COMP_ID = O.COMP_ID
        </cfquery>
        <cfreturn LOGIN_CONTROL/>
    </cffunction>

    <cffunction name="LOGIN_WW" access="remote" returnFormat="json">
        <cfreturn 1>
    </cffunction>

    <cffunction name="GET_LOGIN_CONTROL" access="remote" returntype="string" returnFormat="json">        
        <cftry>
            <cfset arguments_content = deserializeJSON(getHttpRequestData().content)> 
            <cfscript>
                StructAppend(arguments,arguments_content,true);
            </cfscript>
            
            <cfset arguments.member_password = hash(arguments.member_password, "SHA-256", "UTF-8")>
            
            <!--- OTURUMU AÇ --->
            <cfif ACCESS_DATA.PUBLIC.STATUS>
                PU
            <cfelseif ACCESS_DATA.CONSUMER.STATUS>
                ww
            <cfelseif ACCESS_DATA.COMPANY.STATUS>
                <!--- pp --->
                <cfset login_control = get_login_control_pp(member_code:arguments.member_code,username:arguments.username,member_password:arguments.member_password)>                
                <cfif login_control.RecordCount>
                    <cfset WRK_SESSION_CONTROL = GET_SESSION(USERID:login_control.PARTNER_ID).RecordCount> 
                    <cfif WRK_SESSION_CONTROL EQ 0 OR arguments.force_login EQ 1>
                        <cfset default_company_id_ = GET_SITE.COMPANY>
                        <cfset login_ = LOGIN_PP(
                            member_code:arguments.member_code,
                            username:arguments.username,
                            member_password:arguments.member_password,
                            default_company_id_:default_company_id_
                        )>
                        <cfif login_>
                            <cfset result.status = true>
                            <cfset result.process = 200 ><!--- Başarılı --->
                        <cfelse>
                            <cfset result.status = false>
                            <cfset result.process = 203 ><!--- FN LOGIN_PP--->
                            <cfset result.error = 203 >                           
                        </cfif>
                    <cfelse>
                        <cfset result.status = true>
                        <cfset result.process = 201 ><!--- Askıda, Kullanıcı Şuan İçeride --->
                    </cfif>
                <cfelse>
                    <cfset result.status = true>
                    <cfset result.process = 202><!--- Kullanıcı Bilgileri Hatalı --->
                </cfif>
            <cfelseif ACCESS_DATA.CARIER.STATUS>
                <cfset login_control = get_login_control_cp(username:arguments.username,member_password:arguments.member_password)>                
                <cfif login_control.RecordCount>
                    <cfset WRK_SESSION_CONTROL = GET_SESSION(USERID:login_control.EMPAPP_ID).RecordCount>
                    <cfif WRK_SESSION_CONTROL EQ 0 OR arguments.force_login EQ 1>
                        <cfset login_ = LOGIN_CP(
                            username:arguments.username,
                            member_password:arguments.member_password
                        )>
                        <cfif login_>
                            <cfset result.status = true>
                            <cfset result.process = 200 ><!--- Başarılı --->
                        <cfelse>
                            <cfset result.status = false>
                            <cfset result.process = 203 ><!--- FN LOGIN_PP--->
                            <cfset result.error = 203 >                           
                        </cfif>
                    <cfelse>
                        <cfset result.status = true>
                        <cfset result.process = 201 ><!--- Askıda, Kullanıcı Şuan İçeride --->
                    </cfif>
                <cfelse>
                    <cfset result.status = true>
                    <cfset result.process = 202><!--- Kullanıcı Bilgileri Hatalı --->
                </cfif>
                <!--- CP --->
            </cfif>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.process = 204 >
                <cfset result.error = cfcatch.message>
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="LOGIN_threeDGate" access="remote" returntype="string">
        <cfset default_company_id_ = GET_SITE.COMPANY>        
        <cfset threeDGate_token= #decrypt(arguments.threeDGate,'protein_3d','CFMX_COMPAT','Hex')#>
        <cfset WRK_SESSION_CONTROL = GET_SESSION(threeDGate_token:threeDGate_token)> 
        <cfif WRK_SESSION_CONTROL.RecordCount>
            <cfset login_ = LOGIN_PP(
                username:WRK_SESSION_CONTROL.USERNAME,
                userid:WRK_SESSION_CONTROL.USERID,
                threeDGateLogin:1,
                default_company_id_:default_company_id_
            )>
        </cfif>
        <cfreturn "">
    </cffunction>   
    
    <cffunction name="maintenance_view" access="remote" returntype="string" returnFormat="json">        
        <cftry>
            <cfset arguments_content = deserializeJSON(getHttpRequestData().content)> 
            <cfscript>
                StructAppend(arguments,arguments_content,true);
            </cfscript>
            <cfset PRIMARY_DATA = #deserializeJSON(GET_SITE.PRIMARY_DATA)#>
            <cfif PRIMARY_DATA.MAINTENANCE_PASSWORD EQ arguments.maintenance_password>                
                <cfset session.MAINTENANCE_PASSWORD = arguments.maintenance_password>
                <cfset result.status = true>
                <cfset result.process = 200 ><!--- Başarılı --->
            <cfelse>
                <cfset result.status = true>
                <cfset result.process = 202 ><!--- Yanlış Parola --->
            </cfif>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.process = 203 >
                <cfset result.error = cfcatch.message>
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="admin_view" access="remote" returntype="string" returnFormat="json">        
        <cftry>
            <cfset arguments_content = deserializeJSON(getHttpRequestData().content)> 
            <cfscript>
                StructAppend(arguments,arguments_content,true);
            </cfscript>
            <cfset PRIMARY_DATA = #deserializeJSON(GET_SITE.PRIMARY_DATA)#>
            <cfif PRIMARY_DATA.MAINTENANCE_PASSWORD EQ arguments.admin_password>     
                <cfset session.ADMIN_PASSWORD = arguments.admin_password>
                <cfset result.status = true>
                <cfset result.process = 200 ><!--- Başarılı --->
            <cfelse>
                <cfset result.status = true>
                <cfset result.process = 202 ><!--- Yanlış Parola --->
            </cfif>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.process = 203 >
                <cfset result.error = cfcatch.message>
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="logOut" access="remote" returntype="any">
    
        <cfquery name="DEL_WRK_SESSION" datasource="#dsn#">
            DELETE FROM WRK_SESSION WHERE 
            <cfif isdefined("session.ep") or isdefined("session.mobile")>
                USERID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
            <cfelseif isdefined("session.pp")>
                USERID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
            <cfelseif isdefined("session.ww")>
                USERID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
            <cfelseif isdefined("session.cp")>
                USERID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
            <cfelseif isdefined("session.wp")>
                USERID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.wp.userid#">
            </cfif>
        </cfquery>
        <cfloop collection="#session#" item="key_field">
            <cfscript>
            if ((key_field neq 'error_text') and (key_field neq 'sessionid') and (key_field neq 'urltoken'))
                StructDelete(session,key_field);
            </cfscript>
        </cfloop>
        
	    <cfreturn 1>    
    </cffunction>

    <cffunction name="logOutAdmin" access="remote" returntype="any">
        <cfset session.ADMIN_PASSWORD = "">  
        <cfreturn 1>    
    </cffunction>
    
</cfcomponent>