<cffunction name="appendUrl" access="public" returntype="string">
    <cfargument name="data">
    <cfargument name="key">
    <cfargument name="prm">
    <cfscript>
        result = arguments.data;
        if (isDefined("arguments.value") && len(arguments.value)) {
            result = result & arguments.key & arguments.value;
        }
    </cfscript>
    <cfreturn result>
</cffunction>