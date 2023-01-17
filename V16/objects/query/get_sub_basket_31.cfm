<!---Sistem sayaç ve ödeme planı sayfalarından fatura oluşurma sayfaları --->
<cfif len(attributes.invoice_counter_number)>
	<cfloop from="1" to="#attributes.invoice_counter_number#" index="i_counter">
	  <cfoutput>
		<input type="hidden" name="invoice_stock_id_<cfoutput>#i_counter#</cfoutput>" id="invoice_stock_id_<cfoutput>#i_counter#</cfoutput>" value="<cfoutput>#evaluate('attributes.invoice_stock_id_#i_counter#')#</cfoutput>">
		<input type="hidden" name="counter_row_<cfoutput>#i_counter#</cfoutput>" id="counter_row_<cfoutput>#i_counter#</cfoutput>" value="<cfoutput>#evaluate('attributes.counter_row_#i_counter#')#</cfoutput>">
	  </cfoutput>
	</cfloop>

	<cfloop from="1" to="#attributes.invoice_counter_number#" index="i_counter">
	  <cfif len(evaluate('attributes.invoice_stock_id_#i_counter#'))>
		<cfloop from="1" to="#evaluate('attributes.counter_row_#i_counter#')#" index="i_counter2">
		<cfoutput>
		  <input type="hidden" name="invoice_difference_#i_counter#_#i_counter2#" id="invoice_difference_#i_counter#_#i_counter2#" value="#evaluate('attributes.invoice_difference_#i_counter#_#i_counter2#')#">
		  <input type="hidden" name="h_invoice_difference_#i_counter#_#i_counter2#" id="h_invoice_difference_#i_counter#_#i_counter2#" value="#evaluate('attributes.h_invoice_difference_#i_counter#_#i_counter2#')#">
		 <cfif isdefined("attributes.is_invoice_#i_counter#_#i_counter2#")> 
		 	<input type="hidden" name="result_row_id_#i_counter#_#i_counter2#" id="result_row_id_#i_counter#_#i_counter2#" value="#evaluate('attributes.result_row_id_#i_counter#_#i_counter2#')#">		  
		  	<input type="hidden" name="is_invoice_#i_counter#_#i_counter2#" id="is_invoice_#i_counter#_#i_counter2#" value="1">
		  </cfif>
		</cfoutput>
		</cfloop>
	  </cfif>
	</cfloop>	
	
	<cfscript>
		
		sepet = StructNew();
		sepet.satir = ArrayNew(1);
		sepet.kdv_array = ArrayNew(2);
		sepet.total = 0;
		sepet.toplam_indirim = 0;
		sepet.total_tax = 0;
		sepet.net_total = 0;
		sepet.stopaj_rate_id = 0;
		sepet.genel_indirim = 0;
		sepet.other_money = session.ep.money;
		
		product_id_list = '';
		for (i = 1; i lte attributes.invoice_counter_number;i=i+1)
		{
			if(len(evaluate('attributes.invoice_stock_id_#i#')))
				product_id_list = ListAppend(product_id_list,evaluate('attributes.invoice_product_id_#i#'),',');
		}
	
		product_id_list = listsort(ListDeleteDuplicates(product_id_list),'numeric','asc',',');
		
		if(len(product_id_list))
		{
			SQLString = "SELECT ACCOUNT_CODE,ACCOUNT_CODE_PUR,PRODUCT_ID FROM PRODUCT_PERIOD WHERE PRODUCT_ID IN (#product_id_list#) AND PERIOD_ID = #session.ep.period_id# ORDER BY PRODUCT_ID";
			get_product_accounts = cfquery(SQLString : SQLString, Datasource : DSN3);
	
			product_id_account_list=listsort(valuelist(get_product_accounts.product_id),'numeric','asc',',');
		}
		
		i=0;
		for (counter_k = 1; counter_k lte attributes.invoice_counter_number;counter_k=counter_k+1)
		{
			if(len(evaluate('attributes.invoice_stock_id_#counter_k#')))
			{
				i=i+1;
				sepet.satir[i] = StructNew();
				
				sepet.satir[i].wrk_row_id ="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
				sepet.satir[i].wrk_row_relation_id = '';
				
				sepet.satir[i].is_inventory = evaluate('attributes.invoice_is_inventory_#counter_k#');
				sepet.satir[i].product_name = evaluate('attributes.invoice_product_name_#counter_k#');
				sepet.satir[i].amount = evaluate('attributes.invoice_amount_#counter_k#');
				sepet.satir[i].unit = evaluate('attributes.invoice_unit_#counter_k#');
				sepet.satir[i].unit_id = evaluate('attributes.invoice_unit_id_#counter_k#');
				sepet.satir[i].price = evaluate('attributes.invoice_price_#counter_k#');
				sepet.satir[i].stock_id = evaluate('attributes.invoice_stock_id_#counter_k#');
				sepet.satir[i].product_id = evaluate('attributes.invoice_product_id_#counter_k#');
				sepet.satir[i].barcode = evaluate('attributes.invoice_barcod_#counter_k#');
				sepet.satir[i].special_code = '';
				sepet.satir[i].stock_code = evaluate('attributes.invoice_stock_code_#counter_k#');
				sepet.satir[i].manufact_code = evaluate('attributes.invoice_manufact_code_#counter_k#');
				
				sepet.satir[i].product_account_code = get_product_accounts.ACCOUNT_CODE[listfind(product_id_account_list,evaluate('attributes.invoice_product_id_#counter_k#'),',')];
			
				sepet.satir[i].indirim1 = 0;
				sepet.satir[i].indirim2 = 0;
				sepet.satir[i].indirim3 = 0;
				sepet.satir[i].indirim4 = 0;
				sepet.satir[i].indirim5 = 0;
				sepet.satir[i].indirim6 = 0;
				sepet.satir[i].indirim7 = 0;
				sepet.satir[i].indirim8 = 0;
				sepet.satir[i].indirim9 = 0;
				sepet.satir[i].indirim10 = 0;
				
				sepet.satir[i].indirim_carpan = (100-sepet.satir[i].indirim1) * (100-sepet.satir[i].indirim2) * (100-sepet.satir[i].indirim3) * (100-sepet.satir[i].indirim4) * (100-sepet.satir[i].indirim5) * (100-sepet.satir[i].indirim6) * (100-sepet.satir[i].indirim7) * (100-sepet.satir[i].indirim8) * (100-sepet.satir[i].indirim9) * (100-sepet.satir[i].indirim10);
				sepet.satir[i].net_maliyet = 0;	
				sepet.satir[i].marj = 0;
			
				if(len(evaluate('attributes.invoice_tax_#counter_k#'))) sepet.satir[i].tax_percent = evaluate('attributes.invoice_tax_#counter_k#');
				else sepet.satir[i].tax_percent = 0;
				sepet.satir[i].paymethod_id = '';
				sepet.satir[i].duedate = "";
				
				if(evaluate('attributes.invoice_other_money_#counter_k#') neq session.ep.money)
				{
					SQLString1 = "SELECT (RATE2/RATE1) RATE FROM SETUP_MONEY WHERE MONEY = '#evaluate('attributes.invoice_other_money_#counter_k#')#'";
					get_money = cfquery(SQLString : SQLString1, Datasource : DSN2);
					PRICE = sepet.satir[i].price * get_money.rate;
					PRICE_OTHER = sepet.satir[i].price;
					sepet.satir[i].price_other = PRICE_OTHER;
					sepet.satir[i].price = PRICE;
				}
				else
					PRICE_OTHER = sepet.satir[i].price;
				
				sepet.satir[i].other_money = evaluate('attributes.invoice_other_money_#counter_k#');
				sepet.satir[i].price_other = PRICE_OTHER;
				sepet.satir[i].other_money_value = PRICE_OTHER * sepet.satir[i].amount;
				
				sepet.satir[i].other_money_grosstotal = (sepet.satir[i].amount * sepet.satir[i].price_other * sepet.satir[i].indirim_carpan)/100000000000000000000 ; 
				sepet.satir[i].other_money_grosstotal = sepet.satir[i].other_money_grosstotal * (sepet.satir[i].tax_percent/100);
				
				sepet.satir[i].row_total = sepet.satir[i].amount * sepet.satir[i].price;
				sepet.satir[i].row_nettotal = (sepet.satir[i].row_total/100000000000000000000) * sepet.satir[i].indirim_carpan;
				sepet.satir[i].row_taxtotal = sepet.satir[i].row_nettotal * (sepet.satir[i].tax_percent/100);
				sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal;
				
				sepet.satir[i].deliver_date = '';
				sepet.satir[i].deliver_dept = '';
			
				sepet.satir[i].spect_id = '';
				sepet.satir[i].spect_name = '';
				sepet.satir[i].lot_no = '';
			
				sepet.total = sepet.total + wrk_round(sepet.satir[i].row_total,basket_total_round_number); 
				sepet.toplam_indirim = sepet.toplam_indirim + (wrk_round(sepet.satir[i].row_total,price_round_number) - wrk_round(sepet.satir[i].row_nettotal,price_round_number));
				sepet.total_tax = sepet.total_tax + sepet.satir[i].row_taxtotal;
				sepet.net_total = sepet.net_total + sepet.satir[i].row_lasttotal;
			
				// kdv array
				kdv_flag = 0;
				for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
					{
					if (sepet.kdv_array[k][1] eq sepet.satir[i].tax_percent)
						{
						kdv_flag = 1;
						sepet.kdv_array[k][2] = sepet.kdv_array[k][2] + 0;
						sepet.kdv_array[k][3] = sepet.kdv_array[k][3] + wrk_round(sepet.satir[i].row_nettotal,basket_total_round_number);			
						}
					}
				if (not kdv_flag)
					{
					sepet.kdv_array[arraylen(sepet.kdv_array)+1][1] = sepet.satir[i].tax_percent;
					sepet.kdv_array[arraylen(sepet.kdv_array)][2] = 0;
					sepet.kdv_array[arraylen(sepet.kdv_array)][3] = wrk_round(sepet.satir[i].row_nettotal,basket_total_round_number);
					}
				sepet.satir[i].assortment_array = ArrayNew(1);
			}
		}
	</cfscript>
