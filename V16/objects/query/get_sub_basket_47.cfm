<cfif isDefined("attributes.packet_id") and len(attributes.packet_id)>
	<cfquery name="GET_ORDER_PRODUCTS" datasource="#DSN3#">
		SELECT
			PR.*,
			PR.ROW_IN AS QUANTITY,
			S.PROPERTY,
			S.STOCK_CODE,
			S.BARCOD,
			S.MANUFACT_CODE,
			S.IS_INVENTORY,
			S.IS_PRODUCTION,
			S.STOCK_CODE_2,
			S.PRODUCT_NAME,
			S.TAX,
			S.TAX_PURCHASE,
			'' BASKET_EMPLOYEE_ID,
			'' ROW_PROJECT_ID,
			'' ROW_WORK_ID,
			'' WRK_ROW_RELATION_ID,
			'' PAYMETHOD_ID,
			'' UNIQUE_RELATION_ID,
			'' ROW_DELIVER_DATE,
			'' RESERVE_DATE,
			'-1' ORDER_ROW_CURRENCY,
			'-1' RESERVE_TYPE,
			'TL' OTHER_MONEY,
			0 PRICE,
			0 PRICE_OTHER,
			0 DISCOUNT_1,
			0 DISCOUNT_2,
			0 DISCOUNT_3,
			0 DISCOUNT_4,
			0 DISCOUNT_5,
			0 DISCOUNT_6,
			0 DISCOUNT_7,
			0 DISCOUNT_8,
			0 DISCOUNT_9,
			0 DISCOUNT_10,
			0 OTVTOTAL
		FROM
			#dsn1#.PACKETING_ROW PR LEFT JOIN STOCKS S ON S.STOCK_ID = PR.STOCK_ID
		WHERE
			PR.UPD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.packet_id#">
			AND S.PRODUCT_STATUS = 1
		ORDER BY
			PR.PACKET_ROW_ID
	</cfquery>
