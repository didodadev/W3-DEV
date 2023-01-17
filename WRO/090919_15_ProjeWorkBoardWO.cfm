<!-- Description :  Proje WorkBoard sayfası için WO ve yeni diller eklendi.
Developer: Melek Kocabey
Company : Workcube
Destination: main -->
<querytag>
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Proje WorkBoard', ITEM_TR='Proje WorkBoard', ITEM_ENG='Proje WorkBoard' WHERE DICTIONARY_ID = 50967
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Termini Geçmiş İşler', ITEM_TR='Termini Geçmiş İşler', ITEM_ENG='Deadline Pass Tasks' WHERE DICTIONARY_ID = 45888
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Termini Verilmemiş İşler', ITEM_TR='Termini Verilmemiş İşler', ITEM_ENG='Undertermined Tasks' WHERE DICTIONARY_ID = 46089
    IF NOT EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'report.project_work_board')
    BEGIN
        INSERT [WRK_OBJECTS] 
        (
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
        VALUES 
        (
             1
            ,1
            ,N'Proje WorkBoard'
            ,50967
            ,N'ProjeWorkBoard'
            ,N'report.project_work_board'
            ,NULL
            ,N'report/standart/ProjectWorkBoard.cfm'
            ,NULL
            ,NULL
            ,1
            ,NULL
            ,N'Development'
            ,NULL
            ,0
            ,NULL
            ,N'V16'
            ,NULL
            ,NULL
            ,0
            ,0
            ,0
            ,N'<p><strong>Amaç:&nbsp;&nbsp;</strong>İşlerle ilgili detayların raporlanması.</p>'
            ,N'Workcube Team'
            ,NULL
            ,NULL
            ,N'192.168.69.61'
            ,87
            ,CAST(0x0000AAC300D3F2FC AS DATETIME)
            ,N'192.168.69.65'
            ,4
            ,CAST(0x0000AAD4008DBC4F AS DATETIME)
            ,N'HTTP'
            ,2176
            ,NULL
            ,NULL
            ,N'report'
            ,N'project_work_board'
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
            ,0
            ,NULL
            ,NULL
        )
    END
</querytag>
