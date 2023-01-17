<!-- Description : Bestpractice sisteme eklendi
Developer: Halit Yurttaş
Company : Workcube
Destination: Main -->
<querytag>
    IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='WRK_BESTPRACTICE' )
    BEGIN
        CREATE TABLE [WRK_BESTPRACTICE](
            [BESTPRACTICE_ID] [int] IDENTITY(1,1) NOT NULL,
            [BESTPRACTICE_NAME] [nvarchar](250) NOT NULL,
            [BESTPRACTICE_DETAIL] [nvarchar](max) NULL,
            [BESTPRACTICE_AUTHOR] [nvarchar](150) NOT NULL,
            [BESTPRACTICE_AUTHORID] [int] NOT NULL,
            [BESTPRACTICE_PRODUCT_CODE] [nvarchar](50) NOT NULL,
            [BESTPRACTICE_LICENSE] [nvarchar](50) NOT NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_IP] [nvarchar](25) NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_IP] [nvarchar](25) NULL,
        CONSTRAINT [PK_WRK_BESTPRACTICE] PRIMARY KEY CLUSTERED 
        (
            [BESTPRACTICE_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

        CREATE TABLE [WRK_OBJECTS_BESTPRACTICE](
            [OB_ID] [int] IDENTITY(1,1) NOT NULL,
            [OBJECT_ID] [int] NOT NULL,
            [BESTPRACTICE_ID] [int] NOT NULL,
        CONSTRAINT [PK_WRK_OBJECT_BESTPRACTICE] PRIMARY KEY CLUSTERED 
        (
            [OB_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END
</querytag>