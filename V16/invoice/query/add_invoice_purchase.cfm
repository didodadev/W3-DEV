<!--- sayfada abort veya alert gibi işlemler yapılacağı zaman xml import dosyalarıda göz önüne alınmalı bu sayfalar onlardada kullanılıyor --->
<cf_get_lang_set module_name="invoice"> <!--- sayfanin en altinda kapanisi var --->
<cfif not isdefined('xml_import')>
	<cfinclude template="check_our_period.cfm"><!--- islem yapilan donem session dakine uygun mu? --->
</cfif>

<!--- sorun olusuyor diye hem attributes hemde form olarak atandi --->
<cfif not isdefined("form.invoice_number")>
	<cfif isdefined('form.serial_number') and len(form.serial_number)>
		<cfset form.invoice_number = "#form.serial_number#-#form.serial_no#">
		<cfset attributes.invoice_number = "#form.serial_number#-#form.serial_no#">
	<cfelse>
		<cfset form.invoice_number = "#form.serial_no#">
		<cfset attributes.invoice_number = "#form.serial_no#">
	</cfif>
</cfif>
<!--- Burada kullanilmayan cari hesap degerleri bosaltilmazsa carici ve muhasebeciye yanlis kayitlar olusturuyor, FBS 20120322 --->
<cfif (isDefined("attributes.company_id") and Len(attributes.company_id) and isDefined("attributes.comp_name") and Len(attributes.comp_name))>
	<cfset attributes.company_id = attributes.company_id>
	<cfset attributes.consumer_id = "">
	<cfset attributes.employee_id = "">
<cfelseif (isDefined("attributes.consumer_id") and Len(attributes.consumer_id))>
	<cfset attributes.company_id = "">
	<cfset attributes.consumer_id = attributes.consumer_id>
	<cfset attributes.employee_id = "">
<cfelse>
	<cfset attributes.company_id = "">
	<cfset attributes.consumer_id = "">
	<cfset attributes.employee_id = attributes.employee_id>
</cfif>

