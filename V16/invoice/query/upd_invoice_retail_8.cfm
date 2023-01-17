<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfscript>
			muhasebe_sil(action_id:form.invoice_id, process_type:form.old_process_type);
			cari_sil(action_id:form.invoice_id, process_type:form.old_process_type, is_delete_action:1);
		</cfscript>
		<!--- cash hareketleri siliniyor --->
		<cfquery name="GET_INVOICE_CASH_ACTIONS" datasource="#dsn2#">
			SELECT * FROM INVOICE_CASH_POS WHERE INVOICE_ID=#form.invoice_id# AND CASH_ID IS NOT NULL
		</cfquery>
		<cfset cash_action_list=listsort(valuelist(GET_INVOICE_CASH_ACTIONS.CASH_ID,','),'numeric','asc',',')>
		<cfif len(cash_action_list)>
			<cfscript>
				for(k=1; k lte listlen(cash_action_list); k=k+1)
				{
					cari_sil(action_id:listgetat(cash_action_list,k,','), process_type:35);
					muhasebe_sil(action_id:listgetat(cash_action_list,k,','), process_type:35);
				}
				butce_sil(action_id:form.invoice_id,muhasebe_db:dsn2);
			</cfscript>
			<cfquery name="DEL_CASH_ACTION" datasource="#dsn2#">
				DELETE FROM CASH_ACTIONS WHERE ACTION_ID IN (#cash_action_list#)
			</cfquery>
			<cfquery name="DEL_INVOICE_CASH" datasource="#dsn2#">
				DELETE FROM INVOICE_CASH_POS WHERE CASH_ID IN (#cash_action_list#) AND INVOICE_ID=#form.invoice_id#
			</cfquery>
		</cfif>
		<!--- pos hareketleri siliniyor --->
		<cfquery name="GET_INVOICE_POS_ACTIONS" datasource="#dsn2#">
			SELECT * FROM INVOICE_CASH_POS WHERE INVOICE_ID=#form.invoice_id# AND POS_PERIOD_ID = #session.ep.period_id#
		</cfquery>
		<cfset pos_action_list=listsort(valuelist(GET_INVOICE_POS_ACTIONS.POS_ACTION_ID,','),'numeric','asc',',')>
		<cfif len(pos_action_list)>
			<cfscript>
				for(n=1; n lte listlen(pos_action_list); n=n+1)
				{
					cari_sil(action_id:listgetat(pos_action_list,n,','), process_type:241);
					muhasebe_sil(action_id:listgetat(pos_action_list,n,','), process_type:241);
				}
			</cfscript>
			<cfquery name="DEL_CARD" datasource="#dsn2#">
				DELETE FROM #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS WHERE CREDITCARD_PAYMENT_ID IN (#pos_action_list#)
			</cfquery>
			<cfquery name="DEL_CARD_ROWS" datasource="#dsn2#">
				DELETE FROM #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS_ROWS WHERE CREDITCARD_PAYMENT_ID IN (#pos_action_list#)
			</cfquery>
			<cfquery name="DEL_CASH_ACTIONS" datasource="#dsn2#">
				DELETE FROM INVOICE_CASH_POS WHERE INVOICE_ID=#form.invoice_id# AND POS_ACTION_ID IN (#pos_action_list#) AND POS_PERIOD_ID = #session.ep.period_id#
			</cfquery>
		</cfif>
		<!---// cash ve pos hareketleri siliniyor --->
		<cfif len(GET_NUMBER.IS_WITH_SHIP) and GET_NUMBER.IS_WITH_SHIP>
			<!--- 20040311 IS_WITH_SHIP bos olamaz ama fatura ile iliskili kayıt yoksa --->
			<cfquery name="GET_SHIP" datasource="#dsn2#">
				SELECT 
					INV_S.SHIP_ID,
					SHIP.SHIP_TYPE 
				FROM 
					SHIP,
					INVOICE_SHIPS INV_S 
				WHERE 
					INV_S.INVOICE_ID = #form.invoice_id# AND 
					INV_S.SHIP_ID=SHIP.SHIP_ID AND
					SHIP.IS_WITH_SHIP=1 
			</cfquery>
			<cfif get_ship.recordcount>
				<cfquery name="DEL_STOCKS_ROW" datasource="#dsn2#">
					DELETE FROM STOCKS_ROW WHERE PROCESS_TYPE=#GET_SHIP.SHIP_TYPE# AND UPD_ID=#GET_SHIP.SHIP_ID#
				</cfquery>
				<!--- seri no kayitlari silinir --->
				<cfscript>
				del_serial_no(
				process_id : GET_SHIP.SHIP_ID,
				process_cat : GET_SHIP.SHIP_TYPE, 
				period_id : session.ep.period_id
				);
				</cfscript>
				<!--- seri no kayitlari silinir --->
				<cfquery name="DEL_SHIP_ROW4" datasource="#dsn2#">
					DELETE FROM SHIP_MONEY WHERE ACTION_ID = #GET_SHIP.SHIP_ID#
				</cfquery>	
				<cfquery name="DEL_SHIP_RESULT_ROWS" datasource="#dsn2#">
					DELETE FROM SHIP_RESULT_ROW WHERE SHIP_ID = #GET_SHIP.SHIP_ID#
				</cfquery>		
				<cfquery name="DEL_SHIP_ROW" datasource="#dsn2#">
					DELETE FROM SHIP_ROW WHERE SHIP_ID = #GET_SHIP.SHIP_ID#
				</cfquery>
				<cfquery name="DEL_SHIP" datasource="#dsn2#">
					DELETE FROM SHIP WHERE SHIP_ID = #GET_SHIP.SHIP_ID#
				</cfquery>	
                <cfif isDefined("attributes.order_id_listesi") and len(attributes.order_id_listesi)>
                    <cfloop list="#attributes.order_id_listesi#" index="kk">
                        <cfquery name="DEL_ORDERS_SHIP" datasource="#dsn2#"> 
                            DELETE FROM #dsn3_alias#.ORDERS_SHIP WHERE SHIP_ID=#get_ship.ship_id# AND ORDER_ID=#kk# AND PERIOD_ID=#session.ep.period_id#
                        </cfquery>
                    </cfloop>
                <cfelseif isDefined("attributes.order_id") and len(attributes.order_id)>
                    <cfquery name="DEL_ORDERS_SHIP" datasource="#dsn2#"> 
                        DELETE FROM #dsn3_alias#.ORDERS_SHIP WHERE SHIP_ID=#get_ship.ship_id# AND ORDER_ID=#attributes.order_id# AND PERIOD_ID=#session.ep.period_id#
                    </cfquery>
                </cfif>
			</cfif>
		</cfif>
		<cfquery name="DEL_INVOICE_SHIPS" datasource="#dsn2#">
			DELETE FROM INVOICE_SHIPS WHERE INVOICE_ID = #form.invoice_id#
		</cfquery>
		<cfquery name="DEL_INVOICE_ROW_1" datasource="#dsn2#">
			DELETE FROM INVOICE_CONTRACT_COMPARISON WHERE MAIN_INVOICE_ID = #form.invoice_id#
		</cfquery>
		<cfquery name="DEL_INVOICE_ROW_12" datasource="#dsn2#">
			DELETE FROM INVOICE_CONTROL WHERE INVOICE_ID=#form.invoice_id#
		</cfquery>
		<cfquery name="DEL_INVOICE_ROW_123" datasource="#dsn2#">
			DELETE FROM INVOICE_CONTROL_CONTRACT_ACTIONS WHERE ACTION_ID = #form.invoice_id#
		</cfquery>
		<cfquery name="DEL_INVOICE_ROW" datasource="#dsn2#">
			DELETE FROM INVOICE_ROW WHERE INVOICE_ID=#form.invoice_id#
		</cfquery>
		<cfquery name="DEL_INVOICE_11" datasource="#dsn2#">
			DELETE FROM INVOICE_COST WHERE INVOICE_ID=#form.invoice_id#
		</cfquery>
		<cfquery name="DEL_INVOICE_111" datasource="#dsn2#">
			DELETE FROM INVOICE_MONEY WHERE ACTION_ID = #form.invoice_id#
		</cfquery>
		<cfquery name="DEL_INVOICE_1" datasource="#dsn2#">
			DELETE FROM INVOICE_GROUP_COMP_INVOICE WHERE INVOICE_ID=#form.invoice_id#
		</cfquery>
		<cfquery name="DEL_INVOICE" datasource="#dsn2#">
			DELETE FROM INVOICE WHERE INVOICE_ID=#form.invoice_id#
		</cfquery>
		<cfif (isdefined("attributes.order_id") and len(attributes.order_id)) or (isdefined("attributes.order_id_listesi") and len(attributes.order_id_listesi))>
            <cfquery name="del_orders_invoice" datasource="#dsn2#">
                DELETE FROM #dsn3_alias#.ORDERS_INVOICE WHERE ORDER_ID = <cfif isdefined("attributes.order_id") and len(attributes.order_id)>#attributes.order_id#<cfelse>#attributes.order_id_listesi#</cfif> AND INVOICE_ID = #form.invoice_id# AND PERIOD_ID = #session.ep.period_id#
            </cfquery>
        </cfif>
		<!--- Belge Silindiginde Bagli Uyari/Onaylar Da Silinir --->
		<cfquery name="Del_Relation_Warnings" datasource="#dsn2#">
			DELETE FROM #dsn_alias#.PAGE_WARNINGS WHERE ACTION_TABLE = 'INVOICE' AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.invoice_id#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
		</cfquery>
		<cf_add_log log_type="-1" action_id="#form.invoice_id# " action_name="#form.invoice_number# Silindi" paper_no="#get_number.invoice_number#" process_stage="#get_number.process_cat#"  process_type="#form.old_process_type#" data_source="#dsn2#">
	</cftransaction>
</cflock>
