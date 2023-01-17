<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_SETUP_LANGUAGES" datasource="#dsn#">
                SELECT * FROM SETUP_LANGUAGES
            </cfquery>
          <cfreturn GET_SETUP_LANGUAGES>
    </cffunction>
</cfcomponent>

