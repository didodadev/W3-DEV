<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="LIB_CAT" datasource="#dsn#">
                SELECT * FROM LIBRARY_CAT
            </cfquery>
          <cfreturn LIB_CAT>
    </cffunction>
</cfcomponent>
