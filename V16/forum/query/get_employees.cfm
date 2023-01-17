<cfquery name="EMPLOYEES" datasource="#dsn#">
	SELECT
		EP.EMPLOYEE_ID,
		EP.POSITION_STATUS,
		EP.POSITION_CODE,
		EP.EMPLOYEE_NAME,
		E.EMPLOYEE_USERNAME,
		EP.EMPLOYEE_SURNAME,
		EP.DEPARTMENT_ID
	FROM
		EMPLOYEES E,
		EMPLOYEE_POSITIONS EP
	WHERE
		E.EMPLOYEE_ID = EP.EMPLOYEE_ID
		AND
		EP.POSITION_STATUS = 1
	<cfif isDefined("attributes.employee_poss") and listlen(attributes.employee_poss)>
		AND
		EP.POSITION_ID IN (#listsort(listdeleteduplicates(attributes.employee_poss),'numeric','ASC',',')#)
	</cfif>
</cfquery>	
	
