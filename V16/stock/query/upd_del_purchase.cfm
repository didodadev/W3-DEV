<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
    	
		<cfscript>
			add_relation_rows(
				action_type:'del',
				action_dsn : '#dsn2#',
				to_table:'SHIP',
				to_action_id : attributes.UPD_ID
				);
			if(isdefined("attributes.irsaliye_id_listesi") and len(attributes.irsaliye_id_listesi)) //irsaliyeye cekilen konsinye irsaliye varsa
			{
				add_ship_row_relation(
					to_related_process_id : attributes.UPD_ID,
					to_related_process_type : get_process_type.PROCESS_TYPE,
					old_related_process_type : attributes.old_process_type,
					ship_related_action_type:2,
					is_invoice_ship:1,
					process_db :dsn2
					);
			}
			//seri no kayitlari silinir
			del_serial_no(
			process_id : attributes.UPD_ID,
			process_cat : get_process_type.process_type, 
			period_id : session.ep.period_id
			);
			
			/*irsaliye siparis iliskisi silinip, siparis satır aşama ve rezerve bilgileri guncelleniyor*/
			add_reserve_row(
				related_process_id : attributes.UPD_ID,
				reserve_action_type:2,
				is_order_process:1,
				is_purchase_sales:0,
				process_db :dsn2
				);
			if(get_process_type.process_type eq 74 or get_process_type.process_type eq 73)//eğer iade irsaliyesi ise ilişkili mal alım iraliyelelerinin satın alma siparişleri bulunacak
			{
				get_related_order_row = cfquery(datasource : "#dsn2#", sqlstring : "SELECT ORR.ORDER_ID,SR.SHIP_ID,SR.AMOUNT OLD_AMOUNT,SR.WRK_ROW_ID FROM #dsn3_alias#.ORDER_ROW ORR,SHIP_ROW SR,SHIP_ROW SRR WHERE ORR.WRK_ROW_ID = SR.WRK_ROW_RELATION_ID AND SR.WRK_ROW_ID = SRR.WRK_ROW_RELATION_ID AND SRR.SHIP_ID = #attributes.UPD_ID#");
				for(kk_order=1;kk_order<=get_related_order_row.recordcount;kk_order++)
				{
					get_total_ship_amount = cfquery(datasource : "#dsn2#", sqlstring : "SELECT SUM(SRR.AMOUNT) AMOUNT FROM SHIP_ROW SRR WHERE SRR.WRK_ROW_RELATION_ID='#get_related_order_row.WRK_ROW_ID# AND SHIP_ID <> #attributes.UPD_ID#'");
					if(get_total_ship_amount.recordcount and len(get_total_ship_amount.amount))
						amount_new = get_related_order_row.old_amount - get_total_ship_amount.amount;
					else
						amount_new = get_related_order_row.old_amount;
					if(amount_new lt 0) amount_new = 0;
					upd_row = cfquery(datasource : "#dsn2#",is_select:0, sqlstring : "UPDATE #dsn3_alias#.ORDER_ROW_RESERVED SET STOCK_IN = #amount_new# WHERE ORDER_ID = #get_related_order_row.order_id[kk_order]# AND SHIP_ID = #get_related_order_row.ship_id[kk_order]# AND PERIOD_ID=#session.ep.period_id#");
				}
			}
		</cfscript>
		
		<!--- sevkiyat planinda irsaliye iliskisini silmek icin eklendi fbs 20091210 --->
		<cfquery name="ship_result_control" datasource="#dsn2#">
			SELECT SHIP_ID,SR.SHIP_RESULT_ID FROM SHIP_RESULT SR, SHIP_RESULT_ROW SRR WHERE SR.SHIP_RESULT_ID = SRR.SHIP_RESULT_ID AND SR.IS_ORDER_TERMS = 1 AND SRR.SHIP_ID = #attributes.UPD_ID#
		</cfquery>
		<cfif ship_result_control.recordcount>
			<cfquery name="Upd_Ship_Result_Row" datasource="#dsn2#">
				UPDATE SHIP_RESULT_ROW SET SHIP_ID = NULL, SHIP_NUMBER = NULL WHERE SHIP_ID = #attributes.UPD_ID#
			</cfquery>
			<cfquery name="Upd_Ship_Result_Row_Component" datasource="#dsn2#">
				UPDATE SHIP_RESULT_ROW_COMPONENT SET SHIP_RESULT_ROW_AMOUNT = 0 WHERE SHIP_RESULT_ID = #ship_result_control.ship_result_id#
			</cfquery>
		</cfif>
		<!--- //sevkiyat planinda irsaliye iliskisini silmek icin eklendi fbs 20091210 --->
		
		<!--- seri no kayitlari silinir --->
		<cfquery name="DEL1" datasource="#dsn2#">
			DELETE FROM STOCKS_ROW WHERE UPD_ID = #attributes.UPD_ID# AND PROCESS_TYPE = #get_process_type.process_type#
		</cfquery>
		<cfquery name="DEL4" datasource="#dsn2#">
			DELETE FROM SHIP_MONEY WHERE ACTION_ID = #attributes.UPD_ID#
		</cfquery>
		<cfquery name="DEL2" datasource="#dsn2#">
			DELETE FROM	SHIP_ROW WHERE SHIP_ID = #attributes.UPD_ID#
		</cfquery>
		<cfquery name="DEL3" datasource="#dsn2#">
			DELETE FROM	SHIP WHERE SHIP_ID = #attributes.UPD_ID#
		</cfquery>
		<cfquery name="DEL4" datasource="#dsn2#">
			DELETE FROM SHIP_ROW_RELATION WHERE SHIP_ID = #attributes.UPD_ID# AND SHIP_PERIOD=#session.ep.period_id#
		</cfquery>
		<cfquery name="DEL4" datasource="#dsn2#">
			DELETE FROM SHIP_ROW_RELATION WHERE TO_SHIP_ID = #attributes.UPD_ID#
		</cfquery>
		<cfquery name="get_stock_fis" datasource="#dsn2#">
			SELECT FIS_ID,FIS_TYPE,PROCESS_CAT FROM STOCK_FIS WHERE RELATED_SHIP_ID = #attributes.UPD_ID#
		</cfquery>
		<cfif get_stock_fis.recordcount>
			<cfquery name="get_inventory_type" datasource="#dsn2#">
				SELECT PROCESS_TYPE,PROCESS_CAT_ID,IS_ACCOUNT,IS_ACCOUNT_GROUP,IS_BUDGET,IS_ACCOUNT_GROUP,IS_PROJECT_BASED_ACC,IS_BUDGET,IS_STOCK_ACTION,ACTION_FILE_NAME,ACTION_FILE_FROM_TEMPLATE,IS_COST FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #get_stock_fis.PROCESS_CAT#
			</cfquery>
			<cfquery name="del4" datasource="#dsn2#">
				DELETE FROM STOCK_FIS_ROW WHERE FIS_ID = #get_stock_fis.FIS_ID#
			</cfquery>
			<cfquery name="del5" datasource="#dsn2#">
				DELETE FROM STOCK_FIS WHERE FIS_ID = #get_stock_fis.FIS_ID#
			</cfquery>
			<cfquery name="del6" datasource="#dsn2#">
				DELETE FROM STOCK_FIS_MONEY WHERE ACTION_ID = #get_stock_fis.FIS_ID#
			</cfquery>
			<cfquery name="del6" datasource="#dsn2#">
				DELETE FROM #dsn3_alias#.INVENTORY_ROW WHERE PERIOD_ID = #session.ep.period_id# AND ACTION_ID = #get_stock_fis.FIS_ID#
			</cfquery>
			<cfquery name="del6" datasource="#dsn2#">
				DELETE FROM STOCKS_ROW WHERE UPD_ID = #get_stock_fis.FIS_ID# AND PROCESS_TYPE=#get_stock_fis.FIS_TYPE#
			</cfquery>
			<cfscript>
				muhasebe_sil(action_id:get_stock_fis.FIS_ID,process_type:get_stock_fis.FIS_TYPE);
			</cfscript>
		</cfif>

		<cfquery name="DEL_PROD_RETURN_ROWS" datasource="#dsn2#"><!--- iade irsaliyesi silindiginde, servisten iade alınan urunlerdeki silinemez kontrolu kaldırılıyor--->
			UPDATE 
				#dsn3_alias#.SERVICE_PROD_RETURN_ROWS 
			SET 
				IS_SHIP = NULL,
				RETURN_SHIP_ID = NULL,
				RETURN_SHIP_NO = NULL,
				RETURN_PERIOD_ID = NULL
			WHERE
				RETURN_SHIP_ID=#attributes.UPD_ID#
				AND RETURN_PERIOD_ID = #session.ep.period_id#
		</cfquery>
		<cfquery name="DEL3" datasource="#dsn2#">
			DELETE FROM	#dsn3_alias#.RELATION_ROW WHERE FROM_TABLE = 'SHIP_ROW' AND TO_TABLE = 'INVENTORY_ROW' AND FROM_ACTION_ID = #attributes.UPD_ID# AND PERIOD_ID = #session.ep.period_id#
		</cfquery>
		<!--- secilen islem kategorisine bir action file eklenmisse --->
			<cf_workcube_process_cat 
				process_cat="#get_process_type.process_cat_id#"
				action_id = "#attributes.UPD_ID#"
				action_table="SHIP"
				action_column="SHIP_ID"
				is_action_file = 1
				action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_purchase'
				action_file_name='#get_process_type.action_file_name#'
				action_db_type = '#dsn2#'
				is_template_action_file = '#get_process_type.action_file_from_template#'>
                <cf_add_log employee_id="#session.ep.userid#" log_type="-1" action_id="#attributes.UPD_ID#" action_name="#attributes.ship_number# Silindi" paper_no="#attributes.ship_number#" period_id="#session.ep.period_id#" process_type="#get_process_type.PROCESS_TYPE#" data_source="#dsn2#">
	</cftransaction>
