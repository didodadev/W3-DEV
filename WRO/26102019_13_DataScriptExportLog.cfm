<!-- Description : Workdev DB aracında tablo Create/Insert script dosyası export
     ederken, yapılan export işleminin log kayıtlarını tutması için gerekli tablodur.
Developer: Nuri Şahin
Company : Workcube
Destination: Main -->
<querytag>
	IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='DATA_SCRIPT_EXPORT_LOG')
	BEGIN
        CREATE TABLE [DATA_SCRIPT_EXPORT_LOG]
        (
            [ID] INT NOT NULL IDENTITY(1, 1),
            [TABLE_NAME] NVARCHAR(50) NULL,
            [BEST_PRACTICE_ID] INT NULL,
            [BEST_PRACTICE_NAME] NVARCHAR(50) NULL,
            [TYPE] NVARCHAR(50) NULL,
            [HEAD] NVARCHAR(50) NULL,
            [DETAIL] NVARCHAR(150) NULL,
            [DATE] DATETIME NULL,
            [AUTHOR_ID] INT NULL,
            [AUTHOR_NAME] NVARCHAR(50) NULL,
            [CREATE_SCRIPT] NVARCHAR(MAX) NULL,
            [INSERT_SCRIPT] NVARCHAR(MAX) NULL,
            [CREATE_DATE] DATETIME NULL,
            [CREATE_USER_ID] INT NULL,
            [CREATE_USER_IP] NVARCHAR(20) NULL,
            CONSTRAINT [PK_DATA_SCRIPT_EXPORT_LOG]
                PRIMARY KEY ([ID] ASC)
        )
	END;
	
</querytag>