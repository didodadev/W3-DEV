<!-- Description :  Satış tekliflerinin teslim şartı alanını tutması ve güncellemesi için DELIVERY_CONDITION alanı açıldı. 
Developer: Yücel Aydın
Company : Mifa Bilgi Sistemleri
Destination: Company -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='OFFER_ROW' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME='DELIVERY_CONDITION')
    BEGIN
        ALTER TABLE OFFER_ROW ADD 
        DELIVERY_CONDITION nvarchar(50) NULL
    END;
</querytag>