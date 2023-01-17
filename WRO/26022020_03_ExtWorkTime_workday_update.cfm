<!-- Description : Fazla Mesai Çalışma Günü Alanları
Developer: Yunus Özay
Company : Team Yazılım
Destination: Main -->
<querytag>
    UPDATE
		EMPLOYEES_EXT_WORKTIMES
	SET
		WORK_START_TIME = START_TIME,
		WORK_END_TIME = END_TIME
	WHERE
		WORK_START_TIME IS NULL
</querytag>
