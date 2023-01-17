<cfquery name="GET_LIST_CORRESPONDENCE" datasource="#dsn#">
	SELECT 
        C.ID, 
        C.TO_EMP, 
        C.CC_EMP, 
        C.CC_PARS, 
        C.CATEGORY, 
		C.COR_STAGE,
        C.SUBJECT, 
        C.RECORD_EMP,
        C.UPDATE_EMP, 
        C.UPDATE_IP, 
        C.RECORD_DATE, 
        C.IS_READ, 
        C.COR_STARTDATE, 
        C.COR_FINISHDATE, 
        C.CORRESPONDENCE_NUMBER, 
        C.RECORD_IP, 
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES.EMPLOYEE_ID
	FROM 
		CORRESPONDENCE C,
		EMPLOYEES
	WHERE
		YEAR(C.RECORD_DATE) = #session.ep.period_year# AND
		EMPLOYEES.EMPLOYEE_ID=C.RECORD_EMP AND 
		(
			EMPLOYEES.EMPLOYEE_ID=#session.ep.USERID# OR
			TO_EMP LIKE '%,#session.ep.USERID#,%'
		)
	<cfif isDefined("CORRCAT_ID") AND len(CORRCAT_ID) AND CORRCAT_ID NEQ 0>
		AND C.CATEGORY = #CORRCAT_ID#
	</cfif>
	<cfif isDefined("process_stage") AND len(process_stage) AND process_stage NEQ 0>
		AND C.COR_STAGE = #process_stage#
	</cfif>
	<cfif isdefined("attributes.is_active") and attributes.is_active eq 0>
		AND C.IS_READ = 1
	<cfelseif isdefined("attributes.is_active") and attributes.is_active eq 1>
		AND C.IS_READ = 0
	</cfif>
	<cfif isDefined("attributes.key") AND len(attributes.key)>
		AND C.SUBJECT LIKE '%#attributes.key#%'
	</cfif>
	ORDER BY
		C.RECORD_DATE DESC
</cfquery>
<cfset FULLNAME = "">
<cfoutput query="GET_LIST_CORRESPONDENCE">
	<cfset FULLNAME =  FULLNAME & ',' & "#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#">
</cfoutput>
