<cf_get_lang_set module_name="invoice"><!--- sayfanin en altinda kapanisi var --->
<cfinclude template="check_our_period.cfm"><!--- islem yapilan donem session dakine uygun mu? --->
<cfset attributes.basket_due_value_date_ = attributes.invoice_date><!--- alış sayfalarını kullandıgı için böyle set edildi --->
<cfquery name="GET_NUMBER" datasource="#dsn2#">
	SELECT INVOICE_ID,INVOICE_NUMBER,CASH_ID,IS_CASH,IS_WITH_SHIP FROM INVOICE WHERE INVOICE_ID=#form.invoice_id#
</cfquery>
<cfif not GET_NUMBER.recordcount>
	<script type="text/javascript">
		alert("Böyle Bir Fatura Kaydı Bulunamadı!");
		window.location.href="<cfoutput>#request.self#?fuseaction=invoice.list_bill</cfoutput>";	
	</script>
	<cfabort>
</cfif>
<cfscript>
	add_relation_rows(
		action_type:'del',
		action_dsn : '#dsn2#',
		to_table:'INVOICE',
		to_action_id : form.invoice_id
		);
</cfscript>		
<cfif form.del_invoice_id eq 0 >
	<cfinclude template="upd_invoice_purchase_1.cfm"><!--- kontroller yapiliyor ve ship varsa  siliniyor --->
	<cflock name="#CreateUUID()#" timeout="20">
		<cftransaction>
			<!--- invoice ve invoice_row tablosunu guncelleme islemini yapiyor.--->
			<cfinclude template="upd_invoice_marketplace_2.cfm">
			<cfif isdefined("form.fatura_iptal") and form.fatura_iptal eq 1>
				<cfinclude template="update_invoice_iptal_purchase.cfm">
			<cfelse>
				<cfinclude template="upd_invoice_purchase_3.cfm" ><!--- cari ve muhasebe guncelleme islemi yapiyor --->
				<cfinclude template="upd_invoice_purchase_4.cfm" ><!--- kasa cari ve nuhasebe islemlerii yapar. --->
				<!--- stok ve irsaliye islemleri stok tablosu ve irsaliye tablolarina ekleme ve guncellemeler yapiliyor.
				<cfinclude template="upd_invoice_marketplace_5.cfm" > --->
				<cfscript>basket_kur_ekle(action_id:form.invoice_id,table_type_id:1,process_type:1);</cfscript>						
			</cfif>	
		</cftransaction>
	</cflock>
	<cfscript>
        if(isdefined("form.fatura_iptal") and form.fatura_iptal eq 1)
            cost_action(action_type:1,action_id:form.invoice_id,query_type:3);
        else
            cost_action(action_type:1,action_id:form.invoice_id,query_type:2);
    </cfscript>
	<script type="text/javascript">
        window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.marketplace_commands&event=upd&iid=#form.invoice_id#</cfoutput>";
    </script>    
<cfelseif (form.del_invoice_id gt 0) and (form.del_invoice_id eq form.invoice_id)>
	<cfscript>
	    cost_action(action_type:1,action_id:form.invoice_id,query_type:3);
    </cfscript>	
    <cfinclude template="get_bill_process_cat.cfm">
	<cfinclude template="upd_invoice_purchase_6.cfm">
	<cf_add_log  log_type="-1" action_id="#form.invoice_id#" action_name="#form.invoice_number# Silindi" paper_no="#form.invoice_number#" process_type="#form.old_process_type#">
	<cfoutput>
		<script type="text/javascript">
            window.location.href="#request.self#?fuseaction=invoice.list_bill";
        </script> 
    </cfoutput>     
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
