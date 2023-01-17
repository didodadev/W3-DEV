<!-- Description : Bakım altına sipariş rezerv bakım sayfası eklendi
Developer: Pınar Yıldız
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'settings.order_reserve_maintenance')
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
            ,[IS_ONLY_SHOW_PAGE]
            ,[DISPLAY_BEFORE_PATH]
            ,[DISPLAY_AFTER_PATH]
            ,[ACTION_BEFORE_PATH]
            ,[ACTION_AFTER_PATH]
            )
        VALUES (
            1
            ,11
            ,N'Sipariş Rezerve Bakım Kodu'
            ,44662
            ,N'settings.orderreservemaintenance'
            ,N'settings.order_reserve_maintenance'
            ,NULL
            ,N'settings/display/order_reserve_maintenance.cfm'
            ,NULL
            ,NULL
            ,1
            ,NULL
            ,N'Analys'
            ,NULL
            ,0
            ,NULL
            ,N'v16'
            ,NULL
            ,NULL
            ,0
            ,0
            ,0
            ,'Kapatılmış sipariş reservelerinin sistemde yer kaplamaması için silme kodu eklendi.Aynı zamanda history tablosuna yazılması sağlandı. Silinen siparişlerin numaraları işlemden sonra ekrana basıldı.'
            ,NULL
            ,NULL
            ,NULL
            ,N'127.0.0.1'
            ,69
            ,CAST(N'2019-09-05 15:04:52.000' AS DATETIME)
            ,NULL
            ,NULL
            ,NULL
            ,N'HTTP'
            ,2176
            ,NULL
            ,NULL
            ,N'settings'
            ,N'order_reserve_maintenance'
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
            ,5
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