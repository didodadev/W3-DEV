<cfquery name="get_process" datasource="#dsn2#">
	SELECT PAPER_NO FROM BANK_ACTIONS WHERE ACTION_ID=#attributes.id#
</cfquery>
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="CONTROL_BANK_ORDER" datasource="#dsn2#">
			SELECT BANK_ORDER_ID FROM BANK_ACTIONS WHERE ACTION_ID = #attributes.id#
		</cfquery>
		<cfif len(control_bank_order.bank_order_id)>
			<cfquery name="BANK_ORDER_PROCESS_TYPE" datasource="#dsn2#">
				SELECT 
					SPR.PROCESS_TYPE,
					SPR.IS_CARI,
					BANK_ORDERS.BANK_ORDER_TYPE,
					BANK_ORDERS.BANK_ORDER_TYPE_ID
				FROM 
					#dsn3_alias#.SETUP_PROCESS_CAT AS SPR,
					BANK_ORDERS 
				WHERE 
					SPR.PROCESS_CAT_ID = BANK_ORDERS.BANK_ORDER_TYPE_ID
					AND SPR.PROCESS_TYPE=BANK_ORDERS.BANK_ORDER_TYPE
					AND BANK_ORDERS.BANK_ORDER_ID=#control_bank_order.bank_order_id#
			</cfquery>
			<cfif BANK_ORDER_PROCESS_TYPE.IS_CARI>
				<cfquery name="upd_cari_action" datasource="#dsn2#">
					UPDATE 
						CARI_ROWS
					SET 
						IS_PROCESSED=0
					WHERE 
						ACTION_ID=#control_bank_order.bank_order_id# AND
						ACTION_TYPE_ID=#BANK_ORDER_PROCESS_TYPE.BANK_ORDER_TYPE#
				</cfquery>
			</cfif>
			<cfquery name="UPD_BANK_ORDERS" datasource="#dsn2#">
				UPDATE BANK_ORDERS SET IS_PAID=0 WHERE BANK_ORDER_ID=#control_bank_order.bank_order_id#
			</cfquery>
		</cfif>
		<cfscript>
			cari_sil(action_id:attributes.id,process_type:attributes.old_process_type);
			muhasebe_sil(action_id:attributes.id,process_type:attributes.old_process_type);
			butce_sil(action_id:attributes.id,process_type:attributes.old_process_type);
		</cfscript>		
		<cfquery name="DEL_BANK_ACTION_MONEY" datasource="#dsn2#">
			DELETE FROM BANK_ACTION_MONEY WHERE ACTION_ID = #attributes.id#
		</cfquery>
		<cfquery name="DEL_FROM_BANK_ACTIONS" datasource="#dsn2#">
			DELETE FROM BANK_ACTIONS WHERE ACTION_ID = #attributes.id#
		</cfquery>
		<cf_add_log log_type="-1" action_id="#attributes.id#" action_name="#attributes.head#" process_type="#attributes.old_process_type#"  paper_no="#get_process.paper_no#" data_source="#dsn2#">
	</cftransaction>
</cflock>
<cfif isdefined("attributes.is_popup")> 
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
<cfelse>
	<script type="text/javascript">
		window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.list_bank_actions';	
	</script>
</cfif>
