<cfif IsDefined('attributes.action_from_account_id') and len(attributes.action_from_account_id)>
	<cfquery name="get_branch" datasource="#dsn3#">
        SELECT
        	AB.BRANCH_ID,
            B.BRANCH_NAME
        FROM
        	ACCOUNTS_BRANCH AB
            LEFT JOIN  #dsn_alias#.BRANCH B ON  B.BRANCH_ID=AB.BRANCH_ID
        WHERE 
      		ACCOUNT_ID = #ListGetAt(attributes.action_from_account_id,1,';')#
    
    </cfquery>
    <cfif IsDefined('attributes.credit_contract_row_id') and len(attributes.credit_contract_row_id)>
  	<cfquery name="get_bank_branch" datasource="#dsn2#">
    	SELECT
            B.TO_BRANCH_ID
        FROM
            CREDIT_CONTRACT_PAYMENT_INCOME CC
            LEFT JOIN BANK_ACTIONS B ON CC.BANK_ACTION_ID = B.ACTION_ID
        WHERE
            CREDIT_CONTRACT_PAYMENT_ID = #attributes.credit_contract_row_id#
   </cfquery>
</cfif>
	<label class="col col-4 col-xs-12"><cf_get_lang_main no='2245.Banka Şubesi'></label>
    <div class="col col-8 col-xs-12">
    	<select name="action_from_account_branch" id="action_from_account_branch">
			<cfif get_branch.recordcount neq 1>
                <option value=""><cf_get_lang_main no='322.seç'></option>
            </cfif>
            <cfoutput query="get_branch">
                <option value="#branch_id#" <cfif (IsDefined('attributes.credit_contract_row_id') and len(attributes.credit_contract_row_id)) and  (branch_id eq get_bank_branch.to_branch_id)>selected</cfif>>#branch_name#</option>
            </cfoutput>
        </select>
    </div>
</cfif>


