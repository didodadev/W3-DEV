<cffunction name="GET_WRK_WIDGET" access="public" returntype="query">
    <cfargument name="keyword" required="yes">
    <cfargument name="maxrow" required="yes">
    
    <cfquery name="find_widget" datasource="#dsn#">
        SELECT WIDGETID, WIDGET_TITLE, WIDGET_VERSION, WIDGET_EVENT_TYPE
        FROM WRK_WIDGET
        WHERE WIDGET_TITLE LIKE <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='%#arguments.keyword#%'>
    </cfquery>
    <cfreturn find_widget>
</cffunction>