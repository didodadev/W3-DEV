<!-- Description : Plevne IAM için SUBSCRIPTION_IAM tablosu create kodu
Developer: Dilek Özdemir
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_main_@' AND TABLE_NAME = 'SUBSCRIPTION_IAM')

    BEGIN
        CREATE TABLE [SUBSCRIPTION_IAM](
            [IAM_ID] [int] IDENTITY(1,1) NOT NULL,
            [SUBSCRIPTION_ID] [int] NULL,
            [SUBSCRIPTION_NO] [nvarchar](200) NULL,
            [IAM_ACTIVE] [bit] NULL,
            [IAM_USER_NAME] [nvarchar](200) NULL,
            [IAM_NAME] [nvarchar](200) NULL,
            [IAM_SURNAME] [nvarchar](200) NULL,
            [IAM_PASSWORD] [nvarchar](200) NULL,
            [IAM_EMAIL_FIRST] [nvarchar](200) NULL,
            [IAM_EMAİL_SECOND] [nvarchar](200) NULL,
            [IAM_MOBILE_CODE] [nvarchar](20) NULL,
            [IAM_MOBILE_NUMBER] [nvarchar](20) NULL,
            [IAM_USER_COMPANY_NAME] [nvarchar](200) NULL,
            [COMPANY_PARTNER_ID] [int] NULL,
            [REFERRAL_DOMAIN] [nvarchar](200) NULL,
            [RECORD_DATE] [datetime] NULL,
            [UPDATE_DATE] [datetime] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
            [RECORD_EMP] [int] NULL,
            [UPDATE_EMP] [int] NULL,
        CONSTRAINT [PK_SUBSCRIPTION_IAM] PRIMARY KEY CLUSTERED 
        (
            [IAM_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;
</querytag>