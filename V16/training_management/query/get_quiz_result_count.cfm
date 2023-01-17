<cfquery name="get_quiz_result_count" datasource="#dsn#">
	SELECT
		COUNT(RESULT_ID) AS TOPLAM
	FROM
		QUIZ_RESULTS
	WHERE
	<cfif isdefined("attributes.RESULT_ID")>
		RESULT_ID = #attributes.RESULT_ID#
	<cfelseif isdefined("attributes.QUIZ_ID")>
		QUIZ_ID = #attributes.QUIZ_ID#
	</cfif>
	<cfif isdefined("attributes.class_id") and len(attributes.class_id)>
		AND CLASS_ID = #attributes.class_id#
	</cfif>
</cfquery>
