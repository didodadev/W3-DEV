<!-- Description : Wex obje ve dil sorguları
Developer: Uğur Hamurpet
Company : Workcube
Destination: Main-->
<querytag>

IF NOT EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'objects.emptypopup_add_wex_authotization') BEGIN
    INSERT [WRK_OBJECTS] ([IS_ACTIVE], [MODULE_NO], [HEAD], [DICTIONARY_ID], [FRIENDLY_URL], [FULL_FUSEACTION], [FULL_FUSEACTION_VARIABLES], [FILE_PATH], [CONTROLLER_FILE_PATH], [STANDART_ADDON], [LICENCE], [EVENT_TYPE], [STATUS], [IS_DEFAULT], [IS_MENU], [WINDOW], [VERSION], [IS_CATALYST_MOD], [MENU_SORT_NO], [USE_PROCESS_CAT], [USE_SYSTEM_NO], [USE_WORKFLOW], [DETAIL], [AUTHOR], [OBJECTS_COUNT], [DESTINATION_MODUL], [RECORD_IP], [RECORD_EMP], [RECORD_DATE], [UPDATE_IP], [UPDATE_EMP], [UPDATE_DATE], [SECURITY], [STAGE], [MODUL], [BASE], [MODUL_SHORT_NAME], [FUSEACTION], [FUSEACTION2], [FOLDER], [FILE_NAME], [IS_ADD], [IS_UPDATE], [IS_DELETE], [LEFT_MENU_NAME], [IS_WBO_DENIED], [IS_WBO_FORM_LOCK], [IS_WBO_LOCK], [IS_WBO_LOG], [IS_SPECIAL], [IS_TEMP], [EVENT_ADD], [EVENT_DASHBOARD], [EVENT_DEFAULT], [EVENT_DETAIL], [EVENT_LIST], [EVENT_UPD], [TYPE], [POPUP_TYPE], [RANK_NUMBER], [EXTERNAL_FUSEACTION], [IS_LEGACY], [ADDOPTIONS_CONTROLLER_FILE_PATH], [THEME_PATH]) VALUES (1, 42, N'Wex Yetkilendirme İşlemleri', 48911, N'objects.emptypopup_add_wex_authotization', N'objects.emptypopup_add_wex_authotization', NULL, N'objects/query/add_wex_authotization.cfm', NULL, NULL, 1, NULL, N'Deployment', NULL, 0, NULL, N'V16', NULL, NULL, 0, 0, 0, N'<p>Wex yetkilendirme işlemleri ekleme query objesi</p>', N'Uğur Hamurpet', NULL, NULL, N'127.0.0.1', 82, CAST(N'2019-05-02 16:13:15.000' AS DateTime), N'127.0.0.1', 82, CAST(N'2019-05-06 15:36:22.233' AS DateTime), N'HTTP', 2176, NULL, NULL, N'W3WorkDev', N'emptypopup_add_wex_authotization', NULL, N'W3WorkDev', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, 0, 0, 7, NULL, NULL, NULL, 1, NULL, NULL) 
