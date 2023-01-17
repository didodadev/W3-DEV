<!---
İmplementasyon Adımlarıyla İlgili Olan Tüm Fonksiyonlar Bu cfc İçerisinde Toplanacaktır.
Oluşturma Tarihi : 02092019
Oluşturan : İlker Altındal
Mail : ilkeraltindal@workcube.com
--->
<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>

    <cffunction name="getSteps" access="public" returntype="any">
        <cfquery name="getSteps" datasource="#dsn#">
   
            SELECT STEP.*
                --,LANG.ITEM_#UCase(session.ep.language)# AS ITEM
                ,ISNULL(LANG_MDL.ITEM_#UCase(session.ep.language)#,MDL.MODULE) AS MODULE
                ,ISNULL(LANG_FMLY.ITEM_#UCase(session.ep.language)#,FMLY.FAMILY) AS FAMILY
                ,ISNULL(LANG_SLTN.ITEM_#UCase(session.ep.language)#,SLTN.SOLUTION) AS SOLUTION
                ,SLTN.RANK_NUMBER AS SLTN_RANK
                ,SLTN.WRK_SOLUTION_ID
                ,STEP.RANK_NUMBER AS STEP_RANK
                ,FMLY.RANK_NUMBER AS FMLY_RANK
                ,MDL.RANK_NUMBER AS MDL_RANK
            FROM WRK_IMPLEMENTATION_STEP AS STEP
            --LEFT JOIN SETUP_LANGUAGE_TR AS LANG ON LANG.DICTIONARY_ID = STEP.WRK_IMPLEMENTATION_TASK
            LEFT JOIN WRK_MODULE AS MDL ON STEP.WRK_MODUL_ID = MDL.MODULE_ID
            LEFT JOIN SETUP_LANGUAGE_TR AS LANG_MDL ON LANG_MDL.DICTIONARY_ID = MDL.MODULE_DICTIONARY_ID
            LEFT JOIN WRK_FAMILY AS FMLY ON MDL.FAMILY_ID = FMLY.WRK_FAMILY_ID
            LEFT JOIN SETUP_LANGUAGE_TR AS LANG_FMLY ON LANG_FMLY.DICTIONARY_ID = FMLY.FAMILY_DICTIONARY_ID
            LEFT JOIN WRK_SOLUTION AS SLTN ON FMLY.WRK_SOLUTION_ID = SLTN.WRK_SOLUTION_ID
            LEFT JOIN SETUP_LANGUAGE_TR AS LANG_SLTN ON LANG_SLTN.DICTIONARY_ID = SLTN.SOLUTION_DICTIONARY_ID
            WHERE MDL.IS_MENU = 1
            ORDER BY 
                SLTN_RANK, 
                FMLY_RANK, 
                MDL_RANK, 
                STEP_RANK
        </cfquery>
        <cfreturn getSteps>
    </cffunction>

    <cffunction name="getFamilies" returntype="any">
        <cfquery name="getFamilies" datasource="#dsn#">
            SELECT WRK_FAMILY_ID, ISNULL(S.ITEM_#UCase(session.ep.language)#,W.FAMILY) AS LANG 
                FROM WRK_FAMILY AS W
                LEFT JOIN SETUP_LANGUAGE_TR AS S ON S.DICTIONARY_ID = W.FAMILY_DICTIONARY_ID
            WHERE WRK_SOLUTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.solution_id#">
            ORDER BY
                ISNULL(RANK_NUMBER,100)
        </cfquery>
        <cfreturn getFamilies>
    </cffunction>

    <cffunction name="getModule" returntype="any">
        <cfquery name="getModule" datasource="#dsn#">
            SELECT
                W.MODULE_ID,
                W.WIKI,
                W.VIDEO,
                ISNULL(S.ITEM_#UCase(session.ep.language)#,W.MODULE) AS LANG
            FROM
                WRK_MODULE AS W
                LEFT JOIN SETUP_LANGUAGE_TR AS S ON W.MODULE_DICTIONARY_ID = S.DICTIONARY_ID
            WHERE
                W.FAMILY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.family_id#">
                AND W.IS_MENU = 1
            ORDER BY
                ISNULL(W.RANK_NUMBER,100),
                S.ITEM_#UCase(session.ep.language)#
        </cfquery>
        <cfreturn getModule>	
    </cffunction>

    <cffunction name="getTask" returntype="any">
        <cfquery name="getTask" datasource="#dsn#">
            SELECT
                WIS.WRK_IMPLEMENTATION_STEP_ID,
                WIS.WRK_MODUL_ID,
                WIS.WRK_IMPLEMENTATION_TYPE,
                WIS.WRK_OBJECTS,
                WIS.WRK_RELATED_OBJECTS,
                WIS.WRK_RELATED_TABLE_NAME,
                WIS.WRK_RELATED_TABLE_COLUMN,
                WIS.WRK_RELATED_SCHEMA_NAME,
                WIS.WRK_IMPLEMENTATION_TASK_COMPLETE,
                WIS.WRK_IMPLEMENTATION_TASK,
                WIS.RANK_NUMBER,
                WIS.WRK_CONDITION,
                WO.WRK_OBJECTS_ID,
                (SELECT COUNT(WIS2.WRK_IMPLEMENTATION_TASK_COMPLETE) AS TSK_COMP FROM WRK_IMPLEMENTATION_STEP AS WIS2 WHERE WIS2.WRK_IMPLEMENTATION_TASK_COMPLETE = 1 and WIS2.WRK_MODUL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.module_id#"> ) AS TASK_END_COUNT
                --,S.ITEM_#UCase(session.ep.language)# AS ITEM
            FROM
                WRK_IMPLEMENTATION_STEP AS WIS
                --LEFT JOIN SETUP_LANGUAGE_TR AS S ON S.DICTIONARY_ID = WIS.WRK_IMPLEMENTATION_TASK
                LEFT JOIN WRK_MODULE AS WM ON WIS.WRK_MODUL_ID = WM.MODULE_NO
                INNER JOIN WRK_OBJECTS AS WO ON WO.FULL_FUSEACTION = WIS.WRK_OBJECTS
            WHERE
                WM.MODULE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.module_id#">
                AND WM.IS_MENU = 1
            ORDER BY
                ISNULL(WIS.RANK_NUMBER,100)
                --,S.ITEM_#UCase(session.ep.language)#
        </cfquery>
        <cfreturn getTask>
    </cffunction>

    <cffunction name="getTaskDashboard" returntype="any">
        <cfquery name="getTask" datasource="#dsn#">
            SELECT
                WIS.WRK_IMPLEMENTATION_STEP_ID,
                WIS.WRK_MODUL_ID,
                WIS.WRK_IMPLEMENTATION_TYPE,
                WIS.WRK_OBJECTS,
                WIS.WRK_RELATED_OBJECTS,
                WIS.WRK_RELATED_TABLE_NAME,
                WIS.WRK_RELATED_TABLE_COLUMN,
                WIS.WRK_RELATED_SCHEMA_NAME,
                WIS.WRK_IMPLEMENTATION_TASK_COMPLETE,
                WIS.WRK_IMPLEMENTATION_TASK,
                WIS.RANK_NUMBER,
                WIS.WRK_CONDITION,
                WO.WRK_OBJECTS_ID,
                (SELECT COUNT(WIS2.WRK_IMPLEMENTATION_TASK_COMPLETE) AS TSK_COMP FROM WRK_IMPLEMENTATION_STEP AS WIS2 WHERE WIS2.WRK_IMPLEMENTATION_TASK_COMPLETE = 1 and WIS2.WRK_MODUL_ID IN( <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.module_id#" list="yes"> ) ) AS TASK_END_COUNT
            FROM
                WRK_IMPLEMENTATION_STEP AS WIS
                LEFT JOIN WRK_MODULE AS WM ON WIS.WRK_MODUL_ID = WM.MODULE_NO
                INNER JOIN WRK_OBJECTS AS WO ON WO.FULL_FUSEACTION = WIS.WRK_OBJECTS
            WHERE
                WM.MODULE_ID IN( <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.module_id#" list="yes" > )
                AND WM.IS_MENU = 1
            ORDER BY
                ISNULL(WIS.RANK_NUMBER,100)
        </cfquery>
        <cfreturn getTask>
    </cffunction>

    <cffunction name="getTaskCount" returntype="any">
        <cfquery name="getTaskCount" datasource="#dsn#">
            SELECT
                COUNT(WRK_IMPLEMENTATION_STEP_ID) AS TOTAL_TASK,
                (SELECT COUNT(WIS.WRK_IMPLEMENTATION_TASK_COMPLETE) AS BBB FROM WRK_IMPLEMENTATION_STEP AS WIS WHERE WIS.WRK_IMPLEMENTATION_TASK_COMPLETE = 1 ) AS COMPLETED_TASK
            FROM WRK_IMPLEMENTATION_STEP
        </cfquery>
        <cfreturn getTaskCount>
    </cffunction>

    <cffunction name="getModuleTaskCount" returntype="any">
        <cfquery name="getModuleTaskCount" datasource="#dsn#">
            SELECT 
                COUNT(*) AS COMPLETED_MODULE_COUNT	
            FROM (
                    SELECT 
                        WIS.WRK_MODUL_ID,
                        COUNT(WIS.WRK_IMPLEMENTATION_TASK_COMPLETE) AS TOPLAM_TASK,
                        (
                            SELECT
                                COUNT(WRK_IMPLEMENTATION_TASK_COMPLETE) AS COMP
                            FROM 
                                WRK_IMPLEMENTATION_STEP AS WIS2
                            WHERE WIS2.WRK_MODUL_ID = WIS.WRK_MODUL_ID AND WRK_IMPLEMENTATION_TASK_COMPLETE = 1
                        ) AS TAMAMLANAN_TASK
                    FROM 
                        WRK_IMPLEMENTATION_STEP AS WIS
                    GROUP BY WIS.WRK_MODUL_ID
                    ) AS SUB_
            WHERE TOPLAM_TASK - TAMAMLANAN_TASK = 0 
        </cfquery>
        <cfreturn getModuleTaskCount>
    </cffunction>
</cfcomponent>
