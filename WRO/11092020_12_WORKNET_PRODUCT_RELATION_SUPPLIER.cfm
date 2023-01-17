<!-- Description : WORKNET_PRODUCT_RELATION_SUPPLIER tablosu oluşturuldu.
Developer: Emine Yılmaz
Company : Workcube
Destination: main -->
<querytag>
    IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_main_@' and TABLE_NAME='WORKNET_PRODUCT_RELATION_SUPPLIER')
    BEGIN
        CREATE TABLE [WORKNET_PRODUCT_RELATION_SUPPLIER](
            [RELATION_ID] [int] IDENTITY(1,1) NOT NULL,
            [WORKNET_PRODUCT_ID] [int] NULL,
            [COMPANY_ID] [int] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
        CONSTRAINT [PK_WORKNET_PRODUCT_RELATION_SUPPLIER] PRIMARY KEY CLUSTERED 
        (
            [RELATION_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;
</querytag>