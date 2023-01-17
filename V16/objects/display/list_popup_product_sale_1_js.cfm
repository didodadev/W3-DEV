<cfsetting showdebugoutput="yes">
<cfparam name="attributes.page" default=1>
<cfif not isNumeric(attributes.maxrows)>
	<cfset attributes.maxrows = session_base.maxrows>
</cfif>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined('attributes.is_lot_no_based')>
	<cfset is_lot_no_based = attributes.is_lot_no_based>
</cfif>
<cfif isdefined('attributes.round_number')>
	<cfset round_number = attributes.round_number>
</cfif>
<cfparam name="attributes.product_catid" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.barcode" default="">
<cfparam name="attributes.serial_number" default="">
<cfparam name="attributes.manufacturer_code" default="">
<cfparam name="attributes.price_catid" default="">
<cfparam name="attributes.search_company_id" default="">
<cfparam name="attributes.pos_code" default="">
<cfif isdefined("xml_sort_type")>
	<cfparam name="attributes.sort_type" default="#xml_sort_type#">
<cfelse>
	<cfparam name="attributes.sort_type" default="0">
</cfif>
<cfparam name="attributes.keyword2" default="">

<cfif isdefined('xml_use_project_filter') and xml_use_project_filter eq 1><!--- xmlde proje filtresi secilmisse --->
	<cfif isdefined("attributes.projects_id") and Len(attributes.projects_id)>
		<cfset project_id_ = attributes.projects_id>
		<cfset project_head_ = get_project_name(attributes.projects_id)>
	<cfelse>
		<cfset project_id_ = "">
		<cfset project_head_ = "">
	</cfif>
	<cfparam name="attributes.projects_id" default="#project_id_#">
	<cfparam name="attributes.project_head" default="#project_head_#">
</cfif>

<cfset dept_loc_info_=''>
<cfif not isdefined('attributes.departmen_location_info') and isdefined('xml_use_dept_default_value') and xml_use_dept_default_value eq 2 and len(session.ep.user_location)><!--- kullanıcı depo bilgisi --->
	<cfset dept_loc_info_=session.ep.user_location>
<cfelseif not isdefined('attributes.departmen_location_info') and isdefined('xml_use_dept_default_value') and xml_use_dept_default_value eq 1>
	<cfif isdefined('attributes.department_out') and len(attributes.department_out) and isdefined('attributes.location_out') and len(attributes.location_out)><!--- belgede seçilen çıkış depo --->
		<cfset dept_loc_info_='#attributes.department_out#-#attributes.location_out#'>
    <cfelseif isdefined('attributes.department_in') and len(attributes.department_in) and isdefined('attributes.location_in') and len(attributes.location_in)><!--- belgede seçilen giriş depo ---> 
    	<cfset dept_loc_info_='#attributes.department_in#-#attributes.location_in#'>
    </cfif>       
<cfelseif isdefined('attributes.departmen_location_info')>
	<cfset dept_loc_info_=attributes.departmen_location_info>
