<cfinclude template = "../../objects/query/session_base.cfm">
<cfquery name="ADD_INVOICE_SALE" datasource="#dsn2#" result="MAX_ID">
	INSERT INTO INVOICE
		(
	<cfif isdefined("get_customer_info.SALES_COUNTY") and len(get_customer_info.SALES_COUNTY)>
		ZONE_ID,
	</cfif>
	<cfif isdefined("get_customer_info.RESOURCE_ID") and len(get_customer_info.RESOURCE_ID)>
		RESOURCE_ID,
	</cfif>
	<cfif isdefined("get_customer_info.IMS_CODE_ID") and len(get_customer_info.IMS_CODE_ID)>
		IMS_CODE_ID,
	</cfif>
	<cfif isdefined("get_customer_info.CUSTOMER_VALUE_ID") and len(get_customer_info.CUSTOMER_VALUE_ID)>
		CUSTOMER_VALUE_ID,
	</cfif>
		WRK_ID,
		IS_CASH,
		PURCHASE_SALES,
		INVOICE_NUMBER,
		INVOICE_CAT,
		INVOICE_DATE,
		DUE_DATE,
		COMPANY_ID,
		PARTNER_ID,
		CONSUMER_ID,
		NETTOTAL,
		GROSSTOTAL,
		TAXTOTAL,
		SHIP_ADDRESS_ID,
		OTV_TOTAL,
		SA_DISCOUNT,
		NOTE,
		<cfif isDefined("attributes.EMPO_ID") and len(attributes.EMPO_ID)>
			<cfif attributes.EMPO_ID neq 0>SALE_EMP,<cfelse>SALE_PARTNER,</cfif>
		</cfif>
		DELIVER_EMP, 
		DEPARTMENT_ID,
		DEPARTMENT_LOCATION,
		RECORD_DATE,
		RECORD_EMP,
		SHIP_METHOD,
		UPD_STATUS,
		OTHER_MONEY,
		OTHER_MONEY_VALUE,
		IS_WITH_SHIP,
		TEVKIFAT,
		TEVKIFAT_ORAN,
		TEVKIFAT_ID,
		PROCESS_CAT,
		ASSETP_ID
        <cfif isdefined("session_base") and session_base.our_company_info.project_followup eq 1>
			,PROJECT_ID
		</cfif>
	)
	VALUES
	(
	<cfif isdefined("get_customer_info.SALES_COUNTY") and len(get_customer_info.SALES_COUNTY)>
		#get_customer_info.SALES_COUNTY#,
	</cfif>
	<cfif isdefined("get_customer_info.RESOURCE_ID") and len(get_customer_info.RESOURCE_ID)>
		#get_customer_info.RESOURCE_ID#,
	</cfif>
	<cfif isdefined("get_customer_info.IMS_CODE_ID") and len(get_customer_info.IMS_CODE_ID)>
		#get_customer_info.IMS_CODE_ID#,
	</cfif>
	<cfif isdefined("get_customer_info.CUSTOMER_VALUE_ID") and len(get_customer_info.CUSTOMER_VALUE_ID)>
		#get_customer_info.CUSTOMER_VALUE_ID#,
	</cfif>
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_id#">,
		<cfif isDefined("FORM.CASH")>#form.cash#,<cfelse>NULL,</cfif>
		1,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.INVOICE_NUMBER#">,
		#INVOICE_CAT#,
		#attributes.invoice_date#,
		<cfif isdefined("invoice_due_date") and len(invoice_due_date)>#invoice_due_date#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.member_type") and attributes.member_type eq 1>
			<cfif len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
			<cfif len(attributes.partner_id)>#attributes.partner_id#<cfelse>NULL</cfif>,
			NULL,
		<cfelse>
			NULL,
			NULL,
			<cfif len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
		</cfif>
		#form.basket_net_total#,
		#form.basket_gross_total#,
		#form.basket_tax_total#,
		<cfif len(form.SHIP_ADDRESS_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#form.SHIP_ADDRESS_ID#"><cfelse>NULL</cfif>,
		<cfif len(form.basket_otv_total)>#form.basket_otv_total#<cfelse>NULL</cfif>,
		#form.genel_indirim#,
		<cfif isDefined("NOTE") and len(NOTE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#NOTE#"><cfelse>NULL</cfif>,
		<cfif isDefined("attributes.EMPO_ID") and len(attributes.EMPO_ID)>
			<cfif attributes.EMPO_ID neq 0>#EMPO_ID#<cfelse>#PARTO_ID#</cfif>,
		</cfif>
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#LEFT(TRIM(DELIVER_GET),50)#">,
		#attributes.department_id#,
		#attributes.location_id#,
		#NOW()#,
		#session_base.USERID#,
		<cfif isdefined('attributes.ship_method') and len(attributes.ship_method)>#attributes.ship_method#<cfelse>NULL</cfif>,
		1,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.basket_money#">,
		#((form.BASKET_NET_TOTAL*form.BASKET_RATE1)/form.BASKET_RATE2)#,
	<cfif (not included_irs) and (inventory_product_exists eq 1)>
		1,
	<cfelse>
		0,
	</cfif>
	<cfif isdefined("attributes.tevkifat_box")>1<cfelse>0</cfif>,
	<cfif isdefined("attributes.tevkifat_oran") and len(attributes.tevkifat_oran)>#attributes.tevkifat_oran#<cfelse>NULL</cfif>,
	<cfif isdefined("attributes.tevkifat_id") and len(attributes.tevkifat_id)>#attributes.tevkifat_id#<cfelse>NULL</cfif>,
		#FORM.PROCESS_CAT#,
	<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>#attributes.asset_id#<cfelse>NULL</cfif>
    <cfif isdefined("session_base") and session_base.our_company_info.project_followup eq 1>
		,<cfif isdefined("attributes.project_id") and len(attributes.project_id) and isdefined("attributes.project_head") and len(attributes.project_head)>#attributes.project_id#<cfelse>NULL</cfif>
	</cfif>
	)
</cfquery>
<cfset get_invoice_id.max_id = MAX_ID.IDENTITYCOL>
<cfscript>
	dagilim=false;//dagilim yapılıp yapılmadığını tutacak değer ona göre is_cost set edilecek
</cfscript>
<cfset product_id_list="">
<cfset karma_product_list=""><!--- karma koli urunleri tutuyor --->
<cfloop from="1" to="#attributes.rows_#" index="i">
	<cf_date tarih = 'attributes.deliver_date#i#'>
	<cfif session_base.our_company_info.spect_type and isdefined('attributes.is_production#i#') and evaluate('attributes.is_production#i#') eq 1 and not isdefined('attributes.spect_id#i#') or not len(evaluate('attributes.spect_id#i#'))>
		<cfset dsn_type=dsn2>
		<cfinclude template="../../objects/query/add_basket_spec.cfm">
	</cfif>
	<cfset product_id_list=listappend(product_id_list,evaluate("attributes.product_id#i#"))>
	<cfinclude template="get_dis_amount.cfm">
    
    <cfif isdefined('attributes.reason_code#i#') and len(evaluate('attributes.reason_code#i#'))>
    	<cfset reasonCode = Replace(evaluate('attributes.reason_code#i#'),'--','*')>
    <cfelse>
    	<cfset reasonCode = ''>
    </cfif>
    
	<cfquery name="ADD_SHIP_ROW" datasource="#dsn2#">
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
				MARGIN,
				SHIP_ID,
				SHIP_PERIOD_ID,
				DISCOUNT_COST,
				IS_PROMOTION,
				UNIQUE_RELATION_ID,
				PROM_RELATION_ID,
				PRODUCT_NAME2,
				AMOUNT2,
				UNIT2,
				EXTRA_PRICE,
				EXTRA_PRICE_TOTAL,
				SHELF_NUMBER,
				PRODUCT_MANUFACT_CODE,
				BASKET_EXTRA_INFO_ID,
				SELECT_INFO_EXTRA,
				DETAIL_INFO_EXTRA,
				BASKET_EMPLOYEE_ID,
				OTV_ORAN,
				OTVTOTAL,
				PROM_ID,
				PROM_COMISSION,
				PROM_STOCK_ID,				
				IS_COMMISSION,				
				PRICE_CAT,
				CATALOG_ID,
				PROM_COST,
				WRK_ROW_ID,
				WRK_ROW_RELATION_ID,
				WIDTH_VALUE,
				DEPTH_VALUE,
				HEIGHT_VALUE,
				ROW_PROJECT_ID,
                REASON_CODE,
				REASON_NAME
				<cfif isdefined('attributes.row_exp_center_id#i#') and len(evaluate("attributes.row_exp_center_id#i#")) and isdefined('attributes.row_exp_center_name#i#') and len(evaluate("attributes.row_exp_center_name#i#"))>,ROW_EXP_CENTER_ID</cfif>
				<cfif isdefined('attributes.row_exp_item_id#i#') and len(evaluate("attributes.row_exp_item_id#i#")) and isdefined('attributes.row_exp_item_name#i#') and len(evaluate("attributes.row_exp_item_name#i#"))>,ROW_EXP_ITEM_ID</cfif>
				<cfif isdefined('attributes.row_activity_id#i#') and len(evaluate("attributes.row_activity_id#i#"))>,ACTIVITY_TYPE_ID</cfif>
				<cfif isdefined('attributes.row_acc_code#i#') and len(evaluate("attributes.row_acc_code#i#"))>,ROW_ACC_CODE</cfif>
				<cfif isdefined('attributes.row_subscription_name#i#') and len(evaluate("attributes.row_subscription_name#i#")) and isdefined('attributes.row_subscription_id#i#') and len(evaluate("attributes.row_subscription_id#i#"))>,SUBSCRIPTION_ID</cfif>
				<cfif isdefined('attributes.row_assetp_name#i#') and len(evaluate("attributes.row_assetp_name#i#")) and isdefined('attributes.row_assetp_id#i#') and len(evaluate("attributes.row_assetp_id#i#"))>,ASSETP_ID</cfif>
				<cfif isdefined('attributes.row_bsmv_rate#i#') and len(evaluate("attributes.row_bsmv_rate#i#"))>,BSMV_RATE</cfif>
				<cfif isdefined('attributes.row_bsmv_amount#i#') and len(evaluate("attributes.row_bsmv_amount#i#"))>,BSMV_AMOUNT</cfif>
				<cfif isdefined('attributes.row_bsmv_currency#i#') and len(evaluate("attributes.row_bsmv_currency#i#"))>,BSMV_CURRENCY</cfif>
				<cfif isdefined('attributes.row_oiv_rate#i#') and len(evaluate("attributes.row_oiv_rate#i#"))>,OIV_RATE</cfif>
				<cfif isdefined('attributes.row_oiv_amount#i#') and len(evaluate("attributes.row_oiv_amount#i#"))>,OIV_AMOUNT</cfif>
				<cfif isdefined('attributes.row_tevkifat_rate#i#') and len(evaluate("attributes.row_tevkifat_rate#i#"))>,TEVKIFAT_RATE</cfif>
				<cfif isdefined('attributes.row_tevkifat_amount#i#') and len(evaluate("attributes.row_tevkifat_amount#i#"))>,TEVKIFAT_AMOUNT</cfif>
			)
		VALUES
			(
				1,
				#evaluate("attributes.product_id#i#")#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(wrk_eval('attributes.product_name#i#'),250)#">,
				#MAX_ID.IDENTITYCOL#,
				#evaluate("attributes.stock_id#i#")#,
				#evaluate("attributes.amount#i#")#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.unit#i#')#">,
				#evaluate("attributes.unit_id#i#")#,
				#evaluate("attributes.price#i#")#,
				#DISCOUNT_AMOUNT#,
				#evaluate("attributes.row_lasttotal#i#")#,
				#evaluate("attributes.row_nettotal#i#")#,
				#evaluate("attributes.row_taxtotal#i#")#,
				#evaluate("attributes.tax#i#")#,
				<cfif isdefined("attributes.duedate#i#") and len(Evaluate("attributes.duedate#i#"))>#Evaluate("attributes.duedate#i#")#<cfelse>0</cfif>,
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
			<cfif isdefined('attributes.deliver_date#i#') and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#,<cfelse>NULL,</cfif>
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
			<cfif isdefined('attributes.other_money_#i#')><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.other_money_#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined("attributes.other_money_value_#i#") and len(evaluate("attributes.other_money_value_#i#"))>#evaluate("attributes.other_money_value_#i#")#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.spect_id#i#") and len(evaluate("attributes.spect_id#i#"))>
				#evaluate("attributes.spect_id#i#")#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.spect_name#i#')#">,
			</cfif>
			<cfif isdefined("attributes.lot_no#i#") and len(evaluate("attributes.lot_no#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.lot_no#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined("attributes.price_other#i#") and len(evaluate("attributes.price_other#i#"))>#evaluate("attributes.price_other#i#")#<cfelse>0</cfif>,
			<cfif isdefined("attributes.other_money_gross_total#i#") and len(evaluate("attributes.other_money_gross_total#i#"))>#evaluate("attributes.other_money_gross_total#i#")#<cfelse>0</cfif>,
			<!--- <cfif isdefined('attributes.cost_id#i#') and len(evaluate('attributes.cost_id#i#'))>#evaluate('attributes.cost_id#i#')#<cfelse>NULL</cfif>, --->
			<cfif isdefined('attributes.net_maliyet#i#') and len(evaluate('attributes.net_maliyet#i#'))>#evaluate('attributes.net_maliyet#i#')#<cfelse>0</cfif>,
			<cfif isdefined('attributes.marj#i#') and len(evaluate('attributes.marj#i#'))>#evaluate('attributes.marj#i#')#<cfelse>NULL</cfif>,
			#listfirst(ship_id,';')#,
			<cfif listlen(ship_id,';') eq 2>#listlast(ship_id,';')#<cfelse>#session_base.period_id#</cfif>,
			<cfif isdefined('attributes.iskonto_tutar#i#') and len(evaluate('attributes.iskonto_tutar#i#'))>#evaluate('attributes.iskonto_tutar#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.is_promotion#i#') and len(evaluate('attributes.is_promotion#i#'))>#evaluate('attributes.is_promotion#i#')#<cfelse>0</cfif>,
			<cfif isdefined('attributes.row_unique_relation_id#i#') and len(evaluate('attributes.row_unique_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.row_unique_relation_id#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.prom_relation_id#i#') and len(evaluate('attributes.prom_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.prom_relation_id#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.product_name_other#i#') and len(evaluate('attributes.product_name_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.product_name_other#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.unit_other#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.ek_tutar#i#') and len(evaluate('attributes.ek_tutar#i#'))>#evaluate('attributes.ek_tutar#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.ek_tutar_total#i#') and len(evaluate('attributes.ek_tutar_total#i#'))>#evaluate('attributes.ek_tutar_total#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.manufact_code#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.basket_extra_info#i#') and len(evaluate('attributes.basket_extra_info#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.basket_extra_info#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.select_info_extra#i#') and len(evaluate('attributes.select_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.select_info_extra#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.detail_info_extra#i#') and len(evaluate('attributes.detail_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.detail_info_extra#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.basket_employee_id#i#') and len(evaluate('attributes.basket_employee_id#i#')) and isdefined('attributes.basket_employee#i#') and len(evaluate('attributes.basket_employee#i#'))>#evaluate('attributes.basket_employee_id#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.otv_oran#i#') and len(evaluate('attributes.otv_oran#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.otv_oran#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_otvtotal#i#') and len(evaluate('attributes.row_otvtotal#i#'))>#evaluate('attributes.row_otvtotal#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_promotion_id#i#') and len(evaluate('attributes.row_promotion_id#i#'))>#evaluate('attributes.row_promotion_id#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.promosyon_yuzde#i#') and len(evaluate('attributes.promosyon_yuzde#i#'))>#evaluate('attributes.promosyon_yuzde#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.prom_stock_id#i#') and len(evaluate('attributes.prom_stock_id#i#'))>#evaluate('attributes.prom_stock_id#i#')#<cfelse>NULL</cfif>,
			0,
			<cfif isdefined('attributes.price_cat#i#') and len(evaluate('attributes.price_cat#i#'))>#evaluate('attributes.price_cat#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_catalog_id#i#') and len(evaluate('attributes.row_catalog_id#i#'))>#evaluate('attributes.row_catalog_id#i#')#<cfelse>NULL</cfif>,
			0,
			<cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.wrk_row_id#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.wrk_row_relation_id#i#') and len(evaluate('attributes.wrk_row_relation_id#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.wrk_row_relation_id#i#')#"><cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_width#i#') and len(evaluate('attributes.row_width#i#'))>#evaluate('attributes.row_width#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_depth#i#') and len(evaluate('attributes.row_depth#i#'))>#evaluate('attributes.row_depth#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_height#i#') and len(evaluate('attributes.row_height#i#'))>#evaluate('attributes.row_height#i#')#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.row_project_id#i#') and len(evaluate('attributes.row_project_id#i#')) and isdefined('attributes.row_project_name#i#') and len(evaluate('attributes.row_project_name#i#'))>#evaluate('attributes.row_project_id#i#')#<cfelse>NULL</cfif>,
            <cfif len(reasonCode) and reasonCode contains '*'>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(reasonCode,'*')#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#listLast(reasonCode,'*')#">
			<cfelse>
				NULL,
				NULL
			</cfif>
			<cfif isdefined('attributes.row_exp_center_id#i#') and len(evaluate("attributes.row_exp_center_id#i#")) and isdefined('attributes.row_exp_center_name#i#') and len(evaluate("attributes.row_exp_center_name#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_exp_center_id#i#')#"></cfif>
			<cfif isdefined('attributes.row_exp_item_id#i#') and len(evaluate("attributes.row_exp_item_id#i#")) and isdefined('attributes.row_exp_item_name#i#') and len(evaluate("attributes.row_exp_item_name#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_exp_item_id#i#')#"></cfif>
			<cfif isdefined('attributes.row_activity_id#i#') and len(evaluate("attributes.row_activity_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_activity_id#i#')#"></cfif>
			<cfif isdefined('attributes.row_acc_code#i#') and len(evaluate("attributes.row_acc_code#i#"))>,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate('attributes.row_acc_code#i#')#"></cfif>	
			<cfif isdefined('attributes.row_subscription_name#i#') and len(evaluate("attributes.row_subscription_name#i#")) and isdefined('attributes.row_subscription_id#i#') and len(evaluate("attributes.row_subscription_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_subscription_id#i#')#"></cfif>
			<cfif isdefined('attributes.row_assetp_name#i#') and len(evaluate("attributes.row_assetp_name#i#")) and isdefined('attributes.row_assetp_id#i#') and len(evaluate("attributes.row_assetp_id#i#"))>,<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.row_assetp_id#i#')#"></cfif>
			<cfif isdefined('attributes.row_bsmv_rate#i#') and len(evaluate("attributes.row_bsmv_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_rate#i#')#"></cfif>
			<cfif isdefined('attributes.row_bsmv_amount#i#') and len(evaluate("attributes.row_bsmv_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_amount#i#')#"></cfif>
			<cfif isdefined('attributes.row_bsmv_currency#i#') and len(evaluate("attributes.row_bsmv_currency#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_bsmv_currency#i#')#"></cfif>
			<cfif isdefined('attributes.row_oiv_rate#i#') and len(evaluate("attributes.row_oiv_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_oiv_rate#i#')#"></cfif>
			<cfif isdefined('attributes.row_oiv_amount#i#') and len(evaluate("attributes.row_oiv_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_oiv_amount#i#')#"></cfif>
			<cfif isdefined('attributes.row_tevkifat_rate#i#') and len(evaluate("attributes.row_tevkifat_rate#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_tevkifat_rate#i#')#"></cfif>
			<cfif isdefined('attributes.row_tevkifat_amount#i#') and len(evaluate("attributes.row_tevkifat_amount#i#"))>,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.row_tevkifat_amount#i#')#"></cfif>
			)
	</cfquery>
	<cfset karma_product_list=listappend(karma_product_list,evaluate("attributes.product_id#i#"))><!--- karma koli icin eklendi, genel ürün listesi , muhasebe bölümünde de kullanılıyor --->
	
	<cfquery name="GET_MAX_INV_ROW" datasource="#new_dsn2_group#">
		SELECT MAX(INVOICE_ROW_ID) ROW_MAX_ID FROM INVOICE_ROW WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">
	</cfquery>
	
	<cfif isdefined('attributes.basket_employee_id#i#') and len(evaluate('attributes.basket_employee_id#i#')) and isdefined('attributes.basket_employee#i#') and len(evaluate('attributes.basket_employee#i#'))>
		<cfset sales_emp_id = evaluate('attributes.basket_employee_id#i#')>
	<cfelseif isDefined("attributes.EMPO_ID") and len(attributes.EMPO_ID)>
		<cfset sales_emp_id = attributes.EMPO_ID>
	<cfelseif isdefined("session_base")>
		<cfset sales_emp_id = session_base.userid>
	<cfelse>
		<cfset sales_emp_id = 0>
	</cfif>
	<cfscript>
	if(isdefined("session_base") and is_project_based_budget and session_base.our_company_info.project_followup eq 1)
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
	{ //butce
		if(isdefined('attributes.branch_id') and len(attributes.branch_id) )
			budget_branch_id = attributes.branch_id;
		else if(isdefined("session_base"))
			budget_branch_id = ListGetAt(session_base.user_location,2,"-");
		else
			budget_branch_id = '';
		if (isdefined('attributes.other_money_#i#'))
			other_money=evaluate('attributes.other_money_#i#');
		else
			other_money='';
		if (isdefined('attributes.other_money_value_#i#') and len(evaluate('attributes.other_money_value_#i#')))
			other_money_value=evaluate('attributes.other_money_value_#i#');
		else
			other_money_value=0;
		butce=butceci(
			action_id:MAX_ID.IDENTITYCOL,
			muhasebe_db:new_dsn2_group,
			stock_id: evaluate("attributes.stock_id#i#"),
			product_id:evaluate("attributes.product_id#i#"),
			product_tax:evaluate("attributes.tax#i#"),
			product_otv: iif((isdefined("attributes.otv_oran#i#") and len(evaluate('attributes.otv_oran#i#'))),evaluate("attributes.otv_oran#i#"),0),
			tevkifat_rate: iif((isdefined("attributes.row_tevkifat_rate#i#") and len(evaluate('attributes.row_tevkifat_rate#i#'))),evaluate("attributes.row_tevkifat_rate#i#"),0),
			activity_type: iif((isdefined("attributes.row_activity_id#i#") and len(evaluate('attributes.row_activity_id#i#'))),evaluate("attributes.row_activity_id#i#"),de('')),
			expense_center_id: iif((isdefined("attributes.row_exp_center_id#i#") and len(evaluate('attributes.row_exp_center_id#i#'))),evaluate("attributes.row_exp_center_id#i#"),0),
			expense_item_id: iif((isdefined("attributes.row_exp_item_id#i#") and len(evaluate('attributes.row_exp_item_id#i#'))),evaluate("attributes.row_exp_item_id#i#"),0),	
			invoice_row_id:GET_MAX_INV_ROW.ROW_MAX_ID,
			paper_no:form.INVOICE_NUMBER,
			detail : "#form.INVOICE_NUMBER# #getLang('','Nolu Fatura',64680)#",
			is_income_expense: 'true',
			process_type:INVOICE_CAT,
			process_cat:attributes.PROCESS_CAT,
			nettotal:evaluate("attributes.row_nettotal#i#"),
			other_money_value:other_money_value,
			action_currency:other_money,
			action_currency_2:session_base.money2,
			expense_date:attributes.INVOICE_DATE,
			department_id:attributes.department_id,
			project_id:inv_project_id,
			expense_member_id : sales_emp_id,
			expense_member_type : 'employee',
			branch_id : budget_branch_id,
			discounttotal : DISCOUNT_AMOUNT,
			currency_multiplier : attributes.currency_multiplier
			);
		if(butce)dagilim=true;//bir satır bile dagilim yapıldığında is_cost alanını 1 set etmek için dagilim true set ediliyor
	}
	</cfscript>
</cfloop>
<cfscript>
	//döngü dışına alındı her satırda is_cost update etmemesi için
	if(dagilim) upd_invoice_cost = cfquery(datasource : "#new_dsn2_group#", is_select: false,sqlstring : "UPDATE INVOICE SET IS_COST=1 WHERE INVOICE_ID=#MAX_ID.IDENTITYCOL#");
</cfscript>

<!--- tevkifatlı fatura ise --->
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
				#MAX_ID.IDENTITYCOL#,
				#evaluate("attributes.basket_tax_#tax_i#")#,
				#evaluate("attributes.tevkifat_tutar_#tax_i#")#,
				#evaluate("attributes.basket_tax_value_#tax_i#")*100#   
				)
		</cfquery>
	</cfloop>
</cfif>

