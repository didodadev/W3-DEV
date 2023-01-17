<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_SPECIAL_DEFINITION" datasource="#dsn#">
                SELECT * FROM SETUP_SPECIAL_DEFINITION <cfif Len(arguments.keyword)>WHERE SPECIAL_DEFINITION_TYPE = #arguments.keyword#</cfif> ORDER BY SPECIAL_DEFINITION_TYPE,SPECIAL_DEFINITION
            </cfquery>
          <cfreturn GET_SPECIAL_DEFINITION>
    </cffunction>
</cfcomponent>
