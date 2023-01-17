<cfcomponent>
    <cfset dsn=application.systemParam.systemParam().dsn>
    <cfset dsn2 = '#dsn#_#session.ep.period_year#_#session.ep.company_id#'>
    <cfset dsn3 = '#dsn#_#session.ep.company_id#'> 
    <cffunction  name="GET_PRIORITY"  returntype="any">
     <cfargument  name="priority_id" default="">
    <cfquery name="GET_PRIORITY" datasource="#dsn#">
        SELECT
            *
        FROM
            SETUP_PRIORITY
            <cfif isdefined('arguments.priority_id') and len(arguments.priority_id)>
        WHERE
            PRIORITY_ID=#arguments.priority_id#
            </cfif>
        ORDER BY
            PRIORITY_ID
    </cfquery> 
     <cfreturn GET_PRIORITY>
    </cffunction>
    
    <cffunction name="DET_PROJECT" access="remote" >
      <cfargument name="id" default="">
      <cfargument name="PROJECT_NUMBER" default="">
      <cfargument name="PROJECT_STATUS" default=""> 
      <cfargument name="PROJECT_EMP_ID" default=""> 
      <cfargument name="PROJECT_HEAD" default=""> 
      <cfargument name="AGREEMENT_NO" default="">
      <cfargument name="PROJECT_DETAIL" default=""> 
      <cfargument name="TARGET_START" default="">
      <cfargument name="TARGET_FINISH" default=""> 
      <cfargument name="PRO_CURRENCY_ID" default=""> 
      <cfargument name="PRO_PRIORITY_ID" default="">
      <cfargument name="OUTSRC_CMP_ID" default=""> 
      <cfargument name="OUTSRC_PARTNER_ID" default=""> 
      <cfargument name="PROJECT_TARGET" default=""> 
      <cfargument name="EXPENSE_CODE" default="">
      <cfargument name="EXPECTED_BUDGET" default=""> 
      <cfargument name="EXPECTED_COST" default="">
      <cfargument name="BUDGET_CURRENCY" default=""> 
      <cfargument name="COST_CURRENCY" default=""> 
      <cfargument name="RECORD_DATE" default="">
      <cfargument name="RECORD_EMP" default=""> 
      <cfargument name="RECORD_PAR" default=""> 
      <cfargument name="RECORD_IP" default="">
      <cfargument name="UPDATE_DATE" default="">
      <cfargument name="UPDATE_EMP" default="">
      <cfargument name="UPDATE_PAR" default="">
      <cfargument name="UPDATE_IP" default=""> 
      <cfargument name="CAMPAIGN_ID" default=""> 
      <cfargument name="COMPANY_ID" default=""> 
      <cfargument name="CONSUMER_ID" default="">
      <cfargument name="PARTNER_ID" default="">
      <cfargument name="RELATED_PROJECT_ID" default=""> 
      <cfargument name="PROCESS_CAT" default=""> 
      <cfargument name="PROJECT_FOLDER" default="">
      <cfargument name="WORKGROUP_ID" default=""> 
      <cfargument name="PRODUCT_ID" default=""> 
      <cfargument name="DEPARTMENT_ID" default=""> 
      <cfargument name="COUNTRY_ID" default="">
      <cfargument name="SALES_ZONE_ID" default=""> 
      <cfargument name="LOCATION_ID" default=""> 
      <cfargument name="SPECIAL_DEFINITION_ID" default=""> 
      <cfargument name="CARGO_COMPANY_ID" default=""> 
      <cfargument name="DUTY_COMPANY_ID" default="">
      <cfargument name="INSURANCE_COMPANY_ID" default="">
      <cfargument name="TERM_DATE" default=""> 
      <cfargument name="ESTIMATED_OUT_DATE" default=""> 
      <cfargument name="ESTIMATED_ARRIVE_DATE" default=""> 
      <cfargument name="PROJECT_POS_CODE" default=""> 
      <cfargument name="COUNTY_ID" default=""> 
      <cfargument name="CITY_ID" default=""> 
      <cfargument name="COORDINATE_1" default=""> >
      <cfargument name="COORDINATE_2" default=""> 
        <cfargument name="PRO_H_START" default=""> 
       <cfargument name="PRO_H_FINISH" default="">
      <cfargument name="IS_SEND_WEBSERVICE" default="">
      <cfargument name="BRANCH_ID" default="">
      <cfdump  var="#arguments#">
      <cflock name="#CREATEUUID()#" timeout="20">
        <cftransaction>
        <cfquery name="UPDS_PROJECT"  datasource="#dsn#" result="result">
            UPDATE 
                PRO_PROJECTS
            SET 
                CONSUMER_ID = NULL,
                COMPANY_ID = NULL,
                PARTNER_ID = NULL,
                PROJECT_STATUS = <cfif isDefined("arguments.PROJECT_STATUS")>1<cfelse>0</cfif>,
            <cfif len(arguments.PROJECT_EMP_ID)>
                PROJECT_EMP_ID=#arguments.PROJECT_EMP_ID#,
                PROJECT_POS_CODE=<cfif len(arguments.PROJECT_POS_CODE)>#arguments.PROJECT_POS_CODE#<cfelse>NULL</cfif>,
                OUTSRC_CMP_ID=NULL,
                OUTSRC_PARTNER_ID=NULL,
            <cfelseif len(arguments.TASK_COMPANY_ID)>
                PROJECT_EMP_ID=NULL,
                PROJECT_POS_CODE=NULL,
                OUTSRC_CMP_ID=#arguments.TASK_COMPANY_ID#,
                OUTSRC_PARTNER_ID=<cfif len(arguments.TASK_PARTNER_ID)>#arguments.TASK_PARTNER_ID#,<cfelse>NULL,</cfif>
            </cfif>
                PROJECT_FOLDER= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PROJECT_FOLDER#">,
                PROJECT_TARGET= <cfif len(arguments.PROJECT_TARGET)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PROJECT_TARGET#">,<cfelse>NULL,</cfif>
                PROJECT_NUMBER=<cfif len(arguments.project_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.project_number)#"><cfelse>#arguments.id#</cfif>,
                RELATED_PROJECT_ID = <cfif len(arguments.RELATED_PROJECT_ID) and len(arguments.RELATED_PROJECT_HEAD)>#arguments.RELATED_PROJECT_ID#,<cfelse>NULL,</cfif>
                PROJECT_HEAD=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PROJECT_HEAD#">,
                PROJECT_DETAIL=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.PROJECT_DETAIL#">,
                TARGET_START=#arguments.PRO_H_START#,
                TARGET_FINISH=#arguments.PRO_H_FINISH#,
                PRO_CURRENCY_ID=#arguments.process_stage#,
                PRO_PRIORITY_ID=#arguments.PRIORITY_CAT#,
                UPDATE_EMP=#SESSION.EP.USERID#,
                UPDATE_DATE = #now()#,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
                PROCESS_CAT = <cfif isdefined("arguments.main_process_cat") and len(arguments.main_process_cat)>#arguments.main_process_cat#<cfelse>NULL</cfif>,
                EXPENSE_CODE =<cfif isdefined("arguments.EXPENSE_CODE") and len(arguments.EXPENSE_CODE) and len(arguments.EXPENSE_CODE_NAME)>#arguments.EXPENSE_CODE#<cfelse>NULL</cfif>,
                EXPECTED_BUDGET = <cfif isdefined("arguments.EXPECTED_BUDGET") and len(arguments.EXPECTED_BUDGET)>#arguments.EXPECTED_BUDGET#<cfelse>NULL</cfif>,
                EXPECTED_COST = <cfif isdefined("arguments.EXPECTED_COST") and len(arguments.EXPECTED_COST)>#arguments.EXPECTED_COST#<cfelse>NULL</cfif>,
                BUDGET_CURRENCY = <cfif isdefined("arguments.BUDGET_CURRENCY") and len(arguments.BUDGET_CURRENCY)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.BUDGET_CURRENCY#"><cfelse>NULL</cfif>,
                COST_CURRENCY = <cfif isdefined("arguments.COST_CURRENCY") and len(arguments.COST_CURRENCY)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.COST_CURRENCY#"><cfelse>NULL</cfif>,
                AGREEMENT_NO = <cfif isdefined("arguments.agreement_no") and len(arguments.agreement_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.agreement_no#"><cfelse>NULL</cfif>,
                WORKGROUP_ID = <cfif len(arguments.workgroup_id)>#arguments.workgroup_id#<cfelse>NULL</cfif>,
                PRODUCT_ID = <cfif isdefined('arguments.product_id') and len(arguments.product_id) and isdefined('arguments.product_name') and len(arguments.product_name)>#arguments.product_id#<cfelse>NULL</cfif>,
                BRANCH_ID = <cfif isdefined("arguments.branch_id") and len(arguments.branch_id)>#arguments.branch_id#<cfelse>NULL</cfif>,
                DEPARTMENT_ID = <cfif isdefined('arguments.department') and len(arguments.department)>#listfirst(arguments.department,'-')#<cfelse>NULL</cfif>,
                LOCATION_ID = <cfif isdefined('arguments.department') and len(arguments.department)>#listlast(arguments.department,'-')#<cfelse>NULL</cfif>,
                COUNTRY_ID = <cfif isdefined("arguments.country_id") and len(arguments.country_id)>#arguments.country_id#<cfelse>NULL</cfif>,
                SALES_ZONE_ID = <cfif isdefined("arguments.sales_zone_id") and len(arguments.sales_zone_id)>#arguments.sales_zone_id#<cfelse>NULL</cfif>,
                SPECIAL_DEFINITION_ID = <cfif isdefined("arguments.special_definition") and len(arguments.special_definition)>#arguments.special_definition#<cfelse>NULL</cfif>,
                CARGO_COMPANY_ID = <cfif isdefined("arguments.CARGO_COMPANY_ID") and len(arguments.CARGO_COMPANY)>#arguments.CARGO_COMPANY_ID#<cfelse>NULL</cfif>,
                DUTY_COMPANY_ID = <cfif isdefined("arguments.DUTY_COMPANY_ID") and len(arguments.DUTY_COMPANY)>#arguments.DUTY_COMPANY_ID#<cfelse>NULL</cfif>,
                INSURANCE_COMPANY_ID = <cfif isdefined("arguments.INSURANCE_COMPANY_ID") and len(arguments.INSURANCE_COMPANY)>#arguments.INSURANCE_COMPANY_ID#<cfelse>NULL</cfif>,
                TERM_DATE = <cfif isdefined("arguments.TERM_DATE") and len(arguments.TERM_DATE)>#arguments.TERM_DATE#<cfelse>NULL</cfif>,
                ESTIMATED_OUT_DATE = <cfif isdefined("arguments.ESTIMATED_OUT_DATE") and len(arguments.ESTIMATED_OUT_DATE)>#arguments.ESTIMATED_OUT_DATE#<cfelse>NULL</cfif>,
                ESTIMATED_ARRIVE_DATE = <cfif isdefined("arguments.ESTIMATED_ARRIVE_DATE") and len(arguments.ESTIMATED_ARRIVE_DATE)>#arguments.ESTIMATED_ARRIVE_DATE#<cfelse>NULL</cfif>,
                CITY_ID = <cfif isdefined("arguments.city_id") and len(arguments.city_id)>#arguments.city_id#<cfelse>NULL</cfif>,
                COUNTY_ID = <cfif isdefined("arguments.county_id") and len(arguments.county_id)>#arguments.county_id#<cfelse>NULL</cfif>,
                COORDINATE_1 = <cfif isdefined("arguments.coordinate_1") and len(arguments.coordinate_1)>#arguments.coordinate_1#<cfelse>NULL</cfif>,
                COORDINATE_2 = <cfif isdefined("arguments.coordinate_2") and len(arguments.coordinate_2)>#arguments.coordinate_2#<cfelse>NULL</cfif>
            WHERE 
                PROJECT_ID = #arguments.id# AND
                PRO_PRIORITY_ID=#arguments.priority_id#
            </cfquery>
            </cftransaction>
        </cflock> 
    </cffunction>
    <cffunction  name="select"  access = "public">
        <cfargument name="id" default="">
        <cfquery name="get_project"  datasource="#DSN#">
            SELECT 
               PR.PROJECT_ID,
               PP2.PROJECT_ID AS RELATED_PROJECT_ID,
               PP2.PROJECT_HEAD AS RELATED_PROJECT_HEAD, 
               PR.PROJECT_NUMBER,
               PR.PROJECT_STATUS,
               PR.PROJECT_EMP_ID,
               PR.PROJECT_POS_CODE,
               PR.PROJECT_HEAD,
               PR.AGREEMENT_NO,
               PRO.PRODUCT_ID,
               PRO.PRODUCT_NAME,
               PR.PROJECT_DETAIL,
               PR.TARGET_START,
               PR.TARGET_FINISH,
               PR.PRO_CURRENCY_ID,
               CMP.FULLNAME,
               CMP.COMPANY_ID as cmp_company_id,
               PR.PRO_PRIORITY_ID,
               PR.OUTSRC_CMP_ID,
               PR.OUTSRC_PARTNER_ID,
               PR.PROJECT_TARGET,
               PR.EXPENSE_CODE,
               PR.EXPECTED_BUDGET,
               PR.EXPECTED_COST,
               PR.BUDGET_CURRENCY,
               PR.COST_CURRENCY,
               PR.RECORD_DATE,
               PR.RECORD_EMP,
               CMPRT.COMPANY_PARTNER_NAME,
               CMPRT.COMPANY_PARTNER_SURNAME,
               CMPRT.COMPANY_ID AS COMPANY_PARTNER_ID ,
               PR.RECORD_PAR,
               PR.RECORD_IP,
               STP.PRIORITY_ID,
               STP.PRIORITY,
               EMP.EMPLOYEE_ID,
               EMP.EMPLOYEE_NAME,
               EMP.EMPLOYEE_SURNAME,
               PR.UPDATE_DATE,
               PR.UPDATE_EMP,
               PR.UPDATE_PAR,
               PR.UPDATE_IP,
               PR.CAMPAIGN_ID,
               PR.COMPANY_ID,
               PR.CONSUMER_ID,
               CS.CONSUMER_ID,
               CS.CONSUMER_NAME,
               CS.CONSUMER_SURNAME,
               PR.PARTNER_ID,
               PR.RELATED_PROJECT_ID,
               PR.PROCESS_CAT,
               PR.PROJECT_FOLDER,
               PR.WORKGROUP_ID,
               PR.PRODUCT_ID,
               PR.BRANCH_ID,
               WG.WORKGROUP_ID,
               WG.WORKGROUP_NAME,
               PR.DEPARTMENT_ID,
               PR.COUNTRY_ID,
               PR.SALES_ZONE_ID,
               PR.LOCATION_ID,
               BR.BRANCH_ID,
               EXP.EXPENSE_CODE,
               EXP.EXPENSE ,
               BR.BRANCH_NAME,
               PR.SPECIAL_DEFINITION_ID,
               PR.CARGO_COMPANY_ID,
               PR.DUTY_COMPANY_ID,
               PR.INSURANCE_COMPANY_ID,
               PR.TERM_DATE,
               PR.ESTIMATED_OUT_DATE,
               PR.ESTIMATED_ARRIVE_DATE,
               PR.CITY_ID,
               PR.COUNTY_ID,
               PR.COORDINATE_1,
               PR.COORDINATE_2,
               PR.LANGUAGE_ID
            FROM 
            PRO_PROJECTS AS PR
            LEFT JOIN COMPANY AS CMP ON CMP.COMPANY_ID = PR.COMPANY_ID
            LEFT JOIN BRANCH AS BR ON BR.BRANCH_ID = PR.BRANCH_ID
            LEFT JOIN EMPLOYEES AS EMP ON EMP.EMPLOYEE_ID = PR.PROJECT_EMP_ID
            LEFT JOIN COMPANY_PARTNER AS CMPRT ON CMPRT.PARTNER_ID = PR.PARTNER_ID
            LEFT JOIN #DSN2#.EXPENSE_CENTER AS EXP ON EXP.EXPENSE_CODE = PR.EXPENSE_CODE
            LEFT JOIN #DSN3#.PRODUCT AS PRO ON PRO.PRODUCT_ID = PR.PRODUCT_ID
            LEFT JOIN WORK_GROUP AS WG ON WG.WORKGROUP_ID = PR.WORKGROUP_ID
            LEFT JOIN CONSUMER AS CS ON CS.CONSUMER_ID = PR.CONSUMER_ID
            LEFT JOIN PRO_PROJECTS AS PP2 ON PP2.PROJECT_ID = PR.RELATED_PROJECT_ID
            LEFT JOIN SETUP_PRIORITY AS STP ON STP.PRIORITY_ID = PR.PRO_PRIORITY_ID
        WHERE 
                PR.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
        </cfquery>
      
        <cfreturn get_project>
    </cffunction>
    <cffunction  name="get" access="public">
        <cfargument  name="id" default="">
         <cfreturn select(id=arguments.id)> 
    </cffunction> 
    <cffunction  name="GET_CITY"  returntype="any">
        <cfquery name="GET_CITY" datasource="#DSN#">
            SELECT CITY_ID,CITY_NAME FROM SETUP_CITY 
        </cfquery>
        <cfreturn GET_CITY>
    </cffunction>
    <cffunction  name="GET_SPECIAL_DEF"  returntype="any">
    <cfquery name="GET_SPECIAL_DEF" datasource="#DSN#">
        SELECT SPECIAL_DEFINITION_ID,SPECIAL_DEFINITION FROM SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 6
    </cfquery>
     <cfreturn GET_SPECIAL_DEF>
    </cffunction>
    <cffunction  name="GET_WORKGROUPS"  returntype="any">
        <cfquery name="GET_WORKGROUPS" datasource="#DSN#">
            SELECT 
                WG.WORKGROUP_ID,
                WG.HIERARCHY,
                WG.WORKGROUP_NAME,
                WG.SUB_WORKGROUP,
                WG.OUR_COMPANY_ID,
                WG.MANAGER_EMP_ID,
                WG.DEPARTMENT_ID,
                WG.BRANCH_ID,
                WG.HEADQUARTERS_ID
            FROM
                WORK_GROUP WG
                where
                STATUS = 1 AND
		HIERARCHY IS NOT NULL
	ORDER BY 
		WORKGROUP_NAME
        </cfquery>
        <cfreturn GET_WORKGROUPS>
    </cffunction>
    <cffunction  name="GET_ZONES"  returntype="any">
        <cfquery name="GET_ZONES" datasource="#DSN#">
            SELECT SZ_ID,SZ_NAME FROM SALES_ZONES WHERE IS_ACTIVE = 1
        </cfquery>
        <cfreturn GET_ZONES>
     </cffunction>
    <cffunction  name="GET_COUNTRY"  returntype="any">
        <cfquery name="GET_COUNTRY" datasource="#DSN#">
            SELECT COUNTRY_ID,COUNTRY_NAME FROM SETUP_COUNTRY
        </cfquery>
     <cfreturn GET_COUNTRY>
    </cffunction>
   <cffunction  name="PROJECT_DETAIL" access = "public">
        <cfargument  name="id" default="">
        <cfquery name="PROJECT_DETAIL" datasource="#DSN#">
            SELECT 
                PRO_PROJECTS.*,
                SETUP_PRIORITY.PRIORITY,
                (
                    (
                        SELECT
                            SUM(ISNULL(TO_COMPLETE,0))
                        FROM
                            PRO_WORKS PW
                        WHERE
                            PW.PROJECT_ID = PRO_PROJECTS.PROJECT_ID
                    )/
                    (
                        SELECT
                            COUNT(WORK_ID)
                        FROM
                            PRO_WORKS PW2
                        WHERE
                            PW2.PROJECT_ID = PRO_PROJECTS.PROJECT_ID
                    )
                ) COMPLETE_RATE
            FROM 
                PRO_PROJECTS,		
                SETUP_PRIORITY
            WHERE
                <cfif isdefined("arguments.id")>
                PRO_PROJECTS.PROJECT_ID = #arguments.id# AND
                </cfif> 		
                PRO_PROJECTS.PRO_PRIORITY_ID = SETUP_PRIORITY.PRIORITY_ID 
        </cfquery>
    </cffunction>
    <cffunction  name="GET_DEPARTMAN" access = "public">
    <cfquery name="GET_DEPARTMAN" datasource="#DSN#">
       SELECT 
		SL.LOCATION_ID,
		SL.COMMENT,
		D.DEPARTMENT_ID,
		D.DEPARTMENT_HEAD,
		D.BRANCH_ID
	FROM
		STOCKS_LOCATION SL,
		DEPARTMENT D
	WHERE 
		SL.DEPARTMENT_ID = D.DEPARTMENT_ID
		AND D.BRANCH_ID IN (SELECT BRANCH_ID FROM BRANCH WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">)
	ORDER BY
		D.DEPARTMENT_HEAD,
		SL.COMMENT
      
    </cfquery>
    <cfreturn GET_DEPARTMAN>
    </cffunction>
    <cffunction name="get_branches_fnc" access="public" returnType="query" >
		<cfargument name="is_comp_branch" required="no" type="numeric" default="1"> <!--- işlem yapılan şirkete bakılsın mı? --->
		<cfargument name="is_pos_branch" required="no" type="numeric" default="1"> <!--- kullanıcının şube yetkilerine bakılsın mı? --->
		<cfargument name="is_branch_status" required="no" type="numeric" default="1">
		<cfargument name="modul" required="no" type="string" default="">
		<cfif len(arguments.modul) and arguments.modul eq 'hr' and not get_module_power_user(67)>
			<cfset arguments.is_pos_branch = 1>
		</cfif>
		<cfquery name="get_branches_" datasource="#DSN#">
			SELECT
				BRANCH.BRANCH_STATUS,
				BRANCH.HIERARCHY,
				BRANCH.HIERARCHY2,
				BRANCH.BRANCH_ID,
				BRANCH.BRANCH_NAME,
				BRANCH.COMPANY_ID,
				BRANCH.SSK_OFFICE,
				BRANCH.SSK_NO,
				OUR_COMPANY.COMP_ID,
				OUR_COMPANY.COMPANY_NAME,
				OUR_COMPANY.NICK_NAME
			FROM
				BRANCH
				INNER JOIN OUR_COMPANY ON BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID
			WHERE
				BRANCH.BRANCH_ID IS NOT NULL
				<cfif len(arguments.is_branch_status) and arguments.is_branch_status eq 1>
					AND BRANCH.BRANCH_STATUS = 1 
				</cfif>
				<cfif isDefined('session.ep.userid') and arguments.is_comp_branch eq 1>
					AND BRANCH.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> 
				<cfelseif isDefined('session.pda.our_company_id') and arguments.is_comp_branch eq 1>
					AND BRANCH.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.our_company_id#">                 
				</cfif>
				<cfif isDefined('session.ep.position_code') and arguments.is_pos_branch eq 1>
					AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
				</cfif>
				<cfif isDefined('session.ep.isBranchAuthorization') and session.ep.isBranchAuthorization>
					AND BRANCH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">
				</cfif>
			ORDER BY
				OUR_COMPANY.NICK_NAME,
				BRANCH.BRANCH_NAME 
		</cfquery>
		<cfreturn get_branches_>
	</cffunction>
    <cffunction  name="GET_CATS"  returntype="any">
        <cfquery name="GET_CATS" datasource="#DSN#"><!--- project\cfc\get_work.cfc dosyasına taşındı--->
            SELECT
            #dsn#.Get_Dynamic_Language(SETUP_PRIORITY.PRIORITY_ID,'#session.ep.language#','SETUP_PRIORITY','PRIORITY',NULL,NULL,SETUP_PRIORITY.PRIORITY) AS priority,
            PRIORITY_ID
            FROM 
                SETUP_PRIORITY 
            ORDER BY
                PRIORITY
        </cfquery>
        
    </cffunction>
 </cfcomponent>