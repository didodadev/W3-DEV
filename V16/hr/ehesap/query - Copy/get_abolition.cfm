<cfquery  name="get_abolition" datasource="#DSN#">
	SELECT
		EDD.*,EER.*
	FROM
		EMPLOYEE_ABOLITION EDD,
		EMPLOYEES_EVENT_REPORT EER
	WHERE
		EER.EVENT_ID=EDD.EVENT_ID
	<cfif isdefined("attributes.EVENT_ID")>
		AND EER.EVENT_ID=#attributes.EVENT_ID#
	</cfif>
	<cfif isdefined("attributes.ABOLITION_ID")>
		AND EDD.ABOLITION_ID=#attributes.ABOLITION_ID#
	</cfif>	
</cfquery>
