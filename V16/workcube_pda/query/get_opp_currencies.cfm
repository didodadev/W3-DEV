<cfquery name="GET_OPP_CURRENCIES" datasource="#dsn3#">
	SELECT 
    	OPP_CURRENCY_ID, 
        OPP_CURRENCY, 
        RECORD_EMP, 
        RECORD_DATE, 
        RECORD_IP, 
        UPDATE_EMP, 
        UPDATE_DATE, 
        UPDATE_IP 
    FROM 
    	OPPORTUNITY_CURRENCY 
    ORDER BY 
    	OPP_CURRENCY
</cfquery>
