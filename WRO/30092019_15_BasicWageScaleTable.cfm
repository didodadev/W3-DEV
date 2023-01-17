<!-- Description : Temel Ücret Skala Tablosu Create Kodu
Developer: Esma Uysal
Company : Workcube
Destination: Main-->
<querytag>
	IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='POSITION_WAGE_SCALE')
    BEGIN
		CREATE TABLE [POSITION_WAGE_SCALE](
		[WAGE_ID] [int] IDENTITY(1,1) NOT NULL,
		[POSITION_ID] [int] NULL,
		[MIN_SALARY] [float] NULL,
		[MAX_SALARY] [float] NULL,
		[MONEY] [nvarchar](40) NULL,
		[YEAR] [int] NULL,
		[GROSS_NET] [bit] NULL,
		[RECORD_EMP] [int] NULL,
		[RECORD_DATE] [datetime] NULL,
		[RECORD_IP] [nvarchar](40) NULL,
		[UPDATE_EMP] [int] NULL,
		[UPDATE_DATE] [datetime] NULL,
		[UPDATE_IP] [nvarchar](40) NULL,
		CONSTRAINT [PK_POSITION_WAGE_SCALE] PRIMARY KEY CLUSTERED 
		(
			[WAGE_ID] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY] 
	END;
</querytag>
