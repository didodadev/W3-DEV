<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_REQ_TYPE" datasource="#dsn#">
                SELECT * FROM SETUP_REQ_TYPE
            </cfquery>
          <cfreturn GET_REQ_TYPE>
    </cffunction>
</cfcomponent>

