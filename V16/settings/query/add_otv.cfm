<cfset ADD_OTV = createObject("component","V16.settings.cfc.otv")/>
<cfset attributes.tax_ = filternum(attributes.tax_,4)>
<cfset Insert =ADD_OTV.Insert(
	ACCOUNT_CODE:attributes.Account_Code,
	ACCOUNT_CODE_P:attributes.Account_Code_p,
	ACCOUNT_CODE_IADE:attributes.Account_Code_iade,
	ACCOUNT_CODE_P_IADE:attributes.Account_Code_p_iade,
	ACCOUNT_CODE_DISCOUNT:attributes.account_code_discount,
	ACCOUNT_CODE_P_DISCOUNT:attributes.account_code_p_discount,
	TAX:#attributes.tax_#,
	tax_code:"#listfirst(attributes.tax_code)#",
	TAX_CODE_NAME:"#listlast(attributes.tax_code)#",
	DETAIL:attributes.detail,
	TAX_TYPE: attributes.tax_type
)/>
<script>
	window.location.href='<cfoutput>#request.self#?fuseaction=settings.list_otv&event=upd&oid=#Insert.IDENTITYCOL#</cfoutput>';
</script>

