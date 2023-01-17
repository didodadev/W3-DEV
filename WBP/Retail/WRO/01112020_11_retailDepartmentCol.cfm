<!-- Description : Retail Product Alanlar
Developer: Pınar Yıldız
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='DEPARTMENT' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME='POINT_MULTIPLIER')
    BEGIN
        ALTER TABLE DEPARTMENT ADD 
        [POINT_MULTIPLIER] [float] NULL
    END;
</querytag>
