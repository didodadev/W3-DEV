<cfset ADD_BSMV = createObject("component","V16.settings.cfc.BSMV")/>
<cfset Insert =ADD_BSMV.Insert(
	ACCOUNT_CODE:attributes.Account_Code,
	ACCOUNT_CODE_P:attributes.Account_Code_p,
	ACCOUNT_CODE_IADE:attributes.Account_Code_iade,
	ACCOUNT_CODE_P_IADE:attributes.Account_Code_p_iade,
	ACCOUNT_CODE_DIRECT_EXPENSE:attributes.direct_expense_Account_Code,
	TAX:#filternum(attributes.tax_,3)#,
	tax_code:"#listfirst(attributes.tax_code)#",
	DETAIL:attributes.detail,
	TAX_CODE_NAME:"#listlast(attributes.tax_code)#",
	EXPENSE_ITEM_ID: (isDefined("attributes.expense_item_id") and len(attributes.expense_item_id) and isDefined("attributes.expense_item_name") and len( attributes.expense_item_name )) ? attributes.expense_item_id : ""
)/>
<script>
	location.href = document.referrer;
</script>