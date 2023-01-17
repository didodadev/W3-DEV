<cfquery name="get_payment_request" datasource="#DSN#">
	SELECT 
		CP.*
	FROM 
		CORRESPONDENCE_PAYMENT CP
	WHERE
	CP.ID IS NOT NULL 
	AND TO_EMPLOYEE_ID IS NOT NULL
	<cfif isdefined('attributes.id')>
		AND CP.ID=#attributes.id#
	</cfif>	
</cfquery>
