<cfquery name="GET_INVOICE_ROW" datasource="#dsn2#">
	SELECT 
		INVOICE_ROW_POS.*,
		STOCKS.IS_SERIAL_NO,
		STOCKS.STOCK_ID,
		STOCKS.PRODUCT_ID,
		STOCKS.STOCK_CODE,
		STOCKS.BARCOD,
		STOCKS.PROPERTY,
		STOCKS.IS_INVENTORY,
		STOCKS.IS_PRODUCTION,
		STOCKS.MANUFACT_CODE,
		PRODUCT_NAME AS NAME_PRODUCT,
		'' BASKET_EMPLOYEE_ID,
		'' SHIP_ID,
		'' KARMA_PRODUCT_ID,
		'' DISCOUNT1,
		'' DISCOUNT2,
		'' DISCOUNT3,
		'' DISCOUNT4,
		'' DISCOUNT5,
		'' DISCOUNT6,
		'' DISCOUNT7,
		'' DISCOUNT8,
		'' DISCOUNT9,
		'' DISCOUNT10,
		'' COST_PRICE,
		'' MARGIN,
		'' EXTRA_COST,
		'' UNIQUE_RELATION_ID,
		'' PROM_RELATION_ID,
		'' PRODUCT_NAME2,
		'' UNIT2,
		'' AMOUNT2,
		'' EXTRA_PRICE,
		'' EK_TUTAR_PRICE,
		'' EXTRA_PRICE_TOTAL,
		'' EXTRA_PRICE_OTHER_TOTAL,
		'' SHELF_NUMBER,
		'' BASKET_EXTRA_INFO_ID,
		'' SELECT_INFO_EXTRA,
		'' DETAIL_INFO_EXTRA,
		'' PRODUCT_MANUFACT_CODE,
		'' DUE_DATE,
		'' OTVTOTAL,
		'' DELIVER_DATE,
		'' DELIVER_LOC,
		'' DELIVER_DEPT,
		'' SPECT_VAR_ID,
		'' SPECT_VAR_NAME,
		'' LOT_NO,
		'' OTV_ORAN,
		'' PROM_COMISSION,
		'' PROM_COST,
		'' DISCOUNT_COST,
		'' IS_PROMOTION,
		'' PROM_STOCK_ID,
		'' IS_COMMISSION,
		'' LIST_PRICE,
		'' PRICE_CAT,
		'' NUMBER_OF_INSTALLMENT,
		STOCKS.STOCK_CODE_2	
	FROM 
		INVOICE_ROW_POS,
		#dsn3_alias#.STOCKS AS STOCKS
	WHERE
		INVOICE_ROW_POS.INVOICE_ID=#attributes.IID# AND
		INVOICE_ROW_POS.STOCK_ID=STOCKS.STOCK_ID
	ORDER BY
		INVOICE_ROW_ID