END
IF NOT EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'objects.popup_add_wex_authorization') BEGIN
    INSERT [WRK_OBJECTS] ([IS_ACTIVE], [MODULE_NO], [HEAD], [DICTIONARY_ID], [FRIENDLY_URL], [FULL_FUSEACTION], [FULL_FUSEACTION_VARIABLES], [FILE_PATH], [CONTROLLER_FILE_PATH], [STANDART_ADDON], [LICENCE], [EVENT_TYPE], [STATUS], [IS_DEFAULT], [IS_MENU], [WINDOW], [VERSION], [IS_CATALYST_MOD], [MENU_SORT_NO], [USE_PROCESS_CAT], [USE_SYSTEM_NO], [USE_WORKFLOW], [DETAIL], [AUTHOR], [OBJECTS_COUNT], [DESTINATION_MODUL], [RECORD_IP], [RECORD_EMP], [RECORD_DATE], [UPDATE_IP], [UPDATE_EMP], [UPDATE_DATE], [SECURITY], [STAGE], [MODUL], [BASE], [MODUL_SHORT_NAME], [FUSEACTION], [FUSEACTION2], [FOLDER], [FILE_NAME], [IS_ADD], [IS_UPDATE], [IS_DELETE], [LEFT_MENU_NAME], [IS_WBO_DENIED], [IS_WBO_FORM_LOCK], [IS_WBO_LOCK], [IS_WBO_LOG], [IS_SPECIAL], [IS_TEMP], [EVENT_ADD], [EVENT_DASHBOARD], [EVENT_DEFAULT], [EVENT_DETAIL], [EVENT_LIST], [EVENT_UPD], [TYPE], [POPUP_TYPE], [RANK_NUMBER], [EXTERNAL_FUSEACTION], [IS_LEGACY], [ADDOPTIONS_CONTROLLER_FILE_PATH], [THEME_PATH]) VALUES (1, 42, N'Wex Yetkilendirme', 48911, N'objects.popup_add_wex_authorization', N'objects.popup_add_wex_authorization', NULL, N'objects/form/add_wex_authorization.cfm', NULL, NULL, 1, NULL, N'Deployment', NULL, 0, NULL, N'V16', NULL, NULL, 0, 0, 0, N'<p>Wex yetkilendirme popup sayfası</p>', NULL, NULL, NULL, N'127.0.0.1', 82, CAST(N'2019-05-02 13:49:27.000' AS DateTime), N'127.0.0.1', 82, CAST(N'2019-05-06 15:36:25.963' AS DateTime), N'HTTP', 2176, NULL, NULL, N'W3WorkDev', N'popup_add_wex_authorization', NULL, N'W3WorkDev', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, 0, 0, 7, NULL, NULL, NULL, 0, NULL, NULL)
END
IF NOT EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'emptypopup_upd_wex_authotization') BEGIN
    INSERT [WRK_OBJECTS] ([IS_ACTIVE], [MODULE_NO], [HEAD], [DICTIONARY_ID], [FRIENDLY_URL], [FULL_FUSEACTION], [FULL_FUSEACTION_VARIABLES], [FILE_PATH], [CONTROLLER_FILE_PATH], [STANDART_ADDON], [LICENCE], [EVENT_TYPE], [STATUS], [IS_DEFAULT], [IS_MENU], [WINDOW], [VERSION], [IS_CATALYST_MOD], [MENU_SORT_NO], [USE_PROCESS_CAT], [USE_SYSTEM_NO], [USE_WORKFLOW], [DETAIL], [AUTHOR], [OBJECTS_COUNT], [DESTINATION_MODUL], [RECORD_IP], [RECORD_EMP], [RECORD_DATE], [UPDATE_IP], [UPDATE_EMP], [UPDATE_DATE], [SECURITY], [STAGE], [MODUL], [BASE], [MODUL_SHORT_NAME], [FUSEACTION], [FUSEACTION2], [FOLDER], [FILE_NAME], [IS_ADD], [IS_UPDATE], [IS_DELETE], [LEFT_MENU_NAME], [IS_WBO_DENIED], [IS_WBO_FORM_LOCK], [IS_WBO_LOCK], [IS_WBO_LOG], [IS_SPECIAL], [IS_TEMP], [EVENT_ADD], [EVENT_DASHBOARD], [EVENT_DEFAULT], [EVENT_DETAIL], [EVENT_LIST], [EVENT_UPD], [TYPE], [POPUP_TYPE], [RANK_NUMBER], [EXTERNAL_FUSEACTION], [IS_LEGACY], [ADDOPTIONS_CONTROLLER_FILE_PATH], [THEME_PATH]) VALUES (1, 42, N'Wex Yetkilendirme İşlemleri Güncelleme', 48916, N'objects.emptypopup_upd_wex_authotization', N'objects.emptypopup_upd_wex_authotization', NULL, N'objects/query/upd_wex_authorization.cfm', NULL, NULL, 1, NULL, N'Deployment', NULL, 0, NULL, N'V16', NULL, NULL, 0, 0, 0, N'<p>Wex yetkilendirme işlemleri güncelleme query objesi</p>', N'Uğur Hamurpet', NULL, NULL, N'127.0.0.1', 82, CAST(N'2019-05-06 15:47:06.000' AS DateTime), N'127.0.0.1', 82, CAST(N'2019-05-06 16:59:46.313' AS DateTime), N'HTTP', 2176, NULL, NULL, N'W3WorkDev', N'emptypopup_upd_wex_authotization', NULL, N'W3WorkDev', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, 0, 0, 7, NULL, NULL, NULL, 1, NULL, NULL)
