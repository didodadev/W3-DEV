<!--- burasi daha önce o aboneye ait siparis varmi yokmu kontrolu icin yapildi. --->
<cfquery name="GET_SUBSCRIPTION_ORDER" datasource="#DSN3#">
	SELECT
		SUBSCRIPTION_ID
	FROM
		SUBSCRIPTION_CONTRACT_ORDER
	WHERE
		SUBSCRIPTION_ID = #attributes.subscription_id#
</cfquery>
<cfif not get_subscription_order.recordcount>
	<cfquery name="GET_SUBSCRIPTION_PRODUCTS" datasource="#DSN3#">
		SELECT
			*
		FROM 
			SUBSCRIPTION_CONTRACT_ROW
		WHERE
			SUBSCRIPTION_ID = #attributes.subscription_id#
			<!---SCR.ROW_ORDER_ID = 0  bu kosul abonede siparise bagimsiz satırlar icin yazildi --->
	</cfquery>
<cfelse>
	<cfset get_subscription_products.recordcount = 0>
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
	//sepet.other_money = GET_OFFER.OTHER_MONEY;
	for (i = 1; i lte get_subscription_products.recordcount;i=i+1)
		{
		sepet.satir[i] = StructNew();
		
		sepet.satir[i].wrk_row_id ="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
		sepet.satir[i].wrk_row_relation_id = '';
		
		sepet.satir[i].product_id = get_subscription_products.product_id[i];
		sepet.satir[i].product_name = get_subscription_products.product_name[i];
		sepet.satir[i].paymethod_id = '';
		if (len(get_subscription_products.amount[i])) 
			sepet.satir[i].amount = get_subscription_products.amount[i];
		else
			sepet.satir[i].amount = 1;
		sepet.satir[i].unit = get_subscription_products.unit[i];
		sepet.satir[i].unit_id = get_subscription_products.unit_id[i];
		if (len(get_subscription_products.price[i])) 
			sepet.satir[i].price = get_subscription_products.price[i];
		else
			sepet.satir[i].price = 0;
		if(len(get_subscription_products.price_other[i]))
			sepet.satir[i].price_other = get_subscription_products.price_other[i];		
		else
			sepet.satir[i].price_other = get_subscription_products.price[i];
		sepet.satir[i].tax_percent = get_subscription_products.tax[i];
		if(len(get_subscription_products.otv_oran)) //özel tüketim vergisi
			sepet.satir[i].otv_oran = get_subscription_products.otv_oran;
		else if(get_subscription_products.NETTOTAL neq 0 and len(get_subscription_products.OTVTOTAL) and get_subscription_products.OTVTOTAL neq 0) 
			sepet.satir[i].otv_oran = (get_subscription_products.OTVTOTAL/get_subscription_products.NETTOTAL)*100; 
		else 
			sepet.satir[i].otv_oran = 0;
		if (not len(get_subscription_products.discount1[i])) sepet.satir[i].indirim1 = 0; else sepet.satir[i].indirim1 = get_subscription_products.discount1[i];
		if (not len(get_subscription_products.discount2[i])) sepet.satir[i].indirim2 = 0; else sepet.satir[i].indirim2 = get_subscription_products.discount2[i];
		if (not len(get_subscription_products.discount3[i])) sepet.satir[i].indirim3 = 0; else sepet.satir[i].indirim3 = get_subscription_products.discount3[i];
		if (not len(get_subscription_products.discount4[i])) sepet.satir[i].indirim4 = 0; else sepet.satir[i].indirim4 = get_subscription_products.discount4[i];
		if (not len(get_subscription_products.discount5[i])) sepet.satir[i].indirim5 = 0; else sepet.satir[i].indirim5 = get_subscription_products.discount5[i];
		sepet.satir[i].indirim6 = 0;
		sepet.satir[i].indirim7 = 0;
		sepet.satir[i].indirim8 = 0;
		sepet.satir[i].indirim9 = 0;
		sepet.satir[i].indirim10 = 0;
		sepet.satir[i].indirim_carpan = (100-sepet.satir[i].indirim1) * (100-sepet.satir[i].indirim2) * (100-sepet.satir[i].indirim3) * (100-sepet.satir[i].indirim4) * (100-sepet.satir[i].indirim5) * (100-sepet.satir[i].indirim6) * (100-sepet.satir[i].indirim7) * (100-sepet.satir[i].indirim8) * (100-sepet.satir[i].indirim9) * (100-sepet.satir[i].indirim10);
		sepet.satir[i].catalog_id = 0;
		sepet.satir[i].stock_id = get_subscription_products.stock_id[i];
		sepet.satir[i].manufact_code = '';
		sepet.satir[i].duedate = '';
		sepet.satir[i].deliver_date = '';
		sepet.satir[i].deliver_dept = '';
		//sepet.satir[i].duedate = get_offer_products.duedate[i];
		//sepet.satir[i].deliver_date = dateformat(get_offer_products.deliver_date[i],dateformat_style);
		//sepet.satir[i].deliver_dept = "#get_offer_products.deliver_dept[i]#-#get_offer_products.deliver_LOCATION[i]#";
		sepet.satir[i].spect_id = get_subscription_products.spect_var_id[i];
		sepet.satir[i].spect_name = get_subscription_products.spect_var_name[i];
		sepet.satir[i].other_money = get_subscription_products.other_money[i];
		sepet.satir[i].other_money_value = get_subscription_products.price_other[i];	
		sepet.satir[i].other_money_value = get_subscription_products.other_money_value[i];
		//sepet.satir[i].net_maliyet = get_offer_products.NET_MALIYET[i];
		//sepet.satir[i].marj = get_offer_products.MARJ[i];
		if(len(get_subscription_products.price_other[i]))
			sepet.satir[i].price_other = get_subscription_products.price_other[i];
		else
			sepet.satir[i].price_other = get_subscription_products.price[i];
		
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
				STOCK_ID = #get_subscription_products.stock_id[i]#";
		get_stock_name = cfquery(SQLString : SQLString, Datasource : DSN3);
		if(not len(sepet.satir[i].unit_id))sepet.satir[i].unit_id=get_stock_name.product_unit_id;		
		sepet.satir[i].barcode = get_stock_name.barcod;
		sepet.satir[i].special_code = get_stock_name.STOCK_CODE_2;
		sepet.satir[i].is_inventory = get_stock_name.is_inventory;
		sepet.satir[i].is_production = get_stock_name.is_production;
		sepet.satir[i].stock_code = get_stock_name.stock_code;
		/*sepet.satir[i].row_total = sepet.satir[i].amount * sepet.satir[i].price;
		sepet.satir[i].row_nettotal = wrk_round((sepet.satir[i].row_total/100000000000000000000) * sepet.satir[i].indirim_carpan,price_round_number);
		sepet.satir[i].row_taxtotal = wrk_round(sepet.satir[i].row_nettotal * (sepet.satir[i].tax_percent/100),price_round_number);
		sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal;*/
		if(len(get_subscription_products.nettotal))
		{
			sepet.satir[i].row_total = get_subscription_products.nettotal[i]+get_subscription_products.discounttotal[i];//amount*price;
			sepet.satir[i].row_nettotal = get_subscription_products.nettotal[i];
			sepet.satir[i].row_taxtotal = get_subscription_products.taxtotal[i];
			sepet.satir[i].row_lasttotal = get_subscription_products.nettotal[i] + get_subscription_products.taxtotal[i];
			//if(len(grosstotal)) sepet.satir[i].row_lasttotal = grosstotal; else sepet.satir[i].row_lasttotal = 0;
		}
		else
		{
			sepet.satir[i].row_total = sepet.satir[i].amount * sepet.satir[i].price;
			sepet.satir[i].row_nettotal = (sepet.satir[i].row_total/100000000000000000000) * sepet.satir[i].indirim_carpan;
			sepet.satir[i].row_taxtotal = sepet.satir[i].row_nettotal * (sepet.satir[i].tax_percent/100);
			sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal;
		}	
		if(len(get_subscription_products.otvtotal))
		{ 
			sepet.satir[i].row_otvtotal =get_subscription_products.otvtotal[i];
			/*20060530 aksi halde taxtotal daki kusurler basket toplamini bozuyor. if(len(GROSSTOTAL)) sepet.satir[i].row_lasttotal = GROSSTOTAL; else sepet.satir[i].row_lasttotal = 0;*/
			sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal + sepet.satir[i].row_otvtotal;
		}
		else
		{
			sepet.satir[i].row_otvtotal = 0;
			sepet.satir[i].row_lasttotal = get_subscription_products.nettotal[i]+get_subscription_products.taxtotal[i];
		}
		sepet.satir[i].manufact_code = get_stock_name.MANUFACT_CODE;
		sepet.total = sepet.total + wrk_round(sepet.satir[i].row_total,basket_total_round_number); //subtotal_
		sepet.toplam_indirim = sepet.toplam_indirim + (wrk_round(sepet.satir[i].row_total,price_round_number) - wrk_round(sepet.satir[i].row_nettotal,price_round_number)); //discount_
		sepet.total_tax = sepet.total_tax + sepet.satir[i].row_taxtotal; //totaltax_
		sepet.net_total = sepet.net_total + sepet.satir[i].row_lasttotal; //nettotal_
		sepet.satir[i].reserve_type = -1; //siparis eklemede belge bazında reserve et ilk asamada secili geldiginden satırlarda da reserve secili getiriliyor
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
		/* urun asortileri */
		SQLString = "SELECT * FROM PRODUCTION_ASSORTMENT WHERE ACTION_TYPE = 1 AND ASSORTMENT_ID = #get_subscription_products.subscription_row_id[i]# ORDER BY PARSE1,PARSE2";
		get_assort = cfquery(SQLString : SQLString, Datasource : DSN3);

		sepet.satir[i].assortment_array = ArrayNew(1);
		for(j = 1 ; j lte get_assort.recordcount ; j=j+1)
		{
			sepet.satir[i].assortment_array[j] = StructNew();
			sepet.satir[i].assortment_array[j].property_id = get_assort.PARSE1[j];
			sepet.satir[i].assortment_array[j].property_detail_id = get_assort.PARSE2[j];
			sepet.satir[i].assortment_array[j].property_amount = get_assort.AMOUNT[j];
		}
			
		sepet.satir[i].lot_no = "";
		sepet.satir[i].iskonto_tutar = get_subscription_products.discount_cost[i];
		}
		for (t=1;t lte arraylen(sepet.otv_array);t=t+1)
			sepet.total_otv = sepet.total_otv + wrk_round(sepet.otv_array[t][2],price_round_number);
</cfscript>
<!--- <cfquery name="GET_SUBSCRIPTION_" datasource="#DSN3#">	muhtemelen kullanılmıyor kapatıldı
	SELECT
		COMPANY_ID,
		CONSUMER_ID
	FROM 
		SUBSCRIPTION_CONTRACT
	WHERE
		SUBSCRIPTION_ID = #attributes.subscription_id#
</cfquery> --->
