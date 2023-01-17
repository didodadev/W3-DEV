<!-- Description : Seri no tablosuna birim tipi eklendi
Developer: Pınar Yıldız
Company : Workcube
Destination: Company -->
<querytag>
    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'SERVICE_GUARANTY_NEW' AND COLUMN_NAME = 'UNIT_TYPE')
    BEGIN
        ALTER TABLE SERVICE_GUARANTY_NEW ADD
        UNIT_TYPE bit NULL
    END;
</querytag>