END
IF NOT EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'dev.emptypopup_add_wex') BEGIN
    INSERT [WRK_OBJECTS] ([IS_ACTIVE], [MODULE_NO], [HEAD], [DICTIONARY_ID], [FRIENDLY_URL], [FULL_FUSEACTION], [FULL_FUSEACTION_VARIABLES], [FILE_PATH], [CONTROLLER_FILE_PATH], [STANDART_ADDON], [LICENCE], [EVENT_TYPE], [STATUS], [IS_DEFAULT], [IS_MENU], [WINDOW], [VERSION], [IS_CATALYST_MOD], [MENU_SORT_NO], [USE_PROCESS_CAT], [USE_SYSTEM_NO], [USE_WORKFLOW], [DETAIL], [AUTHOR], [OBJECTS_COUNT], [DESTINATION_MODUL], [RECORD_IP], [RECORD_EMP], [RECORD_DATE], [UPDATE_IP], [UPDATE_EMP], [UPDATE_DATE], [SECURITY], [STAGE], [MODUL], [BASE], [MODUL_SHORT_NAME], [FUSEACTION], [FUSEACTION2], [FOLDER], [FILE_NAME], [IS_ADD], [IS_UPDATE], [IS_DELETE], [LEFT_MENU_NAME], [IS_WBO_DENIED], [IS_WBO_FORM_LOCK], [IS_WBO_LOCK], [IS_WBO_LOG], [IS_SPECIAL], [IS_TEMP], [EVENT_ADD], [EVENT_DASHBOARD], [EVENT_DEFAULT], [EVENT_DETAIL], [EVENT_LIST], [EVENT_UPD], [TYPE], [POPUP_TYPE], [RANK_NUMBER], [EXTERNAL_FUSEACTION], [IS_LEGACY], [ADDOPTIONS_CONTROLLER_FILE_PATH], [THEME_PATH]) VALUES (1, 42, N'Wex ekle Query', 48860, NULL, N'dev.emptypopup_add_wex', NULL, N'WDO/development/query/add_wex.cfm', NULL, NULL, 1, NULL, N'Deployment', NULL, 0, NULL, N'V16', NULL, NULL, 0, 0, 0, N'<p>Wex ekleme sorgusu</p>', N'Workcube', NULL, NULL, N'127.0.0.1', 82, CAST(N'2019-04-04 13:04:45.000' AS DateTime), N'127.0.0.1', 82, CAST(N'2019-05-06 15:36:30.467' AS DateTime), N'HTTP', 2176, NULL, NULL, N'W3WorkDev', N'emptypopup_add_wex', NULL, N'W3WorkDev', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, 0, 0, 7, NULL, NULL, NULL, 1, NULL, NULL)
