<cfquery name="GET_SERVICE_OPERATION_PRO" datasource="#dsn3#">
	SELECT
		*
	FROM 
		SERVICE_OPERATION
	WHERE
		SERVICE_ID = #URL.ID#
</cfquery>

<cfset var_ = "service_operation">

<cfset "session.#var_#" = ArrayNew(2)>

<cfloop query="GET_service_OPERATION_PRO">

	<cfset session[var_][currentrow][1] = product_id>
	<cfset session[var_][currentrow][2] = product_name>
	<cfset session[var_][currentrow][3] = paymethod_id>
	<cfset session[var_][currentrow][4] = amount>
	<cfset session[var_][currentrow][5] = unit>
	<cfset session[var_][currentrow][6] = price>
	<cfset session[var_][currentrow][7] = tax>
	<cfset session[var_][currentrow][8] = discount>
	<cfset session[var_][currentrow][9] = catalog_id>
	<cfset session[var_][currentrow][10] = stock_id>
	<cfset session[var_][currentrow][11] = 0>
	<cfset session[var_][currentrow][12] = 0>
	<cfset session[var_][currentrow][13] = 0>
	<cfset session[var_][currentrow][14] = 0>
	<cfset session[var_][currentrow][15] = 0>
	<cfset session[var_][currentrow][16] = 0>
	<cfset session[var_][currentrow][17] = 0>
	<cfset session[var_][currentrow][18] = 0>
	<cfset session[var_][currentrow][19] = 0>
	<cfset session[var_][currentrow][20] = 0>
	<cfset session[var_][currentrow][23] = "">
	<cfset session[var_][currentrow][24] = "">
	<cfset session[var_][currentrow][26] = "">	
	<cfset session[var_][currentrow][27] =0>
	<cfset session[var_][currentrow][28] = 0>	
	<cfset session[var_][currentrow][36] = SESSION.EP.MONEY>
	<cfset session[var_][currentrow][37] = 1>	
	<cfset session[var_][currentrow][39] = "">
	<cfset session[var_][currentrow][40] = "">
	<cfset session[var_][currentrow][41] = 0>		
	<cfset attributes.stock_id = stock_id>
	<cfinclude template="get_stock_name.cfm">
	<cfset session[var_][currentrow][12] = get_stock_name.stock_code>
	<cfset session[var_][currentrow][48] = "">

</cfloop>
