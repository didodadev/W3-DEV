<cfquery name="GET_POSITIONCAT_QUIZ" datasource="#dsn#">
	SELECT 
		QUIZ_ID,
		QUIZ_HEAD,
		RECORD_EMP,
		RECORD_DATE
	FROM 
		EMPLOYEE_QUIZ
	WHERE 
		POSITION_CAT_ID LIKE <cfif isdefined("attributes.position_cat_id")>'%,#attributes.position_cat_id#,%'<cfelse>'%,#get_position_detail.POSITION_CAT_ID#,%'</cfif>	AND
		IS_ACTIVE = 1 AND
		STAGE_ID = -2 AND
		IS_EDUCATION <> 1 AND
		IS_TRAINER <> 1
</cfquery>
