<!-- Description : E-Government WBO güncelleme
Developer: Mahmut Çifçi
Company : Gramoni
Destination: Main -->
<querytag>
    UPDATE WRK_OBJECTS SET IS_ACTIVE = CONVERT(bit, 'True'), MODULE_NO = 28, HEAD = N'E-Fatura Görüntüleme', DICTIONARY_ID = 60063, FRIENDLY_URL = N'InvoiceEcontrol', FULL_FUSEACTION_VARIABLES = NULL, FILE_PATH = N'e_government/display/dsp_efatura_detail.cfm', STANDART_ADDON = 1, LICENCE = 1, EVENT_TYPE = N'UPD', STATUS = N'Deployment', IS_DEFAULT = CONVERT(bit, 'True'), IS_MENU = CONVERT(bit, 'False'), WINDOW = N'popup', VERSION = N'1.0', IS_CATALYST_MOD = CONVERT(bit, 'True'), USE_PROCESS_CAT = CONVERT(bit, 'False'), USE_SYSTEM_NO = CONVERT(bit, 'False'), USE_WORKFLOW = CONVERT(bit, 'False'), DETAIL = NULL, AUTHOR = N'Workcube Core', DESTINATION_MODUL = NULL, STAGE = 2176, MODUL = N'E-Government', BASE = N'ERP', MODUL_SHORT_NAME = N'E-Government', FUSEACTION = N'popup_dsp_efatura_detail', FOLDER = N'display', FILE_NAME = N'dsp_efatura_detail.cfm', IS_ADD = CONVERT(bit, 'False'), IS_UPDATE = CONVERT(bit, 'False'), IS_DELETE = CONVERT(bit, 'False'), LEFT_MENU_NAME = N'', IS_WBO_DENIED = CONVERT(bit, 'False'), IS_WBO_FORM_LOCK = CONVERT(bit, 'False'), IS_WBO_LOCK = CONVERT(bit, 'False'), IS_WBO_LOG = CONVERT(bit, 'False'), IS_SPECIAL = CONVERT(bit, 'False'), IS_TEMP = CONVERT(bit, 'False'), EVENT_ADD = CONVERT(bit, 'False'), EVENT_DASHBOARD = CONVERT(bit, 'False'), EVENT_DEFAULT = NULL, EVENT_DETAIL = CONVERT(bit, 'False'), EVENT_LIST = CONVERT(bit, 'False'), EVENT_UPD = CONVERT(bit, 'False'), TYPE = 0, POPUP_TYPE = NULL, RANK_NUMBER = NULL, EXTERNAL_FUSEACTION = NULL, IS_LEGACY = 1 WHERE FULL_FUSEACTION = N'objects.popup_dsp_efatura_detail'
    UPDATE WRK_OBJECTS SET IS_ACTIVE = CONVERT(bit, 'True'), MODULE_NO = 28, HEAD = N'E-Fatura Görsel', DICTIONARY_ID = NULL, FRIENDLY_URL = NULL, FULL_FUSEACTION_VARIABLES = NULL, FILE_PATH = N'e_government/display/dsp_einvoice_detail.cfm', STANDART_ADDON = 5, LICENCE = 1, EVENT_TYPE = NULL, STATUS = N'Deployment', IS_DEFAULT = NULL, IS_MENU = CONVERT(bit, 'False'), WINDOW = N'popup', VERSION = N'1.0', IS_CATALYST_MOD = NULL, USE_PROCESS_CAT = CONVERT(bit, 'False'), USE_SYSTEM_NO = CONVERT(bit, 'False'), USE_WORKFLOW = CONVERT(bit, 'False'), DETAIL = NULL, AUTHOR = N'Workcube Core', DESTINATION_MODUL = NULL, STAGE = 2176, MODUL = N'E-Government', BASE = N'ERP', MODUL_SHORT_NAME = N'E-Government', FUSEACTION = N'popup_ajax_list_dsp_einvoice_detail', FOLDER = N'display', FILE_NAME = N'dsp_einvoice_detail.cfm', IS_ADD = CONVERT(bit, 'False'), IS_UPDATE = CONVERT(bit, 'False'), IS_DELETE = CONVERT(bit, 'False'), LEFT_MENU_NAME = NULL, IS_WBO_DENIED = NULL, IS_WBO_FORM_LOCK = CONVERT(bit, 'False'), IS_WBO_LOCK = NULL, IS_WBO_LOG = CONVERT(bit, 'False'), IS_SPECIAL = CONVERT(bit, 'False'), IS_TEMP = NULL, EVENT_ADD = CONVERT(bit, 'False'), EVENT_DASHBOARD = CONVERT(bit, 'False'), EVENT_DEFAULT = NULL, EVENT_DETAIL = CONVERT(bit, 'False'), EVENT_LIST = CONVERT(bit, 'False'), EVENT_UPD = CONVERT(bit, 'False'), TYPE = 10, POPUP_TYPE = NULL, RANK_NUMBER = NULL, EXTERNAL_FUSEACTION = NULL, IS_LEGACY = 1 WHERE FULL_FUSEACTION = N'objects.popup_ajax_list_dsp_einvoice_detail'
    UPDATE WRK_OBJECTS SET IS_ACTIVE = CONVERT(bit, 'True'), MODULE_NO = 28, HEAD = N'E-Fatura Dönüş Değerleri', DICTIONARY_ID = NULL, FRIENDLY_URL = NULL, FULL_FUSEACTION_VARIABLES = NULL, FILE_PATH = N'e_government/display/return_detail.cfm', STANDART_ADDON = 9, LICENCE = 1, EVENT_TYPE = NULL, STATUS = N'Deployment', IS_DEFAULT = NULL, IS_MENU = CONVERT(bit, 'False'), WINDOW = N'popup', VERSION = N'1.0', IS_CATALYST_MOD = NULL, USE_PROCESS_CAT = CONVERT(bit, 'False'), USE_SYSTEM_NO = CONVERT(bit, 'False'), USE_WORKFLOW = CONVERT(bit, 'False'), DETAIL = NULL, AUTHOR = N'Workcube Core', DESTINATION_MODUL = NULL, STAGE = 2176, MODUL = N'E-Government', BASE = N'ERP', MODUL_SHORT_NAME = N'E-Government', FUSEACTION = N'popup_return_detail', FOLDER = N'display', FILE_NAME = N'return_detail.cfm', IS_ADD = CONVERT(bit, 'False'), IS_UPDATE = CONVERT(bit, 'False'), IS_DELETE = CONVERT(bit, 'False'), LEFT_MENU_NAME = NULL, IS_WBO_DENIED = NULL, IS_WBO_FORM_LOCK = NULL, IS_WBO_LOCK = NULL, IS_WBO_LOG = CONVERT(bit, 'False'), IS_SPECIAL = CONVERT(bit, 'False'), IS_TEMP = NULL, EVENT_ADD = CONVERT(bit, 'False'), EVENT_DASHBOARD = CONVERT(bit, 'False'), EVENT_DEFAULT = NULL, EVENT_DETAIL = CONVERT(bit, 'False'), EVENT_LIST = CONVERT(bit, 'False'), EVENT_UPD = CONVERT(bit, 'False'), TYPE = 10, POPUP_TYPE = NULL, RANK_NUMBER = NULL, EXTERNAL_FUSEACTION = NULL, IS_LEGACY = 1 WHERE FULL_FUSEACTION = N'invoice.popup_return_detail'
    UPDATE WRK_OBJECTS SET IS_ACTIVE = CONVERT(bit, 'True'), MODULE_NO = 28, HEAD = N'E-Arşiv Görsel', DICTIONARY_ID = NULL, FRIENDLY_URL = N'eArchiveDisplay', FULL_FUSEACTION_VARIABLES = NULL, FILE_PATH = N'e_government/display/dsp_earchive_detail.cfm', STANDART_ADDON = 5, LICENCE = 1, EVENT_TYPE = NULL, STATUS = N'Deployment', IS_DEFAULT = NULL, IS_MENU = CONVERT(bit, 'False'), WINDOW = N'popup', VERSION = N'1.0', IS_CATALYST_MOD = NULL, USE_PROCESS_CAT = CONVERT(bit, 'False'), USE_SYSTEM_NO = CONVERT(bit, 'False'), USE_WORKFLOW = CONVERT(bit, 'False'), DETAIL = NULL, AUTHOR = N'Workcube Core', DESTINATION_MODUL = NULL, STAGE = 2176, MODUL = N'E-Government', BASE = N'ERP', MODUL_SHORT_NAME = N'E-Goverment', FUSEACTION = N'popup_dsp_earchive_detail', FOLDER = N'display', FILE_NAME = N'dsp_earchive_detail.cfm', IS_ADD = CONVERT(bit, 'False'), IS_UPDATE = CONVERT(bit, 'False'), IS_DELETE = CONVERT(bit, 'False'), LEFT_MENU_NAME = NULL, IS_WBO_DENIED = NULL, IS_WBO_FORM_LOCK = CONVERT(bit, 'False'), IS_WBO_LOCK = NULL, IS_WBO_LOG = CONVERT(bit, 'False'), IS_SPECIAL = CONVERT(bit, 'False'), IS_TEMP = NULL, EVENT_ADD = CONVERT(bit, 'False'), EVENT_DASHBOARD = CONVERT(bit, 'False'), EVENT_DEFAULT = NULL, EVENT_DETAIL = CONVERT(bit, 'False'), EVENT_LIST = CONVERT(bit, 'False'), EVENT_UPD = CONVERT(bit, 'False'), TYPE = 10, POPUP_TYPE = NULL, RANK_NUMBER = NULL, EXTERNAL_FUSEACTION = NULL, IS_LEGACY = 1 WHERE FULL_FUSEACTION = N'objects.popup_dsp_earchive_detail'
    UPDATE WRK_OBJECTS SET IS_ACTIVE = CONVERT(bit, 'True'), MODULE_NO = 28, HEAD = N'E-Arşiv Gönderim Detayları', DICTIONARY_ID = NULL, FRIENDLY_URL = NULL, FULL_FUSEACTION_VARIABLES = NULL, FILE_PATH = N'e_government/display/send_detail_earchive.cfm', STANDART_ADDON = 9, LICENCE = 1, EVENT_TYPE = NULL, STATUS = N'Deployment', IS_DEFAULT = NULL, IS_MENU = CONVERT(bit, 'False'), WINDOW = N'popup', VERSION = N'1.0', IS_CATALYST_MOD = NULL, USE_PROCESS_CAT = CONVERT(bit, 'False'), USE_SYSTEM_NO = CONVERT(bit, 'False'), USE_WORKFLOW = CONVERT(bit, 'False'), DETAIL = NULL, AUTHOR = N'Workcube Core', DESTINATION_MODUL = NULL, STAGE = 2176, MODUL = N'E-Government', BASE = N'ERP', MODUL_SHORT_NAME = N'E-Government', FUSEACTION = N'popup_send_detail_earchive', FOLDER = N'display', FILE_NAME = N'send_detail_earchive.cfm', IS_ADD = CONVERT(bit, 'False'), IS_UPDATE = CONVERT(bit, 'False'), IS_DELETE = CONVERT(bit, 'False'), LEFT_MENU_NAME = NULL, IS_WBO_DENIED = NULL, IS_WBO_FORM_LOCK = CONVERT(bit, 'False'), IS_WBO_LOCK = NULL, IS_WBO_LOG = CONVERT(bit, 'False'), IS_SPECIAL = CONVERT(bit, 'False'), IS_TEMP = NULL, EVENT_ADD = CONVERT(bit, 'False'), EVENT_DASHBOARD = CONVERT(bit, 'False'), EVENT_DEFAULT = NULL, EVENT_DETAIL = CONVERT(bit, 'False'), EVENT_LIST = CONVERT(bit, 'False'), EVENT_UPD = CONVERT(bit, 'False'), TYPE = 10, POPUP_TYPE = NULL, RANK_NUMBER = NULL, EXTERNAL_FUSEACTION = NULL, IS_LEGACY = 1 WHERE FULL_FUSEACTION = N'invoice.popup_send_detail_earchive'
    UPDATE WRK_OBJECTS SET IS_ACTIVE = CONVERT(bit, 'True'), MODULE_NO = 28, HEAD = N'E-Arşiv İptal Gönderimi', DICTIONARY_ID = NULL, FRIENDLY_URL = NULL, FULL_FUSEACTION_VARIABLES = NULL, FILE_PATH = N'e_government/display/send_iptal_earchive.cfm', STANDART_ADDON = 9, LICENCE = 1, EVENT_TYPE = NULL, STATUS = N'Deployment', IS_DEFAULT = NULL, IS_MENU = CONVERT(bit, 'False'), WINDOW = N'popup', VERSION = N'1.0', IS_CATALYST_MOD = NULL, USE_PROCESS_CAT = CONVERT(bit, 'False'), USE_SYSTEM_NO = CONVERT(bit, 'False'), USE_WORKFLOW = CONVERT(bit, 'False'), DETAIL = NULL, AUTHOR = N'Workcube Core', DESTINATION_MODUL = NULL, STAGE = 2176, MODUL = N'E-Government', BASE = N'ERP', MODUL_SHORT_NAME = N'E-Government', FUSEACTION = N'popup_send_cancel_earchive', FOLDER = N'display', FILE_NAME = N'send_iptal_earchive.cfm', IS_ADD = CONVERT(bit, 'False'), IS_UPDATE = CONVERT(bit, 'False'), IS_DELETE = CONVERT(bit, 'False'), LEFT_MENU_NAME = NULL, IS_WBO_DENIED = NULL, IS_WBO_FORM_LOCK = CONVERT(bit, 'False'), IS_WBO_LOCK = NULL, IS_WBO_LOG = CONVERT(bit, 'False'), IS_SPECIAL = CONVERT(bit, 'False'), IS_TEMP = NULL, EVENT_ADD = CONVERT(bit, 'False'), EVENT_DASHBOARD = CONVERT(bit, 'False'), EVENT_DEFAULT = NULL, EVENT_DETAIL = CONVERT(bit, 'False'), EVENT_LIST = CONVERT(bit, 'False'), EVENT_UPD = CONVERT(bit, 'False'), TYPE = 10, POPUP_TYPE = NULL, RANK_NUMBER = NULL, EXTERNAL_FUSEACTION = NULL, IS_LEGACY = 1 WHERE FULL_FUSEACTION = N'invoice.popup_send_cancel_earchive'
    UPDATE WRK_OBJECTS SET IS_ACTIVE = CONVERT(bit, 'True'), MODULE_NO = 28, HEAD = N'E-Fatura Gönderim Detayları', DICTIONARY_ID = NULL, FRIENDLY_URL = NULL, FULL_FUSEACTION_VARIABLES = NULL, FILE_PATH = N'e_government/display/send_detail.cfm', STANDART_ADDON = 9, LICENCE = 1, EVENT_TYPE = NULL, STATUS = N'Deployment', IS_DEFAULT = NULL, IS_MENU = CONVERT(bit, 'False'), WINDOW = N'popup', VERSION = N'1.0', IS_CATALYST_MOD = NULL, USE_PROCESS_CAT = CONVERT(bit, 'False'), USE_SYSTEM_NO = CONVERT(bit, 'False'), USE_WORKFLOW = CONVERT(bit, 'False'), DETAIL = N'<p>E-Fatura Gönderim detaylarını görüntüler.</p>', AUTHOR = N'Workcube Core', DESTINATION_MODUL = NULL, STAGE = 2176, MODUL = N'E-Government', BASE = N'ERP', MODUL_SHORT_NAME = N'E-Government', FUSEACTION = N'popup_send_detail', FOLDER = N'display', FILE_NAME = N'send_detail.cfm', IS_ADD = CONVERT(bit, 'False'), IS_UPDATE = CONVERT(bit, 'False'), IS_DELETE = CONVERT(bit, 'False'), LEFT_MENU_NAME = NULL, IS_WBO_DENIED = NULL, IS_WBO_FORM_LOCK = NULL, IS_WBO_LOCK = NULL, IS_WBO_LOG = CONVERT(bit, 'False'), IS_SPECIAL = CONVERT(bit, 'False'), IS_TEMP = NULL, EVENT_ADD = CONVERT(bit, 'False'), EVENT_DASHBOARD = CONVERT(bit, 'False'), EVENT_DEFAULT = NULL, EVENT_DETAIL = CONVERT(bit, 'False'), EVENT_LIST = CONVERT(bit, 'False'), EVENT_UPD = CONVERT(bit, 'False'), TYPE = 10, POPUP_TYPE = NULL, RANK_NUMBER = NULL, EXTERNAL_FUSEACTION = NULL, IS_LEGACY = 1 WHERE FULL_FUSEACTION = N'invoice.popup_send_detail'
    UPDATE WRK_OBJECTS SET IS_ACTIVE = CONVERT(bit, 'True'), MODULE_NO = 28, HEAD = N'E-Fatura Xml Ekle Query', DICTIONARY_ID = NULL, FRIENDLY_URL = NULL, FULL_FUSEACTION_VARIABLES = NULL, FILE_PATH = N'e_government/query/add_efatura_xml.cfm', CONTROLLER_FILE_PATH = NULL, STANDART_ADDON = 2, LICENCE = 1, EVENT_TYPE = NULL, STATUS = N'Deployment', IS_DEFAULT = NULL, IS_MENU = CONVERT(bit, 'False'), WINDOW = N'emptypopup', VERSION = N'1.0', IS_CATALYST_MOD = NULL, MENU_SORT_NO = NULL, USE_PROCESS_CAT = CONVERT(bit, 'False'), USE_SYSTEM_NO = CONVERT(bit, 'False'), USE_WORKFLOW = CONVERT(bit, 'False'), DETAIL = NULL, AUTHOR = N'Workcube Core', DESTINATION_MODUL = NULL, STAGE = 2176, MODUL = N'E-Government', BASE = N'ERP', MODUL_SHORT_NAME = N'E-Government', FUSEACTION = N'emptypopup_add_efatura_xml', FOLDER = N'query', FILE_NAME = N'add_efatura_xml.cfm', IS_ADD = CONVERT(bit, 'True'), IS_UPDATE = CONVERT(bit, 'False'), IS_DELETE = CONVERT(bit, 'False'), LEFT_MENU_NAME = NULL, IS_WBO_DENIED = CONVERT(bit, 'False'), IS_WBO_FORM_LOCK = CONVERT(bit, 'False'), IS_WBO_LOCK = CONVERT(bit, 'False'), IS_WBO_LOG = CONVERT(bit, 'False'), IS_SPECIAL = CONVERT(bit, 'False'), IS_TEMP = CONVERT(bit, 'False'), EVENT_ADD = CONVERT(bit, 'False'), EVENT_DASHBOARD = CONVERT(bit, 'False'), EVENT_DEFAULT = NULL, EVENT_DETAIL = CONVERT(bit, 'False'), EVENT_LIST = CONVERT(bit, 'False'), EVENT_UPD = CONVERT(bit, 'False'), TYPE = 11, POPUP_TYPE = NULL, RANK_NUMBER = NULL, EXTERNAL_FUSEACTION = NULL, IS_LEGACY = 1 WHERE FULL_FUSEACTION = N'objects.emptypopup_add_efatura_xml'
    UPDATE WRK_OBJECTS SET IS_ACTIVE = CONVERT(bit, 'True'), MODULE_NO = 28, HEAD = N'Gelen E-Fatura', DICTIONARY_ID = 47112, FRIENDLY_URL = N'InvoiceEcontrol', FULL_FUSEACTION_VARIABLES = N'', FILE_PATH = N'e_government/display/received_einvoices.cfm', CONTROLLER_FILE_PATH = N'WBO/controller/InvoiceEcontrolController.cfm', STANDART_ADDON = 1, LICENCE = 1, EVENT_TYPE = N'LIST', STATUS = N'Deployment', IS_DEFAULT = CONVERT(bit, 'True'), IS_MENU = CONVERT(bit, 'True'), WINDOW = N'NORMAL', VERSION = N'1.0', IS_CATALYST_MOD = CONVERT(bit, 'True'), MENU_SORT_NO = NULL, USE_PROCESS_CAT = CONVERT(bit, 'False'), USE_SYSTEM_NO = CONVERT(bit, 'False'), USE_WORKFLOW = CONVERT(bit, 'False'), DETAIL = NULL, AUTHOR = N'Workcube Core', DESTINATION_MODUL = NULL, STAGE = 2176, MODUL = N'E-Government', BASE = N'ERP', MODUL_SHORT_NAME = N'E-Government', FUSEACTION = N'received_einvoices', FOLDER = N'display', FILE_NAME = N'received_einvoices.cfm', IS_ADD = CONVERT(bit, 'False'), IS_UPDATE = CONVERT(bit, 'False'), IS_DELETE = CONVERT(bit, 'False'), LEFT_MENU_NAME = N'', IS_WBO_DENIED = NULL, IS_WBO_FORM_LOCK = NULL, IS_WBO_LOCK = NULL, IS_WBO_LOG = CONVERT(bit, 'False'), IS_SPECIAL = CONVERT(bit, 'False'), IS_TEMP = CONVERT(bit, 'False'), EVENT_ADD = CONVERT(bit, 'False'), EVENT_DASHBOARD = CONVERT(bit, 'False'), EVENT_DEFAULT = N'list', EVENT_DETAIL = CONVERT(bit, 'False'), EVENT_LIST = CONVERT(bit, 'False'), EVENT_UPD = CONVERT(bit, 'False'), TYPE = 0, POPUP_TYPE = NULL, RANK_NUMBER = 5, EXTERNAL_FUSEACTION = NULL, IS_LEGACY = 0 WHERE FULL_FUSEACTION = N'invoice.received_einvoices'

    DELETE WRK_OBJECTS WHERE FULL_FUSEACTION = N'invoice.emptypopup_add_efatura_xml'
    DELETE WRK_OBJECTS WHERE FULL_FUSEACTION = N'invoice.popup_add_efatura_xml'
</querytag>