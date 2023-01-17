<!-- Description : Arayüzden sayfa bazlı dil düzenlemesi için wo eklendi
Developer: Pınar
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'settings.popup_page_lang_list')
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
        )
    VALUES (
        1
        ,7
        ,N'Dil Bilgisi Güncelle'
        ,43474
        ,NULL
        ,N'settings.popup_page_lang_list'
        ,NULL
        ,N'settings/display/list_page_lang_list.cfm'
        ,NULL
        ,NULL
        ,1
        ,NULL
        ,N'Development'
        ,NULL
        ,0
        ,NULL
        ,N'v 16'
        ,NULL
        ,NULL
        ,0
        ,0
        ,0
        ,N'<p>İlgili sayfadaki tanımlı dillerin toplu bir şekilde gösterimini sağlar.</p>
    '
        ,N'Pınar Yıldız'
        ,NULL
        ,NULL
        ,N'127.0.0.1'
        ,69
        ,CAST(N'2019-04-25 16:05:07.000' AS DATETIME)
        ,N'127.0.0.1'
        ,69
        ,CAST(N'2019-04-25 16:05:31.920' AS DATETIME)
        ,N'HTTP'
        ,2177
        ,NULL
        ,NULL
        ,N'settings'
        ,N'popup_page_lang_list'
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
        ,1
        ,0
        ,0
        ,NULL
        ,NULL
        ,NULL
        ,1
        ,NULL
        )
        END
</querytag>