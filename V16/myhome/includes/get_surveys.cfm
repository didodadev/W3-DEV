<cfquery name="GET_ME" DATASOURCE="#DSN#" >
	SELECT
		DEPARTMENT_ID
	FROM
		EMPLOYEE_POSITIONS
	WHERE
		EMPLOYEE_ID=#SESSION.EP.USERID#
</cfquery>
<cfquery name="GET_SURVEYS" datasource="#dsn#">
	SELECT
		SURVEY_ID,
		SURVEY,
		SURVEY_HEAD,
		RECORD_DATE
	FROM
		SURVEY
	WHERE
		SURVEY_DEPARTMENTS LIKE '%,#get_me.department_id#,%'
</cfquery>
