CREATE PROCEDURE [@_dsn_company_@].[add_price]
                        @product_id int,
                        @product_unit_id int,
                        @price_cat int,
                        @start_date datetime,
                        @price float,
                        @price_money nvarchar(10),
                        @is_kdv float,
                        @price_with_kdv float,
                        @catalog_id int,
                        @user_id int,
                        @remote_addr nvarchar(40),
                        @price_discount float,
                        @stock_id int,
                        @spect_var_id int
                    AS
                    
                        DELETE FROM 
                            PRICE 
                        WHERE 
                            PRICE_CATID = @price_cat AND 
                            STARTDATE= @start_date AND 
                            PRODUCT_ID= @product_id AND		
                            UNIT= @product_unit_id AND
                            ISNULL(STOCK_ID,0)=@stock_id AND
                            ISNULL(SPECT_VAR_ID,0)=@spect_var_id
                        
                        DELETE FROM 
                            PRICE_HISTORY 
                        WHERE 
                            PRICE_CATID = @price_cat AND 
                            STARTDATE= @start_date AND 
                            PRODUCT_ID= @product_id AND 
                            UNIT= @product_unit_id AND 
                            ISNULL(STOCK_ID,0)=@stock_id AND
                            ISNULL(SPECT_VAR_ID,0)=@spect_var_id
                    
                    DELETE FROM 
                        PRICE 
                    WHERE 
                        FINISHDATE < DATEADD(d,-1,GETDATE())
                    
                    UPDATE 
                        PRICE 
                    SET 
                        FINISHDATE = DATEADD(s,-1,@start_date)
                    WHERE 
                        PRODUCT_ID = @product_id AND 
                        UNIT = @product_unit_id AND 
                        PRICE_CATID = @price_cat AND 
                        STARTDATE < @start_date AND 
                        (FINISHDATE IS NULL OR FINISHDATE > @start_date) AND
                        ISNULL(STOCK_ID,0)=@stock_id AND
                        ISNULL(SPECT_VAR_ID,0)=@spect_var_id
                    
                    UPDATE 
                        PRICE_HISTORY 
                    SET 
                        FINISHDATE = DATEADD(s,-1,@start_date)
                    WHERE 
                        PRODUCT_ID = @product_id AND 
                        UNIT = @product_unit_id AND 
                        PRICE_CATID = @price_cat AND 
                        STARTDATE < @start_date AND 
                        (FINISHDATE IS NULL OR FINISHDATE > @start_date) AND
                        ISNULL(STOCK_ID,0)=@stock_id AND
                        ISNULL(SPECT_VAR_ID,0)=@spect_var_id
                
                    
                    DECLARE @ST_DATE datetime
                    SELECT @ST_DATE = 	(SELECT 
                                    TOP 1 STARTDATE 
                                FROM 
                                    PRICE 
                                WHERE 
                                    PRODUCT_ID = @product_id AND 
                                    UNIT = @product_unit_id AND 
                                    PRICE_CATID = @price_cat AND 
                                    STARTDATE > @start_date AND
                                    ISNULL(STOCK_ID,0)=@stock_id AND
                                    ISNULL(SPECT_VAR_ID,0)=@spect_var_id
                                ORDER BY 
                                    STARTDATE)
                    
                    DECLARE @FINISHDATE datetime
                    if ( @ST_DATE IS NOT NULL)
                        SELECT @FINISHDATE  = DATEADD(s,-1,@ST_DATE)
                    
                    DECLARE @CATALOGID int
                    if ( @catalog_id > 0 )
                        SELECT @CATALOGID = @catalog_id
                    
                    DECLARE @STOCK_ID_ int
                    if ( @stock_id > 0 )
                        SELECT @STOCK_ID_ = @stock_id
                    
                    DECLARE @SPECT_VAR_ID_ int
                    if ( @spect_var_id > 0 )
                        SELECT @SPECT_VAR_ID_ = @spect_var_id
                        
                    INSERT INTO	
                        PRICE
                        (
                            PRICE_CATID,
                            PRODUCT_ID,
                            STOCK_ID,
                            SPECT_VAR_ID,
                            STARTDATE,
                            FINISHDATE,
                            PRICE,
                            IS_KDV,
                            PRICE_KDV,
                            PRICE_DISCOUNT,
                            MONEY,
                            UNIT,
                            CATALOG_ID,
                            RECORD_DATE,
                            RECORD_EMP,
                            RECORD_IP
                        )
                    VALUES
                        (
                            @price_cat,
                            @product_id,
                            @STOCK_ID_,
                            @SPECT_VAR_ID_,
                            @start_date,
                            @FINISHDATE,
                            @price,
                            @is_kdv,
                            @price_with_kdv,
                            @price_discount,
                            @price_money,
                            @product_unit_id,
                            @CATALOGID,
                            getdate(),
                            @user_id,
                            @remote_addr
                        )
                    
                    INSERT INTO	
                        PRICE_HISTORY
                        (
                            PRICE_CATID,
                            PRODUCT_ID,
                            STOCK_ID,
                            SPECT_VAR_ID,
                            STARTDATE,
                            FINISHDATE,
                            PRICE,
                            IS_KDV,
                            PRICE_KDV,
                            PRICE_DISCOUNT,
                            MONEY,
                            UNIT,
                            CATALOG_ID,
                            RECORD_DATE,
                            RECORD_EMP,
                            RECORD_IP
                        )
                    VALUES
                        (
                            @price_cat,
                            @product_id,
                            @STOCK_ID_,
                            @SPECT_VAR_ID_,
                            @start_date,
                            @FINISHDATE,
                            @price,
                            @is_kdv,
                            @price_with_kdv,
                            @price_discount,
                            @price_money,
                            @product_unit_id,
                            @CATALOGID,
                            getdate(),
                            @user_id,
                            @remote_addr
                        )

CREATE PROCEDURE [@_dsn_company_@].[ADD_PRODUCTION_OPERATION] 
                @P_ORDER_ID int,
                @STATION_ID int,
                @O_MINUTE float,
                @OPERATION_TYPE_ID int,
                @AMOUNT float,
                @RECORD_EMP int,
                @RECORD_DATE datetime,
                @RECORD_IP nvarchar(50),
                @STAGE int
                AS
            BEGIN
                SET NOCOUNT ON;
                INSERT INTO 
                    PRODUCTION_OPERATION
                    (
                        P_ORDER_ID,
                        STATION_ID,
                        O_MINUTE,
                        OPERATION_TYPE_ID,
                        AMOUNT,
                        RECORD_EMP,
                        RECORD_DATE,
                        RECORD_IP,
                        STAGE
                    )
                    VALUES
                    (
                        @P_ORDER_ID,
                        @STATION_ID,
                        @O_MINUTE,
                        @OPERATION_TYPE_ID,
                        @AMOUNT,
                        @RECORD_EMP,
                        @RECORD_DATE,
                        @RECORD_IP,
                        @STAGE
                    )
            END

