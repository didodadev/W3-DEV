<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
		<cfquery name="GET_DRIVER_LICENCE" datasource="#dsn#">
			SELECT * FROM SETUP_DRIVERLICENCE
		</cfquery>
	   <cfreturn GET_DRIVER_LICENCE>
    </cffunction>
</cfcomponent>

