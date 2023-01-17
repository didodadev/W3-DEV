<!--- 20080331 SM Satış ve Karlılık Analizi --->
<!---
	attributes.report_type 1 : Şube Bazında
	attributes.report_type 2 : Kategori Bazında
	attributes.report_type 3 : Ürün Bazında
	attributes.report_type 4 : Marka Bazında
	attributes.report_type 5 : Tedarikçi Bazında
	attributes.report_type 6 : Satış Temsilcisi Bazında
	attributes.report_type 7 : Ürün Sorumlusu Bazında
	attributes.report_type 8 : Belge ve Stok Bazında
	attributes.report_type 9 : Satış Ortağı Bazında
 --->
<cfparam name="attributes.module_id_control" default="20,11">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.row_employee" default="">
<cfparam name="attributes.row_employee_id" default="">
<cfparam name="attributes.search_product_catid" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.zone_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.cancel_type_id" default="">
<cfparam name="attributes.brand_name" default="">
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.sup_company" default="">
<cfparam name="attributes.sup_company_id" default="">
<cfparam name="attributes.product_employee_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.order_stage" default="">
<cfparam name="attributes.payment_type_id" default="">
<cfparam name="attributes.card_paymethod_id" default="">
<cfparam name="attributes.payment_type" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.ship_method_id" default="">
<cfparam name="attributes.ship_method_name" default="">
<cfparam name="attributes.report_type" default="">
<cfparam name="attributes.status" default="">
<cfparam name="attributes.cost_status" default="">
<cfparam name="attributes.order_process_cat" default="">
<cfparam name="attributes.datediff_value" default="2">
<cfparam name="attributes.report_sort" default="1">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.graph_type" default="">
<cfparam name="attributes.date1" default="#now()#">
<cfparam name="attributes.date2" default="#now()#">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfquery name="get_sales_zone" datasource="#dsn#">	
	SELECT * FROM SALES_ZONES ORDER BY SZ_NAME
</cfquery>
<cfquery name="get_process_type" datasource="#dsn#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%sales.list_order%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfquery name="get_cancel_type" datasource="#dsn3#">
	SELECT
		*
	FROM 
		SETUP_SUBSCRIPTION_CANCEL_TYPE
	ORDER BY
		SUBSCRIPTION_CANCEL_TYPE
