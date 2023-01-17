<!--- Yetki Kontrollerine bakılacak. --->

<cfcomponent>	    
    <cffunction name="FilePath" returntype="string">
    	<cfargument name="circuit" required="yes" type="string">
    	<cfargument name="fuseaction" required="yes" type="string">
        <cfargument name="dataSource" required="yes" type="string">
    	<cfquery name="GET_FILE_PATH" datasource="#arguments.dataSource#">
        	SELECT
            	FILE_PATH
            FROM
            	WRK_OBJECTS
            WHERE
            	MODUL_SHORT_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.circuit#">
                AND FUSEACTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listLast(arguments.fuseaction,'.')#">
        </cfquery>
	    <cfreturn GET_FILE_PATH.FILE_PATH>
    </cffunction>
    <cffunction name="WindowType" returntype="string">
    	<cfargument name="circuit" required="yes" type="string">
    	<cfargument name="fuseaction" required="yes" type="string">
        <cfargument name="dataSource" required="yes" type="string">
    	<cfquery name="GET_WINDOW_TYPE" datasource="#arguments.dataSource#">
        	SELECT
            	WINDOW
            FROM
            	WRK_OBJECTS
            WHERE
            	MODUL_SHORT_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.circuit#">
                AND FUSEACTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listLast(arguments.fuseaction,'.')#">
        </cfquery>
	    <cfreturn GET_WINDOW_TYPE.WINDOW>
    </cffunction>
</cfcomponent>	
