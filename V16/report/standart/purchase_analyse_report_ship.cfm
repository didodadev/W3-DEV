<cfsetting showdebugoutput="yes">
<cfparam name="attributes.module_id_control" default="20,12">
<cfinclude template="report_authority_control.cfm">
<cf_xml_page_edit fuseact="report.purchase_analyse_report_ship">
<cf_get_lang_set module_name="report">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.invoice_action" default=''>
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.max_rows" default="20">
<cfparam name="attributes.process_type" default="">
<cfparam name="attributes.report_sort" default="1">
<cfparam name="attributes.product_employee_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.total_event" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.hierarcy" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.department_name" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.search_product_catid" default="">
<cfparam name="attributes.is_money2" default="0">
<cfparam name="attributes.is_stock_active" default="1">
<cfparam name="attributes.stock_status_level" default="">
<cfparam name="attributes.date1" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.date2" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.report_type" default="">
<cfparam name="attributes.kdv_dahil" default="">
<cfparam name="attributes.kontrol_type" default="0">
<cfparam name="attributes.brand_name" default="">
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.model_name" default="">
<cfparam name="attributes.model_id" default="">
<cfparam name="attributes.is_other_money" default="0">
<cfparam name="attributes.is_project" default="">
<cfparam name="attributes.is_spect_info" default="">
<cfparam name="attributes.ship_address" default="">
<cfparam name="attributes.department_id_out" default="">
<cfparam name="attributes.department_name_out" default="">
<cf_date tarih='attributes.date1'>
<cf_date tarih='attributes.date2'>
<cfif attributes.is_other_money eq 1 and attributes.is_money2 eq 1>
	<cfset attributes.is_money2 = 0>
