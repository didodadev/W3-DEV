<cfcomponent>
    <cffunction name = "calcExpiresDate" access = "public">
        <cfargument name="expires_sec" type="numeric" required="true">

        <cfset expires_day = ceiling(arguments.expires_sec / 3600 / 60 / 24) />
        <cfset expiredDate = dateAdd('d', expires_day, now()) />

        <cfreturn expiredDate />

    </cffunction>
</cfcomponent>