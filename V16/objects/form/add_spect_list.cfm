<cf_get_lang_set module_name="objects">
<!--- <cfset session.ep.our_company_info.spect_type=5> --->
<!--- spec alismi satismii --->

<cfif isdefined('attributes.sepet_process_type') and ListFind("59,62,591,76,78,77,79,811,761",attributes.sepet_process_type)>
	<cfset spec_purchasesales=0>
<cfelse>
	<cfset spec_purchasesales=1>
</cfif>
<cfset attributes.unsalable=1><!--- acilan urun popuplarinda satilamaz lokasyonda olanda gelsin --->
<cf_xml_page_edit>
<cfquery name="GET_PRODUCT_INFO" datasource="#DSN3#">
	SELECT PRODUCT_NAME,PRODUCT_ID,IS_PROTOTYPE,IS_PRODUCTION FROM STOCKS WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
</cfquery>
<cfif x_is_spec_type eq 2>
		<!--- Sayfa Eğer main spect ekle sayfası olarak kullanılacaksa,fiyat gösterimi yapılmayacağından gösterim değerleri el ile set ediliyor,query sayfasında da fiyatlar dikkate alınmayacak --->
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
		<cfset xml_str = "&is_show_product_price_change=1&is_show_stock_limit_check=1&is_show_spect_name=1&is_show_special_code_1=1&is_show_special_code_2=1&is_show_special_code_3=1&is_show_special_code_4=1&is_show_configure=0&is_show_line_number=0&is_show_property_and_calculate=#is_show_property_and_calculate#&is_show_detail=0&is_spect_name_to_property=#is_spect_name_to_property#&is_show_cost=0&is_show_diff_price=0&is_show_price=0&is_show_property_amount=1&is_show_property_price=0&is_show_tolerance_property=1">
	<cfinclude template="add_spect_from_alternative_products.cfm"><!--- alternatif ürünlerden spec oluşturma sayfası... --->
<cfelseif x_is_spec_type eq 1>
	<cfinclude template="add_spect_new.cfm">
<cfelseif x_is_spec_type eq 3>
	<cfinclude template="add_spect_old.cfm">
<cfelseif x_is_spec_type eq 4>
	<cfif get_product_info.is_production eq 1>
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
		<cfinclude template="add_spect_from_alternative_products.cfm">
	<cfelse>
		<cfinclude template="add_spect_new.cfm">
	</cfif>
</cfif>
<!--- <cfif x_is_spec_type eq 1> <!--- Ürün Ağacı ve Özelliklerden Oluşan Spec Sayfası... --->
    
<cfelseif x_is_spec_type eq 2> <!--- Ürün Konfigüratöründen Oluşan Spec Sayfası.... --->
    <!--- <cfinclude template="add_spect_product_conf.cfm"> --->
</cfif> --->
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
