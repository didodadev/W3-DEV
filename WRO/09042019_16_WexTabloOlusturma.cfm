<!-- Description : Wex tablosu oluştur
Developer: Uğur Hamurpet
Company : Workcube
Destination: Main-->
<querytag>
IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='WRK_WEX' )
    BEGIN
		CREATE TABLE [WRK_WEX](
			[WEX_ID] [int] IDENTITY(1,1) NOT NULL,
			[IS_ACTIVE] [bit] NULL CONSTRAINT [DF_WRK_WEX_IS_ACTIVE]  DEFAULT ((1)),
			[MODULE] [int] NOT NULL,
			[HEAD] [nvarchar](250) NOT NULL,
			[DICTIONARY_ID] [int] NOT NULL,
			[VERSION] [nvarchar](50) NULL,
			[TYPE] [int] NULL,
			[LICENCE] [int] NULL,
			[URL_ADDRESS] [nvarchar](250) NOT NULL,
			[TIME_PLAN_TYPE] [int] NOT NULL,
			[TIME_PLAN] [int] NULL,
			[AUTHENTICATION] [int] NOT NULL,
			[STATUS] [nvarchar](50) NOT NULL,
			[STAGE] [int] NULL,
			[AUTHOR] [nvarchar](50) NULL,
			[FILE_PATH] [nvarchar](250) NOT NULL,
			[RECORD_IP] [nvarchar](50) NULL,
			[RECORD_EMP] [int] NULL,
			[RECORD_DATE] [datetime] NULL,
			[UPDATE_IP] [nvarchar](50) NULL,
			[UPDATE_EMP] [int] NULL,
			[UPDATE_DATE] [datetime] NULL,
		CONSTRAINT [PK_WRK_WEX] PRIMARY KEY CLUSTERED 
		(
			[WEX_ID] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY]
	END;
</querytag>