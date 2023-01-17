<cf_get_lang_set module_name="invoice"><!--- sayfanin en altinda kapanisi var --->
<cfinclude template = "../../objects/query/session_base.cfm">
<cfif not isdefined("new_dsn2_group")><cfset new_dsn2_group = dsn2></cfif>
<cfinclude template="check_our_period.cfm"><!--- islem yapilan donem session dakine uygun mu? --->
<cfinclude template="add_invoice_sale_1.cfm"><!--- kontrollerin yapildigi sayfadir : ayni fatura no dan varmi urun secilmis mi? --->
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
<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session_base.userid#_'&round(rand()*100)>
<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<!---  fatura icin uye ekleniyor --->
		<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
			<cfif not isdefined("xml_import")>
				<cfinclude template="upd_company.cfm">
			</cfif>
			<cfset attributes.member_type=1><!--- kurumsal müsteri  --->
		<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
			<cfinclude template="upd_consumer.cfm">
			<cfset attributes.member_type=2><!--- bireysel müsteri  --->
		<cfelseif isdefined("attributes.member_type") and attributes.member_type eq 1>
			<cfinclude template="add_company.cfm">
			<cfset add_new_member=1><!--- yeni uyeyle ilgili action files da kullanılıyor, SILMEYIN --->
			<cfset attributes.consumer_id ="">
			<cfset attributes.company_id = GET_MAX.MAX_COMPANY>
			<cfset attributes.partner_id = GET_MAX_PARTNER.MAX_PARTNER_ID>
		<cfelseif isdefined("attributes.member_type") and attributes.member_type eq 2>
			<cfinclude template="add_consumer.cfm">
			<cfset add_new_member=1> <!--- yeni uyeyle ilgili action files da kullanılıyor, SILMEYIN --->
			<cfset attributes.consumer_id = GET_MAX_CONS.MAX_CONS>
			<cfset attributes.company_id = "">
			<cfset attributes.partner_id = "">		
		</cfif>
		
		<!--- invoice ve invoice_row --->
		<cfinclude template="add_invoice_retail_2.cfm">
		<!--- cari ve muhasebe islemleri yapılıyor --->
		<cfinclude template="add_invoice_retail_3.cfm">
		<!--- kasa cari ve muhasebe islemlerini yapiyor. --->
		<cfinclude template="add_invoice_retail_4.cfm">
		<!--- pos tahsilat islemleri --->
		<cfif isdefined("attributes.is_pos") and len(attributes.is_pos)>
			<cfinclude template="add_invoice_retail_5.cfm">
		</cfif>		
		<!--- ship eger irsaliyeli fatura ise irsaliye guncelleme ve eklemelerini yapiyor.--->
		<cfinclude template="add_invoice_retail_6.cfm">
 		<cfscript>basket_kur_ekle(action_id:get_invoice_id.max_id,table_type_id:1,process_type:0);</cfscript> 
			<cf_workcube_process_cat 
				process_cat="#form.process_cat#"
				action_id = "#get_invoice_id.max_id#"
				action_table="INVOICE"
				action_column="INVOICE_ID"
				is_action_file = 1
				action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_bill_retail&event=upd&iid=#get_invoice_id.max_id#'
				action_file_name='#get_process_type.action_file_name#'
				action_db_type = '#dsn2#'
				is_template_action_file = '#get_process_type.action_file_from_template#'>
	</cftransaction>
</cflock>

<cfif isdefined("PAPER_NUM") and len(PAPER_NUM)>
	<cfquery name="UPD_PAPERS" datasource="#dsn2#">
		UPDATE
			#dsn3_alias#.PAPERS_NO
		SET
			INVOICE_NUMBER = #PAPER_NUM#
		WHERE
		<cfif isdefined('attributes.paper_printer_id') and len(attributes.paper_printer_id)>
			PRINTER_ID = #attributes.paper_printer_id#
		<cfelse>
			EMPLOYEE_ID = #session_base.USERID#
		</cfif>
	</cfquery>
</cfif>
<cfif not isdefined("xml_import")>
	<script type="text/javascript">
		window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_bill_retail&event=upd&iid=#get_invoice_id.max_id#</cfoutput>";
	</script>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
