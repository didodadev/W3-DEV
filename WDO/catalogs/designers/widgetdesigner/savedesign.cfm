<cfset getPageContext().getCFOutput().clear()>
<cfscript>
    writeOutput( save( attributes.model, attributes.event_type ) );
    abort;
</cfscript>