<cfsetting enablecfoutputonly="yes">
<cfprocessingdirective suppresswhitespace="yes">
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
		attributes.basket_due_value_date_=dateformat(get_ship_detail.DUE_DATE,dateformat_style);
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
			'attributes.select_info_extra#row_ind#'=get_ship_rows.SELECT_INFO_EXTRA[row_ind];
			'attributes.detail_info_extra#row_ind#'=get_ship_rows.DETAIL_INFO_EXTRA[row_ind];
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
</cfprocessingdirective>
<cfsetting enablecfoutputonly="no">
