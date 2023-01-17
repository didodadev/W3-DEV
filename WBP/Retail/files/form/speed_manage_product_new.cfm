<cfajaximport tags="cfwindow">
	<script type="text/javascript" src="/wbp/retail/files/js/speed_manage_product_n3.js?version=<cfoutput>#CreateUUID()#</cfoutput>"></script>
	<cfset bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>
	
	<cfif isdefined("session.ep.userid")>
		<cfquery name="get_user_layout" datasource="#dsn_dev#">
			SELECT LAYOUT_ID FROM SEARCH_TABLES_LAYOUTS_USERS WHERE USER_ID = #session.ep.userid#
		</cfquery>
	<cfelse>
		<cfquery name="get_user_layout" datasource="#dsn_dev#">
			SELECT LAYOUT_ID FROM SEARCH_TABLES_DEFINES
		</cfquery>
	</cfif>
	<cfif get_user_layout.recordcount>
		<cfset layout_ = get_user_layout.LAYOUT_ID>
	<cfelse>
		<cfset layout_ = ''>
	</cfif>
	<cfquery name="get_order_date" datasource="#dsn_dev#">
		SELECT ORDER_DAY FROM SEARCH_TABLES_DEFINES
	</cfquery>
	<cfset order_control_day = -1 * get_order_date.ORDER_DAY>
	<cfset bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>
	<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
	<cfparam name="attributes.table_secret_code" default="#wrk_id#">
	<cfquery name="get_my_branches" datasource="#dsn#">
		SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#
	</cfquery>
	<cfif get_my_branches.recordcount>
		<cfset my_branch_list = valuelist(get_my_branches.BRANCH_ID)>
	<cfelse>
		<cfset my_branch_list = '0'>
	</cfif>
	<cf_xml_page_edit default_value="0" fuseact="product.list_product">
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.price_catid" default="#genel_fiyat_listesi#">
	<cfparam name="attributes.category_name" default="">
	<cfparam name="attributes.cat" default="">
	<cfparam name="attributes.brand_id" default="">
	<cfparam name="attributes.cat_id" default="">
	<cfparam name="attributes.hierarchy1" default="">
	<cfparam name="attributes.hierarchy2" default="">
	<cfparam name="attributes.hierarchy3" default="">
	<cfparam name="attributes.short_code_id" default="">
	<cfparam name="attributes.product_stages" default="">
	<cfparam name="attributes.list_variation_id" default="">
	<cfparam name="attributes.list_property_value" default="">
	<cfparam name="attributes.list_property_id" default="">
	<cfparam name="attributes.search_list_id" default="">
	<cfparam name="attributes.table_code" default="">
	<cfparam name="attributes.action_code" default="">
	<cfparam name="attributes.wrk_id" default="">
	<cfparam name="attributes.koli_type" default="2">
	<cfparam name="attributes.layout_id" default="#layout_#">
	<cfparam name="attributes.tedarikci_kodu" default="">
	<cfparam name="attributes.order_day" default="15">
	<cfparam name="attributes.order2_day" default="15">
	<cfparam name="attributes.bakiye_day" default="15">
	<cfparam name="attributes.calc_type" default="0">
	<cfparam name="attributes.add_stock_gun" default="-15">
	<cfparam name="attributes.is_main" default="0">
	<cfparam name="attributes.product_status" default="1">
	
	<cfparam name="attributes.order_code" default="">
	<cfparam name="attributes.order_id" default="">
	<cfparam name="attributes.order_company_code" default="">
	<cfparam name="attributes.order_date" default="">
	<cfparam name="attributes.order_company_order_list" default="">
	
	
	<cfif len(attributes.order_code) or len(attributes.order_id) or len(attributes.order_company_order_list)>
		<cfset attributes.is_from_order = 1>
	<cfelse>
		<cfset attributes.is_from_order = 0>
	</cfif>
	
	<cfif isdefined("session.ep.userid")>
		<cfset userid_ = session.ep.userid>
		<cfset usertype_ = 0>
	<cfelse>
		<cfset userid_ = session.pp.userid>
		<cfset usertype_ = 1>
	</cfif>
	
	<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#userid_#_'&round(rand()*100)>
	<cfparam name="attributes.table_secret_code" default="#wrk_id#">
	
	<cfif not isdefined("attributes.is_real_form_submitted")>
		<cfset attributes.is_hide_one_stocks = 1>
	</cfif>
	<cfparam name="attributes.is_form_submitted" default="1">
	
	
	<cfif isdefined("attributes.search_startdate") and isdate(attributes.search_startdate)>
		<cf_date tarih = "attributes.search_startdate">
	<cfelse>
		<cfset attributes.search_startdate = dateadd("d",-90,bugun_)>
	</cfif>
	<cfif isdefined("attributes.search_finishdate") and isdate(attributes.search_finishdate)>
		<cf_date tarih = "attributes.search_finishdate">
	<cfelse>
		<cfset attributes.search_finishdate = dateadd("d",-1,bugun_)>
	</cfif>
	
	<cfquery name="get_departments_search" datasource="#dsn#">
		SELECT 
			DEPARTMENT_ID,DEPARTMENT_HEAD 
		FROM 
			DEPARTMENT D
		WHERE
			D.IS_STORE IN (1,3) AND
			ISNULL(D.IS_PRODUCTION,0) = 0 AND
			BRANCH_ID IN (#my_branch_list#) AND
			D.DEPARTMENT_ID NOT IN (#iade_depo_id#)
		ORDER BY 
			DEPARTMENT_HEAD
	</cfquery>
	
	<cfif isdefined("attributes.table_code") and len(attributes.table_code)>
	<cfif len(attributes.table_code) lt 8>
		<cfloop from="1" to="#8 - len(attributes.table_code)#" index="ccm">
			<cfset attributes.table_code = "0#attributes.table_code#">
		</cfloop>
	</cfif>
	
		<cfquery name="get_table" datasource="#dsn_dev#" result="get_table_result">
			SELECT
				TABLE_SECRET_CODE,
				TABLE_INFO,
				TABLE_ID,
				IS_MAIN
			FROM
				SEARCH_TABLES
			WHERE
				TABLE_CODE = '#attributes.table_code#'
		</cfquery>
		
		<cfif get_table.recordcount>
			<cfset attributes.table_info = get_table.TABLE_INFO>
			<cfset attributes.table_id = get_table.TABLE_ID>
			<cfset attributes.table_secret_code = get_table.TABLE_SECRET_CODE>
			<cfset attributes.is_main = get_table.is_main>
			<cfquery name="get_table_info_sql" datasource="#dsn_dev#" result="get_table_row_result2">
				SELECT
					*
				FROM
					SEARCH_TABLES_ROWS_NEW
				WHERE
					TABLE_ID = #attributes.table_id#
			</cfquery>
			
			<cfoutput query="get_table_info_sql">
				<cfset 'get_table_info.#att_name#_#product_code#' = "#att_value#">
			</cfoutput>
			
			<cfquery name="get_table_depts" datasource="#dsn_dev#" result="get_table_result3">
				SELECT
					DEPARTMENT_ID
				FROM
					SEARCH_TABLES_DEPARTMENTS
				WHERE
					TABLE_ID = #attributes.table_id#
			</cfquery>
			<cfif get_table_depts.recordcount and not isdefined("attributes.search_department_id")>
				<cfset attributes.search_department_id = merkez_depo_id>
			</cfif>
		<cfelse>
			<cfset attributes.table_info = ''>
		</cfif>
	<cfelse>
		<cfset attributes.table_info = ''>
	</cfif>
	
	<cfif not isdefined("attributes.search_department_id")>
		<cfset attributes.search_department_id = merkez_depo_id>
	</cfif>
	
	<cfset attributes.is_from_order = 0>
	
	<cfif len(attributes.order_code)>
		<cfquery name="get_order_layout" datasource="#dsn_dev#">
			SELECT * FROM SEARCH_TABLES_DEFINES
		</cfquery>
	
		<cfif isdefined("url.order_code")>
			<cfset attributes.layout_id = get_order_layout.order_layout_id>
		</cfif>
		
		<cfquery name="get_dept" datasource="#dsn3#">
			SELECT DELIVER_DEPT_ID,ORDER_ID,ORDER_DATE FROM ORDERS WHERE ORDER_CODE = '#attributes.order_code#' ORDER BY ORDER_DATE ASC
		</cfquery>
		<cfif get_dept.recordcount>
			<cfset attributes.search_department_id = listdeleteduplicates(valuelist(get_dept.DELIVER_DEPT_ID))>
			<cfset attributes.calc_type = 1>
			
			<cfquery name="get_order_products" datasource="#dsn3#">
				SELECT 
					ORR.PRODUCT_ID,
					ORR.STOCK_ID,
					ORR.QUANTITY,
					ORR.ORDER_ROW_CURRENCY,
					O.ORDER_DATE,
					O.ORDER_ID,
					O.DELIVER_DEPT_ID,
					C.NICKNAME,
					   PP.PROJECT_HEAD AS PROJECT,
					CAST(ISNULL(O.COMPANY_ID,0) AS NVARCHAR) + '_' + CAST(ISNULL(O.PROJECT_ID,0) AS NVARCHAR) AS COMPANY_CODE
				FROM 
					ORDER_ROW ORR,
					ORDERS O
						LEFT JOIN #dsn_alias#.COMPANY C ON (C.COMPANY_ID = O.COMPANY_ID)
						LEFT JOIN #dsn_alias#.PRO_PROJECTS PP ON (PP.PROJECT_ID = O.PROJECT_ID)
				WHERE
					O.ORDER_ID = ORR.ORDER_ID AND 
					O.ORDER_ID IN (#listdeleteduplicates(valuelist(get_dept.ORDER_ID))#)
				ORDER BY
					O.ORDER_DATE,
					O.ORDER_ID,
					O.DELIVER_DEPT_ID,
					ORR.PRODUCT_ID,
					ORR.STOCK_ID
			</cfquery>
			<cfset attributes.order_stock_list = listdeleteduplicates(valuelist(get_order_products.stock_id))>
			
			<cfoutput query="get_order_products">
				<cfset date_ = dateformat(ORDER_DATE,'dd/mm/yyyy')>
				<cfset "attributes.order_company_#product_id#" = NICKNAME & '-' & PROJECT>
				<cfset "attributes.order_company_code_#product_id#" = COMPANY_CODE>
				<cfif not isdefined("attributes.order_order_date1_#product_id#")>
					<cfset "attributes.order_order_date1_#product_id#" = date_>
				<cfelseif isdefined("attributes.order_order_date1_#product_id#") and evaluate("attributes.order_order_date1_#product_id#") is not date_>
					<cfset "attributes.order_order_date2_#product_id#" = date_>
				</cfif>
			</cfoutput>
			
			<cfoutput query="get_order_products">
				<cfset date_ = dateformat(ORDER_DATE,'dd/mm/yyyy')>
				<cfif isdefined("attributes.order_order_date1_#product_id#") and evaluate("attributes.order_order_date1_#product_id#") is date_>
					<cfset 'attributes.order_siparis_miktari_1_#product_id#_#stock_id#_#DELIVER_DEPT_ID#' = QUANTITY>
					<cfset 'attributes.order_siparis_miktari_1_#product_id#_#DELIVER_DEPT_ID#' = QUANTITY>
					<cfif ORDER_ROW_CURRENCY eq -1>
						<cfset 'attributes.order_siparis_sevk_1_#product_id#_#stock_id#_#DELIVER_DEPT_ID#' = 0>
						<cfset 'attributes.order_siparis_sevk_1_#product_id#_#DELIVER_DEPT_ID#' = 0>
					<cfelse>
						<cfset 'attributes.order_siparis_sevk_1_#product_id#_#stock_id#_#DELIVER_DEPT_ID#' = 1>
						<cfset 'attributes.order_siparis_sevk_1_#product_id#_#DELIVER_DEPT_ID#' = 1>
					</cfif>
				</cfif>
				
				<cfif isdefined("attributes.order_order_date2_#product_id#") and evaluate("attributes.order_order_date2_#product_id#") is date_>
					<cfset 'attributes.order_siparis_miktari_2_#product_id#_#stock_id#_#DELIVER_DEPT_ID#' = QUANTITY>
					<cfset 'attributes.order_siparis_miktari_2_#product_id#_#DELIVER_DEPT_ID#' = QUANTITY>
					<cfif ORDER_ROW_CURRENCY eq -1>
						<cfset 'attributes.order_siparis_sevk_2_#product_id#_#stock_id#_#DELIVER_DEPT_ID#' = 0>
						<cfset 'attributes.order_siparis_sevk_2_#product_id#_#DELIVER_DEPT_ID#' = 0>
					<cfelse>
						<cfset 'attributes.order_siparis_sevk_2_#product_id#_#stock_id#_#DELIVER_DEPT_ID#' = 1>
						<cfset 'attributes.order_siparis_sevk_2_#product_id#_#DELIVER_DEPT_ID#' = 1>
					</cfif>
				</cfif>
			</cfoutput>
			<cfset attributes.is_from_order = 1>
		</cfif>
	</cfif>
	
	
	<cfif len(attributes.order_id)>
		<cfquery name="get_order_layout" datasource="#dsn_dev#">
			SELECT * FROM SEARCH_TABLES_DEFINES
		</cfquery>
		<cfif isdefined("url.order_id")>
			<cfset attributes.layout_id = get_order_layout.order_layout_id>
		</cfif>
		<cfquery name="get_dept" datasource="#dsn3#">
			SELECT 
				O.DELIVER_DEPT_ID,
				O.ORDER_ID,
				O.ORDER_DATE,
				C.NICKNAME,
				PP.PROJECT_HEAD AS PROJECT,
				CAST(ISNULL(O.COMPANY_ID,0) AS NVARCHAR) + '_' + CAST(ISNULL(O.PROJECT_ID,0) AS NVARCHAR) AS COMPANY_CODE
			FROM 
				ORDERS O
					LEFT JOIN #dsn_alias#.COMPANY C ON (C.COMPANY_ID = O.COMPANY_ID)
					LEFT JOIN #dsn_alias#.PRO_PROJECTS PP ON (PP.PROJECT_ID = O.PROJECT_ID)
			WHERE 
				O.ORDER_ID = #attributes.order_id# 
		   ORDER BY 
				   O.ORDER_DATE ASC
		</cfquery>
		<cfif get_dept.recordcount>
			<cfset attributes.search_department_id = get_dept.DELIVER_DEPT_ID>
			<cfset attributes.calc_type = 1>
			
			<cfquery name="get_order_products" datasource="#dsn3#">
				SELECT PRODUCT_ID,STOCK_ID,QUANTITY,ORDER_ROW_CURRENCY FROM ORDER_ROW WHERE ORDER_ID IN (#listdeleteduplicates(valuelist(get_dept.ORDER_ID))#)
			</cfquery>
			
			<cfset attributes.order_product_list = listdeleteduplicates(valuelist(get_order_products.PRODUCT_ID))>
			<cfset attributes.order_order_date1 = dateformat(get_dept.ORDER_DATE,'dd/mm/yyyy')>
			<cfoutput query="get_order_products">
				<cfset 'attributes.order_order_date1_#product_id#' = dateformat(get_dept.ORDER_DATE,'dd/mm/yyyy')>
				<cfset 'attributes.order_siparis_miktari_1_#product_id#_#stock_id#_#get_dept.DELIVER_DEPT_ID#' = QUANTITY>
				<cfset 'attributes.order_siparis_miktari_1_#product_id#_#get_dept.DELIVER_DEPT_ID#' = QUANTITY>
				
				<cfset "attributes.order_company_#product_id#" = get_dept.NICKNAME & '-' & get_dept.PROJECT>
				<cfset "attributes.order_company_code_#product_id#" = get_dept.COMPANY_CODE>
				
				<cfif ORDER_ROW_CURRENCY eq -1>
					<cfset 'attributes.order_siparis_sevk_1_#product_id#_#stock_id#_#get_dept.DELIVER_DEPT_ID#' = 0>
					<cfset 'attributes.order_siparis_sevk_1_#product_id#_#get_dept.DELIVER_DEPT_ID#' = 0>
				<cfelse>
					<cfset 'attributes.order_siparis_sevk_1_#product_id#_#stock_id#_#get_dept.DELIVER_DEPT_ID#' = 1>
					<cfset 'attributes.order_siparis_sevk_1_#product_id#_#get_dept.DELIVER_DEPT_ID#' = 1>
				</cfif>
			</cfoutput>
			<cfset attributes.is_from_order = 1>
		</cfif>
	</cfif>
	
	<cfif len(attributes.order_company_code) and len(attributes.order_date)>
		<cfquery name="get_order_layout" datasource="#dsn_dev#">
			SELECT * FROM SEARCH_TABLES_DEFINES
		</cfquery>
		<cfif isdefined("url.order_company_code")>
			<cfset attributes.layout_id = get_order_layout.order_layout_id>
		</cfif>
		
		<cfquery name="get_dept" datasource="#dsn3#">
			SELECT 
				DELIVER_DEPT_ID,ORDER_ID,ORDER_DATE 
			FROM 
				ORDERS 
			WHERE 
				COMPANY_ID = #listfirst(attributes.order_company_code,'_')# AND
				ISNULL(PROJECT_ID,0) =  #listlast(attributes.order_company_code,'_')# AND
				YEAR(ORDER_DATE) = #mid(attributes.order_date,5,4)# AND
				MONTH(ORDER_DATE) = #mid(attributes.order_date,3,2)# AND
				DAY(ORDER_DATE) = #mid(attributes.order_date,1,2)# 
				<cfif isdefined("session.ep.userid")>
				AND ORDER_STAGE = #order_stage_#
				<cfelse>
				AND ORDER_STAGE = #valid_order_stage_#
				</cfif>
			ORDER BY 
				ORDER_DATE ASC
		</cfquery>
		<cfif get_dept.recordcount>
			<cfset attributes.search_department_id = listdeleteduplicates(valuelist(get_dept.DELIVER_DEPT_ID))>
			<cfset attributes.calc_type = 1>
			
			<cfquery name="get_order_products" datasource="#dsn3#">
				SELECT 
					ORR.PRODUCT_ID,
					ORR.STOCK_ID,
					ORR.QUANTITY,
					ORR.ORDER_ROW_CURRENCY,
					O.ORDER_DATE,
					O.ORDER_ID,
					O.DELIVER_DEPT_ID,
					C.NICKNAME,
					   PP.PROJECT_HEAD AS PROJECT,
					CAST(ISNULL(O.COMPANY_ID,0) AS NVARCHAR) + '_' + CAST(ISNULL(O.PROJECT_ID,0) AS NVARCHAR) AS COMPANY_CODE
				FROM 
					ORDER_ROW ORR,
					ORDERS O
						LEFT JOIN #dsn_alias#.COMPANY C ON (C.COMPANY_ID = O.COMPANY_ID)
						LEFT JOIN #dsn_alias#.PRO_PROJECTS PP ON (PP.PROJECT_ID = O.PROJECT_ID)
				WHERE
					O.ORDER_ID = ORR.ORDER_ID AND 
					O.ORDER_ID IN (#listdeleteduplicates(valuelist(get_dept.ORDER_ID))#)
				ORDER BY
					O.ORDER_DATE,
					O.ORDER_ID,
					O.DELIVER_DEPT_ID,
					ORR.PRODUCT_ID,
					ORR.STOCK_ID
			</cfquery>
			<cfset attributes.order_stock_list = listdeleteduplicates(valuelist(get_order_products.stock_id))>
			<cfset attributes.order_company_order_list = listdeleteduplicates(valuelist(get_dept.ORDER_ID))>
			<cfoutput query="get_order_products">
				<cfset date_ = dateformat(ORDER_DATE,'dd/mm/yyyy')>
				<cfset "attributes.order_company_#product_id#" = NICKNAME & '-' & PROJECT>
				<cfset "attributes.order_company_code_#product_id#" = COMPANY_CODE>
				<cfif not isdefined("attributes.order_order_date1_#product_id#")>
					<cfset "attributes.order_order_date1_#product_id#" = date_>
				<cfelseif isdefined("attributes.order_order_date1_#product_id#") and evaluate("attributes.order_order_date1_#product_id#") is not date_>
					<cfset "attributes.order_order_date2_#product_id#" = date_>
				</cfif>
			</cfoutput>
			
			<cfoutput query="get_order_products">
				<cfset date_ = dateformat(ORDER_DATE,'dd/mm/yyyy')>
				<cfif isdefined("attributes.order_order_date1_#product_id#") and evaluate("attributes.order_order_date1_#product_id#") is date_>
					<cfset 'attributes.order_siparis_miktari_1_#product_id#_#stock_id#_#DELIVER_DEPT_ID#' = QUANTITY>
					<cfset 'attributes.order_siparis_miktari_1_#product_id#_#DELIVER_DEPT_ID#' = QUANTITY>
					<cfif ORDER_ROW_CURRENCY eq -1>
						<cfset 'attributes.order_siparis_sevk_1_#product_id#_#stock_id#_#DELIVER_DEPT_ID#' = 0>
						<cfset 'attributes.order_siparis_sevk_1_#product_id#_#DELIVER_DEPT_ID#' = 0>
					<cfelse>
						<cfset 'attributes.order_siparis_sevk_1_#product_id#_#stock_id#_#DELIVER_DEPT_ID#' = 1>
						<cfset 'attributes.order_siparis_sevk_1_#product_id#_#DELIVER_DEPT_ID#' = 1>
					</cfif>
				</cfif>
				
				<cfif isdefined("attributes.order_order_date2_#product_id#") and evaluate("attributes.order_order_date2_#product_id#") is date_>
					<cfset 'attributes.order_siparis_miktari_2_#product_id#_#stock_id#_#DELIVER_DEPT_ID#' = QUANTITY>
					<cfset 'attributes.order_siparis_miktari_2_#product_id#_#DELIVER_DEPT_ID#' = QUANTITY>
					<cfif ORDER_ROW_CURRENCY eq -1>
						<cfset 'attributes.order_siparis_sevk_2_#product_id#_#stock_id#_#DELIVER_DEPT_ID#' = 0>
						<cfset 'attributes.order_siparis_sevk_2_#product_id#_#DELIVER_DEPT_ID#' = 0>
					<cfelse>
						<cfset 'attributes.order_siparis_sevk_2_#product_id#_#stock_id#_#DELIVER_DEPT_ID#' = 1>
						<cfset 'attributes.order_siparis_sevk_2_#product_id#_#DELIVER_DEPT_ID#' = 1>
					</cfif>
				</cfif>
			</cfoutput>
			<cfset attributes.is_from_order = 1>
		</cfif>
	</cfif>
	
	
	<cfquery name="get_search_layouts" datasource="#dsn_dev#">
	SELECT
		LAYOUT_ID,
		LAYOUT_NAME
	FROM
		SEARCH_TABLES_LAYOUTS_NEW
	ORDER BY
		   LAYOUT_NAME
	</cfquery>
	
	<cfset get_product.recordcount=0>
	<cfset get_product.query_count=0>
	
	<cfparam name="attributes.totalrecords" default='#get_product.query_count#'>
	
	<cfquery name="get_price_types" datasource="#dsn_dev#">
		SELECT
			*
		FROM
			PRICE_TYPES
		ORDER BY
			IS_STANDART DESC,
			TYPE_ID ASC
	</cfquery>
	
	<script>
	<cfoutput query="get_price_types">j_price_type_#TYPE_ID# = '#TYPE_code#';</cfoutput>
	</script>
	<cfoutput query="get_price_types">
		<cfset 'j_price_type_#TYPE_ID#' = '#TYPE_code#'>
	</cfoutput>
	
	<cfquery name="get_headers_all" datasource="#dsn_dev#">
		SELECT  
			*,
			(ROW_ID - 1)  AS KOLON_SIRA,
			1 AS KOLON_SHOW
		FROM 
			SEARCH_TABLES_COLOUMS 
		ORDER BY 
			KOLON_SIRA ASC
	</cfquery>
	
	<cfif len(attributes.layout_id)>
		<cfquery name="get_layout_info" datasource="#dsn_dev#">
			SELECT * FROM SEARCH_TABLES_LAYOUTS_NEW WHERE LAYOUT_ID = #attributes.layout_id#
		</cfquery>
		<cfif get_layout_info.recordcount and len(get_layout_info.sort_list)>
				<cfset sort_list = get_layout_info.sort_list>
				
				<cfoutput query="get_headers_all">
					<cfset sira_ = row_id>
	
					<cfif sira_ lte listlen(sort_list)>
						<cfset ozellik_ = listgetat(sort_list,sira_)>
						
						<cfset row_sira_ = listgetat(ozellik_,2,'*')>
						<cfset row_show_ = listgetat(ozellik_,3,'*')>
						<cfset querysetcell(get_headers_all,'KOLON_SIRA',row_sira_,currentrow)>
						
						<cfif row_show_ is 'hide'>
							<cfset querysetcell(get_headers_all,'KOLON_SHOW','0',currentrow)>
						<cfelse>
							<cfset querysetcell(get_headers_all,'KOLON_SHOW','1',currentrow)>
						</cfif>
					</cfif>
				</cfoutput>
		</cfif>
	</cfif>
	
	<cfquery name="get_headers" dbtype="query">
		SELECT * FROM get_headers_all ORDER BY KOLON_SIRA ASC
	</cfquery>
	<cfquery name="get_headers_show" dbtype="query">
		SELECT * FROM get_headers_all WHERE KOLON_SHOW = 1 ORDER BY KOLON_SIRA ASC
	</cfquery>
	<cfif isdefined("attributes.is_form_submitted")>
	<div id="control_h"></div>
	
	<cf_catalystHeader>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cf_box>
			<cfform name="search_product" method="post" action="#request.self#?fuseaction=#url.fuseaction#">
				<input type="hidden" name="list_property_id" id="list_property_id" value="<cfif isdefined("attributes.list_property_id")><cfoutput>#attributes.list_property_id#</cfoutput></cfif>">
				<input type="hidden" name="list_variation_id" id="list_variation_id" value="<cfif isdefined("attributes.list_variation_id")><cfoutput>#attributes.list_variation_id#</cfoutput></cfif>">
				<input type="hidden" name="list_property_value" id="list_property_value" value="<cfif isdefined("attributes.list_property_value")><cfoutput>#attributes.list_property_value#</cfoutput></cfif>">
				<input type="hidden" name="page_hide_col_list" id="page_hide_col_list" value="">
				<input type="hidden" name="page_col_sort_list" id="page_col_sort_list" value="">
				
				<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
				<input name="is_real_form_submitted" id="is_real_form_submitted" type="hidden" value="1">
				<input type="hidden" name="order_id" id="order_id" value="<cfoutput>#attributes.order_id#</cfoutput>"/>
				<input type="hidden" name="order_code" id="order_code" value="<cfoutput>#attributes.order_code#</cfoutput>"/>
				<input type="hidden" name="order_company_code" id="order_company_code" value="<cfoutput>#attributes.order_company_code#</cfoutput>"/>
				<input type="hidden" name="order_date" id="order_date" value="<cfoutput>#attributes.order_date#</cfoutput>"/>
				<input type="hidden" name="order_company_order_list" id="order_company_order_list" value="<cfoutput>#attributes.order_company_order_list#</cfoutput>"/>
				<input name="search_selected_product_list" id="search_selected_product_list" type="hidden" value="">
				<cfparam name="attributes.mode" default="7">
				<cf_box_search>
					<div class="form-group">
						<cfinput type="text" name="table_code" id="table_code" style="width:90px;" value="#attributes.table_code#" maxlength="500" onfocus="AutoComplete_Create('table_code','TABLE_CODE,TABLE_SPE_INFO','TABLE_CODE,TABLE_SPE_INFO','add_options_get_tables','','TABLE_CODE','table_code','','3','150');" placeholder="#getLang('','Tablo No',61483)#">
					</div>
					<div class="form-group">
						<cfinput type="text" name="wrk_id" id="wrk_id" style="width:130px;" value="#attributes.wrk_id#" placeholder="#getLang('','Ana kod',62000)#">
					</div>
					<div class="form-group">
						<cfinput type="text" name="action_code" id="action_code" style="width:75px;" value="#attributes.action_code#" placeholder="#getLang('','İşlem Kodu',48886)#">
					</div>
					<div class="form-group">
						<cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang('','Filtre',57460)#">
					</div>
					<div class="form-group medium">
						<cf_multiselect_check 
						query_name="get_departments_search"  
						name="search_department_id"
						option_text="#getLang('','Departman',57572)#" 
						option_name="department_head" 
						option_value="department_id"
						value="#attributes.search_department_id#">
					</div>
					<div class="form-group">
						<select name="layout_id" id="layout_id" onChange="get_new_layout();">
							<option value=""><cf_get_lang dictionary_id='32796.Görünüm'></option>
							<cfoutput query="get_search_layouts">
								<option value="#layout_id#" <cfif attributes.layout_id eq layout_id>selected</cfif>>#layout_name#</option>
							</cfoutput>
						</select>
					</div>
					<div class="form-group">
						<input type="checkbox" name="is_hide_one_stocks" value="1" <cfif isdefined("attributes.is_hide_one_stocks")>checked</cfif>/> <cf_get_lang dictionary_id='62001.Tekli Stok Gösterme'>
					</div>
					<div class="form-group">
						<select name="calc_type" id="calc_type" onChange="get_calc_type();">
							<option value="0" <cfif attributes.calc_type eq 0>selected</cfif>><cf_get_lang dictionary_id='62002.Hesaplama Yapma'></option>
							<option value="1" <cfif attributes.calc_type eq 1>selected</cfif>><cf_get_lang dictionary_id='62003.Satış Hızına Göre'></option>
							<option value="2" <cfif attributes.calc_type eq 2>selected</cfif>><cf_get_lang dictionary_id='62004.Max Mine Göre'></option>
							<option value="3" <cfif attributes.calc_type eq 3>selected</cfif>><cf_get_lang dictionary_id='62005.Seçililerle Çalış'></option>
						</select>
					</div>
					<div class="form-group">
						<select name="product_status" id="product_status">
							<option value="0" <cfif attributes.product_status eq 0>selected</cfif>><cf_get_lang dictionary_id='62006.Pasif Ürünler'></option>
							<option value="1" <cfif attributes.product_status eq 1>selected</cfif>><cf_get_lang dictionary_id='62007.Aktif Ürünler'></option>
							<option value="2" <cfif attributes.product_status eq 2>selected</cfif>><cf_get_lang dictionary_id='30167.Tüm Ürünler'></option>
						</select>
					</div>
					<div class="form-group">
						<cf_wrk_search_button button_type="4" search_function='input_control()' is_excel="0">
					</div>
					<div class="form-group">
						<a class="ui-btn ui-btn-gray" onClick="$('#note_div').toggle();"><i class="catalyst-grid"></i></a>
					</div>
					<div class="form-group" id="note_div" style="display:none;"><textarea id="note" style="height:150px; width:200px;"></textarea></div>
				</cf_box_search>
				<cfif attributes.calc_type eq 1>
					<cf_box_search>
						<div class="form-group">
							<select name="koli_type" id="koli_type">
								<option value=""><cf_get_lang dictionary_id='62010.Koli Yuvarlama'></option>
								<option value="0" <cfif attributes.koli_type eq 0>selected</cfif>><cf_get_lang dictionary_id='55781.Aşağı'></option>
								<option value="1" <cfif attributes.koli_type eq 1>selected</cfif>><cf_get_lang dictionary_id='55780.Yukarı'></option>
								<option value="2" <cfif attributes.koli_type eq 2>selected</cfif>><cf_get_lang dictionary_id='58544.Sabit'></option>
							</select>
						</div>
						<div class="form-group">
							<div class="input-group">
								<cfinput type="text" name="search_startdate" maxlength="10" value="#dateformat(attributes.search_startdate,'dd/mm/yyyy')#" style="width:65px;" validate="eurodate" message="#getLang('','Tarih Hatalı',56704)#!">
								<span class="input-group-addon"><cf_wrk_date_image date_field="search_startdate"></span>
							</div>
						</div>
						<div class="form-group">
							<div class="input-group">
								<cfinput type="text" name="search_finishdate" maxlength="10" value="#dateformat(attributes.search_finishdate,'dd/mm/yyyy')#" style="width:65px;" validate="eurodate" message="#getLang('','Tarih Hatalı',56704)#!">
								<span class="input-group-addon"><cf_wrk_date_image date_field="search_finishdate"></span>
							</div>
						</div>
						<div class="form-group">
							<label><cf_get_lang dictionary_id='62011.Sipariş Günü'></label>
							<div class="input-group small">
								<cfinput type="text" name="order_day" id="order_day" style="width:30px;" value="#attributes.order_day#" maxlength="3">
							</div>
						</div>
						<div class="form-group">
							<label>2.<cf_get_lang dictionary_id='62011.Sipariş Günü'></label>
							<div class="input-group small">
								<cfinput type="text" name="order2_day" id="order2_day" style="width:30px;" value="#attributes.order2_day#" maxlength="3">
							</div>
						</div>
						<div class="form-group">
							<label><cf_get_lang dictionary_id='62012.Bakiye Sipariş Hesabı'></label>
							<div class="input-group small">	
								<cfinput type="text" name="bakiye_day" id="bakiye_day" style="width:30px;" value="#attributes.bakiye_day#" maxlength="3">
							</div>
						</div>
						<div class="form-group">
							<cfif not isdefined("attributes.is_real_form_submitted")>
								<input type="checkbox" value="1" name="real_stock" id="real_stock" checked/> <cf_get_lang dictionary_id='61654.Eldeki Stoğu Hesaba Kat'>
								<input type="checkbox" value="1" name="way_stock" id="way_stock" checked/> <cf_get_lang dictionary_id='61655.Yoldaki Stoğu Hesaba Kat'>
							<cfelse> 
								<input type="checkbox" value="1" name="real_stock" id="real_stock" <cfif isdefined("attributes.real_stock")>checked</cfif>/> <cf_get_lang dictionary_id='61654.Eldeki Stoğu Hesaba Kat'>
								<input type="checkbox" value="1" name="way_stock" id="way_stock" <cfif isdefined("attributes.way_stock")>checked</cfif>/> <cf_get_lang dictionary_id='61655.Yoldaki Stoğu Hesaba Kat'>
							</cfif>
						</div>
					</cf_box_search>
				</cfif>
			</cfform>
		</cf_box>
		<cf_box>
			<cfform name="info_form" method="post" action="">
				<cfinput type="hidden" name="department_id_list" id="department_id_list" value="#attributes.search_department_id#"/>
				<input type="hidden" name="order_id" id="order_id" value="<cfoutput>#attributes.order_id#</cfoutput>"/>
				<input type="hidden" name="order_code" id="order_code" value="<cfoutput>#attributes.order_code#</cfoutput>"/>
				<input type="hidden" name="order_company_code" id="order_company_code" value="<cfoutput>#attributes.order_company_code#</cfoutput>"/>
				<input type="hidden" name="order_company_order_list" id="order_company_order_list" value="<cfoutput>#attributes.order_company_order_list#</cfoutput>"/>
				<input type="hidden" name="order_date" id="order_date" value="<cfoutput>#attributes.order_date#</cfoutput>"/>
				<input type="hidden" name="ilk_kez_fiyat_at" id="ilk_kez_fiyat_at" value="1"/>
				<cfinput type="hidden" name="table_secret_code" id="table_secret_code" value="#attributes.table_secret_code#" readonly="yes"/>
				<input type="hidden" style="width:700px;" name="layout_sort_list" id="layout_sort_list" value="<cfoutput>#valuelist(get_headers_show.kolon_ad)#</cfoutput>">
				
				<cfquery name="get_table_no" datasource="#dsn_dev#">
					SELECT TABLE_CODE FROM SEARCH_TABLE_NO
				</cfquery>
				<cfset new_number = get_table_no.TABLE_CODE + 1>
				<cfquery name="upd_table_no" datasource="#dsn_dev#">
					UPDATE SEARCH_TABLE_NO SET TABLE_CODE = #new_number#
				</cfquery>
				
				<cfset attributes.screen_wrk_id = new_number>
				<cfloop from="1" to="#8-len(new_number)#" index="ccc">
					<cfset attributes.screen_wrk_id = "0" & attributes.screen_wrk_id>
				</cfloop>
				<cfinput type="hidden" name="screen_wrk_id" id="screen_wrk_id" value="#attributes.screen_wrk_id#" readonly="yes"/>
				
				<cfif isdefined("attributes.table_id")>
					<cfinput type="hidden" name="table_id" id="table_id" value="#attributes.table_id#"/>
				<cfelse>
					<cfinput type="hidden" name="table_id" id="table_id" value=""/>
				</cfif>
				
				<cfquery name="get_departments" datasource="#dsn#">
				SELECT 
					DEPARTMENT_ID,DEPARTMENT_HEAD 
				FROM 
					DEPARTMENT D
				WHERE
					D.IS_STORE IN (1,3) AND
					ISNULL(D.IS_PRODUCTION,0) = 0 AND
					BRANCH_ID IN (#my_branch_list#)
					<cfif len(attributes.search_department_id)>
						AND D.DEPARTMENT_ID IN (#attributes.search_department_id#)
					</cfif>
				ORDER BY 
					DEPARTMENT_HEAD
				</cfquery>
				<cfset dept_count_ = listlen(listdeleteduplicates(valuelist(get_departments.department_id)))>
				
				<cfinclude template="../query/get_products.cfm">
				
				<cfinclude template="../form/speed_manage_product_table_rows3.cfm">
				
				<cfif isdefined("product_id_list")>
					<cfinput type="hidden" name="all_product_list" id="all_product_list" value="#product_id_list#"/>
				<cfelse>
					<cfinput type="hidden" name="all_product_list" id="all_product_list" value=""/>
				</cfif>
				
				<cfif isdefined("product_id_list")>
					<cfinput type="hidden" id="close_product_list" name="close_product_list" value="#product_id_list#">
				<cfelse>
					<cfinput type="hidden" id="close_product_list" name="close_product_list" value="">
				</cfif>
				
				<cfif isdefined("get_table_info.is_purchase_type")>
					<cfset is_purchase_type = get_table_info.is_purchase_type>
				<cfelse>
					<cfset is_purchase_type = 0>
				</cfif>
				<cfinput type="hidden" name="is_purchase_type" id="is_purchase_type" value="#is_purchase_type#" readonly="yes" style="width:60px;"/>
					
					<cfquery name="get_stocks_only" dbtype="query">
						SELECT DISTINCT STOCK_ID FROM get_products ORDER BY PRODUCT_NAME
					</cfquery>
				
					<html ng-app="demoApp">
					<head>
						<link rel="stylesheet" type="text/css" href="/wbp/retail/files/js/jqwidgets/jqwidgets/styles/jqx.base.css" />
						<link rel="stylesheet" type="text/css" href="/wbp/retail/files/js/jqwidgets/jqwidgets/styles/jqx.energyblue.css" />
						<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxcore.js"></script>
						<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxdata.js"></script>
						<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxbuttons.js"></script>
						<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxscrollbar.js"></script>
						<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxmenu.js"></script>
						<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.js"></script>
						<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.edit.js?version=<cfoutput>#CreateUUID()#</cfoutput>"></script>
						
						<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.selection.js"></script>
						<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.columnsresize.js"></script>
						<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.columnsreorder.js"></script>
						<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.filter.js"></script>
				
						<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxnumberinput_new.js?version=<cfoutput>#CreateUUID()#</cfoutput>"></script>
						<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxinput.js"></script>
				
						<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxlistbox.js"></script>
						<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxcheckbox.js"></script>
						<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxtooltip.js"></script>
						<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxdropdownlist.js"></script>
						
						
						<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.grouping.js"></script>
						<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.aggregates.js?version=<cfoutput>#CreateUUID()#</cfoutput>"></script>
						<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/scripts/demos.js"></script>
						<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/demos/jqxgrid/localization.js?version=<cfoutput>#CreateUUID()#</cfoutput>"></script>
						   
						<cfquery name="get_defines" datasource="#dsn_dev#">
							SELECT * FROM SEARCH_TABLES_DEFINES
						</cfquery>
					   
						<cfoutput>
							<style>
								.jqx-grid-cell-selected-energyblue{ background-color:###get_defines.focus_color# !important;  color:##2b465e !important;}/*cfdde9*/
								.jqx-grid-cell-hover-energyblue{ background-color:###get_defines.hover_color# !important;} /*cfdde9*/
								.jqx-grid-group-collapse,.jqx-grid-group-expand{background-color:###get_defines.group_color# !important;}
								.selectedclassRow{background-color:###get_defines.row_focus_color# !important;}
								.hoverclassRow{background-color:##C0C !important;}
							</style>
						</cfoutput>
						
						<cfif get_products.recordcount>
							<cfset g_list = listdeleteduplicates(valuelist(get_products.hierarchy))>
							<cfset g_count = listlen(g_list)>
						<cfelse>
							<cfset g_list = "">
							<cfset g_count = 0>
						</cfif>
						
						<cfloop from="1" to="#g_count#" index="aa">
						<cfoutput>
							<div id="group_ic_#aa#" style="display:none;"></div>
						</cfoutput>
						</cfloop>
						
						<script type="text/javascript">
						<cfif isdefined("session.ep.username")>
							username_ = '<cfoutput>#session.ep.username#</cfoutput>';
							usertype_ = '<cfoutput>#usertype_#</cfoutput>';
						<cfelse>
							username_ = '<cfoutput>#session.pp.username#</cfoutput>';
							usertype_ = '<cfoutput>#usertype_#</cfoutput>';
						</cfif>
						
						<cfoutput>
							g_list = "#g_list#"; 
							g_count = parseInt(#g_count#); 
						</cfoutput>
						
						f_print = 1;
						
						function grup_getir()
						{
							for (var ccm=1; ccm <= g_count; ccm++)
							{
								div_ = 'group_ic_' + ccm;
								value_ = document.getElementById(div_).innerHTML;
								hierarchy_ = list_getat(g_list,ccm);
								
								adres_ = 'index.cfm?fuseaction=retail.emptypopup_seller_limit_table';
								adres_ += '&search_startdate=<cfoutput>#dateformat(attributes.search_startdate,"dd/mm/yyyy")#</cfoutput>';
								adres_ += '&search_finishdate=<cfoutput>#dateformat(attributes.search_finishdate,"dd/mm/yyyy")#</cfoutput>';
								adres_ += '&hierarchy=' + hierarchy_;
								adres_ += '&group_no=' + ccm;
								AjaxPageLoad(adres_,div_);
							}
						}
						grup_getir();
						
						departman_sayisi = '<cfoutput>#listlen(attributes.search_department_id)#</cfoutput>';
						departman_listesi = '<cfoutput>#attributes.search_department_id#</cfoutput>';
						
						tus_islem = 0;
						f1_pop = 0;
						f2_pop = 0;
						f3_pop = 0;
						f4_pop = 0;
						f5_pop = 0;
						f6_pop = 0;
						f7_pop = 0;
						f8_pop = 0;
						f9_pop = 0;
						f10_pop = 0;
						p_pop = 0;
						
						
							function set_new_price(row_id,c_type_,message_)
							{
								today_ = '<cfoutput>#dateformat(now(),"dd/mm/yyyy")#</cfoutput>';
								gun_ = parseInt(list_getat(today_,1,'/'));
								ay_ = parseInt(list_getat(today_,2,'/'));
								yil_ = parseInt(list_getat(today_,3,'/'));
								bugun_deger_ = gun_ + (ay_ * 30) + (yil_ * 365);
								
								var np_rows = $("#jqxgrid").jqxGrid('getboundrows');
								
								urun_adi_ = np_rows[row_id].product_name;
								product_id_ = np_rows[row_id].product_id;
								active_ = np_rows[row_id].active_row;
									
								alis_bas_ = np_rows[row_id].p_startdate;
								alis_bit_ = np_rows[row_id].p_finishdate;
								
								satis_bas_ = np_rows[row_id].startdate;
								satis_bit_ = np_rows[row_id].finishdate;
								
								
								if(alis_bas_ == 'null' || alis_bas_ == null)
									alis_bas_ = '';
									
								if(alis_bit_ == 'null' || alis_bit_ == null)
									alis_bit_ = '';
									
								if(satis_bas_ == 'null' || satis_bas_ == null)
									satis_bas_ = '';
									
								if(satis_bit_ == 'null' || satis_bit_ == null)
									satis_bit_ = '';
								
								if((product_id_ != '' && (active_ == true || active_ == 'true')) && (alis_bas_ == '' || satis_bas_ == ''))
								{
									alert('Seçili Ürünler İçin Alış ve Satış Tarihlerini Girmelisiniz!\nÜrün: ' + urun_adi_);	
									return false;
								}
								
								if((alis_bas_ != '' && alis_bit_ == '') || (alis_bas_ == '' && alis_bit_ != ''))
								{
									alert('Alış Tarihlerini Tam Girmelisiniz!\nÜrün: ' + urun_adi_);
									return false;	
								}
								
								if((satis_bas_ != '' && satis_bit_ == '') || (satis_bas_ == '' && satis_bit_ != ''))
								{
									alert('Satış Tarihlerini Tam Girmelisiniz!\nÜrün: ' + urun_adi_);
									return false;	
								}
								
								
								if(alis_bas_ != '' && alis_bas_ == alis_bit_)
								{
									alert('Alış Tarihleri Aynı Olamaz!\nÜrün: ' + urun_adi_);
									return false;
								}
								
								if(satis_bas_ != '' && satis_bas_ == satis_bit_)
								{
									alert('Satış Tarihleri Aynı Olamaz!\nÜrün: ' + urun_adi_);
									return false;	
								}
								
								if(satis_bas_ != '')
								{
									gun_ = parseInt(list_getat(satis_bas_,1,'/'));
									ay_ = parseInt(list_getat(satis_bas_,2,'/'));
									yil_ = parseInt(list_getat(satis_bas_,3,'/'));
									satis_bas_deger_ = gun_ + (ay_ * 30) + (yil_ * 365);
								}
								
								if(satis_bit_ != '')
								{
									gun_ = parseInt(list_getat(satis_bit_,1,'/'));
									ay_ = parseInt(list_getat(satis_bit_,2,'/'));
									yil_ = parseInt(list_getat(satis_bit_,3,'/'));
									satis_bit_deger_ = gun_ + (ay_ * 30) + (yil_ * 365);
								}
								
								if(alis_bas_ != '')
								{
									gun_ = parseInt(list_getat(alis_bas_,1,'/'));
									ay_ = parseInt(list_getat(alis_bas_,2,'/'));
									yil_ = parseInt(list_getat(alis_bas_,3,'/'));
									alis_bas_deger_ = gun_ + (ay_ * 30) + (yil_ * 365);
								}
								
								if(alis_bit_ != '')
								{
									gun_ = parseInt(list_getat(alis_bit_,1,'/'));
									ay_ = parseInt(list_getat(alis_bit_,2,'/'));
									yil_ = parseInt(list_getat(alis_bit_,3,'/'));
									alis_bit_deger_ = gun_ + (ay_ * 30) + (yil_ * 365);
								}
								
									
								if(c_type_ == '0') // fiyatlarin tamami yeniden yazilacak ise
								{
									if(satis_bas_ != '' && satis_bas_deger_ < bugun_deger_)
									{
										alert('Satış Başlangıç Bugünden Önce Olamaz!\nÜrün: ' + urun_adi_);
										return false;	
									}
									
									if(satis_bit_ != '' && satis_bit_deger_ < bugun_deger_)
									{
										alert('Satış Bitiş Bugünden Önce Olamaz!\nÜrün: ' + urun_adi_);
										return false;	
									}
									
									if(alis_bit_ != '' && alis_bit_deger_ < bugun_deger_)
									{
										alert('Alış Bitiş Bugünden Önce Olamaz!\nÜrün: ' + urun_adi_);
										return false;	
									}
								}
								else if(c_type_ == '1')
								{
									if(np_rows[row_id].product_price_change_lastrowid == '0')
									{
										if(satis_bas_ != '' && satis_bas_deger_ < bugun_deger_)
										{
											alert('Satış Başlangıç Bugünden Önce Olamaz!\nÜrün: ' + urun_adi_);
											return false;	
										}
										
										if(satis_bit_ != '' && satis_bit_deger_ < bugun_deger_)
										{
											alert('Satış Bitiş Bugünden Önce Olamaz!\nÜrün: ' + urun_adi_);
											return false;	
										}
										
										if(alis_bit_ != '' && alis_bit_deger_ < bugun_deger_)
										{
											alert('Alış Bitiş Bugünden Önce Olamaz!\nÜrün: ' + urun_adi_);
											return false;	
										}
									}	
								}
								
								if(alis_bas_ != '' && alis_bit_ != '' && alis_bas_deger_ > alis_bit_deger_)
								{
									alert('Alış Bitiş Alış Başlangıçtan Önce Olamaz!\nÜrün: ' + urun_adi_);
									return false;
								}
								
								if(satis_bas_ != '' && satis_bit_ != '' && satis_bas_deger_ > satis_bit_deger_)
								{
									alert('Satış Bitiş Satış Başlangıçtan Önce Olamaz!\nÜrün: ' + urun_adi_);
									return false;
								}
								
								
								if(np_rows[row_id].price_type_id == '')
								{
									alert('Fiyat Tipi Seçiniz!\nÜrün: ' + urun_adi_);
									return false;	
								}
								
								
								deger_ = '0';
								
								alis_bas_ = np_rows[row_id].p_startdate;
								alis_bit_ = np_rows[row_id].p_finishdate;
								
								satis_bas_ = np_rows[row_id].startdate;
								satis_bit_ = np_rows[row_id].finishdate;
								
								
								deger_ += ';' + np_rows[row_id].price_type_id;
								deger_ += ';' + np_rows[row_id].new_alis_start;
								deger_ += ';' + np_rows[row_id].sales_discount;
								
								deger_ += ';' + np_rows[row_id].p_discount_manuel;
								deger_ += ';' + np_rows[row_id].new_alis;
								deger_ += ';' + np_rows[row_id].new_alis_kdvli;
								
								deger_ += ';' + np_rows[row_id].p_startdate;
								deger_ += ';' + np_rows[row_id].p_finishdate;
								
								deger_ += ';' + np_rows[row_id].alis_kar;
				
								
								if(np_rows[row_id].is_active_p == true)
									deger_ += ';' + '1';
								else
									deger_ += ';' + '0';
									
								deger_ += ';' + np_rows[row_id].first_satis_price;
								deger_ += ';' + np_rows[row_id].first_satis_price_kdv;
								deger_ += ';' + np_rows[row_id].standart_satis_oran;
								deger_ += ';' + np_rows[row_id].p_ss_marj;
								
								deger_ += ';' + np_rows[row_id].startdate;
								deger_ += ';' + np_rows[row_id].finishdate;
								
								if(np_rows[row_id].is_active_s == true)
									deger_ += ';' + '1';
								else
									deger_ += ';' + '0';
									
								deger_ += ';' + np_rows[row_id].dueday;
								
								deger_ += ';' + np_rows[row_id].price_departments;
								
								if(np_rows[row_id].p_product_type == true)
									deger_ += ';' + '1';
								else
									deger_ += ';' + '0';
									
								deger_ += ';' + np_rows[row_id].product_price_change_lastrowid;
								
								np_rows[row_id].product_price_change_lastrowid = 0;// satiri yazar yazmaz bu degeri 0 yapiyoruz ve baska satirlarla karismasini engelliyoruz
								
								sayi_ = parseInt(np_rows[row_id].product_price_change_count);
								yeni_sayi_ = sayi_ + 1;
								
								if(yeni_sayi_ == 1)
								{
									np_rows[row_id].product_price_change_count = yeni_sayi_;
									np_rows[row_id].product_price_change_detail = deger_;
								}
								else
								{
									parcala_ = np_rows[row_id].product_price_change_detail;
									yaz_ = 1;
									for (var m=1; m <= sayi_; m++)
									{
										sira_eleman_ = list_getat(parcala_,m,'*');
										if(sira_eleman_ == deger_)
										{
											yaz_ = 0;	
										}
									}
									
									if(yaz_ == 1)
									{
										yazilacak_ = parcala_ + '*' + deger_;
										np_rows[row_id].product_price_change_count = yeni_sayi_;
										np_rows[row_id].product_price_change_detail = yazilacak_;
									}
									else
									{
										//alert('Kayıt Tekrarı!');
									}
								}
								if(message_ == 1)
								{
									alert('Sepete Eklendi!');	
								}
								return true;
							}
				
						   
						   function save_table_func(type)
						   {
								if(document.getElementById('all_product_list').value == '')
								{
									alert('Ürün Seçiniz!');
									return false;	
								}
				
								var rows = $('#jqxgrid').jqxGrid('getboundrows');
								eleman_sayisi = rows.length;
								
								
								selected_ = '';
								for (var ccm=0; ccm < eleman_sayisi; ccm++)
								{
									product_id_ = rows[ccm].product_id;
									active_ = rows[ccm].active_row;
									
									if(product_id_ != '' && (active_ == true || active_ == 'true'))
									{
									
										if(selected_ == '')
											selected_ = product_id_;
										else
											selected_ += ',' + product_id_;
									}
								}
								if(selected_ == '')
								{
									alert('Hiçbir Satır Seçmediniz!');	
									return false;
								}
								
								var rows = $('#jqxgrid').jqxGrid('getboundrows');
								eleman_sayisi = rows.length;
								for (var ccm=0; ccm < eleman_sayisi; ccm++)
								{
									product_id_ = rows[ccm].product_id;
									active_ = rows[ccm].active_row;
									row_type = rows[ccm].row_type;
									sira_no_ = rows[ccm].sira_no;
									
									if(row_type == '1' &&  active_ == true)
									{
										product_name_ = rows[ccm].product_name;
										finishdate_ = rows[ccm].finishdate;
										p_finishdate_ = rows[ccm].p_finishdate;
										price_type_id_ = rows[ccm].price_type_id;
										
										if(finishdate_ == null || finishdate_ == 'null')
											finishdate_ = '';
											
										if(p_finishdate_ == null || p_finishdate_ == 'null')
											p_finishdate_ = '';	
										
										old_fiyat_ = wrk_round(rows[ccm].c_first_satis_price,2);
										new_fiyat_ = wrk_round(rows[ccm].first_satis_price,2);
										
										old_fiyat_a = wrk_round(rows[ccm].c_new_alis_kdvli,2);
										new_fiyat_a = wrk_round(rows[ccm].new_alis_kdvli,2);
										
										if((old_fiyat_ != new_fiyat_) || old_fiyat_a != new_fiyat_a)
										{
											if(finishdate_ == '' || p_finishdate_ == '')
											{
												alert('Fiyat Girilen Satırlar İçin Satış ve Alış Tarihlerini Tam Girmelisiniz!\n\nÜrün:' + product_name_ + '\n\nEski Satış Fiyat: ' + commaSplit(old_fiyat_,2) + '\nYeni Satış Fiyat: ' + commaSplit(new_fiyat_,2) + '\n\nEski Alış Fiyat: ' + commaSplit(old_fiyat_a,2) + '\nYeni Alış Fiyat: ' + commaSplit(new_fiyat_a,2));
												return false;	
											}
										}
										
										
										if((finishdate_ != '' || p_finishdate_ != '') && price_type_id_ == '')
										{
											alert((ccm+1) + '. Satır İçin Fiyat Tipi Seçmelisiniz!\nÜrün:' + product_name_);
											return false;	
										}
										
										if(price_type_id_ != '' && (p_finishdate_ != '' ||  finishdate_ != ''))
										{
											if(type == '3' || type == '0')
											{
												rows[ccm].is_active_p = true;
												rows[ccm].is_active_s = true;
											}
											
											
											if(type == '0' || type == '2')
												if(!set_new_price(ccm,0,0)) return false;
											else
												if(!set_new_price(ccm,1,0)) return false;
										}
									}
								}
								
								today_ = '<cfoutput>#dateformat(now(),"dd/mm/yyyy")#</cfoutput>';
								gun_ = parseInt(list_getat(today_,1,'/'));
								ay_ = parseInt(list_getat(today_,2,'/'));
								yil_ = parseInt(list_getat(today_,3,'/'));
								bugun_deger_ = gun_ + (ay_ * 30) + (yil_ * 365);
								
								var rows = $('#jqxgrid').jqxGrid('getboundrows');
								eleman_sayisi = rows.length;
				
								for (var ccm=0; ccm < eleman_sayisi; ccm++)
								{
									product_id_ = rows[ccm].product_id;
									active_ = rows[ccm].active_row;
									row_type = rows[ccm].row_type;
									
									if(row_type == '1' &&  active_ == true)
									{
										product_name_ = rows[ccm].product_name;
										alis_bas1_ = rows[ccm].standart_alis_baslangic;
										satis_bas1_ = rows[ccm].standart_satis_baslangic;
										
										if(alis_bas1_ == 'null' || alis_bas1_ == null)
											alis_bas1_ = '';
									
										if(satis_bas1_ == 'null' || satis_bas1_ == null)
											satis_bas1_ = '';
										
										alis_bas_ = alis_bas1_.replace(".","/");
										satis_bas_ = satis_bas1_.replace(".","/");
										
										
										if(satis_bas_ != '')
										{
											gun_ = parseInt(list_getat(satis_bas_,1,'/'));
											ay_ = parseInt(list_getat(satis_bas_,2,'/'));
											yil_ = parseInt(list_getat(satis_bas_,3,'/'));
											satis_bas_deger_ = gun_ + (ay_ * 30) + (yil_ * 365);
										}
										
										if(alis_bas_ != '')
										{
											gun_ = parseInt(list_getat(alis_bas_,1,'/'));
											ay_ = parseInt(list_getat(alis_bas_,2,'/'));
											yil_ = parseInt(list_getat(alis_bas_,3,'/'));
											alis_bas_deger_ = gun_ + (ay_ * 30) + (yil_ * 365);
										}
										
										deger_al_ = wrk_round(rows[ccm].standart_alis_kdvli,2);
										deger_al_c_ = wrk_round(rows[ccm].c_standart_alis_kdvli,2);
										
										deger_sat_ = wrk_round(rows[ccm].standart_satis_kdv,2);
										deger_sat_c_ = wrk_round(rows[ccm].c_standart_satis_kdv,2);
										
										
										if(rows[ccm].is_standart_satis_aktif == true)
											deger_al_check_ = 1;
										else
											deger_al_check_ = 0;
																	
										if(rows[ccm].c_is_standart_satis_aktif == true)
											deger_al_check_c_ = 1;
										else
											deger_al_check_c_ = 0;
										
										if(deger_al_ != deger_al_c_) // degisiklik var
										{
											if(alis_bas_ == '')
											{
												alert('Standart Alış Fiyatında Değişiklik Yaptınız! \nStandart Alış Tarihi Girmelisiniz!\n\nÜrün:' + product_name_ + '\n\nEski Fiyat: ' + commaSplit(deger_al_c_,2) + '\n\nYeni Fiyat: ' + commaSplit(deger_al_,2));
												return false;	
											}
								
											
											if(alis_bas_ != '' && alis_bas_deger_ < bugun_deger_)
											{
												alert('Standart Alış Başlangıç Bugünden Önce Olamaz!\nÜrün:' + product_name_);
												return false;	
											}
										}
										
										
										if(deger_al_check_ == 0 && satis_bas_ == '')
										{
											//nothing	
										}
										else
										{
											if(deger_al_check_ != deger_al_check_c_ || deger_sat_ != deger_sat_c_) // degisiklik var
											{
												if(satis_bas_ == '')
												{
													alert('Standart Satış Fiyatını Aktifleştirdiniz veya Standart Satışı Fiyatı Yaptınız! \nStandart Satış Tarihi Girmelisiniz!\n\nÜrün:' + product_name_+ '\n\nEski Fiyat: ' + commaSplit(deger_sat_c_,2) + '\n\nYeni Fiyat: ' + commaSplit(deger_sat_,2));
													return false;	
												}
												
												if(satis_bas_deger_ < bugun_deger_)
												{
													alert('Standart Satış Başlangıç Bugünden Önce Olamaz!\n\nÜrün:' + product_name_);
													return false;	
												}
											}
										}
										if(type == '0' || type == '1')
										{
											//$('#jqxgrid').jqxGrid('setcellvalue',ccm,'is_standart_satis_aktif',true);
										}
									}
								}
				
								
								popup_name_ = '<cfoutput>tablo_kaydet_#CreateUUID()#</cfoutput>';
								
								/*
								var rows = $('#jqxgrid').jqxGrid('getboundrows');
								eleman_sayisi = rows.length;
								*/
								
								if(document.getElementById('is_main').checked == true)
									is_main_ = 1;
								else
									is_main_ = 0;
								
								table_code_ = document.getElementById('inner_table_code').value;
								if(table_code_.length != 8)
									table_code_ = '';
								
								table_info_ = document.getElementById('inner_table_info').value;
								table_secret_code_ = document.getElementById('table_secret_code').value;
								screen_wrk_id_ = document.getElementById('screen_wrk_id').value;
								table_id_ = document.getElementById('table_id').value;
								all_product_list_ = document.getElementById('all_product_list').value;
								
									var rows = $('#jqxgrid').jqxGrid('getboundrows');
									document.getElementById('print_note').value = JSON.stringify(rows);
									windowopen('','medium','save_window_scr');
									adress_ = 'index.cfm?fuseaction=retail.popupflush_add_speed_manage_product_new';
									
									<cfif isdefined("attributes.is_from_price_change")>
										document.print_form.is_from_price_change.value = '1';
									<cfelse>
										document.print_form.is_from_price_change.value = '0';
									</cfif>
									
									document.print_form.table_code.value = table_code_;
									document.print_form.table_secret_code.value = table_secret_code_;
									document.print_form.is_main.value = is_main_;
									document.print_form.table_id.value = table_id_;
									document.print_form.all_product_list.value = all_product_list_;
									document.print_form.table_info.value = table_info_;
									document.print_form.rowcount.value = eleman_sayisi;
									document.print_form.update_price_action.value = type;
									document.print_form.secili_urunler.value = selected_;
									document.print_form.screen_wrk_id.value = screen_wrk_id_;
									document.print_form.action = adress_;
									document.print_form.target = 'save_window_scr';
									document.print_form.submit();
								f_print = 1;
						   }
						   
						   function secilileri_getir()
						   {
								var filtergroup = new $.jqx.filter();
								var filter_or_operator = 1;
								var filtervalue = true;
								var filtercondition = 'equal';
								var filter1 = filtergroup.createfilter('booleanfilter', filtervalue, filtercondition);
								filtergroup.addfilter(filter_or_operator, filter1);
								$("#jqxgrid").jqxGrid('addfilter', 'active_row', filtergroup);
								$("#jqxgrid").jqxGrid('applyfilters');   
							}
							
						   function ana_urunleri_goster()
						   {
							<cfif isdefined("session.ep.userid")>
								var filtergroup = new $.jqx.filter();
								var filter_or_operator = 1;
								var filtervalue = '1';
								var filtercondition = 'EQUAL';
								var filter1 = filtergroup.createfilter('numericfilter', filtervalue, filtercondition);
								filtergroup.addfilter(filter_or_operator, filter1);
								$("#jqxgrid").jqxGrid('addfilter', 'row_type', filtergroup);
								$("#jqxgrid").jqxGrid('applyfilters');
							</cfif>		
							}
							
						   function ana_urunleri_goster2()
						   {
								var filtergroup = new $.jqx.filter();
								var filter_or_operator = 1;
								var filtervalue = '0';
								var filtercondition = 'GREATER_THAN';
								var filter1 = filtergroup.createfilter('numericfilter', filtervalue, filtercondition);
								filtergroup.addfilter(filter_or_operator, filter1);
								$("#jqxgrid").jqxGrid('addfilter', 'ReportsTo', filtergroup);
								$("#jqxgrid").jqxGrid('applyfilters');
							}
							
							function ana_urunleri_goster3()
						   {
								var filtergroup = new $.jqx.filter();
								var filter_or_operator = 1;
								var filtervalue = '1';
								var filtercondition = 'EQUAL';
								var filter1 = filtergroup.createfilter('numericfilter', filtervalue, filtercondition);
								filtergroup.addfilter(filter_or_operator, filter1);
								$("#jqxgrid").jqxGrid('addfilter', 'row_type', filtergroup);
								$("#jqxgrid").jqxGrid('applyfilters');
							}
							
							function p_name_render(row, columnfield, value, defaulthtml, columnproperties, rowdata)
							{
								var ret = jQuery("#jqxgrid").jqxGrid('getRowData',row);
								ret_p = ret.product_id;
								ret_t = ret.row_type;
								ret_s = ret.stock_count;
								ret_c = ret.product_color;
								ret_f = parseFloat(ret.price_control);
								
								if(ret_f < 0)
									value_ = '<span id="urun_' + (-1 * ret_f) + '" style="background-color:<cfoutput>###get_defines.ACTIVE_PRICE_COLOR#</cfoutput>;">' + value + '</span>';
								else if(ret_f > 0)
									value_ = '<span id="urun_' + ret_f + '" style="background-color:<cfoutput>###get_defines.NEXT_PRICE_COLOR#</cfoutput>">' + value + '</span>';
								else
									value_ = '<span id="urun_' + ret_p + '">' + value + '</span>';
									
								if(ret_t == 2)
									value_ = '<div style="width:100%;background-color:<cfoutput>###get_defines.STOCK_COLOR#</cfoutput>">' + value + '</div>';
								
								if(ret_t == 3)
									value_ = '<div style="width:100%;background-color:<cfoutput>###get_defines.department_color#</cfoutput>">' + value + '</div>';
									
								
								if(ret_c == '')
								{
									return '<table cellpadding="0" cellspacing="0" width="100%"><tr><td style="padding-top:5px;padding-left:5px;">' + value_ + '</td>';
								}
								else
								{
									if(ret_t == 1)
										return '<table cellpadding="0" cellspacing="0" width="100%"><tr><td style="padding-top:5px;padding-left:5px;">' + '<a style="text-decoration:none;font-weight:bold;color:' + ret_c + ';">' + value_ + '</a></td></tr></table>';
									else
										return '<table cellpadding="0" cellspacing="0" width="100%" style="height:100%;background-color:#cccccc;"><tr><td style="padding-top:5px;padding-left:5px;">' + value_ + '</td><tr></table>';	
								}
							}
								
								function treerenderer2(row, columnfield, value, defaulthtml, columnproperties, rowdata)
								{
									if (value != '') 
									{
										var ret = jQuery("#jqxgrid").jqxGrid('getRowData',row);
										ret_p = ret.product_id;
										ret_t = ret.row_type;
										ret_s = ret.sub_rows_count;
										ret_c = ret.product_color;
										ret_f = ret.price_control;
										
										value_ = value;
										
										if(ret_s > 0)
											img_ = '<img style="margin-left:5px;margin-top:8px;" src="/images/listele.gif"/>';
										else
											img_ = '<img style="margin-left:5px;margin-top:8px;" src="/images/listele.gif"/>';
										
										if(ret_t == 1)
											return '<table cellpadding="0" cellspacing="0" width="100%"><tr><td style="padding-top:5px;padding-left:5px;">' + value_ + '</td><td width="10">' + '<a href="javascript://" onclick="del_manage_row(' + row + ');"><img src="/images/delete12.gif" style="margin-left:5px;margin-top:8px;"/></a>' + '</td>' + '<td width="10">'+  '<a href="javascript://" onclick="open_close_down_product(' + ret_p + ');" style="float:left;">' + img_ + '</a></td><td width="2"></td></tr></table>';
										else if(ret_t == 2)
											return '<table cellpadding="0" cellspacing="0" width="100%" style="height:100%;"><tr><td style="padding-top:5px;padding-left:5px;background-color:<cfoutput>###get_defines.STOCK_COLOR#</cfoutput>;">' + value_ + '</td><tr></table>';
										else if(ret_t == 3)
											return '<table cellpadding="0" cellspacing="0" width="100%" style="height:100%;"><tr><td style="padding-top:5px;padding-left:5px;background-color:<cfoutput>###get_defines.department_color#</cfoutput>;">' + value_ + '</td><tr></table>';
									}
								}
								
							function std_renderer(row, columnfield, value, defaulthtml, columnproperties, rowdata)
							{
								if (value != '') 
								{
									value_ = value;
									
									if(value_ > 0)
										img_ = '<img style="margin-left:5px;margin-top:8px;" src="/images/up.gif"/>';
									else if(value_ < 0)
										img_ = '<img style="margin-left:5px;margin-top:8px;" src="/images/down.gif"/>';
									else
										img_ = '';
										
									return '<table cellpadding="0" cellspacing="0"><tr><td>' + img_ + '</td><td> &nbsp;' + commaSplit(value_) + '</td></tr></table>';
								}
							}
							
							function get_yoldaki_stok(product_id,product_name)
							{
								start_date = '<cfoutput>#dateformat(dateadd('d',order_control_day,bugun_),"dd.mm.yyyy")#</cfoutput>';
								finish_date = '<cfoutput>#dateformat(dateadd('d',1,bugun_),"dd.mm.yyyy")#</cfoutput>';
								window.open('index.cfm?fuseaction=retail.list_order&order_stage=76&listing_type=2&product_id=' + product_id + '&product_name=' + product_name + '&currency_id=-6' + '&start_date=' + start_date + '&finish_date=' + finish_date);	
							}
								
						   <cfif isdefined("product_id_list")>
								   js_product_id_list = '<cfoutput>#product_id_list#</cfoutput>';
						   </cfif>
						   <cfif dept_count_ eq 1 or not isdefined("product_id_list")>
								   open_js_product_id_list = '';
						   <cfelse>
								open_js_product_id_list = '<cfoutput>#product_id_list#</cfoutput>';
						   </cfif>
						   $(document).ready(function () 
						   {
							   page_loaded = 0;
							   
							   var numberrenderer = function (row, column, value) 
							   {
								 return '<div style="text-align: center; margin-top: 5px;">' + (0 + value) + '</div>';
								 }
								
								 <cfoutput query="get_headers">
									<cfif len(kolon_tip) and kolon_tip is 'numberinput'>
									 $("##numbereditor_special_#kolon_ad#").jqxNumberInput({
													decimalSeparator: ',',
													inputMode: "simple",
													theme: 'energyblue',
													rtl: false,
													width: 100,
													height: 25,
													spinButtons: false,
													spinButtonsStep:0,
													decimalDigits:3,
													promptChar:" ",
													symbol: " ",
													symbolPosition: "left"
												});
										$("##numbereditor_special_#kolon_ad#").hide();
									</cfif>
								</cfoutput>
							   //$("#search_department_id").jqxDropDownList({autoDropDownHeight: true,checkboxes: true, width: 125, height: 25 });
				
							   function add_product_excel()
								{
									adres_ = 'index.cfm?fuseaction=retail.popup_add_row_to_speed_manage_product_excel&new_page=1';
									adres_ += '&search_startdate=' + document.getElementById('search_startdate').value;
									adres_ += '&search_finishdate=' + document.getElementById('search_finishdate').value;
									windowopen(adres_,'page','add_product_windl');
									add_product_windl.focus();
								}
								
								function open_old_prices()
								{
									adres_ = 'index.cfm?fuseaction=retail.popup_old_prices';
									adres_ += '&new_page=1&product_id_list=' + document.getElementById('all_product_list').value;
									windowopen(adres_,'wide2');
								}
							   
								function add_product(){
									adres_ =  'index.cfm?fuseaction=retail.popup_add_row_to_speed_manage_product';
									windowopen(adres_,'wide');
								}
	
								function save_layout(){
									adres_ = 'index.cfm?fuseaction=retail.emptypopup_save_layout_new';
									adres_ += '&layout_id=' + document.getElementById('layout_id').value;
									openBoxDraggable(adres_);
								}
	
							   foot_ = parseInt(600);
							   head_ = parseInt(50);
								  
							   jheight = foot_ - head_ - 60;
							   jwidth = window.innerWidth - 25;
							   
							   <cfoutput>var url = "/documents/retail/xml/tables_#attributes.table_code#_#userid_#.txt";</cfoutput>
							   var p_types_ = [
							   {value: "", label: "Seciniz" },
							   <cfoutput query="get_price_types">{value: "#type_id#", label: "#type_code#" }<cfif currentrow neq get_price_types.recordcount>,</cfif></cfoutput>
							   ];
							   
							   var p_types_Source =
								{
									 datatype: "array",
									 datafields: [
										 {name: 'label', type: 'string'},
										 {name: 'value', type: 'number'}
									 ],
									 localdata: p_types_
								};
							   
							   var p_types_Adapter = new $.jqx.dataAdapter(p_types_Source,{
									autoBind: true
								});
								
								var source =
								 {
										dataType: "json",
									dataFields: [
										{ name: 'sira_no', type: 'string' },
										{ name: 'product_color', type: 'string' },
										{ name: 'price_control', type: 'string' },
										{ name: 'product_code', type: 'string' },
										{ name: 'row_type', type: 'string' },
										{ name: 'ReportsTo', type: 'string' },
										{ name: 'product_name', type: 'string' },
										{ name: 'product_id', type: 'string' },
										{ name: 'active_row', type: 'bool' },
										{ name: 'stock_id', type: 'string' },
										{ name: 'stock_count', type: 'string' },
										{ name: 'list_price', type: 'float' },
										{ name: 'list_price_kdv', type: 'float' },
										{ name: 'p_ss_marj', type: 'float' },
										{ name: 's_profit', type: 'float' },
										{ name: 'info_standart_alis', type: 'float' },
										{ name: 'is_purchase', type: 'bool' },
										{ name: 'is_purchase_c', type: 'bool' },
										{ name: 'is_purchase_m', type: 'bool' },
										{ name: 'is_sales', type: 'bool' },
										{ name: 'barcode', type: 'string' },
										{ name: 'product_code_r', type: 'string'},
										{ name: 'product_price_change_lastrowid', type: 'string'},
										{ name: 'product_price_change_count', type: 'string'},
										{ name: 'product_price_change_detail', type: 'string'},
										{ name: 'price_type', type: 'string', value:'price_type_id', values: { source: p_types_Adapter.records, value: 'value', name: 'label' }},
										{ name: 'price_type_id', type: 'string'},
										{ name: 'standart_alis', type: 'float'},
										{ name: 'standart_alis_liste', type: 'float'},
										{ name: 'standart_alis_kdv', type: 'float'},
										{ name: 'standart_alis_kdvli', type: 'float'},
										{ name: 'c_standart_alis_kdvli', type: 'float'},
										{ name: 'p_discount_manuel', type: 'float'},
										{ name: 'new_alis_start', type: 'float'},
										{ name: 'new_alis', type: 'float'},
										{ name: 'new_alis_kdvli', type: 'float'},
										{ name: 'is_active_p', type: 'bool'},
										{ name: 'p_startdate', type: 'string'},
										{ name: 'p_finishdate', type: 'string'},
										{ name: 'first_satis_price', type: 'float'},
										{ name: 'is_active_s', type: 'bool' },
										{ name: 'avantaj_oran', type: 'float'},
										{ name: 'first_satis_price_kdv', type: 'float'},
										{ name: 'alistan_maliyetli_marjli_fiyat', type: 'float'},
										{ name: 'sales_discount', type: 'string' },
										{ name: 'avg_rival', type: 'float' },
										{ name: 'ortalama_satis_gunu', type: 'float' },
										{ name: 'stok_yeterlilik_suresi', type: 'float' },
										{ name: 'stok_yeterlilik_suresi_order', type: 'float' },
										{ name: 'genel_stok_tutar', type: 'float' },
										{ name: 'dueday', type: 'float'},
										{ name: 'add_stock_gun', type: 'float'},
										{ name: 'gun_total', type: 'float'},
										{ name: 'stok_devir_hizi', type: 'float'},
										{ name: 'urun_stok', type: 'float'},
										{ name: 'depo_stok', type: 'float'},
										{ name: 'magaza_stok', type: 'float'},
										{ name: 'yoldaki_stok', type: 'float'},
										{ name: 'oneri_siparis', type: 'float'},
										{ name: 'oneri_siparis2', type: 'float'},
										{ name: 'carpan', type: 'string'},
										{ name: 'carpan2', type: 'string'},
										{ name: 'siparis_onay', type: 'bool'},
										{ name: 'siparis_sevk', type: 'bool'},
										{ name: 'siparis_miktar', type: 'float'},
										{ name: 'siparis_miktar_k', type: 'float'},
										{ name: 'siparis_miktar_p', type: 'float'},
										{ name: 'siparis_tutar_1', type: 'float'},
										{ name: 'siparis_tutar_kdv_1', type: 'float'},
										{ name: 'siparis_tarih_1', type: 'string'},
										{ name: 'siparis_onay_2', type: 'bool'},
										{ name: 'siparis_sevk_2', type: 'bool'},					
										{ name: 'siparis_miktar_2', type: 'float'},
										{ name: 'siparis_miktar_k_2', type: 'float'},
										{ name: 'siparis_miktar_p_2', type: 'float'},
										{ name: 'siparis_tutar_2', type: 'float'},
										{ name: 'siparis_tutar_kdv_2', type: 'float'},
										{ name: 'siparis_tarih_2', type: 'string'},
										{ name: 'company_code', type: 'string'},
										{ name: 'company_name', type: 'string'},
										{ name: 'startdate', type: 'string'},
										{ name: 'finishdate', type: 'string'},
										{ name: 'satis_kdv', type: 'float'},
										{ name: 'standart_satis', type: 'float'},
										{ name: 'c_standart_satis', type: 'float'},
										{ name: 'c_standart_satis_kdv', type: 'float'},
										{ name: 'standart_satis_kdv', type: 'float'},
										{ name: 'c_is_standart_satis_aktif', type: 'bool'},
										{ name: 'is_standart_satis_aktif', type: 'bool'},
										{ name: 'maliyet', type: 'float'},
										{ name: 'satis_standart_satis_oran', type: 'float'},
										{ name: 'stok_dagitim', type: 'string'},
										{ name: 'seviye_bilgisi', type: 'string'},
										{ name: 'standart_alis_indirim_tutar', type: 'float'},
										{ name: 'standart_alis_indirim_yuzde', type: 'string'},
										{ name: 'standart_alis_baslangic', type: 'string'},
										{ name: 'standart_satis_baslangic', type: 'string'},
										{ name: 'alis_kar', type: 'float'},
										{ name: 'standart_alis_kar', type: 'float'},
										{ name: 'standart_satis_kar', type: 'float'},
										{ name: 'standart_satis_oran', type: 'float'},
										{ name: 'standart_alis_oran', type: 'float'},
										{ name: 'eski_standart_alis_kdvli', type: 'float'},
										{ name: 'eski_standart_satis_kdvli', type: 'float'},
										{ name: 'eski_kar', type: 'float'},
										{ name: 'liste_oran', type: 'float'},
										{ name: 'donem_satis', type: 'string'},
										{ name: 'donem_satis_tutar', type: 'string'},
										{ name: 'product_cat', type: 'string'},
										{ name: 'sub_rows_count', type: 'float'},
										{ name: 'c_first_satis_price', type: 'float'},
										{ name: 'c_new_alis_kdvli', type: 'float'},
										{ name: 'p_product_type', type: 'bool'},
										{ name: 'product_info', type: 'string'},
										{ name: 'price_departments', type: 'string'},
										{ name: 'std_p_control', type: 'float'},
										{ name: 'unit_price', type: 'float'}	
									],
									id:'id',
									url: url
								 };
								 
								   var dataAdapter = new $.jqx.dataAdapter(source,{
									loadComplete: function () {}
								});			
				
								function createfilterwidget(column, columnElement, widget) 
								{
									widget.jqxDateTimeInput({ firstDayOfWeek: 1 });
								}
								
								
								islem_basladi = 0;
								
								$("#jqxgrid").on('cellendedit', function (event) 
								{					
									alan_adi = event.args.datafield;
									value = event.args.value;
									
									if(alan_adi == 'siparis_miktar' || alan_adi == 'siparis_miktar_2' || alan_adi == 'siparis_miktar_k' || alan_adi == 'siparis_miktar_k_2' || alan_adi == 'siparis_miktar_p' || alan_adi == 'siparis_miktar_p_2')
									{
										hesapla_row_siparis(alan_adi,value,event.args.rowindex);
									}					
									else if(alan_adi == 'standart_alis' || alan_adi == 'standart_alis_indirim_yuzde' || alan_adi == 'standart_alis_indirim_tutar')
									{
										value_ = event.args.value;
										std_p_discount_calc(event.args.rowindex,alan_adi,value_);
									}
									else if(alan_adi == 'standart_satis_kar')
									{
										value_ = event.args.value;
										hesapla_first_sales_std(event.args.rowindex,'3',alan_adi,value_,0);
									}
									else if(alan_adi == 'standart_satis')
									{
										hesapla_standart_satis(event.args.rowindex,'kdvsiz',alan_adi,value,0);
									}
									else if(alan_adi == 'standart_satis_kdv')
									{
										value_ = event.args.value;
										hesapla_standart_satis(event.args.rowindex,'kdvli',alan_adi,value_,0);
									}
									else if(alan_adi == 'new_alis_start' || alan_adi == 'sales_discount' || alan_adi == 'p_discount_manuel')
									{
										alan_adi_ = alan_adi;
										value_ = event.args.value;
										p_discount_calc(event.args.rowindex,alan_adi_,value_,0);
									}
									else if(alan_adi == 'p_ss_marj')
									{
										hesapla_first_sales(event.args.rowindex,'3',alan_adi,value,0);
									}
									else if(alan_adi == 'first_satis_price_kdv')
									{
										if(islem_basladi == 0)
										{
											islem_basladi = 1;
											alan_adi_ = alan_adi;
											value_ = event.args.value;
											hesapla_satis(event.args.rowindex,'kdvli',alan_adi_,value_,1);
											islem_basladi = 0;
										}
									}
								});
								
				
								var container = "<div style='margin: 5px;'><input class='jqx-input jqx-widget-content jqx-rc-all' id='searchField' type='text' style='height: 23px; float: left; width: 223px;' /></div>";
								
								
								var groupsrenderer = function (text,group,expanded) 
								{
									no_ = list_getat(group,1,'-');
									g_sira_ = list_find(g_list,no_);
									try
									{
										deger_ = document.getElementById('group_ic_' + g_sira_).innerHTML;
									}
									catch(e)
									{
										deger_ = group;
									}
									return "<div style='margin: 0px;padding:5px; height:100%; background-color:<cfoutput>###get_defines.group_color#;</cfoutput>' id='group_real_" + g_sira_ + "'><span style='font-size:10px;color:<cfoutput>###get_defines.group_font_color#</cfoutput>;'>" + deger_ + "</span></div>";
								}
								
								ilk = 1;
								
								// create Tree Grid
								$("#jqxgrid").jqxTooltip();
								$("#jqxgrid").jqxGrid(
								{
									cellhover: function (element, pageX, pageY)
									{
										var cell = $('#jqxgrid').jqxGrid('getcellatposition', pageX, pageY);
										var index = cell.row;
										if (cell.column == "active_row") 
										{
											veri_ = $('#jqxgrid').jqxGrid('getcellvalue',index,"product_info");
										}
										else
										{
											veri_ = $('#jqxgrid').jqxGrid('getcellvalue',index,"product_name");	
										}
										$("#jqxgrid").jqxTooltip({content:veri_});
										$("#jqxgrid").jqxTooltip('open',10,85);
									},
									rendertoolbar: function (toolbar) 
									{
										var me = this;
										var container = $("<div style='margin: 5px;'></div>");
										
										var span = $("<span style='float: left; margin-top: 5px; margin-right: 4px;'>K. Arama</span>");
										   var input = $("<input class='jqx-input jqx-widget-content jqx-rc-all' id='ara_product_cat' type='text' style='width: 50px;' />");
										
										<cfif isdefined("attributes.table_code")>
											<cfif isdefined("attributes.is_copy")>
												var input11 = $('<cfinput type="text" name="inner_table_code" id="inner_table_code" value="" readonly="yes" style="width:50px;"  class="jqx-input jqx-widget-content jqx-rc-all"/>');
												var input12 = $('<cfinput type="text" name="inner_table_info" id="inner_table_info" value="" style="width:50px;"   class="jqx-input jqx-widget-content jqx-rc-all"/>');
												var input20 = $(' <cfinput type="checkbox" name="is_main" id="is_main"/>');
											<cfelse>
												var input11 = $('<cfinput type="text" name="inner_table_code" id="inner_table_code" value="#attributes.table_code#" readonly="yes" style="width:50px;"  class="jqx-input jqx-widget-content jqx-rc-all"/>');
												var input12 = $('<cfinput type="text" name="inner_table_info" id="inner_table_info" value="#attributes.table_info#" style="width:50px;"  class="jqx-input jqx-widget-content jqx-rc-all"/>');
												var input20 = $('<cfif attributes.is_main eq 1><cfinput type="checkbox" name="is_main" id="is_main" checked/><cfelse><cfinput type="checkbox" name="is_main" id="is_main"/></cfif>');
											</cfif>
										<cfelse>
											var input11 = $('<cfinput type="text" name="inner_table_code" id="inner_table_code" value="" readonly="yes" style="width:50px;"  class="jqx-input jqx-widget-content jqx-rc-all"/>');
											var input12 = $('<cfinput type="text" name="inner_table_info" id="inner_table_info" value=""  class="jqx-input jqx-widget-content jqx-rc-all" style="width:50px;"/>');
											var input20 = $(' <cfinput type="checkbox" name="is_main" id="is_main"/>');
										</cfif>
										
										var span2 = $("<span style=' margin-top: 5px;'>&nbsp;&nbsp;T.Kodu&nbsp;&nbsp;</span>");
										var span3 = $("<span style='margin-top: 5px;'>&nbsp;&nbsp;T.Açıklama&nbsp;&nbsp;</span>");
										var span_bosluk = $("<span style=' margin-top: 5px;'>&nbsp;&nbsp;</span>");
										
										var span4 = $("<span style='margin-top: 5px;'></span>");
										
										//var input1 = $('<input id="auto_size_button" name="auto_size_button" type="button" value="»" alt="Boyutlandır" title="Boyutlandır"/>');
										var input2 = $('<input id="get_all_rows_open" name="get_all_rows_open" type="button" value="v"  alt="Tüm Satırları Aç" title="Tüm Satırları Aç"/>');
										var input3 = $('<input id="get_all_rows" name="get_all_rows" type="button" value="^" alt="Alt Satırları Kapat" title="Alt Satırları Kapat" />');
										var input4 = $('<input value="X" id="clearfilteringbutton" type="button" alt="Filtreleri Temizle" title="Filtreleri Temizle"/>');
										var input5 = $('<input type="button" value="&sect; "  id="shortcut_button"  alt="Kısayollar" title="Kısayollar" />');
										var input7 = $('<input type="button" value=" ▒ "  id="kolon_button" alt="Kolon Yönetimi" title="Kolon Yönetimi"/>');
										var input8 = $('<input type="button" value=" æ "  id="layout_button" alt="Görünüm" title="Görünüm"/>');
										//var input9 = $('<input type="button" value="Uygulama "  id="karebedeli_button"/>');
										var input10 = $('<input type="button" value="Satıcı Limiti "  id="limit_button"/>');
										
										<cfif attributes.is_from_order eq 0>
											var input13 = $('<input type="button" value="Liste "  id="list_create"/>');
											var input14 = $('<input type="button" value="+" id="add_product_b" title="Ürün Ekle"/>');
											var input15 = $('<input type="button" value="╬" id="load_product" title="Ürün Yükle"/>');
										</cfif>
										
										var input16 = $('<input type="button" value="Eski Fiyatlar" id="old_prices"/>');
										var input28 = $('<input type="button" value="G" id="g_button"/>');
										var input17 = $('<input type="button" value="Teklif" id="save_table"/>');
										var input18 = $('<input type="button" value="Yeni Fiyat" id="save_table2"/>');
										var input19 = $('<input type="button" value="Düzenle" id="save_table3"/>');
										var input22 = $('<input type="button" value="Dönüştür" id="save_table4"/>');
										var input6 = $('<input type="button" value="Yeni Sipariş"  id="order_button"/>');
										var input23 = $('<input type="button" value="Sipariş Düzenle"  id="order_button2"/>');
										var input21 = $('<input type="button" value="Print"  id="print_button"/>');
										var input27 = $('<input type="button" value="Std T."  id="standart_dates"/>');
										var input24 = $('<input type="button" value="AT"  id="active_dates"/>');
										var input25 = $('<input type="button" value="ST 1"  id="siparis_dates"/>');
										var input26 = $('<input type="button" value="ST 2"  id="siparis_dates2"/>');
										
										toolbar.append(container);
										
										<cfif isdefined("session.ep.userid")>
											container.append(span);
											container.append(input);
											container.append(span2);
											container.append(input11);
											container.append(span_bosluk);
											container.append(input20);
											container.append(span3);
											container.append(input12);
											container.append(span4);
											
											container.append(input16);
											container.append(input28);
											<cfif attributes.is_from_order eq 0>
												container.append(input14);
												container.append(input15);
											</cfif>
					
											container.append(input2);
											container.append(input3);
											container.append(input4);
											container.append(input5);
											container.append(input7);
											container.append(input8);
					
											container.append(input10);
										
										
											<cfif attributes.is_from_order eq 0>
												container.append(input13);
												container.append(input17);
												container.append(input18);
												container.append(input19);
												container.append(input22);
											</cfif>
											
											container.append(input6);
											container.append(input23);
											container.append(input21);
											container.append(input27);
											container.append(input24);
											container.append(input25);
											container.append(input26);
										<cfelse>
											container.append(span);
											container.append(input);
											container.append(span2);
											container.append(input11);
											container.append(span_bosluk);
											container.append(input20);
											container.append(span3);
											container.append(input12);
											container.append(input21);
											container.append(input10);
											
											<cfif attributes.is_from_order eq 0>
												container.append(input17);
											</cfif>
										</cfif>
										
										<cfif isdefined("session.ep.userid")>
											$("#standart_dates").jqxButton({theme:theme });
											$("#standart_dates").click(function ()
											{
												get_standart_dates();
											});
											
											$("#g_button").jqxButton({theme:theme });
											$("#g_button").click(function ()
											{
												g_button_action();
											});
											
											$("#active_dates").jqxButton({theme:theme });
											$("#active_dates").click(function ()
											{
												get_activite_dates();
											});
											
											$("#siparis_dates").jqxButton({theme:theme });
											$("#siparis_dates").click(function ()
											{
												get_siparis_dates();
											});
											
											$("#siparis_dates2").jqxButton({theme:theme });
											$("#siparis_dates2").click(function ()
											{
												get_siparis_dates2();
											});
											
											$("#print_button").jqxButton({theme:theme });
											$("#print_button").click(function ()
											{
												print_screen();
											});
											
											<cfif attributes.is_from_order eq 0>
												$("#add_product_b").jqxButton({theme:theme });
												$("#add_product_b").click(function ()
												{
													add_product();
												});
												
												$("#save_table").jqxButton({theme:theme });
												$("#save_table").click(function ()
												{
													save_table_func('2');
												});
												
												$("#save_table2").jqxButton({theme:theme });
												$("#save_table2").click(function ()
												{
													save_table_func('0');
												});
												
												$("#save_table3").jqxButton({theme:theme });
												$("#save_table3").click(function ()
												{
													save_table_func('1');
												});
												
												$("#save_table4").jqxButton({theme:theme });
												$("#save_table4").click(function ()
												{
													save_table_func('3');
												});
				
												$("#load_product").jqxButton({theme:theme });
												$("#load_product").click(function ()
												{
													add_product_excel();
												});
												
												$("#list_create").jqxButton({theme:theme });
												$("#list_create").click(function ()
												{
													save_list();
												});
											</cfif>
											
											$("#old_prices").jqxButton({theme:theme });
											$("#old_prices").click(function ()
											{
												open_old_prices();
											});
				
											$("#kolon_button").jqxButton({theme:theme });
											$("#kolon_button").click(function ()
											{
												show_hide('kolon_menu');
												adress_ = 'index.cfm?fuseaction=retail.emptypopup_get_new_layout_system';
												adress_ += '&layout_id=' + document.getElementById('layout_id').value;
												AjaxPageLoad(adress_,'kolon_menu');
											});
											
											$("#layout_button").jqxButton({theme:theme });
											$("#layout_button").click(function ()
											{
												save_layout();
											});
											
											
											$("#shortcut_button").jqxButton({theme:theme });
											$("#shortcut_button").click(function ()
											{
												show_shortcuts();
											});
											
											
											$("#limit_button").jqxButton({theme:theme });
											$("#limit_button").click(function ()
											{
												seller_limit_table();
											});
										  
										  
											$('#clearfilteringbutton').jqxButton({ theme:theme});	
														
											$('#order_button2').jqxButton({ theme:theme});
											$("#order_button2").click(function ()
											{
												update_order();
											});
											
											$('#order_button').jqxButton({ theme:theme});
											$('#order_button').click(function () 
											{
												$("#jqxgrid").jqxGrid('clearfilters');
												var rows = $('#jqxgrid').jqxGrid('getboundrows');
												var rowscount = $('#jqxgrid').jqxGrid('getdatainformation');
												eleman_sayisi = rowscount.rowscount;
												
												document.getElementById("message_div_main_header_info").innerHTML = 'Sipariş';
												document.getElementById("message_div_main").style.height = 200 + "px";
												document.getElementById("message_div_main").style.width = 300 + "px";
												document.getElementById("message_div_main").style.top = (document.body.offsetHeight-200)/2 + "px";
												document.getElementById("message_div_main").style.left = (document.body.offsetWidth-300)/2 + "px";
												document.getElementById("message_div_main").style.zIndex = 99999;
												document.getElementById('message_div_main_body').style.overflowY = 'auto';
												document.getElementById('message_div_main_body').innerHTML = '<br><br>Sipariş Oluşturuluyor. Lütfen Bekleyiniz!';
												show('message_div_main');
												
												callURL('index.cfm?fuseaction=retail.emptypopup_form_add_order_new&ajax=1',handlerPost,
													{
														basket:JSON.stringify(rows),
														rowcount:eleman_sayisi,
														department_list:'<cfoutput>#attributes.search_department_id#</cfoutput>'
													});
											});
											
											$('#clearfilteringbutton').click(function () 
											{
												$("#jqxgrid").jqxGrid('clearfilters');
												ana_urunleri_goster2();
											});	
											
											
											$('#get_all_rows').jqxButton({ theme:theme});
											$('#get_all_rows').click(function () {
												$("#jqxgrid").jqxGrid('clearfilters');
												ana_urunleri_goster3();
											});
											
											$('#get_all_rows_open').jqxButton({ theme:theme});
											$('#get_all_rows_open').click(function () {
												$("#jqxgrid").jqxGrid('clearfilters');
												ana_urunleri_goster2();
											});
										<cfelse>
											$("#limit_button").jqxButton({theme:theme });
											$("#limit_button").click(function ()
											{
												seller_limit_table();
											});
											<cfif attributes.is_from_order eq 0>
												$("#print_button").jqxButton({theme:theme });
												$("#print_button").click(function ()
												{
													print_screen();
												});
												
												$("#save_table").jqxButton({theme:theme });
												$("#save_table").click(function ()
												{
													save_table_func('2');
												});
											<cfelse>
												$("#print_button").jqxButton({theme:theme });
												$("#print_button").click(function ()
												{
													print_order_screen();
												});
											</cfif>	
										</cfif>
										
										var oldVal = "";
										input.on('keydown', function (event) 
										{
											var keycode;
											if(window.event) 
												keycode = window.event.keyCode;
											else if(e) 
												keycode = e.which;
											if(keycode == 13)
											{
												var filtergroup = new $.jqx.filter();
												var filter_or_operator = 1;
												var filtervalue = input.val();
												var filtercondition = 'contains';
												var filter1 = filtergroup.createfilter('stringfilter', filtervalue, filtercondition);
												filtergroup.addfilter(filter_or_operator, filter1);
												$("#jqxgrid").jqxGrid('addfilter', 'product_cat', filtergroup);
												grid_duzenle();			
											}
										});
									},
									ready: function () 
									{
									//	header_duzenle();
										ana_urunleri_goster();
										page_loaded = 1;
									},					
									handlekeyboardnavigation: handleKeys,
									theme: 'energyblue',
									width:jwidth,
									columnsheight:'80px',
									height: jheight,
									source:dataAdapter,
									sortable: false,
									columnsResize: true,
									columnsReorder: true,
									editable:true,
									localization: getLocalization('de'),
									showfilterrow: true,
									filterable: true,
									filtermode: 'excel',
									showtoolbar: true,
									showaggregates: true,
									showstatusbar: true,
									statusbarheight: 25,
									selectionmode: 'multiplecellsadvanced',
									groupable: true,
									showgroupmenuitems: false,
									closeablegroups: false,
									groupsexpandedbydefault: true,
									showgroupsheader: false,
									groups: ['product_cat'],
									groupsrenderer: groupsrenderer,
									columns:[
											{ text: 'Alt Eleman Sayısı', dataField: 'sub_rows_count', minWidth: 50, width: 50,hidden: true},
											{ text: 'Fiyat Sayısı', dataField: 'product_price_change_count', minWidth: 50, width: 50,hidden: true},
											{ text: 'Fiyat Değişimleri', dataField: 'product_price_change_detail', minWidth: 50, width: 50,hidden: true},
											{ text: 'Eski Fiyat Satırı', dataField: 'product_price_change_lastrowid', minWidth: 50, width: 50,hidden:true},
											{ text: 'Ürün Rengi', dataField: 'product_color', minWidth: 50, width: 50,hidden:true},
											{ text: 'Özel Fiyatlı', dataField: 'price_control', minWidth: 50, width: 50,hidden:true},
											{ text: 'Eski Fiyat', dataField: 'c_first_satis_price', minWidth: 50, width: 50,hidden:true},
											{ text: 'Eski Fiyat Alış', dataField: 'c_new_alis_kdvli', minWidth: 50, width: 50,hidden:true},
											{ text: 'Ürün Fiyat Bilgisi', dataField: 'product_info',minWidth: 50, width: 50,hidden:true},
											{ text: 'Şubeler', dataField: 'price_departments',minWidth: 50, width: 50,hidden:true},
											<cfoutput query="get_headers">
											{ 
												<cfif listfind('product_cat',kolon_ad)>
													text: '#kolon_ozelad#',
												<cfelse>
													//text: '#kolon_ozelad#',
													text: '<table class="jqx-grid-column-header-table" cellpadding="0" cellspacing="0" width="100%"><tr><td height="22" class="jqx-grid-column-header-search-td"><div id="div_#kolon_ad#" style="width:100%; height:20px;" class="jqx-grid-column-header-search-div"></div></td></tr><tr><td>#kolon_ozelad#</td></tr></table>',							
												</cfif>
												<cfif kolon_ad is 'price_type'>
														datafield: 'price_type_id', 
														displayfield: 'price_type',
												<cfelse>
													datafield: '#kolon_ad#',
												</cfif>
												<cfif len(KOLON_AGG)>
													aggregates:['#KOLON_AGG#'],
												</cfif>
												<cfif listfind('siparis_onay,siparis_sevk,siparis_miktar,siparis_miktar_k,siparis_miktar_p,siparis_tutar_1,siparis_tutar_kdv_1',kolon_ad)>
													aggregates: [
													{'' : function(aggregatedValue,currentValue,element,summaryData) 
														{
															var last_row1 = $('##jqxgrid').jqxGrid('getrowdatabyid',summaryData.uid);
															deger_ = last_row1.#kolon_ad#;
															if(summaryData.siparis_sevk && (deger_ != null && deger_ != false && deger_ != ''))
															{
																<cfif kolon_ad is 'siparis_onay' or kolon_ad is 'siparis_sevk'>
																	aggregatedValue = aggregatedValue + 1;
																<cfelse>
																	aggregatedValue = aggregatedValue + deger_;
																</cfif>
															}
															return aggregatedValue;
														}
													  }],
												</cfif>
												<cfif listfind('siparis_onay_2,siparis_sevk_2,siparis_miktar_2,siparis_miktar_k_2,siparis_miktar_p_2,siparis_tutar_2,siparis_tutar_kdv_2',kolon_ad)>
													aggregates: [
													{'' : function(aggregatedValue,value,element,summaryData) 
														{
															deger_ = summaryData.#kolon_ad#;
															if(summaryData.siparis_sevk_2)
															{
																<cfif kolon_ad is 'siparis_onay_2' or kolon_ad is 'siparis_sevk_2'>
																	aggregatedValue = aggregatedValue + 1;
																<cfelse>
																	aggregatedValue = aggregatedValue + deger_;
																</cfif>
															}
															return aggregatedValue;
														}
													  }],
												</cfif>
												filterable:<cfif kolon_filtre eq 1>true<cfelse>false</cfif>,
												editable:<cfif KOLON_DUZENLEME eq 1>true<cfelse>false</cfif>,
												width:<cfif len(kolon_en)>#kolon_en#<cfelse>50</cfif>,
												minwidth:<cfif len(kolon_en)>#kolon_en#<cfelse>50</cfif>,
												cellclassname:cellclass,
												//cellclassname:'#kolon_ad#css',
												<cfif len(kolon_begin_edit)>cellbeginedit:#kolon_begin_edit#,</cfif>
												<cfif len(kolon_end_edit)>cellendedit:#kolon_end_edit#,</cfif>
												<cfif kolon_filtre eq 1 and len(kolon_filtre_tipi)>filtertype:'#kolon_filtre_tipi#',</cfif>
												align: '#kolon_align#', 
												   cellsalign: '#kolon_align#',
												<cfif len(kolon_tip)>
													columntype:'#kolon_tip#',
													<cfif kolon_tip is 'datetimeinput'>
														createfilterwidget: createfilterwidget,
													</cfif>
													<cfif kolon_tip is 'input'>
														createeditor: function (row, cellvalue, editor)
														{
															editor.jqxInput(
															{
																width:<cfif len(kolon_en)>#kolon_en#<cfelse>50</cfif>
															});
														},
													</cfif>
												</cfif>
												<cfif len(kolon_render)>cellsrenderer:#kolon_render#,</cfif>
												<cfif len(kolon_format)>cellsformat:'#kolon_format#',</cfif>
												<cfif kolon_ad is 'price_type'>
													createeditor: function (row, value, editor) {
														editor.jqxDropDownList({ source: p_types_Adapter, displayMember: 'label', valueMember: 'value' });
														  },
												</cfif>
												<cfif KOLON_SHOW eq 0>hidden: true,</cfif>
												pinned:<cfif kolon_sabit eq 1>true<cfelse>false</cfif>
											},
										</cfoutput>
										{ text: 'rt', dataField: 'row_type',editable:false,filterable:false,width:10,hidden: true},
										{ text: 'rt', dataField: 'ReportsTo',editable:false,filterable:false,width:10,hidden: true},
										{ text: 'Tedarikçi K.', dataField: 'company_code', minWidth: 50, width: 50,hidden: true},
										{ text: 'S.Alış Info', dataField: 'info_standart_alis', minWidth: 50, width: 50,hidden: true},
										{ text: 'S.Satış Info', dataField: 'c_standart_satis', minWidth: 50, width: 50,hidden: true},
										{ text: 'S.Satış Info KDV', dataField: 'c_standart_satis_kdv', minWidth: 50, width: 50,hidden: true},
										{ text: 'SSK', dataField: 's_profit', minWidth: 50, width: 50,hidden: true}
									]
								});
								
								$('#jqxgrid').on('filter', function (event) 
								{
									//alert('grid uygulandı');	
								});
						
							
								jQuery(function(){
								jQuery(window).bind('beforeunload', function () 
								{
								/*	if(confirm('Bu sayfadan ayrılırsanız yapmış olduğunuz değişiklikler kaybolacaktır!'))
									{
										return true;	
									}
									else
									{
										document.getElementById('wrk_search_button').disabled = false;
										hide('working_div_main');
										return false;
									}*/
								});
								});			
												
							});
							
							function print_order_screen()
							{
							<cfoutput>
								<cfif isdefined("attributes.order_code") and len(attributes.order_code)>
									adress_ = 'index.cfm?fuseaction=retail.popup_update_order_speed_manage_product&is_view=1&order_code=#attributes.order_code#';
								<cfelseif isdefined("attributes.order_id") and len(attributes.order_id)>
									adress_ = 'index.cfm?fuseaction=retail.popup_update_order_speed_manage_product&is_view=1&order_id=#attributes.order_id#';
								<cfelseif isdefined("attributes.order_company_code") and len(attributes.order_company_code)>
									adress_ = 'index.cfm?fuseaction=retail.popup_update_order_speed_manage_product&is_view=1&order_company_code=#attributes.order_company_code#&order_date=#attributes.order_date#&order_company_order_list=#attributes.order_company_order_list#';
								<cfelse>
									adress_ = 'index.cfm?fuseaction=retail.popup_update_order_speed_manage_product';
								</cfif>
								windowopen(adress_,'white_board','print_window');
							</cfoutput>
							}
						</script>
					</head>
					<body class='default'>
						<style>
						<cfoutput query="get_headers">
							.#kolon_ad#css{background-color:###kolon_arka#; color:###kolon_yazi# !important;}
							.#kolon_ad#css div{color:###kolon_yazi# !important;}
							.#kolon_ad#css table tr td{color:###kolon_yazi# !important;}
						</cfoutput>
						</style>
						
						<div id='jqxWidget' style="z-index:1;">
							<cfoutput query="get_headers">
								<cfif len(kolon_tip) and kolon_tip is 'numberinput'>
									<div style='border-radius: 0px; -moz-border-radius: 0px; -webkit-border-radius: 0px; z-index: 99999; top: 0px; left: 0px; position: absolute;' id='numbereditor_special_#kolon_ad#'></div>
								</cfif>
							</cfoutput>
							<div  id="jqxgrid"></div>                
						</div>
					</body>
					</html>
			</cfform>		
		</cf_box>
	</div>
	
	
	<div id="kolon_menu" style="width:100%; display:none;" class="color-list"></div>
	<div id="speed_action_div" style="display:none;"></div>
	
	<script>
		document.getElementById('keyword').select();
	</script>
	
	
	<form name="print_form" action="index.cfm?fuseaction=retail.popup_print_speed_manage_product" method="post">
		<div id="print_div" style="display:none;">
			<input type="text" name="print_table_code" id="print_table_code" value="">
			<input type="text" name="run_count" id="run_count" value="1">
			<input type="text" name="order_company_order_list" value="">
			
			<input type="text" name="table_code" value="">
			<input type="text" name="is_from_price_change" value="">
			<input type="text" name="table_secret_code" value="">
			<input type="text" name="is_main" value="">
			<input type="text" name="table_id" value="">
			<input type="text" name="all_product_list" value="">
			<input type="text" name="table_info" value="">
			<input type="text" name="screen_wrk_id" value="">
			<input type="text" name="rowcount" value="">
			<input type="text" name="update_price_action" value="">
			<input type="text" name="secili_urunler" value="">
			<input type="text" name="department_id_list" value="<cfoutput>#attributes.search_department_id#</cfoutput>">
			<textarea id="print_note" name="print_note" style="height:150px; width:200px;"></textarea>
			<textarea id="row_list" name="row_list" style="height:150px; width:200px;"></textarea>
		</div>
	</form>
	</cfif>