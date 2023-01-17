<cfcomponent extends="WDO.catalogs.builders.componentbuilders.codegenerators.codegenerator">
    <cffunction name="generate">
        <cfargument name="data" type="any">
        <cfargument name="prefix" type="string" default="">
        <cfscript>
            postfix = findNoCase('customcode', arguments.prefix) gt 0 ? '' : 'customcode';
            //randname = "fn" & lcase(replace(createUUID(), "-", "_", "all"));
            elementname = arguments.prefix & postfix;
            codecontent = "";
            codecontent = codecontent & '<c' & 'ffunction name="' & elementname & '_func">' & crlf(); 
            codecontent = codecontent & data.formula & crlf();
            codecontent = codecontent & '</c' & 'ffunction>' & crlf();

            resolver = createObject( "component", "WDO.catalogs.objectResolver" ).init();
            widgetcomponents = resolver.resolveByRequest( namespace:"WDO.catalogs.builders.widgetbuilder.widgetcomponents" );
            widgetcomponents.addOnload(elementname & '_func', codecontent);

            result = '<c' & 'fset ' & elementname & ' = ' & elementname & '_func()>';
        </cfscript>
        <cfreturn result>
    </cffunction>
</cfcomponent>