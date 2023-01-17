
<cfcomponent>

	<cffunction name="get_orders_fnc" returntype="query">
		<cfargument name="ajax" default="">
		<cfargument name="branch_id" default="">
		<cfargument name="station_id" default="">
		<cfargument name="department_id" default="">
		<cfargument name="stock_id_" default="">
		<cfargument name="product_name" default="">
		<cfargument name="durum_siparis" default="">
		<cfargument name="priority" default="">
		<cfargument name="position_code" default="">
		<cfargument name="position_name" default="">
		<cfargument name="short_code_id" default="">
		<cfargument name="short_code_name" default="">
		<cfargument name="keyword" default="">
		<cfargument name="start_date" default="">
		<cfargument name="finish_date" default="">
		<cfargument name="start_date_order" default="">
		<cfargument name="finish_date_order" default="">
		<cfargument name="sales_partner" default="">
		<cfargument name="sales_partner_id" default="">
		<cfargument name="order_employee" default="">
		<cfargument name="order_employee_id" default="">
		<cfargument name="member_name" default="">
		<cfargument name="company_id" default="">
		<cfargument name="consumer_id" default="">
		<cfargument name="pro_member_name" default="">
		<cfargument name="pro_company_id" default="">
		<cfargument name="pro_consumer_id" default="">
		<cfargument name="project_head" default="">
		<cfargument name="project_id" default="">
		<cfargument name="member_cat_type" default="">
		<cfargument name="spect_main_id" default="">
		<cfargument name="product_id_" default="">
		<cfargument name="spect_name" default="">
		<cfargument name="category_name" default="">
		<cfargument name="category" default="">
		<cfargument name="date_filter" default="">
		
		<cfif isdefined('arguments.ajax')><!--- Üretimdeki Çizelge Sayfasından geliyor ise --->
			<cfif isdefined('arguments.branch_id') and len(arguments.branch_id) and isdefined('arguments.station_id') and not len(arguments.station_id)><!--- Şube veya departman seçilmiş ancak istasyon seçilmemiş ise --->
				<cfquery name="GET_BRANCH_STATIONS" datasource="#this.DSN3#">
					SELECT STATION_ID FROM WORKSTATIONS WHERE BRANCH = #arguments.branch_id# <cfif isdefined('arguments.department_id')and len(arguments.department_id)> AND DEPARTMENT = #arguments.department_id#</cfif>
				</cfquery>
				<cfset arguments.station_id = ValueList(GET_BRANCH_STATIONS.STATION_ID,',')>
			</cfif>
			<!--- İstasyon SEçilmiş ise --->
			<cfif isdefined('arguments.station_id') and len(arguments.station_id)><!--- İstasyon seçili ise --->
				<cfquery name="GET_STATIONS_PRODUCT" datasource="#this.DSN3#">
					SELECT STOCK_ID FROM WORKSTATIONS_PRODUCTS WHERE WS_ID IN (#arguments.station_id#)
				</cfquery>
				<cfset station_stock_id_list = ValueList(GET_STATIONS_PRODUCT.STOCK_ID,',')>
			</cfif>				
		</cfif>
		<cfquery name="GET_ORDERS" datasource="#this.DSN3#">
		
			select 
					O.ORDER_NUMBER,
					O.COMPANY_ID,
					O.CONSUMER_ID,
					O.ORDER_ID,
					P.PRODUCT_ID,
					P.PRODUCT_NAME,
					O.ORDER_NUMBER,
					O.PROJECT_ID,
					P.PRODUCT_ID,
					P.PRODUCT_NAME,
					P.PRODUCT_CODE,
					P.PRODUCT_CODE_2,
					O.ORDER_DATE,
					O.DELIVERDATE,
					PU.ADD_UNIT UNIT,
					'' ORDER_ROW_ID,
						'' STOCK_CODE,
						'' STOCK_CODE_2,
						'' STOCK_ID,
						'' PROPERTY,
						'' SPECT_VAR_ID,
						NUMUNE_.*,
						NUMUNE_.REQ_ID PLAN_ID,
						'' RENK_ID,
						1 OPERASYON_ID,
						1 IS_TEX,
						1 IS_PROD,
					0 UNIT_ID,
					OPERATION_.MAIN_OPERATION_ID,
					ISNULL(OPERATION_.MARJ, ISNULL((SELECT TOP 1 IPS.PROPERTY9 FROM #this.dsn_alias#.INFO_PLUS IPS 
						 INNER JOIN TEXTILE_SAMPLE_REQUEST TSR ON IPS.OWNER_ID = TSR.COMPANY_ID
						 WHERE IPS.INFO_OWNER_TYPE = -1 AND TSR.REQ_ID = NUMUNE_.REQ_ID),0)) MARJ,
					ISNULL(OPERATION_.IS_SEND,0) IS_SEND,
					ISNULL(OPERATION_.AMOUNT,0) OPERATION_AMOUNT,
					ASSET.ASSET_ID,
					ASSET.ASSETCAT_ID,
					ASSET.ASSET_FILE_NAME,
					SUM(ORDER_ROW.QUANTITY) QUANTITY,
					ISNULL(RESULT_FINISH.ORDER_AMOUNT,0) FINISH_ORDER_AMOUNT,
                    ISNULL(RESULT_FINISH.RESULT_AMOUNT,0) FINISH_RESULT_AMOUNT,
                    RESULT_FINISH.OPERATION_TYPE_ID AS FINISH_OPERATION_TYPE_ID
			from 
					ORDER_ROW
					OUTER APPLY (
					SELECT
						TOP 1 
							R.REQ_ID,
							R.REQ_NO,
							R.REQ_HEAD,
							R.SHORT_CODE,
							R.REQ_TYPE_ID,
							R.COMPANY_ORDER_NO,
							R.COMPANY_MODEL_NO,
							PRO_PROJECTS.PROJECT_HEAD,
							PRO_PROJECTS.PROJECT_DETAIL,
							COMPANY.FULLNAME + ' - ' + COMPANY.NICKNAME AS PROJECT_COMPANY
						FROM
							TEXTILE_SAMPLE_REQUEST R
							LEFT JOIN #THIS.DSN_ALIAS#.PRO_PROJECTS ON  PRO_PROJECTS.PROJECT_ID=R.PROJECT_ID
							LEFT JOIN #THIS.DSN_ALIAS#.COMPANY ON COMPANY.COMPANY_ID=PRO_PROJECTS.COMPANY_ID
							WHERE 
								R.REQ_ID=ORDER_ROW.RELATED_ACTION_ID
					)
					 NUMUNE_
					 OUTER APPLY(
						select
							TOP 1 
							ASSET_ID,
							ASSETCAT_ID,
							ASSET_FILE_NAME
						FROM
							#THIS.DSN_ALIAS#.ASSET
							where
								ACTION_SECTION='REQ_ID' AND 
								ACTION_ID=NUMUNE_.REQ_ID AND
								IS_IMAGE=1 AND
								MODULE_NAME='textile'
								ORDER BY ASSET_ID
					) ASSET,
					 ORDERS O
					 OUTER APPLY (
					SELECT
							TEXTILE_PRODUCTION_OPERATION_MAIN.MAIN_OPERATION_ID,
							ISNULL(TEXTILE_PRODUCTION_OPERATION_MAIN.IS_SEND,0) IS_SEND,
							ISNULL(TEXTILE_PRODUCTION_OPERATION_MAIN.MARJ,0) MARJ,
							AMOUNT
						FROM
							TEXTILE_PRODUCTION_OPERATION_MAIN
							WHERE 
							TEXTILE_PRODUCTION_OPERATION_MAIN.ORDER_ID=O.ORDER_ID
					)
					 OPERATION_
					 OUTER APPLY(
                            select 
                                SUM(ISNULL(PRODUCTION_ORDERS.QUANTITY,0)) ORDER_AMOUNT,
                                SUM(ISNULL(PRODUCTION_ORDER_RESULTS_ROW.AMOUNT,0)) RESULT_AMOUNT,
                                TPOP.OPERATION_TYPE_ID
                            from 
                                PRODUCTION_ORDERS_ROW,
                                PRODUCTION_ORDERS
            LEFT JOIN PRODUCTION_ORDER_RESULTS_ROW ON PRODUCTION_ORDER_RESULTS_ROW.P_ORDER_ID=PRODUCTION_ORDERS.P_ORDER_ID AND PRODUCTION_ORDER_RESULTS_ROW.TYPE=1
                                ,TEXTILE_PRODUCTION_OPERATION TPOP
                            where
                                PRODUCTION_ORDERS.P_ORDER_ID=PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID
                                <!---AND PRODUCTION_ORDERS_ROW.ORDER_ROW_ID=ORR.ORDER_ROW_ID--->
                                AND PRODUCTION_ORDERS_ROW.ORDER_ID=O.ORDER_ID
                                AND PRODUCTION_ORDERS_ROW.PLAN_ID=TPOP.P_OPERATION_ID
                                AND TPOP.MAIN_OPERATION_ID=OPERATION_.MAIN_OPERATION_ID
                                AND TPOP.IS_FINISH_LINE=1
                            GROUP BY
                            TPOP.OPERATION_TYPE_ID
                        ) AS RESULT_FINISH,
					PRODUCT P,
					PRODUCT_UNIT PU
					
			WHERE
					O.ORDER_ID=ORDER_ROW.ORDER_ID AND
					P.PRODUCT_ID=ORDER_ROW.PRODUCT_ID AND
					P.PRODUCT_ID=PU.PRODUCT_ID AND
					ORDER_ROW.RELATED_ACTION_TABLE='TEXTILE_SAMPLE_REQUEST' AND
					ORDER_ROW.ORDER_ROW_CURRENCY = -5 AND
					NUMUNE_.REQ_ID IS NOT NULL
										<cfif arguments.durum_siparis eq 1>
										AND O.ORDER_ID IN(
											SELECT PROD_MAIN.ORDER_ID FROM TEXTILE_PRODUCTION_ORDERS_MAIN PROD_MAIN
																	WHERE 
																	PROD_MAIN.ORDER_ID=O.ORDER_ID
											)
										<cfelseif arguments.durum_siparis eq 0>
											AND O.ORDER_ID  not IN(
												SELECT PROD_MAIN.ORDER_ID FROM TEXTILE_PRODUCTION_ORDERS_MAIN PROD_MAIN
																	WHERE 
																	PROD_MAIN.ORDER_ID=O.ORDER_ID
											)
										<cfelseif arguments.durum_siparis eq 2>
											AND O.ORDER_ID  IN(
												SELECT OPERATION_MAIN.ORDER_ID FROM TEXTILE_PRODUCTION_OPERATION_MAIN OPERATION_MAIN
																	WHERE 
																	OPERATION_MAIN.ORDER_ID=O.ORDER_ID AND IS_SEND=1
											)
										<cfelseif arguments.durum_siparis eq 3>
											AND O.ORDER_ID NOT IN(
												SELECT OPERATION_MAIN.ORDER_ID FROM TEXTILE_PRODUCTION_OPERATION_MAIN OPERATION_MAIN
																	WHERE 
																	OPERATION_MAIN.ORDER_ID=O.ORDER_ID AND IS_SEND=1
											)
										<cfelseif arguments.durum_siparis eq 4>
											AND O.ORDER_ID  IN(
													select 
														PRODUCTION_ORDERS_ROW.ORDER_ID
													from 
														PRODUCTION_ORDERS_ROW,
														PRODUCTION_ORDERS
										JOIN PRODUCTION_ORDER_RESULTS_ROW ON PRODUCTION_ORDER_RESULTS_ROW.P_ORDER_ID=PRODUCTION_ORDERS.P_ORDER_ID AND PRODUCTION_ORDER_RESULTS_ROW.TYPE=1
														,TEXTILE_PRODUCTION_OPERATION TPOP
													where
														PRODUCTION_ORDERS.P_ORDER_ID=PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID
														AND PRODUCTION_ORDERS_ROW.ORDER_ID=O.ORDER_ID
														AND PRODUCTION_ORDERS_ROW.PLAN_ID=TPOP.P_OPERATION_ID
														AND TPOP.MAIN_OPERATION_ID=OPERATION_.MAIN_OPERATION_ID
														AND TPOP.IS_FINISH_LINE=1
											)
										<cfelseif arguments.durum_siparis eq 5>
											AND O.ORDER_ID NOT IN(
													select 
															PRODUCTION_ORDERS_ROW.ORDER_ID
														from 
															PRODUCTION_ORDERS_ROW,
															PRODUCTION_ORDERS
											JOIN PRODUCTION_ORDER_RESULTS_ROW ON PRODUCTION_ORDER_RESULTS_ROW.P_ORDER_ID=PRODUCTION_ORDERS.P_ORDER_ID AND PRODUCTION_ORDER_RESULTS_ROW.TYPE=1
															,TEXTILE_PRODUCTION_OPERATION TPOP
														where
															PRODUCTION_ORDERS.P_ORDER_ID=PRODUCTION_ORDERS_ROW.PRODUCTION_ORDER_ID
															AND PRODUCTION_ORDERS_ROW.ORDER_ID=O.ORDER_ID
															AND PRODUCTION_ORDERS_ROW.PLAN_ID=TPOP.P_OPERATION_ID
															AND TPOP.MAIN_OPERATION_ID=OPERATION_.MAIN_OPERATION_ID
															AND TPOP.IS_FINISH_LINE=1
											)
										</cfif>
								<cfif len(arguments.keyword)>
										AND (
												O.ORDER_NUMBER LIKE '<cfif len(arguments.keyword) gt 2>%</cfif>#arguments.keyword#%'
												 OR
												NUMUNE_.REQ_NO LIKE '<cfif len(arguments.keyword) gt 2>%</cfif>#arguments.keyword#%'
										    )
								</cfif>
								<cfif len(arguments.start_date)>
											AND O.DELIVERDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.start_date#">
								</cfif>
								<cfif len(arguments.finish_date)>
											AND O.DELIVERDATE < #DATEADD('d',1,arguments.finish_date)#
								</cfif>
								<cfif len(arguments.start_date_order)>
									AND O.ORDER_DATE >= #arguments.start_date_order#
								</cfif>
								<cfif len(arguments.finish_date_order)>
									AND O.ORDER_DATE < #DATEADD('d',1,arguments.finish_date_order)#
								</cfif>
								<cfif len(arguments.sales_partner) and len(arguments.sales_partner_id)>
									AND O.SALES_PARTNER_ID = #arguments.sales_partner_id#
								</cfif>
								<cfif len(arguments.order_employee) and len(arguments.order_employee_id)>
									AND O.ORDER_EMPLOYEE_ID = #arguments.order_employee_id#
								</cfif>
								<cfif len(arguments.member_name) and len(arguments.company_id)><!--- (arguments.member_type is 'partner') and  --->
									AND O.COMPANY_ID = #arguments.company_id#
								</cfif>
								<cfif len(arguments.member_name) and len(arguments.consumer_id)><!--- (arguments.member_type is 'consumer') and  --->
									AND O.CONSUMER_ID = #arguments.consumer_id#
								</cfif>
								<cfif len(arguments.pro_member_name) and len(arguments.pro_company_id)><!--- (arguments.member_type is 'partner') and  --->
									AND O.PROJECT_ID IN(
										SELECT 
											PROJECT_ID FROM #this.dsn_alias#.PRO_PROJECTS 
											WHERE 
												COMPANY_ID=#arguments.pro_company_id#
									)
								</cfif>
								<cfif len(arguments.pro_member_name) and len(arguments.pro_consumer_id)><!--- (arguments.member_type is 'consumer') and  --->
									AND O.PROJECT_ID IN(
										SELECT 
											PROJECT_ID FROM #this.dsn_alias#.PRO_PROJECTS 
											WHERE 
												CONSUMER_ID=#arguments.pro_consumer_id#
									) 
								</cfif>
								<cfif isdefined('arguments.project_head') and len(arguments.project_head) and len(arguments.project_id)>
									AND O.PROJECT_ID = #arguments.project_id#	
								</cfif>
								<cfif isdefined("arguments.member_cat_type") and listlen(arguments.member_cat_type,'-') eq 2 and listfirst(arguments.member_cat_type,'-') eq '1'>
									AND O.COMPANY_ID IN (SELECT COMPANY_ID FROM #this.dsn_alias#.COMPANY WHERE COMPANYCAT_ID = #listlast(arguments.member_cat_type,'-')#) 
								<cfelseif isdefined("arguments.member_cat_type") and arguments.member_cat_type eq 1>
									AND O.COMPANY_ID IN (SELECT C.COMPANY_ID  FROM #this.dsn_alias#.COMPANY C,#this.dsn_alias#.COMPANY_CAT CAT WHERE C.COMPANYCAT_ID = CAT.COMPANYCAT_ID)
								</cfif>
								<cfif isdefined("arguments.member_cat_type") and listlen(arguments.member_cat_type,'-') eq 2 and listfirst(arguments.member_cat_type,'-') eq '2'>
									AND O.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #this.dsn_alias#.CONSUMER WHERE CONSUMER_CAT_ID = #listlast(arguments.member_cat_type,'-')#)
								<cfelseif isdefined("arguments.member_cat_type") and arguments.member_cat_type eq 2>
									AND O.CONSUMER_ID IN (SELECT C.CONSUMER_ID FROM #this.dsn_alias#.CONSUMER C,#this.dsn_alias#.CONSUMER_CAT CAT WHERE C.CONSUMER_CAT_ID = CAT.CONSCAT_ID)
								</cfif>
									<cfif len(arguments.priority)>
										AND O.PRIORITY_ID = #arguments.priority#
									</cfif>
					
			GROUP BY
				O.ORDER_NUMBER,
					O.ORDER_ID,
					P.PRODUCT_ID,
					P.PRODUCT_NAME,
					O.ORDER_NUMBER,
					O.COMPANY_ID,
					O.CONSUMER_ID,
					P.PRODUCT_ID,
					P.PRODUCT_NAME,
					P.PRODUCT_CODE,
					P.PRODUCT_CODE_2,
					O.ORDER_DATE,
					O.DELIVERDATE,
					O.PROJECT_ID,
					NUMUNE_.REQ_ID,
					NUMUNE_.REQ_NO,
					NUMUNE_.REQ_HEAD,
					NUMUNE_.REQ_TYPE_ID,
					NUMUNE_.SHORT_CODE,
					NUMUNE_.COMPANY_ORDER_NO,
					NUMUNE_.COMPANY_MODEL_NO,
					NUMUNE_.PROJECT_HEAD,
					NUMUNE_.PROJECT_COMPANY,
					NUMUNE_.PROJECT_DETAIL,
					OPERATION_.MAIN_OPERATION_ID,
					OPERATION_.IS_SEND,
					PU.ADD_UNIT,
					ASSET.ASSET_ID,
					ASSET.ASSETCAT_ID,
					ASSET.ASSET_FILE_NAME,
					OPERATION_.MARJ,
					OPERATION_.AMOUNT,
					RESULT_FINISH.ORDER_AMOUNT,
                    RESULT_FINISH.RESULT_AMOUNT,
                    RESULT_FINISH.OPERATION_TYPE_ID		
		
		
		</cfquery>
		<cfreturn GET_ORDERS>
	</cffunction>
</cfcomponent>