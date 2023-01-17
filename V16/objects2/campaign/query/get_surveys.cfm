<cfif isdefined("session.pp.userid")>
	<cfquery name="get_my_comp_cat" datasource="#dsn#">
		SELECT
			COMPANYCAT_ID
		FROM
			COMPANY
		WHERE
			COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
	</cfquery>
<cfelseif isdefined("session.ww.")>
	<cfquery name="get_my_cons_cat" datasource="#dsn#">
		SELECT
			CONSUMER_CAT_ID
		FROM
			CONSUMER
	</cfquery>
</cfif>

<cfquery name="GET_SURVEYS" datasource="#dsn#">
	SELECT
		SURVEY.SURVEY_ID,
		SURVEY.SURVEY,
		SURVEY.SURVEY_HEAD,
		SURVEY.RECORD_DATE,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME
	FROM
		SURVEY AS SURVEY,
		EMPLOYEES
	WHERE
		<cfif isdefined("session.pp.userid")>
			SURVEY.SURVEY_PARTNERS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_my_comp_cat.COMPANYCAT_ID#,%"> AND
		<cfelseif isdefined("session.cp.")>
			SURVEY.CAREER_VIEW = 1 AND
		<cfelse>
			SURVEY.SURVEY_CONSUMERS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_my_cons_cat.CONSUMER_CAT_ID#,%"> AND
		</cfif>
		SURVEY.RECORD_EMP = EMPLOYEES.EMPLOYEE_ID AND
		SURVEY.VIEW_DATE_START < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#"> AND
		SURVEY.VIEW_DATE_FINISH > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">
		<cfif isDefined("attributes.keyword")>
			AND
			(
				SURVEY.SURVEY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
				SURVEY.SURVEY_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
			)
		</cfif>
</cfquery>
