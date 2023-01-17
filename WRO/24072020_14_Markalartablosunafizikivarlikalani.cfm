<!--Description : Markalar tablosuna Fiziki varlık alanı eklendi.
Developer: Gulbahar Inan
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_BRAND' AND COLUMN_NAME = 'PHYSICAL_ASSET')
    BEGIN
        ALTER TABLE SETUP_BRAND ADD PHYSICAL_ASSET bit
    END
</querytag>