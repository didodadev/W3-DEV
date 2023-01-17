<!-- Description : Gelen E-faturada irsaliye irsaliye ilişkisi için EINVOICE_RECEIVING_DETAIL tablosuna SHIP_ID alanı eklendi
Developer: Mahmut Çifçi
Company : Gramoni
Destination: Period -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'EINVOICE_RECEIVING_DETAIL' AND COLUMN_NAME = 'SHIP_ID')
    BEGIN
        ALTER TABLE EINVOICE_RECEIVING_DETAIL ADD SHIP_ID int NULL
    END;
</querytag>