<cfset getPageContext().getCFOutput().clear()>
<cfscript>
repponse = layouttodb( id: attributes.id, structure: attributes.layout);
writeOutput( LCase( Replace( serializeJson( repponse ), "//", "" ) ) );
</cfscript>
<cfabort>