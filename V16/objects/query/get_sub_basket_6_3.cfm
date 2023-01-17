<cfquery name="GET_ORDER_PRODUCTS" datasource="#DSN3#">
	SELECT
		ORR.*,
		S.PROPERTY,
		S.STOCK_CODE,
		S.BARCOD,
		S.MANUFACT_CODE,
		S.IS_INVENTORY,
		S.IS_PRODUCTION,
		S.STOCK_CODE_2,
		EXC.EXPENSE,
		EXI.EXPENSE_ITEM_NAME
	FROM
		STOCKS S,
		ORDER_ROW ORR
		LEFT JOIN #dsn2#.EXPENSE_CENTER AS EXC ON ORR.EXPENSE_CENTER_ID = EXC.EXPENSE_ID
		LEFT JOIN #dsn2#.EXPENSE_ITEMS AS EXI ON ORR.EXPENSE_ITEM_ID = EXI.EXPENSE_ITEM_ID
	WHERE
		ORR.ORDER_ID = #attributes.ORDER_ID#
		AND ORR.STOCK_ID = S.STOCK_ID
		AND S.PRODUCT_STATUS = 1
		AND S.IS_PURCHASE = 1
	ORDER BY
		ORR.ORDER_ROW_ID
</cfquery>
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
	sepet.other_money = get_order_detail.OTHER_MONEY;
	if (isdefined('get_order_detail.SA_DISCOUNT') and isnumeric(get_order_detail.SA_DISCOUNT))
	{
		sepet.genel_indirim = get_order_detail.SA_DISCOUNT;
	}
	for (i = 1; i lte get_order_products.recordcount;i=i+1)
	{
		sepet.satir[i] = StructNew();

		if((isdefined("attributes.event") and attributes.event is 'add') and isdefined("attributes.order_id") and Len(attributes.order_id)) //siparis kopyalama
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
		if(len(get_order_products.OTV_ORAN[i])) //özel tüketim vergisi
			sepet.satir[i].otv_oran = get_order_products.OTV_ORAN[i];
		else 
			sepet.satir[i].otv_oran = 0;
		sepet.satir[i].catalog_id = 0;
		sepet.satir[i].stock_id = get_order_products.stock_id[i];
		//sepet.satir[i].order_currency = get_order_products.ORDER_ROW_CURRENCY[i]; //satır siparis asaması
		sepet.satir[i].order_currency = -1;
		
		if( len(get_order_products.unique_relation_id[i]) ) sepet.satir[i].row_unique_relation_id = get_order_products.unique_relation_id[i]; else sepet.satir[i].row_unique_relation_id = "";
		if( len(get_order_products.prom_relation_id[i]) ) sepet.satir[i].prom_relation_id = get_order_products.prom_relation_id[i]; else sepet.satir[i].prom_relation_id = "";
		if( len(get_order_products.product_name2[i]) ) sepet.satir[i].product_name_other = get_order_products.product_name2[i]; else sepet.satir[i].product_name_other = "";
		if( len(get_order_products.amount2[i]) ) sepet.satir[i].amount_other = get_order_products.amount2[i]; else sepet.satir[i].amount_other = "";
		if( len(get_order_products.unit2[i]) ) sepet.satir[i].unit_other = get_order_products.unit2[i]; else sepet.satir[i].unit_other = "";
		if( len(get_order_products.extra_price[i]) ) sepet.satir[i].ek_tutar = get_order_products.extra_price[i]; else sepet.satir[i].ek_tutar = 0;
		if( len(get_order_products.extra_price_total[i]) ) sepet.satir[i].ek_tutar_total = get_order_products.extra_price_total[i]; else sepet.satir[i].ek_tutar_total = 0;
		if(len(get_order_products.WIDTH_VALUE[i])) sepet.satir[i].row_width = get_order_products.WIDTH_VALUE[i]; else sepet.satir[i].row_width = '';
		if(len(get_order_products.DEPTH_VALUE[i])) sepet.satir[i].row_depth = get_order_products.DEPTH_VALUE[i]; else  sepet.satir[i].row_depth = '';
		if(len(get_order_products.HEIGHT_VALUE[i])) sepet.satir[i].row_height = get_order_products.HEIGHT_VALUE[i]; else  sepet.satir[i].row_height = '';
		if(len(get_order_products.ROW_PROJECT_ID[i]))
		{
			sepet.satir[i].row_project_id=get_order_products.ROW_PROJECT_ID[i];
			sepet.satir[i].row_project_name=GET_ROW_PROJECTS.PROJECT_HEAD[listfind(row_project_id_list_,get_order_products.ROW_PROJECT_ID[i])];
		}
		if(len(get_order_products.ROW_WORK_ID[i]))
		{
			sepet.satir[i].row_work_id=get_order_products.ROW_WORK_ID[i];
			sepet.satir[i].row_work_name=GET_ROW_WORKS.WORK_HEAD[listfind(row_work_id_list_,get_order_products.ROW_WORK_ID[i])];
		}
		if( len(get_order_products.EXTRA_PRICE_OTHER_TOTAL[i]) ) sepet.satir[i].ek_tutar_other_total = get_order_products.EXTRA_PRICE_OTHER_TOTAL[i]; else sepet.satir[i].ek_tutar_other_total = 0;
		if( len(get_order_products.shelf_number[i]) ) sepet.satir[i].shelf_number = get_order_products.shelf_number[i]; else sepet.satir[i].shelf_number = "";
		if( len(get_order_products.BASKET_EXTRA_INFO_ID[i]) ) sepet.satir[i].basket_extra_info = get_order_products.BASKET_EXTRA_INFO_ID[i]; else sepet.satir[i].basket_extra_info="";
		if( len(get_order_products.SELECT_INFO_EXTRA[i]) ) sepet.satir[i].select_info_extra = get_order_products.SELECT_INFO_EXTRA[i]; else sepet.satir[i].select_info_extra="";
		if( len(get_order_products.DETAIL_INFO_EXTRA[i]) ) sepet.satir[i].detail_info_extra = get_order_products.DETAIL_INFO_EXTRA[i]; else sepet.satir[i].detail_info_extra="";

		
		if( len(get_order_products.DUEDATE[i]) ) sepet.satir[i].duedate = get_order_products.duedate[i]; else sepet.satir[i].duedate = '';
		if( len(get_order_products.LIST_PRICE[i]) ) sepet.satir[i].list_price = get_order_products.LIST_PRICE[i]; else sepet.satir[i].list_price = get_order_products.price[i];
		if( len(get_order_products.PRICE_CAT[i]) ) sepet.satir[i].price_cat = get_order_products.PRICE_CAT[i]; else sepet.satir[i].price_cat = '';
		if( len(get_order_products.NUMBER_OF_INSTALLMENT[i]) ) sepet.satir[i].number_of_installment = get_order_products.NUMBER_OF_INSTALLMENT[i]; else sepet.satir[i].number_of_installment = 0;
		if(len(get_order_products.BASKET_EMPLOYEE_ID[i]))
		{	
			sepet.satir[i].basket_employee_id = get_order_products.BASKET_EMPLOYEE_ID[i]; 
			sepet.satir[i].basket_employee = GET_BASKET_EMPLOYEES.BASKET_EMPLOYEE[listfind(basket_emp_id_list,get_order_products.BASKET_EMPLOYEE_ID[i])]; 
		}
		else
		{		
			sepet.satir[i].basket_employee_id = '';
			sepet.satir[i].basket_employee = '';
		}
		
		if( len(get_order_products.KARMA_PRODUCT_ID[i]) ) sepet.satir[i].karma_product_id = get_order_products.KARMA_PRODUCT_ID[i]; else sepet.satir[i].karma_product_id = '';
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
		if (len(get_order_products.EXTRA_COST[i]))	
			sepet.satir[i].extra_cost = get_order_products.EXTRA_COST[i];
		else
			sepet.satir[i].extra_cost = 0;
		sepet.satir[i].deliver_date = dateformat(get_order_products.deliver_date[i],dateformat_style);
		if(len(trim(get_order_products.deliver_LOCATION[i])))
			sepet.satir[i].deliver_dept = "#get_order_products.deliver_dept[i]#-#get_order_products.deliver_LOCATION[i]#";
		else
			sepet.satir[i].deliver_dept = "#get_order_products.deliver_dept[i]#";
		sepet.satir[i].spect_id = get_order_products.SPECT_VAR_ID[i];
		sepet.satir[i].spect_name = get_order_products.SPECT_VAR_NAME[i];
		sepet.satir[i].other_money = get_order_products.OTHER_MONEY[i];
		sepet.satir[i].other_money_value = get_order_products.OTHER_MONEY_VALUE[i];
		sepet.satir[i].lot_no = get_order_products.LOT_NO[i];
		sepet.satir[i].barcode = get_order_products.barcod[i];
		sepet.satir[i].special_code = get_order_products.STOCK_CODE_2[i];
		sepet.satir[i].stock_code = get_order_products.stock_code[i];
		sepet.satir[i].is_inventory= get_order_products.is_inventory[i];
		sepet.satir[i].is_production= get_order_products.is_production[i];
		sepet.satir[i].manufact_code = get_order_products.PRODUCT_MANUFACT_CODE[i];		
		sepet.satir[i].indirim_carpan = (100-sepet.satir[i].indirim1) * (100-sepet.satir[i].indirim2) * (100-sepet.satir[i].indirim3) * (100-sepet.satir[i].indirim4) * (100-sepet.satir[i].indirim5) * (100-sepet.satir[i].indirim6) * (100-sepet.satir[i].indirim7) * (100-sepet.satir[i].indirim8) * (100-sepet.satir[i].indirim9) * (100-sepet.satir[i].indirim10);
		sepet.satir[i].row_total = (sepet.satir[i].amount * sepet.satir[i].price) + sepet.satir[i].ek_tutar_total;
		//sepet.satir[i].row_nettotal = wrk_round((sepet.satir[i].row_total/100000000000000000000) * sepet.satir[i].indirim_carpan);
		sepet.satir[i].row_nettotal = get_order_products.NETTOTAL[i];
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
		// urun asortileri , 20050322 uretilmeyen urunlerin asortilerine bakmaya gerek yoktu?...
		if(get_order_products.IS_PRODUCTION[i]){
			SQLString = "SELECT * FROM PRODUCTION_ASSORTMENT WHERE ACTION_TYPE=2 AND ASSORTMENT_ID=#get_order_products.ORDER_ROW_ID[i]# ORDER BY PARSE1,PARSE2";
			get_assort = cfquery(SQLString : SQLString, Datasource : DSN3);
			sepet.satir[i].assortment_array = ArrayNew(1);
			for(j = 1 ; j lte get_assort.recordcount ; j=j+1)
				{
				sepet.satir[i].assortment_array[j] = StructNew();
				sepet.satir[i].assortment_array[j].property_id = get_assort.PARSE1[j];
				sepet.satir[i].assortment_array[j].property_detail_id = get_assort.PARSE2[j];
				sepet.satir[i].assortment_array[j].property_amount = get_assort.AMOUNT[j];
				}		
		}
		
		/*Masraf Merkezi*/
		if( len(get_order_products.EXPENSE_CENTER_ID[i]) )
		{
			sepet.satir[i].row_exp_center_id = get_order_products.EXPENSE_CENTER_ID[i];
			sepet.satir[i].row_exp_center_name = get_order_products.EXPENSE[i];
		}

		//Aktivite Tipi
		sepet.satir[i].row_activity_id = get_order_products.ACTIVITY_TYPE_ID[i];

		//Bütçe Kalemi
		if( len(get_order_products.EXPENSE_ITEM_ID[i]) )
		{
			sepet.satir[i].row_exp_item_id = get_order_products.EXPENSE_ITEM_ID[i];
			sepet.satir[i].row_exp_item_name = get_order_products.EXPENSE_ITEM_NAME[i];
		}

		//Muhasebe Kodu
		if(len(get_order_products.ACC_CODE[i]))
		{
			sepet.satir[i].row_acc_code = get_order_products.ACC_CODE[i];
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
