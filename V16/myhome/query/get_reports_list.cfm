<cfquery name="get_reports" datasource="#dsn#">
	SELECT
		REPORTS.REPORT_ID,
		REPORTS.REPORT_NAME,
		REPORTS.IS_SPECIAL,
		REPORTS.RECORD_DATE,
		REPORTS.REPORT_DETAIL,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		REPORTS.RECORD_EMP
	FROM
		REPORTS,
		EMPLOYEES
	WHERE
	    EMPLOYEE_ID = REPORTS.RECORD_EMP
	<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		AND
		(
			REPORTS.REPORT_NAME LIKE '%#attributes.keyword#%'
			OR
			REPORTS.REPORT_DETAIL LIKE '%#attributes.keyword#%'
		)
	</cfif>
	<cfif isdefined("attributes.MODULE_ID") and (attributes.MODULE_ID NEQ 0)>
		AND
		REPORTS.MODULE_ID = #attributes.MODULE_ID#
	</cfif>
	<cfif isdefined("attributes.REPORT_STATUS") and (attributes.REPORT_STATUS NEQ -1)>
		AND
		REPORTS.REPORT_STATUS = #attributes.REPORT_STATUS#
	<cfelseif not isDefined("attributes.REPORT_STATUS")>
		AND
		REPORTS.REPORT_STATUS = 1
	</cfif>
	ORDER BY
		REPORT_NAME
</cfquery>
