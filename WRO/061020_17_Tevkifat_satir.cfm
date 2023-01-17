<!-- Description : Tevkifatın satırda yapılabilmesi için faturaya kolon açıldı.
Developer: Halit Yurttaş
Company : Workcube
Destination: Period -->
<querytag>
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'INVOICE_ROW' AND COLUMN_NAME = 'TEVKIFAT_ID')
    BEGIN
        ALTER TABLE INVOICE_ROW ADD
        TEVKIFAT_ID int NULL
    END;
</querytag>