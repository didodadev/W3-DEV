<!-- Description :  CONTENT_BANNERS tablosuna CONTENT alanı eklendi.
Developer: Berkay Topçu
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='CONTENT_BANNERS' AND COLUMN_NAME='CONTENT')
    BEGIN
        ALTER TABLE CONTENT_BANNERS
        ADD CONTENT nvarchar(MAX) NULL
    END;
</querytag>