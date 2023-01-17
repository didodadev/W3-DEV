<cffunction name="get_survey_result_fnc" returntype="query">
   	<cfargument name="survey_main_id" default="" type="numeric"/>
   	<cfargument name="employee_id" default="" type="numeric"/>
	<cfquery name="get_survey_main_result" datasource="#this.dsn#">
		SELECT
			SURVEY_MAIN_RESULT_ID,
			PARTNER_ID,
			CONSUMER_ID,
			EMP_ID,
			COMPANY_ID
		FROM 
			SURVEY_MAIN_RESULT 
		WHERE 
			SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_main_id#"> 
			AND EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
	</cfquery>
	<cfreturn get_survey_main_result/>
</cffunction>
