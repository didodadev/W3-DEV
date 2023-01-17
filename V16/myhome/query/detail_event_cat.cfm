<cfquery name="DETAIL_EVENT_CAT" datasource="#DSN#">
		SELECT
			EVENT_ID,
			EVENT_HEAD,
			EVENTCAT_ID
		FROM
			EVENT
		WHERE 
			EVENT_ID = #attributes.EVENT_ID#
</cfquery>
