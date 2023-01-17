<!-- Description : Ürün Kalite Kontrol Ekranı için PRODUCT_QUALITY_CONTROL_ROW tablosu create kodu

Developer: Dilek Özdemir

Company : Workcube

Destination: Company-->

<querytag>

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'PRODUCT_QUALITY_CONTROL_ROW')


    BEGIN

        CREATE TABLE [PRODUCT_QUALITY_CONTROL_ROW](

            [PRODUCT_QUALITY_CONTROL_ROW_ID] [int] IDENTITY(1,1) NOT NULL,

            [PRODUCT_QUALITY_ID] [int] NULL,

            [PRODUCT_ID] [int] NULL,

            [QUALITY_TYPE_ID] [int] NULL,

            [PRODUCT_QUALITY_CONTROL_TYPE] [nvarchar](200) NULL,

            [SAMPLE_NUMBER] [float] NULL,

            [SAMPLE_METHOD] [int] NULL,

            [MIN_LIMIT] [float] NULL,

            [MAX_LIMIT] [float] NULL,

            [STANDART_VALUE] [float] NULL,

            [CONTROL_OPERATOR] [int] NULL,

            [DESCRIPTION] [nvarchar](200) NULL,

            [RECORD_DATE] [datetime] NULL,

            [UPDATE_DATE] [datetime] NULL,

            [RECORD_IP] [nvarchar](50) NULL,

            [UPDATE_IP] [nvarchar](50) NULL,

            [RECORD_EMP] [int] NULL,

            [UPDATE_EMP] [int] NULL,

        CONSTRAINT [PK_PRODUCT_QUALITY_CONTROL_ROW] PRIMARY KEY CLUSTERED 

        (

            [PRODUCT_QUALITY_CONTROL_ROW_ID] ASC

        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

        ) ON [PRIMARY]

    END;

</querytag>