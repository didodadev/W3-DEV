CREATE PROCEDURE [@_dsn_period_@].[add_multilevel_premium]
			@invoice_id int
		AS
		DECLARE @LEN_REF int;
		DECLARE @LEN_REF2 int;
		DECLARE @REF_POS_CODE int;
		DECLARE @CONSCAT_ID int;
		DECLARE @CONSCAT_ID_2 int;
		DECLARE @PREMIUM_RATE float;
		DECLARE @REF_CODE nvarchar(250);
		DECLARE @REF_CODE_2 nvarchar(250);
		DECLARE @CONS_REF_CODE nvarchar(250);
		DECLARE @MONEY_TYPE nvarchar(20);
		DECLARE @REF_CONS_ID int;
		DECLARE @INV_INDX int;
		DECLARE @INV_CAT int;
		DECLARE @INV_DATE datetime;
		DECLARE @INV_IPTAL bit;
		DECLARE @GROSS_TOTAL float;
		DECLARE @CAMP_ID int;
		SET @INV_INDX = 1;
	
		DELETE FROM 
			INVOICE_MULTILEVEL_PREMIUM 
		WHERE 
			INVOICE_ID = @invoice_id
		SELECT 
			@REF_CONS_ID = CONSUMER_ID,
			@INV_IPTAL = ISNULL(IS_IPTAL,0),
			@INV_CAT = INVOICE_CAT,
			@INV_DATE = INVOICE_DATE,
			@REF_CODE = CONSUMER_REFERENCE_CODE,
			@CONS_REF_CODE = CONSUMER_REFERENCE_CODE
		FROM 
			INVOICE 
		WHERE 
			INVOICE_ID = @invoice_id
	
		SELECT @GROSS_TOTAL= (  SELECT 
									ISNULL(SUM(IR.GROSSTOTAL),0)
								FROM 
									INVOICE_ROW IR,
									[@_dsn_company_@].PRODUCT P
								WHERE 
									IR.INVOICE_ID = @invoice_id AND 
									IR.PRODUCT_ID = P.PRODUCT_ID AND 
									P.IS_INVENTORY = 1);
		SELECT @REF_POS_CODE =( SELECT 
									REF_POS_CODE 
								FROM 
									[@_dsn_main_@].CONSUMER 
								WHERE 
									CONSUMER_ID = @REF_CONS_ID);
		SELECT @CONSCAT_ID   =( SELECT 
									CONSUMER_CAT_ID 
								FROM 
									[@_dsn_main_@].CONSUMER 
								WHERE 
									CONSUMER_ID = @REF_POS_CODE);
		SELECT @MONEY_TYPE= (SELECT 
								MONEY
							FROM 
								SETUP_MONEY
							WHERE 
								RATE1=RATE2);
		SELECT @CAMP_ID = (SELECT TOP 1
							CAMP_ID
						FROM 
							[@_dsn_company_@].CAMPAIGNS 
						WHERE 
							CAMP_STARTDATE < @INV_DATE AND 
							CAMP_FINISHDATE > @INV_DATE);
	
		SET @LEN_REF = (LEN(REPLACE(@REF_CODE,'.','..'))-LEN(@REF_CODE)+1);
		SET @LEN_REF2 = LEN(@REF_CODE);
		IF (@INV_IPTAL <>1)
		BEGIN
			WHILE @INV_INDX <= @LEN_REF
				BEGIN  
	
					IF(CHARINDEX('.',@REF_CODE) <> 0)
						SET @REF_CODE_2 = LEFT(@REF_CODE,CHARINDEX('.',@REF_CODE)-1);
					ELSE
						SET @REF_CODE_2 = @REF_CODE;
					
					SELECT @CONSCAT_ID_2 = (SELECT 
												CONSUMER_CAT_ID 
											FROM 
												[@_dsn_main_@].CONSUMER
											WHERE 
												CONSUMER_ID = @REF_CODE_2);
						
	
					SELECT @PREMIUM_RATE = (SELECT 
												PREMIUM_RATIO
											FROM
												[@_dsn_company_@].SETUP_CONSCAT_PREMIUM  
											WHERE 
												CAMPAIGN_ID = @CAMP_ID AND 
												CONSCAT_ID = @CONSCAT_ID_2 	AND 
												PREMIUM_LEVEL = @LEN_REF - @INV_INDX + 1 AND 
												(REF_MEMBER_CAT = @CONSCAT_ID OR REF_MEMBER_CAT IS NULL));
	
					IF(@PREMIUM_RATE IS NOT NULL)
					BEGIN 
						INSERT INTO	
							INVOICE_MULTILEVEL_PREMIUM
							(					
								CAMPAIGN_ID,
								INVOICE_ID,
								PREMIUM_DATE,
								REF_CONSUMER_ID,
								CONSUMER_ID,
								PREMIUM_LINE,
								PREMIUM_RATE,
								INVOICE_TOTAL,
								PREMIUM_SYSTEM_TOTAL,
								PREMIUM_SYSTEM_MONEY,
								CONSUMER_REFERENCE_CODE,
								PREMIUM_STATUS
							)
						VALUES
							(
								@CAMP_ID,
								@invoice_id,
								@INV_DATE,
								@REF_CONS_ID,
								@REF_CODE_2,
								@LEN_REF - @INV_INDX + 1,
								@PREMIUM_RATE,
								@GROSS_TOTAL,
								@GROSS_TOTAL*@PREMIUM_RATE/100,
								@MONEY_TYPE,
								@CONS_REF_CODE,
								1											
							)
					END;
	
					SET @REF_CODE = SUBSTRING(@REF_CODE,(CHARINDEX('.',@REF_CODE)+1),(@LEN_REF2-CHARINDEX('.',@REF_CODE))); 
					SET @INV_INDX = @INV_INDX+1;
			END;
		END;

CREATE PROCEDURE [@_dsn_period_@].[add_multilevel_sales]
			@invoice_id int
		AS
	DECLARE @LEN_REF int;
		DECLARE @LEN_REF2 int;
		DECLARE @REF_CODE nvarchar(250);
		DECLARE @REF_CODE_2 nvarchar(250);
		DECLARE @REF_CONS_ID int;
		DECLARE @INV_INDX int;
		DECLARE @INV_CAT int;
		DECLARE @INV_DATE datetime;
		DECLARE @INV_IPTAL bit;
		DECLARE @NET_TOTAL float;
		DECLARE @GROSS_TOTAL float;
		DECLARE @INV_NET_TOTAL float;
		DECLARE @INV_GROSS_TOTAL float;
		SET @INV_INDX = 1;
	
		DELETE FROM 
			INVOICE_MULTILEVEL_SALES 
		WHERE 
			INVOICE_ID = @invoice_id
	
		SELECT 
			@INV_IPTAL = ISNULL(IS_IPTAL,0),
			@INV_CAT = INVOICE_CAT,
			@INV_DATE = INVOICE_DATE,
			@REF_CODE = CONSUMER_REFERENCE_CODE,
			@REF_CONS_ID = CONSUMER_ID		
		FROM 
			INVOICE 
		WHERE 
			INVOICE_ID = @invoice_id
	
		SELECT @NET_TOTAL= (SELECT 
					ISNULL(SUM(IR.NETTOTAL),0)
				FROM 
					INVOICE_ROW IR,
					[@_dsn_company_@].PRODUCT P 
				WHERE 
					IR.INVOICE_ID = @invoice_id AND 
					IR.PRODUCT_ID = P.PRODUCT_ID AND 
					(P.IS_INVENTORY = 1 OR P.IS_KARMA = 1));
		SELECT @GROSS_TOTAL= (SELECT 
					ISNULL(SUM(IR.GROSSTOTAL),0)
				FROM 
					INVOICE_ROW IR,
					[@_dsn_company_@].PRODUCT P 
				WHERE 
					IR.INVOICE_ID = @invoice_id AND 
					IR.PRODUCT_ID = P.PRODUCT_ID AND 
					(P.IS_INVENTORY = 1 OR P.IS_KARMA = 1));
		SELECT @INV_NET_TOTAL= (SELECT 
					ISNULL(SUM(IR.NETTOTAL),0)
				FROM 
					INVOICE_ROW IR
				WHERE 
					IR.INVOICE_ID = @invoice_id);
		SELECT @INV_GROSS_TOTAL= (SELECT 
					ISNULL(SUM(IR.GROSSTOTAL),0)
				FROM 
					INVOICE_ROW IR
				WHERE 
					IR.INVOICE_ID = @invoice_id);
		SET @LEN_REF = (LEN(REPLACE(@REF_CODE,'.','..'))-LEN(@REF_CODE)+1);
		SET @LEN_REF2 = LEN(@REF_CODE);
		IF (@INV_IPTAL <>1)
		BEGIN
			WHILE @INV_INDX <= @LEN_REF
				BEGIN  
					IF(CHARINDEX('.',@REF_CODE) <> 0)
						SET @REF_CODE_2 = LEFT(@REF_CODE,CHARINDEX('.',@REF_CODE)-1);
					ELSE
						SET @REF_CODE_2 = @REF_CODE;
					INSERT INTO	
						INVOICE_MULTILEVEL_SALES
						(					
							INVOICE_ID,
							INVOICE_CAT,
							INVOICE_DATE,
							REF_CONSUMER_ID,
							CONSUMER_ID,
							GROSSTOTAL,
							NETTOTAL,
							INV_GROSSTOTAL,
							INV_NETTOTAL,
							SALE_STAGE
						)
					VALUES
						(
							@invoice_id,
							@INV_CAT,
							@INV_DATE,
							@REF_CONS_ID,
							@REF_CODE_2,
							@GROSS_TOTAL,
							@NET_TOTAL,
							@INV_GROSS_TOTAL,
							@INV_NET_TOTAL,
							@LEN_REF - @INV_INDX + 1					
						)
					SET @REF_CODE = SUBSTRING(@REF_CODE,(CHARINDEX('.',@REF_CODE)+1),(@LEN_REF2-CHARINDEX('.',@REF_CODE))); 
					SET @INV_INDX = @INV_INDX+1;
			END;
		END;

CREATE PROCEDURE [@_dsn_period_@].[DEL_COST_PRODUCT]
		@del_product_cost_id int
        AS
        BEGIN
            SET NOCOUNT ON;
            DELETE FROM [@_dsn_product_@].PRODUCT_COST WHERE PRODUCT_COST_ID = @del_product_cost_id
            DELETE FROM PRODUCT_COST_REFERENCE WHERE PRODUCT_COST_ID = @del_product_cost_id
        END

CREATE PROCEDURE [@_dsn_period_@].[DEL_COST_SHIP]
            @del_ship_id_list nvarchar(max),
            @del_cost_period_id INT,
            @paper_product_id_ INT
        AS
        BEGIN
            SET NOCOUNT ON;
            IF @paper_product_id_<> 0
                BEGIN
                    exec('DELETE FROM [@_dsn_product_@].PRODUCT_COST WHERE ACTION_ID  IN ('+@del_ship_id_list+') AND ACTION_TYPE = 2 AND ACTION_PERIOD_ID ='+ @del_cost_period_id+' AND PRODUCT_ID ='+ @paper_product_id_+'');
                END
            ELSE
                BEGIN
                    exec('DELETE FROM [@_dsn_product_@].PRODUCT_COST WHERE ACTION_ID IN ('+@del_ship_id_list+') AND ACTION_TYPE = 2 AND ACTION_PERIOD_ID ='+ @del_cost_period_id+''); 		
                END
                    exec('DELETE FROM PRODUCT_COST_REFERENCE WHERE ACTION_ID IN ('+@del_ship_id_list+') AND ACTION_TYPE = 2');
        END

CREATE PROCEDURE [@_dsn_period_@].[GET_ACCOUNT_PLAN]
				@is_xml bit,
				@account_code NVARCHAR(50),
				@startrow int,
				@maxrows int
			AS
			BEGIN
				
				SET NOCOUNT ON;
			
			   IF @is_xml = 1
					BEGIN
						IF LEN (@account_code) > 0 
							BEGIN
								IF isnumeric(left(@account_code,3)) = 1 
									BEGIN
										WITH CTE1 AS (
												SELECT
													SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC - ACCOUNT_ACCOUNT_REMAINDER.ALACAK) AS BAKIYE,
													ACCOUNT_PLAN.ACCOUNT_CODE, 
													ACCOUNT_PLAN.ACCOUNT_CODE2, 
													ACCOUNT_PLAN.ACCOUNT_NAME,
													ACCOUNT_PLAN.ACCOUNT_ID,
													ACCOUNT_PLAN.SUB_ACCOUNT,
													ACCOUNT_PLAN.IFRS_CODE, 
													ACCOUNT_PLAN.IFRS_NAME
												FROM
													ACCOUNT_PLAN
													LEFT JOIN ACCOUNT_ACCOUNT_REMAINDER ON 
													(
														(ACCOUNT_PLAN.SUB_ACCOUNT =1  AND ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID LIKE ACCOUNT_PLAN.ACCOUNT_CODE +'.%') 
														OR
														(ACCOUNT_PLAN.SUB_ACCOUNT=0 AND ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID = ACCOUNT_PLAN.ACCOUNT_CODE)
													)
												WHERE
													ACCOUNT_PLAN.ACCOUNT_ID IS NOT NULL
													AND ACCOUNT_PLAN.ACCOUNT_CODE LIKE ''+@account_code+'%'
												GROUP BY
													ACCOUNT_PLAN.ACCOUNT_CODE, 
													ACCOUNT_PLAN.ACCOUNT_CODE2, 
													ACCOUNT_PLAN.ACCOUNT_NAME,
													ACCOUNT_PLAN.SUB_ACCOUNT,
													ACCOUNT_PLAN.IFRS_CODE, 
													ACCOUNT_PLAN.IFRS_NAME,
													ACCOUNT_PLAN.ACCOUNT_ID
												),
				
											CTE2 AS (
													SELECT
														CTE1.*,
														ROW_NUMBER() OVER (ORDER BY ACCOUNT_CODE asc) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
													FROM
														CTE1
												)
												SELECT
													CTE2.*
												FROM
													CTE2
												WHERE
													RowNum BETWEEN @startrow and @startrow+(@maxrows-1)
									END
								ELSE
									BEGIN
										WITH CTE1 AS (
												SELECT
													SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC - ACCOUNT_ACCOUNT_REMAINDER.ALACAK) AS BAKIYE,
													ACCOUNT_PLAN.ACCOUNT_CODE, 
													ACCOUNT_PLAN.ACCOUNT_CODE2, 
													ACCOUNT_PLAN.ACCOUNT_NAME,
													ACCOUNT_PLAN.ACCOUNT_ID,
													ACCOUNT_PLAN.SUB_ACCOUNT,
													ACCOUNT_PLAN.IFRS_CODE, 
													ACCOUNT_PLAN.IFRS_NAME
												FROM
													ACCOUNT_PLAN
													LEFT JOIN ACCOUNT_ACCOUNT_REMAINDER ON 
													(
														(ACCOUNT_PLAN.SUB_ACCOUNT =  1 AND ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID LIKE ACCOUNT_PLAN.ACCOUNT_CODE +'.%') OR
														(ACCOUNT_PLAN.SUB_ACCOUNT=0 AND ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID = ACCOUNT_PLAN.ACCOUNT_CODE)
													)
												WHERE
													ACCOUNT_PLAN.ACCOUNT_ID IS NOT NULL
													AND ACCOUNT_PLAN.ACCOUNT_NAME LIKE '%'+@account_code+'%'
												GROUP BY
													ACCOUNT_PLAN.ACCOUNT_CODE, 
													ACCOUNT_PLAN.ACCOUNT_CODE2, 
													ACCOUNT_PLAN.ACCOUNT_NAME,
													ACCOUNT_PLAN.SUB_ACCOUNT,
													ACCOUNT_PLAN.IFRS_CODE, 
													ACCOUNT_PLAN.IFRS_NAME,
													ACCOUNT_PLAN.ACCOUNT_ID
												),
				
											CTE2 AS (
													SELECT
														CTE1.*,
														ROW_NUMBER() OVER (ORDER BY ACCOUNT_CODE asc) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
													FROM
														CTE1
												)
												SELECT
													CTE2.*
												FROM
													CTE2
												WHERE
													RowNum BETWEEN @startrow and @startrow+(@maxrows-1)
									END
							END
						ELSE
							BEGIN
								WITH CTE1 AS (
												SELECT
													SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC - ACCOUNT_ACCOUNT_REMAINDER.ALACAK) AS BAKIYE,
													ACCOUNT_PLAN.ACCOUNT_CODE, 
													ACCOUNT_PLAN.ACCOUNT_CODE2, 
													ACCOUNT_PLAN.ACCOUNT_NAME,
													ACCOUNT_PLAN.ACCOUNT_ID,
													ACCOUNT_PLAN.SUB_ACCOUNT,
													ACCOUNT_PLAN.IFRS_CODE, 
													ACCOUNT_PLAN.IFRS_NAME
												FROM
													ACCOUNT_PLAN
													LEFT JOIN ACCOUNT_ACCOUNT_REMAINDER ON 
													(
														(ACCOUNT_PLAN.SUB_ACCOUNT = 1 AND ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID LIKE ACCOUNT_PLAN.ACCOUNT_CODE +'.%') OR
														(ACCOUNT_PLAN.SUB_ACCOUNT=0 AND ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID = ACCOUNT_PLAN.ACCOUNT_CODE)
													)
												WHERE
													ACCOUNT_PLAN.ACCOUNT_ID IS NOT NULL
												GROUP BY
													ACCOUNT_PLAN.ACCOUNT_CODE, 
													ACCOUNT_PLAN.ACCOUNT_CODE2, 
													ACCOUNT_PLAN.ACCOUNT_NAME,
													ACCOUNT_PLAN.SUB_ACCOUNT,
													ACCOUNT_PLAN.IFRS_CODE, 
													ACCOUNT_PLAN.IFRS_NAME,
													ACCOUNT_PLAN.ACCOUNT_ID
												),
				
										CTE2 AS (
													SELECT
														CTE1.*,
														ROW_NUMBER() OVER (ORDER BY ACCOUNT_CODE asc) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
													FROM
														CTE1
												)
												SELECT
													CTE2.*
												FROM
													CTE2
												WHERE
													RowNum BETWEEN @startrow and @startrow+(@maxrows-1)
							END
					END
			
				ELSE
					BEGIN
						IF LEN (@account_code) > 0 
							BEGIN
								IF isnumeric(left(@account_code,3)) = 1 
									BEGIN
										WITH CTE1 AS (
												SELECT
													ACCOUNT_PLAN.ACCOUNT_CODE, 
													ACCOUNT_PLAN.ACCOUNT_CODE2, 
													ACCOUNT_PLAN.ACCOUNT_NAME,
													ACCOUNT_PLAN.ACCOUNT_ID,
													ACCOUNT_PLAN.SUB_ACCOUNT,
													ACCOUNT_PLAN.IFRS_CODE, 
													ACCOUNT_PLAN.IFRS_NAME
												FROM
													ACCOUNT_PLAN
												WHERE
													ACCOUNT_PLAN.ACCOUNT_ID IS NOT NULL
													AND ACCOUNT_PLAN.ACCOUNT_CODE LIKE ''+@account_code+'%'
												GROUP BY
													ACCOUNT_PLAN.ACCOUNT_CODE, 
													ACCOUNT_PLAN.ACCOUNT_CODE2, 
													ACCOUNT_PLAN.ACCOUNT_NAME,
													ACCOUNT_PLAN.SUB_ACCOUNT,
													ACCOUNT_PLAN.IFRS_CODE, 
													ACCOUNT_PLAN.IFRS_NAME,
													ACCOUNT_PLAN.ACCOUNT_ID
												),
				
											CTE2 AS (
													SELECT
														CTE1.*,
														ROW_NUMBER() OVER (ORDER BY ACCOUNT_CODE asc) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
													FROM
														CTE1
												)
												SELECT
													CTE2.*
												FROM
													CTE2
												WHERE
													RowNum BETWEEN @startrow and @startrow+(@maxrows-1)
									END
								ELSE
									BEGIN
										WITH CTE1 AS (
												SELECT
													ACCOUNT_PLAN.ACCOUNT_CODE, 
													ACCOUNT_PLAN.ACCOUNT_CODE2, 
													ACCOUNT_PLAN.ACCOUNT_NAME,
													ACCOUNT_PLAN.ACCOUNT_ID,
													ACCOUNT_PLAN.SUB_ACCOUNT,
													ACCOUNT_PLAN.IFRS_CODE, 
													ACCOUNT_PLAN.IFRS_NAME
												FROM
													ACCOUNT_PLAN
												WHERE
													ACCOUNT_PLAN.ACCOUNT_ID IS NOT NULL
													AND ACCOUNT_PLAN.ACCOUNT_NAME LIKE '%'+@account_code+'%'
												GROUP BY
													ACCOUNT_PLAN.ACCOUNT_CODE, 
													ACCOUNT_PLAN.ACCOUNT_CODE2, 
													ACCOUNT_PLAN.ACCOUNT_NAME,
													ACCOUNT_PLAN.SUB_ACCOUNT,
													ACCOUNT_PLAN.IFRS_CODE, 
													ACCOUNT_PLAN.IFRS_NAME,
													ACCOUNT_PLAN.ACCOUNT_ID
												),
				
											CTE2 AS (
													SELECT
														CTE1.*,
														ROW_NUMBER() OVER (ORDER BY ACCOUNT_CODE asc) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
													FROM
														CTE1
												)
												SELECT
													CTE2.*
												FROM
													CTE2
												WHERE
													RowNum BETWEEN @startrow and @startrow+(@maxrows-1)
									END
							END
						ELSE
							BEGIN
								WITH CTE1 AS (
												SELECT
													ACCOUNT_PLAN.ACCOUNT_CODE, 
													ACCOUNT_PLAN.ACCOUNT_CODE2, 
													ACCOUNT_PLAN.ACCOUNT_NAME,
													ACCOUNT_PLAN.ACCOUNT_ID,
													ACCOUNT_PLAN.SUB_ACCOUNT,
													ACCOUNT_PLAN.IFRS_CODE, 
													ACCOUNT_PLAN.IFRS_NAME
												FROM
													ACCOUNT_PLAN
												WHERE
													ACCOUNT_PLAN.ACCOUNT_ID IS NOT NULL
												GROUP BY
													ACCOUNT_PLAN.ACCOUNT_CODE, 
													ACCOUNT_PLAN.ACCOUNT_CODE2, 
													ACCOUNT_PLAN.ACCOUNT_NAME,
													ACCOUNT_PLAN.SUB_ACCOUNT,
													ACCOUNT_PLAN.IFRS_CODE, 
													ACCOUNT_PLAN.IFRS_NAME,
													ACCOUNT_PLAN.ACCOUNT_ID
												),
				
										CTE2 AS (
													SELECT
														CTE1.*,
														ROW_NUMBER() OVER (ORDER BY ACCOUNT_CODE asc) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
													FROM
														CTE1
												)
												SELECT
													CTE2.*
												FROM
													CTE2
												WHERE
													RowNum BETWEEN @startrow and @startrow+(@maxrows-1)
							END
					END
			END

