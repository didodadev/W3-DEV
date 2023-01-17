<cfcomponent>
	<cfsetting requesttimeout="2000">
    <cffunction name="moduleAuthority" access="remote" returntype="struct">
        <cfargument name="datasource" default="#dsn#" required="yes">
        <cfargument name="employee_id" default="#dsn#" required="yes">
        <cfquery name="GET_MODULE_AUTHORITY" datasource="#arguments.datasource#">
            SELECT
                M.MODULE_ID
            FROM
                MODULES AS M
                JOIN (
                         SELECT A.USER_GROUP_PERMISSIONS,  
                             Split.a.value('.', 'VARCHAR(100)') AS String  
                         FROM  
                            (
                                SELECT U.USER_GROUP_PERMISSIONS, CAST ('<M>' + REPLACE(U.USER_GROUP_PERMISSIONS, ',', '</M><M>') + '</M>' AS XML) AS String
                                FROM EMPLOYEE_POSITIONS AS EP LEFT JOIN USER_GROUP AS U ON U.USER_GROUP_ID = EP.USER_GROUP_ID
                                WHERE
                                	EP.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">) AS A CROSS APPLY String.nodes ('/M') AS Split(a) ) AS X ON X.String = M.MODULE_ID
        </cfquery>
        <cfif not GET_MODULE_AUTHORITY.recordcount>
            <cfquery name="GET_MODULE_AUTHORITY" datasource="#arguments.datasource#">
                SELECT
                    M.MODULE_ID
                FROM
                    MODULES AS M
                    JOIN (
                             SELECT A.LEVEL_ID,  
                                 Split.a.value('.', 'VARCHAR(100)') AS String  
                             FROM  
                                (
                                    SELECT LEVEL_ID, CAST ('<M>' + REPLACE(LEVEL_ID, ',', '</M><M>') + '</M>' AS XML) AS String  
                                    FROM  EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">) AS A CROSS APPLY String.nodes ('/M') AS Split(a) ) AS X ON X.String = M.MODULE_ID
            </cfquery>
            <cfset authorityModules = valuelist(GET_MODULE_AUTHORITY.MODULE_ID,',')>
        </cfif>
        <cfquery name="GET_PAGE_AUTHORITY" datasource="#arguments.datasource#">
            SELECT 
                EPD.IS_VIEW,
                EPD.DENIED_PAGE	
            FROM
                EMPLOYEE_POSITIONS_DENIED AS EPD,
                EMPLOYEE_POSITIONS AS EP
            WHERE
                EP.EMPLOYEE_ID = POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#"> AND 
                EPD.DENIED_TYPE = 0 AND
                EPD.IS_VIEW = 1 AND
                ( 
                    EPD.POSITION_CODE = EP.POSITION_CODE OR
                    EPD.POSITION_CAT_ID = EP.POSITION_CAT_ID OR
                    EPD.USER_GROUP_ID = EP.USER_GROUP_ID
                )
        </cfquery>
        <cfscript>
            application.moduleAuthority = structNew();
            for(i=1;i<=GET_MODULE_AUTHORITY.recordcount;i++)
            {
                application.moduleAuthority['#GET_WRK_OBJECTS.MODUL_SHORT_NAME[i]#.#GET_WRK_OBJECTS.FUSEACTION[i]#'] = structNew();
                application.moduleAuthority['#GET_WRK_OBJECTS.MODUL_SHORT_NAME[i]#.#GET_WRK_OBJECTS.FUSEACTION[i]#']['window'] = GET_WRK_OBJECTS.WINDOW[i];
                application.moduleAuthority['#GET_WRK_OBJECTS.MODUL_SHORT_NAME[i]#.#GET_WRK_OBJECTS.FUSEACTION[i]#']['filePath'] = GET_WRK_OBJECTS.FILE_PATH[i];
            }
			for(i=1;i<GET_PAGE_AUTHORITY.recordcount;i++) // Kullanıcının yasaklı olup göremeyeceği sayfalarını belirliyoruz.
			{
				application.moduleAuthority['#GET_PAGE_AUTHORITY.DENIED_PAGE[i]#'] = 1;
			}
        </cfscript>
		<cfreturn application.objects>
    </cffunction>
</cfcomponent>
