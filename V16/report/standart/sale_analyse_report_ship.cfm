<style>
    @media only screen and (max-width: 640px),
    (min-device-width: 640px) and (max-device-width: 960px) {
    .color-border table, 
    .color-border thead, 
    .color-border tbody, 
    .color-border th, 
    .color-border td, 
    .color-border tr { 
     display: block; 
     width: 100%;
    }
</style>  
<cfparam name="attributes.module_id_control" default="20,11">
<cfinclude template="report_authority_control.cfm">
<cf_xml_page_edit fuseact="report.sale_analyse_report_ship">
<cfsetting showdebugoutput="yes">
<cfparam name="attributes.hierarcy" default="">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.process_type" default="">
<cfparam name="attributes.report_sort" default="1">
<cfparam name="attributes.brand_name" default="">
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.model_name" default="">
<cfparam name="attributes.model_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.product_employee_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.sales_employee_id" default="">
<cfparam name="attributes.sales_employee" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.ship_address" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.search_product_catid" default="">
<cfparam name="attributes.date1" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.date2" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.deliver_date1" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.deliver_date2" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.report_type" default="1">
<cfparam name="attributes.kdv_dahil" default="">
<cfparam name="attributes.member_cat_type" default="">
<cfparam name="attributes.commethod_id" default="">
<cfparam name="attributes.invoice_action" default="">
<cfparam name="attributes.kontrol" default="0">
<cfparam name="attributes.sector_cat_id" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.is_other_money" default="0">
<cfparam name="attributes.is_money2" default="0">
<cfparam name="attributes.is_project" default="">
<cf_date tarih='attributes.date1'>
<cf_date tarih='attributes.date2'>
<cfif len(attributes.deliver_date1)>
    <cf_date tarih='attributes.deliver_date1'>
</cfif>
<cfif len(attributes.deliver_date2)>
    <cf_date tarih='attributes.deliver_date2'>
</cfif>
<cfif isdefined("attributes.form_submitted")>
    <cfset kurumsal_uye = ''>
    <cfset bireysel_uye = ''>
    <cfif listlen(attributes.member_cat_type)>
        <cfset uzunluk=listlen(attributes.member_cat_type)>
        <cfloop from="1" to="#uzunluk#" index="ktyp">
            <cfset kategori = listgetat(attributes.member_cat_type,ktyp,',')>
            <cfif listlen(kategori) and listfirst(kategori,'-') eq 1>
                <cfset kurumsal_uye = listappend(kurumsal_uye,kategori)>
            <cfelseif listlen(kategori) and listfirst(kategori,'-') eq 2>
                <cfset bireysel_uye = listappend(bireysel_uye,kategori)>
            </cfif>
        </cfloop>
    </cfif>

    <cfif attributes.report_type eq 6>
        <cfset project_id_list=''>
        <cfquery name="GET_PROJECT" datasource="#DSN#">
            SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS
        </cfquery>
        <cfset project_id_list = valuelist(get_project.project_id,',')>
    </cfif>
	<cfquery name="GET_MONEY" datasource="#DSN#">
		SELECT
			MONEY,
			RATE2,
			RATE1
		FROM
			SETUP_MONEY
		WHERE
			PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
			MONEY_STATUS = 1
		ORDER BY 
			MONEY_ID
	</cfquery>
	<cfoutput query="get_money">
		<cfset 'toplam_#money#' = 0>
		<cfset 'toplam_net_doviz_#money#' = 0>
	</cfoutput>
	
    <!---<cfquery name="GET_TOTAL_PURCHASE_2"  datasource="#DSN2#">
   	<cfif not listfind('4,5,6',attributes.report_type) or listlen(kurumsal_uye) or (not listlen(kurumsal_uye) and not listlen(bireysel_uye))>
		SELECT
			 S.BRAND_ID
			 ,S.SHORT_CODE_ID
			,(SR.NETTOTAL <cfif attributes.kdv_dahil eq 1>+SR.TAXTOTAL</cfif>) AS PRICE
			<cfif attributes.is_other_money eq 1>
				,CASE WHEN(SR.SHIP_ID IN(SELECT SMM.ACTION_ID FROM SHIP_MONEY SMM))
				THEN
				SR.NETTOTAL / SM.RATE2
				ELSE
				SR.NETTOTAL / (SELECT IM.RATE2 FROM INVOICE_MONEY IM,INVOICE_SHIPS ISS WHERE IM.ACTION_ID = ISS.INVOICE_ID AND ISS.SHIP_ID = SR.SHIP_ID AND IM.MONEY_TYPE = SR.OTHER_MONEY) 
				END AS PRICE_OTHER
				,SR.OTHER_MONEY
			</cfif>
			<cfif isdefined('attributes.is_product_cost') and not listfind('4,5',attributes.report_type)>
			,( (SR.AMOUNT*PU.MULTIPLIER)* ISNULL((SELECT
					TOP 1 (PURCHASE_NET_SYSTEM_ALL + PURCHASE_EXTRA_COST_SYSTEM)
				FROM 
					#dsn3_alias#.PRODUCT_COST GET_PRODUCT_COST_PERIOD
				WHERE
					GET_PRODUCT_COST_PERIOD.START_DATE <= SHIP.SHIP_DATE AND 
                    GET_PRODUCT_COST_PERIOD.PRODUCT_ID = SR.PRODUCT_ID AND 
                    ISNULL(GET_PRODUCT_COST_PERIOD.SPECT_MAIN_ID,0)=ISNULL(SR.SPECT_VAR_ID,0)
				ORDER BY 
					GET_PRODUCT_COST_PERIOD.START_DATE DESC,
					GET_PRODUCT_COST_PERIOD.PRODUCT_COST_ID DESC
				),0)) AS PRODUCT_COST
			</cfif>
			<cfif attributes.report_type eq 1 or attributes.report_type eq 8>
			,PC.PRODUCT_CAT
			,PC.HIERARCHY
			,PC.PRODUCT_CATID
			,(SR.AMOUNT*PU.MULTIPLIER) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 2>
			,PC.PRODUCT_CAT
			,S.PRODUCT_ID
			,S.PRODUCT_NAME
			,S.BARCOD
			,S.PRODUCT_CODE
			<cfif isdefined("is_monthly_based")>
            ,MONTH(SHIP.SHIP_DATE) AS MONTH_DUE
			,CASE WHEN(SR.SHIP_ID IN(SELECT SMM.ACTION_ID FROM SHIP_MONEY SMM))
			THEN
			((SR.NETTOTAL <cfif attributes.kdv_dahil eq 1>+SR.TAXTOTAL</cfif>)/SM2.RATE2)
			ELSE
			(SR.NETTOTAL <cfif attributes.kdv_dahil eq 1>+SR.TAXTOTAL</cfif>) / (SELECT IM.RATE2 FROM INVOICE_MONEY IM,INVOICE_SHIPS ISS WHERE IM.ACTION_ID = ISS.INVOICE_ID AND ISS.SHIP_ID = SR.SHIP_ID AND IM.MONEY_TYPE = SR.OTHER_MONEY) 
			END AS DOVIZ_PRICE
			,CASE WHEN(SR.SHIP_ID IN(SELECT SMM.ACTION_ID FROM SHIP_MONEY SMM))
			THEN
			SHIP.OTHER_MONEY
			ELSE
			SR.OTHER_MONEY
			END AS MONEY
       		 </cfif>
			,(SR.AMOUNT*PU.MULTIPLIER) AS PRODUCT_STOCK
			,PU.MAIN_UNIT AS BIRIM
		<cfelseif attributes.report_type eq 11>
			,PC.PRODUCT_CAT
			,S.PRODUCT_ID
			,S.PRODUCT_NAME
			,S.BARCOD
			,S.PRODUCT_CODE
			,(SR.AMOUNT*PU.MULTIPLIER) AS PRODUCT_STOCK
			,PU.MAIN_UNIT AS BIRIM
            ,PBM.MODEL_CODE
        	,PBM.MODEL_NAME
            ,MONTH(SHIP.SHIP_DATE) AS SHIP_DATE
		<cfelseif attributes.report_type eq 3>
			,PC.PRODUCT_CAT
			,S.PRODUCT_ID
			,S.PRODUCT_NAME
			,S.BARCOD
			,S.PROPERTY
			,S.STOCK_CODE
		<cfif isdefined("is_monthly_based")>
            ,MONTH(SHIP.SHIP_DATE) AS MONTH_DUE
            ,((SR.NETTOTAL <cfif attributes.kdv_dahil eq 1>+SR.TAXTOTAL</cfif>)/SM2.RATE2) AS DOVIZ_PRICE
            ,SM2.MONEY_TYPE AS MONEY
        </cfif>
			,SR.STOCK_ID
			,(SR.AMOUNT*PU.MULTIPLIER) AS PRODUCT_STOCK
			,SR.UNIT AS BIRIM
			<cfelseif attributes.report_type eq 4>
			,C.NICKNAME AS MUSTERI
			,C.COMPANY_ID AS MUSTERI_ID
			,(SR.AMOUNT*PU.MULTIPLIER) AS PRODUCT_STOCK
			,SR.UNIT AS BIRIM
			,1 AS TYPE
			<cfelseif attributes.report_type eq 10>
			,C.NICKNAME AS MUSTERI
			,C.COMPANY_ID AS MUSTERI_ID
			,(SR.AMOUNT*PU.MULTIPLIER) AS PRODUCT_STOCK
			,SR.UNIT AS BIRIM
			,((SR.NETTOTAL <cfif attributes.kdv_dahil eq 1>+SR.TAXTOTAL</cfif>)/SM2.RATE2) AS DOVIZ_PRICE
			,SM2.MONEY_TYPE AS MONEY
			,1 AS TYPE
			<cfelseif attributes.report_type eq 5>
			,C.CITY
			,(SR.AMOUNT*PU.MULTIPLIER) AS PRODUCT_STOCK
			<cfelseif attributes.report_type eq 6>
			,SHIP.PURCHASE_SALES
			,SHIP.SHIP_ID
			,SHIP.SHIP_NUMBER
			,SHIP.SHIP_TYPE
			,SHIP.ADDRESS
			,SHIP.REF_NO
			,SHIP.PROJECT_ID
			,C.NICKNAME AS MUSTERI
			,C.COMPANY_ID AS MUSTERI_ID
			,1 AS TYPE
			,MEMBER_CODE
			,OZEL_KOD
			,SHIP.SHIP_DATE
			,PC.PRODUCT_CAT
			,PC.HIERARCHY
			,PC.PRODUCT_CATID
			,S.PRODUCT_ID
			,S.STOCK_ID
			,S.PRODUCT_NAME
			,S.PROPERTY
			,S.STOCK_CODE
			,S.MANUFACT_CODE
            ,S.PRODUCT_CODE_2
			,(SR.AMOUNT*PU.MULTIPLIER) AS PRODUCT_STOCK
			,SR.UNIT AS BIRIM
			,SR.PRICE AS BIRIM_FIYAT
			,SR.OTHER_MONEY_VALUE OTHER_MONEY_VALUE
			,SR.OTHER_MONEY OTHER_MONEY
		<cfif attributes.kdv_dahil eq 1>
            ,(SR.NETTOTAL + (SR.NETTOTAL*(SR.TAX/100))) PRICE_ROW
        <cfelse>
            ,SR.NETTOTAL PRICE_ROW
        </cfif>
			,SR.BASKET_EXTRA_INFO_ID BASKET_EXTRA_INFO_ID
			,SR.SPECT_VAR_NAME
			,(SELECT TOP 1 SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS WHERE SPECTS.SPECT_VAR_ID = SR.SPECT_VAR_ID) AS SPECT_MAIN_ID
			,SR.SHIP_ROW_ID
			,SR.ROW_PROJECT_ID
			<cfelseif attributes.report_type eq 7>
			,SR.PRICE_CAT
			,(SR.AMOUNT*PU.MULTIPLIER) AS PRODUCT_STOCK
			,PU.MAIN_UNIT AS BIRIM
			<cfelseif attributes.report_type eq 9>
			,B.BRANCH_NAME
			,B.BRANCH_ID
			,(SR.AMOUNT*PU.MULTIPLIER) AS PRODUCT_STOCK
			</cfif>
		FROM
			SHIP,
			SHIP_ROW SR	
		<cfif attributes.is_other_money eq 1>
             LEFT JOIN
			 	SHIP_MONEY SM
		    ON
                SR.SHIP_ID = SM.ACTION_ID AND 
                SM.MONEY_TYPE = SR.OTHER_MONEY
        </cfif>	
			,#dsn3_alias#.STOCKS S,
			#dsn3_alias#.PRODUCT_CAT PC,			
			#dsn3_alias#.PRODUCT_UNIT PU
			<cfif listfind('4,5,6',attributes.report_type)>
			,#dsn_alias#.COMPANY C
			<cfelseif listfind('2,3',attributes.report_type) and isdefined("is_monthly_based")>
			,#dsn2_alias#.SHIP_MONEY SM2
			<cfelseif listfind('10',attributes.report_type)>
			,#dsn_alias#.COMPANY C
			,#dsn2_alias#.SHIP_MONEY SM2
			<cfelseif attributes.report_type eq 9>
			,#dsn_alias#.DEPARTMENT D
			,#dsn_alias#.BRANCH B			
			<cfelseif attributes.report_type eq 8>
			,#dsn3_alias#.PRODUCT_CAT PC_2
			<cfelseif attributes.report_type eq 11>
        		,#dsn1_alias#.PRODUCT_BRANDS_MODEL PBM 
            </cfif>
		WHERE
			SHIP.PURCHASE_SALES = 1 AND
			SHIP.IS_SHIP_IPTAL = 0 AND 
			SHIP.SHIP_TYPE <> 81 AND
			SHIP.SHIP_TYPE <> 811 AND
			SHIP.SHIP_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"> AND
			SHIP.DELIVER_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.deliver_date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.deliver_date2#"> AND
            SR.STOCK_ID = S.STOCK_ID AND
			SHIP.SHIP_ID = SR.SHIP_ID AND	
			PU.PRODUCT_ID = S.PRODUCT_ID AND	
			S.PRODUCT_ID = SR.PRODUCT_ID AND 
			PU.PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID AND 
		<cfif attributes.is_other_money eq 1>
				(      
                    (       
                        SM.ACTION_ID IS NOT NULL            
                    )     
				OR      
                    (       
                        SM.ACTION_ID IS  NULL   AND 
                        SM.ACTION_ID = (SELECT MAX(ACTION_ID) FROM SHIP_MONEY)     
                    )     
				)  AND
		</cfif>
		<cfif listfind('4,5,6',attributes.report_type)>
			SHIP.COMPANY_ID = C.COMPANY_ID AND
		</cfif>
		<cfif attributes.report_type eq 9>
			SHIP.DELIVER_STORE_ID = D.DEPARTMENT_ID AND
			D.BRANCH_ID = B.BRANCH_ID AND 
		</cfif>
        <cfif attributes.report_type eq 11>
        	S.SHORT_CODE_ID = PBM.MODEL_ID AND
        </cfif>
		<cfif attributes.report_type eq 8>
			PC_2.PRODUCT_CATID = S.PRODUCT_CATID AND
			CHARINDEX('.',PC_2.HIERARCHY) <> 0 AND
			PC.HIERARCHY = LEFT(PC_2.HIERARCHY,(CHARINDEX('.',PC_2.HIERARCHY)-1))			
		<cfelse>
			PC.PRODUCT_CATID = S.PRODUCT_CATID
		</cfif>
		<cfif attributes.report_type eq 5>
			 AND C.CITY IS NOT NULL
		</cfif>
		<cfif len(attributes.project_id) and len(attributes.project_head)>
			AND SHIP.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
		</cfif>
		<cfif listfind('2,3',attributes.report_type) and isdefined("is_monthly_based")>
			AND SR.STOCK_ID = S.STOCK_ID
			AND PU.PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID
			AND (
				(
					SR.SHIP_ID IN(SELECT SMM.ACTION_ID FROM SHIP_MONEY SMM) AND
					SM2.ACTION_ID = SR.SHIP_ID AND
					SM2.IS_SELECTED = 1  
				)
				OR
				(
					SR.SHIP_ID NOT IN(SELECT SMM.ACTION_ID FROM SHIP_MONEY SMM)
					AND SM2.ACTION_ID = (SELECT MAX(ACTION_ID) FROM SHIP_MONEY) AND
					SM2.MONEY_TYPE = SR.OTHER_MONEY
				)
			) 
		</cfif>
		<cfif listfind('10',attributes.report_type)>
			AND SHIP.COMPANY_ID = C.COMPANY_ID  
			AND SHIP.SHIP_ID = SM2.ACTION_ID
			AND SM2.IS_SELECTED = 1  
		</cfif>
		<cfif len(attributes.process_type)>
			AND SHIP.PROCESS_CAT IN (#attributes.process_type#)
		</cfif>
		<cfif len(attributes.department_id)>
		AND(
			<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
				(SHIP.DELIVER_STORE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND SHIP.LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
				<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
			</cfloop>  
			)
		</cfif>	
		<cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>AND S.BRAND_ID IN (#attributes.brand_id#)</cfif>
		<cfif len(trim(attributes.model_name)) and len(attributes.model_id)>AND S.SHORT_CODE_ID IN (#attributes.model_id#)</cfif>
		<cfif len(attributes.company) and len(attributes.company_id) and attributes.company_id neq 0>AND SHIP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"></cfif>
		<cfif len(attributes.company) and len(attributes.consumer_id) and attributes.consumer_id neq 0>AND SHIP.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"></cfif>
		<cfif len(attributes.company) and len(attributes.employee_id)>AND SHIP.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"></cfif>
		<cfif len(attributes.company) and len(trim(attributes.ship_address))>AND SHIP.ADDRESS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.ship_address#%"></cfif>
		<cfif len(trim(attributes.product_cat)) and len(attributes.search_product_catid)>AND PC.HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.search_product_catid#%"></cfif>
		<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>AND	S.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"></cfif>		
		<cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>AND S.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_employee_id#"></cfif>
		<cfif len(trim(attributes.sales_employee)) and len(attributes.sales_employee_id)>AND SHIP.SALE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_employee_id#"></cfif>
		<cfif isdefined('attributes.commethod_id') and len(attributes.commethod_id)>
			AND SHIP.COMMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.commethod_id#">
		</cfif>
		<cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_id) and len(ship_method_name)>
			AND SHIP.SHIP_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_method_id#">
		</cfif>
		<cfif listlen(kurumsal_uye)>
			AND SHIP.COMPANY_ID IN
            (
                SELECT 
                    C.COMPANY_ID 
                FROM 
                    #dsn_alias#.COMPANY C,
                    #dsn_alias#.COMPANY_CAT CAT 
                WHERE 
                    C.COMPANYCAT_ID = CAT.COMPANYCAT_ID AND
                    (
                      <cfloop list="#kurumsal_uye#" delimiters="," index="kat_i">
                          (CAT.COMPANYCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(kat_i,'-')#">)
                          <cfif kat_i neq listlast(kurumsal_uye,',') and listlen(kurumsal_uye,',') gte 1> OR</cfif>
                      </cfloop>  
                    )
            )	
		</cfif>
		<cfif len(attributes.invoice_action) and attributes.invoice_action eq 1>
			AND SHIP.SHIP_ID IN (SELECT SHIP_ID FROM INVOICE_SHIPS WHERE SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">)
		<cfelseif len(attributes.invoice_action) and attributes.invoice_action eq 0>
			AND SHIP.SHIP_ID NOT IN (SELECT SHIP_ID FROM INVOICE_SHIPS WHERE SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">)
		</cfif>
		<cfif isdefined('attributes.sector_cat_id') and len(attributes.sector_cat_id)>
			AND	SHIP.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE SECTOR_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sector_cat_id#">)
		</cfif>

    </cfif>
    
    <cfif (not listfind('4,5,6',attributes.report_type) or (listlen(bireysel_uye) and listlen(kurumsal_uye)) or (not listlen(kurumsal_uye) and not listlen(bireysel_uye))) and (listfind('4,5,6',attributes.report_type))>
		UNION ALL
    </cfif>
    
    <cfif not listfind('4,5,6',attributes.report_type) or listlen(bireysel_uye) or (not listlen(kurumsal_uye) and not listlen(bireysel_uye))>
        SELECT DISTINCT
			S.BRAND_ID
			,S.SHORT_CODE_ID
			,( SR.NETTOTAL <cfif attributes.kdv_dahil eq 1>+SR.TAXTOTAL</cfif>) AS PRICE
			<cfif attributes.is_other_money eq 1>
				,CASE WHEN(SR.SHIP_ID IN(SELECT SMM.ACTION_ID FROM SHIP_MONEY SMM))
				THEN
				SR.NETTOTAL / SM.RATE2
				ELSE
				SR.NETTOTAL / (SELECT IM.RATE2 FROM INVOICE_MONEY IM,INVOICE_SHIPS ISS WHERE IM.ACTION_ID = ISS.INVOICE_ID AND ISS.SHIP_ID = SR.SHIP_ID AND IM.MONEY_TYPE = SR.OTHER_MONEY) 
				END AS PRICE_OTHER
				,SR.OTHER_MONEY
			</cfif>
			<cfif isdefined('attributes.is_product_cost') and not listfind('4,5',attributes.report_type)>
			,( (SR.AMOUNT*PU.MULTIPLIER)* ISNULL((SELECT
					TOP 1 (PURCHASE_NET_SYSTEM_ALL + PURCHASE_EXTRA_COST_SYSTEM)  
				FROM 
					#dsn3_alias#.PRODUCT_COST GET_PRODUCT_COST_PERIOD
				WHERE
					GET_PRODUCT_COST_PERIOD.START_DATE <= SHIP.SHIP_DATE AND 
                    GET_PRODUCT_COST_PERIOD.PRODUCT_ID = SR.PRODUCT_ID AND 
                    ISNULL(GET_PRODUCT_COST_PERIOD.SPECT_MAIN_ID,0) = ISNULL(SR.SPECT_VAR_ID,0)
				ORDER BY 
					GET_PRODUCT_COST_PERIOD.START_DATE DESC,
					GET_PRODUCT_COST_PERIOD.PRODUCT_COST_ID DESC
				),0)) AS PRODUCT_COST
			</cfif>
		<cfif attributes.report_type eq 1>
			,PC.PRODUCT_CAT
			,PC.HIERARCHY
			,PC.PRODUCT_CATID
			,(SR.AMOUNT*PU.MULTIPLIER) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 2>
			,S.PRODUCT_ID
			,S.PRODUCT_NAME
			,S.BARCOD
			,S.PRODUCT_CODE
			<cfif isdefined("is_monthly_based")>
            ,MONTH(SHIP.SHIP_DATE) AS MONTH_DUE
            ,((SR.NETTOTAL <cfif attributes.kdv_dahil eq 1>+SR.TAXTOTAL</cfif>)/SM2.RATE2) AS DOVIZ_PRICE
            ,SM2.MONEY_TYPE AS MONEY
        </cfif>
			,(SR.AMOUNT*PU.MULTIPLIER) AS PRODUCT_STOCK
			,PU.MAIN_UNIT AS BIRIM
        <cfelseif attributes.report_type eq 11>
			,PC.PRODUCT_CAT
            ,S.PRODUCT_ID
			,S.PRODUCT_NAME
			,S.BARCOD
			,S.PRODUCT_CODE
			,(SR.AMOUNT*PU.MULTIPLIER) AS PRODUCT_STOCK
			,PU.MAIN_UNIT AS BIRIM  
            ,PBM.MODEL_CODE
        	,PBM.MODEL_NAME
            ,,MONTH(SHIP.SHIP_DATE) AS SHIP_DATE 
		<cfelseif attributes.report_type eq 3>
			,S.PRODUCT_ID
			,S.PRODUCT_NAME
			,S.BARCOD
			,S.PROPERTY
			,S.STOCK_CODE
			<cfif isdefined("is_monthly_based")>
                ,MONTH(SHIP.SHIP_DATE) AS MONTH_DUE
                ,((SR.NETTOTAL <cfif attributes.kdv_dahil eq 1>+SR.TAXTOTAL</cfif>)/SM2.RATE2) AS DOVIZ_PRICE
                ,SM2.MONEY_TYPE AS MONEY
            </cfif>
			,SR.STOCK_ID
			,(SR.AMOUNT*PU.MULTIPLIER) AS PRODUCT_STOCK
			,SR.UNIT AS BIRIM
		<cfelseif attributes.report_type eq 4>
			,(C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME) AS MUSTERI
			,C.CONSUMER_ID AS MUSTERI_ID
			,(SR.AMOUNT*PU.MULTIPLIER) AS PRODUCT_STOCK
			,SR.UNIT AS BIRIM
			,0 AS TYPE
			<cfelseif attributes.report_type eq 10>
			,(C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME) AS MUSTERI
			,C.CONSUMER_ID AS MUSTERI_ID
			,(SR.AMOUNT*PU.MULTIPLIER) AS PRODUCT_STOCK
			,SR.UNIT AS BIRIM
			,((SR.NETTOTAL <cfif attributes.kdv_dahil eq 1>+SR.TAXTOTAL</cfif>)/SM2.RATE2) AS DOVIZ_PRICE
			,SM2.MONEY_TYPE AS MONEY
			,0 AS TYPE
			<cfelseif attributes.report_type eq 5>
			,C.TAX_CITY_ID AS CITY
			,(SR.AMOUNT*PU.MULTIPLIER) AS PRODUCT_STOCK
			<cfelseif attributes.report_type eq 6>
			,SHIP.PURCHASE_SALES
			,SHIP.SHIP_ID
			,SHIP.SHIP_NUMBER
			,SHIP.SHIP_TYPE
			,SHIP.ADDRESS
			,SHIP.REF_NO
			,SHIP.PROJECT_ID
			,(C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME) AS MUSTERI
			,C.CONSUMER_ID AS MUSTERI_ID
			,0 AS TYPE
			,MEMBER_CODE
			,OZEL_KOD
			,SHIP.SHIP_DATE
			,PC.PRODUCT_CAT
			,PC.HIERARCHY
			,PC.PRODUCT_CATID
			,S.PRODUCT_ID
			,S.STOCK_ID
			,S.PRODUCT_NAME
			,S.PROPERTY
			,S.STOCK_CODE
			,S.MANUFACT_CODE
            ,S.PRODUCT_CODE_2
			,(SR.AMOUNT*PU.MULTIPLIER) AS PRODUCT_STOCK
			,SR.UNIT AS BIRIM
			,SR.PRICE AS BIRIM_FIYAT
			,SR.OTHER_MONEY_VALUE OTHER_MONEY_VALUE
			,SR.OTHER_MONEY OTHER_MONEY
		<cfif attributes.kdv_dahil eq 1>
            ,(SR.NETTOTAL + (SR.NETTOTAL*(SR.TAX/100))) PRICE_ROW
        <cfelse>
            ,SR.NETTOTAL PRICE_ROW
        </cfif>
			,SR.BASKET_EXTRA_INFO_ID BASKET_EXTRA_INFO_ID
			,SR.SPECT_VAR_NAME
			,(SELECT TOP 1 SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS WHERE SPECTS.SPECT_VAR_ID = SR.SPECT_VAR_ID) AS SPECT_MAIN_ID
			,SR.SHIP_ROW_ID
			,SR.ROW_PROJECT_ID
			<cfelseif attributes.report_type eq 7>
			,SR.PRICE_CAT
			,(SR.AMOUNT*PU.MULTIPLIER) AS PRODUCT_STOCK
			,PU.MAIN_UNIT AS BIRIM
			</cfif>
		FROM
			SHIP,
			SHIP_ROW SR	
		<cfif attributes.is_other_money eq 1>
               LEFT JOIN SHIP_MONEY SM ON SR.SHIP_ID = SM.ACTION_ID AND SM.MONEY_TYPE = SR.OTHER_MONEY
        </cfif>		
			,#dsn3_alias#.STOCKS S,
			#dsn3_alias#.PRODUCT_CAT PC,
			#dsn3_alias#.PRODUCT_UNIT PU
			<cfif listfind('4,5,6',attributes.report_type)>
			,#dsn_alias#.CONSUMER C
			<cfelseif listfind('2,3',attributes.report_type) and isdefined("is_monthly_based")>
			,#dsn2_alias#.SHIP_MONEY SM2
			<cfelseif listfind('10',attributes.report_type)>
			,#dsn_alias#.CONSUMER C
			,#dsn2_alias#.SHIP_MONEY SM2
			<cfelseif attributes.report_type eq 11>
        		,#dsn1_alias#.PRODUCT_BRANDS_MODEL PBM 
            </cfif>
		WHERE
			SHIP.PURCHASE_SALES = 1 AND
			SHIP.IS_SHIP_IPTAL = 0 AND 
			SHIP.SHIP_TYPE <> 81 AND
			SHIP.SHIP_TYPE <> 811 AND
			SHIP.SHIP_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"> AND
			SHIP.DELIVER_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.deliver_date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.deliver_date2#"> AND
            SR.STOCK_ID = S.STOCK_ID AND	
			SHIP.SHIP_ID = SR.SHIP_ID AND	
			PU.PRODUCT_ID = S.PRODUCT_ID AND	
			S.PRODUCT_ID = SR.PRODUCT_ID AND 
			PU.PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID AND 
			PC.PRODUCT_CATID = S.PRODUCT_CATID 
		<cfif attributes.is_other_money eq 1>
			AND	
                (      
                    (       
                        SM.ACTION_ID IS NOT NULL            
                    )     
				OR      
                    (       
                        SM.ACTION_ID IS  NULL   AND 
                        SM.ACTION_ID = (SELECT MAX(ACTION_ID) FROM SHIP_MONEY)     
                    )     
				)  
		</cfif>
		<cfif attributes.report_type eq 5>
			 AND C.TAX_CITY_ID IS NOT NULL
		</cfif>
         <cfif attributes.report_type eq 11>
        	S.SHORT_CODE_ID = PBM.MODEL_ID AND
        </cfif>
		<cfif listfind('4,5,6',attributes.report_type)>
			AND SHIP.CONSUMER_ID = C.CONSUMER_ID  
		</cfif>
		<cfif listfind('2,3',attributes.report_type) and isdefined("is_monthly_based")>
			AND SR.STOCK_ID = S.STOCK_ID
			AND PU.PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID
			(
				(
					SR.SHIP_ID IN(SELECT SMM.ACTION_ID FROM SHIP_MONEY SMM) AND
					SM2.ACTION_ID = SR.SHIP_ID AND
					SM2.IS_SELECTED = 1  
				)
				OR
				(
					SR.SHIP_ID NOT IN(SELECT SMM.ACTION_ID FROM SHIP_MONEY SMM)
					AND SM.ACTION_ID = (SELECT MAX(ACTION_ID) FROM SHIP_MONEY) AND
					SM.MONEY_TYPE = SHIP.OTHER_MONEY
				)
			) AND
		</cfif>
		<cfif listfind('10',attributes.report_type)>
			AND SHIP.CONSUMER_ID = C.CONSUMER_ID  
			AND SHIP.SHIP_ID = SM2.ACTION_ID
			AND SM2.IS_SELECTED = 1  
		</cfif>
		<cfif len(attributes.process_type)>
			AND SHIP.PROCESS_CAT IN (#attributes.process_type#)
		</cfif>
		<cfif len(attributes.department_id)>
            AND(
            <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                (SHIP.DELIVER_STORE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND SHIP.LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
                <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
            </cfloop>  
                )
		</cfif>	
		<cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)> AND S.BRAND_ID IN (#attributes.brand_id#)</cfif>		
		<cfif len(trim(attributes.model_name)) and len(attributes.model_id)>AND S.SHORT_CODE_ID IN (#attributes.model_id#)</cfif>
		<cfif len(attributes.company) and len(attributes.company_id) and attributes.company_id neq 0>AND SHIP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"></cfif>
		<cfif len(attributes.company) and len(attributes.consumer_id) and attributes.consumer_id neq 0>AND SHIP.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"></cfif>
		<cfif len(attributes.company) and len(attributes.employee_id)>AND SHIP.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"></cfif>
		<cfif len(attributes.company) and len(trim(attributes.ship_address))>AND SHIP.ADDRESS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.ship_address#%"></cfif>
		<cfif len(trim(attributes.product_cat)) and len(attributes.search_product_catid)>AND PC.HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.search_product_catid#%"></cfif>
		<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>AND	S.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"></cfif>		
		<cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
			AND S.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_employee_id#">
		</cfif>
		<cfif len(trim(attributes.sales_employee)) and len(attributes.sales_employee_id)>AND SHIP.SALE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_employee_id#"></cfif>
		<cfif isdefined('attributes.commethod_id') and len(attributes.commethod_id)>
			AND SHIP.COMMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.commethod_id#">
		</cfif>
		<cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_id) and len(ship_method_name)>
			AND SHIP.SHIP_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_method_id#">
		</cfif>
		<cfif listlen(bireysel_uye)>
			AND SHIP.CONSUMER_ID IN
				(
				SELECT 
					C.CONSUMER_ID 
				FROM 
					#dsn_alias#.CONSUMER C,
					#dsn_alias#.CONSUMER_CAT CAT 
				WHERE 
					C.CONSUMER_CAT_ID = CAT.CONSCAT_ID AND
					(
						<cfloop list="#bireysel_uye#" delimiters="," index="kat_j">
							(CAT.CONSCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(kat_j,'-')#">)
							<cfif kat_j neq listlast(bireysel_uye,',') and listlen(bireysel_uye,',') gte 1> OR</cfif>
						</cfloop>
					)
				)
		</cfif>
		<cfif len(attributes.invoice_action) and attributes.invoice_action eq 1>
			AND SHIP.SHIP_ID IN (SELECT SHIP_ID FROM INVOICE_SHIPS WHERE SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">)
		<cfelseif len(attributes.invoice_action) and attributes.invoice_action eq 0>
			AND SHIP.SHIP_ID NOT IN (SELECT SHIP_ID FROM INVOICE_SHIPS WHERE SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">)
		</cfif>
		<cfif isdefined('attributes.sector_cat_id') and len(attributes.sector_cat_id)>
			AND	SHIP.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER WHERE SECTOR_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sector_cat_id#">)
		</cfif>
	</cfif>
	<cfif listfind('4,6',attributes.report_type) and not listlen(bireysel_uye) and not listlen(kurumsal_uye)>
		UNION ALL
		
        SELECT DISTINCT
			S.BRAND_ID
			,S.SHORT_CODE_ID
			,( SR.NETTOTAL <cfif attributes.kdv_dahil eq 1>+SR.TAXTOTAL</cfif>) AS PRICE
			<cfif attributes.is_other_money eq 1>
				,CASE WHEN(SR.SHIP_ID IN(SELECT SMM.ACTION_ID FROM SHIP_MONEY SMM))
				THEN
				SR.NETTOTAL / SM.RATE2
				ELSE
				SR.NETTOTAL / (SELECT IM.RATE2 FROM INVOICE_MONEY IM,INVOICE_SHIPS ISS WHERE IM.ACTION_ID = ISS.INVOICE_ID AND ISS.SHIP_ID = SR.SHIP_ID AND IM.MONEY_TYPE = SR.OTHER_MONEY) 
				END AS PRICE_OTHER
				,SR.OTHER_MONEY
			</cfif>
			<cfif isdefined('attributes.is_product_cost') and not listfind('4,5',attributes.report_type)>
			,( (SR.AMOUNT*PU.MULTIPLIER)* ISNULL((SELECT
					TOP 1 (PURCHASE_NET_SYSTEM_ALL + PURCHASE_EXTRA_COST_SYSTEM)  
				FROM 
					#dsn3_alias#.PRODUCT_COST GET_PRODUCT_COST_PERIOD
				WHERE
					GET_PRODUCT_COST_PERIOD.START_DATE <= SHIP.SHIP_DATE AND 
                    GET_PRODUCT_COST_PERIOD.PRODUCT_ID = SR.PRODUCT_ID AND 
                    ISNULL(GET_PRODUCT_COST_PERIOD.SPECT_MAIN_ID,0) = ISNULL(SR.SPECT_VAR_ID,0)
				ORDER BY 
					GET_PRODUCT_COST_PERIOD.START_DATE DESC,
					GET_PRODUCT_COST_PERIOD.PRODUCT_COST_ID DESC
				),0)) AS PRODUCT_COST
			</cfif>
			<cfif attributes.report_type eq 1>
			,PC.PRODUCT_CAT
			,PC.HIERARCHY
			,PC.PRODUCT_CATID
			,(SR.AMOUNT*PU.MULTIPLIER) AS PRODUCT_STOCK
			<cfelseif attributes.report_type eq 2>
                ,S.PRODUCT_ID
                ,S.PRODUCT_NAME
                ,S.BARCOD
                ,S.PRODUCT_CODE
                <cfif isdefined("is_monthly_based")>
                    ,MONTH(SHIP.SHIP_DATE) AS MONTH_DUE
                    ,((SR.NETTOTAL <cfif attributes.kdv_dahil eq 1>+SR.TAXTOTAL</cfif>)/SM2.RATE2) AS DOVIZ_PRICE
                    ,SM2.MONEY_TYPE AS MONEY
                </cfif>
                ,(SR.AMOUNT*PU.MULTIPLIER) AS PRODUCT_STOCK
                ,PU.MAIN_UNIT AS BIRIM
			<cfelseif attributes.report_type eq 11>
                ,PC.PRODUCT_CAT
                ,S.PRODUCT_ID
                ,S.PRODUCT_NAME
                ,S.BARCOD
                ,S.PRODUCT_CODE
                ,(SR.AMOUNT*PU.MULTIPLIER) AS PRODUCT_STOCK
                ,PU.MAIN_UNIT AS BIRIM
                ,PBM.MODEL_CODE
       			,PBM.MODEL_NAME
                ,MONTH(SHIP.SHIP_DATE) AS SHIP_DATE
			<cfelseif attributes.report_type eq 3>
                ,S.PRODUCT_ID
                ,S.PRODUCT_NAME
                ,S.BARCOD
                ,S.PROPERTY
                ,S.STOCK_CODE
                <cfif isdefined("is_monthly_based")>
                    ,MONTH(SHIP.SHIP_DATE) AS MONTH_DUE
                    ,((SR.NETTOTAL <cfif attributes.kdv_dahil eq 1>+SR.TAXTOTAL</cfif>)/SM2.RATE2) AS DOVIZ_PRICE
                    ,SM2.MONEY_TYPE AS MONEY
                </cfif>
                ,SR.STOCK_ID
                ,(SR.AMOUNT*PU.MULTIPLIER) AS PRODUCT_STOCK
                ,SR.UNIT AS BIRIM
			<cfelseif attributes.report_type eq 4>
			,(EMP.EMPLOYEE_NAME+ ' ' + EMP.EMPLOYEE_SURNAME) AS MUSTERI
			,EMP.EMPLOYEE_ID AS MUSTERI_ID
			,(SR.AMOUNT*PU.MULTIPLIER) AS PRODUCT_STOCK
			,SR.UNIT AS BIRIM
			,-1 AS TYPE
			<cfelseif attributes.report_type eq 10>
			,(EMP.EMPLOYEE_NAME+ ' ' + EMP.EMPLOYEE_SURNAME) AS MUSTERI
			,EMP.EMPLOYEE_ID AS MUSTERI_ID
			,(SR.AMOUNT*PU.MULTIPLIER) AS PRODUCT_STOCK

			,SR.UNIT AS BIRIM
			,((SR.NETTOTAL <cfif attributes.kdv_dahil eq 1>+SR.TAXTOTAL</cfif>)/SM2.RATE2) AS DOVIZ_PRICE
			,SM2.MONEY_TYPE AS MONEY
			,-1 AS TYPE
			<cfelseif attributes.report_type eq 6>
			,SHIP.PURCHASE_SALES
			,SHIP.SHIP_ID
			,SHIP.SHIP_NUMBER
			,SHIP.SHIP_TYPE
			,SHIP.ADDRESS
			,SHIP.REF_NO
			,SHIP.PROJECT_ID
			,(EMP.EMPLOYEE_NAME+ ' ' + EMP.EMPLOYEE_SURNAME) AS MUSTERI
			,EMP.EMPLOYEE_ID AS MUSTERI_ID
			,-1 AS TYPE
			,MEMBER_CODE
			,OZEL_KOD
			,SHIP.SHIP_DATE
			,PC.PRODUCT_CAT
			,PC.HIERARCHY
			,PC.PRODUCT_CATID
			,S.PRODUCT_ID
			,S.STOCK_ID
			,S.PRODUCT_NAME
			,S.PROPERTY
			,S.STOCK_CODE
			,S.MANUFACT_CODE
            ,S.PRODUCT_CODE_2
			,(SR.AMOUNT*PU.MULTIPLIER) AS PRODUCT_STOCK
			,SR.UNIT AS BIRIM
			,SR.PRICE AS BIRIM_FIYAT
			,SR.OTHER_MONEY_VALUE OTHER_MONEY_VALUE
			,SR.OTHER_MONEY OTHER_MONEY
			<cfif attributes.kdv_dahil eq 1>
                ,(SR.NETTOTAL + (SR.NETTOTAL*(SR.TAX/100))) PRICE_ROW
            <cfelse>
                ,SR.NETTOTAL PRICE_ROW
            </cfif>
                ,SR.BASKET_EXTRA_INFO_ID BASKET_EXTRA_INFO_ID
                ,SR.SPECT_VAR_NAME
                ,(SELECT TOP 1 SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS WHERE SPECTS.SPECT_VAR_ID = SR.SPECT_VAR_ID) AS SPECT_MAIN_ID
                ,SR.SHIP_ROW_ID
                ,SR.ROW_PROJECT_ID
			<cfelseif attributes.report_type eq 7>
                ,SR.PRICE_CAT
                ,(SR.AMOUNT*PU.MULTIPLIER) AS PRODUCT_STOCK
                ,PU.MAIN_UNIT AS BIRIM
			<cfelseif attributes.report_type eq 11>
        		,#dsn1_alias#.PRODUCT_BRANDS_MODEL PBM 
            </cfif>
		FROM
			SHIP,
			SHIP_ROW SR	
			<cfif attributes.is_other_money eq 1>
              LEFT JOIN SHIP_MONEY SM ON SR.SHIP_ID = SM.ACTION_ID AND SM.MONEY_TYPE = SR.OTHER_MONEY
            </cfif>		
            ,#dsn3_alias#.STOCKS S,
			#dsn3_alias#.PRODUCT_CAT PC,
			#dsn3_alias#.PRODUCT_UNIT PU
			<cfif listfind('4,5,6',attributes.report_type)>
				,#dsn_alias#.EMPLOYEES EMP
			<cfelseif listfind('2,3',attributes.report_type) and isdefined("is_monthly_based")>
				,#dsn2_alias#.SHIP_MONEY SM2
			<cfelseif listfind('10',attributes.report_type)>
				,#dsn_alias#.EMPLOYEES EMP
				,#dsn2_alias#.SHIP_MONEY SM2
			</cfif>
		WHERE
			SHIP.PURCHASE_SALES = 1 AND
			SHIP.IS_SHIP_IPTAL = 0 AND 
			SHIP.SHIP_TYPE <> 81 AND
			SHIP.SHIP_TYPE <> 811 AND
			SHIP.SHIP_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"> AND
			SHIP.DELIVER_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.deliver_date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.deliver_date2#"> AND
            SR.STOCK_ID = S.STOCK_ID AND	
			SHIP.SHIP_ID = SR.SHIP_ID AND	
			PU.PRODUCT_ID = S.PRODUCT_ID AND	
			S.PRODUCT_ID = SR.PRODUCT_ID AND 
			PU.PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID AND 
			PC.PRODUCT_CATID = S.PRODUCT_CATID
		<cfif attributes.is_other_money eq 1>
			AND	
                (      
                    (       
                        SM.ACTION_ID IS NOT NULL            
                    )     
				OR      
                    (       
                        SM.ACTION_ID IS  NULL   AND 
                        SM.ACTION_ID = (SELECT MAX(ACTION_ID) FROM SHIP_MONEY)     
                    )     
				) 
		</cfif>
		<cfif attributes.report_type eq 5>
			 AND C.TAX_CITY_ID IS NOT NULL
		</cfif>
        <cfif attributes.report_type eq 11>
        	S.SHORT_CODE_ID = PBM.MODEL_ID AND
        </cfif>
		<cfif listfind('4,5,6',attributes.report_type)>
			AND SHIP.EMPLOYEE_ID = EMP.EMPLOYEE_ID  
		</cfif>
		<cfif listfind('2,3',attributes.report_type) and isdefined("is_monthly_based")>
			AND SR.STOCK_ID = S.STOCK_ID
			AND PU.PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID
			(
				(
					SR.SHIP_ID IN(SELECT SMM.ACTION_ID FROM SHIP_MONEY SMM) AND
					SM2.ACTION_ID = SR.SHIP_ID AND
					SM2.IS_SELECTED = 1  
				)
				OR
				(
					SR.SHIP_ID NOT IN(SELECT SMM.ACTION_ID FROM SHIP_MONEY SMM)
					AND SM.ACTION_ID = (SELECT MAX(ACTION_ID) FROM SHIP_MONEY) AND
					SM.MONEY_TYPE = SHIP.OTHER_MONEY
				)
			) AND
		</cfif>
		<cfif listfind('10',attributes.report_type)>
			AND SHIP.EMPLOYEE_ID = EMP.EMPLOYEE_ID 
			AND SHIP.SHIP_ID = SM2.ACTION_ID
			AND SM2.IS_SELECTED = 1  
		</cfif>
		<cfif len(attributes.process_type)>
			AND SHIP.PROCESS_CAT IN (#attributes.process_type#)
		</cfif>
		<cfif len(attributes.department_id)>
		AND(
		<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
			(SHIP.DELIVER_STORE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND SHIP.LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
			<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
		</cfloop>  
			)
		</cfif>	
		<cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)> AND S.BRAND_ID IN (#attributes.brand_id#)</cfif>		
		<cfif len(trim(attributes.model_name)) and len(attributes.model_id)>AND S.SHORT_CODE_ID IN (#attributes.model_id#)</cfif>
		<cfif len(attributes.company) and len(attributes.company_id) and attributes.company_id neq 0>AND SHIP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"></cfif>
		<cfif len(attributes.company) and len(attributes.consumer_id) and attributes.consumer_id neq 0>AND SHIP.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"></cfif>
		<cfif len(attributes.company) and len(attributes.employee_id)>AND SHIP.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"></cfif>
		<cfif len(attributes.company) and len(trim(attributes.ship_address))>AND SHIP.ADDRESS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.ship_address#%"></cfif>
		<cfif len(trim(attributes.product_cat)) and len(attributes.search_product_catid)>AND PC.HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.search_product_catid#%"></cfif>
		<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>AND	S.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"></cfif>		
		<cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
			AND S.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_employee_id#">
		</cfif>
		<cfif len(trim(attributes.sales_employee)) and len(attributes.sales_employee_id)>AND SHIP.SALE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_employee_id#"></cfif>
		<cfif isdefined('attributes.commethod_id') and len(attributes.commethod_id)>
			AND SHIP.COMMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.commethod_id#">
		</cfif>
		<cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_id) and len(ship_method_name)>
			AND SHIP.SHIP_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_method_id#">
		</cfif>
		<cfif len(attributes.invoice_action) and attributes.invoice_action eq 1>
			AND SHIP.SHIP_ID IN (SELECT SHIP_ID FROM INVOICE_SHIPS WHERE SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">)
		<cfelseif len(attributes.invoice_action) and attributes.invoice_action eq 0>
			AND SHIP.SHIP_ID NOT IN (SELECT SHIP_ID FROM INVOICE_SHIPS WHERE SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">)
		</cfif>
	</cfif>
	</cfquery>--->
    
    <cfquery name="GET_TOTAL_PURCHASE_2"  datasource="#DSN2#">
		SELECT
			 S.BRAND_ID
			 ,S.SHORT_CODE_ID
			,(SR.NETTOTAL <cfif attributes.kdv_dahil eq 1>+SR.TAXTOTAL</cfif>) AS PRICE
			<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
				,CASE WHEN(SR.SHIP_ID IN(SELECT SMM.ACTION_ID FROM SHIP_MONEY SMM))
				THEN
				SR.NETTOTAL / SM.RATE2
				ELSE
				SR.NETTOTAL / (SELECT IM.RATE2 FROM INVOICE_MONEY IM,INVOICE_SHIPS ISS WHERE IM.ACTION_ID = ISS.INVOICE_ID AND ISS.SHIP_ID = SR.SHIP_ID AND IM.MONEY_TYPE = SR.OTHER_MONEY) 
				END AS PRICE_OTHER
				,<cfif attributes.is_money2>'#session.ep.money2#'<cfelse>SR.OTHER_MONEY</cfif> AS OTHER_MONEY
			</cfif>
			<cfif isdefined('attributes.is_product_cost') and not listfind('4,5',attributes.report_type)>
			,( (SR.AMOUNT*PU.MULTIPLIER)* ISNULL((SELECT
					TOP 1 (PURCHASE_NET_SYSTEM_ALL + PURCHASE_EXTRA_COST_SYSTEM)
				FROM 
					#dsn3_alias#.PRODUCT_COST GET_PRODUCT_COST_PERIOD
				WHERE
					GET_PRODUCT_COST_PERIOD.START_DATE <= SHIP.SHIP_DATE AND 
                    GET_PRODUCT_COST_PERIOD.PRODUCT_ID = SR.PRODUCT_ID AND 
                    ISNULL(GET_PRODUCT_COST_PERIOD.SPECT_MAIN_ID,0)=ISNULL(SR.SPECT_VAR_ID,0)
				ORDER BY 
					GET_PRODUCT_COST_PERIOD.START_DATE DESC,
					GET_PRODUCT_COST_PERIOD.PRODUCT_COST_ID DESC
				),0)) AS PRODUCT_COST
			</cfif>
		<cfif listfind("4,6,10",attributes.report_type)>
        	,(CASE WHEN SHIP.COMPANY_ID IS NOT NULL THEN COMP.NICKNAME WHEN SHIP.CONSUMER_ID IS NOT NULL THEN CONS.CONSUMER_NAME+' '+CONS.CONSUMER_SURNAME ELSE EMP.EMPLOYEE_NAME+' '+EMP.EMPLOYEE_SURNAME END) AS MUSTERI
			,(CASE WHEN SHIP.COMPANY_ID IS NOT NULL THEN COMP.COMPANY_ID WHEN SHIP.CONSUMER_ID IS NOT NULL THEN CONS.CONSUMER_ID ELSE EMP.EMPLOYEE_ID END) AS MUSTERI_ID
            ,(CASE WHEN SHIP.COMPANY_ID IS NOT NULL  THEN 1 WHEN SHIP.CONSUMER_ID IS NOT NULL  THEN 0 ELSE -1 END) AS TYPE
         </cfif>
         <cfif attributes.report_type eq 12>
         	,CASE WHEN SHIP.COMPANY_ID IS NOT NULL THEN 
			(SELECT POSITION_CODE FROM #DSN_ALIAS#.WORKGROUP_EMP_PAR WHERE COMPANY_ID = SHIP.COMPANY_ID AND WORKGROUP_EMP_PAR.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND WORKGROUP_EMP_PAR.IS_MASTER = 1)
			ELSE 0
			END
			 AS TEMSILCI_POS_ID
             ,CASE WHEN SHIP.COMPANY_ID IS NOT NULL THEN 
			(SELECT EMPLOYEE_POSITIONS.EMPLOYEE_NAME  + ' ' + EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME AS TEMSILCI FROM #DSN_ALIAS#.WORKGROUP_EMP_PAR,#DSN_ALIAS#.EMPLOYEE_POSITIONS WHERE WORKGROUP_EMP_PAR.POSITION_CODE = EMPLOYEE_POSITIONS.POSITION_CODE AND WORKGROUP_EMP_PAR.COMPANY_ID = SHIP.COMPANY_ID AND WORKGROUP_EMP_PAR.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND WORKGROUP_EMP_PAR.IS_MASTER = 1)
			ELSE ''
			END
			 AS TEMSILCI
         </cfif>
		<cfif attributes.report_type eq 1 or attributes.report_type eq 8>
			,PC.PRODUCT_CAT
			,PC.HIERARCHY
			,PC.PRODUCT_CATID
			,(SR.AMOUNT*PU.MULTIPLIER) AS PRODUCT_STOCK
            ,(SELECT PT_2.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT_2 WHERE PT_2.IS_ADD_UNIT = 1 AND PT_2.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER_AMOUNT
		<cfelseif attributes.report_type eq 2>
			,PC.PRODUCT_CAT
			,S.PRODUCT_ID
			,S.PRODUCT_NAME
			,S.BARCOD
			,S.PRODUCT_CODE
            <!---<cfif x_show_second_unit>--->
                ,(SELECT PUNIT.ADD_UNIT FROM #dsn3_alias#.PRODUCT_UNIT PUNIT WHERE PUNIT.IS_ADD_UNIT = 1 AND PUNIT.PRODUCT_ID = S.PRODUCT_ID) UNIT2
                ,(SELECT PT.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT WHERE PT.IS_ADD_UNIT = 1 AND PT.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER
                <cfif x_unit_weight eq 1>
	                ,(SELECT PRDUNT.WEIGHT FROM #dsn3_alias#.PRODUCT_UNIT PRDUNT WHERE PRDUNT.PRODUCT_ID = S.PRODUCT_ID AND IS_MAIN = 1) AS UNIT_WEIGHT
                </cfif>
            <!---</cfif>	--->
			<cfif isdefined("is_monthly_based")>
                ,MONTH(SHIP.SHIP_DATE) AS MONTH_DUE
                ,CASE WHEN(SR.SHIP_ID IN(SELECT SMM.ACTION_ID FROM SHIP_MONEY SMM))
                THEN
                ((SR.NETTOTAL <cfif attributes.kdv_dahil eq 1>+SR.TAXTOTAL</cfif>)/SM2.RATE2)
                ELSE
                (SR.NETTOTAL <cfif attributes.kdv_dahil eq 1>+SR.TAXTOTAL</cfif>) / (SELECT IM.RATE2 FROM INVOICE_MONEY IM,INVOICE_SHIPS ISS WHERE IM.ACTION_ID = ISS.INVOICE_ID AND ISS.SHIP_ID = SR.SHIP_ID AND IM.MONEY_TYPE = SR.OTHER_MONEY) 
                END AS DOVIZ_PRICE
                ,CASE WHEN(SR.SHIP_ID IN(SELECT SMM.ACTION_ID FROM SHIP_MONEY SMM))
                THEN
                SHIP.OTHER_MONEY
                ELSE
                SR.OTHER_MONEY
                END AS MONEY
       		 </cfif>
			,(SR.AMOUNT*PU.MULTIPLIER) AS PRODUCT_STOCK
			,PU.MAIN_UNIT AS BIRIM
		<cfelseif attributes.report_type eq 11>
			,PC.PRODUCT_CAT
			,S.PRODUCT_ID
			,S.PRODUCT_NAME
			,S.BARCOD
			,S.PRODUCT_CODE
			,(SR.AMOUNT*PU.MULTIPLIER) AS PRODUCT_STOCK
			,PU.MAIN_UNIT AS BIRIM
            ,PBM.MODEL_CODE
        	,PBM.MODEL_NAME
            ,MONTH(SHIP.SHIP_DATE) AS SHIP_DATE
		<cfelseif attributes.report_type eq 3>
			,PC.PRODUCT_CAT
			,S.PRODUCT_ID
			,S.PRODUCT_NAME
			,S.BARCOD
			,S.PROPERTY
			,S.STOCK_CODE
            <!---<cfif x_show_second_unit>--->
                ,(SELECT PUNIT.ADD_UNIT FROM #dsn3_alias#.PRODUCT_UNIT PUNIT WHERE PUNIT.IS_ADD_UNIT = 1 AND PUNIT.PRODUCT_ID = S.PRODUCT_ID) UNIT2
                ,(SELECT PT.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT WHERE PT.IS_ADD_UNIT = 1 AND PT.PRODUCT_ID = S.PRODUCT_ID) MULTIPLIER
                <cfif x_unit_weight eq 1>
	                ,(SELECT PRDUNT.WEIGHT FROM #dsn3_alias#.PRODUCT_UNIT PRDUNT WHERE PRDUNT.PRODUCT_ID = S.PRODUCT_ID AND IS_MAIN = 1) AS UNIT_WEIGHT
                </cfif>
            <!---</cfif>	--->
			<cfif isdefined("is_monthly_based")>
                ,MONTH(SHIP.SHIP_DATE) AS MONTH_DUE
                ,((SR.NETTOTAL <cfif attributes.kdv_dahil eq 1>+SR.TAXTOTAL</cfif>)/SM2.RATE2) AS DOVIZ_PRICE
                ,SM2.MONEY_TYPE AS MONEY
            </cfif>
			,SR.STOCK_ID
			,(SR.AMOUNT*PU.MULTIPLIER) AS PRODUCT_STOCK
			,SR.UNIT AS BIRIM
		<cfelseif attributes.report_type eq 4 or attributes.report_type eq 12>
			,(SR.AMOUNT*PU.MULTIPLIER) AS PRODUCT_STOCK
			,SR.UNIT AS BIRIM
		<cfelseif attributes.report_type eq 10>
			,(SR.AMOUNT*PU.MULTIPLIER) AS PRODUCT_STOCK
			,SR.UNIT AS BIRIM
			,((SR.NETTOTAL <cfif attributes.kdv_dahil eq 1>+SR.TAXTOTAL</cfif>)/SM2.RATE2) AS DOVIZ_PRICE
			,SM2.MONEY_TYPE AS MONEY
		<cfelseif attributes.report_type eq 5>
			,(CASE WHEN SHIP.COMPANY_ID IS NOT NULL THEN COMP.CITY WHEN SHIP.CONSUMER_ID IS NOT NULL THEN CONS.TAX_CITY_ID ELSE '' END) AS CITY
			,(SR.AMOUNT*PU.MULTIPLIER) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 6>
			,SHIP.PURCHASE_SALES
			,SHIP.SHIP_ID
			,SHIP.SHIP_NUMBER
			,SHIP.SHIP_TYPE
			,SHIP.ADDRESS
			,SHIP.REF_NO
			,SHIP.PROJECT_ID
			,(CASE WHEN SHIP.COMPANY_ID IS NOT NULL THEN COMP.MEMBER_CODE WHEN SHIP.CONSUMER_ID IS NOT NULL THEN CONS.MEMBER_CODE ELSE EMP.MEMBER_CODE END) AS MEMBER_CODE
			,(CASE WHEN SHIP.COMPANY_ID IS NOT NULL THEN COMP.OZEL_KOD WHEN SHIP.CONSUMER_ID IS NOT NULL THEN CONS.OZEL_KOD ELSE EMP.OZEL_KOD END) AS OZEL_KOD
			,SHIP.SHIP_DATE
			,PC.PRODUCT_CAT
			,PC.HIERARCHY
			,PC.PRODUCT_CATID
			,S.PRODUCT_ID
			,S.STOCK_ID
			,S.PRODUCT_NAME
			,S.PROPERTY
			,S.STOCK_CODE
			,S.MANUFACT_CODE
            ,S.PRODUCT_CODE_2
			,(SR.AMOUNT*PU.MULTIPLIER) AS PRODUCT_STOCK
            ,(SELECT PT_2.MULTIPLIER FROM #dsn3_alias#.PRODUCT_UNIT PT_2 WHERE PT_2.IS_ADD_UNIT = 1 AND PT_2.PRODUCT_ID = S.PRODUCT_ID) AS MULTIPLIER_AMOUNT_1
			,SR.UNIT AS BIRIM
			,SR.PRICE AS BIRIM_FIYAT
			,SR.OTHER_MONEY_VALUE OTHER_MONEY_VALUE
			,SR.OTHER_MONEY OTHER_MONEY
			<cfif attributes.kdv_dahil eq 1>
                ,(SR.NETTOTAL + (SR.NETTOTAL*(SR.TAX/100))) PRICE_ROW
            <cfelse>
                ,SR.NETTOTAL PRICE_ROW
            </cfif>
			,SR.BASKET_EXTRA_INFO_ID BASKET_EXTRA_INFO_ID
			,SR.SPECT_VAR_NAME
			,(SELECT TOP 1 SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS WHERE SPECTS.SPECT_VAR_ID = SR.SPECT_VAR_ID) AS SPECT_MAIN_ID
            <cfif x_unit_weight eq 1>
	            ,(SELECT PRDUNT1.WEIGHT FROM #dsn3_alias#.PRODUCT_UNIT PRDUNT1 WHERE PRDUNT1.PRODUCT_ID = SR.PRODUCT_ID AND IS_MAIN = 1) AS UNIT_WEIGHT_1
            </cfif>
			,SR.SHIP_ROW_ID
			,SR.ROW_PROJECT_ID
		<cfelseif attributes.report_type eq 7>
			,SR.PRICE_CAT
			,(SR.AMOUNT*PU.MULTIPLIER) AS PRODUCT_STOCK
			,PU.MAIN_UNIT AS BIRIM
		<cfelseif attributes.report_type eq 9>
			,B.BRANCH_NAME
			,B.BRANCH_ID
			,(SR.AMOUNT*PU.MULTIPLIER) AS PRODUCT_STOCK
		</cfif>
		FROM
			SHIP
            <cfif listfind('4,5,6,10',attributes.report_type)>
                LEFT JOIN #dsn_alias#.COMPANY COMP ON COMP.COMPANY_ID = SHIP.COMPANY_ID 
                LEFT JOIN #dsn_alias#.CONSUMER CONS ON CONS.CONSUMER_ID = SHIP.CONSUMER_ID
                LEFT JOIN #dsn_alias#.EMPLOYEES EMP ON EMP.EMPLOYEE_ID = SHIP.EMPLOYEE_ID
			</cfif>
			,SHIP_ROW SR	
			<cfif attributes.is_other_money eq 1 or attributes.is_money2>
                 LEFT JOIN SHIP_MONEY SM ON SR.SHIP_ID = SM.ACTION_ID AND SM.MONEY_TYPE = <cfif attributes.is_money2 eq 1><cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#"><cfelse>SR.OTHER_MONEY</cfif>
            </cfif>
            <cfif listfind('2,3',attributes.report_type) and isdefined("is_monthly_based")>
            	 LEFT JOIN #dsn2_alias#.SHIP_MONEY SM2 ON SM2.ACTION_ID = SR.SHIP_ID AND SM2.IS_SELECTED = 1 
			</cfif>
            ,
            #dsn3_alias#.STOCKS S,
			#dsn3_alias#.PRODUCT_CAT PC,			
			#dsn3_alias#.PRODUCT_UNIT PU
			<cfif listfind('2,3',attributes.report_type) and isdefined("is_monthly_based")>
                
            <cfelseif listfind("10",attributes.report_type)>
                ,#dsn2_alias#.SHIP_MONEY SM2
			<cfelseif attributes.report_type eq 9>
                ,#dsn_alias#.DEPARTMENT D
                ,#dsn_alias#.BRANCH B			
			<cfelseif attributes.report_type eq 8>
                ,#dsn3_alias#.PRODUCT_CAT PC_2
			<cfelseif attributes.report_type eq 11>
        		,#dsn1_alias#.PRODUCT_BRANDS_MODEL PBM 
            </cfif>
		WHERE
			SHIP.PURCHASE_SALES = 1 AND
			SHIP.IS_SHIP_IPTAL = 0 AND 
			SHIP.SHIP_TYPE <> 81 AND
			SHIP.SHIP_TYPE <> 811 AND
			SHIP.SHIP_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"> AND
			<cfif len(attributes.deliver_date1) and len(attributes.deliver_date2)>
                SHIP.DELIVER_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.deliver_date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,attributes.deliver_date2)#"> AND
            </cfif>
            SR.STOCK_ID = S.STOCK_ID AND
			SHIP.SHIP_ID = SR.SHIP_ID AND	
			PU.PRODUCT_ID = S.PRODUCT_ID AND	
			S.PRODUCT_ID = SR.PRODUCT_ID AND 
			PU.PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID AND 
		<cfif attributes.is_other_money eq 1 or attributes.is_money2>
				(   
                    (  
                        SM.ACTION_ID IS NOT NULL            
                    )
				OR 
                    (
                        SM.ACTION_ID IS  NULL   AND 
                        SM.ACTION_ID = (SELECT MAX(ACTION_ID) FROM SHIP_MONEY)     
                    )
				)  AND
		</cfif>
		<cfif attributes.report_type eq 9>
			SHIP.DELIVER_STORE_ID = D.DEPARTMENT_ID AND
			D.BRANCH_ID = B.BRANCH_ID AND 
		</cfif>
        <cfif attributes.report_type eq 11>
        	S.SHORT_CODE_ID = PBM.MODEL_ID AND
        </cfif>
		<cfif attributes.report_type eq 8>
			PC_2.PRODUCT_CATID = S.PRODUCT_CATID AND
			CHARINDEX('.',PC_2.HIERARCHY) <> 0 AND
			PC.HIERARCHY = LEFT(PC_2.HIERARCHY,(CHARINDEX('.',PC_2.HIERARCHY)-1))			
		<cfelse>
			PC.PRODUCT_CATID = S.PRODUCT_CATID
		</cfif>
		<cfif attributes.report_type eq 5>
			 AND( COMP.CITY IS NOT NULL
             OR CONS.TAX_CITY_ID IS NOT NULL)
		</cfif>
		<cfif len(attributes.project_id) and len(attributes.project_head)>
			AND SHIP.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
		</cfif>
		<cfif listfind('2,3',attributes.report_type) and isdefined("is_monthly_based")>
			AND SR.STOCK_ID = S.STOCK_ID
			AND PU.PRODUCT_UNIT_ID = S.PRODUCT_UNIT_ID
			<!---AND (
                    (
                        SR.SHIP_ID IN(SELECT SMM.ACTION_ID FROM SHIP_MONEY SMM) AND
                        SM2.ACTION_ID = SR.SHIP_ID AND
                        SM2.IS_SELECTED = 1  
                    )
				OR
                    (
                        SR.SHIP_ID NOT IN(SELECT SMM.ACTION_ID FROM SHIP_MONEY SMM)
                        AND SM2.ACTION_ID = (SELECT MAX(ACTION_ID) FROM SHIP_MONEY) AND
                        SM2.MONEY_TYPE = SR.OTHER_MONEY
                    )
				)
			--->	 
		</cfif>
		<cfif listfind('10',attributes.report_type)>
			AND SHIP.SHIP_ID = SM2.ACTION_ID
			AND SM2.IS_SELECTED = 1  
		</cfif>
		<cfif len(attributes.process_type)>
			AND SHIP.PROCESS_CAT IN (#attributes.process_type#)
		</cfif>
		<cfif len(attributes.department_id)>
            AND(
                <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                    (SHIP.DELIVER_STORE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND SHIP.LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
                    <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                </cfloop>  
                )
		</cfif>	
		<cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>AND S.BRAND_ID IN (#attributes.brand_id#)</cfif>
		<cfif len(trim(attributes.model_name)) and len(attributes.model_id)>AND S.SHORT_CODE_ID IN (#attributes.model_id#)</cfif>
		<cfif len(attributes.company) and len(attributes.company_id) and attributes.company_id neq 0>AND SHIP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"></cfif>
		<cfif len(attributes.company) and len(attributes.consumer_id) and attributes.consumer_id neq 0>AND SHIP.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"></cfif>
		<cfif len(attributes.company) and len(attributes.employee_id)>AND SHIP.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"></cfif>
		<cfif len(attributes.company) and len(trim(attributes.ship_address))>AND SHIP.ADDRESS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.ship_address#%"></cfif>
		<cfif len(trim(attributes.product_cat)) and len(attributes.search_product_catid)>AND PC.HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.search_product_catid#%"></cfif>
		<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>AND	S.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"></cfif>		
		<cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>AND S.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_employee_id#"></cfif>
		<cfif len(trim(attributes.sales_employee)) and len(attributes.sales_employee_id)>AND SHIP.SALE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_employee_id#"></cfif>
		<cfif isdefined('attributes.commethod_id') and len(attributes.commethod_id)>
			AND SHIP.COMMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.commethod_id#">
		</cfif>
		<cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_id) and len(ship_method_name)>
			AND SHIP.SHIP_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_method_id#">
		</cfif>
		<cfif listlen(kurumsal_uye) or listlen(bireysel_uye)>
			AND (
            <cfif listlen(kurumsal_uye)>
            (
                SHIP.COMPANY_ID IN
                (
                    SELECT 
                        COMP.COMPANY_ID 
                    FROM 
                        #dsn_alias#.COMPANY COMP,
                        #dsn_alias#.COMPANY_CAT COMP_CAT 
                    WHERE 
                        COMP.COMPANYCAT_ID = COMP_CAT.COMPANYCAT_ID AND
                        (
                          <cfloop list="#kurumsal_uye#" delimiters="," index="kat_i">
                              (COMP_CAT.COMPANYCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(kat_i,'-')#">)
                              <cfif kat_i neq listlast(kurumsal_uye,',') and listlen(kurumsal_uye,',') gte 1> OR</cfif>
                          </cfloop>  
                        )
                )
             )
			</cfif>
			<cfif listlen(bireysel_uye)>
              <cfif listlen(bireysel_uye) and listlen(kurumsal_uye)>OR</cfif>
              (
              	SHIP.CONSUMER_ID IN
                    (
                    SELECT 
                        CONS.CONSUMER_ID 
                    FROM 
                        #dsn_alias#.CONSUMER CONS,
                        #dsn_alias#.CONSUMER_CAT CONS_CAT 
                    WHERE 
                        CONS.CONSUMER_CAT_ID = CONS_CAT.CONSCAT_ID AND
                        (
                            <cfloop list="#bireysel_uye#" delimiters="," index="kat_j">
                                (CONS_CAT.CONSCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(kat_j,'-')#">)
                                <cfif kat_j neq listlast(bireysel_uye,',') and listlen(bireysel_uye,',') gte 1> OR</cfif>
                            </cfloop>
                        )
                    )
              )
              </cfif>
           )
        </cfif>
		<cfif len(attributes.invoice_action) and attributes.invoice_action eq 1>
			AND SHIP.SHIP_ID IN (SELECT SHIP_ID FROM INVOICE_SHIPS WHERE SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">)
			<cfif listfind('3,6,4,2',attributes.report_type)>
            	AND SR.WRK_ROW_ID IN (SELECT WRK_ROW_RELATION_ID FROM INVOICE_ROW)
            </cfif>
		<cfelseif len(attributes.invoice_action) and attributes.invoice_action eq 0>
			<cfif listfind('3,6,4,2',attributes.report_type)>
            	AND SR.WRK_ROW_ID NOT IN (SELECT WRK_ROW_RELATION_ID FROM INVOICE_ROW WHERE WRK_ROW_RELATION_ID IS NOT NULL)
            <cfelse>
                AND SHIP.SHIP_ID NOT IN (SELECT SHIP_ID FROM INVOICE_SHIPS WHERE SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">)
            </cfif>
		</cfif>
		<cfif isdefined('attributes.sector_cat_id') and len(attributes.sector_cat_id)>
			AND	(
	            	SHIP.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE SECTOR_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sector_cat_id#">) OR
                   	SHIP.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER WHERE SECTOR_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sector_cat_id#">)
                 )
		</cfif>
    </cfquery>
	<cfquery name="GET_TOTAL_PURCHASE" dbtype="query">
		SELECT 
			SUM(PRICE) AS PRICE
			<cfif attributes.is_other_money eq 1 or attributes.is_money2>
                ,SUM(PRICE_OTHER) PRICE_OTHER,OTHER_MONEY
            </cfif>
			<cfif isdefined('attributes.is_product_cost') and not listfind('4,5',attributes.report_type)>
			,SUM(PRODUCT_COST) AS PRODUCT_COST
			</cfif>
			<cfif attributes.report_type eq 1 or attributes.report_type eq 8>
			,PRODUCT_CAT,HIERARCHY,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,MULTIPLIER_AMOUNT
			<cfelseif attributes.report_type eq 2>
			,BRAND_ID,SHORT_CODE_ID,PRODUCT_CAT,PRODUCT_ID,PRODUCT_NAME<cfif isdefined("is_monthly_based")>,PRODUCT_CODE,MONTH_DUE,DOVIZ_PRICE,MONEY</cfif>,BARCOD,BIRIM,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,PRODUCT_CODE,UNIT2,MULTIPLIER<cfif x_unit_weight eq 1>,UNIT_WEIGHT</cfif>
			<cfelseif attributes.report_type eq 11>
			,SHORT_CODE_ID,SHIP_DATE,BIRIM AS UNIT,MODEL_CODE,MODEL_NAME,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
			<cfelseif attributes.report_type eq 3>
			,BRAND_ID,SHORT_CODE_ID,PRODUCT_CAT,PRODUCT_ID,PRODUCT_NAME<cfif isdefined("is_monthly_based")>,STOCK_CODE,MONTH_DUE,DOVIZ_PRICE,MONEY</cfif>,BARCOD,STOCK_CODE
			,PROPERTY,STOCK_ID,BIRIM,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,UNIT2,MULTIPLIER<cfif x_unit_weight eq 1>,UNIT_WEIGHT</cfif>
			<cfelseif attributes.report_type eq 4>
			,MUSTERI,MUSTERI_ID,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,TYPE
			<cfelseif attributes.report_type eq 10>
			,MUSTERI,MUSTERI_ID,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,MONEY,SUM(DOVIZ_PRICE) AS DOVIZ_PRICE,TYPE
            <cfelseif attributes.report_type eq 12>
			,TEMSILCI,TEMSILCI_POS_ID,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
			<cfelseif attributes.report_type eq 5>
			,CITY,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
			<cfelseif attributes.report_type eq 6>
			,BRAND_ID,SHORT_CODE_ID,PURCHASE_SALES,SHIP_ID,SHIP_NUMBER,SHIP_TYPE,ADDRESS,REF_NO,MUSTERI,MUSTERI_ID,MEMBER_CODE,OZEL_KOD,SHIP_DATE,PRODUCT_CAT,HIERARCHY,PRODUCT_CATID,PRODUCT_ID,STOCK_ID,PRODUCT_NAME,PROPERTY,STOCK_CODE,MANUFACT_CODE,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,BIRIM,BIRIM_FIYAT,OTHER_MONEY_VALUE,OTHER_MONEY,PRICE_ROW,BASKET_EXTRA_INFO_ID,SPECT_VAR_NAME,SPECT_MAIN_ID,SHIP_ROW_ID,PROJECT_ID,ROW_PROJECT_ID,PRODUCT_CODE_2<cfif x_unit_weight eq 1>,UNIT_WEIGHT_1</cfif>,MULTIPLIER_AMOUNT_1
			<cfelseif attributes.report_type eq 7>
			,PRICE_CAT,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK	
			<cfelseif attributes.report_type eq 9>
			,BRANCH_NAME,BRANCH_ID,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK			
			</cfif>		
		FROM 
			GET_TOTAL_PURCHASE_2
		GROUP BY 
			<cfif attributes.is_other_money eq 1 or attributes.is_money2>
			OTHER_MONEY,
			</cfif>
			<cfif attributes.report_type eq 1 or attributes.report_type eq 8>
			PRODUCT_CAT,HIERARCHY,MULTIPLIER_AMOUNT
			<cfelseif attributes.report_type eq 2>
			BRAND_ID,SHORT_CODE_ID,PRODUCT_ID,PRODUCT_CAT,PRODUCT_NAME<cfif isdefined("is_monthly_based")>,PRODUCT_CODE,MONTH_DUE,DOVIZ_PRICE,MONEY</cfif>,BIRIM,BARCOD,PRODUCT_CODE,UNIT2,MULTIPLIER<cfif x_unit_weight eq 1>,UNIT_WEIGHT</cfif>
			<cfelseif attributes.report_type eq 11>
			SHORT_CODE_ID,MODEL_CODE,MODEL_NAME,BIRIM,SHIP_DATE
			<cfelseif attributes.report_type eq 3>
			BRAND_ID,SHORT_CODE_ID,PRODUCT_ID,PRODUCT_NAME<cfif isdefined("is_monthly_based")>,STOCK_CODE,MONTH_DUE,DOVIZ_PRICE,MONEY</cfif>,PRODUCT_CAT,PROPERTY,STOCK_ID,BIRIM,BARCOD,STOCK_CODE,UNIT2,MULTIPLIER<cfif x_unit_weight eq 1>,UNIT_WEIGHT</cfif>
			<cfelseif attributes.report_type eq 4>
			MUSTERI,MUSTERI_ID,BIRIM,TYPE
			<cfelseif attributes.report_type eq 10>
			MUSTERI,MUSTERI_ID,BIRIM,MONEY,TYPE
            <cfelseif attributes.report_type eq 12>
			TEMSILCI,TEMSILCI_POS_ID,BIRIM
			<cfelseif attributes.report_type eq 5>
			CITY
			<cfelseif attributes.report_type eq 6>
			PURCHASE_SALES,
			SHIP_ID,
			SHIP_NUMBER,
			SHIP_TYPE,
			ADDRESS,
			REF_NO,
			SHIP_DATE,
			PRODUCT_CAT,
			HIERARCHY,
			PRODUCT_CATID,
			PRODUCT_ID,
			STOCK_ID,
			PRODUCT_NAME,
			PROPERTY,
			STOCK_CODE,
			MANUFACT_CODE,
            PRODUCT_CODE_2,
			BIRIM,
			MUSTERI,
			MUSTERI_ID,
			TYPE,
			MEMBER_CODE,
			OZEL_KOD,
			BIRIM_FIYAT,
			OTHER_MONEY_VALUE,
			OTHER_MONEY,
			PRICE_ROW,
			BASKET_EXTRA_INFO_ID,
			SPECT_VAR_NAME,
			SPECT_MAIN_ID,
			<cfif x_unit_weight eq 1>
	            UNIT_WEIGHT_1,
            </cfif>
            MULTIPLIER_AMOUNT_1,
			SHIP_ROW_ID,
			PROJECT_ID,
			ROW_PROJECT_ID,
			BRAND_ID,
			SHORT_CODE_ID
			<cfelseif attributes.report_type eq 7>
			PRICE_CAT
			<cfelseif attributes.report_type eq 9>
			BRANCH_NAME,
			BRANCH_ID
			</cfif>	
		ORDER BY 
		<cfif attributes.kontrol eq 1>
			SHIP_NUMBER
		<cfelseif attributes.report_type eq 11>
        	SHIP_DATE
		<cfelseif attributes.report_sort eq 1>
			PRICE DESC
		<cfelse>
			<cfif attributes.report_type eq 1 or attributes.report_type eq 2 or attributes.report_type eq 3 or attributes.report_type eq 6 or attributes.report_type eq 7>
                PRODUCT_STOCK DESC
            <cfelseif attributes.report_type eq 4 or (attributes.report_type eq 10)>	
                MUSTERI,MUSTERI_ID
            <cfelseif attributes.report_type eq 12>	
                TEMSILCI,TEMSILCI_POS_ID
            <cfelseif attributes.report_type eq 5>	
                CITY
            <cfelse>
                PRODUCT_CAT,
                PRICE
            </cfif>
		</cfif>
	</cfquery>
	<cfif attributes.report_type eq 2 and isdefined("is_monthly_based")>
		<cfquery name="GET_TOTAL_PURCHASE_3" dbtype="query">
			SELECT DISTINCT
				PRODUCT_NAME,PRODUCT_CODE,PRODUCT_ID
			FROM
				GET_TOTAL_PURCHASE
		</cfquery>
	<cfelseif attributes.report_type eq 3 and isdefined("is_monthly_based")>
		<cfquery name="GET_TOTAL_PURCHASE_3" dbtype="query">
			SELECT DISTINCT
				PRODUCT_NAME,STOCK_CODE,STOCK_ID,PROPERTY
			FROM
				GET_TOTAL_PURCHASE
		</cfquery>
	</cfif>
	<cfquery name="get_all_total" dbtype="query">
		SELECT SUM(PRICE) AS PRICE FROM GET_TOTAL_PURCHASE
	</cfquery>
	<cfif len(get_all_total.PRICE)>
		<cfset butun_toplam=get_all_total.PRICE>
	<cfelse>
		<cfset butun_toplam=1>
	</cfif>	
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
<cfset toplam_satis=0>
<cfset toplam_satis_doviz=0>
<cfset toplam_miktar=0>
<cfset toplam_weight=0>
<cfset toplam_unit_weight=0>
<cfset toplam_ikinci_miktar = 0>
<cfset toplam_maliyet =0>
<cfset toplam_birim_fiyat =0>
<cfset total_price_value = 0>
<cfset toplam_multiplier = 0>
<cfset toplam_multiplier_amount_1 = 0>
<cfif attributes.report_type eq 5>
	<cfquery name="GET_CITY" datasource="#DSN#">
		SELECT CITY_ID,CITY_NAME FROM SETUP_CITY 
	</cfquery>
	<cfset city_id_list = valuelist(get_city.city_id,',')>
</cfif>
<cfquery name="get_product_units" datasource="#dsn#">
	SELECT * FROM SETUP_UNIT
</cfquery>
<cfoutput query="get_product_units">
	<cfset unit_ = filterSpecialChars(get_product_units.unit)>
    <cfset 'toplam_ikinci_#unit_#' = 0>
</cfoutput>
<cfquery name="GET_COMPANY_CAT" datasource="#DSN#">
	<!--- SELECT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT ORDER BY COMPANYCAT --->
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
	<!--- SELECT CONSCAT_ID,CONSCAT FROM CONSUMER_CAT ORDER BY HIERARCHY --->
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
<cfquery name="GET_COMMETHOD_CATS" datasource="#DSN#">
	SELECT COMMETHOD_ID,COMMETHOD FROM SETUP_COMMETHOD ORDER BY COMMETHOD
</cfquery>
<cfquery name="GET_COMPANY_SECTOR" datasource="#DSN#">
	SELECT SECTOR_CAT_ID,SECTOR_CAT FROM SETUP_SECTOR_CATS ORDER BY SECTOR_CAT
</cfquery>

<cfform name="rapor" id="rapor" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
    <input type="hidden" name="form_submitted" value="1"> 
    <cf_report_list_search title="#getLang('report',679)#">
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
                                                <cf_wrk_product_cat form_name='rapor' hierarchy_code='search_product_catid' product_cat_name='product_cat'>
                                                <input type="hidden" name="search_product_catid" id="search_product_catid" value="<cfif len(attributes.product_cat)><cfoutput>#attributes.search_product_catid#</cfoutput></cfif>">
                                                <input type="text" name="product_cat" id="product_cat" style="width:150px;" value="<cfif len(attributes.product_cat)><cfoutput>#attributes.product_cat#</cfoutput></cfif>" onKeyUp="get_product_cat();" onFocus="AutoComplete_Create('product_cat','HIERARCHY,PRODUCT_CAT','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID','productcat_id','form','3','200');">
                                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_code=rapor.search_product_catid&field_name=rapor.product_cat</cfoutput>');"></span>
                                            </div>
                                        </div>
                                    </div>    
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang_main no='217.Açıklama'>/<cf_get_lang_main no='245.Ürün'></label>
                                        <div class="col col-12 col-xs-12">
                                            <div class="input-group">
                                                <input type="hidden" name="product_id" id="product_id" <cfif len(attributes.product_name)>value="<cfoutput>#attributes.product_id#</cfoutput>"</cfif>>
                                                <input type="text" name="product_name" id="product_name" style="width:150px;" value="<cfoutput>#attributes.product_name#</cfoutput>"  onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product_autocomplete','0','PRODUCT_ID','product_id','','3','200');" autocomplete="off">
                                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="set_the_report();windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=rapor.product_id&field_name=rapor.product_name','list');"></span>
                                            </div>
                                        </div>
                                    </div> 
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang no='643.Satışı Yapan'></label>
                                        <div class="col col-12 col-xs-12">
                                            <div class="input-group">
                                                <input type="hidden" name="sales_employee_id" id="sales_employee_id" value="<cfif len(attributes.sales_employee)><cfoutput>#attributes.sales_employee_id#</cfoutput></cfif>">
                                                <input type="text" name="sales_employee" id="sales_employee" style="width:150px;" value="<cfif len(attributes.sales_employee)><cfoutput>#attributes.sales_employee#</cfoutput></cfif>" onFocus="AutoComplete_Create('sales_employee','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',0,0,0','EMPLOYEE_ID','sales_employee_id','','3','150');" maxlength="255">
                                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=rapor.sales_employee_id&field_emp_id2=rapor.sales_employee_id&field_name=rapor.sales_employee&select_list=1,9<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','list');"></span>
                                            </div>
                                        </div>
                                    </div>    
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang_main no='1036.Ürün Sorumlusu'></label>
                                        <div class="col col-12 col-xs-12">
                                            <div class="input-group">
                                                <input type="hidden" name="product_employee_id" id="product_employee_id"  value="<cfif len(attributes.employee_name)><cfoutput>#attributes.product_employee_id#</cfoutput></cfif>">
                                                <input type="text" name="employee_name" id="employee_name" style="width:150px;" value="<cfif len(attributes.employee_name)><cfoutput>#attributes.employee_name#</cfoutput></cfif>" maxlength="255" onfocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','125');">
                                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=rapor.product_employee_id&field_code=rapor.product_employee_id&field_name=rapor.employee_name&select_list=1,9','list');"></span>
                                            </div>
                                        </div>
                                    </div>    
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang_main no='107.Cari Hesap'></label>
                                        <div class="col col-12 col-xs-12">
                                            <div class="input-group">
                                                <input type="hidden" name="consumer_id" id="consumer_id" <cfif len(attributes.company)>value="<cfoutput>#attributes.consumer_id#</cfoutput>"</cfif>>			
                                                <input type="hidden" name="company_id" id="company_id" <cfif len(attributes.company)> value="<cfoutput>#attributes.company_id#</cfoutput>"</cfif>>
                                                <input type="hidden" name="employee_id" id="employee_id" <cfif len(attributes.company)> value="<cfoutput>#attributes.employee_id#</cfoutput>"</cfif>>
                                                <input type="text" name="company" id="company" style="width:150px;" value="<cfif len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>" onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',0,0,0','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID','company_id,consumer_id,employee_id','','3','150');">
                                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=1,2,3,9&field_comp_name=rapor.company&field_comp_id=rapor.company_id&field_consumer=rapor.consumer_id&field_emp_id=rapor.employee_id&field_name=rapor.company&field_member_name=rapor.company</cfoutput>&keyword='+encodeURIComponent(document.rapor.company.value),'list')"></span>
                                            </div>
                                        </div>
                                    </div>    
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang no='410.Sevk Adresi'></label>
                                        <div class="col col-12 col-xs-12">
                                            <div class="input-group">
                                                <input type="hidden" name="city_id" id="city_id" value="">
                                                <input type="hidden" name="county_id" id="county_id" value="">
                                                <input type="text" name="ship_address" id="ship_address" value="<cfif len(attributes.ship_address)><cfoutput>#attributes.ship_address#</cfoutput></cfif>" style="width:150px;"><!--- <cfoutput>#trim(attributes.ship_address)#</cfoutput> --->
                                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="add_ship_adress();"></span>
                                            </div>
                                        </div>
                                    </div>    
                                </div>
                            </div>
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
                                <div class="col col-12 col-xs-12">
                                	<div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang_main no='4.Proje'></label>
                                        <div class="col col-12 col-xs-12">
                                            <div class="input-group">
                                                <input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id')><cfoutput>#attributes.project_id#</cfoutput></cfif>">
                                                <input type="text" name="project_head" id="project_head" style="width:150px;" value="<cfif isdefined('attributes.project_head') and  len(attributes.project_head)><cfoutput>#attributes.project_head#</cfoutput></cfif>" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','150');">
                                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=rapor.project_id&project_head=rapor.project_head');"></span>
                                            </div>
                                            <div colspan="3" style="<cfif attributes.report_type neq 6>display:none;</cfif>" id="money_info_2">
                                                <input type="checkbox" name="is_money_info" id="is_money_info" width="100" value="1" <cfif isdefined("attributes.is_money_info")>checked</cfif>><cf_get_lang no='926.Döviz Göster'>
                                                <input name="is_project" id="is_project" value="1" width="100" type="checkbox" <cfif attributes.is_project eq 1 >checked</cfif>><cf_get_lang_main no='4.Proje'> <cf_get_lang_main no='1184.Göster'>
                                            </div>
                                            <div id="monthly_based" <cfif attributes.report_type neq 2 or attributes.report_type neq 3>style="display:none;"</cfif>>
                                                <label>
                                                    <input type="checkbox" name="is_monthly_based" id="is_monthly_based" value="1" <cfif isdefined("attributes.is_monthly_based")>checked</cfif>><cf_get_lang no='1977.Ay Bazında'>
                                                </label>    
                                            </div>
                                            <div id="spect_info_2">
                                                <input type="checkbox" name="is_spect_info" id="is_spect_info" value="1" <cfif isdefined("attributes.is_spect_info")>checked</cfif>><cf_get_lang no='1889.Spec Göster'>
                                            </div>
                                            <div id="ref_no" <cfif attributes.report_type neq 6>style="display:none;"</cfif>>&nbsp;
                                                <input type="checkbox" name="is_ref_no" id="is_ref_no" value="1" <cfif isdefined("attributes.is_ref_no")>checked</cfif>><cf_get_lang no='1978.Referans No Göster'>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang_main no='1435.Marka'></label>
                                        <cf_wrk_list_items table_name ='PRODUCT_BRANDS' wrk_list_object_id='BRAND_ID' wrk_list_object_name='BRAND_NAME' sub_header_name="#getLang('main',1435)#" header_name="#getLang('report',1818)#" width='150' datasource ="#dsn1#">
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang_main no='813.Model'></label>
                                        <cf_wrk_list_items table_name ='PRODUCT_BRANDS_MODEL' wrk_list_object_id='MODEL_ID' wrk_list_object_name='MODEL_NAME' sub_header_name="#getLang('main',813)#" header_name="#getLang('report',1354)#" width='150' datasource ="#dsn1#">
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang_main no='1703.Sevk Yöntemi'></label>
                                        <div class="col col-12 col-xs-12">
                                            <div class="input-group">
                                                <input type="hidden" name="ship_method_id" id="ship_method_id" value="<cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_name)><cfoutput>#attributes.ship_method_id#</cfoutput></cfif>">
                                                <input type="text" name="ship_method_name" id="ship_method_name" style="width:150px;" value="<cfif isdefined("attributes.ship_method_name") and len(attributes.ship_method_name)><cfoutput>#attributes.ship_method_name#</cfoutput></cfif>" onFocus="AutoComplete_Create('ship_method_name','SHIP_METHOD','SHIP_METHOD','get_ship_method','','SHIP_METHOD_ID','ship_method_id','','3','125');" autocomplete="off">
                                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=rapor.ship_method_name&field_id=rapor.ship_method_id','list');"></span>		
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang_main no='678.İletişim Yöntemi'></label>
                                        <div class="col col-12 col-xs-12">                         
                                            <select name="commethod_id" id="commethod_id" style="width:150px;">
                                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                <cfoutput query="get_commethod_cats">
                                                    <option value="#commethod_id#" <cfif commethod_id eq attributes.commethod_id> selected</cfif>>#commethod#</option>
                                                </cfoutput>
                                            </select>                         
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang_main no='167.Sektör'></label>
                                        <div class="col col-12 col-xs-12">
                                           <select name="sector_cat_id" style="width:150px;">
                                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                <cfoutput query="get_company_sector">
                                                    <option value="#sector_cat_id#" <cfif sector_cat_id eq attributes.sector_cat_id> selected</cfif>>#sector_cat#</option>
                                                </cfoutput>
                                            </select>
                                        </div>
                                    </div>
                                </div>             
                            </div>
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
                                <div class="col col-12 col-xs-12">
                                     <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang_main no='388.İşlem Tipi'></label>
                                        <div class="col col-12 col-xs-12">
                                            <cfquery name="GET_PROCESS_CAT" datasource="#DSN3#">
                                                SELECT PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (70,71,72,78,79,81,88,83,85) ORDER BY PROCESS_CAT
                                            </cfquery>
                                            <select name="process_type" id="process_type" style="width:175px;height:70px;" multiple>
                                                <cfoutput query="get_process_cat">
                                                <option value="#process_cat_id#" <cfif listfind(attributes.process_type,process_cat_id,',')> selected</cfif>>#process_cat#</option>
                                                </cfoutput>
                                            </select>
                                        </div> 
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang_main no='1351.Depo'></label>
                                        <div class="col col-12 col-xs-12">
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
                                                    D.IS_STORE <> 2
                                                <cfif isDefined('x_show_pasive_departments') and x_show_pasive_departments eq 0>
                                                    AND D.DEPARTMENT_STATUS = 1 
                                                </cfif>
                                            </cfquery>
                                            <cfquery name="GET_ALL_LOCATION" datasource="#DSN#">
                                                SELECT DEPARTMENT_ID,LOCATION_ID,COMMENT FROM STOCKS_LOCATION <cfif isDefined('x_show_pasive_departments') and x_show_pasive_departments eq 0>WHERE STATUS = 1</cfif>
                                            </cfquery>						
                                            <select name="department_id" multiple style="width:175px; height:70px;">
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
                                        <label class="col col-12 col-xs-12"><cf_get_lang no='521.Müşteri Kategorisi'></label>
                                        <div class="col col-12 col-xs-12">
                                            <select name="member_cat_type" style="width:176px; height:70px;" multiple>
                                                <optgroup label="<cf_get_lang_main no='627.Kurumsal Üye Kategorileri'>">
                                                    <cfoutput query="get_company_cat">
                                                    <option value="1-#companycat_id#" <cfif listfind(attributes.member_cat_type,'1-#companycat_id#',',')>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#companycat#</option>
                                                    </cfoutput>					
                                                </optgroup>
                                                <optgroup label="<cf_get_lang_main no='628.Bireysel Üye Kategorileri'>">
                                                    <cfoutput query="get_consumer_cat">
                                                    <option value="2-#conscat_id#" <cfif listfind(attributes.member_cat_type,'2-#conscat_id#',',')>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#conscat#</option>
                                                    </cfoutput>	
                                                </optgroup>
                                            </select>
                                        </div>
                                    </div>
                                </div>             
                            </div>
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
                                <div class="col col-12 col-xs-12">
                                	<div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang_main no='1278.Tarih Aralığı'>*</label>
                                        <div class="col col-6">
                                             <div class="input-group">                                    
                                                <cfsavecontent variable="message"><cf_get_lang_main no='370.Tarih Değerini Kontrol Ediniz'></cfsavecontent>
                                                <cfinput value="#dateformat(attributes.date1,dateformat_style)#" type="text" maxlength="10" name="date1" required="yes" message="#message#" validate="#validate_style#" style="width:65px;">
                                                <span class="input-group-addon">
                                                   <cf_wrk_date_image date_field="date1"> 
                                                </span>
                                             </div>
                                        </div>
                                        <div class="col col-6">
                                             <div class="input-group">
                                                <cfinput value="#dateformat(attributes.date2,dateformat_style)#"  type="text" maxlength="10" name="date2" required="yes" message="#message#" validate="#validate_style#" style="width:65px;">
                                                <span class="input-group-addon">
                                                   <cf_wrk_date_image date_field="date2">
                                                </span>   
                                             </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang no="325.Fiili Sevk Tarihi">*</label>
                                        <div class="col col-6">
                                             <div class="input-group">  
                                                <cfsavecontent variable="message"><cf_get_lang_main no='370.Tarih Değerini Kontrol Ediniz'></cfsavecontent>   <cfinput type="text" name="deliver_date1" validate="#validate_style#" value="#dateformat(attributes.deliver_date1,dateformat_style)#" required="yes" message="#message#" style="width:65px;">
                                                <span class="input-group-addon">
                                                    <cf_wrk_date_image date_field="deliver_date1"> 
                                                </span>  
                                             </div>
                                        </div>
                                         <div class="col col-6">
                                             <div class="input-group">
                                                <cfinput type="text" name="deliver_date2" validate="#validate_style#" value="#dateformat(attributes.deliver_date2,dateformat_style)#" message="#message#" style="width:65px;">
                                                <span class="input-group-addon">
                                                   <cf_wrk_date_image date_field="deliver_date2">
                                                </span>       
                                             </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang_main no='1548.Rapor Tipi'></label>
                                        <div class="col col-12 col-xs-12 col-sm-12">
                                            <select name="report_type" style="width:185px;" onChange="type_gizle();">
                                                <option value="1" <cfif attributes.report_type eq 1>selected</cfif>><cf_get_lang no='331.Kategori Bazında'></option>
                                                <option value="8" <cfif attributes.report_type eq 8>selected</cfif>><cf_get_lang no='1835.Ana Kategori'><cf_get_lang_main no='1189.Bazında'></option>
                                                <option value="2" <cfif attributes.report_type eq 2>selected</cfif>><cf_get_lang no='332.Ürün Bazında'></option>
                                                <option value="3" <cfif attributes.report_type eq 3>selected</cfif>><cf_get_lang no='333.Stok Bazında'></option>
                                                <option value="4" <cfif attributes.report_type eq 4>selected</cfif>><cf_get_lang no='536.Müşteri Bazında'></option>
                                                <option value="10" <cfif attributes.report_type eq 10>selected</cfif>><cf_get_lang no='1976.Müşteri ve Döviz Bazında'></option>
                                                <option value="5" <cfif attributes.report_type eq 5>selected</cfif>><cf_get_lang no='754.İl Bazında'></option>
                                                <option value="6" <cfif attributes.report_type eq 6>selected</cfif>><cf_get_lang no='964.Belge ve Stok Bazında'></option>
                                                <option value="7" <cfif attributes.report_type eq 7>selected</cfif>><cf_get_lang no ='1559.Fiyat Listesi Bazında'></option>
                                                <option value="9" <cfif attributes.report_type eq 9>selected</cfif>><cf_get_lang no='629.Şube Bazında'></option>
                                                <option value="11" <cfif attributes.report_type eq 11>selected</cfif>><cf_get_lang_main no='813.Model'><cf_get_lang_main no='1189.Bazında'></option>
                                                <option value="12" <cfif attributes.report_type eq 12>selected</cfif>><cf_get_lang no="542.Müşteri Temsilci Bazında"></option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label id="model_month_td"
                                            <cfif isdefined("attributes.report_type") and attributes.report_type neq 23>style="display:none;"</cfif>><input type="checkbox" name="model_month" id="model_month" value="0" <cfif isdefined("attributes.model_month")>checked</cfif>/><cf_get_lang dictionary_id='33509.Modelleri Satır Olarak Listele'>
                                        </label>                                           
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang no='494.Fatura Hareketleri'></label>
                                        <div class="col col-12 col-xs-12">
                                            <select name="invoice_action">
                                                <option selected value=""><cf_get_lang_main no='669.Hepsi'></option>
                                                <option value="1" <cfif isDefined('attributes.invoice_action') and attributes.invoice_action eq 1>selected</cfif>><cf_get_lang no='495.Faturalanmış'></option>
                                                <option value="0" <cfif isDefined('attributes.invoice_action') and attributes.invoice_action eq 0>selected</cfif>><cf_get_lang no='496.Faturalanmamış'></option>
                                            </select> 
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-xs-12"><cf_get_lang no='334.Rapor Sıra'></label>
                                        <label>
                                            <input type="hidden" name="kontrol" id="kontrol" value="0">
                                            <input type="radio" name="report_sort" id="report_sort" value="1" <cfif attributes.report_sort eq 1 and attributes.kontrol eq 0>checked</cfif>><cf_get_lang_main no='2213.Ciro'>
                                        </label>  
                                        <label>  
                                            <input type="radio" name="report_sort" id="report_sort" value="2" <cfif attributes.report_sort eq 2 and attributes.kontrol eq 0>checked</cfif>><cf_get_lang_main no='223.Miktar'>
                                        </label>                                            
                                    </div>
                                    <div class="form-group">
                                        <label>
                                            <input type="checkbox" name="kdv_dahil" id="kdv_dahil" value="1" <cfif isdefined("attributes.kdv_dahil") and (attributes.kdv_dahil eq 1)>checked</cfif>><cf_get_lang no='338.Kdv Dahil'>
                                        </label>
                                        <label>
                                            <input type="checkbox" name="is_product_cost" id="is_product_cost" value="1" <cfif isdefined("attributes.is_product_cost")>checked</cfif>><cf_get_lang_main no='846.Maliyet'>
                                        </label>
                                        <label>
                                            <input name="is_other_money" id="is_other_money" value="1" onclick="dissable_check(1);" type="checkbox" <cfif attributes.is_other_money eq 1>checked</cfif>><cf_get_lang_main no='383.İşlem Dovizli'>
                                        </label> 
                                        <label>  
                                            <cfif isdefined("session.ep.money2")><input name="is_money2" id="is_money2" value="1" onclick="dissable_check(2);" type="checkbox" <cfif attributes.is_money2 eq 1>checked = "checked"</cfif>><cfoutput>#session.ep.money2#</cfoutput><cf_get_lang_main no='1184.Göster'></cfif>
                                        </label>
                                    </div>
                                </div>
                            </div>             
                        </div>
                    </div>
                    <div class="row ReportContentBorder">
                        <div class="ReportContentFooter">
                           	<input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang_main no='446.Excel Getir'> <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
							<cf_wrk_report_search_button search_function='prod_cost_control()' button_type='1' is_excel='1'>					
					    </div>	  
					</div>
                 </div>
            </div>
            <cfif IsDefined("attributes.form_submitted") and not (isdefined('attributes.is_excel') and attributes.is_excel eq 1)>
                <cf_seperator title="#getLang('main',388)#" id="transaction_type">
                    <table class="color-border"  cellpadding="2" cellspacing="1" style="display:none; width:100%; margin-bottom:10px;" id="transaction_type" >
                        <tr class="color-row">
                            <td valign="top" nowrap="nowrap">
                                <cfif len(attributes.process_type)>
                                    <cfquery name="GET_PROCESS_CAT" datasource="#DSN3#">
                                        SELECT PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID IN (#attributes.process_type#) AND PROCESS_TYPE IN (70,71,72,78,79,81,88,83,85) ORDER BY PROCESS_CAT
                                    </cfquery>
                                <cfif get_process_cat.recordcount>
                                    <cfoutput query="get_process_cat">#process_cat#<br></cfoutput>
                                </cfif>        
                                </cfif>
                            </td>
                            <td valign="top" width="30%">
                                <cfoutput>
                                <cf_get_lang_main no='1548.Rapor Tipi'>
                                    <cfif attributes.report_type eq 1><cf_get_lang no='331.Kategori Bazında'>
                                    <cfelseif attributes.report_type eq 8><cf_get_lang no='1835. Ana Kategori'><cf_get_lang_main no='1189.Bazında'>
                                    <cfelseif attributes.report_type eq 2><cf_get_lang no='332.Ürün Bazında'>
                                    <cfelseif attributes.report_type eq 3><cf_get_lang no='333.Stok Bazında'>
                                    <cfelseif attributes.report_type eq 4><cf_get_lang no='536.Müşteri Bazında'>
                                    <cfelseif attributes.report_type eq 10><cf_get_lang no='1976.Müşteri ve Döviz Bazında'>
                                    <cfelseif attributes.report_type eq 5><cf_get_lang no='754.İl Bazında'>
                                    <cfelseif attributes.report_type eq 6><cf_get_lang no='964.Belge ve Stok Bazında'>
                                    <cfelseif attributes.report_type eq 7><cf_get_lang no ='1559.Fiyat Listesi Bazında'>
                                    <cfelseif attributes.report_type eq 9><cf_get_lang no='629.Şube Bazında'>
                                    </cfif><hr />
                                    <cf_get_lang_main no='1278.Tarih Aralığı'>:#dateformat(attributes.date1,dateformat_style)#-#dateformat(attributes.date1,dateformat_style)#<hr />
                                    <cf_get_lang_main no='4.Proje'>:#attributes.project_head#<hr />
                                    <cf_get_lang_main no='107.Cari Hesap'>:#attributes.company#<hr />	
                                </cfoutput>
                            </td>
                            <td valign="top" width="30%">
                            <cfoutput>
                                <cf_get_lang_main no='74.Kategori'>:#attributes.product_cat#<hr />
                                <cf_get_lang no='643.Satışı Yapan'>:#attributes.sales_employee#<hr />
                                <cf_get_lang_main no='1703.Sevk Yöntemi'>:#attributes.ship_method_name#<hr />
                            </cfoutput>
                            </td>
                            <td valign="top" width="30%">
                                <cfoutput>
                                <cf_get_lang_main no='217.Açıklama'>/<cf_get_lang_main no='245.Ürün'>:#attributes.product_name#<hr />
                                <cf_get_lang_main no='1435.Marka'>:#BRAND_NAME#<hr />
                                <cf_get_lang_main no='813.Model'>:#attributes.MODEL_NAME#<hr />
                                <cf_get_lang_main no='1036.Ürün Sorumlusu'>:#attributes.employee_name#<hr />
                                </cfoutput>
                            </td>
                            <td valign="top" width="50%">
                            <cfoutput>
                                <cf_get_lang no='494.Fatura Hareketleri'>:<cfif isDefined('attributes.invoice_action') and attributes.invoice_action eq 1><cf_get_lang no='495.Faturalanmış'><cfelseif isDefined('attributes.invoice_action') and attributes.invoice_action eq 0><cf_get_lang no='496.Faturalanmamış'><cfelse><cf_get_lang_main no='669.Hepsi'></cfif><hr />
                                <cf_get_lang no='334.Rapor Sıra'>:<cfif attributes.report_sort eq 1 and attributes.kontrol eq 0><cf_get_lang_main no='2213.Ciro'><cfelseif attributes.report_sort eq 2 and attributes.kontrol eq 0><cf_get_lang_main no='223.Miktar'></cfif><hr />
                                <cf_get_lang_main no='678.İletişim Yöntemi'>
                            </cfoutput>
                                <cfoutput query="get_commethod_cats">
                                    <cfif commethod_id eq attributes.commethod_id>#commethod#</cfif>
                                </cfoutput>
                            </td>
                        </tr>
                    </table>
            </cfif>
        </cf_report_list_search_area>
    </cf_report_list_search>
</cfform>
    <!--- Excel TableToExcel.convert fonksiyonu ile alındığı için kapatıldı. --->
    <!--- <cfif isdefined("attributes.form_submitted") and isdefined('attributes.is_excel') and attributes.is_excel eq 1>
        <cfset filename = "#createuuid()#">
        <cfheader name="Expires" value="#Now()#">
        <cfcontent type="application/vnd.msexcel;charset=utf-16">
        <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-16">	
    </cfif> --->
<div id="sales_list">
    <cfif isdefined("attributes.form_submitted")>
        <cf_report_list>
            <cfset price_cat_list = ''>
            <cfset basket_extra_list = ''>
            <cfif get_total_purchase.recordcount and ListFind("6,7",attributes.report_type,",")>
                <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <cfif attributes.report_type eq 7>
                        <cfif len(price_cat) and not listfind(price_cat_list,price_cat)>
                            <cfset price_cat_list = listappend(price_cat_list,price_cat)>
                        </cfif>
                    <cfelseif attributes.report_type eq 6>
                        <cfif len(basket_extra_info_id) and not listfind(basket_extra_list,basket_extra_info_id)>
                            <cfset basket_extra_list = listappend(basket_extra_list,basket_extra_info_id)>
                        </cfif>
                    </cfif>
                </cfoutput>
            </cfif>
            <cfset brand_id_list=''>
            <cfset short_code_id_list=''>
            <cfif get_total_purchase.recordcount and ListFind("2,3,6",attributes.report_type,",") and (is_brand_show eq 1 or is_short_code_show eq 1)>
                <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <cfif len(brand_id) and not listfind(brand_id_list,brand_id)>
                        <cfset brand_id_list=listappend(brand_id_list,brand_id)>
                    </cfif>
                    <cfif len(short_code_id) and not listfind(short_code_id_list,short_code_id)>
                        <cfset short_code_id_list=listappend(short_code_id_list,short_code_id)>
                    </cfif>
                </cfoutput>
                <cfif len(brand_id_list) and is_brand_show eq 1>
                    <cfset brand_id_list=listsort(brand_id_list,"numeric","ASC",",")>
                    <cfquery name="get_brand" datasource="#DSN1#">
                        SELECT BRAND_ID,BRAND_NAME FROM PRODUCT_BRANDS WHERE BRAND_ID IN (#brand_id_list#) ORDER BY BRAND_ID
                    </cfquery>
                    <cfset brand_id_list = listsort(listdeleteduplicates(valuelist(get_brand.BRAND_ID,',')),"numeric","ASC",",")>
                </cfif>
                <cfif len(short_code_id_list) and is_short_code_show eq 1>
                    <cfset short_code_id_list=listsort(short_code_id_list,"numeric","ASC",",")>
                    <cfquery name="get_model" datasource="#DSN1#">
                        SELECT MODEL_NAME,MODEL_ID FROM PRODUCT_BRANDS_MODEL WHERE MODEL_ID IN (#short_code_id_list#) ORDER BY MODEL_ID
                    </cfquery>
                    <cfset short_code_id_list = listsort(listdeleteduplicates(valuelist(get_model.MODEL_ID,',')),"numeric","ASC",",")>
                </cfif>
            </cfif>
            <cfif attributes.report_type eq 7>
                <cfif len(price_cat_list)>
                    <cfset price_cat_list=listsort(price_cat_list,"numeric","ASC",",")>
                    <cfquery name="get_price_cat" datasource="#DSN3#">
                        SELECT PRICE_CAT, PRICE_CATID FROM PRICE_CAT WHERE PRICE_CATID IN (#price_cat_list#) ORDER BY PRICE_CATID
                    </cfquery>
                    <cfset price_cat_list = listsort(listdeleteduplicates(valuelist(get_price_cat.price_catid,',')),'numeric','ASC',',')>
                </cfif>
            </cfif>
            <cfif attributes.report_type eq 6>
                <cfif len(basket_extra_list)>
                    <cfset basket_extra_list=listsort(basket_extra_list,"numeric","ASC",",")>
                    <cfquery name="GET_BASKET_EXTRA" datasource="#DSN3#">
                        SELECT BASKET_INFO_TYPE_ID,BASKET_INFO_TYPE FROM SETUP_BASKET_INFO_TYPES WHERE BASKET_INFO_TYPE_ID IN (#basket_extra_list#) ORDER BY BASKET_INFO_TYPE_ID
                    </cfquery>
                    <cfset basket_extra_list = listsort(listdeleteduplicates(valuelist(get_basket_extra.basket_info_type_id,',')),'numeric','ASC',',')>
                </cfif>
            </cfif>
            <cfif attributes.page neq 1>
                <cfoutput query="get_total_purchase" startrow="1" maxrows="#attributes.startrow-1#">
                    <cfif isdefined('attributes.is_product_cost') and not listfind('4,5',attributes.report_type) and len(product_cost)>
                        <cfset toplam_maliyet=product_cost+toplam_maliyet>
                    </cfif> 
                    <cfif len(price)>
                        <cfset toplam_satis=price+toplam_satis>
                    </cfif> 
                    <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                        <cfif len(price_other)>
                            <cfset toplam_satis_doviz=price_other+toplam_satis_doviz>
                        </cfif>
                    </cfif>
                    <cfif listfind('2,3,6,4',attributes.report_type)>
                        <cfif isdefined("product_stock") and len(product_stock)>
                            <cfset toplam_miktar=product_stock+toplam_miktar>
                        </cfif> 	
                    </cfif>
                    <cfif attributes.report_type eq 6>
                        <cfset toplam_birim_fiyat=toplam_birim_fiyat+(price_row/product_stock)>
                        <cfset total_price_value = total_price_value + birim_fiyat>
                    </cfif>
                </cfoutput>
            </cfif>		
            <cfif attributes.report_type eq 1 or attributes.report_type eq 8>
                <thead>
                    <tr>
                        <th width="25"><cf_get_lang_main no='75.No'></th>
                        <th width="80" nowrap><cf_get_lang no='657.Kategori kodu'></th><!--- kategori kodu eklendi.MA20081107 --->
                        <th width="300"><cf_get_lang_main no='74.Kategori'></th>
                        <th style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
                        <th style="text-align:right;">2.<cf_get_lang_main no='223.Miktar'></th>
                        <cfif isdefined('attributes.is_product_cost')>
                            <th style="text-align:right;"><cf_get_lang_main no='846.Maliyet'></th>
                            <th style="text-align:center;" width="50"><cf_get_lang_main no='1062.Birim'></th>
                        </cfif>
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2>
                            <th width="75" style="text-align:right;"><cf_get_lang_main no='265.Doviz'></th>
                            <th style="text-align:center;"><cf_get_lang_main no='1062.Birim'></th>
                        </cfif>
                        <th width="100" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></th>
                        <th style="text-align:center;" width="50"><cf_get_lang_main no='1062.Birim'></th>
                        <th width="35" style="text-align:right;">%</th>
                    </tr>	
                </thead>
                <cfif get_total_purchase.recordcount> 
                <tbody>     	  
                    <cfoutput query="get_total_purchase"  startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td width="25">#currentrow#</td>
                            <td width="100" style="text-align:left;mso-number-format:\@;">#hierarchy#</td>							
                            <td>#product_cat#</td>
                            <td style="text-align:right;">#TLFormat(product_stock)# </td>
                            <td style="text-align:right;">
                                <cfif len(PRODUCT_STOCK) and len(MULTIPLIER_AMOUNT)>
                                    <cfset toplam_multiplier = toplam_multiplier + PRODUCT_STOCK/MULTIPLIER_AMOUNT>
                                    #TLFormat(PRODUCT_STOCK/MULTIPLIER_AMOUNT,4)#
                                </cfif>
                            </td>
                            <cfif len(product_stock)>
                                <cfset toplam_miktar=product_stock+toplam_miktar>
                            </cfif>
                            <cfif isdefined('attributes.is_product_cost')>
                            <td nowrap style="text-align:right;">
                            <cfif len(product_cost)>
                                <cfset toplam_maliyet=toplam_maliyet+product_cost>
                                #TLFormat(product_cost)# 
                            </cfif>
                            </td>
                            <td style="text-align:center;">#session.ep.money#</td>
                            </cfif>
                            <cfif attributes.is_other_money eq 1 or attributes.is_money2>
                                <cfif len(price_other)><cfset toplam_satis_doviz = toplam_satis_doviz + price_other></cfif>
                                <td style="text-align:right;">#TLFormat(price_other)#</td>
                                <td style="text-align:center;">#other_money#</td>
                            </cfif>
                            <td style="text-align:right;">
                            <cfif len(price)>
                                <cfset toplam_satis=price+toplam_satis>
                                #TLFormat(price)#
                            </cfif>
                            </td>
                            <td style="text-align:center;">#session.ep.money#</td>
                            <td style="text-align:right;mso-number-format:'00\.00';"><cfif len(butun_toplam) and butun_toplam neq 0 and len(price)>#NumberFormat(Evaluate(100*price/butun_toplam),"00.00")#<cfelse>00.00</cfif></td>
                        </tr>
                    </cfoutput>
                </tbody>
                <tfoot>
                    <cfoutput>
                        <tr>
                            <td colspan="3" class="txtbold" style="text-align:right;"><cf_get_lang_main no='80.Toplam'></td>
                            <td class="txtbold" style="text-align:right;">#TLFormat(toplam_miktar)# </td>
                            <td class="txtbold" style="text-align:right;">#TLFormat(toplam_multiplier,4)#</td>
                            <cfif isdefined('attributes.is_product_cost')>
                                <td nowrap class="txtbold" style="text-align:right;">#TLFormat(toplam_maliyet)# </td>
                                <td class="txtbold" style="text-align:center;">#session.ep.money#</td>
                            </cfif>
                            <cfif attributes.is_other_money eq 1 or attributes.is_money2>
                                <td class="txtbold" style="text-align:right;">
                                    <cfif attributes.is_money2>#TLFormat(toplam_satis_doviz)#</cfif>
                                </td>
                                <td></td>
                            </cfif>
                            <td class="txtbold" style="text-align:right;">#TLFormat(toplam_satis)# </td>
                            <td class="txtbold" style="text-align:center;">#session.ep.money#</td>
                            <td></td>
                        </tr>
                    </cfoutput>	 
                </tfoot>
                <cfelse>
                    <tr><td colspan="20"><cf_get_lang_main no='72.Kayıt Yok'>!</td></tr>
                </cfif>
            <cfelseif attributes.report_type eq 9>
                <thead>
                    <tr>
                        <th width="25"><cf_get_lang_main no='75.No'></th>
                        <th><cf_get_lang_main no='41.Şube'></th>
                        <th style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
                        <cfif isdefined('attributes.is_product_cost')>
                        <th style="text-align:right;"><cf_get_lang_main no='846.Maliyet'></th>
                        <th style="text-align:center;" width="50"><cf_get_lang_main no='1062.Birim'></th>
                        </cfif>
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2>
                            <th width="75" style="text-align:right;"><cf_get_lang_main no='265.Doviz'></th>
                            <th style="text-align:center;"><cf_get_lang_main no='1062.Birim'></th>
                        </cfif>
                        <th width="100" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></th>
                        <th style="text-align:center;" width="50"><cf_get_lang_main no='1062.Birim'></th>
                        <th width="35" style="text-align:right;">%</th>
                    </tr>
                </thead>
                <cfif get_total_purchase.recordcount> 
                <tbody>		  
                    <cfoutput query="get_total_purchase"  startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <td>#branch_name#</td>
                            <td style="text-align:right;">#TLFormat(product_stock)# </td>
                            <cfif len(product_stock)>
                                <cfset toplam_miktar=product_stock+toplam_miktar>
                            </cfif>
                            <cfif isdefined('attributes.is_product_cost')>
                            <td nowrap style="text-align:right;">
                            <cfif len(product_cost)>
                                <cfset toplam_maliyet=toplam_maliyet+product_cost>
                                #TLFormat(product_cost)# 
                            </cfif>
                            </td>
                            <td style="text-align:center;">#session.ep.money#</td>
                            </cfif>
                            <cfif attributes.is_other_money eq 1 or attributes.is_money2>
                                <td style="text-align:right;"><cfif len(price_other)><cfset toplam_satis_doviz = toplam_satis_doviz + price_other></cfif>#TLFormat(price_other)#</td>
                                <td style="text-align:center;">#other_money#</td>
                            </cfif>
                            <td style="text-align:right;">
                            <cfif len(price)>
                                <cfset toplam_satis=price+toplam_satis>
                                #TLFormat(price)#
                            </cfif>
                            </td>
                            <td style="text-align:center;">#session.ep.money#</td>
                            <td style="text-align:right;mso-number-format:'00\.00';"><cfif len(butun_toplam) and butun_toplam neq 0 and len(price)>#NumberFormat(Evaluate(100*price/butun_toplam),"00.00")#<cfelse>00.00</cfif></td>
                        </tr>
                    </cfoutput>
                </tbody>
                <tfoot>
                    <cfoutput>
                        <tr>
                            <td colspan="2" class="txtbold" style="text-align:right;"><cf_get_lang_main no='80.Toplam'></td>
                            <td class="txtbold" style="text-align:right;">#TLFormat(toplam_miktar)# </td>
                            <cfif isdefined('attributes.is_product_cost')>
                            <td nowrap class="txtbold" style="text-align:right;">#TLFormat(toplam_maliyet)# </td>
                            <td class="txtbold" style="text-align:center;">#session.ep.money#</td>
                            </cfif>
                            <cfif attributes.is_other_money eq 1 or attributes.is_money2>
                            <td class="txtbold" style="text-align:right;"><cfif attributes.is_money2>#TLFormat(toplam_satis_doviz)#</cfif></td>
                            <td></td>
                            </cfif>
                            <td class="txtbold" style="text-align:right;">#TLFormat(toplam_satis)# </td>
                            <td class="txtbold" style="text-align:center;">#session.ep.money#</td>
                            <td></td>
                        </tr>
                    </cfoutput>	
                </tfoot>    
                <cfelse>
                    <tr><td colspan="20"><cf_get_lang_main no='72.Kayıt Yok'>!</td></tr>
                </cfif>	
            <cfelseif attributes.report_type eq 4 OR attributes.report_type eq 12>
                <thead>
                    <tr>
                        <th width="25"><cf_get_lang_main no='75.No'></th>
                        <th><cf_get_lang_main no='1195.Firma'></th>
                        <th style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
                        <th style="text-align:center;"><cf_get_lang_main no='224.Birim'></th>
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2>
                            <th width="75" style="text-align:right;"><cf_get_lang_main no='265.Doviz'></th>
                            <th style="text-align:center;"><cf_get_lang_main no='1062.Birim'></th>
                        </cfif>
                        <th width="200" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></th>
                        <th style="text-align:center;"><cf_get_lang_main no='1062.Birim'></th>
                        <th width="35" style="text-align:right;">%</th>
                    </tr>
                </thead>
                <cfif get_total_purchase.recordcount>
                <tbody>
                    <cfoutput query="get_total_purchase"  startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <td>
                            <cfif attributes.report_type eq 4>
                                <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1 >
                                    #musteri#
                                <cfelseif type eq 1>
                                    <a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#musteri_id#','list');">#musteri#</a>
                                <cfelseif type eq 0>
                                    <a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#musteri_id#','list');">#musteri#</a>	
                                <cfelse>
                                    <a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#musteri_id#','list');">#musteri#</a>	
                                </cfif>
                            <cfelse>
                                <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1 >
                                    #temsilci#
                                <cfelse>
                                    <a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&pos_code=#temsilci_pos_id#','list');">#temsilci#</a>	
                                </cfif>
                            </cfif>
                            <td style="text-align:right;">#TLFormat(product_stock)# </td>
                            <td style="text-align:center;">#birim#</td>
                            <cfif len(product_stock)>
                                <cfset toplam_miktar=product_stock+toplam_miktar>
                            </cfif> 
                            <cfif attributes.is_other_money eq 1 or attributes.is_money2>
                                <td style="text-align:right;"><cfif len(price_other)><cfset toplam_satis_doviz = toplam_satis_doviz + price_other></cfif>#TLFormat(price_other)#</td>
                                <td style="text-align:center;">#other_money#</td>
                            </cfif>
                            <td style="text-align:right;">
                                #TLFormat(price)# 
                                <cfif len(price)><cfset toplam_satis=price+toplam_satis></cfif>
                            </td>
                            <td style="text-align:center;">#session.ep.money#</td>
                            <td style="text-align:right;mso-number-format:'00\.00';"><cfif len(butun_toplam) and butun_toplam neq 0 and len(price)>#NumberFormat(Evaluate(100*price/butun_toplam),"00.00")#<cfelse>00.00</cfif></td>
                        </tr>
                    </cfoutput>
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="2" class="txtbold" style="text-align:right;"><cf_get_lang_main no='80.Toplam'></td>
                        <td class="txtbold" style="text-align:right;"><cfoutput>#TLFormat(toplam_miktar)#</cfoutput></td>
                        <td>&nbsp;</td>
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2>
                            <td class="txtbold" style="text-align:right;"><cfif attributes.is_money2><cfoutput>#TLFormat(toplam_satis_doviz)#</cfoutput></cfif></td>
                            <td></td>
                        </cfif>
                        <td class="txtbold" style="text-align:right;"><cfoutput>#TLFormat(toplam_satis)#</cfoutput></td>
                        <td class="txtbold" style="text-align:center;"><cfoutput>#session.ep.money#</cfoutput></td>
                        <td></td>
                    </tr>
                </tfoot>
                <cfelse>
                    <tr><td colspan="20"><cf_get_lang_main no='72.Kayıt Yok'>!</td></tr>
                </cfif>	
            <cfelseif attributes.report_type eq 10>
                <thead>
                    <tr>
                        <th width="25"><cf_get_lang_main no='75.No'></th>
                        <th><cfif attributes.report_type eq 10><cf_get_lang_main no='1195.Firma'><cfelse><cf_get_lang_main no="1383.müşteri temsilci"></cfif></th>
                        <th style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
                        <th style="text-align:center;"><cf_get_lang_main no='224.Birim'></th>
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2>
                            <th width="75" style="text-align:right;"><cf_get_lang_main no='265.Doviz'></th>
                            <th style="text-align:center;"><cf_get_lang_main no='1062.Birim'></th>
                        </cfif>
                        <th width="200" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></th>
                        <th style="text-align:center;"><cf_get_lang_main no='1062.Birim'></th>
                        <th width="200" style="text-align:right;"><cf_get_lang no='1979.Döviz Net Tutar'></th>
                        <th style="text-align:center;"><cf_get_lang_main no='1062.Birim'></th>
                        <th width="35" style="text-align:right;">%</th>
                    </tr>
                </thead>
                <cfif get_total_purchase.recordcount>
                <tbody>  
                    <cfoutput query="get_total_purchase"  startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <td>
                                <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1 >
                                    #musteri#
                                <cfelseif type eq 1>
                                    <a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#musteri_id#','list');">#musteri#</a>
                                <cfelseif type eq 0>
                                    <a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#musteri_id#','list');">#musteri#</a>	
                                <cfelse>
                                    <a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#musteri_id#','list');">#musteri#</a>	
                                </cfif>
                            <td style="text-align:right;">#TLFormat(product_stock)# </td>
                            <td style="text-align:center;">#birim#</td>
                            <cfif len(product_stock)>
                                <cfset toplam_miktar=product_stock+toplam_miktar>
                            </cfif> 
                            <cfif attributes.is_other_money eq 1 or attributes.is_money2>
                                <td style="text-align:right;"><cfif len(price_other)><cfset toplam_satis_doviz = toplam_satis_doviz + price_other></cfif>#TLFormat(price_other)#</td>
                                <td style="text-align:center;">#other_money#</td>
                            </cfif>
                            <td style="text-align:right;">
                                #TLFormat(price)# 
                                <cfif len(price)><cfset toplam_satis=price+toplam_satis></cfif>
                            </td>
                            <td style="text-align:center;">#session.ep.money#</td>
                            <td style="text-align:right;">#TLFormat(doviz_price)#</td>
                            <td style="text-align:center;">#money#</td>
                            <cfset 'toplam_#money#' = (evaluate('toplam_#money#')) + doviz_price>
                            <td style="text-align:right;mso-number-format:'00\.00';"><cfif len(butun_toplam) and butun_toplam neq 0 and len(price)>#NumberFormat(Evaluate(100*price/butun_toplam),"00.00")#<cfelse>00.00</cfif></td>
                        </tr>
                    </cfoutput>
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="2" class="txtbold" style="text-align:right;"><cf_get_lang_main no='80.Toplam'></td>
                        <td class="txtbold" style="text-align:right;"><cfoutput>#TLFormat(toplam_miktar)#</cfoutput>	</td>
                        <td>&nbsp;</td>
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2>
                            <td class="txtbold" style="text-align:right;"><cfif attributes.is_money2>#TLFormat(toplam_satis_doviz)#</cfif></td>
                            <td></td>
                        </cfif>
                        <td class="txtbold" style="text-align:right;"><cfoutput>#TLFormat(toplam_satis)#</cfoutput>	  </td>
                        <td class="txtbold" style="text-align:center;"><cfoutput>#session.ep.money#</cfoutput>	</td>
                        <td class="txtbold" style="text-align:right;">
                            <cfoutput query="get_money">
                                <cfif evaluate('toplam_#money#') gt 0>
                                    #TLFormat(evaluate('toplam_#money#'))# #money#<br/>
                                </cfif>
                            </cfoutput>
                        </td>
                        <td></td>
                        <td></td>
                    </tr>
                </tfoot>
                <cfelse>
                        <tr><td colspan="20"><cf_get_lang_main no='72.Kayıt Yok'>!</td></tr>
                </cfif>	
            <cfelseif attributes.report_type eq 5>
                <thead>
                    <tr>
                        <th width="25"><cf_get_lang_main no='75.No'></th>
                        <th><cf_get_lang_main no='559.İl'></th>
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2>
                            <th style="text-align:right;" width="75"><cf_get_lang_main no='265.Doviz'></th>
                            <th style="text-align:center;"><cf_get_lang_main no='1062.Birim'></th>
                        </cfif>
                        <th style="text-align:right;" width="200"><cf_get_lang_main no='261.Tutar'></th>
                        <th style="text-align:center;"><cf_get_lang_main no='1062.Birim'></th>
                        <th style="text-align:right;" width="35">%</th>
                    </tr>
                </thead> 
                <cfif get_total_purchase.recordcount>  
                <tbody>
                    <cfoutput query="get_total_purchase"  startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <td><cfif len(get_total_purchase.city) and listfind(city_id_list,get_total_purchase.city,',')>
                                    #get_city.city_name[listfind(city_id_list,get_total_purchase.city,',')]#
                                </cfif>
                            </td>
                            <cfif attributes.is_other_money eq 1 or attributes.is_money2>
                                <td style="text-align:right;"><cfif len(price_other)><cfset toplam_satis_doviz = toplam_satis_doviz + price_other></cfif>#TLFormat(price_other)#</td>
                                <td style="text-align:center;">#other_money#</td>
                            </cfif>
                            <td style="text-align:right;">
                                #TLFormat(price)# 
                                <cfif len(price)><cfset toplam_satis=price+toplam_satis></cfif>
                            </td>
                            <td style="text-align:center;">#session.ep.money#</td>
                            <td style="text-align:right;mso-number-format:'00\.00';"><cfif len(butun_toplam) and butun_toplam neq 0 and len(price)>#NumberFormat(Evaluate(100*price/butun_toplam),"00.00")#<cfelse>00.00</cfif></td>
                        </tr>
                    </cfoutput>
                </tbody>
                <tfoot>
                    <cfoutput>
                        <tr>
                            <td colspan="2" class="txtbold" style="text-align:right;"><cf_get_lang_main no='80.Toplam'></td>
                            <cfif attributes.is_other_money eq 1 or attributes.is_money2>
                                <td class="txtbold" style="text-align:right;"><cfif attributes.is_money2>#TLFormat(toplam_satis_doviz)#</cfif></td>
                                <td></td>
                            </cfif>
                            <td class="txtbold" style="text-align:right;">#TLFormat(toplam_satis)#</td>
                            <td class="txtbold" style="text-align:center;">#session.ep.money#</td>
                            <td></td>
                        </tr>
                    </cfoutput>	 
                </tfoot>
                <cfelse>
                    <tr><td colspan="20"><cf_get_lang_main no='72.Kayıt Yok'>!</td></tr>
                </cfif>	
            <cfelseif attributes.report_type eq 6>
                <thead>
                    <tr>
                        <th width="25"><cf_get_lang_main no='75.No'></th>
                        <cfif isdefined("attributes.is_ref_no")>
                            <th><cf_get_lang_main no='1382.Referans No'></th>
                        </cfif>
                        <th><cf_get_lang_main no='726.İrsaliye No'></th>
                        <th><cf_get_lang no='565.İrsaliye Tarihi'></th>
                        <th><cf_get_lang_main no='45.Müşteri'></th>
                        <cfif attributes.is_project eq 1>
                            <th><cf_get_lang_main no ='4.Proje'></th>
                        </cfif>
                        <th><cf_get_lang_main no='146.Üye No'></th>
                        <th><cf_get_lang_main no='377.Özel Kod'></th>
                        <th><cf_get_lang_main no='1388.Ürün Kod'></th>
                        <th><cf_get_lang_main no='222.Üretici Kodu'></th>
                        <th><cf_get_lang_main no='245.Ürün'></th>
                        <cfif is_brand_show eq 1><th><cf_get_lang_main no='1435.Marka'></th></cfif>
                        <cfif is_short_code_show eq 1><th><cf_get_lang_main no='813.Model'></th></cfif>
                        <cfif isdefined("attributes.is_spect_info")>
                            <th><cf_get_lang_main no='235.Spec'></th>
                            <th><cf_get_lang_main no="235.Spec"> <cf_get_lang_main no="1115.Id"></th>
                        </cfif>
                        <cfif x_show_product_code_2>
                        <th><cf_get_lang_main no="377.Özel Kod">(<cf_get_lang_main no="245.Ürün">)</th>
                        </cfif>
                        <th><cf_get_lang no='1890.Ek Açıklama'></th>
                        <th width="100" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
                        <th width="100" style="text-align:right;">2.<cf_get_lang_main no='223.Miktar'></th>
                        <th style="text-align:center;"><cf_get_lang_main no='224.Birim'></th>
                        <cfif x_unit_weight eq 1>
                            <th width="100" style="text-align:right;"><cf_get_lang_main no='1987.Ağırlık'></th>
                        </cfif>
                        <th width="90" style="text-align:center;" nowrap><cf_get_lang_main no='226.Birim Fiyat'></th>
                        <cfif isdefined("attributes.is_money_info")>
                            <th width="90" nowrap><cf_get_lang no='690.Döviz Net Fiyat'></th>
                            <th><cf_get_lang_main no='709.İşlem Dövizi'></th>
                        </cfif>
                        <th width="90" style="text-align:center;" nowrap><cf_get_lang no='122.Net Fiyat'></th>
                        <cfif isdefined('attributes.is_product_cost')>
                            <th style="text-align:right;"><cf_get_lang_main no='846.Maliyet'></th>
                            <th style="text-align:center;"><cf_get_lang_main no='1062.Birim'></th>
                        </cfif>
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2>
                            <th width="75" style="text-align:right;"><cf_get_lang_main no='265.Doviz'></th>
                            <th style="text-align:center;"><cf_get_lang_main no='1062.Birim'></th>
                        </cfif>
                        <th width="150" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></th>
                        <th style="text-align:center;"><cf_get_lang_main no='1062.Birim'></th>
                        <th width="35" style="text-align:right;">%</th>
                    </tr>
                </thead>
                <cfif get_total_purchase.recordcount> 
                <tbody>
                    <cfoutput query="get_total_purchase"  startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <cfif isdefined("attributes.is_ref_no")>
                                <td>#ref_no#</td>
                            </cfif>
                            <td><cfif purchase_sales eq 0>
                                    <cfswitch expression="#ship_type#">
                                        <cfdefaultcase>
                                            <cfset url_param = "#request.self#?fuseaction=stock.form_add_purchase&event=upd&ship_id=">
                                        </cfdefaultcase>
                                    </cfswitch>
                                <cfelseif purchase_sales eq 1>
                                    <cfswitch expression="#ship_type#">
                                        <cfcase value="81">
                                            <cfset url_param = "#request.self#?fuseaction=stock.add_ship_dispatch&event=upd&ship_id=">
                                        </cfcase>
                                        <cfcase value="811">
                                            <cfset url_param="#request.self#?fuseaction=stock.upd_stock_in_from_customs&ship_id=">
                                        </cfcase>
                                        <cfcase value="83">
                                            <cfset url_param = "#request.self#?fuseaction=invent.upd_invent_sale&ship_id=">
                                        </cfcase>
                                        <cfdefaultcase>
                                            <cfset url_param = "#request.self#?fuseaction=stock.form_add_sale&event=upd&ship_id=">
                                        </cfdefaultcase>
                                    </cfswitch>				
                                </cfif>
                                <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                                    #ship_number#
                                <cfelse>
                                    <a href="#url_param##ship_id#" class="tableyazi" target="_blank">#ship_number#</a>
                                </cfif>
                            </td>
                            <td>#dateformat(ship_date,dateformat_style)#</td>
                            <td><cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1 >
                                    #musteri#
                                <cfelseif type eq 1>
                                    <a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#musteri_id#','list');">#musteri#</a>
                                <cfelseif type eq 0>
                                    <a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#musteri_id#','list');">#musteri#</a>	
                                <cfelse>
                                    <a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#musteri_id#','list');">#musteri#</a>	
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
                            <td>#member_code#</td>
                            <td>#ozel_kod#</td>
                            <td>#stock_code#</td>
                            <td>#manufact_code#</td>
                            <td><cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                                    #product_name# #property#
                                <cfelse>
                                    <a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#','list');">
                                    #product_name# #property#
                                    </a>
                                </cfif>
                            </td>
                            <cfif is_brand_show eq 1><td><cfif len(brand_id)>#get_brand.BRAND_NAME[listfind(brand_id_list,brand_id,',')]#</cfif></td></cfif>
                            <cfif is_short_code_show eq 1><td><cfif len(short_code_id)>#get_model.MODEL_NAME[listfind(short_code_id_list,short_code_id,',')]#</cfif></td></cfif>
                            <cfif isdefined("attributes.is_spect_info")>
                                <td>#spect_var_name#</td>
                                <td>#spect_main_id#</td>
                            </cfif>
                            <cfif x_show_product_code_2>
                                <td style="mso-number-format:\@;">#product_code_2#</td>
                            </cfif>
                            <td><cfif len(basket_extra_info_id)>#get_basket_extra.basket_info_type[listfind(basket_extra_list,basket_extra_info_id,',')]#</cfif></td>
                            <td style="text-align:right;">#TLFormat(product_stock,4)# 
                                <cfif len(product_stock)>
                                    <cfset toplam_miktar=product_stock+toplam_miktar>
                                </cfif> 
                            </td>
                            <td style="text-align:right;">
                                <cfif len(PRODUCT_STOCK) and len(MULTIPLIER_AMOUNT_1)>
                                    <cfset toplam_multiplier_amount_1 = toplam_multiplier_amount_1 + PRODUCT_STOCK/MULTIPLIER_AMOUNT_1>
                                    #TLFormat(PRODUCT_STOCK/MULTIPLIER_AMOUNT_1,4)#
                                </cfif>
                            </td>
                            <td style="text-align:center;">#birim#</td>
                            <cfif x_unit_weight eq 1>
                                <td style="text-align:right;">
                                    <cfif len(PRODUCT_STOCK) and len(UNIT_WEIGHT_1)>
                                        <cfset toplam_unit_weight = toplam_unit_weight + PRODUCT_STOCK*UNIT_WEIGHT_1>
                                        #TLFormat(PRODUCT_STOCK*UNIT_WEIGHT_1,2)#
                                    </cfif>
                                </td>
                            </cfif>
                            <td style="text-align:right;">#TLFormat(birim_fiyat)#</td>
                            <cfif isdefined("attributes.is_money_info")>
                                <cfset "toplam_net_doviz_#other_money#" = evaluate("toplam_net_doviz_#other_money#") + other_money_value>
                                <td style="text-align:right;">#tlformat(other_money_value)#</td>
                                <td style="text-align:center;">#other_money#</td>
                            </cfif>
                            <td style="text-align:right;">
                                #tlformat(price_row/product_stock)#
                                <cfif attributes.report_type eq 6>
                                    <cfset toplam_birim_fiyat=toplam_birim_fiyat+(price_row/product_stock)>
                                    <cfset total_price_value = total_price_value + birim_fiyat>
                                </cfif>
                            </td>
                            <cfif isdefined('attributes.is_product_cost')>
                            <td nowrap style="text-align:right;">
                                <cfif len(product_cost)>
                                    <cfset toplam_maliyet=toplam_maliyet+product_cost>
                                    #TLFormat(product_cost)# 
                                </cfif>
                            </td>
                            <td style="text-align:center;"><cfif len(product_cost)>#session.ep.money#</cfif></td>
                            </cfif>
                            <cfif attributes.is_other_money eq 1 or attributes.is_money2>
                                <td style="text-align:right;"><cfif len(price_other)><cfset toplam_satis_doviz = toplam_satis_doviz + price_other></cfif>#TLFormat(price_other)#</td>
                                <td style="text-align:center;">#other_money#</td>
                            </cfif>
                            <td style="text-align:right;">
                                <cfif len(price)>
                                    <cfset toplam_satis=price+toplam_satis>
                                    #TLFormat(price)# 
                                </cfif>
                            </td>
                            <td style="text-align:center;"><cfif len(price)>#session.ep.money#</cfif></td>
                            <td style="text-align:right;mso-number-format:'00\.00';"><cfif len(butun_toplam) and butun_toplam neq 0 and len(price)>#NumberFormat(Evaluate(100*price/butun_toplam),"00.00")#<cfelse>00.00</cfif></td>
                        </tr>
                    </cfoutput> 
                </tbody>
                <tfoot>
                    <cfoutput>
                        <tr>
                            <cfset colspan_ = 10>
                            <cfif isdefined("attributes.is_spect_info")>
                                <cfset colspan_ = colspan_ + 2>
                            </cfif>
                            <cfif isdefined("attributes.is_ref_no")>
                                <cfset colspan_ = colspan_ + 1>
                            </cfif>
                            <cfif attributes.is_project eq 1>
                                <cfset colspan_ = colspan_ + 1>
                            </cfif>
                            <cfif x_show_product_code_2>
                                <cfset colspan_ = colspan_ + 1>
                            </cfif>
                            <cfif is_brand_show eq 1>
                                <cfset colspan_ = colspan_ + 1>
                            </cfif>
                            <cfif is_short_code_show eq 1>
                                <cfset colspan_ = colspan_ + 1>
                            </cfif>
                            <td class="txtbold" style="text-align:right;" colspan="#colspan_#"><cf_get_lang_main no='80.Toplam'></td>
                            <td class="txtbold" style="text-align:right;">#TLFormat(toplam_miktar)#</td>
                            <td class="txtbold" style="text-align:right;">#TLFormat(toplam_multiplier_amount_1,4)#</td>
                            <td>&nbsp;</td>
                            <cfif x_unit_weight eq 1>
                                <td class="txtbold" style="text-align:right;">#TLFormat(toplam_unit_weight,4)#</td>
                            </cfif>
                            <td class="txtbold" style="text-align:right;">#TLFormat(total_price_value)#</td>
                            <cfif isdefined("attributes.is_money_info")>
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
                            <td class="txtbold" style="text-align:right;">#TLFormat(toplam_birim_fiyat)#</td>
                            <cfif isdefined('attributes.is_product_cost')>
                            <td nowrap class="txtbold" style="text-align:right;">#TLFormat(toplam_maliyet)# </td>
                            <td class="txtbold" style="text-align:center;">#session.ep.money#</td>
                            </cfif>
                            <cfif attributes.is_other_money eq 1 or attributes.is_money2>
                                <td class="txtbold" style="text-align:right;"><cfif attributes.is_money2>#TLFormat(toplam_satis_doviz)#</cfif></td>
                                <td></td>
                            </cfif>
                            <td class="txtbold" style="text-align:right;">#TLFormat(toplam_satis)#</td>
                            <td class="txtbold" style="text-align:center;">#session.ep.money#</td>
                            <td></td>
                        </tr>
                    </cfoutput>  
                </tfoot> 
                <cfelse>
                    <tr><td colspan="20"><cf_get_lang_main no='72.Kayıt Yok'>!</td></tr>
                </cfif>	
            <cfelseif attributes.report_type eq 11>
                <cfif isdefined("attributes.model_month") and len(attributes.model_month)>
                    <thead>
                        <tr>
                            <th><cf_get_lang_main no='1312.Ay'></th>
                            <th><cf_get_lang_main no='813.Model'></th>
                            <th><cf_get_lang_main no='223.Miktar'></th>
                            <th><cf_get_lang_main no='224.Birim'></th>
                            <th><cf_get_lang_main no='261.Tutar'></th>
                        </tr>
                    </thead>
                    <cfif get_total_purchase.recordcount>
                    <tbody>
                        <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <tr>
                                <td>#SHIP_DATE#</td>
                                <td>#MODEL_NAME#</td>
                                <td>#PRODUCT_STOCK#</td>
                                <td>#UNIT#</td>
                                <td>#TlFormat(PRICE,2)#</td>
                            </tr>
                        </cfoutput>
                    </tbody>
                    <cfelse>
                        <tr><td colspan="20"><cf_get_lang_main no='72.Kayıt Yok'>!</td></tr>
                    </cfif>	
                <cfelse>
                    <cfset fatura_aylar = ListDeleteDuplicates(valuelist(get_total_purchase.SHIP_DATE))>
                    <cfset first_month = month(dateformat(attributes.date1,dateformat_style))>
                    <cfset last_month = month(dateformat(attributes.date2,dateformat_style))>
                    <thead>
                        <tr>
                            <cfoutput>
                                <cfloop index="aaa" from="#first_month#" to="#last_month#">
                                    <th colspan="4" class="txtbold" style="text-align:center; width:400px;">#aaa#/#session.ep.period_year#</th>
                                </cfloop>
                            </cfoutput>
                        </tr> 
                    </thead>
                    <cfif get_total_purchase.recordcount>  
                        <tbody>
                            <cfif (last_month-first_month) gt listlen(fatura_aylar)>
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
                                        #bbb# AS SHIP_DATE,
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
                                        SHIP_DATE,
                                        PRICE
                                    FROM
                                        get_total_purchase
                                        UNION
                                        SELECT
                                        MODEL_NAME,
                                        PRODUCT_STOCK,
                                        UNIT,
                                        SHIP_DATE,
                                        PRICE
                                        FROM
                                        get_
                                        ORDER BY SHIP_DATE
                                </cfquery>
                            <cfelse>
                                <cfquery name="get_purch" dbtype="query">
                                    SELECT
                                        MODEL_NAME,
                                        PRODUCT_STOCK,
                                        UNIT,
                                        SHIP_DATE,
                                        PRICE
                                    FROM
                                        get_total_purchase
                                    ORDER BY SHIP_DATE   
                                </cfquery>
                            </cfif>
                            <cfoutput query="get_purch" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#" group="SHIP_DATE">
                                <td colspan="4" valign="top">
                                    <table cellpadding="0" cellpadding="0">
                                        <thead>
                                            <tr>
                                                <th style="width:100px;" class="txtbold"><cf_get_lang_main no='813.Model'></th>
                                                <th class="txtbold" style="text-align:right;width:100px;"><cf_get_lang_main no='223.Miktar'></th>
                                                <th class="txtbold" style="text-align:right;width:100px;"><cf_get_lang_main no='224.Birim'></th>
                                                <th class="txtbold" style="text-align:right;width:100px;"><cf_get_lang_main no='261.Tutar'></th>
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
                    <cfelse>
                        <tr><td colspan="20"><cf_get_lang_main no='72.Kayıt Yok'>!</td></tr>
                    </cfif>	    
                </cfif>                
            <cfelseif attributes.report_type eq 7>
                <thead>
                    <tr>
                        <th width="25"><cf_get_lang_main no='75.No'></th>
                        <th><cf_get_lang_main no='1552.Fiyat Listesi'></th>
                        <th style="text-align:right;" width="100"><cf_get_lang_main no='223.Miktar'></th>
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2>
                            <th style="text-align:right;" width="75"><cf_get_lang_main no='265.Doviz'></th>
                            <th style="text-align:center;"><cf_get_lang_main no='1062.Birim'></th>
                        </cfif>
                        <th style="text-align:right;" width="200"><cf_get_lang_main no='261.Tutar'></th>
                        <th style="text-align:center;"><cf_get_lang_main no='1062.Birim'></th>
                        <th style="text-align:right;" width="35">%</th>
                    </tr> 
                </thead>
                <cfif get_total_purchase.recordcount>
                    <tbody> 
                        <cfoutput query="get_total_purchase"  startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <tr>
                                <td>#currentrow#</td>
                                <td>
                                    <cfif len(price_cat_list) and len(price_cat) and price_cat gt 0>
                                        #get_price_cat.price_cat[listfind(price_cat_list,price_cat,',')]#
                                    <cfelseif price_cat eq -2>
                                        <cf_get_lang_main no='1309.Standart Satış'>
                                    <cfelseif price_cat eq -1>
                                        <cf_get_lang_main no='1310.Standart Alış'>
                                    </cfif>
                                </td>
                                <td style="text-align:right;">#TLFormat(product_stock,4)# 
                                <cfif len(product_stock)>
                                    <cfset toplam_miktar=product_stock+toplam_miktar>
                                </cfif> 
                                </td>
                                <cfif attributes.is_other_money eq 1 or attributes.is_money2>
                                    <td style="text-align:right;"><cfif len(price_other)><cfset toplam_satis_doviz = toplam_satis_doviz + price_other></cfif>#TLFormat(price_other)#</td>
                                    <td style="text-align:center;">#other_money#</td>
                                </cfif>
                                <td style="text-align:right;">
                                #TLFormat(price)# 
                                <cfif len(price)>
                                    <cfset toplam_satis=price+toplam_satis>
                                </cfif>
                                </td>
                                <td style="text-align:center;">#session.ep.money#</td>
                                <td style="text-align:right;mso-number-format:'00\.00';"><cfif len(butun_toplam) and butun_toplam neq 0 and len(price)>#NumberFormat(Evaluate(100*price/butun_toplam),"00.00")#<cfelse>00.00</cfif></td>
                            </tr>
                        </cfoutput>
                    </tbody>
                    <tfoot>
                        <cfoutput>
                            <tr>
                                <td class="txtbold" colspan="2" style="text-align:right"><cf_get_lang_main no='80.Toplam'></td>
                                <td class="txtbold" style="text-align:right;">#TLFormat(toplam_miktar)#</td>
                                <cfif attributes.is_other_money eq 1 or attributes.is_money2>
                                    <td class="txtbold" style="text-align:right;"><cfif attributes.is_money2>#TLFormat(toplam_satis_doviz)#</cfif></td>
                                    <td></td>
                                </cfif>
                                <td class="txtbold" style="text-align:right;">#TLFormat(toplam_satis)#</td>
                                <td class="txtbold" style="text-align:center;">#session.ep.money#</td>
                                <td></td>
                            </tr>
                        </cfoutput>	 
                    </tfoot>
                <cfelse>
                        <tr><td colspan="20"><cf_get_lang_main no='72.Kayıt Yok'>!</td></tr>
                </cfif>	
            <cfelseif isdefined("is_monthly_based")>
                <thead>
                    <cfif get_total_purchase.recordcount>
                        <tr>
                            <td width="120"></td>
                            <td></td>
                            <cfset month_list = "OCAK,ŞUBAT,MART,NİSAN,MAYIS,HAZİRAN,TEMMUZ,AĞUSTOS,EYLÜL,EKİM,KASIM,ARALIK">
                            <cfloop from="1" to="#listlen(month_list)#" index="indx">
                            <td colspan="4" class="txtbold" style="text-align:center;"><cfoutput>#ListgetAt(month_list,indx)#</cfoutput></td>
                            </cfloop>
                            <td colspan="2" class="txtbold" style="text-align:center;"><cf_get_lang_main no='80.TOPLAM'></td>
                        </tr>
                    </cfif>
                        <tr>
                            <td width="90" nowrap><cf_get_lang_main no='1388.Ürün Kodu'></td>
                            <td width="180" nowrap><cf_get_lang_main no='245.Ürün'></td>
                            <cfloop from="1" to="#listlen(month_list)#" index="indx">
                                <td><cf_get_lang_main no='223.Miktar'></td>
                                <td><cf_get_lang_main no='224.Birim'></td>
                                <td><cf_get_lang_main no='261.Tutar'></td>
                                <td><cf_get_lang_main no='1062.Birim'></td>
                            </cfloop>
                            <td><cf_get_lang_main no='223.Miktar'></td>
                            <td style="text-align:right;"><cf_get_lang_main no='261.Tutar'></td>
                        </tr>
                </thead>
                <cfif get_total_purchase.recordcount>
                    <tbody>
                    <cfoutput query="get_total_purchase">
                        <cfif attributes.report_type eq 2>
                            <cfif isdefined("product_stock_#product_id#_#month_due#")>
                                <cfset "product_stock_#product_id#_#month_due#" = evaluate("product_stock_#product_id#_#month_due#") + product_stock>
                            <cfelse>
                                <cfset "product_stock_#product_id#_#month_due#" = product_stock>
                            </cfif>
                            <cfif isdefined("birim_#product_id#_#month_due#")>
                                <cfset "birim_#product_id#_#month_due#" = evaluate("birim_#product_id#_#month_due#")>
                            <cfelse>
                                <cfset "birim_#product_id#_#month_due#" = birim>
                            </cfif>
                            <cfif isdefined("doviz_price_#product_id#_#month_due#")>
                                <cfset "doviz_price_#product_id#_#month_due#" = evaluate("doviz_price_#product_id#_#month_due#") + price><!--- doviz_price --->
                            <cfelse>
                                <cfset "doviz_price_#product_id#_#month_due#" = price><!--- doviz_price --->
                            </cfif>
                            <cfif isdefined("money_#product_id#_#month_due#")>
                                <cfset "money_#product_id#_#month_due#" = evaluate("money_#product_id#_#month_due#")>
                            <cfelse>
                                <cfset "money_#product_id#_#month_due#" = money>
                            </cfif>
                        <cfelseif attributes.report_type eq 3>
                            <cfif isdefined("product_stock_#stock_id#_#month_due#")>
                                <cfset "product_stock_#stock_id#_#month_due#" = evaluate("product_stock_#stock_id#_#month_due#") + product_stock>
                            <cfelse>
                                <cfset "product_stock_#stock_id#_#month_due#" = product_stock>
                            </cfif>
                            <cfif isdefined("birim_#stock_id#_#month_due#")>
                                <cfset "birim_#stock_id#_#month_due#" = evaluate("birim_#stock_id#_#month_due#")>
                            <cfelse>
                                <cfset "birim_#stock_id#_#month_due#" = birim>
                            </cfif>
                            <cfif isdefined("doviz_price_#stock_id#_#month_due#")>
                                <cfset "doviz_price_#stock_id#_#month_due#" = evaluate("doviz_price_#stock_id#_#month_due#") + price><!--- doviz_price --->
                            <cfelse>
                                <cfset "doviz_price_#stock_id#_#month_due#" = price><!--- doviz_price --->
                            </cfif>
                            <cfif isdefined("money_#stock_id#_#month_due#")>
                                <cfset "money_#stock_id#_#month_due#" = evaluate("money_#stock_id#_#month_due#")>
                            <cfelse>
                                <cfset "money_#stock_id#_#month_due#" = money>
                            </cfif>
                        </cfif>
                        </cfoutput>
                    </tbody>
                    <tfoot>
                    <cfoutput query="get_total_purchase_3" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <cfif attributes.report_type eq 2>
                                <td width="120">#product_code#</td>
                                <td width="300">
                                    <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                                        #product_name#
                                    <cfelse>
                                        <a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#','list');">
                                        #product_name#</a>
                                    </cfif>
                                </td>
                            <cfelseif attributes.report_type eq 3>
                                <td width="120">#stock_code#</td>
                                <td width="300">
                                    <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1 >
                                        #product_name# #property#
                                    <cfelse>
                                        <a href="#request.self#?fuseaction=stock.list_stock&event=det&pid=#product_id#" class="tableyazi">#product_name# #property#</a>
                                    </cfif>
                                </td>
                            </cfif>
                            <cfset toplam_miktar = 0>
                            <cfloop query="get_money">
                                <cfset "toplam_tutar_#money#" = 0>
                            </cfloop>
                                <cfloop from="1" to="#listlen(month_list)#" index="indx">
                                    <cfif attributes.report_type eq 2>
                                        <td style="text-align:right;"><cfif isdefined("product_stock_#product_id#_#indx#")>#tlformat(evaluate("product_stock_#product_id#_#indx#"))#<cfelse>#tlformat(0)#</cfif></td>
                                        <td style="text-align:center;"><cfif isdefined("birim_#product_id#_#indx#")>#evaluate("birim_#product_id#_#indx#")#</cfif></td>
                                        <td style="text-align:right;"><cfif isdefined("doviz_price_#product_id#_#indx#")>#tlformat(evaluate("doviz_price_#product_id#_#indx#"))#<cfelse>#tlformat(0)#</cfif></td>
                                        <td style="text-align:center;"><cfif isdefined("money_#product_id#_#indx#")>#evaluate("money_#product_id#_#indx#")#</cfif></td>
                                        <cfif isdefined("product_stock_#product_id#_#indx#")><cfset toplam_miktar = evaluate("product_stock_#product_id#_#indx#") + toplam_miktar></cfif>
                                        <cfif isdefined("doviz_price_#product_id#_#indx#")><cfset "toplam_tutar_#evaluate("money_#product_id#_#indx#")#" = evaluate("doviz_price_#product_id#_#indx#") + evaluate("toplam_tutar_#evaluate("money_#product_id#_#indx#")#")></cfif>
                                    <cfelseif attributes.report_type eq 3>
                                        <td style="text-align:right;"><cfif isdefined("product_stock_#stock_id#_#indx#")>#tlformat(evaluate("product_stock_#stock_id#_#indx#"))#<cfelse>#tlformat(0)#</cfif></td>
                                        <td style="text-align:center;"><cfif isdefined("birim_#stock_id#_#indx#")>#evaluate("birim_#stock_id#_#indx#")#</cfif></td>
                                        <td style="text-align:right;"><cfif isdefined("doviz_price_#stock_id#_#indx#")>#tlformat(evaluate("doviz_price_#stock_id#_#indx#"))#<cfelse>#tlformat(0)#</cfif></td>
                                        <td style="text-align:center;"><cfif isdefined("money_#stock_id#_#indx#")>#evaluate("money_#stock_id#_#indx#")#</cfif></td>
                                        <cfif isdefined("product_stock_#stock_id#_#indx#")><cfset toplam_miktar = evaluate("product_stock_#stock_id#_#indx#") + toplam_miktar></cfif>
                                        <cfif isdefined("doviz_price_#stock_id#_#indx#")><cfset "toplam_tutar_#evaluate("money_#stock_id#_#indx#")#" = evaluate("doviz_price_#stock_id#_#indx#") + evaluate("toplam_tutar_#evaluate("money_#stock_id#_#indx#")#")></cfif>
                                    </cfif>
                                </cfloop>
                                <td class="txtbold" style="text-align:right;">#tlformat(toplam_miktar)#</td>
                                <td nowrap class="txtbold" style="text-align:right;">
                                    <cfloop query="get_money">
                                        <cfif evaluate('toplam_tutar_#money#') gt 0>
                                            #tlformat(evaluate("toplam_tutar_#money#"))# #money#<br/>
                                        </cfif>
                                    </cfloop>
                                </td>
                        </tr>
                        </cfoutput>
                    </tfoot>
                <cfelse>
                    <tr>
                        <td colspan="20">
                            <cf_get_lang_main no='72.Kayıt Yok'>!
                        </td>
                    </tr>     
                </cfif>
                    <cfif isdefined("attributes.form_submitted") and attributes.totalrecords gt attributes.maxrows>
                        <tr> 
                            <td>	
                            <cfscript>
                                str_link = "form_submitted=1";
                                str_link = "#str_link#&process_type=#attributes.process_type#&report_sort=#attributes.report_sort#&product_employee_id=#attributes.product_employee_id#";
                                str_link = "#str_link#&sales_employee=#attributes.sales_employee#&sales_employee_id=#attributes.sales_employee_id#";
                                str_link = "#str_link#&product_name=#attributes.product_name#&product_id=#attributes.product_id#&employee_name=#attributes.employee_name#";
                                str_link = "#str_link#&keyword=#attributes.keyword#";
                                str_link = "#str_link#&department_id=#attributes.department_id#&consumer_id=#attributes.consumer_id#";
                                str_link = "#str_link#&company=#attributes.company#&company_id=#attributes.company_id#&product_cat=#attributes.product_cat#&search_product_catid=#attributes.search_product_catid#&hierarcy=#attributes.hierarcy#";
                                str_link = "#str_link#&kdv_dahil=#attributes.kdv_dahil#&date1=#dateformat(attributes.date1,dateformat_style)#";
                                str_link = "#str_link#&date2=#dateformat(attributes.date2,dateformat_style)#&report_type=#attributes.report_type#";
                                str_link = "#str_link#&member_cat_type=#attributes.member_cat_type#";
                                str_link = "#str_link#&project_id=#attributes.project_id#";
                                str_link = "#str_link#&project_head=#attributes.project_head#";
                                str_link = "#str_link#&sector_cat_id=#attributes.sector_cat_id#";
                                str_link = "#str_link#&kontrol=#attributes.kontrol#";
                                str_link = "#str_link#&invoice_action=#attributes.invoice_action#";
                                str_link = "#str_link#&ship_address=#attributes.ship_address#";
                                str_link = "#str_link#&brand_id=#attributes.brand_id#&brand_name=#attributes.brand_name#";
                                str_link = "#str_link#&model_id=#attributes.model_id#&model_name=#attributes.model_name#";
                                str_link = "#str_link#&ship_method_id=#attributes.ship_method_id#&ship_method_name=#attributes.ship_method_name#";
                                if(isdefined('attributes.is_product_cost')) str_link = "#str_link#&is_product_cost=#attributes.is_product_cost#";
                                if(isdefined('attributes.is_spect_info')) str_link = "#str_link#&is_spect_info=#attributes.is_spect_info#";
                                if(isdefined("attributes.is_money_info"))str_link = "#str_link#&is_money_info=#attributes.is_money_info#";
                                if(isdefined("attributes.is_monthly_based"))str_link = "#str_link#&is_monthly_based=#attributes.is_monthly_based#";
                                if(isdefined("attributes.is_other_money"))str_link = "#str_link#&is_other_money=#attributes.is_other_money#";
                                if(isdefined("attributes.is_money2"))str_link = "#str_link#&is_money2=#attributes.is_money2#";
                            </cfscript>
                            <cf_paging 
                                    page="#attributes.page#" 
                                    maxrows="#attributes.maxrows#" 
                                    totalrecords="#attributes.totalrecords#" 
                                    startrow="#attributes.startrow#" 
                                    adres="#attributes.fuseaction#&#str_link#"> 
                    </cfif>
            <cfelse>
                <thead>
                    <tr>
                        <th width="25"><cf_get_lang_main no='75.No'></th>
                        <th><cf_get_lang_main no='74.Kategori'></th>
                        <th><cf_get_lang_main no='221.Barkod'></th>
                        <th><cf_get_lang_main no='245.Ürün'></th>
                        <th><cf_get_lang_main no='106.Stok Kodu'></th>
                        <cfif listfind('2,3',attributes.report_type)>
                            <cfif is_brand_show eq 1><th><cf_get_lang_main no='1435.Marka'></th></cfif>
                            <cfif is_short_code_show eq 1><th><cf_get_lang_main no='813.Model'></th></cfif>
                        </cfif>
                        <th width="100" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
                        <th style="text-align:center;"><cf_get_lang_main no='224.Birim'></th>
                        <cfif x_unit_weight eq 1>
                            <th width="100" style="text-align:right;">Ağırlık</th>
                        </cfif>
                        <cfif x_show_second_unit eq 1 and listfind('2,3',attributes.report_type)>
                            <th width="100" style="text-align:right;">2. Birim <cf_get_lang_main no='223.Miktar'></th>
                            <th style="text-align:center;">2. <cf_get_lang_main no='224.Birim'></th>
                        </cfif>
                        <cfif isdefined('attributes.is_product_cost')>
                        <th style="text-align:right;"><cf_get_lang_main no='846.Maliyet'></th>
                        <th style="text-align:center;"><cf_get_lang_main no='1062.Birim'></th>
                        </cfif>
                        <cfif attributes.is_other_money eq 1 or attributes.is_money2>
                            <th width="75" style="text-align:right;"><cf_get_lang_main no='265.Doviz'></th>
                            <th style="text-align:center;"><cf_get_lang_main no='1062.Birim'></th>
                        </cfif>
                        <th width="180" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></th>
                        <th style="text-align:center;"><cf_get_lang_main no='1062.Birim'></th>
                        <th width="35" style="text-align:right;">%</th>
                    </tr>  
                </thead>
                <cfif get_total_purchase.recordcount>
                <tbody>
                    <cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <td>#product_cat#</td>
                            <cfif attributes.report_type eq 2>
                                <td style="mso-number-format:\@;">#barcod#</td>
                                <td>
                                    <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1 >
                                        #product_name#
                                    <cfelse>
                                        <a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#','list');">
                                        #product_name#</a>
                                    </cfif>
                                </td>
                                <td>#product_code#</td>
                            <cfelseif attributes.report_type eq 3>
                                <td style="mso-number-format:\@;">#barcod#</td>
                                <td><cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1 >
                                        #product_name# #property#
                                    <cfelse>
                                        <a href="#request.self#?fuseaction=stock.list_stock&event=det&pid=#product_id#" class="tableyazi">#product_name# #property#</a>
                                    </cfif>
                                </td>
                                <td>#stock_code#</td>
                            </cfif>
                            <cfif listfind('2,3',attributes.report_type)>
                                <cfif is_brand_show eq 1><td><cfif len(brand_id)>#get_brand.BRAND_NAME[listfind(brand_id_list,brand_id,',')]#</cfif></td></cfif>
                                <cfif is_short_code_show eq 1><td><cfif len(short_code_id)>#get_model.MODEL_NAME[listfind(short_code_id_list,short_code_id,',')]#</cfif></td></cfif>
                            </cfif>
                            <td style="text-align:right;">
                                <cfif len(product_stock)>
                                    <cfset toplam_miktar=product_stock+toplam_miktar>
                                    #TLFormat(product_stock)#
                                </cfif> 
                            </td>
                            <td style="text-align:center;">
                                <cfif len(product_stock)>
                                    #birim#
                                </cfif>
                            </td>
                            <cfif x_unit_weight eq 1>
                                <td style="text-align:right;">
                                    <cfif len(PRODUCT_STOCK) and len(UNIT_WEIGHT)>
                                        <cfset toplam_weight = toplam_weight+PRODUCT_STOCK*UNIT_WEIGHT>
                                        #TLFormat(PRODUCT_STOCK*UNIT_WEIGHT,2)#
                                    </cfif>
                                </td>
                            </cfif>
                            <cfif x_show_second_unit eq 1 and listfind('2,3',attributes.report_type)>
                                <td style="text-align:right;">
                                    <cfif len(product_stock)>
                                        <cfif len(product_stock) and len(multiplier)>
                                            <cfset unit_ = filterspecialchars(unit2)>
                                            <cfset 'toplam_ikinci_#unit_#' = evaluate('toplam_ikinci_#unit_#') + product_stock/wrk_round(multiplier,8,1)>
                                            #TLFormat(product_stock/wrk_round(multiplier,8,1))#
                                        </cfif>
                                    </cfif> 
                                </td>
                                <td style="text-align:center;">
                                    #UNIT2#
                                </td>
                            </cfif>
                            <cfif isdefined('attributes.is_product_cost')>
                                <td nowrap style="text-align:right;">
                                    <cfif len(product_cost)>
                                        <cfset toplam_maliyet=toplam_maliyet+product_cost>
                                        #TLFormat(product_cost)# 
                                    </cfif>
                                </td>
                                <td style="text-align:center;">
                                    <cfif len(product_cost)>
                                        #session.ep.money#
                                    </cfif>
                                </td>
                            </cfif>
                            <cfif attributes.is_other_money eq 1 or attributes.is_money2>
                                <td style="text-align:right;"><cfif len(price_other)><cfset toplam_satis_doviz = toplam_satis_doviz + price_other></cfif>#TLFormat(price_other)#</td>
                                <td style="text-align:center;">#other_money#</td>
                            </cfif>
                            <td style="text-align:right;">
                                <cfif len(price)>
                                    <cfset toplam_satis=price+toplam_satis>
                                    #TLFormat(price)# 
                                </cfif>
                            </td>
                            <td style="text-align:center;">
                                <cfif len(price)>
                                    #session.ep.money#
                                </cfif>
                            </td>
                            <td style="text-align:right;mso-number-format:'00\.00';"><cfif len(butun_toplam) and butun_toplam neq 0 and len(price)>#NumberFormat(Evaluate(100*price/butun_toplam),"00.00")#<cfelse>00.00</cfif></td>
                        </tr>
                    </cfoutput>
                </tbody>
                <tfoot>
                    <cfoutput>
                        <tr height="20" class="color-list">
                            <td colspan="5" class="txtbold" style="text-align:right"><cf_get_lang_main no='80.Toplam'></td>
                            <td class="txtbold" style="text-align:right;">#TLFormat(toplam_miktar)#</td>
                            <td></td>
                            <cfif x_unit_weight eq 1>
                                <td class="txtbold" style="text-align:right;">#TLFormat(toplam_weight,4)#</td>
                            </cfif>
                            <cfif x_show_second_unit eq 1 and listfind('2,3',attributes.report_type)>
                                    <td class="txtbold" style="text-align:right;">
                                    <cfloop query="get_product_units">
                                        <cfset unit_ = filterSpecialChars(get_product_units.unit)>
                                        <cfif evaluate('toplam_ikinci_#unit_#') gt 0>
                                            #TLFormat(evaluate('toplam_ikinci_#unit_#'))# <br>
                                        </cfif>
                                    </cfloop>
                                </td>                                        
                                <td style="text-align:center;" class="txtbold">
                                    <cfloop query="get_product_units">
                                        <cfset unit_ = filterSpecialChars(get_product_units.unit)>
                                        <cfif evaluate('toplam_ikinci_#unit_#') gt 0>
                                            #unit_# <br>
                                        </cfif>
                                    </cfloop>
                                </td>
                            </cfif>
                            <cfif isdefined('attributes.is_product_cost')>
                            <td></td>
                            <td nowrap class="txtbold" style="text-align:right;">#TLFormat(toplam_maliyet)# </td>
                            </cfif>
                            <cfif attributes.is_other_money eq 1 or attributes.is_money2>
                                <td class="txtbold" style="text-align:right;"><cfif attributes.is_money2>#TLFormat(toplam_satis_doviz)#</cfif></td>
                                <td></td>
                            </cfif>
                            <cfif isdefined('attributes.is_product_cost')>
                            <td style="text-align:center;" class="txtbold">
                            #session.ep.money# 
                            </td>
                            </cfif>
                            <td class="txtbold" style="text-align:right;">#TLFormat(toplam_satis)# </td>
                            <td class="txtbold" style="text-align:center;">#session.ep.money#</td>
                            <td></td>
                        </tr>
                    </cfoutput>  
                </tfoot>
                <cfelse>
                        <tr><td colspan="20"><cf_get_lang_main no='72.Kayıt Yok'>!</td></tr>
                </cfif> 
            </cfif>
        </cf_report_list>          
        <cfif  isdefined("attributes.form_submitted") and attributes.totalrecords gt attributes.maxrows>	
            <cfscript>
                str_link = "form_submitted=1";
                str_link = "#str_link#&process_type=#attributes.process_type#&report_sort=#attributes.report_sort#&product_employee_id=#attributes.product_employee_id#";
                str_link = "#str_link#&sales_employee=#attributes.sales_employee#&sales_employee_id=#attributes.sales_employee_id#&employee_id=#attributes.employee_id#";
                str_link = "#str_link#&product_name=#attributes.product_name#&product_id=#attributes.product_id#&employee_name=#attributes.employee_name#";
                str_link = "#str_link#&keyword=#attributes.keyword#";
                str_link = "#str_link#&department_id=#attributes.department_id#&consumer_id=#attributes.consumer_id#";
                str_link = "#str_link#&company=#attributes.company#&company_id=#attributes.company_id#&product_cat=#attributes.product_cat#&search_product_catid=#attributes.search_product_catid#&hierarcy=#attributes.hierarcy#";
                str_link = "#str_link#&kdv_dahil=#attributes.kdv_dahil#&date1=#dateformat(attributes.date1,dateformat_style)#";
                str_link = "#str_link#&date2=#dateformat(attributes.date2,dateformat_style)#&report_type=#attributes.report_type#";
                str_link = "#str_link#&member_cat_type=#attributes.member_cat_type#";
                str_link = "#str_link#&project_id=#attributes.project_id#";
                str_link = "#str_link#&project_head=#attributes.project_head#";
                str_link = "#str_link#&sector_cat_id=#attributes.sector_cat_id#";
                str_link = "#str_link#&kontrol=#attributes.kontrol#";
                str_link = "#str_link#&invoice_action=#attributes.invoice_action#";
                str_link = "#str_link#&ship_address=#attributes.ship_address#";
                str_link = "#str_link#&brand_id=#attributes.brand_id#&brand_name=#attributes.brand_name#";
                str_link = "#str_link#&model_id=#attributes.model_id#&model_name=#attributes.model_name#";
                str_link = "#str_link#&ship_method_id=#attributes.ship_method_id#&ship_method_name=#attributes.ship_method_name#";
                if(isdefined('attributes.is_product_cost')) str_link = "#str_link#&is_product_cost=#attributes.is_product_cost#";
                if(isdefined('attributes.is_spect_info')) str_link = "#str_link#&is_spect_info=#attributes.is_spect_info#";
                if(isdefined("attributes.is_money_info"))str_link = "#str_link#&is_money_info=#attributes.is_money_info#";
                if(isdefined("attributes.is_monthly_based"))str_link = "#str_link#&is_monthly_based=#attributes.is_monthly_based#";
                if(isdefined("attributes.is_ref_no"))str_link = "#str_link#&is_ref_no=#attributes.is_ref_no#";
                if(isdefined("attributes.is_project"))str_link = "#str_link#&is_project=#attributes.is_project#";
                if(isdefined("attributes.model_month"))str_link = "#str_link#&model_month=#attributes.model_month#";
                if(isdefined("attributes.deliver_date1"))str_link = "#str_link#&deliver_date1=#dateformat(attributes.deliver_date1,dateformat_style)#";
                if(isdefined("attributes.deliver_date2"))str_link = "#str_link#&deliver_date2=#dateformat(attributes.deliver_date2,dateformat_style)#";
            </cfscript>
            <cf_paging
                    page="#attributes.page#" 
                    maxrows="#attributes.maxrows#" 
                    totalrecords="#attributes.totalrecords#" 
                    startrow="#attributes.startrow#" 
                    adres="#attributes.fuseaction#&#str_link#">  
        </cfif>
    </cfif>             
</div>
<script language="JavaScript">
    <cfif attributes.is_excel eq 1>
        $(function(){TableToExcel.convert(document.getElementById('sales_list'));});
    </cfif>
	function set_the_report()
	{
		rapor.report_type.checked = false;
	}
	function type_gizle()
	{
		
		if (rapor.report_type.value == 11)
		{	
		   document.getElementById('model_month_td').style.display = '';	
		}
		else
		{
			document.getElementById('model_month_td').style.display = 'none';
			document.rapor.model_month.checked = false
		}
		
		if (rapor.report_type.value == 6)
		{
			money_info_2.style.display = '';
			rapor.kontrol.value = 1;
		}
		else
		{
			money_info_2.style.display = 'none';
			rapor.kontrol.value = 0;
		}
		if(rapor.report_type.value == 6)	
		{
			rapor.is_spect_info.style.display = '';
			if(spect_info_2 != undefined)
				spect_info_2.style.display = '';
		}
		else
		{
			rapor.is_spect_info.style.display = 'none';
			if(spect_info_2 != undefined)
				spect_info_2.style.display = 'none';
		}
		if(rapor.report_type.value == 2 || rapor.report_type.value == 3)	
		{
			rapor.is_monthly_based.style.display = '';
			if(monthly_based != undefined)
				monthly_based.style.display = '';
		}
		else
		{
			rapor.is_monthly_based.style.display = 'none';
			if(monthly_based != undefined)
				monthly_based.style.display = 'none';
		}
		if(rapor.report_type.value == 6)	
		{
			rapor.is_ref_no.style.display = '';
			if(ref_no != undefined)
				ref_no.style.display = '';
		}
		else
		{
			rapor.is_ref_no.style.display = 'none';
			if(ref_no != undefined)
				ref_no.style.display = 'none';
		}		
	}
	function prod_cost_control()
	{
     
		/*if(document.getElementById('process_type').value=='')
		{
			alert('<cf_get_lang_main no="1358.İşlem Tipi Seçiniz">');
			return false;	
		}*/
        if(!date_check(rapor.date1,rapor.date2,"<cf_get_lang no ='1093.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!")){
					return false;
				}  
		if(!date_check(rapor.deliver_date1,rapor.deliver_date2,"<cf_get_lang no ='1093.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!")){
					return false;
				} 

        if(document.rapor.is_excel.checked==false)
		{
			document.rapor.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>";
			return true;
		}
		else $('#rapor').submit();
			


		var temp_report_type=rapor.report_type.options[rapor.report_type.selectedIndex].value;
		if(rapor.is_product_cost.checked==true && list_find('4,5',temp_report_type))
		{
			alert("<cf_get_lang no ='1566.İl ve Müşteri Bazında Raporlamada Maliyet Çalıştırılmıyor'>!");
			return false;
		}
		if(document.rapor.is_excel.checked==false)
		{
			document.rapor.action="<cfoutput>#request.self#?fuseaction=report.sale_analyse_report_ship</cfoutput>";
			return true;
		}
		else $('#rapor').submit();
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
			alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='107.Cari Hesap'>");
			return false;
		}
	}
		
	function dissable_check(type)
	{
		if (type == 1)
			document.getElementById("is_money2").checked = false;
		else if(type == 2)
			document.getElementById("is_other_money").checked = false;
	}
	type_gizle();
</script>
