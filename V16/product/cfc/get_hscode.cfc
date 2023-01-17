<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn1 = application.systemParam.systemParam().dsn1>

    <cffunction name="getHSCodeChapter" access="public" returntype="query">
        <cfargument name="get_hscode_chapter" default="">
        <cfquery name="GET_HSCODE_CHAPTER" datasource="#DSN#">
			SELECT 
                HSCHAPTER_DETAIL,
                HSCHAPTER_NO
            FROM 
                #dsn1#.HSCODE_CHAPTER
		</cfquery>
        <cfreturn GET_HSCODE_CHAPTER>
    </cffunction>

    <cffunction name="getHSCode" access="public" returntype="query">
        <cfargument name="get_hscode" default="">
        <cfargument name="hschapter_no" default="">
        <cfquery name="GET_HSCODE" datasource="#DSN#">
            SELECT 
                HSCODE_,
                HSCODE_DETAIL,
                HSCHAPTER_NO
            FROM 
                #dsn1#.HSCODE
            <cfif len(arguments.hschapter_no)>
            WHERE HSCHAPTER_NO = #arguments.hschapter_no#
            </cfif>
            <cfif len(arguments.keyword)>
                    WHERE HSCODE_ LIKE '%#arguments.keyword#%' OR HSCODE_DETAIL LIKE '%#arguments.keyword#%'
			</cfif>
		</cfquery>
        <cfreturn GET_HSCODE>
    </cffunction>
</cfcomponent>