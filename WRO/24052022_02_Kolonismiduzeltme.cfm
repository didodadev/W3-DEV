<!-- Description : Kolon ismi duzeltme
Developer: Fatih Kara
Company : Workcube
Destination: Main -->
<querytag>  
    IF EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'BRANCH' AND COLUMN_NAME = N'ACC_UNİT_CODE')
    BEGIN
		EXEC sp_rename N'BRANCH.ACC_UNİT_CODE', N'ACC_UNIT_CODE', N'COLUMN';
    END;
</querytag>