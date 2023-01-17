<cfquery name="GET_GRPS" datasource="#DSN#">
	SELECT GROUP_ID FROM USERS WHERE POSITIONS LIKE '%,#session.ep.position_code#,%'
</cfquery>
<cfquery name="GET_WRKGROUPS" datasource="#DSN#">
	SELECT WORKGROUP_ID FROM WORKGROUP_EMP_PAR WHERE POSITION_CODE = #session.ep.position_code#	
</cfquery>
<cfset grps = valuelist(get_grps.group_id)>
<cfset wrkgroups = valuelist(get_wrkgroups.workgroup_id)>
<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT D.BRANCH_ID, D.DEPARTMENT_ID FROM DEPARTMENT D, EMPLOYEE_POSITIONS EP WHERE EP.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND  EP.DEPARTMENT_ID = D.DEPARTMENT_ID 
</cfquery>
<cfquery name="GET_DAILY_EVENTS" datasource="#DSN#">
	SELECT 
		EVENT.EVENT_TO_POS,
		EVENT.EVENT_CC_POS,
		EVENT.EVENT_ID,
		EVENT.STARTDATE,
		EVENT.FINISHDATE,
		EVENT_CAT.EVENTCAT,
		EVENT_CAT.COLOUR,
		EVENT.VALID,
		EVENT.VALID_EMP,
		EVENT.RECORD_EMP,
		EVENT.UPDATE_EMP,
		EVENT.RECORD_PAR,
		EVENT.UPDATE_PAR,
		EVENT.EVENT_HEAD,
		EVENT.EVENT_STAGE,
		EVENT.EVENT_PLACE_ID,
		EVENT.EVENT_DETAIL,
		EVENT.IS_WIEW_DEPARTMENT,
		EVENT.IS_WIEW_BRANCH,
        EVENT.IS_VIEW_COMPANY,
		EVENT.VIEW_TO_ALL,
		EVENT.EVENT_TO_BRANCH,
		EVENT.VALIDATOR_POSITION_CODE,
        PROCESS_TYPE_ROWS.STAGE
	FROM 
		EVENT,
		EVENT_CAT,
        PROCESS_TYPE_ROWS
	WHERE
		EVENT.EVENT_STAGE = PROCESS_TYPE_ROWS.PROCESS_ROW_ID AND
		EVENT.EVENTCAT_ID = EVENT_CAT.EVENTCAT_ID AND
		(
			( EVENT.STARTDATE >= #attributes.TO_DAY# AND EVENT.STARTDATE < #DATEADD('D',1,attributes.TO_DAY)# ) OR
			( EVENT.FINISHDATE >= #attributes.TO_DAY# AND EVENT.FINISHDATE < #DATEADD('D',1,attributes.TO_DAY)# )
		) 
		AND 
			(
				<cfif isdefined("session.agenda_userid")>
					(
					EVENT.RECORD_EMP = #session.agenda_userid# OR
					EVENT.UPDATE_EMP = #session.agenda_userid# OR
					EVENT.VALID_EMP = #session.agenda_userid# OR
					EVENT.EVENT_TO_POS LIKE '%,#session.agenda_userid#,%' OR
					EVENT.EVENT_CC_POS LIKE '%,#session.agenda_userid#,%'					
					)
				<cfelse>
					(
					EVENT.RECORD_EMP = #session.ep.userid# OR
					EVENT.UPDATE_EMP = #session.ep.userid# OR
					EVENT.VALID_EMP = #session.ep.userid# OR
					EVENT.EVENT_TO_POS LIKE '%,#session.ep.userid#,%' OR
					EVENT.EVENT_CC_POS LIKE '%,#session.ep.userid#,%'
					)
				</cfif>
				<cfloop list="#GRPS#" index="GRP_I">
					OR EVENT.EVENT_TO_GRP LIKE '%,#GRP_I#,%'
				</cfloop>
				<cfloop list="#GRPS#" index="GRP_I">
					OR EVENT.EVENT_CC_GRP LIKE '%,#GRP_I#,%'
				</cfloop>
				<cfloop list="#wrkgroups#" index="WRK">
				  OR EVENT.EVENT_TO_WRKGROUP LIKE '%,#WRK#,%'
				</cfloop>
				<cfloop list="#wrkgroups#" index="WRK">
				  OR EVENT.EVENT_CC_WRKGROUP LIKE '%,#WRK#,%'
				</cfloop>
				OR EVENT.EVENT_TO_BRANCH LIKE '%,#get_branch.branch_id#,%' 
				OR EVENT.EVENT_TO_BRANCH LIKE '#get_branch.branch_id#,%'
				OR EVENT.EVENT_TO_BRANCH LIKE '%,#get_branch.branch_id#'
				OR EVENT.EVENT_TO_BRANCH = '#get_branch.branch_id#'
				<!---<cfif isdefined("is_gundem")>
				OR
				(
					( EVENT.VIEW_TO_ALL = 1 AND EVENT.IS_WIEW_BRANCH = #get_all_agenda_department_branch.branch_id# AND EVENT.IS_WIEW_DEPARTMENT = #get_all_agenda_department_branch.department_id#) OR	
					( EVENT.VIEW_TO_ALL = 1 AND EVENT.IS_WIEW_BRANCH = #get_all_agenda_department_branch.branch_id# AND EVENT.IS_WIEW_DEPARTMENT IS NULL) OR 
					( EVENT.VIEW_TO_ALL = 1 AND EVENT.IS_WIEW_BRANCH IS NULL AND EVENT.IS_WIEW_DEPARTMENT IS NULL)
				)	
				<cfelse>	
				</cfif>--->
				<cfif isdefined('attributes.view_agenda') and attributes.view_agenda eq 1><!--- departman gorsun --->
					OR ( EVENT.IS_WIEW_DEPARTMENT IS NOT NULL AND EVENT.IS_WIEW_DEPARTMENT = #get_all_agenda_department_branch.department_id# )
					OR EVENT.IS_WIEW_DEPARTMENT = #get_all_agenda_department_branch.department_id#
				</cfif>
				<cfif isdefined('attributes.view_agenda') and attributes.view_agenda eq 2><!--- şube görsün --->
					OR ( EVENT.IS_WIEW_BRANCH IS NOT NULL AND EVENT.IS_WIEW_BRANCH = #get_all_agenda_department_branch.branch_id#)
					OR  EVENT.IS_WIEW_DEPARTMENT = #get_all_agenda_department_branch.department_id#
				</cfif>
				<cfif isdefined('attributes.view_agenda') and attributes.view_agenda eq 3><!--- herkes gorsun --->
					OR EVENT.IS_WIEW_BRANCH = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_branch.branch_id#">
					OR EVENT.IS_WIEW_DEPARTMENT = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_branch.department_id#">
                    OR 
                    	(EVENT.IS_VIEW_COMPANY = 1
                        <cfif isdefined("xml_multiple_comp") and xml_multiple_comp eq 1>
                        	AND EVENT.EVENT_ID IN (SELECT EVENT_ID FROM EVENT_COMPANY WHERE COMPANY_ID IN (#my_comp_list#)) 
                        </cfif>
                        )
					OR EVENT.VIEW_TO_ALL = 1
				</cfif>
			)
</cfquery>

<!--- <cfquery name="get_daily_events" datasource="#dsn#">
	SELECT 
		EVENT.EVENT_TO_POS,
		EVENT.EVENT_CC_POS,
		EVENT.EVENT_ID,
		EVENT.STARTDATE,
		EVENT.FINISHDATE,
		EVENT_CAT.EVENTCAT,
		EVENT.VALID,
		EVENT.VALID_EMP,
		EVENT.RECORD_EMP,
		EVENT.UPDATE_EMP,
		EVENT.RECORD_PAR,
		EVENT.UPDATE_PAR,
		EVENT.EVENT_HEAD,
		EVENT.EVENT_STAGE,
		EVENT.EVENT_PLACE_ID,
		EVENT.IS_WIEW_DEPARTMENT,
		EVENT.IS_WIEW_BRANCH,
		EVENT.VIEW_TO_ALL,
		VALIDATOR_POSITION_CODE,
        PROCESS_TYPE_ROWS.STAGE
	FROM 
		EVENT,
		EVENT_CAT,
        PROCESS_TYPE_ROWS
	WHERE
		EVENT.EVENT_STAGE = PROCESS_TYPE_ROWS.PROCESS_ROW_ID AND
        EVENT.EVENTCAT_ID = EVENT_CAT.EVENTCAT_ID AND
		(
			( EVENT.STARTDATE >= #attributes.TO_DAY# AND EVENT.STARTDATE < #DATEADD('D',1,attributes.TO_DAY)# ) OR
			( EVENT.FINISHDATE >= #attributes.TO_DAY# AND EVENT.FINISHDATE < #DATEADD('D',1,attributes.TO_DAY)# )
		) 
		AND 
			(
				<cfif isdefined("session.agenda_userid")>
					(
					EVENT.RECORD_EMP = #session.agenda_userid# OR
					EVENT.UPDATE_EMP = #session.agenda_userid# OR
					EVENT.VALID_EMP = #session.agenda_userid# OR
					EVENT.EVENT_TO_POS LIKE '%,#session.agenda_userid#,%' OR
					EVENT.EVENT_CC_POS LIKE '%,#session.agenda_userid#,%'					
					)
				<cfelse>
					(
					EVENT.RECORD_EMP = #session.ep.userid# OR
					EVENT.UPDATE_EMP = #session.ep.userid# OR
					EVENT.VALID_EMP = #session.ep.userid# OR
					EVENT.EVENT_TO_POS LIKE '%,#session.ep.userid#,%' OR
					EVENT.EVENT_CC_POS LIKE '%,#session.ep.userid#,%'
					)
				</cfif>
				<cfloop list="#GRPS#" index="GRP_I">
					OR EVENT.EVENT_TO_GRP LIKE '%,#GRP_I#,%'
				</cfloop>
				<cfloop list="#GRPS#" index="GRP_I">
					OR EVENT.EVENT_CC_GRP LIKE '%,#GRP_I#,%'
				</cfloop>
				<cfloop list="#wrkgroups#" index="WRK">
				  OR EVENT.EVENT_TO_WRKGROUP LIKE '%,#WRK#,%'
				</cfloop>
				<cfloop list="#wrkgroups#" index="WRK">
				  OR EVENT.EVENT_CC_WRKGROUP LIKE '%,#WRK#,%'
				</cfloop>
				OR
				(
					( EVENT.VIEW_TO_ALL = 1 AND EVENT.IS_WIEW_BRANCH = #get_all_agenda_department_branch.branch_id# AND EVENT.IS_WIEW_DEPARTMENT = #get_all_agenda_department_branch.department_id#) OR	
					( EVENT.VIEW_TO_ALL = 1 AND EVENT.IS_WIEW_BRANCH = #get_all_agenda_department_branch.branch_id# AND EVENT.IS_WIEW_DEPARTMENT IS NULL) OR 
					( EVENT.VIEW_TO_ALL = 1 AND EVENT.IS_WIEW_BRANCH IS NULL AND EVENT.IS_WIEW_DEPARTMENT IS NULL)
				)
			)
			
			
</cfquery>
 --->
