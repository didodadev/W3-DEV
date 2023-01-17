<!--Description : Gümrük-ihracat İşlemleri Tablosu 
Developer: Melek KOCABEY
Company : Workcube
Destination: Company-->
<querytag>
    IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='CUSTOM_DECLERATION')
    BEGIN
        CREATE TABLE [CUSTOM_DECLERATION](
        [CUSTOM_DECLERATION_ID] [int] IDENTITY(1,1) NOT NULL,
        [PERIOD_ID] [int] NULL,
        [INVOICE_ID] [int] NULL,
        [DECLERATION_NO] [nvarchar](100) NULL,
        [INVOICE_PAPER_NO] [nvarchar](100) NULL,
        [REGIME] [int] NULL,
        [FINANCIAL_RESPONSIBLE_COMPANY] [int] NULL,
        [DECLERATION_COMPANY] [int] NULL,
        [FIRST_DESTINATION_COUNTRY] [int] NULL,
        [TRADER_COUNTRY] [int] NULL,
        [EXPORTER_COUNTRY] [int] NULL,
        [EXPORTER_ZONE] [int] NULL,
        [FINAL_DESTINATION_COUNTRY] [int] NULL,
        [FINAL_DESTINATION_ZONE] [int] NULL,
        [DECLERATION_CATEGORY] [int] NULL,
        [REFERENCE_NO] [nvarchar](250) NULL,
        [TRANSPORT_VEHICLE_CODE] [int] NULL,
        [TRANSPORT_VEHICLE_INFO] [nvarchar](500) NULL,
        [TRANSPORT_VEHICLE_CONTRY] [int] NULL,
        [CONTAINER_TYPE] [int] NULL,
        [GROSS_KG] [float] NULL,
        [NET_KG] [float] NULL,
        [DELIVERY_CODE] [int] NULL,
        [DELIVERY_ADRESS] [nvarchar](500) NULL,
        [OUTLAND_VEHICLE_CODE] [int] NULL,
        [OUTLAND_VEHICLE_COUNTRY] [int] NULL,
        [OUTLAND_VEHICLE_INFO] [nvarchar](500) NULL,
        [CONTRATCT_TYPE] [int] NULL,
        [OUTLAND_TRANSPORT_TYPE] [int] NULL,
        [DOMESTIC_TRANSPORT_TYPE] [int] NULL,
        [LOADING_PLACE] [nvarchar](250) NULL,
        [EXIT_CUSTOM_OFFICE] [int] NULL,
        [GOODS_PLACE] [int] NULL,
        [UNBONDED_WAREHOUSE] [int] NULL,
        [CUSTOM_BROKER] [int] NULL,
        [TRANSPORT_COST] [float] NULL,
        [TRANSPORT_COST_MONEY_TYPE] [nvarchar](25) NULL,
        [DOMESTIC_COST] [float] NULL,
        [DOMESTIC_COST_MONEY_TYPE] [nvarchar](25) NULL,
        [ASSURANCE_COST] [float] NULL,
        [ASSURANCE_COST_MONEY_TYPE] [nvarchar](25) NULL,
        [OUTLAND_COST] [float] NULL,
        [OUTLAND_COST_MONEY_TYPE] [nvarchar](25) NULL,
        [TOTAL_COST_SYTEM] [float] NULL,
        [TOTAL_COST_OTHER_MONEY] [float] NULL,
        [TOTAL_COST_MONEY_TYPE] [nvarchar](25) NULL,
        [LOADING_LIST] [nvarchar](500) NULL,
        [DECLERATION_DATE] [datetime] NULL,
        [APPROVE_DATE] [datetime] NULL,
        [CLOSED_DATE] [datetime] NULL,
        [RECORD_DATE] [datetime] NULL,
        [RECORD_IP] [nvarchar](43) NULL,
        [RECORD_EMP] [int] NULL,
        [UPDATE_DATE] [datetime] NULL,
        [UPDATE_IP] [nvarchar](43) NULL,
        [UPDATE_EMP] [int] NULL,
        [INVOICE_COST] [float] NULL,
        [INVOICE_COST_MONEY_TYPE] [nvarchar](25) NULL,
        [DECLERATION_DETAIL] [nvarchar](500) NULL,
        [DECLERATION_BUYER] [int] NULL,
        [FARM_POLICY] [nvarchar](500) NULL,
        [DECLARATION] [nvarchar](25) NULL,
    CONSTRAINT [PK__CUSTOM_D__C34CD0E0CC86CE2B] PRIMARY KEY CLUSTERED 
    (
        [CUSTOM_DECLERATION_ID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]
    END;
</querytag>