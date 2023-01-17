<!--Description : Çalışan yakını Süreç Alanı
Developer: Alper Çitmen
Company : Workcube
Destination: Main-->
<querytag>
	    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'EMPLOYEES_RELATIVES' AND COLUMN_NAME = 'PROCESS_STAGE')
        BEGIN
                ALTER TABLE EMPLOYEES_RELATIVES ADD 
                PROCESS_STAGE  int NULL
        END;
</querytag>