</cflock>
<cfif isDefined("session.ep") and session.ep.our_company_info.is_cost eq 1 and get_process_type.IS_COST eq 1><!--- sirket maliyet takip ediliyorsa not js le yonlenioyr cunku cost_action locationda calismiyor --->	<cfscript>cost_action(action_type:2,action_id:attributes.UPD_ID,query_type:3);</cfscript>
	<script type="text/javascript">
		<cfif fusebox.circuit is 'service'>
			window.location.href="<cfoutput>#request.self#?fuseaction=service.popup_check_service_ships&service_id=#attributes.service_id#</cfoutput>";
		<cfelse>
			window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_purchase</cfoutput>";
		</cfif>
	</script>
<cfelseif isDefined("session.ep") and session.ep.our_company_info.is_cost eq 1 and isdefined("get_inventory_type.is_cost") and get_inventory_type.is_cost eq 1 and isdefined("get_stock_fis.FIS_ID")><!--- sirket maliyet takip ediliyorsa not js le yonleniyor cunku cost_action locationda calismiyor --->
	<cfscript>cost_action(action_type:3,action_id:get_stock_fis.FIS_ID,query_type:3);</cfscript>
	<script type="text/javascript">
		<cfif fusebox.circuit is 'service'>
			window.location.href="<cfoutput>#request.self#?fuseaction=service.popup_check_service_ships&service_id=#attributes.service_id#</cfoutput>";
		<cfelse>
			window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_purchase</cfoutput>";
		</cfif>
	</script>
<cfelse>
	<script type="text/javascript">
		<cfif fusebox.circuit is 'service'>
			window.location.href="<cfoutput>#request.self#?fuseaction=service.popup_check_service_ships&service_id=#attributes.service_id#</cfoutput>";
		<cfelse>
			window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_purchase</cfoutput>";
		</cfif>
	</script>
</cfif>
