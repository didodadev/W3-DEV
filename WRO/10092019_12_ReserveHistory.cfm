<!-- Description : Sipariş reserveleri history tablosu
Developer: Pınar Yıldız
Company : Workcube
Destination: Company-->
<querytag>
	IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='ORDER_ROW_RESERVED_HISTORY')
    BEGIN
		CREATE TABLE [ORDER_ROW_RESERVED_HISTORY](
		[ROW_RESERVED_HISTORY_ID] [int] IDENTITY(1,1) NOT NULL,
		[ROW_RESERVED_ID] [int] NOT NULL,
		[STOCK_ID] [int] NULL,
		[PRODUCT_ID] [int] NULL,
		[SPECT_VAR_ID] [int] NULL,
		[ORDER_ID] [int] NULL,
		[ORDER_ROW_ID] [int] NULL,
		[SHIP_ID] [int] NULL,
		[INVOICE_ID] [int] NULL,
		[PERIOD_ID] [int] NULL,
		[RESERVE_STOCK_IN] [float] NULL DEFAULT ((0)),
		[RESERVE_STOCK_OUT] [float] NULL DEFAULT ((0)),
		[RESERVE_CANCEL_AMOUNT] [float] NULL DEFAULT ((0)),
		[STOCK_IN] [float] NULL DEFAULT ((0)),
		[STOCK_OUT] [float] NULL DEFAULT ((0)),
		[DEPARTMENT_ID] [int] NULL,
		[LOCATION_ID] [int] NULL,
		[SHELF_NUMBER] [int] NULL,
		[PRE_ORDER_ID] [nvarchar](60) NULL,
		[STOCK_STRATEGY_ID] [int] NULL,
		[IS_BASKET] [int] NULL,
		[ORDER_WRK_ROW_ID] [nvarchar](40) NULL,
	CONSTRAINT [PK_ORDER_ROW_RESERVED_ROW_RESERVED_HISTORY_ID] PRIMARY KEY CLUSTERED 
	(
		[ROW_RESERVED_HISTORY_ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
	END;
</querytag>