<!--- 
	amac            : FULLNAME vererek EMPLOYEE_ID,FULLNAME,POSITION_CODE bilgisini hr icin getirmek
	parametre adi   : employee_name
	ayirma isareti  : YOK
	kullanim        : get_employee_hr('Ahmet K') 
 --->
<cffunction name="get_in_outs_autocomplete" access="public" returnType="query" output="no">
	<cfargument name="in_out_name" required="yes" type="string">
		<cfquery name="GET_IN_OUTS" datasource="#dsn#">
			SELECT 
				E.EMPLOYEE_ID AS EMPLOYEE_ID,
				E.EMPLOYEE_NAME AS EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME AS EMPLOYEE_SURNAME,
				<cfif database_type is 'MSSQL'>
				E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS FULLNAME,
				<cfelseif database_type is 'DB2'>
				E.EMPLOYEE_NAME || ' ' || E.EMPLOYEE_SURNAME AS FULLNAME,
				</cfif>
				D.DEPARTMENT_HEAD AS DEPARTMENT_HEAD,
				B.BRANCH_NAME AS BRANCH_NAME,
				<cfif database_type is 'MSSQL'>
					B.BRANCH_NAME + '/' + D.DEPARTMENT_HEAD AS BRANS_NAME_DEP_HEAD,
				<cfelseif database_type is 'DB2'>
					B.BRANCH_NAME || '/' || D.DEPARTMENT_HEAD AS BRANS_NAME_DEP_HEAD,
				</cfif>
				EIO.SOCIALSECURITY_NO,
				EI.TC_IDENTY_NO AS TC_IDENTY_NO,
				EIO.IN_OUT_ID AS IN_OUT_ID,
				CONVERT(VARCHAR(10), EIO.START_DATE, 103) AS START_DATE,
				EIO.FINISH_DATE AS FINISH_DATE,
				EIO.RETIRED_SGDP_NUMBER
			FROM 
				EMPLOYEES E,
				EMPLOYEES_IN_OUT EIO,
				EMPLOYEES_IDENTY EI,
				DEPARTMENT D,
				BRANCH B
			WHERE
				E.EMPLOYEE_ID = EI.EMPLOYEE_ID AND
				E.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND
				E.EMPLOYEE_STATUS = 1 AND
				EIO.DEPARTMENT_ID = D.DEPARTMENT_ID AND
				EIO.FINISH_DATE IS NULL AND
				D.BRANCH_ID = B.BRANCH_ID AND
				(
                    EI.TC_IDENTY_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.in_out_name#%"> OR
                    EIO.SOCIALSECURITY_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.in_out_name#%"> OR
                    EIO.RETIRED_SGDP_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.in_out_name#%"> OR 
                    <cfif database_type is 'MSSQL'>
                    E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.in_out_name#%">
                    <cfelseif database_type is 'DB2'>
                    E.EMPLOYEE_NAME || ' ' || E.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.in_out_name#%">
                    </cfif>
				)
				<cfif not session.ep.ehesap>
				AND B.BRANCH_ID IN (
										SELECT
											BRANCH_ID
										FROM
											EMPLOYEE_POSITION_BRANCHES
										WHERE
											POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
										)
				</cfif>
			ORDER BY 
				E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME,
				E.EMPLOYEE_ID 
		</cfquery>
	<cfreturn get_in_outs>
</cffunction>

