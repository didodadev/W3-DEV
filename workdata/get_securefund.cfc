<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
    	<cfargument name="keyword" default="">
        	<cfquery name="GET_SECUREFUND" datasource="#dsn#">
            	SELECT * FROM SETUP_SECUREFUND
            </cfquery>
        <cfreturn GET_SECUREFUND>        
    </cffunction>
</cfcomponent>
