<cfcomponent>
    <cfset variables.dsn = application.systemParam.systemParam().dsn>
    <cfset variables.dsn3 = application.systemParam.systemParam().dsn3>

    <cfset companyComp = createObject("component","V16.member.cfc.member_company")>

    <!--- Begin: iş ID 121395 --->
    <cffunction name="createCompany" returntype="any">
        <cfargument name="asset1" default="">
        <cfargument name="asset2" default="">
        <cfargument name="wrk_id" default="">
        <cfargument name="companycat_id" default="">
        <cfargument name="fullname" default="">
        <cfargument name="taxno" default="">
        <cfargument name="userid" default="#session.ep.userid#">
        <cfargument name="remote_addr" default="#cgi.remote_addr#">
        <cfargument name="record_date" default="#now()#">
        <cfargument name="is_person" default="">

        <cftransaction>
            <cfset comp = companyComp.ADD_COMPANY(arguments)>
            <cfreturn comp.generatedkey>
        </cftransaction>
        <cfreturn "false">
    </cffunction>

    <cffunction name="addWorkgroupMember" returntype="any">
        <cfargument name="company_id" default="">
        <cfargument name="our_company_id" default="#session.ep.company_id#">
        <cfargument name="pos_code" default="">
        <cfargument name="userid" default="#session.ep.userid#">
        <cfargument name="remote_addr" default="#cgi.remote_addr#">
        <cfargument name="record_date" default="#now()#">

        <cfset companyComp.ADD_WORKGROUP_MEMBER(arguments)>
    </cffunction>

    <cffunction name="addCompanyPeriod" returntype="any">
        <cfargument name="company_id" default="">
        <cfargument name="period_id" default="">

        <cfset companyComp.ADD_COMP_PERIOD(arguments)>
    </cffunction>

    <cffunction name="addCompanySectors" returntype="any">
        <cfargument name="company_sectors" default="">
        <cfargument name="company_id" default="">

        <cftransaction>
            <!--- Index yerine item olması gerekmezmi? --->
            <cfloop list="#attributes.company_sectors#" index="i">
                <cfset addCompanySector(sector_id:i, company_id:company_id)>
            </cfloop>
        </cftransaction>
    </cffunction>

    <cffunction name="addCompanySector" returntype="any">
        <cfargument name="sector_id" default="">
        <cfargument name="company_id" default="">
        
        <cfset companyComp.ADD_COMP_SECTOR(arguments.sector_id, arguments.company_id)>
    </cffunction>

    <cffunction name="updateMemberCode" returntype="any">
        <cfargument name="company_id" default="">
        <cfargument name="member_code" default="">
        
        <cfset companyComp.UPD_MEMBER_CODE(arguments.company_id, arguments.member_code)>
    </cffunction>

    <cffunction name="updatePartnerManager" returntype="any">
        <cfargument name="company_id" default="">
        <cfargument name="partner_id" default="">
        
        <cfset companyComp.UPD_MANAGER_PARTNER(arguments.company_id, arguments.partner_id)>
    </cffunction>

    <cffunction name="getCompanyByCode" access="public">
        <cfargument name="company_code" required="yes">
        <cfargument name="company_id" default="">
        <cfargument name="dsn3" default="#variables.dsn3#">
        <cfset arguments.company_code = trim(arguments.company_code)>

        <cfreturn companyComp.GET_COMPANY_CODE(arguments.company_code, arguments.company_id)>
    </cffunction>

    <cffunction name="isDuplicateCompanyCode" access="public">
        <cfargument name="company_code" required="yes">
        <cfargument name="company_id" default="">
        <cfargument name="dsn3" default="#variables.dsn3#">
        <cfset arguments.company_code = trim(arguments.company_code)>

        <cfset company = getCompanyByCode(arguments.company_code, arguments.company_id)>
        <cfreturn company.recordcount ? true : false>
    </cffunction>

    <cffunction name="getCompanyByName" access="public">
        <cfargument name="fullname" default="">
        <cfargument name="nickname" default="">
        <cfargument name="dsn3" default="#variables.dsn3#">
        <cfset arguments.fullname = trim(arguments.fullname)>
        <cfset arguments.nickname = trim(arguments.nickname)>

        <cfreturn companyComp.GET_COMP_BY_NAME(arguments.fullname, arguments.nickname)>
    </cffunction>

    <cffunction name="isDuplicateCompanyName" access="public">
        <cfargument name="fullname" default="">
        <cfargument name="nickname" default="">
        <cfargument name="dsn3" default="#variables.dsn3#">

        <cfset company = getCompanyByName(arguments.fullname, arguments.nickname)>
        <cfreturn company.recordcount ? true : false>
    </cffunction>

    <cffunction name="update_paper">
        <cfargument name="paper_type" required="yes">
        <cfargument name="dsn3" default="#variables.dsn3#">

        <cftransaction>
            <cf_papers paper_type="#arguments.paper_type#">
            <!--- Belge numarasi update ediliyor. --->
            <cfquery name="UPD_GEN_PAP" datasource="#dsn3#">
                UPDATE 
                    GENERAL_PAPERS
                SET
                    SUBSCRIPTION_NUMBER = #paper_number#
                WHERE
                    SUBSCRIPTION_NUMBER IS NOT NULL
            </cfquery>
        </cftransaction>
        <cfset paper = structNew()>
        <cfset paper.paper_code = paper_code>
		<cfset paper.paper_number = paper_number>
		<cfset paper.paper_full = paper_full>
        <cfreturn paper>
    </cffunction>

    <cffunction name="Get_Paper_Number_Code">
        <cfargument name="dsn3" default="#variables.dsn3#">

        <cfquery name="Get_Paper_Number_Code" datasource="#dsn3#">
            SELECT SUBSCRIPTION_NUMBER FROM GENERAL_PAPERS WHERE SUBSCRIPTION_NUMBER IS NOT NULL
        </cfquery>
        <cfreturn Get_Paper_Number_Code>
    </cffunction>

    <cffunction name="createPartner" returntype="any">
        <cfargument name="company_id" default="">
        <cfargument name="name" default="">
        <cfargument name="soyad" default="">
        <cfargument name="company_partner_status" default="">
        <cfargument name="title" default="">
        <cfargument name="sex" default="">
        <cfargument name="language" default="#session.ep.language#">
        <cfargument name="department" default="">
        <cfargument name="company_partner_email" default="">
        <cfargument name="mobilcat_id_partner" default="">
        <cfargument name="mobiltel_partner" default="">
        <cfargument name="telcod" default="">
        <cfargument name="tel1" default="">
        <cfargument name="tel_local" default="">
        <cfargument name="fax" default="">
        <cfargument name="homepage" default="">
        <cfargument name="mission" default="">
        <cfargument name="record_date" default="#now()#">
        <cfargument name="userid" default="#session.ep.userid#">
        <cfargument name="remote_addr" default="#cgi.remote_addr#">
        <cfargument name="adres" default="">
        <cfargument name="postcod" default="">
        <cfargument name="county_id" default="">
        <cfargument name="city_id" default="">
        <cfargument name="country" default="">
        <cfargument name="semt" default="">
        <cfargument name="tc_identity" default="">
        <cfargument name="birthdate" default="">
        
        <cftransaction>
            <cfset companyComp.ADD_PARTNER(arguments)>
            <cfreturn getMaxPartner().partner_id>
        </cftransaction>
        <cfreturn "false">
    </cffunction>

    <cffunction name="updateMemberCode" returntype="any">
        <cfargument name="partner_id" default="">

        <cfset companyComp.UPD_MEMBER_CODE(arguments.partner_id)>
    </cffunction>

    <cffunction name="addCompanyPartnerDetail" returntype="any">
        <cfargument name="partner_id" default="">
        
        <cfset companyComp.ADD_COMPANY_PARTNER_DETAIL(arguments.partner_id)>
    </cffunction>

    <cffunction name="addPartnerSettings" returntype="any">
        <cfargument name="partner_id" default="">
        <cfargument name="language" default="#session.ep.language#">

        <cfset companyComp.ADD_PART_SETTINGS(arguments.partner_id, arguments.language)>
    </cffunction>

    <cffunction name="getMaxPartner">
        <cfreturn companyComp.GET_MAX_PARTNER()>
    </cffunction>

    <cffunction name="createSubscriptionContract" access="public">
        <cfargument name="dsn3" default="#variables.dsn3#">

        <cftransaction>
            <cfset subscriptionContractComp.ADD_SUBSCRIPTION_CONTRACT(arguments)>
            <cfreturn getMaxSubscription(arguments.wrk_id).subscription_id>
        </cftransaction>
        <cfreturn "false">
    </cffunction>

    <cffunction name="addContractRows">
        <cfargument name="rows_" default="">
        <cfargument name="product_id" default="">
        <cfargument name="deliver_date" default="">
        <cfargument name="dsn3" default="#variables.dsn3#">

        <cftransaction>
            <cfloop from="1" to="#attributes.rows_#" index="i">
                <cf_date tarih="attributes.deliver_date#i#">
                <cfinclude template="get_dis_amount.cfm">
                <cfif isdefined("attributes.product_id#i#") and len(evaluate("attributes.product_id#i#"))>
                    <cfset addContractRow(arguments)>
                </cfif>
            </cfloop>
        </cftransaction>
    </cffunction>

    <cffunction name="addContractRow">
        <cfargument name="dsn3" default="#variables.dsn3#">

        <cfset subscriptionContractComp.ADD_CONTRACT_ROW(arguments)>
    </cffunction>

    <cffunction name="getSubscriptionNoByPaper">
        <cfargument name="paper_code" default="">
        <cfargument name="paper_number" default="">
        <cfargument name="dsn3" default="#variables.dsn3#">
        
        <cfreturn subscriptionContractComp.Check_No(arguments.DSN3, arguments.paper_code, arguments.paper_number)>
    </cffunction>

    <cffunction name="getMaxSubscription">
        <cfargument name="wrk_id" default="">
        <cfargument name="DSN3" default="#variables.dsn3#">

        <cfreturn subscriptionContractComp.GET_MAX_SUBSCRIPTION(arguments.DSN3, arguments.wrk_id)>
    </cffunction>
    <!--- End: iş ID 121395 --->

    <!--- Begin: iş ID 121396 --->

    <!--- Begin: V16\objects2\project\display\popup_graph.cfm --->
    <cffunction name="get_relations_by_work_id">
        <cfargument name="pro_work_id" required="yes">

        <cfquery name="get_relations" datasource="#dsn#">
            SELECT
                *
            FROM
                PRO_WORK_RELATIONS
            WHERE
                WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pro_work_id#">
                AND
                PRE_ID <> 0
        </cfquery>
        <cfreturn get_relations>
    </cffunction>

    <cffunction name="get_work_id_by_pre_id">
        <cfargument name="pre_id" required="yes">

        <cfquery name="get_work_id_by_pre_id">
            SELECT 
                WORK_ID 
            FROM 
                PRO_WORK_RELATIONS 
            WHERE 
                PRE_ID = #arguments.pre_id#
        </cfquery>
        <cfreturn get_work_id_by_pre_id>
    </cffunction>

    <cffunction name="get_priority_id_and_color">
        <cfquery name="get_priority_id_and_color">
            SELECT PRIORITY_ID, COLOR FROM SETUP_PRIORITY
        </cfquery>
        <cfreturn get_priority_id_and_color>
    </cffunction>
    <!--- End: V16\objects2\project\display\popup_graph.cfm --->
    
    <!--- Begin: V16\project\query\get_project_graph.cfm --->
    <cffunction name="GET_PRO_HEAD">
        <cfquery name="GET_PRO_HEAD" datasource="#DSN#">
            SELECT
                PRO_PROJECTS.PROJECT_HEAD,
                PRO_PROJECTS.TARGET_START,
                PRO_PROJECTS.TARGET_FINISH,
                PRO_PROJECTS.PRO_PRIORITY_ID,
                PRO_PROJECTS.PROCESS_CAT
            FROM
                PRO_PROJECTS,
                EMPLOYEES
            WHERE
                PRO_PROJECTS.PROJECT_ID = #attributes.PROJECT_ID#
                <!--- AND
                PRO_PROJECTS.PROJECT_EMP_ID =#attributes.project_emp_id# --->
                AND
                EMPLOYEES.EMPLOYEE_STATUS = 1
        UNION
            SELECT
                PRO_PROJECTS.PROJECT_HEAD,
                PRO_PROJECTS.TARGET_START,
                PRO_PROJECTS.TARGET_FINISH,
                PRO_PROJECTS.PRO_PRIORITY_ID,
                PRO_PROJECTS.PROCESS_CAT
            FROM
                PRO_PROJECTS,
                COMPANY_PARTNER
            WHERE
                PRO_PROJECTS.PROJECT_ID = #attributes.PROJECT_ID#
                AND
                PRO_PROJECTS.OUTSRC_PARTNER_ID = COMPANY_PARTNER.PARTNER_ID
        </cfquery>
        <cfreturn GET_PRO_HEAD>
    </cffunction>

    <cffunction name="GET_PRIORITY">
        <cfquery name="GET_PRIORITY" datasource="#dsn#">
            SELECT
                PRIORITY,
                COLOR
            FROM 
                SETUP_PRIORITY 
            WHERE 
                PRIORITY_ID=#GET_PRO_HEAD.PRO_PRIORITY_ID#
        </cfquery>
        <cfreturn GET_PRIORITY>
    </cffunction>

    <cffunction name="upd_works">
        <cfquery name="upd_works" datasource="#dsn#">
            UPDATE PRO_WORKS SET RELATED_WORK_ID = 0 WHERE RELATED_WORK_ID IS NULL
        </cfquery>
        <cfreturn upd_works>
    </cffunction>

    <cffunction name="get_graph">
        <cfquery name="get_graph" datasource="#dsn#">
            SELECT
                0 AS PARTNER_ID,
                '' AS COMPANY_PARTNER_NAME,
                '' AS COMPANY_PARTNER_SURNAME,
                EMPLOYEES.EMPLOYEE_ID,
                EMPLOYEES.EMPLOYEE_ID,
                EMPLOYEES.EMPLOYEE_NAME,
                EMPLOYEES.EMPLOYEE_SURNAME,
                PRO_WORKS.WORK_ID,
                PRO_WORKS.RELATED_WORK_ID,
                PRO_WORKS.WORK_HEAD,
                PRO_WORKS.WORK_CURRENCY_ID,
                PRO_WORKS.WORK_PRIORITY_ID,
                PRO_WORKS.TARGET_START AS TARGET_START,
                PRO_WORKS.TARGET_FINISH
            FROM
                PRO_WORKS,
                EMPLOYEES
            WHERE
                PRO_WORKS.PROJECT_ID = #attributes.PROJECT_ID# AND
                PRO_WORKS.PROJECT_EMP_ID = EMPLOYEES.EMPLOYEE_ID AND
                EMPLOYEES.EMPLOYEE_STATUS = 1
        UNION
            SELECT
                COMPANY_PARTNER.PARTNER_ID,
                COMPANY_PARTNER.COMPANY_PARTNER_NAME,
                COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
                0 AS EMPLOYEE_ID,
                0 AS PROJECT_EMP_ID,
                '' AS EMPLOYEE_NAME,
                '' AS EMPLOYEE_SURNAME,
                PRO_WORKS.WORK_ID,
                PRO_WORKS.RELATED_WORK_ID,
                PRO_WORKS.WORK_HEAD,
                PRO_WORKS.WORK_CURRENCY_ID,
                PRO_WORKS.WORK_PRIORITY_ID,
                PRO_WORKS.TARGET_START AS TARGET_START,
                PRO_WORKS.TARGET_FINISH
            FROM
                PRO_WORKS,
                COMPANY_PARTNER
            WHERE
                PRO_WORKS.PROJECT_ID = #attributes.PROJECT_ID# AND
                PRO_WORKS.OUTSRC_PARTNER_ID = COMPANY_PARTNER.PARTNER_ID
            ORDER BY
                TARGET_START
        </cfquery>
        <cfreturn get_graph>
    </cffunction>
    <!--- End: V16\project\query\get_project_graph.cfm --->
    
    <!--- Begin: V16\objects2\project\query\get_relations.cfm --->
    <cffunction name="get_relations">
        <cfquery name="get_relations" datasource="#dsn#">
            SELECT
                *
            FROM
                PRO_WORK_RELATIONS
            WHERE
                WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pro_work_id#">
                AND
                PRE_ID <> 0
        </cfquery>
        <cfreturn get_relations>
    </cffunction>
    <!--- End: V16\objects2\project\query\get_relations.cfm --->
    
    <!--- Begin: V16\objects2\project\form\add_prowork.cfm --->
    <cffunction name="GET_SPECIAL_DEFINITION">
        <cfquery name="GET_SPECIAL_DEFINITION" datasource="#DSN#">
            SELECT SPECIAL_DEFINITION_ID,SPECIAL_DEFINITION FROM SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 7
        </cfquery>
        <cfreturn GET_SPECIAL_DEFINITION>
    </cffunction>

    <cffunction name="GET_PROJECT">
        <cfargument name="project_id" required="yes">

        <cfquery name="GET_PROJECT" datasource="#DSN#">
			SELECT PROJECT_HEAD, PROJECT_ID, TARGET_START, TARGET_FINISH, COMPANY_ID, PARTNER_ID FROM PRO_PROJECTS WHERE PRO_PROJECTS.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">
        </cfquery>
        <cfreturn GET_PROJECT>
    </cffunction>

    <cffunction name="GET_PRO_WORK_INFO">
        <cfargument name="work_id" required="yes">

        <cfquery name="GET_PRO_WORK_INFO" datasource="#DSN#">
            SELECT 
                WORK_HEAD,
                WORK_ID,
                TARGET_START,
                TARGET_FINISH
            FROM 
                PRO_WORKS 
            WHERE 
                WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.work_id#">
        </cfquery>
        <cfreturn GET_PRO_WORK_INFO>
    </cffunction>
    <!--- End: V16\objects2\project\form\add_prowork.cfm --->
    
    <!--- Begin: V16\objects2\project\query\get_pro_work_cat.cfm --->
    <cffunction name="GET_WORK_CAT">
        <cfargument name="work_cat_id">

        <cfquery name="GET_WORK_CAT" datasource="#DSN#">
            SELECT 
                WORK_CAT_ID,
                WORK_CAT
            FROM 
                PRO_WORK_CAT
                <cfif isdefined("attributes.work_cat_id")>
                    WHERE
                        WORK_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.work_cat_id#">
                </cfif>
        </cfquery>
    </cffunction>
    <!--- End: V16\objects2\project\query\get_pro_work_cat.cfm --->

    <!--- Begin: V16\objects2\project\query\get_priority.cfm --->
    <cffunction name="GET_CATS">
        <cfquery name="GET_CATS" datasource="#DSN#">
            SELECT PRIORITY_ID, PRIORITY FROM SETUP_PRIORITY
        </cfquery>
        <cfreturn GET_CATS>
    </cffunction>
    <!--- End: V16\objects2\project\query\get_priority.cfm --->

    <!--- Begin: V16\objects2\project\query\get_project_team.cfm --->
    <cffunction name="GET_PROJECT2">
        <cfquery name="GET_PROJECT" datasource="#DSN#">
			SELECT PROJECT_ID FROM WORKGROUP_EMP_PAR WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
        </cfquery>
        <cfreturn GET_PROJECT>
    </cffunction>

    <cffunction name="GET_PROJECT_WORKGROUP">
        <cfargument name="project_id" required="yes">

        <cfquery name="GET_PROJECT_WORKGROUP" datasource="#DSN#" maxrows="1">
            SELECT WORKGROUP_ID FROM WORK_GROUP WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">
        </cfquery>
        <cfreturn GET_PROJECT_WORKGROUP>
    </cffunction>

    <cffunction name="GET_EMPS">
        <cfargument name="workgroup_id" required="yes">

        <cfquery name="GET_EMPS" datasource="#DSN#">
            SELECT 
              EMPLOYEE_POSITIONS.EMPLOYEE_ID,
              EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
              EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
              WORKGROUP_EMP_PAR.ROLE_ID
           FROM 
              EMPLOYEE_POSITIONS,
              WORKGROUP_EMP_PAR
           WHERE 
              EMPLOYEE_POSITIONS.POSITION_STATUS = 1 AND
              EMPLOYEE_POSITIONS.EMPLOYEE_ID = WORKGROUP_EMP_PAR.EMPLOYEE_ID AND
              WORKGROUP_EMP_PAR.WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.workgroup_id#">
      </cfquery>
      <cfreturn GET_EMPS>
    </cffunction>

    <cffunction name="GET_PARS">
        <cfargument name="workgroup_id" required="yes">

        <cfquery name="GET_PARS" datasource="#DSN#">
            SELECT 
                COMPANY_PARTNER.COMPANY_PARTNER_NAME,
                COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
                COMPANY_PARTNER.COMPANY_ID,
                COMPANY_PARTNER.PARTNER_ID,
                COMPANY.NICKNAME,
                WORKGROUP_EMP_PAR.ROLE_ID
            FROM 
                COMPANY_PARTNER,
                COMPANY,
                WORKGROUP_EMP_PAR
             WHERE 
                COMPANY_PARTNER.PARTNER_ID = WORKGROUP_EMP_PAR.PARTNER_ID AND
                COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
                COMPANY_PARTNER.COMPANY_PARTNER_STATUS = 1 AND
                WORKGROUP_EMP_PAR.WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.workgroup_id#">
        </cfquery>
        <cfreturn GET_PARS>
    </cffunction>
    <!--- End: V16\objects2\project\query\get_project_team.cfm --->

    <!--- Begin: V16\objects2\query\get_emps_pars_cons.cfm --->
    <cffunction name="GET_EMPS_PARS_CONS">
        <cfargument name="company_id">

        <cfquery name="GET_EMPS_PARS_CONS" datasource="#DSN#">
            <cfif isdefined('arguments.company_id') and len(arguments.company_id)>
                SELECT
                    3 AS TYPE,
                    CP.PARTNER_ID AS UYE_ID,
                    CP.COMPANY_ID AS COMP_ID,
                    CP.COMPANY_PARTNER_NAME AS UYE_NAME,
                    CP.COMPANY_PARTNER_SURNAME AS UYE_SURNAME,
                    C.NICKNAME AS NICKNAME
                FROM
                    COMPANY_PARTNER CP,
                    COMPANY C
                WHERE
                    CP.COMPANY_ID = C.COMPANY_ID AND
                    CP.COMPANY_PARTNER_STATUS = 1 AND		
                    CP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
                <cfif arguments.company_id neq session.pp.company_id>
                    UNION
                        SELECT
                            4 AS TYPE,
                            CP.PARTNER_ID AS UYE_ID,
                            CP.COMPANY_ID AS COMP_ID,
                            CP.COMPANY_PARTNER_NAME AS UYE_NAME,
                            CP.COMPANY_PARTNER_SURNAME AS UYE_SURNAME,
                            C.NICKNAME AS NICKNAME
                        FROM
                            COMPANY_PARTNER CP,
                            COMPANY C
                        WHERE
                            CP.COMPANY_ID = C.COMPANY_ID AND	
                            CP.COMPANY_PARTNER_STATUS = 1 AND	
                            CP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
                </cfif>
            <cfelse>
                SELECT
                    1 AS TYPE,
                    EP.EMPLOYEE_ID AS UYE_ID,
                    0 AS COMP_ID,
                    EP.EMPLOYEE_NAME AS UYE_NAME,
                    EP.EMPLOYEE_SURNAME AS UYE_SURNAME,
                    '' AS NICKNAME
                FROM
                    EMPLOYEE_POSITIONS EP,
                    WORKGROUP_EMP_PAR WE
                WHERE
                    EP.POSITION_STATUS = 1 AND
                    EP.POSITION_CODE = WE.POSITION_CODE AND
                    WE.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
                UNION
                    SELECT
                        2 AS TYPE,
                        CP.PARTNER_ID AS UYE_ID,
                        CP.COMPANY_ID AS COMP_ID,
                        CP.COMPANY_PARTNER_NAME AS UYE_NAME,
                        CP.COMPANY_PARTNER_SURNAME AS UYE_SURNAME,
                        C.NICKNAME AS NICKNAME
                    FROM
                        COMPANY_PARTNER CP,
                        WORKGROUP_EMP_PAR WE,
                        COMPANY C
                    WHERE
                        C.COMPANY_ID = CP.COMPANY_ID AND
                        CP.PARTNER_ID = WE.PARTNER_ID AND
                        CP.COMPANY_PARTNER_STATUS = 1 AND
                        WE.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
                UNION
                    SELECT
                        3 AS TYPE,
                        CP.PARTNER_ID AS UYE_ID,
                        CP.COMPANY_ID AS COMP_ID,
                        CP.COMPANY_PARTNER_NAME AS UYE_NAME,
                        CP.COMPANY_PARTNER_SURNAME AS UYE_SURNAME,
                        C.NICKNAME AS NICKNAME
                    FROM
                        COMPANY_PARTNER CP,
                        COMPANY C
                    WHERE
                        CP.COMPANY_ID = C.COMPANY_ID AND
                        CP.COMPANY_PARTNER_STATUS = 1 AND		
                        CP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
                UNION
                    SELECT
                        4 AS TYPE,
                        CP.PARTNER_ID AS UYE_ID,
                        CP.COMPANY_ID AS COMP_ID,
                        CP.COMPANY_PARTNER_NAME AS UYE_NAME,
                        CP.COMPANY_PARTNER_SURNAME AS UYE_SURNAME,
                        C.NICKNAME AS NICKNAME
                    FROM
                        COMPANY_PARTNER CP,
                        COMPANY C
                    WHERE
                        CP.COMPANY_ID = C.COMPANY_ID AND
                        CP.COMPANY_PARTNER_STATUS = 1 AND		
                        C.HIERARCHY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
                UNION
                    SELECT
                        5 AS TYPE,
                        C.CONSUMER_ID AS UYE_ID,
                        0 AS COMP_ID,
                        C.CONSUMER_NAME AS UYE_NAME,
                        C.CONSUMER_SURNAME AS UYE_SURNAME,
                        '' AS NICKNAME
                    FROM
                        CONSUMER C
                    WHERE	
                        C.HIERARCHY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
            </cfif>
        </cfquery>
    </cffunction>
    <!--- End: V16\objects2\query\get_emps_pars_cons.cfm --->

    <!--- Begin: V16\objects2\project\form\add_work_relation.cfm --->
    <cffunction name="GET_PRO_WORKS">
        <cfargument name="pro_id">
        <cfargument name="work_id">

        <cfquery name="GET_PRO_WORKS" datasource="#DSN#">
            SELECT
                WORK_HEAD,
                WORK_ID,
                TARGET_START
            FROM 
                PRO_WORKS
            WHERE
                <cfif isdefined("attributes.pro_id") and len(arguments.pro_id)>
                    PRO_WORKS.PROJECT_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pro_id#"> AND
                </cfif>
                (
                    PRO_WORKS.COMPANY_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> OR
                    PRO_WORKS.OUTSRC_CMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> OR
                    PRO_WORKS.RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> OR
                    PRO_WORKS.UPDATE_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
                )
                <cfif isDefined("attributes.work_id")>
                    AND WORK_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.work_id#">
                </cfif>
        </cfquery>
        <cfreturn GET_PRO_WORKS>
    </cffunction>

    <cffunction name="GET_COM_WORKS">
        <cfargument name="com_id" required="yes">

        <cfquery name="GET_COM_WORKS" datasource="#DSN#">
            SELECT
                WORK_HEAD,
                WORK_ID,
                TARGET_START
            FROM
                PRO_WORKS
            WHERE
                COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.com_id#">
          </cfquery>
          <cfreturn GET_COM_WORKS>
    </cffunction>
    <!--- End: V16\objects2\project\form\add_work_relation.cfm --->

    <!--- Begin: V16\objects2\display\list_projects_popup.cfm --->
    <cffunction name="GET_PROJECT_CAT">
        <cfquery name="GET_PROJECT_CAT" datasource="#DSN#">
            SELECT
               DISTINCT 
               SMC.MAIN_PROCESS_CAT_ID,
               SMC.MAIN_PROCESS_CAT
            FROM 
               SETUP_MAIN_PROCESS_CAT SMC,
               SETUP_MAIN_PROCESS_CAT_ROWS SMR,
               EMPLOYEE_POSITIONS
            WHERE
               SMC.MAIN_PROCESS_CAT_ID=SMR.MAIN_PROCESS_CAT_ID AND
               (EMPLOYEE_POSITIONS.POSITION_CAT_ID=SMR.MAIN_POSITION_CAT_ID OR 
                   EMPLOYEE_POSITIONS.POSITION_CODE=SMR.MAIN_POSITION_CODE)
        </cfquery>
        <cfreturn GET_PROJECT_CAT>
    </cffunction>
    
    <cffunction name="GET_PROCURRENCY">
        <cfquery name="GET_PROCURRENCY" datasource="#DSN#">
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
                <cfif isDefined('session.pp.userid')>
                    PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
                </cfif>
                PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%objects.popup_list_projects%">
            ORDER BY
                PTR.LINE_NUMBER
        </cfquery>
        <cfreturn GET_PROCURRENCY>
    </cffunction>

    <cffunction name="get_part">
        <cfargument name="partner_list" required="yes">

        <cfquery name="get_part" datasource="#dsn#">
            SELECT
                PARTNER_ID,
                <cfif (database_type is 'MSSQL')>
                    COMPANY_PARTNER_NAME +' '+ COMPANY_PARTNER_SURNAME AS PARTNER_NAME
                <cfelseif (database_type is 'DB2')>
                    COMPANY_PARTNER_NAME ||' '|| COMPANY_PARTNER_SURNAME AS PARTNER_NAME
                </cfif>
            FROM
                COMPANY_PARTNER
            WHERE
                PARTNER_ID IN (#arguments.partner_list#)
            ORDER BY
                PARTNER_ID
        </cfquery>
        <cfreturn get_part>
    </cffunction>

    <cffunction name="get_comp">
        <cfquery name="get_comp" datasource="#dsn#">
            SELECT COMPANY_ID, FULLNAME FROM COMPANY WHERE COMPANY_ID IN (#company_list#) ORDER BY COMPANY_ID
        </cfquery>
        <cfreturn get_comp>
    </cffunction>

    <cffunction name="GET_CONS">
        <cfargument name="consumer_list" required="yes">

        <cfquery name="GET_CONS" datasource="#DSN#">
            SELECT
                CONSUMER_ID,
                <cfif (database_type is 'MSSQL')>
                    (CONSUMER_NAME +' '+ CONSUMER_SURNAME) AS COMPANY_NAME
                <cfelseif (database_type is 'DB2')>
                    (CONSUMER_NAME ||' '|| CONSUMER_SURNAME) AS COMPANY_NAME
                </cfif>
            FROM
                CONSUMER
            WHERE
                CONSUMER_ID IN (#arguments.consumer_list#)
            ORDER BY
                CONSUMER_ID
        </cfquery>
        <cfreturn GET_CONS>
    </cffunction>

    <cffunction name="GET_COMPANY_PARTNERS">
        <cfargument name="outsrc_partner_list" required="yes">

        <cfquery name="GET_COMPANY_PARTNERS" datasource="#DSN#">
            SELECT
                PARTNER_ID,
                COMPANY_PARTNER_NAME AS PARTNER_NAME,
                COMPANY_PARTNER_SURNAME AS PARTNER_SURNAME,
                COMPANY_PARTNER_EMAIL PARTNER_EMAIL
            FROM
                COMPANY_PARTNER
            WHERE
                PARTNER_ID  IN (#arguments.outsrc_partner_list#) 
            ORDER BY 
                PARTNER_ID
        </cfquery>
        <cfreturn GET_COMPANY_PARTNERS>
    </cffunction>

    <cffunction name="GET_EMP">
        <cfargument name="project_emp_list" required="yes">

        <cfquery name="GET_EMP" datasource="#DSN#">
            SELECT
                EMPLOYEE_ID,
                EMPLOYEE_NAME,
                EMPLOYEE_SURNAME,
                EMPLOYEE_EMAIL
            FROM
                EMPLOYEES
            WHERE
                EMPLOYEE_ID IN (#arguments.project_emp_list#)
            ORDER BY
                EMPLOYEE_ID
        </cfquery>
        <cfreturn GET_EMP>
    </cffunction>

    <cffunction name="GET_PRIO">
        <cfargument name="priority_list" required="yes">

        <cfquery name="GET_PRIO" datasource="#DSN#">
            SELECT PRIORITY_ID,PRIORITY FROM SETUP_PRIORITY WHERE PRIORITY_ID IN (#arguments.priority_list#) ORDER BY PRIORITY_ID
        </cfquery>
        <cfreturn GET_PRIO>
    </cffunction>

    <cffunction name="GET_CURRENCY_NAME">
        <cfargument name="project_stage_list" required="yes">

        <cfquery name="GET_CURRENCY_NAME" datasource="#DSN#">
            SELECT PROCESS_ROW_ID,STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#arguments.project_stage_list#) ORDER BY PROCESS_ROW_ID
        </cfquery>
        <cfreturn GET_CURRENCY_NAME>
    </cffunction>

    <cffunction name="GET_CATEGORY_NAME">
        <cfargument name="project_category_list" required="yes">

        <cfquery name="GET_CATEGORY_NAME" datasource="#DSN#">
            SELECT MAIN_PROCESS_CAT_ID, MAIN_PROCESS_CAT FROM SETUP_MAIN_PROCESS_CAT WHERE MAIN_PROCESS_CAT_ID IN (#arguments.project_category_list#) ORDER BY MAIN_PROCESS_CAT_ID
        </cfquery>
        <cfreturn GET_CATEGORY_NAME>
    </cffunction>
    <!--- End: V16\objects2\display\list_projects_popup.cfm --->

    <!--- Begin: V16\objects2\project\query\get_projects_list.cfm --->
    <cffunction name="GET_PROJECTS">
        <cfargument name="userid" default="-1">
        <cfargument name="company_id" default="-1">
        <cfargument name="keyword" default="">
        <cfargument name="currency" default="">
        <cfargument name="priority_cat" default="">
        <cfargument name="project_status" default="">

        <cfquery name="GET_PROJECTS" datasource="#DSN#">
            SELECT 
                DISTINCT(PP.PROJECT_ID),
                PP.*,
                (SELECT EMPLOYEE_NAME +' '+ EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = PP.PROJECT_EMP_ID) PRO_EMPLOYEE,
                SP.COLOR,
                SP.PRIORITY
            FROM 
                WORK_GROUP WG,
                WORKGROUP_EMP_PAR WEP,
                PRO_PROJECTS PP,
                SETUP_PRIORITY SP
                <cfif len(arguments.keyword)>
                    ,PRO_HISTORY
                </cfif>
            WHERE
                WG.WORKGROUP_ID = WEP.WORKGROUP_ID AND 
                PP.PRO_PRIORITY_ID = SP.PRIORITY_ID AND
                (	
                    PP.PROJECT_ID = WG.PROJECT_ID OR 
                    WG.PROJECT_ID IS NULL 
                )
               AND
                (	
                    PP.OUTSRC_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userid#"> OR
                    PP.OUTSRC_CMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"> OR
                    PP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"> OR
                    PP.UPDATE_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userid#"> OR
                    PP.RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userid#"> OR
                    WEP.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userid#"> OR
                    WEP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
                )
                <cfif len(arguments.keyword) gt 1>
                    AND PP.PROJECT_ID=PRO_HISTORY.PROJECT_ID
                    AND (
                            PP.PROJECT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR
                            PP.PROJECT_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                        )
                <cfelseif len(arguments.keyword) eq 1>
                    AND PP.PROJECT_ID = PRO_HISTORY.PROJECT_ID
                    AND PP.PROJECT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                </cfif>
                <cfif len(arguments.currency)>
                    AND PP.PRO_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.currency#">
                </cfif>
                <cfif len(arguments.priority_cat)>
                    AND PP.PRO_PRIORITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.priority_cat#"> 
                </cfif>
                <cfif len(arguments.project_status)>
                    AND PP.PROJECT_STATUS = #arguments.project_status#
                </cfif>
        </cfquery>
        <cfreturn GET_PROJECTS>
    </cffunction>
    <!--- End: V16\objects2\project\query\get_projects_list.cfm --->

    <!--- Begin: V16\objects2\project\form\upd_work.cfm --->
    <!--- Aynı fonksiyon, V16\objects2\project\form\add_prowork.cfm --->
    <cffunction name="GET_SPECIAL_DEFINITION2">
        <cfquery name="GET_SPECIAL_DEFINITION" datasource="#DSN#">
            SELECT SPECIAL_DEFINITION_ID,SPECIAL_DEFINITION FROM SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 7
        </cfquery>
        <cfreturn GET_SPECIAL_DEFINITION>
    </cffunction>

    <cffunction name="GET_PROCURRENCY2">
        <cfquery name="GET_PROCURRENCY" datasource="#DSN#">
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
                <cfif isdefined("session.pp")>
                    PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
                <cfelseif isdefined("session.ww")>
                    PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#"> AND
                <cfelse>
                    PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                </cfif>
                PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%objects2.popup_updwork%">
            ORDER BY 
                PTR.LINE_NUMBER
        </cfquery>
        <cfreturn GET_PROCURRENCY>
    </cffunction>

    <cffunction name="GET_PRO_NAME">
        <cfargument name="project_id" required="yes">

        <cfquery name="GET_PRO_NAME" datasource="#DSN#">
            SELECT 
                PROJECT_HEAD 
            FROM 
                PRO_PROJECTS 
            WHERE
                PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">
        </cfquery>
        <cfreturn GET_PRO_NAME>
    </cffunction>

    <cffunction name="GET_PROCESS">
        <cfargument name="work_currency_id" required="yes">

        <cfquery name="GET_PROCESS" datasource="#DSN#">
            SELECT STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.work_currency_id#">
        </cfquery>
        <cfreturn GET_PROCESS>
    </cffunction>
    <!--- End: V16\objects2\project\form\upd_work.cfm --->

    <!--- Begin: V16\objects2\project\query\get_work.cfm --->
    <cffunction name="UPD_WORK">
        <cfargument name="work_id" required="yes">

        <cfquery name="UPD_WORK" datasource="#DSN#">
            SELECT 
                PW.TARGET_START,
                PW.TARGET_FINISH,
                PW.PROJECT_ID,
                PW.WORK_CURRENCY_ID,
                PW.WORK_PRIORITY_ID,
                PW.WORK_CAT_ID,
                PW.RELATED_WORK_ID,
                PW.WORK_HEAD,
                PW.PROJECT_EMP_ID,
                PW.OUTSRC_CMP_ID,
                PW.OUTSRC_PARTNER_ID,
                PW.WORK_STATUS,
                PW.RECORD_AUTHOR,
                PW.RECORD_PAR,
                PW.RECORD_DATE,
                PW.WORK_ID
            FROM 
                PRO_WORKS AS PW
            WHERE 
                PW.WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.work_id#">
                <!--- <cfif isdefined('attributes.id') and len(attributes.id)>
                    AND
                    (
                        PW.PROJECT_ID IN
                            (
                            SELECT PROJECT_ID FROM PRO_PROJECTS
                            WHERE
                                    PRO_PROJECTS.OUTSRC_PARTNER_ID = #session.pp.userid# OR
                                    PRO_PROJECTS.OUTSRC_CMP_ID = #session.pp.company_id# OR
                                    PRO_PROJECTS.COMPANY_ID = #session.pp.company_id# OR
                                    PRO_PROJECTS.UPDATE_PAR = #session.pp.userid# OR
                                    PRO_PROJECTS.RECORD_PAR = #session.pp.userid#
                            )
                        OR ( PW.PROJECT_ID = 0 AND (PW.COMPANY_ID=#session.pp.company_id# OR PW.OUTSRC_CMP_ID = #session.pp.company_id# OR PW.RECORD_PAR = #session.pp.userid#) )
                    )
                </cfif> --->
        </cfquery>
        <cfreturn UPD_WORK>
    </cffunction>

    <cffunction name="GET_LAST_REC">
        <cfargument name="work_id" required="yes">

        <cfquery name="GET_LAST_REC" datasource="#DSN#">
            SELECT
                MAX(HISTORY_ID) AS HIS_ID
            FROM
                PRO_WORKS_HISTORY
            WHERE
                WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.work_id#">
        </cfquery>
        <cfreturn GET_LAST_REC>
    </cffunction>

    <cffunction name="GET_HIST_DETAIL">
        <cfargument name="hist_id" required="yes">

        <cfquery name="GET_HIST_DETAIL" datasource="#DSN#">
            SELECT
                PRO_WORKS_HISTORY.WORK_PRIORITY_ID
            FROM
                PRO_WORKS_HISTORY,
                SETUP_PRIORITY
            WHERE
                PRO_WORKS_HISTORY.WORK_PRIORITY_ID = SETUP_PRIORITY.PRIORITY_ID AND
                PRO_WORKS_HISTORY.HISTORY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.hist_id#">
        </cfquery>
        <cfreturn GET_HIST_DETAIL>
    </cffunction>
    <!--- End: V16\objects2\project\query\get_work.cfm --->

    <!--- Begin: V16\objects2\project\query\get_work_history.cfm --->
    <cffunction name="GET_WORK_HISTORY">
        <cfargument name="work_id" required="yes">

        <cfquery name="GET_WORK_HISTORY" datasource="#DSN#">
            SELECT
                PRO_WORKS_HISTORY.*,
                PRO_WORK_CAT.WORK_CAT,
                SETUP_PRIORITY.*,		
                PRO_WORKS.WORK_HEAD
            FROM
                PRO_WORKS_HISTORY,
                PRO_WORK_CAT,
                SETUP_PRIORITY,	
                PRO_WORKS
            WHERE
                PRO_WORK_CAT.WORK_CAT_ID = PRO_WORKS_HISTORY.WORK_CAT_ID AND
                PRO_WORKS_HISTORY.WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.work_id#"> AND
                PRO_WORKS_HISTORY.WORK_PRIORITY_ID=SETUP_PRIORITY.PRIORITY_ID AND
                PRO_WORKS.WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.work_id#">
            ORDER BY
                PRO_WORKS_HISTORY.HISTORY_ID DESC
        </cfquery>
        <cfreturn GET_WORK_HISTORY>
    </cffunction>
    <!--- End: V16\objects2\project\query\get_work_history.cfm --->

    <!--- Begin: V16\objects2\project\display\work_relation_asset.cfm --->
    <cffunction name="GET_WORK_ASSET">
        <cfargument name="work_id" required="yes">

        <cfquery name="GET_WORK_ASSET" datasource="#DSN#">
            SELECT
                A.ASSET_FILE_NAME,
                A.MODULE_NAME,
                A.ASSET_ID,
                A.ASSETCAT_ID,
                A.ASSET_NAME,
                A.RECORD_EMP,
                A.IMAGE_SIZE,
                A.ASSET_FILE_SERVER_ID,
                ASSET_CAT.ASSETCAT,
                ASSET_CAT.ASSETCAT_PATH,
                CP.NAME,
                A.RECORD_PAR
            FROM
                ASSET A,
                CONTENT_PROPERTY CP,
                ASSET_CAT
            WHERE
                A.ASSETCAT_ID = ASSET_CAT.ASSETCAT_ID AND
                A.ACTION_SECTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="WORK_ID"> AND
                A.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.work_id#"> AND
                A.PROPERTY_ID = CP.CONTENT_PROPERTY_ID
                AND A.IS_SPECIAL = 0
                AND A.IS_INTERNET = 1
            ORDER BY 
                A.RECORD_DATE DESC 
        </cfquery>
        <cfreturn GET_WORK_ASSET>
    </cffunction>
    <!--- End: V16\objects2\project\display\work_relation_asset.cfm --->

    <!--- Begin: V16\objects2\project\display\list_stock_receipts.cfm --->
    <cffunction name="GET_STOCK_FIS">
        <cfargument name="work_id" required="yes">

        <cfquery name="GET_STOCK_FIS" datasource="#DSN2#">
            SELECT WORK_ID,FIS_ID,FIS_NUMBER FROM STOCK_FIS WHERE WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.work_id#">
        </cfquery>
        <cfreturn GET_STOCK_FIS>
    </cffunction>
    <!--- End: V16\objects2\project\display\list_stock_receipts.cfm --->

    <!--- Begin: V16\objects2\project\display\pro_works_list.cfm --->
    <cffunction name="GET_PRO_WORK">
        <cfargument name="priority_cat" required="yes">
        <cfargument name="currency" required="yes">
        <cfargument name="keyword_" default="">
        <cfargument name="work_status" required="yes">
        <cfargument name="work_milestones" required="yes">
        <cfargument name="project_id">
        <cfargument name="service_id">
        <cfargument name="subscription_id">

        <cfquery name="GET_PRO_WORK" datasource="#DSN#">
            SELECT
                WORK_ID,
                TYPE,
                MILESTONE_WORK_ID,
                COLOR,
                WORK_HEAD,
                PROJECT_ID,
                EMPLOYEE,
                WORK_PRIORITY_ID,
                PRIORITY,
                STAGE,
                TO_COMPLETE,
                TARGET_FINISH,
                TARGET_START
            FROM
            (
                SELECT
                    CASE 
                        WHEN IS_MILESTONE = 1 THEN WORK_ID
                        WHEN IS_MILESTONE <> 1 THEN ISNULL(MILESTONE_WORK_ID,0)
                    END AS NEW_WORK_ID,
                    CASE 
                        WHEN IS_MILESTONE = 1 THEN 0
                        WHEN IS_MILESTONE <> 1 THEN 1
                    END AS TYPE,
                    PW.IS_MILESTONE,
                    PW.MILESTONE_WORK_ID,
                    PW.WORK_ID,
                    PW.WORK_HEAD,
                    PW.PROJECT_ID,
                    PW.ESTIMATED_TIME,
                    (SELECT PTR.STAGE FROM PROCESS_TYPE_ROWS PTR WHERE PTR.PROCESS_ROW_ID= PW.WORK_CURRENCY_ID) STAGE,
                    PW.WORK_PRIORITY_ID,
                    CASE 
                        WHEN PW.PROJECT_EMP_ID IS NOT NULL THEN (SELECT E.EMPLOYEE_NAME +' '+ E.EMPLOYEE_SURNAME FROM EMPLOYEES E WHERE E.EMPLOYEE_ID = PW.PROJECT_EMP_ID)
                        WHEN PW.OUTSRC_PARTNER_ID IS NOT NULL THEN (SELECT C2.NICKNAME+' - '+ CP2.COMPANY_PARTNER_NAME + ' ' + CP2.COMPANY_PARTNER_SURNAME NAME FROM COMPANY_PARTNER CP2,COMPANY C2 WHERE C2.COMPANY_ID = CP2.COMPANY_ID AND CP2.PARTNER_ID = PW.OUTSRC_PARTNER_ID)
                    END AS EMPLOYEE,
                    PW.TARGET_FINISH,
                    PW.TARGET_START,
                    PW.REAL_FINISH,
                    PW.REAL_START,
                    PW.TO_COMPLETE,
                    PW.UPDATE_DATE,
                    PW.RECORD_DATE,
                    SP.PRIORITY,
                    SP.COLOR,
                    (SELECT PRO_MATERIAL.PRO_MATERIAL_ID FROM PRO_MATERIAL WHERE PRO_MATERIAL.WORK_ID = PW.WORK_ID) PRO_MATERIAL_ID
                FROM
                    PRO_WORKS PW,
                    SETUP_PRIORITY SP
                WHERE
                    PW.WORK_PRIORITY_ID = SP.PRIORITY_ID
                    <cfif isDefined('arguments.project_id') and len(arguments.project_id)>
                        AND PW.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">
                    </cfif>
                    <cfif len(arguments.keyword_)>
                        AND 
                        (
                            <cfif isNumeric(arguments.keyword_)>
                                PW.WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.keyword_#"> OR 
                            </cfif>
                            PW.WORK_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword_#%">
                        )
                    </cfif>
                    <cfif len(arguments.priority_cat)>
                        AND PW.WORK_PRIORITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.priority_cat#">
                    </cfif>
                    <cfif len(arguments.currency)>
                        AND PW.WORK_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.currency#">
                    </cfif>
                    <cfif isDefined('arguments.service_id') and len(arguments.service_id)>
                        AND PW.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_id#">
                    </cfif>
                    <cfif isDefined('arguments.subscription_id') and len(arguments.subscription_id)>
                        AND PW.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.subscription_id#">
                    </cfif>
                    <cfif arguments.work_status eq -1>
                        AND PW.WORK_STATUS = 0
                    <cfelseif arguments.work_status eq 1>
                        AND PW.WORK_STATUS = 1
                    </cfif>
            )T1
            WHERE
                1=1 
                <cfif arguments.work_milestones eq 0>
                    AND IS_MILESTONE <> 1
                </cfif>
            ORDER BY
                <cfif isdefined("arguments.ordertype") and arguments.ordertype eq 2>
                    ISNULL(UPDATE_DATE,RECORD_DATE) DESC
                <cfelseif isdefined("arguments.ordertype") and arguments.ordertype eq 3>
                    TARGET_START DESC
                <cfelseif isdefined("arguments.ordertype") and arguments.ordertype eq 4>
                    TARGET_START
                <cfelseif isdefined("arguments.ordertype") and arguments.ordertype eq 5>
                    TARGET_FINISH DESC
                <cfelseif isdefined("arguments.ordertype") and arguments.ordertype eq 6>
                    TARGET_FINISH
                <cfelseif isdefined("arguments.ordertype") and arguments.ordertype eq 7>
                    WORK_HEAD
                <cfelse>
                    WORK_ID DESC
                </cfif>
        </cfquery>
        <cfreturn GET_PRO_WORK>
    </cffunction>

    <cffunction name="GET_HARCANAN_ZAMAN">
        <cfargument name="work_h_list" required="yes">

        <cfquery name="GET_HARCANAN_ZAMAN" datasource="#DSN#">
            SELECT
                SUM((ISNULL(TOTAL_TIME_HOUR,0)*60) + ISNULL(TOTAL_TIME_MINUTE,0)) AS HARCANAN_DAKIKA,
                WORK_ID
            FROM
                PRO_WORKS_HISTORY
            WHERE
                WORK_ID IN (#arguments.work_h_list#)
            GROUP BY
                WORK_ID
        </cfquery>
        <cfreturn GET_HARCANAN_ZAMAN>
    </cffunction>

    <cffunction name="GET_PROCURRENCY3">
        <cfargument name="my_our_comp_" required="yes">

        <cfquery name="GET_PROCURRENCY" datasource="#DSN#">
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
                PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.my_our_comp_#"> AND
                PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%project.works%">
            ORDER BY
                PTR.LINE_NUMBER
        </cfquery>
    </cffunction>
    <!--- End: V16\objects2\project\display\pro_works_list.cfm --->

    <!--- Begin: V16\objects2\project\query\add_mail.cfm --->
    <cffunction name="GET_EMPS1">
        <cfargument name="id" required="yes">

        <cfquery name="GET_EMPS1" datasource="#DSN#">
            SELECT
                EMPLOYEE_POSITIONS.EMPLOYEE_ID,PRO_PROJECTS.PROJECT_HEAD
            FROM
                PRO_PROJECTS,
                EMPLOYEE_POSITIONS
            WHERE
                PRO_PROJECTS.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#"> AND
                EMPLOYEE_POSITIONS.EMPLOYEE_ID = PRO_PROJECTS.PROJECT_EMP_ID AND
                EMPLOYEE_POSITIONS.POSITION_STATUS = 1 
        </cfquery>
        <cfreturn GET_EMPS1>
    </cffunction>

    <cffunction name="GET_EMPS2">
        <cfargument name="id" required="yes">

        <cfquery name="GET_EMPS2" datasource="#DSN#">
            SELECT	
                DISTINCT EMPLOYEE_POSITIONS.EMPLOYEE_ID,
                WORKGROUP_EMP_PAR.POSITION_CODE
            FROM
                WORK_GROUP,
                WORKGROUP_EMP_PAR,
                EMPLOYEE_POSITIONS
            WHERE
                WORK_GROUP.WORKGROUP_ID = WORKGROUP_EMP_PAR.WORKGROUP_ID AND
                WORK_GROUP.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#"> AND
                EMPLOYEE_POSITIONS.EMPLOYEE_ID = WORKGROUP_EMP_PAR.EMPLOYEE_ID AND
                EMPLOYEE_POSITIONS.IS_MASTER = 1 AND
                WORKGROUP_EMP_PAR.EMPLOYEE_ID IS NOT NULL
        </cfquery>
        <cfreturn GET_EMPS2>
    </cffunction>

    <cffunction name="GET_PARS1">
        <cfargument name="id" required="yes">

        <cfquery name="GET_PARS1" datasource="#DSN#">
            SELECT
                DISTINCT COMPANY_PARTNER.PARTNER_ID
            FROM
                PRO_PROJECTS,
                COMPANY_PARTNER
            WHERE
                PRO_PROJECTS.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#"> AND
                COMPANY_PARTNER.PARTNER_ID = PRO_PROJECTS.OUTSRC_PARTNER_ID AND
                COMPANY_PARTNER.PARTNER_ID IS NOT NULL
        </cfquery>
        <cfreturn GET_PARS1>
    </cffunction>

    <cffunction name="GET_PARS2">
        <cfargument name="id" required="yes">

        <cfquery name="GET_PARS2" datasource="#DSN#">
            SELECT
                WORKGROUP_EMP_PAR.PARTNER_ID
            FROM
                WORKGROUP_EMP_PAR,
                WORK_GROUP
            WHERE
                WORK_GROUP.WORKGROUP_ID = WORKGROUP_EMP_PAR.WORKGROUP_ID AND
                WORK_GROUP.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#"> AND
                WORKGROUP_EMP_PAR.PARTNER_ID IS NOT NULL
        </cfquery>
        <cfreturn GET_PARS2>
    </cffunction>

    <cffunction name="GET_SENDER">
        <cfquery name="GET_SENDER" datasource="#DSN#">
            SELECT 
                COMPANY_PARTNER_EMAIL,
                COMPANY_PARTNER_NAME,
                COMPANY_PARTNER_SURNAME
            FROM
                COMPANY_PARTNER
            WHERE
                PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
        </cfquery>
        <cfreturn GET_SENDER>
    </cffunction>

    <cffunction name="GET_EMP_MAIL">
        <cfargument name="id" required="yes">

        <cfquery name="GET_EMP_MAIL" datasource="#DSN#">
            SELECT 
                EMPLOYEE_EMAIL
            FROM
                EMPLOYEES
            WHERE
                EMPLOYEE_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
        </cfquery>
        <cfreturn GET_EMP_MAIL>
    </cffunction>

    <cffunction name="GET_PAR_MAIL">
        <cfargument name="id" required="yes">

        <cfquery name="GET_PAR_MAIL" datasource="#DSN#">
            SELECT 
                COMPANY_PARTNER_EMAIL
            FROM
                COMPANY_PARTNER
            WHERE
                PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
        </cfquery>
        <cfreturn GET_PAR_MAIL>
    </cffunction>
    <!--- End: V16\objects2\project\query\add_mail.cfm --->

    <!--- Begin: V16\objects\display\view_company_logo.cfm --->
    <cffunction name="CHECK">
        <cfargument name="our_company_id">

        <cfquery name="CHECK" datasource="#DSN#">
            SELECT 
                ASSET_FILE_NAME2,
                ASSET_FILE_NAME2_SERVER_ID
            FROM 
                OUR_COMPANY 
            WHERE 
                <cfif isdefined("arguments.our_company_id")>
                    COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.our_company_id#">
                <cfelse>
                    <cfif isDefined("session.ep.company_id") and len(session.ep.company_id)>
                        COMP_ID = #session.ep.company_id#
                    <cfelseif isDefined("session.pp.company_id") and len(session.pp.company_id)>	
                        COMP_ID = #session.pp.company_id#
                    <cfelseif isDefined("session.ww.our_company_id")>
                        COMP_ID = #session.ww.our_company_id#
                    <cfelseif isDefined("session.cp.our_company_id")>
                        COMP_ID = #session.cp.our_company_id#
                    </cfif> 
                </cfif> 
        </cfquery>
        <cfreturn CHECK>
    </cffunction>
    <!--- End: V16\objects\display\view_company_logo.cfm --->

    <!--- Begin: V16\settings\query\get_template_dimension.cfm --->
    <cffunction name="GET_TEMPLATE_DIMENSION">
        <cfargument name="type">

        <cfquery name="GET_TEMPLATE_DIMENSION" datasource="#DSN#">
            SELECT
                 *
            FROM
                 SETUP_TEMPLATE_DIMENSION
            <cfif isDefined("arguments.type")>
                WHERE
                     TEMPLATE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.type#">
            </cfif>	 
        </cfquery>
        <cfreturn GET_TEMPLATE_DIMENSION>
    </cffunction>
    <!--- End: V16\settings\query\get_template_dimension.cfm --->

    <!--- Begin: V16\objects\display\view_company_info.cfm --->
    <cffunction name="GET_OUR_COMPANY_INFO">
        <cfquery name="GET_OUR_COMPANY_INFO" datasource="#DSN#">
            SELECT LOGO_TYPE FROM OUR_COMPANY_INFO WHERE COMP_ID = 
                    <cfif isDefined("session.ep.company_id")>
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                    <cfelseif isDefined("session.pp.our_company_id")>	
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">
                    <cfelseif isDefined("session.ww.our_company_id")>
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">
                    <cfelseif isDefined("session.cp.our_company_id")>
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.our_company_id#">
                    </cfif>    
        </cfquery>
        <cfreturn GET_OUR_COMPANY_INFO>
    </cffunction>

    <cffunction name="VIEW_INFO">
        <cfquery name="VIEW_INFO" datasource="#DSN#">
            SELECT
                BRANCH_FULLNAME NAME_,
                BRANCH_TELCODE TELCODE_,
                BRANCH_TEL1 TEL1_,
                BRANCH_TEL2 TEL2_,
                BRANCH_TEL3 TEL3_,
                BRANCH_FAX FAX_,
                BRANCH_ADDRESS ADDRESS_,
                BRANCH_EMAIL EMAIL_,
                '' WEB_,
                '' TAX_NO
            FROM
                BRANCH
            WHERE 
                <cfif isDefined("session.ep.user_location")>
                    BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">
                <cfelseif isDefined("session.ep.company_id")>
                    COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                <cfelseif isDefined("session.pp.our_company_id")>	
                    COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">
                <cfelseif isDefined("session.ww.our_company_id")>
                    COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">
                <cfelseif isDefined("session.cp.our_company_id")>
                    COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.our_company_id#">
                </cfif>
        </cfquery>
        <cfreturn VIEW_INFO>
    </cffunction>

    <cffunction name="VIEW_INFO2">
        <cfargument name="our_company_id">

        <cfquery name="VIEW_INFO" datasource="#DSN#">
            SELECT
                COMPANY_NAME NAME_,
                TEL_CODE TELCODE_,
                TEL TEL1_,
                TEL2 TEL2_,
                TEL3 TEL3_,
                FAX FAX_,
                ADDRESS ADDRESS_,
                EMAIL EMAIL_,
                WEB WEB_
            FROM
                OUR_COMPANY
            WHERE 
            <cfif isdefined("arguments.our_company_id")>
                COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.our_company_id#">
            <cfelse>
                <cfif isDefined("session.ep.company_id")>
                    COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                <cfelseif isDefined("session.pp.our_company_id")>	
                    COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">
                <cfelseif isDefined("session.ww.our_company_id")>
                    COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">
                <cfelseif isDefined("session.cp.our_company_id")>
                    COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.our_company_id#">
                </cfif>
            </cfif> 
        </cfquery>
        <cfreturn VIEW_INFO>
    </cffunction>
    <!--- End: V16\objects\display\view_company_info.cfm --->

    <!--- Begin: V16\objects2\project\query\add_prowork.cfm --->
    <cffunction name="GET_REL_WORK_PRO">
        <cfargument name="rel_work_id" required="yes">

        <cfquery name="GET_REL_WORK_PRO" datasource="#DSN#">
            SELECT
                TARGET_START
            FROM
                PRO_WORKS
            WHERE	
                WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.rel_work_id#">
        </cfquery>
        <cfreturn GET_REL_WORK_PRO>
    </cffunction>

    <cffunction name="ADD_WORK">
        <cfargument name="estimated_time">
        <cfargument name="expected_budget">
        <cfargument name="expected_budget_money">
        <cfargument name="pro_work_cat" required="yes">
        <cfargument name="project_id" required="yes">
        <cfargument name="company_id" required="yes">
        <cfargument name="partner_id" required="yes">
        <cfargument name="rel_work_id">
        <cfargument name="task_" required="yes">
        <cfargument name="type" required="yes">
        <cfargument name="work_head" required="yes">
        <cfargument name="work_detail" required="yes">
        <cfargument name="work_h_start" required="yes">
        <cfargument name="work_h_finish" required="yes">
        <cfargument name="process_stage" required="yes">
        <cfargument name="priority_cat" required="yes">

        <cfquery name="ADD_WORK" datasource="#DSN#">
            INSERT INTO 
                PRO_WORKS 
                (
                    WORK_CAT_ID,
                    PROJECT_ID,
                    COMPANY_ID,
                    COMPANY_PARTNER_ID,						
                    RELATED_WORK_ID,
                    <cfif isdefined("arguments.estimated_time") and len(arguments.estimated_time)>
                        ESTIMATED_TIME,
                    </cfif>
                    <cfif isdefined("arguments.expected_budget") and len(arguments.expected_budget)>
                        EXPECTED_BUDGET,
                    </cfif>
                    <cfif isdefined("arguments.expected_budget_money") and len(arguments.expected_budget_money)>
                        EXPECTED_BUDGET_MONEY,
                    </cfif>
                    PROJECT_EMP_ID,							
                    OUTSRC_CMP_ID,
                    OUTSRC_PARTNER_ID,
                    WORK_HEAD,
                    WORK_DETAIL,
                    TARGET_START,
                    TARGET_FINISH,
                    RECORD_PAR,
                    WORK_CURRENCY_ID,
                    WORK_PRIORITY_ID,
                    RECORD_DATE,
                    RECORD_IP,
                    WORK_STATUS
                )
            VALUES 
                (
                    #arguments.pro_work_cat#,
                    #arguments.project_id#,
                    #arguments.company_id#,
                    #arguments.partner_id#,
                    <cfif isdefined("arguments.rel_work_id") and len(arguments.rel_work_id)>
                        #arguments.rel_work_id#,
                    <cfelse>
                        NULL,
                    </cfif>
                    <cfif isdefined("arguments.estimated_time") and len(arguments.estimated_time)>
                        #arguments.estimated_time#,
                    </cfif>
                    <cfif isdefined("arguments.expected_budget") and len(arguments.expected_budget)>
                        #arguments.expected_budget#,
                    </cfif>
                    <cfif isdefined("arguments.expected_budget_money") and len(arguments.expected_budget_money)>
                        '#arguments.expected_budget_money#',
                    </cfif>								
                    <cfif arguments.type eq '1'>
                        #listgetat(arguments.task_,3,',')#,
                    <cfelse>
                        NULL,
                    </cfif>
                    <cfif arguments.type eq '2' or arguments.type eq '3'>
                        #listgetat(arguments.task_,2,',')#,
                        #listgetat(arguments.task_,3,',')#,
                    <cfelse>
                        NULL,
                        NULL,
                    </cfif>
                    '#arguments.work_head#',
                    '#arguments.work_detail#',
                    #arguments.work_h_start#,
                    #arguments.work_h_finish#,
                    #session.pp.userid#,
                    #arguments.process_stage#,
                    #arguments.priority_cat#,
                    #NOW()#,
                    '#CGI.REMOTE_ADDR#',
                    1
                    )
        </cfquery>
        <cfreturn ADD_WORK>
    </cffunction>

    <cffunction name="GET_LAST_WORK">
        <cfquery name="GET_LAST_WORK" datasource="#DSN#">
            SELECT MAX(WORK_ID) AS WORK_ID FROM PRO_WORKS
        </cfquery>
        <cfreturn GET_LAST_WORK>
    </cffunction>

    <cffunction name="ADD_RELATION">
        <cfargument name="WORK_ID" required="yes">
        <cfargument name="REL_WORK_ID" required="yes">

        <cfquery name="ADD_RELATION" datasource="#DSN#">
            INSERT INTO
                PRO_WORK_RELATIONS
                (
                    WORK_ID,
                    PRE_ID
                )
            VALUES
                (
                    #arguments.WORK_ID#,
                    #arguments.REL_WORK_ID#
                )
        </cfquery>
        <cfreturn ADD_RELATION>
    </cffunction>

    <cffunction name="GET_EMAIL_ADDRESS">
        <cfargument name="task_" required="yes">

        <cfquery name="GET_EMAIL_ADDRESS" datasource="#DSN#">
            SELECT EMPLOYEE_ID, EMPLOYEE_NAME AS NAME, EMPLOYEE_SURNAME AS SURNAME, EMPLOYEE_EMAIL AS EMAIL_ADDRESS FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(arguments.task_,3,',')#">
        </cfquery>
        <cfreturn GET_EMAIL_ADDRESS>
    </cffunction>

    <!--- Aynı isim, sonuna 2 eklendi --->
    <cffunction name="GET_EMAIL_ADDRESS2">
        <cfargument name="task_" required="yes">

        <cfquery name="GET_EMAIL_ADDRESS" datasource="#DSN#">
            SELECT PARTNER_ID, COMPANY_PARTNER_EMAIL AS EMAIL_ADDRESS, COMPANY_PARTNER_NAME AS NAME, COMPANY_PARTNER_SURNAME AS SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.task_,3,',')#">
        </cfquery>
        <cfreturn GET_EMAIL_ADDRESS>
    </cffunction>

    <cffunction name="ADD_WORK_HISTORY">
        <cfargument name="pro_work_cat" required="yes">
        <cfargument name="work_id" required="yes">
        <cfargument name="company_id" required="yes">
        <cfargument name="partner_id" required="yes">
        <cfargument name="project_id" required="yes">
        <cfargument name="work_head" required="yes">
        <cfargument name="work_detail" required="yes">
        <cfargument name="rel_work_id" default="">
        <cfargument name="task_" required="yes">
        <cfargument name="type" required="yes">
        <cfargument name="work_h_start" required="yes">
        <cfargument name="work_h_finish" required="yes">
        <cfargument name="process_stage" required="yes">
        <cfargument name="priority_cat" required="yes">

        <cfquery name="ADD_WORK_HISTORY" datasource="#DSN#">
            INSERT INTO
                PRO_WORKS_HISTORY
                (
                    WORK_CAT_ID,
                    WORK_ID,
                    COMPANY_ID,
                    COMPANY_PARTNER_ID,
                    PROJECT_ID,
                    WORK_HEAD,
                    WORK_DETAIL,
                    RELATED_WORK_ID,
                    PROJECT_EMP_ID,							
                    OUTSRC_CMP_ID,
                    OUTSRC_PARTNER_ID,
                    TARGET_START,
                    TARGET_FINISH,
                    WORK_CURRENCY_ID,
                    WORK_PRIORITY_ID,
                    UPDATE_DATE,
                    UPDATE_PAR
                )
                VALUES
                (
                    #arguments.pro_work_cat#,
                    #arguments.work_id#,
                    #arguments.company_id#,
                    #arguments.partner_id#,
                    #arguments.project_id#,
                    '#arguments.work_head#',
                    '#arguments.work_detail#',
                    <cfif len(arguments.rel_work_id)>#arguments.rel_work_id#,<cfelse>NULL,</cfif>
                    <cfif arguments.type eq '1'>#listgetat(arguments.task_,3,',')#<cfelse>NULL</cfif>,
                    <cfif arguments.type eq '2' or arguments.type eq '3'>
                        #listgetat(arguments.task_,2,',')#,
                        #listgetat(arguments.task_,3,',')#,
                    <cfelse>
                        NULL,
                        NULL,
                    </cfif>
                    #arguments.work_h_start#,
                    #arguments.work_h_finish#,
                    #arguments.process_stage#,
                    #arguments.priority_cat#,
                    #now()#,
                    #session.pp.userid#
                )
        </cfquery>
        <cfreturn ADD_WORK_HISTORY>
    </cffunction>
    <!--- End: V16\objects2\project\query\add_prowork.cfm --->

    <!--- Begin: V16\objects2\project\query\del_work.cfm --->
    <cffunction name="WORK_SIL">
        <cfargument name="id" required="yes">

        <cfquery name="WORK_SIL" datasource="#dsn#">
            DELETE 
            FROM 
                PRO_WORKS 
            WHERE 
                WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
        </cfquery>
        <cfreturn WORK_SIL>
    </cffunction>

    <cffunction name="WORK_HIST_SIL">
        <cfargument name="id" required="yes">

        <cfquery name="WORK_HIST_SIL" datasource="#dsn#">
            DELETE
            FROM 
                PRO_WORKS_HISTORY 
            WHERE 
                WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
        </cfquery>
        <cfreturn WORK_HIST_SIL>
    </cffunction>

    <cffunction name="REL_WORK_SIL">
        <cfargument name="id" required="yes">

        <cfquery name="REL_WORK_SIL" datasource="#dsn#">
            UPDATE
                PRO_WORKS 
            SET
                RELATED_WORK_ID=0
            WHERE 
                RELATED_WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
        </cfquery>
        <cfreturn REL_WORK_SIL>
    </cffunction>

    <cffunction name="delete_relations">
        <cfargument name="id" required="yes">

        <cfquery name="delete_relations" datasource="#dsn#">
            DELETE FROM
                PRO_WORK_RELATIONS
            WHERE
                WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
                OR
                PRE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
        </cfquery>
        <cfreturn delete_relations>
    </cffunction>
    <!--- End: V16\objects2\project\query\del_work.cfm --->

    
    <!--- Begin: V16\objects2\project\query\upd_work.cfm --->
    <cffunction name="GET_PROJECT3">
        <cfargument name="project_id" required="yes">

        <cfquery name="GET_PROJECT" datasource="#DSN#">
            SELECT
                COMPANY_ID,
                PARTNER_ID,
                TARGET_START,
                TARGET_FINISH
            FROM
                PRO_PROJECTS
            WHERE
                PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">
        </cfquery>
        <cfreturn GET_PROJECT>
    </cffunction>

    <cffunction name="GET_PROBLEM_RELATED_WORKS">
        <cfargument name="work_id" required="yes">
        <cfargument name="work_h_start" required="yes">

        <cfquery name="GET_PROBLEM_RELATED_WORKS" datasource="#DSN#">
			SELECT
				PRO_WORK_RELATIONS.WORK_ID
			FROM
				PRO_WORK_RELATIONS,
				PRO_WORKS PRE,
				PRO_WORKS ORIGINAL
			WHERE
				PRE.WORK_ID = PRO_WORK_RELATIONS.PRE_ID AND
				ORIGINAL.WORK_ID = PRO_WORK_RELATIONS.WORK_ID AND
				PRE.TARGET_START > <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.work_h_start#"> AND
				PRO_WORK_RELATIONS.WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.work_id#">
        </cfquery>
        <cfreturn GET_PROBLEM_RELATED_WORKS>
    </cffunction>

    <cffunction name="GET_WORK_DETAIL">
        <cfargument name="work_id" required="yes">

        <cfquery name="GET_WORK_DETAIL" datasource="#DSN#">
            SELECT
                PROJECT_ID
            FROM
                PRO_WORKS
            WHERE
                WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.work_id#">
        </cfquery>
        <cfreturn GET_WORK_DETAIL>
    </cffunction>

    <cffunction name="DEL_RELATED_WORKS">
        <cfargument name="work_id" required="yes">

        <cfquery name="DEL_RELATED_WORKS" datasource="#DSN#">
            DELETE FROM
                PRO_WORK_RELATIONS
            WHERE
                WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.work_id#">
        </cfquery>
        <cfreturn DEL_RELATED_WORKS>
    </cffunction>

    <cffunction name="ADD_PRO_WORK_RELATIONS">
        <cfargument name="work_id" required="yes">
        <cfargument name="pre_id" required="yes">
        <cfargument name="related_work_type">
        <cfargument name="related_work_lag">

        <cfquery name="ADD_PRO_WORK_RELATIONS" datasource="#DSN#">
            INSERT INTO
                PRO_WORK_RELATIONS
                (
                    WORK_ID,
                    PRE_ID,
                    RELATION_TYPE,
                    LAG
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.work_id#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pre_id#">,
                    <cfif isDefined("arguments.related_work_type")>
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.related_work_type#">
                    <cfelse>
                        NULL
                    </cfif>,
                    <cfif isDefined("arguments.related_work_lag")>
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.related_work_lag#">
                    <cfelse>
                        NULL
                    </cfif>
                 )
        </cfquery>
        <cfreturn ADD_PRO_WORK_RELATIONS>
    </cffunction>

    <cffunction name="ADD_WORK_HISTORY2">
        <cfargument name="pro_work_cat">
        <cfargument name="priority_cat">
        <cfargument name="work_id" required="yes">
        <cfargument name="work_head" required="yes">
        <cfargument name="work_detail" required="yes">
        <cfargument name="rel_work">
        <cfargument name="project_id" required="yes">
        <cfargument name="work_h_start">
        <cfargument name="work_h_finish">
        <cfargument name="process_stage" required="yes">
        <cfargument name="type" required="yes">
        <cfargument name="task_" required="yes">

        <cfquery name="ADD_WORK_HISTORY" datasource="#DSN#">
            INSERT INTO
                PRO_WORKS_HISTORY
                    (
                        <cfif isDefined('arguments.pro_work_cat')>WORK_CAT_ID,</cfif>
                        WORK_ID,
                        WORK_HEAD,
                        WORK_DETAIL,
                        RELATED_WORK_ID,
                        PROJECT_ID,
                        REAL_START,
                        REAL_FINISH,
                        WORK_CURRENCY_ID,
                        <cfif isDefined('arguments.priority_cat')>WORK_PRIORITY_ID,</cfif>
                        PROJECT_EMP_ID,							
                        OUTSRC_CMP_ID,
                        OUTSRC_PARTNER_ID,
                        UPDATE_DATE,
                        UPDATE_PAR				
                    )
                VALUES
                    (
                        <cfif isDefined('arguments.pro_work_cat')>#arguments.pro_work_cat#,</cfif>
                        #arguments.work_id#,
                        '#arguments.work_head#',
                        '#arguments.work_detail#',
                        <cfif isdefined('arguments.rel_work') and len(arguments.rel_work)>'#arguments.rel_work#',<cfelse>NULL,</cfif>
                        <cfif isdefined('arguments.project_id')>#arguments.project_id#<cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.work_h_start') and len(arguments.work_h_start)>#arguments.work_h_start#<cfelse>NULL</cfif>,
                        <cfif isDefined('arguments.work_h_finish') and len(arguments.work_h_finish)>#arguments.work_h_finish#<cfelse>NULL</cfif>,
                        #arguments.process_stage#,
                        <cfif isDefined('arguments.priority_cat')>#arguments.priority_cat#,</cfif>
                        <cfif arguments.type eq 1>
                            #listgetat(arguments.task_,3,',')#,
                        <cfelse>
                            NULL,
                        </cfif>
                        <cfif arguments.type eq '2' or arguments.type eq '3'>
                            #listgetat(arguments.task_,2,',')#,
                            #listgetat(arguments.task_,3,',')#,
                        <cfelse>
                            NULL,
                            NULL,
                        </cfif>
                        #now()#,
                        #session.pp.userid#
                    )
        </cfquery>
        <cfreturn ADD_WORK_HISTORY>
    </cffunction>

    <cffunction name="UPD_WORK2">
        <cfargument name="pro_work_cat">
        <cfargument name="rel_work">
        <cfargument name="work_status">
        <cfargument name="project_id">
        <cfargument name="work_head" required="yes">
        <cfargument name="work_detail" required="yes">
        <cfargument name="work_h_start">
        <cfargument name="work_h_finish">
        <cfargument name="process_stage" required="yes">
        <cfargument name="priority_cat">
        <cfargument name="task_" required="yes">
        <cfargument name="type" required="yes">
        <cfargument name="work_id" required="yes">

        <cfquery name="UPD_WORK" datasource="#DSN#">
            UPDATE 
                 PRO_WORKS 
             SET 
                 <cfif isDefined('arguments.pro_work_cat')>WORK_CAT_ID = #arguments.pro_work_cat#,</cfif>
                 <cfif isDefined("arguments.rel_work") and len(arguments.rel_work)>
                     RELATED_WORK_ID = '#arguments.rel_work#',
                 <cfelse>
                     RELATED_WORK_ID = NULL,
                 </cfif>
                 <cfif isdefined("arguments.work_status")>
                     WORK_STATUS=1,
                 <cfelse>
                     WORK_STATUS=0,
                 </cfif>
                 PROJECT_ID = <cfif isdefined("arguments.project_id") and len(arguments.project_id)>#arguments.project_id#<cfelse>NULL</cfif>,
                 WORK_HEAD='#arguments.work_head#',
                 WORK_DETAIL='#arguments.work_detail#',
                 REAL_START = <cfif isDefined('arguments.work_h_start') and len(arguments.work_h_start)>#arguments.work_h_start#<cfelse>NULL</cfif>,
                 REAL_FINISH = <cfif isDefined('arguments.work_h_finish') and len(arguments.work_h_finish)>#arguments.work_h_finish#<cfelse>NULL</cfif>,
                 WORK_CURRENCY_ID=#arguments.process_stage#,
                 <cfif isDefined('arguments.priority_cat')>WORK_PRIORITY_ID=#arguments.priority_cat#,</cfif>
                 <cfif arguments.type eq 1>
                     PROJECT_EMP_ID = #listgetat(arguments.task_,3,',')#,
                 <cfelse>
                     PROJECT_EMP_ID = NULL,
                 </cfif>					
                 <cfif arguments.type eq '2' or arguments.type eq '3'>
                     OUTSRC_CMP_ID = #listgetat(arguments.task_,2,',')#,
                     OUTSRC_PARTNER_ID = #listgetat(arguments.task_,3,',')#,
                 <cfelse>
                     OUTSRC_CMP_ID = NULL,
                     OUTSRC_PARTNER_ID = NULL,
                 </cfif>
                 UPDATE_PAR=#session.pp.userid#,
                 UPDATE_DATE=#now()#,
                 UPDATE_IP='#CGI.REMOTE_ADDR#'
             WHERE 
                 PRO_WORKS.WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.work_id#">
         </cfquery>
         <cfreturn UPD_WORK>
    </cffunction>

    <cffunction name="getDate">
        <cfargument name="work_id" required="yes">

        <cfquery name="getDate" datasource="#DSN#">
            SELECT TARGET_START,TARGET_FINISH FROM PRO_WORKS WHERE WORK_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.work_id#">
        </cfquery>
        <cfreturn getDate>
    </cffunction>

    <cffunction name="get_relDate">
        <cfargument name="work_id" required="yes">

        <cfquery name="get_relDate" datasource="#DSN#">
            SELECT TARGET_START,TARGET_FINISH,DATEDIFF("D",TARGET_START,TARGET_FINISH)AS FARK FROM PRO_WORKS WHERE WORK_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.work_id#">
        </cfquery>
        <cfreturn get_relDate>
    </cffunction>

    <cffunction name="setDate">
        <cfargument name="related_work_type" required="yes">
        <cfargument name="work_id" required="yes">
        <cfargument name="tfinish_date" default="">
        <cfargument name="tfinishend_date" default="">
        <cfargument name="tstartminus_date" default="">
        <cfargument name="tstart_date" default="">
        <cfargument name="tstartend_date" default="">
        <cfargument name="tfinishminus_date" default="">

        <cfquery name="setDate" datasource="#DSN#">
            <cfif arguments.related_work_type eq 'FS'>
                UPDATE PRO_WORKS SET TARGET_START=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#tfinish_date#">,TARGET_FINISH=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#tfinishend_date#"> WHERE WORK_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.work_id#">
            <cfelseif arguments.related_work_type eq 'SF'>
                UPDATE PRO_WORKS SET TARGET_START=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#tstartminus_date#">,TARGET_FINISH=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#tstart_date#"> WHERE WORK_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.work_id#">
            <cfelseif arguments.related_work_type eq 'SS'>
                UPDATE PRO_WORKS SET TARGET_START=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#tstart_date#">,TARGET_FINISH=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#tstartend_date#"> WHERE WORK_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.work_id#">
            <cfelse>
                UPDATE PRO_WORKS SET TARGET_START=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#tfinishminus_date#">,TARGET_FINISH=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#tfinish_date#"> WHERE WORK_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.work_id#">
            </cfif>	
        </cfquery>
        <cfreturn setDate>
    </cffunction>

    <!--- Aynı fonksiyon, V16\objects2\project\query\add_prowork.cfm --->
    <cffunction name="GET_EMAIL_ADDRESS3">
        <cfargument name="task_" required="yes">

        <cfquery name="GET_EMAIL_ADDRESS" datasource="#DSN#">
            SELECT EMPLOYEE_ID, EMPLOYEE_NAME AS NAME, EMPLOYEE_SURNAME AS SURNAME, EMPLOYEE_EMAIL AS EMAIL_ADDRESS FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(arguments.task_,3,',')#">
        </cfquery>
        <cfreturn GET_EMAIL_ADDRESS>
    </cffunction>

    <!--- Aynı isim, sonuna 2 eklendi --->
    <cffunction name="GET_EMAIL_ADDRESS4">
        <cfargument name="task_" required="yes">

        <cfquery name="GET_EMAIL_ADDRESS" datasource="#DSN#">
            SELECT PARTNER_ID, COMPANY_PARTNER_EMAIL AS EMAIL_ADDRESS, COMPANY_PARTNER_NAME AS NAME, COMPANY_PARTNER_SURNAME AS SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(arguments.task_,3,',')#">
        </cfquery>
        <cfreturn GET_EMAIL_ADDRESS>
    </cffunction>
    <!--- End: V16\objects2\project\query\upd_work.cfm --->

    <!--- Begin: V16\objects2\query\add_info_plus_project_act.cfm --->
    <cffunction name="get_asama">
        <cfquery name="get_asama" datasource="#dsn#" maxrows="1">
            SELECT 
                PROCESS_TYPE_ROWS.*,
                PROCESS_TYPE.IS_STAGE_BACK 
            FROM
                PROCESS_TYPE_ROWS,
                PROCESS_TYPE
            WHERE
                PROCESS_TYPE.PROCESS_ID = PROCESS_TYPE_ROWS.PROCESS_ID AND
                PROCESS_TYPE_ROWS.IS_PARTNER  = 1
        </cfquery>
        <cfreturn get_asama>
    </cffunction>

    <cffunction name="get_oncelik">
        <cfquery name="get_oncelik" datasource="#DSN#" maxrows="1">
            SELECT 
                PRIORITY_ID,
                PRIORITY 
            FROM 
                SETUP_PRIORITY
            ORDER BY
                PRIORITY
        </cfquery>
        <cfreturn get_oncelik>
    </cffunction>

    <cffunction name="get_cat">
        <cfquery name="get_cat" datasource="#dsn#" maxrows="1">
            SELECT DISTINCT
                SPC.MAIN_PROCESS_CAT_ID,
                SPC.MAIN_PROCESS_CAT,
                SPC.MAIN_PROCESS_TYPE
            FROM
                SETUP_MAIN_PROCESS_CAT_ROWS AS SPCR,
                SETUP_MAIN_PROCESS_CAT_FUSENAME AS SPCF,
                SETUP_MAIN_PROCESS_CAT SPC
            WHERE
                SPC.MAIN_PROCESS_CAT_ID = SPCR.MAIN_PROCESS_CAT_ID AND
                SPC.MAIN_PROCESS_CAT_ID = SPCF.MAIN_PROCESS_CAT_ID AND
                SPC.MAIN_PROCESS_MODULE IN (1) AND
                SPCF.FUSE_NAME = 'project.addpro'
            ORDER BY 
                SPC.MAIN_PROCESS_CAT
        </cfquery>
        <cfreturn get_cat>
    </cffunction>

    <cffunction name="ADD_PROJECT">
        <cfargument name="project_head" required="yes">
        <cfargument name="PROJECT_DETAIL" required="yes">
        <cfargument name="PRO_H_START" required="yes">
        <cfargument name="PRO_H_FINISH" required="yes">
        <cfargument name="PROCESS_ROW_ID" required="yes">
        <cfargument name="priority_id" required="yes">
        <cfargument name="MAIN_PROCESS_CAT_ID" required="yes">

        <cfquery name="ADD_PROJECT" datasource="#dsn#">
			INSERT INTO 
				PRO_PROJECTS
			(
				COMPANY_ID,
				PARTNER_ID,
				PROJECT_HEAD,
				PROJECT_DETAIL,
				TARGET_START,
				TARGET_FINISH,
				PRO_CURRENCY_ID,
				PRO_PRIORITY_ID,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP,
				PROJECT_STATUS,
				PROCESS_CAT
			)
			VALUES
			(
					#session.pp.COMPANY_ID#,
					#session.pp.userid#,
					'#arguments.project_head#',
					'#arguments.PROJECT_DETAIL#',
					#arguments.PRO_H_START#,
					#arguments.PRO_H_FINISH#,
					#arguments.PROCESS_ROW_ID#,
					#arguments.priority_id#,
					#NOW()#,
					#SESSION.pp.USERID#,
					'#CGI.REMOTE_ADDR#',
					1,
					#arguments.MAIN_PROCESS_CAT_ID#
				)
        </cfquery>
        <cfreturn ADD_PROJECT>
    </cffunction>

    <cffunction name="GET_LAST_PRO">
        <cfquery name="GET_LAST_PRO" datasource="#dsn#">
			SELECT MAX(PROJECT_ID) AS PRO_ID FROM PRO_PROJECTS
        </cfquery>
        <cfreturn GET_LAST_PRO>
    </cffunction>

    <cffunction name="ADD_PROJECT_TO_HISTORY">
        <cfargument name="pro_id" required="yes">
        <cfargument name="PRO_H_START" required="yes">
        <cfargument name="PRO_H_FINISH" required="yes">
        <cfargument name="PROCESS_ROW_ID" required="yes">
        <cfargument name="priority_id" required="yes">

        <cfquery name="ADD_PROJECT_TO_HISTORY" datasource="#dsn#">
			INSERT INTO 
				PRO_HISTORY
				(
					COMPANY_ID,
					PARTNER_ID,
					PROJECT_ID,
					UPDATE_DATE,
					TARGET_START,
					TARGET_FINISH,
					PRO_CURRENCY_ID,
					PRO_PRIORITY_ID
				)
			VALUES
				(
					#session.pp.COMPANY_ID#,
					#session.pp.userid#,
					#arguments.pro_id#,
					#now()#,
					#arguments.PRO_H_START#,
					#arguments.PRO_H_FINISH#,
					#arguments.PROCESS_ROW_ID#,
					#arguments.priority_id#
				)
        </cfquery>
        <cfreturn ADD_PROJECT_TO_HISTORY>
    </cffunction>

    <cffunction name="ADD_INFO">
        <cfargument name="STR_COLUMN" required="yes">
        <cfargument name="STR_VALUE" required="yes">
        <cfargument name="PRO_ID" required="yes">

        <cfquery name="ADD_INFO" datasource="#DSN#">
            INSERT INTO 
                PROJECT_INFO_PLUS
                (
                    #PreserveSingleQuotes(arguments.STR_COLUMN)#
                    PROJECT_ID,
                    PARTNER_ID,
                    COMPANY_ID,
                    RECORD_IP,
                    INFO_OWNER_TYPE
                )
                    VALUES
                (
                    #PreserveSingleQuotes(arguments.STR_VALUE)#
                    #arguments.PRO_ID#,
                    #session.pp.userid#,
                    #session.pp.COMPANY_ID#,
                    '#cgi.remote_addr#',
                    -10
                )
        </cfquery>
        <cfreturn ADD_INFO>
    </cffunction>
    <!--- End: V16\objects2\query\add_info_plus_project_act.cfm --->

    <!--- Begin: V16\objects2\project\display\dsp_project_detail.cfm --->
    <cffunction name="GET_PRO_CURRENCY_NAME">
        <cfargument name="pro_currency_id" required="yes">

        <cfquery name="GET_PRO_CURRENCY_NAME" datasource="#DSN#">
            SELECT STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pro_currency_id#">
        </cfquery>
        <cfreturn GET_PRO_CURRENCY_NAME>
    </cffunction>

    <cffunction name="GET_PRIORITY2">
        <cfargument name="project_id" required="yes">

        <cfquery name="GET_PRIORITY" datasource="#DSN#">
            SELECT PRIORITY FROM SETUP_PRIORITY,PRO_PROJECTS WHERE PRO_PRIORITY_ID = PRIORITY_ID AND PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">
        </cfquery>
        <cfreturn GET_PRIORITY>
    </cffunction>

    <cffunction name="GET_PRO_NAME2">
        <cfargument name="related_project_id" required="yes">

        <cfquery name="GET_PRO_NAME" datasource="#DSN#">
            SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.related_project_id#">
        </cfquery>
        <cfreturn GET_PRO_NAME>
    </cffunction>
    <!--- End: V16\objects2\project\display\dsp_project_detail.cfm --->

    <!--- Begin: V16\objects2\project\query\get_prodetail.cfm --->
    <cffunction name="PROJECT_DETAIL">
        <cfargument name="project_id">
        <cfargument name="id">

        <cfquery name="PROJECT_DETAIL" datasource="#DSN#">
            SELECT 
                *,
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
                SETUP_MONEY
            WHERE
                <cfif isDefined('session.pp.userid')>
                    SETUP_MONEY.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.period_id#"> AND
                <cfelseif isDefined('session.pda.userid')>
                    SETUP_MONEY.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.period_id#"> AND        
                </cfif>
                SETUP_MONEY.MONEY=PRO_PROJECTS.BUDGET_CURRENCY AND
                <cfif isDefined('arguments.project_id')>
                    PRO_PROJECTS.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">
                <cfelseif isDefined('arguments.id')>
                    PRO_PROJECTS.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">        
                </cfif>
            ORDER BY 
                PRO_PROJECTS.RECORD_DATE
        </cfquery>
        <cfreturn PROJECT_DETAIL>
    </cffunction>

    <cffunction name="GET_LAST_REC2">
        <cfargument name="project_id">
        <cfargument name="id">

        <cfquery name="GET_LAST_REC" datasource="#DSN#">
            SELECT
                MAX(HISTORY_ID) AS HIS_ID
            FROM
                PRO_HISTORY
            WHERE
                <cfif isDefined('arguments.project_id')>
                    PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">
                <cfelseif isDefined('arguments.id')>
                    PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">        
                </cfif>
        </cfquery>
        <cfreturn GET_LAST_REC>
    </cffunction>

    <cffunction name="GET_HIST_DETAIL2">
        <cfargument name="hist_id" required="yes">

        <cfquery name="GET_HIST_DETAIL" datasource="#DSN#">
            SELECT
                PRIORITY
            FROM
                PRO_HISTORY,
                SETUP_PRIORITY
            WHERE
                PRO_HISTORY.PRO_PRIORITY_ID = SETUP_PRIORITY.PRIORITY_ID AND
                PRO_HISTORY.HISTORY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.hist_id#">
        </cfquery>
        <cfreturn GET_HIST_DETAIL>
    </cffunction>
    <!--- End: V16\objects2\project\query\get_prodetail.cfm --->

    <!--- Begin: V16\objects2\project\display\project_team.cfm --->
    <cffunction name="GET_ROL_NAME">
        <cfargument name="role_id" required="yes">

        <cfquery name="GET_ROL_NAME" datasource="#DSN#">
            SELECT 
                PROJECT_ROLES 
            FROM 
                SETUP_PROJECT_ROLES 
            WHERE 
                PROJECT_ROLES_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.role_id#">
        </cfquery>
        <cfreturn GET_ROL_NAME>
    </cffunction>

    <cffunction name="GET_ROL_NAME2">
        <cfargument name="role_id" required="yes">

        <cfquery name="GET_ROL_NAME2" datasource="#DSN#">
            SELECT 
                PROJECT_ROLES 
            FROM 
                SETUP_PROJECT_ROLES 
            WHERE 
                PROJECT_ROLES_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.role_id#">
        </cfquery>
        <cfreturn GET_ROL_NAME2>
    </cffunction>
    <!--- End: V16\objects2\project\display\project_team.cfm --->

    <!--- Begin: V16\objects2\sale\list_project_pro_info.cfm --->
    <cffunction name="name">
        <cfargument name="type_id" required="yes">

        <cfquery name="GET_LABELS" datasource="#DSN#">
            SELECT
                *
            FROM
                SETUP_INFOPLUS_NAMES
            WHERE	
                OWNER_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.type_id#">
        </cfquery>
    </cffunction>
    <!--- End: V16\objects2\sale\list_project_pro_info.cfm --->

    <!--- Begin: V16\objects2\project\display\dsp_projects.cfm --->
    <cffunction name="GET_PROCURRENCY4">
        <cfargument name="my_our_comp_" required="yes">

        <cfquery name="GET_PROCURRENCY" datasource="#DSN#">
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
                PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.my_our_comp_#"> AND
                PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%objects2.list_projects%">
            ORDER BY
                PTR.LINE_NUMBER
        </cfquery>
        <cfreturn GET_PROCURRENCY>
    </cffunction>

    <cffunction name="GET_CURRENCY_NAME2">
        <cfargument name="project_stage_list" required="yes">

        <cfquery name="GET_CURRENCY_NAME" datasource="#DSN#">
            SELECT PROCESS_ROW_ID,STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#arguments.project_stage_list#) ORDER BY PROCESS_ROW_ID
        </cfquery>
        <cfreturn GET_CURRENCY_NAME>
    </cffunction>
    <!--- End: V16\objects2\project\display\dsp_projects.cfm --->

    <!--- Begin: V16\objects2\project\display\project_relation_asset.cfm --->
    <cffunction name="GET_ASSET">
        <cfargument name="project_id" required="yes">

        <cfquery name="GET_ASSET" datasource="#DSN#">
            SELECT
                ASSET.ASSET_FILE_NAME,
                ASSET.ASSET_NAME,
                CP.NAME
            FROM
                ASSET,
                CONTENT_PROPERTY AS CP,
                ASSET_SITE_DOMAIN ASD
            WHERE
                ASD.ASSET_ID = ASSET.ASSET_ID AND
                ASD.SITE_DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.http_host#"> AND
                ASSET.ACTION_SECTION = 'PROJECT_ID' AND
                ASSET.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#"> AND
                ASSET.PROPERTY_ID = CP.CONTENT_PROPERTY_ID
            ORDER BY 
                ASSET.ACTION_ID
        </cfquery>
        <cfreturn GET_ASSET>
    </cffunction>
    <!--- End: V16\objects2\project\display\project_relation_asset.cfm --->

    <!--- Begin: V16\objects2\project\display\project_relation_content.cfm --->
    <cffunction name="GET_CONTENT_RELATION">
        <cfargument name="project_id" required="yes">

        <cfquery name="GET_CONTENT_RELATION" datasource="#DSN#">
            SELECT 
                C.CONTENT_ID,
                C.CONT_HEAD,
                C.USER_FRIENDLY_URL,
                C.CONTENT_PROPERTY_ID
            FROM 
                CONTENT_RELATION CR,
                CONTENT C
            WHERE 
                C.CONTENT_STATUS = 1 AND
                C.STAGE_ID = -2 AND 
                CR.ACTION_TYPE = 'PROJECT_ID' AND
                CR.CONTENT_ID = C.CONTENT_ID AND
                CR.ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">
        </cfquery>
        <cfreturn GET_CONTENT_RELATION>
    </cffunction>
    <!--- End: V16\objects2\project\display\project_relation_content.cfm --->

    <!--- Begin: V16\objects2\project\display\project_relation_events.cfm --->
    <cffunction name="GET_RELATED_EVENTS">
        <cfargument name="project_id" required="yes">
        <cfargument name="company_id" required="yes">

        <cfquery name="GET_RELATED_EVENTS" datasource="#DSN#">
            SELECT
                RE.*,
                E.STARTDATE,
                E.EVENT_HEAD
            FROM
                EVENTS_RELATED RE,
                EVENT E
            WHERE
                E.EVENT_ID = RE.EVENT_ID AND		
                RE.ACTION_SECTION = 'PROJECT_ID' AND
                RE.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">
                  <cfif isdefined("arguments.company_id") and len(arguments.company_id)>
                    AND RE.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                  </cfif>	
            ORDER BY 
                E.STARTDATE DESC
        </cfquery>
        <cfreturn GET_RELATED_EVENTS>
    </cffunction>
    <!--- End: V16\objects2\project\display\project_relation_events.cfm --->

    <!--- Bulunamayan
        V16/objects2//project/display/graph.cfm
        V16/objects2/project/query/relate_opp_event.cfm 
    --->
</cfcomponent>