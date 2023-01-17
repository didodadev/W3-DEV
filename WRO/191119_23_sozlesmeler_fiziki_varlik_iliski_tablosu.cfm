<!-- Description : Sözleşmeler fiziki varlık ilişki tablosu
Developer: Mahmut Çifçi
Company : Gramoni
Destination: Main-->
<querytag>
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='RELATION_PHYSICAL_ASSET_CONTRACT' )
    BEGIN
        CREATE TABLE [RELATION_PHYSICAL_ASSET_CONTRACT](
            [RELATION_ID] [int] IDENTITY(1,1) NOT NULL,
            [CONTRACT_ID] [int] NULL,
            [ASSETP_ID] [int] NULL,
            [OUR_COMPANY_ID] [int] NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL
        CONSTRAINT [PK_RELATION_PHYSICAL_ASSET_CONTRACT] PRIMARY KEY CLUSTERED 
        (
            [RELATION_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;
</querytag>