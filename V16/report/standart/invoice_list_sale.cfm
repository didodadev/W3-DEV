<!--- 
	Seçilen tarih araligindaki secilen faturalari (50,52,53,56,57,58,62,66,6,531,561,48) ve detaylarını getirir
	(Fatura no, tarih, carihesap, kdv oranları, kdvsiz toplam, kdv toplam, kdvli toplam)
	duzenleme : 20050922
	FB 20071205 cari kategorisi filtresi eklendi cari popupı düzenlendi
	FBS 20081204 muhasebe kodlari ayrildi
 --->
<!--- <cf_xml_page_edit fuseact="report.invoice_list_sale"> --->
	<cf_xml_page_edit fuseact="report.invoice_list_sale">
		<cfparam name="attributes.module_id_control" default="20">
		<cfinclude template="report_authority_control.cfm">
		<cfparam name="attributes.company_id" default="">
		<cfparam name="attributes.consumer_id" default="">
		<cfparam name="attributes.is_excel" default="0">
		<cfparam name="attributes.company" default="">
		<cfparam name="attributes.category_id" default="">
		<cfparam name="attributes.department_id" default="">
		<cfparam name="attributes.process_type" default="">
		<cfparam name="attributes.finishdate" default="#now()#">
		<cfparam name="attributes.report_type" default="1">
		<cfparam name="attributes.list_type" default="">
		<cfparam name="attributes.project_id" default="">
		<cfparam name="attributes.project_head" default="">
		<cfparam name="attributes.startdate" default="#date_add('d',-1,attributes.finishdate)#">
		<cfparam name="attributes.use_efatura" default="">
		<cfparam name="attributes.subscription_type" default="">
		<cfparam name="attributes.product_cat_id" default="">
		<cfparam name="attributes.product_category_name" default="">
		<cfparam name="attributes.cat" default="">
		<cfset gun_farki = 0>
		<cfif attributes.is_excel eq 0><!--- excel alınırken ColdFusion was unable to add the header hatası nedeniyle bu kontrol eklendi --->
			<cfflush interval="1000">
		</cfif>	
		<cfset InvoiceSale= createObject("component","V16.report.standart.cfc.invoice_list_sale") />
		<cfset get_subscription_type=InvoiceSale.GET_SUBSCRIPTION_TYPE() />
		<cfset get_all_tax=InvoiceSale.GET_ALL_TAX() />
		<cfset get_all_otv=InvoiceSale.GET_ALL_OTV() />
		<cfset get_all_bsmv=InvoiceSale.GET_ALL_BSMV() />
		<cfset get_all_oiv=InvoiceSale.GET_ALL_OIV() />
		<cfset get_subscription_cat=InvoiceSale.GET_SUBSCRIPTION_CAT() />
		<cfif not isDefined("GET_SUBSCRIPTION_AUTHORITY")> 
			<!--- 20190927 abone kategorsine göre yetkilendirme için include edildiği sayfada çekilmiş olabilir bu nedenle kontrol ekledik Author: Tolga Sütlü, Ahmet Yolcu--->
			<cfset gsa = createObject("component","V16.objects.cfc.subscriptionNauthority")/>
			<cfset GET_SUBSCRIPTION_AUTHORITY= gsa.SelectAuthority()/>
		</cfif>	
		<CFSET otv_list ="">
		<cfset tax_list=valuelist(get_all_tax.TAX)>
		<cfloop query="get_all_otv">
			<CFSET otv_list = listappend(otv_list,get_all_otv.tax)>
		</cfloop>
		<cfset bsmv_list=valuelist(get_all_bsmv.tax)>
		<cfset oiv_list=valuelist(get_all_oiv.tax)>
		<cfset var_process_type = '50,52,53,56,57,58,62,66,532,531,561,48,121,69,533,640,680,5311'>
		<cfquery name="get_process_cat" datasource="#dsn3#">
			SELECT PROCESS_CAT_ID,PROCESS_CAT,PROCESS_TYPE FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (<cfqueryparam list="yes" value="#var_process_type#">) ORDER BY PROCESS_CAT
		</cfquery>
		<cfquery name="get_our_companies" datasource="#dsn#">
			SELECT 
				DISTINCT
				SP.OUR_COMPANY_ID
			FROM
				EMPLOYEE_POSITIONS EP,
				SETUP_PERIOD SP,
				EMPLOYEE_POSITION_PERIODS EPP,
				OUR_COMPANY O
			WHERE 
				SP.OUR_COMPANY_ID = O.COMP_ID AND
				SP.PERIOD_ID = EPP.PERIOD_ID AND
				EP.POSITION_ID = EPP.POSITION_ID AND
				EP.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
		</cfquery>
		<cfquery name="get_comp_category" datasource="#dsn#">
			SELECT
				COMPANYCAT_ID CATEGORY_ID, 
				COMPANYCAT CATEGORY_NAME
			FROM
				COMPANY_CAT
			WHERE
				COMPANYCAT_ID IN (SELECT COMPANYCAT_ID FROM COMPANY_CAT_OUR_COMPANY WHERE OUR_COMPANY_ID IN (#valuelist(get_our_companies.our_company_id,',')#))
		</cfquery>
		<cfquery name="get_cons_category" datasource="#dsn#">
			SELECT
				CONSCAT_ID CATEGORY_ID, 
				CONSCAT CATEGORY_NAME
			FROM
				CONSUMER_CAT
			WHERE
				CONSCAT_ID IN (SELECT CONSCAT_ID  FROM CONSUMER_CAT_OUR_COMPANY WHERE OUR_COMPANY_ID IN (#valuelist(get_our_companies.our_company_id,',')#))
			ORDER BY
				HIERARCHY	
		</cfquery>
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
				B.BRANCH_ID IN(SELECT BRANCH_ID FROM  EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) 
		</cfquery>
		<cfquery name="get_all_department" datasource="#dsn#">
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
				B.BRANCH_ID IN(SELECT BRANCH_ID FROM  EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) 
		</cfquery>
		<cfset branch_dep_list=valuelist(get_all_department.department_id,',')>
		<cfset var_invoice_cat = '50,52,53,56,57,58,62,66,532,531,561,48,121,69,533,5311'>
		<cfprocessingdirective suppresswhitespace="yes">
		<cfif isdefined("attributes.form_varmi")>
			<cfquery name="get_add_info_name" datasource="#dsn3#">
				SELECT
					   PROPERTY,PROPERTY_NAME 
					FROM
					(
						select * from SETUP_PRO_INFO_PLUS_NAMES where OWNER_TYPE_ID = -32
					 ) t
						UNPIVOT
						(
							PROPERTY_NAME FOR PROPERTY IN
						(
							<cfloop from="1" to ="40" index="i">
								PROPERTY#i#_NAME <cfif i neq 40>,</cfif>
							</cfloop>
						) 
					) AS U
			</cfquery>
			
			<cfquery name="get_add_info_name1" datasource="#dsn3#">
				SELECT
					   PROPERTY,PROPERTY_NAME 
					FROM
					(
						select * from SETUP_PRO_INFO_PLUS_NAMES where OWNER_TYPE_ID = -19
					 ) t
						UNPIVOT
						(
							PROPERTY_NAME FOR PROPERTY IN
						(
							<cfloop from="1" to ="40" index="i">
								PROPERTY#i#_NAME <cfif i neq 40>,</cfif>
							</cfloop>
						) 
					) AS U
			</cfquery>
			
			<cfif isdate(attributes.startdate)>
				<cf_date tarih = "attributes.startdate">
			</cfif>
			<cfif isdate(attributes.finishdate)>
				<cf_date tarih = "attributes.finishdate">
			</cfif>
			<cfset kurumsal = ''>
			<cfset bireysel = ''>
			<cfif listlen(attributes.category_id)>
				<cfset uzunluk=listlen(attributes.category_id)>
				<cfloop from="1" to="#uzunluk#" index="catyp">
					<cfset eleman = listgetat(attributes.category_id,catyp,',')>
					<cfif listlen(eleman) and listfirst(eleman,'-') eq 1>
						<cfset kurumsal = listappend(kurumsal,listlast(eleman,'-'))>
					<cfelseif listlen(eleman) and listfirst(eleman,'-') eq 2>
						<cfset bireysel = listappend(bireysel,listlast(eleman,'-'))>
					</cfif>
				</cfloop>
			</cfif>
			<cfquery name="get_invoice_detail" datasource="#dsn2#">
				<cfif not(len(bireysel) and not len(kurumsal)) and  not (isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isdefined("attributes.company") and len(attributes.company))>
					SELECT 
						INVOICE.INVOICE_ID AS ACTION_ID,
						INVOICE.INVOICE_NUMBER  AS BELGE_NO,
						INVOICE.SERIAL_NUMBER AS SERIAL_NUMBER,
						INVOICE.SERIAL_NO AS SERIAL_NO,
						INVOICE.INVOICE_DATE AS ACTION_DATE,
						INVOICE.NETTOTAL,
						ISNULL(INVOICE.TAXTOTAL,0) AS TAXTOTAL,
						ISNULL(INVOICE.OTV_TOTAL,0) AS OTV_TOTAL,				
						INVOICE.GROSSTOTAL,
						INVOICE.SA_DISCOUNT,
						INVOICE.ROUND_MONEY,
						INVOICE.INVOICE_CAT,
						INVOICE.ACC_DEPARTMENT_ID,
						INVOICE.IS_TAX_OF_OTV,
						INVOICE.PROJECT_ID,
						INVOICE.DUE_DATE,
						IR.ROW_PROJECT_ID,	
						ISNULL(IR.OTVTOTAL,0) AS OTVTOTAL,					
						IR.OTV_ORAN,			
						CASE WHEN INVOICE.SA_DISCOUNT=0 THEN IR.OTVTOTAL ELSE ((1- INVOICE.SA_DISCOUNT/(INVOICE.NETTOTAL-INVOICE.OTV_TOTAL-INVOICE.TAXTOTAL-INVOICE.BSMV_TOTAL+INVOICE.SA_DISCOUNT))* IR.OTVTOTAL) END AS ROW_OTVTOTAL,
						CASE WHEN INVOICE.SA_DISCOUNT=0 THEN IR.TAXTOTAL ELSE ((1- INVOICE.SA_DISCOUNT/(INVOICE.NETTOTAL-INVOICE.OTV_TOTAL-INVOICE.TAXTOTAL-INVOICE.BSMV_TOTAL+INVOICE.SA_DISCOUNT))* IR.TAXTOTAL) END AS ROW_TAXTOTAL,
						IR.TAX,
						IR.DISCOUNTTOTAL,
						IR.NETTOTAL AS KDVSIZ_TOPLAM,
						SC.SUBSCRIPTION_HEAD AS SUBS_NAME,
						SC.SUBSCRIPTION_NO,
						INVOICE.SHIP_ADDRESS,
						<cfif attributes.report_type eq 2>
							ISNULL(IR.NAME_PRODUCT,DESCRIPTION) AS PRODUCT_NAME,
							'' NOTE,
						<cfelse>
							INVOICE.NOTE NOTE,
						</cfif>
						C.FULLNAME,
						C.MEMBER_CODE,
						C.OZEL_KOD,
						C.TAXOFFICE,
						C.TAXNO,
						(SELECT TC_IDENTITY FROM #dsn_alias#.COMPANY_PARTNER CP WHERE C.COMPANY_ID = CP.COMPANY_ID AND CP.PARTNER_ID = C.MANAGER_PARTNER_ID) AS TC_IDENTY_NO,
						0 AS TYPE,
						INVOICE.PROCESS_CAT,
						IR.PRODUCT_ID,
						IR.AMOUNT ROW_QUANTITY,
						ISNULL(IR.UNIT,'Adet') UNIT,
						PC.PRODUCT_CATID,
						PC.PRODUCT_CAT,
						<cfif isdefined("attributes.list_type") and listfind(attributes.list_type,11)>
							<cfloop from="1" to="40" index="i">
								INVOICE_INFO_PLUS.PROPERTY#i#,
							</cfloop>
						</cfif>
						<cfif attributes.report_type eq 2>
							ISNULL(IR.DELIVER_DEPT,INVOICE.DEPARTMENT_ID) ROW_DEPT,
							ISNULL(IR.DELIVER_LOC,INVOICE.DEPARTMENT_LOCATION) ROW_LOC
						<cfelse>
							INVOICE.DEPARTMENT_ID ROW_DEPT,
							INVOICE.DEPARTMENT_LOCATION ROW_LOC
						</cfif>
						<cfif attributes.report_type eq 2>
							,(SELECT ACCOUNT_ID FROM #dsn3_alias#.INVENTORY WHERE INVENTORY.INVENTORY_ID = IR.INVENTORY_ID) ACCOUNT_ID
						</cfif>
						,IR.BSMV_RATE,	
						ISNULL(INVOICE.BSMV_TOTAL,0) AS BSMV_TOTAL,
						ISNULL(IR.BSMV_AMOUNT,0) AS BSMVTOTAL,
						IR.BSMV_AMOUNT AS ROW_BSMVTOTAL,
						IR.OIV_RATE,
						ISNULL(IR.OIV_AMOUNT,0) AS OIVTOTAL,	
						ISNULL(INVOICE.OIV_TOTAL,0) AS OIV_TOTAL,
						IR.OIV_AMOUNT AS ROW_OIVTOTAL
						<cfif attributes.report_type eq 2 and isdefined("attributes.list_type") and listfind(attributes.list_type,16)>
							,P.PRODUCT_CODE_2
						</cfif>
					FROM
						INVOICE JOIN
						INVOICE_ROW IR ON INVOICE.INVOICE_ID = IR.INVOICE_ID
						LEFT JOIN #dsn3_alias#.SUBSCRIPTION_CONTRACT SC ON INVOICE.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID
						LEFT JOIN #dsn3_alias#.SETUP_SUBSCRIPTION_TYPE SST ON SC.SUBSCRIPTION_TYPE_ID = SST.SUBSCRIPTION_TYPE_ID
						<cfif isdefined("attributes.list_type") and listfind(attributes.list_type,11) >
							LEFT JOIN INVOICE_INFO_PLUS  ON INVOICE.INVOICE_ID=INVOICE_INFO_PLUS.INVOICE_ID
						</cfif>
						<cfif (session.ep.our_company_info.is_efatura)>
							LEFT JOIN EINVOICE_RELATION ER ON ER.ACTION_ID = INVOICE.INVOICE_ID AND ER.ACTION_TYPE = 'INVOICE'
							LEFT JOIN EINVOICE_RECEIVING_DETAIL ERD ON ERD.INVOICE_ID = INVOICE.INVOICE_ID
							LEFT JOIN #dsn3_alias#.SETUP_PROCESS_CAT SPC ON SPC.PROCESS_CAT_ID = INVOICE.PROCESS_CAT
						</cfif>
						,#dsn_alias#.COMPANY C,
						#dsn3_alias#.PRODUCT P,
						#dsn3_alias#.PRODUCT_CAT PC
					WHERE
						INVOICE.COMPANY_ID = C.COMPANY_ID
						<cfif len(attributes.use_efatura) and attributes.use_efatura neq 5>
							AND C.USE_EFATURA = 1 
							AND C.EFATURA_DATE <= INVOICE.INVOICE_DATE 
							<cfif attributes.use_efatura eq 1>
								AND ER.STATUS IS NULL
								AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = INVOICE.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE') = 0
								AND SPC.INVOICE_TYPE_CODE IS NOT NULL
								AND INVOICE.INVOICE_DATE  >= #createodbcdatetime(session.ep.our_company_info.efatura_date)#
							<cfelseif attributes.use_efatura eq 2>
								AND 
								(
									(
										(SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = INVOICE.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE') > 0 
										AND ER.PATH IS NOT NULL
									)
									OR
									(SELECT COUNT(RECEIVING_DETAIL_ID) FROM EINVOICE_RECEIVING_DETAIL ESD WHERE ESD.INVOICE_ID = INVOICE.INVOICE_ID) > 0
								)
							<cfelseif attributes.use_efatura eq 3>
								AND ER.STATUS = 1
							<cfelseif attributes.use_efatura eq 4>
								AND ER.STATUS = 0
							</cfif>
						<cfelseif attributes.use_efatura eq 5>
							AND (C.USE_EFATURA = 0 OR C.EFATURA_DATE > INVOICE.INVOICE_DATE )
						</cfif>
						AND IR.PRODUCT_ID=P.PRODUCT_ID
						AND PC.PRODUCT_CATID = P.PRODUCT_CATID
						<cfif len(attributes.process_type)>
							AND INVOICE.PROCESS_CAT IN (#attributes.process_type#)
						<cfelse>
							AND INVOICE.INVOICE_CAT IN (<cfqueryparam list="yes" value="#var_invoice_cat#">)
						</cfif>
						<cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_id) and len(ship_method_name)>
							AND INVOICE.SHIP_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_method_id#">
						</cfif>
						<cfif attributes.report_type eq 2>
							<cfif isdefined('attributes.project_id') and len(attributes.project_head) and len(attributes.project_id)>
								AND IR.ROW_PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
							</cfif>
						<cfelse>
							<cfif isdefined('attributes.project_id') and len(attributes.project_head) and len(attributes.project_id)>
								AND INVOICE.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
							</cfif>
						</cfif>
						AND INVOICE.IS_IPTAL = 0
						<cfif isDefined("attributes.startdate") and isdate(attributes.startdate) and isDefined("attributes.finishdate") and isdate(attributes.finishdate)>
							AND INVOICE.INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
						</cfif>	
						<cfif attributes.report_type eq 2>
							<cfif len(attributes.department_id)>
								AND (
								<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
									(ISNULL(IR.DELIVER_DEPT,INVOICE.DEPARTMENT_ID) = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND ISNULL(IR.DELIVER_LOC,DEPARTMENT_LOCATION) = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
									<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
								</cfloop>  
								) 
							<cfelseif len(branch_dep_list)>
								AND ISNULL(IR.DELIVER_DEPT,INVOICE.DEPARTMENT_ID) IN(#branch_dep_list#)	
							</cfif>
						<cfelse>
							<cfif len(attributes.department_id)>
								AND (
								<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
									(INVOICE.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND INVOICE.DEPARTMENT_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
									<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
								</cfloop>  
								) 
							<cfelseif len(branch_dep_list)>
								AND INVOICE.DEPARTMENT_ID IN(#branch_dep_list#)	
							</cfif>
						</cfif>
						<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company") and len(attributes.company)>
							AND INVOICE.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
						</cfif>
						<cfif len(kurumsal)>
							AND C.COMPANYCAT_ID IN (#kurumsal#)
						</cfif>
						<cfif len(attributes.subscription_type)>
							AND SST.SUBSCRIPTION_TYPE_ID IN (#attributes.subscription_type#)
						</cfif>
						<cfif isdefined("attributes.product_cat_id") and len(attributes.product_cat_id)>
							AND P.PRODUCT_CATID IN (#attributes.product_cat_id#)
						</cfif>
					UNION ALL
				</cfif>
				<cfif not(len(bireysel) and not len(kurumsal)) and  not (isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isdefined("attributes.company") and len(attributes.company))>
					SELECT 
						INVOICE.INVOICE_ID AS ACTION_ID,
						INVOICE.INVOICE_NUMBER  AS BELGE_NO,
						INVOICE.SERIAL_NUMBER AS SERIAL_NUMBER,
						INVOICE.SERIAL_NO AS SERIAL_NO,
						INVOICE.INVOICE_DATE AS ACTION_DATE,
						INVOICE.NETTOTAL,
						ISNULL(INVOICE.TAXTOTAL,0) AS TAXTOTAL,
						ISNULL(INVOICE.OTV_TOTAL,0) AS OTV_TOTAL,					
						INVOICE.GROSSTOTAL,
						INVOICE.SA_DISCOUNT,
						INVOICE.ROUND_MONEY,
						INVOICE.INVOICE_CAT,
						INVOICE.ACC_DEPARTMENT_ID,
						INVOICE.IS_TAX_OF_OTV,
						INVOICE.PROJECT_ID,
						INVOICE.DUE_DATE,
						IR.ROW_PROJECT_ID,				
						ISNULL(IR.OTVTOTAL,0) AS OTVTOTAL,
						IR.OTV_ORAN,				
						CASE WHEN INVOICE.SA_DISCOUNT=0 THEN IR.OTVTOTAL ELSE ((1- INVOICE.SA_DISCOUNT/(INVOICE.NETTOTAL-INVOICE.OTV_TOTAL-INVOICE.TAXTOTAL-INVOICE.BSMV_TOTAL+INVOICE.SA_DISCOUNT))* IR.OTVTOTAL) END AS ROW_OTVTOTAL,
						CASE WHEN INVOICE.SA_DISCOUNT=0 THEN IR.TAXTOTAL ELSE ((1- INVOICE.SA_DISCOUNT/(INVOICE.NETTOTAL-INVOICE.OTV_TOTAL-INVOICE.TAXTOTAL-INVOICE.BSMV_TOTAL+INVOICE.SA_DISCOUNT))* IR.TAXTOTAL) END AS ROW_TAXTOTAL,
					--	IR.TAXTOTAL AS ROW_TAXTOTAL,
						IR.TAX,
						IR.DISCOUNTTOTAL,
						IR.NETTOTAL AS KDVSIZ_TOPLAM,
						SC.SUBSCRIPTION_HEAD AS SUBS_NAME,
						SC.SUBSCRIPTION_NO,
						INVOICE.SHIP_ADDRESS,
						<cfif attributes.report_type eq 2>
							ISNULL(IR.NAME_PRODUCT,DESCRIPTION) AS PRODUCT_NAME,
							'' NOTE,
						<cfelse>
							INVOICE.NOTE NOTE,
						</cfif>
						C.FULLNAME,
						C.MEMBER_CODE,
						C.OZEL_KOD,
						C.TAXOFFICE,
						C.TAXNO,
						(SELECT TC_IDENTITY FROM #dsn_alias#.COMPANY_PARTNER CP WHERE C.COMPANY_ID = CP.COMPANY_ID AND CP.PARTNER_ID = C.MANAGER_PARTNER_ID) AS TC_IDENTY_NO,
						0 AS TYPE,
						INVOICE.PROCESS_CAT,
						IR.PRODUCT_ID,
						IR.AMOUNT ROW_QUANTITY,
						ISNULL(IR.UNIT,'Adet') UNIT,
						0 AS PRODUCT_CATID,
						NULL AS PRODUCT_CAT,
						<cfif isdefined("attributes.list_type")and  listfind(attributes.list_type,11) >
							<cfloop from="1" to="40" index="i">
								INVOICE_INFO_PLUS.PROPERTY#i#,
							</cfloop>
						</cfif>
						<cfif attributes.report_type eq 2>
							ISNULL(IR.DELIVER_DEPT,INVOICE.DEPARTMENT_ID) ROW_DEPT,
							ISNULL(IR.DELIVER_LOC,INVOICE.DEPARTMENT_LOCATION) ROW_LOC
						<cfelse>
							INVOICE.DEPARTMENT_ID ROW_DEPT,
							INVOICE.DEPARTMENT_LOCATION ROW_LOC
						</cfif>
						<cfif attributes.report_type eq 2>
							,(SELECT ACCOUNT_ID FROM #dsn3_alias#.INVENTORY WHERE INVENTORY.INVENTORY_ID = IR.INVENTORY_ID) ACCOUNT_ID
						</cfif>
						,ISNULL(INVOICE.BSMV_TOTAL,0) AS BSMV_TOTAL,
						ISNULL(IR.BSMV_AMOUNT,0) AS BSMVTOTAL,
						IR.BSMV_RATE,
						IR.BSMV_AMOUNT AS ROW_BSMVTOTAL,
						ISNULL(IR.OIV_AMOUNT,0) AS OIVTOTAL,	
						ISNULL(INVOICE.OIV_TOTAL,0) AS OIV_TOTAL,
						IR.OIV_AMOUNT AS ROW_OIVTOTAL,
						IR.OIV_RATE
						<cfif attributes.report_type eq 2 and isdefined("attributes.list_type") and listfind(attributes.list_type,16)>
							,'' PRODUCT_CODE_2
						</cfif>
					FROM
						INVOICE JOIN
						INVOICE_ROW IR ON INVOICE.INVOICE_ID = IR.INVOICE_ID
						LEFT JOIN #dsn3_alias#.SUBSCRIPTION_CONTRACT SC ON INVOICE.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID
						LEFT JOIN #dsn3_alias#.SETUP_SUBSCRIPTION_TYPE SST ON SC.SUBSCRIPTION_TYPE_ID = SST.SUBSCRIPTION_TYPE_ID
						<cfif isdefined("attributes.list_type") and listfind(attributes.list_type,11)>
							LEFT JOIN INVOICE_INFO_PLUS  ON INVOICE.INVOICE_ID=INVOICE_INFO_PLUS.INVOICE_ID
						</cfif>
						<cfif (session.ep.our_company_info.is_efatura)>
							LEFT JOIN EINVOICE_RELATION ER ON ER.ACTION_ID = INVOICE.INVOICE_ID AND ER.ACTION_TYPE = 'INVOICE'
							LEFT JOIN EINVOICE_RECEIVING_DETAIL ERD ON ERD.INVOICE_ID = INVOICE.INVOICE_ID
							LEFT JOIN #dsn3_alias#.SETUP_PROCESS_CAT SPC ON SPC.PROCESS_CAT_ID = INVOICE.PROCESS_CAT
						</cfif>
						,#dsn_alias#.COMPANY C
					WHERE
						INVOICE.COMPANY_ID = C.COMPANY_ID	
						<cfif len(attributes.use_efatura) and attributes.use_efatura neq 5>
							AND C.USE_EFATURA = 1 
							AND C.EFATURA_DATE <= INVOICE.INVOICE_DATE 
							<cfif attributes.use_efatura eq 1>
								AND ER.STATUS IS NULL
								AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = INVOICE.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE') = 0
								AND SPC.INVOICE_TYPE_CODE IS NOT NULL
								AND INVOICE.INVOICE_DATE  >= #createodbcdatetime(session.ep.our_company_info.efatura_date)#
							<cfelseif attributes.use_efatura eq 2>
								AND 
								(
									(
										(SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = INVOICE.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE') > 0 
										AND ER.PATH IS NOT NULL
									)
									OR
									(SELECT COUNT(RECEIVING_DETAIL_ID) FROM EINVOICE_RECEIVING_DETAIL ESD WHERE ESD.INVOICE_ID = INVOICE.INVOICE_ID) > 0
								)
							<cfelseif attributes.use_efatura eq 3>
								AND ER.STATUS = 1
							<cfelseif attributes.use_efatura eq 4>
								AND ER.STATUS = 0
							</cfif>
						<cfelseif attributes.use_efatura eq 5>
							AND (C.USE_EFATURA = 0 OR C.EFATURA_DATE > INVOICE.INVOICE_DATE )
						</cfif>
						AND IR.PRODUCT_ID IS NULL
						<cfif len(attributes.process_type)>
							AND INVOICE.PROCESS_CAT IN (#attributes.process_type#)
						<cfelse>
							AND INVOICE.INVOICE_CAT IN (66)
						</cfif>
						<cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_id) and len(ship_method_name)>
							AND INVOICE.SHIP_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_method_id#">
						</cfif>
						<cfif attributes.report_type eq 2>
							<cfif isdefined('attributes.project_id') and len(attributes.project_head) and len(attributes.project_id)>
								AND IR.ROW_PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
							</cfif>
						<cfelse>
							<cfif isdefined('attributes.project_id') and len(attributes.project_head) and len(attributes.project_id)>
								AND INVOICE.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
							</cfif>
						</cfif>
						AND INVOICE.IS_IPTAL = 0
						<cfif isDefined("attributes.startdate") and isdate(attributes.startdate) and isDefined("attributes.finishdate") and isdate(attributes.finishdate)>
							AND INVOICE.INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
						</cfif>
						<cfif attributes.report_type eq 2>
							<cfif len(attributes.department_id)>
								AND (
								<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
									(ISNULL(IR.DELIVER_DEPT,INVOICE.DEPARTMENT_ID) = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND ISNULL(IR.DELIVER_LOC,DEPARTMENT_LOCATION) = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
									<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
								</cfloop>  
								) 
							<cfelseif len(branch_dep_list)>
								AND ISNULL(IR.DELIVER_DEPT,INVOICE.DEPARTMENT_ID) IN(#branch_dep_list#)	
							</cfif>
						<cfelse>
							<cfif len(attributes.department_id)>
								AND (
								<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
									(INVOICE.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND INVOICE.DEPARTMENT_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
									<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
								</cfloop>  
								) 
							<cfelseif len(branch_dep_list)>
								AND INVOICE.DEPARTMENT_ID IN(#branch_dep_list#)	
							</cfif>
						</cfif>
						<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company") and len(attributes.company)>
							AND INVOICE.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
						</cfif>
						<cfif len(kurumsal)>
							AND C.COMPANYCAT_ID IN (#kurumsal#)
						</cfif>
						<cfif len(attributes.subscription_type)>
							AND SST.SUBSCRIPTION_TYPE_ID IN (#attributes.subscription_type#) 
						</cfif>
					UNION ALL
				</cfif>
				<cfif not(len(kurumsal) and not len(bireysel)) and  not (isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company") and len(attributes.company))>
					SELECT 
						INVOICE.INVOICE_ID AS ACTION_ID,
						INVOICE.INVOICE_NUMBER  AS BELGE_NO,
						INVOICE.SERIAL_NUMBER AS SERIAL_NUMBER,
						INVOICE.SERIAL_NO AS SERIAL_NO,
						INVOICE.INVOICE_DATE AS ACTION_DATE,
						INVOICE.NETTOTAL,
						ISNULL(INVOICE.TAXTOTAL,0) AS TAXTOTAL,
						ISNULL(INVOICE.OTV_TOTAL,0) AS OTV_TOTAL,				
						INVOICE.GROSSTOTAL,
						INVOICE.SA_DISCOUNT,
						INVOICE.ROUND_MONEY,
						INVOICE.INVOICE_CAT,
						INVOICE.ACC_DEPARTMENT_ID,
						INVOICE.IS_TAX_OF_OTV,
						INVOICE.PROJECT_ID,
						INVOICE.DUE_DATE,
						IR.ROW_PROJECT_ID,				
						ISNULL(IR.OTVTOTAL,0) AS OTVTOTAL,				
						IR.OTV_ORAN,									
						CASE WHEN INVOICE.SA_DISCOUNT=0 THEN IR.OTVTOTAL ELSE ((1- INVOICE.SA_DISCOUNT/(INVOICE.NETTOTAL-INVOICE.OTV_TOTAL-INVOICE.TAXTOTAL-INVOICE.BSMV_TOTAL+INVOICE.SA_DISCOUNT))* IR.OTVTOTAL) END AS ROW_OTVTOTAL,
						CASE WHEN INVOICE.SA_DISCOUNT=0 THEN IR.TAXTOTAL ELSE ((1- INVOICE.SA_DISCOUNT/(INVOICE.NETTOTAL-INVOICE.OTV_TOTAL-INVOICE.TAXTOTAL-INVOICE.BSMV_TOTAL+INVOICE.SA_DISCOUNT))* IR.TAXTOTAL) END AS ROW_TAXTOTAL,
					--	IR.TAXTOTAL AS ROW_TAXTOTAL,
						IR.TAX,
						IR.DISCOUNTTOTAL,
						IR.NETTOTAL AS KDVSIZ_TOPLAM,
						SC.SUBSCRIPTION_HEAD AS SUBS_NAME,
						SC.SUBSCRIPTION_NO,
						INVOICE.SHIP_ADDRESS,
						<cfif attributes.report_type eq 2>
							ISNULL(IR.NAME_PRODUCT,DESCRIPTION) AS PRODUCT_NAME,
							'' NOTE,
						<cfelse>
							INVOICE.NOTE NOTE,
						</cfif>
						C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME AS FULLNAME,
						C.MEMBER_CODE,
						C.OZEL_KOD,
						C.TAX_OFFICE TAXOFFICE,
						C.TAX_NO TAXNO,
						C.TC_IDENTY_NO,
						0 AS TYPE,
						INVOICE.PROCESS_CAT,
						IR.PRODUCT_ID,
						IR.AMOUNT ROW_QUANTITY,
						ISNULL(IR.UNIT,'Adet') UNIT,
						PC.PRODUCT_CATID,
						PC.PRODUCT_CAT,
						<cfif isdefined("attributes.list_type") and listfind(attributes.list_type,11)>
							<cfloop from="1" to="40" index="i">
								INVOICE_INFO_PLUS.PROPERTY#i#,
							</cfloop>
						</cfif>
						<cfif attributes.report_type eq 2>
							ISNULL(IR.DELIVER_DEPT,INVOICE.DEPARTMENT_ID) ROW_DEPT,
							ISNULL(IR.DELIVER_LOC,INVOICE.DEPARTMENT_LOCATION) ROW_LOC
						<cfelse>
							INVOICE.DEPARTMENT_ID ROW_DEPT,
							INVOICE.DEPARTMENT_LOCATION ROW_LOC
						</cfif>
						<cfif attributes.report_type eq 2>
							,(SELECT ACCOUNT_ID FROM #dsn3_alias#.INVENTORY WHERE INVENTORY.INVENTORY_ID = IR.INVENTORY_ID) ACCOUNT_ID
						</cfif>
						,ISNULL(IR.BSMV_AMOUNT,0) AS BSMVTOTAL,	
						ISNULL(INVOICE.BSMV_TOTAL,0) AS BSMV_TOTAL,
						IR.BSMV_RATE,
						IR.BSMV_AMOUNT AS ROW_BSMVTOTAL,
						ISNULL(IR.OIV_AMOUNT,0) AS OIVTOTAL,	
						ISNULL(INVOICE.OIV_TOTAL,0) AS OIV_TOTAL,
						IR.OIV_AMOUNT AS ROW_OIVTOTAL,
						IR.OIV_RATE
						<cfif attributes.report_type eq 2 and isdefined("attributes.list_type") and listfind(attributes.list_type,16)>
							,P.PRODUCT_CODE_2
						</cfif>
					FROM
						INVOICE JOIN 
						INVOICE_ROW IR ON INVOICE.INVOICE_ID = IR.INVOICE_ID
						LEFT JOIN #dsn3_alias#.SUBSCRIPTION_CONTRACT SC ON INVOICE.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID
						LEFT JOIN #dsn3_alias#.SETUP_SUBSCRIPTION_TYPE SST ON SC.SUBSCRIPTION_TYPE_ID = SST.SUBSCRIPTION_TYPE_ID
						<cfif isdefined("attributes.list_type") and listfind(attributes.list_type,11)>
							LEFT JOIN INVOICE_INFO_PLUS  ON INVOICE.INVOICE_ID=INVOICE_INFO_PLUS.INVOICE_ID
						</cfif>
						<cfif (session.ep.our_company_info.is_efatura)>
							LEFT JOIN EINVOICE_RELATION ER ON ER.ACTION_ID = INVOICE.INVOICE_ID AND ER.ACTION_TYPE = 'INVOICE'
							LEFT JOIN EINVOICE_RECEIVING_DETAIL ERD ON ERD.INVOICE_ID = INVOICE.INVOICE_ID
							LEFT JOIN #dsn3_alias#.SETUP_PROCESS_CAT SPC ON SPC.PROCESS_CAT_ID = INVOICE.PROCESS_CAT
						</cfif>
						,#dsn_alias#.CONSUMER C,
						#dsn3_alias#.PRODUCT P,
						#dsn3_alias#.PRODUCT_CAT PC
					WHERE
						INVOICE.CONSUMER_ID = C.CONSUMER_ID	
						<cfif len(attributes.use_efatura) and attributes.use_efatura neq 5>
							AND C.USE_EFATURA = 1 
							AND C.EFATURA_DATE <= INVOICE.INVOICE_DATE 
							<cfif attributes.use_efatura eq 1>
								AND ER.STATUS IS NULL
								AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = INVOICE.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE') = 0
								AND SPC.INVOICE_TYPE_CODE IS NOT NULL
								AND INVOICE.INVOICE_DATE >= #createodbcdatetime(session.ep.our_company_info.efatura_date)#
							<cfelseif attributes.use_efatura eq 2>
								AND 
								(
									(
										(SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = INVOICE.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE') > 0 
										AND ER.PATH IS NOT NULL
									)
									OR
									(SELECT COUNT(RECEIVING_DETAIL_ID) FROM EINVOICE_RECEIVING_DETAIL ESD WHERE ESD.INVOICE_ID = INVOICE.INVOICE_ID) > 0
								)
							<cfelseif attributes.use_efatura eq 3>
								AND ER.STATUS = 1
							<cfelseif attributes.use_efatura eq 4>
								AND ER.STATUS = 0
							</cfif>
						<cfelseif attributes.use_efatura eq 5>
							AND (C.USE_EFATURA = 0 OR C.EFATURA_DATE > INVOICE.INVOICE_DATE )
						</cfif>	
						AND IR.PRODUCT_ID=P.PRODUCT_ID
						AND PC.PRODUCT_CATID=P.PRODUCT_CATID
						<cfif len(attributes.process_type)>
							AND INVOICE.PROCESS_CAT IN (#attributes.process_type#)
						<cfelse>
							AND INVOICE.INVOICE_CAT IN (<cfqueryparam list="yes" value="#var_invoice_cat#">)
						</cfif>		
						<cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_id) and len(ship_method_name)>
							AND INVOICE.SHIP_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_method_id#">
						</cfif>	
						<cfif attributes.report_type eq 2>
							<cfif isdefined('attributes.project_id') and len(attributes.project_head) and len(attributes.project_id)>
								AND IR.ROW_PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
							</cfif>				
						<cfelse>
							<cfif isdefined('attributes.project_id') and len(attributes.project_head) and len(attributes.project_id)>
								AND INVOICE.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
							</cfif>				
						</cfif>
						AND INVOICE.IS_IPTAL = 0
						<cfif isDefined("attributes.startdate") and isdate(attributes.startdate) and isDefined("attributes.finishdate") and isdate(attributes.finishdate)>
							AND INVOICE.INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
						</cfif>	
						<cfif attributes.report_type eq 2>
							<cfif len(attributes.department_id)>
								AND (
								<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
									(ISNULL(IR.DELIVER_DEPT,INVOICE.DEPARTMENT_ID) = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND ISNULL(IR.DELIVER_LOC,DEPARTMENT_LOCATION) = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
									<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
								</cfloop>  
								) 
							<cfelseif len(branch_dep_list)>
								AND ISNULL(IR.DELIVER_DEPT,INVOICE.DEPARTMENT_ID) IN(#branch_dep_list#)	
							</cfif>
						<cfelse>
							<cfif len(attributes.department_id)>
								AND (
								<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
									(INVOICE.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND INVOICE.DEPARTMENT_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
									<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
								</cfloop>  
								) 
							<cfelseif len(branch_dep_list)>
								AND INVOICE.DEPARTMENT_ID IN(#branch_dep_list#)	
							</cfif>
						</cfif>
						<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isdefined("attributes.company") and len(attributes.company)>
							AND INVOICE.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
						</cfif>
						<cfif len(bireysel)>
							AND C.CONSUMER_CAT_ID IN (#bireysel#)
						</cfif>
						<cfif len(attributes.subscription_type)>
							AND SST.SUBSCRIPTION_TYPE_ID IN (#attributes.subscription_type#) 
						</cfif>
						<cfif isdefined("attributes.product_cat_id") and len(attributes.product_cat_id)>
							AND P.PRODUCT_CATID IN (#attributes.product_cat_id#)
						</cfif>
					UNION ALL
				</cfif>
				<cfif not(len(kurumsal) and not len(bireysel)) and  not (isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company") and len(attributes.company))>
					SELECT 
						INVOICE.INVOICE_ID AS ACTION_ID,
						INVOICE.INVOICE_NUMBER  AS BELGE_NO,
						INVOICE.SERIAL_NUMBER AS SERIAL_NUMBER,
						INVOICE.SERIAL_NO AS SERIAL_NO,
						INVOICE.INVOICE_DATE AS ACTION_DATE,
						INVOICE.NETTOTAL,
						ISNULL(INVOICE.TAXTOTAL,0) AS TAXTOTAL,
						ISNULL(INVOICE.OTV_TOTAL,0) AS OTV_TOTAL,						
						INVOICE.GROSSTOTAL,
						INVOICE.SA_DISCOUNT,
						INVOICE.ROUND_MONEY,
						INVOICE.INVOICE_CAT,
						INVOICE.ACC_DEPARTMENT_ID,
						INVOICE.IS_TAX_OF_OTV,
						INVOICE.PROJECT_ID,
						INVOICE.DUE_DATE,
						IR.ROW_PROJECT_ID,					
						ISNULL(IR.OTVTOTAL,0) AS OTVTOTAL,						
						IR.OTV_ORAN,					
						CASE WHEN INVOICE.SA_DISCOUNT=0 THEN IR.OTVTOTAL ELSE ((1- INVOICE.SA_DISCOUNT/(INVOICE.NETTOTAL-INVOICE.OTV_TOTAL-INVOICE.TAXTOTAL-INVOICE.BSMV_TOTAL+INVOICE.SA_DISCOUNT))* IR.OTVTOTAL) END AS ROW_OTVTOTAL,
						CASE WHEN INVOICE.SA_DISCOUNT=0 THEN IR.TAXTOTAL ELSE ((1- INVOICE.SA_DISCOUNT/(INVOICE.NETTOTAL-INVOICE.OTV_TOTAL-INVOICE.TAXTOTAL-INVOICE.BSMV_TOTAL+INVOICE.SA_DISCOUNT))* IR.TAXTOTAL) END AS ROW_TAXTOTAL,
						--IR.TAXTOTAL AS ROW_TAXTOTAL,
						IR.TAX,
						IR.DISCOUNTTOTAL,
						IR.NETTOTAL AS KDVSIZ_TOPLAM,
						SC.SUBSCRIPTION_HEAD AS SUBS_NAME,
						SC.SUBSCRIPTION_NO,
						INVOICE.SHIP_ADDRESS,
						<cfif attributes.report_type eq 2>
							ISNULL(IR.NAME_PRODUCT,DESCRIPTION) AS PRODUCT_NAME,
							'' NOTE,
						<cfelse>
							INVOICE.NOTE NOTE,
						</cfif>
						C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME AS FULLNAME,
						C.MEMBER_CODE,
						C.OZEL_KOD,
						C.TAX_OFFICE TAXOFFICE,
						C.TAX_NO TAXNO,
						C.TC_IDENTY_NO,
						0 AS TYPE,
						INVOICE.PROCESS_CAT,
						IR.PRODUCT_ID,
						IR.AMOUNT ROW_QUANTITY,
						ISNULL(IR.UNIT,'Adet') UNIT,
						0 AS PRODUCT_CATID,
						NULL AS PRODUCT_CAT,
						<cfif isdefined("attributes.list_type") and listfind(attributes.list_type,11)>
							<cfloop from="1" to="40" index="i">
								INVOICE_INFO_PLUS.PROPERTY#i#,
							</cfloop>
						</cfif>
						<cfif attributes.report_type eq 2>
							ISNULL(IR.DELIVER_DEPT,INVOICE.DEPARTMENT_ID) ROW_DEPT,
							ISNULL(IR.DELIVER_LOC,INVOICE.DEPARTMENT_LOCATION) ROW_LOC
						<cfelse>
							INVOICE.DEPARTMENT_ID ROW_DEPT,
							INVOICE.DEPARTMENT_LOCATION ROW_LOC
						</cfif>
						<cfif attributes.report_type eq 2>
							,(SELECT ACCOUNT_ID FROM #dsn3_alias#.INVENTORY WHERE INVENTORY.INVENTORY_ID = IR.INVENTORY_ID) ACCOUNT_ID
						</cfif>
						,ISNULL(IR.BSMV_AMOUNT,0) AS BSMVTOTAL,	
						ISNULL(INVOICE.BSMV_TOTAL,0) AS BSMV_TOTAL,
						IR.BSMV_RATE,
						IR.BSMV_AMOUNT AS ROW_BSMVTOTAL,
						ISNULL(IR.OIV_AMOUNT,0) AS OIVTOTAL,	
						ISNULL(INVOICE.OIV_TOTAL,0) AS OIV_TOTAL,
						IR.OIV_AMOUNT AS ROW_OIVTOTAL,
						IR.OIV_RATE
						<cfif attributes.report_type eq 2 and isdefined("attributes.list_type") and listfind(attributes.list_type,16)>
							,'' PRODUCT_CODE_2
						</cfif>
					FROM
						INVOICE JOIN 
						INVOICE_ROW IR ON INVOICE.INVOICE_ID = IR.INVOICE_ID
						LEFT JOIN #dsn3_alias#.SUBSCRIPTION_CONTRACT SC ON INVOICE.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID	
						LEFT JOIN #dsn3_alias#.SETUP_SUBSCRIPTION_TYPE SST ON SC.SUBSCRIPTION_TYPE_ID = SST.SUBSCRIPTION_TYPE_ID
						 <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,11)>
							LEFT JOIN INVOICE_INFO_PLUS  ON INVOICE.INVOICE_ID=INVOICE_INFO_PLUS.INVOICE_ID
						</cfif>
						<cfif (session.ep.our_company_info.is_efatura)>
							LEFT JOIN EINVOICE_RELATION ER ON ER.ACTION_ID = INVOICE.INVOICE_ID AND ER.ACTION_TYPE = 'INVOICE'
							LEFT JOIN EINVOICE_RECEIVING_DETAIL ERD ON ERD.INVOICE_ID = INVOICE.INVOICE_ID
							LEFT JOIN #dsn3_alias#.SETUP_PROCESS_CAT SPC ON SPC.PROCESS_CAT_ID = INVOICE.PROCESS_CAT
						</cfif>
						,#dsn_alias#.CONSUMER C
					WHERE
						INVOICE.CONSUMER_ID = C.CONSUMER_ID		
						<cfif len(attributes.use_efatura) and attributes.use_efatura neq 5>
							AND C.USE_EFATURA = 1 
							AND C.EFATURA_DATE <= INVOICE.INVOICE_DATE 
							<cfif attributes.use_efatura eq 1>
								AND ER.STATUS IS NULL
								AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = INVOICE.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE') = 0
								AND SPC.INVOICE_TYPE_CODE IS NOT NULL
								AND INVOICE.INVOICE_DATE >= #createodbcdatetime(session.ep.our_company_info.efatura_date)#
							<cfelseif attributes.use_efatura eq 2>
								AND 
								(
									(
										(SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = INVOICE.INVOICE_ID AND ESD.ACTION_TYPE = 'INVOICE') > 0 
										AND ER.PATH IS NOT NULL
									)
									OR
									(SELECT COUNT(RECEIVING_DETAIL_ID) FROM EINVOICE_RECEIVING_DETAIL ESD WHERE ESD.INVOICE_ID = INVOICE.INVOICE_ID) > 0
								)
							<cfelseif attributes.use_efatura eq 3>
								AND ER.STATUS = 1
							<cfelseif attributes.use_efatura eq 4>
								AND ER.STATUS = 0
							</cfif>
						<cfelseif attributes.use_efatura eq 5>
							AND (C.USE_EFATURA = 0 OR C.EFATURA_DATE > INVOICE.INVOICE_DATE )
						</cfif>	
						AND IR.PRODUCT_ID IS NULL
						<cfif len(attributes.process_type)>
							AND INVOICE.PROCESS_CAT IN (#attributes.process_type#)
						<cfelse>
							AND INVOICE.INVOICE_CAT IN (66)
						</cfif>
						<cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_id) and len(ship_method_name)>
							AND INVOICE.SHIP_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_method_id#">
						</cfif>
						<cfif attributes.report_type eq 2>
							<cfif isdefined('attributes.project_id') and len(attributes.project_head) and len(attributes.project_id)>
								AND IR.ROW_PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
							</cfif>
						<cfelse>
							<cfif isdefined('attributes.project_id') and len(attributes.project_head) and len(attributes.project_id)>
								AND INVOICE.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
							</cfif>
						</cfif>
						AND INVOICE.IS_IPTAL = 0
						<cfif isDefined("attributes.startdate") and isdate(attributes.startdate) and isDefined("attributes.finishdate") and isdate(attributes.finishdate)>
							AND INVOICE.INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
						</cfif>	
						<cfif attributes.report_type eq 2>
							<cfif len(attributes.department_id)>
								AND (
								<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
									(ISNULL(IR.DELIVER_DEPT,INVOICE.DEPARTMENT_ID) = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND ISNULL(IR.DELIVER_LOC,DEPARTMENT_LOCATION) = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
									<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
								</cfloop>  
								) 
							<cfelseif len(branch_dep_list)>
								AND ISNULL(IR.DELIVER_DEPT,INVOICE.DEPARTMENT_ID) IN(#branch_dep_list#)	
							</cfif>
						<cfelse>
							<cfif len(attributes.department_id)>
								AND (
								<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
									(INVOICE.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND INVOICE.DEPARTMENT_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
									<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
								</cfloop>  
								) 
							<cfelseif len(branch_dep_list)>
								AND INVOICE.DEPARTMENT_ID IN(#branch_dep_list#)	
							</cfif>
						</cfif>
						<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isdefined("attributes.company") and len(attributes.company)>
							AND INVOICE.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
						</cfif>
						<cfif len(bireysel)>
							AND C.CONSUMER_CAT_ID IN (#bireysel#)
						</cfif>
						<cfif len(attributes.subscription_type)>
							AND SST.SUBSCRIPTION_TYPE_ID IN (#attributes.subscription_type#) 
						</cfif>
					UNION ALL
				</cfif>
				<cfif not(isdefined("attributes.ship_method_id") and len(attributes.ship_method_id) and len(attributes.ship_method_name))>
					<cfif not(len(bireysel) and not len(kurumsal)) and  not (isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isdefined("attributes.company") and len(attributes.company))>
						SELECT 
							E.EXPENSE_ID  AS ACTION_ID,
							E.PAPER_NO AS BELGE_NO,
							'' SERIAL_NUMBER,
							'' SERIAL_NO,
							E.EXPENSE_DATE AS ACTION_DATE,
							E.TOTAL_AMOUNT_KDVLI AS NETTOTAL,
							E.KDV_TOTAL AS TAXTOTAL,
							E.OTV_TOTAL AS OTV_TOTAL,							
							E.TOTAL_AMOUNT AS GROSSTOTAL,
							0 AS SA_DISCOUNT,
							0 AS ROUND_MONEY,
							E.ACTION_TYPE,
							E.ACC_DEPARTMENT_ID,
							0 AS IS_TAX_OF_OTV,
							E.PROJECT_ID,
							E.DUE_DATE,
							E_ROW.PROJECT_ID ROW_PROJECT_ID,							
							ISNULL(E_ROW.AMOUNT_OTV,0) AS OTVTOTAL,
							E_ROW.OTV_RATE AS OTV_ORAN,
							E_ROW.AMOUNT_OTV AS ROW_OTVTOTAL,						
							E_ROW.AMOUNT_KDV AS ROW_TAXTOTAL,
							CAST(E_ROW.KDV_RATE AS FLOAT) AS TAX,								
							0 AS DISCOUNTTOTAL,
							(E_ROW.AMOUNT*E_ROW.QUANTITY) AS KDVSIZ_TOPLAM,
							'' SUBS_NAME,
							'' SUBSCRIPTION_NO,
							'' AS SHIP_ADDRESS,
							<cfif attributes.report_type eq 2>
								' ' PRODUCT_NAME,
								E_ROW.DETAIL NOTE,
							<cfelse>
								E.DETAIL NOTE,
							</cfif>
							C.FULLNAME,
							C.MEMBER_CODE,
							C.OZEL_KOD,
							C.TAXOFFICE,
							C.TAXNO,
							(SELECT TC_IDENTITY FROM #dsn_alias#.COMPANY_PARTNER CP WHERE C.COMPANY_ID = CP.COMPANY_ID AND CP.PARTNER_ID = C.MANAGER_PARTNER_ID) AS TC_IDENTY_NO,
							1 AS TYPE,
							E.PROCESS_CAT,
							E_ROW.EXPENSE_ITEM_ID AS PRODUCT_ID,
							E_ROW.QUANTITY ROW_QUANTITY,
							ISNULL(E_ROW.UNIT,'Adet') AS UNIT, <!--- ürün secilmemiş satırlarda birim null geliyor --->
							EXPENSE_ITEMS.EXPENSE_ITEM_ID AS PRODUCT_CATID,
							EXPENSE_ITEMS.EXPENSE_ITEM_NAME AS PRODUCT_CAT,
							<cfif isdefined("attributes.list_type") and listfind(attributes.list_type,11)>
								<cfloop from="1" to="40" index="i">
									EXPENSE_ITEM_PLANS_INFO_PLUS.PROPERTY#i#,
								</cfloop>
							</cfif>
							E.DEPARTMENT_ID ROW_DEPT,
							E.LOCATION_ID ROW_LOC
							<cfif attributes.report_type eq 2>
							,'' ACCOUNT_ID
							</cfif>
							,E_ROW.BSMV_RATE AS BSMV_ORAN,
							E.BSMV_TOTAL AS BSMV_TOTAL,
							ISNULL(E_ROW.AMOUNT_BSMV,0) AS BSMVTOTAL,
							E_ROW.AMOUNT_BSMV AS ROW_BSMVTOTAL,
							E_ROW.OIV_RATE AS OIV_ORAN,
							E.OIV_TOTAL AS OIV_TOTAL,
							ISNULL(E_ROW.AMOUNT_OIV,0) AS OIV_TOTAL,
							E_ROW.AMOUNT_OIV AS ROW_OIVTOTAL
							<cfif attributes.report_type eq 2 and isdefined("attributes.list_type") and listfind(attributes.list_type,16)>
								,'' PRODUCT_CODE_2
							</cfif>
						FROM
							EXPENSE_ITEM_PLANS E JOIN 
							EXPENSE_ITEMS_ROWS E_ROW ON  E.EXPENSE_ID=E_ROW.EXPENSE_ID
							LEFT JOIN #dsn3_alias#.SUBSCRIPTION_CONTRACT SC ON E.SUBSCRIPTION_ID=SC.SUBSCRIPTION_ID
							LEFT JOIN #dsn3_alias#.SETUP_SUBSCRIPTION_TYPE SST ON SC.SUBSCRIPTION_TYPE_ID = SST.SUBSCRIPTION_TYPE_ID
							<cfif isdefined("attributes.list_type") and listfind(attributes.list_type,11)>
								LEFT JOIN EXPENSE_ITEM_PLANS_INFO_PLUS  ON E.EXPENSE_ID=EXPENSE_ITEM_PLANS_INFO_PLUS.EXPENSE_ID
							</cfif>
							<cfif (session.ep.our_company_info.is_efatura)>
								LEFT JOIN EINVOICE_RELATION ER ON ER.ACTION_ID = E.EXPENSE_ID AND ER.ACTION_TYPE = 'EXPENSE_ITEM_PLANS'
								LEFT JOIN EINVOICE_RECEIVING_DETAIL ERD ON ERD.EXPENSE_ID = E.EXPENSE_ID
								LEFT JOIN #dsn3_alias#.SETUP_PROCESS_CAT SPC ON SPC.PROCESS_CAT_ID = E.PROCESS_CAT
							</cfif>
							,#dsn_alias#.COMPANY C,
							EXPENSE_ITEMS
							<cfif len(attributes.product_cat_id)>
								,#dsn3_alias#.PRODUCT P
								,#dsn3_alias#.PRODUCT_CAT PC
							</cfif>
						WHERE                	
							E.CH_COMPANY_ID = C.COMPANY_ID AND 
							E.IS_IPTAL = 0
							<cfif len(attributes.use_efatura) and attributes.use_efatura neq 5>
								AND C.USE_EFATURA = 1 
								AND C.EFATURA_DATE <= E.EXPENSE_DATE 
								<cfif attributes.use_efatura eq 1>
									AND ER.STATUS IS NULL
									AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = E.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS') = 0
									AND SPC.INVOICE_TYPE_CODE IS NOT NULL
									AND E.EXPENSE_DATE >= #createodbcdatetime(session.ep.our_company_info.efatura_date)#
								<cfelseif attributes.use_efatura eq 2>
									AND 
									(
										(
											(SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = E.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS') > 0 
											AND ER.PATH IS NOT NULL
										)
										OR
										(SELECT COUNT(RECEIVING_DETAIL_ID) FROM EINVOICE_RECEIVING_DETAIL ESD WHERE ESD.EXPENSE_ID = E.EXPENSE_ID) > 0
									)
								<cfelseif attributes.use_efatura eq 3>
									AND ER.STATUS = 1
								<cfelseif attributes.use_efatura eq 4>
									AND ER.STATUS = 0
								</cfif>
							<cfelseif attributes.use_efatura eq 5>
								AND (C.USE_EFATURA = 0 OR C.EFATURA_DATE > E.EXPENSE_DATE)
							</cfif>	
							AND E_ROW.EXPENSE_ITEM_ID=EXPENSE_ITEMS.EXPENSE_ITEM_ID
							<cfif len(attributes.process_type)>
								AND E.PROCESS_CAT IN (#attributes.process_type#)
							<cfelse>
								AND E.ACTION_TYPE IN (121)
							</cfif>
							<cfif len(attributes.product_cat_id)>
								AND E_ROW.PRODUCT_ID=P.PRODUCT_ID
								AND PC.PRODUCT_CATID=P.PRODUCT_CATID
							</cfif>
							<cfif isDefined("attributes.startdate") and isdate(attributes.startdate) and isDefined("attributes.finishdate") and isdate(attributes.finishdate)>
								AND E.EXPENSE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
							</cfif>	
							<cfif attributes.report_type eq 2>
								<cfif isdefined('attributes.project_id') and len(attributes.project_head) and len(attributes.project_id)>
									AND E_ROW.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
								</cfif>
							<cfelse>
								<cfif isdefined('attributes.project_id') and len(attributes.project_head) and len(attributes.project_id)>
									AND E.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
								</cfif>
							</cfif>
							<cfif len(attributes.department_id)>
								AND (
								<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
									(E.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND E.LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
									<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
								</cfloop>  
								) 
							<cfelseif len(branch_dep_list)>
								AND (E.DEPARTMENT_ID IN(#branch_dep_list#) OR E.DEPARTMENT_ID IS NULL)
							</cfif>
							<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company") and len(attributes.company)>
								AND E.CH_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
							</cfif>
							<cfif len(kurumsal)>
								AND C.COMPANYCAT_ID IN (#kurumsal#)
							</cfif>
							<cfif len(attributes.subscription_type)>
								AND SST.SUBSCRIPTION_TYPE_ID IN (#attributes.subscription_type#)
							</cfif>
							<cfif isdefined("attributes.product_cat_id") and len(attributes.product_cat_id)>
								AND P.PRODUCT_CATID IN (#attributes.product_cat_id#)
							</cfif>
						UNION ALL
					</cfif>	
				</cfif>
				<cfif not(isdefined("attributes.ship_method_id") and len(attributes.ship_method_id) and len(attributes.ship_method_name))>
					<cfif not(len(kurumsal) and not len(bireysel)) and not (isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company") and len(attributes.company))>
						SELECT 
							E.EXPENSE_ID  AS ACTION_ID,
							E.PAPER_NO AS BELGE_NO,
							'' SERIAL_NUMBER,
							'' SERIAL_NO,
							E.EXPENSE_DATE AS ACTION_DATE,
							E.TOTAL_AMOUNT_KDVLI AS NETTOTAL,
							E.KDV_TOTAL AS TAXTOTAL,
							E.OTV_TOTAL AS OTV_TOTAL,							
							E.TOTAL_AMOUNT AS GROSSTOTAL,
							0 AS SA_DISCOUNT,
							0 AS ROUND_MONEY,
							E.ACTION_TYPE,
							E.ACC_DEPARTMENT_ID,
							0 AS IS_TAX_OF_OTV,
							E.PROJECT_ID,
							E.DUE_DATE,
							E_ROW.PROJECT_ID ROW_PROJECT_ID,							
							ISNULL(E_ROW.AMOUNT_OTV,0) AS OTVTOTAL,
							E_ROW.OTV_RATE AS OTV_ORAN,
							E_ROW.AMOUNT_OTV AS ROW_OTVTOTAL,							
							E_ROW.AMOUNT_KDV AS ROW_TAXTOTAL,
							CAST(E_ROW.KDV_RATE AS FLOAT) AS TAX,						
							0 AS DISCOUNTTOTAL,
							(E_ROW.AMOUNT*E_ROW.QUANTITY) AS KDVSIZ_TOPLAM,
							'' SUBS_NAME,
							'' SUBSCRIPTION_NO,
							'' AS SHIP_ADDRESS,
							<cfif attributes.report_type eq 2>
								' ' PRODUCT_NAME,
								E_ROW.DETAIL NOTE,
							<cfelse>
								E.DETAIL NOTE,
							</cfif>
							C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME AS FULLNAME,
							C.MEMBER_CODE,
							C.OZEL_KOD,
							C.TAX_OFFICE TAXOFFICE,
							C.TAX_NO TAXNO,
							C.TC_IDENTY_NO,
							1 AS TYPE,
							E.PROCESS_CAT,
							E_ROW.EXPENSE_ITEM_ID AS PRODUCT_ID,
							E_ROW.QUANTITY ROW_QUANTITY,
							ISNULL(E_ROW.UNIT,'Adet') AS UNIT, <!--- ürün secilmemiş satırlarda birim null geliyor --->
							EXPENSE_ITEMS.EXPENSE_ITEM_ID AS PRODUCT_CATID,
							EXPENSE_ITEMS.EXPENSE_ITEM_NAME AS PRODUCT_CAT,
							 <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,11)>
								<cfloop from="1" to="40" index="i">
									EXPENSE_ITEM_PLANS_INFO_PLUS.PROPERTY#i#,
								</cfloop>
							</cfif>
							E.DEPARTMENT_ID ROW_DEPT,
							E.LOCATION_ID ROW_LOC
							<cfif attributes.report_type eq 2>
								,'' ACCOUNT_ID
							</cfif>
							,E.BSMV_TOTAL AS BSMV_TOTAL,
							ISNULL(E_ROW.AMOUNT_BSMV,0) AS BSMV_TOTAL,
							E_ROW.BSMV_RATE AS BSMV_ORAN,
							E_ROW.AMOUNT_BSMV AS ROW_BSMVTOTAL,
							E.OIV_TOTAL AS OIV_TOTAL,
							ISNULL(E_ROW.AMOUNT_OIV,0) AS OIV_TOTAL,
							E_ROW.OIV_RATE AS OIV_ORAN,
							E_ROW.AMOUNT_OIV AS ROW_OIVTOTAL
							<cfif attributes.report_type eq 2 and isdefined("attributes.list_type") and listfind(attributes.list_type,16)>
								,'' PRODUCT_CODE_2
							</cfif>
						FROM
							EXPENSE_ITEM_PLANS E JOIN 
							EXPENSE_ITEMS_ROWS E_ROW ON E.EXPENSE_ID=E_ROW.EXPENSE_ID
							LEFT JOIN #dsn3_alias#.SUBSCRIPTION_CONTRACT SC ON E.SUBSCRIPTION_ID=SC.SUBSCRIPTION_ID
							LEFT JOIN #dsn3_alias#.SETUP_SUBSCRIPTION_TYPE SST ON SC.SUBSCRIPTION_TYPE_ID = SST.SUBSCRIPTION_TYPE_ID
							<cfif isdefined("attributes.list_type") and listfind(attributes.list_type,11) >
								LEFT JOIN EXPENSE_ITEM_PLANS_INFO_PLUS  ON E.EXPENSE_ID=EXPENSE_ITEM_PLANS_INFO_PLUS.EXPENSE_ID
							</cfif>
							<cfif (session.ep.our_company_info.is_efatura)>
								LEFT JOIN EINVOICE_RELATION ER ON ER.ACTION_ID = E.EXPENSE_ID AND ER.ACTION_TYPE = 'EXPENSE_ITEM_PLANS'
								LEFT JOIN EINVOICE_RECEIVING_DETAIL ERD ON ERD.EXPENSE_ID = E.EXPENSE_ID
								LEFT JOIN #dsn3_alias#.SETUP_PROCESS_CAT SPC ON SPC.PROCESS_CAT_ID = E.PROCESS_CAT
							</cfif>
							,#dsn_alias#.CONSUMER C,
							EXPENSE_ITEMS
						WHERE
							E.CH_CONSUMER_ID = C.CONSUMER_ID AND 
							E.IS_IPTAL = 0
							<cfif len(attributes.use_efatura) and attributes.use_efatura neq 5>
								AND C.USE_EFATURA = 1 
								AND C.EFATURA_DATE <= E.EXPENSE_DATE
								<cfif attributes.use_efatura eq 1>
									AND ER.STATUS IS NULL
									AND (SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = E.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS') = 0
									AND SPC.INVOICE_TYPE_CODE IS NOT NULL
									AND E.EXPENSE_DATE >= #createodbcdatetime(session.ep.our_company_info.efatura_date)#
								<cfelseif attributes.use_efatura eq 2>
									AND 
									(
										(
											(SELECT COUNT(SENDING_DETAIL_ID) FROM EINVOICE_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = E.EXPENSE_ID AND ESD.ACTION_TYPE = 'EXPENSE_ITEM_PLANS') > 0 
											AND ER.PATH IS NOT NULL
										)
										OR
										(SELECT COUNT(RECEIVING_DETAIL_ID) FROM EINVOICE_RECEIVING_DETAIL ESD WHERE ESD.EXPENSE_ID = E.EXPENSE_ID) > 0
									)
								<cfelseif attributes.use_efatura eq 3>
									AND ER.STATUS = 1
								<cfelseif attributes.use_efatura eq 4>
									AND ER.STATUS = 0
								</cfif>
							<cfelseif attributes.use_efatura eq 5>
								AND (C.USE_EFATURA = 0 OR C.EFATURA_DATE > E.EXPENSE_DATE)
							</cfif>	
							AND E_ROW.EXPENSE_ITEM_ID=EXPENSE_ITEMS.EXPENSE_ITEM_ID
							<cfif len(attributes.process_type)>
								AND E.PROCESS_CAT IN (#attributes.process_type#)
							<cfelse>
								AND E.ACTION_TYPE IN (121)
							</cfif>
							<cfif isDefined("attributes.startdate") and isdate(attributes.startdate) and isDefined("attributes.finishdate") and isdate(attributes.finishdate)>
								AND E.EXPENSE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
							</cfif>	
							<cfif attributes.report_type eq 2>
								<cfif isdefined('attributes.project_id') and len(attributes.project_head) and len(attributes.project_id)>
									AND E_ROW.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
								</cfif>
							<cfelse>
								<cfif isdefined('attributes.project_id') and len(attributes.project_head) and len(attributes.project_id)>
									AND E.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
								</cfif>
							</cfif>
							<cfif len(attributes.department_id)>
								AND (
								<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
									(E.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND E.LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
									<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
								</cfloop>  
								) 
							<cfelseif len(branch_dep_list)>
								AND (E.DEPARTMENT_ID IN (#branch_dep_list#) OR E.DEPARTMENT_ID IS NULL)
							</cfif>
							<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isdefined("attributes.company") and len(attributes.company)>
								AND E.CH_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
							</cfif>
							<cfif len(bireysel)>
								AND C.CONSUMER_CAT_ID IN (#bireysel#)
							</cfif>
							<cfif len(attributes.subscription_type)>
								AND SST.SUBSCRIPTION_TYPE_ID IN (#attributes.subscription_type#)
							</cfif>
						UNION ALL
					</cfif>
				</cfif>
				<cfif not(isdefined("attributes.ship_method_id") and len(attributes.ship_method_id) and len(attributes.ship_method_name))>
					SELECT 
						E.EXPENSE_ID  AS ACTION_ID,
						E.PAPER_NO AS BELGE_NO,
						'' SERIAL_NUMBER,
						'' SERIAL_NO,
						E.EXPENSE_DATE AS ACTION_DATE,
						E.TOTAL_AMOUNT_KDVLI AS NETTOTAL,
						E.KDV_TOTAL AS TAXTOTAL,
						E.OTV_TOTAL AS OTV_TOTAL,					
						E.TOTAL_AMOUNT AS GROSSTOTAL,
						0 AS SA_DISCOUNT,
						0 AS ROUND_MONEY,
						E.ACTION_TYPE,
						E.ACC_DEPARTMENT_ID,
						0 AS IS_TAX_OF_OTV,
						E.PROJECT_ID,
						E.DUE_DATE,
						E_ROW.PROJECT_ID ROW_PROJECT_ID,
						ISNULL(E_ROW.AMOUNT_OTV,0) AS OTVTOTAL,
						E_ROW.OTV_RATE AS OTV_ORAN,
						E_ROW.AMOUNT_OTV AS ROW_OTVTOTAL,
						E_ROW.AMOUNT_KDV AS ROW_TAXTOTAL,
						CAST(E_ROW.KDV_RATE AS FLOAT) AS TAX,						
						0 AS DISCOUNTTOTAL,
						(E_ROW.AMOUNT*E_ROW.QUANTITY) AS KDVSIZ_TOPLAM,
						'' SUBS_NAME,
						'' SUBSCRIPTION_NO,
						'' AS SHIP_ADDRESS,
						<cfif attributes.report_type eq 2>
							' ' PRODUCT_NAME,
							E_ROW.DETAIL NOTE,
						<cfelse>
							E.DETAIL NOTE,
						</cfif>
						'' FULLNAME,
						'' MEMBER_CODE,
						'' OZEL_KOD,
						'' TAXOFFICE,
						'' TAXNO,
						'' AS TC_IDENTY_NO,
						1 AS TYPE,
						E.PROCESS_CAT,
						E_ROW.EXPENSE_ITEM_ID AS PRODUCT_ID,
						E_ROW.QUANTITY ROW_QUANTITY,
						ISNULL(E_ROW.UNIT,'Adet') AS UNIT, <!--- ürün secilmemiş satırlarda birim null geliyor --->
						EXPENSE_ITEMS.EXPENSE_ITEM_ID AS PRODUCT_CATID,
						EXPENSE_ITEMS.EXPENSE_ITEM_NAME AS PRODUCT_CAT,
						 <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,11) >
							<cfloop from="1" to="40" index="i">
								EXPENSE_ITEM_PLANS_INFO_PLUS.PROPERTY#i#,
							</cfloop>
						</cfif>
						E.DEPARTMENT_ID ROW_DEPT,
						E.LOCATION_ID ROW_LOC
						<cfif attributes.report_type eq 2>
							,'' ACCOUNT_ID
						</cfif>
						,ISNULL(E_ROW.AMOUNT_BSMV,0) AS BSMV_TOTAL,
						E.BSMV_TOTAL AS BSMV_TOTAL,
						E_ROW.BSMV_RATE AS BSMV_ORAN,
						E_ROW.AMOUNT_BSMV AS ROW_BSMVTOTAL,
						E.OIV_TOTAL AS OIV_TOTAL,
						ISNULL(E_ROW.AMOUNT_OIV,0) AS OIV_TOTAL,
						E_ROW.OIV_RATE AS OIV_ORAN,
						E_ROW.AMOUNT_OIV AS ROW_OIVTOTAL
						<cfif attributes.report_type eq 2 and isdefined("attributes.list_type") and listfind(attributes.list_type,16)>
							,'' PRODUCT_CODE_2
						</cfif>
					FROM
						EXPENSE_ITEM_PLANS E JOIN 
						EXPENSE_ITEMS_ROWS E_ROW ON  E.EXPENSE_ID=E_ROW.EXPENSE_ID
						LEFT JOIN #dsn3_alias#.SUBSCRIPTION_CONTRACT SC ON E.SUBSCRIPTION_ID=SC.SUBSCRIPTION_ID
						LEFT JOIN #dsn3_alias#.SETUP_SUBSCRIPTION_TYPE SST ON SC.SUBSCRIPTION_TYPE_ID = SST.SUBSCRIPTION_TYPE_ID
						<cfif isdefined("attributes.list_type") and listfind(attributes.list_type,11)>
							LEFT JOIN EXPENSE_ITEM_PLANS_INFO_PLUS  ON E.EXPENSE_ID=EXPENSE_ITEM_PLANS_INFO_PLUS.EXPENSE_ID
						</cfif>
						<cfif (session.ep.our_company_info.is_efatura)>
							LEFT JOIN EINVOICE_RELATION ER ON ER.ACTION_ID = E.EXPENSE_ID AND ER.ACTION_TYPE = 'EXPENSE_ITEM_PLANS'
							LEFT JOIN EINVOICE_RECEIVING_DETAIL ERD ON ERD.EXPENSE_ID = E.EXPENSE_ID
							LEFT JOIN #dsn3_alias#.SETUP_PROCESS_CAT SPC ON SPC.PROCESS_CAT_ID = E.PROCESS_CAT
						</cfif>
						,EXPENSE_ITEMS,
						#dsn3_alias#.PRODUCT P,
						#dsn3_alias#.PRODUCT_CAT PC
					WHERE
						<cfif len(attributes.process_type)>
							E.PROCESS_CAT IN (#attributes.process_type#) AND
						<cfelse>
							E.ACTION_TYPE IN (121) AND
						</cfif>
						E_ROW.EXPENSE_ITEM_ID=EXPENSE_ITEMS.EXPENSE_ITEM_ID
						<cfif len(attributes.use_efatura) and attributes.use_efatura neq 5>
							AND 1 = 0
						</cfif>
						AND E.IS_IPTAL = 0
						AND E.CH_COMPANY_ID IS NULL
						AND E.CH_CONSUMER_ID IS NULL
						AND E_ROW.PRODUCT_ID=P.PRODUCT_ID
						AND PC.PRODUCT_CATID=P.PRODUCT_CATID
						<cfif isDefined("attributes.startdate") and isdate(attributes.startdate) and isDefined("attributes.finishdate") and isdate(attributes.finishdate)>
							AND E.EXPENSE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
						</cfif>	
						<cfif attributes.report_type eq 2>
							<cfif isdefined('attributes.project_id') and len(attributes.project_head) and len(attributes.project_id)>
								AND E_ROW.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
							</cfif>
						<cfelse>
							<cfif isdefined('attributes.project_id') and len(attributes.project_head) and len(attributes.project_id)>
								AND E.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
							</cfif>
						</cfif>
						<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company") and len(attributes.company)>
							AND 1=2 <!--- şirket boş olanlar geleceğinden şirket seçili ise burdan kayıt gelmesin--->
						</cfif>
						<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isdefined("attributes.company") and len(attributes.company)>
							AND 1=2 <!--- şirket boş olanlar geleceğinden şirket seçili ise burdan kayıt gelmesin--->
						</cfif>
						<cfif len(attributes.category_id)>
							AND 1=2 <!--- şirket boş olanlar geleceğinden kategori seçili ise burdan kayıt gelmesin--->
						</cfif>
						<cfif len(attributes.subscription_type)>
							AND SST.SUBSCRIPTION_TYPE_ID IN (#attributes.subscription_type#)
						</cfif>
						<cfif isdefined("attributes.product_cat_id") and len(attributes.product_cat_id)>
							AND P.PRODUCT_CATID IN (#attributes.product_cat_id#)
						</cfif>
				UNION ALL
				</cfif>
				SELECT 
					INVOICE.INVOICE_ID AS ACTION_ID,
					INVOICE.INVOICE_NUMBER  AS BELGE_NO,
					INVOICE.SERIAL_NUMBER  AS SERIAL_NUMBER,
					INVOICE.SERIAL_NO AS SERIAL_NO,
					INVOICE.INVOICE_DATE AS ACTION_DATE,
					INVOICE.NETTOTAL,
					ISNULL(INVOICE.TAXTOTAL,0) AS TAXTOTAL,
					ISNULL(INVOICE.OTV_TOTAL,0) AS OTV_TOTAL,					
					INVOICE.GROSSTOTAL,
					INVOICE.SA_DISCOUNT,
					INVOICE.ROUND_MONEY,
					INVOICE.INVOICE_CAT,
					INVOICE.ACC_DEPARTMENT_ID,
					INVOICE.IS_TAX_OF_OTV,
					INVOICE.PROJECT_ID,
					INVOICE.DUE_DATE,
					INVOICE.PROJECT_ID ROW_PROJECT_ID,				
					0 AS OTVTOTAL,
					0 AS OTV_ORAN,
					0 AS ROW_OTVTOTAL,						
					IR.TAXTOTAL ROW_TAXTOTAL,				
					IR.TAX,
					IR.DISCOUNTTOTAL,
					IR.NETTOTAL AS KDVSIZ_TOPLAM,
					SC.SUBSCRIPTION_HEAD AS SUBS_NAME,
					SC.SUBSCRIPTION_NO,
					INVOICE.SHIP_ADDRESS,
					<cfif attributes.report_type eq 2>
						'' PRODUCT_NAME,
						'' NOTE,
					<cfelse>
						INVOICE.NOTE NOTE,
					</cfif>
					'' FULLNAME,
					'' MEMBER_CODE,
					'' OZEL_KOD,
					'' TAXOFFICE,
					'' TAXNO,
					'' TC_IDENTY_NO,
					1 AS TYPE,
					INVOICE.PROCESS_CAT,
					IR.PRODUCT_ID,
					IR.AMOUNT ROW_QUANTITY,
					IR.UNIT,
					0 AS PRODUCT_CATID,
					NULL AS PRODUCT_CAT,
					<cfif isdefined("attributes.list_type") and listfind(attributes.list_type,11)>
						<cfloop from="1" to="40" index="i">
							INVOICE_INFO_PLUS.PROPERTY#i#,
						</cfloop>
					</cfif>
					INVOICE.DEPARTMENT_ID ROW_DEPT,
					INVOICE.DEPARTMENT_LOCATION ROW_LOC
					<cfif attributes.report_type eq 2>
						,'' ACCOUNT_ID
					</cfif>
					,ISNULL(INVOICE.BSMV_TOTAL,0) AS BSMV_TOTAL,
					0 AS BSMVTOTAL,
					0 AS BSMV_RATE,
					0 AS ROW_BSMVTOTAL,
					ISNULL(INVOICE.OIV_TOTAL,0) AS OIV_TOTAL,
					0 AS OIV_TOTAL,
					0 AS OIV_RATE,
					0 AS ROW_OIVTOTAL
					<cfif attributes.report_type eq 2 and isdefined("attributes.list_type") and listfind(attributes.list_type,16)>
						,'' PRODUCT_CODE_2
					</cfif>
				FROM
					INVOICE JOIN 
					INVOICE_ROW_POS IR ON INVOICE.INVOICE_ID = IR.INVOICE_ID
					LEFT JOIN #dsn3_alias#.SUBSCRIPTION_CONTRACT SC ON INVOICE.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID
					LEFT JOIN #dsn3_alias#.SETUP_SUBSCRIPTION_TYPE SST ON SC.SUBSCRIPTION_TYPE_ID = SST.SUBSCRIPTION_TYPE_ID
					<cfif isdefined("attributes.list_type") and listfind(attributes.list_type,11) >
						LEFT JOIN INVOICE_INFO_PLUS  ON INVOICE.INVOICE_ID=INVOICE_INFO_PLUS.INVOICE_ID
					</cfif>
					,#dsn3_alias#.PRODUCT P,
					#dsn3_alias#.PRODUCT_CAT PC
				WHERE
					<cfif len(attributes.process_type)>
						INVOICE.PROCESS_CAT IN (#attributes.process_type#)
					<cfelse>
						INVOICE.INVOICE_CAT IN (69)
					</cfif>
					<cfif len(attributes.use_efatura) and attributes.use_efatura neq 5>
						AND 1 = 0
					</cfif>
					AND IR.PRODUCT_ID=P.PRODUCT_ID
					AND PC.PRODUCT_CATID=P.PRODUCT_CATID
					<cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_id) and len(ship_method_name)>
						AND INVOICE.SHIP_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_method_id#">
					</cfif>
					<cfif isdefined('attributes.project_id') and len(attributes.project_head) and len(attributes.project_id)>
						AND INVOICE.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
					</cfif>
					<cfif isDefined("attributes.startdate") and isdate(attributes.startdate) and isDefined("attributes.finishdate") and isdate(attributes.finishdate)>
						AND INVOICE.INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
					</cfif>	
					<cfif len(attributes.department_id)>
						AND (
						<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
							(INVOICE.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND INVOICE.DEPARTMENT_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
							<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
						</cfloop>  
						) 
					<cfelseif len(branch_dep_list)>
						AND INVOICE.DEPARTMENT_ID IN(#branch_dep_list#)	
					</cfif>
					<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company") and len(attributes.company)>
						AND 1=2 <!--- şirket boş olanalr geleceğinden şirket seçili ise burdan kayıt gelmesin--->
					</cfif>
					<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isdefined("attributes.company") and len(attributes.company)>
						AND 1=2 <!--- şirket boş olanalr geleceğinden şirket seçili ise burdan kayıt gelmesin--->
					</cfif>
					<cfif len(attributes.category_id)>
						AND 1=2 <!--- şirket boş olanalr geleceğinden kategori seçili ise burdan kayıt gelmesin--->
					</cfif>
					<cfif len(attributes.subscription_type)>
						AND SST.SUBSCRIPTION_TYPE_ID IN (#attributes.subscription_type#) 
					</cfif>
					<cfif isdefined("attributes.product_cat_id") and len(attributes.product_cat_id)>
							AND P.PRODUCT_CATID IN (#attributes.product_cat_id#)
						</cfif>
			</cfquery>			
		<cfelse>
			<cfset get_invoice_detail.recordcount=0>
		</cfif>
		<cfif get_invoice_detail.recordcount>
			<cfquery name="get_invoice" dbtype="query">
				SELECT 
					<cfif attributes.report_type eq 2><!--- satır bazında --->
						*
					<cfelse>
						ACTION_ID,
						BELGE_NO,
						SERIAL_NUMBER,
						SERIAL_NO,
						ACTION_DATE,
						NETTOTAL,
						TAXTOTAL,
						OTV_TOTAL,
						BSMV_TOTAL,
						OIV_TOTAL,
						SUM(DISCOUNTTOTAL) AS INV_DISCOUNTTOTAL,
						GROSSTOTAL,
						SA_DISCOUNT,
						ROUND_MONEY,
						INVOICE_CAT,
						ACC_DEPARTMENT_ID,				
						FULLNAME,
						MEMBER_CODE,
						OZEL_KOD,
						TAXOFFICE,
						TAXNO,
						TC_IDENTY_NO,
						IS_TAX_OF_OTV,
						PROJECT_ID,
						DUE_DATE,
						NOTE,
						TYPE,					
						<cfif isdefined("attributes.list_type") and listfind(attributes.list_type,11)>
							<cfloop from="1" to="40" index="i">
								PROPERTY#i#,
							</cfloop>
						</cfif>
						ROW_DEPT,
						ROW_LOC
						<cfif isdefined("attributes.list_type") and listfind(attributes.list_type,14)>
							,BSMVTOTAL,
							BSMV_RATE,
							ROW_BSMVTOTAL
						</cfif>
						<cfif isdefined("attributes.list_type") and listfind(attributes.list_type,15)>
							,OIVTOTAL,
							OIV_RATE,
							ROW_OIVTOTAL
						</cfif>
					</cfif>,
					PROCESS_CAT,
					SUBS_NAME,
					SUBSCRIPTION_NO,
					SHIP_ADDRESS
				FROM
					get_invoice_detail
				<cfif attributes.report_type eq 1>
					GROUP BY
						ACTION_ID,
						BELGE_NO,
						SERIAL_NUMBER,
						SERIAL_NO,
						ACTION_DATE,
						NETTOTAL,
						TAXTOTAL,
						OTV_TOTAL,
						BSMV_TOTAL,
						OIV_TOTAL,
						GROSSTOTAL,
						SA_DISCOUNT,
						ROUND_MONEY,
						INVOICE_CAT,
						ACC_DEPARTMENT_ID,					
						FULLNAME,
						MEMBER_CODE,
						OZEL_KOD,
						TAXOFFICE,
						TAXNO,
						TC_IDENTY_NO,
						IS_TAX_OF_OTV,
						PROJECT_ID,
						DUE_DATE,
						NOTE,
						TYPE,
						PROCESS_CAT,
						SUBS_NAME,	
						SUBSCRIPTION_NO,
						SHIP_ADDRESS,			
						<cfif isdefined("attributes.list_type") and listfind(attributes.list_type,11)>
							<cfloop from="1" to="40" index="i">
								PROPERTY#i#,
							</cfloop>
						</cfif>
						ROW_DEPT,
						ROW_LOC
						<cfif isdefined("attributes.list_type") and listfind(attributes.list_type,14)>
							,BSMVTOTAL,
							BSMV_RATE,
							ROW_BSMVTOTAL
						</cfif>
						<cfif isdefined("attributes.list_type") and listfind(attributes.list_type,15)>
							,OIVTOTAL,
							OIV_RATE,
							ROW_OIVTOTAL
						</cfif>
				</cfif>
				ORDER BY
					BELGE_NO ASC,
					ACTION_DATE DESC
			</cfquery>
			<cfquery name="get_invoice_taxes" datasource="#dsn2#">
				SELECT 
					IT.* 
				FROM 
					INVOICE_TAXES IT,
					INVOICE
				WHERE 
					INVOICE.INVOICE_ID = IT.INVOICE_ID
					<cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_id) and len(ship_method_name)>
						AND INVOICE.SHIP_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_method_id#">
					</cfif>
					<cfif isDefined("attributes.startdate") and isdate(attributes.startdate) and isDefined("attributes.finishdate") and isdate(attributes.finishdate)>
						AND INVOICE.INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
					</cfif>	
					<cfif len(attributes.department_id)>
						AND (
						<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
							(INVOICE.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND INVOICE.DEPARTMENT_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
							<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
						</cfloop>  
						) 
					<cfelseif len(branch_dep_list)>
						AND INVOICE.DEPARTMENT_ID IN(#branch_dep_list#)	
					</cfif>
			</cfquery>
			<cfoutput query="get_invoice_taxes">
				<cfset "tax_beyan_#invoice_id#_#tax#" = BEYAN_TUTAR>
				<cfset "tax_tevkifat_#invoice_id#_#tax#" = TEVKIFAT_TUTAR>
			</cfoutput>
			<cfset unit_list = listdeleteduplicates(valuelist(get_invoice_detail.unit))><!--- Unit Listesi --->
			<cfset unit_list = '#replace(unit_list,"/","_","all")#'>
			<cfset unit_list = '#replace(unit_list," ","_","all")#'>
			<cfset unit_list = '#replace(unit_list,".","","all")#'>
			<cfloop list="#unit_list#" index="tt">
				<cfset 'last_total_amount_#tt#' = 0>
				<cfset 'devir_last_total_amount_#tt#' = 0>
				<cfset 'total_row_quantity_#tt#' = 0>
				<cfset 'devir_total_row_quantity_#tt#' = 0>
			</cfloop>
			<cfset last_total_amount_ = 0>
			<cfset devir_last_total_amount_ = 0>
		<cfelse>
			<cfset get_invoice.recordcount=0>
		</cfif>
		<cfif isdate(attributes.startdate)>
			<cfset attributes.startdate = dateformat(attributes.startdate, dateformat_style)>
		</cfif>
		<cfif isdate(attributes.finishdate)>
			<cfset attributes.finishdate = dateformat(attributes.finishdate, dateformat_style)>
		</cfif>
		
		<cfparam name="attributes.page" default=1>
		<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
		<cfparam name="attributes.totalrecords" default="#get_invoice.recordcount#">
		<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
		<cfform name="form" action="" method="post">
		<input type="hidden" value="1" name="form_varmi" id="form_varmi">
			<cfsavecontent variable='title'><cf_get_lang dictionary_id='39169.Fatura Listesi Satışlar'></cfsavecontent>
			<cf_report_list_search title="#title#">
				<cf_report_list_search_area>
					<div class="row">
						<div class="col col-12 col-xs-12">
							<div class="row formContent">
								<div class="row" type="row">
									<div class="col col-3 col-md-6 col-xs-12">
										<div class="form-group">
										  <label class="col col-12"><cf_get_lang dictionary_id='58763.Depo'></label>
											<div class="col col-12 col-xs-12">
												<cfquery name="get_all_location" datasource="#DSN#">
													SELECT * FROM STOCKS_LOCATION <cfif x_show_pasive_departments eq 0>WHERE STATUS = 1</cfif>
												</cfquery>						
												<select name="department_id" id="department_id" multiple >
													<cfoutput query="get_department">
													<optgroup label="#department_head#">
														<cfquery name="get_location" dbtype="query">
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
										   <label class="col col-12"> <cf_get_lang dictionary_id='57800.İşlem Tipi'></label>
											<div class="col col-12 col-xs-12">
												<select name="process_type" id="process_type"  multiple>
													<cfoutput query="get_process_cat">
														<option value="#PROCESS_CAT_ID#" <cfif listfind(attributes.process_type,PROCESS_CAT_ID,',')>selected</cfif>>#PROCESS_CAT#</option>
													</cfoutput>
												</select>
											</div>
										</div>							
									</div>
									<div class="col col-3 col-md-6 col-xs-12">
										<div class="form-group">
										  <label class="col col-12"><cf_get_lang dictionary_id='39242.Müşteri Kat'></label>
											<div class="col col-12 col-xs-12">
												<select name="category_id" id="category_id"  multiple>
													<optgroup label="<cf_get_lang dictionary_id='58039.Kurumsal Üye Kategorileri'>">
														<cfoutput query="get_comp_category">
															<option value="1-#category_id#"  <cfif listfind(attributes.category_id,'1-#category_id#')>selected</cfif>>&nbsp;&nbsp;#category_name#</option>
														</cfoutput>
													</optgroup>
													<optgroup label="<cf_get_lang dictionary_id='58040.Bireysel Üye Kategorileri'>">
														<cfoutput query="get_cons_category">
															<option value="2-#category_id#"  <cfif listfind(attributes.category_id,'2-#category_id#')>selected</cfif>>&nbsp;&nbsp;#category_name#</option>
														</cfoutput>
													</optgroup>
												</select>
											</div>
										</div>
										<div class="form-group">
											 <label class="col col-12"> <cf_get_lang dictionary_id="57509.Liste"> <cf_get_lang dictionary_id="38937.Tipi"></label>
											<div class="col col-12 col-xs-12">
											<select name="list_type" id="list_type" multiple>
													<option value="1" <cfif listfind(attributes.list_type,1)>selected</cfif>><cf_get_lang dictionary_id='58763.Depo'>-<cf_get_lang dictionary_id='30031.Lokasyon'></option>
													<option value="2" <cfif listfind(attributes.list_type,2)>selected</cfif>><cf_get_lang dictionary_id='57789.Özel Kod'></option>
													<option value="3" <cfif listfind(attributes.list_type,3)>selected</cfif>><cf_get_lang dictionary_id='58025.TC Kimlik No'></option>
													<option value="4" <cfif listfind(attributes.list_type,4)>selected</cfif>><cf_get_lang dictionary_id='57486.Kategori'></option>
													<option value="5" <cfif listfind(attributes.list_type,5)>selected</cfif>><cf_get_lang dictionary_id='38956.Şube /Departman'></option>
													<option value="6" <cfif listfind(attributes.list_type,6)>selected</cfif>><cf_get_lang dictionary_id='57629.Açıklama'></option>
													<option value="7" <cfif listfind(attributes.list_type,7)>selected</cfif>><cf_get_lang dictionary_id='57635.Miktar'></option>
													<option value="8" <cfif listfind(attributes.list_type,8)>selected</cfif>><cf_get_lang dictionary_id='57639.KDV'></option>
													<option value="12" <cfif listfind(attributes.list_type,12)>selected</cfif>><cf_get_lang dictionary_id='58021.ÖTV'></option>
													<option value="9" <cfif listfind(attributes.list_type,9)>selected</cfif>><cf_get_lang dictionary_id='57416.Proje'></option>
													<option value="10" <cfif listfind(attributes.list_type,10)>selected</cfif>><cf_get_lang dictionary_id='57881.Vade Tarihi'></option>
													<option value="11" <cfif listfind(attributes.list_type,11)>selected</cfif>><cf_get_lang dictionary_id='57810.Ek Bilgi'></option>
													<option value="13" <cfif listfind(attributes.list_type,13)>selected</cfif>><cf_get_lang dictionary_id='39234.Abone İsmi'></option>
													<option value="14" <cfif listfind(attributes.list_type,14)>selected</cfif>><cf_get_lang  dictionary_id="50923.BSMV"></option>
													<option value="15" <cfif listfind(attributes.list_type,15)>selected</cfif>><cf_get_lang dictionary_id='50982.OIV'></option>
													<option value="16" <cfif listfind(attributes.list_type,16)>selected</cfif>><cf_get_lang dictionary_id="60278.Ürün Özel Kod"></option>
													<option value="17" <cfif listfind(attributes.list_type,17)>selected</cfif>><cf_get_lang dictionary_id='29502.Abone No'></option>
													<option value="18" <cfif listfind(attributes.list_type,18)>selected</cfif>><cf_get_lang dictionary_id='30261.Fatura Adersi'></option>
												</select>
											</div>
										</div>
									</div>
									<div class="col col-3 col-md-6 col-xs-12">
										<div class="form-group">
											<label class="col col-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
											<div class="col col-12 col-xs-12">
												<div class="input-group">
													<input type="hidden" name="company_id" id="company_id"  value="<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isDefined("attributes.company") and len(attributes.company)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
													<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isDefined("attributes.company") and len(attributes.company)><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
													<input type="text" name="company" id="company" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'0\',\'0\',\'0\',\'2\',\'0\'','COMPANY_ID,CONSUMER_ID','company_id,consumer_id','form','3','250');" autocomplete="off" style="width:154px;" value="<cfif isDefined("attributes.company") and len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>" >
													<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=form.company&field_comp_id=form.company_id&field_name=form.company&field_consumer=form.consumer_id&select_list=2,3&keyword='+encodeURIComponent(document.form.company.value),'list');"></span>
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></label>
											<div class="col col-12 col-xs-12">
												<div class="input-group">
													<input type="hidden" name="ship_method_id" id="ship_method_id" value="<cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_name)><cfoutput>#attributes.ship_method_id#</cfoutput></cfif>">
													<input type="text" name="ship_method_name" id="ship_method_name" style="width:154px;" value="<cfif isdefined("attributes.ship_method_name") and len(attributes.ship_method_name)><cfoutput>#attributes.ship_method_name#</cfoutput></cfif>" onfocus="AutoComplete_Create('ship_method_name','SHIP_METHOD','SHIP_METHOD','get_ship_method','','SHIP_METHOD_ID','ship_method_id','','3','125');" autocomplete="off">
													<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method_id','list');"></span>
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12"><cf_get_lang dictionary_id='57416.Proje'></label>
											<div class="col col-12 col-xs-12">
												<div class="input-group">
														<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id')><cfoutput>#attributes.project_id#</cfoutput></cfif>">
														<input type="text" name="project_head" id="project_head" style="width:154px;" value="<cfif isdefined('attributes.project_head') and  len(attributes.project_head)><cfoutput>#attributes.project_head#</cfoutput></cfif>" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
														<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=rapor.project_id&project_head=rapor.project_head');"></span> 
												</div>
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
											<label class="col col-12"><cf_get_lang dictionary_id='58690.Tarih Aralığı'>*</label>
											<div class="col col-6">
												<div class="input-group">
													<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
													<cfinput type="text" name="startdate" value="#attributes.startdate#" validate="#validate_style#" message="#message#" maxlength="10" required="yes">
													<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
												</div>
											</div>
											<div class="col col-6">
												<div class="input-group">
													<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
													<cfinput type="text" name="finishdate" value="#attributes.finishdate#" validate="#validate_style#" message="#message#" maxlength="10" required="yes">
													<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span> 
												</div>
											</div>
										</div>								
									</div>
									<div class="col col-3 col-md-6 col-xs-12">
										<div class="form-group">
											 <label class="col col-12"> <cf_get_lang dictionary_id='58960.Rapor Tipi'></label>
											<div class="col col-12 col-xs-12">                                           
												<select name="report_type" id="report_type" style="width:154px;" onchange="kontrol_report();">
													<option value="1"<cfif isDefined('attributes.report_type') and attributes.report_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57660.Belge Bazında'></option>
													<option value="2"<cfif isDefined('attributes.report_type') and attributes.report_type eq 2>selected</cfif>><cf_get_lang dictionary_id='58508.Satır'><cf_get_lang dictionary_id='58601.Bazında'></option>
												</select>	
											</div>
										</div>										
										<div class="form-group" id="item-product_cat_id">
											<label class="col col-12"><cf_get_lang dictionary_id='29401.Ürün Kategori'></label>
											<div class="col col-12">
												<div class="input-group">
													<input type="hidden" name="product_cat_id" id="product_cat_id" value="<cfif len(attributes.product_cat_id) and len(attributes.product_category_name)><cfoutput>#attributes.product_cat_id#</cfoutput></cfif>">
													<input type="hidden" name="cat" id="cat" value="<cfif len(attributes.cat) and len(attributes.product_category_name)><cfoutput>#attributes.cat#</cfoutput></cfif>">
													<input name="product_category_name" type="text" id="product_category_name" style="width:100px;" onfocus="AutoComplete_Create('product_category_name','PRODUCT_CATID,PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID,HIERARCHY','product_cat_id,cat','','3','200','','1');" value="<cfif len(attributes.product_category_name)><cfoutput>#attributes.product_category_name#</cfoutput></cfif>" autocomplete="off">
													<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=form.product_cat_id&field_code=form.cat&field_name=form.product_category_name</cfoutput>');"></span>
												</div>
											</div>
										</div>	
										<cfif get_subscription_cat.recordcount and get_subscription_cat.IS_SUBSCRIPTION_CONTRACT eq 1>
											<div class="form-group" id="form_ul_suscription_type">
												<label class="col col-12"><cf_get_lang dictionary_id='40085.Abone Kategori'></label>
												<div class="col col-12">
													<select name="subscription_type" id="subscription_type">
														<option value=""><cf_get_lang dictionary_id='40085.Abone Kategori'></option>
															<cfoutput query="get_subscription_type">
																<option value="#subscription_type_id#" <cfif attributes.subscription_type eq subscription_type_id>selected</cfif>>#subscription_type#</option>
															</cfoutput>
													</select>
												</div>
											</div>
										</cfif>
										<div class="form-group">
											 <label class="col col-12 "><cf_get_lang dictionary_id="29872.E-Fatura"></label>
											<div class="col col-12 col-xs-12">                                           
												<cfif session.ep.our_company_info.is_efatura>
													<select name="use_efatura" id="use_efatura" style="width:154px;">
														<option value=""><cf_get_lang dictionary_id="29872.E-Fatura"></option>
														<option value="1" <cfif attributes.use_efatura eq 1>selected</cfif>><cf_get_lang dictionary_id='59329.Gönderilecekler'></option>
														<option value="2" <cfif attributes.use_efatura eq 2>selected</cfif>><cf_get_lang dictionary_id='59776.E-Fatura Kesilenler'></option>
														<option value="3" <cfif attributes.use_efatura eq 3>selected</cfif>><cf_get_lang dictionary_id='57500.Onay'></option>
														<option value="4" <cfif attributes.use_efatura eq 4>selected</cfif>><cf_get_lang dictionary_id='29537.Red'></option>
														<option value="5" <cfif attributes.use_efatura eq 5>selected</cfif>><cf_get_lang dictionary_id='59338.E-Fatura Olmayanlar'></option>
													</select>
												</cfif>
											</div>
										</div>
										<div class="form-group">
											<div class="col col-12 col-xs-12">                                          
												<label id="inv_total" style="<cfif attributes.report_type neq 1>display:none;</cfif>"> 
													<input type="checkbox" name="is_inv_total" id="is_inv_total" value="1" <cfif isdefined("attributes.is_inv_total")>checked</cfif>><cf_get_lang dictionary_id='40652.Fatura Toplam Göster'>				
												</label>
											</div>
										</div>
										<div class="form-group">
											<div class="col col-12 col-xs-12">
												<label id="tevkifat_total" style="cfif attributes.report_type eq 2>display=none;">
													<input type="checkbox" name="is_tevkifat" id="is_tevkifat" value="1" <cfif isdefined("attributes.is_tevkifat")>checked</cfif>><cf_get_lang dictionary_id='40653.Tevkifat Göster'>				
												</label>
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
										<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" range="1,999" validate="integer" message="#message#" maxlength="3" style="width:25px;">
									<cfelse>
										<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" range="1,999" onKeyUp="isNumber(this)" validate="integer" message="#message#" maxlength="3" style="width:25px;">
									</cfif>
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57911.Çalıştır'></cfsavecontent>
									<cf_wrk_report_search_button button_type='1' search_function='kontrol()' is_excel='1'>
								</div>
							</div>
						</div>
					</div>
				</cf_report_list_search_area>
			</cf_report_list_search>
		</cfform>
		<cfif isdefined('attributes.is_excel') and listfind('1,2',attributes.is_excel)>
			<cfset attributes.startrow=1>
			<cfset attributes.maxrows=get_invoice.recordcount>
		</cfif>
		<cfif isdefined("attributes.is_excel") and attributes.is_excel eq 2>
			<cfset type_ = 2>
		<cfelseif isdefined("attributes.is_excel") and attributes.is_excel eq 1>
			<cfset filename="invoice_list_sale#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
			<cfheader name="Expires" value="#GetHttpTimeString(Now())#">
			<cfcontent type="application/vnd.msexcel;charset=utf-16">
			<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
			<meta http-equiv="content-type" content="text/html; charset=utf-16">
			<cfset type_ = 1>
		<cfelse>
			<cfset type_ = 0>
		</cfif>
		<cfif isdefined("attributes.form_varmi")>
		<cf_report_list>
			<cfoutput>
				<thead>
					<tr>
						<th><cf_get_lang dictionary_id='57637.Seri No'></th>
						<th><cf_get_lang dictionary_id='58133.Fatura No'></th>
						<th><cf_get_lang dictionary_id='57800.İşlem Tipi'></th>
						<th width="150"><cf_get_lang dictionary_id='57742.Tarih'></th>
						<cfif listfind(attributes.list_type,10)>
							<th width="75"><cf_get_lang dictionary_id='57881.Vade Tarihi'></th>
						</cfif>
						<cfif listfind(attributes.list_type,11)>
							<cfset list_info_sale = valuelist(get_add_info_name.property)>
							<cfloop from="1" to="#listlen(list_info_sale)#" index="i">
								<th width="200">
									<cf_get_lang dictionary_id='57810.Ek Bilgi'>#i#
								</th>
							</cfloop>
						</cfif>
						<cfif listfind(attributes.list_type,1)>
							<th><cf_get_lang dictionary_id='58763.Depo'></th>
							<th><cf_get_lang dictionary_id='30031.Lokasyon'></th>
						</cfif>
						<cfif listfind(attributes.list_type,2)>
							<th><cf_get_lang dictionary_id='57789.Özel Kod'></th>
						</cfif>
						<th><cf_get_lang dictionary_id='57519.Cari Hesap'><cf_get_lang dictionary_id='57487.No'></th>            
						<th><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
						<cfif listfind(attributes.list_type,13)> 
							<th><cf_get_lang dictionary_id='39234.Abone İsmi'></th> 		
						</cfif>
						<cfif listfind(attributes.list_type,17)> 
							<th><cf_get_lang dictionary_id='29502.Abone nO'></th> 		
						</cfif>
						<cfif listfind(attributes.list_type,18)> 
							<th><cf_get_lang dictionary_id='30261.Fatura Adresi'></th> 		
						</cfif>
						<cfif attributes.report_type eq 1 and listfind(attributes.list_type,6)>
							<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
						</cfif> 						
						<th><cf_get_lang dictionary_id='58762.Vergi Dairesi'></th>
						<th><cf_get_lang dictionary_id='57752.Vergi No'></th>
						<cfif listfind(attributes.list_type,3)>
							<th><cf_get_lang dictionary_id='58025.TC Kimlik No'></th>
						</cfif>
						<cfif listfind(attributes.list_type,4)>
							<th><cf_get_lang dictionary_id='57486.Kategori'></th>
						</cfif>
						<cfif listfind(attributes.list_type,5)>
							<th><cf_get_lang dictionary_id='38956.Şube /Departman'></th>
						</cfif>
						<cfif listfind(attributes.list_type,9)>
							<th><cf_get_lang dictionary_id='57416.Proje'></th>
						</cfif>
						<cfif attributes.report_type eq 1 and listfind(attributes.list_type,7)><!--- belge bazında birimlere gore toplu miktarlar getiriliyor --->
							<th style="text-align:right"><cf_get_lang dictionary_id='57635.Miktar'></th>
						</cfif>
						<cfif attributes.report_type eq 2>
							<th><cf_get_lang dictionary_id='58221.Ürün Adı'></th>
							<cfif listfind(attributes.list_type,6)><th><cf_get_lang dictionary_id='57629.Açıklama'></th></cfif>
							<cfif listfind(attributes.list_type,7)><th><cf_get_lang dictionary_id='57635.Miktar'></th></cfif>
							<th><cf_get_lang dictionary_id='38889.Hesap Kodu'></th>
							<cfif listfind(attributes.list_type,16)><th><cf_get_lang dictionary_id="60278.Ürün Özel Kod"></th></cfif> 
						</cfif>
						<cfif listfind(attributes.list_type,8)>
							<cfloop list="#tax_list#" index="tax_t">
								<th width="60" nowrap="nowrap">%#NumberFormat(tax_t)#<cf_get_lang dictionary_id='57639.KDV'></th>
							</cfloop>
							<cfif isdefined("attributes.is_tevkifat")>
								<cfloop list="#tax_list#" index="tax_t">
									<th width="60" nowrap="nowrap">%#NumberFormat(tax_t)#</th>
								</cfloop>
								<cfloop list="#tax_list#" index="tax_t">
									<th width="60" nowrap="nowrap">%#NumberFormat(tax_t)#</th>
								</cfloop>
							</cfif>
						</cfif>
						<cfif listfind(attributes.list_type,12)>
							<cfloop list="#otv_list#" index="otv_t">
								<th width="140"><cfoutput>%#otv_t#</cfoutput><cf_get_lang dictionary_id="58021.ötv"></th>
							</cfloop>
						</cfif>
						<cfif listfind(attributes.list_type,14)>
							<cfloop list="#bsmv_list#" index="bsmv_t">
								<th width="140"><cfoutput>%#bsmv_t#</cfoutput><cf_get_lang dictionary_id="50923.BSMV"></th>
							</cfloop>
						</cfif>
						<cfif listfind(attributes.list_type,15)>
							<cfloop list="#oiv_list#" index="oiv_t">
								<th width="140"><cfoutput>%#oiv_t#</cfoutput><cf_get_lang dictionary_id='50982.OIV'></th>
							</cfloop>
						</cfif>
						<cfif attributes.report_type eq 1>
							<th width="150"><cf_get_lang dictionary_id='39067.Kdv siz Toplam'></th>
							<th width="150"><cf_get_lang dictionary_id='57678.Fatura Altı İnd'></th>
							<th width="50"><cf_get_lang dictionary_id='57710.Yuvarlama'></th>
						</cfif>
						<th><cf_get_lang dictionary_id='57649.Toplam İnd'></th>
						<th><cf_get_lang dictionary_id='39420.İnd Sonrası Kdv siz Toplam'></th>
						<th><cf_get_lang dictionary_id='58021.ÖTV'><cf_get_lang dictionary_id='57492.Toplam'></th>
						<th><cf_get_lang dictionary_id="50923.BSMV"><cf_get_lang dictionary_id='57492.Toplam'></th>
						<th><cf_get_lang dictionary_id='50982.OIV'><cf_get_lang dictionary_id='57492.Toplam'></th>
						<th><cf_get_lang dictionary_id='40374.ÖTV nin KDV Toplamı'></th>
						<th><cf_get_lang dictionary_id='57643.Kdv Toplam'></th>						
						<th><cf_get_lang dictionary_id='57680.Kdv li Toplam'></th>
					</tr>
				</thead>
			</cfoutput>
			<cfscript>
				toplam_miktar = 0;
				general_otv_total_=0;
				general_bsmv_total_=0;
				general_oiv_total_=0;
				kdvsiz_toplam = 0;
				kdv_toplam = 0;
				devir_toplam = 0;
				devir_genel_toplam=0;
				devir_kdvsiz_toplam_ind=0;
				devir_kdvsiz_tolam=0;
				devir_toplam_indirim=0;
				devir_kdv_toplam=0;
				devir_kdvli_toplam=0;
				devir_round_money_total=0;
				devir_indli_kdvsiz_toplam=0;
				devir_fatalti_ind=0;
				toplam_indirim=0;
				kdvli_toplam = 0;
				fatalti_ind = 0;
				round_mon = 0;
				round_money_total =0;
				paper_total_discount = 0;
				indli_kdvsiz_toplam = 0;
				ind_sonrası_kdvsiz_toplam = 0;
				for(xx=1; xx lte listlen(tax_list); xx=xx+1)
				{
					'kdv_genel_toplam_#NumberFormat(listgetat(tax_list,xx))#'=0;
					'devir_kdv_genel_toplam_#NumberFormat(listgetat(tax_list,xx))#'=0;
					'inv_kdv_genel_toplam_#NumberFormat(listgetat(tax_list,xx))#'=0;
					'beyan_genel_toplam_#NumberFormat(listgetat(tax_list,xx))#'=0;
					'devir_beyan_genel_toplam_#NumberFormat(listgetat(tax_list,xx))#'=0;
					'tevkifat_genel_toplam_#NumberFormat(listgetat(tax_list,xx))#'=0;
					'devir_tevkifat_genel_toplam_#NumberFormat(listgetat(tax_list,xx))#'=0;
				}
				inv_toplam_miktar = 0;
				inv_toplam_indirim = 0;
				inv_indli_kdvsiz_toplam = 0;
				inv_kdv_toplam = 0;
				inv_kdvli_toplam = 0;
			</cfscript>
			<cfset product_list = "">
			<cfset expense_list = "">
			<cfset process_cat_id_list = ''>
			<cfset action_id_list = ''>
			<cfset action_id_list2 = ''>
			<cfset department_id_list=''>
			<cfset dep_branch_id_list=''>
			<cfset row_location_id_list=''>	
			<cfset row_department_id_list=''>
			<cfset project_id_list = ''>	
			<cfif get_invoice.recordcount>
				<cfif attributes.report_type eq 2>
					<cfoutput query="get_invoice" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif type eq 0 and len(product_id) and not listfind(product_list,product_id,',')>
							<cfset product_list = listappend(product_list,product_id,',')>
						</cfif>
						<cfif type eq 1 and len(product_id) and not listfind(expense_list,product_id,',')>
							<cfset expense_list = listappend(expense_list,product_id,',')>
						</cfif>
						<cfif len(process_cat) and process_cat neq 0 and not listfind(process_cat_id_list,process_cat)>
							<cfset process_cat_id_list = Listappend(process_cat_id_list,process_cat)>
						</cfif>
						<cfif len(acc_department_id) and not listfind(department_id_list,acc_department_id)>
							<cfset department_id_list = Listappend(department_id_list,acc_department_id)>
						</cfif>
						<cfif len(row_dept) and not listfind(row_department_id_list,row_dept)>
							<cfset row_department_id_list = Listappend(row_department_id_list,row_dept)>
						</cfif>
						<cfif len("#row_dept#-#row_loc#") and not listfind(row_location_id_list,"#row_dept#-#row_loc#")>
							<cfset row_location_id_list=listappend(row_location_id_list,"#row_dept#-#row_loc#")>
						</cfif>
						<cfif len(row_project_id) and not listfind(project_id_list,row_project_id)>
							<cfset project_id_list = Listappend(project_id_list,row_project_id)>
						</cfif>
					</cfoutput>
				<cfelse>
					<cfoutput query="get_invoice" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(process_cat) and process_cat neq 0 and not listfind(process_cat_id_list,process_cat)>
							<cfset process_cat_id_list = Listappend(process_cat_id_list,process_cat)>
						</cfif>
						<cfif type eq 0 and not listfind(action_id_list,action_id)>
							<cfset action_id_list = Listappend(action_id_list,action_id)>
						</cfif>
						<cfif len(acc_department_id) and not listfind(department_id_list,acc_department_id)>
							<cfset department_id_list = Listappend(department_id_list,acc_department_id)>
						</cfif>
						<cfif len(row_dept) and not listfind(row_department_id_list,row_dept)>
							<cfset row_department_id_list = Listappend(row_department_id_list,row_dept)>
						</cfif>
						<cfif len("#row_dept#-#row_loc#") and not listfind(row_location_id_list,"#row_dept#-#row_loc#")>
							<cfset row_location_id_list=listappend(row_location_id_list,"#row_dept#-#row_loc#")>
						</cfif>
						<cfif len(project_id) and not listfind(project_id_list,project_id)>
							<cfset project_id_list = Listappend(project_id_list,project_id)>
						</cfif>
					</cfoutput>
				</cfif>
				<cfif len(department_id_list)>
					<cfquery name="get_department_info" datasource="#dsn#">
						SELECT
							B.BRANCH_NAME,
							D.DEPARTMENT_HEAD,
							D.DEPARTMENT_ID
						FROM 
							BRANCH B,
							DEPARTMENT D
						WHERE
							D.DEPARTMENT_ID IN (#department_id_list#) AND
							B.BRANCH_ID = D.BRANCH_ID
						ORDER BY
							D.DEPARTMENT_ID
					</cfquery>
					<cfset department_id_list=listsort(listdeleteduplicates(valuelist(get_department_info.department_id,',')),'numeric','ASC',',')>
				</cfif>
				<cfif len(row_department_id_list)>
					<cfquery name="get_department_info_row" datasource="#dsn#">
						SELECT
							B.BRANCH_NAME,
							D.DEPARTMENT_HEAD,
							D.DEPARTMENT_ID
						FROM 
							BRANCH B,
							DEPARTMENT D
						WHERE
							D.DEPARTMENT_ID IN (#row_department_id_list#) AND
							B.BRANCH_ID = D.BRANCH_ID
						ORDER BY
							D.DEPARTMENT_ID
					</cfquery>
					<cfset row_department_id_list=listsort(listdeleteduplicates(valuelist(get_department_info_row.department_id,',')),'numeric','ASC',',')>
				</cfif>
				<cfif ListLen(row_location_id_list,',')>
					<cfset row_location_id_list=listsort(row_location_id_list,'text','asc',',')>
					<cfquery name="get_location" datasource="#dsn#">
						SELECT
							SL.COMMENT,
							CAST(D.DEPARTMENT_ID AS NVARCHAR(10)) + CAST('-' AS NVARCHAR(1)) + CAST(SL.LOCATION_ID AS NVARCHAR(10)) DEPARTMENT_LOCATIONS_
						FROM
							DEPARTMENT D,
							STOCKS_LOCATION SL
						WHERE
							D.DEPARTMENT_ID = SL.DEPARTMENT_ID AND
							D.IS_STORE <> 2 AND
							CAST(D.DEPARTMENT_ID AS NVARCHAR(10)) + CAST('-' AS NVARCHAR(1)) + CAST(SL.LOCATION_ID AS NVARCHAR(10)) IN (#ListQualify(row_location_id_list,"'",",")#)
						ORDER BY
							CAST(D.DEPARTMENT_ID AS NVARCHAR(10)) + CAST('-' AS NVARCHAR(1)) + CAST(SL.LOCATION_ID AS NVARCHAR(10))
					</cfquery>
					<cfset row_location_id_list = ListSort(ListDeleteDuplicates(ValueList(get_location.department_locations_,',')),"text","asc",",")>
				</cfif>
				<cfif len(process_cat_id_list)>
					<cfset process_cat_id_list=listsort(process_cat_id_list,"numeric","ASC",",")>			
					<cfquery name="get_process_cat" datasource="#DSN3#">
						SELECT PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID IN (#process_cat_id_list#) ORDER BY PROCESS_CAT_ID
					</cfquery>
					<cfset process_cat_id_list = listsort(listdeleteduplicates(valuelist(get_process_cat.PROCESS_CAT_ID,',')),'numeric','ASC',',')>
				</cfif>
				<cfif len(product_list)>
					<cfset product_list = listsort(product_list,"numeric","ASC",",")>
					<cfquery name="get_account_product" datasource="#dsn3#">
						SELECT * FROM PRODUCT_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND PRODUCT_ID IN (#product_list#) ORDER BY PRODUCT_ID
					</cfquery>
					<cfset product_list = listsort(listdeleteduplicates(valuelist(get_account_product.product_id,',')),"numeric","ASC",",")>
				</cfif>
				<cfif len(expense_list)>
					<cfset expense_list = listsort(expense_list,"numeric","ASC",",")>
					<cfquery name="get_account_expense" datasource="#dsn2#">
						SELECT * FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID IN (#expense_list#) ORDER BY EXPENSE_ITEM_ID
					</cfquery>
					<cfset expense_list = listsort(listdeleteduplicates(valuelist(get_account_expense.expense_item_id,',')),"numeric","ASC",",")>
				</cfif>
				<cfif len(project_id_list)>
					<cfset project_id_list = listsort(project_id_list,"numeric","ASC",",")>
					<cfquery name="get_project" datasource="#dsn#">
						SELECT PROJECT_HEAD,PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_id_list#) ORDER BY PROJECT_ID
					</cfquery>
					<cfset project_id_list = listsort(listdeleteduplicates(valuelist(get_project.PROJECT_ID,',')),"numeric","ASC",",")>
				</cfif>
				<cfif attributes.page gt 1>
					<cfif isdefined("attributes.is_tevkifat")>
						<cfoutput query="get_invoice" startrow="1" maxrows="#attributes.startrow-1#">
							<cfif type eq 0 and not listfind(action_id_list2,action_id)>
								<cfset action_id_list2 = Listappend(action_id_list2,action_id)>
							</cfif>
						</cfoutput>
					</cfif>
					<cfif len(action_id_list2)>
						<cfquery name="get_invoice_taxes" datasource="#dsn2#">
							SELECT * FROM INVOICE_TAXES WHERE INVOICE_ID IN (#action_id_list2#) ORDER BY INVOICE_ID
						</cfquery>
						<cfoutput query="get_invoice_taxes">
							<cfset "tax_beyan_#invoice_id#_#tax#" = BEYAN_TUTAR>
							<cfset "tax_tevkifat_#invoice_id#_#tax#" = TEVKIFAT_TUTAR>
						</cfoutput>
					</cfif>
					<cfif attributes.report_type eq 1>
						<cfoutput query="get_invoice" startrow="1" maxrows="#attributes.startrow-1#">
							<cfquery name="GET_INV_ROWS" dbtype="query">
								SELECT 
									ACTION_ID,ROW_TAXTOTAL,ROW_OTVTOTAL,OTVTOTAL,TAX,OTV_ORAN as OTV,DISCOUNTTOTAL,GROSSTOTAL,SA_DISCOUNT,ROUND_MONEY,OTV_ORAN,NETTOTAL,TAXTOTAL,PRODUCT_CAT,PRODUCT_CATID,UNIT,ROW_QUANTITY,BSMVTOTAL,BSMV_RATE,ROW_BSMVTOTAL,OIVTOTAL,OIV_RATE,ROW_OIVTOTAL
								FROM 
									get_invoice_detail 
								WHERE 
									ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ACTION_ID#">
									AND TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice.TYPE#">
							</cfquery>
							<cfscript>
								if( isdefined ("INV_DISCOUNTTOTAL") and len(INV_DISCOUNTTOTAL) and (GROSSTOTAL - INV_DISCOUNTTOTAL) neq 0)
									oran_2 = ((GROSSTOTAL - INV_DISCOUNTTOTAL) - SA_DISCOUNT) / (GROSSTOTAL - INV_DISCOUNTTOTAL);
								else
								oran_2 = 1;
								paper_total_discount=0;
								kdv_of_otv_total = 0;
								otv_toplam = 0;
								bsmv_toplam = 0;
								oiv_toplam = 0;
								for(tt=1; tt lte GET_INV_ROWS.recordcount; tt=tt+1)
								{
									if(isdefined('kdv_toplam_#GET_INV_ROWS.TAX[tt]#_#GET_INV_ROWS.ACTION_ID[tt]#_#get_invoice.type#') and len(evaluate('kdv_toplam_#GET_INV_ROWS.TAX[tt]#_#GET_INV_ROWS.ACTION_ID[tt]#_#get_invoice.type#')))
										'kdv_toplam_#GET_INV_ROWS.TAX[tt]#_#GET_INV_ROWS.ACTION_ID[tt]#_#get_invoice.type#' = evaluate('kdv_toplam_#GET_INV_ROWS.TAX[tt]#_#GET_INV_ROWS.ACTION_ID[tt]#_#get_invoice.type#') + GET_INV_ROWS.ROW_TAXTOTAL[tt];
									else
										'kdv_toplam_#GET_INV_ROWS.TAX[tt]#_#GET_INV_ROWS.ACTION_ID[tt]#_#get_invoice.type#' =GET_INV_ROWS.ROW_TAXTOTAL[tt];

									if (attributes.report_type eq 1)
									{
										if(isdefined('otv_toplam') and len(otv_toplam) )
											otv_toplam = otv_toplam + wrk_round((GET_INV_ROWS.OTVTOTAL[tt]*oran_2),4);
										else
											otv_toplam =wrk_round((GET_INV_ROWS.OTVTOTAL[tt]*oran_2),4);

										otv_ = filterSpecialChars(GET_INV_ROWS.OTV[tt]);
										if(isdefined('otv_toplam_#otv_#_#GET_INV_ROWS.ACTION_ID[tt]#_#get_invoice.type#') and len(evaluate('otv_toplam_#otv_#_#GET_INV_ROWS.ACTION_ID[tt]#_#get_invoice.type#')))
											'otv_toplam_#otv_#_#GET_INV_ROWS.ACTION_ID[tt]#_#get_invoice.type#' = evaluate('otv_toplam_#otv_#_#GET_INV_ROWS.ACTION_ID[tt]#_#get_invoice.type#') + GET_INV_ROWS.ROW_OTVTOTAL[tt];
										else
											'otv_toplam_#otv_#_#GET_INV_ROWS.ACTION_ID[tt]#_#get_invoice.type#' =GET_INV_ROWS.ROW_OTVTOTAL[tt];	

										if( not len(GET_INV_ROWS.BSMVTOTAL[tt]) ) GET_INV_ROWS.BSMVTOTAL[tt] = 0;
										if(isdefined('bsmv_toplam') and len(bsmv_toplam) )
											bsmv_toplam = bsmv_toplam + wrk_round((GET_INV_ROWS.BSMVTOTAL[tt]*oran_2),4);
										else
											bsmv_toplam =wrk_round((GET_INV_ROWS.BSMVTOTAL[tt]*oran_2),4);

										if( not len(GET_INV_ROWS.OIVTOTAL[tt]) ) GET_INV_ROWS.OIVTOTAL[tt] = 0;
										if(isdefined('oiv_toplam') and len(oiv_toplam) )
											oiv_toplam = oiv_toplam + wrk_round((GET_INV_ROWS.OIVTOTAL[tt]*oran_2),4);
										else
											oiv_toplam =wrk_round((GET_INV_ROWS.OIVTOTAL[tt]*oran_2),4);
									}							
														
									if(len(GET_INV_ROWS.DISCOUNTTOTAL[tt])) // fatura altı indirim dahil
									{
										if(isdefined('paper_total_discount') and len(paper_total_discount))
											paper_total_discount = paper_total_discount + GET_INV_ROWS.DISCOUNTTOTAL[tt];
										else
											paper_total_discount = GET_INV_ROWS.DISCOUNTTOTAL[tt];
									}
									if(len(GET_INVOICE.IS_TAX_OF_OTV) and GET_INVOICE.IS_TAX_OF_OTV eq 1 and GET_INV_ROWS.TAX[tt] neq 0 and GET_INV_ROWS.OTVTOTAL[tt] neq 0)
									{
										if(isdefined('kdv_of_otv_total') and len(kdv_of_otv_total) )
											kdv_of_otv_total = kdv_of_otv_total+((GET_INV_ROWS.OTVTOTAL[tt]*GET_INV_ROWS.TAX[tt])/100);
										else
											kdv_of_otv_total = (GET_INV_ROWS.OTVTOTAL[tt]*GET_INV_ROWS.TAX[tt])/100;
									}
								}
								//if(len(GET_INV_ROWS.GROSSTOTAL))
									//kdvsiz_toplam = kdvsiz_toplam + wrk_round(GET_INV_ROWS.GROSSTOTAL);
								if(len(GET_INV_ROWS.SA_DISCOUNT))
								{
									fatalti_ind=fatalti_ind + wrk_round(GET_INV_ROWS.SA_DISCOUNT);
									paper_total_discount = paper_total_discount + wrk_round(GET_INV_ROWS.SA_DISCOUNT);
									if((GET_INV_ROWS.NETTOTAL-GET_INV_ROWS.TAXTOTAL-otv_toplam-bsmv_toplam-oiv_toplam+GET_INV_ROWS.SA_DISCOUNT) gt 0)
										inv_disc_row_rate= 1 - GET_INV_ROWS.SA_DISCOUNT/(GET_INV_ROWS.NETTOTAL-GET_INV_ROWS.TAXTOTAL-otv_toplam-bsmv_toplam-oiv_toplam+GET_INV_ROWS.SA_DISCOUNT);
									else
										inv_disc_row_rate= 1;
								}
								if(len(GET_INV_ROWS.ROUND_MONEY))
									round_money_total=round_money_total + wrk_round(GET_INV_ROWS.ROUND_MONEY);
								
								devir_toplam =devir_toplam + TAXTOTAL;
								devir_genel_toplam =devir_genel_toplam + NETTOTAL;
								devir_kdvsiz_tolam =devir_kdvsiz_tolam +(GROSSTOTAL-(paper_total_discount)); 
								devir_toplam_indirim=devir_toplam_indirim+wrk_round(paper_total_discount);
								if(attributes.report_type eq 1)
								{
									devir_kdvsiz_toplam_ind=devir_kdvsiz_toplam_ind+ wrk_round(GET_INV_ROWS.GROSSTOTAL);
									if(len(GET_INV_ROWS.SA_DISCOUNT))
										devir_fatalti_ind=devir_fatalti_ind+wrk_round(GET_INV_ROWS.SA_DISCOUNT);
									if(len(GET_INV_ROWS.ROUND_MONEY))
										devir_round_money_total=devir_round_money_total+ wrk_round(GET_INV_ROWS.ROUND_MONEY);
								}
							</cfscript>
							<cfloop list="#tax_list#" index="tax_ii">
								<cfset tax_count=NumberFormat(tax_ii)>
								<cfif isdefined('kdv_toplam_#tax_count#_#action_id#_#type#') and len(evaluate('kdv_toplam_#tax_count#_#action_id#_#type#'))>
								<cfset 'devir_kdv_genel_toplam_#tax_count#' = evaluate('devir_kdv_genel_toplam_#tax_count#') + (evaluate('kdv_toplam_#tax_count#_#action_id#_#type#'))>
								</cfif>
								<cfif isdefined("attributes.is_tevkifat")>
									<cfif type eq 0 and isdefined('tax_tevkifat_#action_id#_#tax_count#') and len(evaluate('tax_tevkifat_#action_id#_#tax_count#'))>
										<cfset 'devir_tevkifat_genel_toplam_#tax_count#' = evaluate('devir_tevkifat_genel_toplam_#tax_count#') + (evaluate('tax_tevkifat_#action_id#_#tax_count#'))>
									</cfif>
									<cfif type eq 0 and isdefined('tax_beyan_#action_id#_#tax_count#') and len(evaluate('tax_beyan_#action_id#_#tax_count#'))>
										<cfset 'devir_beyan_genel_toplam_#tax_count#' = evaluate('devir_beyan_genel_toplam_#tax_count#') + (evaluate('tax_beyan_#action_id#_#tax_count#'))>
									</cfif>
								</cfif>
							</cfloop>
							<cfif listfind(attributes.list_type,7)>
								<cfquery name="GET_INV_ROWS" dbtype="query">
									SELECT 
										UNIT,ROW_QUANTITY
									FROM 
										get_invoice_detail 
									WHERE 
										ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ACTION_ID#">
										AND TYPE =#get_invoice.TYPE#
								</cfquery>
								<cfscript>
									for(tt=1; tt lte GET_INV_ROWS.recordcount; tt=tt+1)
									{
										unit_=filterSpecialChars(GET_INV_ROWS.UNIT[tt]);
										if(len(unit_))
										{'devir_last_total_amount_#unit_#' = evaluate('devir_last_total_amount_#unit_#') + GET_INV_ROWS.ROW_QUANTITY[tt];}
										else
										{'devir_last_total_amount_' = evaluate('devir_last_total_amount_') + GET_INV_ROWS.ROW_QUANTITY[tt];}
									}
								</cfscript>
							</cfif>
						</cfoutput>
					<cfelse>
						<cfoutput query="get_invoice" startrow="1" maxrows="#attributes.startrow-1#">
							<cfset temp_row_tax_total_=0>
							<cfset row_grosstotal_=0>
							<cfif (get_invoice.currentrow eq 1 or get_invoice.ACTION_ID[currentrow] neq get_invoice.ACTION_ID[currentrow-1] or not isdefined('temp_disc_total')) and get_invoice.SA_DISCOUNT neq 0>
								<cfquery name="GET_INV_ROWS" dbtype="query">
									SELECT 
										ACTION_ID,SUM(DISCOUNTTOTAL) AS INV_DISCOUNTTOTAL,
										SUM(ROW_TAXTOTAL) AS TOTAL_AMOUNT_KDV
									FROM 
										get_invoice_detail
									WHERE 
										ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice.ACTION_ID#">
										AND TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice.TYPE#">
									GROUP BY
										ACTION_ID
								</cfquery>
								<cfset temp_disc_total =GET_INV_ROWS.INV_DISCOUNTTOTAL>
							</cfif>
							<cfif get_invoice.SA_DISCOUNT neq 0 and len(temp_disc_total) and (GROSSTOTAL - temp_disc_total) neq 0>
								<cfset oran_2 = ((GROSSTOTAL - temp_disc_total) - SA_DISCOUNT) / (GROSSTOTAL - temp_disc_total)>
							<cfelse>
								<cfset oran_2 =1>
							</cfif>
							<cfloop list="#tax_list#" index="tax_ii">
								<cfset tax_count=NumberFormat(tax_ii)>
								<cfif NumberFormat(get_invoice.TAX eq tax_count)>
									<cfif len(get_invoice.ROW_TAXTOTAL)>
										<cfset temp_row_tax_total_ = wrk_round(get_invoice.ROW_TAXTOTAL)>
										<cfif isdefined('devir_kdv_genel_toplam_#tax_count#') and len(evaluate('devir_kdv_genel_toplam_#tax_count#'))>
											<cfset 'devir_kdv_genel_toplam_#tax_count#' = evaluate('devir_kdv_genel_toplam_#tax_count#') + (get_invoice.ROW_TAXTOTAL)>
										<cfelse>
											<cfset 'devir_kdv_genel_toplam_#tax_count#' = (get_invoice.ROW_TAXTOTAL)>
										</cfif>
									</cfif>
								</cfif>
							</cfloop>
							<cfset unit__=filterSpecialChars(unit)>
							<cfset 'devir_total_row_quantity_#unit__#' = evaluate('devir_total_row_quantity_#unit__#') + ROW_QUANTITY>
							<cfif len(get_invoice.DISCOUNTTOTAL)><cfset devir_toplam_indirim=devir_toplam_indirim+(get_invoice.DISCOUNTTOTAL+(get_invoice.DISCOUNTTOTAL*(1-oran_2)))></cfif>
							<cfif len(get_invoice.KDVSIZ_TOPLAM)>
								<cfset devir_kdvsiz_tolam = devir_kdvsiz_tolam + (get_invoice.KDVSIZ_TOPLAM*oran_2)>
								<cfset devir_row_grosstotal_=temp_row_tax_total_+(get_invoice.KDVSIZ_TOPLAM)>
							</cfif>
							<cfset devir_toplam = devir_toplam + temp_row_tax_total_>
							<cfset devir_genel_toplam = devir_genel_toplam + devir_row_grosstotal_>
						</cfoutput>
					</cfif>
				</cfif>
				<cfoutput query="get_invoice" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfif attributes.report_type eq 1>
						<cfquery name="GET_INV_ROWS" dbtype="query">
							SELECT 
								ACTION_ID,ROW_TAXTOTAL,ROW_OTVTOTAL,OTVTOTAL,TAX,OTV_ORAN as OTV,DISCOUNTTOTAL,GROSSTOTAL,SA_DISCOUNT,ROUND_MONEY,OTV_ORAN,NETTOTAL,TAXTOTAL,PRODUCT_CAT,PRODUCT_CATID,UNIT,ROW_QUANTITY,BSMVTOTAL,BSMV_RATE,ROW_BSMVTOTAL,OIVTOTAL,OIV_RATE,ROW_OIVTOTAL
							FROM 
								get_invoice_detail 
							WHERE 
								ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ACTION_ID#">
								AND TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice.TYPE#">
						</cfquery>
						<cfscript>
							inv_disc_row_rate = 0; /*fatura altı indirimin satırlara yansıma oranı*/
							product_cat_list='';
							product_cat_id_list='';
							unit_list_='';
							if(len(INV_DISCOUNTTOTAL) and (GROSSTOTAL - INV_DISCOUNTTOTAL) neq 0)
								oran_2 = ((GROSSTOTAL - INV_DISCOUNTTOTAL) - SA_DISCOUNT) / (GROSSTOTAL - INV_DISCOUNTTOTAL);
							else
								oran_2 = 1;
							paper_total_discount=0;
							kdv_of_otv_total = 0;
							otv_toplam = 0;
							bsmv_toplam = 0;
							for(tt=1; tt lte GET_INV_ROWS.recordcount; tt=tt+1)
							{
								if(isdefined('kdv_toplam_#GET_INV_ROWS.TAX[tt]#_#GET_INV_ROWS.ACTION_ID[tt]#_#get_invoice.type#') and len(evaluate('kdv_toplam_#GET_INV_ROWS.TAX[tt]#_#GET_INV_ROWS.ACTION_ID[tt]#_#get_invoice.type#')))
									'kdv_toplam_#GET_INV_ROWS.TAX[tt]#_#GET_INV_ROWS.ACTION_ID[tt]#_#get_invoice.type#' = evaluate('kdv_toplam_#GET_INV_ROWS.TAX[tt]#_#GET_INV_ROWS.ACTION_ID[tt]#_#get_invoice.type#') + GET_INV_ROWS.ROW_TAXTOTAL[tt];
								else
									'kdv_toplam_#GET_INV_ROWS.TAX[tt]#_#GET_INV_ROWS.ACTION_ID[tt]#_#get_invoice.type#' =GET_INV_ROWS.ROW_TAXTOTAL[tt];
							
								if(isdefined('otv_toplam') and len(otv_toplam) )
									otv_toplam = otv_toplam + wrk_round((GET_INV_ROWS.OTVTOTAL[tt]),4);
								else
									otv_toplam =wrk_round((GET_INV_ROWS.OTVTOTAL[tt]),4);

								otv_ = filterSpecialChars(GET_INV_ROWS.OTV[tt]);
								if(isdefined('otv_toplam_#otv_#_#GET_INV_ROWS.ACTION_ID[tt]#_#get_invoice.type#') and len(evaluate('otv_toplam_#otv_#_#GET_INV_ROWS.ACTION_ID[tt]#_#get_invoice.type#')))
										'otv_toplam_#otv_#_#GET_INV_ROWS.ACTION_ID[tt]#_#get_invoice.type#' = evaluate('otv_toplam_#otv_#_#GET_INV_ROWS.ACTION_ID[tt]#_#get_invoice.type#') + GET_INV_ROWS.ROW_OTVTOTAL[tt];
									else
										'otv_toplam_#otv_#_#GET_INV_ROWS.ACTION_ID[tt]#_#get_invoice.type#' =GET_INV_ROWS.ROW_OTVTOTAL[tt];
								
								if( not len(GET_INV_ROWS.BSMVTOTAL[tt]) ) GET_INV_ROWS.BSMVTOTAL[tt] = 0;
								if(isdefined('bsmv_toplam') and len(bsmv_toplam) )
									bsmv_toplam = bsmv_toplam + wrk_round((GET_INV_ROWS.BSMVTOTAL[tt]),4);
								else
									bsmv_toplam =wrk_round(numberFormat(GET_INV_ROWS.BSMVTOTAL[tt]),4);

								if( not len(GET_INV_ROWS.OIVTOTAL[tt]) ) GET_INV_ROWS.OIVTOTAL[tt] = 0;
								if(isdefined('oiv_toplam') and len(oiv_toplam) )
									oiv_toplam = oiv_toplam + wrk_round((GET_INV_ROWS.OIVTOTAL[tt]),4);
								else
									oiv_toplam =wrk_round(numberFormat(GET_INV_ROWS.OIVTOTAL[tt]),4);
															
								if(len(GET_INV_ROWS.DISCOUNTTOTAL[tt])) // fatura altı indirim dahil
								{
									if(isdefined('paper_total_discount') and len(paper_total_discount))
										paper_total_discount = paper_total_discount + GET_INV_ROWS.DISCOUNTTOTAL[tt];
									else
										paper_total_discount = GET_INV_ROWS.DISCOUNTTOTAL[tt];
								}
								if(len(GET_INVOICE.IS_TAX_OF_OTV) and GET_INVOICE.IS_TAX_OF_OTV eq 1 and GET_INV_ROWS.TAX[tt] neq 0 and GET_INV_ROWS.OTV_ORAN[tt] neq 0)
								{
									if(isdefined('kdv_of_otv_total') and len(kdv_of_otv_total) )
										kdv_of_otv_total = kdv_of_otv_total+((GET_INV_ROWS.OTVTOTAL[tt]*GET_INV_ROWS.TAX[tt])/100);
									else
										kdv_of_otv_total = (GET_INV_ROWS.OTVTOTAL[tt]*GET_INV_ROWS.TAX[tt])/100;
								}
								
								if(len(GET_INV_ROWS.PRODUCT_CATID[tt]) and len(GET_INV_ROWS.PRODUCT_CAT[tt]) and not listfind(product_cat_id_list,GET_INV_ROWS.PRODUCT_CATID[tt]))
								{
									product_cat_id_list=listappend(product_cat_id_list,GET_INV_ROWS.PRODUCT_CATID[tt]);
									product_cat_list=listappend(product_cat_list,GET_INV_ROWS.PRODUCT_CAT[tt],'§'); //alt+789
								}
								if(len(GET_INV_ROWS.UNIT[tt])) //birimlere gore miktar toplamı alınıyor
								{
									
									unit_=filterSpecialChars(GET_INV_ROWS.UNIT[tt]);
									if(not listfind(unit_list_,unit_))
									{
										unit_list_=listappend(unit_list_,unit_);
										'total_amount_#GET_INV_ROWS.ACTION_ID[tt]#_#unit_#'=GET_INV_ROWS.ROW_QUANTITY[tt];
									}
									else if(isdefined('total_amount_#GET_INV_ROWS.ACTION_ID[tt]#_#unit_#') and len(evaluate('total_amount_#GET_INV_ROWS.ACTION_ID[tt]#_#unit_#')) )
									{
										'total_amount_#GET_INV_ROWS.ACTION_ID[tt]#_#unit_#'=evaluate('total_amount_#GET_INV_ROWS.ACTION_ID[tt]#_#unit_#')+GET_INV_ROWS.ROW_QUANTITY[tt];
									}
									else
									{
										'total_amount_#GET_INV_ROWS.ACTION_ID[tt]#_#unit_#'= GET_INV_ROWS.ROW_QUANTITY[tt];
									}
								}
								else
								{
									'total_amount_#GET_INV_ROWS.ACTION_ID[tt]#'= GET_INV_ROWS.ROW_QUANTITY[tt];
								}
								
							}
							if (not len(GET_INV_ROWS.BSMVTOTAL))  GET_INV_ROWS.BSMVTOTAL = 0;
							if (not len(GET_INV_ROWS.OIVTOTAL))  GET_INV_ROWS.OIVTOTAL = 0;
							if(len(GET_INV_ROWS.NETTOTAL))
								kdvsiz_toplam = kdvsiz_toplam + wrk_round(GET_INV_ROWS.NETTOTAL-GET_INV_ROWS.TAXTOTAL-GET_INV_ROWS.OTVTOTAL-GET_INV_ROWS.BSMVTOTAL-GET_INV_ROWS.OIVTOTAL);
							if(len(GET_INV_ROWS.SA_DISCOUNT))
							{
								fatalti_ind=fatalti_ind + wrk_round(GET_INV_ROWS.SA_DISCOUNT);
								paper_total_discount = paper_total_discount + wrk_round(GET_INV_ROWS.SA_DISCOUNT);
								if((GET_INV_ROWS.NETTOTAL-GET_INV_ROWS.TAXTOTAL-otv_toplam-bsmv_toplam-oiv_toplam+GET_INV_ROWS.SA_DISCOUNT) gt 0)
									inv_disc_row_rate= 1 - GET_INV_ROWS.SA_DISCOUNT/(GET_INV_ROWS.NETTOTAL-GET_INV_ROWS.TAXTOTAL-otv_toplam-bsmv_toplam-oiv_toplam+GET_INV_ROWS.SA_DISCOUNT);
								else
									inv_disc_row_rate= 1;
							}
							if(len(GET_INV_ROWS.ROUND_MONEY))
								round_money_total=round_money_total + wrk_round(GET_INV_ROWS.ROUND_MONEY);
						</cfscript>
						<tbody>
							<tr>
								<td>#SERIAL_NUMBER#</td>
								<td>
									<cfif isdefined('attributes.is_excel') and listfind('1,2',attributes.is_excel)>
										#get_invoice.BELGE_NO#
									<cfelse>
										<cfif get_invoice.invoice_cat eq 65>
											<cfif attributes.is_excel eq 0>
												<a href="#request.self#?fuseaction=invent.upd_purchase_invent&invoice_id=#get_invoice.ACTION_ID#" class="tableyazi">#get_invoice.BELGE_NO#</a>
											<cfelse>
											#get_invoice.BELGE_NO#
											</cfif>
										<cfelseif get_invoice.invoice_cat eq 66>
											<cfif attributes.is_excel eq 0>
												<a href="#request.self#?fuseaction=invent.upd_invent_sale&invoice_id=#get_invoice.ACTION_ID#" class="tableyazi">#get_invoice.BELGE_NO#</a>
											<cfelse>
											#get_invoice.BELGE_NO#
											</cfif>
										<cfelseif get_invoice.invoice_cat eq 52>
											<cfif attributes.is_excel eq 0>
												<a href="#request.self#?fuseaction=invoice.form_add_bill&event=upd&iid=#get_invoice.ACTION_ID#" class="tableyazi">#get_invoice.BELGE_NO#</a>
											<cfelse>
											#get_invoice.BELGE_NO#
											</cfif>
										<cfelseif get_invoice.invoice_cat eq 121>
											<cfif attributes.is_excel eq 0>
												<a href="#request.self#?fuseaction=cost.add_income_cost&event=upd&expense_id=#get_invoice.ACTION_ID#" class="tableyazi">#get_invoice.BELGE_NO#</a>
											<cfelse>
											#get_invoice.BELGE_NO#
											</cfif>
										<cfelse>
											<cfif attributes.is_excel eq 0>
												<a href="#request.self#?fuseaction=invoice.form_add_bill&event=upd&iid=#get_invoice.ACTION_ID#" class="tableyazi">#get_invoice.BELGE_NO#</a>
											<cfelse>
											#get_invoice.BELGE_NO#
											</cfif>
										</cfif>
									</cfif>
								</td>
								<td width="100"><cfif len(process_cat)>#get_process_cat.process_cat[listfind(process_cat_id_list,process_cat,',')]#</cfif></td>
								<td format="dateformat">#dateformat(ACTION_DATE,dateformat_style)#</td>
								<cfif listfind(attributes.list_type,10)>
									<td format="dateformat">#dateformat(DUE_DATE,dateformat_style)#</td>
								</cfif>
								<cfif listfind(attributes.list_type,11)>
									<cfset get_value.recordcount = 0>
									<cfset get_type.recordcount = 0>
									<cfloop query="get_add_info_name">
										<td>
											<cfset my_kolon = replace(PROPERTY,'_NAME','')>
											<cfset my_kolon1 = replace(PROPERTY,'_NAME','')>
											<cfset my_kolon1 = replace(my_kolon1,'PROPERTY','')>
											<cfset my_kolon2 = replace(PROPERTY,'_NAME','')>
											<cfset my_kolon2 = my_kolon2&'_TYPE'>
											<cfquery name="get_type" datasource="#dsn3#">
												SELECT  #my_kolon2# FROM SETUP_PRO_INFO_PLUS_NAMES where #my_kolon2# = 'select' and OWNER_TYPE_ID =-8
											</cfquery>
											<cfif isnumeric(evaluate('get_invoice.#my_kolon#')) and get_type.recordcount >
												<cfquery name="get_value" datasource="#dsn3#">
														SELECT SELECT_VALUE,PROPERTY_NO FROM SETUP_PRO_INFO_PLUS_VALUES WHERE PROPERTY_NO = #my_kolon1# AND INFO_ROW_ID=#evaluate('get_invoice.#my_kolon#')#
												</cfquery>
											<cfelse>
												<cfset get_value.recordcount = 0 >
											</cfif>
											<cfif get_value.recordcount and get_type.recordcount>
												#get_value.SELECT_VALUE# 
											<cfelse>
												#evaluate('get_invoice.#my_kolon#')#
											</cfif>
											<cfset get_value.recordcount = 0>
										</td>
									<cfset get_value.SELECT_VALUE =''>
									</cfloop>
									<cfset get_value.SELECT_VALUE =''>
								</cfif>
								<cfif listfind(attributes.list_type,1)>
									<td><cfif len(row_department_id_list)>#get_department_info_row.department_head[listfind(row_department_id_list,row_dept)]#</cfif></td>
									<td><cfif len(row_location_id_list)>#get_location.comment[ListFind(row_location_id_list,"#row_dept#-#row_loc#",',')]#</cfif></td>
								</cfif>
								<cfif listfind(attributes.list_type,2)>
									<td>#ozel_kod#</td>
								</cfif>
								<td>#member_code#</td>
								<td>#FULLNAME#</td>
								<cfif listfind(attributes.list_type,13)> 
									<td>#SUBS_NAME#</td> 		
								</cfif>
								<cfif listfind(attributes.list_type,17)> 
									<td>#subscription_no#</td> 		
								</cfif>
								<cfif listfind(attributes.list_type,18)> 
									<td>#ship_address#</td> 		
								</cfif>
								<cfif attributes.report_type eq 1 and listfind(attributes.list_type,6)>
									<td>#note#</td>
								</cfif>
								<td>#TAXOFFICE#</td>
								<td>#TAXNO#</td>
								<cfif listfind(attributes.list_type,3)>
									<td>#TC_IDENTY_NO#</td>
								</cfif>
								<cfif listfind(attributes.list_type,4)>
									<td nowrap="nowrap"><!--- urun kategorileri --->
										<cfloop list="#product_cat_id_list#" index="cat_ii">
											#listgetat(product_cat_list,listfind(product_cat_id_list,cat_ii),'§')#
											<cfif cat_ii neq listlast(product_cat_id_list)>, <cfif attributes.is_excel neq 1> <cfif type_ neq 2><br/></cfif></cfif></cfif>
										</cfloop>
									</td>
								</cfif>
								<cfif listfind(attributes.list_type,5)>
									<td>
										<cfif len(acc_department_id)>#get_department_info.BRANCH_NAME[listfind(department_id_list,acc_department_id,',')]#  - #get_department_info.department_head[listfind(department_id_list,acc_department_id,',')]#</cfif>
									</td>
								</cfif>
								<cfif listfind(attributes.list_type,9)>
									<td>
										<cfif len(project_id)>#get_project.PROJECT_HEAD[listfind(project_id_list,project_id,',')]#</cfif>
									</td>
								</cfif>
								<cfif attributes.report_type eq 1 and listfind(attributes.list_type,7)>
									<td nowrap="nowrap" style="text-align:right" format="numeric"><!--- birim bazında miktar toplamları --->
										<cfif listlen(unit_list_)>
											<cfloop list="#unit_list_#" index="unit_ii">
												<cfif isdefined('total_amount_#action_id#_#unit_ii#') and len(evaluate('total_amount_#action_id#_#unit_ii#'))>
													#TLFormat(evaluate('total_amount_#action_id#_#unit_ii#'))# #unit_ii# <cfif type_ neq 2><br/></cfif>
													<cfset 'last_total_amount_#unit_ii#' = evaluate('last_total_amount_#unit_ii#') + evaluate('total_amount_#action_id#_#unit_ii#')>
													<cfset 'devir_last_total_amount_#unit_ii#' = evaluate('devir_last_total_amount_#unit_ii#') + evaluate('total_amount_#action_id#_#unit_ii#')>
												</cfif>
		
											</cfloop>
										<cfelse>
											<cfif isdefined('total_amount_#action_id#') and len(evaluate('total_amount_#action_id#'))>
												#TLFormat(evaluate('total_amount_#action_id#'))#<cfif type_ neq 2><br/></cfif>
												<cfset 'last_total_amount_' = evaluate('last_total_amount_') + evaluate('total_amount_#action_id#')>
												<cfset 'devir_last_total_amount_' = evaluate('devir_last_total_amount_') + evaluate('total_amount_#action_id#')>
											</cfif>
										</cfif>
									</td>
								</cfif>
								<cfif attributes.report_type eq 2>
									<cfif listfind(attributes.list_type,6)><th></th></cfif>
									<cfif listfind(attributes.list_type,7)><th></th></cfif>
									<th></th>				
								</cfif>
								<cfif listfind(attributes.list_type,8)>
									<cfloop list="#tax_list#" index="tax_ii">
										<cfset tax_count=NumberFormat(tax_ii)>
										<td style="text-align:right" format="numeric">
											<cfif isdefined('kdv_toplam_#tax_count#_#action_id#_#type#') and len(evaluate('kdv_toplam_#tax_count#_#action_id#_#type#'))>
												#TLFormat(evaluate('kdv_toplam_#tax_count#_#action_id#_#type#'))#
												<cfset 'kdv_genel_toplam_#tax_count#' = evaluate('kdv_genel_toplam_#tax_count#') + (evaluate('kdv_toplam_#tax_count#_#action_id#_#type#'))>
											</cfif>
										</td>
									</cfloop>
									<cfif isdefined("attributes.is_tevkifat")>
										<cfloop list="#tax_list#" index="tax_ii">
											<cfset tax_count=NumberFormat(tax_ii)>
											<td style="text-align:right" format="numeric">
												<cfif type eq 0 and isdefined('tax_tevkifat_#action_id#_#tax_count#') and len(evaluate('tax_tevkifat_#action_id#_#tax_count#'))>
													#TLFormat(evaluate('tax_tevkifat_#action_id#_#tax_count#'))#
													<cfset 'tevkifat_genel_toplam_#tax_count#' = evaluate('tevkifat_genel_toplam_#tax_count#') + (evaluate('tax_tevkifat_#action_id#_#tax_count#'))>
												</cfif>
											</td>
										</cfloop>
										<cfloop list="#tax_list#" index="tax_ii">
											<cfset tax_count=NumberFormat(tax_ii)>
											<td style="text-align:right" format="numeric">
												<cfif type eq 0 and isdefined('tax_beyan_#action_id#_#tax_count#') and len(evaluate('tax_beyan_#action_id#_#tax_count#'))>
													<cfif evaluate('tax_beyan_#action_id#_#tax_count#') eq 0 >#TLFormat(evaluate('tax_beyan_#action_id#_#tax_count#'))#<cfelse>#TLFormat(evaluate('tax_beyan_#action_id#_#tax_count#')/100)#</cfif>
													<cfset 'beyan_genel_toplam_#tax_count#' = evaluate('beyan_genel_toplam_#tax_count#') + (evaluate('tax_beyan_#action_id#_#tax_count#'))>
												</cfif>
											</td>
										</cfloop>
									</cfif>
								</cfif>
								<cfif listfind(attributes.list_type,12)>
									<cfloop list="#otv_list#" index="otv_ii">
										<cfset otv_count=NumberFormat(otv_ii)>
											<td style="text-align:right;" format="numeric">
											<cfif len(get_invoice.OTV_TOTAL)>
												<cfif isdefined('otv_toplam_#otv_count#_#action_id#_#type#') and len(evaluate('otv_toplam_#otv_count#_#action_id#_#type#'))>
													<cfif isdefined('otv_genel_toplam_#otv_count#') and len(evaluate('otv_genel_toplam_#otv_count#'))>
														<cfset 'otv_genel_toplam_#otv_count#' = evaluate('otv_genel_toplam_#otv_count#') + evaluate('otv_toplam_#otv_count#_#action_id#_#type#')*oran_2>
														<cfset 'inv_otv_genel_toplam_#otv_count#' = evaluate('inv_otv_genel_toplam_#otv_count#') + evaluate('otv_toplam_#otv_count#_#action_id#_#type#')*oran_2>
													<cfelse>
														<cfset 'otv_genel_toplam_#otv_count#' = evaluate('otv_toplam_#otv_count#_#action_id#_#type#')*oran_2>
														<cfset 'inv_otv_genel_toplam_#otv_count#' = evaluate('otv_toplam_#otv_count#_#action_id#_#type#')*oran_2>
													</cfif>
													#TLFormat(evaluate('otv_toplam_#otv_count#_#action_id#_#type#')*oran_2)#
												</cfif>
											</cfif>
											</td>
									</cfloop>
								</cfif>										
								<cfif listfind(attributes.list_type,14)>
									<cfloop list="#bsmv_list#" index="bsmv_ii">
										<cfset bsmv_count=NumberFormat(bsmv_ii)>
										<cfif NumberFormat(get_invoice.bsmv_rate eq bsmv_count)>
											<td style="text-align:right;" format="numeric">
											<cfif len(get_invoice.ROW_BSMVTOTAL)>
												<cfif isdefined('bsmv_genel_toplam_#bsmv_count#') and len(evaluate('bsmv_genel_toplam_#bsmv_count#'))>
													<cfset 'bsmv_genel_toplam_#bsmv_count#' = evaluate('bsmv_genel_toplam_#bsmv_count#') + get_invoice.ROW_BSMVTOTAL>
													<cfset 'inv_bsmv_genel_toplam_#bsmv_count#' = evaluate('inv_bsmv_genel_toplam_#bsmv_count#') + get_invoice.ROW_BSMVTOTAL>
												<cfelse>
													<cfset 'bsmv_genel_toplam_#bsmv_count#' = get_invoice.ROW_BSMVTOTAL>
													<cfset 'inv_bsmv_genel_toplam_#bsmv_count#' = get_invoice.ROW_BSMVTOTAL>
												</cfif>
												#TLFormat(get_invoice.ROW_BSMVTOTAL)#
											</cfif></td>
										<cfelse>
											<td style="text-align:right;"></td>
										</cfif>
									</cfloop>
								</cfif>	
								<cfif listfind(attributes.list_type,15)>
									<cfloop list="#oiv_list#" index="oiv_ii">
										<cfset oiv_count=NumberFormat(oiv_ii)>
										<cfif NumberFormat(get_invoice.oiv_rate eq oiv_count)>
											<td style="text-align:right;" format="numeric">
											<cfif len(get_invoice.ROW_OIVTOTAL)>
												<cfif isdefined('oiv_genel_toplam_#oiv_count#') and len(evaluate('oiv_genel_toplam_#oiv_count#'))>
													<cfset 'oiv_genel_toplam_#oiv_count#' = evaluate('oiv_genel_toplam_#oiv_count#') + get_invoice.ROW_OIVTOTAL>
													<cfset 'inv_oiv_genel_toplam_#oiv_count#' = evaluate('inv_oiv_genel_toplam_#oiv_count#') + get_invoice.ROW_OIVTOTAL>
												<cfelse>
													<cfset 'oiv_genel_toplam_#oiv_count#' = get_invoice.ROW_OIVTOTAL>
													<cfset 'inv_oiv_genel_toplam_#oiv_count#' = get_invoice.ROW_OIVTOTAL>
												</cfif>
												#TLFormat(get_invoice.ROW_OIVTOTAL)#
											</cfif></td>
										<cfelse>
											<td style="text-align:right;"></td>
										</cfif>
									</cfloop>
								</cfif>
								<cfif attributes.report_type eq 1>
									<td style="text-align:right" format="numeric">#TlFormat(GROSSTOTAL)#</td>
									<td style="text-align:right" format="numeric">#TlFormat(SA_DISCOUNT)#</td>
									<td style="text-align:right" format="numeric"><cfif len(ROUND_MONEY)>#TLFormat(ROUND_MONEY)#</cfif></td>
								</cfif>
								<td style="text-align:right" format="numeric"><cfif len(paper_total_discount)>#TLFormat(paper_total_discount)#<cfset toplam_indirim=toplam_indirim+wrk_round(paper_total_discount)></cfif></td><!--- FATURA ALTI INDIRIM DAHIL --->
								<td style="text-align:right" format="numeric">#TlFormat(NETTOTAL-TAXTOTAL-OTV_TOTAL-BSMV_TOTAL)#</td>
								<cfset indli_kdvsiz_toplam = indli_kdvsiz_toplam + NETTOTAL-TAXTOTAL-OTV_TOTAL<!---ind_sonrası_kdvsiz_toplam---->> <!--- Total İnd.Sonrası KDV siz Toplam 0 geliyordu --->
								<td style="text-align:right" format="numeric"><cfif isdefined('otv_toplam') and len(otv_toplam)><cfset general_otv_total_ = general_otv_total_+wrk_round(otv_toplam)>#TLFormat(otv_toplam)#</cfif></td>
								<td style="text-align:right" format="numeric"><cfif isdefined('bsmv_toplam') and len(bsmv_toplam)><cfset general_bsmv_total_ = general_bsmv_total_+wrk_round(bsmv_toplam)>#TLFormat(bsmv_toplam)#</cfif></td>								
								<td style="text-align:right" format="numeric"><cfif isdefined('oiv_toplam') and len(oiv_toplam)><cfset general_oiv_total_ = general_oiv_total_+wrk_round(oiv_toplam)>#TLFormat(oiv_toplam)#</cfif></td>																
								<td style="text-align:right" format="numeric"><cfif isdefined('kdv_of_otv_total') and len(kdv_of_otv_total)>#TLFormat(kdv_of_otv_total)#</cfif></td>
								<td style="text-align:right" format="numeric">#TLFormat(TAXTOTAL)#<cfset kdv_toplam = kdv_toplam + TAXTOTAL></td>
								<td style="text-align:right" format="numeric">#TLFormat(NETTOTAL)#<cfset kdvli_toplam = kdvli_toplam + NETTOTAL></td>
							</tr>
						</tbody>
					<cfelse>
						<cfset temp_row_tax_total_=0>
						<cfset row_grosstotal_=0>
						<cfif (get_invoice.currentrow eq 1 or get_invoice.ACTION_ID[currentrow] neq get_invoice.ACTION_ID[currentrow-1] or not isdefined('temp_disc_total')) and get_invoice.SA_DISCOUNT neq 0>
							<cfquery name="GET_INV_ROWS" dbtype="query">
								SELECT 
									ACTION_ID,SUM(DISCOUNTTOTAL) AS INV_DISCOUNTTOTAL,
									SUM(ROW_TAXTOTAL) AS TOTAL_AMOUNT_KDV
								FROM 
									get_invoice_detail 
								WHERE 
									ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice.ACTION_ID#">
									AND TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice.TYPE#">
								GROUP BY
									ACTION_ID
							</cfquery>
							<cfset temp_disc_total =GET_INV_ROWS.INV_DISCOUNTTOTAL>
						 <cfelse>
						 <cfquery name="GET_INV_ROWS" dbtype="query">
								SELECT 
									ACTION_ID,SUM(DISCOUNTTOTAL) AS INV_DISCOUNTTOTAL,
									SUM(ROW_TAXTOTAL) AS TOTAL_AMOUNT_KDV
								FROM 
									get_invoice_detail 
								WHERE 
									ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice.ACTION_ID#">
									AND TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice.TYPE#">
								GROUP BY
									ACTION_ID
							</cfquery>
						</cfif>
						
						<cfif get_invoice.SA_DISCOUNT neq 0 and len(temp_disc_total) and (GROSSTOTAL - temp_disc_total) neq 0>
							<cfset oran_2 = ((GROSSTOTAL - temp_disc_total) - SA_DISCOUNT) / (GROSSTOTAL - temp_disc_total)>
						<cfelse>
							<cfset oran_2 =1>
						</cfif>
						<tbody>
						<tr>
							<td>#SERIAL_NO#</td>
							<td>
								<cfif isdefined('attributes.is_excel') and listfind('1,2',attributes.is_excel)>
									#get_invoice.BELGE_NO#
								<cfelse>
									<cfif get_invoice.invoice_cat eq 65>
										<cfif attributes.is_excel eq 0>
											<a href="#request.self#?fuseaction=invent.upd_purchase_invent&invoice_id=#get_invoice.ACTION_ID#" class="tableyazi">#get_invoice.BELGE_NO#</a>
										<cfelse>
										#get_invoice.BELGE_NO#
										</cfif>
									<cfelseif get_invoice.invoice_cat eq 66>
										<cfif attributes.is_excel eq 0>
											<a href="#request.self#?fuseaction=invent.upd_invent_sale&invoice_id=#get_invoice.ACTION_ID#" class="tableyazi">#get_invoice.BELGE_NO#</a>
										<cfelse>
										#get_invoice.BELGE_NO#
										</cfif>
									<cfelseif get_invoice.invoice_cat eq 52>
										<cfif attributes.is_excel eq 0>
											<a href="#request.self#?fuseaction=invoice.add_bill_retail&event=upd&iid=#get_invoice.ACTION_ID#" class="tableyazi">#get_invoice.BELGE_NO#</a>
										<cfelse>
										#get_invoice.BELGE_NO#
										</cfif>
									<cfelseif get_invoice.invoice_cat eq 121>
										<cfif attributes.is_excel eq 0>
											<a href="#request.self#?fuseaction=cost.add_income_cost&event=upd&expense_id=#get_invoice.ACTION_ID#" class="tableyazi">#get_invoice.BELGE_NO#</a>
										<cfelse>
										#get_invoice.BELGE_NO#
										</cfif>
									<cfelse>
										<cfif attributes.is_excel eq 0>
											<a href="#request.self#?fuseaction=invoice.form_add_bill&event=upd&iid=#get_invoice.ACTION_ID#" class="tableyazi">#get_invoice.BELGE_NO#</a>
										<cfelse>
										#get_invoice.BELGE_NO#
										</cfif>
									</cfif>
								</cfif>
							</td>
							<td width="100"><cfif len(process_cat)>#get_process_cat.process_cat[listfind(process_cat_id_list,process_cat,',')]#</cfif></td>
							<td format="dateformat">#dateformat(get_invoice.ACTION_DATE,dateformat_style)#</td>
							<cfif listfind(attributes.list_type,10)>
								<td format="dateformat">#dateformat(get_invoice.DUE_DATE,dateformat_style)#</td>
							</cfif>
							<cfif listfind(attributes.list_type,11)>
								<cfloop query="get_add_info_name">
									<td>
										<cfset my_kolon = replace(PROPERTY,'_NAME','')>
										<cfset my_kolon1 = replace(PROPERTY,'_NAME','')>
										<cfset my_kolon1 = replace(my_kolon1,'PROPERTY','')>
										<cfset my_kolon2 = replace(PROPERTY,'_NAME','')>
										<cfset my_kolon2 = my_kolon2&'_TYPE'>
										<cfquery name="get_type" datasource="#dsn3#">
											SELECT  #my_kolon2# FROM SETUP_PRO_INFO_PLUS_NAMES where #my_kolon2# = 'select' and OWNER_TYPE_ID =-8
										</cfquery>
										<cfif isnumeric(evaluate('get_invoice.#my_kolon#')) and get_type.recordcount >
											<cfquery name="get_value" datasource="#dsn3#">
													SELECT SELECT_VALUE,PROPERTY_NO FROM SETUP_PRO_INFO_PLUS_VALUES WHERE PROPERTY_NO = #my_kolon1# AND INFO_ROW_ID=#evaluate('get_invoice.#my_kolon#')#
											</cfquery>
										<cfelse>
											<cfset get_value.recordcount = 0 >
										</cfif>
										<cfif get_value.recordcount and get_type.recordcount>
											#get_value.SELECT_VALUE# 
										<cfelse>
											#evaluate('get_invoice.#my_kolon#')#
										</cfif>
										<cfset get_value.recordcount = 0>
									</td>
								</cfloop>
							</cfif>
							<cfif listfind(attributes.list_type,1)>
								<td><cfif isdefined(row_dept)>#get_department_info_row.department_head[listfind(row_department_id_list,row_dept)]#</cfif></td>
								<td>#get_location.comment[ListFind(row_location_id_list,"#row_dept#-#row_loc#",',')]#</td>
							</cfif>
							<cfif listfind(attributes.list_type,2)>
								<td>#ozel_kod#</td>
							</cfif>
							<td>#get_invoice.member_code#</td>
							<td style='mso-number-format:"\@"'>#get_invoice.FULLNAME#</td>
							<cfif listfind(attributes.list_type,13)><td>#get_invoice.subs_name#</td></cfif>
							<cfif listfind(attributes.list_type,17)><td>#get_invoice.subscription_no#</td></cfif>
							<cfif listfind(attributes.list_type,18)><td>#get_invoice.ship_address#</td></cfif>
							<td>#get_invoice.TAXOFFICE#</td>
							<td>#get_invoice.TAXNO#</td>
							<cfif listfind(attributes.list_type,3)>
								<td>#TC_IDENTY_NO#</td>
							</cfif>
							<cfif listfind(attributes.list_type,4)>
								<td>#get_invoice.PRODUCT_CAT#</td>
							</cfif>
							<cfif listfind(attributes.list_type,5)>
								<td>
									 <cfif len(acc_department_id)>#get_department_info.BRANCH_NAME[listfind(department_id_list,acc_department_id,',')]#  - #get_department_info.department_head[listfind(department_id_list,acc_department_id,',')]#</cfif>
								</td>
							</cfif>
							<cfif listfind(attributes.list_type,9)>
								<td>
									<cfif len(row_project_id)>#get_project.PROJECT_HEAD[listfind(project_id_list,row_project_id,',')]#</cfif>
								</td>
							</cfif>
							<td>#get_invoice.product_name#</td>
							<cfif listfind(attributes.list_type,6)>
								<td style='mso-number-format:"\@"'>
									<cfif type eq 1>
										#note#
									<cfelse>
										<cfif type eq 0>
											#get_invoice.product_name#
										<cfelseif type eq 1 and len(product_list)>
											#get_account_expense.expense_item_name[listfind(expense_list,product_id,',')]#
										</cfif>
									</cfif>
								</td>
							</cfif> 							
							<cfif listfind(attributes.list_type,7)>
								<td style="text-align:right" nowrap>
									<cfset inv_toplam_miktar = inv_toplam_miktar+ROW_QUANTITY>
									<cfset toplam_miktar = toplam_miktar+ROW_QUANTITY>
									#TLFormat(ROW_QUANTITY,4)# #unit#
									<cfset unit__=filterSpecialChars(unit)>
									<cfset 'row_quantity_#unit__#' = ROW_QUANTITY>
									<cfset 'total_row_quantity_#unit__#' = evaluate('total_row_quantity_#unit__#') + evaluate('row_quantity_#unit__#')>
									<cfset 'devir_total_row_quantity_#unit__#' = evaluate('devir_total_row_quantity_#unit__#') + evaluate('row_quantity_#unit__#')>
								</td>
							</cfif>
							<td format="numeric">
								<cfif type eq 0>
									<cfif invoice_cat eq 58 and len(product_list)><!--- Verilen fiyat farki --->
										#get_account_product.account_price[listfind(product_list,product_id,',')]#
									<cfelseif invoice_cat eq 62 and len(product_list)><!--- Alim iade --->
										#get_account_product.account_pur_iade[listfind(product_list,product_id,',')]#
									<cfelseif invoice_cat eq 531 and len(product_list)><!--- Ihracat --->
										#get_account_product.account_yurtdisi[listfind(product_list,product_id,',')]#
									<cfelseif invoice_cat eq 533 and len(product_list)><!--- KDV den muaf --->
										#get_account_product.EXE_VAT_SALE_INVOICE[listfind(product_list,product_id,',')]#
									<cfelseif invoice_cat eq 66><!--- Sabit Kiymet Satis --->
										#account_id#
									<cfelse><!--- Digerleri (satis oluyor) --->
										<cfif len(product_list)>#get_account_product.account_code[listfind(product_list,product_id,',')]#</cfif>
									</cfif>
								<cfelseif type eq 1 and len(expense_list)><!--- gelir ve masraf iade fisi --->
									#get_account_expense.account_code[listfind(expense_list,product_id,',')]#
								</cfif>
							</td>
							<cfif listfind(attributes.list_type,16)>
								<td style='mso-number-format:"\@"'>
									#PRODUCT_CODE_2#
								</td>
							</cfif>
							<cfloop list="#tax_list#" index="tax_ii">
								<cfset tax_count=NumberFormat(tax_ii)>
								<cfif NumberFormat(get_invoice.TAX eq tax_count)>
									<cfif len(get_invoice.ROW_TAXTOTAL)>
										<cfset temp_row_tax_total_ = wrk_round(get_invoice.ROW_TAXTOTAL)>
										<cfif isdefined('kdv_genel_toplam_#tax_count#') and len(evaluate('kdv_genel_toplam_#tax_count#'))>
											<cfset 'kdv_genel_toplam_#tax_count#' = evaluate('kdv_genel_toplam_#tax_count#') + (get_invoice.ROW_TAXTOTAL*oran_2)>
											<cfset 'inv_kdv_genel_toplam_#tax_count#' = evaluate('inv_kdv_genel_toplam_#tax_count#') + (get_invoice.ROW_TAXTOTAL*oran_2)>
										<cfelse>
											<cfset 'kdv_genel_toplam_#tax_count#' = (get_invoice.ROW_TAXTOTAL*oran_2)>
											<cfset 'inv_kdv_genel_toplam_#tax_count#' = (get_invoice.ROW_TAXTOTAL*oran_2)>
										</cfif>
									</cfif>
								</cfif>
							</cfloop>
							<cfif listfind(attributes.list_type,8)>
								<cfloop list="#tax_list#" index="tax_ii">
									<cfset tax_count=NumberFormat(tax_ii)>
									<cfif NumberFormat(get_invoice.TAX eq tax_count)>
										<td style="text-align:right" format="numeric">
											<cfif len(get_invoice.ROW_TAXTOTAL)>
												#TLFormat(get_invoice.ROW_TAXTOTAL)#
											</cfif>
										</td>
									<cfelse>
										<td style="text-align:right"></td>
									</cfif>
								</cfloop>
								<cfif isdefined("attributes.is_tevkifat") and attributes.report_type eq 2>
									<cfloop list="#tax_list#" index="tax_ii">
										<cfset tax_count=NumberFormat(tax_ii)>
										<td style="text-align:right" format="numeric">
											<cfif type eq 0 and get_inv_rows.total_amount_kdv gt 0 and isdefined('tax_tevkifat_#action_id#_#tax_count#') and len(evaluate('tax_tevkifat_#action_id#_#tax_count#'))>
												#TLFormat((ROW_TAXTOTAL/get_inv_rows.total_amount_kdv)*evaluate('tax_tevkifat_#action_id#_#tax_count#'))#
												<cfset 'tevkifat_genel_toplam_#tax_count#' = evaluate('tevkifat_genel_toplam_#tax_count#') + (evaluate('tax_tevkifat_#action_id#_#tax_count#'))>
											</cfif>
										</td>
									</cfloop>
									<cfloop list="#tax_list#" index="tax_ii">
										<cfset tax_count=NumberFormat(tax_ii)>
										<td style="text-align:right" format="numeric">
											<cfif type eq 0 and get_inv_rows.total_amount_kdv gt 0 and isdefined('tax_beyan_#action_id#_#tax_count#') and len(evaluate('tax_beyan_#action_id#_#tax_count#'))>
												<cfif evaluate('tax_beyan_#action_id#_#tax_count#') eq 0>#TLFormat((ROW_TAXTOTAL/get_inv_rows.total_amount_kdv)*evaluate('tax_beyan_#action_id#_#tax_count#'))#<cfelse>#TLFormat((ROW_TAXTOTAL/get_inv_rows.total_amount_kdv)*evaluate('tax_beyan_#action_id#_#tax_count#')/100)#</cfif>
												<cfset 'beyan_genel_toplam_#tax_count#' = evaluate('beyan_genel_toplam_#tax_count#') + (evaluate('tax_beyan_#action_id#_#tax_count#'))>
											</cfif>
										</td>
									</cfloop>
								</cfif>
							</cfif>
							<cfif listfind(attributes.list_type,12)>
								<cfloop list="#otv_list#" index="otv_ii">
									<cfset otv_count=NumberFormat(otv_ii)>
									<cfif get_invoice.otv_oran eq otv_count>
										<td style="text-align:right;" format="numeric">
										<cfif len(get_invoice.ROW_OTVTOTAL)>
											<cfif isdefined('otv_genel_toplam_#otv_count#') and len(evaluate('otv_genel_toplam_#otv_count#'))>
												<cfset 'otv_genel_toplam_#otv_count#' = evaluate('otv_genel_toplam_#otv_count#') + get_invoice.ROW_OTVTOTAL>
												<cfset 'inv_otv_genel_toplam_#otv_count#' = evaluate('inv_otv_genel_toplam_#otv_count#') + get_invoice.ROW_OTVTOTAL>
											<cfelse>
												<cfset 'otv_genel_toplam_#otv_count#' = get_invoice.ROW_OTVTOTAL>
												<cfset 'inv_otv_genel_toplam_#otv_count#' = get_invoice.ROW_OTVTOTAL>
											</cfif>
											#TLFormat(get_invoice.ROW_OTVTOTAL)#
										</cfif></td>
									<cfelse>
										<td style="text-align:right;"></td>
									</cfif>
								</cfloop>
							</cfif>	
							<cfif listfind(attributes.list_type,14)>
								<cfloop list="#bsmv_list#" index="bsmv_ii">
									<cfset bsmv_count=NumberFormat(bsmv_ii)>
									<cfif NumberFormat(get_invoice.bsmv_rate eq bsmv_count)>
										<td style="text-align:right;" format="numeric">
										<cfif len(get_invoice.ROW_BSMVTOTAL)>
											<cfif isdefined('bsmv_genel_toplam_#bsmv_count#') and len(evaluate('bsmv_genel_toplam_#bsmv_count#'))>
												<cfset 'bsmv_genel_toplam_#bsmv_count#' = evaluate('bsmv_genel_toplam_#bsmv_count#') + get_invoice.ROW_BSMVTOTAL>
												<cfset 'inv_bsmv_genel_toplam_#bsmv_count#' = evaluate('inv_bsmv_genel_toplam_#bsmv_count#') + get_invoice.ROW_BSMVTOTAL>
											<cfelse>
												<cfset 'bsmv_genel_toplam_#bsmv_count#' = get_invoice.ROW_BSMVTOTAL>
												<cfset 'inv_bsmv_genel_toplam_#bsmv_count#' = get_invoice.ROW_BSMVTOTAL>
											</cfif>
											#TLFormat(get_invoice.ROW_BSMVTOTAL)#
										</cfif></td>
									<cfelse>
										<td style="text-align:right;"></td>
									</cfif>
								</cfloop>
							</cfif>	
							<cfif listfind(attributes.list_type,15)>
								<cfloop list="#oiv_list#" index="oiv_ii">
									<cfset oiv_count=NumberFormat(oiv_ii)>
									<cfif NumberFormat(get_invoice.oiv_rate eq oiv_count)>
										<td style="text-align:right;" format="numeric">
										<cfif len(get_invoice.ROW_OIVTOTAL)>
											<cfif isdefined('oiv_genel_toplam_#oiv_count#') and len(evaluate('oiv_genel_toplam_#oiv_count#'))>
												<cfset 'oiv_genel_toplam_#oiv_count#' = evaluate('oiv_genel_toplam_#oiv_count#') + get_invoice.ROW_OIVTOTAL>
												<cfset 'inv_oiv_genel_toplam_#oiv_count#' = evaluate('inv_oiv_genel_toplam_#oiv_count#') + get_invoice.ROW_OIVTOTAL>
											<cfelse>
												<cfset 'oiv_genel_toplam_#oiv_count#' = get_invoice.ROW_OIVTOTAL>
												<cfset 'inv_oiv_genel_toplam_#oiv_count#' = get_invoice.ROW_OIVTOTAL>
											</cfif>
											#TLFormat(get_invoice.ROW_OIVTOTAL)#
										</cfif></td>
									<cfelse>
										<td style="text-align:right;"></td>
									</cfif>
								</cfloop>
							</cfif>	
							<td style="text-align:right" format="numeric">
								<cfif isdefined("GET_INV_ROWS.NETTOTAL") and len(GET_INV_ROWS.NETTOTAL)>
									<cfset kdvsiz_toplam = kdvsiz_toplam + wrk_round(GET_INV_ROWS.NETTOTAL-TAXTOTAL-OTV_TOTAL-BSMVTOTAL-OIVTOTAL)>
								</cfif>
								<cfif len(get_invoice.DISCOUNTTOTAL)>#TLFormat(get_invoice.DISCOUNTTOTAL+(get_invoice.DISCOUNTTOTAL*(1-oran_2)))#
									<cfset toplam_indirim=toplam_indirim+(get_invoice.DISCOUNTTOTAL+(get_invoice.DISCOUNTTOTAL*(1-oran_2)))>
									<cfset inv_toplam_indirim=inv_toplam_indirim+(get_invoice.DISCOUNTTOTAL+(get_invoice.DISCOUNTTOTAL*(1-oran_2)))>
								</cfif>
							</td> <!--- fatura altı indirimin satır indirimlerine yansıtılmıs hali --->
							<td style="text-align:right" format="numeric">
								<cfif len(get_invoice.KDVSIZ_TOPLAM)>
									#TLFormat(get_invoice.KDVSIZ_TOPLAM*oran_2)#
									<cfset indli_kdvsiz_toplam = indli_kdvsiz_toplam + (get_invoice.KDVSIZ_TOPLAM*oran_2)>
									<cfset inv_indli_kdvsiz_toplam = inv_indli_kdvsiz_toplam + (get_invoice.KDVSIZ_TOPLAM*oran_2)>
									<cfset row_grosstotal_=temp_row_tax_total_+(get_invoice.KDVSIZ_TOPLAM)>
								</cfif>
							</td>
							<td style="text-align:right" format="numeric">
							<cfif len(get_invoice.OTVTOTAL)>					
								<cfset row_grosstotal_=row_grosstotal_+ (get_invoice.OTVTOTAL*oran_2)>
								<cfset general_otv_total_ = general_otv_total_+ (get_invoice.OTVTOTAL*oran_2)>
								#TLFormat(get_invoice.OTVTOTAL*oran_2)#
							</cfif></td>
							<td style="text-align:right" format="numeric">
								<cfif len(get_invoice.BSMVTOTAL)>					
									<cfset row_grosstotal_=row_grosstotal_+ (get_invoice.BSMVTOTAL*oran_2)>
									<cfset general_bsmv_total_ = general_bsmv_total_+ (get_invoice.BSMVTOTAL*oran_2)>
									#TLFormat(get_invoice.BSMVTOTAL*oran_2)#
								</cfif>
							</td>
							<td style="text-align:right" format="numeric">
								<cfif len(get_invoice.OIVTOTAL)>					
									<cfset row_grosstotal_=row_grosstotal_+ (get_invoice.OIVTOTAL*oran_2)>
									<cfset general_oiv_total_ = general_oiv_total_+ (get_invoice.OIVTOTAL*oran_2)>
									#TLFormat(get_invoice.OIVTOTAL*oran_2)#
								</cfif>
							</td>
							<td style="text-align:right" format="numeric"><cfif len(get_invoice.IS_TAX_OF_OTV) and get_invoice.IS_TAX_OF_OTV eq 1 and len(get_invoice.TAX) and len(get_invoice.OTVTOTAL) and get_invoice.TAX neq 0>#TLFormat((get_invoice.OTVTOTAL*get_invoice.TAX)/100)#<cfelse>#TLFormat(0)#</cfif></td>
							<td style="text-align:right" format="numeric">#TLFormat(temp_row_tax_total_)#<cfset kdv_toplam = kdv_toplam + temp_row_tax_total_><cfset inv_kdv_toplam = inv_kdv_toplam + temp_row_tax_total_></td>
							<td style="text-align:right" format="numeric">#TLFormat(row_grosstotal_)#<cfset kdvli_toplam = kdvli_toplam + row_grosstotal_><cfset inv_kdvli_toplam = inv_kdvli_toplam+ row_grosstotal_></td>
						</tr>	
						</tbody>
						<cfif isdefined("attributes.is_inv_total") and (get_invoice.action_id[currentrow] neq get_invoice.action_id[currentrow+1] or get_invoice.process_cat[currentrow] neq get_invoice.process_cat[currentrow+1] or currentrow eq attributes.maxrows)>
							<tfoot>
							<tr>
								<cfset colspan_ = 8>
								<cfif type_ eq 0>
									<cfset colspan_ = 8>
								<cfelseif type_ eq 1>
									<cfloop index="aa" from="1" to="#colspan_-1#">
										<td></td>								
									</cfloop>
									<cfset colspan_ = 1>
								</cfif>
								<cfif listfind(attributes.list_type,10)>
									<cfset colspan_ = colspan_ + 1>
									<cfif type_ eq 1>
										<cfloop index="aa" from="1" to="#colspan_-1#">
											<td></td>
										</cfloop>
										<cfset colspan_ = 1>
									</cfif>	
								</cfif>
								<cfif listfind(attributes.list_type,11)>
									<cfloop query="get_add_info_name">
									<cfif type_ eq 1>
										<cfloop index="aa" from="1" to="#colspan_-1#">
											<td></td>
										</cfloop>
										<cfset colspan_ = 1>
									</cfif>
									</cfloop>	
								</cfif>
								
								<cfif listfind(attributes.list_type,1)>
									<cfset colspan_ = colspan_ + 2>
									<cfif type_ eq 1>
										<cfloop index="aa" from="1" to="#colspan_-2#">
											<td></td>
										</cfloop>
										<cfset colspan_ = 2>
									</cfif>	
								</cfif>
								<cfif listfind(attributes.list_type,2)>
									<cfset colspan_ = colspan_ + 1>
									<cfif type_ eq 1>
										<cfloop index="aa" from="1" to="#colspan_-1#">
											<td></td>
										</cfloop>
										<cfset colspan_ = 1>
									</cfif>	
								</cfif>
								<cfif listfind(attributes.list_type,3)>
									<cfset colspan_ = colspan_ + 1>
									<cfif type_ eq 1>
										<cfloop index="aa" from="1" to="#colspan_-1#">
											<td></td>
										</cfloop>
										<cfset colspan_ = 1>
									</cfif>	
								</cfif>
								<cfif listfind(attributes.list_type,4)>
									<cfset colspan_ = colspan_ + 1>
									<cfif type_ eq 1>
										<cfloop index="aa" from="1" to="#colspan_-1#">
											<td></td>
										</cfloop>
										<cfset colspan_ = 1>
									</cfif>	
								</cfif>
								<cfif listfind(attributes.list_type,5)>
									<cfset colspan_ = colspan_ + 1>
									<cfif type_ eq 1>
										<cfloop index="aa" from="1" to="#colspan_-1#">
											<td></td>
										</cfloop>
										<cfset colspan_ = 1>
									</cfif>
								</cfif>
								<cfif listfind(attributes.list_type,9)>
									<cfset colspan_ = colspan_ + 1>
									<cfif type_ eq 1>
										<cfloop index="aa" from="1" to="#colspan_-1#">
											<td></td>
										</cfloop>
										<cfset colspan_ = 1>
									</cfif>
								</cfif>
								<cfif listfind(attributes.list_type,16)>
									<cfset colspan_ = colspan_ + 1>
									<cfif type_ eq 1>
										<cfloop index="aa" from="1" to="#colspan_-1#">
											<td></td>
										</cfloop>
										<cfset colspan_ = 1>
									</cfif>
								</cfif>
								<cfif listfind(attributes.list_type,6)>
									<cfset colspan_ = colspan_ + 1>
									<cfif type_ eq 1>
										<cfloop index="aa" from="1" to="#colspan_-1#">
											<td></td>
										</cfloop>
										<cfset colspan_ = 1>
									</cfif>	
								</cfif>
								<td height="20" class="txtbold" colspan="#colspan_#" style="text-align:right"><cf_get_lang dictionary_id='57441.Fatura'><cf_get_lang dictionary_id='57492.Toplam'></td>
								<cfif listfind(attributes.list_type,7)><td height="20" class="txtbold" style="text-align:right" format="numeric">#TLFormat(inv_toplam_miktar)# #unit#</td></cfif>
								<td format="numeric"></td>
								<cfif listfind(attributes.list_type,8)>
									<cfloop list="#tax_list#" index="tax_ii">
										<td style="text-align:right" class="txtbold" format="numeric"></td>
									</cfloop>
									<cfloop list="#tax_list#" index="tax_ii">
										<td style="text-align:right" class="txtbold" format="numeric"><cfif isdefined('inv_kdv_genel_toplam_#NumberFormat(tax_ii)#') and len(evaluate('inv_kdv_genel_toplam_#NumberFormat(tax_ii)#'))>#TLFormat(evaluate('inv_kdv_genel_toplam_#NumberFormat(tax_ii)#'))#</cfif></td>
									</cfloop>
								</cfif>
								<cfif listfind(attributes.list_type,12)>
									<cfloop list="#otv_list#" index="otv_ii">
										<td class="txtbold" style="text-align:right;" format="numeric">
											<cfif isdefined('inv_otv_genel_toplam_#NumberFormat(otv_ii)#') and len(evaluate('inv_otv_genel_toplam_#NumberFormat(otv_ii)#'))>
												#TLFormat(evaluate('inv_otv_genel_toplam_#NumberFormat(otv_ii)#'))#
											</cfif>
										</td>
									</cfloop>
								</cfif>
								<cfif listfind(attributes.list_type,14)>
									<cfloop list="#bsmv_list#" index="bsmv_ii">
										<td class="txtbold" style="text-align:right;" format="numeric">
											<cfif isdefined('inv_bsmv_genel_toplam_#NumberFormat(bsmv_ii)#') and len(evaluate('inv_bsmv_genel_toplam_#NumberFormat(bsmv_ii)#'))>
												#TLFormat(evaluate('inv_bsmv_genel_toplam_#NumberFormat(bsmv_ii)#'))#
											</cfif>
										</td>
									</cfloop>
								</cfif>
								<cfif listfind(attributes.list_type,15)>
									<cfloop list="#oiv_list#" index="oiv_ii">
										<td class="txtbold" style="text-align:right;" format="numeric">
											<cfif isdefined('inv_oiv_genel_toplam_#NumberFormat(oiv_ii)#') and len(evaluate('inv_oiv_genel_toplam_#NumberFormat(oiv_ii)#'))>
												#TLFormat(evaluate('inv_oiv_genel_toplam_#NumberFormat(oiv_ii)#'))#
											</cfif>
										</td>
									</cfloop>
								</cfif>
								<td style="text-align:right" class="txtbold" format="numeric"><cfif len(inv_toplam_indirim)>#TLFormat(inv_toplam_indirim)#</cfif></td>
								<td style="text-align:right" class="txtbold" format="numeric">#TLFormat(inv_indli_kdvsiz_toplam)#</td>
								<td style="text-align:right" class="txtbold" format="numeric"></td>
								<td style="text-align:right" class="txtbold" format="numeric"></td>
								<td style="text-align:right" class="txtbold" format="numeric"></td>
								<td style="text-align:right" class="txtbold" format="numeric"></td>
								<td style="text-align:right" class="txtbold" format="numeric">#TLFormat(inv_kdv_toplam)#</td>
								<td style="text-align:right" class="txtbold" format="numeric">#TLFormat(inv_kdvli_toplam)#</td>
							</tr>
							</tfoot>
							<cfscript>
								inv_toplam_miktar = 0;
								inv_toplam_indirim = 0;
								inv_indli_kdvsiz_toplam = 0;
								inv_kdv_toplam = 0;
								inv_kdvli_toplam = 0;
								for(xx=1; xx lte listlen(tax_list); xx=xx+1)
								{
									'inv_kdv_genel_toplam_#NumberFormat(listgetat(tax_list,xx))#'=0;
								}
							</cfscript>
						</cfif>			
					</cfif>
				</cfoutput>
				<cfoutput>
					<tfoot>
					<tr>						
						<cfif attributes.report_type eq 2>
							<cfset colspan_rept_ = 9>
						<cfelse>
							<cfset colspan_rept_ = 8>
						</cfif>
						<cfif type_ eq 1>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</cfif>
						<cfif attributes.report_type eq 2>
							<cfif type_ eq 1>
								<cfset colspan_rept_ = 1>
							</cfif>
							<cfif listfind(attributes.list_type,10)>
								<cfset colspan_rept_ = colspan_rept_ + 1>
								<cfif type_ eq 1>
									<td></td>
									<cfset colspan_rept_ = 1>
								</cfif>		
							</cfif>                    
							<cfif listfind(attributes.list_type,11)>
								<cfloop query="get_add_info_name">
									<cfset colspan_rept_ = colspan_rept_ + 1>
									<cfif type_ eq 1>
										<td></td>
										<cfset colspan_rept_ = 1>
									</cfif>
								</cfloop>
							</cfif>
							<cfif listfind(attributes.list_type,1)>
								<cfset colspan_rept_ = colspan_rept_ + 2>
								<cfif type_ eq 1>
									<td></td>
									<td></td>
								</cfif>
							</cfif>
							<cfif listfind(attributes.list_type,2)>
								<cfset colspan_rept_ = colspan_rept_ + 1>
								<cfif type_ eq 1>
									<td></td>
									<cfset colspan_rept_ = 1>
								</cfif>		
							</cfif>
							<cfif listfind(attributes.list_type,3)>
								<cfset colspan_rept_ = colspan_rept_ + 1>
								<cfif type_ eq 1>
									<td></td>
									<cfset colspan_rept_ = 1>
								</cfif>		
							</cfif>
							<cfif listfind(attributes.list_type,4)>
								<cfset colspan_rept_ = colspan_rept_ + 1>
								<cfif type_ eq 1>
									<td></td>
									<cfset colspan_rept_ = 1>
								</cfif>	
							</cfif>
							<cfif listfind(attributes.list_type,5)>
								<cfset colspan_rept_ = colspan_rept_ + 1>
								<cfif type_ eq 1>
									<td></td>
									<cfset colspan_rept_ = 1>
								</cfif>	
							</cfif>
							<cfif listfind(attributes.list_type,9)>
								<cfset colspan_rept_ = colspan_rept_ + 1>
								<cfif type_ eq 1>
									<td></td>
									<cfset colspan_rept_ = 1>
								</cfif>	
							</cfif>
							<cfif listfind(attributes.list_type,6)>
								<cfset colspan_rept_ = colspan_rept_ + 1>
								<cfif type_ eq 1>
									<td></td>
									<cfset colspan_rept_ = 1>
								</cfif>	
							</cfif>
							<cfif listfind(attributes.list_type,16)>
								<cfset colspan_rept_ = colspan_rept_ + 1>
								<cfif type_ eq 1>
									<td></td>
									<cfset colspan_rept_ = 1>
								</cfif>	
							</cfif>
							<td height="20" class="txtbold" colspan="#colspan_rept_#" style="text-align:right"><cf_get_lang dictionary_id='57492.Toplam'></td>
							<cfif listfind(attributes.list_type,7)>
								<td height="20" class="txtbold" style="text-align:right" format="numeric">
									<cfloop list="#unit_list#" index="tt">
										<cfif evaluate('total_row_quantity_#tt#') gt 0>
											#Tlformat(evaluate('total_row_quantity_#tt#'))# #tt#<cfif type_ neq 2><br/></cfif>
										</cfif>
									</cfloop>
								</td>
							</cfif>
							<!---<cfif listfind(attributes.list_type,8)>
								<cfloop list="#tax_list#" index="tax_ii">
									<cf_wrk_html_td class="txtbold" style="text-align:right" format="numeric"><cfif isdefined('kdv_genel_toplam_#NumberFormat(tax_ii)#') and len(evaluate('kdv_genel_toplam_#NumberFormat(tax_ii)#'))>#TLFormat(evaluate('kdv_genel_toplam_#NumberFormat(tax_ii)#'))#</cfif></cf_wrk_html_td>
								</cfloop>
								<cfif isdefined("attributes.is_tevkifat")>
									<cfloop list="#tax_list#" index="tax_ii">
										<cfset tax_count=NumberFormat(tax_ii)>
										<cf_wrk_html_td class="txtbold" style="text-align:right" format="numeric"><cfif isdefined('tevkifat_genel_toplam_#NumberFormat(tax_ii)#') and len(evaluate('tevkifat_genel_toplam_#NumberFormat(tax_ii)#'))>#TLFormat(evaluate('tevkifat_genel_toplam_#NumberFormat(tax_ii)#'))#</cfif></cf_wrk_html_td>
									</cfloop>
									<cfloop list="#tax_list#" index="tax_ii">
										<cfset tax_count=NumberFormat(tax_ii)>
										<cf_wrk_html_td class="txtbold" style="text-align:right" format="numeric"><cfif isdefined('beyan_genel_toplam_#NumberFormat(tax_ii)#') and len(evaluate('beyan_genel_toplam_#NumberFormat(tax_ii)#'))>#TLFormat(evaluate('beyan_genel_toplam_#NumberFormat(tax_ii)#')/100)#</cfif></cf_wrk_html_td>
									</cfloop>
								</cfif>
							</cfif>--->
							<td></td>
						<cfelse>
							<cfif type_ eq 1>
								<cfset colspan_rept_ = 1>
							</cfif>
							<cfif listfind(attributes.list_type,10)>
								<cfset colspan_rept_ = colspan_rept_ + 1>
								<cfif type_ eq 1>
									<td></td>
									<cfset colspan_rept_ = 1>
								</cfif>		
							</cfif>
							<cfif listfind(attributes.list_type,11)>
								   <cfloop query="get_add_info_name">
									<cfset colspan_rept_ = colspan_rept_ + 1>
									<cfif type_ eq 1>
										<td></td>
										<cfset colspan_rept_ = 1>
									</cfif>
								</cfloop>
							</cfif>
							<cfif listfind(attributes.list_type,1)>
								<cfset colspan_rept_ = colspan_rept_ + 2>
								<cfif type_ eq 1>
									<td></td>
									<td></td>
									<cfset colspan_rept_ = 1>
								</cfif>
							</cfif>
							<cfif listfind(attributes.list_type,2)>
								<cfset colspan_rept_ = colspan_rept_ + 1>
								<cfif type_ eq 1>
									<td></td>
									<cfset colspan_rept_ = 1>
								</cfif>		
							</cfif>
							<cfif listfind(attributes.list_type,3)>
								<cfset colspan_rept_ = colspan_rept_ + 1>
								<cfif type_ eq 1>
									<td></td>
									<cfset colspan_rept_ = 1>
								</cfif>		
							</cfif>
							<cfif listfind(attributes.list_type,4)>
								<cfset colspan_rept_ = colspan_rept_ + 1>
								<cfif type_ eq 1>
									<td></td>
									<cfset colspan_rept_ = 1>
								</cfif>		
							</cfif>
							<cfif listfind(attributes.list_type,5)>
								<cfset colspan_rept_ = colspan_rept_ + 1>
								<cfif type_ eq 1>
									<td></td>
									<cfset colspan_rept_ = 1>
								</cfif>		
							</cfif>
							<cfif listfind(attributes.list_type,9)>
								<cfset colspan_rept_ = colspan_rept_ + 1>
								<cfif type_ eq 1>
									<td></td>
									<cfset colspan_rept_ = 1>
								</cfif>		
							</cfif>
							<cfif listfind(attributes.list_type,6)>
								<cfset colspan_rept_ = colspan_rept_ + 1>
								<cfif type_ eq 1>
									<td></td>
									<cfset colspan_rept_ = 1>
								</cfif>		
							</cfif>
							<td height="20" class="txtbold" colspan="#colspan_rept_#" style="text-align:right"><cf_get_lang dictionary_id='57492.Toplam'></td>
							<cfif listfind(attributes.list_type,7)>
								<td class="txtbold" style="text-align:right" nowrap="nowrap" format="numeric">
									<cfloop list="#unit_list#" index="tt">
										<cfif evaluate('last_total_amount_#tt#') gt 0>
											#Tlformat(evaluate('last_total_amount_#tt#'))# #tt#<cfif isdefined("attributes.is_excel") and attributes.is_excel eq 1> <cfelse><cfif type_ neq 2><br/></cfif></cfif>
										</cfif>
									</cfloop>
									<cfif last_total_amount_ gt 0>
										#Tlformat(evaluate('last_total_amount_'))#
									</cfif>
								</td>				
							</cfif>
						</cfif>
						<cfif listfind(attributes.list_type,8)>
							<cfloop list="#tax_list#" index="tax_ii">
								<td class="txtbold" style="text-align:right" format="numeric"><cfif isdefined('kdv_genel_toplam_#NumberFormat(tax_ii)#') and len(evaluate('kdv_genel_toplam_#NumberFormat(tax_ii)#'))>#TLFormat(evaluate('kdv_genel_toplam_#NumberFormat(tax_ii)#'))#</cfif></td>
							</cfloop>
							<cfif isdefined("attributes.is_tevkifat")>
								<cfloop list="#tax_list#" index="tax_ii">
									<cfset tax_count=NumberFormat(tax_ii)>
									<td class="txtbold" style="text-align:right" format="numeric"><cfif isdefined('tevkifat_genel_toplam_#NumberFormat(tax_ii)#') and len(evaluate('tevkifat_genel_toplam_#NumberFormat(tax_ii)#'))>#TLFormat(evaluate('tevkifat_genel_toplam_#NumberFormat(tax_ii)#'))#</cfif></td>
								</cfloop>
								<cfloop list="#tax_list#" index="tax_ii">
									<cfset tax_count=NumberFormat(tax_ii)>
									<td class="txtbold" style="text-align:right" format="numeric"><cfif isdefined('beyan_genel_toplam_#NumberFormat(tax_ii)#') and len(evaluate('beyan_genel_toplam_#NumberFormat(tax_ii)#'))>#TLFormat(evaluate('beyan_genel_toplam_#NumberFormat(tax_ii)#')/100)#</cfif></td>
								</cfloop>
							</cfif>
						</cfif>
						<cfif listfind(attributes.list_type,12)>
							<cfloop list="#otv_list#" index="otv_ii">
								<td class="txtbold" style="text-align:right;" format="numeric">
									<cfif isdefined('otv_genel_toplam_#NumberFormat(otv_ii)#') and len(evaluate('otv_genel_toplam_#NumberFormat(otv_ii)#'))>
										#TLFormat(evaluate('otv_genel_toplam_#NumberFormat(otv_ii)#'))#
									</cfif>
								</td>
							</cfloop>
						</cfif>
						<cfif listfind(attributes.list_type,14)>
							<cfloop list="#bsmv_list#" index="bsmv_ii">
								<td class="txtbold" style="text-align:right;" format="numeric">
									<cfif isdefined('bsmv_genel_toplam_#filterNum(bsmv_ii)#') and len(evaluate('bsmv_genel_toplam_#filterNum(bsmv_ii)#'))>
										#TLFormat(evaluate('bsmv_genel_toplam_#filterNum(bsmv_ii)#'))#
									</cfif>
								</td>
							</cfloop>
						</cfif>
						<cfif listfind(attributes.list_type,15)>
							<cfloop list="#oiv_list#" index="oiv_ii">
								<td class="txtbold" style="text-align:right;" format="numeric">
									<cfif isdefined('oiv_genel_toplam_#filterNum(oiv_ii)#') and len(evaluate('oiv_genel_toplam_#filterNum(oiv_ii)#'))>
										#TLFormat(evaluate('oiv_genel_toplam_#filterNum(oiv_ii)#'))#
									</cfif>
								</td>
							</cfloop>
						</cfif>
						<cfif attributes.report_type eq 1>
							<td class="txtbold" style="text-align:right" format="numeric">#TLFormat(kdvsiz_toplam+toplam_indirim)#</td>
							<td class="txtbold" style="text-align:right" format="numeric">#TLFormat(fatalti_ind)#</td>
							<td class="txtbold" style="text-align:right" format="numeric"><cfif len(round_money_total)>#TLFormat(round_money_total)#</cfif></td>					
						</cfif>
						<cfif listfind(attributes.list_type,13)><td class="txtbold" style="text-align:right" format="numeric"></td></cfif>
						<cfif listfind(attributes.list_type,17)><td class="txtbold" style="text-align:right" format="numeric"></td></cfif>
						<cfif listfind(attributes.list_type,18)><td class="txtbold" style="text-align:right" format="numeric"></td></cfif>
						<td class="txtbold" style="text-align:right" format="numeric"><cfif len(toplam_indirim)>#TLFormat(toplam_indirim)#</cfif></td>
						<td class="txtbold" style="text-align:right" format="numeric">
							#TLFormat(indli_kdvsiz_toplam)#
						</td>
						<td class="txtbold" style="text-align:right" format="numeric">#TLFormat(general_otv_total_)#</td>
						<td class="txtbold" style="text-align:right" format="numeric"> #TLFormat(general_bsmv_total_)#</td>
						<td class="txtbold" style="text-align:right" format="numeric"> #TLFormat(general_oiv_total_)#</td>
						<td class="txtbold" style="text-align:right" format="numeric"></td>          
						<td class="txtbold" style="text-align:right" format="numeric">#TLFormat(kdv_toplam)#</td>
						<td class="txtbold" style="text-align:right" format="numeric">#TLFormat(kdvli_toplam)#</td>
					</tr>	
					</tfoot>
				<cfif attributes.page gt 1>
					<cfset devir_toplam =devir_toplam + kdv_toplam>
					<cfset devir_genel_toplam =devir_genel_toplam + kdvli_toplam>
					<cfset devir_kdvsiz_tolam =devir_kdvsiz_tolam +indli_kdvsiz_toplam>
					<cfset devir_toplam_indirim =devir_toplam_indirim +toplam_indirim> 
					<cfif attributes.report_type eq 1>
						<cfset devir_round_money_total=devir_round_money_total+round_money_total>
						<cfset devir_fatalti_ind=devir_fatalti_ind+fatalti_ind>
						<cfset devir_kdvsiz_toplam_ind=devir_kdvsiz_toplam_ind+ kdvsiz_toplam>
					</cfif>
					<tfoot>
					<tr>
						<cfif attributes.report_type eq 2>
							<cfset colspan_ = 9>
							<cfif listfind(attributes.list_type,10)>
								<cfset colspan_ = colspan_ + 1>
								<cfif type_ eq 1>
									<cfloop index="aa" from="1" to="#colspan_-1#">
										<td></td>
									</cfloop>
									<cfset colspan_ = 1>
								</cfif>	
							</cfif>
							<cfif listfind(attributes.list_type,11)>
								<cfloop query="get_add_info_name">
									<cfset colspan_ = colspan_ + 1>
									<cfif type_ eq 1>
										<cfloop index="aa" from="1" to="#colspan_-1#">
											<td></td>
										</cfloop>
										<cfset colspan_ = 1>
									</cfif>	
								</cfloop>
							</cfif>
							<cfif listfind(attributes.list_type,1)>
								<cfset colspan_ = colspan_ + 2>
								<cfif type_ eq 1>
									<cfloop index="aa" from="1" to="#colspan_-2#">
										<td></td>
									</cfloop>
									<cfset colspan_ = 2>
								</cfif>
							</cfif>
							<cfif listfind(attributes.list_type,2)>
								<cfset colspan_ = colspan_ + 1>
								<cfif type_ eq 1>
									<cfloop index="aa" from="1" to="#colspan_-1#">
										<td></td>
									</cfloop>
									<cfset colspan_ = 1>
								</cfif>
							</cfif>
							<cfif listfind(attributes.list_type,3)>
								<cfset colspan_ = colspan_ + 1>
								<cfif type_ eq 1>
									<cfloop index="aa" from="1" to="#colspan_-1#">
										<td></td>
									</cfloop>
									<cfset colspan_ = 1>
								</cfif>
							</cfif>
							<cfif listfind(attributes.list_type,4)>
								<cfset colspan_ = colspan_ + 1>
								<cfif type_ eq 1>
									<cfloop index="aa" from="1" to="#colspan_-1#">
										<td></td>
									</cfloop>
									<cfset colspan_ = 1>
								</cfif>
							</cfif>
							<cfif listfind(attributes.list_type,5)>
								<cfset colspan_ = colspan_ + 1>
								<cfif type_ eq 1>
									<cfloop index="aa" from="1" to="#colspan_-1#">
										<td></td>
									</cfloop>
									<cfset colspan_ = 1>
								</cfif>
							</cfif>
							<cfif listfind(attributes.list_type,9)>
								<cfset colspan_ = colspan_ + 1>
								<cfif type_ eq 1>
									<cfloop index="aa" from="1" to="#colspan_-1#">
										<td></td>
									</cfloop>
									<cfset colspan_ = 1>
								</cfif>
							</cfif>
							<cfif listfind(attributes.list_type,6)>
								<cfset colspan_ = colspan_ + 1>
								<cfif type_ eq 1>
									<cfloop index="aa" from="1" to="#colspan_-1#">
										<td></td>
									</cfloop>
									<cfset colspan_ = 1>
								</cfif>
							</cfif>
							<td class="txtbold" style="text-align:right" colspan="#colspan_#"><cf_get_lang dictionary_id='40654.Kümülatif Toplamlar'></td>
							<cfif listfind(attributes.list_type,7)>
								<td class="txtbold" style="text-align:right" format="numeric">
									<cfloop list="#unit_list#" index="tt">
										<cfif evaluate('devir_total_row_quantity_#tt#') gt 0>
											#Tlformat(evaluate('devir_total_row_quantity_#tt#'))# #tt#<cfif type_ neq 2><br/></cfif>
										</cfif>
									</cfloop>
								</td>
							</cfif>
							<td format="numeric"></td>							
						<cfelse>
							<cfset colspan_ = 8>
							<cfif listfind(attributes.list_type,10)>
								<cfset colspan_ = colspan_ + 1>
								<cfif type_ eq 1>
									<cfloop index="aa" from="1" to="#colspan_-1#">
										<td></td>
									</cfloop>
									<cfset colspan_ = 1>
								</cfif>	
							</cfif>
							<cfif listfind(attributes.list_type,11)>
								<cfloop query="get_add_info_name">
									<cfset colspan_ = colspan_ + 1>
									<cfif type_ eq 1>
										<cfloop index="aa" from="1" to="#colspan_-1#">
											<td></td>
										</cfloop>
										<cfset colspan_ = 1>
									</cfif>	
								</cfloop>
							</cfif>
							<cfif listfind(attributes.list_type,1)>
								<cfset colspan_ = colspan_ + 2>
								<cfif type_ eq 1>
									<cfloop index="aa" from="1" to="#colspan_-2#">
										<td></td>
									</cfloop>
									<cfset colspan_ = 2>
								</cfif>
							</cfif>
							<cfif listfind(attributes.list_type,2)>
								<cfset colspan_ = colspan_ + 1>
								<cfif type_ eq 1>
									<cfloop index="aa" from="1" to="#colspan_-1#">
										<td></td>
									</cfloop>
									<cfset colspan_ = 1>
								</cfif>
							</cfif>
							<cfif listfind(attributes.list_type,3)>
								<cfset colspan_ = colspan_ + 1>
								<cfif type_ eq 1>
									<cfloop index="aa" from="1" to="#colspan_-1#">
										<td></td>
									</cfloop>
									<cfset colspan_ = 1>
								</cfif>
							</cfif>
							<cfif listfind(attributes.list_type,4)>
								<cfset colspan_ = colspan_ + 1>
								<cfif type_ eq 1>
									<cfloop index="aa" from="1" to="#colspan_-1#">
										<td></td>
									</cfloop>
									<cfset colspan_ = 1>
								</cfif>
							</cfif>
							<cfif listfind(attributes.list_type,5)>
								<cfset colspan_ = colspan_ + 1>
								<cfif type_ eq 1>
									<cfloop index="aa" from="1" to="#colspan_-1#">
										<td></td>
									</cfloop>
									<cfset colspan_ = 1>
								</cfif>
							</cfif>
							<cfif listfind(attributes.list_type,9)>
								<cfset colspan_ = colspan_ + 1>
								<cfif type_ eq 1>
									<cfloop index="aa" from="1" to="#colspan_-1#">
										<td></td>
									</cfloop>
									<cfset colspan_ = 1>
								</cfif>
							</cfif>
							<cfif listfind(attributes.list_type,6)>
								<cfset colspan_ = colspan_ + 1>
								<cfif type_ eq 1>
									<cfloop index="aa" from="1" to="#colspan_-1#">
										<td></td>
									</cfloop>
									<cfset colspan_ = 1>
								</cfif>
							</cfif>
							<td class="txtbold" style="text-align:right" colspan="#colspan_#"><cf_get_lang dictionary_id='40654.Kümülatif Toplamlar'></td>
							<cfif listfind(attributes.list_type,7)>
								<td height="20" class="txtbold" style="text-align:right" format="numeric">
									<cfloop list="#unit_list#" index="tt">
										<cfif evaluate('devir_last_total_amount_#tt#') gt 0>
											#Tlformat(evaluate('devir_last_total_amount_#tt#'))# #tt#<cfif type_ neq 2><br/></cfif>
										</cfif>
									</cfloop>
									<cfif devir_last_total_amount_ gt 0>
										#Tlformat(evaluate('devir_last_total_amount_'))#<cfif type_ neq 2><br/></cfif>
									</cfif>
								</td>
							</cfif>
						</cfif>
						<cfif listfind(attributes.list_type,8)>
							<cfloop list="#tax_list#" index="tax_ii">
								<td class="txtbold" style="text-align:right" format="numeric">
									<cfif isdefined('kdv_genel_toplam_#NumberFormat(tax_ii)#') and len(evaluate('kdv_genel_toplam_#NumberFormat(tax_ii)#'))>
										<cfif isdefined('devir_kdv_genel_toplam_#NumberFormat(tax_ii)#') and len(evaluate('devir_kdv_genel_toplam_#NumberFormat(tax_ii)#'))>
											#TLFormat(evaluate("kdv_genel_toplam_#NumberFormat(tax_ii)#") + evaluate("devir_kdv_genel_toplam_#NumberFormat(tax_ii)#"))#
										<cfelse>
											#TLFormat(evaluate("kdv_genel_toplam_#NumberFormat(tax_ii)#"))#
										</cfif>
									<cfelseif isdefined('devir_kdv_genel_toplam_#NumberFormat(tax_ii)#') and len(evaluate('devir_kdv_genel_toplam_#NumberFormat(tax_ii)#'))>
										#TLFormat(evaluate("devir_kdv_genel_toplam_#NumberFormat(tax_ii)#"))#
									</cfif>				
								</td>
							</cfloop>
							<cfif isdefined("attributes.is_tevkifat") and attributes.report_type eq 1>
								<cfloop list="#tax_list#" index="tax_ii">
									<cfset tax_count=NumberFormat(tax_ii)>
									<td class="txtbold" style="text-align:right" format="numeric"><cfif isdefined('devir_tevkifat_genel_toplam_#NumberFormat(tax_ii)#') and len(evaluate('devir_tevkifat_genel_toplam_#NumberFormat(tax_ii)#'))>#TLFormat(evaluate('devir_tevkifat_genel_toplam_#NumberFormat(tax_ii)#'))#</cfif></td>
								</cfloop>
								<cfloop list="#tax_list#" index="tax_ii">
									<cfset tax_count=NumberFormat(tax_ii)>
									<td class="txtbold" style="text-align:right" format="numeric"><cfif isdefined('devir_beyan_genel_toplam_#NumberFormat(tax_ii)#') and len(evaluate('devir_beyan_genel_toplam_#NumberFormat(tax_ii)#'))>#TLFormat(evaluate('devir_beyan_genel_toplam_#NumberFormat(tax_ii)#'))#</cfif></td>
								</cfloop>
							 <cfelseif isdefined("attributes.is_tevkifat") and attributes.report_type eq 2>
								<cfloop list="#tax_list#" index="tax_ii">
									<cfset tax_count=NumberFormat(tax_ii)>
									<td class="txtbold" style="text-align:right" format="numeric"><cfif isdefined('devir_tevkifat_genel_toplam_#NumberFormat(tax_ii)#') and len(evaluate('devir_tevkifat_genel_toplam_#NumberFormat(tax_ii)#'))>#TLFormat(evaluate('devir_tevkifat_genel_toplam_#NumberFormat(tax_ii)#'))#</cfif></td>
								</cfloop>
								<cfloop list="#tax_list#" index="tax_ii">
									<cfset tax_count=NumberFormat(tax_ii)>
									<td class="txtbold" style="text-align:right" format="numeric"><cfif isdefined('devir_beyan_genel_toplam_#NumberFormat(tax_ii)#') and len(evaluate('devir_beyan_genel_toplam_#NumberFormat(tax_ii)#'))>#TLFormat(evaluate('devir_beyan_genel_toplam_#NumberFormat(tax_ii)#'))#</cfif></td>
								</cfloop>
							</cfif>
						</cfif>
						<cfif listfind(attributes.list_type,12)>
							<cfloop list="#otv_list#" index="otv_ii">
								<td class="txtbold" style="text-align:right;" format="numeric">
									<cfif isdefined('otv_genel_toplam_#NumberFormat(otv_ii)#') and len(evaluate('otv_genel_toplam_#NumberFormat(otv_ii)#'))>
										<cfif isdefined('devir_otv_genel_toplam_#NumberFormat(otv_ii)#') and len(evaluate('devir_otv_genel_toplam_#NumberFormat(otv_ii)#'))>
											#TLFormat(evaluate("otv_genel_toplam_#NumberFormat(otv_ii)#") + evaluate("devir_otv_genel_toplam_#NumberFormat(otv_ii)#"))#
										<cfelse>
											#TLFormat(evaluate("otv_genel_toplam_#NumberFormat(otv_ii)#"))#
										</cfif>
									<cfelseif isdefined('devir_otv_genel_toplam_#NumberFormat(otv_ii)#') and len(evaluate('devir_otv_genel_toplam_#NumberFormat(otv_ii)#'))>
										#TLFormat(evaluate("devir_otv_genel_toplam_#NumberFormat(otv_ii)#"))#
									</cfif>				
								</td>
							</cfloop>
						</cfif>
						<cfif listfind(attributes.list_type,14)>
							<cfloop list="#bsmv_list#" index="bsmv_ii">
								<td class="txtbold" style="text-align:right;" format="numeric">
									<cfif isdefined('bsmv_genel_toplam_#NumberFormat(bsmv_ii)#') and len(evaluate('bsmv_genel_toplam_#NumberFormat(bsmv_ii)#'))>
										<cfif isdefined('devir_bsmv_genel_toplam_#NumberFormat(bsmv_ii)#') and len(evaluate('devir_bsmv_genel_toplam_#NumberFormat(bsmv_ii)#'))>
											#TLFormat(evaluate("bsmv_genel_toplam_#NumberFormat(bsmv_ii)#") + evaluate("devir_bsmv_genel_toplam_#NumberFormat(bsmv_ii)#"))#
										<cfelse>
											#TLFormat(evaluate("bsmv_genel_toplam_#NumberFormat(bsmv_ii)#"))#
										</cfif>
									<cfelseif isdefined('devir_bsmv_genel_toplam_#NumberFormat(bsmv_ii)#') and len(evaluate('devir_bsmv_genel_toplam_#NumberFormat(bsmv_ii)#'))>
										#TLFormat(evaluate("devir_bsmv_genel_toplam_#NumberFormat(bsmv_ii)#"))#
									</cfif>				
								</td>
							</cfloop>
						</cfif>
						<cfif listfind(attributes.list_type,15)>
							<cfloop list="#oiv_list#" index="oiv_ii">
								<td class="txtbold" style="text-align:right;" format="numeric">
									<cfif isdefined('oiv_genel_toplam_#NumberFormat(oiv_ii)#') and len(evaluate('oiv_genel_toplam_#NumberFormat(oiv_ii)#'))>
										<cfif isdefined('devir_oiv_genel_toplam_#NumberFormat(oiv_ii)#') and len(evaluate('devir_oiv_genel_toplam_#NumberFormat(oiv_ii)#'))>
											#TLFormat(evaluate("oiv_genel_toplam_#NumberFormat(oiv_ii)#") + evaluate("devir_oiv_genel_toplam_#NumberFormat(oiv_ii)#"))#
										<cfelse>
											#TLFormat(evaluate("oiv_genel_toplam_#NumberFormat(oiv_ii)#"))#
										</cfif>
									<cfelseif isdefined('devir_oiv_genel_toplam_#NumberFormat(oiv_ii)#') and len(evaluate('devir_oiv_genel_toplam_#NumberFormat(oiv_ii)#'))>
										#TLFormat(evaluate("devir_oiv_genel_toplam_#NumberFormat(oiv_ii)#"))#
									</cfif>				
								</td>
							</cfloop>
						</cfif>
						<cfif attributes.report_type eq 1>
						<td class="txtbold" style="text-align:right" format="numeric">#TLFormat(devir_kdvsiz_toplam_ind)#</td>
						<td class="txtbold" style="text-align:right" format="numeric">#TLFormat(devir_fatalti_ind)#</td>
						<td class="txtbold" style="text-align:right" format="numeric"><cfif len(round_money_total)>#TLFormat(devir_round_money_total)#</cfif></td>
						</cfif>
						<td class="txtbold" style="text-align:right" format="numeric"><cfif len(devir_toplam_indirim)>#TLFormat(devir_toplam_indirim)#</cfif></td>
						<td class="txtbold" style="text-align:right" format="numeric">#TLFormat(devir_kdvsiz_tolam)#</td>
						<td class="txtbold" style="text-align:right" format="numeric"></td>
						<td class="txtbold" style="text-align:right" format="numeric"></td>
						<td class="txtbold" style="text-align:right" format="numeric"></td>
						<td class="txtbold" style="text-align:right" format="numeric"></td>
						<td class="txtbold" style="text-align:right" format="numeric">#TLFormat(devir_toplam)#</td>
						<td class="txtbold" style="text-align:right" format="numeric">#TLFormat(devir_genel_toplam)#</td>
					</tr>
					</tfoot>
				</cfif>
				</cfoutput>
			<cfelse>
				<cfoutput>
					<cfset colspan_ = 16>
					<cfif listfind(attributes.list_type,10)>
						<cfset colspan_ = colspan_ + 1>
					</cfif>
					<cfif listfind(attributes.list_type,11)>
						<cfloop query="get_add_info_name">
						   <cfset colspan_ = colspan_ + 1>
						</cfloop>
					</cfif>
					<cfif listfind(attributes.list_type,1)>
						<cfset colspan_ = colspan_ + 2>
					</cfif>
					<cfif listfind(attributes.list_type,2)>
						<cfset colspan_ = colspan_ + 1>
					</cfif>
					<cfif attributes.report_type eq 1 and listfind(attributes.list_type,6)>
						<cfset colspan_ = colspan_ + 1>
					</cfif>
					<cfif listfind(attributes.list_type,3)>
						<cfset colspan_ = colspan_ + 1>
					</cfif>
					<cfif listfind(attributes.list_type,4)>
						<cfset colspan_ = colspan_ + 1>
					</cfif>
					<cfif listfind(attributes.list_type,5)>
						<cfset colspan_ = colspan_ + 1>
					</cfif>
					<cfif listfind(attributes.list_type,9)>
						<cfset colspan_ = colspan_ + 1>
					</cfif>
					<cfif attributes.report_type eq 1 and listfind(attributes.list_type,7)><!--- belge bazında birimlere gore toplu miktarlar getiriliyor --->
						<cfset colspan_ = colspan_ + 1>
					</cfif>
					<cfif attributes.report_type eq 2>
						<cfif listfind(attributes.list_type,6)><cfset colspan_ = colspan_ + 1></cfif>
						<cfif listfind(attributes.list_type,7)><cfset colspan_ = colspan_ + 1></cfif>
						<cfset colspan_ = colspan_ + 1>
					</cfif>
					<cfif listfind(attributes.list_type,8)>
						<cfloop list="#tax_list#" index="tax_t">
							<cfoutput><cfset colspan_ = colspan_ + 1></cfoutput>
						</cfloop>
						<cfif isdefined("attributes.is_tevkifat")>
							<cfloop list="#tax_list#" index="tax_t">
								<cfoutput><cfset colspan_ = colspan_ + 1></cfoutput>
							</cfloop>
							<cfloop list="#tax_list#" index="tax_t">
								<cfoutput><cfset colspan_ = colspan_ + 1></cfoutput>
							</cfloop>
						</cfif>
					</cfif>
					<cfif listfind(attributes.list_type,12)>
						<cfloop list="#otv_list#" index="otv_t">
							<cfset colspan_ = colspan_ + 1>
						</cfloop>
					</cfif>
					<cfif listfind(attributes.list_type,14)>
						<cfloop list="#bsmv_list#" index="bsmv_t">
							<cfset colspan_ = colspan_ + 1>
						</cfloop>
					</cfif>
					<cfif listfind(attributes.list_type,15)>
						<cfloop list="#oiv_list#" index="oiv_t">
							<cfset colspan_ = colspan_ + 1>
						</cfloop>
					</cfif>
					<cfif attributes.report_type eq 1>
						<cfset colspan_ = colspan_ + 3>
					</cfif>
					<tr>
						<td height="20" colspan="#colspan_#"><cfif isdefined("attributes.form_varmi")><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</cfif></td>
					</tr>
				</cfoutput>
			</cfif>
			
		</cf_report_list>
		</cfif>
		<cfif not (isdefined('attributes.is_excel') and listfind('1,2',attributes.is_excel,','))>
			<cfset adres = "">
			<cfif get_invoice.recordcount and (attributes.maxrows lt attributes.totalrecords)>
				<cfset adres = "#attributes.fuseaction#&form_varmi=1">	
				<cfif isDefined("attributes.startdate") and len(attributes.startdate)>
					<cfset adres = "#adres#&startdate=#attributes.startdate#">
				</cfif>
				<cfif isDefined("attributes.finishdate") and len(attributes.finishdate)>
					<cfset adres = "#adres#&finishdate=#attributes.finishdate#">
				</cfif>
				<cfif isDefined("attributes.department_id") and len(attributes.department_id)>
					<cfset adres = "#adres#&department_id=#attributes.department_id#">
				</cfif>
				<cfif isDefined("attributes.category_id") and len(attributes.category_id)>
					<cfset adres = "#adres#&category_id=#attributes.category_id#">
				</cfif>
				<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
					<cfset adres = "#adres#&company_id=#attributes.company_id#">
				</cfif>
				<cfif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
					<cfset adres = "#adres#&consumer_id=#attributes.consumer_id#">
				</cfif>
				<cfif isDefined("attributes.company") and len(attributes.company)>
					<cfset adres = "#adres#&company=#attributes.company#">
				</cfif> 
				<cfif isDefined("attributes.process_type") and len(attributes.process_type)>
					<cfset adres = "#adres#&process_type=#attributes.process_type#">
				</cfif>
				<cfif isDefined("attributes.is_tevkifat") and len(attributes.is_tevkifat)>
					<cfset adres = "#adres#&is_tevkifat=#attributes.is_tevkifat#">
				</cfif>
				<cfif isDefined("attributes.is_department") and len(attributes.is_department)>
					<cfset adres = "#adres#&is_department=#attributes.is_department#">
				</cfif>
				<cfif isDefined("attributes.is_inv_total") and len(attributes.is_inv_total)>
					<cfset adres = "#adres#&is_inv_total=#attributes.is_inv_total#">
				</cfif>  
				<cfif isDefined("attributes.ship_method_id") and len(attributes.ship_method_id)>
					<cfset adres = "#adres#&ship_method_id=#attributes.ship_method_id#">
				</cfif>
				<cfif isDefined("attributes.ship_method_name") and len(attributes.ship_method_name)>
					<cfset adres = "#adres#&ship_method_name=#attributes.ship_method_name#">
				</cfif>     
				<cfif isDefined("attributes.list_type") and len(attributes.list_type)>
					<cfset adres = "#adres#&list_type=#attributes.list_type#">
				</cfif>
				<cfif isDefined("attributes.project_id") and len(attributes.project_id)>
					<cfset adres = "#adres#&project_id=#attributes.project_id#">
				</cfif>
				<cfif isDefined("attributes.project_head") and len(attributes.project_head)>
					<cfset adres = "#adres#&project_head=#attributes.project_head#">
				</cfif>
				<cfif isdefined("attributes.subscription_type_id") and len(attributes.subscription_type_id)>
					<cfset adres = "#adres#&subscription_type_id=#attributes.subscription_type_id#">
				</cfif>
				<cfif isdefined("attributes.subscription_type") and len(attributes.subscription_type)>
					<cfset adres = "#adres#&subscription_type=#attributes.subscription_type#">
				</cfif>			
				<cfif isdefined("attributes.use_efatura") and len(attributes.use_efatura)>
					<cfset adres = "#adres#&use_efatura=#attributes.use_efatura#">
				</cfif>  
				<cfif isdefined("attributes.product_cat_id") and len(attributes.product_cat_id)>
					<cfset adres = "#adres#&product_cat_id=#attributes.product_cat_id#">
				</cfif> 
				
				<cfset adres = "#adres#&report_type=#attributes.report_type#">
				<cf_paging 
					page="#attributes.page#" 
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="#adres#">
			</cfif>
		</cfif>
		</cfprocessingdirective>
		<script type="text/javascript">
			function kontrol_report()
			{
				deger = form.report_type.options[form.report_type.selectedIndex].value;
				if(deger == 2)
				{
					inv_total.style.display = '';
					tevkifat_total.style.display = '';
				}
				else
				{
					inv_total.style.display = 'none';
					tevkifat_total.style.display = '';
				}
			}
			function kontrol()
			{
				if ((document.form.startdate.value != '') && (document.form.finishdate.value != '') &&
				!date_check(form.startdate,form.finishdate,"<cf_get_lang dictionary_id='39814.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
					 return false;
				if(document.form.is_excel.checked==false)
				{
					document.form.action="<cfoutput>#request.self#?fuseaction=report.invoice_list_sale</cfoutput>";
					return true;
				
				}
				else
				{
					document.form.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_invoice_list_sale</cfoutput>";
				}
			}
		</script>
		<cfsetting showdebugoutput="yes">