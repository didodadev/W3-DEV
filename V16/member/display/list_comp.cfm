<cfif isDefined('form.search_type') and form.search_type is 1>
	<cfinclude template="list_partner_comp.cfm">
<cfelse>
	<cfinclude template="list_company.cfm">
</cfif>