END
IF NOT EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'dev.emptypopup_upd_wex') BEGIN
    INSERT [WRK_OBJECTS] ([IS_ACTIVE], [MODULE_NO], [HEAD], [DICTIONARY_ID], [FRIENDLY_URL], [FULL_FUSEACTION], [FULL_FUSEACTION_VARIABLES], [FILE_PATH], [CONTROLLER_FILE_PATH], [STANDART_ADDON], [LICENCE], [EVENT_TYPE], [STATUS], [IS_DEFAULT], [IS_MENU], [WINDOW], [VERSION], [IS_CATALYST_MOD], [MENU_SORT_NO], [USE_PROCESS_CAT], [USE_SYSTEM_NO], [USE_WORKFLOW], [DETAIL], [AUTHOR], [OBJECTS_COUNT], [DESTINATION_MODUL], [RECORD_IP], [RECORD_EMP], [RECORD_DATE], [UPDATE_IP], [UPDATE_EMP], [UPDATE_DATE], [SECURITY], [STAGE], [MODUL], [BASE], [MODUL_SHORT_NAME], [FUSEACTION], [FUSEACTION2], [FOLDER], [FILE_NAME], [IS_ADD], [IS_UPDATE], [IS_DELETE], [LEFT_MENU_NAME], [IS_WBO_DENIED], [IS_WBO_FORM_LOCK], [IS_WBO_LOCK], [IS_WBO_LOG], [IS_SPECIAL], [IS_TEMP], [EVENT_ADD], [EVENT_DASHBOARD], [EVENT_DEFAULT], [EVENT_DETAIL], [EVENT_LIST], [EVENT_UPD], [TYPE], [POPUP_TYPE], [RANK_NUMBER], [EXTERNAL_FUSEACTION], [IS_LEGACY], [ADDOPTIONS_CONTROLLER_FILE_PATH], [THEME_PATH]) VALUES (1, 42, N'Wex güncelle Query', 48863, NULL, N'dev.emptypopup_upd_wex', NULL, N'WDO/development/query/upd_wex.cfm', NULL, NULL, 1, NULL, N'Deployment', NULL, 0, NULL, N'V16', NULL, NULL, 0, 0, 0, N'<p>Wex güncelleme sorgusu</p>', N'Workcube', NULL, NULL, N'127.0.0.1', 82, CAST(N'2019-04-05 16:49:40.000' AS DateTime), N'127.0.0.1', 82, CAST(N'2019-05-06 15:36:33.673' AS DateTime), N'HTTP', 2176, NULL, NULL, N'W3WorkDev', N'emptypopup_upd_wex', NULL, N'W3WorkDev', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, 0, 0, 7, NULL, NULL, NULL, 1, NULL, NULL)
END
IF NOT EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'objects.popup_list_wex') BEGIN
    INSERT [WRK_OBJECTS] ([IS_ACTIVE], [MODULE_NO], [HEAD], [DICTIONARY_ID], [FRIENDLY_URL], [FULL_FUSEACTION], [FULL_FUSEACTION_VARIABLES], [FILE_PATH], [CONTROLLER_FILE_PATH], [STANDART_ADDON], [LICENCE], [EVENT_TYPE], [STATUS], [IS_DEFAULT], [IS_MENU], [WINDOW], [VERSION], [IS_CATALYST_MOD], [MENU_SORT_NO], [USE_PROCESS_CAT], [USE_SYSTEM_NO], [USE_WORKFLOW], [DETAIL], [AUTHOR], [OBJECTS_COUNT], [DESTINATION_MODUL], [RECORD_IP], [RECORD_EMP], [RECORD_DATE], [UPDATE_IP], [UPDATE_EMP], [UPDATE_DATE], [SECURITY], [STAGE], [MODUL], [BASE], [MODUL_SHORT_NAME], [FUSEACTION], [FUSEACTION2], [FOLDER], [FILE_NAME], [IS_ADD], [IS_UPDATE], [IS_DELETE], [LEFT_MENU_NAME], [IS_WBO_DENIED], [IS_WBO_FORM_LOCK], [IS_WBO_LOCK], [IS_WBO_LOG], [IS_SPECIAL], [IS_TEMP], [EVENT_ADD], [EVENT_DASHBOARD], [EVENT_DEFAULT], [EVENT_DETAIL], [EVENT_LIST], [EVENT_UPD], [TYPE], [POPUP_TYPE], [RANK_NUMBER], [EXTERNAL_FUSEACTION], [IS_LEGACY], [ADDOPTIONS_CONTROLLER_FILE_PATH], [THEME_PATH]) VALUES (1, 42, N'Wex Listesi (Popup)', 48866, NULL, N'objects.popup_list_wex', NULL, N'objects/display/list_wex.cfm', NULL, NULL, 1, NULL, N'Deployment', NULL, 0, NULL, N'V16', NULL, NULL, 0, 0, 0, N'<p>Wex popup listeleme sayfası</p>', N'Workcube', NULL, NULL, N'127.0.0.1', 82, CAST(N'2019-04-09 11:30:34.000' AS DateTime), N'127.0.0.1', 82, CAST(N'2019-04-09 16:16:05.757' AS DateTime), N'HTTP', 2176, NULL, NULL, N'W3WorkDev', N'popup_list_wex', NULL, N'W3WorkDev', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, 0, 0, 7, NULL, NULL, NULL, 1, NULL, NULL)
