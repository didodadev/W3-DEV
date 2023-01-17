<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
</cfif>
<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
</cfif>
<cfif isdefined('attributes.start_date1') and len(attributes.start_date1)>
	<cf_date tarih="attributes.start_date1">
</cfif>
<cfif isdefined('attributes.finish_date1') and len(attributes.finish_date1)>
	<cf_date tarih="attributes.finish_date1">
</cfif>
<cfif isdefined('attributes.start_date2') and len(attributes.start_date2)>
	<cf_date tarih="attributes.start_date2">
</cfif>
<cfif isdefined('attributes.finish_date2') and len(attributes.finish_date2)>
	<cf_date tarih="attributes.finish_date2">
</cfif>
<cfif isdefined('attributes.order_deliver_date') and len(attributes.order_deliver_date)>
	<cf_date tarih="attributes.order_deliver_date">
</cfif>
<cfquery name="get_order_demand" datasource="#dsn3#">
	SELECT
		*
	FROM
	(
		<cfif attributes.order_internaldemand eq 3 or attributes.order_internaldemand eq 1 or not len(attributes.order_internaldemand)>
			SELECT
				O.ORDER_ID ACTION_ID,
				ORR.ORDER_ROW_ID ACTION_ROW_ID,
				O.ORDER_NUMBER,
				O.ORDER_DATE ACTION_DATE,
				<cfif isdefined("x_show_deliver_date") and x_show_deliver_date eq 1>
					ORR.DELIVER_DATE  DELIVERDATE, 
				<cfelse>	
					O.DELIVERDATE DELIVERDATE,
				</cfif>
				O.COMPANY_ID,
				O.CONSUMER_ID,
				O.DELIVER_DEPT_ID DEPARTMENT_OUT,
				O.LOCATION_ID LOCATION_OUT,
				'' DEPARTMENT_IN,
				'' LOCATION_IN,
				O.IS_INSTALMENT,
				O.ORDER_HEAD,
				O.ORDER_STAGE,
				O.PROJECT_ID,
				ORR.STOCK_ID,
				ORR.SPECT_VAR_NAME,
				ORR.UNIT,
				ORR.NETTOTAL,
				ORR.TAX,
				ORR.CANCEL_AMOUNT,
				ORR.ORDER_ROW_CURRENCY,
				ORR.QUANTITY,
				ORR.DELIVER_DEPT,
				ORR.DELIVER_LOCATION,
				ISNULL((SELECT SP.SPECT_MAIN_ID FROM SPECTS SP WHERE SP.SPECT_VAR_ID = ORR.SPECT_VAR_ID),0) SPECT_MAIN_ID,
				(ORR.QUANTITY - ISNULL(ORR.DELIVER_AMOUNT,0)) AS LAST_AMOUNT,
				1 AS TYPE,
				S.PRODUCT_CODE,
				S.PRODUCT_NAME,
				S.PRODUCT_ID,
				ORR.WRK_ROW_ID,
                '' DEMAND_TYPE
			FROM
				ORDERS O,
				ORDER_ROW ORR,
				STOCKS S
			WHERE
				((O.PURCHASE_SALES = 1 AND O.ORDER_ZONE = 0) OR (O.PURCHASE_SALES = 0 AND O.ORDER_ZONE = 1)) 
				AND O.ORDER_ID = ORR.ORDER_ID
				AND S.STOCK_ID = ORR.STOCK_ID
				AND (ORR.QUANTITY - ISNULL((SELECT SUM(IR.AMOUNT) FROM #dsn2_alias#.SHIP_ROW IR WHERE IR.WRK_ROW_RELATION_ID = ORR.WRK_ROW_ID),0)- ISNULL((SELECT SUM(ORR2.QUANTITY) FROM ORDER_ROW ORR2 WHERE ORR2.WRK_ROW_RELATION_ID = ORR.WRK_ROW_ID),0))>0
				AND ORR.ORDER_ROW_CURRENCY NOT IN(-3,-10,-9,-8)
				<cfif len(attributes.keyword)>
					AND 
						(
							O.ORDER_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
							O.ORDER_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
							S.PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
						)
				</cfif>
				<cfif isdefined('attributes.order_stage') and len(attributes.order_stage)>
					AND ORDER_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_stage#">
				</cfif>
				<cfif len(attributes.order_row_currency)>
					AND ORR.ORDER_ROW_CURRENCY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_row_currency#">
				</cfif>
				<cfif len(attributes.status) and attributes.status neq 3>
					AND O.ORDER_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.status#">
				</cfif>
				<cfif isdefined("attributes.project_id") and len (attributes.project_id) and isdefined("attributes.project_head") and len (attributes.project_head)>
					AND O.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
				</cfif>
				<cfif len(attributes.product_id) and len(attributes.product_name)>
					AND ORR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
				</cfif>
				<cfif len(attributes.brand_id)>
					AND S.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#">
				</cfif>
				<cfif isdefined("attributes.order_employee_id") and len(attributes.order_employee_id) and len(attributes.order_employee)>
					AND O.ORDER_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_employee_id#">
				</cfif>
				<cfif len(attributes.company_id_) and len(attributes.company_)>
					AND S.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id_#">
				</cfif>
				<cfif len(attributes.short_code_id) and len(attributes.short_code_name)>
					AND S.SHORT_CODE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.short_code_id#">
				</cfif>
				<cfif len(attributes.department_out_id)>					
				    <cfif listlen(attributes.department_out_id,'-') eq 1>
                        AND ISNULL(ISNULL(ORR.DELIVER_DEPT,O.DELIVER_DEPT_ID),0) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_out_id#">
                    <cfelse>
                        AND ISNULL(ISNULL(ORR.DELIVER_DEPT,O.DELIVER_DEPT_ID),0) =  <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.department_out_id,'-')#">
                        AND ISNULL(ISNULL(ORR.DELIVER_LOCATION,O.LOCATION_ID),0) =  <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.department_out_id,'-')#">                    
                    </cfif>
                </cfif>
				<cfif isdefined("attributes.member_type") and (attributes.member_type is 'PARTNER') and len(attributes.member_name) and len(attributes.list_company_id)>
					AND O.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.list_company_id#">
				</cfif>
				<cfif isdefined("attributes.member_type") and (attributes.member_type is 'CONSUMER') and len(attributes.member_name) and len(attributes.list_consumer_id)>
					AND O.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.list_consumer_id#">
				</cfif>
				<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
					AND O.ORDER_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
				</cfif>
				<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
					AND O.ORDER_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
				</cfif>
				<cfif isdefined("x_show_deliver_date") and x_show_deliver_date eq 1>
					<cfif isdefined('attributes.start_date1') and len(attributes.start_date1)>
						AND ORR.DELIVER_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date1#">
					</cfif>
					<cfif isdefined('attributes.finish_date1') and len(attributes.finish_date1)>
						AND ORR.DELIVER_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date1#">
					</cfif>
				<cfelse>
					<cfif isdefined('attributes.start_date1') and len(attributes.start_date1)>
						AND O.DELIVERDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date1#">
					</cfif>
					<cfif isdefined('attributes.finish_date1') and len(attributes.finish_date1)>
						AND O.DELIVERDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date1#">
					</cfif>
				</cfif>
				<cfif isdefined('attributes.start_date2') and len(attributes.start_date2)>
					AND O.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date2#"> 
				</cfif>
				<cfif isdefined('attributes.finish_date2') and len(attributes.finish_date2)>
					AND O.RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#date_add('d',1,attributes.finish_date2)#">
				</cfif>
				<cfif isdefined("attributes.prod_cat") and len(attributes.prod_cat)>
					AND S.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.prod_cat#.%">
				</cfif>
				<cfif isDefined("attributes.priority") and len(attributes.priority)>
					AND O.PRIORITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.priority#"> 
				</cfif>
				<cfif isdefined('attributes.sale_add_option') and len(attributes.sale_add_option)>
					AND O.SALES_ADD_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sale_add_option#">
				</cfif>
				<cfif isdefined('attributes.order_deliver_date') and len(attributes.order_deliver_date)>
					AND DATEADD(DAY,-1*ISNULL((SELECT TOP 1 SS.PROVISION_TIME FROM STOCK_STRATEGY SS WHERE SS.PRODUCT_ID =ORR.PRODUCT_ID AND SS.STOCK_ID = ORR.STOCK_ID AND SS.DEPARTMENT_ID IS NULL),0),O.DELIVERDATE) <= #attributes.order_deliver_date#
				</cfif>
		</cfif>
		<cfif attributes.order_internaldemand eq 3 or not len(attributes.order_internaldemand)>
			UNION ALL
		</cfif>
		<cfif attributes.order_internaldemand eq 3 or attributes.order_internaldemand eq 2 or not len(attributes.order_internaldemand)>
			SELECT
				O.INTERNAL_ID ACTION_ID,
				ORR.I_ROW_ID ACTION_ROW_ID,
				O.INTERNAL_NUMBER ORDER_NUMBER,
				O.TARGET_DATE ACTION_DATE,
				<cfif isdefined("x_show_deliver_date") and x_show_deliver_date eq 1>
					ORR.DELIVER_DATE DELIVERDATE,
				<cfelse>
					O.TARGET_DATE DELIVERDATE,
				</cfif>
				'' COMPANY_ID,
				'' CONSUMER_ID,
				O.DEPARTMENT_OUT DEPARTMENT_OUT,
				O.LOCATION_OUT LOCATION_OUT,
				O.DEPARTMENT_IN DEPARTMENT_IN,
				O.LOCATION_IN LOCATION_IN,
				'' IS_INSTALMENT,
				O.SUBJECT ORDER_HEAD,
				O.INTERNALDEMAND_STAGE ORDER_STAGE,
				O.PROJECT_ID,
				ORR.STOCK_ID,
				ORR.SPECT_VAR_NAME,
				ORR.UNIT,
				ORR.NETTOTAL,
				ORR.TAX,
				0 CANCEL_AMOUNT,
				'' ORDER_ROW_CURRENCY,
				ORR.QUANTITY,
				0 DELIVER_DEPT,
				0 DELIVER_LOCATION,
				ISNULL((SELECT SP.SPECT_MAIN_ID FROM SPECTS SP WHERE SP.SPECT_VAR_ID = ORR.SPECT_VAR_ID),0) SPECT_MAIN_ID,
				(ORR.QUANTITY - ISNULL((SELECT SUM(IR.AMOUNT) FROM #dsn2_alias#.SHIP_ROW IR WHERE IR.WRK_ROW_RELATION_ID = ORR.WRK_ROW_ID),0)- ISNULL((SELECT SUM(ORR2.QUANTITY) FROM ORDER_ROW ORR2 WHERE ORR2.WRK_ROW_RELATION_ID = ORR.WRK_ROW_ID),0)) AS LAST_AMOUNT, 
				0 AS TYPE,
				S.PRODUCT_CODE,
				S.PRODUCT_NAME,
				S.PRODUCT_ID,
				ORR.WRK_ROW_ID,
                O.DEMAND_TYPE
			FROM
				INTERNALDEMAND O,
				INTERNALDEMAND_ROW ORR,
				STOCKS S
			WHERE
				O.INTERNAL_ID = ORR.I_ID
				AND S.STOCK_ID = ORR.STOCK_ID
				AND (ORR.QUANTITY - ISNULL((SELECT SUM(IR.AMOUNT) FROM #dsn2_alias#.SHIP_ROW IR WHERE IR.WRK_ROW_RELATION_ID = ORR.WRK_ROW_ID),0)- ISNULL((SELECT SUM(ORR2.QUANTITY) FROM ORDER_ROW ORR2 WHERE ORR2.WRK_ROW_RELATION_ID = ORR.WRK_ROW_ID),0))>0
				<cfif len(attributes.keyword)>
					AND 
						(
							O.SUBJECT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
							O.INTERNAL_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
							S.PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
						)
				</cfif>
				<cfif isdefined('attributes.internaldemand_stage') and len(attributes.internaldemand_stage)>
					AND INTERNALDEMAND_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.internaldemand_stage#">
				</cfif>
				<cfif len(attributes.status) and attributes.status neq 3>
					AND O.IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.status#">
				</cfif>
				<cfif isdefined("attributes.project_id") and len (attributes.project_id) and isdefined("attributes.project_head") and len (attributes.project_head)>
					AND O.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
				</cfif>
				<cfif len(attributes.product_id) and len(attributes.product_name)>
					AND ORR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
				</cfif>
				<cfif len(attributes.brand_id)>
					AND S.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#">
				</cfif>
				<cfif isdefined("attributes.from_employee_id") and len(attributes.from_employee_id) and isdefined('attributes.from_employee_name') and len(attributes.from_employee_name)>
					AND O.FROM_POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.from_employee_id#">
				</cfif>
				<cfif isdefined("attributes.to_position_code") and len(attributes.to_position_code) and isdefined('attributes.to_position_name') and len(attributes.to_position_name)>
					AND O.TO_POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.to_position_code#">
				</cfif>
				<cfif len(attributes.company_id_) and len(attributes.company_)>
					AND S.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id_#">
				</cfif>
				<cfif len(attributes.short_code_id) and len(attributes.short_code_name)>
					AND S.SHORT_CODE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.short_code_id#">
				</cfif>	
				<cfif len(attributes.department_out_id)>
                	<cfif listlen(attributes.department_out_id,'-') eq 1>
                        AND O.DEPARTMENT_OUT =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_out_id#">
                    <cfelse>
                        AND O.DEPARTMENT_OUT =  <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.department_out_id,'-')#">
                        AND O.LOCATION_OUT =  <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.department_out_id,'-')#">                    
                    </cfif>
				</cfif>
				<cfif len(attributes.department_in_id)>
                	<cfif listlen(attributes.department_in_id,'-') eq 1>
                        AND O.DEPARTMENT_IN =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_in_id#">
                    <cfelse>
                        AND O.DEPARTMENT_IN =  <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.department_in_id,'-')#">
                        AND O.LOCATION_IN =  <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.department_in_id,'-')#">                    
                    </cfif>
				</cfif>
				<cfif isdefined("x_show_deliver_date") and x_show_deliver_date eq 1>
					<cfif isdefined('attributes.start_date1') and len(attributes.start_date1)>
						AND ORR.DELIVER_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date1#">
					</cfif>
					<cfif isdefined('attributes.finish_date1') and len(attributes.finish_date1)>
						AND ORR.DELIVER_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date1#">
					</cfif>
				<cfelse>
					<cfif isdefined('attributes.start_date1') and len(attributes.start_date1)>
						AND O.TARGET_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date1#">
					</cfif>
					<cfif isdefined('attributes.finish_date1') and len(attributes.finish_date1)>
						AND O.TARGET_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date1#">
					</cfif>
				</cfif>
				<cfif isdefined('attributes.start_date2') and len(attributes.start_date2)>
					AND O.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date2#"> 
				</cfif>
				<cfif isdefined('attributes.finish_date2') and len(attributes.finish_date2)>
					AND O.RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#date_add('d',1,attributes.finish_date2)#">
				</cfif>
				<cfif isdefined("attributes.prod_cat") and len(attributes.prod_cat)>
					AND S.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.prod_cat#.%">
				</cfif>
				<cfif isDefined("attributes.priority") and len(attributes.priority)>
					AND O.PRIORITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.priority#"> 
				</cfif>
				<cfif isdefined('attributes.order_deliver_date') and len(attributes.order_deliver_date)>
					AND DATEADD(DAY,-1*ISNULL((SELECT TOP 1 SS.PROVISION_TIME FROM STOCK_STRATEGY SS WHERE SS.PRODUCT_ID =ORR.PRODUCT_ID AND SS.STOCK_ID = ORR.STOCK_ID AND SS.DEPARTMENT_ID IS NULL),0),O.TARGET_DATE) <= #attributes.order_deliver_date#
				</cfif>
		</cfif>
	)T1
	ORDER BY
		ACTION_DATE
</cfquery>
