<cfcomponent output="no" extends = "paramsControl">

    <cfset dsn = this.getdsn()>
    <!--- TEST --->
	<cffunction name="test" access="remote" returntype="string">
		<cfreturn "Employee Work Graph component is accessible.">
	</cffunction>
    
    <!--- GET LANGUAGE SET --->
    <cffunction name="getLangSet" access="remote" returntype="array" output="no">
    	<cfargument name="lang" type="string" required="yes">
        <cfargument name="numbers" type="string" required="yes">
    
    	<cfset lang_component = CreateObject("component", "language")>
		<cfreturn lang_component.getLanguageSet(arguments.lang, arguments.numbers)>
    </cffunction>
    
    <!--- GET EMPLOYEE INFO --->
    <cffunction name="getEmployeeInfo" access="remote" returntype="struct" output="no">
    	<cfargument name="employee_id" type="string" required="no" default="">
        <cfargument name="partner_id" type="string" required="no" default="">
        
        <cfif len(arguments.employee_id)>
            <cfquery name="get_info" datasource="#dsn#" maxrows="1">
                SELECT
                    E.EMPLOYEE_NAME AS name,
                    E.EMPLOYEE_SURNAME AS surname,
                    POSITION_NAME AS positionName
                FROM
                    EMPLOYEES E,
                    EMPLOYEE_POSITIONS EP
                WHERE
                    E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND
                    E.EMPLOYEE_ID = '#arguments.employee_id#'
            </cfquery>
		<cfelseif len(arguments.partner_id)>
        	<cfquery name="get_info" datasource="#dsn#" maxrows="1">
                SELECT
                    CP.COMPANY_PARTNER_NAME AS name,
                    CP.COMPANY_PARTNER_SURNAME AS surname,
                    SPP.PARTNER_POSITION AS positionName
                FROM 
                    COMPANY_PARTNER CP,
                    SETUP_PARTNER_POSITION SPP
                WHERE 
                    CP.MISSION = SPP.PARTNER_POSITION_ID AND
                    CP.PARTNER_ID = '#arguments.partner_id#'
            </cfquery>
		</cfif>
        
        <cfset info = StructNew()>
        <cfif isDefined("get_info")>
			<cfset info["name"] = get_info.name>
            <cfset info["surname"] = get_info.surname>
            <cfset info["positionName"] = get_info.positionName>
		</cfif>
        
        <cfreturn info>
    </cffunction>
    
    <!--- GET COMPANY CAT --->
	<cffunction name="getCompanyCat" access="remote" returntype="query" output="no">
    	<cfargument name="company_id" type="any" required="yes">
        
		<cfquery name="companycat_list" datasource="#dsn#">
            SELECT 
				CC.COMPANYCAT_ID id,
				CC.COMPANYCAT name 
			FROM 
				COMPANY_CAT CC,
				COMPANY_CAT_OUR_COMPANY CCO
			WHERE 
				CC.COMPANYCAT_ID = CCO.COMPANYCAT_ID AND
				CCO.OUR_COMPANY_ID = #arguments.company_id#
        </cfquery>
        
        <cfreturn companycat_list>
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
    
	<!--- GET AGENDA --->
    <cffunction name="getAgenda" access="private" returntype="query" output="no">
        <cfargument name="employee_id" type="numeric" required="yes">
        <cfargument name="startdate" type="date" required="yes">
        <cfargument name="finishdate" type="date" required="yes">
        <cfargument name="project_id" type="any" required="no" default="">
        
        <cfquery name="emp_events" datasource="#dsn#">
            SELECT
                'event' AS TYPE,
                EVENT_ID AS taskID,
                EVENT_HEAD AS title,
                STARTDATE AS startDate,
                FINISHDATE AS finishDate,
                STARTDATE AS targetStartDate,
                FINISHDATE AS targetFinishDate
            FROM
                EVENT
            WHERE
                (EVENT_TO_POS LIKE '%,#arguments.employee_id#,%' OR EVENT_CC_POS LIKE '%,#arguments.employee_id#,%' OR VALID_EMP = #arguments.employee_id#)
                <cfif len(arguments.project_id)>AND PROJECT_ID = #arguments.project_id#</cfif>
                AND
                (
                    (STARTDATE <= #arguments.startdate# AND FINISHDATE >= #arguments.startdate#) OR 
                    (STARTDATE >= #arguments.startdate# AND STARTDATE <= #arguments.finishdate#)
                )
            UNION ALL
                SELECT 
                    'offtime' AS TYPE,
                    OFFTIME.OFFTIME_ID AS taskID, 
                    SETUP_OFFTIME.OFFTIMECAT AS title,
                    '' AS startDate, 
                    '' AS finishDate,
                    OFFTIME.STARTDATE AS targetStartDate, 
                    OFFTIME.FINISHDATE AS targetFinishDate
                FROM 
                    OFFTIME,
                    SETUP_OFFTIME
                WHERE
                    OFFTIME.EMPLOYEE_ID = #arguments.employee_id# AND
                    OFFTIME.OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID
                    AND
                    (
                        (
                        OFFTIME.STARTDATE >= #arguments.startdate# AND
                        OFFTIME.STARTDATE <= #arguments.finishdate#
                        )
                    OR
                        (
                        OFFTIME.STARTDATE <= #arguments.startdate# AND
                        OFFTIME.FINISHDATE >= #arguments.startdate#
                        )
                    )
            UNION ALL
                SELECT 
                    'ssk_fee' AS TYPE,
                    EMPLOYEES_SSK_FEE.FEE_ID AS taskID, 
                    'Vizite' AS title,
                    '' AS startDate, 
                    '' AS finishDate,
                    EMPLOYEES_SSK_FEE.FEE_DATEOUT AS targetStartDate, 
                    EMPLOYEES_SSK_FEE.FEE_DATEOUT AS targetFinishDate
                FROM 
                    EMPLOYEES_SSK_FEE
                WHERE
                    EMPLOYEES_SSK_FEE.EMPLOYEE_ID = #arguments.employee_id#
                    AND
                    (
                        (
                        EMPLOYEES_SSK_FEE.FEE_DATEOUT >= #arguments.startdate# AND
                        EMPLOYEES_SSK_FEE.FEE_DATEOUT <= #arguments.finishdate#
                        )
                    OR
                        (
                        EMPLOYEES_SSK_FEE.FEE_DATEOUT <= #arguments.startdate# AND
                        EMPLOYEES_SSK_FEE.FEE_DATEOUT >= #arguments.startdate#
                        )
                    )
            UNION ALL
                SELECT 
                    'training' AS TYPE,
                    TRAINING_CLASS.CLASS_ID AS taskID,
                    TRAINING_CLASS.CLASS_NAME AS title,
                    '' AS startDate, 
                    '' AS finishDate,
                    TRAINING_CLASS.START_DATE AS targetStartDate,
                    TRAINING_CLASS.FINISH_DATE AS targetFinishDate
                FROM 
                    TRAINING_CLASS ,
                    TRAINING_CLASS_ATTENDER 
                WHERE
                     TRAINING_CLASS.CLASS_ID = TRAINING_CLASS_ATTENDER.CLASS_ID AND 
                     TRAINING_CLASS_ATTENDER.EMP_ID = #arguments.employee_id#
                     <cfif len(arguments.project_id)>AND PROJECT_ID = #arguments.project_id#</cfif>
                        AND
                        (
                            (
    
                            TRAINING_CLASS.START_DATE >= #arguments.startdate# AND
                            TRAINING_CLASS.START_DATE <= #arguments.finishdate#
                            )
                        OR
                            (
                            TRAINING_CLASS.START_DATE <= #arguments.startdate# AND
                            TRAINING_CLASS.FINISH_DATE >= #arguments.startdate#
                            )
                        )	
                
        </cfquery>
        <cfreturn emp_events>
    </cffunction>
    
    <!--- GET LIST --->
    <cffunction name="getList" access="remote" returntype="array" output="no">
    	<cfargument name="company_id" type="any" required="yes">
        <cfargument name="project_id" type="string" required="no" default="">
        <cfargument name="employee_id" type="string" required="no">
        <cfargument name="partner_id" type="string" required="no">
        <cfargument name="department_id" type="string" required="no">
        <cfargument name="branch_id" type="string" required="no">
        <cfargument name="startdate" type="date" required="no">
        <cfargument name="finishdate" type="date" required="no">
        <cfargument name="get_with_agenda" type="boolean" required="no">
        <cfargument name="type" type="string" required="no" default="">
        <cfargument name="company_cat_id" type="string" required="no" default="">
        <cfargument name="limitation_emp_id" type="any" required="no" default="">
    
        <cfquery name="task_list" datasource="#dsn#">
        	<cfif (not len(arguments.type) or arguments.type is "0" or isDefined("arguments.employee_id") and len(arguments.employee_id)) and not isDefined("arguments.partner_id")>
            	<cfif isDefined("arguments.limitation_emp_id") and len(arguments.limitation_emp_id)>
                    DECLARE @authorizedBranchesAndDepartments TABLE ( branchID int, departmentID int );
                    INSERT INTO @authorizedBranchesAndDepartments
                    SELECT 
                        EPB.BRANCH_ID,
                        EPB.DEPARTMENT_ID
                    FROM
                        EMPLOYEE_POSITION_BRANCHES EPB,
                        BRANCH B
                    WHERE 
                        EPB.BRANCH_ID = B.BRANCH_ID AND
                        B.COMPANY_ID = #arguments.company_id# AND
                        EPB.POSITION_CODE = (SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #arguments.limitation_emp_id#);
                        
                    DECLARE @posHierarchy TABLE ( posCode int );
                    
                    INSERT INTO @posHierarchy SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #arguments.limitation_emp_id#;
                    
                    INSERT INTO @posHierarchy
                    SELECT 
                        POSITION_CODE 
                    FROM 
                        EMPLOYEE_POSITIONS EP,
                        @posHierarchy PH
                    WHERE 
                        (EP.UPPER_POSITION_CODE = PH.posCode OR EP.UPPER_POSITION_CODE2 = PH.posCode) AND
                        EP.EMPLOYEE_ID IS NOT NULL AND
                        EP.POSITION_CODE NOT IN (SELECT posCode FROM @posHierarchy)
                </cfif>
            
                SELECT
                    0 isPartner,
                    E.EMPLOYEE_ID personID,
                    E.EMPLOYEE_NAME personName,
                    E.EMPLOYEE_SURNAME personSurname,
                    PW.WORK_ID taskID,
                    CAST(PW.WORK_HEAD as nvarchar(MAX)) title,
                    PW.WORK_STATUS isActive,
                    PW.WORK_PRIORITY_ID priority,
                    PW.TO_COMPLETE completedRate,
                    PW.TARGET_START targetStartDate,
                    PW.TARGET_FINISH targetFinishDate,
                    PW.REAL_START startDate,
                    PW.REAL_FINISH finishDate,
                    PW.RECORD_DATE,
                    PW.OUTSRC_CMP_ID companyID,
                    PRO_PROJECTS.PROJECT_NUMBER projectNumber,
					PRO_PROJECTS.PROJECT_HEAD projectTitle,
                    PRO_PROJECTS.PROJECT_EMP_ID projectEmpID,
                    C.NICK_NAME companyName,
					NULL companyCatID
                FROM
                    PRO_WORKS PW LEFT JOIN PRO_PROJECTS ON PW.PROJECT_ID = PRO_PROJECTS.PROJECT_ID,
                    EMPLOYEES E,
                    EMPLOYEE_POSITIONS EP,
                    OUR_COMPANY C,
                    BRANCH B,
                    DEPARTMENT D
                WHERE
                    PW.PROJECT_EMP_ID = E.EMPLOYEE_ID AND
                    E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND
                    EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND
                    D.BRANCH_ID = B.BRANCH_ID AND
                    B.COMPANY_ID = C.COMP_ID AND
                    PRO_PROJECTS.PROJECT_EMP_ID IS NOT NULL AND
                    <cfif isDefined('arguments.branch_id') and len(arguments.branch_id)>
                        D.BRANCH_ID = #arguments.branch_id# AND
                        <cfif isDefined('arguments.department_id') and len(arguments.department_id)>
                            D.DEPARTMENT_ID = #arguments.department_id# AND
                        </cfif>
                        D.DEPARTMENT_STATUS = 1 AND
                    </cfif>
                    <cfif isDefined('arguments.project_id') and len(arguments.project_id)>PW.PROJECT_ID = '#arguments.project_id#' AND</cfif>
                    <cfif isDefined('arguments.employee_id') and len(arguments.employee_id)>PW.PROJECT_EMP_ID = #arguments.employee_id# AND</cfif>
                    (
                        (
                        PW.TARGET_START >= #arguments.startdate# AND
                        PW.TARGET_START <= #arguments.finishdate#
                        )
                    OR
                        (
                        PW.TARGET_START <= #arguments.startdate# AND
                        PW.TARGET_FINISH >= #arguments.startdate#
                        )
                    ) AND
                    PW.WORK_CURRENCY_ID <> -3 /*AND
                    E.EMPLOYEE_STATUS = 1*/
                    <cfif isDefined("arguments.limitation_emp_id") and len(arguments.limitation_emp_id)>
                    	AND
                        (
	                        B.BRANCH_ID IN (SELECT branchID FROM @authorizedBranchesAndDepartments) OR
                            D.DEPARTMENT_ID IN (SELECT departmentID FROM @authorizedBranchesAndDepartments)
                        )
                        AND EP.POSITION_CODE IN (SELECT posCode FROM @posHierarchy)
                    </cfif>
			</cfif>
            <cfif not len(arguments.type) and not isDefined("arguments.employee_id") and not isDefined("arguments.partner_id")>UNION</cfif>
            <cfif (not len(arguments.type) or arguments.type is "1" or isDefined("arguments.partner_id") and len(arguments.partner_id)) and not isDefined("arguments.employee_id")>
                SELECT
                    1 isPartner,
                    CP.PARTNER_ID personID,
                    CP.COMPANY_PARTNER_NAME personName,
                    CP.COMPANY_PARTNER_SURNAME personSurname,
                    PW.WORK_ID taskID,
                    CAST(PW.WORK_HEAD as nvarchar(MAX)) title,
                    PW.WORK_STATUS isActive,
                    PW.WORK_PRIORITY_ID priority,
                    PW.TO_COMPLETE completedRate,
                    PW.TARGET_START targetStartDate,
                    PW.TARGET_FINISH targetFinishDate,
                    PW.REAL_START startDate,
                    PW.REAL_FINISH finishDate,
                    PW.RECORD_DATE,
                    PW.OUTSRC_CMP_ID companyID,
                    PRO_PROJECTS.PROJECT_NUMBER projectNumber,
					PRO_PROJECTS.PROJECT_HEAD projectTitle,
                    PRO_PROJECTS.PROJECT_EMP_ID projectEmpID,
					C.NICKNAME companyName,
                    C.COMPANYCAT_ID companyCatID
                FROM
                    PRO_WORKS PW LEFT JOIN PRO_PROJECTS ON PW.PROJECT_ID = PRO_PROJECTS.PROJECT_ID,
                    COMPANY_PARTNER CP,
					COMPANY C
                WHERE
                    C.COMPANY_ID = CP.COMPANY_ID AND
                    PRO_PROJECTS.PROJECT_EMP_ID IS NOT NULL AND
					<cfif len(arguments.company_cat_id)>C.COMPANYCAT_ID = #arguments.company_cat_id# AND</cfif>
					<cfif isDefined('arguments.project_id') and len(arguments.project_id)>PW.PROJECT_ID = '#arguments.project_id#' AND</cfif>
                    <cfif isDefined('arguments.partner_id') and len(arguments.partner_id)>CP.PARTNER_ID = '#arguments.partner_id#' AND</cfif>
                    (
                        (
                        PW.TARGET_START >= #arguments.startdate# AND
                        PW.TARGET_START <= #arguments.finishdate#
                        )
                    OR
                        (
                        PW.TARGET_START <= #arguments.startdate# AND
                        PW.TARGET_FINISH >= #arguments.startdate#
                        )
                    ) AND
                    PW.OUTSRC_PARTNER_ID = CP.PARTNER_ID AND
                    PW.WORK_CURRENCY_ID <> -3
			</cfif>
            ORDER BY
				companyName, personName, personSurname
        </cfquery>
        
        <cfset result = ArrayNew(1)>
        <cfloop query="task_list">
            <cfset isExist = false>
            <cfset task = StructNew()>
            <cfset task["taskID"] = task_list.taskID>
            <cfset task["empID"] = task_list.personID>
            <cfset task["empIsPartner"] = task_list.isPartner>
            <cfset task["companyID"] = task_list.companyID>
            <cfset task["title"] = task_list.title>
            <cfset task["type"] = "task">
            <cfset task["isActive"] = task_list.isActive>
            <cfset task["priority"] = task_list.priority>
            <cfset task["completedRate"] = task_list.completedRate>
            <cfset task["targetStartDate"] = task_list.targetStartDate>
            <cfset task["targetFinishDate"] = task_list.targetFinishDate>
            <cfset task["startDate"] = task_list.startDate>
            <cfset task["finishDate"] = task_list.finishDate>
            <cfset task["projectNumber"] = task_list.projectNumber>
            <cfset task["projectTitle"] = task_list.projectTitle>
            <cfset task["projectEmpID"] = task_list.projectEmpID>
            
            <cfif arraylen(result)>
                <cfloop from="1" to="#arraylen(result)#" index="i">
                    <cfif result[i].id eq task_list.personID and result[i].isPartner eq task_list.isPartner>
                        <cfset isExist = true>
                        <cfset result[i].list[arraylen(result[i].list) + 1] = task>
                        <cfbreak>
                    </cfif>
                </cfloop>
            </cfif>
            
            <cfif isExist eq false>
                <cfset employeeInfo = StructNew()>
                <cfset employeeInfo["id"] = task_list.personID>
                <cfset employeeInfo["name"] = task_list.personName>
                <cfset employeeInfo["surname"] = task_list.personSurname>
                <cfset employeeInfo["isPartner"] = task_list.isPartner>
                <cfset employeeInfo["compID"] = task_list.companyID>
                <cfset employeeInfo["compName"] = task_list.companyName>
           		<cfset employeeInfo["compCatID"] = task_list.companyCatID>
                <cfset employeeInfo["list"] = ArrayNew(1)>
                <cfset employeeInfo["list"][arraylen(employeeInfo.list) + 1] = task>
                <cfset result[arraylen(result) + 1] = employeeInfo>
            </cfif>
        </cfloop>
        
        <cfif isDefined('arguments.get_with_agenda') and arguments.get_with_agenda eq true>
            <cfset agenda = getAgenda(arguments.employee_id, arguments.startdate, arguments.finishdate, arguments.project_id)>
            
            <cfif not arraylen(result)>
            	<cfset employeeInfo = StructNew()>
                <cfset employeeInfo["list"] = ArrayNew(1)>
                <cfset result[1] = employeeInfo>
            </cfif>
            
            <cfloop query="agenda">
                <cfset task = StructNew()>
                <cfset task["taskID"] = agenda.taskID>
                <cfset task["empID"] = arguments.employee_id>
                <cfset task["empIsPartner"] = 0>
           		<cfset task["companyID"] = "">
                <cfset task["title"] = agenda.title>
                <cfset task["type"] = agenda.type>
                <cfset task["isActive"] = true>
                <cfset task["priority"] = ''>
                <cfset task["completedRate"] = '100'>
                <cfset task["targetStartDate"] = agenda.targetStartDate>
                <cfset task["targetFinishDate"] = agenda.targetFinishDate>
                <cfset task["startDate"] = agenda.startDate>
                <cfset task["finishDate"] = agenda.finishDate>
            
                <cfset result[1].list[arraylen(result[1].list) + 1] = task>
            </cfloop>
        </cfif>
        
        <cfreturn result>
    </cffunction>
    
    <!--- UPDATE AGENDA ITEM --->
    <cffunction name="updateAgendaItems" access="remote" returntype="boolean" output="no">
    	<cfargument name="employee_id" type="numeric" required="yes">
        <cfargument name="item_list" type="array" required="yes">
        <!--- <cfargument name="type" type="string" required="yes">
        <cfargument name="target_start_date" type="date" required="yes">
        <cfargument name="target_finish_date" type="date" required="yes">
        <cfargument name="completed_rate" type="numeric" required="yes">
        <cfargument name="target_emp_id" type="numeric" required="no">
        <cfargument name="target_emp_is_partner" type="numeric" required="no">
        <cfargument name="outsrc_cmp_id" type="numeric" required="no"> --->

		<cftry>
            <cfloop from="1" to="#ArrayLen(arguments.item_list)#" index="i">
                <cfset item = arguments.item_list[i]>
                <cfset nowValue = now()>
                
                <cfif item.type eq "task">
                    <cfquery name="update_task" datasource="#dsn#">
                        UPDATE
                            PRO_WORKS
                        SET
                            TARGET_START = #item.startDate#,
                            TARGET_FINISH = #item.finishDate#,
                            TO_COMPLETE = #item.completedRate#,
                            UPDATE_DATE = #nowValue#,
                            UPDATE_AUTHOR = #arguments.employee_id#,
                            <cfif isDefined('item.targetEmpID') and len('item.targetEmpID')>
                                <cfif isDefined('item.targetEmpIsPartner') and item.targetEmpIsPartner eq 0>
                                    PROJECT_EMP_ID = #item.targetEmpID#,
                                    OUTSRC_PARTNER_ID = NULL,
                                    OUTSRC_CMP_ID = NULL,
                                <cfelseif isDefined('item.targetEmpIsPartner') and item.targetEmpIsPartner eq 1>
                                    OUTSRC_PARTNER_ID = #item.targetEmpID#,
                                    OUTSRC_CMP_ID = #item.outSrcCompID#,
                                    PROJECT_EMP_ID = NULL,
                                </cfif>
                            </cfif>
                            UPDATE_IP = '#cgi.REMOTE_ADDR#'
                        WHERE
                            WORK_ID = #item.itemID#
                    </cfquery>
                <cfelseif item.type eq "event">
                    <cfquery name="update_event" datasource="#dsn#">
                        UPDATE
                            EVENT
                        SET
                            STARTDATE = #item.startDate#,
                            FINISHDATE = #item.finishDate#,
                            UPDATE_DATE = #nowValue#,
                            UPDATE_EMP = #arguments.employee_id#,
                            UPDATE_IP = '#cgi.REMOTE_ADDR#'
                        WHERE
                            EVENT_ID = #item.itemID#
                    </cfquery>
                <cfelseif item.type eq "offtime">
                    <cfquery name="update_offtime" datasource="#dsn#">
                        UPDATE
                            OFFTIME
                        SET
                            STARTDATE = #item.startDate#,
                            FINISHDATE = #item.finishDate#,
                            UPDATE_DATE = #nowValue#,
                            UPDATE_EMP = #arguments.employee_id#,
                            UPDATE_IP = '#cgi.REMOTE_ADDR#'
                        WHERE
                            OFFTIME_ID = #item.itemID#
                    </cfquery>
                <cfelseif item.type eq "ssk_fee">
                    <cfquery name="update_ssk_fee" datasource="#dsn#">
                        UPDATE
                            EMPLOYEES_SSK_FEE
                        SET
                            FEE_DATEOUT = #item.startDate#,
                            UPDATE_DATE = #nowValue#,
                            UPDATE_EMP = #arguments.employee_id#,
                            UPDATE_IP = '#cgi.REMOTE_ADDR#'
                        WHERE
                            FEE_ID = #item.itemID#
                    </cfquery>
                <cfelseif item.type eq "training">
                    <cfquery name="update_training" datasource="#dsn#">
                        UPDATE
                            TRAINING_CLASS
                        SET
                            START_DATE = #item.startDate#,
                            FINISH_DATE = #item.finishDate#,
                            UPDATE_DATE = #nowValue#,
                            UPDATE_EMP = #arguments.employee_id#,
                            UPDATE_IP = '#cgi.REMOTE_ADDR#'
                        WHERE
                            CLASS_ID = #item.itemID#
                    </cfquery>
                </cfif>
            </cfloop>
            	
            <cfcatch>
            	<cfreturn "#cfcatch.Message#\n\nDetail: #cfcatch.Detail#\n\nRaw Trace: #cfcatch.tagcontext[1].raw_trace#\n\nRecord index: #i#">
            </cfcatch>
        </cftry>
        
        <cfreturn true>
    </cffunction>
</cfcomponent>