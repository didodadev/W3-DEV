 <!-- Description : Ödeme Planı tarihçesinde, tarihçeyi daha detaylı tutabilmesi için yeni tablo eklendi.
Developer: Canan Ebret
Company : Workcube
Destination: Company-->
<querytag>
    IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_company_@' and TABLE_NAME='SUBSCRIPTION_PAYMENT_PLAN_ROW_HISTORY_DETAIL')
    BEGIN
    CREATE TABLE [SUBSCRIPTION_PAYMENT_PLAN_ROW_HISTORY_DETAIL](
        [SUBSCRIPTION_PAYMENT_PLAN_ROW_HISTORY_DETAIL_ID] [int] IDENTITY(1,1) NOT NULL,
        [SUBSCRIPTION_PAYMENT_ROW_ID] [int] NULL,
        [SUBSCRIPTION_ID] [int] NULL,
        [STOCK_ID] [int] NULL,
        [PRODUCT_ID] [int] NULL,
        [INVOICE_ID] [int] NULL,
        [PERIOD_ID] [int] NULL,
        [PAYMENT_DATE] [datetime] NULL,
        [PAYMENT_FINISH_DATE] [datetime] NULL,
        [DETAIL] [nvarchar](50) NULL,
        [UNIT] [nvarchar](50) NULL,
        [AMOUNT] [float] NULL,
        [MONEY_TYPE] [nvarchar](43) NULL,
        [ROW_TOTAL] [float] NULL,
        [DISCOUNT] [float] NULL,
        [ROW_NET_TOTAL] [float] NULL,
        [IS_COLLECTED_INVOICE] [bit] NULL,
        [IS_BILLED] [bit] NULL,
        [IS_PAID] [bit] NULL,
        [IS_COLLECTED_PROVISION] [bit] NULL,
        [UNIT_ID] [int] NULL,
        [PAYMETHOD_ID] [int] NULL,
        [CARD_PAYMETHOD_ID] [int] NULL,
        [SUBS_REFERENCE_ID] [int] NULL,
        [IS_GROUP_INVOICE] [bit] NULL,
        [IS_INVOICE_IPTAL] [bit] NULL,
        [DUE_DIFF_ID] [int] NULL,
        [SERVICE_ID] [int] NULL,
        [CALL_ID] [int] NULL,
        [IS_ACTIVE] [bit] NULL,
        [CAMPAIGN_ID] [int] NULL,
        [CARI_ACTION_ID] [int] NULL,
        [CARI_PERIOD_ID] [int] NULL,
        [CARI_ACT_TYPE] [int] NULL,
        [CARI_ACT_TABLE] [nvarchar](50) NULL,
        [CARI_ACT_ID] [int] NULL,
        [QUANTITY] [float] NULL,
        [DISCOUNT_AMOUNT] [float] NULL,
        [CAMP_ID] [int] NULL,
        [RECORD_IP] [nvarchar](50) NULL,
        [UPDATE_EMP] [int] NULL,
        [UPDATE_IP] [nvarchar](50) NULL,
        [UPDATE_DATE] [datetime] NULL,
        [INVOICE_DATE] [datetime] NULL,
        [DUE_DIFF_INVOICE_ID] [int] NULL,
        [DUE_DIFF_PERIOD_ID] [int] NULL,
        [RATE] [int] NULL,
        [HISTORY_ACTION_TYPE] [int] NULL,
        [HISTORY_ACTION_DATE] [datetime] NULL,
        [HISTORY_ACTION_EMP] [int] NULL,
     CONSTRAINT [PK_SUBSCRIPTION_PAYMENT_PLAN_ROW_HISTORY_DETAIL] PRIMARY KEY CLUSTERED 
    (
        [SUBSCRIPTION_PAYMENT_PLAN_ROW_HISTORY_DETAIL_ID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY]
    END

</querytag>