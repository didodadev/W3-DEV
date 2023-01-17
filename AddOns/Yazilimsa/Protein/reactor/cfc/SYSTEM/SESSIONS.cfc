<cfcomponent extends="cfc.queryJSONConverter">

    <cfheader name="Access-Control-Allow-Origin" value="*" />
    <cfheader name="Access-Control-Allow-Methods" value="GET,POST" />
    <cfheader name="Access-Control-Allow-Headers" value="Content-Type" /> 
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset result = StructNew()>

    <cffunction name="GET_SESSION" access="remote" returntype="query">
        <cfquery name="GET_SESSION" datasource="#dsn#">
            SELECT * FROM WRK_SESSION WHERE CFTOKEN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cftoken#"> AND CFID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cfid#">
        </cfquery>
        <cfreturn GET_SESSION>
    </cffunction>

    <cffunction name="UPDATE_SESSION" access="remote" returntype="void">
        <cfargument name="token" type="string" required="true">
        <cfargument name="id" type="string" required="true">

        <cfquery name="UPDATE_SESSION" datasource="#dsn#">
            UPDATE WRK_SESSION 
            SET CFTOKEN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cftoken#">, CFID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cfid#">
            WHERE CFTOKEN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.token#"> 
            AND CFID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#">
        </cfquery>
    </cffunction>

    <cffunction name="SIGN_OF_LIFE_UPDATE" access="remote" returntype="void" hint="kullanıcı yaşam belirtisi günceller.">  
        <cfquery name="SIGN_OF_LIFE_UPDATE" datasource="#dsn#">
            UPDATE 
                WRK_SESSION 
            SET 
                ACTION_DATE = #NOW()#
            WHERE 
                CFTOKEN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CFTOKEN#"> 
                AND CFID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CFID#">             
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

    <cffunction name="GET_BASE_SESSION" access="remote" returntype="struct">
        <cfset uid = int(rand()*9999999)>
        <cfquery name="GET_SITE" datasource="#dsn#">
            SELECT * FROM PROTEIN_SITES WHERE DOMAIN LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#cgi.SERVER_NAME#%">
        </cfquery>
        <cfquery name="GET_BASE_SESSION" datasource="#dsn#">
           SELECT
                SP.PERIOD_ID,
                SP.PERIOD_YEAR,
                SP.OUR_COMPANY_ID,
                SP.OUR_COMPANY_ID AS COMPANY_ID,
                SP.OTHER_MONEY,
                SP.STANDART_PROCESS_MONEY,
                OC.COMPANY_NAME,
                OC.EMAIL,
                OC.NICK_NAME,
                OCI.SPECT_TYPE,
                OCI.IS_USE_IFRS,
                OCI.RATE_ROUND_NUM,
                SM.MONEY,
                SP.OTHER_MONEY MONEY2,
                SP.OTHER_MONEY,
                SP.PERIOD_YEAR,
                'tr' language,
                3 TIME_ZONE,
			    25 MAXROWS,
                'q-#uid#' USERKEY,
                'q' USERTYPE,
                '#uid#' USERID,
                '' NAME,
                '' SURNAME,
                '' USERNAME,
                '' EMAIL
            FROM
                OUR_COMPANY OC
                LEFT JOIN OUR_COMPANY_INFO OCI ON OC.COMP_ID = OCI.COMP_ID
                LEFT JOIN SETUP_PERIOD SP ON OC.COMP_ID = SP.OUR_COMPANY_ID
                LEFT JOIN SETUP_MONEY SM ON SP.PERIOD_ID = SM.PERIOD_ID
            WHERE
                SP.PERIOD_YEAR = #year(now())# AND
                SM.RATE1 = SM.RATE2 AND
                OC.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_SITE.COMPANY#">
        </cfquery>
        <cfset session.qq = GET_BASE_SESSION>
        <!--- <cfset ADD_WRK_SESSION_TO_DB = ADD_WRK_SESSION_TO_DB_(session_text:"session.qq")> --->
        <cfreturn QueryGetRow(GET_BASE_SESSION,1)>
    </cffunction>

    <cffunction name="GET_LANGUAGE" access="remote" returntype="query">
        <cfquery name="GET_LANGUAGE" datasource="#dsn#">
            SELECT LANGUAGE_SET,LANGUAGE_SHORT FROM SETUP_LANGUAGE WHERE IS_ACTIVE = 1
        </cfquery>
        <cfreturn GET_LANGUAGE>
    </cffunction>
</cfcomponent>