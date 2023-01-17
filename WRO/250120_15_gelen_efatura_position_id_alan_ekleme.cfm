<!-- Description : Gelen efatura listeleme sayfasına yalnızca pozisyon id ye atanmış faturaları listenebilmesi için alan eklendi.
Developer: Mahmut Çifçi
Company : Gramoni
Destination: Period -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'EINVOICE_RECEIVING_DETAIL' AND COLUMN_NAME = 'POSITION_IDS')
    BEGIN
        ALTER TABLE EINVOICE_RECEIVING_DETAIL ADD POSITION_IDS [nvarchar](50) NULL
    END;
</querytag>