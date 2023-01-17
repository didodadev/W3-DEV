<cfquery name="CONS_NOTES" datasource="#dsn#">
	SELECT
		NOTE_ID,
		NOTE_HEAD,
		NOTE_BODY
	FROM
		NOTES
	WHERE
		CAMP_ID = #CAMP_ID#
		AND
		CONSUMER_ID = #attributes.CONSUMER_ID#
</cfquery>	
	

