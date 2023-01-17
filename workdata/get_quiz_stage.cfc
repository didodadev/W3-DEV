<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_QUIZ_STAGE" datasource="#dsn#">
                SELECT * FROM SETUP_QUIZ_STAGE
            </cfquery>
          <cfreturn GET_QUIZ_STAGE>
    </cffunction>
</cfcomponent>

