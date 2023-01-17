<!-- Description : Gelen-Giden Kargo Türleri scripti .
Developer: Fatma Zehra Dere
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='CARGO_DOCUMENT_TYPE' )
    BEGIN
    CREATE TABLE [CARGO_DOCUMENT_TYPE](
	[TYPE_ID] [int] IDENTITY(1,1) NOT NULL,
	[DOCUMENT_TYPE] [nvarchar](50) NULL,
	[RECORD_EMP] [int] NULL,
	[RECORD_IP] [nvarchar](50) NULL,
	[RECORD_DATE] [datetime] NULL,
	[UPDATE_IP] [nvarchar](50) NULL,
	[UPDATE_EMP] [int] NULL,
	[UPDATE_DATE] [datetime] NULL
) ON [PRIMARY]
END;
</querytag>