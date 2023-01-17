<cfif attributes.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı.\rMuhasebe Döneminizi Kontrol Ediniz!");
		window.location.href='<cfoutput>#request.self#?fuseaction=invoice.list_bill</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cfquery name="get_number" datasource="#dsn2#">
	SELECT INVOICE_ID,INVOICE_NUMBER,CASH_ID,IS_CASH,IS_WITH_SHIP,WRK_ID FROM INVOICE WHERE INVOICE_ID = #attributes.invoice_id#
</cfquery>
<cfif not get_number.recordcount>
	<script type="text/javascript">
		alert("Böyle Bir Fatura Kaydı Bulunamadı!");
		window.location.href="<cfoutput>#request.self#?fuseaction=invoice.list_bill</cfoutput>";	
	</script>
	<cfabort>
</cfif>
<cfset is_from_zreport = 1>
<cfif attributes.del_invoice_id eq 0>
	<cfinclude template="../../invoice/query/upd_invoice_1.cfm">
	<cf_get_lang_set module_name="finance">
	<cflock name="#CreateUUID()#" timeout="60">
		<cftransaction>
			<cfset attributes.total_diff_amount = filterNum(attributes.total_diff_amount)>
			<!--- Fatura ve fatura satırları --->
			<cfinclude template="upd_daily_zreport1.cfm">
			<!--- Muhasebe işlemleri --->
			<cfinclude template="upd_daily_zreport2.cfm">
			<!--- Kasa işlemleri --->
			<cfinclude template="upd_daily_zreport3.cfm">
			<!--- Pos işlemleri --->
			<cfinclude template="upd_daily_zreport4.cfm">
			<!--- Stok hareketleri --->
			<cfinclude template="upd_daily_zreport5.cfm">
			<cfif attributes.x_show_info eq 1>
				<!--- Istatistiksel bilgiler --->
				<cfinclude template="upd_daily_zreport7.cfm">						
			</cfif>
			<cfscript>basket_kur_ekle(action_id:attributes.invoice_id,table_type_id:1,process_type:1);</cfscript>	
			<cfif len(get_process_type.action_file_name)>
				<cf_workcube_process_cat 
					process_cat="#attributes.process_cat#"
					action_id = #attributes.invoice_id#
					is_action_file = 1
					action_file_name='#get_process_type.action_file_name#'
					action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_daily_zreport&event=upd&iid=#attributes.invoice_id#'
					action_db_type = '#dsn2#'
					is_template_action_file = '#get_process_type.action_file_from_template#'>
			</cfif>

		</cftransaction>
	</cflock>
    <script type="text/javascript">
		window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_daily_zreport&event=upd&iid=#attributes.invoice_id#</cfoutput>";
	</script>
	<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
<cfelseif (attributes.del_invoice_id gt 0) and (attributes.del_invoice_id eq attributes.invoice_id)>
	<cfquery name="get_process" datasource="#dsn2#">
		SELECT PROCESS_CAT,INVOICE_NUMBER FROM INVOICE WHERE INVOICE_CAT=69 AND INVOICE_ID = #attributes.invoice_id#
	</cfquery>
	<cfinclude template="../../invoice/query/get_bill_process_cat.cfm">
	<cflock name="#CreateUUID()#" timeout="20">
		<cftransaction>
			<cfinclude template="upd_daily_zreport6.cfm">
			<cfif len(get_process_type.action_file_name)>
				<cf_workcube_process_cat 
					process_cat="#attributes.process_cat#"
					action_id = #attributes.invoice_id#
					is_action_file = 1
					action_file_name='#get_process_type.action_file_name#'
					action_page='#request.self#?fuseaction=#fusebox.circuit#.list_daily_zreport'
					action_db_type = '#dsn2#'
					is_template_action_file = '#get_process_type.action_file_from_template#'>
			</cfif>
			<cf_add_log  log_type="-1" action_id="#attributes.invoice_id#" action_name="#attributes.invoice_number#" paper_no="#get_process.invoice_number#" process_stage="#get_process.process_cat#" process_type="#attributes.old_process_type#" data_source="#dsn2#">
		</cftransaction>
	</cflock>
    <script type="text/javascript">
		window.location.href="<cfoutput>#request.self#?fuseaction=finance.list_daily_zreport</cfoutput>";
	</script>
</cfif>
