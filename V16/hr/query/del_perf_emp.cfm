<CFTRANSACTION>
	<cfquery name="get_EMPLOYEE_PERFORMANCE" datasource="#dsn#">
	SELECT
		RESULT_ID,
		PER_STAGE
	FROM
		EMPLOYEE_PERFORMANCE
	WHERE
		PER_ID = #attributes.PER_ID#
	</cfquery>
	<cfif IsNumeric(get_EMPLOYEE_PERFORMANCE.RESULT_ID)>
		<cfquery name="del_EMPLOYEE_QUIZ_CHAPTER_EXPL" datasource="#dsn#">
		DELETE FROM
			EMPLOYEE_QUIZ_CHAPTER_EXPL
		WHERE
			RESULT_ID = #get_EMPLOYEE_PERFORMANCE.RESULT_ID#
		</cfquery>		
		<cfquery name="del_EMPLOYEE_QUIZ_RESULTS_DETAILS" datasource="#dsn#">
		DELETE FROM
			EMPLOYEE_QUIZ_RESULTS_DETAILS
		WHERE
			RESULT_ID = #get_EMPLOYEE_PERFORMANCE.RESULT_ID#
		</cfquery>
		<cfquery name="del_EMPLOYEE_QUIZ_RESULTS" datasource="#dsn#">
		DELETE FROM
			EMPLOYEE_QUIZ_RESULTS
		WHERE
			RESULT_ID = #get_EMPLOYEE_PERFORMANCE.RESULT_ID#
		</cfquery>
	</cfif>
	<cfquery name="del_EMPLOYEE_PERFORMANCE" datasource="#dsn#">
	DELETE FROM
		EMPLOYEE_PERFORMANCE
	WHERE
		PER_ID = #attributes.PER_ID#
	</cfquery>
	<cf_add_log  log_type="-1" action_id="#attributes.PER_ID#" action_name="#attributes.head#" process_stage="#get_EMPLOYEE_PERFORMANCE.per_stage#">
</CFTRANSACTION>
<cflocation url="#request.self#?fuseaction=hr.list_perform" addtoken="no">
