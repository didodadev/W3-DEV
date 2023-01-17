<cfquery name="GET_INVOICE_INFO_FOR_SHIP" datasource="#DSN2#">
	SELECT 
		INVOICE_ROW.STOCK_ID,
		SUM(INVOICE_ROW.AMOUNT*PU.MULTIPLIER) AS TOTAL_MAIN_UNIT_NO, 
		PU.MAIN_UNIT
	FROM 
		INVOICE,
		INVOICE_ROW,
		#dsn3_alias#.PRODUCT_UNIT AS PU
	WHERE 
		PU.PRODUCT_UNIT_STATUS = 1 AND 
		INVOICE.INVOICE_ID = #URL.IID# AND 
		INVOICE_ROW.INVOICE_ID = INVOICE.INVOICE_ID AND
		PU.ADD_UNIT = INVOICE_ROW.UNIT AND
		PU.PRODUCT_ID = INVOICE_ROW.PRODUCT_ID		
	GROUP BY
		INVOICE_ROW.STOCK_ID,PU.MAIN_UNIT
</cfquery>
<cfset irsaliye_fark_toplam = 0>
<cfoutput query="GET_INVOICE_INFO_FOR_SHIP">		
	<cfquery name="GET_SHIP_INFO_FOR_INVOICE" datasource="#DSN2#">
		SELECT 
			SHIP_ROW.STOCK_ID,
			SUM(SHIP_ROW.AMOUNT*PU.MULTIPLIER) AS TOTAL_MAIN_UNIT_NO, 
			PU.MAIN_UNIT
		FROM 
			SHIP,
			SHIP_ROW,
			INVOICE_SHIPS,
			#dsn3_alias#.PRODUCT_UNIT AS PU
		WHERE 
			PU.PRODUCT_UNIT_STATUS = 1 AND 
			<!--- SHIP.INVOICE_NUMBER = '#GET_INVOICE_INFO.INVOICE_NUMBER#' AND  --->
			INVOICE_SHIPS.INVOICE_ID=#URL.IID# AND
			INVOICE_SHIPS.SHIP_ID=SHIP.SHIP_ID AND
			INVOICE_SHIPS.SHIP_PERIOD_ID = #session.ep.period_id# AND
			SHIP_ROW.STOCK_ID = #GET_INVOICE_INFO_FOR_SHIP.STOCK_ID# AND 
			SHIP.SHIP_ID = SHIP_ROW.SHIP_ID AND
			PU.ADD_UNIT = SHIP_ROW.UNIT AND
			PU.PRODUCT_ID = SHIP_ROW.PRODUCT_ID
		GROUP BY
			SHIP_ROW.STOCK_ID,PU.MAIN_UNIT
	</cfquery>
	<cfif TOTAL_MAIN_UNIT_NO GT GET_SHIP_INFO_FOR_INVOICE.TOTAL_MAIN_UNIT_NO>
		<cfif len(GET_SHIP_INFO_FOR_INVOICE.TOTAL_MAIN_UNIT_NO)>
			<cfset irsaliye_fark_NO = TOTAL_MAIN_UNIT_NO - GET_SHIP_INFO_FOR_INVOICE.TOTAL_MAIN_UNIT_NO>
		<cfelse>
			<cfset irsaliye_fark_NO = 0>
		</cfif>
		<cfquery name="GET_STOCKS_PRICE" datasource="#DSN2#" maxrows="1">
		SELECT 
			INVOICE_ROW.STOCK_ID,
			PU.MAIN_UNIT,
			INVOICE_ROW.PRICE/PU.MULTIPLIER AS PRICE_MULT,
			INVOICE_ROW.DISCOUNT1,
			INVOICE_ROW.DISCOUNT2,
			INVOICE_ROW.DISCOUNT3,
			INVOICE_ROW.DISCOUNT4,
			INVOICE_ROW.DISCOUNT5			
		FROM 
			INVOICE,
			INVOICE_ROW,
			#dsn3_alias#.PRODUCT_UNIT AS PU
		WHERE 
			PU.PRODUCT_UNIT_STATUS = 1 AND 
			INVOICE.INVOICE_ID = #URL.IID# AND 
			INVOICE_ROW.STOCK_ID = #STOCK_ID# AND
			INVOICE_ROW.INVOICE_ID = INVOICE.INVOICE_ID AND
			PU.ADD_UNIT = INVOICE_ROW.UNIT AND
			PU.PRODUCT_ID = INVOICE_ROW.PRODUCT_ID
		</cfquery>
		<cfloop query="GET_STOCKS_PRICE">
			<cfscript>
				if (discount1 eq "") new_inv_discount1 = 0; else new_inv_discount1 = discount1;
				if (discount2 eq "") new_inv_discount2 = 0; else new_inv_discount2 = discount2;
				if (discount3 eq "") new_inv_discount3 = 0; else new_inv_discount3 = discount3;
				if (discount4 eq "") new_inv_discount4 = 0; else new_inv_discount4 = discount4;
				if (discount5 eq "") new_inv_discount5 = 0; else new_inv_discount5 = discount5;
				new_fatura_toplam_discount =  GET_STOCKS_PRICE.PRICE_MULT*((100 - new_inv_discount1)/100)*((100 - new_inv_discount2)/100)*((100 - new_inv_discount3)/100)*((100 - new_inv_discount4)/100)*((100 - new_inv_discount5)/100);
			</cfscript>
		</cfloop>
		<cfset irsaliye_fark_TUTAR = irsaliye_fark_NO * new_fatura_toplam_discount>
		<cfset irsaliye_fark_toplam = irsaliye_fark_toplam + irsaliye_fark_TUTAR>
	</cfif>
</cfoutput>
