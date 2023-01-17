<cfcomponent>
    <cfset dsn = application.SystemParam.SystemParam().dsn>
    <cfset dsn3 = "#dsn#_product">

    <!--- Start List Functions --->
    <cffunction name="GET_EMP_TRAN1" returntype="any">
        <cfargument name="emp_id" type="numeric">
        <cfquery name="GET_EMP_TRAN" datasource="#DSN#">
            SELECT CLASS_ID FROM TRAINING_CLASS_ATTENDER WHERE EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.emp_id#">
        </cfquery>
        <cfreturn GET_EMP_TRAN>
    </cffunction>
    <cffunction name="GET_EMP_TRAN2" returntype="any">
        <cfargument name="cons_id" type="numeric">
        <cfquery name="GET_EMP_TRAN" datasource="#DSN#">
            SELECT CLASS_ID FROM TRAINING_CLASS_ATTENDER WHERE CON_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cons_id#">
        </cfquery>
        <cfreturn GET_EMP_TRAN>
    </cffunction>
    <cffunction name="GET_EMP_TRAN3" returntype="any">
        <cfargument name="par_id" type="numeric">
        <cfquery name="GET_EMP_TRAN" datasource="#DSN#">
            SELECT CLASS_ID FROM TRAINING_CLASS_ATTENDER WHERE PAR_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.par_id#">
        </cfquery>
        <cfreturn GET_EMP_TRAN>
    </cffunction>
    <cffunction name="GET_BRANCHS_F" returntype="any">
        <cfquery name="GET_BRANCHS" datasource="#DSN#">
            SELECT 
                BRANCH_ID,
                BRANCH_NAME 
            FROM 
                BRANCH
            WHERE
                BRANCH_ID IN (
                                SELECT
                                    BRANCH_ID
                                FROM
                                    EMPLOYEE_POSITION_BRANCHES
                                WHERE
                                    POSITION_CODE =<cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.POSITION_CODE#"> 	
                            )
            ORDER BY 
                BRANCH_ID
        </cfquery>
        <cfreturn GET_BRANCHS>
    </cffunction>
    <cffunction name="GET_CLASS_EX_CLASS_F" returntype="any">
        <cfargument name="branch_id_list">
        <cfargument name="online">
        <cfargument name="keyword">
        <cfargument name="date1">
        <cfargument name="DUN">
        <cfargument name="training_cat_id">
        <cfargument name="training_sec_id">
        <cfargument name="emp_class_id">
        <cfargument name="ic_dis">
        <cfargument name="project">
        <cfargument name="project_id">
        <cfargument name="train_head">
        <cfargument name="train_id">
        <cfquery name="GET_CLASS_EX_CLASS" datasource="#DSN#">
            SELECT DISTINCT
                TC.START_DATE, 
                TC.FINISH_DATE, 
                TC.ONLINE, 
                TC.CLASS_ID, 
                TC.CLASS_NAME, 
                TC.CLASS_PLACE, 
                TC.MONTH_ID, 
                <!--- TC.TRAINER_EMP,
                TC.TRAINER_PAR,
                TC.TRAINER_CONS, --->
                TC.INT_OR_EXT AS TYPE,
                TRAINING_LINK
            FROM
                TRAINING_CLASS TC
                LEFT JOIN TRAINING TRN ON TC.TRAINING_ID = TRN.TRAIN_ID
            WHERE
                TC.CLASS_ID IS NOT NULL AND
                (
                    TC.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_ATTENDER WHERE EMP_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE DEPARTMENT_ID IN(SELECT DEPARTMENT_ID FROM DEPARTMENT WHERE BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#arguments.branch_id_list#">)))) OR
                    <!---CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS WHERE TRAINER_EMP =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">) OR--->
                    TC.CLASS_ID NOT IN (SELECT CLASS_ID FROM TRAINING_CLASS_ATTENDER WHERE EMP_ID IS NOT NULL) OR
                    TC.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_INFORM WHERE EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">) OR
                    TC.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_ATTENDER WHERE EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">)
                )
                <cfif isDefined("arguments.online") and len(arguments.online)>AND ONLINE = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.online#"></cfif>
                <cfif isDefined("arguments.keyword") and len(arguments.keyword)>
                    AND TC.CLASS_NAME LIKE '%' + <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#" maxlength="100" /> + '%'
                </cfif>
                <cfif isDefined("arguments.date1") and len(arguments.date1)>
                    AND
                    (
                        TC.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.date1#"> OR
                        TC.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.date1#">
                    )
                </cfif>
                <cfif isDefined("arguments.dun") and len(arguments.dun)>AND TC.START_DATE ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.DUN#"></cfif>
                <cfif isdefined("arguments.training_cat_id") AND len(arguments.training_cat_id)>AND TC.TRAINING_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.training_cat_id#"></cfif>
                <cfif isdefined("arguments.training_sec_id") AND len(arguments.training_sec_id)>AND TC.TRAINING_SEC_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.training_sec_id#"></cfif>
                <cfif isdefined("arguments.emp_class_id") and listlen(arguments.emp_class_id)>AND TC.CLASS_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes"  value="#arguments.emp_class_id#">) <cfelseif isdefined("arguments.emp_class_id") and not listlen(arguments.emp_class_id)> AND TC.CLASS_ID=0</cfif>
                <cfif isdefined("arguments.ic_dis") and len(arguments.ic_dis)>AND TC.INT_OR_EXT = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.ic_dis#"></cfif>
                <cfif isdefined("arguments.project") and len(arguments.project) and len(arguments.project_id)>AND TC.PROJECT_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#"></cfif>
                <cfif isdefined("arguments.train_id") and len(arguments.train_id) and isdefined("arguments.train_head") and len(arguments.train_head)>
                    AND TRN.TRAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.train_id#">
                </cfif>
            ORDER BY 
                START_DATE DESC		
        </cfquery>
        <cfreturn GET_CLASS_EX_CLASS>
    </cffunction>
    <!--- End of List Functions --->

    <!--- Start İnsert Functions --->
    <cffunction name="GET_TRAINING_EVAL_QUIZS_F" returntype="any">
        <cfquery name="GET_TRAINING_EVAL_QUIZS" datasource="#DSN#">
            SELECT
                QUIZ_ID,
                QUIZ_HEAD
            FROM
                EMPLOYEE_QUIZ
            WHERE
                STAGE_ID = -2 AND
                IS_ACTIVE = 1 AND
                IS_EDUCATION = 1
            ORDER BY 
                QUIZ_HEAD
        </cfquery>
        <cfreturn GET_TRAINING_EVAL_QUIZS>
    </cffunction>
    <cffunction name="GET_SITE_MENU_F" returntype="any">
        <cfquery name="GET_SITE_MENU" datasource="#DSN#">
            SELECT 
                MENU_ID,
                SITE_DOMAIN,
                OUR_COMPANY_ID 
            FROM 
                MAIN_MENU_SETTINGS 
            WHERE 
                IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_bit" value="1"> AND 
                SITE_DOMAIN IS NOT NULL
        </cfquery>
        <cfreturn GET_SITE_MENU>
    </cffunction>
    <cffunction name="GET_COMPANIES_F" returntype="any">
        <cfquery name="GET_COMPANIES" datasource="#DSN#">
            SELECT COMP_ID,NICK_NAME FROM OUR_COMPANY WHERE COMP_STATUS = 1  ORDER BY COMPANY_NAME
        </cfquery>
        <cfreturn GET_COMPANIES>
    </cffunction>
    <cffunction name="FIND_DEPARTMENT_BRANCH_F" returntype="any">
        <cfargument name="p_code" default="0">
        <cfquery name="FIND_DEPARTMENT_BRANCH" datasource="#DSN#">
            SELECT
                EMPLOYEE_POSITIONS.EMPLOYEE_ID,
                EMPLOYEE_POSITIONS.POSITION_ID,
                EMPLOYEE_POSITIONS.POSITION_CODE,
                BRANCH.BRANCH_ID,
                BRANCH.BRANCH_NAME,
                DEPARTMENT.DEPARTMENT_ID,
                DEPARTMENT.DEPARTMENT_HEAD
            FROM
                EMPLOYEE_POSITIONS,
                DEPARTMENT,
                BRANCH
            WHERE
                EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
                DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
                <cfif arguments.p_code eq 0>
                AND EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
                <cfelseif len(arguments.p_code) and arguments.p_code neq 0>
                AND EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.p_code#">
                </cfif>
        </cfquery>
        <cfreturn FIND_DEPARTMENT_BRANCH>
    </cffunction>
    <cffunction name="GET_LANGUAGE_F" returntype="any">
        <cfquery name="GET_LANGUAGE" datasource="#DSN#">
            SELECT LANGUAGE_SHORT,LANGUAGE_SET FROM SETUP_LANGUAGE
        </cfquery>
        <cfreturn GET_LANGUAGE>
    </cffunction>
    <cffunction name="ADD_CLASS_F" returntype="any">
        <cfargument name="class_tools" type="string">
        <cfargument name="max_participation">
        <cfargument name="max_self_service">
        <cfargument name="training_sec_id">
        <cfargument name="training_cat_id">
        <cfargument name="CLASS_NAME" type="string">
        <cfargument name="CLASS_OBJECTIVE" type="string">
        <cfargument name="CLASS_TARGET" type="string">
        <cfargument name="class_announcement" type="string">
        <cfargument name="CLASS_PLACE" type="string">
        <cfargument name="CLASS_PLACE_ADDRESS" type="string">
        <cfargument name="CLASS_PLACE_TEL" type="string">
        <cfargument name="CLASS_PLACE_MANAGER" type="string">
        <cfargument name="START_DATE" type="date">
        <cfargument name="FINISH_DATE" type="date">
        <cfargument name="DATE_NO">
        <cfargument name="HOUR_NO">
        <cfargument name="online">
        <cfargument name="int_or_ext">
        <cfargument name="MONTH_ID">
        <cfargument name="training_style">
        <cfargument name="VIEW_TO_ALL">
        <cfargument name="is_wiew_branch">
        <cfargument name="is_wiew_branch_">
        <cfargument name="is_wiew_department">
        <cfargument name="is_view_comp">
        <cfargument name="project_id">
        <cfargument name="project_head" type="string">
        <cfargument name="is_net_display" type="numeric">
        <cfargument name="process_stage" type="numeric">
        <cfargument name="is_active" type="numeric">
        <cfargument name="language_id">
        <cfargument name="stock_id">
        <cfargument name="product_name" type="string">
        <cfargument name="train_id">
        <cfargument name="train_head" type="string">
        <cfargument name="url_training" type="string">
        <cfset response = structNew()>
        <cfset response.status = true>
        <cftry>
            <cfquery name="ADD_CLASS" datasource="#DSN#" result="MAX_ID">
                INSERT INTO
                    TRAINING_CLASS
                    (
                        MAX_PARTICIPATION,
                        MAX_SELF_SERVICE,
                        TRAINING_SEC_ID,
                        TRAINING_CAT_ID,
                        CLASS_NAME,
                        CLASS_OBJECTIVE,
                        CLASS_TARGET,
                        CLASS_ANNOUNCEMENT_DETAIL,
                        CLASS_PLACE,
                        CLASS_PLACE_ADDRESS,
                        CLASS_PLACE_TEL,
                        CLASS_PLACE_MANAGER,
                        START_DATE,
                        FINISH_DATE,
                        DATE_NO,
                        HOUR_NO,
                        ONLINE,
                        INT_OR_EXT,
                        MONTH_ID,
                        TRAINING_STYLE,
                        <cfif len(arguments.class_tools)>CLASS_TOOLS,</cfif>
                        VIEW_TO_ALL,
                        IS_WIEW_BRANCH,
                        IS_WIEW_DEPARTMENT,
                        IS_VIEW_COMPANY,
                        PROJECT_ID,
                        RECORD_DATE,
                        RECORD_IP,
                        RECORD_EMP,
                        IS_INTERNET,
                        PROCESS_STAGE,
                        IS_ACTIVE,
                        LANGUAGE,
                        <!---RELATED_CLASS_ID, --->
                        STOCK_ID,
                        TRAINING_ID,
                        TRAINING_LINK
                    )
                VALUES
                    (
                        <cfif len(arguments.max_participation)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.max_participation#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" null="yes" value=""></cfif>,
                        <cfif len(arguments.max_self_service)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.max_self_service#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" null="yes" value=""></cfif>,
                        <cfif isdefined("arguments.training_sec_id") and len(arguments.training_sec_id) and arguments.training_sec_id NEQ 0>
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.training_sec_id#">
                        <cfelse>
                            <cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">
                        </cfif>,
                        <cfif isdefined("arguments.training_cat_id") and len(arguments.training_cat_id) and arguments.training_cat_id NEQ 0>
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.training_cat_id#">,
                        <cfelse>
                            <cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">,
                        </cfif>
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CLASS_NAME#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CLASS_OBJECTIVE#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CLASS_TARGET#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.class_announcement#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CLASS_PLACE#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CLASS_PLACE_ADDRESS#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CLASS_PLACE_TEL#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CLASS_PLACE_MANAGER#">,
                        <cfif len(arguments.START_DATE)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.START_DATE#">,<cfelse><cfqueryparam cfsqltype="cf_sql_timestamp" null="yes" value="">,</cfif>
                        <cfif len(arguments.FINISH_DATE)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.FINISH_DATE#">,<cfelse><cfqueryparam cfsqltype="cf_sql_timestamp" null="yes" value="">,</cfif>
                        <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.DATE_NO#">,
                        <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.HOUR_NO#">,
                        <cfif isdefined("arguments.online") and len(arguments.online)>1<cfelse>0</cfif>,
                        <cfif isdefined("arguments.int_or_ext") and len(arguments.int_or_ext)>1<cfelse>0</cfif>,
                        <cfif isdefined("arguments.MONTH_ID") and len(arguments.MONTH_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.MONTH_ID#">,<cfelse><cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">,</cfif>
                        <cfif isDefined("arguments.training_style") and len(arguments.training_style)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.training_style#">,<cfelse><cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">,</cfif>
                        <cfif len(arguments.class_tools)><cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.CLASS_TOOLS#">,</cfif>
                        <cfif isDefined("arguments.VIEW_TO_ALL") and len(arguments.VIEW_TO_ALL)>
                            <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
                            <cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">,
                            <cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">,
                            <cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">,
                        <cfelseif isDefined("arguments.is_wiew_branch") and len(arguments.is_wiew_branch)>
                            <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_wiew_branch#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">,
                            <cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">,
                        <cfelseif isDefined("arguments.is_wiew_department") and len(arguments.is_wiew_department)>
                            <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_wiew_branch_#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_wiew_department#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">,
                        <cfelseif isDefined("arguments.is_view_comp") and len(arguments.is_view_comp)>
                            <cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="1">,
                            <cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">,
                            <cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">,
                        <cfelse>
                            <cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">,
                            <cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">,
                            <cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">,
                            <cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">,
                        </cfif>
                        <cfif isDefined('arguments.project_id') and len(arguments.project_id) and len(arguments.project_head)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" null="yes" value=""></cfif>,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">,
                        <cfif isdefined('arguments.is_net_display') and arguments.is_net_display eq 1>1<cfelse>0</cfif>,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">,
                        <cfif isdefined('arguments.is_active') and arguments.is_active eq 1>1<cfelse>0</cfif>,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.language_id#">,
                        <!---<cfif len(attributes.related_class_id) and len(attributes.related_class_name)>
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.related_class_id#">,
                        <cfelse>
                            <cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">,
                        </cfif>--->
                        <cfif len(arguments.stock_id) and len(arguments.product_name)>
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#">,
                        <cfelse>
                            <cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">,
                        </cfif>
                        <cfif len(arguments.train_id) and len(arguments.train_head)>	
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.train_id#">,
                        <cfelse>
                            <cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">,
                        </cfif>
                        <cfif len(arguments.url_training) and len(arguments.url_training)>	
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.url_training#">
                        <cfelse>
                            <cfqueryparam cfsqltype="cf_sql_varchar" null="yes" value="">
                        </cfif>
                    )
            </cfquery>
            <cfset response.MAX_ID = MAX_ID>
            <cfcatch type = "any">
                <cfset response.status = false>
            </cfcatch>
        </cftry>
        <cfreturn response>
    </cffunction>
    <cffunction name="ADD_COMP_F" returntype="any">
        <cfargument name="class_id" type="numeric">
        <cfargument name="company_id" type="numeric">
        <cfquery name="add_comp" datasource="#dsn#">
            INSERT INTO TRAINING_CLASS_COMPANY
            (
                CLASS_ID,
                COMPANY_ID
            )
            VALUES
            (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.class_id#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
            )
        </cfquery> 
    </cffunction>
    <cffunction name="GET_COMPANY_F" returntype="any">
        <cfargument name="is_upd" default="0" required="false">
        <cfquery name="get_company" datasource="#dsn#">
            SELECT SITE_ID MENU_ID, DOMAIN SITE_DOMAIN,COMPANY OUR_COMPANY_ID from PROTEIN_SITES WHERE STATUS = 1
        </cfquery>
        <cfreturn get_company>
    </cffunction>
    <cffunction name="training_site_domain_f" returntype="any">
        <cfargument name="t_class_id" type="numeric">
        <cfargument name="menu_id">
        <cfquery name="training_site_domain" datasource="#dsn#">
            INSERT INTO
                TRAINING_CLASS_SITE_DOMAIN
                (
                    TRAINING_CLASS_ID,		
                    MENU_ID
                )
            VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.t_class_id#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.menu_id#">
                )	
        </cfquery>
    </cffunction>
    <!--- End of İnsert Functions --->

    <!--- Start Update Functions --->
    <cffunction name="GET_CLASS_IDS_F" returntype="any">
        <cfargument name="training_sec_id" type="numeric">
        <cfquery name="GET_CLASS_IDS" datasource="#DSN#">
            SELECT CLASS_ID FROM TRAINING_CLASS_SECTIONS WHERE TRAINING_SEC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.training_sec_id#">
        </cfquery>
        <cfreturn GET_CLASS_IDS>
    </cffunction>
    <cffunction name="GET_CLASS_F" returntype="any">
        <cfargument name="class_id" type="numeric">
        <cfargument name="online">
        <cfargument name="keyword" type="string">
        <cfargument name="training_sec_id">
        <cfargument name="class_ids">
        <cfargument name="date1">
        <cfquery name="GET_CLASS" datasource="#DSN#">
            SELECT
                CLASS_ID,
                #dsn#.Get_Dynamic_Language(CLASS_ID,'#session.ep.language#','TRAINING_CLASS','CLASS_NAME',NULL,NULL,CLASS_NAME) AS CLASS_NAME,
                ONLINE,
                INT_OR_EXT,
                IS_INTERNET,
                IS_ACTIVE,
                TRAINING_ID,
                LANGUAGE,
                TRAINING_STYLE,
                PROCESS_STAGE,
                TRAINING_CAT_ID,
                MAX_PARTICIPATION,
                MAX_SELF_SERVICE,
                TRAINING_SEC_ID,
                CLASS_PLACE,
                CLASS_PLACE_MANAGER,
                CLASS_PLACE_ADDRESS,
                CLASS_TOOLS,
                PROJECT_ID,
                CLASS_TARGET,
                #dsn#.Get_Dynamic_Language(CLASS_ID,'#session.ep.language#','TRAINING_CLASS','CLASS_ANNOUNCEMENT_DETAIL',NULL,NULL,CLASS_ANNOUNCEMENT_DETAIL) AS CLASS_ANNOUNCEMENT_DETAIL,
                CLASS_OBJECTIVE,
                VIEW_TO_ALL,
                IS_WIEW_BRANCH,
                IS_WIEW_DEPARTMENT,
                IS_VIEW_COMPANY,
                RECORD_DATE, 
                DATE_NO,
                HOUR_NO,
                CLASS_PLACE_TEL,
                STOCK_ID,
                TRAINING_LINK,
                MODULE_IDS,
                QUIZ_ID,
                START_DATE,
                FINISH_DATE,
                RECORD_EMP,
                UPDATE_EMP,
                UPDATE_DATE 
            FROM
                TRAINING_CLASS
            WHERE
                CLASS_ID IS NOT NULL
                <cfif isDefined("arguments.class_id") and len(arguments.class_id)>
                    AND CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.class_id#">
                </cfif>
                <cfif isDefined("arguments.online") and len(arguments.online)>
                    AND ONLINE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.online#">
                </cfif>
                <cfif isDefined("arguments.keyword") and len(arguments.keyword)>
                    AND
                    (CLASS_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR CLASS_OBJECTIVE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">)
                </cfif>
                <cfif isdefined("arguments.training_sec_id") and isdefined("arguments.class_ids") and len(arguments.class_ids)>
                    AND	CLASS_ID IN (#arguments.class_ids#)
                </cfif> 	
                <cfif isDefined("arguments.date1") and len(arguments.date1)>
                    <cf_date tarih='arguments.date1'>
                    AND	START_DATE >= #arguments.date1#
                </cfif>
                <cfif isdefined("arguments.training_sec_id") and len(arguments.training_sec_id) and arguments.training_sec_id neq 0>
                   AND TRAINING_SEC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.training_sec_id#">
                </cfif>
        </cfquery>
        <cfreturn GET_CLASS>
    </cffunction>
    <cffunction name="GET_CLASS_RESULTS_F" returntype="any">
        <cfargument name="CLASS_ID" type="numeric">
        <cfargument name="keyword" type="string">
        <cfquery name="GET_CLASS_RESULTS" datasource="#DSN#">
            SELECT
                CLASS_ID
            FROM
                TRAINING_CLASS_RESULTS
            WHERE
                CLASS_ID IS NOT NULL
                <cfif isDefined("arguments.CLASS_ID") and len(arguments.CLASS_ID)>
                    AND CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.class_id#">
                </cfif>
                <cfif isdefined("arguments.keyword") and len(arguments.keyword)>
                    AND
                        EMP_ID IN
                        (
                            SELECT
                                EMPLOYEE_ID
                            FROM
                                EMPLOYEE_POSITIONS
                            WHERE
                                EMPLOYEE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR 
                                EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                        )
                </cfif>
        </cfquery>
        <cfreturn GET_CLASS_RESULTS>
    </cffunction>
    <cffunction name="GET_CLASS_ATTENDER_EVAL_F" returntype="any">
        <cfargument name="class_id" type="numeric">
        <cfquery name="GET_CLASS_ATTENDER_EVAL" datasource="#DSN#">
            SELECT
                CLASS_ID
            FROM
                TRAINING_CLASS_ATTENDER_EVAL
            WHERE
                CLASS_ID IS NOT NULL
                <cfif isDefined("arguments.class_id") and len(arguments.class_id)>
                    AND CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.class_id#">
                </cfif>
        </cfquery>
        <cfreturn GET_CLASS_ATTENDER_EVAL>
    </cffunction>
    <cffunction name="GET_CLASS_COST_F" returntype="any">
        <cfargument name="class_id" type="numeric">
        <cfquery name="GET_CLASS_COST" datasource="#DSN#">
            SELECT
                CLASS_ID
            FROM
                TRAINING_CLASS_COST
            WHERE
                CLASS_ID IS NOT NULL
                <cfif isDefined("arguments.class_id") and len(arguments.class_id)>
                    AND CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.class_id#">
                </cfif>
        </cfquery>
        <cfreturn GET_CLASS_COST>
    </cffunction>
    <cffunction name="GET_CL_SEC_F" returntype="any">
        <cfargument name="class_id" type="numeric">
        <cfquery name="GET_CL_SEC" datasource="#DSN#">
            SELECT
                TT.TRAINING_SEC_ID,
                TC.TRAIN_SECTION_ID,
                TT.TRAIN_ID AS TRAINING_ID,
                TRAIN_HEAD
            FROM
                TRAINING_CLASS_SECTIONS TC,
                TRAINING TT
            WHERE
                TT.TRAIN_ID = TC.TRAIN_ID AND
                TC.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.class_id#">
        </cfquery>
        <cfreturn GET_CL_SEC>
    </cffunction>
    <cffunction name="get_class_company_f" returntype="any">
        <cfargument name="class_id" type="numeric">
        <cfquery name="get_class_company" datasource="#dsn#">
            SELECT COMPANY_ID FROM TRAINING_CLASS_COMPANY WHERE CLASS_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.class_id#">
        </cfquery>
        <cfreturn get_class_company>
    </cffunction>
    <cffunction name="GET_CLASS_ATTENDER_F" returntype="any">
        <cfargument name="CLASS_ID" type="numeric">
        <cfquery name="GET_CLASS_ATTENDER" datasource="#DSN#">
            SELECT CLASS_ID FROM TRAINING_CLASS_ATTENDER WHERE CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.CLASS_ID#">
        </cfquery>
        <cfreturn GET_CLASS_ATTENDER>
    </cffunction>
    <cffunction name="get_class_attenders_by_id" returntype="any">
        <cfargument name="lesson_id" type="numeric">
        <cfquery name="get_class_attenders_by_id" datasource="#DSN#">
            SELECT
                *
            FROM
                TRAINING_GROUP_CLASS_ATTENDANCE TGCA
                    INNER JOIN TRAINING_GROUP_ATTENDERS TGA ON TGA.TRAINING_GROUP_ATTENDERS_ID = TGCA.TRAINING_GROUP_ATTENDERS_ID
            WHERE TGCA.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.lesson_id#">
        </cfquery>
        <cfreturn get_class_attenders_by_id>
    </cffunction>
    <cffunction name="GET_MODULES_F" returntype="any">
        <cfquery name="GET_MODULES" datasource="#DSN#">
            SELECT MODULE_ID,MODULE_SHORT_NAME FROM MODULES  WHERE MODULE_SHORT_NAME IS NOT NULL ORDER BY MODULE_SHORT_NAME
        </cfquery>
        <cfreturn GET_MODULES>
    </cffunction>
    <cffunction name="GET_QUIZ_RESULT_F" returntype="any">
        <cfargument name="class_id" type="numeric">
        <cfargument name="quiz_id" default="">
        <cfquery name="GET_QUIZ_RESULT" datasource="#DSN#">
            SELECT	
                CLASS_EVAL_ID
            FROM
                TRAINING_CLASS_EVAL
            WHERE
                <cfif isdefined("arguments.quiz_id") and len(arguments.quiz_id)>
                    QUIZ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.quiz_id#"> AND
                </cfif>	
                CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.class_id#">
        </cfquery>
        <cfreturn GET_QUIZ_RESULT>
    </cffunction>
    <cffunction name="CONTROL_F" returntype="any">
        <cfargument name="class_id" type="numeric">
        <cfquery name="CONTROL" datasource="#DSN#">
            SELECT 
                RESULT_HEAD,
                RESULT_DETAIL 
            FROM 
                TRAINING_CLASS_RESULT_REPORT 
            WHERE 
                CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.class_id#">
        </cfquery>
        <cfreturn CONTROL>
    </cffunction>
    <cffunction name="GET_RECORD_POSITIONS_CODE_F" returntype="any">
        <cfargument name="record_emp" type="numeric">
        <cfquery name="GET_RECORD_POSITIONS_CODE" datasource="#DSN#">
            SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.record_emp#">  AND IS_MASTER = 1
        </cfquery>
        <cfreturn GET_RECORD_POSITIONS_CODE>
    </cffunction>
    <cffunction name="GET_TRAINER_F" returntype="any">
        <cfargument name="class_id" type="numeric">
        <cfquery name="GET_TRAINER" datasource="#DSN#" maxrows="1">
            SELECT EMP_ID,PAR_ID,CONS_ID FROM TRAINING_CLASS_TRAINERS WHERE CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.class_id#">
        </cfquery>
        <cfreturn GET_TRAINER>
    </cffunction>
    <cffunction name="GET_TRAINING_F" returntype="any">
        <cfargument name="training_id" type="numeric">
        <cfquery name="GET_TRAINING" datasource="#DSN#">
            SELECT TRAIN_HEAD FROM TRAINING WHERE TRAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.training_id#">
        </cfquery>
        <cfreturn GET_TRAINING>
    </cffunction>
    <cffunction name="GET_PRODUCT_F" returntype="any">
        <cfargument name="stock_id" type="numeric">
        <cfquery name="GET_PRODUCT" datasource="#DSN3#">
            SELECT 
                P.PRODUCT_NAME,
                S.PROPERTY
            FROM 
                PRODUCT P, 
                STOCKS S
            WHERE 
                S.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#"> 
                AND S.PRODUCT_ID = P.PRODUCT_ID
        </cfquery>
        <cfreturn GET_PRODUCT>
    </cffunction>
    <cffunction name="UPD_CLASS_F" returntype="any">
        <cfargument name="max_participation">
        <cfargument name="max_self_service">
        <cfargument name="training_sec_id">
        <cfargument name="training_cat_id" type="numeric">
        <cfargument name="CLASS_NAME" type="string">
        <cfargument name="CLASS_OBJECTIVE" type="string">
        <cfargument name="CLASS_TARGET" type="string">
        <cfargument name="class_announcement" type="string">
        <cfargument name="CLASS_PLACE" type="string">
        <cfargument name="CLASS_PLACE_ADDRESS" type="string">
        <cfargument name="CLASS_PLACE_TEL" type="string">
        <cfargument name="CLASS_PLACE_MANAGER" type="string">
        <cfargument name="START_DATE" type="date">
        <cfargument name="FINISH_DATE" type="date">
        <cfargument name="DATE_NO">
        <cfargument name="HOUR_NO">
        <cfargument name="online">
        <cfargument name="int_or_ext">
        <cfargument name="class_tools" type="string">
        <cfargument name="MONTH_ID">
        <cfargument name="training_style">
        <cfargument name="VIEW_TO_ALL">
        <cfargument name="is_wiew_branch">
        <cfargument name="is_wiew_branch_">
        <cfargument name="is_wiew_department">
        <cfargument name="is_view_comp">
        <cfargument name="modules">
        <cfargument name="project_id">
        <cfargument name="project_head" type="string">
        <cfargument name="is_net_display" type="numeric">
        <cfargument name="process_stage" type="numeric">
        <cfargument name="is_active" type="numeric">
        <cfargument name="language_id">
        <cfargument name="stock_id">
        <cfargument name="product_name">
        <cfargument name="train_id">
        <cfargument name="train_head">
        <cfargument name="class_id">
        <cfargument name="url_training">
        <cfquery name="UPD_CLASS" datasource="#DSN#">
			UPDATE
				TRAINING_CLASS
			SET
				MAX_PARTICIPATION = <cfif len(arguments.max_participation)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.max_participation#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
				MAX_SELF_SERVICE = <cfif len(arguments.max_self_service)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.max_self_service#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
				TRAINING_SEC_ID = <cfif isdefined("arguments.training_sec_id") and len(arguments.training_sec_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.training_sec_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
				TRAINING_CAT_ID = <cfif isdefined("arguments.training_cat_id") and len(arguments.training_cat_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.training_cat_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
				CLASS_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.class_name#">,
				CLASS_OBJECTIVE = <cfif isdefined("arguments.class_objective") and len(arguments.class_objective)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.class_objective#"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"></cfif>,
				CLASS_PLACE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.class_place#">,
				CLASS_PLACE_ADDRESS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.class_place_address#">,
				CLASS_PLACE_TEL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.class_place_tel#">,
				CLASS_PLACE_MANAGER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.class_place_manager#">,
				START_DATE = <cfif len(arguments.start_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"><cfelse><cfqueryparam cfsqltype="cf_sql_timestamp" value="" null="yes"></cfif>,
				FINISH_DATE = <cfif len(arguments.finish_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#"><cfelse><cfqueryparam cfsqltype="cf_sql_timestamp" value="" null="yes"></cfif>,			
				DATE_NO = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.date_no#">,
				HOUR_NO = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.hour_no#">,
				ONLINE = <cfif isdefined("arguments.online") and len(arguments.online)>1<cfelse>0</cfif>,
				INT_OR_EXT = <cfif isdefined("arguments.int_or_ext") and len(arguments.int_or_ext)>1<cfelse>0</cfif>,
                CLASS_TOOLS = <cfif len(arguments.class_tools)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.class_tools#">,<cfelse>NULL,</cfif>
				CLASS_TARGET = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.class_target#">,
				CLASS_ANNOUNCEMENT_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.class_announcement#">,
				<!--- PROJECT_ID = <cfif isDefined('attributes.project_id') and len(attributes.project_id) and len(attributes.project_head)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" null="yes" value=""></cfif>, --->
				UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				MONTH_ID=<cfif isdefined("arguments.month_id") and len(arguments.month_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.month_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" null="yes" value=""></cfif>,
				TRAINING_STYLE =<cfif isDefined("arguments.training_style") and len(arguments.training_style)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.training_style#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes"></cfif>,
				<cfif isDefined("arguments.view_to_all") and len(arguments.view_to_all)>
					VIEW_TO_ALL = <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
					IS_WIEW_BRANCH = <cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes">,
					IS_WIEW_DEPARTMENT = <cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes">,
                    IS_VIEW_COMPANY = <cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes">,
				<cfelseif isDefined("arguments.is_wiew_branch") and len(arguments.is_wiew_branch)>
					VIEW_TO_ALL = <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
					IS_WIEW_BRANCH = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_wiew_branch#">,
					IS_WIEW_DEPARTMENT = <cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes">,
                    IS_VIEW_COMPANY = <cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes">,
				<cfelseif isDefined("arguments.is_wiew_department") and len(arguments.is_wiew_department)>
					VIEW_TO_ALL = <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
					IS_WIEW_BRANCH = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_wiew_branch_#">,
					IS_WIEW_DEPARTMENT = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_wiew_department#">,
                    IS_VIEW_COMPANY = <cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes">,
				<cfelseif isDefined("arguments.is_view_comp") and len(arguments.is_view_comp)>
					VIEW_TO_ALL = <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
					IS_WIEW_BRANCH = <cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes">,
					IS_WIEW_DEPARTMENT = <cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes">,
                    IS_VIEW_COMPANY = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_view_comp#">,
				<cfelse>
					VIEW_TO_ALL = <cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes">,
					IS_WIEW_BRANCH = <cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes">,
					IS_WIEW_DEPARTMENT = <cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes">,
                    IS_VIEW_COMPANY = <cfqueryparam cfsqltype="cf_sql_integer" value="" null="yes">,
				</cfif>
                MODULE_IDS = <cfif isDefined('arguments.modules') and len(arguments.modules)>'#arguments.modules#'<cfelse>NULL</cfif>,
                IS_ACTIVE = <cfif isdefined("arguments.is_active") and arguments.is_active eq 1>1<cfelse>0</cfif>,
				IS_INTERNET = <cfif isdefined("arguments.is_net_display") and arguments.is_net_display eq 1>1<cfelse>0</cfif>,
				PROCESS_STAGE =<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#" >,
				LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.language_id#">,
				<cfif len(arguments.stock_id) and len(arguments.product_name)>
					STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#">,
				<cfelse>
					STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">,
				</cfif>
				<cfif len(arguments.train_id) and len(arguments.train_head)>
					TRAINING_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.train_id#">,
				<cfelse>
					TRAINING_ID = <cfqueryparam cfsqltype="cf_sql_integer" null="yes" value="">,
				</cfif>
                <cfif len(arguments.url_training) and len(arguments.url_training)>
					TRAINING_LINK =<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.url_training#">
				<cfelse>
					TRAINING_LINK = <cfqueryparam cfsqltype="cf_sql_varchar" null="yes" value="">
				</cfif>
			WHERE
				CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.class_id#">
		</cfquery>
    </cffunction>
    <cffunction name="DEL_SITE_DOMAIN_F" returntype="any">
        <cfargument name="class_id" type="numeric">
        <cfquery name="DEL_SITE_DOMAIN" datasource="#DSN#">
            DELETE FROM TRAINING_CLASS_SITE_DOMAIN WHERE TRAINING_CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.class_id#">
        </cfquery>
    </cffunction>
    <cffunction name="DEL_COMP_F" returntype="any">
        <cfargument name="class_id" type="numeric">
        <cfquery name="DEL_COMP" datasource="#DSN#">
        	DELETE FROM TRAINING_CLASS_COMPANY WHERE CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.class_id#">
        </cfquery>
    </cffunction>
    <!--- End of Update Functions --->

    <cffunction name="GET_HOMEWORK" returntype="any">
        <cfargument name="lesson_id" type="numeric">
        <cfquery name="GET_HOMEWORK" datasource="#DSN#">
        	SELECT
                THS.*
            FROM
                TRAINING_HOMEWORK_STUDY THS
            WHERE
                LESSON_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.lesson_id#">
            ORDER BY
                DELIVERY_DATE ASC
        </cfquery>
        <cfreturn GET_HOMEWORK>
    </cffunction>

    <cffunction name="GET_HOMEWORK_DELIVERIES" returntype="any">
        <cfargument name="homework_id" type="numeric">
        <cfquery name="GET_HOMEWORK_DELIVERIES" datasource="#DSN#">
        	SELECT
                THSD.*
            FROM
                TRAINING_HOMEWORK_STUDY_DELIVERY THSD
            WHERE
                HOMEWORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.homework_id#">
        </cfquery>
        <cfreturn GET_HOMEWORK_DELIVERIES>
    </cffunction>

    <cffunction name="get_employee" returntype="any">
        <cfargument name="userid" type="numeric">
        <cfargument name="member_type" type="string">
        <cfquery name="get_employee" datasource="#dsn#">
            <cfif isDefined("member_type")>
                <cfif arguments.member_type eq 'partner'>
                    SELECT COMPANY_PARTNER_NAME +' '+ COMPANY_PARTNER_SURNAME AS NAME_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID = #arguments.userid#
                <cfelseif arguments.member_type eq 'consumer'>
                    SELECT CONSUMER_NAME +' '+ CONSUMER_SURNAME AS NAME_SURNAME FROM CONSUMER WHERE CONSUMER_ID = #arguments.userid#
                <cfelse>
                    SELECT EMPLOYEE_NAME +' '+ EMPLOYEE_SURNAME AS NAME_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #arguments.userid#
                </cfif>
            </cfif>
        </cfquery>
        <cfreturn get_employee>
    </cffunction>

    <cffunction name="get_homework_by_id" returntype="any">
        <cfargument name="homework_id" type="numeric">
        <cfquery name="get_homework_by_id" datasource="#dsn#">
            SELECT * FROM TRAINING_HOMEWORK_STUDY WHERE HOMEWORK_ID = #arguments.homework_id#
        </cfquery>
        <cfreturn get_homework_by_id>
    </cffunction>
    
    <cffunction name="get_asset_by_id" returntype="any">
        <cfargument name="lesson_id" type="numeric">
        <cfquery name="get_asset_by_id" datasource="#dsn#">
            SELECT 
                * 
            FROM 
                ASSET
            WHERE
                ASSETCAT_ID = -6
                AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.lesson_id#">
                AND MODULE_ID = 34
                AND ACTION_SECTION = 'CLASS_ID'
        </cfquery>
        <cfreturn get_asset_by_id>
    </cffunction>

    <cffunction name="add_homework" returntype="any" access="remote">
        <cf_date tarih = "arguments.delivery_date">
        <cftry>
            <cfset responseStruct = structNew()>
            <cfquery name="add_homework" datasource="#dsn#" result="MAX_ID">
                INSERT INTO TRAINING_HOMEWORK_STUDY
                (
                    LESSON_ID
                    ,HOMEWORK
                    ,DETAIL
                    <cfif arguments.member_type eq 'employee'>
                        ,EMP_ID
                    <cfelseif arguments.member_type eq 'partner'>
                        ,PAR_ID
                    <cfelse>
                        ,CONS_ID
                    </cfif>
                    ,MEMBER_TYPE
                    ,DELIVERY_DATE
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.class_id#">
                    ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.homework#">
                    ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.homework_detail#">
                    <cfif arguments.member_type eq 'employee'>
                        ,<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.emp_id#">
                    <cfelseif arguments.member_type eq 'partner'>
                        ,<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.par_id#">
                    <cfelse>
                        ,<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cons_id#">
                    </cfif>
                    ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.member_type#">
                    ,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.delivery_date#">

                )
            </cfquery>
            <cfset responseStruct.message = "İşlem Başarılı">
            <cfset responseStruct.status = true>
            <cfset responseStruct.error = {}>
            <cfset responseStruct.identity = ''>
        <cfcatch type="database">
            <cftransaction action="rollback">
            <cfset responseStruct.message = "İşlem Hatalı">
            <cfset responseStruct.status = false>
            <cfset responseStruct.error = cfcatch>
        </cfcatch>
        </cftry>
        <cfreturn responseStruct>
    </cffunction>

    <cffunction name="upd_homework" returntype="any" access="remote">
        <cf_date tarih = "arguments.delivery_date">
        <cftry>
            <cfset responseStruct = structNew()>
            <cfquery name="upd_homework" datasource="#dsn#">
                UPDATE
                    TRAINING_HOMEWORK_STUDY
                SET
                    HOMEWORK = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.homework#">
                    ,DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.homework_detail#">
                    <cfif arguments.member_type eq 'employee'>
                        ,EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.emp_id#">
                        ,PAR_ID = NULL
                        ,CONS_ID = NULL
                    <cfelseif arguments.member_type eq 'partner'>
                        ,PAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.par_id#">
                        ,EMP_ID = NULL
                        ,CONS_ID = NULL
                    <cfelse>
                        ,CONS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cons_id#">
                        ,EMP_ID = NULL
                        ,PAR_ID = NULL
                    </cfif>
                    ,MEMBER_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.member_type#">
                    ,DELIVERY_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.delivery_date#">
                WHERE HOMEWORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.homework_id#">
            </cfquery>
            <cfset responseStruct.message = "İşlem Başarılı">
            <cfset responseStruct.status = true>
            <cfset responseStruct.error = {}>
            <cfset responseStruct.identity = ''>
        <cfcatch type="database">
            <cftransaction action="rollback">
            <cfset responseStruct.message = "İşlem Hatalı">
            <cfset responseStruct.status = false>
            <cfset responseStruct.error = cfcatch>
        </cfcatch>
        </cftry>
        <cfreturn responseStruct>
    </cffunction>

    <cffunction name="del_homework" access="remote" returntype="any">
        <cftry>
            <cfquery name="del_homework" datasource="#DSN#">
                DELETE             
                FROM
                    TRAINING_HOMEWORK_STUDY
                WHERE
                    HOMEWORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.homework_id#">
            </cfquery>
            <cfset responseStruct.message = "İşlem Başarılı">
            <cfset responseStruct.status = true>
            <cfset responseStruct.error = {}>
            <cfset responseStruct.identity = ''>
        <cfcatch type="database">
            <cftransaction action="rollback">
            <cfset responseStruct.message = "İşlem Hatalı">
            <cfset responseStruct.status = false>
            <cfset responseStruct.error = cfcatch>
        </cfcatch>
        </cftry>
        <cfreturn responseStruct>
    </cffunction>

    <cffunction name = "get_user_info" returnType = "any" access = "public" description = "Get user info">
        <cfargument name="userkey" type="string" required="true" displayname="user key string">
        
        <cfif arguments.userkey contains "e">
            <cfquery name="get_user_info" datasource="#DSN#">
                SELECT
                    EMPLOYEE_ID AS MEMBER_ID,
                    EMPLOYEE_NAME AS NAME,
                    EMPLOYEE_SURNAME AS SURNAME,
                    'employee' AS MEMBER_TYPE
                FROM
                    EMPLOYEES
                WHERE
                    EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(arguments.userkey,"-")#">
            </cfquery>
        <cfelseif arguments.userkey contains "p">
            <cfquery name="get_user_info" datasource="#DSN#">
                SELECT
                    PARTNER_ID AS MEMBER_ID,
                    COMPANY_PARTNER_NAME AS NAME,
                    COMPANY_PARTNER_SURNAME AS SURNAME,
                    'partner' AS MEMBER_TYPE
                FROM
                    COMPANY_PARTNER
                WHERE
                    PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(arguments.userkey,"-")#">
            </cfquery>
        <cfelseif arguments.userkey contains "c">
            <cfquery name="get_user_info" datasource="#DSN#">
                SELECT
                    CONSUMER_ID AS MEMBER_ID,
                    CONSUMER_NAME AS NAME,
                    CONSUMER_SURNAME AS SURNAME,
                    'consumer' AS MEMBER_TYPE
                FROM
                    CONSUMER
                WHERE
                    CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(arguments.userkey,"-")#">
            </cfquery>
        </cfif>
        <cfreturn get_user_info>
    </cffunction>

    <cffunction name="add_homework_answer" returntype="any" access="remote">
        <cftry>
            <cfset responseStruct = structNew()>
            <cfquery name="add_homework_answer" datasource="#dsn#" result="MAX_ID">
                INSERT INTO TRAINING_HOMEWORK_STUDY_DELIVERY
                (
                    HOMEWORK_ID
                    <cfif arguments.member_type eq 'employee'>
                        ,EMP_ID
                    <cfelseif arguments.member_type eq 'partner'>
                        ,PAR_ID
                    <cfelse>
                        ,CONS_ID
                    </cfif>
                    ,DELIVERY_DATE
                    ,ANSWER
                    <cfif isDefined("arguments.puan") and len(arguments.puan)>
                        ,PUAN
                    </cfif>
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.homework_id#">
                    <cfif arguments.member_type eq 'employee'>
                        ,<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.emp_id#">
                    <cfelseif arguments.member_type eq 'partner'>
                        ,<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.par_id#">
                    <cfelse>
                        ,<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cons_id#">
                    </cfif>
                    ,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.delivery_date#">
                    ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.answer#">
                    <cfif isDefined("arguments.puan") and len(arguments.puan)>
                        ,<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.puan#">
                    <cfelse>,0
                    </cfif>
                )
            </cfquery>
            <cfset responseStruct.message = "İşlem Başarılı">
            <cfset responseStruct.status = true>
            <cfset responseStruct.error = {}>
            <cfset responseStruct.identity = ''>
        <cfcatch type="database">
            <cftransaction action="rollback">
            <cfset responseStruct.message = "İşlem Hatalı">
            <cfset responseStruct.status = false>
            <cfset responseStruct.error = cfcatch>
        </cfcatch>
        </cftry>
        <cfreturn responseStruct>
    </cffunction>

    <cffunction name="upd_homework_answer" returntype="any" access="remote">
        <cf_date tarih = "arguments.delivery_date">
        <cftry>
            <cfset responseStruct = structNew()>
            <cfquery name="upd_homework_answer" datasource="#dsn#" result="MAX_ID">
                UPDATE
                    TRAINING_HOMEWORK_STUDY_DELIVERY
                SET
                    HOMEWORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.homework_id#">
                    <cfif arguments.member_type eq 'employee'>
                        ,EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.emp_id#">
                    <cfelseif arguments.member_type eq 'partner'>
                        ,PAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.par_id#">
                    <cfelse>
                        ,CONS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cons_id#">
                    </cfif>
                    ,DELIVERY_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.delivery_date#">
                    ,ANSWER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.answer#">
                    <cfif isDefined("arguments.puan") and len(arguments.puan)>
                        ,PUAN = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.puan#">
                    </cfif>
                WHERE HOMEWORK_DELIVERY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.homework_delivery_id#">
            </cfquery>
            <cfset responseStruct.message = "İşlem Başarılı">
            <cfset responseStruct.status = true>
            <cfset responseStruct.error = {}>
            <cfset responseStruct.identity = ''>
        <cfcatch type="database">
            <cftransaction action="rollback">
            <cfset responseStruct.message = "İşlem Hatalı">
            <cfset responseStruct.status = false>
            <cfset responseStruct.error = cfcatch>
        </cfcatch>
        </cftry>
        <cfreturn responseStruct>
    </cffunction>

    <cffunction name="GET_TRAININGS" returntype="any">
        <cfargument name="train_group_id" type="numeric">
        <cfquery name="GET_TRAININGS" datasource="#DSN#">
            SELECT
                TC.CLASS_ID,
                TC.CLASS_NAME,
                TC.START_DATE,
                TC.FINISH_DATE,
                TCG.CLASS_GROUP_ID,
                TCG.TRAIN_GROUP_ID
            FROM
                TRAINING_CLASS_GROUP_CLASSES TCG,
                TRAINING_CLASS TC
            WHERE
                TC.CLASS_ID=TCG.CLASS_ID
            AND
                TCG.TRAIN_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.train_group_id#">
        </cfquery>
        <cfreturn GET_TRAININGS>
    </cffunction>

    <cffunction name="get_training_groups" returntype="any">
        <cfargument name="lesson_id" type="numeric">
        <cfquery name="get_training_groups" datasource="#dsn#">
            SELECT
                *
            FROM
                TRAINING_CLASS_GROUPS TCG
                    INNER JOIN TRAINING_CLASS_GROUP_CLASSES TCGC ON TCGC.TRAIN_GROUP_ID = TCG.TRAIN_GROUP_ID
                    INNER JOIN TRAINING_CLASS TC ON TC.CLASS_ID = TCGC.CLASS_ID
            WHERE
                TC.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.lesson_id#">
        </cfquery>
        <cfreturn get_training_groups>
    </cffunction>

    <cffunction name="get_joined" returntype="any">
        <cfargument name="train_group_id">
        <cfargument name="class_id">
        <cfargument name="ATTENDER_ID">
        <cfquery name="get_joined" datasource="#dsn#">
            SELECT
                *
            FROM
                TRAINING_GROUP_CLASS_ATTENDANCE
            WHERE
                TRAINING_GROUP_ATTENDERS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ATTENDER_ID#">
                AND CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.class_id#">
                AND TRAINING_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.train_group_id#">
        </cfquery>
        <cfreturn get_joined>
    </cffunction>

    <cffunction name="upd_lesson_attenders" returntype="any" access="remote">
        <cftry>
            <cfset responseStruct = structNew()>
            <cfset train_group_id = arguments.train_group_id.split(",")[1]>
            <cfset class_attender_id = arguments.class_attender_id.split(",")>
            <cfset k_id = arguments.k_id.split(",")>
            <cfset type = arguments.type.split(",")>
            <cfset class_id = arguments.class_id.split(",")[1]>
            <cfset joined = arguments.joined.split(",")>
            <cfset count = ArrayLen(k_id)>
            <cfloop from="1" to="#count#" index="i">
                <cfquery name="upd_lesson_attenders" datasource="#dsn#" result="MAX_ID">
                    UPDATE
                        TRAINING_GROUP_CLASS_ATTENDANCE
                    SET
                        JOINED = <cfqueryparam cfsqltype="cf_sql_integer" value="#joined[i]#">
                    WHERE
                        TRAINING_GROUP_ATTENDERS_ID = #class_attender_id[i]#
                        AND TRAINING_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#train_group_id#">
                        AND CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#class_id#">
                </cfquery>
            </cfloop>
            <cfset responseStruct.message = "İşlem Başarılı">
            <cfset responseStruct.status = true>
            <cfset responseStruct.error = {}>
            <cfset responseStruct.identity = ''>
        <cfcatch type="database">
            <cftransaction action="rollback">
            <cfset responseStruct.message = "İşlem Hatalı">
            <cfset responseStruct.status = false>
            <cfset responseStruct.error = cfcatch>
        </cfcatch>
        </cftry>
        <cfreturn responseStruct>
    </cffunction>

    <cffunction name="GetContent" access="public" returntype="query">
        <cfargument name="action_type" default="">
        <cfargument name="action_type_id" default="">
        <cfargument name="train_group_id" default="">
        <cfargument name="chapter" default="">
        <cfargument name="company_id" default="">
        <cfquery name="GET_CONTENT" datasource="#DSN#">
            SELECT
                CR.CONTENT_ID,
                CR.RECORD_EMP,
                C.RECORD_DATE,
                C.CONT_HEAD,
                C.CONT_SUMMARY,
                C.CONTENT_PROPERTY_ID,
                C.UPDATE_MEMBER,
                PTR.STAGE,
                C.WRITE_VERSION,
                C.UPDATE_DATE,
                CP.NAME,
                CCH.CHAPTER,
                CC.CONTENTCAT,
                CC.CONTENTCAT_ID
            FROM
                CONTENT_RELATION CR,
                CONTENT_CHAPTER CCH,
                CONTENT_CAT CC,
		        CONTENT_PROPERTY CP,
                CONTENT C
                    LEFT JOIN PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = C.PROCESS_STAGE
            WHERE
                C.CONTENT_PROPERTY_ID = CP.CONTENT_PROPERTY_ID
                AND CR.ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_type#">
                AND CR.ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_type_id#">
                AND CR.CONTENT_ID = C.CONTENT_ID
                <cfif isdefined("arguments.company_id") and len(arguments.company_id)>
                    AND CR.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
                </cfif>
                AND CC.CONTENTCAT_ID = CCH.CONTENTCAT_ID
                AND CCH.CHAPTER_ID = C.CHAPTER_ID
        </cfquery>
        <cfreturn GET_CONTENT>  
	</cffunction>

    <cffunction name="get_training_groups_contents" access="public" returntype="query">
        <cfargument name="action_type" default="">
        <cfargument name="action_type_id" default="">
        <cfargument name="train_group_id" default="">
        <cfargument name="chapter" default="">
        <cfargument name="company_id" default="">
        <cfquery name="get_training_groups_contents" datasource="#DSN#">
            SELECT
                CR.CONTENT_ID,
                CR.RECORD_EMP,
                C.RECORD_DATE,
                C.CONT_HEAD,
                C.CONT_SUMMARY,
                C.CONTENT_PROPERTY_ID,
                C.UPDATE_MEMBER,
                C.WRITE_VERSION,
                C.UPDATE_DATE,
                CP.NAME,
                CCH.CHAPTER,
                CC.CONTENTCAT,
                CC.CONTENTCAT_ID
            FROM
                CONTENT_RELATION CR,
                CONTENT_CHAPTER CCH,
                CONTENT_CAT CC,
                CONTENT_PROPERTY CP,
                CONTENT C
            WHERE
                CR.CONTENT_ID = C.CONTENT_ID
                AND CR.ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_type#">
                AND CR.ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_type_id#">
                AND CC.CONTENTCAT_ID = CCH.CONTENTCAT_ID
                AND CCH.CHAPTER_ID = C.CHAPTER_ID
        </cfquery>
        <cfreturn get_training_groups_contents>  
	</cffunction>
</cfcomponent>