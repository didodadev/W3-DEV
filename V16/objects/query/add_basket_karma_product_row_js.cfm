<cfquery name="GET_KARMA_PRODUCT" datasource="#dsn1#">
	SELECT 
		KP.SPEC_MAIN_ID,
		<cfif is_sale_product eq 1>	KP.TAX	<cfelse>KP.TAX_PURCHASE AS TAX</cfif>,
		KP.KARMA_PRODUCT_ID,
		KP.STOCK_ID,
		KP.PRODUCT_ID,
		KP.PRODUCT_UNIT_ID,
		KP.PRODUCT_AMOUNT,
		KP.SALES_PRICE,
		KP.OTHER_LIST_PRICE,
		KP.ENTRY_ID,
		<cfif session.ep.period_year lt 2009>
			CASE WHEN KP.MONEY ='TL' THEN '<cfoutput>#session.ep.money#</cfoutput>' ELSE KP.MONEY END AS MONEY
		<cfelseif session.ep.period_year gte 2009>
			CASE WHEN KP.MONEY ='YTL' THEN '<cfoutput>#session.ep.money#</cfoutput>' ELSE KP.MONEY END AS MONEY
		<cfelse>
			KARMA_PRODUCTS.MONEY
		</cfif> 
	FROM 
		KARMA_PRODUCTS KP
	WHERE 
		KP.KARMA_PRODUCT_ID = #attributes.product_id#
	ORDER BY 
		ENTRY_ID
</cfquery>
<cfif not GET_KARMA_PRODUCT.recordcount>
	<script type="text/javascript">
		alert("Karma Koli İçeriğine Ürün Tanımlamalısınız!");
		window.close();
	</script>
</cfif>
<cfif isdefined('attributes.price_catid') and len(attributes.price_catid) and not listfind('-1,-2',attributes.price_catid)> <!--- standart alış-satıs fiyatları haricindeki tüm liste fiyatlarını burdan alıyor --->
	<cfquery name="GET_KARMA_PRICE" datasource="#dsn3#">
		SELECT 	
			KPP.SALES_PRICE,KPP.START_DATE,KPP.FINISH_DATE,
		<cfif session.ep.period_year lt 2009>
			CASE WHEN KPP.MONEY ='TL' THEN '<cfoutput>#session.ep.money#</cfoutput>' ELSE KPP.MONEY END AS MONEY,
		<cfelseif session.ep.period_year gte 2009>
			CASE WHEN KPP.MONEY ='YTL' THEN '<cfoutput>#session.ep.money#</cfoutput>' ELSE KPP.MONEY END AS MONEY,
		<cfelse>
			KARMA_PRODUCTS.MONEY,
		</cfif> 
			KPP.PRODUCT_ID,KPP.STOCK_ID,KPP.SPEC_MAIN_ID,KPP.PRICE_CATID,KPP.ENTRY_ID,
			PC.NUMBER_OF_INSTALLMENT,PC.AVG_DUE_DAY,
            KPP.SALES_PRICE AS OTHER_LIST_PRICE
		FROM 
			KARMA_PRODUCTS_PRICE KPP,
			PRICE_CAT PC
		WHERE 
			KPP.KARMA_PRODUCT_ID = #attributes.product_id#
			AND KPP.PRICE_CATID = #attributes.price_catid#
			AND KPP.PRICE_CATID = PC.PRICE_CATID
		<cfif isdefined("attributes.search_process_date") and len(attributes.search_process_date)>
			AND KPP.START_DATE <= #attributes.search_process_date#
			AND KPP.FINISH_DATE >= #attributes.search_process_date#
		</cfif>
	</cfquery>
<cfelse>
	<cfset GET_KARMA_PRICE.recordcount=0>
</cfif>
<cfset system_round_number_row =2>
<cfif isdefined('attributes.int_basket_id') and len(attributes.int_basket_id)>
	<cfquery name="get_round_number" datasource="#dsn3#">
		SELECT PRICE_ROUND_NUMBER FROM SETUP_BASKET WHERE BASKET_ID=#attributes.int_basket_id# AND B_TYPE=1
	</cfquery>
	<cfif len(get_round_number.PRICE_ROUND_NUMBER)>
		<cfset system_round_number_row =get_round_number.PRICE_ROUND_NUMBER>
	</cfif>
