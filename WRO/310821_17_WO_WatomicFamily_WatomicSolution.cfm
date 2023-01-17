<!-- Description : WO için Watomic Solution ve Watomic Family alanları eklendi.
Developer: Dilek Özdemir
Company : Workcube
Destination: MAIN-->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WRK_OBJECTS' AND COLUMN_NAME = 'WATOMIC_SOLUTION_ID')
    BEGIN
        ALTER TABLE @_dsn_main_@.WRK_OBJECTS ADD
        WATOMIC_SOLUTION_ID int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WRK_OBJECTS' AND COLUMN_NAME = 'WATOMIC_FAMILY_ID')
    BEGIN
        ALTER TABLE @_dsn_main_@.WRK_OBJECTS ADD
        WATOMIC_FAMILY_ID int NULL
    END;
</querytag>