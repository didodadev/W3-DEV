<!--- 
20060504 Bu rapor : islem kategorileri -multiple- bazinda (tipleri degil !!!), ve depolar bazında -multiple- 
kategori, urun ve stok bazinda alislarin toplamini alir (secilirse iadeleri de duserek -verilen fiyat farki 58 ve alim iade 62-).
müsteri kategorileri de eklendi -multiple- FB 20080214

Modified by : Hgul. Cari bazında, belge ve stok bazında rapor tiplerinde bireysel üyelerinde gelmesi sağlandı. 20120726 
 ---><cfsetting showdebugoutput="yes">
<cfparam name="attributes.module_id_control" default="20,12">
<cfinclude template="report_authority_control.cfm">
<cf_xml_page_edit fuseact="report.purchase_analyse_report">
<cf_get_lang_set module_name="report">
<cfparam name="attributes.hierarcy" default="">
<cfparam name="attributes.graph_type" default="">
<cfparam name="attributes.max_rows" default='#session.ep.maxrows#'>
<cfparam name="attributes.process_type" default="">
<cfparam name="attributes.report_sort" default="1">
<cfparam name="attributes.product_employee_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.is_return" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.sale_employee_id" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.department_name" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.is_other_money" default="0">
<cfparam name="attributes.is_money2" default="0">
<cfparam name="attributes.is_discount" default="0">
<cfparam name="attributes.search_product_catid" default="">
<cfparam name="attributes.date1" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.date2" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.kdv_dahil" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.report_type" default="1">
<cfparam name="attributes.invoice_count" default="">
<cfparam name="attributes.taxno" default="">
<cfparam name="attributes.kontrol_type" default="0">
<cfparam name="attributes.brand_name" default="">
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.model_name" default="" >
<cfparam name="attributes.model_id" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.payment_type_id" default="">
<cfparam name="attributes.card_paymethod_id" default="">
<cfparam name="attributes.payment_type" default="">
<cfparam name="attributes.member_cat_type" default="">
<cfparam name="attributes.cost_price" default="">
<cfparam name="attributes.is_project" default="">
<cfparam name="attributes.is_spect_info" default="">
<cfparam name="attributes.use_efatura" default="">
<cfparam name="attributes.stock_code" default="">
<cfif attributes.is_other_money eq 1 and attributes.is_money2 eq 1>
	<cfset attributes.is_money2 = 0>
