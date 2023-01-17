<cfquery name="GET_LAST_RECORD" datasource="#dsn2#">
	SELECT
		MAX(ACTION_ID) AS ACT_ID
	FROM
		BANK_ACTIONS
</cfquery>
