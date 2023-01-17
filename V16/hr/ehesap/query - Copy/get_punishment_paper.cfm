<cfquery  name="get_punishment_paper" datasource="#DSN#">
	SELECT
		EDD.*,EER.*
	FROM
		EMPLOYEE_PUNISHMENT_PAPER EDD,
		EMPLOYEES_EVENT_REPORT EER
	WHERE
		EER.EVENT_ID=EDD.EVENT_ID
	<cfif isdefined("attributes.EVENT_ID")>
		AND EER.EVENT_ID=#attributes.EVENT_ID#
	</cfif>
	<cfif isdefined("attributes.PUNISHMENT_PAPER_ID")>
		AND EDD.PUNISHMENT_PAPER_ID=#attributes.PUNISHMENT_PAPER_ID#
	</cfif>	
</cfquery>
