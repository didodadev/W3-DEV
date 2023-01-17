<!-- Description :  Satış siparişleri ekranında ORDER_ROW tablosuna GTIP_NUMBER alanı açıldı. 
Developer: Melek KOCABEY
Company : Workcube
Destination: Company -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='ORDER_ROW' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME='GTIP_NUMBER')
    BEGIN
        ALTER TABLE ORDER_ROW ADD 
        GTIP_NUMBER nvarchar(50) NULL
    END;
</querytag>