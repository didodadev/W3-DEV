<cfset UPD_OIV = createObject("component","V16.settings.cfc.oiv")/>
<cfset UPDATE =UPD_OIV.UPDATE(
    OIV_ID : attributes.OID,
	ACCOUNT_CODE:attributes.Account_Code,
	ACCOUNT_CODE_P:attributes.Account_Code_p,
	ACCOUNT_CODE_IADE:attributes.Account_Code_iade,
	ACCOUNT_CODE_P_IADE:attributes.Account_Code_p_iade,
	TAX:#filternum(attributes.tax_,3)#,
	tax_code:"#listfirst(attributes.tax_code)#",
	tax_code_name :"#listlast(attributes.tax_code)#",
	DETAIL:attributes.detail
)/>
<script>
	<cfoutput>window.location.href = 'index.cfm?fuseaction=settings.list_oiv&event=upd&oid=#attributes.OID#'</cfoutput>
</script>