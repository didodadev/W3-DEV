<!-- Description : Üye Bazlı E-Fatura Şablonu Yükleme tablosu
Developer: Mahmut Çifçi
Company : Gramoni
Destination: Company-->
<querytag>

    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_company_@' AND TABLE_NAME = 'EINVOICE_TEMPLATES')
    BEGIN
        CREATE TABLE [EINVOICE_TEMPLATES](
            [TEMPLATE_ID] [int] IDENTITY(1,1) NOT NULL,
            [COMPANY_ID] [int] NULL,
            [CONSUMER_ID] [int] NULL,
            [TEMPLATE_PATH] [nvarchar](250) NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [RECORD_DATE] [datetime] NULL
        ) ON [PRIMARY]
    END;
</querytag>