<!--- rapor seçilen tarihler arasındaki dönemleri bularak bu dönemlerde kayıtlı konsinye irsaliyeler üzerinden çalışır.
her dönemdeki konsinye irsaliyelerin bir sonraki dönemde tekrar işlenmiş (faturaya veya iade konsinye irsaliyeye çekilmiş) olma olasılığı dikkate alınır.
OZDEN2008 --->
<cfparam name="attributes.module_id_control" default="13">
<cfinclude template="report_authority_control.cfm">
<cf_get_lang_set module_name="report">
<cf_xml_page_edit fuseact="report.consigment_analyse_report">
<cfparam name="attributes.belge_no" default="">
<cfparam name="attributes.invoice_action" default=''>
<cfparam name="attributes.oby" default="1">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.consumer_name" default="">
<cfparam name="attributes.sales_employee_id" default="">
<cfparam name="attributes.sales_employee_name" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.member_cat_type" default="1">
<cfparam name="attributes.process_type" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.search_product_catid" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.brand_name" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.report_type" default="1">
<cfparam name="attributes.is_month_based_" default="">
<cfparam name="attributes.control_bakiye" default="">
<cfparam name="attributes.paper_period_year" default="">
<cfparam name="attributes.subscription_no" default="">
<cfparam name="attributes.subscription_id" default="">
<cfif attributes.is_excel eq 0><!--- excel alınırken ColdFusion was unable to add the header hatası nedeniyle bu kontrol eklendi --->
	<cfflush interval="1000">
