<!-- Description : COMMANDMENT tablosunun eklenmesi
Developer: Kayhan KAYA
Company : Workcube
Destination: Main-->
<querytag>
	IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='COMMANDMENT' )
	BEGIN
		CREATE TABLE [COMMANDMENT](
		[COMMANDMENT_ID] [int] IDENTITY(1,1) NOT NULL,
		[DETAIL] [nvarchar](250) NULL,
		[RECORD_DATE] [datetime] NULL,
		[COMMANDMENT_DATE] [datetime] NULL,
		[RECORD_EMP] [int] NULL,
		[COMMANDMENT_VALUE] [float] NULL,
		[COMMANDMENT_DETAIL] [nvarchar](500) NULL,
		[IS_REFUSE] [bit] NULL,
		[IS_APPLY] [bit] NULL,
		[IS_TRANSFER] [bit] NULL,
		[EMPLOYEE_ID] [int] NULL,
		[PROJECT_ID] [int] NULL,
		[SERIAL_NO] [nvarchar](5) NULL,
		[SERIAL_NUMBER] [nvarchar](50) NULL,
		[PROCESS_STAGE] [int] NULL,
		[COMMANDMENT_FILE] [nvarchar](50) NULL,
		[IBAN_NO] [nvarchar](100) NULL,
		[PRE_COMMANDMENT_VALUE] [real] NULL,
		[RATE_VALUE] [real] NULL,
		[IS_CVP] [bit] NULL,
		[ODENEN] [float] NULL,
		[COMMANDMENT_TYPE] [int] NULL,
		[TYPE_ID] [int] NULL,
		[PRIORITY] [int] NULL,
		[UPDATE_DATE] [datetime] NULL,
		[UPDATE_EMP] [int] NULL,
		[IS_MANUEL_CLOSED] [bit] NULL,
		[COMMANDMENT_OFFICE] [nvarchar](500) NULL
	) ON [PRIMARY]
	END
</querytag>