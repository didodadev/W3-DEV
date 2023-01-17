<!-- Description : COMMANDMENT_ROW tablosunun eklenmesi
Developer: Kayhan KAYA
Company : Workcube
Destination: Main-->
<querytag>
	IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='COMMANDMENT_ROWS' )
	BEGIN
    CREATE TABLE [COMMANDMENT_ROWS](
	[ROW_ID] [int] IDENTITY(1,1) NOT NULL,
	[COMMANDMENT_ID] [int] NULL,
	[EMPLOYEE_PUANTAJ_ID] [int] NULL,
	[CLOSED_AMOUNT] [float] NULL,
	[SAL_YEAR] [int] NULL,
	[SAL_MON] [int] NULL,
	[EMPLOYEE_ID] [int] NULL
) ON [PRIMARY]
	END
</querytag>