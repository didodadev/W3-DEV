<cfset ADD_OIV = createObject("component","V16.settings.cfc.oiv")/>
<cfset Insert =ADD_OIV.Insert(
	ACCOUNT_CODE:attributes.Account_Code,
	ACCOUNT_CODE_P:attributes.Account_Code_p,
	ACCOUNT_CODE_IADE:attributes.Account_Code_iade,
	ACCOUNT_CODE_P_IADE:attributes.Account_Code_p_iade,
	TAX:"#filternum(attributes.tax_,3)#",
	tax_code:"#listfirst(attributes.tax_code)#",
	DETAIL:attributes.detail,
	tax_code_name :"#listlast(attributes.tax_code)#"
)/>
<script>
	<cfoutput>window.location.href = 'index.cfm?fuseaction=settings.list_oiv&event=upd&oid=#Insert.IDENTITYCOL#'</cfoutput>
</script>