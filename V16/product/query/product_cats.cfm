<cfquery name="PRODUCT_CATS" datasource="#DSN3#">
	SELECT 
    	PRODUCT_CATID,
    	HIERARCHY,
        #dsn#.Get_Dynamic_Language(PRODUCT_CATID,'#session.ep.language#','PRODUCT_CAT','PRODUCT_CAT',NULL,NULL,PRODUCT_CAT) AS PRODUCT_CAT,
        PROFIT_MARGIN,
        PROFIT_MARGIN_MAX,
        LIST_ORDER_NO,
        USER_FRIENDLY_URL,
        DETAIL,
        IS_PUBLIC,
        IS_CUSTOMIZABLE,
        IS_INSTALLMENT_PAYMENT,
        IMAGE_CAT,
        IMAGE_CAT_SERVER_ID,
        STOCK_CODE_COUNTER,
        FORM_FACTOR,
        WATALOGY_CAT_ID,
        IS_CASH_REGISTER,
        RECORD_EMP,
        RECORD_DATE,
        UPDATE_EMP,
        UPDATE_DATE
	FROM 
    	PRODUCT_CAT 
    ORDER BY 
    	HIERARCHY
</cfquery>
