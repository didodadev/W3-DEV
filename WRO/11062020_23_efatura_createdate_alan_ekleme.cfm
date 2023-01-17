<!-- Description :  Gelen efatura tablosuna create_date alanı eklendi.
Developer: Mahmut Çifçi
Company : Gramoni
Destination: Period -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'EINVOICE_RECEIVING_DETAIL' AND COLUMN_NAME = 'CREATE_DATE')
    BEGIN
        ALTER TABLE EINVOICE_RECEIVING_DETAIL ADD CREATE_DATE [datetime] NULL
    END;
</querytag>