CREATE PROCEDURE [@_dsn_company_@].[ADD_PRODUCTION_ORDER]
                @PO_RELATED_ID int,
                @STOCK_ID int,
                @QUANTITY float,
                @START_DATE datetime,
                @FINISH_DATE datetime,
                @RECORD_EMP int,
                @RECORD_DATE datetime,
                @RECORD_IP nvarchar(50),
                @STATUS int,
                @PROJECT_ID int,
                @P_ORDER_NO nvarchar(50),
                @DETAIL nvarchar(2000),
                @PROD_ORDER_STAGE int,
                @STATION_ID int,
                @SPECT_VAR_ID int,
                @SPECT_VAR_NAME nvarchar(500),
                @IS_STOCK_RESERVED bit,
                @IS_DEMONTAJ bit,
                @LOT_NO nvarchar(100),
                @PRODUCTION_LEVEL nvarchar(50),
                @SPEC_MAIN_ID int,
                @IS_STAGE int,
                @WRK_ROW_ID nvarchar(40),
                @DEMAND_NO nvarchar(50),
                @EXIT_DEP_ID int,
                @EXIT_LOC_ID int,
                @PRODUCTION_DEP_ID int,
                @PRODUCTION_LOC_ID int,
                @WORK_ID int ,
                @WRK_ROW_RELATION_ID nvarchar(50)	
                
                AS
                BEGIN
                    SET NOCOUNT ON;
                                    INSERT INTO 
                                            PRODUCTION_ORDERS
                                        (
                                            PO_RELATED_ID,
                                            STOCK_ID,
                                            QUANTITY,
                                            START_DATE,
                                            FINISH_DATE,
                                            RECORD_EMP,
                                            RECORD_DATE,
                                            RECORD_IP,
                                            STATUS,
                                            PROJECT_ID,
                                            P_ORDER_NO,
                                            DETAIL,
                                            PROD_ORDER_STAGE,
                                            STATION_ID,
                                            SPECT_VAR_ID,
                                            SPECT_VAR_NAME,
                                            IS_STOCK_RESERVED,
                                            IS_DEMONTAJ,
                                            LOT_NO,
                                            PRODUCTION_LEVEL,
                                            SPEC_MAIN_ID,
                                            IS_STAGE,
                                            WRK_ROW_ID,
                                            DEMAND_NO,
                                            EXIT_DEP_ID,
                                            EXIT_LOC_ID,
                                            PRODUCTION_DEP_ID,
                                            PRODUCTION_LOC_ID,
                                            WORK_ID,
                                            WRK_ROW_RELATION_ID
                                        )
                                        VALUES
                                        ( 
                                            @PO_RELATED_ID,
                                            @STOCK_ID,
                                            @QUANTITY,
                                            @START_DATE,
                                            @FINISH_DATE,
                                            @RECORD_EMP,
                                            @RECORD_DATE,
                                            @RECORD_IP,
                                            @STATUS,
                                            @PROJECT_ID,
                                            @P_ORDER_NO,
                                            @DETAIL,
                                            @PROD_ORDER_STAGE,
                                            @STATION_ID,
                                            @SPECT_VAR_ID,
                                            @SPECT_VAR_NAME,
                                            @IS_STOCK_RESERVED,
                                            @IS_DEMONTAJ,
                                            @LOT_NO,
                                            @PRODUCTION_LEVEL,
                                            @SPEC_MAIN_ID,
                                            @IS_STAGE,
                                            @WRK_ROW_ID,
                                            @DEMAND_NO,
                                            @EXIT_DEP_ID,
                                            @EXIT_LOC_ID,
                                            @PRODUCTION_DEP_ID,
                                            @PRODUCTION_LOC_ID,
                                            @WORK_ID,
                                            @WRK_ROW_RELATION_ID	
                                        )
                END

CREATE PROCEDURE [@_dsn_company_@].[ADD_PRODUCTION_ORDER_CASH] 
                @startdate datetime,
                @finishdate datetime,
                @station_id int
            AS
            BEGIN
                -- SET NOCOUNT ON added to prevent extra result sets from
                -- interfering with SELECT statements.
                SET NOCOUNT ON;
            
               INSERT INTO
                    PRODUCTION_ORDERS_CASH
                    (
                        START_DATE,
                        FINISH_DATE,
                        STATION_ID
                    )
                VALUES
                    (
                        @startdate,
                        @finishdate,
                        @station_id
                    )
            END

CREATE PROCEDURE [@_dsn_company_@].[ADD_PRODUCTION_ORDER_RESULT]
                @P_ORDER_ID int,
                @PROCESS_ID int,
                @START_DATE datetime ,
                @FINISH_DATE datetime,
                @EXIT_DEP_ID int,
                @EXIT_LOC_ID int,
                @STATION_ID int,
                @PRODUCTION_ORDER_NO nvarchar(43),
                @RESULT_NO nvarchar(43),
                @ENTER_DEP_ID int,
                @ENTER_LOC_ID int,
                @ORDER_NO nvarchar(250),
                @REFERENCE_NO nvarchar(500),
                @POSITION_ID int ,
                @RECORD_EMP int,
                @RECORD_DATE datetime,
                @RECORD_IP nvarchar(50),
                @LOT_NO nvarchar(100),
                @PRODUCTION_DEP_ID int,
                @PRODUCTION_LOC_ID int,
                @PROD_ORD_RESULT_STAGE int,
                @IS_STOCK_FIS bit,
                @WRK_ROW_ID nvarchar(40),
                @EXPIRATION_DATE datetime
            AS
            BEGIN
                SET NOCOUNT ON;
                    INSERT INTO 
                        PRODUCTION_ORDER_RESULTS 
                    ( 
                        P_ORDER_ID,
                        PROCESS_ID,
                        START_DATE,
                        FINISH_DATE,
                        EXIT_DEP_ID,
                        EXIT_LOC_ID,
                        STATION_ID,
                        PRODUCTION_ORDER_NO,
                        RESULT_NO,
                        ENTER_DEP_ID,
                        ENTER_LOC_ID,
                        ORDER_NO,
                        REFERENCE_NO,
                        POSITION_ID ,
                        RECORD_EMP,
                        RECORD_DATE,
                        RECORD_IP,
                        LOT_NO,
                        PRODUCTION_DEP_ID,
                        PRODUCTION_LOC_ID,
                        PROD_ORD_RESULT_STAGE,
                        IS_STOCK_FIS,
                        WRK_ROW_ID,
                        EXPIRATION_DATE
                    )
                    VALUES
                    (
                        @P_ORDER_ID,
                        @PROCESS_ID,
                        @START_DATE,
                        @FINISH_DATE,
                        @EXIT_DEP_ID,
                        @EXIT_LOC_ID,
                        @STATION_ID,
                        @PRODUCTION_ORDER_NO,
                        @RESULT_NO,
                        @ENTER_DEP_ID,
                        @ENTER_LOC_ID,
                        @ORDER_NO,
                        @REFERENCE_NO,
                        @POSITION_ID ,
                        @RECORD_EMP,
                        @RECORD_DATE,
                        @RECORD_IP,
                        @LOT_NO,
                        @PRODUCTION_DEP_ID,
                        @PRODUCTION_LOC_ID,
                        @PROD_ORD_RESULT_STAGE,
                        @IS_STOCK_FIS,
                        @WRK_ROW_ID,
                        @EXPIRATION_DATE
                    )
                    
            END

