<!-- Description : Dijital varlık obje ve dil düzenlemeleri
Developer: Uğur Hamurpet
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'asset.popup_history_list') 
    BEGIN
        INSERT WRK_OBJECTS (IS_ACTIVE,MODULE_NO,HEAD,DICTIONARY_ID,FULL_FUSEACTION,FILE_PATH,LICENCE,STATUS,VERSION,DETAIL,AUTHOR,RECORD_IP,RECORD_EMP,RECORD_DATE,SECURITY,STAGE,FUSEACTION) VALUES (1,43,N'Dijital Varlık Tarihçe Sayfası',48842,N'asset.popup_history_list',N'asset/display/history_list.cfm',1,N'Deployment',N'V16',N'<p>Dijital varlıklar tarihçe popup sayfası</p>',N'Workcube Team',N'127.0.0.1',82,'2019-01-14 13:23:13.000',N'HTTP',70,'popup_history_list')
    END
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Dijital Varlık Tarihçe Sayfası', ITEM_TR='Dijital Varlık Tarihçe Sayfası', ITEM_ENG='Dijital asset history page' WHERE DICTIONARY_ID = 48842
</querytag>