</cfif>
<cfif attributes.report_type eq 5>
	<cfset project_id_list=''>
	<cfquery name="get_project" datasource="#dsn#">
		SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS
	</cfquery>
	<cfset project_id_list = valuelist(get_project.project_id,',')>
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
		<cfif x_show_pasive_departments eq 0>
			D.DEPARTMENT_STATUS = 1 AND
		</cfif>
		B.BRANCH_ID IN(SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
	ORDER BY 
		DEPARTMENT_HEAD
</cfquery>
<cfset branch_dep_list=valuelist(get_department.department_id,',')><!--- Eğer depo seçilmeden çalıştırılırsa yine arka tarafta yetkili olduklarına bakacak --->
<cfquery name="GET_ALL_LOCATION" datasource="#DSN#">
	SELECT DEPARTMENT_ID,LOCATION_ID,COMMENT FROM STOCKS_LOCATION <cfif x_show_pasive_departments eq 0>WHERE STATUS = 1</cfif>
</cfquery>						
<cfquery name="get_money" datasource="#dsn2#">
	SELECT MONEY_ID,MONEY FROM SETUP_MONEY
</cfquery>

<cfquery name="get_product_units" datasource="#dsn#">
	SELECT UNIT_ID,UNIT FROM SETUP_UNIT
</cfquery>
<cfset unit_kontr = valuelist(get_product_units.unit,',')>
<cfoutput query="get_product_units">
	<cfset unit_ = filterSpecialChars(get_product_units.unit)>
	<cfset 'toplam_#unit_#' = 0>
    <cfset 'toplam_2_#unit_#' = 0>
    <cfset 'toplam_miktar_#unit_#' = 0>
    <cfset 'toplam_miktar_2_#unit_#' = 0>
</cfoutput>
<cfoutput query="get_money">
	<cfset "toplam_#money#" = 0>
</cfoutput>
<cfquery name="get_process_cat" datasource="#dsn3#">
	SELECT PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (49,51,54,55,59,591,592,60,601,61,62,63,64,68,690,691) ORDER BY PROCESS_TYPE
</cfquery>
<cfset process_type_list= valuelist(get_process_cat.process_cat_id)>
<cf_date tarih='attributes.date1'>
<cf_date tarih='attributes.date2'>
<cfif isdefined("attributes.form_submitted")>
	<cfset kurumsal = ''>
	<cfset bireysel = ''>
	<cfif listlen(attributes.member_cat_type)>
		<cfset uzunluk=listlen(attributes.member_cat_type)>
		<cfloop from="1" to="#uzunluk#" index="catyp">
			<cfset eleman = listgetat(attributes.member_cat_type,catyp,',')>
			<cfif listlen(eleman) and listfirst(eleman,'-') eq 1>
				<cfset kurumsal = listappend(kurumsal,eleman)>
			<cfelseif listlen(eleman) and listfirst(eleman,'-') eq 2>
				<cfset bireysel = listappend(bireysel,eleman)>
			</cfif>
		</cfloop>
	</cfif>
	<cfif attributes.report_type neq 4 and attributes.report_type neq 5>
		<cfquery name="check_table" datasource="#DSN2#">
        	IF EXISTS (select * from tempdb.sys.tables where name='####get_total_purchase_#session.ep.userid#')
            DROP TABLE ####get_total_purchase_#session.ep.userid#
        </cfquery>
        <cfquery name="get_total_purchase" datasource="#DSN2#" result="xxx">
			SELECT
				<cfif attributes.report_type eq 12>
					<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                    	<cfif attributes.is_other_money eq 1>
                        	I.OTHER_MONEY,
						</cfif>
						<cfif attributes.kdv_dahil eq 1>
                            (IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL) AS ISKONTO,
                            (((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL))) / INVM.RATE2 AS  ISKONTO_DOVIZ,
                            (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1) * IR.NETTOTAL *(IR.TAX+100)/100 ) AS PRICE,
                            (((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1) * IR.NETTOTAL *(IR.TAX+100)/100)) / INVM.RATE2) AS PRICE_DOVIZ
                        <cfelse>
                            (IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL) AS ISKONTO,
                            (((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) / INVM.RATE2) ISKONTO_DOVIZ,
                            (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL  AS PRICE,
                            ( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL) / INVM.RATE2 AS PRICE_DOVIZ
                        </cfif>
                    <cfelse>
                        <cfif attributes.kdv_dahil eq 1>
                            (IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL) AS ISKONTO,
                             (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL *(IR.TAX+100)/100  AS PRICE
                        <cfelse>
                            (IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL) AS ISKONTO,
                             (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL  AS PRICE
                        </cfif>
                    </cfif>
                <cfelse>
                	<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
						<cfif attributes.is_other_money eq 1>
                        	I.OTHER_MONEY,
						</cfif>
						<cfif attributes.kdv_dahil eq 1>
                            SUM((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) AS ISKONTO,
                            SUM(((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) / INVM.RATE2) ISKONTO_DOVIZ,
                            SUM( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL *(IR.TAX+100)/100 ) AS PRICE,
                            SUM( ( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL *(IR.TAX+100)/100) / INVM.RATE2 ) AS PRICE_DOVIZ
                        <cfelse>
                            SUM((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) AS ISKONTO,
                            SUM(((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) / INVM.RATE2) ISKONTO_DOVIZ,
                            SUM( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL ) AS PRICE,
                            SUM( ( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL) / INVM.RATE2 ) AS PRICE_DOVIZ
                        </cfif>
					<cfelse>
						<cfif attributes.kdv_dahil eq 1>
                            SUM((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) AS ISKONTO,
                            SUM( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL *(IR.TAX+100)/100 ) AS PRICE
                        <cfelse>
                            SUM((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) AS ISKONTO,
                            SUM( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL ) AS PRICE
                    	</cfif>
					</cfif>
				</cfif>
				<cfif attributes.report_type eq 1 or attributes.report_type eq 11>
					,PC.PRODUCT_CAT
					,PC.HIERARCHY
					,PC.PRODUCT_CATID
					,SUM(IR.AMOUNT) AS PRODUCT_STOCK
					,SUM(IR.AMOUNT2) AS PRODUCT_STOCK2
					,IR.UNIT AS BIRIM
					,IR.UNIT2 AS BIRIM2
				<cfelseif attributes.report_type eq 2>
					,PC.PRODUCT_CAT
					,PC.HIERARCHY
					,PC.PRODUCT_CATID
					,P.PRODUCT_ID
					,P.PRODUCT_NAME
					,P.BARCOD
					,SUM(IR.AMOUNT) AS PRODUCT_STOCK
					,SUM(IR.EXTRA_COST*IR.AMOUNT) AS COST_PRICE
					,IR.UNIT AS BIRIM
				<cfelseif attributes.report_type eq 3>
					,PC.PRODUCT_CAT
					,PC.HIERARCHY
					,PC.PRODUCT_CATID
					,P.PRODUCT_ID
					,P.PRODUCT_NAME
					,S.STOCK_CODE
					,S.BARCOD
					,S.PROPERTY,
					IR.STOCK_ID
					,SUM(IR.AMOUNT) AS PRODUCT_STOCK
					,SUM(IR.EXTRA_COST*IR.AMOUNT) AS COST_PRICE
					,IR.UNIT AS BIRIM
				<cfelseif attributes.report_type eq 6>
					,PB.BRAND_NAME
					,P.BRAND_ID
					,SUM(IR.AMOUNT) AS PRODUCT_STOCK
				<cfelseif attributes.report_type eq 7>
					,PR.PROJECT_ID
					,PR.PROJECT_HEAD
					,SUM(IR.AMOUNT) AS PRODUCT_STOCK
				<cfelseif attributes.report_type eq 8>
					,I.PAY_METHOD
					,I.CARD_PAYMETHOD_ID
					,SUM(IR.AMOUNT) AS PRODUCT_STOCK
				<cfelseif attributes.report_type eq 9>
					,EP.POSITION_CODE AS POSITION_CODE
					,SUM(IR.AMOUNT) AS PRODUCT_STOCK
				<cfelseif attributes.report_type eq 10>
					,B.BRANCH_NAME
					,B.BRANCH_ID
					,SUM(IR.AMOUNT) AS PRODUCT_STOCK
					,SUM(IR.AMOUNT2) AS PRODUCT_STOCK2
					,IR.UNIT AS BIRIM
					,IR.UNIT2 AS BIRIM2
				<cfelseif attributes.report_type eq 12>
               		 ,IR.AMOUNT  AS PRODUCT_STOCK
					<cfif isdefined('attributes.product_types') and not len(attributes.product_types)>
                        ,CASE
                            WHEN P.IS_PURCHASE = 1 THEN 1  END AS t_1   
                         ,CASE   
                            WHEN P.IS_INVENTORY = 0 THEN 2  END AS t_2
                        ,CASE    
                            WHEN (P.IS_INVENTORY = 1 AND P.IS_PRODUCTION = 0) THEN 3 END AS t_3
                        ,CASE    
                            WHEN P.IS_TERAZI = 1 THEN 4  END AS t_4
                        ,CASE    
                            WHEN P.IS_PURCHASE = 0 THEN 5 END AS t_5
                        ,CASE    
                            WHEN P.IS_PRODUCTION = 1 THEN 6 END AS t_6
                        ,CASE    
                            WHEN P.IS_SERIAL_NO = 1 THEN 7 END AS t_7
                        ,CASE    
                            WHEN P.IS_KARMA = 1 THEN 8 END AS t_8
                        ,CASE    
                            WHEN P.IS_INTERNET = 1 THEN 9  END AS t_9
                        ,CASE    
                            WHEN P.IS_PROTOTYPE = 1 THEN 10  END AS t_10
                        ,CASE    
                            WHEN P.IS_ZERO_STOCK = 1 THEN 11 END AS t_11
                        ,CASE    
                            WHEN P.IS_EXTRANET = 1 THEN 12 END AS t_12
                        ,CASE    
                            WHEN P.IS_COST = 1 THEN 13 END AS t_13
                        ,CASE    
                            WHEN P.IS_SALES = 1 THEN 14 END AS t_14
                        ,CASE    
                            WHEN P.IS_QUALITY = 1 THEN 15 END AS t_15
                        ,CASE    
                            WHEN P.IS_INVENTORY = 1 THEN 16 END AS t_16
                    <cfelse>
                    	<cfif isdefined('attributes.product_types') and (attributes.product_types eq 1)>
                        ,CASE
                            WHEN P.IS_PURCHASE = 1 THEN 1  END AS t_1   
                         </cfif>
                         <cfif isdefined('attributes.product_types') and (attributes.product_types eq 2)>
                         ,CASE   
                            WHEN P.IS_INVENTORY = 0 THEN 2  END AS t_2
                         </cfif>
                        <cfif isdefined('attributes.product_types') and (attributes.product_types eq 3)>
                        ,CASE    
                            WHEN (P.IS_INVENTORY = 1 AND P.IS_PRODUCTION = 0) THEN 3 END AS t_3
                        </cfif>
                        <cfif isdefined('attributes.product_types') and (attributes.product_types eq 4)>
                        ,CASE    
                            WHEN P.IS_TERAZI = 1 THEN 4  END AS t_4
                        </cfif>
                        <cfif isdefined('attributes.product_types') and (attributes.product_types eq 5)>
                        ,CASE    
                            WHEN P.IS_PURCHASE = 0 THEN 5 END AS t_5
                        </cfif>
                        <cfif isdefined('attributes.product_types') and (attributes.product_types eq 6)>
                        ,CASE    
                            WHEN P.IS_PRODUCTION = 1 THEN 6 END AS t_6
                        </cfif>
                        <cfif isdefined('attributes.product_types') and (attributes.product_types eq 7)>
                        ,CASE    
                            WHEN P.IS_SERIAL_NO = 1 THEN 7 END AS t_7
                        </cfif>
                        <cfif isdefined('attributes.product_types') and (attributes.product_types eq 8)>
                        ,CASE    
                            WHEN P.IS_KARMA = 1 THEN 8 END AS t_8
                        </cfif>
                        <cfif isdefined('attributes.product_types') and (attributes.product_types eq 9)>
                        ,CASE    
                            WHEN P.IS_INTERNET = 1 THEN 9  END AS t_9
                        </cfif>
                        <cfif isdefined('attributes.product_types') and (attributes.product_types eq 10)>
                        ,CASE    
                            WHEN P.IS_PROTOTYPE = 1 THEN 10  END AS t_10
                        </cfif>
                        <cfif isdefined('attributes.product_types') and (attributes.product_types eq 11)>
                        ,CASE    
                            WHEN P.IS_ZERO_STOCK = 1 THEN 11 END AS t_11
                        </cfif>
                        <cfif isdefined('attributes.product_types') and (attributes.product_types eq 12)>
                        ,CASE    
                            WHEN P.IS_EXTRANET = 1 THEN 12 END AS t_12
                        </cfif>
                        <cfif isdefined('attributes.product_types') and (attributes.product_types eq 13)>
                        ,CASE    
                            WHEN P.IS_COST = 1 THEN 13 END AS t_13
                        </cfif>
                        <cfif isdefined('attributes.product_types') and (attributes.product_types eq 14)>
                        ,CASE    
                            WHEN P.IS_SALES = 1 THEN 14 END AS t_14
                        </cfif>
                        <cfif isdefined('attributes.product_types') and (attributes.product_types eq 15)>
                        ,CASE    
                            WHEN P.IS_QUALITY = 1 THEN 15 END AS t_15
                        </cfif>
                        <cfif isdefined('attributes.product_types') and (attributes.product_types eq 16)>
                        ,CASE    
                            WHEN P.IS_INVENTORY = 1 THEN 16 END AS t_16
						</cfif>
					</cfif> 
				</cfif>
				,0 TYPE
			<cfif attributes.report_type eq 12>
            	INTO ####get_total_purchase_#session.ep.userid#
			</cfif>
            FROM
				INVOICE I
				<cfif len(attributes.use_efatura)>
					LEFT JOIN EINVOICE_RECEIVING_DETAIL ERD ON ERD.INVOICE_ID = I.INVOICE_ID
				</cfif>,
					INVOICE_ROW IR,		
					#dsn3_alias#.STOCKS S,
					#dsn3_alias#.PRODUCT P
					LEFT JOIN #dsn3_alias#.PRODUCT_CAT PC ON PC.PRODUCT_CATID = P.PRODUCT_CATID
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					,INVOICE_MONEY INVM
				</cfif>
				<cfif attributes.report_type eq 6>
					,#dsn3_alias#.PRODUCT_BRANDS PB
				<cfelseif attributes.report_type eq 7>
					,#dsn_alias#.PRO_PROJECTS PR
				<cfelseif attributes.report_type eq 9>
					,#dsn_alias#.EMPLOYEE_POSITIONS EP
				<!---<cfelseif attributes.report_type eq 11>
					,#dsn3_alias#.PRODUCT_CAT PC_2 --->
				<cfelseif attributes.report_type eq 10>
					,#dsn_alias#.DEPARTMENT D
					,#dsn_alias#.BRANCH B			
				</cfif>
			WHERE
				<cfif len(attributes.use_efatura) and attributes.use_efatura eq 1>
					ERD.INVOICE_ID IS NOT NULL AND
				<cfelseif len(attributes.use_efatura) and attributes.use_efatura eq 0>
					ERD.INVOICE_ID IS NULL AND
				</cfif>
				I.IS_IPTAL = 0 AND
				<cfif not isdefined("attributes.is_zero_value")>
					I.GROSSTOTAL > 0 AND
					I.NETTOTAL > 0 AND
				</cfif>
				S.PRODUCT_ID = P.PRODUCT_ID AND
				IR.STOCK_ID = S.STOCK_ID AND
				I.INVOICE_ID = IR.INVOICE_ID AND
				I.INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"> AND
				S.PRODUCT_ID = IR.PRODUCT_ID AND
				I.INVOICE_CAT NOT IN (62) AND
                <cfif isdefined('attributes.product_types') and (attributes.product_types eq 1)>
                    P.IS_PURCHASE = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 2)>
                    P.IS_INVENTORY = 0 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 3)>
                    P.IS_INVENTORY = 1 AND P.IS_PRODUCTION = 0 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 4)>
                    P.IS_TERAZI = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 5)>
                    P.IS_PURCHASE = 0 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 6)>
                    P.IS_PRODUCTION = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 7)>
                    P.IS_SERIAL_NO = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 8)>
                    P.IS_KARMA = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 9)>
                    P.IS_INTERNET = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 10)>
                    P.IS_PROTOTYPE = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 11)>
                    P.IS_ZERO_STOCK = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 12)>
                    P.IS_EXTRANET = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 13)>
                    P.IS_COST = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 14)>
                    P.IS_SALES = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 15)>
                    P.IS_QUALITY = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 16)>
                    P.IS_INVENTORY = 1 AND
                </cfif>
				<cfif attributes.report_type eq 11>
				<!---	PC_2.PRODUCT_CATID = P.PRODUCT_CATID AND--->
					CHARINDEX('.',PC.HIERARCHY) = 0 
				<!---	AND PC.HIERARCHY = LEFT(PC.HIERARCHY,(CHARINDEX('.',PC.HIERARCHY)-1))	--->		
				<cfelse>
					1 = 1 
				</cfif>
				<cfif attributes.report_type eq 6>
					AND P.BRAND_ID = PB.BRAND_ID 
				<cfelseif attributes.report_type eq 7>
					AND I.PROJECT_ID = PR.PROJECT_ID
				<cfelseif attributes.report_type eq 9>
					AND P.PRODUCT_MANAGER = EP.POSITION_CODE
				<cfelseif attributes.report_type eq 10>
					AND I.DEPARTMENT_ID = D.DEPARTMENT_ID 
					AND D.BRANCH_ID = B.BRANCH_ID			
				</cfif>
				<cfif len(attributes.process_type)>
					AND I.PROCESS_CAT IN (#attributes.process_type#)
				<cfelseif len(process_type_list)>
					AND I.PROCESS_CAT IN (#process_type_list#)	
				</cfif>
				<cfif len(attributes.project_id) and len(attributes.project_head)>
				 	AND I.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
				</cfif>
				<cfif attributes.is_other_money eq 1>
					AND INVM.ACTION_ID = I.INVOICE_ID 
					AND INVM.MONEY_TYPE = I.OTHER_MONEY
				<cfelseif attributes.is_money2 eq 1>
					AND INVM.ACTION_ID = I.INVOICE_ID
					AND INVM.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
				</cfif>
                <cfif len(trim(attributes.STOCK_CODE)) and len(attributes.STOCK_CODE)>AND S.STOCK_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.stock_code#"></cfif>
				<cfif len(trim(attributes.employee)) and len(attributes.sale_employee_id)>AND I.SALE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sale_employee_id#"></cfif>
				<cfif len(attributes.company) and len(attributes.company_id) and attributes.company_id neq 0>AND I.COMPANY_ID=	<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"></cfif>
				<cfif len(attributes.company) and len(attributes.consumer_id) and attributes.consumer_id neq 0>AND I.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"></cfif>
				<cfif len(attributes.company) and len(attributes.employee_id) and attributes.employee_id neq 0>AND I.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"></cfif>
				<cfif len(trim(attributes.product_cat)) and len(attributes.search_product_catid)>AND PC.HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.search_product_catid#%"></cfif>
				<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>AND	P.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"></cfif>		
				<cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>AND P.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_employee_id#"></cfif>
				<cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>AND P.BRAND_ID IN (#attributes.brand_id#)</cfif>
				<cfif len(trim(attributes.model_name)) and len(attributes.model_id)>AND P.SHORT_CODE_ID IN (#attributes.model_id#)</cfif>
				<cfif isdefined("kurumsal") and listlen(kurumsal)>
					AND <cfif isdefined("bireysel") and listlen(bireysel)>(</cfif>I.COMPANY_ID IN
						(
						SELECT 
							C.COMPANY_ID 
						FROM 
							#dsn_alias#.COMPANY C,
							#dsn_alias#.COMPANY_CAT CAT
						WHERE 
							C.COMPANYCAT_ID = CAT.COMPANYCAT_ID AND
							(
								<cfloop list="#kurumsal#" delimiters="," index="cat_i">
									(CAT.COMPANYCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(cat_i,'-')#">)
									<cfif cat_i neq listlast(kurumsal,',') and listlen(kurumsal,',') gte 1> OR</cfif>
								</cfloop>  
							)
						)
				</cfif>
				<cfif isdefined("bireysel") and listlen(bireysel)>
					<cfif isdefined("kurumsal") and listlen(kurumsal)>OR<cfelse>AND</cfif> I.CONSUMER_ID IN
						(
						SELECT 
							C.CONSUMER_ID 
						FROM 
							#dsn_alias#.CONSUMER C,
							#dsn_alias#.CONSUMER_CAT CAT 
						WHERE 
							C.CONSUMER_CAT_ID = CAT.CONSCAT_ID AND
							(
								<cfloop list="#bireysel#" delimiters="," index="cat_i">
									(CAT.CONSCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(cat_i,'-')#">)
									<cfif cat_i neq listlast(bireysel,',') and listlen(bireysel,',') gte 1> OR</cfif>
								</cfloop>  
							)
						)
					<cfif isdefined("kurumsal") and listlen(kurumsal)>)</cfif>	
				</cfif>
				<cfif len(attributes.payment_type) and len(attributes.payment_type_id)>
					AND I.PAY_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.payment_type_id#">
				<cfelseif len(attributes.payment_type) and len(attributes.card_paymethod_id)>
					AND I.CARD_PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.card_paymethod_id#">
				</cfif>
				<cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_id) and len(ship_method_name)>
					AND I.SHIP_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_method_id#">
				</cfif>
				<cfif len(attributes.department_id)>
				AND(
					<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
						(I.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND I.DEPARTMENT_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
						<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
					</cfloop>  
					)
				<cfelseif len(branch_dep_list)>
					AND I.DEPARTMENT_ID IN (#branch_dep_list#)
				</cfif>	
			<cfif attributes.report_type neq 12>
          	 GROUP BY	
				<cfif attributes.is_other_money eq 1>
					I.OTHER_MONEY,
				</cfif>
				<cfif attributes.report_type eq 1 or attributes.report_type eq 11>
					PC.PRODUCT_CAT,
					PC.PRODUCT_CATID,			
					PC.HIERARCHY,
					IR.UNIT,
					IR.UNIT2
				<cfelseif attributes.report_type eq 2>
					PC.PRODUCT_CAT,
					PC.PRODUCT_CATID,
					PC.HIERARCHY,
					P.PRODUCT_ID,
					P.BARCOD,
					P.PRODUCT_NAME,
					IR.PRODUCT_ID,
					IR.UNIT
				<cfelseif attributes.report_type eq 3>
					PC.PRODUCT_CAT,
					PC.PRODUCT_CATID,
					PC.HIERARCHY,
					IR.STOCK_ID,
					P.PRODUCT_NAME,
					P.PRODUCT_ID,
					S.PROPERTY,
					S.STOCK_CODE,
					S.BARCOD,
					IR.UNIT
				<cfelseif attributes.report_type eq 6>
					PB.BRAND_NAME,
					P.BRAND_ID
				<cfelseif attributes.report_type eq 7>
					PR.PROJECT_ID,
					PR.PROJECT_HEAD
				<cfelseif attributes.report_type eq 8>
					I.PAY_METHOD,
					I.CARD_PAYMETHOD_ID
				<cfelseif attributes.report_type eq 9>
					EP.POSITION_CODE
				<cfelseif attributes.report_type eq 10>
					B.BRANCH_NAME,
					B.BRANCH_ID	,
					IR.UNIT,
					IR.UNIT2
                <cfelseif attributes.report_type eq 12>
				</cfif>
            </cfif>    
			ORDER BY 
				<cfif attributes.report_sort eq 1>
					PRICE DESC
				<cfelseif attributes.report_sort eq 2>
					PRODUCT_STOCK DESC
				</cfif>
		</cfquery>
        <cfif attributes.report_type eq 12>
            <cfquery name="get_total_purchase" datasource="#DSN2#" result="xxx">
                SELECT 
					SUM(PRICE) AS PRICE,
					SUM(ISKONTO) AS ISKONTO
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					,SUM(PRICE_DOVIZ) AS PRICE_DOVIZ
					,SUM(ISKONTO_DOVIZ) AS ISKONTO_DOVIZ
                    <cfif attributes.is_other_money eq 1>
                        ,OTHER_MONEY
					</cfif>
				</cfif>
				<cfif attributes.report_type eq 4>
					,NICKNAME,COMPANY_ID,TAXOFFICE,TAXNO,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
				<cfelseif attributes.report_type eq 5>
					,INVOICE_ID,INVOICE_NUMBER,DEPARTMENT_ID,PURCHASE_SALES,
					DEPARTMENT_LOCATION,MUSTERI,COMPANY_ID,OZEL_KOD_2,BIRIM_FIYAT,OTHER_MONEY_VALUE,OTHER_MONEY,INVOICE_DATE,PRODUCT_CAT,HIERARCHY,PRODUCT_CATID,PRODUCT_ID,PRODUCT_NAME,PRODUCT_CODE,MANUFACT_CODE,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,SUM(IR.AMOUNT2) AS PRODUCT_STOCK2,SUM(IR.NETTOTAL) AS NET_TOTAL,SUM(COST_PRICE) AS COST_PRICE,BIRIM,BIRIM2,INVOICE_ROW_ID,DUE_DATE,INV_DUE_DATE,NOTE,SPECT_VAR_NAME,SPECT_MAIN_ID,ROW_PROJECT_ID,PROJECT_ID,LOT_NO,BARCOD
				<cfelseif attributes.report_type eq 12>
                	,PRODUCT_TYPE,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
                </cfif>	
					,TYPE
                FROM
                (SELECT *
                 FROM ####get_total_purchase_#session.ep.userid#) t
                UNPIVOT
                (PRODUCT_TYPE FOR ALAN IN
                    (	<cfif isdefined('attributes.product_types') and not len(attributes.product_types)>
							t_1,
							t_2, 
							t_3, 
							t_4,
							t_5,
							t_6,
							t_7,
							t_8,
							t_9,
							t_10,
							t_11,
							t_12,
							t_13,
							t_14,
							t_15,
							t_16
                         <cfelse>
							 	 <cfif isdefined('attributes.product_types') and (attributes.product_types eq 1)>
                                 	t_1
                                 </cfif>
                                 <cfif isdefined('attributes.product_types') and (attributes.product_types eq 2)>
                                 	t_2
                                 </cfif>
                                 <cfif isdefined('attributes.product_types') and (attributes.product_types eq 3)> 
                                 	t_3
                                 </cfif>
                                 <cfif isdefined('attributes.product_types') and (attributes.product_types eq 4)>
                                 	t_4
                                 </cfif>
                                 <cfif isdefined('attributes.product_types') and (attributes.product_types eq 5)>
                                 	t_5
                                 </cfif>
                                 <cfif isdefined('attributes.product_types') and (attributes.product_types eq 6)>
                                 	t_6
                                 </cfif>
                                 <cfif isdefined('attributes.product_types') and (attributes.product_types eq 7)>
                                 	t_7
                                 </cfif>
                                 <cfif isdefined('attributes.product_types') and (attributes.product_types eq 8)>
                                 	t_8
                                 </cfif>
                                 <cfif isdefined('attributes.product_types') and (attributes.product_types eq 9)>
                                 	t_9
                                 </cfif>
                                 <cfif isdefined('attributes.product_types') and (attributes.product_types eq 10)>
                                 	t_10
                                 </cfif>
                                 <cfif isdefined('attributes.product_types') and (attributes.product_types eq 11)>
                                 	t_11
                                 </cfif>
                                 <cfif isdefined('attributes.product_types') and (attributes.product_types eq 12)>
                                 	t_12
                                 </cfif>
                                 <cfif isdefined('attributes.product_types') and (attributes.product_types eq 13)>
                                 	t_13
                                 </cfif>
                                 <cfif isdefined('attributes.product_types') and (attributes.product_types eq 14)>
                                 	t_14
                                 </cfif>
                                 <cfif isdefined('attributes.product_types') and (attributes.product_types eq 15)>
                                 	t_15
                                 </cfif>
                                 <cfif isdefined('attributes.product_types') and (attributes.product_types eq 16)>
                                 	t_16
                         		 </cfif>
						 </cfif>
                     )
                ) AS u
                GROUP BY 
                	PRODUCT_TYPE
                    ,ALAN
                    ,TYPE
                    <cfif attributes.is_other_money eq 1>
                    	,U.OTHER_MONEY
					</cfif>
			ORDER BY 
				<cfif attributes.report_sort eq 1>
					PRICE DESC
				<cfelseif attributes.report_sort eq 2>
					PRODUCT_STOCK DESC
				</cfif>					
			</cfquery>
        </cfif>
	<cfelse>
		<cfquery name="get_total_purchase" datasource="#DSN2#"><!--- COMPANY --->
			SELECT
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					<cfif attributes.kdv_dahil eq 1>
						SUM((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) AS ISKONTO,
						SUM(((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) / INVM.RATE2) ISKONTO_DOVIZ,
						SUM( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL *(IR.TAX+100)/100 ) AS PRICE,
						SUM( ( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL *(IR.TAX+100)/100) / INVM.RATE2 ) AS PRICE_DOVIZ
					<cfelse>
						SUM((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) AS ISKONTO,
						SUM(((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) / INVM.RATE2) ISKONTO_DOVIZ,
						SUM( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL ) AS PRICE,
						SUM( ( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL) / INVM.RATE2 ) AS PRICE_DOVIZ
					</cfif>
				<cfelse>
					<cfif attributes.kdv_dahil eq 1>
						SUM((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) AS ISKONTO,
						SUM( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL *(IR.TAX+100)/100 ) AS PRICE
					<cfelse>
						SUM((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) AS ISKONTO,
						SUM( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL ) AS PRICE
					</cfif>
				</cfif>
				<cfif attributes.is_other_money eq 1>
					,I.OTHER_MONEY
				</cfif>
				<cfif attributes.report_type eq 4>
					,C.NICKNAME
					,C.COMPANY_ID
					,C.TAXOFFICE
					,C.TAXNO
					,SUM(IR.AMOUNT) AS PRODUCT_STOCK
				<cfelseif attributes.report_type eq 5>
					,I.INVOICE_NUMBER
					,I.SERIAL_NUMBER
					,I.SERIAL_NO
					,I.DEPARTMENT_ID
					,I.DEPARTMENT_LOCATION
					,I.PROJECT_ID
					,C.NICKNAME AS MUSTERI
					,C.COMPANY_ID
					,C.OZEL_KOD_2
					,I.INVOICE_DATE
					,PC.PRODUCT_CAT
					,PC.HIERARCHY
					,PC.PRODUCT_CATID
					,S.PRODUCT_ID
					,P.PRODUCT_NAME
					,P.PRODUCT_CODE
					,P.PRODUCT_CODE_2
					,P.MANUFACT_CODE
					,SUM(IR.AMOUNT) AS PRODUCT_STOCK
                    ,SUM(IR.AMOUNT2) AS PRODUCT_STOCK2
                    ,SUM(IR.NETTOTAL) AS NET_TOTAL
					,SUM(IR.EXTRA_COST) AS COST_PRICE
					,IR.UNIT AS BIRIM
                    ,IR.UNIT2 AS BIRIM2                    
					,SUM(IR.PRICE) AS BIRIM_FIYAT
					,SUM(IR.OTHER_MONEY_VALUE) AS OTHER_MONEY_VALUE
					,I.OTHER_MONEY AS OTHER_MONEY
					,IR.INVOICE_ROW_ID
					,IR.DUE_DATE
					,IR.ROW_PROJECT_ID
					,I.DUE_DATE AS INV_DUE_DATE
					,CAST(I.NOTE AS NVARCHAR) NOTE
					,IR.SPECT_VAR_NAME
					,(SELECT TOP 1 SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS WHERE SPECTS.SPECT_VAR_ID = IR.SPECT_VAR_ID) AS SPECT_MAIN_ID
					,I.PURCHASE_SALES
					,I.INVOICE_ID
					,IR.LOT_NO
			        ,P.BARCOD
                <cfelseif attributes.report_type eq 12>
					,SUM(IR.AMOUNT) AS PRODUCT_STOCK
                	,CASE
                	WHEN P.IS_PURCHASE = 1 THEN 1 
                    WHEN P.IS_INVENTORY = 0 THEN 2 
                    WHEN (P.IS_INVENTORY = 1 AND P.IS_PRODUCTION = 0) THEN 3
                    WHEN P.IS_TERAZI = 1 THEN 4
                    WHEN P.IS_PURCHASE = 0 THEN 5
                    WHEN P.IS_PRODUCTION = 1 THEN 6 
                    WHEN P.IS_SERIAL_NO = 1 THEN 7
                    WHEN P.IS_KARMA = 1 THEN 8 
                    WHEN P.IS_INTERNET = 1 THEN 9
                    WHEN P.IS_PROTOTYPE = 1 THEN 10
                    WHEN P.IS_ZERO_STOCK = 1 THEN 11
                    WHEN P.IS_EXTRANET = 1 THEN 12
                    WHEN P.IS_COST = 1 THEN 13
                    WHEN P.IS_SALES = 1 THEN 14
                    WHEN P.IS_QUALITY = 1 THEN 15
                    WHEN P.IS_INVENTORY = 1 THEN 16 
                    END AS PRODUCT_TYPE
				</cfif>
				,1 TYPE <!--- kurumsal üye --->
			FROM
				INVOICE I
				<cfif len(attributes.use_efatura)>
					LEFT JOIN EINVOICE_RECEIVING_DETAIL ERD ON ERD.INVOICE_ID = I.INVOICE_ID
				</cfif>,
				INVOICE_ROW IR,		
				#dsn3_alias#.STOCKS S,
				#dsn3_alias#.PRODUCT_CAT PC,
				#dsn3_alias#.PRODUCT P
				<cfif attributes.report_type eq 4 or attributes.report_type eq 5>,#dsn_alias#.COMPANY C</cfif>
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					,INVOICE_MONEY INVM
				</cfif>
			WHERE
				<cfif len(attributes.use_efatura) and attributes.use_efatura eq 1>
					ERD.INVOICE_ID IS NOT NULL AND
				<cfelseif len(attributes.use_efatura) and attributes.use_efatura eq 0>
					ERD.INVOICE_ID IS NULL AND
				</cfif>
				I.IS_IPTAL = 0 AND
				<cfif not isdefined("attributes.is_zero_value")>
					I.GROSSTOTAL > 0 AND
					I.NETTOTAL > 0 AND
				</cfif>
                 <cfif isdefined('attributes.product_types') and (attributes.product_types eq 1)>
                    P.IS_PURCHASE = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 2)>
                    P.IS_INVENTORY = 0 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 3)>
                    P.IS_INVENTORY = 1 AND 
                    P.IS_PRODUCTION = 0 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 4)>
                    P.IS_TERAZI = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 5)>
                    P.IS_PURCHASE = 0 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 6)>
                    P.IS_PRODUCTION = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 7)>
                    P.IS_SERIAL_NO = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 8)>
                    P.IS_KARMA = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 9)>
                    P.IS_INTERNET = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 10)>
                    P.IS_PROTOTYPE = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 11)>
                    P.IS_ZERO_STOCK = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 12)>
                    P.IS_EXTRANET = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 13)>
                    P.IS_COST = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 14)>
                    P.IS_SALES = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 15)>
                    P.IS_QUALITY = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 16)>
                    P.IS_INVENTORY = 1 AND
                </cfif>
				S.PRODUCT_ID = P.PRODUCT_ID AND
				IR.STOCK_ID = S.STOCK_ID AND
				I.INVOICE_ID = IR.INVOICE_ID AND
				I.INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"> AND
				S.PRODUCT_ID = IR.PRODUCT_ID AND
				I.INVOICE_CAT NOT IN (62) AND
				PC.PRODUCT_CATID = P.PRODUCT_CATID 
				<cfif attributes.report_type eq 4>
					AND I.COMPANY_ID = C.COMPANY_ID
				<cfelseif attributes.report_type eq 5>
					AND	I.COMPANY_ID = C.COMPANY_ID 
					AND PC.PRODUCT_CATID = P.PRODUCT_CATID
				</cfif>
				<cfif len(attributes.process_type)>
				AND I.PROCESS_CAT IN (#attributes.process_type#)
				<cfelseif len(process_type_list)>
				AND I.PROCESS_CAT IN (#process_type_list#)	
				</cfif>
				<cfif len(attributes.project_id) and len(attributes.project_head)>
				 AND I.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
				</cfif>
				<cfif attributes.is_other_money eq 1>
					AND INVM.ACTION_ID = I.INVOICE_ID 
					AND INVM.MONEY_TYPE = I.OTHER_MONEY
				<cfelseif attributes.is_money2 eq 1>
					AND INVM.ACTION_ID = I.INVOICE_ID
					AND INVM.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
				</cfif>
				<cfif len(trim(attributes.employee)) and len(attributes.sale_employee_id)>AND I.SALE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sale_employee_id#"></cfif>
				<cfif len(attributes.company) and len(attributes.company_id) and attributes.company_id neq 0>AND I.COMPANY_ID=	<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"></cfif>
				<cfif len(attributes.company) and len(attributes.consumer_id) and attributes.consumer_id neq 0>AND I.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"></cfif>
				<cfif len(attributes.company) and len(attributes.employee_id) and attributes.employee_id neq 0>AND I.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"></cfif>
				<cfif len(trim(attributes.product_cat)) and len(attributes.search_product_catid)>AND PC.HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.search_product_catid#%"></cfif>
				<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>AND	P.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"></cfif>		
				<cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>AND P.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_employee_id#"></cfif>
				<cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>AND P.BRAND_ID IN (#attributes.brand_id#)</cfif>
				<cfif len(trim(attributes.model_name)) and len(attributes.model_id)>AND P.SHORT_CODE_ID IN (#attributes.model_id#)</cfif>
				<cfif isdefined("kurumsal") and listlen(kurumsal)>
					AND <cfif isdefined("bireysel") and listlen(bireysel)>(</cfif>I.COMPANY_ID IN
						(
						SELECT 
							C.COMPANY_ID 
						FROM 
							#dsn_alias#.COMPANY C,
							#dsn_alias#.COMPANY_CAT CAT 
						WHERE 
							C.COMPANYCAT_ID = CAT.COMPANYCAT_ID AND
							(
								<cfloop list="#kurumsal#" delimiters="," index="cat_i">
									(CAT.COMPANYCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(cat_i,'-')#">)
									<cfif cat_i neq listlast(kurumsal,',') and listlen(kurumsal,',') gte 1> OR</cfif>
								</cfloop>  
							)
						)
				</cfif>
				<cfif isdefined("bireysel") and listlen(bireysel)>
					<cfif isdefined("kurumsal") and listlen(kurumsal)>OR<cfelse>AND</cfif> I.CONSUMER_ID IN
						(
						SELECT 
							C.CONSUMER_ID 
						FROM 
							#dsn_alias#.CONSUMER C,
							#dsn_alias#.CONSUMER_CAT CAT 
						WHERE 
							C.CONSUMER_CAT_ID = CAT.CONSCAT_ID AND
							(
								<cfloop list="#bireysel#" delimiters="," index="cat_i">
									(CAT.CONSCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(cat_i,'-')#">)
									<cfif cat_i neq listlast(bireysel,',') and listlen(bireysel,',') gte 1> OR</cfif>
								</cfloop>  
							)
						)
					<cfif isdefined("kurumsal") and listlen(kurumsal)>)</cfif>	
				</cfif>
				<cfif len(attributes.payment_type) and len(attributes.payment_type_id)>
					AND I.PAY_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.payment_type_id#">
				<cfelseif len(attributes.payment_type) and len(attributes.card_paymethod_id)>
					AND I.CARD_PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.card_paymethod_id#">
				</cfif>
				<cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_id) and len(ship_method_name)>
					AND I.SHIP_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_method_id#">
				</cfif>
				<cfif len(attributes.department_id)>
				AND(
					<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
						(I.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND I.DEPARTMENT_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
						<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
					</cfloop>  
					)
				<cfelseif len(branch_dep_list)>
					AND I.DEPARTMENT_ID IN (#branch_dep_list#)
				</cfif>	
                <cfif len(trim(attributes.STOCK_CODE)) and len(attributes.STOCK_CODE)>AND S.STOCK_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.stock_code#"></cfif><!---AND S.STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.stock_code#%">--->
			GROUP BY	
				<cfif attributes.is_other_money eq 1>
					I.OTHER_MONEY,
				</cfif>
				<cfif attributes.report_type eq 4>
					C.NICKNAME,
					C.COMPANY_ID,
					C.TAXOFFICE,
					C.TAXNO
				<cfelseif attributes.report_type eq 5>
					I.INVOICE_NUMBER,
					I.SERIAL_NUMBER,
					I.SERIAL_NO,
					I.DEPARTMENT_ID,
					I.DEPARTMENT_LOCATION,
					I.PROJECT_ID,
					C.NICKNAME,
					C.COMPANY_ID,
					C.OZEL_KOD_2,
					I.INVOICE_DATE,
					PC.PRODUCT_CAT,
					PC.HIERARCHY,
					PC.PRODUCT_CATID,
					S.PRODUCT_ID,
					P.PRODUCT_NAME,
					P.PRODUCT_CODE,
					P.PRODUCT_CODE_2,
					P.MANUFACT_CODE,
					IR.UNIT,
                    IR.UNIT2,
					I.OTHER_MONEY,
					IR.INVOICE_ROW_ID,
					IR.DUE_DATE,
					IR.ROW_PROJECT_ID,
					I.DUE_DATE,
					CAST(I.NOTE AS NVARCHAR),
					IR.SPECT_VAR_NAME,
					IR.SPECT_VAR_ID,
					I.PURCHASE_SALES,
					I.INVOICE_ID,
					IR.LOT_NO,
			        P.BARCOD
                <cfelseif attributes.report_type eq 12>
                    P.IS_PURCHASE,
                    P.IS_INVENTORY,
                    P.IS_PRODUCTION,
                    P.IS_TERAZI,
                    P.IS_SERIAL_NO,
                    P.IS_KARMA,
                    P.IS_INTERNET,
                    P.IS_PROTOTYPE,
                    P.IS_ZERO_STOCK,
                    P.IS_EXTRANET,
                    P.IS_COST,
                    P.IS_SALES,
                    P.IS_QUALITY
				</cfif>
				<cfif attributes.report_type eq 5>
					ORDER BY 
						<cfif attributes.report_sort eq 1>
							PRICE DESC,
						<cfelseif attributes.report_sort eq 2>
							PRODUCT_STOCK DESC,
						</cfif>
						I.INVOICE_DATE DESC
				<cfelseif attributes.kontrol_type eq 1 and attributes.report_type eq 5>
					ORDER BY 
						<cfif attributes.report_sort eq 1>
							PRICE DESC,
						<cfelseif attributes.report_sort eq 2>
							PRODUCT_STOCK DESC,
						</cfif>
						INVOICE_NUMBER
				</cfif>
		</cfquery>
		<cfquery name="get_total_purchase__" datasource="#DSN2#"><!--- CONSUMER --->
			SELECT
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					<cfif attributes.kdv_dahil eq 1>
						SUM((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) AS ISKONTO,
						SUM(((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) / INVM.RATE2) ISKONTO_DOVIZ,
						SUM( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL *(IR.TAX+100)/100 ) AS PRICE,
						SUM( ( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL *(IR.TAX+100)/100) / INVM.RATE2 ) AS PRICE_DOVIZ
					<cfelse>
						SUM((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) AS ISKONTO,
						SUM(((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) / INVM.RATE2) ISKONTO_DOVIZ,
						SUM( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL ) AS PRICE,
						SUM( ( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL) / INVM.RATE2 ) AS PRICE_DOVIZ
					</cfif>
				<cfelse>
					<cfif attributes.kdv_dahil eq 1>
						SUM((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) AS ISKONTO,
						SUM( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL *(IR.TAX+100)/100 ) AS PRICE
					<cfelse>
						SUM((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) AS ISKONTO,
						SUM( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL ) AS PRICE
					</cfif>
				</cfif>
				<cfif attributes.is_other_money eq 1>
					,I.OTHER_MONEY
				</cfif>
				<cfif attributes.report_type eq 4>
					,C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME NICKNAME
					,C.CONSUMER_ID COMPANY_ID
					,C.TAX_OFFICE TAXOFFICE
					,C.TAX_NO TAXNO
					,SUM(IR.AMOUNT) AS PRODUCT_STOCK
				<cfelseif attributes.report_type eq 5>
					,I.INVOICE_NUMBER
					,I.SERIAL_NUMBER
					,I.SERIAL_NO
					,I.DEPARTMENT_ID
					,I.DEPARTMENT_LOCATION
					,I.PROJECT_ID
					,C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME AS MUSTERI
					,C.CONSUMER_ID COMPANY_ID
					,'' AS OZEL_KOD_2
					,I.INVOICE_DATE
					,PC.PRODUCT_CAT
					,PC.HIERARCHY
					,PC.PRODUCT_CATID
					,S.PRODUCT_ID
					,P.PRODUCT_NAME
					,P.PRODUCT_CODE
					,P.PRODUCT_CODE_2
					,P.MANUFACT_CODE
					,SUM(IR.AMOUNT) AS PRODUCT_STOCK
                    ,SUM(IR.AMOUNT2) AS PRODUCT_STOCK2
                    ,SUM(IR.NETTOTAL) AS NET_TOTAL
					,SUM(IR.EXTRA_COST) AS COST_PRICE
					,IR.UNIT AS BIRIM
                    ,IR.UNIT2 AS BIRIM2
					,SUM(IR.PRICE) AS BIRIM_FIYAT
					,SUM(IR.OTHER_MONEY_VALUE) AS OTHER_MONEY_VALUE
					,I.OTHER_MONEY AS OTHER_MONEY
					,IR.INVOICE_ROW_ID
					,IR.DUE_DATE
					,IR.ROW_PROJECT_ID
					,I.DUE_DATE AS INV_DUE_DATE
					,CAST(I.NOTE AS NVARCHAR) NOTE
					,IR.SPECT_VAR_NAME
					,(SELECT TOP 1 SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS WHERE SPECTS.SPECT_VAR_ID = IR.SPECT_VAR_ID) AS SPECT_MAIN_ID
					,I.PURCHASE_SALES
					,I.INVOICE_ID
					,IR.LOT_NO
			        ,P.BARCOD
                <cfelseif attributes.report_type eq 12>
                	,SUM(IR.AMOUNT) AS PRODUCT_STOCK
                	,CASE
                	WHEN P.IS_PURCHASE = 1 THEN 1 
                    WHEN P.IS_INVENTORY = 0 THEN 2 
                    WHEN (P.IS_INVENTORY = 1 AND P.IS_PRODUCTION = 0) THEN 3
                    WHEN P.IS_TERAZI = 1 THEN 4
                    WHEN P.IS_PURCHASE = 0 THEN 5
                    WHEN P.IS_PRODUCTION = 1 THEN 6 
                    WHEN P.IS_SERIAL_NO = 1 THEN 7
                    WHEN P.IS_KARMA = 1 THEN 8 
                    WHEN P.IS_INTERNET = 1 THEN 9
                    WHEN P.IS_PROTOTYPE = 1 THEN 10
                    WHEN P.IS_ZERO_STOCK = 1 THEN 11
                    WHEN P.IS_EXTRANET = 1 THEN 12
                    WHEN P.IS_COST = 1 THEN 13
                    WHEN P.IS_SALES = 1 THEN 14
                    WHEN P.IS_QUALITY = 1 THEN 15
                    WHEN P.IS_INVENTORY = 1 THEN 16 
                    END AS PRODUCT_TYPE
				</cfif>
				,2 TYPE <!--- bireysel üye --->
			FROM
				INVOICE I
				<cfif len(attributes.use_efatura)>
					LEFT JOIN EINVOICE_RECEIVING_DETAIL ERD ON ERD.INVOICE_ID = I.INVOICE_ID
				</cfif>,
				INVOICE_ROW IR,		
				#dsn3_alias#.STOCKS S,
				#dsn3_alias#.PRODUCT_CAT PC,
				#dsn3_alias#.PRODUCT P
				<cfif attributes.report_type eq 4 or attributes.report_type eq 5>,#dsn_alias#.CONSUMER C</cfif>
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					,INVOICE_MONEY INVM
				</cfif>
			WHERE
				<cfif len(attributes.use_efatura) and attributes.use_efatura eq 1>
					ERD.INVOICE_ID IS NOT NULL AND
				<cfelseif len(attributes.use_efatura) and attributes.use_efatura eq 0>
					ERD.INVOICE_ID IS NULL AND
				</cfif>
					I.IS_IPTAL = 0 AND
				<cfif not isdefined("attributes.is_zero_value")>
					I.GROSSTOTAL > 0 AND
					I.NETTOTAL > 0 AND
				</cfif>
					S.PRODUCT_ID = P.PRODUCT_ID AND
					IR.STOCK_ID = S.STOCK_ID AND
					I.INVOICE_ID = IR.INVOICE_ID AND
					I.INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"> AND
					S.PRODUCT_ID = IR.PRODUCT_ID AND
					I.INVOICE_CAT NOT IN (62) AND
                 <cfif isdefined('attributes.product_types') and (attributes.product_types eq 1)>
                    P.IS_PURCHASE = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 2)>
                    P.IS_INVENTORY = 0 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 3)>
                    P.IS_INVENTORY = 1 AND P.IS_PRODUCTION = 0 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 4)>
                    P.IS_TERAZI = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 5)>
                    P.IS_PURCHASE = 0 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 6)>
                    P.IS_PRODUCTION = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 7)>
                    P.IS_SERIAL_NO = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 8)>
                    P.IS_KARMA = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 9)>
                    P.IS_INTERNET = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 10)>
                    P.IS_PROTOTYPE = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 11)>
                    P.IS_ZERO_STOCK = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 12)>
                    P.IS_EXTRANET = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 13)>
                    P.IS_COST = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 14)>
                    P.IS_SALES = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 15)>
                    P.IS_QUALITY = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 16)>
                    P.IS_INVENTORY = 1 AND
                </cfif>
				PC.PRODUCT_CATID = P.PRODUCT_CATID 
				<cfif attributes.report_type eq 4>
					AND I.CONSUMER_ID = C.CONSUMER_ID
				<cfelseif attributes.report_type eq 5>
					AND	I.CONSUMER_ID = C.CONSUMER_ID 
					AND PC.PRODUCT_CATID = P.PRODUCT_CATID
				</cfif>
				<cfif len(attributes.process_type)>
					AND I.PROCESS_CAT IN (#attributes.process_type#)
				<cfelseif len(process_type_list)>
					AND I.PROCESS_CAT IN (#process_type_list#)	
				</cfif>
				<cfif len(attributes.project_id) and len(attributes.project_head)>
				 	AND I.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
				</cfif>
				<cfif attributes.is_other_money eq 1>
					AND INVM.ACTION_ID = I.INVOICE_ID 
					AND INVM.MONEY_TYPE = I.OTHER_MONEY
				<cfelseif attributes.is_money2 eq 1>
					AND INVM.ACTION_ID = I.INVOICE_ID
					AND INVM.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
				</cfif>
				<cfif len(trim(attributes.employee)) and len(attributes.sale_employee_id)>AND I.SALE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sale_employee_id#"></cfif>
				<cfif len(attributes.company) and len(attributes.company_id) and attributes.company_id neq 0>AND I.COMPANY_ID=	<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"></cfif>
				<cfif len(attributes.company) and len(attributes.consumer_id) and attributes.consumer_id neq 0>AND I.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"></cfif>
				<cfif len(attributes.company) and len(attributes.employee_id) and attributes.employee_id neq 0>AND I.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"></cfif>
				<cfif len(trim(attributes.product_cat)) and len(attributes.search_product_catid)>AND PC.HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.search_product_catid#%"></cfif>
				<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>AND	P.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"></cfif>		
				<cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>AND P.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_employee_id#"></cfif>
				<cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>AND P.BRAND_ID IN (#attributes.brand_id#)</cfif>
				<cfif len(trim(attributes.model_name)) and len(attributes.model_id)>AND P.SHORT_CODE_ID IN (#attributes.model_id#)</cfif>
				<cfif isdefined("kurumsal") and listlen(kurumsal)>
					AND <cfif isdefined("bireysel") and listlen(bireysel)>(</cfif>I.COMPANY_ID IN
						(
						SELECT 
							C.COMPANY_ID				
						FROM 
							#dsn_alias#.COMPANY C,
							#dsn_alias#.COMPANY_CAT CAT 
						WHERE 
							C.COMPANYCAT_ID = CAT.COMPANYCAT_ID AND
							(
								<cfloop list="#kurumsal#" delimiters="," index="cat_i">
									(CAT.COMPANYCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(cat_i,'-')#">)
									<cfif cat_i neq listlast(kurumsal,',') and listlen(kurumsal,',') gte 1> OR</cfif>
								</cfloop>  
							)
						)
				</cfif>
				<cfif isdefined("bireysel") and listlen(bireysel)>
					<cfif isdefined("kurumsal") and listlen(kurumsal)>OR<cfelse>AND</cfif> I.CONSUMER_ID IN
						(
						SELECT 
							C.CONSUMER_ID
						FROM 
							#dsn_alias#.CONSUMER C,
							#dsn_alias#.CONSUMER_CAT CAT 
						WHERE 
							C.CONSUMER_CAT_ID = CAT.CONSCAT_ID AND
							(
								<cfloop list="#bireysel#" delimiters="," index="cat_i">
									(CAT.CONSCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(cat_i,'-')#">)
									<cfif cat_i neq listlast(bireysel,',') and listlen(bireysel,',') gte 1> OR</cfif>
								</cfloop>  
							)
						)
					<cfif isdefined("kurumsal") and listlen(kurumsal)>)</cfif>	
				</cfif>
				<cfif len(attributes.payment_type) and len(attributes.payment_type_id)>
					AND I.PAY_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.payment_type_id#">
				<cfelseif len(attributes.payment_type) and len(attributes.card_paymethod_id)>
					AND I.CARD_PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.card_paymethod_id#">
				</cfif>
				<cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_id) and len(ship_method_name)>
					AND I.SHIP_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_method_id#">
				</cfif>
				<cfif len(attributes.department_id)>
				AND(
					<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
						(I.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND I.DEPARTMENT_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
						<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
					</cfloop>  
					)
				<cfelseif len(branch_dep_list)>
					AND I.DEPARTMENT_ID IN (#branch_dep_list#)
				</cfif>	
			GROUP BY	
				<cfif attributes.is_other_money eq 1>
					I.OTHER_MONEY,
				</cfif>
				<cfif attributes.report_type eq 4>
					C.CONSUMER_NAME,
					C.CONSUMER_SURNAME,
					C.CONSUMER_ID,
					C.TAX_OFFICE,
					C.TAX_NO
				<cfelseif attributes.report_type eq 5>
					I.INVOICE_NUMBER,
					I.SERIAL_NUMBER,
					I.SERIAL_NO,
					I.DEPARTMENT_ID,
					I.DEPARTMENT_LOCATION,
					I.PROJECT_ID,
					C.CONSUMER_NAME,
					C.CONSUMER_SURNAME,
					C.CONSUMER_ID,
					I.INVOICE_DATE,
					PC.PRODUCT_CAT,
					PC.HIERARCHY,
					PC.PRODUCT_CATID,
					S.PRODUCT_ID,
					P.PRODUCT_NAME,
					P.PRODUCT_CODE,
					P.PRODUCT_CODE_2,
					P.MANUFACT_CODE,
					IR.UNIT,
                    IR.UNIT2,
					I.OTHER_MONEY,
					IR.INVOICE_ROW_ID,
					IR.DUE_DATE,
					IR.ROW_PROJECT_ID,
					I.DUE_DATE,
					CAST(I.NOTE AS NVARCHAR),
					IR.SPECT_VAR_NAME,
					IR.SPECT_VAR_ID,
					I.PURCHASE_SALES,
					I.INVOICE_ID,
					IR.LOT_NO,
			        P.BARCOD
                <cfelseif attributes.report_type eq 12>
                    P.IS_PURCHASE,
                    P.IS_INVENTORY,
                    P.IS_PRODUCTION,
                    P.IS_TERAZI,
                    P.IS_SERIAL_NO,
                    P.IS_KARMA,
                    P.IS_INTERNET,
                    P.IS_PROTOTYPE,
                    P.IS_ZERO_STOCK,
                    P.IS_EXTRANET,
                    P.IS_COST,
                    P.IS_SALES,
                    P.IS_QUALITY
				</cfif>
				<cfif attributes.report_type eq 5>
					ORDER BY 
						<cfif attributes.report_sort eq 1>
							PRICE DESC,
						<cfelseif attributes.report_sort eq 2>
							PRODUCT_STOCK DESC,
						</cfif>
						I.INVOICE_DATE DESC
				<cfelseif attributes.kontrol_type eq 1 and attributes.report_type eq 5>
					ORDER BY
						<cfif attributes.report_sort eq 1>
							PRICE DESC,
						<cfelseif attributes.report_sort eq 2>
							PRODUCT_STOCK DESC,
						</cfif>
						INVOICE_NUMBER
				</cfif>
		</cfquery>
		<cfquery name="get_total_purchase" dbtype="query">
			SELECT * FROM get_total_purchase
			UNION ALL
			SELECT * FROM get_total_purchase__
			ORDER BY
				<cfif attributes.report_sort eq 1>
					PRICE DESC
				<cfelseif attributes.report_sort eq 2>
					PRODUCT_STOCK2,PRODUCT_STOCK DESC
				</cfif>
		</cfquery>
	</cfif>
	<cfif isdefined("attributes.is_return") and attributes.is_return eq 1>
		<cfif attributes.report_type neq 4 and attributes.report_type neq 5>
			<cfif attributes.report_type eq 12>
            	<cfquery name="check_table" datasource="#DSN2#">
                IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'get_total_purchase_2')
                DROP TABLE get_total_purchase_2
        	</cfquery>
            </cfif>
            <cfquery name="get_total_purchase_2"  datasource="#DSN2#">
				SELECT
					<cfif attributes.report_type neq 12>
						<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                        	<cfif attributes.is_other_money eq 1>
								I.OTHER_MONEY,
							</cfif>
                            <cfif attributes.kdv_dahil eq 1>
                                -1*SUM((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) AS ISKONTO,
                                -1*SUM(((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) / INVM.RATE2) ISKONTO_DOVIZ,
                                -1*SUM( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL *(IR.TAX+100)/100 ) AS PRICE,
                                -1*SUM( ( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL *(IR.TAX+100)/100) / INVM.RATE2 ) AS PRICE_DOVIZ
                            <cfelse>
                                -1*SUM((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) AS ISKONTO,
                                -1*SUM(((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) / INVM.RATE2) ISKONTO_DOVIZ,
                                -1*SUM( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL ) AS PRICE,
                                -1*SUM( ( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL) / INVM.RATE2 ) AS PRICE_DOVIZ
                            </cfif>
                        <cfelse>
                            <cfif attributes.kdv_dahil eq 1>
                                -1*SUM((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) AS ISKONTO,
                                -1*SUM( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL *(IR.TAX+100)/100 ) AS PRICE
                            <cfelse>
                                -1*SUM((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) AS ISKONTO,
                                -1*SUM( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL ) AS PRICE
                            </cfif>
                        </cfif>
                    <cfelse>
                    	<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                        	<cfif attributes.is_other_money eq 1>
								I.OTHER_MONEY,
							</cfif>
                            <cfif attributes.kdv_dahil eq 1>
                                -1*(IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL) AS ISKONTO,
                                -1*((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) / INVM.RATE2 ISKONTO_DOVIZ,
                                -1*(1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL *(IR.TAX+100)/100  AS PRICE,
                                -1*( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL *(IR.TAX+100)/100) / INVM.RATE2  AS PRICE_DOVIZ
                            <cfelse>
                                -1*(IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL) AS ISKONTO,
                                -1*((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) / INVM.RATE2 ISKONTO_DOVIZ,
                                -1*(1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL  AS PRICE,
                                -1* ( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL) / INVM.RATE2  AS PRICE_DOVIZ
                            </cfif>
                        <cfelse>
                            <cfif attributes.kdv_dahil eq 1>
                                -1*(IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL) AS ISKONTO,
                                -1*(1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL *(IR.TAX+100)/100  AS PRICE
                            <cfelse>
                                -1*(IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL) AS ISKONTO,
                                -1*(1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL  AS PRICE
                            </cfif>
                        </cfif>	
					</cfif>
					<cfif attributes.report_type eq 1 or attributes.report_type eq 11>
						,PC.PRODUCT_CAT
						,PC.HIERARCHY
						,PC.PRODUCT_CATID
						,-1*SUM(IR.AMOUNT) AS PRODUCT_STOCK
						,-1*SUM(IR.AMOUNT2) AS PRODUCT_STOCK2
						,IR.UNIT AS BIRIM
						,IR.UNIT2 AS BIRIM2
					<cfelseif attributes.report_type eq 2>
						,PC.PRODUCT_CAT
						,PC.HIERARCHY
						,PC.PRODUCT_CATID
						,P.PRODUCT_ID
						,P.PRODUCT_NAME
						,P.BARCOD
						,-1*SUM(IR.AMOUNT) AS PRODUCT_STOCK
						,-1*SUM(IR.EXTRA_COST*IR.AMOUNT) AS COST_PRICE
						,IR.UNIT AS BIRIM
					<cfelseif attributes.report_type eq 3>
						,PC.PRODUCT_CAT
						,PC.HIERARCHY
						,PC.PRODUCT_CATID
						,P.PRODUCT_ID
						,P.PRODUCT_NAME
						,S.STOCK_CODE
						,S.BARCOD
						,S.PROPERTY
						,IR.STOCK_ID
						,-1*SUM(IR.AMOUNT) AS PRODUCT_STOCK
						,-1*SUM(IR.EXTRA_COST*IR.AMOUNT) AS COST_PRICE
						,IR.UNIT AS BIRIM
					<cfelseif attributes.report_type eq 6>
						,PB.BRAND_NAME
						,P.BRAND_ID
						,-1*SUM(IR.AMOUNT) AS PRODUCT_STOCK
					<cfelseif attributes.report_type eq 7>
						,PR.PROJECT_ID
						,PR.PROJECT_HEAD
						,-1*SUM(IR.AMOUNT) AS PRODUCT_STOCK
					<cfelseif attributes.report_type eq 8>
						,I.PAY_METHOD
						,I.CARD_PAYMETHOD_ID
						,-1*SUM(IR.AMOUNT) AS PRODUCT_STOCK
					<cfelseif attributes.report_type eq 9>
						,EP.POSITION_CODE AS POSITION_CODE
						,-1*SUM(IR.AMOUNT) AS PRODUCT_STOCK
					<cfelseif attributes.report_type eq 10>
						,B.BRANCH_NAME
						,B.BRANCH_ID
						,-1*SUM(IR.AMOUNT) AS PRODUCT_STOCK,
						,-1*SUM(IR.AMOUNT2) AS PRODUCT_STOCK2	
						,IR.UNIT AS BIRIM	
						,IR.UNIT2 AS BIRIM2		
                   	<cfelseif attributes.report_type eq 12>
						,-1*IR.AMOUNT AS PRODUCT_STOCK
						<cfif isdefined('attributes.product_types') and not len(attributes.product_types)>
                            ,CASE
                                WHEN P.IS_PURCHASE = 1 THEN 1  END AS t_1   
                             ,CASE   
                                WHEN P.IS_INVENTORY = 0 THEN 2  END AS t_2
                            ,CASE    
                                WHEN (P.IS_INVENTORY = 1 AND P.IS_PRODUCTION = 0) THEN 3 END AS t_3
                            ,CASE    
                                WHEN P.IS_TERAZI = 1 THEN 4  END AS t_4
                            ,CASE    
                                WHEN P.IS_PURCHASE = 0 THEN 5 END AS t_5
                            ,CASE    
                                WHEN P.IS_PRODUCTION = 1 THEN 6 END AS t_6
                            ,CASE    
                                WHEN P.IS_SERIAL_NO = 1 THEN 7 END AS t_7
                            ,CASE    
                                WHEN P.IS_KARMA = 1 THEN 8 END AS t_8
                            ,CASE    
                                WHEN P.IS_INTERNET = 1 THEN 9  END AS t_9
                            ,CASE    
                                WHEN P.IS_PROTOTYPE = 1 THEN 10  END AS t_10
                            ,CASE    
                                WHEN P.IS_ZERO_STOCK = 1 THEN 11 END AS t_11
                            ,CASE    
                                WHEN P.IS_EXTRANET = 1 THEN 12 END AS t_12
                            ,CASE    
                                WHEN P.IS_COST = 1 THEN 13 END AS t_13
                            ,CASE    
                                WHEN P.IS_SALES = 1 THEN 14 END AS t_14
                            ,CASE    
                                WHEN P.IS_QUALITY = 1 THEN 15 END AS t_15
                            ,CASE    
                                WHEN P.IS_INVENTORY = 1 THEN 16 END AS t_16
                    	<cfelse>
							<cfif isdefined('attributes.product_types') and (attributes.product_types eq 1)>
                            ,CASE
                                WHEN P.IS_PURCHASE = 1 THEN 1  END AS t_1   
                             </cfif>
                             <cfif isdefined('attributes.product_types') and (attributes.product_types eq 2)>
                             ,CASE   
                                WHEN P.IS_INVENTORY = 0 THEN 2  END AS t_2
                             </cfif>
                            <cfif isdefined('attributes.product_types') and (attributes.product_types eq 3)>
                            ,CASE    
                                WHEN (P.IS_INVENTORY = 1 AND P.IS_PRODUCTION = 0) THEN 3 END AS t_3
                            </cfif>
                            <cfif isdefined('attributes.product_types') and (attributes.product_types eq 4)>
                            ,CASE    
                                WHEN P.IS_TERAZI = 1 THEN 4  END AS t_4
                            </cfif>
                            <cfif isdefined('attributes.product_types') and (attributes.product_types eq 5)>
                            ,CASE    
                                WHEN P.IS_PURCHASE = 0 THEN 5 END AS t_5
                            </cfif>
                            <cfif isdefined('attributes.product_types') and (attributes.product_types eq 6)>
                            ,CASE    
                                WHEN P.IS_PRODUCTION = 1 THEN 6 END AS t_6
                            </cfif>
                            <cfif isdefined('attributes.product_types') and (attributes.product_types eq 7)>
                            ,CASE    
                                WHEN P.IS_SERIAL_NO = 1 THEN 7 END AS t_7
                            </cfif>
                            <cfif isdefined('attributes.product_types') and (attributes.product_types eq 8)>
                            ,CASE    
                                WHEN P.IS_KARMA = 1 THEN 8 END AS t_8
                            </cfif>
                            <cfif isdefined('attributes.product_types') and (attributes.product_types eq 9)>
                            ,CASE    
                                WHEN P.IS_INTERNET = 1 THEN 9  END AS t_9
                            </cfif>
                            <cfif isdefined('attributes.product_types') and (attributes.product_types eq 10)>
                            ,CASE    
                                WHEN P.IS_PROTOTYPE = 1 THEN 10  END AS t_10
                            </cfif>
                            <cfif isdefined('attributes.product_types') and (attributes.product_types eq 11)>
                            ,CASE    
                                WHEN P.IS_ZERO_STOCK = 1 THEN 11 END AS t_11
                            </cfif>
                            <cfif isdefined('attributes.product_types') and (attributes.product_types eq 12)>
                            ,CASE    
                                WHEN P.IS_EXTRANET = 1 THEN 12 END AS t_12
                            </cfif>
                            <cfif isdefined('attributes.product_types') and (attributes.product_types eq 13)>
                            ,CASE    
                                WHEN P.IS_COST = 1 THEN 13 END AS t_13
                            </cfif>
                            <cfif isdefined('attributes.product_types') and (attributes.product_types eq 14)>
                            ,CASE    
                                WHEN P.IS_SALES = 1 THEN 14 END AS t_14
                            </cfif>
                            <cfif isdefined('attributes.product_types') and (attributes.product_types eq 15)>
                            ,CASE    
                                WHEN P.IS_QUALITY = 1 THEN 15 END AS t_15
                            </cfif>
                            <cfif isdefined('attributes.product_types') and (attributes.product_types eq 16)>
                            ,CASE    
                                WHEN P.IS_INVENTORY = 1 THEN 16 END AS t_16
                            </cfif>
						</cfif>
					</cfif>
					,0 TYPE
				<cfif attributes.report_type eq 12>
                	INTO #DSN2#.get_total_purchase_2
				</cfif>
                FROM
					INVOICE I
					<cfif len(attributes.use_efatura)>
						LEFT JOIN EINVOICE_RECEIVING_DETAIL ERD ON ERD.INVOICE_ID = I.INVOICE_ID
					</cfif>,
					INVOICE_ROW IR,
					#dsn3_alias#.STOCKS S,
					#dsn3_alias#.PRODUCT_CAT PC,
					#dsn3_alias#.PRODUCT P
					<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
						,INVOICE_MONEY INVM
					</cfif>
					<cfif attributes.report_type eq 6>
						,#dsn3_alias#.PRODUCT_BRANDS PB
					<cfelseif attributes.report_type eq 7>
						,#dsn_alias#.PRO_PROJECTS PR
					<cfelseif attributes.report_type eq 9>
						,#dsn_alias#.EMPLOYEE_POSITIONS EP
					<!---<cfelseif attributes.report_type eq 11>
						,#dsn3_alias#.PRODUCT_CAT PC_2 --->
					<cfelseif attributes.report_type eq 10>
						,#dsn_alias#.DEPARTMENT D
						,#dsn_alias#.BRANCH B				
					</cfif>
				WHERE
					<cfif len(attributes.use_efatura) and attributes.use_efatura eq 1>
						ERD.INVOICE_ID IS NOT NULL AND
					<cfelseif len(attributes.use_efatura) and attributes.use_efatura eq 0>
						ERD.INVOICE_ID IS NULL AND
					</cfif>
					I.IS_IPTAL = 0 AND
					I.PURCHASE_SALES = 1 AND
					S.PRODUCT_ID = P.PRODUCT_ID AND
					S.PRODUCT_ID = IR.PRODUCT_ID AND
					IR.STOCK_ID = S.STOCK_ID AND
					I.INVOICE_ID = IR.INVOICE_ID AND
                     <cfif isdefined('attributes.product_types') and (attributes.product_types eq 1)>
                        P.IS_PURCHASE = 1 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 2)>
                        P.IS_INVENTORY = 0 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 3)>
                        P.IS_INVENTORY = 1 AND P.IS_PRODUCTION = 0 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 4)>
                        P.IS_TERAZI = 1 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 5)>
                        P.IS_PURCHASE = 0 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 6)>
                        P.IS_PRODUCTION = 1 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 7)>
                        P.IS_SERIAL_NO = 1 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 8)>
                        P.IS_KARMA = 1 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 9)>
                        P.IS_INTERNET = 1 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 10)>
                        P.IS_PROTOTYPE = 1 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 11)>
                        P.IS_ZERO_STOCK = 1 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 12)>
                        P.IS_EXTRANET = 1 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 13)>
                        P.IS_COST = 1 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 14)>
                        P.IS_SALES = 1 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 15)>
                        P.IS_QUALITY = 1 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 16)>
                        P.IS_INVENTORY = 1 AND
                    </cfif>
					<cfif not isdefined("attributes.is_zero_value")>
						I.GROSSTOTAL > 0 AND
						I.NETTOTAL > 0 AND
					</cfif>
					I.INVOICE_DATE BETWEEN #attributes.date1# AND #attributes.date2#  AND
					I.INVOICE_CAT IN (62) AND<!--- 20060504 iade tipleri : alim aide ve verilen fiyat farki fats --->
					<cfif attributes.report_type eq 11>
					<!---	PC_2.PRODUCT_CATID = P.PRODUCT_CATID AND --->
						CHARINDEX('.',PC.HIERARCHY) = 0 
					<!---	PC.HIERARCHY = LEFT(PC_2.HIERARCHY,(CHARINDEX('.',PC_2.HIERARCHY)-1))--->	
					<cfelse>
						PC.PRODUCT_CATID = P.PRODUCT_CATID 
					</cfif>
					<cfif attributes.report_type eq 6>
						AND P.BRAND_ID = PB.BRAND_ID 
					<cfelseif attributes.report_type eq 7>
						AND I.PROJECT_ID = PR.PROJECT_ID
					<cfelseif attributes.report_type eq 9>
						AND P.PRODUCT_MANAGER = EP.POSITION_CODE 
					<cfelseif attributes.report_type eq 10>
						AND I.DEPARTMENT_ID = D.DEPARTMENT_ID 
						AND D.BRANCH_ID = B.BRANCH_ID				
					</cfif>
					<cfif attributes.is_other_money eq 1>
						AND INVM.ACTION_ID = I.INVOICE_ID 
						AND INVM.MONEY_TYPE = I.OTHER_MONEY
					<cfelseif attributes.is_money2 eq 1>
						AND INVM.ACTION_ID = I.INVOICE_ID
						AND INVM.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
					</cfif>
					<cfif len(attributes.project_id) and len(attributes.project_head)>
						AND I.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
					</cfif>
					<cfif len(trim(attributes.employee)) and len(attributes.sale_employee_id)>AND I.SALE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sale_employee_id#"></cfif>		
					<cfif len(attributes.company) and len(attributes.company_id) and attributes.company_id neq 0>AND I.COMPANY_ID =	<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"></cfif>
					<cfif len(attributes.company) and len(attributes.consumer_id) and attributes.consumer_id neq 0>AND I.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"></cfif>
					<cfif len(attributes.company) and len(attributes.employee_id) and attributes.employee_id neq 0>AND I.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"></cfif>
					<cfif len(trim(attributes.product_cat)) and len(attributes.search_product_catid)>AND PC.HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.search_product_catid#%"></cfif>
					<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>AND P.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"></cfif>
					<cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>AND P.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_employee_id#"></cfif>
					<cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>AND P.BRAND_ID IN (#attributes.brand_id#) </cfif>
					<cfif len(trim(attributes.model_name)) and len(attributes.model_id)>AND P.SHORT_CODE_ID IN (#attributes.model_id#) </cfif>
					<cfif len(attributes.payment_type) and len(attributes.payment_type_id)>
						AND I.PAY_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.payment_type_id#">
					<cfelseif len(attributes.payment_type) and len(attributes.card_paymethod_id)>
						AND I.CARD_PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.card_paymethod_id#">
					</cfif>
					<cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_id) and len(ship_method_name)>
						AND I.SHIP_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_method_id#">
					</cfif>
					<cfif len(attributes.department_id)>
						AND
						(
						<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
							(I.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND I.DEPARTMENT_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
						<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
						</cfloop>  
						) 
					<cfelseif len(branch_dep_list)>
						AND I.DEPARTMENT_ID IN (#branch_dep_list#)
					</cfif>
				<cfif attributes.report_type neq 12>
                GROUP BY
					<cfif attributes.is_other_money eq 1>
						I.OTHER_MONEY,
					</cfif>
					<cfif attributes.report_type eq 1 or attributes.report_type eq 11>
						PC.PRODUCT_CAT,
						PC.PRODUCT_CATID,
						PC.HIERARCHY,
						IR.UNIT,
						IR.UNIT2
					<cfelseif attributes.report_type eq 2>
						PC.PRODUCT_CAT,
						PC.PRODUCT_CATID,
						PC.HIERARCHY,
						P.PRODUCT_ID,
						P.PRODUCT_NAME,
						P.BARCOD,
						IR.PRODUCT_ID,
						IR.UNIT,
						IR.PRICE
					<cfelseif attributes.report_type eq 3>
						PC.PRODUCT_CAT,
						PC.PRODUCT_CATID,
						PC.HIERARCHY,
						P.PRODUCT_NAME,
						P.PRODUCT_ID,
						S.PROPERTY,
						S.STOCK_CODE,
						S.BARCOD,
						IR.STOCK_ID,
						IR.UNIT,
						IR.PRICE
                    <cfelseif attributes.report_type eq 12>
						P.IS_PURCHASE,
						P.IS_INVENTORY,
						P.IS_PRODUCTION,
						P.IS_TERAZI,
						P.IS_SERIAL_NO,
						P.IS_KARMA,
						P.IS_INTERNET,
						P.IS_PROTOTYPE,
						P.IS_ZERO_STOCK,
						P.IS_EXTRANET,
						P.IS_COST,
						P.IS_SALES,
						P.IS_QUALITY
					<cfelseif attributes.report_type eq 6>
						PB.BRAND_NAME,
						P.BRAND_ID
					<cfelseif attributes.report_type eq 7>
						PR.PROJECT_ID,
						PR.PROJECT_HEAD
					<cfelseif attributes.report_type eq 8>
						I.PAY_METHOD,
						I.CARD_PAYMETHOD_ID
					<cfelseif attributes.report_type eq 9>
						EP.POSITION_CODE
					<cfelseif attributes.report_type eq 10>
						B.BRANCH_NAME,
						B.BRANCH_ID,
						IR.UNIT,	
						IR.UNIT2 
					</cfif>
            	</cfif>
			</cfquery>
            <cfif attributes.report_type eq 12 >
            	<cfquery name="get_total_purchase_2" datasource="#DSN2#">
                    SELECT 
                        SUM(PRICE) AS PRICE,
                        SUM(ISKONTO) AS ISKONTO
                    <cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
                        ,SUM(PRICE_DOVIZ) AS PRICE_DOVIZ
                        ,SUM(ISKONTO_DOVIZ) AS ISKONTO_DOVIZ
                        <cfif attributes.is_other_money eq 1>
                        ,OTHER_MONEY
						</cfif>
                    </cfif>
                    <cfif attributes.report_type eq 4>
                        ,NICKNAME,COMPANY_ID,TAXOFFICE,TAXNO,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
                    <cfelseif attributes.report_type eq 5>
                        ,INVOICE_ID,INVOICE_NUMBER,DEPARTMENT_ID,PURCHASE_SALES,
                        DEPARTMENT_LOCATION,MUSTERI,COMPANY_ID,OZEL_KOD_2,BIRIM_FIYAT,OTHER_MONEY_VALUE,OTHER_MONEY,INVOICE_DATE,PRODUCT_CAT,HIERARCHY,PRODUCT_CATID,PRODUCT_ID,PRODUCT_NAME,PRODUCT_CODE,MANUFACT_CODE,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,SUM(COST_PRICE) AS COST_PRICE,BIRIM,BIRIM2,INVOICE_ROW_ID,DUE_DATE,INV_DUE_DATE,NOTE,SPECT_VAR_NAME,SPECT_MAIN_ID,ROW_PROJECT_ID,PROJECT_ID,LOT_NO,BARCOD
                    <cfelseif attributes.report_type eq 12>
                        ,PRODUCT_TYPE,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
                    </cfif>	
                        ,TYPE
                    FROM
                    (SELECT *
                     FROM get_total_purchase_2) t
                    UNPIVOT
                    (PRODUCT_TYPE FOR ALAN IN
                        (	<cfif isdefined('attributes.product_types') and not len(attributes.product_types)>
                             t_1,
                             t_2, 
                             t_3, 
                             t_4,
                             t_5,
                             t_6,
                             t_7,
                             t_8,
                             t_9,
                             t_10,
                             t_11,
                             t_12,
                             t_13,
                             t_14,
                             t_15,
                             t_16
                             <cfelse>
                                     <cfif isdefined('attributes.product_types') and (attributes.product_types eq 1)>
                                        t_1
                                     </cfif>
                                     <cfif isdefined('attributes.product_types') and (attributes.product_types eq 2)>
                                        t_2
                                     </cfif>
                                     <cfif isdefined('attributes.product_types') and (attributes.product_types eq 3)> 
                                        t_3
                                     </cfif>
                                     <cfif isdefined('attributes.product_types') and (attributes.product_types eq 4)>
                                        t_4
                                     </cfif>
                                     <cfif isdefined('attributes.product_types') and (attributes.product_types eq 5)>
                                        t_5
                                     </cfif>
                                     <cfif isdefined('attributes.product_types') and (attributes.product_types eq 6)>
                                        t_6
                                     </cfif>
                                     <cfif isdefined('attributes.product_types') and (attributes.product_types eq 7)>
                                        t_7
                                     </cfif>
                                     <cfif isdefined('attributes.product_types') and (attributes.product_types eq 8)>
                                        t_8
                                     </cfif>
                                     <cfif isdefined('attributes.product_types') and (attributes.product_types eq 9)>
                                        t_9
                                     </cfif>
                                     <cfif isdefined('attributes.product_types') and (attributes.product_types eq 10)>
                                        t_10
                                     </cfif>
                                     <cfif isdefined('attributes.product_types') and (attributes.product_types eq 11)>
                                        t_11
                                     </cfif>
                                     <cfif isdefined('attributes.product_types') and (attributes.product_types eq 12)>
                                        t_12
                                     </cfif>
                                     <cfif isdefined('attributes.product_types') and (attributes.product_types eq 13)>
                                        t_13
                                     </cfif>
                                     <cfif isdefined('attributes.product_types') and (attributes.product_types eq 14)>
                                        t_14
                                     </cfif>
                                     <cfif isdefined('attributes.product_types') and (attributes.product_types eq 15)>
                                        t_15
                                     </cfif>
                                     <cfif isdefined('attributes.product_types') and (attributes.product_types eq 16)>
                                        t_16
                                     </cfif>
                             </cfif>
                         )
                    ) AS u
                    GROUP BY 
                        PRODUCT_TYPE
                        ,ALAN
                        ,TYPE
                        <cfif attributes.is_other_money eq 1>
                            ,OTHER_MONEY
                        </cfif>
				</cfquery>
            </cfif>
            <cfquery name="get_total_purchase_3" dbtype="query">
                SELECT * FROM get_total_purchase
                UNION 
                SELECT * FROM get_total_purchase_2 
				ORDER BY 
					<cfif attributes.report_sort eq 1>
						PRICE DESC 
					<cfelseif attributes.report_sort eq 2>
						PRODUCT_STOCK DESC 
					</cfif>
            </cfquery>
			<cfquery name="get_total_purchase" dbtype="query">
				SELECT 
					SUM(PRICE) AS PRICE,
					SUM(ISKONTO) AS ISKONTO
					<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
						,SUM(PRICE_DOVIZ) AS PRICE_DOVIZ
						,SUM(ISKONTO_DOVIZ) AS ISKONTO_DOVIZ
					</cfif>
					<cfif attributes.report_type eq 1 or attributes.report_type eq 11>
						,PRODUCT_CAT,HIERARCHY,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,SUM(PRODUCT_STOCK2) AS PRODUCT_STOCK2,BIRIM,BIRIM2
					<cfelseif attributes.report_type eq 2>
						,PRODUCT_CAT,HIERARCHY,PRODUCT_ID,PRODUCT_NAME,BARCOD,BIRIM,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,SUM(COST_PRICE) AS COST_PRICE
					<cfelseif attributes.report_type eq 3>
						,PRODUCT_CAT,HIERARCHY,PRODUCT_ID,PRODUCT_NAME,STOCK_CODE,BARCOD
						,PROPERTY,STOCK_ID,BIRIM,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,SUM(COST_PRICE) AS COST_PRICE
					<cfelseif attributes.report_type eq 6>
						,BRAND_NAME,BRAND_ID,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
					<cfelseif attributes.report_type eq 7>
						,PROJECT_HEAD,PROJECT_ID,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
					<cfelseif attributes.report_type eq 8>
						,PAY_METHOD,CARD_PAYMETHOD_ID,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
					<cfelseif attributes.report_type eq 9>
						,POSITION_CODE,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
					<cfelseif attributes.report_type eq 10>
						,BRANCH_ID,BRANCH_NAME,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
					<cfelseif attributes.report_type eq 12 >
                    	,PRODUCT_TYPE,
                        SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
					</cfif>	
					,0 TYPE
				FROM 
					get_total_purchase_3
                GROUP BY 
				<cfif attributes.is_other_money eq 1>
					OTHER_MONEY,
				</cfif>
				<cfif attributes.report_type eq 1 or attributes.report_type eq 11>	
					PRODUCT_CAT,
					HIERARCHY,
                    BIRIM,
                    BIRIM2
				<cfelseif attributes.report_type eq 2>
					PRODUCT_CAT,HIERARCHY,PRODUCT_ID,PRODUCT_NAME,BIRIM,BARCOD
				<cfelseif attributes.report_type eq 3>
					PRODUCT_CAT,HIERARCHY,PRODUCT_ID,PRODUCT_NAME,PROPERTY,STOCK_ID,BIRIM,STOCK_CODE,BARCOD
				<cfelseif attributes.report_type eq 6>
					BRAND_NAME,BRAND_ID
				<cfelseif attributes.report_type eq 7>
					PROJECT_HEAD,PROJECT_ID
				<cfelseif attributes.report_type eq 8>
					PAY_METHOD,CARD_PAYMETHOD_ID
				<cfelseif attributes.report_type eq 9>
					POSITION_CODE
				<cfelseif attributes.report_type eq 10>
					BRANCH_ID,
					BRANCH_NAME
				<cfelseif attributes.report_type eq 12 >
                    PRODUCT_TYPE
                    ,TYPE
				</cfif>	
			ORDER BY
				<cfif attributes.report_sort eq 1>
					PRICE DESC 
				<cfelseif attributes.report_sort eq 2>
					PRODUCT_STOCK DESC
				</cfif>
			</cfquery>
		<cfelse>
			<cfquery name="get_total_purchase_2" datasource="#DSN2#"><!--- company --->
				SELECT
					<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
						<cfif attributes.kdv_dahil eq 1>
							-1*SUM((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) AS ISKONTO,
							-1*SUM(((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) / INVM.RATE2) ISKONTO_DOVIZ,
							-1*SUM( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL *(IR.TAX+100)/100 ) AS PRICE,
							-1*SUM( ( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL *(IR.TAX+100)/100) / INVM.RATE2 ) AS PRICE_DOVIZ
						<cfelse>
							-1*SUM((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) AS ISKONTO,
							-1*SUM(((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) / INVM.RATE2) ISKONTO_DOVIZ,
							-1*SUM( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL ) AS PRICE,
							-1*SUM( ( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL) / INVM.RATE2 ) AS PRICE_DOVIZ
						</cfif>
					<cfelse>
						<cfif attributes.kdv_dahil eq 1>
							-1*SUM((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) AS ISKONTO,
							-1*SUM( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL *(IR.TAX+100)/100 ) AS PRICE
						<cfelse>
							-1*SUM((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) AS ISKONTO,
							-1*SUM( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL ) AS PRICE
						</cfif>
					</cfif>
					<cfif attributes.is_other_money eq 1>
						,I.OTHER_MONEY
					</cfif>
					<cfif attributes.report_type eq 4>
						,C.NICKNAME
						,C.COMPANY_ID
						,C.TAXOFFICE
						,C.TAXNO
						,-1*SUM(IR.AMOUNT) AS PRODUCT_STOCK
					<cfelseif attributes.report_type eq 5>
						,I.INVOICE_NUMBER
						,I.SERIAL_NUMBER
						,I.SERIAL_NO
						,I.DEPARTMENT_ID
						,I.DEPARTMENT_LOCATION
						,I.PROJECT_ID
						,C.NICKNAME AS MUSTERI
						,C.COMPANY_ID
						,C.OZEL_KOD_2
						,I.INVOICE_DATE
						,PC.PRODUCT_CAT
						,PC.HIERARCHY
						,PC.PRODUCT_CATID
						,S.PRODUCT_ID
						,P.PRODUCT_NAME
						,P.PRODUCT_CODE
						,P.PRODUCT_CODE_2
						,P.MANUFACT_CODE
						,-1*SUM(IR.AMOUNT) AS PRODUCT_STOCK
						,-1*SUM(IR.EXTRA_COST) AS COST_PRICE 
						,SUM(IR.AMOUNT2) AS PRODUCT_STOCK2
						,SUM(IR.NETTOTAL) AS NET_TOTAL
						,IR.UNIT AS BIRIM
                        ,IR.UNIT2 AS BIRIM2
						,IR.PRICE AS BIRIM_FIYAT
						,IR.OTHER_MONEY_VALUE AS OTHER_MONEY_VALUE
						,I.OTHER_MONEY AS OTHER_MONEY
						,IR.INVOICE_ROW_ID
						,IR.DUE_DATE
						,IR.ROW_PROJECT_ID
						,I.DUE_DATE AS INV_DUE_DATE
						,CAST(I.NOTE AS NVARCHAR) NOTE
						,IR.SPECT_VAR_NAME
						,(SELECT TOP 1 SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS WHERE SPECTS.SPECT_VAR_ID = IR.SPECT_VAR_ID) AS SPECT_MAIN_ID
						,I.PURCHASE_SALES
						,I.INVOICE_ID
						,IR.LOT_NO
			       		,P.BARCOD
                    <cfelseif attributes.report_type eq 12>
						,-1*SUM(IR.AMOUNT) AS PRODUCT_STOCK
                        ,CASE
                        WHEN P.IS_PURCHASE = 1 THEN 1 
                        WHEN P.IS_INVENTORY = 0 THEN 2 
                        WHEN (P.IS_INVENTORY = 1 AND P.IS_PRODUCTION = 0) THEN 3
                        WHEN P.IS_TERAZI = 1 THEN 4
                        WHEN P.IS_PURCHASE = 0 THEN 5
                        WHEN P.IS_PRODUCTION = 1 THEN 6 
                        WHEN P.IS_SERIAL_NO = 1 THEN 7
                        WHEN P.IS_KARMA = 1 THEN 8 
                        WHEN P.IS_INTERNET = 1 THEN 9
                        WHEN P.IS_PROTOTYPE = 1 THEN 10
                        WHEN P.IS_ZERO_STOCK = 1 THEN 11
                        WHEN P.IS_EXTRANET = 1 THEN 12
                        WHEN P.IS_COST = 1 THEN 13
                        WHEN P.IS_SALES = 1 THEN 14
                        WHEN P.IS_QUALITY = 1 THEN 15
                        WHEN P.IS_INVENTORY = 1 THEN 16 
                        END AS PRODUCT_TYPE
					</cfif>
					,1 TYPE <!--- kurumsal üye --->
				FROM
					INVOICE I
					<cfif len(attributes.use_efatura)>
						LEFT JOIN EINVOICE_RECEIVING_DETAIL ERD ON ERD.INVOICE_ID = I.INVOICE_ID
					</cfif>,
					INVOICE_ROW IR,
					#dsn3_alias#.STOCKS S,
					#dsn3_alias#.PRODUCT_CAT PC,
					#dsn3_alias#.PRODUCT P
					<cfif attributes.report_type eq 4 or attributes.report_type eq 5>,#dsn_alias#.COMPANY C</cfif>
					<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
						,INVOICE_MONEY INVM
					</cfif>
				WHERE
					<cfif len(attributes.use_efatura) and attributes.use_efatura eq 1>
						ERD.INVOICE_ID IS NOT NULL AND
					<cfelseif len(attributes.use_efatura) and attributes.use_efatura eq 0>
						ERD.INVOICE_ID IS NULL AND
					</cfif>
					I.IS_IPTAL = 0 AND
					I.PURCHASE_SALES = 1 AND
					S.PRODUCT_ID = P.PRODUCT_ID AND
					S.PRODUCT_ID = IR.PRODUCT_ID AND
					IR.STOCK_ID = S.STOCK_ID AND
					I.INVOICE_ID = IR.INVOICE_ID AND
                    <cfif isdefined('attributes.product_types') and (attributes.product_types eq 1)>
                        P.IS_PURCHASE = 1 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 2)>
                        P.IS_INVENTORY = 0 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 3)>
                        P.IS_INVENTORY = 1 AND P.IS_PRODUCTION = 0 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 4)>
                        P.IS_TERAZI = 1 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 5)>
                        P.IS_PURCHASE = 0 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 6)>
                        P.IS_PRODUCTION = 1 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 7)>
                        P.IS_SERIAL_NO = 1 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 8)>
                        P.IS_KARMA = 1 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 9)>
                        P.IS_INTERNET = 1 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 10)>
                        P.IS_PROTOTYPE = 1 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 11)>
                        P.IS_ZERO_STOCK = 1 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 12)>
                        P.IS_EXTRANET = 1 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 13)>
                        P.IS_COST = 1 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 14)>
                        P.IS_SALES = 1 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 15)>
                        P.IS_QUALITY = 1 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 16)>
                        P.IS_INVENTORY = 1 AND
                    </cfif>
					<cfif not isdefined("attributes.is_zero_value")>
						I.GROSSTOTAL > 0 AND
						I.NETTOTAL > 0 AND
					</cfif>
					I.INVOICE_DATE BETWEEN #attributes.date1# AND #attributes.date2#  AND
					I.INVOICE_CAT IN (62) AND<!--- 20060504 iade tipleri : alim aide ve verilen fiyat farki fats --->
					PC.PRODUCT_CATID = P.PRODUCT_CATID 
					<cfif attributes.report_type eq 4>
						AND I.COMPANY_ID = C.COMPANY_ID
					<cfelseif attributes.report_type eq 5>
						AND	I.COMPANY_ID = C.COMPANY_ID 
						AND PC.PRODUCT_CATID = P.PRODUCT_CATID
					</cfif>
					<cfif attributes.is_other_money eq 1>
						AND INVM.ACTION_ID = I.INVOICE_ID 
						AND INVM.MONEY_TYPE = I.OTHER_MONEY
					<cfelseif attributes.is_money2 eq 1>
						AND INVM.ACTION_ID = I.INVOICE_ID
						AND INVM.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
					</cfif>
					<cfif len(attributes.project_id) and len(attributes.project_head)>
						AND I.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
					</cfif>
					<cfif len(trim(attributes.employee)) and len(attributes.sale_employee_id)>AND I.SALE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sale_employee_id#"></cfif>		
					<cfif len(attributes.company) and len(attributes.company_id) and attributes.company_id neq 0>AND I.COMPANY_ID =	<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"></cfif>
					<cfif len(attributes.company) and len(attributes.consumer_id) and attributes.consumer_id neq 0>AND I.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"></cfif>
					<cfif len(attributes.company) and len(attributes.employee_id) and attributes.employee_id neq 0>AND I.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"></cfif>
					<cfif len(trim(attributes.product_cat)) and len(attributes.search_product_catid)>AND PC.HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.search_product_catid#%"></cfif>
					<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>AND P.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"></cfif>
					<cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>AND P.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_employee_id#"></cfif>
					<cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>AND P.BRAND_ID IN (#attributes.brand_id#) </cfif>
					<cfif len(trim(attributes.model_name)) and len(attributes.model_id)>AND P.SHORT_CODE_ID IN (#attributes.model_id#) </cfif>
					<cfif len(attributes.payment_type) and len(attributes.payment_type_id)>
						AND I.PAY_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.payment_type_id#">
					<cfelseif len(attributes.payment_type) and len(attributes.card_paymethod_id)>
						AND I.CARD_PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.card_paymethod_id#">
					</cfif>
					<cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_id) and len(ship_method_name)>
						AND I.SHIP_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_method_id#">
					</cfif>
					<cfif len(attributes.department_id)>
						AND
						(
						<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
							(I.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND I.DEPARTMENT_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
						<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
						</cfloop>  
						) 
					<cfelseif len(branch_dep_list)>
						AND I.DEPARTMENT_ID IN (#branch_dep_list#)
					</cfif>
				GROUP BY
					<cfif attributes.is_other_money eq 1>
						I.OTHER_MONEY,
					</cfif>
					<cfif attributes.report_type eq 4>
						C.NICKNAME,
						C.COMPANY_ID,
						C.TAXOFFICE,
						C.TAXNO
					<cfelseif attributes.report_type eq 5>
						I.INVOICE_NUMBER,
						I.SERIAL_NUMBER,
						I.SERIAL_NO,
						I.DEPARTMENT_ID,
						I.DEPARTMENT_LOCATION,
						I.PROJECT_ID,
						C.NICKNAME,
						C.COMPANY_ID,
						C.OZEL_KOD_2,
						I.INVOICE_DATE,
						PC.PRODUCT_CAT,
						PC.HIERARCHY,
						PC.PRODUCT_CATID,
						S.PRODUCT_ID,
						P.PRODUCT_NAME,
						P.PRODUCT_CODE,
						P.PRODUCT_CODE_2,
						P.MANUFACT_CODE,
						IR.UNIT,
                        IR.UNIT2,
						IR.PRICE,
						IR.OTHER_MONEY_VALUE,
						I.OTHER_MONEY,
						IR.INVOICE_ROW_ID,
						IR.DUE_DATE,
						IR.ROW_PROJECT_ID,
						I.DUE_DATE,
						CAST(I.NOTE AS NVARCHAR),
						IR.SPECT_VAR_NAME,
						IR.SPECT_VAR_ID,
						I.PURCHASE_SALES,
						I.INVOICE_ID,
						IR.LOT_NO,
			        	P.BARCOD
                    <cfelseif attributes.report_type eq 12>
                        P.IS_PURCHASE,
                        P.IS_INVENTORY,
                        P.IS_PRODUCTION,
                        P.IS_TERAZI,
                        P.IS_SERIAL_NO,
                        P.IS_KARMA,
                        P.IS_INTERNET,
                        P.IS_PROTOTYPE,
                        P.IS_ZERO_STOCK,
                        P.IS_EXTRANET,
                        P.IS_COST,
                        P.IS_SALES,
                        P.IS_QUALITY
					</cfif>
			</cfquery>
			<cfquery name="get_total_purchase_2__"  datasource="#DSN2#"><!--- consumer --->
				SELECT
					<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
						<cfif attributes.kdv_dahil eq 1>
							-1*SUM((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) AS ISKONTO,
							-1*SUM(((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) / INVM.RATE2) ISKONTO_DOVIZ,
							-1*SUM( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL *(IR.TAX+100)/100 ) AS PRICE,
							-1*SUM( ( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL *(IR.TAX+100)/100) / INVM.RATE2 ) AS PRICE_DOVIZ
						<cfelse>
							-1*SUM((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) AS ISKONTO,
							-1*SUM(((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) / INVM.RATE2) ISKONTO_DOVIZ,
							-1*SUM( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL ) AS PRICE,
							-1*SUM( ( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL) / INVM.RATE2 ) AS PRICE_DOVIZ
						</cfif>
					<cfelse>
						<cfif attributes.kdv_dahil eq 1>
							-1*SUM((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) AS ISKONTO,
							-1*SUM( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL *(IR.TAX+100)/100 ) AS PRICE
						<cfelse>
							-1*SUM((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) AS ISKONTO,
							-1*SUM( (1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL ) AS PRICE
						</cfif>
					</cfif>
					<cfif attributes.is_other_money eq 1>
						,I.OTHER_MONEY
					</cfif>
					<cfif attributes.report_type eq 4>
						,C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME NICKNAME
						,C.CONSUMER_ID
						,C.TAX_OFFICE TAXOFFICE
						,C.TAX_NO TAXNO
						,-1*SUM(IR.AMOUNT) AS PRODUCT_STOCK
					<cfelseif attributes.report_type eq 5>
						,I.INVOICE_NUMBER
						,I.SERIAL_NUMBER
						,I.SERIAL_NO
						,I.DEPARTMENT_ID
						,I.DEPARTMENT_LOCATION
						,I.PROJECT_ID
						,C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME AS MUSTERI
						,C.CONSUMER_ID COMPANY_ID
						,'' AS OZEL_KOD_2
						,I.INVOICE_DATE
						,PC.PRODUCT_CAT
						,PC.HIERARCHY
						,PC.PRODUCT_CATID
						,S.PRODUCT_ID
						,P.PRODUCT_NAME
						,P.PRODUCT_CODE
						,P.PRODUCT_CODE_2
						,P.MANUFACT_CODE
						,-1*SUM(IR.AMOUNT) AS PRODUCT_STOCK
						,-1*SUM(IR.EXTRA_COST) AS COST_PRICE
						,SUM(IR.AMOUNT2) AS PRODUCT_STOCK2
						,SUM(IR.NETTOTAL) AS NET_TOTAL
						,IR.UNIT AS BIRIM
						,IR.UNIT2 AS BIRIM2
						,IR.PRICE AS BIRIM_FIYAT
						,IR.OTHER_MONEY_VALUE AS OTHER_MONEY_VALUE
						,I.OTHER_MONEY AS OTHER_MONEY
						,IR.INVOICE_ROW_ID
						,IR.DUE_DATE
						,IR.ROW_PROJECT_ID
						,I.DUE_DATE AS INV_DUE_DATE
						,CAST(I.NOTE AS NVARCHAR) NOTE
						,IR.SPECT_VAR_NAME
						,(SELECT TOP 1 SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS WHERE SPECTS.SPECT_VAR_ID = IR.SPECT_VAR_ID) AS SPECT_MAIN_ID
						,I.PURCHASE_SALES
						,I.INVOICE_ID
						,IR.LOT_NO
			        	,P.BARCOD
                    <cfelseif attributes.report_type eq 12>
						,-1*SUM(IR.AMOUNT) AS PRODUCT_STOCK
                        ,CASE
                        WHEN P.IS_PURCHASE = 1 THEN 1 
                        WHEN P.IS_INVENTORY = 0 THEN 2 
                        WHEN (P.IS_INVENTORY = 1 AND P.IS_PRODUCTION = 0) THEN 3
                        WHEN P.IS_TERAZI = 1 THEN 4
                        WHEN P.IS_PURCHASE = 0 THEN 5
                        WHEN P.IS_PRODUCTION = 1 THEN 6 
                        WHEN P.IS_SERIAL_NO = 1 THEN 7
                        WHEN P.IS_KARMA = 1 THEN 8 
                        WHEN P.IS_INTERNET = 1 THEN 9
                        WHEN P.IS_PROTOTYPE = 1 THEN 10
                        WHEN P.IS_ZERO_STOCK = 1 THEN 11
                        WHEN P.IS_EXTRANET = 1 THEN 12
                        WHEN P.IS_COST = 1 THEN 13
                        WHEN P.IS_SALES = 1 THEN 14
                        WHEN P.IS_QUALITY = 1 THEN 15
                        WHEN P.IS_INVENTORY = 1 THEN 16 
                        END AS PRODUCT_TYPE
					</cfif>
					,2 TYPE <!--- bireysel üye --->
				FROM
					INVOICE I
					<cfif len(attributes.use_efatura)>
						LEFT JOIN EINVOICE_RECEIVING_DETAIL ERD ON ERD.INVOICE_ID = I.INVOICE_ID
					</cfif>,
					INVOICE_ROW IR,
					#dsn3_alias#.STOCKS S,
					#dsn3_alias#.PRODUCT_CAT PC,
					#dsn3_alias#.PRODUCT P
					<cfif attributes.report_type eq 4 or attributes.report_type eq 5>,#dsn_alias#.CONSUMER C</cfif>
					<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
						,INVOICE_MONEY INVM
					</cfif>
				WHERE
					<cfif len(attributes.use_efatura) and attributes.use_efatura eq 1>
						ERD.INVOICE_ID IS NOT NULL AND
					<cfelseif len(attributes.use_efatura) and attributes.use_efatura eq 0>
						ERD.INVOICE_ID IS NULL AND
					</cfif>
					I.IS_IPTAL = 0 AND
					I.PURCHASE_SALES = 1 AND
					S.PRODUCT_ID = P.PRODUCT_ID AND
					S.PRODUCT_ID = IR.PRODUCT_ID AND
					IR.STOCK_ID = S.STOCK_ID AND
					I.INVOICE_ID = IR.INVOICE_ID AND
                    <cfif isdefined('attributes.product_types') and (attributes.product_types eq 1)>
                        P.IS_PURCHASE = 1 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 2)>
                        P.IS_INVENTORY = 0 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 3)>
                        P.IS_INVENTORY = 1 AND P.IS_PRODUCTION = 0 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 4)>
                        P.IS_TERAZI = 1 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 5)>
                        P.IS_PURCHASE = 0 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 6)>
                        P.IS_PRODUCTION = 1 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 7)>
                        P.IS_SERIAL_NO = 1 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 8)>
                        P.IS_KARMA = 1 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 9)>
                        P.IS_INTERNET = 1 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 10)>
                        P.IS_PROTOTYPE = 1 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 11)>
                        P.IS_ZERO_STOCK = 1 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 12)>
                        P.IS_EXTRANET = 1 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 13)>
                        P.IS_COST = 1 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 14)>
                        P.IS_SALES = 1 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 15)>
                        P.IS_QUALITY = 1 AND
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 16)>
                        P.IS_INVENTORY = 1 AND
                    </cfif>
					<cfif not isdefined("attributes.is_zero_value")>
						I.GROSSTOTAL > 0 AND
						I.NETTOTAL > 0 AND
					</cfif>
					I.INVOICE_DATE BETWEEN #attributes.date1# AND #attributes.date2#  AND
					I.INVOICE_CAT IN (62) AND<!--- 20060504 iade tipleri : alim aide ve verilen fiyat farki fats --->
					PC.PRODUCT_CATID = P.PRODUCT_CATID 
					<cfif attributes.report_type eq 4>
						AND I.CONSUMER_ID = C.CONSUMER_ID
					<cfelseif attributes.report_type eq 5>
						AND	I.CONSUMER_ID = C.CONSUMER_ID 
						AND PC.PRODUCT_CATID = P.PRODUCT_CATID
					</cfif>
					<cfif attributes.is_other_money eq 1>
						AND INVM.ACTION_ID = I.INVOICE_ID 
						AND INVM.MONEY_TYPE = I.OTHER_MONEY
					<cfelseif attributes.is_money2 eq 1>
						AND INVM.ACTION_ID = I.INVOICE_ID
						AND INVM.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
					</cfif>
					<cfif len(attributes.project_id) and len(attributes.project_head)>
						AND I.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
					</cfif>
					<cfif len(trim(attributes.employee)) and len(attributes.sale_employee_id)>AND I.SALE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sale_employee_id#"></cfif>		
					<cfif len(attributes.company) and len(attributes.company_id) and attributes.company_id neq 0>AND I.COMPANY_ID =	<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"></cfif>
					<cfif len(attributes.company) and len(attributes.consumer_id) and attributes.consumer_id neq 0>AND I.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"></cfif>
					<cfif len(attributes.company) and len(attributes.employee_id) and attributes.employee_id neq 0>AND I.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"></cfif>
					<cfif len(trim(attributes.product_cat)) and len(attributes.search_product_catid)>AND PC.HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.search_product_catid#%"></cfif>
					<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>AND P.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"></cfif>
					<cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>AND P.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_employee_id#"></cfif>
					<cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>AND P.BRAND_ID IN (#attributes.brand_id#) </cfif>
					<cfif len(trim(attributes.model_name)) and len(attributes.model_id)>AND P.SHORT_CODE_ID IN (#attributes.model_id#) </cfif>
					<cfif len(attributes.payment_type) and len(attributes.payment_type_id)>
						AND I.PAY_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.payment_type_id#">
					<cfelseif len(attributes.payment_type) and len(attributes.card_paymethod_id)>
						AND I.CARD_PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.card_paymethod_id#">
					</cfif>
					<cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_id) and len(ship_method_name)>
						AND I.SHIP_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_method_id#">
					</cfif>
					<cfif len(attributes.department_id)>
						AND
						(
						<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
							(I.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND I.DEPARTMENT_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
						<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
						</cfloop>  
						) 
					<cfelseif len(branch_dep_list)>
						AND I.DEPARTMENT_ID IN (#branch_dep_list#)
					</cfif>
				GROUP BY
					<cfif attributes.is_other_money eq 1>
						I.OTHER_MONEY,
					</cfif>
					<cfif attributes.report_type eq 4>
						C.CONSUMER_NAME,
						C.CONSUMER_SURNAME,
						C.CONSUMER_ID,
						C.TAX_OFFICE,
						C.TAX_NO
					<cfelseif attributes.report_type eq 5>
						I.INVOICE_NUMBER,
						I.SERIAL_NUMBER,
						I.SERIAL_NO,
						I.DEPARTMENT_ID,
						I.DEPARTMENT_LOCATION,
						I.PROJECT_ID,
						C.CONSUMER_NAME,
						C.CONSUMER_SURNAME,
						C.CONSUMER_ID,
						I.INVOICE_DATE,
						PC.PRODUCT_CAT,
						PC.HIERARCHY,
						PC.PRODUCT_CATID,
						S.PRODUCT_ID,
						P.PRODUCT_NAME,
						P.PRODUCT_CODE,
						P.PRODUCT_CODE_2,
						P.MANUFACT_CODE,
						IR.UNIT,
                        IR.UNIT2,
						IR.PRICE,
						IR.OTHER_MONEY_VALUE,
						I.OTHER_MONEY,
						IR.INVOICE_ROW_ID,
						IR.DUE_DATE,
						IR.ROW_PROJECT_ID,
						I.DUE_DATE,
						CAST(I.NOTE AS NVARCHAR),
						IR.SPECT_VAR_NAME,
						IR.SPECT_VAR_ID,
						I.PURCHASE_SALES,
						I.INVOICE_ID,
						IR.LOT_NO,
			        	P.BARCOD
                    <cfelseif attributes.report_type eq 12>
                        P.IS_PURCHASE,
                        P.IS_INVENTORY,
                        P.IS_PRODUCTION,
                        P.IS_TERAZI,
                        P.IS_SERIAL_NO,
                        P.IS_KARMA,
                        P.IS_INTERNET,
                        P.IS_PROTOTYPE,
                        P.IS_ZERO_STOCK,
                        P.IS_EXTRANET,
                        P.IS_COST,
                        P.IS_SALES,
                        P.IS_QUALITY
					</cfif>
			</cfquery>
			<cfquery name="get_total_purchase_2" dbtype="query">
				SELECT * FROM get_total_purchase_2
				UNION 
				SELECT * FROM get_total_purchase_2__
				ORDER BY
				<cfif attributes.report_sort eq 1>
					PRICE DESC
				<cfelseif attributes.report_sort eq 2>
					PRODUCT_STOCK DESC
				</cfif>
			</cfquery>
			<cfquery name="get_total_purchase_3" dbtype="query">
				SELECT * FROM get_total_purchase
				UNION 
				SELECT * FROM get_total_purchase_2 
				ORDER BY
				<cfif attributes.report_sort eq 1>
					PRICE DESC
				<cfelseif attributes.report_sort eq 2>
					PRODUCT_STOCK DESC
				</cfif>
			</cfquery>
			<cfquery name="get_total_purchase" dbtype="query">
				SELECT 
					SUM(PRICE) AS PRICE,
					SUM(ISKONTO) AS ISKONTO
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					,SUM(PRICE_DOVIZ) AS PRICE_DOVIZ
					,SUM(ISKONTO_DOVIZ) AS ISKONTO_DOVIZ
				</cfif>
				<cfif attributes.report_type eq 4>
					,NICKNAME,COMPANY_ID,TAXOFFICE,TAXNO,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
				<cfelseif attributes.report_type eq 5>
					,INVOICE_ID,
					INVOICE_NUMBER,
					SERIAL_NUMBER,
					SERIAL_NO,
					DEPARTMENT_ID,
					PURCHASE_SALES,
					DEPARTMENT_LOCATION
					MUSTERI,
					COMPANY_ID,
					OZEL_KOD_2,
					BIRIM_FIYAT,
					OTHER_MONEY_VALUE,
					OTHER_MONEY,
					INVOICE_DATE,
					PRODUCT_CAT,
					HIERARCHY,
					PRODUCT_CATID,
					PRODUCT_ID,
					PRODUCT_NAME,
					PRODUCT_CODE,
					PRODUCT_CODE_2,
					MANUFACT_CODE,
					SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,
					SUM(COST_PRICE) AS COST_PRICE,
					BIRIM,
					BIRIM2,
					INVOICE_ROW_ID,
					DUE_DATE,
					INV_DUE_DATE,
					NOTE,
					SPECT_VAR_NAME,
					SPECT_MAIN_ID,
					ROW_PROJECT_ID,
					PROJECT_ID,
					IR.LOT_NO,
			        P.BARCOD
				<cfelseif attributes.report_type eq 12>
                	,PRODUCT_TYPE,SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
                </cfif>	
				,TYPE
				FROM 
					get_total_purchase_3
				GROUP BY 
				<cfif attributes.is_other_money eq 1>
					OTHER_MONEY,
				</cfif>
				<cfif attributes.report_type eq 4>
					NICKNAME,COMPANY_ID,TAXNO,TAXOFFICE
				<cfelseif attributes.report_type eq 5>
					INVOICE_ID,
					INVOICE_NUMBER,
					SERIAL_NUMBER,
					SERIAL_NO,
					DEPARTMENT_ID,
					PURCHASE_SALES,
					DEPARTMENT_LOCATION,
					INVOICE_DATE,
					COMPANY_ID,
					OZEL_KOD_2,
					PRODUCT_CAT,
					HIERARCHY,
					PRODUCT_CATID,
					PRODUCT_ID,
					PRODUCT_NAME,
					PRODUCT_CODE,
					PRODUCT_CODE_2,
					MANUFACT_CODE,
					BIRIM,
                    BIRIM2,
					MUSTERI,
					BIRIM_FIYAT,
					OTHER_MONEY_VALUE,
					OTHER_MONEY,
					INVOICE_ROW_ID,
					DUE_DATE,
					INV_DUE_DATE,
					NOTE,
					SPECT_VAR_NAME,
					SPECT_MAIN_ID,
					ROW_PROJECT_ID,
					PROJECT_ID,
					PRODUCT_STOCK,
					COST_PRICE,
					IR.LOT_NO,
			        P.BARCOD
				<cfelseif attributes.report_type eq 12>
                	,PRODUCT_TYPE
				</cfif>	
					,TYPE
				ORDER  BY 
				<cfif attributes.kontrol_type eq 1>
					INVOICE_NUMBER
				<cfelseif attributes.report_sort eq 1>
					PRICE DESC
				<cfelseif attributes.report_sort eq 2>
					PRODUCT_STOCK DESC
				</cfif>
			</cfquery>
		</cfif>
	</cfif>		
	<cfquery name="get_all_total" dbtype="query">
		SELECT SUM(PRICE) AS PRICE FROM get_total_purchase
	</cfquery>
	<cfif len(get_all_total.PRICE)>
		<cfset butun_toplam=get_all_total.PRICE>
	<cfelse>
		<cfset butun_toplam=1>
	</cfif>	
	<cfif attributes.report_type eq 4 and attributes.invoice_count eq 1>
		<cfquery name="get_count" datasource="#dsn2#">
			SELECT  
				C.NICKNAME,
				C.COMPANY_ID,
				COUNT(C.COMPANY_ID) AS ISLEM_SAYISI
			FROM
				INVOICE I,
				#dsn_alias#.COMPANY C
			WHERE
				<cfif len(attributes.process_type)>I.PROCESS_CAT IN (#attributes.process_type#) AND</cfif>
				I.PURCHASE_SALES = 0 AND
				I.IS_IPTAL = 0 AND
				I.INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">  AND
				I.COMPANY_ID = C.COMPANY_ID  
			GROUP BY	
				C.NICKNAME,
				C.COMPANY_ID
		</cfquery>
		<cfquery name="get_count_" datasource="#dsn2#">
			SELECT  
				C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME NICKNAME,
				C.CONSUMER_ID,
				COUNT(C.CONSUMER_ID) AS ISLEM_SAYISI
			FROM
				INVOICE I,
				#dsn_alias#.CONSUMER C
			WHERE
				<cfif len(attributes.process_type)>I.PROCESS_CAT IN (#attributes.process_type#) AND</cfif>
				I.PURCHASE_SALES = 0 AND
				I.IS_IPTAL = 0 AND
				I.INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">  AND
				I.CONSUMER_ID = C.CONSUMER_ID  
			GROUP BY	
				C.CONSUMER_NAME,
				C.CONSUMER_SURNAME,
				C.CONSUMER_ID
		</cfquery>
	</cfif>
</cfif>
<cfset toplam_satis=0>
<cfset toplam_satis2=0>
<cfset toplam_satis3=0>
<cfset toplam_iskonto=0>
<cfset toplam_iskonto2=0>
<cfset toplam_birim=0>
<cfset toplam_miktar=0>
<cfset toplam_maliyet=0>
<cfif attributes.report_type eq 8>
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
<cfelseif attributes.report_type eq 9>
	<cfquery name="get_position" datasource="#dsn#">
		SELECT POSITION_CODE,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS
	</cfquery>
	<cfset position_code_list = valuelist(get_position.position_code,',')>
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
<cfset product_cat_list = "50,79,412,55,159,46,546,456,667,52,547,607,545,48,164,44">
<cfsavecontent variable="title"><cf_get_lang dictionary_id='30103.Alış Analizi Fatura'></cfsavecontent>
<cf_report_list_search id="analyse_report" title="#title#">
	<cf_report_list_search_area>
		<cfform name="rapor" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.purchase_analyse_report">
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
											<input type="text" name="product_name" id="product_name" style="width:175px;" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product_autocomplete','0','PRODUCT_ID','product_id','','3','200');" autocomplete="off" value="<cfoutput>#attributes.product_name#</cfoutput>" passthrough="readonly=yes">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="set_the_report();windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=rapor.product_id&field_name=rapor.product_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','list');"></span>
										</div>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58448.Ürün Sorumlusu'></label>
									<div class="col col-12 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="product_employee_id" id="product_employee_id"  value="<cfif len(attributes.employee_name)><cfoutput>#attributes.product_employee_id#</cfoutput></cfif>">
            							<input type="text" name="employee_name" id="employee_name" style="width:175px;" value="<cfif len(attributes.employee_name)><cfoutput>#attributes.employee_name#</cfoutput></cfif>" maxlength="255">
           								<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=rapor.product_employee_id&field_name=rapor.employee_name&select_list=1,9','list');"></span>
									</div>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='30011.Satın Alan'></label>
									<div class="col col-12 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="sale_employee_id" id="sale_employee_id"  value="<cfif len(attributes.employee)><cfoutput>#attributes.sale_employee_id#</cfoutput></cfif>">
            							<input type="text" name="employee" id="employee" style="width:175px;" value="<cfif len(attributes.employee)><cfoutput>#attributes.employee#</cfoutput></cfif>" maxlength="255">
           								<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=rapor.sale_employee_id&field_emp_id2=rapor.employee_id&field_name=rapor.employee&select_list=1,9','list');"></span>
									</div>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
									<div class="col col-12 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="consumer_id" id="consumer_id" <cfif len(attributes.company)>value="<cfoutput>#attributes.consumer_id#</cfoutput>"</cfif>>			
										<input type="hidden" name="company_id" id="company_id" <cfif len(attributes.company)> value="<cfoutput>#attributes.company_id#</cfoutput>"</cfif>>
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
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58225.Model'></label>
									<cf_wrk_list_items table_name ='PRODUCT_BRANDS_MODEL' wrk_list_object_id='MODEL_ID' wrk_list_object_name='MODEL_NAME' sub_header_name="#getLang('main',813)#" header_name="#getLang('report',1354)#" width='175' datasource ="#dsn1#">
								</div>
							</div> 
							<div class="col col-3 col-md-6 col-xs-12">
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
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></label>
									<div class="col col-12 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="<cfoutput>#attributes.card_paymethod_id#</cfoutput>">
										<input type="hidden" name="payment_type_id" id="payment_type_id" value="<cfoutput>#attributes.payment_type_id#</cfoutput>">
            							<input type="text" name="payment_type" id="payment_type" value="<cfoutput>#attributes.payment_type#</cfoutput>" style="width:175px;">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_paymethods&field_id=rapor.payment_type_id&field_name=rapor.payment_type&field_card_payment_id=rapor.card_paymethod_id&field_card_payment_name=rapor.payment_type','medium');"></span>
									</div>
									</div>
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
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58960.Rapor Tipi'></label>
									<div class="col col-12 col-xs-12">
									<select name="report_type" id="report_type" style="width:162px;" onchange="kontrol();">
										<option value="11" <cfif attributes.report_type eq 11>selected</cfif>><cf_get_lang dictionary_id='40556.Ana Kategori'><cf_get_lang dictionary_id='58601.Bazında'></option>
										<option value="5" <cfif attributes.report_type eq 5>selected</cfif>><cf_get_lang dictionary_id='39685.Belge ve Stok Bazında'></option>
										<option value="4" <cfif attributes.report_type eq 4>selected</cfif>><cf_get_lang dictionary_id='39075.Cari Bazında'></option>
										<option value="6" <cfif attributes.report_type eq 6>selected</cfif>><cf_get_lang dictionary_id='39095.Marka Bazında'></option>
										<option value="1" <cfif attributes.report_type eq 1>selected</cfif>><cf_get_lang dictionary_id='39052.Kategori Bazında'></option>
										<option value="8" <cfif attributes.report_type eq 8>selected</cfif>><cf_get_lang dictionary_id='39374.Ödeme Yöntemi Bazında'></option>
										<option value="7" <cfif attributes.report_type eq 7>selected</cfif>><cf_get_lang dictionary_id='29819.Proje Bazında'></option>
										<option value="3" <cfif attributes.report_type eq 3>selected</cfif>><cf_get_lang dictionary_id='39054.Stok Bazında'></option>
										<option value="10" <cfif attributes.report_type eq 10>selected</cfif>><cf_get_lang dictionary_id='39350.Şube Bazında'></option>
										<option value="2" <cfif attributes.report_type eq 2>selected</cfif>><cf_get_lang dictionary_id='39053.Ürün Bazında'></option>
										<option value="12" <cfif attributes.report_type eq 12>selected</cfif>><cf_get_lang dictionary_id="40074.Ürün Grubu"><cf_get_lang dictionary_id='58601.Bazında'></option>
										<option value="9" <cfif attributes.report_type eq 9>selected</cfif>><cf_get_lang dictionary_id='39696.Ürün Sorumlusu Bazında'></option>
									</select>
									</div>
								</div>
								<cfif session.ep.our_company_info.is_efatura>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='29872.E-Fatura'></label>
									<div class="col col-12 col-xs-12">
									<select name="use_efatura" id="use_efatura" style="width:162px;">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<option value="1" <cfif attributes.use_efatura eq 1>selected="selected"</cfif>><cf_get_lang dictionary_id='29492.Kullanıyor'></option>
										<option value="0" <cfif attributes.use_efatura eq 0>selected="selected"</cfif>><cf_get_lang dictionary_id='29493.Kullanmıyor'></option>
									</select>
									</div>
								</div>
								</cfif>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='39741.E-Grafik'></label>
									<div class="col col-12 col-xs-12">
									<select name="graph_type" id="graph_type" style="width:162px;">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<option value="cylinder" <cfif attributes.graph_type eq 'cylinder'> selected</cfif>><cf_get_lang dictionary_id='57666.Silindir'></option>
										<option value="pie"<cfif attributes.graph_type eq 'pie'> selected</cfif>><cf_get_lang dictionary_id='58728.Pasta'></option>
										<option value="bar"<cfif attributes.graph_type eq 'bar'> selected</cfif>><cf_get_lang dictionary_id='57663.Bar'></option>
									</select>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="40074.Ürün Grubu"></label>
									<div class="col col-12 col-xs-12">
										<cf_get_lang_set module_name="product">
											<select name="product_types" id="product_types" style="width:175px;">
												<option value=""><cf_get_lang dictionary_id='57734.Seciniz'></option>
												<option value="5"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 5)> selected</cfif>><cf_get_lang dictionary_id='37170.Tedarik Edilmiyor'></option>
												<option value="1"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 1)> selected</cfif>><cf_get_lang dictionary_id='37061.Tedarik Ediliyor'></option>
												<option value="2"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 2)> selected</cfif>><cf_get_lang dictionary_id='37090.Hizmetler'></option>
												<option value="16"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 16)> selected</cfif>><cf_get_lang dictionary_id='37055.Envantere Dahil'></option>
												<option value="3"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 3)> selected</cfif>><cf_get_lang dictionary_id='37423.Mallar'></option>
												<option value="4"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 4)> selected</cfif>><cf_get_lang dictionary_id='37066.Terazi'></option>
												<option value="6"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 6)> selected</cfif>><cf_get_lang dictionary_id='37057.Üretiliyor'></option>
												<option value="13"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 13)> selected</cfif>><cf_get_lang dictionary_id='37556.Maliyet Takip Ediliyor'></option>
												<option value="15"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 15)> selected</cfif>><cf_get_lang dictionary_id='59157.Kalite'><cf_get_lang dictionary_id="37175.Takip Ediliyor"></option>
												<option value="7"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 7)> selected</cfif>><cf_get_lang dictionary_id='37557.Seri No Takip'></option>
												<option value="8"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 8)> selected</cfif>><cf_get_lang dictionary_id='37467.Karma Koli'></option>
												<option value="9"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 9)> selected</cfif>><cf_get_lang dictionary_id='58079.İnternet'></option>
												<option value="12"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 12)> selected</cfif>><cf_get_lang dictionary_id='58019.Extranet'></option>
												<option value="10"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 10)> selected</cfif>><cf_get_lang dictionary_id='37063.Özelleştirilebilir'></option>
												<option value="11"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 11)> selected</cfif>><cf_get_lang dictionary_id='37558.Sıfır Stok İle Çalış'></option>
												<option value="14"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 14)> selected</cfif>><cf_get_lang dictionary_id='37059.Satışta'></option>
											</select>
										<cf_get_lang_set module_name="report">
									</div>
								</div>
								<div class="form-group">
									<cfif attributes.report_type eq 5 or attributes.report_type eq 3>
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57518.Stok Kodu'></label>
										<div class="col col-12 col-xs-12">	
											<input type="text" name="stock_code" id="stock_code" value="<cfoutput>#attributes.stock_code#</cfoutput>" maxlength="50" style="width:175px;">
										</div>
									</cfif>
								</div>
							</div>
							<div class="col col-3 col-md-6 col-xs-12">
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57800.İşlem Tipi'>*</label>
									<div class="col col-12 col-xs-12">
									<select name="process_type" id="process_type" style="width:175px; height:70px;" multiple>
										<cfoutput query="get_process_cat">
										<option value="#PROCESS_CAT_ID#" <cfif listfind(attributes.process_type,PROCESS_CAT_ID,',')>selected</cfif>>#PROCESS_CAT#</option>
										</cfoutput>
									</select>
									</div>
								</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58763.Depo'></label>
									<div class="col col-12 col-xs-12">
									<select name="department_id" id="department_id" multiple style="width:175px;height:70px;">
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
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58609.Üye Kategorisi'></label>
									<div class="col col-12 col-xs-12">
									<select name="member_cat_type" id="member_cat_type" multiple style="width:175px;height:70px;">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id ='58039.Kurumsal Üye Kategorileri'></cfsavecontent>
											<optgroup label="<cfoutput>#message#</cfoutput>">
												<cfoutput query="get_company_cat">
												<option value="1-#COMPANYCAT_ID#" <cfif listfind(attributes.member_cat_type,'1-#COMPANYCAT_ID#',',')>selected</cfif>>&nbsp;&nbsp;#COMPANYCAT#</option>
												</cfoutput>
											</optgroup>
											<cfsavecontent variable="message"><cf_get_lang dictionary_id ='58040.Bireysel Üye Kategorileri'></cfsavecontent>
											<optgroup label="<cfoutput>#message#</cfoutput>">
												<cfoutput query="get_consumer_cat">
												<option value="2-#CONSCAT_ID#" <cfif listfind(attributes.member_cat_type,'2-#CONSCAT_ID#',',')>selected</cfif>>&nbsp;&nbsp;#CONSCAT#</option>
												</cfoutput>
											</optgroup>
									</select>	
									</div>
								</div>
							</div>
							<div class="col col-3 col-md-6 col-xs-12">
								<div class="form-group">
                           		 	<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58690.Tarih Aralığı'></label>
                                	<cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'></cfsavecontent>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang Dictionary_id ='58053.Başlangıç Tarihi'></cfsavecontent>
											<cfinput validate="#validate_style#" message="#message#" type="text" name="date1" value="#dateformat(attributes.date1,dateformat_style)#" required="yes">  
											<span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>            
											<span class="input-group-addon no-bg"></span>
											<cfsavecontent variable="message2"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang Dictionary_id ='57700.Bitiş Tarihi'></cfsavecontent>
											<cfinput validate="#validate_style#" message="#message2#" type="text" name="date2" value="#dateformat(attributes.date2,dateformat_style)#" required="yes">
											<span class="input-group-addon"><cf_wrk_date_image date_field="date2"></span>  
										</div>
									</div>
                        		</div>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='39055.Rapor Sıra'></label> 
									<div class="col col-12 col-xs-12">
										<input type="hidden" name="kontrol_type" id="kontrol_type" value="0">
										<label><cf_get_lang dictionary_id='30010.Ciro'><input type="radio" name="report_sort" id="report_sort" value="1"  <cfif attributes.report_sort eq 1>checked</cfif>></label>
										<label><cf_get_lang dictionary_id='57635.Miktar'><input type="radio" name="report_sort" id="report_sort" value="2"  <cfif attributes.report_sort eq 2>checked</cfif>></label>
									</div>
								</div>
								<div class="form-group">
									<div class="col col-12 col-xs-12">
										<label id="gizli1" style="<cfif attributes.report_type neq 4>display:none;</cfif>"><cf_get_lang dictionary_id='40025.İşlem Sayısı'><input type="checkbox" name="invoice_count" id="invoice_count" value="1" <cfif attributes.invoice_count eq 1>checked</cfif>></label>
										<label id="gizli1" style="<cfif attributes.report_type neq 4>display:none;</cfif>"><cf_get_lang dictionary_id='57752.Vergi No'><input type="checkbox" name="taxno" id="taxno" value="1" <cfif attributes.taxno eq 1>checked</cfif>></label>
										<label><cf_get_lang dictionary_id='39410.İşlem Dovizli'><input name="is_other_money" id="is_other_money" value="1" type="checkbox" <cfif attributes.is_other_money eq 1 >checked</cfif>></label>
										<cfif isdefined("session.ep.money2")><label><cf_get_lang dictionary_id='58596.Göster'><input name="is_money2" id="is_money2" value="1" type="checkbox" <cfif attributes.is_money2 eq 1 >checked</cfif>><cfoutput> #session.ep.money2#</cfoutput></label></cfif>
										<label><cf_get_lang dictionary_id='39059.Kdv Dahil'><input type="checkbox" name="kdv_dahil" id="kdv_dahil" value="1" <cfif isdefined("attributes.kdv_dahil") and (attributes.kdv_dahil eq 1)>checked</cfif>></label>
										<label><cf_get_lang dictionary_id='39058.İadeler Düşsün'><input type="checkbox" name="is_return" id="is_return" value="1" <cfif attributes.is_return eq 1>checked</cfif>></label>
										<label><cf_get_lang dictionary_id='39368.İskonto Göster'><input name="is_discount" id="is_discount" value="1" type="checkbox" <cfif attributes.is_discount eq 1 >checked</cfif>></label>
										<label style="<cfif attributes.report_type neq 5>display:none;</cfif>" id="is_spect_info"><cf_get_lang dictionary_id='40610.Spec Göster'><input type="checkbox" name="is_spect_info" id="is_spect_info" value="1" <cfif attributes.is_spect_info eq 1 >checked</cfif>></label>
										<label style="<cfif attributes.report_type neq 5>display:none;</cfif>" id="money_info_2"><cf_get_lang dictionary_id='39647.Döviz Göster'><input type="checkbox" name="is_money_info" id="is_money_info" value="1" <cfif isdefined("attributes.is_money_info")>checked</cfif>></label>
										<label style="<cfif attributes.report_type neq 5>display:none;</cfif>" id="money_info_2"><cf_get_lang dictionary_id='57416.Proje'> <cf_get_lang dictionary_id='58596.Göster'><input name="is_project" id="is_project" value="1" type="checkbox" <cfif attributes.is_project eq 1 >checked</cfif>></label>
										<label style="<cfif not listfind('2,3,5',attributes.report_type)>display:none;</cfif>" id="gizli2"><cf_get_lang dictionary_id='40023.Ek Maliyet'><input type="checkbox" name="cost_price" id="cost_price" value="1" <cfif attributes.cost_price eq 1>checked</cfif>></label>
										<label><cf_get_lang dictionary_id ='38842.Sıfır Tutarlı Faturalar Dahil'><input type="checkbox" name="is_zero_value" id="is_zero_value" value="1" <cfif isdefined("attributes.is_zero_value")>checked</cfif>></label>
									</div>
									 
								</div>
							</div>
						</div>
					</div>
					<div class="row ReportContentBorder">
                		<div class="ReportContentFooter">
							<label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" value="1" name="is_excel" id="is_excel" <cfif attributes.is_excel eq 1>checked</cfif>></label>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfinput type="text" name="max_rows" value="#attributes.max_rows#" required="yes" onKeyUp="isNumber(this)" validate="integer" message="#message#" maxlength="3" style="width:25px;">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57911.Çalıştır'></cfsavecontent> 
							<cf_wrk_report_search_button search_function='satir_kontrol()' button_type='1' insert_info='#message#'>
						</div>
					</div>
				</div>
			</div>
		</cfform>
		<cfif isdefined("attributes.form_submitted") and not (isdefined("attributes.is_excel") and attributes.is_excel eq 1)>
			<cfsavecontent variable='title'><cf_get_lang dictionary_id='57800.İşlem Tipi'></cfsavecontent>
			<cf_seperator title="#title#" id="transaction_type" is_closed="1">
			<table class="color-border" width="99%" cellpadding="2" cellspacing="1" style="display:none;" id="transaction_type">
				<tr class="color-row">
					<td valign="top" nowrap="nowrap">
						<cfif len(attributes.process_type)>
							<cfquery name="get_process_cat" datasource="#DSN3#">
								SELECT PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID IN (#attributes.process_type#) AND PROCESS_TYPE IN (49,51,54,55,59,591,592,60,601,61,62,63,64,68,690,691) ORDER BY PROCESS_CAT
							</cfquery>
						<cfelse>
							<cfset get_process_cat.recordcount = 0>
						</cfif>
						<cfif get_process_cat.recordcount>
							<cfoutput query="get_process_cat">#process_cat#<br></cfoutput>
						</cfif>
					</td>
					<td valign="top">
						<cf_get_lang dictionary_id='58960.Rapor Tipi'>:
						<cfif attributes.report_type eq 1><cf_get_lang dictionary_id='39052.Kategori Bazında'>
						<cfelseif attributes.report_type eq 2><cf_get_lang dictionary_id='39053.Ürün Bazında'>
						<cfelseif attributes.report_type eq 3><cf_get_lang dictionary_id='39054.Stok Bazında'>
						<cfelseif attributes.report_type eq 4><cf_get_lang dictionary_id='39075.Cari Bazında'>
						<cfelseif attributes.report_type eq 5><cf_get_lang dictionary_id='39685.Belge ve Stok Bazında'>
						<cfelseif attributes.report_type eq 6><cf_get_lang dictionary_id='39095.Marka Bazında'>
						<cfelseif attributes.report_type eq 7><cf_get_lang dictionary_id='29819.Proje Bazında'>
						<cfelseif attributes.report_type eq 8><cf_get_lang dictionary_id='39374.Ödeme Yöntemi Bazında'>
						<cfelseif attributes.report_type eq 9><cf_get_lang dictionary_id='39696.Ürün Sorumlusu Bazında'>
						<cfelseif attributes.report_type eq 10><cf_get_lang dictionary_id='39350.Şube Bazında'>
						<cfelseif attributes.report_type eq 11><cf_get_lang dictionary_id='40556.Ana Kategori'> <cf_get_lang dictionary_id='58601.Bazında'>
						<cfelseif attributes.report_type eq 12><cf_get_lang dictionary_id="40074.Ürün Grubu"> <cf_get_lang dictionary_id='58601.Bazında'>
						</cfif><hr>
						<cf_get_lang dictionary_id='57486.Kategori'>:<cfoutput>#attributes.product_cat#</cfoutput><hr>
						<cf_get_lang dictionary_id='57519.Cari Hesap'>:<cfoutput>#attributes.company#</cfoutput><hr>
						<cf_get_lang dictionary_id='57416.Proje'>:<cfoutput>#attributes.project_head#</cfoutput><hr>
					</td>
					<cfoutput>
					<td valign="top">
						<cf_get_lang dictionary_id='57742.Tarih'>:#dateformat(attributes.date1,dateformat_style)#-#dateformat(attributes.date2,dateformat_style)#<hr>
						<cf_get_lang dictionary_id='57657.Ürün'>:#attributes.product_name#<hr>
						<cf_get_lang dictionary_id='58448.Ürün Sorumlu'>:#attributes.employee_name#<hr>
						<cf_get_lang dictionary_id='58847.Marka'>:#left(attributes.BRAND_NAME,50)#<hr>
						<cf_get_lang dictionary_id='58225.Model'>:#attributes.model_name#<hr>
					</td>
					<td valign="top">
						<cf_get_lang dictionary_id='57434.Rapor'> <cf_get_lang dictionary_id='58577.Sıra'>:<cfif attributes.report_sort eq 1><cf_get_lang dictionary_id='30010.Ciro'><cfelseif attributes.report_sort eq 2><cf_get_lang dictionary_id='57635.Miktar'><cfelse><cf_get_lang dictionary_id ='39553.Kar'></cfif><hr>
						<cf_get_lang dictionary_id='30011.Satın Alan'>:#attributes.employee#<hr />
						<cf_get_lang dictionary_id='58516.Ödeme Yöntemi'>:#attributes.payment_type#<hr />
						<cf_get_lang dictionary_id='29500.Sevk Yöntemi'>:#attributes.ship_method_name#<hr />
					</td>
					</cfoutput>
				</tr>
			</table>
		</cfif>
	</cf_report_list_search_area>
</cf_report_list_search>


<!---<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
    <cfset filename = "#createuuid()#">
    <cfheader name="Expires" value="#Now()#">
    <cfcontent type="application/vnd.msexcel;charset=utf-8">
    <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</cfif>   --->

	<cfif isdefined("attributes.is_excel") and attributes.is_excel eq 1>
		<cfset type_ = 1>
	<cfelse>
		<cfset type_ = 0>
	</cfif> 
    	<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
        </cfif>
        <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
            <cf_seperator title="#getLang('main',388)#" id="transaction_type" is_closed="1">
            <table class="color-border" width="99%" cellpadding="2" cellspacing="1"  style="display:none;" id="transaction_type">
                <tr class="color-row">
                    <td valign="top" nowrap="nowrap">
                        <cfif len(attributes.process_type)>
                            <cfquery name="get_process_cat" datasource="#DSN3#">
                                SELECT PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID IN (#attributes.process_type#) AND PROCESS_TYPE IN (49,51,54,55,59,591,592,60,601,61,62,63,64,68,690,691) ORDER BY PROCESS_CAT
                            </cfquery>
                        <cfelse>
                            <cfset get_process_cat.recordcount = 0>
                        </cfif>
                        <cfif get_process_cat.recordcount>
                            <cfoutput query="get_process_cat">#process_cat#<br></cfoutput>
                        </cfif>
                    </td>
                    <td valign="top">
                        <cf_get_lang dictionary_id='1548.Rapor Tipi'>:
                        <cfif attributes.report_type eq 1><cf_get_lang dictionary_id='331.Kategori Bazında'>
                        <cfelseif attributes.report_type eq 2><cf_get_lang dictionary_id='332.Ürün Bazında'>
                        <cfelseif attributes.report_type eq 3><cf_get_lang dictionary_id='333.Stok Bazında'>
                        <cfelseif attributes.report_type eq 4><cf_get_lang dictionary_id='354.Cari Bazında'>
                        <cfelseif attributes.report_type eq 5><cf_get_lang dictionary_id='964.Belge ve Stok Bazında'>
                        <cfelseif attributes.report_type eq 6><cf_get_lang dictionary_id='374.Marka Bazında'>
                        <cfelseif attributes.report_type eq 7><cf_get_lang dictionary_id='2022.Proje Bazında'>
                        <cfelseif attributes.report_type eq 8><cf_get_lang dictionary_id='653.Ödeme Yöntemi Bazında'>
                        <cfelseif attributes.report_type eq 9><cf_get_lang dictionary_id='975.Ürün Sorumlusu Bazında'>
                        <cfelseif attributes.report_type eq 10><cf_get_lang dictionary_id='629.Şube Bazında'>
                        <cfelseif attributes.report_type eq 11><cf_get_lang dictionary_id='1835. Ana Kategori'><cf_get_lang dictionary_id='1189.Bazında'>
                        <cfelseif attributes.report_type eq 12><cf_get_lang dictionary_id="1353.Ürün Grubu"><cf_get_lang dictionary_id='1189.Bazında'>
                        </cfif><hr>
                        <cf_get_lang dictionary_id='74.Kategori'>:<cfoutput>#attributes.product_cat#</cfoutput><hr>
                        <cf_get_lang dictionary_id='107.Cari Hesap'>:<cfoutput>#attributes.company#</cfoutput><hr>
                        <cf_get_lang dictionary_id='4.Proje'>:<cfoutput>#attributes.project_head#</cfoutput><hr>
                    </td>
                    <cfoutput>
                    <td valign="top">
                        <cf_get_lang dictionary_id='330.Tarih'>:#dateformat(attributes.date1,dateformat_style)#-#dateformat(attributes.date2,dateformat_style)#<hr>
                        <cf_get_lang dictionary_id='245.Ürün'>:#attributes.product_name#<hr>
                        <cf_get_lang dictionary_id='1036.Ürün Sorumlu'>:#attributes.employee_name#<hr>
                        <cf_get_lang dictionary_id='1435.Marka'>:#left(attributes.BRAND_NAME,50)#<hr>
                        <cf_get_lang dictionary_id='813.Model'>:<cfoutput>#attributes.model_name#</cfoutput><hr>
                    </td>
                    <td valign="top">
                        <cf_get_lang dictionary_id='22.Rapor'> <cf_get_lang dictionary_id='1165.Sıra'>:<cfif attributes.report_sort eq 1><cf_get_lang dictionary_id='2213.Ciro'><cfelseif attributes.report_sort eq 2><cf_get_lang dictionary_id='223.Miktar'><cfelse><cf_get_lang dictionary_id ='832.Kar'></cfif><hr>
                        <cfoutput>
                        <cf_get_lang dictionary_id='2214.Satın Alan'>:#attributes.employee#<hr />
                        <cf_get_lang dictionary_id='1104.Ödeme Yöntemi'>:#attributes.payment_type#<hr />
                        <cf_get_lang dictionary_id='1703.Sevk Yöntemi'>:#attributes.ship_method_name#<hr />
                        </cfoutput>
                    </td>
                    </cfoutput>
                </tr>
            </table> 
		</cfif>
<div id="purchase_list">
<cfif isdefined("attributes.form_submitted")>
	<cfif isdefined("attributes.is_excel") and  attributes.is_excel eq 1>
		<cfset attributes.startrow=1>
		<cfset attributes.max_rows=get_total_purchase.recordcount>
		<cfset type_ = 0>
	<cfelse>
		<cfset type_ = 0>
	</cfif>
	<cf_report_list>

		<cf_wrk_html_table class="basket_list" table="0" table_draw_type="#type_#" filename="report_purchase#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
			<cfparam name="attributes.page" default=1>
			<cfparam name="attributes.totalrecords" default="#get_total_purchase.recordcount#">
			<cfset attributes.startrow=((attributes.page-1)*attributes.max_rows)+1>
			<cfif get_total_purchase.recordcount>
				<cfif attributes.page neq 1>
					<cfoutput query="get_total_purchase"  startrow="1" maxrows="#attributes.startrow-1#">
						<cfset toplam_satis3=ISKONTO+toplam_satis3>
						<cfif attributes.is_money2 eq 1>
							<cfset toplam_satis2=ISKONTO_DOVIZ+toplam_satis2>
						</cfif>
						<cfset toplam_iskonto=ISKONTO+toplam_iskonto>
						<cfif attributes.is_money2 eq 1>
							<cfset toplam_iskonto2=ISKONTO_DOVIZ+toplam_iskonto2>
						</cfif>
						<cfif attributes.report_type eq 5>
							<cfif len(PRODUCT_STOCK)>
								<cfset unit_ = filterSpecialChars(birim)>
								<cfset 'toplam_#unit_#' = evaluate('toplam_#unit_#') + PRODUCT_STOCK>
							</cfif>
							<cfif len(PRODUCT_STOCK)>
								<cfset unit_ = filterSpecialChars(birim)>
								<cfset 'toplam_2_#unit_#' = evaluate('toplam_2_#unit_#') + PRODUCT_STOCK>
							</cfif>
							<cfset toplam_birim=BIRIM_FIYAT+toplam_birim>
						</cfif>
						<cfif attributes.report_type eq 1>
							<cfif len(PRODUCT_STOCK)>
								<cfset unit_ = filterSpecialChars(birim)>
								<cfset 'toplam_miktar_#unit_#' = evaluate('toplam_miktar_#unit_#') + PRODUCT_STOCK>
							</cfif>
							<cfif len(PRODUCT_STOCK2)>
								<cfset unit_ = filterSpecialChars(birim2)>
								<cfset 'toplam_miktar_2_#unit_#' = evaluate('toplam_miktar_2_#unit_#') + PRODUCT_STOCK2>
							</cfif>
						</cfif>
						<cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar>
						<cfset toplam_satis=PRICE+toplam_satis>
					</cfoutput>
				</cfif>
				<!--- Rapor tipi kategori bazında ise --->
				<cfif attributes.report_type eq 1 or attributes.report_type eq 11>
					
						<thead>
							<cf_wrk_html_tr>
								<cf_wrk_html_th width="25"><cf_get_lang dictionary_id='57487.No'></cf_wrk_html_th>
								<cf_wrk_html_th nowrap><cf_get_lang dictionary_id='39378.Kategori kodu'></cf_wrk_html_th>
								<cf_wrk_html_th width="300" height="22"><cf_get_lang dictionary_id='57486.Kategori'></cf_wrk_html_th>
								<cf_wrk_html_th width="200" style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></cf_wrk_html_th>
								<cf_wrk_html_th width="30"><cf_get_lang dictionary_id='57636.Birim'></cf_wrk_html_th>
								<cf_wrk_html_th width="200" style="text-align:right;"><cf_get_lang dictionary_id='40371.Miktar2'></cf_wrk_html_th>
								<cf_wrk_html_th width="50"><cf_get_lang dictionary_id='40391.Birim2'></cf_wrk_html_th>
								<cfif attributes.is_discount eq 1>
									<cf_wrk_html_th width="100" style="text-align:right;"><cf_get_lang dictionary_id='39697.İskonto Tutar'></cf_wrk_html_th>
									<cf_wrk_html_th width="50" style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></cf_wrk_html_th>
									<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
										<cf_wrk_html_th width="100" style="text-align:right;"><cf_get_lang dictionary_id='39698.İskonto Döviz'></cf_wrk_html_th>
										<cf_wrk_html_th width="50" style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></cf_wrk_html_th>
									</cfif>
								</cfif>
								<cf_wrk_html_th width="100" style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></cf_wrk_html_th>
								<cf_wrk_html_th width="50" style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></cf_wrk_html_th>
								<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
								<cf_wrk_html_th width="100" style="text-align:right;"><cf_get_lang dictionary_id='57677.Döviz'></cf_wrk_html_th>
								<cf_wrk_html_th width="50" style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></cf_wrk_html_th>
								</cfif>
								<cf_wrk_html_th width="35" style="text-align:right;">%</cf_wrk_html_th>
							</cf_wrk_html_tr>
						</thead>
						<tbody>
							<cfoutput query="get_total_purchase"  startrow="#attributes.startrow#" maxrows="#attributes.max_rows#">					
								<cfif attributes.is_money2 eq 1>
									<cfset toplam_satis2=PRICE_DOVIZ+toplam_satis2>
								</cfif>
								<cfset toplam_iskonto=ISKONTO+toplam_iskonto>
								<cfif attributes.is_money2 eq 1>
									<cfset toplam_iskonto2=ISKONTO_DOVIZ+toplam_iskonto2>
								</cfif>
								<cf_wrk_html_tr>
									<cf_wrk_html_td>#currentrow#</cf_wrk_html_td>
									<cf_wrk_html_td width="100">#HIERARCHY#</cf_wrk_html_td>
									<cf_wrk_html_td>#PRODUCT_CAT#</cf_wrk_html_td>
									<cf_wrk_html_td style="text-align:right;" format="numeric">
										#TLFormat(PRODUCT_STOCK,4)#
										<cfif len(PRODUCT_STOCK)>
											<cfset unit_ = filterSpecialChars(birim)>
											<cfset 'toplam_miktar_#unit_#' = evaluate('toplam_miktar_#unit_#') + PRODUCT_STOCK>
										</cfif>
									</cf_wrk_html_td>
									<cf_wrk_html_td style="text-align:center;">#BIRIM#</cf_wrk_html_td>
									<cf_wrk_html_td style="text-align:right;" format="numeric">
										#TLFormat(PRODUCT_STOCK2,4)#
										<cfif len(PRODUCT_STOCK2) and len(BIRIM2)>
											<cfset unit_ = filterSpecialChars(birim2)>
											<cfset 'toplam_miktar_2_#unit_#' = evaluate('toplam_miktar_2_#unit_#') + PRODUCT_STOCK2>
										</cfif>
									</cf_wrk_html_td>	
									<cf_wrk_html_td style="text-align:center;">
										#BIRIM2#
									</cf_wrk_html_td>
									<cfif attributes.is_discount eq 1>
										<cf_wrk_html_td style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(ISKONTO)#<cfelse>#TLFormat(ISKONTO,5)#</cfif></cf_wrk_html_td>
										<cf_wrk_html_td width="60" style="text-align:center;">#SESSION.EP.MONEY#</cf_wrk_html_td>
										<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
											<cf_wrk_html_td style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(ISKONTO_DOVIZ)#<cfelse>#TLFormat(ISKONTO_DOVIZ,5)#</cfif></cf_wrk_html_td>
											<cf_wrk_html_td width="60" style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></cf_wrk_html_td>
										</cfif>
									</cfif>
									<cf_wrk_html_td style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(PRICE)#<cfelse>#TLFormat(PRICE,5)#</cfif></cf_wrk_html_td>
									<cfset toplam_satis=PRICE+toplam_satis>
									<cf_wrk_html_td style="text-align:center;">#SESSION.EP.MONEY#</cf_wrk_html_td>
									<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
										<cf_wrk_html_td style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(PRICE_DOVIZ)#<cfelse>#TLFormat(PRICE_DOVIZ,5)#</cfif></cf_wrk_html_td>
										<cf_wrk_html_td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></cf_wrk_html_td>
									</cfif>
									<cf_wrk_html_td style="text-align:right; mso-number-format:'\@';" format="text"><cfif len(butun_toplam) and butun_toplam neq 0 and len(PRICE)>#NumberFormat(Evaluate(100*PRICE/butun_toplam),"00.00")#<cfelse>00.00</cfif></cf_wrk_html_td>
								</cf_wrk_html_tr>
							</cfoutput>
						</tbody>
						<tfoot>
							<cfoutput>
								<cf_wrk_html_tr>
									<cf_wrk_html_td colspan="3" class="formbold" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></cf_wrk_html_td>
									<cf_wrk_html_td class="formbold" style="text-align:right;" <!--- format="numeric" --->>
										<cfloop query="get_product_units">
											<cfset unit_ = filterSpecialChars(get_product_units.unit)>
											<cfif evaluate('toplam_miktar_#unit_#') gt 0>
												<cfif x_five_digit eq 0>
													#Tlformat(evaluate('toplam_miktar_#unit_#'))#<br/>
												<cfelse>
													#Tlformat(evaluate('toplam_miktar_#unit_#'),5)#<br/>
												</cfif>
											</cfif>
										</cfloop>
									</cf_wrk_html_td>
									<cf_wrk_html_td style="text-align:center;" class="formbold">
										<cfloop query="get_product_units">
											<cfset unit_ = filterSpecialChars(get_product_units.unit)>
											<cfif evaluate('toplam_miktar_#unit_#') gt 0>
												#get_product_units.unit#<br/>
											</cfif>
										</cfloop>
									</cf_wrk_html_td>
									<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric">
										<cfloop query="get_product_units">
											<cfset unit_ = filterSpecialChars(get_product_units.unit)>
											<cfif evaluate('toplam_miktar_2_#unit_#') gt 0>
												#Tlformat(evaluate('toplam_miktar_2_#unit_#'),4)#<br/>
											</cfif>
										</cfloop>
									</cf_wrk_html_td>
									<cf_wrk_html_td style="text-align:center;" class="formbold">
										<cfloop query="get_product_units">
											<cfset unit_ = filterSpecialChars(get_product_units.unit)>
											<cfif evaluate('toplam_miktar_2_#unit_#') gt 0>
												#get_product_units.unit#<br/>
											</cfif>
										</cfloop>
									</cf_wrk_html_td>
									<cfif attributes.is_discount eq 1>
										<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(toplam_iskonto)#<cfelse>#TLFormat(toplam_iskonto,5)#</cfif></cf_wrk_html_td>
										<cf_wrk_html_td style="text-align:center;" class="formbold">#SESSION.EP.MONEY#</cf_wrk_html_td>
										<cfif attributes.is_money2 eq 1>
											<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(toplam_iskonto2)#<cfelse>#TLFormat(toplam_iskonto2,5)#</cfif></cf_wrk_html_td>
											<cf_wrk_html_td style="text-align:center;" class="formbold">#SESSION.EP.MONEY2#</cf_wrk_html_td>
										<cfelseif attributes.is_other_money eq 1>
											<cf_wrk_html_td></cf_wrk_html_td>
											<cf_wrk_html_td style="text-align:center;" class="formbold"></cf_wrk_html_td>
										</cfif>
									</cfif>
									<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(toplam_satis)#<cfelse>#TLFormat(toplam_satis,5)#</cfif></cf_wrk_html_td>
									<cf_wrk_html_td style="text-align:center;" class="formbold">#SESSION.EP.MONEY#</cf_wrk_html_td>
									<cfif attributes.is_money2 eq 1>
										<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(toplam_satis2)#<cfelse>#TLFormat(toplam_satis2,5)#</cfif></cf_wrk_html_td>
										<cf_wrk_html_td style="text-align:center;" class="formbold">#SESSION.EP.MONEY2#</cf_wrk_html_td>
									</cfif>
									<cfif attributes.is_other_money eq 1>
										<cf_wrk_html_td></cf_wrk_html_td>
										<cf_wrk_html_td style="text-align:center;" class="formbold"></cf_wrk_html_td>
									</cfif>
									<cf_wrk_html_td></cf_wrk_html_td>
								</cf_wrk_html_tr>
							</cfoutput>
						</tfoot>
					
				<!--- Rapor tipi kategori bazında ise --->
				<cfelseif attributes.report_type eq 10>
					
						<thead>
							<cf_wrk_html_tr>
								<cf_wrk_html_th width="25"><cf_get_lang dictionary_id='57487.No'></cf_wrk_html_th>
								<cf_wrk_html_th><cf_get_lang dictionary_id='57453.Şube'></cf_wrk_html_th>
								<cf_wrk_html_th width="100" style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></cf_wrk_html_th>
								<cfif attributes.is_discount eq 1>
									<cf_wrk_html_th width="100" style="text-align:right;"><cf_get_lang dictionary_id='39697.İskonto Tutar'></cf_wrk_html_th>
									<cf_wrk_html_th style="text-align:center;" width="50"><cf_get_lang dictionary_id='58474.Birim'></cf_wrk_html_th>
									<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
										<cf_wrk_html_th width="100" style="text-align:right;"><cf_get_lang dictionary_id='39698.İskonto Döviz'></cf_wrk_html_th>
										<cf_wrk_html_th style="text-align:center;" width="50"><cf_get_lang dictionary_id='58474.Birim'></cf_wrk_html_th>
									</cfif>
								</cfif>
								<cf_wrk_html_th width="100" style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></cf_wrk_html_th>
								<cf_wrk_html_th style="text-align:center;" width="50"><cf_get_lang dictionary_id='58474.Birim'></cf_wrk_html_th>
								<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
								<cf_wrk_html_th width="100" style="text-align:right;"><cf_get_lang dictionary_id='57677.Döviz'></cf_wrk_html_th>
								<cf_wrk_html_th style="text-align:center;" width="50"><cf_get_lang dictionary_id='58474.Birim'></cf_wrk_html_th>
								</cfif>
								<cf_wrk_html_th width="35" style="text-align:right;">%</cf_wrk_html_th>
							</cf_wrk_html_tr>
						</thead>
						<tbody>
							<cfoutput query="get_total_purchase"  startrow="#attributes.startrow#" maxrows="#attributes.max_rows#">
								<cfset toplam_satis=PRICE+toplam_satis>
								<cfif attributes.is_money2 eq 1>
									<cfset toplam_satis2=PRICE_DOVIZ+toplam_satis2>
								</cfif>
								<cfset toplam_iskonto=ISKONTO+toplam_iskonto>
								<cfif attributes.is_money2 eq 1>
									<cfset toplam_iskonto2=ISKONTO_DOVIZ+toplam_iskonto2>
								</cfif>
								<cf_wrk_html_tr>
									<cf_wrk_html_td>#currentrow#</cf_wrk_html_td>
									<cf_wrk_html_td>#BRANCH_NAME#</cf_wrk_html_td>
									<cf_wrk_html_td style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(product_stock,4)#<cfelse>#TLFormat(product_stock,5)#</cfif>
									<cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar>
									</cf_wrk_html_td>
									<cfif attributes.is_discount eq 1>
										<cf_wrk_html_td style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(ISKONTO)#<cfelse>#TLFormat(ISKONTO,5)#</cfif></cf_wrk_html_td>
										<cf_wrk_html_td style="text-align:center;" width="60">#SESSION.EP.MONEY#</cf_wrk_html_td>
										<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
											<cf_wrk_html_td style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(ISKONTO_DOVIZ)#<cfelse>#TLFormat(ISKONTO_DOVIZ,5)#</cfif></cf_wrk_html_td>
											<cf_wrk_html_td style="text-align:center;" width="60"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></cf_wrk_html_td>
										</cfif>
									</cfif>
									<cf_wrk_html_td style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(PRICE)#<cfelse>#TLFormat(PRICE,5)#</cfif></cf_wrk_html_td>
									<cf_wrk_html_td style="text-align:center;">#SESSION.EP.MONEY#</cf_wrk_html_td>
									<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
										<cf_wrk_html_td style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(PRICE_DOVIZ)#<cfelse>#TLFormat(PRICE_DOVIZ,5)#</cfif></cf_wrk_html_td>
										<cf_wrk_html_td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></cf_wrk_html_td>
									</cfif>
									<cf_wrk_html_td style="text-align:right; mso-number-format:'\@';" format="text"><cfif len(butun_toplam) and butun_toplam neq 0 and len(PRICE)>#NumberFormat(Evaluate(100*PRICE/butun_toplam),"00.00")#<cfelse>00.00</cfif></td>
								</cf_wrk_html_tr>
							</cfoutput>
						</tbody>
						<tfoot>
							<cfoutput>
								<cf_wrk_html_tr>
									<cf_wrk_html_td colspan="2" class="formbold" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></cf_wrk_html_td>
									<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif toplam_miktar gt 0><cfif x_five_digit eq 0>#TLFormat(toplam_miktar)#<cfelse>#TLFormat(toplam_miktar,5)#</cfif></cfif></cf_wrk_html_td> 
									<cfif attributes.is_discount eq 1>
										<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(toplam_iskonto)#<cfelse>#TLFormat(toplam_iskonto,5)#</cfif></cf_wrk_html_td>
										<cf_wrk_html_td class="formbold" style="text-align:center;">#SESSION.EP.MONEY#</cf_wrk_html_td>
										<cfif attributes.is_money2 eq 1>
											<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(toplam_iskonto2)#<cfelse>#TLFormat(toplam_iskonto2,5)#</cfif></cf_wrk_html_td>
											<cf_wrk_html_td style="text-align:center;" class="formbold">#SESSION.EP.MONEY2#</cf_wrk_html_td>
										<cfelseif attributes.is_other_money eq 1>
											<cf_wrk_html_td></cf_wrk_html_td>
											<cf_wrk_html_td style="text-align:center;" class="formbold"></cf_wrk_html_td>
										</cfif>
									</cfif>
									<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(toplam_satis)#<cfelse>#TLFormat(toplam_satis,5)#</cfif></cf_wrk_html_td>
									<cf_wrk_html_td style="text-align:center;" class="formbold">#SESSION.EP.MONEY#</cf_wrk_html_td>
									<cfif attributes.is_money2 eq 1>
										<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(toplam_satis2)#<cfelse>#TLFormat(toplam_satis2,5)#</cfif></cf_wrk_html_td>
										<cf_wrk_html_td style="text-align:center;" class="formbold">#SESSION.EP.MONEY2#</cf_wrk_html_td>
									</cfif>
									<cfif attributes.is_other_money eq 1>
										<cf_wrk_html_td></cf_wrk_html_td>
										<cf_wrk_html_td style="text-align:center;" class="formbold"></cf_wrk_html_td>
									</cfif>
									<td></td>
								</cf_wrk_html_tr>
							</cfoutput>
						</tfoot>  
					
				<cfelseif attributes.report_type eq 4>
					
						<thead>
							<cf_wrk_html_tr>
								<cf_wrk_html_th width="25"><cf_get_lang dictionary_id='57487.No'></cf_wrk_html_th>
								<cf_wrk_html_th height="22"><cf_get_lang dictionary_id='58607.Firma'></cf_wrk_html_th>
								<cfif attributes.taxno eq 1>
									<cf_wrk_html_th>
										<cf_get_lang dictionary_id='58762.Vergi Dairesi'>
									</cf_wrk_html_th>
									<cf_wrk_html_th>
										<cf_get_lang dictionary_id='57752.Vergi No'>
									</cf_wrk_html_th>
								</cfif>
								<cfif attributes.invoice_count eq 1>
									<cf_wrk_html_th style="text-align:right;"><cf_get_lang dictionary_id ='40025.İşlem Sayısı'></cf_wrk_html_th>
								</cfif>
								<cf_wrk_html_th style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></cf_wrk_html_th>
								<cfif attributes.is_discount eq 1>
									<cf_wrk_html_th width="150" style="text-align:right;"><cf_get_lang dictionary_id='39697.İskonto Tutar'></cf_wrk_html_th>
									<cf_wrk_html_th width="30"><cf_get_lang dictionary_id='58474.Birim'></cf_wrk_html_th>
									<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
										<cf_wrk_html_th width="150" style="text-align:right;"><cf_get_lang dictionary_id='39698.İskonto Döviz'></cf_wrk_html_th>
										<cf_wrk_html_th width="30"><cf_get_lang dictionary_id='58474.Birim'></cf_wrk_html_th>
									</cfif>
								</cfif>
								<cf_wrk_html_th width="150" style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></cf_wrk_html_th>
								<cf_wrk_html_th width="30"><cf_get_lang dictionary_id='58474.Birim'></cf_wrk_html_th>
								<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
									<cf_wrk_html_th width="150" style="text-align:right;"><cf_get_lang dictionary_id='57677.Döviz'></cf_wrk_html_th>
									<cf_wrk_html_th width="30"><cf_get_lang dictionary_id='58474.Birim'></cf_wrk_html_th>
								</cfif>
								<cf_wrk_html_th width="35" style="text-align:right;">%</cf_wrk_html_th>
							</cf_wrk_html_tr>
						</thead>
						<tbody>
							<cfoutput query="get_total_purchase"  startrow="#attributes.startrow#" maxrows="#attributes.max_rows#">
								<cfset toplam_satis=PRICE+toplam_satis>
								<cfif attributes.is_money2 eq 1>
									<cfset toplam_satis2=PRICE_DOVIZ+toplam_satis2>
								</cfif>
								<cfset toplam_iskonto=ISKONTO+toplam_iskonto>
								<cfif attributes.is_money2 eq 1>
									<cfset toplam_iskonto2=ISKONTO_DOVIZ+toplam_iskonto2>
								</cfif>
								<cf_wrk_html_tr>
									<cf_wrk_html_td>#currentrow#</cf_wrk_html_td>
									<cf_wrk_html_td>
										<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1 >
										#NICKNAME#
										<cfelse>
											<cfif type eq 1>
												<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#COMPANY_ID#','list');">#NICKNAME#</a>
											<cfelseif type eq 2>
												<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#COMPANY_ID#','list');">#NICKNAME#</a>
											</cfif>
										</cfif>
									</cf_wrk_html_td>
									<cfif attributes.taxno eq 1>
										<cf_wrk_html_td>#taxoffice#</cf_wrk_html_td>
										<cf_wrk_html_td>#taxno#</cf_wrk_html_td>
									</cfif>
									<cfif isdefined('attributes.invoice_count') and attributes.invoice_count eq 1>
										<cf_wrk_html_td style="text-align:center;">
											<cfif type eq 1>
												<cfquery name="get_islem" dbtype="query">
													SELECT ISLEM_SAYISI FROM get_count WHERE COMPANY_ID = #get_total_purchase.company_id# 
												</cfquery>
											<cfelseif type eq 2>
												<cfquery name="get_islem" dbtype="query">
													SELECT ISLEM_SAYISI FROM get_count_ WHERE CONSUMER_ID = #get_total_purchase.company_id# 
												</cfquery>
											</cfif>
											#get_islem.islem_sayisi#
										</cf_wrk_html_td>
									</cfif>
									<cf_wrk_html_td style="text-align:right;" format="numeric">
										<cfif x_five_digit eq 0>#TLFormat(product_stock,4)#<cfelse>#TLFormat(product_stock,5)#</cfif>
										<cfset toplam_miktar=product_stock+toplam_miktar>
									</cf_wrk_html_td>
									<cfif attributes.is_discount eq 1>
										<cf_wrk_html_td style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(ISKONTO)#<cfelse>#TLFormat(ISKONTO,5)#</cfif></cf_wrk_html_td>
										<cf_wrk_html_td style="text-align:center;">#SESSION.EP.MONEY#</cf_wrk_html_td>
										<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
											<cf_wrk_html_td style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(ISKONTO_DOVIZ)#<cfelse>#TLFormat(ISKONTO_DOVIZ,5)#</cfif></cf_wrk_html_td>
											<cf_wrk_html_td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></cf_wrk_html_td>
										</cfif>
									</cfif>
									<cf_wrk_html_td style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(PRICE)#<cfelse>#TLFormat(PRICE,5)#</cfif></cf_wrk_html_td>
									<cf_wrk_html_td style="text-align:center;">#SESSION.EP.MONEY#</cf_wrk_html_td>
									<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
										<cf_wrk_html_td style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(PRICE_DOVIZ)#<cfelse>#TLFormat(PRICE_DOVIZ,5)#</cfif></cf_wrk_html_td>
										<cf_wrk_html_td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></cf_wrk_html_td>
									</cfif>
									<cf_wrk_html_td style="text-align:right; mso-number-format:'\@';" format="text"><cfif len(butun_toplam) and butun_toplam neq 0 and len(PRICE)>#NumberFormat(Evaluate(100*PRICE/butun_toplam),"00.00")#<cfelse>00.00</cfif></cf_wrk_html_td>
								</cf_wrk_html_tr>
							</cfoutput>
						</tbody>
						<tfoot>
							<cfoutput>
								<cf_wrk_html_tr>
									<cfif attributes.invoice_count eq 1 and attributes.taxno eq 1>
										<cfset colspan_ = 5>
									<cfelseif attributes.invoice_count eq 1>
										<cfset colspan_= 3>
									<cfelseif attributes.taxno eq 1>
										<cfset colspan_= 4>
									<cfelseif attributes.invoice_count neq 1 and attributes.taxno neq 1>
										<cfset colspan_ = 2>
									</cfif>
									<cf_wrk_html_td class="formbold" colspan="#colspan_#" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></cf_wrk_html_td>
									<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric">
										<cfif toplam_miktar gt 0><cfif x_five_digit eq 0>#TLFormat(toplam_miktar)#<cfelse>#TLFormat(toplam_miktar,5)#</cfif></cfif>
									</cf_wrk_html_td>
									<cfif attributes.is_discount eq 1>
										<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(toplam_iskonto)#<cfelse>#TLFormat(toplam_iskonto,5)#</cfif></cf_wrk_html_td>
										<cf_wrk_html_td style="text-align:center;" class="formbold">#SESSION.EP.MONEY#</cf_wrk_html_td>
										<cfif attributes.is_money2 eq 1>
											<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(toplam_iskonto2)#<cfelse>#TLFormat(toplam_iskonto2,5)#</cfif></cf_wrk_html_td>
											<cf_wrk_html_td style="text-align:center;" class="formbold">#SESSION.EP.MONEY2#</cf_wrk_html_td>
										<cfelseif attributes.is_other_money eq 1>
											<cf_wrk_html_td></cf_wrk_html_td>
											<cf_wrk_html_td style="text-align:center;" class="formbold"></cf_wrk_html_td>
										</cfif>
									</cfif>
									<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(toplam_satis)#<cfelse>#TLFormat(toplam_satis,5)#</cfif></cf_wrk_html_td>
									<cf_wrk_html_td style="text-align:center;" class="formbold">#SESSION.EP.MONEY#</cf_wrk_html_td>
									<cfif attributes.is_money2 eq 1>
										<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(toplam_satis2)#<cfelse>#TLFormat(toplam_satis2,5)#</cfif></cf_wrk_html_td>
										<cf_wrk_html_td style="text-align:center;" class="formbold">#SESSION.EP.MONEY2#</cf_wrk_html_td>
									</cfif>
									<cfif attributes.is_other_money eq 1>
										<cf_wrk_html_td></cf_wrk_html_td>
										<cf_wrk_html_td style="text-align:center;" class="formbold"></cf_wrk_html_td>
									</cfif>
									<cf_wrk_html_td></cf_wrk_html_td>
								</cf_wrk_html_tr>
							</cfoutput>	
						</tfoot>
					
				<cfelseif get_total_purchase.recordcount and attributes.report_type eq 5>
					
						<thead>
							<cf_wrk_html_tr>
								<cf_wrk_html_th width="25"><cf_get_lang dictionary_id='57487.No'></cf_wrk_html_th>
								<cf_wrk_html_th><cf_get_lang dictionary_id='57637.Seri No'></cf_wrk_html_th>
								<cf_wrk_html_th><cf_get_lang dictionary_id='58133.Fatura No'></cf_wrk_html_th>
								<cf_wrk_html_th><cf_get_lang dictionary_id='58759.Fatura Tarihi'></cf_wrk_html_th>
								<cf_wrk_html_th><cf_get_lang dictionary_id='57881.Vade Tarihi'></cf_wrk_html_th>
								<cfif isdefined("x_show_invoice_detail") and x_show_invoice_detail eq 1>
									<cf_wrk_html_th><cf_get_lang dictionary_id='57629.açıklama'></cf_wrk_html_th>
								</cfif>
								<cf_wrk_html_th><cf_get_lang dictionary_id='58763.Depo'></cf_wrk_html_th>
								<cf_wrk_html_th><cf_get_lang dictionary_id='57457.Müşteri'></cf_wrk_html_th>
								<cfif isdefined("x_show_ozel_kod_3") and x_show_ozel_kod_3 eq 1>
									<cf_wrk_html_th class="txtbold"><cf_get_lang dictionary_id="30343.Özel Kod 3"></cf_wrk_html_th>
								</cfif>
								<cfif attributes.is_project eq 1>
									<cf_wrk_html_th width="75"><cf_get_lang dictionary_id ='57416.Proje'></cf_wrk_html_th>
								</cfif>
								<cf_wrk_html_th><cf_get_lang dictionary_id='58800.Ürün Kod'></cf_wrk_html_th>
								<cf_wrk_html_th nowrap><cf_get_lang dictionary_id="60278.Ürün Özel Kod"></cf_wrk_html_th>
								<cf_wrk_html_th><cf_get_lang dictionary_id='57634.Üretici Kodu'></cf_wrk_html_th>
								<cf_wrk_html_th><cf_get_lang dictionary_id='57657.Ürün'> </cf_wrk_html_th>
								<cfif attributes.is_spect_info eq 1>
									<cf_wrk_html_th><cf_get_lang dictionary_id='57647.Spec'></cf_wrk_html_th>
									<cf_wrk_html_th><cf_get_lang dictionary_id="57647.Spec"><cf_get_lang dictionary_id="58527.Id"></cf_wrk_html_th>
								</cfif>
								<cfif isdefined("x_show_lot_no") and x_show_lot_no eq 1>
									<cf_wrk_html_th class="txtbold"><cf_get_lang dictionary_id='32916.Lot no'></cf_wrk_html_th>
								</cfif>
								<cfif isdefined("x_show_barcode") and x_show_barcode eq 1>
									<cf_wrk_html_th class="txtbold"><cf_get_lang dictionary_id='57633.Barkod'></cf_wrk_html_th>
								</cfif>
								<cf_wrk_html_th style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></cf_wrk_html_th>
								<cf_wrk_html_th width="30"><cf_get_lang dictionary_id='57636.Birim'></cf_wrk_html_th>
								<cfif attributes.report_type eq 5 and isdefined("x_amount2") and x_amount2 eq 1><cf_wrk_html_th style="text-align:right;"><cf_get_lang dictionary_id='40371.Miktar2'></cf_wrk_html_th></cfif>
								<cfif attributes.report_type eq 5 and isdefined("x_unit2") and x_unit2 eq 1><cf_wrk_html_th width="50"><cf_get_lang dictionary_id='40391.Birim2'></cf_wrk_html_th></cfif>
								<cf_wrk_html_th width="100" style="text-align:right;"><cf_get_lang dictionary_id='57638.Birim Fiyat'></cf_wrk_html_th>
								<cfif isdefined("attributes.is_money_info")>
									<cf_wrk_html_th width="100" style="text-align:right;"><cf_get_lang dictionary_id='39411.Döviz Net Fiyat'></cf_wrk_html_th>
									<cf_wrk_html_th width="80" style="text-align:center;"><cf_get_lang dictionary_id='58121.İşlem Dövizi'></cf_wrk_html_th>
								</cfif>
							<cfif attributes.report_type eq 5 and isdefined("x_unit2") and x_net_price eq 1><th width="50"><cf_get_lang dictionary_id='38843.NetFiyat'></th></cfif>
								<cf_wrk_html_th width="30"><cf_get_lang dictionary_id='58474.Birim'></cf_wrk_html_th>                        
								<cfif attributes.is_discount eq 1>
									<cf_wrk_html_th width="120" style="text-align:right;"><cf_get_lang dictionary_id='39697.İskonto Tutar'></cf_wrk_html_th>
									<cf_wrk_html_th width="30"><cf_get_lang dictionary_id='58474.Birim'></cf_wrk_html_th>
									<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
										<cf_wrk_html_th width="120" style="text-align:right;"><cf_get_lang dictionary_id='39698.İskonto Döviz'></cf_wrk_html_th>
									<cf_wrk_html_th width="30"><cf_get_lang dictionary_id='58474.Birim'></cf_wrk_html_th>
									</cfif>
								</cfif>
								<cf_wrk_html_th width="120" style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></cf_wrk_html_th>
								<cf_wrk_html_th width="30"><cf_get_lang dictionary_id='58474.Birim'></cf_wrk_html_th>
								<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
								<cf_wrk_html_th width="75" style="text-align:right;"><cf_get_lang dictionary_id='57677.Döviz'></cf_wrk_html_th>
								<cf_wrk_html_th width="30"><cf_get_lang dictionary_id='58474.Birim'></cf_wrk_html_th>
								</cfif>
								<cfif attributes.cost_price eq 1 or attributes.cost_price eq 1>
									<cf_wrk_html_th width="75" style="text-align:right;"><cf_get_lang dictionary_id ='40023.Ek Maliyet'></cf_wrk_html_th>
								</cfif>
								<cf_wrk_html_th width="35" style="text-align:right;">%</cf_wrk_html_th>
							</cf_wrk_html_tr>
						</thead>
						<tbody>
							<cfset department_name_list = "">
							<cfset department_location_list = "">
							<cfoutput query="get_total_purchase">
								<cfif len(department_id) and not listfind(department_name_list,department_id)>
									<cfset department_name_list=listappend(department_name_list,department_id)>
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
										B.COMPANY_ID = #session.ep.company_id# AND
										B.BRANCH_ID = D.BRANCH_ID AND
										D.IS_STORE <> 2 AND
										B.BRANCH_ID IN(SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
									ORDER BY
										D.DEPARTMENT_ID
								</cfquery>
								<cfset department_name_list = listsort(listdeleteduplicates(valuelist(get_departman_name.department_id,',')),'numeric','ASC',',')>
							</cfif>
							<cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.max_rows#">
							<cfset toplam_satis=PRICE+toplam_satis>
							<cfif attributes.is_money2 eq 1>
								<cfset toplam_satis2=PRICE_DOVIZ+toplam_satis2>
							</cfif>
							<cfset toplam_iskonto=ISKONTO+toplam_iskonto>
							<cfif attributes.is_money2 eq 1>
								<cfset toplam_iskonto2=ISKONTO_DOVIZ+toplam_iskonto2>
							</cfif>				
							<cf_wrk_html_tr>
								<cf_wrk_html_td>#currentrow#</cf_wrk_html_td>
								<cf_wrk_html_td>
									<cfset fuse_type = 'invoice'>
									<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
										#serial_number#
									<cfelse>
										<cfif purchase_sales eq 1>
											<a href="#request.self#?fuseaction=#fuse_type#.form_add_bill&event=upd&iid=#invoice_id#" target="_blank" class="tableyazi">#serial_number#</a>
										<cfelseif purchase_sales eq 0>
											<a href="#request.self#?fuseaction=#fuse_type#.form_add_bill_purchase&event=upd&iid=#invoice_id#" target="_blank" class="tableyazi">#serial_number#</a>
										</cfif>
									</cfif>
								</cf_wrk_html_td>
								<cf_wrk_html_td>
									<cfset fuse_type = 'invoice'>
									<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
										#serial_no#
									<cfelse>
										<cfif purchase_sales eq 1>
											<a href="#request.self#?fuseaction=#fuse_type#.form_add_bill&event=upd&iid=#invoice_id#" target="_blank" class="tableyazi">#serial_no#</a>
										<cfelseif purchase_sales eq 0>
											<a href="#request.self#?fuseaction=#fuse_type#.form_add_bill_purchase&event=upd&iid=#invoice_id#" target="_blank" class="tableyazi">#serial_no#</a>
										</cfif>
									</cfif>
								</cf_wrk_html_td>
								<cf_wrk_html_td format="date">#dateformat(INVOICE_DATE,dateformat_style)#</cf_wrk_html_td>
								<cf_wrk_html_td format="date"><cfif len(due_date) and due_date gt 0>#dateformat(date_add('d',due_date,INVOICE_DATE),dateformat_style)#<cfelseif len(inv_due_date)>#dateformat(inv_due_date,dateformat_style)#<cfelse>#dateformat(INVOICE_DATE,dateformat_style)#</cfif></cf_wrk_html_td>
								<cfif isdefined("x_show_invoice_detail") and x_show_invoice_detail eq 1>
									<cf_wrk_html_td width="150">#note#</cf_wrk_html_td>
								</cfif>
								<cf_wrk_html_td><cfif len(department_id) and  isdefined("department_location") and len(department_location)>
									<cfquery name="get_lokasyon_name" datasource="#dsn#">
										SELECT COMMENT FROM STOCKS_LOCATION WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#department_id#"> AND LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#department_location#">
									</cfquery>
									#get_departman_name.department_head[listfind(department_name_list,department_id,',')]#- #get_lokasyon_name.comment#
									</cfif>
								</cf_wrk_html_td>
								<cf_wrk_html_td>
								<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1 >
									#MUSTERI#
								<cfelse>
									<cfif type eq 1>
										<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#COMPANY_ID#','list');">#MUSTERI#</a>
									<cfelseif type eq 2>
										<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#COMPANY_ID#','list');">#MUSTERI#</a>
									</cfif>
								</cfif>
								</cf_wrk_html_td>
								<cfif isdefined("x_show_ozel_kod_3") and x_show_ozel_kod_3 eq 1>
									<cf_wrk_html_td style="mso-number-format:\@;">#OZEL_KOD_2#</cf_wrk_html_td>
								</cfif>
								<cfif attributes.is_project eq 1>
									<cf_wrk_html_td>
										<cfif len(get_total_purchase.row_project_id) and listfind(project_id_list,get_total_purchase.row_project_id,',')>
											<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
												#get_project.project_head[listfind(project_id_list,get_total_purchase.row_project_id,',')]#
											<cfelse>
												<a href="#request.self#?fuseaction=project.projects&event=det&id=#row_project_id#" class="tableyazi">#get_project.project_head[listfind(project_id_list,get_total_purchase.row_project_id,',')]#</a>
											</cfif>
										<cfelseif len(get_total_purchase.project_id) and listfind(project_id_list,get_total_purchase.project_id,',')>
											<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
												#get_project.project_head[listfind(project_id_list,get_total_purchase.project_id,',')]#
											<cfelse>
												<a href="#request.self#?fuseaction=project.projects&event=det&id=#project_id#" class="tableyazi">#get_project.project_head[listfind(project_id_list,get_total_purchase.project_id,',')]#</a>
											</cfif>
										</cfif>  
									</cf_wrk_html_td>
								</cfif>
								<cf_wrk_html_td>#PRODUCT_CODE#</cf_wrk_html_td>
								<cf_wrk_html_td>#PRODUCT_CODE_2#</cf_wrk_html_td>
								<cf_wrk_html_td>#MANUFACT_CODE#</cf_wrk_html_td>
								<cf_wrk_html_td>
								<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1 >
									#PRODUCT_NAME#
								<cfelse>
									<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#PRODUCT_ID#','list');">
									#PRODUCT_NAME#
									</a>
								</cfif>
								</cf_wrk_html_td>
								<cfif attributes.is_spect_info eq 1>
									<cf_wrk_html_td>#spect_var_name#</cf_wrk_html_td>
									<cf_wrk_html_td>#spect_main_id#</cf_wrk_html_td>
								</cfif>
								<cfif isdefined("x_show_lot_no") and x_show_lot_no eq 1>
									<cf_wrk_html_td style="mso-number-format:\@;">#LOT_NO#</cf_wrk_html_td>
								</cfif>
								<cfif isdefined("x_show_barcode") and x_show_barcode eq 1>
									<cf_wrk_html_td style="mso-number-format:\@;">#BARCOD#</cf_wrk_html_td>
								</cfif>
								<cf_wrk_html_td style="text-align:right;" format="numeric">
									#TLFormat(PRODUCT_STOCK,4)#
									<cfif len(PRODUCT_STOCK)>
										<cfset unit_ = filterSpecialChars(birim)>
										<cfset 'toplam_#unit_#' = evaluate('toplam_#unit_#') + PRODUCT_STOCK>
									</cfif>
								</cf_wrk_html_td>
								<cf_wrk_html_td style="text-align:center;">#BIRIM#</cf_wrk_html_td>
								<cfif attributes.report_type eq 5 and isdefined("x_amount2") and x_amount2 eq 1>
									<cf_wrk_html_td style="text-align:right;" format="numeric">
										#TLFormat(PRODUCT_STOCK2,4)#
										<cfif len(PRODUCT_STOCK2) and len(birim2)>
											<cfset unit_ = filterSpecialChars(birim2)>
											<cfset 'toplam_2_#unit_#' = evaluate('toplam_2_#unit_#') + PRODUCT_STOCK2>
										</cfif>	
									</cf_wrk_html_td>	
								</cfif>
								<cfif attributes.report_type eq 5 and isdefined("x_unit2") and x_unit2 eq 1><cf_wrk_html_td style="text-align:center;">#BIRIM2#</cf_wrk_html_td></cfif>
								<cf_wrk_html_td style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(BIRIM_FIYAT)#<cfelse>#TLFormat(BIRIM_FIYAT,5)#</cfif></cf_wrk_html_td>
								<cfif isdefined("attributes.is_money_info")>
									<cfset "toplam_#other_money#" = evaluate("toplam_#other_money#") + other_money_value>
									<cf_wrk_html_td style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#tlformat(other_money_value)#<cfelse>#tlformat(other_money_value,5)#</cfif></cf_wrk_html_td>
									<cf_wrk_html_td style="text-align:center;">#other_money#</cf_wrk_html_td>
								</cfif>
								<cfif attributes.report_type eq 5 and isdefined("x_net_price") and x_net_price eq 1 and product_stock neq 0><td style="text-align:right;">#TLFormat(NET_TOTAL/PRODUCT_STOCK,4)#</td></cfif>
								<cf_wrk_html_td style="text-align:center;">#SESSION.EP.MONEY#</cf_wrk_html_td>
								<cfset toplam_birim=BIRIM_FIYAT+toplam_birim>
								<cfif attributes.is_discount eq 1>
									<cf_wrk_html_td style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(ISKONTO)#<cfelse>#TLFormat(ISKONTO,5)#</cfif></cf_wrk_html_td>
									<cf_wrk_html_td style="text-align:center;">#SESSION.EP.MONEY#</cf_wrk_html_td>
									<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
										<cf_wrk_html_td style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(ISKONTO_DOVIZ)#<cfelse>#TLFormat(ISKONTO_DOVIZ,5)#</cfif></cf_wrk_html_td>
										<cf_wrk_html_td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></cf_wrk_html_td>
									</cfif>
								</cfif>
								<cf_wrk_html_td style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(PRICE)#<cfelse>#TLFormat(PRICE,5)#</cfif></cf_wrk_html_td>
								<cf_wrk_html_td style="text-align:center;">#SESSION.EP.MONEY#</cf_wrk_html_td>
								<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
									<cf_wrk_html_td style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(PRICE_DOVIZ)#<cfelse>#TLFormat(PRICE_DOVIZ,5)#</cfif></cf_wrk_html_td>
									<cf_wrk_html_td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></cf_wrk_html_td>
								</cfif>
								<cfif attributes.cost_price eq 1 or attributes.cost_price eq 1>
									<cfif len(cost_price)>
										<cf_wrk_html_td style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(cost_price)#<cfelse>#TLFormat(wrk_round(cost_price,5,1),5)#</cfif></cf_wrk_html_td>
										<cfset toplam_maliyet=cost_price+toplam_maliyet>
									<cfelse>
										<cf_wrk_html_td style="text-align:right;" format="numeric">#TLFormat(0)#</cf_wrk_html_td>
									</cfif>
								</cfif>
								<cf_wrk_html_td style="text-align:right; mso-number-format:'\@';" format="text"><cfif len(butun_toplam) and butun_toplam neq 0 and len(PRICE)>#NumberFormat(Evaluate(100*PRICE/butun_toplam),"00.00")#<cfelse>00.00</cfif></cf_wrk_html_td>
							</cf_wrk_html_tr>
							</cfoutput> 
						</tbody>
						<tfoot>
							<cfoutput>
								<cf_wrk_html_tr>
										<cfif (isdefined("x_show_invoice_detail") and x_show_invoice_detail eq 1) and attributes.is_project eq 1 and attributes.is_spect_info eq 1>
											<cfset colspan_ = 14>
										<cfelseif (isdefined("x_show_invoice_detail") and x_show_invoice_detail eq 1) and attributes.is_spect_info eq 1>
											<cfset colspan_ = 13>
										<cfelseif (isdefined("x_show_invoice_detail") and x_show_invoice_detail eq 1) and attributes.is_project eq 1>
											<cfset colspan_ = 12>
										<cfelseif (isdefined("x_show_invoice_detail") and x_show_invoice_detail eq 1) or attributes.is_project eq 1>
											<cfset colspan_ = 11>
										<cfelseif (isdefined("x_show_invoice_detail") and x_show_invoice_detail neq 1) and attributes.is_spect_info eq 1>
											<cfset colspan_ = 12>                                   
										<cfelse>
											<cfset colspan_ = 10>
										</cfif>	
										<cfif attributes.report_type eq 5 and IsDefined("x_amount2") and x_amount2 eq 1>
											<cfset colspan_ = 13>                              
										</cfif>
										<cfif attributes.report_type eq 5 and IsDefined("x_unit2") and x_unit2 eq 1>
											<cfset colspan_ = 13>
										</cfif>
										<cfif attributes.report_type eq 5 and IsDefined("x_net_price") and x_net_price eq 1>
											<cfset colspan_ = 13>
										</cfif>   
										<cfif attributes.report_type eq 5 and IsDefined("x_show_lot_no") and x_show_lot_no eq 1>
											<cfset colspan_ = 14>
										</cfif>  
										<cfif attributes.report_type eq 5 and IsDefined("x_show_lot_no") and x_show_lot_no eq 1 and IsDefined("x_show_lot_no") and x_show_lot_no eq 1>
											<cfset colspan_ = 15>
										<cfelseif attributes.report_type eq 5 and IsDefined("x_show_lot_no") and x_show_lot_no eq 1>
											<cfset colspan_ = 14>
										</cfif>                                                 			
									<cf_wrk_html_td class="formbold" colspan="#colspan_#" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></cf_wrk_html_td>
									<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric">
										<cfloop query="get_product_units">
											<cfset unit_ = filterSpecialChars(get_product_units.unit)>
											<cfif evaluate('toplam_#unit_#') gt 0>
												<cfif x_five_digit eq 0>
													#Tlformat(evaluate('toplam_#unit_#'))#<br/>
												<cfelse>
													#Tlformat(evaluate('toplam_#unit_#'),5)#<br/>
												</cfif>
											</cfif>
										</cfloop>
									</cf_wrk_html_td>
									<cf_wrk_html_td style="text-align:center;" class="formbold">
										<cfloop query="get_product_units">
											<cfset unit_ = filterSpecialChars(get_product_units.unit)>
											<cfif evaluate('toplam_#unit_#') gt 0>
												#get_product_units.unit#<br/>
											</cfif>
										</cfloop>
									</cf_wrk_html_td>
									<cfif isdefined("x_amount2") and x_amount2 eq 1>
										<cf_wrk_html_td style="text-align:center;" class="formbold">
											<cfloop query="get_product_units">
												<cfset unit_ = filterSpecialChars(get_product_units.unit)>
												<cfif evaluate('toplam_2_#unit_#') gt 0>
													<cfif x_five_digit eq 0>
														#Tlformat(evaluate('toplam_2_#unit_#'))#<br/>
													<cfelse>
														#Tlformat(evaluate('toplam_2_#unit_#'),5)#<br/>
													</cfif>
												</cfif>
											</cfloop>
										</cf_wrk_html_td>
									</cfif>                            
									<cfif isdefined("x_unit2") and x_unit2 eq 1>
										<cf_wrk_html_td style="text-align:center;" class="formbold">
											<cfloop query="get_product_units">
												<cfset unit_ = filterSpecialChars(get_product_units.unit)>
												<cfif evaluate('toplam_2_#unit_#') gt 0>
													#get_product_units.unit#<br/>
												</cfif>
											</cfloop>
										</cf_wrk_html_td>
									</cfif> 
									<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(toplam_birim)#<cfelse>#TLFormat(toplam_birim,5)#</cfif></cf_wrk_html_td>
									<cfif isdefined("x_net_price") and x_net_price eq 1>
										<cf_wrk_html_td></cf_wrk_html_td>
									</cfif>
									<cfif isdefined("attributes.is_money_info")>
										<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric">
											<cfloop query="get_money">
												<cfif evaluate("toplam_#money#") gt 0>
													<cfif x_five_digit eq 0>#TLFormat(evaluate("toplam_#money#"))#<br/><cfelse>#TLFormat(evaluate("toplam_#money#"),5)#<br/></cfif>
												</cfif>
											</cfloop>
										</cf_wrk_html_td>
										<cf_wrk_html_td class="formbold" style="text-align:center;">
											<cfloop query="get_money">
												<cfif evaluate("toplam_#money#") gt 0>
													#money#<br/>
												</cfif>
											</cfloop>
										</cf_wrk_html_td>
									</cfif>
									<cf_wrk_html_td style="text-align:center;" class="formbold">#SESSION.EP.MONEY#</cf_wrk_html_td>
									<cfif attributes.is_discount eq 1>
										<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(toplam_iskonto)#<cfelse>#TLFormat(toplam_iskonto,5)#</cfif></cf_wrk_html_td>
										<cf_wrk_html_td style="text-align:center;" class="formbold">#SESSION.EP.MONEY#</cf_wrk_html_td>
										<cfif attributes.is_money2 eq 1>
											<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(toplam_iskonto2)#<cfelse>#TLFormat(toplam_iskonto2,5)#</cfif></cf_wrk_html_td>
											<cf_wrk_html_td style="text-align:center;" class="formbold">#SESSION.EP.MONEY2#</cf_wrk_html_td>
										<cfelseif attributes.is_other_money eq 1>
											<cf_wrk_html_td></cf_wrk_html_td>
											<cf_wrk_html_td style="text-align:center;" class="formbold"></cf_wrk_html_td>
										</cfif>
									</cfif>
									<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(toplam_satis)#<cfelse>#TLFormat(toplam_satis,5)#</cfif></cf_wrk_html_td>
									<cf_wrk_html_td style="text-align:center;" class="formbold">#SESSION.EP.MONEY#</cf_wrk_html_td>
									<cfif attributes.is_money2 eq 1>
										<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(toplam_satis2)#<cfelse>#TLFormat(toplam_satis2,5)#</cfif></cf_wrk_html_td>
										<cf_wrk_html_td style="text-align:center;" class="formbold">#SESSION.EP.MONEY2#</cf_wrk_html_td>
									</cfif>
									<cfif attributes.is_other_money eq  1>
										<cf_wrk_html_td></cf_wrk_html_td>
										<cf_wrk_html_td style="text-align:center;" class="formbold"></cf_wrk_html_td>
									</cfif>
									<cfif attributes.cost_price eq 1 or attributes.cost_price eq 1>
										<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(toplam_maliyet)#<cfelse>#TLFormat(wrk_round(toplam_maliyet,5,1),5)#</cfif></cf_wrk_html_td>
									</cfif>
									<cf_wrk_html_td></cf_wrk_html_td>
								</cf_wrk_html_tr>
							</cfoutput>
						</tfoot>
					
				<cfelseif attributes.report_type eq 6>
					
						<thead>
							<cf_wrk_html_tr>
								<cf_wrk_html_th width="25"><cf_get_lang dictionary_id='57487.No'></cf_wrk_html_th>
								<cf_wrk_html_th height="22"><cf_get_lang dictionary_id='58847.Marka'></cf_wrk_html_th>
								<cf_wrk_html_th style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></cf_wrk_html_th>
								<cfif attributes.is_discount eq 1>
									<cf_wrk_html_th width="150" style="text-align:right;"><cf_get_lang dictionary_id='39697.İskonto Tutar'></cf_wrk_html_th>
									<cf_wrk_html_th width="30" style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></cf_wrk_html_th>
									<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
										<cf_wrk_html_th width="150" style="text-align:right;"><cf_get_lang dictionary_id='39698.İskonto Döviz'></cf_wrk_html_th>
										<cf_wrk_html_th width="30" style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></cf_wrk_html_th>
									</cfif>
								</cfif>
								<cf_wrk_html_th width="150" style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></cf_wrk_html_th>
								<cf_wrk_html_th width="30" style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></cf_wrk_html_th>
								<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
								<cf_wrk_html_th width="150" style="text-align:right;"><cf_get_lang dictionary_id='57677.Döviz'></cf_wrk_html_th>
								<cf_wrk_html_th width="30" style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></cf_wrk_html_th>
								</cfif>
								<cf_wrk_html_th width="35" style="text-align:right;">%</cf_wrk_html_th>
							</cf_wrk_html_tr>
						</thead>
						<tbody>
							<cfoutput query="get_total_purchase"  startrow="#attributes.startrow#" maxrows="#attributes.max_rows#">
								<cfset toplam_satis=PRICE+toplam_satis>
								<cfif attributes.is_money2 eq 1>
									<cfset toplam_satis2=PRICE_DOVIZ+toplam_satis2>
								</cfif>
								<cfset toplam_iskonto=ISKONTO+toplam_iskonto>
								<cfif attributes.is_money2 eq 1>
									<cfset toplam_iskonto2=ISKONTO_DOVIZ+toplam_iskonto2>
								</cfif>
								<cf_wrk_html_tr>
									<cf_wrk_html_td>#currentrow#</cf_wrk_html_td>
									<cf_wrk_html_td>#brand_name#</cf_wrk_html_td>
									<cf_wrk_html_td style="text-align:right;" format="numeric">#TLFormat(product_stock,4)#
									<cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar>
									</cf_wrk_html_td>
									<cfif attributes.is_discount eq 1>
										<cf_wrk_html_td style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(ISKONTO)#<cfelse>#TLFormat(ISKONTO,5)#</cfif></cf_wrk_html_td>
										<cf_wrk_html_td style="text-align:center;">#SESSION.EP.MONEY#</cf_wrk_html_td>
										<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
											<cf_wrk_html_td style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(ISKONTO_DOVIZ)#<cfelse>#TLFormat(ISKONTO_DOVIZ,5)#</cfif></cf_wrk_html_td>
											<cf_wrk_html_td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></cf_wrk_html_td>
										</cfif>
									</cfif>
									<cf_wrk_html_td style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(PRICE)#<cfelse>#TLFormat(PRICE,5)#</cfif></cf_wrk_html_td>
									<cf_wrk_html_td style="text-align:center;">#SESSION.EP.MONEY#</cf_wrk_html_td>
									<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
										<cf_wrk_html_td style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(PRICE_DOVIZ)#<cfelse>#TLFormat(PRICE_DOVIZ,5)#</cfif></cf_wrk_html_td>
										<cf_wrk_html_td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></cf_wrk_html_td>
									</cfif>
									<cf_wrk_html_td style="text-align:right; mso-number-format:'\@';" format="text"><cfif len(butun_toplam) and butun_toplam neq 0 and len(PRICE)>#NumberFormat(Evaluate(100*PRICE/butun_toplam),"00.00")#<cfelse>00.00</cfif></cf_wrk_html_td>
								</cf_wrk_html_tr>
							</cfoutput>
						</tbody> 
						<tfoot> 
							<cfoutput>
							<cf_wrk_html_tr height="20" class="color-list">
								<cf_wrk_html_td class="formbold" colspan="2" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></cf_wrk_html_td>
								<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric">
								<cfif toplam_miktar gt 0><cfif x_five_digit eq 0>#TLFormat(toplam_miktar)#<cfelse>#TLFormat(toplam_miktar,5)#</cfif></cfif>
								</cf_wrk_html_td> 
								<cfif attributes.is_discount eq 1>
									<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(toplam_iskonto)#<cfelse>#TLFormat(toplam_iskonto,5)#</cfif></cf_wrk_html_td>
									<cf_wrk_html_td style="text-align:center;" class="formbold">#SESSION.EP.MONEY#</cf_wrk_html_td>
									<cfif attributes.is_money2 eq 1>
										<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(toplam_iskonto2)#<cfelse>#TLFormat(toplam_iskonto2,5)#</cfif></cf_wrk_html_td>
										<cf_wrk_html_td style="text-align:center;" class="formbold">#SESSION.EP.MONEY2#</cf_wrk_html_td>
									<cfelseif attributes.is_other_money eq 1>
										<cf_wrk_html_td></cf_wrk_html_td>
										<cf_wrk_html_td></cf_wrk_html_td>
									</cfif>
								</cfif>
								<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(toplam_satis)#<cfelse>#TLFormat(toplam_satis,5)#</cfif></cf_wrk_html_td>
								<cf_wrk_html_td style="text-align:center;" class="formbold">#SESSION.EP.MONEY#</cf_wrk_html_td>
								<cfif attributes.is_money2 eq 1>
									<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(toplam_satis2)#<cfelse>#TLFormat(toplam_satis2,5)#</cfif></cf_wrk_html_td>
									<cf_wrk_html_td style="text-align:center;" class="formbold">#SESSION.EP.MONEY2#</cf_wrk_html_td>
								</cfif>
								<cfif attributes.is_other_money eq 1>
									<cf_wrk_html_td></cf_wrk_html_td>
									<cf_wrk_html_td style="text-align:center;" class="formbold"></cf_wrk_html_td>
								</cfif>
								<cf_wrk_html_td></cf_wrk_html_td>
							</cf_wrk_html_tr>
							</cfoutput>	
						</tfoot> 
					
				<cfelseif attributes.report_type eq 7>
					
						<thead> 
							<cf_wrk_html_tr>
								<cf_wrk_html_th width="25"><cf_get_lang dictionary_id='57487.No'></cf_wrk_html_th>
								<cf_wrk_html_th height="22"><cf_get_lang dictionary_id='57416.Proje'></cf_wrk_html_th>
								<cf_wrk_html_th style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></cf_wrk_html_th>
								<cfif attributes.is_discount eq 1>
									<cf_wrk_html_th width="150" style="text-align:right;"><cf_get_lang dictionary_id='39697.İskonto Tutar'></cf_wrk_html_th>
									<cf_wrk_html_th width="30"><cf_get_lang dictionary_id='58474.Birim'></cf_wrk_html_th>
									<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
										<cf_wrk_html_th width="150" style="text-align:right;"><cf_get_lang dictionary_id='39698.İskonto Döviz'></cf_wrk_html_th>
										<cf_wrk_html_th width="30"><cf_get_lang dictionary_id='58474.Birim'></cf_wrk_html_th>
									</cfif>
								</cfif>
								<cf_wrk_html_th width="150" style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></cf_wrk_html_th>
								<cf_wrk_html_th width="30"><cf_get_lang dictionary_id='58474.Birim'></cf_wrk_html_th>
								<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
								<cf_wrk_html_th width="150" style="text-align:right;"><cf_get_lang dictionary_id='57677.Döviz'></cf_wrk_html_th>
								<cf_wrk_html_th width="30"><cf_get_lang dictionary_id='58474.Birim'></cf_wrk_html_th>
								</cfif>
								<cf_wrk_html_th width="35" style="text-align:right;">%</cf_wrk_html_th>
							</cf_wrk_html_tr>
						</thead>
						<tbody>
							<cfoutput query="get_total_purchase"  startrow="#attributes.startrow#" maxrows="#attributes.max_rows#">
								<cfset toplam_satis=PRICE+toplam_satis>
								<cfif attributes.is_money2 eq 1>
									<cfset toplam_satis2=PRICE_DOVIZ+toplam_satis2>
								</cfif>
								<cfset toplam_iskonto=ISKONTO+toplam_iskonto>
								<cfif attributes.is_money2 eq 1>
									<cfset toplam_iskonto2=ISKONTO_DOVIZ+toplam_iskonto2>
								</cfif>
								<cf_wrk_html_tr>
									<cf_wrk_html_td>#currentrow#</cf_wrk_html_td>
									<cf_wrk_html_td>#project_head#</cf_wrk_html_td>
									<cf_wrk_html_td style="text-align:right;" format="numeric">#TLFormat(product_stock,4)#
									<cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar>
									</cf_wrk_html_td>
									<cfif attributes.is_discount eq 1>
										<cf_wrk_html_td style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(ISKONTO)#<cfelse>#TLFormat(ISKONTO,5)#</cfif></cf_wrk_html_td>
										<cf_wrk_html_td style="text-align:center;">#SESSION.EP.MONEY#</cf_wrk_html_td>
										<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
											<cf_wrk_html_td style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(ISKONTO_DOVIZ)#<cfelse>#TLFormat(ISKONTO_DOVIZ,5)#</cfif></cf_wrk_html_td>
											<cf_wrk_html_td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></cf_wrk_html_td>
										</cfif>
									</cfif>
									<cf_wrk_html_td style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(PRICE)#<cfelse>#TLFormat(PRICE,5)#</cfif></cf_wrk_html_td>
									<cf_wrk_html_td style="text-align:center;">#SESSION.EP.MONEY#</cf_wrk_html_td>
									<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
										<cf_wrk_html_td style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(PRICE_DOVIZ)#<cfelse>#TLFormat(PRICE_DOVIZ,5)#</cfif></cf_wrk_html_td>
										<cf_wrk_html_td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></cf_wrk_html_td>
									</cfif>
									<td style="text-align:right; mso-number-format:'\@';" format="text"><cfif len(butun_toplam) and butun_toplam neq 0 and len(PRICE)>#NumberFormat(Evaluate(100*PRICE/butun_toplam),"00.00")#<cfelse>00.00</cfif></td>
								</cf_wrk_html_tr>
							</cfoutput>
						</tbody>
						<tfoot>
							<cfoutput>
							<cf_wrk_html_tr>
								<cf_wrk_html_td class="formbold" colspan="2" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></cf_wrk_html_td>
								<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric">
								<cfif toplam_miktar gt 0><cfif x_five_digit eq 0>#TLFormat(toplam_miktar)#<cfelse>#TLFormat(toplam_miktar,5)#</cfif></cfif>
								</cf_wrk_html_td> 
								<cfif attributes.is_discount eq 1>
									<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(toplam_iskonto)#<cfelse>#TLFormat(toplam_iskonto,5)#</cfif></cf_wrk_html_td>
									<cf_wrk_html_td style="text-align:center;" class="formbold">#SESSION.EP.MONEY#</cf_wrk_html_td>
									<cfif attributes.is_money2 eq 1>
										<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(toplam_iskonto2)#<cfelse>#TLFormat(toplam_iskonto2,5)#</cfif></cf_wrk_html_td>
										<cf_wrk_html_td style="text-align:center;" class="formbold">#SESSION.EP.MONEY2#</cf_wrk_html_td>
									<cfelseif attributes.is_other_money eq 1>
										<cf_wrk_html_td></cf_wrk_html_td>
										<cf_wrk_html_td style="text-align:center;" class="formbold"></cf_wrk_html_td>
									</cfif>
								</cfif>
								<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(toplam_satis)#<cfelse>#TLFormat(toplam_satis,5)#</cfif></cf_wrk_html_td>
								<cf_wrk_html_td style="text-align:center;" class="formbold">#SESSION.EP.MONEY#</cf_wrk_html_td>
								<cfif attributes.is_money2 eq 1>
									<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(toplam_satis2)#<cfelse>#TLFormat(toplam_satis2,5)#</cfif></cf_wrk_html_td>
									<cf_wrk_html_td style="text-align:center;" class="formbold">#SESSION.EP.MONEY2#</cf_wrk_html_td>
								</cfif>
								<cfif attributes.is_other_money eq 1>
									<cf_wrk_html_td></cf_wrk_html_td>
									<cf_wrk_html_td style="text-align:center;" class="formbold"></cf_wrk_html_td>
								</cfif>
								<cf_wrk_html_td></cf_wrk_html_td>
							</cf_wrk_html_tr>
							</cfoutput>
						</tfoot>
					
				<cfelseif attributes.report_type eq 8>
					
						<thead>
							<cf_wrk_html_tr>
								<cf_wrk_html_th width="25"><cf_get_lang dictionary_id='57487.No'></cf_wrk_html_th>
								<cf_wrk_html_th height="22"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></cf_wrk_html_th>
								<cf_wrk_html_th style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></cf_wrk_html_th>
								<cfif attributes.is_discount eq 1>
									<cf_wrk_html_th width="150" style="text-align:right;"><cf_get_lang dictionary_id='39697.İskonto Tutar'></cf_wrk_html_th>
									<cf_wrk_html_th width="30"><cf_get_lang dictionary_id='58474.Birim'></cf_wrk_html_th>
									<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
										<cf_wrk_html_th width="150" style="text-align:right;"><cf_get_lang dictionary_id='39698.İskonto Döviz'></cf_wrk_html_th>
										<cf_wrk_html_th width="30"><cf_get_lang dictionary_id='58474.Birim'></cf_wrk_html_th>
									</cfif>
								</cfif>
								<cf_wrk_html_th width="150" style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></cf_wrk_html_th>
								<cf_wrk_html_th width="30"><cf_get_lang dictionary_id='58474.Birim'></cf_wrk_html_th>
								<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
								<cf_wrk_html_th width="150" style="text-align:right;"><cf_get_lang dictionary_id='57677.Döviz'></cf_wrk_html_th>
								<cf_wrk_html_th width="30"><cf_get_lang dictionary_id='58474.Birim'></cf_wrk_html_th>
								</cfif>
								<cf_wrk_html_th width="35" style="text-align:right;">%</cf_wrk_html_th>
							</cf_wrk_html_tr>
						</thead>
						<tbody>
							<cfoutput query="get_total_purchase"  startrow="#attributes.startrow#" maxrows="#attributes.max_rows#">
								<cfset toplam_satis=PRICE+toplam_satis>
								<cfif attributes.is_money2 eq 1>
									<cfset toplam_satis2=PRICE_DOVIZ+toplam_satis2>
								</cfif>
								<cfset toplam_iskonto=ISKONTO+toplam_iskonto>
								<cfif attributes.is_money2 eq 1>
									<cfset toplam_iskonto2=ISKONTO_DOVIZ+toplam_iskonto2>
								</cfif>
								<cf_wrk_html_tr height="20" onmouseover="this.className='color-light';" onmouseout="this.className='color-row';" class="color-row">
									<cf_wrk_html_td>#currentrow#</cf_wrk_html_td>
									<cf_wrk_html_td><cfif len(PAY_METHOD) and listfind(list_pay_ids,PAY_METHOD,',')>
											#GET_PAY_METHOD.PAYMETHOD[listfind(list_pay_ids,PAY_METHOD,',')]#
										<cfelseif len(CARD_PAYMETHOD_ID) and listfind(list_cc_pay_ids,CARD_PAYMETHOD_ID,',')>
											#GET_CC_METHOD.CARD_NO[listfind(list_cc_pay_ids,CARD_PAYMETHOD_ID,',')]#
										<cfelse>
											**ÖY:#PAY_METHOD# KK ÖY:#CARD_PAYMETHOD_ID#**
										</cfif>
									</cf_wrk_html_td>
									<cf_wrk_html_td style="text-align:right;" format="numeric">#TLFormat(product_stock,4)#
									<cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar>
									</cf_wrk_html_td>
									<cfif attributes.is_discount eq 1>
										<cf_wrk_html_td style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(ISKONTO)#<cfelse>#TLFormat(ISKONTO,5)#</cfif></cf_wrk_html_td>
										<cf_wrk_html_td style="text-align:center;">#SESSION.EP.MONEY#</cf_wrk_html_td>
										<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
											<cf_wrk_html_td style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(ISKONTO_DOVIZ)#<cfelse>#TLFormat(ISKONTO_DOVIZ,5)#</cfif></cf_wrk_html_td>
											<cf_wrk_html_td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></cf_wrk_html_td>
										</cfif>
									</cfif>
									<cf_wrk_html_td style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(PRICE)#<cfelse>#TLFormat(PRICE,5)#</cfif></cf_wrk_html_td>
									<cf_wrk_html_td style="text-align:center;">#SESSION.EP.MONEY#</cf_wrk_html_td>
									<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
										<cf_wrk_html_td style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(PRICE_DOVIZ)#<cfelse>#TLFormat(PRICE_DOVIZ,5)#</cfif></cf_wrk_html_td>
										<cf_wrk_html_td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></cf_wrk_html_td>
									</cfif>
									<cf_wrk_html_td style="text-align:right; mso-number-format:'\@';" format="text"><cfif len(butun_toplam) and butun_toplam neq 0 and len(PRICE)>#NumberFormat(Evaluate(100*PRICE/butun_toplam),"00.00")#<cfelse>00.00</cfif></cf_wrk_html_td>
								</cf_wrk_html_tr>
							</cfoutput>
						</tbody>
						<tfoot>
							<cfoutput>
							<cf_wrk_html_tr>
								<cf_wrk_html_td class="formbold" colspan="2" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></cf_wrk_html_td>
								<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric">
								<cfif toplam_miktar gt 0><cfif x_five_digit eq 0>#TLFormat(toplam_miktar)#<cfelse>#TLFormat(toplam_miktar,5)#</cfif></cfif>
								</cf_wrk_html_td> 
								<cfif attributes.is_discount eq 1>
									<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(toplam_iskonto)#<cfelse>#TLFormat(toplam_iskonto,5)#</cfif></cf_wrk_html_td>
									<cf_wrk_html_td style="text-align:center;" class="formbold">#SESSION.EP.MONEY#</cf_wrk_html_td>
									<cfif attributes.is_money2 eq 1>
										<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(toplam_iskonto2)#<cfelse>#TLFormat(toplam_iskonto2,5)#</cfif></cf_wrk_html_td>
										<cf_wrk_html_td style="text-align:center;" class="formbold">#SESSION.EP.MONEY2#</cf_wrk_html_td>
									<cfelseif attributes.is_other_money eq 1>
										<cf_wrk_html_td></cf_wrk_html_td>
										<cf_wrk_html_td></cf_wrk_html_td>
									</cfif>
								</cfif>
								<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(toplam_satis)#<cfelse>#TLFormat(toplam_satis,5)#</cfif></cf_wrk_html_td>
								<cf_wrk_html_td style="text-align:center;" class="formbold">#SESSION.EP.MONEY#</td>
								<cfif attributes.is_money2 eq 1>
									<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(toplam_satis2)#<cfelse>#TLFormat(toplam_satis2,5)#</cfif></cf_wrk_html_td>
									<cf_wrk_html_td style="text-align:center;">#SESSION.EP.MONEY2#</cf_wrk_html_td>
								</cfif>
								<cfif attributes.is_other_money eq 1>
									<cf_wrk_html_td></cf_wrk_html_td>
									<cf_wrk_html_td></cf_wrk_html_td>
								</cfif>
								<cf_wrk_html_td></cf_wrk_html_td>
							</cf_wrk_html_tr>
							</cfoutput>
						</tfoot>
					
				<cfelseif attributes.report_type eq 9>
					
						<thead>
							<cf_wrk_html_tr>
								<cf_wrk_html_th width="25"><cf_get_lang dictionary_id='57487.No'></cf_wrk_html_th>
								<cf_wrk_html_th height="22"><cf_get_lang dictionary_id='58448.Ürün Sorumlusu'></cf_wrk_html_th>
								<cf_wrk_html_th style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></cf_wrk_html_th>
								<cfif attributes.is_discount eq 1>
									<cf_wrk_html_th width="150" style="text-align:right;"><cf_get_lang dictionary_id='39697.İskonto Tutar'></cf_wrk_html_th>
									<cf_wrk_html_th width="30"><cf_get_lang dictionary_id='58474.Birim'></cf_wrk_html_th>
									<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
										<cf_wrk_html_th width="150" style="text-align:right;"><cf_get_lang dictionary_id='39698.İskonto Döviz'></cf_wrk_html_th>
										<cf_wrk_html_th width="30"><cf_get_lang dictionary_id='58474.Birim'></cf_wrk_html_th>
									</cfif>
								</cfif>
								<cf_wrk_html_th width="150" style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></cf_wrk_html_th>
								<cf_wrk_html_th width="30"><cf_get_lang dictionary_id='58474.Birim'></cf_wrk_html_th>
								<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
								<cf_wrk_html_th width="150" style="text-align:right;"><cf_get_lang dictionary_id='57677.Döviz'></cf_wrk_html_th>
								<cf_wrk_html_th width="30"><cf_get_lang dictionary_id='58474.Birim'></cf_wrk_html_th>
								<cf_wrk_html_th></cf_wrk_html_th>
								</cfif>
								<cf_wrk_html_th width="35" style="text-align:right;">%</cf_wrk_html_th>
							</cf_wrk_html_tr>
						</thead>
						<tbody>
							<cfoutput query="get_total_purchase"  startrow="#attributes.startrow#" maxrows="#attributes.max_rows#">
								<cfset toplam_satis=PRICE+toplam_satis>
								<cfif attributes.is_money2 eq 1>
									<cfset toplam_satis2=PRICE_DOVIZ+toplam_satis2>
								</cfif>
								<cfset toplam_iskonto=ISKONTO+toplam_iskonto>
								<cfif attributes.is_money2 eq 1>
									<cfset toplam_iskonto2=ISKONTO_DOVIZ+toplam_iskonto2>
								</cfif>
								<cf_wrk_html_tr>
									<cf_wrk_html_td>#currentrow#</cf_wrk_html_td>
									<cf_wrk_html_td>
									<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1 >
										#get_position.employee_name[listfind(position_code_list,get_total_purchase.position_code,',')]#&nbsp;
										#get_position.employee_surname[listfind(position_code_list,get_total_purchase.position_code,',')]#&nbsp;
									<cfelse>
										<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&pos_code=#get_total_purchase.position_code#','medium');" class="tableyazi">
											#get_position.employee_name[listfind(position_code_list,get_total_purchase.position_code,',')]#&nbsp;
											#get_position.employee_surname[listfind(position_code_list,get_total_purchase.position_code,',')]#&nbsp;
										</a>				
									</cfif>
									</cf_wrk_html_td>
									<cf_wrk_html_td style="text-align:right;" format="numeric">#TLFormat(product_stock,4)#
									<cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar>
									</cf_wrk_html_td>
									<cfif attributes.is_discount eq 1>
										<cf_wrk_html_td style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(ISKONTO)#<cfelse>#TLFormat(ISKONTO,5)#</cfif></cf_wrk_html_td>
										<cf_wrk_html_td style="text-align:center;">#SESSION.EP.MONEY#</cf_wrk_html_td>
										<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
											<cf_wrk_html_td style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(ISKONTO_DOVIZ)#<cfelse>#TLFormat(ISKONTO_DOVIZ,5)#</cfif></cf_wrk_html_td>
											<cf_wrk_html_td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></cf_wrk_html_td>
										</cfif>
									</cfif>
									<cf_wrk_html_td style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(PRICE)#<cfelse>#TLFormat(PRICE,5)#</cfif></cf_wrk_html_td>
									<cf_wrk_html_td style="text-align:center;">#SESSION.EP.MONEY#</cf_wrk_html_td>
									<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
										<cf_wrk_html_td style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(PRICE_DOVIZ)#<cfelse>#TLFormat(PRICE_DOVIZ,5)#</cfif></cf_wrk_html_td>
										<cf_wrk_html_td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></cf_wrk_html_td>
									</cfif>
									<cf_wrk_html_td style="text-align:right; mso-number-format:'\@';" format="text"><cfif len(butun_toplam) and butun_toplam neq 0 and len(PRICE)>#NumberFormat(Evaluate(100*PRICE/butun_toplam),"00.00")#<cfelse>00.00</cfif></cf_wrk_html_td>
								</cf_wrk_html_tr>
							</cfoutput>
						</tbody>
						<tfoot>
							<cfoutput>
							<cf_wrk_html_tr>
								<cf_wrk_html_td class="formbold" colspan="2" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></cf_wrk_html_td>
								<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric">
								<cfif toplam_miktar gt 0><cfif x_five_digit eq 0>#TLFormat(toplam_miktar)#<cfelse>#TLFormat(toplam_miktar,5)#</cfif></cfif>
								</cf_wrk_html_td> 
								<cfif attributes.is_discount eq 1>
									<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(toplam_iskonto)#<cfelse>#TLFormat(toplam_iskonto,5)#</cfif></cf_wrk_html_td>
									<cf_wrk_html_td style="text-align:center;" class="formbold">#SESSION.EP.MONEY#</cf_wrk_html_td>
									<cfif attributes.is_money2 eq 1>
										<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(toplam_iskonto2)#<cfelse>#TLFormat(toplam_iskonto2,5)#</cfif></cf_wrk_html_td>
										<cf_wrk_html_td style="text-align:center;" class="formbold">#SESSION.EP.MONEY2#</cf_wrk_html_td>
									<cfelseif attributes.is_other_money eq 1>
										<cf_wrk_html_td></cf_wrk_html_td>
										<cf_wrk_html_td class="formbold"></cf_wrk_html_td>
									</cfif>
								</cfif>
								<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(toplam_satis)#<cfelse>#TLFormat(toplam_satis,5)#</cfif></cf_wrk_html_td>
								<cf_wrk_html_td style="text-align:center;" class="formbold">#SESSION.EP.MONEY#</cf_wrk_html_td>
								<cfif attributes.is_money2 eq 1>
									<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(toplam_satis2)#<cfelse>#TLFormat(toplam_satis2,5)#</cfif></cf_wrk_html_td>
									<cf_wrk_html_td style="text-align:center;" class="formbold">#SESSION.EP.MONEY2#</cf_wrk_html_td>
									<cf_wrk_html_td></cf_wrk_html_td>
								</cfif>
								<cfif attributes.is_other_money eq 1>
									<cf_wrk_html_td></cf_wrk_html_td>
									<cf_wrk_html_td class="formbold"></cf_wrk_html_td>
									<cf_wrk_html_td></cf_wrk_html_td>
								</cfif>
								<cf_wrk_html_td></cf_wrk_html_td>
							</cf_wrk_html_tr>
							</cfoutput>	
						</tfoot>
					
				<cfelseif attributes.report_type eq 12>
					
						<thead>
							<cf_wrk_html_tr>
								<cf_wrk_html_th width="200"><cf_get_lang dictionary_id="40074.Ürün Grubu"></cf_wrk_html_th>
								<cf_wrk_html_th style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></cf_wrk_html_th>
								<cfif attributes.is_discount eq 1>
									<cf_wrk_html_th width="100" style="text-align:right;"><cf_get_lang dictionary_id='39697.İskonto Tutar'></cf_wrk_html_th>
									<cf_wrk_html_th width="50" style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></cf_wrk_html_th>
									<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
										<cf_wrk_html_th width="100" style="text-align:right;"><cf_get_lang dictionary_id='39698.İskonto Döviz'></cf_wrk_html_th>
										<cf_wrk_html_th width="50" style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></cf_wrk_html_th>
									</cfif>
								</cfif>
								<cf_wrk_html_th width="100" style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></cf_wrk_html_th>
								<cf_wrk_html_th width="50" style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></cf_wrk_html_th>
								<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
									<cf_wrk_html_th width="100" style="text-align:right;"><cf_get_lang dictionary_id='57677.Döviz'></cf_wrk_html_th>
									<cf_wrk_html_th width="50" style="text-align:center;"><cf_get_lang dictionary_id='58474.Birim'></cf_wrk_html_th>
								</cfif>
								<cf_wrk_html_th width="35" style="text-align:right;">%</cf_wrk_html_th>
							</cf_wrk_html_tr>
						</thead>
						<tbody>
							<cfoutput query="get_total_purchase"  startrow="#attributes.startrow#" maxrows="#attributes.max_rows#">
								<cfset toplam_satis=PRICE+toplam_satis>
								<cfif attributes.is_money2 eq 1>
									<cfset toplam_satis2=PRICE_DOVIZ+toplam_satis2>
								</cfif>
								<cfset toplam_iskonto=ISKONTO+toplam_iskonto>
								<cfif attributes.is_money2 eq 1>
									<cfset toplam_iskonto2=ISKONTO_DOVIZ+toplam_iskonto2>
								</cfif>
								<cf_wrk_html_tr>
									<cf_wrk_html_td>
									
										<cfset deger_ = listGetAt(product_cat_list,PRODUCT_TYPE,',')>
										
										<cfif deger_ eq 667><cf_get_lang dictionary_id="58079.İnternet">
										<cfelseif deger_ eq 607><cf_get_lang dictionary_id="58019.Extranet">
										<cfelseif deger_ eq 164><cf_get_lang dictionary_id="40009.Kalite"> 
										<cfelse>
											<cf_get_lang_set module_name="product">
												#getLang('product',deger_)#
											<cf_get_lang_set module_name="report">
										</cfif>
									</cf_wrk_html_td>
									<cf_wrk_html_td style="text-align:right;" format="numeric">#TLFormat(product_stock,4)#
									<cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar>
									</cf_wrk_html_td>
									<cfif attributes.is_discount eq 1>
										<cf_wrk_html_td style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(ISKONTO)#<cfelse>#TLFormat(ISKONTO,5)#</cfif></cf_wrk_html_td>
										<cf_wrk_html_td style="text-align:center;">#SESSION.EP.MONEY#</cf_wrk_html_td>
										<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
											<cf_wrk_html_td style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(ISKONTO_DOVIZ)#<cfelse>#TLFormat(ISKONTO_DOVIZ,5)#</cfif></cf_wrk_html_td>
											<cf_wrk_html_td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></cf_wrk_html_td>
										</cfif>
									</cfif>
									<cf_wrk_html_td style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(PRICE)#<cfelse>#TLFormat(PRICE,5)#</cfif></cf_wrk_html_td>
									<cf_wrk_html_td style="text-align:center;">#SESSION.EP.MONEY#</cf_wrk_html_td>
									<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
										<cf_wrk_html_td style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(PRICE_DOVIZ)#<cfelse>#TLFormat(PRICE_DOVIZ,5)#</cfif></cf_wrk_html_td>
										<cf_wrk_html_td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></cf_wrk_html_td>
									</cfif>
									<cf_wrk_html_td style="text-align:right; mso-number-format:'\@';" format="text"><cfif len(butun_toplam) and butun_toplam neq 0 and len(PRICE)>#NumberFormat(Evaluate(100*PRICE/butun_toplam),"00.00")#<cfelse>00.00</cfif></cf_wrk_html_td>
								</cf_wrk_html_tr>
							</cfoutput>
						</tbody>
						<tfoot>
							<cfoutput>
								<cf_wrk_html_tr>
									<cf_wrk_html_td class="formbold" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></cf_wrk_html_td>
									<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif toplam_miktar gt 0><cfif x_five_digit eq 0>#TLFormat(toplam_miktar)#<cfelse>#TLFormat(toplam_miktar,5)#</cfif></cfif></cf_wrk_html_td> 
									<cfif attributes.is_discount eq 1>
										<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(toplam_iskonto)#<cfelse>#TLFormat(toplam_iskonto,5)#</cfif></cf_wrk_html_td>
										<cf_wrk_html_td style="text-align:center;" class="formbold">#SESSION.EP.MONEY#</cf_wrk_html_td>
										<cfif attributes.is_money2 eq 1>
											<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(toplam_iskonto2)#<cfelse>#TLFormat(toplam_iskonto2,5)#</cfif></cf_wrk_html_td>
											<cf_wrk_html_td style="text-align:center;" class="formbold">#SESSION.EP.MONEY2#</cf_wrk_html_td>
										<cfelseif attributes.is_other_money eq 1>
											<cf_wrk_html_td></cf_wrk_html_td>
											<cf_wrk_html_td style="text-align:center;" class="formbold"></cf_wrk_html_td>
										</cfif>
									</cfif>
									<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(toplam_satis)#<cfelse>#TLFormat(toplam_satis,5)#</cfif></cf_wrk_html_td>
									<cf_wrk_html_td style="text-align:center;" class="formbold">#SESSION.EP.MONEY#</cf_wrk_html_td>
									<cfif attributes.is_money2 eq 1>
										<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(toplam_satis2)#<cfelse>#TLFormat(toplam_satis2,5)#</cfif></cf_wrk_html_td>
										<cf_wrk_html_td style="text-align:center;" class="formbold">#SESSION.EP.MONEY2#</cf_wrk_html_td>
									</cfif>
									<cfif attributes.is_other_money eq 1>
										<cf_wrk_html_td></cf_wrk_html_td>
										<cf_wrk_html_td style="text-align:center;" class="formbold"></cf_wrk_html_td>
									</cfif>
									<cf_wrk_html_td></cf_wrk_html_td>
								</cf_wrk_html_tr>
							</cfoutput>
						</tfoot>  
					   	        
				<cfelse>
					
						<thead>
							<cf_wrk_html_tr>
								<cf_wrk_html_th width="25"><cf_get_lang dictionary_id='57487.No'></cf_wrk_html_th>
								<cf_wrk_html_th height="22"><cf_get_lang dictionary_id='57486.Kategori'></cf_wrk_html_th>
								<cf_wrk_html_th><cf_get_lang dictionary_id='57633.Barkod'></cf_wrk_html_th>
								<cfif attributes.report_type eq 3>
									<cf_wrk_html_th><cf_get_lang dictionary_id='57518.STOK KODU'></cf_wrk_html_th>
								</cfif>
								<cf_wrk_html_th><cf_get_lang dictionary_id='57657.Ürün'> </cf_wrk_html_th>
								<cf_wrk_html_th style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></cf_wrk_html_th>
								<cf_wrk_html_th width="30"><cf_get_lang dictionary_id='57636.Birim'></cf_wrk_html_th>
								<cfif attributes.is_discount eq 1>
									<cf_wrk_html_th style="text-align:right;"><cf_get_lang dictionary_id='39697.İskonto Tutar'></cf_wrk_html_th>
									<cf_wrk_html_th width="30"><cf_get_lang dictionary_id='58474.Birim'></cf_wrk_html_th>
									<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
										<cf_wrk_html_th style="text-align:right;"><cf_get_lang dictionary_id='39698.İskonto Döviz'></cf_wrk_html_th>
										<cf_wrk_html_th width="30"><cf_get_lang dictionary_id='58474.Birim'></cf_wrk_html_th>
									</cfif>
								</cfif>
								<cf_wrk_html_th style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></cf_wrk_html_th>
								<cf_wrk_html_th width="30"><cf_get_lang dictionary_id='58474.Birim'></cf_wrk_html_th>
								<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
								<cf_wrk_html_th width="75" style="text-align:right;"><cf_get_lang dictionary_id='57677.Döviz'></cf_wrk_html_th>
								<cf_wrk_html_th width="30"><cf_get_lang dictionary_id='58474.Birim'></cf_wrk_html_th>
								</cfif>
								<cfif attributes.cost_price eq 1 or attributes.cost_price eq 1>
								<cf_wrk_html_th width="75" style="text-align:right;"><cf_get_lang dictionary_id ='40023.Ek Maliyet'></cf_wrk_html_th>
								</cfif>
								<cf_wrk_html_th width="35" style="text-align:right;">%</cf_wrk_html_th>
							</cf_wrk_html_tr> 
						</thead> 
						<tbody>
							<cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.max_rows#">
							<!--- <cfset toplam_satis=PRICE+toplam_satis> --->
							<cfif attributes.is_money2 eq 1>
								<cfset toplam_satis2=PRICE_DOVIZ+toplam_satis2>
							</cfif>
							<cfset toplam_iskonto=ISKONTO+toplam_iskonto>
							<cfif attributes.is_money2 eq 1>
								<cfset toplam_iskonto2=ISKONTO_DOVIZ+toplam_iskonto2>
							</cfif>
							<cf_wrk_html_tr>
								<cf_wrk_html_td>#currentrow#</cf_wrk_html_td>
								<cf_wrk_html_td>#PRODUCT_CAT#</cf_wrk_html_td>
								<cfif attributes.report_type eq 2>
									<cf_wrk_html_td>#BARCOD#</cf_wrk_html_td>
									<cf_wrk_html_td>
									<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1 >
										#PRODUCT_NAME#
									<cfelse>
										<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#PRODUCT_ID#','list');">
										#PRODUCT_NAME#</a>
									</cfif>
									</cf_wrk_html_td>
								<cfelseif attributes.report_type eq 3>
									<cf_wrk_html_td>#BARCOD#</cf_wrk_html_td>
									<cf_wrk_html_td>#STOCK_CODE#</cf_wrk_html_td>
									<cf_wrk_html_td>
									<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1 >
										#PRODUCT_NAME# #PROPERTY#
									<cfelse>
										<a href="#request.self#?fuseaction=stock.list_stock&event=det&pid=#PRODUCT_ID#" class="tableyazi">#PRODUCT_NAME# #PROPERTY#</a>
									</cfif>
									</cf_wrk_html_td>
								</cfif>
								<cf_wrk_html_td style="text-align:right;" format="numeric">
									#TLFormat(PRODUCT_STOCK,4)#
									<cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar>
								</cf_wrk_html_td>
								<cf_wrk_html_td style="text-align:center;">#BIRIM#</cf_wrk_html_td>
								<cfif attributes.is_discount eq 1>
									<cf_wrk_html_td style="text-align:right;" format="numeric">#TLFormat(ISKONTO)#</cf_wrk_html_td>
									<cf_wrk_html_td style="text-align:center;">#SESSION.EP.MONEY#</cf_wrk_html_td>
									<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
										<cf_wrk_html_td style="text-align:right;" format="numeric">#TLFormat(ISKONTO_DOVIZ)#</cf_wrk_html_td>
										<cf_wrk_html_td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></cf_wrk_html_td>
									</cfif>
								</cfif>
								<cf_wrk_html_td style="text-align:right;" format="numeric">#TLFormat(PRICE)#</cf_wrk_html_td>
								<cfset toplam_satis=PRICE+toplam_satis>
								<cf_wrk_html_td style="text-align:center;">#SESSION.EP.MONEY#</cf_wrk_html_td>
								<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
									<cf_wrk_html_td style="text-align:right;" format="numeric">#TLFormat(PRICE_DOVIZ)#</cf_wrk_html_td>
									<cf_wrk_html_td style="text-align:center;"><cfif attributes.is_other_money eq 1>#OTHER_MONEY#<cfelse>#session.ep.money2#</cfif></cf_wrk_html_td>
								</cfif>
								<cfif attributes.cost_price eq 1 or attributes.cost_price eq 1>
									<cfif len(cost_price)>
										<cf_wrk_html_td style="text-align:right;" format="numeric">#TLFormat(cost_price)#</cf_wrk_html_td>
										<cfset toplam_maliyet=(cost_price)+toplam_maliyet>
									<cfelse>
										<cf_wrk_html_td style="text-align:right;" format="numeric">#TLFormat(0)#</cf_wrk_html_td>
									</cfif>
								</cfif>
								<cf_wrk_html_td style="text-align:right; mso-number-format:'\@';" format="text"><cfif butun_toplam gt 0>#NumberFormat(Evaluate(100*PRICE/butun_toplam),"00.00")#<cfelse>00.00</cfif></cf_wrk_html_td>
							</cf_wrk_html_tr>
							</cfoutput>
						</tbody>
						<tfoot>
							<cfoutput>
							<cf_wrk_html_tr>
								<cfif attributes.report_type eq 3>
									<cfset colspan_ = 5>
								<cfelse>
									<cfset colspan_= 4>
								</cfif>
								<cf_wrk_html_td colspan="#colspan_#" class="formbold" style="text-align:right;"><cf_get_lang dictionary_id='80.Toplam'></cf_wrk_html_td>
								<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric">
									<cfif toplam_miktar gt 0><cfif x_five_digit eq 0>#TLFormat(toplam_miktar)#<cfelse>#TLFormat(toplam_miktar,5)#</cfif></cfif>
								</cf_wrk_html_td>
								<cf_wrk_html_td class="formbold" style="text-align:center;">
									<cfloop query="get_product_units">
										<cfset unit_ = filterSpecialChars(get_product_units.unit)>
										<cfif evaluate('toplam_#unit_#') gt 0>
											#get_product_units.unit#<br/>
										</cfif>
									</cfloop>
								</cf_wrk_html_td>
								<cfif attributes.is_discount eq 1>
									<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(toplam_iskonto)#<cfelse>#TLFormat(toplam_iskonto,5)#</cfif></cf_wrk_html_td>
									<cf_wrk_html_td style="text-align:center;" class="formbold">#SESSION.EP.MONEY#</cf_wrk_html_td>
									<cfif attributes.is_money2 eq 1>
										<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(toplam_iskonto2)#<cfelse>#TLFormat(toplam_iskonto2,5)#</cfif></cf_wrk_html_td>
										<cf_wrk_html_td style="text-align:center;" class="formbold">#SESSION.EP.MONEY2#</cf_wrk_html_td>
									<cfelseif attributes.is_other_money eq 1>
										<cf_wrk_html_td></cf_wrk_html_td>
										<cf_wrk_html_td></cf_wrk_html_td>
									</cfif>
								</cfif>
								<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(toplam_satis)#<cfelse>#TLFormat(toplam_satis,5)#</cfif></cf_wrk_html_td>
								<cf_wrk_html_td style="text-align:center;" class="formbold">#SESSION.EP.MONEY#</cf_wrk_html_td>
								<cfif attributes.is_money2 eq 1>
									<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(toplam_satis2)#<cfelse>#TLFormat(toplam_satis2,5)#</cfif></cf_wrk_html_td>
									<cf_wrk_html_td style="text-align:center;" class="formbold">#SESSION.EP.MONEY2#</cf_wrk_html_td>
								<cfelseif attributes.is_other_money eq 1>
									<cf_wrk_html_td></cf_wrk_html_td>
									<cf_wrk_html_td></cf_wrk_html_td>
								</cfif>
								<cfif attributes.cost_price eq 1 or attributes.cost_price eq 1>
									<cf_wrk_html_td class="formbold" style="text-align:right;" format="numeric"><cfif x_five_digit eq 0>#TLFormat(toplam_maliyet)#<cfelse>#TLFormat(wrk_round(toplam_maliyet,5,1),5)#</cfif></cf_wrk_html_td>
								</cfif>
								<cf_wrk_html_td></cf_wrk_html_td>
							</cf_wrk_html_tr>
							</cfoutput> 
						</tfoot> 
					
				</cfif>
			</cfif>
		</cf_wrk_html_table>
	</cf_report_list>
    
	<cfif attributes.totalrecords gt attributes.max_rows>
				<cfscript>
					str_link = "form_submitted=1";				
					str_link = "#str_link#&graph_type=#attributes.graph_type#";
					str_link = "#str_link#&max_rows=#attributes.max_rows#&process_type=#attributes.process_type#&report_sort=#attributes.report_sort#&product_employee_id=#attributes.product_employee_id#";
					str_link = "#str_link#&product_name=#attributes.product_name#&product_id=#attributes.product_id#&is_return=#attributes.is_return#&employee_name=#attributes.employee_name#";
					str_link = "#str_link#&keyword=#attributes.keyword#&employee=#attributes.employee#&sale_employee_id=#attributes.sale_employee_id#";
					str_link = "#str_link#&department_id=#attributes.department_id#&department_name=#attributes.department_name#&consumer_id=#attributes.consumer_id#&employee_id=#attributes.employee_id#";
					str_link = "#str_link#&company=#attributes.company#&company_id=#attributes.company_id#&product_cat=#attributes.product_cat#&search_product_catid=#attributes.search_product_catid#&hierarcy=#attributes.hierarcy#";
					str_link = "#str_link#&invoice_count=#attributes.invoice_count#&taxno=#attributes.taxno#";
					str_link = "#str_link#&kdv_dahil=#attributes.kdv_dahil#&date1=#dateformat(attributes.date1,dateformat_style)#";
					str_link = "#str_link#&date2=#dateformat(attributes.date2,dateformat_style)#&report_type=#attributes.report_type#";
					str_link = "#str_link#&project_id=#attributes.project_id#";
					str_link = "#str_link#&stock_code=#attributes.stock_code#";
					str_link = "#str_link#&project_head=#attributes.project_head#";
					str_link = "#str_link#&kontrol_type=#attributes.kontrol_type#";
					str_link = "#str_link#&payment_type_id=#attributes.payment_type_id#";
					str_link = "#str_link#&card_paymethod_id=#attributes.card_paymethod_id#";
					str_link = "#str_link#&payment_type=#attributes.payment_type#";
					str_link = "#str_link#&brand_id=#attributes.brand_id#&brand_name=#attributes.brand_name#";
					str_link = "#str_link#&model_id=#attributes.model_id#&model_name=#attributes.model_name#";
					str_link = "#str_link#&is_money2=#attributes.is_money2#";
					if(isDefined("attributes.is_zero_value"))str_link = "#str_link#&is_zero_value=#attributes.is_zero_value#";
					str_link = "#str_link#&is_other_money=#attributes.is_other_money#";
					str_link = "#str_link#&is_discount=#attributes.is_discount#";
					str_link = "#str_link#&member_cat_type=#attributes.member_cat_type#&cost_price=#attributes.cost_price#";
					str_link = "#str_link#&ship_method_id=#attributes.ship_method_id#&ship_method_name=#attributes.ship_method_name#";
					if(isdefined("attributes.is_money_info"))str_link = "#str_link#&is_money_info=#attributes.is_money_info#";
					if(isdefined("attributes.is_project"))str_link = "#str_link#&is_project=#attributes.is_project#";
					if(isdefined("attributes.is_spect_info"))str_link = "#str_link#&is_spect_info=#attributes.is_spect_info#";
					if(isdefined("attributes.product_types"))str_link = "#str_link#&product_types=#attributes.product_types#";
					if(isdefined("attributes.use_efatura") and len(attributes.use_efatura))str_link = "#str_link#&use_efatura=#attributes.use_efatura#";
				</cfscript>
				<cf_paging
					page="#attributes.page#" 
					maxrows="#attributes.max_rows#" 
					totalrecords="#attributes.totalrecords#" 
					startrow="#attributes.startrow#" 
					adres="#fusebox.circuit#.purchase_analyse_report&#str_link#"> 
	</cfif>	
</cfif> 
<!--- Grafik Başlangıç --->
<cfif isdefined("attributes.form_submitted") and len(attributes.graph_type)>
<table width="98%" cellpadding="2" cellspacing="1" border="0" style="text-align:center;" class="color-border">
		<tr class="color-row">
			<td style="text-align:center;">
			<cfif isDefined("form.graph_type") and len(form.graph_type)>
				<cfset graph_type = form.graph_type>
			<cfelse>
				<cfset graph_type = "line">
			</cfif>
			
				<cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.max_rows#">
					<cfset 'sum_of_total#currentrow#' =  NumberFormat(PRICE*100/butun_toplam,'00.00')>
					<!--- Kategori Bazında ise --->
					<cfif attributes.REPORT_TYPE eq 1 or attributes.REPORT_TYPE eq 11>
						<cfset item_value = left(PRODUCT_CAT,30) >
					<!--- Ürün Bazında ise --->	
					<cfelseif attributes.REPORT_TYPE eq 2>
						<cfset item_value = left(PRODUCT_NAME,30)>
					<!--- Stok Bazında --->	
					<cfelseif attributes.REPORT_TYPE eq 3>
						<cfset item_value = left('#PRODUCT_NAME#&nbsp;#PROPERTY#',30)>
					<!--- Marka Bazında --->	
					<cfelseif attributes.REPORT_TYPE eq 6>	
						<cfset item_value = left(BRAND_NAME,30)>
					<!--- Cari Bazında --->	
					<cfelseif attributes.REPORT_TYPE eq 4>	
						<cfset item_value = "#left(NICKNAME,30)# #OTHER_MONEY#">
					<!---Belge ve Stok Bazında --->	
					<cfelseif attributes.REPORT_TYPE eq 5>	
						<cfset item_value = left(INVOICE_NUMBER,30)>
					<!---Proje Bazında --->	
					<cfelseif attributes.REPORT_TYPE eq 7>	
						<cfset item_value = left(project_head,30)>
					<!--- Ödeme Yöntemi Bazında --->	
					<cfelseif attributes.REPORT_TYPE eq 8>
						<cfif len(PAY_METHOD) and listfind(list_pay_ids,PAY_METHOD,',')>
							<cfset item_value = left('#GET_PAY_METHOD.PAYMETHOD[listfind(list_pay_ids,PAY_METHOD,',')]#',30)>
						<cfelseif len(CARD_PAYMETHOD_ID) and listfind(list_cc_pay_ids,CARD_PAYMETHOD_ID,',')>
							<cfset item_value =left('#GET_CC_METHOD.CARD_NO[listfind(list_cc_pay_ids,CARD_PAYMETHOD_ID,',')]#',30)>
						<cfelse>
							<cfset item_value =	left('**ÖY:#PAY_METHOD# KK ÖY:#CARD_PAYMETHOD_ID#**',30)>
						</cfif>
					<!---Ürün Sorumlusu Bazında --->	
					<cfelseif attributes.REPORT_TYPE eq 9>	
						<cfset item_value = left('#get_position.employee_name[listfind(position_code_list,get_total_purchase.position_code,',')]#&nbsp;#get_position.employee_surname[listfind(position_code_list,get_total_purchase.position_code,',')]#',30)>
					</cfif>
					<cfset 'item_#currentrow#' = "#item_value#">
					<cfset 'value_#currentrow#' = "#wrk_round(Evaluate("sum_of_total#currentrow#"))#">
				</cfoutput>	
				<script src="JS/Chart.min.js"></script> 
				<canvas id="myChart" style="float:left;max-width:320px;max-height:320px;"></canvas>
				<script>
					var ctx = document.getElementById('myChart');
						var myChart = new Chart(ctx, {
							type: '<cfoutput>#graph_type#</cfoutput>',
							data: {
								labels: [<cfloop from="1" to="#get_total_purchase.recordcount#" index="jj">
												 <cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
								datasets: [{
									label: "Alış Analiz Fatura",
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
</cfif>		
</div>		
<!--- Grafik Bitiş --->			  
<script type="text/javascript">
    <cfif attributes.is_excel eq 1>
        $(function(){
            TableToExcel.convert(document.getElementById('purchase_list'));
           $('#purchase_list').remove();
        });
        
    </cfif>
	function set_the_report()
	{
		rapor.report_type.checked = false;
	}
	
	function satir_kontrol()
	{
		if(document.getElementById('process_type').value=='')
		{
			alert("<cf_get_lang dictionary_id='58770.İşlem tipi seçiniz'>")	;
			return false;
		}
		if(document.rapor.max_rows.value > 250)
		{
			alert ("<cf_get_lang dictionary_id='39538.Görüntüleme Sayısı 250 den fazla olamaz'>!");
			return false;
		}
		/*if(document.rapor.is_excel.checked==false)
			{
				document.rapor.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.purchase_analyse_report</cfoutput>"
				return true;
			}
			else
				document.rapor.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_purchase_analyse_report</cfoutput>"
				*/
	}
	
	function kontrol()
	{
		deger = rapor.report_type.options[rapor.report_type.selectedIndex].value;
		if (deger != 4  && rapor.form_submitted.value == 1)
			gizli1.style.display = 'none';
		else
			gizli1.style.display = '';
	
		if (deger != 2 && deger != 3 && deger != 5 && rapor.form_submitted.value == 1)
			gizli2.style.display = 'none';
		else
			gizli2.style.display = '';
	
		if (deger == 5)
		{	
			rapor.kontrol_type.value = 1;
			money_info_2.style.display = '';
			is_spect_info.style.display = '';
		}
		else
		{
			rapor.kontrol_type.value = 0;
			money_info_2.style.display = 'none';
			is_spect_info.style.display = 'none';
		}
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
