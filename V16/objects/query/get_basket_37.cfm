<cfquery name="GET_ORDER_PRODUCTS" datasource="#dsn3#">
	SELECT
		ORDER_ROW.PRODUCT_ID,
		ORDER_ROW.PRODUCT_NAME,
		ORDER_ROW.PAYMETHOD_ID,
		ORDER_ROW.UNIT_ID,
		ORDER_ROW.UNIT,
		ORDER_ROW.PRICE,
		ORDER_ROW.PRICE_OTHER,
		ORDER_ROW.STOCK_ID,
		ORDER_ROW.DUEDATE,
		ORDER_ROW.DISCOUNT_1,
		ORDER_ROW.DISCOUNT_2,
		ORDER_ROW.DISCOUNT_3,
		ORDER_ROW.DISCOUNT_4,
		ORDER_ROW.DISCOUNT_5,
		ORDER_ROW.DISCOUNT_6,
		ORDER_ROW.DISCOUNT_7,
		ORDER_ROW.DISCOUNT_8,
		ORDER_ROW.DISCOUNT_9,
		ORDER_ROW.DISCOUNT_10,
		ORDER_ROW.DELIVER_DATE,
		ORDER_ROW.SPECT_VAR_ID,
		ORDER_ROW.SPECT_VAR_NAME,
		ORDER_ROW.OTHER_MONEY,				
		ORDER_ROW.OTHER_MONEY_VALUE,
		ORDER_ROW.LOT_NO,
		ORDER_ROW.TAX,		
		ORDER_ROW.NETTOTAL,
		ORDER_ROW.ORDER_ROW_ID,	
		ORDER_ROW.EXTRA_COST,
		ORDER_ROW.UNIQUE_RELATION_ID,
		ORDER_ROW.PRODUCT_NAME2,
		ORDER_ROW.AMOUNT2,
		ORDER_ROW.UNIT2,
		ORDER_ROW.EXTRA_PRICE,
		ORDER_ROW.EXTRA_PRICE_TOTAL,
		ORDER_ROW.EXTRA_PRICE_OTHER_TOTAL,
		ORDER_ROW.SHELF_NUMBER,
		ORDER_ROW.PRODUCT_MANUFACT_CODE,
		ORDER_ROW.DELIVER_LOCATION,
		ORDER_ROW.OTV_ORAN,
		ORDER_ROW.OTVTOTAL,
		ORDER_ROW.BASKET_EXTRA_INFO_ID,
		ORDER_ROW.SELECT_INFO_EXTRA,
		ORDER_ROW.DETAIL_INFO_EXTRA,
		ODR.DEPARTMENT_ID AS DELIVER_DEPT,
		ODR.LOCATION_ID,
		ODR.AMOUNT AS QUANTITY
	FROM 
		ORDERS,
		ORDER_ROW,
		ORDER_ROW_DEPARTMENTS ODR 
	WHERE
		ODR.ORDER_ROW_ID = ORDER_ROW.ORDER_ROW_ID 
		AND ORDERS.ORDER_ID = ORDER_ROW.ORDER_ID
		AND ORDER_ROW.ORDER_ROW_CURRENCY IN (-6,-7)
		<cfif isdefined("order_row_list") and len(order_row_list)>
			AND ODR.ORDER_ROW_ID IN (#order_row_list#)
		</cfif>
		<cfif isdefined("url.deliver_dept") and len(url.deliver_dept)>
			AND ODR.DEPARTMENT_ID = #url.deliver_dept#
		</cfif>
		<cfif isdefined("attributes.deliverdate") and len(attributes.deliverdate)>
			AND ORDERS.DELIVERDATE = #attributes.deliverdate#
		</cfif>				
		AND ORDER_ROW.ORDER_ID = #attributes.order_id#
</cfquery>
<!---  <input type="hidden" name="ship_order_row_list" value="<cfoutput>#ValueList(GET_ORDER_PRODUCTS.ORDER_ROW_ID)#</cfoutput>"> --->
<cfset row_project_id_list_=listsort(ListDeleteDuplicates(valuelist(GET_ORDER_PRODUCTS.ROW_PROJECT_ID)),'numeric','asc',',')>
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
	sepet.genel_indirim=0;
	
	for (i = 1; i lte get_order_products.recordcount;i=i+1)
		{
		sepet.satir[i] = StructNew();
		
		sepet.satir[i].wrk_row_id ="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
		sepet.satir[i].wrk_row_relation_id = '';
		
		sepet.satir[i].product_id = get_order_products.product_id[i];
		sepet.satir[i].product_name = get_order_products.product_name[i];
		sepet.satir[i].paymethod_id = get_order_products.paymethod_id[i];
		sepet.satir[i].amount = get_order_products.quantity[i];
		sepet.satir[i].unit = get_order_products.unit[i];
		sepet.satir[i].unit_id = get_order_products.unit_id[i];
		sepet.satir[i].price = get_order_products.price[i];
		if(len(get_order_products.price_other[i]))
			sepet.satir[i].price_other = get_order_products.price_other[i];
		else
			sepet.satir[i].price_other = get_order_products.price[i];
		sepet.satir[i].tax_percent = get_order_products.tax[i];
		if(len(get_order_products.otv_oran[i])) sepet.satir[i].otv_oran = get_order_products.otv_oran[i]; else sepet.satir[i].otv_oran = 0;
		sepet.satir[i].catalog_id = 0;
		sepet.satir[i].stock_id = get_order_products.stock_id[i];
		sepet.satir[i].duedate = get_order_products.duedate[i];
		if( len(get_order_products.UNIQUE_RELATION_ID[i]) ) sepet.satir[i].row_unique_relation_id = get_order_products.UNIQUE_RELATION_ID[i]; else sepet.satir[i].row_unique_relation_id = "";
		if( len(get_order_products.PRODUCT_NAME2[i]) ) sepet.satir[i].product_name_other = get_order_products.PRODUCT_NAME2[i]; else sepet.satir[i].product_name_other = "";
		if( len(get_order_products.AMOUNT2[i]) ) sepet.satir[i].amount_other = get_order_products.AMOUNT2[i]; else sepet.satir[i].amount_other = "";
		if( len(get_order_products.UNIT2[i]) ) sepet.satir[i].unit_other = get_order_products.UNIT2[i]; else sepet.satir[i].unit_other = "";
		if( len(get_order_products.EXTRA_PRICE[i]) ) sepet.satir[i].ek_tutar = get_order_products.EXTRA_PRICE[i]; else sepet.satir[i].ek_tutar = "";
		if( len(get_order_products.EXTRA_PRICE_TOTAL[i]) ) sepet.satir[i].ek_tutar_total = get_order_products.EXTRA_PRICE_TOTAL[i]; else sepet.satir[i].ek_tutar_total = "";
		if( len(get_order_products.EXTRA_PRICE_OTHER_TOTAL[i]) ) sepet.satir[i].ek_tutar_other_total = get_order_products.EXTRA_PRICE_OTHER_TOTAL[i]; else sepet.satir[i].ek_tutar_other_total = 0;
		if( len(get_order_products.SHELF_NUMBER[i]) ) sepet.satir[i].shelf_number = get_order_products.SHELF_NUMBER[i]; else sepet.satir[i].shelf_number = "";
		if( len(get_order_products.BASKET_EXTRA_INFO_ID[i]) ) sepet.satir[i].basket_extra_info = get_order_products.BASKET_EXTRA_INFO_ID[i]; else sepet.satir[i].basket_extra_info="";
		if( len(get_order_products.SELECT_INFO_EXTRA[i])) sepet.satir[i].select_info_extra = get_order_products.SELECT_INFO_EXTRA[i]; else sepet.satir[i].select_info_extra="";
		if( len(get_order_products.DETAIL_INFO_EXTRA[i])) sepet.satir[i].detail_info_extra = get_order_products.DETAIL_INFO_EXTRA[i]; else sepet.satir[i].detail_info_extra="";

		if(len(get_order_products.WIDTH_VALUE[i])) sepet.satir[i].row_width = get_order_products.WIDTH_VALUE[i]; else sepet.satir[i].row_width = '';
		if(len(get_order_products.DEPTH_VALUE[i])) sepet.satir[i].row_depth = get_order_products.DEPTH_VALUE[i]; else  sepet.satir[i].row_depth = '';
		if(len(get_order_products.HEIGHT_VALUE[i])) sepet.satir[i].row_height = get_order_products.HEIGHT_VALUE[i]; else  sepet.satir[i].row_height = '';
		if(len(get_order_products.ROW_PROJECT_ID[i]))
		{
			sepet.satir[i].row_project_id=get_order_products.ROW_PROJECT_ID[i];
			sepet.satir[i].row_project_name=GET_ROW_PROJECTS.PROJECT_HEAD[listfind(row_project_id_list_,get_order_products.ROW_PROJECT_ID[i])];
		}
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
		sepet.satir[i].indirim_carpan = (100-sepet.satir[i].indirim1) * (100-sepet.satir[i].indirim2) * (100-sepet.satir[i].indirim3) * (100-sepet.satir[i].indirim4) * (100-sepet.satir[i].indirim5) * (100-sepet.satir[i].indirim6) * (100-sepet.satir[i].indirim7) * (100-sepet.satir[i].indirim8) * (100-sepet.satir[i].indirim9) * (100-sepet.satir[i].indirim10);
		sepet.satir[i].net_maliyet = 0;	
		sepet.satir[i].marj = 0;		
		if(len(get_order_products.extra_cost[i]))
			sepet.satir[i].extra_cost = get_order_products.extra_cost[i];
		else
			sepet.satir[i].extra_cost =0;
		sepet.satir[i].deliver_date = dateformat(get_order_products.deliver_date[i],dateformat_style);
		if(len(trim(get_order_products.deliver_LOCATION[i]))){
			sepet.satir[i].deliver_dept = "#get_order_products.deliver_dept[i]#-#get_order_products.deliver_LOCATION[i]#";
		}else{
			sepet.satir[i].deliver_dept = "#get_order_products.deliver_dept[i]#";
		}
		sepet.satir[i].spect_id = get_order_products.SPECT_VAR_ID[i];
		sepet.satir[i].spect_name = get_order_products.SPECT_VAR_NAME[i];
		sepet.satir[i].other_money = get_order_products.OTHER_MONEY[i];
		sepet.satir[i].other_money_value = get_order_products.OTHER_MONEY_VALUE[i];
		sepet.satir[i].lot_no = get_order_products.LOT_NO[i];
		SQLString = "SELECT STOCK_CODE,STOCK_CODE_2, BARCOD, IS_SERIAL_NO, IS_INVENTORY, IS_PRODUCTION, MANUFACT_CODE FROM STOCKS WHERE STOCK_ID = #get_order_products.stock_id[i]#";
		get_stock_name = cfquery(SQLString : SQLString, Datasource : DSN3);
		sepet.satir[i].barcode = get_stock_name.barcod;
		sepet.satir[i].special_code = get_stock_name.STOCK_CODE_2;
		sepet.satir[i].stock_code = get_stock_name.stock_code;
		sepet.satir[i].manufact_code = get_order_products.PRODUCT_MANUFACT_CODE[i];
		sepet.satir[i].is_inventory = get_stock_name.is_inventory;
		sepet.satir[i].is_production = get_stock_name.is_production;
		sepet.satir[i].row_total = (sepet.satir[i].amount * sepet.satir[i].price) + sepet.satir[i].ek_tutar_total;
		//sepet.satir[i].row_nettotal = wrk_round((sepet.satir[i].row_total/100000000000000000000) * sepet.satir[i].indirim_carpan); OZDEN01042006
		sepet.satir[i].row_nettotal =get_order_products.NETTOTAL[i];
		sepet.satir[i].row_taxtotal = wrk_round(sepet.satir[i].row_nettotal * (sepet.satir[i].tax_percent/100),price_round_number);
		if(len(get_order_products.OTVTOTAL[i]))
		{ 
			sepet.satir[i].row_otvtotal =get_order_products.OTVTOTAL[i];
			sepet.satir[i].row_lasttotal =  sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal + sepet.satir[i].row_otvtotal;
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
		// urun asortileri 
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

	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		sepet.kdv_array[k][2] = wrk_round(sepet.kdv_array[k][3] * sepet.kdv_array[k][1] /100,basket_total_round_number);
	
	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		sepet.total_tax = sepet.total_tax + sepet.kdv_array[k][2];
		
	
	for (t=1;t lte arraylen(sepet.otv_array);t=t+1)
		sepet.total_otv = sepet.total_otv + wrk_round(sepet.otv_array[t][2],price_round_number);
	
	sepet.net_total = sepet.net_total + sepet.total_tax + sepet.total_otv;
</cfscript>
