<cfif not isdefined("attributes.consumer_id") and isdefined("session.ww.userid")>
	<cfset attributes.consumer_id = session.ww.userid>
<cfelseif not isdefined("attributes.partner_id") and isdefined("session.pp.userid")>
	<cfset attributes.partner_id = session.pp.userid>
</cfif>
<cfquery name="GET_ORDER_DEMANDS" datasource="#DSN3#">
	SELECT
		O.STOCK_ID,
        O.GIVEN_AMOUNT,
        O.DEMAND_AMOUNT,
        O.PROMOTION_ID,
        O.PRICE,
        O.PRICE_KDV,
        O.PRICE_MONEY,
        O.DEMAND_ID,
        O.STOCK_ACTION_TYPE,
		S.PRODUCT_ID,
		S.PRODUCT_NAME,
		S.TAX,
		S.PRODUCT_UNIT_ID,
		S.IS_INVENTORY,
		S.IS_ZERO_STOCK,
		S.PROPERTY
	FROM
		ORDER_DEMANDS O,
		STOCKS S
	WHERE
		<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
			O.RECORD_CON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
		<cfelseif isdefined("attributes.partner_id") and len(attributes.partner_id)>
			O.RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#">
		<cfelse>
			1 = 2
		</cfif>
		AND S.STOCK_ID = O.STOCK_ID
		AND O.DEMAND_STATUS = 1
		AND O.DEMAND_TYPE = 3
		AND O.DEMAND_AMOUNT > ISNULL(GIVEN_AMOUNT,0)
		AND O.DEMAND_ID NOT IN(SELECT DEMAND_ID FROM ORDER_PRE_ROWS WHERE DEMAND_ID IS NOT NULL)
