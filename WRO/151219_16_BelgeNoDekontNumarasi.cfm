<!-- Description : Şirket Belge numaralarına dekont no alanı eklendi.
Developer: Tolga SÜTLÜ
Company : Devonomy
Destination: Company -->
<querytag>
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'GENERAL_PAPERS' AND COLUMN_NAME = 'RECEIPT_NO')
        BEGIN
        ALTER TABLE GENERAL_PAPERS ADD 
        RECEIPT_NO nvarchar(50) NULL
        END;

        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'GENERAL_PAPERS' AND COLUMN_NAME = 'RECEIPT_NUMBER')
        BEGIN
        ALTER TABLE GENERAL_PAPERS ADD 
        RECEIPT_NUMBER int NULL
        END;
</querytag>