<!--- M.ER ÜRÜN ÖZELLLİKLERİ --->
<cffunction name="get_product_alternative" access="public" returnType="query" output="no">
	<cfargument name="product_name" required="yes" type="string">
	<cfargument name="maxrows" required="yes" type="string" default="">
	<cfargument name="product_id" required="yes" type="string">
			<cfquery name="GET_ALTERNATE_PRODUCT" datasource="#dsn3#">
				SELECT 	
					ASIL_PRODUCT,
					ALTERNATIVE_PRODUCT_ID,
					PRODUCT_NAME,
					PRODUCT_ID,
					STOCK_ID,
					PROPERTY,
					IS_PRODUCTION
					FROM
					(
					SELECT
							AP.PRODUCT_ID ASIL_PRODUCT,
							AP.ALTERNATIVE_PRODUCT_ID,
							P.PRODUCT_NAME, 
							P.PRODUCT_ID,
							P.STOCK_ID,
							P.PROPERTY,
							P.IS_PRODUCTION
						FROM
							STOCKS AS P,
							ALTERNATIVE_PRODUCTS AS AP
						WHERE
							P.PRODUCT_ID NOT IN (SELECT PRODUCT_ID FROM ALTERNATIVE_PRODUCTS_EXCEPT WHERE ALTERNATIVE_PRODUCT_ID=#arguments.product_id#) AND
							((
								P.PRODUCT_ID=AP.PRODUCT_ID AND
								AP.ALTERNATIVE_PRODUCT_ID IN (#arguments.product_id#)
							)
							OR
							(
								P.PRODUCT_ID=AP.ALTERNATIVE_PRODUCT_ID AND
								AP.PRODUCT_ID IN (#arguments.product_id#)
							))
					UNION ALL
							SELECT 
									PRODUCT_ID AS ASIL_PRODUCT,
									PRODUCT_ID AS ALTERNATIVE_PRODUCT_ID,
									PRODUCT_NAME, 
									PRODUCT_ID,
									STOCK_ID,
									PROPERTY,
									IS_PRODUCTION 
							FROM 
									STOCKS 
							WHERE 
									PRODUCT_ID = #arguments.product_id#
					)
					T1	
					WHERE PRODUCT_NAME LIKE '#arguments.product_name#%'
			</cfquery>
		<cfreturn GET_ALTERNATE_PRODUCT>
</cffunction>
