<cfquery  name="get_discipline_detail" datasource="#DSN#">
	SELECT
		EDD.*,EER.*
	FROM
		EMPLOYEE_DISCIPLINE_DECISION EDD,
		EMPLOYEES_EVENT_REPORT EER
	WHERE
		EER.EVENT_ID=EDD.EVENT_ID
	<cfif isdefined("attributes.EVENT_ID")>
		AND EER.EVENT_ID=#attributes.EVENT_ID#
	</cfif>
	<cfif isdefined("attributes.DISCIPLINE_ID")>
		AND EDD.DISCIPLINE_ID=#attributes.DISCIPLINE_ID#
	</cfif>	
</cfquery>
