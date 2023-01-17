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

<cfquery name="GET_SURVEY" datasource="#dsn#">
	SELECT
		*
	FROM
		SURVEY
	WHERE
		SURVEY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.SURVEY_ID#">
		<cfif isdefined("session.ww.consumer_category") and isdefined("session.ww.userid")>
			AND (SURVEY_CONSUMERS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#session.ww.consumer_category#%"> OR SURVEY_GUEST = 1)
			AND SURVEY_ID NOT IN (SELECT DISTINCT SURVEY_ID FROM SURVEY_VOTES WHERE CON_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">)
		<cfelseif isdefined("session.pp.company_category")>
			AND (SURVEY_PARTNERS LIKE <cfqueryparam cfsqltype="cf_sql_integer" value="%#session.pp.company_category#%"> OR SURVEY_GUEST = 1)
			AND SURVEY_ID NOT IN (SELECT DISTINCT SURVEY_ID FROM SURVEY_VOTES WHERE PAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">)
		<cfelseif  isdefined("session.cp.userid")>
			AND CAREER_VIEW = 1
		<cfelse>
			AND SURVEY_GUEST = 1
			AND SURVEY_ID NOT IN (SELECT DISTINCT SURVEY_ID FROM SURVEY_VOTES WHERE RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#"> AND GUEST = 1)
		</cfif>
</cfquery>
