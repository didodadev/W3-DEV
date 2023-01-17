<cfif len(get_app.position_id)>
	<cfquery name="GET_POSITIONCAT" datasource="#dsn#">
		SELECT 
			POSITION_CAT_ID
		FROM 
			EMPLOYEE_POSITIONS
		WHERE 
			POSITION_ID = #get_app.position_id#
	</cfquery>
</cfif>

<cfif len(get_app.position_id) OR len(get_app.position_cat_id)> 
	<cfquery name="GET_POSITIONCAT_QUIZ" datasource="#dsn#">
		SELECT 
			QUIZ_ID,
			QUIZ_HEAD,
			RECORD_EMP,
			RECORD_DATE
		FROM 
			EMPLOYEE_QUIZ
		WHERE 
		<cfif len(get_app.position_id)>
			POSITION_CAT_ID LIKE '%,#GET_POSITIONCAT.POSITION_CAT_ID#,%'
		<cfelseif len(get_app.position_cat_id)>
			POSITION_CAT_ID LIKE '%,#get_app.position_cat_id#,%'
		</cfif>
			AND
			IS_ACTIVE = 1
			AND
			STAGE_ID = -2
			AND
			IS_APPLICATION = 1
	</cfquery>
</cfif>
