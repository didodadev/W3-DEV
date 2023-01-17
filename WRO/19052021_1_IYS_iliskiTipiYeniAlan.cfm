<!-- Description : COMPANY_PARTNER_RESOURCE Tablosuna Yeni Alanlar Eklendi.
Developer: Emin Yaşartürk
Company : Startech BT
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'COMPANY_PARTNER_RESOURCE'  AND COLUMN_NAME = 'IYS_INFO')
    BEGIN
        ALTER TABLE COMPANY_PARTNER_RESOURCE ADD
        IYS_INFO nvarchar(250) NULL
    END;
</querytag>