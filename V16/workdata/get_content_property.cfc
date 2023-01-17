<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getComponentFunction">
        <cfargument name="keyword" default="">
            <cfquery name="GET_CONTENT_PROPERTY" datasource="#dsn#">
                SELECT 
					CONTENT_PROPERTY.CONTENT_PROPERTY_ID,
					#dsn#.Get_Dynamic_Language(CONTENT_PROPERTY.CONTENT_PROPERTY_ID,'#session.ep.language#','CONTENT_PROPERTY','NAME',NULL,NULL,NAME) AS NAME,
 					DESCRIPTION
				FROM 
					CONTENT_PROPERTY LEFT JOIN CONTENT_PROPERTY_PERM
                    ON CONTENT_PROPERTY.CONTENT_PROPERTY_ID = CONTENT_PROPERTY_PERM.CONTENT_PROPERTY_ID
                WHERE
                	CONTENT_PROPERTY_PERM.POSITION_CODE IN (#session.ep.position_code#)
                ORDER BY
                	NAME
            </cfquery>
           <cfreturn GET_CONTENT_PROPERTY>
    </cffunction>
</cfcomponent>
