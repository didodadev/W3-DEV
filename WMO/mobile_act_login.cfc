<cffunction name="get_ban_control" returntype="query">
    <cfquery name="IFBANNED" datasource="#this.DSN#">
    	SELECT REMOTE_ADDR,RECORD_DATE FROM WRK_SECURE_BANNED_IP WHERE REMOTE_ADDR = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#"> AND ACTIVE = 1
    </cfquery>
    <cfreturn IFBANNED/>
</cffunction>

<cffunction name="GET_EMP_AUTHORITY_CODES" returntype="query">
	<cfargument name="POSITION_ID" default=""/>
	<cfquery name="GET_CODES" datasource="#this.DSN#">
		SELECT * FROM EMPLOYEES_AUTHORITY_CODES WHERE POSITION_ID = #POSITION_ID#
	</cfquery>
    <cfreturn GET_CODES/>
</cffunction>

<cffunction name="GET_STOP_LOGIN" returntype="query">
	<cfargument name="position_cat_id" default=""/>
	<cfquery name="GET_STOPS" datasource="#this.DSN#">
		SELECT TYPE_ID,MESSAGE FROM SETUP_STOP_LOGINS WHERE TYPE = 0 AND TYPE_ID = #position_cat_id#
	</cfquery>
    <cfreturn GET_STOPS/>
</cffunction>

<cffunction name="GET_PASS_CONTROL" returntype="query">
	<cfquery name="pass_control" datasource="#this.dsn#" maxrows="1">
		SELECT PASSWORD_CHANGE_INTERVAL FROM PASSWORD_CONTROL WHERE PASSWORD_STATUS = 1 AND PASSWORD_CHANGE_INTERVAL > 0
	</cfquery>
    <cfreturn pass_control/>
</cffunction>

<cffunction name="GET_USER_PASS_CONTROL" returntype="query">
	<cfargument name="employee_id" default=""/>
	<cfquery name="get_pass_" datasource="#this.dsn#" maxrows="1">
		SELECT RECORD_DATE,FORCE_PASSWORD_CHANGE FROM EMPLOYEES_HISTORY WHERE EMPLOYEE_ID = #employee_id# AND IS_PASSWORD_CHANGE = 1 ORDER BY EMPLOYEE_HISTORY_ID DESC
	</cfquery>
    <cfreturn get_pass_/>
</cffunction>

<cffunction name="GET_BRANCH_DEPT" returntype="query">
	<cfargument name="position_code" default=""/>
	<cfargument name="our_company_id" default=""/>
	<cfquery name="get_emp_branches" datasource="#this.dsn#">
		SELECT BRANCH_ID,DEPARTMENT_ID,LOCATION_ID FROM EMPLOYEE_POSITION_DEPARTMENTS WHERE POSITION_CODE = #position_code# AND OUR_COMPANY_ID = #our_company_id#
	</cfquery>
    <cfreturn get_emp_branches/>
</cffunction>

<cffunction name="get_period_date" returntype="query">
	<cfargument name="position_id" default=""/>
	<cfargument name="period_id" default=""/>
	<cfquery name="get_periods" datasource="#this.dsn#">
		SELECT PERIOD_DATE,PROCESS_DATE FROM EMPLOYEE_POSITION_PERIODS WHERE POSITION_ID=#POSITION_ID# AND PERIOD_ID=#PERIOD_ID#
	</cfquery>
    <cfreturn get_periods/>
</cffunction>

<cffunction name="get_user_groups" returntype="query">
	<cfargument name="user_group_id" default=""/>
	<cfquery name="get_groups" datasource="#this.dsn#">
		SELECT USER_GROUP_PERMISSIONS,USER_GROUP_PERMISSIONS_EXTRA FROM USER_GROUP WHERE USER_GROUP_ID = #user_group_id#
	</cfquery>
    <cfreturn get_groups/>
</cffunction>

