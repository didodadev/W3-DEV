<!-- Description : fazla mesailerim sayfasın da kullanılabilmesi için EMPLOYEES_EXT_WORKTIMES tablosuna PROCESS_STAGE, WORKTIME_WAGE_STATUS, WORKING_SPACE tablosuna alanlar eklendi.
Developer: Canan Ebret
Company : Workcube
Destination: Main -->
<querytag>
    
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EMPLOYEES_EXT_WORKTIMES' AND COLUMN_NAME='PROCESS_STAGE')
    BEGIN
        ALTER TABLE EMPLOYEES_EXT_WORKTIMES ADD
        PROCESS_STAGE int NULL
    END;
    
    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EMPLOYEES_EXT_WORKTIMES' AND COLUMN_NAME='WORKTIME_WAGE_STATU')
    BEGIN
        ALTER TABLE EMPLOYEES_EXT_WORKTIMES ADD
        WORKTIME_WAGE_STATU int NULL
    END;

    IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='EMPLOYEES_EXT_WORKTIMES' AND COLUMN_NAME='WORKING_SPACE')
    BEGIN
        ALTER TABLE EMPLOYEES_EXT_WORKTIMES ADD
        WORKING_SPACE int NULL
    END  

</querytag>
