<!--- ! ! ! Satis analiz ! ! !
sale_analyse_report_2.cfm (kar bilgisi gostermeyen detayli satis analizi raporu)
	attributes.report_type 1 : Kategori Bazinda
	attributes.report_type 2 : Urun Bazinda
	attributes.report_type 3 : Stok Bazinda
	attributes.report_type 4 : Müsteri Bazinda
	attributes.report_type 5 : Müsteri Tipi Bazinda
	attributes.report_type 6 : Tedarikci Bazinda
	attributes.report_type 7 : Sube ve Kategori Bazinda (ana kategoriler gelir ve kullanicinin yetkili subeleri listelenir)
	attributes.report_type 8 : Satis Yapan Bazinda
	attributes.report_type 9 : Marka Bazinda
	attributes.report_type 10 : Musteri Degeri Bazinda
	attributes.report_type 11 : Iliski Tipi Bazinda
	attributes.report_type 12 : Mikro Bolge Kodu Bazinda
	attributes.report_type 13 : Satis Bolgesi Bazinda
	attributes.report_type 14 : Odeme Yontemi Bazinda
	attributes.report_type 15 : Hedef Pazar Bazinda
	attributes.report_type 16 : Il Bazinda
	attributes.report_type 17 : Belge ve Stok Bazinda
	attributes.report_type 18 : Müsteri Temsilcisi ve Kategori Bazinda
	attributes.report_type 19 : Fiyat Listesi Bazinda
	attributes.report_type 20 : Ana Kategori Bazinda
	attributes.report_type 21 : Satış Ortağı Bazinda
	attributes.report_type 22 : Belge Bazinda
	attributes.report_type 24 : Müşteri ve Kategori Bazında
 --->
 <cfif session.ep.isBranchAuthorization>
 <cfelse>
	 <cfparam name="attributes.module_id_control" default="20,11">
	 <cfinclude template="report_authority_control.cfm">
 </cfif>
 <cfsetting showdebugoutput="yes"> <!--- Excel alirken sorun cikartiyordu diye kapatildi. M.E.Y 20120810 --->
 <cf_get_lang_set module_name="report">
 <cf_xml_page_edit fuseact="report.sale_analyse_report_orders">
 <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
 <cfparam name="attributes.report_sort"  default="1">
 <cfparam name="attributes.product_employee_id" default="">
 <cfparam name="attributes.product_name" default="">
 <cfparam name="attributes.product_id" default="">
 <cfparam name="attributes.employee_name" default="">
 <cfparam name="attributes.keyword" default="">
 <cfparam name="attributes.employee" default="">
 <cfparam name="attributes.employee_id" default="">
 <cfparam name="attributes.row_employee" default="">
 <cfparam name="attributes.row_employee_id" default="">
 <cfparam name="attributes.product_id" default="">
 <cfparam name="attributes.is_kdv" default="0">
 <cfparam name="attributes.sup_company" default="">
 <cfparam name="attributes.sup_company_id" default="">
 <cfparam name="attributes.company" default="">
 <cfparam name="attributes.company_id" default="">
 <cfparam name="attributes.commethod_id" default="">
 <cfparam name="attributes.pos_code" default="">
 <cfparam name="attributes.pos_code_text" default="">
 <cfparam name="attributes.brand_name" default="">
 <cfparam name="attributes.brand_id" default="">
 <cfparam name="attributes.model_name" default="">
 <cfparam name="attributes.model_id" default="">
 <cfparam name="attributes.department_id" default="">
 <cfparam name="attributes.status" default="">
 <cfparam name="attributes.product_cat" default="">
 <cfparam name="attributes.search_product_catid" default="" >
 <cfparam name="attributes.date1" default="#now()#">
 <cfparam name="attributes.date2" default="#now()#">
 <cfparam name="attributes.termin_date1" default="#now()#">
 <cfparam name="attributes.termin_date2" default="#now()#">
 <cfparam name="attributes.project_id" default="">
 <cfparam name="attributes.project_head" default="">
 <cfparam name="attributes.report_type" default="1">
 <cfparam name="attributes.is_prom" default="0" >
 <cfparam name="attributes.is_other_money" default="0">
 <cfparam name="attributes.is_money_info" default="0">
 <cfparam name="attributes.is_money2" default="0" >
 <cfparam name="attributes.resource_id" default="" >
 <cfparam name="attributes.ims_code_id" default="">
 <cfparam name="attributes.customer_value_id" default="">
 <cfparam name="attributes.zone_id" default="">
 <cfparam name="attributes.is_discount" default="0">
 <cfparam name="attributes.is_project" default="">
 <cfparam name="attributes.segment_id" default="">
 <cfparam name="attributes.member_cat_type" default="">
 <cfparam name="attributes.kontrol" default="0">
 <cfparam name="attributes.cancel_type_id" default="">
 <cfparam name="attributes.order_stage" default="">
 <cfparam name="attributes.graph_type" default="">
 <cfparam name="attributes.is_excel" default="">
 <cfparam name="attributes.is_iptal" default="">
 <cfparam name="attributes.order_process_cat" default="">
 <cfparam name="attributes.sector_cat_id" default="">
 <cfparam name="attributes.sales_member_id" default="">
 <cfparam name="attributes.sales_member_type" default="">
 <cfparam name="attributes.sales_member" default="">
 <cfparam name="attributes.branch_id" default="">
 <cfparam name="attributes.city_id" default="">
 <cfparam name="attributes.county_id" default="">
 <cfparam name="attributes.country_id" default="">
 <cfparam name="attributes.sale_add_option" default="">
 <cfif attributes.is_other_money eq 1 and attributes.is_money2 eq 1>
	 <cfset attributes.is_money2 = 0>
 </cfif>
 <cfquery name="get_basket" datasource="#dsn3#">
	SELECT AMOUNT_ROUND FROM SETUP_BASKET WHERE BASKET_ID = 4
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
		 (PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%sales.list_order%"> OR PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%sales.upd_fast_sale%">)
	 ORDER BY
		 PTR.LINE_NUMBER
 </cfquery>
 <cfif attributes.report_type eq 17>
	 <cfset stage_list_name_id=''>
	 <cfset project_id_list=''>
	 <cfoutput query="get_process_type">
		 <cfset stage_list_name_id=listappend(stage_list_name_id,get_process_type.PROCESS_ROW_ID,',')>
		 <cfset stage_list_name_id=listappend(stage_list_name_id,get_process_type.STAGE,',')>
	 </cfoutput>
	 <cfquery name="get_project" datasource="#dsn#">
		 SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS
	 </cfquery>
	 <cfset project_id_list = valuelist(get_project.project_id,',')>
 </cfif>
 <cfquery name="GET_DEPARTMENT" datasource="#DSN#">
	 SELECT
		 DEPARTMENT_ID,
		 DEPARTMENT_HEAD
	 FROM
		 BRANCH B,
		 DEPARTMENT D 
	 WHERE
		 B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		 B.BRANCH_ID = D.BRANCH_ID AND
		 D.IS_STORE <> 2
		 <cfif isdefined("x_show_pasive_departments") and x_show_pasive_departments eq 0>
			 AND D.DEPARTMENT_STATUS = 1 
		 </cfif>
		 <cfif isdefined("x_bring_to_response") and x_bring_to_response eq 1>
			 AND B.BRANCH_ID IN
				 (SELECT 
					 BRANCH_ID 
				  FROM  
					 EMPLOYEE_POSITION_BRANCHES 
				  WHERE 
					 POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
		 </cfif>
	 ORDER BY
		 DEPARTMENT_HEAD
 </cfquery>
 <cfset cmp = createObject("component","V16.settings.cfc.setupCountry") />
 <cfset GET_COUNTRY_1 = cmp.getCountry()>
 <cfquery name="get_money" datasource="#dsn#"><!--- Onceki Donemlerin Para Birimleri De Gerektiginden Dsnden Cekiliyor FBS --->
	 SELECT MONEY FROM SETUP_MONEY GROUP BY MONEY
 </cfquery>
 <cfoutput query="get_money">
	 <cfset 'total_grosstotal_doviz_#money#' = 0>
 </cfoutput>
 <cfset branch_dep_list=valuelist(get_department.department_id,',')>
 <cfif isdefined("attributes.form_submitted")>
	 <!--- Query blogu --->
	 <cfinclude template="../query/get_sale_analyse_orders.cfm">
 <cfelse>
	 <cfset get_total_purchase.recordcount = 0>
 </cfif>
 <cfparam name="attributes.page" default=1>
 <cfparam name="attributes.totalrecords" default="#get_total_purchase.recordcount#">
 <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
 <cfif isdefined('attributes.is_excel') and  attributes.is_excel eq 1>
	 <cfset attributes.startrow=1>
	 <cfset attributes.maxrows=get_total_purchase.recordcount>
 </cfif>
 <cfset toplam_satis = 0>
 <cfset toplam_discount = 0>
 <cfset toplam_net_fiyet = 0>
 <cfset toplam_kalan_tutar = 0>
 <cfset toplam_miktar = 0>
 <cfset toplam_multiplier = 0>
 <cfset unit2_list = "">
 <cfset toplam_ikinci_miktar = 0>
 <cfset toplam_unit_weıght = 0>
 <cfset toplam_unit_weıght_1 = 0>
 <cfset total_grosstotal = 0>
 <cfset toplam_multiplier_amount_1 = 0>
 <cfif isdate(attributes.date1)><cfset attributes.date1 = dateformat(attributes.date1, dateformat_style)></cfif>
 <cfif isdate(attributes.date2)><cfset attributes.date2 = dateformat(attributes.date2, dateformat_style)></cfif>
 <cfif isdate(attributes.termin_date1)><cfset attributes.termin_date1 = dateformat(attributes.termin_date1, dateformat_style)></cfif>
 <cfif isdate(attributes.termin_date2)><cfset attributes.termin_date2 = dateformat(attributes.termin_date2, dateformat_style)></cfif>
 
 <cfquery name="GET_CUSTOMER_VALUE" datasource="#DSN#">
	 SELECT CUSTOMER_VALUE_ID, CUSTOMER_VALUE FROM SETUP_CUSTOMER_VALUE ORDER BY CUSTOMER_VALUE
 </cfquery>
 <cfif attributes.report_type eq 10>
	 <cfquery name="GET_CUSTOMER_VALUE_2" datasource="#DSN#">
		 SELECT CUSTOMER_VALUE_ID, CUSTOMER_VALUE FROM SETUP_CUSTOMER_VALUE ORDER BY CUSTOMER_VALUE_ID
	 </cfquery>
	 <cfset list_customer_val_ids = valuelist(GET_CUSTOMER_VALUE.CUSTOMER_VALUE_ID,',')>
 </cfif>
 <cfif attributes.report_type eq 11>
	 <cfquery name="GET_RESOURCE_2" datasource="#DSN#">
		 SELECT * FROM COMPANY_PARTNER_RESOURCE ORDER BY RESOURCE_ID
	 </cfquery>
	 <cfset list_resource_ids = valuelist(GET_RESOURCE_2.RESOURCE_ID,',')>
 </cfif>
 <cfquery name="SZ" datasource="#DSN#">
	 SELECT * FROM SALES_ZONES WHERE IS_ACTIVE=1 ORDER BY SZ_NAME
 </cfquery>
 <cfif attributes.report_type eq 13>
	 <cfquery name="SZ_2" datasource="#DSN#">
		 SELECT * FROM SALES_ZONES ORDER BY SZ_ID
	 </cfquery>
	 <cfset list_zone_ids = valuelist(SZ_2.SZ_ID,',')>
 </cfif>
 <cfif attributes.report_type eq 14>
	 <cfquery name="GET_PAY_METHOD" datasource="#DSN#">
		 SELECT 
			 SP.PAYMETHOD_ID,
			 SP.PAYMETHOD
		 FROM 
			 SETUP_PAYMETHOD SP,
			 SETUP_PAYMETHOD_OUR_COMPANY SPOC
		 WHERE 
			 SP.PAYMETHOD_ID = SPOC.PAYMETHOD_ID 
			 AND SPOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
		 ORDER BY 
			 SP.PAYMETHOD_ID
	 </cfquery>
	 <cfset list_pay_ids = valuelist(GET_PAY_METHOD.PAYMETHOD_ID,',')>
	 <cfquery name="GET_CC_METHOD" datasource="#DSN3#">
		 SELECT CARD_NO,PAYMENT_TYPE_ID FROM CREDITCARD_PAYMENT_TYPE ORDER BY PAYMENT_TYPE_ID
	 </cfquery>
	 <cfset list_cc_pay_ids = valuelist(GET_CC_METHOD.PAYMENT_TYPE_ID,',')>
 </cfif>
 <cfquery name="GET_SEGMENTS" datasource="#DSN1#">
	 SELECT PRODUCT_SEGMENT_ID, PRODUCT_SEGMENT FROM PRODUCT_SEGMENT ORDER BY PRODUCT_SEGMENT
 </cfquery>
 <cfquery name="GET_SEGMENTS_2" datasource="#DSN1#">
	 SELECT PRODUCT_SEGMENT_ID, PRODUCT_SEGMENT FROM PRODUCT_SEGMENT ORDER BY PRODUCT_SEGMENT_ID
 </cfquery>
 <cfset list_segment_ids = valuelist(GET_SEGMENTS_2.PRODUCT_SEGMENT_ID,',')>
 <cfif attributes.report_type eq 16>
	 <cfquery name="get_city" datasource="#dsn#">
		 SELECT CITY_ID,CITY_NAME FROM SETUP_CITY 
	 </cfquery>
	 <cfset city_id_list = valuelist(get_city.city_id,',')>
 </cfif>
 <cfquery name="GET_COMPANY_CAT" datasource="#DSN#">
	 SELECT DISTINCT	
		 COMPANYCAT_ID,
		 COMPANYCAT
	 FROM
		 GET_MY_COMPANYCAT
	 WHERE
		 EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
		 OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	 ORDER BY
		 COMPANYCAT
 </cfquery>
 <cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
	 SELECT DISTINCT	
		 CONSCAT_ID,
		 CONSCAT,
		 HIERARCHY
	 FROM
		 GET_MY_CONSUMERCAT
	 WHERE
		 EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
		 OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	 ORDER BY
		 HIERARCHY		
 </cfquery>
 <cfquery name="GET_COMMETHOD_CATS" datasource="#dsn#">
	 SELECT * FROM SETUP_COMMETHOD ORDER BY COMMETHOD
 </cfquery>
 <cfquery name="get_cancel_type" datasource="#dsn3#">
	 <!---SELECT * FROM SETUP_SUBSCRIPTION_CANCEL_TYPE ORDER BY SUBSCRIPTION_CANCEL_TYPE--->
	 SELECT * FROM SETUP_INVOICE_CANCEL_TYPE ORDER BY INV_CANCEL_TYPE
 </cfquery>
 <cfquery name="GET_COMPANY_SECTOR" datasource="#DSN#">
	 SELECT * FROM SETUP_SECTOR_CATS ORDER BY SECTOR_CAT
 </cfquery>
 <cfquery name="get_branch_" datasource="#dsn#">
	 SELECT 
		 BRANCH_NAME,BRANCH_ID
	 FROM
		 BRANCH
	 WHERE
		 COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
		 AND BRANCH_STATUS = 1
		 AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
 </cfquery>
 <cfif attributes.report_type eq 7>
	 <cfquery name="GET_BRANCH" datasource="#DSN#">
		 SELECT 
			 BRANCH_NAME,BRANCH_ID 
		 FROM 
			 BRANCH
		 WHERE
			 COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> 
			 AND BRANCH_STATUS = 1
			 <cfif len(attributes.department_id)>
				 AND BRANCH_ID IN (SELECT BRANCH_ID FROM DEPARTMENT WHERE DEPARTMENT_ID IN 
				 (<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
					 #listfirst(dept_i,'-')#
					 <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1>,</cfif>
				 </cfloop>)
				 )
			 <cfelse>
				 AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
			 </cfif>
		 ORDER BY 
			 BRANCH_NAME
	 </cfquery>
 <cfelseif attributes.report_type eq 18 and get_total_purchase.recordcount>
	 <cfset employee_id_list = ''>
	 <cfoutput query="get_total_purchase">
		 <cfif len(employee_id) and not listfind(employee_id_list,employee_id)>
			 <cfset employee_id_list=listappend(employee_id_list,employee_id)>
		 </cfif>  
	 </cfoutput>	
	 <cfquery name="get_employees" datasource="#dsn#">
		 SELECT 
			 (EMPLOYEE_NAME + ' '+ EMPLOYEE_SURNAME) AS EMP_NAME,
			 EMPLOYEE_ID 
		 FROM 
			 EMPLOYEES
		 WHERE
			 EMPLOYEE_STATUS = 1 AND
			 EMPLOYEE_ID IN (#employee_id_list#)
		 ORDER BY 
			 EMPLOYEE_NAME,
			 EMPLOYEE_SURNAME
	 </cfquery>
 <cfelseif attributes.report_type eq 22 and get_total_purchase.recordcount>
	 <cfset stage_id_list=''>
	 <cfset order_employee_id_list = ''>
	 <cfset sales_add_option_list = ''>
	 <cfset order_county_id_list = ''>
	 <cfset order_city_id_list = ''>
	 <cfset project_id_list = ''>
	 <cfset sales_partner_id_list = ''>
	 <cfset sales_consumer_id_list = ''>
	 <cfset ship_method_id_list = ''>
	 <cfset paymethod_list = ''>
	 <cfoutput query="get_total_purchase">
		 <cfif isdefined('ORDER_STAGE') and len(ORDER_STAGE) and not listfind(stage_id_list,ORDER_STAGE)>
			 <cfset stage_id_list=listappend(stage_id_list,ORDER_STAGE)>
		 </cfif>
		 <cfif isdefined('ORDER_EMPLOYEE_ID') and len(ORDER_EMPLOYEE_ID) and not listfind(order_employee_id_list,ORDER_EMPLOYEE_ID)>
			 <cfset order_employee_id_list=listappend(order_employee_id_list,ORDER_EMPLOYEE_ID)>
		 </cfif>
		 <cfif isdefined('SALES_ADD_OPTION_ID') and len(SALES_ADD_OPTION_ID) and not listfind(sales_add_option_list,SALES_ADD_OPTION_ID)>
			 <cfset sales_add_option_list=listappend(sales_add_option_list,SALES_ADD_OPTION_ID)>
		 </cfif>
		 <cfif isdefined('CITY_ID') and len(CITY_ID) and not listfind(order_city_id_list,CITY_ID)>
			 <cfset order_city_id_list=listappend(order_city_id_list,CITY_ID)>
		 </cfif>
		 <cfif isdefined('COUNTY_ID') and len(COUNTY_ID) and not listfind(order_county_id_list,COUNTY_ID)>
			 <cfset order_county_id_list=listappend(order_county_id_list,COUNTY_ID)>
		 </cfif>
		 <cfif isdefined('PROJECT_ID') and len(PROJECT_ID) and not listfind(project_id_list,PROJECT_ID)>
			 <cfset project_id_list=listappend(project_id_list,PROJECT_ID)>
		 </cfif>
		 <cfif isdefined('SALES_PARTNER_ID') and len(SALES_PARTNER_ID) and not listfind(sales_partner_id_list,SALES_PARTNER_ID)>
			 <cfset sales_partner_id_list=listappend(sales_partner_id_list,SALES_PARTNER_ID)>
		 </cfif>
		 <cfif isdefined('SALES_CONSUMER_ID') and len(SALES_CONSUMER_ID) and not listfind(sales_consumer_id_list,SALES_CONSUMER_ID)>
			 <cfset sales_consumer_id_list=listappend(sales_consumer_id_list,SALES_CONSUMER_ID)>
		 </cfif>
		 <cfif isdefined('SHIP_METHOD') and len(SHIP_METHOD) and not listfind(ship_method_id_list,SHIP_METHOD)>
			 <cfset ship_method_id_list=listappend(ship_method_id_list,SHIP_METHOD)>
		 </cfif>
		 <cfif isdefined('PAYMETHOD') and len(PAYMETHOD) and not listfind(paymethod_list,PAYMETHOD)>
			 <cfset paymethod_list=listappend(paymethod_list,PAYMETHOD)>
		 </cfif>
	 </cfoutput>
	 <cfif listlen(stage_id_list)>
		 <cfset stage_id_list=listsort(stage_id_list,"numeric","ASC",",")>
		 <cfquery name="get_stage" datasource="#DSN#">
			 SELECT STAGE, PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#stage_id_list#) ORDER BY PROCESS_ROW_ID	
		 </cfquery>
		 <cfset stage_id_list = listsort(listdeleteduplicates(valuelist(get_stage.PROCESS_ROW_ID,',')),'numeric','ASC',',')>
	 </cfif>
	 <cfif listlen(order_employee_id_list)>
		 <cfset order_employee_id_list=listsort(order_employee_id_list,"numeric","ASC",",")>
		 <cfquery name="get_emp" datasource="#DSN#">
			 SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME EMPLOYEE,EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#order_employee_id_list#) ORDER BY EMPLOYEE_ID
		 </cfquery>
		 <cfset order_employee_id_list = listsort(listdeleteduplicates(valuelist(get_emp.EMPLOYEE_ID,',')),'numeric','ASC',',')>
	 </cfif>
	 <cfif listlen(sales_add_option_list)>
		 <cfset sales_add_option_list=listsort(sales_add_option_list,"numeric","ASC",",")>
		 <cfquery name="get_sale_add_options" datasource="#DSN3#">
			 SELECT
				 SALES_ADD_OPTION_ID,
				 SALES_ADD_OPTION_NAME
			 FROM
				 SETUP_SALES_ADD_OPTIONS
			 WHERE
				 SALES_ADD_OPTION_ID IN (#sales_add_option_list#)
			 ORDER BY
				 SALES_ADD_OPTION_ID
		 </cfquery>
		 <cfset sales_add_option_list = listsort(listdeleteduplicates(valuelist(get_sale_add_options.SALES_ADD_OPTION_ID,',')),'numeric','ASC',',')>
	 </cfif>
	 <cfif listlen(order_city_id_list)>
		 <cfset order_city_id_list=listsort(order_city_id_list,"numeric","ASC",",")>
		 <cfquery name="get_order_city" datasource="#DSN#">
			 SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE CITY_ID IN (#order_city_id_list#) ORDER BY CITY_ID
		 </cfquery>
		 <cfset order_city_id_list = listsort(listdeleteduplicates(valuelist(get_order_city.CITY_ID,',')),'numeric','ASC',',')>
	 </cfif>
	 <cfif listlen(order_county_id_list)>
		 <cfset order_county_id_list=listsort(order_county_id_list,"numeric","ASC",",")>
		 <cfquery name="get_order_county" datasource="#DSN#">
			 SELECT COUNTY_NAME,COUNTY_ID,CITY FROM SETUP_COUNTY WHERE COUNTY_ID IN (#order_county_id_list#) ORDER BY COUNTY_ID
		 </cfquery>
		 <cfset order_county_id_list = listsort(listdeleteduplicates(valuelist(get_order_county.COUNTY_ID,',')),'numeric','ASC',',')>
	 </cfif>
	 <cfif listlen(project_id_list)>
		 <cfset project_id_list=listsort(project_id_list,"numeric","ASC",",")>
		 <cfquery name="get_project" datasource="#dsn#">
			 SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_id_list#) ORDER BY PROJECT_ID
		 </cfquery>
		 <cfset project_id_list = listsort(listdeleteduplicates(valuelist(get_project.PROJECT_ID,',')),'numeric','ASC',',')>
	 </cfif>
	 <cfif listlen(sales_partner_id_list)>
		 <cfset sales_partner_id_list=listsort(sales_partner_id_list,"numeric","ASC",",")>
		 <cfquery name="get_sales_partner" datasource="#dsn#">
			 SELECT PARTNER_ID,COMPANY_PARTNER_NAME+' '+COMPANY_PARTNER_SURNAME SALES_PARTNER FROM COMPANY_PARTNER WHERE PARTNER_ID IN (#sales_partner_id_list#) ORDER BY PARTNER_ID
		 </cfquery>
		 <cfset sales_partner_id_list = listsort(listdeleteduplicates(valuelist(get_sales_partner.PARTNER_ID,',')),'numeric','ASC',',')>
	 </cfif>
	 <cfif listlen(sales_consumer_id_list)>
		 <cfset sales_consumer_id_list=listsort(sales_consumer_id_list,"numeric","ASC",",")>
		 <cfquery name="get_sales_consumer" datasource="#dsn#">
			 SELECT CONSUMER_ID,CONSUMER_NAME+' '+CONSUMER_SURNAME SALES_CONSUMER FROM CONSUMER WHERE CONSUMER_ID IN (#sales_consumer_id_list#) ORDER BY CONSUMER_ID
		 </cfquery>
		 <cfset sales_consumer_id_list = listsort(listdeleteduplicates(valuelist(get_sales_consumer.CONSUMER_ID,',')),'numeric','ASC',',')>
	 </cfif>
	 <cfif listlen(ship_method_id_list)>
		 <cfset ship_method_id_list=listsort(ship_method_id_list,"numeric","ASC",",")>
		 <cfquery name="get_ship_method" datasource="#dsn#">
			 SELECT SHIP_METHOD_ID,SHIP_METHOD FROM SHIP_METHOD WHERE SHIP_METHOD_ID IN (#ship_method_id_list#) ORDER BY SHIP_METHOD_ID
		 </cfquery>
		 <cfset ship_method_id_list = listsort(listdeleteduplicates(valuelist(get_ship_method.SHIP_METHOD_ID,',')),'numeric','ASC',',')>
	 </cfif>
	 <cfif listlen(paymethod_list)>
		 <cfset paymethod_list=listsort(paymethod_list,"numeric","ASC",",")>
		 <cfquery name="get_paymethod" datasource="#dsn#">
			 SELECT PAYMETHOD_ID,PAYMETHOD FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID IN (#paymethod_list#) ORDER BY PAYMETHOD_ID
		 </cfquery>
		 <cfset paymethod_list = listsort(listdeleteduplicates(valuelist(get_paymethod.PAYMETHOD_ID,',')),'numeric','ASC',',')>
	 </cfif>
 <cfelse>
	 <cfset get_employees.recordcount = 0>
 </cfif>
<cfsavecontent variable="title"><cf_get_lang dictionary_id='30072.Satis Analiz Siparis'></cfsavecontent>
	<cf_report_list_search id="analyse_report_" title="#title#">
		<cf_report_list_search_area>
	 		<cfform name="rapor" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">
		 	<input type="hidden" name="form_submitted" id="form_submitted" value="">
			 	<div class="row">
        		    <div class="col col-12 col-xs-12">
            		    <div class="row formContent">
                		    <div class="row" type="row">
							    <div class="col col-3 col-md-6 col-xs-12">
								    <div class="form-group">
									    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
									    <div class="col col-9 col-xs-12">
									        <div class="input-group">
												<cf_wrk_product_cat form_name='rapor' hierarchy_code='search_product_catid' product_cat_name='product_cat'>
												<input type="hidden" name="search_product_catid" id="search_product_catid" value="<cfif len(attributes.product_cat)><cfoutput>#attributes.search_product_catid#</cfoutput></cfif>">
												<input type="text" name="product_cat" id="product_cat" style="width:120px;" value="<cfif len(attributes.product_cat)><cfoutput>#attributes.product_cat#</cfoutput></cfif>" onkeyup="get_product_cat();" onFocus="AutoComplete_Create('product_cat','HIERARCHY,PRODUCT_CAT','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID','productcat_id','form','3','200');">
												<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_code=rapor.search_product_catid&field_name=rapor.product_cat</cfoutput>');"></span>
											</div>
										</div>
									</div>		
									<div class="form-group">
									    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
									    <div class="col col-9 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="product_id" id="product_id" value="<cfif len(attributes.product_name)><cfoutput>#attributes.product_id#</cfoutput></cfif>">
												<input type="text" name="product_name" id="product_name" style="width:120px;" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product_autocomplete','0','PRODUCT_ID','product_id','','3','200');" autocomplete="off" value="<cfoutput>#attributes.product_name#</cfoutput>" passthrough="readonly=yes">
												<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="set_the_report();windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=rapor.product_id&field_name=rapor.product_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','list');"></span>
											</div>
										</div>	
									</div>
									<div class="form-group">
									    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58448.Ürün Sorumlusu'></label>
									    <div class="col col-9 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="product_employee_id" id="product_employee_id"  value="<cfif len(attributes.employee_name)><cfoutput>#attributes.product_employee_id#</cfoutput></cfif>">
												<input type="text" name="employee_name" id="employee_name" style="width:120px;" value="<cfif len(attributes.employee_name)><cfoutput>#attributes.employee_name#</cfoutput></cfif>" maxlength="255" onfocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','125');">
												<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=rapor.product_employee_id&field_name=rapor.employee_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,9','list');"></span>
											</div>
										</div>
									</div>
									<div class="form-group">
									    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58448.Tedarikçi'></label>
									    <div class="col col-9 col-xs-12">	
											<div class="input-group">
												<input type="hidden" name="sup_company_id" id="sup_company_id" value="<cfif len(attributes.sup_company)><cfoutput>#attributes.sup_company_id#</cfoutput></cfif>">
												<input type="text" name="sup_company" id="sup_company" style="width:120px;" value="<cfif len(attributes.sup_company)><cfoutput>#attributes.sup_company#</cfoutput></cfif>" onfocus="AutoComplete_Create('sup_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','sup_company_id','','3','250');">
												<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=rapor.sup_company&field_comp_id=rapor.sup_company_id<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2','list');"></span>
											</div>
										</div>
									</div>		
									<div class="form-group">
									    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='39223.Satış Ortağı'></label>
									    <div class="col col-9 col-xs-12">	
											<div class="input-group">
												<cfif len(attributes.sales_member) and len(attributes.sales_member_id) and attributes.sales_member_type is 'partner'>
													<cfset sales_member_id_ = attributes.sales_member_id>
													<cfset sales_member_type_ = "partner">
													<cfset sales_member_ = get_par_info(attributes.sales_member_id,0,-1,0)>
												<cfelseif len(attributes.sales_member) and len(attributes.sales_member_id) and attributes.sales_member_type is 'consumer'>
													<cfset sales_member_id_ = attributes.sales_member_id>
													<cfset sales_member_type_ = "consumer">
													<cfset sales_member_ = get_cons_info(attributes.sales_member_id,0,0)>
												<cfelse>
													<cfset sales_member_id_ = "">
													<cfset sales_member_type_ = "">
													<cfset sales_member_ = "">
												</cfif>
												<cfoutput>
													<input type="hidden" name="sales_member_id" id="sales_member_id" value="<cfif Len(sales_member_) and Len(sales_member_id_)>#sales_member_id_#</cfif>">
													<input type="hidden" name="sales_member_type" id="sales_member_type" value="<cfif Len(sales_member_) and Len(sales_member_id_)>#sales_member_type_#</cfif>">
													<input type="text" name="sales_member" id="sales_member" style="width:120px;" value="<cfif Len(sales_member_) and Len(sales_member_id_)>#sales_member_#</cfif>" onfocus="AutoComplete_Create('sales_member','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2\',0,0,0','PARTNER_CODE,MEMBER_TYPE','sales_member_id,sales_member_type','','3','250');" autocomplete="off">
													<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&field_id=rapor.sales_member_id&field_name=rapor.sales_member&field_type=rapor.sales_member_type<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2,3','list','popup_list_pars');"></span>
												</cfoutput>
											</div>
										</div>
									</div>
									<div class="form-group">
									    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='39364.Satisi Yapan'></label>
									    <div class="col col-9 col-xs-12">	
											<div class="input-group">
												<input type="hidden" name="employee_id" id="employee_id"  value="<cfif len(attributes.employee)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
												<input type="text" name="employee" id="employee" style="width:120px;" value="<cfif len(attributes.employee)><cfoutput>#attributes.employee#</cfoutput></cfif>" maxlength="255" onfocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID,MEMBER_NAME','employee_id,employee','','3','135');">
												<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id2=rapor.employee_id&field_name=rapor.employee<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,9','list');"></span>
				 							</div>
										</div>
									</div>
									<div class="form-group">
									    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57457.Müsteri'></label>
									    <div class="col col-9 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined('attributes.consumer_id') and len(attributes.company)><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
												<input type="hidden" name="company_id" id="company_id" value="<cfif len(attributes.company)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
												<input type="text" name="company" id="company" style="width:120px;" value="<cfif len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','company_id','','3','150');">
												<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=rapor.company&field_comp_id=rapor.company_id&field_consumer=rapor.consumer_id&field_member_name=rapor.company&select_list=2,3','list');"></span>
											</div>
										</div>
									</div>
									<div class="form-group">
									    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58795.Müşteri Temsilcisi'></label>
									    <div class="col col-9 col-xs-12">
											<div class="input-group">
			 									<input type="hidden" name="pos_code" id="pos_code" value="<cfif len(attributes.pos_code_text) and len(attributes.pos_code)><cfoutput>#attributes.pos_code#</cfoutput></cfif>">
												<input type="Text" name="pos_code_text" id="pos_code_text" style="width:120px;" value="<cfif len(attributes.pos_code_text) and len(attributes.pos_code)><cfoutput>#get_emp_info(attributes.pos_code,1,0)#</cfoutput></cfif>" onfocus="AutoComplete_Create('pos_code_text','FULLNAME','FULLNAME','get_emp_pos','','POSITION_CODE','pos_code','','3','130');">
												<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=rapor.pos_code&field_name=rapor.pos_code_text<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,9','list')"></span>
											</div>
										</div>
									</div>
									<div class="form-group">
									    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='39744.Satir Müsteri Temsilcisi'></label>
									    <div class="col col-9 col-xs-12">
											<div class="input-group">	
												<input type="hidden" name="row_employee_id" id="row_employee_id"  value="<cfif len(attributes.row_employee)><cfoutput>#attributes.row_employee_id#</cfoutput></cfif>">
												<input type="text" name="row_employee" id="row_employee" style="width:120px;" value="<cfif len(attributes.row_employee)><cfoutput>#attributes.row_employee#</cfoutput></cfif>" maxlength="255" onFocus="AutoComplete_Create('row_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE,MEMBER_NAME','row_employee_id,row_employee','','3','135');">
												<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id2=rapor.row_employee_id&field_name=rapor.row_employee<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,9','list');"></span>
											</div>
										</div>
									</div>
									<div class="form-group">
									    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58847.Marka'></label>
				 						<cf_wrk_list_items  table_name ='PRODUCT_BRANDS' wrk_list_object_id='BRAND_ID' wrk_list_object_name='BRAND_NAME' sub_header_name="#getLang('main',1435)#" header_name="#getLang('report',1818)#" width='120' datasource ="#DSN1#" >	
									</div>
									<div class="form-group">
									    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58225.Model'></label>
										<cf_wrk_list_items table_name ='PRODUCT_BRANDS_MODEL' wrk_list_object_id='MODEL_ID' wrk_list_object_name='MODEL_NAME' sub_header_name="#getLang('main',813)#" header_name="#getLang('report',1354)#" width='120' datasource ="#dsn1#">
									</div>
									<div class="form-group">
									    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58134.Mikro Bölge Kodu'></label>
									    <div class="col col-9 col-xs-12">
											<div class="input-group">
				 								<cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>
													<cfquery name="GET_IMS" datasource="#dsn#">
														SELECT * FROM SETUP_IMS_CODE WHERE IMS_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ims_code_id#">
													</cfquery>
													<input type="hidden" name="ims_code_id" id="ims_code_id" value="<cfoutput>#attributes.ims_code_id#</cfoutput>">
													<cfinput type="text" name="ims_code_name" style="width:120px;" value="#get_ims.ims_code# #get_ims.ims_code_name#" onFocus="AutoComplete_Create('ims_code_name','IMS_CODE,IMS_CODE_NAME','IMS_NAME','get_ims_code','','IMS_CODE_ID','ims_code_id','','3','200');">
												<cfelse>
													<input type="hidden" name="ims_code_id" id="ims_code_id">
													<cfinput type="text" name="ims_code_name" style="width:120px;" value="" onFocus="AutoComplete_Create('ims_code_name','IMS_CODE,IMS_CODE_NAME','IMS_NAME','get_ims_code','','IMS_CODE_ID','ims_code_id','','3','200');">
												</cfif>
												<span class="input-group-addon btnPointer icon-ellipsis"  href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ims_code&field_name=rapor.ims_code_name&field_id=rapor.ims_code_id','list');"></span>
											</div>
										</div>
									</div>
									<div class="form-group">
									    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></label>
									    <div class="col col-9 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="ship_method_id" id="ship_method_id" value="<cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_name)><cfoutput>#attributes.ship_method_id#</cfoutput></cfif>">
												<input type="text" name="ship_method_name" id="ship_method_name" style="width:120px;" value="<cfif isdefined("attributes.ship_method_name") and len(attributes.ship_method_name)><cfoutput>#attributes.ship_method_name#</cfoutput></cfif>" onfocus="AutoComplete_Create('ship_method_name','SHIP_METHOD','SHIP_METHOD','get_ship_method','','SHIP_METHOD_ID','ship_method_id','','3','125');" autocomplete="off">
												<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=rapor.ship_method_name&field_id=rapor.ship_method_id','list');"></span>
				 							</div>
										</div>
									</div>
								</div>	
								<div class="col col-3 col-md-6 col-xs-12">
									<div class="form-group">
									    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58552.Müsteri Degeri'></label>
									    <div class="col col-9 col-xs-12">
											<select name="customer_value_id" id="customer_value_id" style="width:130px;">
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<cfoutput query="get_customer_value">
													<option value="#customer_value_id#" <cfif customer_value_id eq attributes.customer_value_id>selected</cfif>>#customer_value#</option>
												</cfoutput>
											</select>
										</div>
									</div>	
									<div class="form-group">
									    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='39224.Iliski Tipi'></label>
									    <div class="col col-9 col-xs-12">
											<cf_wrk_combo
											name="resource_id"
											query_name="GET_PARTNER_RESOURCE"
											option_name="resource"
											option_value="resource_id"
											value="#attributes.resource_id#"
											width="130">
										</div>
									</div>	
									<div class="form-group">
									    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='39370.Hedef Pazar'></label>
									    <div class="col col-9 col-xs-12">
											<select name="SEGMENT_ID" id="SEGMENT_ID" style="width:130px;">
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<cfoutput query="GET_SEGMENTS">
													<option value="#PRODUCT_SEGMENT_ID#" <cfif attributes.segment_id eq PRODUCT_SEGMENT_ID>Selected</cfif>>#PRODUCT_SEGMENT#</option>
												</cfoutput>
											</select>
										</div>
									</div>
									<div class="form-group">
									    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58090.Iletisim Yöntemi'></label>
									    <div class="col col-9 col-xs-12">
											<select name="commethod_id" id="commethod_id" style="width:130px;">
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<cfoutput query="get_commethod_cats">
													<option value="#commethod_id#" <cfif commethod_id eq attributes.commethod_id>selected</cfif>>#commethod#</option>
												</cfoutput>
											</select>
										</div>
									</div>	
									<div class="form-group">
									    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57579.Sektör'></label>
									    <div class="col col-9 col-xs-12">
											<select name="sector_cat_id" id="sector_cat_id" style="width:130px;">
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<cfoutput query="get_company_sector">
													<option value="#sector_cat_id#" <cfif sector_cat_id eq attributes.sector_cat_id>selected</cfif>>#sector_cat#</option>
												</cfoutput>
											</select>
										</div>
									</div>
									<div class="form-group">
									    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58825.Iptal Nedeni'></label>
									    <div class="col col-9 col-xs-12">
											<select name="cancel_type_id" id="cancel_type_id" style="width:130px;">
												<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
												<cfoutput query="get_cancel_type">
													<option value="#inv_cancel_type_id#" <cfif inv_cancel_type_id eq attributes.cancel_type_id>selected</cfif>>#inv_cancel_type#</option>
												</cfoutput>
											</select>
										</div>
									</div>
									<div class="form-group">
									    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='39742.Irsaliye Hareketleri'></label>
									    <div class="col col-9 col-xs-12">
											<select name="irsaliye_kontrol" id="irsaliye_kontrol" style="width:130px;">
												<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
												<option value="1" <cfif isdefined("attributes.irsaliye_kontrol") and attributes.irsaliye_kontrol eq 1>selected</cfif>><cf_get_lang dictionary_id ='40291.Irsaliyelenmis'></option>
												<option value="0" <cfif isdefined("attributes.irsaliye_kontrol") and attributes.irsaliye_kontrol eq 0>selected</cfif>><cf_get_lang dictionary_id ='40292.Irsaliyelenmemis'></option>
											</select>
										</div>
									</div>
									<div class="form-group">
									    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='39215.Fatura Hareketleri'></label>
									    <div class="col col-9 col-xs-12">
											<select name="fatura_kontrol" id="fatura_kontrol" style="width:130px;">
												<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
												<option value="1" <cfif isdefined("attributes.fatura_kontrol") and attributes.fatura_kontrol eq 1>selected</cfif>><cf_get_lang dictionary_id ='39216.Faturalanmis'></option>
												<option value="0" <cfif isdefined("attributes.fatura_kontrol") and attributes.fatura_kontrol eq 0>selected</cfif>><cf_get_lang dictionary_id ='39217.Faturalanmamis'></option>
											</select>
										</div>
									</div>
									<div class="form-group">
									    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
									    <div class="col col-9 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id')><cfoutput>#attributes.project_id#</cfoutput></cfif>">
												<input type="text" name="project_head" id="project_head" style="width:118px;" value="<cfif isdefined('attributes.project_head') and  len(attributes.project_head)><cfoutput>#attributes.project_head#</cfoutput></cfif>">
												<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=rapor.project_id&project_head=rapor.project_head');"></span>	
											</div>
										</div>
									</div>
									<div class="form-group">
									    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58219.Ülke'></label>
									    <div class="col col-9 col-xs-12">
											<select name="country_id" id="country_id" style="width:130px;">
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<cfoutput query="get_country_1">
													<option value="#country_id#" <cfif attributes.country_id eq country_id>selected</cfif>>#country_name#</option>
												</cfoutput>
											</select>
										</div>
									</div>	
									<div class="form-group">
									    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='39282.Satis Ozel Tanim'></label>
									    <div class="col col-9 col-xs-12">	
											<cfinclude template="../../sales/query/get_sale_add_option.cfm">
											<select name="sale_add_option" id="sale_add_option" style="width:195px;">
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<cfoutput query="get_sale_add_option">
													<option value="#sales_add_option_id#" <cfif attributes.sale_add_option eq sales_add_option_id>selected</cfif>>#sales_add_option_name#</option>
												</cfoutput>
											</select>
										</div>
									</div>	
									<div class="form-group">
									    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57659.Satis Bölgesi'></label>
									    <div class="col col-9 col-xs-12">	
											<select name="zone_id" id="zone_id" style="width:130px;">
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<cfoutput query="sz">
													<option value="#sz_id#" <cfif attributes.zone_id eq sz_id>selected</cfif>>#sz_name#</option>
												</cfoutput>
											</select>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-3 col-xs-12" <cfif attributes.report_type neq 22>style="display:none;"</cfif> id="ship_address"><cf_get_lang dictionary_id='55200.Sevk Yeri'></label>
										<div class="col col-9 col-xs-12" <cfif attributes.report_type neq 22>style="display:none;"</cfif> id="ship_address2">
											<cfquery name="get_city" datasource="#dsn#">
												SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE COUNTRY_ID = 1
											</cfquery>
											<select name="city_id" id="city_id" style="width:95px;" onchange="LoadCounty(this.value,'county_id')">
												<option value=""><cf_get_lang dictionary_id='58608.İl'></option>
												<cfoutput query="get_city">
													<option value="#city_id#" <cfif attributes.city_id eq city_id>selected</cfif>>#city_name#</option>
												</cfoutput>
											</select>
											<select name="county_id" id="county_id" style="width:95px;">
												<option value=""><cf_get_lang dictionary_id='58638.İlçe'></option>
												<cfif len(attributes.city_id)>
													<cfquery name="GET_COUNTY" datasource="#DSN#">
														SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY WHERE CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city_id#"> ORDER BY COUNTY_NAME
													</cfquery>
													<cfoutput query="get_county">
														<option value="#county_id#" <cfif attributes.county_id eq county_id>selected</cfif>>#county_name#</option>
													</cfoutput>
												</cfif>
											</select>
										</div>
									</div>
								</div>
								<div class="col col-3 col-md-6 col-xs-12">
									<div class="form-group">
									    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58763.Depo'></label>
									    <div class="col col-9 col-xs-12">
											<cfquery name="GET_ALL_LOCATION" datasource="#dsn#">
												SELECT * FROM STOCKS_LOCATION <cfif x_show_pasive_departments eq 0>WHERE STATUS = 1</cfif>
											</cfquery>						
											<select name="department_id" id="department_id" multiple style="width:193px; height:75px;">
												<cfoutput query="get_department">
													<optgroup label="#department_head#">
													<cfquery name="GET_LOCATION" dbtype="query">
														SELECT * FROM GET_ALL_LOCATION WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_department.department_id[currentrow]#">
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
									<div class="form-group">
									    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58609.Üye Kategorisi'></label>
									    <div class="col col-9 col-xs-12">
											<select name="member_cat_type" id="member_cat_type" style="width:193px;height:75px;" multiple="multiple">
												<optgroup label="<cf_get_lang dictionary_id='58039.Kurumsal Üye Kategorileri'>">
												<cfoutput query="get_company_cat">
													<option value="1-#COMPANYCAT_ID#" <cfif listfind(attributes.member_cat_type,'1-#COMPANYCAT_ID#',',')>selected</cfif>>&nbsp;&nbsp;#COMPANYCAT#</option>
												</cfoutput>						
												</optgroup>
												<optgroup label="Bireysel Üye Kategorileri">
												<cfoutput query="get_consumer_cat">
													<option value="2-#CONSCAT_ID#" <cfif listfind(attributes.member_cat_type,'2-#CONSCAT_ID#',',')>selected</cfif>>&nbsp;&nbsp;#CONSCAT#</option>
												</cfoutput>						
												</optgroup>
											</select>	
										</div>
									</div>
									<div class="form-group">
									    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='39675.Siparis Asamasi'></label>
									    <div class="col col-9 col-xs-12">
											<select name="order_stage" id="order_stage" style="width:193px;height:75px;" multiple>
												<option value="-7" <cfif listfind(attributes.order_stage,-7)>selected</cfif>><cf_get_lang dictionary_id='29748.Eksik Teslimat'></option>
												<option value="-8" <cfif listfind(attributes.order_stage,-8)>selected</cfif>><cf_get_lang dictionary_id='29749.Fazla Teslimat'></option>
												<option value="-6" <cfif listfind(attributes.order_stage,-6)>selected</cfif>><cf_get_lang dictionary_id='58761.Sevk'></option>
												<option value="-5" <cfif listfind(attributes.order_stage,-5)>selected</cfif>><cf_get_lang dictionary_id='57456.Üretim'></option>
												<option value="-4" <cfif listfind(attributes.order_stage,-4)>selected</cfif>><cf_get_lang dictionary_id='29747.Kismi Üretim'></option>
												<option value="-3" <cfif listfind(attributes.order_stage,-3)>selected</cfif>><cf_get_lang dictionary_id='29746.Kapatildi'></option>
												<option value="-2" <cfif listfind(attributes.order_stage,-2)>selected</cfif>><cf_get_lang dictionary_id='29745.Tedarik'></option>
												<option value="-1" <cfif listfind(attributes.order_stage,-1)>selected</cfif>><cf_get_lang dictionary_id='58717.Açik'></option>
												<option value="-9" <cfif listfind(attributes.order_stage,-9)>selected</cfif>><cf_get_lang dictionary_id='58506.Iptal'></option>
												<option value="-10" <cfif listfind(attributes.order_stage,-10)>selected</cfif>><cf_get_lang dictionary_id='29746.Kapatildi'>(<cf_get_lang dictionary_id='58500.Manuel'>)</option>
											</select>
										</div>
									</div>
									<div class="form-group">
									    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
									    <div class="col col-9 col-xs-12">
											<select name="branch_id" id="branch_id" style="width:130px;height:75px;" multiple>
												<cfoutput query="get_branch_">
													<option value="#branch_id#"<cfif listfind(attributes.branch_id,branch_id)>selected</cfif>>#branch_name#</option>
												</cfoutput>
											</select>
				 						</div>
									</div>	 
									<div class="form-group">
									    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='39695.Siparis Süreci'></label>
									    <div class="col col-9 col-xs-12">
											<select name="order_process_cat" id="order_process_cat" style="width:193px;height:75px;" multiple>
												<cfoutput query="get_process_type">
													<option value="#process_row_id#"<cfif listfind(attributes.order_process_cat,process_row_id)>selected</cfif>>#stage#</option>
												</cfoutput>
											</select>
										</div>
									</div>
		 						</div>
								<div class="col col-3 col-md-6 col-xs-12">
									 <div class="form-group">
									    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='29501.Siparis Tarihi'></label>
				 							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Tarih Degerini Kontrol Ediniz'></cfsavecontent>
										<div class="col col-9 col-xs-12">
										    <div class="input-group">
												<cfinput value="#attributes.date1#" type="text" maxlength="10" name="date1" validate="#validate_style#" required="yes" message="#message#" style="width:65px;">
												<span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>
												<span class="input-group-addon no-bg"></span>
												<cfinput value="#attributes.date2#" type="text" maxlength="10" name="date2" validate="#validate_style#" required="yes" message="#message#" style="width:65px;" >
												<span class="input-group-addon"><cf_wrk_date_image date_field="date2"></span>
											</div>
										</div>
									</div>				 
									<div class="form-group">
									    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57645.Teslim Tarihi'></label>
											<cfsavecontent variable="message2"><cf_get_lang dictionary_id='57782.Tarih Degerini Kontrol Ediniz !'></cfsavecontent>
										<div class="col col-9 col-xs-12">
										    <div class="input-group">
												<cfinput value="#attributes.termin_date1#" type="text" maxlength="10" name="termin_date1" style="width:65px;" required="yes" message="#message2#" validate="#validate_style#">
												<span class="input-group-addon"><cf_wrk_date_image date_field="termin_date1"></span>
												<span class="input-group-addon no-bg"></span>
												<cfinput value="#attributes.termin_date2#" maxlength="10"  type="text" name="termin_date2" style="width:65px;" required="yes" message="#message2#" validate="#validate_style#">
												<span class="input-group-addon"><cf_wrk_date_image date_field="termin_date2"></span>	
											</div>
										</div>				
									</div>
									<div class="form-group">
									    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58960.Rapor Tipi'></label>
									    <div class="col col-9 col-xs-12">	
											<select name="report_type" id="report_type" style="width:175px;" onchange="type_gizle();">
												<option value="1" <cfif attributes.report_type eq 1>selected</cfif>> <cf_get_lang dictionary_id='39052.Kategori Bazinda'></option>
												<option value="20" <cfif attributes.report_type eq 20>selected</cfif>><cf_get_lang dictionary_id='40556.Ana Kategori'> <cf_get_lang dictionary_id='58601.Bazinda'></option>
												<option value="2" <cfif attributes.report_type eq 2>selected</cfif>> <cf_get_lang dictionary_id='39053.ürün Bazinda'></option>
												<option value="3" <cfif attributes.report_type eq 3>selected</cfif>> <cf_get_lang dictionary_id='39054.Stok Bazinda'></option>
												<option value="4" <cfif attributes.report_type eq 4>selected</cfif>> <cf_get_lang dictionary_id='39257.Müşteri Bazinda'></option>
												<option value="5" <cfif attributes.report_type eq 5>selected</cfif>> <cf_get_lang dictionary_id='39348.Müşteri Tipi Bazinda'></option>
												<option value="24" <cfif attributes.report_type eq 24>selected</cfif>><cf_get_lang dictionary_id='57457.Müşteri'> <cf_get_lang dictionary_id='57457.ve'> <cf_get_lang dictionary_id='39052.Kategori Bazinda'></option>
												<option value="6" <cfif attributes.report_type eq 6>selected</cfif>> <cf_get_lang dictionary_id='39349.Tedarikçi Bazinda'></option>
												<option value="7" <cfif attributes.report_type eq 7>selected</cfif>> <cf_get_lang dictionary_id='39688.Sube ve Kategori Bazinda'></option>
												<option value="8" <cfif attributes.report_type eq 8>selected</cfif>> <cf_get_lang dictionary_id='39351.Satis Yapan Bazinda'></option>
												<option value="9" <cfif attributes.report_type eq 9>selected</cfif>> <cf_get_lang dictionary_id='39095.Marka Bazinda'></option>
												<option value="10" <cfif attributes.report_type eq 10>selected</cfif>> <cf_get_lang dictionary_id='39259.Müşteri Degeri Bazinda'></option>
												<option value="11" <cfif attributes.report_type eq 11>selected</cfif>> <cf_get_lang dictionary_id='39352.Iliski Tipi Bazinda'></option>
												<option value="12" <cfif attributes.report_type eq 12>selected</cfif>> <cf_get_lang dictionary_id='39353.Mikro Bölge Bazinda'></option>
												<option value="13" <cfif attributes.report_type eq 13>selected</cfif>> <cf_get_lang dictionary_id='39262.Satis Bölgesi Bazinda'></option>
												<option value="14" <cfif attributes.report_type eq 14>selected</cfif>> <cf_get_lang dictionary_id='39355.Ödeme Yontemi Bazinda'></option>
												<option value="15" <cfif attributes.report_type eq 15>selected</cfif>> <cf_get_lang dictionary_id='39356.Hedef Pazar Bazinda'></option>
												<option value="16" <cfif attributes.report_type eq 16>selected</cfif>> <cf_get_lang dictionary_id='39475.Il Bazinda'></option>
												<option value="17" <cfif attributes.report_type eq 17>selected</cfif>><cf_get_lang dictionary_id='39685.Belge ve Stok Bazinda'></option>
												<option value="18" <cfif attributes.report_type eq 18>selected</cfif>><cf_get_lang dictionary_id='39689.Müşteri Temsilcisi ve Kategori Bazinda'></option>
												<option value="19" <cfif attributes.report_type eq 19>selected</cfif>><cf_get_lang dictionary_id ='40280.Fiyat Listesi Bazinda'></option>
												<option value="21" <cfif attributes.report_type eq 21>selected</cfif>><cf_get_lang dictionary_id ='40278.Satış Ortağı Bazında'></option>
												<option value="22" <cfif attributes.report_type eq 22>selected</cfif>><cf_get_lang dictionary_id='57660.Belge Bazında'></option>
												<option value="23" <cfif attributes.report_type eq 23>selected</cfif>><cf_get_lang dictionary_id='58225.Model Bazında'></option>
											</select>	
										</div>
									</div>
									<div class="form-group">
									    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57950.Grafik Format'></label>
									    <div class="col col-9 col-xs-12">
											<select name="graph_type" id="graph_type" style="width:90px;">
												<option value="" selected><cf_get_lang dictionary_id='57950.Grafik Format'></option>
												<option value="radar" <cfif attributes.graph_type eq 'radar'> selected</cfif>><cf_get_lang dictionary_id='60666.Radar'></option>
												<option value="pie"<cfif attributes.graph_type eq 'pie'> selected</cfif>><cf_get_lang dictionary_id='58728.Pasta'></option>
												<option value="bar"<cfif attributes.graph_type eq 'bar'> selected</cfif>><cf_get_lang dictionary_id='57663.Bar'></option>
											</select>
										</div>
									</div>	
									<div class="form-group">
									    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57756.Durum'></label>
									    <div class="col col-9 col-xs-12">
											<select name="status" id="status" style="width:60px;">
												<option value=""><cf_get_lang dictionary_id='57756.Durum'></option>
												<option value="0"<cfif attributes.status eq 0> selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
												<option value="1"<cfif attributes.status eq 1> selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
											</select>
										</div>
									</div>
									<div class="form-group">
									    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='39055.Rapor Sıra'></label>
									    <div class="col col-9 col-xs-12">
											<input type="hidden" name="kontrol" id="kontrol" value="0">
											<label><cf_get_lang dictionary_id='39361.Ciro ya Göre'><input type="radio" name="report_sort" id="report_sort" value="1"  <cfif attributes.report_sort eq 1 and attributes.kontrol eq 0>checked</cfif>></label>
											<label><cf_get_lang dictionary_id='39362.Miktar a Göre'><input type="radio" name="report_sort" id="report_sort" value="2"  <cfif attributes.report_sort eq 2 and attributes.kontrol eq 0>checked</cfif>></label>					
										</div>
									</div>	
									<div class="form-group">
									    <div class="col col-12 col-xs-12">
											<label id="model_month_td" <cfif isdefined("attributes.report_type") and attributes.report_type neq 23>style="display:none;"</cfif>><cf_get_lang dictionary_id='33509.Modelleri Satır Olarak Listele'><input type="checkbox" name="model_month" id="model_month" value="0" <cfif isdefined("attributes.model_month")>checked</cfif>/></label>
											<label><cf_get_lang dictionary_id='39743.Bedava Promosyonlar'><input name="is_prom" id="is_prom" value="1" type="checkbox" <cfif attributes.is_prom eq 1 >checked<cfelseif attributes.report_type eq 22>disabled</cfif>></label>
											<label><cf_get_lang dictionary_id='40610.Spec Göster'><input type="checkbox" name="is_spect_info" id="is_spect_info" value="1" <cfif isdefined("attributes.is_spect_info")>checked<cfelseif attributes.report_type neq 17>disabled</cfif>></label>	
											<label><cf_get_lang dictionary_id='39410.Islem Dovizli'><input name="is_other_money" id="is_other_money" value="1" type="checkbox" <cfif attributes.is_other_money eq 1 >checked<cfelseif attributes.report_type eq 7 or attributes.report_type eq 18>disabled</cfif>></label>
											<label><cf_get_lang dictionary_id='39647.Döviz Göster'><input type="checkbox" name="is_money_info" id="is_money_info" value="1" <cfif attributes.is_money_info eq 1>checked<cfelseif attributes.report_type neq 17>disabled</cfif>></label>
											<label><cf_get_lang dictionary_id='39368.Iskonto Göster'><input name="is_discount" id="is_discount" value="1" type="checkbox" <cfif attributes.is_discount eq 1>checked</cfif>></label>
											<label><cf_get_lang dictionary_id='39059.KDV Dahil'><input name="is_kdv" id="is_kdv" value="1" type="checkbox" <cfif attributes.is_kdv eq 1 >checked</cfif>></label>
											<label><cf_get_lang dictionary_id='39660.Iptaller Düssün'><input name="is_iptal" id="is_iptal" value="1" type="checkbox" <cfif attributes.is_iptal eq 1>checked<cfelseif attributes.report_type eq 22>disabled</cfif>></label>
											<label><cfif isdefined("session.ep.money2")><cf_get_lang dictionary_id='58596.Göster'><input name="is_money2" id="is_money2" value="1" type="checkbox" <cfif attributes.is_money2 eq 1 >checked</cfif>><cfoutput>#session.ep.money2#</cfoutput></cfif></label>
											<label><cf_get_lang dictionary_id='57416.Proje'> <cf_get_lang dictionary_id='58596.Göster'><input name="is_project" id="is_project" value="1" type="checkbox" <cfif attributes.is_project eq 1>checked<cfelseif attributes.report_type neq 17 and attributes.report_type neq 22>disabled</cfif>></label>
										</div>
									</div>	
                            	</div>
					    	</div>
						</div>	
						<div class="row ReportContentBorder">
							<div class="ReportContentFooter">
								<label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
								<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
									<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" message="#message#" maxlength="3" style="width:25px;">
								<cfelse>
									<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
								</cfif>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57911.Çalistir'></cfsavecontent>
								<cf_wrk_report_search_button search_function='kontrol_form()' button_type='1' insert_info='#message#'>
							</div>
						</div> 
					</div>
				</div>    
			</cfform>
        </cf_report_list_search_area>
	</cf_report_list_search>
 <cfif isdefined("attributes.form_submitted") and not (isdefined("attributes.is_excel") and attributes.is_excel eq 1)>
	 <cfsavecontent variable="title"><cf_get_lang dictionary_id='39675.Sipariş Aşaması'></cfsavecontent>
	 <cf_seperator title="#title#" id="order_phose">
	<div style="display:none;" id="order_phose">
	 <table class="color-border" width="99%" cellpadding="2" cellspacing="1">
		 <tr class="color-row">
			 <td valign="top" nowrap="nowrap">
				 <cfif listfind(attributes.order_stage,-7)><cf_get_lang dictionary_id='29748.Eksik Teslimat'><br /></cfif>
				 <cfif listfind(attributes.order_stage,-8)><cf_get_lang dictionary_id='29749.Fazla Teslimat'><br /></cfif>
				 <cfif listfind(attributes.order_stage,-6)><cf_get_lang dictionary_id='58761.Sevk'><br /></cfif>
				 <cfif listfind(attributes.order_stage,-5)><cf_get_lang dictionary_id='57456.Üretim'><br /></cfif>
				 <cfif listfind(attributes.order_stage,-4)><cf_get_lang dictionary_id='29747.Kismi Üretim'><br /></cfif>
				 <cfif listfind(attributes.order_stage,-3)><cf_get_lang dictionary_id='29746.Kapatildi'><br /></cfif>
				 <cfif listfind(attributes.order_stage,-2)><cf_get_lang dictionary_id='29745.Tedarik'><br /></cfif>
				 <cfif listfind(attributes.order_stage,-1)><cf_get_lang dictionary_id='58717.Açik'><br /></cfif>
				 <cfif listfind(attributes.order_stage,-9)><cf_get_lang dictionary_id='58506.Iptal'><br /></cfif>
				 <cfif listfind(attributes.order_stage,-10)><cf_get_lang dictionary_id='29746.Kapatildi'>(<cf_get_lang dictionary_id='58500.Manuel'>)<br /></cfif>
			 </td>
			 <td valign="top" width="30%">
				 <b><cf_get_lang dictionary_id='39695.Siparis Süreci'></b><br /><br />
				 <cfif len(attributes.order_process_cat)>
					<cfquery name="get_process_type_selected" dbtype="query">
						SELECT * FROM GET_PROCESS_TYPE WHERE PROCESS_ROW_ID IN (#attributes.order_process_cat#)
					</cfquery>
					<cfif get_process_type_selected.recordcount>
						<cfoutput query="get_process_type_selected">
							#stage#<br />
						</cfoutput>
					</cfif>
				<cfelse>
					<cfoutput query="get_process_type">
						#stage#<br />
					</cfoutput>
				 </cfif>
			 </td>
			 <td valign="top" width="30%"><cf_get_lang dictionary_id='58960.Rapor Tipi'>:
				 <cfif attributes.report_type eq 1><cf_get_lang dictionary_id='39052.Kategori Bazinda'>
				 <cfelseif attributes.report_type eq 2><cf_get_lang dictionary_id='39053.Ürün Bazinda'>
				 <cfelseif attributes.report_type eq 3><cf_get_lang dictionary_id='39054.Stok Bazinda'>
				 <cfelseif attributes.report_type eq 4><cf_get_lang dictionary_id='39257.Müsteri Bazinda'>
				 <cfelseif attributes.report_type eq 5><cf_get_lang dictionary_id='39348.Müsteri Tipi Bazinda'>
				 <cfelseif attributes.report_type eq 24><cf_get_lang dictionary_id='57457.Müşteri'> <cf_get_lang dictionary_id='57989.ve'> <cf_get_lang dictionary_id='39052.Kategori Bazinda'>
				 <cfelseif attributes.report_type eq 6><cf_get_lang dictionary_id='39349.Tedarikçi Bazinda'>
				 <cfelseif attributes.report_type eq 7><cf_get_lang dictionary_id='39688.Sube Ve Kategori Bazinda'>
				 <cfelseif attributes.report_type eq 8><cf_get_lang dictionary_id='39351.Satis Yapan Bazinda'>
				 <cfelseif attributes.report_type eq 9><cf_get_lang dictionary_id='39095.Marka Bazinda'>
				 <cfelseif attributes.report_type eq 10><cf_get_lang dictionary_id='39259.Müsteri Degeri Bazinda'>
				 <cfelseif attributes.report_type eq 11><cf_get_lang dictionary_id='39352.Iliski Tipi Bazinda'>
				 <cfelseif attributes.report_type eq 12><cf_get_lang dictionary_id='39353.Mikro Bölge Bazinda'>
				 <cfelseif attributes.report_type eq 13><cf_get_lang dictionary_id='39262.Satis Bölgesi Bazinda'>
				 <cfelseif attributes.report_type eq 14><cf_get_lang dictionary_id='39374.Ödeme Yöntemi Bazinda'>
				 <cfelseif attributes.report_type eq 15><cf_get_lang dictionary_id='39356.Hedef Pazar Bazinda'>
				 <cfelseif attributes.report_type eq 16><cf_get_lang dictionary_id='39475.Il Bazinda'>
				 <cfelseif attributes.report_type eq 17><cf_get_lang dictionary_id='39685.Belge ve Stok Bazinda'>
				 <cfelseif attributes.report_type eq 18><cf_get_lang dictionary_id='39689.Müsteri Temsilcisi ve Kategori Bazinda'>
				 <cfelseif attributes.report_type eq 19><cf_get_lang dictionary_id='40280.Fiyat Listesi Bazinda'>
				 <cfelseif attributes.report_type eq 20><cf_get_lang dictionary_id='40556.Ana Kategori'> <cf_get_lang dictionary_id='58601.Bazinda'>
				 <cfelseif attributes.report_type eq 21><cf_get_lang dictionary_id='40278.Satış Ortağı Bazında'>
				 <cfelseif attributes.report_type eq 22><cf_get_lang dictionary_id='57660.Belge Bazında'>
				 </cfif>
				 <cfif attributes.is_kdv eq 1><cf_get_lang dictionary_id='39059.KDV Dahil'></cfif><hr>
				 <cf_get_lang dictionary_id='57486.Kategori'>:<cfoutput>#attributes.product_cat#</cfoutput><hr>
				 <cf_get_lang dictionary_id='57457.Müsteri'>:<cfoutput>#attributes.company#</cfoutput><hr>
				 <cf_get_lang dictionary_id='58795.Müsteri Temsilcisi'>:<cfoutput>#attributes.pos_code_text#</cfoutput>
			 </td>
			 <cfoutput>
				 <td valign="top" width="30%">
					 <cf_get_lang dictionary_id='57742.Tarih'>:#attributes.date1#-#attributes.date2#<hr>
					 <cf_get_lang dictionary_id='57657.ürün'>:#attributes.product_name#<hr>
					 <a title="#attributes.brand_name#"><cf_get_lang dictionary_id='58847.Marka'>:#left(attributes.brand_name,50)#<hr></a>
					 <cf_get_lang dictionary_id='58448.ürün Sorumlusu'>:#attributes.employee_name#
				 </td>
				 <td valign="top" width="40%">
					 <cf_get_lang dictionary_id='39055.Rapor Sira'>:<cfif attributes.report_sort eq 1><cf_get_lang dictionary_id='30010.Ciro'><cfelse><cf_get_lang dictionary_id='57635.Miktar'></cfif><hr>
					 <cf_get_lang dictionary_id='29533.Tedarikçi'>:#attributes.sup_company#<hr>
					 <cf_get_lang dictionary_id='39364.Satisi Yapan'>:#attributes.employee#<hr>
					 <cf_get_lang dictionary_id='39370.Hedef Pazar'>:
					 <cfif len(attributes.segment_id) and listfind(list_segment_ids,attributes.segment_id,',')>
						 #GET_SEGMENTS_2.PRODUCT_SEGMENT[listfind(list_segment_ids,attributes.segment_id,',')]#
					 </cfif>
				 </td>
			 </cfoutput>
		 </tr>
	 </table>	
	</div>
 </cfif>
 <cfquery name="get_product_units" datasource="#dsn#">
	 SELECT * FROM SETUP_UNIT
 </cfquery>
 <cfoutput query="get_product_units">
	 <cfset unit_ = filterSpecialChars(get_product_units.unit)>
	 <cfset 'toplam_#unit_#' = 0>
	 <cfset 'toplam_ikinci_#unit_#' = 0>
	 <cfset 'toplam_giden_#unit_#' = 0>
	 <cfset 'toplam_kalan_#unit_#' = 0>
 </cfoutput>
 <cfoutput query="get_money">
	 <cfset "toplam_#money#" = 0>
	 <cfset "toplam_tutar#money#" = 0>
	 <cfset "toplam_kalan_tutar#money#" = 0>
	 <cfset "toplam_net_doviz_#money#" = 0>
 </cfoutput>
 <div id="order-list">
 <cfif isdefined("attributes.form_submitted")>

	 <!--- Excel TableToExcel.convert fonksiyonu ile alındığı için kapatıldı. --->
	 <!--- <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
		 <cfset filename = "#createuuid()#">
		 <cfheader name="Expires" value="#Now()#">
		 <cfcontent type="application/msexcel;charset=utf-16">
		 <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
		 <meta http-equiv="Content-Type" content="text/html; charset=utf-16">
	 </cfif> --->

		 <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
			 <cfsavecontent variable="title"><cf_get_lang dictionary_id='39675.Sipariş Aşaması'></cfsavecontent>
			 <cf_seperator title="#title#" id="order_phose">
			 <table class="color-border" width="99%" cellpadding="2" cellspacing="1" style="display:none;" id="order_phose">
				 <tr class="color-row">
					 <td valign="top" nowrap="nowrap">
							 <cfif listfind(attributes.order_stage,-7)><cf_get_lang dictionary_id='29748.Eksik Teslimat'><br /></cfif>
							 <cfif listfind(attributes.order_stage,-8)><cf_get_lang dictionary_id='29749.Fazla Teslimat'><br /></cfif>
							 <cfif listfind(attributes.order_stage,-6)><cf_get_lang dictionary_id='58761.Sevk'><br /></cfif>
							 <cfif listfind(attributes.order_stage,-5)><cf_get_lang dictionary_id='57456.Üretim'><br /></cfif>
							 <cfif listfind(attributes.order_stage,-4)><cf_get_lang dictionary_id='29747.Kismi Üretim'><br /></cfif>
							 <cfif listfind(attributes.order_stage,-3)><cf_get_lang dictionary_id='29746.Kapatildi'><br /></cfif>
							 <cfif listfind(attributes.order_stage,-2)><cf_get_lang dictionary_id='29745.Tedarik'><br /></cfif>
							 <cfif listfind(attributes.order_stage,-1)><cf_get_lang dictionary_id='58717.Açik'><br /></cfif>
							 <cfif listfind(attributes.order_stage,-9)><cf_get_lang dictionary_id='58506.Iptal'><br /></cfif>
							 <cfif listfind(attributes.order_stage,-10)><cf_get_lang dictionary_id='29746.Kapatildi'>(<cf_get_lang dictionary_id='58500.Manuel'>)<br /></cfif>
					 </td>
					 <td valign="top" width="30%">
						 <b><cf_get_lang dictionary_id='39695.Siparis Süreci'></b><br /><br />
						 <cfif len(attributes.order_process_cat)>
						 <cfquery name="get_process_type_selected" dbtype="query">
							 SELECT * FROM GET_PROCESS_TYPE WHERE PROCESS_ROW_ID IN (#attributes.order_process_cat#)
						 </cfquery>
						 <cfif get_process_type_selected.recordcount>
						 <cfoutput query="get_process_type">
							 #stage#<br />
						 </cfoutput>
						 </cfif>
						 </cfif>
					 </td>
					 <td valign="top" width="30%"><cf_get_lang dictionary_id='58960.Rapor Tipi'>:
						 <cfif attributes.report_type eq 1><cf_get_lang dictionary_id='39052.Kategori Bazinda'>
						 <cfelseif attributes.report_type eq 2><cf_get_lang dictionary_id='39053.Ürün Bazinda'>
						 <cfelseif attributes.report_type eq 3><cf_get_lang dictionary_id='39054.Stok Bazinda'>
						 <cfelseif attributes.report_type eq 4><cf_get_lang dictionary_id='39257.Müsteri Bazinda'>
						 <cfelseif attributes.report_type eq 5><cf_get_lang dictionary_id='39348.Müsteri Tipi Bazinda'>
						 <cfelseif attributes.report_type eq 24><cf_get_lang dictionary_id='57457.Müşteri'> <cf_get_lang dictionary_id='57989.ve'> <cf_get_lang dictionary_id='39052.Kategori Bazinda'>
						 <cfelseif attributes.report_type eq 6><cf_get_lang dictionary_id='39349.Tedarikçi Bazinda'>
						 <cfelseif attributes.report_type eq 7><cf_get_lang dictionary_id ='39688.Sube Ve Kategori Bazinda'>
						 <cfelseif attributes.report_type eq 8><cf_get_lang dictionary_id='39351.Satis Yapan Bazinda'>
						 <cfelseif attributes.report_type eq 9><cf_get_lang dictionary_id='39095.Marka Bazinda'>
						 <cfelseif attributes.report_type eq 10><cf_get_lang dictionary_id='39259.Müsteri Degeri Bazinda'>
						 <cfelseif attributes.report_type eq 11><cf_get_lang dictionary_id='39352.Iliski Tipi Bazinda'>
						 <cfelseif attributes.report_type eq 12><cf_get_lang dictionary_id='39353.Mikro Bölge Bazinda'>
						 <cfelseif attributes.report_type eq 13><cf_get_lang dictionary_id='39262.Satis Bölgesi Bazinda'>
						 <cfelseif attributes.report_type eq 14><cf_get_lang dictionary_id='39374.Ödeme Yöntemi Bazinda'>
						 <cfelseif attributes.report_type eq 15><cf_get_lang dictionary_id='39356.Hedef Pazar Bazinda'>
						 <cfelseif attributes.report_type eq 16><cf_get_lang dictionary_id='39475.Il Bazinda'>
						 <cfelseif attributes.report_type eq 17><cf_get_lang dictionary_id='39685.Belge ve Stok Bazinda'>
						 <cfelseif attributes.report_type eq 18><cf_get_lang dictionary_id='39689.Müsteri Temsilcisi ve Kategori Bazinda'>
						 <cfelseif attributes.report_type eq 19><cf_get_lang dictionary_id='40280.Fiyat Listesi Bazinda'>
						 <cfelseif attributes.report_type eq 20><cf_get_lang dictionary_id='40556.Ana Kategori'><cf_get_lang dictionary_id='58601.Bazinda'>
						 <cfelseif attributes.report_type eq 21><cf_get_lang dictionary_id='40278.Satış Ortağı Bazında'>
						 <cfelseif attributes.report_type eq 22><cf_get_lang dictionary_id='57660.Belge Bazında'>
						 </cfif>
						 <cfif attributes.is_kdv eq 1><cf_get_lang dictionary_id='39059.KDV Dahil'></cfif><hr>
						 <cf_get_lang dictionary_id='57486.Kategori'>:<cfoutput>#attributes.product_cat#</cfoutput><hr>
						 <cf_get_lang dictionary_id='57457.Müsteri'>:<cfoutput>#attributes.company#</cfoutput><hr>
						 <cf_get_lang dictionary_id='58795.Müsteri Temsilcisi'>:<cfoutput>#attributes.pos_code_text#</cfoutput>
					 </td>
					 <cfoutput>
						 <td valign="top" width="30%">
							 <cf_get_lang dictionary_id='57742.Tarih'>:#attributes.date1#-#attributes.date2#<hr>
							 <cf_get_lang dictionary_id='57657.ürün'>:#attributes.product_name#<hr>
							 <a title="#attributes.brand_name#"><cf_get_lang dictionary_id='58847.Marka'>:#left(attributes.brand_name,50)#<hr></a>
							 <cf_get_lang dictionary_id='58448.ürün Sorumlusu'>:#attributes.employee_name#
						 </td>
						 <td valign="top" width="40%">
							 <cf_get_lang dictionary_id='39055.Rapor Sira'>:<cfif attributes.report_sort eq 1><cf_get_lang dictionary_id='30010.Ciro'><cfelse><cf_get_lang dictionary_id='57635.Miktar'></cfif><hr>
							 <cf_get_lang dictionary_id='29533.Tedarikçi'>:#attributes.sup_company#<hr>
							 <cf_get_lang dictionary_id='39364.Satisi Yapan'>:#attributes.employee#<hr>
							 <cf_get_lang dictionary_id='39370.Hedef Pazar'>:
							 <cfif len(attributes.segment_id) and listfind(list_segment_ids,attributes.segment_id,',')>
								 #GET_SEGMENTS_2.PRODUCT_SEGMENT[listfind(list_segment_ids,attributes.segment_id,',')]#
							 </cfif>
						 </td>
					 </cfoutput>
				 </tr>
			 </table>	
		 </cfif>
		<cf_report_list>
			 <cfset price_cat_list = ''>
			 <cfset sales_partner_list = "">
			 <cfset sales_consumer_list = "">
			 <cfset brand_id_list=''>
			 <cfset short_code_id_list=''>
			 <cfif get_total_purchase.recordcount and attributes.report_type eq 19>
				 <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					 <cfif len(price_cat) and not listfind(price_cat_list,price_cat)>
						 <cfset price_cat_list = listappend(price_cat_list,price_cat)>
					 </cfif>	
				 </cfoutput>
			 <cfelseif get_total_purchase.recordcount and attributes.report_type eq 21>
				 <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					 <cfif len(sales_member_id) and sales_member_type eq 1 and not listfind(sales_partner_list,sales_member_id)>
						 <cfset sales_partner_list = listappend(sales_partner_list,sales_member_id)>
					 </cfif>	
					 <cfif len(sales_member_id) and sales_member_type eq 2 and not listfind(sales_consumer_list,sales_member_id)>
						 <cfset sales_consumer_list = listappend(sales_consumer_list,sales_member_id)>
					 </cfif>		
				 </cfoutput>
			 </cfif>
			 <cfif attributes.report_type eq 19>
				 <cfif len(price_cat_list)>
					 <cfset price_cat_list=listsort(price_cat_list,"numeric","ASC",",")>
					 <cfquery name="get_price_cat" datasource="#DSN3#">
						 SELECT PRICE_CAT, PRICE_CATID FROM PRICE_CAT WHERE PRICE_CATID IN (#price_cat_list#) ORDER BY PRICE_CATID
					 </cfquery>
					 <cfset price_cat_list = listsort(listdeleteduplicates(valuelist(get_price_cat.price_catid,',')),'numeric','ASC',',')>
				 </cfif>
			 <cfelseif attributes.report_type eq 21>
				 <cfif len(sales_partner_list)>
					 <cfset sales_partner_list=listsort(sales_partner_list,"numeric","ASC",",")>
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
							 CP.PARTNER_ID IN (#sales_partner_list#)
						 ORDER BY
							 CP.PARTNER_ID
					 </cfquery>
					 <cfset sales_partner_list = listsort(listdeleteduplicates(valuelist(get_partner_name.partner_id,',')),'numeric','ASC',',')>
				 </cfif> 
				 <cfif len(sales_consumer_list)>
					 <cfset sales_consumer_list=listsort(sales_consumer_list,"numeric","ASC",",")>
					 <cfquery name="get_consumer_name" datasource="#DSN#">
						 SELECT CONSUMER_NAME,CONSUMER_SURNAME,CONSUMER_ID FROM CONSUMER WHERE CONSUMER_ID IN (#sales_consumer_list#) ORDER BY CONSUMER_ID
					 </cfquery>
					 <cfset sales_consumer_list = listsort(listdeleteduplicates(valuelist(get_consumer_name.consumer_id,',')),'numeric','ASC',',')>
				 </cfif>	
			 </cfif>
			 <cfif get_total_purchase.recordcount and listfind('2,3,17',attributes.report_type)>
				   <cfoutput query="get_total_purchase">
					 <cfif len(brand_id) and not listfind(brand_id_list,brand_id)>
						 <cfset brand_id_list=listappend(brand_id_list,brand_id)>
					 </cfif>
					 <cfif len(short_code_id) and not listfind(short_code_id_list,short_code_id)>
						 <cfset short_code_id_list=listappend(short_code_id_list,short_code_id)>
					 </cfif>
				 </cfoutput>
				  <cfif len(brand_id_list)>
					 <cfset brand_id_list=listsort(brand_id_list,"numeric","ASC",",")>
					 <cfquery name="get_brand" datasource="#DSN1#">
						 SELECT BRAND_ID,BRAND_NAME FROM PRODUCT_BRANDS WHERE BRAND_ID IN (#brand_id_list#) ORDER BY BRAND_ID
					 </cfquery>
					 <cfset brand_id_list = listsort(listdeleteduplicates(valuelist(get_brand.BRAND_ID,',')),"numeric","ASC",",")>
				 </cfif>
				 <cfif len(short_code_id_list)>
					 <cfset short_code_id_list=listsort(short_code_id_list,"numeric","ASC",",")>
					 <cfquery name="get_model" datasource="#DSN1#">
						 SELECT MODEL_NAME,MODEL_ID FROM PRODUCT_BRANDS_MODEL WHERE MODEL_ID IN (#short_code_id_list#) ORDER BY MODEL_ID
					 </cfquery>
					 <cfset short_code_id_list = listsort(listdeleteduplicates(valuelist(get_model.MODEL_ID,',')),"numeric","ASC",",")>
				 </cfif>
			 </cfif>
			 <cfif get_total_purchase.recordcount and (attributes.report_type eq 1 or attributes.report_type eq 20 or attributes.report_type eq 24)>
				 <thead>
					 <tr>
					 <cfif attributes.report_type eq 24>
						 <th><cf_get_lang dictionary_id='57457.Müşteri'></th>
						 </cfif>
						 <th><cf_get_lang dictionary_id='39378.Kategori Kod'></th>
						 <th height="22"><cf_get_lang dictionary_id='57486.Kategori'></th>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></th>
						 <th width="100" style="text-align:right;">2.<cf_get_lang dictionary_id='57635.Miktar'></th>
						 <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39401.Brüt Doviz'></th>
							 <th style="text-align:center;" width="50"><cf_get_lang dictionary_id='58474.Birim'></th>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='57677.Doviz'></th>
							 <th style="text-align:center;" width="50"><cf_get_lang dictionary_id='58474.Birim'></th>
							 <cfif attributes.is_discount eq 1>
								 <th width="75"  style="text-align:right;"><cf_get_lang dictionary_id='39403.Isk Doviz'></th>
								 <th style="text-align:center;" width="50"><cf_get_lang dictionary_id='58474.Birim'></th>
							 </cfif>
						 </cfif>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='39381.Brüt Tutar'></th>
						 <th style="text-align:center;" width="50"><cf_get_lang dictionary_id='58474.Birim'></th>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
						 <th style="text-align:center;" width="50"><cf_get_lang dictionary_id='58474.Birim'></th>
						 <cfif attributes.is_discount eq 1>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39382.Isk Tutar'></th>
							 <th style="text-align:center;" width="50"><cf_get_lang dictionary_id='58474.Birim'></th>
						 </cfif>
						 <th style="text-align:right;">%</th>
					 </tr>
				 </thead>
				 <tbody>
					 <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						 <tr>
						 <cfif attributes.report_type eq 24>
							 <td>
										<cfif MEMBER_TYPE eq 1><!--- kurumsallar icin --->
										 <a href="javascript://"  class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#musteri_id#','list')"></a>
									 <cfelse>
										 <a href="javascript://"  class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#musteri_id#','list')"></a>
									 </cfif>
									 #MUSTERI#
							 </td>
							 </cfif>
							 <td>#HIERARCHY#</td>
							 <td>#PRODUCT_CAT#</td>
							 <td style="text-align:right;mso-number-format:0\.00;">#TLFormat(PRODUCT_STOCK,4)#
								 <cfif len(PRODUCT_STOCK)>
									 <cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar>
								 </cfif>
							 </td>
							 <td style="text-align:right;mso-number-format:0\.00;">
								 <cfif len(MULTIPLIER_AMOUNT)>
									 <cfset toplam_multiplier = toplam_multiplier + PRODUCT_STOCK/MULTIPLIER_AMOUNT>
									 #TLFormat(PRODUCT_STOCK/MULTIPLIER_AMOUNT,4)#
								 </cfif>
							 </td>
							 <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
								 <td style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ)# </td>
								 <td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
								 <td style="text-align:right;">#TLFormat(PRICE_DOVIZ)# </td>
								 <td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
								 <cfif attributes.is_discount eq 1>
									 <td style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ-PRICE_DOVIZ)# </td>
									 <td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
								 </cfif>
							 </cfif>
							 <td style="text-align:right;">#TLFormat(GROSSTOTAL)#<cfset total_grosstotal=GROSSTOTAL+total_grosstotal></td>
							 <td style="text-align:center;">#SESSION.EP.MONEY#</td>
							 <td style="text-align:right;">#TLFormat(PRICE)#<cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif></td>
							 <td style="text-align:center;">#SESSION.EP.MONEY#</td>
							 <cfif attributes.is_discount eq 1>
								 <td style="text-align:right;"><cfif Len(PRICE)>#TLFormat(DISCOUNT)# <cfset toplam_discount=DISCOUNT+toplam_discount> <cfelse>#TLFormat(GROSSTOTAL)# <cfset toplam_discount=GROSSTOTAL+toplam_discount></cfif></td>
								 <td style="text-align:center;">#SESSION.EP.MONEY#</td>
							 </cfif>
							 <td style="text-align:right;mso-number-format:0\.00;"><cfif len(price) and butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
						 </tr>
					 </cfoutput>
				 </tbody>
			 <cfelseif get_total_purchase.recordcount and listfind('2,3',attributes.report_type,',')>
				 <thead>
					 <tr>
						 <th><cf_get_lang dictionary_id='39378.Kategori Kod'></th>
						 <th><cf_get_lang dictionary_id='57486.Kategori'></th>
						 <cfif is_brand_show eq 1><th><cf_get_lang dictionary_id='58847.Marka'></th></cfif>
						 <cfif is_short_code_show eq 1><th><cf_get_lang dictionary_id='58225.Model'></th></cfif>
						 <cfif (attributes.report_type eq 3 or attributes.report_type eq 2) and isdefined("x_show_special_code") and x_show_special_code eq 1><th><cf_get_lang dictionary_id='57789.Özel Kod'></th></cfif>
						 <th><cf_get_lang dictionary_id='58800.ürün Kod'></th>
						 <th><cf_get_lang dictionary_id='57633.Barkod'></th>
						 <th><cf_get_lang dictionary_id='57657.ürün'> </th>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></th>
						 <cfif x_unit_weight eq 1>
							 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='29784.Ağırlık'></th>
						 </cfif>
						 <th style="text-align:center;"><cf_get_lang dictionary_id='57636.Birim'></th>
						 <cfif x_show_second_unit eq 1 and listfind('2,3',attributes.report_type)>
							 <th width="100" style="text-align:right;">2.<cf_get_lang dictionary_id='60368.Birim Miktar'></th>
							 <th style="text-align:center;">2. <cf_get_lang dictionary_id='57636.Birim'></th>
						 </cfif>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='40288.Teslim Edilen'></th>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='58444.Kalan'></th>
						 <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39401.Brüt Doviz'></th>
							 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='57677.Doviz'></th>
							 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
							 <cfif attributes.is_discount eq 1>
								 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39403.Isk Doviz'></th>
								 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
							 </cfif>
						 </cfif>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='39381.Brüt Tutar'></th>
						 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
						 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id ='40687.Kalan Tutar'></th>
						 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 <cfif attributes.is_discount eq 1>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39382.Isk Tutar'></th>
							 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 </cfif>
						 <th style="text-align:right;">%</th>
					 </tr>
				 </thead>
				 <tbody>
					 <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						 <tr>
							 <td>#HIERARCHY#</td>
							 <td>#PRODUCT_CAT#</td>
							 <cfif is_brand_show eq 1><td><cfif len(brand_id)>#get_brand.BRAND_NAME[listfind(brand_id_list,brand_id,',')]#</cfif></td></cfif>
							 <cfif is_short_code_show eq 1><td><cfif len(short_code_id)>#get_model.MODEL_NAME[listfind(short_code_id_list,short_code_id,',')]#</cfif></td></cfif>
							 <cfif isdefined("x_show_special_code") and x_show_special_code eq 1>
								 <cfif attributes.report_type eq 3>
									 <td>#STOCK_CODE_2#</td>
								 <cfelseif attributes.report_type eq 2>
									 <td>#PRODUCT_CODE_2#</td>
								 </cfif>
							 </cfif>
							 <cfif attributes.report_type eq 2>
								 <td>#PRODUCT_CODE#</td>
								 <td>#BARCOD#</td>
								 <td><a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#PRODUCT_ID#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','list');">#PRODUCT_NAME#</a></td>
							 <cfelseif attributes.report_type eq 3>
								 <td>#STOCK_CODE#</td>
								 <td>#BARCOD#</td>
								 <td><a href="#request.self#?fuseaction=stock.list_stock&event=det&pid=#PRODUCT_ID#" class="tableyazi">#PRODUCT_NAME# #PROPERTY#</a></td>
							 </cfif>
							 <td style="text-align:right;mso-number-format:'\@'">#TLFormat(PRODUCT_STOCK,4)# 
								 <cfif len(PRODUCT_STOCK)>
									 <cfset unit_ = filterSpecialChars(birim)>
									 <cfset 'toplam_#unit_#' = evaluate('toplam_#unit_#') +PRODUCT_STOCK>	
								 </cfif>
							 </td>
							 <cfif x_unit_weight eq 1>
								 <td style="text-align:center;" style="text-align:right;mso-number-format:'\@'">
									 <cfif len(PRODUCT_STOCK) and len(UNIT_WEIGHT)>
										 <cfset toplam_unit_weıght = toplam_unit_weıght + PRODUCT_STOCK*UNIT_WEIGHT>
										 #TLFormat(PRODUCT_STOCK*UNIT_WEIGHT,4)#
									 </cfif>
								 </td>
							 </cfif>
							 <td style="text-align:center;">#BIRIM#</td>
							 <cfif x_show_second_unit eq 1 and listfind('2,3',attributes.report_type)>
								 <td style="text-align:right;">
										 <cfif len(product_stock) and len(multiplier)>
											 <cfset toplam_ikinci_miktar = toplam_ikinci_miktar + product_stock/wrk_round(multiplier,8,1)>
											 #TLFormat(product_stock/wrk_round(multiplier,8,1))#
											 <cfset unit2_ = filterspecialchars(unit2)> 
											 <cfset 'toplam_ikinci_#unit2_#' = evaluate('toplam_ikinci_#unit2_#') + product_stock/wrk_round(multiplier,8,1)>
										 </cfif>
								 </td>
								 <td style="text-align:center;">
									 <cfset unit2_list = listappend(unit2_list,UNIT2)>
									 #UNIT2#
								 </td>
							 </cfif>
							 <cfif attributes.is_other_money eq 1>
								 <cfset net_fiyat_=OTHER_MONEY_VALUE/PRODUCT_STOCK>
							 <cfelseif len(ROW_LASTTOTAL)>
								 <cfset net_fiyat_=ROW_LASTTOTAL/PRODUCT_STOCK>
							 <cfelse>
								 <cfset net_fiyat_ = 0>
							 </cfif> 
							 <td style="text-align:right;">#TLFormat(deliver_amount)#</td>
							 <td style="text-align:right;">
								 <cfset remain_amount = product_stock-deliver_amount>
								 <cfif x_show_remains_as_zero eq 1 and remain_amount lt 0>
									 <cfset remain_amount = 0>
								 </cfif> 
								 #TLFormat(remain_amount)#
							 </td>
							 <cfset 'toplam_giden_#unit_#' = evaluate('toplam_giden_#unit_#') + deliver_amount>	
							 <cfset 'toplam_kalan_#unit_#' = evaluate('toplam_kalan_#unit_#') + (product_stock - (deliver_amount))>	
							 <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
								 <td style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ)# </td>
								 <td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
								 <td style="text-align:right;">#TLFormat(PRICE_DOVIZ)# </td>
								 <td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
								 <cfif attributes.is_discount eq 1>
									 <td style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ-PRICE_DOVIZ)# </td>
									 <td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
								 </cfif>
							 </cfif>
							 <td style="text-align:right;">#TLFormat(GROSSTOTAL)# <cfset total_grosstotal=GROSSTOTAL+total_grosstotal></td>
							 <td style="text-align:center;">#SESSION.EP.MONEY#</td>
							 <td style="text-align:right;">#TLFormat(PRICE)# <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif></td>
							 <td style="text-align:center;">#SESSION.EP.MONEY#</td>
							 <td style="text-align:right;">
								 <cfset remain = product_stock-deliver_amount>
								 <cfif x_show_remains_as_zero eq 1 and remain lt 0>
									 <cfset remain = 0>
								 </cfif>
								 <cfif len(ROW_LASTTOTAL) and ROW_LASTTOTAL neq 0>
									 #TLFormat(ROW_LASTTOTAL)#
									 <cfset toplam_kalan_tutar=toplam_kalan_tutar+(ROW_LASTTOTAL)>
								 <cfelseif remain neq 0>
									<cfset toplam_kalan_tutar=toplam_kalan_tutar+(price)>
									 #TLFormat(price)#
								 <cfelse>
									#TLFormat(0)#
								 </cfif>
							 </td>
							 <td style="text-align:center;">#SESSION.EP.MONEY#</td>
							 <cfif attributes.is_discount eq 1>
								 <td style="text-align:right;">#TLFormat(DISCOUNT)# <cfset toplam_discount=DISCOUNT+toplam_discount></td>
								 <td style="text-align:center;">#SESSION.EP.MONEY#</td>
							 </cfif>
							 <td style="text-align:right;"><cfif len(price) and butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
						 </tr>
					 </cfoutput>
				 </tbody>
			 <cfelseif get_total_purchase.recordcount and listfind('4,6,21',attributes.report_type)>
				 <thead>
					 <tr>
						 <th><cfif attributes.report_type eq 21><cf_get_lang dictionary_id ='39223.Satış Ortağı'><cfelse><cf_get_lang dictionary_id='58607.Firma'></cfif></th>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></th>
						 <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39401.Brüt Doviz'></th>
							 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='57677.Doviz'></th>
							 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
							 <cfif attributes.is_discount eq 1>
								 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39403.Isk Doviz'></th>
								 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
							 </cfif>
						 </cfif>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='39381.Brüt Tutar'></th>
						 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
						 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 <cfif attributes.is_discount eq 1>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39382.Isk Tutar'></th>
							 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 </cfif>
						 <th style="text-align:right;">%</th>
					 </tr>
				 </thead>
				 <tbody>
					 <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						 <tr>
							 <td>
								 <cfif attributes.report_type eq 4 or attributes.report_type eq 24>
									 <cfif MEMBER_TYPE eq 1><!--- kurumsallar icin --->
										 <a href="javascript://"  class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#musteri_id#','list')"></a>
									 <cfelse>
										 <a href="javascript://"  class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#musteri_id#','list')"></a>
									 </cfif>
									 #MUSTERI#
								 <cfelseif attributes.report_type eq 21>
									 <cfif len(sales_member_id) and sales_member_type eq 1 and len(sales_partner_list)>
										 <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#sales_member_id#','medium');" class="tableyazi"> 
											 #get_partner_name.company_partner_name[listfind(sales_partner_list,sales_member_id,',')]# #get_partner_name.company_partner_surname[listfind(sales_partner_list,sales_member_id,',')]#
										 </a> - 
										 <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_partner_name.company_id[listfind(sales_partner_list,sales_member_id,',')]#','medium');" class="tableyazi"> 
											 #get_partner_name.nickname[listfind(sales_partner_list,sales_member_id,',')]#
										 </a>
									 <cfelseif len(sales_member_id) and sales_member_type eq 2 and len(sales_consumer_list)>
										 <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#sales_member_id#','medium','popup_con_det');">
											 #get_consumer_name.consumer_name[listfind(sales_consumer_list,sales_member_id,',')]# #get_consumer_name.consumer_surname[listfind(sales_consumer_list,sales_member_id,',')]#
										 </a>
									 </cfif>
								 <cfelse>
									 <a href="javascript://"  class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#company_id#','list')">
										 #NICKNAME#
									 </a>
								 </cfif>
							 </td>
							 <td style="text-align:right;">#TLFormat(PRODUCT_STOCK,4)#
							 <cfif len(PRODUCT_STOCK)>
								 <cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar>
							 </cfif>
							 </td>
							 <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
								 <td style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ)# </td>
								 <td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
								 <td style="text-align:right;">#TLFormat(PRICE_DOVIZ)# </td>
								 <td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
								 <cfif attributes.is_discount eq 1>
									 <td style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ-PRICE_DOVIZ)# </td>
									 <td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
								 </cfif>
							 </cfif>
							 <td style="text-align:right;">#TLFormat(GROSSTOTAL)#<cfset total_grosstotal=GROSSTOTAL+total_grosstotal></td>
							 <td style="text-align:center;">#SESSION.EP.MONEY#</td>
							 <td style="text-align:right;">#TLFormat(PRICE)# <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif></td>
							 <td style="text-align:center;">#SESSION.EP.MONEY#</td>
							 <cfif attributes.is_discount eq 1>
								 <td style="text-align:right;">#TLFormat(DISCOUNT)#<cfset toplam_discount=DISCOUNT+toplam_discount></td>
								 <td style="text-align:center;">#SESSION.EP.MONEY#</td>
							 </cfif>
							 <td style="text-align:right;"><cfif len(price) and butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
						 </tr>
					 </cfoutput>
				 </tbody>
			 <cfelseif get_total_purchase.recordcount and attributes.report_type eq 5>
				 <thead>
					 <tr>
						 <th><cf_get_lang dictionary_id='39404.Müsteri Tipi'></th>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></th>
						 <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39401.Brüt Doviz'></th>
							 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='57677.Doviz'></th>
							 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
							 <cfif attributes.is_discount eq 1>
								 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39403.Isk Doviz'></th>
								 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
							 </cfif>
						 </cfif>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='39381.Brüt Tutar'></th>
						 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
						 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 <cfif attributes.is_discount eq 1>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39382.Isk Tutar'></th>
							 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 </cfif>
						 <th style="text-align:right;">%</th>
					 </tr>
				 </thead>
				 <tbody>
					 <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						 <tr>
							 <td>#MUSTERI_TYPE#</td>
							 <td style="text-align:right;">#TLFormat(PRODUCT_STOCK,4)#
							 <cfif len(PRODUCT_STOCK)>
								 <cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar>
							 </cfif>
							 </td>
							 <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
								 <td style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ)# </td>
								 <td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
								 <td style="text-align:right;">#TLFormat(PRICE_DOVIZ)# </td>
								 <td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
								 <cfif attributes.is_discount eq 1>
									 <td style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ-PRICE_DOVIZ)# </td>
									 <td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
								 </cfif>
							 </cfif>
							 <td style="text-align:right;">#TLFormat(GROSSTOTAL)# <cfset total_grosstotal=GROSSTOTAL+total_grosstotal> </td>
							 <td style="text-align:center;">#SESSION.EP.MONEY#</td>
							 <td style="text-align:right;">#TLFormat(PRICE)# <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif></td>
							 <td style="text-align:center;">#SESSION.EP.MONEY#</td>
							 <cfif attributes.is_discount eq 1>
								 <td style="text-align:right;">#TLFormat(DISCOUNT)# <cfset toplam_discount=DISCOUNT+toplam_discount></td>
								 <td style="text-align:center;">#SESSION.EP.MONEY#</td>
							 </cfif>
							 <td style="text-align:right;"><cfif len(price) and butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
						 </tr>
					 </cfoutput>
				 </tbody>
				<cfelseif get_total_purchase.recordcount and attributes.report_type eq 7>
				 <cfset currentrow=0>
				 <cfset branch_total_=0>
				 <thead>
					 <tr>
						 <th><cf_get_lang dictionary_id ='57486.Kategori'></th>
						 <th><cf_get_lang dictionary_id ='40290.Subesiz'></th>
						 <cfset branch_list=listsort(valuelist(GET_BRANCH.BRANCH_NAME,';'),'TEXT','ASC',';')>
						 <cfloop list="#branch_list#" index="branch_index" delimiters=";">
							 <th><cfoutput>#branch_index#</cfoutput></th>
							 <cfset 'branch_total_#filterSpecialChars(branch_index)#'=0>
						 </cfloop>
						 <th><cf_get_lang dictionary_id ='57486.Kategori'><cf_get_lang dictionary_id ='57492.Toplam'></th>
					 </tr>
				 </thead>
				 <cfoutput>
					 <tbody>
						 <cfloop from="1" to="#GET_TOTAL_PURCHASE.RECORDCOUNT#" index="row_c"><!--- kayitlar donerken satirlarida kolonlarida goruntuleniyor gelen kayitlara gore tr td ler sekilleniyor --->
							 <cfset currentrow=currentrow+1>
							 <cfset branch_count=0>
							 <cfif currentrow eq 1 or GET_TOTAL_PURCHASE.PRODUCT_CAT[currentrow] neq GET_TOTAL_PURCHASE.PRODUCT_CAT[currentrow-1]><!--- ilk kayit yada bir oncekinden farkli ise satir acilir--->
							 <tr>
								 <td>#GET_TOTAL_PURCHASE.PRODUCT_CAT[currentrow]#</td>
								 <td style="text-align:right;">
									 <cfif not len(GET_TOTAL_PURCHASE.BRANCH_NAME[currentrow])>
										 <cfif len(GET_TOTAL_PURCHASE.PRICE[currentrow])>
											 #TLFormat(GET_TOTAL_PURCHASE.PRICE[currentrow])#
											 <cfset branch_total_=branch_total_+GET_TOTAL_PURCHASE.PRICE[currentrow]>
										 <cfelse>
											 <cfset branch_total_=branch_total_>
										 </cfif>
										 <cfset currentrow=currentrow+1>
									 <cfelse>
										 #TLformat(0)#
									 </cfif>
								 </td>
								 <cfset prod_cat_total=0>
								 <cfloop list="#branch_list#" index="branch_index_" delimiters=";"><!--- subeler donerken queryden gelen kayitda dondurulerek kolonlara subenin degerlerini basmasi saglaniyor --->
									 <cfif GET_TOTAL_PURCHASE.PRODUCT_CAT[currentrow] eq GET_TOTAL_PURCHASE.PRODUCT_CAT[currentrow+branch_count]>
										 <td style="text-align:right;">
											 <cfif branch_index_ eq GET_TOTAL_PURCHASE.BRANCH_NAME[currentrow+branch_count]>
												 <cfset prod_cat_total=prod_cat_total+GET_TOTAL_PURCHASE.PRICE[currentrow+branch_count]>
												 #TLFormat(GET_TOTAL_PURCHASE.PRICE[currentrow+branch_count])#
												 <cfif len(evaluate('GET_TOTAL_PURCHASE.PRICE[currentrow+branch_count]'))>
												 <cfset 'branch_total_#filterSpecialChars(branch_index_)#'=evaluate('branch_total_#filterSpecialChars(branch_index_)#')+evaluate('GET_TOTAL_PURCHASE.PRICE[#currentrow+branch_count#]')>
												 </cfif>
												 <cfset branch_count=branch_count+1>
											 <cfelse>
												 #TLFormat(0)#
											 </cfif>
										 </td>
									 <cfelse>
										 <td style="text-align:right;">#TLFormat(0)#</td>
									 </cfif>
								 </cfloop>
								 <td style="text-align:right;">#TLFormat(prod_cat_total)#</td>
							 </cfif>
							 <cfset currentrow=currentrow+branch_count-1>
							 </tr>
							 <cfif currentrow eq GET_TOTAL_PURCHASE.RECORDCOUNT><cfbreak></cfif>
						 </cfloop>
					 </tbody>
				 </cfoutput>
				<cfelseif get_total_purchase.recordcount and attributes.report_type eq 8>
				 <thead>
					 <tr>
						 <th><cf_get_lang dictionary_id='57576.Çalisan'></th>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></th>
						 <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39401.Brüt Doviz'></th>
							 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='57677.Doviz'></th>
							 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
							 <cfif attributes.is_discount eq 1>
								 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39403.Isk Doviz'></th>
								 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
							 </cfif>
						 </cfif>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='39381.Brüt Tutar'></th>
						 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
						 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 <cfif attributes.is_discount eq 1>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39382.Isk Tutar'></th>
							 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 </cfif>
						 <th style="text-align:right;">%</th>
					 </tr>
				 </thead>
				 <tbody>
					 <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						 <tr>
							 <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium')" class="tableyazi">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a></td>
							 <td style="text-align:right;">#TLFormat(PRODUCT_STOCK,4)#
							 <cfif len(PRODUCT_STOCK)>
								 <cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar>
							 </cfif>
							 </td>
							 <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
								 <td style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ)# </td>
								 <td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
								 <td style="text-align:right;">#TLFormat(PRICE_DOVIZ)# </td>
								 <td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
								 <cfif attributes.is_discount eq 1>
									 <td style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ-PRICE_DOVIZ)# </td>
									 <td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
								 </cfif>
							 </cfif>
							 <td style="text-align:right;">#TLFormat(GROSSTOTAL)# <cfset total_grosstotal=GROSSTOTAL+total_grosstotal></td>
							 <td style="text-align:center;">#SESSION.EP.MONEY#</td>
							 <td style="text-align:right;">#TLFormat(PRICE)# <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif></td>
							 <td style="text-align:center;">#SESSION.EP.MONEY#</td>
							 <cfif attributes.is_discount eq 1>
								 <td style="text-align:right;">#TLFormat(DISCOUNT)#<cfset toplam_discount=DISCOUNT+toplam_discount> </td>
								 <td style="text-align:center;">#SESSION.EP.MONEY#</td>
							 </cfif>
							 <td style="text-align:right;"><cfif len(price) and butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
						 </tr>
					 </cfoutput>
				 </tbody>
			 <cfelseif get_total_purchase.recordcount and attributes.report_type eq 9>
				 <thead> 
					 <tr>
					 <th><cf_get_lang dictionary_id='58847.Marka'></th>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></th>
						 <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39401.Brüt Doviz'></th>
							 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='57677.Doviz'></th>
							 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
							 <cfif attributes.is_discount eq 1>
								 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39403.Isk Doviz'></th>
								 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
							 </cfif>
						 </cfif>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='39381.Brüt Tutar'></th>
						 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
						 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 <cfif attributes.is_discount eq 1>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39382.Isk Tutar'></th>
							 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 </cfif>
						 <th style="text-align:right;">%</th>
					 </tr>
				 </thead>
				 <tbody>  
					 <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						 <tr>
							 <td>#BRAND_NAME#</td>
							 <td style="text-align:right;">#TLFormat(PRODUCT_STOCK,4)#
								 <cfif len(PRODUCT_STOCK)>
									 <cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar>
								 </cfif>
							 </td>
							 <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
								 <td style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ)# </td>
								 <td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
								 <td style="text-align:right;">#TLFormat(PRICE_DOVIZ)# </td>
								 <td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
								 <cfif attributes.is_discount eq 1>
									 <td style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ-PRICE_DOVIZ)# </td>
									 <td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
								 </cfif>
							 </cfif>
							 <td style="text-align:right;">#TLFormat(GROSSTOTAL)#<cfset total_grosstotal=GROSSTOTAL+total_grosstotal> </td>
							 <td style="text-align:center;">#SESSION.EP.MONEY#</td>
							 <td style="text-align:right;">#TLFormat(PRICE)# <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif></td>
							 <td style="text-align:center;">#SESSION.EP.MONEY#</td>
							 <cfif attributes.is_discount eq 1>
								 <td style="text-align:right;">#TLFormat(DISCOUNT)# <cfset toplam_discount=DISCOUNT+toplam_discount></td>
								 <td style="text-align:center;">#SESSION.EP.MONEY#</td>
							 </cfif>
							 <td style="text-align:right;"><cfif len(price) and butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
						 </tr>
					 </cfoutput>
				 </tbody>
			 <cfelseif get_total_purchase.recordcount and attributes.report_type eq 10>
				 <thead> 
					 <tr>
						 <th><cf_get_lang dictionary_id='58552.Müsteri Degeri'></th>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></th>
						 <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39401.Brüt Doviz'></th>
							 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='57677.Doviz'></th>
							 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
							 <cfif attributes.is_discount eq 1>
								 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39403.Isk Doviz'></th>
								 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
							 </cfif>
						 </cfif>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='39381.Brüt Tutar'></th>
						 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
						 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 <cfif attributes.is_discount eq 1>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39382.Isk Tutar'></th>
							 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 </cfif>
						 <th style="text-align:right;">%</th>
					 </tr>  
				 </thead>
				 <tbody>
					 <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						 <tr>
							 <td>#GET_CUSTOMER_VALUE_2.CUSTOMER_VALUE[listfind(list_customer_val_ids,CUSTOMER_VALUE_ID,',')]#</td>
							 <td style="text-align:right;">#TLFormat(PRODUCT_STOCK,4)#
							 <cfif len(PRODUCT_STOCK)>
								 <cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar>
							 </cfif>
							 </td>
							 <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
								 <td style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ)# </td>
								 <td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
								 <td style="text-align:right;">#TLFormat(PRICE_DOVIZ)# </td>
								 <td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
								 <cfif attributes.is_discount eq 1>
									 <td style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ-PRICE_DOVIZ)# </td>
									 <td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
								 </cfif>
							 </cfif>
							 <td style="text-align:right;">#TLFormat(GROSSTOTAL)# <cfset total_grosstotal=GROSSTOTAL+total_grosstotal></td>
							 <td style="text-align:center;">#SESSION.EP.MONEY#</td>
							 <td style="text-align:right;">#TLFormat(PRICE)# <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif></td>
							 <td style="text-align:center;">#SESSION.EP.MONEY#</td>
							 <cfif attributes.is_discount eq 1>
								 <td style="text-align:right;">#TLFormat(DISCOUNT)# <cfset toplam_discount=DISCOUNT+toplam_discount></td>
								 <td style="text-align:center;">#SESSION.EP.MONEY#</td>
							 </cfif>
							 <td style="text-align:right;"><cfif len(price) and butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
						 </tr>
					 </cfoutput>
				 </tbody>
				<cfelseif get_total_purchase.recordcount and attributes.report_type eq 11>
				 <thead> 
					 <tr>
						 <th><cf_get_lang dictionary_id='39224.Iliski Tipi'></th>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></th>
						 <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39401.Brüt Doviz'></th>
							 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='57677.Doviz'></th>
							 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
							 <cfif attributes.is_discount eq 1>
								 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39403.Isk Doviz'></th>
								 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
							 </cfif>
						 </cfif>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='39381.Brüt Tutar'></th>
						 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
						 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 <cfif attributes.is_discount eq 1>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39382.Isk Tutar'></th>
							 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 </cfif>
						 <th style="text-align:right;">%</th>
					 </tr>  
				 </thead>
				 <tbody>
					 <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						 <tr>
							 <td>#GET_RESOURCE_2.RESOURCE[listfind(list_resource_ids,RESOURCE_ID,',')]#</td>
							 <td style="text-align:right;">#TLFormat(PRODUCT_STOCK,4)#
							 <cfif len(PRODUCT_STOCK)>
								 <cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar>
							 </cfif>
							 </td>
							 <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
								 <td style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ)# </td>
								 <td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
								 <td style="text-align:right;">#TLFormat(PRICE_DOVIZ)# </td>
								 <td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
								 <cfif attributes.is_discount eq 1>
									 <td style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ-PRICE_DOVIZ)# </td>
									 <td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
								 </cfif>
							 </cfif>
							 <td style="text-align:right;">#TLFormat(GROSSTOTAL)# <cfset total_grosstotal=GROSSTOTAL+total_grosstotal></td>
							 <td style="text-align:center;">#SESSION.EP.MONEY#</td>
							 <td style="text-align:right;">#TLFormat(PRICE)# <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif></td>
							 <td style="text-align:center;">#SESSION.EP.MONEY#</td>
							 <cfif attributes.is_discount eq 1>
								 <td style="text-align:right;">#TLFormat(DISCOUNT)# <cfset toplam_discount=DISCOUNT+toplam_discount></td>
								 <td style="text-align:center;">#SESSION.EP.MONEY#</td>
							 </cfif>
							 <td style="text-align:right;"><cfif len(price) and butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
						 </tr>
					 </cfoutput>
				 </tbody>
			 <cfelseif get_total_purchase.recordcount and attributes.report_type eq 12>
				 <thead> 
					 <tr>
						 <th><cf_get_lang dictionary_id='58134.Mikro Bölge Kodu'></th>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></th>
						 <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39401.Brüt Doviz'></th>
							 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='57677.Doviz'></th>
							 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
							 <cfif attributes.is_discount eq 1>
								 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39403.Isk Doviz'></th>
								 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
							 </cfif>
						 </cfif>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='39381.Brüt Tutar'></th>
						 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
						 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 <cfif attributes.is_discount eq 1>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39382.Isk Tutar'></th>
							 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 </cfif>
						 <th style="text-align:right;">%</th>
					 </tr>  
				 </thead>
				   <tbody>
					 <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						 <tr>
							 <td>#IMS_CODE_NAME#</td>
							 <td style="text-align:right;">#TLFormat(PRODUCT_STOCK,4)#
							 <cfif len(PRODUCT_STOCK)>
								 <cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar>
							 </cfif>
							 </td>
							 <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
								 <td style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ)# </td>
								 <td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
								 <td style="text-align:right;">#TLFormat(PRICE_DOVIZ)# </td>
								 <td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
								 <cfif attributes.is_discount eq 1>
									 <td style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ-PRICE_DOVIZ)# </td>
									 <td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
								 </cfif>
							 </cfif>
							 <td style="text-align:right;">#TLFormat(GROSSTOTAL)# <cfset total_grosstotal=GROSSTOTAL+total_grosstotal></td>
							 <td style="text-align:center;">#SESSION.EP.MONEY#</td>
							 <td style="text-align:right;">#TLFormat(PRICE)# <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif></td>
							 <td style="text-align:center;">#SESSION.EP.MONEY#</td>
							 <cfif attributes.is_discount eq 1>
								 <td style="text-align:right;">#TLFormat(DISCOUNT)# <cfset toplam_discount=DISCOUNT+toplam_discount></td>
								 <td style="text-align:center;">#SESSION.EP.MONEY#</td>
							 </cfif>
							 <td style="text-align:right;"><cfif len(price) and butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
						 </tr>
					 </cfoutput>
					</tbody>
				<cfelseif get_total_purchase.recordcount and attributes.report_type eq 13>
				 <thead> 
					 <tr>
						 <th><cf_get_lang dictionary_id='57659.Satis Bölgesi'></th>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></th>
						 <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39401.Brüt Doviz'></th>
							 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='57677.Doviz'></th>
							 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
							 <cfif attributes.is_discount eq 1>
								 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39403.Isk Doviz'></th>
								 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
							 </cfif>
						 </cfif>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='39381.Brüt Tutar'></th>
						 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
						 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 <cfif attributes.is_discount eq 1>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39382.Isk Tutar'></th>
							 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 </cfif>
						 <th style="text-align:right;">%</th>
					 </tr> 
				 </thead>
				 <tbody> 
					 <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						 <tr>
							 <td>#SZ_2.SZ_NAME[listfind(list_zone_ids,ZONE_ID,',')]#</td>
							 <td style="text-align:right;">#TLFormat(PRODUCT_STOCK,4)#
							 <cfif len(PRODUCT_STOCK)>
								 <cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar>
							 </cfif>
							 </td>
							 <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
								 <td style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ)# </td>
								 <td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
								 <td style="text-align:right;">#TLFormat(PRICE_DOVIZ)# </td>
								 <td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
								 <cfif attributes.is_discount eq 1>
									 <td style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ-PRICE_DOVIZ)# </td>
									 <td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
								 </cfif>
							 </cfif>
							 <td style="text-align:right;">#TLFormat(GROSSTOTAL)# <cfset total_grosstotal=GROSSTOTAL+total_grosstotal></td>
							 <td style="text-align:center;">#SESSION.EP.MONEY#</td>
							 <td style="text-align:right;">#TLFormat(PRICE)# <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif></td>
							 <td style="text-align:center;">#SESSION.EP.MONEY#</td>
							 <cfif attributes.is_discount eq 1>
								 <td style="text-align:right;">#TLFormat(DISCOUNT)# <cfset toplam_discount=DISCOUNT+toplam_discount></td>
								 <td style="text-align:center;">#SESSION.EP.MONEY#</td>
							 </cfif>
							 <td style="text-align:right;"><cfif len(price) and butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
						 </tr>
					 </cfoutput>
				 </tbody>
				<cfelseif get_total_purchase.recordcount and attributes.report_type eq 14>
				 <thead>
					 <tr>
						 <th><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></th>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></th>
						 <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39401.Brüt Doviz'></th>
							 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='57677.Doviz'></th>
							 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
							 <cfif attributes.is_discount eq 1>
								 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39403.Isk Doviz'></th>
								 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
							 </cfif>
						 </cfif>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='39381.Brüt Tutar'></th>
						 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
						 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 <cfif attributes.is_discount eq 1>
							 <th width="75"  style="text-align:right;"><cf_get_lang dictionary_id='39382.Isk Tutar'></th>
							 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 </cfif>
						 <th style="text-align:right;">%</th>
					 </tr>
				 </thead>
				   <tbody>  
						<cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						 <tr>
							 <td>
								 <cfif len(PAYMETHOD) and listfind(list_pay_ids,PAYMETHOD,',')>
									 #GET_PAY_METHOD.PAYMETHOD[listfind(list_pay_ids,PAYMETHOD,',')]#
								 <cfelseif len(CARD_PAYMETHOD_ID) and listfind(list_cc_pay_ids,CARD_PAYMETHOD_ID,',')>
									 #GET_CC_METHOD.CARD_NO[listfind(list_cc_pay_ids,CARD_PAYMETHOD_ID,',')]#
								 <cfelse>
									 **&Ouml;Y:#PAYMETHOD# KK &Ouml;Y:#CARD_PAYMETHOD_ID#**
								 </cfif>
							 </td>
							 <td style="text-align:right;">#TLFormat(PRODUCT_STOCK,4)#
								 <cfif len(PRODUCT_STOCK)>
									 <cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar>
								 </cfif>
							 </td>
							 <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
								 <td style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ)# </td>
								 <td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
								 <td style="text-align:right;">#TLFormat(PRICE_DOVIZ)# </td>
								 <td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
								 <cfif attributes.is_discount eq 1>
									 <td style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ-PRICE_DOVIZ)# </td>
									 <td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
								 </cfif>
							 </cfif>
							 <td style="text-align:right;">#TLFormat(GROSSTOTAL)# <cfset total_grosstotal=GROSSTOTAL+total_grosstotal></td>
							 <td style="text-align:center;">#SESSION.EP.MONEY#</td>
							 <td style="text-align:right;">#TLFormat(PRICE)# <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif></td>
							 <td style="text-align:center;">#SESSION.EP.MONEY#</td>
							 <cfif attributes.is_discount eq 1>
								 <td style="text-align:right;">#TLFormat(DISCOUNT)#<cfset toplam_discount=DISCOUNT+toplam_discount> </td>
								 <td style="text-align:center;">#SESSION.EP.MONEY#</td>
							 </cfif>
							 <td style="text-align:right;"><cfif len(price) and butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
						 </tr>
					 </cfoutput>
				   </tbody>
			 <cfelseif get_total_purchase.recordcount and attributes.report_type eq 15>
				 <thead>  
					 <tr>
						 <th><cf_get_lang dictionary_id='39370.Hedef Pazar'></th>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></th>
						 <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39401.Brüt Doviz'></th>
							 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='57677.Doviz'></th>
							 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
							 <cfif attributes.is_discount eq 1>
								 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39403.Isk Doviz'></th>
								 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
							 </cfif>
						 </cfif>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='39381.Brüt Tutar'></th>
						 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
						 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 <cfif attributes.is_discount eq 1>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39382.Isk Tutar'></th>
							 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 </cfif>
						 <th style="text-align:right;">%</th>
					 </tr>  
				 </thead>
				 <tbody>
					 <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						 <tr>
							 <td>
							 <cfif len(get_total_purchase.SEGMENT_ID) and listfind(list_segment_ids,get_total_purchase.SEGMENT_ID,',')>
								 #GET_SEGMENTS_2.PRODUCT_SEGMENT[listfind(list_segment_ids,get_total_purchase.SEGMENT_ID,',')]#
							 </cfif>
							 </td>
							 <td style="text-align:right;">#TLFormat(PRODUCT_STOCK,4)#
							 <cfif len(PRODUCT_STOCK)>
								 <cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar>
							 </cfif>
							 </td>
							 <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
								 <td style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ)# </td>
								 <td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
								 <td style="text-align:right;">#TLFormat(PRICE_DOVIZ)# </td>
								 <td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
								 <cfif attributes.is_discount eq 1>
									 <td style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ-PRICE_DOVIZ)# </td>
									 <td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
								 </cfif>
							 </cfif>
							 <td style="text-align:right;">#TLFormat(GROSSTOTAL)# <cfset total_grosstotal=GROSSTOTAL+total_grosstotal></td>
							 <td style="text-align:center;">#SESSION.EP.MONEY#</td>
							 <td style="text-align:right;">#TLFormat(PRICE)# <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif></td>
							 <td style="text-align:center;">#SESSION.EP.MONEY#</td>
							 <cfif attributes.is_discount eq 1>
								 <td style="text-align:right;">#TLFormat(DISCOUNT)# <cfset toplam_discount=DISCOUNT+toplam_discount></td>
								 <td style="text-align:center;">#SESSION.EP.MONEY#</td>
							 </cfif>
							 <td style="text-align:right;"><cfif len(price) and butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
						 </tr>
					 </cfoutput>
				 </tbody>
				<cfelseif get_total_purchase.recordcount and attributes.report_type eq 16>
				 <thead>   
					 <tr>
						 <th>Il</th>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></th>
						 <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39401.Brüt Doviz'></th>
							 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='57677.Doviz'></th>
							 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
							 <cfif attributes.is_discount eq 1>
								 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39403.Isk Doviz'></th>
								 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
							 </cfif>
						 </cfif>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='39381.Brüt Tutar'></th>
						 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
						 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 <cfif attributes.is_discount eq 1>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39382.Isk Tutar'></th>
							 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 </cfif>
						 <th style="text-align:right;">%</th>
					 </tr> 
				 </thead>
				 <tbody> 
					 <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						 <tr>
							 <td>
							 <cfif len(get_total_purchase.city) and listfind(city_id_list,get_total_purchase.city,',')>
								 #get_city.city_name[listfind(city_id_list,get_total_purchase.city,',')]#
							 </cfif>
							 </td>
							 <td style="text-align:right;">#TLFormat(PRODUCT_STOCK,4)#
							 <cfif len(PRODUCT_STOCK)>
								 <cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar>
							 </cfif>
							 </td>
							 <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
								 <td style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ)# </td>
								 <td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
								 <td style="text-align:right;">#TLFormat(PRICE_DOVIZ)# </td>
								 <td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
								 <cfif attributes.is_discount eq 1>
									 <td style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ-PRICE_DOVIZ)# </td>
									 <td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
								 </cfif>
							 </cfif>
							 <td style="text-align:right;">#TLFormat(GROSSTOTAL)# <cfset total_grosstotal=GROSSTOTAL+total_grosstotal></td>
							 <td style="text-align:center;">#SESSION.EP.MONEY#</td>
							 <td style="text-align:right;">#TLFormat(PRICE)# <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif></td>
							 <td style="text-align:center;">#SESSION.EP.MONEY#</td>
							 <cfif attributes.is_discount eq 1>
								 <td style="text-align:right;">#TLFormat(DISCOUNT)# <cfset toplam_discount=DISCOUNT+toplam_discount></td>
								 <td style="text-align:center;">#SESSION.EP.MONEY#</td>
							 </cfif>
							 <td style="text-align:right;"><cfif len(price) and butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
						 </tr>
					 </cfoutput>
				 </tbody>
			 <cfelseif get_total_purchase.recordcount and attributes.report_type eq 17>
				 <thead>  
					 <tr>
						 <th><cf_get_lang dictionary_id='58211.Siparis No'></th>
						 <cfif xml_reference_code eq 1>
							 <th><cf_get_lang dictionary_id='39902.Referans Kodu'></th>
						 </cfif>
						 <cfif xml_order_head eq 1>
							 <th><cf_get_lang dictionary_id='60815.Sipariş Konusu'></th>
						 </cfif>
						 <th><cf_get_lang dictionary_id='29501.Siparis Tarihi'></th>
						 <th><cf_get_lang dictionary_id='57645.Teslim Tarihi'></th>
						 <th><cf_get_lang dictionary_id='39695.Siparis Süreci'></th>
						 <th><cf_get_lang dictionary_id='57482.Asama'></th>
						 <th><cf_get_lang dictionary_id='57457.Müşteri'></th>
						 <cfif attributes.is_project eq 1>
							 <th><cf_get_lang dictionary_id ='57416.Proje'></th>
						 </cfif>
						 <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
						 <th nowrap="nowrap"><cf_get_lang dictionary_id='39513.Satır Açıklaması'></th>
						 <th><cf_get_lang dictionary_id='58800.Ürün Kod'></th>
						 <th><cf_get_lang dictionary_id='57634.Üretici Kodu'></th>
						 <th width="150"><cf_get_lang dictionary_id='57657.Ürün'></th>
						 <cfif is_brand_show eq 1><th><cf_get_lang dictionary_id='58847.Marka'></th></cfif>
						 <cfif is_short_code_show eq 1><th><cf_get_lang dictionary_id='58225.Model'></th></cfif>
						 <cfif isdefined("attributes.is_spect_info")>
							 <th><cf_get_lang dictionary_id='57647.Spec'></th>
							 <th><cf_get_lang dictionary_id='54850.Spec Id'></th>
						 </cfif>
						 <cfif isdefined("x_show_special_code") and x_show_special_code eq 1>
							 <th><cf_get_lang dictionary_id="57789.Özel Kod"></th>
						 </cfif>
						 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></th>
						 <th width="75" style="text-align:right;">2.<cf_get_lang dictionary_id='57635.Miktar'></th>
						 <cfif x_unit_weight eq 1>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='29784.Ağırlık'></th>
						 </cfif>
						 <th style="text-align:center;"><cf_get_lang dictionary_id='57636.Birim'></th>
						 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id ='40288.Teslim Edilen'></th>
						 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='58444.Kalan'></th>
						 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='57638.Birim Fiyat'></th>
						 <cfif isdefined("attributes.is_money_info") and attributes.is_money_info eq 1>
							 <th width="100"><cf_get_lang dictionary_id='39411.Döviz Net Fiyat'></th>
							 <th width="70"><cf_get_lang dictionary_id='58121.Islem Dövizi'></th>
						 </cfif>
						 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='38843.Net Fiyat'></th>
						 <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39401.Brüt Doviz'></th>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='57677.Doviz'></th>
							 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
							 <cfif attributes.is_discount eq 1>
								 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39403.Isk Doviz'></th>
								 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
							 </cfif>
						 </cfif>
						 <th width="90" style="text-align:right;"><cf_get_lang dictionary_id='39381.Brüt Tutar'></th>
						 <th width="90" style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
						 <th width="90" style="text-align:right;"><cf_get_lang dictionary_id='40687.Kalan Tutar'></th>
						 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 <cfif attributes.is_discount eq 1>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='661.Isk Tutar'></th>
							 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 </cfif>
						 <th style="text-align:right;">%</th>
					 </tr>
				 </thead>
				 <tbody>
					 <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						 <tr>
							 <td><cfset fuse_type = 'sales'>
								 <cfif is_instalment eq 1>
									 <cfset page_type = 'upd_fast_sale'>
								 <cfelse>
									 <cfset page_type = 'list_order&event=upd'>
								 </cfif>
								 <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#fuse_type#.#page_type#&order_id=#order_id#','wide');" class="tableyazi">
									#ORDER_NUMBER#
								 </a>
							 </td>
							 <cfif xml_reference_code eq 1>
								 <td>#REF_NO#</td>
							 </cfif>
							 <cfif xml_order_head eq 1>
								 <td>#ORDER_HEAD#</td>
							 </cfif>
							 <td>#dateformat(ORDER_DATE,dateformat_style)#</td>
							 <td>#dateformat(DELIVERDATE_,dateformat_style)#</td>
							 <td><cfif isdefined('stage_list_name_id') and listlen(stage_list_name_id,',') gte listfind(stage_list_name_id,ORDER_STAGE,',')+1 and listfind(stage_list_name_id,ORDER_STAGE,',') gt 0>
									 #listgetat(stage_list_name_id,listfind(stage_list_name_id,ORDER_STAGE,',')+1,',')#
								 </cfif>
							 </td>
							 <td><cfif order_row_currency eq -8><cf_get_lang dictionary_id ='29749.Fazla Teslimat'>
								 <cfelseif order_row_currency eq -7><cf_get_lang dictionary_id ='29748.Eksik Teslimat'>
								 <cfelseif order_row_currency eq -6><cf_get_lang dictionary_id ='58761.Sevk'>
								 <cfelseif order_row_currency eq -5><cf_get_lang dictionary_id ='57456.Üretim'>
								 <cfelseif order_row_currency eq -4><cf_get_lang dictionary_id ='29747.Kismi Üretim'>
								 <cfelseif order_row_currency eq -3><cf_get_lang dictionary_id ='29746.Kapatildi'>
								 <cfelseif order_row_currency eq -2><cf_get_lang dictionary_id ='29745.Tedarik'>
								 <cfelseif order_row_currency eq -1><cf_get_lang dictionary_id ='58717.Açık'>
								 <cfelseif order_row_currency eq -9><cf_get_lang dictionary_id ='58506.İptal'>
								 <cfelseif order_row_currency eq -10><cf_get_lang dictionary_id ='29746.Kapatıldı'>(<cf_get_lang dictionary_id ='58500.Manuel'>)
								 </cfif>				
							 </td>
							 <td><cfif MEMBER_TYPE eq 1><!--- kurumsallar icin --->
									 <a href="javascript://"  class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#COMPANY_ID#','list')">#MUSTERI#</a>
								 <cfelse>
									 <a href="javascript://"  class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#COMPANY_ID#','list')">#MUSTERI#</a>
								 </cfif>
							 </td>
							 <cfif attributes.is_project eq 1>
								 <td><cfif len(get_total_purchase.row_project_id) and listfind(project_id_list,get_total_purchase.row_project_id,',')>
										 <a href="#request.self#?fuseaction=project.projects&event=det&id=#row_project_id#" class="tableyazi">#get_project.project_head[listfind(project_id_list,get_total_purchase.row_project_id,',')]#</a>
									 <cfelseif len(get_total_purchase.project_id) and listfind(project_id_list,get_total_purchase.project_id,',')>
										 <a href="#request.self#?fuseaction=project.projects&event=det&id=#project_id#" class="tableyazi">#get_project.project_head[listfind(project_id_list,get_total_purchase.project_id,',')]#</a>
									 </cfif>
								 </td>
							 </cfif>
							 <td>#ORDER_DETAIL#</td>
							 <td>#PRODUCT_NAME2#</td>
							 <td style="mso-number-format:'\@'">#STOCK_CODE#</td>
							 <td>#MANUFACT_CODE#</td>
							 <td><a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#PRODUCT_ID#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','list');">
									 #PRODUCT_NAME# #PROPERTY#
								 </a>
							 </td>
							 <cfif is_brand_show eq 1><td><cfif len(brand_id)>#get_brand.BRAND_NAME[listfind(brand_id_list,brand_id,',')]#</cfif></td></cfif>
							 <cfif is_short_code_show eq 1><td><cfif len(short_code_id)>#get_model.MODEL_NAME[listfind(short_code_id_list,short_code_id,',')]#</cfif></td></cfif>
							 <cfif isdefined("attributes.is_spect_info")>
								 <td>#spect_var_name#</td>
								 <td>#spect_main_id#</td>
							 </cfif>
							 <cfif isDefined('x_show_special_code') And x_show_special_code Eq 1>
								 <td style="mso-number-format:\@;">#product_code_2#</td>
							 </cfif>
							 <td style="text-align:right;">#TLFormat(PRODUCT_STOCK,4)# 
							 <cfif len(PRODUCT_STOCK)>
								 <cfset unit_ = filterSpecialChars(birim)>
								 <cfset 'toplam_#unit_#' = evaluate('toplam_#unit_#') +PRODUCT_STOCK>	
							 </cfif>
							 </td>
							 <td style="text-align:right;">
								 <cfif len(MULTIPLIER_AMOUNT_1)>
									 <cfset toplam_multiplier_amount_1 = toplam_multiplier_amount_1 + PRODUCT_STOCK/MULTIPLIER_AMOUNT_1>
									 #TLFormat(PRODUCT_STOCK/MULTIPLIER_AMOUNT_1,get_basket.amount_round)#
								 </cfif>
							 </td>
							 <cfif x_unit_weight eq 1>
								 <td style="text-align:center;" style="text-align:right;mso-number-format:'\@'">
									 <cfif len(PRODUCT_STOCK) and len(UNIT_WEIGHT_1)>
										 <cfset toplam_unit_weıght_1 = toplam_unit_weıght_1 + PRODUCT_STOCK*UNIT_WEIGHT_1>
										 #TLFormat(PRODUCT_STOCK*UNIT_WEIGHT_1,4)#
									 </cfif>
								 </td>
							 </cfif>
							 <td style="text-align:center;" >#BIRIM#</td>
							 <td style="text-align:right;">#TLFormat(deliver_amount)#</td>
							 <td style="text-align:right;">
								 <cfset remain_amount = product_stock-deliver_amount>
								 <cfif x_show_remains_as_zero eq 1 and remain_amount lt 0>
									 <cfset remain_amount = 0>
								 </cfif> 
								 #TLFormat(remain_amount)#
							 </td>
							 <cfset 'toplam_giden_#unit_#' = evaluate('toplam_giden_#unit_#') + deliver_amount>	
							 <cfset 'toplam_kalan_#unit_#' = evaluate('toplam_kalan_#unit_#') + (product_stock - (deliver_amount))>	
							 <td style="text-align:right;">#TLFormat(birim_fiyat)#</td>
							 <cfif isdefined("attributes.is_money_info") and attributes.is_money_info eq 1>
								 <td style="text-align:right;">#tlformat(other_money_value)# <cfset "toplam_net_doviz_#other_money#" = evaluate("toplam_net_doviz_#other_money#") + other_money_value></td>
								 <td style="text-align:center;">#other_money#</td>
							 </cfif>
							 <cfif attributes.is_other_money eq 1>
								 <cfset net_fiyat_=OTHER_MONEY_VALUE/QUANTITY>
							 <cfelseif len(ROW_LASTTOTAL)>
								 <cfset net_fiyat_=ROW_LASTTOTAL/QUANTITY>
							 <cfelse>
								 <cfset net_fiyat_=0>
							 </cfif>
							  <td style="text-align:right;">
								 #TLFormat(net_fiyat_)#
								 <cfif attributes.is_other_money eq 1>
									 <cfset "toplam_#other_money#" = evaluate("toplam_#other_money#")+net_fiyat_>
								 <cfelse>
									 <cfset toplam_net_fiyet=toplam_net_fiyet+net_fiyat_>
								 </cfif>
							  </td>
							 <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
								 <td style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ)# </td>
								 <td style="text-align:right;">#TLFormat(PRICE_DOVIZ)# </td>
								 <td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
								 <cfif attributes.is_discount eq 1>
									 <td style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ-PRICE_DOVIZ)# </td>
									 <td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
								 </cfif>
							 </cfif>
							 <td style="text-align:right;">#TLFormat(GROSSTOTAL)#<cfset total_grosstotal=GROSSTOTAL+total_grosstotal></td>
							 <td style="text-align:right;">
								 #TLFormat(ROW_LASTTOTAL)#
								 <cfset toplam_satis =toplam_satis+ROW_LASTTOTAL>
							 </td>
							 <td style="text-align:right;">
								 <cfset remain = product_stock-deliver_amount>
								 <cfif x_show_remains_as_zero eq 1 and remain lt 0>
									 <cfset remain = 0>
								 </cfif>
								 #TLFormat(remain*ROW_LASTTOTAL/QUANTITY)#
								 <cfif attributes.is_other_money eq 1>
									 <cfif isdefined("other_money") and len(other_money)>
										 <cfset "toplam_kalan_tutar#OTHER_MONEY#"=evaluate("toplam_kalan_tutar#OTHER_MONEY#")+(remain*ROW_LASTTOTAL/QUANTITY)>
									 <cfelse>
										 <cfset "toplam_kalan_tutar#SESSION.EP.MONEY#"=evaluate("toplam_kalan_tutar#SESSION.EP.MONEY#")+(remain*ROW_LASTTOTAL/QUANTITY)>
									 </cfif>
								 <cfelse>
									 <cfset toplam_kalan_tutar=toplam_kalan_tutar+(remain*ROW_LASTTOTAL/QUANTITY)>
								 </cfif>
							 </td>
							 <td style="text-align:center;">#SESSION.EP.MONEY#</td>
							 <cfif attributes.is_discount eq 1>
								 <td style="text-align:right;">#TLFormat(DISCOUNT)# <cfset toplam_discount=DISCOUNT+toplam_discount></td>
								 <td style="text-align:center;">#SESSION.EP.MONEY#</td>
							 </cfif>
							 <td style="text-align:right;"><cfif len(price) and butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
						 </tr>
					 </cfoutput>
				 </tbody>
			 <cfelseif get_total_purchase.recordcount and attributes.report_type eq 18>
				 <cfset currentrow=0>
				 <tfoot>
					 <tr>
						 <td><cf_get_lang dictionary_id ='57486.Kategori'></td>
						 <cfset emp_list=listsort(valuelist(get_employees.emp_name,';'),'TEXT','ASC',';')>
						 <cfloop list="#emp_list#" index="emp_index" delimiters=";">
							 <td><cfoutput>#emp_index#</cfoutput></td>
							 <cfset 'emp_total_#filterSpecialChars(emp_index)#'=0>
						 </cfloop>
						 <td><cf_get_lang dictionary_id ='57486.Kategori'> <cf_get_lang dictionary_id ='57492.Toplam'> </td>
					 </tr>
					 <cfoutput>
						 <cfloop from="1" to="#GET_TOTAL_PURCHASE.RECORDCOUNT#" index="row_c"><!--- kayitlar donerken satirlarida kolonlarida goruntuleniyor gelen kayitlara gore tr td ler sekilleniyor --->
							 <cfset currentrow=currentrow+1>
							 <cfset emp_count=0>
							 <cfif currentrow eq 1 or GET_TOTAL_PURCHASE.PRODUCT_CAT[currentrow] neq GET_TOTAL_PURCHASE.PRODUCT_CAT[currentrow-1]><!--- ilk kayit yada bir oncekinden farkli ise satir acilir--->
								 <tr height="20" onmouseover="this.className='color-light';" onmouseout="this.className='color-row';" class="color-row">
								 <td>#GET_TOTAL_PURCHASE.PRODUCT_CAT[currentrow]#</td>
								 <cfset prod_cat_total=0>
							 </cfif>
							 <cfloop list="#emp_list#" index="emp_index" delimiters=";"><!--- calisanlar donerken queryden gelen kayitda dondurulerek kolonlara calisanin degerlerini basmasi saglaniyor --->
								 <cfif GET_TOTAL_PURCHASE.PRODUCT_CAT[currentrow] eq GET_TOTAL_PURCHASE.PRODUCT_CAT[currentrow+emp_count]>
									 <td style="text-align:right;">
										 <cfif emp_index eq GET_TOTAL_PURCHASE.EMP_NAME[currentrow+emp_count]>
											 <cfset prod_cat_total=prod_cat_total+GET_TOTAL_PURCHASE.PRICE[currentrow+emp_count]>
											 #TLFormat(GET_TOTAL_PURCHASE.PRICE[currentrow+emp_count])#
											 <cfif len(evaluate('GET_TOTAL_PURCHASE.PRICE[currentrow+emp_count]'))>
												 <cfset 'emp_total_#filterSpecialChars(emp_index)#'=evaluate('emp_total_#filterSpecialChars(emp_index)#')+evaluate('GET_TOTAL_PURCHASE.PRICE[#currentrow+emp_count#]')>
											 </cfif>
											 <cfset emp_count=emp_count+1>
										 <cfelse>
											 #TLFormat(0)#
										 </cfif>
									 </td>
								 <cfelse>
									 <td style="text-align:right;">#TLFormat(0)#</td>
								 </cfif>
							 </cfloop>
							 <td style="text-align:right;">#TLFormat(prod_cat_total)#</td>
							 <cfset currentrow=currentrow+emp_count-1>
							 <cfif currentrow eq GET_TOTAL_PURCHASE.RECORDCOUNT or GET_TOTAL_PURCHASE.PRODUCT_CAT[currentrow] neq GET_TOTAL_PURCHASE.PRODUCT_CAT[currentrow+1]><!--- tr kapatmak icin ya son satir olacak yada bir sonrakinden farkli bir kategori olacak --->
							 </tr>
							 </cfif>
							 <cfif currentrow eq GET_TOTAL_PURCHASE.RECORDCOUNT><cfbreak></cfif>
						 </cfloop>
					 </cfoutput>
				 </tfoot>
				 <cfelseif get_total_purchase.recordcount and attributes.report_type eq 22>
				 <thead>
					 <tr>
						 <th><cf_get_lang dictionary_id="57487.No"></th>
						 <th><cf_get_lang dictionary_id='58211.Siparis No'></th>
						 <cfif xml_reference_code eq 1>
							 <th><cf_get_lang dictionary_id='39902.Referans Kodu'></th>
						 </cfif>
						 <th><cf_get_lang dictionary_id='60815.Sipariş Konusu'></th>
						 <th><cf_get_lang dictionary_id='29501.Siparis Tarihi'></th>
						 <th><cf_get_lang dictionary_id='48282.Sevk Tarihi'></th>
						 <th><cf_get_lang dictionary_id='57645.Teslim Tarihi'></th>
						 <th><cf_get_lang dictionary_id='39695.Siparis Süreci'></th>
						 <th><cf_get_lang dictionary_id='60816.Sipariş Özel Tanımı'></th>
						 <th><cf_get_lang dictionary_id='58061.Cari'></th>
						 <cfif attributes.is_project eq 1>
							 <th><cf_get_lang dictionary_id ='57416.Proje'></th>
						 </cfif>
						 <th><cf_get_lang dictionary_id ='58608.İl'></th>
						 <th><cf_get_lang dictionary_id ='58638.İlçe'></th>
						 <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
						 <th><cf_get_lang dictionary_id ='56987.Satış Yapan'></th>
						 <th><cf_get_lang dictionary_id ='57322.Satış Ortağı'></th>
						 <th><cf_get_lang dictionary_id ='29500.Sevk Yöntemi'></th>
						 <th><cf_get_lang dictionary_id ='58516.Ödeme Yöntemi'></th>
						 <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39401.Brüt Doviz'></th>
							 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='57677.Doviz'></th>
							 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
							 <cfif attributes.is_discount eq 1>
								 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39403.Isk Doviz'></th>
								 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
							 </cfif>
						 </cfif>
						 <th width="90" style="text-align:right;"><cf_get_lang dictionary_id='39381.Brüt Tutar'></th>
						 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 <cfif attributes.is_other_money eq 1>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39401.Brüt Doviz'></th>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='57677.Doviz'></th>
						 </cfif>
						 <th width="90" style="text-align:right;"><cf_get_lang dictionary_id='29534.Toplam Tutar'></th>
						 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 <cfif attributes.is_discount eq 1>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39382.Isk Tutar'></th>
							 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 </cfif>
						 <th style="text-align:right;">%</th>
					 </tr>
				 </thead>
				 <tbody>
					 <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					 <tr>
						 <td>#currentrow#</td>
						 <td><cfset fuse_type = 'sales'>
							 <cfif is_instalment eq 1>
								 <cfset page_type = 'upd_fast_sale'>
							 <cfelse>
								 <cfset page_type = 'list_order&event=upd'>
							 </cfif>
							 <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#fuse_type#.#page_type#&order_id=#order_id#','wide');" class="tableyazi">
								#ORDER_NUMBER#
							 </a>
						 </td>
						 <cfif xml_reference_code eq 1>
							 <td>#REF_NO#</td>
						 </cfif>
						 <td>#ORDER_HEAD#</td>
						 <td>#dateformat(ORDER_DATE,dateformat_style)#</td>
						 <td>#DateFormat(SHIP_DATE,dateformat_style)#</td>
						 <td>#dateformat(DELIVERDATE_,dateformat_style)#</td>
						 <td>
							 <cfif len(order_stage)>
								 #get_stage.STAGE[listfind(stage_id_list,order_stage,',')]#
							 </cfif>
						 </td>
						 <td>
							 <cfif len(SALES_ADD_OPTION_ID)>
								 #get_sale_add_options.SALES_ADD_OPTION_NAME[listfind(sales_add_option_list,SALES_ADD_OPTION_ID,',')]#
							 </cfif>
						 </td>
						 <td>
							 <cfif MEMBER_TYPE eq 1><!--- kurumsallar icin --->
								 <a href="javascript://"  class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#COMPANY_ID#','list')">#MUSTERI#</a>
							 <cfelse>
								 <a href="javascript://"  class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#COMPANY_ID#','list')">#MUSTERI#</a>
							 </cfif>
						 </td>
						 <cfif attributes.is_project eq 1>
							 <td><cfif len(get_total_purchase.project_id) and listfind(project_id_list,get_total_purchase.project_id,',')>
									 <a href="#request.self#?fuseaction=project.projects&event=det&id=#project_id#" class="tableyazi">#get_project.project_head[listfind(project_id_list,get_total_purchase.project_id,',')]#</a>
								 </cfif>
							 </td>
						 </cfif>
						 <td><cfif len(city_id)>#get_order_city.CITY_NAME[listfind(order_city_id_list,city_id,',')]#</cfif></td>
						 <td><cfif len(county_id)>#get_order_county.COUNTY_NAME[listfind(order_county_id_list,county_id,',')]#</cfif></td>
						 <td>#ORDER_DETAIL#</td>
						 <td><cfif len(order_employee_id)>#get_emp.EMPLOYEE[listfind(order_employee_id_list,ORDER_EMPLOYEE_ID,',')]#</cfif></td>
						 <td>
							 <cfif len(SALES_PARTNER_ID)>
								 #get_sales_partner.SALES_PARTNER[listfind(sales_partner_id_list,SALES_PARTNER_ID,',')]#
							 <cfelseif len(SALES_CONSUMER_ID)>
								 #get_sales_consumer.SALES_CONSUMER[listfind(sales_consumer_id_list,SALES_CONSUMER_ID,',')]#
							 </cfif><!--- satış ortağı --->
						 </td>
						 <td><cfif len(ship_method)>#get_ship_method.SHIP_METHOD[listfind(ship_method_id_list,SHIP_METHOD,',')]#</cfif><!--- sevk yöntemi ---></td>
						 <td><cfif len(paymethod)>#get_paymethod.PAYMETHOD[listfind(paymethod_list,PAYMETHOD,',')]#</cfif><!--- ödeme yöntemi ---></td>
						 <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
							<td style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ)# </td>
							<td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
							<td style="text-align:right;">#TLFormat(PRICE_DOVIZ)# </td>
							<td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
							<cfif attributes.is_discount eq 1>
								<td style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ-PRICE_DOVIZ)# </td>
								<td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
							</cfif>
						 </cfif>
						 <td style="text-align:right;">
							 #TLFormat(GROSSTOTAL)#<cfif len(GROSSTOTAL)><cfset total_grosstotal = GROSSTOTAL + total_grosstotal></cfif></td>
						 <td style="text-align:center">#session.ep.money#</td>
						 <cfif attributes.is_other_money eq 1>
							 <td style="text-align:right;">
								 #TLFormat(GROSSTOTAL_DOVIZ)#
								 <cfset 'total_grosstotal_doviz_#other_money#' = evaluate('total_grosstotal_doviz_#other_money#') + GROSSTOTAL_DOVIZ>
							 </td>
							 <td style="text-align:center">#other_money#</td>
						 </cfif>
						 <td style="text-align:right;">
							 #TLFormat(NETTOTAL)#
							 <cfset toplam_satis =toplam_satis+NETTOTAL>
						 </td>
						 <td style="text-align:center;">#SESSION.EP.MONEY#</td>
						 <cfif attributes.is_discount eq 1>
							 <td style="text-align:right;">#TLFormat(DISCOUNT)#<cfset toplam_discount=DISCOUNT+toplam_discount> </td>
							 <td style="text-align:center;">#SESSION.EP.MONEY#</td>
						 </cfif>
						 <td style="text-align:right;"><cfif len(price) and butun_toplam neq 0>#Replace(NumberFormat(NETTOTAL*100/butun_toplam,"00.00"),".",",")#</cfif></td>
					 </tr>
					 </cfoutput>
				 </tbody>
				 <cfelseif get_total_purchase.recordcount and attributes.report_type eq 19>
				 <thead>
					 <tr>
						 <th height="22"><cf_get_lang dictionary_id='58964.Fiyat Listesi'></th>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></th>
						 <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39401.Brüt Doviz'></th>
							 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='57677.Doviz'></th>
							 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
							 <cfif attributes.is_discount eq 1>
								 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39403.Isk Doviz'></th>
								 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
							 </cfif>
						 </cfif>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='39381.Brüt Tutar'></th>
						 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
						 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 <cfif attributes.is_discount eq 1>
							 <th width="75" style="text-align:right;"><cf_get_lang dictionary_id='39382.Isk Tutar'></th>
							 <th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
						 </cfif>
						 <th style="text-align:right;">%</th>
					 </tr>
				 </thead>  
				 <tbody>
					 <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					 <tr>
						 <td>
						 <cfif len(price_cat_list) and len(price_cat) and price_cat gt 0>
							 #get_price_cat.price_cat[listfind(price_cat_list,price_cat,',')]#
						 <cfelseif price_cat eq -2>
							 <cf_get_lang dictionary_id='58721.Standart Satis'>
						 <cfelseif price_cat eq -1>
							 <cf_get_lang dictionary_id='58722.Standart Alis'>
						 </cfif>
						 </td>
						 <td style="text-align:right;">#TLFormat(PRODUCT_STOCK,4)#
						 <cfif len(PRODUCT_STOCK)>
							 <cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar>
						 </cfif>
						 </td>
						 <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
							 <td style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ)# </td>
							 <td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
							 <td style="text-align:right;">#TLFormat(PRICE_DOVIZ)#</td>
							 <td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
							 <cfif attributes.is_discount eq 1>
								 <td style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ-PRICE_DOVIZ)#</td>
								 <td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></td>
							 </cfif>
						 </cfif>
						 <td style="text-align:right;">#TLFormat(GROSSTOTAL)#<cfset total_grosstotal=GROSSTOTAL+total_grosstotal></td>
						 <td style="text-align:center;">#session.ep.money#</td>
						 <td style="text-align:right;">#TLFormat(PRICE)# <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif></td>
						 <td style="text-align:center;">#session.ep.money#</td>
						 <cfif attributes.is_discount eq 1>
							 <td style="text-align:right;">#TLFormat(DISCOUNT)#<cfset toplam_discount=DISCOUNT+toplam_discount></td>
							 <td style="text-align:center;">#session.ep.money#</td>
						 </cfif>
						 <td style="text-align:right;"><cfif len(price) and butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
					 </tr>
					 </cfoutput>
				 </tbody>
			 <cfelseif get_total_purchase.recordcount and attributes.report_type eq 23>
				 <cfif isdefined("attributes.model_month") and len(attributes.model_month)>
					 <thead>
						 <tr>
							 <th><cf_get_lang dictionary_id='58724.Ay'></th>
							 <th><cf_get_lang dictionary_id='58225.Model'></th>
							 <th><cf_get_lang dictionary_id='57635.Miktar'></th>
							 <th><cf_get_lang dictionary_id='57636.Birim'></th>
							 <th><cf_get_lang dictionary_id='57673.Tutar'></th>
						 </tr>
					 </thead>
					 <tbody>
						 <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							 <tr>
								 <td>#ORDER_DATE_#</td>
								 <td>#MODEL_NAME#</td>
								 <td>#PRODUCT_STOCK#</td>
								 <td>#UNIT#</td>
								 <td>#TlFormat(PRICE,2)#</td>
							 </tr>
						 </cfoutput>
					 </tbody>
				 <cfelse>
					 <cfset fatura_aylar = ListDeleteDuplicates(valuelist(get_total_purchase.ORDER_DATE_))>
					 <cfset first_month = month(dateformat(attributes.date1,dateformat_style))>
					 <cfset last_month = month(dateformat(attributes.date2,dateformat_style))>
					 <thead>
						 <tr>
							 <cfoutput>
								 <cfif year(dateformat(attributes.date1,dateformat_style)) eq year(dateformat(attributes.date2,dateformat_style)) >
									 <cfloop index="aaa" from="#first_month#" to="#last_month#">
										 <th colspan="4" class="txtbold" style="text-align:center; width:400px;">#aaa#/#session.ep.period_year#</th>
									 </cfloop>
								 <cfelse>
									 <cfloop index="aaa" from="1" to="12">
										 <th colspan="4" class="txtbold" style="text-align:center; width:400px;">#aaa#/#session.ep.period_year#</th>
									 </cfloop>	
								 </cfif>
							 </cfoutput>
						 </tr> 
					 </thead>
					 <tbody>
						 <cfoutput>
							 <cfset tarih1 =dateformat(attributes.date1,dateformat_style)>
							 <cfset tarih2 =dateformat(attributes.date2,dateformat_style)>
						 </cfoutput>
						 <cfif DateDiff("m",tarih1,tarih2) gt listlen(fatura_aylar)>
							 <cfset empty_months = ''>
							 <cfloop index="aaa" from="#first_month#" to="#last_month#">
								 <cfif not listfindnocase(fatura_aylar,aaa,',')>
									 <cfset empty_months = listappend(empty_months,aaa)>
								 </cfif>
							 </cfloop>
							 <cfset kontrol_degiskeni=0>
							 <cfquery name="get_" datasource="#dsn#">
								 <CFLOOP list="#empty_months#" index="bbb">
								 <cfset ++kontrol_degiskeni>
									  SELECT
										 #bbb# AS ORDER_DATE_,
										 '<cfif len(attributes.MODEL_NAME)>#attributes.MODEL_NAME#<cfelse></cfif>' AS MODEL_NAME,
										 NULL AS PRODUCT_STOCK,
										 '' AS UNIT,
										 NULL AS PRICE
										 <cfif kontrol_degiskeni neq listlen(empty_months)>UNION</cfif>
								 </CFLOOP>
							 </cfquery>
							 <cfquery name="get_purch" dbtype="query">
								 SELECT
									 MODEL_NAME,
									 PRODUCT_STOCK,
									 UNIT,
									 ORDER_DATE_,
									 PRICE
								 FROM
									 get_total_purchase
								 UNION
								 SELECT
									 MODEL_NAME,
									 PRODUCT_STOCK,
									 UNIT,
									 ORDER_DATE_,
									 PRICE
								 FROM
									 get_
								 ORDER BY ORDER_DATE_
							 </cfquery>
						 <cfelse>
							 <cfquery name="get_purch" dbtype="query">
								 SELECT
									 MODEL_NAME,
									 PRODUCT_STOCK,
									 UNIT,
									 ORDER_DATE_,
									 PRICE
								 FROM
									 get_total_purchase
								 ORDER BY ORDER_DATE_    
							 </cfquery>
						 </cfif>
						 <cfoutput query="get_purch" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#" group="ORDER_DATE_">
							 <td colspan="4" valign="top">
								 <table cellpadding="0" cellspacing="0">
									 <thead>
										 <tr>
											 <th style="width:100px;" class="txtbold"><cf_get_lang dictionary_id='58225.MODEL'></th>
											 <th class="txtbold" style="text-align:right;width:100px;"><cf_get_lang dictionary_id='57635.MİKTAR'></th>
											 <th class="txtbold" style="text-align:right;width:100px;"><cf_get_lang dictionary_id='57636.BİRİM'></th>
											 <th class="txtbold" style="text-align:right;width:100px;"><cf_get_lang dictionary_id='57673.Tutar'></th>
										 </tr>
									 </thead>
									 <tbody>
										 <cfoutput>
											 <tr>
												 <td>#MODEL_NAME#</td>
												 <td>#PRODUCT_STOCK#</td>
												 <td>#UNIT#</td>
												 <td>#TlFormat(PRICE,2)#</td>
											 </tr>
										 </cfoutput>
									 </tbody>
								 </table>
							 </td>
						 </cfoutput>
					 </tbody>
				 </cfif>                
			 </cfif>
			 <cfoutput>
				 <cfif attributes.report_type neq 23>
					 <tfoot>
						 <tr>
							 <cfset colspan_ = 11>
							 <cfset colspan_doc = 16>
							 <cfset colspan_product = 5>
							 <cfset colspan_stock = 5>
							 <cfif isdefined("attributes.is_spect_info") and attributes.is_spect_info eq 1>
								 <cfset colspan_ = colspan_+2>
							 </cfif>
							 <cfif attributes.is_project eq 1>
								 <cfset colspan_ ++>
								 <cfset colspan_doc ++>
							 </cfif>
							 <cfif isdefined("x_show_special_code") and x_show_special_code eq 1>
								 <cfset colspan_ ++>
								 <cfset colspan_product ++>
								 <cfset colspan_stock ++>
							 </cfif>
							 <cfif xml_reference_code>
								 <cfset colspan_ ++>
								 <cfset colspan_doc ++>
							 </cfif>
							 <cfif xml_order_head>
								 <cfset colspan_ ++>
							 </cfif>
							 <cfif is_brand_show>
								 <cfset colspan_ ++>
								 <cfset colspan_product ++>
								 <cfset colspan_stock ++>
							 </cfif>
							 <cfif is_short_code_show>
								 <cfset colspan_ ++>
								 <cfset colspan_product ++>
								 <cfset colspan_stock ++>
							 </cfif>
							 <cfif attributes.report_type neq 7 and attributes.report_type neq 18>
								 <td colspan="
								 <cfif attributes.report_type eq 2>#colspan_product#
								 <cfelseif attributes.report_type eq 3>#colspan_stock#
								 <cfelseif attributes.report_type eq 1 or attributes.report_type eq 20 or attributes.report_type eq 24>2
								 <cfelseif attributes.report_type eq 17>#colspan_#
								 <cfelseif attributes.report_type eq 22> #colspan_doc#
								 <cfelseif listfind('16,15,14,13,12,11,10,9,8,4,6,5,19,21',attributes.report_type)>1
								 <cfelse><cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1><cfif attributes.is_discount>10<cfelse>8</cfif><cfelse><cfif attributes.is_discount>4<cfelse>4</cfif></cfif>
								 </cfif>" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></td>
								 <cfif attributes.report_type eq 17>
									 <td class="txtbold" style="text-align:right;">
										 <cfloop query="get_product_units">
											 <cfset unit_ = filterSpecialChars(get_product_units.unit)>
											 <cfif evaluate('toplam_#unit_#') gt 0>
												 #Tlformat(evaluate('toplam_#unit_#'))# <br/>
											 </cfif>
										 </cfloop>
									 </td>
									 <td class="txtbold" style="text-align:right;">#TLFormat(toplam_multiplier_amount_1,get_basket.AMOUNT_ROUND)#</td>
									 <cfif x_unit_weight eq 1>
										 <td class="txtbold" style="text-align:right;">#TLFormat(toplam_unit_weıght_1,4)#</td>
									 </cfif>
									 <td class="txtbold" style="text-align:center;">
										 <cfloop query="get_product_units">
											 <cfset unit_ = filterSpecialChars(get_product_units.unit)>
											 <cfif evaluate('toplam_#unit_#') gt 0>
												 #unit#<br/>
											 </cfif>
										 </cfloop>
									 </td>
									 <td class="txtbold" style="text-align:center;">
										 <cfloop query="get_product_units">
											 <cfset unit_ = filterSpecialChars(get_product_units.unit)>
											 <cfif evaluate('toplam_giden_#unit_#') gt 0>
												 #Tlformat(evaluate('toplam_giden_#unit_#'))# #get_product_units.unit#<br/>
											 </cfif>
										 </cfloop>
									 </td>
									 <td class="txtbold" style="text-align:center;">
										 <cfloop query="get_product_units">
											 <cfset unit_ = filterSpecialChars(get_product_units.unit)>
											 <cfif evaluate('toplam_kalan_#unit_#') gt 0>
												 #Tlformat(evaluate('toplam_kalan_#unit_#'))# #get_product_units.unit#<br/>
											 </cfif>
										 </cfloop>
									 </td>
									 <td class="txtbold" style="text-align:right;">#TLFormat(total_grosstotal)#</td>
									 <cfif isdefined("attributes.is_money_info") and attributes.is_money_info eq 1>
										 <td class="txtbold" style="text-align:right;">
											 <cfloop query="get_money">
												 <cfif evaluate("toplam_net_doviz_#money#") gt 0>
													 #TLFormat(evaluate("toplam_net_doviz_#money#"))#<br/>
												 </cfif>
											 </cfloop>
										 </td>
										 <td class="txtbold" style="text-align:center;">
											 <cfloop query="get_money">
												 <cfif evaluate("toplam_net_doviz_#money#") gt 0>
													 #money#<br/>
												 </cfif>
											 </cfloop>
										 </td>
									 </cfif>
									 <td class="txtbold" style="text-align:right;">&nbsp;
										 <cfif attributes.is_other_money eq 1>
										 <cfloop query="get_money">
											 <cfif evaluate("toplam_#money#") gt 0>
												 #TLFormat(evaluate("toplam_#money#"))#<br/>
											 </cfif>
										 </cfloop>
										 <cfelse>
											 #TLFormat(toplam_net_fiyet)#
										 </cfif>								
									 </td>
									 <td colspan="<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1><cfif attributes.is_discount>4<cfelse>2</cfif></cfif>"></td>
									 <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
										 <td class="txtbold" style="text-align:center;">
											 <cfloop query="get_money">
												 <cfif evaluate("toplam_kalan_tutar#money#") gt 0>
													 #money#<br/>
												 </cfif>
											 </cfloop>
										 </td>
										 <td>&nbsp;</td>
									 </cfif>
								 <cfelseif attributes.report_type eq 1 or attributes.report_type eq 20 or attributes.report_type eq 24>
									 <td class="txtbold" style="text-align:right;">#Tlformat(toplam_miktar)#</td>
									 <td class="txtbold" style="text-align:right;">#TLFormat(toplam_multiplier,4)#</td>
									 <td class="txtbold" style="text-align:right;">#TLFormat(total_grosstotal)#</td>
									 <td class="txtbold" style="text-align:center;">#session.ep.money#</td>
									 <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
									 <td colspan="<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1><cfif attributes.is_discount>8<cfelse>6</cfif><cfelse>2</cfif>"></td>
									 </cfif>
								 <cfelseif listfind('16,15,14,13,12,11,10,9,8,4,6,19,5,21',attributes.report_type)>
									 <td class="txtbold" style="text-align:right;">
										 #TLFormat(toplam_miktar)#
									 </td>
									 <td class="txtbold" style="text-align:right;">#TLFormat(total_grosstotal)#</td>
									 <td class="txtbold" style="text-align:center;">#session.ep.money#</td>
									 <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
										<td colspan="<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1><cfif attributes.is_discount>8<cfelse>6</cfif><cfelse>2</cfif>"></td>
									</cfif>
								 <cfelseif listfind('2,3',attributes.report_type)>
									 <td class="txtbold" style="text-align:right;">
										 <cfloop query="get_product_units">
											 <cfset unit_ = filterSpecialChars(get_product_units.unit)>
											 <cfif evaluate('toplam_#unit_#') gt 0>
												 #Tlformat(evaluate('toplam_#unit_#'))# <br/>
											 </cfif>
										 </cfloop>
									 </td>
									 <cfif x_unit_weight eq 1>
										 <td class="txtbold" style="text-align:right;">#TLFormat(toplam_unit_weıght,4)#</td>
									 </cfif>
									 <td class="txtbold" style="text-align:center;">#get_product_units.unit#</td>
									 <cfif x_show_second_unit>
										 <td class="txtbold" style="text-align:right;">
										 <cfset unit2_list = listdeleteduplicates(unit2_list)>
										 <cfloop list="#unit2_list#" index="cc">
											 <cfset unit2_ = filterSpecialChars(cc)>
											 #TLFormat(evaluate('toplam_ikinci_#unit2_#'))# <br>
										 </cfloop>
										 </td>
										 <td class="txtbold" style="text-align:center;">
											 <cfloop list="#unit2_list#" index="cc">
												 <cfset unit2_ = filterSpecialChars(cc)>
												 #unit2_# <br>
										 </cfloop>
										 </td>
									 </cfif>
									 <td class="txtbold" style="text-align:right;">
										 <cfloop query="get_product_units">
											 <cfset unit_ = filterSpecialChars(get_product_units.unit)>
											 <cfif evaluate('toplam_giden_#unit_#') gt 0>
												 #Tlformat(evaluate('toplam_giden_#unit_#'))# #get_product_units.unit#<br/>
											 </cfif>
										 </cfloop>
									 </td>
									 <td class="txtbold" style="text-align:right;">
										 <cfloop query="get_product_units">
											 <cfset unit_ = filterSpecialChars(get_product_units.unit)>
											 <cfif evaluate('toplam_kalan_#unit_#') gt 0>
												 #Tlformat(evaluate('toplam_kalan_#unit_#'))# #get_product_units.unit#<br/>
											 </cfif>
										 </cfloop>
									 </td>
									 <td class="txtbold" style="text-align:right;">#TLFormat(total_grosstotal)#</td>
									 <td class="txtbold" style="text-align:center;">#session.ep.money#</td>
									 <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
										 <td colspan="<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1><cfif attributes.is_discount>8<cfelse>6</cfif><cfelse>2</cfif>"></td>
										</cfif>
								 <cfelseif attributes.report_type eq 22>
									 <td class="txtbold" style="text-align:right;">
										 #TLFormat(total_grosstotal)# brüt tutar --->
									 </td>
									 <td class="txtbold" style="text-align:center;">#session.ep.money#</td>
									 <cfif isdefined("attributes.is_other_money") and attributes.is_other_money eq 1>
										 <td class="txtbold" style="text-align:right;">
											 <cfloop query="get_money">
												 <cfif evaluate("total_grosstotal_doviz_#money#") gt 0>
													 #TLFormat(evaluate("total_grosstotal_doviz_#money#"))#<br/>
												 </cfif>
											 </cfloop>
										 </td>
										 <td class="txtbold" style="text-align:center;">
											 <cfloop query="get_money">
												 <cfif evaluate("total_grosstotal_doviz_#money#") gt 0>
													 #money#<br/>
												 </cfif>
											 </cfloop>
										 </td>
									 </cfif>
								 </cfif>
								 <td class="txtbold" style="text-align:right;">#TLFormat(toplam_satis)#</td>
								 <cfif attributes.report_type eq 17>
									 <td class="txtbold" style="text-align:right;">
										 <cfif attributes.is_other_money eq 1>
											 <cfloop query="get_money">
												 <cfif evaluate("toplam_kalan_tutar#money#") gt 0>
													 #TLFormat(evaluate("toplam_kalan_tutar#money#"))#<br/>
												 </cfif>
											 </cfloop>
										 <cfelse>
											 #TLFormat(toplam_kalan_tutar)#
										 </cfif>
									 </td>
								 </cfif>
								 <td class="txtbold" style="text-align:center;">#session.ep.money#</td>
								 <cfif listfind('2,3',attributes.report_type)>
									 <td class="txtbold" style="text-align:right;">#TLFormat(toplam_kalan_tutar)#</td>
									 <td class="txtbold" style="text-align:center;">#session.ep.money#</td>
								 </cfif>
								 <cfif attributes.is_discount eq 1>
									<td class="txtbold" style="text-align:right;">#TLFormat(toplam_discount)#</td>
									<td class="txtbold" style="text-align:center;">#session.ep.money#</td>
								 </cfif>
								 <td class="txtbold" style="text-align:right;"><cfif butun_toplam neq 0>#TLFormat(toplam_satis*100/butun_toplam)#</cfif></td>
							 <cfelseif attributes.report_type eq 7>
								 <td class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></td>
								 <td class="txtbold" style="text-align:right;"><cfif isdefined('emp_total_')>#TLFormat(emp_total_)#<cfelse>#TLFormat(0)#</cfif></td>
									 <cfif isdefined('emp_total_')>
										 <cfset toplam=emp_total_>
									 <cfelse>
										 <cfset toplam=0>
									 </cfif>
									 <cfif isdefined('branch_list')>
									 <cfloop list="#branch_list#" index="branch_index" delimiters=";">
										 <td class="txtbold" style="text-align:right;">
											 #TLFormat(evaluate('branch_total_#filterSpecialChars(branch_index)#'))#
										 </td>
										 <cfset toplam=toplam+evaluate('branch_total_#filterSpecialChars(branch_index)#')>
									 </cfloop>
									 </cfif>
									 <td class="txtbold" style="text-align:right;">#TLFormat(total_grosstotal)#</td>
								 </tr>
								 <tr height="25" class="color-list">
									 <td class="txtbold" style="text-align:right"><cf_get_lang dictionary_id ='57680.Genel Toplam'></td>
									 <td colspan="<cfif isdefined('branch_list')>#listlen(branch_list,';')+2#<cfelse>2</cfif>" class="txtbold" style="text-align:center;">&nbsp; #TLFormat(toplam)# #session.ep.money#</td>
								 </tr>
							 <cfelse>
								 <tr>
									 <td class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></td>
									 <cfset toplam=0>
									 <cfif isdefined('emp_list')>
									 <cfloop list="#emp_list#" index="emp_index" delimiters=";">
										 <td class="txtbold" style="text-align:right;">
											 #TLFormat(evaluate('emp_total_#filterSpecialChars(emp_index)#'))#
										 </td>
										 <cfset toplam=toplam+evaluate('emp_total_#filterSpecialChars(emp_index)#')>
									 </cfloop>
									 </cfif>
									 <td class="txtbold"></td>
								 </tr>
								 <tr height="25" class="color-list">
									 <td class="txtbold" style="text-align:right"><cf_get_lang dictionary_id ='57680.Genel Toplam'></td>
									 <td colspan="<cfif isdefined('emp_list')>#listlen(emp_list,';')+2#<cfelse>2</cfif>" class="txtbold" style="text-align:right;" >#TLFormat(toplam)# #session.ep.money#</td>
								 </tr>
							 </cfif>
						 </tr>
					 </tfoot> 
				 </cfif>
			 </cfoutput>
			</cf_report_list>
	
	
	
 </cfif>
 <cfif attributes.report_type neq 7 and attributes.report_type neq 18>
	 <cfset adres = "">
	 <cfif isdefined("attributes.form_submitted") and attributes.totalrecords gt attributes.maxrows>
		 <cfset adres = "#attributes.fuseaction#&form_submitted=1">	
		 <cfif len(attributes.report_sort)>
			 <cfset adres = "#adres#&report_sort=#attributes.report_sort#">
		 </cfif>
		 <cfif len(attributes.product_id)>
			 <cfset adres = "#adres#&product_id=#attributes.product_id#&product_name=#attributes.product_name#">
		 </cfif>
		 <cfif len(attributes.row_employee_id) and len(attributes.row_employee)>
			 <cfset adres = "#adres#&row_employee_id=#attributes.row_employee_id#&row_employee=#attributes.row_employee#">
		 </cfif> 
		 <cfif len(attributes.employee_id) and len(attributes.employee)>
			 <cfset adres = "#adres#&employee_id=#attributes.employee_id#&employee=#attributes.employee#">
		 </cfif> 
		 <cfif len(attributes.keyword)>
			 <cfset adres = "#adres#&keyword=#attributes.keyword#">
		 </cfif>
		 <cfif len(attributes.brand_name) and len(attributes.brand_id)>
			 <cfset adres = "#adres#&brand_id=#attributes.brand_id#&brand_name=#attributes.brand_name#">
		 </cfif> 
		 <cfif len(attributes.model_name) and len(attributes.model_id)>
			 <cfset adres = "#adres#&model_id=#attributes.model_id#&model_name=#attributes.model_name#">
		 </cfif> 
		 <cfif len(attributes.employee_name) and len(attributes.product_employee_id)>
			 <cfset adres = "#adres#&employee_name=#attributes.employee_name#&product_employee_id=#attributes.product_employee_id#">
		 </cfif>
		 <cfif Len(attributes.sales_member) and Len(attributes.sales_member_id)>
			 <cfset adres = "#adres#&sales_member=#attributes.sales_member#&sales_member_type=#attributes.sales_member_type#&sales_member_id=#attributes.sales_member_id#">
		 </cfif>
		 <cfif len(attributes.sup_company_id)>
			 <cfset adres = "#adres#&sup_company_id=#attributes.sup_company_id#&sup_company=#attributes.sup_company#">
		 </cfif>
		 <cfif len(attributes.company_id)>
			 <cfset adres = "#adres#&company_id=#attributes.company_id#&company=#attributes.company#">
		 </cfif>
		 <cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
			 <cfset adres = "#adres#&consumer_id=#attributes.consumer_id#&company=#attributes.company#">
		 </cfif>
		 <cfif len(attributes.pos_code_text)>
			 <cfset adres = "#adres#&pos_code=#attributes.pos_code#&pos_code_text=#attributes.pos_code_text#">
		 </cfif>
		 <cfif len(attributes.search_product_catid)>
			 <cfset adres = "#adres#&search_product_catid=#attributes.search_product_catid#&product_cat=#attributes.product_cat#">
		 </cfif>
		 <cfif len(attributes.date1)>
			 <cfset adres = "#adres#&date1=#attributes.date1#">
		 </cfif>
		 <cfif len(attributes.date2)>
			 <cfset adres = "#adres#&date2=#attributes.date2#">
		 </cfif>
		 <cfif len(attributes.termin_date1)>
			 <cfset adres = "#adres#&termin_date1=#attributes.termin_date1#">
		 </cfif>
		 <cfif len(attributes.termin_date2)>
			 <cfset adres = "#adres#&termin_date2=#attributes.termin_date2#">
		 </cfif>
		 <cfif len(attributes.report_type)>
			 <cfset adres = "#adres#&report_type=#attributes.report_type#">
		 </cfif>
		 <cfif len(attributes.zone_id)>
			 <cfset adres = "#adres#&zone_id=#attributes.zone_id#">
		 </cfif>
		 <cfif len(attributes.resource_id)>
			 <cfset adres = "#adres#&resource_id=#attributes.resource_id#">
		 </cfif>
		 <cfif len(attributes.ims_code_id)>
			 <cfset adres = "#adres#&ims_code_id=#attributes.ims_code_id#">
		 </cfif>
		 <cfif len(attributes.customer_value_id)>
			 <cfset adres = "#adres#&customer_value_id=#attributes.customer_value_id#">
		 </cfif>
		 <cfif len(attributes.country_id)>
			 <cfset adres="#adres#&country_id=#attributes.country_id#">
		 </cfif>
		 <cfif len(attributes.segment_id)>
			 <cfset adres = "#adres#&segment_id=#attributes.segment_id#">
		 </cfif>
		 <cfif isDefined("attributes.is_kdv") and len(attributes.is_kdv)>
			 <cfset adres = "#adres#&is_kdv=#attributes.is_kdv#">
		 </cfif>
		 <cfif isDefined("attributes.is_prom") and len(attributes.is_prom)>
			 <cfset adres = "#adres#&is_prom=#attributes.is_prom#">
		 </cfif>
		 <cfif isDefined("attributes.is_other_money") and len(attributes.is_other_money)>
			 <cfset adres = "#adres#&is_other_money=#attributes.is_other_money#">
		 </cfif>
		 <cfif isDefined("attributes.is_money2") and len(attributes.is_money2)>
			 <cfset adres = "#adres#&is_money2=#attributes.is_money2#">
		 </cfif>
		 <cfif isDefined("attributes.is_iptal") and len(attributes.is_iptal)>
			 <cfset adres = "#adres#&is_iptal=#attributes.is_iptal#">
		 </cfif>
		 <cfif isDefined("attributes.is_discount") and len(attributes.is_discount)>
			 <cfset adres = "#adres#&is_discount=#attributes.is_discount#">
		 </cfif>
		 <cfif isDefined("attributes.member_cat_type") and len(attributes.member_cat_type)>
			 <cfset adres = "#adres#&member_cat_type=#attributes.member_cat_type#">
		 </cfif>
		 <cfif isDefined("attributes.project_id") and len(attributes.project_id)>
			 <cfset adres = "#adres#&project_id=#attributes.project_id#">
		 </cfif>
		 <cfif isDefined("attributes.project_head") and len(attributes.project_head)>
			 <cfset adres = "#adres#&project_head=#attributes.project_head#">
		 </cfif>
		 <cfif isDefined("attributes.kontrol") and len(attributes.kontrol)>
			 <cfset adres = "#adres#&kontrol=#attributes.kontrol#">
		 </cfif>
		 <cfif isDefined("attributes.department_id") and len(attributes.department_id)>
			 <cfset adres = "#adres#&department_id=#attributes.department_id#">
		 </cfif>
		 <cfif isDefined("attributes.status") and len(attributes.status)>
			 <cfset adres = "#adres#&status=#attributes.status#">
		 </cfif>
		 <cfif len(attributes.graph_type)>
			 <cfset adres = "#adres#&graph_type=#attributes.graph_type#">
		 </cfif>
		 <cfif len(attributes.order_process_cat)>
			 <cfset adres = "#adres#&order_process_cat=#attributes.order_process_cat#">
		 </cfif>
		 <cfif len(attributes.order_stage)>
			 <cfset adres = "#adres#&order_stage=#attributes.order_stage#">
		 </cfif>
		 <cfif isDefined("attributes.sector_cat_id") and len(attributes.sector_cat_id)>
			 <cfset adres = "#adres#&sector_cat_id=#attributes.sector_cat_id#">
		 </cfif>
		 <cfif isDefined("attributes.fatura_kontrol") and len(attributes.fatura_kontrol)>
			 <cfset adres = "#adres#&fatura_kontrol=#attributes.fatura_kontrol#">
		 </cfif>
		 <cfif isDefined("attributes.irsaliye_kontrol") and len(attributes.irsaliye_kontrol)>
			 <cfset adres = "#adres#&irsaliye_kontrol=#attributes.irsaliye_kontrol#">
		 </cfif>
		 <cfif isDefined("attributes.is_money_info") and len(attributes.is_money_info)>
			 <cfset adres = "#adres#&is_money_info=#attributes.is_money_info#">
		 </cfif>
		 <cfif isDefined("attributes.is_project") and len(attributes.is_project)>
			 <cfset adres = "#adres#&is_project=#attributes.is_project#">
		 </cfif>
		 <cfif isDefined("attributes.branch_id") and len(attributes.branch_id)>
			 <cfset adres = "#adres#&branch_id=#attributes.branch_id#">
		 </cfif>
		 <cfif isDefined("attributes.is_spect_info") and len(attributes.is_spect_info)>
			 <cfset adres = "#adres#&is_spect_info=#attributes.is_spect_info#">
		 </cfif>
		 <cfif isDefined("attributes.model_month") and len(attributes.model_month)>
			 <cfset adres = "#adres#&model_month=#attributes.model_month#">
		 </cfif>
		 <cf_paging page="#attributes.page#" 
					 maxrows="#attributes.maxrows#"
					 totalrecords="#attributes.totalrecords#"
					 startrow="#attributes.startrow#"
					 adres="#adres#">
	 </cfif>
 </cfif>
 <cfif isdefined("attributes.form_submitted") and len(attributes.graph_type) and isdefined('get_total_purchase.recordcount') and get_total_purchase.recordcount>
	 <table width="98%" cellpadding="2" cellspacing="1" border="0" style="text-align:center;" class="color-border">
		 <tr class="color-row">
			 <td style="text-align:center;">
			 <cfif isDefined("form.graph_type") and len(form.graph_type)>
				 <cfset graph_type = form.graph_type>
			 <cfelse>
				 <cfset graph_type = "bar">
			 </cfif>
			 <script src="JS/Chart.min.js"></script> 
				 <cfoutput query="get_total_purchase"startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					 <cfset 'sum_of_total#currentrow#' =  NumberFormat(PRICE*100/butun_toplam,'00.00')>
					 <!--- Kategori Bazinda ise --->
					 <cfif attributes.report_type eq 1 or attributes.report_type eq 20 or attributes.report_type eq 24>
						 <cfset item_value = PRODUCT_CAT >
					 <!--- ürün Bazinda ise --->
					 <cfelseif attributes.report_type eq 2>
						 <cfset item_value = left(PRODUCT_NAME,30)>
					 <!--- Stok Bazinda --->
					 <cfelseif attributes.report_type eq 3>
						 <cfset item_value = left('#PRODUCT_NAME#&nbsp;#PROPERTY#',30)>
					 <!--- Müsteri Bazinda --->
					 <cfelseif attributes.report_type eq 4 or attributes.report_type eq 24>
						 <cfset item_value = left(MUSTERI,30)>
					 <!--- Müsteri Tipi Bazinda --->
					 <cfelseif attributes.report_type eq 5>
						 <cfset item_value = left(MUSTERI_TYPE,30)>
					 <!--- Tedarikci Bazinda --->
					 <cfelseif attributes.report_type eq 6>
						 <cfset item_value = left(NICKNAME,30)>
					 <!--- Sube Bazinda --->
					 <cfelseif attributes.report_type eq 7>
						 <cfset item_value = left(BRANCH_NAME,30)>
					 <!--- Satis Yapan Bazinda --->
					 <cfelseif attributes.report_type eq 8>
						 <cfset item_value = left('#EMPLOYEE_NAME#&nbsp;#EMPLOYEE_SURNAME#',30)>
					 <!--- Marka Bazinda --->
					 <cfelseif attributes.report_type eq 9>
						 <cfset item_value = left(BRAND_NAME,30)>
					 <!--- Musteri Degeri Bazinda --->
					 <cfelseif attributes.report_type eq 10>
						 <cfset item_value = left(GET_CUSTOMER_VALUE_2.CUSTOMER_VALUE[listfind(list_customer_val_ids,CUSTOMER_VALUE_ID,',')],30)>
					 <!--- Iliski Tipi Bazinda --->
					 <cfelseif attributes.report_type eq 11>
						 <cfset item_value = left(GET_RESOURCE_2.RESOURCE[listfind(list_resource_ids,RESOURCE_ID,',')],30)>
					 <!--- Mikro Bolge Bazinda --->
					 <cfelseif attributes.report_type eq 12>
						 <cfset item_value = left(IMS_CODE_NAME,30)>
					 <!--- Satis Bolgesi Bazinda --->
					 <cfelseif attributes.report_type eq 13>
						 <cfset item_value = left(SZ_2.SZ_NAME[listfind(list_zone_ids,ZONE_ID,',')],30)>
					 <!--- odeme Yontemi Bazinda --->
					 <cfelseif attributes.report_type eq 14>
						 <cfif len(PAYMETHOD) and listfind(list_pay_ids,PAYMETHOD,',')>
							 <cfset item_value = left('#GET_PAY_METHOD.PAYMETHOD[listfind(list_pay_ids,PAYMETHOD,',')]#',30)>
						 <cfelseif len(CARD_PAYMETHOD_ID) and listfind(list_cc_pay_ids,CARD_PAYMETHOD_ID,',')>
							 <cfset item_value =left('#GET_CC_METHOD.CARD_NO[listfind(list_cc_pay_ids,CARD_PAYMETHOD_ID,',')]#',30)>
						 <cfelse>
							 <cfset item_value =	left('**ÖY:#PAYMETHOD# KK ÖY:#CARD_PAYMETHOD_ID#**',30)>
						 </cfif>
					 <!---Hedef Pazar Bazinda --->
					 <cfelseif attributes.report_type eq 15>
						 <cfset item_value = left(GET_SEGMENTS_2.PRODUCT_SEGMENT[listfind(list_segment_ids,get_total_purchase.SEGMENT_ID,',')],30)>
					 <!---Il Bazinda --->
					 <cfelseif attributes.report_type eq 16>
						 <cfset item_value = left(get_city.city_name[listfind(city_id_list,get_total_purchase.city,',')],30)>
					 <!---Belge ve Stok Bazinda --->
					 <cfelseif attributes.report_type eq 17>
						 <cfset item_value = left(ORDER_NUMBER,30)>
					 <!---Musteri temsilcisi ve sube bazinda --->
					 <cfelseif attributes.report_type eq 18>
						 <cfset item_value = left(EMP_NAME,30)>
					 <cfelseif attributes.report_type eq 19>
						 <cfif len(price_cat_list) and len(price_cat) and price_cat gt 0>
							 <cfset item_value = left(get_price_cat.price_cat[listfind(price_cat_list,price_cat,',')],30)>
						 <cfelseif price_cat eq -2>
							 <cfset item_value = getLang('main',1309)>
						 <cfelseif price_cat eq -1>
							 <cfset item_value = getLang('main',1310)>
						 <cfelse>
							 <cfset item_value = "">
						 </cfif>
					 <!--- Satis Ortagi Bazinda FBS --->
					 <cfelseif attributes.report_type eq 21>
						 <cfif len(sales_member_id) and sales_member_type eq 1 and len(sales_partner_list)>
							 <cfset item_value = left('#get_partner_name.company_partner_name[listfind(sales_partner_list,sales_member_id,',')]#&nbsp;#get_partner_name.company_partner_surname[listfind(sales_partner_list,sales_member_id,',')]#',40)>
						 <cfelseif len(sales_member_id) and sales_member_type eq 2 and len(sales_consumer_list)>
							 <cfset item_value = left('#get_consumer_name.consumer_name[listfind(sales_consumer_list,sales_member_id,',')]# #get_consumer_name.consumer_surname[listfind(sales_consumer_list,sales_member_id,',')]#',40)>
						  <cfelse>
							 <cfset item_value = ''>
						 </cfif>
					 </cfif>
						 <cfset 'item_#currentrow#' = "#item_value#">
						 <cfset 'value_#currentrow#' = "#wrk_round(Evaluate("sum_of_total#currentrow#"))#">
				  </cfoutput>
				  <canvas id="myChart" style="float:left;max-width:600px;max-height:600px;"></canvas>
				  <script>
					 var ctx = document.getElementById('myChart');
						 var myChart = new Chart(ctx, {
							 type: '<cfoutput>#graph_type#</cfoutput>',
							 data: {
								 labels: [<cfloop from="1" to="#get_total_purchase.recordcount#" index="jj">
												  <cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
								 datasets: [{
									 label: "<cfoutput>#getLang('main',2275)#</cfoutput>",
									 backgroundColor: [<cfloop from="1" to="#get_total_purchase.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
									 data: [<cfloop from="1" to="#get_total_purchase.recordcount#" index="jj"><cfoutput>#NumberFormat(evaluate("value_#jj#"),'00')#</cfoutput>,</cfloop>],
								 }]
							 },
							 options: {}
					 });
				  </script>
			 </td>
		 </tr>
	 </table>
	 <br />
 </cfif>
</div>
 <script type="text/javascript">
 	<cfif attributes.is_excel eq 1>
		$(function(){TableToExcel.convert(document.getElementById('order-list'));});
	</cfif>
	 function set_the_report()
	 {
		 rapor.report_type.checked = false;
	 }
	 function type_gizle()
	 {
		 if (rapor.report_type.value == 17)
		 {
			 //rapor.kontrol.value = 1;
			 document.getElementById('is_spect_info').disabled = false;
			 document.getElementById('is_money_info').disabled = false;
		 }
		 else
		 {
			 document.getElementById('is_spect_info').disabled = true;
			 document.getElementById('is_money_info').disabled = true;
		 }
		 if (rapor.report_type.value == 17 || rapor.report_type.value == 22)
		 {
			 document.getElementById('is_project').disabled = false;
		 }
		 else
		 {
			 document.getElementById('is_project').disabled = true;
		 }
		 if (rapor.report_type.value == 22)
		 {
			 ship_address.style.display = '';
			 ship_address2.style.display = '';
			 document.getElementById('is_prom').disabled = true;
			 document.getElementById('is_iptal').disabled = true;
		 }
		 else
		 {
			 ship_address.style.display = 'none';
			 ship_address2.style.display = 'none';
			 document.getElementById('is_prom').disabled = false;
			 document.getElementById('is_iptal').disabled = false;
		 }
		 if (rapor.report_type.value == 7 || rapor.report_type.value == 18)
		 {
			 document.getElementById('is_other_money').disabled = true;
		 }
		 else
			 document.getElementById('is_other_money').disabled = false;
		 if (rapor.report_type.value == 23)
		 {	
			document.getElementById('model_month_td').style.display = '';	
		 }
		 else
		 {
			 document.getElementById('model_month_td').style.display = 'none';
			 document.rapor.model_month.checked = false
		 }
	 }
	 function kontrol_form()
	 {
		 
		 <cfif isdefined("x_branch_required") and x_branch_required eq 1> 
		 if(document.rapor.branch_id.value == "")
		 {
			 alert("<cf_get_lang dictionary_id ='30126.Sube seciniz'>");
			 return false;
		 }
		 </cfif> 
 
		 var department_id = document.rapor.department_id.options.length;	
		 var department_name = '';
		 for(i=0;i<department_id;i++)
		 {
			 if(document.rapor.department_id.options[i].selected && department_name.length==0)
				 department_name = department_name + document.rapor.department_id.options[i].value;
			 else if(document.rapor.department_id.options[i].selected)
				 department_name = department_name + ',' + document.rapor.department_id.options[i].value;
		 }
		 if (rapor.report_type.value == 18 && (rapor.department_id.value == '' || list_len(department_name,',') > 1))
		 {
			 alert("<cf_get_lang dictionary_id ='40289.Musteri Temsilcisi ve Sube Bazinda Rapor Almak Icin Bir Depo Secmelisiniz '>!");
			 return false;
		 }
		 
	

		 if(document.rapor.is_excel.checked==false)
		{
			document.rapor.action="<cfoutput>#request.self#?fuseaction=report.sale_analyse_report_orders</cfoutput>"
			return true;
		}
		else $('#maxrows').val('<cfoutput>#get_total_purchase.recordcount#</cfoutput>');
 
	 }
 </script>
 <cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">