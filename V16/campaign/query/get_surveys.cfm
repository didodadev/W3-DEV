<cfquery name="GET_SURVEYS" datasource="#DSN#">
	SELECT
		S.SURVEY_ID,
		S.SURVEY,
		S.SURVEY_HEAD,
		S.RECORD_DATE,
		S.RECORD_EMP,
		S.STAGE_ID,
		(SELECT STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = S.STAGE_ID) STAGE_NAME,
		S.VIEW_DATE_START,
		S.VIEW_DATE_FINISH,
		E.EMPLOYEE_ID,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
	FROM
		SURVEY S,
		EMPLOYEES E
	WHERE
		S.RECORD_EMP = E.EMPLOYEE_ID
		<cfif isdefined("attributes.survey_status") and attributes.survey_status eq 1>AND SURVEY_STATUS=1</cfif>
		<cfif isdefined("attributes.survey_status") and attributes.survey_status eq 2>AND SURVEY_STATUS=0</cfif>
		<cfif isdefined("attributes.stage_id") and Len(attributes.stage_id)>AND STAGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stage_id#"></cfif>
		<cfif len(attributes.start_dates)>AND VIEW_DATE_START >=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,attributes.start_dates)#"></cfif>
		<cfif len(attributes.finish_dates)>AND VIEW_DATE_FINISH <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,attributes.finish_dates)#"></cfif>
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			AND (S.SURVEY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR S.SURVEY_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI)
		</cfif>
		AND S.SURVEY_OUR_COMP LIKE '%,#session.ep.company_id#,%'
	ORDER BY 
		S.RECORD_DATE DESC
</cfquery>
