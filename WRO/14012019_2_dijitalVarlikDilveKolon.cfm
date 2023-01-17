<!-- Description : Dijital varlık kategorileri dil güncellemeleri yapıldı ve ASSET_CAT tablosuna yeni kolon eklendi 
Developer: Uğur Hamurpet
Company : Workcube
Destination: Main-->
<querytag>
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Dijital Varlık Kategorileri Ajax Sayfası', ITEM_TR='Dijital Varlık Kategorileri Ajax Sayfası', ITEM_ENG='Digital Asset Categories Ajax Page' WHERE DICTIONARY_ID = 48524
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Eğer yeni bir alt kategori ekleyecekseniz, bir ana kategori seçmelisiniz', ITEM_TR='Eğer yeni bir alt kategori ekleyecekseniz, bir ana kategori seçmelisiniz', ITEM_ENG='If you are adding a new subcategory, you must select a main category' WHERE DICTIONARY_ID = 48526
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Seçtiğiniz kategori mevcut değil', ITEM_TR='Seçtiğiniz kategori mevcut değil', ITEM_ENG='The category you selected does not exist' WHERE DICTIONARY_ID = 48534
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Bu dosyayı görüntülemek için izinli değilsiniz! Kod : Yasaklı Kullanıcı', ITEM_TR='Bu dosyayı görüntülemek için izinli değilsiniz! Kod : Yasaklı Kullanıcı', ITEM_ENG='You have not permission for view this file! Code : Banned user' WHERE DICTIONARY_ID = 48537
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Aynı isimde bir kategori mevcut! Lütfen farklı bir isimle tekrar deneyiniz!', ITEM_TR='Aynı isimde bir kategori mevcut! Lütfen farklı bir isimle tekrar deneyiniz!', ITEM_ENG='A category with the same name is available! Please try again with a different name!' WHERE DICTIONARY_ID = 48542
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Dijital Varlık Kategorisi Ekleme Popup Sayfası', ITEM_TR='Dijital Varlık Kategorisi Ekleme Popup Sayfası', ITEM_ENG='Digital Asset Category Add Popup Page' WHERE DICTIONARY_ID = 48554
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Dijital Varlık Kategorisi Güncelleme Popup Sayfası', ITEM_TR='Dijital Varlık Kategorisi Güncelleme Popup Sayfası', ITEM_ENG='Digital Asset Category Update Popup Page' WHERE DICTIONARY_ID = 48584
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Yeni Klasör', ITEM_TR='Yeni Klasör', ITEM_ENG='New Folder' WHERE DICTIONARY_ID = 48601
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Yeniden Adlandır', ITEM_TR='Yeniden Adlandır', ITEM_ENG='Rename' WHERE DICTIONARY_ID = 48602
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Dosyayı Güncelle', ITEM_TR='Dosyayı Güncelle', ITEM_ENG='Update File' WHERE DICTIONARY_ID = 48605
    
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ASSET_CAT' AND COLUMN_NAME = 'ASSETCAT_MAIN_ID')
    BEGIN
        ALTER TABLE ASSET_CAT ADD 
        ASSETCAT_MAIN_ID INT
    END
</querytag>