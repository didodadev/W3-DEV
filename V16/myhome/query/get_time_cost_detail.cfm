<cfquery name="GET_TIME_COST" datasource="#dsn#">
	SELECT 
		TC.* ,
		TC.EVENT_DATE AS EVENT_DATE,
		PP.PROJECT_HEAD,
		CASE WHEN TC.COMPANY_ID IS NOT NULL THEN C.FULLNAME WHEN TC.CONSUMER_ID IS NOT NULL THEN CON.CONSUMER_NAME + ' ' + CON.CONSUMER_SURNAME END AS MEMBER_NAME,
		SA.ACTIVITY_NAME,
		E.EVENT_HEAD,
		PW.WORK_HEAD,
		EC.EXPENSE,
		S.SERVICE_HEAD
	FROM 
		TIME_COST TC
		LEFT JOIN PRO_PROJECTS PP ON PP.PROJECT_ID = TC.PROJECT_ID
		LEFT JOIN COMPANY C ON C.COMPANY_ID = TC.COMPANY_ID
		LEFT JOIN CONSUMER CON ON CON.CONSUMER_ID = TC.CONSUMER_ID
		LEFT JOIN SETUP_ACTIVITY SA ON SA.ACTIVITY_ID = TC.ACTIVITY_ID
		LEFT JOIN EVENT E ON E.EVENT_ID = TC.EVENT_ID
		LEFT JOIN PRO_WORKS PW ON PW.WORK_ID = TC.WORK_ID
		LEFT JOIN #dsn2_alias#.EXPENSE_CENTER EC ON EC.EXPENSE_ID = TC.EXPENSE_ID
		LEFT JOIN #dsn3_alias#.SERVICE S ON S.SERVICE_ID = TC.SERVICE_ID
	WHERE 
		TC.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			AND TC.COMMENT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		</cfif>
		<cfif isdefined("attributes.startdate") and len(attributes.startdate) and isDefined("attributes.finishdate") and len(attributes.finishdate)>
			AND TC.EVENT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
			AND TC.EVENT_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
		</cfif>
		<cfif isdefined("attributes.cat_id") and len(attributes.cat_id)>
			AND TC.TIME_COST_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cat_id#">
		</cfif>
		<cfif isdefined("attributes.stage_id") and len(attributes.stage_id)>
			AND TC.TIME_COST_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stage_id#">
		</cfif>
		<cfif isdefined("attributes.consumer_id") and isdefined('attributes.member_name') and len(attributes.member_name) and len(attributes.consumer_id)>
			AND TC.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
		</cfif>
		<cfif isdefined("attributes.partner_id") and isdefined('attributes.member_name') and len(attributes.member_name) and len(attributes.partner_id)>
			AND TC.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#">
		</cfif>
		<cfif isdefined("attributes.company_id") and isdefined('attributes.member_name') and len(attributes.member_name) and len(attributes.company_id)>
			AND TC.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
		</cfif>
		<cfif isdefined("attributes.project_id") and isdefined('attributes.project_head') and len(attributes.project_head) and len(attributes.project_id)>
			AND TC.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
		</cfif>
		<cfif isdefined("attributes.activity") and len(attributes.activity)>
			AND TC.ACTIVITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.activity#">
		</cfif>
	ORDER BY
		TC.TIME_COST_ID DESC
</cfquery>

