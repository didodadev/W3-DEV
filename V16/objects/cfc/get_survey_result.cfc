<cfcomponent>
	<cffunction name="getSurveyResult" access="public" returntype="query">
		<cfargument name="survey_main_id" type="numeric" required="yes" default="">
		<cfargument name="dsn" required="yes" default="">
		<cfquery name="get_Result" datasource="#arguments.dsn#">
			SELECT 
				SURVEY_MAIN_RESULT_ID 
			FROM 
				SURVEY_MAIN_RESULT 
			WHERE 
				SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.survey_main_id#">
		</cfquery>
		<cfreturn get_Result>
	</cffunction> 
</cfcomponent>
