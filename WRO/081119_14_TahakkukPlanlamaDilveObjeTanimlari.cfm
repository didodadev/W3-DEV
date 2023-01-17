<!-- Description : Tahakkuk Planlama için dil ve obje tanimlamalari yapildi.
Developer: Botan Kayğan
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'budget.list_tahakkuk')
    BEGIN
        INSERT [WRK_OBJECTS] ([IS_ACTIVE], [MODULE_NO], [HEAD], [DICTIONARY_ID], [FRIENDLY_URL], [FULL_FUSEACTION], [FULL_FUSEACTION_VARIABLES], [FILE_PATH], [CONTROLLER_FILE_PATH], [STANDART_ADDON], [LICENCE], [EVENT_TYPE], [STATUS], [IS_DEFAULT], [IS_MENU], [WINDOW], [VERSION], [IS_CATALYST_MOD], [MENU_SORT_NO], [USE_PROCESS_CAT], [USE_SYSTEM_NO], [USE_WORKFLOW], [DETAIL], [AUTHOR], [OBJECTS_COUNT], [DESTINATION_MODUL], [RECORD_IP], [RECORD_EMP], [RECORD_DATE], [UPDATE_IP], [UPDATE_EMP], [UPDATE_DATE], [SECURITY], [STAGE], [MODUL], [BASE], [MODUL_SHORT_NAME], [FUSEACTION], [FUSEACTION2], [FOLDER], [FILE_NAME], [IS_ADD], [IS_UPDATE], [IS_DELETE], [LEFT_MENU_NAME], [IS_WBO_DENIED], [IS_WBO_FORM_LOCK], [IS_WBO_LOCK], [IS_WBO_LOG], [IS_SPECIAL], [IS_TEMP], [EVENT_ADD], [EVENT_DASHBOARD], [EVENT_DEFAULT], [EVENT_DETAIL], [EVENT_LIST], [EVENT_UPD], [TYPE], [POPUP_TYPE], [RANK_NUMBER], [EXTERNAL_FUSEACTION], [IS_LEGACY], [ADDOPTIONS_CONTROLLER_FILE_PATH], [THEME_PATH], [IS_ONLY_SHOW_PAGE], [DISPLAY_BEFORE_PATH], [DISPLAY_AFTER_PATH], [ACTION_BEFORE_PATH], [ACTION_AFTER_PATH], [ICON]) VALUES (1, 46, N'Tahakkuk Planlama', 36205, NULL, N'budget.list_tahakkuk', NULL, N'budget/display/list_tahakkuk.cfm', N'WBO/controller/TahakkukController.cfm', 9, 1, NULL, N'Deployment', NULL, 1, N'popup', N'v16', NULL, NULL, 0, 0, 0, NULL, N'Workcube Team', 0, NULL, N'127.0.0.1', 96, NULL, N'127.0.0.1', 119, CAST(N'2019-11-08T10:38:26.530' AS DateTime), N'HTTP', 2176, N'Objects', N'Intranet', N'Objects', N'list_tahakkuk', NULL, NULL, NULL, 0, 0, 0, NULL, 0, 0, 0, NULL, 0, 0, 0, 0, NULL, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
    END;

    IF NOT EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'budget.emptypopup_add_tahakkuk_plan')
    BEGIN
        INSERT [WRK_OBJECTS] ([IS_ACTIVE], [MODULE_NO], [HEAD], [DICTIONARY_ID], [FRIENDLY_URL], [FULL_FUSEACTION], [FULL_FUSEACTION_VARIABLES], [FILE_PATH], [CONTROLLER_FILE_PATH], [STANDART_ADDON], [LICENCE], [EVENT_TYPE], [STATUS], [IS_DEFAULT], [IS_MENU], [WINDOW], [VERSION], [IS_CATALYST_MOD], [MENU_SORT_NO], [USE_PROCESS_CAT], [USE_SYSTEM_NO], [USE_WORKFLOW], [DETAIL], [AUTHOR], [OBJECTS_COUNT], [DESTINATION_MODUL], [RECORD_IP], [RECORD_EMP], [RECORD_DATE], [UPDATE_IP], [UPDATE_EMP], [UPDATE_DATE], [SECURITY], [STAGE], [MODUL], [BASE], [MODUL_SHORT_NAME], [FUSEACTION], [FUSEACTION2], [FOLDER], [FILE_NAME], [IS_ADD], [IS_UPDATE], [IS_DELETE], [LEFT_MENU_NAME], [IS_WBO_DENIED], [IS_WBO_FORM_LOCK], [IS_WBO_LOCK], [IS_WBO_LOG], [IS_SPECIAL], [IS_TEMP], [EVENT_ADD], [EVENT_DASHBOARD], [EVENT_DEFAULT], [EVENT_DETAIL], [EVENT_LIST], [EVENT_UPD], [TYPE], [POPUP_TYPE], [RANK_NUMBER], [EXTERNAL_FUSEACTION], [IS_LEGACY], [ADDOPTIONS_CONTROLLER_FILE_PATH], [THEME_PATH], [IS_ONLY_SHOW_PAGE], [DISPLAY_BEFORE_PATH], [DISPLAY_AFTER_PATH], [ACTION_BEFORE_PATH], [ACTION_AFTER_PATH], [ICON]) VALUES (1, 46, N'Tahakkuk Planlama Ekle Query', 56340, NULL, N'budget.emptypopup_add_tahakkuk_plan', NULL, N'budget/query/add_tahakkuk_plan.cfm', NULL, NULL, 1, NULL, N'Deployment', NULL, 0, NULL, N'v16', NULL, NULL, 0, 0, 0, NULL, N'Workcube Team', NULL, NULL, N'127.0.0.1', 119, CAST(N'2019-11-07T17:29:47.000' AS DateTime), NULL, NULL, NULL, N'HTTP', 2176, NULL, NULL, N'budget', N'emptypopup_add_tahakkuk_plan', NULL, N'W3WorkDev', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, 0, 0, 11, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
    END;

    IF NOT EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'budget.emptypopup_upd_tahakkuk_plan')
    BEGIN
        INSERT [WRK_OBJECTS] ([IS_ACTIVE], [MODULE_NO], [HEAD], [DICTIONARY_ID], [FRIENDLY_URL], [FULL_FUSEACTION], [FULL_FUSEACTION_VARIABLES], [FILE_PATH], [CONTROLLER_FILE_PATH], [STANDART_ADDON], [LICENCE], [EVENT_TYPE], [STATUS], [IS_DEFAULT], [IS_MENU], [WINDOW], [VERSION], [IS_CATALYST_MOD], [MENU_SORT_NO], [USE_PROCESS_CAT], [USE_SYSTEM_NO], [USE_WORKFLOW], [DETAIL], [AUTHOR], [OBJECTS_COUNT], [DESTINATION_MODUL], [RECORD_IP], [RECORD_EMP], [RECORD_DATE], [UPDATE_IP], [UPDATE_EMP], [UPDATE_DATE], [SECURITY], [STAGE], [MODUL], [BASE], [MODUL_SHORT_NAME], [FUSEACTION], [FUSEACTION2], [FOLDER], [FILE_NAME], [IS_ADD], [IS_UPDATE], [IS_DELETE], [LEFT_MENU_NAME], [IS_WBO_DENIED], [IS_WBO_FORM_LOCK], [IS_WBO_LOCK], [IS_WBO_LOG], [IS_SPECIAL], [IS_TEMP], [EVENT_ADD], [EVENT_DASHBOARD], [EVENT_DEFAULT], [EVENT_DETAIL], [EVENT_LIST], [EVENT_UPD], [TYPE], [POPUP_TYPE], [RANK_NUMBER], [EXTERNAL_FUSEACTION], [IS_LEGACY], [ADDOPTIONS_CONTROLLER_FILE_PATH], [THEME_PATH], [IS_ONLY_SHOW_PAGE], [DISPLAY_BEFORE_PATH], [DISPLAY_AFTER_PATH], [ACTION_BEFORE_PATH], [ACTION_AFTER_PATH], [ICON]) VALUES (1, 46, N'Tahakkuk Planlama Güncelle Query', 56305, NULL, N'budget.emptypopup_upd_tahakkuk_plan', NULL, N'budget/query/upd_tahakkuk_plan.cfm', NULL, NULL, 1, NULL, N'Deployment', NULL, 0, NULL, N'v16', NULL, NULL, 0, 0, 0, NULL, N'Workcube Team', NULL, NULL, N'127.0.0.1', 119, CAST(N'2019-11-07T17:34:15.000' AS DateTime), NULL, NULL, NULL, N'HTTP', 2176, NULL, NULL, N'budget', N'emptypopup_upd_tahakkuk_plan', NULL, N'W3WorkDev', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, 0, 0, 11, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
    END;

    IF NOT EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'budget.list_tahakkuk_aktarim')
    BEGIN
        INSERT [WRK_OBJECTS] ([IS_ACTIVE], [MODULE_NO], [HEAD], [DICTIONARY_ID], [FRIENDLY_URL], [FULL_FUSEACTION], [FULL_FUSEACTION_VARIABLES], [FILE_PATH], [CONTROLLER_FILE_PATH], [STANDART_ADDON], [LICENCE], [EVENT_TYPE], [STATUS], [IS_DEFAULT], [IS_MENU], [WINDOW], [VERSION], [IS_CATALYST_MOD], [MENU_SORT_NO], [USE_PROCESS_CAT], [USE_SYSTEM_NO], [USE_WORKFLOW], [DETAIL], [AUTHOR], [OBJECTS_COUNT], [DESTINATION_MODUL], [RECORD_IP], [RECORD_EMP], [RECORD_DATE], [UPDATE_IP], [UPDATE_EMP], [UPDATE_DATE], [SECURITY], [STAGE], [MODUL], [BASE], [MODUL_SHORT_NAME], [FUSEACTION], [FUSEACTION2], [FOLDER], [FILE_NAME], [IS_ADD], [IS_UPDATE], [IS_DELETE], [LEFT_MENU_NAME], [IS_WBO_DENIED], [IS_WBO_FORM_LOCK], [IS_WBO_LOCK], [IS_WBO_LOG], [IS_SPECIAL], [IS_TEMP], [EVENT_ADD], [EVENT_DASHBOARD], [EVENT_DEFAULT], [EVENT_DETAIL], [EVENT_LIST], [EVENT_UPD], [TYPE], [POPUP_TYPE], [RANK_NUMBER], [EXTERNAL_FUSEACTION], [IS_LEGACY], [ADDOPTIONS_CONTROLLER_FILE_PATH], [THEME_PATH], [IS_ONLY_SHOW_PAGE], [DISPLAY_BEFORE_PATH], [DISPLAY_AFTER_PATH], [ACTION_BEFORE_PATH], [ACTION_AFTER_PATH], [ICON]) VALUES (1, 46, N'Tahakkuk Planları Aktarım', 56296, NULL, N'budget.list_tahakkuk_aktarim', NULL, N'budget/display/list_tahakkuk_aktarim.cfm', NULL, NULL, 1, NULL, N'Deployment', NULL, 1, NULL, N'v16', NULL, NULL, 0, 0, 0, NULL, N'Workcube Team', NULL, NULL, N'127.0.0.1', 119, CAST(N'2019-11-07T17:37:31.000' AS DateTime), NULL, NULL, NULL, N'HTTP', 2176, NULL, NULL, N'budget', N'list_tahakkuk_aktarim', NULL, N'W3WorkDev', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, 0, 0, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
    END;

    IF NOT EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'budget.emptypopup_del_tahakkuk_plan')
    BEGIN
        INSERT [WRK_OBJECTS] ([IS_ACTIVE], [MODULE_NO], [HEAD], [DICTIONARY_ID], [FRIENDLY_URL], [FULL_FUSEACTION], [FULL_FUSEACTION_VARIABLES], [FILE_PATH], [CONTROLLER_FILE_PATH], [STANDART_ADDON], [LICENCE], [EVENT_TYPE], [STATUS], [IS_DEFAULT], [IS_MENU], [WINDOW], [VERSION], [IS_CATALYST_MOD], [MENU_SORT_NO], [USE_PROCESS_CAT], [USE_SYSTEM_NO], [USE_WORKFLOW], [DETAIL], [AUTHOR], [OBJECTS_COUNT], [DESTINATION_MODUL], [RECORD_IP], [RECORD_EMP], [RECORD_DATE], [UPDATE_IP], [UPDATE_EMP], [UPDATE_DATE], [SECURITY], [STAGE], [MODUL], [BASE], [MODUL_SHORT_NAME], [FUSEACTION], [FUSEACTION2], [FOLDER], [FILE_NAME], [IS_ADD], [IS_UPDATE], [IS_DELETE], [LEFT_MENU_NAME], [IS_WBO_DENIED], [IS_WBO_FORM_LOCK], [IS_WBO_LOCK], [IS_WBO_LOG], [IS_SPECIAL], [IS_TEMP], [EVENT_ADD], [EVENT_DASHBOARD], [EVENT_DEFAULT], [EVENT_DETAIL], [EVENT_LIST], [EVENT_UPD], [TYPE], [POPUP_TYPE], [RANK_NUMBER], [EXTERNAL_FUSEACTION], [IS_LEGACY], [ADDOPTIONS_CONTROLLER_FILE_PATH], [THEME_PATH], [IS_ONLY_SHOW_PAGE], [DISPLAY_BEFORE_PATH], [DISPLAY_AFTER_PATH], [ACTION_BEFORE_PATH], [ACTION_AFTER_PATH], [ICON]) VALUES (1, 46, N'Tahakkuk Plan Sil Query', 56299, NULL, N'budget.emptypopup_del_tahakkuk_plan', NULL, N'budget/query/del_tahakkuk_plan.cfm', NULL, NULL, 1, NULL, N'Deployment', NULL, 0, NULL, N'v16', NULL, NULL, 0, 0, 0, NULL, N'Workcube Team', NULL, NULL, N'127.0.0.1', 119, CAST(N'2019-11-07T17:40:50.000' AS DateTime), N'127.0.0.1', 119, CAST(N'2019-11-07T17:49:34.657' AS DateTime), N'HTTP', 2176, NULL, NULL, N'budget', N'emptypopup_del_tahakkuk_plan', NULL, N'W3WorkDev', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, 0, 0, 11, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
    END;

    IF NOT EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'budget.emptypopup_tahakkuk_aktarim_gider')
    BEGIN
        INSERT [WRK_OBJECTS] ([IS_ACTIVE], [MODULE_NO], [HEAD], [DICTIONARY_ID], [FRIENDLY_URL], [FULL_FUSEACTION], [FULL_FUSEACTION_VARIABLES], [FILE_PATH], [CONTROLLER_FILE_PATH], [STANDART_ADDON], [LICENCE], [EVENT_TYPE], [STATUS], [IS_DEFAULT], [IS_MENU], [WINDOW], [VERSION], [IS_CATALYST_MOD], [MENU_SORT_NO], [USE_PROCESS_CAT], [USE_SYSTEM_NO], [USE_WORKFLOW], [DETAIL], [AUTHOR], [OBJECTS_COUNT], [DESTINATION_MODUL], [RECORD_IP], [RECORD_EMP], [RECORD_DATE], [UPDATE_IP], [UPDATE_EMP], [UPDATE_DATE], [SECURITY], [STAGE], [MODUL], [BASE], [MODUL_SHORT_NAME], [FUSEACTION], [FUSEACTION2], [FOLDER], [FILE_NAME], [IS_ADD], [IS_UPDATE], [IS_DELETE], [LEFT_MENU_NAME], [IS_WBO_DENIED], [IS_WBO_FORM_LOCK], [IS_WBO_LOCK], [IS_WBO_LOG], [IS_SPECIAL], [IS_TEMP], [EVENT_ADD], [EVENT_DASHBOARD], [EVENT_DEFAULT], [EVENT_DETAIL], [EVENT_LIST], [EVENT_UPD], [TYPE], [POPUP_TYPE], [RANK_NUMBER], [EXTERNAL_FUSEACTION], [IS_LEGACY], [ADDOPTIONS_CONTROLLER_FILE_PATH], [THEME_PATH], [IS_ONLY_SHOW_PAGE], [DISPLAY_BEFORE_PATH], [DISPLAY_AFTER_PATH], [ACTION_BEFORE_PATH], [ACTION_AFTER_PATH], [ICON]) VALUES (1, 46, N'Tahakkuk İşlemleri Aktarım Query', 56328, NULL, N'budget.emptypopup_tahakkuk_aktarim_gider', NULL, N'budget/query/add_tahakkuk_aktarim_gider.cfm', NULL, NULL, 1, NULL, N'Deployment', NULL, 0, NULL, N'v16', NULL, NULL, 0, 0, 0, NULL, N'Workcube Team', NULL, NULL, N'127.0.0.1', 119, CAST(N'2019-11-07T17:49:01.000' AS DateTime), NULL, NULL, NULL, N'HTTP', 2176, NULL, NULL, N'budget', N'emptypopup_tahakkuk_aktarim_gider', NULL, N'W3WorkDev', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, 0, 0, 11, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
    END;

    IF NOT EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'objects.popup_account_plan_new')
    BEGIN
        INSERT [WRK_OBJECTS] ([IS_ACTIVE], [MODULE_NO], [HEAD], [DICTIONARY_ID], [FRIENDLY_URL], [FULL_FUSEACTION], [FULL_FUSEACTION_VARIABLES], [FILE_PATH], [CONTROLLER_FILE_PATH], [STANDART_ADDON], [LICENCE], [EVENT_TYPE], [STATUS], [IS_DEFAULT], [IS_MENU], [WINDOW], [VERSION], [IS_CATALYST_MOD], [MENU_SORT_NO], [USE_PROCESS_CAT], [USE_SYSTEM_NO], [USE_WORKFLOW], [DETAIL], [AUTHOR], [OBJECTS_COUNT], [DESTINATION_MODUL], [RECORD_IP], [RECORD_EMP], [RECORD_DATE], [UPDATE_IP], [UPDATE_EMP], [UPDATE_DATE], [SECURITY], [STAGE], [MODUL], [BASE], [MODUL_SHORT_NAME], [FUSEACTION], [FUSEACTION2], [FOLDER], [FILE_NAME], [IS_ADD], [IS_UPDATE], [IS_DELETE], [LEFT_MENU_NAME], [IS_WBO_DENIED], [IS_WBO_FORM_LOCK], [IS_WBO_LOCK], [IS_WBO_LOG], [IS_SPECIAL], [IS_TEMP], [EVENT_ADD], [EVENT_DASHBOARD], [EVENT_DEFAULT], [EVENT_DETAIL], [EVENT_LIST], [EVENT_UPD], [TYPE], [POPUP_TYPE], [RANK_NUMBER], [EXTERNAL_FUSEACTION], [IS_LEGACY], [ADDOPTIONS_CONTROLLER_FILE_PATH], [THEME_PATH], [IS_ONLY_SHOW_PAGE], [DISPLAY_BEFORE_PATH], [DISPLAY_AFTER_PATH], [ACTION_BEFORE_PATH], [ACTION_AFTER_PATH], [ICON]) VALUES (1, 46, N'Hesap Planı Seçim', 56327, N'account_plan_new', N'objects.popup_account_plan_new', NULL, N'budget/display/list_account_plan_new.cfm', NULL, NULL, 1, NULL, N'Deployment', NULL, 0, NULL, N'v16', NULL, NULL, 0, 0, 0, NULL, N'Workcube Team', NULL, NULL, N'127.0.0.1', 119, CAST(N'2019-11-07T17:52:27.000' AS DateTime), NULL, NULL, NULL, N'HTTP', 2176, NULL, NULL, N'objects', N'popup_account_plan_new', NULL, N'W3WorkDev', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, 0, 0, 10, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
    END;

    IF NOT EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'objects.popup_payment_with_voucher_tahakkuk')
    BEGIN
        INSERT [WRK_OBJECTS] ([IS_ACTIVE], [MODULE_NO], [HEAD], [DICTIONARY_ID], [FRIENDLY_URL], [FULL_FUSEACTION], [FULL_FUSEACTION_VARIABLES], [FILE_PATH], [CONTROLLER_FILE_PATH], [STANDART_ADDON], [LICENCE], [EVENT_TYPE], [STATUS], [IS_DEFAULT], [IS_MENU], [WINDOW], [VERSION], [IS_CATALYST_MOD], [MENU_SORT_NO], [USE_PROCESS_CAT], [USE_SYSTEM_NO], [USE_WORKFLOW], [DETAIL], [AUTHOR], [OBJECTS_COUNT], [DESTINATION_MODUL], [RECORD_IP], [RECORD_EMP], [RECORD_DATE], [UPDATE_IP], [UPDATE_EMP], [UPDATE_DATE], [SECURITY], [STAGE], [MODUL], [BASE], [MODUL_SHORT_NAME], [FUSEACTION], [FUSEACTION2], [FOLDER], [FILE_NAME], [IS_ADD], [IS_UPDATE], [IS_DELETE], [LEFT_MENU_NAME], [IS_WBO_DENIED], [IS_WBO_FORM_LOCK], [IS_WBO_LOCK], [IS_WBO_LOG], [IS_SPECIAL], [IS_TEMP], [EVENT_ADD], [EVENT_DASHBOARD], [EVENT_DEFAULT], [EVENT_DETAIL], [EVENT_LIST], [EVENT_UPD], [TYPE], [POPUP_TYPE], [RANK_NUMBER], [EXTERNAL_FUSEACTION], [IS_LEGACY], [ADDOPTIONS_CONTROLLER_FILE_PATH], [THEME_PATH], [IS_ONLY_SHOW_PAGE], [DISPLAY_BEFORE_PATH], [DISPLAY_AFTER_PATH], [ACTION_BEFORE_PATH], [ACTION_AFTER_PATH], [ICON]) VALUES (1, 46, N'Ödeme Planı Ekle Güncelle', 56334, N'popup_payment_with_voucher_tahakkuk', N'objects.popup_payment_with_voucher_tahakkuk', NULL, N'budget/form/payment_with_voucher_tahakkuk.cfm', NULL, NULL, 1, NULL, N'Deployment', NULL, 0, NULL, N'v16', NULL, NULL, 0, 0, 0, NULL, N'Workcube Team', NULL, NULL, N'127.0.0.1', 119, CAST(N'2019-11-07T17:56:39.000' AS DateTime), N'127.0.0.1', 119, CAST(N'2019-11-07T17:59:13.127' AS DateTime), N'HTTP', 2176, NULL, NULL, N'objects', N'popup_payment_with_voucher_tahakkuk', NULL, N'W3WorkDev', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, 0, 0, 10, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
    END;

    IF NOT EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'objects.emptypopup_payment_with_voucher_tahakkuk')
    BEGIN
        INSERT [WRK_OBJECTS] ([IS_ACTIVE], [MODULE_NO], [HEAD], [DICTIONARY_ID], [FRIENDLY_URL], [FULL_FUSEACTION], [FULL_FUSEACTION_VARIABLES], [FILE_PATH], [CONTROLLER_FILE_PATH], [STANDART_ADDON], [LICENCE], [EVENT_TYPE], [STATUS], [IS_DEFAULT], [IS_MENU], [WINDOW], [VERSION], [IS_CATALYST_MOD], [MENU_SORT_NO], [USE_PROCESS_CAT], [USE_SYSTEM_NO], [USE_WORKFLOW], [DETAIL], [AUTHOR], [OBJECTS_COUNT], [DESTINATION_MODUL], [RECORD_IP], [RECORD_EMP], [RECORD_DATE], [UPDATE_IP], [UPDATE_EMP], [UPDATE_DATE], [SECURITY], [STAGE], [MODUL], [BASE], [MODUL_SHORT_NAME], [FUSEACTION], [FUSEACTION2], [FOLDER], [FILE_NAME], [IS_ADD], [IS_UPDATE], [IS_DELETE], [LEFT_MENU_NAME], [IS_WBO_DENIED], [IS_WBO_FORM_LOCK], [IS_WBO_LOCK], [IS_WBO_LOG], [IS_SPECIAL], [IS_TEMP], [EVENT_ADD], [EVENT_DASHBOARD], [EVENT_DEFAULT], [EVENT_DETAIL], [EVENT_LIST], [EVENT_UPD], [TYPE], [POPUP_TYPE], [RANK_NUMBER], [EXTERNAL_FUSEACTION], [IS_LEGACY], [ADDOPTIONS_CONTROLLER_FILE_PATH], [THEME_PATH], [IS_ONLY_SHOW_PAGE], [DISPLAY_BEFORE_PATH], [DISPLAY_AFTER_PATH], [ACTION_BEFORE_PATH], [ACTION_AFTER_PATH], [ICON]) VALUES (1, 46, N'Ödeme Planı Ekle Query', 56351, N'emptypopup_payment_with_voucher_tahakkuk', N'objects.emptypopup_payment_with_voucher_tahakkuk', NULL, N'budget/query/payment_with_voucher_tahakkuk.cfm', NULL, NULL, 1, NULL, N'Deployment', NULL, 0, NULL, N'v16', NULL, NULL, 0, 0, 0, NULL, N'Workcube Team', NULL, NULL, N'127.0.0.1', 119, CAST(N'2019-11-07T18:01:24.000' AS DateTime), NULL, NULL, NULL, N'HTTP', 2176, NULL, NULL, N'objects', N'emptypopup_payment_with_voucher_tahakkuk', NULL, N'W3WorkDev', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, 0, 0, 11, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
    END;

    UPDATE SETUP_LANGUAGE_TR SET ITEM='Tahakkuk Planlama', ITEM_TR='Tahakkuk Planlama', ITEM_ENG='Accrual Planning' WHERE DICTIONARY_ID = 36205
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Tahakkuk Planlama Ekle Query', ITEM_TR='Tahakkuk Planlama Ekle Query', ITEM_ENG='Accrual Planning Add Query' WHERE DICTIONARY_ID = 56340
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Tahakkuk Planlama Güncelle Query', ITEM_TR='Tahakkuk Planlama Güncelle Query', ITEM_ENG='Accrual Planning Update Query' WHERE DICTIONARY_ID = 56305
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Tahakkuk Planları Aktarım', ITEM_TR='Tahakkuk Planları Aktarım', ITEM_ENG='Accrual Plans Transfer' WHERE DICTIONARY_ID = 56296
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Tahakkuk Plan Sil Query', ITEM_TR='Tahakkuk Plan Sil Query', ITEM_ENG='Accrual Planning Delete Query' WHERE DICTIONARY_ID = 56299
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Tahakkuk İşlemleri Aktarım Query', ITEM_TR='Tahakkuk İşlemleri Aktarım Query', ITEM_ENG='Accrual Transactions Transfer Query' WHERE DICTIONARY_ID = 56328
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Hesap Planı Seçim', ITEM_TR='Hesap Planı Seçim', ITEM_ENG='Account Plan Selection' WHERE DICTIONARY_ID = 56327
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Ödeme Planı Ekle Güncelle', ITEM_TR='Ödeme Planı Ekle Güncelle', ITEM_ENG='Payment Plan Add Update' WHERE DICTIONARY_ID = 56334
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Ödeme Planı Ekle Query', ITEM_TR='Ödeme Planı Ekle Query', ITEM_ENG='Payment Plan Add Query' WHERE DICTIONARY_ID = 56351
</querytag>