<!-- Description : Dijital Arşive Embed codu ekleyip videoları gösterebilme durumu için, ASSET tablosuna alan eklendi
Developer: İlker Altındal
Company : Workcube
Destination: Main -->
<querytag>
    
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='ASSET' AND COLUMN_NAME='EMBEDCODE_URL')
    BEGIN
        ALTER TABLE ASSET ADD
        EMBEDCODE_URL nvarchar(500)
    END  

</querytag>
