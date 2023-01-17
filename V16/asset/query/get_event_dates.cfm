<cfif isDefined("attributes.EVENT_ID")>
	<cfquery name="EVENT_DATES" datasource="#dsn#">
		SELECT
			STARTDATE,
			FINISHDATE
		FROM
			EVENT
		WHERE
			EVENT_ID = #attributes.EVENT_ID#
	</cfquery>
</cfif>
