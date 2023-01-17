<!-- Description : Dijital varlık grupları tablosuna dijital varlık kategori ilişkisi için alan açıldı 
Developer: Uğur Hamurpet
Company : Workcube
Destination: Main -->
<querytag>
    IF EXISTS ( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='DIGITAL_ASSET_GROUP_PERM' AND INFORMATION_SCHEMA.TABLES.TABLE_SCHEMA <> 'dbo' )
    BEGIN
        IF NOT EXISTS ( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='DIGITAL_ASSET_GROUP_PERM' AND COLUMN_NAME='ASSETCAT_ID')
        BEGIN
        ALTER TABLE DIGITAL_ASSET_GROUP_PERM ADD 
        ASSETCAT_ID int
        END;
    END
    ELSE
    BEGIN
        CREATE TABLE [DIGITAL_ASSET_GROUP_PERM](
            [PERMISSION_ID] [int] IDENTITY(1,1) NOT NULL,
            [GROUP_ID] [int] NULL,
            [ASSETCAT_ID] [int] NULL,
            [POSITION_CODE] [int] NULL,
            [PARTNER_ID] [int] NULL,
            [POSITION_CAT] [int] NULL,
            [STATUS] [bit] NULL,
        CONSTRAINT [PK_DIGITAL_ASSET_GROUP_PERM] PRIMARY KEY CLUSTERED 
        (
            [PERMISSION_ID] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
        ) ON [PRIMARY]
    END;
</querytag>
