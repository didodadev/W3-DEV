<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_ACCIDENT_TYPE" datasource="#dsn#">
                SELECT * FROM SETUP_ACCIDENT_TYPE
            </cfquery>
          <cfreturn GET_ACCIDENT_TYPE>
    </cffunction>
</cfcomponent>

