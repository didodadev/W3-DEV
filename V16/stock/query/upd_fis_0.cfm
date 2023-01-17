<cfif not isdefined("attributes.location_in") or not len(attributes.location_in) >
	<cfset attributes.location_in = "NULL" >
</cfif>
<cfif not isdefined("attributes.location_out") or not len(attributes.location_out)>
	<cfset attributes.location_out = "NULL" >
</cfif>
<!--- sayım fisi guncellemede kullanılıyor --->
<cffunction name="get_stock_amount">
	<cfargument name="stock_id">
	<cfquery name="get_pro_stock" datasource="#DSN2#">
		SELECT
			SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK
		FROM
			#dsn_alias#.DEPARTMENT D,
			#dsn3_alias#.PRODUCT P,
			#dsn3_alias#.STOCKS S,
			STOCKS_ROW SR
		WHERE
			P.PRODUCT_ID = S.PRODUCT_ID AND
			S.STOCK_ID = SR.STOCK_ID AND
			D.DEPARTMENT_ID = SR.STORE AND
			D.DEPARTMENT_ID=#attributes.department_in# AND
			S.STOCK_ID = #stock_id#
		GROUP BY
			P.PRODUCT_ID, 
			S.STOCK_ID, 
			S.STOCK_CODE, 
			S.PROPERTY, 
			S.BARCOD, 
			D.DEPARTMENT_ID, 
			D.DEPARTMENT_HEAD
	</cfquery>
	<cfreturn get_pro_stock.product_stock>
</cffunction>
<!--- //sayım fisi guncelleme  --->
