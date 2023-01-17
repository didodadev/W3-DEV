<cfquery name="GET_SHIP_ROW" datasource="#dsn2#">
	SELECT
		SH.*,
		S.IS_INVENTORY,
		S.IS_PRODUCTION,
		S.STOCK_CODE,
		S.BARCOD,
		S.IS_SERIAL_NO,
		S.MANUFACT_CODE,
		S.STOCK_CODE,
		S.STOCK_CODE_2
	FROM 
		SHIP_ROW SH,
		#dsn3_alias#.STOCKS S
	WHERE 
		SH.SHIP_ID=#attributes.ship_id# AND
		SH.STOCK_ID=S.STOCK_ID
	ORDER BY
		SH.SHIP_ROW_ID
</cfquery>
<cfset row_project_id_list_=listsort(ListDeleteDuplicates(valuelist(GET_SHIP_ROW.ROW_PROJECT_ID)),'numeric','asc',',')>
<cfif len(row_project_id_list_)>
	<cfquery name="GET_ROW_PROJECTS" datasource="#dsn#">
		SELECT PROJECT_HEAD,PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID IN (#row_project_id_list_#) ORDER BY PROJECT_ID
	</cfquery>
	<cfset row_project_id_list_=valuelist(GET_ROW_PROJECTS.PROJECT_ID)>
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
	sepet.other_money = GET_UPD_PURCHASE.OTHER_MONEY;
</cfscript>
<cfoutput query="GET_SHIP_ROW">
	<cfscript>
		i = currentrow;
		sepet.satir[i] = StructNew();

		if(isdefined("attributes.is_copy") and attributes.is_copy eq 1)
		{
			sepet.satir[i].wrk_row_id="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
			sepet.satir[i].wrk_row_relation_id ='';
		}
		else
		{
			sepet.satir[i].wrk_row_relation_id = GET_SHIP_ROW.wrk_row_relation_id[i];
			sepet.satir[i].wrk_row_id=GET_SHIP_ROW.WRK_ROW_ID[i];
		}
		sepet.satir[i].product_id = GET_SHIP_ROW.product_id;
		sepet.satir[i].is_inventory = GET_SHIP_ROW.is_inventory;
		sepet.satir[i].is_production = GET_SHIP_ROW.is_production;
		sepet.satir[i].special_code = GET_SHIP_ROW.STOCK_CODE_2;
		sepet.satir[i].product_name = name_product;
		sepet.satir[i].amount = amount;
		sepet.satir[i].unit = unit;
		sepet.satir[i].unit_id = unit_id;
		sepet.satir[i].price = price;
		sepet.satir[i].IS_SERIAL_NO = IS_SERIAL_NO;		
		if(len(IMPORT_INVOICE_ID) and len(IMPORT_PERIOD_ID))
			sepet.satir[i].row_ship_id = IMPORT_INVOICE_ID&";"&IMPORT_PERIOD_ID ;
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
		if (len(COST_PRICE)) sepet.satir[i].net_maliyet = COST_PRICE; else sepet.satir[i].net_maliyet=0;
		sepet.satir[i].marj = 0;
		if (len(EXTRA_COST)) sepet.satir[i].extra_cost = EXTRA_COST; else sepet.satir[i].extra_cost = 0;
		if(len(tax))sepet.satir[i].tax_percent = tax;else sepet.satir[i].tax_percent = 0;
		sepet.satir[i].paymethod_id = paymethod_id;
		sepet.satir[i].stock_id = stock_id;
		sepet.satir[i].barcode = GET_SHIP_ROW.BARCOD;
		sepet.satir[i].stock_code = GET_SHIP_ROW.STOCK_CODE;
		sepet.satir[i].manufact_code = PRODUCT_MANUFACT_CODE;
		sepet.satir[i].duedate = GET_SHIP_ROW.DUE_DATE;
		if(len(UNIQUE_RELATION_ID)) sepet.satir[i].row_unique_relation_id = UNIQUE_RELATION_ID; else sepet.satir[i].row_unique_relation_id = "";
		if(len(PRODUCT_NAME2)) sepet.satir[i].product_name_other = PRODUCT_NAME2; else sepet.satir[i].product_name_other = "";
		if(len(AMOUNT2)) sepet.satir[i].amount_other = AMOUNT2; else sepet.satir[i].amount_other = "";
		if(len(UNIT2)) sepet.satir[i].unit_other = UNIT2; else sepet.satir[i].unit_other = "";
		if(len(EXTRA_PRICE)) sepet.satir[i].ek_tutar = EXTRA_PRICE; else sepet.satir[i].ek_tutar = 0;
		if(len(EXTRA_PRICE_TOTAL)) sepet.satir[i].ek_tutar_total = EXTRA_PRICE_TOTAL; else sepet.satir[i].ek_tutar_total = 0;
		if(len(EXTRA_PRICE_OTHER_TOTAL) ) sepet.satir[i].ek_tutar_other_total = EXTRA_PRICE_OTHER_TOTAL; else sepet.satir[i].ek_tutar_other_total = 0;
		if(len(WIDTH_VALUE)) sepet.satir[i].row_width = WIDTH_VALUE; else sepet.satir[i].row_width = '';
		if(len(DEPTH_VALUE)) sepet.satir[i].row_depth = DEPTH_VALUE; else  sepet.satir[i].row_depth = '';
		if(len(HEIGHT_VALUE)) sepet.satir[i].row_height = HEIGHT_VALUE; else  sepet.satir[i].row_height = '';
		if(len(ROW_PROJECT_ID))
		{
			sepet.satir[i].row_project_id=ROW_PROJECT_ID;
			sepet.satir[i].row_project_name=GET_ROW_PROJECTS.PROJECT_HEAD[listfind(row_project_id_list_,ROW_PROJECT_ID)];
		}
		// ekk satır seçim
		if(len(select_info_extra)) sepet.satir[i].select_info_extra=select_info_extra;
		else sepet.satir[i].select_info_extra='';
		// ek açıklama
		if(len(BASKET_EXTRA_INFO_ID)) sepet.satir[i].basket_extra_info = BASKET_EXTRA_INFO_ID; 
		else sepet.satir[i].basket_extra_info="";
		// ek satır açıklama
		if(len(detail_info_extra))sepet.satir[i].detail_info_extra=detail_info_extra;
		else sepet.satir[i].detail_info_extra='';
		if(len(SHELF_NUMBER)) sepet.satir[i].shelf_number = SHELF_NUMBER; else sepet.satir[i].shelf_number = "";
		if(len(TO_SHELF_NUMBER)) sepet.satir[i].to_shelf_number = TO_SHELF_NUMBER; else sepet.satir[i].to_shelf_number = "";
		if(len(NETTOTAL))
		{
			sepet.satir[i].row_total = NETTOTAL+DISCOUNTTOTAL;//amount*price;
			sepet.satir[i].row_nettotal = NETTOTAL;
			sepet.satir[i].row_taxtotal = TAXTOTAL;
			if(len(OTVTOTAL))
			{ 
				sepet.satir[i].row_otvtotal =OTVTOTAL;
				sepet.satir[i].row_lasttotal = NETTOTAL+TAXTOTAL+OTVTOTAL;
			}
			else
			{
				sepet.satir[i].row_otvtotal = 0;
				sepet.satir[i].row_lasttotal = NETTOTAL+TAXTOTAL;
			}
		}else{
			sepet.satir[i].row_total = (sepet.satir[i].amount * sepet.satir[i].price)+sepet.satir[i].ek_tutar_total;
			sepet.satir[i].row_nettotal = (sepet.satir[i].row_total/100000000000000000000) * sepet.satir[i].indirim_carpan;
			sepet.satir[i].row_taxtotal = sepet.satir[i].row_nettotal * (sepet.satir[i].tax_percent/100);
			if(len(OTVTOTAL))
			{ 
				sepet.satir[i].row_otvtotal =OTVTOTAL;
				sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal+sepet.satir[i].row_otvtotal;
			}
			else
			{
				sepet.satir[i].row_otvtotal = 0;
				sepet.satir[i].row_lasttotal =sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal;
			}
		}
	
		sepet.total = sepet.total + wrk_round(sepet.satir[i].row_total,basket_total_round_number); //subtotal_
		sepet.toplam_indirim = sepet.toplam_indirim + (wrk_round(sepet.satir[i].row_total,price_round_number) - wrk_round(sepet.satir[i].row_nettotal,price_round_number)); //discount_
		sepet.net_total = sepet.net_total + sepet.satir[i].row_nettotal; //nettotal_
		
		sepet.satir[i].iskonto_tutar = DISCOUNT_COST;
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
		if(len(OTV_ORAN)) //özel tüketim vergisi
			sepet.satir[i].otv_oran = OTV_ORAN;
		else if(NETTOTAL neq 0 and len(OTVTOTAL) and OTVTOTAL neq 0) 
			sepet.satir[i].otv_oran = (OTVTOTAL/NETTOTAL)*100; 
		else 
			sepet.satir[i].otv_oran = 0;
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
		sepet.satir[i].assortment_array = ArrayNew(1);
		
		if(len(LIST_PRICE)) sepet.satir[i].list_price = LIST_PRICE; else sepet.satir[i].list_price = PRICE;
		if(len(PRICE_CAT)) sepet.satir[i].price_cat = PRICE_CAT; else  sepet.satir[i].price_cat = '';
		if(len(CATALOG_ID)) sepet.satir[i].row_catalog_id = CATALOG_ID; else  sepet.satir[i].row_catalog_id = '';
		if(len(NUMBER_OF_INSTALLMENT)) sepet.satir[i].number_of_installment = NUMBER_OF_INSTALLMENT; else sepet.satir[i].number_of_installment = 0;

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
