<cfcomponent>

    <cffunction name="generate" access="public" returntype="any">
        <cfargument name="langno" type="string">
        <cfset result = "<c" & "f_get_lang dictionary_id='" & listfirst( arguments.langno, '.' ) & "'>">
        <cfreturn result>
    </cffunction>

</cfcomponent>