CREATE PROCEDURE [@_dsn_company_@].[ADD_PRODUCTION_ORDER_RESULTS_ROW]
                @TREE_TYPE NVARCHAR(43),
                @TYPE int,
                @PR_ORDER_ID int,
                @BARCODE nvarchar(43),
                @STOCK_ID int,
                @PRODUCT_ID int,
                @AMOUNT float,
                @AMOUNT2 float,
                @UNIT_ID int,
                @UNIT2 nvarchar(50),
                @NAME_PRODUCT nvarchar(500),
                @UNIT_NAME nvarchar(65),
                @SPECT_ID int,
                @SPEC_MAIN_ID int,
                @SPECT_NAME nvarchar(500),
                @COST_ID int,
                @KDV_PRICE float,
                @PURCHASE_NET_SYSTEM float,
                @PURCHASE_NET_SYSTEM_MONEY nvarchar(43),
                @PURCHASE_EXTRA_COST_SYSTEM float,
                @PURCHASE_NET_SYSTEM_TOTAL float,
                @PURCHASE_NET float,
                @PURCHASE_NET_MONEY nvarchar(43),
                @PURCHASE_NET_2 float,
                @PURCHASE_EXTRA_COST_SYSTEM_2 float,
                @PURCHASE_NET_MONEY_2 nvarchar(43),
                @PURCHASE_EXTRA_COST float,
                @PURCHASE_NET_TOTAL float,
                @PRODUCT_NAME2 nvarchar(500),
                @FIRE_AMOUNT float,
                @IS_FREE_AMOUNT bit,
                @WRK_ROW_ID nvarchar(50),
                @WRK_ROW_RELATION_ID nvarchar(50)
            AS
            BEGIN
                SET NOCOUNT ON;
            
               INSERT INTO
                    PRODUCTION_ORDER_RESULTS_ROW
                    (
                        TREE_TYPE,
                        TYPE,
                        PR_ORDER_ID,
                        BARCODE,
                        STOCK_ID,
                        PRODUCT_ID,
                        AMOUNT,
                        AMOUNT2,
                        UNIT_ID,
                        UNIT2,
                        NAME_PRODUCT,
                        UNIT_NAME,
                        SPECT_ID,
                        SPEC_MAIN_ID,
                        SPECT_NAME,
                        COST_ID,
                        KDV_PRICE,
                        PURCHASE_NET_SYSTEM,
                        PURCHASE_NET_SYSTEM_MONEY,
                        PURCHASE_EXTRA_COST_SYSTEM,
                        PURCHASE_NET_SYSTEM_TOTAL,
                        PURCHASE_NET,
                        PURCHASE_NET_MONEY,
                        PURCHASE_NET_2,
                        PURCHASE_EXTRA_COST_SYSTEM_2,
                        PURCHASE_NET_MONEY_2,
                        PURCHASE_EXTRA_COST,
                        PURCHASE_NET_TOTAL,
                        PRODUCT_NAME2,
                        FIRE_AMOUNT,
                        IS_FREE_AMOUNT,
                        WRK_ROW_ID,
                        WRK_ROW_RELATION_ID
                    )
                    VALUES
                    (
                        @TREE_TYPE,
                        @TYPE,
                        @PR_ORDER_ID,
                        @BARCODE,
                        @STOCK_ID,
                        @PRODUCT_ID,
                        @AMOUNT,
                        @AMOUNT2,
                        @UNIT_ID,
                        @UNIT2,
                        @NAME_PRODUCT,
                        @UNIT_NAME,
                        @SPECT_ID,
                        @SPEC_MAIN_ID,
                        @SPECT_NAME,
                        @COST_ID,
                        @KDV_PRICE,
                        @PURCHASE_NET_SYSTEM,
                        @PURCHASE_NET_SYSTEM_MONEY,
                        @PURCHASE_EXTRA_COST_SYSTEM,
                        @PURCHASE_NET_SYSTEM_TOTAL,
                        @PURCHASE_NET,
                        @PURCHASE_NET_MONEY,
                        @PURCHASE_NET_2,
                        @PURCHASE_EXTRA_COST_SYSTEM_2,
                        @PURCHASE_NET_MONEY_2,
                        @PURCHASE_EXTRA_COST,
                        @PURCHASE_NET_TOTAL,
                        @PRODUCT_NAME2,
                        @FIRE_AMOUNT,
                        @IS_FREE_AMOUNT,
                        @WRK_ROW_ID,
                        @WRK_ROW_RELATION_ID
                    
                    )
            END

CREATE PROCEDURE [@_dsn_company_@].[ADD_PRODUCTION_ORDER_RESULTS_ROW_O]
                @TYPE int,
                @PR_ORDER_ID int,
                @BARCODE nvarchar(43),
                @STOCK_ID int,
                @PRODUCT_ID int,
                @LOT_NO nvarchar(100),
                @AMOUNT float,
                @AMOUNT2 float,
                @UNIT_ID int,
                @UNIT2 nvarchar(50),
                @SERIAL_NO nvarchar(50),
                @NAME_PRODUCT nvarchar(500),
                @UNIT_NAME nvarchar(65),
                @IS_SEVKIYAT bit,
                @SPECT_ID int,
                @SPEC_MAIN_ID int,
                @SPECT_NAME nvarchar(500) ,
                @COST_ID int,
                @KDV_PRICE float,
                @PURCHASE_NET_SYSTEM float,
                @PURCHASE_NET_SYSTEM_MONEY nvarchar(43),
                @PURCHASE_EXTRA_COST_SYSTEM float,
                @PURCHASE_NET_SYSTEM_TOTAL float,
                @PURCHASE_NET float,
                @PURCHASE_NET_MONEY nvarchar(43),
                @PURCHASE_NET_2 float,
                @PURCHASE_EXTRA_COST_SYSTEM_2 float,
                @PURCHASE_NET_MONEY_2 nvarchar(43),
                @PURCHASE_EXTRA_COST float,
                @PURCHASE_NET_TOTAL float,
                @PRODUCT_NAME2 nvarchar(500),
                @WRK_ROW_ID nvarchar(50),
                @WRK_ROW_RELATION_ID nvarchar(50),
                @LINE_NUMBER int,
                @IS_MANUAL_COST bit,
                @EXPIRATION_DATE datetime,
                @WIDTH float,
                @HEIGHT float,
                @LENGTH float,
                @SPECIFIC_WEIGHT float,
                @WEIGHT float
            AS
                BEGIN
                    SET NOCOUNT ON;
                        INSERT INTO
                                PRODUCTION_ORDER_RESULTS_ROW
                                (
                                    TYPE,
                                    PR_ORDER_ID,
                                    BARCODE,
                                    STOCK_ID,
                                    PRODUCT_ID,
                                    LOT_NO,
                                    AMOUNT,
                                    AMOUNT2,
                                    UNIT_ID,
                                    UNIT2,
                                    SERIAL_NO,
                                    NAME_PRODUCT,
                                    UNIT_NAME,
                                    IS_SEVKIYAT,
                                    SPECT_ID,
                                    SPEC_MAIN_ID,
                                    SPECT_NAME,
                                    COST_ID,
                                    KDV_PRICE,
                                    PURCHASE_NET_SYSTEM,
                                    PURCHASE_NET_SYSTEM_MONEY,
                                    PURCHASE_EXTRA_COST_SYSTEM,
                                    PURCHASE_NET_SYSTEM_TOTAL,
                                    PURCHASE_NET,
                                    PURCHASE_NET_MONEY,
                                    PURCHASE_NET_2,
                                    PURCHASE_EXTRA_COST_SYSTEM_2,
                                    PURCHASE_NET_MONEY_2,
                                    PURCHASE_EXTRA_COST,
                                    PURCHASE_NET_TOTAL,
                                    PRODUCT_NAME2,
                                    WRK_ROW_ID,
                                    WRK_ROW_RELATION_ID,
                                    LINE_NUMBER,
                                    IS_MANUAL_COST,
                                    EXPIRATION_DATE,
                                    WIDTH,
                                    HEIGHT,
                                    LENGTH,
                                    SPECIFIC_WEIGHT,
                                    WEIGHT
                                )
                                VALUES
                                (
                                    @TYPE,
                                    @PR_ORDER_ID,
                                    @BARCODE,
                                    @STOCK_ID,
                                    @PRODUCT_ID,
                                    @LOT_NO,
                                    @AMOUNT,
                                    @AMOUNT2,
                                    @UNIT_ID,
                                    @UNIT2,
                                    @SERIAL_NO,
                                    @NAME_PRODUCT,
                                    @UNIT_NAME,
                                    @IS_SEVKIYAT,
                                    @SPECT_ID,
                                    @SPEC_MAIN_ID,
                                    @SPECT_NAME,
                                    @COST_ID,
                                    @KDV_PRICE,
                                    @PURCHASE_NET_SYSTEM,
                                    @PURCHASE_NET_SYSTEM_MONEY,
                                    @PURCHASE_EXTRA_COST_SYSTEM,
                                    @PURCHASE_NET_SYSTEM_TOTAL,
                                    @PURCHASE_NET,
                                    @PURCHASE_NET_MONEY,
                                    @PURCHASE_NET_2,
                                    @PURCHASE_EXTRA_COST_SYSTEM_2,
                                    @PURCHASE_NET_MONEY_2,
                                    @PURCHASE_EXTRA_COST,
                                    @PURCHASE_NET_TOTAL,
                                    @PRODUCT_NAME2,
                                    @WRK_ROW_ID,
                                    @WRK_ROW_RELATION_ID,
                                    @LINE_NUMBER,
                                    @IS_MANUAL_COST,
                                    @EXPIRATION_DATE,
                                    @WIDTH,
                                    @HEIGHT,
                                    @LENGTH,
                                    @SPECIFIC_WEIGHT,
                                    @WEIGHT
                                )
            END

