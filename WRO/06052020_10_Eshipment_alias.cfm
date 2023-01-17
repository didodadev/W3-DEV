<!-- Description : E-irsaliye alias tanımlarının geçici saklandığı tablodur
Developer: Halit Yurttaş
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS( SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='ESHIPMENT_ALIAS')
    BEGIN
        CREATE TABLE [ESHIPMENT_ALIAS](
        [ESHIPMENT_USERID] [int] IDENTITY(1,1) NOT NULL,
        [VKNTCKN] [nvarchar](15) NOT NULL,
        [ALIAS] [nvarchar](100) NOT NULL,
        [NAME] [nvarchar](250) NOT NULL,
        [TYPE] [nvarchar](50) NULL,
        [REGISTERTIME] [datetime] NULL,
        [FIRSTCREATIONTIME] [datetime] NULL,
        [ALIASCREATIONTIME] [datetime] NULL,
        CONSTRAINT [PK_ESHIPMENT_ALIAS] PRIMARY KEY CLUSTERED 
        (
            [ESHIPMENT_USERID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;
</querytag>
