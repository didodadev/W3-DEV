<cfquery name="GET_CATALOG_PRODUCT" datasource="#dsn3#">
	SELECT 
		* 
	FROM 
		CATALOG_PRODUCTS CP, 
		PRODUCT P
	WHERE 
		CP.CATALOG_ID = #URL.ID# 
		AND 
		P.PRODUCT_ID = CP.PRODUCT_ID					  
</cfquery>

<cfif not isDefined("attributes.kek")>
	<cfset var_="Cat_Pro_Add">
<cfelse>
	<cfset var_="temp_dsp_catalog">
</cfif>
	
<cfset Session.Cat_Pro_Add = ArrayNew(2)>

<cfoutput query="get_catalog_product">
	<cfquery name="GET_STOCK_NAME" datasource="#dsn3#">
		SELECT STOCK_CODE FROM STOCKS
			WHERE STOCK_ID = #STOCK_ID#
	</cfquery>
	<cfscript>
	session[var_][currentrow][1] = product_id;
	session[var_][currentrow][2] = product_name;
	session[var_][currentrow][3] = "";
	session[var_][currentrow][4] = quantity;
	if (isDefined("unit"))
		session[var_][currentrow][5] = unit;
	session[var_][currentrow][6] = listprice;
	if (isDefined("tax"))
		session[var_][currentrow][7] = tax;
	else
		session[var_][currentrow][7] = 0;
	 session[var_][currentrow][8] = DISCOUNT1; // indirim 
	 session[var_][currentrow][9] = 0; // catalog_id 
	 session[var_][currentrow][10] = stock_id;
	 session[var_][currentrow][11] = 0; //  barcod
	 session[var_][currentrow][13] = 0; // manufact_code
	 session[var_][currentrow][14] = "";
	 session[var_][currentrow][15] = 0;
	 session[var_][currentrow][16] = 0;
	 session[var_][currentrow][17] = 0;
	 session[var_][currentrow][18] = 0;						
	 session[var_][currentrow][19] = DISCOUNT2; // indirim 
	 session[var_][currentrow][20] = DISCOUNT3; // indirim 
	 session[var_][currentrow][23]= "";
	 session[var_][currentrow][24] = "";
	 session[var_][currentrow][26] = spect_var_id;
	 session[var_][currentrow][39] = spect_var_name;
 	 session[var_][currentrow][40] = "";
	 session[var_][currentrow][42] = "";
	 session[var_][currentrow][43] = "";
	 session[var_][currentrow][44] = "";
	 session[var_][currentrow][45] = "";
	 session[var_][currentrow][46] = "";
	 session[var_][currentrow][47] = "";
 	 session[var_][currentrow][48] = "";
	
 	 session[var_][currentrow][41] = 0;
	 session[var_][currentrow][27] = DISCOUNT4;
	 session[var_][currentrow][28] = DISCOUNT5;
	 session[var_][currentrow][36] = SESSION.EP.MONEY;
	 session[var_][currentrow][37] = 1;
	 attributes.stock_id = stock_id;
	 session[var_][currentrow][12] = get_stock_name.stock_code;
	 session[var_][currentrow][15] = "0";
	</cfscript>
</cfoutput>
