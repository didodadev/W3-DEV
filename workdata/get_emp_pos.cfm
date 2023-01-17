<!--- 
	amac            : FULLNAME vererek EMPLOYEE_ID,FULLNAME,POSITION_CODE bilgisini getirmek
	parametre adi   : emp_pos_name
	ayirma isareti  : YOK
	kullanim        : get_emp_pos('Ahmet K') 
	Yazan           : A.Selam Karatas
	Tarih           : 29.5.2007
	Guncelleme      : 29.5.2007
 --->
<cffunction name="get_emp_pos" access="public" returnType="query" output="no">
	<cfargument name="emp_pos_name" required="yes" type="string">
	<cfargument name="maxrows" required="yes" type="string" default="">
	<cfif len(arguments.maxrows)>
		<cfquery name="GET_EMP_POS_" datasource="#DSN#" maxrows="#arguments.maxrows#">
			SELECT 
				EMPLOYEE_ID,
				<cfif database_type is 'MSSQL'>
				EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS FULLNAME,
				<cfelseif database_type is 'DB2'>
				EMPLOYEE_NAME || ' ' || EMPLOYEE_SURNAME AS FULLNAME,
				</cfif>
				<cfif database_type is 'MSSQL'>
				POSITION_NAME + ' - ' + EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS POSITION_NAME,
				<cfelseif database_type is 'DB2'>
				POSITION_NAME || ' - ' || EMPLOYEE_NAME || ' ' || EMPLOYEE_SURNAME AS POSITION_NAME,
				</cfif>
				POSITION_CODE,
				IS_MASTER
			FROM 
				EMPLOYEE_POSITIONS 
			WHERE 
				
				<cfif database_type is 'MSSQL'>
				EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emp_pos_name#%">
				<cfelseif database_type is 'DB2'>
				EMPLOYEE_NAME || ' ' || EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emp_pos_name#%">
				</cfif>
			ORDER BY 
				EMPLOYEE_NAME,
				EMPLOYEE_SURNAME,
				IS_MASTER DESC
		</cfquery>
	<cfelse>
		<cfquery name="GET_EMP_POS_" datasource="#DSN#">
			SELECT 
				EMPLOYEE_ID,
				<cfif database_type is 'MSSQL'>
				EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS FULLNAME,
				<cfelseif database_type is 'DB2'>
				EMPLOYEE_NAME || ' ' || EMPLOYEE_SURNAME AS FULLNAME,
				</cfif>
				<cfif database_type is 'MSSQL'>
				POSITION_NAME + ' - ' + EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS POSITION_NAME,
				<cfelseif database_type is 'DB2'>
				POSITION_NAME || ' - ' || EMPLOYEE_NAME || ' ' || EMPLOYEE_SURNAME AS POSITION_NAME,
				</cfif>
				POSITION_CODE,
				IS_MASTER
			FROM 
				EMPLOYEE_POSITIONS 
			WHERE 
				<cfif database_type is 'MSSQL'>
				EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emp_pos_name#%">
				<cfelseif database_type is 'DB2'>
				EMPLOYEE_NAME || ' ' || EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emp_pos_name#%">
				</cfif>
			ORDER BY 
				EMPLOYEE_NAME,
				EMPLOYEE_SURNAME,
				IS_MASTER DESC
		</cfquery>
	</cfif>
	<cfreturn get_emp_pos_>
</cffunction>
