<cfif isdefined("caller.dsn")>
	<cfset dsn = caller.dsn>
</cfif>
<cfquery name="get_queries" datasource="#dsn#">
	SELECT
		REPORT.REPORT_ID,
		REPORT.REPORT_NAME,
		REPORT.RECORD_DATE,
		REPORT.REPORT_DETAIL,
		EMPLOYEES.EMPLOYEE_ID,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME
	FROM
		REPORT,
		EMPLOYEES
	WHERE
		EMPLOYEES.EMPLOYEE_ID = REPORT.RECORD_EMP
		 
		<!---REPORT.MODULE_ID = #CALLER.attributes.module_id#--->
		<cfif isdefined("attributes.MODULE_ID")>
	     AND
		 REPORT.MODULE_ID = #attributes.MODULE_ID#
	    <cfelseif isdefined("CALLER.attributes.MODULE_ID")>
	     AND
		 REPORT.MODULE_ID = #CALLER.attributes.MODULE_ID#
	    </cfif>
	<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		AND
		(
		REPORT.REPORT_NAME LIKE '%#attributes.keyword#%'
		OR
		REPORT.REPORT_DETAIL LIKE '%#attributes.keyword#%'
		)
	</cfif>
	<cfif isdefined("attributes.QUERY_STATUS") and (attributes.QUERY_STATUS NEQ -1)>
		AND
		REPORT.QUERY_STATUS = #attributes.QUERY_STATUS#
	<cfelseif not isDefined("attributes.QUERY_STATUS")>
		AND
		REPORT.QUERY_STATUS = 1
	</cfif>
	ORDER BY
		REPORT.REPORT_NAME
</cfquery>
