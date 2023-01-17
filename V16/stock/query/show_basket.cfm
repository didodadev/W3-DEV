<cfset invoice_bill_upd=arraynew(2)>
<cfif isDefined('INV_ID') and len(INV_ID)>
	<cfquery name="GET_INVOICE_ROW" datasource="#dsn2#">
		SELECT 
			INVOICE_ROW.*,
			INV.INVENTORY_ID AS STOCK_ID,
			INV.INVENTORY_ID AS PRODUCT_ID,
			INVOICE_ROW.DESCRIPTION AS PROPERTY,
			INV.INVENTORY_ID AS PRODUCT_ID,
			INV.INVENTORY_NAME AS PRODUCT_NAME
		FROM 
			INVOICE_ROW, 
			#dsn_alias#.INVENTORY AS INV
		WHERE 
			INV.INVENTORY_ID=#INV_ID# AND
		<cfif NOT isDefined("attributes.ID")>
			INVOICE_ROW.INVOICE_ID = #attributes.IID#
		<cfelse>
			INVOICE_ROW.INVOICE_ID = #attributes.ID#
		</cfif>
	</cfquery>
<cfelse>
	<cfquery name="GET_INVOICE_ROW" datasource="#dsn3#">
		SELECT 
			IR.*,
			STOCKS.STOCK_ID,
			STOCKS.PRODUCT_ID,
			STOCKS.PROPERTY,
			PRODUCT.PRODUCT_ID,
			PRODUCT.PRODUCT_NAME
		FROM 
			#dsn2_alias#.INVOICE_ROW AS IR, 
			STOCKS AS STOCKS, 
			PRODUCT AS PRODUCT
		WHERE 
			IR.STOCK_ID = STOCKS.STOCK_ID 
			AND
			STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID
			AND
		<cfif NOT isDefined("attributes.ID")>
			IR.INVOICE_ID = #attributes.IID#
		<cfelse>
			IR.INVOICE_ID = #attributes.ID#
		</cfif>
	</cfquery>
</cfif>
<cfoutput query="get_invoice_row">
		<cfset invoice_bill_upd[currentrow][1] = product_id>
		<cfset invoice_bill_upd[currentrow][2] = "#product_name#-#property#">
		<cfset invoice_bill_upd[currentrow][4] = amount>
		<cfset invoice_bill_upd[currentrow][5] = unit>
		<cfset invoice_bill_upd[currentrow][35] = unit_id>		
		<cfset invoice_bill_upd[currentrow][6] = price>	
		<cfif len(ptice_other)>
			<cfset invoice_bill_upd[currentrow][41] = price_other>
		<cfelse>
			<cfset invoice_bill_upd[currentrow][41] = price>		
		</cfif>
		<cfset invoice_bill_upd[currentrow][8] = discounttotal>
		<cfset invoice_bill_upd[currentrow][10] = stock_id>
		<cfset invoice_bill_upd[currentrow][14] = pay_method>
		<cfset invoice_bill_upd[currentrow][15] = amount*price>
		<cfset invoice_bill_upd[currentrow][16] = nettotal>
		<cfset invoice_bill_upd[currentrow][17] = taxtotal>
		<cfset invoice_bill_upd[currentrow][18] = grosstotal>
		<cfset invoice_bill_upd[currentrow][19] = 0>
		<cfset invoice_bill_upd[currentrow][20] = 0> 
		<cfset invoice_bill_upd[currentrow][49] = OTHER_MONEY_GROSS_TOTAL>
		<cfset invoice_bill_upd[currentrow][7] = (taxtotal/nettotal)*100> 
</cfoutput>
