<cfcomponent>
    <cfset dsn= application.systemParam.systemParam().dsn>
    <cfset dsn3= "#dsn#_#session.ep.company_id#">
    <cffunction name="GetDetailSurvey" access="public" returntype="query">
        <cfargument name="action_type" default="">
        <cfargument name="keyword" default="">
        <cfargument name="type_id" default="">
        <cfquery name="get_detail_survey" datasource="#DSN#">
            SELECT 
                SM.SURVEY_MAIN_ID,
                SM.SURVEY_MAIN_HEAD,
                SM.SURVEY_MAIN_DETAILS,
                SM.RECORD_DATE,
                SM.TYPE,
                SM.PROCESS_ROW_ID,
                PTR.STAGE
            FROM 
                SURVEY_MAIN SM
                LEFT JOIN PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = SM.PROCESS_ROW_ID
            WHERE 
                SM.TYPE IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_type#" list="yes">)
            <cfif isDefined("arguments.keyword") and len(arguments.keyword)>
                AND SM.SURVEY_MAIN_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
            </cfif>
            <cfif isdefined("arguments.type_id") and len(arguments.type_id)>
                AND SM.TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.type_id#">
            </cfif>
            ORDER BY 
                SM.RECORD_DATE DESC
        </cfquery> 
        <cfreturn get_detail_survey>
    </cffunction>
    <cffunction name="GetProcess" access="public" returntype="query">
        <cfquery name="get_process" datasource="#DSN#">
            SELECT
                PT.PROCESS_NAME,
                PT.PROCESS_ID
            FROM
                PROCESS_TYPE_OUR_COMPANY PTO,
                PROCESS_TYPE PT
            WHERE
                PT.PROCESS_ID = PTO.PROCESS_ID AND
                PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%objects.popup_form_add_detailed_survey_main_result%">
            ORDER BY
                PT.PROCESS_NAME
        </cfquery>
        <cfreturn get_process>
    </cffunction>
    <cffunction name="GetLanguage" access="public" returntype="query">
        <cfquery name="get_language" datasource="#DSN#">
            SELECT 
              LANGUAGE_ID,
              LANGUAGE_SET 
            FROM 
              SETUP_LANGUAGE
        </cfquery>
        <cfreturn get_language>
    </cffunction>
    <cffunction name="GetControl" access="public" returntype="query">
        <cfargument name="action_type_id" default="">
        <cfquery name="get_control" datasource="#dsn#">
            SELECT 
               SM.SURVEY_MAIN_ID 
            FROM 
               SURVEY_MAIN SM,
               CONTENT_RELATION CR 
            WHERE 
               SM.SURVEY_MAIN_ID = CR.SURVEY_MAIN_ID AND
               CR.RELATION_TYPE = 9 AND 
               (CR.RELATION_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_type_id#"> OR 
               CR.RELATED_ALL = 1)
        </cfquery>
        <cfreturn get_control>
    </cffunction>
    <cffunction name="GetPositionCat" access="public" returntype="query">
        <cfquery name="get_position_cat" datasource="#dsn#">
            SELECT 
               POSITION_CAT_ID,
               POSITION_CAT 
            FROM 
               SETUP_POSITION_CAT 
            ORDER BY 
               POSITION_CAT
        </cfquery>
        <cfreturn get_position_cat>
    </cffunction>
   <cffunction name="GetProjectCat" access="public" returntype="query">
        <cfquery name="get_project_cat" datasource="#dsn#">
            SELECT 
              MAIN_PROCESS_CAT_ID,
              MAIN_PROCESS_CAT 
            FROM 
              SETUP_MAIN_PROCESS_CAT 
            ORDER BY 
              MAIN_PROCESS_CAT
        </cfquery>
        <cfreturn get_project_cat>
   </cffunction>
   <cffunction name="GetWorkCat" access="public" returntype="query">
        <cfquery name="get_work_cat" datasource="#dsn#">
            SELECT 
              WORK_CAT_ID,
              WORK_CAT 
            FROM 
              PRO_WORK_CAT 
            ORDER BY 
              WORK_CAT
        </cfquery>
        <cfreturn get_work_cat>
    </cffunction>
    <cffunction name="AddSurveyMain" access="public" returntype="any">
        <cfargument name="head" default="">
        <cfargument name="detail" default="">
        <cfargument name="is_active" default="">
        <cfargument name="type" default="">
        <cfargument name="process_stage" default="">
        <cfargument name="language_id" default="">
        <cfargument name="employee_id" default="">
        <cfargument name="score1" default="">
        <cfargument name="score2" default="">
        <cfargument name="score3" default="">
        <cfargument name="score4" default="">
        <cfargument name="score5" default="">
        <cfargument name="comment1" default="">
        <cfargument name="comment2" default="">
        <cfargument name="comment3" default="">
        <cfargument name="comment4" default="">
        <cfargument name="comment5" default="">
        <cfargument name="analysis_average" default="">
        <cfargument name="total_score" default="">
        <cfargument name="IS_MANAGER_0" default="">
        <cfargument name="IS_MANAGER_1" default="">
        <cfargument name="IS_MANAGER_2" default="">
        <cfargument name="IS_MANAGER_3" default="">
        <cfargument name="IS_MANAGER_4" default="">
        <cfargument name="emp_quiz_weight" default="">
        <cfargument name="manager_quiz_weight_1" default="">
        <cfargument name="manager_quiz_weight_2" default="">
        <cfargument name="manager_quiz_weight_3" default="">
        <cfargument name="manager_quiz_weight_4" default="">
        <cfargument name="process_id" default="">
        <cfargument name="startdate" default="">
        <cfargument name="finishdate" default="">
        <cfargument name="is_one_result" default="">
        <cfargument name="is_selected_attender" default="">
        <cfargument name="is_not_show_saved" default="">
        <cfargument name="is_show_myhome" default="">
        <cfargument name="is_position_competence_measured" default="">
        <cfargument name="is_position_targets_measured" default="">
        <cfquery name="add_survey_main" datasource="#dsn#" result="MAX_ID">
			INSERT INTO 
				SURVEY_MAIN
				(	
					SURVEY_MAIN_HEAD,
					SURVEY_MAIN_DETAILS,
					IS_ACTIVE,
					TYPE,
					PROCESS_ROW_ID, 
					LANGUAGE_ID,
					EMP_ID,
					SCORE1,
					SCORE2,
					SCORE3,
					SCORE4,
					SCORE5,
					COMMENT1,
					COMMENT2,
					COMMENT3,
					COMMENT4,
					COMMENT5,
					AVERAGE_SCORE,
					TOTAL_SCORE,
					<!--- MAIN_TIME_LIMIT,  --->
					IS_MANAGER_0,
					IS_MANAGER_1,
					IS_MANAGER_2,
					IS_MANAGER_3,
					IS_MANAGER_4,
					EMP_QUIZ_WEIGHT,
					MANAGER_QUIZ_WEIGHT_1,
					MANAGER_QUIZ_WEIGHT_2,
					MANAGER_QUIZ_WEIGHT_3,
					MANAGER_QUIZ_WEIGHT_4,
					PROCESS_ID,
					START_DATE,
					FINISH_DATE,
					IS_ONE_RESULT,
					IS_SELECTED_ATTENDER,
					IS_NOT_SHOW_SAVED,
                    IS_SHOW_MYHOME,
                    IS_POSITION_COMPETENCE_MEASURED,
                    IS_POSITION_TARGETS_MEASURED,
                    RECORD_EMP,
					RECORD_DATE,
					RECORD_IP 
				)
				VALUES
				(
					<cfif isdefined('arguments.head') and len(arguments.head)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.head#"><cfelse>NULL</cfif>,
					<cfif isdefined('arguments.detail') and len(arguments.detail)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.detail#"><cfelse>NULL</cfif>,
					<cfif isdefined('arguments.is_active') and len(arguments.is_active)>1<cfelse>0</cfif>,
					<cfif isdefined('arguments.type') and len(arguments.type)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.type#"><cfelse>NULL</cfif>,
					<cfif isdefined('arguments.process_stage') and len(arguments.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#"><cfelse>NULL</cfif>,
					<cfif isdefined('arguments.language_id') and len(arguments.language_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.language_id#"><cfelse>NULL</cfif>,
					<cfif isdefined('arguments.employee_id') and len(arguments.employee_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#"><cfelse>NULL</cfif>,
					<cfif isdefined('arguments.score1') and len(arguments.score1)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.score1#"><cfelse>NULL</cfif>,
					<cfif isdefined('arguments.score2') and len(arguments.score2)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.score2#"><cfelse>NULL</cfif>,
					<cfif isdefined('arguments.score3') and len(arguments.score3)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.score3#"><cfelse>NULL</cfif>,
					<cfif isdefined('arguments.score4') and len(arguments.score4)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.score4#"><cfelse>NULL</cfif>,
					<cfif isdefined('arguments.score5') and len(arguments.score5)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.score5#"><cfelse>NULL</cfif>,
					<cfif isdefined('arguments.comment1') and len(arguments.comment1)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.comment1#"><cfelse>NULL</cfif>,
					<cfif isdefined('arguments.comment2') and len(arguments.comment2)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.comment2#"><cfelse>NULL</cfif>,
					<cfif isdefined('arguments.comment3') and len(arguments.comment3)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.comment3#"><cfelse>NULL</cfif>,
					<cfif isdefined('arguments.comment4') and len(arguments.comment4)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.comment4#"><cfelse>NULL</cfif>,
					<cfif isdefined('arguments.comment5') and len(arguments.comment5)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.comment5#"><cfelse>NULL</cfif>,
					<cfif isdefined('arguments.analysis_average') and len(arguments.analysis_average)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.analysis_average#"><cfelse>NULL</cfif>,
					<cfif isdefined('arguments.total_score') and len(arguments.total_score)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.total_score#"><cfelse>NULL</cfif>,
					<!--- <cfif isdefined('arguments.main_time_limit') and len(arguments.main_time_limit)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.main_time_limit#"><cfelse>NULL</cfif>,    --->
					<cfif IsDefined("arguments.IS_MANAGER_0") and len(arguments.IS_MANAGER_0)>1<cfelse>0</cfif>,
					<cfif IsDefined("arguments.IS_MANAGER_1") and len(arguments.IS_MANAGER_1)>1<cfelse>0</cfif>,
					<cfif IsDefined("arguments.IS_MANAGER_2") and len(arguments.IS_MANAGER_2)>1<cfelse>0</cfif>,
					<cfif IsDefined("arguments.IS_MANAGER_3") and len(arguments.IS_MANAGER_3)>1<cfelse>0</cfif>,
					<cfif IsDefined("arguments.IS_MANAGER_4") and len(arguments.IS_MANAGER_4)>1<cfelse>0</cfif>,
					<cfif IsDefined("arguments.emp_quiz_weight") and len(arguments.emp_quiz_weight)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.emp_quiz_weight#"><cfelse>NULL</cfif>,
					<cfif IsDefined("arguments.manager_quiz_weight_1") and len(arguments.manager_quiz_weight_1)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.manager_quiz_weight_1#"><cfelse>NULL</cfif>,
					<cfif isDefined("arguments.manager_quiz_weight_2") and len(arguments.manager_quiz_weight_2)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.manager_quiz_weight_2#"><cfelse>NULL</cfif>,
					<cfif isdefined("arguments.manager_quiz_weight_3") and len(arguments.manager_quiz_weight_3)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.manager_quiz_weight_3#"><cfelse>NULL</cfif>,
					<cfif isdefined("arguments.manager_quiz_weight_4") and len(arguments.manager_quiz_weight_4)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.manager_quiz_weight_4#"><cfelse>NULL</cfif>,
					<cfif isdefined("arguments.process_id")and len(arguments.process_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_id#"><cfelse>NULL</cfif>,
					<cfif isDefined("arguments.startdate") and len(arguments.startdate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startdate#"><cfelse>NULL</cfif>,
					<cfif isDefined("arguments.finishdate")and len(arguments.finishdate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finishdate#"><cfelse>NULL</cfif>,
					<cfif isdefined('arguments.is_one_result') and len(arguments.is_one_result)>1<cfelse>0</cfif>,
					<cfif isdefined('arguments.is_selected_attender') and len(arguments.is_selected_attender)>1<cfelse>0</cfif>,
					<cfif isdefined('arguments.is_not_show_saved') and len(arguments.is_not_show_saved)>1<cfelse>0</cfif>,
					<cfif isdefined('arguments.is_show_myhome') and len(arguments.is_show_myhome)>1<cfelse>0</cfif>,
					<cfif isdefined('arguments.is_position_competence_measured') and len(arguments.is_position_competence_measured)>1<cfelse>0</cfif>,
					<cfif isdefined('arguments.is_position_targets_measured') and len(arguments.is_position_targets_measured)>1<cfelse>0</cfif>,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">
				)
		</cfquery>
    <cfreturn MAX_ID>
    </cffunction>
    <cffunction name="AddMainPositionCats" access="public" returntype="any">
        <cfargument name="IDENTITYCOL" default="">
        <cfargument name="i" default="#i#">
        <cfquery name="add_main_position_cats" datasource="#dsn#">
			INSERT INTO
				SURVEY_MAIN_POSITION_CATS
				(
					SURVEY_MAIN_ID,
					POSITION_CAT_ID
				)
			VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#IDENTITYCOL#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#i#" list="yes">
				)
		</cfquery>
    <cfreturn>
    </cffunction>
    <cffunction name="AddMainProjectCats" access="public" returntype="any">
        <cfargument name="IDENTITYCOL" default="">
        <cfargument name="i" default="#i#">
        <cfquery name="add_main_project_cats" datasource="#dsn#">
			INSERT INTO
				SURVEY_MAIN_PROJECT_CATS
				(
					SURVEY_MAIN_ID,
					PROJECT_CAT_ID
				)
			VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#IDENTITYCOL#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#i#" list="yes">
				)
        </cfquery>
        <cfreturn>
    </cffunction>
    <cffunction name="AddMainWorkCats" access="public" returntype="any">
        <cfargument name="IDENTITYCOL" default="">
        <cfargument name="i" default="#i#">
        <cfquery name="add_main_work_cats" datasource="#dsn#">
			INSERT INTO
				SURVEY_MAIN_WORK_CATS
				(
					SURVEY_MAIN_ID,
					WORK_CAT_ID
				)
			VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#IDENTITYCOL#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#i#" list="yes">
				)
        </cfquery>
        <cfreturn>
    </cffunction>
    <cffunction name="AddContentRelation" access="public" returntype="any"> 
        <cfargument name="IDENTITYCOL" default="">
        <cfargument name="action_type_id" default="">
        <cfargument name="relation_type" default="">
        <cfquery name="add_content_relation" datasource="#dsn#">
            INSERT INTO
                CONTENT_RELATION
                (
                    SURVEY_MAIN_ID,
                    RELATION_CAT,
                    RELATION_TYPE,
                    RELATED_ALL,
                    RECORD_EMP,
                    RECORD_DATE,
                    RECORD_IP
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#IDENTITYCOL#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_type_id#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.relation_type#">,
                    0,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">
                )
        </cfquery>
        <cfreturn>
    </cffunction>
    <cffunction name="GetSurvey" access="public" returntype="query">
        <cfargument name="survey_id" default="">
        <cfquery name="get_survey" datasource="#dsn#">
            SELECT 
                SURVEY_MAIN_HEAD,
                SURVEY_MAIN_DETAILS,
                IS_ACTIVE,
                IS_ONE_RESULT,
                PROCESS_ROW_ID,
                TYPE,
                AVERAGE_SCORE,
                TOTAL_SCORE,
                EMP_ID,
                SCORE1,
                COMMENT1,
                SCORE2,
                COMMENT2,
                SCORE3,
                COMMENT3,
                SCORE4,
                COMMENT4,
                SCORE5,
                COMMENT5,
                IS_MANAGER_0,
                IS_MANAGER_1,
                IS_MANAGER_2,
                IS_MANAGER_3,
                IS_MANAGER_4,
                EMP_QUIZ_WEIGHT,
                MANAGER_QUIZ_WEIGHT_1,
                MANAGER_QUIZ_WEIGHT_2,
                MANAGER_QUIZ_WEIGHT_3,
                MANAGER_QUIZ_WEIGHT_4,
                PROCESS_ID,
                START_DATE,
                FINISH_DATE,
                IS_SELECTED_ATTENDER,
                IS_NOT_SHOW_SAVED,
                IS_SHOW_MYHOME,
                IS_POSITION_COMPETENCE_MEASURED,
                IS_POSITION_TARGETS_MEASURED,
				SURVEY_PERIOD,
                RECORD_EMP,
                RECORD_DATE,
                UPDATE_EMP,
                UPDATE_DATE
            FROM 
                SURVEY_MAIN 
            WHERE 
                SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_id#">
        </cfquery>
        <cfreturn get_survey>
    </cffunction>
    <cffunction name="GetSurveyResult" access="public" returntype="query">
        <cfargument name="survey_id" default="">
        <cfquery name="get_survey_result" datasource="#dsn#" maxrows="1">
            SELECT 
              SURVEY_MAIN_RESULT_ID 
            FROM 
              SURVEY_MAIN_RESULT 
            WHERE SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_id#">
        </cfquery>
    <cfreturn get_survey_result>   
    </cffunction>
    <cffunction name="GetPositionCats" access="public" returntype="query">
        <cfargument name="survey_id" default="">
        <cfquery name="get_position_cats" datasource="#dsn#">
            SELECT 
               POSITION_CAT_ID 
            FROM 
               SURVEY_MAIN_POSITION_CATS 
            WHERE
               SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_id#">
        </cfquery>
    <cfreturn get_position_cats>   
    </cffunction>
    <cffunction name="GetProjectCats" access="public" returntype="query">
        <cfargument name="survey_id" default="">
        <cfquery name="get_project_cats" datasource="#dsn#">
            SELECT 
              PROJECT_CAT_ID
            FROM 
              SURVEY_MAIN_PROJECT_CATS 
            WHERE 
              SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_id#">
        </cfquery>
        <cfreturn get_project_cats>
    </cffunction>
    <cffunction name="GetWorkCats" access="public" returntype="query">
        <cfargument name="survey_id" default="">
        <cfquery name="get_work_cats" datasource="#dsn#">
            SELECT 
               WORK_CAT_ID 
            FROM 
               SURVEY_MAIN_WORK_CATS
            WHERE SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_id#">
        </cfquery>
        <cfreturn get_work_cats>
    </cffunction>
    <cffunction name="UpdSurveyMain" access="public" returntype="any">
        <cfargument name="head" default="">
        <cfargument name="detail" default="">
        <cfargument name="is_active" default="">
        <cfargument name="is_one_result" default="">
        <cfargument name="is_selected_attender" default="">
        <cfargument name="IS_NOT_SHOW_SAVED" default="">
        <cfargument name="IS_SHOW_MYHOME" default="">
        <cfargument name="type" default="">
        <cfargument name="process_stage" default="">
        <cfargument name="language_id" default="">
        <cfargument name="employee_id" default="">
        <cfargument name="score1" default="">
        <cfargument name="score2" default="">
        <cfargument name="score3" default="">
        <cfargument name="score4" default="">
        <cfargument name="score5" default="">
        <cfargument name="comment1" default="">
        <cfargument name="comment2" default="">
        <cfargument name="comment3" default="">
        <cfargument name="comment4" default="">
        <cfargument name="comment5" default="">
        <cfargument name="analysis_average" default="">
        <cfargument name="total_score" default="">
        <cfargument name="IS_MANAGER_0" default="">
        <cfargument name="IS_MANAGER_1" default="">
        <cfargument name="IS_MANAGER_2" default="">
        <cfargument name="IS_MANAGER_3" default="">
        <cfargument name="IS_MANAGER_4" default="">
        <cfargument name="emp_quiz_weight" default="">
        <cfargument name="manager_quiz_weight_1" default="">
        <cfargument name="manager_quiz_weight_2" default="">
        <cfargument name="manager_quiz_weight_3" default="">
        <cfargument name="manager_quiz_weight_4" default="">
        <cfargument name="process_id" default="">
        <cfargument name="startdate" default="">
        <cfargument name="finishdate" default="">
        <cfargument name="survey_id" default="">
		<cfargument name="survey_period" default="">
		
         <cfargument name="dateformat_style" default="">
        <cfquery name="upd_survey_main" datasource="#dsn#">
            UPDATE 
                SURVEY_MAIN
            SET	
                SURVEY_MAIN_HEAD = <cfif isDefined("arguments.head") and len(arguments.head)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.head#"><cfelse>NULL</cfif>,
                SURVEY_MAIN_DETAILS = <cfif isDefined("arguments.detail") and len(arguments.detail)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.detail#"><cfelse>NULL</cfif>,
                IS_ACTIVE = <cfif isDefined("arguments.is_active") and len(arguments.is_active)>1<cfelse>0</cfif>,
                IS_ONE_RESULT = <cfif isDefined("arguments.is_one_result") and len(arguments.is_one_result)>1<cfelse>0</cfif>,
                IS_SELECTED_ATTENDER = <cfif isDefined("arguments.is_selected_attender") and len(arguments.is_selected_attender)>1<cfelse>0</cfif>,
                IS_NOT_SHOW_SAVED = <cfif isDefined("arguments.IS_NOT_SHOW_SAVED") and len(arguments.IS_NOT_SHOW_SAVED)>1<cfelse>0</cfif>,
                IS_SHOW_MYHOME = <cfif isDefined("arguments.IS_SHOW_MYHOME") and len(arguments.IS_SHOW_MYHOME)>1<cfelse>0</cfif>,
                IS_POSITION_COMPETENCE_MEASURED = <cfif isDefined("arguments.IS_POSITION_COMPETENCE_MEASURED") and len(arguments.IS_POSITION_COMPETENCE_MEASURED)>1<cfelse>0</cfif>,
                IS_POSITION_TARGETS_MEASURED = <cfif isDefined("arguments.IS_POSITION_TARGETS_MEASURED") and len(arguments.IS_POSITION_TARGETS_MEASURED)>1<cfelse>0</cfif>,
                TYPE = <cfif isDefined("arguments.type") and len(arguments.type)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.type#"><cfelse>NULL</cfif>,
                PROCESS_ROW_ID = <cfif isDefined("arguments.process_stage") and len(arguments.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#"><cfelse>NULL</cfif>,
                LANGUAGE_ID = <cfif isDefined("arguments.language_id") and len(arguments.language_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.language_id#"><cfelse>NULL</cfif>,
                EMP_ID = <cfif isDefined("arguments.employee_id") and len(arguments.employee_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#"><cfelse>NULL</cfif>,
                SCORE1 = <cfif isDefined("arguments.score1") and len(arguments.score1)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.score1#"><cfelse>NULL</cfif>,
                SCORE2 = <cfif isDefined("arguments.score2") and len(arguments.score2)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.score2#"><cfelse>NULL</cfif>,
                SCORE3 = <cfif isDefined("arguments.score3") and len(arguments.score3)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.score3#"><cfelse>NULL</cfif>,
                SCORE4 = <cfif isDefined("arguments.score4") and len(arguments.score4)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.score4#"><cfelse>NULL</cfif>,
                SCORE5 = <cfif isDefined("arguments.score5") and len(arguments.score5)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.score5#"><cfelse>NULL</cfif>,
                COMMENT1 = <cfif isDefined("arguments.comment1") and len(arguments.comment1)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.comment1#"><cfelse>NULL</cfif>,
                COMMENT2 = <cfif isDefined("arguments.comment2") and len(arguments.comment2)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.comment2#"><cfelse>NULL</cfif>,
                COMMENT3 = <cfif isDefined("arguments.comment3") and len(arguments.comment3)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.comment3#"><cfelse>NULL</cfif>,
                COMMENT4 = <cfif isDefined("arguments.comment4") and len(arguments.comment4)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.comment4#"><cfelse>NULL</cfif>,
                COMMENT5 = <cfif isDefined("arguments.comment5") and len(arguments.comment5)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.comment5#"><cfelse>NULL</cfif>,
                AVERAGE_SCORE = <cfif isDefined("arguments.analysis_average") and len(arguments.analysis_average)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.analysis_average#"><cfelse>NULL</cfif>,
                TOTAL_SCORE = <cfif isDefined("arguments.total_score") and len(arguments.total_score)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.total_score#"><cfelse>NULL</cfif>,
                <!--- MAIN_TIME_LIMIT = <cfif isdefined('arguments.main_time_limit') and  len(arguments.main_time_limit)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.main_time_limit#"><cfelse>NULL</cfif>, 
                 --->
                IS_MANAGER_0 = <cfif isDefined("arguments.IS_MANAGER_0") and len(arguments.IS_MANAGER_0)>1<cfelse>0</cfif>,
                IS_MANAGER_1 = <cfif isDefined("arguments.IS_MANAGER_1") and len(arguments.IS_MANAGER_1)>1<cfelse>0</cfif>,
                IS_MANAGER_2 = <cfif isDefined("arguments.IS_MANAGER_2") and len(arguments.IS_MANAGER_2)>1<cfelse>0</cfif>,
                IS_MANAGER_3 = <cfif isDefined("arguments.IS_MANAGER_3") and len(arguments.IS_MANAGER_3)>1<cfelse>0</cfif>,
                IS_MANAGER_4 = <cfif isDefined("arguments.IS_MANAGER_4") and len(arguments.IS_MANAGER_4)>1<cfelse>0</cfif>,
                EMP_QUIZ_WEIGHT = <cfif isDefined("arguments.emp_quiz_weight") and len(arguments.emp_quiz_weight)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.emp_quiz_weight#"><cfelse>NULL</cfif>,
                MANAGER_QUIZ_WEIGHT_1 = <cfif isDefined("arguments.manager_quiz_weight_1") and len(arguments.manager_quiz_weight_1)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.manager_quiz_weight_1#"><cfelse>NULL</cfif>,
                MANAGER_QUIZ_WEIGHT_2 = <cfif isDefined("arguments.manager_quiz_weight_2") and len(arguments.manager_quiz_weight_2)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.manager_quiz_weight_2#"><cfelse>NULL</cfif>,
                MANAGER_QUIZ_WEIGHT_3 = <cfif isDefined("arguments.manager_quiz_weight_3") and len(arguments.manager_quiz_weight_3)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.manager_quiz_weight_3#"><cfelse>NULL</cfif>,
                MANAGER_QUIZ_WEIGHT_4 = <cfif isDefined("arguments.manager_quiz_weight_4") and len(arguments.manager_quiz_weight_4)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.manager_quiz_weight_4#"><cfelse>NULL</cfif>,
                PROCESS_ID = <cfif isDefined("arguments.process_id") and len(arguments.process_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_id#"><cfelse>NULL</cfif>,
                START_DATE = <cfif isDefined("arguments.startdate") and len(arguments.startdate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#(arguments.startdate)#"><cfelse>NULL</cfif>,
                FINISH_DATE = <cfif isDefined("arguments.finishdate") and len(arguments.finishdate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#(arguments.finishdate)#"><cfelse>NULL</cfif>,
                SURVEY_PERIOD = <cfif isDefined("arguments.survey_period") and len(arguments.survey_period)>#arguments.survey_period#<cfelse>0</cfif>,
				UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">, 
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                UPDATE_IP = '#cgi.remote_addr#' 
            WHERE 
                SURVEY_MAIN_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_id#">
        </cfquery>
        <cfreturn>
    </cffunction>
    <cffunction name="DelPositionCats" access="public" returntype="any">
        <cfargument name="survey_id" default="">
        <cfquery name="del_position_cats" datasource="#dsn#">
            DELETE 
            FROM 
               SURVEY_MAIN_POSITION_CATS 
            WHERE SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_id#">
        </cfquery>
        <cfreturn>
    </cffunction>
    <cffunction name="DelProjectCats" access="public" returntype="any">
        <cfargument name="survey_id" default="">
        <cfquery name="del_project_cats" datasource="#dsn#">
            DELETE 
            FROM 
              SURVEY_MAIN_PROJECT_CATS 
            WHERE SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_id#">
        </cfquery>
        <cfreturn>
    </cffunction>
    <cffunction  name="DelWorkCats" access="public" returntype="any">
        <cfargument name="survey_id" default="">
        <cfquery name="del_work_cats" datasource="#dsn#">
            DELETE 
            FROM 
              SURVEY_MAIN_WORK_CATS 
            WHERE SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_id#">
        </cfquery>
        <cfreturn>
    </cffunction>
    <cffunction  name="AddMainPositionCatsUpd" access="public" returntype="any">
        <cfargument name="survey_id" default="">
        <cfargument name="i" default="#i#">
        <cfquery name="add_main_position_cats_upd" datasource="#dsn#">
			INSERT INTO
				SURVEY_MAIN_POSITION_CATS
				(
					SURVEY_MAIN_ID,
					POSITION_CAT_ID
				)
			VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_id#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.i#">
				)
        </cfquery>
        <cfreturn>
    </cffunction>
    <cffunction  name="AddMainProjectCatUpd" access="public" returntype="any">
        <cfargument name="survey_id" default="">
        <cfargument name="i" default="#i#">
        <cfquery name="add_main_project_cat_upd" datasource="#dsn#">
			INSERT INTO
				SURVEY_MAIN_PROJECT_CATS
				(
					SURVEY_MAIN_ID,
					PROJECT_CAT_ID
				)
			VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_id#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#i#" list="yes">
				)
        </cfquery>
        <cfreturn>
    </cffunction>
    <cffunction  name="AddMainWorkCatsUpd" access="public" returntype="any">
        <cfargument name="survey_id" default="">
        <cfargument name="i" default="#i#">
        <cfquery name="add_main_work_cats" datasource="#dsn#">
			INSERT INTO
				SURVEY_MAIN_WORK_CATS
				(
					SURVEY_MAIN_ID,
					WORK_CAT_ID
				)
			VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_id#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#i#" list="yes">
				)
        </cfquery>
        <cfreturn>
    </cffunction>
    <cffunction  name="DelSurveyOption" access="public" returntype="any">
        <cfargument name="survey_main_id" default="">
        <cfquery name="del_survey_option" datasource="#dsn#">
            DELETE 
            FROM 
               SURVEY_OPTION
            WHERE 
               SURVEY_CHAPTER_ID IN(
                        SELECT 
                            SURVEY_CHAPTER_ID 
                        FROM
                            SURVEY_CHAPTER 
                        WHERE
                            SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_main_id#">)
        </cfquery>
        <cfreturn>
    </cffunction>
    <cffunction name="DelSurveyChapter" access="public" returntype="any">
        <cfargument name="survey_main_id" default="">
        <cfquery name="del_survey_chapter" datasource="#dsn#">
            DELETE 
            FROM 
               SURVEY_CHAPTER 
            WHERE 
               SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_main_id#">
        </cfquery>
    <cfreturn>
    </cffunction>
    <cffunction name="DelSurveyQuestion" access="public" returntype="any">
        <cfargument name="survey_main_id" default="">
        <cfquery name="del_survey_question" datasource="#dsn#">
            DELETE 
            FROM 
              SURVEY_QUESTION 
            WHERE 
              SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_main_id#">
        </cfquery>
    <cfreturn>
    </cffunction>
    <cffunction name="DelSurveyRelation" access="public" returntype="any">
        <cfargument name="survey_main_id" default="">
        <cfquery name="del_survey_relation" datasource="#dsn#">
            DELETE 
            FROM 
              CONTENT_RELATION 
            WHERE 
              SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_main_id#">
        </cfquery>
    <cfreturn>
    </cffunction>
    <cffunction name="DelSurveyMain" access="public" returntype="any">
        <cfargument name="survey_main_id" default="">
        <cfquery name="del_survey_main" datasource="#dsn#">
            DELETE 
            FROM 
              SURVEY_MAIN 
            WHERE 
              SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_main_id#">
        </cfquery>
    <cfreturn>
    </cffunction>
    <!--- cfboxlar --->
    <cffunction name="GetSurveyChapter" access="public" returntype="query">
        <cfargument name="survey_id" default="">
        <cfquery name="get_survey_chapter" datasource="#dsn#">
            SELECT 
                SURVEY_CHAPTER_ID,
                SURVEY_CHAPTER_HEAD,
                SURVEY_CHAPTER_DETAIL,
                SURVEY_CHAPTER_WEIGHT,
                SURVEY_CHAPTER_CODE
            FROM 
                SURVEY_CHAPTER 
            WHERE 
                SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_id#">
            ORDER BY 
                SURVEY_CHAPTER_ID
        </cfquery>
        <cfreturn get_survey_chapter> 
    </cffunction>
    <cffunction name="GetQuestion" access="public" returntype="query">
        <cfargument name="survey_id" default="">
        <cfquery name="get_question" datasource="#dsn#">
			SELECT 
               SURVEY_QUESTION_ID 
            FROM 
               SURVEY_QUESTION 
            WHERE 
                SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_id#">
        </cfquery>
        <cfreturn get_question>
    </cffunction>
    <cffunction name="DelSurveyChapterFirst" access="public" returntype="any">
        <cfargument name="survey_question_id" default="">
        <cfquery name="del_survey_chapter" datasource="#dsn#">
            DELETE 
            FROM 
               SURVEY_OPTION
            WHERE 
               SURVEY_QUESTION_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#arguments.survey_question_id#">)
        </cfquery>
        <cfreturn>
    </cffunction>
    <cffunction name="DelSurveyChapterSecond" access="public" returntype="any">
        <cfargument name="survey_question_id" default="">
        <cfquery name="del_survey_chapter" datasource="#dsn#">
            DELETE 
            FROM 
              SURVEY_QUESTION 
            WHERE 
              SURVEY_QUESTION_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#arguments.survey_question_id#">)
        </cfquery>
        <cfreturn>
    </cffunction>
    <cffunction name="UpdSurveyChapter" access="public" returntype="any">
        <cfargument name="survey_id" default="">
        <cfargument name="survey_chapter_code" default="">
        <cfargument name="survey_chapter_head" default="">
        <cfargument name="survey_chapter_detail" default="">
        <cfargument name="survey_chapter_weight" default="">
        <cfargument name="survey_chapter_id" default="">
        <cfquery name="upd_survey_chapter" datasource="#dsn#">
            UPDATE
                SURVEY_CHAPTER
            SET
                SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_id#">,
                SURVEY_CHAPTER_CODE = <cfif isDefined("arguments.survey_chapter_code") and len("arguments.survey_chapter_code")><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.survey_chapter_code#">,<cfelse>NULL,</cfif>
                SURVEY_CHAPTER_HEAD = <cfif isDefined("arguments.survey_chapter_head") and len("arguments.survey_chapter_head")><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.survey_chapter_head#">,<cfelse>NULL,</cfif>
                SURVEY_CHAPTER_DETAIL = <cfif isDefined("arguments.survey_chapter_detail") and len("arguments.survey_chapter_detail")><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.survey_chapter_detail#">,<cfelse>NULL,</cfif>
                SURVEY_CHAPTER_WEIGHT = <cfif isDefined("arguments.survey_chapter_weight") and len("arguments.survey_chapter_weight")><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.survey_chapter_weight#">,<cfelse>NULL,</cfif>
                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">
            WHERE 
                SURVEY_CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("arguments.survey_chapter_id")#">
        </cfquery>
        <cfreturn>
    </cffunction>
    <cffunction name="AddSurveyChapter" access="public" returntype="any">
        <cfargument name="survey_id" default="">
        <cfargument name="survey_chapter_code" default="">
        <cfargument name="survey_chapter_head" default="">
        <cfargument name="survey_chapter_detail" default="">
        <cfargument name="survey_chapter_weight" default="">
        <cfquery name="add_survey_chapter" datasource="#dsn#">
            INSERT INTO
                SURVEY_CHAPTER
                (	
                    SURVEY_MAIN_ID,
                    SURVEY_CHAPTER_CODE,
                    SURVEY_CHAPTER_HEAD,
                    SURVEY_CHAPTER_DETAIL,
                    SURVEY_CHAPTER_WEIGHT,
                    RECORD_EMP,
                    RECORD_DATE,
                    RECORD_IP
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_id#">,
                    <cfif isDefined("arguments.survey_chapter_code") and len("arguments.survey_chapter_code")><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.survey_chapter_code#">,<cfelse>NULL,</cfif>
                    <cfif isDefined("arguments.survey_chapter_head") and len("arguments.survey_chapter_head")><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.survey_chapter_head#">,<cfelse>NULL,</cfif>
                    <cfif isDefined("arguments.survey_chapter_detail") and len("arguments.survey_chapter_detail")><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.survey_chapter_detail#">,<cfelse>NULL,</cfif>
                    <cfif isDefined("arguments.survey_chapter_weight") and len("arguments.survey_chapter_weight")><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.survey_chapter_weight#">,<cfelse>NULL,</cfif>
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">
                )
        </cfquery>
        <cfreturn>
    </cffunction>
    <cffunction name="DelSurveyChapterthird" access="public" returntype="any">
        <cfargument name="survey_id" default="">
        <cfargument name="survey_chapter_id" default="">
        <cfquery name="delsurveychapter" datasource="#dsn#">
            DELETE
            FROM
              SURVEY_CHAPTER 
            WHERE
              SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_id#"> AND
              SURVEY_CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_chapter_id#">
        </cfquery>
        <cfreturn>
    </cffunction>
    <cffunction name="DelSurveyQuestionfourth" access="public" returntype="any">
        <cfargument name="survey_chapter_id" default="">
        <cfquery name="delsurveyquestion" datasource="#dsn#">
            DELETE 
            FROM 
               SURVEY_QUESTION 
            WHERE 
               SURVEY_CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_chapter_id#">
        </cfquery>
        <cfreturn>
    </cffunction>
    <cffunction name="GetPlus" access="public" returntype="query">
        <cfquery name="get_plus" datasource="#dsn#">
				SELECT
                  LINE_NUMBER, 
                  SURVEY_CHAPTER_ID 
                FROM 
                  SURVEY_QUESTION
                WHERE 
                  SURVEY_QUESTION_ID =<cfqueryparam cfsqltype="cf_sql_integer" value ="#arguments.survey_question_id#">
		</cfquery> 
        <cfreturn get_plus>
    </cffunction>
    <cffunction name="UpdMinus" access="public" returntype="any">
        <cfargument name="survey_chapter_id" default="">
        <cfargument name="line_number" default="">
        <cfargument name="line_replace" default="">
        <cfquery name="upd_minus" datasource="#dsn#">
            UPDATE
                SURVEY_QUESTION
            SET
                LINE_NUMBER =  LINE_NUMBER - 1
            WHERE
                SURVEY_CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#survey_chapter_id#"> AND
                LINE_NUMBER BETWEEN <cfqueryparam cfsqltype="cf_sql_integer" value="#line_number#"> AND
                                    <cfqueryparam cfsqltype="cf_sql_nvarchar"  value="#arguments.line_replace#">
        </cfquery>
        <cfreturn>
    </cffunction>
    <cffunction name="UpdPlus" access="public" returntype="any">
        <cfargument name="line_replace" default="">
        <cfargument name="survey_question_id" default="">
        <cfquery name="upd_plus" datasource="#dsn#">
            UPDATE
                SURVEY_QUESTION
            SET
                LINE_NUMBER =<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.line_replace#">     
            WHERE
                SURVEY_QUESTION_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_question_id#">
        </cfquery>
        <cfreturn>
    </cffunction>
    <cffunction name="UpdMinus1" access="public" returntype="any">
        <cfargument name="survey_chapter_id" default="">
        <cfargument name="line_replace" default="">
        <cfargument name="line_number" default="">
        <cfquery name="upd_minus1" datasource="#dsn#">
            UPDATE
                SURVEY_QUESTION
            SET
                LINE_NUMBER =  LINE_NUMBER + 1
            WHERE
                SURVEY_CHAPTER_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#survey_chapter_id#"> AND
                LINE_NUMBER BETWEEN <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.line_replace#"> AND 
                                   <cfqueryparam cfsqltype="cf_sql_integer" value="#line_number#">
        </cfquery>
        <cfreturn>
    </cffunction>
   <!---  soru sor listeleme kısmı --->
    <cffunction name="GetQuestions" access="public" returntype="query">
    <cfargument name="survey_chapter_id" default="">
        <cfquery name="get_questions" datasource="#dsn#">
            SELECT
                SURVEY_QUESTION_ID,
                SURVEY_MAIN_ID,
                QUESTION_HEAD,
                QUESTION_DETAIL,
                LINE_NUMBER
            FROM 
                SURVEY_QUESTION 
            WHERE 
                SURVEY_CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_chapter_id#">
            ORDER BY LINE_NUMBER
        </cfquery>
        <cfreturn get_questions>
    </cffunction>
     <!--- soru ekleme bolumu --->
    <cffunction name="GetSurveyOptions" access="public" returntype="query">
        <cfargument name="survey_chapter_id" default="">
        <cfquery name="get_survey_options" datasource="#dsn#">
            SELECT 
                SURVEY_QUESTION_ID,
                OPTION_HEAD,
                OPTION_DETAIL,
                OPTION_POINT,
                SCORE_RATE1,
                SCORE_RATE2,
                QUESTION_DESIGN,
                QUESTION_TYPE 
            FROM 
                SURVEY_OPTION 
            WHERE 
                SURVEY_CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_chapter_id#"> AND
                SURVEY_QUESTION_ID IS NULL
        </cfquery>
        <cfreturn get_survey_options>
    </cffunction>
    <cffunction name="AddAsset" access="public" returntype="any">
        <cfargument name="assetcat_id" default="">
        <cfargument name="property_id" default="">
        <cfargument name="moduleName" default="">
        <cfargument name="moduleId" default="">
        <cfargument name="actionSection" default="">
        <cfargument name="file_name" default="">
        <cfargument name="asset_file_real_name" default="">
        <cfargument name="fileSize" default="">
        <cfargument name="fileServerId" default="">
        <cfargument name="member_id" default="">
        <cfquery name="add_asset" datasource="#DSN#">
			INSERT INTO 
				ASSET
			(	
				MODULE_NAME,
				MODULE_ID,
				ACTION_SECTION,
				<!--- ACTION_ID, --->
				ASSETCAT_ID,
				PROPERTY_ID,
				COMPANY_ID,
				<!--- ASSET_NAME, --->
				<!--- ASSET_STAGE, --->
				ASSET_FILE_NAME,
				ASSET_FILE_REAL_NAME,
				SERVER_NAME,
				ASSET_FILE_SIZE,
				ASSET_FILE_SERVER_ID,
				RECORD_EMP, 
				RECORD_DATE,
				RECORD_IP
			)
			VALUES
			(	
				<cfqueryparam cfsqltype="cf_sql_nvarchar"  value="#moduleName#">,
                <cfqueryparam cfsqltype="cf_sql_integer"  value="#moduleId#">,
				<cfqueryparam cfsqltype="cf_sql_nvarchar"  value="#actionSection#">,
				<!--- #get_max.max_id#, --->
				<cfif isdefined("arguments.assetcat_id") and len(arguments.assetcat_id)><cfqueryparam cfsqltype="cf_sql_integer"  value="#arguments.assetcat_id#"><cfelse>NULL</cfif>,
				<cfif isdefined("arguments.property_id") and len(arguments.property_id)><cfqueryparam cfsqltype="cf_sql_integer"  value="#arguments.property_id#"><cfelse>NULL</cfif>,
				1,
				<!--- 'Etkilesim: #get_max.max_id#', --->
				<!--- #get_process.process_row_id#, --->
				<cfqueryparam cfsqltype="cf_sql_nvarchar"  value="#file_name#">,
				<cfqueryparam cfsqltype="cf_sql_nvarchar"  value="#asset_file_real_name#">,
				'#cgi.http_host#',
				<cfqueryparam cfsqltype="cf_sql_integer"  value="#fileSize#">,
				<cfqueryparam cfsqltype="cf_sql_integer"  value="#fileServerId#">,
				<cfqueryparam cfsqltype="cf_sql_integer"  value="#member_id#">, 
				#now()#,
				'#cgi.remote_addr#'
			)
        </cfquery>
        <cfreturn>
    </cffunction>
    <cffunction name="GetLineNumber" access="public" returntype="query">
        <cfquery name="get_line_number" datasource="#dsn#">
            SELECT 
               MAX(LINE_NUMBER) AS LINE_NUMBER 
            FROM SURVEY_QUESTION 
            WHERE 
            SURVEY_CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_chapter_id#">
        </cfquery>
        <cfreturn get_line_number>
    </cffunction>
    <cffunction name="AddSurveyQuestions" access="public" returntype="any">
        <cfargument name="survey_chapter_id" default="">
        <cfargument name="survey_id" default="">
        <cfargument name="is_question" default="">
        <cfargument name="file_name" default="">
        <cfargument name="line_number_plus" default="">
        <cfargument name="question_head" default="">
        <cfargument name="question_detail" default="">
        <cfargument name="question_type" default="">
        <cfargument name="question_design" default="">
        <cfargument name="question_validation_question_id" default="">
        <cfargument name="option_image0" default="">
        <cfargument name="question_asset" default="">
        <cfargument name="question_time_limit" default="">
        <cfargument name="is_show_gd" default="">
        <cfquery name="add_survey_questions" datasource="#dsn#" result="MAX_ID">
            INSERT INTO 
                SURVEY_QUESTION
                (	
                    SURVEY_CHAPTER_ID,
                    SURVEY_MAIN_ID,
                    IS_REQUIRED,
                    LINE_NUMBER,
                    QUESTION_HEAD,
                    QUESTION_DETAIL,
                    QUESTION_TYPE,
                    QUESTION_DESIGN,
                    CROSS_QUESTION_ID,
                    QUESTION_IMAGE_PATH,
                    QUESTION_FLASH_PATH,
                    QUESTION_TIME_LIMIT,
                    IS_SHOW_GD,
                    RECORD_EMP,
                    RECORD_DATE,
                    RECORD_IP 
                )
                VALUES
                (	
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_chapter_id#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_id#">,
                    <cfif isdefined("arguments.is_question")>1<cfelse>0</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#line_number_plus#">,
                    <cfif isdefined('arguments.question_head') and len(arguments.question_head)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.question_head#"><cfelse>NULL</cfif>,
                    <cfif isdefined('arguments.question_detail') and len(arguments.question_detail)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.question_detail#"><cfelse>NULL</cfif>,
                    <cfif isdefined('arguments.question_type') and len(arguments.question_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.question_type#"><cfelse>NULL</cfif>,
                    <cfif isdefined('arguments.question_design') and len(arguments.question_design)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.question_design#"><cfelse>NULL</cfif>,
                    <cfif isdefined('arguments.question_validation_question_id') and len(arguments.question_validation_question_id)>#arguments.question_validation_question_id#<cfelse>NULL</cfif>,
                    <cfif isdefined('arguments.option_image0') and len(arguments.option_image0)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#file_name#"><cfelse>NULL</cfif>,
                    <cfif isdefined('arguments.question_asset') and len(arguments.question_asset)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.question_asset#"><cfelse>NULL</cfif>,
                    <cfif isdefined('arguments.question_time_limit') and len(arguments.question_time_limit)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.question_time_limit#"><cfelse>NULL</cfif>,   
                    <cfif isdefined('arguments.is_show_gd') and len(arguments.is_show_gd)>#arguments.is_show_gd#<cfelse>NULL</cfif>,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">
                )
        </cfquery>
        <cfreturn MAX_ID>
    </cffunction>
    <cffunction name="AddSurveyOptions1" access="public" returntype="any">
        <cfargument name="survey_chapter_id" default="">
        <cfargument name="IDENTITYCOL" default="">
        <cfargument name="option_score_rate1" default="">
        <cfargument name="option_score_rate2" default="">
        <cfquery name="add_survey_options1" datasource="#dsn#">
            INSERT INTO 
                SURVEY_OPTION
                (	
                    SURVEY_CHAPTER_ID,
                    SURVEY_QUESTION_ID,
                    SCORE_RATE1,
                    SCORE_RATE2  
                )
                VALUES
                (	
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_chapter_id#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#IDENTITYCOL#">,
                    <cfif isdefined("arguments.option_score_rate1") and len(evaluate("arguments.option_score_rate1"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('arguments.option_score_rate1')#">,<cfelse>NULL,</cfif> 
                    <cfif isdefined("arguments.option_score_rate2") and len(evaluate("arguments.option_score_rate2"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('arguments.option_score_rate2')#"><cfelse>NULL</cfif>  
                )
        </cfquery>
    </cffunction>
    <cffunction name="add_survey_options2" access="public" returntype="any">
        <cfargument name="survey_chapter_id" default="">
        <cfargument name="option_head" default="">
        <cfargument name="option_detail" default="">
        <cfargument name="option_score" default="">
        <cfargument name="option_score_rate1" default="">
        <cfargument name="option_score_rate2" default="">
        <cfargument name="option_point" default="">
        <cfargument name="file_name" default="">
        <cfquery name="add_survey_options2" datasource="#dsn#">
            INSERT INTO 
                SURVEY_OPTION
                (	
                    SURVEY_CHAPTER_ID,
                    SURVEY_QUESTION_ID,
                    OPTION_HEAD,
                    OPTION_DETAIL,
                    <!--- OPTION_NOTE, --->
                    OPTION_SCORE, 
                    SCORE_RATE1,
                    SCORE_RATE2,  
                    OPTION_POINT,
                    OPTION_IMAGE_PATH
                )
                VALUES
                (	
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_chapter_id#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#IDENTITYCOL#">,
                    <cfif isdefined("arguments.option_head") and len(arguments.option_head)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.option_head#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.option_detail") and len(arguments.option_detail)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.option_detail#"><cfelse>NULL</cfif>,
                    <!--- <cfif isdefined("arguments.option_add_note#j#")>1<cfelse>0</cfif>, --->
                    <cfif isdefined("arguments.option_score") and len(arguments.option_score)>1<cfelse>0</cfif>,
                    <cfif isdefined("arguments.option_score_rate1") and len(arguments.option_score_rate1)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.option_score_rate1#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.option_score_rate2") and len(arguments.option_score_rate2)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.option_score_rate2#"><cfelse>NULL</cfif> , 
                    <cfif isdefined("arguments.option_point") and len(arguments.option_point)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.option_point#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.option_image") and len(arguments.option_image)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.file_name#"><cfelse>NULL</cfif> 
                )
        </cfquery> 
    </cffunction>
    <cffunction name="GetMaxQuestionId" access="public" returntype="query">
        <cfargument name="survey_chapter_id" default="">
        <cfquery name="get_max_question_id" datasource="#dsn#">
            SELECT 
               MAX(SURVEY_QUESTION_ID) AS QUESTION_ID 
            FROM 
               SURVEY_QUESTION WHERE SURVEY_CHAPTER_ID = #arguments.survey_chapter_id#
        </cfquery>
        <cfreturn get_max_question_id>
    </cffunction>
    <cffunction name="UpdSurveyMainQuestion" access="public" returntype="any">
        <cfargument name="question_type" default="">
        <cfargument name="question_design" default="">
        <cfargument name="is_show_gd" default="">
        <cfargument name="QUESTION_ID" default="">
        <cfquery name="upd_survey_main_question" datasource="#dsn#">
            UPDATE 
                SURVEY_QUESTION
            SET	
                QUESTION_TYPE = <cfif isdefined('arguments.question_type') and len(arguments.question_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.question_type#">
                <cfelse><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#get_survey_options.question_type#"></cfif>,
                QUESTION_DESIGN = <cfif isdefined('arguments.question_design') and len(arguments.question_design)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.question_design#">
                <cfelseif len(get_survey_options.question_design)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#get_survey_options.question_design#"><cfelse>NULL</cfif>,
                IS_SHOW_GD  = <cfif isdefined('arguments.is_show_gd') and len(arguments.is_show_gd)><cfqueryparam     
                cfsqltype="cf_sql_integer" value="#arguments.is_show_gd#"><cfelse>NULL</cfif>
            WHERE 
                SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#QUESTION_ID#">
        </cfquery>
        <cfreturn>
    </cffunction>
    <cffunction name="GetSurveyQuestion" access="public" returntype="query">
        <cfargument name="survey_question_id" default="">
        <cfquery name="get_survey_question" datasource="#dsn#">
            SELECT 
                QUESTION_HEAD,
                QUESTION_DETAIL,
                QUESTION_IMAGE_PATH,
                QUESTION_TYPE,
                QUESTION_DESIGN,
                IS_REQUIRED,
                IS_SHOW_GD,
                RECORD_EMP,
                RECORD_DATE,
                UPDATE_EMP,
                UPDATE_DATE
            FROM 
                SURVEY_QUESTION 
            WHERE 
                SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_question_id#">
        </cfquery>
        <cfreturn  get_survey_question>
    </cffunction>
    <cffunction name="GetSurveyChapterQuestion" access="public" returntype="query">
        <cfargument name="survey_chapter_id" default="">
        <cfquery name="get_survey_chapter" datasource="#dsn#">
            SELECT 
               SURVEY_QUESTION_ID,
               OPTION_HEAD,
               OPTION_DETAIL,
               OPTION_POINT,
               SCORE_RATE1,
               SCORE_RATE2,
               QUESTION_DESIGN,
               QUESTION_TYPE 
            FROM 
               SURVEY_OPTION 
            WHERE 
               SURVEY_CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_chapter_id#"> AND SURVEY_QUESTION_ID IS NULL
        </cfquery>
        <cfreturn get_survey_chapter>
    </cffunction>
    <cffunction name="GetSurveyOptionsQuestion" access="public" returntype="query" >
        <cfargument name="survey_question_id" default="">
        <cfquery name="get_survey_options" datasource="#dsn#">
            SELECT
                SCORE_RATE1,
                SCORE_RATE2,
                OPTION_IMAGE_PATH,
                OPTION_NOTE,
                OPTION_SCORE,
                OPTION_HEAD,
                OPTION_DETAIL,
                OPTION_POINT 
            FROM
                SURVEY_OPTION 
            WHERE 
                SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_question_id#"> AND SURVEY_QUESTION_ID IS NOT NULL
        </cfquery>
        <cfreturn get_survey_options>
    </cffunction>
    <cffunction name="UpdSurveyQuestion" access="public" returntype="any">
        <cfargument name="is_question" default="">
        <cfargument name="head" default="">
        <cfargument name="detail" default="">
        <cfargument name="question_type" default="">
        <cfargument name="question_design" default="">
        <cfargument name="option_image0" default="">
        <cfargument name="file_name" default="">
        <cfargument name="question_image" default="">
        <cfargument name="asset" default="">
        <cfargument name="question_time_limit" default="">
        <cfargument name="validation_question_id" default="">
        <cfargument name="is_show_gd" default="">
        <cfargument name="survey_question_id" default="">
        <cfquery name="upd_survey_main" datasource="#dsn#">
            UPDATE 
                SURVEY_QUESTION
            SET	
                IS_REQUIRED = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_question#">,
                QUESTION_HEAD = <cfif len(arguments.head)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.head#"><cfelse>NULL</cfif>,
                QUESTION_DETAIL = <cfif len(arguments.detail)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.detail#"><cfelse>NULL</cfif>,
                QUESTION_TYPE = <cfif isdefined('arguments.question_type') and len(arguments.question_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.question_type#"><cfelse>null</cfif>,
                QUESTION_DESIGN = <cfif isdefined('arguments.question_design') and len(arguments.question_design)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.question_design#"><cfelse>NULL</cfif>,
                QUESTION_IMAGE_PATH = <cfif isdefined('arguments.option_image0') and len(arguments.option_image0)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#file_name#"><cfelseif isdefined('arguments.question_image') and len(arguments.question_image)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.question_image#"><cfelse>NULL</cfif>,
                QUESTION_FLASH_PATH = <cfif isdefined('arguments.asset') and len(arguments.asset)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.asset#"><cfelse>NULL</cfif>,
                QUESTION_TIME_LIMIT = <cfif isdefined('arguments.question_time_limit') and len(arguments.question_time_limit)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.question_time_limit#"><cfelse>NULL</cfif>, 
                CROSS_QUESTION_ID = <cfif isdefined('arguments.validation_question_id') and len(arguments.validation_question_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.validation_question_id#"><cfelse>NULL</cfif>,
                IS_SHOW_GD = <cfif isdefined('arguments.is_show_gd') and len(arguments.is_show_gd)>#arguments.is_show_gd#<cfelse>NULL</cfif>,
                UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">, 
                UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#"> 
            WHERE 
                SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_question_id#">
        </cfquery>
    </cffunction> 
    <cffunction name="DelSurveyOptions" access="public" returntype="any">
        <cfargument name="survey_question_id" default="">
        <cfquery name="del_survey_options" datasource="#dsn#">
            DELETE 
            FROM 
              SURVEY_OPTION
            WHERE 
              SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_question_id#"> AND 
              SURVEY_CHAPTER_ID IS NOT NULL
        </cfquery>
    </cffunction>
    <cffunction name="AddSurveyOptions" access="public" returntype="any">
        <cfargument name="survey_chapter_id" default="">
        <cfargument name="survey_question_id" default="">
        <cfargument name="option_head" default="">
        <cfargument name="option_detail" default="">
        <cfargument name="option_point" default="">
        <cfargument name="opt_image" default="">
        <cfargument name="file_name" default="">
        <cfquery name="add_survey_options" datasource="#dsn#">
            INSERT INTO 
                SURVEY_OPTION
                (	
                    SURVEY_CHAPTER_ID,
                    SURVEY_QUESTION_ID,
                    OPTION_HEAD,
                    OPTION_DETAIL,
                    <!--- OPTION_NOTE, --->
                    OPTION_SCORE, 
                    <!--- SCORE_RATE1,
                    SCORE_RATE2, --->  
                    OPTION_POINT,
                    OPTION_IMAGE_PATH
                )
                VALUES
                (	
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_chapter_id#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_question_id#">,
                    <cfif isdefined("arguments.option_head") and len(evaluate("arguments.option_head"))><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate('arguments.option_head')#">,<cfelse>NULL,</cfif>
                    <cfif isdefined("arguments.option_detail") and len(evaluate("arguments.option_detail"))><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate('arguments.option_detail')#">,<cfelse>NULL,</cfif>
                    <!--- <cfif isdefined("arguments.option_add_note#")>1<cfelse>0</cfif>, --->
                    <cfif isdefined("arguments.option_score")>1<cfelse>0</cfif>,
                    <!--- <cfif isdefined("arguments.option_score_rate1") and len(evaluate("arguments.option_score_rate1"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('arguments.option_score_rate1')#">,<cfelse>NULL,</cfif> 
                    <cfif isdefined("arguments.option_score_rate1") and len(evaluate("arguments.option_score_rate2"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('arguments.option_score_rate2')#">,<cfelse>NULL,</cfif>  ---> 
                    <cfif isdefined("arguments.option_point") and len(evaluate("arguments.option_point"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('arguments.option_point')#"><cfelse>NULL</cfif>,
                    <cfif isdefined("arguments.option_image") and len(evaluate("arguments.option_image"))><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#file_name#"><cfelse>NULL</cfif> 
                )
        </cfquery>
    </cffunction>
    <!--- ilişkili alanlar --->
   <cffunction name="GetTrains" access="public" returntype="query">
        <cfargument name="pos_req_type_id" default="">
        <cfargument name="date1" default="">
        <cfargument name="KEYWORD" default="">
        <cfargument name="pos_req_type" default="">
        <cfquery name="get_trains" datasource="#dsn#">
            SELECT 
                *
            FROM
                TRAINING_CLASS TC
            WHERE
                <cfif isdefined('arguments.list_type') and arguments.list_type eq 1 or len(arguments.pos_req_type_id) and len(arguments.pos_req_type)>
                    TC.CLASS_ID IN 
                    (
                        SELECT DISTINCT 
                            TCS.CLASS_ID
                        FROM 
                            RELATION_SEGMENT_TRAINING RST,
                            TRAINING_CLASS_SECTIONS TCS
                        WHERE
                            RST.RELATION_FIELD_ID=TCS.TRAIN_ID
                            AND RST.RELATION_ACTION=9
                        <cfif len(arguments.pos_req_type_id) and len(arguments.pos_req_type)>
                            AND RST.RELATION_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pos_req_type_id#">
                        </cfif>
                    )
                <cfelse>
                    1=1
                </cfif>
                <cfif len(arguments.date1)>
                    AND TC.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.date1#">
                </cfif>
                <cfif len(arguments.KEYWORD)>
                AND
                (
                    CLASS_NAME LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#arguments.KEYWORD#%">
                OR
                    CLASS_OBJECTIVE LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#arguments.KEYWORD#%">
                )
                </cfif>
                <!---<cfif len(arguments.class_style)>
                    AND TC.CLASS_ID IN (SELECT
                                        TC.CLASS_ID
                                    FROM
                                        TRAINING_CLASS_SECTIONS TC,
                                        TRAINING TT
                                    WHERE
                                        TT.TRAIN_ID = TC.TRAIN_ID AND
                                        TT.TRAINING_TYPE=#arguments.class_style#
                                    )
                </cfif>
                <cfif len(arguments.class_type)>
                    AND TC.CLASS_ID IN (SELECT
                                        TC.CLASS_ID
                                    FROM
                                        TRAINING_CLASS_SECTIONS TC,
                                        TRAINING TT
                                    WHERE
                                        TT.TRAIN_ID = TC.TRAIN_ID AND
                                        TT.TRAINING_TYPE=#arguments.class_type#
                                    )
                </cfif>--->
        </cfquery>
        <cfreturn get_trains>
   </cffunction>
   <cffunction name="GetTrainingStyle" access="public" returntype="query">
        <cfquery name="get_training_style" datasource="#dsn#">
            SELECT 
            *
            FROM
            SETUP_TRAINING_STYLE
        </cfquery>
        <cfreturn get_training_style>
   </cffunction>
   <cffunction name="GetReqs" access="public" returntype="query">
        <cfargument name="req_year" default="">
        <cfquery name="get_reqs" datasource="#dsn#">
            SELECT 
                REQ_TYPE_ID,
                REQ_TYPE
            FROM
                POSITION_REQ_TYPE
            WHERE
                PERFECTION_YEAR =<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.req_year#">
        </cfquery>
        <cfreturn get_reqs>
   </cffunction>
   <cffunction name="GetRelatedParts" access="public" returntype="query">
        <cfargument name="survey_id" default="">
        <cfquery name="get_related_parts" datasource="#dsn#">
            SELECT 
                RELATION_CAT,
                RELATION_TYPE
            FROM 
                CONTENT_RELATION 
            WHERE 
                SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_id#">
        </cfquery>
        <cfreturn get_related_parts>
   </cffunction>
   <cffunction name="GetOpp" access="public" returntype="query">
        <cfquery name="get_opp" datasource="#dsn3#">
            SELECT 
              OPP_HEAD AS RELATION_HEAD 
            FROM 
              OPPORTUNITIES 
            WHERE 
              OPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#relation_cat#">
        </cfquery>
        <cfreturn get_opp>
   </cffunction>
   <cffunction name="GetContent" access="public" returntype="query">
        <cfquery name="get_content" datasource="#dsn#">
            SELECT 
               CONT_HEAD AS RELATION_HEAD 
            FROM 
               CONTENT 
            WHERE 
               CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#relation_cat#">
        </cfquery>
        <cfreturn get_content>
    </cffunction>
    <cffunction name="GetCampaign" access="public" returntype="query">
        <cfquery name="get_campaign" datasource="#dsn3#">
            SELECT
               CAMP_HEAD AS RELATION_HEAD 
            FROM
               CAMPAIGNS 
            WHERE
               CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#relation_cat#">
        </cfquery>
        <cfreturn get_campaign>
    </cffunction>
    <cffunction name="GetProduct" access="public" returntype="query">
        <cfquery name="get_product" datasource="#dsn3#">
            SELECT 
               PRODUCT_NAME AS RELATION_HEAD 
            FROM 
               STOCKS WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#relation_cat#">
        </cfquery>
        <cfreturn get_product>
    </cffunction>
    <cffunction name="GetProject" access="public" returntype="query">
        <cfquery name="get_project" datasource="#dsn#">
            SELECT 
               PROJECT_HEAD AS RELATION_HEAD 
            FROM 
               PRO_PROJECTS 
            WHERE 
               PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#relation_cat#">
        </cfquery>
        <cfreturn get_project>
    </cffunction>
    <cffunction name="GetWork" access="public" returntype="query">
        <cfquery name="get_work" datasource="#dsn#">
            SELECT
               WORK_HEAD AS RELATION_HEAD 
            FROM 
               PRO_WORKS
            WHERE 
              WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#relation_cat#">
        </cfquery>
        <cfreturn get_work>
    </cffunction>
    <cffunction name="GetApp" access="public" returntype="query">
        <cfquery name="get_app" datasource="#dsn#">
            SELECT 
              NAME+' '+SURNAME AS RELATION_HEAD 
            FROM 
              EMPLOYEES_APP 
            WHERE 
              EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#relation_cat#">
        </cfquery>
        <cfreturn get_app>
    </cffunction>
    <cffunction name="GetClass" access="public" returntype="query">
        <cfquery name="get_class" datasource="#dsn#">
            SELECT 
               CLASS_NAME AS RELATION_HEAD 
            FROM 
               TRAINING_CLASS 
            WHERE 
              CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#relation_cat#">
        </cfquery>
        <cfreturn get_class>
    </cffunction>
    <cffunction name="GetOrganization" access="public" returntype="query">
        <cfquery name="get_organization" datasource="#dsn#">
            SELECT 
               ORGANIZATION_HEAD AS RELATION_HEAD 
            FROM 
               ORGANIZATION 
            WHERE 
              ORGANIZATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#relation_cat#">
        </cfquery>
        <cfreturn get_organization>
    </cffunction>
</cfcomponent>