CREATE PROCEDURE [@_dsn_company_@].[ADD_PRODUCTION_ORDER_RESULTS_ROW_S] 
                @TREE_TYPE nvarchar(43),
                @TYPE int,
                @PR_ORDER_ID int,
                @BARCODE nvarchar(43),
                @STOCK_ID int,
                @PRODUCT_ID int,
                @LOT_NO nvarchar(100) ,
                @AMOUNT float,
                @AMOUNT2 float,
                @UNIT_ID int ,
                @UNIT2 nvarchar(50),
                @SERIAL_NO nvarchar(50),
                @NAME_PRODUCT nvarchar(500),
                @UNIT_NAME nvarchar(65),
                @IS_SEVKIYAT bit,
                @SPECT_ID int,
                @SPEC_MAIN_ID int,
                @SPECT_NAME nvarchar(500),								
                @COST_ID int,
                @KDV_PRICE float,
                @PURCHASE_NET_SYSTEM float,
                @PURCHASE_NET_SYSTEM_MONEY nvarchar(43),
                @PURCHASE_EXTRA_COST_SYSTEM float,
                @PURCHASE_NET_SYSTEM_TOTAL float,
                @PURCHASE_NET float,
                @PURCHASE_NET_MONEY nvarchar(43),
                @PURCHASE_NET_2 float,
                @PURCHASE_EXTRA_COST_SYSTEM_2 float,
                @PURCHASE_NET_MONEY_2 nvarchar(43),
                @PURCHASE_EXTRA_COST float ,
                @PURCHASE_NET_TOTAL float,
                @PRODUCT_NAME2 nvarchar(500),
                @IS_FROM_SPECT bit ,
                @IS_FREE_AMOUNT bit,
                @WRK_ROW_ID nvarchar(50),
                @WRK_ROW_RELATION_ID nvarchar(50),
                @LINE_NUMBER int,
                @IS_MANUAL_COST bit,
                @EXPIRATION_DATE datetime,
                @WIDTH float,
                @HEIGHT float,
                @LENGTH float,
                @SPECIFIC_WEIGHT float,
                @WEIGHT float
            AS
            BEGIN
                SET NOCOUNT ON;
                INSERT INTO
                    PRODUCTION_ORDER_RESULTS_ROW
                (
                    TREE_TYPE,
                    TYPE,
                    PR_ORDER_ID,
                    BARCODE,
                    STOCK_ID,
                    PRODUCT_ID,
                    LOT_NO,
                    AMOUNT,
                    AMOUNT2,
                    UNIT_ID,
                    UNIT2,
                    SERIAL_NO,
                    NAME_PRODUCT,
                    UNIT_NAME,
                    IS_SEVKIYAT,
                    SPECT_ID,
                    SPEC_MAIN_ID,
                    SPECT_NAME,								
                    COST_ID,
                    KDV_PRICE,
                    PURCHASE_NET_SYSTEM,
                    PURCHASE_NET_SYSTEM_MONEY,
                    PURCHASE_EXTRA_COST_SYSTEM,
                    PURCHASE_NET_SYSTEM_TOTAL,
                    PURCHASE_NET,
                    PURCHASE_NET_MONEY,
                    PURCHASE_NET_2,
                    PURCHASE_EXTRA_COST_SYSTEM_2,
                    PURCHASE_NET_MONEY_2,
                    PURCHASE_EXTRA_COST,
                    PURCHASE_NET_TOTAL,
                    PRODUCT_NAME2,
                    IS_FROM_SPECT,
                    IS_FREE_AMOUNT,
                    WRK_ROW_ID,
                    WRK_ROW_RELATION_ID,
                    LINE_NUMBER,
                    IS_MANUAL_COST,
                    EXPIRATION_DATE,
                    WIDTH,
                    HEIGHT,
                    LENGTH,
                    SPECIFIC_WEIGHT,
                    WEIGHT
                )
                VALUES
                (
                    @TREE_TYPE,
                    @TYPE,
                    @PR_ORDER_ID,
                    @BARCODE,
                    @STOCK_ID,
                    @PRODUCT_ID,
                    @LOT_NO,
                    @AMOUNT,
                    @AMOUNT2,
                    @UNIT_ID,
                    @UNIT2,
                    @SERIAL_NO,
                    @NAME_PRODUCT,
                    @UNIT_NAME,
                    @IS_SEVKIYAT,
                    @SPECT_ID,
                    @SPEC_MAIN_ID,
                    @SPECT_NAME,								
                    @COST_ID,
                    @KDV_PRICE,
                    @PURCHASE_NET_SYSTEM,
                    @PURCHASE_NET_SYSTEM_MONEY,
                    @PURCHASE_EXTRA_COST_SYSTEM,
                    @PURCHASE_NET_SYSTEM_TOTAL,
                    @PURCHASE_NET,
                    @PURCHASE_NET_MONEY,
                    @PURCHASE_NET_2,
                    @PURCHASE_EXTRA_COST_SYSTEM_2,
                    @PURCHASE_NET_MONEY_2,
                    @PURCHASE_EXTRA_COST,
                    @PURCHASE_NET_TOTAL,
                    @PRODUCT_NAME2,
                    @IS_FROM_SPECT,
                    @IS_FREE_AMOUNT,
                    @WRK_ROW_ID,
                    @WRK_ROW_RELATION_ID,
                    @LINE_NUMBER,
                    @IS_MANUAL_COST,
                    @EXPIRATION_DATE,
                    @WIDTH,
                    @HEIGHT,
                    @LENGTH,
                    @SPECIFIC_WEIGHT,
                    @WEIGHT
                )	
            END

