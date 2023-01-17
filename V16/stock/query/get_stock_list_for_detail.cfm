<cfquery name="GET_PRODUCT" datasource="#dsn3#">
	SELECT 
		PU.MAIN_UNIT,
		P.PRODUCT_ID,
		P.PRODUCT_NAME,
		S.STOCK_ID,
		S.BARCOD,
		S.STOCK_CODE,
		S.PROPERTY,
		GS.PRODUCT_STOCK
	FROM 
		PRODUCT AS P,
		STOCKS AS S,
		PRODUCT_UNIT AS PU,
	<cfif isDefined("attributes.department_id") and len(attributes.department_id) and isnumeric(attributes.department_id)>
		#dsn2_alias#.GET_STOCK_PRODUCT AS GS
	<cfelse>
		#dsn2_alias#.GET_STOCK AS GS
	</cfif>
	WHERE
		P.PRODUCT_ID = #attributes.pid# AND
		GS.STOCK_ID = S.STOCK_ID AND
		P.PRODUCT_STATUS = 1 AND 
		P.IS_INVENTORY = 1 AND 
		P.PRODUCT_ID = S.PRODUCT_ID AND
		P.PRODUCT_ID = PU.PRODUCT_ID AND 
		PU.IS_MAIN = 1
	<cfif len(attributes.keyword)>
		AND P.PRODUCT_NAME LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%'
	</cfif>
	<cfif isDefined("attributes.department_id") and len(attributes.department_id) and isnumeric(attributes.department_id)>
		AND GS.DEPARTMENT_ID = #attributes.department_id#
	</cfif>		
	ORDER BY
		P.PRODUCT_NAME
</cfquery>
