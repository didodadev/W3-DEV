<cfif isdefined("attributes.receiving_detail_id") and len(attributes.receiving_detail_id)>
	<cfset kontrol_row = 0>
	<cfloop from="1" to="#attributes.line_count#" index="x">
		<cfif isdefined("attributes.stock_id_#x#") and len(evaluate("attributes.stock_id_#x#"))>
			<cfset kontrol_row = kontrol_row + 1>
		</cfif>
	</cfloop>
	<cfif kontrol_row neq 0>
		<cfquery name="GET_INVOICE_ROW" datasource="#dsn3#">
			<cfset count_row = 0>
			<cfloop from="1" to="#attributes.line_count#" index="x">
				<cfif len(evaluate("attributes.stock_id_#x#"))>
					<cfset count_row = count_row + 1>
					SELECT 
						PRODUCT_UNIT.MAIN_UNIT_ID AS UNIT_ID,
						PRODUCT_UNIT.MAIN_UNIT AS UNIT,
						'' UNIT2,
						STOCKS.PRODUCT_NAME NAME_PRODUCT,
						STOCKS.PRODUCT_NAME PRODUCT_NAME2,
						STOCKS.IS_SERIAL_NO,
						STOCKS.STOCK_ID,
						STOCKS.PRODUCT_ID,
						STOCKS.STOCK_CODE,
						STOCKS.STOCK_CODE_2,
						STOCKS.BARCOD,
						STOCKS.PROPERTY,
						STOCKS.IS_INVENTORY,
						STOCKS.IS_PRODUCTION,
						#evaluate("attributes.tax_#x#")# TAX,
						'' WRK_ROW_RELATION_ID,
						'' RELATED_ACTION_ID,
						'' RELATED_ACTION_TABLE,
						'' UNIQUE_RELATION_ID,
						'' PROM_RELATION_ID,
						'' SHIP_ID,
						'' EXTRA_COST,
						'' DUE_DATE,
						'' DELIVER_LOC,
						'' DELIVER_DEPT,
						'' PROM_COMISSION,
						'' PROM_COST,
						'' PROM_ID,
						'' IS_COMMISSION,
						'' BASKET_EXTRA_INFO_ID,
						'' SELECT_INFO_EXTRA,
						'' DETAIL_INFO_EXTRA,
						'' BASKET_EMPLOYEE_ID,
						#wrk_round(evaluate("attributes.price_#x#"))# LIST_PRICE,
						'' PRICE_CAT,
						'' KARMA_PRODUCT_ID,
						'' CATALOG_ID,
						0 NUMBER_OF_INSTALLMENT,			
						'' AS WRK_ROW_ID,
						'' AS WRK_ROW_RELATION_ID,
						'' AS ROW_PAYMETHOD_ID,
						0 PAY_METHOD,
						#wrk_round(evaluate("attributes.price_#x#"))# PRICE,
						#evaluate("attributes.quantity_#x#")# AS AMOUNT,
						#evaluate("attributes.quantity_#x#")# AS AMOUNT2,
						#evaluate("attributes.price_#x#")# AS PRICE_OTHER,
						#wrk_round(evaluate("attributes.net_total_#x#"))# AS NETTOTAL,
						0 AS PRICE_KDV,
						'#session.ep.other_money#' AS MONEY,
						'#session.ep.other_money#' AS OTHER_MONEY,
						((#evaluate("attributes.net_total_#x#")#+#wrk_round(evaluate("attributes.net_total_#x#"))#*#evaluate("attributes.tax_#x#")#)/100) AS OTHER_MONEY_GROSS_TOTAL,
						(#wrk_round(evaluate("attributes.net_total_#x#"))#*#evaluate("attributes.tax_#x#")#/100) AS TAXTOTAL,
						#wrk_round(evaluate("attributes.net_total_#x#"))*wrk_round(evaluate("attributes.discount_#x#"))/100#  AS DISCOUNTTOTAL,
						#wrk_round(evaluate("attributes.discount_#x#"))# AS DISCOUNT1,
						0 AS DISCOUNT2,
						0 AS DISCOUNT3,
						0 AS DISCOUNT4,
						0 AS DISCOUNT5,
						0 AS DISCOUNT6,
						0 AS DISCOUNT7,
						0 AS DISCOUNT8,
						0 AS DISCOUNT9,
						0 AS DISCOUNT10,
						0 AS DISCOUNT_COST,
						'' AS MARGIN,
						#NOW()# AS DELIVER_DATE,
						'' AS WIDTH_VALUE,
						'' AS DEPTH_VALUE,
						'' AS HEIGHT_VALUE,
						'' AS ROW_PROJECT_ID,
						'' COST_PRICE,
						'' EXTRA_PRICE,
						'' EK_TUTAR_PRICE,
						'' EXTRA_PRICE_TOTAL,
						'' EXTRA_PRICE_OTHER_TOTAL,
						'' SHELF_NUMBER,
						'' PRODUCT_MANUFACT_CODE,
						'' OTVTOTAL,
						0 OTV_ORAN,
						0 OTHER_MONEY_VALUE,
						'' SPECT_VAR_ID,
						'' SPECT_VAR_NAME,
						'' LOT_NO,
						'' IS_PROMOTION,
						'' PROM_STOCK_ID,
						'' SUBSCRIPTION_ID,
						'' SUBSCRIPTION_NO,
						'' SUBSCRIPTION_HEAD,
						'' ASSET_P_ID,
						'' ASSET_P,
						'' BSMV_RATE,
						'' BSMV_AMOUNT,
						'' BSMV_CURRENCY,
						'' OIV_RATE,
						'' OIV_AMOUNT,
						'' TEVKIFAT_RATE,
						'' TEVKIFAT_AMOUNT
					FROM 
						STOCKS AS STOCKS,
						PRODUCT_UNIT
					WHERE
						PRODUCT_UNIT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
						PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
						STOCKS.STOCK_ID = #evaluate("attributes.stock_id_#x#")#
						<cfif count_row neq kontrol_row>
							 UNION ALL
						</cfif>
				</cfif>
			 </cfloop>
		</cfquery>
	<cfelse>
		<cfquery name="GET_INVOICE_ROW" datasource="#dsn3#">
			SELECT 
				PRODUCT_UNIT.MAIN_UNIT_ID AS UNIT_ID,
				PRODUCT_UNIT.MAIN_UNIT AS UNIT,
				'' UNIT2,
				STOCKS.PRODUCT_NAME NAME_PRODUCT,
				STOCKS.PRODUCT_NAME PRODUCT_NAME2,
				STOCKS.IS_SERIAL_NO,
				STOCKS.STOCK_ID,
				STOCKS.PRODUCT_ID,
				STOCKS.STOCK_CODE,
				STOCKS.STOCK_CODE_2,
				STOCKS.BARCOD,
				STOCKS.PROPERTY,
				STOCKS.IS_INVENTORY,
				STOCKS.IS_PRODUCTION,
				0 TAX,
				'' WRK_ROW_RELATION_ID,
				'' RELATED_ACTION_ID,
				'' RELATED_ACTION_TABLE,
				'' UNIQUE_RELATION_ID,
				'' PROM_RELATION_ID,
				'' SHIP_ID,
				'' EXTRA_COST,
				'' DUE_DATE,
				'' DELIVER_LOC,
				'' DELIVER_DEPT,
				'' PROM_COMISSION,
				'' PROM_COST,
				'' PROM_ID,
				'' IS_COMMISSION,
				'' BASKET_EXTRA_INFO_ID,
				'' SELECT_INFO_EXTRA,
				'' DETAIL_INFO_EXTRA,
				'' BASKET_EMPLOYEE_ID,
				0 LIST_PRICE,
				'' PRICE_CAT,
				'' KARMA_PRODUCT_ID,
				'' CATALOG_ID,
				0 NUMBER_OF_INSTALLMENT,			
				'' AS WRK_ROW_ID,
				'' AS WRK_ROW_RELATION_ID,
				'' AS ROW_PAYMETHOD_ID,
				0 PAY_METHOD,
				0 PRICE,
				0 AS AMOUNT,
				0AS AMOUNT2,
				0 AS PRICE_OTHER,
				0 AS NETTOTAL,
				0 AS PRICE_KDV,
				'#session.ep.other_money#' AS MONEY,
				'#session.ep.other_money#' AS OTHER_MONEY,
				0 AS OTHER_MONEY_GROSS_TOTAL,
				0 AS TAXTOTAL,
				0 AS DISCOUNTTOTAL,
				0 AS DISCOUNT1,
				0 AS DISCOUNT2,
				0 AS DISCOUNT3,
				0 AS DISCOUNT4,
				0 AS DISCOUNT5,
				0 AS DISCOUNT6,
				0 AS DISCOUNT7,
				0 AS DISCOUNT8,
				0 AS DISCOUNT9,
				0 AS DISCOUNT10,
				0 AS DISCOUNT_COST,
				'' AS MARGIN,
				#NOW()# AS DELIVER_DATE,
				'' AS WIDTH_VALUE,
				'' AS DEPTH_VALUE,
				'' AS HEIGHT_VALUE,
				'' AS ROW_PROJECT_ID,
				'' COST_PRICE,
				'' EXTRA_PRICE,
				'' EK_TUTAR_PRICE,
				'' EXTRA_PRICE_TOTAL,
				'' EXTRA_PRICE_OTHER_TOTAL,
				'' SHELF_NUMBER,
				'' PRODUCT_MANUFACT_CODE,
				'' OTVTOTAL,
				0 OTV_ORAN,
				0 OTHER_MONEY_VALUE,
				'' SPECT_VAR_ID,
				'' SPECT_VAR_NAME,
				'' LOT_NO,
				'' IS_PROMOTION,
				'' PROM_STOCK_ID,
				'' SUBSCRIPTION_ID,
				'' SUBSCRIPTION_NO,
				'' SUBSCRIPTION_HEAD,
				'' ASSET_P_ID,
				'' ASSET_P,
				'' BSMV_RATE,
				'' BSMV_AMOUNT,
				'' BSMV_CURRENCY,
				'' OIV_RATE,
				'' OIV_AMOUNT,
				'' TEVKIFAT_RATE,
				'' TEVKIFAT_AMOUNT
			FROM 
				STOCKS AS STOCKS,
				PRODUCT_UNIT
			WHERE
				PRODUCT_UNIT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
				PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
				STOCKS.STOCK_ID = 0
		</cfquery>
	</cfif>
	<cfscript>
		get_sale_det.STOPAJ = '';
		get_sale_det.STOPAJ_ORAN = '';
		get_sale_det.STOPAJ_RATE_ID = '';
		get_sale_det.ROUND_MONEY = 0;
		if(len(session.ep.other_money))
		{
			get_sale_det.OTHER_MONEY = '#session.ep.other_money#';
			default_basket_money_ = '#session.ep.other_money#';
		}
		else
		{
			get_sale_det.OTHER_MONEY ='TL';
			default_basket_money_='TL';
		}
		get_sale_det.general_prom_id = '';
		get_sale_det.free_prom_id = '';
		get_sale_det.sa_discount = '';
		get_sale_det.TEVKIFAT = 0;
	</cfscript>
<cfelse>
	<cfquery name="GET_INVOICE_ROW" datasource="#dsn2#">
		SELECT 
			INVOICE_ROW.*,
			STOCKS.STOCK_ID,
			STOCKS.PRODUCT_ID,
			STOCKS.STOCK_CODE,
			STOCKS.BARCOD,
			STOCKS.PROPERTY,
			STOCKS.IS_INVENTORY,
			STOCKS.IS_PRODUCTION,
			STOCKS.PRODUCT_NAME,
			STOCKS.MANUFACT_CODE,
			STOCKS.STOCK_CODE_2,
			SC.SUBSCRIPTION_NO,
			SC.SUBSCRIPTION_HEAD,
			ASSP.ASSETP
		FROM 
			INVOICE_ROW
			LEFT JOIN #dsn3#.SUBSCRIPTION_CONTRACT AS SC ON INVOICE_ROW.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID
			LEFT JOIN #dsn#.ASSET_P AS ASSP ON INVOICE_ROW.ASSETP_ID = ASSP.ASSETP_ID,
			#dsn3_alias#.STOCKS  AS STOCKS
		WHERE
			INVOICE_ROW.STOCK_ID=STOCKS.STOCK_ID AND		
			INVOICE_ROW.INVOICE_ID = #attributes.IID#
		ORDER BY
			INVOICE_ROW_ID
	</cfquery>
</cfif>
<cfset product_id_list=listsort(ListDeleteDuplicates(valuelist(GET_INVOICE_ROW.PRODUCT_ID)),'numeric','asc',',')>
<cfset row_project_id_list_=listsort(ListDeleteDuplicates(valuelist(GET_INVOICE_ROW.ROW_PROJECT_ID)),'numeric','asc',',')>
<cfif len(row_project_id_list_)>
	<cfquery name="GET_ROW_PROJECTS" datasource="#dsn#">
		SELECT PROJECT_HEAD,PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID IN (#row_project_id_list_#) ORDER BY PROJECT_ID
	</cfquery>
	<cfset row_project_id_list_=valuelist(GET_ROW_PROJECTS.PROJECT_ID)>
</cfif>
<cfif listlen(product_id_list)>
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
</cfif>
<cfscript>
	sale_product = 0;
	sepet = StructNew();
	sepet.satir = ArrayNew(1);
	sepet.kdv_array = ArrayNew(2);
	sepet.otv_array = ArrayNew(2);
	sepet.total = 0;
	sepet.toplam_indirim = 0;
	
	if(isdefined("attributes.convert_products_id") and len(attributes.convert_products_id) and isdefined("attributes.convert_stocks_id") and len(attributes.convert_stocks_id))
	{
		get_sale_det.STOPAJ = '';
		get_sale_det.STOPAJ_ORAN = '';
		get_sale_det.STOPAJ_RATE_ID = '';
		get_sale_det.ROUND_MONEY = 0;
		if(len(session.ep.other_money))
		{
			get_sale_det.OTHER_MONEY = '#session.ep.other_money#';
			default_basket_money_ = '#session.ep.other_money#';
		}
		else
		{
			get_sale_det.OTHER_MONEY ='TL';
			default_basket_money_='TL';
		}
		get_sale_det.general_prom_id = '';
		get_sale_det.free_prom_id = '';
		get_sale_det.sa_discount = '';
		get_sale_det.TEVKIFAT = 0;
	}
	
	if(len(get_sale_det.STOPAJ))
		sepet.stopaj = get_sale_det.STOPAJ;
	else
		sepet.stopaj = 0;
	if(len(get_sale_det.STOPAJ_ORAN))
		sepet.stopaj_yuzde = get_sale_det.STOPAJ_ORAN;
	else
		sepet.stopaj_yuzde = 0;
	if(len(get_sale_det.STOPAJ_RATE_ID))
		sepet.stopaj_rate_id = get_sale_det.STOPAJ_RATE_ID;
	else
		sepet.stopaj_rate_id = 0;
	sepet.total_tax = 0;
	sepet.total_otv = 0;
	sepet.net_total = 0;
	sepet.genel_indirim = 0;
	//sepet.basket_ship_id = "";
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
		
		//Kopyalama ve rapordan vs donusturmede Wrk_row_id degeri sifirdan olusmalidir, digerleri icin ornegin guncellemede ayni kalmalidir
		if( (isdefined("attributes.event") and attributes.event is 'copy') or (isdefined("attributes.convert_products_id") and len(attributes.convert_products_id) and isdefined("attributes.convert_stocks_id") and len(attributes.convert_stocks_id)) )
		{
			sepet.satir[i].wrk_row_id="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
			if(findnocase('copy',fusebox.fuseaction))
			{
				sepet.satir[i].wrk_row_relation_id = "";
				
			}
			else
				if(isDefined("attributes.iid") and Len(attributes.iid))
					sepet.satir[i].wrk_row_relation_id = get_invoice_row.wrk_row_id;
				else
					sepet.satir[i].wrk_row_relation_id = get_invoice_row.wrk_row_relation_id;
		}
		else
		{
			sepet.satir[i].wrk_row_id = get_invoice_row.wrk_row_id;
			sepet.satir[i].wrk_row_relation_id = get_invoice_row.wrk_row_relation_id;
		}

		if((isdefined("attributes.event") and attributes.event is 'copy') or (isdefined("attributes.convert_products_id") and len(attributes.convert_products_id) and isdefined("attributes.convert_stocks_id") and len(attributes.convert_stocks_id)) )
		{
			sepet.satir[i].related_action_id="";
			sepet.satir[i].related_action_table="";
		}
		else
		{
			sepet.satir[i].related_action_id=RELATED_ACTION_ID;
			sepet.satir[i].related_action_table=RELATED_ACTION_TABLE;	
		}
		
		sepet.satir[i].product_id = product_id;
		sepet.satir[i].is_inventory = is_inventory;
		sepet.satir[i].is_production = is_production;
		if (len(ship_id) and len(ship_period_id))
			sepet.satir[i].row_ship_id = '#ship_id#;#ship_period_id#';
		else if( len(ship_id))
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
		sepet.satir[i].net_maliyet = 0;	
		sepet.satir[i].marj = 0;	
		sepet.satir[i].iskonto_tutar = DISCOUNT_COST;
		if (len(extra_cost)) sepet.satir[i].extra_cost = extra_cost; else sepet.satir[i].extra_cost =0;
		sepet.satir[i].indirim_carpan = (100-sepet.satir[i].indirim1) * (100-sepet.satir[i].indirim2) * (100-sepet.satir[i].indirim3) * (100-sepet.satir[i].indirim4) * (100-sepet.satir[i].indirim5) * (100-sepet.satir[i].indirim6) * (100-sepet.satir[i].indirim7) * (100-sepet.satir[i].indirim8) * (100-sepet.satir[i].indirim9) * (100-sepet.satir[i].indirim10);

		if(len(UNIQUE_RELATION_ID)) sepet.satir[i].row_unique_relation_id = UNIQUE_RELATION_ID; else sepet.satir[i].row_unique_relation_id = "";
		if(len(PROM_RELATION_ID)) sepet.satir[i].prom_relation_id = PROM_RELATION_ID; else sepet.satir[i].prom_relation_id = "";
		if(len(PRODUCT_NAME2)) sepet.satir[i].product_name_other = PRODUCT_NAME2; else sepet.satir[i].product_name_other = "";
		if(len(AMOUNT2)) sepet.satir[i].amount_other = AMOUNT2; else sepet.satir[i].amount_other = "";
		if(len(UNIT2)) sepet.satir[i].unit_other = UNIT2; else sepet.satir[i].unit_other = "";
		if(len(EXTRA_PRICE)) sepet.satir[i].ek_tutar = EXTRA_PRICE; else sepet.satir[i].ek_tutar = 0;
		if(len(EXTRA_PRICE_TOTAL)) sepet.satir[i].ek_tutar_total = EXTRA_PRICE_TOTAL; else sepet.satir[i].ek_tutar_total = 0;
		if(len(EXTRA_PRICE_OTHER_TOTAL)) sepet.satir[i].ek_tutar_other_total = EXTRA_PRICE_OTHER_TOTAL; else sepet.satir[i].ek_tutar_other_total = 0;
		if(len(SHELF_NUMBER)) sepet.satir[i].shelf_number = SHELF_NUMBER; else sepet.satir[i].shelf_number = "";
		if(len(BASKET_EXTRA_INFO_ID)) sepet.satir[i].basket_extra_info = BASKET_EXTRA_INFO_ID; else sepet.satir[i].basket_extra_info="";
		if(len(SELECT_INFO_EXTRA)) sepet.satir[i].select_info_extra = SELECT_INFO_EXTRA; else sepet.satir[i].select_info_extra="";
		if(len(DETAIL_INFO_EXTRA)) sepet.satir[i].detail_info_extra = DETAIL_INFO_EXTRA; else sepet.satir[i].detail_info_extra="";
		if(len(WIDTH_VALUE)) sepet.satir[i].row_width = WIDTH_VALUE; else sepet.satir[i].row_width = '';
		if(len(DEPTH_VALUE)) sepet.satir[i].row_depth = DEPTH_VALUE; else  sepet.satir[i].row_depth = '';
		if(len(HEIGHT_VALUE)) sepet.satir[i].row_height = HEIGHT_VALUE; else  sepet.satir[i].row_height = '';
		if(len(ROW_PROJECT_ID))
		{
			sepet.satir[i].row_project_id=ROW_PROJECT_ID;
			sepet.satir[i].row_project_name=GET_ROW_PROJECTS.PROJECT_HEAD[listfind(row_project_id_list_,ROW_PROJECT_ID)];
		}
		sepet.satir[i].stock_id = stock_id;
		sepet.satir[i].barcode = BARCOD;
		sepet.satir[i].stock_code = STOCK_CODE;
		sepet.satir[i].special_code = STOCK_CODE_2;
		sepet.satir[i].manufact_code = PRODUCT_MANUFACT_CODE;
		sepet.satir[i].duedate = pay_method;
		sepet.satir[i].row_total = nettotal+discounttotal;//amount*price;
		sepet.satir[i].row_nettotal = nettotal;
		sepet.satir[i].row_taxtotal = taxtotal;
		if(len(OTVTOTAL)) sepet.satir[i].row_otvtotal = OTVTOTAL; else sepet.satir[i].row_otvtotal = 0;
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
		
		sepet.satir[i].spect_id = spect_var_id;
		sepet.satir[i].spect_name = spect_var_name;
		sepet.satir[i].lot_no = LOT_NO;
		if(len(PRICE_OTHER))
			sepet.satir[i].price_other = PRICE_OTHER;
		else
			sepet.satir[i].price_other = PRICE;
	
		if(len(tax))
			sepet.satir[i].tax_percent =TAX;
		else if(nettotal neq 0) 
			sepet.satir[i].tax_percent =(taxtotal/nettotal)*100; 
		else 
			sepet.satir[i].tax_percent=0;

		if(len(OTV_ORAN)) //özel tüketim vergisi
			sepet.satir[i].otv_oran = OTV_ORAN;
		else if(NETTOTAL neq 0 and len(OTVTOTAL) and OTVTOTAL neq 0) 
			sepet.satir[i].otv_oran = (OTVTOTAL/NETTOTAL)*100; 
		else 
			sepet.satir[i].otv_oran = 0;
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
				sepet.kdv_array[k][2] = sepet.kdv_array[k][2] + wrk_round(sepet.satir[i].row_taxtotal,basket_total_round_number);
				sepet.kdv_array[k][3] = sepet.kdv_array[k][3] + wrk_round(sepet.satir[i].row_nettotal,basket_total_round_number);			
				}
			}
		if (not kdv_flag)
			{
			sepet.kdv_array[arraylen(sepet.kdv_array)+1][1] = sepet.satir[i].tax_percent;
			sepet.kdv_array[arraylen(sepet.kdv_array)][2] = wrk_round(sepet.satir[i].row_taxtotal,basket_total_round_number);
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
		
		if(len(LIST_PRICE)) sepet.satir[i].list_price = LIST_PRICE; else sepet.satir[i].list_price = PRICE;
		if(len(PRICE_CAT)) sepet.satir[i].price_cat = PRICE_CAT; else  sepet.satir[i].price_cat = '';
		if(len(CATALOG_ID)) sepet.satir[i].row_catalog_id = CATALOG_ID; else  sepet.satir[i].row_catalog_id = '';
		if(len(NUMBER_OF_INSTALLMENT)) sepet.satir[i].number_of_installment = NUMBER_OF_INSTALLMENT; else sepet.satir[i].number_of_installment = 0;
		sepet.satir[i].lot_no = "";

		sepet.satir[i].row_subscription_id = ( len( SUBSCRIPTION_ID ) ) ? SUBSCRIPTION_ID : '';
		sepet.satir[i].row_subscription_name = ( len( SUBSCRIPTION_NO ) and len( SUBSCRIPTION_HEAD ) ) ? SUBSCRIPTION_NO & " - " & SUBSCRIPTION_HEAD : '';
		sepet.satir[i].row_assetp_id = ( len( ASSETP_ID ) ) ? ASSETP_ID : '';
		sepet.satir[i].row_assetp_name = ( len( ASSETP ) ) ? ASSETP : '';
		sepet.satir[i].row_oiv_rate = ( len( OIV_RATE ) ) ? OIV_RATE : '';
		sepet.satir[i].row_oiv_amount = ( len( OIV_AMOUNT ) ) ? OIV_AMOUNT : '';
		sepet.satir[i].row_bsmv_rate = ( len( BSMV_RATE ) ) ? BSMV_RATE : '';
		sepet.satir[i].row_bsmv_amount = ( len( BSMV_AMOUNT ) ) ? BSMV_AMOUNT : '';
		sepet.satir[i].row_bsmv_currency = ( len( BSMV_CURRENCY ) ) ? BSMV_CURRENCY : '';
		sepet.satir[i].row_tevkifat_rate = ( len( TEVKIFAT_RATE ) ) ? TEVKIFAT_RATE : '';
		sepet.satir[i].row_tevkifat_amount = ( len( TEVKIFAT_AMOUNT ) ) ? TEVKIFAT_AMOUNT : '';

	</cfscript>
</cfoutput>
<cfscript>
	
	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		sepet.total_tax = sepet.total_tax + sepet.kdv_array[k][2];
		
	
	for (t=1;t lte arraylen(sepet.otv_array);t=t+1)
		sepet.total_otv = sepet.total_otv + wrk_round(sepet.otv_array[t][2],price_round_number);
	sepet.net_total = sepet.net_total + sepet.total_tax + sepet.total_otv;
</cfscript>
