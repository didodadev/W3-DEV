<!-- Description : Sağlık Teminatı Tipi Sayfasında Tedaviler ve İlaçlar Tab'ları için tablolar oluşturuldu VE Diller Eklendi.
Developer: Melek KOCABEY
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='SETUP_HEALTH_ASSURANCE_TYPE_MEDICATION' AND INFORMATION_SCHEMA.TABLES.TABLE_SCHEMA <> 'dbo' )
    BEGIN
            CREATE TABLE [SETUP_HEALTH_ASSURANCE_TYPE_MEDICATION](
            [MEDICATION_ID] [int] IDENTITY(1,1) NOT NULL,
            [ASSURANCE_ID] [int] NULL,
            [MEDICATION] [nvarchar](250) NULL,
            [PERIOD] [int] NULL,
            [MAX] [int] NULL,
            [NOTE] [nvarchar](250) NULL,
        CONSTRAINT [PK_SETUP_HEALTH_ASSURANCE_TYPE_MEDICATION] PRIMARY KEY CLUSTERED 
        (
            [MEDICATION_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='SETUP_HEALTH_ASSURANCE_TYPE_TREATMENTS' AND INFORMATION_SCHEMA.TABLES.TABLE_SCHEMA <> 'dbo' )
    BEGIN
            CREATE TABLE [SETUP_HEALTH_ASSURANCE_TYPE_TREATMENTS](
            [TREATMENT_ID] [int] IDENTITY(1,1) NOT NULL,
            [ASSURANCE_ID] [int] NULL,
            [TREATMENT] [nvarchar](250) NULL,
            [PERIOD] [int] NULL,
            [MAX] [int] NULL,
            [NOTE] [nvarchar](250) NULL,
        CONSTRAINT [PK_SETUP_HEALTH_ASSURANCE_TYPE_TREATMENTS] PRIMARY KEY CLUSTERED 
        (
            [TREATMENT_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Tedaviler', ITEM_TR='Tedaviler', ITEM_ENG='Treatments' WHERE DICTIONARY_ID = 34925
    UPDATE SETUP_LANGUAGE_TR SET ITEM='Anlaşmalı Kurumlar', ITEM_TR='Anlaşmalı Kurumlar', ITEM_ENG='Contracted Institutions' WHERE DICTIONARY_ID = 34758
</querytag>