<!-- Description :  add new columns to WRK_LICENSE table
Developer: Uğur Hamurpet
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WRK_LICENSE' AND COLUMN_NAME = 'OWNER_COMPANY_ID')
    BEGIN
        ALTER TABLE WRK_LICENSE ADD
        OWNER_COMPANY_ID int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WRK_LICENSE' AND COLUMN_NAME = 'IMPLEMENTATION_PROJECT_ID')
    BEGIN
        ALTER TABLE WRK_LICENSE ADD
        IMPLEMENTATION_PROJECT_ID int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WRK_LICENSE' AND COLUMN_NAME = 'TECHNICAL_PERSON_ID')
    BEGIN
        ALTER TABLE WRK_LICENSE ADD
        TECHNICAL_PERSON_ID nvarchar(50) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WRK_LICENSE' AND COLUMN_NAME = 'TECHNICAL_PERSON_EMPLOYEE_ID')
    BEGIN
        ALTER TABLE WRK_LICENSE ADD
        TECHNICAL_PERSON_EMPLOYEE_ID nvarchar(50) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WRK_LICENSE' AND COLUMN_NAME = 'TECHNICAL_PERSON_EMPLOYEE_TITLE')
    BEGIN
        ALTER TABLE WRK_LICENSE ADD
        TECHNICAL_PERSON_EMPLOYEE_TITLE nvarchar(200) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WRK_LICENSE' AND COLUMN_NAME = 'IMPLEMENTATION_POWER_USER_ID')
    BEGIN
        ALTER TABLE WRK_LICENSE ADD
        IMPLEMENTATION_POWER_USER_ID nvarchar(50) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WRK_LICENSE' AND COLUMN_NAME = 'IMPLEMENTATION_POWER_USER_EMPLOYEE_ID')
    BEGIN
        ALTER TABLE WRK_LICENSE ADD
        IMPLEMENTATION_POWER_USER_EMPLOYEE_ID nvarchar(50) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WRK_LICENSE' AND COLUMN_NAME = 'IMPLEMENTATION_POWER_USER_EMPLOYEE_TITLE')
    BEGIN
        ALTER TABLE WRK_LICENSE ADD
        IMPLEMENTATION_POWER_USER_EMPLOYEE_TITLE nvarchar(200) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WRK_LICENSE' AND COLUMN_NAME = 'WORKCUBE_PARTNER_COMPANY_ID')
    BEGIN
        ALTER TABLE WRK_LICENSE ADD
        WORKCUBE_PARTNER_COMPANY_ID nvarchar(50) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WRK_LICENSE' AND COLUMN_NAME = 'WORKCUBE_PARTNER_COMPANY_TEAM_ID')
    BEGIN
        ALTER TABLE WRK_LICENSE ADD
        WORKCUBE_PARTNER_COMPANY_TEAM_ID nvarchar(50) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WRK_LICENSE' AND COLUMN_NAME = 'WORKCUBE_PARTNER_COMPANY_TEAM')
    BEGIN
        ALTER TABLE WRK_LICENSE ADD
        WORKCUBE_PARTNER_COMPANY_TEAM nvarchar(200) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WRK_LICENSE' AND COLUMN_NAME = 'WORKCUBE_SUPPORT_TEAM_ID')
    BEGIN
        ALTER TABLE WRK_LICENSE ADD
        WORKCUBE_SUPPORT_TEAM_ID nvarchar(50) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WRK_LICENSE' AND COLUMN_NAME = 'OWNER_COMPANY_EMAIL')
    BEGIN
        ALTER TABLE WRK_LICENSE ADD
        OWNER_COMPANY_EMAIL nvarchar(50) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WRK_LICENSE' AND COLUMN_NAME = 'TEL')
    BEGIN
        ALTER TABLE WRK_LICENSE ADD
        TEL nvarchar(200) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WRK_LICENSE' AND COLUMN_NAME = 'EMAIL')
    BEGIN
        ALTER TABLE WRK_LICENSE ADD
        EMAIL nvarchar(200) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WRK_LICENSE' AND COLUMN_NAME = 'LICENSE_TYPE')
    BEGIN
        ALTER TABLE WRK_LICENSE ADD
        LICENSE_TYPE int NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WRK_LICENSE' AND COLUMN_NAME = 'RELEASE_NO')
    BEGIN
        ALTER TABLE WRK_LICENSE ADD
        RELEASE_NO nvarchar(30) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WRK_LICENSE' AND COLUMN_NAME = 'RELEASE_DATE')
    BEGIN
        ALTER TABLE WRK_LICENSE ADD
        RELEASE_DATE datetime NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WRK_LICENSE' AND COLUMN_NAME = 'GIT_URL')
    BEGIN
        ALTER TABLE WRK_LICENSE ADD
        GIT_URL nvarchar(200) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WRK_LICENSE' AND COLUMN_NAME = 'GIT_DIR')
    BEGIN
        ALTER TABLE WRK_LICENSE ADD
        GIT_DIR nvarchar(200) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WRK_LICENSE' AND COLUMN_NAME = 'GIT_BRANCH')
    BEGIN
        ALTER TABLE WRK_LICENSE ADD
        GIT_BRANCH nvarchar(200) NULL
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'WRK_LICENSE' AND COLUMN_NAME = 'PARAMS')
    BEGIN
        ALTER TABLE WRK_LICENSE ADD
        PARAMS nvarchar(MAX) NULL
    END;
</querytag>