END
IF NOT EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'objects.popup_upd_wex_authorization') BEGIN
    INSERT [WRK_OBJECTS] ([IS_ACTIVE], [MODULE_NO], [HEAD], [DICTIONARY_ID], [FRIENDLY_URL], [FULL_FUSEACTION], [FULL_FUSEACTION_VARIABLES], [FILE_PATH], [CONTROLLER_FILE_PATH], [STANDART_ADDON], [LICENCE], [EVENT_TYPE], [STATUS], [IS_DEFAULT], [IS_MENU], [WINDOW], [VERSION], [IS_CATALYST_MOD], [MENU_SORT_NO], [USE_PROCESS_CAT], [USE_SYSTEM_NO], [USE_WORKFLOW], [DETAIL], [AUTHOR], [OBJECTS_COUNT], [DESTINATION_MODUL], [RECORD_IP], [RECORD_EMP], [RECORD_DATE], [UPDATE_IP], [UPDATE_EMP], [UPDATE_DATE], [SECURITY], [STAGE], [MODUL], [BASE], [MODUL_SHORT_NAME], [FUSEACTION], [FUSEACTION2], [FOLDER], [FILE_NAME], [IS_ADD], [IS_UPDATE], [IS_DELETE], [LEFT_MENU_NAME], [IS_WBO_DENIED], [IS_WBO_FORM_LOCK], [IS_WBO_LOCK], [IS_WBO_LOG], [IS_SPECIAL], [IS_TEMP], [EVENT_ADD], [EVENT_DASHBOARD], [EVENT_DEFAULT], [EVENT_DETAIL], [EVENT_LIST], [EVENT_UPD], [TYPE], [POPUP_TYPE], [RANK_NUMBER], [EXTERNAL_FUSEACTION], [IS_LEGACY], [ADDOPTIONS_CONTROLLER_FILE_PATH], [THEME_PATH]) VALUES (1, 42, N'Wex Yetkilendirme İşlemleri Güncelleme', 48916, N'objects.popup_upd_wex_authorization', N'objects.popup_upd_wex_authorization', NULL, N'objects/form/upd_wex_authorization.cfm', NULL, NULL, 1, NULL, N'Deployment', NULL, 0, NULL, N'V16', NULL, NULL, 0, 0, 0, N'<p>Wex Yetkilendirme İşlemleri Güncelleme Form Sayfası</p>', N'Uğur Hamurpet', NULL, NULL, N'127.0.0.1', 82, CAST(N'2019-05-06 15:42:58.000' AS DateTime), NULL, NULL, NULL, N'HTTP', 2176, NULL, NULL, N'W3WorkDev', N'popup_upd_wex_authorization', NULL, N'W3WorkDev', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, 0, 0, 7, NULL, NULL, NULL, 1, NULL, NULL)
