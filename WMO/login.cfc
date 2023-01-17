<!---
    File: login.cfc
    Folder: WMO
    Author: 
    Date:  
    Description:
        
    History:
        Gramoni-Mahmut Çifçi mahmut.cifci@gramoni.com
        03.11.2019 Lucee uyumluluk projesi için cfcomponent etiketi içerisine alındı
    To Do:

--->
<cfcomponent extends="cfc.queryJSONConverter">
    <cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="get_ban_control" returntype="query">
		<cfquery name="IFBANNED" datasource="#this.DSN#">
			SELECT REMOTE_ADDR,RECORD_DATE FROM WRK_SECURE_BANNED_IP WHERE REMOTE_ADDR = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#"> AND ACTIVE = 1
		</cfquery>
		<cfreturn IFBANNED/>
	</cffunction>

	<cffunction name="GET_EMP_AUTHORITY_CODES" returntype="query">
		<cfargument name="POSITION_ID" default=""/>
		<cfquery name="GET_CODES" datasource="#this.DSN#">
			SELECT * FROM EMPLOYEES_AUTHORITY_CODES WHERE POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#POSITION_ID#">
		</cfquery>
		<cfreturn GET_CODES/>
	</cffunction>

	<cffunction name="GET_STOP_LOGIN" returntype="query">
		<cfargument name="position_cat_id" default=""/>
		<cfquery name="GET_STOPS" datasource="#this.DSN#">
			SELECT TYPE_ID,MESSAGE FROM SETUP_STOP_LOGINS WHERE TYPE = 0 AND TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#position_cat_id#">
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
			SELECT RECORD_DATE,FORCE_PASSWORD_CHANGE FROM EMPLOYEES_HISTORY WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#employee_id#"> AND IS_PASSWORD_CHANGE = 1 ORDER BY RECORD_DATE DESC
		</cfquery>
		<cfreturn get_pass_/>
	</cffunction>

	<cffunction name="GET_BRANCH_DEPT" returntype="query">
		<cfargument name="position_code" default=""/>
		<cfargument name="our_company_id" default=""/>
		<cfquery name="get_emp_branches" datasource="#this.dsn#">
			SELECT BRANCH_ID,DEPARTMENT_ID,LOCATION_ID FROM EMPLOYEE_POSITION_DEPARTMENTS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#position_code#"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#our_company_id#">
		</cfquery>
		<cfreturn get_emp_branches/>
	</cffunction>

	<cffunction name="get_period_date" returntype="query">
		<cfargument name="position_id" default=""/>
		<cfargument name="period_id" default=""/>
		<cfquery name="get_periods" datasource="#this.dsn#">
			SELECT PERIOD_DATE,PROCESS_DATE FROM EMPLOYEE_POSITION_PERIODS WHERE POSITION_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#POSITION_ID#"> AND PERIOD_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#PERIOD_ID#">
		</cfquery>
		<cfreturn get_periods/>
	</cffunction>

	<cffunction name="get_user_groups" returntype="query">
		<cfargument name="user_group_id" default=""/>
		<cfquery name="get_groups" datasource="#this.dsn#">
			SELECT USER_GROUP_PERMISSIONS,USER_GROUP_PERMISSIONS_EXTRA,IS_BRANCH_AUTHORIZATION FROM USER_GROUP WHERE USER_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#user_group_id#">
		</cfquery>
		<cfreturn get_groups/>
	</cffunction>

	<cffunction name="get_login_employee" returntype="query">
		<cfargument name="username" required="yes" default=""/>
		<cfargument name="employee_password" required="yes" default=""/>
		<cfargument name="use_password_maker" default=""/>
		<cfargument name="use_standart_login" default="1"/>
		<cfargument name="language" default="tr"/>
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
				<!---EMPLOYEE_POSITIONS.POWER_USER,--->
				<!---EMPLOYEE_POSITIONS.POWER_USER_LEVEL_ID,--->
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
				SETUP_MONEY.MONEY
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
				SETUP_MONEY
			WHERE 
				MY_SETTINGS.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
				DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
				EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
				EMPLOYEES.EMPLOYEE_USERNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#USERNAME#"> AND 
				<cfif listFind('1,2',use_standart_login)>
					EMPLOYEES.EMPLOYEE_PASSWORD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#EMPLOYEE_PASSWORD#"> AND
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
				(EMPLOYEES.EXPIRY_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> OR EMPLOYEES.EXPIRY_DATE IS NULL) AND
				EMPLOYEE_POSITIONS.USER_GROUP_ID IS NOT NULL
		</cfquery>
		<cfreturn get_employee_login/>
	</cffunction>

	<cffunction name="ADD_LAST_LOGIN">
		<cfargument name="employee_id" default=""/>
		<cfargument name="server_machine" default=""/>
		<cfargument name="browser_info" default=""/>
		<cfargument name="coordinate1" default=""/>
		<cfargument name="coordinate2" default=""/>
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
				LOGIN_BROWSER,
                COORDINATE1,
                COORDINATE2
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_integer" value="#server_machine#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.http_host#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#employee_id#">,
				1,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#browser_info#">
				<cfif isDefined('arguments.coordinate1') and len(arguments.coordinate1)>
                    ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.coordinate1#">
                <cfelse>
                    ,<cfqueryparam cfsqltype="cf_sql_varchar" value="0">
                </cfif>
				<cfif isDefined('arguments.coordinate2') and len(arguments.coordinate2)>
                    ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.coordinate2#">
                <cfelse>
                    ,<cfqueryparam cfsqltype="cf_sql_varchar" value="0">
                </cfif>
			)
		</cfquery>	
	</cffunction>

    <cffunction name="get_last_login" returntype="query">
        <cfquery name="get_last_login" datasource="#this.DSN#">
            SELECT TOP (1) * FROM WRK_LOGIN WHERE EMPLOYEE_ID = #session.ep.userid# ORDER BY LOGIN_ID DESC
        </cfquery>
        <cfreturn get_last_login />
    </cffunction>

    <cffunction name="add_user_login_coord" access="remote">
        <cfargument name="login_id" default=""/>
        <cfargument name="coordinate1" default=""/>
		<cfargument name="coordinate2" default=""/>
        <cfquery name="add_user_login_coord" datasource="#dsn#">
            UPDATE
                WRK_LOGIN
            SET
                COORDINATE1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.coordinate1#">,
                COORDINATE2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.coordinate2#">
            WHERE LOGIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.login_id#">
        </cfquery>
    </cffunction>

	<cffunction name="del_production_rows">
		<cfargument name="employee_id" default=""/>
		<cfargument name="data_source" default=""/>
		<cfquery name="del_p_rows" datasource="#this.DSN#">
			DELETE FROM #data_source#.PRODUCTION_MATERIAL_ROWS WHERE RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#employee_id#">
		</cfquery>	
	</cffunction>

	<cffunction name="get_username_ban_control" returntype="query">
		<cfargument name="username" default=""/>
		<cfquery name="IFBANNED_USERNAME" datasource="#this.DSN#">
			SELECT USER_NAME,USER_IP,LOGIN_DATE FROM FAILED_LOGINS WHERE USER_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#username#"> AND IS_ACTIVE = 1
		</cfquery>
		<cfreturn IFBANNED_USERNAME/>
	</cffunction>

	<cffunction name="get_security_login_info" returntype="query">
		<cfquery name="GET_SECURITY_LOGIN_INFO" datasource="#this.DSN#">
			SELECT PASSWORD_STATUS AS IS_ACTIVE,FAILED_LOGIN_COUNT AS LOGIN_COUNT FROM PASSWORD_CONTROL WHERE PASSWORD_STATUS = 1
		</cfquery>
		<cfreturn GET_SECURITY_LOGIN_INFO/>
	</cffunction>

	<cffunction name="get_failed_login" returntype="query">
		<cfargument name="username" default=""/>
		<cfquery name="GET_FAILED_LOGIN" datasource="#this.DSN#">
			SELECT USER_NAME FROM FAILED_LOGINS WHERE USER_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#username#"> AND IS_ACTIVE = 1
		</cfquery>
		<cfreturn GET_FAILED_LOGIN/>
	</cffunction>

	<cffunction name="update_failed_login">
		<cfargument name="username" default=""/>
		<cfquery name="update_failed_login" datasource="#this.DSN#">
			UPDATE FAILED_LOGINS SET IS_ACTIVE = 0 WHERE USER_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#username#">
		</cfquery>
	</cffunction>

	<cffunction name="add_failed_login">
		<cfargument name="username" default=""/>
		<cfargument name="ip_adress" default=""/>
		<cfargument name="datetime" default=""/>
		<cfquery name="ADD_FAILED_LOGIN" datasource="#this.DSN#">
			INSERT INTO FAILED_LOGINS (USER_NAME,USER_IP,LOGIN_DATE,IS_ACTIVE) VALUES (<cfqueryparam cfsqltype="cf_sql_varchar" value="#username#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#ip_adress#">,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#datetime#">,1)
		</cfquery>
	</cffunction>

	<cffunction name="getMenuJSON" returntype="query">
		<cfargument name="menu_id" default=""/>
		<cfargument name="language" default=""/>
		<cfargument name="userid" default=""/>

		<cfif arguments.menu_id eq 0>
			<cfquery name="getMenuJSON" datasource="#this.dsn#">
			SELECT * FROM
			(
			SELECT 
				*
			FROM 
			(	
				SELECT
					1 X,
					Replace(L4.ITEM_#UCASE(arguments.language)#,'''','') AS 'ITEM_#UCASE(arguments.language)#',
					Replace(L3.ITEM_#UCASE(arguments.language)#,'''','') AS 'ITEM_#UCASE(arguments.language)#2',
					Replace(L2.ITEM_#UCASE(arguments.language)#,'''','') AS 'ITEM_#UCASE(arguments.language)#3',
					Replace(L1.ITEM_#UCASE(arguments.language)#,'''','') AS 'ITEM_#UCASE(arguments.language)#4',
					W.FULL_FUSEACTION AS FUSEACTION,
					M.MODULE_TYPE,
					W.POPUP_TYPE,
					W.WRK_OBJECTS_ID,
					ISNULL(S.RANK_NUMBER,100) AS SOLUTION_RANK_NUMBER,
					ISNULL(F.RANK_NUMBER,100) AS FAMILY_RANK_NUMBER,
					ISNULL(M.RANK_NUMBER,100) AS MODULE_RANK_NUMBER
				FROM
					WRK_OBJECTS AS W
					LEFT JOIN SETUP_LANGUAGE_TR AS L1 ON L1.DICTIONARY_ID = W.DICTIONARY_ID
					LEFT JOIN WRK_MODULE AS M ON W.MODULE_NO = M.MODULE_NO
					LEFT JOIN SETUP_LANGUAGE_TR AS L2 ON L2.DICTIONARY_ID = M.MODULE_DICTIONARY_ID
					LEFT JOIN WRK_FAMILY AS F ON F.WRK_FAMILY_ID = M.FAMILY_ID
					LEFT JOIN SETUP_LANGUAGE_TR AS L3 ON L3.DICTIONARY_ID = F.FAMILY_DICTIONARY_ID
					LEFT JOIN WRK_SOLUTION AS S ON S.WRK_SOLUTION_ID = F.WRK_SOLUTION_ID
					LEFT JOIN SETUP_LANGUAGE_TR AS L4 ON L4.DICTIONARY_ID = S.SOLUTION_DICTIONARY_ID
									JOIN (
									SELECT A.USER_GROUP_PERMISSIONS,  
										Split.a.value('.', 'VARCHAR(100)') AS String  
									FROM  
										(
											SELECT U.USER_GROUP_PERMISSIONS, CAST ('<M>' + REPLACE(U.USER_GROUP_PERMISSIONS, ',', '</M><M>') + '</M>' AS XML) AS String
											FROM EMPLOYEE_POSITIONS AS EP LEFT JOIN USER_GROUP AS U ON U.USER_GROUP_ID = EP.USER_GROUP_ID
											WHERE
												EP.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userid#">) AS A CROSS APPLY String.nodes ('/M') AS Split(a) ) AS X ON X.String = M.MODULE_NO
				WHERE
					S.IS_MENU = 1 AND
					F.IS_MENU = 1 AND
					M.IS_MENU = 1 AND
					W.IS_MENU = 1
				GROUP BY
					Replace(L4.ITEM_#UCASE(arguments.language)#,'''',''),
					Replace(L3.ITEM_#UCASE(arguments.language)#,'''',''),
					Replace(L2.ITEM_#UCASE(arguments.language)#,'''',''),
					Replace(L1.ITEM_#UCASE(arguments.language)#,'''',''),
					W.FULL_FUSEACTION,
					M.MODULE_TYPE,
					W.POPUP_TYPE,
					W.WRK_OBJECTS_ID,
					ISNULL(S.RANK_NUMBER,100),
					ISNULL(F.RANK_NUMBER,100),
					ISNULL(M.RANK_NUMBER,100)
			) AS L1
			) AS ALL_DATA
			WHERE
				ALL_DATA.FUSEACTION NOT IN (
					SELECT 
						OBJECT_NAME 
					FROM 
						USER_GROUP_OBJECT U
						LEFT JOIN EMPLOYEE_POSITIONS AS E ON E.USER_GROUP_ID = U.USER_GROUP_ID
					WHERE 
						E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userid#">
						AND U.LIST_OBJECT = 1
				)
				ORDER BY 
					ALL_DATA.SOLUTION_RANK_NUMBER ASC,
					ALL_DATA.FAMILY_RANK_NUMBER ASC,
					ALL_DATA.MODULE_RANK_NUMBER ASC,
				CASE
					WHEN Replace(ALL_DATA.ITEM_#UCASE(arguments.language)#,'''','') = 'ERP' THEN 1
					WHEN Replace(ALL_DATA.ITEM_#UCASE(arguments.language)#,'''','') = 'CRM' THEN 2
					WHEN Replace(ALL_DATA.ITEM_#UCASE(arguments.language)#,'''','') = 'HR' THEN 3
					WHEN Replace(ALL_DATA.ITEM_#UCASE(arguments.language)#,'''','') = 'PAM' THEN 4
					WHEN Replace(ALL_DATA.ITEM_#UCASE(arguments.language)#,'''','') = 'PMS' THEN 5
					WHEN Replace(ALL_DATA.ITEM_#UCASE(arguments.language)#,'''','') = 'BI' THEN 6
					WHEN Replace(ALL_DATA.ITEM_#UCASE(arguments.language)#,'''','') = 'Intranet' THEN 7
					WHEN Replace(ALL_DATA.ITEM_#UCASE(arguments.language)#,'''','') = 'CMS' THEN 8
					WHEN Replace(ALL_DATA.ITEM_#UCASE(arguments.language)#,'''','') = 'LMS' THEN 9
					WHEN Replace(ALL_DATA.ITEM_#UCASE(arguments.language)#,'''','') = 'SUBO' THEN 10
					WHEN Replace(ALL_DATA.ITEM_#UCASE(arguments.language)#,'''','') = 'MLM' THEN 11
					WHEN Replace(ALL_DATA.ITEM_#UCASE(arguments.language)#,'''','') = 'POS' THEN 12
					ELSE 13
				END
			</cfquery>
		<cfelse>
			<cfquery name="getMenuJSON" datasource="#this.dsn#">
				WITH Submenus AS
				(
					SELECT 
						SELECTED_ID AS MenuItemID, 
						ABS(LINK_TYPE) AS LINK_TYPE,
						LINK_NAME, 
						SELECTED_LINK AS URL, 
						0 AS ParentID, 
						Level = 0
					FROM
						MAIN_MENU_SELECTS m
					WHERE
						m.MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.menu_id#">
				
					UNION ALL
				
					SELECT 
						m2.LAYER_ROW_ID AS MenuItemID, 
						ABS(m2.LINK_TYPE) AS LINK_TYPE,
						m2.LINK_NAME, 
						SELECTED_LINK AS URL, 
						m2.SELECTED_ID ParentID, 
						s.Level + 1 
					FROM
						MAIN_MENU_LAYER_SELECTS m2
					INNER JOIN
						Submenus s ON m2.SELECTED_ID = s.MenuItemID  
					where
						m2.MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.menu_id#">
				)  
				SELECT * FROM Submenus ORDER BY Level, MenuItemID
			</cfquery>
		</cfif>
		<cfreturn getMenuJSON>
	</cffunction>

	<cffunction name="getMenuUserGroup" returntype="query">
		<cfargument name="language" default=""/>
		<cfargument name="user_group_id" default=""/>
		<cfargument name="dsn" default=""/>
		<cfquery name="getMenuUserGroup" datasource="#arguments.dsn#">
			SELECT * FROM
			(
			SELECT 
				*
			FROM 
			(	
				SELECT
					1 X,
					ISNULL(Replace(L4.ITEM_#UCASE(arguments.language)#,'''',''),S.SOLUTION) AS 'ITEM_#UCASE(arguments.language)#',
					ISNULL(Replace(L3.ITEM_#UCASE(arguments.language)#,'''',''),F.FAMILY) AS 'ITEM_#UCASE(arguments.language)#2',
					ISNULL(Replace(L2.ITEM_#UCASE(arguments.language)#,'''',''),M.MODULE) AS 'ITEM_#UCASE(arguments.language)#3',
					ISNULL(Replace(L1.ITEM_#UCASE(arguments.language)#,'''',''),HEAD) AS 'ITEM_#UCASE(arguments.language)#4',
					ISNULL(W.FULL_FUSEACTION,W.EXTERNAL_FUSEACTION) AS FUSEACTION,
					M.MODULE_TYPE,
					W.POPUP_TYPE,
					W.WRK_OBJECTS_ID,
					ISNULL(S.RANK_NUMBER,100) AS SOLUTION_RANK_NUMBER,
					ISNULL(F.RANK_NUMBER,100) AS FAMILY_RANK_NUMBER,
					ISNULL(M.RANK_NUMBER,100) AS MODULE_RANK_NUMBER,
					W.FULL_FUSEACTION_VARIABLES AS VARIABLE,
					ISNULL(W.RANK_NUMBER,100) AS OBJECT_RANK_NUMBER,
					W.WINDOW
				FROM
					WRK_OBJECTS AS W
					LEFT JOIN SETUP_LANGUAGE_TR AS L1 ON L1.DICTIONARY_ID = W.DICTIONARY_ID
					LEFT JOIN WRK_MODULE AS M ON W.MODULE_NO = M.MODULE_NO
					LEFT JOIN SETUP_LANGUAGE_TR AS L2 ON L2.DICTIONARY_ID = M.MODULE_DICTIONARY_ID
					LEFT JOIN WRK_FAMILY AS F ON F.WRK_FAMILY_ID = M.FAMILY_ID
					LEFT JOIN SETUP_LANGUAGE_TR AS L3 ON L3.DICTIONARY_ID = F.FAMILY_DICTIONARY_ID
					LEFT JOIN WRK_SOLUTION AS S ON S.WRK_SOLUTION_ID = F.WRK_SOLUTION_ID
					LEFT JOIN SETUP_LANGUAGE_TR AS L4 ON L4.DICTIONARY_ID = S.SOLUTION_DICTIONARY_ID
					JOIN (
					SELECT A.USER_GROUP_PERMISSIONS,  
						Split.a.value('.', 'VARCHAR(100)') AS String  
					FROM  
						(
							SELECT 
								U.USER_GROUP_PERMISSIONS, 
								CAST ('<M>' + REPLACE(U.USER_GROUP_PERMISSIONS, ',', '</M><M>') + '</M>' AS XML) AS String
							FROM 
								USER_GROUP AS U
							WHERE
								U.USER_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.user_group_id#">) AS A CROSS APPLY String.nodes ('/M') AS Split(a) ) AS X ON X.String = M.MODULE_NO
				WHERE
					S.IS_MENU = 1 AND
					F.IS_MENU = 1 AND
					M.IS_MENU = 1 AND
					W.IS_MENU = 1
				GROUP BY
					Replace(L4.ITEM_#UCASE(arguments.language)#,'''',''),
					Replace(L3.ITEM_#UCASE(arguments.language)#,'''',''),
					Replace(L2.ITEM_#UCASE(arguments.language)#,'''',''),
					Replace(L1.ITEM_#UCASE(arguments.language)#,'''',''),
					W.FULL_FUSEACTION,
					M.MODULE_TYPE,
					W.POPUP_TYPE,
					W.WRK_OBJECTS_ID,
					ISNULL(S.RANK_NUMBER,100),
					ISNULL(F.RANK_NUMBER,100),
					ISNULL(M.RANK_NUMBER,100),
					ISNULL(W.RANK_NUMBER,100),
					W.FULL_FUSEACTION_VARIABLES,
					S.SOLUTION,
					F.FAMILY,
					M.MODULE,
					W.EXTERNAL_FUSEACTION,
					W.HEAD,
					W.WINDOW
			) AS L1
			) AS ALL_DATA
			WHERE
				ALL_DATA.FUSEACTION NOT IN (
					SELECT 
						U.OBJECT_NAME 
					FROM 
						USER_GROUP_OBJECT U
					WHERE 
						U.USER_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.user_group_id#">
						AND U.LIST_OBJECT = 1
				)
				ORDER BY 
					ALL_DATA.SOLUTION_RANK_NUMBER ASC,
					ALL_DATA.FAMILY_RANK_NUMBER ASC,
					ALL_DATA.MODULE_RANK_NUMBER ASC,
					ALL_DATA.OBJECT_RANK_NUMBER ASC,
				CASE
					WHEN Replace(ALL_DATA.ITEM_#UCASE(arguments.language)#,'''','') = 'ERP' THEN 1
					WHEN Replace(ALL_DATA.ITEM_#UCASE(arguments.language)#,'''','') = 'CRM' THEN 2
					WHEN Replace(ALL_DATA.ITEM_#UCASE(arguments.language)#,'''','') = 'HR' THEN 3
					WHEN Replace(ALL_DATA.ITEM_#UCASE(arguments.language)#,'''','') = 'PAM' THEN 4
					WHEN Replace(ALL_DATA.ITEM_#UCASE(arguments.language)#,'''','') = 'PMS' THEN 5
					WHEN Replace(ALL_DATA.ITEM_#UCASE(arguments.language)#,'''','') = 'BI' THEN 6
					WHEN Replace(ALL_DATA.ITEM_#UCASE(arguments.language)#,'''','') = 'Intranet' THEN 7
					WHEN Replace(ALL_DATA.ITEM_#UCASE(arguments.language)#,'''','') = 'CMS' THEN 8
					WHEN Replace(ALL_DATA.ITEM_#UCASE(arguments.language)#,'''','') = 'LMS' THEN 9
					WHEN Replace(ALL_DATA.ITEM_#UCASE(arguments.language)#,'''','') = 'SUBO' THEN 10
					WHEN Replace(ALL_DATA.ITEM_#UCASE(arguments.language)#,'''','') = 'MLM' THEN 11
					WHEN Replace(ALL_DATA.ITEM_#UCASE(arguments.language)#,'''','') = 'POS' THEN 12
					ELSE 13
				END
		</cfquery>		
		<cfreturn getMenuUserGroup>
	</cffunction>
	
	<cffunction name="getJeliMenuUserGroup" returntype="any" returnFormat="json">
		<cfargument name="language" default=""/>
		<cfargument name="user_group_id" default=""/>
		<cfargument name="dsn" default=""/>
		<cfargument name="design_id" default=""/>
		<cftry>		
			<cfquery name="getJeliMenuUserGroup" datasource="#arguments.dsn#">
				SELECT * FROM
				(
				SELECT 
					*
				FROM 
				(	
					SELECT
						1 X,
						ISNULL(Replace(L4.ITEM_#UCASE(arguments.language)#,'''',''),S.SOLUTION) AS SOLUTION_TITLE,
						ISNULL(Replace(L3.ITEM_#UCASE(arguments.language)#,'''',''),F.FAMILY) AS FAMILY_TITLE,
						ISNULL(Replace(L2.ITEM_#UCASE(arguments.language)#,'''',''),M.MODULE) AS MODULE_TITLE,
						ISNULL(Replace(L1.ITEM_#UCASE(arguments.language)#,'''',''),HEAD) AS OBJECT_TITLE,
						<cfif arguments.design_id eq 2>
						ISNULL(Replace(LWS.ITEM_#UCASE(arguments.language)#,'''',''),WS.WRK_WATOMIC_SOLUTION_NAME) AS WATOMIC_SOLUTION_TITLE,
						ISNULL(Replace(LWF.ITEM_#UCASE(arguments.language)#,'''',''),WF.WATOMIC_FAMILY_NAME) AS WATOMIC_FAMILY_TITLE,
						WF.WRK_WATOMIC_FAMILY_ICON,
						</cfif>
						ISNULL(W.FULL_FUSEACTION,W.EXTERNAL_FUSEACTION) AS FUSEACTION,
						M.MODULE_TYPE,
						W.POPUP_TYPE,
						W.WRK_OBJECTS_ID,
						ISNULL(S.RANK_NUMBER,100) AS SOLUTION_RANK_NUMBER,
						ISNULL(F.RANK_NUMBER,100) AS FAMILY_RANK_NUMBER,
						ISNULL(M.RANK_NUMBER,100) AS MODULE_RANK_NUMBER,
						W.FULL_FUSEACTION_VARIABLES AS VARIABLE,
						<cfif arguments.design_id eq 2>
							WS.WRK_WATOMIC_SOLITION_RANK_NUMBER AS WS_RANK_NUMBER,
							WF.WATOMIC_FAMILY_RANK_NUMBER AS WF_RANK_NUMBER,
						</cfif>
						ISNULL(W.RANK_NUMBER,100) AS OBJECT_RANK_NUMBER,
						S.WRK_SOLUTION_ID,
						F.WRK_FAMILY_ID,
						M.MODULE_NO,
						S.ICON AS SOLUTION_ICON,
						F.ICON AS FAMILY_ICON,
						M.ICON AS MODULE_ICON,
						W.ICON AS OBJECT_ICON,
						S.IS_MENU AS SOLUTION_IS_MENU,
						F.IS_MENU AS FAMILY_IS_MENU,
						M.IS_MENU AS MODULE_IS_MENU,
						W.IS_MENU AS OBJECTS_IS_MENU,
						W.TYPE AS OBJECT_TYPE,
						W.LICENCE,
						W.STATUS,
						W.MAIN_VERSION,
						W.VERSION,
						-- Type Gore Siralama
						CASE WHEN W.TYPE = 0 THEN 0 --WBO
							WHEN W.TYPE = 8 THEN 1 --Report
							WHEN W.TYPE = 13 THEN 2 --Dashboard
							WHEN W.TYPE = 1 THEN 3 --Param
							WHEN W.TYPE = 3 THEN 4 --Import
							WHEN W.TYPE = 5 THEN 5 --Bakım
							ELSE 6
						END AS TYPE_RANK,
						W.WINDOW
					FROM
						WRK_OBJECTS AS W
						LEFT JOIN SETUP_LANGUAGE_TR AS L1 ON L1.DICTIONARY_ID = W.DICTIONARY_ID
						LEFT JOIN WRK_MODULE AS M ON W.MODULE_NO = M.MODULE_NO
						LEFT JOIN SETUP_LANGUAGE_TR AS L2 ON L2.DICTIONARY_ID = M.MODULE_DICTIONARY_ID
						LEFT JOIN WRK_FAMILY AS F ON F.WRK_FAMILY_ID = M.FAMILY_ID
						LEFT JOIN SETUP_LANGUAGE_TR AS L3 ON L3.DICTIONARY_ID = F.FAMILY_DICTIONARY_ID
						LEFT JOIN WRK_SOLUTION AS S ON S.WRK_SOLUTION_ID = F.WRK_SOLUTION_ID
						LEFT JOIN SETUP_LANGUAGE_TR AS L4 ON L4.DICTIONARY_ID = S.SOLUTION_DICTIONARY_ID
						<cfif arguments.design_id eq 2>
						LEFT JOIN WRK_WATOMIC_SOLUTION AS WS ON W.WATOMIC_SOLUTION_ID = WS.WRK_WATOMIC_SOLUTION_ID
						LEFT JOIN SETUP_LANGUAGE_TR AS LWS ON LWS.DICTIONARY_ID = WS.WRK_WATOMIC_SOLUTION_DICTIONARY_ID
						LEFT JOIN WRK_WATOMIC_FAMILY AS WF ON W.WATOMIC_FAMILY_ID = WF.WRK_WATOMIC_FAMILY_ID
						LEFT JOIN SETUP_LANGUAGE_TR AS LWF ON LWF.DICTIONARY_ID = WF.WRK_WATOMIC_FAMILY_DICTONARY_ID
						</cfif>
						JOIN (
						SELECT A.USER_GROUP_PERMISSIONS,  
							Split.a.value('.', 'VARCHAR(100)') AS String  
						FROM  
							(
								SELECT 
									U.USER_GROUP_PERMISSIONS, 
									CAST ('<M>' + REPLACE(U.USER_GROUP_PERMISSIONS, ',', '</M><M>') + '</M>' AS XML) AS String
								FROM 
									USER_GROUP AS U
								WHERE
									U.USER_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.user_group_id#">
							) AS A CROSS APPLY String.nodes ('/M') AS Split(a) ) AS X ON X.String = M.MODULE_NO
					WHERE
						W.TYPE != 10 
						AND W.TYPE != 11
						AND W.IS_ACTIVE = 1
						AND W.STATUS != 'Cancel'
						AND M.IS_MENU = 1
						<cfif arguments.design_id eq 2>
						AND W.WATOMIC_SOLUTION_ID IS NOT NULL
						AND W.WATOMIC_FAMILY_ID IS NOT NULL
						</cfif>
					GROUP BY
						Replace(L4.ITEM_#UCASE(arguments.language)#,'''',''),
						Replace(L3.ITEM_#UCASE(arguments.language)#,'''',''),
						Replace(L2.ITEM_#UCASE(arguments.language)#,'''',''),
						Replace(L1.ITEM_#UCASE(arguments.language)#,'''',''),
						<cfif arguments.design_id eq 2>
						Replace(LWS.ITEM_#UCASE(arguments.language)#,'''',''),
						Replace(LWF.ITEM_#UCASE(arguments.language)#,'''',''),
						WS.WRK_WATOMIC_SOLUTION_NAME,
						WF.WATOMIC_FAMILY_NAME,
						WF.WRK_WATOMIC_FAMILY_ICON,
						</cfif>
						S.WRK_SOLUTION_ID,
						F.WRK_FAMILY_ID,
						M.MODULE_NO,
						W.FULL_FUSEACTION,
						M.MODULE_TYPE,
						W.POPUP_TYPE,
						W.WRK_OBJECTS_ID,
						ISNULL(S.RANK_NUMBER,100),
						ISNULL(F.RANK_NUMBER,100),
						ISNULL(M.RANK_NUMBER,100),
						ISNULL(W.RANK_NUMBER,100),
						<cfif arguments.design_id eq 2>
							WS.WRK_WATOMIC_SOLITION_RANK_NUMBER,
							WF.WATOMIC_FAMILY_RANK_NUMBER,
						</cfif>
						W.FULL_FUSEACTION_VARIABLES,
						S.SOLUTION,
						F.FAMILY,
						M.MODULE,
						W.EXTERNAL_FUSEACTION,
						W.HEAD,
						S.ICON,
						F.ICON,
						M.ICON,
						W.ICON,
						S.IS_MENU,
						F.IS_MENU,
						M.IS_MENU,
						W.IS_MENU,
						W.TYPE,
						W.LICENCE,
						W.STATUS,
						W.MAIN_VERSION,
						W.VERSION,
						W.WINDOW
				) AS L1
				) AS ALL_DATA
				WHERE
					ALL_DATA.FUSEACTION NOT IN (
						SELECT 
							U.OBJECT_NAME 
						FROM 
							USER_GROUP_OBJECT U
						WHERE 
							U.USER_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.user_group_id#">
							AND U.LIST_OBJECT = 1
					)
					ORDER BY 
						<cfif arguments.design_id eq 2>
							ALL_DATA.WS_RANK_NUMBER ASC,
							ALL_DATA.WF_RANK_NUMBER ASC,
							ALL_DATA.OBJECT_TITLE ASC
						<cfelse>
							CASE
								WHEN SOLUTION_TITLE = 'ERP' THEN 1
								WHEN SOLUTION_TITLE = 'CRM' THEN 2
								WHEN SOLUTION_TITLE = 'HR' THEN 3
								WHEN SOLUTION_TITLE = 'PAM' THEN 4
								WHEN SOLUTION_TITLE= 'PMS' THEN 5
								WHEN SOLUTION_TITLE = 'BI' THEN 6
								WHEN SOLUTION_TITLE = 'Intranet' THEN 7
								WHEN SOLUTION_TITLE = 'CMS' THEN 8
								WHEN SOLUTION_TITLE = 'LMS' THEN 9
								WHEN SOLUTION_TITLE = 'SUBO' THEN 10
								WHEN SOLUTION_TITLE = 'MLM' THEN 11
								WHEN SOLUTION_TITLE = 'POS' THEN 12
								ELSE 13
							END ASC,
							ALL_DATA.MODULE_NO ASC,
							ALL_DATA.TYPE_RANK ASC,
							ALL_DATA.OBJECT_TITLE ASC,
							ALL_DATA.OBJECT_TYPE ASC,
							ALL_DATA.OBJECT_RANK_NUMBER ASC
						</cfif>			
			</cfquery>
			<cfif getJeliMenuUserGroup.recordcount>
				<cfset result.status = true>
				<cfset result.data = this.returnData(replace(serializeJSON(getJeliMenuUserGroup),"//",""))>
			<cfelse>
				<cfset result.status = false>
			</cfif>
			<cfcatch type="any">
				<cfset result.status = false>
			</cfcatch>  
		</cftry>
        <cfreturn Replace(serializeJSON(result),'//','')>
	</cffunction>

	<cffunction name="GET_USER_LICENCE_LOGIN" returntype="query">
		<cfargument name="employee_id" default=""/>
		<cfquery name="GET_USER_LICENCE" datasource="#this.DSN#">
			SELECT ISNULL(USER_ANSWER,2) AS USER_ANSWER FROM USER_LICENCE WHERE USER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
		</cfquery>
		<cfreturn GET_USER_LICENCE/>
	</cffunction>
</cfcomponent>