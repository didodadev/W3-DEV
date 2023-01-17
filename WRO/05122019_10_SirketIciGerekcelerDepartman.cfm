<!-- Description : Şirket içi gerekçeler tabosuna departman kolonu eklendi. ÇAlışan Yakını tarihçe tablosu eklendi.Eğitim ve işlere öğrenim yılı ve süresi eklendi
Developer: Esma Uysal
Company : Workcube
Destination: MAin-->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'SETUP_EMPLOYEE_FIRE_REASONS' AND COLUMN_NAME = 'IS_DEPARTMENT')
    BEGIN
        ALTER TABLE SETUP_EMPLOYEE_FIRE_REASONS ADD 
        IS_DEPARTMENT bit NULL
        
        ALTER TABLE DEPARTMENT ADD 
        IN_COMPANY_REASON_ID int NULL
        
        ALTER TABLE DEPARTMENT_HISTORY ADD 
        IN_COMPANY_REASON_ID int NULL
    END
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'EMPLOYEES_RELATIVES_HISTORY')
    BEGIN
        CREATE TABLE [EMPLOYEES_RELATIVES_HISTORY](
            [RELATIVE_ID] [int] IDENTITY(1,1) NOT NULL,
            [EMPLOYEE_ID] [int] NULL,
            [EMPAPP_ID] [int] NULL,
            [NAME] [nvarchar](50) NULL,
            [SURNAME] [nvarchar](50) NULL,
            [SEX] [bit] NULL,
            [RELATIVE_LEVEL] [nvarchar](50) NULL,
            [BIRTH_DATE] [datetime] NULL,
            [BIRTH_PLACE] [nvarchar](50) NULL,
            [EDUCATION_OLD] [nvarchar](43) NULL,
            [JOB] [nvarchar](43) NULL,
            [COMPANY] [nvarchar](50) NULL,
            [JOB_POSITION] [nvarchar](43) NULL,
            [EDUCATION] [int] NULL,
            [EDUCATION_STATUS] [bit] NULL,
            [RECORD_DATE] [datetime] NULL DEFAULT (getdate()),
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
            [TC_IDENTY_NO] [nvarchar](50) NULL,
            [WORK_STATUS] [bit] NULL,
            [DISCOUNT_STATUS] [bit] NULL,
            [DETAIL] [nvarchar](250) NULL,
            [EDUCATION_SCHOOL_NAME] [nvarchar](100) NULL,
            [EDUCATION_CLASS_NAME] [nvarchar](100) NULL,
            [EDUCATION_RECORD_DATE] [datetime] NULL,
            [MARRIAGE_DATE] [datetime] NULL,
            [VALIDITY_DATE] [datetime] NULL,
            [CHILD_HELP] [bit] NULL,
            [IS_MARRIED] [bit] NULL,
            [DISABLED_RELATIVE] [bit] NULL,
            [CORPORATION_EMPLOYEE] [bit] NULL,
            [IS_RETIRED] [bit] NULL,
        CONSTRAINT [PK_EMPLOYEES_RELATIVES_HISTORY_RELATIVE_ID] PRIMARY KEY CLUSTERED 
        (
            [RELATIVE_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'EMPLOYEES_APP_EDU_INFO' AND COLUMN_NAME = 'EDUCATION_LANG')
    BEGIN
        ALTER TABLE EMPLOYEES_APP_EDU_INFO ADD 
        EDUCATION_LANG nvarchar(MAX) NULL
        
        ALTER TABLE EMPLOYEES_APP_EDU_INFO ADD 
        EDUCATION_TIME int NULL
       
    END
</querytag>

