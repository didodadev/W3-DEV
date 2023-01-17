<cfif isdefined("session.agenda_userid")>
	<!--- baskasinda --->
	<cfif session.agenda_user_type is "p">
		<cfquery name="GET_GRPS" datasource="#DSN#">
			SELECT GROUP_ID FROM USERS WHERE PARTNERS LIKE '%,#session.agenda_userid#,%'
		</cfquery>
		<cfquery name="get_wrkgroups" datasource="#DSN#">
			SELECT WORKGROUP_ID FROM WORKGROUP_EMP_PAR WHERE PARTNER_ID = #session.agenda_userid#	
		</cfquery>
	<cfelseif session.agenda_user_type is "e">
		<cfquery name="GET_GRPS" datasource="#DSN#">
			SELECT GROUP_ID FROM USERS WHERE POSITIONS LIKE '%,#session.agenda_position_code#,%'
		</cfquery>
		<cfquery name="get_wrkgroups" datasource="#DSN#">
             SELECT WORKGROUP_ID FROM WORKGROUP_EMP_PAR WHERE POSITION_CODE = #session.agenda_position_code#		  
		</cfquery>
	</cfif>
<cfelse>
	<!--- kendinde --->
	<cfquery name="GET_GRPS" datasource="#DSN#">
		SELECT GROUP_ID FROM USERS WHERE POSITIONS LIKE '%,#session.ep.position_code#,%'
	</cfquery>
	<cfquery name="get_wrkgroups" datasource="#DSN#">
		SELECT WORKGROUP_ID FROM WORKGROUP_EMP_PAR WHERE POSITION_CODE = #session.ep.position_code#		  
	</cfquery>
</cfif>

<cfset grps = valuelist(get_grps.group_id)>
<cfset wrkgroups = valuelist(get_wrkgroups.workgroup_id)>
<cfquery name="GET_MONTHLY_EVENTS" datasource="#DSN#">
	SELECT
		EVENT.EVENT_TO_POS,
		EVENT.EVENT_CC_POS,
		EVENT.EVENT_ID,
		EVENT.STARTDATE,
		EVENT.FINISHDATE,
		EVENT_CAT.EVENTCAT,
		EVENT.EVENTCAT_ID,
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
        PROCESS_TYPE_ROWS.STAGE
	FROM 
		EVENT,
		EVENT_CAT,
        PROCESS_TYPE_ROWS
	WHERE
    	EVENT.EVENT_STAGE = PROCESS_TYPE_ROWS.PROCESS_ROW_ID AND
		
		EVENT.EVENTCAT_ID = EVENT_CAT.EVENTCAT_ID AND
		(
			((EVENT.STARTDATE >= #attributes.to_day#) AND (EVENT.STARTDATE < #DATEADD("M",1,attributes.to_day)#)) OR
			((EVENT.FINISHDATE >= #attributes.to_day#) AND (EVENT.FINISHDATE < #DATEADD("M",1,attributes.to_day)#))
		) 
		AND 
		(
			<cfif isDefined("session.agenda_userid")>
				<!--- baskasinda --->
				<cfif session.agenda_user_type is "P">
					(
						EVENT.EVENT_TO_PAR LIKE '%,#session.agenda_userid#,%' OR EVENT.EVENT_CC_PAR LIKE '%,#session.agenda_userid#,%'
						<cfloop LIST="#grps#" INDEX="grp_i">
							OR EVENT.EVENT_TO_GRP LIKE '%,#grp_i#,%'
							OR EVENT.EVENT_CC_GRP LIKE '%,#grp_i#,%'
						</cfloop>
						<cfloop list="#wrkgroups#" index="wrk">
							OR EVENT.EVENT_TO_WRKGROUP LIKE '%,#wrk#,%'
							OR EVENT.EVENT_CC_WRKGROUP LIKE '%,#WRK#,%'
						</cfloop>
					)
				<cfelseif session.agenda_user_type is "E">
					EVENT.EVENT_TO_POS LIKE '%,#session.agenda_userid#,%' OR
					EVENT.EVENT_CC_POS LIKE '%,#session.agenda_userid#,%' OR
					EVENT.VALID_EMP = #session.agenda_userid# 
					<cfloop list="#grps#" INDEX="grp_i">
						OR EVENT.EVENT_TO_GRP LIKE '%,#grp_i#,%'
						OR EVENT.EVENT_CC_GRP LIKE '%,#grp_i#,%'
					</cfloop>
					<cfloop list="#wrkgroups#" index="wrk">
						OR EVENT.EVENT_TO_WRKGROUP LIKE '%,#wrk#,%'
						OR EVENT.EVENT_CC_WRKGROUP LIKE '%,#WRK#,%'
					</cfloop>
				</cfif>
			<cfelse>
				<!--- kendinde --->
				EVENT.RECORD_EMP = #session.ep.userid# OR
				EVENT.UPDATE_EMP = #session.ep.userid# OR
				EVENT.VALID_EMP = #session.ep.userid# OR
				EVENT.EVENT_TO_POS LIKE '%,#session.ep.userid#,%' OR
				EVENT.EVENT_CC_POS LIKE '%,#session.ep.userid#,%'
				<cfloop LIST="#grps#" INDEX="grp_i">
					OR EVENT.EVENT_TO_GRP LIKE '%,#grp_i#,%'
					OR EVENT.EVENT_CC_GRP LIKE '%,#grp_i#,%'
				</cfloop>
				<cfloop list="#wrkgroups#" index="wrk">
					OR EVENT.EVENT_TO_WRKGROUP LIKE '%,#wrk#,%'
					OR EVENT.EVENT_CC_WRKGROUP LIKE '%,#wrk#,%'
				</cfloop>
			</cfif>
			<cfif isdefined('attributes.view_agenda') and listfindnocase('1,2,3',attributes.view_agenda)><!--- departman gorsun --->
				OR ( EVENT.IS_WIEW_DEPARTMENT IS NOT NULL AND EVENT.IS_WIEW_DEPARTMENT = #get_all_agenda_department_branch.department_id# )
			</cfif>
			<cfif isdefined('attributes.view_agenda') and listfindnocase('2,3',attributes.view_agenda)><!--- şube görsün --->
				OR ( EVENT.IS_WIEW_BRANCH IS NOT NULL AND EVENT.IS_WIEW_BRANCH = #get_all_agenda_department_branch.branch_id#)
			</cfif>
			<cfif isdefined('attributes.view_agenda') and attributes.view_agenda eq 3><!--- herkes gorsun --->
            	OR 
                (
                	(
                    EVENT.VIEW_TO_ALL = 0 AND EVENT.IS_VIEW_COMPANY IS NOT NULL AND 
                    (
                        EVENT.IS_VIEW_COMPANY = 1
						<cfif isdefined("xml_multiple_comp") and xml_multiple_comp eq 1>
                        	AND EVENT.EVENT_ID IN (SELECT EVENT_ID FROM EVENT_COMPANY WHERE COMPANY_ID IN (#my_comp_list#)) 
                        </cfif>
                    )
                    )
					OR EVENT.VIEW_TO_ALL = 1
                )
			</cfif>
		)
	ORDER BY 
		EVENT.STARTDATE
</cfquery>