CREATE PROCEDURE [@_dsn_company_@].[ADD_PRODUCTION_ORDERS_ROW] 
                @PRODUCTION_ORDER_ID int,
                @ORDER_ID int,
                @ORDER_ROW_ID int,
                @TYPE int
            AS
            BEGIN
                SET NOCOUNT ON;
               INSERT INTO
                    PRODUCTION_ORDERS_ROW
                (
                    PRODUCTION_ORDER_ID ,
                    ORDER_ID ,
                    ORDER_ROW_ID ,
                    TYPE 
                )
                VALUES
                (
                    @PRODUCTION_ORDER_ID,
                    @ORDER_ID,
                    @ORDER_ROW_ID,
                    @TYPE
                )
                END

CREATE PROCEDURE [@_dsn_company_@].[ADD_PRODUCTION_ORDERS_STOCKS]
                @P_ORDER_ID int ,
                @PRODUCT_ID int ,
                @STOCK_ID int ,
                @SPECT_MAIN_ID int,
                @AMOUNT float,
                @TYPE int,
                @PRODUCT_UNIT_ID int,
                @RECORD_EMP int ,
                @RECORD_DATE datetime,
                @RECORD_IP nvarchar(50),
                @IS_PHANTOM bit,
                @IS_SEVK bit,
                @IS_PROPERTY int,
                @IS_FREE_AMOUNT bit,
                @FIRE_AMOUNT float,
                @FIRE_RATE float,
                @SPECT_MAIN_ROW_ID int,
                @IS_FLAG bit,
                @WRK_ROW_ID nvarchar(40),
                @LINE_NUMBER int
            AS
            BEGIN
                -- SET NOCOUNT ON added to prevent extra result sets from
                -- interfering with SELECT statements.
                SET NOCOUNT ON;
            
                INSERT INTO
                        PRODUCTION_ORDERS_STOCKS
                    (
                        P_ORDER_ID,
                        PRODUCT_ID,
                        STOCK_ID,
                        SPECT_MAIN_ID,
                        AMOUNT,
                        TYPE,
                        PRODUCT_UNIT_ID,
                        RECORD_EMP,
                        RECORD_DATE,
                        RECORD_IP,
                        IS_PHANTOM,
                        IS_SEVK,
                        IS_PROPERTY,
                        IS_FREE_AMOUNT,
                        FIRE_AMOUNT,
                        FIRE_RATE,
                        SPECT_MAIN_ROW_ID,
                        IS_FLAG,
                        WRK_ROW_ID,
                        LINE_NUMBER
                    )
                    VALUES
                    (
                        @P_ORDER_ID,
                        @PRODUCT_ID,
                        @STOCK_ID,
                        @SPECT_MAIN_ID,
                        @AMOUNT,
                        @TYPE,
                        @PRODUCT_UNIT_ID,
                        @RECORD_EMP,
                        @RECORD_DATE,
                        @RECORD_IP,
                        @IS_PHANTOM,
                        @IS_SEVK,
                        @IS_PROPERTY,
                        @IS_FREE_AMOUNT,
                        @FIRE_AMOUNT,
                        @FIRE_RATE,
                        @SPECT_MAIN_ROW_ID,
                        @IS_FLAG,
                        @WRK_ROW_ID,
                        @LINE_NUMBER
                    )
            END

CREATE PROCEDURE [@_dsn_company_@].[DEL_ORDER_ROW_RESERVED]
                @cftoken nvarchar(1000)
            AS
            BEGIN
                SET NOCOUNT ON;
                DELETE FROM ORDER_ROW_RESERVED WHERE PRE_ORDER_ID = @cftoken
            END

CREATE PROCEDURE [@_dsn_company_@].[GET_NETBOOK]
                    @action_date datetime,			
                    @process_date datetime,			
                    @db_alias nvarchar(50)
                AS
                BEGIN
                                
                    SET NOCOUNT ON;
                    DECLARE @SQL_TEXT NVARCHAR(500);
                                
                    IF LEN(@db_alias) > 0
                        BEGIN
                            IF @action_date IS NOT NULL
                                BEGIN
                                    SET @SQL_TEXT = 'SELECT TOP 1 NETBOOK_ID FROM '+ @db_alias +'NETBOOKS WHERE STATUS = 1 AND (' + ''''+CONVERT(nvarchar(50),@action_date)+'''' + ' BETWEEN START_DATE AND FINISH_DATE OR ' + ''''+CONVERT(nvarchar(50),@process_date)+'''' + ' BETWEEN START_DATE AND FINISH_DATE)';
                                END
                            ELSE
                                BEGIN
                                    SET @SQL_TEXT = 'SELECT TOP 1 NETBOOK_ID FROM '+ @db_alias +'NETBOOKS WHERE STATUS = 1 AND ' + ''''+CONVERT(nvarchar(50),@process_date)+'''' + ' BETWEEN START_DATE AND FINISH_DATE';
                                END
                        END
                                
                    ELSE
                        BEGIN
                            IF @action_date IS NOT NULL
                                BEGIN
                                    SET @SQL_TEXT = 'SELECT TOP 1 NETBOOK_ID FROM NETBOOKS WHERE STATUS = 1 AND (' + ''''+CONVERT(nvarchar(50),@action_date)+'''' + ' BETWEEN START_DATE AND FINISH_DATE OR ' + ''''+CONVERT(nvarchar(50),@process_date)+'''' + ' BETWEEN START_DATE AND FINISH_DATE)';
                                END
                            ELSE
                                BEGIN
                                    SET @SQL_TEXT = 'SELECT TOP 1 NETBOOK_ID FROM NETBOOKS WHERE STATUS = 1 AND ' + ''''+CONVERT(nvarchar(50),@process_date)+'''' + ' BETWEEN START_DATE AND FINISH_DATE';
                                END
                        END
                                
                    exec (@SQL_TEXT); 
                END

CREATE PROCEDURE [@_dsn_company_@].[GET_PRODUCTION_ORDER_MAX]
                @wrk_id_new nvarchar(40)
            AS
            BEGIN
                SET NOCOUNT ON;
                    SELECT
                        P_ORDER_ID PID,
                        IS_DEMONTAJ,
                        QUANTITY AMOUNT
                    FROM
                        PRODUCTION_ORDERS
                    WHERE
                        WRK_ROW_ID = @wrk_id_new
            END

CREATE PROCEDURE [@_dsn_company_@].[GET_PRODUCTION_ORDER_RESULT_MAX_ID]
            AS
            BEGIN
                SET NOCOUNT ON;
                    SELECT MAX(PR_ORDER_ID) AS MAX_ID FROM PRODUCTION_ORDER_RESULTS
            END

