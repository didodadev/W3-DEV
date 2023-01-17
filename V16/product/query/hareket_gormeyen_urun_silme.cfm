		<cfquery name="get_stocks_row" datasource="#dsn2#">			
			SELECT 
				COUNT(STOCK_ID) AS SATIR,
				PRODUCT_ID,STOCK_ID
			FROM 	
				STOCKS_ROW
			WHERE 
				PRODUCT_ID NOT IN (SELECT P.PRODUCT_ID FROM #dsn3_alias#.PRODUCT P,INVOICE_ROW IR WHERE P.PRODUCT_ID = IR.PRODUCT_ID AND P.IS_INVENTORY = 0)
				<!--- BU KISIM ERSAN ICIN EKLENMISTIR --->
				AND
				PRODUCT_ID IN
				(
					SELECT 
						PRODUCT_ID 
					FROM 
						#dsn3_alias#.PRODUCT 
					WHERE 
						PRODUCT_CATID=1252
				)
			GROUP BY 
				PRODUCT_ID,STOCK_ID
			HAVING 
				COUNT(STOCK_ID)< 2
		</cfquery>
		<cfset del_prod="">
		
		<cfoutput query="get_stocks_row">	
			<!--- Donem Db sinden Silme İslemleri--->
			<cfquery name="del_stocks_row" datasource="#dsn2#">
				DELETE FROM STOCKS_ROW WHERE PRODUCT_ID=#get_stocks_row.PRODUCT_ID#
			</cfquery>
			<!--- //Donem Db sinden Silme İslemleri--->
			<!--- Sirket Db sinden Silme İslemleri--->
			<cfquery name="del_catalog" datasource="#dsn3#">
				DELETE FROM CATALOG_PROMOTION_PRODUCTS WHERE PRODUCT_ID=#get_stocks_row.PRODUCT_ID#
				DELETE FROM PRICE_DELETED_ROWS WHERE PRODUCT_ID=#get_stocks_row.PRODUCT_ID#
				DELETE FROM PRICE_HISTORY WHERE PRODUCT_ID=#get_stocks_row.PRODUCT_ID#
				DELETE FROM PRICE WHERE PRODUCT_ID=#get_stocks_row.PRODUCT_ID#
			</cfquery>
			<!--- //Sirket Db sinden Silme İslemleri--->
			<!--- Product Db sinden Silme İslemleri--->
			<cfquery name="del_stocks_barcodes" datasource="#dsn1#">
				DELETE FROM STOCKS_BARCODES WHERE STOCK_ID=#get_stocks_row.STOCK_ID#		
				DELETE FROM STOCKS WHERE PRODUCT_ID=#get_stocks_row.PRODUCT_ID#
				DELETE FROM PRICE_STANDART WHERE PRODUCT_ID=#get_stocks_row.PRODUCT_ID#
				DELETE FROM PRODUCT_OUR_COMPANY WHERE PRODUCT_ID=#get_stocks_row.PRODUCT_ID#
				DELETE FROM PRODUCT_UNIT WHERE PRODUCT_ID=#get_stocks_row.PRODUCT_ID#
				DELETE FROM PRODUCT WHERE PRODUCT_ID=#get_stocks_row.PRODUCT_ID#
			</cfquery>
			<!--- //Product Db sinden Silme İslemleri--->
		</cfoutput>

		<cfset del_prod=ListAppend(del_prod,get_stocks_row.PRODUCT_ID,',')>	

		<cfoutput>#del_prod#</cfoutput>
		<!--- <cfoutput> #ListToArray(del_prod,',')#<br/></cfoutput> --->

