<!-- Description : Fazla Mesai Çalışma Günü Alanları
Developer: Yunus Özay
Company : Team Yazılım
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'EMPLOYEES_EXT_WORKTIMES' AND COLUMN_NAME = 'WORK_START_TIME')
        BEGIN
			ALTER TABLE EMPLOYEES_EXT_WORKTIMES ADD WORK_START_TIME datetime
		END;
</querytag>