CREATE PROCEDURE [@_dsn_company_@].[GET_SUB_PRODUCT_FIRE] 
                 @spect_main_id___ int
            AS
            BEGIN
                -- SET NOCOUNT ON added to prevent extra result sets from
                -- interfering with SELECT statements.
                SET NOCOUNT ON;
            
                        SELECT
                            SPECT_MAIN_ROW.RELATED_MAIN_SPECT_ID,
                            CASE WHEN (ISNULL(SPECT_MAIN_ROW.FIRE_AMOUNT,0) <> 0)
                            THEN
                                SPECT_MAIN_ROW.FIRE_AMOUNT
                            ELSE
                                CASE WHEN (ISNULL(SPECT_MAIN_ROW.FIRE_RATE,0) <> 0)
                                THEN
                                SPECT_MAIN_ROW.AMOUNT*SPECT_MAIN_ROW.FIRE_RATE/100
                                ELSE
                                SPECT_MAIN_ROW.AMOUNT
                                END
                            END AS AMOUNT ,
                            ISNULL(SPECT_MAIN_ROW.IS_FREE_AMOUNT,0) AS IS_FREE_AMOUNT,
                            STOCKS.PRODUCT_ID,
                            STOCKS.STOCK_ID,
                            PRODUCT_UNIT.PRODUCT_UNIT_ID,
                            SPECT_MAIN_ROW.IS_SEVK,
                            SPECT_MAIN_ROW.IS_PROPERTY,
                            ISNULL(SPECT_MAIN_ROW.FIRE_AMOUNT,0) FIRE_AMOUNT,
                            ISNULL(SPECT_MAIN_ROW.FIRE_RATE,0) FIRE_RATE,
                            SPECT_MAIN_ROW.SPECT_MAIN_ROW_ID,
                            SPECT_MAIN_ROW.LINE_NUMBER
                        FROM
                            SPECT_MAIN,
                            SPECT_MAIN_ROW,
                            STOCKS,
                            PRODUCT_UNIT,
                            PRICE_STANDART
                        WHERE
                            PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
                            PRICE_STANDART.PURCHASESALES = 1 AND
                            PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID AND
                            STOCKS.STOCK_STATUS = 1	AND
                            ISNULL(IS_PHANTOM,0) = 0 AND
                            SPECT_MAIN.SPECT_MAIN_ID = @spect_main_id___ AND
                            SPECT_MAIN.SPECT_MAIN_ID = SPECT_MAIN_ROW.SPECT_MAIN_ID AND
                            SPECT_MAIN_ROW.STOCK_ID = STOCKS.STOCK_ID AND
                            (ISNULL(SPECT_MAIN_ROW.FIRE_AMOUNT,0)<>0 OR ISNULL(SPECT_MAIN_ROW.FIRE_RATE,0)<>0)  AND
                            PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
                            STOCKS.PRODUCT_UNIT_ID=PRICE_STANDART.UNIT_ID
            END

CREATE PROCEDURE [@_dsn_company_@].[GET_WORKSTATIONS_PRODUCTS] 
            @_OPERATION_TYPE_ID_  int,
            @production_stock_id int	
            AS
            BEGIN
                -- SET NOCOUNT ON added to prevent extra result sets from
                -- interfering with SELECT statements.
                SET NOCOUNT ON;
                SELECT 
                    WS_ID AS STATION_ID,
                    OPERATION_TYPE_ID,
                    PRODUCTION_TIME 
                FROM
                    WORKSTATIONS_PRODUCTS 
                WHERE 
                    OPERATION_TYPE_ID = @_OPERATION_TYPE_ID_  
                    AND MAIN_STOCK_ID = @production_stock_id
              
            END

