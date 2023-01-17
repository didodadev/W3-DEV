<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT
		BRANCH_NAME,
		BRANCH_ID
	FROM 
		BRANCH
	WHERE
		BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.position_code#"> )
		ORDER BY BRANCH_NAME
</cfquery>
<cfquery name="GET_EVENT_PLAN" datasource="#DSN#">
	SELECT
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
		COMPANY_PARTNER.COMPANY_PARTNER_NAME,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
		COMPANY_PARTNER.PARTNER_ID
	FROM
		COMPANY,
		EVENT_PLAN_ROW,
		COMPANY_PARTNER
	WHERE 
		<!---EVENT_PLAN_ROW.EVENT_PLAN_ROW_ID IN 
		(
			SELECT 
				EVENT_ROW_ID
			FROM
				EVENT_PLAN_ROW_PARTICIPATION_POS 
			WHERE
				EVENT_ROW_PART_POS_ID IS NOT NULL
				<cfif isdefined("session.agenda_userid")>
					AND EVENT_PLAN_ROW_PARTICIPATION_POS.EVENT_POS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.agenda_userid#">
				<cfelse>
					AND EVENT_PLAN_ROW_PARTICIPATION_POS.EVENT_POS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.position_code#">
				</cfif>
		) AND--->
		<cfif isdefined("seventh_day") and isdefined("first_day")>
			EVENT_PLAN_ROW.START_DATE >= #first_day# AND
			EVENT_PLAN_ROW.FINISH_DATE < #DATEADD('d',seventh_day,'1')# AND
		<cfelseif isdefined("tarih1") and isdefined("tarih2")>
			EVENT_PLAN_ROW.START_DATE >= #tarih1# AND
			EVENT_PLAN_ROW.FINISH_DATE < #tarih2# AND
		<cfelse>
			EVENT_PLAN_ROW.START_DATE >= #tarih# AND
			EVENT_PLAN_ROW.FINISH_DATE < #DATEADD("d", 1, tarih)# AND
		</cfif>
		EVENT_PLAN_ROW.PARTNER_ID = COMPANY_PARTNER.PARTNER_ID AND 
		COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
		EVENT_PLAN_ROW.PARTNER_ID = COMPANY_PARTNER.PARTNER_ID
	ORDER BY 
		EVENT_PLAN_ROW.EVENT_PLAN_ROW_ID
	DESC
</cfquery>
<cfquery name="GET_EVENT_CAT" datasource="#DSN#">
	SELECT EVENTCAT_ID, EVENTCAT FROM EVENT_CAT
</cfquery>
<cfquery name="GET_CAT" datasource="#DSN#">
	SELECT VISIT_TYPE_ID,VISIT_TYPE FROM SETUP_VISIT_TYPES
</cfquery>
