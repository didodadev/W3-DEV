<!-- Description : Tekrar eden menü isimleri düzenlendi 2
Developer: Uğur Hamurpet
Company : Workcube
Destination: Main-->
<querytag>
    UPDATE SETUP_LANGUAGE_TR SET ITEM = 'Bakım Takvimi | SERVİS', ITEM_TR = 'Bakım Takvimi | SERVİS', ITEM_ENG = 'Maintenance Schedule | SERVİCE' WHERE DICTIONARY_ID = 41738
    UPDATE SETUP_LANGUAGE_TR SET ITEM = 'Bakım Takvimi | VARLIKLAR', ITEM_TR = 'Bakım Takvimi | VARLIKLAR', ITEM_ENG = 'Maintenance Schedule | ASSETCARE' WHERE DICTIONARY_ID = 47752
    UPDATE WRK_OBJECTS SET HEAD = 'Bakım Takvimi | SERVİS', DICTIONARY_ID = 41738 WHERE WRK_OBJECTS_ID = 4805
    UPDATE WRK_OBJECTS SET HEAD = 'Bakım Takvimi | VARLIKLAR', DICTIONARY_ID = 47752 WHERE WRK_OBJECTS_ID = 85
</querytag>