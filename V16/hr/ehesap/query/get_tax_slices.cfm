<cfquery name="get_tax_slices" datasource="#dsn#">
	SELECT 
    	TAX_SL_ID, 
        NAME, 
        STARTDATE, 
        FINISHDATE, 
        STATUS, 
        MIN_PAYMENT_1, 
        MAX_PAYMENT_1, 
        RATIO_1, 
        MIN_PAYMENT_2, 
        MAX_PAYMENT_2, 
        RATIO_2,
        MIN_PAYMENT_3, 
        MAX_PAYMENT_3, 
        RATIO_3, 
        MIN_PAYMENT_4, 
        MAX_PAYMENT_4, 
        RATIO_4, 
        MIN_PAYMENT_5,
        MAX_PAYMENT_5, 
        RATIO_5, 
        MIN_PAYMENT_6, 
        MAX_PAYMENT_6, 
        RATIO_6, 
        RECORD_DATE, 
        RECORD_IP,
        RECORD_EMP, 
        SAKAT1,
        SAKAT2, 
        SAKAT3 
    FROM 
	    SETUP_TAX_SLICES 
    ORDER BY 
    	RECORD_DATE DESC
</cfquery>
