<!-- Description : Forum yeni dilleri eklendi ve tablo güncellemesi yapıldı 
Developer: Uğur Hamurpet
Company : Workcube
Destination: Main -->
<querytag>
    IF EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='FORUM_TOPIC' AND INFORMATION_SCHEMA.TABLES.TABLE_SCHEMA <> 'dbo' )
    BEGIN
        IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='FORUM_TOPIC' AND COLUMN_NAME='FORUM_TOPIC_REAL_FILE')
        BEGIN
        ALTER TABLE FORUM_TOPIC ADD 
        FORUM_TOPIC_REAL_FILE nvarchar(100)
        END
    END;
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Konu eklenirken bir hata oluştu', ITEM_TR='Konu eklenirken bir hata oluştu', ITEM_ENG='An error occurred while adding a topic' WHERE DICTIONARY_ID = 55021
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Kriterlerinize uygun kayıt bulunamadı', ITEM_TR='Kriterlerinize uygun kayıt bulunamadı', ITEM_ENG='No records found matching your criteria' WHERE DICTIONARY_ID = 47731
</querytag>