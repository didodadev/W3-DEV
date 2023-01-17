<cfquery name="get_insurance_ratios" datasource="#dsn#">
	SELECT 
    	INS_RAT_ID, 
        STARTDATE, 
        FINISHDATE 
    FROM 
    	INSURANCE_RATIO 
    ORDER BY 
	    FINISHDATE DESC
</cfquery>

