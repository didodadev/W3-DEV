<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_SOCIAL_MEDIA_WORDS" datasource="#dsn#">
                SELECT * FROM SOCIAL_MEDIA_SEARCH_WORDS
            </cfquery>
          <cfreturn GET_SOCIAL_MEDIA_WORDS>
    </cffunction>
</cfcomponent>
