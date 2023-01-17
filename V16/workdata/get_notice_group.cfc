<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="GET_NOTICE_GROUP" datasource="#dsn#">
            SELECT * FROM SETUP_NOTICE_GROUP
        </cfquery>
		<cfreturn GET_NOTICE_GROUP>
    </cffunction>
</cfcomponent>

