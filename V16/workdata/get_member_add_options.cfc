<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_MEMBER_ADD_OPTIONS" datasource="#dsn#">
                SELECT 
					MEMBER_ADD_OPTION_ID,
					#dsn#.Get_Dynamic_Language(MEMBER_ADD_OPTION_ID,'#session.ep.language#','SETUP_MEMBER_ADD_OPTIONS','MEMBER_ADD_OPTION_NAME',NULL,NULL,MEMBER_ADD_OPTION_NAME) AS MEMBER_ADD_OPTION_NAME,
					DETAIL,
					IS_INTERNET
				FROM 
					SETUP_MEMBER_ADD_OPTIONS
            </cfquery>
          <cfreturn GET_MEMBER_ADD_OPTIONS>
    </cffunction>
</cfcomponent>

