<!-- Description : Fiziki Varlık Masalar
Developer: Fatih Kara
Company : Workcube
Destination: Main -->
<querytag>
	
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ASSET_P' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'DESK_NO')
    BEGIN
        ALTER TABLE ASSET_P ADD DESK_NO nvarchar(100) NULL
    END;

	IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ASSET_P' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'DESK_CHAIR')
    BEGIN
        ALTER TABLE ASSET_P ADD DESK_CHAIR int NULL
    END;

	IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ASSET_P' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'RELATION_DESKS_ASSETP_ID')
    BEGIN
        ALTER TABLE ASSET_P ADD RELATION_DESKS_ASSETP_ID int NULL
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'ASSET_P_DESKS_GROUP')
    BEGIN
    CREATE TABLE [ASSET_P_DESKS_GROUP](
        [ASSET_P_DESKS_GROUP_ID] [int] IDENTITY(1,1) NOT NULL,
        [DEPARTMENT_ID] [int] NULL,
        [EMPLOYEE_ID] [int] NULL,
        [ASSETP_CATID] [int] NULL,
        [POSITION_CODE] [int] NULL,
        [ASSET_P_SPACE_ID] [int] NULL,
        [RECORD_DATE] datetime NULL,	
        [RECORD_EMP] int NULL,	
        [RECORD_IP] nvarchar(50) NULL
    ) ON [PRIMARY]
    END;

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ASSET_P_SPACE' AND TABLE_SCHEMA = '@_dsn_main_@' AND COLUMN_NAME = 'IS_HORECA')
    BEGIN
        ALTER TABLE ASSET_P_SPACE ADD IS_HORECA bit NULL
    END;
</querytag>