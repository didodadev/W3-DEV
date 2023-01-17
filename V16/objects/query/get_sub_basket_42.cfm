<cfquery name="GET_SHIP_ROW" datasource="#dsn2#">
	SELECT
		SHIP_ROW.*,
		STOCKS.IS_INVENTORY,
		STOCKS.IS_PRODUCTION,
		STOCKS.PRODUCT_NAME,
		STOCKS.MANUFACT_CODE,
		STOCKS.STOCK_CODE,
		STOCKS.BARCOD,
		STOCKS.STOCK_CODE_2
	FROM 
		SHIP_ROW,
		#dsn3_alias#.STOCKS STOCKS
	WHERE 
		SHIP_ID IN (#attributes.LIST_OF_SHIP#) AND
		SHIP_ROW.STOCK_ID=STOCKS.STOCK_ID
<!---ORDER BY SHIP_ROW_ID--->
</cfquery>
<cfset product_id_list=listsort(ListDeleteDuplicates(valuelist(GET_SHIP_ROW.PRODUCT_ID)),'numeric','asc',',')>
<cfquery name="get_product_accounts" datasource="#dsn3#">
	SELECT
		PER.ACCOUNT_CODE,
		PER.ACCOUNT_CODE_PUR,
		PER.PRODUCT_ID
	FROM
		PRODUCT_PERIOD PER
	WHERE
		PER.PRODUCT_ID IN (#product_id_list#) AND
		PER.PERIOD_ID=#session.ep.period_id#
	ORDER BY
		PER.PRODUCT_ID
</cfquery>
<cfset product_id_list=listsort(ListDeleteDuplicates(valuelist(get_product_accounts.PRODUCT_ID)),'numeric','asc',',')>
<cfscript>
	sepet = StructNew();
	sepet.satir = ArrayNew(1);
	sepet.kdv_array = ArrayNew(2);
	sepet.total = 0;
	sepet.toplam_indirim = 0;
	sepet.total_tax = 0;
	sepet.net_total = 0;
	sepet.genel_indirim = 0;
	//sepet.basket_ship_id = attributes.LIST_OF_SHIP;
</cfscript>
<cfoutput query="GET_SHIP_ROW">
	<cfscript>
		i = currentrow;
		sepet.satir[i] = StructNew();
		
		sepet.satir[i].wrk_row_id ="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
		sepet.satir[i].wrk_row_relation_id = '';
		
		sepet.satir[i].product_id = PRODUCT_ID;
		sepet.satir[i].is_inventory =IS_INVENTORY;
		sepet.satir[i].is_production =IS_PRODUCTION;
		if (len(ship_id))
			sepet.satir[i].row_ship_id = '#ship_id#;#session.ep.period_id#';
		sepet.satir[i].product_name = NAME_PRODUCT;
		sepet.satir[i].amount = AMOUNT;
		sepet.satir[i].unit = UNIT;
		sepet.satir[i].unit_id = UNIT_ID;
		sepet.satir[i].price = PRICE;
		sepet.satir[i].stock_id = STOCK_ID;
		sepet.satir[i].barcode = BARCOD;
		sepet.satir[i].stock_code = STOCK_CODE;
		sepet.satir[i].special_code = STOCK_CODE_2;
		sepet.satir[i].manufact_code = PRODUCT_MANUFACT_CODE;
		sepet.satir[i].dara = DARA;
		sepet.satir[i].darali = DARALI;
		sepet.satir[i].paymethod_id = PAYMETHOD_ID;
	
		if(sale_product eq 0)
			sepet.satir[i].product_account_code = get_product_accounts.ACCOUNT_CODE_PUR[listfind(product_id_list,PRODUCT_ID,',')];
		else
			sepet.satir[i].product_account_code = get_product_accounts.ACCOUNT_CODE[listfind(product_id_list,PRODUCT_ID,',')];
	
		if(len(UNIQUE_RELATION_ID)) sepet.satir[i].row_unique_relation_id = UNIQUE_RELATION_ID; else sepet.satir[i].row_unique_relation_id = "";
		if(len(PRODUCT_NAME2)) sepet.satir[i].product_name_other = PRODUCT_NAME2; else sepet.satir[i].product_name_other = "";
		if(len(AMOUNT2)) sepet.satir[i].amount_other = AMOUNT2; else sepet.satir[i].amount_other = "";
		if(len(UNIT2)) sepet.satir[i].unit_other = UNIT2; else sepet.satir[i].unit_other = "";
		if(len(EXTRA_PRICE)) sepet.satir[i].ek_tutar = EXTRA_PRICE; else sepet.satir[i].ek_tutar = 0;
		if(len(EXTRA_PRICE_OTHER_TOTAL) ) sepet.satir[i].ek_tutar_other_total = EXTRA_PRICE_OTHER_TOTAL; else sepet.satir[i].ek_tutar_other_total = 0;
		if(len(SHELF_NUMBER)) sepet.satir[i].shelf_number = SHELF_NUMBER; else sepet.satir[i].shelf_number = "";
	
		if (not len(discount)) sepet.satir[i].indirim1 = 0; else sepet.satir[i].indirim1 = discount;
		if (not len(discount2)) sepet.satir[i].indirim2 = 0; else sepet.satir[i].indirim2 = discount2;
		if (not len(discount3)) sepet.satir[i].indirim3 = 0; else sepet.satir[i].indirim3 = discount3;
		if (not len(discount4)) sepet.satir[i].indirim4 = 0; else sepet.satir[i].indirim4 = discount4;
		if (not len(discount5)) sepet.satir[i].indirim5 = 0; else sepet.satir[i].indirim5 = discount5;
		if (not len(discount6)) sepet.satir[i].indirim6 = 0; else sepet.satir[i].indirim6 = discount6;
		if (not len(discount7)) sepet.satir[i].indirim7 = 0; else sepet.satir[i].indirim7 = discount7;
		if (not len(discount8)) sepet.satir[i].indirim8 = 0; else sepet.satir[i].indirim8 = discount8;
		if (not len(discount9)) sepet.satir[i].indirim9 = 0; else sepet.satir[i].indirim9 = discount9;
		if (not len(discount10)) sepet.satir[i].indirim10 = 0; else sepet.satir[i].indirim10 = discount10;
		sepet.satir[i].indirim_carpan = (100-sepet.satir[i].indirim1) * (100-sepet.satir[i].indirim2) * (100-sepet.satir[i].indirim3) * (100-sepet.satir[i].indirim4) * (100-sepet.satir[i].indirim5) * (100-sepet.satir[i].indirim6) * (100-sepet.satir[i].indirim7) * (100-sepet.satir[i].indirim8) * (100-sepet.satir[i].indirim9) * (100-sepet.satir[i].indirim10);
	
		if(len(TAX))sepet.satir[i].tax_percent = TAX;
		else sepet.satir[i].tax_percent = 0;
		//sepet.satir[i].row_total = amount*price;
		if(len(NETTOTAL))
		{
			sepet.satir[i].row_total = NETTOTAL+DISCOUNTTOTAL;//amount*price;
			sepet.satir[i].row_nettotal = NETTOTAL;
			sepet.satir[i].row_taxtotal = TAXTOTAL;
			sepet.satir[i].row_lasttotal = NETTOTAL + TAXTOTAL;
			//if(len(grosstotal)) sepet.satir[i].row_lasttotal = grosstotal; else sepet.satir[i].row_lasttotal = 0;
		}else{
			sepet.satir[i].row_total = sepet.satir[i].amount * sepet.satir[i].price;
			sepet.satir[i].row_nettotal = (sepet.satir[i].row_total/100000000000000000000) * sepet.satir[i].indirim_carpan;
			sepet.satir[i].row_taxtotal = sepet.satir[i].row_nettotal * (sepet.satir[i].tax_percent/100);
			sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal;
		}
		
		sepet.total = sepet.total + wrk_round(sepet.satir[i].row_total,basket_total_round_number); //subtotal_
		sepet.toplam_indirim = sepet.toplam_indirim + (wrk_round(sepet.satir[i].row_total,price_round_number) - wrk_round(sepet.satir[i].row_nettotal,price_round_number)); //discount_
		sepet.net_total = sepet.net_total + sepet.satir[i].row_nettotal; //nettotal_
	
		sepet.satir[i].other_money = OTHER_MONEY;
		if(len(OTHER_MONEY_VALUE))
			sepet.satir[i].other_money_value = OTHER_MONEY_VALUE;
		else
			sepet.satir[i].other_money_value =0;
		sepet.satir[i].other_money_grosstotal = OTHER_MONEY_GROSS_TOTAL;
		sepet.satir[i].deliver_date = dateformat(DELIVER_DATE,dateformat_style);
		
		if(len(DELIVER_LOC)) 
			sepet.satir[i].deliver_dept = DELIVER_DEPT & "-" & DELIVER_LOC ; 
		else 
			sepet.satir[i].deliver_dept = DELIVER_DEPT ; 
		
		sepet.satir[i].duedate = "";
		sepet.satir[i].spect_id = spect_var_id;
		sepet.satir[i].spect_name = spect_var_name;
		sepet.satir[i].lot_no = LOT_NO;
		if(len(PRICE_OTHER))
			sepet.satir[i].price_other = PRICE_OTHER;
		else
			sepet.satir[i].price_other = PRICE;
	
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
		
		if(len(OTVTOTAL))
		{ 
			sepet.satir[i].row_otvtotal =OTVTOTAL;
			/*20060530 aksi halde taxtotal daki kusurler basket toplamini bozuyor. if(len(GROSSTOTAL)) sepet.satir[i].row_lasttotal = GROSSTOTAL; else sepet.satir[i].row_lasttotal = 0;*/
			sepet.satir[i].row_lasttotal = NETTOTAL+TAXTOTAL+OTVTOTAL;
		}
		else
		{
			sepet.satir[i].row_otvtotal = 0;
			sepet.satir[i].row_lasttotal = NETTOTAL+TAXTOTAL;
		}
	</cfscript>
</cfoutput>
<cfscript>
	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		sepet.kdv_array[k][2] = wrk_round(sepet.kdv_array[k][3] * sepet.kdv_array[k][1] /100,basket_total_round_number);
	
	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		sepet.total_tax = sepet.total_tax + sepet.kdv_array[k][2];
	
	sepet.net_total = sepet.net_total + sepet.total_tax;
</cfscript>
