<cfcomponent extends="WDO.catalogs.builders.componentbuilders.codegenerators.codegenerator">
    <cffunction name="generate" access="public" returntype="string">
        <cfargument name="data" type="any">
        <cfargument name="prefix" type="string" default="">
        <cfscript>
            code = "<c" & "fset " & prefix;
            if (not findNoCase(data.name, prefix)) {
            code = code & data.name;
            }
            code = code & "=session." & data.formula & ">";
        </cfscript>
        <cfreturn code>
    </cffunction>
</cfcomponent>