</cfif>
<cfquery name="get_department" datasource="#dsn#">
    SELECT
        DEPARTMENT_ID,
        DEPARTMENT_HEAD
    FROM
        BRANCH B,
        DEPARTMENT D 
    WHERE
        B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
        B.BRANCH_ID = D.BRANCH_ID AND
        D.IS_STORE <> 2 AND
        D.DEPARTMENT_STATUS = 1 AND
        B.BRANCH_ID IN(SELECT BRANCH_ID FROM  EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
</cfquery>
<cfquery name="get_all_location" datasource="#DSN#">
	SELECT DEPARTMENT_ID,LOCATION_ID,COMMENT FROM STOCKS_LOCATION
</cfquery>
<cfquery name="get_company_cat" datasource="#DSN#">
	SELECT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT ORDER BY COMPANYCAT
</cfquery>
<cfquery name="get_consumer_cat" datasource="#DSN#">
	SELECT CONSCAT_ID,CONSCAT FROM CONSUMER_CAT ORDER BY CONSCAT
</cfquery>
<cfif isdefined("attributes.date2") and isdate(attributes.date2)>
	<cf_date tarih="attributes.date2">
<cfelse>
	<cfset attributes.date2 = createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#')>
</cfif>
<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
	<cf_date tarih="attributes.date1">
<cfelse>
	<cfset attributes.date1 = date_add('ww',-1,attributes.date2)>
</cfif>

<cfset page_totals = arraynew(2)>
<cfquery name="GET_PERIODS_" datasource="#dsn#">
	SELECT PERIOD_ID,PERIOD_YEAR,OUR_COMPANY_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> ORDER BY PERIOD_YEAR DESC
</cfquery>
<cfif isdefined("attributes.is_form_submitted")>
	<cfset new_period_id_list_ = valuelist(GET_PERIODS_.PERIOD_ID)>
	<cfset list_period_years=valuelist(GET_PERIODS_.PERIOD_YEAR)>
	<cfquery name="get_all_periods" dbtype="query">
		SELECT 
			* 
		FROM 
			GET_PERIODS_ 
		WHERE
			<cfif not isdefined("attributes.is_pre_ships")>
				PERIOD_YEAR >= <cfqueryparam cfsqltype="cf_sql_integer" value="#dateformat(attributes.date1,'yyyy')#"> 
				AND PERIOD_YEAR <= <cfqueryparam cfsqltype="cf_sql_integer" value="#dateformat(attributes.date2,'yyyy')#">
			<cfelse>
				PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_year#">
			</cfif>
		ORDER BY 
			PERIOD_YEAR
	</cfquery>	
	<cfif not get_all_periods.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='57859.Dönem Kaydı Bulunmamaktadır'>!");
			history.back();	
		</script>
		<cfabort>
	</cfif>
	<cfquery name="GET_ALL_SHIP" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
		SELECT
			*,
			(
				SELECT TOP 1
						(PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM)
					FROM 
						#dsn3_alias#.PRODUCT_COST
					WHERE 
						START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
						AND ACTION_PERIOD_ID IN (#new_period_id_list_#)
						AND PRODUCT_ID = T1.PRODUCT_ID
					ORDER BY 
						PRODUCT_ID, 
						RECORD_DATE DESC, 
						START_DATE DESC,
						PRODUCT_COST_ID DESC
			) ALL_PRODUCT_COST
		FROM
		(
		<cfloop query="get_all_periods">
			SELECT
				1 AS TYPE,
			<cfif attributes.report_type eq 2>
				#get_all_periods.PERIOD_ID# AS SHIP_PERIOD,
				SHIP.SHIP_ID,
				SHIP.SHIP_NUMBER AS BELGE_NO,
				SHIP.SHIP_DATE AS ISLEM_TARIHI,
				SHIP.COMPANY_ID,
				SHIP.CONSUMER_ID,
				SHIP.PARTNER_ID,
				SHIP.SALE_EMP,
				DELIVER_EMP AS DELIVER_EMP,
				DEPARTMENT_IN AS DEPARTMENT_ID,
				SHIP.DELIVER_STORE_ID AS DEPARTMENT_ID_2,
				SPC.PROCESS_CAT BELGE_TURU,
				SHIP.PROJECT_ID,
			<cfelseif attributes.report_type eq 1>
				PC.PRODUCT_CAT,
				S.BARCOD,
				S.BRAND_ID,
			</cfif>
				SHIP.SHIP_TYPE,
				S.STOCK_CODE,
				S.PRODUCT_ID,
				S.STOCK_ID,
				S.PRODUCT_NAME,
				S.PROPERTY,
				ABS(SUM(GSRC.STOCK_IN-GSRC.STOCK_OUT)) AS PAPER_AMOUNT,
				0 SHIP_AMOUNT,
				0 INV_AMOUNT,
				0 SHIP_COST,
				0 INV_COST,
				'' INVOICE_NUMBER_LIST,
				'' SHIP_NUMBER_LIST,
				SUM(GSRC.MALIYET*ABS(GSRC.STOCK_IN-GSRC.STOCK_OUT)) AS TOTAL_COST
			FROM 
				#dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.SHIP SHIP,
				#dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.GET_STOCKS_ROW_COST GSRC,
				#dsn3_alias#.STOCKS S,
				#dsn3_alias#.SETUP_PROCESS_CAT SPC
				<cfif attributes.report_type eq 1>
				,#dsn3_alias#.PRODUCT_CAT PC
				</cfif>
			WHERE 
				GSRC.UPD_ID = SHIP.SHIP_ID
				AND GSRC.PROCESS_TYPE = SHIP.SHIP_TYPE
				AND SHIP.IS_SHIP_IPTAL = 0
				AND GSRC.STOCK_ID = S.STOCK_ID
				AND SHIP.IS_WITH_SHIP = 0
				<cfif attributes.report_type eq 1>
					AND	PC.PRODUCT_CATID = S.PRODUCT_CATID
				</cfif>
				AND SHIP.SHIP_TYPE = SPC.PROCESS_TYPE
				AND SHIP.PROCESS_CAT = 	SPC.PROCESS_CAT_ID
				<cfif len(attributes.process_type)>
					AND SHIP.PROCESS_CAT IN (#attributes.process_type#)
				</cfif>
				AND SHIP.SHIP_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
				<cfif attributes.report_type eq 2 and len(attributes.paper_period_year)><!--- belge bazında raporlama yapılıyorsa ve irsaliye donemi secilmisse sadece o yıla ait belgeler alınır.. başlangıc bitiş tarihleri arasındaki işlemleri kontrol edilir --->
					AND YEAR(SHIP.SHIP_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.paper_period_year#">
				</cfif>
				<cfif len(attributes.department_id)>
					AND(
					<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
						(SHIP.DEPARTMENT_IN = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND SHIP.LOCATION_IN = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
						OR (SHIP.DELIVER_STORE_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND SHIP.LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
						<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
					</cfloop>  
						)
				</cfif>				
				<cfif len(attributes.belge_no)>
					AND (SHIP.SHIP_NUMBER LIKE '<cfif len(attributes.belge_no) gt 3>%</cfif>#attributes.belge_no#%')
				</cfif>
				<cfif len(attributes.consumer_id) and attributes.consumer_id gt 0 and Len(attributes.consumer_name)>AND SHIP.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"></cfif>
				<cfif len(attributes.company_id) and attributes.company_id gt 0 and Len(attributes.company)>AND SHIP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"></cfif>
				<cfif len(attributes.sales_employee_id) and Len(attributes.sales_employee_name)>AND SHIP.SALE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_employee_id#"></cfif>
				<cfif len(attributes.stock_id) and len(attributes.product_name)>AND S.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#"></cfif>
				<cfif isdefined("attributes.member_cat_type") and listlen(attributes.member_cat_type,'-') eq 2 and listfirst(attributes.member_cat_type,'-') is '1'>
					AND SHIP.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANYCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.member_cat_type,'-')#">)
				</cfif>
				<cfif isdefined("attributes.member_cat_type") and listlen(attributes.member_cat_type,'-') eq 2 and listfirst(attributes.member_cat_type,'-') is '2'>
					AND SHIP.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER WHERE CONSUMER_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.member_cat_type,'-')#">)
				</cfif>
				<cfif len(attributes.project_id) and len(attributes.project_head)>
					AND SHIP.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
				</cfif>
				<cfif len(trim(attributes.product_cat)) and len(attributes.search_product_catid)>
					AND S.PRODUCT_CATID IN(SELECT PRODUCT_CATID FROM #dsn3_alias#.PRODUCT_CAT PCC WHERE PCC.HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.search_product_catid#%">)
				</cfif>
				<cfif attributes.report_type eq 2 and not len(attributes.process_type) and not isdefined('attributes.not_ship_related')>
					AND SHIP.SHIP_TYPE =  72
				</cfif>
				<cfif len(attributes.brand_id) and len(attributes.brand_name)>
					AND S.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#">
				</cfif>
				<cfif isdefined('attributes.not_ship_related') and attributes.not_ship_related eq 1>
					AND SHIP_TYPE IN (75)
					AND SHIP_ID NOT IN (SELECT TO_SHIP_ID FROM #dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.SHIP_TO_SHIP WHERE TO_SHIP_TYPE =75)
				</cfif>
				<cfif attributes.invoice_action eq 1>
					AND SHIP.SHIP_ID IN (
										SELECT SHIP_ID FROM #dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.INVOICE_SHIPS WHERE SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_all_periods.PERIOD_ID#">
										<cfif isdefined('list_period_years') and listfind(list_period_years,(get_all_periods.PERIOD_YEAR+1))><!--- irsaliye bir sonraki donemde faturaya cekilmis mi kontrol ediliyor --->
										UNION ALL SELECT SHIP_ID FROM #dsn#_#get_all_periods.PERIOD_YEAR+1#_#get_all_periods.OUR_COMPANY_ID#.INVOICE_SHIPS INVOICE_SHIPS WHERE SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_all_periods.PERIOD_ID#">
										</cfif>
						)
				<cfelseif attributes.invoice_action eq 2>
					AND SHIP.SHIP_ID NOT IN (
										SELECT SHIP_ID FROM #dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.INVOICE_SHIPS WHERE SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_all_periods.PERIOD_ID#">
										<cfif isdefined('list_period_years') and listfind(list_period_years,(get_all_periods.PERIOD_YEAR+1))>
										UNION ALL SELECT SHIP_ID FROM #dsn#_#get_all_periods.PERIOD_YEAR+1#_#get_all_periods.OUR_COMPANY_ID#.INVOICE_SHIPS INVOICE_SHIPS WHERE SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_all_periods.PERIOD_ID#">
										</cfif>
					)
				</cfif>
                <cfif len(attributes.subscription_id) and len(attributes.subscription_no)>
                	AND SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
                </cfif>
			GROUP BY
			<cfif attributes.report_type eq 2>
				SHIP.SHIP_ID,
				SHIP.SHIP_NUMBER,
				SHIP.SHIP_DATE,
				SHIP.COMPANY_ID,
				SHIP.CONSUMER_ID,
				SHIP.PARTNER_ID,
				SHIP.SALE_EMP,
				DELIVER_EMP,
				DELIVER_EMP,
				DEPARTMENT_IN,
				SHIP.DELIVER_STORE_ID,
				SPC.PROCESS_CAT,
				SHIP.PROJECT_ID,
			<cfelseif attributes.report_type eq 1>
				PC.PRODUCT_CAT,					
				S.BARCOD,
				S.BRAND_ID,
			</cfif>
				SHIP.SHIP_TYPE,
				S.STOCK_CODE,
				S.PRODUCT_ID,
				S.STOCK_ID,
				S.PRODUCT_NAME,
				S.PROPERTY
		<cfif currentrow neq get_all_periods.recordcount> UNION ALL </cfif>					
		</cfloop>
		<cfif isdefined("attributes.is_pre_ships")>
		UNION ALL
		SELECT
			0 AS TYPE,
			<cfif attributes.report_type eq 2>
				PERIOD_ID AS SHIP_PERIOD,
				SHIP_ID,
				SHIP_NUMBER AS BELGE_NO,
				SHIP_DATE AS ISLEM_TARIHI,
				PCS.COMPANY_ID,
				PCS.CONSUMER_ID,
				PCS.PARTNER_ID,
				'' SALE_EMP,
				'' DELIVER_EMP,
				'' DEPARTMENT_ID,
				DEPARTMENT_ID AS DEPARTMENT_ID_2,
				SPC.PROCESS_CAT BELGE_TURU,
				PROJECT_ID,
			<cfelseif attributes.report_type eq 1>
				PC.PRODUCT_CAT,
				S.BARCOD,
				S.BRAND_ID,
			</cfif>
				SHIP_TYPE,
				S.STOCK_CODE,
				S.PRODUCT_ID,
				S.STOCK_ID,
				S.PRODUCT_NAME,
				S.PROPERTY,
				AMOUNT AS PAPER_AMOUNT,
				SHIP_AMOUNT,
				INV_AMOUNT,
				SHIP_COST,
				INV_COST,
				INVOICE_NUMBER_LIST,
				SHIP_NUMBER_LIST,
				SUM(PCS.COST_VALUE*AMOUNT) AS TOTAL_COST
			FROM 
				PRE_CONSIGNMENT_SHIP PCS,
				#dsn3_alias#.STOCKS S,
				#dsn3_alias#.SETUP_PROCESS_CAT SPC
				<cfif attributes.report_type eq 1>
					,#dsn3_alias#.PRODUCT_CAT PC
				</cfif>
			WHERE 
				PCS.STOCK_ID = S.STOCK_ID
				<cfif attributes.report_type eq 1>
					AND	PC.PRODUCT_CATID = S.PRODUCT_CATID
				</cfif>
				AND PCS.SHIP_TYPE = SPC.PROCESS_TYPE
				AND PCS.PROCESS_CAT = 	SPC.PROCESS_CAT_ID
				<cfif len(attributes.process_type)>
					AND PCS.PROCESS_CAT IN (#attributes.process_type#)
				</cfif>
				AND PCS.SHIP_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
				<cfif attributes.report_type eq 2 and len(attributes.paper_period_year)> <!--- belge bazında raporlama yapılıyorsa ve irsaliye donemi secilmisse sadece o yıla ait belgeler alınır.. başlangıc bitiş tarihleri arasındaki işlemleri kontrol edilir --->
					AND YEAR(PCS.SHIP_DATE) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.paper_period_year#">
				</cfif>
				<cfif len(attributes.department_id)>
					AND(
					<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
						(PCS.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND PCS.LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
						<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
					</cfloop>  
						)
				</cfif>				
				<cfif len(attributes.belge_no)>
				AND (
					(PCS.SHIP_NUMBER LIKE '<cfif len(attributes.belge_no) gt 3>%</cfif>#attributes.belge_no#%')
					)
				</cfif>
				<cfif len(attributes.consumer_id) and attributes.consumer_id gt 0 and Len(attributes.consumer_name)>AND PCS.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"></cfif>
				<cfif len(attributes.company_id) and attributes.company_id gt 0 and Len(attributes.company)>AND PCS.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"></cfif>
				<cfif len(attributes.stock_id) and len(attributes.product_name)>AND S.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#"></cfif>
				<cfif isdefined("attributes.member_cat_type") and listlen(attributes.member_cat_type,'-') eq 2 and listfirst(attributes.member_cat_type,'-') is '1'>
					AND PCS.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANYCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.member_cat_type,'-')#">)
				</cfif>
				<cfif isdefined("attributes.member_cat_type") and listlen(attributes.member_cat_type,'-') eq 2 and listfirst(attributes.member_cat_type,'-') is '2'>
					AND PCS.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER WHERE CONSUMER_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.member_cat_type,'-')#">)
				</cfif>
				<cfif len(attributes.project_id) and len(attributes.project_head)>
					AND PCS.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
				</cfif>
				<cfif len(trim(attributes.product_cat)) and len(attributes.search_product_catid)>
					AND S.PRODUCT_CATID IN(SELECT PRODUCT_CATID FROM #dsn3_alias#.PRODUCT_CAT PCC WHERE PCC.HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.search_product_catid#%">)
				</cfif>
				<cfif attributes.report_type eq 2 and not len(attributes.process_type) and not isdefined('attributes.not_ship_related')>
					AND PCS.SHIP_TYPE =  72
				</cfif>
				<cfif len(attributes.brand_id) and len(attributes.brand_name)>
					AND S.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#">
				</cfif>
				<cfif isdefined('attributes.not_ship_related') and attributes.not_ship_related eq 1>
					AND SHIP_TYPE IN (75)
					AND SHIP_ID NOT IN (SELECT TO_SHIP_ID FROM #dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.SHIP_TO_SHIP WHERE TO_SHIP_TYPE =75)
				</cfif>
				<cfif attributes.invoice_action eq 1>
					AND PCS.SHIP_ID IN (
										SELECT SHIP_ID FROM #dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.INVOICE_SHIPS WHERE SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_all_periods.PERIOD_ID#">
										<cfif isdefined('list_period_years') and listfind(list_period_years,(get_all_periods.PERIOD_YEAR+1))>
											UNION ALL SELECT SHIP_ID FROM #dsn#_#get_all_periods.PERIOD_YEAR+1#_#get_all_periods.OUR_COMPANY_ID#.INVOICE_SHIPS INVOICE_SHIPS WHERE SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_all_periods.PERIOD_ID#">
										</cfif>
										)
				<cfelseif attributes.invoice_action eq 2>
					AND PCS.SHIP_ID NOT IN (
										SELECT SHIP_ID FROM #dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.INVOICE_SHIPS WHERE SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_all_periods.PERIOD_ID#">
										<cfif isdefined('list_period_years') and listfind(list_period_years,(get_all_periods.PERIOD_YEAR+1))>
											UNION ALL SELECT SHIP_ID FROM #dsn#_#get_all_periods.PERIOD_YEAR+1#_#get_all_periods.OUR_COMPANY_ID#.INVOICE_SHIPS INVOICE_SHIPS WHERE SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_all_periods.PERIOD_ID#">
										</cfif>
										)
				</cfif>
                <cfif len(attributes.subscription_id) and len(attributes.subscription_no)>
                	AND SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
                </cfif>
			GROUP BY
			<cfif attributes.report_type eq 2>
				PCS.PERIOD_ID,
				PCS.SHIP_ID,
				PCS.SHIP_NUMBER,
				PCS.SHIP_DATE,
				PCS.COMPANY_ID,
				PCS.CONSUMER_ID,
				PCS.PARTNER_ID,
				PCS.DEPARTMENT_ID,
				PCS.LOCATION_ID,
				SPC.PROCESS_CAT,
				PCS.PROJECT_ID,
			<cfelseif attributes.report_type eq 1>
				PC.PRODUCT_CAT,					
				S.BARCOD,
				S.BRAND_ID,
			</cfif>
				PCS.SHIP_TYPE,
				S.STOCK_CODE,
				S.PRODUCT_ID,
				S.STOCK_ID,
				S.PRODUCT_NAME,
				S.PROPERTY,
				AMOUNT,
				SHIP_AMOUNT,
				INV_AMOUNT,
				SHIP_COST,
				INV_COST,
				INVOICE_NUMBER_LIST,
				SHIP_NUMBER_LIST	
		</cfif>
		)T1
		<cfif attributes.report_type eq 2>
			<cfif not len(attributes.report_type)>
				<cfif attributes.oby eq 2>
					ORDER BY ISLEM_TARIHI
				<cfelseif attributes.oby eq 3>
					ORDER BY BELGE_NO
				<cfelseif attributes.oby eq 4>
					ORDER BY BELGE_NO DESC
				<cfelseif attributes.oby eq 5>
					ORDER BY PRODUCT_NAME ASC
				<cfelse>
					ORDER BY ISLEM_TARIHI DESC
				</cfif>
			</cfif>	
		</cfif>
	</cfquery>
	<cfif report_type eq 1 and GET_ALL_SHIP.recordcount> <!--- stok bazında raporlama --->
		<cfquery name="GET_PROD_RESULTS" dbtype="query">
			SELECT
				PRODUCT_CAT,					
				BARCOD,
				STOCK_CODE,
				PRODUCT_ID,
				STOCK_ID,
				PRODUCT_NAME,
				PROPERTY,
				BRAND_ID,
				SUM(PAPER_AMOUNT) AS PAPER_AMOUNT,
				ALL_PRODUCT_COST
				<cfif isdefined("attributes.is_pre_ships")>
					,SUM(SHIP_AMOUNT) AS SHIP_AMOUNT
					,SUM(INV_AMOUNT) AS INV_AMOUNT
					,SUM(SHIP_COST) AS SHIP_COST
					,SUM(INV_COST) AS INV_COST
				</cfif>
			FROM
				GET_ALL_SHIP
			GROUP BY
				PRODUCT_CAT,					
				BARCOD,
				STOCK_CODE,
				PRODUCT_ID,
				STOCK_ID,
				PRODUCT_NAME,
				PROPERTY,
				BRAND_ID,
				ALL_PRODUCT_COST
		</cfquery>
		<cfquery name="GET_PROD_IN" dbtype="query">
			SELECT
				PRODUCT_ID,
				STOCK_ID,
				SUM(PAPER_AMOUNT) AS AMOUNT,
				SUM(TOTAL_COST) AS TOTAL_COST
			FROM
				GET_ALL_SHIP
			WHERE
				SHIP_TYPE IN (75,77)
			GROUP BY
				PRODUCT_ID,
				STOCK_ID
		</cfquery>
		<cfquery name="GET_PROD_OUT" dbtype="query">
			SELECT
				PRODUCT_ID,
				STOCK_ID,
				SUM(PAPER_AMOUNT) AS AMOUNT,
				SUM(TOTAL_COST) AS TOTAL_COST
			FROM
				GET_ALL_SHIP
			WHERE
				SHIP_TYPE IN (72,79)
			GROUP BY
				PRODUCT_ID,
				STOCK_ID
		</cfquery>
	<cfelse>
		<cfset GET_PROD_RESULTS.recordcount = 0>
		<cfset GET_PROD_IN.recordcount = 0>
		<cfset GET_PROD_OUT.recordcount = 0>
	</cfif>
<cfelse>
	<cfset GET_ALL_SHIP.recordcount = 0>
	<cfset GET_PROD_RESULTS.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1>
<cfif attributes.report_type eq 1><!--- stok bazında --->
	<cfparam name="attributes.totalrecords" default="#GET_PROD_RESULTS.recordcount#">
<cfelse><!--- belge bazında --->
	<cfparam name="attributes.totalrecords" default="#GET_ALL_SHIP.recordcount#">
</cfif>
<cfform name="frm_search" action="#request.self#?fuseaction=#fusebox.circuit#.consigment_analyse_report" method="post">
<cfsavecontent variable="title"><cf_get_lang dictionary_id='58453.Konsinye Raporu'></cfsavecontent>
<cf_report_list_search title="#title#">
	<cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-md-12">
									<div class="form-group">
										<label class="col col-12"><cf_get_lang dictionary_id='57800.İşlem Tipi'></label>
										<div class="col col-12 col-xs-12">
												<cfquery name="get_process_cat" datasource="#dsn3#">
													SELECT PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (72,75,77,79) ORDER BY PROCESS_TYPE
												</cfquery>
												<select name="process_type" id="process_type"  multiple style="height:115px;">
													<cfoutput query="get_process_cat">
														<option value="#PROCESS_CAT_ID#" <cfif listfind(attributes.process_type,PROCESS_CAT_ID,',')>selected</cfif>>#PROCESS_CAT#</option>
													</cfoutput>
												</select>	
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12"><cf_get_lang dictionary_id='58763.Depo'></label>
										<div class="col col-12 col-xs-12">
											<select name="department_id" id="department_id" multiple style="height:115px;">
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
								<div class="col col-12 col-md-12">
									<div class="form-group">
										<label class="col col-12"><cf_get_lang dictionary_id ='57519.Cari Hesap'></label>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="company_id" id="company_id" value="<cfif Len(attributes.company_id) and len(attributes.company)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
												<input type="text" name="company" id="company" style="width:150px;" value="<cfif Len(attributes.company_id) and len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','company_id','','3','150');">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_name=frm_search.consumer_name&field_consumer=frm_search.consumer_id&field_comp_name=frm_search.company&field_comp_id=frm_search.company_id&select_list=2,3&keyword='+encodeURIComponent(document.frm_search.company.value),'list');"></span>	
											</div>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12"><cf_get_lang dictionary_id ='57657.Ürün'></label>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="stock_id" id="stock_id" <cfif len("attributes.stock_id") and len(attributes.product_name)>value="<cfoutput>#attributes.stock_id#</cfoutput>"</cfif>>
												<input type="text" name="product_name" id="product_name" style="width:150px;" value="<cfif len(attributes.stock_id) and len(attributes.product_name)><cfoutput>#attributes.product_name#</cfoutput></cfif>" passthrough="readonly=yes" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID','product_id','form','3','200');">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=frm_search.stock_id&field_name=frm_search.product_name&keyword='+encodeURIComponent(document.frm_search.product_name.value),'list');"></span>		
											</div>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="search_product_catid" id="search_product_catid" value="<cfif len(attributes.product_cat)><cfoutput>#attributes.search_product_catid#</cfoutput></cfif>">
												<input type="text" name="product_cat" id="product_cat" style="width:150px;"  value="<cfif len(attributes.product_cat)><cfoutput>#attributes.product_cat#</cfoutput></cfif>" onkeyup="get_product_cat();" onFocus="AutoComplete_Create('product_cat','HIERARCHY,PRODUCT_CAT','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID','productcat_id','form','3','200');">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_code=frm_search.search_product_catid&field_name=frm_search.product_cat</cfoutput>');"></span>
											</div>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12"><cf_get_lang dictionary_id='58832.Abone'></label>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="subscription_id" id="subscription_id" value="<cfif Len(attributes.subscription_no)><cfoutput>#attributes.subscription_id#</cfoutput></cfif>">
												<input type="text" name="subscription_no" id="subscription_no" value="<cfoutput>#attributes.subscription_no#</cfoutput>" style="width:155px;" onfocus="AutoComplete_Create('subscription_no','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO','get_subscription','2','SUBSCRIPTION_ID','subscription_id','','3','200');" autocomplete="off">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_subscription&field_id=frm_search.subscription_id&field_no=frm_search.subscription_no'</cfoutput>,'list','popup_list_subscription');"></span>
											</div>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12"><cf_get_lang dictionary_id='58847.Marka'></label>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="brand_id" id="brand_id"  value="<cfif len(attributes.brand_name)><cfoutput>#attributes.brand_id#</cfoutput></cfif>">
												<input type="text" name="brand_name" id="brand_name" style="width:150px;" value="<cfif len(attributes.brand_name)><cfoutput>#attributes.brand_name#</cfoutput></cfif>" maxlength="255" onFocus="AutoComplete_Create('brand_name','BRAND_NAME','BRAND_NAME','get_brand','','BRAND_ID','brand_id','form','3','100');">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_brands&brand_id=frm_search.brand_id&brand_name=frm_search.brand_name&keyword='+encodeURIComponent(document.frm_search.brand_name.value),'small');"></span>	
											</div>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12"><cf_get_lang dictionary_id ='40294.Satış Çalışanı'></label>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="sales_employee_id" id="sales_employee_id"  value="<cfif Len(attributes.sales_employee_name)><cfoutput>#attributes.sales_employee_id#</cfoutput></cfif>">
												<input type="text" name="sales_employee_name" id="sales_employee_name" value="<cfif len(attributes.sales_employee_name)><cfoutput>#attributes.sales_employee_name#</cfoutput></cfif>" maxlength="255" onfocus="AutoComplete_Create('sales_employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','125');">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=frm_search.sales_employee_name&field_emp_id=frm_search.sales_employee_id&select_list=1','list');"></span>	
											</div>
										</div>
									</div>
									
								</div>
							</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-md-12">
									<div class="form-group">
										<label class="col col-12"><cf_get_lang dictionary_id ='57416.Proje'></label>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="project_id" id="project_id" value="<cfif len(attributes.project_head)><cfoutput>#attributes.project_id#</cfoutput></cfif>"> 
												<input type="text" name="project_head" id="project_head" value="<cfif len(attributes.project_head)><cfoutput>#attributes.project_head#</cfoutput></cfif>" style="width:150px;" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','list_works','3','250');">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=frm_search.project_id&project_head=frm_search.project_head');"> </span>	
											</div>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12"><cf_get_lang dictionary_id='58960.Rapor Tipi'></label>
										<div class="col col-12 col-xs-12">
											<select name="report_type" id="report_type">
												<option value="1" <cfif isDefined('attributes.report_type') and attributes.report_type eq 1>selected</cfif>><cf_get_lang dictionary_id='39054.Stok Bazında'></option>
												<option value="2" <cfif isDefined('attributes.report_type') and attributes.report_type eq 2>selected</cfif>><cf_get_lang dictionary_id='57660.Belge Bazında'></option>
											</select>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12"><cf_get_lang dictionary_id='39345.Dosya Tipi'></label>
										<div class="col col-12 col-xs-12">                                           
											<select name="is_excel_" id="is_excel_" style="width:154px;" >
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<option value="2" <cfif attributes.is_excel eq 2>selected</cfif>>CSV <cf_get_lang dictionary_id='58600.Dosya Oluştur'></option>
											</select>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12"><cf_get_lang dictionary_id ='45442.Fatura Hareketleri'></label>
										<div class="col col-12 col-xs-12">
											<select name="invoice_action" id="invoice_action">
												<option selected value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
												<option value="1" <cfif isDefined('attributes.invoice_action') and attributes.invoice_action eq 1>selected</cfif>><cf_get_lang dictionary_id ='39216.Faturalanmış'></option>
												<option value="2" <cfif isDefined('attributes.invoice_action') and attributes.invoice_action eq 2>selected</cfif>><cf_get_lang dictionary_id ='39217.Faturalanmamış'></option>
											</select>	
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12"><cf_get_lang dictionary_id ='57773.İrsaliye'><cf_get_lang dictionary_id ='39363.Dönemi'></label>
										<div class="col col-12 col-xs-12">
											<select name="paper_period_year" id="paper_period_year">
												<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
												<cfoutput query="GET_PERIODS_">
													<option value="#GET_PERIODS_.PERIOD_YEAR#" <cfif attributes.paper_period_year eq GET_PERIODS_.PERIOD_YEAR>selected</cfif>>#GET_PERIODS_.PERIOD_YEAR#</option>
												</cfoutput>
											</select>		
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12"><cf_get_lang dictionary_id='57756.Durum'></label>
										<div class="col col-12 col-xs-12">
											<select name="control_bakiye" id="control_bakiye">
												<option value="" <cfif len(attributes.control_bakiye)>selected</cfif>><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<option value="1"<cfif len(attributes.control_bakiye) and attributes.control_bakiye eq 1>selected</cfif>><cf_get_lang dictionary_id ='40600.Kapanmamış Belgeler'></option>
												<option value="2"<cfif len(attributes.control_bakiye) and attributes.control_bakiye eq 2>selected</cfif>><cf_get_lang dictionary_id ='40601.Önceki Dönemden Devredenler'></option>
											</select>	
										</div>
									</div>
									
								</div>
							</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-md-12">
									<div class="form-group">
										<label class="col col-12"><cf_get_lang dictionary_id='40267.Sıralama Tipi'></label>
										<div class="col col-12 col-xs-12">
											<select name="oby" id="oby" style="width:170px;">
												<option value="1" <cfif attributes.oby eq 1>selected</cfif>><cf_get_lang dictionary_id='57926.Azalan Tarih'></option>
												<option value="2" <cfif attributes.oby eq 2>selected</cfif>><cf_get_lang dictionary_id='57925.Artan Tarih'></option>
												<option value="3" <cfif attributes.oby eq 3>selected</cfif>><cf_get_lang dictionary_id='29459.Artan No'></option>
												<option value="4" <cfif attributes.oby eq 4>selected</cfif>><cf_get_lang dictionary_id='29458.Azalan No'></option>
												<option value="5" <cfif attributes.oby eq 5>selected</cfif>><cf_get_lang dictionary_id='58221.Ürün Adı'></option>
											</select>	
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12"><cf_get_lang dictionary_id='57880.Belge No'></label>
										<div class="col col-12 col-xs-12">
											<cfinput type="text" name="belge_no" value="#attributes.belge_no#">		
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12"><cf_get_lang dictionary_id ='57578.Yetkili'></label>
										<div class="col col-12 col-xs-12">
											<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif Len(attributes.consumer_id) and len(attributes.consumer_name)><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
											<input type="text" name="consumer_name" id="consumer_name" value="<cfif Len(attributes.consumer_id) and len(attributes.consumer_name)><cfoutput>#attributes.consumer_name#</cfoutput></cfif>">		
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12"><cf_get_lang dictionary_id='58690.Tarihi Aralığı'>*</label>
										<div class="col col-6">
											<div class="input-group">
												<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
												<cfinput type="text" name="date1" value="#dateformat(attributes.date1,dateformat_style)#" style="width:65px;" validate="#validate_style#" message="#message#" maxlength="10" required="yes">
												<span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>
											</div>
										</div>
										<div class="col col-6">
											<div class="input-group">		
												<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
												<cfinput type="text" name="date2" value="#dateformat(attributes.date2,dateformat_style)#" style="width:65px;" validate="#validate_style#" message="#message#" maxlength="10" required="yes">
												<span class="input-group-addon"><cf_wrk_date_image date_field="date2"></span>
											</div>
										</div>
									</div>	
									<div class="form-group">
										<div class="col col-12">
										<label><cf_get_lang dictionary_id='38945.Ay Bazında Fatura Bilgisi'><input type="checkbox" name="is_month_based_" id="is_month_based_" value="1" <cfif isdefined('attributes.is_month_based_') and attributes.is_month_based_ eq 1>checked</cfif>></label>
										</div>
										<div class="col col-12">
											<label><cf_get_lang dictionary_id="39510.Devir İşlemlerinden Getir"><input type="checkbox" name="is_pre_ships" id="is_pre_ships" value="1" <cfif isdefined("attributes.is_pre_ships")>checked</cfif>></label>
										</div>
										<div class="col col-12">
											<label><cf_get_lang dictionary_id ='40265.Çıkış İrs Olmayan İadeler'><input type="checkbox" name="not_ship_related" id="not_ship_related" value="1" <cfif isdefined('attributes.not_ship_related')>checked</cfif>></label>
										</div>
										<div class="col col-12">
											<cfif isdefined('xml_report_to_table') and xml_report_to_table eq 1>
												<label><cf_get_lang dictionary_id ='40599.Tabloya Aktar'><input type="checkbox" value="1" name="export_to_table" id="export_to_table"<cfif isdefined('attributes.export_to_table') and attributes.export_to_table eq 1>checked</cfif>></label>
											</cfif>
										</div>
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
                			<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
            				<cfelse>
                			<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;" onKeyUp="isNumber(this)">
							</cfif>
							<input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
							<cf_wrk_report_search_button search_function='kontrol()' button_type='1' is_excel='1'>
						</div>
					</div>
				</div>
			</div>
	</cf_report_list_search_area>
</cf_report_list_search>
</cfform>
<cfif isdefined("attributes.is_excel") and attributes.is_excel eq 1><!--- excel olusturulacaksa --->
	<cfset filename="consigment_content_report#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-16">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="content-type" content="text/plain; charset=utf-16">
	<cfset type_ = 1>
<cfelseif isdefined("attributes.is_excel") and attributes.is_excel eq 2>
	<cfset type_ = 2>
<cfelse>
	<cfset type_ = 0>
</cfif>
<cfif isdefined("attributes.is_form_submitted")>
<!-- sil -->
<cfif isdefined("attributes.is_excel") and attributes.is_excel neq 1>
<table width="99%" class="color-border" cellpadding="2" cellspacing="1">
    <tr class="color-row">
        <td class="txtbold" valign="top" width="40"><cf_get_lang dictionary_id='58763.Depo'></td>
        <td valign="top" width="400">
			<cfif len(attributes.department_id)>
                <cfset deger_ = 0>
                <table>
                	<tr>
                    <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                        <cfset deger_ = deger_ + 1>
                        <cfquery name="GET_LOCATION" dbtype="query">
                            SELECT COMMENT FROM GET_ALL_LOCATION WHERE DEPARTMENT_ID = #listfirst(dept_i,'-')# AND LOCATION_ID = #listlast(dept_i,'-')#
                        </cfquery>
                        <cfoutput>
                            <td width="180">#get_location.comment#</td><cfif (deger_ mod 2) eq 0></tr></cfif>
                        </cfoutput>
                    </cfloop>
                </table>
            </cfif>
        </td>
        <cfoutput>
        <td valign="top" width="400">
        	<table width="100%" cellpadding="0" cellspacing="0">
            	<tr>
                	<td width="80"><cf_get_lang dictionary_id ='57519.Cari Hesap'></td><td>: <cfif isdefined("attributes.company") and len(attributes.company)>#attributes.company#</cfif></td>
                </tr>
                <tr><td colspan="2"><hr /></td></tr>
                <tr>
                	<td><cf_get_lang dictionary_id ='57657.Ürün '></td><td>: <cfif isdefined("attributes.product_name") and len(attributes.product_name)>#attributes.product_name#</cfif></td>
            	</tr>
                 <tr><td colspan="2"><hr /></td></tr>
                <tr>
                	<td><cf_get_lang dictionary_id ='57486.Kategori'></td><td> : <cfif isdefined ("attributes.product_cat") and len(attributes.product_cat)>#attributes.product_cat#</cfif></td>
            	</tr>
                <tr><td colspan="2"><hr /></td></tr>
                <tr>
                	<td><cf_get_lang dictionary_id='58847.Marka'></td><td> : <cfif len(attributes.brand_name)>#attributes.brand_name#</cfif></td>
            	</tr>
                <tr><td colspan="2"><hr /></td></tr>
                <tr>
                	<td><cf_get_lang dictionary_id ='40264.Proje No'></td><td>: <cfif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>#attributes.project_id#</cfif></td>
                </tr>
                <tr><td colspan="2"><hr /></td></tr>
                <tr>
                	<td><cf_get_lang dictionary_id ='57416.Proje'></td><td> : <cfif isdefined("attributes.project_head")>#attributes.project_head#</cfif></td>
            	</tr>
                <tr><td colspan="2"><hr /></td></tr>
                <tr>
                	<td><cf_get_lang dictionary_id ='40294.Satış Çalışanı'></td><td> : 	<cfif len(attributes.sales_employee_name)>#attributes.sales_employee_name#</cfif></td>
                </tr>
                <tr><td colspan="2"><hr /></td></tr>
           </table>
        </td>
        <td valign="top">
        	<table width="100%" cellpadding="0" cellspacing="0">
            	<tr>
                	<td width="100"><cf_get_lang dictionary_id='58690.Tarih Aralığı'></td>
                    <td format="date">: <cfif isdefined("attributes.date1") and len(attributes.date1)>#dateformat(attributes.date1,dateformat_style)#</cfif>
                          <cfif isdefined("attributes.date2") and len(attributes.date2)> - #dateformat(attributes.date2,dateformat_style)#</cfif>
                    </td>
                </tr>
                <tr><td colspan="2"><hr /></td></tr>
                <tr>
                	<td><cf_get_lang dictionary_id='58960.Rapor Tipi'></td>
                    <td>: <cfif isDefined('attributes.report_type') and attributes.report_type eq 1><cf_get_lang dictionary_id='39054.Stok Bazında'></cfif>
            			  <cfif isDefined('attributes.report_type') and attributes.report_type eq 2><cf_get_lang dictionary_id='57660.Belge Bazında'></cfif>
                    </td>
                </tr>
                <tr><td colspan="2"><hr /></td></tr>
                <tr>
                	<td><cf_get_lang dictionary_id ='40266.Fatura Hareket Tipi'></td>
                    <td>:<cfif isdefined("attributes.invoice_action") and attributes.invoice_action eq 1><cf_get_lang dictionary_id ='39216.Faturalanmış'></cfif>
 			             <cfif isdefined("attributes.invoice_action") and attributes.invoice_action eq 2><cf_get_lang dictionary_id ='39217.Faturalanmamış'></cfif>
                    </td>
                </tr>
                <tr><td colspan="2"><hr /></td></tr>
                <tr>
                	<td><cf_get_lang dictionary_id ='40267.Sıralama Türü'></td>
                    <td>:
						<cfif isdefined("attributes.oby")>
                            <cfif attributes.oby eq 1><cf_get_lang dictionary_id='57926.Azalan Tarih'></cfif>
                            <cfif attributes.oby eq 2><cf_get_lang dictionary_id='57925.Artan Tarih'></cfif>
                            <cfif attributes.oby eq 3><cf_get_lang dictionary_id='29459.Artan No'></cfif>
                            <cfif attributes.oby eq 4><cf_get_lang dictionary_id='29458.Azalan No'></cfif>
                            <cfif attributes.oby eq 5><cf_get_lang dictionary_id='58221.Ürün Adı'></cfif>
                        </cfif>
                    </td>
               </tr>
               <tr><td colspan="2"><hr /></td></tr>
               <tr>
               		<td><cf_get_lang dictionary_id='57880.Belge No'></td><td>: <cfif isdefined("attributes.belge_no") and len(attributes.belge_no)>#attributes.belge_no#</cfif></td>
               </tr>
               <tr><td colspan="2"><hr /></td></tr>
           </table>
        </td>
    </tr>
    </cfoutput>
</table>
</cfif>
<!-- sil -->
<cf_report_list>
	<cfif isdefined('attributes.export_to_table') and attributes.export_to_table eq 1 and not isdefined('attributes.oran')>
		<cfinclude template="consigment_report_to_table.cfm"><!--- konsinye raporu tabloya yazılacaksa, ilgili tabloyu oluşturur ve sonrasında tabloya kayıtları aktarır --->
	<cfelse><!--- standart raporlama --->
	<thead>
        <tr>
			<cfif attributes.report_type eq 1><!--- Stok bazinda rapor secili ise --->
				<th width="100"><cf_get_lang dictionary_id ='57486.Kategori'></th>
				<th width="100"><cf_get_lang dictionary_id='58800.Ürün Kodu'></th>
				<th width="100"><cf_get_lang dictionary_id ='57657.Ürün'></th>
				<th nowrap="nowrap"><cf_get_lang dictionary_id='58847.Marka'></th>
				<th nowrap="nowrap"><cf_get_lang dictionary_id ='57635.Miktar'></th>
				<th nowrap="nowrap"><cf_get_lang dictionary_id='58258.Maliyet'></th>
				<th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
				<th nowrap="nowrap"><cf_get_lang dictionary_id='29418.İade'></th>
				<th nowrap="nowrap"><cf_get_lang dictionary_id ='40268.İade Maliyet'></th>
				<th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
				<th nowrap="nowrap"><cf_get_lang dictionary_id ='39235.Faturalanan Miktar'></th>
				<th nowrap="nowrap"><cf_get_lang dictionary_id ='40269.Fatura Maliyeti'></th>
				<th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
				<th nowrap="nowrap"><cf_get_lang dictionary_id ='40270.Kalan Miktar'></th>
				<th nowrap="nowrap"><cf_get_lang dictionary_id='58258.Maliyet'></th>
				<th style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></th>
			<cfelse>
					<cfif not (isdefined('attributes.is_excel') and listfind('2',attributes.is_excel,',')) and attributes.invoice_action neq 2 and attributes.is_month_based_ eq 1>
						<cfset rowspan_ = 2>
					<cfelse>
						<cfset rowspan_ = 1>
					</cfif>
					<cfoutput>
					<th style="text-align:center;" rowspan="#rowspan_#"><cf_get_lang dictionary_id ='57742.Tarih'></th>
					<th width="70" rowspan="#rowspan_#"><cf_get_lang dictionary_id='58138.İrsaliye No'></th>
					<th width="100" rowspan="#rowspan_#"><cf_get_lang dictionary_id='58578.Belge Türü'></th>
					<th width="60" rowspan="#rowspan_#"><cf_get_lang dictionary_id ='57416.Proje'></th>
					<th rowspan="#rowspan_#"><cf_get_lang dictionary_id ='57519.Cari Hesap'></th>
					<th rowspan="#rowspan_#"><cf_get_lang dictionary_id ='57486.Kategori'></th>
					<th rowspan="#rowspan_#"><cf_get_lang dictionary_id ='57518.Stok Kodu'></th>
					<th rowspan="#rowspan_#"><cf_get_lang dictionary_id ='58221.Ürün Adı'></th>
					<th rowspan="#rowspan_#"><cf_get_lang dictionary_id ='39230.Depo Giriş'></th>
					<th rowspan="#rowspan_#"><cf_get_lang dictionary_id ='39231.Depo Çıkış'></th>
					<th rowspan="#rowspan_#"><cf_get_lang dictionary_id ='57554.Giriş'></th>
					<th rowspan="#rowspan_#"><cf_get_lang dictionary_id ='57431.Çıkış'></th>
					<th rowspan="#rowspan_#"><cf_get_lang dictionary_id ='40271.Belge Maliyeti'></th>
					<th rowspan="#rowspan_#"><cf_get_lang dictionary_id ='58474.Birim'></th>
					<th rowspan="#rowspan_#"><cf_get_lang dictionary_id ='40272.İade İrs Miktar'></th>
					<th rowspan="#rowspan_#"><cf_get_lang dictionary_id ='40273.İade İrs Maliyet'></th>
					<th rowspan="#rowspan_#"><cf_get_lang dictionary_id ='58474.Birim'></th>
					<th rowspan="#rowspan_#"><cf_get_lang dictionary_id ='40274.İade İrs No'></th>
					</cfoutput>
				<cfif attributes.invoice_action neq 2><!--- faturalanmamış secilmemişse --->
					<cfif not (isdefined('attributes.is_excel') and listfind('2',attributes.is_excel,',')) and attributes.is_month_based_ eq 1>
						<cfset rowspan_ = 2>
					<cfelse>
						<cfset rowspan_ = 1>
					</cfif>
					<cfoutput>
						<th rowspan="#rowspan_#"><cf_get_lang dictionary_id ='39235.Faturalanan Miktar'></th>
						<th rowspan="#rowspan_#"><cf_get_lang dictionary_id ='40275.Faturalanan Maliyet'></th>
						<th rowspan="#rowspan_#"><cf_get_lang dictionary_id ='58474.Birim'></th>
						<th rowspan="#rowspan_#"><cf_get_lang dictionary_id ='58133.Fatura No'></th>
						<th rowspan="#rowspan_#"><cf_get_lang dictionary_id ='40270.Kalan Miktar'></th>
						<th rowspan="#rowspan_#"><cf_get_lang dictionary_id ='58258.Maliyet'></th>
						<th rowspan="#rowspan_#"><cf_get_lang dictionary_id ='58474.Birim'></th>
					</cfoutput>
					<cfif attributes.is_month_based_ eq 1><!--- faturalama bilgileri aylık gosterilecekse --->
						<cfset month_count_ = datediff('m',attributes.date1,attributes.date2)>
						<cfset start_date=dateformat(attributes.date1,'mm/yyyy')>
						<cfoutput>
							<cfif isdefined("attributes.is_pre_ships")>
								<th style="text-align:center;" colspan="3">#session.ep.period_year-1#</th>
							</cfif>
							<cfloop from="0" to="#month_count_#" index="month_ii">
								<cfset start_date=dateformat(date_add('m',month_ii,attributes.date1),'mm/yyyy')>
								<th style="text-align:center;" colspan="3">#start_date#</th>
							</cfloop>
						</cfoutput>
					</cfif>
				</cfif>
			</cfif>
		</tr>
		<cfif attributes.report_type eq 2 and attributes.invoice_action neq 2 and attributes.is_month_based_ eq 1><!--- belge bazında raporlama, faturalanmamış secilmemiş ve ay bazında faturalama işaretli ise --->
			<tr>
				<cfif isdefined('attributes.is_excel') and listfind('1,2',attributes.is_excel,',')>
					<th nowrap="nowrap"></th>
				</cfif>
				<cfset month_count_ = datediff('m',attributes.date1,attributes.date2)>
				<cfset start_date=dateformat(attributes.date1,'mm/yyyy')>
				<cfif isdefined("attributes.is_pre_ships")>
					<th nowrap="nowrap"><cf_get_lang dictionary_id ='40603.Fatura Miktarı'></th>
					<th nowrap="nowrap"><cf_get_lang dictionary_id ='40269.Fatura Maliyeti'></th>
					<th nowrap="nowrap"><cf_get_lang dictionary_id ='58133.Fatura No'></th>
				</cfif>
				<cfloop from="0" to="#month_count_#" index="month_tt">
					<cfset start_date=dateformat(date_add('m',month_tt,attributes.date1),'mm/yyyy')>
					<th nowrap="nowrap"><cf_get_lang dictionary_id ='40603.Fatura Miktarı'></th>
					<th nowrap="nowrap"><cf_get_lang dictionary_id ='40269.Fatura Maliyeti'></th>
					<th nowrap="nowrap"><cf_get_lang dictionary_id ='58133.Fatura No'></th>
				</cfloop>
			</tr>
		</cfif>
    </thead>
	</cfif>
	<cfscript>
		for(elemet_i=1;elemet_i lte 20; elemet_i=elemet_i+1)
			page_totals[1][#elemet_i#] = 0;
	</cfscript>
	<cfif GET_ALL_SHIP.recordcount>
		<cfif attributes.report_type eq 2><!--- BELGE BAZINDA RAPORLAMA --->
			<cfscript>
				company_id_list ='';
				consumer_id_list ='';
				dept_id_list ='';
				deliver_emp_list ='';
				prod_id_list_ ='';
				project_id_list='';
				if(isdefined('attributes.is_excel') and listfind('1,2',attributes.is_excel,','))
				{
					attributes.startrow=1;
					attributes.maxrows=GET_ALL_SHIP.recordcount;
				}
				else if(isdefined('attributes.export_to_table') and attributes.export_to_table eq 1)
					attributes.maxrows=500;
			</cfscript>
			<cfset kontrol_ship = 0>
			<cfoutput query="GET_ALL_SHIP" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfif len(COMPANY_ID) and (COMPANY_ID neq 0) and not listfind(company_id_list,COMPANY_ID)>
					<cfset company_id_list=listappend(company_id_list,COMPANY_ID)>
				<cfelseif len(CONSUMER_ID) and (CONSUMER_ID neq 0) and not listfind(consumer_id_list,CONSUMER_ID)>
					<cfset consumer_id_list=listappend(consumer_id_list,CONSUMER_ID)>
				</cfif>
				<cfif type eq 1>
					<cfset kontrol_ship = 1>
					<cfif isdefined('ship_list_#GET_ALL_SHIP.SHIP_PERIOD#')>
						<cfset 'ship_list_#GET_ALL_SHIP.SHIP_PERIOD#' = listappend(evaluate('ship_list_#GET_ALL_SHIP.SHIP_PERIOD#'),ship_id,',')>
					<cfelse>
						<cfset 'ship_list_#GET_ALL_SHIP.SHIP_PERIOD#' = ship_id>
					</cfif>
					<cfif isdefined('ship_list_spe')>
						<cfset ship_list_spe = listappend(ship_list_spe,'#ship_id#-#GET_ALL_SHIP.SHIP_PERIOD#')>
					<cfelse>
						<cfset ship_list_spe = '#ship_id#-#GET_ALL_SHIP.SHIP_PERIOD#'>
					</cfif> 
				</cfif>
				<cfif len(DEPARTMENT_ID) and (DEPARTMENT_ID neq 0) or len(DEPARTMENT_ID_2)>
					<cfif not listfind(dept_id_list,DEPARTMENT_ID)>
						<cfset dept_id_list=listappend(dept_id_list,DEPARTMENT_ID)>
					</cfif>
					<cfif not listfind(dept_id_list,DEPARTMENT_ID_2)>
						<cfset dept_id_list=listappend(dept_id_list,DEPARTMENT_ID_2)>
					</cfif>
				</cfif>
				<cfif not listfind(prod_id_list_,PRODUCT_ID)>
					<cfset prod_id_list_=listappend(prod_id_list_,PRODUCT_ID)>
				</cfif>
				<cfif len(PROJECT_ID) and not listfind(project_id_list,PROJECT_ID)>
					<cfset project_id_list=listappend(project_id_list,PROJECT_ID)>
				</cfif>
			</cfoutput>
			<cfset artir = 0>
			<cfloop query="get_all_periods">
				<cfif isdefined('ship_list_#get_all_periods.PERIOD_ID#') and len(evaluate('ship_list_#get_all_periods.PERIOD_ID#'))>
					<cfset artir = artir + 1>
				</cfif>
			</cfloop>
			<cfif kontrol_ship eq 1>
				<cfquery name="get_all_ship_amount_2" datasource="#dsn#"><!--- belge bazında dokum alındıgında irsaliyelerin iliskili oldugu iade konsinye irsaliyelerini çekiyor --->
					SELECT
						SUM(AMOUNT) AS AMOUNT,
						PRODUCT_ID,
						STOCK_ID,
						TO_SHIP_ID,
						TO_SHIP_TYPE,
						TO_SHIP_NUMBER,
						SHIP_YEAR,
						SHIP_ID,
						SHIP_PERIOD,
						SUM(SHIP_TOTAL_COST*AMOUNT) AS SHIP_TOTAL_COST
					FROM
					(
					<cfset kontrol_row = 0>
					<cfloop query="get_all_periods">
						<cfif isdefined('ship_list_#get_all_periods.PERIOD_ID#') and len(evaluate('ship_list_#get_all_periods.PERIOD_ID#'))><!--- bu donemde konsinye irsaliye varsa --->
							<cfset kontrol_row = kontrol_row + 1>
							<cfif kontrol_row neq 1>UNION ALL</cfif>
							SELECT <!--- DISTINCT --->
								SRR.AMOUNT AS AMOUNT,
								SRR.PRODUCT_ID,
								SRR.STOCK_ID,
								TO_SHIP_ID,
								TO_SHIP_TYPE,
								S.SHIP_NUMBER AS TO_SHIP_NUMBER,
								YEAR(S.SHIP_DATE) AS SHIP_YEAR,
								SRR.SHIP_ID,
								SRR.SHIP_PERIOD,
								ISNULL((SELECT
									TOP 1 (PURCHASE_NET_SYSTEM + PURCHASE_EXTRA_COST_SYSTEM)  
								FROM 
									#dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.GET_PRODUCT_COST_PERIOD GPCP
								WHERE
									GPCP.START_DATE <= S.SHIP_DATE
									AND GPCP.PRODUCT_ID = SRR.PRODUCT_ID
								ORDER BY GPCP.START_DATE DESC,GPCP.RECORD_DATE DESC, GPCP.PURCHASE_NET_SYSTEM DESC
									),0) AS SHIP_TOTAL_COST			
							FROM
								#dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.SHIP_ROW_RELATION SRR,
								#dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.SHIP S
							WHERE
								SRR.SHIP_ID IN (#evaluate('ship_list_#get_all_periods.PERIOD_ID#')#)
								AND SRR.TO_SHIP_ID = S.SHIP_ID
								AND SRR.TO_SHIP_TYPE = S.SHIP_TYPE
								AND SHIP_PERIOD= <cfqueryparam cfsqltype="cf_sql_integer" value="#get_all_periods.PERIOD_ID#">
								AND S.SHIP_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
								<cfif len(attributes.project_id) and len(attributes.project_head)>
									AND S.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
								</cfif>
								<cfif isdefined("attributes.member_cat_type") and listlen(attributes.member_cat_type,'-') eq 2 and listfirst(attributes.member_cat_type,'-') is '1'>
									AND S.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANYCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.member_cat_type,'-')#">)
								</cfif>
								<cfif isdefined("attributes.member_cat_type") and listlen(attributes.member_cat_type,'-') eq 2 and listfirst(attributes.member_cat_type,'-') is '2'>
									AND S.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER WHERE CONSUMER_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.member_cat_type,'-')#">)
								</cfif>
								<cfif len(attributes.consumer_id) and attributes.consumer_id gt 0 and Len(attributes.consumer_name)>
									AND S.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
								</cfif>
								<cfif len(attributes.company_id) and attributes.company_id gt 0 and Len(attributes.company)>
									AND S.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
								</cfif>
								<cfif len(attributes.sales_employee_id) and Len(attributes.sales_employee_name)>
									AND S.SALE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_employee_id#">
								</cfif>
								<cfif len(attributes.stock_id) and len(attributes.product_name)>
									AND SRR.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
								</cfif>
								AND S.IS_WITH_SHIP = 0 <!--- faturaların kendi irsaliyelerini almamak icin, zaten faturaları ayrıca cekiyoruz --->
								AND S.SHIP_TYPE IN (75,79)
								AND SRR.TO_SHIP_ID IS NOT NULL
								
							<cfif isdefined('list_period_years') and listfind(list_period_years,(get_all_periods.PERIOD_YEAR+1))> <!--- bir sonraki donemde aynı irsaliyeler konsinye irsaliyelere cekilmis mi kontrol ediliyor --->
							UNION ALL
								SELECT <!--- DISTINCT --->
									SRR.AMOUNT AS AMOUNT,
									SRR.PRODUCT_ID,
									SRR.STOCK_ID,
									TO_SHIP_ID,
									TO_SHIP_TYPE,
									S.SHIP_NUMBER AS TO_SHIP_NUMBER,
									YEAR(S.SHIP_DATE) AS SHIP_YEAR,
									SRR.SHIP_ID,
									SRR.SHIP_PERIOD,
									ISNULL((SELECT
										TOP 1 (PURCHASE_NET_SYSTEM + PURCHASE_EXTRA_COST_SYSTEM)  
									FROM 
										#dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.GET_PRODUCT_COST_PERIOD GPCP
									WHERE
										GPCP.START_DATE <= S.SHIP_DATE
										AND GPCP.PRODUCT_ID = SRR.PRODUCT_ID
									ORDER BY GPCP.START_DATE DESC,GPCP.RECORD_DATE DESC, GPCP.PURCHASE_NET_SYSTEM DESC
										),0) AS SHIP_TOTAL_COST			
								FROM
									#dsn#_#get_all_periods.PERIOD_YEAR+1#_#get_all_periods.OUR_COMPANY_ID#.SHIP_ROW_RELATION SRR,
									#dsn#_#get_all_periods.PERIOD_YEAR+1#_#get_all_periods.OUR_COMPANY_ID#.SHIP S
								WHERE
									SRR.SHIP_ID IN (#evaluate('ship_list_#get_all_periods.PERIOD_ID#')#)
									AND SRR.TO_SHIP_ID = S.SHIP_ID
									AND SRR.TO_SHIP_TYPE = S.SHIP_TYPE
									AND SHIP_PERIOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_all_periods.PERIOD_ID#">
									AND S.SHIP_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
									<cfif len(attributes.project_id) and len(attributes.project_head)>
										AND S.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
									</cfif>
									<cfif isdefined("attributes.member_cat_type") and listlen(attributes.member_cat_type,'-') eq 2 and listfirst(attributes.member_cat_type,'-') is '1'>
										AND S.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANYCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.member_cat_type,'-')#">)
									</cfif>
									<cfif isdefined("attributes.member_cat_type") and listlen(attributes.member_cat_type,'-') eq 2 and listfirst(attributes.member_cat_type,'-') is '2'>
										AND S.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER WHERE CONSUMER_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.member_cat_type,'-')#">)
									</cfif>
									<cfif len(attributes.consumer_id) and attributes.consumer_id gt 0 and Len(attributes.consumer_name)>
										AND S.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
									</cfif>
									<cfif len(attributes.company_id) and attributes.company_id gt 0 and Len(attributes.company)>
										AND S.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
									</cfif>
									<cfif len(attributes.sales_employee_id) and Len(attributes.sales_employee_name)>
										AND S.SALE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_employee_id#">
									</cfif>
									<cfif len(attributes.stock_id) and len(attributes.product_name)>
										AND SRR.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
									</cfif>
									AND S.IS_WITH_SHIP = 0 <!--- faturaların kendi irsaliyelerini almamak icin, zaten faturaları ayrıca cekiyoruz --->
									AND S.SHIP_TYPE IN (75,79)
									AND SRR.TO_SHIP_ID IS NOT NULL
							</cfif>
							<cfif isdefined('list_period_years') and listfind(list_period_years,(get_all_periods.PERIOD_YEAR+2))> <!--- bir sonraki donemde aynı irsaliyeler konsinye irsaliyelere cekilmis mi kontrol ediliyor --->
							UNION ALL
								SELECT <!--- DISTINCT --->
									SRR.AMOUNT AS AMOUNT,
									SRR.PRODUCT_ID,
									SRR.STOCK_ID,
									TO_SHIP_ID,
									TO_SHIP_TYPE,
									S.SHIP_NUMBER AS TO_SHIP_NUMBER,
									YEAR(S.SHIP_DATE) AS SHIP_YEAR,
									SRR.SHIP_ID,
									SRR.SHIP_PERIOD,
									ISNULL((SELECT
										TOP 1 (PURCHASE_NET_SYSTEM + PURCHASE_EXTRA_COST_SYSTEM)  
									FROM 
										#dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.GET_PRODUCT_COST_PERIOD GPCP
									WHERE
										GPCP.START_DATE <= S.SHIP_DATE
										AND GPCP.PRODUCT_ID = SRR.PRODUCT_ID
									ORDER BY GPCP.START_DATE DESC,GPCP.RECORD_DATE DESC, GPCP.PURCHASE_NET_SYSTEM DESC
										),0) AS SHIP_TOTAL_COST			
								FROM
									#dsn#_#get_all_periods.PERIOD_YEAR+2#_#get_all_periods.OUR_COMPANY_ID#.SHIP_ROW_RELATION SRR,
									#dsn#_#get_all_periods.PERIOD_YEAR+2#_#get_all_periods.OUR_COMPANY_ID#.SHIP S
								WHERE
									SRR.SHIP_ID IN (#evaluate('ship_list_#get_all_periods.PERIOD_ID#')#)
									AND SRR.TO_SHIP_ID = S.SHIP_ID
									AND SRR.TO_SHIP_TYPE = S.SHIP_TYPE
									AND SHIP_PERIOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_all_periods.PERIOD_ID#">
									AND S.SHIP_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
									<cfif len(attributes.project_id) and len(attributes.project_head)>
										AND S.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
									</cfif>
									<cfif isdefined("attributes.member_cat_type") and listlen(attributes.member_cat_type,'-') eq 2 and listfirst(attributes.member_cat_type,'-') is '1'>
										AND S.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANYCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.member_cat_type,'-')#">)
									</cfif>
									<cfif isdefined("attributes.member_cat_type") and listlen(attributes.member_cat_type,'-') eq 2 and listfirst(attributes.member_cat_type,'-') is '2'>
										AND S.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER WHERE CONSUMER_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.member_cat_type,'-')#">)
									</cfif>
									<cfif len(attributes.consumer_id) and attributes.consumer_id gt 0 and Len(attributes.consumer_name)>
										AND S.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
									</cfif>
									<cfif len(attributes.company_id) and attributes.company_id gt 0 and Len(attributes.company)>
										AND S.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
									</cfif>
									<cfif len(attributes.sales_employee_id) and Len(attributes.sales_employee_name)>
										AND S.SALE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_employee_id#">
									</cfif>
									<cfif len(attributes.stock_id) and len(attributes.product_name)>
										AND SRR.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
									</cfif>
									AND S.IS_WITH_SHIP = 0 <!--- faturaların kendi irsaliyelerini almamak icin, zaten faturaları ayrıca cekiyoruz --->
									AND S.SHIP_TYPE IN (75,79)
									AND SRR.TO_SHIP_ID IS NOT NULL
							</cfif>
						</cfif>				
					</cfloop>
					) AS A1
					GROUP BY
						PRODUCT_ID,
						STOCK_ID,
						TO_SHIP_ID,
						TO_SHIP_TYPE,
						TO_SHIP_NUMBER,
						SHIP_ID,
						SHIP_PERIOD,
						SHIP_YEAR
					ORDER BY TO_SHIP_ID
				</cfquery>
				<cfif get_all_ship_amount_2.recordcount>
					<cfquery name="get_all_ship_amount" dbtype="query"><!--- belge bazında dokum alındıgında irsaliyelerin iliskili oldugu iade konsinye irsaliyelerini çekiyor --->
						SELECT
							SUM(AMOUNT) AS AMOUNT,
							PRODUCT_ID,
							STOCK_ID,
							TO_SHIP_ID,
							TO_SHIP_TYPE,
							TO_SHIP_NUMBER,
							SHIP_ID,
							SHIP_PERIOD,
							SUM(SHIP_TOTAL_COST) AS SHIP_TOTAL_COST
						FROM
							get_all_ship_amount_2
						GROUP BY
							PRODUCT_ID,
							STOCK_ID,
							TO_SHIP_ID,
							TO_SHIP_TYPE,
							TO_SHIP_NUMBER,
							SHIP_ID,
							SHIP_PERIOD
						ORDER BY TO_SHIP_ID
					</cfquery>
				<cfelse>
					<cfset get_all_ship_amount.recordcount=0>
				</cfif>
			<cfelse>
				<cfset get_all_ship_amount.recordcount=0>
				<cfset get_all_ship_amount_2.recordcount=0>
			</cfif>
			<cfset artir2 = 0>
			<cfloop query="get_all_periods">
				<cfif isdefined('ship_list_#get_all_periods.PERIOD_ID#') and len(evaluate('ship_list_#get_all_periods.PERIOD_ID#'))>
					<cfset artir2 = artir2 + 1>
				</cfif>
			</cfloop>
			<cfif kontrol_ship eq 1>
				<cfquery name="get_all_inv_amount_2" datasource="#dsn#">
					SELECT
						SUM(AMOUNT) AS AMOUNT,
						SUM(INV_TOTAL_COST*AMOUNT) AS INV_TOTAL_COST,
						INVOICE_YEAR,
						<cfif attributes.invoice_action neq 2 and attributes.is_month_based_ eq 1>
						INVOICE_MONTH,
						</cfif>
						PRODUCT_ID,
						STOCK_ID,
						TO_INVOICE_ID,
						TO_INVOICE_CAT,
						TO_INVOICE_NUMBER,
						SHIP_ID,
						SHIP_PERIOD
					FROM
					(
					<cfset active_period_ = 0>
					<cfloop query="get_all_periods">
						<cfset active_period_ = active_period_ + 1>
							SELECT
								SUM(AMOUNT) AS AMOUNT,
								YEAR(INVOICE_DATE) AS INVOICE_YEAR,
								<cfif attributes.invoice_action neq 2 and attributes.is_month_based_ eq 1>
								MONTH(INVOICE_DATE) AS INVOICE_MONTH,
								</cfif>
								PRODUCT_ID,
								STOCK_ID,
								SRR.TO_INVOICE_ID,
								SRR.TO_INVOICE_CAT,
								INV.INVOICE_NUMBER AS TO_INVOICE_NUMBER,
								SRR.SHIP_ID,
								SRR.SHIP_PERIOD,
								ISNULL((SELECT
									TOP 1 (PURCHASE_NET_SYSTEM + PURCHASE_EXTRA_COST_SYSTEM)  
								FROM 
									#dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.GET_PRODUCT_COST_PERIOD GPCP
								WHERE
									GPCP.START_DATE <= INV.INVOICE_DATE
									AND GPCP.PRODUCT_ID = SRR.PRODUCT_ID
								ORDER BY GPCP.START_DATE DESC,GPCP.RECORD_DATE DESC, GPCP.PURCHASE_NET_SYSTEM DESC
									),0) AS INV_TOTAL_COST							
							FROM
								#dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.SHIP_ROW_RELATION SRR,
								#dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.INVOICE INV
							WHERE
								CAST(SRR.SHIP_ID AS VARCHAR) + '-' + CAST(SRR.SHIP_PERIOD AS VARCHAR) IN ('#replace(ship_list_spe,",","','","all")#')
								AND SRR.TO_INVOICE_ID =INV.INVOICE_ID
								AND SRR.TO_INVOICE_CAT = INV.INVOICE_CAT							
								AND INV.INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
								<cfif len(attributes.project_id) and len(attributes.project_head)>
									AND INV.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
								</cfif>
								<cfif isdefined("attributes.member_cat_type") and listlen(attributes.member_cat_type,'-') eq 2 and listfirst(attributes.member_cat_type,'-') is '1'>
									AND INV.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANYCAT_ID = #listlast(attributes.member_cat_type,'-')#)
								</cfif>
								<cfif isdefined("attributes.member_cat_type") and listlen(attributes.member_cat_type,'-') eq 2 and listfirst(attributes.member_cat_type,'-') is '2'>
									AND INV.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER WHERE CONSUMER_CAT_ID = #listlast(attributes.member_cat_type,'-')#)
								</cfif>
								<cfif len(attributes.consumer_id) and attributes.consumer_id gt 0 and Len(attributes.consumer_name)>
									AND INV.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
								</cfif>
								<cfif len(attributes.company_id) and attributes.company_id gt 0 and Len(attributes.company)>
									AND INV.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
								</cfif>
								<cfif len(attributes.sales_employee_id) and Len(attributes.sales_employee_name)>
									AND INV.SALE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_employee_id#">
								</cfif>
								<cfif len(attributes.stock_id) and len(attributes.product_name)>
									AND SRR.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
								</cfif>
								AND SRR.TO_INVOICE_ID IS NOT NULL
							GROUP BY
								SRR.SHIP_ID,
								SRR.SHIP_PERIOD,
								YEAR(INVOICE_DATE),
								<cfif attributes.invoice_action neq 2 and attributes.is_month_based_ eq 1>
								MONTH(INVOICE_DATE),
								</cfif>
								SRR.TO_INVOICE_ID,
								SRR.TO_INVOICE_CAT,
								INV.INVOICE_DATE,
								INVOICE_NUMBER,
								PRODUCT_ID,
								STOCK_ID
							<cfif active_period_ neq get_all_periods.recordcount>UNION ALL</cfif>
					</cfloop>
					) AS A1
						GROUP BY
							PRODUCT_ID,
							STOCK_ID,
							TO_INVOICE_ID,
							TO_INVOICE_CAT,
							TO_INVOICE_NUMBER,
							SHIP_ID,
							SHIP_PERIOD
							,INVOICE_YEAR
							<cfif attributes.invoice_action neq 2 and attributes.is_month_based_ eq 1>
							,INVOICE_MONTH
							</cfif>
						ORDER BY TO_INVOICE_ID
				</cfquery>
				<cfif get_all_inv_amount_2.recordcount>
					<cfquery name="get_all_inv_amount" dbtype="query">
						SELECT
							SUM(AMOUNT) AS AMOUNT,
							SUM(INV_TOTAL_COST) AS INV_TOTAL_COST,
							PRODUCT_ID,
							STOCK_ID,
							TO_INVOICE_ID,
							TO_INVOICE_CAT,
							TO_INVOICE_NUMBER,
							SHIP_ID,
							SHIP_PERIOD
							<cfif attributes.invoice_action neq 2 and attributes.is_month_based_ eq 1>
							,INVOICE_MONTH
							,INVOICE_YEAR
							</cfif>
						FROM
							get_all_inv_amount_2
						GROUP BY
							PRODUCT_ID,
							STOCK_ID,
							TO_INVOICE_ID,
							TO_INVOICE_CAT,
							TO_INVOICE_NUMBER,
							SHIP_ID,
							SHIP_PERIOD
							<cfif attributes.invoice_action neq 2 and attributes.is_month_based_ eq 1>
							,INVOICE_YEAR
							,INVOICE_MONTH
							</cfif>
						ORDER BY TO_INVOICE_ID
				</cfquery>
				<cfelse>
					<cfset get_all_inv_amount.recordcount=0>
				</cfif>
			<cfelse>
				<cfset get_all_inv_amount_2.recordcount=0>
				<cfset get_all_inv_amount.recordcount=0>
			</cfif>
			<cfset project_id_list=listsort(project_id_list,"numeric","ASC")>
			<cfif len(project_id_list)>
				<cfquery name="get_project_info" datasource="#dsn#">
					SELECT PROJECT_HEAD,PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_id_list#) ORDER BY PROJECT_ID
				</cfquery>
				<cfset project_id_list=valuelist(get_project_info.PROJECT_ID)>
			</cfif>
			<cfset prod_id_list_=listsort(prod_id_list_,"numeric","ASC",",")>
			<cfscript>
				for(shp_t=1; shp_t lte get_all_ship_amount.recordcount; shp_t=shp_t+1)
				{
					if(isdefined('used_ship_amount_new_#get_all_ship_amount.SHIP_ID[shp_t]#_#get_all_ship_amount.STOCK_ID[shp_t]#')) //miktarlar
						'used_ship_amount_new_#get_all_ship_amount.SHIP_ID[shp_t]#_#get_all_ship_amount.STOCK_ID[shp_t]#' = evaluate('used_ship_amount_new_#get_all_ship_amount.SHIP_ID[shp_t]#_#get_all_ship_amount.STOCK_ID[shp_t]#')+get_all_ship_amount.AMOUNT[shp_t];
					else
						'used_ship_amount_new_#get_all_ship_amount.SHIP_ID[shp_t]#_#get_all_ship_amount.STOCK_ID[shp_t]#' = get_all_ship_amount.AMOUNT[shp_t];
					
					if(isdefined('used_ship_cost_#get_all_ship_amount.SHIP_ID[shp_t]#_#get_all_ship_amount.STOCK_ID[shp_t]#')) //maliyet
						'used_ship_cost_#get_all_ship_amount.SHIP_ID[shp_t]#_#get_all_ship_amount.STOCK_ID[shp_t]#' = evaluate('used_ship_cost_#get_all_ship_amount.SHIP_ID[shp_t]#_#get_all_ship_amount.STOCK_ID[shp_t]#')+get_all_ship_amount.SHIP_TOTAL_COST[shp_t];
					else
						'used_ship_cost_#get_all_ship_amount.SHIP_ID[shp_t]#_#get_all_ship_amount.STOCK_ID[shp_t]#' = get_all_ship_amount.SHIP_TOTAL_COST[shp_t];
				
					if(isdefined('to_ship_number_list_#get_all_ship_amount.SHIP_ID[shp_t]#_#get_all_ship_amount.STOCK_ID[shp_t]#')) //cekildigi irsaliyeler
						'to_ship_number_list_#get_all_ship_amount.SHIP_ID[shp_t]#_#get_all_ship_amount.STOCK_ID[shp_t]#' = listappend(evaluate('to_ship_number_list_#get_all_ship_amount.SHIP_ID[shp_t]#_#get_all_ship_amount.STOCK_ID[shp_t]#'),get_all_ship_amount.TO_SHIP_NUMBER[shp_t]);
					else
						'to_ship_number_list_#get_all_ship_amount.SHIP_ID[shp_t]#_#get_all_ship_amount.STOCK_ID[shp_t]#' = get_all_ship_amount.TO_SHIP_NUMBER[shp_t];
				}
				for(shp_dd=1; shp_dd lte get_all_ship_amount_2.recordcount; shp_dd=shp_dd+1)//belge active donemde faturaya cekilmis mi
				{
					if(get_all_ship_amount_2.SHIP_YEAR[shp_dd] eq session.ep.period_year) 
						'used_paper_in_active_period_#get_all_ship_amount_2.SHIP_ID[shp_dd]#_#get_all_ship_amount_2.STOCK_ID[shp_dd]#'=1;
				}
				for(inv_zz=1; inv_zz lte get_all_inv_amount_2.recordcount; inv_zz=inv_zz+1)//belge active donemde faturaya cekilmis mi
				{
					if(get_all_inv_amount_2.INVOICE_YEAR[inv_zz] eq session.ep.period_year) 
						'used_paper_in_active_period_#get_all_inv_amount_2.SHIP_ID[inv_zz]#_#get_all_inv_amount_2.STOCK_ID[inv_zz]#'=1;
				}
				for(inv_k=1; inv_k lte get_all_inv_amount.recordcount; inv_k=inv_k+1)
				{
					if(isdefined('used_inv_amount_#get_all_inv_amount.SHIP_PERIOD[inv_k]#_#get_all_inv_amount.SHIP_ID[inv_k]#_#get_all_inv_amount.STOCK_ID[inv_k]#'))
						'used_inv_amount_#get_all_inv_amount.SHIP_PERIOD[inv_k]#_#get_all_inv_amount.SHIP_ID[inv_k]#_#get_all_inv_amount.STOCK_ID[inv_k]#' = evaluate('used_inv_amount_#get_all_inv_amount.SHIP_PERIOD[inv_k]#_#get_all_inv_amount.SHIP_ID[inv_k]#_#get_all_inv_amount.STOCK_ID[inv_k]#')+get_all_inv_amount.AMOUNT[inv_k];
					else
						'used_inv_amount_#get_all_inv_amount.SHIP_PERIOD[inv_k]#_#get_all_inv_amount.SHIP_ID[inv_k]#_#get_all_inv_amount.STOCK_ID[inv_k]#' = get_all_inv_amount.AMOUNT[inv_k];
				
					if(isdefined('used_inv_cost_#get_all_inv_amount.SHIP_PERIOD[inv_k]#_#get_all_inv_amount.SHIP_ID[inv_k]#_#get_all_inv_amount.STOCK_ID[inv_k]#'))
						'used_inv_cost_#get_all_inv_amount.SHIP_PERIOD[inv_k]#_#get_all_inv_amount.SHIP_ID[inv_k]#_#get_all_inv_amount.STOCK_ID[inv_k]#' = evaluate('used_inv_cost_#get_all_inv_amount.SHIP_PERIOD[inv_k]#_#get_all_inv_amount.SHIP_ID[inv_k]#_#get_all_inv_amount.STOCK_ID[inv_k]#')+get_all_inv_amount.INV_TOTAL_COST[inv_k];
					else
						'used_inv_cost_#get_all_inv_amount.SHIP_PERIOD[inv_k]#_#get_all_inv_amount.SHIP_ID[inv_k]#_#get_all_inv_amount.STOCK_ID[inv_k]#' = get_all_inv_amount.INV_TOTAL_COST[inv_k];

					if(isdefined('to_inv_number_list_#get_all_inv_amount.SHIP_PERIOD[inv_k]#_#get_all_inv_amount.SHIP_ID[inv_k]#_#get_all_inv_amount.STOCK_ID[inv_k]#')) //cekildigi faturalar
						'to_inv_number_list_#get_all_inv_amount.SHIP_PERIOD[inv_k]#_#get_all_inv_amount.SHIP_ID[inv_k]#_#get_all_inv_amount.STOCK_ID[inv_k]#' = listappend(evaluate('to_inv_number_list_#get_all_inv_amount.SHIP_PERIOD[inv_k]#_#get_all_inv_amount.SHIP_ID[inv_k]#_#get_all_inv_amount.STOCK_ID[inv_k]#'),get_all_inv_amount.TO_INVOICE_NUMBER[inv_k]);
					else
						'to_inv_number_list_#get_all_inv_amount.SHIP_PERIOD[inv_k]#_#get_all_inv_amount.SHIP_ID[inv_k]#_#get_all_inv_amount.STOCK_ID[inv_k]#' = get_all_inv_amount.TO_INVOICE_NUMBER[inv_k];
					
					
					if(attributes.invoice_action neq 2 and attributes.is_month_based_ eq 1)
					{
						if(isdefined('used_inv_amount_#get_all_inv_amount.SHIP_PERIOD[inv_k]#_#get_all_inv_amount.SHIP_ID[inv_k]#_#get_all_inv_amount.STOCK_ID[inv_k]#_#get_all_inv_amount.INVOICE_YEAR[inv_k]#_#get_all_inv_amount.INVOICE_MONTH[inv_k]#'))
							'used_inv_amount_#get_all_inv_amount.SHIP_PERIOD[inv_k]#_#get_all_inv_amount.SHIP_ID[inv_k]#_#get_all_inv_amount.STOCK_ID[inv_k]#_#get_all_inv_amount.INVOICE_YEAR[inv_k]#_#get_all_inv_amount.INVOICE_MONTH[inv_k]#' = evaluate('used_inv_amount_#get_all_inv_amount.SHIP_PERIOD[inv_k]#_#get_all_inv_amount.SHIP_ID[inv_k]#_#get_all_inv_amount.STOCK_ID[inv_k]#_#get_all_inv_amount.INVOICE_YEAR[inv_k]#_#get_all_inv_amount.INVOICE_MONTH[inv_k]#')+get_all_inv_amount.AMOUNT[inv_k];
						else
							'used_inv_amount_#get_all_inv_amount.SHIP_PERIOD[inv_k]#_#get_all_inv_amount.SHIP_ID[inv_k]#_#get_all_inv_amount.STOCK_ID[inv_k]#_#get_all_inv_amount.INVOICE_YEAR[inv_k]#_#get_all_inv_amount.INVOICE_MONTH[inv_k]#' = get_all_inv_amount.AMOUNT[inv_k];
					
						if(isdefined('used_inv_cost_#get_all_inv_amount.SHIP_PERIOD[inv_k]#_#get_all_inv_amount.SHIP_ID[inv_k]#_#get_all_inv_amount.STOCK_ID[inv_k]#_#get_all_inv_amount.INVOICE_YEAR[inv_k]#_#get_all_inv_amount.INVOICE_MONTH[inv_k]#'))
							'used_inv_cost_#get_all_inv_amount.SHIP_PERIOD[inv_k]#_#get_all_inv_amount.SHIP_ID[inv_k]#_#get_all_inv_amount.STOCK_ID[inv_k]#_#get_all_inv_amount.INVOICE_YEAR[inv_k]#_#get_all_inv_amount.INVOICE_MONTH[inv_k]#' = evaluate('used_inv_cost_#get_all_inv_amount.SHIP_PERIOD[inv_k]#_#get_all_inv_amount.SHIP_ID[inv_k]#_#get_all_inv_amount.STOCK_ID[inv_k]#_#get_all_inv_amount.INVOICE_YEAR[inv_k]#_#get_all_inv_amount.INVOICE_MONTH[inv_k]#')+get_all_inv_amount.INV_TOTAL_COST[inv_k];
						else
							'used_inv_cost_#get_all_inv_amount.SHIP_PERIOD[inv_k]#_#get_all_inv_amount.SHIP_ID[inv_k]#_#get_all_inv_amount.STOCK_ID[inv_k]#_#get_all_inv_amount.INVOICE_YEAR[inv_k]#_#get_all_inv_amount.INVOICE_MONTH[inv_k]#' = get_all_inv_amount.INV_TOTAL_COST[inv_k];

						if(isdefined('to_inv_number_list_#get_all_inv_amount.SHIP_PERIOD[inv_k]#_#get_all_inv_amount.SHIP_ID[inv_k]#_#get_all_inv_amount.STOCK_ID[inv_k]#_#get_all_inv_amount.INVOICE_YEAR[inv_k]#_#get_all_inv_amount.INVOICE_MONTH[inv_k]#')) //cekildigi irsaliyeler
							'to_inv_number_list_#get_all_inv_amount.SHIP_PERIOD[inv_k]#_#get_all_inv_amount.SHIP_ID[inv_k]#_#get_all_inv_amount.STOCK_ID[inv_k]#_#get_all_inv_amount.INVOICE_YEAR[inv_k]#_#get_all_inv_amount.INVOICE_MONTH[inv_k]#' = listappend(evaluate('to_inv_number_list_#get_all_inv_amount.SHIP_PERIOD[inv_k]#_#get_all_inv_amount.SHIP_ID[inv_k]#_#get_all_inv_amount.STOCK_ID[inv_k]#_#get_all_inv_amount.INVOICE_YEAR[inv_k]#_#get_all_inv_amount.INVOICE_MONTH[inv_k]#'),get_all_inv_amount.TO_INVOICE_NUMBER[inv_k]);
						else
							'to_inv_number_list_#get_all_inv_amount.SHIP_PERIOD[inv_k]#_#get_all_inv_amount.SHIP_ID[inv_k]#_#get_all_inv_amount.STOCK_ID[inv_k]#_#get_all_inv_amount.INVOICE_YEAR[inv_k]#_#get_all_inv_amount.INVOICE_MONTH[inv_k]#' = get_all_inv_amount.TO_INVOICE_NUMBER[inv_k];
					}
				}
			</cfscript> 
			<cfif listlen(company_id_list)>
				<cfset company_id_list=listsort(company_id_list,"numeric","ASC",",")>
				<cfquery name="get_company_detail" datasource="#dsn#">
					SELECT 
						COMPANY.COMPANY_ID,
						COMPANY.NICKNAME,
						COMPANY.FULLNAME ,
						COMPANY_CAT.COMPANYCAT
					FROM 
						COMPANY,
						COMPANY_CAT
					WHERE 
						COMPANY.COMPANYCAT_ID = COMPANY_CAT.COMPANYCAT_ID AND
						COMPANY_ID IN (#company_id_list#) 
					ORDER BY 
						COMPANY.COMPANY_ID
				</cfquery>
			</cfif>
			<cfif listlen(consumer_id_list)>
				<cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",",")>
				<cfquery name="get_consumer_detail" datasource="#dsn#">
					SELECT 
						CONSUMER.CONSUMER_ID,
						CONSUMER.CONSUMER_NAME,
						CONSUMER.CONSUMER_SURNAME,
						CONSUMER_CAT.CONSCAT
					FROM 
						CONSUMER,
						CONSUMER_CAT
					WHERE 
						CONSUMER.CONSUMER_CAT_ID = CONSUMER_CAT.CONSCAT_ID AND 
						CONSUMER_ID IN (#consumer_id_list#) 
					ORDER BY 
						CONSUMER.CONSUMER_ID
				</cfquery>
			</cfif>
			<cfif listlen(deliver_emp_list)>
				<cfset deliver_emp_list=listsort(deliver_emp_list,"numeric","ASC",",")>
				<cfquery name="get_deliver_emp_detail" datasource="#dsn#" >
					SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#deliver_emp_list#) ORDER BY EMPLOYEE_ID
				</cfquery> 
			</cfif>
			<cfif listlen(dept_id_list)>
				<cfset dept_id_list=listsort(dept_id_list,"numeric","ASC",",")>
				<cfquery name="get_dept_detail" datasource="#dsn#" >
					SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID IN (#dept_id_list#) ORDER BY DEPARTMENT_ID
				</cfquery> 
			</cfif>
			<cfoutput query="GET_ALL_SHIP" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfset consigment_dept_amount_ = 0>
				<cfif listfind('75,77',SHIP_TYPE)><!--- kons. cıkıs iade,kons. giris --->
					<cfset consigment_dept_amount_ = consigment_dept_amount_+ PAPER_AMOUNT>
				</cfif>
				<cfif listfind('72,79',SHIP_TYPE)> <!--- kons. cıkıs, kons. giris iade iade --->
					<cfset consigment_dept_amount_ = consigment_dept_amount_+ PAPER_AMOUNT>
				</cfif>
				<cfif isdefined('used_ship_amount_new_#SHIP_ID#_#STOCK_ID#') and len(evaluate('used_ship_amount_new_#SHIP_ID#_#STOCK_ID#'))>
					<cfset consigment_dept_amount_ = consigment_dept_amount_ - evaluate('used_ship_amount_new_#SHIP_ID#_#STOCK_ID#')>
				</cfif>
				<cfif isdefined('used_inv_amount_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#') and len(evaluate('used_inv_amount_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#'))>
					<cfset consigment_dept_amount_ = consigment_dept_amount_ - evaluate('used_inv_amount_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#')>
				</cfif>
				<cfif isdefined('used_paper_in_active_period_#SHIP_ID#_#STOCK_ID#')><!--- belge aktif donemde işlem gormusse 1 set ediliyor.. önceki donemde kayıtlı irsaliyeler kalan miktarı olmasa bile aktif donemde işlem gorduyse raporda listeleniyor --->
					<cfset active_period_control=1> 
				<cfelse>
					<cfset active_period_control=0> 
				</cfif>
				<cfif not len(attributes.control_bakiye) or (len(attributes.control_bakiye) and attributes.control_bakiye eq 1 and consigment_dept_amount_ gt 0 ) or (len(attributes.control_bakiye) and attributes.control_bakiye eq 2 and (year(ISLEM_TARIHI) eq session.ep.period_year) or (consigment_dept_amount_ gt 0) or (active_period_control eq 1))>
				<!--- kapanmamış belgeler secilmisse başalngıc-bitiş tarihleri arasındaki tüm kalan miktarı olan konsinyeler gelir
				onceki donemde kapanmamış belgeler secildiginde, aktif donemdeki tüm konsinye belgeler ve onceki donemden sadece bakiye olan konsinyeler listelenir. --->
					<cfif isdefined('attributes.export_to_table') and attributes.export_to_table eq 1>
						<cfset is_export_table=1>
						<cfinclude template="consigment_report_to_table.cfm">
					<cfelse>
                    	<tbody>
						<tr>
							<td>#dateformat(ISLEM_TARIHI,dateformat_style)#</td>
							<td>#belge_no#</td>
							<td>#belge_turu#</td>
							<td><cfif len(PROJECT_ID) and listfind(project_id_list,PROJECT_ID)>#get_project_info.PROJECT_HEAD[listfind(project_id_list,PROJECT_ID)]#</cfif></td>
							<td><cfif len(COMPANY_ID)>
								#get_company_detail.FULLNAME[listfind(company_id_list,COMPANY_ID,',')]#
							<cfelseif len(CONSUMER_ID)>
								#get_consumer_detail.CONSUMER_NAME[listfind(consumer_id_list,CONSUMER_ID,',')]#
								#get_consumer_detail.CONSUMER_SURNAME[listfind(consumer_id_list,CONSUMER_ID,',')]#
							<cfelseif len(DELIVER_EMP) and isnumeric(DELIVER_EMP)>
								#get_deliver_emp_detail.EMPLOYEE_NAME[listfind(deliver_emp_list,DELIVER_EMP,',')]# 
								#get_deliver_emp_detail.EMPLOYEE_SURNAME[listfind(deliver_emp_list,DELIVER_EMP,',')]#
							</cfif>
							</td>
							<td><cfif len(company_id)>#get_company_detail.COMPANYCAT[listfind(company_id_list,COMPANY_ID,',')]#<cfelseif len(consumer_id)>#get_consumer_detail.CONSCAT[listfind(consumer_id_list,CONSUMER_ID,',')]#</cfif></td>
							<td>#stock_code#</td>
							<td>#product_name#<cfif len(property)> - #property#</cfif></td>
							<td style="text-align:right;"><cfif len(DEPARTMENT_ID) and (DEPARTMENT_ID neq 0)>#get_dept_detail.DEPARTMENT_HEAD[listfind(dept_id_list,DEPARTMENT_ID,',')]#</cfif></td>
							<td style="text-align:right;"><cfif len(DEPARTMENT_ID_2) and (DEPARTMENT_ID_2 neq 0)>#get_dept_detail.DEPARTMENT_HEAD[listfind(dept_id_list,DEPARTMENT_ID_2,',')]#</cfif></td>
							<td style="text-align:right;" nowrap="nowrap" format="numeric">
								<cfif listfind('75,77',SHIP_TYPE)><!--- kons. cıkıs iade,kons. giris --->
									#TLFormat(PAPER_AMOUNT)#
									<cfset page_totals[1][9] = page_totals[1][9] + PAPER_AMOUNT>
								</cfif>
							</td>
							<td style="text-align:right;" nowrap="nowrap" format="numeric">
							<cfif listfind('72,79',SHIP_TYPE)> <!--- kons. cıkıs, kons. giris iade iade --->
								#TLFormat(PAPER_AMOUNT)#
								<cfset page_totals[1][10] = page_totals[1][10] + PAPER_AMOUNT>
							</cfif>
							</td>
							<td style="text-align:right;" nowrap="nowrap" format="numeric">
								#TLFormat(TOTAL_COST)# 
								<cfset page_totals[1][11] = page_totals[1][11] + TOTAL_COST>
							</td>
							<td style="text-align:center;">#session.ep.money#</td>
							<cfif type eq 1><!--- eğer devirden gelmiyorsa --->
								<td style="text-align:right;" nowrap="nowrap" format="numeric"><!--- iade irsaliyesine cekilen urunlerin miktarı --->
								<cfif isdefined('used_ship_amount_new_#SHIP_ID#_#STOCK_ID#') and len(evaluate('used_ship_amount_new_#SHIP_ID#_#STOCK_ID#'))>
									#TLFormat(evaluate('used_ship_amount_new_#SHIP_ID#_#STOCK_ID#'))#
									<cfset page_totals[1][12] = page_totals[1][12] + evaluate("used_ship_amount_new_#SHIP_ID#_#STOCK_ID#")>
								</cfif>
								</td>
								<td style="text-align:right;" nowrap="nowrap" format="numeric"><!--- iade irsaliyesi urunlerin maliyeti --->
								<cfif isdefined('used_ship_cost_#SHIP_ID#_#STOCK_ID#') and len(evaluate('used_ship_cost_#SHIP_ID#_#STOCK_ID#'))>
									#TLFormat(evaluate('used_ship_cost_#SHIP_ID#_#STOCK_ID#'))# 
									<cfset page_totals[1][13] = page_totals[1][13] + evaluate("used_ship_cost_#SHIP_ID#_#STOCK_ID#")>
								</cfif>
								</td>
								<td style="text-align:center;">
								<cfif isdefined('used_ship_cost_#SHIP_ID#_#STOCK_ID#') and len(evaluate('used_ship_cost_#SHIP_ID#_#STOCK_ID#'))>
									#session.ep.money#
								</cfif>
								</td>
								<td>
								<cfif isdefined('to_ship_number_list_#SHIP_ID#_#STOCK_ID#') and len(evaluate('to_ship_number_list_#SHIP_ID#_#STOCK_ID#'))>
									#evaluate('to_ship_number_list_#SHIP_ID#_#STOCK_ID#')#
								</cfif>
								</td>
								<cfif attributes.invoice_action neq 2>
									<td style="text-align:right;" nowrap="nowrap" format="numeric"><!--- Faturalanan miktar --->
									
									<cfif isdefined('used_inv_amount_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#') and len(evaluate('used_inv_amount_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#'))>
										#TLFormat(evaluate('used_inv_amount_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#'))#
										<cfset page_totals[1][14] = page_totals[1][14] + evaluate("used_inv_amount_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#")>
									</cfif>
									</td>
									<td style="text-align:right;" nowrap="nowrap" format="numeric"><!--- Faturalanan miktarın maliyeti --->
									<cfif isdefined('used_inv_cost_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#') and len(evaluate('used_inv_cost_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#'))>
										#TLFormat(evaluate('used_inv_cost_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#'))#
										<cfset page_totals[1][15] = page_totals[1][15] + evaluate("used_inv_cost_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#")>
									</cfif>
									</td>
									<td style="text-align:center;">
									<cfif isdefined('used_inv_cost_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#') and len(evaluate('used_inv_cost_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#'))>
										#session.ep.money#
									</cfif>
									</td>
									<td>
									<cfif isdefined('to_inv_number_list_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#') and len(evaluate('to_inv_number_list_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#'))>
										#evaluate('to_inv_number_list_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#')#
									</cfif>
									</td>
								</cfif>
							<cfelse>
								<td style="text-align:right;" nowrap="nowrap" format="numeric"><!--- iade irsaliyesine cekilen urunlerin miktarı --->
									#TLFormat(ship_amount)#
									<cfset page_totals[1][12] = page_totals[1][12] +ship_amount>
								</td>
								<td style="text-align:right;" nowrap="nowrap" format="numeric"><!--- iade irsaliyesi urunlerin maliyeti --->
									#TLFormat(ship_cost)# 
									<cfset page_totals[1][13] = page_totals[1][13] + ship_cost>
								</td>
								<td style="text-align:center;">
									#session.ep.money#
								</td>
								<td>
									#ship_number_list#
								</td>
								<cfif attributes.invoice_action neq 2>
									<td style="text-align:right;" nowrap="nowrap" format="numeric"><!--- Faturalanan miktar --->
										#TLFormat(inv_amount)#
										<cfset page_totals[1][14] = page_totals[1][14] + inv_amount>
									</td>
									<td style="text-align:right;" nowrap="nowrap" format="numeric"><!--- Faturalanan miktarın maliyeti --->
										#TLFormat(inv_cost)#
										<cfset page_totals[1][15] = page_totals[1][15] + inv_cost>
									</td>
									<td style="text-align:center;">
										#session.ep.money#
									</td>
									<td>
										#invoice_number_list#
									</td>	
								</cfif>
							</cfif>
							<td style="text-align:right;" nowrap="nowrap" format="numeric">
								#TLFormat(consigment_dept_amount_)#
								<cfset page_totals[1][16] = page_totals[1][16] + consigment_dept_amount_>
							</td>
							<td style="text-align:right;" nowrap="nowrap" format="numeric">
								<cfif len(ALL_PRODUCT_COST)>
									#TLFormat(consigment_dept_amount_*(ALL_PRODUCT_COST))# 
									<cfset page_totals[1][17] = page_totals[1][17] + (consigment_dept_amount_*(ALL_PRODUCT_COST))>
								</cfif>
							</td>
							<td style="text-align:center;">
							<cfif len(ALL_PRODUCT_COST)>
								#session.ep.money#
							</cfif>
							</td>
							<cfif attributes.invoice_action neq 2 and attributes.is_month_based_ eq 1>
								<!--- belge bazında raporlamada ay bazında faturalama bilgileri listeleniyor --->
								<cfif isdefined("attributes.is_pre_ships")>
									<td style="text-align:right;" nowrap="nowrap" format="numeric">#TLFormat(inv_amount)#</td>
									<td style="text-align:right;" nowrap="nowrap" format="numeric">#TLFormat(inv_cost)#</td>
									<td>#invoice_number_list#</td>
								</cfif>
								<cfloop from="0" to="#month_count_#" index="month_hh">
									<cfset start_date=dateformat(date_add('m',month_hh,attributes.date1),'mm/yyyy')>
									<cfset temp_month_=month(start_date)>
									<cfset temp_year_=year(start_date)>
									<cfif type eq 1><!--- eğer devirden gelmiyorsa --->
										<td style="text-align:right;" nowrap="nowrap" format="numeric"><!--- Faturalanan miktar --->
										<cfif isdefined('used_inv_amount_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#_#temp_year_#_#temp_month_#') and len(evaluate('used_inv_amount_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#_#temp_year_#_#temp_month_#'))>
											#TLFormat(evaluate('used_inv_amount_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#_#temp_year_#_#temp_month_#'))#
										</cfif>
										</td>
										<td style="text-align:right;" nowrap="nowrap" format="numeric"><!--- Faturalanan miktarın maliyeti --->
										<cfif isdefined('used_inv_cost_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#_#temp_year_#_#temp_month_#') and len(evaluate('used_inv_cost_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#_#temp_year_#_#temp_month_#'))>
											#TLFormat(evaluate('used_inv_cost_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#_#temp_year_#_#temp_month_#'))# 
										</cfif>
										</td>
										<td>
										<cfif isdefined('to_inv_number_list_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#_#temp_year_#_#temp_month_#') and len(evaluate('to_inv_number_list_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#_#temp_year_#_#temp_month_#'))>
											#evaluate('to_inv_number_list_#SHIP_PERIOD#_#SHIP_ID#_#STOCK_ID#_#temp_year_#_#temp_month_#')#
										</cfif>
										</td>
									<cfelse>
										<td style="text-align:right;" nowrap="nowrap">0</td>
										<td style="text-align:right;" nowrap="nowrap">0</td>
										<td></td>
									</cfif>
								</cfloop>
							</cfif>
						</tr>
                        </tbody>
					</cfif>
				</cfif>
			</cfoutput>
			<cfif (isdefined('attributes.export_to_table') and attributes.export_to_table eq 1) and GET_ALL_SHIP.recordcount gte (attributes.startrow+attributes.maxrows)>
					<cfoutput>
					<cfset attributes.page = attributes.page+1>
					<cfset oran = 'Yuzde:#tlformat(((attributes.startrow+attributes.maxrows)*100)/GET_ALL_SHIP.recordcount)#'>
					<cfset newUrlAdr = '#request.self#?fuseaction=#fusebox.circuit#.consigment_analyse_report&oran=#oran#'>
					<cfset newUrlStrList =StructKeyList(attributes,',')>
					<cfloop list="#newUrlStrList#" index="pageVar">
						<cfif pageVar neq 'fuseaction' and pageVar neq 'startrow'>
							<cfif pageVar is 'date1'>
								<cfset attributes.date1 = '#dateformat(attributes.date1,dateformat_style)#'>
							</cfif>
							<cfif pageVar is 'date2'>
								<cfset attributes.date2 = '#dateformat(attributes.date2,dateformat_style)#'>
							</cfif>
							<cfset newUrlAdr = '#newUrlAdr#&#pageVar#=#Evaluate("attributes.#pageVar#")#'>
						</cfif>
					</cfloop>
					<script type="text/javascript">
						document.frm_search.action ="#newUrlAdr#";
						document.frm_search.submit();
					</script>
					</cfoutput>
			</cfif>
			<cfif (isdefined('attributes.export_to_table') and attributes.export_to_table eq 1)>
				<script type="text/javascript">
					alert('Tabloya Aktarma İşlemi Tamamlandı!');
				</script>
					<cfoutput>
						<tr>
							 <td height="20" colspan="25"><cf_get_lang dictionary_id ='40602.Tabloya Aktarım Tamamlandı'></td>
						</tr>
					</cfoutput>
			</cfif>
			<cfif not (isdefined('attributes.export_to_table') and attributes.export_to_table eq 1)>
				<cfoutput>	
                <tbody>
					<tr>
						<td class="txtbold" style="text-align:right;" colspan="10"><cf_get_lang dictionary_id ='39183.Sayfa Toplam'></td>
						<td style="text-align:right;" format="numeric">#TLFormat(page_totals[1][9])#</td>
						<td style="text-align:right;" format="numeric">#TLFormat(page_totals[1][10])#</td>
						<td style="text-align:right;" format="numeric">#TLFormat(page_totals[1][11])#</td>
						<td></td>
						<td style="text-align:right;" format="numeric">#TLFormat(page_totals[1][12])#</td>
						<td style="text-align:right;" format="numeric">#TLFormat(page_totals[1][13])#</td>
						<td></td>
						<td></td>
						<td style="text-align:right;"></td>
						<td style="text-align:right;"></td>
						<td></td>
						<td></td>
						<td style="text-align:right;" format="numeric">#TLFormat(page_totals[1][16])#</td>
						<td style="text-align:right;"></td>
						<td></td>
						<cfif attributes.invoice_action neq 2 and attributes.is_month_based_ eq 1>
							<!--- belge bazında raporlamada ay bazında faturalama bilgileri listeleniyor --->
							<cfif isdefined("attributes.is_pre_ships")>
								<td></td>
								<td></td>
								<td></td>
							</cfif>
							<cfloop from="0" to="#month_count_#" index="month_nn">
								<td></td>
								<td></td>
								<td></td>
							</cfloop>
						</cfif>
					</tr>
                </tbody>
				</cfoutput>
			</cfif>
		<cfelseif attributes.report_type eq 1><!--- Stok Bazinda --->
			<cfif isdefined('attributes.is_excel') and listfind('1,2',attributes.is_excel,',')>
				<cfset attributes.startrow=1>
				<cfset attributes.maxrows=GET_PROD_RESULTS.recordcount>
			</cfif>
			<cfset inv_stock_id_list = ''>
			<cfset inv_product_id_list = ''>
			<cfoutput query="GET_PROD_RESULTS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfscript>
					//konsinye giris miktarları set ediliyor
					for(kkk=1; kkk lte GET_PROD_IN.recordcount; kkk=kkk+1)
					{
						if(GET_PROD_IN.STOCK_ID[kkk] eq GET_PROD_RESULTS.STOCK_ID) 
						{
							'prod_consigment_in_#GET_PROD_RESULTS.STOCK_ID#' = GET_PROD_IN.AMOUNT[kkk];
							'prod_consigment_in_cost_#GET_PROD_RESULTS.STOCK_ID#' = GET_PROD_IN.TOTAL_COST[kkk];
							break;
						}
					}
					for(xxx=1; xxx lte GET_PROD_OUT.recordcount; xxx=xxx+1)
					{//konsinye cıkıs miktarları set ediliyor
						if(GET_PROD_OUT.STOCK_ID[xxx] eq GET_PROD_RESULTS.STOCK_ID) 
						{
							'prod_consigment_out_#GET_PROD_RESULTS.STOCK_ID#' = GET_PROD_OUT.AMOUNT[xxx];
							'prod_consigment_out_cost_#GET_PROD_RESULTS.STOCK_ID#' = GET_PROD_OUT.TOTAL_COST[xxx];
							break;
						}
					}
					if(not listfind(inv_stock_id_list,GET_PROD_RESULTS.STOCK_ID))
						inv_stock_id_list = listappend(inv_stock_id_list,GET_PROD_RESULTS.STOCK_ID,',');
				
					if(not listfind(inv_product_id_list,GET_PROD_RESULTS.PRODUCT_ID)) //maliyetler icin kullanılıyor
						inv_product_id_list = listappend(inv_product_id_list,GET_PROD_RESULTS.PRODUCT_ID,',');
				</cfscript>
			</cfoutput>
			<cfif listlen(inv_stock_id_list)>
				<cfset inv_stock_id_list=listsort(inv_stock_id_list,"numeric","ASC",",")>
				<cfquery name="GET_ALL_PRODUCT_COST" datasource="#dsn3#"> <!---sadece listelenecek urunlerin bitis tarihine gore maliyetleri alınıyor  --->
					SELECT 
						PRODUCT_ID, 
						PRODUCT_COST_ID,
						PURCHASE_NET_ALL PURCHASE_NET, 
						PURCHASE_EXTRA_COST, 
						PURCHASE_NET_MONEY ,
						START_DATE,
						RECORD_DATE,
						PURCHASE_NET_SYSTEM_ALL PURCHASE_NET_SYSTEM,
						PURCHASE_NET_SYSTEM_MONEY,
						PURCHASE_EXTRA_COST_SYSTEM
					FROM 
						PRODUCT_COST
					WHERE 
						START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
						AND ACTION_PERIOD_ID IN (#new_period_id_list_#)
						AND PRODUCT_ID IN (#inv_product_id_list#)
						ORDER BY PRODUCT_ID, RECORD_DATE DESC, START_DATE DESC,PRODUCT_COST_ID DESC
				</cfquery>
				<cfquery name="GET_PROD_INV_AMOUNT" datasource="#dsn#">
					SELECT
						SUM(AMOUNT) AS AMOUNT,
						SUM(INV_TOTAL_COST*AMOUNT) AS INV_TOTAL_COST,
						STOCK_ID
					FROM
					(
					<cfset active_period_ = 0>
					<cfloop query="get_all_periods">
						<cfset active_period_ = active_period_ + 1>
							SELECT
								AMOUNT,
								YEAR(INVOICE_DATE) AS INVOICE_YEAR,
								PRODUCT_ID,
								STOCK_ID,
								SRR.TO_INVOICE_ID,
								SRR.TO_INVOICE_CAT,
								INV.INVOICE_NUMBER AS TO_INVOICE_NUMBER,
								SRR.SHIP_ID,
								SRR.SHIP_PERIOD,
								ISNULL((SELECT
									TOP 1 (PURCHASE_NET_SYSTEM + PURCHASE_EXTRA_COST_SYSTEM)  
								FROM 
									#dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.GET_PRODUCT_COST_PERIOD GPCP
								WHERE
									GPCP.START_DATE <= INV.INVOICE_DATE
									AND GPCP.PRODUCT_ID = SRR.PRODUCT_ID
								ORDER BY GPCP.START_DATE DESC,GPCP.RECORD_DATE DESC, GPCP.PURCHASE_NET_SYSTEM DESC
									),0) AS INV_TOTAL_COST							
							FROM
								#dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.SHIP_ROW_RELATION SRR,
								#dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.INVOICE INV,
								#dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.SHIP S
							WHERE
								SRR.STOCK_ID IN (#inv_stock_id_list#)
								AND SRR.TO_INVOICE_ID =INV.INVOICE_ID
								AND SRR.TO_INVOICE_CAT = INV.INVOICE_CAT
								AND INV.PURCHASE_SALES = 1		
								AND SRR.SHIP_ID = S.SHIP_ID
								AND S.SHIP_ID  IN(SELECT SR.UPD_ID FROM #dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.STOCKS_ROW SR WHERE SR.PROCESS_TYPE = S.SHIP_TYPE AND SR.UPD_ID = S.SHIP_ID)				
								AND INV.INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
								AND SHIP_PERIOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_all_periods.period_id#">
								<cfif len(attributes.process_type)>
									AND S.PROCESS_CAT IN (#attributes.process_type#)
								<cfelse>
									AND S.SHIP_TYPE IN (72,75,77,79) <!--- sadece konsinye tipindeki irsaliyeleri alması icin --->
								</cfif>
								<cfif len(attributes.project_id) and len(attributes.project_head)>
									AND INV.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
								</cfif>
								<cfif isdefined("attributes.member_cat_type") and listlen(attributes.member_cat_type,'-') eq 2 and listfirst(attributes.member_cat_type,'-') is '1'>
									AND INV.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANYCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.member_cat_type,'-')#">)
								</cfif>
								<cfif isdefined("attributes.member_cat_type") and listlen(attributes.member_cat_type,'-') eq 2 and listfirst(attributes.member_cat_type,'-') is '2'>
									AND INV.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER WHERE CONSUMER_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.member_cat_type,'-')#">)
								</cfif>
								<cfif len(attributes.consumer_id) and attributes.consumer_id gt 0 and Len(attributes.consumer_name)>
									AND INV.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
								</cfif>
								<cfif len(attributes.company_id) and attributes.company_id gt 0 and Len(attributes.company)>
									AND INV.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
								</cfif>
								<cfif len(attributes.sales_employee_id) and Len(attributes.sales_employee_name)>
									AND INV.SALE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_employee_id#">
								</cfif>
								<cfif len(attributes.stock_id) and len(attributes.product_name)>
									AND SRR.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
								</cfif>
								AND SRR.TO_INVOICE_ID IS NOT NULL
							<cfif isdefined('list_period_years') and listfind(list_period_years,(get_all_periods.PERIOD_YEAR+1))>
							UNION ALL
							SELECT
								AMOUNT,
								YEAR(INVOICE_DATE) AS INVOICE_YEAR,
								PRODUCT_ID,
								STOCK_ID,
								SRR.TO_INVOICE_ID,
								SRR.TO_INVOICE_CAT,
								INV.INVOICE_NUMBER AS TO_INVOICE_NUMBER,
								SRR.SHIP_ID,
								SRR.SHIP_PERIOD,
								ISNULL((SELECT
									TOP 1 (PURCHASE_NET_SYSTEM + PURCHASE_EXTRA_COST_SYSTEM)  
								FROM 
									#dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.GET_PRODUCT_COST_PERIOD GPCP
								WHERE
									GPCP.START_DATE <= INV.INVOICE_DATE
									AND GPCP.PRODUCT_ID = SRR.PRODUCT_ID
								ORDER BY GPCP.START_DATE DESC,GPCP.RECORD_DATE DESC, GPCP.PURCHASE_NET_SYSTEM DESC
									),0) AS INV_TOTAL_COST							
							FROM
								#dsn#_#get_all_periods.PERIOD_YEAR+1#_#get_all_periods.OUR_COMPANY_ID#.SHIP_ROW_RELATION SRR,
								#dsn#_#get_all_periods.PERIOD_YEAR+1#_#get_all_periods.OUR_COMPANY_ID#.INVOICE INV,
								#dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.SHIP S
							WHERE
								SRR.STOCK_ID IN (#inv_stock_id_list#)
								AND SRR.TO_INVOICE_ID =INV.INVOICE_ID
								AND SRR.TO_INVOICE_CAT = INV.INVOICE_CAT
								AND INV.PURCHASE_SALES = 1		
								AND SRR.SHIP_ID = S.SHIP_ID
								AND S.SHIP_ID  IN(SELECT SR.UPD_ID FROM #dsn#_#get_all_periods.PERIOD_YEAR#_#get_all_periods.OUR_COMPANY_ID#.STOCKS_ROW SR WHERE SR.PROCESS_TYPE = S.SHIP_TYPE AND SR.UPD_ID = S.SHIP_ID)				
								AND INV.INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
								AND SHIP_PERIOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_all_periods.period_id#">
								<cfif len(attributes.process_type)>
									AND S.PROCESS_CAT IN (#attributes.process_type#)
								<cfelse>
									AND S.SHIP_TYPE IN (72,75,77,79) <!--- sadece konsinye tipindeki irsaliyeleri alması icin --->
								</cfif>
								<cfif len(attributes.project_id) and len(attributes.project_head)>
									AND INV.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
								</cfif>
								<cfif isdefined("attributes.member_cat_type") and listlen(attributes.member_cat_type,'-') eq 2 and listfirst(attributes.member_cat_type,'-') is '1'>
									AND INV.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE COMPANYCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.member_cat_type,'-')#">)
								</cfif>
								<cfif isdefined("attributes.member_cat_type") and listlen(attributes.member_cat_type,'-') eq 2 and listfirst(attributes.member_cat_type,'-') is '2'>
									AND INV.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER WHERE CONSUMER_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.member_cat_type,'-')#">)
								</cfif>
								<cfif len(attributes.consumer_id) and attributes.consumer_id gt 0 and Len(attributes.consumer_name)>
									AND INV.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
								</cfif>
								<cfif len(attributes.company_id) and attributes.company_id gt 0 and Len(attributes.company)>
									AND INV.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
								</cfif>
								<cfif len(attributes.sales_employee_id) and Len(attributes.sales_employee_name)>
									AND INV.SALE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_employee_id#">
								</cfif>
								<cfif len(attributes.stock_id) and len(attributes.product_name)>
									AND SRR.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
								</cfif>
								AND SRR.TO_INVOICE_ID IS NOT NULL
							</cfif>
							<cfif active_period_ neq get_all_periods.recordcount>UNION ALL</cfif>
					</cfloop>
					) AS A1
						GROUP BY
							STOCK_ID
				</cfquery>
				<cfoutput query="GET_PROD_RESULTS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfscript>
						//konsinye giris miktarları set ediliyor
						for(nnn=1; nnn lte GET_PROD_INV_AMOUNT.recordcount; nnn=nnn+1)
						{
							if(GET_PROD_INV_AMOUNT.STOCK_ID[nnn] eq GET_PROD_RESULTS.STOCK_ID) 
							{
								'prod_inv_amount_#GET_PROD_RESULTS.STOCK_ID#' = GET_PROD_INV_AMOUNT.AMOUNT[nnn];
								'prod_inv_amount_cost_#GET_PROD_RESULTS.STOCK_ID#' = GET_PROD_INV_AMOUNT.INV_TOTAL_COST[nnn];
								break;
							}
						}
					</cfscript>
				</cfoutput>
			</cfif>
			<cfoutput query="GET_PROD_RESULTS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<cfset consigment_prod_amount_ = 0>
            <cfif isdefined('prod_consigment_in_#STOCK_ID#') and len(evaluate('prod_consigment_in_#STOCK_ID#'))>
				<cfset consigment_prod_amount_ = consigment_prod_amount_ - evaluate('prod_consigment_in_#STOCK_ID#')> 
            </cfif>
            <cfif isdefined('prod_inv_amount_#STOCK_ID#') and len(evaluate('prod_inv_amount_#STOCK_ID#'))>
				<cfset consigment_prod_amount_ = consigment_prod_amount_ - evaluate('prod_inv_amount_#STOCK_ID#')>
            </cfif>
            <cfif consigment_prod_amount_ neq 0>
            <tbody>
			<tr>
				<td>#product_cat#</td>
				<td>#stock_code#</td>
				<td>#product_name#<cfif len(property)> - #property#</cfif></td>
				<td>
				<cfif len(BRAND_ID)>
					<cfquery name="get_mark_names" datasource="#dsn1#">
						SELECT * FROM PRODUCT_BRANDS WHERE BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#BRAND_ID#"> ORDER BY BRAND_NAME
					</cfquery>
					#get_mark_names.brand_name#
				</cfif>
				</td>
				<td style="text-align:right;" nowrap="nowrap" format="numeric">
					<cfif isdefined('prod_consigment_out_#STOCK_ID#') and len(evaluate('prod_consigment_out_#STOCK_ID#'))>
					<cfset consigment_prod_amount_ = consigment_prod_amount_ + evaluate('prod_consigment_out_#STOCK_ID#')>
					#TLFormat(evaluate('prod_consigment_out_#STOCK_ID#'))#
					<cfset page_totals[1][1] = page_totals[1][1] + evaluate("prod_consigment_out_#STOCK_ID#")>
					</cfif>
				</td>
				<td style="text-align:right;" nowrap="nowrap" format="numeric">
				<cfif isdefined('prod_consigment_out_cost_#STOCK_ID#') and len(evaluate('prod_consigment_out_cost_#STOCK_ID#'))>
					#TLFormat(evaluate('prod_consigment_out_cost_#STOCK_ID#'))# 
					<cfset page_totals[1][2] = page_totals[1][2] + evaluate("prod_consigment_out_cost_#STOCK_ID#")>
				</cfif>
				</td>
				<td style="text-align:center;" nowrap="nowrap">
				<cfif isdefined('prod_consigment_out_cost_#STOCK_ID#') and len(evaluate('prod_consigment_out_cost_#STOCK_ID#'))>
					#session.ep.money#
				</cfif>
				</td>
				<cfif isdefined("attributes.is_pre_ships")>
					<td style="text-align:right;" nowrap="nowrap" format="numeric">
						#TLFormat(SHIP_AMOUNT)#
						<cfset consigment_prod_amount_ = consigment_prod_amount_ - SHIP_AMOUNT>
					</td>
					<td style="text-align:right;" nowrap="nowrap" format="numeric">
						#TLFormat(SHIP_COST)#
					</td>
					<td style="text-align:center;">
						#session.ep.money#
					</td>
					<td style="text-align:right;" nowrap="nowrap" format="numeric">
						#TLFormat(INV_AMOUNT)#
						<cfset consigment_prod_amount_ = consigment_prod_amount_ - INV_AMOUNT>
					</td>
					<td style="text-align:right;" nowrap="nowrap" format="numeric">
						#TLFormat(INV_COST)#
					</td>
					<td style="text-align:center;">
						#session.ep.money#
					</td>
					<td style="text-align:right;" nowrap="nowrap" format="numeric">
						#TLFormat(consigment_prod_amount_)#
						<cfset page_totals[1][7] = page_totals[1][7] + consigment_prod_amount_>
					</td>
					<td style="text-align:right;" nowrap="nowrap" format="numeric">
					<cfif len(ALL_PRODUCT_COST)>
						#TLFormat(consigment_prod_amount_*ALL_PRODUCT_COST)# 
						<cfset page_totals[1][8] = page_totals[1][8] + (consigment_prod_amount_*ALL_PRODUCT_COST)>
					</cfif>
					</td>
					<td>
						<cfif len(ALL_PRODUCT_COST)>
							#session.ep.money#
						</cfif>
					</td>
				<cfelse>
					<td style="text-align:right;" nowrap="nowrap" format="numeric">
					<cfif isdefined('prod_consigment_in_#STOCK_ID#') and len(evaluate('prod_consigment_in_#STOCK_ID#'))>
						#TLFormat(evaluate('prod_consigment_in_#STOCK_ID#'))#
						<cfset page_totals[1][3] = page_totals[1][3] + evaluate("prod_consigment_in_#STOCK_ID#")>
					</cfif>
					</td>
					<td style="text-align:right;" nowrap="nowrap" format="numeric">
					<cfif isdefined('prod_consigment_in_cost_#STOCK_ID#') and len(evaluate('prod_consigment_in_cost_#STOCK_ID#'))>
						#TLFormat(evaluate('prod_consigment_in_cost_#STOCK_ID#'))# 
						<cfset page_totals[1][4] = page_totals[1][4] + evaluate("prod_consigment_in_cost_#STOCK_ID#")>
					</cfif>
					</td>
					<td style="text-align:center;"><cfif isdefined('prod_consigment_in_cost_#STOCK_ID#') and len(evaluate('prod_consigment_in_cost_#STOCK_ID#'))>
					#session.ep.money#
					</cfif>
					</td>
					<td style="text-align:right;" nowrap="nowrap" format="numeric">
					<cfif isdefined('prod_inv_amount_#STOCK_ID#') and len(evaluate('prod_inv_amount_#STOCK_ID#'))>
						#TLFormat(evaluate('prod_inv_amount_#STOCK_ID#'))#
						<cfset page_totals[1][5] = page_totals[1][5] + evaluate("prod_inv_amount_#STOCK_ID#")>
					</cfif>
					</td>
					<td style="text-align:right;" nowrap="nowrap" format="numeric">
					<cfif isdefined('prod_inv_amount_cost_#STOCK_ID#') and len(evaluate('prod_inv_amount_cost_#STOCK_ID#'))>
						#TLFormat(evaluate('prod_inv_amount_cost_#STOCK_ID#'))#
						<cfset page_totals[1][6] = page_totals[1][6] + evaluate("prod_inv_amount_cost_#STOCK_ID#")>
					</cfif>
					</td>
					<td style="text-align:center;">
						<cfif isdefined('prod_inv_amount_cost_#STOCK_ID#') and len(evaluate('prod_inv_amount_cost_#STOCK_ID#'))>
							#session.ep.money#
						</cfif>
					</td>
					<td style="text-align:right;" nowrap="nowrap" format="numeric">
						#TLFormat(consigment_prod_amount_)#
						<cfset page_totals[1][7] = page_totals[1][7] + consigment_prod_amount_>
					</td>
					<td style="text-align:right;" nowrap="nowrap" format="numeric">
					<cfif len(ALL_PRODUCT_COST)>
						#TLFormat(consigment_prod_amount_*ALL_PRODUCT_COST)# 
						<cfset page_totals[1][8] = page_totals[1][8] + (consigment_prod_amount_*ALL_PRODUCT_COST)>
					</cfif>
					</td>
					<td>
						<cfif len(ALL_PRODUCT_COST)>
							#session.ep.money#
						</cfif>
					</td>
				</cfif>
			</tr>
            </tbody>
            </cfif>
			</cfoutput>
			<cfoutput>
            <tbody>
			<tr>
				<td class="txtbold" style="text-align:right;" colspan="4"><cf_get_lang dictionary_id ='39183.Sayfa Toplam'></td>
				<td style="text-align:right;" format="numeric">#TLFormat(page_totals[1][1])#</td>
				<td style="text-align:right;" format="numeric">#TLFormat(page_totals[1][2])#</td>
				<td></td>
				<td style="text-align:right;" format="numeric">#TLFormat(page_totals[1][3])#</td>
				<td style="text-align:right;" format="numeric">#TLFormat(page_totals[1][4])#</td>
				<td></td>
				<td style="text-align:right;" format="numeric">#TLFormat(page_totals[1][5])#</td>
				<td style="text-align:right;" format="numeric">#TLFormat(page_totals[1][6])#</td>
				<td></td>
				<td style="text-align:right;" format="numeric">#TLFormat(page_totals[1][7])#</td>
				<td style="text-align:right;" format="numeric">#TLFormat(page_totals[1][8])#</td>
				<td></td>
			</tr>
            </tbody>
		</cfoutput>
	</cfif>
   <cfelse>
		<cfoutput> 
        <tbody>
			<tr>
				<td colspan="35"><cfif isdefined("attributes.is_form_submitted") and len(attributes.is_form_submitted)><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id ='57701.Filtre Ediniz'>!</cfif></td>
			</tr>
         </tbody>
		</cfoutput>
   </cfif>
</cf_report_list>
</cfif>
<cfif not (isdefined('attributes.is_excel') and listfind('1,2',attributes.is_excel,','))>
	<cfif attributes.totalrecords gt attributes.maxrows>
		<cfset adres = "#fusebox.circuit#.consigment_analyse_report">
		<cfif isdefined("attributes.is_form_submitted") and len(attributes.is_form_submitted)> 
			<cfset adres = "#adres#&is_form_submitted=1">
		</cfif>
		<cfif len(attributes.process_type)>
		  <cfset adres = adres & "&process_type=#attributes.process_type#">
		</cfif>
		<cfif len(attributes.belge_no)>
		  <cfset adres = adres & "&belge_no=#attributes.belge_no#">
		</cfif>
		<cfif isDefined('attributes.is_pre_ships') and len(attributes.is_pre_ships) >
		  <cfset adres = adres & '&is_pre_ships=#attributes.is_pre_ships#'>
		</cfif>
		<cfif len(attributes.oby)>
		  <cfset adres = adres & '&oby=#attributes.oby#'>
		</cfif>
		<cfif len(attributes.invoice_action)>
			<cfset adres = adres &'&invoice_action=#attributes.invoice_action#'>
		</cfif> 
		<cfif len(attributes.department_id) >
		  <cfset adres = adres & '&department_id=#attributes.department_id#'>
		</cfif>
		<cfif len(attributes.consumer_id) and Len(attributes.consumer_name)>
		  <cfset adres = adres & '&consumer_id=#attributes.consumer_id#&consumer_name=#attributes.consumer_name#'>
		</cfif>
		<cfif len(attributes.company_id) and Len(attributes.company)>
		  <cfset adres = adres & '&company_id=#attributes.company_id#&company=#attributes.company#'>
		</cfif>
		<cfif len(attributes.sales_employee_id) and Len(attributes.sales_employee_name)>
		  <cfset adres = adres & '&sales_employee_id=#attributes.sales_employee_id#&sales_employee_name=#attributes.sales_employee_name#'>
		</cfif>
		<cfif len(attributes.stock_id) and len(attributes.product_name)>
			<cfset adres = "#adres#&stock_id=#attributes.stock_id#&product_name=#attributes.product_name#">
		</cfif>
		<cfif isdate(attributes.date1)>
			<cfset adres = "#adres#&date1=#dateformat(attributes.date1,dateformat_style)#">
		</cfif>
		<cfif isdate(attributes.date2)>
			<cfset adres = "#adres#&date2=#dateformat(attributes.date2,dateformat_style)#">
		</cfif>
		<cfif len(attributes.member_cat_type)>
			<cfset adres = adres&'&member_cat_type=#attributes.member_cat_type#'>
	   </cfif>
		<cfif isdefined("attributes.report_type") and len(attributes.report_type)>
			<cfset adres = "#adres#&report_type=#attributes.report_type#" >
		</cfif>
		<cfif len(attributes.project_id) and len(attributes.project_head)>
			<cfset adres = "#adres#&project_id=#attributes.project_id#&project_head=#attributes.project_head#">
		</cfif>
		<cfif len(attributes.search_product_catid) and len(attributes.product_cat)>
			<cfset adres = "#adres#&search_product_catid=#attributes.search_product_catid#&product_cat=#attributes.product_cat#">
		</cfif>
		<cfif isDefined('attributes.is_month_based_') and len(attributes.is_month_based_)>
			<cfset adres = "#adres#&is_month_based_=#attributes.is_month_based_#">
		</cfif>
		<cfif len(attributes.brand_id) and len(attributes.brand_name)>
			<cfset adres = "#adres#&brand_id=#attributes.brand_id#&brand_name=#attributes.brand_name#">
		</cfif>
        <cfif isdefined("attributes.control_bakiye") and len(attributes.control_bakiye)>
			<cfset adres = "#adres#&control_bakiye=#attributes.control_bakiye#" >
		</cfif>		
				<cf_paging page="#attributes.page#" 
					maxrows="#attributes.maxrows#" 
					totalrecords="#attributes.totalrecords#" 
					startrow="#attributes.startrow#" 
					adres="#adres#"> 
	</cfif>
	<br/>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
<script type="text/javascript">
	function kontrol()
	{
		if ((document.frm_search.date1.value != '') && (document.frm_search.date2.value != '') &&
	    !date_check(frm_search.date1,frm_search.date2,"<cf_get_lang dictionary_id ='39814.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
	         return false;
		 if(document.frm_search.is_excel.checked==false)
			{
				document.frm_search.action="<cfoutput>#request.self#?fuseaction=report.consigment_analyse_report</cfoutput>";
				return true;
			
			}
			else
			{
					document.frm_search.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_consigment_analyse_report</cfoutput>";
			}
	}
</script>