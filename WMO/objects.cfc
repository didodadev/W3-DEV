<cfcomponent>
    <cffunction name="workcubeObjects" access="remote" returntype="struct">
        <cfargument name="datasource" default="#dsn#" required="yes">
        <cfquery name="GET_WRK_OBJECTS" datasource="#arguments.datasource#">
            SELECT
                WINDOW,
                FULL_FUSEACTION,
                MODUL_SHORT_NAME,
                FUSEACTION,
                FILE_PATH,
                DICTIONARY_ID,
                CASE WHEN ADDOPTIONS_CONTROLLER_FILE_PATH IS NOT NULL THEN ADDOPTIONS_CONTROLLER_FILE_PATH ELSE CONTROLLER_FILE_PATH END AS CONTROLLER_FILE_PATH,
                MODULE_NO,
                FRIENDLY_URL,
				IS_LEGACY,
                ISNULL(LICENCE,1) AS LICENCE,
                DISPLAY_BEFORE_PATH,
                DISPLAY_AFTER_PATH,
                ACTION_BEFORE_PATH,
                ACTION_AFTER_PATH,
                SECURITY,
                TYPE,
                XML_PATH
            FROM
                WRK_OBJECTS
        </cfquery>
        <cfscript>
            application.objects = structNew();
            for(i=1;i<=GET_WRK_OBJECTS.recordcount;i++)
            {
                application.objects['#GET_WRK_OBJECTS.FULL_FUSEACTION[i]#'] = structNew();
                application.objects['#GET_WRK_OBJECTS.FULL_FUSEACTION[i]#']['window'] = GET_WRK_OBJECTS.WINDOW[i];
                application.objects['#GET_WRK_OBJECTS.FULL_FUSEACTION[i]#']['filePath'] = GET_WRK_OBJECTS.FILE_PATH[i];
				application.objects['#GET_WRK_OBJECTS.FULL_FUSEACTION[i]#']['DICTIONARY_ID'] = GET_WRK_OBJECTS.DICTIONARY_ID[i];
				application.objects['#GET_WRK_OBJECTS.FULL_FUSEACTION[i]#']['CONTROLLER_FILE_PATH'] = GET_WRK_OBJECTS.CONTROLLER_FILE_PATH[i];
				application.objects['#GET_WRK_OBJECTS.FULL_FUSEACTION[i]#']['MODULE_NO'] = GET_WRK_OBJECTS.MODULE_NO[i];
				application.objects['#GET_WRK_OBJECTS.FULL_FUSEACTION[i]#']['FRIENDLY_URL'] = GET_WRK_OBJECTS.FRIENDLY_URL[i];
				application.objects['#GET_WRK_OBJECTS.FULL_FUSEACTION[i]#']['LEGACY'] = GET_WRK_OBJECTS.IS_LEGACY[i];
                application.objects['#GET_WRK_OBJECTS.FULL_FUSEACTION[i]#']['LICENCE'] = GET_WRK_OBJECTS.LICENCE[i];
                application.objects['#GET_WRK_OBJECTS.FULL_FUSEACTION[i]#']['DISPLAY_BEFORE_PATH'] = GET_WRK_OBJECTS.DISPLAY_BEFORE_PATH[i];
                application.objects['#GET_WRK_OBJECTS.FULL_FUSEACTION[i]#']['DISPLAY_AFTER_PATH'] = GET_WRK_OBJECTS.DISPLAY_AFTER_PATH[i];
                application.objects['#GET_WRK_OBJECTS.FULL_FUSEACTION[i]#']['ACTION_BEFORE_PATH'] = GET_WRK_OBJECTS.ACTION_BEFORE_PATH[i];
                application.objects['#GET_WRK_OBJECTS.FULL_FUSEACTION[i]#']['ACTION_AFTER_PATH'] = GET_WRK_OBJECTS.ACTION_AFTER_PATH[i];
                application.objects['#GET_WRK_OBJECTS.FULL_FUSEACTION[i]#']['SECURITY'] = GET_WRK_OBJECTS.SECURITY[i];
                application.objects['#GET_WRK_OBJECTS.FULL_FUSEACTION[i]#']['TYPE'] = GET_WRK_OBJECTS.TYPE[i];
                application.objects['#GET_WRK_OBJECTS.FULL_FUSEACTION[i]#']['XML_PATH'] = GET_WRK_OBJECTS.XML_PATH[i];
                
            }
        </cfscript>
		<cfreturn application.objects>
    </cffunction>
    <cffunction name="workObjects" access="remote" returntype="query">
    	<cfargument name="dataSource" required="yes" default="">
        <cfargument name="employeeId" required="yes" default="">
        <cfargument name="fuseact" required="yes" default="">
        <cfquery name="workObjects" datasource="#arguments.dataSource#">
            SELECT
                W.FULL_FUSEACTION AS FUSEACTION
            FROM
                WRK_OBJECTS AS W
                LEFT JOIN WRK_MODULE AS M ON M.MODULE_NO = W.MODULE_NO
                JOIN (
                    SELECT A.USER_GROUP_PERMISSIONS,  
                        Split.a.value('.', 'VARCHAR(100)') AS String  
                    FROM  
                    (
                        SELECT U.USER_GROUP_PERMISSIONS, CAST ('<M>' + REPLACE(U.USER_GROUP_PERMISSIONS, ',', '</M><M>') + '</M>' AS XML) AS String
                        FROM EMPLOYEE_POSITIONS AS EP LEFT JOIN USER_GROUP AS U ON U.USER_GROUP_ID = EP.USER_GROUP_ID
                        WHERE
                            EP.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employeeId#">) AS A CROSS APPLY String.nodes ('/M') AS Split(a) ) AS X ON X.String = M.MODULE_NO
            WHERE
                W.MODUL_SHORT_NAME + '.' + W.FUSEACTION IS NOT NULL
                AND W.FULL_FUSEACTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fuseAct#">
            GROUP BY
                W.FULL_FUSEACTION
        </cfquery>
		<cfreturn workObjects>
    </cffunction>
    <cffunction name="parametricObjects" access="remote" returntype="struct">
    	<cfargument name="dataSource" required="yes" default="">
        <cfquery name="parametricObjects" datasource="#arguments.dataSource#">
            SELECT
            	W.MODULE_NO,
				W.DICTIONARY_ID,
                W.FULL_FUSEACTION,
				S.ITEM_TR
            FROM
            	WRK_OBJECTS W
				LEFT JOIN SETUP_LANGUAGE_TR AS S ON S.DICTIONARY_ID = W.DICTIONARY_ID
            WHERE
            	W.TYPE = 1
            ORDER BY
				W.MODULE_NO,
                S.ITEM_TR
        </cfquery>
        <cfscript>
			application.parametricObjects = structNew();
			sayac = 0;
			for(i=0;i<=parametricObjects.recordcount;i++)
			{
				if(i eq 0 or (i gt 0 and parametricObjects.MODULE_NO[i] eq parametricObjects.MODULE_NO[i-1]))
					sayac = sayac + 1;
				else
					sayac = 0;
				application.parametricObjects[parametricObjects.MODULE_NO[i]][sayac]['ITEM'] = '#parametricObjects.ITEM_TR[i]#';
				application.parametricObjects[parametricObjects.MODULE_NO[i]][sayac]['FUSEACTION'] = '#parametricObjects.FULL_FUSEACTION[i]#';
			}
		</cfscript>
		<cfreturn application.parametricObjects>
    </cffunction>
    <cffunction name="parametricObjectsSystem" access="remote" returntype="struct">
    	<cfargument name="dataSource" required="yes" default="">
        <cfquery name="parametricObjectsSystem" datasource="#arguments.dataSource#">
            SELECT
            	W.MODULE_NO,
				W.DICTIONARY_ID,
                W.FULL_FUSEACTION,
				S.ITEM_TR
            FROM
            	WRK_OBJECTS W
				LEFT JOIN SETUP_LANGUAGE_TR AS S ON S.DICTIONARY_ID = W.DICTIONARY_ID
            WHERE
            	W.TYPE = 4
                AND W.MODULE_NO = 7
            ORDER BY
				W.MODULE_NO,
                S.ITEM_TR
        </cfquery>
        <cfscript>
			application.parametricObjectsSystem = structNew();
			sayac = 0;
			for(i=0;i<=parametricObjectsSystem.recordcount;i++)
			{
				if(i eq 0 or (i gt 0 and parametricObjectsSystem.MODULE_NO[i] eq parametricObjectsSystem.MODULE_NO[i-1]))
					sayac = sayac + 1;
				else
					sayac = 0;
				application.parametricObjectsSystem[parametricObjectsSystem.MODULE_NO[i]][sayac]['ITEM'] = '#parametricObjectsSystem.ITEM_TR[i]#';
				application.parametricObjectsSystem[parametricObjectsSystem.MODULE_NO[i]][sayac]['FUSEACTION'] = '#parametricObjectsSystem.FULL_FUSEACTION[i]#';
			}
		</cfscript>
		<cfreturn application.parametricObjectsSystem>
    </cffunction>
</cfcomponent>
