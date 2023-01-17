<cfcomponent>
    <cffunction name="webtime2date" returntype="any">
        <cfargument name="webtime">
        <cfscript>
            arguments.webtime = reReplace(arguments.webtime, '\+[0-9]{2,2}:[0-9]{2,2}', '');
            arguments.webtime = reReplace(arguments.webtime, '\.[0-9]{1,3}$', '');
            arguments.webtime = replace(arguments.webtime, "T", " ");
            return arguments.webtime;
        </cfscript>
    </cffunction>
</cfcomponent>