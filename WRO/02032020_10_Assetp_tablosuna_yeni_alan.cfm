<!-- Description : Asset P tablosuna mekan tanımlamaları için yeni alan eklendi.
Developer: Emine Yılmaz
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ASSET_P' AND COLUMN_NAME = 'ASSET_P_SPACE_ID')
    BEGIN
        ALTER TABLE ASSET_P ADD
        ASSET_P_SPACE_ID int NULL
    END;
   
</querytag>