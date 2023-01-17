<!-- Description : Fiziki Varlıklar Yedek Parçalar için tablo create kodu
Developer: Dilek Özdemir
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'ASSET_P_PARTS')

    BEGIN
        CREATE TABLE [ASSET_P_PARTS](
            [ASSET_P_PARTS_ID] [int] IDENTITY(1,1) NOT NULL,
            [ASSET_P_ID] [int] NULL,
            [PRODUCT_ID] [int] NULL,
            [STOCK_ID] [int] NULL,
            [CHANGE_PERIOD] [int] NULL,
            [CHANGE_AMOUNT] [int] NULL,
            [SPECT_ID] [int] NULL,
            [RISK_POINT] [int] NULL,
            [QUANTIY] [int] NULL,
            [PRODUCT_UNIT_ID] [int] NULL,
            [DETAIL] [nvarchar](200) NULL,
            [RECORD_DATE] [datetime] NULL,
            [UPDATE_DATE] [datetime] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
            [RECORD_EMP] [int] NULL,
            [UPDATE_EMP] [int] NULL,
        CONSTRAINT [PK_ASSET_P_PARTS] PRIMARY KEY CLUSTERED 
        (
            [ASSET_P_PARTS_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;
</querytag>