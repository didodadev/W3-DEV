<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_CARD_CHANGE_TYPE" datasource="#dsn#">
                SELECT * FROM SETUP_CARD_CHANGE_TYPES
            </cfquery>
          <cfreturn GET_CARD_CHANGE_TYPE>
    </cffunction>
</cfcomponent>

