<cftransaction>
<cfquery name="ADD_QUIZ_RESULT" datasource="#dsn#">
	INSERT INTO
		EMPLOYEE_QUIZ_RESULTS
		(
		QUIZ_ID,
		EMP_ID,
		USER_POINT,
 		START_DATE
		)
	VALUES
		(
		#SESSION.QUIZ_ID#,
		#SESSION.EP.USERID#,
		0,
 		#now()#
		)
</cfquery>	

<cfquery name="GET_RESULT_ID" datasource="#dsn#">
	SELECT
		MAX(RESULT_ID) AS MAX_ID
	FROM
		EMPLOYEE_QUIZ_RESULTS
	WHERE
		EMP_ID=#SESSION.EP.USERID#
		AND
		QUIZ_ID = #SESSION.QUIZ_ID#
</cfquery>
</cftransaction>

<cfset SESSION.RESULT_ID = GET_RESULT_ID.MAX_ID>
