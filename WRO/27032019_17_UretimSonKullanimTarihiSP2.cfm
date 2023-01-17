<!-- Description : Üretim sonuç sp fire düzenlendi
Developer: Pınar Yıldız
Company : Workcube
Destination: Company-->
<querytag>
         ALTER PROCEDURE [ADD_PRODUCTION_ORDER_RESULT]
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
</querytag>