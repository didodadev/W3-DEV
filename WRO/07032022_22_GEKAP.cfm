<!--Description : GEKAP geri dönüşüm tablosu
Developer: Mahmut Aslan
Company : Workcube
Destination: Main-->
<querytag>
    IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='RECYCLE_GROUP')
    BEGIN
		CREATE TABLE [RECYCLE_GROUP](
            [RECYCLE_GROUP_ID] [int] IDENTITY(1,1) NOT NULL,
            [RECYCLE_GROUP] [nvarchar](200) NOT NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
            CONSTRAINT [PK_RECYCLE_GROUP] PRIMARY KEY CLUSTERED 
            (
                [RECYCLE_GROUP_ID] ASC
            )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
            ) ON [PRIMARY]
    END;
    IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='RECYCLE_SUB_GROUP')
    BEGIN
        CREATE TABLE [RECYCLE_SUB_GROUP](
            [RECYCLE_SUB_GROUP_ID] [int] IDENTITY(1,1) NOT NULL,
            [RECYCLE_SUB_GROUP] [nvarchar](200) NOT NULL,
            [RECYCLE_GROUP_ID] [int] NOT NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
            CONSTRAINT [PK_RECYCLE_SUB_GROUP] PRIMARY KEY CLUSTERED 
            (
                [RECYCLE_SUB_GROUP_ID] ASC
            )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
            ) ON [PRIMARY]
    END;

</querytag>