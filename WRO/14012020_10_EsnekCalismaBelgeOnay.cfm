<!-- Description : Esnek çalışma saatlerine 1. ve 2. amir onay eklendi.
Developer: Esma Uysal
Company : Workcube
Destination: Main-->
<querytag>   
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='WORKTIME_FLEXIBLE' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME='APPROVE_EMP_ID_1')
    BEGIN
        ALTER TABLE WORKTIME_FLEXIBLE  
		ADD APPROVE_EMP_ID_1 int NULL
    END;
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='WORKTIME_FLEXIBLE' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME='APPROVE_EMP_ID_2')
    BEGIN
        ALTER TABLE WORKTIME_FLEXIBLE  
		ADD APPROVE_EMP_ID_2 int NULL
    END;
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='WORKTIME_FLEXIBLE' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME='IS_APPROVE_1')
    BEGIN
        ALTER TABLE WORKTIME_FLEXIBLE  
		ADD IS_APPROVE_1 bit NULL
    END;
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='WORKTIME_FLEXIBLE' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME='IS_APPROVE_2')
    BEGIN
        ALTER TABLE WORKTIME_FLEXIBLE  
		ADD IS_APPROVE_2 bit NULL
    END;
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='WORKTIME_FLEXIBLE' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME='APPROVE_HR_EMP_ID')
    BEGIN
        ALTER TABLE WORKTIME_FLEXIBLE  
		ADD APPROVE_HR_EMP_ID int NULL
    END;
    IF NOT EXISTS(SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='WORKTIME_FLEXIBLE' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME='IS_APPROVE')
    BEGIN
        ALTER TABLE WORKTIME_FLEXIBLE  
		ADD IS_APPROVE bit NULL
    END;
</querytag>