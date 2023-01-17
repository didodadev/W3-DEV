<!-- Description : Dijital varlık kategorilerileri için popup ve ajax objeleri oluşturuldu.
Developer: Uğur Hamurpet
Company : Workcube
Destination: Main-->
<querytag>
IF NOT EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'objects.ajax_get_asset_cat') BEGIN
    INSERT WRK_OBJECTS (IS_ACTIVE,MODULE_NO,HEAD,DICTIONARY_ID,FULL_FUSEACTION,FILE_PATH,LICENCE,STATUS,VERSION,AUTHOR,RECORD_IP,RECORD_EMP,RECORD_DATE,SECURITY,FUSEACTION) VALUES (1,8,N'Dijital Varlık Kategorileri Ajax Sayfası',48524,N'objects.ajax_get_asset_cat',N'objects/display/ajax_get_asset_cat.cfm',1,N'Deployment',N'V16',N'Workcube Team',N'127.0.0.1',82,'2019-01-14 13:23:13.000',N'HTTP','ajax_get_asset_cat')
END
IF NOT EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'objects.popup_add_asset_cat') BEGIN
    INSERT WRK_OBJECTS (IS_ACTIVE,MODULE_NO,HEAD,DICTIONARY_ID,FULL_FUSEACTION,FILE_PATH,LICENCE,STATUS,VERSION,AUTHOR,RECORD_IP,RECORD_EMP,RECORD_DATE,SECURITY,FUSEACTION) VALUES (1,8,N'Dijital Varlık Kategorisi Ekleme Popup Sayfası',48554,N'objects.popup_add_asset_cat',N'settings/form/add_asset_cat.cfm',1,N'Deployment',N'V16',N'Workcube Team',N'127.0.0.1',82,'2019-01-16 18:58:30.000',N'HTTP','popup_add_asset_cat')
END
IF NOT EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = 'objects.popup_upd_asset_cat') BEGIN
    INSERT WRK_OBJECTS (IS_ACTIVE,MODULE_NO,HEAD,DICTIONARY_ID,FULL_FUSEACTION,FILE_PATH,LICENCE,STATUS,VERSION,AUTHOR,RECORD_IP,RECORD_EMP,RECORD_DATE,SECURITY,FUSEACTION) VALUES (1,8,N'Dijital Varlık Kategorisi Güncelleme Popup Sayfası',48584,N'objects.popup_upd_asset_cat',N'settings/form/upd_asset_cat.cfm',1,N'Deployment',N'V16',N'Workcube Team',N'127.0.0.1',82,'2019-01-17 11:22:45.000',N'HTTP','popup_upd_asset_cat')
END
    ALTER TABLE ASSET_CAT ALTER COLUMN ASSETCAT_PATH NVARCHAR(MAX)
</querytag>