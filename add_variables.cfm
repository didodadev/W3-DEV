<!--- sadece "act_login" lerde include edilir --->
<cfset session_base = evaluate(attributes.session_text)>

<!---Order_row_reserved tablosunda  sessiondan dusmus kullanıcilarin sepete atilan urunlerinin silinmesi için eklendi.Lutfen yeri degistirilmesin --->
<cfif isdefined("fusebox.use_stock_speed_reserve") and fusebox.use_stock_speed_reserve>
	<cfinclude template="clear_order_row_reserved.cfm">
</cfif>

<!--- basketten eklenmiş ama belgesi kaydedilmemiş seri nolar silinir  --->
<cftry>
	<cfif isdefined("session.ep.userid")>
		<cfif isdefined("session_base.our_company_id") and len(session_base.our_company_id)>
			<cfset reserved_db = '#DSN#_#session_base.our_company_id#'>
		<cfelse>
			<cfset reserved_db = '#DSN#_#session_base.company_id#'> 
		</cfif>   
		<cfquery name="del_order_r" datasource="#reserved_db#">
			DELETE FROM SERVICE_GUARANTY_NEW WHERE WRK_ROW_ID IS NOT NULL AND PROCESS_ID = 0 AND RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
		</cfquery>
	</cfif>
	<cfcatch></cfcatch>
</cftry>

