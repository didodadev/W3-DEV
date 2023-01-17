<cfif isdefined("control_all_") and control_all_ eq 1>
	<cfquery name="GET_GRPS" datasource="#DSN#">
		SELECT GROUP_ID FROM USERS WHERE POSITIONS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ep.position_code#,%">
	</cfquery>
	<cfquery name="GET_WRKGROUPS" datasource="#DSN#">
		SELECT WORKGROUP_ID FROM WORKGROUP_EMP_PAR WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">	
	</cfquery>
	<cfset grps = valuelist(get_grps.group_id)>
	<cfset wrkgroups = valuelist(get_wrkgroups.workgroup_id)>
	<cfquery name="GET_BRANCH" datasource="#DSN#">
		SELECT D.BRANCH_ID,D.DEPARTMENT_ID FROM DEPARTMENT D, EMPLOYEE_POSITIONS EP WHERE EP.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND  EP.DEPARTMENT_ID = D.DEPARTMENT_ID 
		AND EP.IS_MASTER= 1
	</cfquery>
</cfif>
<cfquery name="GET_AGENDA_COMPANY" datasource="#DSN#">
    SELECT 
        SETUP_PERIOD.OUR_COMPANY_ID
    FROM
        EMPLOYEE_POSITION_PERIODS,
        EMPLOYEE_POSITIONS,
        SETUP_PERIOD
    WHERE
        EMPLOYEE_POSITIONS.POSITION_ID = EMPLOYEE_POSITION_PERIODS.POSITION_ID
        AND EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
        AND SETUP_PERIOD.PERIOD_ID = EMPLOYEE_POSITION_PERIODS.PERIOD_ID
