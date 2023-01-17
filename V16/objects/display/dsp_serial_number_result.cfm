
<cfsetting showdebugoutput="yes">
<cf_xml_page_edit fuseact="objects.serial_no">
<cfparam name="kalan_sure" default="">
<cfif isdefined("attributes.product_serial_no") and len(attributes.product_serial_no) and (isdefined("attributes.seri_stock_id") or isdefined("attributes.only_service"))>
	<cfif isdefined("attributes.seri_stock_id")>
		<cfquery name="get_search_results_" datasource="#dsn3#">
			SELECT 
				SG.GUARANTY_ID,
				SG.RECORD_DATE,
				SG.STOCK_ID,
				SG.PROCESS_ID,
				SG.SERIAL_NO,
				SG.REFERENCE_NO,
                SG.LOT_NO,
				SG.IS_SALE,
				SG.PROCESS_CAT,
				CASE 
                    WHEN SG.PROCESS_CAT IN (1719) THEN (SELECT RESULT_NO FROM PRODUCTION_ORDER_RESULTS WHERE PR_ORDER_ID = SG.PROCESS_ID) 
                    ELSE SG.PROCESS_NO
                END AS PROCESS_NO,
				SG.SALE_CONSUMER_ID,
				SG.SALE_COMPANY_ID,
				SG.PURCHASE_GUARANTY_CATID,
				SG.SALE_GUARANTY_CATID,
				SG.SALE_START_DATE,
				SG.SALE_FINISH_DATE,
				SG.PURCHASE_START_DATE,
				SG.PURCHASE_FINISH_DATE,
				SG.PURCHASE_COMPANY_ID,
				SG.IS_PURCHASE,
				SG.IN_OUT,
				SG.IS_RETURN,
				SG.IS_RMA,
				SG.IS_SERVICE,
				SG.IS_TRASH,
				SG.PURCHASE_CONSUMER_ID,
				SG.MAIN_STOCK_ID,
				SG.IS_SERI_SONU,
				SG.DEPARTMENT_ID,
				E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME,
				S.STOCK_CODE,
				S.PRODUCT_NAME,
				S.PROPERTY,
				S.PRODUCT_ID
			FROM 
				SERVICE_GUARANTY_NEW SG,
				STOCKS S,
				#DSN_ALIAS#.EMPLOYEES E
			WHERE 
				SG.RECORD_EMP = E.EMPLOYEE_ID AND 
				SG.STOCK_ID = S.STOCK_ID AND 
				SG.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.seri_stock_id#"> AND
				(
                	SG.SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_serial_no#"> 
                	OR SG.REFERENCE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_serial_no#">
                    OR SG.LOT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_serial_no#">
                )
				<cfif isdefined("attributes.is_store")>
					AND ( SG.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">))
				</cfif>
		 		<!--- AND SG.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> Ömer Turhan'ın isteği üzerine kaldırıldı.--->
			ORDER BY 
				SG.UPDATE_DATE DESC,
				SG.RECORD_DATE DESC
		</cfquery>
	<cfelse>
		<cfset get_search_results_.recordcount = 0>
	</cfif>
	<cfif isdefined("attributes.company_send_form") and get_search_results_.recordcount>
		<script type="text/javascript">
			<cfoutput>
				opener.#attributes.company_send_form#.service_product_id.value = '#get_search_results_.PRODUCT_ID#';
				opener.#attributes.company_send_form#.stock_id.value = '#get_search_results_.STOCK_ID#';
				opener.#attributes.company_send_form#.service_product.value = '#get_search_results_.PRODUCT_NAME#  #get_search_results_.PROPERTY#';
				opener.#attributes.company_send_form#.is_check_product_serial_number.value = 1;
	
				<cfif len(get_search_results_.sale_consumer_id)>
					opener.#attributes.company_send_form#.company_id.value = '';
					opener.#attributes.company_send_form#.company_name.value = '';
					opener.#attributes.company_send_form#.service_address.value = '';
					opener.#attributes.company_send_form#.member_id.value = '#get_search_results_.sale_consumer_id#';
					opener.#attributes.company_send_form#.member_type.value = 'consumer';
					opener.#attributes.company_send_form#.member_name.value = '#get_cons_info(get_search_results_.sale_consumer_id,1,0)#';
				<cfelseif len(get_search_results_.purchase_consumer_id)>
					opener.#attributes.company_send_form#.company_id.value = '';
					opener.#attributes.company_send_form#.company_name.value = '';
					opener.#attributes.company_send_form#.service_address.value = '';
					opener.#attributes.company_send_form#.member_id.value = '#get_search_results_.purchase_consumer_id#';
					opener.#attributes.company_send_form#.member_type.value = 'consumer';
					opener.#attributes.company_send_form#.member_name.value = '#get_cons_info(get_search_results_.purchase_consumer_id,1,0)#';
				<cfelseif len(get_search_results_.sale_company_id)>
					<cfquery name="get_par_comp" datasource="#dsn#">
						SELECT 
							C.FULLNAME,
							CP.COMPANY_PARTNER_NAME,
							CP.COMPANY_PARTNER_SURNAME,
							C.MANAGER_PARTNER_ID,
							C.COMPANY_ADDRESS
						FROM
							COMPANY C,
							COMPANY_PARTNER CP
						WHERE
							C.MANAGER_PARTNER_ID = CP.PARTNER_ID AND 
							C.COMPANY_ID = #get_search_results_.sale_company_id# AND
							C.COMPANY_ID = CP.COMPANY_ID
					</cfquery>
					opener.#attributes.company_send_form#.company_id.value = '#get_search_results_.sale_company_id#';
					opener.#attributes.company_send_form#.company_name.value = '#get_par_comp.FULLNAME#';
					opener.#attributes.company_send_form#.service_address.value = "#replace(get_par_comp.COMPANY_ADDRESS,chr(13)&chr(10),' ','all')#";
					opener.#attributes.company_send_form#.member_id.value = '#get_par_comp.MANAGER_PARTNER_ID#';
					opener.#attributes.company_send_form#.member_type.value = 'partner';
					opener.#attributes.company_send_form#.member_name.value = '#get_par_comp.COMPANY_PARTNER_NAME# #get_par_comp.COMPANY_PARTNER_SURNAME#';
				<cfelseif len(get_search_results_.purchase_company_id)>
					<cfquery name="get_par_comp_2" datasource="#dsn#">
						SELECT
							C.MANAGER_PARTNER_ID,
							CP.COMPANY_PARTNER_NAME,
							CP.COMPANY_PARTNER_SURNAME,
							CP.COMPANY_PARTNER_EMAIL,
							CB.COMPBRANCH_TELCODE,
							CB.COMPBRANCH_TEL1,
							CB.COMPBRANCH_ADDRESS,
							CB.COUNTY_ID,
							CB.CITY_ID,
							SC.COUNTY_NAME,
							C.FULLNAME,
							S_C.CITY_NAME,
							S.COUNTRY_NAME,
							SZ.SZ_ID
						FROM
							COMPANY_BRANCH AS CB 
							LEFT JOIN SETUP_COUNTY AS SC ON SC.COUNTY_ID = CB.COUNTY_ID 
							LEFT JOIN SETUP_CITY AS S_C ON S_C.CITY_ID = CB.CITY_ID
							LEFT JOIN SETUP_COUNTRY AS S ON S.COUNTRY_ID = CB.COUNTRY_ID,
							COMPANY_PARTNER AS CP,
							COMPANY AS C LEFT JOIN SALES_ZONES AS SZ ON SZ.SZ_ID = C.SALES_COUNTY
						WHERE
							CB.COMPANY_ID = #get_search_results_.purchase_company_id#
							AND CP.COMPANY_ID = CB.COMPANY_ID
							AND C.COMPANY_ID = CB.COMPANY_ID
					</cfquery>					
					opener.#attributes.company_send_form#.company_id.value = '#get_search_results_.purchase_company_id#';
					opener.#attributes.company_send_form#.company_name.value = '#get_par_comp_2.FULLNAME#';
					opener.#attributes.company_send_form#.member_id.value = '#get_par_comp_2.MANAGER_PARTNER_ID#';
					opener.#attributes.company_send_form#.member_type.value = 'partner';
					opener.#attributes.company_send_form#.member_name.value = '#get_par_comp_2.COMPANY_PARTNER_NAME# #get_par_comp_2.COMPANY_PARTNER_SURNAME#';
					opener.#attributes.company_send_form#.bring_tel_no.value = '#get_par_comp_2.COMPBRANCH_TELCODE##get_par_comp_2.COMPBRANCH_TEL1#';
					opener.#attributes.company_send_form#.bring_email.value = '#get_par_comp_2.COMPANY_PARTNER_EMAIL#';
					opener.#attributes.company_send_form#.service_address.value = '#replace(get_par_comp_2.COMPBRANCH_ADDRESS,chr(13)&chr(10)," ","all")# #get_par_comp_2.COUNTY_NAME# #get_par_comp_2.CITY_NAME# #get_par_comp_2.COUNTRY_NAME#';
					opener.#attributes.company_send_form#.service_city_id.value = '#get_par_comp_2.CITY_ID#';
					opener.#attributes.company_send_form#.service_county_id.value = '#get_par_comp_2.COUNTY_ID#';
					opener.#attributes.company_send_form#.service_county_name.value = '#get_par_comp_2.COUNTY_NAME#';
					opener.#attributes.company_send_form#.applicator_comp_name.value = '#get_par_comp_2.FULLNAME#';
					opener.#attributes.company_send_form#.sales_zone_id.value = '#get_par_comp_2.SZ_ID#';
				</cfif>
			</cfoutput>
		</script>
	</cfif>
	<cfset kalan_sure = 0>
	<cfif isdefined("attributes.seri_stock_id")>
    	<cfquery name="get_search_results_ilk" dbtype="query" maxrows="1">
            SELECT * FROM get_search_results_ ORDER BY GUARANTY_ID DESC
        </cfquery>
		<cfif not listfind('73,74,75',get_search_results_.process_cat)>
            <cfquery name="get_search_results_guaranty" dbtype="query" maxrows="1">
                SELECT * FROM get_search_results_ WHERE IS_SALE = 1 AND PROCESS_CAT NOT IN (141) ORDER BY GUARANTY_ID DESC
            </cfquery>
            <cfif len(get_search_results_guaranty.SALE_FINISH_DATE)>
                <cfset kalan_sure = datediff("d",now(),get_search_results_guaranty.SALE_FINISH_DATE)>
            </cfif>
            <cfset sale_purchase = 1>
            <cfif not get_search_results_guaranty.recordcount>
                <cfquery name="get_search_results_guaranty" dbtype="query" maxrows="1">
                    SELECT * FROM get_search_results_ WHERE IN_OUT=0 ORDER BY GUARANTY_ID DESC
                </cfquery>
                <cfif len(get_search_results_guaranty.PURCHASE_FINISH_DATE)>
					<cfset kalan_sure = datediff("d",now(),get_search_results_guaranty.PURCHASE_FINISH_DATE)>
                </cfif>
                <cfset sale_purchase = 0>
            </cfif>
        <cfelse>
            <cfquery name="get_search_results_guaranty" dbtype="query" maxrows="1">
                SELECT * FROM get_search_results_ WHERE IS_SALE = 1 AND PROCESS_CAT NOT IN (141) ORDER BY GUARANTY_ID DESC
            </cfquery>
            <cfset sale_purchase = 1>
            <cfset kalan_sure = 0>
        </cfif>
	<cfelse>
		<cfset get_search_results_ilk.recordcount = 0>
	</cfif>
	<cfif get_search_results_.recordcount and len(get_search_results_.PROCESS_ID)>
		<cfquery name="get_related_results_" datasource="#dsn3#">
			SELECT 
				SG.*,
				E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME,
				D.DEPARTMENT_HEAD,
				S.STOCK_CODE,
				S.PRODUCT_NAME
			FROM 
				SERVICE_GUARANTY_NEW SG,
				STOCKS S,
				#DSN_ALIAS#.EMPLOYEES E,
				#DSN_ALIAS#.DEPARTMENT D
			WHERE 
				SG.RECORD_EMP = E.EMPLOYEE_ID
				AND SG.DEPARTMENT_ID = D.DEPARTMENT_ID
				AND SG.STOCK_ID = S.STOCK_ID
				AND RETURN_SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_search_results_.serial_no#">
				AND RETURN_STOCK_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_search_results_.stock_id#">
				AND RETURN_PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_search_results_.PROCESS_ID#">
				<cfif isdefined("attributes.is_store")>
					AND  ( SG.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">))
				</cfif>
			ORDER BY GUARANTY_ID DESC
		</cfquery>
	</cfif>
</cfif>
<cf_catalystHeader> 
<cfsavecontent variable="message"><cf_get_lang dictionary_id='33760.Seri No Sorgulama'></cfsavecontent>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
<cf_box title="#message#" collapsable="0" resize="0">
	<cfinclude template="serial_number.cfm">
</cf_box>
</div>
			<cfif isdefined("attributes.product_serial_no") and len(attributes.product_serial_no) and (isdefined("attributes.seri_stock_id") or isdefined("attributes.only_service"))>
				<cfif get_search_results_.recordcount>
					<div class="col col-9 col-md-9 col-sm-9 col-xs-12" type="column" index="2" sort="true">
						<cfoutput query="get_search_results_ilk">
						<cf_box title="#getlang('','Seri no','57637')#: #serial_no#">
								<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
									<div class="form-group" id="item-stock_code">
										<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
									<div class="col col-8 col-md-8 col-xs-12">
										: #product_name#-#guaranty_id#
									</div>
									</div>
									<div class="form-group" id="item-serial_no">
										<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='57637.Seri No'></label>
									<div class="col col-8 col-md-8 col-xs-12">
										: #serial_no#
									</div>
									</div>
									<div class="form-group" id="item-stock_code">
										<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id ='57518.Stok Kodu'></label>
									<div class="col col-8 col-md-8 col-xs-12">
										: #STOCK_CODE#
									</div>
									</div>
									<div class="form-group" id="item-reference_no">
										<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='58794.Referans No'></label>
									<div class="col col-8 col-md-8 col-xs-12">
										: #reference_no#
									</div>
									</div>
									<div class="form-group" id="item-lot_no">
										<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='32916.Lot No'></label>
									<div class="col col-8 col-md-8 col-xs-12">
										: #lot_no#
									</div>
									</div>
									<div class="form-group" id="item-guarantycat_id">
										<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='57717.Garanti'></label>
									<div class="col col-8 col-md-8 col-xs-12">
										: 
										<cfif sale_purchase eq 1>
											<cf_get_lang dictionary_id='57448.Satış'> <cfset attributes.guarantycat_id = get_search_results_guaranty.SALE_GUARANTY_CATID>
										<cfelseif process_cat eq 1193>
											<cf_get_lang dictionary_id='57448.Satış'> <cfset attributes.guarantycat_id = get_search_results_guaranty.SALE_GUARANTY_CATID>
										<cfelse>
											<cf_get_lang dictionary_id='58176.Alış'> <cfset attributes.guarantycat_id = get_search_results_guaranty.PURCHASE_GUARANTY_CATID>
										</cfif>
										<cf_get_lang dictionary_id ='33761.Garantisi'> - 
										<cfif isdefined("attributes.guarantycat_id") and len(attributes.guarantycat_id)>
											<cfquery name="GET_GUARANTY_CAT" datasource="#dsn#">
												SELECT *,(SELECT SGT.GUARANTYCAT_TIME FROM #dsn_alias#.SETUP_GUARANTYCAT_TIME SGT WHERE SGT.GUARANTYCAT_TIME_ID = SETUP_GUARANTY.GUARANTYCAT_TIME) GUARANTYCAT_TIME_  FROM  SETUP_GUARANTY WHERE GUARANTYCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.guarantycat_id#">
											</cfquery>
											#GET_GUARANTY_CAT.guarantycat# - #GET_GUARANTY_CAT.guarantycat_time_# <cf_get_lang dictionary_id='58724.Ay'>
										</cfif>
									</div>
									</div>
									<div class="form-group" id="item-sale_purchase">
										<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id ='33762.Garanti Tarihi'></label>
									<div class="col col-8 col-md-8 col-xs-12">
										:
										<cfif sale_purchase eq 1>
											#dateformat(get_search_results_guaranty.SALE_START_DATE,dateformat_style)# - #dateformat(get_search_results_guaranty.SALE_FINISH_DATE,dateformat_style)#
										<cfelse>
											#dateformat(get_search_results_guaranty.PURCHASE_START_DATE,dateformat_style)# - #dateformat(get_search_results_guaranty.PURCHASE_FINISH_DATE,dateformat_style)#
										</cfif>
									</div>
									</div>
									<div class="form-group" id="item-kalan_sure">
										<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id ='33854.Kalan Süre'></label>
									<div class="col col-8 col-md-8 col-xs-12">
										:
											#kalan_sure# <cf_get_lang dictionary_id ='57490.gün'>
									</div>
									</div>
								</div><div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
									<div class="form-group" id="item-department_id">
										<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='58763.Depo'></label>
									<div class="col col-8 col-md-8 col-xs-12">
										:
										<cfif len(department_id)>
											<cfquery name="get_dep" datasource="#dsn#">
												SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#department_id#">
											</cfquery>
											#get_dep.DEPARTMENT_HEAD#
										</cfif>
									</div>
									</div>
									<div class="form-group" id="item-employee_surname">
										<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='57569.Görevli'></label>
									<div class="col col-8 col-md-8 col-xs-12">
										: #employee_name# #employee_surname#
									</div>
									</div>
									<div class="form-group" id="item-process_cat">
										<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='57800.İşlem Tipi'></label>
									<div class="col col-8 col-md-8 col-xs-12">
										: #get_process_name(process_cat)#
									</div>
									</div>
									<div class="form-group" id="item-process_no">
										<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='57880.Belge No'></label>
									<div class="col col-8 col-md-8 col-xs-12">
										: #process_no#
									</div>
									</div>
									<div class="form-group" id="item-sale_consumer_id">
										<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id ='33763.İlgili Firma / Kişi '></label>
									<div class="col col-8 col-md-8 col-xs-12">
										:
										<cfif len(sale_consumer_id)>#get_cons_info(sale_consumer_id,1,1)#
										<cfelseif len(sale_company_id)>#get_par_info(sale_company_id,1,1,1)#
										<cfelseif len(purchase_company_id)>#get_par_info(purchase_company_id,1,1,1)#
										<cfelseif len(purchase_consumer_id)>#get_cons_info(purchase_consumer_id,1,1)#
										</cfif>
									</div>
									</div>
									<div class="form-group" id="item-is_seri_sonu">
										<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id ='33764.Son Durum'></label>
									<div class="col col-8 col-md-8 col-xs-12">
										:
										<cfif is_purchase eq 1><cf_get_lang dictionary_id ='33765.Alındı'>,</cfif>
										<cfif is_sale eq 1><cf_get_lang dictionary_id ='33766.Satıldı'>,</cfif>
										<cfif in_out eq 1><cf_get_lang dictionary_id ='33237.Satılabilir'>,</cfif>
										<cfif is_return eq 1><cf_get_lang dictionary_id='29418.İade'>,</cfif>
										<cfif is_rma eq 1><cf_get_lang dictionary_id ='33239.Üreticide'>,</cfif>
										<cfif is_service eq 1><cf_get_lang dictionary_id ='33240.Serviste'>,</cfif>
										<cfif is_trash eq 1><cf_get_lang dictionary_id='29471.Fire'>,</cfif>
										<cfif is_seri_sonu eq 1><cf_get_lang dictionary_id ='33767.Seri Sonu'>,</cfif>
									</div>
									</div>
								</div>
						</cf_box>
					</cfoutput>
						<cfsavecontent variable="title_message"><cf_get_lang dictionary_id ='33768.Seri No Tarihçesi'></cfsavecontent>
							<cf_box 
								style="width:98%;" 
								title="#title_message#" 
								closable="0" 
								box_page="#request.self#?fuseaction=objects.serial_no_history_ajax&PRODUCT_SERIAL_NO=#attributes.PRODUCT_SERIAL_NO#&SERI_STOCK_ID=#get_search_results_.STOCK_ID#">
							</cf_box>
							<cfif isDefined("attributes.seri_stock_id") and len(attributes.seri_stock_id)>
								<cfsavecontent variable="title_message3"><cf_get_lang dictionary_id='33771.Seri No Ait Başvurular'></cfsavecontent>
								<cf_box 
									style="width:98%;" 
									title="#title_message3#" 
									closable="0"
									box_page="#request.self#?fuseaction=objects.serial_number_services_ajax&PRODUCT_SERIAL_NO=#attributes.PRODUCT_SERIAL_NO#&SERI_STOCK_ID=#attributes.seri_stock_id#">
								</cf_box>
							<cfelse>
								<cfsavecontent variable="title_message3"><cf_get_lang dictionary_id='33771.Seri No Ait Başvurular'></cfsavecontent>
								<cf_box 
									style="width:98%;" 
									title="#title_message3#" 
									closable="0"
									box_page="#request.self#?fuseaction=objects.serial_number_services_ajax&PRODUCT_SERIAL_NO=#attributes.PRODUCT_SERIAL_NO#">
								</cf_box>
							</cfif>
							<cfif x_is_stock>
							<cf_box title="#getlang('','Stok','57452')#">
								<cfset attributes.solo_serial_no = '#attributes.PRODUCT_SERIAL_NO#'>
								<cfset attributes.crtrow = 1>
								<cfset attributes.sid = get_search_results_.STOCK_ID>
								<cfinclude template="../../objects/display/location_stock_status_info.cfm">
								<cfinclude template="../../objects/display/seri_no_stock_status_info.cfm">
								<cfif isdefined("attributes.seri_stock_id") and len(attributes.seri_stock_id)>
									<cfquery name="get_system_serials" datasource="#dsn3#">
										SELECT 
											SG.GUARANTY_ID,
											SG.RECORD_DATE,
											SG.STOCK_ID,
											SG.PROCESS_ID,
											SG.SERIAL_NO,
											SG.LOT_NO,
											SG.IS_SALE,
											SG.PROCESS_CAT,
											SG.PROCESS_NO,
											SG.SALE_CONSUMER_ID,
											SG.SALE_COMPANY_ID,
											SG.PURCHASE_GUARANTY_CATID,
											SG.SALE_GUARANTY_CATID,
											SG.SALE_START_DATE,
											SG.SALE_FINISH_DATE,
											SG.PURCHASE_START_DATE,
											SG.PURCHASE_FINISH_DATE,
											SG.PURCHASE_COMPANY_ID,
											SG.PURCHASE_CONSUMER_ID,
											SG.MAIN_STOCK_ID,
											SG.IS_SERI_SONU,
											SC.SUBSCRIPTION_HEAD,
											SC.SUBSCRIPTION_ID,
											SC.START_DATE,
											SC.FINISH_DATE,
											E.EMPLOYEE_NAME,
											E.EMPLOYEE_SURNAME,
											S.STOCK_CODE,
											S.PRODUCT_NAME,
											S.PRODUCT_ID,
											PTR.STAGE
										FROM 
											SERVICE_GUARANTY_NEW SG,
											STOCKS S,
											#DSN_ALIAS#.EMPLOYEES E,
											SUBSCRIPTION_CONTRACT SC,
											#DSN_ALIAS#.PROCESS_TYPE_ROWS PTR
										WHERE 
											PTR.PROCESS_ROW_ID = SC.SUBSCRIPTION_STAGE AND
											SC.SUBSCRIPTION_ID = SG.PROCESS_ID AND
											SG.PROCESS_CAT = 1193 AND
											SG.RECORD_EMP = E.EMPLOYEE_ID AND 
											SG.STOCK_ID = S.STOCK_ID AND 
											SG.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.seri_stock_id#"> AND
											(SG.SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_serial_no#"> OR SG.REFERENCE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_serial_no#"> OR SG.LOT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_serial_no#">)
									</cfquery>
								<cfelse>
									<cfset get_system_serials.recordcount = 0>
								</cfif>
								<cfif get_system_serials.recordcount>
									<cfsavecontent variable="title_message4"><cf_get_lang dictionary_id='32672.Sistem Seri Noları'></cfsavecontent>
									<cf_box style="width:98%;" title="#title_message4#" closable="0">
										<cf_ajax_list>
											<thead>
												<tr>
													<th><cf_get_lang dictionary_id='58820.Başlık'></th>
													<th width="60"><cf_get_lang dictionary_id='57482.Aşama'></th>
													<th><cf_get_lang dictionary_id='57747.Sözleşme Tarihi'></th>
													<th width="100"><cf_get_lang dictionary_id='57748.İptal Tarihi'></th>
													<th width="100"><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
												</tr>
											 </thead>
											 <tbody>
												<cfoutput query="get_system_serials">
													<tr height="20" onmouseover="this.className='color-light';" onmouseout="this.className='color-row';" class="color-row">
														<td><a href="javascript://" onclick="window.opener.location.href='#request.self#?fuseaction=sales.list_subscription_contract&event=upd&subscription_id=#SUBSCRIPTION_ID#';" class="tableyazi">#SUBSCRIPTION_HEAD#</a></td>
														<td>#STAGE#</td>
														<td>#dateformat(start_date,dateformat_style)#</td>
														<td><cfif len(finish_date)>#dateformat(finish_date,dateformat_style)#</cfif></td>
														<td><cfif len(sale_consumer_id)>#get_cons_info(sale_consumer_id,1,1)#
															<cfelseif len(sale_company_id)>#get_par_info(sale_company_id,1,1,1)#
															<cfelseif len(purchase_company_id)>#get_par_info(purchase_company_id,1,1,1)#
															<cfelseif len(purchase_consumer_id)>#get_cons_info(purchase_consumer_id,1,1)#
															</cfif>
														</td>
													</tr>
												</cfoutput>
											 </tbody>
										 </cf_ajax_list>
									 </cf_box>
								</cfif>   
							</cf_box>
							</cfif>
							<cfif isdefined("get_related_results_") and get_related_results_.recordcount>
						<cfsavecontent variable="title_message2"><cf_get_lang dictionary_id ='33769.İlişkili İşlem Satırları'></cfsavecontent>
						<cf_box style="width:98%;" title="#title_message2#" closable="0">
						<table cellpadding="2" cellspacing="1" width="98%" height="100%" align="center" class="color-border">
							<tr class="color-header">
								<td class="form-title" height="22"><cf_get_lang dictionary_id ='33769.İlişkili İşlem Satırları'></td>
							</tr>
							<tr class="color-row">
								<td>
								<table>
								<cfoutput query="get_related_results_">
									<tr>
										<td><b><cf_get_lang dictionary_id='57657.Ürün'>:#PRODUCT_NAME#</b></td>
									</tr>
									<tr>
										<td><b><cf_get_lang dictionary_id='57717.Garanti'> :</b>
											<cfif is_sale eq 1>
												<cf_get_lang dictionary_id='57448.Satış'> <cfset attributes.guarantycat_id = SALE_GUARANTY_CATID>
											<cfelse>
												<cf_get_lang dictionary_id='58176.Alış'> <cfset attributes.guarantycat_id = PURCHASE_GUARANTY_CATID>
											</cfif>
											<cf_get_lang dictionary_id ='33761.Garantisi'> - 
											<cfif isdefined("attributes.guarantycat_id") and len(attributes.guarantycat_id)>
												<cfquery name="GET_GUARANTY_CAT" datasource="#dsn#">
													SELECT * FROM  SETUP_GUARANTY WHERE GUARANTYCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.guarantycat_id#">
												</cfquery>
												#get_guaranty_cat.guarantycat# - #get_guaranty_cat.guarantycat_time# ay
											</cfif>
										</td>
									</tr>
									<tr>
										<td><b><cf_get_lang dictionary_id='58763.Depo'> :</b> #DEPARTMENT_HEAD# - <b><cf_get_lang dictionary_id ='57569.Görevli'> :</b> #employee_name# #employee_surname# - <b><cf_get_lang dictionary_id='57800.İşlem Tipi'> :</b> #get_process_name(process_cat)#</td>
									</tr>
									<tr>
										<td><b><cf_get_lang dictionary_id ='33763.İlgili Firma / Kişi '>:</b> 
											<cfif len(sale_consumer_id)>#get_cons_info(sale_consumer_id,1,1)#
											<cfelseif len(sale_company_id)>#get_par_info(sale_company_id,1,1,1)#
											<cfelseif len(purchase_company_id)>#get_par_info(purchase_company_id,1,1,1)#
											<cfelseif len(purchase_consumer_id)>#get_cons_info(purchase_consumer_id,1,1)#
											</cfif>
										</td>
									</tr>
									<tr>
										<td><b><cf_get_lang dictionary_id ='33764.Son Durum'>:
											<cfif is_purchase eq 1><cf_get_lang dictionary_id ='33765.Alındı'>,</cfif>
											<cfif is_sale eq 1><cf_get_lang dictionary_id ='33766.Satıldı'>,</cfif>
											<cfif in_out eq 1><cf_get_lang dictionary_id ='33237.Satılabilir'>,</cfif>
											<cfif is_return eq 1><cf_get_lang dictionary_id='29418.İade'>,</cfif>
											<cfif is_rma eq 1><cf_get_lang dictionary_id ='33239.Üreticide'>,</cfif>
											<cfif is_service eq 1><cf_get_lang dictionary_id ='33240.Serviste'>,</cfif>
											<cfif is_trash eq 1><cf_get_lang dictionary_id='29471.Fire'>,</cfif>
											<cfif is_seri_sonu eq 1><cf_get_lang dictionary_id ='33767.Seri Sonu'>,</cfif>
											</b>
										</td>
									</tr>
								</cfoutput>
								</table>
								</td>
							</tr>
						</table>
						</cf_box>
					</cfif>	
					<cfif isDefined("attributes.seri_stock_id") and len(attributes.seri_stock_id)>
						<cfsavecontent variable="title_message5"><cf_get_lang dictionary_id='46839.İlişkili Belgeler'></cfsavecontent>
						<cf_box 
							style="width:98%;" 
							title="#title_message5#" 
							closable="0"
							box_page="#request.self#?fuseaction=objects.serial_number_relation&PRODUCT_SERIAL_NO=#attributes.PRODUCT_SERIAL_NO#&SERI_STOCK_ID=#attributes.seri_stock_id#">
						</cf_box>
					<cfelse>
						<cfsavecontent variable="title_message5"><cf_get_lang dictionary_id='46839.İlişkili Belgeler'></cfsavecontent>
						<cf_box 
							style="width:98%;" 
							title="#title_message5#" 
							closable="0"
							box_page="#request.self#?fuseaction=objects.serial_number_relation&PRODUCT_SERIAL_NO=#attributes.PRODUCT_SERIAL_NO#">
						</cf_box>
					</cfif>
					<cfif isDefined("attributes.seri_stock_id") and len(attributes.seri_stock_id)>
					<cfsavecontent variable="title_message6"><cf_get_lang dictionary_id ='32670.Özel ilişkiler'></cfsavecontent>
						<cf_box 
							style="width:100%;" 
							title="#title_message6#" 
							closable="0" 
							add_href="AjaxPageLoad('#request.self#?fuseaction=objects.popup_add_new_specify&stock_id=#attributes.seri_stock_id#&serial_no=#attributes.product_serial_no#' ,'add_specify_','1');"
							box_page="#request.self#?fuseaction=objects.special_relation_ajax&PRODUCT_SERIAL_NO=#attributes.PRODUCT_SERIAL_NO#&SERI_STOCK_ID=#attributes.seri_stock_id#">
						</cf_box>
					</cfif>
					</div>
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="2" sort="true">
						                <!---Seri No Üst İlişkisi --->
			
				<cfif get_search_results_.recordcount>
					<cfquery name="get_alt_products" datasource="#DSN3#">
						SELECT
							SG.*,
							S.PRODUCT_NAME,
							S.PROPERTY
						FROM
							SERVICE_GUARANTY_NEW AS SG,
							STOCKS S
						WHERE
							<cfif len(get_search_results_ilk.process_id)>
								PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_search_results_ilk.process_id#"> AND
							<cfelse>
								PROCESS_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_search_results_ilk.PROCESS_NO#"> AND
							</cfif>
							PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_search_results_ilk.process_cat#"> AND
							(MAIN_STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_search_results_ilk.STOCK_ID#"> <cfif len(get_search_results_ilk.MAIN_STOCK_ID)>OR MAIN_STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_search_results_ilk.MAIN_STOCK_ID#"></cfif>) AND
							SG.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
							S.STOCK_ID = SG.STOCK_ID
							<cfif isdefined("attributes.is_store")>
								AND 
								(
								SG.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)
								)
							</cfif>
					</cfquery>
					<cfif len(get_search_results_ilk.MAIN_STOCK_ID)>
						<cfquery name="get_ust_products" datasource="#DSN3#">
							SELECT
								SG.*,
								S.PRODUCT_NAME,
								S.PROPERTY
							FROM
								SERVICE_GUARANTY_NEW AS SG,
								STOCKS S
							WHERE
								PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_search_results_ilk.process_id#"> AND
								PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_search_results_ilk.process_cat#"> AND
								SG.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_search_results_ilk.MAIN_STOCK_ID#"> AND
								SG.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
								S.STOCK_ID = SG.STOCK_ID
						</cfquery>
					<cfelse>
						<cfset get_ust_products.recordcount = 0>
					</cfif>
					<cfif get_alt_products.recordcount or get_ust_products.recordcount>
						<cfsavecontent variable="title_message5"><cf_get_lang dictionary_id ='33223.İlişkili Ürünler'></cfsavecontent>
						<cf_box style="width:98%;" title="#title_message5#" closable="0">
                            <cf_ajax_list>
                                <thead>
                                    <tr>
                                        <th><cf_get_lang dictionary_id ='57657.Ürün'></th>
                                        <th><cf_get_lang dictionary_id ='33770.Seriler'></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <cfif get_ust_products.recordcount>
                                        <cfoutput query="get_ust_products" group="STOCK_ID">
                                        <cfif len(SERIAL_NO)>
                                        	<cfset seri_no_ = SERIAL_NO>
                                        <cfelseif len(lot_no) and not len(SERIAL_NO)>
                                        	<cfset seri_no_ = lot_no>
                                        </cfif>
                                            <tr>
                                                <td nowrap>#PRODUCT_NAME##PROPERTY#</td>
                                                <td width="100%"><cfoutput><a href="#request.self#?fuseaction=objects.dsp_serial_number_result&product_serial_no=#seri_no_#" class="tableyazi">#seri_no_#</a>,</cfoutput></td>
                                            </tr>
                                        </cfoutput>
                                    </cfif>
                                    <cfif get_alt_products.recordcount>
                                        <cfoutput query="get_alt_products" group="STOCK_ID">
                                        <cfif len(SERIAL_NO)>
                                        	<cfset seri_no_ = SERIAL_NO>
                                        <cfelseif len(lot_no) and not len(SERIAL_NO)>
                                        	<cfset seri_no_ = lot_no>
                                        </cfif>
                                            <tr>
                                                <td nowrap>#PRODUCT_NAME##PROPERTY#</td>
                                                <td width="100%"><cfoutput><a href="#request.self#?fuseaction=objects.dsp_serial_number_result&product_serial_no=#seri_no_#" class="tableyazi">#seri_no_#</a>,</cfoutput></td>
                                            </tr>
                                        </cfoutput>
                                    </cfif>
                                </tbody>
                            </cf_ajax_list>
						</cf_box>
					</cfif>
				</cfif>
			</cfif>
	
        <cfif get_search_results_.recordcount and isdefined("attributes.product_serial_no") and len(attributes.product_serial_no) and (isdefined("attributes.seri_stock_id") or isdefined("attributes.only_service"))>
		
			
                        <cfif isdefined("attributes.seri_stock_id")>
                            <cf_get_workcube_asset id="box_1" company_id="#session.ep.company_id#" asset_cat_id='-5' module_id='14' action_section='GUARANTY_SERIAL_NO' action_type='1' action_id='#attributes.product_serial_no#' action_id_2='#attributes.seri_stock_id#'>
                            <cf_get_workcube_note company_id="#session.ep.company_id#" style="1" action_section='GUARANTY_SERIAL_NO' action_id='#attributes.product_serial_no#' action_type='1' action_id_2='#attributes.seri_stock_id#'>
                            <cf_get_workcube_asset id="box_2" company_id="#session.ep.company_id#" asset_cat_id='-5' module_id='14' action_section='GUARANTY_SERIAL_NO' action_type='1' action_id='#attributes.product_serial_no#' is_image='1' action_id_2='#attributes.seri_stock_id#'>
                            
                           
                            <div id="add_specify_"></div>
                        <cfelse>
                            <cf_get_workcube_asset id="box_1" company_id="#session.ep.company_id#" asset_cat_id='-5' module_id='14' action_section='GUARANTY_SERIAL_NO' action_type='1' action_id='#attributes.product_serial_no#'>
                            <br/>
                            <cf_get_workcube_note company_id="#session.ep.company_id#" style="1" action_section='GUARANTY_SERIAL_NO' action_id='#attributes.product_serial_no#' action_type='1'>
                            <br/>
                            <cf_get_workcube_asset id="box_2" company_id="#session.ep.company_id#" asset_cat_id='-5' module_id='14' action_section='GUARANTY_SERIAL_NO' action_type='1' action_id='#attributes.product_serial_no#' is_image='1'>
                        </cfif>
                    
		</cfif>
	</div>
</cfif>

<script type="text/javascript">
		$(document).ready(function() {
			$('#product_serial_no').focus();
		});
	function open_add_specify_(serial_no,stock_id)
	{
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_new_specify&stock_id='+stock_id+'&serial_no='+serial_no ,'add_specify_','1');
	}
	function open_update_specify(guaranty_id,serial_no,stock_id)
	{ 
		AjaxPageLoad( '<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_upd_specify_settings&guaranty_id='+guaranty_id+'&serial_no='+serial_no+'&stock_id='+stock_id ,'add_specify_','1');
	}
</script>
