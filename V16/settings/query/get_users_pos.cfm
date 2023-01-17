<cfquery name="GET_USERS_POS" datasource="#dsn#">
	SELECT 
		POSITION_CODE,
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME,
		EMPLOYEE_EMAIL
	FROM 
		EMPLOYEE_POSITIONS
	WHERE
		POSITION_CODE IN (#LISTSORT(attributes.POSITION_CODES,"NUMERIC")#)
	<cfif isDefined("attributes.searchKey") and len(attributes.searchKey)>
		AND (EMPLOYEE_NAME LIKE '%#attributes.searchKey#%' OR EMPLOYEE_SURNAME LIKE '%#attributes.searchKey#%')
	</cfif>		
</cfquery>
