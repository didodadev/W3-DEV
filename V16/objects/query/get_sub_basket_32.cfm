<cfif isdefined("attributes.service_operation_ids") and isdefined("attributes.is_from_operations")>
	<cfquery name="GET_SHIP_ROW" datasource="#dsn3#">
		SELECT
			SH.PRICE AS PRICE,
			SUM(SH.AMOUNT) AMOUNT,
			SH.PRICE AS PRICE_OTHER,
			SUM(SH.TOTAL_PRICE) AS OTHER_MONEY_VALUE,
			S.PRODUCT_ID,
			S.STOCK_ID,
			S.MANUFACT_CODE,
			S.PROPERTY,
			S.BARCOD,
			S.STOCK_CODE,
			S.PRODUCT_NAME AS NAME_PRODUCT,
			S.IS_INVENTORY,
			S.IS_PRODUCTION,
			S.TAX,
			S.TAX_PURCHASE,
			PRODUCT_UNIT.MAIN_UNIT_ID AS UNIT_ID,
			PRODUCT_UNIT.MAIN_UNIT AS UNIT,
			SH.CURRENCY,
			SH.CURRENCY AS MONEY,
			SH.CURRENCY AS OTHER_MONEY,
			#NOW()# AS DELIVER_DATE,
			0 AS DISCOUNT,
			0 AS OTHER_MONEY_GROSS_TOTAL,
			0 AS DISCOUNTTOTAL,
			0 AS PRICE_KDV,
			0 AS TAXTOTAL,
			0 AS IS_SERIAL_NO,
			0 AS OTV_ORAN,
			0 AS EXTRA_COST,
			0 AS OTVTOTAL,
			0 AS DISCOUNT_COST,
			0 AS AMOUNT2,
			0 AS EXTRA_PRICE,
			0 AS EK_TUTAR_PRICE,
			0 AS EXTRA_PRICE_OTHER_TOTAL,
			0 AS LIST_PRICE,
			0 AS DISCOUNT2,
			0 AS DISCOUNT3,
			0 AS DISCOUNT4,
			0 AS DISCOUNT5,
			0 AS DISCOUNT6,
			0 AS DISCOUNT7,
			0 AS DISCOUNT8,
			0 AS DISCOUNT9,
			0 AS DISCOUNT10,
			0 AS PROM_COMISSION,
			SH.SERVICE_EMP_ID AS BASKET_EMPLOYEE_ID,
			0 AS ROW_PROJECT_ID,
			'' AS RELATED_ACTION_ID,
			'' AS RELATED_ACTION_TABLE,
			'' DELIVER_LOC,
			'' DELIVER_DEPT,
			'' AS NETTOTAL,
			'' AS PAYMETHOD_ID,
			'' AS SERVICE_NO,
			'' AS WIDTH_VALUE,
			'' AS DEPTH_VALUE,
			'' AS HEIGHT_VALUE,
			'' AS ROW_PROJECT_ID,
			'' AS PRODUCT_MANUFACT_CODE,
			'' AS DUE_DATE,
			'' AS SPECT_VAR_ID,
			'' AS SPECT_VAR_NAME,
			'' AS LOT_NO,
			'' AS UNIQUE_RELATION_ID,
			'' AS PRODUCT_NAME2,
			'' AS UNIT2,
			'' AS PROM_RELATION_ID,
			'' AS SHELF_NUMBER,
			'' AS PRICE_CAT,
			'' AS NUMBER_OF_INSTALLMENT,
			'' AS WIDTH_VALUE,
			'' AS DEPTH_VALUE,
			'' AS HEIGHT_VALUE,
			'' AS KARMA_PRODUCT_ID,
			'' WRK_ROW_ID,
			SH.PRICE	,
			S.STOCK_CODE_2		
		FROM
			STOCKS S,
			SERVICE SR,
			PRODUCT_UNIT,
			SERVICE_OPERATION SH
		WHERE
			SH.SERVICE_OPE_ID IN (#attributes.service_operation_ids#) AND
			SR.SERVICE_ID = SH.SERVICE_ID AND
			S.STOCK_ID = SH.STOCK_ID AND
			PRODUCT_UNIT.PRODUCT_ID = S.PRODUCT_ID AND
			PRODUCT_UNIT.PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID
		GROUP BY
			S.PRODUCT_ID,
			S.STOCK_ID,
			S.MANUFACT_CODE,
			S.PROPERTY,
			S.BARCOD,
			S.STOCK_CODE,
			S.PRODUCT_NAME,
			S.IS_INVENTORY,
			S.IS_PRODUCTION,
			S.TAX,
			S.TAX_PURCHASE,
			PRODUCT_UNIT.MAIN_UNIT_ID,
			PRODUCT_UNIT.MAIN_UNIT,
			SH.CURRENCY,
			SH.PRICE,
			SH.SERVICE_EMP_ID,
			S.STOCK_CODE_2
	</cfquery>
<cfelse>
	<cfquery name="GET_SHIP_ROW" datasource="#dsn#">
		SELECT 
			APSO.*,
			0 AS BASKET_EMPLOYEE_ID,
			0 AS ROW_PROJECT_ID,
			SERVICE_OPE_ID AS RELATED_ACTION_ID,
			'ASSET_P_SERVICE_OPERATION' AS RELATED_ACTION_TABLE,
			APSO.PRODUCT_NAME AS NAME_PRODUCT,
			'' AS KARMA_PRODUCT_ID,
			0 AS AMOUNT2,
			0 AS DISCOUNT,
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
			'' AS PRODUCT_MANUFACT_CODE,
			'' AS DUE_DATE,
			0 AS EXTRA_COST,
			'' AS NETTOTAL,
			0 AS DISCOUNTTOTAL,
			0 AS TAXTOTAL,
			0 AS OTVTOTAL,
			APSO.CURRENCY AS OTHER_MONEY,
			APSO.PRICE AS OTHER_MONEY_VALUE,
			APSO.TOTAL_PRICE AS OTHER_MONEY_GROSS_TOTAL,
			'' AS DELIVER_DATE,
			'' AS DELIVER_LOC,
			'' AS DELIVER_DEPT,
			'' AS SPECT_VAR_ID,
			'' AS SPECT_VAR_NAME,
			'' AS LOT_NO,
			APSO.PRICE AS PRICE_OTHER,
			'' AS UNIQUE_RELATION_ID,
			'' AS PROM_RELATION_ID,
			'' AS PRODUCT_NAME2,
			'' AS UNIT2,
			0 AS EXTRA_PRICE,
			0 AS EK_TUTAR_PRICE,
			0 AS EXTRA_PRICE_OTHER_TOTAL,
			'' AS SHELF_NUMBER,
			0 AS LIST_PRICE,
			'' AS PRICE_CAT,
			'' AS NUMBER_OF_INSTALLMENT,
			'' AS WIDTH_VALUE,
			'' AS DEPTH_VALUE,
			'' AS HEIGHT_VALUE,
			STOCKS.IS_SERIAL_NO,
			STOCKS.STOCK_ID,
			STOCKS.PRODUCT_ID,
			STOCKS.STOCK_CODE,
			STOCKS.BARCOD,
			STOCKS.PROPERTY,
			STOCKS.IS_INVENTORY,
			STOCKS.IS_PRODUCTION,
			STOCKS.MANUFACT_CODE,
			STOCKS.STOCK_CODE_2
		FROM 
			ASSET_P_SERVICE_OPERATION APSO,
			#dsn3_alias#.STOCKS AS STOCKS
		WHERE
			APSO.ASSETP_ID = #attributes.assetp_id# AND
			APSO.SERVICE_OPE_ID IN (#attributes.service_operation_id#) AND
			APSO.STOCK_ID = STOCKS.STOCK_ID
	</cfquery>
</cfif>
<cfset product_id_list_=listsort(ListDeleteDuplicates(valuelist(GET_SHIP_ROW.PRODUCT_ID)),'numeric','asc',',')>
<cfset basket_emp_id_list=listsort(ListDeleteDuplicates(valuelist(GET_SHIP_ROW.BASKET_EMPLOYEE_ID)),'numeric','asc',',')>
<cfset row_project_id_list_=listsort(ListDeleteDuplicates(valuelist(GET_SHIP_ROW.ROW_PROJECT_ID)),'numeric','asc',',')>
<cfquery name="get_product_accounts" datasource="#dsn3#">
	SELECT
		PER.ACCOUNT_CODE,
		PER.ACCOUNT_CODE_PUR,
		PER.PRODUCT_ID
	FROM
		PRODUCT_PERIOD PER
	WHERE
		PER.PRODUCT_ID IN (#product_id_list_#) AND
		PER.PERIOD_ID=#session.ep.period_id#
	ORDER BY
		PER.PRODUCT_ID
</cfquery>
<cfset product_id_list_=listsort(ListDeleteDuplicates(valuelist(get_product_accounts.PRODUCT_ID)),'numeric','asc',',')>
<cfif len(basket_emp_id_list)>
	<cfquery name="GET_BASKET_EMPLOYEES" datasource="#dsn#">
		SELECT EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS BASKET_EMPLOYEE, EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#basket_emp_id_list#) ORDER BY EMPLOYEE_ID
	</cfquery>
	<cfset basket_emp_id_list = valuelist(GET_BASKET_EMPLOYEES.EMPLOYEE_ID)> <!--- bulunan kayıtlara gore liste yeniden set ediliyor --->
</cfif>
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
	sepet.stopaj_rate_id = '';
	sepet.stopaj_yuzde = 0;
	sepet.stopaj = 0;
	//sepet.basket_ship_id = attributes.ship_id;
</cfscript>
<cfoutput query="GET_SHIP_ROW">
	<cfif currency eq SESSION.EP.MONEY>
		<cfset FIYAT = price>
		<cfset FIYAT_OTHER = price>
	<cfelse>
		<cfquery name="get_rate" datasource="#DSN#">SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY='#currency#'</cfquery>
		<cfset row_rate_info=(get_rate.RATE2/get_rate.RATE1)>
		<cfset FIYAT = price * (get_rate.RATE2/get_rate.RATE1)>
		<cfset FIYAT_OTHER = price>	
	</cfif>
	<cfscript>
		i = currentrow;
		sepet.satir[i] = StructNew();
		
		sepet.satir[i].wrk_row_id ="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
		sepet.satir[i].wrk_row_relation_id = wrk_row_id[i];
		
		sepet.satir[i].related_action_id=RELATED_ACTION_ID;
		sepet.satir[i].related_action_table=RELATED_ACTION_TABLE;		
		sepet.satir[i].product_id = PRODUCT_ID;
		sepet.satir[i].is_inventory = IS_INVENTORY;
		sepet.satir[i].is_production = IS_PRODUCTION;
		sepet.satir[i].product_name = NAME_PRODUCT;
		sepet.satir[i].amount = AMOUNT;
		sepet.satir[i].unit = UNIT;
		sepet.satir[i].unit_id = UNIT_ID;
		sepet.satir[i].price = FIYAT;
		if(sale_product eq 0)
			sepet.satir[i].product_account_code = get_product_accounts.ACCOUNT_CODE_PUR[listfind(product_id_list_,PRODUCT_ID,',')];
		else
			sepet.satir[i].product_account_code = get_product_accounts.ACCOUNT_CODE[listfind(product_id_list_,PRODUCT_ID,',')];
	
		if(len(KARMA_PRODUCT_ID)) sepet.satir[i].karma_product_id = KARMA_PRODUCT_ID; else  sepet.satir[i].karma_product_id = '';
		if (not len(DISCOUNT)) sepet.satir[i].indirim1 = 0; else sepet.satir[i].indirim1 = DISCOUNT;
		if (not len(DISCOUNT2)) sepet.satir[i].indirim2 = 0; else sepet.satir[i].indirim2 = DISCOUNT2;
		if (not len(DISCOUNT3)) sepet.satir[i].indirim3 = 0; else sepet.satir[i].indirim3 = DISCOUNT3;
		if (not len(DISCOUNT4)) sepet.satir[i].indirim4 = 0; else sepet.satir[i].indirim4 = DISCOUNT4;
		if (not len(DISCOUNT5)) sepet.satir[i].indirim5 = 0; else sepet.satir[i].indirim5 = DISCOUNT5;
		if (not len(DISCOUNT6)) sepet.satir[i].indirim6 = 0; else sepet.satir[i].indirim6 = DISCOUNT6;
		if (not len(DISCOUNT7)) sepet.satir[i].indirim7 = 0; else sepet.satir[i].indirim7 = DISCOUNT7;
		if (not len(DISCOUNT8)) sepet.satir[i].indirim8 = 0; else sepet.satir[i].indirim8 = DISCOUNT8;
		if (not len(DISCOUNT9)) sepet.satir[i].indirim9 = 0; else sepet.satir[i].indirim9 = DISCOUNT9;
		if (not len(DISCOUNT10)) sepet.satir[i].indirim10 = 0; else sepet.satir[i].indirim10 = DISCOUNT10;
		if (not len(DISCOUNT_COST)) sepet.satir[i].iskonto_tutar = 0; else sepet.satir[i].iskonto_tutar = DISCOUNT_COST;
		sepet.satir[i].indirim_carpan = (100-sepet.satir[i].indirim1) * (100-sepet.satir[i].indirim2) * (100-sepet.satir[i].indirim3) * (100-sepet.satir[i].indirim4) * (100-sepet.satir[i].indirim5) * (100-sepet.satir[i].indirim6) * (100-sepet.satir[i].indirim7) * (100-sepet.satir[i].indirim8) * (100-sepet.satir[i].indirim9) * (100-sepet.satir[i].indirim10);
	
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
		sepet.satir[i].paymethod_id = PAYMETHOD_ID;
		sepet.satir[i].stock_id = STOCK_ID;
		sepet.satir[i].barcode = BARCOD;
		sepet.satir[i].special_code = STOCK_CODE_2;
		sepet.satir[i].stock_code = STOCK_CODE;
		sepet.satir[i].manufact_code = PRODUCT_MANUFACT_CODE;
		if(len(DUE_DATE))sepet.satir[i].duedate = DUE_DATE; else sepet.satir[i].duedate = "";
		if (len(extra_cost)) sepet.satir[i].extra_cost = extra_cost; else sepet.satir[i].extra_cost = 0;
		//sepet.satir[i].row_total = amount*price;
		if(len(nettotal))
		{
			sepet.satir[i].row_total = nettotal+discounttotal;//amount*price;
			sepet.satir[i].row_nettotal = nettotal;
			sepet.satir[i].row_taxtotal = taxtotal;
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
			sepet.satir[i].row_total = sepet.satir[i].amount * sepet.satir[i].price;
			sepet.satir[i].row_nettotal = (sepet.satir[i].row_total/100000000000000000000) * sepet.satir[i].indirim_carpan;
			sepet.satir[i].row_taxtotal = sepet.satir[i].row_nettotal * (sepet.satir[i].tax_percent/100);
			if(len(OTVTOTAL))
			{ 
				sepet.satir[i].row_otvtotal =OTVTOTAL;
				sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal + sepet.satir[i].row_otvtotal;
			}
			else
			{
				sepet.satir[i].row_otvtotal = 0;
				sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal;
			}
		}
		sepet.total = sepet.total + wrk_round(sepet.satir[i].row_total,basket_total_round_number); //subtotal_
		sepet.toplam_indirim = sepet.toplam_indirim + (wrk_round(sepet.satir[i].row_total,price_round_number) - wrk_round(sepet.satir[i].row_nettotal,price_round_number)); //discount_
		sepet.net_total = sepet.net_total + sepet.satir[i].row_nettotal; //nettotal_ a daha sonra kdv toplam ekleniyor altta
		
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
		
		if(len(UNIQUE_RELATION_ID)) sepet.satir[i].row_unique_relation_id = UNIQUE_RELATION_ID; else sepet.satir[i].row_unique_relation_id = "";
		if(len(PROM_RELATION_ID)) sepet.satir[i].prom_relation_id = PROM_RELATION_ID; else sepet.satir[i].prom_relation_id = "";
		if(len(PRODUCT_NAME2)) sepet.satir[i].product_name_other = PRODUCT_NAME2; else sepet.satir[i].product_name_other = "";
		if(len(AMOUNT2)) sepet.satir[i].amount_other = AMOUNT2; else sepet.satir[i].amount_other = "";
		if(len(UNIT2)) sepet.satir[i].unit_other = UNIT2; else sepet.satir[i].unit_other = "";
		if(len(EXTRA_PRICE)) sepet.satir[i].ek_tutar = EXTRA_PRICE; else sepet.satir[i].ek_tutar = 0;
		
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
		
		if(len(EXTRA_PRICE_OTHER_TOTAL) ) sepet.satir[i].ek_tutar_other_total = EXTRA_PRICE_OTHER_TOTAL; else sepet.satir[i].ek_tutar_other_total = 0;
		if(len(SHELF_NUMBER)) sepet.satir[i].shelf_number = SHELF_NUMBER; else sepet.satir[i].shelf_number = "";
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
		if(len(WIDTH_VALUE)) sepet.satir[i].row_width = WIDTH_VALUE; else sepet.satir[i].row_width = '';
		if(len(DEPTH_VALUE)) sepet.satir[i].row_depth = DEPTH_VALUE; else  sepet.satir[i].row_depth = '';
		if(len(HEIGHT_VALUE)) sepet.satir[i].row_height = HEIGHT_VALUE; else  sepet.satir[i].row_height = '';
		if(len(ROW_PROJECT_ID))
		{
			sepet.satir[i].row_project_id=ROW_PROJECT_ID;
			sepet.satir[i].row_project_name=GET_ROW_PROJECTS.PROJECT_HEAD[listfind(row_project_id_list_,ROW_PROJECT_ID)];
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
