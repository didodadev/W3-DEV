<!--- ürün ağacında yapılan değişiklikler sonucu xml e bağlı olarak özelleştirilebilir olmayan ürünün
		 üretim emirlerinin sarf ve firelerini silip yeniden oluşturur. hgul 20130306 --->
<cfsetting requesttimeout="100000">
<cfif not isdefined("new_dsn3")>
	<cfset new_dsn3 = dsn3>
</cfif>
<cfquery name="get_temp_table" datasource="#new_dsn3#">
	IF object_id('tempdb..##TEMP_P_ORDER_ID') IS NOT NULL
	   BEGIN
		DROP TABLE ##TEMP_P_ORDER_ID 
	   END
</cfquery>
<cfquery name="temp_table" datasource="#new_dsn3#">
	CREATE TABLE ##TEMP_P_ORDER_ID 
	( 
		P_ORDER_ID	int
	)
</cfquery>
<cfquery name="get_p_order_id" datasource="#new_dsn3#">
	INSERT INTO ##TEMP_P_ORDER_ID 
	(
		P_ORDER_ID
	)
		SELECT P_ORDER_ID FROM PRODUCTION_ORDERS WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
</cfquery>
<cfquery name="xx" datasource="#dsn3#">
SELECT P_ORDER_ID FROM PRODUCTION_ORDERS WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
</cfquery>
<cflock name="#createuuid()#" timeout="20">
	<cftransaction>
		<cfquery name="get_sub_product_main" datasource="#dsn3#"><!--- ilgili ürüne ait üretim emirlerinin sarf ve fire satırları siliniyor --->
			DELETE FROM PRODUCTION_ORDERS_STOCKS WHERE P_ORDER_ID IN (SELECT * FROM ##TEMP_P_ORDER_ID)
		</cfquery>
		<!--- production_orders_stocks tablosunda ilgili ürünün üretim emirlerine sarf ve fire ekliyor. --->
		<cfquery name="get_sub_product" datasource="#new_dsn3#"><!--- sarf ekleniyor --->
			SELECT
				PRODUCTION_ORDERS.P_ORDER_ID,
				PRODUCTION_ORDERS.IS_DEMONTAJ,
				PRODUCTION_ORDERS.QUANTITY,
				PRODUCTION_ORDERS.SPEC_MAIN_ID,
				PRODUCTION_ORDERS.SPECT_VAR_ID,
				SPECT_MAIN_ROW.RELATED_MAIN_SPECT_ID,
				SPECT_MAIN_ROW.AMOUNT AS AMOUNT, 
				ISNULL(SPECT_MAIN_ROW.IS_FREE_AMOUNT,0) AS IS_FREE_AMOUNT,
				STOCKS.PRODUCT_ID,
				STOCKS.STOCK_ID,
				PRODUCT_UNIT.PRODUCT_UNIT_ID,
				0 IS_PHANTOM,
				SPECT_MAIN_ROW.IS_SEVK,
				SPECT_MAIN_ROW.IS_PROPERTY,
				ISNULL(SPECT_MAIN_ROW.FIRE_AMOUNT,0) FIRE_AMOUNT,
				ISNULL(SPECT_MAIN_ROW.FIRE_RATE,0) FIRE_RATE,
				SPECT_MAIN_ROW.SPECT_MAIN_ROW_ID,
				0 AS SUB_SPEC_MAIN_ID,
				PRODUCTION_ORDERS.RECORD_EMP,
				PRODUCTION_ORDERS.RECORD_DATE,
				PRODUCTION_ORDERS.RECORD_IP
			FROM
				SPECT_MAIN,
				SPECT_MAIN_ROW,
				STOCKS,
				PRODUCT_UNIT,
				PRODUCTION_ORDERS
			WHERE
				PRODUCTION_ORDERS.P_ORDER_ID IN (SELECT * FROM ##TEMP_P_ORDER_ID) AND
				STOCKS.PRODUCT_ID IN (
									SELECT 
										PRICE_STANDART.PRODUCT_ID 
									FROM 
										PRICE_STANDART 
									WHERE 
										PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID AND
										PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
										PRICE_STANDART.PURCHASESALES = 1 AND
										STOCKS.PRODUCT_UNIT_ID=PRICE_STANDART.UNIT_ID) AND
				STOCKS.STOCK_STATUS = 1	AND
				SPECT_MAIN.SPECT_MAIN_ID = PRODUCTION_ORDERS.SPEC_MAIN_ID AND
				SPECT_MAIN.SPECT_MAIN_ID = SPECT_MAIN_ROW.SPECT_MAIN_ID AND
				SPECT_MAIN_ROW.STOCK_ID = STOCKS.STOCK_ID AND
				SPECT_MAIN_ROW.IS_PROPERTY IN(0,4) AND
				ISNULL(SPECT_MAIN_ROW.IS_PHANTOM,0)=0 AND
				PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID
		</cfquery>
		<cfif get_sub_product.recordcount>
			<cfoutput query="get_sub_product">
				<cfset phantom_stock_id_list = ''>
				<cfset phantom_spec_main_id_list = ''>
				<cfif len(get_sub_product.SPEC_MAIN_ID)>
					<cfset main_product_spec_main_id = get_sub_product.SPEC_MAIN_ID>
				<cfelseif len(get_sub_product.SPECT_VAR_ID)>
					<cfquery name="get_main_spec_id" datasource="#new_dsn3#">
						SELECT SPECT_MAIN_ID FROM SPECTS WHERE SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sub_product.SPECT_VAR_ID#">
					</cfquery>
					<cfset main_product_spec_main_id = get_main_spec_id.SPECT_MAIN_ID>
				<cfelse><!--- SPEC_VAR_ID VE SPEC_MAIN_ID SEÇİLMEMİŞ İSE...--->
					<cfquery name="get_main_spec_id" datasource="#new_dsn3#">
						SELECT TOP 1 SPECT_MAIN_ID FROM SPECT_MAIN SM WHERE SM.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sub_product.STOCK_ID#">
					</cfquery>
					<cfset main_product_spec_main_id = get_main_spec_id.SPECT_MAIN_ID>
				</cfif>
				<cfif not isdefined("control_spect_#main_product_spec_main_id#_#p_order_id#")>
					<cfif main_product_spec_main_id gt 0>
						<cfscript>
							writeProductTree(main_product_spec_main_id,1);//geT_phantom_product_list sayfaısndan geliyor
						</cfscript>
					</cfif>
					<cfif len(phantom_spec_main_id_list)>
						<cfquery name="get_sub_phantom_product" datasource="#new_dsn3#">
							SELECT
								#P_ORDER_ID# P_ORDER_ID,
								#IS_DEMONTAJ# IS_DEMONTAJ,
								#QUANTITY# QUANTITY,
								#SPEC_MAIN_ID# SPEC_MAIN_ID,
								SPECT_MAIN_ROW.RELATED_MAIN_SPECT_ID,
								SPECT_MAIN_ROW.AMOUNT AS AMOUNT, 
								ISNULL(SPECT_MAIN_ROW.IS_FREE_AMOUNT,0) AS IS_FREE_AMOUNT,
								STOCKS.PRODUCT_ID,
								STOCKS.STOCK_ID,
								PRODUCT_UNIT.PRODUCT_UNIT_ID,
								1 IS_PHANTOM,
								SPECT_MAIN_ROW.IS_SEVK,
								SPECT_MAIN_ROW.IS_PROPERTY,
								ISNULL(SPECT_MAIN_ROW.FIRE_AMOUNT,0) FIRE_AMOUNT,
								ISNULL(SPECT_MAIN_ROW.FIRE_RATE,0) FIRE_RATE,
								SPECT_MAIN_ROW.SPECT_MAIN_ROW_ID,
								SPECT_MAIN.SPECT_MAIN_ID AS SUB_SPEC_MAIN_ID,<!--- BU ALAN SARF SATIRINA GELEN ÜRÜNÜN HANGİ SPEC'E BAĞLI OLDUĞUNU GÖSTERMEK İÇİN KONULDU.. --->
								#RECORD_EMP# RECORD_EMP,
								'#RECORD_DATE#' AS RECORD_DATE,
								'#RECORD_IP#' AS RECORD_IP
							FROM
								SPECT_MAIN,
								SPECT_MAIN_ROW,
								STOCKS,
								PRODUCT_UNIT
							WHERE
								STOCKS.PRODUCT_ID IN (
													SELECT 
														PRICE_STANDART.PRODUCT_ID 
													FROM 
														PRICE_STANDART 
													WHERE 
														PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID AND
														PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
														PRICE_STANDART.PURCHASESALES = 1 AND
														STOCKS.PRODUCT_UNIT_ID=PRICE_STANDART.UNIT_ID) AND
								STOCKS.STOCK_STATUS = 1	AND
								SPECT_MAIN.SPECT_MAIN_ID IN (#phantom_spec_main_id_list#) AND
								SPECT_MAIN.SPECT_MAIN_ID = SPECT_MAIN_ROW.SPECT_MAIN_ID AND
								SPECT_MAIN_ROW.STOCK_ID = STOCKS.STOCK_ID AND
								SPECT_MAIN_ROW.IS_PROPERTY IN(0,4) AND
								ISNULL(SPECT_MAIN_ROW.IS_PHANTOM,0)=0 AND
								PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID
						</cfquery>
						<cfloop query="get_sub_phantom_product">
							<cfset _AMOUNT_ = AMOUNT>
							<cfif isdefined('multipler_#SUB_SPEC_MAIN_ID#')>
								<cfset _amount_ =  Evaluate('multipler_#SUB_SPEC_MAIN_ID#')*AMOUNT>
							</cfif>
							<cfif is_free_amount eq 1>
								<cfset amount__ = _amount_>
							<cfelse>
								<cfset amount__ = _amount_ * QUANTITY>
							</cfif>
							<cfquery name="add_production_orders_stocks" datasource="#new_dsn3#"> <!--- fantom ürün varsa --->
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
										RECORD_DATE,
										RECORD_EMP,
										RECORD_IP,
										IS_PHANTOM,
										IS_SEVK,
										IS_PROPERTY,
										IS_FREE_AMOUNT,
										FIRE_AMOUNT,
										FIRE_RATE,
										SPECT_MAIN_ROW_ID,
										IS_FLAG
									)
								VALUES
									(
										#P_ORDER_ID#,
										#PRODUCT_ID#,
										#STOCK_ID#,
										<cfif len(RELATED_MAIN_SPECT_ID)>#RELATED_MAIN_SPECT_ID#<cfelse>NULL</cfif>,
										#amount__#,
										2,
										#PRODUCT_UNIT_ID#,
										#createodbcdatetime(RECORD_DATE)#,
										#RECORD_EMP#,
										'#RECORD_IP#',
										#IS_PHANTOM#,
										<cfif len(IS_SEVK)>#IS_SEVK#<cfelse>NULL</cfif>,
										#IS_PROPERTY#,
										#IS_FREE_AMOUNT#,
										#FIRE_AMOUNT#,
										#FIRE_RATE#,
										#SPECT_MAIN_ROW_ID#,
										1
									)	
							</cfquery>
						</cfloop>
		
					</cfif>
					<cfset "control_spect_#main_product_spec_main_id#_#p_order_id#" = 1>
				</cfif>
					<cfif is_demontaj eq 1>
						<cfset amount_ = QUANTITY>
					<cfelse>
						<cfif is_free_amount eq 1>
							<cfset amount_ = AMOUNT>
						<cfelse>
							<cfset amount_ = AMOUNT * QUANTITY>
						</cfif>
					</cfif>
					<cfquery name="add_production_orders_stocks" datasource="#new_dsn3#"> <!--- ilgili sirkette kayit varsa --->
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
								RECORD_DATE,
								RECORD_EMP,
								RECORD_IP,
								IS_PHANTOM,
								IS_SEVK,
								IS_PROPERTY,
								IS_FREE_AMOUNT,
								FIRE_AMOUNT,
								FIRE_RATE,
								SPECT_MAIN_ROW_ID,
								IS_FLAG
							)
						VALUES
							(
								#P_ORDER_ID#,
								#PRODUCT_ID#,
								#STOCK_ID#,
								<cfif len(RELATED_MAIN_SPECT_ID)>#RELATED_MAIN_SPECT_ID#<cfelse>NULL</cfif>,
								#amount_#,
								2,
								#PRODUCT_UNIT_ID#,
								#createodbcdatetime(RECORD_DATE)#,
								#RECORD_EMP#,
								'#RECORD_IP#',
								#IS_PHANTOM#,
								<cfif len(IS_SEVK)>#IS_SEVK#<cfelse>NULL</cfif>,
								#IS_PROPERTY#,
								#IS_FREE_AMOUNT#,
								#FIRE_AMOUNT#,
								#FIRE_RATE#,
								#SPECT_MAIN_ROW_ID#,
								1
							)	
					</cfquery>
			</cfoutput>
		</cfif>
		<cfquery name="get_sub_product_fire" datasource="#new_dsn3#"><!--- Fire ekleniyor --->
			SELECT
				PRODUCTION_ORDERS.P_ORDER_ID,
				PRODUCTION_ORDERS.IS_DEMONTAJ,
				PRODUCTION_ORDERS.QUANTITY,
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
				PRODUCTION_ORDERS.RECORD_EMP,
				PRODUCTION_ORDERS.RECORD_DATE,
				PRODUCTION_ORDERS.RECORD_IP
			FROM
				SPECT_MAIN,
				SPECT_MAIN_ROW,
				STOCKS,
				PRODUCT_UNIT,
				PRODUCTION_ORDERS
			WHERE
				STOCKS.PRODUCT_ID IN (
									SELECT 
										PRICE_STANDART.PRODUCT_ID 
									FROM 
										PRICE_STANDART 
									WHERE 
										PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID AND
										PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
										PRICE_STANDART.PURCHASESALES = 1 AND
										STOCKS.PRODUCT_UNIT_ID=PRICE_STANDART.UNIT_ID) AND
				STOCKS.STOCK_STATUS = 1	AND
				ISNULL(IS_PHANTOM,0) = 0 AND
				SPECT_MAIN.SPECT_MAIN_ID = PRODUCTION_ORDERS.SPEC_MAIN_ID AND
				SPECT_MAIN.SPECT_MAIN_ID = SPECT_MAIN_ROW.SPECT_MAIN_ID AND
				SPECT_MAIN_ROW.STOCK_ID = STOCKS.STOCK_ID AND
				(ISNULL(SPECT_MAIN_ROW.FIRE_AMOUNT,0)<>0 OR ISNULL(SPECT_MAIN_ROW.FIRE_RATE,0)<>0)  AND
				PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
				PRODUCTION_ORDERS.P_ORDER_ID NOT IN (SELECT P_ORDER_ID FROM PRODUCTION_ORDERS_STOCKS WHERE PRODUCTION_ORDERS_STOCKS.TYPE = 3 AND IS_FLAG = 1)<!---  AND
				PRODUCTION_ORDERS.P_ORDER_ID NOT IN (SELECT P_ORDER_ID FROM PRODUCTION_ORDER_RESULTS) --->
		</cfquery>
		<cfif get_sub_product_fire.recordcount>
			<cfoutput query="get_sub_product_fire">
				<cfset amount_ = AMOUNT * QUANTITY>
				<cfquery name="add_sub_product_fire" datasource="#new_dsn3#"> <!--- ilgili sirkette kayit varsa --->
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
							RECORD_DATE,
							RECORD_EMP,
							RECORD_IP,
							IS_PHANTOM,
							IS_SEVK,
							IS_PROPERTY,
							IS_FREE_AMOUNT,
							FIRE_AMOUNT,
							FIRE_RATE,
							SPECT_MAIN_ROW_ID,
							IS_FLAG
						)
					VALUES
						(
							#P_ORDER_ID#,
							#PRODUCT_ID#,
							#STOCK_ID#,
							<cfif len(RELATED_MAIN_SPECT_ID)>#RELATED_MAIN_SPECT_ID#<cfelse>NULL</cfif>,
							#amount_#,
							3,
							#PRODUCT_UNIT_ID#,
							#createodbcdatetime(RECORD_DATE)#,
							#RECORD_EMP#,
							'#RECORD_IP#',
							0,
							<cfif len(IS_SEVK)>#IS_SEVK#<cfelse>NULL</cfif>,
							#IS_PROPERTY#,
							#IS_FREE_AMOUNT#,
							#FIRE_AMOUNT#,
							#FIRE_RATE#,
							#SPECT_MAIN_ROW_ID#,
							1
						)	
				</cfquery>
			</cfoutput>
		</cfif>
		<cfquery name="get_temp_table" datasource="#new_dsn3#">
			IF object_id('tempdb..##TEMP_P_ORDER_ID') IS NOT NULL
				BEGIN
					DROP TABLE ##TEMP_P_ORDER_ID 
				END
		</cfquery>
	</cftransaction>
</cflock>