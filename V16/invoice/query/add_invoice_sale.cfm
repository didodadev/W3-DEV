<!--- sayfada abort veya alert gibi işlemler yapılacağı zaman xml import dosyalarıda göz önüne alınmalı bu sayfalar onlardada kullanılıyor --->
<cf_get_lang_set module_name="invoice"><!--- sayfanin en altinda kapanisi var --->
<cfif not isdefined('xml_import')>
	<cfinclude template="check_our_period.cfm"><!--- islem yapilan donem session dakine uygun mu? --->
</cfif>

<cfif not isdefined("new_dsn2_group")><cfset new_dsn2_group = dsn2></cfif>
<cfif not isdefined("new_dsn3_group")><cfset new_dsn3_group = dsn3></cfif>
<cfif not isdefined("new_period_id")>
	<cfif isDefined('session.ep.userid')>
		<cfset new_period_id = session.ep.period_id>
	<cfelseif isDefined('session.pp.userid')>
		<cfset new_period_id = session.pp.period_id>    
	<cfelseif isDefined('session.ww.userid')>
		<cfset new_period_id = session.ww.period_id>
	</cfif>    
</cfif>
<cfif not isdefined("form.invoice_number")>
	<cfif isdefined('form.serial_number') and len(form.serial_number)>
		<cfset form.invoice_number = "#form.serial_number#-#form.serial_no#">
	<cfelse>
		<cfset form.invoice_number = "#form.serial_no#">
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
<cfinclude template="add_invoice_sale_1.cfm"><!--- kontrollerin yapildigi sayfadir : ayni fatura no dan varmi urun secilmis mi? --->
<cfif not isdefined('error_flag') or isdefined("is_from_function") or error_flag eq 0><!--- xml import değil yada xml import için hata oluşmadı ise --->
	<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session_base.userid#_'&round(rand()*100)>
	<cflock name="#CreateUUID()#" timeout="60">
		<cftransaction>
			<!--- Include dosyalarinda datasource ismi DSN2 olucak sekilde alias la baska dsn leri yazin. --->		
			<!---  fatura ekle Fatura tablosuna kayit ekleme islemi yapiliyor. --->
			<cfinclude template="add_invoice_sale_2.cfm">		
			<!--- cari islemler ve muhasebe islemleri ekleniyor. --->
			<cfinclude template="add_invoice_sale_3.cfm">	
			<!--- kasa cari ve muhasebe islemlerini yapiyor. --->
			<cfinclude template="add_invoice_sale_4.cfm">
			<!--- ship eger irsaliyeli fatura ise irsaliye guncelleme ve eklemelerini yapiyor.--->
			<cfinclude template="add_invoice_sale_5.cfm">
			<!--- BK20051229 Sistem sayac okuma veya odeme planından fatura eklemeye gelirken kullaniliyor --->
			<cfif isDefined('attributes.subscription_id') and len(attributes.subscription_id)>			
				<cfinclude template="add_invoice_sale_6.cfm">
			</cfif>
			<!--- dbs tablosuna kayit atiliyor --->
			<cfif isdefined("attributes.paymethod") and len(attributes.paymethod) and len(attributes.paymethod_id)>
				<cfquery name="get_payment_vehicle" datasource="#new_dsn2_group#">
					SELECT PAYMENT_VEHICLE FROM #dsn_alias#.SETUP_PAYMETHOD WHERE PAYMETHOD_ID = #attributes.paymethod_id#
				</cfquery>
				<cfif get_payment_vehicle.recordcount and get_payment_vehicle.payment_vehicle eq 8>
					<cfinclude template="add_invoice_sale_7.cfm">
				</cfif>
			</cfif>
			<!--- begin: ihracat kayıtlı işlemler --->
			<cfif isDefined("is_export_registered") and is_export_registered eq 1>
				<cfquery name="query_export_registered_update" datasource="#new_dsn2_group#">
					UPDATE INVOICE SET IS_EXPORT_REGISTRATION = 1 WHERE INVOICE_ID = #get_invoice_id.max_id#
				</cfquery>
			</cfif>
			<cfif isDefined("is_export_product") and is_export_product eq 1>
				<cfquery name="query_export_product_update" datasource="#new_dsn2_group#">
					UPDATE INVOICE SET IS_EXPORT_PRODUCT = 1 WHERE INVOICE_ID = #get_invoice_id.max_id#
				</cfquery>
			</cfif>
			<!--- end: ihracat kayıtlı işlemler --->
			<cfif not isdefined('xml_import')>
				<cfif isdefined("attributes.contract_row_ids") and len(attributes.contract_row_ids)>
					<cfquery name="upd_control_bill" datasource="#new_dsn2_group#">
						UPDATE
							INVOICE_CONTRACT_COMPARISON
						SET
							DIFF_INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice_id.max_id#">
						WHERE
							CONTRACT_COMPARISON_ROW_ID IN (SELECT RELATED_ACTION_ID FROM INVOICE_ROW WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice_id.max_id#"> AND RELATED_ACTION_TABLE='INVOICE_CONTRACT_COMPARISON')
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
			<cfif isdefined("attributes.assetp_service_operation_id") and len(attributes.assetp_service_operation_id)>
				<cfquery name="upd_assetp_rows" datasource="#new_dsn2_group#">
					UPDATE
						#dsn_alias#.ASSET_P_SERVICE_OPERATION
					SET
						IS_OUT = 1,
						OUT_INVOICE_ID = #get_invoice_id.max_id#,
						OUT_INVOICE_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.INVOICE_NUMBER#">,
						OUT_INVOICE_PERIOD = #session.ep.period_id#,
						UPDATE_DATE = #now()#,
						UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
						UPDATE_MEMBER = #session.ep.userid#
					WHERE
						SERVICE_OPE_ID IN (#attributes.assetp_service_operation_id#)
				</cfquery>
			</cfif>
			<cfscript>basket_kur_ekle(action_id:get_invoice_id.max_id,table_type_id:1,process_type:0,basket_money_db:new_dsn2_group);</cfscript>
			<cf_workcube_process_cat 
				process_cat="#form.process_cat#"
				action_id = "#get_invoice_id.max_id#"
				action_table="INVOICE"
				action_column="INVOICE_ID"
				is_action_file = "1"
				action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_bill&event=upd&iid=#get_invoice_id.max_id#'
				action_file_name='#get_process_type.action_file_name#'
				action_db_type = "#new_dsn2_group#"
				is_template_action_file = '#get_process_type.action_file_from_template#'>
			<!--- Referans üyelere satış yazılıyor --->
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
			<cfset last_invoice_id_sale = get_invoice_id.max_id>
			<cfif not isdefined("first_invoice_id")>
				<cfset first_invoice_id = get_invoice_id.max_id>
			</cfif>
             <cf_add_log employee_id="#session.ep.userid#" log_type="1" action_id="#get_invoice_id.max_id#" action_name= "#form.serial_number#-#form.serial_no# Eklendi" paper_no= "#form.serial_number#-#form.serial_no#" period_id="#session.ep.period_id#" process_type="#get_process_type.PROCESS_TYPE#" data_source="#new_dsn2_group#">
		</cftransaction>
	</cflock>
</cfif>
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
		action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_bill&event=upd&iid=#get_invoice_id.max_id#'
		warning_description="#getLang('','Fatura',57441)# : #form.invoice_number#">	
</cfif>	
<cfif isdefined("xml_import") and xml_import neq 2>
	<cfset last_xml_import_sale = xml_import>
<cfelseif not isdefined("xml_import") or (isdefined('xml_import') and xml_import eq 2)><!--- Grup İçi işlemler için fonksiyon çağırıyoruz --->
	<cfif isdefined("new_dsn3_group")>
		<cfset new_comp_id = listlast(new_dsn3_group,'_')>
	<cfelse>
		<cfset new_comp_id = session.ep.company_id>
	</cfif>
	<cfscript>
		add_company_related_action(action_id:last_invoice_id_sale,action_type:3,comp_id:new_comp_id);
	</cfscript>
</cfif>
<!---Ek Bilgiler--->
<cfset attributes.info_id = max_id.IDENTITYCOL>
<cfset attributes.is_upd = 0>
<cfset attributes.info_type_id = -32>
<cfinclude template="../../objects/query/add_info_plus2.cfm">
<!---Ek Bilgiler--->
<!---<cfif not(isdefined('xml_import') and xml_import eq 2) and not(isdefined('xml_import') and xml_import eq 0)> bu kontrol neden eklendi?--->
<cfif not (isdefined('xml_import') and xml_import eq 2)>
	<cfif isdefined("PAPER_NUM") and len(PAPER_NUM)>
		<cfset paper_type = 'INVOICE'>
		<cfif (isDefined("attributes.company_id") and Len(attributes.company_id) and isDefined("attributes.comp_name") and Len(attributes.comp_name))>
			<cfquery name="get_comp_info" datasource="#dsn#">
				SELECT 1 FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND USE_EFATURA = 1 AND EFATURA_DATE<=#attributes.invoice_date#
			</cfquery>
		<cfelseif (isDefined("attributes.consumer_id") and Len(attributes.consumer_id))>
			<cfquery name="get_comp_info" datasource="#dsn#">
				SELECT 1 FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> AND USE_EFATURA = 1 AND EFATURA_DATE<=#attributes.invoice_date#
			</cfquery>
		</cfif>
		<cfif session.ep.our_company_info.is_efatura eq 1 and isdefined("get_comp_info") and get_comp_info.recordcount>
			<cfset paper_type = 'E_INVOICE'>
		</cfif>
		<cfquery name="UPD_PAPERS" datasource="#dsn3#">
			UPDATE 
				PAPERS_NO 
			SET 
				#paper_type#_NUMBER = #PAPER_NUM# 
			WHERE
			<cfif isdefined('attributes.paper_printer_id') and len(attributes.paper_printer_id)>
				PRINTER_ID = #attributes.paper_printer_id#
			<cfelse>
				EMPLOYEE_ID = #SESSION.EP.USERID#
			</cfif>
		</cfquery>
	</cfif>
    <cfif isDefined('session.ep.userid')>
		<cfif isDefined('session.ep.our_company_info.is_cost') and session.ep.our_company_info.is_cost eq 1><!--- sirket maliyet takip ediliyorsa not js le yonleniyor cunku cost_action locationda calismiyor --->
            <cfscript>
				if(INVOICE_CAT neq 58)//fiyat koruma degilse kayıt yapacak fiyat farkı faturası ise ana fatua guncellenecegi isin query type 2 olarak gidiyor
					cost_action(action_type:1,action_id:first_invoice_id,query_type:1);
				else
					cost_action(action_type:1,action_id:first_invoice_id,query_type:2);
            </cfscript>
        </cfif>
        <cfset attributes.actionId=first_invoice_id>
		<script type="text/javascript">
			window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_bill&event=upd&iid=#first_invoice_id#</cfoutput>";
		</script>
    </cfif>
</cfif>

<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
