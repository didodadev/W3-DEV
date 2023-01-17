<!-- Description : Retail [CREDIT_CARD] Alanlar
Developer: Pınar Yıldız
Company : Workcube
Destination: Company -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='CREDIT_CARD' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME='NEXT_PAYMENT_DATE')
    BEGIN
        ALTER TABLE CREDIT_CARD ADD 
        [NEXT_PAYMENT_DATE] [datetime] NULL,
        [NEXT_CLOSE_DATE] [datetime] NULL,
        [CLOSE_DATE] [datetime] NULL,
        [PAYMENT_DATE] [datetime] NULL,
        [EXTRE_VALUE] [float] NULL,
        [MINIMUM_PAYMENT] [float] NULL
    END;
</querytag>
