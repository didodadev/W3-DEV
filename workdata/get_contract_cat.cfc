<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_CONTRACT_CAT" datasource="#DSN#_#session.ep.company_id#">
                SELECT * FROM CONTRACT_CAT
            </cfquery>
          <cfreturn GET_CONTRACT_CAT>
    </cffunction>
</cfcomponent>

