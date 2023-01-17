<cfparam name="attributes.model" default="">
<cfparam name="attributes.process" default="">
<cfparam name="attributes.fuseact" default="">

<cfinclude template="./catalogs/designers/modeldesigner/model.cfm">

<cfif cgi.REQUEST_METHOD eq "POST" && len(attributes.process) && attributes.process eq "preview">
    <cfscript>
        writeOutput(preview(attributes.model));
    </cfscript>
    <cfabort>
<cfelseif cgi.REQUEST_METHOD eq "POST" and len(attributes.process) && attributes.process eq "save">
    <cfscript>
        saveStatus = save(attributes.model);
        if (saveStatus eq 1)
        {
            writeOutput("Kayit Tamamlandi");
        }
        else 
        {
            writeDump(saveStatus);    
        }
    </cfscript>
    <cfabort>
<cfelseif cgi.REQUEST_METHOD eq "POST" and len(attributes.process) && attributes.process eq "generate">
    <cfscript>
        saveStatus = saveandgenerate(attributes.model);
        if (saveStatus eq 1)
        {
            writeOutput("Kayit ve Generate Tamamlandi");
        }
        else 
        {
            writeDump(saveStatus);    
        }
    </cfscript>
    <cfabort>
<cfelse>
    <cfset attributes.model = load(attributes.fuseact)>
    <cfinclude template="./catalogs/designers/modeldesigner/layout.cfm">
    <cfinclude template="./catalogs/designers/modeldesigner/appengine.cfm">
</cfif>