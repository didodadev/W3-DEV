<cfquery name="EVENT_HEAD" datasource="#dsn#">
	SELECT
		EVENT_HEAD
	FROM
		EVENT
	WHERE
		EVENT_ID = #attributes.EVENT_ID#
</cfquery>	
	
