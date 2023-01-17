<!-- Description : Protein Menü ile ilişkili Mega Menü Tablosu
Developer: Semih AKARTUNA
Company : Yazılımsa
Destination: Main -->
<querytag>
    IF NOT EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '@_dsn_main_@' and TABLE_NAME='PROTEIN_MEGA_MENUS')
    BEGIN
        CREATE TABLE [PROTEIN_MEGA_MENUS](
            [ID] [int] IDENTITY(1,1) NOT NULL,
            [SITE] [int] NOT NULL,
            [MENU_ID] [int] NOT NULL,
            [MEGAMENU_ID] [nvarchar](50) NOT NULL,
            [TITLE] [nvarchar](140) NULL,
            [STATUS] [int] NULL,
            [MEGAMENU_DATA] [text] NULL,
            [RECORD_DATE] [datetime] NULL,
            [RECORD_EMP] [int] NULL,
            [RECORD_IP] [nvarchar](50) NULL,
            [UPDATE_DATE] [datetime] NULL,
            [UPDATE_EMP] [int] NULL,
            [UPDATE_IP] [nvarchar](50) NULL,
            CONSTRAINT [PK_PROTEIN_MEGA_MENUS] PRIMARY KEY CLUSTERED 
        (
            [ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
    END    
</querytag>

