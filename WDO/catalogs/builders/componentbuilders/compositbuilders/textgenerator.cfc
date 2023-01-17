<cfcomponent>
    <cffunction name="createComponents" access="public" returntype="string">
        <cfargument name="data" type="any">
        <cfargument name="fuseaction" type="string">
        <cfscript>
            
            componentGenerator = createObject("component", "WDO.catalogs.builders.componentbuilders.compositbuilders.componentgenerator");
            comps = componentGenerator.generate(data=arguments.data);

            comp = "<c" & 'fcomponent extends="WDO.catalogs.dataComponent">' & crlf();
            if ( isDefined( "componentGenerator.componentprops" ) and arrayLen( componentGenerator.componentprops ) ) {
                comp = comp & crlf() & arrayToList( componentGenerator.componentprops, crlf() ) & crlf();
            }
            comp = comp & crlf() & '<cfset dsn = application.systemParam.systemParam().dsn>';
            comp = comp & crlf() & '<cfset dsn1 = application.systemParam.systemParam().dsn & "_product">';
            comp = comp & crlf() & '<cfset dsn2 = application.systemParam.systemParam().dsn & "_" & session.ep.period_year & "_" & session.ep.company_id>';
            comp = comp & crlf() & '<cfset dsn3 = application.systemParam.systemParam().dsn & "_" & session.ep.company_id>' & crlf();
            for (i=1; i<=arrayLen(structKeyArray(comps)); i++)
            {
                structName = structKeyArray(comps)[i];
                comp = comp & crlf() & comps[structName] & crlf() & crlf();
            }
            comp = comp & "</cfcomponent>";
            
        </cfscript>
        <cfreturn comp>
    </cffunction>

    <!--- local helpers --->

    <cffunction name="crlf" access="private" returntype="string">
        <cfreturn CreateObject("java", "java.lang.System").getProperty("line.separator")>
    </cffunction>
</cfcomponent>