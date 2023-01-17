<cfquery name="GET_CASHES" datasource="#dsn2#">
	SELECT 
		* 
	FROM 
		CASH 
	WHERE
		A_VOUCHER_ACC_CODE IS NOT NULL
		AND V_VOUCHER_ACC_CODE IS NOT NULL
		<cfif session.ep.isBranchAuthorization>
		AND CASH_ID IN (SELECT CASH_ID FROM CASH WHERE BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#)
	</cfif>
	ORDER BY	
		CASH_ID
</cfquery>

