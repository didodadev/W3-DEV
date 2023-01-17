<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="GetDetailSurvey" access="public" returntype="query">
		<cfargument name="keyword" default="">
		<cfargument name="maxrows" default="">
		<cfargument name="startrow" default="">
        <cfargument name="project_cat_id" default="">
        <cfargument name="work_cat_id" default="">
        <cfargument name="relation_type" default="">
        <cfargument name="action_type" default="">
        <cfquery name="get_detail_survey" datasource="#dsn#">
            SELECT 
                SURVEY_MAIN_ID,
                SURVEY_MAIN_HEAD,
                TYPE
            FROM 
                SURVEY_MAIN 
            WHERE 
                SURVEY_MAIN_ID IS NOT NULL AND
                IS_ACTIVE = 1
            <cfif isDefined("arguments.keyword") and len(arguments.keyword)>
                AND SURVEY_MAIN_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#">
            </cfif> 
            <cfif isDefined("arguments.project_cat_id") and len(arguments.project_cat_id)>
                AND SURVEY_MAIN_ID IN(SELECT SURVEY_MAIN_ID FROM SURVEY_MAIN_PROJECT_CATS WHERE PROJECT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_cat_id#">)
            </cfif>
            <cfif isDefined("arguments.work_cat_id") and len(arguments.work_cat_id)>
                AND SURVEY_MAIN_ID IN(SELECT SURVEY_MAIN_ID FROM SURVEY_MAIN_WORK_CATS WHERE WORK_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.work_cat_id#">)
            </cfif> 
            <cfif isdefined("arguments.relation_type") and len(arguments.relation_type) and isdefined("arguments.action_type") and len(arguments.action_type)><!--- sadece iliskilendir denilen ekrandaki tipteki formları getirmesi icin eklendi--->
                AND TYPE IN(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#arguments.action_type#">)
                <!--- AND SURVEY_MAIN_ID NOT IN(SELECT SURVEY_MAIN_ID FROM CONTENT_RELATION WHERE (RELATION_TYPE IN(#arguments.relation_type#) AND RELATION_CAT = #arguments.relation_cat# )<!--- OR RELATED_ALL = 1--->)--->
            </cfif>
            ORDER BY RECORD_DATE DESC
        </cfquery>
        <cfreturn get_detail_survey>
	</cffunction>
    <cffunction name="GetControl" access="public" returntype="query">
        <cfargument name="relation_cat" default="">
        <cfquery name="get_control" datasource="#dsn#">
            SELECT
              SM.SURVEY_MAIN_ID 
            FROM 
              SURVEY_MAIN SM,CONTENT_RELATION CR 
            WHERE 
              SM.SURVEY_MAIN_ID = CR.SURVEY_MAIN_ID AND CR.RELATION_TYPE = 9 AND 
              (CR.RELATION_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.relation_cat#"> OR 
              CR.RELATED_ALL = 1)
        </cfquery>
       <cfreturn get_control>
   </cffunction>
   <cffunction name="GetMainResult" access="public" returntype="query">
        <cfargument name="action_type" default="">
        <cfargument name="action_type_id" default="">
        <cfquery name="get_main_result" datasource="#dsn#">
            SELECT 
                SURVEY_MAIN.SURVEY_MAIN_ID,
                SURVEY_MAIN.SURVEY_MAIN_HEAD,
                SURVEY_MAIN.TYPE,
                SURVEY_MAIN.IS_ONE_RESULT,
                SURVEY_MAIN_RESULT.COMPANY_ID,
                SURVEY_MAIN_RESULT.CONSUMER_ID,
                SURVEY_MAIN_RESULT.EMP_ID,
                SURVEY_MAIN_RESULT.PARTNER_ID,
                SURVEY_MAIN_RESULT.RECORD_DATE,
                SURVEY_MAIN_RESULT.SURVEY_MAIN_RESULT_ID
            FROM 
                SURVEY_MAIN_RESULT
                INNER JOIN SURVEY_MAIN 
                ON SURVEY_MAIN_RESULT.SURVEY_MAIN_ID = SURVEY_MAIN.SURVEY_MAIN_ID	
            WHERE
                ACTION_TYPE IN(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#arguments.action_type#">) AND
                ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_type_id#">
            UNION ALL
            SELECT DISTINCT
                SM.SURVEY_MAIN_ID,
                SM.SURVEY_MAIN_HEAD,
                SM.TYPE,
                SM.IS_ONE_RESULT,
                '' AS COMPANY_ID,
                '' CONSUMER_ID,
                '' EMP_ID,
                '' PARTNER_ID,
                '' RECORD_DATE,
                '-1' SURVEY_MAIN_RESULT_ID
            FROM 
                SURVEY_MAIN SM,
                CONTENT_RELATION CR
            WHERE
                SM.IS_ACTIVE = 1 AND
                SM.SURVEY_MAIN_ID = CR.SURVEY_MAIN_ID AND
                (
                    (CR.RELATION_TYPE IN(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#arguments.action_type#">) AND 
                    (CR.RELATION_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_type_id#"> OR 
                    CR.RELATED_ALL = 1))
                )		
        </cfquery>
        <cfreturn get_main_result>	       
    </cffunction>
    <cffunction name="GetControlResult" access="public" returntype="query">
        <cfargument name="survey_main_id" default="">
        <cfquery name="get_control_result" dbtype="query">
            SELECT 
                SURVEY_MAIN_ID 
            FROM 
                get_main_result
            WHERE 
                SURVEY_MAIN_ID  = <cfqueryparam cfsqltype="cf_sql_integer" value="#survey_main_id#"> AND 
                SURVEY_MAIN_RESULT_ID >0 
        </cfquery>
        <cfreturn get_control_result>
    </cffunction>
  <cffunction name="GetSurvey" access="public" returntype="query">
        <cfargument name="related_type" default="">
        <cfargument name="action_type_id" default="">
        <cfquery name="get_survey" datasource="#DSN#">
            SELECT 
                 SM.SURVEY_MAIN_ID,
                 SM.SURVEY_MAIN_HEAD,
                 SM.IS_ONE_RESULT,
                 '-1' SURVEY_MAIN_RESULT_ID,
                 CR.RELATED_ALL
            FROM 
                SURVEY_MAIN SM,
                CONTENT_RELATION CR
            WHERE
                SM.IS_ACTIVE = 1 AND
                SM.SURVEY_MAIN_ID = CR.SURVEY_MAIN_ID AND
                (
                    (CR.RELATION_TYPE IN(<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.related_type#">)  AND 
                    (CR.RELATION_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_type_id#"> OR 
                    CR.RELATED_ALL = 1))
                )
            UNION ALL
                SELECT 
                    SURVEY_MAIN.SURVEY_MAIN_ID,
                    SURVEY_MAIN.SURVEY_MAIN_HEAD,
                    SURVEY_MAIN.IS_ONE_RESULT,
                    SURVEY_MAIN_RESULT.SURVEY_MAIN_RESULT_ID,
                    '' AS RELATED_ALL
                FROM 
                    SURVEY_MAIN_RESULT
                    INNER JOIN SURVEY_MAIN 
                    ON SURVEY_MAIN_RESULT.SURVEY_MAIN_ID = SURVEY_MAIN.SURVEY_MAIN_ID
                WHERE
                    (SURVEY_MAIN_RESULT.IS_CLOSED = 0 OR SURVEY_MAIN_RESULT.IS_CLOSED = '')AND
                    SURVEY_MAIN_RESULT.ACTION_TYPE IN(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#arguments.related_type#">) AND
                    SURVEY_MAIN_RESULT.ACTION_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_type_id#"> AND  
                    (SURVEY_MAIN_RESULT.EMP_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> OR
                    SURVEY_MAIN_RESULT.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">)         
                    </cfquery> 
        <cfreturn get_survey> 
    </cffunction>  
   <cffunction name="GetControlSurvey" access="public" returntype="query">
        <cfargument name="survey_main_id" default="">
        <cfquery name="get_control_survey" dbtype="query">
            SELECT 
              SURVEY_MAIN_ID 
            FROM 
              get_survey 
            WHERE 
              SURVEY_MAIN_ID  = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_main_id#"> AND 
              SURVEY_MAIN_RESULT_ID >0 
        </cfquery>
        <cfreturn get_control_survey>
    </cffunction>
    <cffunction name="GetSurveyDetails" access="public" returntype="query"> 
        <cfargument name="survey_result_id" default="">
        <cfquery name="get_survey_details" datasource="#dsn#">
            SELECT 
                SURVEY_MAIN.TOTAL_SCORE,
                SURVEY_MAIN_RESULT.COMPANY_ID,
                SURVEY_MAIN_RESULT.CONSUMER_ID,
                SURVEY_MAIN_RESULT.EMP_ID,
                SURVEY_MAIN_RESULT.PARTNER_ID,
                SURVEY_MAIN_RESULT.RECORD_DATE,
                SURVEY_MAIN_RESULT.SCORE_RESULT
            FROM 
                SURVEY_MAIN_RESULT,SURVEY_MAIN
            WHERE
                SURVEY_MAIN_RESULT.SURVEY_MAIN_ID = SURVEY_MAIN.SURVEY_MAIN_ID AND
                SURVEY_MAIN_RESULT.SURVEY_MAIN_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_result_id#">
        </cfquery>
        <cfreturn get_survey_details>
    </cffunction> 
</cfcomponent>
