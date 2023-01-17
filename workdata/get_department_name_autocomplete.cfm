<cffunction name="get_department_name_autocomplete" access="public" returnType="query" output="no">
	<cfargument name="department_head" required="yes" type="string">
		<cfquery name="GET_ALL_LOCATION" datasource="#DSN#">
			SELECT 
				D.DEPARTMENT_HEAD + '-' + SL.COMMENT AS DEPARTMENT_HEAD,
				SL.DEPARTMENT_ID + '-' + SL.LOCATION_ID AS DEPARTMENT_ID,
				D.DEPARTMENT_STATUS AS DEPARTMENT_STATUS,
				SL.STATUS AS LOCATION_STATUS
			FROM 
				STOCKS_LOCATION SL WITH (NOLOCK),
				DEPARTMENT D WITH (NOLOCK),
				BRANCH B WITH (NOLOCK)
			WHERE
				D.IS_STORE <> 2 AND
				SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND
				<!---D.DEPARTMENT_STATUS = 1 AND--->
				D.BRANCH_ID = B.BRANCH_ID AND
				B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
				(
				DEPARTMENT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.department_head#%">
				OR
				COMMENT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.department_head#%">
				)
			UNION
			SELECT
				D.DEPARTMENT_HEAD AS DEPARTMENT_HEAD,
				D.DEPARTMENT_ID,
				D.DEPARTMENT_STATUS AS DEPARTMENT_STATUS,
				NULL AS LOCATION_STATUS
			FROM
				DEPARTMENT D WITH (NOLOCK),
				BRANCH B WITH (NOLOCK)
			WHERE
				D.IS_STORE <> 2 AND
				<!---D.DEPARTMENT_STATUS = 1 AND--->
				D.BRANCH_ID = B.BRANCH_ID AND
				B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
				(
				DEPARTMENT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.department_head#%">
				)
			ORDER BY
				DEPARTMENT_ID,
				DEPARTMENT_HEAD
		</cfquery>
	<cfreturn GET_ALL_LOCATION>
</cffunction>

