<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="GET_MAIL_WARNING" datasource="#dsn#">
            SELECT * FROM SETUP_MAIL_WARNING
        </cfquery>
		<cfreturn GET_MAIL_WARNING>
    </cffunction>
</cfcomponent>

