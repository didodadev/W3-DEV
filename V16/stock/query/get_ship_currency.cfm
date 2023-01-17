<cfif isdefined("ship_id")>
	<cfquery name="get_ship_cur" datasource="#DSN2#">
		SELECT
			SHIP_RESULT.SHIP_RESULT_ID,
			SHIP_RESULT.SHIP_CURRENCY_ID
		FROM
			SHIP_RESULT,
			SHIP_RESULT_ROW
		WHERE
			SHIP_RESULT.SHIP_RESULT_ID = SHIP_RESULT_ROW.SHIP_RESULT_ID AND
			SHIP_RESULT_ROW.SHIP_ID = #ship_id#										
	</cfquery>
	<cfif len(get_ship_cur.SHIP_CURRENCY_ID)>
		<cfset attributes.ship_cur_id = get_ship_cur.SHIP_CURRENCY_ID >
	</cfif>
</cfif>

