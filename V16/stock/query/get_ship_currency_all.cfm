<cfquery name="get_ship_currencies" datasource="#DSN#">
	SELECT
		*
	FROM
		SHIP_CURRENCY
		<cfif isdefined('attributes.ship_cur_id')>
	WHERE
		SHIP_CURRENCY_ID=#attributes.ship_cur_id#
		</cfif>		
	ORDER BY
		SHIP_CURRENCY
</cfquery>