CREATE PROCEDURE [@_dsn_company_@].[SP_GET_STOCK_RESERVED]
                @product_id INT
            AS
            BEGIN
                SET NOCOUNT ON;
                
                SELECT SUM(STOCK_AZALT)  AS AZALAN,
                       SUM(STOCK_ARTIR)  AS ARTAN
                FROM   (
                           SELECT SUM(STOCK_AZALT) AS STOCK_AZALT,
                                  SUM(STOCK_ARTIR) AS STOCK_ARTIR,
                                  PRODUCT_ID,
                                  STOCK_ID,
                                  STOCK_CODE,
                                  PROPERTY,
                                  BARCOD,
                                  MAIN_UNIT
                           FROM   (
                                      SELECT SUM((ORR.RESERVE_STOCK_OUT -ORR.STOCK_OUT) * PU.MULTIPLIER) AS 
                                             STOCK_AZALT,
                                             0       AS STOCK_ARTIR,
                                             S.PRODUCT_ID,
                                             S.STOCK_ID,
                                             S.STOCK_CODE,
                                             S.PROPERTY,
                                             S.BARCOD,
                                             PU.MAIN_UNIT,
                                             ORDS.ORDER_ID
                                      FROM   STOCKS     S,
                                             GET_ORDER_ROW_RESERVED_ALL ORR,
                                             ORDERS     ORDS,
                                             PRODUCT_UNIT PU
                                      WHERE  ORR.STOCK_ID = S.STOCK_ID
                                             AND ORDS.RESERVED = 1
                                             AND ORDS.ORDER_STATUS = 1
                                             AND ORR.ORDER_ID = ORDS.ORDER_ID
                                             AND (
                                                     (ORDS.PURCHASE_SALES = 1 AND ORDS.ORDER_ZONE = 0)
                                                     OR (ORDS.PURCHASE_SALES = 0 AND ORDS.ORDER_ZONE = 1)
                                                 )
                                             AND S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID
                                             AND (ORR.RESERVE_STOCK_OUT -ORR.STOCK_OUT) > 0
                                             AND ORR.PRODUCT_ID = @product_id
                                      GROUP BY
                                             S.PRODUCT_ID,
                                             S.STOCK_ID,
                                             S.STOCK_CODE,
                                             S.PROPERTY,
                                             S.BARCOD,
                                             PU.MAIN_UNIT,
                                             ORDS.ORDER_ID
                                      UNION
                                      SELECT 0       AS STOCK_AZALT,
                                             SUM((ORR.RESERVE_STOCK_IN -ORR.STOCK_IN) * PU.MULTIPLIER) AS 
                                             STOCK_ARTIR,
                                             S.PRODUCT_ID,
                                             S.STOCK_ID,
                                             S.STOCK_CODE,
                                             S.PROPERTY,
                                             S.BARCOD,
                                             PU.MAIN_UNIT,
                                             ORDS.ORDER_ID
                                      FROM   STOCKS     S,
                                             GET_ORDER_ROW_RESERVED ORR,
                                             ORDERS     ORDS,
                                             [@_dsn_main_@].STOCKS_LOCATION SL,
                                             PRODUCT_UNIT PU
                                      WHERE  ORR.PRODUCT_ID = @product_id
                                             AND ORR.STOCK_ID = S.STOCK_ID
                                             AND ORDS.RESERVED = 1
                                             AND ORDS.ORDER_STATUS = 1
                                             AND ORR.ORDER_ID = ORDS.ORDER_ID
                                             AND ORDS.PURCHASE_SALES = 0
                                             AND ORDS.ORDER_ZONE = 0
                                             AND ORDS.DELIVER_DEPT_ID = SL.DEPARTMENT_ID
                                             AND ORDS.LOCATION_ID = SL.LOCATION_ID
                                             AND ORDS.DELIVER_DEPT_ID IS NOT NULL
                                             AND SL.NO_SALE = 0
                                             AND S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID
                                             AND (ORR.RESERVE_STOCK_IN -ORR.STOCK_IN) > 0
                                      GROUP BY
                                             S.PRODUCT_ID,
                                             S.STOCK_ID,
                                             S.STOCK_CODE,
                                             S.PROPERTY,
                                             S.BARCOD,
                                             PU.MAIN_UNIT,
                                             ORDS.ORDER_ID
                                      UNION 
                                      SELECT SUM(
                                                 (ORR.RESERVE_STOCK_OUT -ORR.STOCK_OUT) * SR.AMOUNT_VALUE 
                                                 * PU.MULTIPLIER
                                             )       AS STOCK_AZALT,
                                             0       AS STOCK_ARTIR,
                                             S.PRODUCT_ID,
                                             S.STOCK_ID,
                                             S.STOCK_CODE,
                                             S.PROPERTY,
                                             S.BARCOD,
                                             PU.MAIN_UNIT,
                                             ORDS.ORDER_ID
                                      FROM   STOCKS     S,
                                             GET_ORDER_ROW_RESERVED ORR,
                                             ORDERS     ORDS,
                                             SPECTS_ROW SR,
                                             PRODUCT_UNIT PU
                                      WHERE  ORR.PRODUCT_ID = @product_id
                                             AND SR.STOCK_ID = S.STOCK_ID
                                             AND ORR.SPECT_VAR_ID = SR.SPECT_ID
                                             AND SR.IS_SEVK = 1
                                             AND ORDS.RESERVED = 1
                                             AND ORDS.ORDER_STATUS = 1
                                             AND ORR.ORDER_ID = ORDS.ORDER_ID
                                             AND (
                                                     (ORDS.PURCHASE_SALES = 1 AND ORDS.ORDER_ZONE = 0)
                                                     OR (ORDS.PURCHASE_SALES = 0 AND ORDS.ORDER_ZONE = 1)
                                                 )
                                             AND S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID
                                             AND (ORR.RESERVE_STOCK_OUT -ORR.STOCK_OUT) > 0
                                      GROUP BY
                                             S.PRODUCT_ID,
                                             S.STOCK_ID,
                                             S.STOCK_CODE,
                                             S.PROPERTY,
                                             S.BARCOD,
                                             PU.MAIN_UNIT,
                                             ORDS.ORDER_ID
                                      UNION 	
                                      SELECT 0       AS STOCK_AZALT,
                                             SUM(
                                                 (ORR.RESERVE_STOCK_IN -ORR.STOCK_IN) * SR.AMOUNT_VALUE 
                                                 * PU.MULTIPLIER
                                             )       AS STOCK_ARTIR,
                                             S.PRODUCT_ID,
                                             S.STOCK_ID,
                                             S.STOCK_CODE,
                                             S.PROPERTY,
                                             S.BARCOD,
                                             PU.MAIN_UNIT,
                                             ORDS.ORDER_ID
                                      FROM   STOCKS     S,
                                             GET_ORDER_ROW_RESERVED ORR,
                                             ORDERS     ORDS,
                                             SPECTS_ROW SR,
                                             [@_dsn_main_@].STOCKS_LOCATION SL,
                                             PRODUCT_UNIT PU
                                      WHERE  ORR.PRODUCT_ID = @product_id
                                             AND SR.STOCK_ID = S.STOCK_ID
                                             AND ORR.SPECT_VAR_ID = SR.SPECT_ID
                                             AND SR.IS_SEVK = 1
                                             AND ORDS.RESERVED = 1
                                             AND ORDS.ORDER_STATUS = 1
                                             AND ORR.ORDER_ID = ORDS.ORDER_ID
                                             AND ORDS.PURCHASE_SALES = 0
                                             AND ORDS.ORDER_ZONE = 0
                                             AND ORDS.DELIVER_DEPT_ID = SL.DEPARTMENT_ID
                                             AND ORDS.LOCATION_ID = SL.LOCATION_ID
                                             AND ORDS.DELIVER_DEPT_ID IS NOT NULL
                                             AND SL.NO_SALE = 0
                                             AND S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID
                                             AND (ORR.RESERVE_STOCK_IN -ORR.STOCK_IN) > 0
                                      GROUP BY
                                             S.PRODUCT_ID,
                                             S.STOCK_ID,
                                             S.STOCK_CODE,
                                             S.PROPERTY,
                                             S.BARCOD,
                                             PU.MAIN_UNIT,
                                             ORDS.ORDER_ID
                                      UNION
                                      SELECT SUM((ORR.RESERVE_STOCK_OUT -ORR.STOCK_OUT) * PU.MULTIPLIER) AS 
                                             STOCK_AZALT,
                                             SUM((ORR.RESERVE_STOCK_IN -ORR.STOCK_IN) * PU.MULTIPLIER) AS 
                                             STOCK_ARTIR,
                                             S.PRODUCT_ID,
                                             S.STOCK_ID,
                                             S.STOCK_CODE,
                                             S.PROPERTY,
                                             S.BARCOD,
                                             PU.MAIN_UNIT,
                                             0          ORDER_ID
                                      FROM   STOCKS     S,
                                             GET_ORDER_ROW_RESERVED ORR,
                                             PRODUCT_UNIT PU
                                      WHERE  ORR.PRODUCT_ID = @product_id
                                             AND ORR.STOCK_ID = S.STOCK_ID
                                             AND ORR.ORDER_ID IS NULL
                                             AND S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID
                                             AND (
                                                     (ORR.RESERVE_STOCK_IN -ORR.STOCK_IN) > 
                                                     0
                                                     OR (ORR.RESERVE_STOCK_OUT -ORR.STOCK_OUT)
                                                        > 0
                                                 )
                                      GROUP BY
                                             S.PRODUCT_ID,
                                             S.STOCK_ID,
                                             S.STOCK_CODE,
                                             S.PROPERTY,
                                             S.BARCOD,
                                             PU.MAIN_UNIT
                                  ) AS GET_STOCK_RESERVED_ROW
                           GROUP BY
                                  PRODUCT_ID,
                                  STOCK_ID,
                                  STOCK_CODE,
                                  PROPERTY,
                                  BARCOD,
                                  MAIN_UNIT
                       )                 AS GET_STOCK_RESERVED
                WHERE  PRODUCT_ID = @product_id
            END

