<cffunction name="get_emp_position">
	<cfargument name="emp_id_f" >
	<cfquery name="get_e" datasource="#DSN#">
		SELECT
			EP.POSITION_NAME,
			B.BRANCH_NAME,
			D.DEPARTMENT_HEAD,
			OC.NICK_NAME
		FROM
			EMPLOYEE_POSITIONS  EP,
			DEPARTMENT D,
			BRANCH B,
			OUR_COMPANY OC
		WHERE
			OC.COMP_ID=B.COMPANY_ID
		AND
			EP.DEPARTMENT_ID=D.DEPARTMENT_ID	
		AND
			D.BRANCH_ID=B.BRANCH_ID
		AND
			EP.EMPLOYEE_ID=#emp_id_f#
	</cfquery>
	<cfset strd=" #get_e.NICK_NAME#/#get_e.BRANCH_NAME#/#get_e.DEPARTMENT_HEAD#|#get_e.POSITION_NAME#">
	<cfreturn #strd#>
</cffunction>
