<cfquery name="GET_STICKER" datasource="#DSN#">
	SELECT
		*	
	FROM
		SETUP_STICKER	
	WHERE
		STICKER_ID=#attributes.STICKER_ID#
</cfquery>
