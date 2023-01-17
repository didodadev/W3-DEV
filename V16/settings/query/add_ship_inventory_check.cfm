<cfquery name="get_ships" datasource="#dsn2#">
	SELECT
		SHIP.*
	FROM
		SHIP 
	WHERE
		SHIP.SHIP_ID = #attributes.action_id#
		AND SUBSCRIPTION_ID IS NOT NULL
</cfquery>
<cfset row_ship_id = get_ships.ship_id>
<cfset row_ship_type = get_ships.ship_type>
<cfif get_ships.recordcount and row_ship_type eq 71><!--- satis irsaliyesi ise --->
	<cfquery name="get_stock_fis" datasource="#kaynak_dsn2#">
		SELECT * FROM STOCK_FIS WHERE RELATED_SHIP_ID = #row_ship_id# AND FIS_TYPE = 118
	</cfquery>
	<cfset GET_S_ID.MAX_ID = get_stock_fis.FIS_ID>
<cfelseif get_ships.recordcount><!--- iade irsaliyesi ise --->
	<cfquery name="get_stock_fis" datasource="#kaynak_dsn2#">
		SELECT FIS_ID,FIS_TYPE,PROCESS_CAT FROM STOCK_FIS WHERE RELATED_SHIP_ID = #row_ship_id# AND FIS_TYPE = 1182
	</cfquery>
	<cfset GET_S_ID.MAX_ID = get_stock_fis.FIS_ID>
</cfif>
