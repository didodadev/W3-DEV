<cfset attributes.deliver_date_frm = createdatetime(year(attributes.invoice_date),month(attributes.invoice_date),day(attributes.invoice_date),attributes.invoice_date_h,attributes.invoice_date_m,0)>
<cfquery name="ADD_INVOICE_SALE" datasource="#new_dsn2_group#" result="MAX_ID">
	INSERT INTO
		INVOICE
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
		KASA_ID,
		PURCHASE_SALES,
		<cfif isdefined("session.ep") and session.ep.our_company_info.project_followup eq 1>
			PROJECT_ID,
		</cfif>
		SERIAL_NUMBER,
		SERIAL_NO,
		INVOICE_NUMBER,
		INVOICE_CAT,
		INVOICE_DATE,
		SHIP_DATE,
		DUE_DATE,
		COMPANY_ID,
		PARTNER_ID,
		CONSUMER_ID,
		EMPLOYEE_ID,
		NETTOTAL,
		GROSSTOTAL,
		TAXTOTAL,
		OTV_TOTAL,
		SA_DISCOUNT,
		NOTE,
		SHIP_ADDRESS_ID,
	<cfif isDefined("attributes.EMPO_ID") and len(attributes.EMPO_ID)>
		<cfif attributes.EMPO_ID neq ''>SALE_EMP,<cfelse>SALE_PARTNER,</cfif>
	</cfif>
		DELIVER_EMP,
		DEPARTMENT_ID,
		DEPARTMENT_LOCATION,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_CONS,
		SHIP_METHOD,
		PAY_METHOD,
		UPD_STATUS,
		OTHER_MONEY,
		OTHER_MONEY_VALUE,
		IS_WITH_SHIP,
		PROCESS_CAT,
		COMMETHOD_ID,
		REF_NO,
		GENERAL_PROM_ID,
		GENERAL_PROM_LIMIT,
		GENERAL_PROM_AMOUNT,
		GENERAL_PROM_DISCOUNT,
		FREE_PROM_ID,
		FREE_PROM_LIMIT,
		FREE_PROM_AMOUNT,
		FREE_PROM_COST,
		FREE_PROM_STOCK_ID,
		FREE_STOCK_PRICE,
		FREE_STOCK_MONEY,
		TEVKIFAT,
		TEVKIFAT_ORAN,
		TEVKIFAT_ID,
		CARD_PAYMETHOD_ID,
		CARD_PAYMETHOD_RATE,
		IS_TAX_OF_OTV,
		SHIP_ADDRESS,
		SALES_PARTNER_ID,
		SALES_CONSUMER_ID,
		CONSUMER_REFERENCE_CODE,
		PARTNER_REFERENCE_CODE,
		SALES_TEAM_ID,
		ASSETP_ID,
		SUBSCRIPTION_ID,
		ACC_DEPARTMENT_ID,
		CONTRACT_ID,
		PROGRESS_ID,
		FROM_PROGRESS,
		STOPAJ,
		STOPAJ_ORAN,
		STOPAJ_RATE_ID,
		ACC_TYPE_ID,
		PROFILE_ID,
        SERVICE_ID,
		REALIZATION_DATE,
		PROCESS_TIME,
        BSMV_TOTAL,
		OIV_TOTAL,
		VAT_EXCEPTION_ID,
		PROCESS_STAGE,
		BANK_ID,
		IS_IPTAL,
		PAYMENT_COMPANY_ID
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
		<cfif isDefined("FORM.CASH") and len(KASA)>1,#KASA#,<cfelse>0,NULL,</cfif>
		1,
		<cfif isdefined("session.ep") and session.ep.our_company_info.project_followup eq 1>
			<cfif isdefined("attributes.project_id") and len(attributes.project_id) and isdefined("attributes.project_head") and len(attributes.project_head)>#attributes.project_id#<cfelse>NULL</cfif>,
		</cfif>
		<cfif isdefined('form.serial_number') and len(form.serial_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.SERIAL_NUMBER#"><cfelse>NULL</cfif>,
		<cfif isdefined('form.serial_no') and len(form.serial_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.SERIAL_NO#"><cfelse>NULL</cfif>,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.INVOICE_NUMBER#">,
		#INVOICE_CAT#,
		#attributes.invoice_date#,
		<cfif isdefined("attributes.ship_date") and len(attributes.ship_date) and isdate(attributes.ship_date)>#attributes.ship_date#<cfelse>NULL</cfif>,
		<cfif len(invoice_due_date) and isdate(invoice_due_date)>#invoice_due_date#<cfelse>NULL</cfif>,
	<cfif isDefined("attributes.company_id") and len(attributes.company_id) and isDefined("attributes.comp_name") and len(attributes.comp_name)>
		#attributes.company_id#,
		<cfif isDefined("attributes.partner_id") and len(attributes.partner_id)>#attributes.partner_id#<cfelse>NULL</cfif>,
		NULL,
		NULL,
	<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
		NULL,
		NULL,
		#attributes.consumer_id#,
		NULL,
	<cfelse>
		NULL,
		NULL,
		NULL,
		#attributes.employee_id#,
	</cfif>
		#form.basket_net_total#,
		#form.basket_gross_total#,
		#form.basket_tax_total#,
		<cfif len(form.basket_otv_total)>#form.basket_otv_total#<cfelse>NULL</cfif>,
		<cfif len(form.genel_indirim)>#form.genel_indirim#<cfelse>0</cfif>,
	<cfif isDefined("note") and len(note)><cfqueryparam cfsqltype="cf_sql_varchar" value="#note#"><cfelse>NULL</cfif>,
	<cfif isDefined("attributes.ship_address_id") and len(attributes.ship_address_id)>#attributes.ship_address_id#<cfelse>NULL</cfif>,
	<cfif isDefined("attributes.EMPO_ID") and len(attributes.EMPO_ID)>
		<cfif attributes.EMPO_ID neq ''>#attributes.EMPO_ID#<cfelse>#attributes.PARTO_ID#</cfif>,
	</cfif>
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#LEFT(TRIM(DELIVER_GET),50)#">,
		#attributes.department_id#,
		#attributes.location_id#,
		#NOW()#,
		<cfif isdefined("session.ep.userid")>#SESSION.EP.USERID#<cfelse>NULL</cfif>,
		<cfif isdefined("session.ww.userid")>#SESSION.WW.USERID#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.ship_method') and len(attributes.ship_method)>#attributes.ship_method#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.paymethod_id") and len(attributes.paymethod_id)>#attributes.paymethod_id#<cfelse>NULL</cfif>,<!---  --->
		1,<!--- UPD_STATUS ?? --->
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.basket_money#">,<!--- döviz --->
		#((attributes.BASKET_NET_TOTAL*attributes.BASKET_RATE1)/attributes.BASKET_RATE2)#,<!--- döviz fiyat --->
	<cfif (not included_irs) and (inventory_product_exists eq 1)>
		1,
	<cfelse>
		0,
	</cfif>
		#FORM.PROCESS_CAT#,
		<cfif isdefined("attributes.commethod_id") and len(attributes.commethod_id)>#attributes.commethod_id#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.ref_no") and len(attributes.ref_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ref_no#"><cfelse>NULL</cfif>,
		<cfif isdefined("attributes.general_prom_id") and len(attributes.general_prom_id)>#attributes.general_prom_id#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.general_prom_limit") and len(attributes.general_prom_limit)>#attributes.general_prom_limit#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.general_prom_amount") and len(attributes.general_prom_amount)>#attributes.general_prom_amount#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.general_prom_discount") and len(attributes.general_prom_discount)>#attributes.general_prom_discount#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.free_prom_id") and len(attributes.free_prom_id)>#attributes.free_prom_id#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.free_prom_limit") and len(attributes.free_prom_limit)>#attributes.free_prom_limit#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.free_prom_amount") and len(attributes.free_prom_amount)>#attributes.free_prom_amount#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.free_prom_cost") and len(attributes.free_prom_cost)>#attributes.free_prom_cost#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.free_prom_stock_id") and len(attributes.free_prom_stock_id)>#attributes.free_prom_stock_id#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.free_stock_price") and len(attributes.free_stock_price)>#attributes.free_stock_price#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.free_stock_money") and len(attributes.free_stock_money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.free_stock_money#"><cfelse>NULL</cfif>,
		<cfif isdefined("attributes.tevkifat_box")>1<cfelse>0</cfif>,
		<cfif isdefined("attributes.tevkifat_oran") and len(attributes.tevkifat_oran)>#attributes.tevkifat_oran#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.tevkifat_id") and len(attributes.tevkifat_id)>#attributes.tevkifat_id#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.card_paymethod_id") and len(attributes.card_paymethod_id)>
			#attributes.card_paymethod_id#,
			<cfif isdefined("attributes.commission_rate") and len(attributes.commission_rate)>
				#attributes.commission_rate#,
			<cfelse>
				NULL,
			</cfif>
		<cfelse>
			NULL,
			NULL,
		</cfif>
		<cfif isdefined('attributes.basket_otv_from_tax_price') and len(attributes.basket_otv_from_tax_price)>#attributes.basket_otv_from_tax_price#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.adres") and len(attributes.adres)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.adres#"><cfelse>NULL</cfif>,
		<cfif isdefined("attributes.sales_member") and len(attributes.sales_member) and isdefined("attributes.sales_member_type") and(attributes.sales_member_type eq "PARTNER")>
			#attributes.sales_member_id#,
		<cfelse>
			NULL,
		</cfif>
		<cfif isdefined("attributes.sales_member") and len(attributes.sales_member) and isdefined("attributes.sales_member_type") and (attributes.sales_member_type eq "CONSUMER")>
			#attributes.sales_member_id#,
		<cfelse>
			NULL,
		</cfif>
		<cfif isdefined('attributes.consumer_reference_code') and len(attributes.consumer_reference_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.consumer_reference_code#"><cfelse>NULL</cfif>,
		<cfif isdefined('attributes.partner_reference_code') and len(attributes.partner_reference_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.partner_reference_code#"><cfelse>NULL</cfif>,
		<cfif isdefined("attributes.EMPO_ID") and len(attributes.EMPO_ID) and len(emp_team_id)>#emp_team_id#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>#attributes.asset_id#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_no)>#attributes.subscription_id#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.acc_department_id") and len(attributes.acc_department_id)>#attributes.acc_department_id#<cfelse>NULL</cfif>,
		<cfif (isdefined('attributes.contract_no') and len(attributes.contract_no)) and isdefined('attributes.contract_id') and len(attributes.contract_id)>#attributes.contract_id#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.progress_id') and len(attributes.progress_id)>
			#attributes.progress_id#,
			1
		<cfelse>
			NULL,
			0
		</cfif>,
		<cfif isdefined("form.stopaj") and len(form.stopaj)>#form.stopaj#<cfelse>NULL</cfif>,
		<cfif isdefined("form.stopaj_yuzde") and len(form.stopaj_yuzde)>#form.stopaj_yuzde#<cfelse>NULL</cfif>,
		<cfif isdefined("form.stopaj_rate_id") and len(form.stopaj_rate_id)>#form.stopaj_rate_id#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>#attributes.acc_type_id#<cfelse>NULL</cfif>,
		<cfif isdefined("inv_profile_id") and len(inv_profile_id)>'#inv_profile_id#'<cfelse>NULL</cfif>,
        <cfif isdefined("attributes.service_id") and len(attributes.service_id)>#attributes.service_id#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.realization_date") and len(attributes.realization_date) and isdate(attributes.realization_date)>#attributes.realization_date#<cfelse>NULL</cfif>,
		#attributes.deliver_date_frm#,
        <cfif isdefined("attributes.total_bsmv") and len(attributes.total_bsmv)>#attributes.total_bsmv#<cfelse>0</cfif>,
		<cfif isdefined("attributes.total_oiv") and len(attributes.total_oiv)>#attributes.total_oiv#<cfelse>0</cfif>,
		<cfif isdefined("form.exc_id") and len(form.exc_id)>#form.exc_id#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.process_stage') and len(attributes.process_stage)>#attributes.process_stage#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.account_id") and len(attributes.account_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.account_id#"><cfelse>NULL</cfif>,
		0,
		<cfif isDefined("attributes.payment_company_id") and len(attributes.payment_company_id) and isDefined("attributes.payment_comp_name") and len(attributes.payment_comp_name)>#attributes.payment_company_id#<cfelse>NULL</cfif>
	)
</cfquery>
<cfscript>
	attributes.invoice_id = MAX_ID.IDENTITYCOL;
	get_invoice_id.max_id = MAX_ID.IDENTITYCOL;
	product_id_list='';// satıs iade fat. karmakoli-üretim-spect stok hareketi cözumleri icin kullanılıyor
	stock_id_list='';
	dagilim=false;
</cfscript>
<cfif IsDefined("attributes.service_id") and len(attributes.service_id)>
	<cfquery name="upd_g_service" datasource="#new_dsn2_group#">
    	UPDATE #dsn3_alias#.SERVICE SET INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
    </cfquery>
</cfif>
<cfloop from="1" to="#attributes.rows_#" index="i">
	<cf_date tarih = 'attributes.deliver_date#i#'>
	<cfif not isdefined("is_from_function") and isdefined("session.ep") and session.ep.our_company_info.spect_type and isdefined('attributes.is_production#i#') and evaluate('attributes.is_production#i#') eq 1 and (not isdefined('attributes.spect_id#i#') or not len(evaluate('attributes.spect_id#i#')))>
		<cfset dsn_type=new_dsn2_group>
		<cfinclude template="../../objects/query/add_basket_spec.cfm">
	</cfif>
	<cfinclude template="get_dis_amount.cfm">
    
    <cfif isdefined('attributes.reason_code#i#') and len(evaluate('attributes.reason_code#i#'))>
    	<cfset reasonCode = Replace(evaluate('attributes.reason_code#i#'),'--','*')>
    <cfelse>
    	<cfset reasonCode = ''>
    </cfif>

	<cfif IsDefined("attributes.order_id_listesi") and len( attributes.order_id_listesi ) and isdefined('attributes.wrk_row_relation_id#i#') and len(evaluate('attributes.wrk_row_relation_id#i#'))>
        <cfquery name = "get_order" datasource = "#new_dsn2_group#">
            SELECT ORDER_ID FROM #dsn3_alias#.ORDER_ROW WHERE WRK_ROW_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.wrk_row_relation_id#i#')#">
        </cfquery>
        <cfif get_order.recordcount>
            <cfset attributes.order_id = get_order.ORDER_ID />
        </cfif>
    </cfif>
        
	<cfif IsDefined("attributes.order_id_listesi") and len( attributes.order_id_listesi ) and isdefined('attributes.wrk_row_relation_id#i#') and len(evaluate('attributes.wrk_row_relation_id#i#'))>
        <cfquery name = "get_order" datasource = "#new_dsn2_group#">
            SELECT ORDER_ID FROM #dsn3_alias#.ORDER_ROW WHERE WRK_ROW_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.wrk_row_relation_id#i#')#">
        </cfquery>
        <cfif get_order.recordcount>
            <cfset attributes.order_id = get_order.ORDER_ID />
        </cfif>
    </cfif>

	<cfquery name="ADD_INVOICE_ROW" datasource="#new_dsn2_group#">
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
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(evaluate('attributes.product_name#i#'),250)#">,
			#MAX_ID.IDENTITYCOL#,
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
		<cfif isdefined('attributes.deliver_date#i#') and isdate(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,
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
		<cfif isdefined('attributes.other_money_#i#')><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.other_money_#i#')#"><cfelse>NULL</cfif>,
		<cfif isdefined("attributes.other_money_value_#i#") and len(evaluate("attributes.other_money_value_#i#"))>#evaluate("attributes.other_money_value_#i#")#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.spect_id#i#") and len(evaluate("attributes.spect_id#i#"))>
			#evaluate("attributes.spect_id#i#")#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.spect_name#i#')#">,
		</cfif>
		<cfif isdefined("attributes.lot_no#i#") and len(evaluate("attributes.lot_no#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.lot_no#i#')#"><cfelse>NULL</cfif>,
		<cfif isdefined("attributes.price_other#i#") and len(evaluate("attributes.price_other#i#"))>#evaluate("attributes.price_other#i#")#<cfelse>0</cfif>,
		<cfif isdefined("attributes.other_money_gross_total#i#") and len(evaluate("attributes.other_money_gross_total#i#"))>#evaluate("attributes.other_money_gross_total#i#")#<cfelse>0</cfif>,
		<!--- <cfif isdefined('attributes.cost_id#i#') and len(evaluate('attributes.cost_id#i#'))>#evaluate('attributes.cost_id#i#')#<cfelse>NULL</cfif>, --->
		<cfif isdefined('attributes.net_maliyet#i#') and len(evaluate('attributes.net_maliyet#i#'))>#evaluate('attributes.net_maliyet#i#')#<cfelse>0</cfif>,
		<cfif isdefined('attributes.extra_cost#i#') and len(evaluate('attributes.extra_cost#i#'))>#evaluate('attributes.extra_cost#i#')#<cfelse>0</cfif>,
		<cfif isdefined('attributes.marj#i#') and len(evaluate('attributes.marj#i#'))>#evaluate('attributes.marj#i#')#<cfelse>NULL</cfif>,
			#listfirst(ship_id,';')#,
		<cfif listlen(ship_id,';') eq 2>#listlast(ship_id,';')#<cfelse>#session_base.period_id#</cfif>,
		<cfif isdefined('attributes.promosyon_yuzde#i#') and len(evaluate('attributes.promosyon_yuzde#i#'))>#evaluate('attributes.promosyon_yuzde#i#')#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.promosyon_maliyet#i#') and len(evaluate('attributes.promosyon_maliyet#i#'))>#evaluate('attributes.promosyon_maliyet#i#')#<cfelse>0</cfif>,
		<cfif isdefined('attributes.iskonto_tutar#i#') and len(evaluate('attributes.iskonto_tutar#i#'))>#evaluate('attributes.iskonto_tutar#i#')#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.row_promotion_id#i#') and len(evaluate('attributes.row_promotion_id#i#'))>#evaluate('attributes.row_promotion_id#i#')#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.is_promotion#i#') and len(evaluate('attributes.is_promotion#i#'))>#evaluate('attributes.is_promotion#i#')#<cfelse>0</cfif>,
		<cfif isdefined('attributes.prom_stock_id#i#') and len(evaluate('attributes.prom_stock_id#i#'))>#evaluate('attributes.prom_stock_id#i#')#<cfelse>NULL</cfif>,
		<cfif isdefined('attributes.is_commission#i#') and len(evaluate('attributes.is_commission#i#'))>#evaluate('attributes.is_commission#i#')#<cfelse>0</cfif>,
		<cfif isdefined("attributes.row_ship_id#i#") and len(evaluate("attributes.row_ship_id#i#")) and listfirst(evaluate("attributes.row_ship_id#i#"),';') neq 0>#listfirst(evaluate("attributes.row_ship_id#i#"),';')#<cfelseif isDefined("attributes.order_id") and len(attributes.order_id)>#attributes.order_id#<cfelse>NULL</cfif>,
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
		<cfif isdefined('attributes.otv_oran#i#') and len(evaluate('attributes.otv_oran#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.otv_oran#i#')#"><cfelse>NULL</cfif>,
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
	<cfquery name="get_sale_emp" datasource="#new_dsn2_group#">
		SELECT SALE_EMP FROM INVOICE WHERE INVOICE_ID = #MAX_ID.IDENTITYCOL#
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
	<cfquery name="GET_MAX_INV_ROW" datasource="#new_dsn2_group#">
		SELECT MAX(INVOICE_ROW_ID) ROW_MAX_ID FROM INVOICE_ROW WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">
	</cfquery>
    <!--- Eğerki  Faturamızın satırı  başka bir fatura ile ilişkili ise..--->
	<cfif not isdefined('xml_import')><!--- XML'de tanımlı olmadığı için bu kontrolü ekledik! --->
		<cfif isdefined('attributes.related_action_id#i#') and Evaluate('attributes.related_action_id#i#') gt 0 and isdefined('attributes.wrk_row_relation_id#i#') and Evaluate('attributes.wrk_row_relation_id#i#') gt 0>
            <cfscript>
                add_relation_rows(
                    action_type:'add',
                    action_dsn : '#new_dsn2_group#',
                    to_table:'INVOICE',
                    from_table:'#evaluate("attributes.RELATED_ACTION_TABLE#i#")#',
                    to_wrk_row_id : Evaluate("attributes.wrk_row_id#i#"),
                    from_wrk_row_id :Evaluate("attributes.wrk_row_relation_id#i#"),
                    amount : Evaluate("attributes.amount#i#"),
                    to_action_id : MAX_ID.IDENTITYCOL,
                    from_action_id :Evaluate("attributes.related_action_id#i#")
                    );
            </cfscript>
        </cfif>	
    </cfif>
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

	if(is_budget){ //butce
			if(isdefined('attributes.branch_id') and len(attributes.branch_id) )
				budget_branch_id = attributes.branch_id;
			else if(isdefined("session.ep"))
				budget_branch_id = ListGetAt(session.ep.user_location,2,"-");
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
			if(isdefined("attributes.subscription_id") and isdefined("attributes.subscription_no") and len(attributes.subscription_id) and len(attributes.subscription_no))
				attributes.subscription_id_ = attributes.subscription_id;
			else
				attributes.subscription_id_ = '';
			if(isdefined("attributes.row_activity_id#i#") and len(evaluate('attributes.row_activity_id#i#')))
				attributes.row_activity_id = evaluate('attributes.row_activity_id#i#');
			else
				attributes.row_activity_id = '';
			butce=butceci(
				action_id:MAX_ID.IDENTITYCOL,
				muhasebe_db:new_dsn2_group,
				muhasebe_db_dsn3:new_dsn3_group,
				period_id:new_period_id,
				stock_id: evaluate("attributes.stock_id#i#"),
				product_id:evaluate("attributes.product_id#i#"),
				product_tax:( is_expensing_tax eq 0 ) ? iif((isdefined("attributes.tax#i#") and len(evaluate('attributes.tax#i#'))),evaluate("attributes.tax#i#"),0) : 0,
				product_otv: iif((isdefined("attributes.otv_oran#i#") and len(evaluate('attributes.otv_oran#i#'))),evaluate("attributes.otv_oran#i#"),0),
				product_bsmv: ( is_expensing_bsmv eq 0 ) ? iif((isdefined("attributes.row_bsmv_rate#i#") and len(evaluate('attributes.row_bsmv_rate#i#'))),evaluate("attributes.row_bsmv_rate#i#"),0) : 0,
				product_oiv: iif((isdefined("attributes.row_oiv_rate#i#") and len(evaluate('attributes.row_oiv_rate#i#'))),evaluate("attributes.row_oiv_rate#i#"),0),
				tevkifat_rate: iif((isdefined("attributes.row_tevkifat_rate#i#") and len(evaluate('attributes.row_tevkifat_rate#i#'))),evaluate("attributes.row_tevkifat_rate#i#"),0),
				activity_type: attributes.row_activity_id,
				expense_center_id: iif((isdefined("attributes.row_exp_center_id#i#") and len(evaluate('attributes.row_exp_center_id#i#'))),evaluate("attributes.row_exp_center_id#i#"),0),
				expense_item_id: iif((isdefined("attributes.row_exp_item_id#i#") and len(evaluate('attributes.row_exp_item_id#i#'))),evaluate("attributes.row_exp_item_id#i#"),0),
				subscription_id: iif((isdefined("attributes.row_subscription_id#i#") and len(evaluate('attributes.row_subscription_id#i#')) and isdefined("attributes.row_subscription_name#i#") and len(evaluate('attributes.row_subscription_name#i#'))),evaluate("attributes.row_subscription_id#i#"),attributes.subscription_id_),
				invoice_row_id:GET_MAX_INV_ROW.ROW_MAX_ID,
				paper_no:form.INVOICE_NUMBER,
				process_cat:attributes.PROCESS_CAT,
				detail : "#form.INVOICE_NUMBER# #getLang('','Nolu Fatura',64680)#",
				is_income_expense: 'true',///gelir
				process_type:INVOICE_CAT,
				nettotal: evaluate("attributes.row_nettotal#i#"),
				other_money_value:other_money_value,
				action_currency:other_money,
				action_currency_2:session_base.money2,
				expense_date:attributes.INVOICE_DATE,
				department_id:attributes.department_id,
				project_id:inv_project_id,
				expense_member_id : sales_emp_id,
				expense_member_type : 'employee',
				branch_id : budget_branch_id,
				currency_multiplier : attributes.currency_multiplier,
				group_dsn3_db : new_dsn3_group,
				discounttotal : DISCOUNT_AMOUNT,
				group_period_id : new_period_id
			);

			////İşlem tipinde BSMV'yi giderleştir seçilmişse
			if( is_expensing_bsmv == 1 and isDefined("attributes.row_bsmv_amount#i#") and evaluate("attributes.row_bsmv_amount#i#") > 0 and isDefined("attributes.row_bsmv_currency#i#") and evaluate("attributes.row_bsmv_currency#i#") > 0){

				get_bsmv_row = cfquery(datasource:"#new_dsn2_group#",sqlstring:"SELECT * FROM #new_dsn3_group#.SETUP_BSMV WHERE TAX = #evaluate("attributes.row_bsmv_rate#i#")#");
				butce = butceci(
					action_id:MAX_ID.IDENTITYCOL,
					muhasebe_db:new_dsn2_group,
					muhasebe_db_dsn3:new_dsn3_group,
					period_id:new_period_id,
					stock_id: evaluate("attributes.stock_id#i#"),
					product_id:evaluate("attributes.product_id#i#"),
					activity_type: attributes.row_activity_id,
					expense_center_id: iif((isdefined("attributes.row_exp_center_id#i#") and len(evaluate('attributes.row_exp_center_id#i#'))),evaluate("attributes.row_exp_center_id#i#"),0),
					expense_item_id: get_bsmv_row.EXPENSE_ITEM_ID,///Doğrudan giderleştirme gider kalemi
					subscription_id: iif((isdefined("attributes.row_subscription_id#i#") and len(evaluate('attributes.row_subscription_id#i#')) and isdefined("attributes.row_subscription_name#i#") and len(evaluate('attributes.row_subscription_name#i#'))),evaluate("attributes.row_subscription_id#i#"),attributes.subscription_id_),
					invoice_row_id:GET_MAX_INV_ROW.ROW_MAX_ID,
					paper_no:form.INVOICE_NUMBER,
					detail : "#form.INVOICE_NUMBER# #getLang('','Nolu Fatura',64680)#",
					is_income_expense: 'false',///gider
					process_type:INVOICE_CAT,
					nettotal: evaluate("attributes.row_bsmv_amount#i#"),
					other_money_value:evaluate("attributes.row_bsmv_currency#i#"),
					action_currency:other_money,
					action_currency_2:session_base.money2,
					expense_date:attributes.INVOICE_DATE,
					process_cat:attributes.PROCESS_CAT,
					department_id:attributes.department_id,
					project_id:inv_project_id,
					expense_member_id : sales_emp_id,
					expense_member_type : 'employee',
					branch_id : budget_branch_id,
					currency_multiplier : attributes.currency_multiplier,
					group_dsn3_db : new_dsn3_group,
					group_period_id : new_period_id
				);

			}

			if( is_expensing_tax == 1 and isDefined("attributes.row_taxtotal#i#") and evaluate("attributes.row_taxtotal#i#") > 0 ){////İşlem tipinde KDV'yi giderleştir seçilmişse

				get_tax_row=cfquery(datasource:"#new_dsn2_group#",sqlstring:"SELECT * FROM SETUP_TAX WHERE TAX = #evaluate("form.tax#i#")#");
				butce = butceci(
					action_id:MAX_ID.IDENTITYCOL,
					muhasebe_db:new_dsn2_group,
					muhasebe_db_dsn3:new_dsn3_group,
					period_id:new_period_id,
					stock_id: evaluate("attributes.stock_id#i#"),
					product_id:evaluate("attributes.product_id#i#"),
					activity_type: attributes.row_activity_id,
					expense_center_id: iif((isdefined("attributes.row_exp_center_id#i#") and len(evaluate('attributes.row_exp_center_id#i#'))),evaluate("attributes.row_exp_center_id#i#"),0),
					expense_item_id: get_tax_row.EXPENSE_ITEM_ID,///Doğrudan giderleştirme gider kalemi
					subscription_id: iif((isdefined("attributes.row_subscription_id#i#") and len(evaluate('attributes.row_subscription_id#i#')) and isdefined("attributes.row_subscription_name#i#") and len(evaluate('attributes.row_subscription_name#i#'))),evaluate("attributes.row_subscription_id#i#"),attributes.subscription_id_),
					invoice_row_id:GET_MAX_INV_ROW.ROW_MAX_ID,
					paper_no:form.INVOICE_NUMBER,
					detail : "#form.INVOICE_NUMBER# #getLang('','Nolu Fatura',64680)#",
					is_income_expense: 'false',///gider
					process_type:INVOICE_CAT,
					process_cat:attributes.PROCESS_CAT,
					nettotal: evaluate("attributes.row_taxtotal#i#"),
					other_money_value: (evaluate("attributes.row_taxtotal#i#") * attributes.basket_rate1 / attributes.basket_rate2),
					action_currency:other_money,
					action_currency_2:session_base.money2,
					expense_date:attributes.INVOICE_DATE,
					department_id:attributes.department_id,
					project_id:inv_project_id,
					expense_member_id : sales_emp_id,
					expense_member_type : 'employee',
					branch_id : budget_branch_id,
					currency_multiplier : attributes.currency_multiplier,
					group_dsn3_db : new_dsn3_group,
					group_period_id : new_period_id
				);

			}

			if(butce)dagilim=true;//bir satır bile dagilim yapıldığında is_cost alanını 1 set etmek için dagilim true set ediliyor
	}
	</cfscript>
</cfloop>
<cfscript>
//döngü dışına alındı her satırda is_cost update etmemesi için
	if(dagilim) upd_invoice_cost = cfquery(datasource : "#new_dsn2_group#", is_select: false,sqlstring : "UPDATE INVOICE SET IS_COST=1 WHERE INVOICE_ID=#MAX_ID.IDENTITYCOL#");
</cfscript>
<cfif (included_irs eq 1) and len(attributes.ship_ids)>
<!--- faturaya aktif donemden çekilen irsaliye kayıtları yazılıyor --->	
	<cfset attributes.ship_ids = listsort(attributes.ship_ids,'numeric','asc')> 
	<cfloop list="#listsort(attributes.ship_ids,'numeric','asc')#" index="per_k">
		<cfquery name="ADD_INVOICE_SHIPS" datasource="#new_dsn2_group#">
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
				#MAX_ID.IDENTITYCOL#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.invoice_number#">,
				#per_k#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_irs.SHIP_NUMBER[listfind(attributes.ship_ids,per_k,',')]#">,
				0 ,<!--- irsaliyeli fatura --->
				#session_base.period_id#
			)
		</cfquery>
	</cfloop>
</cfif>
<cfif (included_irs eq 1) and isdefined('pre_period_ships') and len(pre_period_ships)>
	<!--- faturaya önceki donemden irsaliye kayıtları yazılıyor --->
	<cfif isDefined("old_period_row_ship_info") and ListLen(old_period_row_ship_info)>
		<cfset pre_period_ships = old_period_row_ship_info>
	</cfif>
	<cfset ship_number_ = "">
	<cfloop list="#pre_period_ships#" index="index_t">
		<cfif isDefined("old_period_row_ship_info") and ListLen(old_period_row_ship_info)><!--- FBS 20110708 gecici cozum, duzenlenebilir --->
			<cfset ship_id_ = ListFirst(index_t,";")>
			<cfset pre_period_id = ListLast(index_t,";")>
			<cfquery name="get_period" datasource="#new_dsn2_group#">
				SELECT PERIOD_YEAR,OUR_COMPANY_ID FROM #dsn_alias#.SETUP_PERIOD WHERE PERIOD_ID= #pre_period_id# AND OUR_COMPANY_ID = #session.ep.company_id#
			</cfquery>
			<cfif get_period.recordcount>
				<cfquery name="get_irs2" datasource="#new_dsn2_group#">
					SELECT SHIP_NUMBER FROM #dsn#_#get_period.period_year#_#get_period.our_company_id#.SHIP WHERE SHIP_ID = #ship_id_#
				</cfquery>
				<cfset ship_number_ = get_irs2.SHIP_NUMBER>
			</cfif>
		<cfelse>
			<cfset ship_number_ = get_irs2.SHIP_NUMBER[listfind(pre_period_ships,index_t,",")]>
			<cfset ship_id_ = index_t>
		</cfif>
		<cfquery name="ADD_INVOICE_SHIPS" datasource="#new_dsn2_group#">
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
				#MAX_ID.IDENTITYCOL#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.invoice_number#">,
				#ship_id_#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#ship_number_#">,
				0, <!--- irsaliyeli fatura --->
				#pre_period_id#
			)
		</cfquery>
	</cfloop>
</cfif>
<cfif included_irs eq 1><!--- faturaya cekilen irsaliyeler icin (dikkat faturanın kendi irsaliyesi icin degil) SHIP_ROW_RELATION tablosuna kayıt atılıyor--->
	<cfscript>
		if(not isdefined('xml_import'))//xml impordan gelmiyorsa yüklesin
		{
			add_ship_row_relation(
				to_related_process_id : MAX_ID.IDENTITYCOL,
				to_related_process_type : get_process_type.PROCESS_TYPE,
				is_invoice_ship : 0,
				ship_related_action_type:0,
				process_db :new_dsn2_group
				);
		}
	</cfscript>
</cfif>
<!--- tevkifatlı fatura ise --->
<cfif isdefined("attributes.tevkifat_box") and isdefined("attributes.tevkifat_oran") and len(attributes.tevkifat_oran)>
	<cfloop from="1" to="#form.basket_tax_count#" index="tax_i">
		<cfquery name="ADD_INVOICE_TAXES" datasource="#new_dsn2_group#">
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
