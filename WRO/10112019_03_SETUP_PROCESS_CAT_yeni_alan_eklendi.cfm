<!-- Description : SETUP_PROCESS_CAT tablosuna Gelecek Ay ve Yıllara Ait İşlemleri Tahakkuklaştır alanı eklendi.
Developer: Cemil Durgan
Company : Durgan Bilişim
Destination: Company -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'SETUP_PROCESS_CAT' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'NEXT_PERIODS_ACCRUAL_ACTION')
        BEGIN
            ALTER TABLE SETUP_PROCESS_CAT ADD NEXT_PERIODS_ACCRUAL_ACTION BIT
        END;
</querytag>
