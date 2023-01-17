<cf_get_lang_set module_name="invoice"><!--- sayfanin en altinda kapanisi var --->
<!--- kontroller --->
<cfif isdefined("attributes.note")><cfset note = attributes.note></cfif>
<cfinclude template="add_invoice_other_1.cfm">
<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<!--- fatura ve satırları --->
		<cfinclude template="add_invoice_other_2.cfm">
		<!--- fatura cari ve muhasebe --->
		<cfinclude template="add_invoice_other_3.cfm">
		<!--- kasa varsa kasa işlemleri --->
		<cfinclude template="add_invoice_other_4.cfm">
		<cfif ListFindNoCase("690,64", INVOICE_CAT, ",")><!--- Gider Pusula (Mal) ---><!--- Müstahsil Makbuzu ---><!--- Mal --->
			<!--- ship + row ---><!--- kendi irsaliyesi --->
			<cfinclude template="add_invoice_other_5.cfm">
		</cfif>
		<!--- Stock + Row --->
		<cfinclude template="add_invoice_other_6.cfm">
		<cfscript>basket_kur_ekle(action_id:get_invoice_id.max_id,table_type_id:1,process_type:0);</cfscript>
		<!--- secilen islem kategorisine bir action file eklenmisse --->
		<cf_workcube_process_cat 
			process_cat="#form.process_cat#"
			is_action_file = 1
			action_file_name='#get_process_type.action_file_name#'
			action_db_type = '#dsn2#'
			action_id = #get_invoice_id.max_id#
			action_table="INVOICE"
			action_column="INVOICE_ID"
			action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_bill_other&event=upd&iid=#get_invoice_id.max_id#'
			is_template_action_file = '#get_process_type.action_file_from_template#'>
            
		<!--- E-Fatura Onay islemi--->
        <cfinclude template="../../e_government/query/einvoice_approval.cfm" />
		<cf_add_log employee_id="#session.ep.userid#" log_type="1" action_id="#get_invoice_id.max_id#" action_name="Alis Faturasi Eklendi" paper_no="#form.invoice_number#" period_id="#session.ep.period_id#"  process_type="#INVOICE_CAT#" data_source="#dsn2#">
	</cftransaction>
</cflock>
<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
	<cf_workcube_process 
			is_upd='1' 
			data_source='#dsn2#' 
			old_process_line='0'
			process_stage='#attributes.process_stage#' 
			record_member='#session.ep.userid#' 
			record_date='#now()#'
			action_table='INVOICE'
			action_column='INVOICE_ID'
			action_id='#get_invoice_id.max_id#'
			action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_bill_other&event=upd&iid=#get_invoice_id.max_id#'
			warning_description="#getLang('','Stopajlı Alış Faturası',47219)# : #form.invoice_number#">
</cfif>
<!---Ek Bilgiler--->
<cfset attributes.info_id = get_invoice_id.max_id>
<cfset attributes.is_upd = 0>
<cfset attributes.info_type_id = -8>
<cfinclude template="../../objects/query/add_info_plus2.cfm">
<!---Ek Bilgiler--->
<cfif isdefined("attributes.efatura_id") and len(attributes.efatura_id)>
	<script type="text/javascript">
		wrk_opener_reload();
	</script>
</cfif>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_bill_other&event=upd&iid=#get_invoice_id.max_id#</cfoutput>";
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->

