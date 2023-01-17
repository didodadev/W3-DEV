<cfcomponent extends = "app.component.base">

    <cfset dsn = this.getSystemParam().dsn />
	<cfset whops_company_id = this.getSystemParam().whops.our_company_id />

    <cffunction name="login" access="remote" returntype="any" returnFormat="JSON">
        <cfargument name="pos_code" required="yes"/>
		<cfargument name="employee_username" required="yes"/>
		<cfargument name="employee_password" required="yes"/>
		<cfargument name="language" default="tr"/>
		<cfargument name="screen_width" default=""/>
		<cfargument name="screen_height" default=""/>

        <cfset response = structNew()/>
        <cf_cryptedpassword password="#arguments.employee_password#" output="employee_password">
        
        <cfquery name="get_employee_login" datasource="#dsn#">
			SELECT 
				EMPLOYEES.EMPLOYEE_ID,
				EMPLOYEES.EMPLOYEE_USERNAME,
				EMPLOYEES.EMPLOYEE_PASSWORD,
				EMPLOYEES.IP_ADDRESS,
				EMPLOYEES.IS_IP_CONTROL,
				EMPLOYEES.WORKTIPS_OPEN,
				EMPLOYEE_POSITIONS.POSITION_CODE,
				EMPLOYEE_POSITIONS.POSITION_ID,
				EMPLOYEE_POSITIONS.POSITION_CAT_ID,
				EMPLOYEE_POSITIONS.POSITION_NAME,
				EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
				EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
				EMPLOYEE_POSITIONS.USER_GROUP_ID,
				EMPLOYEE_POSITIONS.DISCOUNT_VALID,
				EMPLOYEE_POSITIONS.DUEDATE_VALID,
				EMPLOYEE_POSITIONS.PRICE_VALID,
				EMPLOYEE_POSITIONS.PRICE_DISPLAY_VALID,
				EMPLOYEE_POSITIONS.COST_DISPLAY_VALID,
				EMPLOYEE_POSITIONS.RATE_VALID,
				EMPLOYEE_POSITIONS.THEIR_RECORDS_ONLY,
				EMPLOYEE_POSITIONS.MEMBER_VIEW_CONTROL,
				EMPLOYEE_POSITIONS.CONSUMER_PRIORITY,
				EMPLOYEE_POSITIONS.LEVEL_ID,
				EMPLOYEE_POSITIONS.LEVEL_EXTRA_ID,
				EMPLOYEE_POSITIONS.DEPARTMENT_ID,
				EMPLOYEE_POSITIONS.EHESAP,
				EMPLOYEE_POSITIONS.PERIOD_ID,
				EMPLOYEE_POSITIONS.ADMIN_STATUS,
				ISNULL(EMPLOYEE_POSITIONS.WRK_MENU, '0') AS WRK_MENU,
				U.POWERUSER AS POWER_USER_LEVEL_ID,
				U.SENSITIVE_USER_LEVEL,
				U.REPORT_USER_LEVEL,
				U.DATA_LEVEL,
				MY_SETTINGS.INTERFACE_ID,
				MY_SETTINGS.WEEK_START,
				MY_SETTINGS.OZEL_MENU_ID,
				MY_SETTINGS.INTERFACE_COLOR,
				<cfif isdefined('arguments.language') and len(arguments.language) and arguments.language eq 'tr'>
					MY_SETTINGS.LANGUAGE_ID,
				<cfelseif isdefined('arguments.language') and len(arguments.language) and arguments.language neq 'tr'>
					REPLACE(MY_SETTINGS.LANGUAGE_ID,'tr','eng') AS LANGUAGE_ID,
				</cfif>
				MY_SETTINGS.LOGIN_TIME,
				MY_SETTINGS.TIME_ZONE,
				MY_SETTINGS.MAXROWS,
				MY_SETTINGS.TIMEOUT_LIMIT,
				MY_SETTINGS.DATEFORMAT_STYLE,
				MY_SETTINGS.TIMEFORMAT_STYLE,
				MY_SETTINGS.MONEYFORMAT_STYLE,
				OUR_COMPANY.COMPANY_NAME,
				OUR_COMPANY.NICK_NAME,
				OUR_COMPANY.EMAIL,
				OUR_COMPANY_INFO.WORKCUBE_SECTOR,
				OUR_COMPANY_INFO.IS_GUARANTY_FOLLOWUP,
				OUR_COMPANY_INFO.IS_PROJECT_FOLLOWUP,
				OUR_COMPANY_INFO.IS_ASSET_FOLLOWUP,
				OUR_COMPANY_INFO.IS_SALES_ZONE_FOLLOWUP,
				OUR_COMPANY_INFO.IS_SMS,
				OUR_COMPANY_INFO.IS_UNCONDITIONAL_LIST,
				OUR_COMPANY_INFO.IS_SUBSCRIPTION_CONTRACT,
				OUR_COMPANY_INFO.SPECT_TYPE,
				OUR_COMPANY_INFO.IS_COST,
				ISNULL(OUR_COMPANY_INFO.IS_COST_LOCATION,0) AS IS_COST_LOCATION,
				OUR_COMPANY_INFO.IS_PAPER_CLOSER,
				OUR_COMPANY_INFO.IS_USE_IFRS,
				OUR_COMPANY_INFO.RATE_ROUND_NUM,
				OUR_COMPANY_INFO.PURCHASE_PRICE_ROUND_NUM,
				OUR_COMPANY_INFO.SALES_PRICE_ROUND_NUM,
				OUR_COMPANY_INFO.IS_PROD_COST_TYPE,
				OUR_COMPANY_INFO.IS_STOCK_BASED_COST,
				OUR_COMPANY_INFO.IS_MAXROWS_CONTROL_OFF,
				OUR_COMPANY_INFO.IS_LOCATION_FOLLOW,
				OUR_COMPANY_INFO.IS_PROJECT_GROUP,
				OUR_COMPANY_INFO.SPECIAL_MENU_FILE,
				OUR_COMPANY_INFO.IS_ADD_INFORMATIONS,
				ISNULL(OUR_COMPANY_INFO.IS_EFATURA,0) AS IS_EFATURA,
				OUR_COMPANY_INFO.EFATURA_DATE,
				ISNULL(OUR_COMPANY_INFO.IS_EARCHIVE,0) AS IS_EARCHIVE,
				OUR_COMPANY_INFO.EARCHIVE_DATE,            
				ISNULL(OUR_COMPANY_INFO.IS_EDEFTER,0) AS IS_EDEFTER,
				ISNULL(OUR_COMPANY_INFO.IS_ESHIPMENT,0) AS IS_ESHIPMENT,
				OUR_COMPANY_INFO.ESHIPMENT_DATE,
				ISNULL(OUR_COMPANY_INFO.IS_LOT_NO,0) AS IS_LOT_NO,
				BRANCH.BRANCH_ID,
				SETUP_PERIOD.OUR_COMPANY_ID,
				SETUP_PERIOD.OTHER_MONEY,
				SETUP_PERIOD.STANDART_PROCESS_MONEY,
				SETUP_PERIOD.PERIOD_YEAR,
				SETUP_PERIOD.IS_INTEGRATED,
				SETUP_PERIOD.PERIOD_DATE,
				SETUP_PERIOD.PROCESS_DATE,
				SETUP_PERIOD.START_DATE,
				SETUP_PERIOD.FINISH_DATE,
				SETUP_MONEY.MONEY,
				POS_EQUIPMENT.EQUIPMENT_CODE
			FROM 
				EMPLOYEES,
				EMPLOYEE_POSITIONS
				LEFT JOIN USER_GROUP AS U ON EMPLOYEE_POSITIONS.USER_GROUP_ID = U.USER_GROUP_ID,
				DEPARTMENT,
				BRANCH,
				MY_SETTINGS, 
				OUR_COMPANY,
				OUR_COMPANY_INFO,
				SETUP_PERIOD,
				SETUP_MONEY,
				#dsn#_#whops_company_id#.POS_EQUIPMENT
			WHERE 
				MY_SETTINGS.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
				DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
				EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
				EMPLOYEE_POSITIONS.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
				EMPLOYEES.EMPLOYEE_STATUS = 1 AND
				EMPLOYEE_POSITIONS.POSITION_STATUS = 1 AND
				EMPLOYEE_POSITIONS.IS_MASTER = 1 AND
				SETUP_PERIOD.PERIOD_ID = EMPLOYEE_POSITIONS.PERIOD_ID AND
				EMPLOYEE_POSITIONS.PERIOD_ID IS NOT NULL AND 
				OUR_COMPANY.COMP_ID = SETUP_PERIOD.OUR_COMPANY_ID AND
				SETUP_MONEY.RATE1 = SETUP_MONEY.RATE2 AND
				SETUP_MONEY.PERIOD_ID = SETUP_PERIOD.PERIOD_ID AND
				OUR_COMPANY.COMP_ID = OUR_COMPANY_INFO.COMP_ID AND
				POS_EQUIPMENT.BRANCH_ID = DEPARTMENT.BRANCH_ID AND
				EMPLOYEE_POSITIONS.USER_GROUP_ID IS NOT NULL AND
				POS_EQUIPMENT.EQUIPMENT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pos_code#"> AND
				EMPLOYEES.EMPLOYEE_USERNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.employee_username#"> AND 
                EMPLOYEES.EMPLOYEE_PASSWORD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#employee_password#">
		</cfquery>

        <cfif get_employee_login.recordcount>
            <cfset this.setSession(get_employee_login,arguments.screen_width,arguments.screen_height) />
            <cfset response = { status: true } />
        <cfelse>
            <cfset response = { status: false, message: 'Your username or password is wrong' } />
        </cfif>

		<cfreturn replace(serializeJson(response),"//","") />
	</cffunction>

	<cffunction name = "logout" returnType = "any" returnFormat = "JSON" access = "remote">
		<cfif isdefined("session")>
			<cfloop collection=#session# item="key_field">
				<cfscript>
					StructDelete(session, key_field); 
				</cfscript>
			</cfloop>
			<cfcookie name="JSESSIONID" expires="now">
		</cfif>
		<cfreturn replace(serializeJSON({status: true}), "//", "") />
	</cffunction>

    <cffunction name="GET_BRANCH_DEPT" returntype="query">
		<cfargument name="position_code" default=""/>
		<cfargument name="our_company_id" default=""/>
		<cfquery name="get_emp_branches" datasource="#dsn#">
			SELECT BRANCH_ID,DEPARTMENT_ID,LOCATION_ID FROM EMPLOYEE_POSITION_DEPARTMENTS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_code#"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.our_company_id#">
		</cfquery>
		<cfreturn get_emp_branches/>
	</cffunction>

    <cffunction name="get_period_date" returntype="query">
		<cfargument name="position_id" default=""/>
		<cfargument name="period_id" default=""/>
		<cfquery name="get_periods" datasource="#dsn#">
			SELECT PERIOD_DATE,PROCESS_DATE FROM EMPLOYEE_POSITION_PERIODS WHERE POSITION_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.POSITION_ID#"> AND PERIOD_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PERIOD_ID#">
		</cfquery>
		<cfreturn get_periods/>
	</cffunction>

    <cffunction name="get_user_groups" returntype="query">
		<cfargument name="user_group_id" default=""/>
		<cfquery name="get_groups" datasource="#dsn#">
			SELECT USER_GROUP_PERMISSIONS,USER_GROUP_PERMISSIONS_EXTRA,IS_BRANCH_AUTHORIZATION FROM USER_GROUP WHERE USER_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.user_group_id#">
		</cfquery>
		<cfreturn get_groups/>
	</cffunction>

	<cffunction name="GET_EMP_AUTHORITY_CODES" returntype="query">
		<cfargument name="POSITION_ID" default=""/>
		<cfquery name="GET_CODES" datasource="#dsn#">
			SELECT * FROM EMPLOYEES_AUTHORITY_CODES WHERE POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.POSITION_ID#">
		</cfquery>
		<cfreturn GET_CODES/>
	</cffunction>

    <cffunction name="setSession" returnType="any">
        <cfargument name="login" required="yes"/>
		<cfargument name="screen_width" default=""/>
		<cfargument name="screen_height" default=""/>
        
		<cfset GET_EMP_AUTHORITY_CODES = this.GET_EMP_AUTHORITY_CODES(login.position_id)/>
		<cfquery name="GET_EMP_AUTHORITY_CODES_1" dbtype="query">
			SELECT AUTHORITY_CODE FROM GET_EMP_AUTHORITY_CODES WHERE MODULE_ID = 3
		</cfquery>

		<cfscript>
		//Dil değeri önceden oluşturulduğundan; kaybolmaması için local değişkene alınır.
		local.userLanguage = session.wp.language?:"tr";

		// partner ve public icin de bu ayarlamalar gereklidir. Değişiklikler oralara da uygulanmalı
		session.wp = StructNew();
		session.wp.userid = login.employee_ID;
		session.wp.week_start = login.week_start;
		session.wp.position_code = login.position_code;
		session.wp.money = login.money;
		session.wp.money2 = login.other_money;
		session.wp.other_money = login.standart_process_money;
		session.wp.time_zone = login.time_zone;
		session.wp.name = login.employee_name;
		session.wp.surname = login.employee_surname;
		session.wp.position_name = login.position_name;
		session.wp.consumer_priority = login.consumer_priority;
		session.wp.discount_valid = login.discount_valid;
		session.wp.duedate_valid = login.duedate_valid;
		session.wp.member_view_control = login.member_view_control;
		session.wp.price_valid = login.price_valid;
		session.wp.price_display_valid = login.price_display_valid;
		session.wp.cost_display_valid = login.cost_display_valid;
		session.wp.rate_valid = login.rate_valid;
		session.wp.their_records_only = login.their_records_only;
		session.wp.language = local.userLanguage != "tr" ? local.userLanguage : login.language_id;
		session.wp.design_id = len(login.interface_id) ? login.interface_id : 1;
		session.wp.menu_id = login.WRK_MENU;
		session.wp.design_color = login.interface_color;
		session.wp.username = login.employee_username;
		session.wp.userkey = 'e-#login.employee_id#';
		session.wp.company_id = login.our_company_id;
		session.wp.our_company_id = login.our_company_id;
		session.wp.company = login.company_name;
		session.wp.company_email = login.email;
		session.wp.company_nick = login.nick_name;
		session.wp.period_id = login.period_id;
		session.wp.period_start_date = dateformat(login.start_date,'yyyy-mm-dd');
		session.wp.period_finish_date = dateformat(login.finish_date,'yyyy-mm-dd');
		session.wp.ehesap = login.ehesap;
		session.wp.maxrows = login.maxrows;
		if(isDefined("session.SESSIONID"))
			session.wp.workcube_id = session.SESSIONID;
		else
			session.wp.workcube_id = cookie.JSESSIONID;
		session.wp.our_company_info = StructNew();
		
		session.wp.our_company_info.workcube_sector = login.workcube_sector;
		session.wp.our_company_info.is_paper_closer =login.is_paper_closer;
		session.wp.our_company_info.is_cost =login.is_cost;
		session.wp.our_company_info.is_cost_location =login.is_cost_location;
		session.wp.our_company_info.guaranty_followup = login.is_guaranty_followup;
		session.wp.our_company_info.project_followup = login.is_project_followup;
		session.wp.our_company_info.asset_followup = login.is_asset_followup;
		session.wp.our_company_info.sales_zone_followup = login.is_sales_zone_followup;
		session.wp.our_company_info.subscription_contract=login.is_subscription_contract;
		session.wp.our_company_info.sms = login.is_sms;
		session.wp.our_company_info.unconditional_list = login.is_unconditional_list;
		session.wp.our_company_info.spect_type = login.spect_type;
		session.wp.our_company_info.is_ifrs = login.is_use_ifrs;
		session.wp.our_company_info.rate_round_num = login.rate_round_num;
		session.wp.our_company_info.purchase_price_round_num = login.purchase_price_round_num;
		session.wp.our_company_info.sales_price_round_num = login.sales_price_round_num;
		session.wp.our_company_info.is_prod_cost_type = login.is_prod_cost_type;
		session.wp.our_company_info.is_stock_based_cost = login.is_stock_based_cost;
		session.wp.our_company_info.is_project_group = login.is_project_group;
		session.wp.our_company_info.special_menu_file = login.special_menu_file;
		session.wp.our_company_info.is_maxrows_control_off = login.is_maxrows_control_off;
		session.wp.our_company_info.is_add_informations = login.is_add_informations;
		session.wp.our_company_info.is_efatura = login.is_efatura;
		session.wp.our_company_info.efatura_date = login.efatura_date;
		session.wp.our_company_info.is_edefter = login.is_edefter;
		session.wp.our_company_info.is_earchive = login.is_earchive;
		session.wp.our_company_info.earchive_date = login.earchive_date;		
		session.wp.our_company_info.is_lot_no = login.is_lot_no;
		session.wp.our_company_info.is_eshipment = login.is_eshipment;
		session.wp.our_company_info.eshipment_date = login.eshipment_date;
		if(len(login.dateformat_style))
			session.wp.dateformat_style = login.dateformat_style;
		else {
			session.wp.dateformat_style = 'dd/mm/yyyy';
		}
		if(len(login.timeformat_style))
			session.wp.timeformat_style = login.timeformat_style;
		else {
			session.wp.timeformat_style = 'HH:mm';
		}
		if(len(login.moneyformat_style))
			session.wp.moneyformat_style = login.moneyformat_style;
		else {
			session.wp.moneyformat_style = 0;
		}
		if(len(login.is_location_follow))
			session.wp.our_company_info.is_location_follow = login.is_location_follow;
		else
			session.wp.our_company_info.is_location_follow = 0;
		//session.wp.authority_code = StructNew();
		session.wp.authority_code_hr = "#get_emp_authority_codes_1.authority_code#";
		if(not len(login.admin_status)) session.wp.admin = 0;
		else session.wp.admin = login.admin_status;
		
		if(not len(login.power_user_level_id))
		{
			session.wp.power_user = 0;
			session.wp.power_user_level_id = '';
		}
		else
		{
			session.wp.power_user = 1;
			session.wp.power_user_level_id = login.power_user_level_id;
		}
		session.wp.dockphone = login.SENSITIVE_USER_LEVEL;
		session.wp.report_user_level = login.REPORT_USER_LEVEL;
		session.wp.data_level = login.DATA_LEVEL;
		session.wp.timeout_min = login.TIMEOUT_LIMIT;
		session.wp.worktips_open = ( isdefined("login.WORKTIPS_OPEN") and len(login.WORKTIPS_OPEN) ) ? login.WORKTIPS_OPEN : 0;
		// Oncelikli Sube Departman Lokasyon Yetkileri Sirkete Gore Belirlenir FBS 20111020
		get_priority_branch_dept = this.GET_BRANCH_DEPT(login.position_code,login.our_company_id);
		if (get_priority_branch_dept.recordcount and len(get_priority_branch_dept.BRANCH_ID) and len(get_priority_branch_dept.DEPARTMENT_ID) and len(get_priority_branch_dept.LOCATION_ID))
			session.wp.user_location = get_priority_branch_dept.DEPARTMENT_ID&'-'&get_priority_branch_dept.BRANCH_ID&'-'&get_priority_branch_dept.LOCATION_ID;
		else if (get_priority_branch_dept.recordcount and len(get_priority_branch_dept.BRANCH_ID) and len(get_priority_branch_dept.DEPARTMENT_ID))
			session.wp.user_location = get_priority_branch_dept.DEPARTMENT_ID&'-'&get_priority_branch_dept.BRANCH_ID;
		else
			session.wp.user_location = login.DEPARTMENT_ID&'-'&login.BRANCH_ID;
		// Oncelikli Sube Departman Lokasyon Yetkileri Sirkete Gore Belirlenir FBS 20111020

		// period date of login user
		get_period_date = this.get_period_date(LOGIN.POSITION_ID,LOGIN.PERIOD_ID);
		session.wp.period_year=login.period_year;
		session.wp.period_is_integrated=login.is_integrated;
		if (len(get_period_date.period_date)) 
			session.wp.period_date = dateformat(get_period_date.period_date,'yyyy-mm-dd');
		else if (len(login.period_date)) 
			session.wp.period_date =dateformat(login.period_date,'yyyy-mm-dd');
		else 
			session.wp.period_date = "#login.period_year#-01-01";
		// period date of login user
		// grup uyesi
		if (len(get_period_date.process_date))
			session.wp.process_date = dateformat(get_period_date.process_date,'yyyy-mm-dd');
		else if (len(login.process_date)) 
			session.wp.process_date=dateformat(login.process_date,'yyyy-mm-dd');
		else 
			session.wp.process_date = "#login.period_year#-01-01";
		if (len(login.user_group_id))
		{
			GET_USER_GROUPS = this.get_user_groups(login.user_group_id);
			session.wp.user_level = get_user_groups.user_group_permissions;
			//if(isdefined("use_extra_modules") and use_extra_modules eq 1 and get_modules_extra.recordcount)
			//	session.wp.user_level_extra = get_user_groups.user_group_permissions_extra;	
			if(len(get_user_groups.IS_BRANCH_AUTHORIZATION))
				session.wp.isBranchAuthorization = get_user_groups.IS_BRANCH_AUTHORIZATION;
			else
				session.wp.isBranchAuthorization = 0;
		}
		else 
		{
			session.wp.user_level = login.level_id;
		//	if(isdefined("use_extra_modules") and use_extra_modules eq 1 and get_modules_extra.recordcount)
		//		session.wp.user_level_extra = login.level_extra_id;
			session.wp.isBranchAuthorization = 0;
		}
		structDelete(session, "error_text");
		session.wp.is_order_closed = 0;// pp-ww deki gibi siparisin odemesi kontrolu icim eklendi
		if(isdefined("arguments.screen_width"))
		{
			session.wp.screen_width = "#arguments.screen_width#";
			session.wp.screen_height = "#arguments.screen_height#";
		}
		else
		{
			session.wp.screen_width = "-1";
			session.wp.screen_height = "-1";
		}
		session.wp.whops.equipment_code = login.EQUIPMENT_CODE;
	</cfscript>

    </cffunction>
</cfcomponent>