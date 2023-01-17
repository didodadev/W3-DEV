<cfscript>
	//döngü içinde çalışmaması için döngü dışında yazıldı her güncelleme işleminde öncelikle tüm dağıtım silinmeli 
	if((isDefined("attributes.is_cost") and attributes.is_cost eq 0) or not isDefined("attributes.is_cost"))
		butce_sil(action_id:form.invoice_id,muhasebe_db:dsn2);
	dagilim=false;//dagilim yapılıp yapılmadığını tutacak değer ona göre is_cost set edilecek
</cfscript>

<cfquery name="DEL_ROW" datasource="#dsn2#">
	DELETE FROM INVOICE_ROW WHERE INVOICE_ID = #form.invoice_id#
</cfquery>
<cfset product_id_list=''>
<cfset stock_id_list=''>
<cfloop from="1" to="#attributes.rows_#" index="i">
	<cfif isdefined("session.ep") and session.ep.our_company_info.spect_type and isdefined('attributes.is_production#i#') and evaluate('attributes.is_production#i#') eq 1 and not(isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#')))>
		<cfset dsn_type=dsn2>
		<cfinclude template="../../objects/query/add_basket_spec.cfm">
	</cfif>
	<cf_date tarih="attributes.deliver_date#i#">
	<cfinclude template="get_dis_amount.cfm">

    <cfif isdefined('attributes.reason_code#i#') and len(evaluate('attributes.reason_code#i#'))>
    	<cfset reasonCode = Replace(evaluate('attributes.reason_code#i#'),'--','*')>
    <cfelse>
    	<cfset reasonCode = ''>
    </cfif>
    
	<cfif IsDefined("attributes.order_id") and len( attributes.order_id ) and isdefined('attributes.wrk_row_relation_id#i#') and len(evaluate('attributes.wrk_row_relation_id#i#'))>
        <cfquery name = "get_order" datasource = "#dsn2#">
            SELECT ORDER_ID FROM #dsn3#.ORDER_ROW WHERE WRK_ROW_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.wrk_row_relation_id#i#')#">
        </cfquery>
        <cfif get_order.recordcount>
            <cfset attributes.order_id = get_order.ORDER_ID />
        </cfif>
    </cfif>
	
	<cfquery name="ADD_INVOICE_ROW" datasource="#dsn2#">
		INSERT INTO
			INVOICE_ROW
        (
			PURCHASE_SALES,
			PRODUCT_ID,
			NAME_PRODUCT,
			INVOICE_ID,
			STOCK_ID,
			AMOUNT,
			UNIT,
			UNIT_ID,				
			PRICE,
			DISCOUNTTOTAL,
			GROSSTOTAL,
			NETTOTAL,
			TAXTOTAL,
			TAX,
			DUE_DATE,
			DISCOUNT1,
			DISCOUNT2,
			DISCOUNT3,
			DISCOUNT4,
			DISCOUNT5,
			DISCOUNT6,
			DISCOUNT7,
			DISCOUNT8,
			DISCOUNT9,
			DISCOUNT10,			
			DELIVER_DATE,
			DELIVER_DEPT,
			DELIVER_LOC,
			OTHER_MONEY,
			OTHER_MONEY_VALUE,
		<cfif isdefined("attributes.spect_id#i#") and len(evaluate("attributes.spect_id#i#"))>
			SPECT_VAR_ID,
			SPECT_VAR_NAME,
		</cfif>
			LOT_NO,
			PRICE_OTHER,
			OTHER_MONEY_GROSS_TOTAL,
			<!--- COST_ID, --->
			COST_PRICE,
			EXTRA_COST,
			MARGIN,
			SHIP_ID,
			SHIP_PERIOD_ID,
			PROM_COMISSION,
			PROM_COST,
			DISCOUNT_COST,
			PROM_ID,
			IS_PROMOTION,
			PROM_STOCK_ID,
			IS_COMMISSION,
			ORDER_ID,
			UNIQUE_RELATION_ID,
			PROM_RELATION_ID,
			PRODUCT_NAME2,
			AMOUNT2,
			UNIT2,
			EXTRA_PRICE,
			EK_TUTAR_PRICE,<!--- iscilik_birim_maliyeti --->
			EXTRA_PRICE_TOTAL,
			EXTRA_PRICE_OTHER_TOTAL,
			SHELF_NUMBER,
			PRODUCT_MANUFACT_CODE,
			BASKET_EXTRA_INFO_ID,
			SELECT_INFO_EXTRA,
			DETAIL_INFO_EXTRA,
			BASKET_EMPLOYEE_ID,
			LIST_PRICE,
			NUMBER_OF_INSTALLMENT,
			PRICE_CAT,
			CATALOG_ID,
			KARMA_PRODUCT_ID,
			OTV_ORAN,
			OTVTOTAL,
			WRK_ROW_ID,
			WRK_ROW_RELATION_ID,
			RELATED_ACTION_ID,
			RELATED_ACTION_TABLE,
			WIDTH_VALUE,
			DEPTH_VALUE,
			HEIGHT_VALUE,
			ROW_PROJECT_ID,
            ROW_WORK_ID,
			ROW_PAYMETHOD_ID,
            REASON_CODE,
            REASON_NAME,
            DELIVERY_CONDITION,
            CONTAINER_TYPE,
            CONTAINER_NUMBER,
            CONTAINER_QUANTITY,
            DELIVERY_COUNTRY,
            DELIVERY_CITY,
            DELIVERY_COUNTY,
            DELIVERY_TYPE,
            GTIP_NUMBER
			<cfif isdefined('attributes.row_exp_center_name#i#') and len(evaluate("attributes.row_exp_center_name#i#")) and isdefined('attributes.row_exp_center_id#i#') and len(evaluate("attributes.row_exp_center_id#i#"))>,ROW_EXP_CENTER_ID</cfif>
			<cfif isdefined('attributes.row_exp_item_name#i#') and len(evaluate("attributes.row_exp_item_name#i#")) and isdefined('attributes.row_exp_item_id#i#') and len(evaluate("attributes.row_exp_item_id#i#"))>,ROW_EXP_ITEM_ID</cfif>
			<cfif isdefined('attributes.row_acc_code#i#') and len(evaluate("attributes.row_acc_code#i#"))>,ROW_ACC_CODE</cfif>
			<cfif isdefined('attributes.row_activity_id#i#') and len(evaluate("attributes.row_activity_id#i#"))>,ACTIVITY_TYPE_ID</cfif>
			<cfif isdefined('attributes.row_subscription_name#i#') and len(evaluate("attributes.row_subscription_name#i#")) and isdefined('attributes.row_subscription_id#i#') and len(evaluate("attributes.row_subscription_id#i#"))>,SUBSCRIPTION_ID</cfif>
			<cfif isdefined('attributes.row_assetp_name#i#') and len(evaluate("attributes.row_assetp_name#i#")) and isdefined('attributes.row_assetp_id#i#') and len(evaluate("attributes.row_assetp_id#i#"))>,ASSETP_ID</cfif>
			<cfif isdefined('attributes.row_bsmv_rate#i#') and len(evaluate("attributes.row_bsmv_rate#i#"))>,BSMV_RATE</cfif>
			<cfif isdefined('attributes.row_bsmv_amount#i#') and len(evaluate("attributes.row_bsmv_amount#i#"))>,BSMV_AMOUNT</cfif>
			<cfif isdefined('attributes.row_bsmv_currency#i#') and len(evaluate("attributes.row_bsmv_currency#i#"))>,BSMV_CURRENCY</cfif>
			<cfif isdefined('attributes.row_oiv_rate#i#') and len(evaluate("attributes.row_oiv_rate#i#"))>,OIV_RATE</cfif>
			<cfif isdefined('attributes.row_oiv_amount#i#') and len(evaluate("attributes.row_oiv_amount#i#"))>,OIV_AMOUNT</cfif>
			<cfif isDefined('attributes.row_tevkifat_id#i#') and len(evaluate("attributes.row_tevkifat_id#i#"))>,TEVKIFAT_ID</cfif>
			<cfif isdefined('attributes.row_tevkifat_rate#i#') and len(evaluate("attributes.row_tevkifat_rate#i#"))>,TEVKIFAT_RATE</cfif>
			<cfif isdefined('attributes.row_tevkifat_amount#i#') and len(evaluate("attributes.row_tevkifat_amount#i#"))>,TEVKIFAT_AMOUNT</cfif>
			<cfif isDefined('attributes.otv_type#i#') and len(evaluate("attributes.otv_type#i#"))>,OTV_TYPE</cfif>
			<cfif isDefined('attributes.otv_discount#i#') and len(evaluate("attributes.otv_discount#i#"))>,OTV_DISCOUNT</cfif>
			<cfif isDefined('attributes.row_weight#i#') and len(evaluate("attributes.row_weight#i#"))>,WEIGHT</cfif>
			<cfif isDefined('attributes.row_specific_weight#i#') and len(evaluate("attributes.row_specific_weight#i#"))>,SPECIFIC_WEIGHT</cfif>
			<cfif isDefined('attributes.row_volume#i#') and len(evaluate("attributes.row_volume#i#"))>,VOLUME</cfif>
        )
		VALUES
        (
			1,
			#evaluate("attributes.product_id#i#")#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(evaluate('attributes.product_name#i#'), 500)#">,
			#form.invoice_id#,
			#evaluate("attributes.stock_id#i#")#,
			#evaluate("attributes.amount#i#")#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit#i#')#">,
			#evaluate("attributes.unit_id#i#")#,
			#evaluate("attributes.price#i#")#,
			#DISCOUNT_AMOUNT#,
			#evaluate("attributes.row_lasttotal#i#")#,
			#evaluate("attributes.row_nettotal#i#")#,
			#evaluate("attributes.row_taxtotal#i#")#,
			#evaluate("attributes.tax#i#")#,
			<cfif isdefined("attributes.duedate#i#") and len(Evaluate("attributes.duedate#i#"))>#evaluate("attributes.duedate#i#")#<cfelse>0</cfif>,
			#indirim1#,
			#indirim2#,
			#indirim3#,
			#indirim4#,
			#indirim5#,
			#indirim6#,
			#indirim7#,
			#indirim8#,
			#indirim9#,
			#indirim10#,
			<cfif isdefined("attributes.deliver_date#i#") and len(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.deliver_dept#i#") and len(trim(evaluate("attributes.deliver_dept#i#"))) and len(listfirst(evaluate("attributes.deliver_dept#i#"),"-"))>
				#listfirst(evaluate("attributes.deliver_dept#i#"),"-")#,
			<cfelseif isdefined('attributes.department_id') and len(attributes.department_id)>
				#attributes.department_id#,
			<cfelse>
				NULL,
			</cfif>
			<cfif isdefined("attributes.deliver_dept#i#") and listlen(trim(evaluate("attributes.deliver_dept#i#")),"-") eq 2 and len(listlast(evaluate("attributes.deliver_dept#i#"),"-"))>
				#listlast(evaluate("attributes.deliver_dept#i#"),"-")#,
			<cfelseif isdefined('attributes.location_id') and len(attributes.location_id)>
				#attributes.location_id#,
			<cfelse>
				NULL,
			</cfif>
			<cfif isdefined("attributes.other_money_#i#")><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.other_money_#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined("attributes.other_money_value_#i#") and len(evaluate("attributes.other_money_value_#i#"))>#evaluate("attributes.other_money_value_#i#")#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.spect_id#i#") and len(evaluate("attributes.spect_id#i#"))>
				#evaluate("attributes.spect_id#i#")#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(evaluate('attributes.spect_name#i#'),500)#">,
			</cfif>
			<cfif isdefined("attributes.lot_no#i#") and len(evaluate("attributes.lot_no#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.lot_no#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined("attributes.price_other#i#") and len(evaluate("attributes.price_other#i#"))>#evaluate("attributes.price_other#i#")#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.other_money_gross_total#i#") and len(evaluate("attributes.other_money_gross_total#i#"))>#evaluate("attributes.other_money_gross_total#i#")#<cfelse>NULL</cfif>,
			<!--- <cfif isdefined('attributes.cost_id#i#') and len(evaluate('attributes.cost_id#i#'))>#evaluate('attributes.cost_id#i#')#<cfelse>NULL</cfif>, --->
			<cfif isdefined('attributes.net_maliyet#i#') and len(evaluate('attributes.net_maliyet#i#'))>#evaluate('attributes.net_maliyet#i#')#<cfelse>0</cfif>,
			<cfif isdefined('attributes.extra_cost#i#') and len(evaluate('attributes.extra_cost#i#'))>#evaluate('attributes.extra_cost#i#')#<cfelse>0</cfif>,
			<cfif isdefined('attributes.marj#i#') and len(evaluate('attributes.marj#i#'))>#evaluate('attributes.marj#i#')#<cfelse>NULL</cfif>,
			#listfirst(ship_id,';')#,
			<cfif listlen(ship_id,';') eq 2>#listlast(ship_id,';')#<cfelse>#session.ep.period_id#</cfif>,
			<cfif isdefined('attributes.promosyon_yuzde#i#') and len(evaluate('attributes.promosyon_yuzde#i#'))>#evaluate('attributes.promosyon_yuzde#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.promosyon_maliyet#i#') and len(evaluate('attributes.promosyon_maliyet#i#'))>#evaluate('attributes.promosyon_maliyet#i#')#<cfelse>0</cfif>,
			<cfif isdefined('attributes.iskonto_tutar#i#') and len(evaluate('attributes.iskonto_tutar#i#'))>#evaluate('attributes.iskonto_tutar#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_promotion_id#i#') and len(evaluate('attributes.row_promotion_id#i#'))>#evaluate('attributes.row_promotion_id#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.is_promotion#i#') and len(evaluate('attributes.is_promotion#i#'))>#evaluate('attributes.is_promotion#i#')#<cfelse>0</cfif>,
			<cfif isdefined('attributes.prom_stock_id#i#') and len(evaluate('attributes.prom_stock_id#i#'))>#evaluate('attributes.prom_stock_id#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.is_commission#i#') and len(evaluate('attributes.is_commission#i#'))>#evaluate('attributes.is_commission#i#')#<cfelse>0</cfif>,
			<cfif isDefined("attributes.order_id") and len(attributes.order_id)>#attributes.order_id#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_unique_relation_id#i#') and len(evaluate('attributes.row_unique_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.row_unique_relation_id#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.prom_relation_id#i#') and len(evaluate('attributes.prom_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.prom_relation_id#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.product_name_other#i#') and len(evaluate('attributes.product_name_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.product_name_other#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.unit_other#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.ek_tutar#i#') and len(evaluate('attributes.ek_tutar#i#'))>#evaluate('attributes.ek_tutar#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.ek_tutar_price#i#') and len(evaluate('attributes.ek_tutar_price#i#'))>#evaluate('attributes.ek_tutar_price#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.ek_tutar_total#i#') and len(evaluate('attributes.ek_tutar_total#i#'))>#evaluate('attributes.ek_tutar_total#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.ek_tutar_other_total#i#') and len(evaluate('attributes.ek_tutar_other_total#i#'))>#evaluate('attributes.ek_tutar_other_total#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.manufact_code#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.basket_extra_info#i#') and len(evaluate('attributes.basket_extra_info#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.basket_extra_info#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.select_info_extra#i#') and len(evaluate('attributes.select_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.select_info_extra#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.detail_info_extra#i#') and len(evaluate('attributes.detail_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.detail_info_extra#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.basket_employee_id#i#') and len(evaluate('attributes.basket_employee_id#i#')) and isdefined('attributes.basket_employee#i#') and len(evaluate('attributes.basket_employee#i#'))>#evaluate('attributes.basket_employee_id#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.list_price#i#') and len(evaluate('attributes.list_price#i#'))>#evaluate('attributes.list_price#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.number_of_installment#i#') and len(evaluate('attributes.number_of_installment#i#'))>#evaluate('attributes.number_of_installment#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.price_cat#i#') and len(evaluate('attributes.price_cat#i#'))>#evaluate('attributes.price_cat#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_catalog_id#i#') and len(evaluate('attributes.row_catalog_id#i#'))>#evaluate('attributes.row_catalog_id#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.karma_product_id#i#') and len(evaluate('attributes.karma_product_id#i#'))>#evaluate('attributes.karma_product_id#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.otv_oran#i#') and len(evaluate('attributes.otv_oran#i#'))>#evaluate('attributes.otv_oran#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_otvtotal#i#') and len(evaluate('attributes.row_otvtotal#i#'))>#evaluate('attributes.row_otvtotal#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.wrk_row_id#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.wrk_row_relation_id#i#') and len(evaluate('attributes.wrk_row_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.wrk_row_relation_id#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.related_action_id#i#') and len(evaluate('attributes.related_action_id#i#'))>#evaluate('attributes.related_action_id#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.related_action_table#i#') and len(evaluate('attributes.related_action_table#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.related_action_table#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_width#i#') and len(evaluate('attributes.row_width#i#'))>#evaluate('attributes.row_width#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_depth#i#') and len(evaluate('attributes.row_depth#i#'))>#evaluate('attributes.row_depth#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_height#i#') and len(evaluate('attributes.row_height#i#'))>#evaluate('attributes.row_height#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_project_id#i#') and len(evaluate('attributes.row_project_id#i#')) and isdefined('attributes.row_project_name#i#') and len(evaluate('attributes.row_project_name#i#'))>#evaluate('attributes.row_project_id#i#')#<cfelse>NULL</cfif>,
            <cfif isdefined('attributes.row_work_id#i#') and len(evaluate('attributes.row_work_id#i#')) and isdefined('attributes.row_work_name#i#') and len(evaluate('attributes.row_work_name#i#'))>#evaluate('attributes.row_work_id#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_paymethod_id#i#') and len(evaluate('attributes.row_paymethod_id#i#'))>#evaluate('attributes.row_paymethod_id#i#')#<cfelse>NULL</cfif>,
            <cfif len(reasonCode) and reasonCode contains '*'>
            	<cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(reasonCode,'*')#">,
            	<cfqueryparam cfsqltype="cf_sql_varchar" value="#listLast(reasonCode,'*')#">
            <cfelse>
            	NULL,
                NULL
            </cfif>
            ,<cfif isdefined("attributes.delivery_condition#i#") and len(evaluate("attributes.delivery_condition#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.delivery_condition#i#')#"><cfelse>NULL</cfif>
			,<cfif isdefined("attributes.container_type#i#") and len(evaluate("attributes.container_type#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.container_type#i#')#"><cfelse>NULL</cfif>
			,<cfif isdefined("attributes.container_number#i#") and len(evaluate("attributes.container_number#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.container_number#i#')#"><cfelse>NULL</cfif>
			,<cfif isdefined("attributes.container_quantity#i#") and len(evaluate("attributes.container_quantity#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.container_quantity#i#')#"><cfelse>NULL</cfif>
			,<cfif isdefined("attributes.delivery_country#i#") and len(evaluate("attributes.delivery_country#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.delivery_country#i#')#"><cfelse>NULL</cfif>
			,<cfif isdefined("attributes.delivery_city#i#") and len(evaluate("attributes.delivery_city#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.delivery_city#i#')#"><cfelse>NULL</cfif>
			,<cfif isdefined("attributes.delivery_county#i#") and len(evaluate("attributes.delivery_county#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.delivery_county#i#')#"><cfelse>NULL</cfif>
			,<cfif isdefined("attributes.delivery_type#i#") and len(evaluate("attributes.delivery_type#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.delivery_type#i#')#"><cfelse>NULL</cfif>
			,<cfif isdefined("attributes.gtip_number#i#") and len(evaluate("attributes.gtip_number#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.gtip_number#i#')#"><cfelse>NULL</cfif>
			<cfif isdefined('attributes.row_exp_center_name#i#') and len(evaluate("attributes.row_exp_center_name#i#")) and isdefined('attributes.row_exp_center_id#i#') and len(evaluate("attributes.row_exp_center_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_exp_center_id#i#')#"></cfif>
			<cfif isdefined('attributes.row_exp_item_name#i#') and len(evaluate("attributes.row_exp_item_name#i#")) and isdefined('attributes.row_exp_item_id#i#') and len(evaluate("attributes.row_exp_item_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_exp_item_id#i#')#"></cfif>
			<cfif isdefined('attributes.row_acc_code#i#') and len(evaluate("attributes.row_acc_code#i#"))>,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate('attributes.row_acc_code#i#')#"></cfif>
			<cfif isdefined('attributes.row_activity_id#i#') and len(evaluate("attributes.row_activity_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_activity_id#i#')#"></cfif>
			<cfif isdefined('attributes.row_subscription_name#i#') and len(evaluate("attributes.row_subscription_name#i#")) and isdefined('attributes.row_subscription_id#i#') and len(evaluate("attributes.row_subscription_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_subscription_id#i#')#"></cfif>
			<cfif isdefined('attributes.row_assetp_name#i#') and len(evaluate("attributes.row_assetp_name#i#")) and isdefined('attributes.row_assetp_id#i#') and len(evaluate("attributes.row_assetp_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_assetp_id#i#')#"></cfif>
			<cfif isdefined('attributes.row_bsmv_rate#i#') and len(evaluate("attributes.row_bsmv_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_rate#i#')#"></cfif>
			<cfif isdefined('attributes.row_bsmv_amount#i#') and len(evaluate("attributes.row_bsmv_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_amount#i#')#"></cfif>
			<cfif isdefined('attributes.row_bsmv_currency#i#') and len(evaluate("attributes.row_bsmv_currency#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_currency#i#')#"></cfif>
			<cfif isdefined('attributes.row_oiv_rate#i#') and len(evaluate("attributes.row_oiv_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_oiv_rate#i#')#"></cfif>
			<cfif isdefined('attributes.row_oiv_amount#i#') and len(evaluate("attributes.row_oiv_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_oiv_amount#i#')#"></cfif>
			<cfif isDefined('attributes.row_tevkifat_id#i#') and len(evaluate("attributes.row_tevkifat_id#i#"))>,#evaluate("attributes.row_tevkifat_id#i#")#</cfif>
			<cfif isdefined('attributes.row_tevkifat_rate#i#') and len(evaluate("attributes.row_tevkifat_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_tevkifat_rate#i#')#"></cfif>
			<cfif isdefined('attributes.row_tevkifat_amount#i#') and len(evaluate("attributes.row_tevkifat_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_tevkifat_amount#i#')#"></cfif>
			<cfif isDefined('attributes.otv_type#i#') and len(evaluate("attributes.otv_type#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.otv_type#i#')#"></cfif>
			<cfif isDefined('attributes.otv_discount#i#') and len(evaluate("attributes.otv_discount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.otv_discount#i#')#"></cfif>
			<cfif isDefined('attributes.row_weight#i#') and len(evaluate("attributes.row_weight#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_weight#i#')#"></cfif>
			<cfif isDefined('attributes.row_specific_weight#i#') and len(evaluate("attributes.row_specific_weight#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_specific_weight#i#')#"></cfif>
			<cfif isDefined('attributes.row_volume#i#') and len(evaluate("attributes.row_volume#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_volume#i#')#"></cfif>
		)
	</cfquery>
	<!--- listeler, ürünlerin spec üretim karma koli stok hareketi cozumleri icin kullanılıyor --->
	<cfset product_id_list=listappend(product_id_list,evaluate("attributes.product_id#i#"))>
	<cfset stock_id_list=listappend(stock_id_list,evaluate("attributes.stock_id#i#"))>
	<cfquery name="get_sale_emp" datasource="#dsn2#">
		SELECT SALE_EMP FROM INVOICE WHERE INVOICE_ID = #form.invoice_id#
	</cfquery>
	<cfif isdefined('attributes.basket_employee_id#i#') and len(evaluate('attributes.basket_employee_id#i#')) and isdefined('attributes.basket_employee#i#') and len(evaluate('attributes.basket_employee#i#'))>
		<cfset sales_emp_id = evaluate('attributes.basket_employee_id#i#')>
	<cfelseif len(get_sale_emp.sale_emp)>
		<cfset sales_emp_id = get_sale_emp.sale_emp>
	<cfelseif isdefined("session.ep")>
		<cfset sales_emp_id = session.ep.userid>
	<cfelse>
		<cfset sales_emp_id = 0>
	</cfif>
    <!--- Eğerki  Faturamızın satırı  başka bir fatura ile ilişkili ise..--->
	<cfif not isdefined('xml_import')><!--- XML'de tanımlı olmadığı için bu kontrolü ekledik! --->
		<cfif isdefined('attributes.related_action_id#i#') and Evaluate('attributes.related_action_id#i#') gt 0 and isdefined('attributes.wrk_row_relation_id#i#') and Evaluate('attributes.wrk_row_relation_id#i#') gt 0>
			<cfscript>
				add_relation_rows(
					action_type:'add',
					action_dsn : '#dsn2#',
					to_table:'INVOICE',
					from_table:'#evaluate("attributes.RELATED_ACTION_TABLE#i#")#',
					to_wrk_row_id : Evaluate("attributes.wrk_row_id#i#"),
					from_wrk_row_id :Evaluate("attributes.wrk_row_relation_id#i#"),
					amount : Evaluate("attributes.amount#i#"),
					to_action_id : attributes.INVOICE_ID,
					from_action_id :Evaluate("attributes.related_action_id#i#")
					);
			</cfscript>
		</cfif>
    </cfif>
	<cfif (isDefined("attributes.is_cost") and attributes.is_cost eq 0) or not isDefined("attributes.is_cost")>
		<cfscript>
			if(isdefined("session.ep") and is_project_based_budget and session.ep.our_company_info.project_followup eq 1)
			{
				if(isdefined('attributes.row_project_id#i#') and len(evaluate('attributes.row_project_id#i#')) and isdefined('attributes.row_project_name#i#') and len(evaluate('attributes.row_project_name#i#')))
					inv_project_id=evaluate('attributes.row_project_id#i#'); 
				else if(isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head))
					inv_project_id=attributes.project_id; 
				else 
					inv_project_id='';
			}
			else 
				inv_project_id='';
				
			if(is_budget)
			{
				if(isdefined('attributes.branch_id') and len(attributes.branch_id) )
					budget_branch_id = attributes.branch_id;
				else
					budget_branch_id = ListGetAt(session.ep.user_location,2,"-");
				
				GET_MAX_INV_ROW = cfquery(datasource : "#dsn2#", sqlstring : "SELECT MAX(INVOICE_ROW_ID) ROW_MAX_ID FROM INVOICE_ROW WHERE INVOICE_ID=#form.invoice_id#");
				
				if (isdefined('attributes.other_money_#i#'))
					other_money=evaluate('attributes.other_money_#i#');
				else
					other_money='';
				
				if (isdefined('attributes.other_money_value_#i#') and len(evaluate('attributes.other_money_value_#i#')))
					other_money_value=evaluate('attributes.other_money_value_#i#');
				else
					other_money_value=0;
				if(isdefined("attributes.subscription_id") and isdefined("attributes.subscription_no") and len(attributes.subscription_id) and len(attributes.subscription_no))
					attributes.subscription_id_ = attributes.subscription_id;
				else
					attributes.subscription_id_ = '';
				butce=butceci (
					action_id:form.invoice_id,
					muhasebe_db:dsn2,
					stock_id: evaluate("attributes.stock_id#i#"),
					product_id: evaluate("attributes.product_id#i#"),
					product_tax: ( is_expensing_tax eq 0 ) ? iif((isdefined("attributes.tax#i#") and len(evaluate('attributes.tax#i#'))),evaluate("attributes.tax#i#"),0) : 0,
					product_otv: iif((isdefined("attributes.otv_oran#i#") and len(evaluate('attributes.otv_oran#i#'))),evaluate("attributes.otv_oran#i#"),0),
					product_bsmv: ( is_expensing_bsmv eq 0 ) ? iif((isdefined("attributes.row_bsmv_rate#i#") and len(evaluate('attributes.row_bsmv_rate#i#'))),evaluate("attributes.row_bsmv_rate#i#"),0) : 0,
					product_oiv: iif((isdefined("attributes.row_oiv_rate#i#") and len(evaluate('attributes.row_oiv_rate#i#'))),evaluate("attributes.row_oiv_rate#i#"),0),
					tevkifat_rate: iif((isdefined("attributes.row_tevkifat_rate#i#") and len(evaluate('attributes.row_tevkifat_rate#i#'))),evaluate("attributes.row_tevkifat_rate#i#"),0),
					activity_type: iif((isdefined("attributes.row_activity_id#i#") and len(evaluate('attributes.row_activity_id#i#'))),evaluate("attributes.row_activity_id#i#"),de('')),
					expense_center_id: iif((isdefined("attributes.row_exp_center_id#i#") and len(evaluate('attributes.row_exp_center_id#i#'))),evaluate("attributes.row_exp_center_id#i#"),0),
					expense_item_id: iif((isdefined("attributes.row_exp_item_id#i#") and len(evaluate('attributes.row_exp_item_id#i#'))),evaluate("attributes.row_exp_item_id#i#"),0),
					subscription_id: iif((isdefined("attributes.row_subscription_id#i#") and len(evaluate('attributes.row_subscription_id#i#')) and isdefined("attributes.row_subscription_name#i#") and len(evaluate('attributes.row_subscription_name#i#'))),evaluate("attributes.row_subscription_id#i#"),attributes.subscription_id_),
					invoice_row_id:GET_MAX_INV_ROW.ROW_MAX_ID,
					invoice_number:form.INVOICE_NUMBER,
					detail : '#form.INVOICE_NUMBER# Nolu Fatura',
					is_income_expense: 'true',//Gelir
					process_type:INVOICE_CAT,
					process_cat:attributes.PROCESS_CAT,
					nettotal:evaluate("attributes.row_nettotal#i#"),
					other_money_value:other_money_value,
					action_currency:other_money,
					expense_date:attributes.INVOICE_DATE,
					department_id:attributes.department_id,
					project_id:inv_project_id,
					expense_member_id : sales_emp_id,
					expense_member_type : 'employee',
					branch_id : budget_branch_id,
					discounttotal : DISCOUNT_AMOUNT,
					currency_multiplier : attributes.currency_multiplier
				);

				////İşlem tipinde BSMV'yi giderleştir seçilmişse
				if( is_expensing_bsmv == 1 and isDefined("attributes.row_bsmv_amount#i#") and evaluate("attributes.row_bsmv_amount#i#") > 0 and isDefined("attributes.row_bsmv_currency#i#") and evaluate("attributes.row_bsmv_currency#i#") > 0){

					get_bsmv_row = cfquery(datasource:"#new_dsn2_group#",sqlstring:"SELECT * FROM #new_dsn3_group#.SETUP_BSMV WHERE TAX = #evaluate("attributes.row_bsmv_rate#i#")#");
					butce = butceci(
						action_id:form.invoice_id,
						muhasebe_db:dsn2,
						stock_id: evaluate("attributes.stock_id#i#"),
						product_id: evaluate("attributes.product_id#i#"),
						activity_type: iif((isdefined("attributes.row_activity_id#i#") and len(evaluate('attributes.row_activity_id#i#'))),evaluate("attributes.row_activity_id#i#"),de('')),
						expense_center_id: iif((isdefined("attributes.row_exp_center_id#i#") and len(evaluate('attributes.row_exp_center_id#i#'))),evaluate("attributes.row_exp_center_id#i#"),0),
						expense_item_id: get_bsmv_row.EXPENSE_ITEM_ID,///Doğrudan giderleştirme gider kalemi
						subscription_id: iif((isdefined("attributes.row_subscription_id#i#") and len(evaluate('attributes.row_subscription_id#i#')) and isdefined("attributes.row_subscription_name#i#") and len(evaluate('attributes.row_subscription_name#i#'))),evaluate("attributes.row_subscription_id#i#"),attributes.subscription_id_),
						invoice_row_id:GET_MAX_INV_ROW.ROW_MAX_ID,
						invoice_number:form.INVOICE_NUMBER,
						detail : '#form.INVOICE_NUMBER# Nolu Fatura',
						is_income_expense: 'false',//Gider
						process_type:INVOICE_CAT,
						process_cat:attributes.PROCESS_CAT,
						nettotal: evaluate("attributes.row_bsmv_amount#i#"),
						other_money_value:evaluate("attributes.row_bsmv_currency#i#"),
						action_currency:other_money,
						expense_date:attributes.INVOICE_DATE,
						department_id:attributes.department_id,
						project_id:inv_project_id,
						expense_member_id : sales_emp_id,
						expense_member_type : 'employee',
						branch_id : budget_branch_id,
						discounttotal : DISCOUNT_AMOUNT,
						currency_multiplier : attributes.currency_multiplier
					);

				}

				if( is_expensing_tax == 1 and isDefined("attributes.row_taxtotal#i#") and evaluate("attributes.row_taxtotal#i#") > 0 ){////İşlem tipinde KDV'yi giderleştir seçilmişse

					get_tax_row=cfquery(datasource:"#new_dsn2_group#",sqlstring:"SELECT * FROM SETUP_TAX WHERE TAX = #evaluate("form.tax#i#")#");
					butce = butceci(
						action_id:form.invoice_id,
						muhasebe_db:dsn2,
						stock_id: evaluate("attributes.stock_id#i#"),
						product_id: evaluate("attributes.product_id#i#"),
						activity_type: iif((isdefined("attributes.row_activity_id#i#") and len(evaluate('attributes.row_activity_id#i#'))),evaluate("attributes.row_activity_id#i#"),de('')),
						expense_center_id: iif((isdefined("attributes.row_exp_center_id#i#") and len(evaluate('attributes.row_exp_center_id#i#'))),evaluate("attributes.row_exp_center_id#i#"),0),
						expense_item_id: get_tax_row.EXPENSE_ITEM_ID,///Doğrudan giderleştirme gider kalemi
						subscription_id: iif((isdefined("attributes.row_subscription_id#i#") and len(evaluate('attributes.row_subscription_id#i#')) and isdefined("attributes.row_subscription_name#i#") and len(evaluate('attributes.row_subscription_name#i#'))),evaluate("attributes.row_subscription_id#i#"),attributes.subscription_id_),
						invoice_row_id:GET_MAX_INV_ROW.ROW_MAX_ID,
						invoice_number:form.INVOICE_NUMBER,
						detail : '#form.INVOICE_NUMBER# Nolu Fatura',
						is_income_expense: 'false',//Gider
						process_type:INVOICE_CAT,
						process_cat:attributes.PROCESS_CAT,
						nettotal: evaluate("attributes.row_taxtotal#i#"),
						other_money_value: (evaluate("attributes.row_taxtotal#i#") * attributes.basket_rate1 / attributes.basket_rate2),
						action_currency:other_money,
						expense_date:attributes.INVOICE_DATE,
						department_id:attributes.department_id,
						project_id:inv_project_id,
						expense_member_id : sales_emp_id,
						expense_member_type : 'employee',
						branch_id : budget_branch_id,
						discounttotal : DISCOUNT_AMOUNT,
						currency_multiplier : attributes.currency_multiplier
					);

				}

				if(butce)dagilim=true;//bir satır bile dagilim yapıldığında is_cost alanını 1 set etmek için dagilim true set ediliyor
			}
		</cfscript>
	</cfif>
</cfloop>
<cfscript>
	if(dagilim)	upd_invoice_cost = cfquery(datasource : "#dsn2#",is_select: false, sqlstring : "UPDATE INVOICE SET IS_COST=1 WHERE INVOICE_ID=#form.invoice_id#");
</cfscript> 
<cfif (included_irs eq 1 and isdefined("form.fatura_iptal") and form.fatura_iptal eq 1) or not (isdefined("form.fatura_iptal") and form.fatura_iptal eq 1)>
	<!--- kendi irsaliyesini olusturmus fatura iptal edilirse fatura-irsaliye ilişkisi silinmez --->
	<cfquery name="DEL_INVOICE_SHIPS" datasource="#dsn2#">
		DELETE FROM INVOICE_SHIPS WHERE INVOICE_ID = #form.invoice_id#
	</cfquery>
	<cfif (included_irs eq 1) and len(attributes.ship_ids)>
    <cfset attributes.ship_ids = listsort(attributes.ship_ids,'numeric','asc')>
	<!--- aktif donemin irsaliye kayıtları yazılıyor --->	
			<cfloop list="#attributes.ship_ids#" index="per_k">
				<cfquery name="ADD_INVOICE_SHIPS" datasource="#dsn2#">
					INSERT INTO
						INVOICE_SHIPS
					(
						INVOICE_ID,
						INVOICE_NUMBER,
						SHIP_ID,
						SHIP_NUMBER,
						IS_WITH_SHIP,
						SHIP_PERIOD_ID
					)
					VALUES
					(
						#form.invoice_id#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.invoice_number#">,
						#per_k#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_irs.SHIP_NUMBER[listfind(attributes.ship_ids,per_k,',')]#">,
						0,<!--- irsaliyeli fatura --->
						#session.ep.period_id#
					)
				</cfquery>
			</cfloop>
	</cfif>
	<cfif (included_irs eq 1) and isdefined('pre_period_ships') and len(pre_period_ships)>
		<!--- onceki donemin irsaliye kayıtları yazılıyor --->
		<cfif isDefined("old_period_row_ship_info") and ListLen(old_period_row_ship_info)>
			<cfset pre_period_ships = old_period_row_ship_info>
		</cfif>
		<cfset ship_number_ = "">
		<cfloop list="#pre_period_ships#" index="index_t">
			<cfif isDefined("old_period_row_ship_info") and ListLen(old_period_row_ship_info)><!--- FBS 20110708 gecici cozum, duzenlenebilir --->
				<cfset ship_id_ = ListFirst(index_t,";")>
				<cfset pre_period_id = ListLast(index_t,";")>
				<cfquery name="get_period" datasource="#dsn2#">
					SELECT PERIOD_YEAR,OUR_COMPANY_ID FROM #dsn_alias#.SETUP_PERIOD WHERE PERIOD_ID= #pre_period_id# AND OUR_COMPANY_ID = #session.ep.company_id#
				</cfquery>
				<cfif get_period.recordcount>
					<cfquery name="get_irs2" datasource="#dsn2#">
						SELECT SHIP_NUMBER FROM #dsn#_#get_period.period_year#_#get_period.our_company_id#.SHIP WHERE SHIP_ID = #ship_id_#
					</cfquery>
					<cfset ship_number_ = get_irs2.SHIP_NUMBER>
				</cfif>
			<cfelse>
				<cfset ship_number_ = get_irs2.SHIP_NUMBER[listfind(pre_period_ships,index_t,",")]>
				<cfset ship_id_ = index_t>
			</cfif>
			<cfquery name="ADD_INVOICE_SHIPS" datasource="#dsn2#">
				INSERT INTO
					INVOICE_SHIPS
				(
					INVOICE_ID,
					INVOICE_NUMBER,
					SHIP_ID,
					SHIP_NUMBER,
					IS_WITH_SHIP,
					SHIP_PERIOD_ID
				)
				VALUES
				(
					#form.invoice_id#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.invoice_number#">,
					#ship_id_#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#ship_number_#">,
					0, <!--- irsaliyeli fatura --->
					#pre_period_id#
				)
			</cfquery>
		</cfloop>
	</cfif>
</cfif>
<cfif included_irs eq 1><!--- faturaya cekilen irsaliyeler icin (dikkat faturanın kendi irsaliyesi icin degil) SHIP_ROW_RELATION tablosuna kayıt atılıyor--->
	<cfscript>
		add_ship_row_relation(
			to_related_process_id : form.invoice_id,
			to_related_process_type : INVOICE_CAT,
			old_related_process_type : form.old_process_type,
			is_related_action_iptal : iif((isdefined("form.fatura_iptal") and (form.fatura_iptal eq 1)),1,0),
			is_invoice_ship : 0,
			ship_related_action_type:1,
			process_db :dsn2
			);
	</cfscript>
<cfelse>
	<cfquery name="DEL_SHIP_ROW_RELATION" datasource="#dsn2#">
		DELETE FROM SHIP_ROW_RELATION WHERE TO_INVOICE_ID = #form.invoice_id# AND TO_INVOICE_CAT = #form.old_process_type#
	</cfquery>
</cfif>

<!--- tevkifatlı fatura ise --->
<cfquery name="DEL_INVOICE_TAXES" datasource="#dsn2#">
	DELETE FROM INVOICE_TAXES WHERE INVOICE_ID=#form.invoice_id#
</cfquery>
<cfif isdefined("attributes.tevkifat_box") and isdefined("attributes.tevkifat_oran") and len(attributes.tevkifat_oran)>
	<cfloop from="1" to="#form.basket_tax_count#" index="tax_i">
		<cfquery name="ADD_INVOICE_TAXES" datasource="#dsn2#">
			INSERT INTO
				INVOICE_TAXES
				(
				INVOICE_ID,
				TAX,
				TEVKIFAT_TUTAR,
				BEYAN_TUTAR					
				)
			VALUES
				(
				#form.invoice_id#,
				#evaluate("attributes.basket_tax_#tax_i#")#,
				#evaluate("attributes.tevkifat_tutar_#tax_i#")#,
				#evaluate("attributes.basket_tax_value_#tax_i#")*100#   
				)
		</cfquery>
	</cfloop>
</cfif>
<!---Sistem ödeme planı faturasına iptal bilgisi set edilir,o tarafta gösterimi yapılmadı çokfazla işlem gerekiyordu burdan set edildi--->
<cfquery name="UPD_PAYMENT_ROWS" datasource="#dsn2#">
	UPDATE
		#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
	SET
		IS_INVOICE_IPTAL = NULL,
		UPDATE_DATE = #now()#,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		UPDATE_EMP = #session.ep.userid#
	WHERE
		INVOICE_ID = #form.invoice_id# AND 
		PERIOD_ID = #session.ep.period_id#
</cfquery>
<cf_add_log employee_id="#session.ep.userid#" log_type="0" action_id="#form.invoice_id#" action_name= "#GET_NUMBER.invoice_number# Güncellendi" paper_no= "#GET_NUMBER.invoice_number#" period_id="#session.ep.period_id#" process_type="#form.old_process_type#" data_source="#dsn2#">
