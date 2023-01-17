<cf_date tarih="attributes.order_date">
<cfset attributes.price_date = attributes.order_date>
<cfset attributes.search_process_date = attributes.order_date>

<cfif isdefined('attributes.price_cat_id') and attributes.price_cat_id gt 0>
	<cfset attributes.price_catid = attributes.price_cat_id>
</cfif>

<cfquery name="GET_ADDRESS" datasource="#DSN#">
	SELECT 
		C.CITY, 
		C.COUNTY, 
		C.COMPANY_ADDRESS, 
		C.SEMT,	
		SETUP_CITY.CITY_NAME,
		SETUP_COUNTY.COUNTY_NAME
	FROM 
		COMPANY C, 
		SETUP_CITY, 
		SETUP_COUNTY 
	WHERE 
		C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
		C.CITY = SETUP_CITY.CITY_ID AND
		C.COUNTY = SETUP_COUNTY.COUNTY_ID 
</cfquery>
<cfset attributes.ship_address_city_id = get_address.city>
<cfset attributes.ship_address_county_id = get_address.county>
<cfset attributes.ship_address = '#get_address.company_address# #get_address.semt# #get_address.county_name# #get_address.city_name#'>
<cfset attributes.process_stage = 15>
<cfset attributes.reserved = 1>
<cfif not len(attributes.ship_date)>
	<cfset attributes.ship_date = dateformat(date_add('d',1,attributes.order_date),'dd/mm/yyyy')>	
</cfif>
<cf_date tarih="attributes.ship_date">
<cfset attributes.deliverdate = dateformat(date_add('d',1,attributes.ship_date),'dd/mm/yyyy')>
<cfset attributes.order_date = dateformat(attributes.order_date,"dd/mm/yyyy")>
<cfset attributes.ship_date = dateformat(attributes.ship_date,"dd/mm/yyyy")>	

