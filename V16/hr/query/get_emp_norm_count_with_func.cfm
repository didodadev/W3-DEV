<cffunction name="get_emp_count">
	<cfargument name="mon_id" type="boolean" required="true">
	<cfargument name="b_id" type="boolean" required="true">
	<cfargument name="d_id" type="boolean" required="true">
	<cfargument name="p_id" type="boolean" required="true">
	<cfset ay=mon_id>
	<cfset yil=SESSION.EP.PERIOD_YEAR>
	<cfquery name="get_e" datasource="#DSN#">
		SELECT DISTINCT
			EP.POSITION_ID
		FROM
			EMPLOYEE_POSITIONS_HISTORY EP,
			DEPARTMENT D
		WHERE
			D.DEPARTMENT_ID = EP.DEPARTMENT_ID AND
			D.BRANCH_ID=#arguments.b_id# AND
			EP.DEPARTMENT_ID=#arguments.d_id# AND
			EP.POSITION_CAT_ID=#arguments.p_id# AND
			DATEPART(MM,EP.START_DATE) <= #ay# AND
			DATEPART(YYYY,EP.START_DATE) <= #yil# AND
			(
				(
				DATEPART(MM,EP.FINISH_DATE) >= #ay# AND
				DATEPART(YYYY,EP.FINISH_DATE) >= #yil#
				)
			OR
				EP.FINISH_DATE IS NULL
			)
	</cfquery>
	<cfreturn get_e.recordcount >
</cffunction>
