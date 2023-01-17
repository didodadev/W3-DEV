


<cfif isdefined("attributes.opp_id") and len(attributes.opp_id) and isdefined("attributes.product_id")>
	<cfquery name="GET_OFFER_PRODUCTS" datasource="#DSN3#">
		SELECT
				PS.PRODUCT_SAMPLE_ID ,
			0 as OFFER_ID,
				P.PRODUCT_ID,
				0 as DESCRIPTION,
				 PS.PRODUCT_SAMPLE_NAME  AS PRODUCT_NAME,
				'' AS PAYMETHOD_ID,
				PS.TARGET_AMOUNT_UNITY AS UNIT_ID,
				SU.UNIT AS UNIT,
				'' AS UNIT2,
				'' AS UNIQUE_RELATION_ID,
				'' AS PROM_RELATION_ID,
				ISNULL(PS.TARGET_AMOUNT, 0 )  AS QUANTITY,
				'' AS PRODUCT_NAME2,
				'' AS AMOUNT2,
				 S.STOCK_ID,
				0 AS EXTRA_PRICE,
				0 AS EK_TUTAR_PRICE,
				'' AS EXTRA_PRICE_TOTAL,
				'' AS EXTRA_PRICE_OTHER_TOTAL,
				'' AS SHELF_NUMBER,
				'' AS BASKET_EXTRA_INFO_ID,
				PS.SALES_PRICE  AS PRICE,
				PS.SALES_PRICE  AS LIST_PRICE,
				'' AS PRICE_CAT,
				'' AS CATALOG_ID,
				'' AS NUMBER_OF_INSTALLMENT,
				0 AS COST_PRICE,
				0 AS MARJ,
				0 AS EXTRA_COST,
				PS.SALES_PRICE  AS PRICE_OTHER,
				0 AS TAX,
				0 AS OTV_ORAN,
				PS.SALES_PRICE_CURRENCY  AS OTHER_MONEY, 
				PS.CUSTOMER_MODEL_NO AS  PRODUCT_MANUFACT_CODE,
				0 AS DUEDATE,
				'' AS PROM_COMISSION,
				0 AS PROM_COST,
				0 AS DISCOUNT_COST,
				0 AS IS_PROMOTION,
				'' AS PROM_STOCK_ID,
				'' AS PROM_ID,
				0 AS IS_COMMISSION,
				0 AS  DISCOUNT_1,
				0 AS  DISCOUNT_2,
				0 AS  DISCOUNT_3,
				0 AS  DISCOUNT_4,
				0 AS  DISCOUNT_5,
				0 AS DISCOUNT_6,
				0 AS DISCOUNT_7,
				0 AS DISCOUNT_8,
				0 AS DISCOUNT_9,
				0 AS DISCOUNT_10,
				'' AS BASKET_EMPLOYEE_ID,
				'' as PBS_ID,
				'' AS KARMA_PRODUCT_ID,
				'' AS DELIVER_DATE,'' AS DELIVER_LOCATION,'' AS DELIVER_DEPT,'' AS SPECT_VAR_ID,'' AS SPECT_VAR_NAME,
				'' LOT_NO,
				-1 RESERVE_TYPE,
				'' RESERVE_DATE,
				'' AS BARCOD,
				S.BARCOD,S.STOCK_CODE,S.IS_INVENTORY,S.IS_PRODUCTION,
				'' AS NETTOTAL,
			'' AS OTVTOTAL,
				P.PRODUCT_ID AS OFFER_ROW_ID,
				'' AS PRO_MATERIAL_ID,
				-1 AS ORDER_ROW_CURRENCY,
				'' AS ROW_PRO_MATERIAL_ID,
				'' AS WRK_ROW_ID,
				'' AS WRK_ROW_RELATION_ID,
			'' AS RELATED_ACTION_ID,
			'' AS RELATED_ACTION_TABLE,
				'' AS WIDTH_VALUE,
				'' AS DEPTH_VALUE,
				'' AS HEIGHT_VALUE,
				'' AS ROW_PROJECT_ID,
				'' STOCK_CODE_2,
				'' ROW_WORK_ID,
				'' SELECT_INFO_EXTRA,
				'' DETAIL_INFO_EXTRA,
				'' AS REASON_CODE,
			'' AS EXPENSE_CENTER_ID,
			'' AS ACTIVITY_TYPE_ID,
			'' AS EXPENSE_ITEM_ID,
			'' AS ACC_CODE,
			'' AS SUBSCRIPTION_ID,
			'' AS SUBSCRIPTION_NO,
			'' AS ASSETP_ID,
			'' AS ASSETP,
			'' AS OIV_RATE,
			'' AS OIV_AMOUNT,
			'' AS BSMV_RATE,
			'' AS BSMV_AMOUNT,
			'' AS BSMV_CURRENCY,
			'' AS TEVKIFAT_RATE,
			'' AS TEVKIFAT_AMOUNT,
			'' AS GTIP_NUMBER,
			'' AS OTV_TYPE,
			'' AS OTV_DISCOUNT,
			'' AS OTHER_MONEY_VALUE 
				, PS.OPPORTUNITY_ID 
				,P.PRODUCT_ID AS OFFER_ROW_ID
				,O.OPP_ID 
				, P.P_SAMPLE_ID
				,0 SPECIFIC_WEIGHT
				,0 WEIGHT
				,0 VOLUME 
				,'' as PAY_METHOD_ID
				,'' as PARTNER_ID
				,'' as  NET_MALIYET
				,	'' as EXPENSE
				,'' as EXPENSE_ITEM_NAME
				,'' as DELIVERY_CONDITION 
				FROM 
				#dsn1#.PRODUCT AS P
				LEFT JOIN PRODUCT_SAMPLE AS PS ON PS.PRODUCT_SAMPLE_ID = P.P_SAMPLE_ID 
				LEFT JOIN OPPORTUNITIES AS O ON  O.OPP_ID =PS.OPPORTUNITY_ID 
				LEFT JOIN #dsn#.SETUP_UNIT AS SU ON  SU.UNIT_ID = PS.TARGET_AMOUNT_UNITY 
				LEFT JOIN STOCKS AS S ON S.PRODUCT_ID=P.PRODUCT_ID
			
		WHERE
		
			P.PRODUCT_ID   IN (#ListQualify(product_id,"'",",")#) 
			
		ORDER BY
			P.PRODUCT_ID
	</cfquery>
	<cfelse>
		<cfquery name="GET_OFFER_" datasource="#dsn3#">
			SELECT TOP 1
				COMPANY_ID,
				CONSUMER_ID,
				OTHER_MONEY
			FROM
				OFFER
			WHERE
				OFFER_ID IN (#attributes.OFFER_ID#)
		</cfquery>
		<cfif isDefined("form.offer_row_check_info") and len(form.offer_row_check_info)>
			<cfset GET_OFFER.OTHER_MONEY = GET_OFFER_.other_money>
		</cfif>
<cfquery name="GET_OFFER_PRODUCTS" datasource="#DSN3#">
	SELECT
		OFFER_ROW.OFFER_ID,
		OFFER_ROW.OFFER_ROW_ID,
		OFFER_ROW.PRODUCT_ID,
		OFFER_ROW.STOCK_ID,
		OFFER_ROW.QUANTITY,
		OFFER_ROW.UNIT,
		OFFER_ROW.UNIT_ID,
		OFFER_ROW.PRICE,
		OFFER_ROW.PRICE_OTHER,
		OFFER_ROW.TAX,
		OFFER_ROW.DUEDATE,
		OFFER_ROW.PRODUCT_NAME,
		OFFER_ROW.DESCRIPTION,
		OFFER_ROW.PAY_METHOD_ID,
		OFFER_ROW.PARTNER_ID,
		OFFER_ROW.DELIVER_DATE,
		OFFER_ROW.DELIVER_DEPT,
		OFFER_ROW.DELIVER_LOCATION,
		OFFER_ROW.DISCOUNT_1,
		OFFER_ROW.DISCOUNT_2,
		OFFER_ROW.DISCOUNT_3,
		OFFER_ROW.DISCOUNT_4,
		OFFER_ROW.DISCOUNT_5,
		OFFER_ROW.DISCOUNT_6,
		OFFER_ROW.DISCOUNT_7,
		OFFER_ROW.DISCOUNT_8,
		OFFER_ROW.DISCOUNT_9,
		OFFER_ROW.DISCOUNT_10,
		OFFER_ROW.SPECT_VAR_ID,
		OFFER_ROW.SPECT_VAR_NAME,
		OFFER_ROW.OTHER_MONEY,
		OFFER_ROW.OTHER_MONEY_VALUE,
		OFFER_ROW.NET_MALIYET,
		OFFER_ROW.MARJ,
		OFFER_ROW.PROM_COMISSION,
		OFFER_ROW.PROM_COST,
		OFFER_ROW.DISCOUNT_COST,
		OFFER_ROW.IS_PROMOTION,
		OFFER_ROW.PROM_ID,
		OFFER_ROW.PROM_STOCK_ID,
		OFFER_ROW.PRODUCT_NAME2,
		OFFER_ROW.UNIT2,
		OFFER_ROW.EXTRA_PRICE_OTHER_TOTAL,
		OFFER_ROW.EXTRA_PRICE,
		OFFER_ROW.SHELF_NUMBER,
		OFFER_ROW.UNIQUE_RELATION_ID,
		OFFER_ROW.PRODUCT_MANUFACT_CODE,
		OFFER_ROW.DISCOUNTTOTAL,
		OFFER_ROW.EXTRA_PRICE_TOTAL,
		OFFER_ROW.OTV_ORAN,
		OFFER_ROW.OTVTOTAL,
		OFFER_ROW.COST_ID,
		OFFER_ROW.EXTRA_COST,
		OFFER_ROW.BASKET_EXTRA_INFO_ID,
		OFFER_ROW.SELECT_INFO_EXTRA,
		OFFER_ROW.DETAIL_INFO_EXTRA,
		OFFER_ROW.DELIVERY_CONDITION,
		OFFER_ROW.LIST_PRICE,
		OFFER_ROW.LOT_NO,
		OFFER_ROW.PRICE_CAT,
		OFFER_ROW.CATALOG_ID,
		OFFER_ROW.NUMBER_OF_INSTALLMENT,
		OFFER_ROW.KARMA_PRODUCT_ID,
		OFFER_ROW.AMOUNT2,
		OFFER_ROW.EK_TUTAR_PRICE,
		OFFER_ROW.WRK_ROW_ID,
		OFFER_ROW.WRK_ROW_RELATION_ID,
		OFFER_ROW.RELATED_ACTION_ID,
		OFFER_ROW.RELATED_ACTION_TABLE,
		OFFER_ROW.DEPTH_VALUE,
		OFFER_ROW.WIDTH_VALUE,
		OFFER_ROW.HEIGHT_VALUE,
		OFFER_ROW.ROW_PROJECT_ID,
		OFFER_ROW.BASKET_EMPLOYEE_ID,
		OFFER_ROW.PBS_ID,
		OFFER_ROW.ROW_WORK_ID,
		OFFER_ROW.EXPENSE_CENTER_ID,
		OFFER_ROW.EXPENSE_ITEM_ID,
		OFFER_ROW.ACTIVITY_TYPE_ID,
		OFFER_ROW.ACC_CODE,
		OFFER_ROW.BSMV_RATE,
		OFFER_ROW.BSMV_AMOUNT,
		OFFER_ROW.BSMV_CURRENCY,
		OFFER_ROW.OIV_RATE,
		OFFER_ROW.OIV_AMOUNT,
		OFFER_ROW.TEVKIFAT_RATE,
		OFFER_ROW.TEVKIFAT_AMOUNT,
		EXC.EXPENSE,
		EXI.EXPENSE_ITEM_NAME,
		OFFER_ROW.SPECIFIC_WEIGHT,
		OFFER_ROW.WEIGHT,
		OFFER_ROW.VOLUME
    FROM
		OFFER_ROW
		LEFT JOIN #dsn2#.EXPENSE_CENTER AS EXC ON OFFER_ROW.EXPENSE_CENTER_ID = EXC.EXPENSE_ID
		LEFT JOIN #dsn2#.EXPENSE_ITEMS AS EXI ON OFFER_ROW.EXPENSE_ITEM_ID = EXI.EXPENSE_ITEM_ID
    WHERE
        OFFER_ID IN (#attributes.OFFER_ID#)
    ORDER BY
        OFFER_ROW_ID
</cfquery>
</cfif>
<cfset basket_emp_id_list=listsort(ListDeleteDuplicates(valuelist(GET_OFFER_PRODUCTS.BASKET_EMPLOYEE_ID)),'numeric','asc',',')>
<cfset row_project_id_list_=listsort(ListDeleteDuplicates(valuelist(GET_OFFER_PRODUCTS.ROW_PROJECT_ID)),'numeric','asc',',')>
<cfset row_work_id_list_=listsort(ListDeleteDuplicates(valuelist(GET_OFFER_PRODUCTS.ROW_WORK_ID)),'numeric','asc',',')>
<cfif len(basket_emp_id_list)>
	<cfquery name="GET_BASKET_EMPLOYEES" datasource="#dsn#">
		SELECT EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS BASKET_EMPLOYEE, EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#basket_emp_id_list#) ORDER BY EMPLOYEE_ID
	</cfquery>
	<cfset basket_emp_id_list = valuelist(GET_BASKET_EMPLOYEES.EMPLOYEE_ID)>
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
	if( isdefined("attributes.opp_id"))
	{
		sepet.other_money = GET_OFFER_PRODUCTS.OTHER_MONEY;
	}
	else
	
	sepet.other_money = GET_OFFER.OTHER_MONEY;
	
	// teklif basketine fatura alti indirim alani eklendi 20140804 esranur
	sepet.genel_indirim = 0;
	if (isdefined('GET_OFFER.SA_DISCOUNT') and isnumeric(GET_OFFER.SA_DISCOUNT))
	{
		sepet.genel_indirim = GET_OFFER.SA_DISCOUNT;
	}
	
	for (i = 1; i lte get_offer_products.recordcount;i=i+1)
	{
		sepet.satir[i] = StructNew();
		if(isdefined("attributes.offer_id") and isdefined("attributes.ref") and attributes.ref is 'offer') // satis teklifine donusturme
		{
			sepet.satir[i].wrk_row_id="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
			sepet.satir[i].wrk_row_relation_id=get_offer_products.WRK_ROW_ID[i];
			sepet.satir[i].related_action_id='#attributes.offer_id#';
			sepet.satir[i].related_action_table='OFFER';
		}
		else if(isdefined("attributes.offer_to_order") and attributes.offer_to_order eq 1)
		{
			sepet.satir[i].wrk_row_id="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
			sepet.satir[i].wrk_row_relation_id=get_offer_products.WRK_ROW_ID[i];
			sepet.satir[i].related_action_id='';
			sepet.satir[i].related_action_table='';
		}
		else if(isdefined("attributes.offer_row_check_info") and len(attributes.offer_row_check_info)) // iliskili teklif siparise donusturme
		{
			sepet.satir[i].wrk_row_relation_id = get_offer_products.wrk_row_relation_id[i];
			sepet.satir[i].wrk_row_id=get_offer_products.WRK_ROW_ID[i];
			sepet.satir[i].related_action_id=get_offer_products.offer_id[i];
			sepet.satir[i].related_action_table="OFFER";
		}
		else if((isdefined("attributes.event") and attributes.event is 'add')  and isdefined("attributes.offer_id") and Len(attributes.offer_id) ) //teklif kopyalama
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
		if(len(GET_OFFER_PRODUCTS.KARMA_PRODUCT_ID[i])) sepet.satir[i].karma_product_id =  GET_OFFER_PRODUCTS.KARMA_PRODUCT_ID[i]; else sepet.satir[i].karma_product_id = ''; 
		sepet.satir[i].product_id = get_offer_products.product_id[i];
		sepet.satir[i].product_name = get_offer_products.product_name[i];
		sepet.satir[i].paymethod_id = get_offer_products.pay_method_id[i];

		sepet.satir[i].promosyon_yuzde = get_offer_products.PROM_COMISSION[i];	
		if(len(get_offer_products.PROM_COST[i]))
			sepet.satir[i].promosyon_maliyet = get_offer_products.PROM_COST[i];
		else
			sepet.satir[i].promosyon_maliyet = 0;
		sepet.satir[i].iskonto_tutar = get_offer_products.DISCOUNT_COST[i];
		sepet.satir[i].is_promotion = get_offer_products.IS_PROMOTION[i];
		sepet.satir[i].prom_stock_id = get_offer_products.prom_stock_id[i];
		if(len(get_offer_products.BASKET_EMPLOYEE_ID[i]))
		{	
			sepet.satir[i].basket_employee_id = get_offer_products.BASKET_EMPLOYEE_ID[i]; 
			sepet.satir[i].basket_employee = GET_BASKET_EMPLOYEES.BASKET_EMPLOYEE[listfind(basket_emp_id_list,get_offer_products.BASKET_EMPLOYEE_ID[i])]; 
		}
		else
		{		
			sepet.satir[i].basket_employee_id = '';
			sepet.satir[i].basket_employee = '';
		}
		
		
		if(isdefined("attributes.offer_row_check_info") and len(attributes.offer_row_check_info)) // iliskili teklifteki miktarlar aliniyor
		{
			if(len(Evaluate('offer_amount_'&get_offer_products.offer_id[i]&"_"&get_offer_products.wrk_row_id[i])))
					sepet.satir[i].amount = filternum(Evaluate('offer_amount_'&get_offer_products.offer_id[i]&"_"&get_offer_products.wrk_row_id[i]));
				else
					sepet.satir[i].amount = get_offer_products.QUANTITY[i];
		}
		else if (len(get_offer_products.quantity[i])) 
			sepet.satir[i].amount = get_offer_products.quantity[i];
		else
			sepet.satir[i].amount = 1;
		sepet.satir[i].unit = get_offer_products.unit[i];
		sepet.satir[i].unit_id = get_offer_products.unit_id[i];
		sepet.satir[i].pbs_id = get_offer_products.PBS_ID[i];
		if( len(get_offer_products.price_other[i]))
			sepet.satir[i].price_other = get_offer_products.price_other[i];
		else
			sepet.satir[i].price_other = get_offer_products.price[i];
		sepet.satir[i].other_money = get_offer_products.OTHER_MONEY[i];
		sepet.satir[i].price = 0;
		for(k=1;k lte get_money_bskt.recordcount;k=k+1)
			if(sepet.satir[i].other_money eq get_money_bskt.MONEY_TYPE[k])
				sepet.satir[i].price = sepet.satir[i].price_other * get_money_bskt.RATE2[k] / get_money_bskt.RATE1[k];
		if(len(get_offer_products.price_other[i]))
			sepet.satir[i].price_other = get_offer_products.price_other[i];		
		else
			sepet.satir[i].price_other = get_offer_products.price[i];
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
		sepet.satir[i].indirim_carpan = (100-sepet.satir[i].indirim1) * (100-sepet.satir[i].indirim2) * (100-sepet.satir[i].indirim3) * (100-sepet.satir[i].indirim4) * (100-sepet.satir[i].indirim5) * (100-sepet.satir[i].indirim6) * (100-sepet.satir[i].indirim7) * (100-sepet.satir[i].indirim8) * (100-sepet.satir[i].indirim9) * (100-sepet.satir[i].indirim10);
		sepet.satir[i].catalog_id = 0;
		sepet.satir[i].stock_id = get_offer_products.stock_id[i];
		sepet.satir[i].manufact_code = get_offer_products.PRODUCT_MANUFACT_CODE[i];
		sepet.satir[i].duedate = get_offer_products.duedate[i];
		sepet.satir[i].deliver_date = dateformat(get_offer_products.deliver_date[i],dateformat_style);
		sepet.satir[i].deliver_dept = "#get_offer_products.deliver_dept[i]#-#get_offer_products.deliver_LOCATION[i]#";
		sepet.satir[i].spect_id = get_offer_products.spect_var_id[i];
		sepet.satir[i].spect_name = get_offer_products.spect_var_name[i];
		sepet.satir[i].other_money_value = get_offer_products.price_other[i];	
		sepet.satir[i].other_money_value = get_offer_products.OTHER_MONEY_VALUE[i];
		sepet.satir[i].net_maliyet = get_offer_products.NET_MALIYET[i];
		sepet.satir[i].marj = get_offer_products.MARJ[i];
		if (len(get_offer_products.EXTRA_COST[i]))	
			sepet.satir[i].extra_cost = get_offer_products.EXTRA_COST[i];
		else
			sepet.satir[i].extra_cost = 0;
		if( len(get_offer_products.unique_relation_id[i]) ) sepet.satir[i].row_unique_relation_id = get_offer_products.unique_relation_id[i]; else sepet.satir[i].row_unique_relation_id = "";
		if( len(get_offer_products.product_name2[i]) ) sepet.satir[i].product_name_other = get_offer_products.product_name2[i]; else sepet.satir[i].product_name_other = "";
		if( len(get_offer_products.amount2[i]) ) sepet.satir[i].amount_other = get_offer_products.amount2[i]; else sepet.satir[i].amount_other = "";
		if( len(get_offer_products.EXTRA_PRICE_OTHER_TOTAL[i])) sepet.satir[i].ek_tutar_other_total = get_offer_products.EXTRA_PRICE_OTHER_TOTAL[i]; else sepet.satir[i].ek_tutar_other_total = 0;	
		if( len(get_offer_products.unit2[i]) ) sepet.satir[i].unit_other = get_offer_products.unit2[i]; else sepet.satir[i].unit_other = "";
		if( len(get_offer_products.extra_price[i]) ) sepet.satir[i].ek_tutar = get_offer_products.extra_price[i]; else sepet.satir[i].ek_tutar = 0;
		if( len(get_offer_products.extra_price_total[i]) ) sepet.satir[i].ek_tutar_total = get_offer_products.extra_price_total[i]; else sepet.satir[i].ek_tutar_total = 0;

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
		
		if(len(get_offer_products.EK_TUTAR_PRICE[i]))
		{
			sepet.satir[i].ek_tutar_price = get_offer_products.EK_TUTAR_PRICE[i];
			if(len(get_offer_products.amount2[i])) sepet.satir[i].ek_tutar_cost = get_offer_products.EK_TUTAR_PRICE[i]*get_offer_products.amount2[i]; else sepet.satir[i].ek_tutar_cost = get_offer_products.EK_TUTAR_PRICE[i];
		}
		else
		{ sepet.satir[i].ek_tutar_price = 0;sepet.satir[i].ek_tutar_cost =0;}
		
		if(len(sepet.satir[i].ek_tutar_cost) and sepet.satir[i].ek_tutar_cost neq 0)
			sepet.satir[i].ek_tutar_marj = (sepet.satir[i].ek_tutar*100/sepet.satir[i].ek_tutar_cost)-100;
		else
			sepet.satir[i].ek_tutar_marj ='';
		
		if( len(get_offer_products.shelf_number[i]) ) sepet.satir[i].shelf_number = get_offer_products.shelf_number[i]; else sepet.satir[i].shelf_number = "";
		if( len(get_offer_products.BASKET_EXTRA_INFO_ID[i]) ) sepet.satir[i].basket_extra_info = get_offer_products.BASKET_EXTRA_INFO_ID[i]; else sepet.satir[i].basket_extra_info="";
		if( len(get_offer_products.SELECT_INFO_EXTRA[i]) ) sepet.satir[i].select_info_extra = get_offer_products.SELECT_INFO_EXTRA[i]; else sepet.satir[i].select_info_extra="";
		if( len(get_offer_products.DETAIL_INFO_EXTRA[i]) ) sepet.satir[i].detail_info_extra = get_offer_products.DETAIL_INFO_EXTRA[i]; else sepet.satir[i].detail_info_extra="";
		if( len(get_offer_products.DELIVERY_CONDITION[i]) ) sepet.satir[i].delivery_condition = get_offer_products.DELIVERY_CONDITION[i]; else sepet.satir[i].delivery_condition="";
		SQLString = "
			SELECT
				STOCK_CODE,
				BARCOD,
				MANUFACT_CODE,
				IS_INVENTORY,
				IS_PRODUCTION,
				PRODUCT_UNIT_ID,
				STOCK_CODE_2
			FROM
				STOCKS
			WHERE
				STOCK_ID = #get_offer_products.stock_id[i]#";
		get_stock_name = cfquery(SQLString : SQLString, Datasource : DSN3);
		if(not len(sepet.satir[i].unit_id))sepet.satir[i].unit_id=get_stock_name.PRODUCT_UNIT_ID;		
		sepet.satir[i].barcode = get_stock_name.barcod;
		sepet.satir[i].special_code = get_stock_name.STOCK_CODE_2;
		sepet.satir[i].is_inventory = get_stock_name.is_inventory;
		sepet.satir[i].is_production = get_stock_name.is_production;
		sepet.satir[i].stock_code = get_stock_name.stock_code;
		sepet.satir[i].row_total = (sepet.satir[i].amount * sepet.satir[i].price)+sepet.satir[i].ek_tutar_total;
		sepet.satir[i].row_nettotal = sepet.satir[i].row_total;
		if(len(sepet.satir[i].iskonto_tutar) and get_money_bskt.recordcount)
			for(k=1;k lte get_money_bskt.recordcount;k=k+1)
				if(sepet.satir[i].other_money eq get_money_bskt.MONEY_TYPE[k])
					sepet.satir[i].row_nettotal = sepet.satir[i].row_nettotal - (sepet.satir[i].iskonto_tutar * get_money_bskt.RATE2[k] / get_money_bskt.RATE1[k] * sepet.satir[i].amount);
		if(len(sepet.satir[i].promosyon_yuzde))
			sepet.satir[i].row_nettotal = sepet.satir[i].row_nettotal * (100-sepet.satir[i].promosyon_yuzde) /100;

		sepet.satir[i].row_nettotal = wrk_round((sepet.satir[i].row_nettotal * sepet.satir[i].indirim_carpan) /100000000000000000000,price_round_number);
		//sepet.satir[i].row_nettotal = wrk_round((sepet.satir[i].row_total/100000000000000000000) * sepet.satir[i].indirim_carpan);
		//sepet.satir[i].row_taxtotal = wrk_round(sepet.satir[i].row_nettotal * (sepet.satir[i].tax_percent/100));
		if(len(get_offer_products.OTVTOTAL[i]))
		{ 
			sepet.satir[i].row_otvtotal =get_offer_products.OTVTOTAL[i];
		}
		else
		{
		 	sepet.satir[i].row_otvtotal = 0;
		}
		if (ListFindNoCase(display_list, "otv_from_tax_price"))
			sepet.satir[i].row_taxtotal = wrk_round(((sepet.satir[i].row_nettotal+sepet.satir[i].row_otvtotal) * (sepet.satir[i].tax_percent/100)),price_round_number);
		else
			sepet.satir[i].row_taxtotal = wrk_round((sepet.satir[i].row_nettotal * (sepet.satir[i].tax_percent/100)),price_round_number);
		sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal +sepet.satir[i].row_otvtotal;
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
		sepet.satir[i].lot_no = get_offer_products.LOT_NO[i];

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
			sepet.satir[i].row_weight = ( len( get_offer_products.WEIGHT ) ) ? get_offer_products.WEIGHT : '';
			sepet.satir[i].row_specific_weight = ( len( get_offer_products.SPECIFIC_WEIGHT ) ) ? get_offer_products.SPECIFIC_WEIGHT : '';
			sepet.satir[i].row_volume = ( len( get_offer_products.VOLUME ) ) ? get_offer_products.VOLUME : '';
	}

	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		sepet.kdv_array[k][2] = wrk_round(sepet.kdv_array[k][3] * sepet.kdv_array[k][1] /100,basket_total_round_number);
	
	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		sepet.total_tax = sepet.total_tax + sepet.kdv_array[k][2];
		
	
	for (t=1;t lte arraylen(sepet.otv_array);t=t+1)
		sepet.total_otv = sepet.total_otv + wrk_round(sepet.otv_array[t][2],price_round_number);
	sepet.net_total = sepet.net_total + sepet.total_tax + sepet.total_otv;
</cfscript>