CREATE PROCEDURE [@_dsn_period_@].[GET_ACTION] 
            @recordcount int ,
            @IS_WITH_SHIP BIT,
            @paper_product_id int, 
            @paper_action_id int,
            @paper_action_type int,
            @cost_money_system_2 NVARCHAR(50) 
        AS
        BEGIN
            
            SET NOCOUNT ON;
                        
                    IF @paper_action_type = 1
                        BEGIN 
                            IF (@recordcount = 1 )
                                BEGIN
                                    IF @IS_WITH_SHIP = 0
                                        BEGIN
                                                SELECT
                                                    SHIP.SHIP_ID,
                                                    INVOICE_ROW.INVOICE_ROW_ID ACTION_ROW_ID,
                                                    INVOICE.RECORD_DATE INSERT_DATE,
                                                    INVOICE.INVOICE_DATE PAPER_DATE,
                                                    ISNULL(SHIP.DELIVER_DATE,SHIP.SHIP_DATE) ACTION_DATE,
                                                    INVOICE_ROW.AMOUNT AMOUNT,
                                                    INVOICE_ROW.SPECT_VAR_ID SPEC_ID,
                                                    STOCKS.STOCK_ID,
                                                    STOCKS.PRODUCT_ID,
                                                    INVOICE.PROCESS_CAT,
                                                    INVOICE.DEPARTMENT_ID ACTION_DEPARTMENT_ID,
                                                    INVOICE.DEPARTMENT_LOCATION ACTION_LOCATION_ID,
                                                    INVOICE_ROW.DUE_DATE,
                                                    INVOICE.INVOICE_DATE
                                                FROM
                                                    SHIP,
                                                    INVOICE,
                                                    INVOICE_ROW,
                                                    [@_dsn_product_@].STOCKS STOCKS,
                                                    [@_dsn_product_@].PRODUCT PRODUCT
                                                WHERE
                                                    INVOICE.INVOICE_ID =@paper_action_id AND
                                                    INVOICE.INVOICE_ID=INVOICE_ROW.INVOICE_ID AND
                                                    INVOICE_ROW.SHIP_ID=SHIP.SHIP_ID AND
                                                    STOCKS.STOCK_ID=INVOICE_ROW.STOCK_ID AND
                                                    STOCKS.PRODUCT_ID=PRODUCT.PRODUCT_ID AND
                                                    PRODUCT.IS_COST=1
                                                ORDER BY
                                                    ISNULL(SHIP.DELIVER_DATE,SHIP.SHIP_DATE),
                                                    STOCKS.PRODUCT_ID,
                                                    INVOICE_ROW.INVOICE_ROW_ID
                                        END
        
                                    ELSE
                                        BEGIN
                                            SELECT
                                                SHIP.SHIP_ID,
                                                INVOICE_ROW.INVOICE_ROW_ID ACTION_ROW_ID,
                                                INVOICE.RECORD_DATE INSERT_DATE,
                                                INVOICE.INVOICE_DATE PAPER_DATE,
                                                ISNULL(SHIP.DELIVER_DATE,SHIP.SHIP_DATE) ACTION_DATE,
                                                INVOICE_ROW.AMOUNT AMOUNT,
                                                INVOICE_ROW.SPECT_VAR_ID SPEC_ID,
                                                STOCKS.STOCK_ID,
                                                STOCKS.PRODUCT_ID,
                                                INVOICE.PROCESS_CAT,
                                                INVOICE.DEPARTMENT_ID ACTION_DEPARTMENT_ID,
                                                INVOICE.DEPARTMENT_LOCATION ACTION_LOCATION_ID,
                                                INVOICE_ROW.DUE_DATE,
                                                INVOICE.INVOICE_DATE
                                            FROM
                                                SHIP,
                                                INVOICE,
                                                INVOICE_ROW,
                                                INVOICE_SHIPS,
                                                [@_dsn_product_@].STOCKS STOCKS,
                                                [@_dsn_product_@].PRODUCT PRODUCT
                                            WHERE
                                                INVOICE.INVOICE_ID = @paper_action_id AND
                                                INVOICE.INVOICE_ID=INVOICE_ROW.INVOICE_ID AND
                                                INVOICE_SHIPS.SHIP_ID=SHIP.SHIP_ID AND
                                                INVOICE_SHIPS.INVOICE_ID=INVOICE.INVOICE_ID AND
                                                STOCKS.STOCK_ID=INVOICE_ROW.STOCK_ID AND
                                                STOCKS.PRODUCT_ID=PRODUCT.PRODUCT_ID AND
                                                PRODUCT.IS_COST=1 
                                            ORDER BY
                                                ISNULL(SHIP.DELIVER_DATE,SHIP.SHIP_DATE),
                                                STOCKS.PRODUCT_ID,
                                                INVOICE_ROW.INVOICE_ROW_ID
                                        END
                                END
                            ELSE
                                BEGIN
                                        SELECT DISTINCT
                                            1 INV_CONT_COMP,
                                            SHIP.SHIP_ID,
                                            INVOICE.INVOICE_ID,
                                            INVOICE_ROW.INVOICE_ROW_ID ACTION_ROW_ID,
                                            INVOICE.RECORD_DATE INSERT_DATE,
                                            INVOICE.INVOICE_DATE PAPER_DATE,
                                            ISNULL(SHIP.DELIVER_DATE,SHIP.SHIP_DATE) ACTION_DATE,
                                            INVOICE_ROW.AMOUNT AMOUNT,
                                            INVOICE_ROW.SPECT_VAR_ID SPEC_ID,
                                            STOCKS.STOCK_ID,
                                            STOCKS.PRODUCT_ID,
                                            INVOICE.PROCESS_CAT,
                                            INVOICE.DEPARTMENT_ID ACTION_DEPARTMENT_ID,
                                            INVOICE.DEPARTMENT_LOCATION ACTION_LOCATION_ID,
                                            INVOICE_ROW.DUE_DATE,
                                            INVOICE.INVOICE_DATE
                                        FROM
                                            SHIP,
                                            INVOICE,
                                            INVOICE_ROW,
                                            INVOICE_SHIPS,
                                            INVOICE_CONTRACT_COMPARISON,
                                            [@_dsn_product_@].STOCKS STOCKS,
                                            [@_dsn_product_@].PRODUCT PRODUCT
                                        WHERE
                                            INVOICE_CONTRACT_COMPARISON.DIFF_INVOICE_ID =@paper_action_id AND
                                            INVOICE.INVOICE_ID=INVOICE_CONTRACT_COMPARISON.MAIN_INVOICE_ID AND
                                            INVOICE.INVOICE_ID=INVOICE_ROW.INVOICE_ID AND
                                            INVOICE_SHIPS.SHIP_ID=SHIP.SHIP_ID AND
                                            INVOICE_SHIPS.INVOICE_ID=INVOICE.INVOICE_ID AND
                                            STOCKS.STOCK_ID=INVOICE_ROW.STOCK_ID AND
                                            STOCKS.PRODUCT_ID=PRODUCT.PRODUCT_ID AND
                                            PRODUCT.IS_COST=1
        
                                        ORDER BY
                                            ISNULL(SHIP.DELIVER_DATE,SHIP.SHIP_DATE),
                                            STOCKS.PRODUCT_ID,
                                            INVOICE_ROW.INVOICE_ROW_ID
                                END
                        END
                    ELSE
                        IF  @paper_action_type = 2
                            BEGIN
                                SELECT
                                    SHIP.SHIP_ID,
                                    SHIP_ROW.SHIP_ROW_ID ACTION_ROW_ID,
                                    SHIP.RECORD_DATE INSERT_DATE,
                                    SHIP.SHIP_DATE PAPER_DATE,
                                    SHIP.DELIVER_DATE ACTION_DATE,
                                    SHIP_ROW.AMOUNT AMOUNT,
                                    SHIP_ROW.SPECT_VAR_ID SPEC_ID,
                                    STOCKS.STOCK_ID,
                                    STOCKS.PRODUCT_ID,
                                    SHIP.PROCESS_CAT,
                                    ISNULL(SHIP.DEPARTMENT_IN,SHIP.DELIVER_STORE_ID) ACTION_DEPARTMENT_ID,
                                    ISNULL(SHIP.LOCATION_IN,SHIP.LOCATION) ACTION_LOCATION_ID
                                FROM 
                                    SHIP,
                                    SHIP_ROW,
                                    [@_dsn_product_@].STOCKS STOCKS,
                                    [@_dsn_product_@].PRODUCT PRODUCT
                                WHERE
                                    SHIP.SHIP_ID = @paper_action_id AND
                                    SHIP.SHIP_ID = SHIP_ROW.SHIP_ID AND
                                    STOCKS.STOCK_ID = SHIP_ROW.STOCK_ID AND
                                    STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
                                    PRODUCT.IS_COST = 1
                                ORDER BY
                                    STOCKS.PRODUCT_ID,
                                    SHIP_ROW.SHIP_ROW_ID
                            END
                        ELSE
                            IF @paper_action_type = 3
                                BEGIN
                                    SELECT
                                        STOCK_FIS_ROW.STOCK_FIS_ROW_ID ACTION_ROW_ID,
                                        STOCK_FIS.RECORD_DATE INSERT_DATE,
                                        STOCK_FIS.FIS_DATE PAPER_DATE,
                                        STOCK_FIS.FIS_DATE ACTION_DATE,
                                        STOCK_FIS_ROW.AMOUNT AMOUNT,
                                        STOCK_FIS_ROW.SPECT_VAR_ID SPEC_ID,
                                        STOCKS.STOCK_ID,
                                        STOCKS.PRODUCT_ID,
                                        STOCK_FIS.PROCESS_CAT,
                                        STOCK_FIS.DEPARTMENT_IN ACTION_DEPARTMENT_ID,
                                        STOCK_FIS.LOCATION_IN ACTION_LOCATION_ID,
                                        ISNULL(STOCK_FIS_ROW.DUE_DATE,0) DUE_DATE,
                                        STOCK_FIS_ROW.RESERVE_DATE
                                    FROM 
                                        STOCK_FIS,
                                        STOCK_FIS_ROW,
                                        [@_dsn_product_@].STOCKS STOCKS,
                                        [@_dsn_product_@].PRODUCT PRODUCT
                                    WHERE
                                        STOCK_FIS.FIS_ID = @paper_action_id AND
                                        STOCK_FIS.FIS_ID = STOCK_FIS_ROW.FIS_ID AND
                                        STOCKS.STOCK_ID = STOCK_FIS_ROW.STOCK_ID AND
                                        STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
                                        PRODUCT.IS_COST=1 
                                    ORDER BY
                                        STOCKS.PRODUCT_ID,STOCK_FIS_ROW.STOCK_FIS_ROW_ID	
                                END
                            ELSE
                                IF @paper_action_type = 4
                                    BEGIN
                                            SELECT
                                                PORR.PR_ORDER_ROW_ID ACTION_ROW_ID,
                                                ISNULL(POR.UPDATE_DATE,POR.RECORD_DATE) INSERT_DATE,
                                                POR.FINISH_DATE PAPER_DATE,
                                                POR.FINISH_DATE ACTION_DATE,
                                                PORR.AMOUNT,
                                                PORR.SPECT_ID SPEC_ID,
                                                PORR.SPEC_MAIN_ID EXCHANGE_SPECT_MAIN_ID,
                                                (PORR.PURCHASE_NET_SYSTEM++ISNULL(PORR.PURCHASE_EXTRA_COST_SYSTEM,0)) PURCHASE_NET_SYSTEM,
                                                PORR.PURCHASE_NET_SYSTEM_MONEY,
                                                (ISNULL(PORR.LABOR_COST_SYSTEM,0)+ISNULL(PORR.STATION_REFLECTION_COST_SYSTEM,0)) AS PURCHASE_EXTRA_COST_SYSTEM,
                                                STOCKS.STOCK_ID,
                                                STOCKS.PRODUCT_ID,
                                                POR.PROCESS_ID PROCESS_CAT,
                                                POR.PRODUCTION_DEP_ID ACTION_DEPARTMENT_ID,
                                                POR.PRODUCTION_LOC_ID ACTION_LOCATION_ID
                                            FROM 
                                                PRODUCTION_ORDERS PO,
                                                PRODUCTION_ORDER_RESULTS POR,
                                                PRODUCTION_ORDER_RESULTS_ROW PORR,
                                                [@_dsn_product_@].STOCKS STOCKS,
                                                [@_dsn_product_@].PRODUCT PRODUCT
                                            WHERE
                                                POR.PR_ORDER_ID = @paper_action_id AND
                                                PO.P_ORDER_ID = POR.P_ORDER_ID AND
                                                POR.PR_ORDER_ID = PORR.PR_ORDER_ID AND
                                                STOCKS.STOCK_ID = PORR.STOCK_ID AND
                                                STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
                                                PRODUCT.IS_COST = 1 AND
                                                PORR.TYPE = 1 AND
                                                ISNULL(PORR.IS_FREE_AMOUNT,0) <> 1 AND
                                                PO.IS_DEMONTAJ <> 1
                                            ORDER BY
                                                STOCKS.PRODUCT_ID,PORR.PR_ORDER_ROW_ID
                                    END
                                ELSE
                                    IF @paper_action_type = 5 OR @paper_action_type = 7
                                        BEGIN
                                            IF @paper_action_type <> 5 
                                                BEGIN
                                                    SELECT
                                                        STOCK_EXCHANGE.EXCHANGE_NUMBER ACTION_NUMBER,
                                                        STOCK_EXCHANGE.STOCK_EXCHANGE_ID ACTION_ROW_ID,
                                                        STOCK_EXCHANGE.PROCESS_DATE INSERT_DATE,
                                                        STOCK_EXCHANGE.PROCESS_DATE PAPER_DATE,
                                                        STOCK_EXCHANGE.PROCESS_DATE ACTION_DATE,
                                                        STOCK_EXCHANGE.AMOUNT,
                                                        STOCK_EXCHANGE.SPECT_ID SPEC_ID,
                                                        STOCK_EXCHANGE.SPECT_MAIN_ID EXCHANGE_SPECT_MAIN_ID,
                                                        STOCK_EXCHANGE.STOCK_ID,
                                                        STOCK_EXCHANGE.PRODUCT_ID,
                                                        PRODUCT.PRODUCT_ID,
                                                        STOCK_EXCHANGE.PROCESS_CAT PROCESS_CAT,
                                                        STOCK_EXCHANGE.DEPARTMENT_ID ACTION_DEPARTMENT_ID,
                                                        STOCK_EXCHANGE.LOCATION_ID ACTION_LOCATION_ID
                                                    FROM
                                                        STOCK_EXCHANGE,
                                                        [@_dsn_product_@].PRODUCT PRODUCT
                                                    WHERE
                                                        PRODUCT.PRODUCT_ID=STOCK_EXCHANGE.PRODUCT_ID AND
                                                            STOCK_EXCHANGE.EXCHANGE_NUMBER = (SELECT EXCHANGE_NUMBER FROM STOCK_EXCHANGE WHERE STOCK_EXCHANGE_ID = @paper_action_id)
                                                    ORDER BY
                                                        PRODUCT.PRODUCT_ID,STOCK_EXCHANGE.STOCK_EXCHANGE_ID
                                                END
                                            ELSE
                                                BEGIN
                                                    SELECT
                                                        STOCK_EXCHANGE.EXCHANGE_NUMBER ACTION_NUMBER,
                                                        STOCK_EXCHANGE.STOCK_EXCHANGE_ID ACTION_ROW_ID,
                                                        STOCK_EXCHANGE.PROCESS_DATE INSERT_DATE,
                                                        STOCK_EXCHANGE.PROCESS_DATE PAPER_DATE,
                                                        STOCK_EXCHANGE.PROCESS_DATE ACTION_DATE,
                                                        STOCK_EXCHANGE.AMOUNT,
                                                        STOCK_EXCHANGE.SPECT_ID SPEC_ID,
                                                        STOCK_EXCHANGE.SPECT_MAIN_ID EXCHANGE_SPECT_MAIN_ID,
                                                        STOCK_EXCHANGE.STOCK_ID,
                                                        STOCK_EXCHANGE.PRODUCT_ID,
                                                        PRODUCT.PRODUCT_ID,
                                                        STOCK_EXCHANGE.PROCESS_CAT PROCESS_CAT,
                                                        STOCK_EXCHANGE.DEPARTMENT_ID ACTION_DEPARTMENT_ID,
                                                        STOCK_EXCHANGE.LOCATION_ID ACTION_LOCATION_ID
                                                    FROM
                                                        STOCK_EXCHANGE,
                                                        [@_dsn_product_@].PRODUCT PRODUCT
                                                    WHERE
                                                        PRODUCT.PRODUCT_ID=STOCK_EXCHANGE.PRODUCT_ID AND
                                                            STOCK_EXCHANGE.STOCK_EXCHANGE_ID =@paper_action_id
                                                    ORDER BY
                                                        PRODUCT.PRODUCT_ID,STOCK_EXCHANGE.STOCK_EXCHANGE_ID
                                                END	
                                        END
        
                                    ELSE
                                        IF @paper_action_type = 6 
                                            BEGIN
                                                    SELECT
                                                        EXPENSE_ITEMS_ROWS.EXP_ITEM_ROWS_ID ACTION_ROW_ID,
                                                        EXPENSE_ITEM_PLANS.RECORD_DATE INSERT_DATE,
                                                        EXPENSE_ITEM_PLANS.EXPENSE_DATE PAPER_DATE,
                                                        EXPENSE_ITEM_PLANS.EXPENSE_DATE ACTION_DATE,
                                                        EXPENSE_ITEMS_ROWS.QUANTITY AMOUNT,
                                                        NULL SPEC_ID,
                                                        NULL EXCHANGE_SPECT_MAIN_ID,
                                                        EXPENSE_ITEMS_ROWS.STOCK_ID,
                                                        EXPENSE_ITEMS_ROWS.PRODUCT_ID,
                                                        EXPENSE_ITEM_PLANS.PROCESS_CAT PROCESS_CAT,
                                                        EXPENSE_ITEM_PLANS.DEPARTMENT_ID ACTION_DEPARTMENT_ID,
                                                        EXPENSE_ITEM_PLANS.LOCATION_ID ACTION_LOCATION_ID
                                                    FROM
                                                        EXPENSE_ITEM_PLANS,
                                                        EXPENSE_ITEMS_ROWS,
                                                        [@_dsn_product_@].PRODUCT PRODUCT
                                                    WHERE
                                                        EXPENSE_ITEM_PLANS.EXPENSE_ID = @paper_action_id AND
                                                        EXPENSE_ITEM_PLANS.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID AND
                                                        PRODUCT.PRODUCT_ID = EXPENSE_ITEMS_ROWS.PRODUCT_ID 
                                                    ORDER BY
                                                        PRODUCT.PRODUCT_ID,EXPENSE_ITEMS_ROWS.EXP_ITEM_ROWS_ID
                                            END
                                        ELSE
                                            IF @paper_action_type = 8
                                            BEGIN
                                                    SELECT		
                                                        PRODUCT_COST_INVOICE.PRODUCT_COST_INVOICE_ID ACTION_ROW_ID,
                                                        PRODUCT_COST_INVOICE.RECORD_DATE INSERT_DATE,
                                                        PRODUCT_COST_INVOICE.COST_DATE PAPER_DATE,
                                                        PRODUCT_COST_INVOICE.COST_DATE ACTION_DATE,
                                                        PRODUCT_COST_INVOICE.AMOUNT,
                                                        NULL SPEC_ID,
                                                        PRODUCT_COST_INVOICE.SPECT_MAIN_ID EXCHANGE_SPECT_MAIN_ID,
                                                        PRODUCT_COST_INVOICE.PRODUCT_ID,
                                                        PRODUCT_COST_INVOICE.STOCK_ID,
                                                        INVOICE.PROCESS_CAT,
                                                        INVOICE.DEPARTMENT_ID ACTION_DEPARTMENT_ID,
                                                        INVOICE.DEPARTMENT_LOCATION ACTION_LOCATION_ID,
                                                        INVOICE.INVOICE_ID,
                                                        PRODUCT.PRODUCT_ID,
                                                        PRODUCT_COST_INVOICE.COST_TYPE_ID,
                                                        PRODUCT_COST_INVOICE.PRICE_PROTECTION_TYPE,
                                                        PRODUCT_COST_INVOICE.PRICE_PROTECTION,
                                                        PRODUCT_COST_INVOICE.PRICE_PROTECTION_MONEY,		
                                                        PRODUCT_COST_INVOICE.TOTAL_PRICE_PROTECTION,
                                                        ISNULL((
                                                            SELECT TOP 1 MONEY FROM [@_dsn_company_@].PRODUCT_COST 
                                                            WHERE
                                                                PRODUCT_ID = PRODUCT_COST_INVOICE.PRODUCT_ID AND
                                                                START_DATE <= PRODUCT_COST_INVOICE.COST_DATE
                                                                AND	ISNULL(SPECT_MAIN_ID,0) = ISNULL(PRODUCT_COST_INVOICE.SPECT_MAIN_ID,0)
                                                            ORDER BY
                                                                START_DATE DESC,
                                                                RECORD_DATE DESC,
                                                                PRODUCT_COST_ID DESC
                                                        ),@cost_money_system_2) MONEY
                                                    FROM
                                                        PRODUCT_COST_INVOICE,
                                                        INVOICE,
                                                        [@_dsn_product_@].PRODUCT PRODUCT
                                                    WHERE
                                                        PRODUCT_COST_INVOICE.INVOICE_ID = @paper_action_id AND
                                                        PRODUCT_COST_INVOICE.INVOICE_ID = INVOICE.INVOICE_ID AND
                                                        PRODUCT.PRODUCT_ID = PRODUCT_COST_INVOICE.PRODUCT_ID
                                                    ORDER BY
                                                        PRODUCT_COST_INVOICE.COST_DATE,
                                                        PRODUCT.PRODUCT_ID,PRODUCT_COST_INVOICE.PRODUCT_COST_INVOICE_ID
                                            END
        END

