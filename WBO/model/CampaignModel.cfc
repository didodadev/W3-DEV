<!-----------------------------------------------------------------------
*************************************************************************
		Copyright Workcube E-Business Inc. www.workcube.com
*************************************************************************
Analys		: Fatih Ayık			Developer	: Merve Temel		
Analys Date : 01/04/2016			Dev Date	: 10/05/2016		
Description :
	Bu component kampanya objesine ait CRUD ve list fonksiyonlarını gerceklestirir.
----------------------------------------------------------------------->

<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cfset dsn3 = '#dsn#_#session.ep.company_id#'>
    
	<!--- list --->
    <cffunction name="list" access="public" returntype="query">
		<cfargument name="keyword" type="string" default="" required="no">
        <cfargument name="our_company_id" type="numeric" default="#session.ep.company_id#" required="no">
        <cfargument name="camp_type" type="string" default="" required="no">
        <cfargument name="is_active" type="string" default="" required="no">
        <cfargument name="emp_id" type="numeric" default="0" required="no">
        <cfargument name="par_id" type="numeric" default="0" required="no">
        <cfargument name="cons_id" type="numeric" default="0" required="no">
        <cfargument name="startdate" type="string" default="" required="no">
        <cfargument name="finishdate" type="string" default="" required="no">
        
        
		<cfquery name="list" datasource="#DSN3#">
            SELECT
                C.CAMP_ID,
                C.CAMP_CAT_ID,
                C.CAMP_NO,
                C.CAMP_STATUS,
                C.CAMP_HEAD,
                C.CAMP_STAGE_ID,
                C.PROCESS_STAGE,
                C.CAMP_STARTDATE,
                C.CAMP_FINISHDATE,
                C.LEADER_EMPLOYEE_ID,
                E.EMPLOYEE_NAME +' '+ E.EMPLOYEE_SURNAME LEADER_EMP_NAME,
                PTR.STAGE,
                CC.CAMP_CAT_NAME
            FROM
                CAMPAIGNS C
                LEFT JOIN #dsn#.EMPLOYEES AS E ON E.EMPLOYEE_ID = C.LEADER_EMPLOYEE_ID
                LEFT JOIN #dsn#.PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = C.PROCESS_STAGE
                LEFT JOIN CAMPAIGN_CATS CC ON CC.CAMP_CAT_ID = C.CAMP_CAT_ID
        WHERE
            C.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.our_company_id#"> 
            <cfif len(arguments.keyword)>
                AND
                (
                    C.CAMP_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR
                    C.CAMP_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR
                    C.CAMP_OBJECTIVE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                )
            </cfif>
            <cfif len(arguments.camp_type) and listlen(arguments.camp_type,'_') eq 2>
                AND	C.CAMP_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(arguments.camp_type,2,'_')#">
            <cfelseif len(arguments.camp_type)>
                AND	C.CAMP_CAT_ID IN (SELECT CAMP_CAT_ID FROM CAMPAIGN_CATS WHERE CAMP_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.camp_type#">)
            </cfif>
            <cfif len(arguments.is_active)>
                AND	C.CAMP_STATUS = #arguments.is_active#
            </cfif>	
			<cfif arguments.emp_id neq 0>
                AND C.LEADER_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.emp_id#"> 
            </cfif>
            <cfif len(arguments.startdate)>AND C.CAMP_STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,arguments.startdate)#"> </cfif>
            <cfif len(arguments.finishdate)>AND C.CAMP_STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,arguments.finishdate)#"> </cfif>
            ORDER BY 	
                C.CAMP_STARTDATE DESC
        </cfquery>
        
		<cfreturn list>
	</cffunction>
    
	<!--- get --->
    <cffunction name="get" access="public" returntype="query">
		<cfargument name="camp_id" type="numeric" default="0" required="yes">
        
		<cfquery name="get" datasource="#DSN3#">
            SELECT
                CAMPAIGNS.CAMP_ID,
                CAMPAIGNS.PROJECT_ID,
                CAMPAIGNS.CAMP_HEAD,
                CAMPAIGNS.COMPANY_CAT,
                CAMPAIGNS.IS_EXTRANET,
                CAMPAIGNS.CONSUMER_CAT,
                CAMPAIGNS.IS_INTERNET,
                CAMPAIGNS.CAMP_STATUS,
                CAMPAIGNS.CAMP_NO,
                CAMPAIGNS.CAMP_TYPE,
                CAMPAIGNS.CAMP_CAT_ID,
                CAMPAIGNS.PROCESS_STAGE,
                CAMPAIGNS.CAMP_STARTDATE,
                CAMPAIGNS.CAMP_FINISHDATE,
                CAMPAIGNS.CAMP_OBJECTIVE,
                CAMPAIGNS.LEADER_EMPLOYEE_ID,
                CAMPAIGNS.RECORD_EMP,
                CAMPAIGNS.UPDATE_EMP,
                CAMPAIGNS.RECORD_DATE,
                CAMPAIGNS.UPDATE_DATE,
                CAMPAIGNS.CAMP_STAGE_ID,
                CAMPAIGNS.PART_TIME,
                PP.PROJECT_HEAD,
                EP.EMPLOYEE_NAME +' '+ EP.EMPLOYEE_SURNAME AS LEADER_EMPLOYEE
            FROM
                CAMPAIGNS 
                LEFT JOIN #dsn#.PRO_PROJECTS PP ON PP.PROJECT_ID = CAMPAIGNS.PROJECT_ID
                LEFT JOIN #dsn#.EMPLOYEES EP ON EP.EMPLOYEE_ID = CAMPAIGNS.LEADER_EMPLOYEE_ID
            WHERE
                CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.camp_id#">
        </cfquery>
        
		<cfreturn get>
	</cffunction>
    <!--- add --->
    <cffunction name="add" access="public" returntype="string">
		<cfargument name="camp_status" type="boolean" default="0" required="yes">
        <cfargument name="camp_cat_id" type="numeric" required="yes">
        <cfargument name="is_extranet" type="boolean" default="0" required="no">
		<cfargument name="is_internet" type="boolean" default="0" required="no">
        <cfargument name="comp_cat" type="string" default="" required="no">
        <cfargument name="cons_cat" type="string" default="" required="no">
		<cfargument name="process_stage" type="numeric" required="yes">
        <cfargument name="paper_no" type="string" required="yes">
        <cfargument name="paper_number" type="string" required="yes">
        <cfargument name="camp_startdate" type="date" required="yes">
        <cfargument name="camp_finishdate" type="date" required="yes">
        <cfargument name="camp_head" type="string" required="yes">
        <cfargument name="leader_employee_id" type="numeric" default="0" required="no">
        <cfargument name="camp_objective" type="string" required="no">
        <cfargument name="project_id" type="numeric" default="0" required="no">
        <cfargument name="camp_type" type="any" default="" required="yes">
        <cfargument name="participation_time" type="any" default="" required="no">
        
		<cfquery name="add" datasource="#dsn3#" result="MAX_ID">
            INSERT INTO
                CAMPAIGNS
            (
                CAMP_STATUS, 
                CAMP_CAT_ID,
                OUR_COMPANY_ID,
                IS_EXTRANET,
                IS_INTERNET,
                COMPANY_CAT,
                CONSUMER_CAT,
                PROCESS_STAGE,
                CAMP_NO,
                CAMP_STARTDATE, 
                CAMP_FINISHDATE, 
                CAMP_HEAD, 
                LEADER_EMPLOYEE_ID,
                CAMP_OBJECTIVE,
                PROJECT_ID,
                RECORD_DATE,
                RECORD_EMP,
                RECORD_IP,
                CAMP_TYPE,
                PART_TIME
            )
            VALUES
            (
                #arguments.camp_status#, 
                #arguments.camp_cat_id#, 
                #session.ep.company_id#,
                #arguments.is_extranet#,
                #arguments.is_internet#,
                <cfif len(arguments.comp_cat)>',#arguments.comp_cat#,'<cfelse>NULL</cfif>,
                <cfif len(arguments.cons_cat)>',#arguments.cons_cat#,'<cfelse>NULL</cfif>,
                #arguments.process_stage#,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.paper_number#">,
                #arguments.camp_startdate#, 
                #arguments.camp_finishdate#, 
                '#arguments.camp_head#', 
                <cfif arguments.leader_employee_id neq 0>#leader_employee_id#<cfelse>NULL</cfif>,
                <cfif len(arguments.camp_objective)>'#arguments.camp_objective#'<cfelse>NULL</cfif>,
                <cfif arguments.project_id neq 0>#arguments.project_id#<cfelse>NULL</cfif>,
                #now()#,
                #session.ep.userid#,
                '#cgi.remote_addr#',
                #arguments.camp_type#,
                <cfif len(arguments.participation_time)>#arguments.participation_time#<cfelse>NULL</cfif>
            )
        </cfquery>
        
        <cfif len(arguments.paper_no)>
            <cfquery name="UPD_GEN_PAP" datasource="#DSN3#">
                UPDATE 
                    GENERAL_PAPERS
                SET
                    CAMPAIGN_NUMBER = #arguments.paper_no#
                WHERE
                    CAMPAIGN_NUMBER IS NOT NULL
            </cfquery>
        </cfif>
        
		<cfreturn MAX_ID.IDENTITYCOL>
	</cffunction>
    <!--- upd --->
    <cffunction name="upd" access="public" returntype="string">
		<cfargument name="camp_id" type="numeric" default="0" required="yes">
        <cfargument name="camp_status" type="boolean" default="0" required="yes">
        <cfargument name="camp_cat_id" type="numeric" required="yes">
        <cfargument name="is_extranet" type="boolean" default="0" required="no">
		<cfargument name="is_internet" type="boolean" default="0" required="no">
        <cfargument name="comp_cat" type="string" default="" required="no">
        <cfargument name="cons_cat" type="string" default="" required="no">
		<cfargument name="process_stage" type="numeric" required="yes">
        <cfargument name="paper_number" type="string" required="yes">
        <cfargument name="camp_startdate" type="date" required="yes">
        <cfargument name="camp_finishdate" type="date" required="yes">
        <cfargument name="camp_head" type="string" required="yes">
        <cfargument name="leader_employee_id" type="numeric" default="0" required="no">
        <cfargument name="camp_objective" type="string" required="no">
        <cfargument name="project_id" type="numeric" default="0" required="no">
        <cfargument name="camp_type" type="any" default="" required="yes">
        <cfargument name="participation_time" type="any" default="" required="no">
        
		<cfquery name="upd" datasource="#dsn3#">
            UPDATE
                CAMPAIGNS
            SET
                LEADER_EMPLOYEE_ID = <cfif arguments.leader_employee_id neq 0>#leader_employee_id#<cfelse>NULL</cfif>,
                CAMP_STATUS = #arguments.camp_status#,
                CAMP_CAT_ID = #arguments.camp_cat_id#,
                IS_INTERNET = #arguments.is_internet#,
                IS_EXTRANET = #arguments.is_extranet#,
                COMPANY_CAT = <cfif len(arguments.comp_cat)>',#arguments.comp_cat#,'<cfelse>NULL</cfif>,
                CONSUMER_CAT = <cfif len(arguments.cons_cat)>',#arguments.cons_cat#,'<cfelse>NULL</cfif>,
                PROCESS_STAGE = #arguments.process_stage#,
                PROJECT_ID = <cfif arguments.project_id neq 0>#arguments.project_id#<cfelse>NULL</cfif>,
                CAMP_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.paper_number#">, 
                CAMP_STARTDATE = #arguments.camp_startdate#,
                CAMP_FINISHDATE = #arguments.camp_finishdate#, 
                CAMP_HEAD = '#arguments.camp_head#',
                CAMP_OBJECTIVE = <cfif len(arguments.camp_objective)>'#arguments.camp_objective#'<cfelse>NULL</cfif>,
                UPDATE_DATE = #NOW()#,
                UPDATE_EMP = #SESSION.EP.USERID#,
                UPDATE_IP = '#CGI.REMOTE_ADDR#',
                CAMP_TYPE = #arguments.camp_type#,
                PART_TIME = <cfif len(arguments.participation_time)>#arguments.participation_time#<cfelse>NULL</cfif>
            WHERE
                CAMP_ID = #arguments.camp_id#
        </cfquery>
        
		<cfreturn arguments.camp_id>
	</cffunction>
    <!--- del --->
    <cffunction name="del" access="public" returntype="boolean">
		<cfargument name="camp_id" type="numeric" default="0" required="yes">
        
		<cfquery name="del" datasource="#dsn3#">
            DELETE CAMPAIGN_SMS_CONT WHERE CAMP_ID = #arguments.camp_id#
            
            DELETE PROMOTIONS WHERE CAMP_ID = #arguments.camp_id#
            
            DELETE CAMPAIGNS WHERE CAMP_ID = #arguments.camp_id#
        </cfquery>

        <cfquery name="get_segment" datasource="#dsn3#">
            SELECT 
                CONSCAT_SEGMENT_ID,
                CAMPAIGN_ID
            FROM 
                SETUP_CONSCAT_SEGMENTATION 
            WHERE 
                CAMPAIGN_ID = #arguments.camp_id#
        </cfquery>
        <cfquery name="DEL_CONTENT_REL" datasource="#dsn3#">
            DELETE #dsn#.CONTENT_RELATION  WHERE ACTION_TYPE_ID = #arguments.camp_id#
        </cfquery>
        <cfif get_segment.recordcount>
            <cfoutput query="get_segment">
                <cfquery name="del_rows" datasource="#dsn3#">
                    DELETE FROM SETUP_CONSCAT_SEGMENTATION_ROWS WHERE CONSCAT_SEGMENT_ID = #get_segment.CONSCAT_SEGMENT_ID#
                </cfquery>		
            </cfoutput>
            <cfquery name="del_segment" datasource="#dsn3#">
                DELETE FROM SETUP_CONSCAT_SEGMENTATION WHERE CAMPAIGN_ID = #arguments.camp_id#
            </cfquery>	
        </cfif>
        <cfquery name="del_premium" datasource="#dsn3#">
            DELETE FROM SETUP_CONSCAT_PREMIUM WHERE CAMPAIGN_ID = #arguments.camp_id#
        </cfquery>
        <cfset attributes.action_section="CAMPAIGN_ID">
        <cfset attributes.actionId=arguments.camp_id>
        
        <cfinclude template="../objects/query/del_assets.cfm">
        <cfinclude template="../objects/query/del_notes.cfm">
        
		<cfreturn true>
	</cffunction>
</cfcomponent>