END
IF NOT EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'sales.subscription_counter_prepaid') BEGIN
    INSERT [WRK_OBJECTS] ([IS_ACTIVE], [MODULE_NO], [HEAD], [DICTIONARY_ID], [FRIENDLY_URL], [FULL_FUSEACTION], [FULL_FUSEACTION_VARIABLES], [FILE_PATH], [CONTROLLER_FILE_PATH], [STANDART_ADDON], [LICENCE], [EVENT_TYPE], [STATUS], [IS_DEFAULT], [IS_MENU], [WINDOW], [VERSION], [IS_CATALYST_MOD], [MENU_SORT_NO], [USE_PROCESS_CAT], [USE_SYSTEM_NO], [USE_WORKFLOW], [DETAIL], [AUTHOR], [OBJECTS_COUNT], [DESTINATION_MODUL], [RECORD_IP], [RECORD_EMP], [RECORD_DATE], [UPDATE_IP], [UPDATE_EMP], [UPDATE_DATE], [SECURITY], [STAGE], [MODUL], [BASE], [MODUL_SHORT_NAME], [FUSEACTION], [FUSEACTION2], [FOLDER], [FILE_NAME], [IS_ADD], [IS_UPDATE], [IS_DELETE], [LEFT_MENU_NAME], [IS_WBO_DENIED], [IS_WBO_FORM_LOCK], [IS_WBO_LOCK], [IS_WBO_LOG], [IS_SPECIAL], [IS_TEMP], [EVENT_ADD], [EVENT_DASHBOARD], [EVENT_DEFAULT], [EVENT_DETAIL], [EVENT_LIST], [EVENT_UPD], [TYPE], [POPUP_TYPE], [RANK_NUMBER], [EXTERNAL_FUSEACTION], [IS_LEGACY], [ADDOPTIONS_CONTROLLER_FILE_PATH], [THEME_PATH]) VALUES (1, 79, N'Sayaç Yükleme İşlemleri', 48878, NULL, N'sales.subscription_counter_prepaid', NULL, N'sales/form/list_subscription_counter_prepaid.cfm', N'WBO/controller/SalesSubscriptionCounterPrepaid.cfm', NULL, 1, NULL, N'Deployment', NULL, 1, NULL, N'V16', NULL, NULL, 0, 0, 0, N'<p>Sayaç yükleme işlemleri</p>', N'Workcube', NULL, NULL, N'127.0.0.1', 82, CAST(N'2019-04-11 15:30:42.000' AS DateTime), N'127.0.0.1', 82, CAST(N'2019-04-11 17:59:14.077' AS DateTime), N'HTTP', 2176, NULL, NULL, N'W3WorkDev', N'subscription_counter_prepaid', NULL, N'W3WorkDev', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, NULL, 0, 1, 1, 0, NULL, NULL, NULL, 0, NULL, NULL)
END
IF NOT EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'sales.popup_subscription_counter_prepaid') BEGIN
    INSERT [WRK_OBJECTS] ([IS_ACTIVE], [MODULE_NO], [HEAD], [DICTIONARY_ID], [FRIENDLY_URL], [FULL_FUSEACTION], [FULL_FUSEACTION_VARIABLES], [FILE_PATH], [CONTROLLER_FILE_PATH], [STANDART_ADDON], [LICENCE], [EVENT_TYPE], [STATUS], [IS_DEFAULT], [IS_MENU], [WINDOW], [VERSION], [IS_CATALYST_MOD], [MENU_SORT_NO], [USE_PROCESS_CAT], [USE_SYSTEM_NO], [USE_WORKFLOW], [DETAIL], [AUTHOR], [OBJECTS_COUNT], [DESTINATION_MODUL], [RECORD_IP], [RECORD_EMP], [RECORD_DATE], [UPDATE_IP], [UPDATE_EMP], [UPDATE_DATE], [SECURITY], [STAGE], [MODUL], [BASE], [MODUL_SHORT_NAME], [FUSEACTION], [FUSEACTION2], [FOLDER], [FILE_NAME], [IS_ADD], [IS_UPDATE], [IS_DELETE], [LEFT_MENU_NAME], [IS_WBO_DENIED], [IS_WBO_FORM_LOCK], [IS_WBO_LOCK], [IS_WBO_LOG], [IS_SPECIAL], [IS_TEMP], [EVENT_ADD], [EVENT_DASHBOARD], [EVENT_DEFAULT], [EVENT_DETAIL], [EVENT_LIST], [EVENT_UPD], [TYPE], [POPUP_TYPE], [RANK_NUMBER], [EXTERNAL_FUSEACTION], [IS_LEGACY], [ADDOPTIONS_CONTROLLER_FILE_PATH], [THEME_PATH]) VALUES (1, 79, N'Sayaç Yükleme İşlemleri', 48878, N'sales.popup_subscription_counter_prepaid', N'sales.popup_subscription_counter_prepaid', NULL, N'sales/display/popup_subscription_counter_prepaid.cfm', NULL, NULL, 1, NULL, N'Development', NULL, 0, NULL, N'V16', NULL, NULL, 0, 0, 0, N'<p>Sayaç yükleme işlemleri popup sayfası</p>', N'Workcube Team', NULL, NULL, N'127.0.0.1', 82, CAST(N'2019-04-24 13:30:58.000' AS DateTime), N'127.0.0.1', 82, CAST(N'2019-04-24 14:10:15.837' AS DateTime), N'HTTP', NULL, NULL, NULL, N'W3WorkDev', N'popup_subscription_counter_prepaid', NULL, N'W3WorkDev', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, 0, 0, 0, 0, NULL, NULL, NULL, 1, NULL, NULL)
