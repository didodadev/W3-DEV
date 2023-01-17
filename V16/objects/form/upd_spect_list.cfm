<cfif isdefined("fusebox.use_spect_company") and len(fusebox.use_spect_company) and isdefined("fusebox.spect_company_list") and isdefined("session_base") and isdefined("session_base.company_id") and listfind(fusebox.spect_company_list,session_base.company_id)>
	<cfset new_dsn3 = "#dsn#_#fusebox.use_spect_company#">
	<cfset new_dsn3_alias = "#dsn#_#fusebox.use_spect_company#">
<cfelseif isdefined("dsn3")>
	<cfset new_dsn3 = dsn3>
	<cfset new_dsn3_alias = dsn3_alias>
</cfif>
<cfif isdefined('attributes.id')>
	<cfquery name="GET_SPECT" datasource="#new_dsn3#">
		SELECT * FROM SPECTS WHERE SPECT_VAR_ID = #attributes.id#
	</cfquery>
	<cfif GET_SPECT.RECORDCOUNT>
		<cfset attributes.stock_id=GET_SPECT.STOCK_ID>
		<cfset attributes.product_id=GET_SPECT.PRODUCT_ID>
	</cfif>
<cfelseif isdefined('attributes.SPECT_MAIN_ID')>
	<cfset GET_SPECT.SPECT_TYPE = 1>	
	<cfquery name="GET_SPECT" datasource="#new_dsn3#">
		SELECT SPECT_MAIN_NAME AS SPECT_VAR_NAME,* FROM SPECT_MAIN WHERE SPECT_MAIN_ID = #attributes.spect_main_id#
	</cfquery>
	<cfif GET_SPECT.RECORDCOUNT>
		<cfset attributes.stock_id=GET_SPECT.STOCK_ID>
		<cfset attributes.product_id=GET_SPECT.PRODUCT_ID>
	</cfif>
</cfif>
<cfquery name="get_product_info" datasource="#new_dsn3#">
	SELECT PRODUCT_NAME,PRODUCT_ID,IS_PROTOTYPE,IS_PRODUCTION FROM STOCKS WHERE STOCK_ID = #attributes.stock_id#
</cfquery>
<cfif isdefined('attributes.sepet_process_type') and ListFind("59,62,591,76,78,77,79,811,761",attributes.sepet_process_type)>
	<cfset spec_purchasesales=0>
<cfelse>
	<cfset spec_purchasesales=1>
</cfif>
<cfset attributes.unsalable=1><!--- acilan urun popuplarinda satilamaz lokasyonda olanda gelsin --->
<cf_xml_page_edit fuseact ="objects.popup_add_spect_list">
	<!--- Sayfa Eğer main spect güncelleme sayfası olarak kullanılacaksa,fiyat gösterimi yapılmayacağından gösterim değerleri el ile set ediliyor,query sayfasında da fiyatlar dikkate alınmayacak --->
	<!--- <cfset is_show_property_and_calculate = 0>Özelllikler İşlemler Kısmı standart da gelmesin kullanıcının seçimine göre gelsin--->
	<cfset is_show_detail = 0><!--- Main Spect'e detay girmiyoruz,detaylar sadece spect'de tutuluyor --->
	<cfset is_show_cost = 0><!--- Maliyet tutulmuyor zaten tablolarda, --->
	<cfset is_show_diff_price = 0><!--- Main Spect'de Fiyat tutulmuyor o sebeble burda fiyat farkı da göstermiyoruz  --->
	<cfset is_show_price = 0><!--- Main Spect'de Fiyat tutulmuyor o sebeble burda fiyat da göstermiyoruz  --->
	<cfset is_show_property_amount = 1>
	<cfset is_show_property_price = 0><!--- Main Spect'de Fiyat tutulmuyor o sebeble burda fiyat göstermiyoruz  --->
	<cfset is_show_tolerance_property = 1>
    <cfset is_show_line_number = 1>
	<cfset is_show_spect_name = 1>
	<cfset is_show_special_code_1 = 1>
	<cfset is_show_special_code_2 = 1>
	<cfset is_show_special_code_3 = 1>
	<cfset is_show_special_code_4 = 1>
	<cfset is_show_stock_limit_check = 1>
	<cfset is_show_product_price_change = 1>
	<!--- degisiklikler burada ---> 
	<cfset xml_str = "&is_show_product_price_change=1&is_show_stock_limit_check=1&is_show_spect_name=1&is_show_special_code_1=1&is_show_special_code_2=1&is_show_special_code_3=1&is_show_special_code_4=1&is_show_configure=0&is_show_line_number=0&is_show_property_and_calculate=#is_show_property_and_calculate#&is_show_detail=0&is_spect_name_to_property=#is_spect_name_to_property#&is_show_cost=0&is_show_diff_price=0&is_show_price=0&is_show_property_amount=1&is_show_property_price=0&is_show_tolerance_property=1&is_change_spect_name=#is_change_spect_name#">
<!---// XML SAYFA YAPISI --->
<cfif x_is_spec_type eq 2>
	<cfinclude template="../form/add_spect_from_alternative_products.cfm">
<cfelseif x_is_spec_type eq 1>
	<cfinclude template="upd_spect_new.cfm">
<cfelseif x_is_spec_type eq 3>
	<cfinclude template="upd_spect_old.cfm">
<cfelseif x_is_spec_type eq 4>
	<cfif get_product_info.is_production eq 1>
		<cfinclude template="add_spect_from_alternative_products.cfm">
	<cfelse>
		<cfinclude template="upd_spect_new.cfm">
	</cfif>
</cfif>
