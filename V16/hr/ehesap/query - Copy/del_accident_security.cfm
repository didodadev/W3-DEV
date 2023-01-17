<cfquery name="UPD_QUIZ_stage" datasource="#dsn#">
DELETE
	FROM
		EMPLOYEE_ACCIDENT_SECURITY
	WHERE
		ACCIDENT_SECURITY_ID = #attributes.ACCIDENT_SECURITY_ID#
</cfquery>

<cflocation url="#request.self#?fuseaction=ehesap.form_add_accident_security" addtoken="no">
