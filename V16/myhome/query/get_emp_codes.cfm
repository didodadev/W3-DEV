<cfif len(session.ep.authority_code_hr)>
	<cfset emp_code_list = ListChangeDelims(session.ep.authority_code_hr, "+", ".")>
	<cfif isdefined("attributes.hierarchy") and len(attributes.hierarchy)>
		<cfset emp_code_list = ListAppend(emp_code_list, ListChangeDelims(attributes.hierarchy, "+", "."), "+")>
	</cfif>
<cfelseif isdefined("attributes.hierarchy") and len(attributes.hierarchy)>
	<cfset emp_code_list = ListChangeDelims(attributes.hierarchy, "+", ".")>
<cfelse>
	<cfset emp_code_list = "">
</cfif>
