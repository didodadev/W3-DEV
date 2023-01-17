<!-- Description : TAX_TYPE tablosu eklendi.
Developer: Melek kocabey
Company : Workcube
Destination: Company -->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'TAX_TYPE' AND TABLE_SCHEMA = '@_dsn_company_@')
    BEGIN
		CREATE TABLE [TAX_TYPE](
        [TAX_TYPE_ID] [int] IDENTITY(1,1) NOT NULL,
        [TAX_TYPE] [nvarchar](100) NULL,
        [TAX_DETAIL] [nvarchar](500) NULL,
        [CALCULATION_TYPE] [nvarchar](500) NULL,
        [TAX_FORMULA] [nvarchar](1000) NULL,
        [RECORD_IP] [nvarchar](43) NULL,
        [RECORD_DATE] [datetime] NULL,
        [RECORD_EMP] [int] NULL,
        [UPDATE_DATE] [datetime] NULL,
        [UPDATE_EMP] [int] NULL,
        [UPDATE_IP] [nvarchar](43) NULL,
    CONSTRAINT [PK_TAX_TYPE] PRIMARY KEY CLUSTERED 
    (
        [TAX_TYPE_ID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]
    END;
    
</querytag>