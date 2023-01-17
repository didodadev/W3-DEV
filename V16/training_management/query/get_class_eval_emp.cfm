<cfquery name="GET_CLASS_EVAL_EMP" datasource="#dsn#">
	SELECT 
		CLASS_EVAL_ID
	FROM 
		TRAINING_CLASS_EVAL
	WHERE 
		EMP_ID = #attributes.EMPLOYEE_ID#
		AND
		CLASS_ID = #attributes.CLASS_ID#
</cfquery>
