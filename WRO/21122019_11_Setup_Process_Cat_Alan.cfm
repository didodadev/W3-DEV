<!-- Description : IS_ALL_USER alanı açıldı
Developer: Canan Ebret
Company : Workcube
Destination: Company -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'SETUP_PROCESS_CAT' AND COLUMN_NAME = 'IS_ALL_USERS' )
    BEGIN
        ALTER TABLE SETUP_PROCESS_CAT ADD IS_ALL_USERS BIT 
    END
</querytag>