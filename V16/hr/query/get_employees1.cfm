<cfquery name="GET_EMPLOYEES1" datasource="#DSN#" cachedwithin="#fusebox.general_cached_time#">
	SELECT 
		EMPLOYEES.EMPLOYEE_ID,
		EMPLOYEES.EMPLOYEE_NO,
		EMPLOYEES.EMPLOYEE_NAME, 
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES.DIRECT_TELCODE,
		EMPLOYEES.DIRECT_TEL,
		EMPLOYEES.EXTENSION
	FROM 
	<cfif attributes.show_all is "1">
		EMPLOYEE_POSITIONS,
	</cfif>
		EMPLOYEES
	WHERE
		EMPLOYEES.EMPLOYEE_STATUS = 1 
	<cfif attributes.show_all is "1">
		AND EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID
	</cfif>
	<cfif attributes.show_all is "0">
		AND EMPLOYEES.EMPLOYEE_ID NOT IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID>0)
	</cfif>
	<cfif isDefined("attributes.EMPLOYEE_IDS") and len(attributes.EMPLOYEE_IDS)>
		AND EMPLOYEES.EMPLOYEE_ID IN (#attributes.EMPLOYEE_IDS#)
	</cfif>
		AND
		<cfif database_type is "MSSQL">
			EMPLOYEES.EMPLOYEE_NAME+' '+EMPLOYEES.EMPLOYEE_SURNAME LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%'
			<cfelseif database_type is "DB2">
			EMPLOYEES.EMPLOYEE_NAME||' '||EMPLOYEES.EMPLOYEE_SURNAME LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%'
		</cfif>
	ORDER BY
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME
</cfquery>
