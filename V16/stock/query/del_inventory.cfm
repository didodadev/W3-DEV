<cfquery name="get_inv_stock" datasource="#dsn2#">
	SELECT 
    	* 
    FROM 
    	STOCK_FIS 
    WHERE 
	    RELATED_SHIP_ID = #row_ship_id#
</cfquery>
<cfif get_inv_stock.recordcount>
	<cfset attributes.fis_id = get_inv_stock.FIS_ID>
	<cfset attributes.old_process_type = get_inv_stock.FIS_TYPE>
	<cfset attributes.head = get_inv_stock.FIS_NUMBER>
	<cfquery name="DEL_INV" datasource="#dsn2#">
		DELETE FROM #dsn3_alias#.INVENTORY WHERE INVENTORY_ID IN (SELECT INVENTORY_ID FROM #dsn3_alias#.INVENTORY_ROW WHERE ACTION_ID = #get_inv_stock.FIS_ID# AND PROCESS_TYPE = #get_inv_stock.FIS_TYPE# AND PERIOD_ID = #session.ep.period_id# AND SUBSCRIPTION_ID = #get_inv_stock.SUBSCRIPTION_ID#)
	</cfquery>
	<cfquery name="DEL_INV_ROW" datasource="#dsn2#">
		DELETE FROM #dsn3_alias#.INVENTORY_ROW WHERE ACTION_ID = #get_inv_stock.FIS_ID# AND PROCESS_TYPE = #get_inv_stock.FIS_TYPE# AND PERIOD_ID = #session.ep.period_id# AND SUBSCRIPTION_ID = #get_inv_stock.SUBSCRIPTION_ID#
	</cfquery>
	<cfinclude template="../../inventory/query/del_invent_stock_fis_ic.cfm">
</cfif>

