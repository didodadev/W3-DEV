<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="GET_SETUP_NET_CONNECTION" datasource="#dsn#">
            SELECT * FROM SETUP_NET_CONNECTION
        </cfquery>
		<cfreturn GET_SETUP_NET_CONNECTION>
    </cffunction>
</cfcomponent>
