<cfquery name="GET_CHEQUE_DETAIL" datasource="#dsn2#">
	SELECT 
		* 
	FROM
		CHEQUE
	WHERE
		CHEQUE_PAYROLL_ID = #attributes.CHEQUE_PAYROLL_ID#
</cfquery>

