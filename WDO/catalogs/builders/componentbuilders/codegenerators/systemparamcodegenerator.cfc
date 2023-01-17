<cfcomponent extends="WDO.catalogs.builders.componentbuilders.codegenerators.codegenerator">
    <cffunction name="generate" access="public" returntype="string">
        <cfargument name="data" type="any">
        <cfargument name="prefix" type="string" default="">
        <cfscript>
            code = "<c" & 'fset ' & prefix;
            if (findNoCase(data.name, prefix)) {
            code = code & data.name;
            }
            code = code & '= CreateObject("component", "WMO.params").' & data.formula & '>';
        </cfscript>
        <cfreturn code>
    </cffunction>
</cfcomponent>