<cffunction name="get_login_employee" returntype="query">
	<cfargument name="username" default=""/>
    <cfargument name="employee_password" default=""/>
	<cfargument name="use_password_maker" default=""/>
    <cfargument name="use_standart_login" default=""/>
    <cfquery name="get_employee_login" datasource="#this.DSN#">
    	SELECT 
		<cfif use_password_maker eq 1>
			ISNULL((SELECT '1' FROM PASSWORD_MAKER PMK WHERE PMK.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND PMK.IS_ACTIVE = 1),0) AS SEND_PASSWORD_MAKER,
		</cfif>
			EMPLOYEES.EMPLOYEE_ID,
			EMPLOYEES.EMPLOYEE_USERNAME,
			EMPLOYEES.EMPLOYEE_PASSWORD,
			EMPLOYEES.IP_ADDRESS,
			EMPLOYEES.IS_IP_CONTROL,
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
			EMPLOYEE_POSITIONS.POWER_USER,
			EMPLOYEE_POSITIONS.POWER_USER_LEVEL_ID,
			MY_SETTINGS.INTERFACE_ID,
			MY_SETTINGS.OZEL_MENU_ID,
			MY_SETTINGS.INTERFACE_COLOR,
			MY_SETTINGS.LANGUAGE_ID,
			MY_SETTINGS.LOGIN_TIME,
			MY_SETTINGS.TIME_ZONE,
			MY_SETTINGS.MAXROWS,
			MY_SETTINGS.TIMEOUT_LIMIT,
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
			OUR_COMPANY_INFO.IS_DETAIL_FILTER_OPEN,
			OUR_COMPANY_INFO.IS_SUBSCRIPTION_CONTRACT,
			OUR_COMPANY_INFO.SPECT_TYPE,
			OUR_COMPANY_INFO.IS_COST,
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
			BRANCH.BRANCH_ID,
			SETUP_PERIOD.OUR_COMPANY_ID,
			SETUP_PERIOD.OTHER_MONEY,
			SETUP_PERIOD.STANDART_PROCESS_MONEY,
			SETUP_PERIOD.PERIOD_YEAR,
			SETUP_PERIOD.IS_INTEGRATED,
			SETUP_PERIOD.PERIOD_DATE,
			SETUP_PERIOD.PROCESS_DATE,
			SETUP_MONEY.MONEY
		FROM 
			EMPLOYEES,
			EMPLOYEE_POSITIONS,
			DEPARTMENT,
			BRANCH,
			MY_SETTINGS, 
			OUR_COMPANY,
			OUR_COMPANY_INFO,
			SETUP_PERIOD,
			SETUP_MONEY
		WHERE 
			MY_SETTINGS.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
			DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
			EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
			EMPLOYEES.EMPLOYEE_USERNAME = '#USERNAME#' AND 
			<cfif use_standart_login eq 1>
				EMPLOYEES.EMPLOYEE_PASSWORD = '#EMPLOYEE_PASSWORD#' AND
			</cfif>
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
			(EMPLOYEES.EXPIRY_DATE >= #now()# OR EMPLOYEES.EXPIRY_DATE IS NULL)
    </cfquery>
    <cfreturn get_employee_login/>
</cffunction>

<cffunction name="ADD_LAST_LOGIN">
	<cfargument name="employee_id" default=""/>
	<cfargument name="server_machine" default=""/>
	<cfargument name="browser_info" default=""/>
	<cfquery name="ADD_LAST_LOGIN" datasource="#this.DSN#">
		INSERT INTO 
			WRK_LOGIN
		(
			SERVER_MACHINE,
			DOMAIN_NAME,
			EMPLOYEE_ID,
			IN_OUT,
			IN_OUT_TIME,
			LOGIN_IP,
			LOGIN_BROWSER
		)
		VALUES
		(
			#server_machine#,
			'#cgi.http_host#',
			#employee_id#,
			1,
			#now()#,
			'#cgi.remote_addr#',
			'#browser_info#'
		)
	</cfquery>	
</cffunction>

<cffunction name="del_production_rows">
	<cfargument name="employee_id" default=""/>
	<cfargument name="data_source" default=""/>
	<cfquery name="del_p_rows" datasource="#data_source#">
		DELETE FROM PRODUCTION_MATERIAL_ROWS WHERE RECORD_EMP = #employee_id#
	</cfquery>	
</cffunction>
