<cfquery name="GET_EMP_POSITION_CAT_ID" datasource="#DSN#">
	SELECT POSITION_CAT_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> 
</cfquery>
<cfif isdefined("attributes.search_process_date") and isdate(attributes.search_process_date)>
	<cf_date tarih='attributes.search_process_date'>
	<cfset price_date = dateadd('h',hour(now()),attributes.search_process_date)>
<cfelse>
	<cfset price_date = now()>
</cfif>
<cfif isdefined('xml_stock_filter_default_value') and xml_stock_filter_default_value eq 1>
	<cfparam name="attributes.stok_turu" default="1">
<cfelse>
	<cfparam name="attributes.stok_turu" default="2">
</cfif>
<cfparam name="attributes.int_basket_id" default="">
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.keyword2" default=''>
<cfparam name="attributes.price_catid" default="-2">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.pos_code" default="">
<cfparam name="attributes.get_company_id" default="">
<cfparam name="attributes.get_company" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.search_product_catid" default="">
<cfparam name="attributes.product_catid" default="0">
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.brand_name" default="">
<cfparam name="attributes.serial_number" default="">
<cfparam name="attributes.tree_stock_id" default="">
<cfparam name="attributes.tree_product_name" default="">
<cfif isdefined("xml_sort_type")>
	<cfparam name="attributes.sort_type" default="#xml_sort_type#">
<cfelse>
	<cfparam name="attributes.sort_type" default="0">
