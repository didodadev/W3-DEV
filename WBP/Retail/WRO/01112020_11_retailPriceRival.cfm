<!-- Description : Retail [PRICE_RIVAL] Alanlar
Developer: Pınar Yıldız
Company : Workcube
Destination: Company -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='PRICE_RIVAL' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME='TABLE_CODE')
    BEGIN
        ALTER TABLE PRICE_RIVAL ADD 
        [PRICE_TYPE] [int] NULL,
        [PRICE_2] [float] NULL,
        [DATE_EDIT] [bit] NULL,
        [TABLE_CODE] [nvarchar](50) NULL
    END;
</querytag>
