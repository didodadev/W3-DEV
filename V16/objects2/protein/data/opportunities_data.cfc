<cfcomponent extends="cfc.queryJSONConverter">
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset result = StructNew()>
    <cfif isdefined("session.pp")>
        <cfset session_base = evaluate('session.pp')>
        <cfset company_id = session.pp.our_company_id>
        <cfset period_year = session.pp.period_year>
        <cfset language = session.pp.language>
    <cfelseif isdefined("session.ep")>
        <cfset session_base = evaluate('session.ep')>
        <cfset company_id = session.ep.our_company_id>
        <cfset period_year = session.ep.period_year>
        <cfset language = session.ep.language>
    <cfelseif isdefined("session.cp")>
        <cfset session_base = evaluate('session.cp')>
    <cfelseif isdefined("session.ww")>
        <cfset session_base = evaluate('session.ww')>
        <cfset company_id = session.ww.our_company_id>
        <cfset period_year = session.ww.period_year>
        <cfset language = session.ww.language>
    </cfif>    

    <cfset dsn1_alias = "#dsn#_product">
    <cfset dsn_alias = '#dsn#'>
    <cfset dsn2 = dsn2_alias = '#dsn#_#session_base.period_year#_#session_base.OUR_COMPANY_ID#' />
    <cfset dsn3 = dsn3_alias = '#dsn#_#session_base.OUR_COMPANY_ID#' />
    
    <!--- ! list_opportunitites.cfm --->
    <cffunction name="GET_PROBABILITY_RATE" access="remote">
        
        <cfquery name="GET_PROBABILITY_RATE" datasource="#dsn3#">
            SELECT 
                PROBABILITY_RATE_ID, 
                PROBABILITY_RATE, 
                PROBABILITY_NAME, 
                RECORD_EMP, 
                RECORD_DATE, 
                RECORD_IP, 
                UPDATE_EMP, 
                UPDATE_DATE, 
                UPDATE_IP 
            FROM 
                SETUP_PROBABILITY_RATE            
            <cfif isdefined('arguments.probability_rate_id') and len(arguments.probability_rate_id)>
                WHERE
                PROBABILITY_RATE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.probability_rate_id#">
             </cfif>
               
            ORDER BY 
                PROBABILITY_RATE ASC
        </cfquery>

        <cfreturn GET_PROBABILITY_RATE>
    </cffunction>

    <cffunction name="GET_OPP_CURRENCIES" access="remote">
        
        <cfquery name="GET_OPP_CURRENCIES" datasource="#dsn3#">
            SELECT 
                OPP_CURRENCY_ID,
                CASE
                    WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
                    ELSE OPP_CURRENCY
                END AS OPP_CURRENCY
             FROM 
            OPPORTUNITY_CURRENCY 
              LEFT JOIN #DSN_ALIAS#.SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = OPPORTUNITY_CURRENCY.OPP_CURRENCY_ID
                AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="OPP_CURRENCY">
                AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="OPPORTUNITY_CURRENCY">
                AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#language#">
            ORDER BY OPP_CURRENCY
        </cfquery>       

        <cfreturn GET_OPP_CURRENCIES>
    </cffunction>

    <cffunction name="GET_SALE_ADD_OPTION" access="remote" returntype="string">
        
        <cfquery name="GET_SALE_ADD_OPTION" datasource="#DSN3#">
            SELECT
                CASE
                    WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
                    ELSE SALES_ADD_OPTION_NAME
                END AS SALES_ADD_OPTION_NAME,
                SALES_ADD_OPTION_ID
            FROM
                SETUP_SALES_ADD_OPTIONS
                LEFT JOIN #DSN#.SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = SETUP_SALES_ADD_OPTIONS.SALES_ADD_OPTION_ID
                AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SALES_ADD_OPTION_NAME">
                AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_SALES_ADD_OPTIONS">
                AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#language#">
            ORDER BY
                SALES_ADD_OPTION_NAME
        </cfquery>

        <cfreturn GET_SALE_ADD_OPTION>
    </cffunction>

    <cffunction  name="GET_POSITIONS" access="remote" returntype="any">
        <cfquery name="GET_POSITIONS" datasource="#dsn#">
            SELECT
                EMPLOYEE_POSITIONS.EMPLOYEE_ID,
                EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
                EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
                EMPLOYEE_POSITIONS.EMPLOYEE_EMAIL,
                EMPLOYEE_POSITIONS.POSITION_CODE,
                EMPLOYEE_POSITIONS.POSITION_NAME,
                EMPLOYEE_POSITIONS.POSITION_ID,
                BRANCH.BRANCH_NAME,
                BRANCH.BRANCH_ID,
                DEPARTMENT.DEPARTMENT_HEAD,
                DEPARTMENT.DEPARTMENT_ID,
                EMPLOYEES.GROUP_STARTDATE
            FROM
                EMPLOYEE_POSITIONS,
                DEPARTMENT,
                BRANCH,
                EMPLOYEES
            WHERE
                EMPLOYEE_POSITIONS.POSITION_STATUS=1 AND
                EMPLOYEE_POSITIONS.VALID=2 AND
                EMPLOYEES.EMPLOYEE_STATUS=1 AND
                EMPLOYEE_POSITIONS.EMPLOYEE_ID>0 AND
                EMPLOYEES.EMPLOYEE_ID=EMPLOYEE_POSITIONS.EMPLOYEE_ID AND
                EMPLOYEE_POSITIONS.DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID AND
                DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID 
            <cfif not isDefined("arguments.show_empty_pos")>
                AND EMPLOYEES.EMPLOYEE_ID=EMPLOYEE_POSITIONS.EMPLOYEE_ID 
                AND EMPLOYEE_POSITIONS.DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID
            </cfif>
            <cfif isDefined("arguments.keyword") and len(arguments.keyword)>
                <cfif len(arguments.keyword) eq 1>
                    AND EMPLOYEE_POSITIONS.EMPLOYEE_NAME LIKE '#arguments.keyword#%'
                <cfelse>
                    <cfif database_type is 'MSSQL'>
                    AND EMPLOYEE_POSITIONS.EMPLOYEE_NAME + ' ' + EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME LIKE '%#arguments.keyword#%'
                    <cfelseif database_type is 'DB2'>
                    AND EMPLOYEE_POSITIONS.EMPLOYEE_NAME || ' ' || EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME LIKE '%#arguments.keyword#%'
                    </cfif>
                </cfif>
            </cfif>
            <cfif isDefined("arguments.branch_id") and len(arguments.branch_id)>
                AND BRANCH.BRANCH_ID = #arguments.branch_id#
            </cfif>
            <cfif isDefined("arguments.our_cid")>
                AND BRANCH.COMPANY_ID = #arguments.our_cid# 
            </cfif>
            <cfif isdefined("arguments.branch_related")>
                AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.pda.position_code#)
            </cfif>
            <cfif isdefined("arguments.employee_list") and arguments.employee_list neq "">
                AND EMPLOYEES.EMPLOYEE_ID IN (
                    SELECT
                        EMPLOYEE_POSITIONS.EMPLOYEE_ID
                    FROM 
                        BRANCH,
                        EMPLOYEE_POSITIONS,
                        DEPARTMENT
                    WHERE
                        BRANCH.BRANCH_ID IN ( SELECT EMPLOYEE_POSITION_BRANCHES.BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.pda.position_code# )
                        AND EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
                        DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
                )
            </cfif>
            ORDER BY
                EMPLOYEE_POSITIONS.EMPLOYEE_NAME
        </cfquery>
        <cfreturn GET_POSITIONS>
    </cffunction>

    <cffunction name="GET_OPPORTUNITIES" access="remote">
        
        <cfargument name="keyword" type="string" required="no" default="">
        <cfargument name="keyword_detail" type="string" required="no" default="">
        <cfargument name="keyword_oppno" type="string" required="no" default="">
        <cfargument name="start_date" type="string" required="no" default="">
        <cfargument name="finish_date" type="string" required="no" default="">
        <cfargument name="ordertype" type="string" required="no" default="">
        <cfargument name="member_type" type="string" required="no" default="">
        <cfargument name="sales_emp_id" type="string" required="no" default="">
        <cfargument name="sales_member_type" type="string" required="no" default="">
        <cfargument name="record_employee_id" type="string" required="no" default="">
        <cfargument name="process_stage" type="string" required="no" default="">
        <cfargument name="opportunity_type_id" type="string" required="no" default="">
        <cfargument name="product_cat_id" type="string" required="no" default="">
        <cfargument name="stock_name" type="string" required="no" default="">
        <cfargument name="sale_add_option" type="string" required="no" default="">
        <cfargument name="probability" type="string" required="no" default="">
        <cfargument name="opp_currency_id" type="string" required="no" default="">
        <cfif isdefined('arguments.selected_company') and len(arguments.selected_company)>
            <cfset dsn3 = dsn3_alias = '#dsn#_#arguments.selected_company#' />
        </cfif>
        <cfquery name="GET_OPPORTUNITIES" datasource="#DSN3#">
            SELECT
                OPPORTUNITIES.OPP_NO,
                OPPORTUNITIES.PROJECT_ID,
                OPPORTUNITIES.OPP_CURRENCY_ID,
                OPPORTUNITIES.CONSUMER_ID,
                OPPORTUNITIES.PARTNER_ID,
                OPPORTUNITIES.OPP_HEAD,
                OPPORTUNITIES.OPP_DATE,
                OPPORTUNITIES.PROBABILITY,
                OPPORTUNITIES.INCOME,
                OPPORTUNITIES.MONEY,
                OPPORTUNITIES.SALES_EMP_ID,
                OPPORTUNITIES.SALES_PARTNER_ID,
                OPPORTUNITIES.SALES_CONSUMER_ID,
                OPPORTUNITIES.RECORD_DATE,
                OPPORTUNITIES.OPP_ID,
                OPPORTUNITIES.REF_COMPANY_ID,
                OPPORTUNITIES.REF_PARTNER_ID,
                OPPORTUNITIES.STOCK_ID,
                OPPORTUNITIES.PRODUCT_CAT_ID,
                OPPORTUNITIES.COMPANY_ID,
                OPPORTUNITIES.OPPORTUNITY_TYPE_ID,
                OPPORTUNITIES.ACTIVITY_TIME,
                OPPORTUNITIES.COST,
                OPPORTUNITIES.MONEY2,
                OPPORTUNITIES.SALE_ADD_OPTION_ID,
                OPPORTUNITIES.UPDATE_DATE,
                OPPORTUNITIES.OPP_STAGE,                
                CP.COMPANY_PARTNER_NAME + ' ' + CP.COMPANY_PARTNER_SURNAME PARTNER_NAME_SURNAME,                     
                CP.TITLE,
                C.FULLNAME,
                E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME EMPLOYEES_NAME,
                PP.PROJECT_HEAD,
                SOT.OPPORTUNITY_TYPE,
                SOT.OPPORTUNITY_TYPE_ID,
                SSAO.SALES_ADD_OPTION_NAME,
                C2.NICKNAME NICKNAME,
                SPR.PROBABILITY_NAME,
                PTR.STAGE,
                PTR.LINE_NUMBER,
                OC.OPP_CURRENCY
            FROM
                OPPORTUNITIES WITH (NOLOCK) 
                LEFT JOIN #dsn_alias#.PRO_PROJECTS PP ON PP.PROJECT_ID = OPPORTUNITIES.PROJECT_ID
                LEFT JOIN #dsn_alias#.EMPLOYEES E ON E.EMPLOYEE_ID = OPPORTUNITIES.SALES_EMP_ID
                LEFT JOIN #dsn_alias#.EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = OPPORTUNITIES.SALES_EMP_ID
                LEFT JOIN #dsn_alias#.COMPANY_PARTNER CP ON OPPORTUNITIES.PARTNER_ID = CP.PARTNER_ID
                LEFT JOIN #dsn_alias#.COMPANY C ON CP.COMPANY_ID = C.COMPANY_ID
                LEFT JOIN SETUP_OPPORTUNITY_TYPE SOT ON OPPORTUNITIES.OPPORTUNITY_TYPE_ID = SOT.OPPORTUNITY_TYPE_ID
                LEFT JOIN SETUP_SALES_ADD_OPTIONS SSAO ON OPPORTUNITIES.SALE_ADD_OPTION_ID = SSAO.SALES_ADD_OPTION_ID
                LEFT JOIN #dsn_alias#.COMPANY_PARTNER CP2 ON OPPORTUNITIES.SALES_PARTNER_ID = CP2.PARTNER_ID
                LEFT JOIN #dsn_alias#.COMPANY C2 ON CP2.COMPANY_ID = C2.COMPANY_ID	
                LEFT JOIN SETUP_PROBABILITY_RATE SPR ON OPPORTUNITIES.PROBABILITY = SPR.PROBABILITY_RATE_ID
                LEFT JOIN #dsn_alias#.PROCESS_TYPE_ROWS PTR ON OPPORTUNITIES.OPP_STAGE = PTR.PROCESS_ROW_ID
                LEFT JOIN OPPORTUNITY_CURRENCY OC ON OPPORTUNITIES.OPP_CURRENCY_ID = OC.OPP_CURRENCY_ID	
             WHERE
                OPPORTUNITIES.OPP_ID IS NOT NULL
                <cfif len(arguments.keyword)>
                    AND OPPORTUNITIES.OPP_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(arguments.keyword)#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
                </cfif>
                <cfif len(arguments.keyword_detail)>
                    AND OPPORTUNITIES.OPP_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(arguments.keyword_detail)#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
                </cfif>
                <cfif len(arguments.keyword_oppno)>
                    AND OPPORTUNITIES.OPP_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.keyword_oppno)#"> COLLATE SQL_Latin1_General_CP1_CI_AI
                </cfif>
                <cfif len(arguments.start_date)>AND OPPORTUNITIES.OPP_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"></cfif>
                <cfif len(arguments.finish_date)>AND OPPORTUNITIES.OPP_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#"></cfif>
                <cfif isdefined("arguments.opp_status") and len(arguments.opp_status)>AND OPPORTUNITIES.OPP_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#arguments.opp_status#"></cfif>
                <cfif len(arguments.ordertype) and arguments.ordertype eq 4> <!--- Takip Kaydına Göre --->
                    AND OPPORTUNITIES.OPP_ID IN (SELECT OPPORTUNITIES_PLUS.OPP_ID FROM OPPORTUNITIES_PLUS,OPPORTUNITIES WHERE OPPORTUNITIES.OPP_ID = OPPORTUNITIES_PLUS.OPP_ID)
                </cfif> 
                <cfif len(arguments.member_type) and (arguments.member_type is 'partner') and len(arguments.member_name) and len(arguments.company_id)>
                    AND OPPORTUNITIES.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
                </cfif>
                <cfif len(arguments.member_type) and (arguments.member_type is 'consumer') and len(arguments.member_name) and len(arguments.consumer_id)>
                    AND OPPORTUNITIES.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
                </cfif>
                <cfif len(arguments.sales_emp_id) and len(arguments.sales_emp)>
                    AND OPPORTUNITIES.SALES_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sales_emp_id#">
                </cfif>
                <cfif len(arguments.sales_member_type) and (arguments.sales_member_type is 'partner') and isdefined('arguments.sales_member_id') and len(arguments.sales_member_id)>
                    AND OPPORTUNITIES.SALES_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sales_member_id#">
                <cfelseif isdefined("session.pp")>
                    AND (OPPORTUNITIES.SALES_PARTNER_ID IN (SELECT PARTNER_ID FROM #dsn_alias#.COMPANY_PARTNER WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">)
                    OR OPPORTUNITIES.REF_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
                    OR OPPORTUNITIES.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">)               
                </cfif>
                <cfif len(arguments.sales_member_type) and (arguments.sales_member_type is 'consumer') and len(arguments.sales_member_id) and len(arguments.sales_member_name)>
                    AND OPPORTUNITIES.SALES_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sales_member_id#">
                </cfif>
                <cfif len(arguments.record_employee_id) and len(arguments.record_employee)>
                    AND OPPORTUNITIES.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.record_employee_id#">
                </cfif>
                <cfif listlen(arguments.process_stage)>
                    AND OPPORTUNITIES.OPP_STAGE IN (#arguments.process_stage#)
                </cfif>
                <cfif listlen(arguments.opportunity_type_id)>
                    AND OPPORTUNITIES.OPPORTUNITY_TYPE_ID IN (#arguments.opportunity_type_id#)
                </cfif>
                <cfif len(arguments.product_cat_id) and len(arguments.product_cat)>
                    AND OPPORTUNITIES.PRODUCT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_cat_id#">
                </cfif>
                <cfif len(arguments.stock_name) and len(arguments.stock_id)>
                    AND OPPORTUNITIES.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#">
                </cfif>
                <cfif len(arguments.sale_add_option)> 
                    AND OPPORTUNITIES.SALE_ADD_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sale_add_option#">
                </cfif>
                <cfif len(arguments.probability)>
                    AND OPPORTUNITIES.PROBABILITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.probability#">
                </cfif>
                <cfif len(arguments.opp_currency_id)>
                    AND OPPORTUNITIES.OPP_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.opp_currency_id#">
                </cfif>
                <cfif isdefined("arguments.project_head") and len(arguments.project_head) and isdefined("arguments.project_id") and len(arguments.project_id)>
                    AND OPPORTUNITIES.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">
                </cfif>                
                <cfif isdefined('arguments.rival_preference_reasons') and len(arguments.rival_preference_reasons)>
                    AND(
                    <cfloop list="#arguments.rival_preference_reasons#" index="aa" delimiters=",">
                        OPPORTUNITIES.PREFERENCE_REASON_ID LIKE '%,#aa#,%' <cfif aa neq listlast(arguments.rival_preference_reasons,',') and listlen(arguments.rival_preference_reasons,',') gte 1> OR</cfif>
                    </cfloop>)
                </cfif>            
            ORDER BY	              
                OPPORTUNITIES.OPP_ID DESC             
        </cfquery>

        <cfreturn GET_OPPORTUNITIES>
    </cffunction>


    <cffunction name="get_process_type" access="remote" returntype="string">
        
        <cfquery name="get_process_type" datasource="#dsn#">
            SELECT
                PTR.STAGE,
                PTR.PROCESS_ROW_ID
            FROM
                PROCESS_TYPE_ROWS PTR,
                PROCESS_TYPE_OUR_COMPANY PTO,
                PROCESS_TYPE PT
            WHERE
                PT.IS_ACTIVE = 1 AND
                PT.PROCESS_ID = PTR.PROCESS_ID AND
                PT.PROCESS_ID = PTO.PROCESS_ID AND
                PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#"> AND
                PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listfirst(arguments.fuseaction,'.')#.form_add_opportunity%">
            ORDER BY
                PTR.LINE_NUMBER
        </cfquery>

        <cfreturn get_process_type>
    </cffunction>

    <!---! opportunities detail --->

    <cffunction name="GET_OPPORTUNITY" access="remote">
        <cfargument name="opp_id" type="numeric" default="">
        <cfquery name="GET_OPPORTUNITY" datasource="#DSN3#">
            SELECT 
                * 
            FROM 
                OPPORTUNITIES 
                LEFT JOIN #dsn_alias#.PROCESS_TYPE_ROWS PTR ON OPPORTUNITIES.OPP_STAGE = PTR.PROCESS_ROW_ID
            WHERE 
                OPP_ID = #arguments.opp_id#              
        </cfquery>

        <cfreturn GET_OPPORTUNITY>
    </cffunction>

    <cffunction name="GET_OPPORTUNITY_TYPE" access="remote">
        <cfargument name="opportunity_type_id" default="0">
        <cfargument name="is_internet" default="">
        <cfquery name="GET_OPPORTUNITY_TYPE" datasource="#DSN3#">
            SELECT
                OPPORTUNITY_TYPE_ID,
                CASE
                    WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
                    ELSE OPPORTUNITY_TYPE
                END AS OPPORTUNITY_TYPE
            FROM
                SETUP_OPPORTUNITY_TYPE
                LEFT JOIN #DSN_ALIAS#.SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = SETUP_OPPORTUNITY_TYPE.OPPORTUNITY_TYPE_ID
                AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="OPPORTUNITY_TYPE">
                AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_OPPORTUNITY_TYPE">
                AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#language#">      
                <cfif isdefined("arguments.is_internet") and len(arguments.is_internet)>
                    AND SETUP_OPPORTUNITY_TYPE.IS_INTERNET = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.is_internet#"> 
                </cfif>
            ORDER BY
                OPPORTUNITY_TYPE_ID 
        </cfquery>
        <cfreturn GET_OPPORTUNITY_TYPE>
    </cffunction>

    <!---! add opportunities --->

    <cffunction name="GET_COMMETHOD_CATS" access="remote">
        <cfquery name="GET_COMMETHOD_CATS" datasource="#dsn#">
            SELECT
            CASE
                WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
                    ELSE COMMETHOD
                END AS COMMETHOD
                ,
                COMMETHOD_ID
            FROM
                SETUP_COMMETHOD
                LEFT JOIN #DSN_ALIAS#.SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = SETUP_COMMETHOD.COMMETHOD_ID
                AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="COMMETHOD">
                AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_COMMETHOD">
                AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.language#">
            ORDER BY
                COMMETHOD
        </cfquery>
        <cfreturn GET_COMMETHOD_CATS>
    </cffunction>


    <cffunction name="GET_MONEYS" access="remote">
        <cfquery name="GET_MONEYS" datasource="#DSN#">
            SELECT
                MONEY_ID,
                MONEY
            FROM
                SETUP_MONEY
            WHERE
                PERIOD_ID = #session_base.PERIOD_ID#
        </cfquery>
        <cfreturn GET_MONEYS>
    </cffunction>

    <cffunction name="get_probability" access="remote">
        <cfquery name="get_probability" datasource="#dsn3#">
            SELECT * FROM SETUP_PROBABILITY_RATE
        </cfquery>
        <cfreturn get_probability>
    </cffunction>
  

    <cffunction name="ADD_OPPORTUNITY" access="remote" returntype="string" returnformat="json">
        <cfargument name="opportunity_type_id" default="">
        <cfargument name="member_type"  default="">
        <cfargument name="member_id"  default="">
        <cfargument name="company_id"  default="">
        <cfargument name="ref_member_type"  default="">
        <cfargument name="ref_partner_id"  default="">
        <cfargument name="ref_company_id"  default="">
        <cfargument name="ref_consumer_id"  default="">
        <cfargument name="ref_employee_id"  default="">
        <cfargument name="process_stage"  default="">
        <cfargument name="commethod_id"  default="">
        <cfargument name="opp_detail"  default="">
        <cfargument name="income"  default="">
        <cfargument name="money"  default="">
        <cfargument name="cost"  default="">
        <cfargument name="money2"  default="">
        <cfargument name="stock_id"  default="">
        <cfargument name="sales_team_id"  default="">
        <cfargument name="sales_emp_id"  default="">
        <cfargument name="sales_member_id"  default="">
        <cfargument name="sales_consumer_id"  default="">
        <cfargument name="opp_date"  default="">
        <cfargument name="opp_invoice_date"  default="">
        <cfargument name="action_date"  default="">
        <cfargument name="opp_currency_id"  default="">
        <cfargument name="activity_time"  default="">
        <cfargument name="probability"  default="">
        <cfargument name="opp_head"  default="">
        <cfargument name="project_id"  default="">
        <cfargument name="sales_add_option"  default="">
        <cfargument name="service_id"  default="">
        <cfargument name="cus_help_id"  default="">
        <cfargument name="camp_name"  default="">
        <cfargument name="camp_id"  default="">
        <cfargument name="country_id"  default="">
        <cfargument name="sales_zone_id"  default="">
        <cfargument name="event_plan_row_id"  default="">
        <cfargument name="process_cat"  default="">
        <cfargument name="opp_id"  default="">
        
        
        <cftry>               
            <cf_papers paper_type="OPPORTUNITY">
            <cfset system_paper_no = paper_code & '-' & paper_number>
            <cfset system_paper_no_add = paper_number>
            <cfquery name="ADD_OPPORTUNITY" datasource="#DSN3#" result="MAX_ID">
                INSERT INTO
                    OPPORTUNITIES
                    (
                    OPPORTUNITY_TYPE_ID,
                    <cfif arguments.member_type is 'partner'>
                        PARTNER_ID,
                        COMPANY_ID,	
                    <cfelseif arguments.member_type is 'consumer'>
                        CONSUMER_ID,
                    </cfif>
                    <cfif isdefined("arguments.ref_member_type") and arguments.ref_member_type is 'partner'>
                        REF_PARTNER_ID,
                        REF_COMPANY_ID,				
                    <cfelseif isdefined("arguments.ref_member_type") and arguments.ref_member_type is 'consumer'>
                        REF_CONSUMER_ID,
                    <cfelseif isdefined("arguments.ref_member_type") and arguments.ref_member_type is 'employee'>
                        REF_EMPLOYEE_ID,
                    <cfelse>
                        REF_PARTNER_ID,
                        REF_COMPANY_ID,
                        REF_CONSUMER_ID,
                        REF_EMPLOYEE_ID,
                    </cfif>
                    OPP_STAGE,
                    COMMETHOD_ID,
                    PRODUCT_CAT_ID,
                    OPP_DETAIL,
                    INCOME,
                    MONEY,
                    COST,
                    MONEY2,
                    STOCK_ID,
                    SALES_TEAM_ID,
                    SALES_EMP_ID,
                    SALES_PARTNER_ID,
                    SALES_CONSUMER_ID,
                    OPP_DATE,
                    INVOICE_DATE,
                    ACTION_DATE,
                    OPP_CURRENCY_ID,
                    OPP_STATUS,
                    ACTIVITY_TIME,
                    PROBABILITY,
                    OPP_HEAD,
                    OPP_ZONE,
                    PROJECT_ID,
                    OPP_NO,
                    SALE_ADD_OPTION_ID,
                    SERVICE_ID,
                    CUS_HELP_ID,
                    CAMPAIGN_ID,
                    RECORD_EMP,
                    RECORD_IP,
                    RECORD_DATE,
                    ADD_RSS,
                    COUNTRY_ID,
                    SZ_ID,
                    EVENT_PLAN_ROW_ID,
                    PROCESS_CAT
                    )
                VALUES
                    (
                    <cfif len(arguments.opportunity_type_id)>#arguments.opportunity_type_id#<cfelse>NULL</cfif>,
                    <cfif arguments.member_type is 'partner'>
                        #arguments.member_id#,
                        #arguments.company_id#,					
                    <cfelseif arguments.member_type is 'consumer'>
                        #arguments.member_id#,
                    </cfif>
                    <cfif isdefined("arguments.ref_member_type") and arguments.ref_member_type is 'partner'>
                        #arguments.ref_partner_id#,
                        #arguments.ref_company_id#,					
                    <cfelseif isdefined("arguments.ref_member_type") and arguments.ref_member_type is 'consumer'>
                        #arguments.ref_consumer_id#,
                    <cfelseif isdefined("arguments.ref_member_type") and arguments.ref_member_type is 'employee'>
                        #arguments.ref_employee_id#,
                    <cfelse>
                        NULL,
                        NULL,
                        NULL,
                        NULL,				
                    </cfif>
                    #arguments.process_stage#,
                    <cfif len(arguments.commethod_id)>#arguments.commethod_id#<cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.product_cat_id") and  len(arguments.product_cat_id)>#arguments.product_cat_id#<cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.opp_detail#">,
                    <cfif len(arguments.income)>#Replace(arguments.income,',','.','all')#<cfelse>NULL</cfif>,
                    <cfif len(arguments.money) and len(arguments.income)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.money#"><cfelse>NULL</cfif>,
                    <cfif len(arguments.cost)>#arguments.cost#<cfelse>NULL</cfif>,
                    <cfif len(arguments.money2) and len(arguments.cost)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.money2#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.stock_id") and len(arguments.stock_id)>#arguments.stock_id#<cfelse>NULL</cfif>,
                    <cfif len(arguments.sales_team_id)>#arguments.sales_team_id#<cfelse>NULL</cfif>,
                    <cfif len(arguments.sales_emp_id)>#arguments.sales_emp_id#<cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.sales_member_id") and  len(arguments.sales_member_id) and arguments.sales_member_type is 'partner'>
                        #arguments.sales_member_id#,
                        NULL,
                    <cfelseif isdefined("arguments.sales_member_id") and len(arguments.sales_member_id)  and arguments.sales_member_type is 'consumer'>
                        NULL,
                        #arguments.sales_consumer_id#,
                    <cfelse>
                        NULL,
                        NULL,
                    </cfif>
                    #now()#,
                    <cfif isdefined("arguments.opp_invoice_date") and  len(arguments.opp_invoice_date)>#arguments.opp_invoice_date#<cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.action_date") and len(arguments.action_date)>#arguments.action_date#<cfelse>NULL</cfif>,
                    <cfif len(arguments.opp_currency_id)>#arguments.opp_currency_id#<cfelse>NULL</cfif>,
                    1,
                    <cfif isdefined("arguments.activity_time") and len(arguments.activity_time)>#arguments.activity_time#<cfelse>NULL</cfif>,
                    <cfif len(arguments.probability)>#arguments.probability#<cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.opp_head#">,
                    0,
                    <cfif len(arguments.project_id)>#arguments.project_id#<cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#system_paper_no#">,
                    <cfif len(arguments.sales_add_option)>#arguments.sales_add_option#<cfelse>NULL</cfif>,
                    <cfif len(arguments.service_id)>#arguments.service_id#<cfelse>NULL</cfif>,
                    <cfif isdefined('arguments.cus_help_id') and len(arguments.cus_help_id)>#arguments.cus_help_id#<cfelse>NULL</cfif>,
                    <cfif isdefined('arguments.camp_name') and len(arguments.camp_name) and isdefined('arguments.camp_id') and Len(arguments.camp_id)>#arguments.camp_id#<cfelse>NULL</cfif>,
                    #session_base.userid#,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                    #now()#,
                    <cfif isdefined('form.add_rss') and len(form.add_rss)>1<cfelse>0</cfif>,
                    <cfif isdefined('arguments.country_id') and len(arguments.country_id)>#arguments.country_id#<cfelseif isdefined("get_country") and len(get_country.country_id)>#get_country.country_id#<cfelse>NULL</cfif>,
                    <cfif isdefined('arguments.sales_zone_id') and len(arguments.sales_zone_id)>#arguments.sales_zone_id#<cfelseif isdefined("get_country") and len(get_country.sales_id)>#get_country.sales_id#<cfelse>NULL</cfif>,
                    <cfif isdefined('arguments.event_plan_row_id') and len(arguments.event_plan_row_id)>#event_plan_row_id#<cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.process_cat") and len(arguments.process_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_cat#"><cfelse>NULL</cfif>
                    )
            </cfquery>          
            <cfquery name="UPD_GEN_PAP" datasource="#DSN3#">
                UPDATE
                    GENERAL_PAPERS
                SET
                    OPPORTUNITY_NUMBER = #system_paper_no_add#
                WHERE
                    OPPORTUNITY_NUMBER IS NOT NULL
            </cfquery>		
            <cfset result.status = true>
            <cfset result.success_message = "Kaydı Yapıldı, Yönlendiriliyor">           
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
                <cfset result.error = cfcatch >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <!---! upd opportunities  --->

    <cffunction name="UPD_OPPORTUNITY" access="remote" returntype="string" returnformat="json">
        <cfargument name="opportunity_type_id" default="">
        <cfargument name="member_type"  default="">
        <cfargument name="member_id"  default="">
        <cfargument name="company_id"  default="">
        <cfargument name="ref_member_type"  default="">
        <cfargument name="ref_partner_id"  default="">
        <cfargument name="ref_company_id"  default="">
        <cfargument name="ref_consumer_id"  default="">
        <cfargument name="ref_employee_id"  default="">
        <cfargument name="process_stage"  default="">
        <cfargument name="commethod_id"  default="">
        <cfargument name="opp_detail"  default="">
        <cfargument name="income"  default="">
        <cfargument name="money"  default="">
        <cfargument name="cost"  default="">
        <cfargument name="money2"  default="">
        <cfargument name="stock_id"  default="">
        <cfargument name="sales_team_id"  default="">
        <cfargument name="sales_emp_id"  default="">
        <cfargument name="sales_member_id"  default="">
        <cfargument name="sales_consumer_id"  default="">
        <cfargument name="opp_date"  default="">
        <cfargument name="opp_invoice_date"  default="">
        <cfargument name="action_date"  default="">
        <cfargument name="opp_currency_id"  default="">
        <cfargument name="activity_time"  default="">
        <cfargument name="probability"  default="">
        <cfargument name="opp_head"  default="">
        <cfargument name="project_id"  default="">
        <cfargument name="sales_add_option"  default="">
        <cfargument name="service_id"  default="">
        <cfargument name="cus_help_id"  default="">
        <cfargument name="camp_name"  default="">
        <cfargument name="camp_id"  default="">
        <cfargument name="country_id"  default="">
        <cfargument name="sales_zone_id"  default="">
        <cfargument name="event_plan_row_id"  default="">
        <cfargument name="process_cat"  default="">
        <cfargument name="OPPORTUNITY_NO"  default="">
        <cfargument name="RIVAL_PARTNER_ID"  default="">
        <cfargument name="RIVAL_COMPANY_ID"  default="">
        <cfargument name="OPP_ID"  default="">
        
        
        <cftry>   
            <cfscript>
                if(isdefined("to_par_ids")) CC_PARS = ListSort(to_par_ids,"Numeric", "Desc"); else CC_PARS = "";
                if(isdefined("to_pos_ids")) CC_POS = ListSort(to_pos_ids,"Numeric", "Desc"); else CC_POS = "";
                if(isdefined("to_cons_ids")) CC_CONS = ListSort(to_cons_ids,"Numeric", "Desc"); else CC_CONS ='';
                if(isdefined("to_grp_ids")) CC_GRPS = ListSort(to_grp_ids,"Numeric", "Desc") ; else CC_GRPS ='';
            </cfscript>
            
                <cfquery name="UPD_OPPORTUNITY" datasource="#DSN3#">
                    UPDATE
                        OPPORTUNITIES
                    SET
                        OPPORTUNITY_TYPE_ID = <cfif len(arguments.opportunity_type_id)>#arguments.opportunity_type_id#<cfelse>NULL</cfif>,
                    <cfif arguments.member_type is 'partner'>
                        PARTNER_ID = #arguments.member_id#,
                        COMPANY_ID = #arguments.company_id#,
                        CONSUMER_ID = NULL,
                    <cfelseif  arguments.member_type is 'consumer'>
                        PARTNER_ID = NULL,
                        COMPANY_ID = NULL,
                        CONSUMER_ID = #arguments.member_id#,
                    </cfif>
                    <cfif isdefined("arguments.ref_member_type") and arguments.ref_member_type is 'partner' and len(arguments.ref_member)>
                        REF_PARTNER_ID = #arguments.ref_partner_id#,
                        REF_COMPANY_ID = #arguments.ref_company_id#,
                        REF_CONSUMER_ID = NULL,
                        REF_EMPLOYEE_ID = NULL,
                    <cfelseif isdefined("arguments.ref_member_type") and arguments.ref_member_type is 'consumer' and len(arguments.ref_member)>
                        REF_PARTNER_ID = NULL,
                        REF_COMPANY_ID = NULL,
                        REF_CONSUMER_ID = #arguments.ref_consumer_id#,
                        REF_EMPLOYEE_ID = NULL,
                    <cfelseif isdefined("arguments.ref_member_type") and arguments.ref_member_type is 'employee' and len(arguments.ref_member)>
                        REF_PARTNER_ID = NULL,
                        REF_COMPANY_ID = NULL,
                        REF_CONSUMER_ID = NULL,
                        REF_EMPLOYEE_ID = #arguments.ref_employee_id#,
                    <cfelse>
                        REF_PARTNER_ID = NULL,
                        REF_COMPANY_ID = NULL,
                        REF_CONSUMER_ID = NULL,
                        REF_EMPLOYEE_ID = NULL,
                    </cfif>
                        OPP_STAGE = <cfif isdefined("arguments.process_stage")>#arguments.process_stage#,<cfelse>NULL,</cfif>
                        COMMETHOD_ID = <cfif len(arguments.commethod_id)>#arguments.commethod_id#<cfelse>NULL</cfif>,
                        PRODUCT_CAT_ID = <cfif isdefined("arguments.product_cat_id") and  len(arguments.product_cat_id)>#arguments.product_cat_id#<cfelse>NULL</cfif>,
                        OPP_DETAIL = <cfif len(arguments.opp_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.opp_detail#"><cfelse>NULL</cfif>,
                        INCOME = <cfif len(arguments.income)>#Replace(arguments.income,',','.','all')#<cfelse>NULL</cfif>,
                        MONEY = <cfif len(arguments.money) and len(arguments.income)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.money#"><cfelse>NULL</cfif>,
                        COST = <cfif len(arguments.cost)>#arguments.cost#<cfelse>NULL</cfif>,
                        MONEY2 = <cfif len(arguments.money2) and len(arguments.cost)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.money2#"><cfelse>NULL</cfif>,
                        STOCK_ID = <cfif isdefined("arguments.stock_id") and len(arguments.stock_id) and len(arguments.stock_name)>#arguments.stock_id#<cfelse>NULL</cfif>,
                        SALES_TEAM_ID = <cfif len(arguments.sales_team_id)>#arguments.sales_team_id#<cfelse>NULL</cfif>,
                        SALES_EMP_ID = <cfif len(arguments.sales_emp_id) and len(arguments.sales_emp)>#arguments.sales_emp_id#<cfelse>NULL</cfif>,
                        SALES_PARTNER_ID = <cfif isdefined("arguments.sales_member") and len(arguments.sales_member) and len(arguments.sales_member_id) and len(arguments.sales_member_type) and arguments.sales_member_type eq 'partner'>#arguments.sales_member_id#<cfelse>NULL</cfif>,
                        SALES_CONSUMER_ID = <cfif isdefined("arguments.sales_member") and len(arguments.sales_member) and len(arguments.sales_member_id) and len(arguments.sales_member_type) and arguments.sales_member_type eq 'consumer'>#arguments.sales_member_id#<cfelse>NULL</cfif>,
                        OPP_DATE = <cfif len(arguments.opp_date)>#arguments.opp_date#<cfelse>NULL</cfif>,
                        INVOICE_DATE = <cfif isdefined("arguments.opp_invoice_date") and  len(arguments.opp_invoice_date)>#arguments.opp_invoice_date#<cfelse>NULL</cfif>,
                        ACTION_DATE = <cfif isdefined("arguments.action_date") and len(arguments.action_date)>#arguments.action_date#<cfelse>NULL</cfif>,
                        OPP_CURRENCY_ID = <cfif len(arguments.opp_currency_id)>#arguments.opp_currency_id#<cfelse>NULL</cfif>,
                        OPP_STATUS = <cfif isDefined("arguments.opp_status")>1<cfelse>0</cfif>,
                        ACTIVITY_TIME = <cfif isdefined("arguments.activity_time") and len(arguments.activity_time)>#arguments.activity_time#<cfelse>NULL</cfif>,
                        PROBABILITY = <cfif len(arguments.probability)>#arguments.probability#<cfelse>NULL</cfif>,
                        OPP_HEAD = <cfif len(arguments.opp_head)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.opp_head#"><cfelse>NULL</cfif>,
                        OPP_ZONE = 0,
                        PROJECT_ID = <cfif len(arguments.project_id) and len(arguments.project_head)>#arguments.project_id#<cfelse>NULL</cfif>,
                        OPP_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.opportunity_no#">,
                        CC_GRP_IDS = <cfif len(CC_GRPS)><cfqueryparam cfsqltype="cf_sql_varchar" value="#CC_GRPS#"><cfelse>NULL</cfif>,
                        CC_CON_IDS = <cfif len(CC_CONS)><cfqueryparam cfsqltype="cf_sql_varchar" value="#CC_CONS#"><cfelse>NULL</cfif>,
                        CC_PAR_IDS = <cfif len(CC_PARS)><cfqueryparam cfsqltype="cf_sql_varchar" value="#CC_PARS#"><cfelse>NULL</cfif>,
                        CC_POSITIONS = <cfif len(CC_POS)><cfqueryparam cfsqltype="cf_sql_varchar" value="#CC_POS#"><cfelse>NULL</cfif>,
                        SALE_ADD_OPTION_ID = <cfif len(arguments.sales_add_option)>#arguments.sales_add_option#<cfelse>NULL</cfif>,
                        PREFERENCE_REASON_ID = <cfif isdefined("arguments.rival_preference_reason") and len(arguments.rival_preference_reason)><cfqueryparam cfsqltype="cf_sql_varchar" value=",#arguments.rival_preference_reason#,"><cfelse>NULL</cfif>,
                        RIVAL_PARTNER_ID = <cfif len(arguments.rival_partner_id) and len(arguments.rival_company)>#arguments.rival_partner_id#<cfelse>NULL</cfif>,
                        RIVAL_COMPANY_ID = <cfif len(arguments.rival_company_id) and len(arguments.rival_company)>#arguments.rival_company_id#<cfelse>NULL</cfif>,
                        CAMPAIGN_ID = <cfif isdefined('arguments.camp_name') and len(arguments.camp_name) and isdefined('arguments.camp_id') and Len(arguments.camp_id)>#arguments.camp_id#<cfelse>NULL</cfif>,
                        COUNTRY_ID=<cfif isdefined("arguments.country_id1") and len(arguments.country_id1)>#arguments.country_id1#<cfelseif isdefined("get_country") and len(get_country.country_id)>#get_country.country_id#<cfelse>NULL</cfif>,
                        SZ_ID=<cfif isdefined("arguments.sales_zone_id") and len(arguments.sales_zone_id)>#arguments.sales_zone_id#<cfelseif isdefined("get_country") and len(get_country.sales_id)>#get_country.sales_id#<cfelse>NULL</cfif>,
                        UPDATE_EMP = #session_base.userid#,
                        UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                        UPDATE_DATE = #now()#,
                        ADD_RSS = <cfif isdefined('form.add_rss') and len(form.add_rss)>1<cfelse>0</cfif>,
                        PROCESS_CAT = <cfif isdefined("arguments.process_cat") and len(arguments.process_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_cat#"><cfelse>NULL</cfif>
                    WHERE
                        OPP_ID = #arguments.opp_id#
                </cfquery>          
            <cfset result.status = true>
            <cfset result.success_message = "Kaydı Yapıldı, Yönlendiriliyor">
            <cfset result.identity = CreateObject("component", "WMO.functions").contentEncryptingandDecodingAES(isEncode:1,content:arguments.opp_id,accountKey:"wrk")>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
                <cfset result.error = cfcatch >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

<!---! del opportunities  --->
    <cffunction name="DEL_OPPORTUNITY" access="remote" returntype="string" returnformat="json">      
        <cfargument name="OPP_ID"  default="">       
        <cfargument name="action_id"  default="">     
        <cftry>   
            <cftransaction>
                <cfquery name="getOpp" datasource="#dsn3#">
                    SELECT OPP_NO,OPP_HEAD,OPPORTUNITY_TYPE_ID FROM OPPORTUNITIES WHERE OPP_ID = #arguments.action_id#
                </cfquery>
            
            
                <cfquery name="DEL_ANALYSIS_RESULTS_DETAILS" datasource="#DSN3#">
                    DELETE FROM #dsn_alias#.MEMBER_ANALYSIS_RESULTS_DETAILS WHERE RESULT_ID IN (SELECT RESULT_ID FROM #dsn_alias#.MEMBER_ANALYSIS_RESULTS WHERE OPPORTUNITY_ID = #arguments.action_id# AND OUR_COMPANY_ID = #session_base.company_id#)
                </cfquery>
                <cfquery name="DEL_ANALYSIS_RESULTS_DETAILS" datasource="#DSN3#">
                    DELETE FROM #dsn_alias#.MEMBER_ANALYSIS_RESULTS WHERE OPPORTUNITY_ID = #arguments.action_id# AND OUR_COMPANY_ID = #session_base.company_id#
                </cfquery>
                
                <cfquery name="DEL_WORKGROUP_EMP_PAR" datasource="#DSN3#">
                    DELETE FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE OPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
                </cfquery>
                <cfquery name="DEL_WORK_GROUP" datasource="#DSN3#">
                    DELETE FROM #dsn_alias#.WORK_GROUP WHERE OPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
                </cfquery>
                <!--- Takipler silinir --->
                <cfquery name="DEL_OPPORTUNITIES_PLUS" datasource="#DSN3#">
                    DELETE FROM OPPORTUNITIES_PLUS WHERE OPP_ID = #arguments.action_id#
                </cfquery>
                <!--- İlişkili teklif ile fırsat arasındaki ilişkiyi siliyor --->
                <cfquery name="UPD_OFFER" datasource="#DSN3#">
                    UPDATE OFFER SET OPP_ID = NULL WHERE OPP_ID = #arguments.action_id#
                </cfquery>
                
                 <cfquery name="UPD_EVENTS_RELATED" datasource="#DSN3#">
                    UPDATE
                        #dsn_alias#.EVENTS_RELATED
                    SET
                        ACTION_ID = NULL
                    WHERE
                       ACTION_ID = #arguments.action_id# AND
                       COMPANY_ID =#session_base.company_id#   
                </cfquery>
                <cfquery name="DEL_OPPORTUNITIES" datasource="#DSN3#">
                    DELETE FROM OPPORTUNITIES WHERE OPP_ID = #arguments.action_id#
                </cfquery>                
            </cftransaction>
   
            <cfset result.status = true>
            <cfset result.success_message = "Silme islemi basarili">
            <cfset result.identity = arguments.opp_id>
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
                <cfset result.error = cfcatch >
            </cfcatch>  
        </cftry>
        <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>

    <!--- ! list offers --->
    <cffunction name="GET_OPPORTUNITY_PLUSES" access="remote">
        
        <cfquery name="GET_OPPORTUNITY_PLUSES" datasource="#DSN3#">
            SELECT 
                COMMETHOD_ID,
                EMPLOYEE_ID, 
                MAIL_CC, 
                MAIL_SENDER,OPP_ID, 
                OPP_PLUS_ID, 
                OPP_ZONE,
                PARTNER_ID, 
                PLUS_CONTENT, 
                PLUS_DATE, 
                PLUS_SUBJECT, 
                RECORD_DATE, 
                RECORD_EMP, 
                RECORD_IP, 
                RECORD_PAR, 
                UPDATE_DATE, 
                UPDATE_IP, 
                UPDATE_EMP,
                UPDATE_PAR
            FROM 
                OPPORTUNITIES_PLUS 
            WHERE 
                OPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(arguments.opp_id,1,',')#"> ORDER BY RECORD_DATE DESC
        </cfquery>
        <cfreturn GET_OPPORTUNITY_PLUSES>
    </cffunction>

    <cffunction name="GET_MAILFROM" access="remote">        
        <cfquery name="GET_MAILFROM" datasource="#DSN#">         
            SELECT COMPANY_PARTNER_EMAIL,COMPANY_PARTNER_NAME,COMPANY_PARTNER_SURNAME,PARTNER_ID FROM COMPANY_PARTNER WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.userid#">            
        </cfquery>
        <cfreturn GET_MAILFROM>
    </cffunction>

    <!---! add offer  --->
    <cffunction name="ADD_OFFER_PLUS" access="remote" returntype="string" returnformat="json"> 
        
        <cftry>    
            <cfquery name="ADD_OFFER_PLUS" datasource="#DSN3#">
            INSERT INTO
                OPPORTUNITIES_PLUS
                (
                    OPP_ID,
                    <!---COMMETHOD_ID,--->
                    PLUS_CONTENT,
                    PLUS_DATE,
                    EMPLOYEE_ID,
                    RECORD_DATE,
                    RECORD_PAR,
                    OPP_ZONE,
                    RECORD_IP,
                    MAIL_SENDER,
                    PLUS_SUBJECT,
                    IS_EMAIL,
                    MAIL_CC
               
                )
            VALUES
                (
                    #opp_id#,
                    <!---<cfif Len(commethod_id)>#commethod_id#<cfelse>NULL</cfif>,--->
                    '#arguments.plus_content#',
                    #now()#,
                    <cfif len(employee_id)>#employee_id#<cfelse>NULL</cfif>,
                    #now()#,
                    #session_BASE.userid#,
                    0,
                    '#cgi.remote_addr#',
                    <cfif Len(arguments.employee_emails)>'#arguments.employee_emails#'<cfelse>NULL</cfif>,			
                    '#arguments.opp_head#',
                    <cfif isDefined("email") and (email eq "true") and Len(arguments.employee_emails)>1<cfelse>0</cfif>,
                    <cfif Len(arguments.employee_emails1)>'#arguments.employee_emails1#'<cfelse>NULL</cfif>
                )
            </cfquery>
        <cfset result.status = true>
        <cfset result.success_message = "Kaydı Yapıldı, Yönlendiriliyor">
        <cfset result.identity = CreateObject("component", "WMO.functions").contentEncryptingandDecodingAES(isEncode:1,content:arguments.opp_id,accountKey:"wrk")>
        <cfcatch type="any">
            <cfset result.status = false>
            <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
            <cfset result.error = cfcatch >
        </cfcatch>  
    </cftry>
    <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>
    <!--- ! update offer --->
    <!---<cffunction name="UPD_OFFER_PLUS" access="remote" returntype="string" returnformat="json"> 
        
        <cftry>    
            <cfquery name="UPD_OFFER_PLUS" datasource="#DSN3#">
                UPDATE
                    OPPORTUNITIES_PLUS
                SET
                    <!---COMMETHOD_ID = <cfif Len(commethod_id)>#commethod_id#<cfelse>NULL</cfif>,--->
                    MAIL_SENDER = <cfif Len(arguments.employee_emails)>'#arguments.employee_emails#'<cfelse>NULL</cfif>,
                    MAIL_CC = <cfif Len(arguments.employee_emails1)>'#arguments.employee_emails1#'<cfelse>NULL</cfif>,
                    PLUS_DATE = <cfif len(plus_date)>#plus_date#<cfelse>NULL</cfif>,
                    PLUS_CONTENT = '#PLUS_CONTENT#',
                    EMPLOYEE_ID  = <cfif len(employee_id)>#employee_id#<cfelse>NULL</cfif>,
                    UPDATE_DATE  = #now()#,
                    UPDATE_PAR   = #session_base.userid#,
                    UPDATE_IP    = '#cgi.remote_addr#',
                    IS_EMAIL 	 = <cfif isDefined("email") and (email eq "true") and Len(arguments.employee_emails)>1,<cfelse>0,</cfif>
                    PLUS_SUBJECT = '#arguments.opp_head#'
                WHERE
                    OPP_PLUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#opp_plus_id#">
            </cfquery>
        <cfset result.status = true>
        <cfset result.success_message = "Kaydı Yapıldı, Yönlendiriliyor">
        <cfset result.identity = arguments.opp_id>
        <cfcatch type="any">
            <cfset result.status = false>
            <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
            <cfset result.error = cfcatch >
        </cfcatch>  
    </cftry>
    <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>--->

    <cffunction name="SEND_MAIL" access="remote" returntype="string" returnformat="json">
        <cftry> 
        <cfif isdefined('arguments.email') and arguments.email eq 1>
            <cfmail to="#arguments.emails#" from="#get_sender_mail.company_partner_email#" subject="#arguments.opp_header#" type="html">
            #arguments.plus_content#
            </cfmail>
        </cfif> 
        <cfset result.status = true>
        <cfset result.success_message = "Kaydı Yapıldı, Yönlendiriliyor">
        <cfset result.identity = arguments.opp_id>
        <cfcatch type="any">
            <cfset result.status = false>
            <cfset result.danger_message = "Şuanda işlem yapılamıyor...">
            <cfset result.error = cfcatch >
        </cfcatch>  
    </cftry>
    <cfreturn Replace(SerializeJSON(result),'//','')>
    </cffunction>


    <!---! emp info  --->
    <cffunction name = "GET_EMP_LIST" access="remote" returnType = "any">
        <cfargument name="int_emp_list" default="#int_emp_list#">
        <cfquery name="GET_EMP_LIST" datasource="#DSN#">
            SELECT
                EMPLOYEES.EMPLOYEE_NAME NAME,
                EMPLOYEES.EMPLOYEE_SURNAME SURNAME,
                EMPLOYEE_POSITIONS.POSITION_NAME TITLE,
                EMPLOYEES.PHOTO
            FROM                
                EMPLOYEES LEFT JOIN
                EMPLOYEE_POSITIONS 
                ON EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID
                AND EMPLOYEE_POSITIONS.IS_MASTER = 1
            WHERE
                EMPLOYEES.EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#int_emp_list#" list="yes">)
        </cfquery> 
        <cfreturn GET_EMP_LIST>
    </cffunction>
    <cffunction name = "GET_PURSUIT_TEMPLATES" access="remote" returnType = "any">
        <cfargument name="pursuit_template_id" default="">
        <cfquery name="get_pursuit_templates" datasource="#dsn#">
            SELECT 
                 * 
            FROM 
                TEMPLATE_FORMS
            WHERE
                IS_PURSUIT_TEMPLATE = 1	
            <cfif isDefined("arguments.pursuit_template_id") and len(arguments.pursuit_template_id)>		
                AND TEMPLATE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pursuit_template_id#">
            </cfif>			
            ORDER BY 
                TEMPLATE_HEAD	
        </cfquery>
        <cfreturn get_pursuit_templates>
    </cffunction>
    <cffunction name="GET_PARTNER" returntype="query">
        <cfquery name="GET_PARTNER" datasource="#DSN#">
            SELECT
                COMPANY_PARTNER.COMPANY_PARTNER_NAME NAME,
                COMPANY_PARTNER.PARTNER_ID,
                COMPANY_PARTNER.COMPANY_PARTNER_SURNAME SURNAME,
                COMPANY.NICKNAME,
                COMPANY.COMPANY_ID,
                COMPANY_PARTNER.SEX,
                COMPANY_PARTNER.PHOTO
            FROM
                COMPANY_PARTNER,
                COMPANY
            WHERE
                COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
                COMPANY_PARTNER.PARTNER_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userid#">
            ORDER BY
                COMPANY_PARTNER.PARTNER_ID
        </cfquery>
        <cfreturn GET_PARTNER>
    </cffunction>
    <cffunction name="get_related_events" returntype="query">
        <cfquery name="GET_RELATED_EVENTS" datasource="#DSN#">
            SELECT
                ER.EVENT_ID,
                ER.RELATED_ID,
                E.EVENT_HEAD,
                E.STARTDATE,
                ISNULL(ER.EVENT_TYPE,1) TYPE,
                '' EVENT_ROW_ID,
                EC.EVENTCAT
            FROM
                EVENTS_RELATED ER,
                EVENT E,
                EVENT_CAT EC
            WHERE
                E.EVENT_ID = ER.EVENT_ID AND	
                E.EVENTCAT_ID = EC.EVENTCAT_ID AND		
                ER.ACTION_SECTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_section#"> AND
                ER.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> AND
                ISNULL(ER.EVENT_TYPE,1) = 1
            <cfif isdefined("arguments.company_id") and len(arguments.company_id)>
                AND ER.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
            </cfif>
            UNION ALL	
            SELECT
                ER.EVENT_ID,
                ER.RELATED_ID,
                E.EVENT_PLAN_HEAD EVENT_HEAD,
                EVENT_PLAN_ROW.START_DATE STARTDATE,
                ISNULL(ER.EVENT_TYPE,1) TYPE,
                ER.EVENT_ROW_ID,
                '' EVENTCAT
            FROM
                EVENTS_RELATED ER,
                EVENT_PLAN E,
                EVENT_PLAN_ROW
            WHERE
                E.EVENT_PLAN_ID = EVENT_PLAN_ROW.EVENT_PLAN_ID AND
                E.EVENT_PLAN_ID = ER.EVENT_ID AND	
                ER.ACTION_SECTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_section#"> AND
                ER.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#"> AND
                ISNULL(ER.EVENT_TYPE,1) = 2
            <cfif isdefined("arguments.company_id") and len(arguments.company_id)>
                AND ER.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
            </cfif>	
            ORDER BY 
                E.STARTDATE DESC
        </cfquery>
        <cfreturn get_related_events>
    </cffunction>
</cfcomponent>







