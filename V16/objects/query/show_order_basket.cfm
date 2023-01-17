<cfset invoice_bill_upd=arraynew(2)>
<cfquery name="GET_ORDER_ROW" datasource="#dsn3#">
	SELECT 
		ORDER_ROW.*,
		ISNULL(ROW_DISCOUNTTOTAL,0) DISCOUNTTOTAL,
		STOCKS.STOCK_ID,
		STOCKS.PRODUCT_ID,
		STOCKS.PROPERTY,
		PRODUCT.PRODUCT_ID,
		ORDER_ROW.PRODUCT_NAME
	FROM 
		ORDER_ROW ,
		STOCKS AS STOCKS,
		PRODUCT AS PRODUCT
	WHERE 
		ORDER_ROW.ORDER_ID = #attributes.order_id#
		AND ORDER_ROW.STOCK_ID = STOCKS.STOCK_ID 
		AND STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID
</cfquery>
<cfset list_kdv = "" >
<cfset sepet.kdv_array = ArrayNew(2)>
<cfoutput query="get_order_row">
	<cfscript>
		invoice_bill_upd[currentrow][1] = product_id;
		invoice_bill_upd[currentrow][2] = "#product_name#-#property#";
		invoice_bill_upd[currentrow][10] = stock_id;
		invoice_bill_upd[currentrow][15]=  nettotal+discounttotal; //amount*price;
	</cfscript>
	<cfscript>
		invoice_bill_upd[currentrow][4] = quantity;
		invoice_bill_upd[currentrow][5] = unit;
		invoice_bill_upd[currentrow][6] = price;
		invoice_bill_upd[currentrow][8] = discounttotal;
		invoice_bill_upd[currentrow][14] = pay_method;
		invoice_bill_upd[currentrow][16] = nettotal;
		invoice_bill_upd[currentrow][17] = nettotal*tax/100;
		invoice_bill_upd[currentrow][18] = nettotal;
		invoice_bill_upd[currentrow][19] = 0;
		invoice_bill_upd[currentrow][20] = DISCOUNT_1; 
		invoice_bill_upd[currentrow][21] = DISCOUNT_2;
		invoice_bill_upd[currentrow][22] = DISCOUNT_3;
		invoice_bill_upd[currentrow][23]=  DISCOUNT_4;
		invoice_bill_upd[currentrow][24]=  DISCOUNT_5;
		invoice_bill_upd[currentrow][25]=  DISCOUNT_6;
		invoice_bill_upd[currentrow][26] = DISCOUNT_7;
		invoice_bill_upd[currentrow][27] = DISCOUNT_8;
		invoice_bill_upd[currentrow][28] = DISCOUNT_9;
		invoice_bill_upd[currentrow][29] = DISCOUNT_10;
		invoice_bill_upd[currentrow][30] = OTHER_MONEY_VALUE;
		invoice_bill_upd[currentrow][31] = OTHER_MONEY;
	</cfscript>
	<cfif len(TAX)>
		<cfset invoice_bill_upd[currentrow][7] = TAX>
	<cfelse>
		<cfif nettotal neq 0>
			<cfset invoice_bill_upd[currentrow][7] = (taxtotal/nettotal)*100 > 
		<cfelse>	
			<cfset invoice_bill_upd[currentrow][7] = 0>
		</cfif>
	</cfif>		
	<cfscript>
		kdv_flag = 0;
		for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
			{
			if (sepet.kdv_array[k][1] eq invoice_bill_upd[currentrow][7])
				{
				kdv_flag = 1;
				sepet.kdv_array[k][2] = sepet.kdv_array[k][2] + invoice_bill_upd[currentrow][17];
				}
			}
		if (not kdv_flag)
			{
			sepet.kdv_array[arraylen(sepet.kdv_array)+1][1] = invoice_bill_upd[currentrow][7];
			sepet.kdv_array[arraylen(sepet.kdv_array)][2] = invoice_bill_upd[currentrow][17];
			}	
	</cfscript>
</cfoutput>
<cfif get_order_row.recordcount>
	<cfquery name="GET_MONEY" datasource="#dsn3#">
		SELECT
			RATE1,
			RATE2,
			MONEY_TYPE
		FROM
			ORDER_MONEY
		WHERE
			MONEY_TYPE = '#get_order_row.OTHER_MONEY#' AND
			ACTION_ID = #get_order_row.ORDER_ID#
	</cfquery>
</cfif>
