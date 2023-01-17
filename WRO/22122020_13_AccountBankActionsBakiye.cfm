
<!-- Description : Banka hesapları bakiye için view düzenlemesi yapıldı.
Developer: Melek KOCABEY
Company : Workcube
Destination: Period-->
<querytag>
    ALTER VIEW [ACCOUNT_REMAINDER] AS
		SELECT 
            CASE WHEN ACCOUNTS.ACCOUNT_ID = BANK_ACTIONS.ACTION_FROM_ACCOUNT_ID THEN SUM(BANK_ACTIONS.ACTION_VALUE ) ELSE 0 END AS ALACAK,
            CASE WHEN ACCOUNTS.ACCOUNT_ID = BANK_ACTIONS.ACTION_TO_ACCOUNT_ID THEN SUM(BANK_ACTIONS.ACTION_VALUE - BANK_ACTIONS.MASRAF) ELSE 0 END AS BORC,
			CASE WHEN ACCOUNTS.ACCOUNT_ID = BANK_ACTIONS.ACTION_FROM_ACCOUNT_ID THEN SUM(BANK_ACTIONS.SYSTEM_ACTION_VALUE) ELSE 0 END AS ALACAK_SYSTEM,
            CASE WHEN ACCOUNTS.ACCOUNT_ID = BANK_ACTIONS.ACTION_TO_ACCOUNT_ID THEN SUM(BANK_ACTIONS.SYSTEM_ACTION_VALUE) ELSE 0 END AS BORC_SYSTEM,
            ACCOUNTS.ACCOUNT_ID, 
            ACCOUNTS.ACCOUNT_NAME, 
            ACCOUNTS.ACCOUNT_CURRENCY_ID, 
            MAX(BANK_ACTIONS.ACTION_DATE) AS TARIH
    	FROM 
            @_dsn_period_@.BANK_ACTIONS, 
            @_dsn_company_@.ACCOUNTS AS ACCOUNTS
   		 WHERE
            (ACCOUNTS.ACCOUNT_ID = BANK_ACTIONS.ACTION_FROM_ACCOUNT_ID OR ACCOUNTS.ACCOUNT_ID = BANK_ACTIONS.ACTION_TO_ACCOUNT_ID) AND
       		 BANK_ACTIONS.ACTION_TYPE_ID <> 93
    	GROUP BY
            ACCOUNTS.ACCOUNT_ID, 
            ACCOUNTS.ACCOUNT_NAME, 
            ACCOUNTS.ACCOUNT_CURRENCY_ID,	
            BANK_ACTIONS.ACTION_FROM_ACCOUNT_ID,
            BANK_ACTIONS.ACTION_TO_ACCOUNT_ID
</querytag>