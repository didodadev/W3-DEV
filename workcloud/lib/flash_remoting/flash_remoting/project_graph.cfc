<cfcomponent output="no" extends = "paramsControl">

    <cfset dsn = this.getdsn()>
    
    <!--- TEST --->
	<cffunction name="test" access="remote" returntype="string">
		<cfreturn "Project Graph component is accessible.">
	</cffunction>
    
    <!--- GET LANGUAGE SET --->
    <cffunction name="getLangSet" access="remote" returntype="array" output="no">
    	<cfargument name="lang" type="string" required="yes">
        <cfargument name="numbers" type="string" required="yes">
    
    	<cfset lang_component = CreateObject("component", "language")>
		<cfreturn lang_component.getLanguageSet(arguments.lang, arguments.numbers)>
    </cffunction>
    
    <!--- GET PROJECT INFO --->
    <cffunction name="getProjectInfo" access="remote" returntype="any" output="no">
    	<cfargument name="project_id" type="string" required="yes">
        
        <cftry>
            <cfquery name="project_info" datasource="#dsn#">
            	USE [#dsn#];
            
                SELECT
                    0 isPartner,
                    PRO_PROJECTS.PROJECT_HEAD AS title,
                    PRO_PROJECTS.TARGET_START AS startDate,
                    PRO_PROJECTS.TARGET_FINISH AS finishDate,
                    PRO_PROJECTS.PRO_PRIORITY_ID,
                    PRO_PROJECTS.PROCESS_CAT,
                    CAST(PRO_PROJECTS.PROJECT_DETAIL AS nvarchar(max)) AS description
                FROM
                    PRO_PROJECTS,
                    EMPLOYEES
                WHERE
                    PRO_PROJECTS.PROJECT_HEAD IS NOT NULL AND
                    PRO_PROJECTS.PROJECT_ID = '#arguments.project_id#' /*AND
                    EMPLOYEES.EMPLOYEE_STATUS = 1*/
                UNION
                SELECT
                    1 isPartner,
                    PRO_PROJECTS.PROJECT_HEAD AS title,
                    PRO_PROJECTS.TARGET_START AS startDate,
                    PRO_PROJECTS.TARGET_FINISH AS finishDate,
                    PRO_PROJECTS.PRO_PRIORITY_ID,
                    PRO_PROJECTS.PROCESS_CAT,
                    CAST(PRO_PROJECTS.PROJECT_DETAIL AS nvarchar(max)) AS description
                FROM
                    PRO_PROJECTS,
                    COMPANY_PARTNER
                WHERE
                    PRO_PROJECTS.PROJECT_HEAD IS NOT NULL AND
                    PRO_PROJECTS.PROJECT_ID = '#arguments.project_id#' AND
                    PRO_PROJECTS.OUTSRC_PARTNER_ID = COMPANY_PARTNER.PARTNER_ID
            </cfquery>
            
            <cfcatch>
                <cfreturn "#cfcatch.Message#\n\nDetail: #cfcatch.Detail#\n\nRaw Trace: #cfcatch.tagcontext[1].raw_trace#">
            </cfcatch>
        </cftry>
        
        <cfreturn project_info>
    </cffunction>
    
    <!--- GET PRIORITY LIST --->
    <cffunction name="getPriorityList" access="remote" returntype="query" output="no">
    	<cfquery name="priority_list" datasource="#dsn#">
            SELECT
                PRIORITY_ID AS id,
                PRIORITY AS name,	
                COLOR AS color
            FROM 
                SETUP_PRIORITY
        </cfquery>
        
        <cfreturn priority_list>
    </cffunction>
    
    <!--- GET PHASES --->
    <cffunction name="getPhases" access="remote" returntype="query" output="no">
    	<cfargument name="company_id" type="any" required="yes">
        
    	<cfquery name="get_phases" datasource="#dsn#">    
            SELECT
            	PTR.PROCESS_ROW_ID AS id,
                PTR.STAGE AS phase
			FROM
                PROCESS_TYPE_ROWS PTR,
                PROCESS_TYPE_OUR_COMPANY PTO,
                PROCESS_TYPE PT
          	WHERE
                PT.PROCESS_ID = PTR.PROCESS_ID AND
                PT.PROCESS_ID = PTO.PROCESS_ID AND
                PTO.OUR_COMPANY_ID = #arguments.company_id# AND
                PT.PROCESS_ID IN (SELECT PROCESS_ID FROM PROCESS_TYPE WHERE FACTION LIKE '%project.addwork%')
        </cfquery>
        
        <cfreturn get_phases>
    </cffunction>
    
    <!--- GET WORK CATEGORIES --->
    <cffunction name="getWorkCategories" access="remote" returntype="query" output="no">
    	<cfargument name="company_id" type="any" required="yes">
        
    	<cfquery name="get_work_categories" datasource="#dsn#">    
            SELECT 
                WORK_CAT_ID AS id, 
                WORK_CAT AS category 
            FROM 
                PRO_WORK_CAT 
            WHERE	
                OUR_COMPANY_ID LIKE '#arguments.company_id#,%' OR OUR_COMPANY_ID LIKE '%,#arguments.company_id#,%' OR OUR_COMPANY_ID LIKE '%,#arguments.company_id#'
            ORDER BY 
                WORK_CAT
        </cfquery>
        
        <cfreturn get_work_categories>
    </cffunction>
    
    <!--- GET TASKS --->
    <cffunction name="getTaskList" access="remote" returntype="query" output="no">
    	<cfargument name="project_id" type="string" required="yes">
        <cfargument name="encrypt_task_id" type="boolean" required="no" default="0">
        <cfargument name="encrypt_key" type="any" required="no" default="">
        <cfargument name="sorting_type" type="any" required="no" default="4" hint="target start date">
    
    	<cfset sortingKeys = "taskID DESC,UPDATE_DATE DESC,targetStartDate DESC,targetStartDate,targetFinishDate DESC,targetFinishDate,title">
    
    	<cfquery name="task_list" datasource="#dsn#">
			SELECT
                0 isPartner,
                EMPLOYEES.EMPLOYEE_ID personID,
                EMPLOYEES.EMPLOYEE_NAME personName,
                EMPLOYEES.EMPLOYEE_SURNAME personSurname,
                PRO_WORKS.WORK_ID taskID,
                '' encryptedTaskID,
                PRO_WORKS.RELATED_WORK_ID relatedTaskID,
                PRO_WORKS.MILESTONE_WORK_ID relatedMilestoneID,
                PRO_WORKS.RELATION_TYPE relationType,
                CAST(PRO_WORKS.WORK_HEAD as nvarchar(MAX)) title,
                PRO_WORKS.WORK_STATUS isActive,
                PRO_WORKS.IS_MILESTONE isMilestone,
                PRO_WORKS.WORK_CURRENCY_ID phase,
                PRO_WORKS.WORK_PRIORITY_ID priority,
                PRO_WORKS.WORK_CAT_ID categoryID,
                PRO_WORKS.TO_COMPLETE completedRate,
                PRO_WORKS.TARGET_START targetStartDate,
                PRO_WORKS.TARGET_FINISH targetFinishDate,
                PRO_WORKS.REAL_START startDate,
                PRO_WORKS.REAL_FINISH finishDate,
                PRO_WORKS.RECORD_DATE,
                PRO_WORKS.UPDATE_DATE
            FROM
                PRO_WORKS,
                EMPLOYEES
            WHERE
                PRO_WORKS.PROJECT_ID = #arguments.project_id# AND
                PRO_WORKS.PROJECT_EMP_ID = EMPLOYEES.EMPLOYEE_ID /*AND
                EMPLOYEES.EMPLOYEE_STATUS = 1*/
            UNION
            SELECT
                1 isPartner,
                COMPANY_PARTNER.PARTNER_ID personID,
                COMPANY_PARTNER.COMPANY_PARTNER_NAME personName,
                COMPANY_PARTNER.COMPANY_PARTNER_SURNAME personSurname,
                PRO_WORKS.WORK_ID taskID,
                '' encryptedTaskID,
                PRO_WORKS.RELATED_WORK_ID relatedTaskID,
                PRO_WORKS.MILESTONE_WORK_ID relatedMilestoneID,
                PRO_WORKS.RELATION_TYPE relationType,
                CAST(PRO_WORKS.WORK_HEAD as nvarchar(MAX)) title,
                PRO_WORKS.WORK_STATUS isActive,
                PRO_WORKS.IS_MILESTONE isMilestone,
                PRO_WORKS.WORK_CURRENCY_ID phase,
                PRO_WORKS.WORK_PRIORITY_ID priority,
                PRO_WORKS.WORK_CAT_ID categoryID,
                PRO_WORKS.TO_COMPLETE completedRate,
                PRO_WORKS.TARGET_START targetStartDate,
                PRO_WORKS.TARGET_FINISH targetFinishDate,
                PRO_WORKS.REAL_START startDate,
                PRO_WORKS.REAL_FINISH finishDate,
                PRO_WORKS.RECORD_DATE,
                PRO_WORKS.UPDATE_DATE
            FROM
                PRO_WORKS,
                COMPANY_PARTNER
            WHERE
                PRO_WORKS.PROJECT_ID = #arguments.project_id# AND
                PRO_WORKS.OUTSRC_PARTNER_ID = COMPANY_PARTNER.PARTNER_ID
            ORDER BY
                #listGetAt(sortingKeys, int(arguments.sorting_type), ",")#, isMilestone DESC
        </cfquery>
        
        <cfif arguments.encrypt_task_id eq 1>
            <cfloop query="task_list">
                <cfset QuerySetCell(task_list, "encryptedTaskID", "#encrypt(taskID, '#arguments.encrypt_key#', 'CFMX_COMPAT', 'Hex')#", currentRow)>
            </cfloop>
        </cfif>
        
        <cfreturn task_list>
    </cffunction>
    
    <!--- UPDATE TASK --->
    <cffunction name="updateTask" access="remote" returntype="any" output="no">
    	<cfargument name="employee_id" type="numeric" required="yes">
        <cfargument name="task_list" type="array" required="yes">
		
        <cftry>
            <cfloop from="1" to="#ArrayLen(arguments.task_list)#" index="i">
                <cfset task = arguments.task_list[i]>
                <cfset nowValue = now()>
                <cfquery name="update_task" datasource="#dsn#">
                    UPDATE
                        PRO_WORKS
                    SET
                        TARGET_START = #task.target_start_date#,
                        TARGET_FINISH = #task.target_finish_date#,
                        TO_COMPLETE = #task.completed_rate#,
                        UPDATE_DATE = #nowValue#,
                        UPDATE_AUTHOR = #arguments.employee_id#,
                        UPDATE_IP = '#cgi.REMOTE_ADDR#'
                    WHERE
                        WORK_ID = #task.work_id#
                </cfquery>
                <cfquery name="get_task" datasource="#dsn#">
                    SELECT * FROM PRO_WORKS WHERE WORK_ID = #task.work_id#
                </cfquery>
                
                <cfquery name="add_task_history" datasource="#dsn#">
                    INSERT INTO
                        PRO_WORKS_HISTORY
                        (
                            SERVICE_ID,
                            G_SERVICE_ID,
                            OUR_COMPANY_ID,
                            WORK_STATUS,
                            WORK_CAT_ID,
                            WORK_ID,
                            WORK_HEAD,
                            WORK_DETAIL,
                            ESTIMATED_TIME,
                            RELATED_WORK_ID,
                            PROJECT_EMP_ID,
                            OUTSRC_CMP_ID,
                            OUTSRC_PARTNER_ID,
                            PROJECT_ID,
                            COMPANY_ID,
                            COMPANY_PARTNER_ID,
                            CONSUMER_ID,
                            REAL_START,
                            REAL_FINISH,
                            WORK_CURRENCY_ID,
                            WORK_PRIORITY_ID,
                            TOTAL_TIME_HOUR,
                            TOTAL_TIME_MINUTE,
                            TO_COMPLETE,
                            UPDATE_DATE,
                            UPDATE_AUTHOR,
                            IS_MILESTONE,
                            TARGET_START,
                            TARGET_FINISH,
                            RELATION_TYPE
                        )
                        VALUES
                        (
                            <cfif len(get_task.SERVICE_ID)>#get_task.SERVICE_ID#<cfelse>NULL</cfif>,
                            <cfif len(get_task.G_SERVICE_ID)>#get_task.G_SERVICE_ID#<cfelse>NULL</cfif>,
                            <cfif len(get_task.OUR_COMPANY_ID)>#get_task.OUR_COMPANY_ID#<cfelse>NULL</cfif>,
                            <cfif len(get_task.WORK_STATUS)>#get_task.WORK_STATUS#<cfelse>NULL</cfif>,
                            <cfif len(get_task.WORK_CAT_ID)>#get_task.WORK_CAT_ID#<cfelse>NULL</cfif>,
                            #task.work_id#,
                            <cfif len(get_task.WORK_HEAD)>'#get_task.WORK_HEAD#'<cfelse>NULL</cfif>,
                            <cfif len(get_task.WORK_DETAIL)>'#get_task.WORK_DETAIL#'<cfelse>NULL</cfif>,
                            <cfif len(get_task.ESTIMATED_TIME)>#get_task.ESTIMATED_TIME#<cfelse>NULL</cfif>,
                            <cfif len(get_task.RELATED_WORK_ID)>'#get_task.RELATED_WORK_ID#'<cfelse>NULL</cfif>,
                            <cfif len(get_task.PROJECT_EMP_ID)>#get_task.PROJECT_EMP_ID#<cfelse>NULL</cfif>,
                            <cfif len(get_task.OUTSRC_CMP_ID)>#get_task.OUTSRC_CMP_ID#<cfelse>NULL</cfif>,
                            <cfif len(get_task.OUTSRC_PARTNER_ID)>#get_task.OUTSRC_PARTNER_ID#<cfelse>NULL</cfif>,
                            <cfif len(get_task.PROJECT_ID)>#get_task.PROJECT_ID#<cfelse>NULL</cfif>,
                            <cfif len(get_task.COMPANY_ID)>#get_task.COMPANY_ID#<cfelse>NULL</cfif>,
                            <cfif len(get_task.COMPANY_PARTNER_ID)>#get_task.COMPANY_PARTNER_ID#<cfelse>NULL</cfif>,
                            <cfif len(get_task.CONSUMER_ID)>#get_task.CONSUMER_ID#<cfelse>NULL</cfif>,
                            <cfif len(get_task.REAL_START)>'#get_task.REAL_START#'<cfelse>NULL</cfif>,
                            <cfif len(get_task.REAL_FINISH)>'#get_task.REAL_FINISH#'<cfelse>NULL</cfif>,
                            <cfif len(get_task.WORK_CURRENCY_ID)>#get_task.WORK_CURRENCY_ID#<cfelse>NULL</cfif>,
                            <cfif len(get_task.WORK_PRIORITY_ID)>#get_task.WORK_PRIORITY_ID#<cfelse>NULL</cfif>,
                            <cfif len(get_task.TOTAL_TIME_HOUR)>#get_task.TOTAL_TIME_HOUR#<cfelse>NULL</cfif>,
                            <cfif len(get_task.TOTAL_TIME_MINUTE)>#get_task.TOTAL_TIME_MINUTE#<cfelse>NULL</cfif>,
                            #task.completed_rate#,
                            #nowValue#,
                            #arguments.employee_id#,
                            <cfif len(get_task.IS_MILESTONE)>#get_task.IS_MILESTONE#<cfelse>NULL</cfif>,
                            #task.target_start_date#,
                            #task.target_finish_date#,
                            <cfif len(get_task.RELATION_TYPE)>#get_task.RELATION_TYPE#<cfelse>NULL</cfif>
                        )
                </cfquery>
            </cfloop>
            
            <cfcatch>
            	<cfreturn "#cfcatch.Message#\n\nDetail: #cfcatch.Detail#\n\nRaw Trace: #cfcatch.tagcontext[1].raw_trace#\n\nRecord index: #i#">
            </cfcatch>
        </cftry>
       	
        <cfreturn true>
    </cffunction>
</cfcomponent>