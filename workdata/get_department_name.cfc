<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_DEPARTMENT_NAME" datasource="#dsn#">
                SELECT * FROM SETUP_DEPARTMENT_NAME
            </cfquery>
          <cfreturn GET_DEPARTMENT_NAME>
    </cffunction>
</cfcomponent>

