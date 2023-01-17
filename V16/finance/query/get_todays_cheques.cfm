<cfset bugun = createodbcdatetime('#year(now())#-#month(now())#-#day(now())#') >
<cfquery name="GET_CHES_TO_REV" datasource="#dsn2#">
	SELECT
		*
	FROM
		CHEQUE C,
		PAYROLL P,
		#dsn_alias#.COMPANY CO
	WHERE
		( C.CHEQUE_STATUS_ID=1 OR C.CHEQUE_STATUS_ID=2 ) AND
		P.ACTION_ID = C.CHEQUE_PAYROLL_ID AND
		C.CHEQUE_DUEDATE = #bugun# AND
		CO.COMPANY_ID = P.COMPANY_ID
</cfquery>
<cfquery name="GET_CHES_TO_PAY" datasource="#dsn2#">
	SELECT
		*
	FROM
		CHEQUE C,
		PAYROLL P,
		#dsn_alias#.COMPANY CO
	WHERE
		C.CHEQUE_STATUS_ID=6 AND
		P.ACTION_ID = C.CHEQUE_PAYROLL_ID AND
		C.CHEQUE_DUEDATE = #bugun# AND
		CO.COMPANY_ID = P.COMPANY_ID
</cfquery>