<cfelseif isDefined("attributes.order_id") and len(attributes.order_id)>
	<cfquery name="GET_ORDER_PRODUCTS" datasource="#DSN3#">
		SELECT
			ORR.ORDER_ROW_ID,
			ORR.BASKET_EMPLOYEE_ID,
			ORR.ROW_PROJECT_ID,
			ORR.ROW_WORK_ID,
			ORR.OTHER_MONEY,
			ORR.PRODUCT_ID,
			ORR.PAYMETHOD_ID,
			ORR.UNIT,
			ORR.UNIT_ID,
			ORR.PRICE,
			ORR.PRODUCT_NAME,
			ORR.RESERVE_TYPE,
			ORR.RESERVE_DATE,
			ORR.PRICE_OTHER,
			ORR.TAX,
			ORR.UNIQUE_RELATION_ID,
			ORR.AMOUNT2,
			ORR.UNIT2,
			ORR.WIDTH_VALUE,
			ORR.DEPTH_VALUE,
			ORR.HEIGHT_VALUE,
			ORR.DISCOUNT_1,
			ORR.DISCOUNT_2,
			ORR.DISCOUNT_3,
			ORR.DISCOUNT_4,
			ORR.DISCOUNT_5,
			ORR.DISCOUNT_6,
			ORR.DISCOUNT_7,
			ORR.DISCOUNT_8,
			ORR.DISCOUNT_9,
			ORR.DISCOUNT_10,
			ORR.OTVTOTAL,
			S.PROPERTY,
			S.STOCK_CODE,
			S.BARCOD,
			S.MANUFACT_CODE,
			S.IS_INVENTORY,
			S.IS_PRODUCTION,
			S.STOCK_CODE_2,
			S.STOCK_ID,
			EXC.EXPENSE,
			EXI.EXPENSE_ITEM_NAME,
			ORR.QUANTITY - SUM(ISNULL(PR.ROW_IN,0) ) AS QUANTITY
		FROM
			STOCKS S,
			ORDER_ROW ORR
			LEFT JOIN #dsn2#.EXPENSE_CENTER AS EXC ON ORR.EXPENSE_CENTER_ID = EXC.EXPENSE_ID
			LEFT JOIN #dsn2#.EXPENSE_ITEMS AS EXI ON ORR.EXPENSE_ITEM_ID = EXI.EXPENSE_ITEM_ID
			LEFT JOIN #dsn1#.PACKETING_ROW PR ON ORR.ORDER_ID = PR.ORDER_ID AND PR.STOCK_ID = ORR.STOCK_ID
		WHERE
			ORR.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ORDER_ID#">
			AND ORR.STOCK_ID = S.STOCK_ID
			AND S.PRODUCT_STATUS = 1	
		GROUP BY
			ORR.ORDER_ROW_ID,
			ORR.BASKET_EMPLOYEE_ID,
			ORR.ROW_PROJECT_ID,
			ORR.ROW_WORK_ID,
			ORR.OTHER_MONEY,
			ORR.PRODUCT_ID,
			ORR.PAYMETHOD_ID,
			ORR.UNIT,
			ORR.UNIT_ID,
			ORR.PRICE,
			ORR.PRODUCT_NAME,
			ORR.RESERVE_TYPE,
			ORR.RESERVE_DATE,
			ORR.PRICE_OTHER,
			ORR.TAX,
			ORR.UNIQUE_RELATION_ID,
			ORR.AMOUNT2,
			ORR.UNIT2,
			ORR.WIDTH_VALUE,
			ORR.DEPTH_VALUE,
			ORR.HEIGHT_VALUE,
			ORR.DISCOUNT_1,
			ORR.DISCOUNT_2,
			ORR.DISCOUNT_3,
			ORR.DISCOUNT_4,
			ORR.DISCOUNT_5,
			ORR.DISCOUNT_6,
			ORR.DISCOUNT_7,
			ORR.DISCOUNT_8,
			ORR.DISCOUNT_9,
			ORR.DISCOUNT_10,
			ORR.OTVTOTAL,
			S.PROPERTY,
			S.STOCK_CODE,
			S.BARCOD,
			S.MANUFACT_CODE,
			S.IS_INVENTORY,
			S.IS_PRODUCTION,
			S.STOCK_CODE_2,
			S.STOCK_ID,
			ORR.QUANTITY,
			EXC.EXPENSE,
			EXI.EXPENSE_ITEM_NAME
		HAVING ORR.QUANTITY - SUM(ISNULL(PR.ROW_IN,0) ) > 0
		ORDER BY 
			ORR.ORDER_ROW_ID ASC
	</cfquery>
	<!--- <cfdump var="#GET_ORDER_PRODUCTS#" abort> --->
