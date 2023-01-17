<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_COMPUTER_INFO" datasource="#dsn#">
                SELECT * FROM SETUP_COMPUTER_INFO
            </cfquery>
          <cfreturn GET_COMPUTER_INFO>
    </cffunction>
</cfcomponent>
