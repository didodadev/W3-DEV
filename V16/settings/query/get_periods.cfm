<cfquery name="PERIODS" datasource="#dsn#">
	SELECT 
    	S.PERIOD_ID, 
        S.PERIOD, 
        S.PERIOD_YEAR, 
        S.OUR_COMPANY_ID, 
        S.PERIOD_DATE, 
        S.RECORD_DATE, 
        S.RECORD_IP, 
        S.RECORD_EMP, 
        S.UPDATE_DATE, 
        S.UPDATE_IP, 
        S.UPDATE_EMP,
        O.COMPANY_NAME
    FROM 
    	SETUP_PERIOD AS S,
        OUR_COMPANY AS O
    WHERE
    	S.OUR_COMPANY_ID = O.COMP_ID
    ORDER BY 
    	COMPANY_NAME,
        PERIOD_YEAR DESC
</cfquery>	
