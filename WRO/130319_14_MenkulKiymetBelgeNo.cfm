<!-- Description : Menkul Kıymet Alış ve Satış için belge numarası kolonu oluşturuldu
Developer: Esma Uysal
Company : Workcube
Destination: Company-->
<querytag>
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'GENERAL_PAPERS' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'BUYING_SECURITIES_NO')
        BEGIN
                ALTER TABLE GENERAL_PAPERS ADD BUYING_SECURITIES_NO nvarchar(50)
        END;

        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'GENERAL_PAPERS' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'BUYING_SECURITIES_NUMBER')
        BEGIN
                ALTER TABLE GENERAL_PAPERS ADD BUYING_SECURITIES_NUMBER int
        END;
     
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'GENERAL_PAPERS' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'SECURITIES_SALE_NO')
        BEGIN
                ALTER TABLE GENERAL_PAPERS ADD SECURITIES_SALE_NO nvarchar(50)
        END;

        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'GENERAL_PAPERS' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'SECURITIES_SALE_NUMBER')
        BEGIN
                ALTER TABLE GENERAL_PAPERS ADD SECURITIES_SALE_NUMBER int
        END;
</querytag>