<!-- Description : process cat tevkifat yapılmasın seçeneği eklendi.
Developer: İlker Altındal
Company : Workcube
Destination: company-->
<querytag>   
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PROCESS_CAT' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'IS_VISIBLE_TEVKIFAT')
    BEGIN
        ALTER TABLE SETUP_PROCESS_CAT ADD IS_VISIBLE_TEVKIFAT bit NULL
    END;
</querytag>