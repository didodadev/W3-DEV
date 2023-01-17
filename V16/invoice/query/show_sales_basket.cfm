<cfset invoice_bill_upd = arraynew(2) >
<cfif isDefined('INV_ID') and len(INV_ID) >
	<cfquery name="GET_INVOICE_ROW" datasource="#dsn2#">
		SELECT 
			INVOICE_ROW.*,
			INV.INVENTORY_ID AS  STOCK_ID  ,
			INV.INVENTORY_ID AS PRODUCT_ID,
			INVOICE_ROW.DESCRIPTION AS PROPERTY,
			INV.INVENTORY_ID AS  PRODUCT_ID,
			INV.INVENTORY_NAME AS  PRODUCT_NAME
			FROM 
			INVOICE_ROW, 
			#dsn3_alias#.INVENTORY AS INV
		WHERE 
			INV.INVENTORY_ID=#INV_ID# AND
		<cfif not isDefined("attributes.ID")>
			INVOICE_ROW.INVOICE_ID = #URL.IID#
		<cfelse>
			INVOICE_ROW.INVOICE_ID = #attributes.ID#
		</cfif>
		ORDER BY INVOICE_ROW_ID 		
	</cfquery>
<cfelse>
	<cfquery name="GET_INVOICE_ROW" datasource="#dsn2#">
		SELECT 
			INVOICE_ROW.*,
			STOCKS.STOCK_ID,
			STOCKS.PRODUCT_ID,
			STOCKS.PROPERTY,
			PRODUCT.PRODUCT_ID,
			INVOICE_ROW.NAME_PRODUCT AS PRODUCT_NAME
		FROM 
			INVOICE_ROW, 
			#dsn3_alias#.STOCKS AS STOCKS, 
			#dsn3_alias#.PRODUCT AS PRODUCT
		WHERE 
				INVOICE_ROW.STOCK_ID = STOCKS.STOCK_ID 
			AND
				STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID
			AND
			<cfif not isDefined("attributes.ID")>
				INVOICE_ROW.INVOICE_ID = #attributes.IID# <!--- _sil neden integer i liste gibi kullaniyor? --->
			<cfelse>
				INVOICE_ROW.INVOICE_ID = #attributes.ID#
			</cfif>
			ORDER BY INVOICE_ROW_ID 
	</cfquery>
</cfif>
<cfoutput query="get_invoice_row">
	<cfset invoice_bill_upd[currentrow][1] = product_id >
	  <cfif len(property) gt 1>
		<cfset invoice_bill_upd[currentrow][2] = "#product_name#-#property#" >
	  <cfelse>
	  	<cfset invoice_bill_upd[currentrow][2] = "#product_name#">
	  </cfif>
	<cfset invoice_bill_upd[currentrow][4] = amount >
	<cfset invoice_bill_upd[currentrow][5] = unit >
	<cfset invoice_bill_upd[currentrow][35] = unit_id >	
	<cfset invoice_bill_upd[currentrow][6] = price >	
	<cfset invoice_bill_upd[currentrow][8] = discounttotal >
	<cfset invoice_bill_upd[currentrow][10] = stock_id >
	<cfset invoice_bill_upd[currentrow][14] = pay_method >
	<cfset invoice_bill_upd[currentrow][15] = amount*price >
	<cfset invoice_bill_upd[currentrow][16] = nettotal >
	<cfset invoice_bill_upd[currentrow][17] = taxtotal >
	<cfset invoice_bill_upd[currentrow][18] = grosstotal >
	<cfset invoice_bill_upd[currentrow][19] = 0 >
	<cfset invoice_bill_upd[currentrow][20] = 0 > 
	<cfset invoice_bill_upd[currentrow][27] = 0 >
	<cfset invoice_bill_upd[currentrow][26] = spect_var_id >
	<cfset invoice_bill_upd[currentrow][39] = spect_var_name >
	<cfset invoice_bill_upd[currentrow][40] = LOT_NO >
	<cfset invoice_bill_upd[currentrow][41] = PRICE_OTHER >
	<cfset invoice_bill_upd[currentrow][28] = 0 >
	<cfif len(TAX) >
		<cfset invoice_bill_upd[currentrow][7] = TAX >
	<cfelse>
		<cfif nettotal neq 0 >
			<cfset invoice_bill_upd[currentrow][7] = (taxtotal/nettotal)*100 > 
		<cfelse>	
			<cfset invoice_bill_upd[currentrow][7] = 0 >
		</cfif>
	</cfif>
</cfoutput>
