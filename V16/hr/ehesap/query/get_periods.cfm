<cfquery name="get_company_periods" datasource="#DSN#">
	SELECT 
    	PERIOD_ID, 
        PERIOD, 
        PERIOD_YEAR, 
        OUR_COMPANY_ID, 
        RECORD_DATE, 
        RECORD_IP, 
        RECORD_EMP, 
        UPDATE_DATE, 
        UPDATE_IP, 
        UPDATE_EMP, 
        IS_LOCKED, 
        PROCESS_DATE 
    FROM 
	    SETUP_PERIOD 
    WHERE 
    	OUR_COMPANY_ID = #SESSION.EP.COMPANY_ID#
</cfquery>
