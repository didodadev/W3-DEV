<!-- Description : process cat bütçe rezerv kontrolü için yeni alan
Developer: İlker Altındal
Company : Workcube
Destination: company-->
<querytag>   
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PROCESS_CAT' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'IS_BUDGET_RESERVED_CONTROL')
    BEGIN
        ALTER TABLE SETUP_PROCESS_CAT ADD IS_BUDGET_RESERVED_CONTROL INT
    END;
</querytag>