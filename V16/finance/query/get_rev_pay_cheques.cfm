<cfquery name="GET_RECORDS" datasource="#DSN2#">
		SELECT
			C.BANK_NAME,
			C.CHEQUE_STATUS_ID,
			C.CHEQUE_VALUE,
			C.CHEQUE_ID,
			C.CHEQUE_NO,
			C.CURRENCY_ID,
			C.DEBTOR_NAME,
			C.BANK_BRANCH_NAME,
			P.COMPANY_ID
		FROM
			CHEQUE AS C,
			PAYROLL AS P
		WHERE
			CHEQUE_STATUS_ID NOT IN (3,9) AND	<!--- iade ve tahsiller gelmemeli --->
	
			C.CHEQUE_DUEDATE =#attributes.bugun# AND					
			C.CHEQUE_PAYROLL_ID=P.ACTION_ID		
		<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
			AND
				(
				DEBTOR_NAME LIKE '%#attributes.keyword#%' OR 
				CHEQUE_NO LIKE '%#attributes.keyword#%' OR 
				BANK_NAME LIKE '%#attributes.keyword#%' OR 
				BANK_BRANCH_NAME LIKE '%#attributes.keyword#%'
				)
		</cfif>	
</cfquery>
