<cfcomponent>

    <cffunction name="systemParam" access="public">
        <cfreturn application.systemParam>
    </cffunction>

    <cffunction name="Register" access="public">
        <cfset application.systemParam.systemParam = this.systemParam>
    </cffunction>

</cfcomponent>