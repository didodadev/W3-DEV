<cfif form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı.\rMuhasebe Döneminizi Kontrol Ediniz!");
		window.location.href='<cfoutput>#request.self#?fuseaction=invoice.list_bill</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cfset is_from_zreport = 1>
<cfinclude template="../../invoice/query/add_invoice_sale_1.cfm">
<cf_get_lang_set module_name="finance">
<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
	<cflock name="#CreateUUID()#" timeout="60">
		<cftransaction>
			<cfset attributes.total_diff_amount =  (isDefined("attributes.total_diff_amount")) ? filterNum(attributes.total_diff_amount) : 0>
			<!--- Fatura ve fatura satırları --->
			<cfinclude template="add_daily_zreport1.cfm">
			<!--- Muhasebe işlemleri --->
			<cfinclude template="add_daily_zreport2.cfm">
			<!--- Kasa işlemleri --->
			<cfinclude template="add_daily_zreport3.cfm">
			<!--- Pos işlemleri --->
			<cfinclude template="add_daily_zreport4.cfm">
			<!--- Stok hareketleri --->
			<cfinclude template="add_daily_zreport5.cfm">
			<cfif attributes.x_show_info eq 1><!--- xml de seçili ise --->
				<!--- Istatiksel Bilgiler --->
				<cfinclude template="add_daily_zreport7.cfm">				
			</cfif>
			<cfscript>basket_kur_ekle(action_id:get_invoice_id.max_id,table_type_id:1,process_type:0);</cfscript> 
			<!--- onay ve uyarıların gelebilmesi icin action file sarti kaldirildi --->
				<cf_workcube_process_cat 
					process_cat="#form.process_cat#"
					action_id = #get_invoice_id.max_id#
					is_action_file = 1
					action_file_name='#get_process_type.action_file_name#'
					action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.upd_daily_zreport&iid=#get_invoice_id.max_id#'
					action_db_type = '#dsn2#'
					is_template_action_file = '#get_process_type.action_file_from_template#'>		
		</cftransaction>
	</cflock>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_daily_zreport&event=upd&iid=#get_invoice_id.max_id#</cfoutput>";
</script>	
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
