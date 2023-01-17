<cfif isdefined("attributes.public_id")><!---list="#attributes.stock_id#"--->
    <cfquery name="GET_PRO_MAT_ROW" datasource="#dsn3#">
        SELECT 
        	'' ROW_PROJECT_ID,
            STOCKS.PRODUCT_ID,
            STOCKS.STOCK_ID,
            STOCKS.STOCK_CODE,
            STOCKS.BARCOD AS BARCOD,
            STOCKS.MANUFACT_CODE,
            PRODUCT.PRODUCT_NAME,
            PRODUCT_UNIT.PRODUCT_UNIT_ID UNIT_ID,
            PRODUCT_UNIT.MAIN_UNIT UNIT,
            PRODUCT.PRODUCT_CODE,
          	#dsn_alias#.IS_ZERO(ISNULL(AMOUNT,1),1) AMOUNT,
          	PRODUCT.IS_SERIAL_NO,
            1 KUR_HESAPLA,
            PRODUCT.TAX AS TAX,
            PRODUCT.OTV AS OTV,
            PRODUCT.IS_INVENTORY,
            PRODUCT.IS_PRODUCTION,
            PRODUCT_UNIT.MULTIPLIER,
            STOCKS.STOCK_CODE_2,
            PRICE_STANDART.PRICE,
            '' DISCOUNT1,
            '' DISCOUNT2,
            '' DISCOUNT3,
            '' DISCOUNT4,
            '' DISCOUNT5,
            0 COST_PRICE,
            0 MARGIN,
            0 EXTRA_COST,
            '' UNIQUE_RELATION_ID,
            '' PRODUCT_NAME2,
            #dsn_alias#.IS_ZERO(ISNULL(AMOUNT,1),1) AMOUNT2,
            PRICE_STANDART.PRICE*#dsn_alias#.IS_ZERO(ISNULL(AMOUNT,1),1) NETTOTAL,
            PRICE_STANDART.PRICE*#dsn_alias#.IS_ZERO(ISNULL(AMOUNT,1),1) OTHER_MONEY_VALUE,
            PRICE_STANDART.PRICE*#dsn_alias#.IS_ZERO(ISNULL(AMOUNT,1),1)*PRODUCT.TAX/100 TAXTOTAL,
          	PRODUCT_UNIT.ADD_UNIT UNIT2,
            0 EXTRA_PRICE,
            0 WIDTH_VALUE ,
            0 DEPTH_VALUE,
            0 HEIGHT_VALUE,
            0 EK_TUTAR_PRICE,
            0 EXTRA_PRICE_TOTAL,
            0 EXTRA_PRICE_OTHER_TOTAL,
            '' SHELF_NUMBER,
            -1 BASKET_EXTRA_INFO_ID,
			'' SELECT_INFO_EXTRA,
			'' DETAIL_INFO_EXTRA,
            '' PAYMETHOD_ID,
            '' PRODUCT_MANUFACT_CODE,
            '' DUEDATE,
            0 DISCOUNTTOTAL,
            0 OTVTOTAL,
            '' OTHER_MONEY,
            '' DELIVER_DATE,
            '' DELIVER_LOCATION,
            '' DELIVER_DEPT,
            '' SPECT_VAR_ID,
            '' SPECT_VAR_NAME,
            '' PRICE_OTHER,
            0 OTV_ORAN,
            0 PROM_COMISSION,
            0 PROM_COST,
            0 DISCOUNT_COST,
            '' IS_PROMOTION,
            '' PROM_STOCK_ID,
            '' PROM_ID,
            0 LIST_PRICE,
            '' PRICE_CAT,
            '' CATALOG_ID,
            '' KARMA_PRODUCT_ID,
            '' WRK_ROW_ID
 		FROM
            PRODUCT
               LEFT JOIN PRODUCT_UNIT ON PRODUCT_UNIT.PRODUCT_ID=PRODUCT.PRODUCT_ID AND PRODUCT_UNIT_STATUS = 1 AND IS_MAIN=1 
               LEFT JOIN PRICE_STANDART ON PRICE_STANDART.PRODUCT_ID=PRODUCT.PRODUCT_ID AND PRICE_STANDART.PURCHASESALES = 0 AND PRICESTANDART_STATUS=1,
            STOCKS,
			#dsn_alias#.POZ_PROJECT PP
        WHERE	
            PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID
			AND PP.STOCK_ID = STOCKS.STOCK_ID
    </cfquery>
