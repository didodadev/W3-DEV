<!---sipariş silindiğinde parçalı cari ödeme planı sablonu silinir --->
<cfquery name="DEL_PAYMENT_PLANS" datasource="#dsn3#">
	DELETE FROM ORDER_PAYMENT_PLAN_ROWS WHERE PAYMENT_PLAN_ID IN (ISNULL((SELECT PAYMENT_PLAN_ID FROM ORDER_PAYMENT_PLAN WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">),0))
</cfquery>
<cfquery name="DEL_PAYMENT_PLANS" datasource="#dsn3#">
	DELETE FROM ORDER_PAYMENT_PLAN WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
</cfquery>
<!---//sipariş silindiğinde parçalı cari ödeme planı sablonu silinir --->
<cfscript>
	add_relation_rows(
		action_type:'del',
		action_dsn : '#dsn3#',
		to_table:'ORDERS',
		to_action_id : attributes.order_id
		);
</cfscript>
<cfquery name="GET_ORD_DET" datasource="#dsn3#">
	SELECT ORDER_ID,OFFER_ID,ORDER_HEAD,ORDER_NUMBER,ORDER_STAGE,PROCESS_CAT FROM ORDERS WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
</cfquery>
<cfif len(get_ord_det.offer_id) and get_ord_det.offer_id neq 0>
	<cfquery name="UPD_OFFER_ST" datasource="#dsn3#">
		UPDATE OFFER SET OFFER_CURRENCY = 1	WHERE OFFER_ID = #GET_ORD_DET.OFFER_ID#
	</cfquery>
</cfif>
<cfif len(GET_ORD_DET.PROCESS_CAT)> <!--- bütçe rezerv işlemi siliniyor --->
	<cfquery name="get_type" datasource="#dsn3#">
		SELECT PROCESS_TYPE FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = #GET_ORD_DET.PROCESS_CAT#
	</cfquery>
	<cfscript>
		butce_sil(action_id:attributes.order_id,process_type:get_type.PROCESS_TYPE,muhasebe_db:dsn3,reserv_type:1);
	</cfscript>
</cfif>
<!--- urun asortileri siliniyor	--->
<cfquery name="DEL_OFFER_ASSORT_ROWS" datasource="#DSN3#">
	DELETE FROM
		PRODUCTION_ASSORTMENT
	WHERE
		ACTION_TYPE = 2 AND 
		ASSORTMENT_ID IN (
							SELECT
								 ORDER_ROW_ID 
							FROM
								ORDER_ROW
							WHERE
								ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
							)
</cfquery>
<cfquery name="DEL_ORDER_ROW_DEPARTMENTS" datasource="#dsn3#">
	DELETE FROM ORDER_ROW_DEPARTMENTS WHERE 
				ORDER_ROW_ID IN (
						SELECT 
							ORDER_ROW.ORDER_ROW_ID
						FROM 
							ORDER_ROW,
							ORDERS
						WHERE 	
							ORDERS.ORDER_ID = ORDER_ROW.ORDER_ID AND 
							ORDERS.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">)
</cfquery>
<cfquery name="DEL_PAPER_RELATION" datasource="#dsn3#">
	DELETE FROM
		#dsn_alias#.PAPER_RELATION
	WHERE 
		PAPER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#"> AND
		PAPER_TABLE = 'ORDERS' AND
		PAPER_TYPE_ID = 1
</cfquery>
<!--- siparis satır rezerveleri siliniyor --->
<cfquery name="DEL_ORDER_RESERVE" datasource="#dsn3#">
	DELETE FROM ORDER_ROW_RESERVED WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#"> AND SHIP_ID IS NULL
</cfquery>
<!--- siparis iç talep baglantısı sililiniyor --->
<cfquery name="DEL_ORDER_RESERVE" datasource="#dsn3#">
	DELETE FROM INTERNALDEMAND_RELATION_ROW WHERE TO_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
</cfquery>
<cfquery name="DEL_ORDER_ROW" datasource="#dsn3#">
	DELETE FROM ORDER_ROW WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
</cfquery>
<cfquery name="DEL_ORDER" datasource="#dsn3#">
	DELETE FROM ORDERS WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
</cfquery>

<!--- History Kayitlari Silinir --->
<cfquery name="Del_History_Row" datasource="#dsn3#">
	DELETE FROM ORDER_ROW_HISTORY WHERE ORDER_HISTORY_ID IN (SELECT ORDER_HISTORY_ID FROM ORDERS_HISTORY WHERE ORDERS_HISTORY.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">)
</cfquery>
<cfquery name="Del_History" datasource="#dsn3#">
	DELETE FROM ORDERS_HISTORY WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
</cfquery>
<!--- Belge Silindiginde Bagli Uyari/Onaylar Da Silinir --->
<cfquery name="Del_Relation_Warnings" datasource="#dsn3#">
	DELETE FROM #dsn_alias#.PAGE_WARNINGS WHERE ACTION_TABLE = 'ORDERS' AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cf_add_log  log_type="-1" action_id="#attributes.order_id#" action_name="#get_ord_det.order_head#-#get_ord_det.order_number#" paper_no="#get_ord_det.order_number#" process_stage="#get_ord_det.order_stage#" data_source="#dsn3#">
