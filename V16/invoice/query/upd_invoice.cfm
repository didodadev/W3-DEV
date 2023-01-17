<!--- sayfada abort veya alert gibi işlemler yapılacağı zaman xml import dosyalarıda göz önüne alınmalı bu sayfalar onlardada kullanılıyor --->
<cf_get_lang_set module_name="invoice"><!--- sayfanin en altinda kapanisi var --->
<cfif not isdefined('xml_import')>
	<cfinclude template="check_our_period.cfm"><!--- islem yapilan donem session dakine uygun mu? --->
</cfif>
<cfquery name="GET_NUMBER" datasource="#dsn2#">
	SELECT INVOICE_ID,INVOICE_NUMBER,CASH_ID,IS_CASH,IS_WITH_SHIP,WRK_ID,SERIAL_NUMBER FROM INVOICE WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.invoice_id#">
</cfquery>
<cfif not get_number.recordcount>
	<cfif not isdefined('xml_import')>
		<script type="text/javascript">
			alert("Böyle Bir Fatura Kaydı Bulunamadı!");
			window.location.href="<cfoutput>#request.self#?fuseaction=invoice.list_bill</cfoutput>";	
		</script>
		<cfabort>
	<cfelse>
		<cf_get_lang no="27.Hata Oluşan Tahsilat için Silinecek Fatura Bulunamadı!"><br/><br/>
		<cfset not_find_invoice_xml=1>
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
<!--- history --->
<cfinclude template="add_invoice_history.cfm">

<cfif form.del_invoice_id eq 0><!--- silme değil güncelleme --->
	<!--- genel kontroller: cesitli tablolardan select islemleri yapiliyor orn firma acc code aliniyor.--->
	<cfinclude template="upd_invoice_1.cfm">
	<cflock name="#CreateUUID()#" timeout="20">
		<cftransaction>
			<!--- invoice tablosu update ediliyor. --->
			<cfinclude template="upd_invoice_2.cfm">
            <cfscript>
				add_relation_rows(
					action_type:'del',
					action_dsn : '#dsn2#',
					to_table:'INVOICE',
					to_action_id : form.invoice_id
					);
			</cfscript>
			<cfif isdefined("form.fatura_iptal") and form.fatura_iptal eq 1>
				<!--- invoice row a ekleme  ve guncelleme yapiliyor --->
				<cfinclude template="upd_invoice_4.cfm">  
				<cfinclude template="update_invoice_iptal.cfm">
			<cfelse>
				<!--- invoice row a ekleme  ve guncelleme yapiliyor --->
				<cfinclude template="upd_invoice_4.cfm">
				<!--- cari ve muhasebe islemleri ve guncellemeler yapiliyor. --->
				<cfinclude template="upd_invoice_3.cfm">
				<!--- kasa cari ve muhasebe --->
				<cfinclude template="upd_invoice_5.cfm">
				<!--- irsaliye ile ilgili isler yapiliyor eger irsaliye secilmis ise irsaliye guncelliyor aslinda --->
				<cfinclude template="upd_invoice_6.cfm">
				<!--- cari kayitlarina bagli olmaksizin odeme yontemine gore dbs tablosundaki kayitlar guncelleniyor --->
				<cfif attributes.invoice_payment_plan eq 1 and isdefined("attributes.paymethod") and len(attributes.paymethod) and len(attributes.paymethod_id)>
					<cfquery name="GET_PAYMENT_VEHICLE" datasource="#DSN2#">
						SELECT PAYMENT_VEHICLE FROM #dsn_alias#.SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.paymethod_id#">
					</cfquery>
					<cfif get_payment_vehicle.recordcount and get_payment_vehicle.payment_vehicle eq 8>
						<cfinclude template="upd_invoice_7.cfm">
					<cfelse>
						<cfquery name="DEL_PAYMENT_VEHICLE" datasource="#DSN2#">
							DELETE FROM #dsn3_alias#.INVOICE_PAYMENT_PLAN WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.invoice_id#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
						</cfquery>
					</cfif>
				</cfif>
				<cfscript>basket_kur_ekle(action_id:form.invoice_id,table_type_id:1,process_type:1);</cfscript>	
				<cfif isdefined("attributes.consumer_reference_code") and len(attributes.consumer_reference_code)>
					<cfquery name="add_multilevel_sales" datasource="#dsn2#">
						add_multilevel_sales
							#form.invoice_id#
					</cfquery>
					<cfquery name="add_multilevel_premium" datasource="#dsn2#">
						add_multilevel_premium
							#form.invoice_id#
					</cfquery>
				<cfelse>
					<cfquery name="DEL_INVOICE_MLM_SALES" datasource="#DSN2#">
						DELETE FROM INVOICE_MULTILEVEL_SALES WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.invoice_id#">
					</cfquery>
					<cfquery name="DEL_INVOICE_MLM_PREMIUM" datasource="#DSN2#">
						DELETE FROM INVOICE_MULTILEVEL_PREMIUM WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.invoice_id#">
					</cfquery>
				</cfif>
			</cfif>
			<cf_workcube_process_cat 
				process_cat="#form.process_cat#"
				action_id = "#form.invoice_id#"
				action_table="INVOICE"
				action_column="INVOICE_ID"
				is_action_file = "1"
				action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_bill&event=upd&iid=#form.invoice_id#'
				action_file_name='#get_process_type.action_file_name#'
				action_db_type = '#dsn2#'
				is_template_action_file = '#get_process_type.action_file_from_template#'>
		</cftransaction>
	</cflock>
    
    <!---Ek Bilgiler--->
	<cfset attributes.info_id =  attributes.invoice_id>
    <cfset attributes.is_upd = 1>
    <cfset attributes.info_type_id = -32>
    <cfinclude template="../../objects/query/add_info_plus2.cfm">
    <!---Ek Bilgiler--->
    
	<cfif session.ep.our_company_info.is_cost eq 1><!--- sirket maliyet takip ediliyorsa not js le yonlenioyr cunku cost_action locationda calismiyor --->
		<cfscript>
			if(isdefined("form.fatura_iptal") and form.fatura_iptal eq 1 and INVOICE_CAT neq 58)//fiyat koruma ise ana faturanın maliyeti guncellenmeli
				cost_action(action_type:1,action_id:form.invoice_id,query_type:3);
			else
				cost_action(action_type:1,action_id:form.invoice_id,query_type:2);
		</cfscript>
	</cfif>
	<script type="text/javascript">
        window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_bill&event=upd&iid=#form.invoice_id#</cfoutput>";
    </script>
