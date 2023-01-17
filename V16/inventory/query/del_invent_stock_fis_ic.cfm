<cfquery name="DEL_STOCKS_ROW" datasource="#dsn2#">
	DELETE FROM STOCKS_ROW WHERE PROCESS_TYPE=#attributes.old_process_type# AND UPD_ID=#attributes.fis_id#
</cfquery>
<cfquery name="DEL_SHIP_ROW_MONEY" datasource="#dsn2#">
	DELETE FROM STOCK_FIS_MONEY WHERE ACTION_ID = #attributes.fis_id#
</cfquery>			
<cfquery name="DEL_STOCK_FIS_ROW" datasource="#DSN2#">
	DELETE FROM STOCK_FIS_ROW WHERE FIS_ID = #attributes.fis_id#
</cfquery>
<cfquery name="DEL_STOCK_FIS" datasource="#DSN2#">
	DELETE FROM STOCK_FIS WHERE FIS_ID = #attributes.fis_id#
</cfquery>
<cfif attributes.old_process_type eq 1182>
	<cfquery name="DEL_INVENTORY_ROW" datasource="#dsn2#">
		DELETE FROM #dsn3_alias#.INVENTORY_ROW WHERE ACTION_ID = #attributes.fis_id# AND PROCESS_TYPE = #attributes.old_process_type# AND PERIOD_ID = #session.ep.period_id#
	</cfquery>
	<cfquery name="DEL_INVENTORY_HISTORY" datasource="#dsn2#">
		DELETE FROM #dsn3_alias#.INVENTORY_HISTORY WHERE ACTION_ID = #attributes.fis_id# AND ACTION_TYPE = #attributes.old_process_type#
	</cfquery>
<cfelse>
	<cfquery name="DEL_INVENTORY" datasource="#dsn2#">
		DELETE FROM #dsn3_alias#.INVENTORY WHERE INVENTORY_ID IN(SELECT INVENTORY_ID FROM #dsn3_alias#.INVENTORY_ROW WHERE ACTION_ID = #attributes.fis_id# AND PROCESS_TYPE = #attributes.old_process_type# AND PERIOD_ID = #session.ep.period_id#)
	</cfquery>
	<cfquery name="DEL_INVENTORY_ROW" datasource="#dsn2#">
		DELETE FROM #dsn3_alias#.INVENTORY_ROW WHERE ACTION_ID = #attributes.fis_id# AND PROCESS_TYPE = #attributes.old_process_type# AND PERIOD_ID = #session.ep.period_id#
	</cfquery>
	<cfquery name="DEL_INVENTORY_HISTORY" datasource="#dsn2#">
		DELETE FROM #dsn3_alias#.INVENTORY_HISTORY WHERE ACTION_ID = #attributes.fis_id# AND ACTION_TYPE = #attributes.old_process_type#
	</cfquery>
</cfif>
<cfscript>
	muhasebe_sil(action_id:attributes.fis_id, process_type:attributes.old_process_type);
	butce_sil(action_id:attributes.fis_id,process_type:attributes.old_process_type);
</cfscript>
