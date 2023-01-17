<!-- Description : PRODUCT_PERIOD tablosu için önceki wro eksik kalmıştı, eklendi.
Developer: Cemil Durgan
Company : Durgan Bilişim
Destination: Company -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PRODUCT_PERIOD' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'ACCRUAL_MONTH_IFRS')
        BEGIN
            ALTER TABLE PRODUCT_PERIOD ADD ACCRUAL_MONTH_IFRS INT
        END;
</querytag>
