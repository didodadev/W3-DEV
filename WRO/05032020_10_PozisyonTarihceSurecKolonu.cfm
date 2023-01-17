<!-- Description : çalışan Pozisyon tarihçe tablosuna  süreç id kolonu eklendi
Developer: Esma R. Uysal
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEE_POSITIONS_HISTORY' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'POSITION_STAGE')
    BEGIN
        ALTER TABLE EMPLOYEE_POSITIONS_HISTORY ADD
        POSITION_STAGE int NULL;
    END;
</querytag>