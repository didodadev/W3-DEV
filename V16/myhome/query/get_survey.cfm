<cfquery name="get_generator_survey" datasource="#dsn#">
	SELECT
		*,
		CASE 
			WHEN ISNULL(SM.SURVEY_PERIOD,0) = 1 
			THEN ISNULL((
					SELECT 
						SMR.SURVEY_MAIN_RESULT_ID 
					FROM 
						SURVEY_MAIN_RESULT SMR 
					WHERE 
						SMR.SURVEY_MAIN_ID = SM.SURVEY_MAIN_ID AND
						SMR.RECORD_EMP = #session.ep.userid# AND
						YEAR(SMR.RECORD_DATE) = #year(now())# AND
						MONTH(SMR.RECORD_DATE) = #MONTH(now())# AND
						DAY(SMR.RECORD_DATE) = #DAY(now())#
					),0)
			WHEN ISNULL(SM.SURVEY_PERIOD,0) = 30 
			THEN ISNULL((
					SELECT 
						SMR.SURVEY_MAIN_RESULT_ID 
					FROM 
						SURVEY_MAIN_RESULT SMR 
					WHERE 
						SMR.SURVEY_MAIN_ID = SM.SURVEY_MAIN_ID AND
						SMR.RECORD_EMP = #session.ep.userid# AND
						YEAR(SMR.RECORD_DATE) = #year(now())# AND
						MONTH(SMR.RECORD_DATE) = #MONTH(now())#
					),0)
			WHEN ISNULL(SM.SURVEY_PERIOD,0) = 365 
			THEN ISNULL((
					SELECT 
						SMR.SURVEY_MAIN_RESULT_ID 
					FROM 
						SURVEY_MAIN_RESULT SMR 
					WHERE 
						SMR.SURVEY_MAIN_ID = SM.SURVEY_MAIN_ID AND
						SMR.RECORD_EMP = #session.ep.userid# AND
						YEAR(SMR.RECORD_DATE) = #year(now())#
					),0)
		ELSE 0 END AS IS_UPDATE
	FROM
		SURVEY_MAIN SM
	WHERE
		(#NOW()# BETWEEN SM.START_DATE AND SM.FINISH_DATE) AND
		SM.TYPE = 14 AND
		SM.IS_ACTIVE = 1
		AND
		(
			SM.SURVEY_MAIN_ID NOT IN (SELECT SP.SURVEY_MAIN_ID FROM SURVEY_MAIN_POSITION_CATS SP)
			OR
			SM.SURVEY_MAIN_ID IN 
				(
					SELECT 
						SP2.SURVEY_MAIN_ID 
					FROM 
						SURVEY_MAIN_POSITION_CATS SP2,
						EMPLOYEE_POSITIONS EP 
					WHERE 
						EP.POSITION_CAT_ID = SP2.POSITION_CAT_ID AND 
						EP.POSITION_CODE = #session.ep.position_code#
				)
		)
</cfquery>
<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# GROUP BY BRANCH_ID
</cfquery>
<cfquery name="FIND_OUR_COMP" datasource="#DSN#">
	SELECT
		SURVEY_OUR_COMP,
		SURVEY_ID
	FROM
		SURVEY
	WHERE
		SURVEY_STATUS = 1 AND
		<!---STAGE_ID = -2 AND---><!--- Anketler sayfasi surece alindigindan boyle bir kontrole gerek yok --->
		(SURVEY_DEPARTMENTS LIKE '%,#GET_BRANCH.BRANCH_ID#,%' AND SURVEY_OUR_COMP LIKE '%,#session.ep.company_id#,%') AND
		(#NOW()# BETWEEN VIEW_DATE_START AND VIEW_DATE_FINISH) AND
		SURVEY_ID NOT IN (SELECT DISTINCT SURVEY_ID FROM SURVEY_VOTES WHERE EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND SURVEY_ID IS NOT NULL)
		<cfif isdefined("attributes.survey_id")>AND SURVEY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#"></cfif>
</cfquery>
<cfquery name="FIND_SURVEY" dbtype="query">
	SELECT MIN(SURVEY_ID) SURVEY_ID FROM FIND_OUR_COMP
</cfquery>
		
<cfif find_survey.recordcount and len(find_survey.survey_id)>
	<cfquery name="GET_SURVEY" datasource="#DSN#">
		SELECT
            #dsn#.Get_Dynamic_Language(SURVEY_ID,'#session.ep.language#','SURVEY','SURVEY',NULL,NULL,SURVEY) AS SURVEY,
            #dsn#.Get_Dynamic_Language(SURVEY_ID,'#session.ep.language#','SURVEY','DETAIL',NULL,NULL,DETAIL)AS DETAIL,
            SURVEY_TYPE,
            SURVEY_ID
        FROM
            SURVEY S
        WHERE
            SURVEY_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#find_survey.survey_id#">
	</cfquery>
	<cfquery name="GET_SURVEY_ALTS" datasource="#DSN#">
		SELECT
		#dsn#.Get_Dynamic_Language(ALT_ID,'#session.ep.language#','SURVEY_ALTS','ALT',NULL,NULL,ALT) AS ALT,
		ALT_ID	
		FROM
			SURVEY_ALTS
		WHERE
			SURVEY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#find_survey.survey_id#">	
	</cfquery>
</cfif>

