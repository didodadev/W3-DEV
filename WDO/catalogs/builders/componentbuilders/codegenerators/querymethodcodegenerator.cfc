<cfcomponent extends="WDO.catalogs.builders.componentbuilders.codegenerators.codegenerator">
    <cffunction name="generate" access="public" returntype="string">
        <cfargument name="data" type="any">
        <cfargument name="prefix" type="string" default="">
        <cfscript>
            code = "<c" & "fscript>" & crlf();
            code = code & 'mtd = createObject("component", "utility.' & listfirst(data.path, ".") & '");' & crlf();
            code = code & prefix;
            if (findNoCase(data.name, prefix) eq 0) {
            code = code & data.name;
            }
            code = code & ' = mtd.' & data.formula & ';' & crlf();
            code = code & "</c" & "fscript>";
        </cfscript>
        <cfreturn code>
    </cffunction>
</cfcomponent>