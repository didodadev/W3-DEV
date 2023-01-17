<cfquery name="GET_PROTESTS" datasource="#DSN#">
	SELECT
	    EPP.PROTEST_DETAIL,
		EPP.ANSWER_DETAIL,
		EPP.PROTEST_DATE,
		EPP.PROTEST_ID,
		EPP.SAL_MON,
		EPP.SAL_YEAR,
		EPP.EMPLOYEE_ID,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
	FROM
		EMPLOYEES_PUANTAJ_PROTESTS EPP,
		EMPLOYEES E
	WHERE 
	    <cfif not session.ep.ehesap>
			EPP.BRANCH_ID IN (#emp_branch_list#) AND
		</cfif>
		<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
			EPP.BRANCH_ID = #attributes.branch_id# AND
		</cfif>
		<cfif len(attributes.employee_id) and len(attributes.employee_name)>
			 EPP.EMPLOYEE_ID = #attributes.employee_id# AND
		</cfif>
		<cfif len(attributes.sal_mon)>
			 EPP.SAL_MON= #attributes.sal_mon# AND
		</cfif>
		<cfif len(attributes.sal_year)>
		     EPP.SAL_YEAR=#attributes.sal_year# AND
		</cfif>
		<cfif len(attributes.answer_state)>
			 <cfif attributes.answer_state eq 0 >
			 EPP.ANSWER_DETAIL IS NOT NULL AND
			 <cfelse>
			 EPP.ANSWER_DETAIL IS NULL AND
			 </cfif>
		</cfif>
  	    E.EMPLOYEE_ID=EPP.EMPLOYEE_ID
</cfquery>

