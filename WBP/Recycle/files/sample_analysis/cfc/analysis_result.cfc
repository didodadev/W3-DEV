<cfcomponent>

	<cfset dsn = application.systemParam.systemParam().dsn />
	<cfset dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#" />
	<cfset dsn3 = "#dsn#_#session.ep.company_id#" />
	<cfset dsn1 = "#dsn#_product" />

	<cfsetting requesttimeout="2000">

	<cffunction name="getAnalysisResult" access="public" returntype="any">
		<cfargument name = "sample_analysis_id" type="numeric" required="true">
		<cfargument name = "sampling_id" type="numeric" required="true">

		<cfquery name = "get_analysis_result" datasource="#dsn#">
			SELECT
				LTR.RESULT_OPTION,
				LTR.RESULT_VALUE,
				LTR.SAMPLING_ROW_ID,
				LTR.SAMPLE_ANALYSIS_ROW_ID
			FROM
				#dsn#.LAB_TEST_RESULT LTR
					LEFT JOIN #dsn#.REFINERY_LAB_TESTS_ROW RLTR ON RLTR.REFINERY_LAB_TEST_ROW_ID = LTR.SAMPLE_ANALYSIS_ROW_ID
					LEFT JOIN #dsn#.LAB_SAMPLING_ROW LSR ON LSR.SAMPLING_ROW_ID = LTR.SAMPLING_ROW_ID
			WHERE
				RLTR.REFINERY_LAB_TEST_ID = #arguments.sample_analysis_id#
				AND LSR.SAMPLING_ID = #arguments.sampling_id#
		</cfquery>

		<cfreturn get_analysis_result>
	</cffunction>
</cfcomponent>