CREATE PROCEDURE [@_dsn_period_@].[GET_ACTION_PRODUCT] 
            @recordcount int ,
            @IS_WITH_SHIP BIT,
            @paper_product_id int, 
            @paper_action_id int,
            @paper_action_type int,
            @cost_money_system_2 NVARCHAR(50) 
            AS
            BEGIN
            
            SET NOCOUNT ON;
                        
                    IF @paper_action_type = 1
                        BEGIN 
                            IF (@recordcount = 1 )
                                BEGIN
                                    IF @IS_WITH_SHIP = 0
                                        BEGIN
                                                SELECT
                                                    SHIP.SHIP_ID,
                                                    INVOICE_ROW.INVOICE_ROW_ID ACTION_ROW_ID,
                                                    INVOICE.RECORD_DATE INSERT_DATE,
                                                    INVOICE.INVOICE_DATE PAPER_DATE,
                                                    ISNULL(SHIP.DELIVER_DATE,SHIP.SHIP_DATE) ACTION_DATE,
                                                    INVOICE_ROW.AMOUNT AMOUNT,
                                                    INVOICE_ROW.SPECT_VAR_ID SPEC_ID,
                                                    STOCKS.STOCK_ID,
                                                    STOCKS.PRODUCT_ID,
                                                    INVOICE.PROCESS_CAT,
                                                    INVOICE.DEPARTMENT_ID ACTION_DEPARTMENT_ID,
                                                    INVOICE.DEPARTMENT_LOCATION ACTION_LOCATION_ID,
                                                    INVOICE_ROW.DUE_DATE,
                                                    INVOICE.INVOICE_DATE
                                                FROM
                                                    SHIP,
                                                    INVOICE,
                                                    INVOICE_ROW,
                                                    [@_dsn_product_@].STOCKS STOCKS,
                                                    [@_dsn_product_@].PRODUCT PRODUCT
                                                WHERE
                                                    INVOICE.INVOICE_ID =@paper_action_id AND
                                                    INVOICE.INVOICE_ID=INVOICE_ROW.INVOICE_ID AND
                                                    INVOICE_ROW.SHIP_ID=SHIP.SHIP_ID AND
                                                    STOCKS.STOCK_ID=INVOICE_ROW.STOCK_ID AND
                                                    STOCKS.PRODUCT_ID=PRODUCT.PRODUCT_ID AND
                                                    PRODUCT.IS_COST=1
                                                    AND PRODUCT.PRODUCT_ID =@paper_product_id
                                                ORDER BY
                                                    ISNULL(SHIP.DELIVER_DATE,SHIP.SHIP_DATE),
                                                    STOCKS.PRODUCT_ID,
                                                    INVOICE_ROW.INVOICE_ROW_ID
                                        END
            
                                    ELSE
                                        BEGIN
                                            SELECT
                                                SHIP.SHIP_ID,
                                                INVOICE_ROW.INVOICE_ROW_ID ACTION_ROW_ID,
                                                INVOICE.RECORD_DATE INSERT_DATE,
                                                INVOICE.INVOICE_DATE PAPER_DATE,
                                                ISNULL(SHIP.DELIVER_DATE,SHIP.SHIP_DATE) ACTION_DATE,
                                                INVOICE_ROW.AMOUNT AMOUNT,
                                                INVOICE_ROW.SPECT_VAR_ID SPEC_ID,
                                                STOCKS.STOCK_ID,
                                                STOCKS.PRODUCT_ID,
                                                INVOICE.PROCESS_CAT,
                                                INVOICE.DEPARTMENT_ID ACTION_DEPARTMENT_ID,
                                                INVOICE.DEPARTMENT_LOCATION ACTION_LOCATION_ID,
                                                INVOICE_ROW.DUE_DATE,
                                                INVOICE.INVOICE_DATE
                                            FROM
                                                SHIP,
                                                INVOICE,
                                                INVOICE_ROW,
                                                INVOICE_SHIPS,
                                                [@_dsn_product_@].STOCKS STOCKS,
                                                [@_dsn_product_@].PRODUCT PRODUCT
                                            WHERE
                                                INVOICE.INVOICE_ID = @paper_action_id AND
                                                INVOICE.INVOICE_ID=INVOICE_ROW.INVOICE_ID AND
                                                INVOICE_SHIPS.SHIP_ID=SHIP.SHIP_ID AND
                                                INVOICE_SHIPS.INVOICE_ID=INVOICE.INVOICE_ID AND
                                                STOCKS.STOCK_ID=INVOICE_ROW.STOCK_ID AND
                                                STOCKS.PRODUCT_ID=PRODUCT.PRODUCT_ID AND
                                                PRODUCT.IS_COST=1 AND 
                                                PRODUCT.PRODUCT_ID = @paper_product_id
                                            ORDER BY
                                                ISNULL(SHIP.DELIVER_DATE,SHIP.SHIP_DATE),
                                                STOCKS.PRODUCT_ID,
                                                INVOICE_ROW.INVOICE_ROW_ID
                                        END
                                END
                            ELSE
                                BEGIN
                                        SELECT DISTINCT
                                            1 INV_CONT_COMP,
                                            SHIP.SHIP_ID,
                                            INVOICE.INVOICE_ID,
                                            INVOICE_ROW.INVOICE_ROW_ID ACTION_ROW_ID,
                                            INVOICE.RECORD_DATE INSERT_DATE,
                                            INVOICE.INVOICE_DATE PAPER_DATE,
                                            ISNULL(SHIP.DELIVER_DATE,SHIP.SHIP_DATE) ACTION_DATE,
                                            INVOICE_ROW.AMOUNT AMOUNT,
                                            INVOICE_ROW.SPECT_VAR_ID SPEC_ID,
                                            STOCKS.STOCK_ID,
                                            STOCKS.PRODUCT_ID,
                                            INVOICE.PROCESS_CAT,
                                            INVOICE.DEPARTMENT_ID ACTION_DEPARTMENT_ID,
                                            INVOICE.DEPARTMENT_LOCATION ACTION_LOCATION_ID,
                                            INVOICE_ROW.DUE_DATE,
                                            INVOICE.INVOICE_DATE
                                        FROM
                                            SHIP,
                                            INVOICE,
                                            INVOICE_ROW,
                                            INVOICE_SHIPS,
                                            INVOICE_CONTRACT_COMPARISON,
                                            [@_dsn_product_@].STOCKS STOCKS,
                                            [@_dsn_product_@].PRODUCT PRODUCT
                                        WHERE
                                            INVOICE_CONTRACT_COMPARISON.DIFF_INVOICE_ID =@paper_action_id AND
                                            INVOICE.INVOICE_ID=INVOICE_CONTRACT_COMPARISON.MAIN_INVOICE_ID AND
                                            INVOICE.INVOICE_ID=INVOICE_ROW.INVOICE_ID AND
                                            INVOICE_SHIPS.SHIP_ID=SHIP.SHIP_ID AND
                                            INVOICE_SHIPS.INVOICE_ID=INVOICE.INVOICE_ID AND
                                            STOCKS.STOCK_ID=INVOICE_ROW.STOCK_ID AND
                                            STOCKS.PRODUCT_ID=PRODUCT.PRODUCT_ID AND
                                            PRODUCT.IS_COST=1 AND 
                                            PRODUCT.PRODUCT_ID =@paper_product_id
            
                                        ORDER BY
                                            ISNULL(SHIP.DELIVER_DATE,SHIP.SHIP_DATE),
                                            STOCKS.PRODUCT_ID,
                                            INVOICE_ROW.INVOICE_ROW_ID
                                END
                        END
                    ELSE
                        IF  @paper_action_type = 2
                            BEGIN
                                SELECT
                                    SHIP.SHIP_ID,
                                    SHIP_ROW.SHIP_ROW_ID ACTION_ROW_ID,
                                    SHIP.RECORD_DATE INSERT_DATE,
                                    SHIP.SHIP_DATE PAPER_DATE,
                                    SHIP.DELIVER_DATE ACTION_DATE,
                                    SHIP_ROW.AMOUNT AMOUNT,
                                    SHIP_ROW.SPECT_VAR_ID SPEC_ID,
                                    STOCKS.STOCK_ID,
                                    STOCKS.PRODUCT_ID,
                                    SHIP.PROCESS_CAT,
                                    ISNULL(SHIP.DEPARTMENT_IN,SHIP.DELIVER_STORE_ID) ACTION_DEPARTMENT_ID,
                                    ISNULL(SHIP.LOCATION_IN,SHIP.LOCATION) ACTION_LOCATION_ID
                                FROM 
                                    SHIP,
                                    SHIP_ROW,
                                    [@_dsn_product_@].STOCKS STOCKS,
                                    [@_dsn_product_@].PRODUCT PRODUCT
                                WHERE
                                    SHIP.SHIP_ID = @paper_action_id AND
                                    SHIP.SHIP_ID = SHIP_ROW.SHIP_ID AND
                                    STOCKS.STOCK_ID = SHIP_ROW.STOCK_ID AND
                                    STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
                                    PRODUCT.IS_COST = 1 AND 
                                    PRODUCT.PRODUCT_ID = @paper_product_id
                                ORDER BY
                                    STOCKS.PRODUCT_ID,
                                    SHIP_ROW.SHIP_ROW_ID
                            END
                        ELSE
                            IF @paper_action_type = 3
                                BEGIN
                                    SELECT
                                        STOCK_FIS_ROW.STOCK_FIS_ROW_ID ACTION_ROW_ID,
                                        STOCK_FIS.RECORD_DATE INSERT_DATE,
                                        STOCK_FIS.FIS_DATE PAPER_DATE,
                                        STOCK_FIS.FIS_DATE ACTION_DATE,
                                        STOCK_FIS_ROW.AMOUNT AMOUNT,
                                        STOCK_FIS_ROW.SPECT_VAR_ID SPEC_ID,
                                        STOCKS.STOCK_ID,
                                        STOCKS.PRODUCT_ID,
                                        STOCK_FIS.PROCESS_CAT,
                                        STOCK_FIS.DEPARTMENT_IN ACTION_DEPARTMENT_ID,
                                        STOCK_FIS.LOCATION_IN ACTION_LOCATION_ID,
                                        ISNULL(STOCK_FIS_ROW.DUE_DATE,0) DUE_DATE,
                                        STOCK_FIS_ROW.RESERVE_DATE
                                    FROM 
                                        STOCK_FIS,
                                        STOCK_FIS_ROW,
                                        [@_dsn_product_@].STOCKS STOCKS,
                                        [@_dsn_product_@].PRODUCT PRODUCT
                                    WHERE
                                        STOCK_FIS.FIS_ID = @paper_action_id AND
                                        STOCK_FIS.FIS_ID = STOCK_FIS_ROW.FIS_ID AND
                                        STOCKS.STOCK_ID = STOCK_FIS_ROW.STOCK_ID AND
                                        STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
                                        PRODUCT.IS_COST=1 
                                        AND PRODUCT.PRODUCT_ID = @paper_product_id
                                    ORDER BY
                                        STOCKS.PRODUCT_ID,STOCK_FIS_ROW.STOCK_FIS_ROW_ID	
                                END
                            ELSE
                                IF @paper_action_type = 4
                                    BEGIN
                                            SELECT
                                                PORR.PR_ORDER_ROW_ID ACTION_ROW_ID,
                                                ISNULL(POR.UPDATE_DATE,POR.RECORD_DATE) INSERT_DATE,
                                                POR.FINISH_DATE PAPER_DATE,
                                                POR.FINISH_DATE ACTION_DATE,
                                                PORR.AMOUNT,
                                                PORR.SPECT_ID SPEC_ID,
                                                PORR.SPEC_MAIN_ID EXCHANGE_SPECT_MAIN_ID,
                                                (PORR.PURCHASE_NET_SYSTEM++ISNULL(PORR.PURCHASE_EXTRA_COST_SYSTEM,0)) PURCHASE_NET_SYSTEM,
                                                PORR.PURCHASE_NET_SYSTEM_MONEY,
                                                (ISNULL(PORR.LABOR_COST_SYSTEM,0)+ISNULL(PORR.STATION_REFLECTION_COST_SYSTEM,0)) AS PURCHASE_EXTRA_COST_SYSTEM,
                                                STOCKS.STOCK_ID,
                                                STOCKS.PRODUCT_ID,
                                                POR.PROCESS_ID PROCESS_CAT,
                                                POR.PRODUCTION_DEP_ID ACTION_DEPARTMENT_ID,
                                                POR.PRODUCTION_LOC_ID ACTION_LOCATION_ID
                                            FROM 
                                                PRODUCTION_ORDERS PO,
                                                PRODUCTION_ORDER_RESULTS POR,
                                                PRODUCTION_ORDER_RESULTS_ROW PORR,
                                                [@_dsn_product_@].STOCKS STOCKS,
                                                [@_dsn_product_@].PRODUCT PRODUCT
                                            WHERE
                                                POR.PR_ORDER_ID = @paper_action_id AND
                                                PO.P_ORDER_ID = POR.P_ORDER_ID AND
                                                POR.PR_ORDER_ID = PORR.PR_ORDER_ID AND
                                                STOCKS.STOCK_ID = PORR.STOCK_ID AND
                                                STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
                                                PRODUCT.IS_COST = 1 AND
                                                PORR.TYPE = 1 AND
                                                ISNULL(PORR.IS_FREE_AMOUNT,0) <> 1 AND
                                                PO.IS_DEMONTAJ <> 1
                                                AND PRODUCT.PRODUCT_ID = @paper_product_id
                                            ORDER BY
                                                STOCKS.PRODUCT_ID,PORR.PR_ORDER_ROW_ID
                                    END
                                ELSE
                                    IF @paper_action_type = 5 OR @paper_action_type = 7
                                        BEGIN
                                            IF @paper_action_type <> 5 
                                                BEGIN
                                                    SELECT
                                                        STOCK_EXCHANGE.EXCHANGE_NUMBER ACTION_NUMBER,
                                                        STOCK_EXCHANGE.STOCK_EXCHANGE_ID ACTION_ROW_ID,
                                                        STOCK_EXCHANGE.PROCESS_DATE INSERT_DATE,
                                                        STOCK_EXCHANGE.PROCESS_DATE PAPER_DATE,
                                                        STOCK_EXCHANGE.PROCESS_DATE ACTION_DATE,
                                                        STOCK_EXCHANGE.AMOUNT,
                                                        STOCK_EXCHANGE.SPECT_ID SPEC_ID,
                                                        STOCK_EXCHANGE.SPECT_MAIN_ID EXCHANGE_SPECT_MAIN_ID,
                                                        STOCK_EXCHANGE.STOCK_ID,
                                                        STOCK_EXCHANGE.PRODUCT_ID,
                                                        PRODUCT.PRODUCT_ID,
                                                        STOCK_EXCHANGE.PROCESS_CAT PROCESS_CAT,
                                                        STOCK_EXCHANGE.DEPARTMENT_ID ACTION_DEPARTMENT_ID,
                                                        STOCK_EXCHANGE.LOCATION_ID ACTION_LOCATION_ID
                                                    FROM
                                                        STOCK_EXCHANGE,
                                                        [@_dsn_product_@].PRODUCT PRODUCT
                                                    WHERE
                                                        PRODUCT.PRODUCT_ID=STOCK_EXCHANGE.PRODUCT_ID AND
                                                            STOCK_EXCHANGE.EXCHANGE_NUMBER = (SELECT EXCHANGE_NUMBER FROM STOCK_EXCHANGE WHERE STOCK_EXCHANGE_ID = @paper_action_id)
                                                            AND PRODUCT.PRODUCT_ID = @paper_product_id
                                                    ORDER BY
                                                        PRODUCT.PRODUCT_ID,STOCK_EXCHANGE.STOCK_EXCHANGE_ID
                                                END
                                            ELSE
                                                BEGIN
                                                    SELECT
                                                        STOCK_EXCHANGE.EXCHANGE_NUMBER ACTION_NUMBER,
                                                        STOCK_EXCHANGE.STOCK_EXCHANGE_ID ACTION_ROW_ID,
                                                        STOCK_EXCHANGE.PROCESS_DATE INSERT_DATE,
                                                        STOCK_EXCHANGE.PROCESS_DATE PAPER_DATE,
                                                        STOCK_EXCHANGE.PROCESS_DATE ACTION_DATE,
                                                        STOCK_EXCHANGE.AMOUNT,
                                                        STOCK_EXCHANGE.SPECT_ID SPEC_ID,
                                                        STOCK_EXCHANGE.SPECT_MAIN_ID EXCHANGE_SPECT_MAIN_ID,
                                                        STOCK_EXCHANGE.STOCK_ID,
                                                        STOCK_EXCHANGE.PRODUCT_ID,
                                                        PRODUCT.PRODUCT_ID,
                                                        STOCK_EXCHANGE.PROCESS_CAT PROCESS_CAT,
                                                        STOCK_EXCHANGE.DEPARTMENT_ID ACTION_DEPARTMENT_ID,
                                                        STOCK_EXCHANGE.LOCATION_ID ACTION_LOCATION_ID
                                                    FROM
                                                        STOCK_EXCHANGE,
                                                        [@_dsn_product_@].PRODUCT PRODUCT
                                                    WHERE
                                                        PRODUCT.PRODUCT_ID=STOCK_EXCHANGE.PRODUCT_ID AND
                                                            STOCK_EXCHANGE.STOCK_EXCHANGE_ID =@paper_action_id
                                                        
                                                            AND PRODUCT.PRODUCT_ID = @paper_product_id
                                                    ORDER BY
                                                        PRODUCT.PRODUCT_ID,STOCK_EXCHANGE.STOCK_EXCHANGE_ID
                                                END	
                                        END
            
                                    ELSE
                                        IF @paper_action_type = 6 
                                            BEGIN
                                                    SELECT
                                                        EXPENSE_ITEMS_ROWS.EXP_ITEM_ROWS_ID ACTION_ROW_ID,
                                                        EXPENSE_ITEM_PLANS.RECORD_DATE INSERT_DATE,
                                                        EXPENSE_ITEM_PLANS.EXPENSE_DATE PAPER_DATE,
                                                        EXPENSE_ITEM_PLANS.EXPENSE_DATE ACTION_DATE,
                                                        EXPENSE_ITEMS_ROWS.QUANTITY AMOUNT,
                                                        NULL SPEC_ID,
                                                        NULL EXCHANGE_SPECT_MAIN_ID,
                                                        EXPENSE_ITEMS_ROWS.STOCK_ID,
                                                        EXPENSE_ITEMS_ROWS.PRODUCT_ID,
                                                        EXPENSE_ITEM_PLANS.PROCESS_CAT PROCESS_CAT,
                                                        EXPENSE_ITEM_PLANS.DEPARTMENT_ID ACTION_DEPARTMENT_ID,
                                                        EXPENSE_ITEM_PLANS.LOCATION_ID ACTION_LOCATION_ID
                                                    FROM
                                                        EXPENSE_ITEM_PLANS,
                                                        EXPENSE_ITEMS_ROWS,
                                                        [@_dsn_product_@].PRODUCT PRODUCT
                                                    WHERE
                                                        EXPENSE_ITEM_PLANS.EXPENSE_ID = @paper_action_id AND
                                                        EXPENSE_ITEM_PLANS.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ID AND
                                                        PRODUCT.PRODUCT_ID = EXPENSE_ITEMS_ROWS.PRODUCT_ID 
                                                        AND PRODUCT.PRODUCT_ID = @paper_product_id
                                                    ORDER BY
                                                        PRODUCT.PRODUCT_ID,EXPENSE_ITEMS_ROWS.EXP_ITEM_ROWS_ID
                                            END
                                        ELSE
                                            IF @paper_action_type = 8
                                            BEGIN
                                                    SELECT		
                                                        PRODUCT_COST_INVOICE.PRODUCT_COST_INVOICE_ID ACTION_ROW_ID,
                                                        PRODUCT_COST_INVOICE.RECORD_DATE INSERT_DATE,
                                                        PRODUCT_COST_INVOICE.COST_DATE PAPER_DATE,
                                                        PRODUCT_COST_INVOICE.COST_DATE ACTION_DATE,
                                                        PRODUCT_COST_INVOICE.AMOUNT,
                                                        NULL SPEC_ID,
                                                        PRODUCT_COST_INVOICE.SPECT_MAIN_ID EXCHANGE_SPECT_MAIN_ID,
                                                        PRODUCT_COST_INVOICE.PRODUCT_ID,
                                                        PRODUCT_COST_INVOICE.STOCK_ID,
                                                        INVOICE.PROCESS_CAT,
                                                        INVOICE.DEPARTMENT_ID ACTION_DEPARTMENT_ID,
                                                        INVOICE.DEPARTMENT_LOCATION ACTION_LOCATION_ID,
                                                        INVOICE.INVOICE_ID,
                                                        PRODUCT.PRODUCT_ID,
                                                        PRODUCT_COST_INVOICE.COST_TYPE_ID,
                                                        PRODUCT_COST_INVOICE.PRICE_PROTECTION_TYPE,
                                                        PRODUCT_COST_INVOICE.PRICE_PROTECTION,
                                                        PRODUCT_COST_INVOICE.PRICE_PROTECTION_MONEY,		
                                                        PRODUCT_COST_INVOICE.TOTAL_PRICE_PROTECTION,
                                                        ISNULL((
                                                            SELECT TOP 1 MONEY FROM [@_dsn_company_@].PRODUCT_COST 
                                                            WHERE
                                                                PRODUCT_ID = PRODUCT_COST_INVOICE.PRODUCT_ID AND
                                                                START_DATE <= PRODUCT_COST_INVOICE.COST_DATE
                                                                AND	ISNULL(SPECT_MAIN_ID,0) = ISNULL(PRODUCT_COST_INVOICE.SPECT_MAIN_ID,0)
                                                            ORDER BY
                                                                START_DATE DESC,
                                                                RECORD_DATE DESC,
                                                                PRODUCT_COST_ID DESC
                                                        ),@cost_money_system_2) MONEY
                                                    FROM
                                                        PRODUCT_COST_INVOICE,
                                                        INVOICE,
                                                        [@_dsn_product_@].PRODUCT PRODUCT
                                                    WHERE
                                                        PRODUCT_COST_INVOICE.INVOICE_ID = @paper_action_id AND
                                                        PRODUCT_COST_INVOICE.INVOICE_ID = INVOICE.INVOICE_ID AND
                                                        PRODUCT.PRODUCT_ID = PRODUCT_COST_INVOICE.PRODUCT_ID
                                                        AND PRODUCT.PRODUCT_ID = @paper_product_id
                                                    ORDER BY
                                                        PRODUCT_COST_INVOICE.COST_DATE,
                                                        PRODUCT.PRODUCT_ID,PRODUCT_COST_INVOICE.PRODUCT_COST_INVOICE_ID
                                            END
            END

CREATE PROCEDURE [@_dsn_period_@].[get_mizan]
    AS BEGIN
        
    SELECT AC.CARD_TYPE_NO
        ,AC.BILL_NO
        ,'Yevmiye No:' + cast (BILL_NO AS NVARCHAR(50)) +'_____'+ cast(AC.ACTION_DATE  AS NVARCHAR(50)) AS Yevmiye
        ,AP.ACCOUNT_NAME
        ,'Mahsup Fiş No:'+ CAST (AC.CARD_TYPE_NO AS NVARCHAR(50)) AS Mahsup
        ,AC.ACTION_DATE
        ,ACR.ACCOUNT_ID
        ,B.BRANCH_NAME
        ,D.DEPARTMENT_HEAD
        ,PP.PROJECT_HEAD
        ,ACR.DETAIL
        ,CASE WHEN ACR.BA = 0 THEN AMOUNT END AS BORC
        ,CASE WHEN ACR.BA = 1 THEN AMOUNT END AS ALACAK
    FROM   ACCOUNT_CARD AC
        JOIN ACCOUNT_CARD_ROWS ACR
                ON  ACR.CARD_ID = AC.CARD_ID
            LEFT JOIN [@_dsn_main_@].BRANCH AS b
                ON	B.BRANCH_ID = ACR.ACC_BRANCH_ID
            LEFT JOIN [@_dsn_main_@].DEPARTMENT AS d
                ON d.DEPARTMENT_ID = acr.ACC_DEPARTMENT_ID
            LEFT JOIN [@_dsn_main_@].PRO_PROJECTS AS pp
                ON PP.PROJECT_ID = ACR.ACC_PROJECT_ID
            LEFT JOIN ACCOUNT_PLAN AS ap ON AP.ACCOUNT_CODE = ACR.ACCOUNT_ID

	END

CREATE PROCEDURE [@_dsn_period_@].[GET_NETBOOK]
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

CREATE PROCEDURE [@_dsn_period_@].[GET_SHIP_TYPE]
            @action_id int
        AS
        BEGIN
        SET NOCOUNT ON;
                SELECT SHIP_TYPE FROM SHIP WHERE SHIP_ID = @action_id
        END

