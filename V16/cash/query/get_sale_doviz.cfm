<cfquery name="get_sale_doviz" datasource="#dsn2#">
	SELECT
		*
	FROM
		CASH_ACTIONS
	WHERE
		ACTION_ID = #ATTRIBUTES.ID#
		OR
		ACTION_ID = #ATTRIBUTES.ID+1#
	ORDER BY
		ACTION_ID ASC
</cfquery>
