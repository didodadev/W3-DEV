<cfset my_month = month(now())>
<cfset my_day = day(now())>
<cfquery name="get_birthdate" datasource="#dsn#">
	SELECT 
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		EI.BIRTH_DATE
	FROM 
		EMPLOYEES E,
		EMPLOYEES_IDENTY EI
	WHERE 
		E.EMPLOYEE_ID = EI.EMPLOYEE_ID AND
		EI.BIRTH_DATE IS NOT NULL AND
		E.EMPLOYEE_STATUS = 1 AND
		MONTH(EI.BIRTH_DATE)= #my_month# AND
		DAY(EI.BIRTH_DATE) = #my_day#
	ORDER BY 
		E.EMPLOYEE_NAME
</cfquery>

<cfif get_birthdate.recordcount>
	<table cellspacing="0" cellpadding="0" width="100%" border="0">
		<cfoutput query="get_birthdate">
		  <tr height="20">
			<td><li></li></td>
			<td align="left">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
		  </tr>
		</cfoutput>
	 </table>
</cfif>

