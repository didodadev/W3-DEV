<!-- Description : Retail Ship Internal Code Alanı
Developer: Pınar Yıldız
Company : Workcube
Destination: Period -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='SHIP_INTERNAL' AND TABLE_SCHEMA = '@_dsn_period_@' AND COLUMN_NAME='CODE')
    BEGIN
        ALTER TABLE SHIP_INTERNAL ADD 
        [CODE] [nvarchar](50) NULL
    END;
</querytag>
