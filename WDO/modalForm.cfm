<cfparam name="attributes.fuseact" default="#attributes.fuseaction#">

<cfinclude template="./catalogs/designers/widgetdesigner/model.cfm">
<cfif cgi.REQUEST_METHOD eq "post" and attributes.process eq "preview">
    <cfscript>
        designcode = preview(attributes.model);
        writeOutput(designcode);
        abort;
    </cfscript>
<cfelseif cgi.REQUEST_METHOD eq "post" and attributes.process eq "save">
    <cfscript>
        save(attributes.model);
        writeOutput( "Kayit basariyla tamamlandi" );
        abort;
    </cfscript>
<cfelseif cgi.REQUEST_METHOD eq "post" and attributes.process eq "saveandgenerate">
    <cfscript>
        saveandgenerate(attributes.model);
        writeOutput( "Kayit basariyla tamamlandi" );
        abort;
    </cfscript>
<cfelse>
    <cfset attributes.modeldata = loadModel(attributes.fuseact)>
    <cfinclude template="./catalogs/designers/widgetdesigner/layout.cfm">
    <cfinclude template="./catalogs/designers/widgetdesigner/appengine.cfm">
    
</cfif>