<!--- 
	amac            : FULLNAME vererek EMPLOYEE_ID,FULLNAME,POSITION_CODE bilgisini hr icin getirmek
	parametre adi   : employee_name
	ayirma isareti  : YOK
	kullanim        : get_employee_hr('Ahmet K') 
 --->
<cffunction name="get_employee_hr" access="public" returnType="query" output="no">
	<cfargument name="emp_pos_name" required="yes" type="string">
	<cfargument name="maxrows" required="yes" type="string" default="">
	<cfif len(arguments.maxrows)>
		<cfquery name="get_employee_hr" datasource="#dsn#" maxrows="#arguments.maxrows#">
			SELECT 
				EMPLOYEE_ID,
				<cfif database_type is 'MSSQL'>
				EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS FULLNAME
				<cfelseif database_type is 'DB2'>
				EMPLOYEE_NAME || ' ' || EMPLOYEE_SURNAME AS FULLNAME
				</cfif>
			FROM 
				EMPLOYEES
			WHERE 
				EMPLOYEE_STATUS = 1 AND
				<cfif database_type is 'MSSQL'>
				EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emp_pos_name#%">
				<cfelseif database_type is 'DB2'>
				EMPLOYEE_NAME || ' ' || EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emp_pos_name#%">
				</cfif>
			ORDER BY 
				EMPLOYEE_NAME,
				EMPLOYEE_SURNAME
		</cfquery>
	<cfelse>
		<cfquery name="get_employee_hr" datasource="#dsn#">
			SELECT 
				EMPLOYEE_ID,
				<cfif database_type is 'MSSQL'>
				EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS FULLNAME
				<cfelseif database_type is 'DB2'>
				EMPLOYEE_NAME || ' ' || EMPLOYEE_SURNAME AS FULLNAME
				</cfif>
			FROM 
				EMPLOYEES 
			WHERE
				EMPLOYEE_STATUS = 1 AND
				<cfif database_type is 'MSSQL'>
				EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emp_pos_name#%">
				<cfelseif database_type is 'DB2'>
				EMPLOYEE_NAME || ' ' || EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emp_pos_name#%">
				</cfif>
			ORDER BY 
				EMPLOYEE_NAME,
				EMPLOYEE_SURNAME
		</cfquery>
	</cfif>
	<cfreturn get_employee_hr>
</cffunction>
