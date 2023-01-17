<cfset fuseact = listLast(attributes.wo, '.') />
<cfswitch expression = "#fuseact#">
    <cfcase value="emptypopup_get_js_query2">
		<cfinclude template="/V16/objects/query/get_js_query2.cfm">
	</cfcase>
</cfswitch>