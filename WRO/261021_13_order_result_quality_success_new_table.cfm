<!-- Description :  Kalite Kontrol İşlemleri Başarım Sonuçları için ORDER_RESULT_QUALITY_SUCCESS_TYPE tablosu create kodu

Developer: Dilek Özdemir

Company : Workcube

Destination: Company-->

<querytag>

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'ORDER_RESULT_QUALITY_SUCCESS_TYPE')


    BEGIN

        CREATE TABLE [ORDER_RESULT_QUALITY_SUCCESS_TYPE](

            [ORDER_RESULT_QUALITY_SUCCESS_TYPE_ID] [int] IDENTITY(1,1) NOT NULL,

            [SUCCESS_ID] [int] NULL,

            [ORDER_RESULT_QUALITY_ID] [int] NULL,

            [AMOUNT] [float] NULL,

            [RECORD_DATE] [datetime] NULL,

            [UPDATE_DATE] [datetime] NULL,

            [RECORD_IP] [nvarchar](50) NULL,

            [UPDATE_IP] [nvarchar](50) NULL,

            [RECORD_EMP] [int] NULL,

            [UPDATE_EMP] [int] NULL,

        CONSTRAINT [PK_ORDER_RESULT_QUALITY_SUCCESS_TYPE] PRIMARY KEY CLUSTERED 

        (

            [ORDER_RESULT_QUALITY_SUCCESS_TYPE_ID] ASC

        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

        ) ON [PRIMARY]

    END;

</querytag>