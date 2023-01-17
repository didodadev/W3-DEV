<!--- comp_id=1 oldugunda COMPANY_ID'si 1 olan departmanlar listeleniyor.--->
<!--- department_status parametresi 0 oldugunda pasif, 1 oldugunda aktif  olan subeleri getiriyor. --->
<cffunction name="get_department1" access="public" returnType="query" output="no">
	<cfargument name="department_head" required="yes" type="string">
    <cfargument name="maxrows" required="yes" type="string" default="">
    <cfargument name="comp_id" required="no" type="string" default="">
    <cfargument name="department_status" required="no" type="string" default="1">
    <cfquery name="get_department" datasource="#dsn#">
		SELECT 
			D.DEPARTMENT_STATUS,
			D.DEPARTMENT_ID,
			D.BRANCH_ID,
			B.BRANCH_NAME,
			O.NICK_NAME,
			O.COMP_ID,
			D.DEPARTMENT_HEAD
		FROM 
			DEPARTMENT D,
			BRANCH B,
			OUR_COMPANY O
		WHERE 
			D.BRANCH_ID = B.BRANCH_ID AND
			B.COMPANY_ID = O.COMP_ID 
			<cfif isdefined("arguments.comp_id") and len(arguments.comp_id)>
				AND O.COMP_ID = #arguments.comp_id#
			<cfelse>
				AND O.COMP_ID = #session.ep.company_id#
			</cfif>
			AND D.BRANCH_ID IN (
							SELECT
								BRANCH_ID
							FROM
								EMPLOYEE_POSITION_BRANCHES
							WHERE
								POSITION_CODE =#session.ep.position_code#
							)
			AND
			(
				D.DEPARTMENT_HEAD LIKE '#arguments.department_head#%' OR
				B.BRANCH_NAME LIKE '#arguments.department_head#%'
			)
			<cfif arguments.department_status eq 1>
				AND D.DEPARTMENT_STATUS = 1
			<cfelseif arguments.department_status eq 0>
				AND D.DEPARTMENT_STATUS = 0
			</cfif>
			AND D.BRANCH_ID IS NOT NULL
        ORDER BY
            O.NICK_NAME,B.BRANCH_NAME,D.DEPARTMENT_HEAD
	</cfquery>			
	<cfreturn get_department>
</cffunction>
	 


