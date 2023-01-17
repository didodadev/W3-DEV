<cfcomponent extends="cfc.queryJSONConverter">

	<cfset dsn = application.systemParam.systemParam().dsn />
	<cfset dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#" />
	<cfset dsn3 = "#dsn#_#session.ep.company_id#" />
	<cfset dsn1 = "#dsn#_product" />

	<cfsetting requesttimeout="2000">

	<cffunction name="getAnalysisTemplate" access="public" returntype="any">
		<cfargument name="refinery_test_id" default="" required="true">
		<cfquery name="GET_TEST_ALL" datasource="#DSN#">
			SELECT
				#dsn#.Get_Dynamic_Language(REFINERY_TEST_ID,'#session.ep.language#','REFINERY_TEST','TEST_NAME',NULL,NULL,TEST_NAME) AS TEST_NAME_,
				*
			FROM
				REFINERY_TEST
			WHERE 
				REFINERY_TEST_ID = #arguments.refinery_test_id# AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
		</cfquery>
		<cfreturn GET_TEST_ALL>
	</cffunction>

	<cffunction name="getAnalysisTemplateRows" access="public" returntype="any">
		<cfargument name="refinery_test_id" default="" required="true">
		<cfquery name="GET_TEST_ROW" datasource="#DSN#">
			SELECT
				*
			FROM
				REFINERY_TEST_ROWS
			WHERE 
				PARAMETER_TEST_ID = #arguments.refinery_test_id#
		</cfquery>
		<cfreturn GET_TEST_ROW>
	</cffunction>
</cfcomponent>