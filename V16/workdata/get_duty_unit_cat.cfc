<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="GET_DUTY_UNIT_CAT" datasource="#dsn#">
            SELECT * FROM SETUP_DUTY_UNIT_CAT
        </cfquery>
		<cfreturn GET_DUTY_UNIT_CAT>
    </cffunction>
</cfcomponent>

