<!-- Description : Standart Rapor printleri için yeni WOlar eklendi.
Developer: Canan Ebret
Company : Workcube
Destination: main -->
<querytag>
IF NOT EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'report.emptypopup_security_report') BEGIN
    INSERT [WRK_OBJECTS] ( [IS_ACTIVE], [MODULE_NO], [HEAD], [DICTIONARY_ID], [FRIENDLY_URL], [FULL_FUSEACTION], [FULL_FUSEACTION_VARIABLES], [FILE_PATH], [CONTROLLER_FILE_PATH], [STANDART_ADDON], [LICENCE], [EVENT_TYPE], [STATUS], [IS_DEFAULT], [IS_MENU], [WINDOW], [VERSION], [IS_CATALYST_MOD], [MENU_SORT_NO], [USE_PROCESS_CAT], [USE_SYSTEM_NO], [USE_WORKFLOW], [DETAIL], [AUTHOR], [OBJECTS_COUNT], [DESTINATION_MODUL], [RECORD_IP], [RECORD_EMP], [RECORD_DATE], [UPDATE_IP], [UPDATE_EMP], [UPDATE_DATE], [SECURITY], [STAGE], [MODUL], [BASE], [MODUL_SHORT_NAME], [FUSEACTION], [FUSEACTION2], [FOLDER], [FILE_NAME], [IS_ADD], [IS_UPDATE], [IS_DELETE], [LEFT_MENU_NAME], [IS_WBO_DENIED], [IS_WBO_FORM_LOCK], [IS_WBO_LOCK], [IS_WBO_LOG], [IS_SPECIAL], [IS_TEMP], [EVENT_ADD], [EVENT_DASHBOARD], [EVENT_DEFAULT], [EVENT_DETAIL], [EVENT_LIST], [EVENT_UPD], [TYPE], [POPUP_TYPE], [RANK_NUMBER], [EXTERNAL_FUSEACTION], [IS_LEGACY]) VALUES (1, 83, N'Yetki Raporu(Excel)', 58044, NULL, N'report.emptypopup_security_report', NULL, N'report/standart/security_system_report.cfm', NULL, NULL, 1, NULL, N'Deployment', NULL, 0, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, N'127.0.0.1', 113, CAST(N'2019-04-08 15:58:11.000' AS DateTime), N'127.0.0.1', 113, CAST(N'2019-04-08 16:18:57.390' AS DateTime), N'HTTP', NULL, NULL, NULL, N'W3WorkDev', N'emptypopup_security_report', NULL, N'W3WorkDev', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, 0, 0, 0, NULL, NULL, NULL, 0)
END
IF NOT EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'report.emptypopup_security_report_process_cat') BEGIN
    INSERT [WRK_OBJECTS] ( [IS_ACTIVE], [MODULE_NO], [HEAD], [DICTIONARY_ID], [FRIENDLY_URL], [FULL_FUSEACTION], [FULL_FUSEACTION_VARIABLES], [FILE_PATH], [CONTROLLER_FILE_PATH], [STANDART_ADDON], [LICENCE], [EVENT_TYPE], [STATUS], [IS_DEFAULT], [IS_MENU], [WINDOW], [VERSION], [IS_CATALYST_MOD], [MENU_SORT_NO], [USE_PROCESS_CAT], [USE_SYSTEM_NO], [USE_WORKFLOW], [DETAIL], [AUTHOR], [OBJECTS_COUNT], [DESTINATION_MODUL], [RECORD_IP], [RECORD_EMP], [RECORD_DATE], [UPDATE_IP], [UPDATE_EMP], [UPDATE_DATE], [SECURITY], [STAGE], [MODUL], [BASE], [MODUL_SHORT_NAME], [FUSEACTION], [FUSEACTION2], [FOLDER], [FILE_NAME], [IS_ADD], [IS_UPDATE], [IS_DELETE], [LEFT_MENU_NAME], [IS_WBO_DENIED], [IS_WBO_FORM_LOCK], [IS_WBO_LOCK], [IS_WBO_LOG], [IS_SPECIAL], [IS_TEMP], [EVENT_ADD], [EVENT_DASHBOARD], [EVENT_DEFAULT], [EVENT_DETAIL], [EVENT_LIST], [EVENT_UPD], [TYPE], [POPUP_TYPE], [RANK_NUMBER], [EXTERNAL_FUSEACTION], [IS_LEGACY]) VALUES (1, 83, N'Yetki Raporu İşlem Kategorisi Bazında(Excel)', 40683, NULL, N'report.emptypopup_security_report_process_cat', NULL, N'report/standart/security_report_process_cat.cfm', NULL, NULL, 1, NULL, N'Deployment', NULL, 0, NULL, N'v16', NULL, NULL, 0, 0, 0, NULL, N'Workcube Team', NULL, NULL, N'127.0.0.1', 113, CAST(N'2019-04-09 09:48:29.000' AS DateTime), N'127.0.0.1', 113, CAST(N'2019-04-09 14:04:02.033' AS DateTime), N'HTTP', NULL, NULL, NULL, N'W3WorkDev', N'emptypopup_security_report_process_cat', NULL, N'W3WorkDev', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, 0, 0, 0, NULL, NULL, NULL, 0)
