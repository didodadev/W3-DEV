<cfset wos = findWO( head: attributes.keyword )>
<cfset GetPageContext().getCFOutput().clear()>
<cfoutput>#lcase( replace( serializeJSON( wos ), "//", "" ) )#</cfoutput>
<cfabort>