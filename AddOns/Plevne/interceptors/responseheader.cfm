<cfloop query="active_headers">
    <cfset header_data = deserializeJSON(active_headers.RESPONSE_DATA)>
    <cfheader attributeCollection="#header_data#">
</cfloop>