CREATE PROCEDURE [@_dsn_period_@].[get_stock_last_function]
                (
                    @stock_id_list nvarchar (max)
                )
            AS
            BEGIN 
        
                SELECT 
                    ROUND(SUM(REAL_STOCK),4) REAL_STOCK,
                    ROUND(SUM(PRODUCT_STOCK),4) PRODUCT_STOCK,
                    ROUND(SUM(PRODUCT_STOCK+RESERVED_STOCK),4) SALEABLE_STOCK,
                    ROUND(SUM(PURCHASE_ORDER_STOCK),4) PURCHASE_ORDER_STOCK,
                    PRODUCT_ID, 
                    STOCK_ID
                FROM
                (
                    SELECT
                        (SR.STOCK_IN - SR.STOCK_OUT) AS REAL_STOCK,
                        0 AS PRODUCT_STOCK,
                        0 AS RESERVED_STOCK,
                        0 AS PURCHASE_ORDER_STOCK,
                        SR.STOCK_ID,
                        SR.PRODUCT_ID
                    FROM
                        STOCKS_ROW SR
                    JOIN
                        fnSplit(@stock_id_list,',') AS TB1
                    ON 
                        TB1.item = SR.STOCK_ID
                UNION ALL
                    SELECT
                        0 AS REAL_STOCK,
                        (SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK,
                        0 AS RESERVED_STOCK,
                        0 AS PURCHASE_ORDER_STOCK,
                        SR.STOCK_ID,
                        SR.PRODUCT_ID
                    FROM
                        [@_dsn_main_@].STOCKS_LOCATION SL,
                        STOCKS_ROW SR
                    JOIN
                        fnSplit(@stock_id_list,',') AS TB1
                    ON 
                        TB1.item = SR.STOCK_ID
                    WHERE
                        SR.STORE =SL.DEPARTMENT_ID
                        AND SR.STORE_LOCATION=SL.LOCATION_ID
                        AND SL.NO_SALE = 0
                UNION ALL
                    SELECT
                        0 AS REAL_STOCK,
                        0 AS PRODUCT_STOCK,
                        ((RESERVE_STOCK_OUT-STOCK_OUT)*-1) AS RESERVED_STOCK,
                        RESERVE_STOCK_IN AS PURCHASE_ORDER_STOCK,
                        ORR.STOCK_ID,
                        ORR.PRODUCT_ID
                    FROM
                        [@_dsn_company_@].GET_ORDER_ROW_RESERVED ORR
                    JOIN
                        fnSplit(@stock_id_list,',') AS TB1
                    ON 
                        TB1.item = ORR.STOCK_ID
                        , 
                        [@_dsn_company_@].ORDERS ORDS
                    WHERE
                        ORDS.RESERVED = 1 AND 
                        ORDS.ORDER_STATUS = 1 AND	
                        ORR.ORDER_ID=ORDS.ORDER_ID AND 
                        ((RESERVE_STOCK_IN-STOCK_IN)>0 OR (RESERVE_STOCK_OUT-STOCK_OUT)>0)
                UNION ALL
                    SELECT
                        0 AS REAL_STOCK,
                        0 AS PRODUCT_STOCK,
                        (RESERVE_STOCK_IN-STOCK_IN) AS RESERVED_STOCK,
                        0 AS PURCHASE_ORDER_STOCK,
                        ORR.STOCK_ID,
                        ORR.PRODUCT_ID
                    FROM
                        [@_dsn_company_@].GET_ORDER_ROW_RESERVED ORR
                    JOIN
                        fnSplit(@stock_id_list,',') AS TB1
                    ON 
                        TB1.item = ORR.STOCK_ID
                        , 
                        [@_dsn_company_@].ORDERS ORDS,
                        [@_dsn_main_@].STOCKS_LOCATION SL
                    WHERE
                        ORDS.RESERVED = 1 AND 
                        ORDS.ORDER_STATUS = 1 AND	
                        ORDS.DELIVER_DEPT_ID =SL.DEPARTMENT_ID AND 
                        ORDS.LOCATION_ID=SL.LOCATION_ID AND 
                        SL.NO_SALE = 0	 AND 
                        ORR.ORDER_ID=ORDS.ORDER_ID AND 
                        (RESERVE_STOCK_IN-STOCK_IN)>0
                UNION ALL
                    SELECT
                        0 AS REAL_STOCK,
                        0 AS PRODUCT_STOCK,
                        ((RESERVE_STOCK_IN-STOCK_IN) + ((RESERVE_STOCK_OUT-STOCK_OUT)*-1)) AS RESERVED_STOCK,
                        0 AS PURCHASE_ORDER_STOCK,
                        ORR.STOCK_ID,
                        ORR.PRODUCT_ID
                    FROM
                        [@_dsn_company_@].ORDER_ROW_RESERVED  ORR
                    JOIN
                        fnSplit(@stock_id_list,',') AS TB1
                    ON 
                        TB1.item = ORR.STOCK_ID
                    WHERE
                        ORDER_ID IS NULL
                        AND SHIP_ID IS NULL
                        AND INVOICE_ID IS NULL
                UNION ALL
                    SELECT
                        0 AS REAL_STOCK,
                        0 AS PRODUCT_STOCK,
                        (STOCK_ARTIR-STOCK_AZALT) AS RESERVED_STOCK,
                        0  AS PURCHASE_ORDER_STOCK,
                        STOCK_ID,
                        PRODUCT_ID
                    FROM
                        [@_dsn_company_@].GET_PRODUCTION_RESERVED
                    JOIN
                        fnSplit(@stock_id_list,',') AS TB1
                    ON 
                        TB1.item = GET_PRODUCTION_RESERVED.STOCK_ID
                ) T1
                GROUP BY
                    PRODUCT_ID, 
                    STOCK_ID
            END;

CREATE PROCEDURE [@_dsn_period_@].[get_stock_last_function_with_product]
                (
                    @product_id_list nvarchar (max)
                )
            AS
            BEGIN 
                SELECT 
                    ROUND(SUM(REAL_STOCK),4) REAL_STOCK,
                    ROUND(SUM(PRODUCT_STOCK),4) PRODUCT_STOCK,
                    ROUND(SUM(PRODUCT_STOCK+RESERVED_STOCK),4) SALEABLE_STOCK,
                    ROUND(SUM(PURCHASE_ORDER_STOCK),4) PURCHASE_ORDER_STOCK,
                    PRODUCT_ID, 
                    STOCK_ID
                FROM
                (
                    SELECT
                        (STOCK_IN - STOCK_OUT) AS REAL_STOCK,
                        0 AS PRODUCT_STOCK,
                        0 AS RESERVED_STOCK,
                        0 AS PURCHASE_ORDER_STOCK,
                        STOCK_ID,
                        PRODUCT_ID
                    FROM
                        STOCKS_ROW
                    JOIN
                        fnSplit(@product_id_list,',') AS TB1
                    ON 
                        STOCKS_ROW.PRODUCT_ID =TB1.item
                UNION ALL
                    SELECT
                        0 AS REAL_STOCK,
                        (SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK,
                        0 AS RESERVED_STOCK,
                        0 AS PURCHASE_ORDER_STOCK,
                        SR.STOCK_ID,
                        SR.PRODUCT_ID
                    FROM
                        [@_dsn_main_@].STOCKS_LOCATION SL,
                        STOCKS_ROW SR
                    JOIN
                        fnSplit(@product_id_list,',') AS TB1
                    ON 
                        SR.PRODUCT_ID =TB1.item
                    WHERE
                        SR.STORE =SL.DEPARTMENT_ID AND 
                        SR.STORE_LOCATION=SL.LOCATION_ID AND 
                        SL.NO_SALE = 0 
                        
                    UNION ALL
                    SELECT
                        0 AS REAL_STOCK,
                        0 AS PRODUCT_STOCK,

                        ((ORR.RESERVE_STOCK_OUT - ORR.STOCK_OUT)*-1) AS RESERVED_STOCK,
                        ORR.RESERVE_STOCK_IN AS PURCHASE_ORDER_STOCK,
                        ORR.STOCK_ID,
                        ORR.PRODUCT_ID

                    FROM
                        [@_dsn_company_@].GET_ORDER_ROW_RESERVED ORR
                    JOIN
                        fnSplit(@product_id_list,',') AS TB1
                    ON 
                        ORR.PRODUCT_ID =TB1.item
                        , 
                        [@_dsn_company_@].ORDERS ORDS
                    WHERE
                        ORDS.RESERVED = 1 AND 
                        ORDS.ORDER_STATUS = 1 AND	
                        ORR.ORDER_ID = ORDS.ORDER_ID AND 
                        ((ORR.RESERVE_STOCK_IN - ORR.STOCK_IN)>0 OR (ORR.RESERVE_STOCK_OUT - ORR.STOCK_OUT)>0) 
                    UNION ALL
                    SELECT
                        0 AS REAL_STOCK,
                        0 AS PRODUCT_STOCK,
                        (ORR.RESERVE_STOCK_IN - ORR.STOCK_IN) AS RESERVED_STOCK,
                        0 AS PURCHASE_ORDER_STOCK,
                        ORR.STOCK_ID,
                        ORR.PRODUCT_ID
                    FROM
                        [@_dsn_company_@].GET_ORDER_ROW_RESERVED ORR
                    JOIN
                        fnSplit(@product_id_list,',') AS TB1
                    ON 
                        ORR.PRODUCT_ID =TB1.item
                        , 
                        [@_dsn_company_@].ORDERS ORDS,
                        [@_dsn_main_@].STOCKS_LOCATION SL
                    WHERE
                        ORDS.RESERVED = 1 AND 
                        ORDS.ORDER_STATUS = 1 AND	
                        ORDS.DELIVER_DEPT_ID =SL.DEPARTMENT_ID AND 
                        ORDS.LOCATION_ID = SL.LOCATION_ID AND 
                        SL.NO_SALE = 0	 AND 
                        ORR.ORDER_ID = ORDS.ORDER_ID AND 
                        (RESERVE_STOCK_IN-STOCK_IN)>0 
                    UNION ALL
                    SELECT
                        0 AS REAL_STOCK,
                        0 AS PRODUCT_STOCK,
                        ((RESERVE_STOCK_IN-STOCK_IN) + ((RESERVE_STOCK_OUT-STOCK_OUT)*-1)) AS RESERVED_STOCK,
                        0 AS PURCHASE_ORDER_STOCK,
                        STOCK_ID,
                        PRODUCT_ID
                    FROM
                        [@_dsn_company_@].ORDER_ROW_RESERVED
                    JOIN
                        fnSplit(@product_id_list,',') AS TB1
                    ON 
                        ORDER_ROW_RESERVED.PRODUCT_ID =TB1.item
                    WHERE
                        ORDER_ID IS NULL AND 
                        SHIP_ID IS NULL AND 
                        INVOICE_ID IS NULL
                    UNION ALL
                    SELECT
                        0 AS REAL_STOCK,
                        0 AS PRODUCT_STOCK,
                        (STOCK_ARTIR-STOCK_AZALT) AS RESERVED_STOCK,
                        0 AS PURCHASE_ORDER_STOCK,
                        STOCK_ID,
                        PRODUCT_ID
                    FROM
                        [@_dsn_company_@].GET_PRODUCTION_RESERVED
                    JOIN
                        fnSplit(@product_id_list,',') AS TB1
                    ON 
                        GET_PRODUCTION_RESERVED.PRODUCT_ID =TB1.item 
                    UNION ALL
                    SELECT
                        0 AS REAL_STOCK,
                        0 AS PRODUCT_STOCK,
                        -1*(STOCK_IN - SR.STOCK_OUT) AS RESERVED_STOCK,
                        0  AS PURCHASE_ORDER_STOCK,
                        SR.STOCK_ID,
                        SR.PRODUCT_ID
                    FROM
                        STOCKS_ROW SR
                    JOIN
                        fnSplit(@product_id_list,',') AS TB1
                    ON 
                        SR.PRODUCT_ID =TB1.item 
                        ,
                        [@_dsn_main_@].STOCKS_LOCATION SL 
                    WHERE	
                        SR.STORE = SL.DEPARTMENT_ID AND
                        SR.STORE_LOCATION = SL.LOCATION_ID AND
                        ISNULL(SL.IS_SCRAP,0)=1
                ) T1
                GROUP BY
                    PRODUCT_ID, 
                    STOCK_ID
            END;

CREATE PROCEDURE [@_dsn_period_@].[get_stock_last_location_function]
                (
                    @stock_id_list nvarchar (max)
                )
            AS
            BEGIN 
            SELECT 
                SUM(REAL_STOCK) REAL_STOCK,
                SUM(PRODUCT_STOCK) PRODUCT_STOCK,
                SUM(RESERVED_STOCK) RESERVED_STOCK,
                SUM(PURCHASE_PROD_STOCK) PURCHASE_PROD_STOCK,
                SUM(RESERVED_PROD_STOCK) RESERVED_PROD_STOCK,
                SUM(PRODUCT_STOCK+RESERVED_STOCK) SALEABLE_STOCK,
                SUM(RESERVE_SALE_ORDER_STOCK) RESERVE_SALE_ORDER_STOCK,
                SUM(NOSALE_STOCK) NOSALE_STOCK,
                SUM(BELONGTO_INSTITUTION_STOCK) BELONGTO_INSTITUTION_STOCK,
                SUM(RESERVE_PURCHASE_ORDER_STOCK) PURCHASE_ORDER_STOCK,
                SUM(PRODUCTION_ORDER_STOCK) PRODUCTION_ORDER_STOCK,
                SUM(NOSALE_RESERVED_STOCK) AS NOSALE_RESERVED_STOCK,
                PRODUCT_ID, 
                STOCK_ID,
                DEPARTMENT_ID,
                LOCATION_ID
            FROM
            (
                SELECT
                    (SR.STOCK_IN - SR.STOCK_OUT) AS REAL_STOCK,
                    0 AS PRODUCT_STOCK,
                    0 AS RESERVED_STOCK,
                    0 AS PURCHASE_PROD_STOCK,
                    0 AS RESERVED_PROD_STOCK,
                    0 AS RESERVE_SALE_ORDER_STOCK,
                    0 AS NOSALE_STOCK, 
                    0 AS BELONGTO_INSTITUTION_STOCK,
                    0 AS RESERVE_PURCHASE_ORDER_STOCK,
                    0 AS PRODUCTION_ORDER_STOCK,
                    0 AS NOSALE_RESERVED_STOCK,
                    SR.STOCK_ID,
                    SR.PRODUCT_ID,
                    SR.STORE AS DEPARTMENT_ID,
                    SR.STORE_LOCATION AS LOCATION_ID
                FROM
                    STOCKS_ROW SR WITH (NOLOCK)
                JOIN
                    fnSplit(@stock_id_list,',') AS TB1
                ON 
                    TB1.item = SR.STOCK_ID
                UNION ALL
                SELECT
                    (SR.STOCK_IN - SR.STOCK_OUT) AS REAL_STOCK,
                    0 AS PRODUCT_STOCK,
                    0 AS RESERVED_STOCK,
                    0 AS PURCHASE_PROD_STOCK,
                    0 AS RESERVED_PROD_STOCK,
                    0 AS RESERVE_SALE_ORDER_STOCK,
                    0 AS NOSALE_STOCK, 
                    0 AS BELONGTO_INSTITUTION_STOCK,
                    0 AS RESERVE_PURCHASE_ORDER_STOCK,
                    0 AS PRODUCTION_ORDER_STOCK,
                    0 AS NOSALE_RESERVED_STOCK,
                    SR.STOCK_ID,
                    SR.PRODUCT_ID,
                    -1 AS DEPARTMENT_ID,
                    -1 AS LOCATION_ID
                FROM
                    STOCKS_ROW SR WITH (NOLOCK)
                JOIN
                    fnSplit(@stock_id_list,',') AS TB1
                ON 
                    TB1.item = SR.STOCK_ID
                WHERE
                    UPD_ID IS NULL 
                UNION ALL
                SELECT
                    0 AS REAL_STOCK,
                    (SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK,
                    0 AS RESERVED_STOCK,
                    0 AS PURCHASE_PROD_STOCK,
                    0 AS RESERVED_PROD_STOCK,
                    0 AS RESERVE_SALE_ORDER_STOCK,
                    0 AS NOSALE_STOCK, 
                    0 AS BELONGTO_INSTITUTION_STOCK,
                    0 AS RESERVE_PURCHASE_ORDER_STOCK,
                    0 AS PRODUCTION_ORDER_STOCK,
                    0 AS NOSALE_RESERVED_STOCK,
                    SR.STOCK_ID,
                    SR.PRODUCT_ID,
                    SR.STORE AS DEPARTMENT_ID,
                    SR.STORE_LOCATION AS LOCATION_ID
                FROM
                    [@_dsn_main_@].STOCKS_LOCATION SL WITH (NOLOCK),
                    STOCKS_ROW SR WITH (NOLOCK)
                JOIN
                    fnSplit(@stock_id_list,',') AS TB1
                ON 
                    TB1.item = SR.STOCK_ID
                WHERE
                    SR.STORE =SL.DEPARTMENT_ID AND 
                    SR.STORE_LOCATION=SL.LOCATION_ID AND 
                    SL.NO_SALE = 0 
                UNION ALL
                SELECT
                    0 AS REAL_STOCK,
                    -1*(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK,
                    0 AS RESERVED_STOCK,
                    0 AS PURCHASE_PROD_STOCK,
                    0 AS RESERVED_PROD_STOCK,
                    0 AS RESERVE_SALE_ORDER_STOCK,
                    0 AS NOSALE_STOCK, 
                    0 AS BELONGTO_INSTITUTION_STOCK,
                    0 AS RESERVE_PURCHASE_ORDER_STOCK,
                    0 AS PRODUCTION_ORDER_STOCK,
                    0 AS NOSALE_RESERVED_STOCK,
                    SR.STOCK_ID,
                    SR.PRODUCT_ID,
                    SR.STORE AS DEPARTMENT_ID,
                    SR.STORE_LOCATION AS LOCATION_ID
                FROM
                    STOCKS_ROW SR WITH (NOLOCK)
                JOIN
                    fnSplit(@stock_id_list,',') AS TB1
                ON 
                    TB1.item = SR.STOCK_ID	
                    ,
                    [@_dsn_main_@].STOCKS_LOCATION SL WITH (NOLOCK) 
                WHERE	
                    SR.STORE = SL.DEPARTMENT_ID AND
                    SR.STORE_LOCATION = SL.LOCATION_ID AND
                    ISNULL(SL.IS_SCRAP,0)=1 
                UNION ALL
                SELECT
                    0 AS REAL_STOCK,
                    0 AS PRODUCT_STOCK,
                    0 AS RESERVED_STOCK,
                    0 AS PURCHASE_PROD_STOCK,
                    0 AS RESERVED_PROD_STOCK,
                    0 AS RESERVE_SALE_ORDER_STOCK,
                    (SR.STOCK_IN - SR.STOCK_OUT) AS NOSALE_STOCK,
                    0 AS BELONGTO_INSTITUTION_STOCK,
                    0 AS RESERVE_PURCHASE_ORDER_STOCK,
                    0 AS PRODUCTION_ORDER_STOCK,
                    0 AS NOSALE_RESERVED_STOCK,
                    SR.STOCK_ID,
                    SR.PRODUCT_ID,
                    SR.STORE AS DEPARTMENT_ID,
                    SR.STORE_LOCATION AS LOCATION_ID
                FROM
                    [@_dsn_main_@].STOCKS_LOCATION SL WITH (NOLOCK),
                    STOCKS_ROW SR WITH (NOLOCK)
                JOIN
                    fnSplit(@stock_id_list,',') AS TB1
                ON 
                    TB1.item = SR.STOCK_ID	
                WHERE
                    SR.STORE =SL.DEPARTMENT_ID AND 
                    SR.STORE_LOCATION=SL.LOCATION_ID AND 
                    SL.NO_SALE =1
                UNION ALL
                SELECT
                    0 AS REAL_STOCK,
                    0 AS PRODUCT_STOCK,
                    0 AS RESERVED_STOCK,
                    0 AS PURCHASE_PROD_STOCK,
                    0 AS RESERVED_PROD_STOCK,
                    0 AS RESERVE_SALE_ORDER_STOCK,
                    0 AS NOSALE_STOCK, 
                    (SR.STOCK_IN - SR.STOCK_OUT) AS BELONGTO_INSTITUTION_STOCK,
                    0 AS RESERVE_PURCHASE_ORDER_STOCK,
                    0 AS PRODUCTION_ORDER_STOCK,
                    0 AS NOSALE_RESERVED_STOCK,
                    SR.STOCK_ID,
                    SR.PRODUCT_ID,
                    SR.STORE AS DEPARTMENT_ID,
                    SR.STORE_LOCATION AS LOCATION_ID
                FROM
                    [@_dsn_main_@].STOCKS_LOCATION SL WITH (NOLOCK),
                    STOCKS_ROW SR WITH (NOLOCK)
                JOIN
                    fnSplit(@stock_id_list,',') AS TB1
                ON 
                    TB1.item = SR.STOCK_ID
                WHERE
                    SR.STORE =SL.DEPARTMENT_ID AND 
                    SR.STORE_LOCATION=SL.LOCATION_ID AND 
                    SL.BELONGTO_INSTITUTION =1
                UNION ALL
                SELECT
                    0 AS REAL_STOCK,
                    0 AS PRODUCT_STOCK,
                    ((RESERVE_STOCK_OUT-STOCK_OUT)*-1) AS RESERVED_STOCK,
                    0 AS PURCHASE_PROD_STOCK,
                    0 AS RESERVED_PROD_STOCK,
                    (RESERVE_STOCK_OUT-STOCK_OUT) AS RESERVE_SALE_ORDER_STOCK,
                    0 AS NOSALE_STOCK,
                    0 AS BELONGTO_INSTITUTION_STOCK,
                    (RESERVE_STOCK_IN-STOCK_IN) AS RESERVE_PURCHASE_ORDER_STOCK,
                    0 AS PRODUCTION_ORDER_STOCK,
                    0 AS NOSALE_RESERVED_STOCK,
                    ORR.STOCK_ID,
                    ORR.PRODUCT_ID,
                    ORDS.DELIVER_DEPT_ID AS DEPARTMENT_ID,
                    ORDS.LOCATION_ID AS LOCATION_ID
                FROM
                    [@_dsn_company_@].GET_ORDER_ROW_RESERVED ORR WITH (NOLOCK)
                JOIN
                    fnSplit(@stock_id_list,',') AS TB1
                ON 
                    TB1.item = ORR.STOCK_ID
                    , 
                    [@_dsn_company_@].ORDERS ORDS WITH (NOLOCK)
                WHERE
                    ORDS.RESERVED = 1 AND 
                    ORDS.ORDER_STATUS = 1 AND	
                    ORDS.DELIVER_DEPT_ID IS NOT NULL AND
                    ORDS.LOCATION_ID IS NOT NULL AND
                    ORR.ORDER_ID = ORDS.ORDER_ID AND 
                    ((RESERVE_STOCK_IN-STOCK_IN)>0 OR (RESERVE_STOCK_OUT-STOCK_OUT)>0) 
                UNION ALL
                SELECT
                    0 AS REAL_STOCK,
                    0 AS PRODUCT_STOCK,
                    (RESERVE_STOCK_IN-STOCK_IN) AS RESERVED_STOCK,
                    0 AS PURCHASE_PROD_STOCK,
                    0 AS RESERVED_PROD_STOCK,
                    0 AS RESERVE_SALE_ORDER_STOCK,
                    0 AS NOSALE_STOCK,
                    0 AS BELONGTO_INSTITUTION_STOCK,
                    0 AS RESERVE_PURCHASE_ORDER_STOCK,
                    0 AS PRODUCTION_ORDER_STOCK,
                    0 AS NOSALE_RESERVED_STOCK,
                    ORR.STOCK_ID,
                    ORR.PRODUCT_ID,
                    ORDS.DELIVER_DEPT_ID AS DEPARTMENT_ID,
                    ORDS.LOCATION_ID AS LOCATION_ID
                FROM
                    [@_dsn_company_@].GET_ORDER_ROW_RESERVED ORR WITH (NOLOCK)
                JOIN
                    fnSplit(@stock_id_list,',') AS TB1
                ON 
                    TB1.item = ORR.STOCK_ID	
                    , 
                    [@_dsn_company_@].ORDERS ORDS WITH (NOLOCK),
                    [@_dsn_main_@].STOCKS_LOCATION SL WITH (NOLOCK)
                WHERE
                    ORDS.RESERVED = 1 AND 
                    ORDS.ORDER_STATUS = 1 AND
                    ORDS.DELIVER_DEPT_ID = SL.DEPARTMENT_ID AND
                    ORDS.LOCATION_ID = SL.LOCATION_ID AND
                    SL.NO_SALE=0 AND
                    ORDS.PURCHASE_SALES=0 AND
                    ORDS.ORDER_ZONE=0 AND
                    ORR.ORDER_ID = ORDS.ORDER_ID AND 
                    (RESERVE_STOCK_IN-STOCK_IN)>0 
                UNION ALL
                SELECT
                    0 AS REAL_STOCK,
                    0 AS PRODUCT_STOCK,
                    0 AS RESERVED_STOCK,
                    0 AS PURCHASE_PROD_STOCK,
                    0 AS RESERVED_PROD_STOCK,
                    0 AS RESERVE_SALE_ORDER_STOCK,
                    0 AS NOSALE_STOCK,
                    0 AS BELONGTO_INSTITUTION_STOCK,
                    0 AS RESERVE_PURCHASE_ORDER_STOCK,
                    0 AS PRODUCTION_ORDER_STOCK,
                    (RESERVE_STOCK_IN-STOCK_IN) AS NOSALE_RESERVED_STOCK,
                    ORR.STOCK_ID,
                    ORR.PRODUCT_ID,
                    ORDS.DELIVER_DEPT_ID AS DEPARTMENT_ID,
                    ORDS.LOCATION_ID AS LOCATION_ID
                FROM
                    [@_dsn_company_@].GET_ORDER_ROW_RESERVED ORR WITH (NOLOCK)
                JOIN
                    fnSplit(@stock_id_list,',') AS TB1
                ON 
                    TB1.item = ORR.STOCK_ID
                    , 
                    [@_dsn_company_@].ORDERS ORDS WITH (NOLOCK),
                    [@_dsn_main_@].STOCKS_LOCATION SL WITH (NOLOCK)
                WHERE
                    ORDS.RESERVED = 1 AND 
                    ORDS.ORDER_STATUS = 1 AND	
                    ORDS.DELIVER_DEPT_ID IS NOT NULL AND
                    ORDS.LOCATION_ID IS NOT NULL AND
                    ORDS.DELIVER_DEPT_ID = SL.DEPARTMENT_ID AND
                    ORDS.LOCATION_ID = SL.LOCATION_ID AND
                    SL.NO_SALE = 1 AND
                    ORDS.PURCHASE_SALES = 0 AND
                    ORDS.ORDER_ZONE = 0 AND
                    ORR.ORDER_ID = ORDS.ORDER_ID AND 
                    (RESERVE_STOCK_IN-STOCK_IN)>0 
                UNION ALL
                SELECT
                        0 AS REAL_STOCK,
                        0 AS PRODUCT_STOCK,
                        (STOCK_ARTIR-STOCK_AZALT) AS RESERVED_STOCK,
                        STOCK_ARTIR AS PURCHASE_PROD_STOCK,
                        STOCK_AZALT AS RESERVED_PROD_STOCK,
                        0 AS RESERVE_SALE_ORDER_STOCK,
                        0 AS NOSALE_STOCK,
                        0 AS BELONGTO_INSTITUTION_STOCK,
                        0 AS RESERVE_PURCHASE_ORDER_STOCK,
                        (STOCK_ARTIR-STOCK_AZALT) AS PRODUCTION_ORDER_STOCK,
                        0 AS NOSALE_RESERVED_STOCK,
                        STOCK_ID,
                        PRODUCT_ID,
                        DEPARTMENT_ID,
                        LOCATION_ID
                    FROM
                        [@_dsn_company_@].GET_PRODUCTION_RESERVED_LOCATION WITH (NOLOCK)
                    JOIN
                        fnSplit(@stock_id_list,',') AS TB1
                    ON 
                        TB1.item = GET_PRODUCTION_RESERVED_LOCATION.STOCK_ID
            ) T1
            GROUP BY
                PRODUCT_ID, 
                STOCK_ID,
                DEPARTMENT_ID,
                LOCATION_ID
            
            END;

CREATE PROCEDURE [@_dsn_period_@].[get_stock_last_spect_location_function]
                (
                    @stock_id_list nvarchar (max)
                )
            AS
            BEGIN 
        
                SELECT
                    SUM(REAL_STOCK) REAL_STOCK,
                    SUM(PRODUCT_STOCK) PRODUCT_STOCK,
                    SUM(PRODUCT_STOCK+RESERVED_STOCK) SALEABLE_STOCK,
                    SUM(PURCHASE_ORDER_STOCK) PURCHASE_ORDER_STOCK,
                    PRODUCT_ID,
                    STOCK_ID,
                    SPECT_MAIN_ID,
                    (SELECT SM.SPECT_MAIN_NAME FROM [@_dsn_company_@].SPECT_MAIN SM WITH (NOLOCK) WHERE SM.SPECT_MAIN_ID = T1.SPECT_MAIN_ID) SPECT_MAIN_NAME,
                    DEPARTMENT_ID,
                    LOCATION_ID
                FROM
                (
                    SELECT
                        (STOCK_IN - STOCK_OUT) AS REAL_STOCK,
                        0 AS PRODUCT_STOCK,
                        0 AS RESERVED_STOCK,
                        0 AS SALE_ORDER_STOCK,
                        0 AS PURCHASE_ORDER_STOCK,
                        SR.PRODUCT_ID, 
                        SR.STOCK_ID,
                        SR.SPECT_VAR_ID SPECT_MAIN_ID,
                        SR.STORE AS DEPARTMENT_ID,
                        SR.STORE_LOCATION AS LOCATION_ID
                    FROM			
                        STOCKS_ROW SR WITH (NOLOCK)
                    JOIN
                        fnSplit(@stock_id_list,',') AS TB1
                    ON 
                        TB1.item = SR.STOCK_ID
                    UNION ALL
                    SELECT
                        0 AS REAL_STOCK,
                        (STOCK_IN - STOCK_OUT) AS PRODUCT_STOCK,
                        0 AS RESERVED_STOCK,
                        0 AS SALE_ORDER_STOCK,
                        0 AS PURCHASE_ORDER_STOCK,
                        SR.PRODUCT_ID, 
                        SR.STOCK_ID,
                        SR.SPECT_VAR_ID SPECT_MAIN_ID,
                        SR.STORE AS DEPARTMENT_ID,
                        SR.STORE_LOCATION AS LOCATION_ID
                    FROM			
                        [@_dsn_main_@].STOCKS_LOCATION SL WITH (NOLOCK),
                        STOCKS_ROW SR WITH (NOLOCK)
                    JOIN
                        fnSplit(@stock_id_list,',') AS TB1
                    ON 
                        TB1.item = SR.STOCK_ID
                    WHERE			
                        SR.STORE =SL.DEPARTMENT_ID AND 
                        SR.STORE_LOCATION=SL.LOCATION_ID AND 
                        SL.NO_SALE = 0 
                    UNION ALL
                    SELECT
                        0 AS REAL_STOCK,
                        -1*(STOCK_IN - STOCK_OUT) AS PRODUCT_STOCK,
                        0 AS RESERVED_STOCK,
                        0 AS SALE_ORDER_STOCK,
                        0 AS PURCHASE_ORDER_STOCK,
                        SR.PRODUCT_ID, 
                        SR.STOCK_ID,
                        SR.SPECT_VAR_ID SPECT_MAIN_ID,
                        SR.STORE AS DEPARTMENT_ID,
                        SR.STORE_LOCATION AS LOCATION_ID
                    FROM
                        STOCKS_ROW SR WITH (NOLOCK)
                    JOIN
                        fnSplit(@stock_id_list,',') AS TB1
                    ON 
                        TB1.item = SR.STOCK_ID	
                        ,
                        [@_dsn_main_@].STOCKS_LOCATION SL WITH (NOLOCK)
                    WHERE	
                        SR.STORE = SL.DEPARTMENT_ID AND
                        SR.STORE_LOCATION = SL.LOCATION_ID AND
                        ISNULL(SL.IS_SCRAP,0)=1	
                    UNION ALL
                    SELECT
                        0 AS REAL_STOCK,
                        0 AS PRODUCT_STOCK,
                        ((ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)*-1) AS RESERVED_STOCK,
                        0 AS SALE_ORDER_STOCK,
                        ORR.RESERVE_STOCK_IN AS PURCHASE_ORDER_STOCK,
                        ORR.PRODUCT_ID, 
                        ORR.STOCK_ID,
                        (SELECT SPECT_MAIN_ID FROM [@_dsn_company_@].SPECTS WITH (NOLOCK) WHERE SPECT_VAR_ID = ORR.SPECT_VAR_ID) SPECT_MAIN_ID,
                        ORDS.DELIVER_DEPT_ID AS DEPARTMENT_ID,
                        ORDS.LOCATION_ID AS LOCATION_ID
                    FROM
                        [@_dsn_company_@].GET_ORDER_ROW_RESERVED  ORR WITH (NOLOCK)
                    JOIN
                        fnSplit(@stock_id_list,',') AS TB1
                    ON 
                        TB1.item = ORR.STOCK_ID	
                        , 
                        [@_dsn_company_@].ORDERS ORDS WITH (NOLOCK)
                    WHERE
                        ORDS.RESERVED = 1 AND 
                        ORDS.ORDER_STATUS = 1 AND	
                        ORR.ORDER_ID = ORDS.ORDER_ID AND
                        ((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0 OR (ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)>0)
                    UNION ALL
                    SELECT
                        0 AS REAL_STOCK,
                        0 AS PRODUCT_STOCK,
                        (ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) AS RESERVED_STOCK,
                        0 AS SALE_ORDER_STOCK,
                        0 AS PURCHASE_ORDER_STOCK,
                        ORR.PRODUCT_ID, 
                        ORR.STOCK_ID,
                        (SELECT SPECT_MAIN_ID FROM [@_dsn_company_@].SPECTS WITH (NOLOCK) WHERE SPECT_VAR_ID = ORR.SPECT_VAR_ID) SPECT_MAIN_ID,
                        ORDS.DELIVER_DEPT_ID AS DEPARTMENT_ID,
                        ORDS.LOCATION_ID AS LOCATION_ID
                    FROM
                        [@_dsn_main_@].STOCKS_LOCATION SL WITH (NOLOCK),
                        [@_dsn_company_@].GET_ORDER_ROW_RESERVED ORR WITH (NOLOCK)
                    JOIN
                        fnSplit(@stock_id_list,',') AS TB1
                    ON 
                        TB1.item = ORR.STOCK_ID		
                        , 
                        [@_dsn_company_@].ORDERS ORDS WITH (NOLOCK)
                    WHERE
                        ORDS.DELIVER_DEPT_ID = SL.DEPARTMENT_ID AND
                        ORDS.LOCATION_ID = SL.LOCATION_ID AND
                        SL.NO_SALE = 0 AND
                        ORDS.PURCHASE_SALES = 0 AND
                        ORDS.ORDER_ZONE = 0 AND	
                        ORDS.RESERVED = 1 AND 
                        ORDS.ORDER_STATUS = 1 AND	
                        ORR.ORDER_ID = ORDS.ORDER_ID AND
                        (ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0 
                    UNION ALL
                    SELECT
                        0 AS REAL_STOCK,
                        0 AS PRODUCT_STOCK,
                        (STOCK_ARTIR-STOCK_AZALT) AS RESERVED_STOCK,
                        0 AS SALE_ORDER_STOCK,
                        0 AS PURCHASE_ORDER_STOCK,
                        GRS.PRODUCT_ID, 
                        GRS.STOCK_ID,
                        GRS.SPECT_MAIN_ID SPECT_MAIN_ID,
                        DEPARTMENT_ID,
                        LOCATION_ID
                    FROM
                        [@_dsn_company_@].GET_PRODUCTION_RESERVED_SPECT_LOCATION GRS WITH (NOLOCK)
                    JOIN
                        fnSplit(@stock_id_list,',') AS TB1
                    ON 
                        TB1.item = GRS.STOCK_ID	
                ) T1
                GROUP BY
                    PRODUCT_ID, 
                    STOCK_ID,
                    SPECT_MAIN_ID,
                    DEPARTMENT_ID,
                    LOCATION_ID
            END;

CREATE PROCEDURE [@_dsn_period_@].[get_stock_last_spect_location_function_with_spect_main_id]
                (
                    @spect_main_id_list nvarchar (max)
                )
            AS
            BEGIN 
        
                SELECT
                    SUM(REAL_STOCK) REAL_STOCK,
                    SUM(PRODUCT_STOCK) PRODUCT_STOCK,
                    SUM(PRODUCT_STOCK+RESERVED_STOCK) SALEABLE_STOCK,
                    SUM(PURCHASE_ORDER_STOCK) PURCHASE_ORDER_STOCK,
                    PRODUCT_ID,
                    STOCK_ID,
                    SPECT_MAIN_ID,
                    (SELECT SM.SPECT_MAIN_NAME FROM [@_dsn_company_@].SPECT_MAIN SM WITH (NOLOCK) WHERE SM.SPECT_MAIN_ID = T1.SPECT_MAIN_ID) SPECT_MAIN_NAME,
                    DEPARTMENT_ID,
                    LOCATION_ID
                FROM
                (
                    SELECT
                        (STOCK_IN - STOCK_OUT) AS REAL_STOCK,
                        0 AS PRODUCT_STOCK,
                        0 AS RESERVED_STOCK,
                        0 AS SALE_ORDER_STOCK,
                        0 AS PURCHASE_ORDER_STOCK,
                        SR.PRODUCT_ID, 
                        SR.STOCK_ID,
                        SR.SPECT_VAR_ID SPECT_MAIN_ID,
                        SR.STORE AS DEPARTMENT_ID,
                        SR.STORE_LOCATION AS LOCATION_ID
                    FROM			
                        STOCKS_ROW SR WITH (NOLOCK)
                    JOIN
                    	fnSplit(@spect_main_id_list,',') AS TB1
                	ON 
                    	TB1.item = SR.SPECT_VAR_ID
                    UNION ALL
                    SELECT
                        0 AS REAL_STOCK,
                        (STOCK_IN - STOCK_OUT) AS PRODUCT_STOCK,
                        0 AS RESERVED_STOCK,

                        0 AS SALE_ORDER_STOCK,
                        0 AS PURCHASE_ORDER_STOCK,
                        SR.PRODUCT_ID, 
                        SR.STOCK_ID,
                        SR.SPECT_VAR_ID SPECT_MAIN_ID,
                        SR.STORE AS DEPARTMENT_ID,
                        SR.STORE_LOCATION AS LOCATION_ID
                    FROM			
                        [@_dsn_main_@].STOCKS_LOCATION SL WITH (NOLOCK),
                        STOCKS_ROW SR WITH (NOLOCK)
                    JOIN
                    	fnSplit(@spect_main_id_list,',') AS TB1
                	ON 
                    	TB1.item = SR.SPECT_VAR_ID
                    WHERE			
                        SR.STORE =SL.DEPARTMENT_ID AND 
                        SR.STORE_LOCATION=SL.LOCATION_ID AND 
                        SL.NO_SALE = 0 
                    UNION ALL
                    SELECT
                        0 AS REAL_STOCK,
                        -1*(STOCK_IN - STOCK_OUT) AS PRODUCT_STOCK,
                        0 AS RESERVED_STOCK,
                        0 AS SALE_ORDER_STOCK,
                        0 AS PURCHASE_ORDER_STOCK,
                        SR.PRODUCT_ID, 
                        SR.STOCK_ID,
                        SR.SPECT_VAR_ID SPECT_MAIN_ID,
                        SR.STORE AS DEPARTMENT_ID,
                        SR.STORE_LOCATION AS LOCATION_ID
                    FROM
                        STOCKS_ROW SR WITH (NOLOCK)
                    JOIN
                    	fnSplit(@spect_main_id_list,',') AS TB1
                    ON 
                    	TB1.item = SR.SPECT_VAR_ID	
                    	,[@_dsn_main_@].STOCKS_LOCATION SL WITH (NOLOCK)
                    WHERE	
                        SR.STORE = SL.DEPARTMENT_ID AND
                        SR.STORE_LOCATION = SL.LOCATION_ID AND
                        ISNULL(SL.IS_SCRAP,0)=1	
                    UNION ALL
                    SELECT
                        0 AS REAL_STOCK,
                        0 AS PRODUCT_STOCK,
                        ((ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)*-1) AS RESERVED_STOCK,
                        0 AS SALE_ORDER_STOCK,
                        ORR.RESERVE_STOCK_IN AS PURCHASE_ORDER_STOCK,
                        ORR.PRODUCT_ID, 
                        ORR.STOCK_ID,
                        S.SPECT_MAIN_ID,
                        ORDS.DELIVER_DEPT_ID AS DEPARTMENT_ID,
                        ORDS.LOCATION_ID AS LOCATION_ID
                    FROM
                        [@_dsn_company_@].GET_ORDER_ROW_RESERVED  ORR WITH (NOLOCK)
                    LEFT JOIN
						 [@_dsn_company_@].SPECTS S
					ON	
						S.SPECT_VAR_ID = ORR.SPECT_VAR_ID
					JOIN
                     	fnSplit(@spect_main_id_list,',') AS TB1
                	ON 
                     	TB1.item = S.SPECT_MAIN_ID	
                        ,[@_dsn_company_@].ORDERS ORDS WITH (NOLOCK)
                    WHERE
                        ORDS.RESERVED = 1 AND 
                        ORDS.ORDER_STATUS = 1 AND	
                        ORR.ORDER_ID = ORDS.ORDER_ID AND
                        ((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0 OR (ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)>0)
                    UNION ALL
                    SELECT
                        0 AS REAL_STOCK,
                        0 AS PRODUCT_STOCK,
                        (ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) AS RESERVED_STOCK,
                        0 AS SALE_ORDER_STOCK,
                        0 AS PURCHASE_ORDER_STOCK,
                        ORR.PRODUCT_ID, 
                        ORR.STOCK_ID,
                        S.SPECT_MAIN_ID,
                        ORDS.DELIVER_DEPT_ID AS DEPARTMENT_ID,
                        ORDS.LOCATION_ID AS LOCATION_ID
                    FROM
                        [@_dsn_main_@].STOCKS_LOCATION SL WITH (NOLOCK),
                        [@_dsn_company_@].GET_ORDER_ROW_RESERVED ORR WITH (NOLOCK)
                    
                    LEFT JOIN
						 [@_dsn_company_@].SPECTS S
					ON	
						S.SPECT_VAR_ID = ORR.SPECT_VAR_ID
					JOIN
                     	fnSplit(@spect_main_id_list,',') AS TB1
                	ON 
                     	TB1.item = S.SPECT_MAIN_ID	
                    ,[@_dsn_company_@].ORDERS ORDS WITH (NOLOCK)
                    WHERE
                        ORDS.DELIVER_DEPT_ID = SL.DEPARTMENT_ID AND
                        ORDS.LOCATION_ID = SL.LOCATION_ID AND
                        SL.NO_SALE = 0 AND
                        ORDS.PURCHASE_SALES = 0 AND
                        ORDS.ORDER_ZONE = 0 AND	
                        ORDS.RESERVED = 1 AND 
                        ORDS.ORDER_STATUS = 1 AND	
                        ORR.ORDER_ID = ORDS.ORDER_ID AND
                        (ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0 
                    UNION ALL
                    SELECT
                        0 AS REAL_STOCK,
                        0 AS PRODUCT_STOCK,
                        (STOCK_ARTIR-STOCK_AZALT) AS RESERVED_STOCK,
                        0 AS SALE_ORDER_STOCK,
                        0 AS PURCHASE_ORDER_STOCK,
                        GRS.PRODUCT_ID, 
                        GRS.STOCK_ID,
                        GRS.SPECT_MAIN_ID SPECT_MAIN_ID,
                        DEPARTMENT_ID,
                        LOCATION_ID
                    FROM
                        [@_dsn_company_@].GET_PRODUCTION_RESERVED_SPECT_LOCATION GRS WITH (NOLOCK)
                   JOIN
                     	fnSplit(@spect_main_id_list,',') AS TB1
                	ON 
                     	TB1.item = GRS.SPECT_MAIN_ID	
                ) T1
                GROUP BY
                    PRODUCT_ID, 
                    STOCK_ID,
                    SPECT_MAIN_ID,
                    DEPARTMENT_ID,
                    LOCATION_ID
            END;

CREATE PROCEDURE [@_dsn_period_@].[get_stock_last_spect_with_spect_id] 
	@spect_id_list nvarchar(max)
    AS
		SELECT
			SUM(REAL_STOCK) REAL_STOCK,
			SUM(PRODUCT_STOCK) PRODUCT_STOCK,
			SUM(PRODUCT_STOCK+RESERVED_STOCK) SALEABLE_STOCK,
			SUM(PURCHASE_ORDER_STOCK) PURCHASE_ORDER_STOCK,
			PRODUCT_ID,
			STOCK_ID,
			SPECT_MAIN_ID
		FROM
		(
			SELECT
				(STOCK_IN - STOCK_OUT) AS REAL_STOCK,
				0 AS PRODUCT_STOCK,
				0 AS RESERVED_STOCK,
				0 AS SALE_ORDER_STOCK,
				0 AS PURCHASE_ORDER_STOCK,
				SR.PRODUCT_ID, 
				SR.STOCK_ID,
				SR.SPECT_VAR_ID SPECT_MAIN_ID
			FROM			
				STOCKS_ROW SR WITH (NOLOCK)
			JOIN
                    [@_dsn_main_@].fnSplit(@spect_id_list,',') AS TB1
                ON 
                    TB1.item = SR.SPECT_VAR_ID
		UNION ALL
			SELECT
				0 AS REAL_STOCK,
				(STOCK_IN - STOCK_OUT) AS PRODUCT_STOCK,
				0 AS RESERVED_STOCK,
				0 AS SALE_ORDER_STOCK,
				0 AS PURCHASE_ORDER_STOCK,
				SR.PRODUCT_ID, 
				SR.STOCK_ID,
				SR.SPECT_VAR_ID SPECT_MAIN_ID
			FROM			
				[@_dsn_main_@].STOCKS_LOCATION SL,
				STOCKS_ROW SR WITH (NOLOCK)
				JOIN
                    [@_dsn_main_@].fnSplit(@spect_id_list,',') AS TB1
                ON 
                    TB1.item = SR.SPECT_VAR_ID
			WHERE			
				SR.STORE =SL.DEPARTMENT_ID
				AND SR.STORE_LOCATION=SL.LOCATION_ID
				AND SL.NO_SALE = 0
		UNION ALL
			SELECT
				0 AS REAL_STOCK,
				-1*(STOCK_IN - STOCK_OUT) AS PRODUCT_STOCK,
				0 AS RESERVED_STOCK,
				0 AS SALE_ORDER_STOCK,
				0 AS PURCHASE_ORDER_STOCK,
				SR.PRODUCT_ID, 
				SR.STOCK_ID,
				SR.SPECT_VAR_ID SPECT_MAIN_ID
			FROM
				STOCKS_ROW SR WITH (NOLOCK)
				JOIN
                    [@_dsn_main_@].fnSplit(@spect_id_list,',') AS TB1
                ON 
                    TB1.item = SR.SPECT_VAR_ID
				,
				[@_dsn_main_@].STOCKS_LOCATION SL  
			WHERE	
				SR.STORE = SL.DEPARTMENT_ID AND
				SR.STORE_LOCATION = SL.LOCATION_ID AND
				ISNULL(SL.IS_SCRAP,0)=1	
	UNION ALL
			SELECT
				0 AS REAL_STOCK,
				0 AS PRODUCT_STOCK,
				((ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)*-1)  AS RESERVED_STOCK,
				0 AS SALE_ORDER_STOCK,
				ORR.RESERVE_STOCK_IN  AS PURCHASE_ORDER_STOCK,
				ORR.PRODUCT_ID, 
				ORR.STOCK_ID,
				(SELECT SPECT_MAIN_ID FROM [@_dsn_company_@].SPECTS WHERE SPECT_VAR_ID=ORR.SPECT_VAR_ID) SPECT_MAIN_ID
			FROM
				[@_dsn_company_@].GET_ORDER_ROW_RESERVED ORR WITH (NOLOCK)
				JOIN
                    [@_dsn_main_@].fnSplit(@spect_id_list,',') AS TB1
                ON 
                    TB1.item = ORR.SPECT_VAR_ID
				, 
				[@_dsn_company_@].ORDERS ORDS WITH (NOLOCK)
			WHERE
				ORDS.RESERVED = 1 AND 
				ORDS.ORDER_STATUS = 1 AND	
				ORR.ORDER_ID = ORDS.ORDER_ID AND
				((ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0 OR (ORR.RESERVE_STOCK_OUT-ORR.STOCK_OUT)>0)	
		UNION ALL
			SELECT
				0 AS REAL_STOCK,
				0 AS PRODUCT_STOCK,
				(ORR.RESERVE_STOCK_IN-ORR.STOCK_IN) AS RESERVED_STOCK,
				0 AS SALE_ORDER_STOCK,
				0 AS PURCHASE_ORDER_STOCK,
				ORR.PRODUCT_ID, 
				ORR.STOCK_ID,
				(SELECT SPECT_MAIN_ID FROM [@_dsn_company_@].SPECTS WHERE SPECT_VAR_ID=ORR.SPECT_VAR_ID) SPECT_MAIN_ID
			FROM
				[@_dsn_main_@].STOCKS_LOCATION SL,
				[@_dsn_company_@].GET_ORDER_ROW_RESERVED ORR WITH (NOLOCK)
				JOIN
                    [@_dsn_main_@].fnSplit(@spect_id_list,',') AS TB1
                ON 
                    TB1.item = ORR.SPECT_VAR_ID
				, 
				[@_dsn_company_@].ORDERS ORDS WITH (NOLOCK)
			WHERE
				ORDS.DELIVER_DEPT_ID=SL.DEPARTMENT_ID AND
				ORDS.LOCATION_ID=SL.LOCATION_ID AND
				SL.NO_SALE = 0 AND
				ORDS.PURCHASE_SALES=0 AND
				ORDS.ORDER_ZONE=0 AND	
				ORDS.RESERVED = 1 AND 
				ORDS.ORDER_STATUS = 1 AND	
				ORR.ORDER_ID = ORDS.ORDER_ID AND
				(ORR.RESERVE_STOCK_IN-ORR.STOCK_IN)>0
		UNION ALL
			SELECT
				0 AS REAL_STOCK,
				0 AS PRODUCT_STOCK,
				(STOCK_ARTIR-STOCK_AZALT) AS RESERVED_STOCK,
				0 AS SALE_ORDER_STOCK,
				0 AS PURCHASE_ORDER_STOCK,
				GRS.PRODUCT_ID, 
				GRS.STOCK_ID,
				GRS.SPECT_MAIN_ID SPECT_MAIN_ID
			FROM
				[@_dsn_company_@].GET_PRODUCTION_RESERVED_SPECT GRS WITH (NOLOCK)
				JOIN
                    [@_dsn_main_@].fnSplit(@spect_id_list,',') AS TB1
                ON 
                    TB1.item = GRS.SPECT_MAIN_ID
			
		) T1
		GROUP BY
			PRODUCT_ID, 
			STOCK_ID,
			SPECT_MAIN_ID

CREATE PROCEDURE [@_dsn_period_@].[SP_GET_STOCK_ALL]
            @stock_id_list NVARCHAR(850),
            @type int,
            @p_order_id int 
        AS
        BEGIN
            SET NOCOUNT ON;
            IF @p_order_id <> -1
            BEGIN
                IF @type =1
                BEGIN
                
                    SELECT																																																																																																																																																																																																																																	 
                        ISNULL(PRODUCT_STOCK,0) AS PRODUCT_STOCK,
                        ISNULL(SALEABLE_STOCK,0) AS SALEABLE_STOCK,
                        STOCK_ID,
                        SPEC_MAIN_ID
                    FROM 
                        (
                        SELECT 
                            ROUND(SUM(REAL_STOCK),4) REAL_STOCK,
                            ROUND(SUM(PRODUCT_STOCK),4) PRODUCT_STOCK,
                            ROUND(SUM(PRODUCT_STOCK+RESERVED_STOCK),4) SALEABLE_STOCK,
                            ROUND(SUM(PURCHASE_ORDER_STOCK),4) PURCHASE_ORDER_STOCK,
                            STOCK_ID,
                            T1.SPEC_MAIN_ID
                        FROM
                        (
                            SELECT
                                (SR.STOCK_IN - SR.STOCK_OUT) AS REAL_STOCK,
                                0 AS PRODUCT_STOCK,
                                0 AS RESERVED_STOCK,
                                0 AS PURCHASE_ORDER_STOCK,
                                SR.STOCK_ID,
                                ISNULL(SR.SPECT_VAR_ID,0) SPEC_MAIN_ID
                            FROM
                                STOCKS_ROW SR
                            JOIN [@_dsn_main_@].fnsplit(@stock_id_list,',') AS XXX on XXX.item = SR.STOCK_ID
                            WHERE
                                1=1
                        UNION ALL			
                            SELECT
                                0 AS REAL_STOCK,
                                (SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK,
                                0 AS RESERVED_STOCK,
                                0 AS PURCHASE_ORDER_STOCK,
                                SR.STOCK_ID,
                                ISNULL(SR.SPECT_VAR_ID,0) SPEC_MAIN_ID
                            FROM
                                [@_dsn_main_@].STOCKS_LOCATION SL,
                                STOCKS_ROW SR
                                JOIN [@_dsn_main_@].fnsplit(@stock_id_list,',') AS XXX on XXX.item = SR.STOCK_ID
                            WHERE
                                SR.STORE =SL.DEPARTMENT_ID
                                AND SR.STORE_LOCATION=SL.LOCATION_ID
                                AND SL.NO_SALE = 0
                        UNION ALL
                            SELECT
                                0 AS REAL_STOCK,
                                0 AS PRODUCT_STOCK,
                                ((RESERVE_STOCK_OUT-STOCK_OUT)*-1) AS RESERVED_STOCK,
                                RESERVE_STOCK_IN AS PURCHASE_ORDER_STOCK,
                                ORR.STOCK_ID,
                                ISNULL(ORR.SPECT_VAR_ID,0) SPEC_MAIN_ID
                            FROM
                                [@_dsn_company_@].GET_ORDER_ROW_RESERVED ORR
                                JOIN [@_dsn_main_@].fnsplit(@stock_id_list,',') AS XXX on XXX.item = ORR.STOCK_ID, 
                                [@_dsn_company_@].ORDERS ORDS
                            WHERE
                                ORDS.RESERVED = 1 AND 
                                ORDS.ORDER_STATUS = 1 AND	
                                ORR.ORDER_ID=ORDS.ORDER_ID AND 
                                ((RESERVE_STOCK_IN-STOCK_IN)>0 OR (RESERVE_STOCK_OUT-STOCK_OUT)>0)
                        UNION ALL
                            SELECT
                                0 AS REAL_STOCK,
                                0 AS PRODUCT_STOCK,
                                (RESERVE_STOCK_IN-STOCK_IN) AS RESERVED_STOCK,
                                0 AS PURCHASE_ORDER_STOCK,
                                ORR.STOCK_ID,
                                ISNULL(ORR.SPECT_VAR_ID,0) SPEC_MAIN_ID
                            FROM
                                [@_dsn_company_@].GET_ORDER_ROW_RESERVED ORR
                                JOIN [@_dsn_main_@].fnsplit(@stock_id_list,',') AS XXX on XXX.item = ORR.STOCK_ID, 
                                [@_dsn_company_@].ORDERS ORDS,
                                [@_dsn_main_@].STOCKS_LOCATION SL
                            WHERE
                                ORDS.RESERVED = 1 AND 
                                ORDS.ORDER_STATUS = 1 AND	
                                ORDS.DELIVER_DEPT_ID =SL.DEPARTMENT_ID AND 
                                ORDS.LOCATION_ID=SL.LOCATION_ID AND 
                                SL.NO_SALE = 0	 AND 
                                ORR.ORDER_ID=ORDS.ORDER_ID AND 
                                (RESERVE_STOCK_IN-STOCK_IN)>0
                        UNION ALL			
                            SELECT
                                0 AS REAL_STOCK,
                                0 AS PRODUCT_STOCK,
                                ((RESERVE_STOCK_IN-STOCK_IN) + ((RESERVE_STOCK_OUT-STOCK_OUT)*-1)) AS RESERVED_STOCK,
                                0 AS PURCHASE_ORDER_STOCK,
                                ORR.STOCK_ID,
                                ISNULL(ORR.SPECT_VAR_ID,0) SPEC_MAIN_ID
                            FROM
                                [@_dsn_company_@].ORDER_ROW_RESERVED  ORR
                            	JOIN [@_dsn_main_@].fnsplit(@stock_id_list,',') AS XXX on XXX.item = ORR.STOCK_ID
                            WHERE
                                ORDER_ID IS NULL
                                AND SHIP_ID IS NULL
                                AND INVOICE_ID IS NULL
                        UNION ALL
                            SELECT
                                0 AS REAL_STOCK,
                                0 AS PRODUCT_STOCK,

                                (STOCK_ARTIR-STOCK_AZALT) AS RESERVED_STOCK,
                                0  AS PURCHASE_ORDER_STOCK,
                                STOCK_ID,
                                SPEC_MAIN_ID
                            FROM
                                (
                                    SELECT
                                        SUM(STOCK_ARTIR) STOCK_ARTIR,
                                        SUM(STOCK_AZALT) STOCK_AZALT,
                                        STOCK_ID,
                                        SPEC_MAIN_ID
                                    FROM
                                        (
                                            SELECT
                                                (QUANTITY) AS STOCK_ARTIR,
                                                0 AS STOCK_AZALT,
                                                STOCK_ID,
                                                ISNULL(SPEC_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM
                                                [@_dsn_company_@].PRODUCTION_ORDERS
                                                JOIN [@_dsn_main_@].fnsplit(@stock_id_list,',') AS XXX on XXX.item = PRODUCTION_ORDERS.STOCK_ID
                                            WHERE
                                                IS_STOCK_RESERVED = 1 AND
                                                IS_DEMONTAJ=0 AND
                                                SPEC_MAIN_ID IS NOT NULL
                                        UNION ALL
                                            SELECT
                                                0 AS STOCK_ARTIR,
                                                (QUANTITY) AS STOCK_AZALT,
                                                STOCK_ID,
                                                ISNULL(SPEC_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM
                                                [@_dsn_company_@].PRODUCTION_ORDERS
                                                JOIN [@_dsn_main_@].fnsplit(@stock_id_list,',') AS XXX on XXX.item = PRODUCTION_ORDERS.STOCK_ID
                                            WHERE
                                                IS_STOCK_RESERVED = 1 AND
                                                IS_DEMONTAJ=1 AND
                                                SPEC_MAIN_ID IS NOT NULL
                                        UNION ALL
                                            SELECT
                                                0 AS STOCK_ARTIR,
                                                POS.AMOUNT AS STOCK_AZALT,
                                                POS.STOCK_ID,
                                                ISNULL(POS.SPECT_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM
                                                [@_dsn_company_@].PRODUCTION_ORDERS PO,
                                                [@_dsn_company_@].PRODUCTION_ORDERS_STOCKS POS
                                                JOIN [@_dsn_main_@].fnsplit(@stock_id_list,',') AS XXX on XXX.item = POS.STOCK_ID
                                            WHERE
                                                PO.IS_STOCK_RESERVED = 1 AND
                                                PO.P_ORDER_ID = POS.P_ORDER_ID AND
                                                PO.IS_DEMONTAJ=0 AND
                                                ISNULL(POS.STOCK_ID,0)>0 AND
                                                POS.IS_SEVK <> 1 AND
                                                ISNULL(IS_FREE_AMOUNT,0) = 0
                                                AND PO.P_ORDER_ID <> @p_order_id
                                        UNION ALL
                                            SELECT
                                                POS.AMOUNT AS STOCK_ARTIR,
                                                0 AS STOCK_AZALT,
                                                POS.STOCK_ID,
                                                ISNULL(POS.SPECT_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM
                                                [@_dsn_company_@].PRODUCTION_ORDERS PO,
                                                [@_dsn_company_@].PRODUCTION_ORDERS_STOCKS POS
                                                JOIN [@_dsn_main_@].fnsplit(@stock_id_list,',') AS XXX on XXX.item = POS.STOCK_ID
                                            WHERE
                                                PO.IS_STOCK_RESERVED = 1 AND
                                                PO.P_ORDER_ID = POS.P_ORDER_ID AND
                                                PO.IS_DEMONTAJ=1 AND
                                                ISNULL(POS.STOCK_ID,0)>0 AND
                                                POS.IS_SEVK <> 1 AND
                                                ISNULL(IS_FREE_AMOUNT,0) = 0
                                                AND PO.P_ORDER_ID <> @p_order_id
                                        UNION ALL
                                            SELECT 
                                                (P_ORD_R_R.AMOUNT)*-1 AS  STOCK_ARTIR,
                                                0 AS STOCK_AZALT,
                                                P_ORD_R_R.STOCK_ID,
                                                ISNULL(P_ORD.SPEC_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM
                                                [@_dsn_company_@].PRODUCTION_ORDER_RESULTS P_ORD_R,
                                                [@_dsn_company_@].PRODUCTION_ORDER_RESULTS_ROW P_ORD_R_R
                                                JOIN [@_dsn_main_@].fnsplit(@stock_id_list,',') AS XXX on XXX.item = P_ORD_R_R.STOCK_ID,
                                                [@_dsn_company_@].PRODUCTION_ORDERS P_ORD
                                            WHERE
                                                P_ORD.IS_STOCK_RESERVED=1 AND
                                                P_ORD.SPEC_MAIN_ID IS NOT NULL AND
                                                P_ORD.P_ORDER_ID = P_ORD_R.P_ORDER_ID AND
                                                P_ORD_R_R.PR_ORDER_ID=P_ORD_R.PR_ORDER_ID AND
                                                P_ORD_R_R.TYPE=1 AND
                                                P_ORD_R.IS_STOCK_FIS=1 AND
                                                P_ORD_R_R.IS_SEVKIYAT IS NULL
                                        UNION ALL
                                            SELECT 
                                                0 AS STOCK_ARTIR,
                                                (P_ORD_R_R.AMOUNT)*-1 AS STOCK_AZALT,
                                                P_ORD_R_R.STOCK_ID,
                                                ISNULL(P_ORD.SPEC_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM 
                                                [@_dsn_company_@].PRODUCTION_ORDER_RESULTS P_ORD_R,
                                                [@_dsn_company_@].PRODUCTION_ORDER_RESULTS_ROW P_ORD_R_R
                                                JOIN [@_dsn_main_@].fnsplit(@stock_id_list,',') AS XXX on XXX.item = P_ORD_R_R.STOCK_ID,
                                                [@_dsn_company_@].PRODUCTION_ORDERS P_ORD
                                            WHERE
                                                P_ORD.IS_STOCK_RESERVED=1 AND
                                                P_ORD.SPEC_MAIN_ID IS NOT NULL AND
                                                P_ORD.P_ORDER_ID = P_ORD_R.P_ORDER_ID AND
                                                P_ORD_R_R.PR_ORDER_ID=P_ORD_R.PR_ORDER_ID AND
                                                P_ORD_R_R.TYPE=2 AND
                                                P_ORD_R.IS_STOCK_FIS=1 AND
                                                P_ORD_R_R.IS_SEVKIYAT <> 1
                                ) T1
                            GROUP BY 
                                STOCK_ID,
                                T1.SPEC_MAIN_ID
                            )A1
                        ) T1
                    GROUP BY
                            STOCK_ID,
                            SPEC_MAIN_ID
                        ) AS GET_STOCK_LAST
                END
                ELSE
                BEGIN
                    SELECT 
                        ISNULL(PRODUCT_STOCK,0) AS PRODUCT_STOCK,
                        ISNULL(SALEABLE_STOCK,0) AS SALEABLE_STOCK,
                        STOCK_ID,
                        SPEC_MAIN_ID
                    FROM 
                        (
                        SELECT 
                            ROUND(SUM(REAL_STOCK),4) REAL_STOCK,
                            ROUND(SUM(PRODUCT_STOCK),4) PRODUCT_STOCK,
                            ROUND(SUM(PRODUCT_STOCK+RESERVED_STOCK),4) SALEABLE_STOCK,
                            ROUND(SUM(PURCHASE_ORDER_STOCK),4) PURCHASE_ORDER_STOCK,
                            STOCK_ID,
                            T1.SPEC_MAIN_ID
                        FROM
                        (
                            SELECT
                                (SR.STOCK_IN - SR.STOCK_OUT) AS REAL_STOCK,
                                0 AS PRODUCT_STOCK,
                                0 AS RESERVED_STOCK,
                                0 AS PURCHASE_ORDER_STOCK,
                                SR.STOCK_ID,
                                ISNULL(SR.SPECT_VAR_ID,0) SPEC_MAIN_ID
                            FROM
                                STOCKS_ROW SR
                            JOIN [@_dsn_main_@].fnsplit(@stock_id_list,',') AS XXX on XXX.item = SR.STOCK_ID
                             JOIN
                            (
                                    SELECT
                                        CONVERT(NVARCHAR(10),SL.LOCATION_ID)+'_'+CONVERT(NVARCHAR(10),SL.DEPARTMENT_ID) AS ID 
                                    FROM 
                                        [@_dsn_main_@].STOCKS_LOCATION SL,
                                        [@_dsn_main_@].DEPARTMENT D
                                    WHERE
                                        SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND SL.IS_SCRAP = 1
                            ) as SCARP ON  SCARP.ID <> CONVERT(NVARCHAR(10),SR.STORE_LOCATION)+'_'+CONVERT(NVARCHAR(10),SR.STORE)
        
                                
                
                
                        UNION ALL			
                            SELECT
                                0 AS REAL_STOCK,
                                (SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK,
                                0 AS RESERVED_STOCK,
                                0 AS PURCHASE_ORDER_STOCK,
                                SR.STOCK_ID,
                                ISNULL(SR.SPECT_VAR_ID,0) SPEC_MAIN_ID
                            FROM
                                [@_dsn_main_@].STOCKS_LOCATION SL,
                                STOCKS_ROW SR
                                JOIN [@_dsn_main_@].fnsplit(@stock_id_list,',') AS XXX on XXX.item = SR.STOCK_ID
                             JOIN
                            (
                                    SELECT
                                        CONVERT(NVARCHAR(10),SL.LOCATION_ID)+'_'+CONVERT(NVARCHAR(10),SL.DEPARTMENT_ID) AS ID 
                                    FROM 
                                        [@_dsn_main_@].STOCKS_LOCATION SL,
                                        [@_dsn_main_@].DEPARTMENT D
                                    WHERE
                                        SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND SL.IS_SCRAP = 1
                            ) as SCARP ON  SCARP.ID <> CONVERT(NVARCHAR(10),SR.STORE_LOCATION)+'_'+CONVERT(NVARCHAR(10),SR.STORE)
                            
                                
                            WHERE
                                
                                SR.STORE =SL.DEPARTMENT_ID
                                AND SR.STORE_LOCATION=SL.LOCATION_ID
                                AND SL.NO_SALE = 0
                        UNION ALL
                            SELECT
                                0 AS REAL_STOCK,
                                0 AS PRODUCT_STOCK,
                                ((RESERVE_STOCK_OUT-STOCK_OUT)*-1) AS RESERVED_STOCK,
                                RESERVE_STOCK_IN AS PURCHASE_ORDER_STOCK,
                                ORR.STOCK_ID,
                                ISNULL(ORR.SPECT_VAR_ID,0) SPEC_MAIN_ID
                            FROM
                                [@_dsn_company_@].GET_ORDER_ROW_RESERVED ORR
                                JOIN [@_dsn_main_@].fnsplit(@stock_id_list,',') AS XXX on XXX.item = ORR.STOCK_ID, 
                                [@_dsn_company_@].ORDERS ORDS
                            WHERE
                                ORDS.RESERVED = 1 AND 
                                ORDS.ORDER_STATUS = 1 AND	
                                ORR.ORDER_ID=ORDS.ORDER_ID AND 
                                ((RESERVE_STOCK_IN-STOCK_IN)>0 OR (RESERVE_STOCK_OUT-STOCK_OUT)>0)
                        UNION ALL
                            SELECT
                                0 AS REAL_STOCK,
                                0 AS PRODUCT_STOCK,
                                (RESERVE_STOCK_IN-STOCK_IN) AS RESERVED_STOCK,
                                0 AS PURCHASE_ORDER_STOCK,
                                ORR.STOCK_ID,
                                ISNULL(ORR.SPECT_VAR_ID,0) SPEC_MAIN_ID
                            FROM
                                [@_dsn_company_@].GET_ORDER_ROW_RESERVED ORR
                                JOIN [@_dsn_main_@].fnsplit(@stock_id_list,',') AS XXX on XXX.item = ORR.STOCK_ID, 
                                [@_dsn_company_@].ORDERS ORDS,
                                [@_dsn_main_@].STOCKS_LOCATION SL
                            WHERE
                                ORDS.RESERVED = 1 AND 
                                ORDS.ORDER_STATUS = 1 AND	
                                ORDS.DELIVER_DEPT_ID =SL.DEPARTMENT_ID AND 
                                ORDS.LOCATION_ID=SL.LOCATION_ID AND 
                                SL.NO_SALE = 0	 AND 
                                ORR.ORDER_ID=ORDS.ORDER_ID AND 
                                (RESERVE_STOCK_IN-STOCK_IN)>0
                        UNION ALL			
                            SELECT
                                0 AS REAL_STOCK,
                                0 AS PRODUCT_STOCK,
                                ((RESERVE_STOCK_IN-STOCK_IN) + ((RESERVE_STOCK_OUT-STOCK_OUT)*-1)) AS RESERVED_STOCK,
                                0 AS PURCHASE_ORDER_STOCK,
                                ORR.STOCK_ID,
                                ISNULL(ORR.SPECT_VAR_ID,0) SPEC_MAIN_ID
                            FROM
                                [@_dsn_company_@].ORDER_ROW_RESERVED  ORR
                            	JOIN [@_dsn_main_@].fnsplit(@stock_id_list,',') AS XXX on XXX.item = ORR.STOCK_ID
                            WHERE
                                ORDER_ID IS NULL
                                AND SHIP_ID IS NULL
                                AND INVOICE_ID IS NULL
                        UNION ALL
                            SELECT
                                0 AS REAL_STOCK,
                                0 AS PRODUCT_STOCK,
                                (STOCK_ARTIR-STOCK_AZALT) AS RESERVED_STOCK,
                                0  AS PURCHASE_ORDER_STOCK,
                                STOCK_ID,
                                SPEC_MAIN_ID
                            FROM
                                (
                                    SELECT
                                        SUM(STOCK_ARTIR) STOCK_ARTIR,
                                        SUM(STOCK_AZALT) STOCK_AZALT,
                                        STOCK_ID,
                                        SPEC_MAIN_ID
                                    FROM
                                        (
                                            SELECT
                                                (QUANTITY) AS STOCK_ARTIR,
                                                0 AS STOCK_AZALT,
                                                STOCK_ID,
                                                ISNULL(SPEC_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM
                                                [@_dsn_company_@].PRODUCTION_ORDERS
                                                JOIN [@_dsn_main_@].fnsplit(@stock_id_list,',') AS XXX on XXX.item = PRODUCTION_ORDERS.STOCK_ID
                                            WHERE
                                                IS_STOCK_RESERVED = 1 AND
                                                IS_DEMONTAJ=0 AND
                                                SPEC_MAIN_ID IS NOT NULL
                                        UNION ALL
                                            SELECT
                                                0 AS STOCK_ARTIR,
                                                (QUANTITY) AS STOCK_AZALT,
                                                STOCK_ID,
                                                ISNULL(SPEC_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM
                                                [@_dsn_company_@].PRODUCTION_ORDERS
                                                JOIN [@_dsn_main_@].fnsplit(@stock_id_list,',') AS XXX on XXX.item = PRODUCTION_ORDERS.STOCK_ID
                                            WHERE
                                                IS_STOCK_RESERVED = 1 AND
                                                IS_DEMONTAJ=1 AND
                                                SPEC_MAIN_ID IS NOT NULL
                                        UNION ALL
                                            SELECT
                                                0 AS STOCK_ARTIR,
                                                POS.AMOUNT AS STOCK_AZALT,
                                                POS.STOCK_ID,
                                                ISNULL(POS.SPECT_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM
                                                [@_dsn_company_@].PRODUCTION_ORDERS PO,
                                                [@_dsn_company_@].PRODUCTION_ORDERS_STOCKS POS
                                                JOIN [@_dsn_main_@].fnsplit(@stock_id_list,',') AS XXX on XXX.item = POS.STOCK_ID
                                            WHERE
                                                PO.IS_STOCK_RESERVED = 1 AND
                                                PO.P_ORDER_ID = POS.P_ORDER_ID AND
                                                PO.IS_DEMONTAJ=0 AND
                                                ISNULL(POS.STOCK_ID,0)>0 AND
                                                POS.IS_SEVK <> 1 AND
                                                ISNULL(IS_FREE_AMOUNT,0) = 0
                                                AND PO.P_ORDER_ID <> @p_order_id
                                        UNION ALL
                                            SELECT
                                                POS.AMOUNT AS STOCK_ARTIR,
                                                0 AS STOCK_AZALT,
                                                POS.STOCK_ID,
                                                ISNULL(POS.SPECT_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM
                                                [@_dsn_company_@].PRODUCTION_ORDERS PO,
                                                [@_dsn_company_@].PRODUCTION_ORDERS_STOCKS POS
                                                JOIN [@_dsn_main_@].fnsplit(@stock_id_list,',') AS XXX on XXX.item = POS.STOCK_ID
                                            WHERE
                                                PO.IS_STOCK_RESERVED = 1 AND
                                                PO.P_ORDER_ID = POS.P_ORDER_ID AND
                                                PO.IS_DEMONTAJ=1 AND
                                                ISNULL(POS.STOCK_ID,0)>0 AND
                                                POS.IS_SEVK <> 1 AND
                                                ISNULL(IS_FREE_AMOUNT,0) = 0
                                                AND PO.P_ORDER_ID <> @p_order_id
                                        UNION ALL
                                            SELECT 
                                                (P_ORD_R_R.AMOUNT)*-1 AS  STOCK_ARTIR,
                                                0 AS STOCK_AZALT,
                                                P_ORD_R_R.STOCK_ID,
                                                ISNULL(P_ORD.SPEC_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM
                                                [@_dsn_company_@].PRODUCTION_ORDER_RESULTS P_ORD_R,
                                                [@_dsn_company_@].PRODUCTION_ORDER_RESULTS_ROW P_ORD_R_R
                                                JOIN [@_dsn_main_@].fnsplit(@stock_id_list,',') AS XXX on XXX.item = P_ORD_R_R.STOCK_ID,
                                                [@_dsn_company_@].PRODUCTION_ORDERS P_ORD
                                            WHERE
                                                P_ORD.IS_STOCK_RESERVED=1 AND
                                                P_ORD.SPEC_MAIN_ID IS NOT NULL AND
                                                P_ORD.P_ORDER_ID = P_ORD_R.P_ORDER_ID AND
                                                P_ORD_R_R.PR_ORDER_ID=P_ORD_R.PR_ORDER_ID AND
                                                P_ORD_R_R.TYPE=1 AND
                                                P_ORD_R.IS_STOCK_FIS=1 AND
                                                P_ORD_R_R.IS_SEVKIYAT IS NULL
                                        UNION ALL
                                            SELECT 
                                                0 AS STOCK_ARTIR,
                                                (P_ORD_R_R.AMOUNT)*-1 AS STOCK_AZALT,
                                                P_ORD_R_R.STOCK_ID,
                                                ISNULL(P_ORD.SPEC_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM 
                                                [@_dsn_company_@].PRODUCTION_ORDER_RESULTS P_ORD_R,
                                                [@_dsn_company_@].PRODUCTION_ORDER_RESULTS_ROW P_ORD_R_R
                                                JOIN [@_dsn_main_@].fnsplit(@stock_id_list,',') AS XXX on XXX.item = P_ORD_R_R.STOCK_ID,
                                                [@_dsn_company_@].PRODUCTION_ORDERS P_ORD
                                            WHERE
                                                P_ORD.IS_STOCK_RESERVED=1 AND
                                                P_ORD.SPEC_MAIN_ID IS NOT NULL AND
                                                P_ORD.P_ORDER_ID = P_ORD_R.P_ORDER_ID AND
                                                P_ORD_R_R.PR_ORDER_ID=P_ORD_R.PR_ORDER_ID AND
                                                P_ORD_R_R.TYPE=2 AND
                                                P_ORD_R.IS_STOCK_FIS=1 AND
                                                P_ORD_R_R.IS_SEVKIYAT <> 1
                                ) T1
                            GROUP BY 
                                STOCK_ID,
                                T1.SPEC_MAIN_ID
                            )A1
                        ) T1
                    GROUP BY
                            STOCK_ID,
                            SPEC_MAIN_ID
                        ) AS GET_STOCK_LAST
                END
            END
        
            else
                BEGIN
        
                    IF @type =1
                BEGIN
                
                    SELECT																																																																																																																																																																																																																																	 
                        ISNULL(PRODUCT_STOCK,0) AS PRODUCT_STOCK,
                        ISNULL(SALEABLE_STOCK,0) AS SALEABLE_STOCK,
                        STOCK_ID,
                        SPEC_MAIN_ID
                    FROM 
                        (
                        SELECT 
                            ROUND(SUM(REAL_STOCK),4) REAL_STOCK,
                            ROUND(SUM(PRODUCT_STOCK),4) PRODUCT_STOCK,
                            ROUND(SUM(PRODUCT_STOCK+RESERVED_STOCK),4) SALEABLE_STOCK,
                            ROUND(SUM(PURCHASE_ORDER_STOCK),4) PURCHASE_ORDER_STOCK,
                            STOCK_ID,
                            T1.SPEC_MAIN_ID
                        FROM
                        (
                            SELECT
                                (SR.STOCK_IN - SR.STOCK_OUT) AS REAL_STOCK,
                                0 AS PRODUCT_STOCK,
                                0 AS RESERVED_STOCK,
                                0 AS PURCHASE_ORDER_STOCK,
                                SR.STOCK_ID,
                                ISNULL(SR.SPECT_VAR_ID,0) SPEC_MAIN_ID
                            FROM
                                STOCKS_ROW SR
                            JOIN [@_dsn_main_@].fnsplit(@stock_id_list,',') AS XXX on XXX.item = SR.STOCK_ID
                            WHERE
                                1=1
                        UNION ALL			
                            SELECT
                                0 AS REAL_STOCK,
                                (SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK,
                                0 AS RESERVED_STOCK,
                                0 AS PURCHASE_ORDER_STOCK,
                                SR.STOCK_ID,
                                ISNULL(SR.SPECT_VAR_ID,0) SPEC_MAIN_ID
                            FROM
                                [@_dsn_main_@].STOCKS_LOCATION SL,
                                STOCKS_ROW SR
                                JOIN [@_dsn_main_@].fnsplit(@stock_id_list,',') AS XXX on XXX.item = SR.STOCK_ID
                            WHERE
                                SR.STORE =SL.DEPARTMENT_ID
                                AND SR.STORE_LOCATION=SL.LOCATION_ID
                                AND SL.NO_SALE = 0
                        UNION ALL
                            SELECT
                                0 AS REAL_STOCK,
                                0 AS PRODUCT_STOCK,
                                ((RESERVE_STOCK_OUT-STOCK_OUT)*-1) AS RESERVED_STOCK,
                                RESERVE_STOCK_IN AS PURCHASE_ORDER_STOCK,
                                ORR.STOCK_ID,
                                ISNULL(ORR.SPECT_VAR_ID,0) SPEC_MAIN_ID
                            FROM
                                [@_dsn_company_@].GET_ORDER_ROW_RESERVED ORR
                                JOIN [@_dsn_main_@].fnsplit(@stock_id_list,',') AS XXX on XXX.item = ORR.STOCK_ID, 
                                [@_dsn_company_@].ORDERS ORDS
                            WHERE
                                ORDS.RESERVED = 1 AND 
                                ORDS.ORDER_STATUS = 1 AND	
                                ORR.ORDER_ID=ORDS.ORDER_ID AND 
                                ((RESERVE_STOCK_IN-STOCK_IN)>0 OR (RESERVE_STOCK_OUT-STOCK_OUT)>0)
                        UNION ALL
                            SELECT
                                0 AS REAL_STOCK,
                                0 AS PRODUCT_STOCK,
                                (RESERVE_STOCK_IN-STOCK_IN) AS RESERVED_STOCK,
                                0 AS PURCHASE_ORDER_STOCK,
                                ORR.STOCK_ID,
                                ISNULL(ORR.SPECT_VAR_ID,0) SPEC_MAIN_ID
                            FROM
                                [@_dsn_company_@].GET_ORDER_ROW_RESERVED ORR
                                JOIN [@_dsn_main_@].fnsplit(@stock_id_list,',') AS XXX on XXX.item = ORR.STOCK_ID, 
                                [@_dsn_company_@].ORDERS ORDS,
                                [@_dsn_main_@].STOCKS_LOCATION SL
                            WHERE
                                ORDS.RESERVED = 1 AND 
                                ORDS.ORDER_STATUS = 1 AND	
                                ORDS.DELIVER_DEPT_ID =SL.DEPARTMENT_ID AND 
                                ORDS.LOCATION_ID=SL.LOCATION_ID AND 
                                SL.NO_SALE = 0	 AND 
                                ORR.ORDER_ID=ORDS.ORDER_ID AND 
                                (RESERVE_STOCK_IN-STOCK_IN)>0
                        UNION ALL			
                            SELECT
                                0 AS REAL_STOCK,
                                0 AS PRODUCT_STOCK,
                                ((RESERVE_STOCK_IN-STOCK_IN) + ((RESERVE_STOCK_OUT-STOCK_OUT)*-1)) AS RESERVED_STOCK,
                                0 AS PURCHASE_ORDER_STOCK,
                                ORR.STOCK_ID,
                                ISNULL(ORR.SPECT_VAR_ID,0) SPEC_MAIN_ID
                            FROM
                                [@_dsn_company_@].ORDER_ROW_RESERVED  ORR
                            	JOIN [@_dsn_main_@].fnsplit(@stock_id_list,',') AS XXX on XXX.item = ORR.STOCK_ID
                            WHERE
                                ORDER_ID IS NULL
                                AND SHIP_ID IS NULL
                                AND INVOICE_ID IS NULL
                        UNION ALL
                            SELECT
                                0 AS REAL_STOCK,
                                0 AS PRODUCT_STOCK,
                                (STOCK_ARTIR-STOCK_AZALT) AS RESERVED_STOCK,
                                0  AS PURCHASE_ORDER_STOCK,
                                STOCK_ID,
                                SPEC_MAIN_ID
                            FROM
                                (
                                    SELECT
                                        SUM(STOCK_ARTIR) STOCK_ARTIR,
                                        SUM(STOCK_AZALT) STOCK_AZALT,
                                        STOCK_ID,
                                        SPEC_MAIN_ID
                                    FROM
                                        (
                                            SELECT
                                                (QUANTITY) AS STOCK_ARTIR,
                                                0 AS STOCK_AZALT,
                                                STOCK_ID,
                                                ISNULL(SPEC_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM
                                                [@_dsn_company_@].PRODUCTION_ORDERS
                                                JOIN [@_dsn_main_@].fnsplit(@stock_id_list,',') AS XXX on XXX.item = PRODUCTION_ORDERS.STOCK_ID
                                            WHERE
                                                IS_STOCK_RESERVED = 1 AND
                                                IS_DEMONTAJ=0 AND
                                                SPEC_MAIN_ID IS NOT NULL
                                        UNION ALL
                                            SELECT
                                                0 AS STOCK_ARTIR,
                                                (QUANTITY) AS STOCK_AZALT,
                                                STOCK_ID,
                                                ISNULL(SPEC_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM
                                                [@_dsn_company_@].PRODUCTION_ORDERS
                                                JOIN [@_dsn_main_@].fnsplit(@stock_id_list,',') AS XXX on XXX.item = PRODUCTION_ORDERS.STOCK_ID
                                            WHERE
                                                IS_STOCK_RESERVED = 1 AND
                                                IS_DEMONTAJ=1 AND
                                                SPEC_MAIN_ID IS NOT NULL
                                        UNION ALL
                                            SELECT
                                                0 AS STOCK_ARTIR,
                                                POS.AMOUNT AS STOCK_AZALT,
                                                POS.STOCK_ID,
                                                ISNULL(POS.SPECT_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM
                                                [@_dsn_company_@].PRODUCTION_ORDERS PO,
                                                [@_dsn_company_@].PRODUCTION_ORDERS_STOCKS POS
                                                JOIN [@_dsn_main_@].fnsplit(@stock_id_list,',') AS XXX on XXX.item = POS.STOCK_ID
                                            WHERE
                                                PO.IS_STOCK_RESERVED = 1 AND
                                                PO.P_ORDER_ID = POS.P_ORDER_ID AND
                                                PO.IS_DEMONTAJ=0 AND
                                                ISNULL(POS.STOCK_ID,0)>0 AND
                                                POS.IS_SEVK <> 1 AND
                                                ISNULL(IS_FREE_AMOUNT,0) = 0
                                        UNION ALL
                                            SELECT
                                                POS.AMOUNT AS STOCK_ARTIR,
                                                0 AS STOCK_AZALT,
                                                POS.STOCK_ID,
                                                ISNULL(POS.SPECT_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM
                                                [@_dsn_company_@].PRODUCTION_ORDERS PO,
                                                [@_dsn_company_@].PRODUCTION_ORDERS_STOCKS POS
                                                JOIN [@_dsn_main_@].fnsplit(@stock_id_list,',') AS XXX on XXX.item = POS.STOCK_ID
                                            WHERE
                                                PO.IS_STOCK_RESERVED = 1 AND
                                                PO.P_ORDER_ID = POS.P_ORDER_ID AND
                                                PO.IS_DEMONTAJ=1 AND
                                                ISNULL(POS.STOCK_ID,0)>0 AND
                                                POS.IS_SEVK <> 1 AND
                                                ISNULL(IS_FREE_AMOUNT,0) = 0
                                        UNION ALL
                                            SELECT 
                                                (P_ORD_R_R.AMOUNT)*-1 AS  STOCK_ARTIR,
                                                0 AS STOCK_AZALT,
                                                P_ORD_R_R.STOCK_ID,
                                                ISNULL(P_ORD.SPEC_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM
                                                [@_dsn_company_@].PRODUCTION_ORDER_RESULTS P_ORD_R,
                                                [@_dsn_company_@].PRODUCTION_ORDER_RESULTS_ROW P_ORD_R_R
                                                JOIN [@_dsn_main_@].fnsplit(@stock_id_list,',') AS XXX on XXX.item = P_ORD_R_R.STOCK_ID,
                                                [@_dsn_company_@].PRODUCTION_ORDERS P_ORD
                                            WHERE
                                                P_ORD.IS_STOCK_RESERVED=1 AND
                                                P_ORD.SPEC_MAIN_ID IS NOT NULL AND
                                                P_ORD.P_ORDER_ID = P_ORD_R.P_ORDER_ID AND
                                                P_ORD_R_R.PR_ORDER_ID=P_ORD_R.PR_ORDER_ID AND
                                                P_ORD_R_R.TYPE=1 AND
                                                P_ORD_R.IS_STOCK_FIS=1 AND
                                                P_ORD_R_R.IS_SEVKIYAT IS NULL
                                        UNION ALL
                                            SELECT 
                                                0 AS STOCK_ARTIR,
                                                (P_ORD_R_R.AMOUNT)*-1 AS STOCK_AZALT,
                                                P_ORD_R_R.STOCK_ID,
                                                ISNULL(P_ORD.SPEC_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM 
                                                [@_dsn_company_@].PRODUCTION_ORDER_RESULTS P_ORD_R,
                                                [@_dsn_company_@].PRODUCTION_ORDER_RESULTS_ROW P_ORD_R_R
                                                JOIN [@_dsn_main_@].fnsplit(@stock_id_list,',') AS XXX on XXX.item = P_ORD_R_R.STOCK_ID,
                                                [@_dsn_company_@].PRODUCTION_ORDERS P_ORD
                                            WHERE
                                                P_ORD.IS_STOCK_RESERVED=1 AND
                                                P_ORD.SPEC_MAIN_ID IS NOT NULL AND
                                                P_ORD.P_ORDER_ID = P_ORD_R.P_ORDER_ID AND
                                                P_ORD_R_R.PR_ORDER_ID=P_ORD_R.PR_ORDER_ID AND
                                                P_ORD_R_R.TYPE=2 AND
                                                P_ORD_R.IS_STOCK_FIS=1 AND
                                                P_ORD_R_R.IS_SEVKIYAT <> 1
                                ) T1
                            GROUP BY 
                                STOCK_ID,
                                T1.SPEC_MAIN_ID
                            )A1
                        ) T1
                    GROUP BY
                            STOCK_ID,
                            SPEC_MAIN_ID
                        ) AS GET_STOCK_LAST
                END
                ELSE
                BEGIN
                    SELECT 
                        ISNULL(PRODUCT_STOCK,0) AS PRODUCT_STOCK,
                        ISNULL(SALEABLE_STOCK,0) AS SALEABLE_STOCK,
                        STOCK_ID,
                        SPEC_MAIN_ID
                    FROM 
                        (
                        SELECT 
                            ROUND(SUM(REAL_STOCK),4) REAL_STOCK,
                            ROUND(SUM(PRODUCT_STOCK),4) PRODUCT_STOCK,
                            ROUND(SUM(PRODUCT_STOCK+RESERVED_STOCK),4) SALEABLE_STOCK,
                            ROUND(SUM(PURCHASE_ORDER_STOCK),4) PURCHASE_ORDER_STOCK,
                            STOCK_ID,
                            T1.SPEC_MAIN_ID
                        FROM
                        (
                            SELECT
                                (SR.STOCK_IN - SR.STOCK_OUT) AS REAL_STOCK,
                                0 AS PRODUCT_STOCK,
                                0 AS RESERVED_STOCK,
                                0 AS PURCHASE_ORDER_STOCK,
                                SR.STOCK_ID,
                                ISNULL(SR.SPECT_VAR_ID,0) SPEC_MAIN_ID
                            FROM
                                STOCKS_ROW SR
                            JOIN [@_dsn_main_@].fnsplit(@stock_id_list,',') AS XXX on XXX.item = SR.STOCK_ID
                             JOIN
                            (
                                    SELECT
                                        CONVERT(NVARCHAR(10),SL.LOCATION_ID)+'_'+CONVERT(NVARCHAR(10),SL.DEPARTMENT_ID) AS ID 
                                    FROM 
                                        [@_dsn_main_@].STOCKS_LOCATION SL,
                                        [@_dsn_main_@].DEPARTMENT D
                                    WHERE
                                        SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND SL.IS_SCRAP = 1
                            ) as SCARP ON  SCARP.ID <> CONVERT(NVARCHAR(10),SR.STORE_LOCATION)+'_'+CONVERT(NVARCHAR(10),SR.STORE)
                        UNION ALL			
                            SELECT
                                0 AS REAL_STOCK,
                                (SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK,
                                0 AS RESERVED_STOCK,
                                0 AS PURCHASE_ORDER_STOCK,
                                SR.STOCK_ID,
                                ISNULL(SR.SPECT_VAR_ID,0) SPEC_MAIN_ID
                            FROM
                                [@_dsn_main_@].STOCKS_LOCATION SL,
                                STOCKS_ROW SR
                                JOIN [@_dsn_main_@].fnsplit(@stock_id_list,',') AS XXX on XXX.item = SR.STOCK_ID
                             JOIN
                            (
                                    SELECT
                                        CONVERT(NVARCHAR(10),SL.LOCATION_ID)+'_'+CONVERT(NVARCHAR(10),SL.DEPARTMENT_ID) AS ID 
                                    FROM 
                                        [@_dsn_main_@].STOCKS_LOCATION SL,
                                        [@_dsn_main_@].DEPARTMENT D
                                    WHERE
                                        SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND SL.IS_SCRAP = 1
                            ) as SCARP ON  SCARP.ID <> CONVERT(NVARCHAR(10),SR.STORE_LOCATION)+'_'+CONVERT(NVARCHAR(10),SR.STORE)
                            
                                
                            WHERE
                                
                                SR.STORE =SL.DEPARTMENT_ID
                                AND SR.STORE_LOCATION=SL.LOCATION_ID
                                AND SL.NO_SALE = 0
                        UNION ALL
                            SELECT
                                0 AS REAL_STOCK,
                                0 AS PRODUCT_STOCK,
                                ((RESERVE_STOCK_OUT-STOCK_OUT)*-1) AS RESERVED_STOCK,
                                RESERVE_STOCK_IN AS PURCHASE_ORDER_STOCK,
                                ORR.STOCK_ID,
                                ISNULL(ORR.SPECT_VAR_ID,0) SPEC_MAIN_ID
                            FROM
                                [@_dsn_company_@].GET_ORDER_ROW_RESERVED ORR
                                JOIN [@_dsn_main_@].fnsplit(@stock_id_list,',') AS XXX on XXX.item = ORR.STOCK_ID, 
                                [@_dsn_company_@].ORDERS ORDS
                            WHERE
                                ORDS.RESERVED = 1 AND 
                                ORDS.ORDER_STATUS = 1 AND	
                                ORR.ORDER_ID=ORDS.ORDER_ID AND 
                                ((RESERVE_STOCK_IN-STOCK_IN)>0 OR (RESERVE_STOCK_OUT-STOCK_OUT)>0)
                        UNION ALL
                            SELECT
                                0 AS REAL_STOCK,
                                0 AS PRODUCT_STOCK,
                                (RESERVE_STOCK_IN-STOCK_IN) AS RESERVED_STOCK,
                                0 AS PURCHASE_ORDER_STOCK,
                                ORR.STOCK_ID,
                                ISNULL(ORR.SPECT_VAR_ID,0) SPEC_MAIN_ID
                            FROM
                                [@_dsn_company_@].GET_ORDER_ROW_RESERVED ORR
                                JOIN [@_dsn_main_@].fnsplit(@stock_id_list,',') AS XXX on XXX.item = ORR.STOCK_ID, 
                                [@_dsn_company_@].ORDERS ORDS,
                                [@_dsn_main_@].STOCKS_LOCATION SL
                            WHERE
                                ORDS.RESERVED = 1 AND 
                                ORDS.ORDER_STATUS = 1 AND	
                                ORDS.DELIVER_DEPT_ID =SL.DEPARTMENT_ID AND 
                                ORDS.LOCATION_ID=SL.LOCATION_ID AND 
                                SL.NO_SALE = 0	 AND 
                                ORR.ORDER_ID=ORDS.ORDER_ID AND 
                                (RESERVE_STOCK_IN-STOCK_IN)>0
                        UNION ALL			
                            SELECT
                                0 AS REAL_STOCK,
                                0 AS PRODUCT_STOCK,
                                ((RESERVE_STOCK_IN-STOCK_IN) + ((RESERVE_STOCK_OUT-STOCK_OUT)*-1)) AS RESERVED_STOCK,

                                0 AS PURCHASE_ORDER_STOCK,
                                ORR.STOCK_ID,
                                ISNULL(ORR.SPECT_VAR_ID,0) SPEC_MAIN_ID
                            FROM
                                [@_dsn_company_@].ORDER_ROW_RESERVED  ORR
                            	JOIN [@_dsn_main_@].fnsplit(@stock_id_list,',') AS XXX on XXX.item = ORR.STOCK_ID
                            WHERE
                                ORDER_ID IS NULL
                                AND SHIP_ID IS NULL
                                AND INVOICE_ID IS NULL
                        UNION ALL
                            SELECT
                                0 AS REAL_STOCK,
                                0 AS PRODUCT_STOCK,
                                (STOCK_ARTIR-STOCK_AZALT) AS RESERVED_STOCK,
                                0  AS PURCHASE_ORDER_STOCK,
                                STOCK_ID,
                                SPEC_MAIN_ID
                            FROM
                                (
                                    SELECT
                                        SUM(STOCK_ARTIR) STOCK_ARTIR,
                                        SUM(STOCK_AZALT) STOCK_AZALT,
                                        STOCK_ID,
                                        SPEC_MAIN_ID
                                    FROM
                                        (
                                            SELECT
                                                (QUANTITY) AS STOCK_ARTIR,
                                                0 AS STOCK_AZALT,
                                                STOCK_ID,
                                                ISNULL(SPEC_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM
                                                [@_dsn_company_@].PRODUCTION_ORDERS
                                                JOIN [@_dsn_main_@].fnsplit(@stock_id_list,',') AS XXX on XXX.item = PRODUCTION_ORDERS.STOCK_ID
                                            WHERE
                                                IS_STOCK_RESERVED = 1 AND
                                                IS_DEMONTAJ=0 AND
                                                SPEC_MAIN_ID IS NOT NULL
                                        UNION ALL
                                            SELECT
                                                0 AS STOCK_ARTIR,
                                                (QUANTITY) AS STOCK_AZALT,
                                                STOCK_ID,
                                                ISNULL(SPEC_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM
                                                [@_dsn_company_@].PRODUCTION_ORDERS
                                                JOIN [@_dsn_main_@].fnsplit(@stock_id_list,',') AS XXX on XXX.item = PRODUCTION_ORDERS.STOCK_ID
                                            WHERE
                                                IS_STOCK_RESERVED = 1 AND
                                                IS_DEMONTAJ=1 AND
                                                SPEC_MAIN_ID IS NOT NULL
                                        UNION ALL
                                            SELECT
                                                0 AS STOCK_ARTIR,
                                                POS.AMOUNT AS STOCK_AZALT,
                                                POS.STOCK_ID,
                                                ISNULL(POS.SPECT_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM
                                                [@_dsn_company_@].PRODUCTION_ORDERS PO,
                                                [@_dsn_company_@].PRODUCTION_ORDERS_STOCKS POS
                                                JOIN [@_dsn_main_@].fnsplit(@stock_id_list,',') AS XXX on XXX.item = POS.STOCK_ID
                                            WHERE
                                                PO.IS_STOCK_RESERVED = 1 AND
                                                PO.P_ORDER_ID = POS.P_ORDER_ID AND
                                                PO.IS_DEMONTAJ=0 AND
                                                ISNULL(POS.STOCK_ID,0)>0 AND
                                                POS.IS_SEVK <> 1 AND
                                                ISNULL(IS_FREE_AMOUNT,0) = 0
                                        UNION ALL
                                            SELECT
                                                POS.AMOUNT AS STOCK_ARTIR,
                                                0 AS STOCK_AZALT,
                                                POS.STOCK_ID,
                                                ISNULL(POS.SPECT_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM
                                                [@_dsn_company_@].PRODUCTION_ORDERS PO,
                                                [@_dsn_company_@].PRODUCTION_ORDERS_STOCKS POS
                                                JOIN [@_dsn_main_@].fnsplit(@stock_id_list,',') AS XXX on XXX.item = POS.STOCK_ID
                                            WHERE
                                                PO.IS_STOCK_RESERVED = 1 AND
                                                PO.P_ORDER_ID = POS.P_ORDER_ID AND
                                                PO.IS_DEMONTAJ=1 AND
                                                ISNULL(POS.STOCK_ID,0)>0 AND
                                                POS.IS_SEVK <> 1 AND
                                                ISNULL(IS_FREE_AMOUNT,0) = 0
                                        UNION ALL
                                            SELECT 
                                                (P_ORD_R_R.AMOUNT)*-1 AS  STOCK_ARTIR,
                                                0 AS STOCK_AZALT,
                                                P_ORD_R_R.STOCK_ID,
                                                ISNULL(P_ORD.SPEC_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM
                                                [@_dsn_company_@].PRODUCTION_ORDER_RESULTS P_ORD_R,
                                                [@_dsn_company_@].PRODUCTION_ORDER_RESULTS_ROW P_ORD_R_R
                                                JOIN [@_dsn_main_@].fnsplit(@stock_id_list,',') AS XXX on XXX.item = P_ORD_R_R.STOCK_ID,
                                                [@_dsn_company_@].PRODUCTION_ORDERS P_ORD
                                            WHERE
                                                P_ORD.IS_STOCK_RESERVED=1 AND
                                                P_ORD.SPEC_MAIN_ID IS NOT NULL AND
                                                P_ORD.P_ORDER_ID = P_ORD_R.P_ORDER_ID AND
                                                P_ORD_R_R.PR_ORDER_ID=P_ORD_R.PR_ORDER_ID AND
                                                P_ORD_R_R.TYPE=1 AND
                                                P_ORD_R.IS_STOCK_FIS=1 AND
                                                P_ORD_R_R.IS_SEVKIYAT IS NULL
                                        UNION ALL
                                            SELECT 
                                                0 AS STOCK_ARTIR,
                                                (P_ORD_R_R.AMOUNT)*-1 AS STOCK_AZALT,
                                                P_ORD_R_R.STOCK_ID,
                                                ISNULL(P_ORD.SPEC_MAIN_ID,0) SPEC_MAIN_ID
                                            FROM 
                                                [@_dsn_company_@].PRODUCTION_ORDER_RESULTS P_ORD_R,
                                                [@_dsn_company_@].PRODUCTION_ORDER_RESULTS_ROW P_ORD_R_R
                                                JOIN [@_dsn_main_@].fnsplit(@stock_id_list,',') AS XXX on XXX.item = P_ORD_R_R.STOCK_ID,
                                                [@_dsn_company_@].PRODUCTION_ORDERS P_ORD
                                            WHERE
                                                P_ORD.IS_STOCK_RESERVED=1 AND
                                                P_ORD.SPEC_MAIN_ID IS NOT NULL AND
                                                P_ORD.P_ORDER_ID = P_ORD_R.P_ORDER_ID AND
                                                P_ORD_R_R.PR_ORDER_ID=P_ORD_R.PR_ORDER_ID AND
                                                P_ORD_R_R.TYPE=2 AND
                                                P_ORD_R.IS_STOCK_FIS=1 AND
                                                P_ORD_R_R.IS_SEVKIYAT <> 1
                                ) T1
                            GROUP BY 
                                STOCK_ID,
                                T1.SPEC_MAIN_ID
                            )A1
                        ) T1
                    GROUP BY
                            STOCK_ID,
                            SPEC_MAIN_ID
                        ) AS GET_STOCK_LAST
                END
        
                END           
        END

CREATE PROCEDURE [@_dsn_period_@].[SpGetStockLastStrategy] AS
	BEGIN
		SELECT 
			SUM(REAL_STOCK) REAL_STOCK,
			SUM(PRODUCT_STOCK) PRODUCT_STOCK,
			SUM(RESERVED_STOCK) RESERVED_STOCK,
			SUM(PURCHASE_PROD_STOCK) PURCHASE_PROD_STOCK,
			SUM(RESERVED_PROD_STOCK) RESERVED_PROD_STOCK,
			SUM(PRODUCT_STOCK+RESERVED_STOCK) SALEABLE_STOCK,
			SUM(RESERVE_SALE_ORDER_STOCK) RESERVE_SALE_ORDER_STOCK,
			SUM(NOSALE_STOCK) NOSALE_STOCK,
			SUM(BELONGTO_INSTITUTION_STOCK) BELONGTO_INSTITUTION_STOCK,
			SUM(RESERVE_PURCHASE_ORDER_STOCK) RESERVE_PURCHASE_ORDER_STOCK,
			SUM(PRODUCTION_ORDER_STOCK) PRODUCTION_ORDER_STOCK,
			SUM(NOSALE_RESERVED_STOCK) AS NOSALE_RESERVED_STOCK,
			PRODUCT_ID, 
			STOCK_ID,
			DEPARTMENT_ID,
			LOCATION_ID
	INTO  ####TStockLastProfile	
	FROM
		(
			SELECT
				(SR.STOCK_IN - SR.STOCK_OUT) AS REAL_STOCK,
				0 AS PRODUCT_STOCK,
				0 AS RESERVED_STOCK,
				0 AS PURCHASE_PROD_STOCK,
				0 AS RESERVED_PROD_STOCK,
				0 AS RESERVE_SALE_ORDER_STOCK,
				0 AS NOSALE_STOCK, 
				0 AS BELONGTO_INSTITUTION_STOCK,
				0 AS RESERVE_PURCHASE_ORDER_STOCK,
				0 AS PRODUCTION_ORDER_STOCK,
				0 AS NOSALE_RESERVED_STOCK,
				SR.STOCK_ID,
				SR.PRODUCT_ID,
				SR.STORE AS DEPARTMENT_ID,
				SR.STORE_LOCATION AS LOCATION_ID
			FROM
				STOCKS_ROW SR 
			WHERE
				SR.STORE IS NOT NULL AND
				SR.STORE_LOCATION IS NOT NULL 
		UNION ALL
			SELECT
				(SR.STOCK_IN - SR.STOCK_OUT) AS REAL_STOCK,
				0 AS PRODUCT_STOCK,
				0 AS RESERVED_STOCK,
				0 AS PURCHASE_PROD_STOCK,
				0 AS RESERVED_PROD_STOCK,
				0 AS RESERVE_SALE_ORDER_STOCK,
				0 AS NOSALE_STOCK, 
				0 AS BELONGTO_INSTITUTION_STOCK,
				0 AS RESERVE_PURCHASE_ORDER_STOCK,
				0 AS PRODUCTION_ORDER_STOCK,
				0 AS NOSALE_RESERVED_STOCK,
				SR.STOCK_ID,
				SR.PRODUCT_ID,
				'-1'  AS DEPARTMENT_ID,
				'-1'  AS LOCATION_ID
			FROM
				STOCKS_ROW SR 
			WHERE
				UPD_ID IS NULL
		UNION ALL
			SELECT
				0 AS REAL_STOCK,
				(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK,
				0 AS RESERVED_STOCK,
				0 AS PURCHASE_PROD_STOCK,
				0 AS RESERVED_PROD_STOCK,
				0 AS RESERVE_SALE_ORDER_STOCK,
				0 AS NOSALE_STOCK, 
				0 AS BELONGTO_INSTITUTION_STOCK,
				0 AS RESERVE_PURCHASE_ORDER_STOCK,
				0 AS PRODUCTION_ORDER_STOCK,
				0 AS NOSALE_RESERVED_STOCK,
				SR.STOCK_ID,
				SR.PRODUCT_ID,
				SR.STORE AS DEPARTMENT_ID,
				SR.STORE_LOCATION AS LOCATION_ID
			FROM
				[@_dsn_main_@].STOCKS_LOCATION SL,
				STOCKS_ROW SR  
			WHERE
				SR.STORE =SL.DEPARTMENT_ID
				AND SR.STORE_LOCATION=SL.LOCATION_ID
				AND SL.NO_SALE = 0
		UNION ALL
			SELECT
				0 AS REAL_STOCK,
				-1*(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK,
				0 AS RESERVED_STOCK,
				0 AS PURCHASE_PROD_STOCK,
				0 AS RESERVED_PROD_STOCK,
				0 AS RESERVE_SALE_ORDER_STOCK,
				0 AS NOSALE_STOCK, 
				0 AS BELONGTO_INSTITUTION_STOCK,
				0 AS RESERVE_PURCHASE_ORDER_STOCK,
				0 AS PRODUCTION_ORDER_STOCK,
				0 AS NOSALE_RESERVED_STOCK,
				SR.STOCK_ID,
				SR.PRODUCT_ID,
				SR.STORE AS DEPARTMENT_ID,
				SR.STORE_LOCATION AS LOCATION_ID
			FROM
				STOCKS_ROW SR  ,
				[@_dsn_main_@].STOCKS_LOCATION SL 
			WHERE	
				SR.STORE = SL.DEPARTMENT_ID AND
				SR.STORE_LOCATION = SL.LOCATION_ID AND
				ISNULL(SL.IS_SCRAP,0)=1
		UNION ALL
			SELECT
				0 AS REAL_STOCK,
				0 AS PRODUCT_STOCK,
				0 AS RESERVED_STOCK,
				0 AS PURCHASE_PROD_STOCK,
				0 AS RESERVED_PROD_STOCK,
				0 AS RESERVE_SALE_ORDER_STOCK,
				(SR.STOCK_IN - SR.STOCK_OUT) AS NOSALE_STOCK,
				0 AS BELONGTO_INSTITUTION_STOCK,
				0 AS RESERVE_PURCHASE_ORDER_STOCK,
				0 AS PRODUCTION_ORDER_STOCK,
				0 AS NOSALE_RESERVED_STOCK,
				SR.STOCK_ID,
				SR.PRODUCT_ID,
				SR.STORE AS DEPARTMENT_ID,
				SR.STORE_LOCATION AS LOCATION_ID
			FROM
				[@_dsn_main_@].STOCKS_LOCATION SL,
				STOCKS_ROW SR  
			WHERE
				SR.STORE =SL.DEPARTMENT_ID
				AND SR.STORE_LOCATION=SL.LOCATION_ID
				AND SL.NO_SALE =1
		UNION ALL
			SELECT
				0 AS REAL_STOCK,
				0 AS PRODUCT_STOCK,
				0 AS RESERVED_STOCK,
				0 AS PURCHASE_PROD_STOCK,
				0 AS RESERVED_PROD_STOCK,
				0 AS RESERVE_SALE_ORDER_STOCK,
				0 AS NOSALE_STOCK, 
				(SR.STOCK_IN - SR.STOCK_OUT) AS BELONGTO_INSTITUTION_STOCK,
				0 AS RESERVE_PURCHASE_ORDER_STOCK,
				0 AS PRODUCTION_ORDER_STOCK,
				0 AS NOSALE_RESERVED_STOCK,
				SR.STOCK_ID,
				SR.PRODUCT_ID,
				SR.STORE AS DEPARTMENT_ID,
				SR.STORE_LOCATION AS LOCATION_ID
			FROM
				[@_dsn_main_@].STOCKS_LOCATION SL,
				STOCKS_ROW SR  
			WHERE
				SR.STORE =SL.DEPARTMENT_ID
				AND SR.STORE_LOCATION=SL.LOCATION_ID
				AND SL.BELONGTO_INSTITUTION =1
		UNION ALL
			SELECT
				0 AS REAL_STOCK,
				0 AS PRODUCT_STOCK,
				((RESERVE_STOCK_OUT-STOCK_OUT)*-1) AS RESERVED_STOCK,
				0 AS PURCHASE_PROD_STOCK,
				0 AS RESERVED_PROD_STOCK,
				(RESERVE_STOCK_OUT-STOCK_OUT) AS RESERVE_SALE_ORDER_STOCK,
				0 AS NOSALE_STOCK,
				0 AS BELONGTO_INSTITUTION_STOCK,
				(RESERVE_STOCK_IN-STOCK_IN) AS RESERVE_PURCHASE_ORDER_STOCK,
				0 AS PRODUCTION_ORDER_STOCK,
				0 AS NOSALE_RESERVED_STOCK,
				ORR.STOCK_ID,
				ORR.PRODUCT_ID,
				ORDS.DELIVER_DEPT_ID AS DEPARTMENT_ID,
				ORDS.LOCATION_ID AS LOCATION_ID
			FROM
				[@_dsn_company_@].GET_ORDER_ROW_RESERVED ORR  , 
				[@_dsn_company_@].ORDERS ORDS
			WHERE
				ORDS.RESERVED = 1 AND 
				ORDS.ORDER_STATUS = 1 AND	
				ORDS.DELIVER_DEPT_ID IS NOT NULL AND
				ORDS.LOCATION_ID IS NOT NULL AND
				ORR.ORDER_ID = ORDS.ORDER_ID AND 
				((RESERVE_STOCK_IN-STOCK_IN)>0 OR (RESERVE_STOCK_OUT-STOCK_OUT)>0)
		UNION ALL
			SELECT
				0 AS REAL_STOCK,
				0 AS PRODUCT_STOCK,
				(RESERVE_STOCK_IN-STOCK_IN) AS RESERVED_STOCK,
				0 AS PURCHASE_PROD_STOCK,
				0 AS RESERVED_PROD_STOCK,
				0 AS RESERVE_SALE_ORDER_STOCK,
				0 AS NOSALE_STOCK,
				0 AS BELONGTO_INSTITUTION_STOCK,
				0 AS RESERVE_PURCHASE_ORDER_STOCK,
				0 AS PRODUCTION_ORDER_STOCK,
				0 AS NOSALE_RESERVED_STOCK,
				ORR.STOCK_ID,
				ORR.PRODUCT_ID,
				ORDS.DELIVER_DEPT_ID AS DEPARTMENT_ID,
				ORDS.LOCATION_ID AS LOCATION_ID
			FROM
				[@_dsn_company_@].GET_ORDER_ROW_RESERVED ORR , 
				[@_dsn_company_@].ORDERS ORDS,
				[@_dsn_main_@].STOCKS_LOCATION SL
			WHERE
				ORDS.RESERVED = 1 AND 
				ORDS.ORDER_STATUS = 1 AND
				ORDS.DELIVER_DEPT_ID=SL.DEPARTMENT_ID AND
				ORDS.LOCATION_ID=SL.LOCATION_ID AND
				SL.NO_SALE=0 AND
				ORDS.PURCHASE_SALES=0 AND
				ORDS.ORDER_ZONE=0 AND
				ORR.ORDER_ID = ORDS.ORDER_ID AND 
				(RESERVE_STOCK_IN-STOCK_IN)>0	
		UNION ALL
			SELECT
				0 AS REAL_STOCK,
				0 AS PRODUCT_STOCK,
				0 AS RESERVED_STOCK,
				0 AS PURCHASE_PROD_STOCK,
				0 AS RESERVED_PROD_STOCK,
				0 AS RESERVE_SALE_ORDER_STOCK,
				0 AS NOSALE_STOCK,
				0 AS BELONGTO_INSTITUTION_STOCK,
				0 AS RESERVE_PURCHASE_ORDER_STOCK,
				0 AS PRODUCTION_ORDER_STOCK,
				(RESERVE_STOCK_IN-STOCK_IN) AS NOSALE_RESERVED_STOCK,
				ORR.STOCK_ID,
				ORR.PRODUCT_ID,
				ORDS.DELIVER_DEPT_ID AS DEPARTMENT_ID,
				ORDS.LOCATION_ID AS LOCATION_ID
			FROM
				[@_dsn_company_@].GET_ORDER_ROW_RESERVED ORR , 
				[@_dsn_company_@].ORDERS ORDS,
				[@_dsn_main_@].STOCKS_LOCATION SL
			WHERE
				ORDS.RESERVED = 1 AND 
				ORDS.ORDER_STATUS = 1 AND	
				ORDS.DELIVER_DEPT_ID IS NOT NULL AND
				ORDS.LOCATION_ID IS NOT NULL AND
				ORDS.DELIVER_DEPT_ID=SL.DEPARTMENT_ID AND
				ORDS.LOCATION_ID=SL.LOCATION_ID AND
				SL.NO_SALE=1 AND
				ORDS.PURCHASE_SALES=0 AND
				ORDS.ORDER_ZONE=0 AND
				ORR.ORDER_ID = ORDS.ORDER_ID AND 
				(RESERVE_STOCK_IN-STOCK_IN)>0
			UNION ALL
			SELECT
					0 AS REAL_STOCK,
					0 AS PRODUCT_STOCK,
					(STOCK_ARTIR-STOCK_AZALT) AS RESERVED_STOCK,
					STOCK_ARTIR AS PURCHASE_PROD_STOCK,
					STOCK_AZALT AS RESERVED_PROD_STOCK,
					0  AS RESERVE_SALE_ORDER_STOCK,
					0 AS NOSALE_STOCK,
					0 AS BELONGTO_INSTITUTION_STOCK,
					0  AS RESERVE_PURCHASE_ORDER_STOCK,
					(STOCK_ARTIR-STOCK_AZALT)  AS PRODUCTION_ORDER_STOCK,
					0 AS NOSALE_RESERVED_STOCK,
					GET_PRODUCTION_RESERVED_LOCATION.STOCK_ID,
					GET_PRODUCTION_RESERVED_LOCATION.PRODUCT_ID,
					GET_PRODUCTION_RESERVED_LOCATION.DEPARTMENT_ID,
					GET_PRODUCTION_RESERVED_LOCATION.LOCATION_ID
				FROM
					[@_dsn_company_@].GET_PRODUCTION_RESERVED_LOCATION 
		) T1
		GROUP BY
			PRODUCT_ID, 
			STOCK_ID,
			DEPARTMENT_ID,
			LOCATION_ID
	END

CREATE PROCEDURE [@_dsn_period_@].[SpGetStockStrategy]
        AS 
        SELECT XXX.* 
                INTO  ####TStocStrategy
                FROM 
                ####GetStockProfile gsp
                JOIN
                (
            
                    SELECT
                        PRODUCT_ID,
                        STOCK_ID,
                        SUM(MINIMUM_STOCK) AS MINIMUM_STOCK,
                        SUM(MAXIMUM_STOCK) AS MAXIMUM_STOCK,
                        SUM(REPEAT_STOCK_VALUE) AS REPEAT_STOCK_VALUE,
                        SUM(BLOCK_STOCK_VALUE) AS BLOCK_STOCK_VALUE,
                        1 AS STRATEGY_TYPE,
                        DEPARTMENT_ID,
                        PROVISION_TIME,
                        IS_LIVE_ORDER,
                        MINIMUM_ORDER_STOCK_VALUE,
                        MAXIMUM_ORDER_STOCK_VALUE,
                        STOCK_ACTION_ID
                    FROM
                    (
                        SELECT
                            TOTAL_AMOUNT AS MINIMUM_STOCK,
                            0 AS MAXIMUM_STOCK,
                            0 AS REPEAT_STOCK_VALUE,
                            0 AS BLOCK_STOCK_VALUE,
                            SS.PRODUCT_ID,
                            SS.STOCK_ID,
                            SS.DEPARTMENT_ID,
                            SS.PROVISION_TIME,
                            SS.IS_LIVE_ORDER,
                            SS.MINIMUM_ORDER_STOCK_VALUE,
                            SS.MAXIMUM_ORDER_STOCK_VALUE,
                            SS.STOCK_ACTION_ID
                        FROM
                            INVOICE_DAILY_SALES IDS,
                            [@_dsn_company_@].STOCK_STRATEGY SS 
                        WHERE
                            IDS.STOCK_ID=SS.STOCK_ID				
                            AND DATEDIFF(day,IDS.INVOICE_DATE, getdate()) <= MINIMUM_STOCK
                            AND SS.STRATEGY_TYPE=1
                    UNION ALL
                        SELECT
                            0 AS MINIMUM_STOCK,
                            TOTAL_AMOUNT AS MAXIMUM_STOCK,
                            0 AS REPEAT_STOCK_VALUE,
                            0 AS BLOCK_STOCK_VALUE,
                            SS.PRODUCT_ID,
                            SS.STOCK_ID,
                            SS.DEPARTMENT_ID,
                            SS.PROVISION_TIME,
                            SS.IS_LIVE_ORDER,
                            SS.MINIMUM_ORDER_STOCK_VALUE,
                            SS.MAXIMUM_ORDER_STOCK_VALUE,
                            SS.STOCK_ACTION_ID
                        FROM
                            INVOICE_DAILY_SALES IDS,
                            [@_dsn_company_@].STOCK_STRATEGY SS
                        WHERE
                            IDS.STOCK_ID=SS.STOCK_ID				
                            AND DATEDIFF(day,IDS.INVOICE_DATE, getdate()) <= MAXIMUM_STOCK
                            AND SS.STRATEGY_TYPE=1
                    UNION ALL
                        SELECT
                            0 AS MINIMUM_STOCK,
                            0 AS MAXIMUM_STOCK,
                            TOTAL_AMOUNT AS REPEAT_STOCK_VALUE,
                            0 AS BLOCK_STOCK_VALUE,
                            SS.PRODUCT_ID,
                            SS.STOCK_ID,
                            SS.DEPARTMENT_ID,
                            SS.PROVISION_TIME,
                            SS.IS_LIVE_ORDER,
                            SS.MINIMUM_ORDER_STOCK_VALUE,
                            SS.MAXIMUM_ORDER_STOCK_VALUE,
                            SS.STOCK_ACTION_ID
                        FROM
                            INVOICE_DAILY_SALES IDS,
                            [@_dsn_company_@].STOCK_STRATEGY SS
                        WHERE
                            IDS.STOCK_ID=SS.STOCK_ID				
                            AND DATEDIFF(day,IDS.INVOICE_DATE, getdate()) <= REPEAT_STOCK_VALUE
                            AND SS.STRATEGY_TYPE=1 
                    ) AS ALL_TABLE
                    GROUP BY 
                        PRODUCT_ID,
                        STOCK_ID,
                        DEPARTMENT_ID,
                        PROVISION_TIME,
                        IS_LIVE_ORDER,
                        MINIMUM_ORDER_STOCK_VALUE,
                        MAXIMUM_ORDER_STOCK_VALUE,
                        STOCK_ACTION_ID
                UNION ALL
    
                    SELECT
                        PRODUCT_ID,
                        STOCK_ID,
                        MINIMUM_STOCK,
                        MAXIMUM_STOCK,
                        REPEAT_STOCK_VALUE,
                        BLOCK_STOCK_VALUE,
                        STRATEGY_TYPE,
                        DEPARTMENT_ID,
                        PROVISION_TIME,
                        IS_LIVE_ORDER,
                        MINIMUM_ORDER_STOCK_VALUE,
                        MAXIMUM_ORDER_STOCK_VALUE,
                        STOCK_ACTION_ID
                    FROM
                        [@_dsn_company_@].STOCK_STRATEGY SS
                    WHERE
                        STRATEGY_TYPE=0	
                ) AS xxx ON gsp.STOCK_ID = XXX.STOCK_ID

CREATE PROCEDURE [@_dsn_period_@].[SpGetStoctProfile]
                AS 
                    BEGIN
                        
                        SELECT 
                            SUM(REAL_STOCK) REAL_STOCK,
                            SUM(PRODUCT_STOCK) PRODUCT_STOCK,
                            SUM(RESERVED_STOCK) RESERVED_STOCK,
                            SUM(PURCHASE_PROD_STOCK) PURCHASE_PROD_STOCK,
                            SUM(RESERVED_PROD_STOCK) RESERVED_PROD_STOCK,
                            SUM(PRODUCT_STOCK+RESERVED_STOCK) SALEABLE_STOCK,
                            SUM(RESERVE_SALE_ORDER_STOCK) RESERVE_SALE_ORDER_STOCK,
                            SUM(NOSALE_STOCK) NOSALE_STOCK,
                            SUM(BELONGTO_INSTITUTION_STOCK) BELONGTO_INSTITUTION_STOCK,
                            SUM(RESERVE_PURCHASE_ORDER_STOCK) RESERVE_PURCHASE_ORDER_STOCK,
                            SUM(PRODUCTION_ORDER_STOCK) PRODUCTION_ORDER_STOCK,
                            SUM(NOSALE_RESERVED_STOCK) AS NOSALE_RESERVED_STOCK,
                            T1.PRODUCT_ID, 
                            T1.STOCK_ID
                        INTO ####TStockProfile
                        FROM
                        (
                            SELECT
                                (SR.STOCK_IN - SR.STOCK_OUT) AS REAL_STOCK,
                                0 AS PRODUCT_STOCK,
                                0 AS RESERVED_STOCK,
                                0 AS PURCHASE_PROD_STOCK,
                                0 AS RESERVED_PROD_STOCK,
                                0 AS RESERVE_SALE_ORDER_STOCK,
                                0 AS NOSALE_STOCK, 
                                0 AS BELONGTO_INSTITUTION_STOCK,
                                0 AS RESERVE_PURCHASE_ORDER_STOCK,
                                0 AS PRODUCTION_ORDER_STOCK,
                                0 AS NOSALE_RESERVED_STOCK,
                                SR.STOCK_ID,
                                SR.PRODUCT_ID
                            FROM
                                STOCKS_ROW SR
                                JOIN ####GetStockProfile GSP ON SR.STOCK_ID = GSP.STOCK_ID 
                            UNION ALL			
                                SELECT
                                    0 AS REAL_STOCK,
                                    (SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK,
                                    0 AS RESERVED_STOCK,
                                    0 AS PURCHASE_PROD_STOCK,
                                    0 AS RESERVED_PROD_STOCK,
                                    0 AS RESERVE_SALE_ORDER_STOCK,
                                    0 AS NOSALE_STOCK, 
                                    0 AS BELONGTO_INSTITUTION_STOCK,
                                    0 AS RESERVE_PURCHASE_ORDER_STOCK,
                                    0 AS PRODUCTION_ORDER_STOCK,
                                    0 AS NOSALE_RESERVED_STOCK,
                                    SR.STOCK_ID,
                                    SR.PRODUCT_ID
                                FROM
                                    [@_dsn_main_@].STOCKS_LOCATION SL,
                                    STOCKS_ROW SR
                                    JOIN ####GetStockProfile GSP ON SR.STOCK_ID = GSP.STOCK_ID 
                                WHERE
                                    SR.STORE =SL.DEPARTMENT_ID
                                    AND SR.STORE_LOCATION=SL.LOCATION_ID
                                    AND SL.NO_SALE = 0
                            UNION ALL
                                SELECT
                                    0 AS REAL_STOCK,
                                    -1*(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK,
                                    0 AS RESERVED_STOCK,
                                    0 AS PURCHASE_PROD_STOCK,
                                    0 AS RESERVED_PROD_STOCK,
                                    0 AS RESERVE_SALE_ORDER_STOCK,
                                    0 AS NOSALE_STOCK, 
                                    0 AS BELONGTO_INSTITUTION_STOCK,
                                    0 AS RESERVE_PURCHASE_ORDER_STOCK,

                                    0 AS PRODUCTION_ORDER_STOCK,
                                    0 AS NOSALE_RESERVED_STOCK,
                                    SR.STOCK_ID,
                                    SR.PRODUCT_ID
                                FROM
                                    STOCKS_ROW SR JOIN ####GetStockProfile GSP ON SR.STOCK_ID = GSP.STOCK_ID  ,
                                    [@_dsn_main_@].STOCKS_LOCATION SL 
                                WHERE	
                                    SR.STORE = SL.DEPARTMENT_ID AND
                                    SR.STORE_LOCATION = SL.LOCATION_ID AND
                                    ISNULL(SL.IS_SCRAP,0)=1
                            UNION ALL			
                                SELECT
                                    0 AS REAL_STOCK,
                                    0 AS PRODUCT_STOCK,
                                    0 AS RESERVED_STOCK,
                                    0 AS PURCHASE_PROD_STOCK,
                                    0 AS RESERVED_PROD_STOCK,
                                    0 AS RESERVE_SALE_ORDER_STOCK,
                                    (SR.STOCK_IN - SR.STOCK_OUT) AS NOSALE_STOCK,
                                    0 AS BELONGTO_INSTITUTION_STOCK,
                                    0 AS RESERVE_PURCHASE_ORDER_STOCK,
                                    0 AS PRODUCTION_ORDER_STOCK,
                                    0 AS NOSALE_RESERVED_STOCK,
                                    SR.STOCK_ID,
                                    SR.PRODUCT_ID
                                FROM
                                    [@_dsn_main_@].STOCKS_LOCATION SL,
                                    STOCKS_ROW SR JOIN ####GetStockProfile GSP ON SR.STOCK_ID = GSP.STOCK_ID 
                                WHERE
                                    SR.STORE =SL.DEPARTMENT_ID
                                    AND SR.STORE_LOCATION=SL.LOCATION_ID
                                    AND SL.NO_SALE =1
                            UNION ALL
                                SELECT
                                    0 AS REAL_STOCK,
                                    0 AS PRODUCT_STOCK,
                                    0 AS RESERVED_STOCK,
                                    0 AS PURCHASE_PROD_STOCK,
                                    0 AS RESERVED_PROD_STOCK,
                                    0 AS RESERVE_SALE_ORDER_STOCK,
                                    0 AS NOSALE_STOCK, 
                                    (SR.STOCK_IN - SR.STOCK_OUT) AS BELONGTO_INSTITUTION_STOCK,
                                    0 AS RESERVE_PURCHASE_ORDER_STOCK,
                                    0 AS PRODUCTION_ORDER_STOCK,
                                    0 AS NOSALE_RESERVED_STOCK,
                                    SR.STOCK_ID,
                                    SR.PRODUCT_ID
                                FROM
                                    [@_dsn_main_@].STOCKS_LOCATION SL,
                                    STOCKS_ROW SR JOIN ####GetStockProfile GSP ON SR.STOCK_ID = GSP.STOCK_ID 
                                WHERE
                                    SR.STORE =SL.DEPARTMENT_ID
                                    AND SR.STORE_LOCATION=SL.LOCATION_ID
                                    AND SL.BELONGTO_INSTITUTION =1
                            UNION ALL			
                                SELECT
                                    0 AS REAL_STOCK,
                                    0 AS PRODUCT_STOCK,
                                    ((RESERVE_STOCK_OUT-STOCK_OUT)*-1) AS RESERVED_STOCK,
                                    0 AS PURCHASE_PROD_STOCK,
                                    0 AS RESERVED_PROD_STOCK,
                                    (RESERVE_STOCK_OUT-STOCK_OUT) AS RESERVE_SALE_ORDER_STOCK,
                                    0 AS NOSALE_STOCK,
                                    0 AS BELONGTO_INSTITUTION_STOCK,
                                    (RESERVE_STOCK_IN-STOCK_IN) AS RESERVE_PURCHASE_ORDER_STOCK,
                                    0 AS PRODUCTION_ORDER_STOCK,
                                    0 AS NOSALE_RESERVED_STOCK,
                                    ORR.STOCK_ID,
                                    ORR.PRODUCT_ID
                                FROM
                                    [@_dsn_company_@].GET_ORDER_ROW_RESERVED ORR JOIN ####GetStockProfile GSP ON ORR.STOCK_ID = GSP.STOCK_ID , 
                                    [@_dsn_company_@].ORDERS ORDS
                                WHERE
                                    ORDS.RESERVED = 1 AND 
                                    ORDS.ORDER_STATUS = 1 AND	
                                    ORR.ORDER_ID = ORDS.ORDER_ID AND
                                    ((RESERVE_STOCK_IN-STOCK_IN)>0 OR (RESERVE_STOCK_OUT-STOCK_OUT)>0)	
                            UNION ALL			
                                SELECT
                                    0 AS REAL_STOCK,
                                    0 AS PRODUCT_STOCK,
                                    (RESERVE_STOCK_IN-STOCK_IN) AS RESERVED_STOCK,
                                    0 AS PURCHASE_PROD_STOCK,
                                    0 AS RESERVED_PROD_STOCK,
                                    0 AS RESERVE_SALE_ORDER_STOCK,
                                    0 AS NOSALE_STOCK,
                                    0 AS BELONGTO_INSTITUTION_STOCK,
                                    0 AS RESERVE_PURCHASE_ORDER_STOCK,
                                    0 AS PRODUCTION_ORDER_STOCK,
                                    0 AS NOSALE_RESERVED_STOCK,
                                    ORR.STOCK_ID,
                                    ORR.PRODUCT_ID
                                FROM
                                    [@_dsn_main_@].STOCKS_LOCATION SL,
                                    [@_dsn_company_@].GET_ORDER_ROW_RESERVED ORR JOIN ####GetStockProfile GSP ON ORR.STOCK_ID = GSP.STOCK_ID , 
                                    [@_dsn_company_@].ORDERS ORDS
                                WHERE
                                    ORDS.DELIVER_DEPT_ID=SL.DEPARTMENT_ID AND
                                    ORDS.LOCATION_ID=SL.LOCATION_ID AND
                                    SL.NO_SALE = 0 AND
                                    ORDS.PURCHASE_SALES=0 AND
                                    ORDS.ORDER_ZONE=0 AND
                                    ORDS.RESERVED = 1 AND 
                                    ORDS.ORDER_STATUS = 1 AND	
                                    ORR.ORDER_ID = ORDS.ORDER_ID AND
                                    (RESERVE_STOCK_IN-STOCK_IN)>0
                            UNION ALL			
                                SELECT
                                    0 AS REAL_STOCK,
                                    0 AS PRODUCT_STOCK,
                                    0 AS RESERVED_STOCK,
                                    0 AS PURCHASE_PROD_STOCK,
                                    0 AS RESERVED_PROD_STOCK,
                                    0 AS RESERVE_SALE_ORDER_STOCK,
                                    0 AS NOSALE_STOCK,
                                    0 AS BELONGTO_INSTITUTION_STOCK,
                                    0 AS RESERVE_PURCHASE_ORDER_STOCK,
                                    0 AS PRODUCTION_ORDER_STOCK,
                                    (RESERVE_STOCK_IN-STOCK_IN) AS NOSALE_RESERVED_STOCK,
                                    ORR.STOCK_ID,
                                    ORR.PRODUCT_ID
                                FROM
                                    [@_dsn_main_@].STOCKS_LOCATION SL,
                                    [@_dsn_company_@].GET_ORDER_ROW_RESERVED ORR JOIN ####GetStockProfile GSP ON ORR.STOCK_ID = GSP.STOCK_ID , 
                                    [@_dsn_company_@].ORDERS ORDS
                                WHERE
                                    ORDS.DELIVER_DEPT_ID=SL.DEPARTMENT_ID AND
                                    ORDS.LOCATION_ID=SL.LOCATION_ID AND
                                    SL.NO_SALE = 1 AND
                                    ORDS.PURCHASE_SALES=0 AND
                                    ORDS.ORDER_ZONE=0 AND
                                    ORDS.RESERVED = 1 AND 
                                    ORDS.ORDER_STATUS = 1 AND	
                                    ORR.ORDER_ID = ORDS.ORDER_ID AND
                                    (RESERVE_STOCK_IN-STOCK_IN)>0
                            UNION ALL			
                                SELECT
                                    0 AS REAL_STOCK,
                                    0 AS PRODUCT_STOCK,
                                    ((RESERVE_STOCK_IN-STOCK_IN) + ((RESERVE_STOCK_OUT-STOCK_OUT)*-1)) AS RESERVED_STOCK,
                                    0 AS PURCHASE_PROD_STOCK,
                                    0 AS RESERVED_PROD_STOCK,
                                    (RESERVE_STOCK_OUT-STOCK_OUT) AS RESERVE_SALE_ORDER_STOCK,
                                    0 AS NOSALE_STOCK,
                                    0 AS BELONGTO_INSTITUTION_STOCK,
                                    (RESERVE_STOCK_IN-STOCK_IN) AS RESERVE_PURCHASE_ORDER_STOCK,
                                    0 AS PRODUCTION_ORDER_STOCK,
                                    0 AS NOSALE_RESERVED_STOCK,
                                    ORR.STOCK_ID,
                                    ORR.PRODUCT_ID
                                FROM
                                    [@_dsn_company_@].ORDER_ROW_RESERVED  ORR JOIN ####GetStockProfile GSP ON ORR.STOCK_ID = GSP.STOCK_ID 
                                WHERE
                                    ORDER_ID IS NULL
                                    AND SHIP_ID IS NULL
                                    AND INVOICE_ID IS NULL
                            UNION ALL
                                SELECT
                                    0 AS REAL_STOCK,
                                    0 AS PRODUCT_STOCK,
                                    (STOCK_ARTIR-STOCK_AZALT) AS RESERVED_STOCK,
                                    STOCK_ARTIR AS PURCHASE_PROD_STOCK,
                                    STOCK_AZALT AS RESERVED_PROD_STOCK,
                                    0  AS RESERVE_SALE_ORDER_STOCK,
                                    0 AS NOSALE_STOCK,
                                    0 AS BELONGTO_INSTITUTION_STOCK,
                                    0  AS RESERVE_PURCHASE_ORDER_STOCK,
                                    (STOCK_ARTIR-STOCK_AZALT)  AS PRODUCTION_ORDER_STOCK,
                                    0 AS NOSALE_RESERVED_STOCK,
                                    GSP.STOCK_ID,
                                    GSP.PRODUCT_ID
                                FROM
                                    [@_dsn_company_@].GET_PRODUCTION_RESERVED JOIN ####GetStockProfile GSP ON GET_PRODUCTION_RESERVED.STOCK_ID = GSP.STOCK_ID  
                        ) T1 
                        GROUP BY
                            t1.PRODUCT_ID, 
                            t1.STOCK_ID
                END

CREATE PROCEDURE [@_dsn_period_@].[UPD_SHIP_COST]
            @aktarim_is_location_based_cost smallint,
            @is_prod_cost_type bit
        AS
        BEGIN
        
            SET NOCOUNT ON;
             IF ( @aktarim_is_location_based_cost = 1  and @is_prod_cost_type = 0 )
                 BEGIN
                      UPDATE
                                SHIP_ROW
                                SET
                                    COST_PRICE=ISNULL(XXX.p1,0),            
                                    EXTRA_COST=ISNULL((XXX.r1),0)
                                            
                                FROM 

                                    SHIP_ROW
                                OUTER APPLY 
                                    (
                                        SELECT
                                                    TOP 1 
                                              
                                                             ROUND((PURCHASE_NET_SYSTEM_LOCATION),4) AS p1
                                                            ,ROUND((PURCHASE_EXTRA_COST_SYSTEM_LOCATION),4) AS r1
                                                
                                                    FROM 
                                                        [@_dsn_company_@].PRODUCT_COST GPCP
                                                    WHERE
                                                            GPCP.START_DATE <= (SELECT INV.SHIP_DATE FROM SHIP INV WHERE INV.SHIP_ID = SHIP_ROW.SHIP_ID)
                                                            AND GPCP.PRODUCT_ID = SHIP_ROW.PRODUCT_ID
                                                            AND ISNULL(GPCP.SPECT_MAIN_ID,0)=ISNULL((SELECT S.SPECT_MAIN_ID FROM [@_dsn_company_@].SPECTS S WHERE S.SPECT_VAR_ID = SHIP_ROW.SPECT_VAR_ID),0)
                                                            AND GPCP.LOCATION_ID = (SELECT II.LOCATION FROM SHIP II WHERE II.SHIP_ID = SHIP_ROW.SHIP_ID)
                                                            AND GPCP.DEPARTMENT_ID = (SELECT II.DELIVER_STORE_ID FROM SHIP II WHERE II.SHIP_ID = SHIP_ROW.SHIP_ID)
                                                   ORDER BY GPCP.START_DATE DESC,GPCP.RECORD_DATE DESC,GPCP.PRODUCT_COST_ID DESC
                                    ) AS XXX
                                JOIN
                                    ####GET_INVOICE GET_INVOICE ON SHIP_ROW.SHIP_ID = GET_INVOICE.ACTION_ID AND GET_INVOICE.SHIP_TYPE_NEW=81
            
                END
            ELSE
                IF (@aktarim_is_location_based_cost = 0  and @is_prod_cost_type = 0)
                    BEGIN
                          UPDATE
                                SHIP_ROW
                            SET
                                COST_PRICE=ISNULL(XXX.p1,0),            
                                EXTRA_COST=ISNULL((XXX.r1),0)
                                            
                            FROM 
                                SHIP_ROW
                            OUTER APPLY 
                                (
                                    SELECT
                                                TOP 1 
                                                    ROUND((PURCHASE_NET_SYSTEM),4) AS p1,
                                                    ROUND((PURCHASE_EXTRA_COST_SYSTEM),4) AS r1
                                                FROM 
                                                    [@_dsn_company_@].PRODUCT_COST GPCP
                                                WHERE
                                                    GPCP.START_DATE <= (SELECT INV.SHIP_DATE FROM SHIP INV WHERE INV.SHIP_ID = SHIP_ROW.SHIP_ID)
                                                    AND GPCP.PRODUCT_ID = SHIP_ROW.PRODUCT_ID
                                                    AND ISNULL(GPCP.SPECT_MAIN_ID,0)=ISNULL((SELECT S.SPECT_MAIN_ID FROM [@_dsn_company_@].SPECTS S WHERE S.SPECT_VAR_ID = SHIP_ROW.SPECT_VAR_ID),0)
                                                ORDER BY 
                                                    GPCP.START_DATE DESC,
                                                    GPCP.RECORD_DATE DESC,
                                                    GPCP.PRODUCT_COST_ID DESC
                                ) AS XXX
                            JOIN
                                ####GET_INVOICE GET_INVOICE ON SHIP_ROW.SHIP_ID = GET_INVOICE.ACTION_ID AND GET_INVOICE.SHIP_TYPE_NEW=81
                    END
        
                    ELSE
                        IF (@aktarim_is_location_based_cost = 1  and @is_prod_cost_type =1 )
                            BEGIN
                                  UPDATE
                                        SHIP_ROW
                                        SET
                                            COST_PRICE=ISNULL(XXX.p1,0),            
                                            EXTRA_COST=ISNULL((XXX.r1),0)
                                            
                                        FROM 
                                            SHIP_ROW
                                        OUTER APPLY 
                                            (
                                                SELECT
                                                            TOP 1 
                                                                    ROUND((PURCHASE_NET_SYSTEM_LOCATION),4) AS p1
                                                                   ,ROUND((PURCHASE_EXTRA_COST_SYSTEM_LOCATION),4) AS r1
        
                                                            FROM 
                                                                [@_dsn_company_@].PRODUCT_COST GPCP
                                                            WHERE
                                                                GPCP.START_DATE <= (SELECT INV.SHIP_DATE FROM SHIP INV WHERE INV.SHIP_ID = SHIP_ROW.SHIP_ID)
                                                                AND GPCP.PRODUCT_ID = SHIP_ROW.PRODUCT_ID
                                                                AND GPCP.LOCATION_ID = (SELECT II.LOCATION FROM SHIP II WHERE II.SHIP_ID = SHIP_ROW.SHIP_ID)
                                                                AND GPCP.DEPARTMENT_ID = (SELECT II.DELIVER_STORE_ID FROM SHIP II WHERE II.SHIP_ID = SHIP_ROW.SHIP_ID)
                                                            ORDER BY 
                                                                GPCP.START_DATE DESC,
                                                                GPCP.RECORD_DATE DESC,
                                                                GPCP.PRODUCT_COST_ID DESC
                                            ) AS XXX
                                        JOIN
                                            ####GET_INVOICE GET_INVOICE ON SHIP_ROW.SHIP_ID = GET_INVOICE.ACTION_ID AND GET_INVOICE.SHIP_TYPE_NEW=81
                            END
        
                        ELSE
                            IF (@aktarim_is_location_based_cost = 0  and @is_prod_cost_type = 1 )
                            BEGIN
                                  UPDATE
        
                                        SHIP_ROW
                                        SET
                                            COST_PRICE=ISNULL(XXX.p1,0),            
                                            EXTRA_COST=ISNULL((XXX.r1),0)
                                            
                                        FROM 
                                            SHIP_ROW
                                        OUTER APPLY 
                                            (
                                                SELECT
                                                            TOP 1 
                                                                    ROUND((PURCHASE_NET_SYSTEM),4) AS p1
                                                                    ,ROUND((PURCHASE_EXTRA_COST_SYSTEM),4) AS r1
                                                            FROM 
                                                                [@_dsn_company_@].PRODUCT_COST GPCP
                                                            WHERE
                                                                GPCP.START_DATE <= (SELECT INV.SHIP_DATE FROM SHIP INV WHERE INV.SHIP_ID = SHIP_ROW.SHIP_ID)
                                                                AND GPCP.PRODUCT_ID = SHIP_ROW.PRODUCT_ID
                                                            ORDER BY GPCP.START_DATE DESC,GPCP.RECORD_DATE DESC,GPCP.PRODUCT_COST_ID DESC
                                            ) AS XXX
                                        JOIN
                                            ####GET_INVOICE GET_INVOICE ON SHIP_ROW.SHIP_ID = GET_INVOICE.ACTION_ID AND GET_INVOICE.SHIP_TYPE_NEW=81
                            END
                     ELSE
                     IF ( @aktarim_is_location_based_cost = 2  and @is_prod_cost_type = 0 )
                         BEGIN
                              UPDATE
                                        SHIP_ROW
                                        SET
                                            COST_PRICE=ISNULL(XXX.p1,0),            
                                            EXTRA_COST=ISNULL((XXX.r1),0)
                                                    
                                        FROM 
        
                                            SHIP_ROW
                                        OUTER APPLY 
                                            (
                                                SELECT
                                                            TOP 1 
                                                      
                                                                     ROUND((PURCHASE_NET_SYSTEM_DEPARTMENT),4) AS p1
                                                                    ,ROUND((PURCHASE_EXTRA_COST_SYSTEM_DEPARTMENT),4) AS r1
                                                        
                                                            FROM 
                                                                [@_dsn_company_@].PRODUCT_COST GPCP
                                                            WHERE
                                                                    GPCP.START_DATE <= (SELECT INV.SHIP_DATE FROM SHIP INV WHERE INV.SHIP_ID = SHIP_ROW.SHIP_ID)
                                                                    AND GPCP.PRODUCT_ID = SHIP_ROW.PRODUCT_ID
                                                                    AND ISNULL(GPCP.SPECT_MAIN_ID,0)=ISNULL((SELECT S.SPECT_MAIN_ID FROM [@_dsn_company_@].SPECTS S WHERE S.SPECT_VAR_ID = SHIP_ROW.SPECT_VAR_ID),0)
                                                                    AND GPCP.DEPARTMENT_ID = (SELECT II.DELIVER_STORE_ID FROM SHIP II WHERE II.SHIP_ID = SHIP_ROW.SHIP_ID)
                                                           ORDER BY GPCP.START_DATE DESC,GPCP.RECORD_DATE DESC,GPCP.PRODUCT_COST_ID DESC
                                            ) AS XXX
                                        JOIN
                                            ####GET_INVOICE GET_INVOICE ON SHIP_ROW.SHIP_ID = GET_INVOICE.ACTION_ID AND GET_INVOICE.SHIP_TYPE_NEW=81
                    
                        END
                    ELSE
                        IF (@aktarim_is_location_based_cost = 2  and @is_prod_cost_type =1 )
                            BEGIN
                                    UPDATE
                                        SHIP_ROW
                                        SET
                                            COST_PRICE=ISNULL(XXX.p1,0),            
                                            EXTRA_COST=ISNULL((XXX.r1),0)
                                                    
                                        FROM 
                                            SHIP_ROW
                                        OUTER APPLY 
                                            (
                                                SELECT
                                                            TOP 1 
                                                                    ROUND((PURCHASE_NET_SYSTEM_DEPARTMENT),4) AS p1
                                                                    ,ROUND((PURCHASE_EXTRA_COST_SYSTEM_DEPARTMENT),4) AS r1
                
                                                            FROM 
                                                                [@_dsn_company_@].PRODUCT_COST GPCP
                                                            WHERE
                                                                GPCP.START_DATE <= (SELECT INV.SHIP_DATE FROM SHIP INV WHERE INV.SHIP_ID = SHIP_ROW.SHIP_ID)
                                                                AND GPCP.PRODUCT_ID = SHIP_ROW.PRODUCT_ID
                                                                AND GPCP.DEPARTMENT_ID = (SELECT II.DELIVER_STORE_ID FROM SHIP II WHERE II.SHIP_ID = SHIP_ROW.SHIP_ID)
                                                            ORDER BY 
                                                                GPCP.START_DATE DESC,
                                                                GPCP.RECORD_DATE DESC,
                                                                GPCP.PRODUCT_COST_ID DESC
                                            ) AS XXX
                                        JOIN
                                            ####GET_INVOICE GET_INVOICE ON SHIP_ROW.SHIP_ID = GET_INVOICE.ACTION_ID AND GET_INVOICE.SHIP_TYPE_NEW=81
                            END
        
        END