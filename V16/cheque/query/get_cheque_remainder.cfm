<cfquery name="GET_CHEQUE_IN_CASH" datasource="#dsn2#">
 	SELECT 
    	BAKIYE, 
        BORC, 
        ALACAK,
        CASH_ID,
        CASH_NAME 
    FROM 
	    CHEQUE_IN_CASH_TOTAL
</cfquery>
<cfquery name="GET_CHEQUE_IN_BANK" datasource="#dsn2#">
	SELECT 
    	ALACAK, 
        BORC, 
        ACCOUNT_ID, 
        ACCOUNT_NAME 
    FROM 
	    CHEQUE_IN_BANK
</cfquery>
<cfquery name="GET_CHEQUE_TO_PAY" datasource="#dsn2#">
	SELECT 
    	ALACAK, 
        BORC, 
        ACCOUNT_ID, 
        ACCOUNT_NAME 
    FROM 
    	CHEQUE_TO_PAY
</cfquery>
