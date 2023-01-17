<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="getComponentFunction">
        <cfquery name="GET_PRODUCT_STAGE" datasource="#DSN#_#session.ep.company_id#">
            SELECT * FROM PRODUCT_STAGE
        </cfquery>
        <cfreturn GET_PRODUCT_STAGE>        
    </cffunction>
</cfcomponent>
