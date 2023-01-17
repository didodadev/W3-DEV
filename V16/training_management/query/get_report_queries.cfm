<cfinclude template="../query/get_training_sec_names.cfm">
<cfinclude template="../query/get_class.cfm">
<cfinclude template="../query/get_class_results.cfm">
<cfinclude template="../query/get_class_attender_eval.cfm">
<!--- <cfinclude template="../query/get_class_eval.cfm"> --->
<cfquery name="GET_CLASS_EVAL" datasource="#dsn#">
	SELECT
		*
	FROM
		TRAINING_PERFORMANCE
	WHERE
		CLASS_ID IS NOT NULL
	<cfif isDefined("attributes.CLASS_ID") and len(attributes.CLASS_ID)>
		AND CLASS_ID = #attributes.CLASS_ID#
	</cfif>
</cfquery>
<cfinclude template="../query/get_class_cost.cfm">
<cfinclude template="../query/get_training_eval_quizs.cfm">
<cfset attributes.quiz_id = get_class.quiz_id>
<!--- <cfif LEN(attributes.quiz_id)>
	<cfquery name="GET_QUIZ_RESULT" datasource="#dsn#">
		SELECT
			CLASS_EVAL_ID
		FROM
			TRAINING_CLASS_EVAL
		WHERE
			<cfif len(attributes.QUIZ_ID)>
			QUIZ_ID = #attributes.QUIZ_ID#
			 AND
			</cfif>
			CLASS_ID = #attributes.CLASS_ID#
	</cfquery>	
</cfif> --->
<cfset attributes.training_id = get_class.training_id>
<cfif len(get_class.start_date)>
   <cfset start_date = date_add('h', session.ep.time_zone, get_class.start_date)>
</cfif>
<cfif len(get_class.finish_date)>
    <cfset finish_date = date_add('h', session.ep.time_zone, get_class.finish_date)>
</cfif>

