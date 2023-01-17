<cfcomponent extends="cfc.queryJSONConverter">

    <cfset dsn = application.SystemParam.SystemParam().dsn>

    <cffunction name = "returnResponse" returnType = "any" access = "public" returnformat="JSON">
        <cfargument name="queryResult" type="any" required="yes">

        <cfset response = StructNew() />
        <cfif arguments.queryResult.recordcount>
            <cfset response.status = true />
            <cfset response.data = this.returnData(Replace(serializeJSON(arguments.queryResult),"//","")) />
        <cfelse>
            <cfset response.status = false />
        </cfif>
        <cfreturn Replace(serializeJSON(response),"//","") />
    </cffunction>

    <!--- Upgrade işlemi yaparken bir önceki sürümle gelecek olan sürüm tarihleri arasındaki sisteme yeni eklenen dilleri döndürür
            2 parametre alır. start_date ve finish_date --->
    <cffunction name="getNewLangs" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="start_date" default="">
        <cfargument name="finish_date" default="#now()#">
        <cfquery name="getNewLanguages" datasource="#dsn#">
            SELECT
                LANGUAGE_ID,
                LANGUAGE_SET,
                LANGUAGE_SHORT,
                ISNULL(IS_ACTIVE,0) IS_ACTIVE
            FROM
                SETUP_LANGUAGE
            WHERE
                1=1
            <cfif len(arguments.start_date) and len(arguments.finish_date)>
                AND RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
            </cfif>
        </cfquery>
        <cfreturn this.returnResponse( getNewLanguages ) />
    </cffunction>

    <!--- Upgrade işlemi yaparken bir önceki sürümle gelecek olan sürüm tarihleri arasındaki sözlüğe yeni eklenen kelimeleri döndürür
            2 parametre alır. start_date ve finish_date --->
    <cffunction name="getNewLanguages" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="start_date" default="">
        <cfargument name="finish_date" default="#now()#">
        <cfargument name="startrow" default="">
        <cfargument name="maxrows" default="">
        <cfquery name="getNewLanguages" datasource="#dsn#">
            <cfif isDefined('arguments.startrow') and len( arguments.startrow ) and isDefined('arguments.maxrows') and len( arguments.maxrows )>
                WITH CTE1 AS(
            </cfif>
            SELECT
                DICTIONARY_ID,
                ITEM_ID,
                MODULE_ID,
                ITEM,
                ITEM_TR,
                ITEM_ARB,
                ITEM_DE,
                ITEM_ENG,
                ITEM_ES,
                ITEM_RUS,
                ITEM_UKR,
                ITEM_FR,
                ITEM_IT,
                ISNULL(IS_SPECIAL,0) IS_SPECIAL
            FROM
                SETUP_LANGUAGE_TR
            WHERE
                1=1
                AND (IS_SPECIAL IS NULL OR IS_SPECIAL = 0)
            <cfif len(arguments.start_date) and len(arguments.finish_date)>
                AND RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
            </cfif>
            <cfif isDefined('arguments.startrow') and len( arguments.startrow ) and isDefined('arguments.maxrows') and len( arguments.maxrows )>
                ),
                CTE2 AS (
                    SELECT
                        CTE1.*,
                        ROW_NUMBER() OVER (	ORDER BY DICTIONARY_ID ASC ) AS RowNum,
                        (SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                    FROM
                        CTE1
                )
                SELECT CTE2.* FROM CTE2 WHERE RowNum BETWEEN #arguments.startrow# and #arguments.startrow# + ( #arguments.maxrows# - 1 )
            </cfif>
        </cfquery>
        <cfreturn this.returnResponse( getNewLanguages ) />
    </cffunction>

    <!--- Upgrade işlemi yaparken bir önceki sürümle gelecek olan sürüm tarihleri arasındaki sözlükte güncellenen kelimeleri döndürür
            2 parametre alır. start_date ve finish_date --->
    <cffunction name="getUpdatedLanguages" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="start_date" default="">
        <cfargument name="finish_date" default="#now()#">
        <cfquery name="getUpdatedLanguages" datasource="#dsn#">
            SELECT
                DICTIONARY_ID,
                ITEM_ID,
                MODULE_ID,
                ITEM,
                ITEM_TR,
                ITEM_ARB,
                ITEM_DE,
                ITEM_ENG,
                ITEM_ES,
                ITEM_RUS,
                ITEM_UKR,
                ITEM_FR,
                ITEM_IT,
                ISNULL(IS_SPECIAL,0) IS_SPECIAL
            FROM
                SETUP_LANGUAGE_TR
            WHERE
                1=1
                AND (IS_SPECIAL IS NULL OR IS_SPECIAL = 0)
			<cfif len(arguments.start_date) and len(arguments.finish_date)>
                AND UPDATE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND UPDATE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
            </cfif>      
        </cfquery>
        <cfreturn this.returnResponse( getUpdatedLanguages ) />
    </cffunction>

    <!--- Upgrade işlemi yaparken bir önceki sürümle gelecek olan sürüm tarihleri arasındaki yeni eklenen WO'ları döndürür
            3 parametre alır. start_date ve finish_date. is_addon default olarak 1 atanmıştır. --->
    <cffunction name="getNewWO" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="start_date" default="">
        <cfargument name="finish_date" default="#now()#">
        <cfargument name="is_addon" default="1">
        <cfargument name="startrow" default="">
        <cfargument name="maxrows" default="">
        <cfquery name="getNewWO" datasource="#dsn#">
            <cfif isDefined('arguments.startrow') and len( arguments.startrow ) and isDefined('arguments.maxrows') and len( arguments.maxrows )>
                WITH CTE1 AS(
            </cfif>
            SELECT
                WRK_OBJECTS_ID
                ,IS_ACTIVE
                ,MODULE_NO
                ,HEAD
                ,DICTIONARY_ID
                ,FRIENDLY_URL
                ,FULL_FUSEACTION
                ,FULL_FUSEACTION_VARIABLES
                ,FILE_PATH
                ,CONTROLLER_FILE_PATH
                ,STANDART_ADDON
                ,LICENCE
                ,EVENT_TYPE
                ,STATUS
                ,IS_DEFAULT
                ,IS_MENU
                ,WINDOW
                ,VERSION
                ,IS_CATALYST_MOD
                ,MENU_SORT_NO
                ,USE_PROCESS_CAT
                ,USE_SYSTEM_NO
                ,USE_WORKFLOW
                ,AUTHOR
                ,OBJECTS_COUNT
                ,DESTINATION_MODUL
                ,RECORD_DATE
                ,SECURITY
                ,STAGE
                ,MODUL
                ,BASE
                ,MODUL_SHORT_NAME
                ,FUSEACTION
                ,FUSEACTION2
                ,FOLDER
                ,FILE_NAME
                ,IS_ADD
                ,IS_UPDATE
                ,IS_DELETE
                ,LEFT_MENU_NAME
                ,IS_WBO_DENIED
                ,IS_WBO_FORM_LOCK
                ,IS_WBO_LOCK
                ,IS_WBO_LOG
                ,IS_SPECIAL
                ,IS_TEMP
                ,EVENT_ADD
                ,EVENT_DASHBOARD
                ,EVENT_DEFAULT
                ,EVENT_DETAIL
                ,EVENT_LIST
                ,EVENT_UPD
                ,TYPE
                ,POPUP_TYPE
                ,EXTERNAL_FUSEACTION
                ,IS_LEGACY
                ,THEME_PATH
                ,ICON
                ,RANK_NUMBER
                ,ADDOPTIONS_CONTROLLER_FILE_PATH
                ,IS_ONLY_SHOW_PAGE
                ,XML_PATH
                ,DATA_CFC
            FROM
                WRK_OBJECTS
            WHERE
                1=1
                AND (STATUS = 'Deployment' OR STATUS = 'Cancel')
                <cfif len(arguments.is_addon)>
                    AND LICENCE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_addon#">
                </cfif>
                <cfif len(arguments.start_date) and len(arguments.finish_date)>
                    AND RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
                </cfif>
            <cfif isDefined('arguments.startrow') and len( arguments.startrow ) and isDefined('arguments.maxrows') and len( arguments.maxrows )>
                ),
                CTE2 AS (
                    SELECT
                        CTE1.*,
                        ROW_NUMBER() OVER (	ORDER BY WRK_OBJECTS_ID ASC ) AS RowNum,
                        (SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                    FROM
                        CTE1
                )
                SELECT CTE2.* FROM CTE2 WHERE RowNum BETWEEN #arguments.startrow# and #arguments.startrow# + ( #arguments.maxrows# - 1 )
            </cfif>
        </cfquery>
        <cfreturn this.returnResponse( getNewWO ) />
    </cffunction>

    <!--- Upgrade işlemi yaparken bir önceki sürümle gelecek olan sürüm tarihleri arasındaki güncellenen WO'ları döndürür
            3 parametre alır. start_date ve finish_date. is_addon default olarak 1 atanmıştır. --->
    <cffunction name="getUpdatedWO" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="start_date" default="">
        <cfargument name="finish_date" default="#now()#">
        <cfargument name="is_addon" default="1">
        <cfquery name="getUpdatedWO" datasource="#dsn#">
            SELECT
                WRK_OBJECTS_ID
                ,IS_ACTIVE
                ,MODULE_NO
                ,HEAD
                ,DICTIONARY_ID
                ,FRIENDLY_URL
                ,FULL_FUSEACTION
                ,FULL_FUSEACTION_VARIABLES
                ,FILE_PATH
                ,CONTROLLER_FILE_PATH
                ,STANDART_ADDON
                ,LICENCE
                ,EVENT_TYPE
                ,STATUS
                ,IS_DEFAULT
                ,IS_MENU
                ,WINDOW
                ,VERSION
                ,IS_CATALYST_MOD
                ,MENU_SORT_NO
                ,USE_PROCESS_CAT
                ,USE_SYSTEM_NO
                ,USE_WORKFLOW
                ,AUTHOR
                ,OBJECTS_COUNT
                ,DESTINATION_MODUL
                ,UPDATE_DATE
                ,SECURITY
                ,STAGE
                ,MODUL
                ,BASE
                ,MODUL_SHORT_NAME
                ,FUSEACTION
                ,FUSEACTION2
                ,FOLDER
                ,FILE_NAME
                ,IS_ADD
                ,IS_UPDATE
                ,IS_DELETE
                ,LEFT_MENU_NAME
                ,IS_WBO_DENIED
                ,IS_WBO_FORM_LOCK
                ,IS_WBO_LOCK
                ,IS_WBO_LOG
                ,IS_SPECIAL
                ,IS_TEMP
                ,EVENT_ADD
                ,EVENT_DASHBOARD
                ,EVENT_DEFAULT
                ,EVENT_DETAIL
                ,EVENT_LIST
                ,EVENT_UPD
                ,TYPE
                ,POPUP_TYPE
                ,EXTERNAL_FUSEACTION
                ,IS_LEGACY
                ,THEME_PATH
                ,ICON
                ,RANK_NUMBER
                ,ADDOPTIONS_CONTROLLER_FILE_PATH
                ,IS_ONLY_SHOW_PAGE
                ,XML_PATH
                ,DATA_CFC
            FROM
                WRK_OBJECTS
            WHERE
                1=1
                AND STATUS = 'Deployment'
                <cfif len(arguments.is_addon)>
                    AND LICENCE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.is_addon#">
                </cfif>
                <cfif len(arguments.start_date) and len(arguments.finish_date)>
                    AND UPDATE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND UPDATE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
                </cfif>
        </cfquery>
        <cfreturn this.returnResponse( getUpdatedWO ) />
    </cffunction>

    <!--- Upgrade işlemi yaparken bir önceki sürümle gelecek olan sürüm tarihleri arasındaki yeni eklenen Widget'ları döndürür
            2 parametre alır. start_ date ve finish_date --->
    <cffunction name="getNewWidget" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="start_date" default="">
        <cfargument name="finish_date" default="#now()#">
        <cfargument name="startrow" default="">
        <cfargument name="maxrows" default="">
        <cfquery name="getNewWidget" datasource="#dsn#">
            <cfif isDefined('arguments.startrow') and len( arguments.startrow ) and isDefined('arguments.maxrows') and len( arguments.maxrows )>
                WITH CTE1 AS(
            </cfif>
            SELECT
                WIDGETID
                ,WIDGET_FUSEACTION
                ,WIDGET_TITLE
                ,WIDGET_TITLE_DICTIONARY_ID
                ,WIDGET_EVENT_TYPE
                ,WIDGET_VERSION
                ,WIDGET_STRUCTURE
                ,WIDGET_CODE
                ,WIDGET_STATUS
                ,WIDGET_STAGE
                ,WIDGET_TOOL
                ,WIDGET_FILE_PATH
                ,WIDGETSOLUTIONID
                ,WIDGETSOLUTION
                ,WIDGETFAMILYID
                ,WIDGETFAMILY
                ,WIDGETMODULEID
                ,WIDGETMODULENO
                ,WIDGETMODULE
                ,WIDGET_LICENSE
                ,WIDGET_AUTHOR
                ,WIDGET_DEPENDS
                ,RECORD_DATE
                ,WIDGET_DESCRIPTION
                ,IS_PUBLIC
                ,IS_EMPLOYEE
                ,IS_COMPANY
                ,IS_CONSUMER
                ,IS_EMPLOYEE_APP
                ,IS_MACHINES
                ,IS_LIVESTOCK
                ,IS_TEMPLATE_WIDGET
                ,WIDGET_FRIENDLY_NAME
                ,XML_PATH
            FROM
                WRK_WIDGET
            WHERE
                1=1
                AND WIDGET_STATUS = 'Deployment'
            <cfif len(arguments.start_date) and len(arguments.finish_date)>
                AND RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
            </cfif>
            <cfif isDefined('arguments.startrow') and len( arguments.startrow ) and isDefined('arguments.maxrows') and len( arguments.maxrows )>
                ),
                CTE2 AS (
                    SELECT
                        CTE1.*,
                        ROW_NUMBER() OVER (	ORDER BY WIDGETID ASC ) AS RowNum,
                        (SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                    FROM
                        CTE1
                )
                SELECT CTE2.* FROM CTE2 WHERE RowNum BETWEEN #arguments.startrow# and #arguments.startrow# + ( #arguments.maxrows# - 1 )
            </cfif>
        </cfquery>
        <cfreturn this.returnResponse( getNewWidget ) />
    </cffunction>

    <!--- Upgrade işlemi yaparken bir önceki sürümle gelecek olan sürüm tarihleri arasındaki güncellenen Widget'ları döndürür
            2 parametre alır. start_date ve finish_date --->
    <cffunction name="getUpdatedWidget" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="start_date" default="">
        <cfargument name="finish_date" default="#now()#">
        <cfquery name="getUpdatedWidget" datasource="#dsn#">
            SELECT
                WIDGETID
                ,WIDGET_FUSEACTION
                ,WIDGET_TITLE
                ,WIDGET_TITLE_DICTIONARY_ID
                ,WIDGET_EVENT_TYPE
                ,WIDGET_VERSION
                ,WIDGET_STRUCTURE
                ,WIDGET_CODE
                ,WIDGET_STATUS
                ,WIDGET_STAGE
                ,WIDGET_TOOL
                ,WIDGET_FILE_PATH
                ,WIDGETSOLUTIONID
                ,WIDGETSOLUTION
                ,WIDGETFAMILYID
                ,WIDGETFAMILY
                ,WIDGETMODULEID
                ,WIDGETMODULENO
                ,WIDGETMODULE
                ,WIDGET_LICENSE
                ,WIDGET_AUTHOR
                ,WIDGET_DEPENDS
                ,UPDATE_DATE
                ,WIDGET_DESCRIPTION
                ,IS_PUBLIC
                ,IS_EMPLOYEE
                ,IS_COMPANY
                ,IS_CONSUMER
                ,IS_EMPLOYEE_APP
                ,IS_MACHINES
                ,IS_LIVESTOCK
                ,IS_TEMPLATE_WIDGET
                ,WIDGET_FRIENDLY_NAME
                ,XML_PATH
            FROM
                WRK_WIDGET
            WHERE
                1=1
                AND WIDGET_STATUS = 'Deployment'
            <cfif len(arguments.start_date) and len(arguments.finish_date)>
                AND UPDATE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND UPDATE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
            </cfif>
        </cfquery>
        <cfreturn this.returnResponse( getUpdatedWidget ) />
    </cffunction>

    <!--- Upgrade işlemi yaparken bir önceki sürümle gelecek olan sürüm tarihleri arasındaki yeni eklenen Solution'ları döndürür
            2 parametre alır. start_date ve finish_date --->
    <cffunction name="getNewSolution" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="start_date" default="">
        <cfargument name="finish_date" default="#now()#">
        <cfquery name="getNewSolution" datasource="#dsn#">
            SELECT
                WRK_SOLUTION_ID
                ,SOLUTION
                ,SOLUTION_DICTIONARY_ID
                ,SOLUTION_TYPE
                ,IS_MENU
                ,RANK_NUMBER
                ,SOLUTION_LANG_ID
                ,THEME_PATH
                ,UP
                ,ICON
                ,RECORD_DATE
            FROM
                WRK_SOLUTION
            WHERE
                1=1
            <cfif len(arguments.start_date) and len(arguments.finish_date)>
                AND RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
            </cfif>
        </cfquery>
        <cfreturn this.returnResponse( getNewSolution ) />
    </cffunction>

    <!--- Upgrade işlemi yaparken bir önceki sürümle gelecek olan sürüm tarihleri arasındaki güncellenen Solution'ları döndürür
            2 parametre alır. start_date ve finish_date --->
    <cffunction name="getUpdatedSolution" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="start_date" default="">
        <cfargument name="finish_date" default="#now()#">
        <cfquery name="getUpdatedSolution" datasource="#dsn#">
            SELECT
                WRK_SOLUTION_ID
                ,SOLUTION
                ,SOLUTION_DICTIONARY_ID
                ,SOLUTION_TYPE
                ,IS_MENU
                ,RANK_NUMBER
                ,SOLUTION_LANG_ID
                ,THEME_PATH
                ,UP
                ,ICON
                ,UPDATE_DATE
            FROM
                WRK_SOLUTION
            WHERE
                1=1
            <cfif len(arguments.start_date) and len(arguments.finish_date)>
                AND UPDATE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND UPDATE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
            </cfif>
        </cfquery>
        <cfreturn this.returnResponse( getUpdatedSolution ) />
    </cffunction>

    <!--- Upgrade işlemi yaparken bir önceki sürümle gelecek olan sürüm tarihleri arasındaki yeni eklenen Family'leri döndürür
            2 parametre alır. start_date ve finish_date --->
    <cffunction name="getNewFamily" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="start_date" default="">
        <cfargument name="finish_date" default="#now()#">
        <cfquery name="getNewFamily" datasource="#dsn#">
            SELECT
                WRK_FAMILY_ID
                ,FAMILY
                ,FAMILY_DICTIONARY_ID
                ,FAMILY_TYPE
                ,WRK_SOLUTION_ID
                ,IS_MENU
                ,RANK_NUMBER
                ,THEME_PATH
                ,UP
                ,CU
                ,ICON
                ,RECORD_DATE
            FROM
                WRK_FAMILY
            WHERE
                1=1
            <cfif len(arguments.start_date) and len(arguments.finish_date)>
                AND RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
            </cfif>
        </cfquery>
        <cfreturn this.returnResponse( getNewFamily ) />
    </cffunction>

    <!--- Upgrade işlemi yaparken bir önceki sürümle gelecek olan sürüm tarihleri arasındaki güncellenen Family'leri döndürür
            2 parametre alır. start_date ve finish_date --->
    <cffunction name="getUpdatedFamily" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="start_date" default="">
        <cfargument name="finish_date" default="#now()#">
        <cfquery name="getUpdatedFamily" datasource="#dsn#">
            SELECT
                WRK_FAMILY_ID
                ,FAMILY
                ,FAMILY_DICTIONARY_ID
                ,FAMILY_TYPE
                ,WRK_SOLUTION_ID
                ,IS_MENU
                ,RANK_NUMBER
                ,THEME_PATH
                ,UP
                ,CU
                ,ICON
                ,UPDATE_DATE
            FROM
                WRK_FAMILY
            WHERE
                1=1
            <cfif len(arguments.start_date) and len(arguments.finish_date)>
                AND UPDATE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND UPDATE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
            </cfif>
        </cfquery>
        <cfreturn this.returnResponse( getUpdatedFamily ) />
    </cffunction>

    <!--- Upgrade işlemi yaparken bir önceki sürümle gelecek olan sürüm tarihleri arasındaki yeni eklenen Module'leri döndürür
            2 parametre alır. start_date ve finish_date --->
    <cffunction name="getNewModule" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="start_date" default="">
        <cfargument name="finish_date" default="#now()#">
        <cfquery name="getNewModule" datasource="#dsn#">
            SELECT
                MODULE_ID
                ,MODULE_NO
                ,MODULE
                ,MODULE_DICTIONARY_ID
                ,FAMILY_ID
                ,IS_MENU
                ,MODULE_TYPE
                ,RANK_NUMBER
                ,THEME_PATH
                ,UP
                ,ICON
                ,RECORD_DATE
            FROM
                WRK_MODULE
            WHERE
                1=1
            <cfif len(arguments.start_date) and len(arguments.finish_date)>
                AND RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
            </cfif>
        </cfquery>
        <cfreturn this.returnResponse( getNewModule ) />
    </cffunction>

    <!--- Upgrade işlemi yaparken bir önceki sürümle gelecek olan sürüm tarihleri arasındaki güncellenen Module'leri döndürür
            2 parametre alır. start_date ve finish_date --->
    <cffunction name="getUpdatedModule" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="start_date" default="">
        <cfargument name="finish_date" default="#now()#">
        <cfquery name="getUpdatedModule" datasource="#dsn#">
            SELECT
                MODULE_ID
                ,MODULE_NO
                ,MODULE
                ,MODULE_DICTIONARY_ID
                ,FAMILY_ID
                ,IS_MENU
                ,MODULE_TYPE
                ,RANK_NUMBER
                ,THEME_PATH
                ,UP
                ,ICON
                ,UPDATE_DATE
            FROM
                WRK_MODULE
            WHERE
                1=1
            <cfif len(arguments.start_date) and len(arguments.finish_date)>
                AND UPDATE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND UPDATE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
            </cfif>
        </cfquery>
        <cfreturn this.returnResponse( getUpdatedModule ) />
    </cffunction>
    <!--- Upgrade işlemi yaparken bir önceki sürümle gelecek olan sürüm tarihleri arasındaki yeni eklenen modules'leri döndürür
            2 parametre alır. start_date ve finish_date --->
            <cffunction name="getNewModules" access="remote" returntype="any" returnformat="JSON">
                <cfargument name="start_date" default="">
                <cfargument name="finish_date" default="#now()#">
                <cfquery name="getNewModules" datasource="#dsn#">
                    SELECT
                        MODULE_ID
                        ,MODULE_NAME
                        ,MODULE_NAME_TR
                        ,MODULE_SHORT_NAME
                        ,FOLDER
                        ,MODUL_NO
                        ,MODULE_TYPE
                        ,MODULE
                        ,SOLUTION
                        ,FAMILY
                        ,MODULE_DICTIONARY_ID
                        ,SOLUTION_DICTIONARY_ID
                        ,FAMILY_DICTIONARY_ID
                        ,FAMILY_ID
                        ,IS_MENU
                        ,RECORD_DATE
                        ,RECORD_EMP
                        ,RECORD_IP
                        ,UPDATE_DATE
                        ,UPDATE_EMP
                        ,UPDATE_IP
                    FROM
                        MODULES
                    WHERE
                        1=1
                    <cfif len(arguments.start_date) and len(arguments.finish_date)>
                        AND RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
                    </cfif>
                </cfquery>
                <cfreturn this.returnResponse( getNewModules ) />
            </cffunction>

            
    <!--- Upgrade işlemi yaparken bir önceki sürümle gelecek olan sürüm tarihleri arasındaki güncellenen modules'leri döndürür
            2 parametre alır. start_date ve finish_date --->
    <cffunction name="getUpdatedModules" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="start_date" default="">
        <cfargument name="finish_date" default="#now()#">
        <cfquery name="getUpdatedModules" datasource="#dsn#">
            SELECT
                    MODULE_ID
                    ,MODULE_NAME
                    ,MODULE_NAME_TR
                    ,MODULE_SHORT_NAME
                    ,FOLDER
                    ,MODUL_NO
                    ,MODULE_TYPE
                    ,MODULE
                    ,SOLUTION
                    ,FAMILY
                    ,MODULE_DICTIONARY_ID
                    ,SOLUTION_DICTIONARY_ID
                    ,FAMILY_DICTIONARY_ID
                    ,FAMILY_ID
                    ,IS_MENU
                    ,RECORD_DATE
                    ,RECORD_EMP
                    ,RECORD_IP
                    ,UPDATE_DATE
                    ,UPDATE_EMP
                    ,UPDATE_IP
                    FROM
                    MODULES
            WHERE
                1=1
            <cfif len(arguments.start_date) and len(arguments.finish_date)>
                AND UPDATE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND UPDATE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
            </cfif>
        </cfquery>
        <cfreturn this.returnResponse( getUpdatedModules ) />
    </cffunction>

    <!--- Upgrade işlemi yaparken bir önceki sürümle gelecek olan sürüm tarihleri arasındaki yeni eklenen WEX'leri döndürür
            2 parametre alır. start_date ve finish_date --->
    <cffunction name="getNewWEX" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="start_date" default="">
        <cfargument name="finish_date" default="#now()#">
        <cfquery name="getNewWEX" datasource="#dsn#">
            SELECT
                WEX_ID
                ,IS_ACTIVE
                ,MODULE
                ,HEAD
                ,DICTIONARY_ID
                ,VERSION
                ,TYPE
                ,LICENCE
                ,REST_NAME
                ,TIME_PLAN_TYPE
                ,TIME_PLAN
                ,AUTHENTICATION
                ,STATUS
                ,STAGE
                ,AUTHOR
                ,FILE_PATH
                ,RECORD_DATE
                ,RELATED_WO
                ,IMAGE
                ,DETAIL
                ,SOURCE_WO
                ,WEX_FILE_ID
                ,DATA_CONVERTER
                ,IS_DATASERVICE
            FROM
                WRK_WEX
            WHERE
                1=1
                AND STATUS = 'Deployment'
            <cfif len(arguments.start_date) and len(arguments.finish_date)>
                AND RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
            </cfif>
        </cfquery>
        <cfreturn this.returnResponse( getNewWEX ) />
    </cffunction>

    <!--- Upgrade işlemi yaparken bir önceki sürümle gelecek olan sürüm tarihleri arasındaki güncellenen WEX'leri döndürür
            2 parametre alır. start_date ve finish_date --->
    <cffunction name="getUpdatedWEX" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="start_date" default="">
        <cfargument name="finish_date" default="#now()#">
        <cfquery name="getUpdatedWEX" datasource="#dsn#">
            SELECT
                WEX_ID
                ,IS_ACTIVE
                ,MODULE
                ,HEAD
                ,DICTIONARY_ID
                ,VERSION
                ,TYPE
                ,LICENCE
                ,REST_NAME
                ,TIME_PLAN_TYPE
                ,TIME_PLAN
                ,AUTHENTICATION
                ,STATUS
                ,STAGE
                ,AUTHOR
                ,FILE_PATH
                ,UPDATE_DATE
                ,RELATED_WO
                ,IMAGE
                ,DETAIL
                ,SOURCE_WO
                ,WEX_FILE_ID
                ,DATA_CONVERTER
                ,IS_DATASERVICE
            FROM
                WRK_WEX
            WHERE
                1=1
                AND STATUS = 'Deployment'
            <cfif len(arguments.start_date) and len(arguments.finish_date)>
                AND UPDATE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND UPDATE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
            </cfif>
        </cfquery>
        <cfreturn this.returnResponse( getUpdatedWEX ) />
    </cffunction>

    <!--- Upgrade işlemi yaparken bir önceki sürümle gelecek olan sürüm tarihleri arasındaki yeni eklenen Output Template'leri döndürür
            2 parametre alır. start_date ve finish_date --->
    <cffunction name="getNewOutputTemplates" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="start_date" default="">
        <cfargument name="finish_date" default="#now()#">
        <cfquery name="getNewOutputTemplates" datasource="#dsn#">
            SELECT
                WRK_OUTPUT_TEMPLATE_ID
                ,WRK_OUTPUT_TEMPLATE_NAME
                ,WRK_OUTPUT_TEMPLATE_PATENT
                ,IS_ACTIVE
                ,BEST_PRACTISE_CODE
                ,OUTPUT_TEMPLATE_DETAIL
                ,WORKCUBE_PRODUCT_ID
                ,LICENCE_TYPE
                ,RELATED_WO
                ,AUTHOR_PARTNER_ID
                ,AUTHOR_NAME
                ,OUTPUT_TEMPLATE_VIEW_PATH
                ,OUTPUT_TEMPLATE_PATH
                ,OUTPUT_TEMPLATE_SECTORS
                ,WRK_PROCESS_STAGE
                ,PRINT_TYPE
                ,OUTPUT_TEMPLATE_VERSION
                ,RECORD_DATE
                ,USE_LOGO
                ,USE_ADRESS
                ,PAGE_WIDTH
                ,PAGE_HEIGHT
                ,PAGE_MARGIN_LEFT
                ,PAGE_MARGIN_RIGHT
                ,PAGE_MARGIN_TOP
                ,PAGE_MARGIN_BOTTOM
                ,PAGE_HEADER_HEIGHT
                ,PAGE_FOOTER_HEIGHT
                ,RULE_UNIT
            FROM
                WRK_OUTPUT_TEMPLATES
            WHERE
                1=1
            <cfif len(arguments.start_date) and len(arguments.finish_date)>
                AND RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
            </cfif>
        </cfquery>
        <cfreturn this.returnResponse( getNewOutputTemplates ) />
    </cffunction>

    <!--- Upgrade işlemi yaparken bir önceki sürümle gelecek olan sürüm tarihleri arasındaki güncellenen Output Template'leri döndürür
            2 parametre alır. start_date ve finish_date --->
    <cffunction name="getUpdatedOutputTemplates" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="start_date" default="">
        <cfargument name="finish_date" default="#now()#">
        <cfquery name="getUpdatedOutputTemplates" datasource="#dsn#">
            SELECT
                WRK_OUTPUT_TEMPLATE_ID
                ,WRK_OUTPUT_TEMPLATE_NAME
                ,WRK_OUTPUT_TEMPLATE_PATENT
                ,IS_ACTIVE
                ,BEST_PRACTISE_CODE
                ,OUTPUT_TEMPLATE_DETAIL
                ,WORKCUBE_PRODUCT_ID
                ,LICENCE_TYPE
                ,RELATED_WO
                ,AUTHOR_PARTNER_ID
                ,AUTHOR_NAME
                ,OUTPUT_TEMPLATE_VIEW_PATH
                ,OUTPUT_TEMPLATE_PATH
                ,OUTPUT_TEMPLATE_SECTORS
                ,WRK_PROCESS_STAGE
                ,PRINT_TYPE
                ,OUTPUT_TEMPLATE_VERSION
                ,UPDATE_DATE
                ,USE_LOGO
                ,USE_ADRESS
                ,PAGE_WIDTH
                ,PAGE_HEIGHT
                ,PAGE_MARGIN_LEFT
                ,PAGE_MARGIN_RIGHT
                ,PAGE_MARGIN_TOP
                ,PAGE_MARGIN_BOTTOM
                ,PAGE_HEADER_HEIGHT
                ,PAGE_FOOTER_HEIGHT
                ,RULE_UNIT
            FROM
                WRK_OUTPUT_TEMPLATES
            WHERE
                1=1
            <cfif len(arguments.start_date) and len(arguments.finish_date)>
                AND UPDATE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND UPDATE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
            </cfif>
        </cfquery>
        <cfreturn this.returnResponse( getUpdatedOutputTemplates ) />
    </cffunction>

    <!--- Upgrade işlemi yaparken bir önceki sürümle gelecek olan sürüm tarihleri arasındaki yeni eklenen Process Template'leri döndürür
            2 parametre alır. start_date ve finish_date --->
    <cffunction name="getNewProcessTemplates" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="start_date" default="">
        <cfargument name="finish_date" default="#now()#">
        <cfquery name="getNewProcessTemplates" datasource="#dsn#">
            SELECT
                WRK_PROCESS_TEMPLATE_ID
                ,WRK_PROCESS_TEMPLATE_NAME
                ,IS_ACTIVE
                ,IS_ACTION
                ,IS_DISPLAY
                ,IS_STAGE
                ,IS_MAIN
                ,BEST_PRACTISE_CODE
                ,PROCESS_TEMPLATE_DETAIL
                ,WORKCUBE_PRODUCT_ID
                ,LICENCE_TYPE
                ,RELATED_WO
                ,AUTHOR_PARTNER_ID
                ,AUTHOR_NAME
                ,PROCESS_TEMPLATE_ICON_PATH
                ,PROCESS_TEMPLATE_PATH
                ,PROCESS_TEMPLATE_SECTORS
                ,WRK_PROCESS_STAGE
                ,MODULE_ID
                ,PROCESS_TEMPLATE_VERSION
                ,RECORD_DATE
            FROM
                WRK_PROCESS_TEMPLATES
            WHERE
                1=1
            <cfif len(arguments.start_date) and len(arguments.finish_date)>
                AND RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
            </cfif>
        </cfquery>
        <cfreturn this.returnResponse( getNewProcessTemplates ) />
    </cffunction>

    <!--- Upgrade işlemi yaparken bir önceki sürümle gelecek olan sürüm tarihleri arasındaki güncellenen Process Template'leri döndürür
            2 parametre alır. start_date ve finish_date --->
    <cffunction name="getUpdatedProcessTemplates" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="start_date" default="">
        <cfargument name="finish_date" default="#now()#">
        <cfquery name="getUpdatedProcessTemplates" datasource="#dsn#">
            SELECT
                WRK_PROCESS_TEMPLATE_ID
                ,WRK_PROCESS_TEMPLATE_NAME
                ,IS_ACTIVE
                ,IS_ACTION
                ,IS_DISPLAY
                ,IS_STAGE
                ,IS_MAIN
                ,BEST_PRACTISE_CODE
                ,PROCESS_TEMPLATE_DETAIL
                ,WORKCUBE_PRODUCT_ID
                ,LICENCE_TYPE
                ,RELATED_WO
                ,AUTHOR_PARTNER_ID
                ,AUTHOR_NAME
                ,PROCESS_TEMPLATE_ICON_PATH
                ,PROCESS_TEMPLATE_PATH
                ,PROCESS_TEMPLATE_SECTORS
                ,WRK_PROCESS_STAGE
                ,MODULE_ID
                ,PROCESS_TEMPLATE_VERSION
                ,UPDATE_DATE
            FROM
                WRK_PROCESS_TEMPLATES
            WHERE
                1=1
            <cfif len(arguments.start_date) and len(arguments.finish_date)>
                AND UPDATE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#"> AND UPDATE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
            </cfif>
        </cfquery>
        <cfreturn this.returnResponse( getUpdatedProcessTemplates ) />
    </cffunction>
</cfcomponent>