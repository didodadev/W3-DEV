<cfquery name="GET_INVOICE_ROW" datasource="#dsn2#">
	SELECT 
		INVOICE_ROW.*,
		STOCKS.STOCK_ID,
		STOCKS.PRODUCT_ID,
		STOCKS.STOCK_CODE,
		STOCKS.BARCOD,
		STOCKS.PROPERTY,
		STOCKS.PRODUCT_NAME,
		STOCKS.IS_INVENTORY,
		STOCKS.IS_PRODUCTION,
		STOCKS.MANUFACT_CODE,
		STOCKS.STOCK_CODE_2
	FROM 
		INVOICE_ROW, 
		#dsn3_alias#.STOCKS AS STOCKS
	WHERE
		INVOICE_ROW.STOCK_ID=STOCKS.STOCK_ID AND
		INVOICE_ROW.INVOICE_ID = #attributes.IID#
	ORDER BY
		INVOICE_ROW_ID
</cfquery>
<cfset product_id_list=listsort(ListDeleteDuplicates(valuelist(GET_INVOICE_ROW.PRODUCT_ID)),'numeric','asc',',')>
<cfset row_project_id_list_=listsort(ListDeleteDuplicates(valuelist(GET_INVOICE_ROW.ROW_PROJECT_ID)),'numeric','asc',',')>
<cfif len(row_project_id_list_)>
	<cfquery name="GET_ROW_PROJECTS" datasource="#dsn#">
		SELECT PROJECT_HEAD,PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID IN (#row_project_id_list_#) ORDER BY PROJECT_ID
	</cfquery>
	<cfset row_project_id_list_=valuelist(GET_ROW_PROJECTS.PROJECT_ID)>
</cfif>
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

<cfset satir_serino_index = 1 >
<cfscript>
	sepet = StructNew();
	sepet.satir = ArrayNew(1);
	sepet.kdv_array = ArrayNew(2);
	sepet.total = 0;
	sepet.toplam_indirim = 0;
	sepet.total_tax = 0;
	sepet.net_total = 0;
	sepet.genel_indirim = 0;
	sepet.yuvarlama=get_sale_det.ROUND_MONEY;
	//sepet.basket_ship_id = ValueList(get_ship_nums.SHIP_ID);
	if (isnumeric(get_sale_det.sa_discount))
		sepet.genel_indirim = get_sale_det.sa_discount;
	if( (get_sale_det.TEVKIFAT eq 1) and len(get_sale_det.TEVKIFAT_ORAN) )
	{
		sepet.tevkifat_box = 1;
		sepet.tevkifat_oran = get_sale_det.TEVKIFAT_ORAN;
		sepet.tevkifat_id = get_sale_det.TEVKIFAT_ID;
	}
</cfscript>

<cfoutput query="get_invoice_row">
	<cfscript>
	i = currentrow;
	sepet.satir[i] = StructNew();
	
	sepet.satir[i].wrk_row_id ="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
	sepet.satir[i].wrk_row_relation_id = '';
	
	sepet.satir[i].product_id = product_id;
	sepet.satir[i].is_inventory= is_inventory;
	sepet.satir[i].is_production= is_production;
	if (len(ship_id) and len(ship_period_id))
		sepet.satir[i].row_ship_id = '#ship_id#;#ship_period_id#';
	else if(len(ship_id))
		sepet.satir[i].row_ship_id = ship_id;
	sepet.satir[i].product_name = name_product;
	sepet.satir[i].amount = amount;
	sepet.satir[i].unit = unit;
	sepet.satir[i].unit_id = unit_id;
	sepet.satir[i].price = price;	
	if(sale_product eq 0)
		sepet.satir[i].product_account_code = get_product_accounts.ACCOUNT_CODE_PUR[listfind(product_id_list,PRODUCT_ID,',')];
	else
		sepet.satir[i].product_account_code = get_product_accounts.ACCOUNT_CODE[listfind(product_id_list,PRODUCT_ID,',')];

	if(len(UNIQUE_RELATION_ID)) sepet.satir[i].row_unique_relation_id = UNIQUE_RELATION_ID; else sepet.satir[i].row_unique_relation_id = "";
	if(len(PRODUCT_NAME2)) sepet.satir[i].product_name_other = PRODUCT_NAME2; else sepet.satir[i].product_name_other = "";
	if(len(AMOUNT2)) sepet.satir[i].amount_other = AMOUNT2; else sepet.satir[i].amount_other = "";
	if(len(UNIT2)) sepet.satir[i].unit_other = UNIT2; else sepet.satir[i].unit_other = "";
	if(len(EXTRA_PRICE)) sepet.satir[i].ek_tutar = EXTRA_PRICE; else sepet.satir[i].ek_tutar = 0;
	if(len(EXTRA_PRICE_TOTAL)) sepet.satir[i].ek_tutar_total = EXTRA_PRICE_TOTAL; else sepet.satir[i].ek_tutar_total = 0;
	if(len(EXTRA_PRICE_OTHER_TOTAL) ) sepet.satir[i].ek_tutar_other_total = EXTRA_PRICE_OTHER_TOTAL; else sepet.satir[i].ek_tutar_other_total = 0;
	if(len(SHELF_NUMBER)) sepet.satir[i].shelf_number = SHELF_NUMBER; else sepet.satir[i].shelf_number = "";
	if (len(COST_PRICE)) sepet.satir[i].net_maliyet = COST_PRICE; else sepet.satir[i].net_maliyet=0;
	if (len(extra_cost)) sepet.satir[i].extra_cost = extra_cost; else sepet.satir[i].extra_cost =0;
	if(len(WIDTH_VALUE)) sepet.satir[i].row_width = WIDTH_VALUE; else sepet.satir[i].row_width = '';
	if(len(DEPTH_VALUE)) sepet.satir[i].row_depth = DEPTH_VALUE; else  sepet.satir[i].row_depth = '';
	if(len(HEIGHT_VALUE)) sepet.satir[i].row_height = HEIGHT_VALUE; else  sepet.satir[i].row_height = '';
	if(len(ROW_PROJECT_ID))
		{
			sepet.satir[i].row_project_id=ROW_PROJECT_ID;
			sepet.satir[i].row_project_name=GET_ROW_PROJECTS.PROJECT_HEAD[listfind(row_project_id_list_,ROW_PROJECT_ID)];
		}
	if (not len(discount1)) sepet.satir[i].indirim1 = 0; else sepet.satir[i].indirim1 = discount1;
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
	sepet.satir[i].marj = 0;
	sepet.satir[i].dara = DARA;
	sepet.satir[i].darali = DARALI;	
	
	sepet.satir[i].stock_id = stock_id;
	sepet.satir[i].barcode = BARCOD;
	sepet.satir[i].stock_code = STOCK_CODE;
	sepet.satir[i].special_code = STOCK_CODE_2;
	sepet.satir[i].manufact_code = PRODUCT_MANUFACT_CODE;
	sepet.satir[i].duedate = DUE_DATE;// pay_method; abt 18032004
	sepet.satir[i].row_total = nettotal+discounttotal;//amount*price;
	sepet.satir[i].row_nettotal = nettotal;
	sepet.satir[i].row_taxtotal = taxtotal;
	sepet.satir[i].row_lasttotal = grosstotal;
	sepet.satir[i].other_money = OTHER_MONEY;
	sepet.satir[i].other_money_value = OTHER_MONEY_VALUE;
	sepet.satir[i].other_money_grosstotal = OTHER_MONEY_GROSS_TOTAL;
	sepet.satir[i].deliver_date = dateformat(DELIVER_DATE,dateformat_style);
	
	if(len(DELIVER_LOC)) 
		sepet.satir[i].deliver_dept = DELIVER_DEPT & "-" & DELIVER_LOC ; 
	else 
		sepet.satir[i].deliver_dept = DELIVER_DEPT ; 

	sepet.satir[i].assortment_array = ArrayNew(1);
	sepet.satir[i].spect_id = spect_var_id;
	sepet.satir[i].spect_name = spect_var_name;
	sepet.satir[i].lot_no = LOT_NO;
	if(len(PRICE_OTHER))
		sepet.satir[i].price_other = PRICE_OTHER;
	else
		sepet.satir[i].price_other = PRICE;

	if(len(tax))
		{
		sepet.satir[i].tax_percent =TAX;
		}
	else
		{
		if(nettotal neq 0) 
			sepet.satir[i].tax_percent =(taxtotal/nettotal)*100; 
		else 
			sepet.satir[i].tax_percent=0;
		}

	sepet.total = sepet.total + wrk_round(sepet.satir[i].row_total,basket_total_round_number); //subtotal_
	sepet.toplam_indirim = sepet.toplam_indirim + (wrk_round(sepet.satir[i].row_total,price_round_number) - wrk_round(sepet.satir[i].row_nettotal,price_round_number)); //discount_
	sepet.net_total = sepet.net_total + sepet.satir[i].row_nettotal; //nettotal_

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
		
	if(len(LIST_PRICE)) sepet.satir[i].list_price = LIST_PRICE; else sepet.satir[i].list_price = PRICE;
	if(len(PRICE_CAT)) sepet.satir[i].price_cat = PRICE_CAT; else  sepet.satir[i].price_cat = '';
	if(len(CATALOG_ID)) sepet.satir[i].row_catalog_id = CATALOG_ID; else  sepet.satir[i].row_catalog_id = '';
	if(len(NUMBER_OF_INSTALLMENT)) sepet.satir[i].number_of_installment = NUMBER_OF_INSTALLMENT; else sepet.satir[i].number_of_installment = 0;
	
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

	sepet.satir[i].lot_no = "";
	</cfscript>
</cfoutput>
<cfscript>
	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		sepet.kdv_array[k][2] = wrk_round(sepet.kdv_array[k][3] * sepet.kdv_array[k][1] /100,basket_total_round_number);
	
	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		sepet.total_tax = sepet.total_tax + sepet.kdv_array[k][2];
	
	sepet.net_total = sepet.net_total + sepet.total_tax;
</cfscript>
