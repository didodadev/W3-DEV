<cfif isdefined("for_offer_stock_id")><!--- FBS eger teklif detayindan satir bazinda urun cekiliyorsa --->
	<cfset offer_wrk_row_id_ = "">
	<cfset offer_stock_id_ = "">
	<cfloop list="#for_offer_stock_id#" index="x">
		<cfset offer_wrk_row_id_ = listappend(offer_wrk_row_id_,listlast(x,"-"),",")>
		<cfset offer_stock_id_ = listappend(offer_stock_id_,listfirst(x,"-"),",")>
	</cfloop>
</cfif>
<cfquery name="GET_OFFER_PRODUCTS" datasource="#DSN3#">
	SELECT
		OFFER_ROW.*,
		EXC.EXPENSE,
		EXI.EXPENSE_ITEM_NAME
	FROM 
		OFFER_ROW
		LEFT JOIN #dsn2#.EXPENSE_CENTER AS EXC ON OFFER_ROW.EXPENSE_CENTER_ID = EXC.EXPENSE_ID
		LEFT JOIN #dsn2#.EXPENSE_ITEMS AS EXI ON OFFER_ROW.EXPENSE_ITEM_ID = EXI.EXPENSE_ITEM_ID
	WHERE
		OFFER_ID = #attributes.offer_id#
		<cfif isdefined("for_offer_stock_id")>
			<cfif listlen(offer_wrk_row_id_)>
				AND WRK_ROW_RELATION_ID IN (#listqualify(offer_wrk_row_id_,"'")#)
			</cfif>
			<cfif listlen(offer_stock_id_)>
				AND STOCK_ID IN (#offer_stock_id_#)
			</cfif>
		</cfif>
	ORDER BY
		OFFER_ROW_ID
</cfquery>
<cfset basket_emp_id_list=listsort(ListDeleteDuplicates(valuelist(GET_OFFER_PRODUCTS.BASKET_EMPLOYEE_ID)),'numeric','asc',',')>
<cfset row_project_id_list_=listsort(ListDeleteDuplicates(valuelist(GET_OFFER_PRODUCTS.ROW_PROJECT_ID)),'numeric','asc',',')>
<cfset row_work_id_list_=listsort(ListDeleteDuplicates(valuelist(GET_OFFER_PRODUCTS.ROW_WORK_ID)),'numeric','asc',',')>
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
	sepet.other_money = GET_OFFER_DETAIL.OTHER_MONEY;
	if (isdefined('GET_OFFER_DETAIL.SA_DISCOUNT') and isnumeric(GET_OFFER_DETAIL.SA_DISCOUNT))
	{
		sepet.genel_indirim = GET_OFFER_DETAIL.SA_DISCOUNT;
	}
	for (i = 1; i lte get_offer_products.recordcount;i=i+1)
		{
		sepet.satir[i] = StructNew();
	
		if(len(get_offer_products.wrk_row_id[i])) //teklif icin
			sepet.satir[i].wrk_row_id =get_offer_products.wrk_row_id[i];
		if(isdefined('add_order_from_offer_') and len(add_order_from_offer_)) //tekliften siparis olusturulacaksa
		{
			sepet.satir[i].wrk_row_id="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
			sepet.satir[i].wrk_row_relation_id =get_offer_products.wrk_row_id[i];
			sepet.satir[i].related_action_id=get_offer_products.offer_id[i];
			sepet.satir[i].related_action_table='OFFER';
		}
		 //satir bazinda secilerek tekliften siparis olusturulacaksa veya tekliften iliskili teklif olusturuluyorsa
		else if(isdefined('for_offer_stock_id') and len(for_offer_stock_id) or (isdefined('for_offer_id') and len(for_offer_id)))
		{
			sepet.satir[i].wrk_row_id="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
			sepet.satir[i].wrk_row_relation_id =get_offer_products.wrk_row_id[i];
			sepet.satir[i].related_action_id=get_offer_products.offer_id[i];
			sepet.satir[i].related_action_table='OFFER';
		}
		else if((isdefined("attributes.event") and attributes.event is 'add') and isdefined("attributes.offer_id") and len(attributes.offer_id)) //teklif kopyalama findnocase('copy',fusebox.fuseaction)
		{
			sepet.satir[i].wrk_row_id="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
			sepet.satir[i].wrk_row_relation_id='';
			sepet.satir[i].related_action_id='';
			sepet.satir[i].related_action_table='';
		}
		else //teklif detay
		{
			sepet.satir[i].wrk_row_relation_id = get_offer_products.wrk_row_relation_id[i];
			sepet.satir[i].wrk_row_id=get_offer_products.WRK_ROW_ID[i];
			sepet.satir[i].related_action_id=get_offer_products.RELATED_ACTION_ID[i];
			sepet.satir[i].related_action_table=get_offer_products.RELATED_ACTION_TABLE[i];
		}
		if(len(GET_OFFER_PRODUCTS.BASKET_EMPLOYEE_ID[i]))
		{	
			sepet.satir[i].basket_employee_id = GET_OFFER_PRODUCTS.BASKET_EMPLOYEE_ID[i]; 
			sepet.satir[i].basket_employee = GET_BASKET_EMPLOYEES.BASKET_EMPLOYEE[listfind(basket_emp_id_list,GET_OFFER_PRODUCTS.BASKET_EMPLOYEE_ID[i])]; 
		}
		else
		{		
			sepet.satir[i].basket_employee_id = '';
			sepet.satir[i].basket_employee = '';
		}
		sepet.satir[i].product_id = get_offer_products.product_id[i];
		sepet.satir[i].product_name = get_offer_products.product_name[i];
		sepet.satir[i].paymethod_id = get_offer_products.pay_method_id[i];
		sepet.satir[i].amount = get_offer_products.quantity[i];
		sepet.satir[i].unit = get_offer_products.unit[i];
		sepet.satir[i].unit_id = get_offer_products.unit_id[i];		
		
		if( len(get_offer_products.unique_relation_id[i]) ) sepet.satir[i].row_unique_relation_id = get_offer_products.unique_relation_id[i]; else sepet.satir[i].row_unique_relation_id = "";
		if(isdefined('attributes.type') and type eq 1)
			sepet.satir[i].product_name_other="#evaluate("attributes.brfiyat2#i#")#";
		else
		{
			if( len(get_offer_products.product_name2[i]) ) sepet.satir[i].product_name_other = get_offer_products.product_name2[i]; else sepet.satir[i].product_name_other = "";
		}
		if(isdefined('attributes.type') and type eq 1)
		{
			sepet.satir[i].amount_other="#evaluate("attributes.miktar2#i#")#";
			sepet.satir[i].unit_other="#evaluate("attributes.add_unit2#i#")#";
		}
		else
		{
			if( len(get_offer_products.amount2[i]) ) sepet.satir[i].amount_other = get_offer_products.amount2[i]; else sepet.satir[i].amount_other = "";
			if( len(get_offer_products.unit2[i]) ) sepet.satir[i].unit_other = get_offer_products.unit2[i]; else sepet.satir[i].unit_other = "";
		}
		if( len(get_offer_products.extra_price[i]) ) sepet.satir[i].ek_tutar = get_offer_products.extra_price[i]; else sepet.satir[i].ek_tutar = 0;
		if(len(get_offer_products.WIDTH_VALUE[i])) sepet.satir[i].row_width = get_offer_products.WIDTH_VALUE[i]; else sepet.satir[i].row_width = '';
		if(len(get_offer_products.DEPTH_VALUE[i])) sepet.satir[i].row_depth = get_offer_products.DEPTH_VALUE[i]; else  sepet.satir[i].row_depth = '';
		if(len(get_offer_products.HEIGHT_VALUE[i])) sepet.satir[i].row_height = get_offer_products.HEIGHT_VALUE[i]; else  sepet.satir[i].row_height = '';
		if(len(get_offer_products.ROW_PROJECT_ID[i]))
		{
			sepet.satir[i].row_project_id=get_offer_products.ROW_PROJECT_ID[i];
			sepet.satir[i].row_project_name=GET_ROW_PROJECTS.PROJECT_HEAD[listfind(row_project_id_list_,get_offer_products.ROW_PROJECT_ID[i])];
		}
		if(len(get_offer_products.ROW_WORK_ID[i]))
		{
			sepet.satir[i].row_work_id=get_offer_products.ROW_WORK_ID[i];
			sepet.satir[i].row_work_name=GET_ROW_WORKS.WORK_HEAD[listfind(row_work_id_list_,get_offer_products.ROW_WORK_ID[i])];
		}
		if(len(get_offer_products.ek_tutar_price[i]))
		{
			sepet.satir[i].ek_tutar_price = get_offer_products.ek_tutar_price[i];
			if(len(get_offer_products.amount2[i])) sepet.satir[i].ek_tutar_cost = get_offer_products.ek_tutar_price[i]*get_offer_products.amount2[i]; else sepet.satir[i].ek_tutar_cost = get_offer_products.ek_tutar_price[i];
		}
		else
		{ sepet.satir[i].ek_tutar_price = 0;sepet.satir[i].ek_tutar_cost =0;}
		
		
		if(len(sepet.satir[i].ek_tutar_cost) and sepet.satir[i].ek_tutar_cost neq 0)
			sepet.satir[i].ek_tutar_marj = (sepet.satir[i].ek_tutar*100/sepet.satir[i].ek_tutar_cost)-100;
		else
			sepet.satir[i].ek_tutar_marj ='';
		if( len(get_offer_products.extra_price_total[i]) ) sepet.satir[i].ek_tutar_total = get_offer_products.extra_price_total[i]; else sepet.satir[i].ek_tutar_total = 0;
		if( len(get_offer_products.EXTRA_PRICE_OTHER_TOTAL[i]) ) sepet.satir[i].ek_tutar_other_total = get_offer_products.EXTRA_PRICE_OTHER_TOTAL[i]; else sepet.satir[i].ek_tutar_other_total = 0;
		if( len(get_offer_products.shelf_number[i]) ) sepet.satir[i].shelf_number = get_offer_products.shelf_number[i]; else sepet.satir[i].shelf_number = "";
		if( len(get_offer_products.BASKET_EXTRA_INFO_ID[i]) ) sepet.satir[i].basket_extra_info = get_offer_products.BASKET_EXTRA_INFO_ID[i]; else sepet.satir[i].basket_extra_info="";
		if( len(get_offer_products.SELECT_INFO_EXTRA[i]) ) sepet.satir[i].select_info_extra = get_offer_products.SELECT_INFO_EXTRA[i]; else sepet.satir[i].select_info_extra="";
		if( len(get_offer_products.DETAIL_INFO_EXTRA[i]) ) sepet.satir[i].detail_info_extra = get_offer_products.DETAIL_INFO_EXTRA[i]; else sepet.satir[i].detail_info_extra="";
		
		if(isdefined('attributes.type') and type eq 1)
		{
			sepet.satir[i].price_other="#evaluate("attributes.brfiyat1#i#")#";
			sepet.satir[i].price = "#evaluate("attributes.brfiyattl1#i#")#";
		}
		else
		{
			if(len(get_offer_products.price_other[i]))
				sepet.satir[i].price_other = get_offer_products.price_other[i];		
			else
				sepet.satir[i].price_other = get_offer_products.price[i];
			sepet.satir[i].price = get_offer_products.price[i];
		}
		sepet.satir[i].tax_percent = get_offer_products.tax[i];
		if(len(get_offer_products.OTV_ORAN[i])) //özel tüketim vergisi
			sepet.satir[i].otv_oran = get_offer_products.OTV_ORAN[i];
		else 
			sepet.satir[i].otv_oran = 0;
		if (not len(get_offer_products.discount_1[i])) sepet.satir[i].indirim1 = 0; else sepet.satir[i].indirim1 = get_offer_products.discount_1[i];
		if (not len(get_offer_products.discount_2[i])) sepet.satir[i].indirim2 = 0; else sepet.satir[i].indirim2 = get_offer_products.discount_2[i];
		if (not len(get_offer_products.discount_3[i])) sepet.satir[i].indirim3 = 0; else sepet.satir[i].indirim3 = get_offer_products.discount_3[i];
		if (not len(get_offer_products.discount_4[i])) sepet.satir[i].indirim4 = 0; else sepet.satir[i].indirim4 = get_offer_products.discount_4[i];
		if (not len(get_offer_products.discount_5[i])) sepet.satir[i].indirim5 = 0; else sepet.satir[i].indirim5 = get_offer_products.discount_5[i];
		if (not len(get_offer_products.discount_6[i])) sepet.satir[i].indirim6 = 0; else sepet.satir[i].indirim6 = get_offer_products.discount_6[i];
		if (not len(get_offer_products.discount_7[i])) sepet.satir[i].indirim7 = 0; else sepet.satir[i].indirim7 = get_offer_products.discount_7[i];
		if (not len(get_offer_products.discount_8[i])) sepet.satir[i].indirim8 = 0; else sepet.satir[i].indirim8 = get_offer_products.discount_8[i];
		if (not len(get_offer_products.discount_9[i])) sepet.satir[i].indirim9 = 0; else sepet.satir[i].indirim9 = get_offer_products.discount_9[i];
		if (not len(get_offer_products.discount_10[i])) sepet.satir[i].indirim10 = 0; else sepet.satir[i].indirim10 = get_offer_products.discount_10[i];
		if (not len(get_offer_products.discount_cost[i])) sepet.satir[i].iskonto_tutar = 0; else sepet.satir[i].iskonto_tutar = get_offer_products.discount_cost[i];	
		sepet.satir[i].net_maliyet = get_offer_products.NET_MALIYET[i];	
		sepet.satir[i].marj = get_offer_products.MARJ[i];
		sepet.satir[i].indirim_carpan = (100-sepet.satir[i].indirim1) * (100-sepet.satir[i].indirim2) * (100-sepet.satir[i].indirim3) * (100-sepet.satir[i].indirim4) * (100-sepet.satir[i].indirim5) * (100-sepet.satir[i].indirim6) * (100-sepet.satir[i].indirim7) * (100-sepet.satir[i].indirim8) * (100-sepet.satir[i].indirim9) * (100-sepet.satir[i].indirim10);
		sepet.satir[i].catalog_id = 0;
		sepet.satir[i].stock_id = get_offer_products.stock_id[i];
		sepet.satir[i].duedate = get_offer_products.duedate[i];
		sepet.satir[i].deliver_date = dateformat(get_offer_products.deliver_date[i],dateformat_style);
		sepet.satir[i].deliver_dept = "#get_offer_products.deliver_dept[i]#-#get_offer_products.deliver_LOCATION[i]#";
		sepet.satir[i].spect_id = get_offer_products.spect_var_id[i];
		sepet.satir[i].spect_name = get_offer_products.spect_var_name[i];
		if(isdefined('attributes.type') and type eq 1)
			sepet.satir[i].other_money=listgetat(evaluate("attributes.main_money#i#"),1,';');
		else
		{
			sepet.satir[i].other_money = get_offer_products.other_money[i];
		}
		sepet.satir[i].other_money_value = get_offer_products.price_other[i];	
		sepet.satir[i].other_money_value = get_offer_products.OTHER_MONEY_VALUE[i];
		sepet.satir[i].lot_no = "";
		SQLString = "
			SELECT
				STOCK_CODE,
				BARCOD,
				MANUFACT_CODE,
				IS_INVENTORY,
				IS_PRODUCTION,
				STOCK_CODE_2
			FROM
				STOCKS
			WHERE
				STOCK_ID = #get_offer_products.stock_id[i]#";
		get_stock_name = cfquery(SQLString : SQLString, Datasource : DSN3);
		sepet.satir[i].manufact_code = get_offer_products.PRODUCT_MANUFACT_CODE[i];
		sepet.satir[i].special_code = get_stock_name.STOCK_CODE_2;
		sepet.satir[i].barcode = get_stock_name.barcod;
		sepet.satir[i].stock_code = get_stock_name.stock_code;
		sepet.satir[i].is_inventory= get_stock_name.is_inventory;
		sepet.satir[i].is_production= get_stock_name.is_production;
		sepet.satir[i].row_total =((sepet.satir[i].amount * sepet.satir[i].price) + sepet.satir[i].ek_tutar_total);
		sepet.satir[i].row_nettotal = wrk_round((sepet.satir[i].row_total/100000000000000000000) * sepet.satir[i].indirim_carpan,price_round_number);
		
		if(len(sepet.satir[i].iskonto_tutar) and get_money_bskt.recordcount)
			for(k=1;k lte get_money_bskt.recordcount;k=k+1)
				if(sepet.satir[i].other_money eq get_money_bskt.MONEY_TYPE[k])
					sepet.satir[i].row_nettotal = sepet.satir[i].row_nettotal - (sepet.satir[i].iskonto_tutar * get_money_bskt.RATE2[k] / get_money_bskt.RATE1[k] * sepet.satir[i].amount);
		sepet.satir[i].row_taxtotal = wrk_round((sepet.satir[i].row_nettotal * (sepet.satir[i].tax_percent/100)),price_round_number);

		if(len(get_offer_products.OTVTOTAL[i]))
		{ 
			sepet.satir[i].row_otvtotal = get_offer_products.OTVTOTAL[i];
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
		
		if(len(get_offer_products.LIST_PRICE[i])) sepet.satir[i].list_price = get_offer_products.LIST_PRICE[i]; else sepet.satir[i].list_price = get_offer_products.PRICE[i];
		if(len(get_offer_products.PRICE_CAT[i])) sepet.satir[i].price_cat = get_offer_products.PRICE_CAT[i]; else  sepet.satir[i].price_cat = '';
		if(len(get_offer_products.CATALOG_ID[i])) sepet.satir[i].row_catalog_id = get_offer_products.CATALOG_ID[i]; else  sepet.satir[i].row_catalog_id = '';
		if(len(get_offer_products.NUMBER_OF_INSTALLMENT[i])) sepet.satir[i].number_of_installment = get_offer_products.NUMBER_OF_INSTALLMENT[i]; else sepet.satir[i].number_of_installment = 0;

		/* urun asortileri */
		SQLString = "SELECT * FROM PRODUCTION_ASSORTMENT WHERE ACTION_TYPE = 1 AND ASSORTMENT_ID = #get_offer_products.OFFER_ROW_ID[i]# ORDER BY PARSE1,PARSE2";
		get_assort = cfquery(SQLString : SQLString, Datasource : DSN3);

		sepet.satir[i].assortment_array = ArrayNew(1);
		for(j = 1 ; j lte get_assort.recordcount ; j=j+1)
			{
			sepet.satir[i].assortment_array[j] = StructNew();
			sepet.satir[i].assortment_array[j].property_id = get_assort.PARSE1[j];
			sepet.satir[i].assortment_array[j].property_detail_id = get_assort.PARSE2[j];
			sepet.satir[i].assortment_array[j].property_amount = get_assort.AMOUNT[j];
			}		
		// urun departman dagilimi
		SQLString = "SELECT * FROM OFFER_ROW_DEPARTMENTS WHERE OFFER_ROW_ID = #get_offer_products.offer_row_id[i]#";
		get_departman_products = cfquery(SQLString : SQLString, Datasource : DSN3);
		sepet.satir[i].department_array = ArrayNew(1);
		for(j = 1 ; j lte get_departman_products.recordcount ; j=j+1)
			{
				sepet.satir[i].department_array[j] = StructNew();
				sepet.satir[i].department_array[j].AMOUNT = get_departman_products.AMOUNT[j];
				sepet.satir[i].department_array[j].DEPARTMENT_ID = get_departman_products.DEPARTMENT_ID[j];
				sepet.satir[i].department_array[j].LOCATION_ID = get_departman_products.LOCATION_ID[j];
			}
		sepet.satir[i].lot_no = "";

		/*Masraf Merkezi*/
		if( len(get_offer_products.EXPENSE_CENTER_ID[i]) )
		{
			sepet.satir[i].row_exp_center_id = get_offer_products.EXPENSE_CENTER_ID[i];
			sepet.satir[i].row_exp_center_name = get_offer_products.EXPENSE[i];
		}

		//Aktivite Tipi
		sepet.satir[i].row_activity_id = get_offer_products.ACTIVITY_TYPE_ID[i];

		//Bütçe Kalemi
		if( len(get_offer_products.EXPENSE_ITEM_ID[i]) )
		{
			sepet.satir[i].row_exp_item_id = get_offer_products.EXPENSE_ITEM_ID[i];
			sepet.satir[i].row_exp_item_name = get_offer_products.EXPENSE_ITEM_NAME[i];
		}

		//Muhasebe Kodu
		if(len(get_offer_products.ACC_CODE[i]))
		{
			sepet.satir[i].row_acc_code = get_offer_products.ACC_CODE[i];
		}

		sepet.satir[i].row_oiv_rate = ( len( get_offer_products.OIV_RATE ) ) ? get_offer_products.OIV_RATE : '';
		sepet.satir[i].row_oiv_amount = ( len( get_offer_products.OIV_AMOUNT ) ) ? get_offer_products.OIV_AMOUNT : '';
		sepet.satir[i].row_bsmv_rate = ( len( get_offer_products.BSMV_RATE ) ) ? get_offer_products.BSMV_RATE : '';
		sepet.satir[i].row_bsmv_amount = ( len( get_offer_products.BSMV_AMOUNT ) ) ? get_offer_products.BSMV_AMOUNT : '';
		sepet.satir[i].row_bsmv_currency = ( len( get_offer_products.BSMV_CURRENCY ) ) ? get_offer_products.BSMV_CURRENCY : '';
		sepet.satir[i].row_tevkifat_rate = ( len( get_offer_products.TEVKIFAT_RATE ) ) ? get_offer_products.TEVKIFAT_RATE : '';
		sepet.satir[i].row_tevkifat_amount = ( len( get_offer_products.TEVKIFAT_AMOUNT ) ) ? get_offer_products.TEVKIFAT_AMOUNT : '';
	}
	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		sepet.kdv_array[k][2] = wrk_round(sepet.kdv_array[k][3] * sepet.kdv_array[k][1] /100,basket_total_round_number);
	
	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		sepet.total_tax = sepet.total_tax + sepet.kdv_array[k][2];
		
	
	for (t=1;t lte arraylen(sepet.otv_array);t=t+1)
		sepet.total_otv = sepet.total_otv + wrk_round(sepet.otv_array[t][2],price_round_number);
		
	sepet.net_total = sepet.net_total + sepet.total_tax + sepet.total_otv;
</cfscript>

<cfquery name="GET_OFFER_" datasource="#dsn3#">
	SELECT COMPANY_ID, CONSUMER_ID FROM OFFER WHERE OFFER_ID = #attributes.OFFER_ID#
</cfquery>
