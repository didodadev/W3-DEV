<cfcomponent extends="WDO.catalogs.builders.componentbuilders.codegenerators.codegenerator">
    <cffunction name="generate" access="public" returntype="string">
        <cfargument name="data" type="any">
        <cfargument name="prefix" type="string" default="">
        <cfscript>
            resolver = createObject( "component", "WDO.catalogs.objectResolver" ).init();
            widgetcomponents = resolver.resolveByRequest( namespace:"WDO.catalogs.builders.widgetbuilder.widgetcomponents" );
        </cfscript>
        <cfif listlast( data.path, '.' ) eq "cfm">
            <cfscript>
                pagecode = "<c" & 'finclude template="/V16/Workdata/' & data.path & '">' & crlf();
                pagecode = pagecode & "<c" & "fscript>" & crlf();
                pagecode = pagecode & prefix;
                if (findNoCase(data.name, prefix) eq 0) {
                    pagecode = pagecode & data.name;
                }
                pagecode = pagecode & ' = ' & data.formula & ';' & crlf();
                pagecode = pagecode & "</c" & "fscript>";
                widgetcomponents.addOnload(prefix & data.name, pagecode);
            </cfscript>
        <cfelse>
            <cfscript>
                pagecode = "<c" & "fscript>" & crlf();
                pagecode = pagecode & 'mtd = createObject("component", "V16.workdata.' & listfirst(data.path, ".") & '");' & crlf();
                pagecode = pagecode & prefix & data.name & ' = mtd.' & data.formula & ';' & crlf();
                pagecode = pagecode & "</c" & "fscript>";
                widgetcomponents.addOnload(prefix & data.name, pagecode);
            </cfscript>
        </cfif>
        <cfreturn "">
    </cffunction>
</cfcomponent>