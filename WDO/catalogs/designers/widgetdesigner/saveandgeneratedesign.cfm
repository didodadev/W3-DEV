<cfset getPageContext().getCFOutput().clear()>
<cfscript>
    writeOutput( saveandgenerate( attributes.model, attributes.event_type ) );
    abort;
</cfscript>