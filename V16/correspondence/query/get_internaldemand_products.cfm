<cfquery name="GET_INTERNALDEMAND_PRODUCTS" datasource="#dsn3#">
	SELECT
		*
	FROM 
		INTERNALDEMAND_ROW
	WHERE
		I_ID = #attributes.ID#
</cfquery>
<cfscript>
"session.#var_#" = ArrayNew(2);
for (i = 1; i lte GET_INTERNALDEMAND_PRODUCTS.recordcount;i=i+1)
	{
	session[var_][i][1] = GET_INTERNALDEMAND_PRODUCTS.product_id[i];
	session[var_][i][3] = GET_INTERNALDEMAND_PRODUCTS.pay_method_id[i];
	session[var_][i][4] = GET_INTERNALDEMAND_PRODUCTS.quantity[i];
	session[var_][i][5] = GET_INTERNALDEMAND_PRODUCTS.unit[i];
	session[var_][i][6] = GET_INTERNALDEMAND_PRODUCTS.price[i];
	session[var_][i][7] = GET_INTERNALDEMAND_PRODUCTS.tax[i];
	session[var_][i][8] = GET_INTERNALDEMAND_PRODUCTS.discount_1[i];
	session[var_][i][9] = 0;
	session[var_][i][10] = GET_INTERNALDEMAND_PRODUCTS.stock_id[i];
	session[var_][i][11] = 0;
	session[var_][i][13] = 0;
	session[var_][i][41] = GET_INTERNALDEMAND_PRODUCTS.price[i];
	session[var_][i][14] = GET_INTERNALDEMAND_PRODUCTS.duedate[i];
	session[var_][i][19] = GET_INTERNALDEMAND_PRODUCTS.discount_2[i];
	session[var_][i][20] = GET_INTERNALDEMAND_PRODUCTS.discount_3[i];
	session[var_][i][23] = dateformat(GET_INTERNALDEMAND_PRODUCTS.deliver_date[i],dateformat_style);
	session[var_][i][24] = GET_INTERNALDEMAND_PRODUCTS.deliver_dept[i];
	session[var_][i][36] = SESSION.EP.MONEY;
	session[var_][i][37] = 1;
	
	SQLString = "
		SELECT
			PRODUCT.PRODUCT_NAME,
			STOCKS.PROPERTY,
			STOCKS.STOCK_CODE
		FROM
			PRODUCT,
			STOCKS
		WHERE
			STOCKS.STOCK_ID = #GET_INTERNALDEMAND_PRODUCTS.stock_id[i]#
			AND
			PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID";
	get_stock_name = cfquery(SQLString : SQLString, Datasource : DSN3);
	session[var_][i][12] = get_stock_name.stock_code;
	session[var_][i][2] = get_stock_name.product_name&' - '&get_stock_name.property;
	session[var_][i][15] = session[var_][i][4] * session[var_][i][6];
	session[var_][i][16] = (session[var_][i][15]/1000000) * ( (100-session[var_][i][8]) * (100-session[var_][i][19]) * (100-session[var_][i][20]) );
	session[var_][i][17] = session[var_][i][16] * (session[var_][i][7]/100);
	session[var_][i][18] = session[var_][i][16] + session[var_][i][17];
	session[var_][i][26] = "";
	session[var_][i][40] = "";
	session[var_][i][39] = "";
	session[var_][i][27] = 0;			
	session[var_][i][28] = 0;				
	}
</cfscript>
<cfinclude template="get_internaldemand.cfm">
<cfoutput query="get_internaldemand">
	<cfset session.total_demand_upd=get_internaldemand.total>
	<cfset session.net_total_demand_upd=get_internaldemand.net_total>
	<cfset session.total_tax_demand_upd=get_internaldemand.total_tax>				
	<cfset session.discount_demand_upd=get_internaldemand.discount>
</cfoutput>
