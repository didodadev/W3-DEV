<!---
<cfparam name="attributes.modeldata" default="[]">
<cfparam name="attributes.fuseact" default="#attributes.fuseaction#">
<cfparam name="attributes.testmode" default="">

<cfif len(attributes.testmode)>
    <cfinclude template="./test.cfm">
<cfabort>
</cfif>

<cfif cgi.REQUEST_METHOD eq "post">
    <cfscript>
        designbuilder = createObject("component", "WDO.catalogs.builders.widgetbuilder.designbuilder").init(deserializeJSON(model));
        designcode = designbuilder.generate();
        writeOutput(designcode);
        abort;
    </cfscript>
<cfelse>
    <cfinclude template="../../../WDO/catalogs/designers/widgetdesigner/layout.cfm">
    <cfinclude template="../../../WDO/catalogs/designers/widgetdesigner/appengine.cfm">
</cfif>
--->