<!-- Description : Retail [ORDERS] Alanlar
Developer: Pınar Yıldız
Company : Workcube
Destination: Company -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='ORDERS' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME='ORDER_CODE')
    BEGIN
        ALTER TABLE ORDERS ADD 
        [ORDER_CODE] [nvarchar](50) NULL
    END;
</querytag>