<cfelseif (form.del_invoice_id gt 0) and (form.del_invoice_id eq form.invoice_id) and (not isdefined('not_find_invoice_xml') or not_find_invoice_xml eq 0)><!--- fatura silme  //not_find_invoice_xml budeger silmede fatura bulunmadı ise xmlden gelirken devam ettiğinde bu bloga girmesin diye--->
	<cfinclude template="get_bill_process_cat.cfm">
	<cflock name="#CreateUUID()#" timeout="20">
		<cftransaction>
				<!--- Faturalar silinmeden action file calissin diye include 8 asagi alindi fbs 20121210 --->
				<cf_workcube_process_cat 
					process_cat="#form.process_cat#"
					action_id = "#form.invoice_id#"
					action_table="INVOICE"
					action_column="INVOICE_ID"
					is_action_file = 1
					action_page='#request.self#?fuseaction=invoice.list_bill'
					action_file_name='#get_process_type.action_file_name#'
					action_db_type = '#dsn2#'
					is_template_action_file = '#get_process_type.action_file_from_template#'>
				<cfinclude template="upd_invoice_8.cfm">
				<cf_add_log  employee_id="#session.ep.userid#" log_type="-1" action_id="#form.invoice_id#" action_name="#form.invoice_number# Silindi"  process_type="#form.old_process_type#"  paper_no="#GET_NUMBER.invoice_number#" period_id="#session.ep.period_id#" data_source="#dsn2#">
		</cftransaction>
	</cflock>
	<!--- begin: ihracat kayıtlı işlemler --->
	<cfif isDefined("is_export_registered") and is_export_registered eq 1>
		<cfquery name="query_export_registered_update" datasource="#dsn2#">
			UPDATE INVOICE SET IS_EXPORT_REGISTRATION = 1 WHERE INVOICE_ID = #form.invoice_id#
		</cfquery>
	</cfif>
	<cfif isDefined("is_export_product") and is_export_product eq 1>
		<cfquery name="query_export_product_update" datasource="#dsn2#">
			UPDATE INVOICE SET IS_EXPORT_PRODUCT = 1 WHERE INVOICE_ID = #form.invoice_id#
		</cfquery>
	</cfif>
	<!--- end: ihracat kayıtlı işlemler --->
	<cfif not isdefined('xml_import')>
		<cfif session.ep.our_company_info.is_cost eq 1><!--- sirket maliyet takip ediliyorsa not js le yonlenioyr cunku cost_action locationda calismiyor --->
			<cfscript>
				if(INVOICE_CAT neq 58)//fiyat koruma ise ana faturanın maliyeti guncellenmeli
				{
					cost_action(action_type:1,action_id:form.invoice_id,query_type:3);
				}
				else
				{
					if(isdefined('UPD_INVOICE_COMP') and len(UPD_INVOICE_COMP.MAIN_INVOICE_ID))//fiyat korumada ana fatura guncellenecek
						cost_action(action_type:1,action_id:UPD_INVOICE_COMP.MAIN_INVOICE_ID,query_type:2);
					else
						cost_action(action_type:1,action_id:form.invoice_id,query_type:3);//fiyat koruma faturası ancak kontrolden değil ise normal çalışacak
				}
			</cfscript>
		</cfif>
		<script type="text/javascript">
            window.location.href="<cfoutput>#request.self#?fuseaction=invoice.list_bill</cfoutput>";
        </script>	
	</cfif>
</cfif>

<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
	<cf_workcube_process 
		is_upd='1' 
		data_source='#dsn2#' 
		old_process_line='#attributes.old_process_line#'
		process_stage='#attributes.process_stage#' 
		record_member='#session.ep.userid#' 
		record_date='#now()#'
		action_table='INVOICE'
		action_column='INVOICE_ID'
		action_id='#form.invoice_id#'
		action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_bill&event=upd&iid=#form.invoice_id#'
		warning_description='Fatura Talebi : #form.invoice_number#'>	
</cfif>	
<cfif form.del_invoice_id neq 0><!--- silme değil güncelleme --->
	<!---Ek Bilgiler--->
    <cfset attributes.info_id =  attributes.invoice_id>
    <cfset attributes.is_upd = 1>
    <cfset attributes.info_type_id = -32>
    <cfinclude template="../../objects/query/add_info_plus2.cfm">
    <!---Ek Bilgiler--->
</cfif>

<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
