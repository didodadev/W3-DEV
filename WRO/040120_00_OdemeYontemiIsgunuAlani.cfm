<!-- Description : Ödeme Yöntemlerine İş günü Alanı eklendi
Developer: Tolga SÜTLÜ
Company : Gramoni
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'SETUP_PAYMETHOD' AND COLUMN_NAME = 'IS_BUSINESS_DUE_DAY')
    BEGIN
        ALTER TABLE SETUP_PAYMETHOD ADD IS_BUSINESS_DUE_DAY bit NULL
    END;
</querytag>