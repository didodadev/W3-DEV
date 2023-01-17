<cfcomponent extends="WDO.catalogs.builders.componentbuilders.codegenerators.codegenerator">
    <cffunction name="generate" access="public" returntype="string">
        <cfargument name="data" type="any">
        <cfargument name="prefix" type="string" default="">
        <cfscript>
            pagecode = "<c" & 'fset ' & prefix & ' = createObject("component", "workdata.wrk_lists").get("' & data.groupkey & '")>' & crlf();
            
            resolver = createObject( "component", "WDO.catalogs.objectResolver" ).init();
            widgetcomponents = resolver.resolveByRequest( namespace:"WDO.catalogs.builders.widgetbuilder.widgetcomponents" );
            widgetcomponents.addOnload(prefix, pagecode);

            code = "";
        </cfscript>
        <cfreturn code>
    </cffunction>
</cfcomponent>