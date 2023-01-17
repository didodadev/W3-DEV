<cf_date tarih="attributes.ship_date">
<cfset attributes.price_date = attributes.ship_date>
<cfset attributes.search_process_date = attributes.price_date>
<cfif isdefined('attributes.price_cat_id') and attributes.price_cat_id gt 0><cfset attributes.price_catid = attributes.price_cat_id></cfif>
<cfset money_currency = session.pda.money>	
<cfset attributes.adres ="">
<cfset attributes.city_id="">
<cfset attributes.county_id="">

<cfif isDefined("attributes.order_id_listesi") and ListLen(attributes.order_id_listesi)>
	<!--- Siparis Varsa Ilk Buldugunun Adresini Getirir --->
	<cfquery name="GET_ORDER_ADDRESS" datasource="#DSN3#">
		SELECT TOP 1 SHIP_ADDRESS,SHIP_ADDRESS_ID,CITY_ID,COUNTY_ID FROM ORDERS WHERE ORDER_ID IN (#attributes.order_id_listesi#)
	</cfquery>
	<cfset attributes.ship_address = get_order_address.ship_address>
	<cfset attributes.ship_address_id = get_order_address.ship_address_id>
	<cfset attributes.ship_address_city_id = get_order_address.city_id>
	<cfset attributes.ship_address_county_id = get_order_address.county_id>
<cfelse>
	<cfquery name="GET_COMPANY_ADDRESS" datasource="#DSN#">
		SELECT COMPANY_ID, COMPANY_ADDRESS, COMPANY_POSTCODE, SEMT, COUNTY, CITY, COUNTRY FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
	</cfquery>
	<cfif len(get_company_address.company_address)>
		<cfset attributes.adres = "#attributes.adres# #get_company_address.company_address# #get_company_address.company_postcode# #get_company_address.semt#">
	</cfif>
	<cfif len(get_company_address.county)>
		<cfquery name="GET_COUNTY" datasource="#DSN#">
			SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company_address.county#">
		</cfquery>
		<cfset attributes.county_id = get_company_address.county>
		<cfset attributes.adres = "#attributes.adres# #get_county.county_name#">
	</cfif>
	<cfif len(get_company_address.city)>
		<cfquery name="GET_CITY" datasource="#DSN#">
			SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company_address.city#">
		</cfquery>
		<cfset attributes.city_id = get_company_address.city>
		<cfset attributes.adres = "#attributes.adres# #get_city.city_name#">
	</cfif>
	<cfset attributes.ship_address_id = -1>
	<cfset attributes.ship_address_city_id = attributes.city_id>
	<cfset attributes.ship_address_county_id = attributes.county_id>
	<cfset attributes.ship_address = attributes.adres>
</cfif>

<cfset attributes.reserved = 1>
<cfset attributes.deliverdate = dateformat(date_add('d',1,attributes.ship_date),'dd/mm/yyyy')>
<cfset attributes.ship_date = dateformat(attributes.ship_date,"dd/mm/yyyy")>
	
<cfset brcd_list ="">
<cfloop from="1" to="#attributes.ship_row_count#" index="rw_cnt">
	<cfset 'attributes.row_kontrol#rw_cnt#' = evaluate('attributes.ship_row_kontrol#rw_cnt#')>
    <cfif (evaluate('attributes.row_kontrol#rw_cnt#'))>
        <cfset brcd_list = listappend(brcd_list,evaluate("attributes.ship_barcode#rw_cnt#"))>
    </cfif>
</cfloop>

<cfscript>
	wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.pda.userid#_'&round(rand()*100);
	attributes.active_period = session.pda.period_id;
	'ct_process_type_#attributes.process_cat#'= 76;
	GET_SETUP_MONEY=cfquery(SQLString:"SELECT RATE2,RATE1, MONEY MONEY_TYPE,PERIOD_ID FROM SETUP_MONEY",Datasource:dsn2,is_select:1);//kurlar alınıyor
	//kurlar ile ilgili değişkenler oluşuyor		
	for(stp_mny=1;stp_mny lte GET_SETUP_MONEY.RECORDCOUNT;stp_mny=stp_mny+1)
	{
		GET_MONEY_HISTORY=cfquery(SQLString:"SELECT RATE2,RATE1,MONEY MONEY_TYPE FROM MONEY_HISTORY WHERE VALIDATE_DATE >=#createodbcdatetime(attributes.ship_date)# AND MONEY ='#GET_SETUP_MONEY.MONEY_TYPE[stp_mny]#' AND PERIOD_ID = #session.pda.period_id# ORDER BY VALIDATE_DATE ",Datasource:dsn,is_select:1);
		if(GET_MONEY_HISTORY.RECORDCOUNT)
			'#GET_SETUP_MONEY.MONEY_TYPE[stp_mny]#_rate'='#GET_MONEY_HISTORY.RATE1#;#GET_MONEY_HISTORY.RATE2#';
		else
			'#GET_SETUP_MONEY.MONEY_TYPE[stp_mny]#_rate'='#GET_SETUP_MONEY.RATE1[stp_mny]#;#GET_SETUP_MONEY.RATE2[stp_mny]#';
		'attributes.hidden_rd_money_#stp_mny#'=GET_SETUP_MONEY.MONEY_TYPE[stp_mny];
		'attributes.txt_rate1_#stp_mny#'=listfirst(evaluate('#GET_SETUP_MONEY.MONEY_TYPE[stp_mny]#_rate'),';');				
		'attributes.txt_rate2_#stp_mny#'=listlast(evaluate('#GET_SETUP_MONEY.MONEY_TYPE[stp_mny]#_rate'),';');
	}
	if(isdefined('session.pda.money2') and len(trim(session.pda.money2)))
		attributes.basket_money=session.pda.money2;
	else
		attributes.basket_money=session.pda.money;
		
	attributes.basket_rate1=listfirst(evaluate('#attributes.basket_money#_rate'),';');
	attributes.basket_rate2=listlast(evaluate('#attributes.basket_money#_rate'),';');
	
	attributes.paper_number = '';
	attributes.active_company = session.pda.our_company_id;
	attributes.consumer_id = '';
	attributes.currency_multiplier = '';
	attributes.subscription_id = '';
	attributes.deliver_dept_id = '';
	attributes.deliver_loc_id = '';
	attributes.deliver_dept_name = '';
	attributes.record_emp = session.pda.userid;
	attributes.sales_emp = session.pda.userid;
	attributes.order_employee_id = session.pda.userid;
	attributes.order_employee = get_emp_info(attributes.order_employee_id,0,0);
	attributes.ref_company_id = "";
	attributes.ref_member_type = "";
	attributes.ref_member_id = "";
	attributes.ref_company = "";
	attributes.project_id = '';
	attributes.sales_add_option = '';
	attributes.order_head = 'PDA Siparişiniz';

	attributes.genel_indirim = 0;
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
	problem_urunler = '';
	for(row_i=1;row_i lte attributes.ship_row_count;row_i=row_i+1)
	{
		'attributes.row_kontrol#row_i#' = evaluate('attributes.ship_row_kontrol#row_i#');
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
								S.TAX_PURCHASE AS TAX,
								S.IS_PRODUCTION,
								PU.ADD_UNIT,
								PU.UNIT_ID,
								PU.MAIN_UNIT,
								PU.MAIN_UNIT_ID,
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
								
								S.PRODUCT_ID = PU.PRODUCT_ID AND
								PP.PRODUCT_ID=S.PRODUCT_ID AND
								PP.PERIOD_ID = #session.pda.period_id# AND
								SB.UNIT_ID = PU.PRODUCT_UNIT_ID AND 
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
					PRICE_STANDART.PURCHASESALES = 0 AND
					PRICE_STANDART.PRICESTANDART_STATUS = 1 
					';
				else
					product_sql_str=product_sql_str&'
					S.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND
					PRICE_STANDART.PURCHASESALES = 0 AND
					PRICE_STANDART.PRICESTANDART_STATUS = 1 
					';
			GET_PRODUCT_ID=cfquery(SQLString:"#product_sql_str# AND SB.BARCODE = '#evaluate("attributes.ship_barcode#row_i#")#'",Datasource:dsn3,is_select:1);
			
			attributes.product_id = GET_PRODUCT_ID.PRODUCT_ID;//<!--- indirimler için --->
			attributes.stock_id = GET_PRODUCT_ID.STOCK_ID;//<!--- indirimler için --->
			attributes.str_money_currency = GET_PRODUCT_ID.MONEY;//<!--- indirimler için --->
			attributes.branch_id = trim(listgetat(session.pda.user_location,2,'-'));//<!--- indirimler için --->
			'attributes.lot_no#row_i#' = Evaluate('attributes.ship_lot_no#row_i#');
			if(isDefined("attributes.order_id_listesi") and Len(attributes.order_id_listesi))
			{
				relation_row_info="	SELECT
										SB.BARCODE,
										CASE WHEN OW.UNIT2 IS NULL THEN OW.QUANTITY ELSE OW.AMOUNT2 END QUANTITY,
										OW.*
									FROM
										ORDER_ROW OW,
										PRODUCT_UNIT PU,
										STOCKS_BARCODES SB
									WHERE
										OW.STOCK_ID = SB.STOCK_ID AND
										PU.PRODUCT_UNIT_STATUS = 1 AND
										PU.PRODUCT_ID = OW.PRODUCT_ID AND
										ISNULL(OW.UNIT2,OW.UNIT) = PU.ADD_UNIT AND
										SB.UNIT_ID = PU.PRODUCT_UNIT_ID AND
										OW.ORDER_ID IN (#attributes.order_id_listesi#)";
				get_related_order_info=cfquery(SQLString:"#relation_row_info# AND SB.BARCODE = '#evaluate("attributes.ship_barcode#row_i#")#'",Datasource:dsn3,is_select:1);
				'attributes.wrk_row_relation_id#row_i#' = get_related_order_info.wrk_row_id;
			}
			else
				'attributes.wrk_row_relation_id#row_i#' = "";
			
			if(not len(trim(attributes.product_id)))
			{
				'attributes.row_kontrol#row_i#' = 0;
				problem_urunler = listappend(problem_urunler,evaluate("attributes.ship_barcode#row_i#"));
			}
			else
			{
				page_unit_multiplier = 1;
				
				get_aksiyons_sql_str="
					SELECT TOP 1
						CPP.DISCOUNT1,
						CPP.DISCOUNT2,
						CPP.DISCOUNT3,
						CPP.DISCOUNT4,
						CPP.DISCOUNT5,
						CPP.DISCOUNT6,
						CPP.DISCOUNT7,
						CPP.DISCOUNT8,
						CPP.DISCOUNT9,
						CPP.DISCOUNT10,
						CPP.PURCHASE_PRICE,
						CPP.MONEY
					FROM
						CATALOG_PROMOTION AS CP,
						CATALOG_PROMOTION_PRODUCTS AS CPP";
				if(isdefined("attributes.branch_id") and len(attributes.branch_id))
					get_aksiyons_sql_str=get_aksiyons_sql_str&"
						,CATALOG_PRICE_LISTS CPL
						,PRICE_CAT PCAT";
					get_aksiyons_sql_str=get_aksiyons_sql_str&"
					WHERE
						CPP.PRODUCT_ID = #attributes.product_id# AND
						(CP.IS_APPLIED = 1) AND";
				if(isdefined("attributes.search_process_date") and len(attributes.search_process_date))
					get_aksiyons_sql_str=get_aksiyons_sql_str&"
						CP.KONDUSYON_DATE <= #attributes.search_process_date# AND
						CP.KONDUSYON_FINISH_DATE > #attributes.search_process_date# AND";
				else
					get_aksiyons_sql_str=get_aksiyons_sql_str&"
						CP.KONDUSYON_DATE <= #now()# AND
						CP.KONDUSYON_FINISH_DATE > #now()# AND";
				if(isdefined("attributes.branch_id") and len(attributes.branch_id))
					get_aksiyons_sql_str=get_aksiyons_sql_str&"
						CPL.CATALOG_PROMOTION_ID = CP.CATALOG_ID AND
						CPL.PRICE_LIST_ID = PCAT.PRICE_CATID AND
						PCAT.BRANCH LIKE '%,#attributes.branch_id#,%' AND";
					get_aksiyons_sql_str=get_aksiyons_sql_str&"
						CPP.CATALOG_ID = CP.CATALOG_ID
					ORDER BY
						CP.CATALOG_ID DESC";
				get_aksiyons=cfquery(SQLString:"#get_aksiyons_sql_str#",Datasource:dsn3,is_select:1);
				if(get_aksiyons.recordcount)
				{
					flt_price = get_aksiyons.PURCHASE_PRICE;
					flt_price_other_amount = get_aksiyons.PURCHASE_PRICE;
					d1 = get_aksiyons.discount1;
					d2 = get_aksiyons.discount2;
					d3 = get_aksiyons.discount3;
					d4 = get_aksiyons.discount4;
					d5 = get_aksiyons.discount5;
					d6 = get_aksiyons.discount6;
					d7 = get_aksiyons.discount7;
					d8 = get_aksiyons.discount8;
					d9 = get_aksiyons.discount9;
					d10 = get_aksiyons.discount10;
					if (get_aksiyons.MONEY neq money_currency)
						flt_price = flt_price * evaluate("attributes.#attributes.str_money_currency#");
					flt_price = flt_price * page_unit_multiplier;
					
					flt_price_other_amount = flt_price_other_amount * page_unit_multiplier;
				}
			
				if (not get_aksiyons.recordcount)
				{
					get_contracts_sql_str="
								SELECT
									DISCOUNT1,
									DISCOUNT2,
									DISCOUNT3,
									DISCOUNT4,
									DISCOUNT5,
									DISCOUNT_CASH,
									DISCOUNT_CASH_MONEY
								FROM
									CONTRACT_PURCHASE_PROD_DISCOUNT
								WHERE
									PRODUCT_ID = #attributes.product_id# AND";
					if(isdefined("attributes.company_id") and len(attributes.company_id))
						get_contracts_sql_str=get_contracts_sql_str&"
								COMPANY_ID = #attributes.COMPANY_ID# AND";
					if(isdefined("attributes.search_process_date") and len(attributes.search_process_date))
						get_contracts_sql_str=get_contracts_sql_str&"
								(
									START_DATE <= #attributes.search_process_date# AND
									( FINISH_DATE >= #attributes.search_process_date# OR FINISH_DATE IS NULL )
								)";
					else
						get_contracts_sql_str=get_contracts_sql_str&"
								START_DATE <= #now()# AND
								FINISH_DATE >= #now()#";
					get_contracts_sql_str=get_contracts_sql_str&"
								ORDER BY
									START_DATE DESC,
									RECORD_DATE DESC";
					
					get_contracts=cfquery(SQLString:"#get_contracts_sql_str#",Datasource:dsn3,is_select:1);
			
					if (not get_contracts.recordcount)
					{
						get_contracts_sql_str="
									SELECT
										DISCOUNT1,
										DISCOUNT2,
										DISCOUNT3,
										DISCOUNT4,
										DISCOUNT5,
										DISCOUNT_CASH,
										DISCOUNT_CASH_MONEY
									FROM
										CONTRACT_PURCHASE_PROD_DISCOUNT
									WHERE
										PRODUCT_ID = #attributes.product_id# AND
										COMPANY_ID IS NULL AND";
						if(isdefined("attributes.search_process_date") and len(attributes.search_process_date))
							get_contracts_sql_str=get_contracts_sql_str&"
								(
									START_DATE <= #attributes.search_process_date# AND
									( FINISH_DATE >= #attributes.search_process_date# OR FINISH_DATE IS NULL )
								)";
						else
							get_contracts_sql_str=get_contracts_sql_str&"
								START_DATE <= #now()# AND
								FINISH_DATE >= #now()#";
						get_contracts_sql_str=get_contracts_sql_str&"
								ORDER BY
									START_DATE DESC,
									RECORD_DATE DESC";
			
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
						attributes.branch_id = trim(listgetat(session.pda.user_location,2,'-'));
					if (IsDefined("attributes.branch_id") and len(attributes.branch_id) and isnumeric(attributes.branch_id))
					{
						get_c_general_discounts_sql_str="
							SELECT TOP 5
								DISCOUNT
							FROM
								CONTRACT_PURCHASE_GENERAL_DISCOUNT AS CPGD,
								CONTRACT_PURCHASE_GENERAL_DISCOUNT_BRANCHES CPGD_B
							WHERE
								CPGD.GENERAL_DISCOUNT_ID = CPGD_B.GENERAL_DISCOUNT_ID
								AND CPGD_B.BRANCH_ID = #attributes.branch_id#
								AND CPGD.COMPANY_ID=#attributes.company_id#";
						if (isdefined("attributes.search_process_date") and len(attributes.search_process_date))
							get_c_general_discounts_sql_str=get_c_general_discounts_sql_str&"
								AND CPGD.START_DATE <= #attributes.search_process_date#
								AND CPGD.FINISH_DATE >= #attributes.search_process_date#";
						else
							get_c_general_discounts_sql_str=get_c_general_discounts_sql_str&"
								AND CPGD.START_DATE <= #now()#
								AND CPGD.FINISH_DATE >= #now()#";
						get_c_general_discounts_sql_str=get_c_general_discounts_sql_str&"
								ORDER BY
								CPGD.GENERAL_DISCOUNT_ID";					
						get_c_general_discounts=cfquery(SQLString:"#get_c_general_discounts_sql_str#",Datasource:dsn3,is_select:1);
							if (get_c_general_discounts.recordcount)
								for(curr_row=1;curr_row lte get_c_general_discounts.recordcount;curr_row=curr_row+1)
									'd#curr_row+5#' = get_c_general_discounts.DISCOUNT[curr_row];			
					}		
				}
				
				//Eger siparisten olusturuluyorsa, siparisin indirim bilgilerini almalidir
				if(isDefined("attributes.order_id_listesi") and Len(attributes.order_id_listesi))
				{
					if(get_related_order_info.recordcount)
					{
						for(disc_=1;disc_ lte 10;disc_=disc_+1)
							'd#disc_#' = Evaluate("get_related_order_info.DISCOUNT_#disc_#");
					}
				}		
				indirim_carpan = (100-d1) * (100-d2) * (100-d3) * (100-d4) * (100-d5) * (100-d6) * (100-d7) * (100-d8) * (100-d9) * (100-d10);
				
				'attributes.net_maliyet#row_i#'=0;
				'attributes.price_cat#row_i#' = -1;		
				'attributes.wrk_row_id#row_i#' = "WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.pda.userid##round(rand()*100)#";
				'attributes.is_inventory#row_i#' = GET_PRODUCT_ID.IS_INVENTORY;
				'attributes.product_id#row_i#'=GET_PRODUCT_ID.PRODUCT_ID;
				'attributes.stock_id#row_i#'=GET_PRODUCT_ID.STOCK_ID;
				'attributes.amount#row_i#' = evaluate("attributes.ship_amount#row_i#") * GET_PRODUCT_ID.MULTIPLIER;
				'attributes.amount_other#row_i#' = evaluate("attributes.ship_amount#row_i#");
				'attributes.unit#row_i#'= GET_PRODUCT_ID.MAIN_UNIT;
				'attributes.unit_id#row_i#'= GET_PRODUCT_ID.MAIN_UNIT_ID;
				'attributes.unit_other#row_i#'= GET_PRODUCT_ID.ADD_UNIT;
				'attributes.manufact_code#row_i#' = GET_PRODUCT_ID.MANUFACT_CODE;
				
				if(isDefined("attributes.order_id_listesi") and Len(attributes.order_id_listesi))
				{
					'attributes.price#row_i#' = wrk_round(get_related_order_info.price,4);
					'attributes.price_other#row_i#'= wrk_round(get_related_order_info.price_other,4);
					'attributes.tax#row_i#'= get_related_order_info.tax;	
					'attributes.other_money_#row_i#' = get_related_order_info.other_money;
					'attributes.net_maliyet#row_i#' = get_related_order_info.COST_PRICE;
				}
				else
				{
					for(i=1;i lte attributes.kur_say;i=i+1)
					{
						if (evaluate("attributes.hidden_rd_money_#i#") is GET_PRODUCT_ID.MONEY)
							'attributes.price#row_i#' = wrk_round(GET_PRODUCT_ID.PRICE*evaluate("attributes.txt_rate2_#i#")/evaluate("attributes.txt_rate1_#i#"),4);					
					}
					'attributes.price_other#row_i#'= wrk_round(GET_PRODUCT_ID.PRICE,4);
					'attributes.tax#row_i#'= GET_PRODUCT_ID.TAX;	
					'attributes.other_money_#row_i#' = GET_PRODUCT_ID.MONEY;
				}
				'attributes.list_price#row_i#' = evaluate("attributes.price#row_i#");
				'attributes.price_indirimli#row_i#' = wrk_round(evaluate('attributes.price#row_i#')*indirim_carpan/100000000000000000000,4);
				'attributes.price_discount_indirimli#row_i#' = wrk_round(evaluate('attributes.price#row_i#') - evaluate('attributes.price_indirimli#row_i#'),4);
				'attributes.price_other_indirimli#row_i#'= wrk_round(GET_PRODUCT_ID.PRICE*indirim_carpan/100000000000000000000,4);
		
				'attributes.row_total#row_i#'= (Evaluate('attributes.amount#row_i#') * Evaluate('attributes.price#row_i#'));
				'attributes.row_nettotal#row_i#' = wrk_round(evaluate("attributes.price_indirimli#row_i#")*evaluate("attributes.amount#row_i#"),4);//indirim_carpan
				'attributes.row_taxtotal#row_i#'= wrk_round(evaluate("attributes.row_nettotal#row_i#")*(evaluate("attributes.tax#row_i#")/100),4);
				'attributes.row_lasttotal#row_i#' = wrk_round(evaluate("attributes.row_nettotal#row_i#") + evaluate("attributes.row_taxtotal#row_i#"),4);
		
				'attributes.product_name#row_i#' = '#GET_PRODUCT_ID.PRODUCT_NAME#-#GET_PRODUCT_ID.PROPERTY#';
				'attributes.other_money_value_#row_i#' = wrk_round(evaluate('attributes.price_other_indirimli#row_i#')*evaluate("attributes.amount#row_i#"),4);//indirim_carpan
				'attributes.other_money_gross_total#row_i#' = wrk_round(evaluate('attributes.other_money_value_#row_i#')*(1 + (evaluate("attributes.tax#row_i#")/100) ),4);
				'attributes.order_currency#row_i#' = -1;
				'attributes.reserve_type#row_i#' = -1;
				'attributes.spect_id#row_i#' = "";
				'attributes.is_production#row_i#' = GET_PRODUCT_ID.IS_PRODUCTION;
			
				xml_basket_gross_total = wrk_round(xml_basket_gross_total+evaluate("attributes.row_nettotal#row_i#"),4);
				xml_basket_tax_total = wrk_round(xml_basket_tax_total+evaluate("attributes.row_taxtotal#row_i#"),4);
				xml_basket_gross_total_indirimli = wrk_round(xml_basket_gross_total_indirimli+wrk_round(evaluate("attributes.list_price#row_i#")*evaluate("attributes.amount#row_i#"),4),4);
				xml_basket_discount_total_indirimli = wrk_round(xml_basket_discount_total_indirimli+wrk_round(evaluate("attributes.price_discount_indirimli#row_i#")*evaluate("attributes.amount#row_i#"),4),4);
		
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
			}//urun secildikten sonraki if
		}//for un altindaki if
	}//for
	
	attributes.sa_discount = 0;
	attributes.rows_ = attributes.ship_row_count;
	attributes.basket_discount_total = attributes.sa_discount;
	attributes.basket_discount_total = xml_basket_discount_total_indirimli + attributes.sa_discount;
	attributes.basket_gross_total = xml_basket_gross_total_indirimli;
	attributes.basket_net_total = xml_basket_gross_total+xml_basket_tax_total-attributes.sa_discount;
	attributes.basket_tax_total = xml_basket_tax_total;
	attributes.basket_otv_total = 0;
</cfscript>

<cfif listlen(problem_urunler)>
	<cfset attributes.detail = '#attributes.detail# <br/> #problem_urunler#-#dateformat(now(),"dd/mm/yyyy")#.'>
	<script type="text/javascript">
    	alert('Aşağıdaki barkodlara ait kayıt bulunamamıştır!\n<cfoutput>#problem_urunler#</cfoutput>');
    </script>
</cfif>
<cftry>
	<cfinclude template="../../stock/query/add_purchase_pda.cfm">
    <cfinclude template="../../stock/query/get_process_cat.cfm">
    <cf_workcube_process_cat 
        process_cat="#form.process_cat#"
        action_id = "#MAX_ID.IDENTITYCOL#"
        action_table="SHIP"
        action_column="SHIP_ID"
        is_action_file = 1
        action_page='#request.self#?fuseaction=pda.form_upd_purchase&ship_id=#MAX_ID.IDENTITYCOL#'
        action_file_name='#get_process_type.action_file_name#'
        action_db_type = '#DSN2#'><!--- 
        is_template_action_file = '#get_process_type.action_file_from_template#' --->
	<script type="text/javascript">
		alert("İrsaliye <cfoutput>#ship_number#</cfoutput> Belge Numarası ile Oluşturulmuştur!");
		document.location.href = '<cfoutput>#request.self#?fuseaction=pda.form_add_purchase&company_id=#attributes.company_id#</cfoutput>';
	</script>
	<cfcatch>
		<script type="text/javascript">
			alert("İrsaliye Kayıt İşlemi Sırasında Hata Oluştu. Lütfen İşlemlerinizi Kontrol Ediniz!");
			document.location.href = '<cfoutput>#request.self#?fuseaction=pda.form_add_purchase&company_id=#attributes.company_id#</cfoutput>';
		</script>
	</cfcatch>
</cftry>
