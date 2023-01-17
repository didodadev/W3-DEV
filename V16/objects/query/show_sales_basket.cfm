<cfset invoice_bill_upd=arraynew(2)>

<cfquery name="GET_INVOICE_ROW" datasource="#db_adres#">
	SELECT 
		INVOICE_ROW.*
		<cfif not listfind("65,66",get_sale_det.invoice_cat,',')><!--- Demirbaş faturalarında stok olmadığı düşünülerek stocks tablosuna bağlanmasın diye koyduk --->
			,STOCKS.STOCK_ID
			,STOCKS.PRODUCT_ID
			,STOCKS.PROPERTY
			,PRODUCT.PRODUCT_ID
			,INVOICE_ROW.NAME_PRODUCT AS PRODUCT_NAME
		</cfif>
	FROM 
		INVOICE_ROW 
		<cfif not listfind("65,66",get_sale_det.invoice_cat,',')>
			,#dsn3_alias#.STOCKS AS STOCKS
			,#dsn3_alias#.PRODUCT AS PRODUCT
		</cfif>
	WHERE 
	<cfif not isDefined("attributes.ID")>
		INVOICE_ROW.INVOICE_ID = #attributes.IID#
	<cfelse>
		INVOICE_ROW.INVOICE_ID = #attributes.ID#
	</cfif>
	<cfif not listfind("65,66",get_sale_det.invoice_cat,',')>
		AND INVOICE_ROW.STOCK_ID = STOCKS.STOCK_ID 
		AND STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID
	</cfif>
</cfquery>
<cfset list_kdv = "" >
<cfset sepet.kdv_array = ArrayNew(2)>
<cfoutput query="get_invoice_row">
<!--- Demirbaş faturalarında stok her zaman olmadığı için bu kontrolleri koyduk --->
<cfif not listfind("65,66",get_sale_det.invoice_cat,',')>
	<cfscript>
		invoice_bill_upd[currentrow][1] = product_id;
		invoice_bill_upd[currentrow][2] = "#product_name#-#property#";
		invoice_bill_upd[currentrow][10] = stock_id;
		invoice_bill_upd[currentrow][15]=  nettotal+discounttotal; //amount*price;
	</cfscript>
<cfelse>
	<cfscript>
		invoice_bill_upd[currentrow][2] = description;
		invoice_bill_upd[currentrow][15]=  nettotal; 
	</cfscript>
</cfif>
<cfscript>
	invoice_bill_upd[currentrow][4] = amount;
	invoice_bill_upd[currentrow][5] = unit;
	invoice_bill_upd[currentrow][6] = price;
	invoice_bill_upd[currentrow][8] = discounttotal;
	invoice_bill_upd[currentrow][14] = pay_method;
	invoice_bill_upd[currentrow][16] = nettotal;
	invoice_bill_upd[currentrow][17] = taxtotal;
	invoice_bill_upd[currentrow][18] = grosstotal;
	invoice_bill_upd[currentrow][19] = 0;
	invoice_bill_upd[currentrow][20] = DISCOUNT1; 
	invoice_bill_upd[currentrow][21] = DISCOUNT2;
	invoice_bill_upd[currentrow][22] = DISCOUNT3;
	invoice_bill_upd[currentrow][23]=  DISCOUNT4;
	invoice_bill_upd[currentrow][24]=  DISCOUNT5;
	invoice_bill_upd[currentrow][25]=  DISCOUNT6;
	invoice_bill_upd[currentrow][26] = DISCOUNT7;
	invoice_bill_upd[currentrow][27] = DISCOUNT8;
	invoice_bill_upd[currentrow][28] = DISCOUNT9;
	invoice_bill_upd[currentrow][29] = DISCOUNT10;
	invoice_bill_upd[currentrow][30] = OTHER_MONEY_VALUE;
	invoice_bill_upd[currentrow][31] = OTHER_MONEY;
	invoice_bill_upd[currentrow][32] = DELIVER_DEPT & "-" & DELIVER_LOC ;
//	invoice_bill_upd[currentrow][7] = (taxtotal/nettotal)*100;
</cfscript>
	<cfif len(TAX)>
		<cfset invoice_bill_upd[currentrow][7] = TAX>
		<!--- <cfset invoice_bill_upd[currentrow][17] = satir_tax_tutar> --->
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
<cfif get_invoice_row.recordcount>
	<cfquery name="GET_MONEY" datasource="#db_adres#">
		SELECT
			RATE1,
			RATE2,
			MONEY_TYPE
		FROM
			INVOICE_MONEY
		WHERE
			MONEY_TYPE = '#GET_INVOICE_ROW.OTHER_MONEY#' AND
			ACTION_ID = #GET_INVOICE_ROW.INVOICE_ID#
	</cfquery>
</cfif>
