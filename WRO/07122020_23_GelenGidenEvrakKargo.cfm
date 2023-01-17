<!-- Description : Gelen-Giden Evrak ve Kargo İşlemleri sayfası scripti.
Developer: Fatma Zehra Dere
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='PAPER_CARGO_COURIER' )
    BEGIN
        CREATE TABLE [PAPER_CARGO_COURIER](
            [CARGO_ID] [int] IDENTITY(1,1) NOT NULL,
            [COMING_OUT] [int] NULL,
            [DOCUMENT_REGISTRATION_NO] [nvarchar](50) NULL,
            [DATE_REGISTRATION] [datetime] NULL,
            [SENDER_ID] [int] NULL,
            [RECEIVER_ID] [int] NULL,
            [DOCUMENT_NO] [nvarchar](50) NULL,
            [SENDER_DATE] [datetime] NULL,
            [DELIVERY_DATE] [datetime] NULL,
            [PAYMENT_METHOD] [bit] NULL,
            [CARGO_PRICE] [float] NULL,
            [MONEY_TYPE] [nvarchar](43) NULL,
            [CARRIER_COMPANY_ID] [int] NULL,
            [CARRIER_PARTNER_ID] [int] NULL,
            [DETAIL] [nvarchar](max) NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
            [DOCUMENT_TYPE] [int] NULL,
            [SENDER_COMP_ID] [int] NULL,
            [CARGO_FILE] [nvarchar](250) NULL,
            [CARGO_FILE_SERVER_ID] [nvarchar](200) NULL,
        CONSTRAINT [PK_PAPER_CARGO_COURIER] PRIMARY KEY CLUSTERED 
        (
            [CARGO_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    END;
       
        
</querytag>