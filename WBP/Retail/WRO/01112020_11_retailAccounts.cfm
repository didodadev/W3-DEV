<!-- Description : Retail [ACCOUNTS] Alanlar
Developer: Pınar Yıldız
Company : Workcube
Destination: Company -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='ACCOUNTS' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME='ACCOUNT_KMH_LIMIT')
    BEGIN
        ALTER TABLE ACCOUNTS ADD 
        [ACCOUNT_KMH_LIMIT] [float] NULL
    END;
</querytag>
