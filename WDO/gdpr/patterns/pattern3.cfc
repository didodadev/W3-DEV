<cfcomponent>

    <cffunction name="pattern">
        <cfargument name="value" default="">

        <cfset result = reReplaceNoCase(arguments.value, "(\w{1,3})\w*@\w*(\w{2,2})\.(\w{2,3}[\.\w{2,3}]*)", "\1***@***\2.\3")>
        <cfif result eq arguments.value>
            <cfreturn "***">
        <cfelse>
            <cfreturn result>
        </cfif>
    </cffunction>

</cfcomponent>