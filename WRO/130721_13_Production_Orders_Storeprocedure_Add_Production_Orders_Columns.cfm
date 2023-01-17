<!-- Description : ADD_PRODUCTION_ORDER tablosuna QUANTITY_2 ve UNIT_2 alanları eklendi.
Developer: Fatih Ekin
Company : Gramoni
Destination: company -->

<querytag>
    ALTER PROCEDURE [ADD_PRODUCTION_ORDER]
    @PO_RELATED_ID int,
    @STOCK_ID int,
    @QUANTITY float,
    @QUANTITY_2 int,
    @UNIT_2 nvarchar(50),
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
                                QUANTITY_2,
                                UNIT_2,
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
                                @QUANTITY_2,
                                @UNIT_2,
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
</querytag>