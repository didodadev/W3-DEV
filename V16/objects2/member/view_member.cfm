<cfif not isdefined('attributes.company_id')>
	<cfset attributes.company_id = #session.pp.company_id#>
</cfif>
<div class="form-row">
    <cfinclude template="my_company_detail.cfm">
</div><br/>
<div class="form-row">
    <cfinclude template="my_company_partner_detail.cfm">
</div><br/>
<div class="form-row">
    <cfinclude template="my_company_address_detail.cfm">
</div>