</cfquery>
<cfset my_comp_list = ValueList(get_agenda_company.our_company_id)>
<!--- query * ile çekilmişti. Alanları tek tek çekerek getirdim, ayrıca work_id bilgisi ynei eklendi. sorun olursa, eksik alan yüzünden olabilir. hgul 20120910--->
<cfquery name="GET_EVENT" datasource="#DSN#">
	SELECT 
		EVENT.EVENT_ID,
		EVENT.EVENT_HEAD,
		EVENT.EVENT_STAGE,
		EVENT.EVENTCAT_ID,
		EVENT.EVENT_DETAIL,
		EVENT.VALID,
		EVENT.VALID_EMP,
		EVENT.VALID_DATE,
		EVENT.WARNING_START,
		EVENT.WARNING_EMAIL,
		EVENT.WARNING_SMS,
		EVENT.EMAIL_WARNED,
		EVENT.PROJECT_ID,
		EVENT.WORK_ID,
		EVENT.CAMP_ID,
		EVENT.VIEW_TO_ALL,
		EVENT.IS_WIEW_BRANCH,
		EVENT.IS_WIEW_DEPARTMENT,
        EVENT.IS_VIEW_COMPANY,
		EVENT.IS_INTERNET,
		EVENT.IS_GOOGLE_CAL,
		EVENT.CREATED_GOOGLE_EVENT_ID,
		EVENT.EVENT_PLACE_ID,
		EVENT.EVENT_TO_BRANCH,
		EVENT.EVENT_TO_CON,
		EVENT.EVENT_TO_POS,
		EVENT.EVENT_TO_PAR,
		EVENT.EVENT_TO_GRP,
		EVENT.EVENT_TO_WRKGROUP,
		EVENT.EVENT_CC_CON,
		EVENT.EVENT_CC_POS,
		EVENT.EVENT_CC_PAR,
		EVENT.EVENT_CC_GRP,
		EVENT.EVENT_CC_WRKGROUP,
		EVENT.LINK_ID,
		EVENT.VALIDATOR_POSITION_CODE,
		EVENT.VALIDATOR_PAR,
		EVENT.RECORD_EMP,
		EVENT.RECORD_PAR,
		EVENT.RECORD_DATE,
		EVENT.UPDATE_EMP,
		EVENT.UPDATE_PAR,
		EVENT.UPDATE_DATE,
		EVENT.STARTDATE,
		EVENT.FINISHDATE,
		EVENT.OPP_ID,
		EVENT.ONLINE_MEET_LINK
	FROM 
		EVENT
	WHERE 
		EVENT.EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_id#">
		<cfif isdefined("control_all_") and control_all_ eq 1>
			AND 
			(
				<cfif isdefined("session.agenda_userid")>
					(
                        EVENT.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.agenda_userid#"> OR
                        EVENT.UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.agenda_userid#"> OR
                        EVENT.VALID_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.agenda_userid#"> OR
                        EVENT.EVENT_TO_POS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.agenda_userid#,%"> OR
                        EVENT.EVENT_CC_POS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.agenda_userid#,%">					
					)
				<cfelse>
					(
                        EVENT.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> OR
                        EVENT.UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> OR
                        EVENT.VALID_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> OR
                        EVENT.EVENT_TO_POS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ep.userid#,%"> OR
                        EVENT.EVENT_CC_POS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ep.userid#,%">
					)
				</cfif>
				<cfloop list="#GRPS#" index="GRP_I">
					OR EVENT.EVENT_TO_GRP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#GRP_I#,%">
				</cfloop>
				<cfloop list="#GRPS#" index="GRP_I">
					OR EVENT.EVENT_CC_GRP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#GRP_I#,%">
				</cfloop>
				<cfloop list="#wrkgroups#" index="WRK">
				  OR EVENT.EVENT_TO_WRKGROUP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#WRK#,%">
				</cfloop>
				<cfloop list="#wrkgroups#" index="WRK">
				  OR EVENT.EVENT_CC_WRKGROUP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#WRK#,%">
				</cfloop>
				OR EVENT.EVENT_TO_BRANCH LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_branch.branch_id#,%"> 
				OR EVENT.EVENT_TO_BRANCH LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_branch.branch_id#,%">
				OR EVENT.EVENT_TO_BRANCH LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_branch.branch_id#">
				OR EVENT.EVENT_TO_BRANCH = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_branch.branch_id#">
				OR
				(
					( 
                    	EVENT.VIEW_TO_ALL = 1 
                        AND EVENT.IS_WIEW_BRANCH = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_branch.branch_id#"> 
                        AND EVENT.IS_WIEW_DEPARTMENT = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_branch.department_id#"> 
                        AND 
                        	(EVENT.IS_VIEW_COMPANY = 1
                            <cfif isdefined("xml_multiple_comp") and xml_multiple_comp eq 1>
                        		AND EVENT.EVENT_ID IN (SELECT EVENT_ID FROM EVENT_COMPANY WHERE COMPANY_ID IN (#my_comp_list#)) 
                            </cfif>
                            )
                    ) OR	
					( EVENT.VIEW_TO_ALL = 1 AND EVENT.IS_WIEW_BRANCH = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_branch.branch_id#"> AND EVENT.IS_WIEW_DEPARTMENT IS NULL AND EVENT.IS_VIEW_COMPANY IS NULL) OR 
					( EVENT.VIEW_TO_ALL = 1 AND EVENT.IS_WIEW_BRANCH  IS NULL AND EVENT.IS_WIEW_DEPARTMENT IS NULL 
                    AND (EVENT.IS_VIEW_COMPANY = 1
							<cfif isdefined("xml_multiple_comp") and xml_multiple_comp eq 1>
                        		AND EVENT.EVENT_ID IN (SELECT EVENT_ID FROM EVENT_COMPANY WHERE COMPANY_ID IN (#my_comp_list#)) 
                            </cfif>                        
                            )
                    ) OR 
					( EVENT.VIEW_TO_ALL = 1 AND EVENT.IS_WIEW_BRANCH IS NULL AND EVENT.IS_WIEW_DEPARTMENT IS NULL AND EVENT.IS_VIEW_COMPANY IS NULL) OR
					( EVENT.IS_VIEW_COMPANY = 1
							<cfif isdefined("xml_multiple_comp") and xml_multiple_comp eq 1>
                        		AND EVENT.EVENT_ID IN (SELECT EVENT_ID FROM EVENT_COMPANY WHERE COMPANY_ID IN (#my_comp_list#)) 
                            </cfif> 
                    ) OR
					( EVENT.IS_WIEW_BRANCH = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_branch.branch_id#">) OR
					( EVENT.IS_WIEW_DEPARTMENT = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_branch.department_id#">)
				)	
			)
		</cfif>
</cfquery>
<cfif len(get_event.link_id)>
	<cfquery name="GET_EVENT_COUNT" datasource="#DSN#">
		SELECT COUNT(EVENT_ID) AS EVENT_COUNT FROM EVENT WHERE LINK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_event.link_id#">
	</cfquery>
	<cfquery name="DATE_DIFF" datasource="#DSN#" maxrows="2">
		SELECT STARTDATE FROM EVENT WHERE LINK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_event.link_id#"> ORDER BY STARTDATE ASC
	</cfquery>
	<cfif len(date_diff.startdate[1]) and len(date_diff.startdate[2])>
		<cfset fark = datediff("d",date_diff.startdate[1],date_diff.startdate[2])>
		<cfif fark gt 7>
			<cfset fark = 30>
		</cfif>
	<cfelse>
		<cfset fark = 0>
	</cfif>
<cfelse>
	<cfset fark = 0>
</cfif>
