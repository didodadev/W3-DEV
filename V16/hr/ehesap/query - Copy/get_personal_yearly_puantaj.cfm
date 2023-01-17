<cfquery name="get_personal_yearly_puantaj" datasource="#DSN#">
	SELECT
		*
	FROM
		EMPLOYEES_PUANTAJ,
		EMPLOYEES_PUANTAJ_ROWS
	WHERE
		EMPLOYEES_PUANTAJ.SAL_YEAR = <cfif isdefined("attributes.sal_year")>#attributes.sal_year#<cfelse>#session.ep.period_year#</cfif>
		AND
		EMPLOYEES_PUANTAJ.PUANTAJ_ID = EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID
		AND
		EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
	ORDER BY
		EMPLOYEES_PUANTAJ.SAL_MON DESC
</cfquery>
