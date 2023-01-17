<cfif isDefined('form.search_type') and form.search_type is 0>
	<cfinclude template="form_list_company.cfm">
<cfelse>	
	<cfinclude template="list_partner.cfm">
</cfif>
