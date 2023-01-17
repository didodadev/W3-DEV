<cfquery name="GET_SHIP_ROW" datasource="#dsn2#">
	SELECT 
		* 
	FROM 
		SHIP_ROW
	WHERE 
		SHIP_ID=#attributes.SHIP_ID#
	ORDER BY SHIP_ROW_ID
</cfquery>
<cfif not isdefined("attributes.dispatch_true")>
	<cfif isDefined("attributes.this_is_view")><cfset var_="ship_sale_view_upd"><cfelse><cfset var_= "ship_sale_upd"></cfif>
</cfif>
<cfset array_poz=1>
<cfset satir_serino_index = 1>
<cfoutput query="get_ship_row">
	
	<cfquery name="GET_PRODUCT_DETAIL" datasource="#dsn3#">
		SELECT 
			* 
		FROM
			STOCKS,
			PRODUCT
		WHERE
			STOCKS.PRODUCT_ID=PRODUCT.PRODUCT_ID
			AND
			PRODUCT.PRODUCT_ID=#GET_SHIP_ROW.PRODUCT_ID#
	</cfquery>
	<cfquery name="GET_STOCK_CODE" datasource="#dsn3#">
		SELECT 
			* 
		FROM 
			STOCKS 
		WHERE 
			STOCK_ID=#GET_SHIP_ROW.STOCK_ID#
	</cfquery>
	<cfset session[var_][array_poz][42] =  "">
	<cfset session[var_][array_poz][43] =  "">
	<cfset session[var_][array_poz][44] =  "">
	<cfset session[var_][array_poz][45] =  "">
	<cfset session[var_][array_poz][46] =  "">
	<cfset session[var_][array_poz][47] =  "">
	<cfset session[var_][array_poz][48] =  "">
	<cfscript>
	session[var_][array_poz][1] = get_product_detail.product_id;
	session[var_][array_poz][13]= get_product_detail.MANUFACT_CODE;
	session[var_][array_poz][2] = get_ship_row.name_product;
	session[var_][array_poz][10] =get_ship_row.stock_id;
	session[var_][array_poz][11]= get_product_detail.barcod;
	session[var_][array_poz][4] = get_ship_row.amount;
	session[var_][array_poz][3] = get_ship_row.paymethod_id; 
	session[var_][array_poz][5] = get_ship_row.unit;
	session[var_][array_poz][35] = get_ship_row.unit_id;	
	session[var_][array_poz][6] = get_ship_row.price;
	if(len(get_ship_row.PRICE_OTHER))
		session[var_][array_poz][41] = get_ship_row.PRICE_OTHER;	
	else
		session[var_][array_poz][41] = get_ship_row.PRICE;
	session[var_][array_poz][7] = get_ship_row.tax;
	session[var_][array_poz][8] = get_ship_row.discount;
	session[var_][array_poz][26] = get_ship_row.spect_var_id; 
	session[var_][array_poz][39] = get_ship_row.spect_var_name; 
	session[var_][array_poz][40] = get_ship_row.LOT_NO; 
	session[var_][array_poz][15]= get_ship_row.amount * get_ship_row.price;
	session[var_][array_poz][16] = (session[var_][array_poz][15]/100)*(100-get_ship_row.discount);
	session[var_][array_poz][17] = session[var_][array_poz][16]*(get_ship_row.tax/100);
	session[var_][array_poz][18] = session[var_][array_poz][16]+session[var_][array_poz][17];
	session[var_][array_poz][19]=0;
	session[var_][array_poz][20]=0; 
	
	session[var_][array_poz][24] = "" ;
	session[var_][array_poz][14] = "" ;
	session[var_][array_poz][23] = "" ;
	session[var_][array_poz][36] = OTHER_MONEY;
	if(len(OTHER_MONEY_VALUE))
		session[var_][array_poz][37] = OTHER_MONEY_VALUE;	
	else
		session[var_][array_poz][37] = 	session[var_][array_poz][18];		
	
	session[var_][array_poz][49] = OTHER_MONEY_GROSS_TOTAL;
	session[var_][array_poz][23] = dateformat(DELIVER_DATE,dateformat_style); 
	
	if (len(DELIVER_LOC))
		session[var_][array_poz][24]=DELIVER_DEPT & "-" & DELIVER_LOC ; 
	else
		session[var_][array_poz][24]=DELIVER_DEPT ; 
	if (len(DISCOUNT2))
		session[var_][array_poz][19]=DISCOUNT2; 
	else
		session[var_][array_poz][19]=0; 
	if (len(DISCOUNT3))
		session[var_][array_poz][20]=DISCOUNT3; 
	else
		session[var_][array_poz][20]=0; 
	if (len(DISCOUNT4))
		session[var_][array_poz][27]=DISCOUNT4; 
	else
		session[var_][array_poz][27]=0; 
	if (len(DISCOUNT5))
		session[var_][array_poz][28]=DISCOUNT5;
	else
		session[var_][array_poz][28]=0;
	session[var_][array_poz][12] = get_stock_code.stock_code;
	
	
	array_poz = array_poz + 1;
	</cfscript>
</cfoutput>
<!--- _sil deneniyor 20031028 30 gün icinde silinsin...
<cfquery name="GET_DET_SHIP" datasource="#dsn2#">
	SELECT * FROM SHIP WHERE SHIP_ID=#attributes.SHIP_ID#
</cfquery>
	
	<cfset session.rate1=get_det_ship.rate1>
	<cfset session.rate2=get_det_ship.rate2>
	<cfset "session.total_sale_upd" =get_det_ship.grosstotal>
	<cfset "session.discount_sale_upd" = get_det_ship.discounttotal>
	<cfset "session.total_tax_sale_upd" = get_det_ship.taxtotal>
	<cfset "session.net_total_sale_upd" = get_det_ship.nettotal>
<cfif not isDefined("session.rate1")>
	<cfset session.rate1 = 1>
	<cfset session.rate2 = 1>
</cfif> --->