CREATE PROCEDURE [@_dsn_company_@].[SP_GET_STOCK_RESERVED_SPECT] 
                @STOCK_ID_LIST nvarchar(850)
            AS
            BEGIN
                SET NOCOUNT ON;
                SELECT 
                ISNULL(SUM(STOCK_ARTIR),0) AS ARTAN,
                            ISNULL(SUM(STOCK_AZALT),0) AS AZALAN,
                            STOCK_ID,
                            SPECT_MAIN_ID
                FROM	
                (
                                SELECT
                                    SUM((ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT) * PU.MULTIPLIER) AS STOCK_AZALT,
                                    SUM((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) * PU.MULTIPLIER) AS STOCK_ARTIR,
                                    S.PRODUCT_ID, 
                                    S.STOCK_ID,
                                    S.STOCK_CODE, 
                                    S.PROPERTY, 
                                    S.BARCOD, 
                                    PU.MAIN_UNIT,
                                    ORDS.ORDER_ID,
                                    SP.SPECT_MAIN_ID
                                FROM
                                    STOCKS S
                                    JOIN [@_dsn_main_@].FNsplit(@STOCK_ID_LIST,',') as xxx on xxx.item = S.STOCK_ID,
                                    GET_ORDER_ROW_RESERVED ORR,
                                    ORDERS ORDS,
                                    PRODUCT_UNIT PU,
                                    SPECTS SP
                                WHERE
                                    ORR.STOCK_ID = S.STOCK_ID AND 
                                    ORDS.RESERVED = 1 AND 
                                    ORDS.ORDER_STATUS = 1 AND
                                    ORR.ORDER_ID = ORDS.ORDER_ID AND
                                    S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                                    SP.SPECT_VAR_ID=ORR.SPECT_VAR_ID AND
                                    ((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0 OR (ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)>0 )
                                GROUP BY
                                    S.PRODUCT_ID,
                                    S.STOCK_ID,
                                    S.STOCK_CODE,
                                    S.PROPERTY,
                                    S.BARCOD,
                                    PU.MAIN_UNIT,
                                    ORDS.ORDER_ID,
                                    SP.SPECT_MAIN_ID
                            UNION
                                SELECT
                                    SUM((ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT) * PU.MULTIPLIER) AS STOCK_AZALT,
                                    SUM((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) * PU.MULTIPLIER) AS STOCK_ARTIR,
                                    S.PRODUCT_ID, 
                                    S.STOCK_ID,
                                    S.STOCK_CODE, 
                                    S.PROPERTY, 
                                    S.BARCOD, 
                                    PU.MAIN_UNIT,
                                    ORDS.ORDER_ID,
                                    NULL
                                FROM
                                    STOCKS S
                                    JOIN [@_dsn_main_@].FNsplit(@STOCK_ID_LIST,',') as xxx on xxx.item = S.STOCK_ID,
                                    GET_ORDER_ROW_RESERVED ORR,
                                    ORDERS ORDS,
                                    PRODUCT_UNIT PU
                                WHERE
                                    ORR.STOCK_ID = S.STOCK_ID AND 
                                    ORDS.RESERVED = 1 AND 
                                    ORDS.ORDER_STATUS = 1 AND
                                    ORR.ORDER_ID = ORDS.ORDER_ID AND
                                    S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                                    ORR.SPECT_VAR_ID IS NULL AND
                                    ((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0 OR (ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)>0 )
                                GROUP BY
                                    S.PRODUCT_ID,
                                    S.STOCK_ID,
                                    S.STOCK_CODE,
                                    S.PROPERTY,
                                    S.BARCOD,
                                    PU.MAIN_UNIT,
                                    ORDS.ORDER_ID
                            UNION 
                                SELECT
                                    SUM((ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)* SR.AMOUNT_VALUE * PU.MULTIPLIER) AS STOCK_AZALT,
                                    SUM((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) *SR.AMOUNT_VALUE * PU.MULTIPLIER) AS STOCK_ARTIR,
                                    S.PRODUCT_ID,
                                    S.STOCK_ID,
                                    S.STOCK_CODE,
                                    S.PROPERTY,
                                    S.BARCOD, 
                                    PU.MAIN_UNIT,
                                    ORDS.ORDER_ID,
                                    NULL
                                 FROM
                                    STOCKS S
                                    JOIN [@_dsn_main_@].FNsplit(@STOCK_ID_LIST,',') as xxx on xxx.item = S.STOCK_ID,
                                    GET_ORDER_ROW_RESERVED ORR, 
                                    ORDERS ORDS,
                                    SPECTS_ROW SR,
                                    PRODUCT_UNIT PU
                                 WHERE
                                    SR.STOCK_ID = S.STOCK_ID AND 
                                    ORR.SPECT_VAR_ID=SR.SPECT_ID AND
                                    SR.IS_SEVK=1 AND
                                    ORDS.RESERVED = 1 AND
                                    ORDS.ORDER_STATUS = 1 AND
                                    ORR.ORDER_ID = ORDS.ORDER_ID AND
                                    S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
                                    ((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0 OR (ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)>0 )
                                 GROUP BY
                                    S.PRODUCT_ID,
                                    S.STOCK_ID,
                                    S.STOCK_CODE,
                                    S.PROPERTY,
                                    S.BARCOD, 
                                    PU.MAIN_UNIT,
                                    ORDS.ORDER_ID
                ) AS XXXX
                GROUP BY STOCK_ID,SPECT_MAIN_ID
    
            END

CREATE PROCEDURE [@_dsn_company_@].[UPD_GENERAL_PAPERS]
            @system_paper_no_add int
            AS
            BEGIN
                SET NOCOUNT ON;
                    UPDATE 
                        GENERAL_PAPERS
                    SET
                        PRODUCTION_RESULT_NUMBER = @system_paper_no_add
                    WHERE
                        PRODUCTION_RESULT_NUMBER IS NOT NULL
            END

CREATE PROCEDURE [@_dsn_company_@].[UPD_GENERAL_PAPERS_LOT_NUMBER] 
            @lot_system_paper_no_add int
            AS
            BEGIN
                -- SET NOCOUNT ON added to prevent extra result sets from
                -- interfering with SELECT statements.
                SET NOCOUNT ON;
                UPDATE 
                    GENERAL_PAPERS
                SET
                    PRODUCTION_LOT_NUMBER = @lot_system_paper_no_add
                WHERE
                    PRODUCTION_LOT_NUMBER IS NOT NULL
            END

CREATE PROCEDURE [@_dsn_company_@].[UPD_GENERAL_PAPERS_PROD_ORDER_NUMBER]
            @system_paper_no_add int
            AS
            BEGIN
                SET NOCOUNT ON;
                UPDATE 
                    GENERAL_PAPERS
                SET
                    PROD_ORDER_NUMBER = @system_paper_no_add
                WHERE
                    PROD_ORDER_NUMBER IS NOT NULL
            END

CREATE PROCEDURE [@_dsn_company_@].[UPD_PRO_ORDER_LOT_NUMBER]
                @lot_no nvarchar(50),
                @p_order_id int
            AS
            BEGIN
                SET NOCOUNT ON;
                    UPDATE PRODUCTION_ORDERS SET LOT_NO = @lot_no  WHERE P_ORDER_ID = @p_order_id
            END

CREATE PROCEDURE [@_dsn_company_@].[UPD_PROD_ORDER_ROW_SPECT]
                @new_created_spect_id int,
                @new_created_spect_name nvarchar(500),
                @new_created_spect_main_id int ,
                @p_order_id int
                AS
                BEGIN
                    SET NOCOUNT ON;
                    UPDATE 
                                PRODUCTION_ORDER_RESULTS_ROW
                            SET
                                SPECT_ID = @new_created_spect_id,
                                SPECT_NAME = @new_created_spect_name,
                                SPEC_MAIN_ID = @new_created_spect_main_id
                            WHERE
                                TYPE=1 AND 
                                PR_ORDER_ID = @p_order_id
                END

CREATE PROCEDURE [@_dsn_company_@].[UPD_PROD_ORDER_SPECT]
                @new_created_spect_id int,
                @new_created_spect_name nvarchar(500),
                @new_created_spect_main_id int ,
                @p_order_id int
                AS
                BEGIN
                    SET NOCOUNT ON;
                    UPDATE 
                                PRODUCTION_ORDERS
                            SET
                                SPECT_VAR_ID = @new_created_spect_id,
                                SPECT_VAR_NAME = @new_created_spect_name,
                                SPEC_MAIN_ID = @new_created_spect_main_id
                            WHERE
                                P_ORDER_ID =  @p_order_id
                END

CREATE PROCEDURE [@_dsn_company_@].[UPD_PRODUCTION_ORDERS_REF_NO] 
                @ref_no nvarchar(50),
                @p_order_id int
            AS
            BEGIN
                SET NOCOUNT ON;
                    UPDATE PRODUCTION_ORDERS SET REFERENCE_NO = @ref_no  WHERE P_ORDER_ID = @p_order_id
            END