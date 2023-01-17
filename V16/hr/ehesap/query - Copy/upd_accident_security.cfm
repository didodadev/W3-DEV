<cfquery name="UPD_QUIZ_stage" datasource="#dsn#">
UPDATE
	EMPLOYEE_ACCIDENT_SECURITY
SET
	ACCIDENT_SECURITY = '#attributes.ACCIDENT_SECURITY#',
	ACCIDENT_DETAIL = '#attributes.ACCIDENT_DETAIL#'
WHERE
	ACCIDENT_SECURITY_ID = #attributes.ACCIDENT_SECURITY_ID#
</cfquery>

<cflocation url="#request.self#?fuseaction=ehesap.form_add_accident_security" addtoken="no">
