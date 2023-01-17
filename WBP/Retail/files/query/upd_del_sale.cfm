<cfif not isDefined("new_dsn2")><cfset new_dsn2 = dsn2></cfif>
<cfif not isdefined("new_dsn3_group")><cfset new_dsn3_group = dsn3></cfif>
<cfquery name="GET_PROCESS_TYPE" datasource="#new_dsn2#">
	SELECT 
		PROCESS_TYPE,
		PROCESS_CAT_ID,
		IS_CARI,
		IS_ACCOUNT,
		IS_STOCK_ACTION,
		IS_ACCOUNT_GROUP,
		IS_PROJECT_BASED_ACC,
		IS_COST,
		ACTION_FILE_NAME,
		ACTION_FILE_SERVER_ID,
		ACTION_FILE_FROM_TEMPLATE,
		ISNULL(IS_ADD_INVENTORY,0) IS_ADD_INVENTORY,
		ISNULL(IS_DEPT_BASED_ACC,0) IS_DEPT_BASED_ACC
	 FROM 
	 	#new_dsn3_group#.SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_CAT_ID = #form.process_cat#
</cfquery>
<cfscript>
	is_dept_based_acc = GET_PROCESS_TYPE.IS_DEPT_BASED_ACC;
</cfscript>


<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
    	<cfscript>
			add_relation_rows(
				action_type:'del',
				action_dsn : '#dsn2#',
				to_table:'SHIP',
				to_action_id : attributes.UPD_ID
				);
		</cfscript>
		<cfif len(GET_NUMBER.SHIP_TYPE)>
			<cfquery name="DEL1" datasource="#DSN2#">
				DELETE FROM STOCKS_ROW WHERE UPD_ID=#attributes.UPD_ID# AND PROCESS_TYPE=#GET_NUMBER.SHIP_TYPE#
			</cfquery>
		</cfif>
		<cfscript>
			if(isdefined("attributes.irsaliye_id_listesi") and len(attributes.irsaliye_id_listesi)) //irsaliyeye cekilen konsinye irsaliye varsa
			{
					include('add_ship_row_relation.cfm','\objects\functions'); 
					add_ship_row_relation(
						to_related_proc: attributes.UPD_ID,
						to_related_process_type : get_process_type.PROCESS_TYPE,
						old_related_process_type : attributes.old_process_type,
						ship_related_action_type:2,
						is_invoice_ship:1,
						process_db :dsn2
						);
			}
			/*seri no kayitlari silinir*/
			/*
			del_serial_no(
			process_id : attributes.UPD_ID,
			process_cat : GET_NUMBER.SHIP_TYPE, 
			period_id : session.ep.period_id
			);
			*/
			/*irsaliye siparis iliskisi silinip, siparis satır aşama ve rezerve bilgileri guncelleniyor*/
			add_reserve_row(
				related_process_id : attributes.UPD_ID,
				reserve_action_type:2,
				is_order_process:1,
				is_purchase_sales:1,
				process_db :dsn2
				);
			if(get_process_type.process_type eq 78)//eğer iade irsaliyesi ise ilişkili mal alım iraliyelelerinin satın alma siparişleri bulunacak
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
					add_reserve_row(
						reserve_order_id:get_related_order_row.order_id[kk_order],
						related_process_id : get_related_order_row.ship_id[kk_order],
						reserve_action_type:1,
						reserve_process_type:78,
						reserve_action_iptal : 0,
						is_order_process:1,
						is_purchase_sales:0,
						is_stock_row_action :get_process_type.IS_STOCK_ACTION,
						process_db :dsn2
						);
				}
			}
		</cfscript>
		<cfquery name="DEL2" datasource="#DSN2#">
			DELETE FROM	SHIP_ROW WHERE SHIP_ID=#attributes.UPD_ID#
		</cfquery>
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
		<cfquery name="DEL4" datasource="#dsn2#">
			DELETE FROM SHIP_ROW_RELATION WHERE SHIP_ID = #attributes.UPD_ID# AND SHIP_PERIOD=#session.ep.period_id#
		</cfquery>
		<cfquery name="DEL4" datasource="#dsn2#">
			DELETE FROM SHIP_MONEY WHERE ACTION_ID = #attributes.UPD_ID#
		</cfquery>
		<cfquery name="DEL3" datasource="#DSN2#">
			DELETE FROM	SHIP WHERE SHIP_ID=#attributes.UPD_ID#
		</cfquery>
		<cfset row_ship_id = attributes.UPD_ID>
		<cfinclude template="../../stock/query/del_inventory.cfm">
			<cf_workcube_process_cat 
				process_cat="#form.process_cat#"
				action_id = "#attributes.UPD_ID#"
				action_table="SHIP"
				action_column="SHIP_ID"
				is_action_file = 1
				action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_purchase'
				action_file_name='#get_process_type.action_file_name#'
				action_db_type = '#dsn2#'
				is_template_action_file = '#get_process_type.action_file_from_template#'>
	</cftransaction>
</cflock>