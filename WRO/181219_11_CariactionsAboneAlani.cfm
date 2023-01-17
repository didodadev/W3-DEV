<!-- Description : Cari Actions tablosuna abone alanı açıldı
Developer: Pınar Yıldız
Company : Workcube
Destination: Period -->
<querytag>
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_period_@' AND TABLE_NAME = 'CARI_ACTIONS' AND COLUMN_NAME = 'TO_SUBSCRIPTION_ID')
        BEGIN
                ALTER TABLE CARI_ACTIONS 
                ADD TO_SUBSCRIPTION_ID INT NULL
        END;
</querytag>