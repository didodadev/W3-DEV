<cfquery name="get_defence" datasource="#DSN#">
	SELECT
		EDDP.*,
		EVR.TO_CAUTION
	FROM
		EMPLOYEE_DEFENCE_DEMAND_PAPER EDDP,
		EMPLOYEES_EVENT_REPORT EVR
	WHERE
	<cfif isdefined("attributes.event_id")>
		EDDP.EVENT_ID=#attributes.event_id#
	<cfelse>
		EDDP.DEFENCE_ID=#attributes.defence_id#
	</cfif>
	AND
		EDDP.EVENT_ID=EVR.EVENT_ID
</cfquery>