</cfif>
<cfquery name="GET_DEPARTMENT" datasource="#DSN#">
	SELECT 
		D.DEPARTMENT_ID,
		D.DEPARTMENT_HEAD
	FROM
		BRANCH B,
		DEPARTMENT D
	WHERE
		B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		B.BRANCH_ID = D.BRANCH_ID AND
		D.IS_STORE <> 2 AND
	<cfif x_show_pasive_departments eq 0>
        D.DEPARTMENT_STATUS = 1 AND
    </cfif>
		B.BRANCH_ID IN(SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
	ORDER BY 
		DEPARTMENT_HEAD
</cfquery>
<cfset branch_dep_list=valuelist(get_department.department_id,',')><!--- Eğer depo seçilmeden çalıştırılırsa yine arka tarafta yetkili olduklarına bakacak --->
<cfif attributes.report_type eq 5>
	<cfset project_id_list=''>
	<cfquery name="get_project" datasource="#dsn#">
		SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS
	</cfquery>
	<cfset project_id_list = valuelist(get_project.project_id,',')>
</cfif>
<cfquery name="GET_ALL_LOCATION" datasource="#DSN#">
	SELECT DEPARTMENT_ID,LOCATION_ID,COMMENT FROM STOCKS_LOCATION <cfif x_show_pasive_departments eq 0>WHERE STATUS = 1</cfif>
</cfquery>
<cfquery name="get_money" datasource="#dsn2#">
	SELECT * FROM SETUP_MONEY
</cfquery>
<cfoutput query="get_money">
	<cfset "toplam_#money#" = 0>
</cfoutput>
<cfif isdefined("attributes.form_submitted")>
	<cfif len(attributes.department_id)>
		<cfset process_list = '73,74,75,76,77,80,81,811,761,82,84,86,87'>
	<cfelse>
		<cfset process_list = '73,74,75,76,77,80,761,82,84,86,87'>
	</cfif>
	<cfquery name="GET_TOTAL_PURCHASE_2"  datasource="#DSN2#">
		SELECT <!--- DISTINCT FBS 20111221 kaldirdi, burada distinct koymak dogru degil ayni olan kayitlari gostermiyor, gerekiyorsa baska bir cozume gidilmeli --->
			<cfif attributes.is_money2 eq 1 or attributes.is_other_money eq 1>
				<cfif attributes.report_type eq 3 or attributes.report_type eq 4>
					(((SR.AMOUNT*SR.PRICE*(100-SR.DISCOUNT)*(100-SR.DISCOUNT2)*(100-SR.DISCOUNT3)*(100-SR.DISCOUNT4)*(100-SR.DISCOUNT5))/10000000000)<cfif isdefined("attributes.kdv_dahil") and len(attributes.kdv_dahil)>+(((SR.AMOUNT*SR.PRICE*(100-SR.DISCOUNT)*(100-SR.DISCOUNT2)*(100-SR.DISCOUNT3)*(100-SR.DISCOUNT4)*(100-SR.DISCOUNT5))/10000000000)*SR.TAX/100)</cfif>) AS PRICE,
					CASE WHEN SM.ACTION_ID IS NOT NULL
					THEN
					((SR.AMOUNT*SR.PRICE*(100-SR.DISCOUNT)*(100-SR.DISCOUNT2)*(100-SR.DISCOUNT3)*(100-SR.DISCOUNT4)*(100-SR.DISCOUNT5))/10000000000)<cfif isdefined("attributes.kdv_dahil") and len(attributes.kdv_dahil)>+(((SR.AMOUNT*SR.PRICE*(100-SR.DISCOUNT)*(100-SR.DISCOUNT2)*(100-SR.DISCOUNT3)*(100-SR.DISCOUNT4)*(100-SR.DISCOUNT5))/10000000000)*SR.TAX/100)</cfif>/SM.RATE2
					ELSE
					((SR.AMOUNT*SR.PRICE*(100-SR.DISCOUNT)*(100-SR.DISCOUNT2)*(100-SR.DISCOUNT3)*(100-SR.DISCOUNT4)*(100-SR.DISCOUNT5))/10000000000)<cfif isdefined("attributes.kdv_dahil") and len(attributes.kdv_dahil)>+(((SR.AMOUNT*SR.PRICE*(100-SR.DISCOUNT)*(100-SR.DISCOUNT2)*(100-SR.DISCOUNT3)*(100-SR.DISCOUNT4)*(100-SR.DISCOUNT5))/10000000000)*SR.TAX/100)</cfif>/(SELECT IM.RATE2 FROM INVOICE_MONEY IM,INVOICE_SHIPS ISS WHERE IM.ACTION_ID = ISS.INVOICE_ID AND ISS.SHIP_ID = SR.SHIP_ID AND IM.MONEY_TYPE = SR.OTHER_MONEY)
					END AS PRICE_DOVIZ
				<cfelse>
					(((SR.AMOUNT*PU.MULTIPLIER*SR.PRICE*(100-SR.DISCOUNT)*(100-SR.DISCOUNT2)*(100-SR.DISCOUNT3)*(100-SR.DISCOUNT4)*(100-SR.DISCOUNT5))/10000000000)<cfif isdefined("attributes.kdv_dahil") and len(attributes.kdv_dahil)>+(((SR.AMOUNT*PU.MULTIPLIER*SR.PRICE*(100-SR.DISCOUNT)*(100-SR.DISCOUNT2)*(100-SR.DISCOUNT3)*(100-SR.DISCOUNT4)*(100-SR.DISCOUNT5))/10000000000)*SR.TAX/100)</cfif>) AS PRICE,	
					CASE WHEN SM.ACTION_ID IS NOT NULL
					THEN
					((SR.AMOUNT*PU.MULTIPLIER*SR.PRICE*(100-SR.DISCOUNT)*(100-SR.DISCOUNT2)*(100-SR.DISCOUNT3)*(100-SR.DISCOUNT4)*(100-SR.DISCOUNT5))/10000000000)<cfif isdefined("attributes.kdv_dahil") and len(attributes.kdv_dahil)>+(((SR.AMOUNT*PU.MULTIPLIER*SR.PRICE*(100-SR.DISCOUNT)*(100-SR.DISCOUNT2)*(100-SR.DISCOUNT3)*(100-SR.DISCOUNT4)*(100-SR.DISCOUNT5))/10000000000)*SR.TAX/100)</cfif>/SM.RATE2
					ELSE
					((SR.AMOUNT*PU.MULTIPLIER*SR.PRICE*(100-SR.DISCOUNT)*(100-SR.DISCOUNT2)*(100-SR.DISCOUNT3)*(100-SR.DISCOUNT4)*(100-SR.DISCOUNT5))/10000000000)<cfif isdefined("attributes.kdv_dahil") and len(attributes.kdv_dahil)>+(((SR.AMOUNT*PU.MULTIPLIER*SR.PRICE*(100-SR.DISCOUNT)*(100-SR.DISCOUNT2)*(100-SR.DISCOUNT3)*(100-SR.DISCOUNT4)*(100-SR.DISCOUNT5))/10000000000)*SR.TAX/100)</cfif>/ #dsn#.IS_ZERO((SELECT IM.RATE2 FROM INVOICE_MONEY IM,INVOICE_SHIPS ISS WHERE IM.ACTION_ID = ISS.INVOICE_ID AND ISS.SHIP_ID = SR.SHIP_ID AND IM.MONEY_TYPE = SR.OTHER_MONEY),1)
					END AS PRICE_DOVIZ
				</cfif>
			<cfelse>
				<cfif attributes.report_type eq 3 or attributes.report_type eq 4>
					(((SR.AMOUNT*SR.PRICE*(100-SR.DISCOUNT)*(100-SR.DISCOUNT2)*(100-SR.DISCOUNT3)*(100-SR.DISCOUNT4)*(100-SR.DISCOUNT5))/10000000000)<cfif isdefined("attributes.kdv_dahil") and len(attributes.kdv_dahil)>+(((SR.AMOUNT*SR.PRICE*(100-SR.DISCOUNT)*(100-SR.DISCOUNT2)*(100-SR.DISCOUNT3)*(100-SR.DISCOUNT4)*(100-SR.DISCOUNT5))/10000000000)*SR.TAX/100)</cfif>) AS PRICE
				<cfelse>
					(((SR.AMOUNT*PU.MULTIPLIER*SR.PRICE*(100-SR.DISCOUNT)*(100-SR.DISCOUNT2)*(100-SR.DISCOUNT3)*(100-SR.DISCOUNT4)*(100-SR.DISCOUNT5))/10000000000)<cfif isdefined("attributes.kdv_dahil") and len(attributes.kdv_dahil)>+(((SR.AMOUNT*PU.MULTIPLIER*SR.PRICE*(100-SR.DISCOUNT)*(100-SR.DISCOUNT2)*(100-SR.DISCOUNT3)*(100-SR.DISCOUNT4)*(100-SR.DISCOUNT5))/10000000000)*SR.TAX/100)</cfif>) AS PRICE		
				</cfif>
			</cfif>
			<cfif attributes.is_other_money eq 1>
				,SR.OTHER_MONEY 
			</cfif>
			<cfif attributes.report_type eq 1 or attributes.report_type eq 8>
			,PC.PRODUCT_CAT
			,PC.HIERARCHY
			,PC.PRODUCT_CATID
			,(SR.AMOUNT*PU.MULTIPLIER) AS PRODUCT_STOCK
            ,SR.SHIP_ROW_ID
			<cfelseif attributes.report_type eq 2>
			,PC.PRODUCT_CAT
			,PC.HIERARCHY
			,PC.PRODUCT_CATID
			,S.PRODUCT_ID
			,S.PRODUCT_NAME
			,S.BARCOD
			,S.PRODUCT_CODE
			,S.PRODUCT_MANAGER
			,(SR.AMOUNT*PU.MULTIPLIER) AS PRODUCT_STOCK
			,PU.MAIN_UNIT AS BIRIM
            ,SR.SHIP_ROW_ID
			<cfelseif attributes.report_type eq 3>
			,PC.PRODUCT_CAT
			,PC.HIERARCHY
			,PC.PRODUCT_CATID
			,S.PRODUCT_ID
			,S.PRODUCT_NAME
			,S.BARCOD
			,S.STOCK_CODE
			,S.PRODUCT_MANAGER
			,S.PROPERTY
			,SR.STOCK_ID
			,(SR.AMOUNT) PRODUCT_STOCK
			,SR.UNIT AS BIRIM
            ,SR.SHIP_ROW_ID
			<cfelseif attributes.report_type eq 4>
			,C.NICKNAME
			,C.COMPANY_ID
			,(SR.AMOUNT) PRODUCT_STOCK
            ,SR.SHIP_ROW_ID
			<cfelseif attributes.report_type eq 5>
			,CASE WHEN SHIP.COMPANY_ID IS NOT NULL THEN (SELECT C.OZEL_KOD_2 FROM #dsn#.COMPANY AS C WHERE C.COMPANY_ID = SHIP.COMPANY_ID) ELSE '' END AS OZEL_KOD_2
			,SHIP.SHIP_NUMBER
			,SHIP.DEPARTMENT_IN
			,SHIP.LOCATION_IN
			,SHIP.COMPANY_ID
			,SHIP.SHIP_DATE
			,SHIP.PROJECT_ID
			,PC.PRODUCT_CAT
			,PC.HIERARCHY
			,PC.PRODUCT_CATID
			,S.PRODUCT_ID
			,S.STOCK_ID
			,S.PRODUCT_NAME
			,S.PROPERTY
			,S.STOCK_CODE
			,S.MANUFACT_CODE
			,(SR.AMOUNT) PRODUCT_STOCK
			,SR.UNIT AS BIRIM
			,SR.OTHER_MONEY_VALUE
			,SR.OTHER_MONEY
			,SR.ROW_PROJECT_ID
			,SR.SPECT_VAR_NAME
			,(SELECT TOP 1 SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS WHERE SPECTS.SPECT_VAR_ID = SR.SPECT_VAR_ID) AS SPECT_MAIN_ID
            ,SR.SHIP_ROW_ID
			,SHIP.PURCHASE_SALES
			,SHIP.SHIP_TYPE ISLEM_TIPI
			,SHIP.SHIP_ID
            ,SHIP.DELIVER_EMP
            ,SR.PRICE AS PRICE_ROW
			,SR.LOT_NO
			,S.BARCOD
			<cfelseif attributes.report_type eq 6>
			,PB.BRAND_NAME
			,S.BRAND_ID
			,(SR.AMOUNT) PRODUCT_STOCK
			,SR.SHIP_ROW_ID            
			<cfelseif attributes.report_type eq 7>
			,B.BRANCH_NAME
			,B.BRANCH_ID
			,(SR.AMOUNT) PRODUCT_STOCK	
			,SR.SHIP_ROW_ID            
			</cfif>
		FROM
			SHIP,
			SHIP_ROW SR
            <cfif attributes.is_other_money eq 1>
				LEFT JOIN  SHIP_MONEY SM ON SM.ACTION_ID = SR.SHIP_ID AND SM.MONEY_TYPE = SR.OTHER_MONEY AND SR.OTHER_MONEY IS NOT NULL
			</cfif>	
            ,
			#dsn3_alias#.STOCKS S
		<cfif attributes.report_type eq 6>
			LEFT JOIN #dsn3_alias#.PRODUCT_BRANDS PB
			ON S.BRAND_ID = PB.BRAND_ID
		</cfif>
	<!---	<cfif attributes.is_other_money eq 1>
			,SHIP_MONEY SM
		</cfif>	--->
		<cfif attributes.report_type neq 4>
			,#dsn3_alias#.PRODUCT_CAT PC
			,#dsn3_alias#.PRODUCT_UNIT PU
		</cfif>
		<cfif attributes.report_type eq 4>
			,#dsn_alias#.COMPANY C
		</cfif>
		<cfif attributes.is_money2 eq 1>
			,SHIP_MONEY SM
		</cfif>
		<cfif attributes.report_type eq 8>
			,#dsn3_alias#.PRODUCT_CAT PC_2
		<cfelseif attributes.report_type eq 7>
			,#dsn_alias#.DEPARTMENT D
			,#dsn_alias#.BRANCH B		
		</cfif>
		WHERE
			SHIP.IS_SHIP_IPTAL = 0 AND 
			SHIP.SHIP_ID = SR.SHIP_ID AND
			SR.STOCK_ID = S.STOCK_ID AND		
<!---			<cfif attributes.is_other_money eq 1>
				(
					(
						SR.SHIP_ID IN(SELECT SMM.ACTION_ID FROM SHIP_MONEY SMM) AND
					)
					OR
					(
						SR.SHIP_ID NOT IN(SELECT SMM.ACTION_ID FROM SHIP_MONEY SMM)
						AND SM.ACTION_ID = (SELECT MAX(ACTION_ID) FROM SHIP_MONEY) AND
						SM.MONEY_TYPE = SR.OTHER_MONEY
					)
				) AND
			</cfif>--->
            
            <cfif attributes.is_other_money eq 1>
            	SR.OTHER_MONEY IS NOT NULL AND  
            </cfif>
			<cfif len(attributes.project_id) and len(attributes.project_head)>
				 SHIP.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"> AND
			</cfif>
			<cfif attributes.report_type eq 7>
				SHIP.DEPARTMENT_IN = D.DEPARTMENT_ID AND
				D.BRANCH_ID = B.BRANCH_ID AND
			</cfif>
			<!--- <cfif attributes.report_type eq 6>
				S.BRAND_ID = PB.BRAND_ID AND
			</cfif> --->
			<cfif attributes.is_money2 eq 1>
				SM.ACTION_ID = SHIP.SHIP_ID AND 
				SM.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#"> AND 
			</cfif>
			<cfif attributes.report_type neq 4>
				<cfif attributes.report_type eq 8>
					PC_2.PRODUCT_CATID = S.PRODUCT_CATID AND
					CHARINDEX('.',PC_2.HIERARCHY) <> 0 AND
					PC.HIERARCHY = LEFT(PC_2.HIERARCHY,(CHARINDEX('.',PC_2.HIERARCHY)-1)) AND			
				<cfelse>
					PC.PRODUCT_CATID = S.PRODUCT_CATID AND	
				</cfif>
				PU.PRODUCT_ID = S.PRODUCT_ID AND	
				S.PRODUCT_ID = SR.PRODUCT_ID AND 
				PU.PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID AND
				SR.STOCK_ID = S.STOCK_ID AND
			</cfif>	
			SHIP.SHIP_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
			<cfif attributes.report_type eq 4>AND SHIP.COMPANY_ID = C.COMPANY_ID</cfif>	
			<cfif len(attributes.process_type)>
				AND (
						SHIP.PROCESS_CAT IN (#attributes.process_type#)
						<!--- OR 
						(
							SHIP.PROCESS_CAT IS NULL AND
							SHIP.SHIP_TYPE IN (SELECT PROCESS_TYPE FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID IN (#attributes.process_type#))
						) --->
					)
			<cfelse>
				AND SHIP.SHIP_TYPE IN (#process_list#)
			</cfif>
			<cfif len(attributes.company) and len(attributes.company_id) and attributes.company_id neq 0>AND SHIP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"></cfif>
			<cfif len(attributes.company) and len(attributes.consumer_id) and attributes.consumer_id neq 0>AND SHIP.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"></cfif>
			<cfif len(attributes.company) and len(attributes.employee_id) and attributes.employee_id neq 0>AND SHIP.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"></cfif>
            <cfif len(attributes.company) and len(trim(attributes.ship_address))>AND SHIP.ADDRESS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.ship_address#%"></cfif>
			<cfif len(trim(attributes.product_cat)) and len(attributes.search_product_catid)>
				AND S.PRODUCT_CATID IN(SELECT PRODUCT_CATID FROM #dsn3_alias#.PRODUCT_CAT WHERE HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.search_product_catid#%">)
			</cfif>
			<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>AND	S.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"></cfif>		
			<cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>AND S.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_employee_id#"></cfif>
			<cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>AND S.BRAND_ID IN (#attributes.brand_id#)</cfif>
			<cfif len(trim(attributes.model_name)) and len(attributes.model_id)>AND S.SHORT_CODE_ID IN (#attributes.model_id#)</cfif>
			<cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_id) and len(attributes.ship_method_name)>
				AND SHIP.SHIP_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_method_id#">
			</cfif>            
			<cfif len(attributes.department_id)>
				AND(
				<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
					(SHIP.DEPARTMENT_IN = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND SHIP.LOCATION_IN = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
					<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
				</cfloop>  
					)
			<cfelseif len(branch_dep_list)>
				AND SHIP.DEPARTMENT_IN IN (#branch_dep_list#)
			</cfif>	
			<cfif isdefined("x_show_department_out") and x_show_department_out eq 1>
				<cfif isdefined('attributes.department_id_out') and len(attributes.department_id_out)>
					AND(
					<cfloop list="#attributes.department_id_out#" delimiters="," index="dept_i">
						(SHIP.DELIVER_STORE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND SHIP.LOCATION_IN = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
						<cfif dept_i neq listlast(attributes.department_id_out,',') and listlen(attributes.department_id_out,',') gte 1> OR</cfif>
					</cfloop>  
						)
				</cfif>
			</cfif>
			<cfif attributes.invoice_action eq 1>
				AND SHIP.SHIP_ID IN (SELECT SHIP_ID FROM INVOICE_SHIPS)
			<cfelseif attributes.invoice_action eq 2>
				AND SHIP.SHIP_ID NOT IN (SELECT SHIP_ID FROM INVOICE_SHIPS)
			</cfif>			
	</cfquery>

	<cfif get_total_purchase_2.recordcount>
		<cfquery name="GET_TOTAL_PURCHASE" dbtype="query">
			SELECT 
				<cfif attributes.is_other_money eq 1>
					OTHER_MONEY,
				</cfif>
				<cfif attributes.is_money2 eq 1 or attributes.is_other_money eq 1>
					SUM(PRICE_DOVIZ) AS PRICE_DOVIZ,
				</cfif>
				SUM(PRICE) AS PRICE
				<cfif attributes.report_type eq 1 or attributes.report_type eq 8>
				,PRODUCT_CAT,HIERARCHY,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
				<cfelseif attributes.report_type eq 2>
				,PRODUCT_CAT,PRODUCT_ID,PRODUCT_NAME,PRODUCT_CODE,PRODUCT_MANAGER,BARCOD,BIRIM,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
				<cfelseif attributes.report_type eq 3>
				,PRODUCT_CAT,PRODUCT_NAME,STOCK_CODE,PRODUCT_MANAGER,BARCOD
				,PROPERTY,STOCK_ID,BIRIM,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
				<cfelseif attributes.report_type eq 4>
				,NICKNAME,COMPANY_ID,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
				<cfelseif attributes.report_type eq 5>
				,SHIP_NUMBER,DEPARTMENT_IN,LOCATION_IN,COMPANY_ID,OZEL_KOD_2,SHIP_DATE,PRODUCT_CAT,HIERARCHY,PRODUCT_CATID,PRODUCT_ID,STOCK_ID,PRODUCT_NAME,PROPERTY,STOCK_CODE,MANUFACT_CODE,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,BIRIM,OTHER_MONEY_VALUE,OTHER_MONEY,PROJECT_ID,ROW_PROJECT_ID,SPECT_VAR_NAME,SPECT_MAIN_ID,PURCHASE_SALES,ISLEM_TIPI,SHIP_ID,DELIVER_EMP,PRICE_ROW,LOT_NO,BARCOD
				<cfelseif attributes.report_type eq 6>
				,BRAND_NAME,BRAND_ID,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
				<cfelseif attributes.report_type eq 7>
				,BRANCH_NAME,BRANCH_ID,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
				</cfif>		
			FROM 
				get_total_purchase_2
			GROUP BY 
				<cfif attributes.is_other_money eq 1>
				OTHER_MONEY,
				</cfif>
				<cfif attributes.report_type eq 1 or attributes.report_type eq 8>
				PRODUCT_CAT,HIERARCHY
				<cfelseif attributes.report_type eq 2>
				PRODUCT_CAT,PRODUCT_ID,PRODUCT_NAME,PRODUCT_CODE,PRODUCT_MANAGER,BIRIM,BARCOD
				<cfelseif attributes.report_type eq 3>
				PRODUCT_CAT,PRODUCT_ID,PRODUCT_NAME,STOCK_CODE,PRODUCT_MANAGER,PROPERTY,STOCK_ID,BIRIM,BARCOD
				<cfelseif attributes.report_type eq 4>
				NICKNAME,COMPANY_ID
				<cfelseif attributes.report_type eq 5>
				SHIP_NUMBER,
				DEPARTMENT_IN,
				LOCATION_IN,
				SHIP_DATE,
				COMPANY_ID,
				OZEL_KOD_2,
				PRODUCT_CAT,
				HIERARCHY,
				PRODUCT_CATID,
				PRODUCT_ID,
				STOCK_ID,
				PRODUCT_NAME,
				PROPERTY,
				STOCK_CODE,
				MANUFACT_CODE,
				BIRIM,
				OTHER_MONEY_VALUE,
				OTHER_MONEY,
				PROJECT_ID,
				ROW_PROJECT_ID,
				SPECT_VAR_NAME,
				SPECT_MAIN_ID,
				PURCHASE_SALES,
				ISLEM_TIPI,
				SHIP_ID,
                DELIVER_EMP,
                PRICE_ROW,
				LOT_NO,
			    BARCOD
				<cfelseif attributes.report_type eq 6>
				BRAND_NAME,
				BRAND_ID
				<cfelseif attributes.report_type eq 7>
				BRANCH_NAME,
				BRANCH_ID
				</cfif>	
			ORDER  BY 
			<cfif attributes.kontrol_type eq 1>
				SHIP_NUMBER
			<cfelseif attributes.report_sort eq 1>
				PRICE DESC
			<cfelse>
				<cfif listfind('1,2,3,4,5,6',attributes.report_type)>
					PRODUCT_STOCK DESC
				<cfelse>
					PRODUCT_CAT, PRICE DESC
				</cfif>				
			</cfif>
		</cfquery>
	<cfelse>
		<cfset get_total_purchase.recordcount=0>
	</cfif>
	<cfif get_total_purchase.recordcount>
		<cfquery name="GET_ALL_TOTAL" dbtype="query">
			SELECT SUM(PRICE) AS PRICE FROM GET_TOTAL_PURCHASE
		</cfquery>
	<cfelse>
		<cfset get_all_total.recordcount=0>
	</cfif>
	<cfif get_all_total.recordcount neq 0 and len(get_all_total.price)>
		<cfset butun_toplam=get_all_total.price>
	<cfelse>
		<cfset butun_toplam=1>
	</cfif>	
</cfif>
<cfset toplam_satis=0>
<cfset toplam_doviz = 0>
<cfset toplam_miktar=0>
<cfset toplam_price_row = 0>
<cfform name="rapor" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.purchase_analyse_report_ship">
	<cf_report_list_search id="report_ship" title="#getLang('main',2282)#">
		<cf_report_list_search_area>
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-3 col-md-6 col-xs-12">
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<cf_wrk_product_cat form_name='rapor' hierarchy_code='search_product_catid' product_cat_name='product_cat'>
											<input type="hidden" name="search_product_catid" id="search_product_catid" value="<cfif len(attributes.product_cat)><cfoutput>#attributes.search_product_catid#</cfoutput></cfif>">
											<input type="text" name="product_cat" id="product_cat" style="width:175px;"  value="<cfif len(attributes.product_cat)><cfoutput>#attributes.product_cat#</cfoutput></cfif>" onkeyup="get_product_cat();">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_code=rapor.search_product_catid&field_name=rapor.product_cat</cfoutput>');"></span>
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="product_id" id="product_id" <cfif len(attributes.product_name)>value="<cfoutput>#attributes.product_id#</cfoutput>"</cfif>>
											<input type="text" name="product_name" id="product_name" style="width:175px;" value="<cfoutput>#attributes.product_name#</cfoutput>"  onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product_autocomplete','0','PRODUCT_ID','product_id','','3','200');" autocomplete="off">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="set_the_report();windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=rapor.product_id&field_name=rapor.product_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','list');"></span>
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57544.Sorumlu'></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="product_employee_id" id="product_employee_id"  value="<cfif len(attributes.employee_name)><cfoutput>#attributes.product_employee_id#</cfoutput></cfif>">
											<input type="text" name="employee_name" id="employee_name" style="width:175px;" value="<cfif len(attributes.employee_name)><cfoutput>#attributes.employee_name#</cfoutput></cfif>" maxlength="255">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=rapor.product_employee_id&field_name=rapor.employee_name&select_list=1,9','list');"></span>
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id')><cfoutput>#attributes.project_id#</cfoutput></cfif>">
											<input type="text" name="project_head" id="project_head" style="width:175px;" value="<cfif isdefined('attributes.project_head') and  len(attributes.project_head)><cfoutput>#attributes.project_head#</cfoutput></cfif>">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=rapor.project_id&project_head=rapor.project_head');"></span>
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="consumer_id" id="consumer_id" <cfif len(attributes.company)>value="<cfoutput>#attributes.consumer_id#</cfoutput>"</cfif>>			
											<input type="hidden" name="company_id" id="company_id"<cfif len(attributes.company)> value="<cfoutput>#attributes.company_id#</cfoutput>"</cfif>>
											<input type="hidden" name="employee_id" id="employee_id" <cfif len(attributes.company)> value="<cfoutput>#attributes.employee_id#</cfoutput>"</cfif>>
											<input type="text" name="company" id="company" style="width:175px;" value="<cfif len(attributes.company) ><cfoutput>#attributes.company#</cfoutput></cfif>">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=1,2,3,9&field_comp_name=rapor.company&field_comp_id=rapor.company_id&field_consumer=rapor.consumer_id&field_member_name=rapor.company&field_emp_id=rapor.employee_id&field_name=rapor.company<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput>&keyword='+encodeURIComponent(document.rapor.company.value),'list')"></span>
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58847.Marka'></label>
									<cf_wrk_list_items table_name ='PRODUCT_BRANDS' wrk_list_object_id='BRAND_ID' wrk_list_object_name='BRAND_NAME' sub_header_name="#getLang('main',1435)#" header_name="#getLang('report',1818)#" width='175' datasource ="#dsn1#">
								</div>
							</div>
							<div class="col col-3 col-md-6 col-xs-12">				
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58225.Model'></label>
									<cf_wrk_list_items table_name ='PRODUCT_BRANDS_MODEL' wrk_list_object_id='MODEL_ID' wrk_list_object_name='MODEL_NAME' sub_header_name="#getLang('main',813)#" header_name="#getLang('report',1354)#" width='175' datasource ="#dsn1#">
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="ship_method_id" id="ship_method_id" value="<cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_name)><cfoutput>#attributes.ship_method_id#</cfoutput></cfif>">
											<input type="text" name="ship_method_name" id="ship_method_name" style="width:175px;" value="<cfif isdefined("attributes.ship_method_name") and len(attributes.ship_method_name)><cfoutput>#attributes.ship_method_name#</cfoutput></cfif>" onfocus="AutoComplete_Create('ship_method_name','SHIP_METHOD','SHIP_METHOD','get_ship_method','','SHIP_METHOD_ID','ship_method_id','','3','125');" autocomplete="off">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=rapor.ship_method_name&field_id=rapor.ship_method_id','list');"></span>
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='39131.Sevk Adresi'></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="city_id" id="city_id" value="">
											<input type="hidden" name="county_id" id="county_id" value="">
											<input type="text" name="ship_address" id="ship_address"  value="<cfif len(attributes.ship_address)><cfoutput>#attributes.ship_address#</cfoutput></cfif>" style="width:175px;"><!--- <cfoutput>#trim(attributes.ship_address)#</cfoutput> --->
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="add_ship_adress();"></span>
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58960.Rapor Tipi'></label> 
									<div class="col col-12 col-xs-12">
										<select name="report_type" id="report_type" onchange="kontrol();">
											<option value="8" <cfif attributes.report_type eq 8>selected</cfif>><cf_get_lang dictionary_id='40556.Ana Kategori'><cf_get_lang dictionary_id='58601.Bazında'></option>
											<option value="5" <cfif attributes.report_type eq 5>selected</cfif>><cf_get_lang dictionary_id='39685.Belge ve Stok Bazında'></option>
											<option value="4" <cfif attributes.report_type eq 4>selected</cfif>><cf_get_lang dictionary_id='39075.Cari Bazında'></option>
											<option value="1" <cfif attributes.report_type eq 1>selected</cfif>><cf_get_lang dictionary_id='39052.Kategori Bazında'></option>
											<option value="6" <cfif attributes.report_type eq 6>selected</cfif>><cf_get_lang dictionary_id='39095.Marka Bazında'></option>
											<option value="3" <cfif attributes.report_type eq 3>selected</cfif>><cf_get_lang dictionary_id='39054.Stok Bazında'></option>
											<option value="7" <cfif attributes.report_type eq 7>selected</cfif>><cf_get_lang dictionary_id='39350.Şube Bazında'></option>
											<option value="2" <cfif attributes.report_type eq 2>selected</cfif>><cf_get_lang dictionary_id='39053.Ürün Bazında'></option>
										</select>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='39215.Fatura Hareketleri'></label> 
									<div class="col col-12 col-xs-12">
										<select name="invoice_action" id="invoice_action">
											<option selected value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
											<option value="1" <cfif isDefined('attributes.invoice_action') and attributes.invoice_action eq 1>selected</cfif>><cf_get_lang dictionary_id='39216.Faturalanmış'></option>
											<option value="2" <cfif isDefined('attributes.invoice_action') and attributes.invoice_action eq 2>selected</cfif>><cf_get_lang dictionary_id='39217.Faturalanmamış'></option>
										</select>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58690.Tarih Aralığı'></label>
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'></cfsavecontent>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
												<cfinput validate="#validate_style#" message="#message#" type="text" name="date1" value="#dateformat(attributes.date1,dateformat_style)#" required="yes">  
												<span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>            
												<span class="input-group-addon no-bg"></span>
												<cfinput validate="#validate_style#" message="#message#" type="text" name="date2" value="#dateformat(attributes.date2,dateformat_style)#" required="yes">
												<span class="input-group-addon"><cf_wrk_date_image date_field="date2"></span>  
											</div>
										</div>
								</div>
							</div>
							<div class="col col-3 col-md-6 col-xs-12">
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57800.İşlem Tipi'></label> 
										<div class="col col-12 col-xs-12">
											<cfquery name="GET_PROCESS_CAT" datasource="#DSN3#">
												SELECT PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (73,74,75,76,77,80,81,811,761,82,84,86,87) ORDER BY PROCESS_TYPE
											</cfquery>
											<select name="process_type" id="process_type"  multiple>
												<cfoutput query="get_process_cat">
												<option value="#process_cat_id#" <cfif listfind(attributes.process_type,process_cat_id,',')>selected</cfif>>#process_cat#</option>
												</cfoutput>
											</select>
										</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58763.Depo'></label> 
										<div class="col col-12 col-xs-12">
											<select name="department_id" id="department_id" multiple>
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
								<cfif isdefined("x_show_department_out") and x_show_department_out eq 1>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='39231.Depo Çıkış'></label>
										<div class="col col-12 col-xs-12">
											<select name="department_id_out" id="department_id_out" multiple="multiple">
												<cfoutput query="get_department">
													<optgroup label="#department_head#">
													<cfquery name="GET_LOCATION" dbtype="query">
														SELECT * FROM GET_ALL_LOCATION WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_department.department_id[currentrow]#">
													</cfquery>
													<cfif get_location.recordcount>
														<cfloop from="1" to="#get_location.recordcount#" index="s">
															<option value="#department_id#-#get_location.location_id[s]#" <cfif listfind(attributes.department_id_out,'#department_id#-#get_location.location_id[s]#',',')>selected</cfif>>&nbsp;&nbsp;#get_location.comment[s]#</option>
														</cfloop>
													</cfif>
													</optgroup>					  
												</cfoutput>
											</select>	
										</div>
									</div>
								</cfif>
							</div>
							<div class="col col-3 col-md-6 col-xs-12">
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='39055.Rapor Sıra'></label> 
									<div class="col col-12 col-xs-12">
										<input type="hidden" name="kontrol_type" id="kontrol_type" value="<cfoutput>#attributes.kontrol_type#</cfoutput>">
										<label><cf_get_lang dictionary_id='30010.Ciro'><input type="radio" name="report_sort" id="report_sort" value="1"  <cfif attributes.report_sort eq 1 and attributes.kontrol_type eq 0>checked</cfif>></label>
										<label><cf_get_lang dictionary_id='57635.Miktar'><input type="radio" name="report_sort" id="report_sort" value="2"  <cfif attributes.report_sort eq 2 and attributes.kontrol_type eq 0>checked</cfif>></label>
									</div>
								</div>
								<div class="form-group">
									<div class="col col-12 col-xs-12">
										<label><cf_get_lang dictionary_id='39059.Kdv Dahil'><input type="checkbox" name="kdv_dahil" id="kdv_dahil" value="1" <cfif isdefined("attributes.kdv_dahil") and (attributes.kdv_dahil eq 1)>checked</cfif>></label>
										<label><cf_get_lang dictionary_id='58596.Göster'><input name="is_money2" id="is_money2" value="1" type="checkbox" <cfif attributes.is_money2 eq 1 >checked</cfif>><cfoutput> #session.ep.money2# </cfoutput></label>
										<label style="<cfif attributes.report_type neq 5>display:none;</cfif>" id="money_info_2"><cf_get_lang dictionary_id='39647.Döviz Göster'><input type="checkbox" name="is_money_info" id="is_money_info" value="1" <cfif isdefined("attributes.is_money_info")>checked</cfif>></label>										
										<label><cf_get_lang dictionary_id='57795.İşlem Dovizli'><input name="is_other_money" id="is_other_money" value="1" type="checkbox" <cfif attributes.is_other_money eq 1>checked</cfif>></label>
										<label style="<cfif attributes.report_type neq 5>display:none;</cfif>" id="is_spect_info1"><cf_get_lang dictionary_id='40610.Spec Göster'><input type="checkbox" name="is_spect_info" id="is_spect_info" value="1" <cfif attributes.is_spect_info eq 1 >checked</cfif>></label>
										<label style="<cfif attributes.report_type neq 5>display:none;</cfif>" id="is_project1"><input name="is_project" id="is_project" value="1" type="checkbox" <cfif attributes.is_project eq 1 >checked</cfif>><cf_get_lang dictionary_id='57416.Proje'> <cf_get_lang dictionary_id='58596.Göster'></label>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row ReportContentBorder">
						<div class="ReportContentFooter">
							<label><cf_get_lang dictionary_id='57858.Excel Getir'><input name="is_excel" id="is_excel" type="checkbox" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>					
							<input name="max_rows" type="text" id="max_rows" style="width:25px;" value="<cfoutput>#attributes.max_rows#</cfoutput>">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57911.Çalıştır'></cfsavecontent>
							<cf_wrk_report_search_button search_function='control()' button_type='1' is_excel='1' insert_info='#message#'>
						</div>
					</div>
				</div>
			</div>	
		</cf_report_list_search_area>
	</cf_report_list_search>
</cfform>

<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
    <cfset filename = "purchase_analyse_report_ship#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
    <cfheader name="Expires" value="#Now()#">
    <cfcontent type="application/vnd.msexcel;charset=utf-8">
    <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<cfset attributes.startrow=1>
	<cfset attributes.max_rows=get_total_purchase.recordcount>
</cfif>


<cfif isdefined("attributes.form_submitted")>
	<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
		<cfset type_ = 1>
	<cfelse>
		<cfset type_ = 0>
	</cfif>
        <cf_seperator title="#getLang('main',388)#" id="transaction_type" is_closed="1">
        <table class="color-border" width="99%" cellpadding="2" cellspacing="1" style="display:none;" id="transaction_type">
            <tr class="color-row">
                <td valign="top">
                    <cfif len(attributes.process_type)>
                        <cfquery name="GET_PROCESS_CAT" datasource="#DSN3#">
                            SELECT PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID IN (#attributes.process_type#) AND PROCESS_TYPE IN (73,74,75,76,77,80,81,811,761,82,84,86,87) ORDER BY PROCESS_TYPE
                        </cfquery>
                    <cfelse>
                        <cfset get_process_cat.recordcount = 0>
                    </cfif>
                    <cfif get_process_cat.recordcount>
                        <cfoutput query="get_process_cat">#process_cat#<br></cfoutput>
                    </cfif>
                </td>
                <td>
                    <cf_get_lang dictionary_id='58960.Rapor Tipi'>:
                    <cfif attributes.report_type eq 1><cf_get_lang dictionary_id='39052.Kategori Bazında'>
                    <cfelseif attributes.report_type eq 8><cf_get_lang dictionary_id='40556.Ana Kategori'><cf_get_lang dictionary_id='58601.Bazında'>
                    <cfelseif attributes.report_type eq 2><cf_get_lang dictionary_id='39053.Ürün Bazında'>
                    <cfelseif attributes.report_type eq 3><cf_get_lang dictionary_id='39054.Stok Bazında'>
                    <cfelseif attributes.report_type eq 6><cf_get_lang dictionary_id='39095.Marka Bazında'>
                    <cfelseif attributes.report_type eq 4><cf_get_lang dictionary_id='39075.Cari Bazında'>
                    <cfelseif attributes.report_type eq 5><cf_get_lang dictionary_id='39685.Belge ve Stok Bazında'>
                    <cfelseif attributes.report_type eq 7><cf_get_lang dictionary_id='39350.Şube Bazında'>
                    </cfif><hr />
                    <cfoutput>
                    <cf_get_lang dictionary_id='58690.Tarih Aralığı'>:#dateformat(attributes.date1,dateformat_style)#-#dateformat(attributes.date2,dateformat_style)#<hr />
                    <cf_get_lang dictionary_id='57416.Proje'>:#attributes.project_head#<hr />
                    <cf_get_lang dictionary_id='57519.Cari Hesap'>:#attributes.company#<hr />
                    </cfoutput>
                 </td>
                 <td>
                    <cfoutput>
                    <cf_get_lang dictionary_id='57657.Ürün'>:#attributes.product_name#<hr />
                    <cf_get_lang dictionary_id='58847.Marka'>:#BRAND_NAME#<hr />
                    <cf_get_lang dictionary_id='58225.Model'>:#model_name#<hr />
                    <cf_get_lang dictionary_id='57544.Sorumlu'>:#attributes.employee_name#<hr />
                    </cfoutput>
                </td>
                <td>
                    <cfoutput>
                        <cf_get_lang dictionary_id='57486.Kategori'>:#attributes.product_cat#<hr />
                        <cf_get_lang dictionary_id='39215.Fatura Hareketleri'>:<cfif isDefined('attributes.invoice_action') and attributes.invoice_action eq 1><cf_get_lang dictionary_id='39216.Faturalanmış'><cfelseif isDefined('attributes.invoice_action') and attributes.invoice_action eq 2><cf_get_lang dictionary_id='39217.Faturalanmamış'><cfelse><cf_get_lang dictionary_id='57708.Tümü'></cfif><hr />
                        <cf_get_lang dictionary_id='29500.Sevk Yöntemi'>:#attributes.ship_method_name#<hr />
                        <cf_get_lang dictionary_id='39055.Rapor Sıra'>:<cfif attributes.report_sort eq 1><cf_get_lang dictionary_id='30010.Ciro'><cfelseif attributes.report_sort eq 2><cf_get_lang dictionary_id='57635.Miktar'></cfif><hr />
                    </cfoutput>
                </td>
            </tr>
        </table>
	<cf_report_list>
		<cfparam name="attributes.page" default=1>
		<cfparam name="attributes.totalrecords" default="#get_total_purchase.recordcount#">
		<cfset attributes.startrow=((attributes.page-1)*attributes.max_rows)+1>
		<cfif get_total_purchase.recordcount>
		<cfif attributes.page neq 1>
			<cfoutput query="get_total_purchase"  startrow="1" maxrows="#attributes.startrow-1#">
				<cfif len(price)>
					<cfset toplam_satis=price+toplam_satis>
				</cfif> 
				<cfif attributes.is_money2 eq 1 and len(price_doviz)>
					<cfset toplam_doviz=price_doviz+toplam_doviz>
				</cfif>
				<cfif isdefined("product_stock") and len(product_stock)>
					<cfset toplam_miktar=product_stock+toplam_miktar>
				</cfif>
			</cfoutput>
		</cfif>	
		<cfif attributes.report_type eq 1 or attributes.report_type eq 8>
        <thead>
			<tr>
				<th><cf_get_lang dictionary_id='57487.No'></th>
				<th><cf_get_lang dictionary_id='39378.Kategori kodu'></th><!--- kategori kodu eklendi.MA20081107 --->
				<th><cf_get_lang dictionary_id='57486.Kategori'></th>
				<th><cf_get_lang dictionary_id='57635.Miktar'></th>
				<cfif attributes.is_other_money eq 1>
					<th><cf_get_lang dictionary_id='57677.Doviz'></th>
					<th><cf_get_lang dictionary_id='58474.Birim'></th>
				</cfif>
				<th><cf_get_lang dictionary_id='57673.Tutar'></th>
				<th><cf_get_lang dictionary_id='58474.Birim'></th>
				<cfif attributes.is_money2 eq 1>
					<th><cf_get_lang dictionary_id='39656.Döviz Tutar'></th>
					<th><cf_get_lang dictionary_id='58474.Birim'></th>
				</cfif>
				<th>%</th>
			</tr>
        </thead> 
        <tbody> 
			<cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.max_rows#">
				<tr>
					<td>#currentrow#</td>
					<td>#hierarchy#</td>
					<td>#product_cat#</td>
					<td format="numeric">#TLFormat(product_stock)#</td>
					<cfif len(product_stock)><cfset toplam_miktar=product_stock+toplam_miktar></cfif>
					<cfif attributes.is_other_money eq 1>
						<td format="numeric">#TLFormat(price_doviz)#</td>
						<td>#other_money#</td>
					</cfif>
					<td format="numeric">#TLFormat(price)#</td>
					<td>#session.ep.money#</td>
					<cfif len(price)><cfset toplam_satis=price+toplam_satis></cfif>
					<cfif attributes.is_money2 eq 1>
						<td format="numeric">#TLFormat(price_doviz)#</td>
						<td>#session.ep.money2#</td>
						<cfif len(price_doviz)><cfset toplam_doviz=price_doviz+toplam_doviz></cfif>
					</cfif>
					<td format="numeric"><cfif len(butun_toplam) and butun_toplam neq 0 and len(price)>#NumberFormat(Evaluate(100*price/butun_toplam),"00.00")#<cfelse>00.00</cfif></td>
				</tr>
			</cfoutput>
        </tbody>
        <tfoot>
			<cfoutput>
				<tr>
					<td colspan="3" class="formbold"><cf_get_lang dictionary_id='57492.Toplam'></td>
					<td class="formbold" format="numeric">#TLFormat(toplam_miktar)#</td>
					<cfif attributes.is_other_money eq 1>
						<td></td>
						<td></td>
					</cfif>
					<td class="formbold" format="numeric">#TLFormat(toplam_satis)#</td>
					<cfif type_ eq 1>
						<td class="formbold">#session.ep.money#</td>
					<cfelse>
						<td class="formbold">#session.ep.money#</td>					
					</cfif>
					<cfif attributes.is_money2 eq 1>
						<td format="numeric">#TLFormat(toplam_doviz)#</td>
						<td class="formbold">#session.ep.money2#</td>
					</cfif>
					<td></td>
				</tr>
			</cfoutput>
        </tfoot>	
		<cfelseif attributes.report_type eq 7>
        <thead>
			<tr>
				<th><cf_get_lang dictionary_id='57487.No'></th>
				<th><cf_get_lang dictionary_id='57453.Şube'></th>
				<th><cf_get_lang dictionary_id='57635.Miktar'></th>
				<cfif attributes.is_other_money eq 1>
					<th><cf_get_lang dictionary_id='57677.Doviz'></th>
					<th><cf_get_lang dictionary_id='58474.Birim'></th>
				</cfif>
				<th><cf_get_lang dictionary_id='57673.Tutar'></th>
				<th><cf_get_lang dictionary_id='58474.Birim'></th>
				<cfif attributes.is_money2 eq 1>
					<th><cf_get_lang dictionary_id='39656.Döviz Tutar'></th>
					<th><cf_get_lang dictionary_id='58474.Birim'></th>
				</cfif>
				<th>%</th>
			</tr>
        </thead>
        <tbody>			  
			<cfoutput query="get_total_purchase"  startrow="#attributes.startrow#" maxrows="#attributes.max_rows#">
				<tr>
					<td>#currentrow#</td>
					<td>#BRANCH_NAME#</td>
					<td>#TLFormat(PRODUCT_STOCK)#</td>
					<cfif len(PRODUCT_STOCK)><cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar></cfif>
					<cfif attributes.is_other_money eq 1>
						<td>#TLFormat(price_doviz)#</td>
						<td>#other_money#</td>
					</cfif>
					<td>#TLFormat(PRICE)#</td>
					<td>#session.ep.money#</td>
					<cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif>
					<cfif attributes.is_money2 eq 1>
						<td>#TLFormat(PRICE_DOVIZ)#</td>
						<td>#session.ep.money2#</td>
						<cfif len(PRICE_DOVIZ)><cfset toplam_doviz=PRICE_DOVIZ+toplam_doviz></cfif>
					</cfif>
					<td format="numeric"><cfif len(butun_toplam) and butun_toplam neq 0 and len(PRICE)>#NumberFormat(Evaluate(100*PRICE/butun_toplam),"00.00")#<cfelse>00.00</cfif></td>
				</tr>
			</cfoutput>
        </tbody>
        <tfoot>
			<cfoutput>
				<tr>
					<td colspan="2" class="formbold"><cf_get_lang dictionary_id='57492.Toplam'></td>
					<td class="formbold" format="numeric">#TLFormat(toplam_miktar)#</td>
					<cfif attributes.is_other_money eq 1>
						<td></td>
						<td></td>
					</cfif>
					<td class="formbold" format="numeric">#TLFormat(toplam_satis)#</td>
					<td class="formbold">#session.ep.money#</td>
					<cfif attributes.is_money2 eq 1>
						<td class="formbold" format="numeric">#TLFormat(toplam_doviz)#</td>
						<td class="formbold">#session.ep.money2#</td>
					</cfif>
					<td></td>
				</tr>
			</cfoutput> 
        </tfoot>
		<cfelseif attributes.report_type eq 4>
        <thead>
			<tr>
				<th><cf_get_lang dictionary_id='57487.No'></th>
				<th><cf_get_lang dictionary_id='58607.Firma'></th>
				<th><cf_get_lang dictionary_id='57635.Miktar'></th>
				<cfif attributes.is_other_money eq 1>
					<th><cf_get_lang dictionary_id='57677.Doviz'></th>
					<th><cf_get_lang dictionary_id='58474.Birim'></th>
				</cfif>
				<th><cf_get_lang dictionary_id='57673.Tutar'></th>
				<th><cf_get_lang dictionary_id='58474.Birim'></th>
				<cfif attributes.is_money2 eq 1>
					<th><cf_get_lang dictionary_id='39656.Döviz Tutar'></th>
					<th"><cf_get_lang dictionary_id='58474.Birim'></th">
				</cfif>
				<th>%</th>
			</tr>
        </thead>
        <tbody>			  
			<cfoutput query="get_total_purchase"  startrow="#attributes.startrow#" maxrows="#attributes.max_rows#">
				<tr>
					<td>#currentrow#</td>
					<td>
					<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1 >
						#NICKNAME#
					<cfelse>
						<a href="javascript://"  class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#company_id#','list')">#NICKNAME#</a>
					</cfif>
					</td>
					<td format="numeric">#TLFormat(PRODUCT_STOCK)#</td>
					<cfif len(PRODUCT_STOCK)><cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar></cfif>
					<cfif attributes.is_other_money eq 1>
						<td format="numeric">#TLFormat(price_doviz)#</td>
						<td>#other_money#</td>
					</cfif>
					<td format="numeric">#TLFormat(PRICE)#</td>
					<td>#session.ep.money#</td>
					<cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif>
					<cfif attributes.is_money2 eq 1>
						<td format="numeric">#TLFormat(PRICE_DOVIZ)#</td>
						<td>#session.ep.money2#</td>
						<cfif len(PRICE_DOVIZ)><cfset toplam_doviz=PRICE_DOVIZ+toplam_doviz></cfif>
					</cfif>
					<td format="numeric"><cfif len(butun_toplam) and butun_toplam neq 0 and len(PRICE)>#NumberFormat(Evaluate(100*PRICE/butun_toplam),"00.00")#<cfelse>00.00</cfif></td>
				</tr>
			</cfoutput>
        </tbody>
        <tfoot>
			<cfoutput>
				<tr>
					<td colspan="2" class="formbold"><cf_get_lang dictionary_id='57492.Toplam'></td>
					<td class="formbold" format="numeric">#TLFormat(toplam_miktar)#</td>
					<cfif attributes.is_other_money eq 1>
						<td></td>
						<td></td>
					</cfif>
					<td class="formbold" format="numeric">#TLFormat(toplam_satis)#</td>
					<td class="formbold">#session.ep.money#</td>
					<cfif attributes.is_money2 eq 1>
						<td class="formbold" format="numeric">#TLFormat(toplam_doviz)#</td>
						<td class="formbold">#session.ep.money2#</td>
					</cfif>
					<td></td>
				</tr>
			</cfoutput>	
		</tfoot>  
		<cfelseif attributes.report_type eq 5>
        <thead>
			<tr>
				<th><cf_get_lang dictionary_id='57487.No'></th>
				<th><cf_get_lang dictionary_id='58138.İrsaliye No'></th>
				<th><cf_get_lang dictionary_id='39286.İrsaliye Tarihi'></th>
				<th><cf_get_lang dictionary_id='58763.Depo'></th>
				<th><cf_get_lang dictionary_id='57457.Müşteri'></th>
				<cfif isdefined("x_show_ozel_kod_3") and x_show_ozel_kod_3 eq 1>
					<th class="txtbold"><cf_get_lang dictionary_id="30343.Özel Kod 3"></th>	
				</cfif>
				<cfif attributes.is_project eq 1>
					<th><cf_get_lang dictionary_id='57416.Proje'></th>
				</cfif>
				<th><cf_get_lang dictionary_id='58800.Ürün Kod'></th>
				<th><cf_get_lang dictionary_id='57634.Üretici Kodu'></th>
				<th><cf_get_lang dictionary_id='57657.Ürün'> </th>
				<cfif isdefined("attributes.is_spect_info") and attributes.is_spect_info eq 1>
					<th><cf_get_lang dictionary_id='57647.Spec'></th>
					<th><cf_get_lang dictionary_id="57647.Spec"> <cf_get_lang dictionary_id="58527.Id"></th>
				</cfif>						
				<cfif isdefined("x_show_lot_no") and x_show_lot_no eq 1>
					<th class="txtbold"><cf_get_lang dictionary_id='32916.Lot no'></th>
				</cfif>
				<cfif isdefined("x_show_barcode") and x_show_barcode eq 1>
					<th class="txtbold"><cf_get_lang dictionary_id='57633.Barkod'></th>
				</cfif>
				<th><cf_get_lang dictionary_id='57635.Miktar'></th>
				<cfif attributes.is_other_money eq 1>
					<th><cf_get_lang dictionary_id='57677.Doviz'></th>
					<th><cf_get_lang dictionary_id='58474.Birim'></th>
				</cfif>
				<th><cf_get_lang dictionary_id='57636.Birim'></th>
                <th><cf_get_lang dictionary_id='57638.Birim Fiyat'></th>
				<th><cf_get_lang dictionary_id='57673.Tutar'></th>
				<cfif isdefined("attributes.is_money_info")>
					<th><cf_get_lang dictionary_id='39411.Döviz Net Fiyat'></th>
					<th><cf_get_lang dictionary_id='58121.İşlem Dövizi'></th>
				</cfif>
				<th><cf_get_lang dictionary_id='58474.Birim'></th>
				<cfif attributes.is_money2 eq 1>
					<th><cf_get_lang dictionary_id='39656.Döviz Tutar'></th>
					<th><cf_get_lang dictionary_id='58474.Birim'></th>
				</cfif>
				<th>%</th>
                <th><cf_get_lang dictionary_id='57775.Teslim alan'></th>
			</tr>
        </thead>
			<cfset department_name_list = "">
			<cfset department_location_list = "">
			<cfset company_id_list = "">
			<cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.max_rows#">
				<cfif len(department_in) and not listfind(department_name_list,department_in)>
					<cfset department_name_list=listappend(department_name_list,department_in)>
				</cfif>
				<cfif len(company_id) and not listfind(company_id_list,company_id)>
					<cfset company_id_list=listappend(company_id_list,company_id)>
				</cfif>
			</cfoutput>
			<cfif len(department_name_list)>
				<cfset department_name_list = listsort(department_name_list,"numeric","ASC",",")>
				<cfquery name="get_departman_name" datasource="#dsn#">
					SELECT 
						DEPARTMENT_ID,
						DEPARTMENT_HEAD
					FROM
						BRANCH B,
						DEPARTMENT D
					WHERE
						D.DEPARTMENT_ID IN (#department_name_list#) AND
						B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
						B.BRANCH_ID = D.BRANCH_ID AND
						D.IS_STORE <> 2 AND
	  				    B.BRANCH_ID IN(SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
					ORDER BY
						D.DEPARTMENT_ID
				</cfquery>
				<cfset department_name_list = listsort(listdeleteduplicates(valuelist(get_departman_name.department_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(company_id_list)>
				<cfset company_id_list = listsort(company_id_list,"numeric","ASC",",")>
				<cfquery name="get_comp_name" datasource="#dsn#">
					SELECT 
						COMPANY_ID,
						NICKNAME
					FROM
						COMPANY
					WHERE
						COMPANY_ID IN(#company_id_list#)
					ORDER BY
						COMPANY_ID
				</cfquery>
				<cfset company_id_list = listsort(listdeleteduplicates(valuelist(get_comp_name.company_id,',')),'numeric','ASC',',')>
			</cfif>
		<tbody> 			
			<cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.max_rows#">
				<tr>
					<td>#currentrow#</td>
					<td>
						<cfif purchase_sales eq 0>
							<cfswitch expression="#islem_tipi#">
								<cfcase value="761">
									<cfset url_param="#request.self#?fuseaction=stock.upd_marketplace_ship&ship_id=">
								</cfcase>
								<cfcase value="82">
									<cfset url_param = "#request.self#?fuseaction=invent.upd_purchase_invent&ship_id=">
								</cfcase>
								<cfdefaultcase>
									<cfset url_param = "#request.self#?fuseaction=stock.form_add_purchase&event=upd&ship_id=">
								</cfdefaultcase>
							</cfswitch>
						<cfelseif purchase_sales eq 1>
							<cfswitch expression="#islem_tipi#">
								<cfcase value="81">
									<cfset url_param = "#request.self#?fuseaction=stock.add_ship_dispatch&event=upd&ship_id=">
								</cfcase>
								<cfcase value="811">
									<cfset url_param="#request.self#?fuseaction=stock.upd_stock_in_from_customs&event=upd&ship_id=">
								</cfcase>
								<cfcase value="83">
									<cfset url_param = "#request.self#?fuseaction=invent.upd_invent_sale&ship_id=">
								</cfcase>
								<cfdefaultcase>
									<cfset url_param = "#request.self#?fuseaction=stock.form_add_sale&event=upd&ship_id=">
								</cfdefaultcase>
							</cfswitch>				
						<cfelse>
							<cfswitch expression="#islem_tipi#">
								<cfcase value="114">
									<cfset url_param="#request.self#?fuseaction=stock.form_add_open_fis&event=upd&upd_id=">
								</cfcase>
								<cfcase value="118">
									<cfset url_param="#request.self#?fuseaction=invent.upd_invent_stock_fis&fis_id=">
								</cfcase>
								<cfcase value="1182">
									<cfset url_param="#request.self#?fuseaction=invent.upd_invent_stock_fis_return&fis_id=">
								</cfcase>
								<cfcase value="116">
									<cfif stock_exchange_type eq 0>
										<cfset url_param="#request.self#?fuseaction=stock.form_upd_stock_exchange&exchange_id=">
									<cfelse>
										<cfset url_param="#request.self#?fuseaction=stock.form_upd_spec_exchange&exchange_id=">
									</cfif>
								</cfcase>
								<cfdefaultcase>
									<cfset url_param="#request.self#?fuseaction=stock.form_add_fis&event=upd&upd_id=">
								</cfdefaultcase>
							</cfswitch>
						</cfif>
						<cfif not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
							<a href="#url_param##ship_id#"class="tableyazi" target="_blank">#SHIP_NUMBER#</a>
						<cfelse>
							#SHIP_NUMBER#
						</cfif>
					</td>
					<td format="date">#dateformat(SHIP_DATE,dateformat_style)#</td>
					<td><cfif len(department_in) and len(location_in)>
						<cfquery name="get_lokasyon_name" datasource="#dsn#">
							SELECT COMMENT FROM STOCKS_LOCATION WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#department_in#"> AND LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#location_in#">
						</cfquery>
						#get_departman_name.department_head[listfind(department_name_list,department_in,',')]#- #get_lokasyon_name.comment#
						</cfif>
					</td>
					<td>
					<cfif isdefined('attributes.is_excel') and len(company_id_list) and attributes.is_excel eq 1 >
						#get_comp_name.nickname[listfind(company_id_list,company_id,',')]#
					<cfelseif len(company_id_list)>
						<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#company_id#','list');">
							#get_comp_name.nickname[listfind(company_id_list,company_id,',')]#
						</a>
					</cfif>
					</td>
					<cfif isdefined("x_show_ozel_kod_3") and x_show_ozel_kod_3 eq 1>
						<td style="mso-number-format:\@;">#OZEL_KOD_2#</td>
					</cfif>
					<cfif attributes.is_project eq 1>
						<td>
                        <cfif attributes.is_excel neq 1>
						<cfif len(get_total_purchase.row_project_id) and listfind(project_id_list,get_total_purchase.row_project_id,',')>
								<a href="#request.self#?fuseaction=project.projects&event=det&id=#row_project_id#" class="tableyazi">#get_project.project_head[listfind(project_id_list,get_total_purchase.row_project_id,',')]#</a>
							<cfelseif len(get_total_purchase.project_id) and listfind(project_id_list,get_total_purchase.project_id,',')>
								<a href="#request.self#?fuseaction=project.projects&event=det&id=#project_id#" class="tableyazi">#get_project.project_head[listfind(project_id_list,get_total_purchase.project_id,',')]#</a>
							</cfif> 
                            <cfelseif len(get_total_purchase.row_project_id) and listfind(project_id_list,get_total_purchase.row_project_id,',')>
                            #get_project.project_head[listfind(project_id_list,get_total_purchase.row_project_id,',')]# 
                            <cfelseif len(get_total_purchase.project_id) and listfind(project_id_list,get_total_purchase.project_id,',')>
                            #get_project.project_head[listfind(project_id_list,get_total_purchase.project_id,',')]#
                            
                            </cfif>
						</td>
					</cfif>
					<td>#STOCK_CODE#</td>
					<td>#MANUFACT_CODE#</td>
					<td>
						<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1 >
							#PRODUCT_NAME# #PROPERTY#
						<cfelse>
							<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#PRODUCT_ID#','list');">#PRODUCT_NAME# #PROPERTY#</a>
						</cfif>
					</td>
					<cfif isdefined("attributes.is_spect_info") and attributes.is_spect_info eq 1>
						<td>#spect_var_name#</td>
						<td>#spect_id#</td>
					</cfif>
					<cfif isdefined("x_show_lot_no") and x_show_lot_no eq 1>
						<td style="mso-number-format:\@;">#LOT_NO#</td>
					</cfif>
					<cfif isdefined("x_show_barcode") and x_show_barcode eq 1>
						<td style="mso-number-format:\@;">#BARCOD#</td>
					</cfif>
					<td  format="numeric">#TLFormat(PRODUCT_STOCK,4)#</td>
					<cfif attributes.is_other_money eq 1>
						<td  format="numeric">#TLFormat(price_doviz)#</td>
						<td >#other_money#</td>
					</cfif>
					<td>#BIRIM#</td>
                    <td>
                    	#TLFormat(PRICE_ROW)#
                    	<cfif len(PRICE_ROW)><cfset toplam_price_row = PRICE_ROW+toplam_price_row></cfif>    
                    </td>
					<cfif len(PRODUCT_STOCK)><cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar></cfif>
					<td  format="numeric">#TLFormat(PRICE)#</td>
					<cfif isdefined("attributes.is_money_info")>
						<cfset "toplam_#other_money#" = evaluate("toplam_#other_money#") + other_money_value>
						<td  format="numeric">#TLFormat(other_money_value)#</td>
						<td>#other_money#</td>
					</cfif>
					<td>#session.ep.money#</td>
					<cfset toplam_satis=PRICE+toplam_satis>
					<cfif attributes.is_money2 eq 1>
						<td  format="numeric">#TLFormat(PRICE_DOVIZ)#</td>
						<td>#session.ep.money2#</td>
						<cfif len(PRICE_DOVIZ)><cfset toplam_doviz=PRICE_DOVIZ+toplam_doviz></cfif>
					</cfif>
					<td  format="numeric"><cfif len(butun_toplam) and butun_toplam neq 0 and len(PRICE)>#NumberFormat(Evaluate(100*PRICE/butun_toplam),"00.00")#<cfelse>00.00</cfif></td>
					<td>#DELIVER_EMP#</td>
                </tr>
			</cfoutput>
        </tbody>
        <tfoot>
			<cfoutput>
				<tr height="20" class="color-list">
				<cfif attributes.is_spect_info eq 1 and attributes.is_project eq 1>
					<cfset colspan_ = 11>
				<cfelseif attributes.is_spect_info eq 1 and attributes.is_project neq 1>
					<cfset colspan_ = 10>
				<cfelseif attributes.is_project eq 1>
					<cfset colspan_ = 9>
				<cfelse>
					<cfset colspan_ = 8>
				</cfif>
					<td class="formbold" colspan="#colspan_#" ><cf_get_lang dictionary_id='57492.Toplam'></td>
					<td class="formbold"  format="numeric">#TLFormat(toplam_miktar)#</td>
					<cfif attributes.is_other_money eq 1>
						<td></td>
						<td></td>
					</cfif>
					<td class="formbold">&nbsp;</td>
                    <td class="formbold">#TLFormat(toplam_price_row)#</td>
					<td class="formbold"  format="numeric">#TLFormat(toplam_satis)#</td>
					<cfif isdefined("attributes.is_money_info")>
						<td class="formbold"  format="numeric">
							<cfloop query="get_money">
								<cfif evaluate("toplam_#money#") gt 0>
									#TLFormat(evaluate("toplam_#money#"))#<br/>
								</cfif>
							</cfloop>
						</td>
						<td	class="formbold">
							<cfloop query="get_money">						
								<cfif evaluate("toplam_#money#") gt 0>
									#money#<br/>
								</cfif>
							</cfloop>
						</td>
					</cfif>
					<td class="formbold">#session.ep.money#</td>
					<cfif attributes.is_money2 eq 1>
						<td class="formbold"  format="numeric">#TLFormat(toplam_doviz)#</td>
						<td class="formbold">#session.ep.money2#</td>
					</cfif>
					<td>&nbsp;</td>
                    <td>&nbsp;</td>
				</tr>
		  </cfoutput>
        </tfoot> 
		<cfelseif attributes.report_type eq 6>
        <thead>
			<tr>
				<th><cf_get_lang dictionary_id='57487.No'></th>
				<th><cf_get_lang dictionary_id='58847.Marka'></th>
				<th><cf_get_lang dictionary_id='57635.Miktar'></th>
				<cfif attributes.is_other_money eq 1>
					<th><cf_get_lang dictionary_id='57677.Doviz'></th>
					<th><cf_get_lang dictionary_id='58474.Birim'></th>
				</cfif>
				<th ><cf_get_lang dictionary_id='57673.Tutar'></th>
				<th><cf_get_lang dictionary_id='58474.Birim'></th>
				<cfif attributes.is_money2 eq 1>
					<th ><cf_get_lang dictionary_id='39656.Döviz Tutar'></th>
					<th><cf_get_lang dictionary_id='58474.Birim'></th>
				</cfif>
				<th>%</th>
			</tr>
        </thead>	
        <tbody>		  
			<cfoutput query="get_total_purchase"  startrow="#attributes.startrow#" maxrows="#attributes.max_rows#">
				<tr>
					<td >#currentrow#</td>
					<td>#brand_name#</td>
					<td  format="numeric">#TLFormat(PRODUCT_STOCK)#</td>
					<cfif len(PRODUCT_STOCK)><cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar></cfif>
					<cfif attributes.is_other_money eq 1>
						<td  format="numeric">#TLFormat(price_doviz)#</td>
						<td >#other_money#</td>
					</cfif>
					<td  format="numeric">#TLFormat(PRICE)#</td>
					<td>#session.ep.money#</td>
					<cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif>
					<cfif attributes.is_money2 eq 1>
						<td  format="numeric">#TLFormat(PRICE_DOVIZ)#</td>
						<td>#session.ep.money2#</td>
						<cfif len(PRICE_DOVIZ)><cfset toplam_doviz=PRICE_DOVIZ+toplam_doviz></cfif>
					</cfif>
					<td  format="numeric"><cfif len(butun_toplam) and butun_toplam neq 0 and len(PRICE)>#NumberFormat(Evaluate(100*PRICE/butun_toplam),"00.00")#<cfelse>00.00</cfif></td>
				</tr>
			</cfoutput>
        </tbody>  
        <tfoot>
			<cfoutput>
				<tr>
					<td class="formbold" colspan="2" ><cf_get_lang dictionary_id='57492.Toplam'></td>
					<td class="formbold" format="numeric">#TLFormat(toplam_miktar)#</td>
					<cfif attributes.is_other_money eq 1>
						<td></td>
						<td></td>
					</cfif>
					<td class="formbold"  format="numeric">#TLFormat(toplam_satis)#</td>
					<td class="formbold">#session.ep.money#</td>
					<cfif attributes.is_money2 eq 1>
						<td class="formbold"  format="numeric">#TLFormat(toplam_doviz)#</td>
						<td class="formbold">#session.ep.money2#</td>
					</cfif>
					<td></td>
				</tr>
			</cfoutput>	
          </tfoot>  
		<cfelse>
        <thead>
			<tr>
            	<th><cf_get_lang dictionary_id='57487.No'></th>
				<th><cf_get_lang dictionary_id='57486.Kategori'></th>
				<th><cf_get_lang dictionary_id='57633.Barkod'></th>
				<th><cf_get_lang dictionary_id='58800.Ürün Kodu'></th>
				<th><cf_get_lang dictionary_id='57657.Ürün'></th>
				<th><cf_get_lang dictionary_id='58448.Ürün Sorumlusu'></th>
				<th><cf_get_lang dictionary_id='57635.Miktar'></th>
				<th><cf_get_lang dictionary_id='57636.Birim'></th>
				<cfif attributes.is_other_money eq 1>
					<th ><cf_get_lang dictionary_id='57677.Doviz'></th>
					<th><cf_get_lang dictionary_id='58474.Birim'></th>
				</cfif>
				<th><cf_get_lang dictionary_id='57673.Tutar'></th>
				<th><cf_get_lang dictionary_id='58474.Birim'></th>
				<cfif attributes.is_money2 eq 1>
					<th><cf_get_lang dictionary_id='39656.Döviz Tutar'></th>
					<th><cf_get_lang dictionary_id='58474.Birim'></th>
				</cfif>
				<th>%</th>
			</tr>
		</thead>	
		<tbody>
			<cfset product_manager_list = "">
			<cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.max_rows#">
				<cfif len(product_manager) and not listfind(product_manager_list,product_manager)>
					<cfset product_manager_list=listappend(product_manager_list,product_manager)>
				</cfif>
			</cfoutput>
			<cfif len(product_manager_list)>
				<cfset product_manager_list = listsort(product_manager_list,"numeric","ASC",",")>
				<cfquery name="GET_EMP" datasource="#DSN#">
					SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME, EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE IN (#product_manager_list#) ORDER BY  POSITION_CODE
				</cfquery>
			</cfif>
			<cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.max_rows#">
				<tr>
					<td >#currentrow#</td>
					<td>#product_cat#</td>
				<cfif attributes.report_type eq 2>
					<td>#barcod#</td>
					<td>#product_code#</td>
					<td>
						<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
							#product_name#
						<cfelse>
							<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#','list');">#product_name#</a>
						</cfif>
					</td>
					<td>
						<cfif len(product_manager)>
							<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
								#get_emp.employee_name[listfind(product_manager_list,product_manager,',')]# #get_emp.employee_surname[listfind(product_manager_list,product_manager,',')]#
							<cfelse>
								<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_emp.employee_id[listfind(product_manager_list,product_manager,',')]#','list');">#get_emp.employee_name[listfind(product_manager_list,product_manager,',')]# #get_emp.employee_surname[listfind(product_manager_list,product_manager,',')]#</a>
							</cfif>
						</cfif>
					</td>
				<cfelseif attributes.report_type eq 3>
					<td>#barcod#</td>
					<td>#stock_code#</td>
					<td>
						<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1 >
							#product_name# #property#
						<cfelse>
							<a href="#request.self#?fuseaction=stock.list_stock&event=det&pid=#product_id#" class="tableyazi">#product_name# #property#</a>
						</cfif>
					</td>
					<td>
						<cfif len(product_manager)>
							<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
								#get_emp.employee_name[listfind(product_manager_list,product_manager,',')]# #get_emp.employee_surname[listfind(product_manager_list,product_manager,',')]#
							<cfelse>
								<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_emp.employee_id[listfind(product_manager_list,product_manager,',')]#','list');">#get_emp.employee_name[listfind(product_manager_list,product_manager,',')]# #get_emp.employee_surname[listfind(product_manager_list,product_manager,',')]#</a>
							</cfif>
						</cfif>
					</td>					
				</cfif>
					<td format="numeric">#TLFormat(product_stock)#</td>
					<td>#birim#</td>
					<cfif len(product_stock)><cfset toplam_miktar=product_stock+toplam_miktar></cfif>
					<cfif attributes.is_other_money eq 1>
						<td  format="numeric">#TLFormat(price_doviz)#</td>
						<td >#other_money#</td>
					</cfif>
					<td format="numeric">#TLFormat(price)#</td>
					<td>#session.ep.money#</td>
					<cfif len(price)><cfset toplam_satis=price+toplam_satis></cfif>
					<cfif attributes.is_money2 eq 1>
						<td  format="numeric">#TLFormat(price_doviz)#</td>
						<td>#session.ep.money2#</td>
						<cfif len(price_doviz)><cfset toplam_doviz=price_doviz+toplam_doviz></cfif>
					</cfif>
					<td format="numeric"><cfif len(butun_toplam) and butun_toplam neq 0 and len(price)>#NumberFormat(Evaluate(100*price/butun_toplam),"00.00")#<cfelse>00.00</cfif></td>
				</tr>
			</cfoutput>
           </tbody>
           <tfoot>		
			<cfoutput>
				<tr>
					<td class="formbold" colspan="6" ><cf_get_lang dictionary_id='57492.Toplam'></td>
					<td class="formbold" format="numeric">#TLFormat(toplam_miktar)#</td>
					<cfif attributes.is_other_money eq 1>
						<td></td>
						<td></td>
					</cfif>
					<td class="formbold"></td>
					<td class="formbold" format="numeric">#TLFormat(toplam_satis)#</td>
					<td class="formbold">#session.ep.money#</td>
					<cfif attributes.is_money2 eq 1>
						<td class="formbold" format="numeric">#TLFormat(toplam_doviz)#</td>
						<td class="formbold">#session.ep.money2#</td>
					</cfif>
					<td></td>
				</tr>
			</cfoutput>
		  </tfoot>
		
		</cfif>
		</cfif>		
	</cf_report_list>	
	<cfif  isdefined("attributes.form_submitted") and attributes.totalrecords gt attributes.max_rows>	
		<cfscript>
			str_link = "form_submitted=1";
			str_link = "#str_link#&max_rows=#attributes.max_rows#&process_type=#attributes.process_type#&report_sort=#attributes.report_sort#&product_employee_id=#attributes.product_employee_id#";
			str_link = "#str_link#&product_name=#attributes.product_name#&product_id=#attributes.product_id#&total_event=#attributes.total_event#&employee_name=#attributes.employee_name#";
			str_link = "#str_link#&keyword=#attributes.keyword#&product_id=#attributes.product_id#";
			str_link = "#str_link#&department_id=#attributes.department_id#&department_name=#attributes.department_name#&consumer_id=#attributes.consumer_id#&employee_id=#attributes.employee_id#";
			str_link = "#str_link#&company=#attributes.company#&company_id=#attributes.company_id#&product_cat=#attributes.product_cat#&search_product_catid=#attributes.search_product_catid#&hierarcy=#attributes.hierarcy#";
			str_link = "#str_link#&kdv_dahil=#attributes.kdv_dahil#&is_stock_active=#attributes.is_stock_active#&stock_status_level=#attributes.stock_status_level#&date1=#dateformat(attributes.date1,dateformat_style)#";
			str_link = "#str_link#&date2=#dateformat(attributes.date2,dateformat_style)#&report_type=#attributes.report_type#";
			str_link = "#str_link#&project_id=#attributes.project_id#&project_head=#attributes.project_head#";
			str_link = "#str_link#&kontrol_type=#attributes.kontrol_type#";
			str_link = "#str_link#&is_money2=#attributes.is_money2#";
			str_link = "#str_link#&is_excel=#attributes.is_excel#";
			str_link = "#str_link#&invoice_action=#attributes.invoice_action#";
			str_link = "#str_link#&brand_id=#attributes.brand_id#&brand_name=#attributes.brand_name#";
			str_link = "#str_link#&model_id=#attributes.model_id#&model_name=#attributes.model_name#";
			str_link = "#str_link#&ship_address=#attributes.ship_address#";
			str_link = "#str_link#&ship_method_id=#attributes.ship_method_id#&ship_method_name=#attributes.ship_method_name#";
			if(isdefined("attributes.is_money_info"))str_link = "#str_link#&is_money_info=#attributes.is_money_info#";
			if(isdefined("attributes.is_other_money"))str_link = "#str_link#&is_other_money=#attributes.is_other_money#";
			if(isdefined("attributes.is_project"))str_link = "#str_link#&is_project=#attributes.is_project#";
			if(isdefined("attributes.is_spect_info"))str_link = "#str_link#&is_spect_info=#attributes.is_spect_info#";
		</cfscript>
		<tbody>
			<tr>
				<td>
					<cf_paging 
						page="#attributes.page#" 
						maxrows="#attributes.max_rows#" 
						totalrecords="#attributes.totalrecords#" 
						startrow="#attributes.startrow#" 
						adres="#fusebox.circuit#.purchase_analyse_report_ship&#str_link#">
				</td> 
			</tr>
		</tbody>
		</cfif>	
	</cfif>  	

<script type="text/javascript">
	function set_the_report()
	{
		rapor.report_type.checked = false;
	}
	function control()
	{
		if(document.getElementById('process_type').value=='')
		{
			alert("<cf_get_lang dictionary_id='58770.işlem tipi seçiniz'>");
			return false;
		}
		else 
		{
			if(document.rapor.is_excel.checked==false)
			{
				document.rapor.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.purchase_analyse_report_ship</cfoutput>"
				return true;
			}
			else
				document.rapor.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_purchase_analyse_report_ship</cfoutput>"
		}	
		
	}
	function kontrol()
	{
		if (rapor.report_type.value == 5)
		{
			money_info_2.style.display = '';
			is_project1.style.display = '';
			is_spect_info1.style.display = '';
			rapor.kontrol_type.value = 1;
		}
		else
		{
			money_info_2.style.display = 'none';
			is_project1.style.display = 'none';
			is_spect_info1.style.display = 'none';
			rapor.kontrol_type.value = 0;
		}	
	}
	//sevk adresi
	function add_ship_adress()
	{
		if(!(rapor.company_id.value=="") || !(rapor.consumer_id.value==""))
		{
			if(rapor.company_id.value!="")
				{
					str_adrlink = '&field_long_adres=rapor.ship_address';
					if(rapor.city_id!=undefined) str_adrlink = str_adrlink+'&field_city=rapor.city_id';
					if(rapor.county_id!=undefined) str_adrlink = str_adrlink+'&field_county=rapor.county_id';
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+rapor.company.value+''+ str_adrlink , 'list');
					return true;
				}
			else
				{
					str_adrlink = '&field_long_adres=rapor.ship_address'; 
					if(rapor.city_id!=undefined) str_adrlink = str_adrlink+'&field_city=rapor.city_id';
					if(rapor.county_id!=undefined) str_adrlink = str_adrlink+'&field_county=rapor.county_id';
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&keyword='+rapor.company.value+''+ str_adrlink , 'list');
					return true;
				}
		}
		else
		{
			alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57519.Cari Hesap'>");
			return false;
		}
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
