<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_ASSETP_CAT" datasource="#dsn#">
                SELECT 
					* 
				FROM 
					ASSET_P_CAT
            </cfquery>
          <cfreturn GET_ASSETP_CAT>
    </cffunction>
</cfcomponent>