END
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Wex ekle Query', ITEM_TR='Wex ekle Query', ITEM_ENG='Wex add query' WHERE DICTIONARY_ID = 48860
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Wex güncelle Query', ITEM_TR='Wex güncelle Query', ITEM_ENG='Wex update query' WHERE DICTIONARY_ID = 48863
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Wex Listesi (Popup)', ITEM_TR='Wex Listesi (Popup)', ITEM_ENG='Wex List (Popup)' WHERE DICTIONARY_ID = 48866
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Yükle', ITEM_TR='Yükle', ITEM_ENG='Upload' WHERE DICTIONARY_ID = 48868
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Oku', ITEM_TR='Oku', ITEM_ENG='Read' WHERE DICTIONARY_ID = 48869
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Sayaç Yükle', ITEM_TR='Sayaç Yükle', ITEM_ENG='Counter Load' WHERE DICTIONARY_ID = 48870
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Sayaç No', ITEM_TR='Sayaç No', ITEM_ENG='Counter No' WHERE DICTIONARY_ID = 48871
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Sayaç Yükleme İşlemleri', ITEM_TR='Sayaç Yükleme İşlemleri', ITEM_ENG='Counter Loading Operations' WHERE DICTIONARY_ID = 48878
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Yükleme Miktarı', ITEM_TR='Yükleme Miktarı', ITEM_ENG='Loading Amount' WHERE DICTIONARY_ID = 48879
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Yükleme Tarihi', ITEM_TR='Yükleme Tarihi', ITEM_ENG='Loading Date' WHERE DICTIONARY_ID = 48882
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Yükleyen', ITEM_TR='Yükleyen', ITEM_ENG='Loader' WHERE DICTIONARY_ID = 48887
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Paket Miktar', ITEM_TR='Paket Miktar', ITEM_ENG='Package Quantity' WHERE DICTIONARY_ID = 48888
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Wex Yetkilendirme İşlemleri', ITEM_TR='Wex Yetkilendirme İşlemleri', ITEM_ENG='Wex Authorization Operations' WHERE DICTIONARY_ID = 48911
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Yetki Listesi', ITEM_TR='Yetki Listesi', ITEM_ENG='Authority List' WHERE DICTIONARY_ID = 48912
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Wex Yetkilendirme İşlemleri Güncelleme', ITEM_TR='Wex Yetkilendirme İşlemleri Güncelleme', ITEM_ENG='Wex Authorization Operations Update' WHERE DICTIONARY_ID = 48916
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Lütfen dakika cinsinden bir zaman giriniz', ITEM_TR='Lütfen dakika cinsinden bir zaman giriniz', ITEM_ENG='Please enter a time in minutes' WHERE DICTIONARY_ID = 48930
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Sayaç Tipi - Sayaç No Seçiniz', ITEM_TR='Sayaç Tipi - Sayaç No Seçiniz', ITEM_ENG='Please select  Counter Type - Counter No' WHERE DICTIONARY_ID = 48946
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Yükleyen kişiyi seçiniz', ITEM_TR='Yükleyen kişiyi seçiniz', ITEM_ENG='Please select loader' WHERE DICTIONARY_ID = 48947
</querytag>