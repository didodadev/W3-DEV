<!-- Description : SETUP_PROCESS_CAT tablosuna IS_EXPENSING_TAX alanı açıldı
Developer: Uğur Hamurpet
Company : Workcube
Destination: Company -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'SETUP_PROCESS_CAT' AND COLUMN_NAME = 'IS_EXPENSING_TAX' )
    BEGIN
        ALTER TABLE SETUP_PROCESS_CAT ADD IS_EXPENSING_TAX INT NULL DEFAULT 0
    END
</querytag>