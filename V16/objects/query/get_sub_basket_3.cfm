<cfquery name="GET_INVOICE_CONTROL" datasource="#DSN2#">
	SELECT
		*
	FROM
		INVOICE_CONTROL
	WHERE
		<cfif isdefined("attributes.invoice_id")>
			INVOICE_ID = #attributes.invoice_id#
		<cfelse>
			INVOICE_CONTROL_ID IN(#attributes.INVOICE_CONTROL_ID#)
		</cfif>
</cfquery>
<cfif GET_INVOICE_CONTROL.MONEY eq SESSION.EP.MONEY >
	<cfset float_rate = 1 >
	<cfset str_other_money = GET_INVOICE_CONTROL.MONEY >
<cfelse>
	<cfquery name="get_rate" datasource="#DSN#">
		SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY = '#GET_INVOICE_CONTROL.MONEY#'
	</cfquery>
	<cfset float_rate = get_rate.RATE2 / get_rate.RATE1 >
	<cfset str_other_money = GET_INVOICE_CONTROL.MONEY >
</cfif>
<cfif not len(ValueList(GET_INVOICE_CONTROL.RETURN_PRODUCT))>
	<script type="text/javascript">
		alert("Fark Faturası İşleminde Bir Hata Oluştu.Ürün Seçiminizi Güncelleyiniz!");
		history.go(-1);
	</script>
	<cfabort>
</cfif>
<cfquery name="GET_INVOICE_ROW" datasource="#dsn3#">
SELECT
		STOCKS.STOCK_ID,
		STOCKS.PRODUCT_ID,
		STOCKS.STOCK_CODE,
		STOCKS.BARCOD,
		STOCKS.PROPERTY,
		STOCKS.IS_INVENTORY,
		STOCKS.IS_PRODUCTION,
		STOCKS.PRODUCT_NAME,
		STOCKS.MANUFACT_CODE,
		STOCKS.TAX,
		STOCKS.IS_SERIAL_NO,		
		PU.ADD_UNIT,
		PU.PRODUCT_UNIT_ID,
		STOCKS.STOCK_CODE_2,
        IND.PROJECT_ID,
        IND.WORK_ID
	FROM 
		STOCKS
        LEFT JOIN INTERNALDEMAND_ROW IROW ON STOCKS.STOCK_ID = IROW.STOCK_ID
        LEFT JOIN INTERNALDEMAND  IND ON IROW.I_ID = IND.INTERNAL_ID,
		PRODUCT_UNIT AS PU
	WHERE
		PU.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
		STOCKS.STOCK_ID IN (#ValueList(GET_INVOICE_CONTROL.RETURN_PRODUCT)#)
</cfquery>
<cfscript>
	attributes.process_type = GET_INVOICE_CONTROL.PROCESS_TYPE ;
	satir_serino_index = 1;
	sepet = StructNew();
	sepet.satir = ArrayNew(1);
	sepet.kdv_array = ArrayNew(2);
	sepet.total = 0;
	sepet.toplam_indirim = 0;
	sepet.total_tax = 0;
	sepet.net_total = 0;
	sepet.genel_indirim = 0;
</cfscript>
<cfoutput query="GET_INVOICE_CONTROL">
	<cfquery name="GET_INVOICE_ROW_ALL" dbtype="query">
		SELECT * FROM GET_INVOICE_ROW WHERE STOCK_ID = #RETURN_PRODUCT#;
	</cfquery>
	<cfquery name="GET_SHIP_ROW" datasource="#dsn3#">
		SELECT 
			ACCOUNT_CODE
		FROM
			PRODUCT_PERIOD
		WHERE
			PRODUCT_ID = #GET_INVOICE_ROW_ALL.PRODUCT_ID# AND 
			PERIOD_ID = #SESSION.EP.PERIOD_ID#
	</cfquery>

	<!--- ERK  ürün adı zaten yukarıda alındı bir daha gerek var mı ? --->
<!--- 	Bence gerek yok arzu
	<cfquery name="GET_PRODUCT_NAME" datasource="#dsn3#">
		SELECT 
			PRODUCT_NAME,
			STOCKS.*
		FROM
			PRODUCT,
			STOCKS
		WHERE 
			STOCKS.PRODUCT_ID=PRODUCT.PRODUCT_ID AND
			STOCK_ID=#STOCK_ID#
	</cfquery> --->
	<cfscript>
	i = currentrow;
	sepet.satir[i] = StructNew();
	
	sepet.satir[i].wrk_row_id ="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
	sepet.satir[i].wrk_row_relation_id = '';
	
	sepet.satir[i].product_id = GET_INVOICE_ROW_ALL.PRODUCT_ID;
	sepet.satir[i].is_inventory = GET_INVOICE_ROW_ALL.IS_INVENTORY;
	sepet.satir[i].is_production = GET_INVOICE_ROW_ALL.IS_PRODUCTION;
	if(len(INVOICE_NUMBER))
		sepet.satir[i].product_name = GET_INVOICE_ROW_ALL.PRODUCT_NAME & "(#INVOICE_NUMBER#)";
	else
		sepet.satir[i].product_name = GET_INVOICE_ROW_ALL.PRODUCT_NAME;		
	sepet.satir[i].amount = 1;
	sepet.satir[i].unit = GET_INVOICE_ROW_ALL.add_unit;
	sepet.satir[i].unit_id = GET_INVOICE_ROW_ALL.PRODUCT_UNIT_ID;
	sepet.satir[i].price = RETURN_MONEY_VALUE*float_rate;	
	
	sepet.satir[i].indirim1 = 0;
	sepet.satir[i].indirim2 = 0;
	sepet.satir[i].indirim3 = 0;
	sepet.satir[i].indirim4 = 0;
	sepet.satir[i].indirim5 = 0;
	sepet.satir[i].indirim6 = 0;
	sepet.satir[i].indirim7 = 0;
	sepet.satir[i].indirim8 = 0;
	sepet.satir[i].indirim9 = 0;
	sepet.satir[i].indirim10 = 0;

	sepet.satir[i].tax_percent = GET_INVOICE_ROW_ALL.TAX;
	sepet.satir[i].paymethod_id = 0;
	sepet.satir[i].stock_id = GET_INVOICE_ROW_ALL.stock_id;
	sepet.satir[i].barcode = GET_INVOICE_ROW_ALL.BARCOD;
	sepet.satir[i].special_code = GET_INVOICE_ROW_ALL.STOCK_CODE_2;
	sepet.satir[i].special_code = GET_INVOICE_ROW_ALL.PROJECT_ID;
	sepet.satir[i].special_code = GET_INVOICE_ROW_ALL.WORK_ID;
	sepet.satir[i].stock_code = GET_INVOICE_ROW_ALL.STOCK_CODE;
	sepet.satir[i].manufact_code = GET_INVOICE_ROW_ALL.MANUFACT_CODE;
	sepet.satir[i].duedate = "";
	sepet.satir[i].row_total = sepet.satir[i].price;
	sepet.satir[i].indirim_carpan = (100-sepet.satir[i].indirim1) * (100-sepet.satir[i].indirim2) * (100-sepet.satir[i].indirim3) * (100-sepet.satir[i].indirim4) * (100-sepet.satir[i].indirim5) * (100-sepet.satir[i].indirim6) * (100-sepet.satir[i].indirim7) * (100-sepet.satir[i].indirim8) * (100-sepet.satir[i].indirim9) * (100-sepet.satir[i].indirim10);
	sepet.satir[i].row_total = sepet.satir[i].amount * sepet.satir[i].price;
	sepet.satir[i].row_nettotal = (sepet.satir[i].row_total/100000000000000000000) * sepet.satir[i].indirim_carpan;
	sepet.satir[i].row_taxtotal = sepet.satir[i].row_nettotal * (sepet.satir[i].tax_percent/100);
	sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal;
	
	sepet.total = sepet.total + wrk_round(sepet.satir[i].row_total,basket_total_round_number); //subtotal_
	sepet.toplam_indirim = sepet.toplam_indirim + (wrk_round(sepet.satir[i].row_total,price_round_number) - wrk_round(sepet.satir[i].row_nettotal,price_round_number)); //discount_
	sepet.net_total = sepet.net_total + sepet.satir[i].row_nettotal; //nettotal_

	sepet.satir[i].other_money = str_other_money;
	sepet.satir[i].other_money_value = wrk_round(RETURN_MONEY_VALUE,price_round_number);
	sepet.satir[i].other_money_grosstotal = wrk_round(RETURN_MONEY_VALUE,price_round_number);
	sepet.satir[i].deliver_date = "";
	sepet.satir[i].deliver_dept = "" ; 
	
	sepet.satir[i].spect_id = "";
	sepet.satir[i].spect_name = "";
	sepet.satir[i].lot_no = "";
	sepet.satir[i].price_other = wrk_round(RETURN_MONEY_VALUE,price_round_number);

	// kdv array
		kdv_flag = 0;
		for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
			{
			if (sepet.kdv_array[k][1] eq sepet.satir[i].tax_percent)
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
		sepet.satir[i].assortment_array = ArrayNew(1);
	</cfscript>
</cfoutput>
<cfscript>
	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		sepet.kdv_array[k][2] = wrk_round(sepet.kdv_array[k][3] * sepet.kdv_array[k][1] /100,basket_total_round_number);
	
	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		sepet.total_tax = sepet.total_tax + sepet.kdv_array[k][2];
	
	sepet.net_total = sepet.net_total + sepet.total_tax;
</cfscript>