</cfquery>
<cfif get_order_demands.recordcount>
	<cfif isdefined("attributes.is_zero_stock_dept") and len(attributes.is_zero_stock_dept) and listlen(attributes.is_zero_stock_dept,'-') eq 2>
		<cfquery name="GET_STOCK_LAST" datasource="#DSN2#">
			get_stock_last_location_function '#ValueList(get_order_demands.stock_id,",")#'
		</cfquery>
	</cfif>
	<cfoutput query="get_order_demands">
		<cfset productName_ = product_name>
		<cfif len(property)>
			<cfset productName_ = '#productName_# #property#'>
		</cfif>
		<cfif get_order_demands.is_inventory eq 1>
						<cfif isdefined("attributes.is_zero_stock_dept") and len(attributes.is_zero_stock_dept) and listlen(attributes.is_zero_stock_dept,'-') eq 2>
				<cfquery name="GET_LAST_STOCKS_1" dbtype="query">
					SELECT
						STOCK_ID,SALEABLE_STOCK
					FROM
						GET_STOCK_LAST
					WHERE
						STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#">
					<cfif isdefined("attributes.is_zero_stock_dept") and len(attributes.is_zero_stock_dept) and listlen(attributes.is_zero_stock_dept,'-') eq 2>
						AND DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.is_zero_stock_dept,1,'-')#"> 
						AND LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.is_zero_stock_dept,2,'-')#">	
					</cfif>									
				</cfquery>
				
				<cfquery name="GET_LAST_STOCKS_2" datasource="#DSN2#">
					SELECT
						STOCK_ID,SUM(SALEABLE_STOCK) AS SALEABLE_STOCK
					FROM
					(
						SELECT 
							(RESERVE_STOCK_IN-RESERVE_STOCK_OUT)*-1 AS SALEABLE_STOCK,
							STOCK_ID
						FROM
							#dsn3_alias#.ORDER_ROW_RESERVED ORDER_ROW_RESERVED
						WHERE
							PRE_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cftoken#"> AND
							STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#">
						<cfif isdefined("attributes.is_zero_stock_dept") and len(attributes.is_zero_stock_dept) and listlen(attributes.is_zero_stock_dept,'-') eq 2>
							AND DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.is_zero_stock_dept,1,'-')#"> 
							AND LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.is_zero_stock_dept,2,'-')#">	
						</cfif>					
					) AS GET_ALL_SALEABLE_STOCK
					GROUP BY STOCK_ID
				</cfquery>
				<cfquery name="GET_LAST_STOCKS_3" dbtype="query">
						SELECT 
							* 
						FROM 
							GET_LAST_STOCKS_1
					UNION ALL
						SELECT 
							* 
						FROM 
							GET_LAST_STOCKS_2
				</cfquery>
				<cfquery name="GET_STOCK_INFO" dbtype="query">
					SELECT
						STOCK_ID,
						SUM(SALEABLE_STOCK) AS SALEABLE_STOCK
					FROM
						GET_LAST_STOCKS_3
					GROUP BY 
						STOCK_ID
					HAVING 
						SUM(SALEABLE_STOCK) >0
					ORDER BY
						STOCK_ID
				</cfquery>			
			<cfelse>
				<cfquery name="GET_STOCK_INFO" datasource="#DSN2#">
					SELECT
						STOCK_ID,
						SUM(SALEABLE_STOCK) AS SALEABLE_STOCK
					FROM
					(
						SELECT 
							SALEABLE_STOCK, 
							STOCK_ID
						FROM
							GET_STOCK_LAST
						WHERE
							STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#">
							
						UNION ALL
							
						SELECT 
							(RESERVE_STOCK_IN-RESERVE_STOCK_OUT)*-1 AS SALEABLE_STOCK, 
							STOCK_ID
						FROM
							#dsn3_alias#.ORDER_ROW_RESERVED ORDER_ROW_RESERVED
						WHERE
							PRE_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CFTOKEN#"> AND
							STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#">			
					) AS GET_ALL_SALEABLE_STOCK
					GROUP BY 
						STOCK_ID
					HAVING 
						SUM(SALEABLE_STOCK) >0
				</cfquery>
			</cfif>
		<cfelse>
			<cfset get_stock_info.recordcount = 0>
		</cfif>
		<cfif len(given_amount)>
			<cfset amount_ = demand_amount - given_amount>
		<cfelse>
			<cfset amount_ = demand_amount>
		</cfif>
		<cfif get_stock_info.recordcount and amount_ gt get_stock_info.saleable_stock>
			<cfset amount_ = get_stock_info.saleable_stock>
		</cfif>
		<cfif len(get_order_demands.promotion_id)>
			<cfquery name="GET_PROM_DETAIL" datasource="#DSN3#">
				SELECT ISNULL(PRODUCT_PROMOTION_NONEFFECT,0) PRODUCT_PROMOTION_NONEFFECT FROM PROMOTIONS WHERE PROM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_demands.promotion_id#">
			</cfquery>
		</cfif>
		<cfif get_stock_info.recordcount or get_order_demands.is_inventory eq 0 or get_order_demands.is_zero_stock eq 1>
			<cfquery name="ADD_DEMAND_PRODUCT" datasource="#DSN3#">
				INSERT INTO
					ORDER_PRE_ROWS
					(
						PRODUCT_ID,
						PRODUCT_NAME,
						QUANTITY,
						PRICE,
						PRICE_KDV,
						PRICE_MONEY,
						TAX,
						STOCK_ID,
						STOCK_ACTION_ID,
						STOCK_ACTION_TYPE,
						PRODUCT_UNIT_ID,
						PROM_STOCK_AMOUNT,
						IS_PROM_ASIL_HEDIYE,
						PROM_FREE_STOCK_ID,
						IS_COMMISSION,
						PRICE_STANDARD,
						PRICE_STANDARD_KDV,
						PRICE_STANDARD_MONEY,
						IS_FROM_SERI_SONU,
						TO_CONS,
						TO_COMP,
						TO_PAR,
						RECORD_PERIOD_ID,
						RECORD_PAR,
						RECORD_CONS,
						RECORD_EMP,
						RECORD_GUEST,
						COOKIE_NAME,
						SALE_PARTNER_ID,
						SALE_CONSUMER_ID,
						RECORD_IP,
						RECORD_DATE,
						DEMAND_ID,
						IS_NONDELETE_PRODUCT,
						IS_PRODUCT_PROMOTION_NONEFFECT
					)
					VALUES
					(
						#product_id#,
						'#productName_#',
						#amount_#,
						#price#,
						#price_kdv#,
						'#price_money#',
						#tax#,
						#stock_id#,
						0,
						<cfif get_order_demands.is_inventory eq 1>-1<cfelse>-2</cfif>,
						#product_unit_id#,
						1,
						0,
						0,
						0,
						#price#,
						#price_kdv#,
						'#price_money#',
						0,
						<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.company_id') and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.partner_id') and len(attributes.partner_id)>#attributes.partner_id#<cfelse>NULL</cfif>,
						#session_base.period_id#,
						<cfif isdefined("session.pp")>#session.pp.userid#<cfelse>NULL</cfif>,
						<cfif isdefined("session.ww.userid")>#session.ww.userid#<cfelse>NULL</cfif>,
						<cfif isdefined("session.ep.userid")>#session.ep.userid#<cfelse>NULL</cfif>,
						<cfif not isdefined("session.pp") and not isdefined("session.ww.userid") and not isdefined("session.ep.userid")>1<cfelse>0</cfif>,
						<cfif isdefined("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")>'#wrk_eval("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#'<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.sales_member_id') and len(attributes.sales_member_id) and len(attributes.sales_member) and attributes.sales_member_type is 'partner'>#attributes.sales_member_id#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.sales_cons_id') and len(attributes.sales_cons_id) and len(attributes.sales_member) and attributes.sales_member_type is 'consumer'>#attributes.sales_cons_id#<cfelse>NULL</cfif>,
						'#cgi.remote_addr#',
						#now()#,
						#demand_id#,
						<cfif len(stock_action_type) and stock_action_type eq 2>1<cfelse>0</cfif>,
						<cfif len(get_order_demands.promotion_id)>#get_prom_detail.product_promotion_noneffect#<cfelse>0</cfif>
					)
			</cfquery>
		</cfif>
	</cfoutput>
</cfif>
