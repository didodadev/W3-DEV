<cfsetting showdebugoutput="no">
<cfif isdefined('attributes.order_id') and len(attributes.order_id)>
	<cfset attributes.CRTROW =1>
</cfif> 
<cfquery name="get_basket" datasource="#dsn3#">
	SELECT AMOUNT_ROUND FROM SETUP_BASKET WHERE B_TYPE = 1 AND BASKET_ID = 4 ORDER BY BASKET_ID
</cfquery>
<cfset amount_round = get_basket.amount_round>
<cfquery name="get_cancel_types" datasource="#dsn3#">
	SELECT * FROM SETUP_INVOICE_CANCEL_TYPE ORDER BY INV_CANCEL_TYPE
</cfquery>
<cfquery name="GET_STOCKS_ORDER_DETAIL" datasource="#DSN3#">
	SELECT
		SUM(ORR.QUANTITY) AS QUANTITY,
		SUM(ORR.CANCEL_AMOUNT) AS CANCEL_AMOUNT,
		O.ORDER_NUMBER,
		O.ORDER_ID,
		O.COMPANY_ID,
		O.CONSUMER_ID,
		O.DELIVERDATE,
		O.PURCHASE_SALES,
		O.ORDER_ZONE,
		ORR.CANCEL_TYPE_ID,
		<cfif isdefined('attributes.spect_main_id') and attributes.spect_main_id gt 0>
		ORR.SPECT_VAR_ID,
		S.SPECT_MAIN_ID,
		ORR.ORDER_ROW_ID,
		</cfif>
		ORR.ORDER_ROW_CURRENCY,
		COMPANY.NICKNAME,
		ORR.STOCK_ID,
		ORR.PRODUCT_ID,
		<cfif isdefined('attributes.order_id') and len(attributes.order_id)>
		ORR.PRODUCT_NAME,
		STOCKS.STOCK_CODE,
		</cfif>
        ISNULL(ORR.WRK_ROW_ID,0) AS WRK_ROW_ID,
		ORR.ORDER_ROW_ID,
		ISNULL(O.IS_INSTALMENT,0) IS_INSTALMENT
	FROM 
		#dsn_alias#.COMPANY AS COMPANY,
		ORDERS O,
		ORDER_ROW ORR
		<cfif isdefined('attributes.order_id') and len(attributes.order_id)>
		,STOCKS
		</cfif>
		<cfif isdefined('attributes.spect_main_id') and attributes.spect_main_id gt 0>
		,SPECTS S
		</cfif>
	WHERE
    	O.ORDER_STATUS = 1 AND<!--- Aktif Siparişler Gelsin. --->
        (    
        	(
                RESERVED=1 AND 
                (
                    (PURCHASE_SALES = 1 and ORDER_ZONE = 0)  OR   
                    (PURCHASE_SALES = 0 and  ORDER_ZONE = 1 )
                )
            )
          OR
          	(
            	PURCHASE_SALES = 0 and  ORDER_ZONE = 0	
            )
            
        )  AND 
        ORR.RESERVE_TYPE <> <cfqueryparam cfsqltype="cf_sql_integer" value="-3">  AND
		COMPANY.COMPANY_ID = O.COMPANY_ID AND
		<cfif isdefined('attributes.dept_loc_info_') and len(attributes.dept_loc_info_)><!--- stok listesi xmlinde seciliyor, xml de secilmisse stok listesinde secilen depo bilgisine gore filtreleme yapılıyor. --->
			ISNULL(ORR.DELIVER_DEPT,O.DELIVER_DEPT_ID)=#listfirst(attributes.dept_loc_info_,'-')# AND
			<cfif listlen(attributes.dept_loc_info_,'-') eq 2>
				ISNULL(ORR.DELIVER_LOCATION,O.LOCATION_ID)=#listlast(attributes.dept_loc_info_,'-')# AND
			</cfif>
		</cfif>
		<cfif isdefined('attributes.x_show_all_order_row_types') and attributes.x_show_all_order_row_types eq 0><!--- stok listesi xmlinde seciliyor --->
			ORR.ORDER_ROW_CURRENCY NOT IN (-3,-8,-9,-10) AND <!--- kapatılmış, fazla teslimat ve iptal aşamasındaki sipariş satırları gelmesin--->
		<cfelse>
			ORR.ORDER_ROW_CURRENCY NOT IN (-3,-10) AND <!--- Kapatılan siparişler gelmesin. --->
		</cfif>
		O.ORDER_ID = ORR.ORDER_ID
		<cfif isdefined('attributes.order_id') and len(attributes.order_id)>
			AND	O.ORDER_ID = #attributes.order_id#
			AND STOCKS.STOCK_ID=ORR.STOCK_ID
		<cfelse>
			AND	ORR.STOCK_ID = #attributes.sid#
		</cfif>
		<cfif isdefined('attributes.spect_main_id') and attributes.spect_main_id gt 0>
		AND S.SPECT_MAIN_ID = #attributes.spect_main_id#
		AND S.SPECT_VAR_ID = ORR.SPECT_VAR_ID
		</cfif>
	GROUP BY 
		O.ORDER_NUMBER, 
		O.ORDER_ID, 
		O.COMPANY_ID, 
		O.CONSUMER_ID, 
		O.DELIVERDATE, 
		O.PURCHASE_SALES,
		<cfif isdefined('attributes.spect_main_id') and attributes.spect_main_id gt 0>
		ORR.SPECT_VAR_ID,S.SPECT_MAIN_ID,ORR.ORDER_ROW_ID,
		</cfif>
		O.ORDER_ZONE,
		ORR.ORDER_ROW_CURRENCY,
		ORR.STOCK_ID,
		ORR.PRODUCT_ID,
		ORR.CANCEL_TYPE_ID,
		<cfif isdefined('attributes.order_id') and len(attributes.order_id)>
		ORR.PRODUCT_NAME,
		STOCKS.STOCK_CODE,
		</cfif>
		ORR.WRK_ROW_ID,ORR.ORDER_ROW_ID,
		COMPANY.NICKNAME ,
		ISNULL(O.IS_INSTALMENT,0)
	UNION ALL
	SELECT
		SUM(ORR.QUANTITY) AS QUANTITY,
		SUM(ORR.CANCEL_AMOUNT) AS CANCEL_AMOUNT,
		O.ORDER_NUMBER,
		O.ORDER_ID,
		O.COMPANY_ID,
		O.CONSUMER_ID,
		O.DELIVERDATE,
		O.PURCHASE_SALES,
		O.ORDER_ZONE,
		ORR.CANCEL_TYPE_ID,
		<cfif isdefined('attributes.spect_main_id') and attributes.spect_main_id gt 0>
		ORR.SPECT_VAR_ID,
		S.SPECT_MAIN_ID,
		ORR.ORDER_ROW_ID,
		</cfif>
		ORR.ORDER_ROW_CURRENCY,
		CONSUMER.CONSUMER_NAME+' '+CONSUMER.CONSUMER_SURNAME NICKNAME,
		ORR.STOCK_ID,
		ORR.PRODUCT_ID,
		<cfif isdefined('attributes.order_id') and len(attributes.order_id)>
		ORR.PRODUCT_NAME,
		STOCKS.STOCK_CODE,
		</cfif>
        ISNULL(ORR.WRK_ROW_ID,0) AS WRK_ROW_ID,
		ORR.ORDER_ROW_ID,
		ISNULL(O.IS_INSTALMENT,0) IS_INSTALMENT
	FROM 
		#dsn_alias#.CONSUMER AS CONSUMER,
		ORDERS O,
		ORDER_ROW ORR
		<cfif isdefined('attributes.order_id') and len(attributes.order_id)>
		,STOCKS
		</cfif>
		<cfif isdefined('attributes.spect_main_id') and attributes.spect_main_id gt 0>
		,SPECTS S
		</cfif>
	WHERE
    	O.ORDER_STATUS = 1 AND<!--- Aktif Siparişler Gelsin. --->
        (    
        	(
                RESERVED=1 AND 
                (
                    (PURCHASE_SALES = 1 and ORDER_ZONE = 0)  OR   
                    (PURCHASE_SALES = 0 and  ORDER_ZONE = 1 )
                )
            )
          OR
          	(
            	PURCHASE_SALES = 0 and  ORDER_ZONE = 0	
            )
            
        )  AND
        ORR.RESERVE_TYPE <> <cfqueryparam cfsqltype="cf_sql_integer" value="-3"> AND
		CONSUMER.CONSUMER_ID = O.CONSUMER_ID AND
		<cfif isdefined('attributes.dept_loc_info_') and len(attributes.dept_loc_info_)><!--- stok listesi xmlinde seciliyor, xml de secilmisse stok listesinde secilen depo bilgisine gore filtreleme yapılıyor. --->
			ISNULL(ORR.DELIVER_DEPT,O.DELIVER_DEPT_ID)=#listfirst(attributes.dept_loc_info_,'-')# AND
			<cfif listlen(attributes.dept_loc_info_,'-') eq 2>
				ISNULL(ORR.DELIVER_LOCATION,O.LOCATION_ID)=#listlast(attributes.dept_loc_info_,'-')# AND
			</cfif>
		</cfif>
		<cfif isdefined('attributes.x_show_all_order_row_types') and attributes.x_show_all_order_row_types eq 0><!--- stok listesi xmlinde seciliyor --->
			ORR.ORDER_ROW_CURRENCY NOT IN (-3,-8,-9,-10) AND <!--- kapatılmış, fazla teslimat ve iptal aşamasındaki sipariş satırları gelmesin--->
		<cfelse>
			ORR.ORDER_ROW_CURRENCY NOT IN (-3,-10) AND <!--- Kapatılan siparişler gelmesin. --->
		</cfif>
		O.ORDER_ID = ORR.ORDER_ID
		<cfif isdefined('attributes.order_id') and len(attributes.order_id)>
			AND	O.ORDER_ID = #attributes.order_id#
			AND STOCKS.STOCK_ID=ORR.STOCK_ID
		<cfelse>
			AND	ORR.STOCK_ID = #attributes.sid#
		</cfif>
		<cfif isdefined('attributes.spect_main_id') and attributes.spect_main_id gt 0>
		AND S.SPECT_MAIN_ID = #attributes.spect_main_id#
		AND S.SPECT_VAR_ID = ORR.SPECT_VAR_ID
		</cfif>
	GROUP BY 
		O.ORDER_NUMBER, 
		O.ORDER_ID, 
		O.COMPANY_ID, 
		O.CONSUMER_ID, 
		O.DELIVERDATE, 
		O.PURCHASE_SALES,
		<cfif isdefined('attributes.spect_main_id') and attributes.spect_main_id gt 0>
		ORR.SPECT_VAR_ID,S.SPECT_MAIN_ID,ORR.ORDER_ROW_ID,
		</cfif>
		O.ORDER_ZONE,
		ORR.ORDER_ROW_CURRENCY,
		ORR.STOCK_ID,
		ORR.PRODUCT_ID,
		ORR.CANCEL_TYPE_ID,
		<cfif isdefined('attributes.order_id') and len(attributes.order_id)>
		ORR.PRODUCT_NAME,
		STOCKS.STOCK_CODE,
		</cfif>
		ORR.WRK_ROW_ID,ORR.ORDER_ROW_ID,
		CONSUMER.CONSUMER_NAME,
		CONSUMER.CONSUMER_SURNAME,
		ISNULL(O.IS_INSTALMENT,0)
	ORDER BY
		<cfif isdefined('attributes.order_id') and len(attributes.order_id)>
		ORR.ORDER_ROW_ID
		<cfelse>
    	PURCHASE_SALES ASC, ORDER_ZONE ASC, 
		DELIVERDATE 
		</cfif>
