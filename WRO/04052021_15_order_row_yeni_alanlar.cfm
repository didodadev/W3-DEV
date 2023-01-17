<!-- Description :  ORDER_ROW tablosuna OTV_TYPE ve OTV_DISOCUNT alanları eklendi
Developer: Cemil Durgan
Company : Durgan Bilişim
Destination: Company -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='ORDER_ROW' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME='OTV_TYPE')
    BEGIN
        ALTER TABLE ORDER_ROW
        ADD OTV_TYPE float NULL
    END;
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='ORDER_ROW' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME='OTV_DISCOUNT')
    BEGIN
        ALTER TABLE ORDER_ROW
        ADD OTV_DISCOUNT float NULL
    END;
</querytag>