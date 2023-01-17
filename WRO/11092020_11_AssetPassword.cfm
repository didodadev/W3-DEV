<!-- Description : Dijital Arşive şifre alanı eklendi.
Developer: Emine Yılmaz
Company : Workcube
Destination: main -->
<querytag>
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='ASSET' AND COLUMN_NAME='PASSWORD')
    BEGIN
        ALTER TABLE ASSET ADD PASSWORD nvarchar(50) NULL;
    END; 
</querytag>