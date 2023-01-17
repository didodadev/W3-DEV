<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getName" access="remote" returntype="string" returnFormat="plain">
    	<cfargument name="module" default="main">
    	<cfargument name="langNo" required="yes" default="">
        <cftry>
			<cfreturn application.functions.getLang('#arguments.module#',arguments.langNo)>
        <cfcatch>
        	<cfreturn 0>
        </cfcatch>
        </cftry>
    </cffunction>
	<cffunction name="insertList" access="remote" returntype="string" returnFormat="plain">
    	<cfargument name="data" required="yes" default="">
    	<cfargument name="controllerName" required="yes" default="">
        <cfargument name="hidden" required="no" default="">
        <cfquery name="INSERTLIST" datasource="#dsn#">
        	DELETE FROM
            	MODIFIED_PAGE
            WHERE
            	CONTROLLER_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.controllerName#">
                AND JSON_TYPE = 5
        	INSERT INTO MODIFIED_PAGE
            	(
                	JSON_DATA,
                    CONTROLLER_NAME,
                    JSON_TYPE,
                    EVENT_LIST,
                    POSITION_CODE
				)
            VALUES
            	(
                	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.data#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.controllerName#">,
					5,
                    'sort',
                    -1
                )
        </cfquery>
    </cffunction>
	<cffunction name="delList" access="remote" returntype="string" returnFormat="plain">
    	<cfargument name="controllerName" required="yes" default="">
        <cfquery name="DELETELIST" datasource="#dsn#">
        	DELETE FROM
            	MODIFIED_PAGE
            WHERE
            	CONTROLLER_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.controllerName#">
                AND JSON_TYPE = 5
        </cfquery>
    </cffunction>
	<cffunction name="addFavorite" access="remote" returntype="string" returnFormat="plain">
    	<cfargument name="elementId" required="yes" default="">
        <cfquery name="DELETELIST" datasource="#dsn#">
			UPDATE FAVORITES
            SET
            	SHOW = 1
            WHERE
            	FAVORITE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.elementId#">
        </cfquery>
        <cfquery name="getLIST" datasource="#dsn#">
			SELECT
            	FAVORITE_ID,
                FAVORITE,
                FAVORITE_NAME,
                IS_NEW_PAGE
            FROM
            	FAVORITES
			WHERE
            	FAVORITE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.elementId#">
			ORDER BY
            	FAVORITE_NAME
        </cfquery>
        <cfreturn Replace(serializeJSON(GETLIST),'//','')>
    </cffunction>
	<cffunction name="delFavorite" access="remote" returntype="string" returnFormat="plain">
    	<cfargument name="elementId" required="yes" default="">
        <cfquery name="DELETELIST" datasource="#dsn#">
			UPDATE FAVORITES
            SET
            	SHOW = 0
            WHERE
            	FAVORITE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.elementId#">
        </cfquery>
        <cfquery name="getLIST" datasource="#dsn#">
			SELECT
            	FAVORITE_ID,
                FAVORITE,
                FAVORITE_NAME,
                IS_NEW_PAGE
            FROM
            	FAVORITES
			WHERE
                SHOW = 1
			ORDER BY
            	FAVORITE_NAME
        </cfquery>
        <cfreturn Replace(serializeJSON(GETLIST),'//','')>
    </cffunction>
	<cffunction name="getFavorite" access="remote" returntype="string" returnFormat="plain">
        <cfargument name="Show_Top_Menu" default="true">
        <cfquery name="GETLIST" datasource="#dsn#">
			SELECT
            	FAVORITE_ID,
                FAVORITE,
                FAVORITE_NAME,
                IS_NEW_PAGE
			FROM
            	FAVORITES
			WHERE
                1 = 1
            	<cfif Show_Top_Menu eq "true">
                    AND   SHOW = 1
                </cfif>
                AND EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
			ORDER BY
            	FAVORITE_NAME
        </cfquery>
        <cfreturn Replace(serializeJSON(GETLIST),'//','')>
    </cffunction>    
</cfcomponent>
