<cfif isdefined("caller.dsn")>
	<cfset dsn = caller.dsn>
</cfif>

<cfquery name="get_reports" datasource="#dsn#">
   SELECT
      R.REPORT_NAME,
	  R.REPORT_ID,
	  R.IS_SPECIAL,
	  R.RECORD_EMP,
	  R.REPORT_DETAIL,
	  R.RECORD_DATE,
	  E.EMPLOYEE_NAME,
	  E.EMPLOYEE_SURNAME
	FROM 
	  <cfif session.ep.admin neq 1>REPORT_ACCESS_RIGHTS,</cfif>
	  REPORTS R,
	  EMPLOYEES E	  
	WHERE 
		RM.REPORT_ID = R.REPORT_ID AND
		E.EMPLOYEE_ID = R.RECORD_EMP AND
		R.REPORT_STATUS = 1 
	<cfif session.ep.admin neq 1>
		AND
		R.ADMIN_STATUS <> 1
		AND REPORT_ACCESS_RIGHTS.REPORT_ID = R.REPORT_ID
		AND (POS_CAT_ID IN (SELECT POSITION_CAT_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #session.ep.userid#)
		     OR POS_CODE IN (SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #session.ep.userid#))
	</cfif>
	ORDER BY
		R.REPORT_NAME 
</cfquery>
