<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_WORKGROUP_TYPE" datasource="#dsn#">
                SELECT * FROM SETUP_WORKGROUP_TYPE
            </cfquery>
          <cfreturn GET_WORKGROUP_TYPE>
    </cffunction>
</cfcomponent>

