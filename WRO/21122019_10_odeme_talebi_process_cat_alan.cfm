<!--Description : Ödeme Talebi sayfasına işlem kategorisi eklendi CARI_CLOSED tablosu için PROCESS_CAT alan eklendi.
Developer: Canan Ebret
Company : Workcube
Destination: Period-->
<querytag>
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'CARI_CLOSED' AND COLUMN_NAME = 'PROCESS_CAT')
        BEGIN
        ALTER TABLE CARI_CLOSED ADD 
        PROCESS_CAT INT NULL
        END
</querytag>