<cfif attributes.TYPE IS "QUIZ">

	<cfquery name="GET_QUIZ_SEARCH_RESULTS" datasource="#dsn#">
		SELECT 
		*
		FROM
			QUIZ
		WHERE
			QUIZ_DEPARTMENTS LIKE '%#LISTGETAT(SESSION.USER_LOCATION,2,"-")#,%'
			AND
		<cfif attributes.TRAINING_CAT_ID NEQ 0>
			TRAINING_CAT_ID = #attributes.TRAINING_CAT_ID#
			AND
		</cfif>
			(
			QUIZ_ID IN 
				(
				SELECT 
					QUIZ_ID 
				FROM 
					QUESTION 
				WHERE 
					QUESTION LIKE '%#attributes.keyword#%'
					OR
					QUESTION_INFO LIKE '%#attributes.keyword#%'
				)
				OR
				(
				QUIZ_HEAD LIKE '%#attributes.keyword#%'
				OR
				QUIZ_OBJECTIVE LIKE '%#attributes.keyword#%'			
				)
			)
	</cfquery>		

<cfelseif attributes.TYPE IS "TRAINING">

	<cfquery name="GET_TRAINING_SEARCH_RESULTS" datasource="#dsn#">
		SELECT 
			*
		FROM
			TRAINING
		WHERE
		<cfif attributes.TRAINING_CAT_ID NEQ 0>
			TRAIN_CAT_ID = #attributes.TRAINING_CAT_ID#
			AND
		</cfif>
			(
			TRAIN_HEAD LIKE '%#attributes.keyword#%'
			OR
			TRAIN_OBJECTIVE LIKE '%#attributes.keyword#%'
			OR
			TRAIN_DETAIL LIKE '%#attributes.keyword#%'
			)
	</cfquery>		

<cfelse>

	<cfquery name="GET_QUIZ_SEARCH_RESULTS" datasource="#dsn#">
		SELECT 
			*
		FROM
			QUIZ
		WHERE
		<cfif attributes.TRAINING_CAT_ID NEQ 0>
			TRAINING_CAT_ID = #attributes.TRAINING_CAT_ID#
			AND
		</cfif>
			(
			QUIZ_ID IN 
				(
				SELECT 
					QUIZ_ID 
				FROM 
					QUESTION 
				WHERE 
					QUESTION LIKE '%#attributes.keyword#%'
					OR
					QUESTION_INFO LIKE '%#attributes.keyword#%'
				)
				OR
				(
				QUIZ_HEAD LIKE '%#attributes.keyword#%'
				OR
				QUIZ_OBJECTIVE LIKE '%#attributes.keyword#%'			
				)
			)
	</cfquery>		

	<cfquery name="GET_TRAINING_SEARCH_RESULTS" datasource="#dsn#">
		SELECT 
			*
		FROM
			TRAINING
		WHERE
		<cfif attributes.TRAINING_CAT_ID NEQ 0>
			TRAIN_CAT_ID = #attributes.TRAINING_CAT_ID#
			AND
		</cfif>
			(
			TRAIN_HEAD LIKE '%#attributes.keyword#%'
			OR
			TRAIN_OBJECTIVE LIKE '%#attributes.keyword#%'
			OR
			TRAIN_DETAIL LIKE '%#attributes.keyword#%'
			)
	</cfquery>		

</cfif>
