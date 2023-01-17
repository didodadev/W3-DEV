<!-- Description :	İş Aileleri - Sistem Kullanımı sayfası için yeni WO oluşturuldu.
Developer: Canan Ebret
Company : Workcube
Destination: Main -->
<querytag>

    IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='WRK_OBJECTS' AND INFORMATION_SCHEMA.TABLES.TABLE_SCHEMA <> 'dbo' )
    BEGIN
        IF EXISTS(SELECT * from WRK_OBJECTS where FULL_FUSEACTION ='report.holistic')
        BEGIN
        DELETE FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'report.holistic';
        END
    END
    BEGIN
        IF NOT EXISTS(SELECT * from WRK_OBJECTS where FULL_FUSEACTION ='report.business_family_using')
            INSERT INTO [WRK_OBJECTS] (
                [IS_ACTIVE]
                ,[MODULE_NO]
                ,[HEAD]
                ,[DICTIONARY_ID]
                ,[FRIENDLY_URL]
                ,[FULL_FUSEACTION]
                ,[FULL_FUSEACTION_VARIABLES]
                ,[FILE_PATH]
                ,[CONTROLLER_FILE_PATH]
                ,[STANDART_ADDON]
                ,[LICENCE]
                ,[EVENT_TYPE]
                ,[STATUS]
                ,[IS_DEFAULT]
                ,[IS_MENU]
                ,[WINDOW]
                ,[VERSION]
                ,[IS_CATALYST_MOD]
                ,[MENU_SORT_NO]
                ,[USE_PROCESS_CAT]
                ,[USE_SYSTEM_NO]
                ,[USE_WORKFLOW]
                ,[DETAIL]
                ,[AUTHOR]
                ,[OBJECTS_COUNT]
                ,[DESTINATION_MODUL]
                ,[RECORD_IP]
                ,[RECORD_EMP]
                ,[RECORD_DATE]
                ,[UPDATE_IP]
                ,[UPDATE_EMP]
                ,[UPDATE_DATE]
                ,[SECURITY]
                ,[STAGE]
                ,[MODUL]
                ,[BASE]
                ,[MODUL_SHORT_NAME]
                ,[FUSEACTION]
                ,[FUSEACTION2]
                ,[FOLDER]
                ,[FILE_NAME]
                ,[IS_ADD]
                ,[IS_UPDATE]
                ,[IS_DELETE]
                ,[LEFT_MENU_NAME]
                ,[IS_WBO_DENIED]
                ,[IS_WBO_FORM_LOCK]
                ,[IS_WBO_LOCK]
                ,[IS_WBO_LOG]
                ,[IS_SPECIAL]
                ,[IS_TEMP]
                ,[EVENT_ADD]
                ,[EVENT_DASHBOARD]
                ,[EVENT_DEFAULT]
                ,[EVENT_DETAIL]
                ,[EVENT_LIST]
                ,[EVENT_UPD]
                ,[TYPE]
                ,[POPUP_TYPE]
                ,[RANK_NUMBER]
                ,[EXTERNAL_FUSEACTION]
                ,[IS_LEGACY]
                )
            VALUES (
                1
                ,47
                ,N'İş Aileleri - Sistem Kullanımı'
                ,36182
                ,N'BusinessFamilyUsingReport'
                ,N'report.business_family_using'
                ,NULL
                ,N'report/standart/business_family_using.cfm'
                ,NULL
                ,NULL
                ,1
                ,NULL
                ,N'Deployment'
                ,NULL
                ,0
                ,NULL
                ,N'v19'
                ,NULL
                ,NULL
                ,0
                ,0
                ,0
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,N'85.105.211.34'
                ,84
                ,CAST(N'2019-06-10 08:22:03.000' AS DATETIME)
                ,N'127.0.0.1'
                ,113
                ,CAST(N'2019-07-17 11:46:25.073' AS DATETIME)
                ,N'HTTP'
                ,2176
                ,NULL
                ,NULL
                ,N'report'
                ,N'business_family_using'
                ,NULL
                ,N'W3WorkDev'
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,NULL
                ,0
                ,0
                ,NULL
                ,0
                ,0
                ,0
                ,8
                ,NULL
                ,NULL
                ,NULL
                ,1
                )
            End
    </querytag>