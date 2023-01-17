<cfquery name="GET_KARMA_PRODUCT" datasource="#dsn1#"><!---#79263 Karma Ürününün içerisindeki stokların renk özellikleri için sorgu güncellendi.--->
	SELECT 
		KP.*,
		S.STOCK_CODE,
		S.PROPERTY,
		S.IS_PRODUCTION,
		P.KARMA_PROPERTY_COLLAR_ID,
		P.KARMA_PROPERTY_SIZE_ID,
		SP.PROPERTY_ID,<!---renk mi beden mi? --->
		SP.PROPERTY_DETAIL_ID<!---hangi renk yada hangi beden --->
	FROM 
		KARMA_PRODUCTS AS KP
		LEFT JOIN #dsn3#.STOCKS S ON S.STOCK_ID=KP.STOCK_ID
		LEFT JOIN PRODUCT P ON P.PRODUCT_ID=KP.KARMA_PRODUCT_ID
		LEFT JOIN STOCKS_PROPERTY SP ON SP.STOCK_ID =KP.STOCK_ID AND SP.PROPERTY_ID=1<!--- renk için --->
	WHERE
		KP.KARMA_PRODUCT_ID = <cfqueryparam value = "#attributes.pid#" CFSQLType = "cf_sql_integer">
	ORDER BY 
		ENTRY_ID
</cfquery>
<cfscript>
	cmp = createObject("component", "V16.product.cfc.get_product");
	cmp.dsn1 = dsn1;
	cmp.dsn_alias = dsn_alias;
	get_product = cmp.get_product_(pid : attributes.pid);
</cfscript>
<cfif len(get_product.KARMA_FOR_PRODUCT_ID)>
	<cfquery name="GET_KARMA_FOR_PRODUCT" datasource="#dsn1#"><!---#79263 Karma Ürününün içerisindeki stokların renk özellikleri için sorgu güncellendi.--->
		SELECT 
			KP.*,
			S.STOCK_CODE,
			S.PROPERTY,
			S.IS_PRODUCTION,
			SP.PROPERTY_ID,<!---renk mi beden mi? --->
			SP.PROPERTY_DETAIL_ID<!---hangi renk yada hangi beden --->
		FROM 
			KARMA_PRODUCTS AS KP
			LEFT JOIN #dsn3#.STOCKS S ON S.STOCK_ID=KP.STOCK_ID
			LEFT JOIN STOCKS_PROPERTY SP ON SP.STOCK_ID =KP.STOCK_ID AND SP.PROPERTY_ID=1<!--- renk için --->
		WHERE
			KP.KARMA_PRODUCT_ID = <cfqueryparam value = "#get_product.KARMA_FOR_PRODUCT_ID#" CFSQLType = "cf_sql_integer">
		ORDER BY 
			ENTRY_ID
	</cfquery>
<cfelse>
	<cfset GET_KARMA_FOR_PRODUCT.recordcount = 0>
</cfif>


