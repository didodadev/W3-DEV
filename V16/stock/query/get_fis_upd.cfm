<cfinclude template="get_fis_det.cfm">
<cfset Session.ship_fis_upd = ArrayNew(2)>
<cfset var_="ship_fis_upd">
<cfset satir_serino_index = 1>

<cfoutput query="GET_FIS_DET" >
		<cfset session[var_][currentrow][10] =stock_id>
		<cfset session[var_][currentrow][4] = amount>
		<cfset session[var_][currentrow][5] = unit>
		<cfset session[var_][currentrow][35] = unit_id>		
		<cfset session[var_][currentrow][6] = TOTAL>
		<cfset session[var_][currentrow][7] = tax>
		<cfset session[var_][currentrow][8] = 0 >
		<cfset session[var_][currentrow][19] = 0 >
		<cfset session[var_][currentrow][20] = 0 >
		<cfset session[var_][currentrow][27] = 0 >
		<cfset session[var_][currentrow][28] = 0 >
		<cfset session[var_][currentrow][36] = session.ep.money>
		<cfset session[var_][currentrow][37] = 1>
		<cfset session[var_][currentrow][17] = TOTAL_TAX>
		<cfquery name="GET_PRODUCT" datasource="#dsn3#">
			SELECT 
				*
			FROM
				STOCKS
			WHERE 
				STOCK_ID=#SESSION[VAR_][currentrow][10]#
		</cfquery>
		<cfset session[var_][currentrow][1] = get_product.product_id>
		<cfset session[var_][currentrow][11] = get_product.barcod>
		<cfset session[var_][currentrow][12] = get_product.stock_code>
		
		<cfquery name="GET_PRODUCT_NAME" datasource="#dsn3#">
			SELECT 
				PRODUCT_ID,
				PRODUCT_NAME
			FROM
				PRODUCT
			WHERE 
				PRODUCT_ID=#SESSION[VAR_][currentrow][1]#
		</cfquery>
		<cfset session[var_][currentrow][2] = get_product_name.product_name>
		<cfset session[var_][currentrow][18] = 0 >
		<cfset session[var_][currentrow][15] = 0 >
		<cfset session[var_][currentrow][16] = 0 >		
		<cfset session[var_][currentrow][14] = "" >
		<cfset session[var_][currentrow][13] = "" >
		<cfset session[var_][currentrow][24] = "" >
		<cfset session[var_][currentrow][23] = "" >
		<cfset session[var_][currentrow][26] = spect_var_id>
		<cfset session[var_][currentrow][39] = spect_var_name>
		<cfset session[var_][currentrow][40] = LOT_NO>
		<cfset session[var_][currentrow][41] = 0>
</cfoutput>
