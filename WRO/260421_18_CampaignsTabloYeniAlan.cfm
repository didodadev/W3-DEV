
<!-- Description :CAMPAIGNS tablosuna yeni alan eklendi
Developer: Fatma Zehra Dere
Company : Workcube
Destination: Company -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CAMPAIGNS' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME = 'USER_FRIENDLY_URL')
    BEGIN
        ALTER TABLE CAMPAIGNS ADD 
		USER_FRIENDLY_URL nvarchar(250) NULL 
    END;
</querytag>