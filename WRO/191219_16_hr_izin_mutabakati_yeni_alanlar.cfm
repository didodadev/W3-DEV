<!-- Description : HR izin mutabakatı için tabloya yeni alanlar eklendi
Developer: Semih AKARTUNA
Company : Yazılımsa
Destination: Main -->
<querytag> 
        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES_OFFTIME_CONTRACT' AND COLUMN_NAME = 'OFFTIME_DETAIL')
        BEGIN
                ALTER TABLE EMPLOYEES_OFFTIME_CONTRACT ADD 
                OFFTIME_DETAIL nvarchar(250) NULL
        END;

        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES_OFFTIME_CONTRACT' AND COLUMN_NAME = 'IS_APPROVE')
        BEGIN
                ALTER TABLE EMPLOYEES_OFFTIME_CONTRACT ADD 
                IS_APPROVE bit NULL
        END;

        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES_OFFTIME_CONTRACT' AND COLUMN_NAME = 'IS_MAIL')
        BEGIN
                ALTER TABLE EMPLOYEES_OFFTIME_CONTRACT ADD 
                IS_MAIL bit NULL
        END;

        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES_OFFTIME_CONTRACT' AND COLUMN_NAME = 'EX_SAL_YEAR_REMAINDER_DAY')
        BEGIN
                ALTER TABLE EMPLOYEES_OFFTIME_CONTRACT ADD 
                EX_SAL_YEAR_REMAINDER_DAY float NULL
        END;

        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES_OFFTIME_CONTRACT' AND COLUMN_NAME = 'EX_SAL_YEAR_OFTIME_DAY')
        BEGIN
                ALTER TABLE EMPLOYEES_OFFTIME_CONTRACT ADD 
                EX_SAL_YEAR_OFTIME_DAY float NULL
        END;

        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES_OFFTIME_CONTRACT' AND COLUMN_NAME = 'SAL_YEAR_REMAINDER_DAY')
        BEGIN
                ALTER TABLE EMPLOYEES_OFFTIME_CONTRACT ADD 
                SAL_YEAR_REMAINDER_DAY float NULL
        END;

        IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EMPLOYEES_OFFTIME_CONTRACT' AND COLUMN_NAME = 'SAL_YEAR_OFTIME_DAY')
        BEGIN
                ALTER TABLE EMPLOYEES_OFFTIME_CONTRACT ADD 
                SAL_YEAR_OFTIME_DAY float NULL
        END;
</querytag>