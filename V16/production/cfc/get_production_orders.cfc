<cffunction displayname="Üretim Emirleri ve Ürün Bilgileri" name="get_production_orders_fnc" returntype="query">
	<cfargument name="keyword" default="" displayname="Üretim No,Sipariş No veya Seri Noya Göre Arama Yapıyor">
    <cfargument name="station_id" default="">
    <cfargument name="production_stage" default="">
    <cfargument name="product_code_2" default="">
    <cfargument name="p_order_no" default="">
    <cfargument name="order_number" default="">
    <cfargument name="serial_no" default="">
    <cfargument name="spect" default="">
    <cfargument name="order_type" default="">
    <cfargument name="xml_show_related_p_order_state" default="">
	<cfquery name="GET_PO" datasource="#this.DSN3#">
		SELECT
			PRODUCTION_ORDERS.IS_GROUP_LOT,
			PRODUCTION_ORDERS.P_ORDER_ID,
			PRODUCTION_ORDERS.RECORD_DATE,
			PRODUCTION_ORDERS.START_DATE,
			PRODUCTION_ORDERS.FINISH_DATE,
			PRODUCTION_ORDERS.P_ORDER_NO,
			PRODUCTION_ORDERS.STOCK_ID,
			PRODUCTION_ORDERS.QUANTITY,
			PRODUCTION_ORDERS.STATION_ID,
			PRODUCTION_ORDERS.PROD_ORDER_STAGE,
			PRODUCTION_ORDERS.IS_STAGE,
			PRODUCTION_ORDERS.LOT_NO,
			PRODUCTION_ORDERS.DETAIL,
			STOCKS.PRODUCT_NAME,
			STOCKS.PRODUCT_ID,
			STOCKS.PROPERTY,
			STOCKS.STOCK_CODE,
            STOCKS.PRODUCT_CODE_2,
            STOCKS.STOCK_CODE_2,
			PRODUCTION_ORDERS.REFERENCE_NO,
			PRODUCTION_ORDERS.SPECT_VAR_ID,
			PRODUCTION_ORDERS.SPECT_VAR_NAME,
			PRODUCTION_ORDERS.SPEC_MAIN_ID,
			PRODUCTION_ORDERS.DEMAND_NO,
			PRODUCTION_ORDERS.PROJECT_ID,
			STOCKS.PRODUCT_CATID,
			ISNULL((SELECT
						SUM(POR_.AMOUNT) ORDER_AMOUNT
					FROM
						PRODUCTION_ORDER_RESULTS_ROW POR_,
						PRODUCTION_ORDER_RESULTS POO
					WHERE
						POR_.PR_ORDER_ID = POO.PR_ORDER_ID
						AND POO.P_ORDER_ID = PRODUCTION_ORDERS.P_ORDER_ID
						AND POR_.TYPE = 1
						AND POO.IS_STOCK_FIS = 1
					),0) ROW_RESULT_AMOUNT,
			PU.MAIN_UNIT,
            WORKSTATIONS.STATION_NAME,
            ORDERS.ORDER_NUMBER,
            COMPANY.NICKNAME COMPANY_NAME,
            PO.P_ORDER_NO PO_RELATED_NO,
            PRODUCTION_ORDERS.PO_RELATED_ID
            <cfif xml_show_related_p_order_state eq 1>
                ,ISNULL((
                    SELECT
                        SUM(RAMOUNT)
                    FROM
                        (SELECT
                            (PO2.QUANTITY - ISNULL(SUM(PORR.AMOUNT),0)) RAMOUNT
                            ,PO2.P_ORDER_ID
                        FROM 
                            PRODUCTION_ORDERS PO2
                            LEFT JOIN PRODUCTION_ORDER_RESULTS POR ON PO2.P_ORDER_ID = POR.P_ORDER_ID AND POR.IS_STOCK_FIS = 1
                            LEFT JOIN PRODUCTION_ORDER_RESULTS_ROW PORR ON POR.PR_ORDER_ID = PORR.PR_ORDER_ID AND PORR.TYPE = 1
                        WHERE PO2.PO_RELATED_ID = PRODUCTION_ORDERS.P_ORDER_ID
                        GROUP BY 
                            PO2.QUANTITY
                            ,PO2.P_ORDER_ID) T1
                    ),-1) RELATED_AMOUNT
            </cfif>
		FROM
			PRODUCTION_ORDERS
            LEFT JOIN PRODUCTION_ORDERS PO ON PO.P_ORDER_ID = PRODUCTION_ORDERS.PO_RELATED_ID
            LEFT JOIN WORKSTATIONS ON WORKSTATIONS.STATION_ID = PRODUCTION_ORDERS.STATION_ID
            LEFT JOIN PRODUCTION_ORDERS_ROW ON PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID = PRODUCTION_ORDERS.P_ORDER_ID
            LEFT JOIN ORDERS ON PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID
            LEFT JOIN #this.dsn_alias#.COMPANY ON COMPANY.COMPANY_ID = ORDERS.COMPANY_ID,
			STOCKS,
			PRODUCT_UNIT PU
		WHERE
			PU.PRODUCT_UNIT_ID=STOCKS.PRODUCT_UNIT_ID AND
			PRODUCTION_ORDERS.STOCK_ID = STOCKS.STOCK_ID AND
			PRODUCTION_ORDERS.STATUS = 1
			AND PRODUCTION_ORDERS.P_ORDER_ID IN(
												SELECT 
													PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID
												FROM
													PRODUCTION_ORDERS_ROW
												WHERE
													PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID = PRODUCTION_ORDERS.P_ORDER_ID
											)
			 <cfif not isdefined("arguments.production_stage") or not listlen(arguments.production_stage)>
                AND PRODUCTION_ORDERS.IS_STAGE <> <cfqueryparam cfsqltype="cf_sql_integer" value="-1">
            <cfelse>
                AND PRODUCTION_ORDERS.IS_STAGE IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.production_stage#" list="yes">)
            </cfif>
			<cfif len(station_id) and station_id neq 0>
            	AND PRODUCTION_ORDERS.STATION_ID = #station_id#
            <cfelseif len(station_id) and station_id eq 0>
                 AND PRODUCTION_ORDERS.STATION_ID IS NULL
            </cfif>
            <cfif isdefined('arguments.product_code_2') and len(arguments.product_code_2)>
            	AND STOCKS.PRODUCT_CODE_2 LIKE '<cfif len(product_code_2) gt 2>%</cfif>#product_code_2#%'
            </cfif>
            <cfif len(arguments.p_order_no) and not len(arguments.order_number) and not len(arguments.serial_no)>
                AND PRODUCTION_ORDERS.P_ORDER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.p_order_no#%">
            </cfif>
            <cfif len(arguments.order_number) or len(arguments.serial_no)>
            	AND 
                (
                	<cfif len(arguments.p_order_no)>
                    PRODUCTION_ORDERS.P_ORDER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.p_order_no#%"> OR
                    </cfif>
                        (PRODUCTION_ORDERS.P_ORDER_ID IN 
                            (
                              <cfif len(arguments.order_number)>
                                    SELECT 
                                        PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID P_ORDER_ID
                                    FROM
                                        PRODUCTION_ORDERS_ROW,
                                        ORDERS
                                    WHERE
                                        ORDERS.ORDER_NUMBER LIKE  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.order_number#%"> AND 
                                        PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID
                               </cfif>
                               <cfif len(arguments.order_number) and len(arguments.serial_no) >
                                    UNION ALL
                               </cfif>
                               <cfif len(arguments.serial_no)>
                                    SELECT 
                                        SERVICE_GUARANTY_NEW.PROCESS_ID P_ORDER_ID
                                    FROM
                                        SERVICE_GUARANTY_NEW
                                    WHERE
                                        SERVICE_GUARANTY_NEW.PROCESS_CAT = 1194 AND
                                        SERVICE_GUARANTY_NEW.SERIAL_NO LIKE  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.serial_no#%">
                               </cfif>
                            )
                        )
                  )
            </cfif>
			<cfif isdefined('arguments.spect') and len(arguments.spect)>
                AND PRODUCTION_ORDERS.SPECT_VAR_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.spect#%">
            </cfif>
		UNION ALL
			SELECT
			PRODUCTION_ORDERS.IS_GROUP_LOT,
			PRODUCTION_ORDERS.P_ORDER_ID,
			PRODUCTION_ORDERS.RECORD_DATE,
			PRODUCTION_ORDERS.START_DATE,
			PRODUCTION_ORDERS.FINISH_DATE,
			PRODUCTION_ORDERS.P_ORDER_NO,
			PRODUCTION_ORDERS.STOCK_ID,
			PRODUCTION_ORDERS.QUANTITY,
			PRODUCTION_ORDERS.STATION_ID,
			PRODUCTION_ORDERS.PROD_ORDER_STAGE,
			PRODUCTION_ORDERS.IS_STAGE,
			PRODUCTION_ORDERS.LOT_NO,
			PRODUCTION_ORDERS.DETAIL,
			STOCKS.PRODUCT_NAME,
			STOCKS.PRODUCT_ID,
			STOCKS.PROPERTY,
			STOCKS.STOCK_CODE,
            STOCKS.PRODUCT_CODE_2,
            STOCKS.STOCK_CODE_2,
			PRODUCTION_ORDERS.REFERENCE_NO,
			PRODUCTION_ORDERS.SPECT_VAR_ID,
			PRODUCTION_ORDERS.SPECT_VAR_NAME,
			PRODUCTION_ORDERS.SPEC_MAIN_ID,
			PRODUCTION_ORDERS.DEMAND_NO,
			PRODUCTION_ORDERS.PROJECT_ID,
			STOCKS.PRODUCT_CATID,
			ISNULL((SELECT
						SUM(POR_.AMOUNT) ORDER_AMOUNT
					FROM
						PRODUCTION_ORDER_RESULTS_ROW POR_,
						PRODUCTION_ORDER_RESULTS POO
					WHERE
						POR_.PR_ORDER_ID = POO.PR_ORDER_ID
						AND POO.P_ORDER_ID = PRODUCTION_ORDERS.P_ORDER_ID
						AND POR_.TYPE = 1
						AND POO.IS_STOCK_FIS = 1
					),0) ROW_RESULT_AMOUNT,
			PU.MAIN_UNIT,
            WORKSTATIONS.STATION_NAME,
            ORDERS.ORDER_NUMBER,
            COMPANY.NICKNAME COMPANY_NAME,
            PO.P_ORDER_NO PO_RELATED_NO,
            PRODUCTION_ORDERS.PO_RELATED_ID
            <cfif xml_show_related_p_order_state eq 1>
                ,ISNULL((
                    SELECT
                        SUM(RAMOUNT)
                    FROM
                        (SELECT
                            (PO2.QUANTITY - ISNULL(SUM(PORR.AMOUNT),0)) RAMOUNT
                            	,PO2.P_ORDER_ID
                        FROM 
                            PRODUCTION_ORDERS PO2
                            LEFT JOIN PRODUCTION_ORDER_RESULTS POR ON PO2.P_ORDER_ID = POR.P_ORDER_ID AND POR.IS_STOCK_FIS = 1
                            LEFT JOIN PRODUCTION_ORDER_RESULTS_ROW PORR ON POR.PR_ORDER_ID = PORR.PR_ORDER_ID AND PORR.TYPE = 1
                        WHERE PO2.PO_RELATED_ID = PRODUCTION_ORDERS.P_ORDER_ID
                        GROUP BY 
                            PO2.QUANTITY
                            ,PO2.P_ORDER_ID
                            ) T1
                    ),-1) RELATED_AMOUNT
            </cfif>
		FROM
			PRODUCTION_ORDERS
            LEFT JOIN PRODUCTION_ORDERS PO ON PO.P_ORDER_ID = PRODUCTION_ORDERS.PO_RELATED_ID
            LEFT JOIN WORKSTATIONS ON WORKSTATIONS.STATION_ID = PRODUCTION_ORDERS.STATION_ID
            LEFT JOIN PRODUCTION_ORDERS_ROW ON PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID = PRODUCTION_ORDERS.P_ORDER_ID
            LEFT JOIN ORDERS ON PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID
            LEFT JOIN #this.dsn_alias#.COMPANY ON COMPANY.COMPANY_ID = ORDERS.COMPANY_ID 
            ,
			STOCKS,
			PRODUCT_UNIT PU
		WHERE
			PU.PRODUCT_UNIT_ID=STOCKS.PRODUCT_UNIT_ID AND
			PRODUCTION_ORDERS.STOCK_ID = STOCKS.STOCK_ID AND
			PRODUCTION_ORDERS.STATUS = 1
			AND PRODUCTION_ORDERS.P_ORDER_ID NOT IN(
												SELECT 
													PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID
												FROM
													PRODUCTION_ORDERS_ROW
												WHERE
													PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID = PRODUCTION_ORDERS.P_ORDER_ID
											)
            <cfif not isdefined("arguments.production_stage") or not listlen(arguments.production_stage)>
                AND PRODUCTION_ORDERS.IS_STAGE <> <cfqueryparam cfsqltype="cf_sql_integer" value="-1">
            <cfelse>
                AND PRODUCTION_ORDERS.IS_STAGE IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.production_stage#" list="yes">)
            </cfif>
			<cfif len(station_id) and station_id neq 0>
            	AND PRODUCTION_ORDERS.STATION_ID = #station_id#
            <cfelseif len(station_id) and station_id eq 0>
                AND PRODUCTION_ORDERS.STATION_ID IS NULL
            </cfif>
            <cfif isdefined('arguments.product_code_2') and len(arguments.product_code_2)>
            	AND STOCKS.PRODUCT_CODE_2 LIKE '<cfif len(product_code_2) gt 2>%</cfif>#product_code_2#%'
            </cfif>
            <cfif len(arguments.p_order_no) and not len(arguments.order_number) and not len(arguments.serial_no)>
                AND PRODUCTION_ORDERS.P_ORDER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.p_order_no#%">
            </cfif>
            <cfif len(arguments.order_number) or len(arguments.serial_no)>
            	AND 
                (
                	<cfif len(arguments.p_order_no)>
                    PRODUCTION_ORDERS.P_ORDER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.p_order_no#%"> OR
                    </cfif>
                    (PRODUCTION_ORDERS.P_ORDER_ID IN 
                        (
                            <cfif len(arguments.order_number)>
                                SELECT 
                                    PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID P_ORDER_ID
                                FROM
                                    PRODUCTION_ORDERS_ROW,
                                    ORDERS
                                WHERE
                                    ORDERS.ORDER_NUMBER LIKE  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.order_number#%"> AND 
                                    PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID
                           </cfif>
                           <cfif len(arguments.order_number) and len(arguments.serial_no) >
                                UNION ALL
                           </cfif>
                           <cfif len(arguments.serial_no)>
                                SELECT 
                                    SERVICE_GUARANTY_NEW.PROCESS_ID P_ORDER_ID
                                FROM
                                    SERVICE_GUARANTY_NEW
                                WHERE
                                    SERVICE_GUARANTY_NEW.PROCESS_CAT = 1194 AND
                                    SERVICE_GUARANTY_NEW.SERIAL_NO LIKE  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.serial_no#%">
                           </cfif>
                        )
                    )
               )
               </cfif>
            <cfif isdefined('arguments.spect') and len(arguments.spect)>
                AND PRODUCTION_ORDERS.SPECT_VAR_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.spect#%">
            </cfif>
	 </cfquery>
	 
	 <cfreturn GET_PO>
