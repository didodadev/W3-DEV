<cfquery name="get_credit_contracts" datasource="#dsn3#">
	SELECT
		CC.CREDIT_NO,
		CC.CREDIT_EMP_ID,
		CC.RECORD_EMP,
		CC.CREDIT_TYPE,
		CC.CREDIT_CONTRACT_ID,
		CC.CREDIT_DATE,
		CC.COMPANY_ID,
		CC.DETAIL,
		CC.MONEY_TYPE,
		CC.AGREEMENT_NO,
		ISNULL((SELECT TOP 1 RATE2 FROM CREDIT_CONTRACT_MONEY CCM,CREDIT_CONTRACT_ROW CCR WHERE CCM.MONEY_TYPE = CCR.OTHER_MONEY AND CCR.IS_PAID_ROW IS NULL AND CC.CREDIT_CONTRACT_ID = CCR.CREDIT_CONTRACT_ID AND CCM.ACTION_ID = CC.CREDIT_CONTRACT_ID),1) RATE2,
		<cfif isdefined("is_detail_credit_contract") and is_detail_credit_contract eq 1 and attributes.listing_type eq 1>
			ISNULL((SELECT TOP 1 SUM(TOTAL_PRICE) FROM CREDIT_CONTRACT_ROW CCR WHERE CCR.CREDIT_CONTRACT_ID=CC.CREDIT_CONTRACT_ID AND IS_PAID = 1 AND CREDIT_CONTRACT_TYPE=1),0) AS ROW_TOTAL_ACTUAL_PAYMENT,
			ISNULL((SELECT TOP 1 SUM(TOTAL_PRICE) FROM CREDIT_CONTRACT_ROW CCR WHERE CCR.CREDIT_CONTRACT_ID=CC.CREDIT_CONTRACT_ID AND IS_PAID = 1 AND CREDIT_CONTRACT_TYPE=2),0) AS ROW_TOTAL_ACTUAL_REVENUE,
            ISNULL((SELECT TOP 1 SUM(DELAY_PRICE) FROM CREDIT_CONTRACT_ROW CCR WHERE CCR.CREDIT_CONTRACT_ID=CC.CREDIT_CONTRACT_ID AND IS_PAID = 1 AND CREDIT_CONTRACT_TYPE=1),0) AS DELAY_PRICE,
 		</cfif>
		<cfif attributes.listing_type eq 2>
			CASE WHEN CCR.CREDIT_CONTRACT_TYPE = 1 THEN TOTAL_PRICE ELSE 0 END AS ROW_TOTAL_PAYMENT,
			CASE WHEN CCR.CREDIT_CONTRACT_TYPE = 2 THEN TOTAL_PRICE ELSE 0 END AS ROW_TOTAL_REVENUE,
			PROCESS_DATE ROW_PROCESS_DATE
		<cfelse>
			TOTAL_PAYMENT ROW_TOTAL_PAYMENT,
			TOTAL_REVENUE ROW_TOTAL_REVENUE
		</cfif>
	FROM
		CREDIT_CONTRACT CC
		<cfif attributes.listing_type eq 2>
			,CREDIT_CONTRACT_ROW CCR
		</cfif>
	WHERE
		CC.CREDIT_CONTRACT_ID IS NOT NULL
		<cfif attributes.listing_type eq 2>
			AND CC.CREDIT_CONTRACT_ID = CCR.CREDIT_CONTRACT_ID
			AND CCR.IS_PAID_ROW IS NULL
		</cfif>
		<cfif len(attributes.company_id) and len(attributes.company)>
			AND CC.COMPANY_ID = #attributes.company_id#
		</cfif>
		<cfif len(attributes.keyword)>
			AND (CC.CREDIT_NO LIKE '%#attributes.keyword#%' OR CC.REFERENCE LIKE '%#attributes.keyword#%' OR CC.AGREEMENT_NO LIKE '%#attributes.keyword#%')
		</cfif>
		<cfif len(attributes.credit_employee_id) and len(attributes.credit_employee)>
			AND CC.CREDIT_EMP_ID = #attributes.credit_employee_id#
		</cfif>
		<cfif len(attributes.start_date)>
			AND CC.CREDIT_DATE >= #attributes.start_date#
		</cfif>
		<cfif len(attributes.is_active)>
			AND CC.IS_ACTIVE = #attributes.is_active#
		</cfif>
		<cfif len(attributes.process_type)>
			AND CC.PROCESS_TYPE = #attributes.process_type#
		</cfif>
		<cfif len(attributes.credit_limit_id)>
			AND CC.CREDIT_LIMIT_ID = #attributes.credit_limit_id#
		</cfif>
		<cfif len(attributes.credit_type_id)>
			AND CC.CREDIT_TYPE = #attributes.credit_type_id#
		</cfif>
	ORDER BY
		<cfif attributes.listing_type eq 2>
			<!--- CCR.PROCESS_DATE, --->
			ROW_PROCESS_DATE
		<cfelse>
			CC.CREDIT_DATE
		</cfif>
</cfquery>
