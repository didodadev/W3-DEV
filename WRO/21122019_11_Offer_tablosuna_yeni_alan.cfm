<!-- Description : OFFER tablosuna PROCESS_CAT alanı açıldı
Developer: Canan Ebret
Company : Workcube
Destination: Company -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'OFFER' AND COLUMN_NAME = 'PROCESS_CAT' )
    BEGIN
        ALTER TABLE OFFER ADD PROCESS_CAT INT NULL 
    END
</querytag>