</cfquery>
<cfset product_id_list=listsort(ListDeleteDuplicates(valuelist(GET_INVOICE_ROW.PRODUCT_ID)),'numeric','asc',',')>
<cfset basket_emp_id_list=listsort(ListDeleteDuplicates(valuelist(GET_INVOICE_ROW.BASKET_EMPLOYEE_ID)),'numeric','asc',',')>
<cfquery name="get_product_accounts" datasource="#dsn3#">
	SELECT
		PER.ACCOUNT_CODE,
		PER.ACCOUNT_CODE_PUR,
		PER.PRODUCT_ID
	FROM
		PRODUCT_PERIOD PER
	WHERE
		PER.PRODUCT_ID IN (#product_id_list#) AND
		PER.PERIOD_ID = #session_base.period_id#
	ORDER BY
		PER.PRODUCT_ID
</cfquery>
<cfset product_id_list=listsort(ListDeleteDuplicates(valuelist(get_product_accounts.PRODUCT_ID)),'numeric','asc',',')>
<cfif len(basket_emp_id_list)>
	<cfquery name="GET_BASKET_EMPLOYEES" datasource="#dsn#">
		SELECT EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS BASKET_EMPLOYEE, EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#basket_emp_id_list#) ORDER BY EMPLOYEE_ID
	</cfquery>
	<cfset basket_emp_id_list = valuelist(GET_BASKET_EMPLOYEES.EMPLOYEE_ID)> <!--- bulunan kayıtlara gore liste yeniden set ediliyor --->
</cfif>
<cfscript>
	/* satir_serino_index = 1; */
	sepet = StructNew();
	sepet.satir = ArrayNew(1);
	sepet.kdv_array = ArrayNew(2);
	sepet.total_tax = 0;
	sepet.otv_array = ArrayNew(2);
	sepet.total_otv = 0;
	sepet.total = 0;
	sepet.toplam_indirim = 0;
	sepet.net_total = 0;
	sepet.genel_indirim = 0;
	sepet.yuvarlama = get_sale_det.ROUND_MONEY;
	sepet.other_money = get_sale_det.OTHER_MONEY;
	if( len(get_sale_det.general_prom_id) )
	{
		sepet.general_prom_id = get_sale_det.general_prom_id;
		sepet.general_prom_limit = get_sale_det.general_prom_limit;
		sepet.general_prom_discount = get_sale_det.general_prom_discount;
		sepet.general_prom_amount = get_sale_det.general_prom_amount;
	}
	if( len(get_sale_det.free_prom_id) )
	{
		sepet.free_prom_id = get_sale_det.free_prom_id;
		sepet.free_prom_limit = get_sale_det.free_prom_limit;
		sepet.free_prom_amount = get_sale_det.free_prom_amount;
		sepet.free_prom_cost = get_sale_det.free_prom_cost;
		sepet.free_prom_stock_id = get_sale_det.free_prom_stock_id;
		sepet.free_stock_price = get_sale_det.free_stock_price;
		sepet.free_stock_money = get_sale_det.free_stock_money;
	}
 
	if (isnumeric(get_sale_det.sa_discount))
		sepet.genel_indirim = get_sale_det.SA_DISCOUNT;
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
		
		sepet.satir[i].product_id = PRODUCT_ID;
		sepet.satir[i].is_inventory = IS_INVENTORY;
		sepet.satir[i].is_production = IS_PRODUCTION;
		sepet.satir[i].product_name = NAME_PRODUCT;
		sepet.satir[i].special_code = STOCK_CODE_2;
		sepet.satir[i].amount = AMOUNT;
		sepet.satir[i].unit = UNIT;
		sepet.satir[i].unit_id = UNIT_ID;
		sepet.satir[i].price = PRICE;	
		if(sale_product eq 0)
			sepet.satir[i].product_account_code = get_product_accounts.ACCOUNT_CODE_PUR[listfind(product_id_list,PRODUCT_ID,',')];
		else
			sepet.satir[i].product_account_code = get_product_accounts.ACCOUNT_CODE[listfind(product_id_list,PRODUCT_ID,',')];
		if(not (isdefined("attributes.event") and attributes.event is 'copy') and len(SHIP_ID) and len(SHIP_PERIOD_ID) and SHIP_PERIOD_ID neq 0)/*20050301 kopyalamada irsaliye id ler bos gecilmeli*/
			sepet.satir[i].row_ship_id = '#SHIP_ID#;#SHIP_PERIOD_ID#';
		else if(not (isdefined("attributes.event") and attributes.event is 'copy') and len(SHIP_ID))
			sepet.satir[i].row_ship_id = SHIP_ID;
		if(len(KARMA_PRODUCT_ID)) sepet.satir[i].karma_product_id =  KARMA_PRODUCT_ID; else sepet.satir[i].karma_product_id = ''; 
		if (not len(DISCOUNT1)) sepet.satir[i].indirim1 = 0; else sepet.satir[i].indirim1 = DISCOUNT1;
		if (not len(DISCOUNT2)) sepet.satir[i].indirim2 = 0; else sepet.satir[i].indirim2 = DISCOUNT2;
		if (not len(DISCOUNT3)) sepet.satir[i].indirim3 = 0; else sepet.satir[i].indirim3 = DISCOUNT3;
		if (not len(DISCOUNT4)) sepet.satir[i].indirim4 = 0; else sepet.satir[i].indirim4 = DISCOUNT4;
		if (not len(DISCOUNT5)) sepet.satir[i].indirim5 = 0; else sepet.satir[i].indirim5 = DISCOUNT5;
		if (not len(DISCOUNT6)) sepet.satir[i].indirim6 = 0; else sepet.satir[i].indirim6 = DISCOUNT6;
		if (not len(DISCOUNT7)) sepet.satir[i].indirim7 = 0; else sepet.satir[i].indirim7 = DISCOUNT7;
		if (not len(DISCOUNT8)) sepet.satir[i].indirim8 = 0; else sepet.satir[i].indirim8 = DISCOUNT8;
		if (not len(DISCOUNT9)) sepet.satir[i].indirim9 = 0; else sepet.satir[i].indirim9 = DISCOUNT9;
		if (not len(DISCOUNT10)) sepet.satir[i].indirim10 = 0; else sepet.satir[i].indirim10 = DISCOUNT10;
		sepet.satir[i].indirim_carpan = (100-sepet.satir[i].indirim1) * (100-sepet.satir[i].indirim2) * (100-sepet.satir[i].indirim3) * (100-sepet.satir[i].indirim4) * (100-sepet.satir[i].indirim5) * (100-sepet.satir[i].indirim6) * (100-sepet.satir[i].indirim7) * (100-sepet.satir[i].indirim8) * (100-sepet.satir[i].indirim9) * (100-sepet.satir[i].indirim10);
		if (len(COST_PRICE)) sepet.satir[i].net_maliyet = COST_PRICE; else sepet.satir[i].net_maliyet=0;
		if (len(MARGIN)) sepet.satir[i].marj = MARGIN; else sepet.satir[i].marj = 0;
		if (len(extra_cost)) sepet.satir[i].extra_cost = extra_cost; else sepet.satir[i].extra_cost =0;
		if(len(UNIQUE_RELATION_ID)) sepet.satir[i].row_unique_relation_id = UNIQUE_RELATION_ID; else sepet.satir[i].row_unique_relation_id = "";
		if(len(PROM_RELATION_ID)) sepet.satir[i].prom_relation_id = PROM_RELATION_ID; else sepet.satir[i].prom_relation_id = "";
		if(len(PRODUCT_NAME2)) sepet.satir[i].product_name_other = PRODUCT_NAME2; else sepet.satir[i].product_name_other = "";
		if(len(UNIT2)) sepet.satir[i].unit_other = UNIT2; else sepet.satir[i].unit_other = "";
		//iscilik birim ucretinden maliyet ve ektutar hesaplaması iscilik marj oranı dahil edilerek
		if(len(AMOUNT2)) sepet.satir[i].amount_other = AMOUNT2; else sepet.satir[i].amount_other = "";
		if(len(EXTRA_PRICE)) sepet.satir[i].ek_tutar = EXTRA_PRICE;	else sepet.satir[i].ek_tutar = 0;
		if(len(EK_TUTAR_PRICE))
		{
			sepet.satir[i].ek_tutar_price = EK_TUTAR_PRICE;
			if(len(AMOUNT2)) sepet.satir[i].ek_tutar_cost = EK_TUTAR_PRICE*AMOUNT2; else sepet.satir[i].ek_tutar_cost = EK_TUTAR_PRICE;
		}
		else
		{ sepet.satir[i].ek_tutar_price = 0;sepet.satir[i].ek_tutar_cost =0;}
		
		if(len(sepet.satir[i].ek_tutar_cost) and sepet.satir[i].ek_tutar_cost neq 0)
			sepet.satir[i].ek_tutar_marj = (sepet.satir[i].ek_tutar*100/sepet.satir[i].ek_tutar_cost)-100;
		else
			sepet.satir[i].ek_tutar_marj ='';
		//iscilik birim ucretinden maliyet ve ektutar hesaplaması iscilik marj oranı dahil edilerek
		if(len(EXTRA_PRICE_TOTAL)) sepet.satir[i].ek_tutar_total = EXTRA_PRICE_TOTAL; else sepet.satir[i].ek_tutar_total = 0;
		if(len(EXTRA_PRICE_OTHER_TOTAL)) sepet.satir[i].ek_tutar_other_total = EXTRA_PRICE_OTHER_TOTAL; else sepet.satir[i].ek_tutar_other_total = 0;
		if(len(SHELF_NUMBER)) sepet.satir[i].shelf_number = SHELF_NUMBER; else sepet.satir[i].shelf_number = "";
		if(len(BASKET_EXTRA_INFO_ID)) sepet.satir[i].basket_extra_info = BASKET_EXTRA_INFO_ID; else sepet.satir[i].basket_extra_info="";
		if(len(SELECT_INFO_EXTRA)) sepet.satir[i].select_info_extra = SELECT_INFO_EXTRA; else sepet.satir[i].select_info_extra="";
		if(len(DETAIL_INFO_EXTRA)) sepet.satir[i].detail_info_extra = DETAIL_INFO_EXTRA; else sepet.satir[i].detail_info_extra="";
		sepet.satir[i].stock_id = STOCK_ID;
		sepet.satir[i].barcode = BARCOD;
		sepet.satir[i].stock_code = STOCK_CODE;
		sepet.satir[i].manufact_code = PRODUCT_MANUFACT_CODE;
		if(len(DUE_DATE)) sepet.satir[i].duedate = DUE_DATE; else  sepet.satir[i].duedate = '';
		sepet.satir[i].row_total = NETTOTAL+DISCOUNTTOTAL;//amount*price;	
		sepet.satir[i].row_nettotal = NETTOTAL;
		sepet.satir[i].row_taxtotal = TAXTOTAL;
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
		sepet.satir[i].other_money = OTHER_MONEY;
		sepet.satir[i].other_money_value = OTHER_MONEY_VALUE;
		sepet.satir[i].other_money_grosstotal = OTHER_MONEY_GROSS_TOTAL;
		sepet.satir[i].deliver_date = dateformat(DELIVER_DATE,dateformat_style);
		
		if(len(DELIVER_LOC)) 
			sepet.satir[i].deliver_dept = DELIVER_DEPT & "-" & DELIVER_LOC ; 
		else 
			sepet.satir[i].deliver_dept = DELIVER_DEPT ; 
		
		sepet.satir[i].spect_id = SPECT_VAR_ID;
		sepet.satir[i].spect_name = SPECT_VAR_NAME;
		sepet.satir[i].lot_no = LOT_NO;
		if(len(PRICE_OTHER))
			sepet.satir[i].price_other = PRICE_OTHER;
		else
			sepet.satir[i].price_other = PRICE;
	
		if(len(TAX))
			sepet.satir[i].tax_percent = TAX;
		else if(NETTOTAL neq 0) 
			sepet.satir[i].tax_percent = (TAXTOTAL/NETTOTAL)*100; 
		else 
			sepet.satir[i].tax_percent = 0;

		if(len(OTV_ORAN)) //özel tüketim vergisi
			sepet.satir[i].otv_oran = OTV_ORAN;
		else if(NETTOTAL neq 0 and len(OTVTOTAL) and OTVTOTAL neq 0) 
			sepet.satir[i].otv_oran = (OTVTOTAL/NETTOTAL)*100; 
		else 
			sepet.satir[i].otv_oran = 0;

		sepet.total = sepet.total + wrk_round(sepet.satir[i].row_total,basket_total_round_number); //subtotal_	
		sepet.toplam_indirim = sepet.toplam_indirim + (wrk_round(sepet.satir[i].row_total,basket_total_round_number) - wrk_round(sepet.satir[i].row_nettotal,basket_total_round_number)); //discount_
		//writeoutput('#sepet.toplam_indirim#--#wrk_round(sepet.satir[i].row_total)#---#wrk_round(sepet.satir[i].row_nettotal)#<br/>');
		sepet.net_total = sepet.net_total + wrk_round(sepet.satir[i].row_nettotal,basket_total_round_number); //nettotal_ a daha sonra kdv toplam ekleniyor altta
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
		// ötv array
		otv_flag = 0;
		for (z=1;z lte arraylen(sepet.otv_array);z=z+1)
			{
			if (sepet.otv_array[z][1] eq sepet.satir[i].otv_oran)
				{
				otv_flag = 1;
				sepet.otv_array[z][2] = sepet.otv_array[z][2] + sepet.satir[i].row_otvtotal;
				}
			}
		if (not otv_flag)
			{
			sepet.otv_array[arraylen(sepet.otv_array)+1][1] = sepet.satir[i].otv_oran;
			sepet.otv_array[arraylen(sepet.otv_array)][2] = sepet.satir[i].row_otvtotal;
			}
	
		sepet.satir[i].promosyon_yuzde = PROM_COMISSION;
		if (len(PROM_COST)) sepet.satir[i].promosyon_maliyet = PROM_COST; else sepet.satir[i].promosyon_maliyet = 0;
		sepet.satir[i].iskonto_tutar = DISCOUNT_COST;
		sepet.satir[i].is_promotion = IS_PROMOTION;
		sepet.satir[i].prom_stock_id = PROM_STOCK_ID;
		sepet.satir[i].row_promotion_id = PROM_ID ;
		sepet.satir[i].is_commission = IS_COMMISSION;
	
		if(len(LIST_PRICE)) sepet.satir[i].list_price = LIST_PRICE; else sepet.satir[i].list_price = PRICE;
		if(len(PRICE_CAT)) sepet.satir[i].price_cat = PRICE_CAT; else  sepet.satir[i].price_cat = '';
		if(len(NUMBER_OF_INSTALLMENT)) sepet.satir[i].number_of_installment = NUMBER_OF_INSTALLMENT; else sepet.satir[i].number_of_installment = 0;

		if(len(BASKET_EMPLOYEE_ID))
		{	
			sepet.satir[i].basket_employee_id = BASKET_EMPLOYEE_ID; 
			sepet.satir[i].basket_employee = GET_BASKET_EMPLOYEES.BASKET_EMPLOYEE[listfind(basket_emp_id_list,BASKET_EMPLOYEE_ID)]; 
		}
		else
		{		
			sepet.satir[i].basket_employee_id = '';
			sepet.satir[i].basket_employee = '';
		}
	</cfscript>
</cfoutput>
<cfscript>
	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		sepet.kdv_array[k][2] = wrk_round(sepet.kdv_array[k][3] * sepet.kdv_array[k][1] /100,basket_total_round_number);
	
	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		sepet.total_tax = sepet.total_tax + sepet.kdv_array[k][2];
		
	
	for (t=1;t lte arraylen(sepet.otv_array);t=t+1)
		sepet.total_otv = sepet.total_otv + wrk_round(sepet.otv_array[t][2],price_round_number);
	
	sepet.net_total = sepet.net_total + sepet.total_tax + sepet.total_otv;
</cfscript>
