<cfquery name="GET_SUBSCRIPTION_ROW" datasource="#DSN3#">
	SELECT
	*
	FROM
	(
		SELECT
			SCR.SUBSCRIPTION_ROW_ID,
			SCR.AMOUNT,
			SCR.PRICE,
			SCR.UNIT,
			SCR.UNIT_ID,
			SCR.PRODUCT_ID,
			SCR.STOCK_ID,
			SCR.OTHER_MONEY AS CURRENCY,
			SCR.ROW_ORDER_ID,
			SCR.BASKET_EXTRA_INFO_ID,
			SCR.SELECT_INFO_EXTRA,
			SCR.DETAIL_INFO_EXTRA,
			'' AS WRK_ROW_ID,
			SCR.PRODUCT_NAME AS PRODUCT_NAME,
			SCR.PRODUCT_NAME2 AS PRODUCT_NAME2,
			SCR.DISCOUNT1 AS DISCOUNT1,
			SCR.DISCOUNT2 AS DISCOUNT2,
			SCR.DISCOUNT3 AS DISCOUNT3,
			SCR.DISCOUNT4 AS DISCOUNT4,
			SCR.DISCOUNT5 AS DISCOUNT5,
			SCR.DISCOUNT6 AS DISCOUNT6,
			SCR.DISCOUNT7 AS DISCOUNT7,
			SCR.DISCOUNT8 AS DISCOUNT8,
			SCR.DISCOUNT9 AS DISCOUNT9,
			SCR.DISCOUNT10 AS DISCOUNT10,
			SCR.DISCOUNT_COST AS DISCOUNT_COST,
			S.TAX AS TAX,
			S.OTV AS OTV_ORAN,
			SCR.PAYMETHOD_ID AS PAYMETHOD_ID,
			SCR.EXTRA_COST AS EXTRA_COST,
			'' AS NETTOTAL,
			SCR.DISCOUNTTOTAL AS DISCOUNTTOTAL,
			SCR.TAXTOTAL AS TAXTOTAL,
			SCR.OTVTOTAL AS OTVTOTAL,
			SCR.OTHER_MONEY AS OTHER_MONEY,
			SCR.OTHER_MONEY_VALUE AS OTHER_MONEY_VALUE,
			SCR.OTHER_MONEY_GROSS_TOTAL AS OTHER_MONEY_GROSS_TOTAL,
			SCR.DELIVER_DATE AS DELIVER_DATE,
			SCR.SPECT_VAR_ID AS SPECT_VAR_ID,
			SCR.SPECT_VAR_NAME AS SPECT_VAR_NAME,
			SCR.LOT_NO AS LOT_NO,
			SCR.PRICE_OTHER AS PRICE_OTHER,
			P.BSMV AS BSMV_RATE,
			SCR.BSMV_AMOUNT,
			SCR.BSMV_CURRENCY,
			SCR.OIV_RATE,
			SCR.OIV_AMOUNT,
			SCR.TEVKIFAT_RATE,
			SCR.TEVKIFAT_AMOUNT,
			S.IS_INVENTORY,
			S.IS_PRODUCTION,
			S.STOCK_CODE,
			S.BARCOD,
			S.IS_SERIAL_NO,
			S.MANUFACT_CODE,
			S.STOCK_CODE_2,
			SCR.BASKET_EMPLOYEE_ID,
			SCR.LIST_PRICE
		FROM 
			SUBSCRIPTION_CONTRACT_ROW SCR,
			#dsn3_alias#.STOCKS S,
			PRODUCT P
		WHERE 
			SCR.SUBSCRIPTION_ID = #attributes.subscription_id# AND
			SCR.STOCK_ID = S.STOCK_ID AND
			S.PRODUCT_ID = P.PRODUCT_ID
		<cfif isdefined('attributes.service_id') and len(attributes.service_id) and isdefined('attributes.service_operation_id') and len(attributes.service_operation_id)>
		UNION ALL
			SELECT 
				'' SUBSCRIPTION_ROW_ID,
				SO.AMOUNT,
				ISNULL(SO.PRICE,0) PRICE,
				SO.UNIT,
				SO.UNIT_ID,
				SO.PRODUCT_ID,
				SO.STOCK_ID,
				SO.CURRENCY AS CURRENCY,
				'' AS ROW_ORDER_ID,
				'' AS BASKET_EXTRA_INFO_ID,
				'' SELECT_INFO_EXTRA,
				'' DETAIL_INFO_EXTRA,
				SO.WRK_ROW_ID,
				SO.PRODUCT_NAME AS PRODUCT_NAME,
				'' AS PRODUCT_NAME2,
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
				STOCKS.TAX AS TAX,
				0 AS OTV_ORAN,
				'' AS PAYMETHOD_ID,
				0 AS EXTRA_COST,
				'' AS NETTOTAL,
				'' AS DISCOUNTTOTAL,
				'' AS TAXTOTAL,
				'' AS OTVTOTAL,
				SO.CURRENCY AS OTHER_MONEY,
				ISNULL(SO.PRICE,0) AS OTHER_MONEY_VALUE,
				SO.TOTAL_PRICE AS OTHER_MONEY_GROSS_TOTAL,
				'' AS DELIVER_DATE,
				'' AS SPECT_VAR_ID,
				'' AS SPECT_VAR_NAME,
				'' AS LOT_NO,
				SO.PRICE AS PRICE_OTHER,
				STOCKS.IS_INVENTORY,
				STOCKS.IS_PRODUCTION,
				STOCKS.STOCK_CODE,
				STOCKS.BARCOD,
				STOCKS.IS_SERIAL_NO,
				STOCKS.MANUFACT_CODE,
				STOCKS.STOCK_CODE_2,
				'' BASKET_EMPLOYEE_ID,
				0 LIST_PRICE
			FROM 
				SERVICE_OPERATION SO,
				#dsn3_alias#.STOCKS AS STOCKS
			WHERE
				SO.SERVICE_ID = #attributes.service_id# AND
				SO.SERVICE_OPE_ID IN (#attributes.service_operation_id#) AND
				SO.STOCK_ID = STOCKS.STOCK_ID AND
				SO.STOCK_ID IS NOT NULL
		</cfif>
	)T1
	ORDER BY
		SUBSCRIPTION_ROW_ID
</cfquery>
<cfset basket_emp_id_list=listsort(ListDeleteDuplicates(valuelist(GET_SUBSCRIPTION_ROW.BASKET_EMPLOYEE_ID)),'numeric','asc',',')>
<cfif len(basket_emp_id_list)>
	<cfquery name="GET_BASKET_EMPLOYEES" datasource="#dsn#">
		SELECT EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS BASKET_EMPLOYEE, EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#basket_emp_id_list#) ORDER BY EMPLOYEE_ID
	</cfquery>
	<cfset basket_emp_id_list = valuelist(GET_BASKET_EMPLOYEES.EMPLOYEE_ID)> <!--- bulunan kayıtlara gore liste yeniden set ediliyor --->
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
	sepet.other_money = get_subscription.OTHER_MONEY;
	if (isnumeric(GET_SUBSCRIPTION.SA_DISCOUNT))
		sepet.genel_indirim = GET_SUBSCRIPTION.SA_DISCOUNT;
</cfscript>
<cfoutput query="GET_SUBSCRIPTION_ROW">
	<cfscript>
	i = currentrow;
	sepet.satir[i] = StructNew();
	sepet.satir[i].wrk_row_id ="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
	sepet.satir[i].wrk_row_relation_id = '';
	sepet.satir[i].product_id = product_id;
	sepet.satir[i].is_inventory = is_inventory;
	sepet.satir[i].is_production = is_production;
	sepet.satir[i].product_name = product_name;
	sepet.satir[i].amount = amount;
	sepet.satir[i].unit = unit;
	sepet.satir[i].unit_id = unit_id;
	sepet.satir[i].price = price;	
	if(not (isdefined("attributes.event") and attributes.event is 'copy') and len(ROW_ORDER_ID))
		sepet.satir[i].row_ship_id = ROW_ORDER_ID;
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
	sepet.satir[i].net_maliyet = 0;	
	sepet.satir[i].marj = 0;

	if(len(tax))sepet.satir[i].tax_percent = tax;else sepet.satir[i].tax_percent = 0;
	sepet.satir[i].paymethod_id = paymethod_id;
	sepet.satir[i].stock_id = stock_id;
	sepet.satir[i].barcode = BARCOD;
	sepet.satir[i].stock_code = STOCK_CODE;
	sepet.satir[i].product_name_other = PRODUCT_NAME2;
	sepet.satir[i].manufact_code = MANUFACT_CODE;
	sepet.satir[i].special_code = STOCK_CODE_2;
	sepet.satir[i].duedate = "";
	if(len(LIST_PRICE)) sepet.satir[i].list_price = LIST_PRICE; else sepet.satir[i].list_price = PRICE;
	if (len(EXTRA_COST)) sepet.satir[i].extra_cost = EXTRA_COST; else sepet.satir[i].extra_cost =0;
	sepet.satir[i].other_money = OTHER_MONEY;
	sepet.satir[i].iskonto_tutar = DISCOUNT_COST;	
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
	if(len(nettotal))
	{
		sepet.satir[i].row_total = nettotal+discounttotal;//amount*price;
		sepet.satir[i].row_nettotal = nettotal;
		sepet.satir[i].row_taxtotal = taxtotal;
		sepet.satir[i].row_lasttotal = nettotal + taxtotal;
		//if(len(grosstotal)) sepet.satir[i].row_lasttotal = grosstotal; else sepet.satir[i].row_lasttotal = 0;
	}
	else
	{
		sepet.satir[i].row_total = sepet.satir[i].amount * sepet.satir[i].price;
		sepet.satir[i].row_nettotal = sepet.satir[i].row_total;
		if(len(sepet.satir[i].iskonto_tutar) and get_money_bskt.recordcount)
			for(k=1;k lte get_money_bskt.recordcount;k=k+1)
				if(sepet.satir[i].other_money eq get_money_bskt.MONEY_TYPE[k])
					sepet.satir[i].row_nettotal = sepet.satir[i].row_nettotal - (sepet.satir[i].iskonto_tutar * get_money_bskt.RATE2[k] / get_money_bskt.RATE1[k] * sepet.satir[i].amount);
		sepet.satir[i].row_nettotal = wrk_round((sepet.satir[i].row_nettotal * sepet.satir[i].indirim_carpan) /100000000000000000000,price_round_number);
		sepet.satir[i].row_taxtotal = wrk_round((sepet.satir[i].row_nettotal * (sepet.satir[i].tax_percent/100)),price_round_number);
		sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal;
	}	
	if(len(OTVTOTAL))
	{
		sepet.satir[i].row_otvtotal =OTVTOTAL;
	/*20060530 aksi halde taxtotal daki kusurler basket toplamini bozuyor. if(len(GROSSTOTAL)) sepet.satir[i].row_lasttotal = GROSSTOTAL; else sepet.satir[i].row_lasttotal = 0;*/
		sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal+TAXTOTAL+OTVTOTAL;
	}
	else
	{
		sepet.satir[i].row_otvtotal = 0;
		sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal+TAXTOTAL;
	}
	if(len(OTHER_MONEY_VALUE))
		sepet.satir[i].other_money_value = OTHER_MONEY_VALUE;
	else
		sepet.satir[i].other_money_value =0;
	sepet.satir[i].other_money_grosstotal = OTHER_MONEY_GROSS_TOTAL;

	/*sepet.satir[i].deliver_date = dateformat(DELIVER_DATE,dateformat_style);
	if(len(DELIVER_LOC)) 
		sepet.satir[i].deliver_dept = DELIVER_DEPT & "-" & DELIVER_LOC ; 
	else 
		sepet.satir[i].deliver_dept = DELIVER_DEPT ; BK 051124 burasi abonelik icin bu sekilde degisti*/

	sepet.satir[i].deliver_date = '';
	sepet.satir[i].deliver_dept = 'NULL';

	sepet.satir[i].spect_id = spect_var_id;
	sepet.satir[i].spect_name = spect_var_name;
	sepet.satir[i].lot_no = LOT_NO;
	if(len(PRICE_OTHER))
		sepet.satir[i].price_other = PRICE_OTHER;
	else
		sepet.satir[i].price_other = PRICE;

	if(len(tax))
	{
	sepet.satir[i].tax_percent = TAX;
	}
	else
	{
		if(sepet.satir[i].row_nettotal neq 0) 
			sepet.satir[i].tax_percent =(taxtotal/sepet.satir[i].row_nettotal)*100; 
		else 
			sepet.satir[i].tax_percent=0;
	}
	if(len(OTV_ORAN)) //özel tüketim vergisi
		sepet.satir[i].otv_oran = OTV_ORAN;
	else if(sepet.satir[i].row_nettotal neq 0 and len(OTVTOTAL) and OTVTOTAL neq 0) 
		sepet.satir[i].otv_oran = (OTVTOTAL/sepet.satir[i].row_nettotal)*100; 
	else 
		sepet.satir[i].otv_oran = 0;

	sepet.total = sepet.total + wrk_round(sepet.satir[i].row_total,basket_total_round_number); //subtotal_
	sepet.toplam_indirim = sepet.toplam_indirim + (wrk_round(sepet.satir[i].row_total,price_round_number) - wrk_round(sepet.satir[i].row_nettotal,price_round_number)); //discount_
	sepet.net_total = sepet.net_total + sepet.satir[i].row_nettotal; //nettotal_
	sepet.total_tax = sepet.total_tax + sepet.satir[i].row_taxtotal; //totaltax_
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
	sepet.satir[i].deliver_date = dateformat(deliver_date,dateformat_style);
	if(len(BASKET_EXTRA_INFO_ID)) sepet.satir[i].basket_extra_info = BASKET_EXTRA_INFO_ID; else sepet.satir[i].basket_extra_info="";
	if(len(SELECT_INFO_EXTRA)) sepet.satir[i].select_info_extra = SELECT_INFO_EXTRA; else sepet.satir[i].select_info_extra="";
	if(len(DETAIL_INFO_EXTRA)) sepet.satir[i].detail_info_extra = DETAIL_INFO_EXTRA; else sepet.satir[i].detail_info_extra="";

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
	for (t=1;t lte arraylen(sepet.otv_array);t=t+1)
		sepet.total_otv = sepet.total_otv + wrk_round(sepet.otv_array[t][2],price_round_number);
</cfscript>
