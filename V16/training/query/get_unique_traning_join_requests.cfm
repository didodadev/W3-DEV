<cfquery name="get_unique_training_join_requests" datasource="#dsn#">
SELECT DISTINCT
		TRR.EMPLOYEE_ID,
		TRR.IS_VALID,
		TRR.REQUEST_ROW_ID,
		TRR.RECORD_DATE,
		TRR.CLASS_ID
	FROM 
		TRAINING_REQUEST_ROWS AS TRR,
		EMPLOYEES AS E 
	WHERE
		TRR.REQUEST_ROW_ID = #attributes.request_id#
</cfquery>
