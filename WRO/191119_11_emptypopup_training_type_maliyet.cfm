<!-- Description : Eğitim Şekline Göre Eğitim Maliyetleri Raporu sayfası excel getirmek için oluşturuldu.
Developer: Emine Yılmaz
Company : Workcube
Destination: main -->
<querytag>
    IF NOT EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'report.emptypopup_training_type_maliyet')
    BEGIN
        
    INSERT [WRK_OBJECTS] (

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

    ,[ADDOPTIONS_CONTROLLER_FILE_PATH]

    ,[THEME_PATH]

    )

    VALUES (

     1

    ,34

    ,N'Eğitim Şekline Göre Eğitim Maliyetleri Raporu(Excel)'

    ,40357

    ,NULL

    ,N'report.emptypopup_training_type_maliyet'

    ,NULL

    ,N'report/standart/training_type_maliyet.cfm'

    ,NULL

    ,NULL

    ,1

    ,NULL

    ,N'Deployment'

    ,NULL

    ,0

    ,NULL

    ,N'v16'

    ,NULL

    ,NULL

    ,0

    ,0

    ,0

    ,N'<p><strong>Amaç:&nbsp;</strong>Eğitim Şekline Göre Eğitim Maliyetleri Raporu sayfası excel getirmek için oluşturuldu.</p><p>19112019 Emine YILMAZ</p>'

    ,N'Workcube Team'

    ,NULL

    ,NULL

    ,N'127.0.0.1'

    ,263

    ,CAST(N'2019-11-19T11:09:55.000' AS DATETIME)

    ,N'127.0.0.1'

    ,263

    ,CAST(N'2019-11-19T12:03:51.430' AS DATETIME)

    ,N'HTTP'

    ,2176

    ,NULL


    ,NULL

    ,N'report'

    ,N'emptypopup_training_type_maliyet'

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

    ,0

    ,NULL

    ,NULL

    ,NULL

    ,0

    ,NULL

    ,NULL

    )
    END
</querytag>