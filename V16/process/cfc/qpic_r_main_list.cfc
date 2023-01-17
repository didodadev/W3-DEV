<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="get_modules" access="public" returntype="query" >
        <cfquery name="get_modules" datasource="#dsn#">
            SELECT 
                M.MODULE_ID, 
				M.MODUL_NO,
                M.MODULE_SHORT_NAME,
                ISNULL(Replace(SLT.ITEM_#UCASE(session.ep.language)#,'''',''),M.MODULE) AS MODULE
            FROM MODULES M
            JOIN SETUP_LANGUAGE_TR AS SLT ON M.MODULE_DICTIONARY_ID = SLT.DICTIONARY_ID
            WHERE 
                M.MODULE_SHORT_NAME <> '' 
            ORDER BY 
                MODULE
        </cfquery>
        <cfreturn get_modules>
    </cffunction>

    <cffunction name="get_company" access="public" returntype="query" >
        <cfquery name="get_company" datasource="#dsn#">
            SELECT COMP_ID,NICK_NAME FROM OUR_COMPANY ORDER BY NICK_NAME
        </cfquery>
        <cfreturn get_company>
    </cffunction>

    <cffunction name="get_process" access="public" returntype="query" >
        <cfquery name="get_process" datasource="#dsn#">
            SELECT
                PM.PROCESS_MAIN_ID,
                PM.PROCESS_MAIN_HEADER
            FROM
                PROCESS_MAIN PM
            WHERE
                PM.PROCESS_MAIN_ID IS NOT NULL
        </cfquery>
        <cfreturn get_process>
    </cffunction>
    <cffunction name="get_process_id" access="public" returntype="query" >
        <cfargument name="process" type="any" default="">
        <cfquery name="get_process_id" datasource="#dsn#">
            SELECT PROCESS_ID FROM PROCESS_MAIN_ROWS WHERE PROCESS_MAIN_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process#"> AND PROCESS_ID IS NOT NULL 
        </cfquery>
        <cfreturn get_process_id>
    </cffunction>
 <cffunction name="get_main_process" access="public" returntype="query" >
        <cfargument name="process_id" type="any" default="">
        <cfquery name="get_main_process" datasource="#dsn#">
            SELECT PROCESS_MAIN_HEADER,PM.PROCESS_MAIN_ID FROM PROCESS_MAIN_ROWS PMR LEFT JOIN PROCESS_MAIN PM ON PMR.PROCESS_MAIN_ID=PM.PROCESS_MAIN_ID WHERE PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_id#">
        </cfquery>
        <cfreturn get_main_process>
    </cffunction>

    <cffunction name="get_rows" access="public" returntype="query" >
        <cfargument name="author_id" type="any" default="">
        <cfargument name="authority_type" type="any" default="">
        <cfquery name="GET_ROWS" datasource="#DSN#">
			<cfif arguments.authority_type eq 1 or arguments.authority_type eq 0>
				SELECT
					PROCESS_ROW_ID
				FROM
					PROCESS_TYPE_ROWS_POSID
				WHERE
					PRO_POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.author_id#"> AND
					PROCESS_ROW_ID IS NOT NULL
			</cfif>
			<cfif arguments.authority_type eq 0>
				UNION
			</cfif>
			<cfif arguments.authority_type eq 2 or arguments.authority_type eq 0>
				SELECT
					PROCESS_ROW_ID
				FROM
					PROCESS_TYPE_ROWS_CAUID
				WHERE
					CAU_POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.author_id#"> AND
					PROCESS_ROW_ID IS NOT NULL
			</cfif>
			<cfif arguments.authority_type eq 0>
				UNION
			</cfif>
			<cfif arguments.authority_type eq 3 or arguments.authority_type eq 0>
				SELECT
					PROCESS_ROW_ID
				FROM
					PROCESS_TYPE_ROWS_INFID
				WHERE
					INF_POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.author_id#"> AND
					PROCESS_ROW_ID IS NOT NULL
			</cfif>
		</cfquery>
        <cfreturn get_rows>
    </cffunction>
    <cffunction name="get_process_type" access="public" returntype="query">
        <cfargument name="module" type="any" default="">
        <cfargument name="keyword" type="any" default="">
        <cfargument name="record_name" type="any" default="">
        <cfargument name="is_active" type="any" default="">
        <cfargument name="record_id" type="any" default="">
        <cfargument name="s_process_id" type="any" default="">
        <cfargument name="c_id" type="any" default="">
        <cfargument name="company_id" type="any" default="">
        <cfargument name="get_pro_id_recordcount" type="any" default="">
		<cfargument name="get_pro_id_process_id" type="any" default="">
		<cfargument name="department_id" type="any" default="">
		<cfargument name="department" type="any" default="">
		<cfargument name="up_department_id" type="any" default="">
		<cfargument name="up_department" type="any" default="">
		<cfargument name="emp_id" type="any" default="">
		<cfargument name="employee_name" type="any" default="">
		<cfargument name="friendly_url" type="any" default="">
        <cfquery name="GET_PROCESS_TYPE" datasource="#DSN#">
		    SELECT
				PROCESS_TYPE.PROCESS_ID,
				#dsn#.Get_Dynamic_Language(PROCESS_TYPE.PROCESS_ID,'#session.ep.language#','PROCESS_TYPE','PROCESS_NAME',NULL,NULL,PROCESS_TYPE.PROCESS_NAME) AS PROCESS_NAME,
				PROCESS_TYPE.FACTION,
				PROCESS_TYPE.IS_ACTIVE,
				PROCESS_TYPE.MAIN_ACTION_FILE,
				PROCESS_TYPE.MAIN_FILE,
				PROCESS_TYPE.DETAIL,
				PROCESS_TYPE.UPPER_DEP_ID,
				PROCESS_TYPE.RESP_EMP_ID,
				EMPLOYEES.EMPLOYEE_NAME+' '+EMPLOYEES.EMPLOYEE_SURNAME NAME,
				DEPARTMENT.DEPARTMENT_HEAD
			FROM
				PROCESS_TYPE
				LEFT JOIN DEPARTMENT ON PROCESS_TYPE.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
				LEFT JOIN EMPLOYEES ON PROCESS_TYPE.RESP_EMP_ID = EMPLOYEES.EMPLOYEE_ID
			WHERE
				PROCESS_TYPE.PROCESS_ID IS NOT NULL
				<cfif len(arguments.module)>
					AND PROCESS_TYPE.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.module#%">
				</cfif>
				<cfif len(arguments.up_department_id) and len(arguments.up_department)>
					AND PROCESS_TYPE.UPPER_DEP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.up_department_id#">
				</cfif>
				<cfif len(arguments.department) and len(arguments.department_id)>
					AND PROCESS_TYPE.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#"> 
				</cfif>
				<cfif len(arguments.emp_id) and len(arguments.employee_name)>
					AND PROCESS_TYPE.RESP_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.emp_id#"> 
				</cfif>
					AND PROCESS_ID IN
						(
						SELECT 
							PTOC.PROCESS_ID
						FROM 
							PROCESS_TYPE_OUR_COMPANY PTOC
						WHERE 
							PTOC.PROCESS_ID = PROCESS_TYPE.PROCESS_ID 
							<cfif len(arguments.company_id)>
								AND PTOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"> 
							<cfelseif len(arguments.c_id)>
								AND PTOC.OUR_COMPANY_ID IN(#arguments.c_id#)
							</cfif>
						)
				<cfif len(arguments.keyword)>
					AND 
					(
						(PROCESS_TYPE.PROCESS_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">)
						OR
						(PROCESS_TYPE.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">)
						<cfif len(arguments.friendly_url)>
							OR PROCESS_TYPE.FRIENDLY_URL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.friendly_url#%">
						</cfif>
					)
				</cfif>
				
				<cfif isdefined("arguments.record_id") and len(arguments.record_id) and IsDefined("arguments.record_name") and len(arguments.record_name)>
					AND
						PROCESS_TYPE.RECORD_EMP=#arguments.record_id#
				</cfif>
				<cfif isdefined("arguments.s_process_id") and len(arguments.s_process_id)>
					AND
						PROCESS_TYPE.PROCESS_ID IN (#arguments.s_process_id#)
				</cfif>
				<cfif len(arguments.is_active)>AND PROCESS_TYPE.IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_smallint" value="#arguments.is_active#"></cfif>
				<cfif (#arguments.get_pro_id_recordcount#)>AND PROCESS_TYPE.PROCESS_ID IN (#arguments.get_pro_id_process_id#)</cfif>
			ORDER BY
				PROCESS_NAME	
		</cfquery>
        <cfreturn get_process_type>
    </cffunction>
    <cffunction name="get_our_company" access="public" returntype="query">
        <cfargument name="list_process" type="any" default="">
        <cfquery name="get_our_company" datasource="#dsn#">
			SELECT 
				PTOC.OUR_COMPANY_ID,
				PTOC.PROCESS_ID,
				OC.COMP_ID,
				OC.NICK_NAME  
			FROM 
				PROCESS_TYPE_OUR_COMPANY PTOC,
				OUR_COMPANY OC 
			WHERE 
				PTOC.OUR_COMPANY_ID = OC.COMP_ID AND
				PROCESS_ID IN (#arguments.list_process#)
			ORDER BY 
				OC.NICK_NAME
		</cfquery>
        <cfreturn get_our_company>
    </cffunction>
	<cffunction name="get_contents" access="public" returntype="query">
        <cfargument name="process_id" type="any" default="">
		<cfquery name="GET_CONTENTS" datasource="#dsn#">
			SELECT CONTENT_ID FROM CONTENT_RELATION WHERE  ACTION_TYPE='PROCESS_ID' AND ACTION_TYPE_ID = #arguments.process_id# 
		</cfquery>
        <cfreturn get_contents>
    </cffunction>
	<cffunction name="get_stages" access="public" returntype="query">
        <cfargument name="process_id" type="any" default="">
		<cfquery name="GET_STAGES" datasource="#dsn#">
			SELECT #dsn#.Get_Dynamic_Language(PROCESS_ROW_ID,'#session.ep.language#','PROCESS_TYPE_ROWS','STAGE',NULL,NULL,STAGE) AS STAGE,* FROM PROCESS_TYPE_ROWS WHERE PROCESS_ID = #arguments.process_id# ORDER BY LINE_NUMBER
		</cfquery>
        <cfreturn get_stages>
    </cffunction>
	 <cffunction name="get_all_groups" access="public" returntype="query">
        <cfargument name="process_row_id" type="any" default="">
        <cfquery name="GET_ALL_GROUPS" datasource="#dsn#">
			SELECT * FROM PROCESS_TYPE_ROWS_WORKGRUOP WHERE PROCESS_ROW_ID IN (<cfqueryparam cfsqltype = "CF_SQL_INTEGER" value = "#arguments.process_row_id#">)
		</cfquery>
        <cfreturn get_all_groups>
    </cffunction>
	<cffunction name="get_pro" access="public" returntype="numeric">
		<cfargument name="workgroup_id" type="any" default="">
		<cfif not len(arguments.workgroup_id)>
			<cfreturn 0>
		</cfif>
       <cfquery name="GET_PRO" datasource="#dsn#">
			SELECT DISTINCT
				PROCESS_TYPE_ROWS_POSID.PRO_POSITION_ID
			FROM 
				PROCESS_TYPE_ROWS_POSID,
				EMPLOYEE_POSITIONS
			WHERE 
				PROCESS_TYPE_ROWS_POSID.WORKGROUP_ID = <cfqueryparam cfsqltype = "CF_SQL_INTEGER" value = "#arguments.workgroup_id#"> AND
				EMPLOYEE_POSITIONS.POSITION_ID = PROCESS_TYPE_ROWS_POSID.PRO_POSITION_ID
	
		</cfquery>
		<cfquery name="GET_PRO_PAR" datasource="#DSN#">
			SELECT
				PROCESS_TYPE_ROWS_POSID.PRO_PARTNER_ID
		
			FROM 
				PROCESS_TYPE_ROWS_POSID,
				COMPANY_PARTNER,
				COMPANY
			WHERE 
				PROCESS_TYPE_ROWS_POSID.WORKGROUP_ID = <cfqueryparam cfsqltype = "CF_SQL_INTEGER" value = "#arguments.workgroup_id#"> AND
				COMPANY_PARTNER.PARTNER_ID = PROCESS_TYPE_ROWS_POSID.PRO_PARTNER_ID AND
				COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID

		</cfquery>
		<cfset makerCount=GET_PRO.recordcount+GET_PRO_PAR.recordcount>
        <cfreturn makerCount>
	</cffunction>
	<cffunction name="get_workflowdesigner" access="public" returntype="query">
		<cfargument name="process_id" type="any" default="">
		<cfargument name="action_section" type="any" default="PROCESS_TYPE">
		<cfquery name="get_workflowdesigner" datasource="#dsn#">
			SELECT ACTION_SECTION,RELATIVE_ID FROM VISUAL_DESIGNER WHERE ACTION_SECTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_section#"> AND RELATIVE_ID = <cfqueryparam cfsqltype = "CF_SQL_INTEGER" value = "#arguments.process_id#">
		</cfquery>
		<cfreturn get_workflowdesigner>
	</cffunction>
</cfcomponent>
