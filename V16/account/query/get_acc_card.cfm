<cfquery name="GET_ACCOUNT_CARD" datasource="#dsn2#">
	SELECT 
    	AC.*,
        C.FULLNAME COMPANY,
        CO.CONSUMER_NAME + ' ' + CO.CONSUMER_SURNAME CONSUMER,
        E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME EMPLOYEE
    FROM 
    	ACCOUNT_CARD AC 
        LEFT JOIN #dsn_alias#.COMPANY C ON AC.ACC_COMPANY_ID = C.COMPANY_ID
        LEFT JOIN #dsn_alias#.CONSUMER CO ON AC.ACC_CONSUMER_ID = CO.CONSUMER_ID
        LEFT JOIN #dsn_alias#.EMPLOYEES E ON AC.ACC_EMPLOYEE_ID = E.EMPLOYEE_ID
    WHERE 
    	AC.CARD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.card_id#">
</cfquery>
<cfquery name="GET_ACCOUNT_ROWS_MAIN_ALL" datasource="#dsn2#">
	SELECT 
		ACR.*, 
		AP.ACCOUNT_NAME
	FROM 
		ACCOUNT_CARD_ROWS ACR, 
		ACCOUNT_PLAN AP 
	WHERE 
		ACR.CARD_ID=#attributes.card_id# AND 
		ACR.ACCOUNT_ID=AP.ACCOUNT_CODE
	ORDER BY
		ACR.CARD_ROW_ID,
		ACR.BA ASC,
		ACR.AMOUNT DESC
</cfquery>
<cfif not GET_ACCOUNT_ROWS_MAIN_ALL.recordcount and session.ep.our_company_info.is_ifrs eq 1>
	<cfquery name="GET_ACCOUNT_ROWS_MAIN_ALL" datasource="#dsn2#">
		SELECT 
			ACR.*, 
			AP.ACCOUNT_NAME
		FROM 
			ACCOUNT_ROWS_IFRS ACR, 
			ACCOUNT_PLAN AP 
		WHERE 
			ACR.CARD_ID=#attributes.card_id# AND 
			ACR.ACCOUNT_ID=AP.ACCOUNT_CODE
		ORDER BY
			ACR.IFRS_ROW_ID,
			ACR.BA ASC,
			ACR.AMOUNT DESC
	</cfquery>
</cfif>

