
<cfset UPD_tax = createObject("component","V16.settings.cfc.tax")/>
<cfset UPDATE =UPD_tax.UPDATE(
	tid:attributes.tid,
    ACCOUNT_CODE_S : attributes.ACCOUNT_CODE_S,
	ACCOUNT_CODE:attributes.Account_Code,
	ACCOUNT_CODE_S_IADE:attributes.ACCOUNT_CODE_S_IADE,
	ACCOUNT_CODE_IADE:attributes.Account_Code_iade,
	TAX:#filternum(attributes.tax_rate)#,
	tax_code:"#listfirst(attributes.tax_code)#",
	tax_code_name:"#listlast(attributes.tax_code)#",
	DETAIL:attributes.detail,
	INVENTORY_ACCOUNT_CODE_S: attributes.INVENTORY_ACCOUNT_CODE_S,
	INVENTORY_ACCOUNT_CODE: attributes.INVENTORY_ACCOUNT_CODE,
	REC_PRICE_DIF_ACCOUNT_CODE:attributes.REC_PRICE_DIF_ACCOUNT_CODE,
	PRO_PRICE_DIF_ACCOUNT_CODE:attributes.PRO_PRICE_DIF_ACCOUNT_CODE,
	exp_reg_sales_dif_Account_Code:attributes.exp_reg_sales_dif_Account_Code,
	exp_reg_purchase_dif_Account_Code:attributes.exp_reg_purchase_dif_Account_Code,
	inward_process_dif_Account_Code:attributes.inward_process_dif_Account_Code,
	direct_expense_Account_Code:attributes.direct_expense_Account_Code,
	EXPENSE_ITEM_ID: (isDefined("attributes.expense_item_id") and len(attributes.expense_item_id) and isDefined("attributes.expense_item_name") and len( attributes.expense_item_name )) ? attributes.expense_item_id : ""
)/>
<script>
	location.href= document.referrer;
</script> 

