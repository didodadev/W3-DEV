<cfquery name="get_tax"  datasource="#DSN2#">
	SELECT 
    	TAX_ID,
        TAX, 
        DETAIL, 
        SALE_CODE, 
        PURCHASE_CODE, 
        SALE_CODE_IADE, 
        PURCHASE_CODE_IADE, 
        INVENTORY_SALE_CODE, 
        INVENTORY_PURCHASE_CODE, 
        PURCHASE_PRICE_DIFF_CODE, 
        SALE_PRICE_DIFF_CODE, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	SETUP_TAX 
    ORDER BY 
    	TAX
</cfquery>
