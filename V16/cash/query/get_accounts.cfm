<cfquery name="GET_ACCOUNTS" datasource="#dsn3#">
	SELECT 	
		ACCOUNT_ID,
		ACCOUNT_STATUS,
		ACCOUNT_TYPE,
		ACCOUNT_NAME,
		ACCOUNT_BRANCH_ID,
		<cfif session.ep.period_year lt 2009>
			CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS  ACCOUNT_CURRENCY_ID,
		<cfelse>
			ACCOUNTS.ACCOUNT_CURRENCY_ID,
		</cfif>
		ACCOUNT_NO,
		ACCOUNT_OWNER_CUSTOMER_NO,
		ACCOUNT_CREDIT_LIMIT,
		ACCOUNT_BLOCKED_VALUE,
		ACCOUNT_DETAIL,
		ACCOUNT_ACC_CODE,
		ACCOUNT_ORDER_CODE,
		ISOPEN,
		V_CHEQUE_ACC_CODE,
		V_VOUCHER_ACC_CODE,
		IS_INTERNET,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP,
		UPDATE_DATE,
		UPDATE_EMP,
		UPDATE_IP,
		CHEQUE_EXCHANGE_CODE,
		VOUCHER_EXCHANGE_CODE,
		IS_ALL_BRANCH
	 FROM	
	 	ACCOUNTS
</cfquery>