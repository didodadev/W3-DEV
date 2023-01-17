<cfcomponent>
	<cffunction name="get_prod_order_fnc" returntype="query">
		<cfargument name="product_id" default="">
        <cfargument name="product_name" default="">
        <cfargument name="related_product_id" default="">
		<cfargument name="related_stock_id" default="">
		<cfargument name="related_product_name" default="">
		<cfargument name="production_stage" default="">
		<cfargument name="position_code" default="">
		<cfargument name="position_name" default="">
		<cfargument name="product_cat" default="">
        <cfargument name="product_cat_code" default="">
		<cfargument name="product_catid" default="">
		<cfargument name="spect_main_id" default="">
		<cfargument name="spect_name" default="">
		<cfargument name="short_code_id" default="">
		<cfargument name="short_code_name" default="">
		<cfargument name="keyword" default="">
		<cfargument name="result" default="">
		<cfargument name="sales_partner" default="">
		<cfargument name="sales_partner_id" default="">
		<cfargument name="order_employee" default="">
		<cfargument name="order_employee_id" default="">
		<cfargument name="project_head" default="">
		<cfargument name="project_id" default="">
		<cfargument name="member_type" default="">
		<cfargument name="member_name" default="">
		<cfargument name="company_id" default="">
		<cfargument name="consumer_id" default="">
		<cfargument name="status" default="">
		<cfargument name="fuseaction_" default="">
		<cfargument name="is_show_result_amount" default="">
		<cfargument name="operation_type_id" default="">
		<cfargument name="operation_type" default="">
		<cfargument name="station_id" default="">
		<cfargument name="authority_station_id_list" default="">
		<cfargument name="related_orders" default="">
		<cfargument name="station_list" default="">
        <cfargument name="startrow" default="">
        <cfargument name="maxrows" default="">
        <cfargument name="start_date" default="">
		<cfargument name="start_date_2" default="">
		<cfargument name="finish_date" default="">
		<cfargument name="finish_date_2" default="">
		<cfargument name="prod_order_stage" default="">
		<cfargument name="oby" default="">
        <cfargument name="P_ORDER_NO1" default="">
        <cfargument name="DEMAND_NO1" default="">
        <cfargument name="LOT_NO1" default="">
        <cfargument name="REFERENCE_NO1" default="">
        <cfargument name="ORDER_NUMBER1" default="">
        <cfargument name="PRODUCT_NAME1" default="">
        <cfargument name="is_excel" default="">
        
        <cfif len(arguments.P_ORDER_NO1) or len(arguments.DEMAND_NO1) or len(arguments.LOT_NO1) or len(arguments.REFERENCE_NO1) or len(arguments.ORDER_NUMBER1) or len(arguments.PRODUCT_NAME1) >
        
		<cfelse>
        	<cfset arguments.P_ORDER_NO1 = 1 >
            <cfset arguments.DEMAND_NO1 = 1 >
            <cfset arguments.LOT_NO1 = 1 >
            <cfset arguments.REFERENCE_NO1 = 1 >
            <cfset arguments.ORDER_NUMBER1 = 1 >
            <cfset arguments.PRODUCT_NAME1 = 1 >
        </cfif>
        
        <cfquery name="CFC_GET_PRODUCTION_ORDERS" datasource="#this.DSN3#">
			WITH CTE1 AS (
            SELECT
					PRODUCTION_ORDERS.IS_GROUP_LOT,
					PRODUCTION_ORDERS.P_ORDER_ID,
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
					PRODUCTION_ORDERS.PROJECT_ID,
					STOCKS.PRODUCT_NAME,
					STOCKS.PRODUCT_ID,
					STOCKS.PROPERTY,
					STOCKS.STOCK_CODE,
					PRODUCTION_ORDERS.REFERENCE_NO,
					PRODUCTION_ORDERS.SPECT_VAR_ID,
					PRODUCTION_ORDERS.SPECT_VAR_NAME,
					PRODUCTION_ORDERS.SPEC_MAIN_ID,
					PRODUCTION_ORDERS.DEMAND_NO,
					STOCKS.PRODUCT_CATID,
					(SELECT I.INTERNAL_NUMBER FROM INTERNALDEMAND I,INTERNALDEMAND_ROW IR WHERE IR.I_ID = I.INTERNAL_ID AND IR.WRK_ROW_ID = ISNULL(PRODUCTION_ORDERS.WRK_ROW_RELATION_ID,0)) ICT_NO,
					<cfif isdefined("arguments.is_show_result_amount") and arguments.is_show_result_amount eq 1>
					ISNULL(RESULT_AMOUNT,0) ROW_RESULT_AMOUNT,
					</cfif>
					PU.MAIN_UNIT
					<cfif arguments.fuseaction_ contains 'operations'>
						,PRODUCTION_OPERATION.OPERATION_TYPE_ID
						,(PRODUCTION_ORDERS.QUANTITY - ISNULL((
								SELECT 
									SUM(POR.REAL_AMOUNT)
								FROM
									PRODUCTION_OPERATION_RESULT POR
								WHERE
									POR.OPERATION_ID = PRODUCTION_OPERATION.P_OPERATION_ID
							),0)) LAST_AMOUNT
						<cfif isdefined('arguments.result') and arguments.result eq 1>
							,PRODUCTION_OPERATION_RESULT.ACTION_EMPLOYEE_ID
							,PRODUCTION_OPERATION_RESULT.REAL_AMOUNT
							,PRODUCTION_OPERATION_RESULT.STATION_ID RESULT_STATION_ID
							,PRODUCTION_OPERATION_RESULT.OPERATION_RESULT_ID
						</cfif>
					</cfif>
					,(SELECT TOP 1 COMPANY_ID FROM PRODUCTION_ORDERS_ROW,ORDERS WHERE PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID AND PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID = PRODUCTION_ORDERS.P_ORDER_ID) COMPANY_ID
					,(SELECT TOP 1 CONSUMER_ID FROM PRODUCTION_ORDERS_ROW,ORDERS WHERE PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID AND PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID = PRODUCTION_ORDERS.P_ORDER_ID) CONSUMER_ID
					,(SELECT TOP 1 ORDER_EMPLOYEE_ID FROM PRODUCTION_ORDERS_ROW,ORDERS WHERE PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID AND PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID = PRODUCTION_ORDERS.P_ORDER_ID) ORDER_EMPLOYEE_ID
					,(SELECT TOP 1 DELIVERDATE FROM PRODUCTION_ORDERS_ROW,ORDERS WHERE PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID AND PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID = PRODUCTION_ORDERS.P_ORDER_ID) DELIVERDATE
				FROM
					PRODUCTION_ORDERS,
					STOCKS,
					PRODUCT_UNIT PU
					<cfif arguments.fuseaction_ contains 'operations'>
						,PRODUCTION_OPERATION
						<cfif isdefined('arguments.result') and arguments.result eq 1>
							,PRODUCTION_OPERATION_RESULT
						</cfif>
					</cfif>
				WHERE
                	<cfif len(arguments.product_id) and len(arguments.product_name)>
                		STOCKS.PRODUCT_ID = #arguments.product_id# AND
                    </cfif>
					<cfif isdefined("arguments.related_product_id") and len(arguments.related_stock_id) and len(arguments.related_product_id) and len(arguments.related_product_name)>
						(
							PRODUCTION_ORDERS.P_ORDER_ID IN (SELECT PRODUCTION_ORDERS_STOCKS.P_ORDER_ID FROM PRODUCTION_ORDERS_STOCKS WHERE PRODUCTION_ORDERS_STOCKS.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.related_stock_id#">)
						)
						AND
					</cfif>
					PRODUCTION_ORDERS.STOCK_ID = STOCKS.STOCK_ID
					AND PU.PRODUCT_UNIT_ID=STOCKS.PRODUCT_UNIT_ID 
					AND PRODUCTION_ORDERS.P_ORDER_ID IN(
											SELECT 
												PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID
											FROM
												PRODUCTION_ORDERS_ROW
											WHERE
												PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID = PRODUCTION_ORDERS.P_ORDER_ID
										)
					<cfif arguments.fuseaction_ contains 'operations'>
						AND PRODUCTION_ORDERS.P_ORDER_ID = PRODUCTION_OPERATION.P_ORDER_ID
						<cfif isdefined('arguments.result') and arguments.result eq 1>
							AND PRODUCTION_OPERATION.P_OPERATION_ID = PRODUCTION_OPERATION_RESULT.OPERATION_ID
						<cfelseif isdefined('arguments.result') and arguments.result eq 0>
							AND (PRODUCTION_ORDERS.QUANTITY - ISNULL((
								SELECT 
									SUM(POR.REAL_AMOUNT)
								FROM
									PRODUCTION_OPERATION_RESULT POR
								WHERE
									POR.OPERATION_ID = PRODUCTION_OPERATION.P_OPERATION_ID
							),0)) <> 0
						</cfif>
						<cfif isdefined('arguments.operation_type_id') and len(arguments.operation_type_id) and len(arguments.operation_type)>
							AND PRODUCTION_OPERATION.OPERATION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.operation_type_id#">
						</cfif>
						<cfif isdefined('arguments.result') and arguments.result eq 1>
							<cfif isdefined('arguments.station_id') and len(arguments.station_id)>
                                    <cfif arguments.station_id eq 0>
                                        AND PRODUCTION_OPERATION_RESULT.STATION_ID IS NULL
                                    <cfelse>
                                        AND(
											(PRODUCTION_OPERATION_RESULT.STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.station_id#">)
											OR
											(PRODUCTION_OPERATION_RESULT.STATION_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.station_list#" list="yes">))
											)
                                    </cfif>
                            <cfelseif len(arguments.authority_station_id_list)><!--- eğer istasyon seçilmemiş ise,sadece yetkili istasyonlar gelsin. --->
                                AND (PRODUCTION_OPERATION_RESULT.STATION_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.authority_station_id_list#" list="yes">) OR PRODUCTION_OPERATION_RESULT.STATION_ID IS NULL)
                            </cfif>
                        <cfelse>
							<cfif isdefined('arguments.station_id') and len(arguments.station_id)>
								<cfif arguments.station_id eq 0>
                                    AND PRODUCTION_OPERATION.STATION_ID IS NULL
                                <cfelse>
                                    AND PRODUCTION_OPERATION.OPERATION_TYPE_ID IN (SELECT
																						WP.OPERATION_TYPE_ID
																					FROM 
																						WORKSTATIONS W,
																						WORKSTATIONS_PRODUCTS WP
																					WHERE
																					W.STATION_ID = WP.WS_ID 
																					AND WP.MAIN_STOCK_ID IS NULL
																					AND(
																						(W.STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.station_id#">)
																						OR
																						(W.STATION_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.station_list#" list="yes">))
																						))
                                </cfif>
                            <cfelseif len(arguments.authority_station_id_list)><!--- eğer istasyon seçilmemiş ise,sadece yetkili istasyonlar gelsin. --->
                                AND (PRODUCTION_OPERATION.STATION_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.authority_station_id_list#" list="yes">) OR PRODUCTION_OPERATION.STATION_ID IS NULL)
                            </cfif>
                        </cfif>
					</cfif>
					<cfif arguments.fuseaction_ contains 'order' or arguments.fuseaction_ contains 'operations'><!---Operasyonlar veya Emirler ise : Operatöre Gönderilmiş. --->
						<cfif not isdefined("arguments.production_stage") or not listlen(arguments.production_stage)>
							AND PRODUCTION_ORDERS.IS_STAGE <> <cfqueryparam cfsqltype="cf_sql_integer" value="-1">
						<cfelse>
							AND PRODUCTION_ORDERS.IS_STAGE IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.production_stage#" list="yes">)
						</cfif>
					<cfelseif arguments.fuseaction_ contains 'demands'><!--- TALEPLER İSE : BAŞLAMADI OLANLAR... --->
						AND PRODUCTION_ORDERS.IS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="-1">
						AND PRODUCTION_ORDERS.DEMAND_NO IS NOT NULL
					<cfelseif arguments.fuseaction_ contains 'in_productions'>
						<cfif not isdefined("arguments.production_stage") or not listlen(arguments.production_stage)>
							AND PRODUCTION_ORDERS.IS_STAGE IN (<cfqueryparam cfsqltype="cf_sql_integer" value="1,3" list="yes">)
						<cfelse>
							AND PRODUCTION_ORDERS.IS_STAGE IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.production_stage#" list="yes">)
						</cfif>
					</cfif>
					<cfif isDefined("arguments.position_code") and len(arguments.position_code) and len(arguments.position_name)>
						AND STOCKS.PRODUCT_CATID IN(SELECT 
														PC2.PRODUCT_CATID
													FROM 
														PRODUCT_CAT PC1,
														PRODUCT_CAT PC2 
													WHERE 
														PC1.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_code#">
														AND (PC2.HIERARCHY LIKE PC1.HIERARCHY+'.%' OR PC1.HIERARCHY LIKE PC2.HIERARCHY+'.%' OR PC1.PRODUCT_CATID=PC2.PRODUCT_CATID)
													)
					</cfif>
					<cfif isdefined('arguments.product_cat') and  len(arguments.product_cat) and len(arguments.product_catid)>
						AND STOCKS.PRODUCT_CATID IN(SELECT 
														PC1.PRODUCT_CATID
													FROM 
														PRODUCT_CAT PC1,
														PRODUCT_CAT PC2 
													WHERE 
														PC2.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_catid#">
														AND (PC2.HIERARCHY LIKE PC1.HIERARCHY+'.%' OR PC1.HIERARCHY LIKE PC2.HIERARCHY+'.%' OR PC1.PRODUCT_CATID=PC2.PRODUCT_CATID)
													)
					</cfif>
					<cfif isdefined('arguments.spect_main_id') and isdefined('arguments.spect_name') and len(arguments.spect_name)>
						AND PRODUCTION_ORDERS.SPECT_VAR_ID IN(SELECT SPECT_VAR_ID FROM SPECTS WHERE SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.spect_main_id#">)
					</cfif>
					<cfif isdefined("arguments.short_code_id") and len(arguments.short_code_id) and len(arguments.short_code_name)>
						AND	STOCKS.SHORT_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.short_code_id#">
					</cfif>
					<cfif isdefined('arguments.keyword') and len(arguments.keyword)>
						<cfif arguments.fuseaction_ contains 'demands'>
							AND 
							(	
								(1=2)   
								<cfif len(arguments.P_ORDER_NO1)>
                                	OR (P_ORDER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI) 
								</cfif>
                                <cfif len(arguments.DEMAND_NO1)>
                                    OR
                                    (DEMAND_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI)
								</cfif>
                                <cfif len(arguments.LOT_NO1)>
                                    OR
                                    (LOT_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI)
								</cfif>
                                <cfif len(arguments.REFERENCE_NO1)>
                                OR 
								(REFERENCE_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI)
								</cfif>
                                <cfif len(arguments.ORDER_NUMBER1)>
                                OR
								(PRODUCTION_ORDERS.P_ORDER_ID IN 
									(SELECT 
										PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID
									FROM
										PRODUCTION_ORDERS_ROW,
										ORDERS
									WHERE
										ORDERS.ORDER_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI AND 
										PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID))
								</cfif>
                                <cfif len(arguments.PRODUCT_NAME1)>
                                OR
								(PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI)
                                </cfif>
							)
						<cfelse>
							<cfif ListLen(arguments.keyword,',') gt 1>
								AND
								(
								<cfset p_sayac = 0>
								<cfloop list="#arguments.keyword#" delimiters="," index="p_or_no">
								<cfset p_sayac = p_sayac+1>
								( P_ORDER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#p_or_no#"> OR DEMAND_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#p_or_no#"> OR REFERENCE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#p_or_no#"> OR LOT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#p_or_no#">) <cfif ListLen(arguments.keyword,',') gt p_sayac>OR </cfif>
								</cfloop>
								)
							<cfelse><!--- tek bir tane ise like ile baksın.. --->
								AND 
								(
                                	(1=2)   
									<cfif len(arguments.P_ORDER_NO1)>
                                        OR
                                        (P_ORDER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI) 
									</cfif>
                                    <cfif len(arguments.DEMAND_NO1)>
                                        OR 
                                        (DEMAND_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI) 
									</cfif>
									<cfif len(arguments.REFERENCE_NO1)>
                                        OR 
                                        (REFERENCE_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI)
									</cfif>
                                    <cfif len(arguments.LOT_NO1)>
                                        OR
                                        (LOT_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI)
									</cfif>
                                    <cfif len(arguments.ORDER_NUMBER1)>
                                        OR
                                        (PRODUCTION_ORDERS.P_ORDER_ID IN 
                                            (SELECT 
                                                PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID
                                            FROM
                                                PRODUCTION_ORDERS_ROW,
                                                ORDERS
                                            WHERE
                                                ORDERS.ORDER_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI AND 
                                                PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID))
									</cfif>
                                    <cfif len(arguments.PRODUCT_NAME1)>
                                        OR
                                        (PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI)
									</cfif>
                                   
                                )
							</cfif>
						</cfif>
					</cfif>
					<cfif arguments.fuseaction_ contains 'operations' and isdefined('arguments.result') and arguments.result eq 1>
						AND PRODUCTION_OPERATION.P_ORDER_ID IN (SELECT PRODUCTION_OPERATION_RESULT.OPERATION_ID FROM PRODUCTION_OPERATION_RESULT)
					<cfelse>
						<cfif isdefined('arguments.result') and arguments.result eq 1>
							AND PRODUCTION_ORDERS.P_ORDER_ID IN (SELECT PRODUCTION_ORDER_RESULTS.P_ORDER_ID FROM PRODUCTION_ORDER_RESULTS)
						<cfelseif isdefined('arguments.result') and arguments.result eq 0>
							AND PRODUCTION_ORDERS.P_ORDER_ID NOT IN (SELECT PRODUCTION_ORDER_RESULTS.P_ORDER_ID FROM PRODUCTION_ORDER_RESULTS)
						</cfif>
					</cfif>
					<cfif isdefined('arguments.sales_partner') and len(arguments.sales_partner) and len(arguments.sales_partner_id)>
						AND PRODUCTION_ORDERS.P_ORDER_ID IN(
											SELECT 
												PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID
											FROM
												PRODUCTION_ORDERS_ROW,
												ORDERS
											WHERE
												PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID
												AND ORDERS.SALES_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sales_partner_id#">
										)			
					</cfif>
					<cfif isdefined('arguments.order_employee') and len(arguments.order_employee) and len(arguments.order_employee_id)>
						AND PRODUCTION_ORDERS.P_ORDER_ID IN(
											SELECT 
												PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID
											FROM
												PRODUCTION_ORDERS_ROW,
												ORDERS
											WHERE
												PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID
												AND ORDERS.ORDER_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_employee_id#">
										)		
					</cfif>
					<cfif isdefined('arguments.project_head') and len(arguments.project_head) and len(arguments.project_id)>
						AND PRODUCTION_ORDERS.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">
					</cfif>
					<cfif isdefined("arguments.member_type") and (arguments.member_type is 'partner') and len(arguments.member_name) and len(arguments.company_id)>
						AND PRODUCTION_ORDERS.P_ORDER_ID IN(
											SELECT 
												PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID
											FROM
												PRODUCTION_ORDERS_ROW,
												ORDERS
											WHERE
												PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID
												AND ORDERS.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
										)
					</cfif>
					<cfif isdefined("arguments.member_type") and (arguments.member_type is 'consumer') and len(arguments.member_name) and len(arguments.consumer_id)>
						AND PRODUCTION_ORDERS.P_ORDER_ID IN(
											SELECT 
												PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID
											FROM
												PRODUCTION_ORDERS_ROW,
												ORDERS
											WHERE
												PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID
												AND ORDERS.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
										)
					</cfif>
					<cfif isDefined('arguments.status') and arguments.status eq 1>
						AND (STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> OR STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="1">)
					<cfelseif isDefined('arguments.status') and arguments.status eq 2>
						AND STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
					<cfelseif isDefined('arguments.status') and arguments.status eq 3> 
						AND STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
					</cfif>
					<cfif arguments.fuseaction_ contains 'order' or arguments.fuseaction_ contains 'demands'><!---Talepler veya Emirler ise  --->
						<cfif isDefined('arguments.related_orders') and arguments.related_orders eq 1>
							AND (PRODUCTION_ORDERS.PO_RELATED_ID IS NULL OR PRODUCTION_ORDERS.PO_RELATED_ID IS NOT NULL)
						<cfelseif isDefined('arguments.related_orders') and arguments.related_orders eq 2>
							AND PRODUCTION_ORDERS.PO_RELATED_ID IS NULL
						<cfelseif isDefined('arguments.related_orders') and arguments.related_orders eq 3> 
							AND PRODUCTION_ORDERS.PO_RELATED_ID IS NOT NULL
						</cfif>
					</cfif>
			UNION ALL
				SELECT
					PRODUCTION_ORDERS.IS_GROUP_LOT,
					PRODUCTION_ORDERS.P_ORDER_ID,
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
					PRODUCTION_ORDERS.PROJECT_ID,
					STOCKS.PRODUCT_NAME,
					STOCKS.PRODUCT_ID,
					STOCKS.PROPERTY,
					STOCKS.STOCK_CODE,
					PRODUCTION_ORDERS.REFERENCE_NO,
					PRODUCTION_ORDERS.SPECT_VAR_ID,
					PRODUCTION_ORDERS.SPECT_VAR_NAME,
					PRODUCTION_ORDERS.SPEC_MAIN_ID,
					PRODUCTION_ORDERS.DEMAND_NO,
					STOCKS.PRODUCT_CATID,
					(SELECT I.INTERNAL_NUMBER FROM INTERNALDEMAND I,INTERNALDEMAND_ROW IR WHERE IR.I_ID = I.INTERNAL_ID AND IR.WRK_ROW_ID = ISNULL(PRODUCTION_ORDERS.WRK_ROW_RELATION_ID,0)) ICT_NO,
					<cfif isdefined("arguments.is_show_result_amount") and arguments.is_show_result_amount eq 1>
					ISNULL((SELECT
								SUM(POR_.AMOUNT) ORDER_AMOUNT
							FROM
								PRODUCTION_ORDER_RESULTS_ROW POR_,
								PRODUCTION_ORDER_RESULTS POO
							WHERE
								POR_.PR_ORDER_ID = POO.PR_ORDER_ID
								AND POO.P_ORDER_ID = PRODUCTION_ORDERS.P_ORDER_ID AND
                                POR_.STOCK_ID = PRODUCTION_ORDERS.STOCK_ID AND
                                POR_.SPEC_MAIN_ID = PRODUCTION_ORDERS.SPEC_MAIN_ID
								AND POR_.TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
								AND POO.IS_STOCK_FIS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
							),0) ROW_RESULT_AMOUNT,
					</cfif>
					PU.MAIN_UNIT
					<cfif arguments.fuseaction_ contains 'operations'>
						,PRODUCTION_OPERATION.OPERATION_TYPE_ID
						,(PRODUCTION_ORDERS.QUANTITY - ISNULL((
								SELECT 
									SUM(POR.REAL_AMOUNT)
								FROM
									PRODUCTION_OPERATION_RESULT POR
								WHERE
									POR.OPERATION_ID = PRODUCTION_OPERATION.P_OPERATION_ID
							),0)) LAST_AMOUNT
						<cfif isdefined('arguments.result') and arguments.result eq 1>
							,PRODUCTION_OPERATION_RESULT.ACTION_EMPLOYEE_ID
							,PRODUCTION_OPERATION_RESULT.REAL_AMOUNT
							,PRODUCTION_OPERATION_RESULT.STATION_ID RESULT_STATION_ID
							,PRODUCTION_OPERATION_RESULT.OPERATION_RESULT_ID
						</cfif>
					</cfif>
					,(SELECT TOP 1 COMPANY_ID FROM PRODUCTION_ORDERS_ROW,ORDERS WHERE PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID AND PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID = PRODUCTION_ORDERS.P_ORDER_ID) COMPANY_ID
					,(SELECT TOP 1 CONSUMER_ID FROM PRODUCTION_ORDERS_ROW,ORDERS WHERE PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID AND PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID = PRODUCTION_ORDERS.P_ORDER_ID) CONSUMER_ID
					,(SELECT TOP 1 ORDER_EMPLOYEE_ID FROM PRODUCTION_ORDERS_ROW,ORDERS WHERE PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID AND PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID = PRODUCTION_ORDERS.P_ORDER_ID) ORDER_EMPLOYEE_ID
					,(SELECT TOP 1 DELIVERDATE FROM PRODUCTION_ORDERS_ROW,ORDERS WHERE PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID AND PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID = PRODUCTION_ORDERS.P_ORDER_ID) DELIVERDATE
				FROM
					PRODUCTION_ORDERS,
					STOCKS,
					PRODUCT_UNIT PU
					<cfif arguments.fuseaction_ contains 'operations'>
						,PRODUCTION_OPERATION
						<cfif isdefined('arguments.result') and arguments.result eq 1>
							,PRODUCTION_OPERATION_RESULT
						</cfif>
					</cfif>
				WHERE
                	<cfif len(arguments.product_id) and len(arguments.product_name)>
                		STOCKS.PRODUCT_ID = #arguments.product_id# AND
                    </cfif>
					<cfif isdefined("arguments.related_product_id") and len(arguments.related_stock_id) and len(arguments.related_product_id) and len(arguments.related_product_name)>
						(
						PRODUCTION_ORDERS.P_ORDER_ID IN (SELECT PRODUCTION_ORDERS_STOCKS.P_ORDER_ID FROM PRODUCTION_ORDERS_STOCKS WHERE PRODUCTION_ORDERS_STOCKS.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.related_stock_id#">)
						)
						AND
					</cfif>
					PU.PRODUCT_UNIT_ID=STOCKS.PRODUCT_UNIT_ID AND 
					PRODUCTION_ORDERS.STOCK_ID = STOCKS.STOCK_ID AND
					PRODUCTION_ORDERS.P_ORDER_ID NOT IN(
											SELECT 
												PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID
											FROM
												PRODUCTION_ORDERS_ROW
											WHERE
												PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID = PRODUCTION_ORDERS.P_ORDER_ID
										)
					<cfif arguments.fuseaction_ contains 'operations'>
						AND PRODUCTION_ORDERS.P_ORDER_ID = PRODUCTION_OPERATION.P_ORDER_ID
						<cfif isdefined('arguments.result') and arguments.result eq 1>
							AND PRODUCTION_OPERATION.P_OPERATION_ID = PRODUCTION_OPERATION_RESULT.OPERATION_ID
						<cfelseif isdefined('arguments.result') and arguments.result eq 0>
							AND (PRODUCTION_ORDERS.QUANTITY - ISNULL((
								SELECT 
									SUM(POR.REAL_AMOUNT)
								FROM
									PRODUCTION_OPERATION_RESULT POR
								WHERE
									POR.OPERATION_ID = PRODUCTION_OPERATION.P_OPERATION_ID
							),0)) <> 0
						</cfif>
						<cfif isdefined('arguments.operation_type_id') and len(arguments.operation_type_id) and len(arguments.operation_type)>
							AND PRODUCTION_OPERATION.OPERATION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.operation_type_id#">
						</cfif>
                        <cfif isdefined('arguments.result') and arguments.result eq 1>
							<cfif isdefined('arguments.station_id') and len(arguments.station_id)>
                                    <cfif arguments.station_id eq 0>
                                        AND PRODUCTION_OPERATION_RESULT.STATION_ID IS NULL
                                    <cfelse>
                                       AND(
											(PRODUCTION_OPERATION_RESULT.STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.station_id#">)
											OR
											(PRODUCTION_OPERATION_RESULT.STATION_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.station_list#" list="yes">))
											)
                                    </cfif>
                            <cfelseif len(arguments.authority_station_id_list)><!--- eğer istasyon seçilmemiş ise,sadece yetkili istasyonlar gelsin. --->
                                AND (PRODUCTION_OPERATION_RESULT.STATION_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.authority_station_id_list#" list="yes">) OR PRODUCTION_OPERATION_RESULT.STATION_ID IS NULL)
                            </cfif>
                        <cfelse>
							<cfif isdefined('arguments.station_id') and len(arguments.station_id)>
								<cfif arguments.station_id eq 0>
                                    AND PRODUCTION_OPERATION.STATION_ID IS NULL
                                <cfelse>
                                    AND PRODUCTION_OPERATION.OPERATION_TYPE_ID IN (SELECT
																						WP.OPERATION_TYPE_ID
																					FROM 
																						WORKSTATIONS W,
																						WORKSTATIONS_PRODUCTS WP
																					WHERE
																					W.STATION_ID = WP.WS_ID 
																					AND WP.MAIN_STOCK_ID IS NULL
																					AND (
																						(W.STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.station_id#">)
																						OR
																						(W.STATION_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.station_list#" list="yes">))
																						))
                                </cfif>
                            <cfelseif len(arguments.authority_station_id_list)><!--- eğer istasyon seçilmemiş ise,sadece yetkili istasyonlar gelsin. --->
                                AND (PRODUCTION_OPERATION.STATION_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.authority_station_id_list#" list="yes">) OR PRODUCTION_OPERATION.STATION_ID IS NULL)
                            </cfif>
                        </cfif>
					</cfif>
					<cfif arguments.fuseaction_ contains 'order' or arguments.fuseaction_ contains 'operations'><!---Operasyonlar veya Emirler ise : Operatöre Gönderilmiş. --->
						<cfif not isdefined("arguments.production_stage") or not listlen(arguments.production_stage)>
							AND PRODUCTION_ORDERS.IS_STAGE <> <cfqueryparam cfsqltype="cf_sql_integer" value="-1">
						<cfelse>
							AND PRODUCTION_ORDERS.IS_STAGE IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.production_stage#" list="yes">)
						</cfif>
					<cfelseif arguments.fuseaction_ contains 'demands'><!--- TALEPLER İSE : BAŞLAMADI OLANLAR... --->
						AND PRODUCTION_ORDERS.IS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="-1">
						AND PRODUCTION_ORDERS.DEMAND_NO IS NOT NULL
					<cfelseif arguments.fuseaction_ contains 'in_productions'>
						<cfif not isdefined("arguments.production_stage") or not listlen(arguments.production_stage)>
							AND PRODUCTION_ORDERS.IS_STAGE IN (<cfqueryparam cfsqltype="cf_sql_integer" value="1,3" list="yes">)
						<cfelse>
							AND PRODUCTION_ORDERS.IS_STAGE IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.production_stage#" list="yes">)
						</cfif>
					</cfif>
					<cfif isDefined("arguments.position_code") and len(arguments.position_code) and len(arguments.position_name)>
						AND STOCKS.PRODUCT_CATID IN(SELECT 
														PC2.PRODUCT_CATID
													FROM 
														PRODUCT_CAT PC1,
														PRODUCT_CAT PC2 
													WHERE 
														PC1.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_code#">
														AND (PC2.HIERARCHY LIKE PC1.HIERARCHY+'.%' OR PC1.HIERARCHY LIKE PC2.HIERARCHY+'.%' OR PC1.PRODUCT_CATID=PC2.PRODUCT_CATID)
													)
					</cfif>
					<cfif isdefined('arguments.product_cat') and  len(arguments.product_cat) and len(arguments.product_catid)>
						AND STOCKS.PRODUCT_CATID IN(SELECT 
														PC1.PRODUCT_CATID
													FROM 
														PRODUCT_CAT PC1,
														PRODUCT_CAT PC2 
													WHERE 
														PC2.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_catid#">
														AND (PC2.HIERARCHY LIKE PC1.HIERARCHY+'.%' OR PC1.HIERARCHY LIKE PC2.HIERARCHY+'.%' OR PC1.PRODUCT_CATID=PC2.PRODUCT_CATID)
													)
					</cfif>
					<cfif isdefined('arguments.spect_main_id') and isdefined('arguments.spect_name') and len(arguments.spect_name)>
						AND PRODUCTION_ORDERS.SPECT_VAR_ID IN(SELECT SPECT_VAR_ID FROM SPECTS WHERE SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.spect_main_id#">)
					</cfif>
					<cfif isdefined("arguments.short_code_id") and len(arguments.short_code_id) and len(arguments.short_code_name)>
						AND	STOCKS.SHORT_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.short_code_id#">
					</cfif>
					<cfif isdefined('arguments.keyword') and len(arguments.keyword)>
						<cfif arguments.fuseaction_ contains 'demands'>
							AND 
							(
								(1=2)   
								<cfif len(arguments.P_ORDER_NO1)>
                                	OR (P_ORDER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI) 
								</cfif>
                                <cfif len(arguments.DEMAND_NO1)>
                                    OR
                                    (DEMAND_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI)
								</cfif>
                                <cfif len(arguments.LOT_NO1)>
                                    OR
                                    (LOT_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI)
								</cfif>
                                <cfif len(arguments.REFERENCE_NO1)>
                                OR 
								(REFERENCE_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI)
								</cfif>
                                <cfif len(arguments.ORDER_NUMBER1)>
                                OR
								(PRODUCTION_ORDERS.P_ORDER_ID IN 
									(SELECT 
										PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID
									FROM
										PRODUCTION_ORDERS_ROW,
										ORDERS
									WHERE
										ORDERS.ORDER_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI AND 
										PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID))
								</cfif>
                                <cfif len(arguments.PRODUCT_NAME1)>
                                OR
								(PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI)
                                </cfif>
							)
                            
                            	
                            
						<cfelse>
							<cfif ListLen(arguments.keyword,',') gt 1>
								AND
								(
								<cfset p_sayac = 0>
								<cfloop list="#arguments.keyword#" delimiters="," index="p_or_no">
								<cfset p_sayac = p_sayac+1>
								(P_ORDER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#p_or_no#"> OR DEMAND_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#p_or_no#"> OR REFERENCE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#p_or_no#"> OR LOT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#p_or_no#">) <cfif ListLen(arguments.keyword,',') gt p_sayac>OR </cfif>
								</cfloop>
								)
							<cfelse><!--- tek bir tane ise like ile baksın.. --->
								AND 
								(
									(1=2)   
									<cfif len(arguments.P_ORDER_NO1)>
                                        OR (P_ORDER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI) 
                                    </cfif>
                                    <cfif len(arguments.DEMAND_NO1)>
                                        OR
                                        (DEMAND_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI)
                                    </cfif>
                                    <cfif len(arguments.LOT_NO1)>
                                        OR
                                        (LOT_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI)
                                    </cfif>
                                    <cfif len(arguments.REFERENCE_NO1)>
                                    OR 
                                    (REFERENCE_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI)
                                    </cfif>
                                    <cfif len(arguments.ORDER_NUMBER1)>
                                    OR
                                    (PRODUCTION_ORDERS.P_ORDER_ID IN 
                                        (SELECT 
                                            PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID
                                        FROM
                                            PRODUCTION_ORDERS_ROW,
                                            ORDERS
                                        WHERE
                                            ORDERS.ORDER_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI AND 
                                            PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID))
                                    </cfif>
                                    <cfif len(arguments.PRODUCT_NAME1)>
                                    OR
                                    (PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI)
                                    </cfif>
                                    
								)
							</cfif>
						</cfif>
					</cfif>
					<cfif isdefined('arguments.sales_partner') and len(arguments.sales_partner) and len(arguments.sales_partner_id)>
						AND PRODUCTION_ORDERS.P_ORDER_ID IN(
											SELECT 
												PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID
											FROM
												PRODUCTION_ORDERS_ROW,
												ORDERS
											WHERE
												PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID
												AND ORDERS.SALES_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sales_partner_id#">
										)			
					</cfif>
					<cfif isdefined('arguments.order_employee') and len(arguments.order_employee) and len(arguments.order_employee_id)>
						AND PRODUCTION_ORDERS.P_ORDER_ID IN(
											SELECT 
												PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID
											FROM
												PRODUCTION_ORDERS_ROW,
												ORDERS
											WHERE
												PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID
												AND ORDERS.ORDER_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_employee_id#">
										)		
					</cfif>
					<cfif isdefined('arguments.project_head') and len(arguments.project_head) and len(arguments.project_id)>
						AND PRODUCTION_ORDERS.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">
					</cfif>
					<cfif isdefined("arguments.member_type") and (arguments.member_type is 'partner') and len(arguments.member_name) and len(arguments.company_id)>
						AND PRODUCTION_ORDERS.P_ORDER_ID IN(
											SELECT 
												PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID
											FROM
												PRODUCTION_ORDERS_ROW,
												ORDERS
											WHERE
												PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID
												AND ORDERS.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
										)
					</cfif>
					<cfif isdefined("arguments.member_type") and (arguments.member_type is 'consumer') and len(arguments.member_name) and len(arguments.consumer_id)>
						AND PRODUCTION_ORDERS.P_ORDER_ID IN(
											SELECT 
												PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID
											FROM
												PRODUCTION_ORDERS_ROW,
												ORDERS
											WHERE
												PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID
												AND ORDERS.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
										)
					</cfif>
					<cfif arguments.fuseaction_ contains 'operations' and isdefined('arguments.result') and arguments.result eq 1>
						AND PRODUCTION_OPERATION.P_OPERATION_ID IN (SELECT PRODUCTION_OPERATION_RESULT.OPERATION_ID FROM PRODUCTION_OPERATION_RESULT)
					<cfelse>
						<cfif isdefined('arguments.result') and arguments.result eq 1>
							AND PRODUCTION_ORDERS.P_ORDER_ID IN (SELECT PRODUCTION_ORDER_RESULTS.P_ORDER_ID FROM PRODUCTION_ORDER_RESULTS)
						<cfelseif isdefined('arguments.result') and arguments.result eq 0>
							AND PRODUCTION_ORDERS.P_ORDER_ID NOT IN (SELECT PRODUCTION_ORDER_RESULTS.P_ORDER_ID FROM PRODUCTION_ORDER_RESULTS)
						</cfif>
					</cfif>
					AND PRODUCTION_ORDERS.P_ORDER_ID NOT IN(SELECT PRODUCTION_ORDER_ID FROM PRODUCTION_ORDERS_ROW)
					<cfif isDefined('arguments.status') and arguments.status eq 1>
						AND (STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> OR STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="1">)
					<cfelseif isDefined('arguments.status') and arguments.status eq 2>
						AND STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
					<cfelseif isDefined('arguments.status') and arguments.status eq 3> 
						AND STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
					</cfif>
					<cfif arguments.fuseaction_ contains 'order' or arguments.fuseaction_ contains 'demands'><!---Talepler veya Emirler ise  --->
						<cfif isDefined('arguments.related_orders') and arguments.related_orders eq 1>
							AND (PRODUCTION_ORDERS.PO_RELATED_ID IS NULL OR PRODUCTION_ORDERS.PO_RELATED_ID IS NOT NULL)
						<cfelseif isDefined('arguments.related_orders') and arguments.related_orders eq 2>
							AND PRODUCTION_ORDERS.PO_RELATED_ID IS NULL
						<cfelseif isDefined('arguments.related_orders') and arguments.related_orders eq 3> 
							AND PRODUCTION_ORDERS.PO_RELATED_ID IS NOT NULL
						</cfif>
					</cfif>
                    <cfif arguments.fuseaction_ contains 'order' or arguments.fuseaction_ contains 'operations'><!---Operasyonlar veya Emirler ise : Operatöre Gönderilmiş. --->
						<cfif not isdefined("arguments.production_stage") or not listlen(arguments.production_stage)>
							AND PRODUCTION_ORDERS.IS_STAGE <> <cfqueryparam cfsqltype="cf_sql_integer" value="-1">
						<cfelse>
							AND PRODUCTION_ORDERS.IS_STAGE IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.production_stage#" list="yes">)
						</cfif>
					<cfelseif arguments.fuseaction_ contains 'demands'><!--- TALEPLER İSE : BAŞLAMADI OLANLAR... --->
						AND PRODUCTION_ORDERS.IS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="-1">
						AND PRODUCTION_ORDERS.DEMAND_NO IS NOT NULL
					<cfelseif arguments.fuseaction_ contains 'in_productions'>
						<cfif not isdefined("arguments.production_stage") or not listlen(arguments.production_stage)>
							AND PRODUCTION_ORDERS.IS_STAGE IN (<cfqueryparam cfsqltype="cf_sql_integer" value="1,3" list="yes">)
						<cfelse>
							AND PRODUCTION_ORDERS.IS_STAGE IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.production_stage#" list="yes">)
						</cfif>
					</cfif>
                    
        	),
           CTE2 AS (
				SELECT
					CTE1.*
				FROM
					CTE1
                WHERE
                	P_ORDER_ID IS NOT NULL
					<cfif not arguments.fuseaction_ contains 'operations'>
                        <cfif isdefined('arguments.station_id') and len(arguments.station_id)>
                            <cfif arguments.station_id eq 0>
                                AND STATION_ID IS NULL
                            <cfelse>
                                AND (
                                     (STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.station_id#">)
                                     OR
                                     (STATION_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.station_list#" list="yes">) )
                                     )
                            </cfif>
                        <cfelseif len(arguments.authority_station_id_list)><!--- eğer istasyon seçilmemiş ise,sadece yetkili istasyonlar gelsin. --->
                            AND (STATION_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.authority_station_id_list#" list="yes">) OR STATION_ID IS NULL)
                        </cfif>
                    </cfif>
                    <cfif len(arguments.product_cat) and isDefined("arguments.product_cat_code") and len(arguments.product_cat_code)>
                        AND STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#PRODUCT_CAT_CODE#%">
                    </cfif>
                    <cfif isdefined('arguments.product_id') and len(arguments.product_id) and len(arguments.product_name)>AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#"></cfif>
                    <cfif isdefined('arguments.start_date') and isdate(arguments.start_date)>
                        AND START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
                    </cfif>
                    <cfif isdefined('arguments.start_date_2') and isdate(arguments.start_date_2)>
                        AND START_DATE < #DATEADD('d',1,arguments.start_date_2)#
                    </cfif>
                    <cfif isdefined('arguments.finish_date') and isdate(arguments.finish_date)>
                        AND FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
                    </cfif>
                    <cfif isdefined('arguments.finish_date_2') and isdate(arguments.finish_date_2)>
                        AND FINISH_DATE < #DATEADD('d',1,arguments.finish_date_2)#
                    </cfif>
                    <cfif isdefined('arguments.prod_order_stage') and len(arguments.prod_order_stage)>AND PROD_ORDER_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.prod_order_stage#"></cfif>
			),
            CTE3 AS 
            (
            	SELECT 
                	CTE2.*,
                    ROW_NUMBER() OVER (	
                    					ORDER BY
											<cfif isDefined('arguments.oby') and arguments.oby eq 2>
                                                P_ORDER_ID
                                            <cfelseif isDefined('arguments.oby') and arguments.oby eq 3>
                                                START_DATE DESC
                                            <cfelseif isDefined('arguments.oby') and arguments.oby eq 4>
                                                START_DATE
                                            <cfelse>
                                                P_ORDER_ID DESC
                                            </cfif>
									) AS RowNum,(SELECT COUNT(*) FROM CTE2) AS QUERY_COUNT
                FROM
                	CTE2
            )
			SELECT
				CTE3.*
			FROM
				CTE3
            <cfif not (isdefined('arguments.is_excel') and arguments.is_excel eq 1)>
                WHERE
                    RowNum BETWEEN #startrow# and #startrow#+(#maxrows#-1)            
            </cfif>
		</cfquery>
		<cfreturn CFC_GET_PRODUCTION_ORDERS>
	</cffunction>

	<cffunction name="get_prod_order_fnc2" returntype="query">
		<cfargument name="station_id" default="">
		<cfargument name="authority_station_id_list" default="">
		<cfargument name="product_cat" default="">
		<cfargument name="product_cat_code" default="">
		<cfargument name="product_id" default="">
		<cfargument name="product_name" default="">
		<cfargument name="start_date" default="">
		<cfargument name="start_date_2" default="">
		<cfargument name="finish_date" default="">
		<cfargument name="finish_date_2" default="">
		<cfargument name="prod_order_stage" default="">
		<cfargument name="oby" default="">
		<cfargument name="fuseaction_" default="">
		<cfargument name="station_list" default="">
		<cfquery name="CFC_GET_PRODUCTION_ORDERS_DETAIL" dbtype="query">
			SELECT 
				*
			FROM
				CFC_GET_PRODUCTION_ORDERS
			WHERE
				P_ORDER_ID IS NOT NULL
				<cfif not arguments.fuseaction_ contains 'operations'>
					<cfif isdefined('arguments.station_id') and len(arguments.station_id)>
						<cfif arguments.station_id eq 0>
							AND STATION_ID IS NULL
						<cfelse>
							AND (
								 (STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.station_id#">)
								 OR
								 (STATION_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.station_list#" list="yes">) )
								 )
						</cfif>
					<cfelseif len(arguments.authority_station_id_list)><!--- eğer istasyon seçilmemiş ise,sadece yetkili istasyonlar gelsin. --->
						AND (STATION_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.authority_station_id_list#" list="yes">) OR STATION_ID IS NULL)
					</cfif>
				</cfif>
				<cfif len(arguments.product_cat) and isDefined("arguments.product_cat_code") and len(arguments.product_cat_code)>
					AND STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#PRODUCT_CAT_CODE#%">
				</cfif>
				<cfif isdefined('arguments.product_id') and len(arguments.product_id) and len(arguments.product_name)>AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#"></cfif>
				<cfif isdefined('arguments.start_date') and isdate(arguments.start_date)>
					AND START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
				</cfif>
				<cfif isdefined('arguments.start_date_2') and isdate(arguments.start_date_2)>
					AND START_DATE < #DATEADD('d',1,arguments.start_date_2)#
				</cfif>
				<cfif isdefined('arguments.finish_date') and isdate(arguments.finish_date)>
					AND FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
				</cfif>
				<cfif isdefined('arguments.finish_date_2') and isdate(arguments.finish_date_2)>
					AND FINISH_DATE < #DATEADD('d',1,arguments.finish_date_2)#
				</cfif>
				<cfif isdefined('arguments.prod_order_stage') and len(arguments.prod_order_stage)>AND PROD_ORDER_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.prod_order_stage#"></cfif>
			ORDER BY
				<cfif isDefined('arguments.oby') and arguments.oby eq 2>
					P_ORDER_ID
				<cfelseif isDefined('arguments.oby') and arguments.oby eq 3>
					START_DATE DESC
				<cfelseif isDefined('arguments.oby') and arguments.oby eq 4>
					START_DATE
				<cfelse>
					P_ORDER_ID DESC
				</cfif>
		</cfquery>
		<cfreturn CFC_GET_PRODUCTION_ORDERS_DETAIL>
	</cffunction>
    
    

<cffunction name="list_production_orders_fnc" returntype="query">
		
	   <cfargument name="keyword" type="string" hint="arayüz filtrede aranacak anahtar kelime" default="">
       <cfargument name="startrow" type="numeric" hint="" default="">
       <cfargument name="maxrows"  type="numeric" hint="" default="">
       <cfargument name="station_id" default="">
       <cfargument name="station_list" default="">
       <cfargument name="authority_station_id_list" default="">
       <cfargument name="prod_order_stage" default="">
       <cfargument name="related_orders" default="">
       <cfargument name="result" default="">
       <cfargument name="oby" default="">
       <cfargument name="status" default="">
       <cfargument name="product_cat" default="">
       <cfargument name="product_catid" default="">
       <cfargument name="product_cat_code" default="">
       <cfargument name="position_code" default="">
       <cfargument name="member_type" default="">
	   <cfargument name="member_name" default="">
       <cfargument name="company_id" default="">
       <cfargument name="consumer_id" default="">
       <cfargument name="position_name" default="">
       <cfargument name="order_employee_id" default="">
       <cfargument name="order_employee" default="">
       <cfargument name="related_product_id" default="">
	   <cfargument name="related_stock_id" default="">
	   <cfargument name="related_product_name" default="">
       <cfargument name="project_head" default="">
	   <cfargument name="project_id" default="">
       <cfargument name="product_id" default="">
       <cfargument name="product_name" default="">
       <cfargument name="spect_main_id" default="">
	   <cfargument name="spect_name" default="">
       <cfargument name="short_code_id" default="">
       <cfargument name="short_code_name" default="">
       <cfargument name="start_date" default="">
	   <cfargument name="start_date_2" default="">
	   <cfargument name="finish_date" default="">
	   <cfargument name="finish_date_2" default="">
       <cfargument name="production_stage" default="">
       <cfargument name="fuseaction_" default="">
       <cfargument name="P_ORDER_NO1" default="">
       <cfargument name="DEMAND_NO1" default="">
       <cfargument name="LOT_NO1" default="">
       <cfargument name="REFERENCE_NO1" default="">
       <cfargument name="order_no_filter" default="">
       <cfargument name="PRODUCT_NAME1" default="">
        
        
     
	 <cfif len(arguments.P_ORDER_NO1) or len(arguments.DEMAND_NO1) or len(arguments.LOT_NO1) or len(arguments.REFERENCE_NO1) or len(arguments.PRODUCT_NAME1) >
        
		<cfelse>
        	<cfset arguments.P_ORDER_NO1 = 1 >
            <cfset arguments.DEMAND_NO1 = 1 >
            <cfset arguments.LOT_NO1 = 1 >
            <cfset arguments.REFERENCE_NO1 = 1 >
            <cfset arguments.PRODUCT_NAME1 = 1 >
      </cfif>
      
       
	  
        

        
   <cfquery name="CFC_GET_PRODUCTION_ORDERS" datasource="#this.DSN3#">
		WITH CTE1 AS (
                           SELECT
                                 po.STATION_ID,
                                 po.SPECT_VAR_NAME,
                                 PO.SPECT_VAR_ID,
                                 S.PROPERTY, 
                                 S.PRODUCT_ID,
                                 S.STOCK_ID,
                                 PO.IS_GROUP_LOT,
                                 PO.P_ORDER_ID,
                                 PO.P_ORDER_NO,
                                 PO.DEMAND_NO,
                                 sip_no.ORDER_NUMBER_AND_CARI,
                                 PO.LOT_NO,
                                 ICT.INTERNAL_NUMBER,
                                 S.STOCK_CODE,
                                 S.PRODUCT_NAME,
                                 PO.SPEC_MAIN_ID,
                                (CAST(PO.SPEC_MAIN_ID AS NVARCHAR(25)) + '-' + CONVERT(NVARCHAR(25), ISNULL(PO.SPECT_VAR_ID, 0))) AS spec,
                                 W.STATION_NAME,
                                 PTR.STAGE,
                                 PO.START_DATE,
                                 PO.FINISH_DATE,
                                 PO.QUANTITY,
                                 ISNULL(uretilen.ORDER_AMOUNT, 0)  AS RESULT_AMOUNT,
                                 (ISNULL(PO.QUANTITY, 0) -ISNULL(uretilen.ORDER_AMOUNT, 0)) AS kalan,
                                 PU.MAIN_UNIT,
                                 PO.IS_STAGE
                         FROM   PRODUCTION_ORDERS AS PO
                                JOIN STOCKS AS S
                             ON PO.STOCK_ID = S.STOCK_ID
                                JOIN PRODUCT_UNIT AS PU
                             ON PU.PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID
                                LEFT JOIN WORKSTATIONS AS W
                             ON PO.STATION_ID = W.STATION_ID
                      LEFT JOIN (
                                                  SELECT DISTINCT     PRODUCTION_ORDER_ID,
                                                   (
                                                      SELECT ', ' + ORDER_NUMBER + ':' + FULLNAME
                                                      FROM(
                                                           SELECT POR.PRODUCTION_ORDER_ID,
                                                                  o.ORDER_NUMBER,
                                                                  CASE 
                                                                  WHEN C.COMPANY_ID IS NOT NULL THEN 
                                                                  C.FULLNAME
                                                                  WHEN CN.CONSUMER_ID IS NOT 
                                                                  NULL THEN CN.CONSUMER_NAME
                                                                  + ' ' + CN.CONSUMER_SURNAME
                                                                  END AS FULLNAME
                                                           FROM   PRODUCTION_ORDERS_ROW AS POR
                                                                  JOIN ORDERS o
                                                               ON o.ORDER_ID = POR.ORDER_ID
                                                             LEFT JOIN #this.dsn#.COMPANY C
                                                               ON  C.COMPANY_ID = O.COMPANY_ID
                                                        LEFT JOIN #this.dsn#.CONSUMER CN
                                                               ON  CN.CONSUMER_ID = O.CONSUMER_ID
                                                        <cfif len(arguments.order_no_filter)>
                                                         WHERE 
                                                            ORDER_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.order_no_filter#%">
                                                        </cfif>
                                                     ) AS XXX1
                                                 WHERE  XXX1.PRODUCTION_ORDER_ID = XXX.PRODUCTION_ORDER_ID 
                                                 FOR XML PATH('')
                                                ) AS ORDER_NUMBER_AND_CARI
                                                FROM(
                                                SELECT POR.PRODUCTION_ORDER_ID,
                                                       o.ORDER_NUMBER,
                                                       CASE 
                                                       WHEN C.COMPANY_ID IS NOT NULL THEN C.FULLNAME
                                                       WHEN CN.CONSUMER_ID IS NOT NULL THEN CN.CONSUMER_NAME
                                                       + ' ' + CN.CONSUMER_SURNAME
                                                       END AS FULLNAME
                                                  FROM PRODUCTION_ORDERS_ROW AS POR
                                                  JOIN ORDERS o
                                                    ON o.ORDER_ID = POR.ORDER_ID
                                             LEFT JOIN #this.dsn#.COMPANY C
                                                    ON C.COMPANY_ID = O.COMPANY_ID
                                             LEFT JOIN #this.dsn#.CONSUMER CN
                                                    ON CN.CONSUMER_ID = O.CONSUMER_ID
                                             <cfif len(arguments.order_no_filter)>
                                             WHERE 
                                                  ORDER_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.order_no_filter#%">
                                             </cfif>            
                                                     ) AS XXX
                                              GROUP BY
                                                       PRODUCTION_ORDER_ID
                              ) AS sip_no
                            ON  sip_no.PRODUCTION_ORDER_ID = PO.P_ORDER_ID
                     LEFT JOIN (
                                 SELECT I.INTERNAL_NUMBER,
                                 IR.WRK_ROW_ID
                                 FROM   INTERNALDEMAND I
                                 JOIN INTERNALDEMAND_ROW IR
                                 ON  I.INTERNAL_ID = IR.I_ID
                               ) AS ICT
                             ON ICT.WRK_ROW_ID = ISNULL(PO.WRK_ROW_RELATION_ID, 0)
                      LEFT JOIN (
                                  SELECT poo.P_ORDER_ID,
                                  SUM(POR.AMOUNT) ORDER_AMOUNT
                                  FROM   PRODUCTION_ORDER_RESULTS_ROW AS POR
                                  JOIN PRODUCTION_ORDER_RESULTS AS POO
                                  ON  POR.PR_ORDER_ID = POO.PR_ORDER_ID
                                  JOIN PRODUCTION_ORDERS
                                  ON  POO.P_ORDER_ID = PRODUCTION_ORDERS.P_ORDER_ID
                                  AND POR.SPEC_MAIN_ID = PRODUCTION_ORDERS.SPEC_MAIN_ID
                                  WHERE  POR.TYPE = 1
                                  AND POO.IS_STOCK_FIS = 1
                                  GROUP BY
                                  poo.P_ORDER_ID
                                 )AS uretilen
                              ON  uretilen.P_ORDER_ID = po.P_ORDER_ID
                      LEFT JOIN #this.dsn#.PROCESS_TYPE_ROWS PTR
                           ON  PO.PROD_ORDER_STAGE = PTR.PROCESS_ROW_ID
                           
             WHERE  PO.IS_STAGE <> -1
                    <cfif isdefined('arguments.keyword') and len(arguments.keyword)>
						<cfif arguments.fuseaction_ contains 'demands'>
							AND 
							(	
								(1=2)   
								<cfif len(arguments.P_ORDER_NO1)>
                                	OR (P_ORDER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI) 
								</cfif>
                                <cfif len(arguments.DEMAND_NO1)>
                                    OR
                                    (DEMAND_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI)
								</cfif>
                                <cfif len(arguments.LOT_NO1)>
                                    OR
                                    (LOT_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI)
								</cfif>
                                <cfif len(arguments.REFERENCE_NO1)>
                                OR 
								(REFERENCE_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI)
								</cfif>
                                <cfif len(arguments.PRODUCT_NAME1)>
                                OR
								(PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI)
                                </cfif>
							)
						<cfelse>
							<cfif ListLen(arguments.keyword,',') gt 1>
								AND
								(
								<cfset p_sayac = 0>
								<cfloop list="#arguments.keyword#" delimiters="," index="p_or_no">
								<cfset p_sayac = p_sayac+1>
								(P_ORDER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#p_or_no#"> OR DEMAND_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#p_or_no#"> OR REFERENCE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#p_or_no#"> OR LOT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#p_or_no#">) <cfif ListLen(arguments.keyword,',') gt p_sayac>OR </cfif>
								</cfloop>
								)
							<cfelse><!--- tek bir tane ise like ile baksın.. --->
                            
								AND 
								(
                                	(1=2)   
									<cfif len(arguments.P_ORDER_NO1)>
                                        OR
                                        (P_ORDER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI) 
									</cfif>
                                    <cfif len(arguments.DEMAND_NO1)>
                                        OR 
                                        (DEMAND_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI) 
									</cfif>
									<cfif len(arguments.REFERENCE_NO1)>
                                        OR 
                                        (REFERENCE_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI)
									</cfif>
                                    <cfif len(arguments.LOT_NO1)>
                                        OR
                                        (LOT_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI)
									</cfif>
                                    
                                    <cfif len(arguments.PRODUCT_NAME1)>
                                        OR
                                        (PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI)
									</cfif>
                                )
							</cfif>
						</cfif>
					</cfif>
                    <cfif len(arguments.order_no_filter)>
                         AND sip_no.PRODUCTION_ORDER_ID IS NOT NULL
					</cfif>
                    <cfif isdefined('arguments.station_id') and len(arguments.station_id)>
                            <cfif arguments.station_id eq 0>
                                AND W.STATION_ID IS NULL
                            <cfelse>
                                AND (
                                     (W.STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.station_id#">)
                                     OR
                                     (W.STATION_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.station_list#" list="yes">) )
                                     )
                            </cfif>
                        <cfelseif len(arguments.authority_station_id_list)><!--- eğer istasyon seçilmemiş ise,sadece yetkili istasyonlar gelsin. --->
                            AND (W.STATION_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.authority_station_id_list#" list="yes">) OR W.STATION_ID IS NULL)
                        </cfif>
                        <cfif isdefined('arguments.prod_order_stage') and len(arguments.prod_order_stage)>
                           AND PROD_ORDER_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.prod_order_stage#">
                        </cfif>
                        <cfif isDefined('arguments.related_orders') and arguments.related_orders eq 1>
							AND (PO_RELATED_ID IS NULL OR PO.PO_RELATED_ID IS NOT NULL)
						<cfelseif isDefined('arguments.related_orders') and arguments.related_orders eq 2>
							AND PO_RELATED_ID IS NULL
						<cfelseif isDefined('arguments.related_orders') and arguments.related_orders eq 3> 
							AND PO_RELATED_ID IS NOT NULL
						</cfif>
                       <!--- <cfif <!---<!---arguments.fuseaction_ contains 'operations'---> and---> isdefined('arguments.result') and arguments.result eq 1>
						    AND PO.P_ORDER_ID IN (SELECT PRODUCTION_OPERATION_RESULT.OPERATION_ID FROM PRODUCTION_OPERATION_RESULT)
					        <cfelse>--->
						    <cfif isdefined('arguments.result') and arguments.result eq 1>
							AND PO.P_ORDER_ID IN (SELECT PRODUCTION_ORDER_RESULTS.P_ORDER_ID FROM PRODUCTION_ORDER_RESULTS)
						   <cfelseif isdefined('arguments.result') and arguments.result eq 0>
							AND PO.P_ORDER_ID NOT IN (SELECT PRODUCTION_ORDER_RESULTS.P_ORDER_ID FROM PRODUCTION_ORDER_RESULTS)
						   </cfif>
					   <!---</cfif>--->
                     <cfif isDefined('arguments.status') and arguments.status eq 1>
						AND (STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> OR STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="1">)
					   <cfelseif isDefined('arguments.status') and arguments.status eq 2>
						AND STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
					  <cfelseif isDefined('arguments.status') and arguments.status eq 3> 
						AND STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                    </cfif>
                    <cfif isdefined("arguments.member_type") and (arguments.member_type is 'partner') and len(arguments.member_name) and len(arguments.company_id)>
						AND PO.P_ORDER_ID IN(
											SELECT 
												PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID
											FROM
												PRODUCTION_ORDERS_ROW,
												ORDERS
											WHERE
												PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID
												AND ORDERS.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
										)
					</cfif>
					<cfif isdefined("arguments.member_type") and (arguments.member_type is 'consumer') and len(arguments.member_name) and len(arguments.consumer_id)>
						AND PO.P_ORDER_ID IN(
											SELECT 
												PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID
											FROM
												PRODUCTION_ORDERS_ROW,
												ORDERS
											WHERE
												PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID
												AND ORDERS.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
										)
					</cfif>
         <!---           <cfif isdefined('arguments.product_cat') and  len(arguments.product_cat) and len(arguments.product_catid)>
						AND S.PRODUCT_CATID IN(SELECT 
														PC1.PRODUCT_CATID
													FROM 
														PRODUCT_CAT PC1,
														PRODUCT_CAT PC2 
													WHERE 
														PC2.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_catid#">
														AND (PC2.HIERARCHY LIKE PC1.HIERARCHY+'.%' OR PC1.HIERARCHY LIKE PC2.HIERARCHY+'.%' OR PC1.PRODUCT_CATID=PC2.PRODUCT_CATID)
													)
					</cfif>--->
                    <cfif len(arguments.product_cat) and isDefined("arguments.product_cat_code") and len(arguments.product_cat_code)>
                        AND STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#PRODUCT_CAT_CODE#%">
                    </cfif>
                    <cfif isDefined("arguments.position_code") and len(arguments.position_code) and len(arguments.position_name)>
						AND S.PRODUCT_CATID IN(SELECT 
														PC2.PRODUCT_CATID
													FROM 
														PRODUCT_CAT PC1,
														PRODUCT_CAT PC2 
													WHERE 
														PC1.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position_code#">
														AND (PC2.HIERARCHY LIKE PC1.HIERARCHY+'.%' OR PC1.HIERARCHY LIKE PC2.HIERARCHY+'.%' OR PC1.PRODUCT_CATID=PC2.PRODUCT_CATID)
													)
					</cfif>
                    <cfif isdefined('arguments.order_employee') and len(arguments.order_employee) and len(arguments.order_employee_id)>
						AND PO.P_ORDER_ID IN(
											SELECT 
												PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID
											FROM
												PRODUCTION_ORDERS_ROW,
												ORDERS
											WHERE
												PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID
												AND ORDERS.ORDER_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_employee_id#">
										)		
					</cfif>
                    <cfif isdefined("arguments.related_product_id") and len(arguments.related_stock_id) and len(arguments.related_product_id) and len(arguments.related_product_name)>
						(
							PO.P_ORDER_ID IN (SELECT 
                                              PRODUCTION_ORDERS_STOCKS.P_ORDER_ID 
                                              FROM PRODUCTION_ORDERS_STOCKS 
                                              WHERE PRODUCTION_ORDERS_STOCKS.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.related_stock_id#">)
						)
						AND
					</cfif><!---hammadde--->
                    <cfif isdefined('arguments.project_head') and len(arguments.project_head) and len(arguments.project_id)>
						AND PO.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">
					</cfif>
                     <cfif isdefined('arguments.product_id') and len(arguments.product_id) and len(arguments.product_name)>
                        AND S.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">
                     </cfif><!---ürün--->
                     <cfif isdefined('arguments.spect_main_id') and isdefined('arguments.spect_name') and len(arguments.spect_name)>
						AND PRODUCTION_ORDERS.SPECT_VAR_ID IN(SELECT SPECT_VAR_ID FROM SPECTS WHERE SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.spect_main_id#">)
					</cfif>
                    <cfif isdefined("arguments.short_code_id") and len(arguments.short_code_id) and len(arguments.short_code_name)>
						AND	S.SHORT_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.short_code_id#">
					</cfif>
                    <cfif isdefined('arguments.start_date') and isdate(arguments.start_date)>
                        AND START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
                    </cfif>
                    <cfif isdefined('arguments.start_date_2') and isdate(arguments.start_date_2)>
                        AND START_DATE < #DATEADD('d',1,arguments.start_date_2)#
                    </cfif>
                    <cfif isdefined('arguments.finish_date') and isdate(arguments.finish_date)>
                        AND FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
                    </cfif>
                    <cfif isdefined('arguments.finish_date_2') and isdate(arguments.finish_date_2)>
                        AND FINISH_DATE < #DATEADD('d',1,arguments.finish_date_2)#
                    </cfif>
             		<cfif arguments.fuseaction_ contains 'order' or arguments.fuseaction_ contains 'operations'><!---Operasyonlar veya Emirler ise : Operatöre Gönderilmiş. --->
						<cfif not isdefined("arguments.production_stage") or not listlen(arguments.production_stage)>
							AND PO.IS_STAGE <> <cfqueryparam cfsqltype="cf_sql_integer" value="-1">
						<cfelse>
							AND PO.IS_STAGE IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.production_stage#" list="yes">)
						</cfif>
					<cfelseif arguments.fuseaction_ contains 'demands'><!--- TALEPLER İSE : BAŞLAMADI OLANLAR... --->
						AND PO.IS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="-1">
						AND PO.DEMAND_NO IS NOT NULL
					<cfelseif arguments.fuseaction_ contains 'in_productions'>
						<cfif not isdefined("arguments.production_stage") or not listlen(arguments.production_stage)>
							AND PO.IS_STAGE IN (<cfqueryparam cfsqltype="cf_sql_integer" value="1,3" list="yes">)
						<cfelse>
							AND PO.IS_STAGE IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.production_stage#" list="yes">)
						</cfif>
					</cfif>
        ),
           
            CTE2 AS 
            (
            	SELECT 
                	CTE1.*,
                    ROW_NUMBER() OVER (	
                    					ORDER BY
											<cfif isDefined('arguments.oby') and arguments.oby eq 2>
                                                P_ORDER_ID
                                            <cfelseif isDefined('arguments.oby') and arguments.oby eq 3>
                                                START_DATE DESC
                                            <cfelseif isDefined('arguments.oby') and arguments.oby eq 4>
                                                START_DATE
                                            <cfelse>
                                                P_ORDER_ID DESC
                                            </cfif>
									) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                FROM
                	CTE1
            )
			SELECT
				*
			FROM
				CTE2
            <cfif not (isdefined('arguments.is_excel') and arguments.is_excel eq 1)>
                WHERE
                    RowNum BETWEEN #arguments.startrow# and #arguments.startrow#+(#arguments.maxrows#-1)            
            </cfif>
		</cfquery>
		<cfreturn CFC_GET_PRODUCTION_ORDERS>
	</cffunction>
</cfcomponent>