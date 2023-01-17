<cfif isdefined("attributes.to_day") and LEN(attributes.to_day)>
	<cfset today="#datepart('m',attributes.to_day)#/#datepart('d',attributes.to_day)#/#datepart('yyyy',attributes.to_day)#">
<cfelse>
	<cfset today="#datepart('m',now())#/#datepart('d',now())#/#datepart('yyyy',now())#">
</cfif>
<cfquery name="GET_CHES_TO_REV" datasource="#dsn2#">
		SELECT
			*
		FROM
			CHEQUE C,
			PAYROLL P,
			#dsn_alias#.COMPANY CO
		WHERE
			(
				C.CHEQUE_STATUS_ID=1
			OR
				C.CHEQUE_STATUS_ID=2
			)
			AND P.ACTION_ID=C.CHEQUE_PAYROLL_ID
			AND C.CHEQUE_DUEDATE=#CreateODBCDate(now())#
			AND CO.COMPANY_ID=P.COMPANY_ID
			AND P.PAYROLL_TYPE <> 106
	UNION ALL
		SELECT
			*
		FROM
			CHEQUE C,
			PAYROLL P,
			#dsn_alias#.COMPANY CO
		WHERE
		(
			C.CHEQUE_STATUS_ID=1
		OR
			C.CHEQUE_STATUS_ID=2
		)
		AND P.ACTION_ID=C.CHEQUE_PAYROLL_ID
		AND C.CHEQUE_DUEDATE=#CreateODBCDate(now())#
		AND CO.COMPANY_ID=C.COMPANY_ID
		AND P.PAYROLL_TYPE = 106
	ORDER BY
		C.RECORD_DATE DESC
</cfquery>

<cfquery name="GET_CHES_TO_REV_CONS" datasource="#dsn2#">
		SELECT
			*
		FROM
			CHEQUE C,
			PAYROLL P,
			#dsn_alias#.CONSUMER CONS
		WHERE
			(
				C.CHEQUE_STATUS_ID=1
			OR
				C.CHEQUE_STATUS_ID=2
			)
			AND P.ACTION_ID=C.CHEQUE_PAYROLL_ID
			AND C.CHEQUE_DUEDATE=#CreateODBCDate(now())#
			AND CONS.CONSUMER_ID=P.CONSUMER_ID
			AND P.PAYROLL_TYPE <> 106
	UNION ALL
		SELECT
			*
		FROM
			CHEQUE C,
			PAYROLL P,
			#dsn_alias#.CONSUMER CONS
		WHERE
		(
			C.CHEQUE_STATUS_ID=1
		OR
			C.CHEQUE_STATUS_ID=2
		)
		AND P.ACTION_ID=C.CHEQUE_PAYROLL_ID
		AND C.CHEQUE_DUEDATE=#CreateODBCDate(now())#
			AND CONS.CONSUMER_ID=P.CONSUMER_ID
		AND P.PAYROLL_TYPE = 106
	ORDER BY
		C.RECORD_DATE DESC
</cfquery>

<cfquery name="GET_CHES_TO_REV_EMP" datasource="#dsn2#">
		SELECT
			*
		FROM
			CHEQUE C,
			PAYROLL P,
			#dsn_alias#.EMPLOYEES EMP
		WHERE
			(
				C.CHEQUE_STATUS_ID=1
			OR
				C.CHEQUE_STATUS_ID=2
			)
			AND P.ACTION_ID=C.CHEQUE_PAYROLL_ID
			AND C.CHEQUE_DUEDATE=#CreateODBCDate(now())#
			AND EMP.EMPLOYEE_ID=P.EMPLOYEE_ID
			AND P.PAYROLL_TYPE <> 106
	UNION ALL
		SELECT
			*
		FROM
			CHEQUE C,
			PAYROLL P,
			#dsn_alias#.EMPLOYEES EMP
		WHERE
		(
			C.CHEQUE_STATUS_ID=1
		OR
			C.CHEQUE_STATUS_ID=2
		)
		AND P.ACTION_ID=C.CHEQUE_PAYROLL_ID
		AND C.CHEQUE_DUEDATE=#CreateODBCDate(now())#
			AND EMP.EMPLOYEE_ID=P.EMPLOYEE_ID
		AND P.PAYROLL_TYPE = 106
	ORDER BY
		C.RECORD_DATE DESC
</cfquery>
<cfquery name="GET_CHES_TO_PAY" datasource="#dsn2#">
	SELECT
		*
	FROM
		CHEQUE C,
		PAYROLL P,
		#dsn_alias#.COMPANY CO
	WHERE
		C.CHEQUE_STATUS_ID=6
		AND P.ACTION_ID=C.CHEQUE_PAYROLL_ID
		AND C.CHEQUE_DUEDATE=#CreateODBCDate(now())#
		AND CO.COMPANY_ID=C.COMPANY_ID
	ORDER BY
		C.RECORD_DATE DESC
</cfquery>
