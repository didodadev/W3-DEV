<!-- Description : Toplu Gelen Havalede İban No alanı eklendi.
Developer: Botan Kaygan
Company : Workcube
Destination: Period -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'BANK_ACTIONS' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME = 'IBAN_NO')
    BEGIN
        ALTER TABLE BANK_ACTIONS ADD
        IBAN_NO nvarchar(50) NULL;
    END;
</querytag>