<cfif not isDefined("order_purchase")>
	<cfquery name="GET_ORDER_PRODUCTS" datasource="#dsn3#">
		SELECT
			*
		FROM 
			ORDER_ROW
		WHERE
			ORDER_ID = #attributes.order_id#
			<cfif isdefined("attributes.deliver_dept") and len(attributes.deliver_dept)>
				AND DELIVER_DEPT=#attributes.deliver_dept#
			</cfif>
	</cfquery>
	<cfset session.ship_order_row_list = ValueList(GET_ORDER_PRODUCTS.ORDER_ROW_ID)>
	<cfset "session.#var_#" = ArrayNew(2)>
	<cfloop query="get_order_products">
		
		<cfquery name="GET_PRODUCT_NAME" datasource="#DSN3#">
			SELECT
				STOCKS.PRODUCT_NAME,
				STOCKS.BARCOD,
				PRODUCT.MANUFACT_CODE
			FROM
				PRODUCT,
				STOCKS 
			WHERE 
				STOCKS.PRODUCT_ID=PRODUCT.PRODUCT_ID
				AND
				STOCKS.PRODUCT_ID= #PRODUCT_ID#
				AND
				STOCKS.STOCK_ID=#stock_id#
		</cfquery>
				
		<cfset attributes.stock_id = stock_id>
		<cfinclude template="get_stock_name.cfm">
		<cfscript>
		if (NOT len(PRODUCT_NAME))
			PRODUCT_NM=GET_PRODUCT_NAME.PRODUCT_NAME;
		else
			PRODUCT_NM=PRODUCT_NAME;
		session[var_][currentrow][27] = discount_4 ;
		session[var_][currentrow][28] = discount_5 ;
		if (len(DELIVER_LOCATION))
			session[var_][currentrow][24] = "#DELIVER_DEPT#-#DELIVER_LOCATION#" ;
		else
			session[var_][currentrow][24] = DELIVER_DEPT ;
		if (len(DELIVER_DATE))
			session[var_][currentrow][23] = dateformat(DELIVER_DATE,dateformat_style) ;
		else
			session[var_][currentrow][23] = "" ;
		session[var_][currentrow][26] = spect_var_id;
		session[var_][currentrow][39] = spect_var_name;
		session[var_][currentrow][40] = LOT_NO;		
		session[var_][currentrow][1] = PRODUCT_ID;
		session[var_][currentrow][3] = paymethod_id;
		session[var_][currentrow][4] = quantity;
		session[var_][currentrow][5] = unit;
		session[var_][currentrow][35] = unit_id;		
		session[var_][currentrow][6] = price;
		if(len(PRICE_OTHER))
			session[var_][currentrow][41] = PRICE_OTHER;
		else
			session[var_][currentrow][41] = PRICE;		
		session[var_][currentrow][7] = tax;
		session[var_][currentrow][10] = stock_id;
		session[var_][currentrow][14] = duedate;
		session[var_][currentrow][2] = PRODUCT_NM;
		session[var_][currentrow][8] = DISCOUNT_1;
		session[var_][currentrow][19] = DISCOUNT_2;
		session[var_][currentrow][20] = DISCOUNT_3;
		session[var_][currentrow][27] = DISCOUNT_4;
		session[var_][currentrow][28] = DISCOUNT_5;		
		session[var_][currentrow][36] = OTHER_MONEY;
		session[var_][currentrow][49] = (OTHER_MONEY_VALUE*(tax+100))/100;	
		session[var_][currentrow][9] = 0;
		session[var_][currentrow][13] = GET_PRODUCT_NAME.MANUFACT_CODE;
		session[var_][currentrow][11] = GET_PRODUCT_NAME.BARCOD;
		session[var_][currentrow][12] = get_stock_name.stock_code;
		session[var_][currentrow][15] = session[var_][currentrow][4] * session[var_][currentrow][6];
		session[var_][currentrow][16] = session[var_][currentrow][15] - ( session[var_][currentrow][15]*(session[var_][currentrow][8]/100) )  - ( session[var_][currentrow][15]*(session[var_][currentrow][19]/100) )  - ( session[var_][currentrow][15]*(session[var_][currentrow][20]/100) ) ;
		session[var_][currentrow][17] = session[var_][currentrow][16] * (session[var_][currentrow][7]/100);
		session[var_][currentrow][18] = session[var_][currentrow][16] + session[var_][currentrow][17];
		if(len(OTHER_MONEY_VALUE))
			session[var_][currentrow][37] = OTHER_MONEY_VALUE;	
		else
			session[var_][currentrow][37] = session[var_][currentrow][18];	
		

	       session[var_][currentrow][42] = "";
		   session[var_][currentrow][43] = "";
		   session[var_][currentrow][44] = "";
		   session[var_][currentrow][45] = "";
		   session[var_][currentrow][46] = "";
		   session[var_][currentrow][47] = "";
		   session[var_][currentrow][48] = "";
		</cfscript>
	</cfloop>
  <cfelse>	
	<cfquery name="GET_ORDER_PRODUCTS" datasource="#dsn3#">
		SELECT
			*
		FROM 
			ORDER_ROW
		WHERE
			ORDER_ID = #attributes.order_id#
	</cfquery>	
	<cfset var_ = "GiveOrder_upd">
	<cfset "session.#var_#" = ArrayNew(2)>
	<cfloop query="get_order_products">
		<cfquery name="GET_STOCK_NAME" datasource="#dsn3#">
			SELECT 
				STOCK_CODE,PRODUCT.PRODUCT_ID,STOCKS.BARCOD,PRODUCT_NAME,PRODUCT.MANUFACT_CODE
			FROM
				PRODUCT,
				STOCKS 
			WHERE 
				STOCKS.PRODUCT_ID=PRODUCT.PRODUCT_ID
				AND
				STOCKS.PRODUCT_ID= #PRODUCT_ID#
				AND
				STOCKS.STOCK_ID=#stock_id#				
		</cfquery>
			
		
		<cfscript>
		if (NOT len(PRODUCT_NAME))
			PRODUCT_NM=GET_STOCK_NAME.PRODUCT_NAME;
		else
			PRODUCT_NM=PRODUCT_NAME;
		session[var_][currentrow][8] = DISCOUNT_1;
		session[var_][currentrow][19] = DISCOUNT_2;
		session[var_][currentrow][20] = DISCOUNT_3;	
		session[var_][currentrow][27] = DISCOUNT_4 ;
		session[var_][currentrow][28] = DISCOUNT_5 ;		
		if (LEN(DELIVER_LOCATION))
			session[var_][currentrow][24] = "#DELIVER_DEPT#-#DELIVER_LOCATION#";
		else
			session[var_][currentrow][24] = DELIVER_DEPT;
		if (len(DELIVER_DATE))
			session[var_][currentrow][23] = dateformat(DELIVER_DATE,dateformat_style);
		else
			session[var_][currentrow][23] = "";
		session[var_][currentrow][1] = get_stock_name.product_id; 
		session[var_][currentrow][2] = PRODUCT_NM; 
		session[var_][currentrow][3] = pay_method;
		session[var_][currentrow][4] = quantity;
		if (isDefined("unit"))
			session[var_][currentrow][5] = unit;
		session[var_][currentrow][35] = unit_id;
		session[var_][currentrow][6] = price;
		if(len(PRICE_OTHER))
			session[var_][currentrow][41] = PRICE_OTHER;
		else
			session[var_][currentrow][41] = PRICE;
		if (isDefined("tax"))
			session[var_][currentrow][7] = tax;
		else
			session[var_][currentrow][7] = 0;
		session[var_][currentrow][10] = stock_id;
		session[var_][currentrow][14] = 0;
		session[var_][currentrow][15] = price;
		session[var_][currentrow][26] = spect_var_id;
		session[var_][currentrow][39] = spect_var_name;
		session[var_][currentrow][40] = LOT_NO;			
		session[var_][currentrow][9] = 0;
		session[var_][currentrow][13] = GET_STOCK_NAME.MANUFACT_CODE;
		session[var_][currentrow][11] = GET_STOCK_NAME.BARCOD;
		session[var_][currentrow][36] = OTHER_MONEY;
		session[var_][currentrow][14] = "";		
		session[var_][currentrow][15] = session[var_][currentrow][4]*session[var_][currentrow][6];	
		session[var_][currentrow][16] = session[var_][currentrow][15] - ( session[var_][currentrow][15]*(session[var_][currentrow][8]/100) )  - ( session[var_][currentrow][15]*(session[var_][currentrow][19]/100) )  - ( session[var_][currentrow][15]*(session[var_][currentrow][20]/100) ) ;
		session[var_][currentrow][17] = session[var_][currentrow][16] * (session[var_][currentrow][7]/100);
		session[var_][currentrow][18] = session[var_][currentrow][16] + session[var_][currentrow][17];
		session[var_][currentrow][12] = get_stock_name.stock_code;
		if(len(OTHER_MONEY_VALUE))
			session[var_][currentrow][37] = OTHER_MONEY_VALUE;
		else
			session[var_][currentrow][37] = session[var_][currentrow][18];
	       
		   session[var_][currentrow][42] = "";
		   session[var_][currentrow][43] = "";
		   session[var_][currentrow][44] = "";
		   session[var_][currentrow][45] = "";
		   session[var_][currentrow][46] = "";
		   session[var_][currentrow][47] = "";
		   session[var_][currentrow][48] = "";
		</cfscript>
	</cfloop>
</cfif>
