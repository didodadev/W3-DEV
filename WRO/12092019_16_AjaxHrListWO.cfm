
<!-- Description : Kim kimdir sayfasında sayfalama işlemlerinde cf_loader custom tagini kullanabilmek için oluşturulmuştur. Ve wo başlığı için yeni dil eklendi.
Developer: Canan Ebret
Company : Workcube
Destination: Main -->
<querytag>
UPDATE SETUP_LANGUAGE_TR SET ITEM='Hr Ajax Sayfası', ITEM_TR='Hr Ajax Sayfası', ITEM_ENG='Hr Ajax Page' WHERE DICTIONARY_ID = 51009
IF NOT EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION ='rule.ajax_hr_list')
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
        ,[DISPLAY_BEFORE_PATH]
        ,[DISPLAY_AFTER_PATH]
        ,[ACTION_BEFORE_PATH]
        ,[ACTION_AFTER_PATH]
        ,[ICON]
        )
    VALUES (
         1
        ,43
        ,N'Hr Ajax Sayfası'
        ,51009
        ,N'AjaxHrList'
        ,N'rule.ajax_hr_list'
        ,NULL
        ,N'rules/display/ajax_hr_list.cfm'
        ,NULL
        ,NULL
        ,1
        ,NULL
        ,N'Deployment'
        ,NULL
        ,0
        ,NULL
        ,N'v 16'
        ,NULL
        ,NULL
        ,0
        ,0
        ,0
        ,N'<p>Kim kimdir Sayfası için hazırlanmıştır.</p>'
        ,N'Workcube Team'
        ,NULL
        ,NULL
        ,N'127.0.0.1'
        ,113
        ,CAST(N'2019-09-12T15:58:10.000' AS DATETIME)
        ,N'127.0.0.1'
        ,113
        ,CAST(N'2019-09-12T19:14:46.087' AS DATETIME)
        ,N'HTTP'
        ,2176
        ,NULL
        ,NULL
        ,N'hr'
        ,N'ajax_hr_list'
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
        ,10
        ,NULL
        ,NULL
        ,NULL
        ,0
        ,NULL
        ,NULL
        ,NULL
        ,NULL
        ,NULL
        ,NULL
        ,NULL
        )
END
</querytag> 