</cfquery>
<cfif GET_STOCKS_ORDER_DETAIL.recordcount>
	<cfset order_id_list = ValueList(GET_STOCKS_ORDER_DETAIL.ORDER_ID,',')>
	<cfset order_row_id_list = ValueList(GET_STOCKS_ORDER_DETAIL.ORDER_ROW_ID,',')>
	<cfquery name="GET_PRODUCTION_ORDERS_INFO" datasource="#DSN3#"><!--- üRETİME ÇELİEN SİPARİŞLER --->
		SELECT
			PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID,
			PRODUCTION_ORDERS_ROW.ORDER_ID,
			PRODUCTION_ORDERS_ROW.ORDER_ROW_ID,
			QUANTITY,
			P_ORDER_NO,
			IS_STAGE
		FROM  
			PRODUCTION_ORDERS_ROW,
			PRODUCTION_ORDERS
		WHERE
			PRODUCTION_ORDERS.P_ORDER_ID = PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID AND
			<cfif isdefined('attributes.sid') and len(attributes.sid)>
				PRODUCTION_ORDERS.STOCK_ID = #attributes.sid# AND <!--- Siapiş üretime çekildiğinde siparişteki ürün değiştirilmişse buraya gelmesin diye eklenmişti kaldırıldı,gerek olursa açılır. --->
			</cfif>
			PRODUCTION_ORDERS_ROW.ORDER_ID IN (#order_id_list#) AND
			PRODUCTION_ORDERS_ROW.ORDER_ROW_ID IN (#order_row_id_list#)
	</cfquery>
	<cfquery name="GET_ORDER_RESERVED_INFO" datasource="#DSN3#"><!--- REZERVE EDİLEN SİPARİŞLER -KALAN RESERVE MIKTARI- --->
		SELECT
			ORDER_ID,
			ISNULL(ORDER_WRK_ROW_ID,0) AS ORDER_WRK_ROW_ID,
			ROUND(SUM((ISNULL(RESERVE_STOCK_IN,0)-ISNULL(STOCK_IN,0))),#amount_round#) PURCHASE_REZERVE_EDILEN,
			ROUND(SUM((ISNULL(RESERVE_STOCK_OUT,0)-ISNULL(STOCK_OUT,0))),#amount_round#) SALES_REZERVE_EDILEN
			<cfif isdefined('attributes.spect_main_id') and attributes.spect_main_id gt 0>
				,S.SPECT_MAIN_ID,
				S.SPECT_VAR_ID
			</cfif>
		FROM
			ORDER_ROW_RESERVED
			<cfif isdefined('attributes.spect_main_id') and attributes.spect_main_id gt 0>
			,SPECTS S
			</cfif>
		WHERE
			ORDER_ID IN  (#order_id_list#)
			<cfif isdefined('attributes.sid') and len(attributes.sid)>
				AND ORDER_ROW_RESERVED.STOCK_ID = #attributes.sid#
			</cfif>
			<cfif isdefined('attributes.spect_main_id') and attributes.spect_main_id gt 0>
				AND S.SPECT_MAIN_ID = #attributes.spect_main_id#
				AND S.SPECT_VAR_ID = ORDER_ROW_RESERVED.SPECT_VAR_ID
			</cfif>
		GROUP BY 
			ORDER_ID,
			ISNULL(ORDER_WRK_ROW_ID,0)
		<cfif isdefined('attributes.spect_main_id') and attributes.spect_main_id gt 0>,S.SPECT_MAIN_ID,S.SPECT_VAR_ID</cfif><!--- ,(RESERVE_STOCK_OUT-STOCK_OUT),(RESERVE_STOCK_IN-STOCK_IN) --->
	</cfquery>
	<cfquery name="GET_ORDER_RESERVED_INFO2" datasource="#DSN3#"><!---SIPARIS ICIN RESERVE EDILMIS MIKTAR --->
		SELECT
			ORDER_ID,
			ISNULL(ORDER_WRK_ROW_ID,0) AS ORDER_WRK_ROW_ID,
			SUM(ISNULL(RESERVE_STOCK_IN,0)) AS PURCHASE_REZERVE_EDILMEMIS, 
			SUM(ISNULL(RESERVE_STOCK_OUT,0)) AS SALES_REZERVE_EDILMEMIS
			<cfif isdefined('attributes.spect_main_id') and attributes.spect_main_id gt 0>
				,S.SPECT_MAIN_ID,
				S.SPECT_VAR_ID
			</cfif>
		FROM
			ORDER_ROW_RESERVED
			<cfif isdefined('attributes.spect_main_id') and attributes.spect_main_id gt 0>
			,SPECTS S
			</cfif>
		WHERE
			ORDER_ID IN  (#order_id_list#)
			AND SHIP_ID IS NULL
			AND INVOICE_ID IS NULL
			<cfif isdefined('attributes.sid') and len(attributes.sid)>
				AND ORDER_ROW_RESERVED.STOCK_ID = #attributes.sid#
			</cfif>
			<cfif isdefined('attributes.spect_main_id') and attributes.spect_main_id gt 0>
				AND S.SPECT_MAIN_ID = #attributes.spect_main_id#
				AND S.SPECT_VAR_ID = ORDER_ROW_RESERVED.SPECT_VAR_ID
			</cfif>
		GROUP BY 
			ORDER_ID,
			ISNULL(ORDER_WRK_ROW_ID,0)
			<cfif isdefined('attributes.spect_main_id') and attributes.spect_main_id gt 0>,S.SPECT_MAIN_ID,S.SPECT_VAR_ID</cfif>
	</cfquery>
	<cfquery name="get_order_inv_periods" datasource="#dsn3#">
		SELECT DISTINCT PERIOD_ID FROM ORDERS_INVOICE WHERE ORDER_ID IN (#order_id_list#)
	</cfquery>
	<cfif get_order_inv_periods.recordcount>
		<cfset orders_ship_period_list = valuelist(get_order_inv_periods.PERIOD_ID)>
		<cfif listlen(orders_ship_period_list) eq 1 and orders_ship_period_list eq session.ep.period_id>
			<cfquery name="get_processed_amount" datasource="#DSN3#">
				SELECT
					SUM(IR.AMOUNT) AS SHIP_AMOUNT,
					IR.ORDER_ID,
					ISNULL(IR.WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID
				FROM
					#dsn2_alias#.INVOICE I,
					#dsn2_alias#.INVOICE_ROW IR
					<cfif isdefined('attributes.spect_main_id') and attributes.spect_main_id gt 0>
					,SPECTS S
					</cfif>
				WHERE
					I.INVOICE_ID=IR.INVOICE_ID
					AND IR.ORDER_ID IN (#order_id_list#)
					<cfif isdefined('attributes.sid') and len(attributes.sid)>
						AND IR.STOCK_ID = #attributes.sid#
					</cfif>
					<cfif isdefined('attributes.spect_main_id') and attributes.spect_main_id gt 0>
						AND S.SPECT_MAIN_ID = #attributes.spect_main_id#
						AND S.SPECT_VAR_ID = IR.SPECT_VAR_ID
					</cfif>
				GROUP BY
					IR.ORDER_ID,
					ISNULL(IR.WRK_ROW_RELATION_ID,0)
			</cfquery>
		<cfelse>
			<cfquery name="get_period_dsns" datasource="#DSN#">
				SELECT PERIOD_YEAR,OUR_COMPANY_ID,PERIOD_ID FROM SETUP_PERIOD WHERE PERIOD_ID IN (#orders_ship_period_list#)
			</cfquery>
			<cfquery name="get_processed_amount" datasource="#DSN2#">
				SELECT
					SUM(A1.SHIP_AMOUNT) AS SHIP_AMOUNT,
					A1.ORDER_ID,
					A1.WRK_ROW_RELATION_ID
				FROM
				(
				<cfloop query="get_period_dsns">
					SELECT
						SUM(IR.AMOUNT) AS SHIP_AMOUNT,
						IR.ORDER_ID,
						ISNULL(IR.WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID
					FROM
						#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.INVOICE I,
						#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.INVOICE_ROW IR
					WHERE
						I.INVOICE_ID=IR.INVOICE_ID
						AND IR.ORDER_ID IN (#order_id_list#)
						<cfif isdefined('attributes.sid') and len(attributes.sid)>
							AND IR.STOCK_ID = #attributes.sid#
						</cfif>
					GROUP BY
						IR.ORDER_ID,
						ISNULL(IR.WRK_ROW_RELATION_ID,0)
					<cfif currentrow neq get_period_dsns.recordcount> UNION ALL </cfif>					
				</cfloop> ) AS A1
					GROUP BY
						A1.ORDER_ID,
						A1.WRK_ROW_RELATION_ID
			</cfquery>
		</cfif>
	</cfif>
	<cfquery name="get_order_ship_periods" datasource="#dsn3#">
		SELECT DISTINCT PERIOD_ID FROM ORDERS_SHIP WHERE ORDER_ID IN (#order_id_list#)
	</cfquery>
	<cfif get_order_ship_periods.recordcount>
		<cfset orders_ship_period_list = valuelist(get_order_ship_periods.PERIOD_ID)>
		<cfif listlen(orders_ship_period_list) eq 1 and orders_ship_period_list eq session.ep.period_id>
			<cfquery name="get_processed_amount22" datasource="#dsn2#">
				SELECT
					SUM(SR.AMOUNT) AS SHIP_AMOUNT,
					SR.ROW_ORDER_ID AS ORDER_ID,
					ISNULL(SR.WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID
				FROM
					SHIP S,
					SHIP_ROW SR
					<cfif isdefined('attributes.spect_main_id') and attributes.spect_main_id gt 0>
					,#dsn3_alias#.SPECTS SP
					</cfif>
				WHERE
					S.SHIP_ID=SR.SHIP_ID
					AND SR.ROW_ORDER_ID IN (#order_id_list#)
					<cfif isdefined('attributes.sid') and len(attributes.sid)>
						AND SR.STOCK_ID = #attributes.sid#
					</cfif>
					<cfif isdefined('attributes.spect_main_id') and attributes.spect_main_id gt 0>
						AND SP.SPECT_MAIN_ID = #attributes.spect_main_id#
						AND SP.SPECT_VAR_ID = SR.SPECT_VAR_ID
					</cfif>
				GROUP BY
					SR.ROW_ORDER_ID,
					ISNULL(SR.WRK_ROW_RELATION_ID,0)
			</cfquery>
			<cfquery name="get_iade_amount" datasource="#dsn2#">
				SELECT
					SUM(SRR.AMOUNT) AS SHIP_AMOUNT,
					SR.ROW_ORDER_ID AS ORDER_ID,
					ISNULL(SR.WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID
				FROM
					SHIP S,
					SHIP_ROW SR,
					SHIP_ROW SRR
					<cfif isdefined('attributes.spect_main_id') and attributes.spect_main_id gt 0>
					,#dsn3_alias#.SPECTS SP
					</cfif>
				WHERE
					S.SHIP_ID=SR.SHIP_ID
					AND SR.ROW_ORDER_ID IN (#order_id_list#)
					AND SR.WRK_ROW_ID = SRR.WRK_ROW_RELATION_ID
					<cfif isdefined('attributes.sid') and len(attributes.sid)>
						AND SR.STOCK_ID = #attributes.sid#
					</cfif>
					<cfif isdefined('attributes.spect_main_id') and attributes.spect_main_id gt 0>
						AND SP.SPECT_MAIN_ID = #attributes.spect_main_id#
						AND SP.SPECT_VAR_ID = SR.SPECT_VAR_ID
					</cfif>
				GROUP BY
					SR.ROW_ORDER_ID,
					ISNULL(SR.WRK_ROW_RELATION_ID,0)
			</cfquery>
		<cfelse>
			<!--- 5. siparis farklı periyotlardaki irsaliyelerle iliskili --->
			<cfquery name="get_period_dsns" datasource="#dsn2#">
				SELECT PERIOD_YEAR,OUR_COMPANY_ID,PERIOD_ID FROM #dsn_alias#.SETUP_PERIOD WHERE PERIOD_ID IN (#orders_ship_period_list#)
			</cfquery>
			<cfquery name="get_processed_amount22" datasource="#dsn2#">
				SELECT
					SUM(A1.SHIP_AMOUNT) AS SHIP_AMOUNT,
					A1.ORDER_ID,
					A1.WRK_ROW_RELATION_ID
				FROM
				(
				<cfloop query="get_period_dsns">
					SELECT
						SUM(SR.AMOUNT) AS SHIP_AMOUNT,
						SR.ROW_ORDER_ID AS ORDER_ID,
						ISNULL(SR.WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID
					FROM
						#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP S,
						#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP_ROW SR
					WHERE
						S.SHIP_ID=SR.SHIP_ID
						AND SR.ROW_ORDER_ID IN (#order_id_list#)
						<cfif isdefined('attributes.sid') and len(attributes.sid)>
							AND SR.STOCK_ID = #attributes.sid#
						</cfif>
					GROUP BY
						SR.ROW_ORDER_ID,
						ISNULL(SR.WRK_ROW_RELATION_ID,0)
					<cfif currentrow neq get_period_dsns.recordcount> UNION ALL </cfif>					
				</cfloop> ) AS A1
					GROUP BY
						A1.ORDER_ID,
						A1.WRK_ROW_RELATION_ID
			</cfquery>
			<cfquery name="get_iade_amount" datasource="#dsn2#">
				SELECT
					SUM(A1.SHIP_AMOUNT) AS SHIP_AMOUNT,
					A1.ORDER_ID,
					A1.WRK_ROW_RELATION_ID
				FROM
				(
				<cfloop query="get_period_dsns">
					SELECT
						SUM(SRR.AMOUNT) AS SHIP_AMOUNT,
						SR.ROW_ORDER_ID AS ORDER_ID,
						ISNULL(SR.WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID
					FROM
						#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP S,
						#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP_ROW SR,
						#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP_ROW SRR
					WHERE
						S.SHIP_ID=SR.SHIP_ID
						AND SR.ROW_ORDER_ID IN (#order_id_list#)
						AND SR.WRK_ROW_ID = SRR.WRK_ROW_RELATION_ID
						<cfif isdefined('attributes.sid') and len(attributes.sid)>
							AND SR.STOCK_ID = #attributes.sid#
						</cfif>
					GROUP BY
						SR.ROW_ORDER_ID,
						ISNULL(SR.WRK_ROW_RELATION_ID,0)
					<cfif currentrow neq get_period_dsns.recordcount> UNION ALL </cfif>					
				</cfloop> ) AS A1
					GROUP BY
						A1.ORDER_ID,
						A1.WRK_ROW_RELATION_ID
			</cfquery>
		</cfif>
	<cfelseif not len(get_order_ship_periods.recordcount)>
		<cfset get_order_ship_periods.recordcount=0>
	</cfif>
	<cfoutput query="GET_ORDER_RESERVED_INFO"><!--- Siparişlerin miktarları hesaplanıyor --->
		<cfif isdefined('attributes.spect_main_id') and attributes.spect_main_id gt 0><!--- Spect bazında ise --->
			<cfset 'purchase_rezerve_edilen_#ORDER_ID#_#ORDER_WRK_ROW_ID#_#SPECT_VAR_ID#' = PURCHASE_REZERVE_EDILEN>
			<cfset 'sales_rezerve_edilen_#ORDER_ID#_#ORDER_WRK_ROW_ID#_#SPECT_VAR_ID#' = SALES_REZERVE_EDILEN>
		<cfelse><!--- Sipariş bazında ise --->
			<cfset 'purchase_rezerve_edilen_#ORDER_ID#_#ORDER_WRK_ROW_ID#' = PURCHASE_REZERVE_EDILEN>
			<cfset 'sales_rezerve_edilen_#ORDER_ID#_#ORDER_WRK_ROW_ID#' = SALES_REZERVE_EDILEN>
		</cfif>
	</cfoutput>
	<cfoutput query="GET_ORDER_RESERVED_INFO2"><!--- Siparişten rezerve edilmiş ancak fatura yada irsaliyeye çekilmemiş olanları döndürüyoruz. --->
		<cfif isdefined('attributes.spect_main_id') and attributes.spect_main_id gt 0><!--- Spect bazında ise --->
			<cfset 'purchase_rezerve_edilmemis_#ORDER_ID#_#ORDER_WRK_ROW_ID#_#SPECT_VAR_ID#' = PURCHASE_REZERVE_EDILMEMIS>
			<cfset 'sales_rezerve_edilmemis_#ORDER_ID#_#ORDER_WRK_ROW_ID#_#SPECT_VAR_ID#' = SALES_REZERVE_EDILMEMIS>
		<cfelse><!--- Sipariş bazında ise --->
			<cfset 'purchase_rezerve_edilmemis_#ORDER_ID#_#ORDER_WRK_ROW_ID#' = PURCHASE_REZERVE_EDILMEMIS>
			<cfset 'sales_rezerve_edilmemis_#ORDER_ID#_#ORDER_WRK_ROW_ID#' = SALES_REZERVE_EDILMEMIS>
		</cfif>
	</cfoutput>
	<cfoutput query="GET_PRODUCTION_ORDERS_INFO"><!--- Siparişten üretim emri verilenler hesaplanıyor. --->
		<cfset 'uretim_#ORDER_ID#_#ORDER_ROW_ID#' = '#QUANTITY#,#P_ORDER_NO#,#PRODUCTION_ORDER_ID#,#IS_STAGE#'>
	</cfoutput>
	<cfif isdefined('get_processed_amount') and get_processed_amount.recordcount neq 0>
		<cfoutput query="get_processed_amount">
			<cfset 'processed_amount_#ORDER_ID#_#WRK_ROW_RELATION_ID#' = SHIP_AMOUNT>
		</cfoutput>
	</cfif>
	<cfif isdefined('get_iade_amount') and get_iade_amount.recordcount neq 0>
		<cfoutput query="get_iade_amount">
			<cfset 'iade_amount_#ORDER_ID#_#WRK_ROW_RELATION_ID#' = SHIP_AMOUNT>
		</cfoutput>
	</cfif>
	<cfif isdefined('get_processed_amount22') and get_processed_amount22.recordcount neq 0>
		<cfoutput query="get_processed_amount22">
			<cfset 'processed_amount_#ORDER_ID#_#WRK_ROW_RELATION_ID#' = SHIP_AMOUNT>
		</cfoutput>
	</cfif>
</cfif>
<cfsavecontent  variable="variable"><cf_get_lang dictionary_id ='29825.Kaptaılmamış'> <cf_get_lang dictionary_id="31106.Siparişler">
</cfsavecontent>
<cf_seperator title="#variable#" id="unclose_orders#attributes.CRTROW#">
	<cf_grid_list id="unclose_orders#attributes.CRTROW#">
        <cfsavecontent variable="tr_info">
			<thead>
				<tr>
					<cfif isdefined('attributes.order_id') and len(attributes.order_id)>
						<cfset td_class_="form-title">
					<cfelse>
						<cfset td_class_="txtboldblue">
					</cfif>
					<cfoutput>
					<th><cf_get_lang dictionary_id='57487.no'></th>
					<th width="180"><cf_get_lang dictionary_id='57519.cari Hesap'></th>
					<th width="100"><cf_get_lang dictionary_id='57645.Teslim Tarihi'></th>
					<cfif isdefined('attributes.order_id') and len(attributes.order_id)>
						<th><cf_get_lang dictionary_id='57518.Stok kodu'></th>
						<th width="150"><cf_get_lang dictionary_id='57629.Açıklama'></th>
					</cfif>
					<th align="left"><cf_get_lang dictionary_id='57482.Aşama'></th>
					<th><cf_get_lang dictionary_id='57635.Miktar'></th>
					<th><cf_get_lang dictionary_id='58506.İptal'></th>
					<th><cf_get_lang dictionary_id='58825.İptal Nedeni'></th>
					<th><cf_get_lang dictionary_id='57456.Üretim'></th>
					<th><cf_get_lang dictionary_id='58048.Rezerve Edilen'></th>
					<th><cf_get_lang dictionary_id='29823.Sevkedilen'></th>
					<th><cf_get_lang dictionary_id='29418.İade'></th>
					<th><cf_get_lang dictionary_id='29824.Rezerve Edilecek'></th>
					<th width="20"><i class="fa fa-lock"></i></th>
					<th width="20"><i class="fa fa-unlock"></i></th>
					</cfoutput>
				</tr>
			</thead>
        </cfsavecontent>
        <tbody>
			<cfif GET_STOCKS_ORDER_DETAIL.recordcount>
                <form name="orders_reserve_detail" method="post" action="">
                    <cfscript>
                       /* genel_miktar_toplam =0;
                        genel_iade_toplam =0;
                        genel_uretim_toplam =0;
                        genel_rezerve_toplam =0;
                        genel_sevkedilen_toplam =0;
                        genel_kalan_toplam =0;*/
                        is_purchase_ok = 0;
                        is_sales_ok = 0;
                        miktar_toplam_ =0;
                        uretim_toplam_ =0;
                        rezerve_toplam_ =0;
                        sevkedilen_toplam_ =0;
                        iade_toplam_ =0;
                        kalan_toplam_ =0;
                    </cfscript>
                    <cfoutput query="GET_STOCKS_ORDER_DETAIL">
                        <cfset ORDER_ID = ORDER_ID >
                       
						<cfif PURCHASE_SALES eq 0 and  ORDER_ZONE eq 0 and is_purchase_ok  eq 0><!--- SatınAlma Siparişleri İse ve bu satır daha önce yazdırılmamış ise. --->
							#tr_info#
                            <cfif not (isdefined('attributes.order_id') and len(attributes.order_id) )>
                                <tr>
                                    <td colspan="14"><cf_get_lang dictionary_id="29825.Kapatılmamış"> <cf_get_lang dictionary_id="33507.Satın Alma Siparişler"></td>
                                </tr>
                            </cfif>
                           
                            <cfset is_purchase_ok = 1>
                        </cfif>
                        <cfif ((PURCHASE_SALES eq 1 and ORDER_ZONE eq 0) or (PURCHASE_SALES eq 0 and  ORDER_ZONE eq 1 )) and is_sales_ok eq 0><!--- SatınAlma Siparişleri İse ve bu satır daha önce yazdırılmamış ise. --->#tr_info#
                            <cfif not (isdefined('attributes.order_id') and len(attributes.order_id) )>
                                <tr>
                                    <td colspan="14"><cf_get_lang dictionary_id="29825.Kapatılmamış"> <cf_get_lang dictionary_id="58207.Satış Siparişler"></td>
                                </tr>
                            </cfif>
                            
                            <cfset is_sales_ok = 1>
                        </cfif>
                            <tr>
                                <td nowrap>
                                    <cfif is_instalment eq 0>
                                        <a href="#request.self#?fuseaction=<cfif ((PURCHASE_SALES eq 1 and ORDER_ZONE eq 0) or (PURCHASE_SALES eq 0 and  ORDER_ZONE eq 1 ))>sales<cfelse>purchase</cfif>.list_order&event=upd&order_id=#ORDER_ID#" class="tableyazi" target="blank_">#ORDER_NUMBER#</a>
                                    <cfelse>
                                        <a href="#request.self#?fuseaction=sales.list_order_instalment&event=upd&order_id=#ORDER_ID#" class="tableyazi" target="blank_">#ORDER_NUMBER#</a>
                                    </cfif>
                                </td>
                                <td>#NICKNAME#</td>
                                <td>#DateFormat(DELIVERDATE,dateformat_style)#</td>
                                    <cfif isdefined('attributes.order_id') and len(attributes.order_id)>
                                        <td>#STOCK_CODE#</td>
                                        <td>#PRODUCT_NAME#</td>
                                    </cfif>
                                <td>
                                    <cfswitch expression = "#ORDER_ROW_CURRENCY#">
                                        <cfcase value="-10"><cf_get_lang dictionary_id='29746.Kapatıldı'> (<cf_get_lang dictionary_id="58500.Manuel">)</cfcase>
                                        <cfcase value="-9"><cf_get_lang dictionary_id='58506.İptal'></cfcase>
                                        <cfcase value="-7"><cf_get_lang dictionary_id='29748.Eksik Teslimat'></cfcase>
                                        <cfcase value="-8"><cf_get_lang dictionary_id='29749.Fazla Teslimat'></cfcase>
                                        <cfcase value="-6"><cf_get_lang dictionary_id='58761.Sevk'></cfcase>
                                        <cfcase value="-5"><cf_get_lang dictionary_id='57456.Üretim'></cfcase>
                                        <cfcase value="-4"><cf_get_lang dictionary_id='29747.Kısmi Üretim'></cfcase>
                                        <cfcase value="-3"><cf_get_lang dictionary_id='29746.Kapatıldı'></cfcase>
                                        <cfcase value="-2"><cf_get_lang dictionary_id='29745.Tedarik'></cfcase>
                                        <cfcase value="-1"><cf_get_lang dictionary_id='58717.Açık'></cfcase>
                                    </cfswitch>
                                </td>
                                <input type="hidden" name="amount_round_" id="amount_round_" value="#amount_round#" />
                                <td style="text-align:right;">#TLFormat(QUANTITY,amount_round)#
                                <input name="row_amount_#attributes.crtrow#_#currentrow#" id="row_amount_#attributes.crtrow#_#currentrow#" type="hidden" class="text-right" value="#QUANTITY#">
                                    <cfif not ListFind("-8,-10",order_row_currency)>
                                      <!---  <cfset genel_miktar_toplam = genel_miktar_toplam + QUANTITY>--->
                                        <cfset miktar_toplam_ = miktar_toplam_ + QUANTITY>
                                    </cfif>
                                </td>
                                <td><input name="iptal_edilen_#attributes.crtrow#_#currentrow#" id="iptal_edilen_#attributes.crtrow#_#currentrow#" type="text" class="text-right" value="#TLFormat(CANCEL_AMOUNT,amount_round)#"></td>
                                <td><select name="cancel_type_id_#attributes.crtrow#_#currentrow#" id="cancel_type_id_#attributes.crtrow#_#currentrow#">
                                        <option value=""><cf_get_lang dictionary_id='58825.İptal Nedeni'></option>
                                        <cfloop query="get_cancel_types">
                                            <option value="#inv_cancel_type_id#" <cfif len(GET_STOCKS_ORDER_DETAIL.CANCEL_TYPE_ID) and GET_STOCKS_ORDER_DETAIL.CANCEL_TYPE_ID eq inv_cancel_type_id>selected</cfif>>#inv_cancel_type#</option>
                                        </cfloop>
                                    </select>
                                </td>
                                <td style="text-align:right;">
                                    <table width="100%">
                                        <tr>
                                            <cfif isdefined('uretim_#ORDER_ID#_#ORDER_ROW_ID#')>
                                                <td>#ListGetAt(Evaluate('uretim_#ORDER_ID#_#ORDER_ROW_ID#'),1,',')#
                                                    <cfif not ListFind("-8,-10",order_row_currency)>
                                                        <!---<cfset genel_uretim_toplam = genel_uretim_toplam + ListGetAt(Evaluate('uretim_#ORDER_ID#_#ORDER_ROW_ID#'),1,',')>--->
                                                        <cfset uretim_toplam_  = uretim_toplam_ + ListGetAt(Evaluate('uretim_#ORDER_ID#_#ORDER_ROW_ID#'),1,',')>
                                                    </cfif>
                                                </td>
                                                <td style="text-align:right;">
                                                    <cfif listlast(Evaluate('uretim_#ORDER_ID#_#ORDER_ROW_ID#')) neq -1>
                                                        <a href="#request.self#?fuseaction=prod.order&event=upd&upd=#ListGetAt(Evaluate('uretim_#ORDER_ID#_#ORDER_ROW_ID#'),3,',')#" class="tableyazi" target="blank_">#ListGetAt(Evaluate('uretim_#ORDER_ID#_#ORDER_ROW_ID#'),2,',')#</a></td>
                                                    <cfelse>
                                                        #ListGetAt(Evaluate('uretim_#ORDER_ID#_#ORDER_ROW_ID#'),2,',')#
                                                    </cfif>
                                                <cfelse>
                                                <td colspan="2">&nbsp;</td>
                                            </cfif>
                                        </tr>
                                    </table>
                                </td>	
                                <td style="text-align:right;">
                                    <cfif isdefined('attributes.spect_main_id') and attributes.spect_main_id gt 0><!--- Spect bazında bakılıyorsa satırlara göre spect toplamları alınacak --->
                                        <cfif PURCHASE_SALES eq 0 and ORDER_ZONE EQ 0>
                                            <cfif not isdefined('purchase_rezerve_edilen_#ORDER_ID#_#WRK_ROW_ID#_#SPECT_VAR_ID#')><cfset 'purchase_rezerve_edilen_#ORDER_ID#_#WRK_ROW_ID#_#SPECT_VAR_ID#' = 0></cfif>
                                            <cfset 'rezerve_edilen_#ORDER_ID#_#WRK_ROW_ID#' =  Evaluate('purchase_rezerve_edilen_#ORDER_ID#_#WRK_ROW_ID#_#SPECT_VAR_ID#')>
                                        <cfelse>
                                            <cfif not isdefined('sales_rezerve_edilen_#ORDER_ID#_#WRK_ROW_ID#_#SPECT_VAR_ID#')><cfset 'sales_rezerve_edilen_#ORDER_ID#_#WRK_ROW_ID#_#SPECT_VAR_ID#' = 0></cfif>
                                            <cfset 'rezerve_edilen_#ORDER_ID#_#WRK_ROW_ID#' =  Evaluate('sales_rezerve_edilen_#ORDER_ID#_#WRK_ROW_ID#_#SPECT_VAR_ID#')>
                                        </cfif>
                                    <cfelse><!--- Spect bazında değil ise sadece siparişe göre hesaplanıyor.--->
                                        <cfif PURCHASE_SALES eq 0 and ORDER_ZONE EQ 0>
                                            <cfif not isdefined('purchase_rezerve_edilen_#ORDER_ID#_#WRK_ROW_ID#')><cfset 'purchase_rezerve_edilen_#ORDER_ID#_#WRK_ROW_ID#' = 0></cfif>
                                            <cfset 'rezerve_edilen_#ORDER_ID#_#WRK_ROW_ID#' =  Evaluate('purchase_rezerve_edilen_#ORDER_ID#_#WRK_ROW_ID#')>
                                        <cfelse>
                                            <cfif not isdefined('sales_rezerve_edilen_#ORDER_ID#_#WRK_ROW_ID#')><cfset 'sales_rezerve_edilen_#ORDER_ID#_#WRK_ROW_ID#' = 0></cfif>
                                            <cfset 'rezerve_edilen_#ORDER_ID#_#WRK_ROW_ID#' =  Evaluate('sales_rezerve_edilen_#ORDER_ID#_#WRK_ROW_ID#')>
                                        </cfif>
                                    </cfif>
                                    <input name="rezerve_edilen_#attributes.crtrow#_#currentrow#" id="rezerve_edilen_#attributes.crtrow#_#currentrow#" readonly="yes" type="text" class="text-right" value="#TLFormat(Evaluate('rezerve_edilen_#ORDER_ID#_#WRK_ROW_ID#'),amount_round)#">
                                    <cfif not ListFind("-8,-10",order_row_currency)>
                                        <!---<cfset genel_rezerve_toplam =genel_rezerve_toplam + Evaluate('rezerve_edilen_#ORDER_ID#_#WRK_ROW_ID#')>--->
                                        <cfset rezerve_toplam_ = rezerve_toplam_ + Evaluate('rezerve_edilen_#ORDER_ID#_#WRK_ROW_ID#')>
                                    </cfif>
                                </td>
                                <td style="text-align:right;">
                                    <cfif not isdefined('processed_amount_#ORDER_ID#_#WRK_ROW_ID#')><cfset 'processed_amount_#ORDER_ID#_#WRK_ROW_ID#' = 0></cfif>
                                    <cfif not ListFind("-8,-10",order_row_currency)>
                                        <!---<cfset genel_sevkedilen_toplam = genel_sevkedilen_toplam + Evaluate('processed_amount_#ORDER_ID#_#WRK_ROW_ID#')>--->
                                        <cfset sevkedilen_toplam_  = sevkedilen_toplam_ + Evaluate('processed_amount_#ORDER_ID#_#WRK_ROW_ID#')>
                                    </cfif>
                                    <input name="processed_amount_#attributes.crtrow#_#currentrow#" id="processed_amount_#attributes.crtrow#_#currentrow#" type="hidden" value="#TLFormat(Evaluate('processed_amount_#ORDER_ID#_#WRK_ROW_ID#'),amount_round)#">
                                    #Tlformat(Evaluate('processed_amount_#ORDER_ID#_#WRK_ROW_ID#'),amount_round)#
                                </td>
                                <td style="text-align:right;">
                                    <cfif not isdefined('iade_amount_#ORDER_ID#_#WRK_ROW_ID#')><cfset 'iade_amount_#ORDER_ID#_#WRK_ROW_ID#' = 0></cfif>
                                   <!--- <cfset genel_iade_toplam = genel_iade_toplam + Evaluate('iade_amount_#ORDER_ID#_#WRK_ROW_ID#')>--->
                                    <cfset iade_toplam_  =iade_toplam_ + Evaluate('iade_amount_#ORDER_ID#_#WRK_ROW_ID#')>
                                    <input name="iade_amount_#attributes.crtrow#_#currentrow#" id="iade_amount_#attributes.crtrow#_#currentrow#" type="hidden" value="#TLFormat(Evaluate('iade_amount_#ORDER_ID#_#WRK_ROW_ID#'),amount_round)#">
                                    #Tlformat(Evaluate('iade_amount_#ORDER_ID#_#WRK_ROW_ID#'),amount_round)#
                                </td>
                                <td style="text-align:right;">
                                    <cfif isdefined('attributes.spect_main_id') and attributes.spect_main_id gt 0><!--- Spect bazında bakılıyorsa satırlara göre spect toplamları alınacak --->
                                        <cfif PURCHASE_SALES eq 0 and ORDER_ZONE EQ 0>
                                            <cfif not isdefined('purchase_rezerve_edilmemis_#ORDER_ID#_#WRK_ROW_ID#_#SPECT_VAR_ID#')><cfset 'purchase_rezerve_edilmemis_#ORDER_ID#_#WRK_ROW_ID#_#SPECT_VAR_ID#' = 0></cfif>
                                            <cfset 'rezerve_edilmemis_#ORDER_ID#_#WRK_ROW_ID#' =  #QUANTITY#-#Evaluate('purchase_rezerve_edilmemis_#ORDER_ID#_#WRK_ROW_ID#_#SPECT_VAR_ID#')#>
                                        <cfelse>
                                            <cfif not isdefined('sales_rezerve_edilmemis_#ORDER_ID#_#WRK_ROW_ID#_#SPECT_VAR_ID#')><cfset 'sales_rezerve_edilmemis_#ORDER_ID#_#WRK_ROW_ID#_#SPECT_VAR_ID#' = 0></cfif>
                                            <cfset 'rezerve_edilmemis_#ORDER_ID#_#WRK_ROW_ID#' =  #QUANTITY#-#Evaluate('sales_rezerve_edilmemis_#ORDER_ID#_#WRK_ROW_ID#_#SPECT_VAR_ID#')#>
                                        </cfif>
                                    <cfelse>
                                        <cfif PURCHASE_SALES eq 0 and ORDER_ZONE EQ 0>
                                            <cfif not isdefined('purchase_rezerve_edilmemis_#ORDER_ID#_#WRK_ROW_ID#')><cfset 'purchase_rezerve_edilmemis_#ORDER_ID#_#WRK_ROW_ID#' = 0></cfif>
                                            <cfset 'rezerve_edilmemis_#ORDER_ID#_#WRK_ROW_ID#' =  #QUANTITY#-#Evaluate('purchase_rezerve_edilmemis_#ORDER_ID#_#WRK_ROW_ID#')#>
                                        <cfelse>
                                            <cfif not isdefined('sales_rezerve_edilmemis_#ORDER_ID#_#WRK_ROW_ID#')><cfset 'sales_rezerve_edilmemis_#ORDER_ID#_#WRK_ROW_ID#' = 0></cfif>
                                            <cfset 'rezerve_edilmemis_#ORDER_ID#_#WRK_ROW_ID#' =  #QUANTITY#-#Evaluate('sales_rezerve_edilmemis_#ORDER_ID#_#WRK_ROW_ID#')#>
                                        </cfif>
                                    </cfif>
                                    <cfset 'kalan_#ORDER_ID#_#WRK_ROW_ID#' = Evaluate('rezerve_edilmemis_#ORDER_ID#_#WRK_ROW_ID#')>
                                    <input name="__kalan__#attributes.crtrow#_#currentrow#" id="__kalan__#attributes.crtrow#_#currentrow#" type="hidden" class="text-right" value="0"><!--- #Evaluate('kalan_#ORDER_ID#_#WRK_ROW_ID#')# --->
                                    <input name="kalan_#attributes.crtrow#_#currentrow#" id="kalan_#attributes.crtrow#_#currentrow#" type="text" class="text-right" value="#TLformat(0,amount_round)#"><!--- #Evaluate('kalan_#ORDER_ID#_#WRK_ROW_ID#')# --->
                                    <cfif not ListFind("-8,-10",order_row_currency)>
                                        <!---<cfset genel_kalan_toplam = genel_kalan_toplam + Evaluate('kalan_#ORDER_ID#_#WRK_ROW_ID#')>--->
                                        <cfset kalan_toplam_ = kalan_toplam_ + Evaluate('kalan_#ORDER_ID#_#WRK_ROW_ID#')>
                                    </cfif>
                                </td>
                                <td><cfif not listfindnocase(denied_pages,'objects.emptpopup_ajax_add_del_order_reserved')><a href="javascript://" onclick="connectAjax2('#attributes.crtrow#_#currentrow#','#ORDER_ID#','#PRODUCT_ID#','#STOCK_ID#','<cfif isdefined('attributes.spect_main_id') and attributes.spect_main_id gt 0>#GET_STOCKS_ORDER_DETAIL.SPECT_VAR_ID#<cfelse>0</cfif>','3','#PURCHASE_SALES#','#WRK_ROW_ID#','add')"><i class="fa fa-lock" title="<cf_get_lang dictionary_id='36957.Rezerve Et'>"></i></a></cfif></td>
                                <td><cfif not listfindnocase(denied_pages,'objects.emptpopup_ajax_add_del_order_reserved')><a href="javascript://" onclick="connectAjax2('#attributes.crtrow#_#currentrow#','#ORDER_ID#','#PRODUCT_ID#','#STOCK_ID#','<cfif isdefined('attributes.spect_main_id') and attributes.spect_main_id gt 0>#GET_STOCKS_ORDER_DETAIL.SPECT_VAR_ID#<cfelse>0</cfif>','3','#PURCHASE_SALES#','#WRK_ROW_ID#','del')"><i class="fa fa-unlock" title="Rezerve Çöz-İptal"></i><div align="left" id="_detailss_#attributes.crtrow#_#currentrow#"></div></a></cfif></td>
                            </tr>
                            <cfif (is_purchase_ok eq 1 and is_sales_ok eq 0 and  ((PURCHASE_SALES[currentrow+1] eq 1 and ORDER_ZONE[currentrow+1] eq 0) or (PURCHASE_SALES[currentrow+1] eq 0 and  ORDER_ZONE[currentrow+1] eq 1 ))) or currentrow eq get_stocks_order_detail.recordcount>
                                <tr class="txtbold">
                                    <td colspan="<cfif isdefined('attributes.order_id') and len(attributes.order_id)>8<cfelse>4</cfif>"><cf_get_lang dictionary_id='57492.Toplam'></td>
                                    <td style="text-align:right;">#TLFormat(miktar_toplam_,amount_round)#</td>
                                    <td style="text-align:right;">#TLFormat(uretim_toplam_,amount_round)#</td>
                                    <td style="text-align:right;" colspan="<cfif isdefined('attributes.order_id') and len(attributes.order_id)>0<cfelse>3</cfif>">#TLFormat(rezerve_toplam_,amount_round)#</td>
                                    <td style="text-align:right;">#TLFormat(sevkedilen_toplam_,amount_round)#</td>
                                    <td style="text-align:right;">#TLFormat(iade_toplam_,amount_round)#</td>
                                    <td style="text-align:right;"><!--- #kalan_toplam_# ---></td>
                                    <td colspan="2"></td>
                                </tr>
                                <cfscript>
                                    miktar_toplam_=0;
                                    uretim_toplam_=0;
                                    rezerve_toplam_=0;
                                    sevkedilen_toplam_=0;
                                    kalan_toplam_=0;
                                </cfscript>
                            </cfif>
                        </cfoutput>
                    <!---<cfif not (isdefined('attributes.order_id') and len(attributes.order_id) )>
                        <tr class="txtbold">
                            <td colspan="<cfif isdefined('attributes.order_id') and len(attributes.order_id)>8<cfelse>4</cfif>"><cf_get_lang_main no='268.Genel Toplam'></td>
                            <cfoutput>
                            <!---<td style="text-align:right;">#TLFormat(genel_miktar_toplam,amount_round)#</td>--->
                            <!---<td style="text-align:right;">#TLFormat(genel_uretim_toplam,amount_round)#</td>--->
                            <!---<td style="text-align:right;" colspan="<cfif isdefined('attributes.order_id') and len(attributes.order_id)>0<cfelse>3</cfif>">#TLFormat(genel_rezerve_toplam,amount_round)#</td>--->
                            <!---<td style="text-align:right;">#TLFormat(genel_sevkedilen_toplam,amount_round)#</td>--->
                            <!---<td style="text-align:right;">#TLFormat(genel_iade_toplam,amount_round)#</td>--->
                            <td style="text-align:right;"><!--- #genel_kalan_toplam# ---></td>
                            <td colspan="2"></td>
                            </cfoutput>
                        </tr>
                    </cfif>--->
                </form>
            </cfif>
        </tbody>
	</cf_grid_list>
<script type="text/javascript">
	function connectAjax2(crnt_row,r_order_id,r_product_id,r_stock_id,r_spect_id,is_order_process,is_purchase_sales,wrk_row_id,type)
	{
		var _amount_round_ = document.getElementById("amount_round_").value;
		document.getElementById('_detailss_'+crnt_row+'').style.display ='';
		if(eval("document.getElementById('iptal_edilen_" + crnt_row + "')").value!= '')
			var cancel_amount_ = filterNum(eval("document.getElementById('iptal_edilen_" + crnt_row + "')").value,_amount_round_);
		else
			var cancel_amount_='';
		if(eval("document.getElementById('processed_amount_" + crnt_row + "')").value!= '')
			var pro_amount_ = filterNum(eval("document.getElementById('processed_amount_"+crnt_row + "')").value,_amount_round_);
		else
			var pro_amount_='';
		if(eval("document.getElementById('iade_amount_" + crnt_row + "')").value!= '')
			var iade_amount_ = filterNum(eval("document.getElementById('iade_amount_"+crnt_row + "')").value,_amount_round_);
		else
			var iade_amount_='';
			
			
		var kalan_amount_ = parseFloat(filterNum(eval("document.getElementById('row_amount_"+crnt_row+"')").value,_amount_round_)) - parseFloat(pro_amount_) + parseFloat(iade_amount_);
		if(wrk_round(kalan_amount_) < parseFloat(cancel_amount_))
		{ 
			alert("<cf_get_lang dictionary_id='60013.İptal Miktarı Sipariş Kalan Miktarından Fazla Olamaz'>!");
			return false;
		}
		
		cancel_type_name_=eval("document.getElementById('cancel_type_id_"+crnt_row+"')");
		if(cancel_type_name_.options[cancel_type_name_.selectedIndex].value!='')
			var cancel_type_=cancel_type_name_.options[cancel_type_name_.selectedIndex].value;
		else
			var cancel_type_='';
		if(cancel_amount_ >0 && cancel_type_=='')
		{
			alert("<cf_get_lang dictionary_id='58825.İptal Nedeni'> <cf_get_lang dictionary_id='57734.Seçiniz'>!");
			return false;
		}
		if(cancel_amount_ == 0 || cancel_amount_ =='') //iptal degeri sıfır veya bos ise iptal nedeni gonderilmez
			cancel_type_='';
		var r_amount = filterNum(eval("document.getElementById('kalan_" + crnt_row + "')").value,_amount_round_); //rezerve bölümü
		if(r_spect_id == undefined)
			var r_spect_id = "";
		if (r_amount > 0 || cancel_amount_ !='')
		{	
			var cc = '<cfoutput>#request.self#?fuseaction=objects.emptpopup_ajax_add_del_order_reserved</cfoutput>&wrk_row_id='+wrk_row_id+'&crnt_row='+crnt_row+'&r_order_id='+r_order_id+'&r_product_id='+r_product_id+'&r_stock_id='+r_stock_id+'&r_spect_id='+r_spect_id+'&is_order_process='+is_order_process+'&is_purchase_sales='+is_purchase_sales+'&page_type=1&r_amount='+r_amount+'&c_amount='+cancel_amount_+'&pro_amount_='+pro_amount_+'&type='+type+'&cancel_type_='+cancel_type_;
			///eval("document.all.kalan_"+crnt_row).value=cc;
			AjaxPageLoad(cc,'_detailss_'+crnt_row,1);
		//	windowopen(cc,'_detailss_'+crnt_row);
		}
		else
			alert("<cf_get_lang dictionary_id='60014.Rezerve Edilicek Miktar 0 dan Büyük Olmalıdır.'>");
	}
</script>
