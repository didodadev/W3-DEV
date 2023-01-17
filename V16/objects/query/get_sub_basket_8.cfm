<cfquery name="GET_PERIOD" datasource="#dsn3#">
	SELECT DISTINCT
		SP.PERIOD_ID,
		SP.PERIOD_YEAR,
		SP.OUR_COMPANY_ID
	FROM
		SERVICE_PROD_RETURN SPR,
		SERVICE_PROD_RETURN_ROWS SPRR,
		#dsn_alias#.SETUP_PERIOD SP
	WHERE
		SPR.RETURN_ID = SPRR.RETURN_ID AND
		SP.PERIOD_ID = SPR.PERIOD_ID AND
		SPRR.RETURN_ROW_ID IN (#attributes.return_row_ids#)
</cfquery>
<cfquery name="GET_SHIP_ROW" datasource="#dsn3#">
	<cfloop query="GET_PERIOD">
		<cfset new_dsn2 = "#dsn#_#GET_PERIOD.PERIOD_YEAR#_#GET_PERIOD.OUR_COMPANY_ID#">
		SELECT
			SPR.*,
			SPRR.AMOUNT AS SATIR_AMOUNT,
			IR.*,
			S.IS_INVENTORY,
			S.IS_PRODUCTION,
			S.BARCOD,
			S.STOCK_CODE,
			S.MANUFACT_CODE,
			S.IS_SERIAL_NO,
			S.PRODUCT_ID,
			S.STOCK_CODE_2
		FROM
			SERVICE_PROD_RETURN SPR,
			SERVICE_PROD_RETURN_ROWS SPRR,
			#new_dsn2#.INVOICE_ROW IR,
			STOCKS S
		WHERE
			SPR.RETURN_ID = SPRR.RETURN_ID AND
			IR.INVOICE_ROW_ID = SPRR.INVOICE_ROW_ID AND
			SPRR.STOCK_ID = S.STOCK_ID AND
			SPRR.RETURN_ROW_ID IN (#attributes.return_row_ids#)
		<cfif GET_PERIOD.currentrow neq GET_PERIOD.recordcount>
			UNION ALL
		</cfif>
	</cfloop>
</cfquery>
<cfscript>
	sepet = StructNew();
	sepet.satir = ArrayNew(1);
	sepet.kdv_array = ArrayNew(2);
	sepet.total = 0;
	sepet.toplam_indirim = 0;
	sepet.total_tax = 0;
	sepet.net_total = 0;
	sepet.genel_indirim = 0;
	sepet.other_money = session.ep.MONEY2;
</cfscript>
<cfoutput query="GET_SHIP_ROW">
	<cfscript>
	i = currentrow;
	sepet.satir[i] = StructNew();
	
	sepet.satir[i].wrk_row_id ="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
	sepet.satir[i].wrk_row_relation_id = '';
	
	sepet.satir[i].product_id = PRODUCT_ID;
	sepet.satir[i].is_inventory = IS_INVENTORY;
	sepet.satir[i].is_production = IS_PRODUCTION;
	sepet.satir[i].product_name = NAME_PRODUCT;
	sepet.satir[i].amount = SATIR_AMOUNT;
	sepet.satir[i].unit = UNIT;
	sepet.satir[i].unit_id = UNIT_ID;
	sepet.satir[i].price = PRICE;
	
	if(not (isdefined("attributes.event") and attributes.event is 'copy') and isdefined("ROW_ORDER_ID") and len(ROW_ORDER_ID))
		sepet.satir[i].row_ship_id = ROW_ORDER_ID;
	if (not len(DISCOUNT1)) sepet.satir[i].indirim1 = 0; else sepet.satir[i].indirim1 = DISCOUNT1;
	if (not len(DISCOUNT2)) sepet.satir[i].indirim2 = 0; else sepet.satir[i].indirim2 = DISCOUNT2;
	if (not len(DISCOUNT3)) sepet.satir[i].indirim3 = 0; else sepet.satir[i].indirim3 = DISCOUNT3;
	if (not len(DISCOUNT4)) sepet.satir[i].indirim4 = 0; else sepet.satir[i].indirim4 = DISCOUNT4;
	if (not len(DISCOUNT5)) sepet.satir[i].indirim5 = 0; else sepet.satir[i].indirim5 = DISCOUNT5;
	if (not len(DISCOUNT6)) sepet.satir[i].indirim6 = 0; else sepet.satir[i].indirim6 = DISCOUNT6;
	if (not len(DISCOUNT7)) sepet.satir[i].indirim7 = 0; else sepet.satir[i].indirim7 = DISCOUNT7;
	if (not len(DISCOUNT8)) sepet.satir[i].indirim8 = 0; else sepet.satir[i].indirim8 = DISCOUNT8;
	if (not len(DISCOUNT9)) sepet.satir[i].indirim9 = 0; else sepet.satir[i].indirim9 = DISCOUNT9;
	if (not len(DISCOUNT10)) sepet.satir[i].indirim10 = 0; else sepet.satir[i].indirim10 = DISCOUNT10;
	sepet.satir[i].indirim_carpan = (100-sepet.satir[i].indirim1) * (100-sepet.satir[i].indirim2) * (100-sepet.satir[i].indirim3) * (100-sepet.satir[i].indirim4) * (100-sepet.satir[i].indirim5) * (100-sepet.satir[i].indirim6) * (100-sepet.satir[i].indirim7) * (100-sepet.satir[i].indirim8) * (100-sepet.satir[i].indirim9) * (100-sepet.satir[i].indirim10);
	sepet.satir[i].net_maliyet = 0;	
	sepet.satir[i].marj = 0;
	if (len(EXTRA_COST)) sepet.satir[i].extra_cost = EXTRA_COST; else sepet.satir[i].extra_cost = 0;
	sepet.satir[i].paymethod_id = '';
	sepet.satir[i].stock_id = STOCK_ID;
	sepet.satir[i].barcode = BARCOD;
	sepet.satir[i].special_code = STOCK_CODE_2;
	sepet.satir[i].stock_code = STOCK_CODE;
	sepet.satir[i].manufact_code = MANUFACT_CODE;
	sepet.satir[i].duedate = "";
	if(len(TAX))
		sepet.satir[i].tax_percent = TAX;
	else if(NETTOTAL neq 0) 
		sepet.satir[i].tax_percent = (TAXTOTAL/NETTOTAL)*100; 
	else 
		sepet.satir[i].tax_percent = 0;
	//sepet.satir[i].row_total = amount*price;
	if(len(NETTOTAL))
	{
		sepet.satir[i].row_total = ((NETTOTAL+DISCOUNTTOTAL)/AMOUNT)*SATIR_AMOUNT;
		sepet.satir[i].row_nettotal = (NETTOTAL/AMOUNT)*SATIR_AMOUNT;
		sepet.satir[i].row_taxtotal = (TAXTOTAL/AMOUNT)*SATIR_AMOUNT;
		sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal;
		//if(len(GROSSTOTAL)) (GROSSTOTAL/AMOUNT)*SATIR_AMOUNT; else sepet.satir[i].row_lasttotal = 0;
	}
	else
	{
		sepet.satir[i].row_total = sepet.satir[i].amount * sepet.satir[i].price;
		sepet.satir[i].row_nettotal = (sepet.satir[i].row_total/100000000000000000000) * sepet.satir[i].indirim_carpan;
		sepet.satir[i].row_taxtotal = sepet.satir[i].row_nettotal * (sepet.satir[i].tax_percent/100);
		sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal;
	}
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

	sepet.total = sepet.total + wrk_round(sepet.satir[i].row_total,basket_total_round_number); //subtotal_
	sepet.toplam_indirim = sepet.toplam_indirim + (wrk_round(sepet.satir[i].row_total,price_round_number) - wrk_round(sepet.satir[i].row_nettotal,price_round_number)); //discount_
	
	sepet.total_tax = sepet.total_tax + sepet.satir[i].row_taxtotal; //totaltax_
	sepet.net_total = sepet.net_total + sepet.satir[i].row_lasttotal; //nettotal_

	// kdv array
	kdv_flag = 0;
	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		{
		if(sepet.kdv_array[k][1] eq sepet.satir[i].tax_percent)
			{
			kdv_flag = 1;
			sepet.kdv_array[k][2] = sepet.kdv_array[k][2] + 0;
			sepet.kdv_array[k][3] = sepet.kdv_array[k][3] + wrk_round(sepet.satir[i].row_nettotal,basket_total_round_number);			
			}
		}
	if (not kdv_flag)
		{
		sepet.kdv_array[arraylen(sepet.kdv_array)+1][1] = sepet.satir[i].tax_percent;
		sepet.kdv_array[arraylen(sepet.kdv_array)][2] = 0;
		sepet.kdv_array[arraylen(sepet.kdv_array)][3] = wrk_round(sepet.satir[i].row_nettotal,basket_total_round_number);
		}
	
	sepet.satir[i].assortment_array = ArrayNew(1);// asorti işlemleri duzenlenecek
	
	</cfscript>
</cfoutput>

