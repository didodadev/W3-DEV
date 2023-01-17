<!--- 
	amac            : gelen project_name parametresine göre PROJECT_HEAD,PROJECT_ID bilgisini getirmek
	parametre adi   : project_name
	kullanim        : get_project('Proje') 
	Yazan           : B.Kuz
	Tarih           : 20070713
 --->
<cfscript>
	CreateCompenent = createObject("component", "/workdata/get_control_branch_project_info");
	is_control_branch_project = CreateCompenent.get_control_branch_project_info_fnc();
</cfscript>
<cffunction name="get_project" access="public" returnType="query" output="no">
	<cfargument name="project_name" required="yes" type="string">
	<cfargument name="maxrows" required="yes" type="string" default="-1"><!--- -1 (All) yerine kullanilabilir FBS --->
		<cfquery name="get_project_" datasource="#DSN#" maxrows="-1"><!--- maxrows="#arguments.maxrows#" --->
			SELECT
				PP.PROJECT_ID,
                PP.PROJECT_HEAD,
				PP.PROJECT_NUMBER,
				CONVERT(CHAR(10),TARGET_START,103) AS TARGET_START,
                CONVERT(CHAR(10),TARGET_FINISH,103) AS TARGET_FINISH,					
				C.COMPANY_ID,
				C.FULLNAME,
				CP.PARTNER_ID,
				<cfif database_type is 'MSSQL'>
				CP.COMPANY_PARTNER_NAME + ' ' + CP.COMPANY_PARTNER_SURNAME AS MEMBER_PARTNER_NAME,
				C.FULLNAME + ' - ' + CP.COMPANY_PARTNER_NAME + ' ' + CP.COMPANY_PARTNER_SURNAME AS MEMBER_PARTNER_NAME2,
				<cfelseif database_type is 'DB2'>
				CP.COMPANY_PARTNER_NAME || ' ' || CP.COMPANY_PARTNER_SURNAME AS MEMBER_PARTNER_NAME,
				C.FULLNAME || ' - ' || CP.COMPANY_PARTNER_NAME || ' ' || CP.COMPANY_PARTNER_SURNAME AS MEMBER_PARTNER_NAME2,
				</cfif>
                PP.EXPENSE_CODE,
                EX.EXPENSE_ID,
                EX.EXPENSE,
                CON.CONSUMER_ID,
                CASE WHEN PP.COMPANY_ID IS NOT NULL THEN C.FULLNAME WHEN PP.CONSUMER_ID IS NOT NULL THEN CON.CONSUMER_NAME + ' ' + CON.CONSUMER_SURNAME END AS MEMBER_NAME
			FROM 
				PRO_PROJECTS PP
                LEFT JOIN #dsn2_alias#.EXPENSE_CENTER EX ON EX.EXPENSE_CODE = PP.EXPENSE_CODE
				LEFT JOIN COMPANY C ON PP.COMPANY_ID = C.COMPANY_ID
				LEFT JOIN COMPANY_PARTNER CP ON PP.COMPANY_ID = CP.COMPANY_ID AND PP.PARTNER_ID = CP.PARTNER_ID
				LEFT JOIN CONSUMER CON ON PP.CONSUMER_ID = CON.CONSUMER_ID
			WHERE
				PP.PROJECT_STATUS = 1 AND
				(PP.COMPANY_ID IS NOT NULL OR PP.CONSUMER_ID IS NOT NULL) AND
                PP.PROCESS_CAT IN
                (
                    SELECT  
                        SMC.MAIN_PROCESS_CAT_ID
                    FROM 
                        SETUP_MAIN_PROCESS_CAT SMC,
                        SETUP_MAIN_PROCESS_CAT_ROWS SMR,
                        EMPLOYEE_POSITIONS
                    WHERE
                        SMC.MAIN_PROCESS_CAT_ID=SMR.MAIN_PROCESS_CAT_ID AND
                        <cfif isDefined('session.ep.userid')>
                            EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND 
                        </cfif>
                        ( EMPLOYEE_POSITIONS.POSITION_CAT_ID = SMR.MAIN_POSITION_CAT_ID OR EMPLOYEE_POSITIONS.POSITION_CODE=SMR.MAIN_POSITION_CODE )
                )
			    AND 
                (PROJECT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.project_name#%"> OR
				PROJECT_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.project_name#%">)
				<cfif isDefined("is_control_branch_project") and is_control_branch_project eq 1>
					<cfif isDefined('session.ep.position_code')>
						AND PP.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
					</cfif>
				</cfif>
		UNION ALL
			SELECT
				PROJECT_ID,
				PROJECT_HEAD,
				PROJECT_NUMBER,
				CONVERT(CHAR(10),TARGET_START,103) AS TARGET_START,
                CONVERT(CHAR(10),TARGET_FINISH,103) AS TARGET_FINISH,
				'' COMPANY_ID,
				'' FULLNAME,
				'' PARTNER_ID,
				'' MEMBER_PARTNER_NAME,
				'' MEMBER_PARTNER_NAME2,
                PRO_PROJECTS.EXPENSE_CODE,
                EX.EXPENSE_ID,
                EX.EXPENSE,
                '' CONSUMER_ID,
                '' MEMBER_NAME
			FROM 
				PRO_PROJECTS
                	LEFT JOIN #dsn2_alias#.EXPENSE_CENTER EX ON EX.EXPENSE_CODE = PRO_PROJECTS.EXPENSE_CODE
			WHERE
				PROJECT_STATUS = 1 AND
				(PRO_PROJECTS.COMPANY_ID IS NULL OR PRO_PROJECTS.COMPANY_ID = '') AND
				(PRO_PROJECTS.CONSUMER_ID IS NULL OR PRO_PROJECTS.CONSUMER_ID = '') AND
                PROCESS_CAT IN
                (
                    SELECT  
                        SMC.MAIN_PROCESS_CAT_ID
                    FROM 
                        SETUP_MAIN_PROCESS_CAT SMC,
                        SETUP_MAIN_PROCESS_CAT_ROWS SMR,
                        EMPLOYEE_POSITIONS
                    WHERE
                        SMC.MAIN_PROCESS_CAT_ID=SMR.MAIN_PROCESS_CAT_ID AND
                        <cfif isDefined('session.ep.userid')>
                            EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND 
                        </cfif>
                        ( EMPLOYEE_POSITIONS.POSITION_CAT_ID = SMR.MAIN_POSITION_CAT_ID OR EMPLOYEE_POSITIONS.POSITION_CODE=SMR.MAIN_POSITION_CODE )
                )
			    AND 
				(PROJECT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.project_name#%"> OR
				PROJECT_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.project_name#%">)
				<cfif isDefined("is_control_branch_project") and is_control_branch_project eq 1>
					<cfif isDefined('session.ep.position_code')>
						AND PRO_PROJECTS.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
					</cfif>
				</cfif>
			ORDER BY PROJECT_HEAD
		</cfquery>
	<cfreturn get_project_>
</cffunction>