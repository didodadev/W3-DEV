<cfset row_list = ''>
<cfset last_row = false>
<!--- <cfset control_ = 0> --->

<!--- <cfset my_satir_ = 0> --->
<!---
	<cfset gelen_ = 0>
<cfloop from="1" to="#attributes.all_records#" index="ccc">
	<cfif isdefined("attributes.payment_row#ccc#")>
		<cfset gelen_ = gelen_ + 1>
	</cfif>
</cfloop>
--->
<cfquery name="get_taxes" datasource="#dsn2#">
	SELECT * FROM SETUP_TAX
</cfquery>
<cfquery name="get_otv" datasource="#dsn2#">
	SELECT OTV_ID,TAX,ACCOUNT_CODE FROM #dsn3_alias#.SETUP_OTV WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# ORDER BY TAX
</cfquery>
<cfquery name="get_bsmv" datasource="#dsn2#">
	SELECT BSMV_ID,TAX,ACCOUNT_CODE FROM #dsn3_alias#.SETUP_BSMV WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# ORDER BY TAX
</cfquery>
<cfquery name="get_oiv" datasource="#dsn2#">
	SELECT OIV_ID,TAX,ACCOUNT_CODE FROM #dsn3_alias#.SETUP_OIV WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# ORDER BY TAX
</cfquery>

<cfset paymethod_comp = createObject("component","cfc.paymethod_calc")>

