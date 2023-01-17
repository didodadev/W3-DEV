<cfquery name="GET_EVENT_PLAN" datasource="#DSN#">
	SELECT
		1 TYPE,
		EVENT_PLAN.EVENT_PLAN_HEAD,
		EVENT_PLAN.ANALYSE_ID,
		EVENT_PLAN_ROW.RESULT_RECORD_EMP,
		EVENT_PLAN_ROW.EVENT_PLAN_ID,
		EVENT_PLAN_ROW.WARNING_ID,
		EVENT_PLAN_ROW.START_DATE,
		EVENT_PLAN_ROW.FINISH_DATE,
		EVENT_PLAN_ROW.EVENT_PLAN_ROW_ID,
		EVENT_PLAN_ROW.EXECUTE_STARTDATE,
		EVENT_PLAN_ROW.EXECUTE_FINISHDATE,
		EVENT_PLAN_ROW.VISIT_STAGE,
		EVENT_PLAN_ROW.IS_SALES,
		COMPANY.FULLNAME,
		COMPANY.COMPANY_ID,
		COMPANY_PARTNER.COMPANY_PARTNER_NAME MEMBER_NAME,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME MEMBER_SURNAME,
		COMPANY_PARTNER.PARTNER_ID MEMBER_ID
	FROM
		COMPANY,
		EVENT_PLAN_ROW,
		COMPANY_PARTNER,
		EVENT_PLAN
	WHERE
		EVENT_PLAN.EVENT_PLAN_ID = EVENT_PLAN_ROW.EVENT_PLAN_ID AND
		EVENT_PLAN_ROW.IS_ACTIVE = 1 AND
		EVENT_PLAN_ROW.PARTNER_ID = COMPANY_PARTNER.PARTNER_ID AND 
		COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
		<cfif isdefined("seventh_day") and isdefined("first_day")>
			EVENT_PLAN_ROW.START_DATE >= #first_day# AND
			EVENT_PLAN_ROW.FINISH_DATE < #DATEADD('d',seventh_day,'1')# 
		<cfelseif isdefined("tarih1") and isdefined("tarih2")>
			EVENT_PLAN_ROW.START_DATE >= #tarih1# AND
			EVENT_PLAN_ROW.FINISH_DATE < #DATEADD("s",-1,DATEADD("d", 1, tarih2))# 
		<cfelse>
			EVENT_PLAN_ROW.START_DATE >= #attributes.TO_DAY# AND
			EVENT_PLAN_ROW.FINISH_DATE < #DATEADD("d", 1, attributes.TO_DAY)# 
		</cfif>
        <cfif not isdefined('attributes.view_agenda')>
        AND
        EVENT_PLAN_ROW.EVENT_PLAN_ROW_ID IN(SELECT 
												EVENT_ROW_ID
											FROM
												EVENT_PLAN_ROW_PARTICIPATION_POS 
											WHERE
												EVENT_ROW_PART_POS_ID IS NOT NULL
												<cfif isdefined("session.agenda_position_code")>
													AND EVENT_PLAN_ROW_PARTICIPATION_POS.EVENT_POS_ID = #session.agenda_position_code#
												<cfelse>
													AND EVENT_PLAN_ROW_PARTICIPATION_POS.EVENT_POS_ID = #session.ep.position_code#
												</cfif>
											)
		</cfif>
		<cfif isdefined('attributes.view_agenda') and attributes.view_agenda eq 1>
			AND	(
					EVENT_PLAN.IS_WIEW_BRANCH IS NOT NULL AND
					EVENT_PLAN.IS_WIEW_DEPARTMENT IS NOT NULL AND
                    EVENT_PLAN.IS_VIEW_COMPANY IS NULL AND
					EVENT_PLAN.VIEW_TO_ALL IS NOT NULL AND
					EVENT_PLAN.IS_WIEW_DEPARTMENT = #get_all_agenda_department_branch.department_id#
				)
		</cfif>
		<cfif isdefined('attributes.view_agenda') and attributes.view_agenda eq 2>
			AND	(
					EVENT_PLAN.IS_WIEW_BRANCH IS NOT NULL AND
					EVENT_PLAN.IS_WIEW_DEPARTMENT IS NULL AND
					EVENT_PLAN.VIEW_TO_ALL IS NOT NULL AND
                    EVENT_PLAN.IS_VIEW_COMPANY IS NULL AND
					EVENT_PLAN.IS_WIEW_BRANCH = #get_all_agenda_department_branch.branch_id#
				)
		</cfif>
		<cfif isdefined('attributes.view_agenda') and attributes.view_agenda eq 3>
			AND	(
					(
                    EVENT_PLAN.IS_WIEW_BRANCH IS NULL AND
					EVENT_PLAN.IS_WIEW_DEPARTMENT IS NULL AND
                    EVENT_PLAN.IS_VIEW_COMPANY IS NULL AND
					EVENT_PLAN.VIEW_TO_ALL IS NOT NULL
                    )
                    OR
                    (
                    EVENT_PLAN.IS_WIEW_BRANCH IS NULL AND
					EVENT_PLAN.IS_WIEW_DEPARTMENT IS NULL AND
                    (
                        EVENT_PLAN.IS_VIEW_COMPANY IN (#my_comp_list#)
                        <cfif isdefined("xml_multiple_comp") and xml_multiple_comp eq 1>
                            AND EVENT_PLAN.EVENT_PLAN_ID IN (SELECT EVENT_PLAN_ID FROM EVENT_PLAN_COMPANY WHERE COMPANY_ID IN (#my_comp_list#)) 
                        </cfif>
                    )
					AND EVENT_PLAN.VIEW_TO_ALL IS NOT NULL
                    )
					OR
					(
					EVENT_PLAN.IS_WIEW_BRANCH IS NOT NULL AND
					EVENT_PLAN.IS_WIEW_DEPARTMENT IS NOT NULL AND
                    EVENT_PLAN.IS_VIEW_COMPANY IS NULL AND
					EVENT_PLAN.VIEW_TO_ALL IS NOT NULL AND
					EVENT_PLAN.IS_WIEW_DEPARTMENT = #get_all_agenda_department_branch.department_id#
					)
					OR
					(
					EVENT_PLAN.IS_WIEW_BRANCH IS NOT NULL AND
					EVENT_PLAN.IS_WIEW_DEPARTMENT IS NULL AND
					EVENT_PLAN.VIEW_TO_ALL IS NOT NULL AND
                    EVENT_PLAN.IS_VIEW_COMPANY IS NULL AND
					EVENT_PLAN.IS_WIEW_BRANCH = #get_all_agenda_department_branch.branch_id#
					)
				)
		</cfif>
	
	UNION
	
	SELECT
		2 TYPE,
		EVENT_PLAN.EVENT_PLAN_HEAD,
		EVENT_PLAN.ANALYSE_ID,
		EVENT_PLAN_ROW.RESULT_RECORD_EMP,
		EVENT_PLAN_ROW.EVENT_PLAN_ID,
		EVENT_PLAN_ROW.WARNING_ID,
		EVENT_PLAN_ROW.START_DATE,
		EVENT_PLAN_ROW.FINISH_DATE,
		EVENT_PLAN_ROW.EVENT_PLAN_ROW_ID,
		EVENT_PLAN_ROW.EXECUTE_STARTDATE,
		EVENT_PLAN_ROW.EXECUTE_FINISHDATE,
		EVENT_PLAN_ROW.VISIT_STAGE,
		EVENT_PLAN_ROW.IS_SALES,
		'' FULLNAME,
		'' COMPANY_ID,
		CONSUMER.CONSUMER_NAME MEMBER_NAME,
		CONSUMER.CONSUMER_SURNAME MEMBER_SURNAME,
		CONSUMER.CONSUMER_ID MEMBER_ID
	FROM
		CONSUMER,
		EVENT_PLAN_ROW,
		EVENT_PLAN
	WHERE
		EVENT_PLAN.EVENT_PLAN_ID = EVENT_PLAN_ROW.EVENT_PLAN_ID AND
		EVENT_PLAN_ROW.IS_ACTIVE = 1 AND
		EVENT_PLAN_ROW.CONSUMER_ID = CONSUMER.CONSUMER_ID AND 
		<cfif isdefined("seventh_day") and isdefined("first_day")>
			EVENT_PLAN_ROW.START_DATE >= #first_day# AND
			EVENT_PLAN_ROW.FINISH_DATE < #DATEADD('d',seventh_day,'1')# 
		<cfelseif isdefined("tarih1") and isdefined("tarih2")>
			EVENT_PLAN_ROW.START_DATE >= #tarih1# AND
			EVENT_PLAN_ROW.FINISH_DATE < #DATEADD('s',-1,DATEADD('d', 1, tarih2))# 
		<cfelse>
			EVENT_PLAN_ROW.START_DATE >= #attributes.to_day# AND
			EVENT_PLAN_ROW.FINISH_DATE < #DATEADD('d', 1, attributes.TO_DAY)# 
		</cfif>
        <cfif not isdefined('attributes.view_agenda')>
        AND
        EVENT_PLAN_ROW.EVENT_PLAN_ROW_ID IN(SELECT 
												EVENT_ROW_ID
											FROM
												EVENT_PLAN_ROW_PARTICIPATION_POS 
											WHERE
												EVENT_ROW_PART_POS_ID IS NOT NULL
												<cfif isdefined("session.agenda_position_code")>
													AND EVENT_PLAN_ROW_PARTICIPATION_POS.EVENT_POS_ID = #session.agenda_position_code#
												<cfelse>
													AND EVENT_PLAN_ROW_PARTICIPATION_POS.EVENT_POS_ID = #session.ep.position_code#
												</cfif>
											)
		</cfif>
		<cfif isdefined('attributes.view_agenda') and attributes.view_agenda eq 1>
			AND	(
					EVENT_PLAN.IS_WIEW_BRANCH IS NOT NULL AND
					EVENT_PLAN.IS_WIEW_DEPARTMENT IS NOT NULL AND
                    EVENT_PLAN.IS_VIEW_COMPANY IS NULL AND
					EVENT_PLAN.VIEW_TO_ALL IS NOT NULL AND
					EVENT_PLAN.IS_WIEW_DEPARTMENT = #get_all_agenda_department_branch.department_id#
				)
		</cfif>
		<cfif isdefined('attributes.view_agenda') and attributes.view_agenda eq 2>
			AND	(
					EVENT_PLAN.IS_WIEW_BRANCH IS NOT NULL AND
					EVENT_PLAN.IS_WIEW_DEPARTMENT IS NULL AND
                    EVENT_PLAN.IS_VIEW_COMPANY IS NULL AND
					EVENT_PLAN.VIEW_TO_ALL IS NOT NULL AND
					EVENT_PLAN.IS_WIEW_BRANCH = #get_all_agenda_department_branch.branch_id#
				)
		</cfif>
		<cfif isdefined('attributes.view_agenda') and attributes.view_agenda eq 3>
			AND	(
					(
                    EVENT_PLAN.IS_WIEW_BRANCH IS NULL AND
					EVENT_PLAN.IS_WIEW_DEPARTMENT IS NULL AND
                    EVENT_PLAN.IS_VIEW_COMPANY IS NULL AND
					EVENT_PLAN.VIEW_TO_ALL IS NOT NULL
                    )
                    OR
                    (
                    EVENT_PLAN.IS_WIEW_BRANCH IS NULL AND
					EVENT_PLAN.IS_WIEW_DEPARTMENT IS NULL AND
                    (
                    EVENT_PLAN.IS_VIEW_COMPANY IN (#my_comp_list#) 
                    <cfif isdefined("xml_multiple_comp") and xml_multiple_comp eq 1>
                            AND EVENT_PLAN.EVENT_PLAN_ID IN (SELECT EVENT_PLAN_ID FROM EVENT_PLAN_COMPANY WHERE COMPANY_ID IN (#my_comp_list#)) 
                    </cfif>
                    )AND
					EVENT_PLAN.VIEW_TO_ALL IS NOT NULL
                    )
					OR
					(
					EVENT_PLAN.IS_WIEW_BRANCH IS NOT NULL AND
					EVENT_PLAN.IS_WIEW_DEPARTMENT IS NOT NULL AND
                    EVENT_PLAN.IS_VIEW_COMPANY IS NULL AND
					EVENT_PLAN.VIEW_TO_ALL IS NOT NULL AND
					EVENT_PLAN.IS_WIEW_DEPARTMENT = #get_all_agenda_department_branch.department_id#
					)
					OR
					(
					EVENT_PLAN.IS_WIEW_BRANCH IS NOT NULL AND
					EVENT_PLAN.IS_WIEW_DEPARTMENT IS NULL AND
					EVENT_PLAN.VIEW_TO_ALL IS NOT NULL AND
                    EVENT_PLAN.IS_VIEW_COMPANY IS NULL AND
					EVENT_PLAN.IS_WIEW_BRANCH = #get_all_agenda_department_branch.branch_id#
					)
				)
		</cfif>
	ORDER BY 
		EVENT_PLAN_ROW.START_DATE,
		EVENT_PLAN_ROW.EVENT_PLAN_ROW_ID DESC
</cfquery>
