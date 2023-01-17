<cfset getPageContext().getCFOutput().clear()>
<cfscript>
    designcode = preview(attributes.model);
    writeOutput(designcode);
    abort;
</cfscript>