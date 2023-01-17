<cfif isdefined('attributes.is_temporary_solve') and attributes.is_temporary_solve eq 1 and isdefined("attributes.card_id")> <!--- gecici acılmıs fişlerin detay bilgilerini getiriyor --->
	<cfquery name="GET_CARD_ROWS" datasource="#dsn2#">
		SELECT
			*
		FROM
			ACCOUNT_CARD_SAVE ACS,
			ACCOUNT_CARD_SAVE_ROWS ACSR,
			ACCOUNT_PLAN AP
		WHERE
			ACS.CARD_ID=ACSR.CARD_ID
			AND ACSR.ACCOUNT_ID=AP.ACCOUNT_CODE
			AND ACS.NEW_CARD_ID=#attributes.card_id#
	</cfquery>
<cfelse>
	<cfquery name="GET_CARD_ROWS" datasource="#dsn2#">
		SELECT
			ACR.BA,
			ACR.DETAIL,
			ACR.ACCOUNT_ID,
			ACR.IFRS_CODE,
			ACR.AMOUNT,
			ACR.AMOUNT_CURRENCY,
			ACR.AMOUNT_2,
			ACR.AMOUNT_CURRENCY_2,
			ACR.OTHER_AMOUNT,
			ACR.OTHER_CURRENCY,
			ACR.ACC_DEPARTMENT_ID,
			AC.ACTION_DATE,
			AC.BILL_NO,
			AC.CARD_DETAIL,
			AC.CARD_TYPE,
			AC.CARD_TYPE_NO,
			AC.IS_COMPOUND,
			AC.CARD_ID,
			AC.ACTION_TYPE,
			AC.ACTION_ID,
			AC.IS_OTHER_CURRENCY,
			AP.ACCOUNT_NAME,
            ACR.ACC_BRANCH_ID,
			ACR.ACC_DEPARTMENT_ID,
			ACR.ACC_PROJECT_ID,
			AC.ACTION_CAT_ID PROCESS_CAT,
			ACR.QUANTITY,
            AC.ACTION_TABLE,
            CASE
            	WHEN ACDP.DOCUMENT_TYPE_ID < 0 THEN ACDP.DETAIL
            	ELSE ACDP.DOCUMENT_TYPE
        	END AS DOCUMENT_TYPE,
            ACP.PAYMENT_TYPE,
			(SELECT PROJECT_HEAD FROM #dsn_alias#.PRO_PROJECTS WHERE PROJECT_ID = ACR.ACC_PROJECT_ID) AS PROJECT_HEAD
		FROM
			ACCOUNT_CARD_ROWS ACR,
			ACCOUNT_PLAN AP,
   			ACCOUNT_CARD AC
            LEFT JOIN #dsn_alias#.ACCOUNT_CARD_DOCUMENT_TYPES ACDP ON ACDP.DOCUMENT_TYPE_ID = AC.CARD_DOCUMENT_TYPE
            LEFT JOIN #dsn_alias#.ACCOUNT_CARD_PAYMENT_TYPES ACP ON ACP.PAYMENT_TYPE_ID = AC.CARD_PAYMENT_METHOD
		WHERE
		<cfif isdefined("process_cat") and len(attributes.process_cat)>
			ACTION_TYPE = #attributes.process_cat# AND
			ACTION_ID = #attributes.action_id# AND
		<cfelse>
			AC.CARD_ID=#attributes.card_id# AND
		</cfif>
		<cfif isdefined("process_cat") and len(attributes.process_cat) and attributes.process_cat eq 120 and not (isdefined("attributes.action_table"))>
			(AC.ACTION_TABLE != 'INVOICE_COST' OR AC.ACTION_TABLE IS NULL) AND
		</cfif>
        <cfif isdefined("attributes.is_cancel") and len(attributes.is_cancel)>
            ISNULL(AC.IS_CANCEL,0) = #attributes.is_cancel# AND
        </cfif>
		<cfif isdefined("attributes.action_table") and len(attributes.action_table)>
			AC.ACTION_TABLE='#attributes.action_table#' AND
		</cfif>
			ACR.CARD_ID=AC.CARD_ID AND
			ACR.ACCOUNT_ID=AP.ACCOUNT_CODE
		ORDER BY
			BA ASC,AMOUNT DESC
	</cfquery>
</cfif>
<cfif get_card_rows.is_other_currency eq 1>
	<cfquery name="GET_OTHER_MONEY_TOTALS" dbtype="query">
		SELECT
			SUM(OTHER_AMOUNT) OTHER_AMOUNT_TOPLAM,
			OTHER_CURRENCY,
			BA
		FROM
			GET_CARD_ROWS
		WHERE
			CARD_ID=#GET_CARD_ROWS.CARD_ID#
		GROUP BY
			OTHER_CURRENCY,
			BA
		ORDER BY
			BA
	</cfquery>
</cfif>
