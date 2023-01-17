<!--- SIPARIÞ SATýRLARýNý AL --->
<cfset var_="ship">
<cfinclude template="control_session.cfm">

<cfquery name="ORDER_ROWS" datasource="#dsn3#">
	SELECT
		ORD.*,
		PRODUCT.PRODUCT_NAME,
		STOCKS.PROPERTY,
		PRODUCT.PRODUCT_ID,
		PRODUCT.UNIT
	FROM
		ORDER_ROW ORD,
		PRODUCT,
		STOCKS
	WHERE
		ORD.ORDER_ID = #attributes.ORDER_ID#
		AND
		ORD.STOCK_ID = STOCKS.STOCK_ID
		AND
		STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID
</cfquery>

<!--- SESSION A EKLE --->
<cfloop QUERY="ORDER_ROWS">

	<cfif not isDefined("session.#var_#")>
		<cfset "session.#var_#" = ArrayNew(2)>
	</cfif>
	
	<cfset IsError = "FALSE">
	
	<cfloop from="1" to="#ArrayLen(session[var_])#" index="k">
		<cfif (order_rows.stock_id eq session[var_][k][10]) and (order_rows.order_id eq session[var_][k][12])>
			<cfset IsError = "TRUE">
			<cfset k = ArrayLen(session[var_])>
		</cfif>
	</cfloop>
	
	<cfif IsError is "FALSE">

		<cfset array_poz = ArrayLen(session[var_]) + 1>
	
		<cfset session[var_][array_poz][1]  = order_rows.product_id>
		<cfset session[var_][array_poz][2]  = order_rows.product_name>
		<!--- ödeme metodu --->
 		<cfset session[var_][array_poz][3]  = "">
		<cfset session[var_][array_poz][4]  = order_rows.quantity>
		<cfset session[var_][array_poz][5]  = order_rows.unit>
		<cfset session[var_][array_poz][35]  = order_rows.unit_id>		
		<cfset session[var_][array_poz][6]  = order_rows.price>
		<cfset session[var_][array_poz][7]  = order_rows.taxrate>
		<cfif len(order_rows.discount)>
			<cfset session[var_][array_poz][8]  = order_rows.discount>
		<cfelse>
			<cfset session[var_][array_poz][8]  = 0>
		</cfif>
		<cfset session[var_][array_poz][10] = order_rows.stock_id>
		<cfset session[var_][array_poz][11] = order_rows.order_row_id>
		<cfset session[var_][array_poz][12] = order_rows.order_id>
		<cfset session[var_][array_poz][40] = order_rows.LOT_NO>
		<cfset session[var_][array_poz][41] = order_rows.PRICE_OTHER>		
		<cfset session[var_][array_poz][49] = 0>

	</cfif>

</cfloop>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>

