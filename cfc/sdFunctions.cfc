<cfcomponent>
<!---add_invoice_from_order --->
	<cffunction name="add_invoice_from_order" returntype="boolean" output="false">
		<cfargument name="order_id" required="yes" type="numeric">
		<cfargument name="invoice_type" required="no" type="any" default="1" hint="1 satis faturası 0 alis faturasi">
		<cfargument name="process_catid" required="yes" type="string">
		<cfargument name="department_id" required="yes" type="string">
		<cfargument name="location_id" required="yes" type="string">
		<cfargument name="invoice_number" required="no" type="string">
		<cfargument name="invoice_date" required="no" type="string" default="">
		<cfargument name="cari_db" type="string" default="#dsn2#">
		<cfif not isdefined("butceci")>
			<cfinclude template="get_butceci.cfm">
		</cfif>
		<cfif not isdefined("carici")>
			<cfinclude template="get_carici.cfm">
		</cfif>
		<cfif not isdefined("muhasebeci")>
			<cfinclude template="get_muhasebeci.cfm">
		</cfif>
		<cfif not isdefined("get_consumer_period")>
			<cfinclude template="get_user_accounts.cfm">
		</cfif>
		<cfif not isdefined("basket_kur_ekle")>
			<cfinclude template="get_basket_money_js.cfm">
		</cfif>
		<cfif not isdefined("add_reserve_row")>
			<cfinclude template="add_order_row_reserved_stock.cfm">
		</cfif>
		<cfif not isdefined("add_stock_rows")>
			<cfinclude template="add_stock_rows.cfm">
		</cfif>
		<cfquery name="get_order_detail" datasource="#arguments.cari_db#">
			SELECT * FROM #dsn3_alias#.ORDERS WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_id#">
		</cfquery>
		<cfquery name="upd_ord_row" datasource="#arguments.cari_db#">
			UPDATE
				#dsn3_alias#.ORDER_ROW
			SET
				ORDER_ROW_CURRENCY  = -6
			WHERE
				ORDER_ID = #arguments.order_id#
		</cfquery>
		<cfquery name="get_order_rows" datasource="#arguments.cari_db#">
			SELECT * FROM #dsn3_alias#.ORDER_ROW WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_id#">
		</cfquery>
		<cfif len(get_order_detail.COMPANY_ID)>
			<cfquery name="get_member_id" datasource="#arguments.cari_db#">
				SELECT
					COMPANY.COMPANY_ID,
					ISNULL(COMPANY.MANAGER_PARTNER_ID,(SELECT TOP 1 PARTNER_ID FROM #dsn_alias#.COMPANY_PARTNER WHERE COMPANY_ID=COMPANY.COMPANY_ID)) PARTNER_ID,
					COMPANY_PERIOD.ACCOUNT_CODE
				FROM 
					#dsn_alias#.COMPANY,
					#dsn_alias#.COMPANY_PERIOD
				WHERE
					COMPANY.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_detail.company_id#"> AND
					COMPANY_PERIOD.COMPANY_ID = COMPANY.COMPANY_ID AND
					<cfif isdefined("session.ep")>
						COMPANY_PERIOD.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
					<cfelse>
						COMPANY_PERIOD.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.period_id#">
					</cfif>
			</cfquery>
		<cfelse>
			<cfquery name="get_member_id" datasource="#arguments.cari_db#">
				SELECT
					CONSUMER.CONSUMER_ID,
					CONSUMER_PERIOD.ACCOUNT_CODE
				FROM 
					#dsn_alias#.CONSUMER,
					#dsn_alias#.CONSUMER_PERIOD
				WHERE 
					CONSUMER.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_detail.consumer_id#"> AND
					CONSUMER.CONSUMER_ID=CONSUMER_PERIOD.CONSUMER_ID AND
					<cfif isdefined("session.ep")>
						CONSUMER_PERIOD.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
					<cfelse>
						CONSUMER_PERIOD.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.period_id#">
					</cfif>
			</cfquery>
		</cfif>
		<cfquery name="get_money" datasource="#arguments.cari_db#">
			SELECT RATE2,RATE1,MONEY_TYPE FROM #dsn3_alias#.ORDER_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_id#">
		</cfquery>
		<cfquery name="get_money_selected" datasource="#arguments.cari_db#">
			SELECT RATE2,RATE1,MONEY_TYPE FROM #dsn3_alias#.ORDER_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_id#"> AND IS_SELECTED=1
		</cfquery>
		<cfset attributes.INVOICE_DATE_H = 0>
		<cfset attributes.INVOICE_DATE_M = 0>
		<cfscript>
			form.sale_product=arguments.invoice_type;
			attributes.rows_ = get_order_rows.recordcount;
			form.process_cat=arguments.process_catid;
			attributes.process_cat=arguments.process_catid;
			attributes.department_id=arguments.department_id;
			attributes.location_id=arguments.location_id;
			if(isdefined("is_action_file_") and is_action_file_ eq 1)
			{
				if(len(company_id_))
				{
					attributes.company_id=company_id_;
					attributes.partner_id=partner_id_;
					attributes.comp_name='a';
					attributes.partner_name='b';
					attributes.consumer_id='';
				}
				else
				{
					attributes.company_id='';
					attributes.partner_id='';
					attributes.comp_name='a';
					attributes.partner_name='b';
					attributes.consumer_id=consumer_id_;
				}
			}
			else
			{
				if(len(get_order_detail.COMPANY_ID))
				{
					attributes.company_id=get_order_detail.COMPANY_ID;
					attributes.partner_id=get_order_detail.PARTNER_ID;
					attributes.comp_name='a';
					attributes.partner_name='b';
					attributes.consumer_id='';
				}else
				{
					attributes.company_id='';
					attributes.comp_name='a';
					attributes.partner_id='';
					attributes.partner_name='b';
					attributes.consumer_id=get_order_detail.CONSUMER_ID;
				}
			}
			attributes.consumer_reference_code=get_order_detail.CONSUMER_REFERENCE_CODE;
			attributes.partner_reference_code=get_order_detail.PARTNER_REFERENCE_CODE;
			if(isdefined("is_action_file_") and is_action_file_ eq 1)// action file dosyasindan gonderilen degerler
			{
				attributes.invoice_number=invoice_number_;
				form.invoice_number=invoice_number_;
				attributes.ref_no=invoice_number_;
				attributes.invoice_date=invoice_date_;
				attributes.order_id = "NULL";
			}
			else
			{
				if(isdefined("arguments.invoice_number") and len(arguments.invoice_number))
				{
					attributes.invoice_number=arguments.invoice_number;
					form.invoice_number=arguments.invoice_number;
				}
				else
				{
					attributes.invoice_number=get_order_detail.order_number;
					form.invoice_number=get_order_detail.order_number;
				}
				attributes.ref_no=get_order_detail.ORDER_NUMBER;
				if(len(arguments.invoice_date))
					attributes.invoice_date=arguments.invoice_date;
				else
					attributes.invoice_date=dateformat(get_order_detail.ORDER_DATE,'dd/mm/yyyy');
				attributes.order_id = arguments.order_id;
			}
			form.serial_number = listfirst(form.invoice_number,'-');
			form.serial_no = listlast(form.invoice_number,'-');
			attributes.kasa='';
			kasa='';
			attributes.member_account_code=GET_MEMBER_ID.ACCOUNT_CODE;
			note=get_order_detail.ORDER_DETAIL;
			attributes.city_id=get_order_detail.CITY_ID;
			attributes.county_id=get_order_detail.COUNTY_ID;
			attributes.adres=get_order_detail.SHIP_ADDRESS;
			for(stp_mny=1;stp_mny lte GET_MONEY.RECORDCOUNT;stp_mny=stp_mny+1)
			{
				'attributes.hidden_rd_money_#stp_mny#'=GET_MONEY.MONEY_TYPE[stp_mny];
				'attributes.txt_rate1_#stp_mny#'=GET_MONEY.RATE1[stp_mny];	
				'attributes.txt_rate2_#stp_mny#'=GET_MONEY.RATE2[stp_mny];
			}
			form.basket_money=GET_MONEY_SELECTED.MONEY_TYPE;
			attributes.basket_money=GET_MONEY_SELECTED.MONEY_TYPE;
			form.basket_rate1=get_money_selected.rate1;
			attributes.basket_rate1=get_money_selected.rate1;
			form.basket_rate2=get_money_selected.rate2;
			attributes.basket_rate2=get_money_selected.rate2;
			attributes.kur_say=GET_MONEY.RECORDCOUNT;
			attributes.basket_id=2;
			attributes.list_payment_row_id='';
			attributes.subscription_id='';
			attributes.invoice_counter_number='';
			attributes.commethod_id='';
			attributes.bool_from_control_bill='';
			attributes.invoice_control_id='';
			attributes.contract_row_ids='';
			attributes.ship_method=get_order_detail.SHIP_METHOD;
			attributes.card_paymethod_id=get_order_detail.CARD_PAYMETHOD_ID;
			attributes.commission_rate=get_order_detail.CARD_PAYMETHOD_RATE;
			attributes.paymethod_id=get_order_detail.PAYMETHOD;
			attributes.project_id=get_order_detail.PROJECT_ID;
			attributes.project_head=get_order_detail.PROJECT_ID;
			attributes.EMPO_ID=get_order_detail.ORDER_EMPLOYEE_ID;
			attributes.PARTO_ID=get_order_detail.SALES_PARTNER_ID;
			form.deliver_get='';
			form.deliver_get_id='';		
				
			inventory_product_exists = 0;
			attributes.yuvarlama='';
			attributes.tevkifat_oran='';
			attributes.is_general_prom=0;
			attributes.indirim_total='100000000000000000000,100000000000000000000';
			attributes.general_prom_limit='';
			attributes.general_prom_discount='';
			attributes.general_prom_amount=0;
			attributes.free_prom_limit='';
			attributes.flt_net_total_all=0;
			attributes.currency_multiplier = '';
			attributes.basket_member_pricecat='';
			attributes.basket_due_value_date_=dateformat(get_order_detail.DUE_DATE,'dd/mm/yyyy');
			attributes.BASKET_PRICE_ROUND_NUMBER = 4;
			if(isdefined("is_action_file_") and is_action_file_ eq 1)// action file dosyasindan gonderilen degerler
			{
				form.basket_gross_total=Last_Total;
				form.basket_net_total=Last_Total;
			}
			else
			{
				form.basket_gross_total=get_order_detail.GROSSTOTAL;
				form.basket_net_total=get_order_detail.nettotal;
				attributes.basket_net_total=get_order_detail.nettotal;
				attributes.basket_gross_total=get_order_detail.GROSSTOTAL;
			}
			form.basket_otv_total=get_order_detail.OTV_TOTAL;
			form.basket_tax_total=get_order_detail.TAXTOTAL;
			if(len(get_order_detail.SA_DISCOUNT))
			{
				form.genel_indirim=get_order_detail.SA_DISCOUNT;
				attributes.genel_indirim=get_order_detail.SA_DISCOUNT;
			}
			else
				0;
			form.basket_discount_total = form.genel_indirim;
			attributes.basket_discount_total = form.genel_indirim;
			xml_tax_count=1;//kdv sayısı
			xml_otv_count=1;//otv sayısı
		</cfscript>
		<cfloop query="get_order_rows">
			<cfset row_ind = get_order_rows.currentrow>
			<cfif isdefined("is_action_file_") and is_action_file_ eq 1 and Len(new_product_id_)>
				<cfset 'attributes.product_id#row_ind#' = new_product_id_>
			<cfelse>
				<cfset 'attributes.product_id#row_ind#' = get_order_rows.PRODUCT_ID[row_ind]>
			</cfif>
			<cfquery name="get_product_id" datasource="#arguments.cari_db#">
				SELECT
					S.BARCOD BARCODE,
					S.STOCK_ID,
					S.PRODUCT_ID,
					S.STOCK_CODE,
					S.PRODUCT_NAME,
					S.PROPERTY,
					S.IS_INVENTORY,
					S.MANUFACT_CODE,
					S.TAX,
					S.IS_PRODUCTION
				FROM
					#dsn3_alias#.STOCKS AS S
				WHERE
					S.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('attributes.product_id#row_ind#')#">
			</cfquery>
			<cfscript>
				if(isdefined("is_action_file_") and is_action_file_ eq 1)// action file dosyasindan gonderilen degerler
				{
					'attributes.product_name#row_ind#'= get_product_id.product_name;
					'attributes.product_name_other#row_ind#'= get_product_id.product_name;
					'attributes.tax#row_ind#'= get_product_id.tax;
					'form.tax#row_ind#'= get_product_id.tax;
				}
				else
				{
					'attributes.product_name#row_ind#'=get_order_rows.PRODUCT_NAME[row_ind];
					'attributes.product_name_other#row_ind#'=get_order_rows.PRODUCT_NAME2[row_ind];
					'attributes.tax#row_ind#'= get_product_id.tax;
					'form.tax#row_ind#'= get_product_id.tax;
				}
				
				'attributes.is_inventory#row_ind#'=get_product_id.IS_INVENTORY;
				if(get_product_id.IS_INVENTORY) inventory_product_exists = 1;
				'attributes.is_production#row_ind#'=get_product_id.IS_PRODUCTION;
				'attributes.amount#row_ind#'=get_order_rows.QUANTITY[row_ind];
				'attributes.deliver_date#row_ind#'=get_order_rows.DELIVER_DATE[row_ind];
				'attributes.deliver_dept#row_ind#'=get_order_rows.DELIVER_DEPT[row_ind];
				'attributes.duedate#row_ind#'=get_order_rows.DUEDATE[row_ind];
				'attributes.ek_tutar#row_ind#'=get_order_rows.EK_TUTAR_PRICE[row_ind];
				'attributes.ek_tutar_other_total#row_ind#'=get_order_rows.EXTRA_PRICE_TOTAL[row_ind];
				'attributes.ek_tutar_total#row_ind#'=get_order_rows.EXTRA_PRICE_OTHER_TOTAL[row_ind];
				'attributes.extra_cost#row_ind#'=get_order_rows.EXTRA_COST[row_ind];
				if(len(get_order_rows.DISCOUNT_1[row_ind]))
					'attributes.indirim1#row_ind#'=get_order_rows.DISCOUNT_1[row_ind];
				else
					'attributes.indirim1#row_ind#'=0;
				if(len(get_order_rows.DISCOUNT_2[row_ind]))
					'attributes.indirim2#row_ind#'=get_order_rows.DISCOUNT_2[row_ind];
				else
					'attributes.indirim2#row_ind#'=0;
				if(len(get_order_rows.DISCOUNT_3[row_ind]))
					'attributes.indirim3#row_ind#'=get_order_rows.DISCOUNT_3[row_ind];
				else
					'attributes.indirim3#row_ind#'=0;
				if(len(get_order_rows.DISCOUNT_4[row_ind]))
					'attributes.indirim4#row_ind#'=get_order_rows.DISCOUNT_4[row_ind];
				else
					'attributes.indirim4#row_ind#'=0;
				if(len(get_order_rows.DISCOUNT_5[row_ind]))
					'attributes.indirim5#row_ind#'=get_order_rows.DISCOUNT_5[row_ind];
				else
					'attributes.indirim5#row_ind#'=0;
				if(len(get_order_rows.DISCOUNT_6[row_ind]))
					'attributes.indirim6#row_ind#'=get_order_rows.DISCOUNT_6[row_ind];
				else
					'attributes.indirim6#row_ind#'=0;
				if(len(get_order_rows.DISCOUNT_7[row_ind]))
					'attributes.indirim7#row_ind#'=get_order_rows.DISCOUNT_7[row_ind];
				else
					'attributes.indirim7#row_ind#'=0;
				if(len(get_order_rows.DISCOUNT_8[row_ind]))
					'attributes.indirim8#row_ind#'=get_order_rows.DISCOUNT_8[row_ind];
				else
					'attributes.indirim8#row_ind#'=0;
				if(len(get_order_rows.DISCOUNT_9[row_ind]))
					'attributes.indirim9#row_ind#'=get_order_rows.DISCOUNT_9[row_ind];
				else
					'attributes.indirim9#row_ind#'=0;
				if(len(get_order_rows.DISCOUNT_10[row_ind]))
					'attributes.indirim10#row_ind#'=get_order_rows.DISCOUNT_10[row_ind];
				else
					'attributes.indirim10#row_ind#'=0;
				'attributes.indirim_carpan#row_ind#' = (100-Evaluate('attributes.indirim1#row_ind#')) * (100-Evaluate('attributes.indirim2#row_ind#')) * (100-Evaluate('attributes.indirim3#row_ind#')) * (100-Evaluate('attributes.indirim4#row_ind#')) * (100-Evaluate('attributes.indirim5#row_ind#')) * (100-Evaluate('attributes.indirim6#row_ind#')) * (100-Evaluate('attributes.indirim7#row_ind#')) * (100-Evaluate('attributes.indirim8#row_ind#')) * (100-Evaluate('attributes.indirim9#row_ind#')) * (100-Evaluate('attributes.indirim10#row_ind#'));
				'attributes.iskonto_tutar#row_ind#'=get_order_rows.DISCOUNT_COST[row_ind];
				'attributes.is_commission#row_ind#'=get_order_rows.IS_COMMISSION[row_ind];
				'attributes.is_promotion#row_ind#'=get_order_rows.IS_PROMOTION[row_ind];
				'attributes.karma_product_id#row_ind#'=get_order_rows.KARMA_PRODUCT_ID[row_ind];
				'attributes.list_price#row_ind#'=get_order_rows.LIST_PRICE[row_ind];
				'attributes.lot_no#row_ind#'=get_order_rows.LOT_NO[row_ind];
				'attributes.manufact_code#row_ind#'=get_order_rows.PRODUCT_MANUFACT_CODE[row_ind];
				'attributes.marj#row_ind#'=get_order_rows.MARJ[row_ind];
				'attributes.net_maliyet#row_ind#'=get_order_rows.COST_PRICE[row_ind];
				'attributes.number_of_installment#row_ind#'=get_order_rows.NUMBER_OF_INSTALLMENT[row_ind];
				'attributes.order_currency#row_ind#'=get_order_rows.ORDER_ROW_CURRENCY[row_ind];
				
				'attributes.otv_oran#row_ind#'=get_order_rows.OTV_ORAN[row_ind];
				'attributes.row_otvtotal#row_ind#'=get_order_rows.OTVTOTAL[row_ind];
				'form.row_otvtotal#row_ind#'=get_order_rows.OTVTOTAL[row_ind];
				if(isdefined("is_action_file_") and is_action_file_ eq 1)
				{
					'attributes.price#row_ind#'= Last_Total;
					'attributes.price_other#row_ind#'= Last_Total;
					'attributes.row_total#row_ind#'= (Evaluate('attributes.amount#row_ind#') * Evaluate('attributes.price#row_ind#')) + Evaluate('attributes.ek_tutar_total#row_ind#');
					'attributes.row_nettotal#row_ind#' = wrk_round((Evaluate('attributes.row_total#row_ind#')/100000000000000000000)*Evaluate('attributes.indirim_carpan#row_ind#'),4);
					'attributes.row_taxtotal#row_ind#'= wrk_round(Evaluate('attributes.row_nettotal#row_ind#')*(Evaluate('attributes.tax#row_ind#')/100),4);
					'attributes.row_lasttotal#row_ind#' = (Evaluate('attributes.row_nettotal#row_ind#') + Evaluate('attributes.row_taxtotal#row_ind#')) + Evaluate('attributes.row_otvtotal#row_ind#');
					'attributes.other_money_#row_ind#'= session.ep.money;
					'attributes.other_money_value_#row_ind#'= Evaluate('attributes.row_nettotal#row_ind#');
					'attributes.other_money_gross_total#row_ind#'= Evaluate('attributes.row_lasttotal#row_ind#');
				}
				else
				{
					'attributes.price#row_ind#' = get_order_rows.PRICE[row_ind];
					'attributes.price_other#row_ind#' = get_order_rows.PRICE_OTHER[row_ind];
					'attributes.row_total#row_ind#' = get_order_rows.NETTOTAL[row_ind];
					'attributes.row_nettotal#row_ind#' = get_order_rows.NETTOTAL[row_ind];
					'attributes.row_taxtotal#row_ind#' = get_order_rows.NETTOTAL[row_ind]*get_order_rows.TAX[row_ind]/100;
					'attributes.row_lasttotal#row_ind#' = get_order_rows.NETTOTAL[row_ind] + (get_order_rows.NETTOTAL[row_ind]*get_order_rows.TAX[row_ind]/100);
					'attributes.other_money_#row_ind#' = get_order_rows.OTHER_MONEY[row_ind];
					'attributes.other_money_value_#row_ind#' = get_order_rows.OTHER_MONEY_VALUE[row_ind];
					'attributes.other_money_gross_total#row_ind#' = get_order_rows.OTHER_MONEY_VALUE[row_ind] + (get_order_rows.OTHER_MONEY_VALUE[row_ind]*get_order_rows.TAX[row_ind]/100);
				}
				'form.row_taxtotal#row_ind#' = evaluate('attributes.row_taxtotal#row_ind#');
				'attributes.price_cat#row_ind#'=get_order_rows.PRICE_CAT[row_ind];
				'attributes.product_account_code#row_ind#'='';
				'attributes.promosyon_maliyet#row_ind#'=get_order_rows.PROM_COST[row_ind];
				'attributes.promosyon_yuzde#row_ind#'=get_order_rows.PROM_COMISSION[row_ind];
				'attributes.prom_relation_id#row_ind#'=get_order_rows.PROM_RELATION_ID[row_ind];
				'attributes.prom_stock_id#row_ind#'=get_order_rows.PROM_STOCK_ID[row_ind];
				'attributes.reserve_date#row_ind#'=get_order_rows.RESERVE_DATE[row_ind];
				'attributes.reserve_type#row_ind#'=get_order_rows.RESERVE_TYPE[row_ind];
				'attributes.row_promotion_id#row_ind#'=get_order_rows.PROM_ID[row_ind];
				'attributes.row_service_id#row_ind#'='';
				'attributes.row_ship_id#row_ind#'=0;
				'attributes.row_unique_relation_id#row_ind#'=get_order_rows.UNIQUE_RELATION_ID[row_ind];
				'attributes.shelf_number#row_ind#'=get_order_rows.SHELF_NUMBER[row_ind];
				'attributes.spect_id#row_ind#'=get_order_rows.SPECT_VAR_ID[row_ind];
				'attributes.spect_name#row_ind#'=get_order_rows.SPECT_VAR_NAME[row_ind];
				'attributes.stock_id#row_ind#'=get_order_rows.STOCK_ID[row_ind];
				'attributes.unit#row_ind#'=get_order_rows.UNIT[row_ind];
				'attributes.unit_id#row_ind#'=get_order_rows.UNIT_ID[row_ind];
				'attributes.unit_other#row_ind#'=get_order_rows.UNIT2[row_ind];
				'attributes.basket_employee_id#row_ind#'=get_order_rows.BASKET_EMPLOYEE_ID[row_ind];
				'attributes.basket_extra_info#row_ind#'=get_order_rows.BASKET_EXTRA_INFO_ID[row_ind];
				'attributes.detail_info_extra#row_ind#'=get_order_rows.DETAIL_INFO_EXTRA[row_ind];
				'attributes.select_info_extra#row_ind#'=get_order_rows.SELECT_INFO_EXTRA[row_ind];
				
				'attributes.row_bsmv_rate#row_ind#'=get_order_rows.BSMV_RATE[row_ind];
				'attributes.row_bsmv_amount#row_ind#'=get_order_rows.BSMV_AMOUNT[row_ind];
				'attributes.row_bsmv_currency#row_ind#'=get_order_rows.BSMV_CURRENCY[row_ind];
				'attributes.row_oiv_rate#row_ind#'=get_order_rows.OIV_RATE[row_ind];
				'attributes.row_oiv_amount#row_ind#'=get_order_rows.OIV_AMOUNT[row_ind];
				'attributes.row_tevkifat_rate#row_ind#'=get_order_rows.TEVKIFAT_RATE[row_ind];
				'attributes.row_tevkifat_amount#row_ind#'=get_order_rows.TEVKIFAT_AMOUNT[row_ind];
				'attributes.row_exp_center_id#row_ind#'=get_order_rows.EXPENSE_CENTER_ID[row_ind];
				'attributes.row_exp_item_id#row_ind#'=get_order_rows.EXPENSE_ITEM_ID[row_ind];
				'attributes.row_subscription_id#row_ind#'=get_order_rows.SUBSCRIPTION_ID[row_ind];

				if(isdefined('session.pp.userid'))
					'attributes.wrk_row_id#row_ind#'="#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.pp.userid##round(rand()*100)#";
				else if(isdefined('session.ww.userid'))
					'attributes.wrk_row_id#row_ind#'="#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ww.userid##round(rand()*100)#";
				else
					'attributes.wrk_row_id#row_ind#'="#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)#";
				if(isdefined("is_action_file_") and is_action_file_ eq 1)
				{
					'attributes.wrk_row_relation_id#row_ind#'="NULL";
					if(isdefined("invoice_id_") and len(invoice_id_))
					{
						'attributes.related_action_table#row_ind#' = "SALES_QUOTAS";
						'attributes.related_action_id#row_ind#' = invoice_id_;
					}
				}
				else
					'attributes.wrk_row_relation_id#row_ind#'=get_order_rows.WRK_ROW_ID[row_ind];
				attributes.rows_ = row_ind;
			</cfscript>
		</cfloop>
		<cfscript>
			for(ind_inv_row=1;ind_inv_row lte attributes.rows_;ind_inv_row=ind_inv_row+1)
			{
				//fatura altı indirim varsa ona hesaplanarak satırlara yansıtılıyor
				row_price_=get_order_rows.PRICE[ind_inv_row]*get_order_rows.QUANTITY[ind_inv_row];
				tmp_tax=0;
				for(ind_tax_count=1;ind_tax_count lte xml_tax_count;ind_tax_count=ind_tax_count+1)
				{
					if(isdefined('form.basket_tax_#ind_tax_count#') and len(evaluate('form.basket_tax_#ind_tax_count#')) and evaluate('form.basket_tax_#ind_tax_count#') eq evaluate('attributes.tax#ind_inv_row#'))
					{
						'form.basket_tax_value_#ind_tax_count#' =evaluate('form.basket_tax_value_#ind_tax_count#') + wrk_round((row_price_/100)*get_order_rows.TAX[ind_inv_row],2);
						tmp_tax=1;
						break;
					}
				}
				if(tmp_tax eq 0)
				{
					'form.basket_tax_#xml_tax_count#' = evaluate('attributes.tax#ind_inv_row#');
					'form.basket_tax_value_#xml_tax_count#' =  wrk_round((row_price_/100)*get_order_rows.TAX[ind_inv_row],2);
					xml_tax_count=xml_tax_count+1;
				}
				tmp_otv=0;
				for(ind_otv_count=1;ind_otv_count lte xml_otv_count;ind_otv_count=ind_otv_count+1)
				{
					if(isdefined('form.basket_otv_#ind_otv_count#') and evaluate('form.basket_otv_#ind_otv_count#') eq evaluate('attributes.otv_oran#ind_inv_row#'))
					{
						'form.basket_otv_value_#ind_otv_count#'= evaluate('form.basket_otv_value_#ind_otv_count#') + wrk_round((row_price_/100)*get_order_rows.OTV_ORAN[ind_inv_row],2);
						tmp_otv=1;
						break;
					}
				}
				if(tmp_otv eq 0)	
				{
					'form.basket_otv_#xml_otv_count#'= evaluate('attributes.otv_oran#ind_inv_row#');
					'form.basket_otv_value_#xml_otv_count#'= wrk_round((row_price_/100)*get_order_rows.OTV_ORAN[ind_inv_row],2);
					xml_otv_count=xml_otv_count+1;
				}
			}
		</cfscript>
		<cfscript>
			form.basket_otv_count = xml_otv_count-1;//otv oran sayısı
			form.basket_tax_count = xml_tax_count-1;//kdv sayısı
		</cfscript>
		<cfset xml_import=2>
		<cfset is_from_function=1>
		<cfif arguments.invoice_type eq 0>
			<cfinclude template="../v16/invoice/query/add_invoice_purchase.cfm">
		<cfelse>
			<cfinclude template="../v16/invoice/query/add_invoice_sale.cfm">
		</cfif>
		<cfscript>
			for (i=1;i lte form.basket_tax_count;i=i+1)
			{
				'form.basket_tax_#i#'= '';
			}
		</cfscript>
		<cfreturn 1>
	</cffunction>

<!--- add_invoice_from_ship---->
	<cffunction name="add_invoice_from_ship" returntype="boolean" output="false">
		<cfargument name="ship_id" required="yes" type="numeric">
		<cfargument name="process_catid" required="yes" type="string">
		<cfargument name="invoice_number" required="yes" type="string">
		<cfargument name="invoice_date" required="yes" type="date">
		<cfargument name="cari_db" type="string" default="#dsn2#">
		<cfif not isdefined("butceci")>
			<cfinclude template="get_butceci.cfm">
		</cfif>
		<cfif not isdefined("carici")>
			<cfinclude template="get_carici.cfm">
		</cfif>
		<cfif not isdefined("muhasebeci")>
			<cfinclude template="get_muhasebeci.cfm">
		</cfif>
		<cfif not isdefined("get_consumer_period")>
			<cfinclude template="get_user_accounts.cfm">
		</cfif>
		<cfif not isdefined("basket_kur_ekle")>
			<cfinclude template="get_basket_money_js.cfm">
		</cfif>
		<cfif not isdefined("add_reserve_row")>
			<cfinclude template="add_order_row_reserved_stock.cfm">
		</cfif>
		<cfif not isdefined("add_stock_rows")>
			<cfinclude template="add_stock_rows.cfm">
		</cfif>
		<cfif not isdefined("add_company_related_action")>
			<cfinclude template="add_company_related_action.cfm">
		</cfif>
		<cfquery name="get_ship_detail" datasource="#arguments.cari_db#">
			SELECT * FROM #dsn2_alias#.SHIP WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ship_id#">
		</cfquery>
		<cfquery name="get_ship_rows" datasource="#arguments.cari_db#">
			SELECT * FROM #dsn2_alias#.SHIP_ROW WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ship_id#">
		</cfquery>
		<cfif len(get_ship_detail.COMPANY_ID)>
			<cfquery name="get_member_id" datasource="#arguments.cari_db#">
				SELECT
					COMPANY.COMPANY_ID,
					ISNULL(COMPANY.MANAGER_PARTNER_ID,(SELECT TOP 1 PARTNER_ID FROM #dsn_alias#.COMPANY_PARTNER WHERE COMPANY_ID=COMPANY.COMPANY_ID)) PARTNER_ID,
					COMPANY_PERIOD.ACCOUNT_CODE
				FROM 
					#dsn_alias#.COMPANY,
					#dsn_alias#.COMPANY_PERIOD
				WHERE
					COMPANY.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ship_detail.company_id#"> AND
					COMPANY_PERIOD.COMPANY_ID = COMPANY.COMPANY_ID AND
					<cfif isdefined("session.ep")>
						COMPANY_PERIOD.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
					<cfelse>
						COMPANY_PERIOD.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.period_id#">
					</cfif>
			</cfquery>
		<cfelse>
			<cfquery name="get_member_id" datasource="#arguments.cari_db#">
				SELECT
					CONSUMER.CONSUMER_ID,
					CONSUMER_PERIOD.ACCOUNT_CODE
				FROM 
					#dsn_alias#.CONSUMER,
					#dsn_alias#.CONSUMER_PERIOD
				WHERE 
					CONSUMER.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ship_detail.consumer_id#"> AND
					CONSUMER.CONSUMER_ID=CONSUMER_PERIOD.CONSUMER_ID AND
					<cfif isdefined("session.ep")>
						CONSUMER_PERIOD.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
					<cfelse>
						CONSUMER_PERIOD.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.period_id#">
					</cfif>
			</cfquery>
		</cfif>
		<cfquery name="get_money" datasource="#arguments.cari_db#">
			SELECT RATE2,RATE1,MONEY_TYPE FROM #dsn2_alias#.SHIP_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ship_id#">
		</cfquery>
		<cfquery name="get_money_selected" datasource="#arguments.cari_db#">
			SELECT RATE2,RATE1,MONEY_TYPE FROM #dsn2_alias#.SHIP_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ship_id#"> AND IS_SELECTED=1
		</cfquery>
		<cfscript>		
			form.sale_product=1;
			attributes.rows_ = get_ship_rows.recordcount;
			form.process_cat=arguments.process_catid;
			attributes.process_cat=arguments.process_catid;
			attributes.department_id=get_ship_detail.deliver_store_id;
			attributes.location_id=get_ship_detail.location;
			if(isdefined("is_action_file_") and is_action_file_ eq 1)
			{
				if(len(company_id_))
				{
					attributes.company_id=company_id_;
					attributes.partner_id=partner_id_;
					attributes.comp_name='a';
					attributes.partner_name='b';
					attributes.consumer_id='';
				}
				else
				{
					attributes.company_id='';
					attributes.partner_id='';
					attributes.comp_name='a';
					attributes.partner_name='b';
					attributes.consumer_id=consumer_id_;
				}
			}
			else
			{
				if(len(get_ship_detail.COMPANY_ID))
				{
					attributes.company_id=get_ship_detail.COMPANY_ID;
					attributes.partner_id=get_ship_detail.PARTNER_ID;
					attributes.comp_name='a';
					attributes.partner_name='b';
					attributes.consumer_id='';
				}else
				{
					attributes.company_id='';
					attributes.comp_name='a';
					attributes.partner_id='';
					attributes.partner_name='b';
					attributes.consumer_id=get_ship_detail.CONSUMER_ID;
				}
			}
			attributes.invoice_number=arguments.invoice_number;
			form.invoice_number=arguments.invoice_number;
			attributes.ref_no=get_ship_detail.ship_number;
			attributes.invoice_date=arguments.invoice_date;
			attributes.irsaliye_id_listesi = arguments.ship_id;
			form.serial_number = listfirst(form.invoice_number,'-');
			form.serial_no = listlast(form.invoice_number,'-');
			attributes.kasa='';
			kasa='';
			attributes.member_account_code=GET_MEMBER_ID.ACCOUNT_CODE;
			note=get_ship_detail.SHIP_DETAIL;
			attributes.city_id=get_ship_detail.CITY_ID;
			attributes.county_id=get_ship_detail.COUNTY_ID;
			attributes.adres=get_ship_detail.ADDRESS;
			for(stp_mny=1;stp_mny lte GET_MONEY.RECORDCOUNT;stp_mny=stp_mny+1)
			{
				'attributes.hidden_rd_money_#stp_mny#'=GET_MONEY.MONEY_TYPE[stp_mny];
				'attributes.txt_rate1_#stp_mny#'=GET_MONEY.RATE1[stp_mny];	
				'attributes.txt_rate2_#stp_mny#'=GET_MONEY.RATE2[stp_mny];
			}
			form.basket_money=GET_MONEY_SELECTED.MONEY_TYPE;
			attributes.basket_money=GET_MONEY_SELECTED.MONEY_TYPE;
			form.basket_rate1=get_money_selected.rate1;
			attributes.basket_rate1=get_money_selected.rate1;
			form.basket_rate2=get_money_selected.rate2;
			attributes.basket_rate2=get_money_selected.rate2;
			attributes.kur_say=GET_MONEY.RECORDCOUNT;
			attributes.basket_id=2;
			attributes.list_payment_row_id='';
			attributes.subscription_id='';
			attributes.invoice_counter_number='';
			attributes.commethod_id='';
			attributes.bool_from_control_bill='';
			attributes.invoice_control_id='';
			attributes.contract_row_ids='';
			attributes.ship_method=get_ship_detail.SHIP_METHOD;
			attributes.card_paymethod_id=get_ship_detail.CARD_PAYMETHOD_ID;
			attributes.commission_rate=get_ship_detail.CARD_PAYMETHOD_RATE;
			attributes.paymethod_id=get_ship_detail.PAYMETHOD_ID;
			attributes.project_id=get_ship_detail.PROJECT_ID;
			attributes.project_head=get_ship_detail.PROJECT_ID;
			attributes.EMPO_ID=get_ship_detail.SALE_EMP;
			attributes.PARTO_ID='';
			form.deliver_get='';
			form.deliver_get_id='';		
				
			inventory_product_exists = 0;
			attributes.yuvarlama='';
			attributes.tevkifat_oran='';
			attributes.is_general_prom=0;
			attributes.indirim_total='100000000000000000000,100000000000000000000';
			attributes.general_prom_limit='';
			attributes.general_prom_discount='';
			attributes.general_prom_amount=0;
			attributes.free_prom_limit='';
			attributes.flt_net_total_all=0;
			attributes.currency_multiplier = '';
			attributes.basket_member_pricecat='';
			attributes.basket_due_value_date_=dateformat(get_ship_detail.DUE_DATE,'dd/mm/yyyy');
			attributes.BASKET_PRICE_ROUND_NUMBER = 4;
			if(isdefined("is_action_file_") and is_action_file_ eq 1)// action file dosyasindan gonderilen degerler
			{
				form.basket_gross_total=Last_Total;
				form.basket_net_total=Last_Total;
			}
			else
			{
				form.basket_gross_total=get_ship_detail.GROSSTOTAL;
				form.basket_net_total=get_ship_detail.nettotal;
				attributes.basket_net_total=get_ship_detail.nettotal;
				attributes.basket_gross_total=get_ship_detail.GROSSTOTAL;
			}
			form.basket_otv_total=get_ship_detail.OTV_TOTAL;
			form.basket_tax_total=get_ship_detail.TAXTOTAL;
			if(len(get_ship_detail.SA_DISCOUNT))
			{
				form.genel_indirim=get_ship_detail.SA_DISCOUNT;
				attributes.genel_indirim=get_ship_detail.SA_DISCOUNT;
			}
			else
				0;
			form.basket_discount_total = form.genel_indirim;
			attributes.basket_discount_total = form.genel_indirim;
			xml_tax_count=1;//kdv sayısı
			xml_otv_count=1;//otv sayısı
		</cfscript>
		<cfloop query="get_ship_rows">
			<cfset row_ind = get_ship_rows.currentrow>
			<cfif isdefined("is_action_file_") and is_action_file_ eq 1 and Len(new_product_id_)>
				<cfset 'attributes.product_id#row_ind#' = new_product_id_>
			<cfelse>
				<cfset 'attributes.product_id#row_ind#' = get_ship_rows.PRODUCT_ID[row_ind]>
			</cfif>
			<cfquery name="get_product_id" datasource="#arguments.cari_db#">
				SELECT
					S.BARCOD BARCODE,
					S.STOCK_ID,
					S.PRODUCT_ID,
					S.STOCK_CODE,
					S.PRODUCT_NAME,
					S.PROPERTY,
					S.IS_INVENTORY,
					S.MANUFACT_CODE,
					S.TAX,
					S.IS_PRODUCTION
				FROM
					#dsn3_alias#.STOCKS AS S
				WHERE
					S.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('attributes.product_id#row_ind#')#">
			</cfquery>
			<cfscript>
				if(isdefined("is_action_file_") and is_action_file_ eq 1)// action file dosyasindan gonderilen degerler
				{
					'attributes.product_name#row_ind#'= get_product_id.product_name;
					'attributes.product_name_other#row_ind#'= get_product_id.product_name;
					'attributes.tax#row_ind#'= get_product_id.tax;
					'form.tax#row_ind#'= get_product_id.tax;
				}
				else
				{
					'attributes.product_name#row_ind#'=get_ship_rows.NAME_PRODUCT[row_ind];
					'attributes.product_name_other#row_ind#'=get_ship_rows.PRODUCT_NAME2[row_ind];
					'attributes.tax#row_ind#'= get_product_id.tax;
					'form.tax#row_ind#'= get_product_id.tax;
				}
				
				'attributes.is_inventory#row_ind#'=get_product_id.IS_INVENTORY;
				if(get_product_id.IS_INVENTORY) inventory_product_exists = 1;
				'attributes.is_production#row_ind#'=get_product_id.IS_PRODUCTION;
				'attributes.amount#row_ind#'=get_ship_rows.AMOUNT[row_ind];
				'attributes.deliver_date#row_ind#'=get_ship_rows.DELIVER_DATE[row_ind];
				'attributes.deliver_dept#row_ind#'=get_ship_rows.DELIVER_DEPT[row_ind];
				'attributes.duedate#row_ind#'=get_ship_rows.DUE_DATE[row_ind];
				'attributes.ek_tutar#row_ind#'=get_ship_rows.EK_TUTAR_PRICE[row_ind];
				'attributes.ek_tutar_other_total#row_ind#'=get_ship_rows.EXTRA_PRICE_TOTAL[row_ind];
				'attributes.ek_tutar_total#row_ind#'=get_ship_rows.EXTRA_PRICE_OTHER_TOTAL[row_ind];
				'attributes.extra_cost#row_ind#'=get_ship_rows.EXTRA_COST[row_ind];
				if(len(get_ship_rows.DISCOUNT[row_ind]))
					'attributes.indirim1#row_ind#'=get_ship_rows.DISCOUNT[row_ind];
				else
					'attributes.indirim1#row_ind#'=0;
				if(len(get_ship_rows.DISCOUNT2[row_ind]))
					'attributes.indirim2#row_ind#'=get_ship_rows.DISCOUNT2[row_ind];
				else
					'attributes.indirim2#row_ind#'=0;
				if(len(get_ship_rows.DISCOUNT3[row_ind]))
					'attributes.indirim3#row_ind#'=get_ship_rows.DISCOUNT3[row_ind];
				else
					'attributes.indirim3#row_ind#'=0;
				if(len(get_ship_rows.DISCOUNT4[row_ind]))
					'attributes.indirim4#row_ind#'=get_ship_rows.DISCOUNT4[row_ind];
				else
					'attributes.indirim4#row_ind#'=0;
				if(len(get_ship_rows.DISCOUNT5[row_ind]))
					'attributes.indirim5#row_ind#'=get_ship_rows.DISCOUNT5[row_ind];
				else
					'attributes.indirim5#row_ind#'=0;
				if(len(get_ship_rows.DISCOUNT6[row_ind]))
					'attributes.indirim6#row_ind#'=get_ship_rows.DISCOUNT6[row_ind];
				else
					'attributes.indirim6#row_ind#'=0;
				if(len(get_ship_rows.DISCOUNT7[row_ind]))
					'attributes.indirim7#row_ind#'=get_ship_rows.DISCOUNT7[row_ind];
				else
					'attributes.indirim7#row_ind#'=0;
				if(len(get_ship_rows.DISCOUNT8[row_ind]))
					'attributes.indirim8#row_ind#'=get_ship_rows.DISCOUNT8[row_ind];
				else
					'attributes.indirim8#row_ind#'=0;
				if(len(get_ship_rows.DISCOUNT9[row_ind]))
					'attributes.indirim9#row_ind#'=get_ship_rows.DISCOUNT9[row_ind];
				else
					'attributes.indirim9#row_ind#'=0;
				if(len(get_ship_rows.DISCOUNT10[row_ind]))
					'attributes.indirim10#row_ind#'=get_ship_rows.DISCOUNT10[row_ind];
				else
					'attributes.indirim10#row_ind#'=0;
				'attributes.indirim_carpan#row_ind#' = (100-Evaluate('attributes.indirim1#row_ind#')) * (100-Evaluate('attributes.indirim2#row_ind#')) * (100-Evaluate('attributes.indirim3#row_ind#')) * (100-Evaluate('attributes.indirim4#row_ind#')) * (100-Evaluate('attributes.indirim5#row_ind#')) * (100-Evaluate('attributes.indirim6#row_ind#')) * (100-Evaluate('attributes.indirim7#row_ind#')) * (100-Evaluate('attributes.indirim8#row_ind#')) * (100-Evaluate('attributes.indirim9#row_ind#')) * (100-Evaluate('attributes.indirim10#row_ind#'));
				'attributes.iskonto_tutar#row_ind#'=get_ship_rows.DISCOUNT_COST[row_ind];
				'attributes.is_commission#row_ind#'=get_ship_rows.IS_COMMISSION[row_ind];
				'attributes.is_promotion#row_ind#'=get_ship_rows.IS_PROMOTION[row_ind];
				'attributes.karma_product_id#row_ind#'=get_ship_rows.KARMA_PRODUCT_ID[row_ind];
				'attributes.list_price#row_ind#'=get_ship_rows.LIST_PRICE[row_ind];
				'attributes.lot_no#row_ind#'=get_ship_rows.LOT_NO[row_ind];
				'attributes.manufact_code#row_ind#'=get_ship_rows.PRODUCT_MANUFACT_CODE[row_ind];
				'attributes.marj#row_ind#'=get_ship_rows.MARGIN[row_ind];
				'attributes.net_maliyet#row_ind#'=get_ship_rows.COST_PRICE[row_ind];
				'attributes.number_of_installment#row_ind#'=get_ship_rows.NUMBER_OF_INSTALLMENT[row_ind];
				
				'attributes.otv_oran#row_ind#'=get_ship_rows.OTV_ORAN[row_ind];
				'attributes.row_otvtotal#row_ind#'=get_ship_rows.OTVTOTAL[row_ind];
				'form.row_otvtotal#row_ind#'=get_ship_rows.OTVTOTAL[row_ind];
				if(isdefined("is_action_file_") and is_action_file_ eq 1)
				{
					'attributes.price#row_ind#'= Last_Total;
					'attributes.price_other#row_ind#'= Last_Total;
					'attributes.row_total#row_ind#'= (Evaluate('attributes.amount#row_ind#') * Evaluate('attributes.price#row_ind#')) + Evaluate('attributes.ek_tutar_total#row_ind#');
					'attributes.row_nettotal#row_ind#' = wrk_round((Evaluate('attributes.row_total#row_ind#')/100000000000000000000)*Evaluate('attributes.indirim_carpan#row_ind#'),4);
					'attributes.row_taxtotal#row_ind#'= wrk_round(Evaluate('attributes.row_nettotal#row_ind#')*(Evaluate('attributes.tax#row_ind#')/100),4);
					'attributes.row_lasttotal#row_ind#' = (Evaluate('attributes.row_nettotal#row_ind#') + Evaluate('attributes.row_taxtotal#row_ind#')) + Evaluate('attributes.row_otvtotal#row_ind#');
					'attributes.other_money_#row_ind#'= session.ep.money;
					'attributes.other_money_value_#row_ind#'= Evaluate('attributes.row_nettotal#row_ind#');
					'attributes.other_money_gross_total#row_ind#'= Evaluate('attributes.row_lasttotal#row_ind#');
				}
				else
				{
					'attributes.price#row_ind#' = get_ship_rows.PRICE[row_ind];
					'attributes.price_other#row_ind#' = get_ship_rows.PRICE_OTHER[row_ind];
					'attributes.row_total#row_ind#' = get_ship_rows.NETTOTAL[row_ind];
					'attributes.row_nettotal#row_ind#' = get_ship_rows.NETTOTAL[row_ind];
					'attributes.row_taxtotal#row_ind#' = get_ship_rows.NETTOTAL[row_ind]*get_ship_rows.TAX[row_ind]/100;
					'attributes.row_lasttotal#row_ind#' = get_ship_rows.NETTOTAL[row_ind] + (get_ship_rows.NETTOTAL[row_ind]*get_ship_rows.TAX[row_ind]/100);
					'attributes.other_money_#row_ind#' = get_ship_rows.OTHER_MONEY[row_ind];
					'attributes.other_money_value_#row_ind#' = get_ship_rows.OTHER_MONEY_VALUE[row_ind];
					'attributes.other_money_gross_total#row_ind#' = get_ship_rows.OTHER_MONEY_VALUE[row_ind] + (get_ship_rows.OTHER_MONEY_VALUE[row_ind]*get_ship_rows.TAX[row_ind]/100);
				}
				'form.row_taxtotal#row_ind#' = evaluate('attributes.row_taxtotal#row_ind#');
				'attributes.price_cat#row_ind#'=get_ship_rows.PRICE_CAT[row_ind];
				'attributes.product_account_code#row_ind#'='';
				'attributes.promosyon_maliyet#row_ind#'=get_ship_rows.PROM_COST[row_ind];
				'attributes.promosyon_yuzde#row_ind#'=get_ship_rows.PROM_COMISSION[row_ind];
				'attributes.prom_relation_id#row_ind#'=get_ship_rows.PROM_RELATION_ID[row_ind];
				'attributes.prom_stock_id#row_ind#'=get_ship_rows.PROM_STOCK_ID[row_ind];
				'attributes.row_promotion_id#row_ind#'=get_ship_rows.PROM_ID[row_ind];
				'attributes.row_service_id#row_ind#'='';
				'attributes.row_unique_relation_id#row_ind#'=get_ship_rows.UNIQUE_RELATION_ID[row_ind];
				'attributes.shelf_number#row_ind#'=get_ship_rows.SHELF_NUMBER[row_ind];
				'attributes.spect_id#row_ind#'=get_ship_rows.SPECT_VAR_ID[row_ind];
				'attributes.spect_name#row_ind#'=get_ship_rows.SPECT_VAR_NAME[row_ind];
				'attributes.stock_id#row_ind#'=get_ship_rows.STOCK_ID[row_ind];
				'attributes.unit#row_ind#'=get_ship_rows.UNIT[row_ind];
				'attributes.unit_id#row_ind#'=get_ship_rows.UNIT_ID[row_ind];
				'attributes.unit_other#row_ind#'=get_ship_rows.UNIT2[row_ind];
				'attributes.basket_employee_id#row_ind#'=get_ship_rows.BASKET_EMPLOYEE_ID[row_ind];
				'attributes.basket_extra_info#row_ind#'=get_ship_rows.BASKET_EXTRA_INFO_ID[row_ind];
				'attributes.detail_info_extra#row_ind#'=get_ship_rows.DETAIL_INFO_EXTRA[row_ind];
				'attributes.select_info_extra#row_ind#'=get_ship_rows.SELECT_INFO_EXTRA[row_ind];
				'attributes.row_ship_id#row_ind#'="#get_ship_rows.SHIP_ID[row_ind]#;#session.ep.period_id#";
				if(isdefined('session.pp.userid'))
					'attributes.wrk_row_id#row_ind#'="#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.pp.userid##round(rand()*100)#";
				else if(isdefined('session.ww.userid'))
					'attributes.wrk_row_id#row_ind#'="#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ww.userid##round(rand()*100)#";
				else
					'attributes.wrk_row_id#row_ind#'="#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)#";
				'attributes.wrk_row_relation_id#row_ind#'=get_ship_rows.WRK_ROW_ID[row_ind];
				attributes.rows_ = row_ind;
			</cfscript>
		</cfloop>
		<cfscript>
			for(ind_inv_row=1;ind_inv_row lte attributes.rows_;ind_inv_row=ind_inv_row+1)
			{
				//fatura altı indirim varsa ona hesaplanarak satırlara yansıtılıyor
				row_price_=get_ship_rows.PRICE[ind_inv_row]*get_ship_rows.AMOUNT[ind_inv_row];
				tmp_tax=0;
				for(ind_tax_count=1;ind_tax_count lte xml_tax_count;ind_tax_count=ind_tax_count+1)
				{
					if(isdefined('form.basket_tax_#ind_tax_count#') and len(evaluate('form.basket_tax_#ind_tax_count#')) and evaluate('form.basket_tax_#ind_tax_count#') eq evaluate('attributes.tax#ind_inv_row#'))
					{
						'form.basket_tax_value_#ind_tax_count#' =evaluate('form.basket_tax_value_#ind_tax_count#') + wrk_round((row_price_/100)*get_ship_rows.TAX[ind_inv_row],2);
						tmp_tax=1;
						break;
					}
				}
				if(tmp_tax eq 0)
				{
					'form.basket_tax_#xml_tax_count#' = evaluate('attributes.tax#ind_inv_row#');
					'form.basket_tax_value_#xml_tax_count#' =  wrk_round((row_price_/100)*get_ship_rows.TAX[ind_inv_row],2);
					xml_tax_count=xml_tax_count+1;
				}
				tmp_otv=0;
				for(ind_otv_count=1;ind_otv_count lte xml_otv_count;ind_otv_count=ind_otv_count+1)
				{
					if(isdefined('form.basket_otv_#ind_otv_count#') and evaluate('form.basket_otv_#ind_otv_count#') eq evaluate('attributes.otv_oran#ind_inv_row#'))
					{
						'form.basket_otv_value_#ind_otv_count#'= evaluate('form.basket_otv_value_#ind_otv_count#') + wrk_round((row_price_/100)*get_ship_rows.OTV_ORAN[ind_inv_row],2);
						tmp_otv=1;
						break;
					}
				}
				if(tmp_otv eq 0)	
				{
					'form.basket_otv_#xml_otv_count#'= evaluate('attributes.otv_oran#ind_inv_row#');
					'form.basket_otv_value_#xml_otv_count#'= wrk_round((row_price_/100)*get_ship_rows.OTV_ORAN[ind_inv_row],2);
					xml_otv_count=xml_otv_count+1;
				}
			}
		</cfscript>
		<cfscript>
			form.basket_otv_count = xml_otv_count-1;//otv oran sayısı
			form.basket_tax_count = xml_tax_count-1;//kdv sayısı
		</cfscript>
		<cfset xml_import=2>
		<cfset is_from_function=1>
		<cfset is_from_ship_action=1>
		<cfinclude template="../../invoice/query/add_invoice_sale.cfm">
		<cfscript>
			for (i=1;i lte form.basket_tax_count;i=i+1)
			{
				'form.basket_tax_#i#'= '';
			}
		</cfscript>
		<cfreturn 1>
	</cffunction>

<!---add_ship_from_order --->
<!--- Toplu Sevkiyattan Irsaliye Olusturmak Icin Kullaniliyor FBS --->
	<cffunction name="add_ship_from_order" returntype="boolean" output="true">
		<cfargument name="order_id" type="numeric">
		<cfargument name="order_wrk_row_id_list" type="string">
		<cfargument name="process_catid" required="yes" type="string">
		<cfargument name="ship_result_id" required="yes" type="string">
		<cfargument name="x_ship_group_dept" required="yes" type="string">
		<cfargument name="cari_db" type="string" default="#dsn2#">
		<cfif not isdefined("butceci")>
			<cfinclude template="get_butceci.cfm">
		</cfif>
		<cfif not isdefined("carici")>
			<cfinclude template="get_carici.cfm">
		</cfif>
		<cfif not isdefined("muhasebeci")>
			<cfinclude template="get_muhasebeci.cfm">
		</cfif>
		<cfif not isdefined("get_consumer_period")>
			<cfinclude template="get_user_accounts.cfm">
		</cfif>
		<cfif not isdefined("basket_kur_ekle")>
			<cfinclude template="get_basket_money_js.cfm">
		</cfif>
		<cfif not isdefined("add_order_row_reserved_stock")>
			<cfinclude template="add_order_row_reserved_stock.cfm">
		</cfif>
		<cfif not isdefined("add_reserve_row")>
			<cfinclude template="add_relation_rows.cfm">
		</cfif>
		<cfif not isdefined("add_stock_rows")>
			<cfinclude template="add_stock_rows.cfm">
		</cfif>
		<cfset function_off = 1>
	
		<cfset List_Wrk_Row_Id = "">
		<cfif isdefined("arguments.order_id") and Len(arguments.order_id)>
			<cfquery name="get_order_detail" datasource="#arguments.cari_db#">
				SELECT * FROM #dsn3_alias#.ORDERS WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_id#">
			</cfquery>
			<cfquery name="get_order_rows" datasource="#arguments.cari_db#">
				SELECT * FROM #dsn3_alias#.ORDER_ROW WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_id#">
			</cfquery>
		<cfelseif isdefined("arguments.order_wrk_row_id_list") and Len(arguments.order_wrk_row_id_list)>
			<cfloop list="#ListDeleteDuplicates(arguments.order_wrk_row_id_list)#" delimiters=";" index="w">
				<cfset List_Wrk_Row_Id = ListAppend(List_Wrk_Row_Id,ListFirst(w,'_'),',')>
			</cfloop>
			<cfif Len(List_Wrk_Row_Id)>
				<cfquery name="Get_Order_Details" datasource="#arguments.cari_db#">
					SELECT
						1 TYPE,
						<cfif isdefined("arguments.x_ship_group_dept") and arguments.x_ship_group_dept eq 1><!--- depo bazında gruplama seçiliyse --->
							'1_' + CAST(ISNULL(O.COMPANY_ID,0) AS NVARCHAR(10))+ '_' + CAST(ISNULL(O.PROJECT_ID,0) AS NVARCHAR(10)) + '_' +  CAST(ISNULL(O.COUNTY_ID,0) AS NVARCHAR(10))+ '_' +  CAST(ISNULL(ISNULL(OW.DELIVER_DEPT,O.DELIVER_DEPT_ID),0) AS NVARCHAR(10))+ '_' +  CAST(ISNULL(ISNULL(OW.DELIVER_LOCATION,O.LOCATION_ID),0) AS NVARCHAR(10)) MEMBER_ID,
						<cfelse>
							'1_' + CAST(ISNULL(O.COMPANY_ID,0) AS NVARCHAR(10))+ '_' + CAST(ISNULL(O.PROJECT_ID,0) AS NVARCHAR(10)) + '_' +  CAST(ISNULL(O.COUNTY_ID,0) AS NVARCHAR(10)) MEMBER_ID,
						</cfif>
						(SELECT IS_INVENTORY FROM #dsn3_alias#.STOCKS STOCKS WHERE OW.STOCK_ID = STOCK_ID) IS_INVENTORY,
						(SELECT IS_PRODUCTION FROM #dsn3_alias#.STOCKS STOCKS WHERE OW.STOCK_ID = STOCK_ID) IS_PRODUCTION,
						(SELECT PACKAGE_CONTROL_TYPE FROM #dsn1_alias#.PRODUCT WHERE PRODUCT_ID = OW.PRODUCT_ID) CONTROL_TYPE,
						O.SHIP_ADDRESS MULTISHIP_ADDRESS,
						OW.OTHER_MONEY_VALUE ROW_OTHER_MONEY_VALUE,
						OW.OTHER_MONEY ROW_OTHER_MONEY,
						OW.TAX ROW_TAX,
						OW.NETTOTAL ROW_NETTOTAL,
						*					
					FROM
						#dsn3_alias#.ORDERS O,
						#dsn3_alias#.ORDER_ROW OW
					WHERE
						OW.ORDER_ID = O.ORDER_ID AND
						O.CONSUMER_ID IS NULL AND
						<cfif isdefined("attributes.no_send_stock_id_list") and len(attributes.no_send_stock_id_list)>
							OW.STOCK_ID NOT IN (#attributes.no_send_stock_id_list#) AND
						</cfif>
						<cfif isdefined("attributes.no_send_ship_wrk_row_list") and len(attributes.no_send_ship_wrk_row_list)>
							<!--- Burasi kaldirilabilir, simdilik kalsin 20100129 --->
							OW.WRK_ROW_ID NOT IN (#ListQualify(attributes.no_send_ship_wrk_row_list,"'",",","all")#) AND
						</cfif>
						OW.WRK_ROW_ID IN (#ListQualify(List_Wrk_Row_Id,"'",",","all")#)
	
					UNION ALL
	
					SELECT
						2 TYPE,
						<cfif isdefined("arguments.x_ship_group_dept") and arguments.x_ship_group_dept eq 1><!--- depo bazında gruplama seçiliyse --->
							'2_' + CAST(ISNULL(O.CONSUMER_ID,0) AS NVARCHAR(10))+ '_' + CAST(ISNULL(O.PROJECT_ID,0) AS NVARCHAR(10)) + '_' +  CAST(ISNULL(O.COUNTY_ID,0) AS NVARCHAR(10))+ '_' +  CAST(ISNULL(ISNULL(OW.DELIVER_DEPT,O.DELIVER_DEPT_ID),0) AS NVARCHAR(10))+ '_' +  CAST(ISNULL(ISNULL(OW.DELIVER_LOCATION,O.LOCATION_ID),0) AS NVARCHAR(10)) MEMBER_ID,
						<cfelse>
							'2_' + CAST(ISNULL(O.CONSUMER_ID,0) AS NVARCHAR(10))+ '_' + CAST(ISNULL(O.PROJECT_ID,0) AS NVARCHAR(10)) + '_' +  CAST(ISNULL(O.COUNTY_ID,0) AS NVARCHAR(10)) MEMBER_ID,
						</cfif>
						(SELECT IS_INVENTORY FROM #dsn3_alias#.STOCKS STOCKS WHERE OW.STOCK_ID = STOCK_ID) IS_INVENTORY,
						(SELECT IS_PRODUCTION FROM #dsn3_alias#.STOCKS STOCKS WHERE OW.STOCK_ID = STOCK_ID) IS_PRODUCTION,
						(SELECT PACKAGE_CONTROL_TYPE FROM #dsn1_alias#.PRODUCT WHERE PRODUCT_ID = OW.PRODUCT_ID) CONTROL_TYPE,
						O.SHIP_ADDRESS MULTISHIP_ADDRESS,
						OW.OTHER_MONEY_VALUE ROW_OTHER_MONEY_VALUE,
						OW.OTHER_MONEY ROW_OTHER_MONEY,
						OW.TAX ROW_TAX,
						OW.NETTOTAL ROW_NETTOTAL,
						*					
					FROM
						#dsn3_alias#.ORDERS O,
						#dsn3_alias#.ORDER_ROW OW
					WHERE
						OW.ORDER_ID = O.ORDER_ID AND
						O.COMPANY_ID IS NULL AND
						<cfif isdefined("attributes.no_send_stock_id_list") and len(attributes.no_send_stock_id_list)>
							OW.STOCK_ID NOT IN (#attributes.no_send_stock_id_list#) AND
						</cfif>
						OW.WRK_ROW_ID IN (#ListQualify(List_Wrk_Row_Id,"'",",","all")#)
					ORDER BY
						TYPE,
						MEMBER_ID
				</cfquery>
				<cfquery name="Get_Ship_Result_Info" datasource="#arguments.cari_db#">
					SELECT
						SR.DEPARTMENT_ID,
						SR.LOCATION_ID,
						SR.SHIP_METHOD_TYPE,
						SR.MAIN_SHIP_FIS_NO,
						SR.DELIVERY_DATE,
						DTP.TEAM_CODE
					FROM
						#dsn2_alias#.SHIP_RESULT SR,
						#dsn3_alias#.DISPATCH_TEAM_PLANNING DTP
					WHERE
						SR.EQUIPMENT_PLANNING_ID = DTP.PLANNING_ID AND
						SR.SHIP_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ship_result_id#">
				</cfquery>
			<cfelse>
				Eksik Parametre Girişi !!!
			</cfif>
		<cfelse>
			Eksik Parametre Girişi !!!
			<cfabort>
		</cfif>
		
		<cfset row_ind = 0>
		<!--- order_id_listesi bu siparis irsaliye iliskileri saglanirken irsaliye querysindeki function i calistirmak icin gerekli --->
		<cfset attributes.order_id_listesi = ListSort(ListDeleteDuplicates(ValueList(Get_Order_Details.Order_Id,",")),"numeric","asc",",")>
		<cfoutput query="Get_Order_Details" group="Member_Id">
			<cf_papers paper_type = "ship">
			<cfif len(Get_Order_Details.member_id) and Get_Order_Details.type eq 1>
				<cfquery name="get_member_id" datasource="#arguments.cari_db#">
					SELECT
						COMPANY.COMPANY_ID,
						ISNULL(COMPANY.MANAGER_PARTNER_ID,(SELECT TOP 1 PARTNER_ID FROM #dsn_alias#.COMPANY_PARTNER WHERE COMPANY_ID=COMPANY.COMPANY_ID)) PARTNER_ID,
						COMPANY_PERIOD.ACCOUNT_CODE
					FROM 
						#dsn_alias#.COMPANY,
						#dsn_alias#.COMPANY_PERIOD
					WHERE
						COMPANY.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(Get_Order_Details.Member_Id,2,'_')#"> AND
						COMPANY_PERIOD.COMPANY_ID = COMPANY.COMPANY_ID AND
						COMPANY_PERIOD.PERIOD_ID = <cfif isdefined("session.ep")><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.period_id#"></cfif>
				</cfquery>
			<cfelse>
				<cfquery name="get_member_id" datasource="#arguments.cari_db#">
					SELECT
						CONSUMER.CONSUMER_ID,
						CONSUMER_PERIOD.ACCOUNT_CODE
					FROM 
						#dsn_alias#.CONSUMER,
						#dsn_alias#.CONSUMER_PERIOD
					WHERE 
						CONSUMER.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(Get_Order_Details.Member_Id,2,'_')#"> AND
						CONSUMER.CONSUMER_ID = CONSUMER_PERIOD.CONSUMER_ID AND
						CONSUMER_PERIOD.PERIOD_ID = <cfif isdefined("session.ep")><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.period_id#"></cfif>
				</cfquery>
			</cfif>
			<cfquery name="get_money" datasource="#arguments.cari_db#">
				SELECT RATE2,RATE1,MONEY_TYPE FROM #dsn3_alias#.ORDER_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Order_Details.Order_Id#">
			</cfquery>
			<cfquery name="get_money_selected" datasource="#arguments.cari_db#">
				SELECT RATE2,RATE1,MONEY_TYPE FROM #dsn3_alias#.ORDER_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Order_Details.Order_Id#"> AND IS_SELECTED = 1
			</cfquery>
			<cfscript>
				topla_basket_gross_total = 0;
				topla_basket_net_total = 0;
				topla_basket_discount_total = 0;
				topla_basket_tax_total = 0;
				topla_basket_otv_total = 0;
				
				form.sale_product=1;
				attributes.paper_number = paper_number;
				attributes.ship_number = '#paper_code#-#paper_number#';
				form.ship_number='#paper_code#-#paper_number#';
				ship_number='#paper_code#-#paper_number#';
				attributes.order_id = Get_Order_Details.Order_Id;
				attributes.process_cat=arguments.process_catid;
				form.process_cat=arguments.process_catid;
				get_process_type.IS_STOCK_ACTION=1;
				'ct_process_type_#arguments.process_catid#'=arguments.process_catid;
				if(isdefined("arguments.x_ship_group_dept") and arguments.x_ship_group_dept eq 1)//depo bazında gruplama seçili ise
				{
					if(ListGetAt(Get_Order_Details.Member_Id,5,'_') neq 0)
					{
						attributes.department_id=ListGetAt(Get_Order_Details.Member_Id,5,'_');
						attributes.location_id=ListGetAt(Get_Order_Details.Member_Id,6,'_');
					}
					else
					{
						attributes.department_id=Get_Ship_Result_Info.Department_Id;
						attributes.location_id=Get_Ship_Result_Info.Location_Id;
					}
				}
				else
				{
					attributes.department_id=Get_Ship_Result_Info.Department_Id;
					attributes.location_id=Get_Ship_Result_Info.Location_Id;
				}
				attributes.ship_method=Get_Ship_Result_Info.Ship_Method_Type;
				attributes.ref_no = Get_Ship_Result_Info.Team_Code;
	
				if(len(Get_Order_Details.Member_Id) and Get_Order_Details.Type eq 1)
				{
					attributes.company_id=ListGetAt(Get_Order_Details.Member_Id,2,'_');
					attributes.comp_name='a';
					attributes.partner_id=Get_Order_Details.partner_id;
					attributes.partner_name='b';
					attributes.consumer_id='';
				}
				else
				{
					attributes.company_id='';
					attributes.comp_name='a';
					attributes.partner_id='';
					attributes.partner_name='b';
					attributes.consumer_id=ListGetAt(Get_Order_Details.Member_Id,2,'_');
				}
				attributes.consumer_reference_code=Get_Order_Details.CONSUMER_REFERENCE_CODE;
				attributes.partner_reference_code=Get_Order_Details.PARTNER_REFERENCE_CODE;
				
				if(isdefined("attributes.ship_out_date") and isdate(attributes.ship_out_date))
					attributes.ship_date=dateformat(attributes.ship_out_date,'dd/mm/yyyy');
				else
					attributes.ship_date=dateformat(Get_Order_Details.ORDER_DATE,'dd/mm/yyyy');
				
				if(Len(Get_Ship_Result_Info.Delivery_Date) and isDate(Get_Ship_Result_Info.Delivery_Date))
					attributes.deliver_date_frm=dateformat(Get_Ship_Result_Info.Delivery_Date,'dd/mm/yyyy');
				else if(isdefined("attributes.ship_out_date") and isdate(attributes.ship_out_date))
					attributes.deliver_date_frm=dateformat(attributes.ship_out_date,'dd/mm/yyyy');
				else
					attributes.deliver_date_frm=dateformat(Get_Order_Details.ORDER_DATE,'dd/mm/yyyy');
	
				attributes.kasa='';
				kasa='';
				attributes.member_account_code=GET_MEMBER_ID.ACCOUNT_CODE;
				note=Get_Order_Details.ORDER_DETAIL;
				attributes.city_id=Get_Order_Details.CITY_ID;
				attributes.county_id=Get_Order_Details.COUNTY_ID;
				attributes.adres=Get_Order_Details.MULTISHIP_ADDRESS;
				adres = Get_Order_Details.MULTISHIP_ADDRESS;
				for(stp_mny=1;stp_mny lte GET_MONEY.RECORDCOUNT;stp_mny=stp_mny+1)
				{
					'attributes.hidden_rd_money_#stp_mny#'=GET_MONEY.MONEY_TYPE[stp_mny];
					'attributes.txt_rate1_#stp_mny#'=GET_MONEY.RATE1[stp_mny];	
					'attributes.txt_rate2_#stp_mny#'=GET_MONEY.RATE2[stp_mny];
				}
				form.basket_money=GET_MONEY_SELECTED.MONEY_TYPE;
				attributes.basket_money=GET_MONEY_SELECTED.MONEY_TYPE;
				form.basket_rate1=GET_MONEY_SELECTED.RATE1;
				form.basket_rate2=GET_MONEY_SELECTED.RATE2;
				attributes.kur_say=GET_MONEY.RECORDCOUNT;
				if(Get_Order_Details.purchase_sales eq 0 and Get_Order_Details.order_zone eq 0)//alis
				{
					attributes.basket_id = 11;
					attributes.form_add = 1;
					attributes.basket_sub_id = 4;
				}
				else //satis
				{
					attributes.basket_id = 10;
					attributes.form_add = 1;
				}
				attributes.list_payment_row_id='';
				attributes.subscription_id='';
				attributes.ship_counter_number='';
				attributes.commethod_id='';
				attributes.bool_from_control_bill='';
				attributes.invoice_control_id='';
				attributes.contract_row_ids='';
				attributes.card_paymethod_id=Get_Order_Details.CARD_PAYMETHOD_ID;
				attributes.commission_rate=Get_Order_Details.CARD_PAYMETHOD_RATE;
				attributes.paymethod_id=Get_Order_Details.PAYMETHOD;
				attributes.project_id=Get_Order_Details.PROJECT_ID;
				attributes.project_head='aa';
				EMPO_ID=Get_Order_Details.ORDER_EMPLOYEE_ID;
				PARTO_ID=Get_Order_Details.SALES_PARTNER_ID;
				form.deliver_get='';		
					
				inventory_product_exists = 0;
				attributes.yuvarlama='';
				attributes.tevkifat_oran=0;
				attributes.is_general_prom=0;
				attributes.indirim_total='100000000000000000000,100000000000000000000';
				attributes.general_prom_limit='';
				attributes.general_prom_discount='';
				attributes.general_prom_amount=0;
				attributes.free_prom_limit='';
				attributes.flt_net_total_all=0;
				attributes.currency_multiplier = '';
				attributes.basket_member_pricecat='';
				attributes.basket_due_value_date_=dateformat(Get_Order_Details.DUE_DATE,'dd/mm/yyyy');
				attributes.BASKET_PRICE_ROUND_NUMBER = 4;
				
				xml_tax_count=1;//kdv sayısı
				xml_otv_count=1;//otv sayısı
			</cfscript>
			
			<cfset row_info = 0>
			<cfoutput><!--- CfOutput Group Icin Kullanilan 2. Output Silinmesin !!! --->
				<cfset row_ind = row_ind + 1>
				<cfset row_info = row_info + 1>
				<!--- Miktarlar Sevkiyattan Gonderiliyor --->
				<cfset OrderWrkRowId  = Get_Order_Details.wrk_row_id[row_ind]>
				<cfloop list="#ListDeleteDuplicates(arguments.order_wrk_row_id_list)#" delimiters=";" index="xx">
					<!--- Compare text ifadeleri karsilastirmak icin kullaniliyor, listfind gibi --->
					<cfif compare(ListFirst(xx,'_'),OrderWrkRowId) eq 0>
						<cfset 'attributes.amount#row_info#'= ListLast(xx,'_')>
					</cfif>
				</cfloop>
	
				<cfscript>
					price_round_number = 4; //duzenlenecekkkkkkkkkkkkkk
					/* Burasi siparisleri getiriyordu, kaldirildi, ekip bilgileri gelecek sekilde duzenlendi fbs 20100223
					if(not ListFind(attributes.ref_no,Get_Order_Details.ORDER_NUMBER,',')) 
						attributes.ref_no = attributes.ref_no & ',' & Get_Order_Details.ORDER_NUMBER;
					*/
					'attributes.deliver_date#row_info#'=Get_Order_Details.DELIVER_DATE[row_ind];
					'attributes.deliver_dept#row_info#'=""; //Get_Order_Details.DELIVER_DEPT[row_ind]
					'attributes.duedate#row_info#'=Get_Order_Details.DUEDATE[row_ind];
					'attributes.ek_tutar#row_info#'=Get_Order_Details.EK_TUTAR_PRICE[row_ind];
					if(len(Get_Order_Details.EXTRA_PRICE_TOTAL[row_ind])) 'attributes.ek_tutar_total#row_info#'=Get_Order_Details.EXTRA_PRICE_TOTAL[row_ind]; else 'attributes.ek_tutar_total#row_info#'=0;
					if(len(Get_Order_Details.EXTRA_PRICE_OTHER_TOTAL[row_ind])) 'attributes.ek_tutar_other_total#row_info#'=Get_Order_Details.EXTRA_PRICE_OTHER_TOTAL[row_ind]; else 'attributes.ek_tutar_other_total#row_info#'=0;
					if(Len(Get_Order_Details.ROW_TAX[row_ind]))
					{
						'attributes.tax#row_info#'=Get_Order_Details.ROW_TAX[row_ind];
						'attributes.tax_percent#row_info#'=Get_Order_Details.ROW_TAX[row_ind];
					}
					else
					{
						'attributes.tax#row_info#' = 0;
						'attributes.tax_percent#row_info#' = 0;
					}
					'attributes.row_unique_relation_id#row_info#'=Get_Order_Details.UNIQUE_RELATION_ID[row_ind];
					'attributes.shelf_number#row_info#'=Get_Order_Details.SHELF_NUMBER[row_ind];
					'attributes.spect_id#row_info#'=Get_Order_Details.SPECT_VAR_ID[row_ind];
					'attributes.spect_name#row_info#'=Get_Order_Details.SPECT_VAR_NAME[row_ind];
					'attributes.stock_id#row_info#'=Get_Order_Details.STOCK_ID[row_ind];
					'attributes.unit#row_info#'=Get_Order_Details.UNIT[row_ind];
					'attributes.unit_id#row_info#'=Get_Order_Details.UNIT_ID[row_ind];
					'attributes.price_cat#row_info#'=Get_Order_Details.PRICE_CAT[row_ind];
					'attributes.unit_other#row_info#'=Get_Order_Details.UNIT2[row_ind];
					'attributes.basket_employee_id#row_info#'=Get_Order_Details.BASKET_EMPLOYEE_ID[row_ind];
					'attributes.basket_extra_info#row_info#'=Get_Order_Details.BASKET_EXTRA_INFO_ID[row_ind];
					'attributes.detail_info_extra#row_info#'=Get_Order_Details.DETAIL_INFO_EXTRA[row_ind];
					'attributes.select_info_extra#row_info#'=Get_Order_Details.SELECT_INFO_EXTRA[row_ind];
					'attributes.row_promotion_id#row_info#'=Get_Order_Details.PROM_ID[row_ind];
					'attributes.row_service_id#row_info#'='';
					
					'attributes.extra_cost#row_info#'=Get_Order_Details.EXTRA_COST[row_ind];
					'attributes.indirim1#row_info#'=Get_Order_Details.DISCOUNT_1[row_ind];
					'attributes.indirim2#row_info#'=Get_Order_Details.DISCOUNT_2[row_ind];
					'attributes.indirim3#row_info#'=Get_Order_Details.DISCOUNT_3[row_ind];
					'attributes.indirim4#row_info#'=Get_Order_Details.DISCOUNT_4[row_ind];
					'attributes.indirim5#row_info#'=Get_Order_Details.DISCOUNT_5[row_ind];
					'attributes.indirim6#row_info#'=Get_Order_Details.DISCOUNT_6[row_ind];
					'attributes.indirim7#row_info#'=Get_Order_Details.DISCOUNT_7[row_ind];
					'attributes.indirim8#row_info#'=Get_Order_Details.DISCOUNT_8[row_ind];
					'attributes.indirim9#row_info#'=Get_Order_Details.DISCOUNT_9[row_ind];
					'attributes.indirim10#row_info#'=Get_Order_Details.DISCOUNT_10[row_ind];
					'attributes.indirim_carpan#row_info#' = (100-Evaluate('attributes.indirim1#row_info#')) * (100-Evaluate('attributes.indirim2#row_info#')) * (100-Evaluate('attributes.indirim3#row_info#')) * (100-Evaluate('attributes.indirim4#row_info#')) * (100-Evaluate('attributes.indirim5#row_info#')) * (100-Evaluate('attributes.indirim6#row_info#')) * (100-Evaluate('attributes.indirim7#row_info#')) * (100-Evaluate('attributes.indirim8#row_info#')) * (100-Evaluate('attributes.indirim9#row_info#')) * (100-Evaluate('attributes.indirim10#row_info#'));
					
					
					'attributes.iskonto_tutar#row_info#'=Get_Order_Details.DISCOUNT_COST[row_ind];
					'attributes.is_commission#row_info#'=Get_Order_Details.IS_COMMISSION[row_ind];
					'attributes.is_inventory#row_info#'=Get_Order_Details.is_inventory;
					if(Get_Order_Details.is_inventory)	inventory_product_exists = 1;
					'attributes.is_production#row_info#'=Get_Order_Details.IS_PRODUCTION;
		
					'attributes.is_promotion#row_info#'=Get_Order_Details.IS_PROMOTION[row_ind];
					'attributes.karma_product_id#row_info#'=Get_Order_Details.KARMA_PRODUCT_ID[row_ind];
					if(Len(Get_Order_Details.LIST_PRICE[row_ind])) 'attributes.list_price#row_info#'=Get_Order_Details.LIST_PRICE[row_ind]; else 'attributes.list_price#row_info#'= Get_Order_Details.PRICE[row_ind];
					'attributes.lot_no#row_info#'=Get_Order_Details.LOT_NO[row_ind];
					'attributes.manufact_code#row_info#'=Get_Order_Details.PRODUCT_MANUFACT_CODE[row_ind];
					'attributes.marj#row_info#'=Get_Order_Details.MARJ[row_ind];
					'attributes.net_maliyet#row_info#'=Get_Order_Details.COST_PRICE[row_ind];
					'attributes.number_of_installment#row_info#'=Get_Order_Details.NUMBER_OF_INSTALLMENT[row_ind];
					'attributes.order_currency#row_info#'=Get_Order_Details.ORDER_ROW_CURRENCY[row_ind];
					'attributes.product_account_code#row_info#'='';
					'attributes.product_id#row_info#'=Get_Order_Details.PRODUCT_ID[row_ind];
					'attributes.product_name#row_info#'=Get_Order_Details.PRODUCT_NAME[row_ind];
					'attributes.product_name_other#row_info#'=Get_Order_Details.PRODUCT_NAME2[row_ind];
					'attributes.promosyon_maliyet#row_info#'=Get_Order_Details.PROM_COST[row_ind];
					'attributes.promosyon_yuzde#row_info#'=Get_Order_Details.PROM_COMISSION[row_ind];
					'attributes.prom_relation_id#row_info#'=Get_Order_Details.PROM_RELATION_ID[row_ind];
					'attributes.prom_stock_id#row_info#'=Get_Order_Details.PROM_STOCK_ID[row_ind];
					'attributes.reserve_date#row_info#'=Get_Order_Details.RESERVE_DATE[row_ind];
					'attributes.reserve_type#row_info#'=Get_Order_Details.RESERVE_TYPE[row_ind];
	
					'attributes.otv_oran#row_info#'=Get_Order_Details.OTV_ORAN[row_ind];
					'attributes.price#row_info#'=Get_Order_Details.PRICE[row_ind];
					'attributes.price_other#row_info#'=Get_Order_Details.PRICE_OTHER[row_ind];
					'attributes.other_money_#row_info#'=Get_Order_Details.ROW_OTHER_MONEY[row_ind];
					'attributes.row_total#row_info#'=(Evaluate('attributes.amount#row_info#') * Evaluate('attributes.price#row_info#')) + Evaluate('attributes.ek_tutar_total#row_info#');
					if(Len(Get_Order_Details.ROW_OTHER_MONEY_VALUE[row_ind]) and Get_Order_Details.ROW_OTHER_MONEY_VALUE[row_ind] gt 0)
						'attributes.other_money_value_#row_info#' = ((Get_Order_Details.ROW_OTHER_MONEY_VALUE[row_ind] / Get_Order_Details.QUANTITY[row_ind]) * Evaluate('attributes.amount#row_info#'));
					else
						'attributes.other_money_value_#row_info#'=0;
					'attributes.other_money_gross_total#row_info#'= Evaluate('attributes.other_money_value_#row_info#') + ((Evaluate('attributes.other_money_value_#row_info#')*Evaluate('attributes.tax_percent#row_info#'))/100);
	
					'attributes.row_nettotal#row_info#'= wrk_round((Evaluate('attributes.row_total#row_info#')/100000000000000000000)*Evaluate('attributes.indirim_carpan#row_info#'),price_round_number);
					'attributes.row_taxtotal#row_info#'=wrk_round(Evaluate('attributes.row_nettotal#row_info#')*(Evaluate('attributes.tax_percent#row_info#')/100),price_round_number);
					if(Get_Order_Details.OTVTOTAL[row_ind])
						'attributes.row_otvtotal#row_info#'=Get_Order_Details.OTVTOTAL[row_ind];
					else
						'attributes.row_otvtotal#row_info#' = 0;
						
					'attributes.row_lasttotal#row_info#'=(Evaluate('attributes.row_nettotal#row_info#') + Evaluate('attributes.row_taxtotal#row_info#')) + Evaluate('attributes.row_otvtotal#row_info#');
					
					topla_basket_gross_total = topla_basket_gross_total + Evaluate('attributes.row_total#row_info#');
					topla_basket_net_total = topla_basket_net_total + Evaluate('attributes.row_nettotal#row_info#');
					topla_basket_discount_total = topla_basket_discount_total + (wrk_round(Evaluate('attributes.row_total#row_info#'),price_round_number) - wrk_round(Evaluate('attributes.row_nettotal#row_info#'),price_round_number));
	
					//Onemli Wrk_vb Kontrolleri
					'attributes.row_ship_id#row_info#'=Get_Order_Details.ORDER_ID[row_ind];
					if(isdefined('session.pp.userid'))
						'attributes.wrk_row_id#row_info#'="WRK#row_ind##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.pp.userid##round(rand()*100)##row_ind#";
					else if(isdefined('session.ww.userid'))
						'attributes.wrk_row_id#row_info#'="WRK#row_ind##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ww.userid##round(rand()*100)##row_ind#";
					else
						'attributes.wrk_row_id#row_info#'="WRK#row_ind##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##row_ind#";
					'attributes.wrk_row_relation_id#row_info#'=Get_Order_Details.WRK_ROW_ID[row_ind];
					attributes.rows_ = row_info;
				</cfscript>
				<cfscript>
					for(ind_shp_row=1;ind_shp_row lte attributes.rows_;ind_shp_row=ind_shp_row+1)
					{
						//fatura altı indirim varsa ona hesaplanarak satırlara yansıtılıyor
						row_price_=Get_Order_Details.PRICE[ind_shp_row]*Get_Order_Details.QUANTITY[ind_shp_row];
						tmp_tax=0;
						for(ind_tax_count=1;ind_tax_count lte xml_tax_count;ind_tax_count=ind_tax_count+1)
						{
							if(isdefined('form.basket_tax_#ind_tax_count#') and evaluate('form.basket_tax_#ind_tax_count#') eq evaluate('attributes.tax#ind_shp_row#'))
							{
								'form.basket_tax_value_#ind_tax_count#' =evaluate('form.basket_tax_value_#ind_tax_count#') + wrk_round((row_price_/100)*Get_Order_Details.ROW_TAX[ind_shp_row],2);
								topla_basket_tax_total = topla_basket_tax_total + Evaluate('form.basket_tax_value_#ind_tax_count#');
								tmp_tax=1;
								break;
							}
						}
						if(tmp_tax eq 0)
						{
							'form.basket_tax_#xml_tax_count#' = evaluate('attributes.tax#ind_shp_row#');
							'form.basket_tax_value_#xml_tax_count#' =  wrk_round((row_price_/100)*Get_Order_Details.ROW_TAX[ind_shp_row],2);
							topla_basket_tax_total = topla_basket_tax_total + Evaluate('form.basket_tax_value_#xml_tax_count#');
							xml_tax_count=xml_tax_count+1;
						}
						tmp_otv=0;
						for(ind_otv_count=1;ind_otv_count lte xml_otv_count;ind_otv_count=ind_otv_count+1)
						{
							if(isdefined('form.basket_otv_#ind_otv_count#') and evaluate('form.basket_otv_#ind_otv_count#') eq evaluate('attributes.otv_oran#ind_shp_row#'))
							{
								'form.basket_otv_value_#ind_otv_count#'= evaluate('form.basket_otv_value_#ind_otv_count#') + wrk_round((row_price_/100)*Get_Order_Details.OTV_ORAN[ind_shp_row],2);
								topla_basket_otv_total = topla_basket_otv_total + Evaluate('form.basket_otv_value_#ind_otv_count#');
								tmp_otv=1;
								break;
							}
						}
						if(tmp_otv eq 0)	
						{
							'form.basket_otv_#xml_otv_count#'= evaluate('attributes.otv_oran#ind_shp_row#');
							'form.basket_otv_value_#xml_otv_count#'= wrk_round((row_price_/100)*Get_Order_Details.OTV_ORAN[ind_shp_row],2);
							topla_basket_otv_total = topla_basket_otv_total + Evaluate('form.basket_otv_value_#xml_otv_count#');
							xml_otv_count=xml_otv_count+1;
						}
					}
				</cfscript>
				<cfscript>
					//Son toplamlar
					form.genel_indirim=Get_Order_Details.SA_DISCOUNT;
					attributes.genel_indirim=Get_Order_Details.SA_DISCOUNT;
					form.basket_gross_total=topla_basket_gross_total;
					attributes.basket_gross_total=form.basket_gross_total;
					form.basket_net_total=topla_basket_net_total;
					attributes.basket_net_total=form.basket_net_total;
					form.basket_otv_total=topla_basket_otv_total;
					attributes.basket_otv_total=form.basket_otv_total;
					form.basket_tax_total=topla_basket_tax_total;
					attributes.basket_tax_total=form.basket_tax_total;
					attributes.basket_discount_total = topla_basket_discount_total;
					form.basket_discount_total = attributes.basket_discount_total;
		
					form.basket_otv_count = xml_otv_count-1;//otv oran sayısı
					form.basket_tax_count = xml_tax_count-1;//kdv sayısı
				</cfscript>
				
				<cfset xml_import=2>
				<cfif isdefined("session.ep")>
					<cfset form.active_period = session.ep.period_id>
					<cfset attributes.active_period = session.ep.period_id>
				<cfelse>
					<cfset form.active_period = session.pp.period_id>
					<cfset attributes.active_period = session.pp.period_id>
				</cfif>
				
				<cfquery name="Upd_Old_Currency" datasource="#arguments.cari_db#">
					UPDATE
						SHIP_RESULT_ROW
					SET
						OLD_ORDER_ROW_CURRENCY = #Get_Order_Details.ORDER_ROW_CURRENCY[row_ind]#
					WHERE
						SHIP_RESULT_ID = #arguments.ship_result_id# AND
						WRK_ROW_RELATION_ID = '#OrderWrkRowId#'
				</cfquery>
				<cfif Get_Order_Details.ORDER_ROW_CURRENCY[row_ind] eq -5>
					<!--- 
						Asama uretim ise sevk olarak update ediyoruz cunku, irsaliyelestirme yapilirken uretim asamasinda olusan satirlarin asama bilgileri degismiyor, 
						sevk gibi gerekirse kapatilmali ya da eksik, fazla teslimat degisimleri ile miktarlar da guncellenmeli kendisi otomatik olarak
					 --->
					<cfquery name="Upd_Order_Row_Currency" datasource="#arguments.cari_db#">
						UPDATE #dsn3_alias#.ORDER_ROW SET ORDER_ROW_CURRENCY = -6 WHERE ORDER_ROW_CURRENCY = -5 AND ORDER_ID = #Get_Order_Details.Order_Id# AND WRK_ROW_ID = '#Get_Order_Details.Wrk_Row_Id#' 
					</cfquery>
				</cfif>
			
				<!--- Bilesenleri Update Ediliyor --->
				<cfif Get_Order_Details.Control_Type eq 2 and Len(Get_Order_Details.Spect_Var_Id)>
					<cfquery name="Get_Spects_Row" datasource="#dsn2#">
						SELECT * FROM #dsn3_alias#.SPECTS_ROW WHERE SPECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Order_Details.Spect_Var_Id#"> AND IS_PROPERTY IN (0,4) AND STOCK_ID IS NOT NULL
					</cfquery>
					<cfloop query="Get_Spects_Row">
						<cfquery name="Upd_Ship_Result_Row_Component_Id" datasource="#arguments.cari_db#">
							UPDATE SHIP_RESULT_ROW_COMPONENT SET SHIP_RESULT_ROW_AMOUNT = #filterNum(Evaluate("attributes.spect_to_ship_amount_#Get_Order_Details.Wrk_Row_Id#_#Get_Spects_Row.Spect_Row_Id#"))# WHERE  SHIP_RESULT_ID = #arguments.ship_result_id# AND WRK_ROW_RELATION_ID = '#Get_Order_Details.Wrk_Row_Id#' AND COMPONENT_SPECT_ROW_ID = #Get_Spects_Row.Spect_Row_Id#
						</cfquery>
					</cfloop>
				</cfif>
				<!--- //Bilesenleri Update Ediliyor --->
	
			</cfoutput><!--- //CfOutput Group Icin Kullanilan 2. Output Silinmesin !!! --->
			
			<!--- Irsaliye Ekleme Querylerine Bulundugu Kosullara Uygun Geliyor --->
			<cfif Get_Order_Details.purchase_sales eq 0 and Get_Order_Details.order_zone eq 0>
				<!--- Alis --->
				<cfinclude template="../../stock/query/add_purchase.cfm">
			<cfelse>
				<!--- Satis --->
				<cfinclude template="../../stock/query/add_sale.cfm">
			</cfif>
			<cfif isdefined("MAX_ID") and len(MAX_ID.IDENTITYCOL)>
				<cfquery name="Get_Related_Ship_Row" datasource="#arguments.cari_db#">
					SELECT WRK_ROW_RELATION_ID,SHIP_ID,AMOUNT FROM SHIP_ROW WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">
				</cfquery>
				<cfloop query="Get_Related_Ship_Row">
					<cfquery name="Upd_Ship_Result_Row_Id" datasource="#arguments.cari_db#">
						UPDATE
							SHIP_RESULT_ROW
						SET
							SHIP_ID = #Get_Related_Ship_Row.Ship_Id#,
							SHIP_RESULT_ROW_AMOUNT = #Get_Related_Ship_Row.Amount#
						WHERE
							SHIP_RESULT_ID = #arguments.ship_result_id# AND
							WRK_ROW_RELATION_ID = '#Get_Related_Ship_Row.Wrk_Row_Relation_Id#'
					</cfquery>
				</cfloop>
			</cfif>
		</cfoutput>
		<cflocation url="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_upd_multi_packetship&main_ship_fis_no=#Get_Ship_Result_Info.Main_Ship_Fis_No#" addtoken="no">
		<cfreturn true> 
	</cffunction>

<!---add_relation_rows ---->
<!--- 
TEKLİF,SİPARİŞ,İRSALİYE VE FATURA BELGELERİNİN ARALARINDAKİ DÖNÜŞÜMLERDE KULLANILMAK ÜZERE YAZILDI,KOD KİRLİĞİĞİ ÖNLEMEK AÇISINDAN FONKSİYON İLE YAPILDI...
HANGİ BELGENİN "SATIRI" HANGİ BELGENİN SATIRI İLE İLİŞKİLİ OLDUĞUNU TUTAR...
M.ER 23 02 2009
--->
	<cffunction name="add_relation_rows" returntype="boolean" output="false">
		<cfargument name="action_type" type="string" required="yes" default="add"><!--- add or del --->
		<cfargument name="to_table" type="string" required="no">
		<cfargument name="from_table" type="string" required="no">
		<cfargument name="to_wrk_row_id" type="string" required="no">
		<cfargument name="from_wrk_row_id" type="string" required="no">
		<cfargument name="amount" type="numeric" required="no">
		<cfargument name="to_action_id" type="numeric" required="no">
		<cfargument name="from_action_id" type="numeric" required="no">
		<cfargument name="action_dsn" type="string" required="no" default="#dsn3#">
			<cfif arguments.action_type is 'add'>
				<cfquery name="ADD_PAPER_ROW_TO_PAPER_ROW" datasource="#action_dsn#">
					INSERT INTO 
					   #dsn3_alias#.RELATION_ROW
						(
							PERIOD_ID,
							TO_TABLE,
							FROM_TABLE,
							TO_WRK_ROW_ID,
							FROM_WRK_ROW_ID,
							TO_AMOUNT,
							TO_ACTION_ID,
							FROM_ACTION_ID
						)
						VALUES
						(
							#session.ep.period_id#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.to_table#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.from_table#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.to_wrk_row_id#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.from_wrk_row_id#">,
							#arguments.amount#,
							#arguments.to_action_id#,
							#arguments.from_action_id#
						)
				</cfquery>
			<cfelseif arguments.action_type is 'del'>
				<cfquery name="DEL_RELATION_PAPERS_ROW" datasource="#action_dsn#">
					DELETE FROM  #dsn3_alias#.RELATION_ROW WHERE TO_ACTION_ID = #arguments.to_action_id# AND TO_TABLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.to_table#"> AND
					<cfif isdefined('session.ep.period_id')>
						PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
					<cfelse>
						PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.period_id#">
					</cfif>
				</cfquery>
			</cfif>
		<cfreturn true>
	</cffunction>

<!---add_internaldemand_row_relation--->
<!--- İç talep belgelerinin (satır bazlı olarak ) depo-sevk, ambar fişi ve satınalma siparişi bağlantılarını tutar.
OZDEN20080704 --->
	<cffunction name="add_internaldemand_row_relation" returntype="boolean" output="false">
	<cfargument name="internaldemand_id" default=""> <!--- ic talep id si --->
	<cfargument name="to_related_action_id" required="yes" default=""> <!--- iç talebin ilişkili oldugu işlemin action_id si --->
	<cfargument name="to_related_action_type" required="yes" default=""><!---iç talep hangi işlemle ilişkilendirilmis  0: satınalma siparişi, 1: depolararası sevk irs. ,2: ambar fişi 3: satinalma teklifi--->
	<cfargument name="is_related_action_iptal"> <!--- ilgili işlem iptal --->
	<cfargument name="action_status" required="yes" type="numeric"><!--- 0: ekleme 1: guncelleme--->
	<cfargument name="process_db" required="yes" default="#dsn3#" type="string">
	<cfargument name="process_db_alias" type="string">
	<cfif arguments.process_db is not 'dsn3'>
		<cfset arguments.process_db_alias = '#dsn3_alias#.'>
	<cfelse>
		<cfset arguments.process_db_alias = ''>
	</cfif>
	<cfset related_ships = "">
	<cfset related_ship_periods = "">
	<cfif arguments.action_status eq 1>
		<!--- guncelleme ve silme islemlerinden cagrıldıgında kayıtlar temizleniyor.--->
		<cfquery name="DEL_INT_RELATION_" datasource="#arguments.process_db#">
			DELETE 
				FROM #arguments.process_db_alias#INTERNALDEMAND_RELATION_ROW
			WHERE
				<cfif to_related_action_type eq 0> <!--- satınalma siparisi --->
					TO_ORDER_ID = #to_related_action_id#
				<cfelseif to_related_action_type eq 1>
					TO_SHIP_ID = #to_related_action_id#
					AND PERIOD_ID = #session.ep.period_id#
				<cfelseif to_related_action_type eq 2>
					TO_STOCK_FIS_ID = #to_related_action_id#
					AND PERIOD_ID =#session.ep.period_id#
				<cfelseif to_related_action_type eq 3><!--- Satinalma Teklifi --->
					TO_OFFER_ID = #to_related_action_id#
                <cfelseif to_related_action_type eq 4><!--- Satinalma Talebi --->
					TO_INTERNALDEMAND_ID = #to_related_action_id#
				</cfif>
		</cfquery>
	</cfif>
	<cfif listfind('0,1',arguments.action_status) and not (isdefined('arguments.is_related_action_iptal') and arguments.is_related_action_iptal eq 1) > <!--- ekleme ve guncellemede kayıtlar ekleniyor --->
		<cfloop from="1" to="#attributes.rows_#" index="row_shp_ind">
			<cfif Len(Evaluate("attributes.stock_id#row_shp_ind#")) and Len(Evaluate("attributes.product_id#row_shp_ind#"))><!--- FBS 20120502 Bu kontrol action file ile olusan irsaliye kaydi icin eklenmistir --->
				<cfif (listlen(evaluate("attributes.row_ship_id#row_shp_ind#"),';') eq 2 and evaluate("listfirst(attributes.row_ship_id#row_shp_ind#,';')") ) or ( listlen(evaluate("attributes.row_ship_id#row_shp_ind#"),';') eq 1 and evaluate("attributes.row_ship_id#row_shp_ind#") neq 0)>
					<!--- row_ship_id 2 haneli ise interdemand_id;period_id bilgilerini tutar
					row_ship_id 0 olanlar alınmaz cunku bu satırlar manuel eklenmiş urunleri gosterir --->
					<cfquery name="ADD_INTERD_RELATION_ROW_" datasource="#arguments.process_db#">
						INSERT INTO
							#arguments.process_db_alias#INTERNALDEMAND_RELATION_ROW
						(
							INTERNALDEMAND_ID,
							INTERNALDEMAND_ROW_ID,
							PRODUCT_ID,
							STOCK_ID,
							SPECT_VAR_ID,
							SHELF_NUMBER,
							AMOUNT,
							<cfif to_related_action_type eq 0> <!--- satınalma siparisi --->
								TO_ORDER_ID,
							<cfelseif to_related_action_type eq 1>
								TO_SHIP_ID,
							<cfelseif to_related_action_type eq 2>
								TO_STOCK_FIS_ID,
							<cfelseif to_related_action_type eq 3><!--- Satinalma Teklifi --->
								TO_OFFER_ID,
							<cfelseif to_related_action_type eq 4><!--- iç talepten satınalma talebi oluşturma --->
								TO_INTERNALDEMAND_ID,
							</cfif>
							DEPARTMENT_ID,
							LOCATION_ID,
							PERIOD_ID
						)
						VALUES
						(
						#evaluate("listfirst(attributes.row_ship_id#row_shp_ind#,';')")#,
						<cfif listlen(evaluate("attributes.row_ship_id#row_shp_ind#"),';') eq 2 and len(listgetat(evaluate("attributes.row_ship_id#row_shp_ind#"),2,';'))>
							#listgetat(evaluate("attributes.row_ship_id#row_shp_ind#"),2,';')#
						<cfelse>
							NULL
						</cfif>,
							#evaluate('attributes.product_id#row_shp_ind#')#,
							#evaluate('attributes.stock_id#row_shp_ind#')#,
						<cfif isdefined('attributes.spect_id#row_shp_ind#') and len(evaluate('attributes.spect_id#row_shp_ind#'))>#evaluate('attributes.spect_id#row_shp_ind#')#,<cfelse>NULL,</cfif>
						<cfif isdefined('attributes.shelf_number#row_shp_ind#') and len(evaluate('attributes.shelf_number#row_shp_ind#'))>#evaluate('attributes.shelf_number#row_shp_ind#')#,<cfelse>NULL,</cfif>
							#evaluate('attributes.amount#row_shp_ind#')#,
							#to_related_action_id#,
						<cfif to_related_action_type eq 0><!--- satınalma siparisi--->
							<cfif isdefined("attributes.deliver_dept#i#") and len(trim(evaluate("attributes.deliver_dept#i#"))) and len(listfirst(evaluate("attributes.deliver_dept#i#"),"-"))>
								#listfirst(evaluate("attributes.deliver_dept#i#"),"-")#,
							<cfelseif isdefined("attributes.deliver_dept_id") and len(attributes.deliver_dept_id)>
								#attributes.deliver_dept_id#,						
							<cfelse>
								NULL,
							</cfif>
							<cfif isdefined("attributes.deliver_dept#i#") and listlen(trim(evaluate("attributes.deliver_dept#i#")),"-") eq 2 and len(listlast(evaluate("attributes.deliver_dept#i#"),"-"))>
								#listlast(evaluate("attributes.deliver_dept#i#"),"-")#,
							<cfelseif isdefined("attributes.deliver_loc_id") and len(attributes.deliver_loc_id)>
								#attributes.deliver_loc_id#,
							<cfelse>
								NULL,
							</cfif>
						<cfelseif to_related_action_type eq 1><!--- depolararası sevk--->
							<cfif isdefined('attributes.department_id') and len(attributes.department_id)>#attributes.department_id#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.location_id') and len(attributes.location_id)>#attributes.location_id#<cfelse>NULL</cfif>,
						<cfelse>
							NULL,
							NULL,
						</cfif>
							#session.ep.period_id#
						)
					</cfquery>
				</cfif>
			</cfif>
		</cfloop>
	</cfif>
	<cfreturn true>
</cffunction>

<!---add_paper_relation--->
<!---Proje malzeme planlarının iç talep ve siparişle baglantısını tutar. OZDEN 20080711 --->
<!--- PAPER TYPE :  1-ORDERS 
				2-PRO_MATERIAL
				3-INTERNALDEMAND --->
	<cffunction name="add_paper_relation" returntype="boolean" output="false">
		<cfargument name="to_paper_id" required="yes"> <!--- olusturulan belge--->
		<cfargument name="to_paper_table" required="yes"> <!--- olusturulan belgenin tablosu--->
		<cfargument name="to_paper_type" required="yes"><!---olusturulan belgenin type --->
		<cfargument name="from_paper_id"> <!--- baglantılı oldugu belge id si --->
		<cfargument name="from_paper_table"><!--- baglantılı oldugu belgenin tablosu --->
		<cfargument name="from_paper_type"><!--- baglantılı oldugu belgenin type--->
		<cfargument name="action_status" required="yes" type="numeric"><!--- 0: ekleme 1: guncelleme 2: sil--->
		<cfargument name="process_db" required="yes" default="#dsn3#" type="string">
		<cfargument name="process_db_alias" type="string">
		<cfif arguments.process_db is not 'dsn'>
			<cfset arguments.process_db_alias = '#dsn_alias#.'>
		<cfelse>
			<cfset arguments.process_db_alias = ''>
		</cfif>
		<cfif listfind('1,2',arguments.action_status)>
			<!--- guncelleme ve silme islemlerinden cagrıldıgında kayıtlar temizleniyor.--->
			<cfquery name="DEL_INT_RELATION_" datasource="#arguments.process_db#">
				DELETE 
					FROM #arguments.process_db_alias#PAPER_RELATION
				WHERE
					PAPER_ID = #arguments.to_paper_id#
					AND PAPER_TABLE = '#arguments.to_paper_table#'
					AND PAPER_TYPE_ID = #arguments.to_paper_type#
			</cfquery>
		</cfif>
		<cfif listfind('0,1',arguments.action_status)>
			<cfif arguments.to_paper_table is 'ORDERS' and arguments.to_paper_type eq 1>
				<cfquery name="GET_RELATED_PAPER_INFO" datasource="#arguments.process_db#">
					SELECT 
						DISTINCT ROW_PRO_MATERIAL_ID AS RELATED_PAPER_ID
					FROM 
						#dsn3_alias#.ORDER_ROW
					WHERE
						ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.to_paper_id#">
				</cfquery>
			<cfelse>
				<cfquery name="GET_RELATED_PAPER_INFO" datasource="#arguments.process_db#">
					SELECT 
						DISTINCT PRO_MATERIAL_ID AS RELATED_PAPER_ID
					FROM 
						#dsn3_alias#.INTERNALDEMAND_ROW
					WHERE
						I_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.to_paper_id#">
				</cfquery>
			</cfif>
			<cfif GET_RELATED_PAPER_INFO.recordcount>
				<cfset related_action_list_=valuelist(GET_RELATED_PAPER_INFO.RELATED_PAPER_ID)>
			<cfelse>
				<cfset related_action_list_=''>
			</cfif>
		<cfelse>
			<cfset related_action_list_=''>
		</cfif>
		<cfif len(related_action_list_)>
			<cfloop list="#related_action_list_#" index="related_ind_i">
				<cfquery name="ADD_PAPER_RELATION_" datasource="#arguments.process_db#">
					INSERT INTO
						#arguments.process_db_alias#PAPER_RELATION
					(
						PAPER_ID,
						PAPER_TABLE,
						PAPER_TYPE_ID,
						RELATED_PAPER_ID,
						RELATED_PAPER_TABLE,
						RELATED_PAPER_TYPE_ID,
						COMP_ID,
						PERIOD_ID
					)
					VALUES
					(
						#arguments.to_paper_id#,
						'#arguments.to_paper_table#',
						#arguments.to_paper_type#,
						#related_ind_i#,
						<cfif len(arguments.from_paper_table)>'#arguments.from_paper_table#'<cfelse>NULL</cfif>,
						#arguments.from_paper_type#,		
						#session.ep.company_id#,
						#session.ep.period_id#
					)
				</cfquery>
			</cfloop>
		</cfif>
		<cfreturn true>
	</cffunction>
 
<!---add_invoice_from_ship_result--->
<!--- Toplu Sevkiyattan Irsaliye Olusturmak Icin Kullaniliyor FBS --->
	<cffunction name="add_invoice_from_ship_result" returntype="boolean" output="true">
		<cfargument name="order_id" type="numeric">
		<cfargument name="order_wrk_row_id_list" type="string">
		<cfargument name="process_catid" required="yes" type="string">
		<cfargument name="ship_result_id" required="yes" type="string">
		<cfargument name="x_ship_group_dept" required="yes" type="string">
		<cfargument name="cari_db" type="string" default="#dsn2#">
		<cfif not isdefined("butceci")>
			<cfinclude template="get_butceci.cfm">
		</cfif>
		<cfif not isdefined("carici")>
			<cfinclude template="get_carici.cfm">
		</cfif>
		<cfif not isdefined("muhasebeci")>
			<cfinclude template="get_muhasebeci.cfm">
		</cfif>
		<cfif not isdefined("get_consumer_period")>
			<cfinclude template="get_user_accounts.cfm">
		</cfif>
		<cfif not isdefined("basket_kur_ekle")>
			<cfinclude template="get_basket_money_js.cfm">
		</cfif>
		<cfif not isdefined("add_order_row_reserved_stock")>
			<cfinclude template="add_order_row_reserved_stock.cfm">
		</cfif>
		<cfif not isdefined("add_reserve_row")>
			<cfinclude template="add_relation_rows.cfm">
		</cfif>
		<cfif not isdefined("add_stock_rows")>
			<cfinclude template="add_stock_rows.cfm">
		</cfif>
		<cfset function_off = 1>
		<cfset is_from_function = "">
		<cfset List_Wrk_Row_Id = "">
		<cfif isdefined("arguments.order_id") and Len(arguments.order_id)>
			<cfquery name="get_order_detail" datasource="#arguments.cari_db#">
				SELECT * FROM #dsn3_alias#.ORDERS WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_id#">
			</cfquery>
			<cfquery name="get_order_rows" datasource="#arguments.cari_db#">
				SELECT * FROM #dsn3_alias#.ORDER_ROW WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_id#">
			</cfquery>
		<cfelseif isdefined("arguments.order_wrk_row_id_list") and Len(arguments.order_wrk_row_id_list)>
			<cfloop list="#ListDeleteDuplicates(arguments.order_wrk_row_id_list)#" delimiters=";" index="w">
				<cfset List_Wrk_Row_Id = ListAppend(List_Wrk_Row_Id,ListFirst(w,'_'),',')>
			</cfloop>
			<cfif Len(List_Wrk_Row_Id)>
				<cfquery name="Get_Order_Details" datasource="#arguments.cari_db#">
					SELECT
						1 TYPE,
						<cfif isdefined("arguments.x_ship_group_dept") and arguments.x_ship_group_dept eq 1><!--- depo bazında gruplama seçiliyse --->
							'1_' + CAST(ISNULL(O.COMPANY_ID,0) AS NVARCHAR(10))+ '_' + CAST(ISNULL(O.PROJECT_ID,0) AS NVARCHAR(10)) + '_' +  CAST(ISNULL(O.COUNTY_ID,0) AS NVARCHAR(10))+ '_' +  CAST(ISNULL(ISNULL(OW.DELIVER_DEPT,O.DELIVER_DEPT_ID),0) AS NVARCHAR(10))+ '_' +  CAST(ISNULL(ISNULL(OW.DELIVER_LOCATION,O.LOCATION_ID),0) AS NVARCHAR(10)) MEMBER_ID,
						<cfelse>
							'1_' + CAST(ISNULL(O.COMPANY_ID,0) AS NVARCHAR(10))+ '_' + CAST(ISNULL(O.PROJECT_ID,0) AS NVARCHAR(10)) + '_' +  CAST(ISNULL(O.COUNTY_ID,0) AS NVARCHAR(10)) MEMBER_ID,
						</cfif>
						(SELECT IS_INVENTORY FROM #dsn3_alias#.STOCKS STOCKS WHERE OW.STOCK_ID = STOCK_ID) IS_INVENTORY,
						(SELECT IS_PRODUCTION FROM #dsn3_alias#.STOCKS STOCKS WHERE OW.STOCK_ID = STOCK_ID) IS_PRODUCTION,
						(SELECT PACKAGE_CONTROL_TYPE FROM #dsn1_alias#.PRODUCT WHERE PRODUCT_ID = OW.PRODUCT_ID) CONTROL_TYPE,
						O.SHIP_ADDRESS MULTISHIP_ADDRESS,
						OW.OTHER_MONEY_VALUE ROW_OTHER_MONEY_VALUE,
						OW.OTHER_MONEY ROW_OTHER_MONEY,
						OW.TAX ROW_TAX,
						OW.NETTOTAL ROW_NETTOTAL,
						*					
					FROM
						#dsn3_alias#.ORDERS O,
						#dsn3_alias#.ORDER_ROW OW
					WHERE
						OW.ORDER_ID = O.ORDER_ID AND
						O.CONSUMER_ID IS NULL AND
						<cfif isdefined("attributes.no_send_stock_id_list") and len(attributes.no_send_stock_id_list)>
							OW.STOCK_ID NOT IN (#attributes.no_send_stock_id_list#) AND
						</cfif>
						<cfif isdefined("attributes.no_send_ship_wrk_row_list") and len(attributes.no_send_ship_wrk_row_list)>
							<!--- Burasi kaldirilabilir, simdilik kalsin 20100129 --->
							OW.WRK_ROW_ID NOT IN (#ListQualify(attributes.no_send_ship_wrk_row_list,"'",",","all")#) AND
						</cfif>
						OW.WRK_ROW_ID IN (#ListQualify(List_Wrk_Row_Id,"'",",","all")#)
	
					UNION ALL
	
					SELECT
						2 TYPE,
						<cfif isdefined("arguments.x_ship_group_dept") and arguments.x_ship_group_dept eq 1><!--- depo bazında gruplama seçiliyse --->
							'2_' + CAST(ISNULL(O.CONSUMER_ID,0) AS NVARCHAR(10))+ '_' + CAST(ISNULL(O.PROJECT_ID,0) AS NVARCHAR(10)) + '_' +  CAST(ISNULL(O.COUNTY_ID,0) AS NVARCHAR(10))+ '_' +  CAST(ISNULL(ISNULL(OW.DELIVER_DEPT,O.DELIVER_DEPT_ID),0) AS NVARCHAR(10))+ '_' +  CAST(ISNULL(ISNULL(OW.DELIVER_LOCATION,O.LOCATION_ID),0) AS NVARCHAR(10)) MEMBER_ID,
						<cfelse>
							'2_' + CAST(ISNULL(O.CONSUMER_ID,0) AS NVARCHAR(10))+ '_' + CAST(ISNULL(O.PROJECT_ID,0) AS NVARCHAR(10)) + '_' +  CAST(ISNULL(O.COUNTY_ID,0) AS NVARCHAR(10)) MEMBER_ID,
						</cfif>
						(SELECT IS_INVENTORY FROM #dsn3_alias#.STOCKS STOCKS WHERE OW.STOCK_ID = STOCK_ID) IS_INVENTORY,
						(SELECT IS_PRODUCTION FROM #dsn3_alias#.STOCKS STOCKS WHERE OW.STOCK_ID = STOCK_ID) IS_PRODUCTION,
						(SELECT PACKAGE_CONTROL_TYPE FROM #dsn1_alias#.PRODUCT WHERE PRODUCT_ID = OW.PRODUCT_ID) CONTROL_TYPE,
						O.SHIP_ADDRESS MULTISHIP_ADDRESS,
						OW.OTHER_MONEY_VALUE ROW_OTHER_MONEY_VALUE,
						OW.OTHER_MONEY ROW_OTHER_MONEY,
						OW.TAX ROW_TAX,
						OW.NETTOTAL ROW_NETTOTAL,
						*					
					FROM
						#dsn3_alias#.ORDERS O,
						#dsn3_alias#.ORDER_ROW OW
					WHERE
						OW.ORDER_ID = O.ORDER_ID AND
						O.COMPANY_ID IS NULL AND
						<cfif isdefined("attributes.no_send_stock_id_list") and len(attributes.no_send_stock_id_list)>
							OW.STOCK_ID NOT IN (#attributes.no_send_stock_id_list#) AND
						</cfif>
						OW.WRK_ROW_ID IN (#ListQualify(List_Wrk_Row_Id,"'",",","all")#)
					ORDER BY
						TYPE,
						MEMBER_ID
				</cfquery>
				<cfquery name="Get_Ship_Result_Info" datasource="#arguments.cari_db#">
					SELECT
						SR.DEPARTMENT_ID,
						SR.LOCATION_ID,
						SR.SHIP_METHOD_TYPE,
						SR.MAIN_SHIP_FIS_NO,
						SR.DELIVERY_DATE,
						DTP.TEAM_CODE
					FROM
						#dsn2_alias#.SHIP_RESULT SR,
						#dsn3_alias#.DISPATCH_TEAM_PLANNING DTP
					WHERE
						SR.EQUIPMENT_PLANNING_ID = DTP.PLANNING_ID AND
						SR.SHIP_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ship_result_id#">
				</cfquery>
			<cfelse>
				Eksik Parametre Girişi !!!
			</cfif>
		<cfelse>
			Eksik Parametre Girişi !!!
			<cfabort>
		</cfif>
		
		<cfset row_ind = 0>
		<!--- order_id_listesi bu siparis irsaliye iliskileri saglanirken irsaliye querysindeki function i calistirmak icin gerekli --->
		<cfoutput query="Get_Order_Details" group="Member_Id">
			<cfquery name="Get_Order_Details_row" dbtype="query">
				SELECT ORDER_ID FROM Get_Order_Details WHERE MEMBER_ID = '#Member_Id#'
			</cfquery>
			<cfset attributes.order_id_listesi = ListSort(ListDeleteDuplicates(ValueList(Get_Order_Details_row.Order_Id,",")),"numeric","asc",",")>
			<cf_papers paper_type = "invoice">
			<cfif len(Get_Order_Details.member_id) and Get_Order_Details.type eq 1>
				<cfquery name="get_member_id" datasource="#arguments.cari_db#">
					SELECT
						COMPANY.COMPANY_ID,
						ISNULL(COMPANY.MANAGER_PARTNER_ID,(SELECT TOP 1 PARTNER_ID FROM #dsn_alias#.COMPANY_PARTNER WHERE COMPANY_ID=COMPANY.COMPANY_ID)) PARTNER_ID,
						COMPANY_PERIOD.ACCOUNT_CODE
					FROM 
						#dsn_alias#.COMPANY,
						#dsn_alias#.COMPANY_PERIOD
					WHERE
						COMPANY.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(Get_Order_Details.Member_Id,2,'_')#"> AND
						COMPANY_PERIOD.COMPANY_ID = COMPANY.COMPANY_ID AND
						COMPANY_PERIOD.PERIOD_ID = <cfif isdefined("session.ep")><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.period_id#"></cfif>
				</cfquery>
			<cfelse>
				<cfquery name="get_member_id" datasource="#arguments.cari_db#">
					SELECT
						CONSUMER.CONSUMER_ID,
						CONSUMER_PERIOD.ACCOUNT_CODE
					FROM 
						#dsn_alias#.CONSUMER,
						#dsn_alias#.CONSUMER_PERIOD
					WHERE 
						CONSUMER.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(Get_Order_Details.Member_Id,2,'_')#"> AND
						CONSUMER.CONSUMER_ID = CONSUMER_PERIOD.CONSUMER_ID AND
						CONSUMER_PERIOD.PERIOD_ID = <cfif isdefined("session.ep")><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.period_id#"></cfif>
				</cfquery>
			</cfif>
			<cfquery name="get_money" datasource="#arguments.cari_db#">
				SELECT RATE2,RATE1,MONEY_TYPE FROM #dsn3_alias#.ORDER_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Order_Details.Order_Id#">
			</cfquery>
			<cfquery name="get_money_selected" datasource="#arguments.cari_db#">
				SELECT RATE2,RATE1,MONEY_TYPE FROM #dsn3_alias#.ORDER_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Order_Details.Order_Id#"> AND IS_SELECTED = 1
			</cfquery>
			<cfscript>
				topla_basket_gross_total = 0;
				topla_basket_net_total = 0;
				topla_basket_discount_total = 0;
				topla_basket_tax_total = 0;
				topla_basket_otv_total = 0;
				
				form.sale_product=1;
				attributes.paper_number = paper_number;
				attributes.invoice_number = '#paper_code#-#paper_number#';
				form.invoice_number='#paper_code#-#paper_number#';
				invoice_number='#paper_code#-#paper_number#';
				form.serial_number = listfirst(form.invoice_number,'-');
				form.serial_no = listlast(form.invoice_number,'-');
				attributes.order_id = Get_Order_Details.Order_Id;
				attributes.process_cat=arguments.process_catid;
				form.process_cat=arguments.process_catid;
				get_process_type.IS_STOCK_ACTION=1;
				'ct_process_type_#arguments.process_catid#'=arguments.process_catid;
				if(isdefined("arguments.x_ship_group_dept") and arguments.x_ship_group_dept eq 1)//depo bazında gruplama seçili ise
				{
					if(ListGetAt(Get_Order_Details.Member_Id,5,'_') neq 0)
					{
						attributes.department_id=ListGetAt(Get_Order_Details.Member_Id,5,'_');
						attributes.location_id=ListGetAt(Get_Order_Details.Member_Id,6,'_');
					}
					else
					{
						attributes.department_id=Get_Ship_Result_Info.Department_Id;
						attributes.location_id=Get_Ship_Result_Info.Location_Id;
					}
				}
				else
				{
					attributes.department_id=Get_Ship_Result_Info.Department_Id;
					attributes.location_id=Get_Ship_Result_Info.Location_Id;
				}
				attributes.ship_method=Get_Ship_Result_Info.Ship_Method_Type;
				attributes.ref_no = Get_Ship_Result_Info.Team_Code;
	
				if(len(Get_Order_Details.Member_Id) and Get_Order_Details.Type eq 1)
				{
					attributes.company_id=ListGetAt(Get_Order_Details.Member_Id,2,'_');
					attributes.comp_name='a';
					attributes.partner_id=Get_Order_Details.partner_id;
					attributes.partner_name='b';
					attributes.consumer_id='';
				}
				else
				{
					attributes.company_id='';
					attributes.comp_name='a';
					attributes.partner_id='';
					attributes.partner_name='b';
					attributes.consumer_id=ListGetAt(Get_Order_Details.Member_Id,2,'_');
				}
				attributes.consumer_reference_code=Get_Order_Details.CONSUMER_REFERENCE_CODE;
				attributes.partner_reference_code=Get_Order_Details.PARTNER_REFERENCE_CODE;
				
				if(isdefined("attributes.ship_out_date") and isdate(attributes.ship_out_date))
					attributes.invoice_date=dateformat(attributes.ship_out_date,'dd/mm/yyyy');
				else
					attributes.invoice_date=dateformat(Get_Order_Details.ORDER_DATE,'dd/mm/yyyy');
				invoice_date=attributes.invoice_date;
				
				if(Len(Get_Ship_Result_Info.Delivery_Date) and isDate(Get_Ship_Result_Info.Delivery_Date))
					attributes.deliver_date_frm=dateformat(Get_Ship_Result_Info.Delivery_Date,'dd/mm/yyyy');
				else if(isdefined("attributes.ship_out_date") and isdate(attributes.ship_out_date))
					attributes.deliver_date_frm=dateformat(attributes.ship_out_date,'dd/mm/yyyy');
				else
					attributes.deliver_date_frm=dateformat(Get_Order_Details.ORDER_DATE,'dd/mm/yyyy');
	
				attributes.kasa='';
				kasa='';
				attributes.member_account_code=GET_MEMBER_ID.ACCOUNT_CODE;
				note=Get_Order_Details.ORDER_DETAIL;
				attributes.city_id=Get_Order_Details.CITY_ID;
				attributes.county_id=Get_Order_Details.COUNTY_ID;
				attributes.adres=Get_Order_Details.MULTISHIP_ADDRESS;
				adres = Get_Order_Details.MULTISHIP_ADDRESS;
				for(stp_mny=1;stp_mny lte GET_MONEY.RECORDCOUNT;stp_mny=stp_mny+1)
				{
					'attributes.hidden_rd_money_#stp_mny#'=GET_MONEY.MONEY_TYPE[stp_mny];
					'attributes.txt_rate1_#stp_mny#'=GET_MONEY.RATE1[stp_mny];	
					'attributes.txt_rate2_#stp_mny#'=GET_MONEY.RATE2[stp_mny];
				}
				form.basket_money=GET_MONEY_SELECTED.MONEY_TYPE;
				attributes.basket_money=GET_MONEY_SELECTED.MONEY_TYPE;
				form.basket_rate1=GET_MONEY_SELECTED.RATE1;
				form.basket_rate2=GET_MONEY_SELECTED.RATE2;
				attributes.basket_rate1=GET_MONEY_SELECTED.RATE1;
				attributes.basket_rate2=GET_MONEY_SELECTED.RATE2;
				attributes.kur_say=GET_MONEY.RECORDCOUNT;
				if(Get_Order_Details.purchase_sales eq 0 and Get_Order_Details.order_zone eq 0)//alis
				{
					attributes.basket_id = 11;
					attributes.form_add = 1;
					attributes.basket_sub_id = 4;
				}
				else //satis
				{
					attributes.basket_id = 10;
					attributes.form_add = 1;
				}
				attributes.list_payment_row_id='';
				attributes.subscription_id='';
				attributes.ship_counter_number='';
				attributes.commethod_id='';
				attributes.bool_from_control_bill='';
				attributes.invoice_control_id='';
				attributes.contract_row_ids='';
				attributes.card_paymethod_id=Get_Order_Details.CARD_PAYMETHOD_ID;
				attributes.commission_rate=Get_Order_Details.CARD_PAYMETHOD_RATE;
				attributes.paymethod_id=Get_Order_Details.PAYMETHOD;
				attributes.project_id=Get_Order_Details.PROJECT_ID;
				attributes.project_head='aa';
				EMPO_ID=Get_Order_Details.ORDER_EMPLOYEE_ID;
				PARTO_ID=Get_Order_Details.SALES_PARTNER_ID;
				form.deliver_get='';		
					
				inventory_product_exists = 0;
				attributes.yuvarlama='';
				attributes.tevkifat_oran=0;
				attributes.is_general_prom=0;
				attributes.indirim_total='100000000000000000000,100000000000000000000';
				attributes.general_prom_limit='';
				attributes.general_prom_discount='';
				attributes.general_prom_amount=0;
				attributes.free_prom_limit='';
				attributes.flt_net_total_all=0;
				attributes.currency_multiplier = '';
				attributes.basket_member_pricecat='';
				attributes.basket_due_value_date_=dateformat(Get_Order_Details.DUE_DATE,'dd/mm/yyyy');
				attributes.BASKET_PRICE_ROUND_NUMBER = 4;
				
				xml_tax_count=1;//kdv sayısı
				xml_otv_count=1;//otv sayısı
			</cfscript>
			<cfset attributes.acc_department_id = ''>
			<cfset row_info = 0>
			<cfoutput><!--- CfOutput Group Icin Kullanilan 2. Output Silinmesin !!! --->
				<cfset row_ind = row_ind + 1>
				<cfset row_info = row_info + 1>
				<!--- Miktarlar Sevkiyattan Gonderiliyor --->
				<cfset OrderWrkRowId  = Get_Order_Details.wrk_row_id[row_ind]>
				<cfloop list="#ListDeleteDuplicates(arguments.order_wrk_row_id_list)#" delimiters=";" index="xx">
					<!--- Compare text ifadeleri karsilastirmak icin kullaniliyor, listfind gibi --->
					<cfif compare(ListFirst(xx,'_'),OrderWrkRowId) eq 0>
						<cfset 'attributes.amount#row_info#'= ListLast(xx,'_')>
					</cfif>
				</cfloop>
	
				<cfscript>
					price_round_number = 4; //duzenlenecekkkkkkkkkkkkkk
					/* Burasi siparisleri getiriyordu, kaldirildi, ekip bilgileri gelecek sekilde duzenlendi fbs 20100223
					if(not ListFind(attributes.ref_no,Get_Order_Details.ORDER_NUMBER,',')) 
						attributes.ref_no = attributes.ref_no & ',' & Get_Order_Details.ORDER_NUMBER;
					*/
					'attributes.deliver_date#row_info#'=Get_Order_Details.DELIVER_DATE[row_ind];
					'attributes.deliver_dept#row_info#'=""; //Get_Order_Details.DELIVER_DEPT[row_ind]
					'attributes.duedate#row_info#'=Get_Order_Details.DUEDATE[row_ind];
					'attributes.ek_tutar#row_info#'=Get_Order_Details.EK_TUTAR_PRICE[row_ind];
					if(len(Get_Order_Details.EXTRA_PRICE_TOTAL[row_ind])) 'attributes.ek_tutar_total#row_info#'=Get_Order_Details.EXTRA_PRICE_TOTAL[row_ind]; else 'attributes.ek_tutar_total#row_info#'=0;
					if(len(Get_Order_Details.EXTRA_PRICE_OTHER_TOTAL[row_ind])) 'attributes.ek_tutar_other_total#row_info#'=Get_Order_Details.EXTRA_PRICE_OTHER_TOTAL[row_ind]; else 'attributes.ek_tutar_other_total#row_info#'=0;
					if(Len(Get_Order_Details.ROW_TAX[row_ind]))
					{
						'attributes.tax#row_info#'=Get_Order_Details.ROW_TAX[row_ind];
						'attributes.tax_percent#row_info#'=Get_Order_Details.ROW_TAX[row_ind];
					}
					else
					{
						'attributes.tax#row_info#' = 0;
						'attributes.tax_percent#row_info#' = 0;
					}
					'form.tax#row_info#' = evaluate('attributes.tax#row_info#');
					'form.tax_percent#row_info#' = evaluate('attributes.tax_percent#row_info#');
					'attributes.row_unique_relation_id#row_info#'=Get_Order_Details.UNIQUE_RELATION_ID[row_ind];
					'attributes.shelf_number#row_info#'=Get_Order_Details.SHELF_NUMBER[row_ind];
					'attributes.spect_id#row_info#'=Get_Order_Details.SPECT_VAR_ID[row_ind];
					'attributes.spect_name#row_info#'=Get_Order_Details.SPECT_VAR_NAME[row_ind];
					'attributes.stock_id#row_info#'=Get_Order_Details.STOCK_ID[row_ind];
					'attributes.unit#row_info#'=Get_Order_Details.UNIT[row_ind];
					'attributes.unit_id#row_info#'=Get_Order_Details.UNIT_ID[row_ind];
					'attributes.price_cat#row_info#'=Get_Order_Details.PRICE_CAT[row_ind];
					'attributes.unit_other#row_info#'=Get_Order_Details.UNIT2[row_ind];
					'attributes.basket_employee_id#row_info#'=Get_Order_Details.BASKET_EMPLOYEE_ID[row_ind];
					'attributes.basket_extra_info#row_info#'=Get_Order_Details.BASKET_EXTRA_INFO_ID[row_ind];
					'attributes.detail_info_extra#row_info#'=Get_Order_Details.DETAIL_INFO_EXTRA[row_ind];
					'attributes.select_info_extra#row_info#'=Get_Order_Details.SELECT_INFO_EXTRA[row_ind];
					'attributes.row_promotion_id#row_info#'=Get_Order_Details.PROM_ID[row_ind];
					'attributes.row_service_id#row_info#'='';
					
					'attributes.extra_cost#row_info#'=Get_Order_Details.EXTRA_COST[row_ind];
					'attributes.indirim1#row_info#'=Get_Order_Details.DISCOUNT_1[row_ind];
					'attributes.indirim2#row_info#'=Get_Order_Details.DISCOUNT_2[row_ind];
					'attributes.indirim3#row_info#'=Get_Order_Details.DISCOUNT_3[row_ind];
					'attributes.indirim4#row_info#'=Get_Order_Details.DISCOUNT_4[row_ind];
					'attributes.indirim5#row_info#'=Get_Order_Details.DISCOUNT_5[row_ind];
					'attributes.indirim6#row_info#'=Get_Order_Details.DISCOUNT_6[row_ind];
					'attributes.indirim7#row_info#'=Get_Order_Details.DISCOUNT_7[row_ind];
					'attributes.indirim8#row_info#'=Get_Order_Details.DISCOUNT_8[row_ind];
					'attributes.indirim9#row_info#'=Get_Order_Details.DISCOUNT_9[row_ind];
					'attributes.indirim10#row_info#'=Get_Order_Details.DISCOUNT_10[row_ind];
					'attributes.indirim_carpan#row_info#' = (100-Evaluate('attributes.indirim1#row_info#')) * (100-Evaluate('attributes.indirim2#row_info#')) * (100-Evaluate('attributes.indirim3#row_info#')) * (100-Evaluate('attributes.indirim4#row_info#')) * (100-Evaluate('attributes.indirim5#row_info#')) * (100-Evaluate('attributes.indirim6#row_info#')) * (100-Evaluate('attributes.indirim7#row_info#')) * (100-Evaluate('attributes.indirim8#row_info#')) * (100-Evaluate('attributes.indirim9#row_info#')) * (100-Evaluate('attributes.indirim10#row_info#'));
					
					
					'attributes.iskonto_tutar#row_info#'=Get_Order_Details.DISCOUNT_COST[row_ind];
					'attributes.is_commission#row_info#'=Get_Order_Details.IS_COMMISSION[row_ind];
					'attributes.is_inventory#row_info#'=Get_Order_Details.is_inventory;
					if(Get_Order_Details.is_inventory)	inventory_product_exists = 1;
					'attributes.is_production#row_info#'=Get_Order_Details.IS_PRODUCTION;
		
					'attributes.is_promotion#row_info#'=Get_Order_Details.IS_PROMOTION[row_ind];
					'attributes.karma_product_id#row_info#'=Get_Order_Details.KARMA_PRODUCT_ID[row_ind];
					if(Len(Get_Order_Details.LIST_PRICE[row_ind])) 'attributes.list_price#row_info#'=Get_Order_Details.LIST_PRICE[row_ind]; else 'attributes.list_price#row_info#'= Get_Order_Details.PRICE[row_ind];
					'attributes.lot_no#row_info#'=Get_Order_Details.LOT_NO[row_ind];
					'attributes.manufact_code#row_info#'=Get_Order_Details.PRODUCT_MANUFACT_CODE[row_ind];
					'attributes.marj#row_info#'=Get_Order_Details.MARJ[row_ind];
					'attributes.net_maliyet#row_info#'=Get_Order_Details.COST_PRICE[row_ind];
					'attributes.number_of_installment#row_info#'=Get_Order_Details.NUMBER_OF_INSTALLMENT[row_ind];
					'attributes.order_currency#row_info#'=Get_Order_Details.ORDER_ROW_CURRENCY[row_ind];
					'attributes.product_account_code#row_info#'='';
					'attributes.product_id#row_info#'=Get_Order_Details.PRODUCT_ID[row_ind];
					'attributes.product_name#row_info#'=Get_Order_Details.PRODUCT_NAME[row_ind];
					'attributes.product_name_other#row_info#'=Get_Order_Details.PRODUCT_NAME2[row_ind];
					'attributes.promosyon_maliyet#row_info#'=Get_Order_Details.PROM_COST[row_ind];
					'attributes.promosyon_yuzde#row_info#'=Get_Order_Details.PROM_COMISSION[row_ind];
					'attributes.prom_relation_id#row_info#'=Get_Order_Details.PROM_RELATION_ID[row_ind];
					'attributes.prom_stock_id#row_info#'=Get_Order_Details.PROM_STOCK_ID[row_ind];
					'attributes.reserve_date#row_info#'=Get_Order_Details.RESERVE_DATE[row_ind];
					'attributes.reserve_type#row_info#'=Get_Order_Details.RESERVE_TYPE[row_ind];
	
					'attributes.otv_oran#row_info#'=Get_Order_Details.OTV_ORAN[row_ind];
					'attributes.price#row_info#'=Get_Order_Details.PRICE[row_ind];
					'attributes.price_other#row_info#'=Get_Order_Details.PRICE_OTHER[row_ind];
					'attributes.other_money_#row_info#'=Get_Order_Details.ROW_OTHER_MONEY[row_ind];
					'attributes.row_total#row_info#'=(Evaluate('attributes.amount#row_info#') * Evaluate('attributes.price#row_info#')) + Evaluate('attributes.ek_tutar_total#row_info#');
					if(Len(Get_Order_Details.ROW_OTHER_MONEY_VALUE[row_ind]) and Get_Order_Details.ROW_OTHER_MONEY_VALUE[row_ind] gt 0)
						'attributes.other_money_value_#row_info#' = ((Get_Order_Details.ROW_OTHER_MONEY_VALUE[row_ind] / Get_Order_Details.QUANTITY[row_ind]) * Evaluate('attributes.amount#row_info#'));
					else
						'attributes.other_money_value_#row_info#'=0;
					'attributes.other_money_gross_total#row_info#'= Evaluate('attributes.other_money_value_#row_info#') + ((Evaluate('attributes.other_money_value_#row_info#')*Evaluate('attributes.tax_percent#row_info#'))/100);
	
					'attributes.row_nettotal#row_info#'= wrk_round((Evaluate('attributes.row_total#row_info#')/100000000000000000000)*Evaluate('attributes.indirim_carpan#row_info#'),price_round_number);
					'attributes.row_taxtotal#row_info#'=wrk_round(Evaluate('attributes.row_nettotal#row_info#')*(Evaluate('attributes.tax_percent#row_info#')/100),price_round_number);
					'form.row_taxtotal#row_info#'=wrk_round(Evaluate('attributes.row_nettotal#row_info#')*(Evaluate('attributes.tax_percent#row_info#')/100),price_round_number);
					if(Get_Order_Details.OTVTOTAL[row_ind])
						'attributes.row_otvtotal#row_info#'=Get_Order_Details.OTVTOTAL[row_ind];
					else
						'attributes.row_otvtotal#row_info#' = 0;
					'form.row_otvtotal#row_info#' = evaluate('attributes.row_otvtotal#row_info#');
					'attributes.row_lasttotal#row_info#'=(Evaluate('attributes.row_nettotal#row_info#') + Evaluate('attributes.row_taxtotal#row_info#')) + Evaluate('attributes.row_otvtotal#row_info#');
					
					topla_basket_gross_total = topla_basket_gross_total + Evaluate('attributes.row_total#row_info#');
					topla_basket_net_total = topla_basket_net_total + Evaluate('attributes.row_lasttotal#row_info#');
					topla_basket_discount_total = topla_basket_discount_total + (wrk_round(Evaluate('attributes.row_total#row_info#'),price_round_number) - wrk_round(Evaluate('attributes.row_nettotal#row_info#'),price_round_number));
	
					//Onemli Wrk_vb Kontrolleri
					'attributes.row_ship_id#row_info#'=Get_Order_Details.ORDER_ID[row_ind];
					if(isdefined('session.pp.userid'))
						'attributes.wrk_row_id#row_info#'="WRK#row_ind##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.pp.userid##round(rand()*100)##row_ind#";
					else if(isdefined('session.ww.userid'))
						'attributes.wrk_row_id#row_info#'="WRK#row_ind##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ww.userid##round(rand()*100)##row_ind#";
					else
						'attributes.wrk_row_id#row_info#'="WRK#row_ind##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##row_ind#";
					'attributes.wrk_row_relation_id#row_info#'=Get_Order_Details.WRK_ROW_ID[row_ind];
					attributes.rows_ = row_info;
				</cfscript>
				<cfscript>
					//Son toplamlar
					form.genel_indirim=Get_Order_Details.SA_DISCOUNT;
					attributes.genel_indirim=Get_Order_Details.SA_DISCOUNT;
					form.basket_gross_total=topla_basket_gross_total;
					attributes.basket_gross_total=form.basket_gross_total;
					form.basket_net_total=topla_basket_net_total;
					attributes.basket_net_total=form.basket_net_total;
					form.basket_otv_total=topla_basket_otv_total;
					attributes.basket_otv_total=form.basket_otv_total;
					form.basket_tax_total=topla_basket_tax_total;
					attributes.basket_tax_total=form.basket_tax_total;
					attributes.basket_discount_total = topla_basket_discount_total;
					form.basket_discount_total = attributes.basket_discount_total;
		
					form.basket_otv_count = xml_otv_count-1;//otv oran sayısı
					form.basket_tax_count = xml_tax_count-1;//kdv sayısı
				</cfscript>
				
				<cfset xml_import=2>
				<cfif isdefined("session.ep")>
					<cfset form.active_period = session.ep.period_id>
					<cfset attributes.active_period = session.ep.period_id>
				<cfelse>
					<cfset form.active_period = session.pp.period_id>
					<cfset attributes.active_period = session.pp.period_id>
				</cfif>
				
				<cfquery name="Upd_Old_Currency" datasource="#arguments.cari_db#">
					UPDATE
						SHIP_RESULT_ROW
					SET
						OLD_ORDER_ROW_CURRENCY = #Get_Order_Details.ORDER_ROW_CURRENCY[row_ind]#
					WHERE
						SHIP_RESULT_ID = #arguments.ship_result_id# AND
						WRK_ROW_RELATION_ID = '#OrderWrkRowId#'
				</cfquery>
				<cfif Get_Order_Details.ORDER_ROW_CURRENCY[row_ind] eq -5>
					<!--- 
						Asama uretim ise sevk olarak update ediyoruz cunku, irsaliyelestirme yapilirken uretim asamasinda olusan satirlarin asama bilgileri degismiyor, 
						sevk gibi gerekirse kapatilmali ya da eksik, fazla teslimat degisimleri ile miktarlar da guncellenmeli kendisi otomatik olarak
					 --->
					<cfquery name="Upd_Order_Row_Currency" datasource="#arguments.cari_db#">
						UPDATE #dsn3_alias#.ORDER_ROW SET ORDER_ROW_CURRENCY = -6 WHERE ORDER_ROW_CURRENCY = -5 AND ORDER_ID = #Get_Order_Details.Order_Id# AND WRK_ROW_ID = '#Get_Order_Details.Wrk_Row_Id#' 
					</cfquery>
				</cfif>
			
				<!--- Bilesenleri Update Ediliyor --->
				<cfif Get_Order_Details.Control_Type eq 2 and Len(Get_Order_Details.Spect_Var_Id)>
					<cfquery name="Get_Spects_Row" datasource="#dsn2#">
						SELECT * FROM #dsn3_alias#.SPECTS_ROW WHERE SPECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Order_Details.Spect_Var_Id#"> AND IS_PROPERTY IN (0,4) AND STOCK_ID IS NOT NULL
					</cfquery>
					<cfloop query="Get_Spects_Row">
						<cfquery name="Upd_Ship_Result_Row_Component_Id" datasource="#arguments.cari_db#">
							UPDATE SHIP_RESULT_ROW_COMPONENT SET SHIP_RESULT_ROW_AMOUNT = #filterNum(Evaluate("attributes.spect_to_ship_amount_#Get_Order_Details.Wrk_Row_Id#_#Get_Spects_Row.Spect_Row_Id#"))# WHERE  SHIP_RESULT_ID = #arguments.ship_result_id# AND WRK_ROW_RELATION_ID = '#Get_Order_Details.Wrk_Row_Id#' AND COMPONENT_SPECT_ROW_ID = #Get_Spects_Row.Spect_Row_Id#
						</cfquery>
					</cfloop>
				</cfif>
				<!--- //Bilesenleri Update Ediliyor --->
			</cfoutput><!--- //CfOutput Group Icin Kullanilan 2. Output Silinmesin !!! --->
			<cfscript>
				for(ind_shp_row=1;ind_shp_row lte attributes.rows_;ind_shp_row=ind_shp_row+1)
				{
					//fatura altı indirim varsa ona hesaplanarak satırlara yansıtılıyor
					row_price_=Get_Order_Details.PRICE[ind_shp_row]*Get_Order_Details.QUANTITY[ind_shp_row];
					tmp_tax=0;
					for(ind_tax_count=1;ind_tax_count lte xml_tax_count;ind_tax_count=ind_tax_count+1)
					{
						if(isdefined('form.basket_tax_#ind_tax_count#') and evaluate('form.basket_tax_#ind_tax_count#') eq evaluate('attributes.tax#ind_shp_row#'))
						{
							'form.basket_tax_value_#ind_tax_count#' =evaluate('form.basket_tax_value_#ind_tax_count#') + wrk_round((row_price_/100)*Get_Order_Details.ROW_TAX[ind_shp_row],2);
							topla_basket_tax_total = topla_basket_tax_total + wrk_round((row_price_/100)*Get_Order_Details.ROW_TAX[ind_shp_row],2);
							tmp_tax=1;
							break;
						}
					}
					if(tmp_tax eq 0)
					{
						'form.basket_tax_#xml_tax_count#' = evaluate('attributes.tax#ind_shp_row#');
						'form.basket_tax_value_#xml_tax_count#' =  wrk_round((row_price_/100)*Get_Order_Details.ROW_TAX[ind_shp_row],2);
						topla_basket_tax_total = topla_basket_tax_total + wrk_round((row_price_/100)*Get_Order_Details.ROW_TAX[ind_shp_row],2);
						xml_tax_count=xml_tax_count+1;
					}
					tmp_otv=0;
					for(ind_otv_count=1;ind_otv_count lte xml_otv_count;ind_otv_count=ind_otv_count+1)
					{
						if(isdefined('form.basket_otv_#ind_otv_count#') and evaluate('form.basket_otv_#ind_otv_count#') eq evaluate('attributes.otv_oran#ind_shp_row#'))
						{
							'form.basket_otv_value_#ind_otv_count#'= evaluate('form.basket_otv_value_#ind_otv_count#') + wrk_round((row_price_/100)*Get_Order_Details.OTV_ORAN[ind_shp_row],2);
							topla_basket_otv_total = topla_basket_otv_total + wrk_round((row_price_/100)*Get_Order_Details.OTV_ORAN[ind_shp_row],2);
							tmp_otv=1;
							break;
						}
					}
					if(tmp_otv eq 0)	
					{
						'form.basket_otv_#xml_otv_count#'= evaluate('attributes.otv_oran#ind_shp_row#');
						'form.basket_otv_value_#xml_otv_count#'= wrk_round((row_price_/100)*Get_Order_Details.OTV_ORAN[ind_shp_row],2);
						topla_basket_otv_total = topla_basket_otv_total + wrk_round((row_price_/100)*Get_Order_Details.OTV_ORAN[ind_shp_row],2);
						xml_otv_count=xml_otv_count+1;
					}
				}
			</cfscript>
	
			<!--- fatura Ekleme Querylerine Bulundugu Kosullara Uygun Geliyor --->
			<cfif Get_Order_Details.purchase_sales eq 0 and Get_Order_Details.order_zone eq 0>
				<!--- Alis --->
				<cfinclude template="../../invoice/query/add_invoice_purchase.cfm">
			<cfelse>
				<!--- Satis --->
				<cfinclude template="../../invoice/query/add_invoice_sale.cfm">
			</cfif>
			<cfif isdefined("MAX_ID") and len(MAX_ID.IDENTITYCOL)>
				<cfquery name="Get_Related_Inv_Row" datasource="#arguments.cari_db#">
					SELECT WRK_ROW_RELATION_ID,INVOICE_ID,AMOUNT FROM INVOICE_ROW WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">
				</cfquery>
				<cfloop query="Get_Related_Inv_Row">
					<cfquery name="Upd_Ship_Result_Row_Id" datasource="#arguments.cari_db#">
						UPDATE
							SHIP_RESULT_ROW
						SET
							INVOICE_ID = #Get_Related_Inv_Row.Invoice_Id#,
							SHIP_RESULT_ROW_AMOUNT = #Get_Related_Inv_Row.Amount#
						WHERE
							SHIP_RESULT_ID = #arguments.ship_result_id# AND
							WRK_ROW_RELATION_ID = '#Get_Related_Inv_Row.Wrk_Row_Relation_Id#'
					</cfquery>
				</cfloop>
			</cfif>
			<cfif len(attributes.paper_number)>
				<cfquery name="UPD_PAPERS" datasource="#new_dsn3_group#">
					UPDATE 
						PAPERS_NO 
					SET 
						INVOICE_NUMBER = #attributes.paper_number# 
					WHERE 
					<cfif isdefined('attributes.paper_printer_id') and len(attributes.paper_printer_id)>
						PRINTER_ID = #attributes.paper_printer_id#
					<cfelse>
						EMPLOYEE_ID = #SESSION.EP.USERID#
					</cfif>
				</cfquery>
			</cfif>				
			<cfscript>
				for(ind_tax_count=1;ind_tax_count lte 100;ind_tax_count=ind_tax_count+1)
				{
					'form.basket_tax_value_#ind_tax_count#' = 0 ;
					'form.basket_tax_#ind_tax_count#' = 0 ;
					'form.basket_otv_value_#ind_tax_count#' = 0 ;
					'form.basket_otv_#ind_tax_count#' = 0 ;
				}
			</cfscript>
		</cfoutput>
		<cflocation url="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_upd_multi_packetship&main_ship_fis_no=#Get_Ship_Result_Info.Main_Ship_Fis_No#" addtoken="no">
		<cfreturn true> 
	</cffunction>
    
<!---add_pre_order_rows--->
	<cffunction name="add_pre_order_rows" returntype="numeric" output="false">
        <cfargument name="stock_id" type="numeric" required="yes">
        <cfargument name="stock_amount" type="numeric" required="yes">
        <cfargument name="product_unit_id" default="">
        <cfargument name="is_promotion" default="0">
        <cfargument name="period_id" default="">
        <cfargument name="company_id" default="">
        <cfargument name="consumer_id" default="">
        <cfargument name="partner_id" default="">
        <cfargument name="is_commission" default="0">
        <cfargument name="sales_member_id" default="">
        <cfargument name="sales_cons_id" default="">
        <cfargument name="sales_member_type" default="">
        <cfargument name="price_catid" default="">
        <cfargument name="prom_work_type" default="">
        <cfargument name="is_nondelete_product" default="">
        <cfargument name="is_product_promotion_noneffect" default="">
        <cfargument name="catalog_id" default="">
        <cfargument name="is_general_prom" default="">
        <cfargument name="prom_product_price" default="">
        <cfargument name="prom_cost" default="">
        <cfargument name="prom_id" default="">
        <cfargument name="price" default="">
        <cfargument name="price_kdv" default="">
        <cfargument name="price_money" default="">
        <cfargument name="product_tax" default="">
        <cfargument name="stock_action_id" default="">
        <cfargument name="stock_action_type" default="">
        <cfargument name="prom_stock_amount" default="">
        <cfargument name="IS_PROM_ASIL_HEDIYE" default="">
        <cfargument name="PROM_FREE_STOCK_ID" default="">
        <cfargument name="PRICE_STANDARD" default="">
        <cfargument name="PRICE_STANDARD_KDV" default="">
        <cfargument name="PRICE_STANDARD_MONEY" default="">
        <cfargument name="TO_CONS" default="">
        <cfargument name="TO_COMP" default="">
        <cfargument name="TO_PAR" default="">
        <cfargument name="SALE_PARTNER_ID" default="">
        <cfargument name="SALE_CONSUMER_ID" default="">
        <cfargument name="prod_prom_action_type" default="">
    <cfif not isdefined("session.pp") and not isdefined("session.ww.userid") and not IsDefined("Cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")>
            <cfset cookie_name_ = createUUID()>
            <cfcookie name="wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#" value="#cookie_name_#" expires="1">
        </cfif>
        <cfscript>
            saleable_stock_id_list_='';
            not_added_stock_code_list='';
            non_find_stock_list = '';
            control_strategy_list_='';
            stock_strategy_list_='';
        </cfscript>
        <!--- temsilciye baglı fiyat listesi bulunuyor --->
        <cfif not len(arguments.price_catid)>
            <cfif not isdefined("int_period_id")>
                <cfscript>
                    if (listfindnocase(partner_url,'#cgi.http_host#',';'))
                    {
                        int_comp_id = session.pp.our_company_id;
                        int_period_id = session.pp.period_id;
                        attributes.company_id = session.pp.company_id;
                    }
                    else if (listfindnocase(server_url,'#cgi.http_host#',';') )
                    {	
                        int_comp_id = session.ww.our_company_id;
                        int_period_id = session.ww.period_id;
                        if(isdefined('session.ww.userid'))
                            attributes.consumer_id = session.ww.userid;
                    }
                    else if (listfindnocase(employee_url,'#cgi.http_host#',';') )
                    {	
                        int_comp_id = session.ep.company_id;
                        int_period_id = session.ep.period_id;
                    }
                </cfscript>
            </cfif>
            <cfif isdefined("arguments.company_id") and len(arguments.company_id)>
                <cfquery name="GET_CREDIT_LIMIT" datasource="#dsn#">
                    SELECT PRICE_CAT FROM COMPANY_CREDIT WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#">
                </cfquery>
                <cfif get_credit_limit.recordcount and len(get_credit_limit.price_cat)>
                    <cfset arguments.price_catid = get_credit_limit.price_cat>
                <cfelse>		
                    <cfquery name="GET_COMP_CAT" datasource="#dsn#">
                        SELECT COMPANYCAT_ID FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
                    </cfquery>
                    <cfquery name="GET_PRICE_CAT" datasource="#dsn3#">
                        SELECT PRICE_CATID FROM PRICE_CAT WHERE COMPANY_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_comp_cat.companycat_id#,%">
                    </cfquery>
                    <cfif get_price_cat.recordcount>
                        <cfset arguments.price_catid=get_price_cat.price_catid>
                    </cfif>		
                </cfif>
            <cfelseif isdefined("arguments.consumer_id") and len(arguments.consumer_id)>
                <cfquery name="GET_CREDIT_LIMIT" datasource="#dsn#">
                    SELECT PRICE_CAT FROM COMPANY_CREDIT WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#">
                </cfquery>
                <cfif get_credit_limit.recordcount and len(get_credit_limit.price_cat)>
                    <cfset arguments.price_catid = get_credit_limit.price_cat>
                <cfelse>		
                    <cfquery name="GET_COMP_CAT" datasource="#dsn#">
                        SELECT CONSUMER_CAT_ID FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
                    </cfquery>
                    <cfquery name="GET_PRICE_CAT" datasource="#dsn3#">
                        SELECT PRICE_CATID FROM PRICE_CAT WHERE CONSUMER_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_comp_cat.consumer_cat_id#,%">
                    </cfquery>
                    <cfif get_price_cat.recordcount>
                        <cfset arguments.price_catid=get_price_cat.price_catid>
                    </cfif>
                </cfif>
            </cfif>
            <cfif not len(arguments.price_catid)>
                <cfset arguments.price_catid=-2>
            </cfif>
        </cfif>
        <!---// temsilciye baglı fiyat listesi bulunuyor --->
        <cfquery name="get_all_stock" datasource="#dsn3#">
            SELECT
                PRODUCT_ID,
                STOCK_ID,
                PRODUCT_UNIT_ID,
                TAX,
                PROPERTY,
                PRODUCT_NAME,
                STOCK_CODE,
                STOCK_CODE_2,
                IS_ZERO_STOCK,
                IS_INVENTORY
            FROM
                STOCKS
            WHERE
                STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#">
                AND STOCK_STATUS = 1
                <cfif len(arguments.is_promotion) and is_promotion eq 0>
                    AND IS_SALES = 1
                </cfif>
        </cfquery>
        <cfif get_all_stock.recordcount>
            <cfset row_product_id=get_all_stock.PRODUCT_ID>
            <cfif get_all_stock.IS_ZERO_STOCK neq 1 and get_all_stock.IS_INVENTORY neq 0> <!--- sıfır stokla calış secili degilse ve urun envantere dahilse satılabilir stok miktarı kontrol ediliyor--->
                <cfquery name="get_stock_last" datasource="#dsn3#">
                    #dsn2_alias#.get_stock_last_function '#arguments.stock_id#'
                </cfquery>
                <cfquery name="GET_LAST_STOCKS" dbtype="query">
                    SELECT SALEABLE_STOCK, STOCK_ID FROM get_stock_last WHERE SALEABLE_STOCK > 0
                </cfquery>
                <cfif get_last_stocks.recordcount>
                    <cfset saleable_stock_amount=get_last_stocks.SALEABLE_STOCK>
                <cfelse>
                    <cfset saleable_stock_amount=0>
                </cfif>
                <cfset saleable_stock_id_list_ =get_last_stocks.STOCK_ID>
            <cfelse>
                <cfset get_last_stocks.recordcount=0>
            </cfif>
            <cfif get_last_stocks.recordcount>
                <cfif len(get_last_stocks.SALEABLE_STOCK)>
                    <!--- satılabilir stogu yeterli değilse stratejisi kontrol edilecek  --->
                    <cfset 'use_saleable_stock_#arguments.stock_id#'=get_last_stocks.SALEABLE_STOCK>
                    <cfif get_last_stocks.SALEABLE_STOCK lt arguments.stock_amount>
                        <cfset control_strategy_list_=arguments.stock_id>
                    </cfif>
                </cfif>
            <cfelse>
                <cfset control_strategy_list_=arguments.stock_id>
            </cfif>
            <cfif listlen(control_strategy_list_)><!--- satılabilir stogu yeterli olmayan urunlerin strateji bilgileri alınır --->
                <cfset add_alternative_prod_list_=''>
                <cfquery name="get_all_stock_strategy" datasource="#dsn3#">
                    SELECT 
                        SS.STOCK_ACTION_ID,SS.STOCK_ID,SS.PRODUCT_ID, 
                        STOCK_A.STOCK_ACTION_TYPE
                    FROM 
                        STOCK_STRATEGY SS,
                        SETUP_SALEABLE_STOCK_ACTION STOCK_A
                    WHERE 
                        SS.STOCK_ID IN (#control_strategy_list_#)
                        AND SS.STRATEGY_TYPE = 0
                        AND SS.STOCK_ACTION_ID = STOCK_A.STOCK_ACTION_ID
                </cfquery>
                <cfset stock_strategy_list_=valuelist(get_all_stock_strategy.STOCK_ID)>
                <cfset strategy_stock_id_=arguments.stock_id>
                    <cfset 'row_stock_action_id_#strategy_stock_id_#' = get_all_stock_strategy.STOCK_ACTION_ID>
    
                    <cfset 'row_stock_action_type_#strategy_stock_id_#' = get_all_stock_strategy.STOCK_ACTION_TYPE>
                    <cfif get_all_stock_strategy.STOCK_ACTION_TYPE eq 4> <!--- hareket türü 4 ise alternatif urunleri kontrol edilir --->
                        <cfif listfind(saleable_stock_id_list_,strategy_stock_id_) and isdefined('use_saleable_stock_#strategy_stock_id_#')><!--- satılabilir stogu var ama talebi karsılayamıyorsa, kalan kısım için stratejilere bakılır --->
                            <cfset required_stock_amount=arguments.stock_amount-evaluate('use_saleable_stock_#strategy_stock_id_#')>
                        <cfelse>
                            <cfset required_stock_amount=arguments.stock_amount>
                        </cfif>
                        <cfquery name="get_alternative_prods" datasource="#dsn3#">
                            SELECT
                                AP.ALTERNATIVE_PRODUCT_ID,AP.ALTERNATIVE_PRODUCT_NO,
                                AP.ALTERNATIVE_PRODUCT_AMOUNT,AP.START_DATE,AP.FINISH_DATE,
                                S.STOCK_ID,S.IS_ZERO_STOCK,S.IS_INVENTORY,
                                S.STOCK_ID AS ALTERNATIVE_STOCK_ID
                            FROM
                                ALTERNATIVE_PRODUCTS AP,
                                STOCKS S
                            WHERE
                                S.PRODUCT_ID=AP.ALTERNATIVE_PRODUCT_ID
                                AND AP.PRODUCT_ID IN (SELECT S2.PRODUCT_ID FROM STOCKS S2 WHERE STOCK_ID=#strategy_stock_id_#)
                                AND S.STOCK_STATUS=1
                                AND AP.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(now())#">
                                AND AP.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(DATEADD('d',-1,now()))#">
                                AND S.STOCK_STATUS = 1
                                <cfif len(arguments.is_promotion) and is_promotion eq 0>
                                    AND S.IS_SALES = 1
                                </cfif>
                            ORDER BY AP.ALTERNATIVE_PRODUCT_NO		
                        </cfquery>
                        <cfif get_alternative_prods.recordcount neq 0><!--- satılabilir stogu olan alternatif urun yoksa asıl urunun sıfır stokla calıs parametresi kontrol edilir --->
                            <cfset alternative_stock_list = ''>
                            <cfquery name="get_stock_alternative" datasource="#dsn3#">
                                SELECT SALEABLE_STOCK,STOCK_ID FROM #dsn2_alias#.GET_STOCK_LAST WHERE STOCK_ID IN (#valuelist(get_alternative_prods.ALTERNATIVE_STOCK_ID)#) ORDER BY STOCK_ID
                            </cfquery>
                            <cfset alternative_stock_list = listsort(valuelist(get_stock_alternative.stock_id),'numeric','ASC')>
                            <cfset 'add_alternative_prod_list_#strategy_stock_id_#'="">
                            <cfoutput query="get_alternative_prods">
                                <cfif required_stock_amount neq 0>
                                    <cfif isdefined("alternative_stock_list") and listfindnocase(alternative_stock_list,alternative_stock_id)>
                                        <cfset saleable_stock_amount = get_stock_alternative.SALEABLE_STOCK[listfind(alternative_stock_list,alternative_stock_id)]>
                                    <cfelse>
                                        <cfset saleable_stock_amount = 0>
                                    </cfif>	
                                    <cfif get_alternative_prods.IS_INVENTORY eq 0 or get_alternative_prods.IS_ZERO_STOCK eq 1> <!--- alternatif ürun icins sıfır stokla calıs secilmisse veya envantere dahil degilse --->
                                        <cfset 'add_alternative_prod_list_#strategy_stock_id_#'=listappend(evaluate('add_alternative_prod_list_#strategy_stock_id_#'),get_alternative_prods.ALTERNATIVE_STOCK_ID)>
                                        <cfset 'alternative_prod_amount_#ALTERNATIVE_STOCK_ID#'=Int(get_alternative_prods.ALTERNATIVE_PRODUCT_AMOUNT*required_stock_amount)> <!--- kullanılacak miktar --->
                                        <cfset 'pre_prod_amount_#ALTERNATIVE_STOCK_ID#'=required_stock_amount> <!--- kullanılacak miktar --->
                                        <cfset required_stock_amount=0>
                                    <cfelseif saleable_stock_amount neq 0 and Int(saleable_stock_amount/ALTERNATIVE_PRODUCT_AMOUNT) neq 0> <!--- satılabilir stogu varsa --->
                                        <cfset 'add_alternative_prod_list_#strategy_stock_id_#'=listappend(evaluate('add_alternative_prod_list_#strategy_stock_id_#'),get_alternative_prods.ALTERNATIVE_STOCK_ID)>
                                        <cfif Int(get_alternative_prods.ALTERNATIVE_PRODUCT_AMOUNT*required_stock_amount) gt saleable_stock_amount> <!--- gerekli olan miktar alternatif ürünün satılabilir stogundan fazlaysa --->
                                            <cfset temp_add_amount=Int(saleable_stock_amount/ALTERNATIVE_PRODUCT_AMOUNT)> <!--- alternatif urunun satılabilir stogu asıl urunun için gerekli olan miktarın ne kadarını karıslayabiliyor --->
                                            <cfset 'alternative_prod_amount_#ALTERNATIVE_STOCK_ID#'=temp_add_amount*ALTERNATIVE_PRODUCT_AMOUNT> <!--- kullanılacak miktar --->
                                            <cfset required_stock_amount=required_stock_amount-temp_add_amount>
                                            <cfset 'pre_prod_amount_#ALTERNATIVE_STOCK_ID#'=temp_add_amount> <!---alternatif urunden eklenen miktarın asıl urunden karşılıgı --->
                                        <cfelse>
                                            <cfset 'alternative_prod_amount_#ALTERNATIVE_STOCK_ID#'=Int(get_alternative_prods.ALTERNATIVE_PRODUCT_AMOUNT*required_stock_amount)> <!--- kullanılacak miktar --->
                                            <cfset 'pre_prod_amount_#ALTERNATIVE_STOCK_ID#'=required_stock_amount> <!--- kullanılacak miktar --->
                                            <cfset required_stock_amount=0>
                                        </cfif>
                                    </cfif>
                                </cfif>
                            </cfoutput>
                        <cfelse>
                            <cfquery name="get_action_type" datasource="#dsn3#">
                                SELECT TOP 1 STOCK_ACTION_ID FROM SETUP_SALEABLE_STOCK_ACTION WHERE STOCK_ACTION_TYPE = 1
                            </cfquery>
                            <cfset 'row_stock_action_id_#strategy_stock_id_#' = get_action_type.stock_action_id>
                            <cfset 'row_stock_action_type_#strategy_stock_id_#' = 1> <!--- hareket türü 4 oldugu halde yeterli stokta alternatif ürünü yoksa hareket turu 1 set edilir --->
                        </cfif>
                    </cfif>
            </cfif>
            <cfset add_stock_list_=''>
            <cfscript>
                add_row_info = QueryNew("STOCK_ID,AMOUNT,PRE_PRODUCT_ID,PRE_STOCK_ID,PRE_STOCK_AMOUNT,STOCK_ACTION_ID,STOCK_ACTION_TYPE","Integer,Double,Integer,Integer,Double,Integer,Integer");
                add_row_info_count = 0;
                /*for(list_i=1; list_i lte listlen(list_stock_id_);list_i=list_i+1)
                {*/
                    temp_stock_id=arguments.stock_id;
                    'is_finish_#temp_stock_id#'=0;
                    if(get_all_stock.IS_INVENTORY eq 0 or get_all_stock.IS_ZERO_STOCK eq 1) //envantere dahil degilse veya sıfır stokla calısıyorsa tumu eklenir
                    {
                        add_row_info_count = add_row_info_count + 1;
                        QueryAddRow(add_row_info,1);
                        QuerySetCell(add_row_info,"STOCK_ID",temp_stock_id,add_row_info_count);
                        QuerySetCell(add_row_info,"PRE_STOCK_ID",temp_stock_id,add_row_info_count);
                        QuerySetCell(add_row_info,"PRE_PRODUCT_ID",row_product_id,add_row_info_count);
                        QuerySetCell(add_row_info,"AMOUNT",arguments.stock_amount,add_row_info_count);
                        QuerySetCell(add_row_info,"PRE_STOCK_AMOUNT",arguments.stock_amount,add_row_info_count);
                        'is_finish_#temp_stock_id#'=1;
                    }
                    else if(listfind(saleable_stock_id_list_,temp_stock_id)) //satılabilir stogu varsa
                    {
                        add_row_info_count = add_row_info_count + 1;
                        QueryAddRow(add_row_info,1);
                        QuerySetCell(add_row_info,"STOCK_ID",temp_stock_id,add_row_info_count);
                        QuerySetCell(add_row_info,"PRE_PRODUCT_ID",row_product_id,add_row_info_count);
                        QuerySetCell(add_row_info,"PRE_STOCK_ID",temp_stock_id,add_row_info_count);
                            if(len(get_last_stocks.SALEABLE_STOCK) and get_last_stocks.SALEABLE_STOCK lt arguments.stock_amount)
                            {
                                QuerySetCell(add_row_info,"AMOUNT",get_last_stocks.SALEABLE_STOCK,add_row_info_count);
                                QuerySetCell(add_row_info,"PRE_STOCK_AMOUNT",get_last_stocks.SALEABLE_STOCK,add_row_info_count);
                            }
                            else
                            {
                                QuerySetCell(add_row_info,"AMOUNT",arguments.stock_amount,add_row_info_count);
                                QuerySetCell(add_row_info,"PRE_STOCK_AMOUNT",arguments.stock_amount,add_row_info_count);
                                'is_finish_#temp_stock_id#'=1;
                            }
                    }
                    if(evaluate('is_finish_#temp_stock_id#') neq 1 and listfind(stock_strategy_list_,temp_stock_id)) //satılabilir stogu yeterli olmayıp stok stratejisine gore eklenecek urunler
                    {
                        if( isdefined('row_stock_action_type_#temp_stock_id#') and evaluate('row_stock_action_type_#temp_stock_id#') eq 4 and isdefined('add_alternative_prod_list_#temp_stock_id#') and len(evaluate('add_alternative_prod_list_#temp_stock_id#'))) //stratejiye gore hareket turu alternatif urun verilir ise, urun miktarını karsılayacak kadar alternatif urunlerinden eklenir
                        {
                            for(kk=1; kk lte listlen(evaluate('add_alternative_prod_list_#temp_stock_id#'));kk=kk+1) //alternatif urunler ekleniyor
                            {
                                temp_alter_stock_id_=listgetat(evaluate('add_alternative_prod_list_#temp_stock_id#'),kk);
                                add_row_info_count = add_row_info_count + 1;
                                QueryAddRow(add_row_info,1);
                                QuerySetCell(add_row_info,"STOCK_ID",temp_alter_stock_id_,add_row_info_count);
                                QuerySetCell(add_row_info,"PRE_STOCK_ID",temp_stock_id,add_row_info_count); //alternatifi eklenen asıl urunu bu alanda tutuyoruz
                                QuerySetCell(add_row_info,"PRE_PRODUCT_ID",row_product_id,add_row_info_count);
                                QuerySetCell(add_row_info,"PRE_STOCK_AMOUNT",evaluate('pre_prod_amount_#temp_alter_stock_id_#'),add_row_info_count);
                                QuerySetCell(add_row_info,"STOCK_ACTION_ID",evaluate('row_stock_action_id_#temp_stock_id#'),add_row_info_count);
                                QuerySetCell(add_row_info,"STOCK_ACTION_TYPE",evaluate('row_stock_action_type_#temp_stock_id#'),add_row_info_count);
                                QuerySetCell(add_row_info,"AMOUNT",evaluate('alternative_prod_amount_#temp_alter_stock_id_#'),add_row_info_count);
                            }
                        }
                        else if(evaluate('is_finish_#temp_stock_id#') neq 1 and isdefined('row_stock_action_type_#temp_stock_id#') and listfind('1,2,3',evaluate('row_stock_action_type_#temp_stock_id#')) )
                        {
                            add_row_info_count = add_row_info_count + 1;
                            QueryAddRow(add_row_info,1);
                            QuerySetCell(add_row_info,"STOCK_ID",temp_stock_id,add_row_info_count);
                            QuerySetCell(add_row_info,"PRE_STOCK_ID",temp_stock_id,add_row_info_count);
                            QuerySetCell(add_row_info,"PRE_PRODUCT_ID",row_product_id,add_row_info_count);
                            QuerySetCell(add_row_info,"STOCK_ACTION_ID",evaluate('row_stock_action_id_#temp_stock_id#'),add_row_info_count);
                            QuerySetCell(add_row_info,"STOCK_ACTION_TYPE",evaluate('row_stock_action_type_#temp_stock_id#'),add_row_info_count);
                            if( listfind(saleable_stock_id_list_,temp_stock_id) and isdefined('use_saleable_stock_#temp_stock_id#'))
                            {
                                QuerySetCell(add_row_info,"AMOUNT",(arguments.stock_amount-evaluate('use_saleable_stock_#temp_stock_id#')),add_row_info_count);
                                QuerySetCell(add_row_info,"PRE_STOCK_AMOUNT",(arguments.stock_amount-evaluate('use_saleable_stock_#temp_stock_id#')),add_row_info_count);
                            }
                            else
                            {
                                QuerySetCell(add_row_info,"AMOUNT",arguments.stock_amount,add_row_info_count);
                                QuerySetCell(add_row_info,"PRE_STOCK_AMOUNT",arguments.stock_amount,add_row_info_count);
                            }
                        }
                    }
                    else if(not listfind(saleable_stock_id_list_,temp_stock_id) and get_all_stock.IS_ZERO_STOCK neq 1 and get_all_stock.IS_INVENTORY neq 0)
                        not_added_stock_code_list=listappend(not_added_stock_code_list,get_all_stock.STOCK_CODE);
                //}
            </cfscript>
        <cfelse>
            <cfset add_row_info.recordcount=0>
            <cfif arguments.is_promotion neq 1><!--- promosyon urunu ekleme degilse --->
                <script type="text/javascript">
                    alert("Ürün Kaydı Bulunamadı'> !");
                </script>
            </cfif>
        </cfif>
        <cfif listlen(not_added_stock_code_list) neq 0>
            <cfif arguments.is_promotion neq 1>
                <script type="text/javascript">
                    alert("<cfoutput>#not_added_stock_code_list#</cfoutput> Stok Kodlu Ürünün Yeterli Stoğu Bulunmamaktadır!");
                </script>
            </cfif>
        </cfif>
        <cfif add_row_info.recordcount>
            <cfset add_row_stock_id_list = valuelist(add_row_info.STOCK_ID)>
            <cfquery name="get_last_stock_info" datasource="#dsn3#">
                SELECT
                    PRODUCT_ID,
                    STOCK_ID,
                    PRODUCT_UNIT_ID,
                    TAX,
                    PROPERTY,
                    PRODUCT_NAME,
                    STOCK_CODE,
                    IS_ZERO_STOCK
                FROM
                    STOCKS
                WHERE
                    STOCK_ID IN (#add_row_stock_id_list#)
                ORDER BY STOCK_ID
            </cfquery>
            <cfset add_row_stock_id_list = valuelist(get_last_stock_info.STOCK_ID)>
            <cfset add_basket_express_prod_id_list = valuelist(add_row_info.PRE_PRODUCT_ID)><!--- fiyatlar asıl urunlere gore alınıyor, alternatif urun içinde yerine eklendigi asıl urunun fiyatı getiriliyor --->
            
            <!--- //urunlere ait fiyatlar cekiliyor --->
            <cfif not isdefined("get_price_all.recordcount")>
                <cfquery name="GET_PRICE_EXCEPTIONS_ALL" datasource="#dsn3#">
                    SELECT
                        *
                    FROM 
                        PRICE_CAT_EXCEPTIONS
                    WHERE
                        ACT_TYPE = 1 AND
                    <cfif isdefined("arguments.company_id") and len(arguments.company_id)>
                        COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
                    <cfelseif isdefined("arguments.consumer_id") and len(arguments.consumer_id)>
                        CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
                    <cfelse>
                        1=0
                    </cfif>	
                </cfquery>
                <cfquery name="get_price_exceptions_pid" dbtype="query">
                    SELECT * FROM GET_PRICE_EXCEPTIONS_ALL WHERE PRODUCT_ID IS NOT NULL
                </cfquery>
                <cfquery name="get_price_exceptions_pcatid" dbtype="query">
                    SELECT * FROM GET_PRICE_EXCEPTIONS_ALL WHERE PRODUCT_CATID IS NOT NULL
                </cfquery>
                <cfquery name="get_price_exceptions_brid" dbtype="query">
                    SELECT * FROM GET_PRICE_EXCEPTIONS_ALL WHERE BRAND_ID IS NOT NULL
                </cfquery>
                <cfquery name="get_price_all" datasource="#dsn3#">
                    SELECT  
                        P.CATALOG_ID,
                        P.UNIT,
                        P.PRICE PRICE,
                        P.PRICE_KDV,
                        P.PRODUCT_ID,
                        P.MONEY,
                        P.PRICE_CATID
                    FROM 
                        PRICE P,
                        PRODUCT PR,
                        PRODUCT_CAT
                    WHERE 
                        PRICE > 0 AND
                        <cfif isdefined('add_basket_express_prod_id_list') and len(add_basket_express_prod_id_list)> <!--- hızlı siparis sayfasından cagrılıyorsa --->
                        PR.PRODUCT_ID IN (#add_basket_express_prod_id_list#) AND 
                        </cfif>
                        PRODUCT_CAT.PRODUCT_CATID = PR.PRODUCT_CATID AND 
                        P.PRODUCT_ID = PR.PRODUCT_ID AND 
                        ISNULL(P.STOCK_ID,0)=0 AND
                        ISNULL(P.SPECT_VAR_ID,0)=0 AND
                        P.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.price_catid#"> AND
                        (
                            P.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
                            (P.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> OR P.FINISHDATE IS NULL)
                        )
                        AND
                        (
                        <cfif get_price_exceptions_pid.recordcount or get_price_exceptions_pcatid.recordcount or get_price_exceptions_brid.recordcount>
                            <cfif get_price_exceptions_pid.recordcount>
                                P.PRODUCT_ID NOT IN (#valuelist(get_price_exceptions_pid.PRODUCT_ID)#)
                            </cfif>
                            <cfif get_price_exceptions_pcatid.recordcount>
                                <cfif get_price_exceptions_pid.recordcount>AND </cfif> PR.PRODUCT_CATID NOT IN (#valuelist(get_price_exceptions_pcatid.PRODUCT_CATID)#)
                            </cfif>
                            <cfif get_price_exceptions_brid.recordcount>
                                <cfif get_price_exceptions_pid.recordcount or get_price_exceptions_pcatid.recordcount>AND </cfif> 
                                (PR.BRAND_ID NOT IN (#valuelist(get_price_exceptions_brid.BRAND_ID)#) OR PR.BRAND_ID IS NULL )
                            </cfif>
                        <cfelse>
                        1=1
                        </cfif>
                        )
                    <cfif get_price_exceptions_pid.recordcount>
                    UNION
                    SELECT 
                        CATALOG_ID,
                        UNIT,
                        PRICE,
                        PRICE_KDV,
                        PRODUCT_ID,
                        MONEY,
                        PRICE_CATID
                    FROM
                        PRICE
                    WHERE
                        PRICE > 0 AND
                        <cfif isdefined('add_basket_express_prod_id_list') and len(add_basket_express_prod_id_list)> <!--- hızlı siparis sayfasından cagrılıyorsa --->
                        PRODUCT_ID IN (#add_basket_express_prod_id_list#) AND 
                        </cfif>
                        ISNULL(STOCK_ID,0)=0 AND
                        ISNULL(SPECT_VAR_ID,0)=0 AND
                        STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
                        (FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> OR FINISHDATE IS NULL) AND
                        <cfif get_price_exceptions_pid.recordcount gt 1>(</cfif>
                            <cfoutput query="get_price_exceptions_pid">
                            (PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#"> AND PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRICE_CATID#">)
                            <cfif get_price_exceptions_pid.recordcount neq get_price_exceptions_pid.currentrow>
                            OR
                            </cfif>
                            </cfoutput>
                        <cfif get_price_exceptions_pid.recordcount gt 1>)</cfif>
                    </cfif>
                    <cfif get_price_exceptions_pcatid.recordcount>
                    UNION
                    SELECT
                        P.CATALOG_ID,
                        P.UNIT,
                        P.PRICE PRICE,
                        P.PRICE_KDV,
                        P.PRODUCT_ID,
                        P.MONEY,
                        P.PRICE_CATID
                    FROM
                        PRICE P,
                        PRODUCT PR
                    WHERE 
                        PRICE > 0 AND
                        <cfif isdefined('add_basket_express_prod_id_list') and len(add_basket_express_prod_id_list)> <!--- hızlı siparis sayfasından cagrılıyorsa --->
                        PR.PRODUCT_ID IN (#add_basket_express_prod_id_list#) AND 
                        </cfif>
                        <cfif get_price_exceptions_pid.recordcount>
                        P.PRODUCT_ID NOT IN (#valuelist(get_price_exceptions_pid.PRODUCT_ID)#) AND
                        </cfif>
                        P.PRODUCT_ID = PR.PRODUCT_ID AND
                        ISNULL(P.STOCK_ID,0)=0 AND
                        ISNULL(P.SPECT_VAR_ID,0)=0 AND
                        P.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
                        (P.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> OR P.FINISHDATE IS NULL) AND
                        <cfif get_price_exceptions_pcatid.recordcount gt 1>(</cfif>
                        <cfoutput query="get_price_exceptions_pcatid">
                        (PR.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_CATID#"> AND P.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRICE_CATID#">)
                        <cfif get_price_exceptions_pcatid.recordcount neq get_price_exceptions_pcatid.currentrow>
                        OR
                        </cfif>
                        </cfoutput>
                        <cfif get_price_exceptions_pcatid.recordcount gt 1>)</cfif>
                    </cfif>
                    <cfif get_price_exceptions_brid.recordcount>
                    UNION
                    SELECT
                        P.CATALOG_ID,
                        P.UNIT,
                        P.PRICE PRICE,
                        P.PRICE_KDV,
                        P.PRODUCT_ID,
                        P.MONEY,
                        P.PRICE_CATID
                    FROM
                        PRICE P,
                        PRODUCT PR
                    WHERE 
                        PRICE > 0 AND
                        <cfif isdefined('add_basket_express_prod_id_list') and len(add_basket_express_prod_id_list)> <!--- hızlı siparis sayfasından cagrılıyorsa --->
                        PR.PRODUCT_ID IN (#add_basket_express_prod_id_list#) AND 
                        </cfif>
                        <cfif get_price_exceptions_pid.recordcount>
                        P.PRODUCT_ID NOT IN (#valuelist(get_price_exceptions_pid.PRODUCT_ID)#) AND
                        </cfif>
                        <cfif get_price_exceptions_pcatid.recordcount>
                        PR.PRODUCT_CATID NOT IN (#valuelist(get_price_exceptions_pcatid.PRODUCT_CATID)#) AND
                        </cfif>
                        P.PRODUCT_ID = PR.PRODUCT_ID AND
                        ISNULL(P.STOCK_ID,0)=0 AND
                        ISNULL(P.SPECT_VAR_ID,0)=0 AND
                        P.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
                        (P.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> OR P.FINISHDATE IS NULL) AND
                        <cfif get_price_exceptions_brid.recordcount gt 1>(</cfif>
                        <cfoutput query="get_price_exceptions_brid">
                        (PR.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#BRAND_ID#"> AND P.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#PRICE_CATID#">)
                        <cfif get_price_exceptions_brid.recordcount neq get_price_exceptions_brid.currentrow>
                        OR
                        </cfif>
                        </cfoutput>
                        <cfif get_price_exceptions_brid.recordcount gt 1>)</cfif>
                    </cfif>
                </cfquery>
            </cfif>
            <!--- //urunlere ait fiyatlar cekiliyor --->
            
            <cfquery name="get_all_price_standart" datasource="#dsn3#">
                SELECT
                    PRICE_STANDART.PRODUCT_ID,
                    PRICE,
                    PRICE_KDV,
                    IS_KDV,
                    MONEY 
                FROM 
                    PRICE_STANDART,
                    PRODUCT_UNIT
                WHERE
                    PRICE_STANDART.PURCHASESALES = 1 AND
                    PRODUCT_UNIT.IS_MAIN = 1 AND 
                    PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
                    PRICE_STANDART.PRODUCT_ID = PRODUCT_UNIT.PRODUCT_ID AND
                    PRICE_STANDART.PRODUCT_ID IN (#add_basket_express_prod_id_list#)
            </cfquery>
            <cfoutput query="add_row_info">
                <cfquery name="GET_PRICE" dbtype="query">
                    SELECT PRICE, PRICE_KDV, IS_KDV, MONEY FROM get_all_price_standart WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#add_row_info.PRE_PRODUCT_ID#">
                </cfquery>
                <cfif get_price_all.recordcount>
                    <cfquery name="get_p" dbtype="query">
                        SELECT * FROM get_price_all WHERE UNIT = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_all_stock.PRODUCT_UNIT_ID#"> AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_all_stock.PRODUCT_ID#">
                    </cfquery>
                <cfelse>
                    <cfset get_p.recordcount=0>
                </cfif>
                <cfif is_promotion neq 1> <!--- promosyon olarak eklenecek urun degilse sepette olup olmadıgı kontrol ediliyor, promosyonlar kendi dosyalarında kontrol ediliyor --->
                    <cfquery name="control_same_prod_exists" datasource="#dsn3#">
                        SELECT 
                            ORDER_ROW_ID,QUANTITY,PRE_STOCK_AMOUNT
                        FROM
                            ORDER_PRE_ROWS
                        WHERE
                            STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#add_row_info.stock_id#">
                            AND ISNULL(PRE_STOCK_ID,STOCK_ID)=#add_row_info.pre_stock_id# <!--- asıl urun ve alternatif urun bazında kontrol ediliyor --->
                            AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#add_row_info.pre_product_id#">
                            <cfif get_p.recordcount>
                                AND PRICE = <cfqueryparam cfsqltype="cf_sql_float" value="#get_p.price#">
                                AND PRICE_KDV = <cfqueryparam cfsqltype="cf_sql_float" value="#get_p.price_kdv#">
                                AND PRICE_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_p.money#">
                            <cfelse>
                                AND PRICE = <cfqueryparam cfsqltype="cf_sql_float" value="#get_price.price#">
                                AND PRICE_KDV = <cfqueryparam cfsqltype="cf_sql_float" value="#get_price.price_kdv#">
                                AND PRICE_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_price.money#">
                            </cfif>
                            <cfif len(add_row_info.stock_action_type)>
                                AND	STOCK_ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#add_row_info.stock_action_type#">
                            <cfelse>
                                AND STOCK_ACTION_TYPE IS NULL
                            </cfif>
                                AND PRODUCT_UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_last_stock_info.PRODUCT_UNIT_ID#">
                                AND ISNULL(IS_PROM_ASIL_HEDIYE,0)=0
                                AND ISNULL(IS_COMMISSION,0)=0
                            <cfif isdefined('arguments.consumer_id') and len(arguments.consumer_id)>
                                AND TO_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
                            <cfelse>
                                AND TO_CONS IS NULL
                            </cfif>
                            <cfif isdefined('arguments.company_id') and len(arguments.company_id)>
                                AND TO_COMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
                            <cfelse>
                                AND TO_COMP IS NULL
                            </cfif>
                            <cfif isdefined('arguments.partner_id') and len(arguments.partner_id)>
                                AND TO_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#">
                            <cfelse>
                                AND TO_PAR IS NULL
                            </cfif>
                                AND RECORD_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
                            <cfif isdefined("session.pp")>AND RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"><cfelse>AND RECORD_PAR IS NULL</cfif>
                            <cfif isdefined("session.ww.userid")>AND RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"><cfelse>AND RECORD_CONS IS NULL</cfif>
                            <cfif isdefined("session.ep.userid")>AND RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"><cfelse>AND RECORD_EMP IS NULL</cfif>
                    </cfquery>
                <cfelse>
                    <cfset control_same_prod_exists.recordcount=0>
                </cfif>
                <cfif control_same_prod_exists.recordcount>
                    <cfquery name="upd_main_product_" datasource="#dsn3#">
                        UPDATE 
                            ORDER_PRE_ROWS
                        SET
                            QUANTITY=#control_same_prod_exists.QUANTITY+add_row_info.amount#,
                            PRE_STOCK_AMOUNT=#control_same_prod_exists.PRE_STOCK_AMOUNT+add_row_info.amount#
                        WHERE
                            ORDER_ROW_ID=#control_same_prod_exists.ORDER_ROW_ID#
                            AND STOCK_ID=#add_row_info.stock_id#
                            AND PRE_STOCK_ID=#add_row_info.pre_stock_id#
                    </cfquery>
                <cfelse>
                    <cfif isdefined('arguments.PRICE') and len(arguments.PRICE) and len(get_last_stock_info.TAX[listfind(add_row_stock_id_list,add_row_info.stock_id)]) and get_last_stock_info.TAX[listfind(add_row_stock_id_list,add_row_info.stock_id)] neq 0>
                        <cfset arguments.PRICE=wrk_round(((arguments.PRICE/(100+get_last_stock_info.TAX[listfind(add_row_stock_id_list,add_row_info.stock_id)]))*100),4)>
                    </cfif>
    
                    <cfquery name="add_main_product_" datasource="#dsn3#">
                        INSERT INTO
                            ORDER_PRE_ROWS
                        (
                            PROM_WORK_TYPE,
                            IS_NONDELETE_PRODUCT,
                            IS_PRODUCT_PROMOTION_NONEFFECT,
                            CATALOG_ID,
                            IS_GENERAL_PROM,
                            PROM_PRODUCT_PRICE,
                            PROM_COST,
                            PROM_ID,
                            PRE_PRODUCT_ID,
                            PRE_STOCK_ID,
                            PRE_STOCK_AMOUNT,
                            PRODUCT_ID,
                            PRODUCT_NAME,
                            QUANTITY,
                            PRICE,
                            PRICE_KDV,
                            PRICE_MONEY,
                            TAX,
                            STOCK_ID,
                            STOCK_ACTION_ID,
                            STOCK_ACTION_TYPE,
                            PRODUCT_UNIT_ID,
                            PROM_STOCK_AMOUNT,
                            IS_PROM_ASIL_HEDIYE,
                            PROM_FREE_STOCK_ID,
                            IS_COMMISSION,
                            PRICE_STANDARD,
                            PRICE_STANDARD_KDV,
                            PRICE_STANDARD_MONEY,
                            TO_CONS,
                            TO_COMP,
                            TO_PAR,
                            RECORD_PERIOD_ID,
                            RECORD_PAR,
                            RECORD_CONS,
                            RECORD_EMP,
                            RECORD_GUEST,
                            COOKIE_NAME,
                            SALE_PARTNER_ID,
                            SALE_CONSUMER_ID,
                            PROD_PROM_ACTION_TYPE,
                            RECORD_IP,
                            RECORD_DATE
                        )
                            VALUES
                        (
                            <cfif isdefined('arguments.PROM_WORK_TYPE') and len(arguments.PROM_WORK_TYPE)>#PROM_WORK_TYPE#<cfelse>NULL</cfif>,
                            <cfif isdefined('arguments.IS_NONDELETE_PRODUCT') and len(arguments.IS_NONDELETE_PRODUCT)>#IS_NONDELETE_PRODUCT#<cfelse>0</cfif>,
                            <cfif isdefined('arguments.IS_PRODUCT_PROMOTION_NONEFFECT') and len(arguments.IS_PRODUCT_PROMOTION_NONEFFECT)>#arguments.IS_PRODUCT_PROMOTION_NONEFFECT#<cfelse>NULL</cfif>,
                            <cfif isdefined('arguments.CATALOG_ID') and len(arguments.CATALOG_ID)>#arguments.CATALOG_ID#<cfelse>NULL</cfif>,
                            <cfif isdefined('arguments.IS_GENERAL_PROM') and len(arguments.IS_GENERAL_PROM)>#arguments.IS_GENERAL_PROM#<cfelse>NULL</cfif>,
                            <cfif isdefined('arguments.PROM_PRODUCT_PRICE') and len(arguments.PROM_PRODUCT_PRICE)>#arguments.PROM_PRODUCT_PRICE#<cfelse>NULL</cfif>,
                            <cfif isdefined('arguments.PROM_COST') and len(arguments.PROM_COST)>#arguments.PROM_COST#<cfelse>NULL</cfif>,
                            <cfif isdefined('arguments.PROM_ID') and len(arguments.PROM_ID)>#arguments.PROM_ID#<cfelse>NULL</cfif>,
                            <cfif len(add_row_info.PRE_PRODUCT_ID)>#add_row_info.PRE_PRODUCT_ID#<cfelse>#get_last_stock_info.PRODUCT_ID[listfind(add_row_stock_id_list,add_row_info.stock_id)]#</cfif>,
                            <cfif len(add_row_info.PRE_STOCK_ID)>#add_row_info.PRE_STOCK_ID#<cfelse>#get_last_stock_info.STOCK_ID[listfind(add_row_stock_id_list,add_row_info.stock_id)]#</cfif>,
                            <cfif len(add_row_info.PRE_STOCK_AMOUNT)>#add_row_info.PRE_STOCK_AMOUNT#<cfelse>#add_row_info.amount#</cfif>,
                            #get_last_stock_info.PRODUCT_ID[listfind(add_row_stock_id_list,add_row_info.stock_id)]#,
                            <cfif trim(get_last_stock_info.PROPERTY[listfind(add_row_stock_id_list,add_row_info.stock_id)]) is '-'>'#get_last_stock_info.PRODUCT_NAME[listfind(add_row_stock_id_list,add_row_info.stock_id)]#'<cfelse>'#get_last_stock_info.PRODUCT_NAME[listfind(add_row_stock_id_list,add_row_info.stock_id)]# #get_last_stock_info.PROPERTY[listfind(add_row_stock_id_list,add_row_info.stock_id)]#'</cfif>,
                            #add_row_info.amount#,
                            <cfif arguments.is_promotion eq 1>
                                <cfif add_row_info.PRE_STOCK_ID neq add_row_info.stock_id and len(add_row_info.PRE_STOCK_AMOUNT) and add_row_info.PRE_STOCK_AMOUNT neq 0>
                                    <cfif isdefined('arguments.PRICE') and len(arguments.PRICE)>
                                    #wrk_round(arguments.PRICE/(add_row_info.amount/add_row_info.PRE_STOCK_AMOUNT))#
                                    <cfelse>NULL</cfif>,
                                    <cfif isdefined('arguments.PRICE_KDV') and len(arguments.PRICE_KDV)>
                                    #wrk_round(arguments.PRICE_KDV/(add_row_info.amount/add_row_info.PRE_STOCK_AMOUNT))#
                                    <cfelse>NULL</cfif>,
                                <cfelse>
                                    <cfif isdefined('arguments.PRICE') and len(arguments.PRICE)>#arguments.PRICE#<cfelse>NULL</cfif>,
                                    <cfif isdefined('arguments.PRICE_KDV') and len(arguments.PRICE_KDV)>#arguments.PRICE_KDV#<cfelse>NULL</cfif>,
                                </cfif>
                                <cfif isdefined('arguments.PRICE_MONEY') and len(arguments.PRICE_MONEY)>'#arguments.PRICE_MONEY#'<cfelse>NULL</cfif>,
                            <cfelse>
                                <cfif get_p.recordcount>
                                    #get_p.PRICE#,
                                    #get_p.PRICE_KDV#,
                                    '#get_p.MONEY#',
                                <cfelse>
                                    #GET_PRICE.PRICE#,
                                    #GET_PRICE.PRICE_KDV#,
                                    '#GET_PRICE.MONEY#',
                                </cfif>
                            </cfif>
                            #get_last_stock_info.TAX[listfind(add_row_stock_id_list,add_row_info.stock_id)]#,
                            #add_row_info.stock_id#,
                            <cfif len(add_row_info.stock_action_id)>#add_row_info.stock_action_id#<cfelse>0</cfif>,
                            <cfif len(add_row_info.stock_action_type)>#add_row_info.stock_action_type#<cfelse>NULL</cfif>,
                            #get_last_stock_info.PRODUCT_UNIT_ID[listfind(add_row_stock_id_list,add_row_info.stock_id)]#,
                            <cfif arguments.is_promotion eq 1>
                                <cfif isdefined('arguments.PROM_STOCK_AMOUNT') and len(arguments.PROM_STOCK_AMOUNT)>#arguments.PROM_STOCK_AMOUNT#<cfelse>NULL</cfif>,
                                <cfif isdefined('arguments.IS_PROM_ASIL_HEDIYE') and len(arguments.IS_PROM_ASIL_HEDIYE)>#arguments.IS_PROM_ASIL_HEDIYE#<cfelse>NULL</cfif>,
                                <cfif isdefined('arguments.PROM_FREE_STOCK_ID') and len(arguments.PROM_FREE_STOCK_ID)>#arguments.PROM_FREE_STOCK_ID#<cfelse>NULL</cfif>,
                            <cfelse>
                                1,
                                0,
                                0,
                            </cfif>
                            0, <!--- komisyon satırı mı --->
                            <cfif arguments.is_promotion eq 1>
                                <cfif add_row_info.PRE_STOCK_ID neq add_row_info.stock_id and len(add_row_info.PRE_STOCK_AMOUNT) and add_row_info.PRE_STOCK_AMOUNT neq 0>
                                    <cfif isdefined('arguments.PRICE_STANDARD') and len(arguments.PRICE_STANDARD)>#wrk_round(arguments.PRICE_STANDARD/(add_row_info.amount/add_row_info.PRE_STOCK_AMOUNT))#<cfelse>NULL</cfif>,
                                    <cfif isdefined('arguments.PRICE_STANDARD_KDV') and len(arguments.PRICE_STANDARD_KDV)>#wrk_round(arguments.PRICE_STANDARD_KDV/(add_row_info.amount/add_row_info.PRE_STOCK_AMOUNT))#<cfelse>NULL</cfif>,
                                <cfelse>
                                    <cfif isdefined('arguments.PRICE_STANDARD') and len(arguments.PRICE_STANDARD)>#arguments.PRICE_STANDARD#<cfelse>NULL</cfif>,
                                    <cfif isdefined('arguments.PRICE_STANDARD_KDV') and len(arguments.PRICE_STANDARD_KDV)>#arguments.PRICE_STANDARD_KDV#<cfelse>NULL</cfif>,
                                </cfif>
                                <cfif isdefined('arguments.PRICE_STANDARD_MONEY') and len(arguments.PRICE_STANDARD_MONEY)>'#arguments.PRICE_STANDARD_MONEY#'<cfelse>NULL</cfif>,
                            <cfelse>
                                #GET_PRICE.PRICE#,
                                #GET_PRICE.PRICE_KDV#,
                                '#GET_PRICE.MONEY#',
                            </cfif>
                            <cfif isdefined('arguments.consumer_id') and len(arguments.consumer_id)>#arguments.consumer_id#<cfelse>NULL</cfif>,
                            <cfif isdefined('arguments.company_id') and len(arguments.company_id)>#arguments.company_id#<cfelse>NULL</cfif>,
                            <cfif isdefined('arguments.partner_id') and len(arguments.partner_id)>#arguments.partner_id#<cfelse>NULL</cfif>,
                            #session_base.period_id#,
                            <cfif isdefined("session.pp")>#session.pp.userid#<cfelse>NULL</cfif>,
                            <cfif isdefined("session.ww.userid")>#session.ww.userid#<cfelse>NULL</cfif>,
                            <cfif isdefined("session.ep.userid")>#session.ep.userid#<cfelse>NULL</cfif>,
                            <cfif not isdefined("session.pp") and not isdefined("session.ww.userid") and not isdefined("session.ep.userid")>1<cfelse>0</cfif>,
                            <cfif isdefined("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")>'#evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#'<cfelse>NULL</cfif>,
                            <cfif isdefined('arguments.sales_member_id') and len(arguments.sales_member_id) and arguments.sales_member_type is 'partner'>#arguments.sales_member_id#<cfelse>NULL</cfif>,
                            <cfif isdefined('arguments.sales_cons_id') and len(arguments.sales_cons_id) and arguments.sales_member_type is 'consumer'>#arguments.sales_cons_id#<cfelse>NULL</cfif>,
                            <cfif isdefined('arguments.prod_prom_action_type') and len(arguments.prod_prom_action_type)>#arguments.prod_prom_action_type#<cfelse>0</cfif>,
                            '#cgi.remote_addr#',
                            #now()#
                        )
                    </cfquery>
                </cfif>
            </cfoutput>
        </cfif>
        <cfif fusebox.use_stock_speed_reserve><!--- sipariste anında urun rezerve calısıyorsa, sepetteki urunlerin rezerveleri de siliniyor --->
            <cfinclude template="../../objects2/query/get_basket_rows.cfm">
            <!---<cfquery name="del_reserve_rows" datasource="#dsn3#">
                DELETE FROM ORDER_ROW_RESERVED WHERE PRE_ORDER_ID='#CFTOKEN#'
            </cfquery>--->
            <cfstoredproc procedure="DEL_ORDER_ROW_RESERVED" datasource="#dsn3#">
                <cfprocparam cfsqltype="cf_sql_varchar" value="#CFTOKEN#">
            </cfstoredproc>
            <cfoutput query="get_rows">
                <!--- Stok stratejisine göre action_type ı 1,2,3 olmayanlara rezerve yapılıyor --->
                <cfif (len(get_rows.STOCK_ACTION_TYPE) and not listfind('1,2,3',get_rows.STOCK_ACTION_TYPE,',')) or not len(get_rows.STOCK_ACTION_TYPE)>
                    <cfquery name="add_reserve_" datasource="#dsn3#">
                        INSERT INTO 
                            ORDER_ROW_RESERVED
                            (
                                STOCK_ID,
                                PRODUCT_ID,
                                RESERVE_STOCK_OUT,
                                ORDER_ROW_ID,
                                PRE_ORDER_ID,
                                IS_BASKET
                            ) 
                            VALUES
                            (
                                #get_rows.STOCK_ID#,
                                #get_rows.PRODUCT_ID#,
                                #QUANTITY#,
                                #ORDER_ROW_ID#,
                                '#CFTOKEN#',
                                1				
                            )
                    </cfquery>
                </cfif>
            </cfoutput>
        </cfif>
        <cfreturn true>
	</cffunction>
    
<!---add_ship_row_relation--->
<!--- FATURAYA VEYA IRSALIYEYE CEKILEN KONSINYE IRSALIYE SATIRLARINI KAYDEDER--->
	<cffunction name="add_ship_row_relation" returntype="boolean" output="false">
        <cfargument name="to_related_process_id" required="yes" default=""> <!---to_ship_id aktif donemdeki irsaliye. bu irsaliyeye konsinye irsaliyesi cekilir.--->
        <cfargument name="to_related_process_type"><!--- to_ship_type --->
        <cfargument name="old_related_process_type"><!---old_to_ship_type guncelleme ve silme islemlerinde kullanılır --->
        <cfargument name="ship_related_action_type" required="yes" type="numeric"> <!--- 0: ekleme 1: guncelleme 2: silme --->
        <cfargument name="is_related_action_iptal"> <!--- ilgili işlem iptal --->
        <cfargument name="is_invoice_ship" required="yes" default="1"> <!--- 0: invoice , 1: irsaliye işlemlerinden cagrılıyor --->
        <cfargument name="process_db" required="yes" default="#dsn3#" type="string">
        <cfargument name="process_db_alias" type="string">
        <cfif arguments.process_db is not 'dsn2'>
            <cfset arguments.process_db_alias = '#dsn2_alias#.'>
        <cfelse>
            <cfset arguments.process_db_alias = ''>
        </cfif>
        <cfset related_ships = "">
        <cfset related_ship_periods = "">
        <cfif listfind('1,2',arguments.ship_related_action_type) and len(arguments.to_related_process_id)><!--- guncelleme ve silme islemleri --->
            <!--- guncelleme ve silme islemlerinden cagrıldıgında kayıtlar temizleniyor.--->
            <cfquery name="DEL_SHIP_ROW_RELATION_" datasource="#arguments.process_db#">
                DELETE 
                    FROM #arguments.process_db_alias#SHIP_ROW_RELATION
                WHERE
                    <cfif is_invoice_ship eq 1>
                        TO_SHIP_ID=#arguments.to_related_process_id# AND TO_SHIP_TYPE=#arguments.old_related_process_type#
                    <cfelse>
                        TO_INVOICE_ID=#arguments.to_related_process_id# AND TO_INVOICE_CAT=#arguments.old_related_process_type#
                    </cfif> 
            </cfquery>
            <cfif arguments.is_invoice_ship eq 1><!---fonksiyon irsaliyeden cagrılmıssa --->
                <cfquery name="DEL_SHIP_REL" datasource="#arguments.process_db#">
                    DELETE FROM #arguments.process_db_alias#SHIP_TO_SHIP WHERE TO_SHIP_ID=#arguments.to_related_process_id# AND TO_SHIP_TYPE=#arguments.old_related_process_type#
                </cfquery>
            </cfif>
        </cfif>
        <cfif listfind('0,1',arguments.ship_related_action_type) and not (isdefined('arguments.is_related_action_iptal') and arguments.is_related_action_iptal eq 1) 
        and (( is_invoice_ship eq 1 and listfind('71,72,73,74,75,76,77,78,79',arguments.to_related_process_type) ) or is_invoice_ship eq 0)> <!--- ekleme ve guncellemede kayıtlar ekleniyor --->
        <!---irsaliyeden cagrıldıgı durumlar için ship_type kontrolu özellikle eklendi, önce konsinye irs. secip ardından işlem tipi degiştirildiginde olusabilecek sorunları engellemek için --->
            <cfloop from="1" to="#attributes.rows_#" index="row_shp_ind">
                <cfif (listlen(evaluate("attributes.row_ship_id#row_shp_ind#"),';') eq 2 and evaluate("listfirst(attributes.row_ship_id#row_shp_ind#,';')") ) or ( listlen(evaluate("attributes.row_ship_id#row_shp_ind#"),';') eq 1 and evaluate("attributes.row_ship_id#row_shp_ind#") neq 0 and listfind('592',arguments.to_related_process_type) )>
                    <!--- row_ship_id 2 haneli ise ship_id;period_id bilgilerini tutar
                    hal faturalarında (process_type:592) ise tek hanelidir ve aktif donemden irsaliye cekilir.
                    row_ship_id 0 olanlar alınmaz cunku bu satırlar manuel eklenmiş urunleri gosterir --->
                    <cfif not listfind(related_ships,evaluate("listfirst(attributes.row_ship_id#row_shp_ind#,';')"))>
                        <cfset related_ships = listappend(related_ships,evaluate("listfirst(attributes.row_ship_id#row_shp_ind#,';')"))>
                        <cfif listlen(evaluate("attributes.row_ship_id#row_shp_ind#"),';') eq 2>
                            <cfset related_ship_periods = listappend(related_ship_periods,evaluate("listlast(attributes.row_ship_id#row_shp_ind#,';')"))>
                        <cfelse> 
                            <cfset related_ship_periods = listappend(related_ship_periods,session.ep.period_id)>
                        </cfif>
                    </cfif>
                    <cfquery name="ADD_SHIP_ROW_RELATION_" datasource="#arguments.process_db#">
                        INSERT INTO
                            #arguments.process_db_alias#SHIP_ROW_RELATION
                        (
                            PRODUCT_ID,
                            STOCK_ID,
                            SPECT_VAR_ID,
                            SHELF_NUMBER,
                            AMOUNT,
                            SHIP_ID,
                            SHIP_PERIOD,
                            SHIP_WRK_ROW_ID,
                            <cfif arguments.is_invoice_ship eq 1>
                            TO_SHIP_ID,
                            TO_SHIP_TYPE
                            <cfelse>
                            TO_INVOICE_ID,
                            TO_INVOICE_CAT
                            </cfif>
                        )
                        VALUES
                        (
                            #evaluate('attributes.product_id#row_shp_ind#')#,
                            #evaluate('attributes.stock_id#row_shp_ind#')#,
                        <cfif isdefined('attributes.spect_id#row_shp_ind#') and len(evaluate('attributes.spect_id#row_shp_ind#'))>#evaluate('attributes.spect_id#row_shp_ind#')#,<cfelse>NULL,</cfif>
                        <cfif isdefined('attributes.shelf_number#row_shp_ind#') and len(evaluate('attributes.shelf_number#row_shp_ind#'))>#evaluate('attributes.shelf_number#row_shp_ind#')#,<cfelse>NULL,</cfif>
                            #evaluate('attributes.amount#row_shp_ind#')#,
                            #evaluate("listfirst(attributes.row_ship_id#row_shp_ind#,';')")#,
                        <cfif listlen(evaluate("attributes.row_ship_id#row_shp_ind#"),';') eq 2>#evaluate("listlast(attributes.row_ship_id#row_shp_ind#,';')")#,<cfelse>#session.ep.period_id#,</cfif>
                        <cfif arguments.is_invoice_ship eq 1 and not listfind('71,72,73,74,75,76,77,78,79',arguments.to_related_process_type)>
                            <cfif isdefined('attributes.wrk_row_id#row_shp_ind#') and len(evaluate('attributes.wrk_row_id#row_shp_ind#'))>'#wrk_eval('attributes.wrk_row_id#row_shp_ind#')#'<cfelse>NULL</cfif>,	
                        <cfelse>
                            <cfif isdefined('attributes.wrk_row_relation_id#row_shp_ind#') and len(evaluate('attributes.wrk_row_relation_id#row_shp_ind#'))>'#wrk_eval('attributes.wrk_row_relation_id#row_shp_ind#')#'<cfelse>NULL</cfif>,	
                        </cfif>
                            #arguments.to_related_process_id#,
                            #arguments.to_related_process_type#
                        )
                    </cfquery>
                </cfif>
            </cfloop>
            <cfif arguments.is_invoice_ship eq 1> <!--- fonksiyon irsaliyeden cagrılmıssa belge bazında irsaliye-irsaliye ilişkisi ekleniyor --->
                <cfif len(related_ships)>
                    <cfloop list="#related_ships#" index="ship_i">#listfind(related_ships,ship_i)#
                        <cfquery name="ADD_SHIP_TO_SHIP_" datasource="#arguments.process_db#">
                            INSERT INTO
                                #arguments.process_db_alias#SHIP_TO_SHIP
                            (
                                TO_SHIP_ID,
                                TO_SHIP_TYPE,
                                FROM_SHIP_ID,
                                FROM_SHIP_PERIOD
                            )
                            VALUES
                            (
                                #arguments.to_related_process_id#,
                                #arguments.to_related_process_type#,
                                #ship_i#,
                                #listgetat(related_ship_periods,listfind(related_ships,ship_i))#
                            )
                        </cfquery>
                    </cfloop>
                </cfif>
            </cfif>
        </cfif>
        <cfreturn true>
	</cffunction>
    
<!---get_prod_order_funcs--->
	<cffunction name="GET_STATION_PROD">
        <cfargument name="get_station_id" type="numeric" required="true">
        <cfargument name="get_other" type="string"  default=""  required="false">
        <cfquery name="GET_STATION_OF_ORDER" datasource="#DSN#">
            SELECT
                W.*,
                B.BRANCH_ID,
                B.BRANCH_NAME
            FROM
                #dsn3_alias#.WORKSTATIONS W,
                BRANCH B
            WHERE
                W.BRANCH = B.BRANCH_ID AND
                W.STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_station_id#">
        </cfquery>
        <cfif  get_other eq "uye">
            <cfif LEN(GET_STATION_OF_ORDER.OUTSOURCE_PARTNER) AND ISNUMERIC(GET_STATION_OF_ORDER.OUTSOURCE_PARTNER)>
                <cfreturn #get_par_info(GET_STATION_OF_ORDER.OUTSOURCE_PARTNER,0,-1,1)#> 
            <cfelse>
                <cfreturn ''>	
            </cfif>
        <cfelseif  get_other eq "yetkili">	
            <cfif GET_STATION_OF_ORDER.RECORDCOUNT>
                <cfset DEGER= "<a href=""javascript://""  onclick=""windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=" &  #GET_STATION_OF_ORDER.employee_id# & "','medium');"" class=""tableyazi"">" & #GET_STATION_OF_ORDER.FULLNAME2# & "</a>">
                <cfreturn DEGER>	
            <cfelse>
                <cfreturn ''>
            </cfif> 
        <cfelse>
            <cfif GET_STATION_OF_ORDER.RECORDCOUNT>
                <cfreturn GET_STATION_OF_ORDER.STATION_NAME>
            <cfelse>
                <cfreturn ''>
            </cfif> 
        </cfif>
	</cffunction>
    <cffunction name="GET_ROUTE_PROD">
        <cfargument name="get_route_id" type="numeric" required="true">
        <cfquery name="GET_ROUTE_OF_ORDER" datasource="#DSN3#">
            SELECT ROUTE FROM ROUTE WHERE ROUTE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_route_id#">
        </cfquery>
        <cfif GET_ROUTE_OF_ORDER.RECORDCOUNT>
            <cfreturn GET_ROUTE_OF_ORDER.ROUTE>
        <cfelse>
            <cfreturn ''>
        </cfif> 
    </cffunction>
    <cffunction name="GET_PROSPECTUS_PROD">
        <cfargument name="get_prospectus_id" type="numeric" required="true">
        <cfquery name="GET_PROSPECTUS_OF_ORDER" datasource="#DSN3#">
            SELECT PROSPECTUS_NAME FROM PROSPECTUS WHERE PROSPECTUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_prospectus_id#">
        </cfquery>
        <cfif GET_PROSPECTUS_OF_ORDER.RECORDCOUNT>
            <cfreturn GET_PROSPECTUS_OF_ORDER.PROSPECTUS_NAME>
        <cfelse>
            <cfreturn ''>
        </cfif> 
    </cffunction>
    <cffunction name="GET_STATUS_PROD_ORDER">
        <cfargument name="status_id" type="numeric" required="true">
        <cfquery name="GET_STATUS_OF_PROD" datasource="#DSN#">
            SELECT STATUS_NAME FROM PRODUCTION_STATUS WHERE STATUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#status_id#">
        </cfquery>
        <cfif GET_STATUS_OF_PROD.RECORDCOUNT>
            <cfreturn GET_STATUS_OF_PROD.STATUS_NAME>
        <cfelse>
            <cfreturn ''>
        </cfif> 
    </cffunction>
    <cffunction name="GET_PRODUCT_PROPERTY_PROD">
        <cfargument name="stock_id" type="numeric" required="true">
        <cfargument name="be_wanted" type="string" required="false" default="pro_name">
        <cfquery name="GET_PRODUCT_NAMES" datasource="#DSN3#">
            SELECT
                S.PRODUCT_NAME,
                S.PROPERTY,
                PU.MAIN_UNIT,
                S.PRODUCT_ID
            FROM
                STOCKS AS S,
                PRODUCT_UNIT AS PU
            WHERE
                PU.PRODUCT_ID = S.PRODUCT_ID AND
                STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#">
        </cfquery>
        <cfif GET_PRODUCT_NAMES.RECORDCOUNT>
            <cfif len(be_wanted)>
                <cfset 	deger = "#be_wanted#">
                <cfswitch expression="#deger#">
                    <cfcase value="unit">
                        <cfset deger = GET_PRODUCT_NAMES.MAIN_UNIT >
                    </cfcase>
                    <cfcase value="pro">
                        <cfset deger = GET_PRODUCT_NAMES.PRODUCT_ID & " " & GET_PRODUCT_NAMES.PRODUCT_ID >
                    </cfcase>
                    <cfdefaultcase>
                        <cfset deger = GET_PRODUCT_NAMES.PRODUCT_NAME>
                    </cfdefaultcase>
                </cfswitch>
                <cfreturn deger>
            <cfelse>
                <cfreturn GET_PRODUCT_NAMES.PRODUCT_NAME & " " &  GET_PRODUCT_NAMES.PROPERTY>
            </cfif>
        <cfelse>
            <cfreturn ''>
        </cfif> 
    </cffunction>
    <cffunction name="GET_PRODUCT_UNIT_PROD">
        <cfargument name="get_product_id" type="numeric" required="true">
        <cfquery name="GET_PRODUCT_UNIT_OF_ORDER" datasource="#DSN3#">
            SELECT MAIN_UNIT FROM PRODUCT_UNIT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_id#">
        </cfquery>
        <cfif GET_PRODUCT_UNIT_OF_ORDER.RECORDCOUNT>
            <cfreturn GET_PRODUCT_UNIT_OF_ORDER.MAIN_UNIT>
        <cfelse>
            <cfreturn ''>
        </cfif> 
    </cffunction>

<!---sales_import_functions--->
        <cffunction name="f_date" output="false" returntype="string">
            <cfargument name="tarih" type="string" required="yes">
            <cf_date tarih="arguments.tarih">
            <cfreturn arguments.tarih>
    	</cffunction>
    <!--- f_add_invoice_row_problem fonksiyonundaki ROW_TYPE argumanı 0 --> Iade, 1 --> Iptal anlamı tasır 
		IS_PROM parametresi sadece hediye urunlerde 1,diger durumlarda 0 olmali --->
    	<cffunction name="f_add_invoice_row_problem" output="false" returntype="numeric">
        <cfargument name="STOCK_CODE" type="string" required="yes">
        <cfargument name="BARCODE" type="string" required="yes">
        <cfargument name="INVOICE_ID" type="string" required="yes">
        <cfargument name="INVOICE_DATE" type="string" required="yes">
        <cfargument name="BILL_NO" type="string" required="yes">
        <cfargument name="AMOUNT" type="string" required="yes">
        <cfargument name="PRICE" type="string" required="yes">
        <cfargument name="DISCOUNTTOTAL" type="string" required="yes">
        <cfargument name="GROSSTOTAL" type="string" required="yes">
        <cfargument name="TAXTOTAL" type="string" required="yes">
        <cfargument name="NETTOTAL" type="string" required="yes">
        <cfargument name="TAX" type="string" required="yes">
        <cfargument name="CUSTOMER_NO" type="string" required="yes">
        <cfargument name="CREDITCARD_NO" type="string" required="yes">
        <cfargument name="ROW_TYPE" type="string" required="yes">
        <cfargument name="IS_PROM" type="string" required="yes">
        <cfquery name="ADD_INVOICE_ROW_PROBLEM" datasource="#DSN2#">
            INSERT INTO
                INVOICE_ROW_POS_PROBLEM
            (
                INVOICE_ID,
                STOCK_CODE,
                BARCODE,
                INVOICE_DATE,
                AMOUNT,
                PRICE,
                DISCOUNTTOTAL,
                GROSSTOTAL,
                NETTOTAL,
                TAXTOTAL,
                TAX,
                CREDITCARD_NO,
                BRANCH_FIS_NO,
                BRANCH_CON_ID,
                ROW_TYPE,
                IS_PROM
            )
            VALUES
            (
                #arguments.invoice_id#,
                '#arguments.stock_code#',
                '#arguments.barcode#',
                #arguments.invoice_date#,
                #arguments.amount#,
                #arguments.price#,
                #arguments.discounttotal#,
                #arguments.grosstotal#,
                #arguments.nettotal#,
                #arguments.taxtotal#,			
                #arguments.tax#,
                <cfif len(arguments.creditcard_no)>'#arguments.creditcard_no#'<cfelse>NULL</cfif>,
                <cfif len(arguments.bill_no)>'#arguments.bill_no#'<cfelse>NULL</cfif>,
                <cfif len(arguments.customer_no)>'#arguments.customer_no#'<cfelse>NULL</cfif>,
                #arguments.row_type#,
                #arguments.is_prom#
            )
        </cfquery>
        <cfreturn 1>
    </cffunction>
    <!--- f_add_invoice_row fonksiyonundaki ROW_TYPE argumanı 0 --> Iade, 1 --> Iptal anlamı tasır 
		IS_PROM parametresi sadece hediye urunlerde 1,diger durumlarda 0 olmali--->
    	<cffunction name="f_add_invoice_row" output="false" returntype="numeric">
        <cfargument name="DB_SOURCE" type="string" default="#dsn2#">
        <cfargument name="ROW_BLOCK" type="numeric" default="500">	
        <cfargument name="STOCK_ID" type="string" required="yes">
        <cfargument name="BARCODE" type="string" required="yes">
        <cfargument name="PRODUCT_ID" type="string" required="yes">
        <cfargument name="INVOICE_ID" type="string" required="yes">
        <cfargument name="INVOICE_DATE" type="string" required="yes">
        <cfargument name="ROW_TYPE" type="string" required="yes">
        <cfargument name="BILL_NO" type="string" required="yes">
        <cfargument name="ADD_UNIT" type="string" required="yes">
        <cfargument name="AMOUNT" type="string" required="yes">
        <cfargument name="PRICE" type="string" required="yes">
        <cfargument name="DISCOUNTTOTAL" type="string" required="yes">
        <cfargument name="GROSSTOTAL" type="string" required="yes">
        <cfargument name="TAXTOTAL" type="string" required="yes">
        <cfargument name="NETTOTAL" type="string" required="yes">
        <cfargument name="TAX" type="string" required="yes">
        <cfargument name="MULTIPLIER" type="string" required="yes">
        <cfargument name="CUSTOMER_NO" type="string" required="yes">
        <cfargument name="CREDITCARD_NO" type="string" required="yes">
        <cfargument name="TERMINAL_TYPE" type="string">
        <cfargument name="IS_KARMA" required="yes">
        <cfargument name="IS_PROM" type="string" required="yes">
        <cfscript>
            if(arguments.row_type is "0" or arguments.row_type is "1") /*iade yada iptal ise tutar eksi yazılır*/
            {
                arguments.amount = (arguments.amount)*(-1);
                arguments.price = (arguments.price)*(-1);
                arguments.discounttotal = (arguments.discounttotal)*(-1);
                arguments.grosstotal = (arguments.grosstotal)*(-1);
                arguments.nettotal = (arguments.nettotal)*(-1);
                arguments.taxtotal = (arguments.taxtotal)*(-1);
            }
            if(not len(arguments.creditcard_no)) arguments.creditcard_no = 'NULL';
            if(not len(arguments.bill_no)) arguments.bill_no = 'NULL';
            if(not len(arguments.customer_no)) arguments.customer_no = 'NULL';
            if(not len(arguments.is_karma)) arguments.is_karma = 'NULL';
        </cfscript>
        <cfif database_type is 'MSSQL'>
            <cfscript>
                add_inv_row[Arraylen(add_inv_row)+1] = "INSERT INTO INVOICE_ROW_POS (INVOICE_ID,STOCK_ID,INVOICE_DATE,UNIT,AMOUNT,PRICE,DISCOUNTTOTAL,GROSSTOTAL,NETTOTAL,TAXTOTAL,MULTIPLIER,PRODUCT_ID,TAX,CREDITCARD_NO,BRANCH_FIS_NO,BRANCH_CON_ID,BARCODE,IS_KARMA,ROW_TYPE,IS_PROM) VALUES (#arguments.invoice_id#,#arguments.stock_id#,#arguments.invoice_date#,'#arguments.add_unit#',#arguments.amount#,#arguments.price#,#arguments.discounttotal#,#arguments.grosstotal#,#arguments.nettotal#,#arguments.taxtotal#,#arguments.multiplier#,#arguments.product_id#,#arguments.tax#,'#arguments.creditcard_no#','#arguments.bill_no#','#arguments.customer_no#','#arguments.barcode#',#arguments.is_karma#,#arguments.row_type#,#arguments.is_prom#)";
                if((ArrayLen(add_inv_row) gt 1) and (ArrayLen(add_inv_row) mod arguments.row_block eq 0))
                {
                    sonuc_add_row_2 = add_block_row(db_source:arguments.db_source,row_array:add_inv_row);
                    add_inv_row = ArrayNew(1);
                }
            </cfscript>
        <cfelse>
            <cfquery name="ADD_INVOICE_ROW" datasource="#DSN2#">
                INSERT INTO
                    INVOICE_ROW_POS
                (
                    INVOICE_ID,
                    STOCK_ID,
                    INVOICE_DATE,
                    UNIT,
                    AMOUNT,
                    PRICE,
                    DISCOUNTTOTAL,
                    GROSSTOTAL,
                    NETTOTAL,
                    TAXTOTAL,
                    MULTIPLIER,
                    PRODUCT_ID,
                    TAX,
                    CREDITCARD_NO,
                    BRANCH_FIS_NO,
                    BRANCH_CON_ID,
                    BARCODE,
                    IS_KARMA,
                    ROW_TYPE,
                    IS_PROM
                )
                VALUES
                (
                    #arguments.invoice_id#,
                    #arguments.stock_id#,
                    #arguments.invoice_date#,
                    '#arguments.add_unit#',
                    #arguments.amount#,
                    #arguments.price#,<!--- PRICE #replace(oku(arguments.tempo,62,15),",",".","all")#  Birim Fiyat --->
                    #arguments.discounttotal#,<!---DISCOUNTTOTAL #replace(oku(arguments.tempo,107,15),",",".","all")*(-1)# Satırlara uygulanan toplam indirim --->
                    #arguments.grosstotal#,<!--- GROSSTOTAL #replace(oku(arguments.tempo,77,15),",",".","all")*(-1)# Toplam Fiyat --->
                    #arguments.nettotal#,<!--- NETTOTAL --- Toplam Fiyat-Toplam KDV --->
                    #arguments.taxtotal#,<!--- TAXTOTAL --- Toplam KDV --->
                    #arguments.multiplier#,
                    #arguments.product_id#,
                    #arguments.tax#,<!--- #replace(oku(arguments.tempo,43,3),",",".","all")#, --->
                    '#arguments.creditcard_no#',
                    '#arguments.bill_no#',
                    '#arguments.customer_no#',
                    '#arguments.barcode#',
                    #arguments.is_karma#,
                    #arguments.row_type#,
                    #arguments.is_prom#
                )
            </cfquery>
        </cfif>
        <cfreturn true>
    </cffunction>
    <!--- Arraydaki degerleri insert ediyor --->
    	<cffunction name="add_block_row" output="false" returntype="string">
        <cfargument name="db_source" type="string" default="">
        <cfargument name="row_array" type="array" required="yes">
        <cfargument name="satir_atla" type="string" default="#chr(13)&chr(10)#">
        <cfif ArrayLen(arguments.row_array) gt 0 and database_type is 'MSSQL'>
            <cfset arguments.row_array = ArrayToList(arguments.row_array,arguments.satir_atla)><!--- SQL cumlesi liste olarak olustu --->
            <cfquery name="add_block_row_" datasource="#arguments.db_source#">
                #PreserveSingleQuotes(arguments.row_array)#
            </cfquery>
            <cfreturn true>
        <cfelse>
            <cfreturn false>
        </cfif>
    </cffunction>
    	<cffunction name="f_get_stock" output="false" returntype="query">
        <cfargument name="STOCK_ID" type="string">
        <cfargument name="BARCODE" type="string">
        <cfargument name="TERMINAL_TYPE" type="string">
        <cfif isdefined("arguments.stock_id") and not isnumeric(arguments.stock_id)><cfset arguments.stock_id = 0></cfif>
        <cfif isdefined("arguments.barcode") and not isnumeric(arguments.barcode)><cfset arguments.barcode = 0></cfif>
        <cfquery name="Q_GET_STOCK" dbtype="query">
            SELECT
                STOCK_ID,
                TAX,
                MULTIPLIER,
                PRODUCT_ID,
                ADD_UNIT,
                BARCOD,
                IS_KARMA
            FROM
            <cfif listfind('-3,-8', arguments.terminal_type,',')><!--- NCR ve Wincor ise --->
                GET_STOCK_ALL_NCR
            <cfelse>
                GET_STOCK_ALL
            </cfif>
            WHERE 
            <cfif listfind('-3,-8', arguments.terminal_type)><!--- NCR ve Wincor ise --->
                BARCOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.barcode#">
            <cfelse>
                STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#">
            </cfif>
        </cfquery>
        <cfreturn Q_GET_STOCK>
    </cffunction>
    <cffunction name="add_reserve_row" returntype="boolean" output="false">
	<cfargument name="reserve_order_id" required="yes" default=""> <!--- irsaliye islemlerinden liste olarak gonderilebilir, birden fazla siparisin tek irsaliyeye cekildigi durumlar icin --->
	<cfargument name="reserve_stock_id" default="">
	<cfargument name="reserve_product_id" default="">
	<cfargument name="reserve_spect_id" default="">
	<cfargument name="reserve_wrk_row_id" default=""> <!--- stok detayda rezerve çöz ekranından geliyor --->
	<cfargument name="reserve_amount" default="">
	<cfargument name="cancel_amount" default="">
	<cfargument name="related_process_id" default=""><!--- siparis irsaliye ile iliskiliyse ship_id, faturadan ise invoice_id 'yi tutar --->
	<cfargument name="reserve_action_type" required="yes" type="numeric"><!--- 0: ekleme 1: guncelleme 2: silme , 3: reserve çözme işlemi --->
	<cfargument name="reserve_action_iptal" default="0"> <!--- iptal islemlerinde (siparis cekilen irsaliyenin iptali) --->
	<cfargument name="is_order_process" required="yes" type="numeric"> <!--- 0: siparis, 1: irsaliye, 2: fatura, 3: stok durum listesinden işleminden cagrılmıs --->
	<cfargument name="is_purchase_sales" required="yes" type="numeric"> <!--- 0: satınalma siparisi 1: satıs siparisi ORDER_ZONE kontrolu eklenecek--->
	<cfargument name="process_db" required="yes" default="#dsn3#" type="string">
	<cfargument name="process_db_alias" type="string">
	<cfargument name="is_stock_row_action" required="yes" default="1">
	<cfargument name="order_from_partner" default="0">
	<cfargument name="reserve_process_type" default="0">
	<cfscript>
		order_list_for_dept='';
		if(isdefined("session.pp"))
			session_base = evaluate('session.pp');
		else if(isdefined("session.ep"))
			session_base = evaluate('session.ep');
		else if(isdefined("session.pda"))
			session_base = evaluate('session.pda');
		else
			session_base = evaluate('session.ww');
	
		ship_related_order_list=''; // irsaliyeye cekilen siparislerin listesi
		no_change_order_list =''; //reserve bilgileri degistirilmeyecek irsaliyelerin listesi
		old_order_list_ = ''; //onceden iliskilendirilmis irsaliyeler
		removed_order_list = ''; //irsaliye ve faturadan cıkarılmıs irsaliyeler
		stock_count_list_='';

		if(not (isdefined("arguments.process_db_alias") and len(arguments.process_db_alias)))
			if(arguments.process_db is not 'dsn3')
				arguments.process_db_alias = '#dsn3_alias#.';
			else
				arguments.process_db_alias = '';
	</cfscript>
	<cfif reserve_action_iptal neq 1 and reserve_action_type neq 2 and not len(arguments.reserve_order_id)>
		<script type="text/javascript">
			alert('İşlem İle İlgili Sipariş Bilgisi Eksik!');
		</script>
		<cfabort>
	</cfif>
	<!--- ORDER_ROW_RESERVED tablosuna depo ve lokasyon bilgileri gönderilecek. irsaliye ve faturada ilgili oldukları siparişlere ait rezerveleri çözdügü için,
	 irs. fatura satırlarına da sipariş depo-lokasyon bilgileri gönderiliyor --->
	<cfif len(arguments.reserve_order_id)>
		<cfquery name="GET_ORD_DEPT_INFO_" datasource="#arguments.process_db#">
			SELECT
				(CAST(DELIVER_DEPT_ID AS NVARCHAR(20))+'_'+CAST(LOCATION_ID AS NVARCHAR(20))) AS ORD_DEPT_LOCATION,
				ORDER_ID
			FROM
				#arguments.process_db_alias#ORDERS
			WHERE
				ORDER_ID IN (#arguments.reserve_order_id#)
				AND DELIVER_DEPT_ID IS NOT NULL
		</cfquery>
		<cfif GET_ORD_DEPT_INFO_.recordcount>
			<cfset order_list_for_dept= valuelist(GET_ORD_DEPT_INFO_.ORDER_ID)>
		</cfif>
	<cfelse>
		<cfset GET_ORD_DEPT_INFO_.recordcount=0>
	</cfif>
	<cfif listfind('0,1',arguments.reserve_action_type) and not listfind('0,3',arguments.is_order_process)> <!--- ekleme ve güncelleme --->
		<!--- siparis veya faturayla iliskili oldugu halde bu islemler guncellendiginde satır reserveleri degistirilmeyecek siparisler cekiliyor --->
		<cfquery name="CONTROL_RESERVE_STATUS" datasource="#arguments.process_db#"> 
			SELECT 
				ORDER_ID,CHANGE_RESERVE_STATUS
			FROM
				<cfif arguments.is_order_process eq 1>
				#arguments.process_db_alias#ORDERS_SHIP
				<cfelseif arguments.is_order_process eq 2>
				#arguments.process_db_alias#ORDERS_INVOICE
				</cfif>
			WHERE
				<cfif arguments.is_order_process eq 1 and len(arguments.related_process_id)>
					SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.related_process_id#">
					AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
				<cfelseif arguments.is_order_process eq 2 and len(arguments.related_process_id)>
					INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.related_process_id#">
					AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
				<cfelseif arguments.reserve_action_type eq 0 and len(arguments.reserve_order_id)>
					ORDER_ID IN (#arguments.reserve_order_id#) 
				</cfif>
		</cfquery>
		<cfif CONTROL_RESERVE_STATUS.recordcount>
			<cfif not listfind('0,3',arguments.reserve_action_type) and arguments.reserve_action_iptal neq 1> <!--- ekleme ve reserve çözme islemi haricindekiler icin --->
				<cfset old_order_list_ = valuelist(CONTROL_RESERVE_STATUS.ORDER_ID)>
			</cfif>
		</cfif>
	</cfif>
	<!--- reserve_order_id sadece iptal ve silme islemlerinde bos gelebilir kontrol eklenecek --->
	<!--- ekleme islemi haric her durumda oncelikle ORDER_ROW_RESERVED tablosundaki kayıtlar siliniyor--->
	<cfif not listfind('0,3',arguments.reserve_action_type) and reserve_process_type eq 0> <!--- guncelleme islemiyse --->
		<cfquery name="DEL_ORDER_ROW_RESERVED" datasource="#arguments.process_db#">
			DECLARE @RetryCounter INT
			SET @RetryCounter = 1
			RETRY:
				BEGIN TRY
					DELETE FROM 
						#arguments.process_db_alias#ORDER_ROW_RESERVED WITH (UPDLOCK,ROWLOCK)
					WHERE
					<cfif len(arguments.reserve_order_id)>
						ORDER_ID IN (#arguments.reserve_order_id#) AND 
					</cfif> 
					<cfif is_order_process eq 1>  <!--- siparisin cekildigi irsaliyeye ait rezerve satırlar siliniyor --->
						SHIP_ID = #arguments.related_process_id# AND 
						PERIOD_ID =#session_base.period_id#
					<cfelseif is_order_process eq 2> <!---siparisin cekildigi faturaya ait rezerve satırlar siliniyor --->
						INVOICE_ID = #arguments.related_process_id# AND
						PERIOD_ID =#session_base.period_id#
					<cfelse>  <!--- siparisteki rezerve satırlar siliniyor --->
						SHIP_ID IS NULL	AND
						INVOICE_ID IS NULL				
					</cfif>
				END TRY
				BEGIN CATCH
					DECLARE @DoRetry bit; 
					DECLARE @ErrorMessage varchar(500)
					SET @doRetry = 0;
					SET @ErrorMessage = ERROR_MESSAGE()
					IF ERROR_NUMBER() = 1205 
					BEGIN
						SET @doRetry = 1; 
					END
					IF @DoRetry = 1
					BEGIN
						SET @RetryCounter = @RetryCounter + 1
						IF (@RetryCounter > 3)
						BEGIN
							RAISERROR(@ErrorMessage, 18, 1) -- Raise Error Message if 
						END
						ELSE
						BEGIN
							WAITFOR DELAY '00:00:00.05' 
							GOTO RETRY	
						END
					END
					ELSE
					BEGIN
						RAISERROR(@ErrorMessage, 18, 1)
					END
				END CATCH
		</cfquery>
	</cfif>
	<!--- IPTAL VE SILME ISLEMLERINDE CALISAN BOLUM --->
	<cfif listfind('1,2',arguments.is_order_process) and ( arguments.reserve_action_iptal eq 1 or arguments.reserve_action_type eq 2 )>
		<!--- IPTAL IRSALIYE BOLUMU: irsaliye iptal secildiginde, irsaliyeye çekilmiş sipariş varsa; irsaliye-sipariş baglantıları koparılıp, sipariş satır aşamaları ve rezerve tipleri guncellenir... --->
		<cfif arguments.is_order_process eq 1 and arguments.reserve_action_iptal eq 1> <!---iptal edilen irsaliyenin satırlarındaki siparis bilgileri siliniyor --->
			<cfquery name="UPD_RELATED_SHIP_ROW" datasource="#arguments.process_db#"> 
				UPDATE #dsn2_alias#.SHIP_ROW SET ROW_ORDER_ID = 0 WHERE SHIP_ID = #arguments.related_process_id#
			</cfquery>
		<cfelseif arguments.is_order_process eq 2 and arguments.reserve_action_iptal eq 1> 
			<cfquery name="UPD_RELATED_INVOICE_ROW" datasource="#arguments.process_db#"> 
				UPDATE #dsn2_alias#.INVOICE_ROW SET ORDER_ID=NULL WHERE INVOICE_ID=#form.invoice_id#
			</cfquery>
		</cfif>
		<cfif arguments.is_order_process eq 1><!--- irsaliyeden --->
			<cfquery name="GET_RESERVE_ORDERS" datasource="#arguments.process_db#"> <!--- silinecek veya iptal edilecek irsaliyenin siparis bilgileri alınıyor --->
				SELECT ORDER_ID FROM #arguments.process_db_alias#ORDERS_SHIP WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.related_process_id#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
			</cfquery>
		<cfelse><!--- faturadan --->
			<cfquery name="GET_RESERVE_ORDERS" datasource="#arguments.process_db#"> <!--- silinecek veya iptal edilecek irsaliyenin siparis bilgileri alınıyor --->
				SELECT ORDER_ID FROM #arguments.process_db_alias#ORDERS_INVOICE WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.related_process_id#"> AND PERIOD_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
			</cfquery>
		</cfif>
		<cfif GET_RESERVE_ORDERS.recordcount>
			<cfset ship_related_order_list=valuelist(GET_RESERVE_ORDERS.ORDER_ID)> <!--- bu listeye gore alt bolumde siparisler guncelleniyor --->
		</cfif>
	<cfelse>
		<!--- ekleme --->
		<cfif arguments.is_order_process eq 0 and isdefined('arguments.order_from_partner') and arguments.order_from_partner eq 1> <!--- ww ve ppden siparis kaydedilgidinde otomatik reserve kaydediliyor --->
			<cfquery name="ADD_ORDER_ROW_RESERVED" datasource="#arguments.process_db#">
				DECLARE @RetryCounter INT
				SET @RetryCounter = 1
				RETRY:
				BEGIN TRY
					INSERT INTO
						#arguments.process_db_alias#ORDER_ROW_RESERVED
					(
						STOCK_ID,
						PRODUCT_ID,
						SPECT_VAR_ID,
						ORDER_ID,
						<cfif arguments.is_purchase_sales eq 1>
							RESERVE_STOCK_OUT,
						<cfelse>
							RESERVE_STOCK_IN,
						</cfif>
						SHELF_NUMBER,
						ORDER_WRK_ROW_ID,
						DEPARTMENT_ID,
						LOCATION_ID		
					)
					SELECT
						ORDER_ROW.STOCK_ID,
						ORDER_ROW.PRODUCT_ID,
						ORDER_ROW.SPECT_VAR_ID,
						ORDER_ROW.ORDER_ID,
						ORDER_ROW.QUANTITY,
						ORDER_ROW.SHELF_NUMBER,
						ORDER_ROW.WRK_ROW_ID,
						ISNULL(ORDER_ROW.DELIVER_DEPT,ORDERS.DELIVER_DEPT_ID),
						ISNULL(ORDER_ROW.DELIVER_LOCATION,ORDERS.LOCATION_ID)
					FROM 
						#arguments.process_db_alias#ORDER_ROW ORDER_ROW,
						#arguments.process_db_alias#ORDERS ORDERS
					WHERE
						ORDERS.ORDER_ID=ORDER_ROW.ORDER_ID
						AND ORDERS.ORDER_ID= #reserve_order_id#
				END TRY
				BEGIN CATCH
					DECLARE @DoRetry bit; 
					DECLARE @ErrorMessage varchar(500)
					SET @doRetry = 0;
					SET @ErrorMessage = ERROR_MESSAGE()
					IF ERROR_NUMBER() = 1205 
					BEGIN
						SET @doRetry = 1; 
					END
					IF @DoRetry = 1
					BEGIN
						SET @RetryCounter = @RetryCounter + 1
						IF (@RetryCounter > 3)
						BEGIN
							RAISERROR(@ErrorMessage, 18, 1) -- Raise Error Message if 
						END
						ELSE
						BEGIN
							WAITFOR DELAY '00:00:00.05' 
							GOTO RETRY	
						END
					END
					ELSE
					BEGIN
						RAISERROR(@ErrorMessage, 18, 1)
					END
				END CATCH
			</cfquery>
		<cfelseif arguments.is_order_process eq 3 and len(arguments.reserve_stock_id) and ( (len(arguments.reserve_amount) and arguments.reserve_amount neq 0) or len(arguments.cancel_amount) )>
			<!--- stok durum listesinden stock_id, spect_id ,order_id ve miktar göndererek urun reserve edilmesi --->
			<cfquery name="CONTROL_ORDER_RESERVE_AMOUNT" datasource="#arguments.process_db#">
				SELECT 
					<cfif arguments.is_purchase_sales eq 1>
						SUM(RESERVE_STOCK_OUT+ISNULL(RESERVE_CANCEL_AMOUNT,0)) AS CONTROL_RESERVE_AMOUNT,
					<cfelse>
						SUM(RESERVE_STOCK_IN+ISNULL(RESERVE_CANCEL_AMOUNT,0)) AS CONTROL_RESERVE_AMOUNT,
					</cfif>
					STOCK_ID
					<cfif len(arguments.reserve_spect_id) and arguments.reserve_spect_id neq 0>
						,ISNULL(SPECT_VAR_ID,0) AS SPECT_VAR_ID
					</cfif>
				FROM 
					#arguments.process_db_alias#ORDER_ROW_RESERVED 
				WHERE 
					ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reserve_order_id#">
					AND STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reserve_stock_id#">
					<cfif len(arguments.reserve_spect_id) and arguments.reserve_spect_id neq 0>
						AND SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reserve_spect_id#">
					</cfif>
					<cfif len(arguments.reserve_wrk_row_id) and arguments.reserve_wrk_row_id neq 0>
						AND ISNULL(ORDER_WRK_ROW_ID,0) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.reserve_wrk_row_id#">
					</cfif>
				GROUP BY
					STOCK_ID
					<cfif len(arguments.reserve_spect_id) and arguments.reserve_spect_id neq 0>
					,ISNULL(SPECT_VAR_ID,0)
					</cfif>
				ORDER BY
					STOCK_ID
			</cfquery>
			<cfif arguments.reserve_action_type neq 3><!--- reserve çözme işlemi degilse --->
				<cfquery name="CONTROL_ORDER_AMOUNT" datasource="#arguments.process_db#">
					SELECT 
						SUM(QUANTITY-CANCEL_AMOUNT) QUANTITY,STOCK_ID
						<cfif len(arguments.reserve_spect_id) and arguments.reserve_spect_id neq 0>
						,ISNULL(SPECT_VAR_ID,0) AS SPECT_VAR_ID
						</cfif>
					FROM 
						#arguments.process_db_alias#ORDER_ROW 
					WHERE 
						ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reserve_order_id#">
						AND STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reserve_stock_id#">
						<cfif len(arguments.reserve_spect_id) and arguments.reserve_spect_id neq 0>
						AND SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reserve_spect_id#">
						</cfif>
						<cfif len(arguments.reserve_wrk_row_id) and arguments.reserve_wrk_row_id neq 0>
						AND ISNULL(WRK_ROW_ID,0) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.reserve_wrk_row_id#">
						</cfif>
					GROUP BY
						STOCK_ID
						<cfif len(arguments.reserve_spect_id) and arguments.reserve_spect_id neq 0>
						,ISNULL(SPECT_VAR_ID,0)
						</cfif>
					ORDER BY
						STOCK_ID
				</cfquery> 
				<cfif CONTROL_ORDER_RESERVE_AMOUNT.recordcount>
					<cfset max_reserve_amount = CONTROL_ORDER_AMOUNT.QUANTITY-CONTROL_ORDER_RESERVE_AMOUNT.CONTROL_RESERVE_AMOUNT>
				<cfelse>
					<cfset max_reserve_amount = CONTROL_ORDER_AMOUNT.QUANTITY>
				</cfif>
			<cfelse>
				<cfif CONTROL_ORDER_RESERVE_AMOUNT.recordcount> <!--- çözülebilecek max. reserve miktarı belirleniyor --->
					<cfset max_reserve_amount = CONTROL_ORDER_RESERVE_AMOUNT.CONTROL_RESERVE_AMOUNT>
				<cfelse>
					<cfset max_reserve_amount = 0>
				</cfif>
			</cfif>
			<cfif len(arguments.cancel_amount)> <!--- iptal edilecek miktar çözülecek veya reserve edilecek miktara ekleniyor. --->
				<cfset arguments.reserve_amount=arguments.reserve_amount+arguments.cancel_amount>
			</cfif>
			<cfif arguments.reserve_amount gt max_reserve_amount>
				<script type="text/javascript">
					alert("Max. Reserve Miktarını Aştınız!<cfif arguments.reserve_action_type eq 3>Rezervesi Çözülebilecek<cfelse>Rezerve Edilebilecek </cfif> Max. Miktar <cfoutput>#max_reserve_amount#</cfoutput> 'dir");
				</script>
				<cfif not len(arguments.cancel_amount)><!--- iptal işlemi çalıştırılacaksa max_reserve_amount reserve_amount olarak set edilip, işleme devam edilir ve sipariş aşaması güncellenir --->
					<cfabort>
				</cfif>
				<cfset arguments.reserve_amount = max_reserve_amount> 
			</cfif>
			<cfif arguments.reserve_action_type eq 3>
				<cfset arguments.reserve_amount = max_reserve_amount-arguments.reserve_amount> <!--- reserve edilmis miktardan çözülecek miktar cıkarılarak, kalması gereken rezerve miktarı bulunur --->
				<cfquery name="DEL_RESERVE_ROWS" datasource="#arguments.process_db#">
					DELETE FROM 
						ORDER_ROW_RESERVED
					WHERE
						SHIP_ID IS NULL AND INVOICE_ID IS NULL
						AND ORDER_ID=#arguments.reserve_order_id#
						AND STOCK_ID =#arguments.reserve_stock_id#
						<cfif len(arguments.reserve_spect_id) and arguments.reserve_spect_id neq 0>
						AND SPECT_VAR_ID = #arguments.reserve_spect_id#
						</cfif>
						<cfif len(arguments.reserve_wrk_row_id) and arguments.reserve_wrk_row_id neq 0>
						AND ISNULL(ORDER_WRK_ROW_ID,0) = '#arguments.reserve_wrk_row_id#'
						</cfif>
				</cfquery>
			</cfif>
			<cfif arguments.reserve_amount gt 0 or (len(arguments.cancel_amount) and arguments.cancel_amount gt 0)>
				<cfquery name="ADD_ORDER_ROW_RESERVED" datasource="#arguments.process_db#">
					INSERT INTO
						#arguments.process_db_alias#ORDER_ROW_RESERVED
					(
						STOCK_ID,
						PRODUCT_ID,
						SPECT_VAR_ID,
						ORDER_ID,
						<!--- DEPARTMENT_ID,
						LOCATION_ID, --->
						ORDER_WRK_ROW_ID,
						RESERVE_CANCEL_AMOUNT,
						<cfif arguments.is_purchase_sales eq 1>
							RESERVE_STOCK_OUT
						<cfelse>
							RESERVE_STOCK_IN
						</cfif>
					)
					VALUES
					(
						#arguments.reserve_stock_id#,
						#arguments.reserve_product_id#,
						<cfif len(arguments.reserve_spect_id) and arguments.reserve_spect_id neq 0>#arguments.reserve_spect_id#<cfelse>NULL</cfif>,
						#arguments.reserve_order_id#,
						<!--- <cfif len(listfirst(GET_ORD_DEPT_INFO_.ORD_DEPT_LOCATION[listfind(order_list_for_dept,arguments.reserve_order_id)],'_'))>#listfirst(GET_ORD_DEPT_INFO_.ORD_DEPT_LOCATION[listfind(order_list_for_dept,arguments.reserve_order_id)],'_')#<cfelse>NULL</cfif>,
						<cfif len(listlast(GET_ORD_DEPT_INFO_.ORD_DEPT_LOCATION[listfind(order_list_for_dept,arguments.reserve_order_id)],'_'))>#listlast(GET_ORD_DEPT_INFO_.ORD_DEPT_LOCATION[listfind(order_list_for_dept,arguments.reserve_order_id)],'_')#<cfelse>NULL</cfif>,
						 --->
						 <cfif len(arguments.reserve_wrk_row_id) and arguments.reserve_wrk_row_id neq 0>'#arguments.reserve_wrk_row_id#'<cfelse>NULL</cfif>,
						<cfif len(arguments.cancel_amount)>#arguments.cancel_amount#<cfelse>0</cfif>,
						#arguments.reserve_amount#
					)
				</cfquery>
			</cfif>
			<cfquery name="GET_ORDER_ROW_INFO" datasource="#arguments.process_db#">
				SELECT 
					 QUANTITY,STOCK_ID,
					 <cfif len(arguments.reserve_spect_id) and arguments.reserve_spect_id neq 0>
					  ISNULL(SPECT_VAR_ID,0),
					 </cfif>
					 RESERVE_TYPE,ORDER_ROW_ID,ISNULL(WRK_ROW_ID,0) AS WRK_ROW_ID
				FROM 
					#arguments.process_db_alias#ORDER_ROW 
				WHERE 
					ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reserve_order_id#">
					AND STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reserve_stock_id#">
					<cfif len(arguments.reserve_spect_id) and arguments.reserve_spect_id neq 0>
					AND SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reserve_spect_id#">
					</cfif>
					<cfif len(arguments.reserve_wrk_row_id) and arguments.reserve_wrk_row_id neq 0>
					AND ISNULL(WRK_ROW_ID,0) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.reserve_wrk_row_id#">
					</cfif>
			</cfquery>
			<cfquery name="get_reserve_amounts" datasource="#arguments.process_db#">
				SELECT
					<cfif arguments.is_purchase_sales>
						SUM(RESERVE_STOCK_OUT) AS TOTAL_RESERVED_AMOUNT,
						SUM(STOCK_OUT) AS PROCESSED_RESERVED_AMOUNT,
					<cfelse>
						SUM(RESERVE_STOCK_IN) AS TOTAL_RESERVED_AMOUNT,
						SUM(STOCK_IN) AS PROCESSED_RESERVED_AMOUNT,
					</cfif>
					STOCK_ID
					<cfif len(arguments.reserve_spect_id) and arguments.reserve_spect_id neq 0>
					,ISNULL(SPECT_VAR_ID,0)
					</cfif>
					,ISNULL(ORDER_WRK_ROW_ID,0) AS ORDER_WRK_ROW_ID
				FROM
					#arguments.process_db_alias#ORDER_ROW_RESERVED
				WHERE
					ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reserve_order_id#">
					AND STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reserve_stock_id#">
					<cfif len(arguments.reserve_spect_id) and arguments.reserve_spect_id neq 0>
					AND SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reserve_spect_id#">
					</cfif>
				GROUP BY
					ISNULL(ORDER_WRK_ROW_ID,0),
					STOCK_ID
					<cfif len(arguments.reserve_spect_id) and arguments.reserve_spect_id neq 0>
					,ISNULL(SPECT_VAR_ID,0)
					</cfif>
			</cfquery>
			<cfset upd_order_ =''>
			<cfoutput query="GET_ORDER_ROW_INFO">
				<cfif get_reserve_amounts.recordcount>
					<cfloop query="get_reserve_amounts">
						<cfif (get_reserve_amounts.ORDER_WRK_ROW_ID eq 0) or (get_reserve_amounts.ORDER_WRK_ROW_ID eq GET_ORDER_ROW_INFO.WRK_ROW_ID)> <!--- sadece bu satır icin yapılan rezervasyonlar vewrk_row_id siz  eski kayıtları içinde 0 olanlara bakılıyor --->
							<cfif get_reserve_amounts.TOTAL_RESERVED_AMOUNT neq 0 and get_reserve_amounts.TOTAL_RESERVED_AMOUNT eq get_reserve_amounts.PROCESSED_RESERVED_AMOUNT>
								<cfset order_row_reserve_type_ = -4><!--- Rezerve Kapatıldı --->
							<cfelse>
								<cfif (get_reserve_amounts.TOTAL_RESERVED_AMOUNT-(len(get_reserve_amounts.PROCESSED_RESERVED_AMOUNT) ? get_reserve_amounts.PROCESSED_RESERVED_AMOUNT : 0)) neq 0 and (get_reserve_amounts.TOTAL_RESERVED_AMOUNT- (len(get_reserve_amounts.PROCESSED_RESERVED_AMOUNT) ? get_reserve_amounts.PROCESSED_RESERVED_AMOUNT : 0)) lt GET_ORDER_ROW_INFO.QUANTITY>
									<cfset order_row_reserve_type_ = -2>
								<cfelse>
									<cfset order_row_reserve_type_ = -1>
								</cfif>
							</cfif>
						<cfelse>
							<cfset order_row_reserve_type_ = -3>
						</cfif>
					</cfloop>
				<cfelse>
					<cfset order_row_reserve_type_ = -3>
				</cfif>
				<cfquery name="UPD_ORD_ROW" datasource="#arguments.process_db#">
					UPDATE 
						#arguments.process_db_alias#ORDER_ROW 
					SET 
						RESERVE_TYPE = #order_row_reserve_type_#
					WHERE
						ORDER_ID = #arguments.reserve_order_id# AND
						ORDER_ROW_ID = #GET_ORDER_ROW_INFO.ORDER_ROW_ID#
				</cfquery>
				<cfif listfind('-1,-2',order_row_reserve_type_)>
					<cfset upd_order_=1>
				</cfif>
			</cfoutput>
			<cfquery name="GET_PAPER_RESERVE_INFO" datasource="#arguments.process_db#">
				SELECT DISTINCT RESERVE_TYPE FROM ORDER_ROW WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.reserve_order_id#">
			</cfquery>
			<cfset paper_row_reserve_list = valuelist(GET_PAPER_RESERVE_INFO.RESERVE_TYPE)>
			<cfif isdefined('paper_row_reserve_list') and len(paper_row_reserve_list)>
				<cfquery name="UPD_ORD" datasource="#arguments.process_db#">
					UPDATE 
						#arguments.process_db_alias#ORDERS 
					SET
					<cfif listfind(paper_row_reserve_list,'-1') or listfind(paper_row_reserve_list,'-2')>
						RESERVED = 1
					<cfelse>
						RESERVED = 0
					</cfif>
					WHERE 
						ORDER_ID = #arguments.reserve_order_id#
				</cfquery>			
			</cfif>
		<cfelse>
			<cfloop from="1" to="#attributes.rows_#" index="row_xx" >
				<cfif arguments.is_order_process eq 0 and (isdefined("attributes.reserve_type#row_xx#") and evaluate("attributes.reserve_type#row_xx#") neq -3 AND isdefined("attributes.order_currency#row_xx#") and not listfind('-8,-9,-10',evaluate("attributes.order_currency#row_xx#")))><!---siparisten gelen islemlerde rezerve olmayan satırlar haricindekiler ekleniyor --->
					<cfset add_reserve_row_ =1>
				<cfelseif arguments.is_order_process eq 1 and isdefined('attributes.row_ship_id#row_xx#') and listfirst(evaluate('attributes.row_ship_id#row_xx#'),';') neq 0> <!--- irsaliyeye siparis cekme islemlerinde siparisten gelen satırlar icin --->
					<cfif not listfind(ship_related_order_list,listfirst(evaluate('attributes.row_ship_id#row_xx#'),';')) and reserve_process_type eq 0>
					<!--- irsaliye satırlarındaki order_id'lerden ilişkili siparis listesi olusturuluyor --->
						<cfset ship_related_order_list = listappend(ship_related_order_list,listfirst(evaluate('attributes.row_ship_id#row_xx#'),';'))>
					</cfif>
					<cfif arguments.is_stock_row_action eq 1>
						<cfset add_reserve_row_ =1>
					<cfelse>
						<cfset add_reserve_row_ =0>
					</cfif>
				<cfelseif arguments.is_order_process eq 2> <!--- faturaya --->
					<cfset ship_related_order_list = arguments.reserve_order_id>
					<cfif arguments.is_stock_row_action eq 1>
						<cfset add_reserve_row_ =1>
					<cfelse>
						<cfset add_reserve_row_ =0>
					</cfif>
				<cfelse>
					<cfset add_reserve_row_ =0>
				</cfif>
				<cfif add_reserve_row_ eq 1 and reserve_process_type eq 0>
					<cfif listfind('1,2',arguments.is_order_process) and reserve_process_type eq 0><!--- irsaliyeden cagrılıyorsa --->
						<cfset row_rel_ord_id_info_=listfirst(evaluate('attributes.row_ship_id#row_xx#'),';')>
					<cfelse>
						<cfset row_rel_ord_id_info_=arguments.reserve_order_id>
					</cfif>
					<cfquery name="ADD_ORDER_ROW_RESERVED" datasource="#arguments.process_db#">
						INSERT INTO
							#arguments.process_db_alias#ORDER_ROW_RESERVED
						(
							STOCK_ID,
							PRODUCT_ID,
						<cfif isdefined('attributes.spect_id#row_xx#') and len(evaluate('attributes.spect_id#row_xx#'))>
							SPECT_VAR_ID,
						</cfif>
							DEPARTMENT_ID,
							LOCATION_ID,
						<cfif arguments.is_order_process eq 1><!--- irsaliyeden cagrılıyorsa --->
							ORDER_ID,
							ORDER_WRK_ROW_ID,
							SHIP_ID,
							PERIOD_ID,
						<cfelseif arguments.is_order_process eq 2><!--- faturadan cagrılıyorsa --->
							ORDER_ID,
							ORDER_WRK_ROW_ID,
							INVOICE_ID,
							PERIOD_ID,
						<cfelse><!--- siparişten cagrılıyorsa --->
							ORDER_ID,
							ORDER_WRK_ROW_ID,
						</cfif>
						<cfif arguments.is_purchase_sales eq 0>
							<cfif arguments.is_order_process eq 0> <!--- satınalma siparis ekleme --->
								RESERVE_STOCK_IN,
							<cfelse> <!---alıs irsaliye ve fatura ekleme --->
								STOCK_IN,
							</cfif>
						<cfelse>
							<cfif arguments.is_order_process eq 0> <!--- satıs siparisi --->
								RESERVE_STOCK_OUT,
							<cfelse>
								STOCK_OUT, <!--- satış irs. ve faturası --->
							</cfif>
						</cfif>
							SHELF_NUMBER		
						)
						VALUES
						(
							#evaluate('attributes.stock_id#row_xx#')#,
							#evaluate('attributes.product_id#row_xx#')#,
						<cfif isdefined('attributes.spect_id#row_xx#') and len(evaluate('attributes.spect_id#row_xx#'))>
							#evaluate('attributes.spect_id#row_xx#')#,	
						</cfif>
						<cfif isdefined("attributes.deliver_dept#row_xx#") and len(trim(evaluate("attributes.deliver_dept#row_xx#"))) and len(listfirst(evaluate("attributes.deliver_dept#row_xx#"),"-"))>
							#listfirst(evaluate("attributes.deliver_dept#row_xx#"),"-")#
						<cfelseif len(listfirst(GET_ORD_DEPT_INFO_.ORD_DEPT_LOCATION[listfind(order_list_for_dept,row_rel_ord_id_info_)],'_'))>
							#listfirst(GET_ORD_DEPT_INFO_.ORD_DEPT_LOCATION[listfind(order_list_for_dept,row_rel_ord_id_info_)],'_')#
						<cfelse>
							NULL
						</cfif>,
						<cfif isdefined("attributes.deliver_dept#row_xx#") and listlen(trim(evaluate("attributes.deliver_dept#row_xx#")),"-") eq 2 and len(listlast(evaluate("attributes.deliver_dept#row_xx#"),"-"))>
							#listlast(evaluate("attributes.deliver_dept#row_xx#"),"-")#
						<cfelseif len(listlast(GET_ORD_DEPT_INFO_.ORD_DEPT_LOCATION[listfind(order_list_for_dept,row_rel_ord_id_info_)],'_'))>
							#listlast(GET_ORD_DEPT_INFO_.ORD_DEPT_LOCATION[listfind(order_list_for_dept,row_rel_ord_id_info_)],'_')#
						<cfelse>
							NULL
						</cfif>,
						<cfif arguments.is_order_process eq 1>
							#row_rel_ord_id_info_#,
							<!--- irsaliye satırlarındaki siparis baglntısı  wrk_row_relation_id alanında tutuluyor. wrk_row_relation_id alanı satırın ilgili oldugu  siparisin wrk_row_id degerlerini taşır.--->
							<cfif isDefined("attributes.wrk_row_relation_id#row_xx#") and len(evaluate('attributes.wrk_row_relation_id#row_xx#'))>'#wrk_eval('attributes.wrk_row_relation_id#row_xx#')#'<cfelse>NULL</cfif>, <!--- irsaliyede satırlarındaki wrk_row_relation_id order_row daki wrk_row_id yi tutar--->
							#arguments.related_process_id#,
							#session_base.period_id#,
						<cfelseif arguments.is_order_process eq 2>
							<cfif isDefined('row_rel_ord_id_info_') and len(row_rel_ord_id_info_)>#row_rel_ord_id_info_#<cfelse>NULL</cfif>,
							<!--- fatura satırlarındaki siparis baglantısı  wrk_row_relation_id alanında tutuluyor. wrk_row_relation_id alanı satırın ilgili oldugu siparisin wrk_row_id degerlerini taşır.--->
							<cfif isDefined("attributes.wrk_row_relation_id#row_xx#") and len(evaluate('attributes.wrk_row_relation_id#row_xx#'))>'#wrk_eval('attributes.wrk_row_relation_id#row_xx#')#'<cfelse>NULL</cfif>,<!--- fatura satırlarındaki wrk_row_relation_id order_row daki wrk_row_id yi tutar--->
							#arguments.related_process_id#,
							#session_base.period_id#,
						<cfelse>
							#row_rel_ord_id_info_#,
							<!--- siparisin satırlarındaki wrk_row_id yani kendi unique id si --->
							<cfif isDefined("attributes.wrk_row_id#row_xx#") and len(evaluate('attributes.wrk_row_id#row_xx#'))>'#wrk_eval('attributes.wrk_row_id#row_xx#')#'<cfelse>NULL</cfif>,
						</cfif>
							#evaluate('attributes.amount#row_xx#')#,
						<cfif isdefined('attributes.shelf_number#row_xx#') and len(evaluate('attributes.shelf_number#row_xx#'))>#evaluate('attributes.shelf_number#row_xx#')#<cfelse>NULL</cfif>
						)
					</cfquery>
				</cfif>
			</cfloop >		
		</cfif>
	</cfif>
	<cfif len(old_order_list_)>
		<cfloop list="#old_order_list_#" index="old_order_">
			<cfif not listfind(ship_related_order_list,old_order_)>
				<cfset ship_related_order_list = listappend(ship_related_order_list,old_order_)>
				<cfset removed_order_list = listappend(removed_order_list,old_order_) >
			</cfif>
		</cfloop>
	</cfif>
	<cfif (listfind('1,2',arguments.is_order_process) and len(ship_related_order_list)) or arguments.is_order_process eq 3><!--- siparisi irsaliyeye cekme islemiyse siparisin satır aşamaları update edilir. --->
	<!--- islemle ilgili cıkarılmıs ya da onceden eklenmis irsaliyelerin hepsinin icinden degistirilmeyecek eski siparisler bulunuyor --->
		<cfif arguments.is_order_process neq 3><!--- rezerve çöz ve satır iptal işlemlerinden gelmiyorsa --->
			<cfquery name="GET_CHANGE_RESERVE_STATUS" datasource="#arguments.process_db#">
				SELECT 
					DISTINCT ORDER_ID
				FROM
					<cfif arguments.is_order_process eq 1>
					#arguments.process_db_alias#ORDERS_SHIP
					<cfelseif arguments.is_order_process eq 2>
					#arguments.process_db_alias#ORDERS_INVOICE
					</cfif>
				WHERE
					ORDER_ID IN (#ship_related_order_list#)
					AND CHANGE_RESERVE_STATUS=0
					<cfif (arguments.reserve_action_type eq 1 and arguments.reserve_action_iptal eq 1) or arguments.reserve_action_type eq 2><!--- silme ve guncelleme isleminde ilgili isleme ait kayıt haric bırakılır --->
					AND
					<cfif arguments.is_order_process eq 1>
					 ORDER_SHIP_ID NOT IN (
					<cfelseif arguments.is_order_process eq 2>
					 ORDER_INVOICE_ID NOT IN (
					</cfif>
								SELECT 
								<cfif arguments.is_order_process eq 1>
								ORDER_SHIP_ID
								<cfelseif arguments.is_order_process eq 2>
								ORDER_INVOICE_ID
								</cfif>
									 
								FROM
									<cfif arguments.is_order_process eq 1>
									#arguments.process_db_alias#ORDERS_SHIP
									<cfelseif arguments.is_order_process eq 2>
									#arguments.process_db_alias#ORDERS_INVOICE
									</cfif>
								WHERE
									<cfif arguments.is_order_process eq 1 and len(arguments.related_process_id)>
										SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.related_process_id#">
										AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
									<cfelseif arguments.is_order_process eq 2 and len(arguments.related_process_id)>
										INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.related_process_id#">
										AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
									</cfif>
					)	
					</cfif>
			</cfquery>
			<cfif GET_CHANGE_RESERVE_STATUS.recordcount>
				<cfset no_change_order_list = valuelist(GET_CHANGE_RESERVE_STATUS.ORDER_ID)>
			</cfif>
			<cfif listfind('1,2',arguments.reserve_action_type) and reserve_process_type eq 0> <!--- irsaliye guncelleme veya silme sayfasından cagrılıyorsa once o irsaliyeye ait ORDERS_SHIP kayıtları silinir --->
				<cfif arguments.is_order_process eq 1> <!--- siparis irsaliyeye cekilmis --->
					<cfquery name="del_ship_orders" datasource="#arguments.process_db#">
						DELETE 
							FROM #arguments.process_db_alias#ORDERS_SHIP 
						WHERE 
							SHIP_ID=#arguments.related_process_id#
							AND PERIOD_ID=#session_base.period_id#
							<cfif len(no_change_order_list) and not listfind('2,3',arguments.reserve_action_type) and arguments.reserve_action_iptal neq 1> <!--- silme veya iptal degilse CHANGE_RESERVE_STATUS 0 olan siparislere ait satırlar silinmiyor --->
							AND ORDER_ID NOT IN (#no_change_order_list#)
							</cfif> 
					</cfquery>
				<cfelseif arguments.is_order_process eq 2>
					<cfquery name="del_ship_orders" datasource="#arguments.process_db#">
						DELETE 
							FROM #arguments.process_db_alias#ORDERS_INVOICE 
						WHERE 
							INVOICE_ID=#arguments.related_process_id#
							AND PERIOD_ID=#session_base.period_id#
							<cfif len(no_change_order_list) and not listfind('2,3',arguments.reserve_action_type) and arguments.reserve_action_iptal neq 1> <!--- silme veya iptal degilse CHANGE_RESERVE_STATUS 0 olan siparislere ait satırlar silinmiyor --->
							AND ORDER_ID NOT IN (#no_change_order_list#)
							</cfif> 
					</cfquery>
				</cfif>
			</cfif>
		<cfelse>
			<cfset ship_related_order_list=arguments.reserve_order_id>
		</cfif> 
		<cfloop list="#ship_related_order_list#" index="order_ind_">
			<cfset reserve_stock_list_ =''><!--- yerini degistirmeyelim her sipariste liste resetlenmeli. --->
			<cfset ship_stock_list_ =''>
			<cfset ship_stock_relation_list_ =''>
			<!--- ORDERS_SHIP - ORDER_INVOICE tablosuna kayıt yazılması için
			1-irsaliye veya faturayla iliskisi kesilmis siparisler listesinde olmamalı.
			2-iptal veya silme isleminden cagrılmamıs olmalı
			3-guncelleme isleminden cagrılmıssa degistirilmeyecek siparisler listesinde olmamalı, cunku guncellemede bu siparislerin ORDERS_SHIP - ORDER_INVOICE'deki kayıtları silmiyoruz --->
			<cfif arguments.is_order_process neq 3 and not listfind(removed_order_list,order_ind_) and not ( arguments.reserve_action_iptal eq 1 or arguments.reserve_action_type eq 2 ) and not (arguments.reserve_action_type eq 1 and listfind(no_change_order_list,order_ind_) )>
				<cfif arguments.is_order_process eq 1>
					<cfquery name="add_orders_ship" datasource="#arguments.process_db#"> <!--- 1. siparis-irsaliye iliskisini tutan ORDERS_SHIP tablosuna kayıt atılır --->
						INSERT INTO
							#arguments.process_db_alias#ORDERS_SHIP
							(
								ORDER_ID,
								SHIP_ID,
								PERIOD_ID
							)
						VALUES
							(
								#order_ind_#,
								#arguments.related_process_id#,
								#session_base.period_id#
							)
					</cfquery>
				<cfelseif arguments.is_order_process eq 2> <!--- siparis faturaya cekilmisse --->
					<cfquery name="add_orders_ship" datasource="#arguments.process_db#"> <!--- 1. siparis-irsaliye iliskisini tutan ORDERS_SHIP tablosuna kayıt atılır --->
						INSERT INTO
							#arguments.process_db_alias#ORDERS_INVOICE
							(
								ORDER_ID,
								INVOICE_ID,
								PERIOD_ID
							)
						VALUES
							(
								#order_ind_#,
								#arguments.related_process_id#,
								#session_base.period_id#
							)
					</cfquery>
				</cfif>
			</cfif> 
			<!--- 2.siparisi urunlerinin miktarları alınıyor --->
			<cfquery name="get_order_amounts" datasource="#arguments.process_db#">
				SELECT 
					(ORR.QUANTITY-ISNULL(ORR.CANCEL_AMOUNT,0)) AS ORDER_AMOUNT,
					ORR.STOCK_ID,
					ORR.ORDER_ROW_ID,
					ISNULL(ORR.WRK_ROW_ID,0) AS WRK_ROW_ID,
					ORR.RESERVE_TYPE,
					ORR.ORDER_ROW_CURRENCY AS ROW_CURRENCY,
					O.RESERVED
				FROM 
					#arguments.process_db_alias#ORDERS O,
					#arguments.process_db_alias#ORDER_ROW ORR
				WHERE 
					O.ORDER_ID=ORR.ORDER_ID
					AND O.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#">
					<cfif arguments.is_order_process eq 3>
						<!--- Iptalden Geliyorsa sadece ilgili satiri degerlendirsin, Siparis Karsilama Popupindan baska bir yerde is_order_process:3 gelmediginden ekledim, sorun olursa duzeltelim fbs 20130314 --->
						<cfif len(arguments.reserve_wrk_row_id) and arguments.reserve_wrk_row_id neq 0>
							AND ISNULL(WRK_ROW_ID,0) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.reserve_wrk_row_id#">
						</cfif>
					</cfif>
				ORDER BY
					ORR.STOCK_ID,
					ORR.ORDER_ROW_ID				
			</cfquery>
			<cfquery name="get_order_stock_counts" datasource="#arguments.process_db#">
				SELECT 
					COUNT(STOCK_ID) AS STOCK_COUNT,
					ORR.STOCK_ID
				FROM 
					#arguments.process_db_alias#ORDER_ROW ORR
				WHERE 
					ORR.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#">
				GROUP BY
					ORR.STOCK_ID
				HAVING 
					COUNT(STOCK_ID) > 1
				ORDER BY
					ORR.STOCK_ID				
			</cfquery>
			<cfset stock_count_list_=valuelist(get_order_stock_counts.STOCK_ID)>
			<!---3.satır rezerveleri karsılastırmak icin siparisteki urunlerin  stok hareketi yapan irsaliyelere cekilmis miktarları bulunuyor --->
			<cfif arguments.is_order_process neq 3> <!--- iptalden gelen rezerve işlemleri farklı bölümde set edildi --->
				<cfquery name="get_reserve_amounts" datasource="#arguments.process_db#">
					SELECT
					<cfif arguments.is_purchase_sales>
						SUM(STOCK_OUT) AS RESERVE_AMOUNT,
					<cfelse>
						SUM(STOCK_IN) AS RESERVE_AMOUNT,
					</cfif>
						STOCK_ID,
						ISNULL(ORDER_WRK_ROW_ID,0) AS ORDER_WRK_ROW_ID
					FROM
						#arguments.process_db_alias#ORDER_ROW_RESERVED
					WHERE
						ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#">
						AND (SHIP_ID IS NOT NULL OR INVOICE_ID IS NOT NULL)
					GROUP BY
						STOCK_ID,
						ISNULL(ORDER_WRK_ROW_ID,0)
					ORDER BY
						STOCK_ID
				</cfquery>
			</cfif>
			<cfif listfind('1,3',arguments.is_order_process)><!--- irsaliyeyle iliskiliyse veya satır iptal den geliyorsa--->
				<cfquery name="get_order_ship_periods" datasource="#arguments.process_db#">
					SELECT DISTINCT PERIOD_ID FROM #arguments.process_db_alias#ORDERS_SHIP WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#">
					UNION
					SELECT DISTINCT PERIOD_ID FROM #arguments.process_db_alias#ORDERS_INVOICE WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#">
				</cfquery>
				<cfif get_order_ship_periods.recordcount> <!--- siparisle ilgili irsaliye kaydı varsa --->
					<cfset orders_ship_period_list = valuelist(get_order_ship_periods.PERIOD_ID)>
					<!--- 4. siparis sadece aktif donemdeki irsaliyelerle iliskilendirilmis --->
					<cfif listlen(orders_ship_period_list) eq 1 and orders_ship_period_list eq session_base.period_id>
						<cfquery name="get_all_ship_amount" datasource="#arguments.process_db#">
							SELECT
								ROUND(SUM(SHIP_AMOUNT),2) SHIP_AMOUNT,
								STOCK_ID,
								WRK_ROW_RELATION_ID
							FROM
							(
								<!--- direkt ilişkili irsaliyeler --->
								SELECT
									SUM(SR.AMOUNT) AS SHIP_AMOUNT,
									SR.STOCK_ID,
									ISNULL(SR.WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID
								FROM
									#dsn2_alias#.SHIP S,
									#dsn2_alias#.SHIP_ROW SR
								WHERE
									S.SHIP_ID=SR.SHIP_ID
									AND SR.ROW_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#">
									<cfif len(arguments.related_process_id) and reserve_action_type eq 2><!--- silme isleminde silinecek irsaliye haricindeki irsaliyelerin satırlarına bakılıyor --->
									AND S.SHIP_ID NOT IN (#arguments.related_process_id#)
									</cfif>
								GROUP BY
									SR.STOCK_ID,
									ISNULL(SR.WRK_ROW_RELATION_ID,0)
								<!--- irsaliyelerin iadeleri --->
								UNION ALL
								SELECT
									SUM(-1*SRR.AMOUNT) AS SHIP_AMOUNT,
									SR.STOCK_ID,
									ISNULL(SR.WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID
								FROM
									#dsn2_alias#.SHIP S,
									#dsn2_alias#.SHIP SS,
									#dsn2_alias#.SHIP_ROW SR,
									#dsn2_alias#.SHIP_ROW SRR
								WHERE
									S.SHIP_ID=SR.SHIP_ID
									AND SS.SHIP_ID=SRR.SHIP_ID
									AND SR.WRK_ROW_ID=SRR.WRK_ROW_RELATION_ID
									AND SS.SHIP_TYPE IN(73,74,78)
									AND SR.ROW_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#">
									<cfif len(arguments.related_process_id) and reserve_action_type eq 2><!--- silme isleminde silinecek irsaliye haricindeki irsaliyelerin satırlarına bakılıyor --->
										AND S.SHIP_ID NOT IN (#arguments.related_process_id#)
									</cfif>
								GROUP BY
									SR.STOCK_ID,
									ISNULL(SR.WRK_ROW_RELATION_ID,0)
								UNION ALL
								SELECT
									SUM(IR.AMOUNT) AS SHIP_AMOUNT,
									IR.STOCK_ID,
									ISNULL(IR.WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID
								FROM
									#dsn2_alias#.INVOICE I,
									#dsn2_alias#.INVOICE_ROW IR
								WHERE
									I.INVOICE_ID=IR.INVOICE_ID
									AND IR.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#">
								GROUP BY
									IR.STOCK_ID,
									ISNULL(IR.WRK_ROW_RELATION_ID,0)
							)T1
							GROUP BY
								STOCK_ID,
								WRK_ROW_RELATION_ID
							ORDER BY
								STOCK_ID
						</cfquery>
					<cfelse>
						<!--- 5. siparis farklı periyotlardaki irsaliyelerle iliskili --->
						<cfquery name="get_period_dsns" datasource="#arguments.process_db#">
							SELECT PERIOD_YEAR,OUR_COMPANY_ID,PERIOD_ID FROM #dsn_alias#.SETUP_PERIOD WHERE PERIOD_ID IN (#orders_ship_period_list#)
						</cfquery>
						<cfquery name="get_all_ship_amount" datasource="#arguments.process_db#">
							SELECT
								ROUND(SUM(SHIP_AMOUNT),2) AS SHIP_AMOUNT,
								A1.STOCK_ID,
								A1.WRK_ROW_RELATION_ID
							FROM
							(
								<cfloop query="get_period_dsns">
									SELECT
										SUM(SR.AMOUNT) AS SHIP_AMOUNT,
										SR.STOCK_ID,
										ISNULL(SR.WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID
									FROM
										#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP S,
										#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP_ROW SR
									WHERE
										S.SHIP_ID = SR.SHIP_ID
										AND SR.ROW_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#">
										<cfif get_period_dsns.PERIOD_YEAR eq session_base.period_id and len(arguments.related_process_id) and reserve_action_type eq 2>
										AND S.SHIP_ID NOT IN (#arguments.related_process_id#)
										</cfif>
									GROUP BY
										SR.STOCK_ID,
										ISNULL(SR.WRK_ROW_RELATION_ID,0)
									<!--- irsaliyelerin iadeleri --->
									UNION ALL
									SELECT
										SUM(-1*SRR.AMOUNT) AS SHIP_AMOUNT,
										SR.STOCK_ID,
										ISNULL(SR.WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID
									FROM
										#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP S,
										#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP SS,
										#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP_ROW SR,
										#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP_ROW SRR
									WHERE
										S.SHIP_ID=SR.SHIP_ID
										AND SS.SHIP_ID=SRR.SHIP_ID
										AND SR.WRK_ROW_ID=SRR.WRK_ROW_RELATION_ID
										AND SS.SHIP_TYPE IN(73,74,78)
										AND SR.ROW_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#">
										<cfif len(arguments.related_process_id) and reserve_action_type eq 2><!--- silme isleminde silinecek irsaliye haricindeki irsaliyelerin satırlarına bakılıyor --->
											AND S.SHIP_ID NOT IN (#arguments.related_process_id#)
										</cfif>
									GROUP BY
										SR.STOCK_ID,
										ISNULL(SR.WRK_ROW_RELATION_ID,0)
									UNION ALL
									SELECT
										SUM(IR.AMOUNT) AS SHIP_AMOUNT,
										IR.STOCK_ID,
										ISNULL(IR.WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID
									FROM
										#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.INVOICE I,
										#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.INVOICE_ROW IR
									WHERE
										I.INVOICE_ID=IR.INVOICE_ID
										AND IR.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#">
									GROUP BY
										IR.STOCK_ID,
										ISNULL(IR.WRK_ROW_RELATION_ID,0)
									<cfif currentrow neq get_period_dsns.recordcount> UNION ALL </cfif>					
								</cfloop> 
							) AS A1
							GROUP BY
								A1.STOCK_ID,
								A1.WRK_ROW_RELATION_ID
							ORDER BY
								A1.STOCK_ID
						</cfquery>
					</cfif>
					<cfset reserve_stock_list_ = listsort(valuelist(get_reserve_amounts.STOCK_ID),'numeric','ASC')>
					<cfset reserve_stock_relation_list_ = valuelist(get_reserve_amounts.ORDER_WRK_ROW_ID)>
					<cfset ship_stock_list_ = listsort(valuelist(get_all_ship_amount.STOCK_ID),'numeric','ASC')>
					<cfset ship_stock_relation_list_ = valuelist(get_all_ship_amount.WRK_ROW_RELATION_ID)>
				</cfif>
			<cfelseif arguments.is_order_process eq 2> <!--- faturayla iliskiliyse --->
				<cfquery name="get_order_ship_periods" datasource="#arguments.process_db#">
					SELECT DISTINCT PERIOD_ID FROM #arguments.process_db_alias#ORDERS_INVOICE WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#">
					UNION
					SELECT DISTINCT PERIOD_ID FROM #arguments.process_db_alias#ORDERS_SHIP WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#">
				</cfquery>
				<cfif get_order_ship_periods.recordcount>
					<cfset orders_ship_period_list = valuelist(get_order_ship_periods.PERIOD_ID)>
					<!--- 4. siparis sadece aktif donemdeki irsaliyelerle iliskilendirilmis --->
					<cfif listlen(orders_ship_period_list) eq 1 and orders_ship_period_list eq session_base.period_id>
						<cfquery name="get_all_ship_amount" datasource="#arguments.process_db#">
							SELECT
								ROUND(SUM(SHIP_AMOUNT),2) AS SHIP_AMOUNT,
								T1.STOCK_ID,
								T1.WRK_ROW_RELATION_ID
							FROM
							(	SELECT
									SUM(SR.AMOUNT) AS SHIP_AMOUNT,
									SR.STOCK_ID,
									ISNULL(SR.WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID
								FROM
									#dsn2_alias#.SHIP S,
									#dsn2_alias#.SHIP_ROW SR
								WHERE
									S.SHIP_ID=SR.SHIP_ID
									AND SR.ROW_ORDER_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#">
								GROUP BY
									SR.STOCK_ID,
									ISNULL(SR.WRK_ROW_RELATION_ID,0)
							UNION ALL
								SELECT
									SUM(IR.AMOUNT) AS SHIP_AMOUNT,
									IR.STOCK_ID,
									ISNULL(IR.WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID
								FROM
									#dsn2_alias#.INVOICE I,
									#dsn2_alias#.INVOICE_ROW IR
								WHERE
									I.INVOICE_ID=IR.INVOICE_ID
									AND I.INVOICE_CAT NOT IN(55,62)
									AND IR.ORDER_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#">
									<cfif len(arguments.related_process_id) and reserve_action_type eq 2> <!--- silme isleminde silinecek fatura haricindeki faturaların satırlarına bakılıyor --->
									AND I.INVOICE_ID NOT IN (#arguments.related_process_id#)
									</cfif>
								GROUP BY
									IR.STOCK_ID,
									ISNULL(IR.WRK_ROW_RELATION_ID,0)
							UNION ALL
								SELECT
									SUM(-1*IR.AMOUNT) AS SHIP_AMOUNT,
									IR.STOCK_ID,
									ISNULL(IR.WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID
								FROM
									#dsn2_alias#.INVOICE I,
									#dsn2_alias#.INVOICE_ROW IR
								WHERE
									I.INVOICE_ID=IR.INVOICE_ID
									AND I.INVOICE_CAT IN(55,62)
									AND IR.ORDER_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#">
									<cfif len(arguments.related_process_id) and reserve_action_type eq 2> <!--- silme isleminde silinecek fatura haricindeki faturaların satırlarına bakılıyor --->
									AND I.INVOICE_ID NOT IN (#arguments.related_process_id#)
									</cfif>
								GROUP BY
									IR.STOCK_ID,
									ISNULL(IR.WRK_ROW_RELATION_ID,0)
							)T1
							GROUP BY
								T1.STOCK_ID,
								T1.WRK_ROW_RELATION_ID
							ORDER BY
								T1.STOCK_ID
						</cfquery>
					<cfelse>
					<!--- 5. siparis farklı periyotlardaki irsaliyelerle iliskili --->
						<cfquery name="get_period_dsns" datasource="#arguments.process_db#">
							SELECT PERIOD_YEAR,OUR_COMPANY_ID,PERIOD_ID FROM #dsn_alias#.SETUP_PERIOD WHERE PERIOD_ID IN (#orders_ship_period_list#)
						</cfquery>
						<cfquery name="get_all_ship_amount" datasource="#arguments.process_db#">
							SELECT
								SUM(A1.SHIP_AMOUNT) AS SHIP_AMOUNT,
								A1.STOCK_ID,
								A1.WRK_ROW_RELATION_ID
							FROM
							(
							<cfloop query="get_period_dsns">
								SELECT
									SUM(SR.AMOUNT) AS SHIP_AMOUNT,
									SR.STOCK_ID,
									ISNULL(SR.WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID
								FROM
									#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP S,
									#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP_ROW SR
								WHERE
									S.SHIP_ID=SR.SHIP_ID
									AND SR.ROW_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#">
								GROUP BY
									SR.STOCK_ID,
									ISNULL(SR.WRK_ROW_RELATION_ID,0)
							UNION ALL
								SELECT
									SUM(IR.AMOUNT) AS SHIP_AMOUNT,
									IR.STOCK_ID,
									ISNULL(WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID
								FROM
									#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.INVOICE I,
									#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.INVOICE_ROW IR
								WHERE
									I.INVOICE_ID=IR.INVOICE_ID
									AND IR.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#order_ind_#">
									<cfif get_period_dsns.PERIOD_YEAR eq session_base.period_id and len(arguments.related_process_id) and reserve_action_type eq 2> <!--- silme isleminde silinecek irsaliye haricindeki irsaliyelerin satırlarına bakılıyor --->
									AND I.INVOICE_ID NOT IN (#arguments.related_process_id#)
									</cfif>
								GROUP BY
									IR.STOCK_ID,
									ISNULL(WRK_ROW_RELATION_ID,0)
								<cfif currentrow neq get_period_dsns.recordcount> UNION ALL </cfif>					
							</cfloop> ) AS A1
								GROUP BY
									A1.STOCK_ID,
									A1.WRK_ROW_RELATION_ID
								ORDER BY
									A1.STOCK_ID
						</cfquery>
					</cfif>
					<cfset reserve_stock_list_ = listsort(valuelist(get_reserve_amounts.STOCK_ID),'numeric','ASC')>
					<cfset reserve_stock_relation_list_ = valuelist(get_reserve_amounts.ORDER_WRK_ROW_ID)>
					<cfset ship_stock_list_ = listsort(valuelist(get_all_ship_amount.STOCK_ID),'numeric','ASC')>
					<cfset ship_stock_relation_list_ = valuelist(get_all_ship_amount.WRK_ROW_RELATION_ID)>
				</cfif>
			</cfif>
			<cfset order_process_flag = 0>
			<!--- -1 Açık, -2 Tedarik, -3 Kapatıldı, -4 Kısmi Üretim, -5 Üretim, -6 Sevk, -7 Eksik Teslimat, -8 Fazla Teslimat, -9 İptal, -10 Kapatıldı(Manuel --->
			<cfset paper_general_reserve_type = false> <!--- belge bazında rezerveyi gosterir --->
			<cfloop query="get_order_amounts"><!---6. siparis satırlarının reserve_type belirleniyor. DIKKAT: rezerve_type stok hareketi yapan irsaliyelerdeki miktarlara gore hesaplanır --->
				<br/>
				<cfif arguments.is_order_process neq 3> <!--- satır iptal veya rezerve çöz değilse --->
					<cfif listlen(reserve_stock_list_) and listfind(reserve_stock_list_,STOCK_ID) and (get_order_amounts.RESERVE_TYPE neq -3  AND get_order_amounts.row_currency and not listfind('-9,-10',get_order_amounts.row_currency)) and not listfind(no_change_order_list,order_ind_)>
						<cfset order_row_reserve_amount_=ORDER_AMOUNT>
						<cfif not ( isdefined('_reserved_order_stock_amount_#order_ind_#_#STOCK_ID#') and len(evaluate('_reserved_order_stock_amount_#order_ind_#_#STOCK_ID#')) ) and get_reserve_amounts.ORDER_WRK_ROW_ID[listfind(reserve_stock_list_,STOCK_ID)] eq 0>
							<cfset '_reserved_order_stock_amount_#order_ind_#_#STOCK_ID#'=get_reserve_amounts.RESERVE_AMOUNT[listfind(reserve_stock_list_,STOCK_ID)]>
						</cfif>
						<cfif len(WRK_ROW_ID) and WRK_ROW_ID neq 0 and listfind(reserve_stock_relation_list_,WRK_ROW_ID)><!--- satırın birebir ilişkili oldugu sipariş satırları bulunuyor --->
							<cfset '_reserved_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#'=get_reserve_amounts.RESERVE_AMOUNT[listfind(reserve_stock_relation_list_,WRK_ROW_ID)]>
						<cfelse>
							<cfset '_reserved_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#'=0>
						</cfif>
						<cfif not (isdefined('_reserved_order_stock_amount_#order_ind_#_#STOCK_ID#') and len(evaluate('_reserved_order_stock_amount_#order_ind_#_#STOCK_ID#')) )>
							<cfset '_reserved_order_stock_amount_#order_ind_#_#STOCK_ID#'=0>
						</cfif>
						<cfif len(WRK_ROW_ID) and WRK_ROW_ID neq 0 and evaluate('_reserved_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#') gt 0>
							<cfset row_temp_reserve_amount=ORDER_AMOUNT-evaluate('_reserved_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#')> <!--- satırı kapatmak için gerekli olan kalan miktar --->
						<cfelse>
							<cfset row_temp_reserve_amount=ORDER_AMOUNT>
						</cfif>	
						<cfif evaluate('_reserved_order_stock_amount_#order_ind_#_#STOCK_ID#') gt 0 and row_temp_reserve_amount gt 0>
							<cfif evaluate('_reserved_order_stock_amount_#order_ind_#_#STOCK_ID#') gte row_temp_reserve_amount>
								<cfset '_reserved_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#'=evaluate('_reserved_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#')+row_temp_reserve_amount>
								<cfset '_reserved_order_stock_amount_#order_ind_#_#STOCK_ID#'=evaluate('_reserved_order_stock_amount_#order_ind_#_#STOCK_ID#')-row_temp_reserve_amount>
							<cfelseif evaluate('_reserved_order_stock_amount_#order_ind_#_#STOCK_ID#') lt row_temp_reserve_amount>
								<cfset '_reserved_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#'=evaluate('_reserved_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#')+evaluate('_reserved_order_stock_amount_#order_ind_#_#STOCK_ID#')>
								<cfset '_reserved_order_stock_amount_#order_ind_#_#STOCK_ID#'=0>
							</cfif>
						</cfif>
						<cfif ORDER_AMOUNT lte abs(evaluate('_reserved_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#')) and abs(evaluate('_reserved_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#')) gt 0>
							<cfset order_row_reserve_type_ = -4> <!--- Rezerve Kapatıldı --->
						<cfelseif ORDER_AMOUNT gt evaluate('_reserved_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#') and evaluate('_reserved_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#') gt 0>
							<cfset order_row_reserve_type_ = -2> <!--- Kısmı Rezerve--->
						<cfelseif evaluate('_reserved_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#') eq 0>
							<cfset order_row_reserve_type_ = -1> <!--- Rezerve Değil--->
						<cfelse>
							<cfset order_row_reserve_type_ = get_order_amounts.RESERVE_TYPE>
						</cfif>
					<cfelse>
					 <!--- 1-irsaliyeye cekilmis olsada siparis satırında rezerve degil secilmisse rezerve tipi değiştirilmez 2- CHANGE_RESERVE_STATUS 0 olan yani no_change_order_list listesindeki siparislerin reserve asamaları da degistirilmez. --->
						<cfset order_row_reserve_type_ = get_order_amounts.RESERVE_TYPE> <!--- stok hareketi yapan irsaliyeye cekilmemis satır siparisteki rezerve tipini korur --->
					</cfif>
					<cfif listfind('-1,-2',order_row_reserve_type_) and listfind('0,1',arguments.reserve_action_type)><!---Ekleme ve Güncelleme İşlemlerinde tek bir satır bile rezerve veya kısmı rezerve ise belge bazında rezervasyon secilir--->
						<cfset paper_general_reserve_type = true>
					<cfelseif listfind('-1,-2,-4',order_row_reserve_type_) and (arguments.reserve_action_type eq 2 or reserve_action_iptal eq 1)>
					<!--- silme ve iptal islemlerinde kısmı rezerve ve kapatılan rezerve satırlar asagıda rezerve olarak update edileceginden belge bazında rezervede secilmelidir  --->
						<cfset paper_general_reserve_type = true>
					</cfif>
				</cfif>
				
				<cfif listfind('-1,-3,-6,-7,-8,-10',get_order_amounts.ROW_CURRENCY) and listlen(ship_stock_list_) and listfind(ship_stock_list_,STOCK_ID)>	<!---7. siparis satırlarının asamaları (order_currency) belirleniyor. DIKKAT: order_currency irsaliyelestirilen toplam miktara gore bulunuyor --->
					<cfset order_process_flag = 1>
				</cfif>
				<cfif listfind('-1,-3,-6,-7,-8',get_order_amounts.ROW_CURRENCY) and listlen(ship_stock_list_) and listfind(ship_stock_list_,STOCK_ID)>	<!---7. siparis satırlarının asamaları (order_currency) belirleniyor. DIKKAT: order_currency irsaliyelestirilen toplam miktara gore bulunuyor --->	
					<cfif not (isdefined('_used_order_stock_amount_#order_ind_#_#STOCK_ID#') and len(evaluate('_used_order_stock_amount_#order_ind_#_#STOCK_ID#')) ) and get_all_ship_amount.WRK_ROW_RELATION_ID[listfind(ship_stock_list_,STOCK_ID)] eq 0>
						<!--- relation baglantısı olmayan o siparişteki aynı urunler için toplam kullanılmış miktar --->
						<cfset '_used_order_stock_amount_#order_ind_#_#STOCK_ID#'=get_all_ship_amount.SHIP_AMOUNT[listfind(ship_stock_list_,STOCK_ID)]>
					</cfif>
					<cfif len(WRK_ROW_ID) and WRK_ROW_ID neq 0 and listfind(ship_stock_relation_list_,WRK_ROW_ID)><!--- satırın birebir ilişkili oldugu sipariş satırları bulunuyor --->
						<cfset '_used_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#'=get_all_ship_amount.SHIP_AMOUNT[listfind(ship_stock_relation_list_,WRK_ROW_ID)]>
					<cfelse>
						<cfset '_used_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#'=0>
					</cfif>
					<cfif not (isdefined('_used_order_stock_amount_#order_ind_#_#STOCK_ID#') and len(evaluate('_used_order_stock_amount_#order_ind_#_#STOCK_ID#')) )>
						<cfset '_used_order_stock_amount_#order_ind_#_#STOCK_ID#'=0>
					</cfif>
					<cfif len(WRK_ROW_ID) and WRK_ROW_ID neq 0 and evaluate('_used_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#') gt 0>
						<cfset row_temp_amount=ORDER_AMOUNT-evaluate('_used_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#')> <!--- satırı kapatmak için gerekli olan kalan miktar --->
					<cfelse>
						<cfset row_temp_amount=ORDER_AMOUNT>
					</cfif>
					<cfif evaluate('_used_order_stock_amount_#order_ind_#_#STOCK_ID#') gte 0 and row_temp_amount gt 0>
						<cfif evaluate('_used_order_stock_amount_#order_ind_#_#STOCK_ID#') gte row_temp_amount>
							<cfset '_used_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#'=evaluate('_used_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#')+row_temp_amount>
							<cfset '_used_order_stock_amount_#order_ind_#_#STOCK_ID#'=evaluate('_used_order_stock_amount_#order_ind_#_#STOCK_ID#')-row_temp_amount>
						<cfelseif evaluate('_used_order_stock_amount_#order_ind_#_#STOCK_ID#') lt row_temp_amount>
							<cfset '_used_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#'=evaluate('_used_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#')+evaluate('_used_order_stock_amount_#order_ind_#_#STOCK_ID#')>
							<cfset '_used_order_stock_amount_#order_ind_#_#STOCK_ID#'=0>
						</cfif>
					</cfif>
					<cfif wrk_round(ORDER_AMOUNT,2) eq abs(wrk_round(evaluate('_used_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#'),2)) and abs(evaluate('_used_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#')) gt 0>
						<cfset order_row_currency = -3> <!--- kapatıldı aşaması --->
					<cfelseif wrk_round(ORDER_AMOUNT,2) gt wrk_round(evaluate('_used_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#'),2) and evaluate('_used_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#') gt 0>
						<cfset order_row_currency = -7> <!---eksik teslimat aşaması--->
					<cfelseif ORDER_AMOUNT lt evaluate('_used_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#') and evaluate('_used_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#') gt 0>
						<cfif listfind(stock_count_list_,STOCK_ID) and not (len(WRK_ROW_ID) and WRK_ROW_ID neq 0)> 
							<!--- siparişte aynı ürün birden fazla satırda varsa ilk satırlar sipariş aşaması kapatıldı set edilir --->
							<cfif isdefined('order_stock_count_#order_ind_#_#STOCK_ID#_') and len(evaluate('order_stock_count_#order_ind_#_#STOCK_ID#_'))>
								<cfset 'order_stock_count_#order_ind_#_#STOCK_ID#_'=evaluate('order_stock_count_#order_ind_#_#STOCK_ID#_')+1>
							<cfelse>
								<cfset 'order_stock_count_#order_ind_#_#STOCK_ID#_'=1>
							</cfif>
							<cfif evaluate('order_stock_count_#order_ind_#_#STOCK_ID#_') lt get_order_stock_counts.STOCK_COUNT[listfind(stock_count_list_,STOCK_ID)]>
								<cfset order_row_currency = -3> <!--- kapatıldı aşaması--->
							<cfelse>
								<cfset order_row_currency = -8> <!--- fazla teslimat aşaması--->
							</cfif>
						<cfelse>
							<cfset order_row_currency = -8> <!--- fazla teslimat aşaması--->
						</cfif>
					<cfelseif listfind('-3,-7,-8',get_order_amounts.ROW_CURRENCY) and ORDER_AMOUNT gt evaluate('_used_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#') and evaluate('_used_order_row_stock_amount_#order_ind_#_#WRK_ROW_ID#') eq 0>
						<cfset order_row_currency = -6> <!---sevk teslimat aşaması--->
					<cfelse>
						<cfset order_row_currency = get_order_amounts.ROW_CURRENCY>
					</cfif>
				<cfelse>	
					<cfset order_row_currency = get_order_amounts.ROW_CURRENCY>
				</cfif>					
				<cfif listlen(ship_stock_list_) and listfind(ship_stock_list_,STOCK_ID)>
				<!---8. irsaliyelere cekilen toplam miktarına gore siparis asaması , stok hareketi yapan miktara baglı olarak ise rezerve turu update ediliyor.--->
					<cfquery name="UPD_ORD_ROW" datasource="#arguments.process_db#">
						UPDATE 
							#arguments.process_db_alias#ORDER_ROW 
						SET 
							ORDER_ROW_CURRENCY = #order_row_currency#
							<cfif isdefined('_used_order_row_stock_amount_#order_ind_#_#get_order_amounts.WRK_ROW_ID#')>
							,DELIVER_AMOUNT = #evaluate('_used_order_row_stock_amount_#order_ind_#_#get_order_amounts.WRK_ROW_ID#')#
							<cfelse>
							,DELIVER_AMOUNT = 0
							</cfif>
							<cfif isdefined('order_row_reserve_type_') and len(order_row_reserve_type_) and listfind(reserve_stock_list_,STOCK_ID)>
							,RESERVE_TYPE = #order_row_reserve_type_#
							</cfif>
						WHERE
							ORDER_ID = #order_ind_# AND
							<cfif isdefined("arguments.control_stockid")>
							STOCK_ID=#arguments.control_stockid# AND
							<cfelse>
							STOCK_ID = #STOCK_ID# AND
							</cfif>
							ORDER_ROW_ID=#get_order_amounts.ORDER_ROW_ID#
					</cfquery>
				<cfelse> 
					<!--- 9.siparisin cekildigi irsaliye yoksa eksik teslimat, kapatıldı ve fazla teslimat aşamaları tekrar sevk haline getiriliyor
					kapatılmıs ve eksik rezerve satırlar rezerve olarak update ediliyor --->
					<cfquery name="UPD_ORD_ROW" datasource="#arguments.process_db#">
						UPDATE 
							#arguments.process_db_alias#ORDER_ROW 
						SET 
							ORDER_ROW_CURRENCY = -6
							<cfif isdefined('_used_order_row_stock_amount_#order_ind_#_#get_order_amounts.WRK_ROW_ID#')>
							,DELIVER_AMOUNT = #evaluate('_used_order_row_stock_amount_#order_ind_#_#get_order_amounts.WRK_ROW_ID#')#
							<cfelse>
							,DELIVER_AMOUNT = 0
							</cfif>
							<cfif listfind('-2,-4',get_order_amounts.reserve_type)>
								,RESERVE_TYPE = -1
							</cfif> 
						WHERE 
							ORDER_ID = #order_ind_# AND
							STOCK_ID = #STOCK_ID# AND
							ORDER_ROW_CURRENCY IN (-3,-7,-8) AND
							ORDER_ROW_ID=#get_order_amounts.ORDER_ROW_ID#
					</cfquery>
				</cfif>
			</cfloop>
			<!--- Siparisle iliskili irsaliye ve fatura kontrol edilerek IS_PROCESSED degeri sekilleniyor FBS 20120510 --->
			<cfquery name="get_relation_document_control" datasource="#arguments.process_db#" maxrows="1">
				SELECT ORDER_ID FROM #arguments.process_db_alias#ORDERS_SHIP WHERE ORDER_ID = #order_ind_#
				UNION ALL
				SELECT ORDER_ID FROM #arguments.process_db_alias#ORDERS_INVOICE WHERE ORDER_ID = #order_ind_#
			</cfquery>
			<cfif get_relation_document_control.recordcount>
				<cfset order_process_flag = 1>
			<cfelse>
				<cfset order_process_flag = 0>
			</cfif>
			<!--- //Siparisle iliskili irsaliye ve fatura kontrol edilerek IS_PROCESSED degeri sekilleniyor FBS 20120510 --->
			<cfquery name="UPD_ORD" datasource="#arguments.process_db#">
				UPDATE 
					#arguments.process_db_alias#ORDERS 
				SET 
					IS_PROCESSED = <cfif order_process_flag>1<cfelse>0</cfif>
					<cfif arguments.is_order_process neq 3>
						,RESERVED = <cfif paper_general_reserve_type>1<cfelse>0</cfif>
					</cfif>
				WHERE 
					ORDER_ID = #order_ind_#
			</cfquery>			
		</cfloop>
	</cfif>
	<cfreturn true>
</cffunction>
</cfcomponent>
