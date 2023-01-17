<!-- Description : Şirketler History Tablosu oluşturuldu. Şirket tablosundaki datalar history'e aktarıldı.
Developer: Esma Uysal
Company : Workcube
Destination: Main -->
<querytag>
	IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='@_dsn_main_@' AND TABLE_NAME='OUR_COMPANY_HISTORY')
	BEGIN
        CREATE TABLE [OUR_COMPANY_HISTORY](
            [HISTORY_ID] [int] IDENTITY(1,1) NOT NULL,
            [COMP_ID] [int] NOT NULL,
            [COMPANY_NAME] [nvarchar](200) NULL,
            [NICK_NAME] [nvarchar](50) NULL,
            [TAX_OFFICE] [nvarchar](50) NULL,
            [TAX_NO] [nvarchar](50) NULL,
            [TEL_CODE] [nvarchar](43) NULL,
            [TEL] [nvarchar](43) NULL,
            [FAX] [nvarchar](43) NULL,
            [MANAGER] [nvarchar](40) NULL,
            [MANAGER_POSITION_CODE] [int] NULL,
            [MANAGER_POSITION_CODE2] [int] NULL,
            [WEB] [nvarchar](50) NULL,
            [EMAIL] [nvarchar](50) NULL,
            [ADDRESS] [nvarchar](max) NULL,
            [ADMIN_MAIL] [nvarchar](max) NULL,
            [TEL2] [nvarchar](43) NULL,
            [TEL3] [nvarchar](43) NULL,
            [TEL4] [nvarchar](43) NULL,
            [FAX2] [nvarchar](43) NULL,
            [T_NO] [nvarchar](50) NULL,
            [SERMAYE] [nvarchar](43) NULL,
            [CHAMBER] [nvarchar](150) NULL,
            [CHAMBER_NO] [nvarchar](50) NULL,
            [CHAMBER2] [nvarchar](150) NULL,
            [CHAMBER2_NO] [nvarchar](50) NULL,
            [ASSET_FILE_NAME1] [nvarchar](100) NULL,
            [ASSET_FILE_NAME1_SERVER_ID] [int] NULL,
            [ASSET_FILE_NAME2] [nvarchar](100) NULL,
            [ASSET_FILE_NAME2_SERVER_ID] [int] NULL,
            [ASSET_FILE_NAME3] [nvarchar](100) NULL,
            [ASSET_FILE_NAME3_SERVER_ID] [int] NULL,
            [HEADQUARTERS_ID] [int] NULL,
            [IS_ORGANIZATION] [bit] NULL,
            [HIERARCHY] [nvarchar](75) NULL,
            [HIERARCHY2] [nvarchar](75) NULL,
            [COMP_STATUS] [bit] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
            [AUTHORITY_DOC_FINISH] [datetime] NULL,
            [AUTHORITY_DOC_START] [datetime] NULL,
            [AUTHORITY_DOC_NUMBER] [nvarchar](100) NULL,
            [AUTHORITY_DOC_TYPE] [nvarchar](50) NULL,
            [AUTHORITY_DOC_WARNING] [int] NULL,
            [COORDINATE_1] [nvarchar](50) NULL,
            [COORDINATE_2] [nvarchar](50) NULL,
            [COUNTRY_ID] [int] NULL,
            [POSTAL_CODE] [nvarchar](50) NULL,
            [CITY_ID] [int] NULL,
            [CITY_SUBDIVISION_NAME] [nvarchar](50) NULL,
            [BUILDING_NUMBER] [nvarchar](50) NULL,
            [STREET_NAME] [nvarchar](50) NULL,
            [DISTRICT_NAME] [nvarchar](50) NULL,
            [COUNTY_ID] [int] NULL,
            [MERSIS_NO] [nvarchar](50) NULL,
            [NACE_CODE] [nvarchar](50) NULL,
        CONSTRAINT [PK_OUR_COMPANY_HISTORY] PRIMARY KEY CLUSTERED 
        (
            [HISTORY_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
	END;
	IF EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='@_dsn_main_@' AND TABLE_NAME='OUR_COMPANY_HISTORY')
	BEGIN
        SET IDENTITY_INSERT OUR_COMPANY_HISTORY OFF
            INSERT INTO OUR_COMPANY_HISTORY SELECT * FROM OUR_COMPANY
        SET IDENTITY_INSERT OUR_COMPANY_HISTORY ON
    END
</querytag>