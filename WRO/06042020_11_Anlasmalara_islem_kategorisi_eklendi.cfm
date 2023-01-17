
<!-- Description : Anlaşmalar tablosuna işlem kategorisi alanı eklendi
Developer: Gulbahar Inan
Company : Workcube
Destination: company-->
<querytag>   
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'RELATED_CONTRACT' AND COLUMN_NAME = 'PROCESS_CAT')
    BEGIN
        ALTER TABLE RELATED_CONTRACT ADD
        PROCESS_CAT int NULL
    END;
</querytag>