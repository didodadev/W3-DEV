<cfquery name="PARS_NOTES" datasource="#dsn#">
	SELECT
		NOTE_ID,
		NOTE_HEAD,
		NOTE_BODY
	FROM
		NOTES
	WHERE
		CAMP_ID = #CAMP_ID#
		AND
		PARTNER_ID = #attributes.PARTNER_ID#
</cfquery>	
	

