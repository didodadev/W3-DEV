<cfcomponent>
    <!--- CR + LF chars --->
    <cffunction name="crlf" access="public" returntype="string">
        <cfreturn CreateObject("java", "java.lang.System").getProperty("line.separator")>
    </cffunction>

    <!--- Disticate an array --->
    <cffunction name="distinctArray" access="public" returntype="array">
        <cfargument name="data" type="array">
        <cfscript>
            var output = arrayNew(1);
		    output.addAll(createObject("java", "java.util.HashSet").init(arguments.data));
		    return output;
        </cfscript>
    </cffunction>

</cfcomponent>