</cfif>
<cfparam name="attributes.short_code_id" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfset dept_loc_info_=''>
<cfif isdefined('xml_use_department_filter') and xml_use_department_filter eq 1>
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
</cfif>
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
		<cfif isdefined('attributes.department_out') and len(attributes.department_out) and isdefined('attributes.location_out') and len(attributes.location_out)>
			(B.BRANCH_ID IN (SELECT BRANCH_ID FROM  EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) OR D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.department_out)#">)
        <cfelseif isdefined('attributes.department_in') and len(attributes.department_in) and isdefined('attributes.location_in') and len(attributes.location_in)>
			(B.BRANCH_ID IN (SELECT BRANCH_ID FROM  EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) OR D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.department_in)#">)    
		<cfelse>
			B.BRANCH_ID IN (SELECT BRANCH_ID FROM  EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
		</cfif>
</cfquery>

<cfquery name="GET_ALL_LOCATION" datasource="#DSN#">
	SELECT DEPARTMENT_ID, LOCATION_ID, COMMENT ,DEPARTMENT_LOCATION FROM STOCKS_LOCATION
</cfquery>	
<cfif isdefined('xml_use_other_dept_info') and listlen(xml_use_other_dept_info,'-') eq 2>
	<cfquery name="REAL_STOCK_LOCATION" dbtype="query">
		SELECT COMMENT FROM GET_ALL_LOCATION WHERE DEPARTMENT_LOCATION = '#xml_use_other_dept_info#'
	</cfquery>	
</cfif>
<cfif isdefined('xml_use_other_dept_info_ss') and listlen(xml_use_other_dept_info_ss,'-') eq 2>
	<cfquery name="REAL_STOCK_LOCATION_SS" dbtype="query">
		SELECT COMMENT FROM GET_ALL_LOCATION WHERE DEPARTMENT_LOCATION = '#xml_use_other_dept_info_ss#'
	</cfquery>	
</cfif>
<cfparam name="attributes.departmen_location_info" default="#dept_loc_info_#">
<cfif isDefined('attributes.amount_multiplier')>
	<cfset attributes.amount_multiplier = filterNum(attributes.amount_multiplier)>
</cfif>
<cfif not (isDefined('attributes.amount_multiplier') and isnumeric(attributes.amount_multiplier) and attributes.amount_multiplier gt 0)>
	<cfset attributes.amount_multiplier = 1>
</cfif>
<cfif isdefined('attributes.sepet_process_type') and attributes.sepet_process_type neq 52 and attributes.sepet_process_type neq 69><!--- perakende satıs faturasında standart satış fiyat listesine bakılır--->
	<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
		<cfquery name="GET_CREDIT_LIMIT" datasource="#DSN#">
			SELECT 
				PRICE_CAT
			FROM 
				COMPANY_CREDIT
			WHERE 
				COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
				AND OUR_COMPANY_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
		</cfquery>
		<cfquery name="GET_COMP_CAT" datasource="#DSN#">
			SELECT COMPANYCAT_ID FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
		</cfquery>
		<cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
			SELECT 
				PRICE_CATID,
				PRICE_CAT 
			FROM 
				PRICE_CAT 
			WHERE
				<cfif (isdefined('xml_use_member_price_cat_sales') and xml_use_member_price_cat_sales eq 1)><!--- xmlde sadece risk bilgilerinde tanımlı fiyat listesi gelsin secili ise --->
					<cfif GET_CREDIT_LIMIT.RECORDCOUNT and len(GET_CREDIT_LIMIT.PRICE_CAT)>
						(
							PRICE_CAT_STATUS = 1
							AND PRICE_CATID IN (SELECT PC.PRICE_CATID FROM PRICE_CAT_EXCEPTIONS PC WHERE PC.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND PC.ACT_TYPE = 2 AND PC.PURCHASE_SALES = 1)
						) 
					<cfelse>
						1=2
					</cfif>
				<cfelse>
				(
					<cfif GET_CREDIT_LIMIT.RECORDCOUNT and len(GET_CREDIT_LIMIT.PRICE_CAT)>
						(
							PRICE_CAT_STATUS = 1
							AND PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CREDIT_LIMIT.PRICE_CAT#">
						) 
						OR 
					</cfif>
					(
						PRICE_CAT_STATUS = 1
						<cfif basket_prod_list.PRODUCT_SELECT_TYPE neq 13>
							AND COMPANY_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_comp_cat.companycat_id#,%">
						<cfelse><!--- fiyat listeli popupda odeme yontemine gore fiyat listeleri gelir --->
							<cfif isdefined("attributes.card_paymethod_id") and len(attributes.card_paymethod_id)>
								AND PRICE_CAT.PAYMETHOD = 4
							<cfelseif isdefined("attributes.paymethod_vehicle") and len(attributes.paymethod_vehicle)>
								AND PRICE_CAT.PAYMETHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.paymethod_vehicle#">
							<cfelseif isdefined("attributes.paymethod_id") and len(attributes.paymethod_id)>
								AND PRICE_CAT.PAYMETHOD = ISNULL((SELECT PAYMENT_VEHICLE FROM #dsn_alias#.SETUP_PAYMETHOD WHERE PAYMETHOD_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.paymethod_id#">),0)
							</cfif>
						</cfif>
					)
				)
				</cfif>
				<cfif (isdefined("attributes.var_") and (session.ep.isBranchAuthorization)) or (isdefined('attributes.is_store_module'))>
					AND PRICE_CAT.BRANCH LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#LISTGETAT(SESSION.EP.USER_LOCATION,2,"-")#,%">
				</cfif>
				<cfif attributes.is_sale_product eq 0>
					AND IS_PURCHASE = 1
				<cfelse>
					AND IS_SALES = 1
				</cfif>
				<!--- Pozisyon tipine gore yetki veriliyor  --->
				<cfif xml_related_position_cat eq 1>
					AND POSITION_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_emp_position_cat_id.position_cat_id#,%">
				</cfif>
				<!--- //Pozisyon tipine gore yetki veriliyor  --->
			ORDER BY
				PRICE_CAT
		</cfquery>
		<cfif not GET_PRICE_CAT.RECORDCOUNT>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id ='34070.Kurumsal Üyeyi Bir Fiyat Listesine Dahil Ediniz'>!");
				window.close();
			</script>
			<cfabort>
		</cfif>
		<cfif isdefined('prj_disc_price_catid') and len(prj_disc_price_catid)><!---belgede seçilen projenin bağlantısında seçili fiyat listesi --->
			<cfset attributes.price_catid=prj_disc_price_catid>
		<cfelseif GET_CREDIT_LIMIT.recordcount and len(GET_CREDIT_LIMIT.PRICE_CAT)>
			<cfset attributes.price_catid = GET_CREDIT_LIMIT.PRICE_CAT>
		<cfelseif isdefined('xml_use_standard_price_cat') and len(xml_use_standard_price_cat)>
			<cfset attributes.price_catid = xml_use_standard_price_cat>
		<cfelseif GET_PRICE_CAT.RECORDCOUNT>
			<cfset attributes.price_catid=-2>
		</cfif>
	<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
		<cfquery name="GET_CREDIT_LIMIT" datasource="#DSN#">
			SELECT 
				PRICE_CAT
			FROM 
				COMPANY_CREDIT
			WHERE 
				CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
				AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
		</cfquery>
		<cfquery name="GET_COMP_CAT" datasource="#DSN#">
			SELECT CONSUMER_CAT_ID FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
		</cfquery>
		<cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
			SELECT 
				PRICE_CATID,
				PRICE_CAT 
			FROM 
				PRICE_CAT 
			WHERE
				<cfif (isdefined('xml_use_member_price_cat_sales') and xml_use_member_price_cat_sales eq 1)>
					<cfif GET_CREDIT_LIMIT.RECORDCOUNT and len(GET_CREDIT_LIMIT.PRICE_CAT)>
						(
							PRICE_CAT_STATUS = 1
							AND PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CREDIT_LIMIT.PRICE_CAT#">
						)
					<cfelse>
						1=2
					</cfif>
				<cfelse>
				(
					<cfif GET_CREDIT_LIMIT.RECORDCOUNT and len(GET_CREDIT_LIMIT.PRICE_CAT)>
						(
							PRICE_CAT_STATUS = 1
							AND PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_CREDIT_LIMIT.PRICE_CAT#">
						) 
						OR
					</cfif>
					(
						PRICE_CAT_STATUS = 1
						<cfif basket_prod_list.PRODUCT_SELECT_TYPE neq 13>
							AND CONSUMER_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_comp_cat.consumer_cat_id#,%">
						<cfelse><!--- fiyat listeli popupda odeme yontemine gore fiyat listeleri gelir --->
							<cfif isdefined("attributes.card_paymethod_id") and len(attributes.card_paymethod_id)>
								AND PRICE_CAT.PAYMETHOD = 4
							<cfelseif isdefined("attributes.paymethod_vehicle") and len(attributes.paymethod_vehicle)>
								AND PRICE_CAT.PAYMETHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.paymethod_vehicle#">
							</cfif>
							<cfif (isdefined("attributes.var_") and (session.ep.isBranchAuthorization)) or (isdefined('attributes.is_store_module'))>
								AND PRICE_CAT.BRANCH LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#LISTGETAT(SESSION.EP.USER_LOCATION,2,"-")#,%">
							</cfif>
						</cfif>
					)
				)
				</cfif>
				<cfif (isdefined("attributes.var_") and (session.ep.isBranchAuthorization)) or (isdefined('attributes.is_store_module'))>
					AND PRICE_CAT.BRANCH LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#LISTGETAT(SESSION.EP.USER_LOCATION,2,"-")#,%">
				</cfif>
				<cfif attributes.is_sale_product eq 0>
					AND IS_PURCHASE = 1
				<cfelse>
					AND IS_SALES = 1
				</cfif>
				<!--- Pozisyon tipine gore yetki veriliyor  --->
				<cfif xml_related_position_cat eq 1>
					AND POSITION_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_emp_position_cat_id.position_cat_id#,%">
				</cfif>
				<!--- //Pozisyon tipine gore yetki veriliyor  --->
			ORDER BY
				PRICE_CAT
		</cfquery>
		
		<cfif not get_price_cat.recordcount>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id ='34071.Bireysel Üyeyi Bir Fiyat Listesine Dahil Ediniz'>!");
				window.close();
			</script>
			<cfabort>
		</cfif>
		<cfif isdefined('prj_disc_price_catid') and len(prj_disc_price_catid)><!---belgede seçilen projenin bağlantısında seçili fiyat listesi --->
			<cfset attributes.price_catid=prj_disc_price_catid>
		<cfelseif GET_CREDIT_LIMIT.RECORDCOUNT and len(GET_CREDIT_LIMIT.PRICE_CAT)>
			<cfset attributes.price_catid = GET_CREDIT_LIMIT.PRICE_CAT>
		<cfelseif isdefined('xml_use_standard_price_cat') and len(xml_use_standard_price_cat)>
			<cfset attributes.price_catid = xml_use_standard_price_cat>
		<cfelseif GET_PRICE_CAT.RECORDCOUNT>
			<cfset attributes.price_catid=-2>
		</cfif>
    <cfelseif isdefined("attributes.employee_id") and len(attributes.employee_id)><!--- calisanda tum fiyat listeleri geliyor --->
    	<cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
    		SELECT 
            	PRICE_CATID,
                PRICE_CAT 
            FROM 
            	PRICE_CAT 
            WHERE 
            	PRICE_CAT_STATUS = 1 
                <cfif attributes.is_sale_product eq 0>
					AND IS_PURCHASE = 1
				<cfelse>
					AND IS_SALES = 1
				</cfif>
            ORDER BY PRICE_CAT
        </cfquery>
	</cfif>
<cfelse>
	<cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
		SELECT 
			PRICE_CATID,
			PRICE_CAT 
		FROM 
			PRICE_CAT 
		WHERE
			PRICE_CAT_STATUS = 1
			<cfif basket_prod_list.PRODUCT_SELECT_TYPE neq 13>
				<cfif (isdefined("attributes.var_") and (session.ep.isBranchAuthorization)) or (isdefined('attributes.is_store_module') and isdefined('attributes.sepet_process_type') and listfind('49,51,52,54,55,59,60,601,63,591',attributes.sepet_process_type))><!--- alış ve parekende satış faturalarında subeyle iliskili fiyat listeleri seciliyor --->
					AND PRICE_CAT.BRANCH LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#LISTGETAT(SESSION.EP.USER_LOCATION,2,"-")#,%">
				</cfif>
			</cfif>
			<!--- Pozisyon tipine gore yetki veriliyor  --->
			<cfif xml_related_position_cat eq 1>
				AND POSITION_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_emp_position_cat_id.position_cat_id#,%">
			</cfif>
			<!--- //Pozisyon tipine gore yetki veriliyor  --->
		ORDER BY
			PRICE_CAT
	</cfquery>
	<cfif isdefined('prj_disc_price_catid') and len(prj_disc_price_catid)><!---belgede seçilen projenin bağlantısında seçili fiyat listesi --->
		<cfset attributes.price_catid=prj_disc_price_catid>
	<cfelseif isdefined('xml_use_standard_price_cat') and len(xml_use_standard_price_cat)>
		<cfset attributes.price_catid = xml_use_standard_price_cat>
	<cfelseif get_price_cat.recordcount>
		<cfset attributes.price_catid=get_price_cat.PRICE_CATID>
	</cfif>
</cfif>

<!--- form veya urlden geldi ise fiyat listesi o olmalı bu nedenle atanıyor ancak sayfa baındaki cfparam ile -2 atandığından burda attributes ile yapılmadı--->
<cfif isdefined("form.price_catid") and len(form.price_catid)>
	<cfset attributes.price_catid=form.price_catid>
<cfelseif isdefined("url.price_catid") and len(url.price_catid)>
	<cfset attributes.price_catid=url.price_catid>
</cfif>
<cfquery name="GET_PRICE_EXCEPTIONS_ALL" datasource="#DSN3#">
	SELECT
		*
	FROM 
		PRICE_CAT_EXCEPTIONS
	WHERE
		ISNULL(IS_GENERAL,0)=0 AND <!--- urun tanımlarındaki istisnai fiyat listelerinden tanımlananlar burada geçerli olmayacak--->
		ACT_TYPE = 1 AND
	<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
	<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
		CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
	<cfelse>
		1=0
	</cfif>	
</cfquery>
<cfquery name="GET_PRICE_EXCEPTIONS_PID" dbtype="query">
	SELECT * FROM GET_PRICE_EXCEPTIONS_ALL WHERE PRODUCT_ID IS NOT NULL
</cfquery>
<cfquery name="GET_PRICE_EXCEPTIONS_PCATID" dbtype="query">
	SELECT * FROM GET_PRICE_EXCEPTIONS_ALL WHERE PRODUCT_CATID IS NOT NULL
</cfquery>
<cfquery name="GET_PRICE_EXCEPTIONS_BRID" dbtype="query">
	SELECT * FROM GET_PRICE_EXCEPTIONS_ALL WHERE BRAND_ID IS NOT NULL
</cfquery>
<cfquery name="GET_PRICE_EXCEPTIONS_SHORTCODE" dbtype="query">
	SELECT * FROM GET_PRICE_EXCEPTIONS_ALL WHERE SHORT_CODE_ID IS NOT NULL
</cfquery>
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

<cfinclude template="../query/get_moneys.cfm">
<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../query/get_products_sales_it.cfm">
<cfelse>
	<cfset products.recordcount = 0>
</cfif>
<cfif products.recordcount>
	<cfparam name="attributes.totalrecords" default="#products.query_count#">
<cfelse>
	<cfparam name="attributes.totalrecords" default="#products.recordcount#">	
</cfif>
<cfinclude template="../query/get_default_money.cfm">
<cfset stock_list="">
<cfset product_id_list=''>
<cfset work_stock_id_list=''>
<cfif products.recordcount gt 0>
	<cfoutput query="products" >
		<cfset stock_list = listappend(stock_list,STOCK_ID)>
	</cfoutput>
	<cfoutput query="products">
		<cfif not listfind(product_id_list,products.PRODUCT_ID)>
			<cfset product_id_list = listappend(product_id_list,products.PRODUCT_ID)>
		</cfif>
	</cfoutput>
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
	<cfif len(product_id_list)>
		<cfquery name="GET_PRODUCT_UNITS" datasource="#DSN3#">
			SELECT ADD_UNIT,MAIN_UNIT,MULTIPLIER,PRODUCT_UNIT_ID,PRODUCT_ID FROM PRODUCT_UNIT WHERE PRODUCT_ID IN (#product_id_list#) AND PRODUCT_UNIT_STATUS = 1
		</cfquery>
	</cfif>
</cfif>
<cfif len(stock_list)>
	<cfinclude template="../query/get_artan_azalan_stock.cfm">
	<cfquery name="GET_PROM_ALL" datasource="#dsn3#">
		SELECT
			PROMOTIONS.DISCOUNT,
			PROMOTIONS.AMOUNT_DISCOUNT,
			PROMOTIONS.TOTAL_PROMOTION_COST,
			PROMOTIONS.TOTAL_PROMOTION_COST_MONEY,
			PROMOTIONS.PROM_HEAD,
			PROMOTIONS.FREE_STOCK_ID,
			PROMOTIONS.PROM_ID,
			PROMOTIONS.LIMIT_VALUE,
			PROMOTIONS.FREE_STOCK_AMOUNT,
			PROMOTIONS.COMPANY_ID,
			PROMOTIONS.FREE_STOCK_PRICE,
			PROMOTIONS.AMOUNT_1_MONEY,
			PROMOTIONS.PRICE_CATID,
			STOCKS.STOCK_ID,
			GS.PRODUCT_STOCK
		FROM
			STOCKS,
			PROMOTIONS,
			#new_dsn2#.GET_STOCK GS
		WHERE
			PROMOTIONS.PROM_STATUS = 1 AND 	
			PROMOTIONS.PROM_TYPE = 1 AND 	<!--- Satira Uygulanir --->
			PROMOTIONS.LIMIT_TYPE = 1 AND 	<!--- Birim  --->
			GS.STOCK_ID = STOCKS.STOCK_ID AND
			PROMOTIONS.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#"> AND
			STOCKS.STOCK_ID IN (#stock_list#) AND
			(PROMOTIONS.STOCK_ID IS NULL OR STOCKS.STOCK_ID = PROMOTIONS.STOCK_ID) AND
			(PROMOTIONS.BRAND_ID IS NULL OR STOCKS.BRAND_ID = PROMOTIONS.BRAND_ID) AND 
			(PROMOTIONS.PRODUCT_CATID IS NULL OR STOCKS.PRODUCT_CATID = PROMOTIONS.PRODUCT_CATID) AND				
			<!--- (
				STOCKS.STOCK_ID = PROMOTIONS.STOCK_ID
				OR STOCKS.BRAND_ID = PROMOTIONS.BRAND_ID
				OR STOCKS.PRODUCT_CATID = PROMOTIONS.PRODUCT_CATID
				<!--- OR PROMOTIONS.STOCK_ID IS NULL --->
			)	AND --->
			PROMOTIONS.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#price_date#"> AND
			PROMOTIONS.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#price_date#">
			<cfif attributes.stok_turu eq 2>AND GS.PRODUCT_STOCK > 0</cfif>
	</cfquery>
</cfif>

<cfquery name="GET_DEPS" datasource="#DSN#">
	SELECT
		DEPARTMENT_ID,
		DEPARTMENT_HEAD
	FROM
		DEPARTMENT
	WHERE
		IS_STORE <> 2
	<cfif isdefined("attributes.is_store") and attributes.is_store>
		AND BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">
	</cfif>
	ORDER BY DEPARTMENT_HEAD
</cfquery>
<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 11>
	<cfquery name="GET_SHELVES" datasource="#DSN3#">
		SELECT
			PRODUCT_PLACE_ID,
			SHELF_CODE
		FROM 
			PRODUCT_PLACE
		WHERE
			PLACE_STATUS=1
		ORDER BY 
			PRODUCT_PLACE_ID
	</cfquery>
	<cfset shelf_code_list = valuelist(get_shelves.PRODUCT_PLACE_ID)>
</cfif>
<cfset url_str = "">
<cfif isdefined("module_name")>
	<cfset url_str = "#url_str#&module_name=#module_name#">
</cfif>
<cfif isdefined("attributes._spec_page_")>
	<cfset url_str = "#url_str#&_spec_page_=#attributes._spec_page_#">
</cfif>
<cfif isdefined("attributes.update_product_row_id")>
	<cfset url_str = "#url_str#&update_product_row_id=#attributes.update_product_row_id#">
</cfif>
<cfif isdefined("attributes.int_basket_id")>
	<cfset url_str = "#url_str#&int_basket_id=#attributes.int_basket_id#">
</cfif>
<cfif isDefined("attributes.company_id")>
	<cfset url_str = "#url_str#&company_id=#attributes.company_id#">
</cfif>
<cfif isDefined("attributes.consumer_id")>
	<cfset url_str = "#url_str#&consumer_id=#attributes.consumer_id#">
</cfif>
<cfif isDefined("attributes.is_sale_product")>
	<cfset url_str = "#url_str#&is_sale_product=#attributes.is_sale_product#">
</cfif>
<cfif isdefined("attributes.is_cost")>
	<cfset url_str = "#url_str#&is_cost=#attributes.is_cost#">
</cfif>
<cfif isDefined('attributes.rowcount') and len(attributes.rowcount) >
	<cfset url_str = "#url_str#&rowcount=#attributes.rowcount#">
</cfif>
<cfif isdefined("attributes.department_out")>
	<cfset url_str = "#url_str#&department_out=#attributes.department_out#">
</cfif>
<cfif isdefined("is_lot_no_based")>
		<cfset url_str = "#url_str#&is_lot_no_based=#is_lot_no_based#">
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
<cfif isdefined("attributes.branch_id") and len(attributes.branch_id) >
	<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
</cfif>
<cfif isdefined("attributes.search_process_date") and isdate(attributes.search_process_date)>
	<cfset url_str = "#url_str#&search_process_date=#dateformat(attributes.search_process_date,dateformat_style)#">
</cfif>
<cfif isdefined("sepet_process_type") >
 <cfset url_str = "#url_str#&sepet_process_type=#sepet_process_type#">
</cfif>
<cfif isdefined("attributes.unsalable")><!--- satış olmayan lokasyonlarda gelmesi icin --->
	<cfset url_str = "#url_str#&unsalable=#attributes.unsalable#">
</cfif>
<cfif isdefined("attributes.is_store_module")>
	<cfset url_str = "#url_str#&is_store_module=#attributes.is_store_module#">
</cfif>
<cfif isDefined('attributes.is_condition_sale_or_purchase') and len(attributes.is_condition_sale_or_purchase)>
	<cfset url_str = "#url_str#&is_condition_sale_or_purchase=#attributes.is_condition_sale_or_purchase#">
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
<cfif not (isdefined('xml_use_project_filter') and xml_use_project_filter eq 1) and isdefined("attributes.project_id")> <!--- xmlde proje filtresi secilmemis, fakat listeye cagrıldıgı belgedeki proje id gonderilmisse --->
	<cfset url_str = "#url_str#&project_id=#attributes.project_id#">
</cfif>
<cfloop query="moneys">
	<cfif isdefined("attributes.#money#") >
		<cfset url_str = "#url_str#&#money#=#evaluate("attributes.#money#")#">
	</cfif>
</cfloop>
<cfif isdefined("attributes.satir")>
	<cfset url_str = "#url_str#&satir=#attributes.satir#">
</cfif>
<cfif isdefined('xml_use_department_filter') and xml_use_department_filter eq 1 and isdefined("attributes.departmen_location_info") and len(attributes.departmen_location_info)>
	<cfset url_str = "#url_str#&departmen_location_info=#attributes.departmen_location_info#">
</cfif>
<cfset url_str_form = url_str>
<cfset url_str = '#url_str#&form_submitted=1'>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='58964.Fiyat Listesi'></cfsavecontent>
	<cf_box title="#message#">
		<cf_wrk_alphabet keyword="url_str" popup_box="#iif(isdefined("attributes.draggable"),1,0)#"><!--- Harfler --->
		<cfform name="price_cat" action="#request.self#?fuseaction=objects.popup_products#url_str_form#" method="post">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<input type="hidden" name="list_property_id" id="list_property_id" value="<cfif isdefined("attributes.list_property_id")><cfoutput>#attributes.list_property_id#</cfoutput></cfif>">
			<input type="hidden" name="list_variation_id" id="list_variation_id" value="<cfif isdefined("attributes.list_variation_id")><cfoutput>#attributes.list_variation_id#</cfoutput></cfif>">
			<cfif isDefined("attributes.from_product_config")><input type="hidden" name ="from_product_config" id="from_product_config" value=""></cfif>
			<cf_box_search>
				<div class="form-group" id="item-keyword">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" value="#attributes.keyword#" placeholder="#message#">
				</div>
				<div class="form-group" id="item-sort_type">     
					<select name="sort_type" id="sort_type">
						<option value="0" <cfif attributes.sort_type eq 0>selected</cfif>><cf_get_lang dictionary_id='34282.Ürün Adına Göre'></option>
						<option value="1" <cfif attributes.sort_type eq 1>selected</cfif>><cf_get_lang dictionary_id='32751.Stok Koduna Göre'></option>
						<option value="2" <cfif attributes.sort_type eq 2>selected</cfif>><cf_get_lang dictionary_id='32764.Özel Koda Göre'></option>
					</select>
				</div>	
				<div class="form-group" id="item-product_cat">
					<div class="input-group">		
						<input type="hidden" name="search_product_catid" id="search_product_catid" value="<cfoutput>#attributes.search_product_catid#</cfoutput>">
						<input type="hidden" name="product_catid" id="product_catid" value="<cfoutput>#attributes.product_catid#</cfoutput>">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57486.Kategori'></cfsavecontent>
						<input type="text" name="product_cat" id="product_cat" placeholder="<cfoutput>#message#</cfoutput>" value="<cfoutput>#attributes.product_cat#</cfoutput>" onfocus="AutoComplete_Create('product_cat','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID,HIERARCHY','product_catid,search_product_catid','','3','200');" autocomplete="off">
						<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://"onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=price_cat.product_catid&field_hierarchy=price_cat.search_product_catid&field_name=price_cat.product_cat&keyword='+encodeURIComponent(document.price_cat.product_cat.value)</cfoutput>);"></span>
					</div>
				</div> 
				<div class="form-group" id="item-brand_name">
					<div class="input-group">
						<cfif len(attributes.brand_id) and len(attributes.brand_name)>
							<cfquery name="GET_BRAND_NAME" datasource="#DSN3#">
								SELECT BRAND_NAME FROM PRODUCT_BRANDS WHERE BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#">
							</cfquery>
						</cfif>
						<input type="Hidden" name="brand_id" id="brand_id" value="<cfoutput>#attributes.brand_id#</cfoutput>">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='58847.Marka'></cfsavecontent>
						<input type="Text" name="brand_name" id="brand_name" placeholder="<cfoutput>#message#</cfoutput>" onfocus="AutoComplete_Create('brand_name','BRAND_NAME','BRAND_NAME','get_brand','','BRAND_ID','brand_id','','3','100');"  value="<cfoutput>#attributes.brand_name#</cfoutput>" autocomplete="off">
						<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_product_brands&brand_id=price_cat.brand_id&brand_name=price_cat.brand_name</cfoutput>','list');"></span>
					</div>
				</div>	   	
				<div class="form-group" id="item-short_code_id">
					<cfif isdefined('xml_short_code') and xml_short_code eq 1>
						<cf_wrkproductmodel
							returninputvalue="short_code_id,short_code_name"
							returnqueryvalue="MODEL_ID,MODEL_NAME"
							width="80"
							fieldname="short_code_name"
							fieldid="short_code_id"
							compenent_name="getProductModel"            
							boxwidth="250"
							boxheight="150"                        
							model_id="#attributes.short_code_id#">
					</cfif>
				</div>	 
				<cfif isdefined('xml_use_department_filter') and xml_use_department_filter eq 1>
					<div class="form-group" id="item-departmen_location_info">
						<select name="departmen_location_info" id="departmen_location_info">
							<option value=""><cf_get_lang dictionary_id='58763.Depo'></option>
							<cfoutput query="get_department">
								<optgroup label="#department_head#">
								<cfquery name="GET_LOCATION" dbtype="query">
									SELECT * FROM GET_ALL_LOCATION WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_department.department_id[currentrow]#">
								</cfquery>
								<cfif get_location.recordcount>
									<cfloop from="1" to="#get_location.recordcount#" index="s">
										<option value="#department_id#-#get_location.location_id[s]#" <cfif len(attributes.departmen_location_info) and attributes.departmen_location_info is '#department_id#-#get_location.location_id[s]#'>selected</cfif>>&nbsp;&nbsp;#get_location.comment[s]#</option>
									</cfloop>
								</cfif>
								</optgroup>					  
							</cfoutput>
						</select>
					</div>
				</cfif>
				<div class="form-group" id="item-price_catid">
					<select name="price_catid" id="price_catid">
						<cfset kontrol_ = 0>
						<cfif xml_use_member_price_cat_sales eq 0><!--- Eğer sadece müşteri fiyat listeleri gelsin seçilmemişse standart satış gelsin --->
							<!--- <cfif not ((isdefined("attributes.card_paymethod_id") and len(attributes.card_paymethod_id)) or (isdefined("attributes.paymethod_vehicle") and len(attributes.paymethod_vehicle)))>sm kapattı 20130513--->
							<cfif session.ep.our_company_info.unconditional_list or attributes.price_catid is '-2'>
							<cfset kontrol_ = 1>
							<option value="-2" <cfif attributes.price_catid is '-2'>selected</cfif>><cf_get_lang dictionary_id='58721.Standart Satış'></option>
							</cfif>
						</cfif>
						<cfif isdefined('GET_PRICE_CAT') and GET_PRICE_CAT.RECORDCOUNT>
							<cfif attributes.price_catid eq -2 and kontrol_ eq 0><cfset attributes.price_catid = GET_PRICE_CAT.price_catid></cfif>
							<cfoutput query="GET_PRICE_CAT">
								<option value="#price_catid#" <cfif GET_PRICE_CAT.price_catid eq attributes.price_catid> selected</cfif>>#price_cat#</option>
								<!--- TolgaS 20080224 option bu kuşulla bağlıydı neden ? <cfif session.ep.our_company_info.unconditional_list or GET_PRICE_CAT.price_catid is attributes.price_catid></cfif>--->
							</cfoutput>
						</cfif> 
					</select>
				</div>
				
				<div class="form-group" id="item-employee">
					<div class="input-group">
						<input type="hidden" name="pos_code" id="pos_code"  value="<cfoutput>#attributes.pos_code#</cfoutput>">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57544.Sorumlu'></cfsavecontent>
						<input type="text" name="employee" id="employee" placeholder="<cfoutput>#message#</cfoutput>" value="<cfoutput>#attributes.employee#</cfoutput>"  maxlength="255" onfocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE','pos_code','','3','135');" autocomplete="off">
						<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=price_cat.pos_code&field_name=price_cat.employee&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.price_cat.employee.value),'list');"></span>
					</div>
				</div>	   
				<div class="form-group" id="item-get_company">
					<div class="input-group">		
						<input type="hidden" name="get_company_id" id="get_company_id" value="<cfoutput>#attributes.get_company_id#</cfoutput>">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='29533.Tedarikçi'></cfsavecontent>
						<input type="text" name="get_company" id="get_company" placeholder="<cfoutput>#message#</cfoutput>" value="<cfoutput>#attributes.get_company#</cfoutput>" onfocus="AutoComplete_Create('get_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','get_company_id','','3','250');" autocomplete="off">
						<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=price_cat.get_company&field_comp_id=price_cat.get_company_id&select_list=2&is_form_submitted=1&keyword='+encodeURIComponent(document.price_cat.get_company.value),'list');"></span>
					</div>
				</div>
				 
				<div class="form-group" id="item-project_head">
					<cfif isdefined('xml_use_project_filter') and xml_use_project_filter eq 1>
						<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id') and len (attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57416.Proje'></cfsavecontent>
						<input type="text" name="project_head"  id="project_head" placeholder="<cfoutput>#message#</cfoutput>" readonly value="<cfif isdefined('attributes.project_id') and len (attributes.project_id)><cfoutput>#GET_PROJECT_NAME(attributes.project_id)#</cfoutput></cfif>" autocomplete="off">
					</cfif>
				</div> 	
				<div class="form-group" id="item-stok_turu">
					<select name="stok_turu" id="stok_turu">
						<option value="1" <cfif attributes.stok_turu eq 1 >selected</cfif>><cf_get_lang dictionary_id='58081.Hepsi'></option>
						<option value="2" <cfif attributes.stok_turu eq 2 > selected </cfif>><cf_get_lang dictionary_id='33476.Stokta Olanlar'></option>									
					</select>
				</div>
				<cfif isdefined('xml_use_tree_filter') and xml_use_tree_filter eq 1>		
					<div class="form-group" id="item-stok_turu">
						<input type="hidden" name="tree_stock_id" id="tree_stock_id" <cfif len(attributes.tree_stock_id) and len(attributes.tree_product_name)>value="<cfoutput>#attributes.tree_stock_id#</cfoutput>"</cfif>>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='58901.Ağaç'></cfsavecontent>
						<input name="tree_product_name" type="text" id="tree_product_name" placeholder="<cfoutput>#message#</cfoutput>" onfocus="AutoComplete_Create('tree_product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','STOCK_ID','tree_stock_id','','3','100');" value="<cfif len(attributes.tree_stock_id) and len(attributes.tree_product_name)><cfoutput>#attributes.tree_product_name#</cfoutput></cfif>" autocomplete="off">
						<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=price_cat.tree_stock_id&field_name=price_cat.tree_product_name&is_production=1&keyword='+encodeURIComponent(document.price_cat.tree_product_name.value),'list');"></span>   
					</div>
				</cfif>		 
				<div class="form-group" id="keyword2">
					<cfif is_lot_no_based eq 1>  
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='32916.Lot No'></cfsavecontent>          
						<cfinput type="text" name="keyword2" id="keyword2" placeholder="#message#" value="#attributes.keyword2#">
					</cfif>
				</div>	
				<div class="form-group medium" id="item-amount_multiplier">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57635.Miktar'></cfsavecontent>
					<input type="text" name="amount_multiplier" id="amount_multiplier" placeholder="<cfoutput>#message#</cfoutput>" value="<cfoutput>#amountformat(attributes.amount_multiplier,3)#</cfoutput>" onkeyup="return FormatCurrency(this,event,3);" class="moneybox">
				</div>	
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
				</div>	
				<div class="form-group">
					<cf_wrk_search_button search_function='input_control()' button_type="4">
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div id="detail_search">
					<cfif isdefined('xml_product_features_filter') and xml_product_features_filter eq 1>
						<cfinclude template="detailed_product_search.cfm">
					</cfif>
				</div>
			</cf_box_search_detail>	
		</cfform>
		<cf_grid_list>
			<thead> 
				<cfset colspan=5>
				<cfif isdefined('xml_is_dsp_stock_code') and xml_is_dsp_stock_code eq 1>
					<th width="80"><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
					<cfset colspan=colspan+1>
				</cfif> 
				<cfif isdefined('xml_use_ozel_code') and xml_use_ozel_code eq 1>
					<th><cf_get_lang dictionary_id ='57789.Özel Kod'></th>
					<cfset colspan=colspan+1>
				</cfif>
				<th class="form-title" width="200"><cf_get_lang dictionary_id='57657.Ürün'></th>
				<cfif (basket_prod_list.PRODUCT_SELECT_TYPE eq 13 or basket_prod_list.PRODUCT_SELECT_TYPE eq 11 ) and attributes.int_basket_id neq 4>
					<cfif is_lot_no_based eq 1>
						<th><cf_get_lang dictionary_id='32916.Lot No'></th>
						<cfset colspan=colspan+1>
					</cfif>
				</cfif>
				<cfif isdefined('xml_is_list_products') and xml_is_list_products eq 1>
					<th width="200"><cf_get_lang dictionary_id='34281.Ürün Açıklaması'></th>
					<cfset colspan=colspan+1>
				</cfif>
				<cfif listfind('6,9',basket_prod_list.PRODUCT_SELECT_TYPE,',')>
					<th width="30"><cf_get_lang dictionary_id='57647.Spec'></th>
					<cfset colspan=colspan+1>
				</cfif>
				<cfif listfind('2,3,8,9',basket_prod_list.PRODUCT_SELECT_TYPE,',') and xml_use_manufact_code eq 1>
					<th><cf_get_lang dictionary_id='57634.Üretici Kodu'></th>
					<cfset colspan=colspan+1>
				</cfif>
				<cfif listfind('8,9',basket_prod_list.PRODUCT_SELECT_TYPE,',')>
					<th width="110" style="text-align:right;"><cf_get_lang dictionary_id='57784.İşçilik'></th>
					<cfset colspan=colspan+1>
				</cfif>
				<cfif isdefined('xml_dsp_prod_price') and xml_dsp_prod_price eq 1>
					<th width="110" style="text-align:right;"> <cf_get_lang dictionary_id='34069.Son Kullanıcı Fiyat'></th>
					<cfset colspan=colspan+1>
				</cfif>
				<th width="90"  class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='33477.Müşteri Fiyat'></th>
				<cfif basket_prod_list.PRODUCT_SELECT_TYPE eq 11>
				<cfif xml_group_shelf eq 0>
					<th width="100"  nowrap><cf_get_lang dictionary_id ='33892.Son Kullanma Tarihi'></th>
				</cfif>
					<th width="70" style="text-align:center;" nowrap><cf_get_lang dictionary_id ='30001.Raf Bilgisi'></th>
					<th width="50"  nowrap style="text-align:right;"><cf_get_lang dictionary_id ='57452.Stok'></th>
					<cfset colspan=colspan+3>
				</cfif>
				<cfif basket_prod_list.PRODUCT_SELECT_TYPE neq 11>
					<th width="50" style="text-align:right;"><cf_get_lang dictionary_id='57452.Stok'></th>
					<th width="50" style="text-align:right;"><cf_get_lang dictionary_id='32544.Satılabilir Stok'></th>
					<cfset colspan=colspan+2>
				</cfif>	
				<cfif isdefined('xml_use_other_dept_info') and listlen(xml_use_other_dept_info,'-') eq 2>
					<th><cfoutput>#REAL_STOCK_LOCATION.comment#</cfoutput></th>
				</cfif>
				<cfif isdefined('xml_use_other_dept_info_ss') and listlen(xml_use_other_dept_info_ss,'-') eq 2>
					<th><cfoutput>#REAL_STOCK_LOCATION_SS.comment#</cfoutput></th>
				</cfif>
				<th width="50" nowrap="nowrap"><cf_get_lang dictionary_id='57636.Birim'></th>
				<cfif len(listgetat(session.ep.user_location,1,'-')) and basket_prod_list.PRODUCT_SELECT_TYPE neq 11 and session.ep.our_company_info.workcube_sector is "it">
					<th width="60"><cfif len(department_name)><cfoutput>#department_name#</cfoutput></cfif></th>
					<cfset colspan=colspan+1>
				</cfif>
				<th width="20"><a href="javascript://"><i class="icon-detail"></i></a></th>
			</thead>
			<cfif products.recordcount>
				<cfif len(attributes.price_catid)>
					<cfquery name="get_price_cat" datasource="#dsn3#">
						SELECT 
							NUMBER_OF_INSTALLMENT,
							AVG_DUE_DAY,
							TARGET_DUE_DATE
						FROM
							PRICE_CAT
						WHERE
							PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#">
					</cfquery>
			</cfif>
			<cfif isdefined('attributes.price_catid') and get_price_cat.recordcount> <!--- fiyat listesine gore baskete dusurulecek satırın vadesi bulunuyor --->
				<cfif len(get_price_cat.TARGET_DUE_DATE) and isdefined('attributes.search_process_date') and len(attributes.search_process_date)>
					<cfset row_due_day =datediff('d',createodbcdatetime(dateformat(attributes.search_process_date,dateformat_style)),get_price_cat.TARGET_DUE_DATE)>
				<cfelseif len(get_price_cat.AVG_DUE_DAY)>
					<cfset row_due_day =get_price_cat.AVG_DUE_DAY>
				<cfelse>
					<cfset row_due_day =''>
				</cfif>
			<cfelse>
				<cfset row_due_day =''>
			</cfif>
			<cfoutput query="products"> 
				<cfif ListFind("TL,YTL",money)>
					<cfset attributes.money=session.ep.money>
				<cfelse>
					<cfset attributes.money = money>
				</cfif>
				
				<cfloop query="moneys">
					<cfif moneys.money is attributes.money>
						<cfset row_money = money >
						<cfset row_money_rate1 = moneys.rate1>
						<cfset row_money_rate2 = moneys.rate2>
						<cfset musteri_row_money_rate1 = moneys.rate1>
						<cfset musteri_row_money_rate2 = moneys.rate2>
					</cfif>
					<cfif moneys.money is products.GPA_MONEY>
							<cfset musteri_row_money_rate1 = moneys.rate1>
						<cfset musteri_row_money_rate2 = moneys.rate2>
						</cfif>

				</cfloop>
				<cfset pro_price = products.price>
				<cfset pro_price_kdv = products.price_kdv>
				<cfset row_price_catalog_id =''>
				<cfif attributes.price_catid neq -2>
					
					
					
					<cfscript>
						if(len(GPA_PRICE))
						{ 
							musteri_pro_price = GPA_PRICE; 
							musteri_pro_price_kdv= GPA_PRICE_KDV; 
							
							musteri_row_money=GPA_MONEY;
							if(len(GPA_CATALOG_ID)) row_price_catalog_id =GPA_CATALOG_ID; 
						}
						else
						{ 
							musteri_pro_price = 0;
							musteri_pro_price_kdv = 0;
							musteri_row_money =	default_money.money;
							musteri_row_money_rate1 = 1;
							musteri_row_money_rate2 = 1;
						}
					</cfscript>
					<cfscript>
						if(musteri_row_money is default_money.money)
						{
							musteri_str_other_money = musteri_row_money; 
							musteri_flt_other_money_value = musteri_pro_price;
							musteri_flt_other_money_value_kdv = musteri_pro_price_kdv;	
							musteri_flag_prc_other = 0;
						}
						else
						{
							musteri_flag_prc_other = 1 ;
							musteri_str_other_money = musteri_row_money; 
							musteri_flt_other_money_value = musteri_pro_price;
							musteri_flt_other_money_value_kdv = musteri_pro_price_kdv;	
							musteri_pro_price = musteri_pro_price*(musteri_row_money_rate2/musteri_row_money_rate1);
						}
					</cfscript>
				<cfelse>
					<cfscript>
						musteri_flt_other_money_value = pro_price;
						musteri_flt_other_money_value_kdv = pro_price_kdv;
						musteri_str_other_money = row_money;
						musteri_row_money = row_money;
						musteri_flag_prc_other = 1;
						musteri_pro_price = pro_price*(row_money_rate2/row_money_rate1);
						musteri_str_other_money = default_money.money;
					</cfscript>
				</cfif>
				<cfquery name="GET_PRO" dbtype="query" ><!--- maxrows="1" --->
					SELECT * FROM GET_PROM_ALL WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#STOCK_ID#"> 				
						<cfif attributes.price_catid neq -2>
							<!--- <cfif len(get_p.price_catid)> --->
							<cfif len(gpa_price_catid)>
								AND PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#gpa_price_catid#">
							</cfif>
						<cfelse>
							AND PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#">
						</cfif>
						<cfif attributes.stok_turu eq 2>AND PRODUCT_STOCK > 0</cfif>
					ORDER BY
						PROM_ID DESC
				</cfquery>
				<cfset ek_tutar=0>
				<cfset unit_other=''>
				<cfset other_amount=''>
				<cfif listfind('8,9',basket_prod_list.PRODUCT_SELECT_TYPE,',') and len(WORK_STOCK_ID)>
					<cfset work_product_unit="">
					<cfset other_amount=WORK_STOCK_AMOUNT>
					<!--- iscilik urunu varsa ve ıscilik popup secili ise iscilik urun fiyati satirdaki dövüz cinsinde nolmali bu nedenle urun fiyati kurlarla duzenleniyor kur baskettekinden aliniyor eger olmamasi durumunda money querysinden --->
						<cfquery name="GET_WORK_PROD" datasource="#DSN3#">
							SELECT
								STOCKS.PRODUCT_ID,
								STOCKS.STOCK_ID,
								PRODUCT_UNIT.ADD_UNIT
							FROM
								STOCKS,
								PRICE P,
								PRODUCT_UNIT
							WHERE
								STOCKS.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#work_stock_id#">  AND
								PRODUCT_UNIT.PRODUCT_ID = STOCKS.PRODUCT_ID AND 
								PRODUCT_UNIT.PRODUCT_UNIT_STATUS = 1 AND
								PRODUCT_UNIT.IS_MAIN=1 AND
								P.PRODUCT_ID = STOCKS.PRODUCT_ID AND 
								P.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#"> AND
								(
									P.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#price_date#"> AND
									(P.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#price_date#"> OR P.FINISHDATE IS NULL)
								)
						</cfquery>
					<cfif get_work_prod.RECORDCOUNT>
						<cfset ek_tutar=get_work_prod.PRICE><!--- bu deger, basketteki işçilik birim ücretine(ek_tutar_price) dusuruluyor ve işçilik urun  miktar2 alanına atılıp, toplamı ektutar olarak gosteriliyor. ---><!--- <cfset ek_tutar=get_work_prod.PRICE*WORK_STOCK_AMOUNT> --->
						<cfset work_product_unit=get_work_prod.ADD_UNIT>
					<cfelse>
						<cfquery name="GET_WORK_PROD" datasource="#DSN3#">
							SELECT DISTINCT
								PRICE_STANDART.PRODUCT_ID,
								PRICE_STANDART.PRICE,
							<cfif session.ep.period_year lt 2009>
								CASE WHEN PRICE_STANDART.MONEY ='TL' THEN '<cfoutput>#session.ep.money#</cfoutput>' ELSE PRICE_STANDART.MONEY END AS MONEY,
							<cfelse>
								PRICE_STANDART.MONEY,
							</cfif> 
								PRODUCT_UNIT.ADD_UNIT
							FROM
								STOCKS,
								PRICE_STANDART,
								PRODUCT_UNIT
							WHERE
								PRODUCT_UNIT.PRODUCT_ID = STOCKS.PRODUCT_ID AND 
								PRODUCT_UNIT.PRODUCT_UNIT_STATUS = 1 AND
								PRODUCT_UNIT.IS_MAIN=1 AND
								STOCKS.STOCK_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#work_stock_id#"> AND
								STOCKS.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND
								PURCHASESALES = 1 AND
								PRICESTANDART_STATUS = 1
						</cfquery>
						<cfif get_work_prod.RECORDCOUNT>
							<cfset ek_tutar=get_work_prod.PRICE><!--- <cfset ek_tutar=get_work_prod.PRICE*WORK_STOCK_AMOUNT> --->
							<cfset work_product_unit=get_work_prod.ADD_UNIT>
						</cfif>
					</cfif>
					<cfif ek_tutar gt 0>
						<cfif not isdefined('attributes.#get_work_prod.money#')>
							<cfloop query="moneys">
								<cfif moneys.money is get_work_prod.money>
									<cfset work_prod_row_money_rate1 = moneys.rate1>
									<cfset work_prod_row_money_rate2 = moneys.rate2>
								</cfif>
							</cfloop>
						<cfelse>
							<cfset work_prod_row_money_rate1 = 1>
							<cfset work_prod_row_money_rate2 = evaluate('attributes.#get_work_prod.money#')>
						</cfif>
						<cfset ek_tutar=ek_tutar*(work_prod_row_money_rate2/work_prod_row_money_rate1)>
						<cfif not isdefined('#musteri_row_money#')>
							<cfset ek_tutar=ek_tutar/(musteri_row_money_rate2/musteri_row_money_rate1)>
						<cfelse>
							<cfset ek_tutar=ek_tutar/(evaluate('attributes.#musteri_row_money#')/1)>
						</cfif>
					</cfif>
				</cfif>
				<tbody><cfinclude template="list_product_sale_with_link.cfm"></tbody>
			</cfoutput> 
			<cfelse>
				<tbody>
				<tr> 
				<!---<cfif not isdefined("attributes.is_promotion")>#7+get_deps.recordcount#<cfelse>#7+get_deps.recordcount#</cfif>--->
					<td colspan="<cfoutput>#colspan+1#</cfoutput>"><cfif not isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57701.Filtre Ediniz'><cfelse><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'></cfif> !</td>
				</tr>
				</tbody>
			</cfif>
		</cf_grid_list>
		<cfif attributes.totalrecords gt attributes.maxrows>

			<cfset adres = attributes.fuseaction>
			<cfif isdefined("attributes.stok_turu") >
				<cfset url_str = "#url_str#&stok_turu=#attributes.stok_turu#">
			</cfif>	
			<cfif isdefined('xml_use_project_filter') and xml_use_project_filter eq 1><!---  xmlde proje filtresi secilmisse --->
				<cfif isdefined("attributes.project_id")>
					<cfset adres = "#adres#&project_id=#attributes.project_id#">
				</cfif>
				<cfif isdefined("attributes.project_head")>
					<cfset adres = "#adres#&project_head=#attributes.project_head#">
				</cfif>
			</cfif>
			<cfif isdefined("form.price_catid") and len(form.price_catid)>
				<cfset adres = "#adres#&price_catid=#form.price_catid#">
			<cfelseif isdefined("url.price_catid") and len(url.price_catid)>
				<cfset adres = "#adres#&price_catid=#url.price_catid#">
			<cfelse>
				<cfset adres = "#adres#&price_catid=#attributes.price_catid#">
			</cfif>
			<cfif len(attributes.keyword)>
				<cfset adres = "#adres#&keyword=#attributes.keyword#">
			</cfif>
			<cfif len(attributes.employee) and len(attributes.pos_code)>
				<cfset adres = "#adres#&employee=#attributes.employee#&pos_code=#attributes.pos_code#">
			</cfif>
			<cfif len(attributes.product_cat) and len(attributes.product_catid)>
				<cfset adres = "#adres#&product_cat=#attributes.product_cat#&product_catid=#attributes.product_catid#">
			</cfif>
			<cfif len(attributes.get_company_id) and len(attributes.get_company)>
				<cfset adres = "#adres#&get_company_id=#attributes.get_company_id#&get_company=#attributes.get_company#">
			</cfif>
			<cfif len(attributes.brand_id) and len(attributes.brand_name)>
				<cfset adres = "#adres#&brand_id=#attributes.brand_id#&brand_name=#attributes.brand_name#">
			</cfif>
			<cfif isdefined("attributes.tree_stock_id") and len(attributes.tree_stock_id) and len(attributes.tree_product_name)>
				<cfset adres = "#adres#&tree_stock_id=#attributes.tree_stock_id#&tree_product_name=#attributes.tree_product_name#">
			</cfif>
			<cfif isdefined("attributes.amount_multiplier")>
				<cfset adres = "#adres#&amount_multiplier=#attributes.amount_multiplier#">
			</cfif>
			<cfif isdefined("attributes.serial_number")>
				<cfset adres = "#adres#&serial_number=#attributes.serial_number#">
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
			<cfif isDefined('attributes.short_code_id') and len(attributes.short_code_id)>
				<cfset adres = '#adres#&short_code_id=#attributes.short_code_id#'>
			</cfif>
			<cfif isDefined('attributes.short_code_name') and len(attributes.short_code_name)>
				<cfset adres = '#adres#&short_code_name=#attributes.short_code_name#'>
			</cfif>
			<cf_paging page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#adres##url_str#&form_submitted=1">
		
		</cfif>
	</cf_box>
</div>
<cfoutput>
	<script type="text/javascript">
		function input_control()
		{
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
			return true;
		}
		document.price_cat.list_property_id.value="";
		document.price_cat.list_variation_id.value="";
	
		function open_div_price(no,product_id,stock_id,price,price_money,paymethod_id,price_catid,is_store_module,company_id,consumer_id,search_process_date,spt_process_type,money_type,basket_zero_stock_,usable_stock_amount_,int_basket_id_,promotion_id,prom_discount,prom_cost,prom_limit_value,prom_gift_info)
		{
			gizle_goster(eval('document.all.my_row'+no));
			gizle_goster(eval('document.all.check_price'+no));
			AjaxPageLoad('#request.self#?fuseaction=objects.emptypopup_dsp_calc_prices&paymethod_id='+paymethod_id+'&price_money='+price_money+'&price='+price+'&product_id='+product_id+'&no='+no+'&price_catid='+price_catid+'&is_store_module='+is_store_module+'&company_id='+company_id+'&promotion_id='+promotion_id+'&prom_discount='+prom_discount+'&prom_cost='+prom_cost+'&prom_limit_value='+prom_limit_value+'&prom_gift_info='+prom_gift_info+'&consumer_id='+consumer_id+'&search_process_date='+search_process_date+'&spt_process_type='+spt_process_type+'&money_type='+money_type+'&is_add_basket='+1+'&basket_zero_stock_='+basket_zero_stock_+'&usable_stock_amount_='+usable_stock_amount_+'&int_basket_id_='+int_basket_id_,'check_price'+no);
		}
		function open_div_price_cat(no,product_id,stock_id,price,price_money,paymethod_id,card_paymethod_id,paymethod_vehicle,price_catid_,is_store_module,company_id,consumer_id,search_process_date,spt_process_type,money_type,basket_zero_stock_,usable_stock_amount_,int_basket_id_,promotion_id,prom_discount,prom_cost,prom_limit_value,prom_gift_info)
		{
			gizle_goster(eval('document.all.my_row'+no));
			gizle_goster(eval('document.all.check_price'+no));
			AjaxPageLoad('#request.self#?fuseaction=objects.emptypopup_dsp_calc_prices_cat&paymethod_id='+paymethod_id+'&card_paymethod_id='+card_paymethod_id+'&paymethod_vehicle='+paymethod_vehicle+'&price_money='+price_money+'&price='+price+'&product_id='+product_id+'&no='+no+'&price_catid_='+price_catid_+'&is_store_module='+is_store_module+'&company_id='+company_id+'&promotion_id='+promotion_id+'&prom_discount='+prom_discount+'&prom_cost='+prom_cost+'&prom_limit_value='+prom_limit_value+'&prom_gift_info='+prom_gift_info+'&consumer_id='+consumer_id+'&search_process_date='+search_process_date+'&spt_process_type='+spt_process_type+'&money_type='+money_type+'&is_add_basket='+1+'&basket_zero_stock_='+basket_zero_stock_+'&usable_stock_amount_='+usable_stock_amount_+'&int_basket_id_='+int_basket_id_,'check_price'+no);
		}
		function close_div(no)
		{
			gizle(eval('document.all.my_row'+no));
			gizle(eval('document.all.check_price'+no));
		}
		function open_div_sales_info(no,stock_id,product_id)
		{
			gizle_goster(eval('document.all.sales_info_row'+no));
			gizle_goster(eval('document.all.stock_sales_info'+no));
			AjaxPageLoad('#request.self#?fuseaction=objects.emptypopup_ajax_product_stock_info&sales=1&pid='+product_id+'&sid='+stock_id,'stock_sales_info'+no,1);
		}
	</script>
</cfoutput>
<cfsetting showdebugoutput="yes">