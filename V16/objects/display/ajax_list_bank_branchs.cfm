<cfif IsDefined('attributes.bank_id') and len(attributes.bank_id)>
	<cfquery name="GET_BANK_BRANCHES" datasource="#DSN3#">
		SELECT 
			BANK_BRANCH_ID,
			BANK_BRANCH_NAME,
			BANK_NAME
		FROM 
			BANK_BRANCH 
		WHERE 
			BANK_ID = #attributes.bank_id#
		ORDER BY
			BANK_NAME
	</cfquery>
	<select name="branch_id" id="branch_id" style="width:150px">
		<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
		<cfoutput query="get_bank_branches">
			<option value="#bank_branch_id#">#bank_branch_name# </option>
		</cfoutput>
	</select> 
</cfif>