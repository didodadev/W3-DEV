<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfquery name="LIB_CAT" datasource="#dsn#">
            SELECT * FROM LIBRARY_CAT
        </cfquery>
		<cfreturn LIB_CAT>
    </cffunction>
</cfcomponent>
