<!-- Description : subscription_counter Tablosu Güncellendi.
Developer: Botan Kayğan
Company : Workcube
Destination: Company -->
<querytag>

    ALTER TABLE SUBSCRIPTION_COUNTER ADD
        COUNTER_NO NVARCHAR(55) NULL,
        COUNTER_STAGE_ID INT NULL,
        PRICE_CATID INT NULL,
        TARIFF INT NULL,
        READING_TYPE_ID INT NULL,
        WEX_CODE NVARCHAR(50) NULL,
        AMOUNT FLOAT NULL,
        START_DATE DATETIME NULL,
        FINISH_DATE DATETIME NULL,
        DOCUMENTS NVARCHAR(250) NULL,
        UPLOADED_FILE NVARCHAR(250) NULL,
        READING_PERIOD INT NULL,
        FREE_PERIOD INT NULL

    ALTER TABLE SUBSCRIPTION_COUNTER DROP COLUMN
        PRODUCT_NAME,
        CHANGE_PERIOD
        
</querytag>