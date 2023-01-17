<!-- Description : Esnek Çalışma Saatleri WO'ları
Developer: Esma R. Uysal
Company : Workcube
Destination: main -->
<querytag>
IF NOT EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'hr.flexible_worktime')
BEGIN
    INSERT [WRK_OBJECTS]
    (
        [IS_ACTIVE], 
        [MODULE_NO], 
        [HEAD], 
        [DICTIONARY_ID], 
        [FRIENDLY_URL], 
        [FULL_FUSEACTION], 
        [FULL_FUSEACTION_VARIABLES], 
        [FILE_PATH], 
        [CONTROLLER_FILE_PATH], 
        [STANDART_ADDON], 
        [LICENCE], 
        [EVENT_TYPE], 
        [STATUS], 
        [IS_DEFAULT], 
        [IS_MENU], 
        [WINDOW], 
        [VERSION], 
        [IS_CATALYST_MOD], 
        [MENU_SORT_NO], 
        [USE_PROCESS_CAT], 
        [USE_SYSTEM_NO], 
        [USE_WORKFLOW], 
        [DETAIL], 
        [AUTHOR], 
        [OBJECTS_COUNT], 
        [DESTINATION_MODUL], 
        [RECORD_IP], 
        [RECORD_EMP], 
        [RECORD_DATE], 
        [UPDATE_IP], 
        [UPDATE_EMP], 
        [UPDATE_DATE], 
        [SECURITY], 
        [STAGE], 
        [MODUL], 
        [BASE], 
        [MODUL_SHORT_NAME], 
        [FUSEACTION], 
        [FUSEACTION2], 
        [FOLDER], 
        [FILE_NAME], 
        [IS_ADD], 
        [IS_UPDATE], 
        [IS_DELETE], 
        [LEFT_MENU_NAME], 
        [IS_WBO_DENIED], 
        [IS_WBO_FORM_LOCK], 
        [IS_WBO_LOCK], 
        [IS_WBO_LOG], 
        [IS_SPECIAL], 
        [IS_TEMP], 
        [EVENT_ADD], 
        [EVENT_DASHBOARD], 
        [EVENT_DEFAULT], 
        [EVENT_DETAIL], 
        [EVENT_LIST], 
        [EVENT_UPD], 
        [TYPE], 
        [POPUP_TYPE], 
        [RANK_NUMBER], 
        [EXTERNAL_FUSEACTION], 
        [IS_LEGACY]) 
VALUES (
        1, 
        69, 
        N'Esnek Çalışma Başvurusu', 
        38598, 
        N'hrFlexibeWorkTimeApp', 
        N'hr.flexible_worktime', 
        NULL, 
        N'hr/display/list_flexible_worktime.cfm', 
        N'WBO/controller/hrFlexibleWorkTimeController.cfm', 
        NULL, 
        1, 
        NULL, 
        N'Analys', 
        NULL, 
        0, 
        NULL, 
        N'Alfa', 
        NULL, 
        NULL, 
        0, 
        0, 
        0, 
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        N'127.0.0.1', 
        4, 
        Cast(N'2019-12-04 18:56:47.000' AS DATETIME), 
        N'127.0.0.1', 
        4, 
        Cast(N'2019-12-05 15:20:15.243' AS DATETIME), 
        N'HTTP', 
        2176, 
        NULL, 
        NULL, 
        N'hr', 
        N'flexible_worktime', 
        NULL, 
        N'W3WorkDev', 
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        1, 
        0, 
        NULL, 
        0, 
        1, 
        1, 
        0, 
        NULL, 
        NULL, 
        NULL, 
        0) 
END;
IF NOT EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'myhome.flexible_worktime')
BEGIN
        INSERT [WRK_OBJECTS] 
       (
        [IS_ACTIVE], 
        [MODULE_NO], 
        [HEAD], 
        [DICTIONARY_ID], 
        [FRIENDLY_URL], 
        [FULL_FUSEACTION], 
        [FULL_FUSEACTION_VARIABLES], 
        [FILE_PATH], 
        [CONTROLLER_FILE_PATH], 
        [STANDART_ADDON], 
        [LICENCE], 
        [EVENT_TYPE], 
        [STATUS], 
        [IS_DEFAULT], 
        [IS_MENU], 
        [WINDOW], 
        [VERSION], 
        [IS_CATALYST_MOD], 
        [MENU_SORT_NO], 
        [USE_PROCESS_CAT], 
        [USE_SYSTEM_NO], 
        [USE_WORKFLOW], 
        [DETAIL], 
        [AUTHOR], 
        [OBJECTS_COUNT], 
        [DESTINATION_MODUL], 
        [RECORD_IP], 
        [RECORD_EMP], 
        [RECORD_DATE], 
        [UPDATE_IP], 
        [UPDATE_EMP], 
        [UPDATE_DATE], 
        [SECURITY], 
        [STAGE], 
        [MODUL], 
        [BASE], 
        [MODUL_SHORT_NAME], 
        [FUSEACTION], 
        [FUSEACTION2], 
        [FOLDER], 
        [FILE_NAME], 
        [IS_ADD], 
        [IS_UPDATE], 
        [IS_DELETE], 
        [LEFT_MENU_NAME], 
        [IS_WBO_DENIED], 
        [IS_WBO_FORM_LOCK], 
        [IS_WBO_LOCK], 
        [IS_WBO_LOG], 
        [IS_SPECIAL], 
        [IS_TEMP], 
        [EVENT_ADD], 
        [EVENT_DASHBOARD], 
        [EVENT_DEFAULT], 
        [EVENT_DETAIL], 
        [EVENT_LIST], 
        [EVENT_UPD], 
        [TYPE], 
        [POPUP_TYPE], 
        [RANK_NUMBER], 
        [EXTERNAL_FUSEACTION], 
        [IS_LEGACY]) 
VALUES (
        1, 
        69, 
        N'Esnek Çalışma Başvurusu', 
        38598, 
        N'FlexibeWorkTimeApp', 
        N'myhome.flexible_worktime', 
        NULL, 
        N'myhome/form/add_flexible_worktime.cfm', 
        N'WBO/controller/FlexibleWorkTimeController.cfm', 
        NULL, 
        1, 
        NULL, 
        N'Design', 
        NULL, 
        1, 
        NULL, 
        N'Alfa', 
        NULL, 
        NULL, 
        0, 
        0, 
        1, 
        N'<p>Esnek çalışma başvuruları yapmak için kullanılır.</p> ', 
        N'NoCode', 
        NULL, 
        NULL, 
        N'192.168.71.8', 
        57, 
        Cast(N'2019-12-01 11:19:16.000' AS DATETIME), 
        N'127.0.0.1', 
        4, 
        Cast(N'2019-12-03 14:27:34.103' AS DATETIME), 
        N'HTTP', 
        2176, 
        NULL, 
        NULL, 
        N'myhome', 
        N'flexible_worktime', 
        NULL, 
        N'W3WorkDev', 
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        NULL, 
        1, 
        0, 
        NULL, 
        0, 
        1, 
        1, 
        0, 
        NULL, 
        NULL, 
        NULL, 
        0) 
END;
</querytag>