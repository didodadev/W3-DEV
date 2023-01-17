<cfquery name="GET_NUMBER" datasource="#dsn2#">
	SELECT CASH_ID,IS_WITH_SHIP,PROCESS_CAT,INVOICE_NUMBER FROM INVOICE WHERE INVOICE_ID=#attributes.invoice_id#
</cfquery>
<cfquery name="GET_CREDIT_ACTIONS" datasource="#dsn3#">
	SELECT CREDITCARD_EXPENSE_ID, INVOICE_ID FROM CREDIT_CARD_BANK_EXPENSE WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> 
</cfquery>
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfif len(get_number.cash_id)>
			<cfquery name="DEL_CASH_ACTION" datasource="#dsn2#">
				DELETE FROM CASH_ACTIONS WHERE ACTION_ID = #GET_NUMBER.CASH_ID#
			</cfquery>
			<cfquery name="DEL_CASH_ACTION_MONEY" datasource="#dsn2#">
				DELETE FROM CASH_ACTION_MONEY WHERE ACTION_ID = #GET_NUMBER.CASH_ID# 
			</cfquery>
			<cfscript>
			if(attributes.old_process_type eq 65)
			{
				muhasebe_sil(action_id:get_number.cash_id, process_type:34);
				cari_sil(action_id:get_number.cash_id, process_type:34);
			}
			else
			{
				muhasebe_sil(action_id:get_number.cash_id, process_type:35);
				cari_sil(action_id:get_number.cash_id, process_type:35);
			}
			</cfscript>
		</cfif>
		<cfif GET_CREDIT_ACTIONS.recordcount>
			<cfquery name="DEL_CARD_ACTIONS" datasource="#dsn2#">
				DELETE FROM #dsn3#.CREDIT_CARD_BANK_EXPENSE WHERE INVOICE_ID = #GET_CREDIT_ACTIONS.INVOICE_ID#
			</cfquery>
			<cfscript>
				muhasebe_sil(action_id:GET_CREDIT_ACTIONS.CREDITCARD_EXPENSE_ID, process_type:242);
				cari_sil(action_id:GET_CREDIT_ACTIONS.CREDITCARD_EXPENSE_ID, process_type:242);
			</cfscript>
		</cfif>
		<cfif len(GET_NUMBER.IS_WITH_SHIP) and GET_NUMBER.IS_WITH_SHIP>
			<cfquery name="GET_SHIP" datasource="#dsn2#">
				SELECT 
					INV_S.SHIP_ID,
					SHIP.SHIP_TYPE 
				FROM 
					SHIP,
					INVOICE_SHIPS INV_S 
				WHERE 
					INV_S.INVOICE_ID = #attributes.invoice_id# AND 
					INV_S.SHIP_ID=SHIP.SHIP_ID AND
					INV_S.SHIP_PERIOD_ID=#session.ep.period_id# AND
					SHIP.IS_WITH_SHIP = 1 
			</cfquery>
			<cfif GET_SHIP.recordcount>
				<cfquery name="DEL_SHIP_MONEY" datasource="#dsn2#">
					DELETE FROM SHIP_MONEY WHERE ACTION_ID = #GET_SHIP.SHIP_ID#
				</cfquery>
				<cfquery name="DEL_SHIP_ROW" datasource="#dsn2#">
					DELETE FROM SHIP_ROW WHERE SHIP_ID = #GET_SHIP.SHIP_ID#
				</cfquery>
				<cfquery name="DEL_SHIP" datasource="#dsn2#">
					DELETE FROM SHIP WHERE SHIP_ID = #GET_SHIP.SHIP_ID#
				</cfquery>
			</cfif>
		</cfif>
		<cfquery name="DEL_INVOICE_SHIPS" datasource="#dsn2#">
			DELETE FROM INVOICE_SHIPS WHERE INVOICE_ID = #attributes.invoice_id#
		</cfquery>
		<cfquery name="DEL_INVOICE_MONEY" datasource="#dsn2#">
			DELETE FROM INVOICE_MONEY WHERE ACTION_ID = #attributes.invoice_id#
		</cfquery>
		<cfquery name="DEL_INVOICE_ROW" datasource="#dsn2#">
			DELETE FROM INVOICE_ROW WHERE INVOICE_ID=#attributes.invoice_id#
		</cfquery>
		<cfquery name="DEL_INVOICE" datasource="#dsn2#">
			DELETE FROM INVOICE WHERE INVOICE_ID = #attributes.invoice_id#
		</cfquery>
		<cfif attributes.old_process_type eq 65>
			<cfquery name="DEL_INVENTORY" datasource="#dsn2#">
				DELETE FROM #dsn3_alias#.INVENTORY WHERE INVENTORY_ID IN(SELECT INVENTORY_ID FROM #dsn3_alias#.INVENTORY_ROW WHERE ACTION_ID = #attributes.invoice_id# AND PROCESS_TYPE = #attributes.old_process_type# AND PERIOD_ID = #session.ep.period_id#)
			</cfquery>
			<cfquery name="DEL_INVENTORY_ROW" datasource="#dsn2#">
				DELETE FROM #dsn3_alias#.INVENTORY_ROW WHERE ACTION_ID = #attributes.invoice_id# AND PROCESS_TYPE = #attributes.old_process_type# AND PERIOD_ID = #session.ep.period_id#
			</cfquery>
			<cfquery name="DEL_INVENTORY_HISTORY" datasource="#dsn2#">
				DELETE FROM #dsn3_alias#.INVENTORY_HISTORY WHERE ACTION_ID = #attributes.invoice_id# AND ACTION_TYPE = #attributes.old_process_type#
			</cfquery>
			<cfquery name="upd_efatura" datasource="#dsn2#">
				UPDATE
					EINVOICE_RECEIVING_DETAIL
				SET
					INVOICE_ID = NULL,
					IS_PROCESS = 0,
					STATUS = NULL,
					UPDATE_DATE = #CREATEODBCDATETIME(NOW())#
				WHERE
					INVOICE_ID = #attributes.invoice_id#
			</cfquery>
		<cfelse>
			<cfquery name="DEL_INVENTORY_ROW" datasource="#dsn2#">
				DELETE FROM #dsn3_alias#.INVENTORY_ROW WHERE ACTION_ID = #attributes.invoice_id# AND PROCESS_TYPE = #attributes.old_process_type# AND PERIOD_ID = #session.ep.period_id#
			</cfquery>
			<cfquery name="DEL_INVENTORY_HISTORY" datasource="#dsn2#">
				DELETE FROM #dsn3_alias#.INVENTORY_HISTORY WHERE ACTION_ID = #attributes.invoice_id# AND ACTION_TYPE = #attributes.old_process_type#
			</cfquery>
		</cfif>
        <cfquery name="DEL_INVOICE_TAXES" datasource="#dsn2#">
            DELETE FROM INVOICE_TAXES WHERE INVOICE_ID = #attributes.invoice_id#
        </cfquery>
        
		<cfscript>
			muhasebe_sil(action_id:attributes.invoice_id, process_type:attributes.old_process_type);
			cari_sil(action_id:attributes.invoice_id, process_type:attributes.old_process_type);
			butce_sil(action_id:attributes.invoice_id,muhasebe_db:dsn2,process_type:attributes.old_process_type);
		</cfscript>
	<cf_add_log  log_type="-1" action_id="#attributes.invoice_id#" action_name="#attributes.head# Silindi"  process_type="#attributes.old_process_type#" paper_no="#get_number.invoice_number#" data_source="#dsn2#">
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#</cfoutput>?fuseaction=invent.list_actions";
</script>
