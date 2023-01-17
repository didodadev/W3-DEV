<cfif listgetat(session_base.user_level, 4)>
	<cfset URL.CPID = attributes.company_id>
	<cfquery name="GET_BANK" datasource="#DSN#">
		SELECT 
			COMPANY_BANK_ID,
			COMPANY_BANK,
			COMPANY_BANK_CODE,
			COMPANY_IBAN_CODE,
			COMPANY_BANK_BRANCH,
			COMPANY_ACCOUNT_NO,
			COMPANY_BANK_MONEY,
			COMPANY_ACCOUNT_DEFAULT,
			COMPANY_BANK_BRANCH_CODE,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP,
			UPDATE_DATE,
			UPDATE_EMP,
			UPDATE_IP
		FROM 
			COMPANY_BANK
			<cfif isDefined("URL.BID")>
		WHERE 
			COMPANY_BANK_ID = #URL.BID#
			<cfelse>
		WHERE 
			COMPANY_ID = #URL.CPID#
			</cfif>
	</cfquery>
	<cf_ajax_list>
		<cfif get_bank.recordcount>
            <cfoutput query="get_bank">
                <tr>
                    <td>&nbsp;#company_bank# - #company_bank_branch# - IBAN :#company_iban_code# - #company_account_no#&nbsp;&nbsp;#company_bank_money#</td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td><cf_get_lang dictionary_id="57484.Kayıt Yok"></td>
            </tr>
        </cfif>
	</cf_ajax_list>
</cfif>
