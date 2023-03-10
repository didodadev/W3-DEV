<cfquery name="GET_DET_PO" datasource="#DSN3#">
	SELECT 
		PO.*, 
		S.PROPERTY, 
		P.PRODUCT_NAME, 
		P.PRODUCT_ID 
	FROM 
		PRODUCTION_ORDERS PO, 
		STOCKS S, 
		PRODUCT P 
	WHERE 
		PO.P_ORDER_ID=#attributes.P_ORDER_ID# 
	AND 
		PO.STOCK_ID=S.STOCK_ID
	AND	
		S.PRODUCT_ID=P.PRODUCT_ID
</cfquery>