<cfelseif isDefined("attributes.pr_order_id") and len(attributes.pr_order_id)>
	<cfquery name="GET_ORDER_PRODUCTS" datasource="#DSN3#">
		SELECT
			PRODUCTION_ORDER_RESULTS_ROW.AMOUNT - SUM(ISNULL(PR.ROW_IN,0) ) AS QUANTITY,
			PRODUCTION_ORDER_RESULTS_ROW.PRODUCT_ID,
			PRODUCTION_ORDER_RESULTS_ROW.STOCK_ID,
			PRODUCTION_ORDER_RESULTS_ROW.AMOUNT2,
			PRODUCTION_ORDER_RESULTS_ROW.UNIT_ID,
			PRODUCTION_ORDER_RESULTS_ROW.UNIT2,
			PRODUCTION_ORDER_RESULTS_ROW.NAME_PRODUCT AS PRODUCT_NAME,
			PRODUCTION_ORDER_RESULTS_ROW.PURCHASE_NET_MONEY OTHER_MONEY_CURRENCY,
			PRODUCTION_ORDER_RESULTS_ROW.PURCHASE_NET OTHER_MONEY,
			PRODUCTION_ORDER_RESULTS_ROW.PURCHASE_NET_TOTAL OTHER_MONEY_TOTAL,
			PRODUCTION_ORDER_RESULTS_ROW.UNIT_NAME AS UNIT,
			'' AS BASKET_EMPLOYEE_ID,
			'' AS ROW_PROJECT_ID,
			'' ROW_WORK_ID,
			'' PAYMETHOD_ID,
			'' UNIQUE_RELATION_ID,
			'' ROW_DELIVER_DATE,
			'' RESERVE_DATE,
			'-1' ORDER_ROW_CURRENCY,
			'-1' RESERVE_TYPE,
			0 PRICE,
			0 PRICE_OTHER,
			0 DISCOUNT_1,
			0 DISCOUNT_2,
			0 DISCOUNT_3,
			0 DISCOUNT_4,
			0 DISCOUNT_5,
			0 DISCOUNT_6,
			0 DISCOUNT_7,
			0 DISCOUNT_8,
			0 DISCOUNT_9,
			0 DISCOUNT_10,
			0 OTVTOTAL,
			0 WIDTH_VALUE,
			0 HEIGHT_VALUE,
			0 DEPTH_VALUE,
			S.TAX,
			S.TAX_PURCHASE,
			S.STOCK_CODE_2,
			S.STOCK_CODE,
			S.IS_INVENTORY,
			S.IS_PRODUCTION
		FROM
			PRODUCTION_ORDER_RESULTS,
			PRODUCTION_ORDER_RESULTS_ROW
			LEFT JOIN #dsn1#.PACKETING_ROW PR ON PRODUCTION_ORDER_RESULTS_ROW.PR_ORDER_ID = PR.P_RESULT_ID AND PR.STOCK_ID = PRODUCTION_ORDER_RESULTS_ROW.STOCK_ID,
			STOCKS S
		WHERE
			PRODUCTION_ORDER_RESULTS.PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#"> AND
			PRODUCTION_ORDER_RESULTS.PR_ORDER_ID = PRODUCTION_ORDER_RESULTS_ROW.PR_ORDER_ID AND
			S.STOCK_ID = PRODUCTION_ORDER_RESULTS_ROW.STOCK_ID AND
			S.IS_INVENTORY = 1 AND
			PRODUCTION_ORDER_RESULTS_ROW.TYPE = 1
		GROUP BY
			PRODUCTION_ORDER_RESULTS_ROW.PRODUCT_ID,
			PRODUCTION_ORDER_RESULTS_ROW.STOCK_ID,
			PRODUCTION_ORDER_RESULTS_ROW.AMOUNT2,
			PRODUCTION_ORDER_RESULTS_ROW.UNIT_ID,
			PRODUCTION_ORDER_RESULTS_ROW.UNIT2,
			PRODUCTION_ORDER_RESULTS_ROW.NAME_PRODUCT,
			PRODUCTION_ORDER_RESULTS_ROW.PURCHASE_NET_MONEY,
			PRODUCTION_ORDER_RESULTS_ROW.PURCHASE_NET,
			PRODUCTION_ORDER_RESULTS_ROW.PURCHASE_NET_TOTAL,
			PRODUCTION_ORDER_RESULTS_ROW.UNIT_NAME,
			PRODUCTION_ORDER_RESULTS_ROW.AMOUNT,
			WIDTH_VALUE,
			HEIGHT_VALUE,
			DEPTH_VALUE,
			S.TAX,
			S.TAX_PURCHASE,
			S.STOCK_CODE_2,
			S.STOCK_CODE,
			S.IS_INVENTORY,
			S.IS_PRODUCTION
			HAVING PRODUCTION_ORDER_RESULTS_ROW.AMOUNT - SUM(ISNULL(PR.ROW_IN,0) ) > 0
	</cfquery>
</cfif>

