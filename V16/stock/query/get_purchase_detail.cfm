<cfloop query="PURCHASE">
<cfset var_="SHIP">
	<cfif not isDefined("session.#var_#")>
		<cfset "session.#var_#" = ArrayNew(2)>
	</cfif>
	
	<cfset IsError = "FALSE">
	
	<cfloop from="1" to="#ArrayLen(session[var_])#" index="k">
		<cfif purchase.stock_id eq session[var_][k][10]>
			<cfset IsError = "TRUE">
			<cfset k = ArrayLen(session[var_])>
		</cfif>
	</cfloop>
	
	<cfif IsError is "FALSE">

		<cfset array_poz = ArrayLen(session[var_]) + 1>
	
		<cfset session[var_][array_poz][1]  = purchase.product_id>
		<cfset session[var_][array_poz][2]  = purchase.product_name>
		<cfset session[var_][array_poz][3]  = purchase.paymethod_id>
		<cfset session[var_][array_poz][4]  = purchase.amount>
		<cfset session[var_][array_poz][5]  = purchase.unit>
		<cfset session[var_][array_poz][35]  = purchase.unit_id>		
		<cfset session[var_][array_poz][6]  = purchase.price>
		<cfif len(purchase.price_other) >
			<cfset session[var_][array_poz][41]  = purchase.price_other >
		<cfelse>
			<cfset session[var_][array_poz][41]  = purchase.price >		
		</cfif>
		<cfset session[var_][array_poz][7]  = purchase.tax>
		<cfset session[var_][array_poz][8]  = purchase.discount>
		<cfset session[var_][array_poz][9]  = purchase.catalog_id>
		<cfset session[var_][array_poz][10] = purchase.stock_id>
		<cfset session[var_][array_poz][11] = purchase.ship_row_id>
		<cfset session[var_][array_poz][49] = 0>		
		
	</cfif>
	
</cfloop>
