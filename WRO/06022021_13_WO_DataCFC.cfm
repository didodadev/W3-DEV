<!-- Description : WO için Data CFC tanımı eklendi
Developer: Halit Yurttaş
Company : Workcube
Destination: MAIN-->
<querytag>
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WRK_OBJECTS' AND COLUMN_NAME = 'DATA_CFC')
        BEGIN
        ALTER TABLE @_dsn_main_@.WRK_OBJECTS ADD
	DATA_CFC nvarchar(250) NULL
        END;
</querytag>