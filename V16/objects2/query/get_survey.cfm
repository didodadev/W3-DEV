<cfif isdefined("attributes.poll_id") and len(attributes.poll_id)>
	<cfquery name="GET_ACTIVE_SURVEY" datasource="#DSN#">
		SELECT
			SURVEY.SURVEY_ID
		FROM
			SURVEY
		WHERE
			<cfif isdefined("attributes.pid")>
				PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> AND		
			</cfif>
			SURVEY_STATUS = 1 AND
			STAGE_ID = -2 AND
			SURVEY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.poll_id#"> AND
			(#now()# BETWEEN VIEW_DATE_START AND VIEW_DATE_FINISH)	
	</cfquery>
	
	<cfquery name="CONTROL_MY_VOTE" datasource="#DSN#">
		SELECT
			SURVEY.SURVEY_ID
		FROM
			SURVEY
		WHERE
			SURVEY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.poll_id#"> 
			<cfif isdefined("session.ww.consumer_category") and isdefined("session.ww.userid")>
				AND (SURVEY_CONSUMERS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#session.ww.consumer_category#%"> OR SURVEY_GUEST = 1)
				AND SURVEY_ID NOT IN (SELECT DISTINCT SURVEY_ID FROM SURVEY_VOTES WHERE CON_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">)
			<cfelseif isdefined("session.pp.company_category")>
				AND (SURVEY_PARTNERS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#session.pp.company_category#%"> OR SURVEY_GUEST = 1)
				AND SURVEY_ID NOT IN (SELECT DISTINCT SURVEY_ID FROM SURVEY_VOTES WHERE PAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">)
			<cfelseif  isdefined("session.cp.userid")>
				AND CAREER_VIEW = 1
			<cfelse>
				AND SURVEY_GUEST = 1
				AND SURVEY_ID NOT IN (SELECT DISTINCT SURVEY_ID FROM SURVEY_VOTES WHERE RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#"> AND GUEST = 1)
			</cfif>
	</cfquery>
	<cfif not control_my_vote.recordcount>
		<cfset ankete_katil = 0>
		<cfset sonuc_goster = 1>
	<cfelse>
		<cfset ankete_katil = 1>
		<cfset sonuc_goster = 0>
	</cfif>
<cfelse>
	<cfquery name="FIND_SURVEY" datasource="#DSN#">
		SELECT
			MAX(SURVEY.SURVEY_ID) AS SURVEY_ID
		FROM
			SURVEY
		WHERE
		<cfif isdefined("attributes.pid")>
			PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> AND		
		</cfif>
		SURVEY_STATUS = 1 AND
		STAGE_ID = -2 AND
		(#now()# BETWEEN VIEW_DATE_START AND VIEW_DATE_FINISH)	
		<cfif isdefined("session.ww.consumer_category") and isdefined("session.ww.userid")>
			AND (SURVEY_CONSUMERS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#session.ww.consumer_category#%">  OR SURVEY_GUEST = 1)
			AND SURVEY_ID NOT IN (SELECT DISTINCT SURVEY_ID FROM SURVEY_VOTES WHERE CON_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">)
		<cfelseif isdefined("session.pp.company_category")>
			AND (SURVEY_PARTNERS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#session.pp.company_category#%"> OR SURVEY_GUEST = 1)
			AND SURVEY_ID NOT IN (SELECT DISTINCT SURVEY_ID FROM SURVEY_VOTES WHERE PAR_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">)
		<cfelseif  isdefined("session.cp.userid")>
			AND CAREER_VIEW = 1
		<cfelse>
			AND SURVEY_GUEST = 1
			AND SURVEY_ID NOT IN (SELECT DISTINCT SURVEY_ID FROM SURVEY_VOTES WHERE RECORD_IP =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#"> AND GUEST = 1)
		</cfif>
	</cfquery>
	<cfif find_survey.recordcount and len(find_survey.survey_id)>
		<cfset ankete_katil = 1>
		<cfset attributes.poll_id = find_survey.survey_id>
	<cfelse>
		<cfset ankete_katil = 0>
	</cfif>
	
	<cfif not (find_survey.recordcount and len(find_survey.survey_id))>
		<cfquery name="GET_FIND_SURVEY" datasource="#DSN#">
			SELECT
				MAX(SURVEY.SURVEY_ID) AS SURVEY_ID
			FROM
				SURVEY
			WHERE
			<cfif isdefined("attributes.pid")>
				PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> AND		
			</cfif>
			SURVEY_STATUS = 1 AND
			STAGE_ID = -2 AND
			(#now()# BETWEEN VIEW_DATE_START AND VIEW_DATE_FINISH)
			<cfif isdefined("session.ww.consumer_category") and isdefined("session.ww.userid")>
				AND (SURVEY_CONSUMERS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#session.ww.consumer_category#%"> OR SURVEY_GUEST = 1)
			<cfelseif isdefined("session.pp.company_category")>
				AND (SURVEY_PARTNERS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#session.pp.company_category#%"> OR SURVEY_GUEST = 1)
			<cfelseif  isdefined("session.cp.userid")>
				AND CAREER_VIEW = 1
			<cfelse>
				AND SURVEY_GUEST = 1
			</cfif>
		</cfquery>
		<cfif get_find_survey.recordcount and len(get_find_survey.survey_id)>
			<cfset ankete_katil = 1>
			<cfset attributes.poll_id = get_find_survey.survey_id>
		<cfelse>
			<cfset ankete_katil = 0>
		</cfif>
	</cfif>
</cfif>

<cfif ankete_katil>
	<cfquery name="GET_SURVEY" datasource="#DSN#">
		SELECT
			SURVEY_ID,
			SURVEY_TYPE,
			#dsn#.Get_Dynamic_Language(SURVEY_ID,'#session_base.language#','SURVEY','SURVEY',NULL,NULL,SURVEY) AS SURVEY,
            #dsn#.Get_Dynamic_Language(SURVEY_ID,'#session_base.language#','SURVEY','DETAIL',NULL,NULL,DETAIL) AS DETAIL
		FROM
			SURVEY
		WHERE
			SURVEY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.poll_id#">
	</cfquery>

	<cfquery name="GET_SURVEY_ALTS" datasource="#DSN#">
		SELECT
			ALT_ID,
			#dsn#.Get_Dynamic_Language(ALT_ID,'#session_base.language#','SURVEY_ALTS','ALT',NULL,NULL,ALT) AS ALT
		FROM
			SURVEY_ALTS
		WHERE
			SURVEY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.poll_id#">
	</cfquery>
</cfif>