END
IF NOT EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'report.emptypopup_security_report_process_based') BEGIN
    INSERT [WRK_OBJECTS] ( [IS_ACTIVE], [MODULE_NO], [HEAD], [DICTIONARY_ID], [FRIENDLY_URL], [FULL_FUSEACTION], [FULL_FUSEACTION_VARIABLES], [FILE_PATH], [CONTROLLER_FILE_PATH], [STANDART_ADDON], [LICENCE], [EVENT_TYPE], [STATUS], [IS_DEFAULT], [IS_MENU], [WINDOW], [VERSION], [IS_CATALYST_MOD], [MENU_SORT_NO], [USE_PROCESS_CAT], [USE_SYSTEM_NO], [USE_WORKFLOW], [DETAIL], [AUTHOR], [OBJECTS_COUNT], [DESTINATION_MODUL], [RECORD_IP], [RECORD_EMP], [RECORD_DATE], [UPDATE_IP], [UPDATE_EMP], [UPDATE_DATE], [SECURITY], [STAGE], [MODUL], [BASE], [MODUL_SHORT_NAME], [FUSEACTION], [FUSEACTION2], [FOLDER], [FILE_NAME], [IS_ADD], [IS_UPDATE], [IS_DELETE], [LEFT_MENU_NAME], [IS_WBO_DENIED], [IS_WBO_FORM_LOCK], [IS_WBO_LOCK], [IS_WBO_LOG], [IS_SPECIAL], [IS_TEMP], [EVENT_ADD], [EVENT_DASHBOARD], [EVENT_DEFAULT], [EVENT_DETAIL], [EVENT_LIST], [EVENT_UPD], [TYPE], [POPUP_TYPE], [RANK_NUMBER], [EXTERNAL_FUSEACTION], [IS_LEGACY]) VALUES (1, 83, N'Yetki Raporu Süreç Bazında(Excel)', 40681, NULL, N'report.emptypopup_security_report_process_based', NULL, N'report/standart/security_report_process_based.cfm', NULL, NULL, 1, NULL, N'Deployment', NULL, 0, NULL, N'v16', NULL, NULL, 0, 0, 0, NULL, N'Workcube Team', NULL, NULL, N'127.0.0.1', 113, CAST(N'2019-04-09 14:19:02.000' AS DateTime), NULL, NULL, NULL, N'HTTP', NULL, NULL, NULL, N'W3WorkDev', N'emptypopup_security_report_process_based', NULL, N'W3WorkDev', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, 0, 0, 0, NULL, NULL, NULL, 1)
END
IF NOT EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'report.emptypopup_security_report_module_based') BEGIN
    INSERT [WRK_OBJECTS] ( [IS_ACTIVE], [MODULE_NO], [HEAD], [DICTIONARY_ID], [FRIENDLY_URL], [FULL_FUSEACTION], [FULL_FUSEACTION_VARIABLES], [FILE_PATH], [CONTROLLER_FILE_PATH], [STANDART_ADDON], [LICENCE], [EVENT_TYPE], [STATUS], [IS_DEFAULT], [IS_MENU], [WINDOW], [VERSION], [IS_CATALYST_MOD], [MENU_SORT_NO], [USE_PROCESS_CAT], [USE_SYSTEM_NO], [USE_WORKFLOW], [DETAIL], [AUTHOR], [OBJECTS_COUNT], [DESTINATION_MODUL], [RECORD_IP], [RECORD_EMP], [RECORD_DATE], [UPDATE_IP], [UPDATE_EMP], [UPDATE_DATE], [SECURITY], [STAGE], [MODUL], [BASE], [MODUL_SHORT_NAME], [FUSEACTION], [FUSEACTION2], [FOLDER], [FILE_NAME], [IS_ADD], [IS_UPDATE], [IS_DELETE], [LEFT_MENU_NAME], [IS_WBO_DENIED], [IS_WBO_FORM_LOCK], [IS_WBO_LOCK], [IS_WBO_LOG], [IS_SPECIAL], [IS_TEMP], [EVENT_ADD], [EVENT_DASHBOARD], [EVENT_DEFAULT], [EVENT_DETAIL], [EVENT_LIST], [EVENT_UPD], [TYPE], [POPUP_TYPE], [RANK_NUMBER], [EXTERNAL_FUSEACTION], [IS_LEGACY]) VALUES (1, 83, N'Yetki Raporu Modül Bazında(Excel)', 40680, NULL, N'report.emptypopup_security_report_module_based', NULL, N'report/standart/security_report_module_based.cfm', NULL, NULL, 1, NULL, N'Deployment', NULL, 0, NULL, N'v16', NULL, NULL, 0, 0, 0, NULL, N'Workcube Team', NULL, NULL, N'127.0.0.1', 113, CAST(N'2019-04-09 15:53:31.000' AS DateTime), N'127.0.0.1', 113, CAST(N'2019-04-09 16:29:43.957' AS DateTime), N'HTTP', NULL, NULL, NULL, N'W3WorkDev', N'emptypopup_security_report_module_based', NULL, N'W3WorkDev', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, 0, 0, 0, NULL, NULL, NULL, 0)
END
</querytag>