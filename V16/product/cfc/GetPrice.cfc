<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cfset DSN1="#DSN#_product">
	<cfset DSN2=#DSN# & "_"&#DateTimeFormat(now(),"yyyy")#&"_"&#session.ep.company_id#>
	<cfset DSN3=#DSN#&"_"&#session.ep.company_id#>

<cffunction name="getPrice" access="remote" returntype="any"  returnformat="plain">
	  <cfargument name="product_id" required="true">
      <cfargument name="prod_detail" required="true">
      <cfargument name="prod_varyasyon" required="true">
      <cfargument name="price_id" required="true">
           
   <cfquery name="prices" datasource="#DSN1#">
		SELECT 
		    PPD.PROPERTY_DETAIL_ID,
		    PPD.PROPERTY_DETAIL,
		    SP.STOCK_ID,
		    SP.PROPERTY_ID,
			P.PRODUCT_NAME + ' ' + S.PROPERTY as 'PRODUCT_NAME',
			PU.MAIN_UNIT,
			PU.PRODUCT_UNIT_ID,
			P.TAX,
			P.TAX_PURCHASE,
			P.PRODUCT_ID,
			ISNULL(PC.PURCHASE_NET_SYSTEM,0) AS SISTEM_MALIYET,
			ISNULL(PC.PURCHASE_EXTRA_COST_SYSTEM,0) AS EK_MALIYET,
		  		CASE 
					WHEN L1.PRICE IS NULL
				THEN
		    ISNULL(L2.PRICE,0)
				ELSE 
			ISNULL(L1.PRICE,0)
			END AS PRICE,
			ISNULL(L1.MONEY,'TL')as MONEY
		FROM 
			PRODUCT_PROPERTY_DETAIL PPD
			INNER JOIN STOCKS_PROPERTY SP ON  PPD.PRPT_ID = SP.PROPERTY_ID
			INNER JOIN STOCKS S ON  PPD.PROPERTY_DETAIL_ID = SP.PROPERTY_DETAIL_ID
			INNER JOIN PRODUCT P ON S.PRODUCT_ID = P.PRODUCT_ID
			INNER JOIN PRODUCT_UNIT PU ON P.PRODUCT_ID = PU.PRODUCT_ID AND PU.IS_MAIN = 1 
			LEFT JOIN PRODUCT_COST PC ON PC.PRODUCT_ID = P.PRODUCT_ID 
			LEFT JOIN (SELECT
					STOCKS.PRODUCT_ID,
					STOCKS.STOCK_ID, 
					PRICE.UNIT,
					PRICE.PRICE,
					PRICE.PRICE_KDV,
					PRICE.MONEY
				 FROM 
					#dsn3#..PRICE,
					STOCKS 
				WHERE 
					PRICE.STOCK_ID = STOCKS.STOCK_ID AND 
					STOCKS.PRODUCT_ID = #product_id# AND  
					PRICE.PRICE_CATID=#price_id#	
				) L1 ON  L1.STOCK_ID = S.STOCK_ID 
				LEFT JOIN
				(
				SELECT
							PRICE.PRODUCT_ID,
							PRICE.STOCK_ID, 
							PRICE.UNIT,
							PRICE.PRICE,
							PRICE.PRICE_KDV,
							PRICE.MONEY
						 FROM 
							#dsn3#..PRICE
								LEFT JOIN STOCKS ON PRICE.STOCK_ID = STOCKS.STOCK_ID 
						WHERE 
							STOCKS.STOCK_ID IS NULL AND 
							PRICE.PRODUCT_ID = #product_id# AND
							PRICE.PRICE_CATID=#price_id#
				)L2 ON S.PRODUCT_ID = L2.PRODUCT_ID 
		WHERE
		     SP.STOCK_ID IN (SELECT STOCK_ID FROM STOCKS WHERE PRODUCT_ID = #product_id#) AND
			 PROPERTY_ID=#prod_detail# AND PPD.PROPERTY_DETAIL_ID = #prod_varyasyon# AND
			 S.STOCK_ID = SP.STOCK_ID
		ORDER BY
		    PPD.PROPERTY_DETAIL
   </cfquery>
   <cfreturn serializeJSON(prices)>
</cffunction>
<cffunction name="getPriceList" access="remote" returntype="any"  returnFormat="plain">
	 <cfargument name="product_id" required="true">
	 	 
	 <cfquery name="priceList" datasource="#DSN3#">
	SELECT 
		DISTINCT
		PC.PRICE_CATID,
		PC.PRICE_CAT
	FROM 
		PRICE P ,
		PRICE_CAT PC
	WHERE
		P.PRICE_CATID = PC.PRICE_CATID AND 
		--P.STOCK_ID IN (SELECT STOCK_ID FROM STOCKS WHERE PRODUCT_ID=#product_id#)
		P.PRODUCT_ID = <cfqueryparam value="#product_id#" cfsqltype="cf_sql_integer"> 
	 </cfquery>
	 <cfreturn serializeJSON(priceList)>
</cffunction>
</cfcomponent>
