<!-- Description : Ek Maliyet Raporu sayfası için yeni dil ve fusection eklendi.
Developer: Melek KOCABEY
Company : Workcube
Destination: Main-->
<querytag>
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Ek Maliyet Detay Raporu', ITEM_TR='Ek Maliyet Detay Raporu', ITEM_ENG = 'Additional Cost Detail Report' WHERE DICTIONARY_ID = 7
    IF NOT EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'report.additional_cost_detail_report')
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
        VALUES (
            1
            ,56
            ,N'Ek Maliyet Detay Raporu'
            ,7
            ,N'AdditionalCostDetailReport'
            ,N'report.additional_cost_detail_report'
            ,NULL
            ,N'report/standart/additional_cost_detail_report.cfm'
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
            ,N'<p><strong>Amaç:&nbsp;</strong>Üretim Ek Maliyet dağıtımından oluşan detayların raporlanması</p>
            <p><strong>Açıklama:&nbsp;</strong>Üretim Genel Maliyet Dağıtımında istasyon bazında farklı dağıtım kalemlerinin, Muhasebe Hesabı veya Masraf Merkezi bazın da raporlanması sağlanacaktır.</p>'
            ,N'Workcube Team'
            ,NULL
            ,NULL
            ,N'127.0.0.1'
            ,87
            ,CAST(0x0000AABC01098ED0 AS DATETIME)
            ,NULL
            ,NULL
            ,NULL
            ,N'HTTP'
            ,2176
            ,NULL
            ,NULL
            ,N'report'
            ,N'additional_cost_detail_report'
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