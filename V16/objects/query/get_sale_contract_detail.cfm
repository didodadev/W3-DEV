<cfquery name="GET_ORDER_PRODUCTS" datasource="#dsn3#">
	SELECT
		*
	FROM 
		ORDER_ROW
	WHERE
		ORDER_ID = #attributes.order_id#
</cfquery>

<cfscript>
	sepet = StructNew();
	sepet.satir = ArrayNew(1);
	sepet.kdv_array = ArrayNew(2);
	sepet.total = 0;
	sepet.toplam_indirim = 0;
	sepet.total_tax = 0;
	sepet.net_total = 0;
	
	
	for (i = 1; i lte get_order_products.recordcount;i=i+1)
		{
		sepet.satir[i] = StructNew();
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
		sepet.satir[i].catalog_id = 0;
		sepet.satir[i].stock_id = get_order_products.stock_id[i];
		sepet.satir[i].manufact_code = 0;
		sepet.satir[i].duedate = get_order_products.duedate[i];

		if (not len(get_order_products.discount_1[i])) sepet.satir[i].indirim1 = 0;
		else sepet.satir[i].indirim1 = get_order_products.discount_1[i];
		
		if (not len(get_order_products.discount_2[i])) sepet.satir[i].indirim2 = 0;
		else sepet.satir[i].indirim2 = get_order_products.discount_2[i];

		if (not len(get_order_products.discount_3[i])) sepet.satir[i].indirim3 = 0;
		else sepet.satir[i].indirim3 = get_order_products.discount_3[i];
		
		if (not len(get_order_products.discount_4[i])) sepet.satir[i].indirim4 = 0;
		else sepet.satir[i].indirim4 = get_order_products.discount_4[i];
		
		if (not len(get_order_products.discount_5[i])) sepet.satir[i].indirim5 = 0;
		else sepet.satir[i].indirim5 = get_order_products.discount_5[i];
		
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
	}

</cfscript>