<cfset basket_emp_id_list=listsort(ListDeleteDuplicates(valuelist(GET_ORDER_PRODUCTS.BASKET_EMPLOYEE_ID)),'numeric','asc',',')>
<cfset row_project_id_list_=listsort(ListDeleteDuplicates(valuelist(GET_ORDER_PRODUCTS.ROW_PROJECT_ID)),'numeric','asc',',')>
<cfset row_work_id_list_=listsort(ListDeleteDuplicates(valuelist(GET_ORDER_PRODUCTS.ROW_WORK_ID)),'numeric','asc',',')>
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
<cfif len(row_work_id_list_)>
	<cfquery name="GET_ROW_WORKS" datasource="#dsn#">
		SELECT WORK_HEAD,WORK_ID FROM PRO_WORKS WHERE WORK_ID IN (#row_work_id_list_#) ORDER BY WORK_ID
	</cfquery>
	<cfset row_work_id_list_=valuelist(GET_ROW_WORKS.WORK_ID)>
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
	sepet.other_money = GET_ORDER_PRODUCTS.OTHER_MONEY;

	for (i = 1; i lte get_order_products.recordcount;i=i+1)
	{
		sepet.satir[i] = StructNew();

		if((isdefined("attributes.event") and attributes.event is 'add') and ( isdefined("attributes.order_id") and Len(attributes.order_id) or isdefined("attributes.pr_order_id") and Len(attributes.pr_order_id) )) //siparis kopyalama
		{
			sepet.satir[i].wrk_row_id="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
			sepet.satir[i].wrk_row_relation_id='';
		}
		else //satış siparisi guncelleme
		{
			sepet.satir[i].wrk_row_relation_id = get_order_products.wrk_row_relation_id[i];
			sepet.satir[i].wrk_row_id=get_order_products.WRK_ROW_ID[i];
		}
		sepet.satir[i].product_id = get_order_products.product_id[i];
		sepet.satir[i].paymethod_id = get_order_products.paymethod_id[i];
		sepet.satir[i].amount = get_order_products.quantity[i];
		sepet.satir[i].unit = get_order_products.unit[i];
		sepet.satir[i].unit_id = get_order_products.unit_id[i];
		sepet.satir[i].price = get_order_products.price[i];
		sepet.satir[i].product_name = get_order_products.PRODUCT_NAME[i];
		if(listfind('-1,-2,-4',get_order_products.RESERVE_TYPE[i])) //rezerve, kapatılmıs rezerve ve kısmı rezerve secenekleri copy siparise rezerve olarak tasınır
			sepet.satir[i].reserve_type = -1;
		else
			sepet.satir[i].reserve_type = -3; //rezerve degil
		sepet.satir[i].reserve_date = dateformat(get_order_products.reserve_date[i],dateformat_style);
		if(len(get_order_products.price_other[i]))
			sepet.satir[i].price_other = get_order_products.price_other[i];
		else
			sepet.satir[i].price_other = get_order_products.price[i];
		sepet.satir[i].tax_percent = get_order_products.tax[i];

		sepet.satir[i].otv_oran = 0;
		sepet.satir[i].catalog_id = 0;
		sepet.satir[i].stock_id = get_order_products.stock_id[i];
		//sepet.satir[i].order_currency = get_order_products.ORDER_ROW_CURRENCY[i]; //satır siparis asaması
		sepet.satir[i].order_currency = -1;
		
		if( len(get_order_products.unique_relation_id[i]) ) sepet.satir[i].row_unique_relation_id = get_order_products.unique_relation_id[i]; else sepet.satir[i].row_unique_relation_id = "";
		if( len(get_order_products.amount2[i]) ) sepet.satir[i].amount_other = get_order_products.amount2[i]; else sepet.satir[i].amount_other = "";
		if( len(get_order_products.unit2[i]) ) sepet.satir[i].unit_other = get_order_products.unit2[i]; else sepet.satir[i].unit_other = "";
		sepet.satir[i].ek_tutar=0;
		sepet.satir[i].ek_tutar_total=0;
		sepet.satir[i].ek_tutar_other_total=0;

		if(len(get_order_products.WIDTH_VALUE[i])) sepet.satir[i].row_width = get_order_products.WIDTH_VALUE[i]; else sepet.satir[i].row_width = '';
		if(len(get_order_products.DEPTH_VALUE[i])) sepet.satir[i].row_depth = get_order_products.DEPTH_VALUE[i]; else  sepet.satir[i].row_depth = '';
		if(len(get_order_products.HEIGHT_VALUE[i])) sepet.satir[i].row_height = get_order_products.HEIGHT_VALUE[i]; else  sepet.satir[i].row_height = '';

		
		if (not len(get_order_products.discount_1[i])) sepet.satir[i].indirim1 = 0; else sepet.satir[i].indirim1 = get_order_products.discount_1[i];
		if (not len(get_order_products.discount_2[i])) sepet.satir[i].indirim2 = 0; else sepet.satir[i].indirim2 = get_order_products.discount_2[i];
		if (not len(get_order_products.discount_3[i])) sepet.satir[i].indirim3 = 0; else sepet.satir[i].indirim3 = get_order_products.discount_3[i];
		if (not len(get_order_products.discount_4[i])) sepet.satir[i].indirim4 = 0; else sepet.satir[i].indirim4 = get_order_products.discount_4[i];
		if (not len(get_order_products.discount_5[i])) sepet.satir[i].indirim5 = 0; else sepet.satir[i].indirim5 = get_order_products.discount_5[i];
		if (not len(get_order_products.discount_6[i])) sepet.satir[i].indirim6 = 0; else sepet.satir[i].indirim6 = get_order_products.discount_6[i];
		if (not len(get_order_products.discount_7[i])) sepet.satir[i].indirim7 = 0; else sepet.satir[i].indirim7 = get_order_products.discount_7[i];
		if (not len(get_order_products.discount_8[i])) sepet.satir[i].indirim8 = 0; else sepet.satir[i].indirim8 = get_order_products.discount_8[i];
		if (not len(get_order_products.discount_9[i])) sepet.satir[i].indirim9 = 0; else sepet.satir[i].indirim9 = get_order_products.discount_9[i];
		if (not len(get_order_products.discount_10[i])) sepet.satir[i].indirim10 = 0; else sepet.satir[i].indirim10 = get_order_products.discount_10[i];
		
		sepet.satir[i].net_maliyet = 0;	
		sepet.satir[i].marj = 0;	
		sepet.satir[i].extra_cost = 0;
		sepet.satir[i].deliver_dept = "";
		sepet.satir[i].other_money = session.ep.money;
		sepet.satir[i].other_money_value = sepet.satir[i].price_other * sepet.satir[i].amount;
	
		sepet.satir[i].special_code = get_order_products.STOCK_CODE_2[i];
		sepet.satir[i].stock_code = get_order_products.stock_code[i];
		sepet.satir[i].is_inventory= get_order_products.is_inventory[i];
		sepet.satir[i].is_production= get_order_products.is_production[i];
		sepet.satir[i].indirim_carpan = (100-sepet.satir[i].indirim1) * (100-sepet.satir[i].indirim2) * (100-sepet.satir[i].indirim3) * (100-sepet.satir[i].indirim4) * (100-sepet.satir[i].indirim5) * (100-sepet.satir[i].indirim6) * (100-sepet.satir[i].indirim7) * (100-sepet.satir[i].indirim8) * (100-sepet.satir[i].indirim9) * (100-sepet.satir[i].indirim10);
		sepet.satir[i].row_total = (sepet.satir[i].amount * sepet.satir[i].price) + sepet.satir[i].ek_tutar_total;
		//sepet.satir[i].row_nettotal = wrk_round((sepet.satir[i].row_total/100000000000000000000) * sepet.satir[i].indirim_carpan);
		sepet.satir[i].row_nettotal = 0;
		sepet.satir[i].row_taxtotal = wrk_round(sepet.satir[i].row_nettotal * (sepet.satir[i].tax_percent/100),price_round_number);
		if(len(get_order_products.OTVTOTAL[i]))
		{ 
			sepet.satir[i].row_otvtotal = get_order_products.OTVTOTAL[i];
			sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal + sepet.satir[i].row_otvtotal;
		}
		else
		{
		 	sepet.satir[i].row_otvtotal = 0;
			sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal;
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
	
	}
	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		sepet.kdv_array[k][2] = wrk_round(sepet.kdv_array[k][3] * sepet.kdv_array[k][1] /100,basket_total_round_number);
	
	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		sepet.total_tax = sepet.total_tax + sepet.kdv_array[k][2];
		
	
	for (t=1;t lte arraylen(sepet.otv_array);t=t+1)
		sepet.total_otv = sepet.total_otv + wrk_round(sepet.otv_array[t][2],price_round_number);
	
	sepet.net_total = sepet.net_total + sepet.total_tax + sepet.total_otv;
</cfscript>
