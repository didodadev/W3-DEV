<!-- Description : Seri no tablosuna 1. birim miktarı eklendi.
Developer: Esma Uysal
Company : Workcube
Destination: Company -->
<querytag>
    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'SERVICE_GUARANTY_NEW' AND COLUMN_NAME = 'UNIT_ROW_QUANTITY')
    BEGIN
        ALTER TABLE SERVICE_GUARANTY_NEW ADD
        UNIT_ROW_QUANTITY float NULL
    END;
</querytag>