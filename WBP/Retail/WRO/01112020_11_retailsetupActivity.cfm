<!-- Description : Retail setup activty Alanlar
Developer: Pınar Yıldız
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='SETUP_ACTIVITY' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME='IS_OUT')
    BEGIN
        ALTER TABLE SETUP_ACTIVITY ADD 
        [IS_OUT] [bit] NULL,
        [IS_IN] [bit] NULL,
        [CODE] [nvarchar](50) NULL
    END;
</querytag>
