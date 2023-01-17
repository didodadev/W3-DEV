<cfquery name="GET_INTERNALDEMANDS" datasource="#DSN3#">
	SELECT
		*
	FROM 
		INTERNALDEMAND_ROW
	WHERE
		I_ID = #attributes.ID#
</cfquery>
<cfscript>
	sepet = StructNew();
	sepet.satir = ArrayNew(1);
	sepet.kdv_array = ArrayNew(2);
	sepet.total = 0;
	sepet.toplam_indirim = 0;
	sepet.total_tax = 0;
	sepet.net_total = 0;
	for (i = 1; i lte GET_INTERNALDEMANDS.recordcount;i=i+1)
		{
		sepet.satir[i] = StructNew();
		sepet.satir[i].product_id = GET_INTERNALDEMANDS.product_id[i];
		sepet.satir[i].product_name = GET_INTERNALDEMANDS.product_name[i];
		sepet.satir[i].paymethod_id = GET_INTERNALDEMANDS.pay_method_id[i];
		sepet.satir[i].amount = GET_INTERNALDEMANDS.quantity[i];
		sepet.satir[i].unit = GET_INTERNALDEMANDS.unit[i];
		sepet.satir[i].unit_id = GET_INTERNALDEMANDS.unit_id[i];
		if (len(GET_INTERNALDEMANDS.price[i]) and isnumeric(GET_INTERNALDEMANDS.price[i]))
			sepet.satir[i].price = GET_INTERNALDEMANDS.price[i];
		else
			sepet.satir[i].price = 0;
		if(len(GET_INTERNALDEMANDS.price_other[i]))
			sepet.satir[i].price_other = GET_INTERNALDEMANDS.price_other[i];
		else
			sepet.satir[i].price_other = sepet.satir[i].price;
		sepet.satir[i].tax_percent = GET_INTERNALDEMANDS.tax[i];
		sepet.satir[i].catalog_id = 0;
		sepet.satir[i].stock_id = GET_INTERNALDEMANDS.stock_id[i];
		sepet.satir[i].manufact_code = 0;
		sepet.satir[i].duedate = GET_INTERNALDEMANDS.duedate[i];	

		if (not len(GET_INTERNALDEMANDS.discount_1[i])) sepet.satir[i].indirim1 = 0;
		else sepet.satir[i].indirim1 = GET_INTERNALDEMANDS.discount_1[i];
		
		if (not len(GET_INTERNALDEMANDS.discount_2[i])) sepet.satir[i].indirim2 = 0;
		else sepet.satir[i].indirim2 = GET_INTERNALDEMANDS.discount_2[i];

		if (not len(GET_INTERNALDEMANDS.discount_3[i])) sepet.satir[i].indirim3 = 0;
		else sepet.satir[i].indirim3 = GET_INTERNALDEMANDS.discount_3[i];
		
		if (not len(GET_INTERNALDEMANDS.discount_4[i])) sepet.satir[i].indirim4 = 0;
		else sepet.satir[i].indirim4 = GET_INTERNALDEMANDS.discount_4[i];
		
		if (not len(GET_INTERNALDEMANDS.discount_5[i]))
			sepet.satir[i].indirim5 = 0;
		else
			sepet.satir[i].indirim5 = GET_INTERNALDEMANDS.discount_5[i];
		sepet.satir[i].indirim6 = 0;
		sepet.satir[i].indirim7 = 0;
		sepet.satir[i].indirim8 = 0;
		sepet.satir[i].indirim9 = 0;
		sepet.satir[i].indirim10 = 0;
		sepet.satir[i].indirim_carpan = (100-sepet.satir[i].indirim1) * (100-sepet.satir[i].indirim2) * (100-sepet.satir[i].indirim3) * (100-sepet.satir[i].indirim4) * (100-sepet.satir[i].indirim5) * (100-sepet.satir[i].indirim6) * (100-sepet.satir[i].indirim7) * (100-sepet.satir[i].indirim8) * (100-sepet.satir[i].indirim9) * (100-sepet.satir[i].indirim10);
		sepet.satir[i].net_maliyet = 0;	
		sepet.satir[i].marj = 0;		
		sepet.satir[i].deliver_date = dateformat(GET_INTERNALDEMANDS.deliver_date[i],dateformat_style);
		if(len(trim(GET_INTERNALDEMANDS.deliver_LOCATION[i]))){
			sepet.satir[i].deliver_dept = "#GET_INTERNALDEMANDS.deliver_dept[i]#-#GET_INTERNALDEMANDS.deliver_LOCATION[i]#";
		}else{
			sepet.satir[i].deliver_dept = "#GET_INTERNALDEMANDS.deliver_dept[i]#";
		}
		
		//Wrk_row_id Eklendi
		sepet.satir[i].wrk_row_id ="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
		sepet.satir[i].wrk_row_relation_id = '';
		
		sepet.satir[i].spect_id = GET_INTERNALDEMANDS.SPECT_VAR_ID[i];
		sepet.satir[i].spect_name = GET_INTERNALDEMANDS.SPECT_VAR_NAME[i];
		sepet.satir[i].other_money = GET_INTERNALDEMANDS.other_money[i];
		sepet.satir[i].other_money_value = GET_INTERNALDEMANDS.other_money_value[i];
		sepet.satir[i].lot_no = "";
		SQLString = "
			SELECT
				STOCKS.STOCK_CODE,
				STOCKS.BARCOD,
				STOCKS.STOCK_CODE_2
			FROM
				PRODUCT,
				STOCKS
			WHERE
				STOCKS.STOCK_ID = #GET_INTERNALDEMANDS.stock_id[i]#
				AND
				PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID";
		get_stock_name = cfquery(SQLString : SQLString, Datasource : DSN3);
		sepet.satir[i].barcode = get_stock_name.barcod;
		sepet.satir[i].stock_code = get_stock_name.stock_code;
		sepet.satir[i].special_code = get_stock_name.STOCK_CODE_2;
		sepet.satir[i].row_total = sepet.satir[i].amount * sepet.satir[i].price;
		sepet.satir[i].row_nettotal = wrk_round((sepet.satir[i].row_total/100000000000000000000) * sepet.satir[i].indirim_carpan,price_round_number);
		sepet.satir[i].row_taxtotal = wrk_round(sepet.satir[i].row_nettotal * (sepet.satir[i].tax_percent/100),price_round_number);
		sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal;
		sepet.total = sepet.total + wrk_round(sepet.satir[i].row_total,basket_total_round_number); //subtotal_
		sepet.toplam_indirim = sepet.toplam_indirim + (wrk_round(sepet.satir[i].row_total,price_round_number) - wrk_round(sepet.satir[i].row_nettotal,price_round_number)); //discount_
		sepet.total_tax = sepet.total_tax + sepet.satir[i].row_taxtotal; //totaltax_
		sepet.net_total = sepet.net_total + sepet.satir[i].row_lasttotal; //nettotal_

		// kdv array
		kdv_flag = 0;
		for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
			{
			if (sepet.kdv_array[k][1] eq sepet.satir[i].tax_percent)
				{
				kdv_flag = 1;
				sepet.kdv_array[k][2] = sepet.kdv_array[k][2] + sepet.satir[i].row_taxtotal;
				}
			}
		if (not kdv_flag)
			{
			sepet.kdv_array[arraylen(sepet.kdv_array)+1][1] = sepet.satir[i].tax_percent;
			sepet.kdv_array[arraylen(sepet.kdv_array)][2] = sepet.satir[i].row_taxtotal;
			}

		// urun asortileri 
			SQLString = "
				SELECT
					*
				FROM
					PRODUCTION_ASSORTMENT
				WHERE
					ACTION_TYPE=1 AND
					ASSORTMENT_ID=#GET_INTERNALDEMANDS.OFFER_ROW_ID[i]#
				ORDER BY PARSE1,PARSE2
				";
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
</cfscript>