<cfif not isdefined("new_comp_id")><cfset new_comp_id = session.ep.company_id></cfif>
<cfif not isdefined("new_dsn3_group")><cfset new_dsn3_group = dsn3></cfif>
<cfif not isdefined("new_dsn2_group")><cfset new_dsn2_group = dsn2></cfif>
<cfif not isdefined("new_period_id")><cfset new_period_id = session.ep.period_id></cfif>
<cfinclude template="add_invoice_purchase_1.cfm"><!--- kontrollerin yapildigi sayfa : ayni fatura no dan varmi urun secilmis mi? --->
<cfif not isdefined('error_flag') or error_flag eq 0 or isdefined("is_from_function")><!--- xml import değil yada xml import için hata oluşmadı ise --->
	<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
	<cflock name="#CreateUUID()#" timeout="20">
		<cftransaction>
			<!--- Include dosyalarinda datasource ismi DSN2 olucak sekilde alias la baska dsn leri yazin. --->
			<!--- fatura tablosuna kayit ekleme islemi yapiliyor. --->
			<cfinclude template="add_invoice_purchase_2.cfm">
			<!--- cari ve muhasebe islemleri yapiliyor. --->
			<cfinclude template="add_invoice_purchase_3.cfm">
			<!--- kasa cari ve muhasebe islemlerini yapiyor. --->
			<cfinclude template="add_invoice_purchase_4.cfm">
			<!--- irsaliyeli fatura ise irsaliye guncelleme ve eklemelerini yapiyor. --->
			<cfinclude template="add_invoice_purchase_5.cfm">
			<cfscript>basket_kur_ekle(action_id:get_invoice_id.max_id,table_type_id:1,process_type:0,basket_money_db:new_dsn2_group);</cfscript>
			<cfif not isdefined('xml_import')>
				<cfif isdefined("attributes.contract_row_ids") and len(attributes.contract_row_ids)>
					<cfquery name="upd_control_bill" datasource="#new_dsn2_group#">
						UPDATE
							INVOICE_CONTRACT_COMPARISON
						SET
							DIFF_INVOICE_ID = #get_invoice_id.max_id#
						WHERE
							CONTRACT_COMPARISON_ROW_ID IN (SELECT RELATED_ACTION_ID FROM INVOICE_ROW WHERE INVOICE_ID = #get_invoice_id.max_id# AND RELATED_ACTION_TABLE='INVOICE_CONTRACT_COMPARISON')
					</cfquery>
				<cfelseif isdefined("attributes.bool_from_control_bill") or (isdefined("attributes.invoice_control_id") and len(attributes.invoice_control_id))>
					<cfquery name="upd_control_bill" datasource="#new_dsn2_group#">
						UPDATE
							INVOICE_CONTROL
						SET
							CONTROL_INVOICE_ID = #get_invoice_id.max_id#,
							IS_BILLED = 1
						WHERE
						  <cfif len(attributes.bool_from_control_bill)>
							INVOICE_ID = #attributes.bool_from_control_bill#
						  <cfelse>
							INVOICE_CONTROL_ID IN (#attributes.invoice_control_id#)
						  </cfif>
					</cfquery>
				</cfif>
			</cfif>

            <!--- E-Fatura Onay islemi--->
            <cfinclude template="../../e_government/query/einvoice_approval.cfm" />

			<cfif isdefined("attributes.is_asset_transfer") and attributes.is_asset_transfer eq 1>
				<cfif isDefined("attributes.order_id") and len(attributes.order_id)>
					<cfquery name="upd_assets" datasource="#new_dsn2_group#">
						UPDATE
							#dsn_alias#.ASSET
						SET
							ACTION_SECTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="INVOICE_ID">,
							ACTION_ID = #get_invoice_id.max_id#,
							COMPANY_ID = #session.ep.company_id#,
							PERIOD_ID = #session.ep.period_id#,
							UPDATE_EMP = #session.ep.userid#,
							UPDATE_DATE = #now()#,
							UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">
						WHERE
							ACTION_SECTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="ORDER_ID"> AND
							ACTION_ID = #attributes.order_id#
					</cfquery>
				</cfif>
			</cfif>			

			<cf_workcube_process_cat 
				process_cat="#form.process_cat#"
				action_db_type = "#new_dsn2_group#"
				action_id = "#get_invoice_id.max_id#"
				action_table="INVOICE"
				action_column="INVOICE_ID"
				is_action_file = "1"
				action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_bill_purchase&event=upd&iid=#get_invoice_id.max_id#'
				action_file_name='#get_process_type.action_file_name#'
				is_template_action_file = '#get_process_type.action_file_from_template#'>
			<cfif isdefined("attributes.consumer_reference_code") and len(attributes.consumer_reference_code)>
				<cfquery name="add_multilevel_sales" datasource="#new_dsn2_group#">
					add_multilevel_sales
						#get_invoice_id.max_id#
				</cfquery>
				<cfquery name="add_multilevel_premium" datasource="#new_dsn2_group#">
					add_multilevel_premium
						#get_invoice_id.max_id#
				</cfquery>
			</cfif>
			<cfset last_invoice_id_pur = get_invoice_id.max_id>
			<cfif not isdefined("first_invoice_id_pur")>
				<cfset first_invoice_id_pur = get_invoice_id.max_id>
			</cfif>
            <cf_add_log employee_id="#session.ep.userid#" log_type="1" action_id="#get_invoice_id.max_id#" action_name="#form.invoice_number# Eklendi" paper_no="#form.invoice_number#" period_id="#session.ep.period_id#"  process_type="#INVOICE_CAT#" data_source="#new_dsn2_group#">
		</cftransaction>
	</cflock>
	<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
		<cf_workcube_process 
				is_upd='1' 
				data_source='#new_dsn2_group#' 
				old_process_line='0'
				process_stage='#attributes.process_stage#' 
				record_member='#session.ep.userid#' 
				record_date='#now()#'
				action_table='INVOICE'
				action_column='INVOICE_ID'
				action_id='#get_invoice_id.max_id#'
				action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_bill_purchase&event=upd&iid=#get_invoice_id.max_id#'
				warning_description="#getLang('','Fatura',57441)# : #form.invoice_number#">
	</cfif>
</cfif>
<!---Ek Bilgiler--->
<cfset attributes.info_id = max_id.IDENTITYCOL>
<cfset attributes.is_upd = 0>
<cfset attributes.info_type_id = -8>
<cfinclude template="../../objects/query/add_info_plus2.cfm">
<!---Ek Bilgiler--->
<cfif isdefined('xml_import') or (isdefined("xml_import") and xml_import neq 2)>
	<cfset last_xml_import_pur = xml_import>
<cfelseif not isdefined("xml_import")>
	<!--- Grup İçi işlemler için fonksiyon çağırıyoruz --->
	<cfscript>
		add_company_related_action(action_id:last_invoice_id_pur,action_type:4);
	</cfscript>
</cfif>

<cfif isdefined("attributes.receiving_detail_id") and len(attributes.receiving_detail_id)>
	<script type="text/javascript">
		wrk_opener_reload();
	</script>
</cfif>
<cfif not(isdefined('xml_import') and xml_import eq 2)>
	<cfif session.ep.our_company_info.is_cost eq 1 and get_process_type.is_cost eq 1><!--- sirket maliyet takip ediliyorsa not js le yonlenioyr cunku cost_action locationda calismiyor --->
		<cfscript>cost_action(action_type:1,action_id:first_invoice_id_pur,query_type:1);</cfscript>
		<script type="text/javascript">
			window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_bill_purchase&event=upd&iid=#first_invoice_id_pur#</cfoutput>";
		</script>
	<cfelse>
		<script type="text/javascript">
			window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_bill_purchase&event=upd&iid=#first_invoice_id_pur#</cfoutput>";
		</script>
	</cfif>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
