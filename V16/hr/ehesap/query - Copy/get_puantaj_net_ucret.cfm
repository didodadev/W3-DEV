<cfquery name="get_puantaj_net_ucret" datasource="#DSN#">
	SELECT
		EPR.NET_UCRET
	FROM
		EMPLOYEES_PUANTAJ AS EP,
		EMPLOYEES_PUANTAJ_ROWS AS EPR
	WHERE
		EP.PUANTAJ_ID=EPR.PUANTAJ_ID
	AND
		EPR.EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
	AND
		EP.SAL_MON = #attributes.SAL_MON#
	AND
		EP.SAL_YEAR = #attributes.SAL_YEAR#
</cfquery>
