<cfquery name="GET_STRATEGY" datasource="#dsn3#" maxrows="#attributes.maxrows#">
	SELECT
		S.STOCK_ID,
		S.PRODUCT_ID,
		S.PRODUCT_NAME,
		S.PROPERTY,
		GSS.REPEAT_STOCK_VALUE,
		GS.PRODUCT_STOCK AS PRODUCT_TOTAL_STOCK,
		PRODUCT_UNIT.MAIN_UNIT
	FROM
		STOCKS S,
		#dsn2_alias#.GET_STOCK AS GS,
		#dsn2_alias#.GET_STOCK_STRATEGY AS GSS,
		PRODUCT_UNIT
	WHERE
		S.STOCK_ID = GS.STOCK_ID AND 
		S.PRODUCT_STATUS = 1 AND
		S.STOCK_STATUS = 1 AND
		PRODUCT_UNIT.IS_MAIN=1 AND 
		PRODUCT_UNIT.PRODUCT_ID=S.PRODUCT_ID AND 
		GSS.DEPARTMENT_ID IS NULL AND 
		GSS.STOCK_ID =GS.STOCK_ID AND 
		<cfif attributes.gt_ eq 1>
			GS.PRODUCT_STOCK >= GSS.MAXIMUM_STOCK
		<cfelse>
			GS.PRODUCT_STOCK <= GSS.MINIMUM_STOCK
		</cfif>
</cfquery>
