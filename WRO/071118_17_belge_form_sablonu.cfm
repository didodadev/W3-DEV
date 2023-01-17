<!-- Description : Belge form şablonunda kayıt ekleyen ve güncelleyen kişi bilgilerinin tutulması için alanlar eklendi.
Developer: İlker Altındal
Company : Workcube
Destination: Main -->
<querytag>
    IF EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='TEMPLATE_FORMS' AND INFORMATION_SCHEMA.TABLES.TABLE_SCHEMA <> 'dbo' )
    BEGIN
        IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='TEMPLATE_FORMS' AND COLUMN_NAME='RECORD_DATE')
        BEGIN
        ALTER TABLE TEMPLATE_FORMS ADD RECORD_DATE datetime
        END;

        IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='TEMPLATE_FORMS' AND COLUMN_NAME='UPDATE_DATE')
        BEGIN
        ALTER TABLE TEMPLATE_FORMS ADD UPDATE_DATE datetime
        END;
        
        IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='TEMPLATE_FORMS' AND COLUMN_NAME='UPDATE_EMP')
        BEGIN
        ALTER TABLE TEMPLATE_FORMS ADD UPDATE_EMP int
        END;
        
        IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='TEMPLATE_FORMS' AND COLUMN_NAME='RECORD_EMP')
        BEGIN
        ALTER TABLE TEMPLATE_FORMS ADD RECORD_EMP int
        END;

        IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='TEMPLATE_FORMS' AND COLUMN_NAME='UPDATE_IP')
        BEGIN
        ALTER TABLE TEMPLATE_FORMS ADD UPDATE_IP nvarchar(50)
        END;
        
        IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='TEMPLATE_FORMS' AND COLUMN_NAME='RECORD_IP')
        BEGIN
        ALTER TABLE TEMPLATE_FORMS ADD RECORD_IP nvarchar(50)
        END;
    END
    ELSE 
    BEGIN
        CREATE TABLE [TEMPLATE_FORMS](
            [TEMPLATE_ID] [int] IDENTITY(1,1) NOT NULL,
            [TEMPLATE_HEAD] [nvarchar](250) NULL,
            [TEMPLATE_MODULE] [int] NULL,
            [TEMPLATE_CONTENT] [nvarchar](max) NULL,
            [IS_PURSUIT_TEMPLATE] [bit] NULL,
            [IS_LOGO] [bit] NULL,
            [IS_LICENCE] [bit] NULL,
            [RECORD_DATE] [datetime] NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [RECORD_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
            [RECORD_IP] [nvarchar](50) NULL,
        CONSTRAINT [PK_TEMPLATE_FORMS_TEMPLATE_ID] PRIMARY KEY CLUSTERED 
        (
            [TEMPLATE_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

    END;

    </querytag>