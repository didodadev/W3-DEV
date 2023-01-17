<cfcomponent>

    <cffunction name="pattern">
        <cfargument name="value" default="">

        <cfset result = reReplaceNoCase(arguments.value, "(0*\d{3,3})\s*\d{3,3}\s*\d(\d{3,3})", "\1****\2")>
        <cfif result eq arguments.value>
            <cfreturn "***">
        <cfelse>
            <cfreturn result>
        </cfif>
    </cffunction>

</cfcomponent>