<!-- Description :CARI_CLOSED Tablosuna CONTRACT_ID alanı eklendi.
Developer: Gülbahar Inan
Company : Workcube
Destination: Period -->
<querytag>
   IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'CARI_CLOSED' AND COLUMN_NAME = 'CONTRACT_ID')
        BEGIN
                ALTER TABLE CARI_CLOSED ADD 
                CONTRACT_ID int NULL
        END;
</querytag>