<!-- Description : PRODUCT_PERIOD tablosuna alanlar eklendi.
Developer: Cemil Durgan
Company : Durgan Bilişim
Destination: Company -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PRODUCT_PERIOD' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PAST_MONTHS_TO_FIRST')
        BEGIN
            ALTER TABLE PRODUCT_PERIOD ADD PAST_MONTHS_TO_FIRST BIT
        END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'PRODUCT_PERIOD' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'PAST_MONTHS_TO_FIRST_IFRS')
        BEGIN
            ALTER TABLE PRODUCT_PERIOD ADD PAST_MONTHS_TO_FIRST_IFRS BIT
        END;
</querytag>
