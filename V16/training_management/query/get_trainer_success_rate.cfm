<cfquery name="GET_QUIZ" datasource="#DSN#">
	SELECT
		DISTINCT
		EQU.QUIZ_ID
	FROM
		TRAINING_CLASS_QUIZES TCQ,
		EMPLOYEE_QUIZ EQU 
	WHERE
		EQU.QUIZ_ID=TCQ.QUIZ_ID
		AND
		TCQ.CLASS_ID=#attributes.class_id#
		AND
		EQU.IS_TRAINER = 0
</cfquery>

<cfif GET_QUIZ.RecordCount>
<cfset list_quiz_id = valuelist(GET_QUIZ.QUIZ_ID,',')>
	 <cfquery name="get_training_performance_id" datasource="#dsn#">
			SELECT 
				SUM(USER_POINT*100/PERFORM_POINT)/COUNT(TRAINING_PERFORMANCE_ID) AS POINT
			FROM 
				TRAINING_PERFORMANCE 
			WHERE 
				CLASS_ID = #attributes.class_id#
				AND TRAINING_QUIZ_ID IN (#list_quiz_id#)
	  </cfquery>

	 <cfif get_training_performance_id.RecordCount>
		<cfset success_rate = ArraySum(ListToArray(ListSort(ValueList(get_training_performance_id.POINT),'numeric')))/get_training_performance_id.RecordCount>
		<cfset success_rate = Round(success_rate*100)/100>
	<cfelse>	
		<cfset success_rate = "">
	</cfif>
<cfelse>	
	<cfset success_rate = "">
</cfif>