</cffunction>

<cffunction name="get_production_orders_fnc2" returntype="query" displayname="Yetkili Olunan İstasyonlara Göre Üretim Emirlerini Listeler">
	<cfargument name="authority_station_id_list" default="" displayname="yetkili olunan istasyon id listesi">
	<cfargument name="startrow" default="">
	<cfargument name="maxrows" default="">
	<cfargument name="start_date" default="" displayname="Üretim Emri Kayıt Tarihine Bakıyor">
	<cfargument name="finish_date" default="" displayname="Üretim Emri Kayıt Tarihine Bakıyor">
	<cfargument name="nullStation" default="" displayname="İstasyonsuz Emirlerde Gelsin">
    <cfargument name="xml_show_related_p_order_state" default="">
	<cfquery name="GET_PO_DET" dbtype="query">
		SELECT 
			*
		FROM
			GET_PO
		WHERE
			P_ORDER_ID IS NOT NULL
			<cfif len(arguments.authority_station_id_list)>
				AND (STATION_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.authority_station_id_list#" list="yes">) <cfif arguments.nullStation eq 1>OR STATION_ID IS NULL</cfif>)
			<cfelse>
				AND 1 = 0
			</cfif>
            <cfif xml_show_related_p_order_state eq 1>
             	AND RELATED_AMOUNT <= 0
            </cfif>
			<cfif len(arguments.start_date)>
				AND START_DATE >= #arguments.start_date#
			 </cfif>
			 <cfif len(arguments.finish_date)>
				AND START_DATE < #DATEADD('d',1,arguments.finish_date)#
			 </cfif>
		ORDER BY
            <cfif isDefined('arguments.order_type') and arguments.order_type eq 1>
                START_DATE ASC
            <cfelseif isDefined('arguments.order_type') and arguments.order_type eq 2>
                START_DATE DESC
            <cfelseif isDefined('arguments.order_type') and arguments.order_type eq 5>
                COMPANY_NAME ASC
            <cfelseif isDefined('arguments.order_type') and arguments.order_type eq 6>
                COMPANY_NAME DESC
            <cfelseif isDefined('arguments.order_type') and arguments.order_type eq 3>
                STATION_NAME ASC
            <cfelseif isDefined('arguments.order_type') and arguments.order_type eq 4>
                STATION_NAME DESC
            <cfelse>
                START_DATE
            </cfif>
	</cfquery>
	<cfreturn GET_PO_DET>
</cffunction>