<cfelse>
    <cfquery name="GET_PRO_MAT_ROW" datasource="#dsn#">
        SELECT
            PMR.*,
            S.IS_INVENTORY,
            S.IS_PRODUCTION,
            S.STOCK_CODE,
            S.BARCOD,
            S.IS_SERIAL_NO,
            S.MANUFACT_CODE,
            S.STOCK_CODE_2
        FROM 
            PRO_MATERIAL_ROW PMR,
            #dsn3_alias#.STOCKS S
        WHERE 
            PMR.PRO_MATERIAL_ID IN (#attributes.upd_id#) AND
            PMR.STOCK_ID=S.STOCK_ID
        ORDER BY
            PMR.PRO_MATERIAL_ROW_ID
    </cfquery>
   </cfif>
<cfset row_project_id_list_=listsort(ListDeleteDuplicates(valuelist(GET_PRO_MAT_ROW.ROW_PROJECT_ID)),'numeric','asc',',')>
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
	sepet.other_money = '';
	for (i = 1; i lte get_pro_mat_row.recordcount;i=i+1)
	{
		sepet.satir[i] = StructNew();
		if(len(get_pro_mat_row.wrk_row_id))
			sepet.satir[i].wrk_row_id = get_pro_mat_row.wrk_row_id[i];
		else
			sepet.satir[i].wrk_row_id ="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
		sepet.satir[i].wrk_row_relation_id = '';
		
		sepet.satir[i].product_id = get_pro_mat_row.product_id[i];
		sepet.satir[i].is_inventory = get_pro_mat_row.is_inventory[i];
		sepet.satir[i].is_production = get_pro_mat_row.is_production[i];
		sepet.satir[i].product_name = get_pro_mat_row.product_name[i];
		sepet.satir[i].special_code = get_pro_mat_row.STOCK_CODE_2[i];
		sepet.satir[i].amount = get_pro_mat_row.amount[i];
		sepet.satir[i].unit = get_pro_mat_row.unit[i];
		sepet.satir[i].unit_id = get_pro_mat_row.unit_id[i];
		sepet.satir[i].price = get_pro_mat_row.price[i];	
		if (not len(get_pro_mat_row.discount1[i])) sepet.satir[i].indirim1 = 0; else sepet.satir[i].indirim1 = get_pro_mat_row.discount1[i];
		if (not len(get_pro_mat_row.discount2[i])) sepet.satir[i].indirim2 = 0; else sepet.satir[i].indirim2 = get_pro_mat_row.discount2[i];
		if (not len(get_pro_mat_row.discount3[i])) sepet.satir[i].indirim3 = 0; else sepet.satir[i].indirim3 = get_pro_mat_row.discount3[i];
		if (not len(get_pro_mat_row.discount4[i])) sepet.satir[i].indirim4 = 0; else sepet.satir[i].indirim4 = get_pro_mat_row.discount4[i];
		if (not len(get_pro_mat_row.discount5[i])) sepet.satir[i].indirim5 = 0; else sepet.satir[i].indirim5 = get_pro_mat_row.discount5[i];
		sepet.satir[i].indirim6 = 0;
		sepet.satir[i].indirim7 = 0;
		sepet.satir[i].indirim8 = 0;
		sepet.satir[i].indirim9 = 0;
		sepet.satir[i].indirim10 = 0;
		sepet.satir[i].indirim_carpan = (100-sepet.satir[i].indirim1) * (100-sepet.satir[i].indirim2) * (100-sepet.satir[i].indirim3) * (100-sepet.satir[i].indirim4) * (100-sepet.satir[i].indirim5) * (100-sepet.satir[i].indirim6) * (100-sepet.satir[i].indirim7) * (100-sepet.satir[i].indirim8) * (100-sepet.satir[i].indirim9) * (100-sepet.satir[i].indirim10);
		if(len(get_pro_mat_row.COST_PRICE[i])) sepet.satir[i].net_maliyet = get_pro_mat_row.COST_PRICE[i]; else sepet.satir[i].net_maliyet=0;
		if(len(get_pro_mat_row.MARGIN[i])) sepet.satir[i].marj = get_pro_mat_row.MARGIN[i]; else sepet.satir[i].marj = 0;
		if(len(get_pro_mat_row.extra_cost[i])) sepet.satir[i].extra_cost = get_pro_mat_row.extra_cost[i]; else sepet.satir[i].extra_cost = 0;
		if(len(get_pro_mat_row.UNIQUE_RELATION_ID[i])) sepet.satir[i].row_unique_relation_id = get_pro_mat_row.UNIQUE_RELATION_ID[i]; else sepet.satir[i].row_unique_relation_id = "";
		if(len(get_pro_mat_row.PRODUCT_NAME2[i])) sepet.satir[i].product_name_other = get_pro_mat_row.PRODUCT_NAME2[i]; else sepet.satir[i].product_name_other = "";
		if(len(get_pro_mat_row.AMOUNT2[i])) sepet.satir[i].amount_other = get_pro_mat_row.AMOUNT2[i]; else sepet.satir[i].amount_other = "";
		if(len(get_pro_mat_row.UNIT2[i])) sepet.satir[i].unit_other = get_pro_mat_row.UNIT2[i]; else sepet.satir[i].unit_other = "";
		if(len(get_pro_mat_row.EXTRA_PRICE[i])) sepet.satir[i].ek_tutar = get_pro_mat_row.EXTRA_PRICE[i]; else sepet.satir[i].ek_tutar = 0;
		if(len(get_pro_mat_row.WIDTH_VALUE[i])) sepet.satir[i].row_width = get_pro_mat_row.WIDTH_VALUE[i]; else sepet.satir[i].row_width = '';
		if(len(get_pro_mat_row.DEPTH_VALUE[i])) sepet.satir[i].row_depth = get_pro_mat_row.DEPTH_VALUE[i]; else  sepet.satir[i].row_depth = '';
		if(len(get_pro_mat_row.HEIGHT_VALUE[i])) sepet.satir[i].row_height = get_pro_mat_row.HEIGHT_VALUE[i]; else  sepet.satir[i].row_height = '';
		if(len(get_pro_mat_row.ROW_PROJECT_ID[i]))
		{
			sepet.satir[i].row_project_id=get_pro_mat_row.ROW_PROJECT_ID[i];
			sepet.satir[i].row_project_name=GET_ROW_PROJECTS.PROJECT_HEAD[listfind(row_project_id_list_,get_pro_mat_row.ROW_PROJECT_ID[i])];
		}
		if(len(get_pro_mat_row.EK_TUTAR_PRICE[i]))
		{
			sepet.satir[i].ek_tutar_price = get_pro_mat_row.EK_TUTAR_PRICE[i];
			if(len(get_pro_mat_row.AMOUNT2[i])) sepet.satir[i].ek_tutar_cost = get_pro_mat_row.EK_TUTAR_PRICE[i]*get_pro_mat_row.AMOUNT2[i]; else sepet.satir[i].ek_tutar_cost = get_pro_mat_row.EK_TUTAR_PRICE[i];
		}
		else
		{ sepet.satir[i].ek_tutar_price = 0;sepet.satir[i].ek_tutar_cost =0;}
		
		if(len(sepet.satir[i].ek_tutar_cost) and sepet.satir[i].ek_tutar_cost neq 0)
			sepet.satir[i].ek_tutar_marj = (sepet.satir[i].ek_tutar*100/sepet.satir[i].ek_tutar_cost)-100;
		else
			sepet.satir[i].ek_tutar_marj ='';
		
		if(len(get_pro_mat_row.EXTRA_PRICE_TOTAL[i])) sepet.satir[i].ek_tutar_total = get_pro_mat_row.EXTRA_PRICE_TOTAL[i]; else sepet.satir[i].ek_tutar_total = 0;
		if( len(get_pro_mat_row.EXTRA_PRICE_OTHER_TOTAL[i]) ) sepet.satir[i].ek_tutar_other_total = get_pro_mat_row.EXTRA_PRICE_OTHER_TOTAL[i]; else sepet.satir[i].ek_tutar_other_total = 0;
		if(len(get_pro_mat_row.SHELF_NUMBER[i])) sepet.satir[i].shelf_number = get_pro_mat_row.SHELF_NUMBER[i]; else sepet.satir[i].shelf_number = "";
		if(len(get_pro_mat_row.BASKET_EXTRA_INFO_ID[i])) sepet.satir[i].basket_extra_info = get_pro_mat_row.BASKET_EXTRA_INFO_ID[i]; else sepet.satir[i].basket_extra_info="";
		if(len(get_pro_mat_row.SELECT_INFO_EXTRA[i])) sepet.satir[i].select_info_extra = get_pro_mat_row.SELECT_INFO_EXTRA[i]; else sepet.satir[i].select_info_extra="";
		if(len(get_pro_mat_row.DETAIL_INFO_EXTRA[i])) sepet.satir[i].detail_info_extra = get_pro_mat_row.DETAIL_INFO_EXTRA[i]; else sepet.satir[i].detail_info_extra="";
		sepet.satir[i].paymethod_id = get_pro_mat_row.paymethod_id[i];
		sepet.satir[i].stock_id = get_pro_mat_row.stock_id[i];
		sepet.satir[i].barcode = get_pro_mat_row.BARCOD[i];
		sepet.satir[i].stock_code = get_pro_mat_row.STOCK_CODE[i];
		sepet.satir[i].manufact_code = get_pro_mat_row.PRODUCT_MANUFACT_CODE[i];
		sepet.satir[i].duedate = get_pro_mat_row.duedate[i];
		if(len(get_pro_mat_row.nettotal[i]))
		{
			sepet.satir[i].row_total = get_pro_mat_row.nettotal[i]+get_pro_mat_row.discounttotal[i];//amount*price;
			sepet.satir[i].row_nettotal = get_pro_mat_row.nettotal[i];
			sepet.satir[i].row_taxtotal = get_pro_mat_row.taxtotal[i];
			if(len(get_pro_mat_row.otvtotal[i]))
			{ 
				sepet.satir[i].row_otvtotal =get_pro_mat_row.otvtotal[i];
				sepet.satir[i].row_lasttotal = get_pro_mat_row.nettotal[i]+get_pro_mat_row.taxtotal[i]+get_pro_mat_row.otvtotal[i];
			}
			else
			{
				sepet.satir[i].row_otvtotal = 0;
				sepet.satir[i].row_lasttotal = get_pro_mat_row.nettotal[i]+get_pro_mat_row.taxtotal[i];
			}
		}else{
			sepet.satir[i].row_total = (sepet.satir[i].amount * sepet.satir[i].price)+sepet.satir[i].ek_tutar_total;
			sepet.satir[i].row_nettotal = (sepet.satir[i].row_total/100000000000000000000) * sepet.satir[i].indirim_carpan;
			sepet.satir[i].row_taxtotal = sepet.satir[i].row_nettotal * (sepet.satir[i].tax_percent/100);
			if(len(get_pro_mat_row.otvtotal[i]))
			{ 
				sepet.satir[i].row_otvtotal =get_pro_mat_row.otvtotal[i];
				sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal+sepet.satir[i].row_otvtotal;
			}
			else
			{
				sepet.satir[i].row_otvtotal = 0;
				sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal+sepet.satir[i].row_otvtotal;
			}
		}
		sepet.satir[i].other_money = get_pro_mat_row.OTHER_MONEY[i];
		if(len(get_pro_mat_row.OTHER_MONEY_VALUE[i]))
			sepet.satir[i].other_money_value =get_pro_mat_row.OTHER_MONEY_VALUE[i];
		else
			sepet.satir[i].other_money_value =0;
		sepet.satir[i].deliver_date = dateformat(get_pro_mat_row.DELIVER_DATE[i],dateformat_style);
		
		if(len(get_pro_mat_row.DELIVER_LOCATION[i])) 
			sepet.satir[i].deliver_dept = get_pro_mat_row.DELIVER_DEPT[i] & "-" & get_pro_mat_row.DELIVER_LOCATION[i] ; 
		else 
			sepet.satir[i].deliver_dept = get_pro_mat_row.DELIVER_DEPT[i] ; 
		
		sepet.satir[i].spect_id = get_pro_mat_row.spect_var_id[i];
		sepet.satir[i].spect_name = get_pro_mat_row.spect_var_name[i];
		sepet.satir[i].lot_no = '';
		if(len(get_pro_mat_row.PRICE_OTHER[i]))
			sepet.satir[i].price_other = get_pro_mat_row.PRICE_OTHER[i];
		else
			sepet.satir[i].price_other = get_pro_mat_row.PRICE[i];
	
		if(len(get_pro_mat_row.tax[i]))
			sepet.satir[i].tax_percent =get_pro_mat_row.TAX[i];
		else
			{
			if(get_pro_mat_row.nettotal[i] neq 0) 
				sepet.satir[i].tax_percent =(get_pro_mat_row.taxtotal[i]/get_pro_mat_row.nettotal[i])*100; 
			else 
				sepet.satir[i].tax_percent=0;
			}
		if(len(get_pro_mat_row.OTV_ORAN[i])) 
			sepet.satir[i].otv_oran = get_pro_mat_row.OTV_ORAN[i];
		else if(get_pro_mat_row.NETTOTAL[i] neq 0 and len(get_pro_mat_row.OTVTOTAL[i]) and get_pro_mat_row.OTVTOTAL[i] neq 0) 
			sepet.satir[i].otv_oran = (get_pro_mat_row.OTVTOTAL[i]/get_pro_mat_row.NETTOTAL[i])*100; 
		else 
			sepet.satir[i].otv_oran = 0;

		sepet.total = sepet.total + wrk_round(sepet.satir[i].row_total,basket_total_round_number); //subtotal_
		sepet.toplam_indirim = sepet.toplam_indirim + (wrk_round(sepet.satir[i].row_total,price_round_number) - wrk_round(sepet.satir[i].row_nettotal,price_round_number)); //discount_
		sepet.net_total = sepet.net_total + sepet.satir[i].row_nettotal; //nettotal_ a daha sonra kdv toplam ekleniyor altta
	
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
		sepet.satir[i].assortment_array = ArrayNew(1);
		
		sepet.satir[i].promosyon_yuzde = get_pro_mat_row.PROM_COMISSION;	
		if (len(get_pro_mat_row.PROM_COST[i])) sepet.satir[i].promosyon_maliyet = get_pro_mat_row.PROM_COST[i]; else sepet.satir[i].promosyon_maliyet = 0;
		sepet.satir[i].iskonto_tutar = get_pro_mat_row.DISCOUNT_COST[i];
		sepet.satir[i].is_promotion = get_pro_mat_row.IS_PROMOTION[i];
		sepet.satir[i].prom_stock_id = get_pro_mat_row.prom_stock_id[i];
		sepet.satir[i].row_promotion_id =get_pro_mat_row.PROM_ID[i];
		sepet.satir[i].is_commission = '';
		if(len(get_pro_mat_row.LIST_PRICE)) sepet.satir[i].list_price = get_pro_mat_row.LIST_PRICE; else sepet.satir[i].list_price = get_pro_mat_row.PRICE;
		if(len(get_pro_mat_row.PRICE_CAT)) sepet.satir[i].price_cat = get_pro_mat_row.PRICE_CAT; else  sepet.satir[i].price_cat = '';
		if(len(get_pro_mat_row.CATALOG_ID)) sepet.satir[i].row_catalog_id = get_pro_mat_row.CATALOG_ID; else  sepet.satir[i].row_catalog_id = '';
		if(len(get_pro_mat_row.KARMA_PRODUCT_ID)) sepet.satir[i].karma_product_id = get_pro_mat_row.KARMA_PRODUCT_ID; else sepet.satir[i].karma_product_id = ''; 
	}

	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		sepet.kdv_array[k][2] = wrk_round(sepet.kdv_array[k][3] * sepet.kdv_array[k][1] /100,basket_total_round_number);
	
	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		sepet.total_tax = sepet.total_tax + sepet.kdv_array[k][2];
		
	
	for (t=1;t lte arraylen(sepet.otv_array);t=t+1)
		sepet.total_otv = sepet.total_otv + wrk_round(sepet.otv_array[t][2],price_round_number);
	
	sepet.net_total = sepet.net_total + sepet.total_tax + sepet.total_otv;
</cfscript>
