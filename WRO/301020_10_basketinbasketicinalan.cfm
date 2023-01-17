<!-- Description : order_pre_rows a unique_id alanı eklendi
Developer: ilker altındal
Company : Workcube
Destination: Company -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='ORDER_PRE_ROWS' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME='UNIQUE_ID')
    BEGIN
        ALTER TABLE ORDER_PRE_ROWS ADD 
        UNIQUE_ID nvarchar(500) NULL
    END;
</querytag>