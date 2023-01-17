<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_ACC_TYPE" datasource="#dsn#">
                SELECT * FROM SETUP_ACC_TYPE
            </cfquery>
          <cfreturn GET_ACC_TYPE>
    </cffunction>
</cfcomponent>