</cfquery>
<cfquery name="get_department" datasource="#dsn#">
	SELECT
		DEPARTMENT_ID,
		DEPARTMENT_HEAD
	FROM
		BRANCH B,
		DEPARTMENT D 
	WHERE
		B.COMPANY_ID = #session.ep.company_id# AND
		B.BRANCH_ID = D.BRANCH_ID AND
		D.IS_STORE <> 2 AND
		D.DEPARTMENT_STATUS = 1 AND
		B.BRANCH_ID IN(SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
	ORDER BY
		DEPARTMENT_HEAD
</cfquery>
<cfset branch_dep_list = valuelist(get_department.department_id)>
<cfif isdefined("attributes.form_submitted")>
	<cfif isdate(attributes.date1)>
		<cf_date tarih = "attributes.date1">
	</cfif>
	<cfif isdate(attributes.date2)>
		<cf_date tarih = "attributes.date2">
	</cfif>	
	<cfquery name="get_all_order" datasource="#dsn3#">
		SELECT
			<cfif attributes.report_type eq 1>
				B.BRANCH_ID,
				B.BRANCH_NAME
			<cfelseif attributes.report_type eq 2>
				PC.PRODUCT_CATID,
				PC.PRODUCT_CAT
			<cfelseif attributes.report_type eq 3>
				P.PRODUCT_NAME,
				P.PRODUCT_ID,
				PC.PRODUCT_CATID,
				PC.PRODUCT_CAT,
				P.BRAND_ID
			<cfelseif attributes.report_type eq 4>
				PB.BRAND_NAME,
				PB.BRAND_ID
			<cfelseif attributes.report_type eq 5>
				C.COMPANY_ID,
				C.NICKNAME
			<cfelseif attributes.report_type eq 6>
				E.EMPLOYEE_ID,
				E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME
			<cfelseif attributes.report_type eq 7>
				E.EMPLOYEE_ID,
				E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME
			<cfelseif attributes.report_type eq 8>
				ORD_R.ORDER_ROW_CURRENCY,
				ORD_R.BASKET_EMPLOYEE_ID,
				O.IS_INSTALMENT,
				O.ORDER_NUMBER,
				O.ORDER_ID,
				O.ORDER_DATE,
				PC.PRODUCT_CAT,
				PC.PRODUCT_CATID,
				S.PRODUCT_ID,
				P.PRODUCT_NAME,
				P.PRODUCT_CODE,
				P.BRAND_ID
			<cfelseif attributes.report_type eq 9>
				ISNULL(O.SALES_PARTNER_ID,O.SALES_CONSUMER_ID) AS SALES_MEMBER_ID,
				CASE WHEN O.SALES_PARTNER_ID IS NOT NULL THEN 1 ELSE 2 END AS SALES_MEMBER_TYPE
			</cfif>
		FROM 
			ORDERS O,
			ORDER_ROW ORD_R,
			STOCKS S,
			<cfif attributes.report_type eq 1>
				#dsn_alias#.BRANCH B,
				#dsn_alias#.DEPARTMENT D,
			<cfelseif attributes.report_type eq 2>
				PRODUCT_CAT PC,
			<cfelseif attributes.report_type eq 3>
				PRODUCT_CAT PC,
			<cfelseif attributes.report_type eq 4>
				PRODUCT_BRANDS PB,
			<cfelseif attributes.report_type eq 5>
				#dsn_alias#.COMPANY C,
			<cfelseif attributes.report_type eq 6>
				#dsn_alias#.EMPLOYEES E,
			<cfelseif attributes.report_type eq 7>
				#dsn_alias#.EMPLOYEE_POSITIONS E,
			<cfelseif attributes.report_type eq 8>
				PRODUCT_CAT PC,
			</cfif>
			PRODUCT P
		WHERE
			O.NETTOTAL > 0 
			AND 
			(
				(O.PURCHASE_SALES = 1 AND O.ORDER_ZONE = 0)  
				OR
				(O.PURCHASE_SALES = 0 AND O.ORDER_ZONE = 1)
			)
			AND ORD_R.IS_PROMOTION <> 1
			AND O.ORDER_ID = ORD_R.ORDER_ID 
			AND S.PRODUCT_ID = P.PRODUCT_ID 
			AND ORD_R.STOCK_ID = S.STOCK_ID
			AND ORDER_DATE BETWEEN #attributes.date1# AND #attributes.date2#
			<cfif len(attributes.status)>
				AND O.ORDER_STATUS = #attributes.status# 
			</cfif>
			<cfif attributes.report_type eq 1>
				AND O.DELIVER_DEPT_ID = D.DEPARTMENT_ID
				AND D.BRANCH_ID = B.BRANCH_ID
			<cfelseif attributes.report_type eq 2>
				AND P.PRODUCT_CATID = PC.PRODUCT_CATID
			<cfelseif attributes.report_type eq 3 or attributes.report_type eq 8>
				AND (
						( CHARINDEX('.',P.PRODUCT_CODE) <> 0 AND LEFT(P.PRODUCT_CODE,(ABS(CHARINDEX('.',P.PRODUCT_CODE)-1)))=PC.HIERARCHY ) OR
						( CHARINDEX('.',P.PRODUCT_CODE) <= 0 AND P.PRODUCT_CODE = PC.HIERARCHY )
					)
			<cfelseif attributes.report_type eq 4>
				AND P.BRAND_ID = PB.BRAND_ID
			<cfelseif attributes.report_type eq 5>
				AND P.COMPANY_ID = C.COMPANY_ID
			<cfelseif attributes.report_type eq 6>
				AND O.ORDER_EMPLOYEE_ID = E.EMPLOYEE_ID
			<cfelseif attributes.report_type eq 7>
				AND P.PRODUCT_MANAGER = E.POSITION_CODE
			<!--- <cfelseif attributes.report_type eq 8>
				AND LEFT(P.PRODUCT_CODE,(CHARINDEX('.',P.PRODUCT_CODE)-1))=PC.HIERARCHY  --->
			</cfif>
			<cfif len(trim(attributes.product_cat)) and len(attributes.search_product_catid) >
				AND S.STOCK_CODE LIKE '#attributes.search_product_catid#%' 
			</cfif>
			<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
				AND P.PRODUCT_ID = #attributes.product_id#
			</cfif>
			<cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
				AND P.BRAND_ID = #attributes.brand_id#
			</cfif>
			<cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
				AND P.COMPANY_ID = #attributes.sup_company_id# 
			</cfif>
			<cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
				AND P.PRODUCT_MANAGER = #attributes.product_employee_id# 
			</cfif>
			<cfif len(attributes.zone_id)>
				AND O.ZONE_ID = #attributes.zone_id#
			</cfif>
			<cfif len(attributes.cancel_type_id)>
				AND O.CANCEL_TYPE_ID = #attributes.cancel_type_id# 
			</cfif>
			<cfif len(attributes.payment_type) and len(attributes.payment_type_id)>
				AND O.PAYMETHOD = #attributes.payment_type_id#
			<cfelseif len(attributes.payment_type) and len(attributes.card_paymethod_id)>
				AND O.CARD_PAYMETHOD_ID = #attributes.card_paymethod_id#
			</cfif>
			<cfif len(trim(attributes.employee)) and len(attributes.employee_id)>
				AND O.ORDER_EMPLOYEE_ID = #attributes.employee_id# 
			</cfif>
			<cfif len(attributes.ship_method_id) and len(attributes.ship_method_name)>
				AND O.SHIP_METHOD = #attributes.ship_method_id#
			</cfif>
			<cfif len(attributes.order_stage)>
				AND ORD_R.ORDER_ROW_CURRENCY IN (#attributes.order_stage#)
			</cfif>
			<cfif len(attributes.order_process_cat)>
				AND O.ORDER_STAGE IN (#attributes.order_process_cat#)
			</cfif>
			<cfif len(attributes.cost_status) and attributes.cost_status eq 0>
				AND P.PRODUCT_ID NOT IN(SELECT PRODUCT_ID FROM PRODUCT_COST)
			<cfelseif len(attributes.cost_status) and attributes.cost_status eq 1>
				AND P.PRODUCT_ID IN(SELECT PRODUCT_ID FROM PRODUCT_COST)
			</cfif>
			<cfif len(attributes.department_id)>
				AND(
				<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
					(O.DELIVER_DEPT_ID = #listfirst(dept_i,'-')# AND O.LOCATION_ID = #listlast(dept_i,'-')#)
					<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
				</cfloop>  
				) 
			<cfelseif len(branch_dep_list)>
				AND	(O.DELIVER_DEPT_ID IN(#branch_dep_list#) OR O.DELIVER_DEPT_ID IS NULL)
			</cfif>
			<cfif len(trim(attributes.row_employee)) and len(attributes.row_employee_id)>
				AND ORD_R.BASKET_EMPLOYEE_ID = #attributes.row_employee_id# 
			</cfif>
	</cfquery>
	<cfif get_all_order.recordcount>
		<cfif attributes.report_type eq 1>
			<cfset process_id_list = valuelist(get_all_order.branch_id)>
		<cfelseif attributes.report_type eq 2>
			<cfset process_id_list = valuelist(get_all_order.product_catid)>
		<cfelseif attributes.report_type eq 3>
			<cfset process_id_list = valuelist(get_all_order.product_id)>
		<cfelseif attributes.report_type eq 4>
			<cfset process_id_list = valuelist(get_all_order.brand_id)>
		<cfelseif attributes.report_type eq 5>
			<cfset process_id_list = valuelist(get_all_order.company_id)>
		<cfelseif attributes.report_type eq 6>
			<cfset process_id_list = valuelist(get_all_order.employee_id)>
		<cfelseif attributes.report_type eq 7>
			<cfset process_id_list = valuelist(get_all_order.employee_id)>
		<cfelseif attributes.report_type eq 8>
			<cfset process_id_list = valuelist(get_all_order.order_id)>
		<cfelseif attributes.report_type eq 9>
			<cfset process_id_list = valuelist(get_all_order.sales_member_id)>
		</cfif>
		<cfset process_id_list = listsort(listdeleteduplicates(process_id_list),'numeric','ASC',',')>
	</cfif>
		<cfquery name="get_sale_orders" datasource="#dsn3#" cachedwithin="#fusebox.general_cached_time#">
				SELECT
					SUM(GROSSTOTAL) GROSSTOTAL,
					SUM(PRICE) PRICE,
					SUM(QUANTITY) QUANTITY,
					<cfif isdefined("attributes.is_kdv")>
						CASE WHEN SUM(GROSSTOTAL) = 0 THEN 0 ELSE SUM(AVG_DUEDATE)/SUM(GROSSTOTAL) END AS AVG_DUEDATE,
						CASE WHEN SUM(GROSSTOTAL) = 0 THEN 0 ELSE SUM(AVG_ORDERDATE)/SUM(GROSSTOTAL) END AS AVG_ORDERDATE,
						CASE WHEN SUM(QUANTITY) = 0 THEN 0 ELSE SUM(GROSSTOTAL)/SUM(QUANTITY) END AS AVG_PRICE,
					<cfelse>
						CASE WHEN SUM(GROSSTOTAL) = 0 THEN 0 ELSE SUM(AVG_DUEDATE)/SUM(GROSSTOTAL) END AS AVG_DUEDATE,
						CASE WHEN SUM(GROSSTOTAL) = 0 THEN 0 ELSE SUM(AVG_ORDERDATE)/SUM(GROSSTOTAL) END AS AVG_ORDERDATE,
						CASE WHEN SUM(QUANTITY) = 0 THEN 0 ELSE SUM(GROSSTOTAL)/SUM(QUANTITY) END AS AVG_PRICE,
					</cfif>
					SUM(TOTAL_COST) AS TOTAL_COST,
					CASE WHEN SUM(QUANTITY) = 0 THEN 0 ELSE SUM(PHYSICAL_TOTAL_DATE)/ABS(SUM(QUANTITY)) END AS TOTAL_DATE_COST,
					SUM(AMOUNT) AS TOTAL_AMOUNT,
					SUM(TOTAL_STOCK_COST) AS TOTAL_STOCK_COST,
					CASE WHEN SUM(AMOUNT) = 0 THEN 0 ELSE SUM(TOTAL_STOCK_DATE)/SUM(AMOUNT) END AS TOTAL_STOCK_DATE,
					SUM(CLAIM_TOTAL) AS CLAIM_TOTAL,
					CASE WHEN SUM(CLAIM_TOTAL) = 0 THEN 0 ELSE SUM(VOUCHER_DUEDATE)/SUM(CLAIM_TOTAL) END AS CLAIM_DUEDATE,
					<cfif attributes.report_type eq 1>
						BRANCH_NAME
					<cfelseif attributes.report_type eq 2>
						PRODUCT_CAT
					<cfelseif attributes.report_type eq 3>
						PRODUCT_NAME,
						PRODUCT_ID,
						PRODUCT_CAT,
						BRAND_ID
					<cfelseif attributes.report_type eq 4>
						BRAND_NAME
					<cfelseif attributes.report_type eq 5>
						COMPANY_ID,
						NICKNAME
					<cfelseif attributes.report_type eq 6>
						EMPLOYEE_ID,
						EMPLOYEE_NAME,
						EMPLOYEE_SURNAME
					<cfelseif attributes.report_type eq 7>
						EMPLOYEE_ID,
						EMPLOYEE_NAME,
						EMPLOYEE_SURNAME
					<cfelseif attributes.report_type eq 8>
						ORDER_ROW_CURRENCY,
						IS_INSTALMENT,
						BASKET_EMPLOYEE_ID,
						ORDER_NUMBER,
						ORDER_ID,
						ORDER_DATE,
						PRODUCT_CAT,
						PRODUCT_CATID,
						PRODUCT_ID,
						PRODUCT_NAME,
						PRODUCT_CODE,
						BRAND_ID
					<cfelseif attributes.report_type eq 9>
						SALES_MEMBER_ID,
						SALES_MEMBER_TYPE
					</cfif>
				FROM
			(SELECT
				<cfif isdefined("attributes.is_kdv")>
					ORD_R.QUANTITY*ORD_R.PRICE*(100+ORD_R.TAX)/100 GROSSTOTAL,
					(1- (O.SA_DISCOUNT)/((O.NETTOTAL)-O.TAXTOTAL+O.SA_DISCOUNT)) * (ORD_R.NETTOTAL) + (((((1- (O.SA_DISCOUNT)/(O.NETTOTAL-O.TAXTOTAL+O.SA_DISCOUNT))*( ORD_R.NETTOTAL)*ORD_R.TAX)/100))) AS PRICE,
					ISNULL(DATEDIFF(day,GETDATE(),ISNULL((SELECT TOP 1 PAYROLL_AVG_DUEDATE FROM #dsn2_alias#.VOUCHER_PAYROLL WHERE PAYMENT_ORDER_ID = O.ORDER_ID AND PAYROLL_TYPE = 97),O.DUE_DATE))*(ORD_R.QUANTITY*ORD_R.PRICE*(100+ORD_R.TAX)/100),0) AS AVG_DUEDATE,
					ISNULL(DATEDIFF(day,GETDATE(),ORDER_DATE)*(ORD_R.QUANTITY*ORD_R.PRICE*(100+ORD_R.TAX)/100),0) AS AVG_ORDERDATE,
				<cfelse>
					ORD_R.QUANTITY*ORD_R.PRICE GROSSTOTAL,
					CASE WHEN (O.NETTOTAL-O.TAXTOTAL+O.SA_DISCOUNT = 0) THEN 0 ELSE (1- O.SA_DISCOUNT/(O.NETTOTAL-O.TAXTOTAL+O.SA_DISCOUNT)) * ORD_R.NETTOTAL END AS PRICE, 
					<!--- (1- O.SA_DISCOUNT/(O.NETTOTAL-O.TAXTOTAL+O.SA_DISCOUNT)) * ORD_R.NETTOTAL AS PRICE, --->
					ISNULL(DATEDIFF(day,GETDATE(),ISNULL((SELECT TOP 1 PAYROLL_AVG_DUEDATE FROM #dsn2_alias#.VOUCHER_PAYROLL WHERE PAYMENT_ORDER_ID = O.ORDER_ID AND PAYROLL_TYPE = 97),O.DUE_DATE))*(ORD_R.QUANTITY*ORD_R.PRICE),0) AS AVG_DUEDATE,
					ISNULL(DATEDIFF(day,GETDATE(),ORDER_DATE)*(ORD_R.QUANTITY*ORD_R.PRICE),0) AS AVG_ORDERDATE,
				</cfif>
				QUANTITY,
				ISNULL((
						SELECT TOP 1 ORD_R.QUANTITY*(PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM
						)+PROM_COST
					FROM 
						PRODUCT_COST PRODUCT_COST
					WHERE 
						PRODUCT_COST.PRODUCT_ID=ORD_R.PRODUCT_ID AND
						PRODUCT_COST.START_DATE <= O.ORDER_DATE
					ORDER BY
						PRODUCT_COST.START_DATE DESC,
						PRODUCT_COST.RECORD_DATE DESC,
						PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
					),0) AS TOTAL_COST,
				ISNULL((
					SELECT TOP 1	
						DATEDIFF(day,PHYSICAL_DATE,GETDATE())
					FROM 
						PRODUCT_COST PRODUCT_COST
					WHERE 
						PRODUCT_COST.PRODUCT_ID=ORD_R.PRODUCT_ID AND
						PRODUCT_COST.START_DATE <= O.ORDER_DATE
					ORDER BY
						PRODUCT_COST.START_DATE DESC,
						PRODUCT_COST.RECORD_DATE DESC,
						PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
					),0)*QUANTITY AS PHYSICAL_TOTAL_DATE,
				0 AS AMOUNT,
				0 AS TOTAL_STOCK_COST,
				0 AS TOTAL_STOCK_DATE,
				0 AS CLAIM_TOTAL,
				0 AS VOUCHER_DUEDATE,
				<cfif attributes.report_type eq 1>
					B.BRANCH_ID,
					B.BRANCH_NAME
				<cfelseif attributes.report_type eq 2>
					PC.PRODUCT_CATID,
					PC.PRODUCT_CAT
				<cfelseif attributes.report_type eq 3>
					P.PRODUCT_NAME,
					P.PRODUCT_ID,
					PC.PRODUCT_CATID,
					PC.PRODUCT_CAT,
					P.BRAND_ID
				<cfelseif attributes.report_type eq 4>
					PB.BRAND_NAME,
					PB.BRAND_ID
				<cfelseif attributes.report_type eq 5>
					C.COMPANY_ID,
					C.NICKNAME
				<cfelseif attributes.report_type eq 6>
					E.EMPLOYEE_ID,
					E.EMPLOYEE_NAME,
					E.EMPLOYEE_SURNAME
				<cfelseif attributes.report_type eq 7>
					E.EMPLOYEE_ID,
					E.EMPLOYEE_NAME,
					E.EMPLOYEE_SURNAME
				<cfelseif attributes.report_type eq 8>
					ORD_R.ORDER_ROW_CURRENCY,
					O.IS_INSTALMENT,
					ORD_R.BASKET_EMPLOYEE_ID,
					O.ORDER_NUMBER,
					O.ORDER_ID,
					O.ORDER_DATE,
					PC.PRODUCT_CAT,
					PC.PRODUCT_CATID,
					S.PRODUCT_ID,
					P.PRODUCT_NAME,
					P.PRODUCT_CODE,
					P.BRAND_ID
				<cfelseif attributes.report_type eq 9>
					ISNULL(O.SALES_PARTNER_ID,O.SALES_CONSUMER_ID) AS SALES_MEMBER_ID,
					CASE WHEN O.SALES_PARTNER_ID IS NOT NULL THEN 1 ELSE 2 END AS SALES_MEMBER_TYPE				
				</cfif>
			FROM 
				ORDERS O,
				ORDER_ROW ORD_R,
				STOCKS S,
				<cfif attributes.report_type eq 1>
					#dsn_alias#.BRANCH B,
					#dsn_alias#.DEPARTMENT D,
				<cfelseif attributes.report_type eq 2>
					PRODUCT_CAT PC,
				<cfelseif attributes.report_type eq 3>
					PRODUCT_CAT PC,
				<cfelseif attributes.report_type eq 4>
					PRODUCT_BRANDS PB,
				<cfelseif attributes.report_type eq 5>
					#dsn_alias#.COMPANY C,
				<cfelseif attributes.report_type eq 6>
					#dsn_alias#.EMPLOYEES E,
				<cfelseif attributes.report_type eq 7>
					#dsn_alias#.EMPLOYEE_POSITIONS E,
				<cfelseif attributes.report_type eq 8>
					PRODUCT_CAT PC,
				</cfif>
				PRODUCT P
			WHERE
				O.NETTOTAL > 0 
				AND 
				(
					(O.PURCHASE_SALES = 1 AND O.ORDER_ZONE = 0)  
					OR
					(O.PURCHASE_SALES = 0 AND O.ORDER_ZONE = 1)
				)
				AND ORD_R.IS_PROMOTION <> 1
				AND O.ORDER_ID = ORD_R.ORDER_ID 
				AND S.PRODUCT_ID = P.PRODUCT_ID 
				AND ORD_R.STOCK_ID = S.STOCK_ID
				AND ORDER_DATE BETWEEN #attributes.date1# AND #attributes.date2#
				<cfif len(attributes.status)>
					AND O.ORDER_STATUS = #attributes.status# 
				</cfif>
				<cfif attributes.report_type eq 1>
					AND O.DELIVER_DEPT_ID = D.DEPARTMENT_ID
					AND D.BRANCH_ID = B.BRANCH_ID
				<cfelseif attributes.report_type eq 2>
					AND P.PRODUCT_CATID = PC.PRODUCT_CATID
				<cfelseif attributes.report_type eq 3 or attributes.report_type eq 8>
					<!--- AND LEFT(P.PRODUCT_CODE,(CHARINDEX('.',P.PRODUCT_CODE)-1))=PC.HIERARCHY  --->
					AND (
							( CHARINDEX('.',P.PRODUCT_CODE) <> 0 AND LEFT(P.PRODUCT_CODE,(ABS(CHARINDEX('.',P.PRODUCT_CODE)-1)))=PC.HIERARCHY ) OR
							( CHARINDEX('.',P.PRODUCT_CODE) <= 0 AND P.PRODUCT_CODE = PC.HIERARCHY )
						)
				<cfelseif attributes.report_type eq 4>
					AND P.BRAND_ID = PB.BRAND_ID
				<cfelseif attributes.report_type eq 5>
					AND P.COMPANY_ID = C.COMPANY_ID
				<cfelseif attributes.report_type eq 6>
					AND O.ORDER_EMPLOYEE_ID = E.EMPLOYEE_ID
				<cfelseif attributes.report_type eq 7>
					AND P.PRODUCT_MANAGER = E.POSITION_CODE
				<!--- <cfelseif attributes.report_type eq 8>
					AND LEFT(P.PRODUCT_CODE,(CHARINDEX('.',P.PRODUCT_CODE)-1))=PC.HIERARCHY  --->
				</cfif>
				<cfif len(trim(attributes.product_cat)) and len(attributes.search_product_catid) >
					AND S.STOCK_CODE LIKE '#attributes.search_product_catid#%' 
				</cfif>
				<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
					AND P.PRODUCT_ID = #attributes.product_id#
				</cfif>
				<cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
					AND P.BRAND_ID = #attributes.brand_id#
				</cfif>
				<cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
					AND P.COMPANY_ID = #attributes.sup_company_id# 
				</cfif>
				<cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
					AND P.PRODUCT_MANAGER = #attributes.product_employee_id# 
				</cfif>
				<cfif len(attributes.zone_id)>
					AND O.ZONE_ID = #attributes.zone_id#
				</cfif>
				<cfif len(attributes.cancel_type_id)>
					AND O.CANCEL_TYPE_ID = #attributes.cancel_type_id# 
				</cfif>
				<cfif len(attributes.payment_type) and len(attributes.payment_type_id)>
					AND O.PAYMETHOD = #attributes.payment_type_id#
				<cfelseif len(attributes.payment_type) and len(attributes.card_paymethod_id)>
					AND O.CARD_PAYMETHOD_ID = #attributes.card_paymethod_id#
				</cfif>
				<cfif len(trim(attributes.employee)) and len(attributes.employee_id)>
					AND O.ORDER_EMPLOYEE_ID = #attributes.employee_id# 
				</cfif>
				<cfif len(attributes.ship_method_id) and len(attributes.ship_method_name)>
					AND O.SHIP_METHOD = #attributes.ship_method_id#
				</cfif>
				<cfif len(attributes.order_stage)>
					AND ORD_R.ORDER_ROW_CURRENCY IN (#attributes.order_stage#)
				</cfif>
				<cfif len(attributes.order_process_cat)>
					AND O.ORDER_STAGE IN (#attributes.order_process_cat#)
				</cfif>
				<cfif len(attributes.cost_status) and attributes.cost_status eq 0>
					AND P.PRODUCT_ID NOT IN(SELECT PRODUCT_ID FROM PRODUCT_COST)
				<cfelseif len(attributes.cost_status) and attributes.cost_status eq 1>
					AND P.PRODUCT_ID IN(SELECT PRODUCT_ID FROM PRODUCT_COST)
				</cfif>
				<cfif len(attributes.department_id)>
					AND(
					<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
						(O.DELIVER_DEPT_ID = #listfirst(dept_i,'-')# AND O.LOCATION_ID = #listlast(dept_i,'-')#)
						<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
					</cfloop>  
					) 
				<cfelseif len(branch_dep_list)>
					AND	(O.DELIVER_DEPT_ID IN(#branch_dep_list#) OR O.DELIVER_DEPT_ID IS NULL)
				</cfif>
				<cfif len(trim(attributes.row_employee)) and len(attributes.row_employee_id)>
					AND O.ORDER_EMPLOYEE_ID = #attributes.row_employee_id# 
				</cfif>
		<cfif (not len(attributes.status)) and isdefined("attributes.is_iptal")>
			UNION ALL
			SELECT
				<cfif isdefined("attributes.is_kdv")>
					-1*(ORD_R.QUANTITY*ORD_R.PRICE*(100+ORD_R.TAX)/100) GROSSTOTAL,
					-1*((1- (O.SA_DISCOUNT)/((O.NETTOTAL)-O.TAXTOTAL+O.SA_DISCOUNT)) * (ORD_R.NETTOTAL) + (((((1- (O.SA_DISCOUNT)/(O.NETTOTAL-O.TAXTOTAL+O.SA_DISCOUNT))*( ORD_R.NETTOTAL)*ORD_R.TAX)/100)))) AS PRICE,
					-1*(ISNULL(DATEDIFF(day,GETDATE(),ISNULL((SELECT TOP 1 PAYROLL_AVG_DUEDATE FROM #dsn2_alias#.VOUCHER_PAYROLL WHERE PAYMENT_ORDER_ID = O.ORDER_ID AND PAYROLL_TYPE = 97),O.DUE_DATE))*(ORD_R.QUANTITY*ORD_R.PRICE*(100+ORD_R.TAX)/100),0)) AS AVG_DUEDATE,
					-1*(ISNULL(DATEDIFF(day,GETDATE(),ORDER_DATE)*(ORD_R.QUANTITY*ORD_R.PRICE*(100+ORD_R.TAX)/100),0)) AS AVG_ORDERDATE,
				<cfelse>
					-1*(ORD_R.QUANTITY*ORD_R.PRICE) GROSSTOTAL,
					-1*((1- O.SA_DISCOUNT/(O.NETTOTAL-O.TAXTOTAL+O.SA_DISCOUNT)) * ORD_R.NETTOTAL) AS PRICE,
					-1*(ISNULL(DATEDIFF(day,GETDATE(),ISNULL((SELECT TOP 1 PAYROLL_AVG_DUEDATE FROM #dsn2_alias#.VOUCHER_PAYROLL WHERE PAYMENT_ORDER_ID = O.ORDER_ID AND PAYROLL_TYPE = 97),O.DUE_DATE))*(ORD_R.QUANTITY*ORD_R.PRICE),0)) AS AVG_DUEDATE,
					-1*(ISNULL(DATEDIFF(day,GETDATE(),ORDER_DATE)*(ORD_R.QUANTITY*ORD_R.PRICE),0)) AS AVG_ORDERDATE,
				</cfif>
				-1*QUANTITY AS QUANTITY,
				ISNULL((
						SELECT TOP 1 (-1*ORD_R.QUANTITY)*(PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM
						)+PROM_COST
					FROM 
						PRODUCT_COST PRODUCT_COST
					WHERE 
						PRODUCT_COST.PRODUCT_ID=ORD_R.PRODUCT_ID AND
						PRODUCT_COST.START_DATE <= O.ORDER_DATE
					ORDER BY
						PRODUCT_COST.START_DATE DESC,
						PRODUCT_COST.RECORD_DATE DESC,
						PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
					),0) AS TOTAL_COST,
				(ISNULL((
					SELECT TOP 1	
						DATEDIFF(day,PHYSICAL_DATE,GETDATE())
					FROM 
						PRODUCT_COST PRODUCT_COST
					WHERE 
						PRODUCT_COST.PRODUCT_ID=ORD_R.PRODUCT_ID AND
						PRODUCT_COST.START_DATE <= O.ORDER_DATE
					ORDER BY
						PRODUCT_COST.START_DATE DESC,
						PRODUCT_COST.RECORD_DATE DESC,
						PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
					),0)*QUANTITY) AS PHYSICAL_TOTAL_DATE,
				0 AS AMOUNT,
				0 AS TOTAL_STOCK_COST,
				0 AS TOTAL_STOCK_DATE,
				0 AS CLAIM_TOTAL,
				0 AS VOUCHER_DUEDATE,
				<cfif attributes.report_type eq 1>
					B.BRANCH_ID,
					B.BRANCH_NAME
				<cfelseif attributes.report_type eq 2>
					PC.PRODUCT_CATID,
					PC.PRODUCT_CAT
				<cfelseif attributes.report_type eq 3>
					P.PRODUCT_NAME,
					P.PRODUCT_ID,
					PC.PRODUCT_CATID,
					PC.PRODUCT_CAT,
					P.BRAND_ID
				<cfelseif attributes.report_type eq 4>
					PB.BRAND_NAME,
					PB.BRAND_ID
				<cfelseif attributes.report_type eq 5>
					C.COMPANY_ID,
					C.NICKNAME
				<cfelseif attributes.report_type eq 6>
					E.EMPLOYEE_ID,
					E.EMPLOYEE_NAME,
					E.EMPLOYEE_SURNAME
				<cfelseif attributes.report_type eq 7>
					E.EMPLOYEE_ID,
					E.EMPLOYEE_NAME,
					E.EMPLOYEE_SURNAME
				<cfelseif attributes.report_type eq 8>
					ORD_R.ORDER_ROW_CURRENCY,
					O.IS_INSTALMENT,
					ORD_R.BASKET_EMPLOYEE_ID,
					O.ORDER_NUMBER,
					O.ORDER_ID,
					O.ORDER_DATE,
					PC.PRODUCT_CAT,
					PC.PRODUCT_CATID,
					S.PRODUCT_ID,
					P.PRODUCT_NAME,
					P.PRODUCT_CODE,
					P.BRAND_ID
				<cfelseif attributes.report_type eq 9>
					ISNULL(O.SALES_PARTNER_ID,O.SALES_CONSUMER_ID) AS SALES_MEMBER_ID,
					CASE WHEN O.SALES_PARTNER_ID IS NOT NULL THEN 1 ELSE 2 END AS SALES_MEMBER_TYPE
				</cfif>
			FROM 
				ORDERS O,
				ORDER_ROW ORD_R,
				STOCKS S,
				<cfif attributes.report_type eq 1>
					#dsn_alias#.BRANCH B,
					#dsn_alias#.DEPARTMENT D,
				<cfelseif attributes.report_type eq 2>
					PRODUCT_CAT PC,
				<cfelseif attributes.report_type eq 3>
					PRODUCT_CAT PC,
				<cfelseif attributes.report_type eq 4>
					PRODUCT_BRANDS PB,
				<cfelseif attributes.report_type eq 5>
					#dsn_alias#.COMPANY C,
				<cfelseif attributes.report_type eq 6>
					#dsn_alias#.EMPLOYEES E,
				<cfelseif attributes.report_type eq 7>
					#dsn_alias#.EMPLOYEE_POSITIONS E,
				<cfelseif attributes.report_type eq 8>
					PRODUCT_CAT PC,
				</cfif>
				PRODUCT P
			WHERE
				O.NETTOTAL > 0 
				AND 
				(
					(O.PURCHASE_SALES = 1 AND O.ORDER_ZONE = 0)  
					OR
					(O.PURCHASE_SALES = 0 AND O.ORDER_ZONE = 1)
				)
				AND ORD_R.IS_PROMOTION <> 1
				AND O.ORDER_ID = ORD_R.ORDER_ID 
				AND S.PRODUCT_ID = P.PRODUCT_ID 
				AND ORD_R.STOCK_ID = S.STOCK_ID
				AND O.ORDER_STATUS = 0
				AND O.CANCEL_DATE BETWEEN #attributes.date1# AND #attributes.date2#
				<cfif attributes.report_type eq 1>
					AND O.DELIVER_DEPT_ID = D.DEPARTMENT_ID
					AND D.BRANCH_ID = B.BRANCH_ID
				<cfelseif attributes.report_type eq 2>
					AND P.PRODUCT_CATID = PC.PRODUCT_CATID
				<cfelseif attributes.report_type eq 3 or attributes.report_type eq 8>
					<!--- AND LEFT(P.PRODUCT_CODE,(CHARINDEX('.',P.PRODUCT_CODE)-1))=PC.HIERARCHY  --->
					AND (
							( CHARINDEX('.',P.PRODUCT_CODE) <> 0 AND LEFT(P.PRODUCT_CODE,(ABS(CHARINDEX('.',P.PRODUCT_CODE)-1)))=PC.HIERARCHY ) OR
							( CHARINDEX('.',P.PRODUCT_CODE) <= 0 AND P.PRODUCT_CODE = PC.HIERARCHY )
						)
				<cfelseif attributes.report_type eq 4>
					AND P.BRAND_ID = PB.BRAND_ID
				<cfelseif attributes.report_type eq 5>
					AND P.COMPANY_ID = C.COMPANY_ID
				<cfelseif attributes.report_type eq 6>
					AND O.ORDER_EMPLOYEE_ID = E.EMPLOYEE_ID
				<cfelseif attributes.report_type eq 7>
					AND P.PRODUCT_MANAGER = E.POSITION_CODE
				<!--- <cfelseif attributes.report_type eq 8>
					AND LEFT(P.PRODUCT_CODE,(CHARINDEX('.',P.PRODUCT_CODE)-1))=PC.HIERARCHY  --->
				</cfif>
				<cfif len(trim(attributes.product_cat)) and len(attributes.search_product_catid) >
					AND S.STOCK_CODE LIKE '#attributes.search_product_catid#%' 
				</cfif>
				<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
					AND P.PRODUCT_ID = #attributes.product_id#
				</cfif>
				<cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
					AND P.BRAND_ID = #attributes.brand_id#
				</cfif>
				<cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
					AND P.COMPANY_ID = #attributes.sup_company_id# 
				</cfif>
				<cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
					AND P.PRODUCT_MANAGER = #attributes.product_employee_id# 
				</cfif>
				<cfif len(attributes.zone_id)>
					AND O.ZONE_ID = #attributes.zone_id#
				</cfif>
				<cfif len(attributes.cancel_type_id)>
					AND O.CANCEL_TYPE_ID = #attributes.cancel_type_id# 
				</cfif>
				<cfif len(attributes.payment_type) and len(attributes.payment_type_id)>
					AND O.PAYMETHOD = #attributes.payment_type_id#
				<cfelseif len(attributes.payment_type) and len(attributes.card_paymethod_id)>
					AND O.CARD_PAYMETHOD_ID = #attributes.card_paymethod_id#
				</cfif>
				<cfif len(trim(attributes.employee)) and len(attributes.employee_id)>
					AND O.ORDER_EMPLOYEE_ID = #attributes.employee_id# 
				</cfif>
				<cfif len(attributes.ship_method_id) and len(attributes.ship_method_name)>
					AND O.SHIP_METHOD = #attributes.ship_method_id#
				</cfif>
				<cfif len(attributes.order_stage)>
					AND ORD_R.ORDER_ROW_CURRENCY IN (#attributes.order_stage#)
				</cfif>
				<cfif len(attributes.order_process_cat)>
					AND O.ORDER_STAGE IN (#attributes.order_process_cat#)
				</cfif>
				<cfif len(attributes.cost_status) and attributes.cost_status eq 0>
					AND P.PRODUCT_ID NOT IN(SELECT PRODUCT_ID FROM PRODUCT_COST)
				<cfelseif len(attributes.cost_status) and attributes.cost_status eq 1>
					AND P.PRODUCT_ID IN(SELECT PRODUCT_ID FROM PRODUCT_COST)
				</cfif>
				<cfif len(attributes.department_id)>
					AND(
					<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
						(O.DELIVER_DEPT_ID = #listfirst(dept_i,'-')# AND O.LOCATION_ID = #listlast(dept_i,'-')#)
						<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
					</cfloop>  
					) 
				<cfelseif len(branch_dep_list)>
					AND	(O.DELIVER_DEPT_ID IN(#branch_dep_list#) OR O.DELIVER_DEPT_ID IS NULL)
				</cfif>
				<cfif len(trim(attributes.row_employee)) and len(attributes.row_employee_id)>
					AND ORD_R.BASKET_EMPLOYEE_ID = #attributes.row_employee_id# 
				</cfif>
		</cfif>
		<cfif get_all_order.recordcount>
		<cfif attributes.report_type neq 6 and attributes.report_type neq 8 and attributes.report_type neq 9>
			UNION ALL
				SELECT   
					0 AS GROSSTOTAL,
					0 AS PRICE,
					0 AS AVG_DUEDATE,
					0 AS AVG_ORDERDATE,
					0 AS QUANTITY,
					0 AS TOTAL_COST,
					0 AS PHYSICAL_TOTAL_DATE,
					SUM(SR.STOCK_IN-SR.STOCK_OUT) AMOUNT,
					ROUND(ISNULL((
							SELECT TOP 1 (PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM)
						FROM 
							PRODUCT_COST PRODUCT_COST
						WHERE 
							PRODUCT_COST.PRODUCT_ID=S.PRODUCT_ID
							AND START_DATE <= #now()#
						ORDER BY
							PRODUCT_COST.START_DATE DESC,
							PRODUCT_COST.RECORD_DATE DESC,
							PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
						),0)*SUM(SR.STOCK_IN-SR.STOCK_OUT),2) AS TOTAL_STOCK_COST,
					ROUND((ISNULL((
						SELECT TOP 1	
							 DATEDIFF(day,GETDATE(),PHYSICAL_DATE)
						FROM 
							PRODUCT_COST PRODUCT_COST
						WHERE 
							PRODUCT_COST.PRODUCT_ID=S.PRODUCT_ID
							AND START_DATE <= #now()#
						ORDER BY
							PRODUCT_COST.START_DATE DESC,
							PRODUCT_COST.RECORD_DATE DESC,
							PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
						),0)*SUM(SR.STOCK_IN-SR.STOCK_OUT)),2) AS TOTAL_STOCK_DATE,
					0 AS CLAIM_TOTAL,
					0 AS VOUCHER_DUEDATE,
					<cfif attributes.report_type eq 1>
						B.BRANCH_ID,
						B.BRANCH_NAME
					<cfelseif attributes.report_type eq 2>
						PC.PRODUCT_CATID,
						PC.PRODUCT_CAT
					<cfelseif attributes.report_type eq 3>
						P.PRODUCT_NAME,
						P.PRODUCT_ID,
						PC.PRODUCT_CATID,
						PC.PRODUCT_CAT,
						P.BRAND_ID
					<cfelseif attributes.report_type eq 4>
						PB.BRAND_NAME,
						PB.BRAND_ID
					<cfelseif attributes.report_type eq 5>
						C.COMPANY_ID,
						C.NICKNAME
					<cfelseif attributes.report_type eq 7>
						E.EMPLOYEE_ID,
						E.EMPLOYEE_NAME,
						E.EMPLOYEE_SURNAME
					</cfif>
				FROM        
					#dsn2_alias#.STOCKS_ROW SR,
					STOCKS S,
					<cfif attributes.report_type eq 1>
						#dsn_alias#.BRANCH B,
						#dsn_alias#.DEPARTMENT D,
					<cfelseif attributes.report_type eq 2>
						PRODUCT_CAT PC,
					<cfelseif attributes.report_type eq 3>
						PRODUCT P,
						PRODUCT_CAT PC,
					<cfelseif attributes.report_type eq 4>
						PRODUCT_BRANDS PB,
					<cfelseif attributes.report_type eq 5>
						#dsn_alias#.COMPANY C,
					<cfelseif attributes.report_type eq 7>
						#dsn_alias#.EMPLOYEE_POSITIONS E,
					</cfif>
					#dsn_alias#.STOCKS_LOCATION SL
				WHERE
					SR.STOCK_ID=S.STOCK_ID
					AND SR.STORE = SL.DEPARTMENT_ID
					AND SR.STORE_LOCATION=SL.LOCATION_ID
					<cfif attributes.report_type eq 1>
						AND SL.DEPARTMENT_ID = D.DEPARTMENT_ID
						AND D.BRANCH_ID = B.BRANCH_ID
					<cfelseif attributes.report_type eq 2>
						AND S.PRODUCT_CATID = PC.PRODUCT_CATID
					<cfelseif attributes.report_type eq 3>
						AND S.PRODUCT_ID = P.PRODUCT_ID
						AND (
								(CHARINDEX('.',S.STOCK_CODE) > 0 AND LEFT(S.STOCK_CODE,ABS((CHARINDEX('.',S.STOCK_CODE)-1))) = PC.HIERARCHY) OR
								(CHARINDEX('.',S.STOCK_CODE) <= 0 AND S.STOCK_CODE = PC.HIERARCHY)
							)
					<cfelseif attributes.report_type eq 4>
						AND S.BRAND_ID = PB.BRAND_ID
					<cfelseif attributes.report_type eq 5>
						AND S.COMPANY_ID = C.COMPANY_ID
					<cfelseif attributes.report_type eq 7>
						AND S.PRODUCT_MANAGER = E.POSITION_CODE
					</cfif>
					<cfif len(attributes.department_id)>
						AND
							(
							<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
							(SR.STORE = #listfirst(dept_i,'-')# AND SR.STORE_LOCATION = #listlast(dept_i,'-')#)
							<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
							</cfloop>  
							)
					<cfelseif len(branch_dep_list)>
						AND SR.STORE IN (#branch_dep_list#)
					</cfif>
					<cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
						AND S.COMPANY_ID = #attributes.sup_company_id#
					</cfif>
					<cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
						AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
					</cfif>
					<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
						AND S.PRODUCT_ID = #attributes.product_id#
					</cfif>
					<cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
						AND S.BRAND_ID = #attributes.brand_id# 
					</cfif>	
					<cfif len(trim(attributes.product_cat)) and len(attributes.search_product_catid) >
						AND S.STOCK_CODE LIKE '#attributes.search_product_catid#%' 
					</cfif>
					<cfif len(attributes.cost_status) and attributes.cost_status eq 0>
						AND S.PRODUCT_ID NOT IN(SELECT PRODUCT_ID FROM PRODUCT_COST)
					<cfelseif len(attributes.cost_status) and attributes.cost_status eq 1>
						AND S.PRODUCT_ID NOT IN(SELECT PRODUCT_ID FROM PRODUCT_COST)
					</cfif>
					<cfif attributes.report_type eq 1>
						AND SR.STORE IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID IN(#process_id_list#))
					<cfelseif attributes.report_type eq 2>
						AND S.PRODUCT_CATID IN (#process_id_list#)
					<cfelseif attributes.report_type eq 3>
						AND S.PRODUCT_ID IN (#process_id_list#)
					<cfelseif attributes.report_type eq 4>
						AND S.BRAND_ID IN (#process_id_list#)
					<cfelseif attributes.report_type eq 5>
						AND S.COMPANY_ID IN (#process_id_list#)
					<cfelseif attributes.report_type eq 7>
						AND E.EMPLOYEE_ID IN (#process_id_list#)	
					</cfif>
				GROUP BY
					S.PRODUCT_ID,
					<cfif attributes.report_type eq 1>
						B.BRANCH_ID,
						B.BRANCH_NAME
					<cfelseif attributes.report_type eq 2>
						PC.PRODUCT_CATID,
						PC.PRODUCT_CAT
					<cfelseif attributes.report_type eq 3>
						P.PRODUCT_NAME,
						P.PRODUCT_ID,
						PC.PRODUCT_CATID,
						PC.PRODUCT_CAT,
						P.BRAND_ID
					<cfelseif attributes.report_type eq 4>
						PB.BRAND_NAME,
						PB.BRAND_ID
					<cfelseif attributes.report_type eq 5>
						C.COMPANY_ID,
						C.NICKNAME
					<cfelseif attributes.report_type eq 7>
						E.EMPLOYEE_ID,
						E.EMPLOYEE_NAME,
						E.EMPLOYEE_SURNAME
					</cfif>
		</cfif>
		<cfif attributes.report_type eq 1>
			UNION ALL
				SELECT
					0 AS GROSSTOTAL,
					0 AS PRICE,
					0 AS AVG_DUEDATE,
					0 AS AVG_ORDERDATE,
					0 AS QUANTITY,
					0 AS TOTAL_COST,
					0 AS PHYSICAL_TOTAL_DATE,
					0 AS AMOUNT,
					0 AS TOTAL_STOCK_COST,
					0 AS TOTAL_STOCK_DATE,
					V.OTHER_MONEY_VALUE AS CLAIM_TOTAL,
					DATEDIFF(day,GETDATE(),ISNULL(VOUCHER_DUEDATE,0))*OTHER_MONEY_VALUE AS VOUCHER_DUEDATE,
					B.BRANCH_ID,
					B.BRANCH_NAME
				FROM
					#dsn2_alias#.VOUCHER V,
					#dsn2_alias#.VOUCHER_PAYROLL VP,
					#dsn2_alias#.CASH C,
					#dsn_alias#.BRANCH B
				WHERE
					V.VOUCHER_PAYROLL_ID = VP.ACTION_ID AND
					VP.PAYROLL_CASH_ID = C.CASH_ID AND
					C.BRANCH_ID = B.BRANCH_ID AND
					V.VOUCHER_DUEDATE < GETDATE() AND
					DATEDIFF(day,VOUCHER_DUEDATE,GETDATE()) > 15 AND
					V.VOUCHER_STATUS_ID IN(1,11) AND
					B.BRANCH_ID IN (#process_id_list#)
		</cfif>
		</cfif>)T1
		GROUP BY
			<cfif attributes.report_type eq 1>
				BRANCH_ID,
				BRANCH_NAME
			<cfelseif attributes.report_type eq 2>
				PRODUCT_CAT
			<cfelseif attributes.report_type eq 3>
				PRODUCT_NAME,
				PRODUCT_ID,
				PRODUCT_CAT,
				BRAND_ID
			<cfelseif attributes.report_type eq 4>
				BRAND_NAME
			<cfelseif attributes.report_type eq 5>
				COMPANY_ID,
				NICKNAME
			<cfelseif attributes.report_type eq 6>
				EMPLOYEE_ID,
				EMPLOYEE_NAME,
				EMPLOYEE_SURNAME
			<cfelseif attributes.report_type eq 7>
				EMPLOYEE_ID,
				EMPLOYEE_NAME,
				EMPLOYEE_SURNAME
			<cfelseif attributes.report_type eq 8>
				ORDER_ROW_CURRENCY,
				IS_INSTALMENT,
				BASKET_EMPLOYEE_ID,
				ORDER_NUMBER,
				ORDER_ID,
				ORDER_DATE,
				PRODUCT_CAT,
				PRODUCT_CATID,
				PRODUCT_ID,
				PRODUCT_NAME,
				PRODUCT_CODE,
				BRAND_ID
			<cfelseif attributes.report_type eq 9>				
				SALES_MEMBER_ID,
				SALES_MEMBER_TYPE
			</cfif>
		HAVING SUM(PRICE) IS NOT NULL
		ORDER BY
			<cfif attributes.report_sort eq 1>
				SUM(PRICE) DESC
			<cfelseif attributes.report_sort eq 2>
				SUM(QUANTITY) DESC
			<cfelseif attributes.report_sort eq 3>
				SUM(PRICE-TOTAL_COST) DESC
			</cfif>
		</cfquery>
<cfelse>
	<cfset get_sale_orders.recordcount = 0>
</cfif>
<cfif isdate(attributes.date1)>
	<cfset attributes.date1 = dateformat(attributes.date1, dateformat_style)>
</cfif>
<cfif isdate(attributes.date2)>
	<cfset attributes.date2 = dateformat(attributes.date2, dateformat_style)>
</cfif>
<cfset toplam_adet = 0>
<cfset toplam_maliyet = 0>
<cfset toplam_birim_maliyet = 0>
<cfset toplam_ort_satis = 0>
<cfset toplam_satis = 0>
<cfset toplam_brüt_kar = 0>
<cfset toplam_vade_farki = 0>
<cfset toplam_satis_kari= 0>
<cfset toplam_stok_miktari= 0>
<cfset toplam_stok_tutarı= 0>
<cfset toplam_stok_finans_gideri= 0>
<cfset toplam_alacak = 0>
<cfset toplam_vade_alacak = 0>
<cfset toplam_vade_alacak_farkı = 0>
<cfset toplam_net_kar = 0>
<cfset toplam_maliyet_vade = 0>
<cfset toplam_satis_vade = 0>
<cfset toplam_alacak_vade = 0>
<cfset toplam_stok_vade = 0>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default="#get_sale_orders.recordcount#">
<cfif isdefined('attributes.is_excel') and  attributes.is_excel eq 1>
	<cfset attributes.startrow=1>
	<cfset attributes.maxrows=get_sale_orders.recordcount>
</cfif>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="rapor" action="#request.self#?fuseaction=report.sale_stock_analyse_orders" method="post">
	<cf_report_list_search title="#getLang('report',274)#">
		<cf_report_list_search_area>		
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='74.Kategori'></label>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="search_product_catid" id="search_product_catid" value="<cfif len(attributes.product_cat)><cfoutput>#attributes.search_product_catid#</cfoutput></cfif>">
												<input type="text" name="product_cat" id="product_cat" value="<cfif len(attributes.product_cat)><cfoutput>#attributes.product_cat#</cfoutput></cfif>" onfocus="AutoComplete_Create('product_cat','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','HIERARCHY','search_product_catid','','3','200');" >
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_code=rapor.search_product_catid&field_name=rapor.product_cat</cfoutput>','list');"></span>
											</div>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='245.Ürün'></label>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="product_id" id="product_id" value="<cfif len(attributes.product_name)><cfoutput>#attributes.product_id#</cfoutput></cfif>">
												<input type="text" name="product_name" id="product_name" value="<cfoutput>#attributes.product_name#</cfoutput>" passthrough="readonly=yes" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product_autocomplete','0','PRODUCT_ID','product_id','form','3','250');">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=rapor.product_id&field_name=rapor.product_name','list');"></span>
											</div>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='1435.Marka'></label>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="brand_id" id="brand_id"  value="<cfif len(attributes.brand_name)><cfoutput>#attributes.brand_id#</cfoutput></cfif>">
												<input type="text" name="brand_name" id="brand_name" value="<cfif len(attributes.brand_name)><cfoutput>#attributes.brand_name#</cfoutput></cfif>" maxlength="255" onFocus="AutoComplete_Create('brand_name','BRAND_NAME','BRAND_NAME','get_brand','','BRAND_ID','brand_id','form','3','100');">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_brands&brand_id=rapor.brand_id&brand_name=rapor.brand_name','small');"></span>
											</div>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='1104.Ödeme Yöntemi'></label>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="<cfoutput>#attributes.card_paymethod_id#</cfoutput>">
												<input type="hidden" name="payment_type_id" id="payment_type_id" value="<cfoutput>#attributes.payment_type_id#</cfoutput>">
												<input type="text" name="payment_type" id="payment_type" value="<cfoutput>#attributes.payment_type#</cfoutput>" onfocus="AutoComplete_Create('payment_type','PAYMETHOD','PAYMETHOD','get_paymethod','\'1,2\'','PAYMETHOD_ID,PAYMENT_TYPE_ID','payment_type_id,card_paymethod_id','','3','200');">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_paymethods&field_id=rapor.payment_type_id&field_name=rapor.payment_type&field_card_payment_id=rapor.card_paymethod_id&field_card_payment_name=rapor.payment_type','medium');"></span>
											</div>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='1736.Tedarikçi'></label>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="sup_company_id" id="sup_company_id" value="<cfif len(attributes.sup_company)><cfoutput>#attributes.sup_company_id#</cfoutput></cfif>">
												<input type="text" name="sup_company" id="sup_company" value="<cfif len(attributes.sup_company)><cfoutput>#attributes.sup_company#</cfoutput></cfif>" onfocus="AutoComplete_Create('sup_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','sup_company_id','','3','250');">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=rapor.sup_company&field_comp_id=rapor.sup_company_id&select_list=2','list');"></span>
											</div>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang no='482.Satış Temsilcisi'></label>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="row_employee_id" id="row_employee_id"  value="<cfif len(attributes.row_employee)><cfoutput>#attributes.row_employee_id#</cfoutput></cfif>">
												<input type="text" name="row_employee" id="row_employee" value="<cfif len(attributes.row_employee)><cfoutput>#attributes.row_employee#</cfoutput></cfif>" maxlength="255" onFocus="AutoComplete_Create('row_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE,MEMBER_NAME','row_employee_id,row_employee','','3','135');">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=rapor.row_employee_id&field_emp_id2=rapor.row_employee_id&field_name=rapor.row_employee<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,9','list');"></span>	
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='1036.Ürün Sorumlusu'></label>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="product_employee_id" id="product_employee_id" value="<cfif len(attributes.employee_name)><cfoutput>#attributes.product_employee_id#</cfoutput></cfif>">
												<input type="text" name="employee_name" id="employee_name" value="<cfif len(attributes.employee_name)><cfoutput>#attributes.employee_name#</cfoutput></cfif>" maxlength="255" onfocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','125');">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=rapor.product_employee_id&field_code=rapor.product_employee_id&field_name=rapor.employee_name&select_list=1,9','list');"></span>	
											</div>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang no='643.Satışı Yapan'></label>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="employee_id" id="employee_id"  value="<cfif len(attributes.employee)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
												<input type="text" name="employee" id="employee" value="<cfif len(attributes.employee)><cfoutput>#attributes.employee#</cfoutput></cfif>" maxlength="255" onfocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE,MEMBER_NAME','employee_id,employee','','3','135');">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=rapor.employee_id&field_emp_id2=rapor.employee_id&field_name=rapor.employee&select_list=1,9','list');"></span>
											</div>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='1703.Sevk Yöntemi'></label>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="ship_method_id" id="ship_method_id" value="<cfif len(attributes.ship_method_name)><cfoutput>#attributes.ship_method_id#</cfoutput></cfif>">
												<input type="text" name="ship_method_name" id="ship_method_name" value="<cfif len(attributes.ship_method_name)><cfoutput>#attributes.ship_method_name#</cfoutput></cfif>" onFocus="AutoComplete_Create('ship_method_name','SHIP_METHOD','SHIP_METHOD','get_ship_method','','SHIP_METHOD_ID','ship_method_id','','3','140');">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method_id','list');"></span>	
											</div>
										</div>
									</div>
									<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang_main no='1351.Depo'></label>
										<div class="col col-12 col-xs-12">
												<cfquery name="GET_ALL_LOCATION" datasource="#dsn#">
													SELECT
														*
													FROM
														STOCKS_LOCATION
												</cfquery>						
												<select name="department_id" id="department_id" style="height:115px;" multiple>
													<cfoutput query="get_department">
														<optgroup label="#department_head#">
														<cfquery name="GET_LOCATION" dbtype="query">
															SELECT * FROM GET_ALL_LOCATION WHERE DEPARTMENT_ID = #get_department.department_id[currentrow]#
														</cfquery>
														<cfif get_location.recordcount>
															<cfloop from="1" to="#get_location.recordcount#" index="s">
																<option value="#department_id#-#get_location.location_id[s]#" <cfif listfind(attributes.department_id,'#department_id#-#get_location.location_id[s]#',',')>selected</cfif>>&nbsp;&nbsp;#get_location.comment[s]#</option>
															</cfloop>
														</cfif>
														</optgroup>					  
													</cfoutput>
												</select>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='247.Satış Bölgesi'></label>
										<div class="col col-12 col-xs-12">
											<select name="zone_id" id="zone_id">
												<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
												<cfoutput query="get_sales_zone">
													<option value="#sz_id#" <cfif attributes.zone_id eq sz_id>selected</cfif>>#sz_name#</option>
												</cfoutput>
											</select>	
										</div>
									</div>								
									<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang no='954.Sipariş Aşaması'></label>
										<div class="col col-12 col-xs-12">
											<select name="order_stage" id="order_stage" style="height:90px;" multiple>
												<option value="-7" <cfif listfind(attributes.order_stage,-7)>selected</cfif>><cf_get_lang_main no='1951.Eksik Teslimat'></option>
												<option value="-8" <cfif listfind(attributes.order_stage,-8)>selected</cfif>><cf_get_lang_main no='1952.Fazla Teslimat'></option>
												<option value="-6" <cfif listfind(attributes.order_stage,-6)>selected</cfif>><cf_get_lang_main no='1349.Sevk'></option>
												<option value="-5" <cfif listfind(attributes.order_stage,-5)>selected</cfif>><cf_get_lang_main no='44.Üretim'></option>
												<option value="-4" <cfif listfind(attributes.order_stage,-4)>selected</cfif>><cf_get_lang_main no='1950.Kısmi Üretim'></option>
												<option value="-3" <cfif listfind(attributes.order_stage,-3)>selected</cfif>><cf_get_lang_main no='1949.Kapatıldı'></option>
												<option value="-2" <cfif listfind(attributes.order_stage,-2)>selected</cfif>><cf_get_lang_main no='1948.Tedarik'></option>
												<option value="-1" <cfif listfind(attributes.order_stage,-1)>selected</cfif>><cf_get_lang_main no='1305.Açık'></option>
												<option value="-9" <cfif listfind(attributes.order_stage,-9)>selected</cfif>><cf_get_lang_main no='1094.İptal'></option>
												<option value="-10" <cfif listfind(attributes.order_stage,-10)>selected</cfif>><cf_get_lang_main no='1211.Kapatıldı(Manuel)'></option>
											</select>		
										</div>
									</div>
									<div class="form-group">
											<label class="col col-12 col-xs-12"><cf_get_lang no='974.Sipariş Süreci'></label>
										<div class="col col-12 col-xs-12">
											<select name="order_process_cat" id="order_process_cat" style="height:90px;" multiple>
												<cfoutput query="get_process_type">
													<option value="#process_row_id#"<cfif listfind(attributes.order_process_cat,process_row_id)>selected</cfif>>#stage#</option>
												</cfoutput>
											</select>		
										</div>
									</div>
									
								</div>
							</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='1413.İptal Nedeni'></label>
										<div class="col col-12 col-xs-12">
											<select name="cancel_type_id" id="cancel_type_id">
												<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
												<cfoutput query="get_cancel_type">
													<option value="#subscription_cancel_type_id#" <cfif subscription_cancel_type_id eq attributes.cancel_type_id>selected</cfif>>#subscription_cancel_type#</option>
												</cfoutput>
											</select>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='1548.Rapor Tipi'></label>
										<div class="col col-12 col-xs-12">
											<select name="report_type" id="report_type">
												<option value="1" <cfif attributes.report_type eq 1>selected</cfif>> <cf_get_lang no='629.Şube Bazında'></option>
												<option value="2" <cfif attributes.report_type eq 2>selected</cfif>> <cf_get_lang no='331.Kategori Bazında'></option>
												<option value="3" <cfif attributes.report_type eq 3>selected</cfif>> <cf_get_lang no='332.Ürün Bazında'></option>
												<option value="4" <cfif attributes.report_type eq 4>selected</cfif>> <cf_get_lang no='374.Marka Bazında'></option>
												<option value="5" <cfif attributes.report_type eq 5>selected</cfif>> <cf_get_lang no='628.Tedarikçi Bazında'></option>
												<option value="6" <cfif attributes.report_type eq 6>selected</cfif>> <cf_get_lang no='534.Satış Temsilcisi Bazında'></option>
												<option value="7" <cfif attributes.report_type eq 7>selected</cfif>> <cf_get_lang no='975.Ürün Sorumlusu Bazında'></option>
												<option value="8" <cfif attributes.report_type eq 8>selected</cfif>> <cf_get_lang no='964.Belge ve Stok Bazında'></option>
												<option value="9" <cfif attributes.report_type eq 9>selected</cfif>> <cf_get_lang no='1557.Satış Ortağı Bazında'></option>
											</select>	
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang no='1893.Maliyet Durumu'></label>
										<div class="col col-12 col-xs-12">
											<select name="cost_status" id="cost_status" >
												<option value=""><cf_get_lang_main no='296.Tümü'></option>
												<option value="0"<cfif attributes.cost_status eq 0> selected</cfif>><cf_get_lang no='1895.Sıfır Maliyeti Olan Ürünler'></option>
												<option value="1"<cfif attributes.cost_status eq 1> selected</cfif>><cf_get_lang no='1896.Maliyeti Sıfırdan Büyük Olan Ürünler'></option>
											</select>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang no='1892.Vade Farkı Oranı'></label>
										<div class="col col-6">
												<cfinput name="datediff_value" value="#attributes.datediff_value#" validate="integer" class="moneybox" onKeyUp="if(this.value.length == 0 || filterNum(this.value)==0 || this.value == '') this.value = 0; return(FormatCurrency(this,event));">
										</div>
										<div class="col col-6">
											<select name="status" id="status">
												<option value=""><cf_get_lang_main no='296.Tümü'></option>
												<option value="0"<cfif attributes.status eq 0> selected</cfif>><cf_get_lang_main no='82.Pasif'></option>
												<option value="1"<cfif attributes.status eq 1> selected</cfif>><cf_get_lang_main no='81.Aktif'></option>
											</select>										
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='330.Tarih'>*</label>
										<div class="col col-6">
											<div class="input-group">
												<cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no='641.Başlangıç Tarihi'></cfsavecontent>
												<cfinput value="#attributes.date1#" type="text" maxlength="10" name="date1" validate="#validate_style#" required="yes" message="#message#">
												<span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>
											</div>
										</div>
										<div class="col col-6">
											<div class="input-group">
												<cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no='288.Bitiş Tarihi'></cfsavecontent>
												<cfinput value="#attributes.date2#" type="text" maxlength="10" name="date2" validate="#validate_style#" required="yes" message="#message#">
												<span class="input-group-addon"><cf_wrk_date_image date_field="date2"></span>
											</div>
										</div>
									</div>
									<div class="form-group">
											<div class="col col-12 col-xs-12"></div>
										<div class="col col-12 col-xs-12">
											<label><cf_get_lang no='640.Ciroya Göre'><input type="radio" name="report_sort" id="report_sort" value="1"  <cfif attributes.report_sort eq 1>checked</cfif>></label>
											<label><cf_get_lang no='641.Miktara Göre'><input type="radio" name="report_sort" id="report_sort" value="2"  <cfif attributes.report_sort eq 2>checked</cfif>></label>
											<label><cf_get_lang no='1894.Brüt Kara Göre'><input type="radio" name="report_sort" id="report_sort" value="3"  <cfif attributes.report_sort eq 3>checked</cfif>></label><br/>
											<label><cf_get_lang no='338.KDV Dahil'><input name="is_kdv" id="is_kdv" value="" type="checkbox" <cfif isdefined("attributes.is_kdv")>checked</cfif>></label>
											<label><cf_get_lang no='939.İptaller Düşsün'><input name="is_iptal" id="is_iptal" value="" type="checkbox" <cfif isdefined("attributes.is_iptal")>checked</cfif>></label>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row ReportContentBorder">
						<div class="ReportContentFooter">
							<label><cf_get_lang_main no='446.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>
							<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" onKeyUp="isNumber(this)"  range="1,999" message="#message#" maxlength="3" style="width:25px;">
							<cfsavecontent variable="message"><cf_get_lang_main no ='499.Çalıştır'></cfsavecontent>
							<input type="hidden" name="form_submitted" id="form_submitted" value="">
							<cf_wrk_report_search_button search_function='kontrol()' insert_info='#message#' button_type='1' is_excel='1'>		
						</div>
					</div>
				</div>
			</div>
		</cf_report_list_search_area>
	</cf_report_list_search>
</cfform>
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-8">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="content-type" content="text/plain; charset=utf-8">
</cfif>
<cfif isdefined("attributes.form_submitted")>
<cf_report_list>
		
			<thead>
            <tr>
				<th <cfif attributes.report_type eq 3>colspan="3"<cfelseif attributes.report_type eq 8>colspan="6"</cfif>>&nbsp;</th>
				<cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
					<th width="1">&nbsp;</th>
				</cfif>
				<th colspan="14"  style="text-align:center;"><cf_get_lang no='1897.Satış Finansmanı'></th>
				<cfif attributes.report_type neq 6 and attributes.report_type neq 8 and attributes.report_type neq 9>
					<cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
						<th width="1">&nbsp;</th>
					</cfif>
					<th <cfif attributes.report_type eq 1>colspan="4"<cfelse>colspan="5"</cfif> style="text-align:center;"><cf_get_lang no='1898.Stok Finansmanı'></th>
				</cfif>
				<cfif attributes.report_type eq 1>
					<cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
						<th width="1">&nbsp;</th>
					</cfif>
					<th colspan="5" style="text-align:center;"><cf_get_lang no='1899.Alacak Finansmanı'></th>
				</cfif>
			</tr>
			<tr>
				<cfif attributes.report_type eq 1>
					<th width="80"><cf_get_lang_main no='41.Şube'></th>
				<cfelseif attributes.report_type eq 2>
					<th width="100"><cf_get_lang_main no='74.Kategori'></th>
				<cfelseif attributes.report_type eq 3>
					<th width="100"><cf_get_lang_main no='245.Ürün'></th>
					<th width="100"><cf_get_lang_main no='74.Kategori'></th>
					<th width="100"><cf_get_lang_main no='1435.Marka'></th>
				<cfelseif attributes.report_type eq 4>
					<th width="100"><cf_get_lang_main no='1435.Marka'></th>
				<cfelseif attributes.report_type eq 5>
					<th width="100"><cf_get_lang_main no='1736.Tedarikçi'></th>
				<cfelseif attributes.report_type eq 6>
					<th width="100"><cf_get_lang no='482.Satış Temsilcisi'></th>
				<cfelseif attributes.report_type eq 7>
					<th width="100"><cf_get_lang_main no='1036.Ürün Sorumlusu'></th>
				<cfelseif attributes.report_type eq 8>	
					<th><cf_get_lang_main no='799.Sipariş No'></th>
					<th><cf_get_lang_main no='1704.Sipariş Tarihi'></th>
					<th><cf_get_lang_main no='245.Ürün'></th>
					<th><cf_get_lang_main no='74.Kategori'></th>
					<th><cf_get_lang_main no='1435.Marka'></th>
					<th><cf_get_lang no='482.Satış Temsilcisi'></th>
				<cfelseif attributes.report_type eq 9>	
					<th><cf_get_lang no='502.Satış Ortağı'></th>
				</cfif>
				<cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
					<th width="1">&nbsp;</th>
				</cfif>
				<th style="text-align:right;"><cf_get_lang no='1442.Toplam Miktar'></th>
				<th style="text-align:right;"><cf_get_lang no='1482.Toplam Maliyet'></th>
				<th style="text-align:right;"><cf_get_lang no='1900.Maliyet Ortalaması'></th>
				<th style="text-align:right;"><cf_get_lang no='1483.Birim Maliyet'></th>
				<th style="text-align:right;"><cf_get_lang no='1901.Ürün Yaşı'></th>
				<th style="text-align:center;"><cf_get_lang no='1902.Ortalama Satış Tutarı'></th>
				<th style="text-align:center;"><cf_get_lang no='1903.Toplam Satış Tutarı'></th>
				<th style="text-align:center;"><cf_get_lang no='1904.Satışın Ortalama Vadesi'></th>
				<th style="text-align:right;"><cf_get_lang no='1905.Brüt Kar'></th>
				<th style="text-align:right;"><cf_get_lang no='1905.Brüt Kar'> %</th>
				<th style="text-align:right;"><cf_get_lang_main no='1089.Vade Farkı'></th>
				<th style="text-align:right;"><cf_get_lang_main no='1089.Vade Farkı'> %</th>
				<th style="text-align:right;"><cf_get_lang no='1906.Satış Karı'></th>
				<th style="text-align:right;"><cf_get_lang no='1906.Satış Karı'>%</th>
				<cfif attributes.report_type neq 6 and attributes.report_type neq 8 and attributes.report_type neq 9>
					<cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
						<th width="1">&nbsp;</th>
					</cfif>
					<th style="text-align:center;"><cf_get_lang no='1907.Toplam Stok Miktarı'></th>
					<th style="text-align:center;"><cf_get_lang no='1908.Toplam Stok Tutarı'></th>
					<th style="text-align:center;"><cf_get_lang no='1909.Stok Finansal Ortalaması'></th>
					<th style="text-align:center;"><cf_get_lang no='1910.Toplam Stok Finansman Gideri'></th>
				</cfif>
				<cfif attributes.report_type eq 1>
					<cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
						<th width="1">&nbsp;</th>
					</cfif>
					<th style="text-align:center;"><cf_get_lang no='1911.Toplam Vadesinde Tahsil Olmamış Alacak'></th>
					<th style="text-align:center;"><cf_get_lang no='1912.Vadesinde Tahsil Olmamış Alacak Ortalaması'></th>
					<th style="text-align:center;"><cf_get_lang no='1913.Toplam Vadesinde Tahsil Olmamış Alacak Vade Farkı'></th>
					<th style="text-align:center;"><cf_get_lang no='1914.Toplam Dönemsel Gecikme Vade Farkı'></th>
				</cfif>
				<cfif attributes.report_type neq 6 and attributes.report_type neq 8 and attributes.report_type neq 9>
					<th style="text-align:center;"><cf_get_lang no='1915.Net Kar'></th>
				</cfif>
			</tr>
            </thead>
		<cfif get_sale_orders.recordcount>
			<cfset consumer_list = ''>
			<cfset partner_list = ''>
			<cfif attributes.report_type eq 9>
				<cfoutput query="get_sale_orders" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfif len(sales_member_id) and sales_member_type eq 1 and not listfind(partner_list,sales_member_id)>
						<cfset partner_list = listappend(partner_list,sales_member_id)>
					</cfif>	
					<cfif len(sales_member_id) and sales_member_type eq 2 and not listfind(consumer_list,sales_member_id)>
						<cfset consumer_list = listappend(consumer_list,sales_member_id)>
					</cfif>		
				</cfoutput>
				<cfif len(partner_list)>
					<cfset partner_list=listsort(partner_list,"numeric","ASC",",")>
					<cfquery name="get_partner_name" datasource="#DSN#">
						SELECT
							CP.COMPANY_PARTNER_NAME,
							CP.COMPANY_PARTNER_SURNAME,
							CP.PARTNER_ID,
							C.NICKNAME,
							C.COMPANY_ID
						FROM
							COMPANY_PARTNER CP,
							COMPANY C
						WHERE
							CP.COMPANY_ID = C.COMPANY_ID AND
							CP.PARTNER_ID IN (#partner_list#)
						ORDER BY 
							CP.PARTNER_ID
					</cfquery>
					<cfset partner_list = listsort(listdeleteduplicates(valuelist(get_partner_name.partner_id,',')),'numeric','ASC',',')>
				</cfif> 
				<cfif len(consumer_list)>
					<cfset consumer_list=listsort(consumer_list,"numeric","ASC",",")>
					<cfquery name="get_consumer_name" datasource="#DSN#">
						SELECT
							CONSUMER_NAME,
							CONSUMER_SURNAME,
							CONSUMER_ID
						FROM
							CONSUMER
						WHERE
							CONSUMER_ID IN (#consumer_list#)
						ORDER BY 
							CONSUMER_ID
					</cfquery>
					<cfset consumer_list = listsort(listdeleteduplicates(valuelist(get_consumer_name.consumer_id,',')),'numeric','ASC',',')>
				</cfif>	
			</cfif>
			<cfif attributes.report_type eq 8>
				<cfset emp_id_list = ''>
				<cfoutput query="get_sale_orders" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfif len(basket_employee_id) and not listfind(emp_id_list,basket_employee_id)>
						<cfset emp_id_list=listappend(emp_id_list,basket_employee_id)>
					</cfif>  
				</cfoutput>
				<cfif len(emp_id_list)>
					<cfset emp_id_list=listsort(emp_id_list,"numeric","ASC",",")>
					<cfquery name="get_emp" datasource="#dsn#">
						SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#emp_id_list#) ORDER BY EMPLOYEE_ID
					</cfquery>
					<cfset emp_id_list = listsort(listdeleteduplicates(valuelist(get_emp.employee_id,',')),'numeric','ASC',',')>
				</cfif>
			</cfif>
			<cfif attributes.report_type eq 3 or attributes.report_type eq 8 and attributes.report_type neq 9>
				<cfset brand_id_list = ''>
				<cfoutput query="get_sale_orders" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfif len(brand_id) and not listfind(brand_id_list,brand_id)>
						<cfset brand_id_list=listappend(brand_id_list,brand_id)>
					</cfif>  
				</cfoutput>	
				<cfif len(brand_id_list)>
					<cfset brand_id_list=listsort(brand_id_list,"numeric","ASC",",")>
					<cfquery name="get_brand" datasource="#dsn1#">
						SELECT BRAND_ID,BRAND_NAME FROM PRODUCT_BRANDS WHERE BRAND_ID IN (#brand_id_list#) ORDER BY BRAND_ID
					</cfquery>
					<cfset brand_id_list = listsort(listdeleteduplicates(valuelist(get_brand.brand_id,',')),'numeric','ASC',',')>
				</cfif>
			</cfif>
			<cfif attributes.page neq 1>
				<cfoutput query="get_sale_orders" startrow="1" maxrows="#attributes.startrow-1#">
					<cfif quantity gt 0>
						<cfset unit_cost = total_cost / quantity><!--- birim maliyet --->
					<cfelse>
						<cfset unit_cost = 0>
					</cfif>
					<cfset brut_kar = price - total_cost>
					<cfset datediff_value = ((avg_duedate-avg_orderdate)*total_cost*attributes.datediff_value/100/30)><!--- Vade Farkı --->
					<cfset stock_date_value = ((total_stock_cost)*datediff('d',dateformat(attributes.date1,dateformat_style),dateformat(attributes.date2,dateformat_style))*attributes.datediff_value/100/30)><!--- Finansman gideri --->
					<cfset claim_date_value = ((claim_total)*abs(claim_duedate)*attributes.datediff_value/100/30)><!--- toplam vadesinde tahsil edilmemiş alacak --->
					<cfset claim_date_diff_value = (claim_date_value*datediff('d',dateformat(attributes.date1,dateformat_style),dateformat(attributes.date2,dateformat_style))*attributes.datediff_value/100/30)><!--- Dönemsel gecikme tutarı --->
					<!--- Alt Toplamlar --->
					<cfset toplam_adet = toplam_adet + quantity>
					<cfset toplam_maliyet = toplam_maliyet + total_cost>
					<cfset toplam_birim_maliyet = toplam_birim_maliyet + unit_cost>
					<cfif quantity gt 0>
						<cfset toplam_ort_satis = toplam_ort_satis + (price/quantity)>
					</cfif>
					<cfset toplam_satis = toplam_satis + price>
					<cfset toplam_brüt_kar = toplam_brüt_kar + brut_kar>
					<cfset toplam_vade_farki = toplam_vade_farki + datediff_value>
					<cfset toplam_satis_kari= toplam_satis_kari + (brut_kar - datediff_value)>
					<cfset toplam_stok_miktari= toplam_stok_miktari + total_amount>
					<cfset toplam_stok_tutarı= toplam_stok_tutarı + (total_stock_cost)>
					<cfset toplam_stok_finans_gideri= toplam_stok_finans_gideri + stock_date_value>
					<cfset toplam_alacak = toplam_alacak + claim_total>
					<cfset toplam_vade_alacak = toplam_vade_alacak + claim_date_value>
					<cfset toplam_vade_alacak_farkı = toplam_vade_alacak_farkı + claim_date_diff_value>
					<cfset toplam_maliyet_vade = toplam_maliyet_vade + (unit_cost*avg_orderdate)>
					<cfset toplam_satis_vade = toplam_satis_vade + (price*avg_duedate)>
					<cfset toplam_alacak_vade = toplam_alacak_vade + (claim_total*claim_duedate)>
					<cfset toplam_stok_vade = toplam_stok_vade + (total_stock_cost*total_stock_date)>
					<cfif attributes.report_type eq 1>
						<cfset toplam_net_kar = toplam_net_kar + (brut_kar-datediff_value-stock_date_value-claim_date_diff_value)>
					<cfelse>
						<cfset toplam_net_kar = toplam_net_kar + (brut_kar-datediff_value-stock_date_value)>
					</cfif>
				</cfoutput>
			</cfif>	
            <tbody>		
			<cfoutput query="get_sale_orders" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<cfif quantity gt 0>
						<cfset unit_cost = total_cost / quantity>
					<cfelse>
						<cfset unit_cost = 0>
					</cfif>
					<cfset brut_kar = price - total_cost>
					<cfset datediff_value = ((avg_duedate-avg_orderdate)*total_cost*attributes.datediff_value/100/30)>
					<cfset stock_date_value = ((total_stock_cost)*datediff('d',dateformat(attributes.date1,dateformat_style),dateformat(attributes.date2,dateformat_style))*attributes.datediff_value/100/30)>
					<cfset claim_date_value = ((claim_total)*abs(claim_duedate)*attributes.datediff_value/100/30)>
					<cfset claim_date_diff_value = (claim_date_value*datediff('d',dateformat(attributes.date1,dateformat_style),dateformat(attributes.date2,dateformat_style))*attributes.datediff_value/100/30)><!--- Dönemsel gecikme tutarı --->
					<!--- Alt Toplamlar --->
					<cfset toplam_adet = toplam_adet + quantity>
					<cfset toplam_maliyet = toplam_maliyet + total_cost>
					<cfset toplam_birim_maliyet = toplam_birim_maliyet + unit_cost>
					<cfif quantity gt 0>
						<cfset toplam_ort_satis = toplam_ort_satis + (price/quantity)>
					</cfif>
					<cfset toplam_satis = toplam_satis + price>
					<cfset toplam_brüt_kar = toplam_brüt_kar + brut_kar>
					<cfset toplam_vade_farki = toplam_vade_farki + datediff_value>
					<cfset toplam_satis_kari= toplam_satis_kari + (brut_kar - datediff_value)>
					<cfset toplam_stok_miktari= toplam_stok_miktari + total_amount>
					<cfset toplam_stok_tutarı= toplam_stok_tutarı + (total_stock_cost)>
					<cfset toplam_stok_finans_gideri= toplam_stok_finans_gideri + stock_date_value>
					<cfset toplam_alacak = toplam_alacak + claim_total>
					<cfset toplam_vade_alacak = toplam_vade_alacak + claim_date_value>
					<cfset toplam_vade_alacak_farkı = toplam_vade_alacak_farkı + claim_date_diff_value>
					<cfset toplam_maliyet_vade = toplam_maliyet_vade + (unit_cost*avg_orderdate)>
					<cfset toplam_satis_vade = toplam_satis_vade + (price*avg_duedate)>
					<cfset toplam_alacak_vade = toplam_alacak_vade + (claim_total*claim_duedate)>
					<cfset toplam_stok_vade = toplam_stok_vade + (total_stock_cost*total_stock_date)>
					<cfif attributes.report_type eq 1>
						<cfset toplam_net_kar = toplam_net_kar + (brut_kar-datediff_value-stock_date_value-claim_date_diff_value)>
					<cfelse>
						<cfset toplam_net_kar = toplam_net_kar + (brut_kar-datediff_value-stock_date_value)>
					</cfif>
					<cfif attributes.report_type eq 1>
						<td nowrap>#branch_name#</td>	
					<cfelseif attributes.report_type eq 2>
						<td nowrap>#product_cat#</td>
					<cfelseif attributes.report_type eq 3>
						<td nowrap>
							<cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
								<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#PRODUCT_ID#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','list');">
									#product_name#
								</a>
							<cfelse>
								#product_name#
							</cfif>
						</td>
						<td nowrap>#product_cat#</td>
						<td nowrap>
							<cfif len(brand_id_list) and len(brand_id)>
								#get_brand.brand_name[listfind(brand_id_list,brand_id,',')]#
							</cfif>
						</td>
					<cfelseif attributes.report_type eq 4>
						<td nowrap>#brand_name#</td>
					<cfelseif attributes.report_type eq 5>
						<td nowrap>
							<cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
								<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#company_id#','medium');">
									#nickname#
								</a>
							<cfelse>
								#nickname#
							</cfif>
						</td>
					<cfelseif attributes.report_type eq 6>
						<td nowrap>
							<cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
								<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');">
									#employee_name# #employee_surname#
								</a>
							<cfelse>
								#employee_name# #employee_surname#
							</cfif>
						</td>
					<cfelseif attributes.report_type eq 7>
						<td nowrap>
							<cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
								<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');">
									#employee_name# #employee_surname#
								</a>
							<cfelse>
								#employee_name# #employee_surname#
							</cfif>
						</td>
					<cfelseif attributes.report_type eq 8>
						<cfif is_instalment eq 1>
							<cfset page_type = 'upd_fast_sale'>
						<cfelse>
							<cfset page_type = 'list_order&event=upd'>
						</cfif>
						<td nowrap>
							<cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=sales.#page_type#&order_id=#order_id#','wide');" >
									#order_number#
								</a>
							<cfelse>
								#order_number#
							</cfif>
						</td>
						<td nowrap>#dateformat(order_date,dateformat_style)#</td>
						<td nowrap>
							<cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
								<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#PRODUCT_ID#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','list');">
									#product_name#
								</a>
							<cfelse>
								#product_name#
							</cfif>
						</td>
						<td nowrap>#product_cat#</td>
						<td nowrap>
							<cfif len(brand_id_list) and len(brand_id)>
								#get_brand.brand_name[listfind(brand_id_list,brand_id,',')]#
							</cfif>
						</td>
						<td nowrap>
							<cfif len(emp_id_list) and len(basket_employee_id)>
								<cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
									<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#basket_employee_id#','medium');">
										#get_emp.employee_name[listfind(emp_id_list,basket_employee_id,',')]#&nbsp;#get_emp.employee_surname[listfind(emp_id_list,basket_employee_id,',')]#
									</a>
								<cfelse>
										#get_emp.employee_name[listfind(emp_id_list,basket_employee_id,',')]#&nbsp;#get_emp.employee_surname[listfind(emp_id_list,basket_employee_id,',')]#
								</cfif>
							</cfif>
						</td>
					<cfelseif attributes.report_type eq 9>
						<td width="150" nowrap>
							<cfif len(sales_member_id) and sales_member_type eq 1 and len(partner_list)>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#sales_member_id#','medium');" > 
									#get_partner_name.company_partner_name[listfind(partner_list,sales_member_id,',')]# #get_partner_name.company_partner_surname[listfind(partner_list,sales_member_id,',')]#
								</a> - 
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_partner_name.company_id[listfind(partner_list,sales_member_id,',')]#','medium');" > 
									#get_partner_name.nickname[listfind(partner_list,sales_member_id,',')]#
								</a>
							<cfelseif len(sales_member_id) and sales_member_type eq 2 and len(consumer_list)>
								<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#sales_member_id#','medium','popup_con_det');">
									#get_consumer_name.consumer_name[listfind(consumer_list,sales_member_id,',')]# #get_consumer_name.consumer_surname[listfind(consumer_list,sales_member_id,',')]#
								</a>
							</cfif>
						</td>
					</cfif>
					<cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
						<td width="1">&nbsp;</td>
					</cfif>
					<td style="text-align:right;">#quantity#</td>
					<td nowrap style="text-align:right;">#TlFormat(total_cost)#</td>
					<td style="text-align:right;">#dateformat(date_add('d',avg_orderdate,now()),dateformat_style)#</td>
					<td nowrap style="text-align:right;">#TlFormat(unit_cost)#</td>
					<td nowrap style="text-align:right;">#TlFormat(total_date_cost)#</td>
					<td nowrap style="text-align:right;"><cfif quantity gt 0>#TlFormat(abs(price)/quantity)#<cfelse>#TlFormat(0)#</cfif></td>
					<td nowrap style="text-align:right;">#TlFormat(price)#</td>
					<td style="text-align:right;">#dateformat(date_add('d',avg_duedate,now()),dateformat_style)#</td>
					<td nowrap style="text-align:right;">#TlFormat(brut_kar)#</td>
					<td nowrap style="text-align:right;"><cfif price gt 0>#TlFormat((brut_kar/price)*100)#<cfelse>0</cfif></td>
					<td nowrap style="text-align:right;">#TlFormat(datediff_value)#</td>	
					<td nowrap style="text-align:right;"><cfif price gt 0>#TlFormat((datediff_value/price)*100)#<cfelse>0</cfif></td>
					<td nowrap style="text-align:right;">#TlFormat(brut_kar-datediff_value)#</td>	
					<td nowrap style="text-align:right;"><cfif price gt 0>#TlFormat(((brut_kar-datediff_value)/price)*100)#<cfelse>0</cfif></td>
					<cfif attributes.report_type neq 6 and attributes.report_type neq 8 and attributes.report_type neq 9>
						<cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
							<td width="1">&nbsp;</td>
						</cfif>
						<td nowrap style="text-align:right;">#TlFormat(total_amount)#</td>	
						<td nowrap style="text-align:right;">#TlFormat(total_stock_cost)#</td>	
						<td style="text-align:right;">#dateformat(date_add('d',total_stock_date,now()),dateformat_style)#</td>	
						<td nowrap style="text-align:right;">#TlFormat(stock_date_value)#</td>	
					</cfif>
					<cfif attributes.report_type eq 1>
						<cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
							<td width="1">&nbsp;</td>
						</cfif>
						<td nowrap style="text-align:right;">#TlFormat(claim_total)#</td>	
						<td style="text-align:right;">#dateformat(date_add('d',claim_duedate,now()),dateformat_style)#</td>
						<td nowrap style="text-align:right;">#TlFormat(claim_date_value)#</td>
						<td nowrap style="text-align:right;">#TlFormat(claim_date_diff_value)#</td>
						<td nowrap style="text-align:right;">#TlFormat(brut_kar-datediff_value-stock_date_value-claim_date_diff_value)#</td>
					<cfelseif attributes.report_type neq 6 and attributes.report_type neq 8 and attributes.report_type neq 9>
						<td nowrap style="text-align:right;">#TlFormat(brut_kar-datediff_value-stock_date_value)#</td>
					</cfif>
				</tr>
			</cfoutput>
			<cfoutput>
				<tr class="total" height="30">
					<td class="txtbold" style="text-align:right;" <cfif attributes.report_type eq 3>colspan="3"<cfelseif attributes.report_type eq 8>colspan="6"</cfif>><cf_get_lang_main no='80.Toplam'></td>
					<cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
						<td width="1">&nbsp;</td>
					</cfif>
					<td class="txtbold" style="text-align:right;">#toplam_adet#</td>
					<td nowrap class="txtbold" style="text-align:right;">#TlFormat(toplam_maliyet)#</td>
					<td class="txtbold" style="text-align:right;">
						<cfif toplam_birim_maliyet gt 0>
							<cfset due_day = toplam_maliyet_vade / toplam_birim_maliyet>
						<cfelse>
							<cfset due_day = 0>
						</cfif>
						#dateformat(date_add('d',due_day,now()),dateformat_style)#
					</td>
					<td nowrap class="txtbold" style="text-align:right;">#TlFormat(toplam_birim_maliyet)#</td>
					<td nowrap style="text-align:right;"></td>
					<td nowrap class="txtbold" style="text-align:right;">#TlFormat(toplam_ort_satis)#</td>
					<td nowrap class="txtbold" style="text-align:right;">#TlFormat(toplam_satis)#</td>
					<td class="txtbold" style="text-align:right;">
						<cfif toplam_satis gt 0>
							<cfset due_day1 = toplam_satis_vade / toplam_satis>
						<cfelse>
							<cfset due_day1 = 0>
						</cfif>
						#dateformat(date_add('d',due_day1,now()),dateformat_style)#
					</td>
					<td nowrap class="txtbold" style="text-align:right;">#TlFormat(toplam_brüt_kar)#</td>
					<td nowrap class="txtbold" style="text-align:right;">% <cfif toplam_satis gt 0>#TlFormat((toplam_brüt_kar/toplam_satis)*100)#<cfelse>0</cfif></td>
					<td nowrap class="txtbold" style="text-align:right;">#TlFormat(toplam_vade_farki)#</td>	
					<td nowrap class="txtbold" style="text-align:right;">% <cfif toplam_satis gt 0>#TlFormat((toplam_vade_farki/toplam_satis)*100)#<cfelse>0</cfif></td>
					<td nowrap class="txtbold" style="text-align:right;">#TlFormat(toplam_satis_kari)#</td>	
					<td nowrap class="txtbold" style="text-align:right;">% <cfif toplam_satis gt 0>#TlFormat((toplam_satis_kari/toplam_satis)*100)#<cfelse>0</cfif></td>
					<cfif attributes.report_type neq 6 and attributes.report_type neq 8 and attributes.report_type neq 9>
						<cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
							<td width="1">&nbsp;</td>
						</cfif>
						<td nowrap class="txtbold" style="text-align:right;">#TlFormat(toplam_stok_miktari)#</td>	
						<td nowrap class="txtbold" style="text-align:right;">#TlFormat(toplam_stok_tutarı)#</td>	
						<td class="txtbold" style="text-align:right;">
							<cfif toplam_stok_tutarı gt 0>
								<cfset due_day3 = toplam_stok_vade / toplam_stok_tutarı>
							<cfelse>
								<cfset due_day3 = 0>
							</cfif>
							#dateformat(date_add('d',due_day3,now()),dateformat_style)#
						</td>	
						<td nowrap class="txtbold" style="text-align:right;">#TlFormat(toplam_stok_finans_gideri)#</td>	
					</cfif>
					<cfif attributes.report_type eq 1>
						<cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
							<td width="1">&nbsp;</td>
						</cfif>
						<td nowrap class="txtbold" style="text-align:right;">#TlFormat(toplam_alacak)#</td>	
						<td class="txtbold" style="text-align:right;">
							<cfif toplam_alacak gt 0>
								<cfset due_day2 = toplam_alacak_vade / toplam_alacak>
							<cfelse>
								<cfset due_day2 = 0>
							</cfif>
							#dateformat(date_add('d',due_day2,now()),dateformat_style)#
						</td>
						<td nowrap class="txtbold" style="text-align:right;">#TlFormat(toplam_vade_alacak)#</td>
						<td nowrap class="txtbold" style="text-align:right;">#TlFormat(toplam_vade_alacak_farkı)#</td>
					</cfif>
					<cfif attributes.report_type neq 6 and attributes.report_type neq 8 and attributes.report_type neq 9>
						<td nowrap class="txtbold" style="text-align:right;">#TlFormat(toplam_net_kar)#</td>
					</cfif>
				</tr>
			</cfoutput>
            </tbody>
		<cfelse>
            	<tbody>
                    <tr>
                        <td colspan="35" height="20"><cfif isdefined('form_submitted')><cf_get_lang_main no='72.Kayıt Yok'> !<cfelse><cf_get_lang_main no='289.Filtre Ediniz'> !</cfif></td>
                    </tr>
                </tbody>
		</cfif>

</cf_report_list>
</cfif>
		<cfset adres = "">
		<cfif isdefined("attributes.form_submitted") and attributes.totalrecords gt attributes.maxrows>
			<cfset adres = "report.sale_stock_analyse_orders&form_submitted=1">	
			<cfif len(attributes.date1)>
				<cfset adres = "#adres#&date1=#attributes.date1#">
			</cfif>
			<cfif len(attributes.date2)>
				<cfset adres = "#adres#&date2=#attributes.date2#">
			</cfif>
			<cfif len(attributes.report_sort)>
				<cfset adres = "#adres#&report_sort=#attributes.report_sort#">
			</cfif>
			<cfif isdefined("attributes.is_kdv")>
				<cfset adres = "#adres#&is_kdv=#attributes.is_kdv#">
			</cfif>
			<cfif isdefined("attributes.is_iptal")>
				<cfset adres = "#adres#&is_iptal=#attributes.is_iptal#">
			</cfif>
			<cfif len(attributes.report_type)>
				<cfset adres = "#adres#&report_type=#attributes.report_type#">
			</cfif>
			<cfif len(attributes.search_product_catid) and len(attributes.product_cat)>
				<cfset adres = "#adres#&search_product_catid=#attributes.search_product_catid#&product_cat=#attributes.product_cat#">
			</cfif>
			<cfif len(attributes.zone_id)>
				<cfset adres = "#adres#&zone_id=#attributes.zone_id#">
			</cfif>
			<cfif len(attributes.order_stage)>
				<cfset adres = "#adres#&order_stage=#attributes.order_stage#">
			</cfif>
			<cfif len(attributes.product_id) and len(attributes.product_name)>
				<cfset adres = "#adres#&product_id=#attributes.product_id#&product_name=#attributes.product_name#">
			</cfif>
			<cfif len(attributes.cancel_type_id)>
				<cfset adres = "#adres#&cancel_type_id=#attributes.cancel_type_id#">
			</cfif>
			<cfif len(attributes.brand_id) and len(attributes.brand_name)>
				<cfset adres = "#adres#&brand_id=#attributes.brand_id#&brand_name=#attributes.brand_name#">
			</cfif>
			<cfif len(attributes.card_paymethod_id)>
				<cfset adres = "#adres#&card_paymethod_id=#attributes.card_paymethod_id#">
			</cfif>
			<cfif len(attributes.cost_status)>
				<cfset adres = "#adres#&cost_status=#attributes.cost_status#">
			</cfif>
			<cfif len(attributes.status)>
				<cfset adres = "#adres#&status=#attributes.status#">
			</cfif>
			<cfif len(attributes.payment_type_id)>
				<cfset adres = "#adres#&payment_type_id=#attributes.payment_type_id#">
			</cfif>
			<cfif len(attributes.payment_type)>
				<cfset adres = "#adres#&payment_type=#attributes.payment_type#">
			</cfif>
			<cfif len(attributes.department_id)>
				<cfset adres = "#adres#&department_id=#attributes.department_id#">
			</cfif>
			<cfif len(attributes.datediff_value)>
				<cfset adres = "#adres#&datediff_value=#attributes.datediff_value#">
			</cfif>
			<cfif len(attributes.sup_company_id) and len(attributes.sup_company)>
				<cfset adres = "#adres#&sup_company_id=#attributes.sup_company_id#&sup_company=#attributes.sup_company#">
			</cfif>
			<cfif len(attributes.employee_id) and len(attributes.employee)>
				<cfset adres = "#adres#&employee_id=#attributes.employee_id#&employee=#attributes.employee#">
			</cfif>
			<cfif len(attributes.product_employee_id) and len(attributes.employee_name)>
				<cfset adres = "#adres#&product_employee_id=#attributes.product_employee_id#&employee_name=#attributes.employee_name#">
			</cfif>
			<cfif len(attributes.ship_method_id) and len(attributes.ship_method_name)>
				<cfset adres = "#adres#&ship_method_id=#attributes.ship_method_id#&ship_method_name=#attributes.ship_method_name#">
			</cfif>
			<cfif len(attributes.order_process_cat)>
				<cfset adres = "#adres#&order_process_cat=#attributes.order_process_cat#">
			</cfif>
			<cfif len(attributes.row_employee_id) and len(attributes.row_employee)>
				<cfset adres = "#adres#&row_employee_id=#attributes.row_employee_id#&row_employee=#attributes.row_employee#">
			</cfif> 
			<cf_paging
				page="#attributes.page#" 
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#adres#"></td>
		</cfif>
<script type="text/javascript">
	function kontrol()
	{
		if ((document.rapor.date1.value != '') && (document.rapor.date2.value != '') &&
	    !date_check(rapor.date1,rapor.date2,"<cf_get_lang no ='1093.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
	         return false;
		if(document.rapor.is_excel.checked==false)
		{
			document.rapor.action="<cfoutput>#request.self#?fuseaction=report.sale_stock_analyse_orders</cfoutput>";
			return true;
		}
		else
			document.rapor.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_sale_stock_analyse_orders</cfoutput>";
	}
</script>

