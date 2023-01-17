<cfquery name="GET_ORDER_ROWS" datasource="#dsn3#">
	  SELECT 
	  	* 
	  FROM 
	  	ORDER_ROW ORR, PRODUCT P, STOCKS S
	  WHERE 
		  ORR.ORDER_ID =  #URL.ORDER_ID# AND 
		  P.PRODUCT_ID = S.PRODUCT_ID AND
		  S.STOCK_ID = ORR.STOCK_ID
</cfquery>
