<cf_get_lang_set module_name="invoice"><!--- sayfanin en altinda kapanisi var --->
<cfinclude template="check_our_period.cfm"><!--- islem yapilan donem session dakine uygun mu? --->
<cfquery name="GET_NUMBER" datasource="#dsn2#">
	SELECT INVOICE_ID,INVOICE_NUMBER,IS_CASH,IS_WITH_SHIP,PROCESS_CAT FROM INVOICE WHERE INVOICE_ID=#attributes.invoice_id#
</cfquery>
<cfif not GET_NUMBER.recordcount>
	<script type="text/javascript">
		alert("Böyle Bir Fatura Kaydı Bulunamadı!");
		window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.welcome</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cfif len(attributes.department_id) and len(attributes.location_id)>
	<cfquery name="GET_LOCATION_TYPE" datasource="#dsn#">
		SELECT LOCATION_TYPE,IS_SCRAP FROM STOCKS_LOCATION WHERE DEPARTMENT_ID=#attributes.department_id# AND LOCATION_ID=#attributes.location_id#
	</cfquery>
	<cfset location_type=GET_LOCATION_TYPE.LOCATION_TYPE>
	<cfset is_scrap=GET_LOCATION_TYPE.IS_SCRAP>
<cfelse>
	<cfset location_type = "">
	<cfset is_scrap = 0>
</cfif>
<cfif form.del_invoice_id eq 0><!--- silme değil güncelleme --->
	<!--- genel kontroller: cesitli tablolardan select islemleri yapiliyor orn firma acc code aliniyor.--->
	<cfinclude template="upd_invoice_1.cfm">
	<cflock name="#CreateUUID()#" timeout="60">
		<cftransaction>
			<cfif isdefined("attributes.member_type") and (attributes.member_type eq 1) and isdefined("attributes.company_id") and len(attributes.company_id)>
				<cfinclude template="upd_company.cfm">
			<cfelseif isdefined("attributes.member_type") and (attributes.member_type eq 2) and isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
				<cfinclude template="upd_consumer.cfm">
			</cfif>
			<!--- invoice tablosu update ediliyor. --->
			<cfinclude template="upd_invoice_retail_2.cfm">
			<cfif isdefined("form.fatura_iptal") and form.fatura_iptal eq 1>
				<!--- invoice row a ekleme  ve guncelleme yapiliyor --->
				<cfinclude template="upd_invoice_retail_4.cfm">  
				<cfinclude template="update_invoice_iptal_retail.cfm">

				
			<cfelse>
				<!--- invoice row a ekleme  ve guncelleme yapiliyor --->
				<cfinclude template="upd_invoice_retail_4.cfm">
				<!--- cari ve muhasebe islemleri ve guncellemeler yapiliyor. --->
				<cfinclude template="upd_invoice_retail_3.cfm"> 
				<!--- kasa cari ve muhasebe --->
				<cfinclude template="upd_invoice_retail_5.cfm">
				<!--- pos tahsilatı --->
				<cfinclude template="upd_invoice_retail_6.cfm"> 
				<!--- irsaliye ile ilgili isler yapiliyor --->
				<cfinclude template="upd_invoice_retail_7.cfm">
				<cfscript>basket_kur_ekle(action_id:form.invoice_id,table_type_id:1,process_type:1);</cfscript>	
					
			</cfif>
			<cf_workcube_process_cat 
						process_cat="#form.process_cat#"
						action_id = "#form.invoice_id#"
						action_table="INVOICE"
						action_column="INVOICE_ID"
						is_action_file = 1
						action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_bill_retail&event=upd&iid=#form.invoice_id#'
						action_file_name='#get_process_type.action_file_name#'
						action_db_type = '#dsn2#'
						is_template_action_file = '#get_process_type.action_file_from_template#'>	
		</cftransaction>
	</cflock>
	<script type="text/javascript">
        window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_bill_retail&event=upd&iid=#form.invoice_id#</cfoutput>";
    </script>
<cfelseif (form.del_invoice_id gt 0) and (form.del_invoice_id eq form.invoice_id)><!--- fatura silme --->
	<cfinclude template="get_bill_process_cat.cfm">
	<cfinclude template="upd_invoice_retail_8.cfm">
	<script type="text/javascript">
        window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_bill</cfoutput>";
    </script>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
