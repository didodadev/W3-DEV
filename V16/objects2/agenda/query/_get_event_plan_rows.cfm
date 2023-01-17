<cfquery name="GET_EVENT_PLAN" datasource="#dsn#">
	SELECT
		EVENT_PLAN_ROW.EVENT_PLAN_ID,
		EVENT_PLAN_ROW.WARNING_ID,
		EVENT_PLAN_ROW.START_DATE,
		EVENT_PLAN_ROW.FINISH_DATE,
		EVENT_PLAN_ROW.EVENT_PLAN_ROW_ID,
		EVENT_PLAN_ROW.EXECUTE_STARTDATE,
		EVENT_PLAN_ROW.EXECUTE_FINISHDATE,
		EVENT_PLAN_ROW.VISIT_STAGE,
		COMPANY.FULLNAME,
		COMPANY.COMPANY_ID,
		COMPANY_PARTNER.COMPANY_PARTNER_NAME,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
		COMPANY_PARTNER.PARTNER_ID,
		SETUP_VISIT_TYPES.VISIT_TYPE
	FROM
		COMPANY,
		EVENT_PLAN_ROW,
		COMPANY_PARTNER,
		SETUP_VISIT_TYPES
	WHERE 
		EVENT_PLAN_ROW.PARTNER_ID = COMPANY_PARTNER.PARTNER_ID AND 
		COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
		SETUP_VISIT_TYPES.VISIT_TYPE_ID = EVENT_PLAN_ROW.WARNING_ID AND
		EVENT_PLAN_ROW.PARTNER_ID = COMPANY_PARTNER.PARTNER_ID
		<cfif isdefined("session.agenda_userid")>
			AND EVENT_PLAN_ROW.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.agenda_userid#">
		<cfelse>
			AND EVENT_PLAN_ROW.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
		</cfif>
		<cfif isdefined("seventh_day") and isdefined("first_day")>
			AND EVENT_PLAN_ROW.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#first_day#"> 
			AND EVENT_PLAN_ROW.FINISH_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',seventh_day,'1')#">
		<cfelseif isdefined("tarih1") and isdefined("tarih2")>
			AND EVENT_PLAN_ROW.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#tarih1#">
			AND EVENT_PLAN_ROW.FINISH_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#tarih2#">
		<cfelse>
			AND EVENT_PLAN_ROW.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#tarih#">
			AND EVENT_PLAN_ROW.FINISH_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("d", 1, tarih)#">
		</cfif>
	ORDER BY 
		EVENT_PLAN_ROW.EVENT_PLAN_ROW_ID
	DESC
</cfquery>
