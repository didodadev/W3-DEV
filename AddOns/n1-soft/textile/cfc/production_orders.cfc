<cfcomponent>
	<!---<cfinclude template="../../../fbx_workcube_funcs.cfm">--->
	<cffunction name="get_prod_order_fnc" returntype="query">
		<cfargument name="related_product_id" default="">
		<cfargument name="related_stock_id" default="">
		<cfargument name="related_product_name" default="">
		<cfargument name="production_stage" default="">
		<cfargument name="position_code" default="">
		<cfargument name="position_name" default="">
		<cfargument name="product_cat" default="">
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
		<cfargument name="operation_order" default="">
		<cfargument name="station_id" default="">
		<cfargument name="authority_station_id_list" default="">
		<cfargument name="related_orders" default="">
		<cfargument name="station_list" default="">
		<cfargument name="opplist" default="">
		<cfargument name="start_date" default="">
		<cfargument name="start_date_2" default="">
		<cfargument name="finish_date" default="">
		<cfargument name="finish_date_2" default="">
		<cfargument name="hafta" default="">
		<cfquery name="CFC_GET_PRODUCTION_ORDERS" datasource="#this.DSN3#">
				WITH CTE1 AS (
					SELECT
										PM.PARTY_ID,
										PM.PARTY_NO,
										PM.PARTY_STARTDATE,
										PM.PARTY_FINISHDATE,
										PM.STAGE PROD_ORDER_STAGE,
										PM.STATION_ID,
										ISNULL(PM.AMOUNT,0) PRODUCTION_ORDER_AMOUNT,
										ISNULL(TEXTILE_PRODUCTION_OPERATION_MAIN.AMOUNT,0) OPERATION_AMOUNT,
										SR.REQ_NO,
										SR.COMPANY_MODEL_NO,
										SR.COMPANY_ORDER_NO,
										O.ORDER_NUMBER,
										O.ORDER_ID,
										O.DELIVERDATE,
										PRO_PROJECTS.PROJECT_HEAD,
										PRO_PROJECTS.PROJECT_ID,
										PRODUCT.PRODUCT_ID,
										PRODUCT.PRODUCT_NAME,
										PRODUCT.PRODUCT_CODE,
										PRODUCT.PRODUCT_CODE_2,
										C.FULLNAME,
										ISNULL(PSM.RESULT_AMOUNT,0) RESULT_AMOUNT,
										OPERATION_TYPE,
										OPERATION_TYPES.OPERATION_TYPE_ID,
										TEXTILE_PRODUCTION_OPERATION.LINE,
										TEXTILE_PRODUCTION_OPERATION.P_OPERATION_ID
							FROM
								TEXTILE_PRODUCTION_ORDERS_MAIN PM
									OUTER APPLY(
										select 
											SUM(ISNULL(PRODUCTION_ORDERS.QUANTITY,0)) ORDER_AMOUNT,
											SUM(ISNULL(PRODUCTION_ORDER_RESULTS_ROW.AMOUNT,0)) RESULT_AMOUNT
										from 
											PRODUCTION_ORDERS_ROW,
											PRODUCTION_ORDERS
											LEFT JOIN PRODUCTION_ORDER_RESULTS_ROW ON PRODUCTION_ORDER_RESULTS_ROW.P_ORDER_ID=PRODUCTION_ORDERS.P_ORDER_ID AND PRODUCTION_ORDER_RESULTS_ROW.TYPE=1
										where
											PRODUCTION_ORDERS.P_ORDER_ID=PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID
											AND PRODUCTION_ORDERS_ROW.PLAN_ID=PM.P_OPERATION_ID
											AND PRODUCTION_ORDERS_ROW.ORDER_ID=PM.ORDER_ID
									) AS RESULT_
								LEFT JOIN TEXTILE_PRODUCTION_ORDER_RESULTS_MAIN PSM ON PSM.PARTY_ID=PM.PARTY_ID,
								TEXTILE_PRODUCTION_OPERATION_MAIN,
								TEXTILE_PRODUCTION_OPERATION,
								OPERATION_TYPES,
								TEXTILE_SAMPLE_REQUEST SR,
								#this.dsn#.COMPANY C,
								PRODUCT,
								ORDERS O
								LEFT JOIN #this.dsn#.PRO_PROJECTS ON O.PROJECT_ID=PRO_PROJECTS.PROJECT_ID
							
							WHERE
								PM.MAIN_OPERATION_ID=TEXTILE_PRODUCTION_OPERATION_MAIN.MAIN_OPERATION_ID AND
								TEXTILE_PRODUCTION_OPERATION.P_OPERATION_ID=PM.P_OPERATION_ID AND
								SR.REQ_ID=TEXTILE_PRODUCTION_OPERATION_MAIN.REQUEST_ID AND
								O.ORDER_ID=TEXTILE_PRODUCTION_OPERATION_MAIN.ORDER_ID AND
								OPERATION_TYPES.OPERATION_TYPE_ID=PM.OPERATION_TYPE_ID AND
								C.COMPANY_ID=SR.COMPANY_ID AND
								PRODUCT.PRODUCT_ID=PM.PRODUCT_ID

					<cfif len(arguments.product_id) and len(arguments.product_name)>
                		AND PRODUCT.PRODUCT_ID = #arguments.product_id#
                    </cfif>
					<cfif isdefined("arguments.related_product_id") and len(arguments.related_stock_id) and len(arguments.related_product_id) and len(arguments.related_product_name)>
						AND (
							PM.PARTY_ID IN (
												SELECT PRODUCTION_ORDERS.PARTY_ID 
												FROM 
														PRODUCTION_ORDERS_STOCKS,
														PRODUCTION_ORDERS
												WHERE 
												PRODUCTION_ORDERS_STOCKS.P_ORDER_ID=PRODUCTION_ORDERS.P_ORDER_ID AND
												PRODUCTION_ORDERS_STOCKS.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.related_stock_id#">
										)
						)
						
					</cfif>
					<cfif isDefined("arguments.position_code") and len(arguments.position_code) and len(arguments.position_name)>
						AND PRODUCT.PRODUCT_CATID IN(SELECT 
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
						AND PRODUCT.PRODUCT_CATID IN(SELECT 
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
						AND 
						PM.PARTY_ID IN (
							SELECT PARTY_ID FROM 
							PRODUCTION_ORDERS.SPECT_VAR_ID IN(SELECT SPECT_VAR_ID FROM SPECTS WHERE SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.spect_main_id#">)
							AND PARTY_ID=PM.PARTY_ID						
						)
					</cfif>
					<cfif isdefined("arguments.short_code_id") and len(arguments.short_code_id) and len(arguments.short_code_name)>
						AND	PRODUCT.SHORT_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.short_code_id#">
					</cfif>
					<cfif isdefined('arguments.keyword') and len(arguments.keyword)>
							<cfif ListLen(arguments.keyword,',') gt 1>
								AND
								(
									<cfset p_sayac = 0>
									<cfloop list="#arguments.keyword#" delimiters="," index="p_or_no">
									<cfset p_sayac = p_sayac+1>
									(PM.PARTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#p_or_no#"> OR PM.LOT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#p_or_no#"> OR O.ORDER_NUMBER=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#">) <cfif ListLen(arguments.keyword,',') gt p_sayac>OR </cfif>
									</cfloop>
								)
							<cfelse><!--- tek bir tane ise like ile baksın.. --->
								AND (O.ORDER_NUMBER LIKE '#arguments.keyword#%' OR SR.REQ_NO LIKE '#arguments.keyword#%')
								<!---AND 
								(
									(1=1)   
									<cfif len(arguments.P_ORDER_NO1)>
                                        OR (PM.PARTY_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">) 
                                    </cfif>
                                    <cfif len(arguments.DEMAND_NO1)>
                                        OR
                                        (PM.PARTY_ID IN 
											(SELECT 
											PRODUCTION_ORDERS.PARTY_ID
											FROM
												PRODUCTION_ORDERS_ROW,
												PRODUCTION_ORDERS
											WHERE
												PRODUCTION_ORDERS.P_ORDER_ID=PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID AND
												PRODUCTION_ORDERS.P_ORDER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
											)
										)
                                    </cfif>
                                    <cfif len(arguments.LOT_NO1)>
                                        OR
                                        (PM.LOT_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">)
                                    </cfif>
                                    <cfif len(arguments.REFERENCE_NO1)>
                                    OR 
                                    (REFERENCE_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">)
                                    </cfif>
                                    <cfif len(arguments.ORDER_NUMBER1)>
                                    OR
                                    (PM.PARTY_ID IN 
                                        (SELECT 
										   PRODUCTION_ORDERS.PARTY_ID
                                        FROM
                                            PRODUCTION_ORDERS_ROW,
											PRODUCTION_ORDERS,
                                            ORDERS
                                        WHERE
											PRODUCTION_ORDERS.P_ORDER_ID=PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID AND
                                            ORDERS.ORDER_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> AND 
                                            PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID)
									)
                                    </cfif>
                                    <cfif len(arguments.PRODUCT_NAME1)>
                                    OR
                                    (PRODUCT.PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">)
                                    </cfif>
                                    
								)--->
							</cfif>
					</cfif>
					<cfif isdefined('arguments.sales_partner') and len(arguments.sales_partner) and len(arguments.sales_partner_id)>
						AND PM.PARTY_ID IN(
											SELECT 
											 PRODUCTION_ORDERS.PARTY_ID
											FROM
												PRODUCTION_ORDERS_ROW,
												PRODUCTION_ORDERS,
												ORDERS
											WHERE
												PRODUCTION_ORDERS.P_ORDER_ID=PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID 
												AND PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID
												AND ORDERS.SALES_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sales_partner_id#">
												AND PRODUCTION_ORDERS.PARTY_ID=PM.PARTY_ID
										)			
					</cfif>
					<cfif isdefined('arguments.order_employee') and len(arguments.order_employee) and len(arguments.order_employee_id)>
						AND PM.PARTY_ID  IN(
											SELECT 
											PRODUCTION_ORDERS.PARTY_ID
											FROM
												PRODUCTION_ORDERS_ROW,
												PRODUCTION_ORDERS,
												ORDERS
											WHERE
											    PRODUCTION_ORDERS.P_ORDER_ID=PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID 
												AND PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID
												AND ORDERS.ORDER_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_employee_id#">
												AND PRODUCTION_ORDERS.PARTY_ID=PM.PARTY_ID
										)		
					</cfif>
					<cfif isdefined('arguments.project_head') and len(arguments.project_head) and len(arguments.project_id)>
						AND PM.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">
					</cfif>
					<cfif isdefined("arguments.member_type") and (arguments.member_type is 'partner') and len(arguments.member_name) and len(arguments.company_id)>
						AND PM.PARTY_ID IN(
											SELECT 
											PRODUCTION_ORDERS.PARTY_ID
											FROM
												PRODUCTION_ORDERS_ROW,
												PRODUCTION_ORDERS,
												ORDERS
											WHERE
											    PRODUCTION_ORDERS.P_ORDER_ID=PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID 
												AND PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID
												AND ORDERS.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
												AND PRODUCTION_ORDERS.PARTY_ID=PM.PARTY_ID
										)
					</cfif>
					<cfif isdefined("arguments.member_type") and (arguments.member_type is 'consumer') and len(arguments.member_name) and len(arguments.consumer_id)>
						AND PM.PARTY_ID IN(
											SELECT 
											    PRODUCTION_ORDERS.PARTY_ID
											FROM
												PRODUCTION_ORDERS_ROW,
												PRODUCTION_ORDERS,
												ORDERS
											WHERE
											    PRODUCTION_ORDERS.P_ORDER_ID=PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID 
												AND PRODUCTION_ORDERS_ROW.ORDER_ID = ORDERS.ORDER_ID
												AND ORDERS.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
												AND PRODUCTION_ORDERS.PARTY_ID=PM.PARTY_ID
										)
					</cfif>
					<cfif isdefined('arguments.result') and arguments.result eq 1>
						AND PM.PARTY_ID IN (
											select 
											          PRODUCTION_ORDERS.PARTY_ID
													from 
														PRODUCTION_ORDERS_ROW,
														PRODUCTION_ORDERS
										JOIN PRODUCTION_ORDER_RESULTS_ROW ON PRODUCTION_ORDER_RESULTS_ROW.P_ORDER_ID=PRODUCTION_ORDERS.P_ORDER_ID AND PRODUCTION_ORDER_RESULTS_ROW.TYPE=1
														
													where
														PRODUCTION_ORDERS.P_ORDER_ID=PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID
														AND PRODUCTION_ORDERS_ROW.ORDER_ID=O.ORDER_ID
														AND PRODUCTION_ORDERS.PARTY_ID=PM.PARTY_ID
										  )
					<cfelseif isdefined('arguments.result') and arguments.result eq 0>
						AND PM.PARTY_ID NOT IN (
													select 
											          PRODUCTION_ORDERS.PARTY_ID
													from 
														PRODUCTION_ORDERS_ROW,
														PRODUCTION_ORDERS
										JOIN PRODUCTION_ORDER_RESULTS_ROW ON PRODUCTION_ORDER_RESULTS_ROW.P_ORDER_ID=PRODUCTION_ORDERS.P_ORDER_ID AND PRODUCTION_ORDER_RESULTS_ROW.TYPE=1
														
													where
														PRODUCTION_ORDERS.P_ORDER_ID=PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID
														AND PRODUCTION_ORDERS_ROW.ORDER_ID=O.ORDER_ID
														AND PRODUCTION_ORDERS.PARTY_ID=PM.PARTY_ID
											)
					</cfif>
					<!---<cfif isDefined('arguments.status') and arguments.status eq 1>
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
					</cfif>--->



								),
           CTE2 AS (
				SELECT
					CTE1.*,
					ROW_NUMBER() OVER (	
                    					ORDER BY
											<cfif isDefined('arguments.oby') and arguments.oby eq 2>
												PARTY_ID,LINE
                                            <cfelseif isDefined('arguments.oby') and arguments.oby eq 3>
                                                PARTY_STARTDATE DESC,PARTY_ID,LINE
                                            <cfelseif isDefined('arguments.oby') and arguments.oby eq 4>
                                                PARTY_STARTDATE,PARTY_ID,LINE
                                            <cfelse>
                                                PARTY_ID DESC,PARTY_ID,LINE
                                            </cfif>
									) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
				FROM
					CTE1
		   )
		   SELECT
				CTE2.*
			FROM
				CTE2
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
		<cfargument name="opplist" default="">
		<cfquery name="CFC_GET_PRODUCTION_ORDERS_DETAIL" dbtype="query">
			SELECT 
				*
			FROM
				CFC_GET_PRODUCTION_ORDERS
			WHERE
				PARTY_ID IS NOT NULL
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
				
				<cfif isdefined('arguments.start_date') and isdate(arguments.start_date)>
					AND PARTY_STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
				</cfif>
				<cfif isdefined('arguments.start_date_2') and isdate(arguments.start_date_2)>
					AND PARTY_STARTDATE < #DATEADD('d',1,arguments.start_date_2)#
				</cfif>
				<cfif isdefined('arguments.finish_date') and isdate(arguments.finish_date)>
					AND PARTY_FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.finish_date#">
				</cfif>
				<cfif isdefined('arguments.finish_date_2') and isdate(arguments.finish_date_2)>
					AND PARTY_FINISHDATE < #DATEADD('d',1,arguments.finish_date_2)#
				</cfif>
				<cfif isdefined('arguments.prod_order_stage') and len(arguments.prod_order_stage)>
				AND PROD_ORDER_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.prod_order_stage#">
				</cfif>
				<cfif isdefined('arguments.opplist') and len(arguments.opplist)>
				and OPERATION_TYPE_ID IN(#arguments.opplist#)
				</cfif>
			
          
									   ORDER BY
									   <cfif isDefined('arguments.oby') and arguments.oby eq 2>
											PARTY_ID,LINE
										<cfelseif isDefined('arguments.oby') and arguments.oby eq 3>
											PARTY_STARTDATE DESC,PARTY_ID,LINE
										<cfelseif isDefined('arguments.oby') and arguments.oby eq 4>
											PARTY_STARTDATE,PARTY_ID,LINE
										<cfelse>
											PARTY_ID DESC,LINE 
										</cfif>
								 
		</cfquery>
		<cfreturn CFC_GET_PRODUCTION_ORDERS_DETAIL>
	</cffunction>
	<cffunction name="getOrders" returntype="query">
		<cfargument name="party_id" default="">
			<cfquery name="get_orders" datasource="#this.dsn3#">
					select	
							PM.PARTY_NO,
							PO.P_ORDER_NO,
							PO.PARTY_ID,
							PO.QUANTITY,
							PM.OPERATION_TYPE_ID,
							OPERATION_TYPES.OPERATION_TYPE,
							STOCKS.PRODUCT_NAME,
							ISNULL(PO.RESULT_AMOUNT,0) AS ROW_RESULT_AMOUNT,
							STOCKS.PROPERTY,
							STOCKS.STOCK_CODE,
							STOCKS.STOCK_CODE_2
						from
								#this.dsn3#.TEXTILE_PRODUCTION_ORDERS_MAIN PM,
								#this.dsn3#.PRODUCTION_ORDERS PO,
								#this.dsn3#.PRODUCT,
								#this.dsn3#.STOCKS,
								#this.dsn3#.OPERATION_TYPES
						WHERE
							PM.PARTY_ID=PO.PARTY_ID AND
							PM.PRODUCT_ID=PRODUCT.PRODUCT_ID AND 
							STOCKS.STOCK_ID=PO.STOCK_ID AND
							OPERATION_TYPES.OPERATION_TYPE_ID=PM.OPERATION_TYPE_ID AND
							PO.STATUS=1
							<cfif isdefined("arguments.party_id") and len(arguments.party_id)>
								AND PO.PARTY_ID=#arguments.party_id#
							</cfif>
			</cfquery>
			<cfreturn get_orders>
	</cffunction>
	<cffunction name="getOperation">
        <cfquery name="GET_OPERATION" datasource="#this.dsn3#">
				select 
					OPERATION_TYPE_ID,
					OPERATION_TYPE
				from OPERATION_TYPES
        </cfquery>
		<cfreturn GET_OPERATION>
    </cffunction>
</cfcomponent>