</cfif>
<cfset unique_id=CreateUUID()> <!--- karmakolinin icerigindeki tüm ürünlerin UNIQUE_RELATION_ID alanına aynı deger atılır, karmakoli icerigindeki urunlerin silinmesi, guncellenmesi veya miktarının degistirilmesi bu alana baglı olarak kontrol edilir--->
<script type="text/javascript">
	function add_karma_product(karma_product_id,stock_id,product_id,spect_id,spect_name,product_unit_id,amount,tax,prod_price,prod_money,prod_price_other,price_cat,installment_number,due_day,upd_row_no,satir,net_maliyet,extra_cost)
	{
		var get_stock_karma = wrk_safe_query("obj_get_stock_karma",'dsn3',0,stock_id);
		if(get_stock_karma.recordcount)
		{
			var get_prod_acc = wrk_safe_query("obj_get_prod_acc_2",'dsn3',0,product_id);
			var product_id = get_stock_karma.PRODUCT_ID.toString();
			var stock_id = get_stock_karma.STOCK_ID.toString();
			var spect_id = spect_id;
			var spect_name = spect_name;
			var stock_code = get_stock_karma.STOCK_CODE.toString();
			var stock_code_2 = get_stock_karma.STOCK_CODE_2.toString();
			var barcod = get_stock_karma.BARCOD.toString();
			var manufact_code = get_stock_karma.MANUFACT_CODE.toString();
			var product_name = get_stock_karma.PRODUCT_NAME.toString()+get_stock_karma.PROPERTY.toString();
			var unit_id_ = get_stock_karma.PRODUCT_UNIT_ID.toString();
			var unit_ = get_stock_karma.ADD_UNIT.toString();
			var price = parseFloat(prod_price);	
			var price_other = parseFloat(prod_price_other);
			var tax = parseFloat(tax);
			if(get_stock_karma.OTV != '') var otv = get_stock_karma.OTV; else var otv = 0;
			var is_inventory = get_stock_karma.IS_INVENTORY.toString();
			var is_production = get_stock_karma.IS_PRODUCTION.toString();
			var money = prod_money;
			var amount_ = parseFloat(amount);
			if(get_prod_acc.recordcount)
				var product_account_code = get_prod_acc.ACCOUNT_CODE.toString();
			else
				var product_account_code = '';
			var row_catalog_id='';
			var row_unique_relation_id = <cfoutput>'#unique_id#'</cfoutput>;
			tree_mark='';
			if(satir == -1)
			{
				try
				{
					<cfif isdefined("attributes.config_tree")>tree_mark='_';<cfelse>tree_mark='';</cfif>
					<cfif not isdefined("attributes.from_product_config")>parent.window.</cfif>window['add_basket_row' +tree_mark](product_id, stock_id, stock_code, barcod, manufact_code, product_name, unit_id_, unit_, spect_id,spect_name, price, price_other, tax, parseFloat(due_day), 0,0,0,0,0,0,0,0,0,0,'', '', '', '', money, '0', amount_, product_account_code,is_inventory,is_production,net_maliyet,'',extra_cost,'','','',0,0,'',otv,'','','','0','',row_unique_relation_id,row_catalog_id,1,0,'','','','',installment_number,price_cat,karma_product_id,'','','','','','','','','','','',0,'','',stock_code_2,'','','','','','','','','','','','','','','','','','','','','','','','','');
				}
				catch(e)
				{
				<cfif isdefined("attributes.config_tree")>tree_mark='_';<cfelse>tree_mark='';</cfif>
				<cfif not isdefined("attributes.from_product_config")>opener.</cfif>window['add_basket_row' +tree_mark](product_id, stock_id, stock_code, barcod, manufact_code, product_name, unit_id_, unit_, spect_id,spect_name, price, price_other, tax, parseFloat(due_day), 0,0,0,0,0,0,0,0,0,0,'', '', '', '', money, '0', amount_, product_account_code,is_inventory,is_production,net_maliyet,'',extra_cost,'','','',0,0,'',otv,'','','','0','',row_unique_relation_id,row_catalog_id,1,0,'','','','',installment_number,price_cat,karma_product_id,'','','','','','','','','','','',0,'','',stock_code_2,'','','','','','','','','','','','','','','','','','','','','','','','','');
				}
			}
			else
				try
				{
					parent.window.upd_row(product_id, stock_id, stock_code, barcod, manufact_code, product_name, unit_id_, unit_, spect_id,spect_name, price, price_other, tax, parseFloat(due_day), 0,0,0,0,0,0,0,0,0,0,'', '', '', '', money, '0', amount_, product_account_code,is_inventory,is_production,net_maliyet,'',extra_cost,'','','',0,0,'',otv,'','','','0','',row_unique_relation_id,row_catalog_id,1,0,'','','','',installment_number,price_cat,karma_product_id,'','','','','','','','','','','',0,'','',stock_code_2,'','','','','','','','','','','','','','','','','','','','','','','','','');
				}
				catch(e)
				{
					opener.upd_row(product_id, stock_id, stock_code, barcod, manufact_code, product_name, unit_id_, unit_, spect_id,spect_name, price, price_other, tax, parseFloat(due_day), 0,0,0,0,0,0,0,0,0,0,'', '', '', '', money, '0', amount_, product_account_code,is_inventory,is_production,net_maliyet,'',extra_cost,'','','',0,0,'',otv,'','','','0','',row_unique_relation_id,row_catalog_id,1,0,'','','','',installment_number,price_cat,karma_product_id,'','','','','','','','','','','',0,'','',stock_code_2,'','','','','','','','','','','','','','','','','','','','','','','','','');
				}
		}
		
	}
	
