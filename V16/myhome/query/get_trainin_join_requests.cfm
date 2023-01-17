<cfquery name="GET_TRAINING_JOIN_REQUESTS" datasource="#dsn#">
	SELECT 
		TC.CLASS_ID,
		TC.CLASS_NAME,
		TC.START_DATE, 
		TC.FINISH_DATE, 
		TC.MONTH_ID, 
		TJR.EMPLOYEE_ID,
		TJR.VALID,
		TJR.TRAINING_JOIN_REQUEST_ID,
		TJR.RECORD_DATE,
		EP.EMPLOYEE_NAME,
		EP.EMPLOYEE_SURNAME
	FROM 
		TRAINING_JOIN_REQUESTS AS TJR,
		TRAINING_CLASS AS TC,
		EMPLOYEE_POSITIONS AS EP 
	WHERE
		TJR.CLASS_ID = TC.CLASS_ID AND
		EP.EMPLOYEE_ID=TJR.EMPLOYEE_ID AND 
		TJR.EMPLOYEE_ID = #session.ep.userid#
		<cfif isDefined("attributes.KEYWORD") and len(attributes.KEYWORD)> AND
		(
		TC.CLASS_NAME LIKE '%#attributes.KEYWORD#%' OR
		EP.EMPLOYEE_NAME LIKE '%#attributes.KEYWORD#%' OR
		EP.EMPLOYEE_SURNAME LIKE '%#attributes.KEYWORD#%'
		)
		</cfif>
		<cfif isDefined("attributes.VALID") and len(attributes.VALID)>
			<cfif attributes.VALID IS 1>
			AND TJR.VALID = 1
			<cfelseif attributes.VALID IS 2>
			AND TJR.VALID = 0
			<cfelseif attributes.VALID IS 3>
			AND TJR.VALID IS NULL
			</cfif>
		</cfif>	
	ORDER BY
		TJR.RECORD_DATE DESC, TC.CLASS_NAME,EP.EMPLOYEE_NAME,EP.EMPLOYEE_SURNAME 
</cfquery>