<!--- APPLICATION DB YE YAZILIR --->
<!--- SESSION DB YE YAZILIR --->
<cfquery name="ADD_WRK_SESSION_TO_DB" datasource="#DSN#">
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
        IS_COST_LOCATION,
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
		MEMBER_VIEW_CONTROL,
        IS_ADD_INFORMATIONS,
        IS_EFATURA,
		EFATURA_DATE,
		IS_ESHIPMENT,
		ESHIPMENT_DATE,
        IS_EDEFTER,
        IS_LOT_NO,
		START_DATE,
		FINISH_DATE,
        IS_EARCHIVE,
        EARCHIVE_DATE,
        IS_BRANCH_AUTHORIZATION,
		BROWSER_INFO,
		DATEFORMAT_STYLE,
		TIMEFORMAT_STYLE,
		MONEYFORMAT_STYLE,
		DOCK_PHONE,
		REPORT_USER_LEVEL,
		DATA_LEVEL,
		WORKTIPS_OPEN,
		ACTION_PAGE_Q_STRING,
		WEEK_START
	)
	VALUES
	(
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#CFID#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#CFTOKEN#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(session_base.workcube_id)#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.userid#">,
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
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.username#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.name#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.surname#">,
		<cfif isdefined("session_base.position_code")><cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.position_code#"><cfelse>NULL</cfif>,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.money#">,
		<cfqueryparam cfsqltype="cf_sql_float" value="#session_base.time_zone#">,
		<cfif isdefined("session_base.position_name")><cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.position_name#"><cfelse>NULL</cfif>,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.language#">,
		<cfif isdefined("session_base.design_id")><cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.design_id#"><cfelse>NULL</cfif>,
		<cfif isdefined("session_base.menu_id") and len(session_base.menu_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.menu_id#"><cfelse>0</cfif>,
		<cfif isdefined("session_base.design_color")><cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.design_color#"><cfelse>NULL</cfif>,
		<cfif isdefined("session_base.company_id")><cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#"><cfelse>NULL</cfif>,
		<cfif isdefined("session_base.company")><cfqueryparam cfsqltype="cf_sql_varchar" value="#left(session_base.company,200)#"><cfelse>NULL</cfif>,
		<cfif isdefined("session_base.company_email")><cfqueryparam cfsqltype="cf_sql_varchar" value="#left(session_base.company_email,50)#"><cfelse>NULL</cfif>,
		<cfif isdefined("session_base.company_nick")><cfqueryparam cfsqltype="cf_sql_varchar" value="#left(session_base.company_nick,75)#"><cfelse>NULL</cfif>,
		<cfif isdefined("session_base.ehesap")><cfqueryparam cfsqltype="cf_sql_bit" value="#session_base.ehesap#"><cfelse>NULL</cfif>,
		<cfif isdefined("session_base.maxrows")><cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.maxrows#"><cfelse>NULL</cfif>,
		<cfif isdefined("session_base.user_location")><cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.user_location#"><cfelse>NULL</cfif>,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.userkey#">,
		<cfif isdefined("session_base.period_id")><cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#"><cfelse>NULL</cfif>,
		<cfif isdefined("session_base.period_year")><cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_year#"><cfelse>#year(now())#</cfif>,
		<cfif isdefined("session_base.period_is_integrated") and len(session_base.period_is_integrated)><cfqueryparam cfsqltype="cf_sql_bit" value="#session_base.period_is_integrated#"><cfelse>0</cfif>,
		<cfif isdefined("session_base.user_level")><cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.user_level#"><cfelse>NULL</cfif>,
		<cfif isdefined("session_base.our_company_info.workcube_sector")><cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.our_company_info.workcube_sector#"><cfelse>NULL</cfif>,
		<cfif isdefined("session_base.our_company_info.is_paper_closer") and len(session_base.our_company_info.is_paper_closer)><cfqueryparam cfsqltype="cf_sql_bit" value="#session_base.our_company_info.is_paper_closer#"><cfelse>0</cfif>,
		<cfif isdefined("session_base.our_company_info.is_cost") and len(session_base.our_company_info.is_cost)><cfqueryparam cfsqltype="cf_sql_bit" value="#session_base.our_company_info.is_cost#"><cfelse>0</cfif>,
        <cfif isdefined("session_base.our_company_info.is_cost_location") and len(session_base.our_company_info.is_cost_location)><cfqueryparam cfsqltype="cf_sql_bit" value="#session_base.our_company_info.is_cost_location#"><cfelse>0</cfif>,
		'',
		<cfif isDefined("session.sessionid")>
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.sessionid#">,
		<cfelse>
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#cookie.jsessionid#">,
		</cfif>
		<cfif isdefined("session_base.our_company_id")><cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#"><cfelse>NULL</cfif>,
		<cfif isdefined("session_base.our_name")><cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.our_name#"><cfelse>NULL</cfif>,
		<cfif isdefined("session_base.our_nick")><cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.our_nick#"><cfelse>NULL</cfif>,
		<cfif isdefined("session_base.company_category")><cfqueryparam cfsqltype="cf_sql_int" value="#session_base.our_company_id#"><cfelse>NULL</cfif>,
		<cfif isdefined("session_base.admin") and len(session_base.admin)><cfqueryparam cfsqltype="cf_sql_bit" value="#session_base.admin#"><cfelse>0</cfif>,
		<cfif isdefined("session_base.power_user") and len(session_base.power_user)><cfqueryparam cfsqltype="cf_sql_bit" value="#session_base.power_user#"><cfelse>0</cfif>,
		<cfif isdefined("session_base.power_user_level_id") and len(session_base.power_user_level_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.power_user_level_id#"><cfelse>''</cfif>,
		<cfif isdefined("session_base.period_date") and len(session_base.period_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(session_base.period_date)#"><cfelse>NULL</cfif>,
		<cfif isdefined("session_base.process_date") and len(session_base.process_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(session_base.process_date)#"><cfelse>NULL</cfif>,
		<cfif isdefined("session_base.timeout_min") and len(session_base.timeout_min)><cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.timeout_min#"><cfelse>30</cfif>,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.fuseaction#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.fuseaction#">,
		<cfif isdefined("session_base.partner_or_consumer") and len(session_base.partner_or_consumer)><cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.partner_or_consumer#"><cfelse>NULL</cfif>,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		<cfif isdefined("session_base.our_company_info.guaranty_followup") and len(session_base.our_company_info.guaranty_followup)><cfqueryparam cfsqltype="cf_sql_bit" value="#session_base.our_company_info.guaranty_followup#"><cfelse>0</cfif>,
		<cfif isdefined("session_base.our_company_info.project_followup") and len(session_base.our_company_info.project_followup)><cfqueryparam cfsqltype="cf_sql_bit" value="#session_base.our_company_info.project_followup#"><cfelse>0</cfif>,
		<cfif isdefined("session_base.our_company_info.asset_followup") and len(session_base.our_company_info.asset_followup)><cfqueryparam cfsqltype="cf_sql_bit" value="#session_base.our_company_info.asset_followup#"><cfelse>0</cfif>,
		<cfif isdefined("session_base.our_company_info.sales_zone_followup") and len(session_base.our_company_info.sales_zone_followup)><cfqueryparam cfsqltype="cf_sql_bit" value="#session_base.our_company_info.sales_zone_followup#"><cfelse>0</cfif>,
		<cfif isdefined("session_base.our_company_info.sms") and len(session_base.our_company_info.sms)><cfqueryparam cfsqltype="cf_sql_bit" value="#session_base.our_company_info.sms#"><cfelse>0</cfif>,
		<cfif isdefined("session_base.our_company_info.unconditional_list") and len(session_base.our_company_info.unconditional_list)><cfqueryparam cfsqltype="cf_sql_bit" value="#session_base.our_company_info.unconditional_list#"><cfelse>0</cfif>,
		<cfif isdefined("session_base.authority_code_hr")><cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.authority_code_hr#"><cfelse>NULL</cfif>,
		<cfif isdefined("session_base.our_company_info.subscription_contract") and len(session_base.our_company_info.subscription_contract)><cfqueryparam cfsqltype="cf_sql_bit" value="#session_base.our_company_info.subscription_contract#"><cfelse>0</cfif>,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.money2#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_info.spect_type#">,
		<cfif isdefined("session_base.server_machine")><cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.server_machine#"><cfelse>NULL</cfif>,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.http_host#">,
		<cfif isdefined("session_base.our_company_info.is_ifrs")><cfqueryparam cfsqltype="cf_sql_bit" value="#session_base.our_company_info.is_ifrs#"><cfelse>0</cfif>,
		<cfif isdefined("session_base.our_company_info.rate_round_num")><cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_info.rate_round_num#"><cfelse>4</cfif>,
		<cfif isdefined("session_base.discount_valid") and len(session_base.discount_valid)><cfqueryparam cfsqltype="cf_sql_bit" value="#session_base.discount_valid#"><cfelse>0</cfif>,
		<cfif isdefined("session_base.price_display_valid") and len(session_base.price_display_valid)><cfqueryparam cfsqltype="cf_sql_bit" value="#session_base.price_display_valid#"><cfelse>0</cfif>,
		<cfif isdefined("session_base.cost_display_valid") and len(session_base.cost_display_valid)><cfqueryparam cfsqltype="cf_sql_bit" value="#session_base.cost_display_valid#"><cfelse>0</cfif>,
		<cfif isdefined("session_base.rate_valid") and len(session_base.rate_valid)><cfqueryparam cfsqltype="cf_sql_bit" value="#session_base.rate_valid#"><cfelse>0</cfif>,
		<cfif isdefined("session_base.price_valid") and len(session_base.price_valid)><cfqueryparam cfsqltype="cf_sql_bit" value="#session_base.price_valid#"><cfelse>0</cfif>,
		<cfif isdefined("session_base.duedate_valid") and len(session_base.duedate_valid)><cfqueryparam cfsqltype="cf_sql_bit" value="#session_base.duedate_valid#"><cfelse>0</cfif>,
		<cfif isdefined("session_base.consumer_priority") and len(session_base.consumer_priority)><cfqueryparam cfsqltype="cf_sql_bit" value="#session_base.consumer_priority#"><cfelse>0</cfif>,
		<cfif isdefined("session_base.our_company_info.is_maxrows_control_off") and len(session_base.our_company_info.is_maxrows_control_off)><cfqueryparam cfsqltype="cf_sql_bit" value="#session_base.our_company_info.is_maxrows_control_off#"><cfelse>0</cfif>,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
        <cfif isdefined("session_base.our_company_info.is_location_follow") and len(session_base.our_company_info.is_location_follow)><cfqueryparam cfsqltype="cf_sql_bit" value="#session_base.our_company_info.is_location_follow#"><cfelse>0</cfif>,
		<cfif isdefined("session_base.purchase_price_round_num") and len(session_base.purchase_price_round_num)><cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.purchase_price_round_num#"><cfelse>4</cfif>,
		<cfif isdefined("session_base.sales_price_round_num") and len(session_base.sales_price_round_num)><cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.sales_price_round_num#"><cfelse>2</cfif>,
		<cfif isdefined("session_base.is_prod_cost_type") and len(session_base.is_prod_cost_type)><cfqueryparam cfsqltype="cf_sql_bit" value="#session_base.is_prod_cost_type#"><cfelse>0</cfif>,
		<cfif isdefined("session_base.is_project_group") and len(session_base.is_project_group)><cfqueryparam cfsqltype="cf_sql_bit" value="#session_base.is_project_group#"><cfelse>0</cfif>,
		<cfif isdefined("session_base.special_menu_file") and len(session_base.special_menu_file)><cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.special_menu_file#"><cfelse>NULL</cfif>,
		<cfif isdefined("session_base.member_view_control") and len(session_base.member_view_control)>1<cfelse>0</cfif>,
        <cfif isdefined("session_base.our_company_info.is_add_informations") and len(session_base.our_company_info.is_add_informations)><cfqueryparam cfsqltype="cf_sql_bit" value="#session_base.our_company_info.is_add_informations#"><cfelse>0</cfif>,
        <cfif isdefined("session_base.our_company_info.is_efatura") and len(session_base.our_company_info.is_efatura)><cfqueryparam cfsqltype="cf_sql_bit" value="#session_base.our_company_info.is_efatura#"><cfelse>0</cfif>,
		<cfif isdefined("session_base.our_company_info.efatura_date") and len(session_base.our_company_info.efatura_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(session_base.our_company_info.efatura_date)#"><cfelse>0</cfif>,
		<cfif isdefined("session_base.our_company_info.is_eshipment") and len(session_base.our_company_info.is_eshipment)><cfqueryparam cfsqltype="cf_sql_bit" value="#session_base.our_company_info.is_eshipment#"><cfelse>0</cfif>,
		<cfif isdefined("session_base.our_company_info.eshipment_date") and len(session_base.our_company_info.eshipment_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(session_base.our_company_info.eshipment_date)#"><cfelse>0</cfif>,
        <cfif isdefined("session_base.our_company_info.is_edefter") and len(session_base.our_company_info.is_edefter)><cfqueryparam cfsqltype="cf_sql_bit" value="#session_base.our_company_info.is_edefter#"><cfelse>0</cfif>,
		<cfif isdefined("session_base.our_company_info.is_lot_no") and len(session_base.our_company_info.is_lot_no)><cfqueryparam cfsqltype="cf_sql_bit" value="#session_base.our_company_info.is_lot_no#"><cfelse>0</cfif>,
		<cfif isdefined("session_base.period_start_date") and len(session_base.period_start_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(session_base.period_start_date)#"><cfelse>NULL</cfif>,
		<cfif isdefined("session_base.period_finish_date") and len(session_base.period_finish_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(session_base.period_finish_date)#"><cfelse>NULL</cfif>,
        <cfif isdefined("session_base.our_company_info.is_earchive") and len(session_base.our_company_info.is_earchive)><cfqueryparam cfsqltype="cf_sql_bit" value="#session_base.our_company_info.is_earchive#"><cfelse>0</cfif>,
        <cfif isdefined("session_base.our_company_info.earchive_date") and len(session_base.our_company_info.earchive_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(session_base.our_company_info.earchive_date)#"><cfelse>NULL</cfif>,
		<cfqueryparam cfsqltype="cf_sql_bit" value="#session_base.isBranchAuthorization#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#browserdetect()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.dateformat_style#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.timeformat_style#">,
		<cfqueryparam cfsqltype="cf_sql_bit" value="#session_base.moneyformat_style#">,
		<cfif isdefined("session_base.dockphone") and len(session_base.dockphone)><cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.dockphone#"><cfelse>NULL</cfif>,
		<cfif isdefined("session_base.report_user_level") and len(session_base.report_user_level)><cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.report_user_level#"><cfelse>NULL</cfif>,
		<cfif isdefined("session_base.data_level") and len(session_base.data_level)><cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.data_level#"><cfelse>NULL</cfif>,
		<cfif isdefined("session_base.worktips_open") and len(session_base.worktips_open)><cfqueryparam cfsqltype="cf_sql_bit" value="#session_base.worktips_open#"><cfelse>NULL</cfif>,
		<cfqueryparam value = "#cgi.QUERY_STRING#" CFSQLType = "cf_sql_nvarchar">,
		<cfif isdefined("session_base.week_start") and len(session_base.week_start)><cfqueryparam cfsqltype="cf_sql_bit" value="#session_base.week_start#"><cfelse>NULL</cfif>
    )
</cfquery>