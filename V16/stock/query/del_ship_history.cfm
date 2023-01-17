<cfquery name="del_ship_history" datasource="#dsn2#">
	DELETE FROM SHIP_HISTORY WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd_id#">
</cfquery>
<cfquery name="del_ship_row_history" datasource="#dsn2#">
	DELETE FROM SHIP_ROW_HISTORY WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upd_id#">
</cfquery>