<cfscript>
	wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.pda.userid#_'&round(rand()*100);
	form.active_period = session.pda.period_id;
	attributes.process_cat = attributes.process_stage;
	form.process_cat = attributes.process_stage;
	'ct_process_type_#attributes.process_cat#'= 76;
	attributes.paper_number = '';
	ship_number = '';
	
	form.active_company = session.pda.our_company_id;
	attributes.consumer_id = '';
	attributes.currency_multiplier = '';
	attributes.subscription_id = '';
	attributes.deliver_dept_id = '';
	attributes.deliver_loc_id = '';
	attributes.deliver_dept_name = '';
	attributes.record_emp = session.pda.userid;
	attributes.sales_emp = session.pda.userid;
	attributes.ref_company_id = "";
	attributes.ref_member_type = "";
	attributes.ref_member_id = "";
	attributes.ref_company = "";
	attributes.order_employee_id = session.pda.userid;
	attributes.order_employee = get_emp_info(attributes.order_employee_id,0,0);
	attributes.project_id = '';
	attributes.ref_no = '';
	attributes.sales_add_option = '';
	attributes.order_head = 'PDA Siparişiniz';

	form.genel_indirim = 0;
	attributes.general_prom_limit=0;
	attributes.general_prom_discount=0;
	attributes.general_prom_amount=0;
	attributes.free_prom_limit=0;
	attributes.free_prom_amount=0;
	attributes.free_prom_cost=0;

	xml_basket_net_total=0;
	xml_basket_gross_total=0;
	xml_basket_gross_total_indirimli=0;
	xml_basket_discount_total_indirimli=0;
	xml_basket_tax_total=0;
	error_flag=0;
	new_row_count = 0;
	for(row_i=1;row_i lte attributes.row_count;row_i=row_i+1)
	{
		if (evaluate('attributes.row_kontrol#row_i#'))
		{
			// indirimler default 0
			d1 = 0;
			d2 = 0;
			d3 = 0;
			d4 = 0;
			d5 = 0;
			d6 = 0;
			d7 = 0;
			d8 = 0;
			d9 = 0;
			d10= 0;
			disc_amount = 0;
	
			product_sql_str='SELECT DISTINCT 
								SB.BARCODE,
								S.STOCK_ID,
								S.PRODUCT_ID,
								S.STOCK_CODE,
								S.PRODUCT_NAME,
								S.PROPERTY,
								S.IS_INVENTORY,
								S.MANUFACT_CODE,
								S.TAX,
								S.IS_PRODUCTION,
								PU.ADD_UNIT,
								PU.PRODUCT_UNIT_ID,
								PU.MULTIPLIER,
								PP.ACCOUNT_CODE,
								PP.ACCOUNT_CODE_PUR,
								PP.ACCOUNT_IADE';
			if (isdefined('attributes.price_cat_id') and attributes.price_cat_id gt 0)
				product_sql_str=product_sql_str&'
					,
					PRICE.PRICE,
					PRICE.MONEY
				';
			else if (isdefined('attributes.price_cat_id') and attributes.price_cat_id is 0)
				product_sql_str=product_sql_str&'
					,
					PRICE_STANDART.PRICE,
					PRICE_STANDART.MONEY
				';
			else
				product_sql_str=product_sql_str&'
					,
					PRICE_STANDART.PRICE,
					PRICE_STANDART.MONEY
				';
			product_sql_str=product_sql_str&'
					FROM
						STOCKS AS S,
						PRODUCT_UNIT AS PU,
						PRODUCT_PERIOD PP,
						STOCKS_BARCODES SB
			';
			if (isdefined('attributes.price_cat_id') and attributes.price_cat_id gt 0)
				product_sql_str=product_sql_str&'
					,PRICE
				';
			else if (isdefined('attributes.price_cat_id') and attributes.price_cat_id is 0)
				product_sql_str=product_sql_str&'
					,PRICE_STANDART
				';
			else
				product_sql_str=product_sql_str&'
					,PRICE_STANDART
				';
			product_sql_str=product_sql_str&'
				WHERE
					SB.STOCK_ID = S.STOCK_ID AND
					S.PRODUCT_STATUS = 1 AND
					S.STOCK_STATUS = 1 AND
					S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
					S.PRODUCT_ID = PU.PRODUCT_ID AND
					PP.PRODUCT_ID=S.PRODUCT_ID AND
					PP.PERIOD_ID = #session.pda.period_id# AND
					PU.MAIN_UNIT = PU.ADD_UNIT AND
			';
			if (isdefined('attributes.price_cat_id') and attributes.price_cat_id gt 0)
				product_sql_str=product_sql_str&'
					S.PRODUCT_ID = PRICE.PRODUCT_ID AND
					PRICE.PRICE_CATID = #attributes.price_cat_id# AND
					(
						PRICE.STARTDATE <= #attributes.price_date# AND
						(PRICE.FINISHDATE >= #attributes.price_date# OR PRICE.FINISHDATE IS NULL)
					)
			';
			else if (isdefined('attributes.price_cat_id') and attributes.price_cat_id is 0)
				product_sql_str=product_sql_str&'
					S.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND
					PRICE_STANDART.PURCHASESALES = 1 AND
					PRICE_STANDART.PRICESTANDART_STATUS = 1 
				';
			else
				product_sql_str=product_sql_str&'
					S.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND
					PRICE_STANDART.PURCHASESALES = 1 AND
					PRICE_STANDART.PRICESTANDART_STATUS = 1 
				';
			get_product_id=cfquery(SQLString:"#product_sql_str# AND SB.BARCODE = '#evaluate("attributes.barcode#row_i#")#'",Datasource:dsn3,is_select:1);
			
			if(get_product_id.recordcount)
			{
				new_row_count = new_row_count + 1;
				attributes.product_id = get_product_id.PRODUCT_ID;//
				attributes.str_money_currency = get_product_id.MONEY;//
				get_contracts_sql_str='
							SELECT
								DISCOUNT1,
								DISCOUNT2,
								DISCOUNT3,
								DISCOUNT4,
								DISCOUNT5,
								DISCOUNT_CASH,
								DISCOUNT_CASH_MONEY
							FROM
								CONTRACT_SALES_PROD_DISCOUNT
							WHERE
								PRODUCT_ID = #attributes.product_id#'; 
				if(isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.price_catid") and len(attributes.price_catid))
					get_contracts_sql_str=get_contracts_sql_str&'
						AND (COMPANY_ID = #attributes.COMPANY_ID#
						OR (COMPANY_ID IS NULL AND C_S_PROD_DISCOUNT_ID IN (SELECT C_S_PROD_DISCOUNT_ID FROM CONTRACT_SALES_PROD_PRICE_LIST CSPPL WHERE CSPPL.C_S_PROD_DISCOUNT_ID = CONTRACT_SALES_PROD_DISCOUNT.C_S_PROD_DISCOUNT_ID AND PRICE_CAT_ID IN (#attributes.price_catid#))) )';
				else if (isdefined("attributes.price_catid") and len(attributes.price_catid))
					get_contracts_sql_str=get_contracts_sql_str&'
						AND COMPANY_ID IS NULL AND C_S_PROD_DISCOUNT_ID IN (SELECT C_S_PROD_DISCOUNT_ID FROM CONTRACT_SALES_PROD_PRICE_LIST CSPPL WHERE CSPPL.C_S_PROD_DISCOUNT_ID = CONTRACT_SALES_PROD_DISCOUNT.C_S_PROD_DISCOUNT_ID AND PRICE_CAT_ID IN (#attributes.price_catid#))';
				else if (isdefined("attributes.company_id") and len(attributes.company_id))
					get_contracts_sql_str=get_contracts_sql_str&'
						AND COMPANY_ID = #attributes.COMPANY_ID#';
				if (isdefined("attributes.search_process_date") and len(attributes.search_process_date))
					get_contracts_sql_str=get_contracts_sql_str&'
						AND (
							START_DATE <= #attributes.search_process_date#
							AND ( FINISH_DATE >= #attributes.search_process_date# OR FINISH_DATE IS NULL )
						)';
				else
					get_contracts_sql_str=get_contracts_sql_str&'
						AND START_DATE <= #now()#
						AND FINISH_DATE >= #now()#';
				get_contracts_sql_str=get_contracts_sql_str&'
					ORDER BY
						START_DATE DESC,
						RECORD_DATE DESC';
				get_contracts=cfquery(SQLString:"#get_contracts_sql_str#",Datasource:dsn3,is_select:1);
				if (not get_contracts.recordcount)
				{
					get_contracts_sql_str='
								SELECT
									DISCOUNT1,
									DISCOUNT2,
									DISCOUNT3,
									DISCOUNT4,
									DISCOUNT5,
									DISCOUNT_CASH,
									DISCOUNT_CASH_MONEY
								FROM
									CONTRACT_SALES_PROD_DISCOUNT
								WHERE
									PRODUCT_ID = #attributes.product_id# AND
									COMPANY_ID IS NULL AND
									C_S_PROD_DISCOUNT_ID NOT IN (SELECT C_S_PROD_DISCOUNT_ID FROM CONTRACT_SALES_PROD_PRICE_LIST )  AND';
					if (isdefined("attributes.search_process_date") and len(attributes.search_process_date))
						get_contracts_sql_str=get_contracts_sql_str&'
						(
							START_DATE <= #attributes.search_process_date# AND
							(FINISH_DATE >= #attributes.search_process_date# OR FINISH_DATE IS NULL)			
						)';
					else
						get_contracts_sql_str=get_contracts_sql_str&'
							START_DATE <= #now()# AND
							FINISH_DATE >= #now()#';
					get_contracts_sql_str=get_contracts_sql_str&'
						ORDER BY
							START_DATE DESC,
							RECORD_DATE DESC';
					get_contracts=cfquery(SQLString:"#get_contracts_sql_str#",Datasource:dsn3,is_select:1);
				}
				
				if(get_contracts.recordcount)
				{
					if(len(trim(get_contracts.discount1))) d1 = get_contracts.discount1;
					if(len(trim(get_contracts.discount2))) d2 = get_contracts.discount2;
					if(len(trim(get_contracts.discount3))) d3 = get_contracts.discount3;
					if(len(trim(get_contracts.discount4))) d4 = get_contracts.discount4;
					if(len(trim(get_contracts.discount5))) d5 = get_contracts.discount5;
					if(len(get_contracts.discount_cash))
					{
						if( attributes.str_money_currency is get_contracts.discount_cash_money) //urunun para birimi ile retabe para birimi aynı ise tutar aynen alınır yoksa urun para birimine cevirilir
							disc_amount = get_contracts.discount_cash;
						else
							disc_amount = wrk_round( ( (get_contracts.discount_cash * evaluate("attributes.#get_contracts.discount_cash_money#"))/evaluate("attributes.#attributes.str_money_currency#") ),4);
					}
				}
				if (len(trim(listlast(session.pda.user_location,'-'))))//<!--- indirimler için --->
					attributes.branch_id = trim(listlast(session.pda.user_location,'-'));
		
				if (IsDefined("attributes.branch_id") and isnumeric(attributes.branch_id) and isdefined('attributes.company_id') and len(attributes.company_id))
				{
					get_sales_general_discounts_sql_str='
						SELECT
							DISCOUNT
						FROM
							CONTRACT_SALES_GENERAL_DISCOUNT AS CS_GD,
							CONTRACT_SALES_GENERAL_DISCOUNT_BRANCHES CS_GDB
						WHERE
							CS_GD.GENERAL_DISCOUNT_ID = CS_GDB.GENERAL_DISCOUNT_ID
							AND CS_GDB.BRANCH_ID = #attributes.branch_id#
							AND CS_GD.COMPANY_ID = #attributes.company_id#';
					if (isdefined("attributes.search_process_date") and len(attributes.search_process_date))
						get_sales_general_discounts_sql_str=get_sales_general_discounts_sql_str&'
							AND CS_GD.START_DATE <= #attributes.search_process_date#
							AND CS_GD.FINISH_DATE >= #attributes.search_process_date#';
					else
						get_sales_general_discounts_sql_str=get_sales_general_discounts_sql_str&'
							AND CS_GD.START_DATE <= #now()#
							AND CS_GD.FINISH_DATE >= #now()#';
					get_sales_general_discounts_sql_str=get_sales_general_discounts_sql_str&'
						ORDER BY
							CS_GD.GENERAL_DISCOUNT_ID';
					get_sales_general_discounts=cfquery(SQLString:"#get_sales_general_discounts_sql_str#",Datasource:dsn3,is_select:1);
					if (get_sales_general_discounts.recordcount)
						for(curr_row=1;curr_row lte get_sales_general_discounts.recordcount;curr_row=curr_row+1)
							'd#curr_row+5#' = get_sales_general_discounts.DISCOUNT[curr_row];
				}		
				indirim_carpan = (100-d1) * (100-d2) * (100-d3) * (100-d4) * (100-d5) * (100-d6) * (100-d7) * (100-d8) * (100-d9) * (100-d10);
				
				/*  STOCK VS KONTROLLERNDEN SONRA DEĞİŞECEK
				if(GET_PRODUCT_ID.RECORDCOUNT eq 1)
				{*/
				'attributes.wrk_row_id#row_i#'="#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.pda.userid##round(rand()*100)#";
				if (isdefined('attributes.price_cat_id') and attributes.price_cat_id gt 0)
					'attributes.price_cat#row_i#' = attributes.price_cat_id;
				else
					'attributes.price_cat#row_i#' = -2;					
				//'attributes.row_total#row_i#' = filterNum(evaluate("attributes.row_total#row_i#"));
				//'attributes.row_last_total#row_i#' = filterNum(evaluate("attributes.row_last_total#row_i#"));
				//'attributes.row_lasttotal#row_i#' = filterNum(evaluate("attributes.row_last_total#row_i#"));
				//'attributes.row_taxtotal#row_i#' = 0;//bakılckk
				//'attributes.quantity#row_i#' = filterNum(evaluate("attributes.amount#row_i#"));
				'attributes.is_inventory#row_i#' = get_product_id.IS_INVENTORY;
				'attributes.product_id#row_i#'=get_product_id.PRODUCT_ID;
				'attributes.stock_id#row_i#'=get_product_id.STOCK_ID;
				//'attributes.amount#row_i#' = evaluate("attributes.amount#row_i#");
				'attributes.unit#row_i#'= get_product_id.ADD_UNIT;
				'attributes.unit_id#row_i#'= get_product_id.PRODUCT_UNIT_ID;
				for(i=1;i lte attributes.kur_say;i=i+1)
				{
					if (evaluate("attributes.hidden_rd_money_#i#") is get_product_id.MONEY)
					{
						if (evaluate("attributes.is_free_product#row_i#") eq 1)
							'attributes.price#row_i#' = wrk_round(0*evaluate("attributes.txt_rate2_#i#")/evaluate("attributes.txt_rate1_#i#"),4);					
						else							
							'attributes.price#row_i#' = wrk_round(get_product_id.PRICE*evaluate("attributes.txt_rate2_#i#")/evaluate("attributes.txt_rate1_#i#"),4);					
					}
				}
				'attributes.list_price#row_i#' = evaluate("attributes.price#row_i#");
				if (evaluate("attributes.is_free_product#row_i#") eq 1)
					'attributes.price_other#row_i#'= wrk_round(0,4);
				else
					'attributes.price_other#row_i#'= wrk_round(get_product_id.PRICE,4);
				//indirim_carpan{
				'attributes.price_indirimli#row_i#' = wrk_round(evaluate('attributes.price#row_i#')*indirim_carpan/100000000000000000000,4);
				'attributes.price_discount_indirimli#row_i#' = wrk_round(evaluate('attributes.price#row_i#') - evaluate('attributes.price_indirimli#row_i#'),4);
				'attributes.price_other_indirimli#row_i#'= wrk_round(get_product_id.PRICE*indirim_carpan/100000000000000000000,4);
				//indirim_carpan}
				'attributes.tax#row_i#'=get_product_id.TAX;							
				//'attributes.row_nettotal#row_i#' = wrk_round(evaluate("attributes.price#row_i#")*evaluate("attributes.amount#row_i#"),2);
				'attributes.row_nettotal#row_i#' = wrk_round(evaluate("attributes.price_indirimli#row_i#")*evaluate("attributes.amount#row_i#"),4);//indirim_carpan
				'attributes.row_tax_total#row_i#'= wrk_round(evaluate("attributes.row_nettotal#row_i#")*(evaluate("attributes.tax#row_i#")/100),4);
				'attributes.product_name#row_i#' = get_product_id.PRODUCT_NAME;
				'attributes.other_money_#row_i#' = get_product_id.MONEY;
				//'attributes.other_money_gross_total#row_i#' = evaluate("attributes.row_total#row_i#");
				//'attributes.other_money_value_#row_i#' = wrk_round(GET_PRODUCT_ID.PRICE*evaluate("attributes.amount#row_i#"),2);
				'attributes.other_money_value_#row_i#' = wrk_round(evaluate('attributes.price_other_indirimli#row_i#')*evaluate("attributes.amount#row_i#"),4);//indirim_carpan
				'attributes.order_currency#row_i#' = -1;
				'attributes.reserve_type#row_i#' = -1;
				'attributes.spect_id#row_i#' = "";
				'attributes.is_production#row_i#' = get_product_id.IS_PRODUCTION;
			
				//xml_basket_net_total = wrk_round(xml_basket_net_total+(evaluate("attributes.row_total#row_i#")*evaluate("attributes.amount#row_i#")));
				xml_basket_gross_total = wrk_round(xml_basket_gross_total+evaluate("attributes.row_nettotal#row_i#"),4);
				xml_basket_tax_total = wrk_round(xml_basket_tax_total+evaluate("attributes.row_tax_total#row_i#"),4);
				//indirim_carpan{
				xml_basket_gross_total_indirimli = wrk_round(xml_basket_gross_total_indirimli+wrk_round(evaluate("attributes.list_price#row_i#")*evaluate("attributes.amount#row_i#"),4),4);
				xml_basket_discount_total_indirimli = wrk_round(xml_basket_discount_total_indirimli+wrk_round(evaluate("attributes.price_discount_indirimli#row_i#")*evaluate("attributes.amount#row_i#"),4),4);
				//indirim_carpan}
	
				'attributes.indirim1#row_i#'=d1;
				'attributes.indirim2#row_i#'=d2;
				'attributes.indirim3#row_i#'=d3;
				'attributes.indirim4#row_i#'=d4;
				'attributes.indirim5#row_i#'=d5;
				'attributes.indirim6#row_i#'=d6;
				'attributes.indirim7#row_i#'=d7;
				'attributes.indirim8#row_i#'=d8;
				'attributes.indirim9#row_i#'=d9;
				'attributes.indirim10#row_i#'=d10;
				'attributes.iskonto_tutar#row_i#'=disc_amount;
				'attributes.ek_tutar_price#row_i#'=0;
				'attributes.ek_tutar#row_i#'=0;
				'attributes.ek_tutar_other_total#row_i#'=0;
				'attributes.ek_tutar_total#row_i#'=0;
				'attributes.extra_cost#row_i#'=0;
				'attributes.otv_oran#row_i#'=0;
				'attributes.row_otvtotal#row_i#'=0;
				
				/*}
				else
					abort('Seçtiğiniz Ürün Sistemde Bulunamadı<br/>');*/
				
			}
			else
				abort('Seçtiğiniz Kriterlere Göre Sistemde Uygun Ürün Bulunamadı<br/>');
		}
	}

	//attributes.rows_ = attributes.row_count;
	attributes.rows_ = new_row_count;
	//form.basket_discount_total = form.sa_discount;
	form.basket_discount_total = xml_basket_discount_total_indirimli + form.sa_discount;
	//form.basket_gross_total = xml_basket_gross_total;
	form.basket_gross_total = xml_basket_gross_total_indirimli;
	form.basket_net_total = xml_basket_gross_total+xml_basket_tax_total-form.sa_discount;
	form.basket_tax_total = xml_basket_tax_total;

</cfscript>
<cfif attributes.rows_ gt 0>
	<cfinclude template="../../sales/query/add_order_pda.cfm">
	<cfquery name="UPD_ORDER" datasource="#DSN3#">
		UPDATE 
			ORDERS 
		SET 
			ORDER_HEAD = '#session.pda.name# #session.pda.surname# - #dateformat(now(),"dd/mm/yyyy")# - #paper_full#' 
		WHERE 
			ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_order.max_id#">
	</cfquery>
    <cfstoredproc procedure="DEL_ORDER_ROW_RESERVED" datasource="#DSN3#">
        <cfprocparam cfsqltype="cf_sql_varchar" value="#cftoken#">
    </cfstoredproc>
	
	<script type="text/javascript">
		alert('<cfoutput>#paper_full#</cfoutput> no lu siparişiniz başarıyla kaydedilmiştir !');
		window.location.href = '<cfoutput>#request.self#?fuseaction=pda.form_add_order_sale&cpid=#attributes.company_id#</cfoutput>';
	</script>
</cfif>