<cfelseif len(attributes.list_payment_row_id)>
	<cfquery name="GET_PAYMENT_PLAN_ROW" datasource="#dsn3#">
		SELECT 
			STOCKS.STOCK_ID,
			STOCKS.PRODUCT_ID,
			STOCKS.STOCK_CODE,
			SPPR.DETAIL PRODUCT_NAME,
			STOCKS.PROPERTY,
			STOCKS.BARCOD AS BARCOD,
			PRODUCT.TAX AS TAX,
			PRODUCT.OTV AS OTV,
			PRODUCT.IS_ZERO_STOCK,
			PRODUCT.PRODUCT_CATID,
			PRODUCT.PRODUCT_CODE,
			PRODUCT.IS_SERIAL_NO,
			PRODUCT.TAX_PURCHASE,
			PRODUCT.IS_INVENTORY,
			STOCKS.MANUFACT_CODE,		
			SPPR.QUANTITY AS AMOUNT, 
			(SPPR.AMOUNT * (SM.RATE2/SM.RATE1)) PRICE, 
			SPPR.AMOUNT PRICE_OTHER,
			SPPR.ROW_TOTAL TOTAL, 
			SPPR.MONEY_TYPE OTHER_MONEY,
			SPPR.DISCOUNT,
			SPPR.UNIT,
			SPPR.UNIT_ID,
			SPPR.SUBSCRIPTION_PAYMENT_ROW_ID,
			SPPR.BSMV_RATE,
			SPPR.BSMV_AMOUNT,
			SPPR.OIV_RATE,
			SPPR.OIV_AMOUNT,
			SPPR.TEVKIFAT_RATE,
			SPPR.TEVKIFAT_AMOUNT,
			STOCKS.STOCK_CODE_2			
		FROM
			PRODUCT,
			STOCKS,
			#dsn2_alias#.SETUP_MONEY SM,
			SUBSCRIPTION_PAYMENT_PLAN_ROW SPPR
		WHERE	
			PRODUCT.PRODUCT_STATUS = 1 AND
			STOCKS.STOCK_STATUS = 1 AND
			PRODUCT.IS_SALES = 1 AND
			PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
			SPPR.STOCK_ID = STOCKS.STOCK_ID AND
			SPPR.SUBSCRIPTION_PAYMENT_ROW_ID IN (#attributes.list_payment_row_id#) AND
			SM.MONEY = SPPR.MONEY_TYPE AND
			SM.PERIOD_ID = #session.ep.period_id#
		ORDER BY
			PRODUCT.PRODUCT_NAME
	</cfquery>
	<cfset product_id_list = listsort(ListDeleteDuplicates(valuelist(GET_PAYMENT_PLAN_ROW.PRODUCT_ID)),'numeric','asc',',')>
	<cfif len(product_id_list)>
		<cfquery name="get_product_accounts" datasource="#dsn3#">
			SELECT
				PER.ACCOUNT_CODE,
				PER.ACCOUNT_CODE_PUR,
				PER.PRODUCT_ID
			FROM
				PRODUCT_PERIOD PER
			WHERE
				PER.PRODUCT_ID IN (#product_id_list#) AND
				PER.PERIOD_ID = #session.ep.period_id#
			ORDER BY
				PER.PRODUCT_ID
		</cfquery>
		<cfset product_id_account_list=listsort(valuelist(get_product_accounts.PRODUCT_ID),'numeric','asc',',')>
	</cfif>	
		<cfscript>
		sepet = StructNew();
		sepet.satir = ArrayNew(1);
		sepet.kdv_array = ArrayNew(2);
		sepet.otv_array = ArrayNew(2);
		sepet.total = 0;
		sepet.toplam_indirim = 0;
		sepet.total_tax = 0;
		sepet.total_otv = 0;
		sepet.net_total = 0;
		sepet.genel_indirim = 0;
		sepet.other_money = session.ep.money;
	</cfscript>
	<cfoutput query="get_payment_plan_row">
		<cfscript>
		i = currentrow;
		sepet.satir[i] = StructNew();
		sepet.satir[i].product_id = PRODUCT_ID;
		sepet.satir[i].is_inventory = IS_INVENTORY;
		sepet.satir[i].product_name = PRODUCT_NAME;
		sepet.satir[i].amount = AMOUNT;
		sepet.satir[i].unit = UNIT;
		sepet.satir[i].unit_id = UNIT_ID;
		sepet.satir[i].price = PRICE;
		sepet.satir[i].stock_id = STOCK_ID;
		sepet.satir[i].barcode = BARCOD;
		sepet.satir[i].special_code = STOCK_CODE_2;
		sepet.satir[i].stock_code = STOCK_CODE;
		sepet.satir[i].manufact_code = MANUFACT_CODE;
		sepet.satir[i].discount = DISCOUNT;
		
		sepet.satir[i].wrk_row_id ="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
		sepet.satir[i].wrk_row_relation_id = '';
		sepet.satir[i].related_action_id=SUBSCRIPTION_PAYMENT_ROW_ID;
		sepet.satir[i].related_action_table='SUBSCRIPTION_PAYMENT_PLAN_ROW';
		
		sepet.satir[i].product_account_code = get_product_accounts.ACCOUNT_CODE[listfind(product_id_account_list,PRODUCT_ID,',')];
		
		sepet.satir[i].indirim1 = sepet.satir[i].discount;
		sepet.satir[i].indirim2 = 0;
		sepet.satir[i].indirim3 = 0;
		sepet.satir[i].indirim4 = 0;
		sepet.satir[i].indirim5 = 0;
		sepet.satir[i].indirim6 = 0;
		sepet.satir[i].indirim7 = 0;
		sepet.satir[i].indirim8 = 0;
		sepet.satir[i].indirim9 = 0;
		sepet.satir[i].indirim10 = 0;
		
		sepet.satir[i].indirim_carpan = (100-sepet.satir[i].indirim1) * (100-sepet.satir[i].indirim2) * (100-sepet.satir[i].indirim3) * (100-sepet.satir[i].indirim4) * (100-sepet.satir[i].indirim5) * (100-sepet.satir[i].indirim6) * (100-sepet.satir[i].indirim7) * (100-sepet.satir[i].indirim8) * (100-sepet.satir[i].indirim9) * (100-sepet.satir[i].indirim10);
		sepet.satir[i].net_maliyet = 0;	
		sepet.satir[i].marj = 0;
	
		if(len(TAX)) sepet.satir[i].tax_percent = TAX;
		else sepet.satir[i].tax_percent = 0;
		if(len(OTV)) sepet.satir[i].otv_oran = OTV;
		else sepet.satir[i].otv_oran = 0;
		sepet.satir[i].paymethod_id = '';
		sepet.satir[i].duedate = "";
		
		sepet.satir[i].row_total = sepet.satir[i].amount * sepet.satir[i].price;
		sepet.satir[i].row_nettotal = (sepet.satir[i].row_total/100000000000000000000) * sepet.satir[i].indirim_carpan;
		sepet.satir[i].row_taxtotal = sepet.satir[i].row_nettotal * (sepet.satir[i].tax_percent/100);
		sepet.satir[i].row_otvtotal = sepet.satir[i].row_nettotal * (sepet.satir[i].otv_oran/100);
		sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal + sepet.satir[i].row_otvtotal;
		
		if(len(PRICE_OTHER))
		{
			sepet.satir[i].other_money = OTHER_MONEY;
			sepet.satir[i].price_other = PRICE_OTHER;
			sepet.satir[i].other_money_value = PRICE_OTHER  * sepet.satir[i].amount;
		}
		else
		{
			sepet.satir[i].other_money = session.ep.money;
			sepet.satir[i].price_other = PRICE;
			sepet.satir[i].other_money_value = PRICE  * sepet.satir[i].amount;
		}
		
		sepet.satir[i].other_money_grosstotal = (sepet.satir[i].amount * sepet.satir[i].price_other * sepet.satir[i].indirim_carpan)/100000000000000000000 ; 
		sepet.satir[i].other_money_grosstotal = sepet.satir[i].other_money_grosstotal + (sepet.satir[i].other_money_grosstotal * (sepet.satir[i].tax_percent/100) + (sepet.satir[i].other_money_grosstotal * (sepet.satir[i].otv_oran/100)));
		
		sepet.satir[i].deliver_date = '';
		sepet.satir[i].deliver_dept = '';
	
		sepet.satir[i].spect_id = '';
		sepet.satir[i].spect_name = '';
		sepet.satir[i].lot_no = '';
	
		sepet.total = sepet.total + wrk_round(sepet.satir[i].row_total,basket_total_round_number);
		sepet.toplam_indirim = sepet.toplam_indirim + (wrk_round(sepet.satir[i].row_total,price_round_number) - wrk_round(sepet.satir[i].row_nettotal,price_round_number));
		sepet.total_tax = sepet.total_tax + sepet.satir[i].row_taxtotal;
		sepet.total_otv = sepet.total_otv + sepet.satir[i].row_otvtotal;
		sepet.net_total = sepet.net_total + sepet.satir[i].row_lasttotal;
	
		// kdv array
		kdv_flag = 0;
		for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
			{
			if (sepet.kdv_array[k][1] eq sepet.satir[i].tax_percent)
				{
				kdv_flag = 1;
				sepet.kdv_array[k][2] = sepet.kdv_array[k][2] + 0;
				if (ListFindNoCase(display_list, "otv_from_tax_price"))
					sepet.kdv_array[k][3] = sepet.kdv_array[k][3] + wrk_round((sepet.satir[i].row_nettotal+sepet.satir[i].row_otvtotal),basket_total_round_number);
				else
					sepet.kdv_array[k][3] = sepet.kdv_array[k][3] + wrk_round(sepet.satir[i].row_nettotal,basket_total_round_number);		
				}
			}
		if (not kdv_flag)
			{
			sepet.kdv_array[arraylen(sepet.kdv_array)+1][1] = sepet.satir[i].tax_percent;
			sepet.kdv_array[arraylen(sepet.kdv_array)][2] = 0;
			if (ListFindNoCase(display_list, "otv_from_tax_price"))
				sepet.kdv_array[arraylen(sepet.kdv_array)][3] = wrk_round((sepet.satir[i].row_nettotal+sepet.satir[i].row_otvtotal),basket_total_round_number);
			else
				sepet.kdv_array[arraylen(sepet.kdv_array)][3] = wrk_round(sepet.satir[i].row_nettotal,basket_total_round_number);
			}

		// otv array
		otv_flag = 0;
		for (k=1;k lte arraylen(sepet.otv_array);k=k+1)
		{
			if (sepet.otv_array[k][1] eq sepet.satir[i].otv_oran)
			{
				otv_flag = 1;
				sepet.otv_array[k][2] = sepet.otv_array[k][2] + sepet.satir[i].row_otvtotal;
			}
		}
		if (not otv_flag)
		{
			sepet.otv_array[arraylen(sepet.otv_array)+1][1] = sepet.satir[i].otv_oran;
			sepet.otv_array[arraylen(sepet.otv_array)][2] = sepet.satir[i].row_otvtotal;
		}
		sepet.satir[i].assortment_array = ArrayNew(1);

		sepet.satir[i].row_oiv_rate = ( len( OIV_RATE ) ) ? OIV_RATE : '';
		sepet.satir[i].row_oiv_amount = ( len( OIV_AMOUNT ) ) ? OIV_AMOUNT : '';
		sepet.satir[i].row_bsmv_rate = ( len( BSMV_RATE ) ) ? BSMV_RATE : '';
		sepet.satir[i].row_bsmv_amount = ( len( BSMV_AMOUNT ) ) ? BSMV_AMOUNT : '';
		//sepet.satir[i].row_bsmv_currency = ( len( BSMV_CURRENCY ) ) ? BSMV_CURRENCY : '';
		sepet.satir[i].row_tevkifat_rate = ( len( TEVKIFAT_RATE ) ) ? TEVKIFAT_RATE : '';
		sepet.satir[i].row_tevkifat_amount = ( len( TEVKIFAT_AMOUNT ) ) ? TEVKIFAT_AMOUNT : '';
		
		</cfscript>
	</cfoutput>
</cfif>
