<cfcomponent>
	<!--- dil --->
	<cffunction name="upd_session" access="public">
        <cfargument name="userid" type="numeric" required="yes">
        <cfargument name="lang" type="string" required="yes">
        <cfquery name="UPDATE_SESSION" datasource="#this.dsn#">
        	UPDATE WRK_SESSION SET LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.lang#"> WHERE USERID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userid#">
            UPDATE MY_SETTINGS SET LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.lang#"> WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userid#">
        </cfquery>
        <cfreturn>
    </cffunction>
    <!--- çalışma dönemi --->
	<cffunction name="update_emp_fnc" access="public">
        <cfargument name="user_period_id" type="numeric" required="yes">
        <cfargument name="userid" type="numeric" required="yes">
        <cfargument name="position_id" type="numeric" required="yes">
        <cfquery name="UPDATE_EMP" datasource="#this.dsn#">
            UPDATE 
                EMPLOYEE_POSITIONS
            SET
                PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.user_period_id#">
            WHERE
             <cfif isdefined("arguments.position_id")>
                 POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_id#">
             <cfelse>
                 EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userid#">
             </cfif>
        </cfquery> 
        <cfreturn>
    </cffunction>
	<cffunction name="periods_fnc" access="public">
        <cfargument name="user_period_id"  required="yes">        
            <cfquery name="PERIODS" datasource="#this.dsn#">
                SELECT 
                    SETUP_PERIOD.OTHER_MONEY,
                    SETUP_PERIOD.PERIOD_ID,
                    SETUP_PERIOD.PERIOD_YEAR,
                    SETUP_PERIOD.OUR_COMPANY_ID,
                    SETUP_PERIOD.PERIOD_DATE,
                    SETUP_PERIOD.START_DATE,
                    SETUP_PERIOD.FINISH_DATE,
                    SETUP_PERIOD.IS_INTEGRATED,
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
                    OUR_COMPANY_INFO.IS_COST_LOCATION,
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
                    OUR_COMPANY_INFO.IS_EFATURA,
                    OUR_COMPANY_INFO.IS_LOT_NO,
                    ISNULL(OUR_COMPANY_INFO.IS_EDEFTER,0) AS IS_EDEFTER,
                    ISNULL(OUR_COMPANY_INFO.IS_ESHIPMENT,0) AS IS_ESHIPMENT,
                    OUR_COMPANY_INFO.ESHIPMENT_DATE,
                    OUR_COMPANY_INFO.EFATURA_DATE,
                    OUR_COMPANY_INFO.IS_EARCHIVE,
                    OUR_COMPANY_INFO.EARCHIVE_DATE,
                    OUR_COMPANY.COMPANY_NAME,
                    OUR_COMPANY.EMAIL,
                    OUR_COMPANY.NICK_NAME,
                    SETUP_MONEY.MONEY,
                    SETUP_PERIOD.STANDART_PROCESS_MONEY
                FROM
                    SETUP_PERIOD,
                    OUR_COMPANY,
                    OUR_COMPANY_INFO,
                    SETUP_MONEY
                WHERE
                    SETUP_MONEY.COMPANY_ID = SETUP_PERIOD.OUR_COMPANY_ID AND
                    SETUP_PERIOD.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.user_period_id#"> AND
                    OUR_COMPANY.COMP_ID = SETUP_PERIOD.OUR_COMPANY_ID AND
                    OUR_COMPANY_INFO.COMP_ID = OUR_COMPANY.COMP_ID AND
                    SETUP_PERIOD.PERIOD_ID = SETUP_MONEY.PERIOD_ID AND
                    SETUP_MONEY.RATE1 = SETUP_MONEY.RATE2
            </cfquery>  
        <cfreturn periods>
    </cffunction>
    <cffunction name="upd_wrk" access="public">
        <cfargument name="user_location" type="string">
        <cfargument name="period_year">
        <cfargument name="period_id">
        <cfargument name="period_is_integrated">
        <cfargument name="company_id" type="numeric">
        <cfargument name="company" type="string">
        <cfargument name="company_nick" type="string">
        <cfargument name="money" type="string">
        <cfargument name="workcube_sector" type="string">
        <cfargument name="period_date">
        <cfargument name="money2" type="string">
        <cfargument name="is_add_informations">
        <cfargument name="is_efatura">
        <cfargument name="is_edefter">
        <cfargument name="is_lot_no">
        <cfargument name="period_start_date">
        <cfargument name="period_finish_date">
        <cfargument name="userid" type="numeric">
        <cfargument name="employee_id" >
        <cfargument name="moneyFormat" >
        <cfargument name="is_eshipment">
            <cfquery name="upd_wrk_session_to_db" datasource="#this.dsn#">
                UPDATE
                    WRK_SESSION
                SET
                    <cfif isdefined("arguments.user_location")>USER_LOCATION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.user_location#">,</cfif>
                    PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_year#">,
                    PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_id#">,
                    IS_INTEGRATED = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.period_is_integrated#">,
                    COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">,
                    COMPANY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company#">,
                    COMPANY_NICK = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_nick#">,
                    MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.money#">,
                    WORKCUBE_SECTOR = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.workcube_sector#">,
                    PERIOD_DATE = #createodbcdatetime(arguments.period_date)#,
                    MONEY2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.money2#">,
                    IS_ADD_INFORMATIONS = #arguments.is_add_informations#,
                    IS_EFATURA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.is_efatura#">,
                    IS_EDEFTER = #arguments.is_edefter#,
                    IS_LOT_NO = #arguments.is_lot_no#,
                    START_DATE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.period_start_date#">,
                    FINISH_DATE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.period_finish_date#">,
                    MONEYFORMAT_STYLE = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.moneyFormat#">,
                    IS_ESHIPMENT = #arguments.is_eshipment#
                WHERE
                    <cfif isdefined("arguments.employee_id") and len("arguments.employee_id")>
                        USERID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
                    <cfelse>
                        USERID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userid#">
                    </cfif>
                    AND USER_TYPE = 0						
            </cfquery>
        <cfreturn >
    </cffunction>
    <!--- şifre --->
	<cffunction name="upd_password" access="public" returntype="query">
	<cfargument name="userid" type="numeric" required="no">
	<cfargument name="employee_id" >
        <cfquery name="GET_EMPLOYEE_NAME" datasource="#this.dsn#">
             SELECT 
                EMPLOYEE_ID,
                EMPLOYEE_PASSWORD,
                EMPLOYEE_NAME, 
                EMPLOYEE_SURNAME, 
                EMPLOYEE_USERNAME 
            FROM 
                EMPLOYEES 
            WHERE 
            <cfif isdefined("arguments.employee_id") and len(arguments.employee_id)>
                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
            <cfelse>
                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userid#">
            </cfif>
        </cfquery>
    	<cfreturn get_employee_name>
    </cffunction>
	<cffunction name="check_name_fnc" access="public" returntype="query">
        <cfargument name="userid" type="numeric" required="no">
        <cfargument name="employee_id" >
        <cfargument name="employee_username" type="string" required="yes">
        <cfquery name="CHECK_NAME" datasource="#this.dsn#">
            SELECT
                EMPLOYEE_ID
            FROM
                EMPLOYEES
            WHERE
            <cfif isdefined(arguments.employee_id)and len(arguments.employee_id)>
                EMPLOYEE_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
            <cfelse>
                EMPLOYEE_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userid#">
            </cfif>
                AND EMPLOYEE_USERNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.employee_username#">
        </cfquery>
            <cfreturn check_name>
    </cffunction>	
    <cffunction name="upd_employee_fnc" access="public">
    	<cfargument name="dsn" type="string" required="yes">
        <cfargument name="userid" type="numeric" required="yes">
        <cfargument name="employee_id" >
        <cfargument name="employee_password" type="string" required="yes">
        <cfargument name="employee_password1" type="string" required="yes">
        <cfargument name="employee_username" type="string" required="yes">
        <cfquery name="UPDATE_EMP" datasource="#arguments.dsn#">
            UPDATE 
                EMPLOYEES
            SET 
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				<cfif len(arguments.employee_password1)>			
                     ,EMPLOYEE_PASSWORD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.employee_password#">
                </cfif>
                <cfif Len(arguments.employee_username)>
                	,EMPLOYEE_USERNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.employee_username#">
                </cfif>
                
            WHERE
                <cfif isdefined(arguments.employee_id) and len(arguments.employee_id)>
                	EMPLOYEE_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
                <cfelse>
                	EMPLOYEE_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userid#">
                </cfif>
        </cfquery>
        <cfreturn>
	</cffunction>
	<cffunction name="add_fnc" access="public" returntype="query">
        <cfargument name="userid" type="numeric" required="no">
        <cfargument name="employee_id" >
        <cfargument name="employee_password_old" type="string" required="yes">
        <cfargument name="employee_password" type="string" required="yes">
        <cfquery name="add_" datasource="#this.dsn#">
            INSERT INTO
                EMPLOYEES_HISTORY
            (
                EMPLOYEE_ID,
                IS_PASSWORD_CHANGE,
                OLD_PASSWORD,
                NEW_PASSWORD,
                RECORD_DATE,
                RECORD_EMP,
                RECORD_IP
            )
            VALUES
            (
            <cfif isdefined("arguments.employee_id")and len(arguments.employee_id) >
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">,
            <cfelse>
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userid#">,
            </cfif>
                1,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.employee_password_old#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.employee_password#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userid#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
            )
        </cfquery>
        <cfreturn>
    </cffunction>
    <!--- Sistem menüleri --->
	<cffunction name="upd_wrk_session_fnc" access="public">
	<cfargument name="interface">
	<cfargument name="userid" type="numeric" required="yes">
        <cfquery name="upd_wrk_session_to_db" datasource="#this.dsn#">
            UPDATE
                WRK_SESSION
            SET
                MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.interface#">
            WHERE
                USERID = #arguments.userid#
                AND USER_TYPE = 0
        </cfquery>
    	<cfreturn >
    </cffunction>
    <!--- Belge No ayarları --->
	<cffunction name="get_paper_fnc" access="public" returntype="query">
	<cfargument name="emp_id" type="numeric" required="yes">
        <cfquery name="get_paper" datasource="#this.dsn3#">
            SELECT
                EMPLOYEE_ID
            FROM
                PAPERS_NO
            WHERE
                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.emp_id#">
        </cfquery>
    	<cfreturn get_paper>
    </cffunction>
	<cffunction name="add_paper_fnc" access="public" >
	<cfargument name="emp_id" type="numeric" required="yes">
	<cfargument name="userid" type="numeric" required="yes">
        <cfquery name="ADD_PAPER" datasource="#this.dsn3#">
            INSERT INTO
                PAPERS_NO
            (
                EMPLOYEE_ID,
                RECORD_EMP,
                RECORD_DATE,
                RECORD_IP
            )
            VALUES
            (
            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.emp_id#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userid#">,
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
            )
        </cfquery>
        <cfreturn>
    </cffunction>
	<cffunction name="upd_sett_4_fnc" access="public" >
	<cfargument name="revenue_receipt_no" type="string" required="yes">
	<cfargument name="revenue_receipt_number" type="numeric" required="yes">
	<cfargument name="invoice_no" type="string" required="yes">
	<cfargument name="invoice_number" type="numeric" required="yes">
    <cfif session.ep.our_company_info.is_efatura>
	    <cfargument name="e_invoice_no" type="string" required="yes">
	    <cfargument name="e_invoice_number" type="numeric" required="yes">
    </cfif>
	<cfargument name="ship_no" type="string" required="yes">
	<cfargument name="ship_number" type="numeric" required="yes">
    <cfargument name="userid" type="numeric" required="yes"> 
	<cfargument name="emp_id">
        <cfquery name="UPD_SETT_4" datasource="#this.dsn3#">
            UPDATE
                PAPERS_NO
            SET
                REVENUE_RECEIPT_NO = <cfif isdefined('arguments.revenue_receipt_no') and len(arguments.revenue_receipt_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.revenue_receipt_no#"><cfelse>''</cfif>,
                REVENUE_RECEIPT_NUMBER = <cfif isdefined('arguments.revenue_receipt_number') and len(arguments.revenue_receipt_number)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.revenue_receipt_number#"><cfelse>NULL</cfif>,
                INVOICE_NO = <cfif isdefined('arguments.invoice_no') and len(arguments.invoice_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.invoice_no#"><cfelse>''</cfif>,
                INVOICE_NUMBER = <cfif isdefined('arguments.invoice_number') and len(arguments.invoice_number)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.invoice_number#"><cfelse>NULL</cfif>,
                E_INVOICE_NO = <cfif isdefined('arguments.e_invoice_no') and len(arguments.e_invoice_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.e_invoice_no#"><cfelse>''</cfif>,
                E_INVOICE_NUMBER = <cfif isdefined('arguments.e_invoice_number') and len(arguments.e_invoice_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.e_invoice_number#"><cfelse>NULL</cfif>,
                SHIP_NO = <cfif isdefined('arguments.ship_no') and len(arguments.SHIP_NO)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ship_no#"><cfelse>''</cfif>,
                SHIP_NUMBER = <cfif isdefined('arguments.ship_number') and LEN(arguments.ship_number)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ship_number#"><cfelse>NULL</cfif>,
                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userid#">,
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
            WHERE
                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.emp_id#">
        </cfquery>
        <cfreturn>
    </cffunction>
	<cffunction name="getLangs" access="public" returntype="query">
		<cfargument name="dataSource" type="string" required="yes">
		<cfquery name="GET_LANG" datasource="#arguments.dataSource#">
            SELECT LANGUAGE_SET,LANGUAGE_SHORT FROM SETUP_LANGUAGE
        </cfquery>
    	<cfreturn GET_LANG>
    </cffunction>
    <cffunction name="GET_MY_POSITION_CAT_USER_GROUP" access="public" returntype="query">
        <cfargument name="dataSource" type="string" required="yes">
        <cfargument name="positionCode" type="numeric" required="yes">
        <cfquery name="GET_MY_POSITION_CAT_USER_GROUP" datasource="#arguments.dataSource#">
            SELECT POSITION_CAT_ID,USER_GROUP_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.positionCode#">
        </cfquery>
		<cfreturn GET_MY_POSITION_CAT_USER_GROUP>
    </cffunction>
    <cffunction name="GET_OZEL_MENUS" access="public" returntype="query">
        <cfargument name="dataSource" type="string" required="yes">
        <cfargument name="positionCatId" type="numeric" required="yes">
        <cfargument name="userGroupId" type="numeric" required="yes">
        <cfargument name="employeeId" type="numeric" required="yes">
        <cfquery name="GET_OZEL_MENUS" datasource="#arguments.dataSource#">
            SELECT * FROM MAIN_MENU_SETTINGS WHERE (POSITION_CAT_IDS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#arguments.positionCatId#,%"> OR USER_GROUP_IDS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#arguments.userGroupId#,%"> OR TO_EMPS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#arguments.employeeId#,%">) AND IS_ACTIVE = 1
        </cfquery>
		<cfreturn GET_OZEL_MENUS>
    </cffunction>
    <cffunction name="get_papers" access="public" returntype="query">
        <cfargument name="dataSource" type="string" required="yes">
        <cfargument name="userId" type="numeric" required="yes">
        <cfquery name="get_papers" datasource="#arguments.dataSource#">
            SELECT REVENUE_RECEIPT_NO, REVENUE_RECEIPT_NUMBER,INVOICE_NO, INVOICE_NUMBER, E_INVOICE_NO, E_INVOICE_NUMBER, SHIP_NO, SHIP_NUMBER FROM PAPERS_NO WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userId#">
        </cfquery>
		<cfreturn get_papers>
    </cffunction>
    <cffunction name="GET_MY_REPORTS" access="public" returntype="query">
        <cfargument name="dataSource" type="string" required="yes">
        <cfargument name="userId" type="numeric" required="yes">
        <cfquery name="GET_MY_REPORTS" datasource="#arguments.dataSource#">
            SELECT 
                RW.*,
                R.REPORT_NAME,
                R.IS_FILE,
                R.RECORD_DATE
            FROM 
                REPORT_ACCESS_RIGHTS  RW,
                REPORTS R
            WHERE 		
                R.REPORT_ID = RW.REPORT_ID AND
                (
                    POS_CAT_ID = (SELECT POSITION_CAT_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userId#"> AND IS_MASTER = 1) OR
                    POS_CODE = (SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userId#"> AND IS_MASTER = 1)
                )
        </cfquery>
		<cfreturn GET_MY_REPORTS>
    </cffunction>
    <cffunction name="GET_COMPANIES" access="public" returntype="query">
        <cfargument name="dataSource" type="string" required="yes">
        <cfargument name="positionCode" type="numeric" required="yes">
        <cfquery name="GET_COMPANIES" datasource="#arguments.dataSource#">
			SELECT DISTINCT
                COMP_ID,
                COMPANY_NAME
            FROM 
                SETUP_PERIOD SP,
                OUR_COMPANY O,
                EMPLOYEE_POSITION_PERIODS EP
                LEFT JOIN EMPLOYEE_POSITIONS AS EP2 ON EP.POSITION_ID = EP2.POSITION_ID
            WHERE 
                EP.PERIOD_ID = SP.PERIOD_ID AND 
                EP2.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.positionCode#"> AND
                SP.OUR_COMPANY_ID = O.COMP_ID
            ORDER BY
                COMPANY_NAME
        </cfquery>
		<cfreturn GET_COMPANIES>
    </cffunction>
    <cffunction name="GET_PROFILE" access="public" returntype="query">
        <cfargument name="userId" type="numeric" required="yes">
        <cfset dsn = application.systemParam.systemParam().dsn>
        <cfquery name="GET_MY_PROFILE" datasource="#dsn#">
            SELECT
                W.NAME,
                W.SURNAME ,                            
                W.POSITION_NAME,
                E.PHOTO,  
                E2.SEX                                                     
            FROM
                WRK_SESSION AS W
                LEFT JOIN EMPLOYEES AS E ON E.EMPLOYEE_ID = W.USERID
                LEFT JOIN EMPLOYEES_DETAIL AS E2 ON E2.EMPLOYEE_ID = W.USERID                             
            WHERE
               W.USERID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userid#">
        </cfquery>
		<cfreturn GET_MY_PROFILE>
    </cffunction>
    <cffunction name="ONLINE_USER" access="public" returntype="query">
        <cfset dsn = application.systemParam.systemParam().dsn>
        <cfquery name="GET_ONLINE_USER" datasource="#dsn#">
            SELECT 
                W.NAME + ' ' + W.SURNAME AS KULLANICI,
                W.USERID,
                W.POSITION_NAME,
                E.PHOTO,
                E2.SEX,
                W.ACTION_PAGE,
                W.USER_IP,
                W.ACTION_DATE                            
            FROM
                WRK_SESSION AS W
                LEFT JOIN EMPLOYEES AS E ON E.EMPLOYEE_ID = W.USERID
                LEFT JOIN EMPLOYEES_DETAIL AS E2 ON E2.EMPLOYEE_ID = W.USERID
            ORDER BY
                W.NAME + ' ' + W.SURNAME ASC
        </cfquery>
		<cfreturn GET_ONLINE_USER>
    </cffunction>
    <cffunction name="USER_FAVORITES" access="public" returntype="query">
    	<cfargument name="userId" type="numeric" required="yes">
        <cfset dsn = application.systemParam.systemParam().dsn>
        <cfquery name="MY_FAVORITE" datasource="#dsn#">
			SELECT 
                FAVORITE,
                FAVORITE_NAME,
                IS_NEW_PAGE
            FROM 
                FAVORITES 
            WHERE 
                EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userid#">
            ORDER BY 
                FAVORITE_NAME
        </cfquery>
		<cfreturn MY_FAVORITE>
    </cffunction>
    <cffunction name="GET_EVENT_CAT_HEADER" access="public" returntype="query">
    	<cfargument name="userId" type="numeric" required="yes">
        <cfset dsn = application.systemParam.systemParam().dsn>
        <cfquery name="GET_EVENT_CATS" datasource="#dsn#">
            SELECT 
                IS_STANDART = 
                CASE
                  WHEN (SELECT M.EVENTCAT_ID FROM MY_SETTINGS M WHERE M.EVENTCAT_ID = EVENT_CAT.EVENTCAT_ID AND M.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userid#">) IS NULL THEN '0'
                      ELSE '1'
                 END,
                EVENTCAT,
                EVENTCAT_ID		
            FROM 
                EVENT_CAT
            ORDER BY
                EVENTCAT
        </cfquery>
		<cfreturn GET_EVENT_CATS>
    </cffunction>
</cfcomponent>
