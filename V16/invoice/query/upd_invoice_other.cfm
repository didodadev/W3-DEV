<cfinclude template="check_our_period.cfm"><!--- islem yapilan donem session dakine uygun mu? --->
<cfquery name="GET_NUMBER" datasource="#dsn2#">
	SELECT INVOICE_ID,INVOICE_NUMBER,CASH_ID,IS_CASH,IS_WITH_SHIP,PROCESS_CAT,SERIAL_NUMBER FROM INVOICE WHERE INVOICE_ID=#form.invoice_id#
</cfquery>
<cfif not GET_NUMBER.recordcount>
	<script type="text/javascript">
		alert("Böyle Bir Fatura Kaydı Bulunamadı!");
		window.location.href="<cfoutput>#request.self#?fuseaction=invoice.list_bill</cfoutput>";	
	</script>
	<cfabort>
</cfif>
<cfif isdefined("attributes.note")><cfset note = attributes.note></cfif>
<cfif form.del_invoice_id eq 0>
	<cfinclude template="upd_invoice_other_1.cfm"><!--- kontroller --->
	<cflock name="#CreateUUID()#" timeout="20">
		<cftransaction>
			<cfinclude template="upd_invoice_other_2.cfm"><!--- fatura ve satırları --->
			<cfif isdefined("form.fatura_iptal") and form.fatura_iptal eq 1>
				<!--- fatura iptal islemleri yapar. --->
				<cfinclude template="update_invoice_iptal_other.cfm">
			<cfelse>
				<cfinclude template="upd_invoice_other_3.cfm"><!--- fatura cari ve muhasebe --->
				<cfinclude template="upd_invoice_other_4.cfm"><!--- kasa varsa kasa işlemleri --->
				<cfif ListFindNoCase("690,64,691,68", invoice_cat, ",")><!--- Gider Pusula (Mal) ---><!--- Müstahsil Makbuzu ---><!--- Mal --->
					<cfinclude template="upd_invoice_other_5.cfm"><!--- ship + row ---><!--- kendi irsaliyesi --->
					<cfinclude template="upd_invoice_other_6.cfm"><!--- stock + row --->
				</cfif>
				<cfscript>basket_kur_ekle(action_id:form.invoice_id,table_type_id:1,process_type:1);</cfscript>	
					<cf_workcube_process_cat 
						process_cat="#form.process_cat#"
						action_id = "#form.invoice_id#"
						action_table="INVOICE"
						action_column="INVOICE_ID"
						is_action_file = 1
						action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_bill_other&event=upd&iid=#form.invoice_id#'
						action_file_name='#get_process_type.action_file_name#'
						action_db_type = '#dsn2#'
						is_template_action_file = '#get_process_type.action_file_from_template#'>
			</cfif>
            <cf_add_log employee_id="#session.ep.userid#" log_type="0" action_id="#form.invoice_id#" action_name="Alis Faturasi Güncellendi" paper_no="#form.invoice_number#" period_id="#session.ep.period_id#"  process_type="#INVOICE_CAT#" data_source="#dsn2#">
		</cftransaction>
	</cflock>
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
			action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_bill_other&event=upd&iid=#form.invoice_id#'
			warning_description='Stopajlı Alış Faturası : #form.invoice_number#'>	
	</cfif>	
<!---Ek Bilgiler--->
<cfset attributes.info_id =  attributes.invoice_id>
<cfset attributes.is_upd = 1>
<cfset attributes.info_type_id = -8>
<cfinclude template="../../objects/query/add_info_plus2.cfm">
<!---Ek Bilgiler--->
<cfset attributes.actionId = attributes.invoice_id >
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_bill_other&event=upd&iid=#attributes.invoice_id#</cfoutput>";
</script>
<cfelseif (form.del_invoice_id gt 0) and (form.del_invoice_id eq form.invoice_id)>
	<cfinclude template="upd_invoice_other_7.cfm">
	<script type="text/javascript">
        window.location.href="<cfoutput>#request.self#?fuseaction=invoice.list_bill</cfoutput>";
    </script>
</cfif>
