<!-- Description :  Company Şemasına yeni alanlar 
Developer: Gülbahar Inan
Company : Workcube
Destination: Company -->
<querytag>

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='ORDER_DEMANDS' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME='_DOMAIN_NAME')
    BEGIN
        ALTER TABLE ORDER_DEMANDS ADD _DOMAIN_NAME nvarchar(200);
    END

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='ORDER_RESULT_QUALITY_ROW' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME='CONTROL_RESULT_TEXT')
    BEGIN
        ALTER TABLE ORDER_RESULT_QUALITY_ROW ADD CONTROL_RESULT_TEXT varchar;
    END

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='PROMOTIONS' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME='_IS_VIEWED')
    BEGIN
        ALTER TABLE PROMOTIONS ADD _IS_VIEWED bit;
    END

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='PROMOTIONS' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME='_DISCOUNT_TYPE_ID_1')
    BEGIN
        ALTER TABLE PROMOTIONS ADD _DISCOUNT_TYPE_ID_1 int;
    END
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='PROMOTIONS' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME='_DISCOUNT_TYPE_ID_2')
    BEGIN
        ALTER TABLE PROMOTIONS ADD _DISCOUNT_TYPE_ID_2 int;
    END
    IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'CONSIGMENT_REPORT_TABLE' AND TABLE_SCHEMA = '@_dsn_company_@')
    BEGIN
        CREATE TABLE [CONSIGMENT_REPORT_TABLE](	  
            [REPORT_TABLE_ID] int NOT NULL IDENTITY(1,1)	
            , [DATE] datetime NULL	
            , [SHIP_NO] nvarchar(100) NULL	
            , [DOCUMENT_TYPE] nvarchar(250) NULL	
            , [PROJECT] nvarchar(300) NULL	
            , [CURRENT_ACCOUNT] nvarchar(300) NULL	
            , [CATEGORY] nvarchar(300) NULL	
            , [STOCK_CODE] nvarchar(150) NULL	
            , [PARODUCT_NAME] nvarchar(250) NULL	
            , [DEPO_ID] nvarchar(250) NULL	
            , [DEPO_OUT] nvarchar(250) NULL	
            , [IN] float NULL	
            , [OUT] float NULL	
            , [DOCUMENT_COST] float NULL	
            , [DOCUMENT_COST_P_Br] nvarchar(20) NULL	
            , [RETURN_SHIP_AMOUNT] float NULL	
            , [RETURN_SHIP_COST] float NULL	
            , [RETURN_SHIP_COST_P_Br] nvarchar(20) NULL	
            , [RETURN_SHIP_NO] nvarchar(250) NULL	
            , [INVOICE_AMOUNT] float NULL	
            , [INVOICE_COST] float NULL	
            , [INVOICE_COST_P_Br] nvarchar(20) NULL	
            , [INVOICE_NO] nvarchar(250) NULL	
            , [REMAINING_AMOUNT] float NULL	
            , [COST] float NULL	
            , [COST_P_Br] nvarchar(20) NULL	
            , CONSTRAINT [PK_CONSIGMENT_REPORT_TABLE] PRIMARY KEY ([REPORT_TABLE_ID] ASC));
    END

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='SMS_SEND_RECEIVE' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME='UNIQCODE')
    BEGIN
        ALTER TABLE SMS_SEND_RECEIVE ADD UNIQCODE varchar;
    END
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='SETUP_PROCESS_CAT_HISTORY' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME='_IS_ACC_DETAIL_FROM_PROCESS_CAT')
    BEGIN
        ALTER TABLE SETUP_PROCESS_CAT_HISTORY ADD _IS_ACC_DETAIL_FROM_PROCESS_CAT bit;
    END

    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='SERVICE_PROD_RETURN_ROWS' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME='_RETURN_TYPE_OTHER')
    BEGIN
        ALTER TABLE SERVICE_PROD_RETURN_ROWS ADD _RETURN_TYPE_OTHER nvarchar(150);
    END
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='ORDER_MONEY_CREDITS' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME='_IS_GIFT_CARD')
    BEGIN
        ALTER TABLE ORDER_MONEY_CREDITS ADD _IS_GIFT_CARD bit;
    END
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='SERVICE_SUBSTATUS' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME='_SERVICE_SUBSTATUS_ID')
    BEGIN
        ALTER TABLE SERVICE_SUBSTATUS ADD _SERVICE_SUBSTATUS_ID int;
    END
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='ORDERS_DATA' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME='STATUS')
    BEGIN
        ALTER TABLE ORDERS_DATA ADD STATUS nchar(10);
    END
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='CUSTOM_DECLERATION' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME='DECLARATION')
    BEGIN
        ALTER TABLE CUSTOM_DECLERATION ADD DECLARATION nvarchar(25);
    END
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='CUSTOM_DECLERATION' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME='DECLERATION_BUYER')
    BEGIN
        ALTER TABLE CUSTOM_DECLERATION ADD DECLERATION_BUYER int;
    END
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='CUSTOM_DECLERATION' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME='DECLERATION_DETAIL')
    BEGIN
        ALTER TABLE CUSTOM_DECLERATION ADD DECLERATION_DETAIL nvarchar(500);
    END
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='CUSTOM_DECLERATION' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME='FARM_POLICY')
    BEGIN
        ALTER TABLE CUSTOM_DECLERATION ADD FARM_POLICY nvarchar(500);
    END
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='CUSTOM_DECLERATION' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME='INVOICE_COST_MONEY_TYPE')
    BEGIN
        ALTER TABLE CUSTOM_DECLERATION ADD INVOICE_COST_MONEY_TYPE nvarchar(25);
    END
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='CUSTOM_DECLERATION' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME='INVOICE_COST')
    BEGIN
        ALTER TABLE CUSTOM_DECLERATION ADD INVOICE_COST float;
    END
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='SETUP_PROCESS_CAT' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME='_IS_ACC_DETAIL_FROM_PROCESS_CAT')
    BEGIN
        ALTER TABLE SETUP_PROCESS_CAT ADD _IS_ACC_DETAIL_FROM_PROCESS_CAT bit;
    END
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='SETUP_PROCESS_CAT' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME='_IS_SHIP_DEFAULT')
    BEGIN
        ALTER TABLE SETUP_PROCESS_CAT ADD _IS_SHIP_DEFAULT bit;
    END
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='ORDER_DEMANDS_HISTORY' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME='_DOMAIN_NAME')
    BEGIN
        ALTER TABLE ORDER_DEMANDS_HISTORY ADD _DOMAIN_NAME nvarchar(200);
    END
    
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='PROMOTIONS_HISTORY' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME='_IS_VIEWED')
    BEGIN
        ALTER TABLE PROMOTIONS_HISTORY ADD _IS_VIEWED bit;
    END
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='PROMOTIONS_HISTORY' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME='_DISCOUNT_TYPE_ID_1')
    BEGIN
        ALTER TABLE PROMOTIONS_HISTORY ADD _DISCOUNT_TYPE_ID_1 int;
    END
    IF NOT EXISTS( SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='PROMOTIONS_HISTORY' AND TABLE_SCHEMA = '@_dsn_company_@' AND COLUMN_NAME='_DISCOUNT_TYPE_ID_2')
    BEGIN
        ALTER TABLE PROMOTIONS_HISTORY ADD _DISCOUNT_TYPE_ID_2 int;
    END
    

</querytag>