<cfquery name="GET_CARD_ID" datasource="#dsn2#">
	SELECT
		MAX(CARD_ID) AS MAX_ID
	FROM
		ACCOUNT_CARD
</cfquery>
