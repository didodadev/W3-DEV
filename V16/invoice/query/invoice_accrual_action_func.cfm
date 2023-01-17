<cffunction name = "merge_ifrs_card">
	<cfargument name = "standard_card_id" type = "numeric" required = "yes">
	<cfargument name = "ifrs_card_id" type = "numeric" required = "yes">

	<cfquery name = "del_ifrs_rows" datasource = "#dsn2#" result = "r1">
		DELETE FROM ACCOUNT_ROWS_IFRS WHERE CARD_ID = #arguments.standard_card_id#
	</cfquery>
	<cfquery name = "del_ifrs_card" datasource = "#dsn2#" result = "r2">
		DELETE FROM ACCOUNT_CARD WHERE CARD_ID = #arguments.ifrs_card_id#
	</cfquery>
	<cfquery name = "del_std_rows" datasource = "#dsn2#" result = "r2">
		DELETE FROM ACCOUNT_CARD_ROWS WHERE CARD_ID = #arguments.ifrs_card_id#
	</cfquery>
	<cfquery name = "upd_ifrs_rows" datasource = "#dsn2#" result = "r3">
		UPDATE ACCOUNT_ROWS_IFRS SET CARD_ID = #arguments.standard_card_id# WHERE CARD_ID = #arguments.ifrs_card_id#
	</cfquery>

	<cfreturn 1>
</cffunction>
