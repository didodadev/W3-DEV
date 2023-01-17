<cfinclude template = "../../objects/query/session_base.cfm">
<!--- 
	urune spect secilmemis ancak urun agaci varsa veya ozellikleri veya operasyonları varsa spect olarak onu kaydediyoruz o satir icin
	Kullanildigi yerler siparis, fatura, irsaliye, teklif, fisler
	** bu dosyanın iceriyi degisirse üretim planlamadıki prod/query/add_production_order.cfm dosyasındaki bu bolge duzenlensin
--->
<cfif not isdefined('GET_TREE#i#.RECORDCOUNT') or evaluate('GET_TREE#i#.RECORDCOUNT') eq 0 or (isDefined("RetryEx") and RetryEx eq 1)><!--- ozellikli spec degil veya ozellikli spec olsada urun ozelligi yoksa agaci varsa o kaydedilecek --->
	<cfif not isdefined('dsn_type')><cfset dsn_type=dsn3></cfif>
    <cfquery name="GET_TREE#i#" datasource="#dsn_type#"><!--- Ürün Ağacından En Son Varyasyonlanan yani kaydedilen SPECT_MAIN_ID'yi getiriyor.aşağıdada bu main spec kullanılarak bir spec oluşturuluyor..ve baskete yansıtılıyor.. --->
        SELECT TOP 1 SPECT_MAIN_ID FROM #dsn3_alias#.SPECT_MAIN  AS SM WHERE SM.STOCK_ID = #evaluate("attributes.stock_id#i#")# AND SM.IS_TREE = 1 ORDER BY SM.RECORD_DATE DESC,SM.UPDATE_DATE DESC
    </cfquery>
</cfif>
<cfif isdefined("fusebox.use_spect_company") and len(fusebox.use_spect_company) and isdefined("fusebox.spect_company_list") and listfind(fusebox.spect_company_list,session_base.company_id)>
	<cfset new_dsn3 = "#dsn#_#fusebox.use_spect_company#">
<cfelse>
	<cfset new_dsn3 = dsn3>
</cfif>
<cfscript>
if(not isdefined('attributes.company_id')) attributes.company_id = 0;
if(not isdefined('attributes.consumer_id')) attributes.consumer_id = 0;
if(evaluate('GET_TREE#i#.RECORDCOUNT'))
{
	'spec_info#i#' = specer(
			dsn_type:dsn_type,
			spec_type:1,
			main_spec_id:evaluate('GET_TREE#i#.SPECT_MAIN_ID'),
			add_to_main_spec:1,
			company_id: attributes.company_id,
			consumer_id: attributes.consumer_id
		);
	if(isdefined('attributes.is_spect_name_to_property') and attributes.is_spect_name_to_property eq 1){//Spec ismi confg.ürünlerden oluşturuluyor ise!
		configure_spec_name = evaluate("attributes.product_name#i#");
		GetProductConf(listgetat(Evaluate('spec_info#i#'),1,','));//fonksiyon burda çağırlıyor ilk olarak
	}	
}
</cfscript>
<cfif isdefined('attributes.is_spect_name_to_property') and attributes.is_spect_name_to_property eq 1 and isdefined('spec_info#i#')>
    <cfquery name="UpdateSpecNameQuery" datasource="#new_dsn3#">
        UPDATE SPECT_MAIN SET SPECT_MAIN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#left(configure_spec_name,499)#"> WHERE SPECT_MAIN_ID = #listgetat(Evaluate('spec_info#i#'),1,',')#              
    </cfquery>
    <cfif len(listgetat(Evaluate('spec_info#i#'),1,',')) and listgetat(Evaluate('spec_info#i#'),1,',') gt 0>
        <cfquery name="UpdateS_V_SpecNameQuery" datasource="#new_dsn3#">
            UPDATE SPECTS SET SPECT_VAR_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#left(configure_spec_name,499)#"> WHERE SPECT_VAR_ID = #listgetat(Evaluate('spec_info#i#'),2,',')#
        </cfquery>
    </cfif>
</cfif>	
<!--- zaten bu dosya calisiyorsa spec agactan uretilecektir bu yuzden satir tutarlarını degistirmiyoz --->
<cfif isdefined('spec_info#i#') and listlen(evaluate('spec_info#i#'),',')>
	<cfset 'attributes.spect_id#i#'=listgetat(evaluate('spec_info#i#'),2,',')>
	<cfif len(listgetat(evaluate('spec_info#i#'),3,','))>
		<cfset 'attributes.spect_name#i#'=listgetat(evaluate('spec_info#i#'),3,',')>
	<cfelse>
		<cfset 'attributes.spect_name#i#'=evaluate("attributes.product_name#i#")>
	</cfif>
	<!--- FBS 20120713 Manuel girilen maliyet degerleri, spect olmasi durumunda yeniden hesaplaniyor, buna gerek olmadigindan kaldirdim.
	<cfif len(listgetat(evaluate('spec_info#i#'),3,',')) and ( isdefined('attributes.process_cat') and isdefined('ct_process_type_#attributes.process_cat#') and not listfind('55,54,73,74,114',evaluate('ct_process_type_#attributes.process_cat#'),',') )>
	<!--- iadelerde ekrana yazilan tutar kaydedilmeli hesaplanan degil islem kategorisi olan sayfalardan geliyorsa tabi iade oldugunu biliyoz --->
		<cfset 'attributes.cost_id#i#'=''>
		<cfset 'attributes.net_maliyet#i#'= listgetat(evaluate('spec_info#i#'),9,',')>
		<cfset 'attributes.extra_cost#i#'= listgetat(evaluate('spec_info#i#'),10,',')>
	</cfif>
	 --->
</cfif>
