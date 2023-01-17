<cfcomponent>
    <cffunction name="createComponents" access="public" returntype="any">
        <cfargument name="data" type="any">
        <cfargument name="fuseaction" type="string">
        <cfscript>
            if (directoryExists(expandPath("./AddOns/")) neq 1)
            {
                throw("AddOns klasörü bulunamadı!");
            }
            
            componentGenerator = createObject("component", "WDO.catalogs.builders.componentbuilders.compositbuilders.componentgenerator");
            comps = componentGenerator.generate(data=arguments.data);

            familyname = listfirst(fuseaction, ".");
            modelname = listgetat(fuseaction, 2, ".");

            directoryCreateExists("./AddOns/#familyname#");
            directoryCreateExists("./AddOns/#familyname#/cfc");

            comp = "<c" & 'fcomponent extends="WDO.catalogs.dataComponent">' & crlf();
            for (i=1; i<=arrayLen(structKeyArray(comps)); i++)
            {
                structName = structKeyArray(comps)[i];
                comp = comp & comps[structName] & crlf() & crlf();
            }
            comp = comp & "</cfcomponent>";
            
            fileWrite(expandPath("./AddOns/#familyname#/#modelname#/cfc/model.cfc"), comp);
        </cfscript>
    </cffunction>

    <!--- local helpers --->
    <cffunction name="directoryCreateExists" access="private">
        <cfargument name="path" type="string">
        <cfscript>
            if (directoryExists(expandPath(arguments.path)) neq 1)
            {
                directoryCreate(expandPath(arguments.path));
            }
        </cfscript>
    </cffunction>

    <cffunction name="crlf" access="private" returntype="string">
        <cfreturn CreateObject("java", "java.lang.System").getProperty("line.separator")>
    </cffunction>
</cfcomponent>