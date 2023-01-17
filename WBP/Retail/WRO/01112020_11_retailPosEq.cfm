<!-- Description : Retail Pos Alanlar
Developer: Pınar Yıldız
Company : Workcube
Destination: Company -->
<querytag>
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='POS_EQUIPMENT' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME='MALI_NO')
    BEGIN
        ALTER TABLE POS_EQUIPMENT ADD 
        EQUIPMENT_CODE nvarchar(100),
        PATH nvarchar(200),
        OFFLINE_PATH nvarchar(200),
        FILENAME nvarchar(200),
        TYPE nvarchar(200),
        SERIAL_NUMBER nvarchar(200),
         MALI_NO nvarchar(200)
    END;
</querytag>