</cfif>
<cfparam name="attributes.departmen_location_info" default="#dept_loc_info_#">
<cfquery name="GET_DEPARTMENT" datasource="#DSN#">
	SELECT
		DEPARTMENT_ID,
		DEPARTMENT_HEAD,
		D.DEPARTMENT_STATUS
	FROM
		BRANCH B,
		DEPARTMENT D
	WHERE
		B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		B.BRANCH_ID = D.BRANCH_ID AND
		D.IS_STORE <> 2 AND
		D.DEPARTMENT_STATUS = 1 AND
		B.BRANCH_ID IN (SELECT BRANCH_ID FROM  EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
</cfquery>
<cfquery name="GET_ALL_LOCATION" datasource="#DSN#">
	SELECT DEPARTMENT_ID, LOCATION_ID, COMMENT FROM STOCKS_LOCATION
</cfquery>
<cfif isDefined('attributes.amount_multiplier')>
	<cfset attributes.amount_multiplier = filterNum(attributes.amount_multiplier)>
</cfif>
<cfif not (isDefined('attributes.amount_multiplier') and isnumeric(attributes.amount_multiplier) and attributes.amount_multiplier gt 0)>
	<cfset attributes.amount_multiplier = 1>
</cfif>
<cfinclude template="../query/get_moneys.cfm">
<cfif len(attributes.serial_number)>
	<cfquery name="GET_SERIAL_PRODUCTS" datasource="#DSN3#">
		SELECT DISTINCT STOCK_ID FROM SERVICE_GUARANTY_NEW WHERE SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.serial_number#">
	</cfquery>
	<cfif get_serial_products.recordcount>
		<cfset seri_stock_id_list = valuelist(get_serial_products.STOCK_ID)>
	<cfelse>
		<cfset seri_stock_id_list = "">
	</cfif>
</cfif>
<cfif isdefined("attributes.is_submit_form")>
<cfquery name="PRODUCTS" datasource="#DSN3#">
	WITH CTE1 AS (
	SELECT
		STOCKS.STOCK_ID,
		STOCKS.PRODUCT_ID,
		STOCKS.STOCK_CODE,
		(SELECT TOP 1 REASON_CODE FROM #dsn3#.PRODUCT_PERIOD WHERE PRODUCT_PERIOD.PRODUCT_ID = PRODUCT.PRODUCT_ID AND PRODUCT_PERIOD.PERIOD_ID= #session.ep.period_id#) AS REASON_CODE,
		--PRODUCT.PRODUCT_NAME,
		#dsn_alias#.Get_Dynamic_Language(PRODUCT.PRODUCT_ID,'#session.ep.language#','PRODUCT','PRODUCT_NAME',NULL,NULL,PRODUCT.PRODUCT_NAME) AS PRODUCT_NAME,
		PRODUCT.PRODUCT_DETAIL2,
        PRODUCT.PRODUCT_DETAIL,
		STOCKS.STOCK_CODE_2 PRODUCT_CODE_2,
		STOCKS.PROPERTY,
		STOCKS.BARCOD AS BARCOD,
		<cfif isdefined('attributes.is_sale_product') and attributes.is_sale_product eq 0>
			PRODUCT.TAX_PURCHASE AS TAX,
		<cfelse>
			PRODUCT.TAX AS TAX,
		</cfif>
		PRODUCT.OTV AS OTV,
		PRODUCT.BSMV AS BSMV,
		PRODUCT.OIV AS OIV,
		PRODUCT.IS_ZERO_STOCK,
		PRODUCT.PRODUCT_CATID,
		PRODUCT.PRODUCT_CODE,
		PRODUCT.IS_SERIAL_NO,
		PRODUCT.TAX_PURCHASE,
		PRODUCT.IS_INVENTORY,
		PRODUCT.IS_PRODUCTION,
		PRODUCT.CUSTOMS_RECIPE_CODE,
		STOCKS.MANUFACT_CODE,
		STOCKS.PRODUCT_UNIT_ID,
		STOCKS.STOCK_CODE_2
		<cfif is_lot_no_based eq 1>
			,SUM(SR.STOCK_IN-STOCK_OUT) STOCK_AMOUNT
			,DELIVER_DATE
			,LOT_NO
		</cfif>
	FROM
		PRODUCT,
		STOCKS
		<cfif is_lot_no_based eq 1>
		LEFT JOIN #dsn2_alias#.STOCKS_ROW SR ON STOCKS.STOCK_ID = SR.STOCK_ID
		</cfif>
		<cfif isdefined("attributes.barcode") and len(attributes.barcode)>
		LEFT JOIN #dsn3_alias#.GET_STOCK_BARCODES AS GSB ON STOCKS.STOCK_ID = GSB.STOCK_ID
		</cfif>
	WHERE
	<cfif len(attributes.serial_number) and listlen(seri_stock_id_list)>
		STOCKS.STOCK_ID IN (#seri_stock_id_list#) AND
	<cfelseif len(attributes.serial_number) and not listlen(seri_stock_id_list)>
		STOCKS.STOCK_ID IS NULL AND
	</cfif>
		PRODUCT.PRODUCT_STATUS = 1 AND
		STOCKS.STOCK_STATUS = 1 AND
	<cfif isdefined("attributes.sepet_process_type")>
		<cfif ListFind("60,68,691",attributes.sepet_process_type)><!--- 56,58,63, envantere dahil olsada ürünler gelsin kapatılan işlem tiplerinde çünkü artık ürünlerin bu işlem tipleri için muhasebe kodları var--->
			PRODUCT.IS_INVENTORY = 0 AND
		<cfelseif ListFind("690,64",attributes.sepet_process_type)>
			PRODUCT.IS_INVENTORY = 1 AND
		</cfif>
	</cfif>
	<cfif isDefined("attributes.exp_cntr_code") and len(attributes.exp_cntr_code) or isDefined("attributes.budget_items") and len(attributes.budget_items) and is_expense_revenue_center eq 1><!---masraf merkezine bağlı bütçe kalemlerine ait ürünler --->
		 PRODUCT.PRODUCT_ID IN ( 
			                     SELECT 
									DISTINCT CP.PRODUCT_ID
								FROM
									#dsn3_alias#.PRODUCT_PERIOD CP
								WHERE
									CP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND 
									<cfif isdefined('attributes.is_sale_product') and attributes.is_sale_product eq 1> CP.INCOME_ITEM_ID <cfelse> CP.EXPENSE_ITEM_ID </cfif> 
									IN(									
										SELECT 
											EXR.EXPENSE_ITEM_ID
										FROM
											#dsn2_alias#.EXPENSE_CENTER_ROW EXR
										WHERE
											<cfif isDefined("attributes.budget_items") and len(attributes.budget_items)>
												EXR.EXPENSE_ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.budget_items,';')#">
											<cfelse>
												EXR.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.exp_cntr_code,';')#">
											</cfif>	
									)																								
								) AND
	</cfif>
	<cfif isdefined('xml_use_project_filter') and xml_use_project_filter eq 1 and isdefined("attributes.projects_id") and len(attributes.projects_id) and isdefined('attributes.project_head') and len(attributes.project_head)>
		<!--- xml de proje filtresi secilmisse, secilen projenin masraf merkezine baglı urunler listelenir --->
		 PRODUCT.PRODUCT_ID IN (
									SELECT
										DISTINCT CP.PRODUCT_ID
									FROM
										#dsn3_alias#.PRODUCT_PERIOD CP,
										#dsn2_alias#.EXPENSE_CENTER EXC,
										#dsn_alias#.PRO_PROJECTS PRJ
									WHERE
										CP.PRODUCT_ID =PRODUCT.PRODUCT_ID
										AND CP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
										AND PRJ.PROJECT_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.projects_id#">
										AND (CP.EXPENSE_CENTER_ID=EXC.EXPENSE_ID OR CP.COST_EXPENSE_CENTER_ID=EXC.EXPENSE_ID)
										AND SUBSTRING(PRJ.EXPENSE_CODE,1,3) = EXC.EXPENSE_CODE
								) AND
	</cfif>
	<cfif isdefined("attributes.barcode") and len(attributes.barcode)>
		(		
		GSB.BARCODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.barcode#">
		)
		AND
	</cfif>
	<cfif not isdefined('attributes.is_condition_sale_or_purchase') and isdefined('attributes.is_sale_product') and len(attributes.is_sale_product)><!--- alış veya satış olsada bu deger geldi ise urunlerin alış veya satışlarına bakmaz --->
		<cfif (isdefined("attributes.is_sale_product") and attributes.is_sale_product eq 1) and not (isdefined("attributes.sepet_process_type") and listfind(",62,78,81,140,141,811",attributes.sepet_process_type)) and not (isdefined("prod_order_result_") and prod_order_result_ eq 1)>
			PRODUCT.IS_SALES = 1 AND           
		</cfif>
		<cfif (isdefined("attributes.is_sale_product") and attributes.is_sale_product eq 0) and not (isdefined("attributes.sepet_process_type") and listfind("54,55,73,74,81,81,140,141,811",attributes.sepet_process_type)) and attributes.sepet_process_type neq '81,81'><!--- not isdefined("sepet_process_type") or (isdefined("sepet_process_type") and not listfind("53,57,52,56,62,72,78,79,70,71,81,140,141,531",sepet_process_type)) --->
			<cfif isdefined("attributes.demand_type") and attributes.demand_type eq 0>
				(PRODUCT.IS_PURCHASE = 1 OR PRODUCT.IS_PRODUCTION = 1) AND
            <!---<cfelse>
				PRODUCT.IS_PURCHASE = 0  AND--->
            </cfif>
		</cfif>
	</cfif>
	<cfif len(attributes.manufacturer_code)>
		(STOCKS.MANUFACT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.manufacturer_code#"> OR PRODUCT.MANUFACT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.manufacturer_code#">) AND
	</cfif>
	<cfif isdefined("attributes.list_property_id") and len(attributes.list_property_id) and len(attributes.list_variation_id)>
		PRODUCT.PRODUCT_ID IN
		(
			SELECT
				PRODUCT_ID
			FROM
				#dsn1_alias#.PRODUCT_DT_PROPERTIES PRODUCT_DT_PROPERTIES
			WHERE
				(
			  <cfloop from="1" to="#listlen(attributes.list_property_id,',')#" index="pro_index">
				(PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(attributes.list_property_id,pro_index,",")#"> AND VARIATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(attributes.list_variation_id,pro_index,",")#">)
				<cfif pro_index lt listlen(attributes.list_property_id,',')>OR</cfif>
			  </cfloop>
				)
			GROUP BY
				PRODUCT_ID
			HAVING
				COUNT(PRODUCT_ID)> = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlen(attributes.list_property_id,',')#">                 
		) AND
	</cfif>
	<cfif len(attributes.pos_code)>
		PRODUCT.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#"> AND
	</cfif>
	<cfif len(attributes.search_company_id)>
		PRODUCT.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.search_company_id#"> AND
	</cfif>
	<cfif isdefined('attributes.is_store_module') and ( (isdefined('attributes.sepet_process_type') and listfind('49,51,52,53,54,55,59,591,60,601,63,73,74,75,76,77,80,82,86,87',attributes.sepet_process_type)) or (isdefined('attributes.int_basket_id') and attributes.int_basket_id eq 6) )><!--- sube modulunden perakende faturasına urun secilirken --->
		PRODUCT.PRODUCT_ID IN (SELECT DISTINCT PRODUCT_ID FROM #dsn1_alias#.PRODUCT_BRANCH WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#LISTGETAT(SESSION.EP.USER_LOCATION,2,"-")#"> ) AND
	</cfif>
    	<cfif len(attributes.keyword) eq 1>
		(PRODUCT.PRODUCT_NAME LIKE #sql_unicode()#'#attributes.keyword#%' OR STOCKS.BARCOD LIKE '%#attributes.keyword#%' OR STOCKS.STOCK_CODE LIKE '#attributes.keyword#%' OR STOCKS.STOCK_CODE_2 LIKE '#attributes.keyword#%' OR STOCKS.MANUFACT_CODE LIKE '%#attributes.keyword#%') AND
	<cfelseif len(attributes.keyword) gt 1 or listlen(attributes.keyword,"+") >
		((
			<cfloop from="1" to="#listlen(attributes.keyword,'+')#" index="pro_index">
				<cfif pro_index neq 1>AND</cfif>
					PRODUCT.PRODUCT_NAME LIKE #sql_unicode()#'<cfif pro_index neq 1>%</cfif>%#ListGetAt(attributes.keyword,pro_index,"+")#%'                     
			</cfloop>
		) OR STOCKS.STOCK_CODE LIKE '%#attributes.keyword#%' OR STOCKS.BARCOD LIKE '%#attributes.keyword#%' OR STOCKS.STOCK_CODE_2 LIKE '%#attributes.keyword#%' OR STOCKS.MANUFACT_CODE LIKE '%#attributes.keyword#%' OR PRODUCT.PRODUCT_DETAIL LIKE '%#attributes.keyword#%') AND
        
        
	</cfif>		
    <cfif is_lot_no_based eq 1 and len(attributes.keyword2) gt 0>
        SR.LOT_NO LIKE '<cfif len(attributes.keyword2) gte 3>%</cfif>#attributes.keyword2#%' AND
    </cfif>
	<!---<cfif len(attributes.keyword) gt 0>
		<cfif attributes.sort_type eq 0>
			PRODUCT.PRODUCT_NAME LIKE #sql_unicode()#'<cfif len(attributes.keyword) gte 3>%</cfif>#attributes.keyword#%'
		<cfelseif attributes.sort_type eq 1>
			STOCKS.STOCK_CODE LIKE '<cfif len(attributes.keyword) gte 3>%</cfif>#attributes.keyword#%'
		<cfelseif attributes.sort_type eq 2>
			STOCKS.STOCK_CODE_2 LIKE '<cfif len(attributes.keyword) gte 3>%</cfif>#attributes.keyword#%'
		<cfelseif attributes.sort_type eq 3>
			PRODUCT.BARCOD LIKE '<cfif len(attributes.keyword) gte 3>%</cfif>#attributes.keyword#%'
		</cfif>
		AND
	</cfif>
	<cfif is_lot_no_based eq 1 and len(attributes.keyword2) gt 0>
        SR.LOT_NO LIKE '<cfif len(attributes.keyword2) gte 3>%</cfif>#attributes.keyword2#%' AND
    </cfif>--->
	<cfif len(attributes.product_cat) and len(attributes.product_catid)>
		PRODUCT.PRODUCT_CODE LIKE (SELECT HIERARCHY FROM PRODUCT_CAT WHERE PRODUCT_CATID=#attributes.product_catid#)+'.%' AND <!---kategori hiyerarşisine gore arama yapıyor --->
	</cfif>
		PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID
	<cfif is_lot_no_based eq 1>
		GROUP BY
			PRODUCT.PRODUCT_ID,
			STOCKS.STOCK_ID,
			STOCKS.PRODUCT_ID,
			STOCKS.STOCK_CODE,
			PRODUCT.PRODUCT_NAME,
			PRODUCT.PRODUCT_DETAIL2,
			PRODUCT.PRODUCT_CODE_2,
			STOCKS.PROPERTY,
			STOCKS.BARCOD,
			PRODUCT.TAX,
			PRODUCT.OTV,
			PRODUCT.BSMV,
			PRODUCT.OIV,
			PRODUCT.IS_ZERO_STOCK,
			PRODUCT.PRODUCT_CATID,
			PRODUCT.PRODUCT_CODE,
            PRODUCT.PRODUCT_DETAIL,
			PRODUCT.IS_SERIAL_NO,
			PRODUCT.TAX_PURCHASE,
			PRODUCT.IS_INVENTORY,
			PRODUCT.IS_PRODUCTION,
			PRODUCT.CUSTOMS_RECIPE_CODE,
			STOCKS.MANUFACT_CODE,
			STOCKS.PRODUCT_UNIT_ID,
			STOCKS.STOCK_CODE_2,
			SR.LOT_NO,
			SR.DELIVER_DATE
       		<cfif is_lot_no_based eq 1>
       				<cfif not isdefined('attributes.is_lotno1') and not isdefined('attributes.is_submit_form1')>
       				HAVING SUM(SR.STOCK_IN-STOCK_OUT) > 0     
       		</cfif>
          </cfif>     
	</cfif>
	) ,
	CTE2 AS (
				SELECT
					CTE1.*,
						ROW_NUMBER() OVER ( <cfif isdefined('attributes.sort_type') and attributes.sort_type eq 0>
												ORDER BY PRODUCT_NAME
											<cfelseif isdefined('attributes.sort_type') and attributes.sort_type eq 1>
												ORDER BY STOCK_CODE
											<cfelseif isdefined('attributes.sort_type') and attributes.sort_type eq 2>
		 										ORDER BY STOCK_CODE_2
		 									<cfelseif isdefined('attributes.sort_type') and attributes.sort_type eq 3>
		 										ORDER BY BARCOD
                                                <cfelseif isdefined('attributes.sort_type') and attributes.sort_type eq 4>  
                                                ORDER BY PRODUCT_DETAIL                                          
											</cfif>
                                            
                                            
		) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
				FROM
					CTE1
			)
			SELECT
				CTE2.*
			FROM
				CTE2
			WHERE
				RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
</cfquery>
<cfelse>
	<cfset products.query_count = 0 >
	<cfset products.recordcount = 0 >
</cfif>
<cfparam name="attributes.totalrecords" default="#products.query_count#">
<cfset product_id_list=''>
<cfset dept_stock_id_list=''>
<cfset other_dept_stock_id_list=''>
<cfif isdefined("attributes.is_submit_form")>
<cfoutput query="products">
	<cfif not listfind(product_id_list,products.PRODUCT_ID)>
		<cfset product_id_list = listappend(product_id_list,products.PRODUCT_ID)>
	</cfif>
</cfoutput>
</cfif>
<cfif len(product_id_list)>
	<cfquery name="GET_PRODUCT_UNITS" datasource="#DSN3#">
		SELECT ADD_UNIT,MAIN_UNIT,MULTIPLIER,PRODUCT_UNIT_ID,PRODUCT_ID,QUANTITY FROM PRODUCT_UNIT WHERE PRODUCT_ID IN (#product_id_list#) AND PRODUCT_UNIT_STATUS = 1
	</cfquery>
	<cfquery name="GET_DEPT_STOCK_INFO" datasource="#DSN2#">
		SELECT
			SUM(STOCK_IN-STOCK_OUT) AS TOTAL_DEPT_STOCK,
			PRODUCT_ID,
			STOCK_ID
            <cfif isdefined('xml_use_department_filter') and xml_use_department_filter eq 1 and is_lot_no_based eq 1>
            	,LOT_NO
            </cfif>
		FROM
			STOCKS_ROW
		WHERE
			PRODUCT_ID IN (#product_id_list#)
			<cfif isdefined('attributes.departmen_location_info') and len(attributes.departmen_location_info)><!--- depo filtresine ait stok miktarları --->
				AND STORE= <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.departmen_location_info,'-')#">
				AND STORE_LOCATION= <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.departmen_location_info,'-')#">
			</cfif>
		GROUP BY
			PRODUCT_ID,
			STOCK_ID
            <cfif isdefined('xml_use_department_filter') and xml_use_department_filter eq 1 and is_lot_no_based eq 1>
            	,LOT_NO
            </cfif>
		ORDER BY
			STOCK_ID
	</cfquery>
    <cfif isdefined('xml_use_department_filter') and xml_use_department_filter eq 1 and is_lot_no_based eq 1>
		<cfoutput query="GET_DEPT_STOCK_INFO">
			<cfset lot_no_ = replaceNocase(lot_no,'-','_','all')>
        	<cfset lot_no_ = filterSpecialChars(lot_no_)>
			<cfset lot_no_ = trim(lot_no_)>
            <cfset 'dept_stock_id_#stock_id#_#lot_no_#' = TOTAL_DEPT_STOCK>
        </cfoutput>
    <cfelse>
		<cfset dept_stock_id_list=listsort(valuelist(get_dept_stock_info.STOCK_ID),'numeric','asc')>
    </cfif>
	<cfif isdefined('xml_use_other_dept_info') and listlen(xml_use_other_dept_info,'-') eq 2><!--- xmlde tanımlanan 2.depoya ait stok miktarları --->
		<cfquery name="GET_OTHER_DEPT_STOCK_INFO" datasource="#DSN2#">
			SELECT
				SUM(STOCK_IN-STOCK_OUT) AS TOTAL_DEPT_STOCK_2,
				PRODUCT_ID,
				STOCK_ID
			FROM
				STOCKS_ROW
			WHERE
				PRODUCT_ID IN (#product_id_list#)
				AND STORE= <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(xml_use_other_dept_info,'-')#">
				AND STORE_LOCATION= <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(xml_use_other_dept_info,'-')#">
			GROUP BY
				PRODUCT_ID,
				STOCK_ID
			ORDER BY
				STOCK_ID
		</cfquery>
		<cfset other_dept_stock_id_list=listsort(valuelist(get_other_dept_stock_info.STOCK_ID),'numeric','asc')>
	</cfif>
</cfif>
<cfset url_str = ''>
<cfif isdefined("is_sale_product")>
	<cfset url_str = "#url_str#&is_sale_product=#is_sale_product#">
</cfif>
<cfif isdefined("attributes.is_cost")>
	<cfset url_str = "#url_str#&is_cost=#attributes.is_cost#">
</cfif><!--- is_cost net maliyet hesaplamasını kontrol ediyor ozden09112005 --->
<cfif isdefined("attributes.department_out")>
	<cfset url_str = "#url_str#&department_out=#attributes.department_out#">
</cfif>
<cfif isdefined("attributes.location_out")>
	<cfset url_str = "#url_str#&location_out=#attributes.location_out#">
</cfif>
<cfif isdefined("attributes.department_in")>
	<cfset url_str = "#url_str#&department_in=#attributes.department_in#">
</cfif>
<cfif isdefined("attributes.location_in")>
	<cfset url_str = "#url_str#&location_in=#attributes.location_in#">
</cfif>
<cfif isdefined("attributes.update_product_row_id") and len(attributes.update_product_row_id)>
	<cfset url_str = "#url_str#&update_product_row_id=#attributes.update_product_row_id#">
</cfif>
<cfif isdefined("attributes.deliver_date") and len(attributes.deliver_date)>
	<cfset url_str = "#url_str#&deliver_date=#attributes.deliver_date#">
</cfif>
<cfif isdefined("attributes.lot_no") and len(attributes.lot_no)>
	<cfset url_str = "#url_str#&lot_no=#attributes.lot_no#">
</cfif>
<cfif isdefined("sepet_process_type")>
	<cfset url_str = "#url_str#&sepet_process_type=#attributes.sepet_process_type#">
</cfif>
<cfif isdefined("int_basket_id")>
	<cfset url_str = "#url_str#&int_basket_id=#attributes.int_basket_id#">
</cfif>
<cfif isdefined("attributes.search_process_date") and isdate(attributes.search_process_date)>
	<cfset url_str = "#url_str#&search_process_date=#attributes.search_process_date#">
</cfif>
<cfif isdefined("attributes.company_id")>
	<cfset url_str = "#url_str#&company_id=#attributes.company_id#">
</cfif>
<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
	<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
</cfif>
<cfif isDefined('attributes.rowcount') and len(attributes.rowcount)>
	<cfset url_str = "#url_str#&rowcount=#attributes.rowcount#">
</cfif>
<cfif isDefined('attributes.is_price') and len(attributes.is_price)>
	<cfset url_str = "#url_str#&is_price=#attributes.is_price#">
</cfif>
<cfif isDefined('attributes.projects_id') and len(attributes.projects_id) and isDefined("attributes.project_head") and Len(attributes.project_head)>
	<cfset url_str = "#url_str#&project_id=#attributes.projects_id#&project_head=#replace(attributes.project_head,'#chr(39)#','')#">
</cfif>
<cfif isDefined('attributes.is_condition_sale_or_purchase') and len(attributes.is_condition_sale_or_purchase)>
	<cfset url_str = "#url_str#&is_condition_sale_or_purchase=#attributes.is_condition_sale_or_purchase#">
</cfif>
<cfset flag_prc_other=0>
<cfif isDefined('attributes.is_price_other') and len(attributes.is_price_other)>
	<cfset flag_prc_other=attributes.is_price_other>
	<cfset url_str = "#url_str#&is_price_other=#attributes.is_price_other#">
</cfif>
<cfif isdefined("attributes.is_store_module")>
	<cfset url_str = "#url_str#&is_store_module=#attributes.is_store_module#">
</cfif>
<cfif isdefined("attributes.paymethod_id")>
	<cfset url_str = "#url_str#&paymethod_id=#attributes.paymethod_id#">
</cfif>
<cfif isdefined("attributes.card_paymethod_id") and len(attributes.card_paymethod_id)>
	<cfset url_str = "#url_str#&card_paymethod_id=#attributes.card_paymethod_id#">
</cfif>
<cfif isdefined("attributes.paymethod_vehicle") and len(attributes.paymethod_vehicle)>
	<cfset url_str = "#url_str#&paymethod_vehicle=#attributes.paymethod_vehicle#">
</cfif>
<cfif isdefined('attributes.demand_type') and len(attributes.demand_type)>
 	<cfset url_str = "#url_str#&demand_type=#attributes.demand_type#">
</cfif>
<cfloop query="moneys">
	<cfif isdefined("attributes.#money#")>
		<cfset url_str = "#url_str#&#money#=#evaluate("attributes.#money#")#">
	</cfif>
</cfloop>
<cfif isdefined("prod_order_result_") and prod_order_result_ eq 1>
	<cfif isdefined("open_stock_popup_type")>
		<cfset url_str = "#url_str#&open_stock_popup_type=#open_stock_popup_type#&prod_order_result_=#prod_order_result_#">
    </cfif>
    <cfif isdefined("is_lot_no_based")>
		<cfset url_str = "#url_str#&is_lot_no_based=#is_lot_no_based#">
    </cfif> 
	<cfif isdefined("round_number")>
		<cfset url_str = "#url_str#&round_number=#round_number#">
    </cfif>
</cfif>
<cfif isdefined("attributes.departmen_location_info") and len(attributes.departmen_location_info)>
	<cfset url_str = "#url_str#&departmen_location_info=#attributes.departmen_location_info#">
</cfif>
<cfif isdefined("attributes.satir")>
	<cfset url_str = "#url_str#&satir=#attributes.satir#">
</cfif>
<cfset url_str_form = url_str>
<cfset url_str = '#url_str#&is_submit_form=1'>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='57564.Ürünler'></cfsavecontent>
<cf_box title="#message#" collapsable="0">
	<cf_wrk_alphabet keyword="url_str" popup_box="#iif(isdefined("attributes.draggable"),1,0)#"><!--- Harfler --->
	<cfform name="price_cat" action="#request.self#?fuseaction=objects.popup_products#url_str_form#" method="post">
		<cf_box_search>
			<input type="hidden" name="is_submit_form" id="is_submit_form" value="">
			<input type="hidden" name="satir" id="satir" value="<cfoutput>#attributes.satir#</cfoutput>">
			<input type="hidden" name="is_submit_form" id="is_submit_form1" value="">
			<input type="hidden" name="list_property_id" id="list_property_id" value="<cfif isdefined("attributes.list_property_id")><cfoutput>#attributes.list_property_id#</cfoutput></cfif>">
			<input type="hidden" name="list_variation_id" id="list_variation_id" value="<cfif isdefined("attributes.list_variation_id")><cfoutput>#attributes.list_variation_id#</cfoutput></cfif>">
			<cfif isDefined("attributes.from_product_config")><input type="hidden" name ="from_product_config" id="from_product_config" value=""></cfif>
			<div class="form-group" id="keyword">
				<cfif isdefined("prod_order_result_") and prod_order_result_ eq 1><!--- üretim sonucu sayfasından geliyorsa readonly olsun (attributes değeri filtreden silinemesin) --->
					<cfinput type="text" name="keyword" value="#attributes.keyword#" readonly>
				<cfelse>
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword"  placeholder="#message#" value="#attributes.keyword#">
				</cfif>
			</div>
			<div class="form-group" id="search_company">
				<div class="input-group">   
					<input type="hidden" name="search_company_id" id="search_company_id" value="<cfoutput>#attributes.search_company_id#</cfoutput>">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='29533.Tedarikçi'></cfsavecontent>
					<input type="text" name="search_company" id="search_company" placeholder="<cfoutput>#message#</cfoutput>" value="<cfif len(attributes.search_company_id)><cfoutput>#get_par_info(attributes.search_company_id,1,1,0)#</cfoutput></cfif>" onfocus="AutoComplete_Create('search_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','MEMBER_NAME,COMPANY_ID','search_company,search_company_id','','3','250');">
					<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=price_cat.search_company&field_comp_id=price_cat.search_company_id&select_list=2','list');"></span>
				</div>
			</div>
			<div class="form-group" id="amount_multiplier">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57635.Miktar'></cfsavecontent>
				<input type="text" name="amount_multiplier" id="amount_multiplier" placeholder="<cfoutput>#message#</cfoutput>" value="<cfoutput>#amountformat(attributes.amount_multiplier,3)#</cfoutput>" onkeyup="return FormatCurrency(this,event,3);">
			</div>
			<div class="form-group" id="serial_number">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57637.Seri No'></cfsavecontent>
				<cfinput type="text" name="serial_number" placeholder="#message#" value="#attributes.serial_number#">
			</div>
			<div class="form-group" id="sort_type">
				<select name="sort_type" id="sort_type">
					<option value="0" <cfif attributes.sort_type eq 0>selected</cfif>><cf_get_lang dictionary_id='34282.Ürün Adına Göre'></option>
					<option value="1" <cfif attributes.sort_type eq 1>selected</cfif>><cf_get_lang dictionary_id='32751.Stok Koduna Göre'></option>
					<option value="2" <cfif attributes.sort_type eq 2>selected</cfif>><cf_get_lang dictionary_id='32764.Özel Koda Göre'></option>
					<option value="3" <cfif attributes.sort_type eq 3>selected</cfif>><cf_get_lang dictionary_id='30063.Barkoda Göre'></option>
					<option value="4" <cfif attributes.sort_type eq 4>selected</cfif>><cf_get_lang dictionary_id='60124.Ürün Açıklamasına Göre'></option>
				</select>
			</div>
			<div class="form-group" id="product_cat">
				<div class="input-group">   
					<input type="hidden" name="product_catid" id="product_catid" value="<cfoutput>#attributes.product_catid#</cfoutput>">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57486.Kategori'></cfsavecontent>
					<input type="text" name="product_cat" id="product_cat" placeholder="<cfoutput>#message#</cfoutput>" value="<cfoutput>#attributes.product_cat#</cfoutput>" onfocus="AutoComplete_Create('product_cat','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID','product_catid','','3','150');">
					<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://"onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=price_cat.product_catid&field_name=price_cat.product_cat&keyword='+encodeURIComponent(document.price_cat.product_cat.value)</cfoutput>);"></span>
				</div>
			</div> 
			<div class="form-group" id="barcode">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57633.Barkod'></cfsavecontent>
				<cfinput type="text" name="barcode" placeholder="#message#" value="#attributes.barcode#">
			</div>
			<cfif is_lot_no_based eq 1> 
				<div class="form-group" id="keyword2">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='32916.Lot No'></cfsavecontent>
					<cfinput type="text" name="keyword2" id="keyword2" placeholder="#message#" value="#attributes.keyword2#">
				</div>
			</cfif>
			<cfif isdefined('xml_use_project_filter') and xml_use_project_filter eq 1>
				<div class="form-group" id="project_id_">
					<div class="input-group">
						<input type="hidden" name="projects_id" id="projects_id" value="<cfif isdefined('attributes.projects_id') and len (attributes.projects_id)><cfoutput>#attributes.projects_id#</cfoutput></cfif>">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57416.Proje'></cfsavecontent>
						<input type="text" name="project_head"  placeholder="<cfoutput>#message#</cfoutput>" id="project_head" value="<cfif isdefined('attributes.projects_id') and len (attributes.projects_id)><cfoutput>#GET_PROJECT_NAME(attributes.projects_id)#</cfoutput></cfif>" autocomplete="off">
						<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=price_cat.project_head&project_id=price_cat.projects_id</cfoutput>');"></span>
					</div>
				</div>        
			</cfif>
			<div class="form-group" id="pos_code">
				<div class="input-group">
					<input type="hidden" name="pos_code" id="pos_code" value="<cfoutput>#attributes.pos_code#</cfoutput>">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57544.Sorumlu'></cfsavecontent>
					<input type="text" name="employee" id="employee"  placeholder="<cfoutput>#message#</cfoutput>" value="<cfif len(attributes.pos_code)><cfoutput>#get_emp_info(attributes.pos_code,1,0)#</cfoutput></cfif>" maxlength="255" onfocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE','pos_code','','3','120');" autocomplete="off">
					<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=price_cat.pos_code&field_name=price_cat.employee&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.price_cat.employee.value),'list');"></span>
				</div>
			</div> 
			<cfif isdefined('xml_use_department_filter') and xml_use_department_filter eq 1>
				<div class="form-group" id="departmen_location_info">
					<select name="departmen_location_info" id="departmen_location_info">
						<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						<cfoutput query="get_department">
							<optgroup label="#department_head#">
							<cfquery name="GET_LOCATION" dbtype="query">
								SELECT * FROM GET_ALL_LOCATION WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_department.department_id[currentrow]#">
							</cfquery>
							<cfif get_location.recordcount>
								<cfloop from="1" to="#get_location.recordcount#" index="s">
									<cfif xml_use_dept_default_value eq 1>
										<option value="#department_id#-#get_location.location_id[s]#" <cfif len(attributes.departmen_location_info) and attributes.departmen_location_info is '#department_id#-#get_location.location_id[s]#'>selected</cfif>>#get_location.comment[s]#</option>
									<cfelse>
										<option value="#department_id#-#get_location.location_id[s]#" <cfif len(attributes.departmen_location_info) and attributes.departmen_location_info is '#department_id#-#get_location.location_id[s]#'>selected</cfif>>#get_location.comment[s]#</option>
									</cfif>
								</cfloop>
							</cfif>
							</optgroup>
						</cfoutput>
					</select>
				</div>   
			</cfif>
			<div class="form-group" id="manufacturer_code">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57634.Üretici Kodu'></cfsavecontent>
				<cfinput type="text" name="manufacturer_code" placeholder="#message#" value="#attributes.manufacturer_code#">
			</div>
			<div class="form-group" id="item-exp_cntr_code">
				<cfquery name="get_hierarcy" datasource="#dsn2#">
					SELECT 
						D.HIERARCHY_DEP_ID 
					FROM 
						#dsn_alias#.DEPARTMENT D,
						#dsn_alias#.EMPLOYEE_POSITIONS EP 
					WHERE 
						EP.DEPARTMENT_ID = D.DEPARTMENT_ID
						AND POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
				</cfquery>
				<cfif get_hierarcy.recordcount and listlen(get_hierarcy.HIERARCHY_DEP_ID,'.') gt 1>
					<cfset hierarcy_id_list = valuelist(get_hierarcy.HIERARCHY_DEP_ID,',')>
					<cfset up_dep=ListGetAt(hierarcy_id_list,evaluate("#listlen(hierarcy_id_list,".")#-1"),".") >		
				</cfif>
				<cfquery name="get_expense_center_" datasource="#dsn2#">
					SELECT
						EXPENSE_ID,
						EXPENSE_CODE,
						EXPENSE
					FROM
						EXPENSE_CENTER
					<cfif x_authorized_branch_department eq 1>
					WHERE
						(EXPENSE_BRANCH_ID IN (SELECT EP.BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES EP WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) OR (EXPENSE_BRANCH_ID = -1))
						<cfif get_hierarcy.recordcount and listlen(get_hierarcy.HIERARCHY_DEP_ID,'.') gt 1>
							AND (EXPENSE_DEPARTMENT_ID IN 
								(	
									SELECT EP.DEPARTMENT_ID FROM #dsn_alias#.EMPLOYEE_POSITIONS EP WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
									UNION ALL 
										SELECT 
											DEPARTMENT_ID 
										FROM
											#dsn_alias#.DEPARTMENT
										WHERE 
											DEPARTMENT_ID = #up_dep#
								) 
								OR ( EXPENSE_DEPARTMENT_ID = -1)
							)
						</cfif>
					</cfif>
					ORDER BY
						EXPENSE_CODE
				</cfquery>
				<select name="exp_cntr_code" id="exp_cntr_code"  onchange="showBudgetItems(this.value,'budget_items')">
					<option value=""><cf_get_lang dictionary_id='58235.Masraf/Gelir Merkezi'></option>
						<cfoutput  query="get_expense_center_">
							<option value="#EXPENSE_ID#;#EXPENSE#"<cfif isdefined('attributes.exp_cntr_code') and EXPENSE_ID eq listfirst(attributes.exp_cntr_code,';')>selected</cfif>>
								<cfif ListLen(expense_code,".") neq 1>
									<cfloop from="1" to="#ListLen(expense_code,".")#" index="i">&nbsp;</cfloop>
								</cfif>
							#expense#
							</option>
						</cfoutput>
				</select>
			</div>
			<div class="form-group" id="item-budget_items">
				<select name="budget_items" id="budget_items">
					<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
					<cfif isDefined("attributes.exp_cntr_code") and len(attributes.exp_cntr_code)>
						<cfscript>
							cfc = createObject("component", "V16.budget.cfc.budget_expense_cat");
							GET_EXPENSE_ITEMS = cfc.GetBudgetItems_(expense_id:listfirst(attributes.exp_cntr_code,';'),dsn:#dsn2#);
						</cfscript>
					<cfelse>
						<cfquery name="GET_EXPENSE_ITEMS" datasource="#dsn2#">
							SELECT 
								EI.EXPENSE_ITEM_ID,
								EI.EXPENSE_ITEM_NAME
							FROM 
								EXPENSE_ITEMS EI
								LEFT JOIN EXPENSE_CATEGORY EC ON EC.EXPENSE_CAT_ID = EI.EXPENSE_CATEGORY_ID
						</cfquery>
					</cfif>
						<cfoutput query = "GET_EXPENSE_ITEMS">
							<option value="#EXPENSE_ITEM_ID#;#EXPENSE_ITEM_NAME#" <cfif isdefined('attributes.budget_items') and EXPENSE_ITEM_ID eq listfirst(attributes.budget_items,';')>selected</cfif>>#EXPENSE_ITEM_NAME#</option>
						</cfoutput>
				</select>
			</div>			
			<div class="form-group">
				<cfif is_lot_no_based eq 1><label>
				<input type="checkbox" name="is_lotno1" id="is_lotno1" value="1" <cfif isdefined('attributes.is_lotno1')> checked</cfif>><cf_get_lang dictionary_id='60125.Sıfır Stoklu Lotlar'></label></cfif>
			</div>
			<div class="form-group small">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,250" message="#message#">
			</div>
			<div class="form-group">
				<cf_wrk_search_button search_function='input_control()' button_type="4">
			</div>
						

			<!--- <div class="row form-inline">
						<div class="form-group" id="keyword">
							<div class="input-group">
								<cfif isdefined("prod_order_result_") and prod_order_result_ eq 1><!--- üretim sonucu sayfasından geliyorsa readonly olsun (attributes değeri filtreden silinemesin) --->
									<cfinput type="text" name="keyword" value="#attributes.keyword#" readonly>
								<cfelse>
									<cfinput type="text" name="keyword"  placeholder="#getLang('main',48)#" value="#attributes.keyword#">
								</cfif>
							</div>
						</div>  
						<div class="form-group" id="sort_type">
							<div class="input-group x-16">
								<select name="sort_type" id="sort_type" style="width:110px;">
									<option value="0" <cfif attributes.sort_type eq 0>selected</cfif>><cf_get_lang no='1892.Ürün Adına Göre'></option>
									<option value="1" <cfif attributes.sort_type eq 1>selected</cfif>><cf_get_lang no='361.Stok Koduna Göre'></option>
									<option value="2" <cfif attributes.sort_type eq 2>selected</cfif>><cf_get_lang no='374.Özel Koda Göre'></option>
									<option value="3" <cfif attributes.sort_type eq 3>selected</cfif>><cf_get_lang_main no='2266.Barkoda Göre'></option>
									<option value="4" <cfif attributes.sort_type eq 4>selected</cfif>>Ürün Açıklamasına Göre</option>
								</select>
							</div>
						</div> 
						<cfif isdefined('xml_use_project_filter') and xml_use_project_filter eq 1>
							<div class="form-group" id="project_id_">
								<div class="input-group x-14">
									<input type="hidden" name="projects_id" id="projects_id" value="<cfif isdefined('attributes.projects_id') and len (attributes.projects_id)><cfoutput>#attributes.projects_id#</cfoutput></cfif>">
									<input type="text" name="project_head"  placeholder="<cfoutput>#getLang('main',4)#</cfoutput>" id="project_head" value="<cfif isdefined('attributes.projects_id') and len (attributes.projects_id)><cfoutput>#GET_PROJECT_NAME(attributes.projects_id)#</cfoutput></cfif>" autocomplete="off">
									<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=price_cat.project_head&project_id=price_cat.projects_id</cfoutput>','list');"></span>
								</div>
							</div>        
						</cfif>
						<div class="form-group" id="pos_code">
							<div class="input-group x-14">
								<input type="hidden" name="pos_code" id="pos_code" value="<cfoutput>#attributes.pos_code#</cfoutput>">
								<input type="text" name="employee" id="employee"  placeholder="<cfoutput>#getLang('main',132)#</cfoutput>" value="<cfif len(attributes.pos_code)><cfoutput>#get_emp_info(attributes.pos_code,1,0)#</cfoutput></cfif>" maxlength="255" onfocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE','pos_code','','3','120');" autocomplete="off">
								<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=price_cat.pos_code&field_name=price_cat.employee&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.price_cat.employee.value),'list');"></span>
							</div>
						</div>
						<div class="form-group x-3_5">
							<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,250" message="#message#" style="width:25px;">
						</div>
						<div class="form-group">
							<cf_wrk_search_button search_function='input_control()'><!--- <input type="image" src="/images/ara.gif" border="0"> --->
						</div>
				<div class="row">
					<div class="form-group" id="keyword2">
						<div class="input-group x-14">
							<cfif is_lot_no_based eq 1>            
								<cfinput type="text" name="keyword2" id="keyword2" placeholder="#getLang('objects',526)#" value="#attributes.keyword2#">
							</cfif>
						</div>
					</div>
					<div class="form-group" id="search_company">
						<div class="input-group x-14">   
							<input type="hidden" name="search_company_id" id="search_company_id" value="<cfoutput>#attributes.search_company_id#</cfoutput>">
							<input type="text" name="search_company" id="search_company" placeholder="<cfoutput>#getLang('main',1736)#</cfoutput>" value="<cfif len(attributes.search_company_id)><cfoutput>#get_par_info(attributes.search_company_id,1,1,0)#</cfoutput></cfif>" onfocus="AutoComplete_Create('search_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','MEMBER_NAME,COMPANY_ID','search_company,search_company_id','','3','250');">
							<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=price_cat.search_company&field_comp_id=price_cat.search_company_id&select_list=2','list');"></span>
						</div>
					</div>
					<div class="form-group" id="product_cat">
						<div class="input-group x-14">   
							<input type="hidden" name="product_catid" id="product_catid" value="<cfoutput>#attributes.product_catid#</cfoutput>">
							<input type="text" name="product_cat" id="product_cat" placeholder="<cfoutput>#getLang('main',74)#</cfoutput>" value="<cfoutput>#attributes.product_cat#</cfoutput>" onfocus="AutoComplete_Create('product_cat','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID','product_catid','','3','150');">
							<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://"onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=price_cat.product_catid&field_name=price_cat.product_cat&keyword='+encodeURIComponent(document.price_cat.product_cat.value)</cfoutput>,'list');"></span>
						</div>
					</div>
					<cfif isdefined('xml_use_department_filter') and xml_use_department_filter eq 1>
						<div class="form-group" id="departmen_location_info">
							<div class="input-group x-24"> 
								<select name="departmen_location_info" id="departmen_location_info" style="width:170px;">
									<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
									<cfoutput query="get_department">
										<optgroup label="#department_head#">
										<cfquery name="GET_LOCATION" dbtype="query">
											SELECT * FROM GET_ALL_LOCATION WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_department.department_id[currentrow]#">
										</cfquery>
										<cfif get_location.recordcount>
											<cfloop from="1" to="#get_location.recordcount#" index="s">
												<cfif xml_use_dept_default_value eq 1>
													<option value="#department_id#-#get_location.location_id[s]#" <cfif len(attributes.departmen_location_info) and attributes.departmen_location_info is '#department_id#-#get_location.location_id[s]#'>selected</cfif>>#get_location.comment[s]#</option>
												<cfelse>
													<option value="#department_id#-#get_location.location_id[s]#" <cfif len(attributes.departmen_location_info) and attributes.departmen_location_info is '#department_id#-#get_location.location_id[s]#'>selected</cfif>>#get_location.comment[s]#</option>
												</cfif>
											</cfloop>
										</cfif>
										</optgroup>
									</cfoutput>
								</select>
							</div>
						</div>   
					</cfif>
				</div>
				<div class="row">
					<cfif is_lot_no_based eq 1>
						<div class="form-group" id="is_lotno1">
							<div class="input-group x-4">
								<label class="col col-12">
								<div style="float:left;"><input type="checkbox" name="is_lotno1" id="is_lotno1" value="1" style="margin: 0 5px 0 0;" <cfif isdefined('attributes.is_lotno1')> checked</cfif>>
								</div>
								<div style="float:left; padding-top: 4px;">Sıfır Stoklu Lotlar</div></label>
							</div>
						</div>    
					</cfif>
					<div class="form-group" id="amount_multiplier">
						<div class="input-group x-4">
							<input type="text" name="amount_multiplier" id="amount_multiplier" placeholder="<cfoutput>#getLang('main',223)#</cfoutput>" value="<cfoutput>#amountformat(attributes.amount_multiplier,3)#</cfoutput>" onkeyup="return FormatCurrency(this,event,3);">
						</div>
					</div>
					<div class="form-group" id="barcode">
						<div class="input-group">
							<cfinput type="text" name="barcode" placeholder="#getLang('main',221)#" value="#attributes.barcode#" style="width:70px;">
						</div>
					</div>
					<div class="form-group" id="manufacturer_code">
						<div class="input-group">
							<cfinput type="text" name="manufacturer_code" placeholder="#getLang('main',222)#" value="#attributes.manufacturer_code#" style="width:60px;">
						</div>
					</div>
					<div class="form-group" id="serial_number">
						<div class="input-group">
							<cfinput type="text" name="serial_number" placeholder="#getLang('main',225)#" value="#attributes.serial_number#" style="width:50px;">
						</div>
					</div>
				</div>
			</div>  --->    
		</cf_box_search>
		<cf_box_search_detail>
			<div id="detail_search">
			<cfinclude template="detailed_product_search.cfm"><!---daha fazlası butonu buradan geliyor--->
			</div>
		</cf_box_search_detail>
	</cfform>
	<cf_grid_list>
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
				<cfif isdefined('xml_use_ozel_code') and xml_use_ozel_code eq 1>
					<th><cf_get_lang dictionary_id ='57789.Özel Kod'></th>
				</cfif>
				<th><cf_get_lang dictionary_id='57657.Ürün'></th>
				<cfif isdefined('xml_use_manufact_code') and xml_use_manufact_code eq 1>
					<th><cf_get_lang dictionary_id ='57634.Üretici Kodu'></th>
				</cfif>
				<cfif is_lot_no_based eq 1>
					<th><cf_get_lang dictionary_id='32916.Lot No'></th>
					<th><cf_get_lang dictionary_id='33892.Son kullanma tarihi'></th>	
					<th><cf_get_lang dictionary_id='57452.Stok'></th>
				</cfif>
				<cfif isdefined('xml_use_department_filter') and xml_use_department_filter eq 1>
					<th>
					<cfif isdefined('attributes.departmen_location_info') and listlen(attributes.departmen_location_info,'-2')>
						<cfset location_info_ = get_location_info(listfirst(attributes.departmen_location_info,'-'),listlast(attributes.departmen_location_info,'-'),0,0)>
						<cfoutput>#listfirst(location_info_,',')#</cfoutput>
					<cfelse>
						<cf_get_lang dictionary_id ='58763.Depo'>
					</cfif>
					</th>
				</cfif>
				<cfif isdefined('xml_use_other_dept_info') and listlen(xml_use_other_dept_info,'-') eq 2>
					<cfset location_info_ = get_location_info(listfirst(xml_use_other_dept_info,'-'),listlast(xml_use_other_dept_info,'-'),0,0)>
					<th><cfoutput>#listfirst(location_info_,',')#</cfoutput></th>
				</cfif>
				<th><cf_get_lang dictionary_id='57636.Birimler'></th>
			
					<cfif isdefined('is_price') and is_price>
						<th width="20"><a href="javascript://"><i class="fa fa-money" title="<cf_get_lang dictionary_id='29411.Fiyatlar'>"></i></a></th>
					</cfif>
					<th width="20"><a href="javascript://"><i class="icon-detail" title="<cf_get_lang dictionary_id='57771.Detay'>"></i></a></th>
					<th width="20"><a href="javascript://"><i class="fa fa-cubes" title="<cf_get_lang dictionary_id='58166.Stoklar'>"></i></a></th>
					<th width="20"><a href="javascript://"><i class="fa fa-file-text" title="<cf_get_lang dictionary_id ='32994.Satınalma Koşulları'>"></i></a></th>
				
			
			</tr>
		</thead>
		<tbody>
			<cfif products.recordcount>
				<cfoutput query="products">
					<cfquery name="get_units" dbtype="query">
						SELECT DISTINCT ADD_UNIT,PRODUCT_UNIT_ID,MULTIPLIER,MAIN_UNIT,QUANTITY FROM get_product_units WHERE PRODUCT_ID = #PRODUCT_ID#
					</cfquery>
						<cfquery name = "GET_PRODUCT_EXP_CENTER" datasource = "#dsn3#">
							SELECT
							<cfif isdefined('attributes.is_sale_product') and attributes.is_sale_product eq 1>
								CP.EXPENSE_CENTER_ID EXPENSE_ID,
								CP.INCOME_ITEM_ID EXPENSE_ITEM_ID,
								CP.INCOME_ACTIVITY_TYPE_ID ACTIVITY_ID,
							<cfelse>
								CP.COST_EXPENSE_CENTER_ID EXPENSE_ID,
								CP.EXPENSE_ITEM_ID EXPENSE_ITEM_ID,
								CP.ACTIVITY_TYPE_ID ACTIVITY_ID,
							</cfif>
								ET.EXPENSE_ITEM_NAME,
								EXC.EXPENSE
							FROM
								PRODUCT_PERIOD CP
								LEFT JOIN #dsn2#.EXPENSE_CENTER EXC ON 
								<cfif isdefined('attributes.is_sale_product') and attributes.is_sale_product eq 1>
									CP.EXPENSE_CENTER_ID = EXC.EXPENSE_ID
								<cfelse>
									CP.COST_EXPENSE_CENTER_ID = EXC.EXPENSE_ID
								</cfif>
								LEFT JOIN #dsn2#.EXPENSE_ITEMS ET ON 
								<cfif isdefined('attributes.is_sale_product') and attributes.is_sale_product eq 1>
									CP.INCOME_ITEM_ID = ET.EXPENSE_ITEM_ID
								<cfelse>
									CP.EXPENSE_ITEM_ID = ET.EXPENSE_ITEM_ID
								</cfif>
								WHERE CP.PRODUCT_ID = #PRODUCT_ID# AND PERIOD_ID = <cfqueryparam value = "#session.ep.period_id#" CFSQLType = "cf_sql_integer">
						</cfquery>
						
						<cfif is_expense_revenue_center eq 1>
							<cfset expense_center_id = ( isdefined("attributes.exp_cntr_code") ) ? listfirst(attributes.exp_cntr_code,';') : ''>
							<cfset expense_center_name = ( isdefined("attributes.exp_cntr_code") ) ? listlast(attributes.exp_cntr_code,';') : ''>
							<cfset expense_item_id = ( isdefined("attributes.budget_items") ) ? listfirst(attributes.budget_items,';') : ''>
							<cfset expense_item_name = ( isdefined("attributes.budget_items") ) ? listlast(attributes.budget_items,';') : ''>
							<cfif not len(expense_item_id)>
								<cfset expense_item_id = ( GET_PRODUCT_EXP_CENTER.recordcount ) ? GET_PRODUCT_EXP_CENTER.EXPENSE_ITEM_ID : ''>
								<cfset expense_item_name = ( GET_PRODUCT_EXP_CENTER.recordcount ) ? GET_PRODUCT_EXP_CENTER.EXPENSE_ITEM_NAME : ''>
							</cfif>
						<cfelse>
							<cfset expense_center_id = ( GET_PRODUCT_EXP_CENTER.recordcount ) ? GET_PRODUCT_EXP_CENTER.EXPENSE_ID : ''>
							<cfset expense_center_name = ( GET_PRODUCT_EXP_CENTER.recordcount ) ? GET_PRODUCT_EXP_CENTER.EXPENSE : ''>
							<cfset expense_item_id = ( GET_PRODUCT_EXP_CENTER.recordcount ) ? GET_PRODUCT_EXP_CENTER.EXPENSE_ITEM_ID : ''>
							<cfset expense_item_name = ( GET_PRODUCT_EXP_CENTER.recordcount ) ? GET_PRODUCT_EXP_CENTER.EXPENSE_ITEM_NAME : ''>
						</cfif>
						<cfset activity_type_id = ( GET_PRODUCT_EXP_CENTER.recordcount ) ? GET_PRODUCT_EXP_CENTER.ACTIVITY_ID : ''>
					<tr>
						<td>#stock_code#</td>
						<cfif isdefined('xml_use_ozel_code') and xml_use_ozel_code eq 1>
							<td>#product_code_2#</td>
						</cfif>
						<td>#product_name#&nbsp;#property#</td>
						<cfif isdefined('xml_use_manufact_code') and xml_use_manufact_code eq 1>
							<td>#manufact_code#</td>
						</cfif>
						<cfif is_lot_no_based eq 1>
							<td>#lot_no#</td>
							<td>#dateformat(deliver_date,dateformat_style)#</td>
							<cfif isdefined('attributes.round_number')>
								<td style="text-align:right;">#tlformat(stock_amount,round_number)#</td>
							<cfelse>
								<td style="text-align:right;">#tlformat(stock_amount,2)#</td>
							</cfif>
						</cfif>
						<cfif isdefined('xml_use_department_filter') and xml_use_department_filter eq 1>
						<td  style="text-align:right;">
							<cfif isdefined('get_dept_stock_info')>
								<cfif isdefined('xml_use_department_filter') and xml_use_department_filter eq 1 and is_lot_no_based eq 1>
									<cfset lot_no_ = replaceNocase(lot_no,'-','_','all')>
									<cfset lot_no_ = filterSpecialChars(lot_no_)>
									<cfset lot_no_ = trim(lot_no_)>
									<cfif isdefined('dept_stock_id_#stock_id#_#lot_no_#') and len(evaluate('dept_stock_id_#stock_id#_#lot_no_#'))>
										<cfset dept_amount_ = evaluate('dept_stock_id_#stock_id#_#lot_no_#')>
										<cfif isdefined('xml_dsp_unit_based_dept_stock') and xml_dsp_unit_based_dept_stock eq 1 and len(dept_amount_)>
											<cfloop query="get_units">
												<cfif len(MULTIPLIER) and MULTIPLIER neq 0><cfset temp_amount_=MULTIPLIER><cfelse><cfset temp_amount_=1></cfif>
												#TLFormat(dept_amount_/MULTIPLIER)# #ADD_UNIT#
										</cfloop>
										<cfelse>
											#TLFormat(dept_amount_)#
									</cfif>
									</cfif>
								<cfelse>
									<cfset dept_amount_=get_dept_stock_info.total_dept_stock[listfind(dept_stock_id_list,STOCK_ID)]>
									<cfif isdefined('xml_dsp_unit_based_dept_stock') and xml_dsp_unit_based_dept_stock eq 1 and len(dept_amount_)>
										<cfloop query="get_units">
											<cfif len(MULTIPLIER) and MULTIPLIER neq 0><cfset temp_amount_=MULTIPLIER><cfelse><cfset temp_amount_=1></cfif>
											#TLFormat(dept_amount_/MULTIPLIER)# #ADD_UNIT#
									</cfloop>
									<cfelse>
										#TLFormat(dept_amount_)#
								</cfif>
								</cfif>
							</cfif>
						</td>
						</cfif>
						<cfif isdefined('xml_use_other_dept_info') and listlen(xml_use_other_dept_info,'-') eq 2>
							<td  style="text-align:right;"><!--- xmlde tanımlanan 2.depoya ait stok miktarları --->
								<cfif isdefined('get_other_dept_stock_info')>
									#TLFormat(get_other_dept_stock_info.total_dept_stock_2[listfind(other_dept_stock_id_list,STOCK_ID)])#
							</cfif>
							</td>
						</cfif>
						<td>
							<cfscript>
								name_product_='#products.product_name# #products.property#';
								name_product_=ReplaceNoCase(name_product_,'"','','all');
								name_product_=ReplaceNoCase(name_product_,"'","","all");
								pro_id=products.product_id;
								stk_id=products.stock_id;
								stk_code=products.stock_code;
								brc_code=products.barcod;
								man_code=products.manufact_code;
								product_detail2 = products.PRODUCT_DETAIL2;
								/*pro_name=products.product_name;
								prop=products.property;*/
								is_inventory=products.is_inventory;
								tax_end=products.tax;
								ser_no=products.is_serial_no;
								is_production=products.is_production;
								otv_ =products.otv;
								bsmv_ = products.bsmv;
								oiv_ = products.oiv;	
								reason_code = products.reason_code;		
							</cfscript>
							<cfset product_detail2_ = Replace(product_detail2,'"','','all')>
							<cfset product_detail2 = Replace(product_detail2_,"'","","all")>
							<cfloop query="get_units">
							<!--- Urun miktar --->
								<cfset temporary_multiplier = attributes.amount_multiplier>
								<cfif len(MULTIPLIER) and MULTIPLIER neq 0><cfset temp_amount_=MULTIPLIER><cfelse><cfset temp_amount_=1></cfif>
								<cfif len(QUANTITY) and QUANTITY neq 0><cfset attributes.amount_multiplier = QUANTITY></cfif>
								<cfif isdefined("prod_order_result_") and prod_order_result_ eq 1 and is_lot_no_based eq 1>
									<a href="javascript://" onclick="add_lot_no('#products.lot_no#','#dateformat(products.deliver_date,dateformat_style)#');" class="tableyazi">#ADD_UNIT#</a>
								<cfelse>
									<a href="javascript://" onclick="per_sepete_ekle('#pro_id#', '#stk_id#', '#stk_code#', '#brc_code#', '#man_code#', '#name_product_#', '#PRODUCT_UNIT_ID#', '#get_units.main_unit#',1 ,'#ser_no#', '#flag_prc_other#', '#tax_end#','#otv_#', 1, '1', '#is_inventory#','#is_production#','','','','','','','#attributes.amount_multiplier#','#ADD_UNIT#','#temp_amount_#','<cfif is_lot_no_based eq 1>#products.lot_no#</cfif>','#products.CUSTOMS_RECIPE_CODE#','#expense_center_id#','#expense_center_name#','#expense_item_id#','#expense_item_name#','#activity_type_id#','#bsmv_#','#product_detail2#','#reason_code#','#oiv_#');" title=" #wrk_round(MULTIPLIER,8,1)# #main_unit# " class="tableyazi">#ADD_UNIT#&nbsp;</a>
								</cfif>
								<cfset attributes.amount_multiplier = temporary_multiplier>
							</cfloop>
						</td>
							<cfif isdefined('is_price') and is_price>
							<td><a onclick="per_sepete_ekle('#pro_id#','#stk_id#','#stk_code#','#brc_code#','#man_code#','#name_product_#','#PRODUCT_UNIT_ID#','', 1, '#ser_no#', #flag_prc_other# , '#tax_end#','#otv_#', '', '0', '#is_inventory#','#is_production#','','','','','','','','','<cfif is_lot_no_based eq 1>#products.lot_no#</cfif>','','#expense_center_id#','#expense_center_name#','#expense_item_id#','#expense_item_name#','#activity_type_id#','#bsmv_#','#product_detail2#','#reason_code#','#oiv_#');"><i class="fa fa-money" title="<cf_get_lang dictionary_id='29411.Fiyatlar'>"></i></a></td>
							</cfif>
							<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#PRODUCTS.PRODUCT_ID#&sid=#stock_id#','list');"><i class="icon-detail" title="<cf_get_lang dictionary_id='57771.Detay'>"></i></a></td>
							<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_product_stocks&pid=#PRODUCTS.PRODUCT_ID#&sid=#stock_id#','medium');"><i class="fa fa-cubes" title="<cf_get_lang dictionary_id='58166.Stoklar'>"></i></a></td>
							<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_product_contract&pid=#PRODUCTS.PRODUCT_ID#','list');"><i class="fa fa-file-text" title="<cf_get_lang dictionary_id ='32994.Satınalma Koşulları'>"></i></a></td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<cfset colspan_ = 11>
					<cfif is_lot_no_based eq 1>
						<cfset colspan_ = colspan_ + 1>
					</cfif>
					<td colspan="<cfoutput>#colspan_#</cfoutput>">
						<cfif not isdefined("attributes.is_submit_form")>
							<cf_get_lang dictionary_id='57701.Filtre Ediniz'>!
						<cfelse>
							<cf_get_lang dictionary_id='57484.Kayit Bulunamadi'> !
						</cfif>
					</td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
	<cfif isdefined("attributes.totalrecords") and attributes.totalrecords gt attributes.maxrows>
		<cfset adres = "#attributes.fuseaction#" >
		<cfif len(attributes.manufacturer_code)>
			<cfset adres = "#adres#&manufacturer_code=#attributes.manufacturer_code#">
		</cfif>
		<cfset adres = "#adres#&price_catid=#attributes.price_catid#&#url_str#">
		<cfif len(attributes.keyword)>
			<cfset adres = "#adres#&keyword=#attributes.keyword#">
		</cfif>
		<cfif len(attributes.keyword2)>
			<cfset adres = "#adres#&keyword2=#attributes.keyword2#">
		</cfif>
		<cfif len(attributes.search_company_id)>
			<cfset adres = "#adres#&search_company_id=#attributes.search_company_id#">
		</cfif>
		<cfif len(attributes.product_cat) and len(attributes.product_catid)>
			<cfset adres = "#adres#&product_cat=#attributes.product_cat#&product_catid=#attributes.product_catid#">
		</cfif>
		<cfif len(attributes.pos_code)>
			<cfset adres = "#adres#&pos_code=#attributes.pos_code#">
		</cfif>
		<cfif isdefined("attributes.barcode")>
			<cfset adres = "#adres#&barcode=#attributes.barcode#">
		</cfif>
		<cfif isdefined("attributes.serial_number")>
			<cfset adres = "#adres#&serial_number=#attributes.serial_number#">
		</cfif>
		<cfif isdefined("attributes.amount_multiplier")>
			<cfset adres = "#adres#&amount_multiplier=#attributes.amount_multiplier#">
		</cfif>
		<cfif isdefined("attributes.sort_type") and len(attributes.sort_type)>
			<cfset adres = "#adres#&sort_type=#attributes.sort_type#">
		</cfif>
		<cfif isDefined('attributes.list_property_id') and len(attributes.list_property_id)>
        	<cfset adres = '#adres#&list_property_id=#attributes.list_property_id#'>
        </cfif>
		<cfif isDefined('attributes.list_variation_id') and len(attributes.list_variation_id)>
            <cfset adres = '#adres#&list_variation_id=#attributes.list_variation_id#'>
        </cfif>
        <cfif isDefined("attributes.is_submit_form")>
            <cfset adres = '#adres#&is_submit_form=#attributes.is_submit_form#'>
        </cfif>
        <cfif isDefined("attributes.is_submit_form1")>
            <cfset adres = '#adres#&is_submit_form1=#attributes.is_submit_form1#'>
        </cfif>
        <cfif isDefined("attributes.is_lotno1")>
            <cfset adres = '#adres#&is_lotno1=#attributes.is_lotno1#'>
		</cfif>
		<cfif isDefined("attributes.exp_cntr_code")>
            <cfset adres = '#adres#&exp_cntr_code=#attributes.exp_cntr_code#'>
		</cfif>
		<cfif isDefined("attributes.budget_items")>
            <cfset adres = '#adres#&budget_items=#attributes.budget_items#'>
        </cfif>
		<cf_paging page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#adres#">
	</cfif>
</cf_box>
</div>
<script type="text/javascript">
	function input_control()
	{
		<cfif is_expense_revenue_center eq 1>
			if(document.price_cat.exp_cntr_code.value == "")
				{
					alert("<cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>: <cf_get_lang dictionary_id='58235.Masraf/Gelir Merkezi'>!");
					document.getElementById('exp_cntr_code').focus();
					return false;
				}
		</cfif>
		row_count=<cfoutput>#get_property_var.recordcount#</cfoutput>;
		for(r=1;r<=row_count;r++)
		{
			deger_variation_id = eval("document.price_cat.variation_id"+r);
			if(deger_variation_id!=undefined && deger_variation_id.value != "")
			{
				deger_property_id = eval("document.price_cat.property_id"+r);
				if(document.price_cat.list_property_id.value.length==0) ayirac=''; else ayirac=',';
				document.price_cat.list_property_id.value=document.price_cat.list_property_id.value+ayirac+deger_property_id.value;
				document.price_cat.list_variation_id.value=document.price_cat.list_variation_id.value+ayirac+deger_variation_id.value;
			}
		}
		if(price_cat.search_company.value.length == 0)
			price_cat.search_company_id.value = '';
		if(price_cat.employee.value.length == 0)
			price_cat.pos_code.value = '';
		if(price_cat.amount_multiplier.value.length == 0)
			price_cat.amount_multiplier.value = 1;

		<cfif not session.ep.our_company_info.unconditional_list>
			if((price_cat.keyword.value.length==0) && (price_cat.serial_number.value.length==0) && (price_cat.barcode.value.length==0) && (price_cat.search_company_id.value.length==0) && (price_cat.pos_code.value.length==0) && (price_cat.product_catid.value.length==0) && (price_cat.manufacturer_code.value.length==0))
			{
				alert("<cf_get_lang dictionary_id ='34067.En az Bir Adet Arama Kriteri Girmelisiniz'>!");
				document.getElementById('keyword').focus();
				document.price_cat.list_property_id.value="";
				document.price_cat.list_variation_id.value="";
				return false;
			}
		<cfelse>
			return true;
		</cfif>
		//price_cat.amount_multiplier.value = filterNum(price_cat.amount_multiplier.value,3);
		return true;
	}
	document.price_cat.list_property_id.value="";
	document.price_cat.list_variation_id.value="";
	document.getElementById('keyword').focus();
 	function showBudgetItems(expense_id,target,selected) //masraf merkezine bağlı bütçe kalemlerini getir
	{
		expense_id = expense_id.split(";");
        $.ajax({
		  url: '/V16/budget/cfc/budget_expense_cat.cfc?method=getBudgetItems&dsn=<cfoutput>#dsn2#</cfoutput>&expense_id=' + expense_id[0],
		  success: function(data) {
			if(data)
			{
				$('#'+target+" option[value!='']").remove();
				data = $.parseJSON( data );
				for(i=0;i<data.DATA.length;i++)
				{
					var option = $('<option/>');
					if(selected && selected == data.DATA[i][0])
						option.attr({ 'value': data.DATA[i][0], 'selected':'selected' }).text(data.DATA[i][1]);
					else
						option.attr({ 'value': data.DATA[i][0]}).text(data.DATA[i][1]);
					$('#'+target).append(option);
				}
			}
		  }
	   });
	} 
</script>
