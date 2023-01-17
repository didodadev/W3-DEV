<cfquery name="GET_SALE_DET" datasource="#DSN2#">
	SELECT 
		* 
	FROM 
		INVOICE 
	WHERE
		INVOICE_CAT  = 69
		AND INVOICE_ID = #attributes.IID#
		<cfif session.ep.isBranchAuthorization>
			AND (
				RECORD_EMP IN
				(
					SELECT 
						EMPLOYEE_ID
					FROM 
						#dsn_alias#.EMPLOYEE_POSITIONS EP,
						#dsn_alias#.DEPARTMENT D
					WHERE
						EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND
						D.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">
				)
			OR
				DEPARTMENT_ID IN
				(
					SELECT 
						DEPARTMENT_ID
					FROM 
						#dsn_alias#.DEPARTMENT D
					WHERE
						D.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">
				)
			)
		</cfif>
</cfquery>		

