<cfoutput>
    <div class="pagemenus_container">
    	<div style="float:left;">
            <ul class="pagemenus">
                <li><strong><cf_get_lang_main no='2207.Fiziki Varlıklar'></strong>
                    <ul>
                        <cfif not listfindnocase(denied_pages,'assetcare.list_assetp')><li><a href="#request.self#?fuseaction=assetcare.list_assetp"><cf_get_lang_main no='2207.Fiziki Varlıklar'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'assetcare.list_vehicles')><li><a href="#request.self#?fuseaction=assetcare.list_vehicles"><cf_get_lang_main no='2.Araçlar'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'assetcare.list_asset_it')><li><a href="#request.self#?fuseaction=assetcare.list_asset_it"><cf_get_lang no='3.IT Varlıklar'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'assetcare.list_assetp_demands')><li><a href="#request.self#?fuseaction=assetcare.list_assetp_demands"><cf_get_lang_main no='115.Talepler'></a></li></cfif>
                    </ul>
                </li>
            </ul>
            <div class="pagemenus_clear"></div>
            <ul class="pagemenus">
                <li><strong><cf_get_lang no='394.Bakım yönetimi'></strong>
                    <ul>
                        <cfif not listfindnocase(denied_pages,'assetcare.list_assetp_period')><li><a href="#request.self#?fuseaction=assetcare.list_assetp_period"><cf_get_lang_main no='1885.Bakım Planı'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'assetcare.dsp_care_calender')><li><a href="#request.self#?fuseaction=assetcare.dsp_care_calender"><cf_get_lang_main no='2208.Bakım Takvimi'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'assetcare.list_asset_care')><li><a href="#request.self#?fuseaction=assetcare.list_asset_care"><cf_get_lang no='6.Bakım Sonuçları'></a></li></cfif>
                    </ul>
                </li>
            </ul>
        </div>
        <div style="float:left;">
            <ul class="pagemenus">
                <li><strong><cf_get_lang no='132.Km Kontrol'></strong>
                    <ul>
                        <cfif not listfindnocase(denied_pages,'assetcare.form_add_km')><li><a href="#request.self#?fuseaction=assetcare.list_vehicles&event=add_km"><cf_get_lang no='100.KM Kayıt'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'assetcare.form_search_km')><li><a href="#request.self#?fuseaction=assetcare.form_search_km"><cf_get_lang no='173.KM Arama'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'assetcare.vehicle_allocate')><li><a href="#request.self#?fuseaction=assetcare.vehicle_allocate"><cf_get_lang no='155.Araç Tahsis Kayıt'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'assetcare.vehicle_allocate_search')><li><a href="#request.self#?fuseaction=assetcare.vehicle_allocate_search"><cf_get_lang no='181.Araç Tahsis Arama'></a></li></cfif>
                    </ul>
                </li>
            </ul>
            <div class="pagemenus_clear"></div>
            <ul class="pagemenus">
                <li><strong><cf_get_lang no='468.Yakıt Kontrol'></strong>
                    <ul>
                        <cfif not listfindnocase(denied_pages,'assetcare.form_add_fuel')><li><a href="#request.self#?fuseaction=assetcare.form_add_fuel"><cf_get_lang no='198.Yakıt Kayıt'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'assetcare.form_search_fuel')><li><a href="#request.self#?fuseaction=assetcare.form_search_fuel"><cf_get_lang no='174.Yakıt Arama'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'assetcare.fuel_password')><li><a href="#request.self#?fuseaction=assetcare.fuel_password"><cf_get_lang no='151.Akaryakıt Şifreleri Kayıt'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'assetcare.form_search_fuel_password')><li><a href="#request.self#?fuseaction=assetcare.form_search_full_password"><cf_get_lang no='177.Akaryakıt Şifreleri Arama'></a></li></cfif>
                    </ul>
                </li>
            </ul>
            <div class="pagemenus_clear"></div>
            <ul class="pagemenus">
                <li><strong><cf_get_lang no='131.Kaza'>-<cf_get_lang no='133.Ceza'></strong>
                    <ul>
                        <cfif not listfindnocase(denied_pages,'assetcare.form_add_accident')><li><a href="#request.self#?fuseaction=assetcare.form_add_accident"><cf_get_lang no='106.Kaza Kayıt'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'assetcare.form_search_accident')><li><a href="#request.self#?fuseaction=assetcare.form_search_accident"><cf_get_lang no='175.Kaza Arama'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'assetcare.form_add_punishment')><li><a href="#request.self#?fuseaction=assetcare.form_add_punishment"><cf_get_lang no='150.Ceza Kayıt'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'assetcare.form_search_punishment')><li><a href="#request.self#?fuseaction=assetcare.form_search_punishment"><cf_get_lang no='176.Ceza Arama'></a></li></cfif>
                    </ul>
                </li>
             </ul>
             <div class="pagemenus_clear"></div>
            <ul class="pagemenus">
                <li><strong><cf_get_lang no='685.Yakıt-KM'></strong>
                    <ul>
                    	<cfif not listfindnocase(denied_pages,'assetcare.list_fuel_km')><li><a href="#request.self#?fuseaction=assetcare.list_fuel_km"><cf_get_lang no='686.Yakıt KM Arama'></a></li></cfif>
                    </ul>
                </li>
             </ul>
         </div>
         <div style="float:left;">
             <ul class="pagemenus">
                <li><strong><cf_get_lang no='125.Talep'></strong>
                    <ul>
                        <cfif not listfindnocase(denied_pages,'assetcare.add_vehicle_purchase_request')><li><a href="#request.self#?fuseaction=assetcare.add_vehicle_purchase_request"><cf_get_lang no='160.Alış Talebi'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'assetcare.add_vehicle_sales_request')><li><a href="#request.self#?fuseaction=assetcare.add_vehicle_sales_request"><cf_get_lang no='161.Satış Talebi'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'assetcare.add_vehicle_return_request')><li><a href="#request.self#?fuseaction=assetcare.add_vehicle_return_request"><cf_get_lang no='162.İade Talebi'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'assetcare.add_vehicle_exchange_request')><li><a href="#request.self#?fuseaction=assetcare.add_vehicle_exchange_request"><cf_get_lang no='163.Değiştirme Talebi'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'assetcare.vehicle_request_search')><li><a href="#request.self#?fuseaction=assetcare.vehicle_request_search"><cf_get_lang no='179.Talep Arama'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'assetcare.list_sales_price_proposition')><li><a href="#request.self#?fuseaction=assetcare.list_sales_price_proposition"><cf_get_lang no='537.Fiyat Önerisi'></a></li></cfif>		
                        <cfif not listfindnocase(denied_pages,'assetcare.list_sales_purchase_stuff')><li><a href="#request.self#?fuseaction=assetcare.list_sales_purchase_stuff"><cf_get_lang no='294.Araç Satış'></a></li></cfif>
                    </ul>
                </li>
             </ul>
             <div class="pagemenus_clear"></div>
             <ul class="pagemenus">
                <li><strong><cf_get_lang no='186.Nakliye'></strong>
                    <ul>
                        <cfif not listfindnocase(denied_pages,'assetcare.vehicle_transport')><li><a href="#request.self#?fuseaction=assetcare.vehicle_transport"><cf_get_lang no='157.Nakliye Kayıt'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'assetcare.vehicle_transport_search')><li><a href="#request.self#?fuseaction=assetcare.vehicle_transport_search"><cf_get_lang no='180.Nakliye Arama'></a></li></cfif>
                    </ul>
                </li>
             </ul>
         </div>
         <div style="float:left;">
             <ul class="pagemenus">
                <li><strong><cf_get_lang_main no='22.Rapor'></strong>
                    <ul>
                        <cfif not listfindnocase(denied_pages,'assetcare.list_ship_analysis')><li><a href="#request.self#?fuseaction=assetcare.list_ship_analysis"><cf_get_lang no='171.Sevkiyat Analizi'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'assetcare.asset_counting_report')><li><a href="#request.self#?fuseaction=assetcare.asset_counting_report"><cf_get_lang dictionary_id="47205.Sayım Raporu"></a></li></cfif>
                    </ul>
                </li>
             </ul>
             <div class="pagemenus_clear"></div>
             <ul class="pagemenus">
                <li><strong><cf_get_lang_main no='744.Diğer'></strong>
                    <ul>
                        <cfif not listfindnocase(denied_pages,'assetcare.vehicle_count_search')><li><a href="#request.self#?fuseaction=assetcare.vehicle_count_search"><cf_get_lang no='182.Araç Sayıları'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'assetcare.list_driving_licence')><li><a href="#request.self#?fuseaction=assetcare.form_search_driving_licence"><cf_get_lang no='178.Ehliyet Bilgisi Arama'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'assetcare.form_search_depot')><li><a href="#request.self#?fuseaction=assetcare.form_search_depot"><cf_get_lang no='184.Şube Arama'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'assetcare.form_add_assetcare')><li><a href="#request.self#?fuseaction=assetcare.form_add_assetcare"><cf_get_lang no='158.Bakım Kayıt'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'assetcare.vehicle_monthly_fuel_report')><li><a href="#request.self#?fuseaction=assetcare.vehicle_monthly_fuel_report"><cf_get_lang no='165.Aylık Yakıt Raporu'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'assetcare.vehicle_monthly_km_report')><li><a href="#request.self#?fuseaction=assetcare.vehicle_monthly_km_report"><cf_get_lang no='166.Aylık KM Raporu'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'assetcare.list_inventory_zimmet')><li><a href="#request.self#?fuseaction=assetcare.list_inventory_zimmet"><cf_get_lang no='657.Zimmet Kayıtları'></a></li></cfif>
                    </ul>
                </li>
             </ul>
         </div>
    </div>
</cfoutput>
<script src="../design/SpryAssets/left_menus/jquery.treeview.js" type="text/javascript"></script>