<cfloop from="1" to="#attributes.all_records#" index="i">
	<cfif isdefined("attributes.payment_row#i#")><!--- and my_satir_ lt 20 --->
		<cfscript>
			//fatura şirketine göre gruplama
			sub_id_ = evaluate("attributes.row_subscription_id#i#");
			comp_id_ = evaluate("attributes.row_company_id#i#");
			cons_id_ = evaluate("attributes.row_consumer_id#i#");
			partner_id_ = evaluate("attributes.row_partner_id#i#");
			/*project_id_ = evaluate("attributes.row_project_id#i#");
			stock_id_ = evaluate("attributes.stock_id#i#");
			product_name_ = evaluate("attributes.product_name#i#");
			money_type_ = evaluate("attributes.money_type#i#");
			unit_id_ = evaluate("attributes.unit_id#i#");
			discount_ = evaluate("attributes.discount#i#");
			amount_ = evaluate("attributes.amount#i#");*/
			//if (isDefined("is_avg_price")){//ortalama fiyat hesaplamasın seçeneği
				if(isdefined("attributes.multi_sale_grup") and attributes.multi_sale_grup eq 1){
					uniq_row_ = '#comp_id_#.#cons_id_#.#partner_id_#.#sub_id_#';
				}else{
					uniq_row_ = '#comp_id_#.#cons_id_#.#partner_id_#';
				}
			uniq_row_2 = '';
			if(not len(row_list)){
				row_list = listappend(row_list,evaluate("attributes.payment_row#i#"));
			}

			sub_id_2 = "";
			comp_id_2 = "";
			cons_id_2 = "";
			partner_id_2 = "";
		</cfscript>
		
		<cfloop from="#i+1#" to="#attributes.all_records#" index="j">
			<cfif isdefined("attributes.payment_row#j#")>
				<cfscript>				
						sub_id_2 = evaluate("attributes.row_subscription_id#j#");
						comp_id_2 = evaluate("attributes.row_company_id#j#");
						cons_id_2 = evaluate("attributes.row_consumer_id#j#");
						partner_id_2 = evaluate("attributes.row_partner_id#j#");

						if(isdefined("attributes.multi_sale_grup") and attributes.multi_sale_grup eq 1){
							uniq_row_2 = '#comp_id_2#.#cons_id_2#.#partner_id_2#.#sub_id_2#';
						}else{
							uniq_row_2 = '#comp_id_2#.#cons_id_2#.#partner_id_2#';
						}
				</cfscript>
				<cfif uniq_row_ eq uniq_row_2><!--- fatura keslecek aynı kuruma ait sonraki satır bulunuyor --->
					<cfbreak>
				</cfif>
			</cfif>
		</cfloop>
		<cfif i gte attributes.all_records>
			<!--- formdan gelen alan satır sayısı tamamlandı ise bitiş flag değeri --->
			<cfset last_row = true>
		</cfif>
		<cfscript>
			if(isdefined("attributes.multi_sale_grup") and attributes.multi_sale_grup eq 1){
				uniq_row_2 = '#comp_id_2#.#cons_id_2#.#partner_id_2#.#sub_id_2#';
			}else{
				uniq_row_2 = '#comp_id_2#.#cons_id_2#.#partner_id_2#';
			}
		</cfscript>

		
		<cfset row_list = listappend(row_list,evaluate("attributes.payment_row#i#"))>

		<!---<cfif ((my_satir_ eq 20 or i eq attributes.all_records) and uniq_row_ neq uniq_row_2) or control_ eq gelen_> bu kontrol neden var??? FA--->
		<!---<cfif (i eq attributes.all_records) or control_ eq gelen_>--->
		<cfif uniq_row_ neq uniq_row_2 or last_row><!---farklı bir cari yada aboneye geçti ise fatura oluşacak--->
			
			<!--- fatura vs kayıtları --->
			<cfquery name="GET_BILLED_INFO" datasource="#dsn3#">
				SELECT 
					SUBSCRIPTION_PAYMENT_PLAN_ROW.IS_BILLED,
					SUBSCRIPTION_PAYMENT_PLAN_ROW.MONEY_TYPE,
					<cfif xml_other_money eq 1>
						SUBSCRIPTION_PAYMENT_PLAN_ROW.MONEY_TYPE MONEY_TYPE_
					<cfelseif xml_other_money eq 2>
						'#session.ep.money#' MONEY_TYPE_
					<cfelseif xml_other_money eq 4>
						'#attributes.select_money_type#' MONEY_TYPE_
					<cfelse>
						CASE WHEN SC.INVOICE_COMPANY_ID IS NOT NULL THEN
							(SELECT CC.MONEY FROM #dsn_alias#.COMPANY_CREDIT CC WHERE CC.COMPANY_ID = SC.INVOICE_COMPANY_ID AND CC.OUR_COMPANY_ID = #session.ep.company_id#)
						ELSE
							(SELECT CC.MONEY FROM #dsn_alias#.COMPANY_CREDIT CC WHERE CC.CONSUMER_ID = SC.INVOICE_CONSUMER_ID AND CC.OUR_COMPANY_ID = #session.ep.company_id#)
						END AS MONEY_TYPE_
					</cfif>,
					SC.SUBSCRIPTION_ID,
					SC.CONSUMER_ID,
					SC.PARTNER_ID,
					SC.COMPANY_ID,
					SC.SUBSCRIPTION_NO,
					SC.INVOICE_COMPANY_ID,
					SC.INVOICE_PARTNER_ID,
					SC.INVOICE_CONSUMER_ID,
					SC.SALES_EMP_ID,
					SC.INVOICE_ADDRESS,
					SC.INVOICE_ADDRESS_ID,
					SCCOUNTRY.COUNTRY_NAME,
					SCCITY.CITY_NAME,
					SCCOUNTY.COUNTY_NAME,
					S.IS_INVENTORY,
					ISNULL(SUBSCRIPTION_PAYMENT_PLAN_ROW.PAYMETHOD_ID,SC.PAYMENT_TYPE_ID) AS PAYMETHOD_ID,
					
					<cfif isdefined("attributes.multi_sale_grup") and len(attributes.multi_sale_grup) eq 1>
						<!--- toplu faturalama abone bazında gruplama ise aboneden bilgiler alınır ve faturaya onlar yansıtılır --->
						SC.SUBSCRIPTION_INVOICE_DETAIL,
						SC.SALES_COMPANY_ID, 
						SC.SALES_PARTNER_ID, 
						SC.SALES_CONSUMER_ID,
						SC.PROJECT_ID
					<cfelse>
						NULL SUBSCRIPTION_INVOICE_DETAIL,
						NULL SALES_COMPANY_ID, 
						NULL SALES_PARTNER_ID, 
						NULL SALES_CONSUMER_ID,
						NULL PROJECT_ID
					</cfif>
				FROM 
					SUBSCRIPTION_PAYMENT_PLAN_ROW 
					RIGHT JOIN #dsn3_alias#.SUBSCRIPTION_CONTRACT SC ON SUBSCRIPTION_PAYMENT_PLAN_ROW.SUBSCRIPTION_ID = SC.SUBSCRIPTION_ID
					LEFT JOIN #dsn#.SETUP_COUNTRY SCCOUNTRY ON SC.INVOICE_COUNTRY_ID = SCCOUNTRY.COUNTRY_ID
					LEFT JOIN #dsn#.SETUP_COUNTY SCCOUNTY ON SC.INVOICE_COUNTY_ID = SCCOUNTY.COUNTY_ID
					LEFT JOIN #dsn#.SETUP_CITY SCCITY ON SC.INVOICE_CITY_ID = SCCITY.CITY_ID
					RIGHT JOIN #dsn3_alias#.STOCKS S ON SUBSCRIPTION_PAYMENT_PLAN_ROW.PRODUCT_ID = S.PRODUCT_ID AND SUBSCRIPTION_PAYMENT_PLAN_ROW.STOCK_ID = S.STOCK_ID
				WHERE IS_BILLED = 0 AND SUBSCRIPTION_PAYMENT_ROW_ID IN (#row_list#)
			</cfquery>
			<cfif GET_BILLED_INFO.recordcount>
				<cflock name="#CreateUUID()#" timeout="20">
					<cftransaction>
						<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*10000)>
						<cfset attributes.invoice_number = wrk_id>
						<cfset attributes.serial_number = wrk_id>
						<cfset kontrol_number = 0> 
						<cfif attributes.xml_paper_no_info><!--- standart belge numaralarından fatura no oluşturma xmli --->
							<cfif isdefined("attributes.form_is_einvoice") and attributes.form_is_einvoice eq 1>
								<cfset paper_type = 'E_INVOICE'>
							<cfelseif isdefined("attributes.form_is_einvoice") and attributes.form_is_einvoice eq 2>
								<cfset paper_type = 'RECEIPT'>
							<cfelse>
								<cfset paper_type = 'INVOICE'>
							</cfif>
							<cfif paper_type eq 'RECEIPT'>
								<cfquery name="get_paper" datasource="#dsn2#">
									SELECT RECEIPT_NO,RECEIPT_NUMBER FROM #dsn3_alias#.GENERAL_PAPERS WHERE PAPER_TYPE IS NULL 
								</cfquery>
							<cfelse>
								<cfquery name="get_paper" datasource="#dsn2#">
									SELECT * FROM #dsn3_alias#.PAPERS_NO WHERE EMPLOYEE_ID = #session.ep.userid# ORDER BY PAPER_ID DESC 
								</cfquery>
								<cfif not len(evaluate('get_paper.#paper_type#_NO')) and not len(evaluate('get_paper.#paper_type#_NUMBER'))>
									<!--- irsaliye noları ile de gerekirse bir düzenleme yapılmalıdır.. --->
									<cfquery name="get_paper" datasource="#dsn2#">
										SELECT
											*
										FROM
											#dsn3_alias#.PAPERS_NO PN,
											#dsn_alias#.SETUP_PRINTER_USERS SPU
										WHERE
											PN.PRINTER_ID = SPU.PRINTER_ID AND
											SPU.PRINTER_EMP_ID = #session.ep.userid#
										ORDER BY
											PAPER_ID DESC 
									</cfquery>
									<cfset from_printer_info = get_paper.PRINTER_ID>
								</cfif>
							</cfif>
							<cfif len(evaluate('get_paper.#paper_type#_NO')) and len(evaluate('get_paper.#paper_type#_NUMBER'))>
								<cfset attributes.serial_number = "#evaluate('get_paper.#paper_type#_NO')#">
								<cfset attributes.serial_no = "#evaluate('get_paper.#paper_type#_NUMBER')+1#">
								<cfset attributes.invoice_number = "#evaluate('get_paper.#paper_type#_NO')#-#evaluate('get_paper.#paper_type#_NUMBER')+1#">
								<cfset paper_no_info = evaluate('get_paper.#paper_type#_NUMBER')+1>
							<cfelse>
								<cfset attributes.serial_number = wrk_id>
								<cfset attributes.serial_no = wrk_id>
								<cfset attributes.invoice_number = wrk_id>
							</cfif>
						<cfelse>
							<cfset attributes.serial_number = wrk_id>
							<cfset attributes.serial_no = wrk_id>
							<cfset attributes.invoice_number = wrk_id>
						</cfif>
						

						<cfquery name="GET_SALE" datasource="#dsn2#">
							SELECT INVOICE_NUMBER,PURCHASE_SALES FROM INVOICE WHERE PURCHASE_SALES = 1 AND INVOICE_NUMBER='#attributes.invoice_number#'
						</cfquery>
						<cfif get_sale.recordcount>
							<cf_get_lang dictionary_id='57036.Girdiğiniz Fatura Numarası Kullanılıyor !'> : <cfoutput>#attributes.invoice_number# , Abone No : #GET_BILLED_INFO.SUBSCRIPTION_NO#</cfoutput><br/>
						<cfelse>
					
							<cfif len(GET_BILLED_INFO.INVOICE_COMPANY_ID)>
								<cfset invoice_comp_id = GET_BILLED_INFO.INVOICE_COMPANY_ID>
							<cfelse>
								<cfset invoice_comp_id = "">
							</cfif>
							<cfif len(GET_BILLED_INFO.INVOICE_PARTNER_ID)>
								<cfset invoice_part_id = GET_BILLED_INFO.INVOICE_PARTNER_ID>
							<cfelse>
								<cfset invoice_part_id = "">
							</cfif>
							<cfif len(GET_BILLED_INFO.INVOICE_CONSUMER_ID)>
								<cfset invoice_cons_id = GET_BILLED_INFO.INVOICE_CONSUMER_ID>
							<cfelse>
								<cfset invoice_cons_id = "">
							</cfif>

							<cfinclude template="add_group_invoice_1.cfm">
							
							<cfinclude template="add_group_invoice_2.cfm">		
							<!--- cari islemler ve muhasebe islemleri ekleniyor. --->
							<cfinclude template="add_group_invoice_3.cfm">
							<cfquery name="UPD_PAYMENT_ROWS" datasource="#dsn2#">
								UPDATE
									#dsn3_alias#.SUBSCRIPTION_PAYMENT_PLAN_ROW
								SET
									IS_BILLED = 1,
									INVOICE_ID = #GET_INVOICE_ID.MAX_ID#,
									PERIOD_ID = #session.ep.period_id#,
									UPDATE_DATE = #now()#,
									UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
									UPDATE_EMP = #session.ep.userid#
								WHERE
									SUBSCRIPTION_PAYMENT_ROW_ID IN (#row_list#)
							</cfquery>
							
							<cfif attributes.xml_paper_no_info and isDefined("paper_no_info")><!--- standart belge numaralarından fatura no oluşturma xml i --->
								<cfif isdefined("attributes.form_is_einvoice") and attributes.form_is_einvoice eq 2>
									<!--- dekont ise genel belge numaralarından güncelle --->
									<cfquery name="UPD_PAPERS" datasource="#dsn2#">
										UPDATE 
											#dsn3_alias#.GENERAL_PAPERS
										SET 
											#paper_type#_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#paper_no_info#">
										WHERE
											PAPER_TYPE IS NULL
									</cfquery>
								<cfelse>
									<cfquery name="UPD_PAPERS" datasource="#dsn2#">
										UPDATE 
											#dsn3_alias#.PAPERS_NO 
										SET 
											INVOICE_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#paper_no_info#">
										WHERE
										<cfif isdefined('from_printer_info') and len(from_printer_info)>
											PRINTER_ID = #from_printer_info#
										<cfelse>
											EMPLOYEE_ID = #session.ep.userid#
										</cfif>
									</cfquery>
								</cfif>
							</cfif>   
							<!--- action file --->
							<cf_workcube_process_cat 
								process_cat="#form.process_cat#"
								action_id = #get_invoice_id.max_id#
								is_action_file = 1
								action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.detail_invoice_sale&iid=#get_invoice_id.max_id#'
								action_file_name='#get_process_type.action_file_name#'
								action_db_type = '#dsn2#'
								is_template_action_file = '#get_process_type.action_file_from_template#'>    
						</cfif>                 
					</cftransaction>
				</cflock>
				<cfoutput>#attributes.invoice_number#</cfoutput> Nolu Fatura Oluşturulmuştur!<br/>
				<cfset row_list = ''>
			</cfif>
		</cfif>
	</cfif>
</cfloop>

