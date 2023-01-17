<cf_get_lang_set module_name="invoice"><!--- sayfanin en altinda kapanisi var --->
<cfinclude template="check_our_period.cfm"><!--- islem yapilan donem session dakine uygun mu? --->
<cfset attributes.basket_due_value_date_ = attributes.invoice_date><!--- alış sayfalarını kullandıgı için böyle set edildi --->
<cfif not isdefined("new_comp_id")><cfset new_comp_id = session.ep.company_id></cfif>
<cfif not isdefined("new_dsn3_group")><cfset new_dsn3_group = dsn3></cfif>
<cfif not isdefined("new_dsn2_group")><cfset new_dsn2_group = dsn2></cfif>
<cfif not isdefined("new_period_id")><cfset new_period_id = session.ep.period_id></cfif>
<cfinclude template="add_invoice_purchase_1.cfm"><!--- kontrollerin yapildigi sayfa : ayni fatura no dan varmi urun secilmis mi? --->
<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<!--- Include dosyalarinda datasource ismi DSN2 olucak sekilde alias la baska dsn leri yazin. --->
		<!--- fatura tablosuna kayit ekleme islemi yapiliyor. --->
		<cfinclude template="add_invoice_marketplace_2.cfm">
        <cfset get_invoice_id.max_id = max_id.identitycol>
		<!--- cari ve muhasebe islemleri yapiliyor. --->
		<cfinclude template="add_invoice_purchase_3.cfm">
		<!--- kasa cari ve muhasebe islemlerini yapiyor. --->
		<cfinclude template="add_invoice_purchase_4.cfm">
		<cfscript>basket_kur_ekle(action_id:get_invoice_id.max_id,table_type_id:1,process_type:0);</cfscript>
	</cftransaction>
</cflock>
<cfif session.ep.our_company_info.is_cost eq 1 and get_process_type.IS_COST eq 1><!--- sirket maliyet takip ediliyorsa not js le yonlenioyr cunku cost_action locationda calismiyor --->
	<cfscript>cost_action(action_type:1,action_id:get_invoice_id.max_id,query_type:1);</cfscript>
    <script type="text/javascript">
        window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.marketplace_commands&event=upd&iid=#get_invoice_id.max_id#</cfoutput>";
    </script>
</cfif>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.marketplace_commands&event=upd&iid=#get_invoice_id.max_id#</cfoutput>";
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
