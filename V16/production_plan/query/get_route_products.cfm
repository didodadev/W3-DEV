<cfquery name="get_pro" datasource="#dsn3#">
	SELECT 
		WSP.*,
		S.PROPERTY,
		P.PRODUCT_NAME,
		PU.MAIN_UNIT
	from
		ROUTE_PRODUCTS WSP,
		PRODUCT P,
		STOCKS S,
		PRODUCT_UNIT PU
	WHERE
		WSP.ID=#attributes.UPD#
		AND
		WSP.STOCK_ID=S.STOCK_ID
		AND
		S.PRODUCT_ID=P.PRODUCT_ID
		AND
		P.PRODUCT_ID=PU.PRODUCT_ID
		AND
		PU.IS_MAIN=1
</cfquery>
