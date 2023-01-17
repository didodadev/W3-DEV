<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="getComponentFunction">
	    <cfargument name="keyword" default="">
            <cfquery name="GET_SERVICE_SUBSTATUS" datasource="#DSN#_#session.ep.company_id#">
                SELECT * FROM SERVICE_SUBSTATUS
            </cfquery>
        <cfreturn GET_SERVICE_SUBSTATUS>        
    </cffunction>
</cfcomponent>
