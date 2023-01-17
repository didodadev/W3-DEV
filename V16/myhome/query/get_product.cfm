<!--- get_product.cfm --->
<cfquery name="GET_PRODUCT" datasource="#dsn3#" maxrows="#attributes.maxrows#">
	SELECT 
		P.PRODUCT_ID,
		P.PRODUCT_NAME,
		P.BARCOD,
		P.PRODUCT_CODE, 
		PU.MAIN_UNIT
	FROM 
		PRODUCT P,
		PRODUCT_UNIT PU
	WHERE  
		P.PRODUCT_ID = PU.PRODUCT_ID AND 
		<!---P.IS_PROTOTYPE = 1 AND yeni eklenen urunlerde calısıyorda neden ozekestirilebilir diye bakıyor--->
		PU.IS_MAIN=1
	ORDER BY 
		P.RECORD_DATE DESC
</cfquery>