</script>
	<cfif isdefined("attributes.amount_multiplier") and len(attributes.amount_multiplier) and isnumeric(replace(attributes.amount_multiplier,",","."))>
		<cfset amount_multi = attributes.amount_multiplier>
	<cfelse>
		<cfset amount_multi = 1>
	</cfif>
	<cfoutput query="GET_KARMA_PRODUCT">
		<cfset product_money_value = 0>
		<cfset product_money= '#session.ep.money#'>
		<cfset product_price_other = 0>

		<cfif session.ep.our_company_info.is_cost_location eq 1 and listfind("53,52,62,70,71,72,78,79,88,111,112,113,116,119,141,531,532",attributes.sepet_process_type) and len(get_product_all_multip.IS_COST) and get_product_all_multip.IS_COST>
			<cfquery name="GET_PRODUCT_COST" datasource="#dsn3#" maxrows="1">
				SELECT
					PC.PRODUCT_COST_ID,
					PC.PURCHASE_NET_LOCATION_ALL * (SM.RATE2 / SM.RATE1) PURCHASE_NET,
					PC.PURCHASE_EXTRA_COST_LOCATION * (SM.RATE2 / SM.RATE1) PURCHASE_EXTRA_COST
				FROM
					PRODUCT_COST PC,
					#dsn2_alias#.SETUP_MONEY SM
				WHERE 
					SM.MONEY = PC.PURCHASE_NET_MONEY AND
					PC.PRODUCT_COST IS NOT NULL AND
					<cfif isdefined("attributes.search_process_date") and len(attributes.search_process_date)>
						PC.START_DATE < #DATEADD('d',1,attributes.search_process_date)# AND 
					<cfelse>
						PC.START_DATE < #now()# AND
					</cfif>
					PC.PRODUCT_ID = #GET_KARMA_PRODUCT.PRODUCT_ID#
					<cfif isdefined("attributes.department_out") and len(attributes.department_out)>
						AND PC.DEPARTMENT_ID = #listfirst(attributes.department_out)#	
					</cfif>
					<cfif isdefined("attributes.location_out") and len(attributes.location_out)>
						AND PC.LOCATION_ID = #attributes.location_out#	
					</cfif>
				ORDER BY 
					PC.START_DATE DESC
					--,PC.RECORD_DATE DESC
					,PC.PRODUCT_COST_ID DESC
			</cfquery>
		<cfelseif session.ep.our_company_info.is_cost_location eq 2 and listfind("53,52,62,70,71,72,78,79,88,111,112,113,116,119,141,531,532",attributes.sepet_process_type) and len(get_product_all_multip.IS_COST) and get_product_all_multip.IS_COST>
			<cfquery name="GET_PRODUCT_COST" datasource="#dsn3#" maxrows="1">
				SELECT
					PC.PRODUCT_COST_ID,
					PC.PURCHASE_NET_DEPARTMENT_ALL * (SM.RATE2 / SM.RATE1) PURCHASE_NET,
					PC.PURCHASE_EXTRA_COST_DEPARTMENT * (SM.RATE2 / SM.RATE1) PURCHASE_EXTRA_COST
				FROM
					PRODUCT_COST PC,
					#dsn2_alias#.SETUP_MONEY SM
				WHERE 
					SM.MONEY = PC.PURCHASE_NET_MONEY AND
					PC.PRODUCT_COST IS NOT NULL AND
					<cfif isdefined("attributes.search_process_date") and len(attributes.search_process_date)>
						PC.START_DATE < #DATEADD('d',1,attributes.search_process_date)# AND 
					<cfelse>
						PC.START_DATE < #now()# AND
					</cfif>
					PC.PRODUCT_ID = #GET_KARMA_PRODUCT.PRODUCT_ID#
					<cfif isdefined("attributes.department_out") and len(attributes.department_out)>
						AND PC.DEPARTMENT_ID = #listfirst(attributes.department_out)#	
					</cfif>
				ORDER BY 
					PC.START_DATE DESC
					--,PC.RECORD_DATE DESC
					,PC.PRODUCT_COST_ID DESC
			</cfquery>
		<cfelseif (is_sale_product eq 1 or (isdefined("attributes.sepet_process_type") and listfind("110,111,112,113,114,115,119",attributes.sepet_process_type)) or (isdefined('attributes.int_basket_id') and listfind("50",attributes.int_basket_id))) and len(get_product_all_multip.IS_COST) and get_product_all_multip.IS_COST>
			<cfquery name="GET_PRODUCT_COST" datasource="#dsn3#" maxrows="1">
				SELECT
					PC.PRODUCT_COST_ID,
					PC.PURCHASE_NET_ALL * (SM.RATE2 / SM.RATE1) PURCHASE_NET,
					PC.PURCHASE_EXTRA_COST * (SM.RATE2 / SM.RATE1) PURCHASE_EXTRA_COST
				FROM
					PRODUCT_COST PC,
					#dsn2_alias#.SETUP_MONEY SM
				WHERE 
					SM.MONEY = PC.PURCHASE_NET_MONEY AND
					PC.PRODUCT_COST IS NOT NULL AND
				<cfif isdefined("attributes.search_process_date") and len(attributes.search_process_date)>
					PC.START_DATE < #DATEADD('d',1,attributes.search_process_date)# AND 
				<cfelse>
					PC.START_DATE < #now()# AND
				</cfif>
					PC.PRODUCT_ID = #GET_KARMA_PRODUCT.PRODUCT_ID#
				ORDER BY 
					PC.START_DATE DESC
					--,PC.RECORD_DATE DESC
					,PC.PRODUCT_COST_ID DESC
			</cfquery>
		<cfelseif isdefined("attributes.sepet_process_type") and listfind('81',attributes.sepet_process_type) and len(get_product_all_multip.IS_COST) and get_product_all_multip.IS_COST>
			<cfquery name="GET_PRODUCT_COST" datasource="#dsn3#" maxrows="1">
				SELECT
					PC.PRODUCT_COST_ID,
					<cfif session.ep.our_company_info.is_cost_location eq 2>
						PC.PURCHASE_NET_DEPARTMENT_ALL * (SM.RATE2 / SM.RATE1) PURCHASE_NET,
						PC.PURCHASE_EXTRA_COST_DEPARTMENT * (SM.RATE2 / SM.RATE1) PURCHASE_EXTRA_COST
					<cfelseif session.ep.our_company_info.is_cost_location eq 1>
						PC.PURCHASE_NET_LOCATION_ALL * (SM.RATE2 / SM.RATE1) PURCHASE_NET,
						PC.PURCHASE_EXTRA_COST_LOCATION * (SM.RATE2 / SM.RATE1) PURCHASE_EXTRA_COST
					<cfelse>
						PC.PURCHASE_NET_ALL * (SM.RATE2 / SM.RATE1) PURCHASE_NET,
						PC.PURCHASE_EXTRA_COST * (SM.RATE2 / SM.RATE1) PURCHASE_EXTRA_COST
					</cfif>
				FROM
					PRODUCT_COST PC,
					#dsn2_alias#.SETUP_MONEY SM
				WHERE 
					SM.MONEY = PC.PURCHASE_NET_MONEY AND
					PC.PRODUCT_COST IS NOT NULL AND
					<cfif isdefined("attributes.search_process_date") and len(attributes.search_process_date)>
						PC.START_DATE < #DATEADD('d',1,attributes.search_process_date)# AND 
					<cfelse>
						PC.START_DATE < #now()# AND
					</cfif>
					PC.PRODUCT_ID = #GET_KARMA_PRODUCT.PRODUCT_ID#
					<cfif session.ep.our_company_info.is_cost_location neq 0>
						<cfif isdefined("attributes.department_out") and len(attributes.department_out)>
							AND PC.DEPARTMENT_ID = #listfirst(attributes.department_out)#	
						</cfif>
						<cfif session.ep.our_company_info.is_cost_location eq 1>
							<cfif isdefined("attributes.location_out") and len(attributes.location_out)>
								AND PC.LOCATION_ID = #attributes.location_out#	
							</cfif>
						</cfif>
					</cfif>
				ORDER BY 
					PC.START_DATE DESC
					--,PC.RECORD_DATE DESC
					,PC.PRODUCT_COST_ID DESC
			</cfquery>
		</cfif>

		<cfif isdefined('attributes.price_catid') and attributes.price_catid eq '-2'> <!--- standart satıs secilmis ise KARMA_PRODUCT tablosundaki SALES_PRICE kullanılır--->
			<cfset product_money_value = OTHER_LIST_PRICE><!--- SALES_PRICE doviz fiyatini price a dusuruyor, basket yanlis hesapliyor o yuzden fbs 20130509 --->
			<cfset product_money= MONEY>
		<cfelseif isdefined('attributes.price_catid') and len(attributes.price_catid)> <!--- farklı bir fiyat listesi secilmisse --->
			<cfif GET_KARMA_PRICE.recordcount neq 0>
				<cfquery name='get_pro_price' dbtype='query'>
					SELECT * FROM GET_KARMA_PRICE WHERE PRODUCT_ID=#GET_KARMA_PRODUCT.PRODUCT_ID# AND STOCK_ID=#GET_KARMA_PRODUCT.STOCK_ID# AND <cfif len(GET_KARMA_PRODUCT.SPEC_MAIN_ID)>SPEC_MAIN_ID=#GET_KARMA_PRODUCT.SPEC_MAIN_ID#<cfelse>SPEC_MAIN_ID IS NULL </cfif> AND ENTRY_ID=#GET_KARMA_PRODUCT.ENTRY_ID#
				</cfquery>
				<cfif len(get_pro_price.OTHER_LIST_PRICE)>
					<cfset product_money_value = get_pro_price.OTHER_LIST_PRICE>
					<cfset product_money= get_pro_price.MONEY>
				</cfif>
			</cfif>
		<cfelse> <!--- standart alıs secilmisse --->
			<cfquery name="get_pro_price" datasource="#dsn3#" maxrows="1">
				SELECT
					PRICE,MONEY
				FROM
					PRICE_STANDART
				WHERE
					PRODUCT_ID = #PRODUCT_ID# AND
					UNIT_ID = #PRODUCT_UNIT_ID# AND
					PURCHASESALES = 0 AND
				<cfif isdefined("attributes.search_process_date") and len(attributes.search_process_date)>
					START_DATE < #DATEADD('d',1,attributes.search_process_date)#
				<cfelse>
					PRICESTANDART_STATUS = 1
				</cfif>
				ORDER BY
					START_DATE DESC,
					RECORD_DATE DESC
			</cfquery>
			<cfif not get_pro_price.recordcount>
				<cfquery name="get_pro_price" datasource="#dsn3#" maxrows="1">
					SELECT
						PS.PRICE,
						PS.MONEY
					FROM
						PRICE_STANDART AS PS,
						PRODUCT_UNIT AS PU
					WHERE
						PS.UNIT_ID = PU.PRODUCT_UNIT_ID AND
						PS.PRODUCT_ID = #PRODUCT_ID# AND
						PU.IS_MAIN = 1 AND
						PS.PURCHASESALES = 0 AND
					<cfif isdefined("attributes.search_process_date") and len(attributes.search_process_date)>
						PS.START_DATE < #DATEADD('d',1,attributes.search_process_date)#
					<cfelse>
						PS.PRICESTANDART_STATUS = 1
					</cfif>
					ORDER BY
						PS.START_DATE DESC,
						PS.RECORD_DATE DESC
				</cfquery>
			</cfif>
			<cfif get_pro_price.recordcount>
				<cfset product_money_value = get_pro_price.PRICE>
				<cfset product_money = get_pro_price.MONEY>
			</cfif>
		</cfif>
		<cfscript>
			if(isnumeric(product_money_value) and product_money_value neq 0)
			{
				product_price_other = product_money_value;
				if(len(product_money) and product_money is not '#session.ep.money#')
				{
					if(session.ep.period_year gte 2009 and attributes.str_money_currency is 'YTL')
						attributes.YTL = 1;
					else if(session.ep.period_year lt 2009 and attributes.str_money_currency is 'TL')
						attributes.TL = 1;
					
					product_money_value = wrk_round((product_money_value * evaluate("attributes.#product_money#")),system_round_number_row);
				}
			}
			if(attributes.satir == -1) //guncellemeden acılan satır update edilecek
				upd_row=update_product_row_id;
			else
				upd_row=0;
				
			if(isdefined('GET_KARMA_PRICE') and GET_KARMA_PRICE.recordcount neq 0)
			{
				temp_installment_number_ = GET_KARMA_PRICE.NUMBER_OF_INSTALLMENT;
				temp_due_day_ = GET_KARMA_PRICE.AVG_DUE_DAY;
			}
			else
			{
				temp_installment_number_ = 0;
				temp_due_day_ = 0;
			}

			if(len(GET_KARMA_PRODUCT.SPEC_MAIN_ID))
			{
				spec_fonk=specer(
									dsn_type:dsn3,
									main_spec_id=GET_KARMA_PRODUCT.SPEC_MAIN_ID,
									add_to_main_spec=1,
                                    get_message=1
								);
                if(isstruct(spec_fonk)){
                    writeoutput(
                        '<script>alert("#spec_fonk.mistakeMessage#"); history.back(-1);</script>'
                    );
                    abort;
                }else{
                    temp_spect_name=listgetat(spec_fonk,3,',');
				    temp_spect_id=listgetat(spec_fonk,2,',');
                }
			}
			else
			{
				 temp_spect_id='';
				 temp_spect_name='';
			}
			if(session.ep.our_company_info.is_cost_location eq 1 and isdefined("GET_PRODUCT_COST") and len(GET_PRODUCT_COST.PURCHASE_NET) and listfind("53,52,62,70,71,72,78,79,88,111,112,113,116,119,141,531,532",attributes.sepet_process_type) and len(get_product_all_multip.IS_COST) and get_product_all_multip.IS_COST)
			{
				net_maliyet = wrk_round(GET_PRODUCT_COST.PURCHASE_NET,4);
				extra_cost = wrk_round(GET_PRODUCT_COST.PURCHASE_EXTRA_COST,4);
			}
			else if(session.ep.our_company_info.is_cost_location eq 2 and isdefined("GET_PRODUCT_COST") and len(GET_PRODUCT_COST.PURCHASE_NET) and listfind("53,52,62,70,71,72,78,79,88,111,112,113,116,119,141,531,532",attributes.sepet_process_type) and len(get_product_all_multip.IS_COST) and get_product_all_multip.IS_COST)
			{
				net_maliyet = wrk_round(GET_PRODUCT_COST.PURCHASE_NET,4);
				extra_cost = wrk_round(GET_PRODUCT_COST.PURCHASE_EXTRA_COST,4);
			}
			else if(isdefined("GET_PRODUCT_COST") and len(GET_PRODUCT_COST.PURCHASE_NET) and (is_sale_product eq 1 or (isdefined("attributes.sepet_process_type") and listfind("110,111,112,113,114,115,119",attributes.sepet_process_type)) or (isdefined('attributes.int_basket_id') and listfind("50",attributes.int_basket_id))) and len(get_product_all_multip.IS_COST) and get_product_all_multip.IS_COST and len(GET_PRODUCT_COST.PRODUCT_COST_ID))
			{
				net_maliyet = wrk_round(GET_PRODUCT_COST.PURCHASE_NET,4);
				extra_cost = wrk_round(GET_PRODUCT_COST.PURCHASE_EXTRA_COST,4);
			}
			else if(isdefined("GET_PRODUCT_COST") and len(GET_PRODUCT_COST.PURCHASE_NET) and isdefined("attributes.sepet_process_type") and listfind('81',attributes.sepet_process_type) and len(get_product_all_multip.IS_COST) and len(GET_PRODUCT_COST.PURCHASE_NET) and get_product_all_multip.IS_COST and len(GET_PRODUCT_COST.PRODUCT_COST_ID))
			{
				net_maliyet = wrk_round(GET_PRODUCT_COST.PURCHASE_NET,4);
				extra_cost = wrk_round(GET_PRODUCT_COST.PURCHASE_EXTRA_COST,4);
			}
			else 
			{
				net_maliyet = '';
				extra_cost = 0;
			}
		</cfscript>
		<cfif currentrow neq 1>
			<cfset attributes.satir = -1>
		</cfif>
        <script>
		    add_karma_product('#karma_product_id#','#stock_id#','#product_id#','#temp_spect_id#','#temp_spect_name#','#product_unit_id#','#product_amount*amount_multi#','#tax#','#product_money_value#','#product_money#','#product_price_other#',<cfif isdefined('attributes.price_catid') and len(attributes.price_catid)>'#attributes.price_catid#'<cfelse>''</cfif>,'#temp_installment_number_#','#temp_due_day_#','#upd_row#','#attributes.satir#','#net_maliyet#','#extra_cost#');
        </script>
		
    </cfoutput>

<script>
	<cfif (not isdefined("multi") or multi is 0) and not isdefined("attributes.from_product_config")>
		if(<cfoutput>#attributes.satir#</cfoutput> == -1)
		{
			if (typeof(Storage) !== "undefined" && localStorage.getItem("list_product") != null) {
				var newUrl = "<cfoutput>#fusebox.server_machine_list#/#request.self#</cfoutput>?fuseaction=objects.popup_products&";
				var list_product_object = JSON.parse(localStorage.getItem("list_product"));
				
				var list_product = [];
				for(var i in list_product_object) list_product.push([i, list_product_object[i]]);
				
				list_product.forEach((el, index) => {
					newUrl += (( el[0] != 'fuseaction' ) ? (el[0] + "=" + el[1] + (( index != list_product.length ) ? "&" : "")) : '');
				});

				document.location.href = newUrl;
			}
		}else window.close();
	</cfif>
</script>