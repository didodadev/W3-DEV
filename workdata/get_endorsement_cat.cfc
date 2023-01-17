<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_ENDORSEMENT_CAT" datasource="#dsn#">
                SELECT * FROM SETUP_ENDORSEMENT_CAT
            </cfquery>
          <cfreturn GET_ENDORSEMENT_CAT>
    </cffunction>
</cfcomponent>

