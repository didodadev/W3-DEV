<cfoutput> 
    <div class="pagemenus_container">
    	<div style="float:left;">
			<cfif structkeyexists(fusebox.circuits,'prod')>
                <ul class="pagemenus">
                    <li><strong><cf_get_lang_main no="1720.Ürün Tasarım"></strong>
                        <ul>
                            <cfif not listfindnocase(denied_pages,'product.list_product')><li><a href="#request.self#?fuseaction=product.list_product"><cf_get_lang_main no="152.Ürünler"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.product_tree_designer')><li><a href="#request.self#?fuseaction=prod.product_tree_designer"><cf_get_lang no='342.Urun Agacı Tasarımı'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.list_product_tree')><li><a href="#request.self#?fuseaction=prod.list_product_tree"><cf_get_lang no="7.Agaclar"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'objects.popup_list_spect&spec_cat=1&only_list=1')><li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_spect&spec_cat=1&only_list=1','list');"><cf_get_lang_main no='235.Spec'></a></li></cfif>
                        </ul>
                    </li>
                </ul>
            </cfif>
            <cfif structkeyexists(fusebox.circuits,'prod')>
            	<div class="pagemenus_clear"></div>
                <ul class="pagemenus">
                    <li><strong><cf_get_lang no="22.Kalite"></strong>
                        <ul>
                            <cfif not listfindnocase(denied_pages,'settings.list_quality_control_types')><li><a href="#request.self#?fuseaction=settings.list_quality_control_types"><cf_get_lang no="685.Kalite Kontrol Kategorileri"></a></li></cfif>
                            <!--- <cfif not listfindnocase(denied_pages,'settings.popup_add_qualty_control_types')><li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=settings.popup_add_qualty_control_types','medium');"> <cf_get_lang no="686.Kalite Kontrol Tipi"></a></li></cfif> --->
                            <cfif not listfindnocase(denied_pages,'settings.add_production_quality_success')><li><a href="#request.self#?fuseaction=settings.add_production_quality_success"><cf_get_lang no='687.Kalite Başarımı'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.list_quality_controls')><li><a href="#request.self#?fuseaction=prod.list_quality_controls"><cf_get_lang no="688.Kalite İşlemleri"></a></li></cfif>
                        </ul>
                    </li>
                </ul>
            </cfif>
            <cfif structkeyexists(fusebox.circuits,'prod') and listgetat(session.ep.user_level, 40)>
                <div class="pagemenus_clear"></div>
                <ul class="pagemenus">
                    <li><strong><cf_get_lang no="689.Bakım Yönetimi"></strong>
                        <ul>
                            <cfif not listfindnocase(denied_pages,'assetcare.list_assetp_period')><li><a href="#request.self#?fuseaction=assetcare.list_assetp_period"><cf_get_lang_main no='1885.Bakım Planı'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'assetcare.form_add_care_period')><li><a href="#request.self#?fuseaction=assetcare.form_add_care_period"><cf_get_lang no="691.Bakım Planı Ekle"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'assetcare.list_asset_care')><li><a href="#request.self#?fuseaction=assetcare.list_asset_care"><cf_get_lang no="692.Bakım Sonuçları"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'assetcare.form_add_asset_care')><li><a href="#request.self#?fuseaction=assetcare.form_add_asset_care"><cf_get_lang no="693.Bakım Sonucu Ekle"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'assetcare.dsp_care_calender')><li><a href="#request.self#?fuseaction=assetcare.dsp_care_calender"><cf_get_lang_main no="2208.Bakım Takvimi"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'assetcare.list_asset_failure')><li><a href="#request.self#?fuseaction=assetcare.list_asset_failure"><cf_get_lang no="695.Arıza Bildirimi"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'assetcare.form_add_asset_failure')><li><a href="#request.self#?fuseaction=assetcare.form_add_asset_failure"><cf_get_lang no="696.Arıza Bildirimi Ekle"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'assetcare.form_add_expense_cost')><li><a href="#request.self#?fuseaction=assetcare.form_add_expense_cost"><cf_get_lang_main no='1847.Bakım Fişi'></a></li></cfif>
                        </ul>
                    </li>
                </ul>
            </cfif>	
        </div>
        <div style="float:left;">				
			<cfif structkeyexists(fusebox.circuits,'prod')>
                <ul class="pagemenus">
                    <li><strong><cf_get_lang_main no='711.Planlama'></strong>
                        <ul>
                            <cfif not listfindnocase(denied_pages,'prod.tracking')><li><a href="#request.self#?fuseaction=prod.tracking"><cf_get_lang no='2.Siparişler'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.demands')><li><a href="#request.self#?fuseaction=prod.demands"><cf_get_lang_main no='115.Talepler'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.add_prod_order&is_demand=1')><li><a href="#request.self#?fuseaction=prod.add_prod_order&is_demand=1"><cf_get_lang no="76.Talep Ekle"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.add_prod_order&is_demand=1&is_collacted=1')><li><a href="#request.self#?fuseaction=prod.add_prod_order&is_demand=1&is_collacted=1"> <cf_get_lang no="218.Toplu Talep Ekle"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.order')><li><a href="#request.self#?fuseaction=prod.order"><cf_get_lang no="55.Üretim Emirleri"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.add_prod_order')><li><a href="#request.self#?fuseaction=prod.add_prod_order"><cf_get_lang no="65.Üretim Emri Ekle"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.add_prod_order&is_collacted=1')><li><a href="#request.self#?fuseaction=prod.add_prod_order&is_collacted=1"> <cf_get_lang no="221.Toplu Üretim Emri Ekle"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.workstation_graph')><li><a href="#request.self#?fuseaction=prod.workstation_graph"> <cf_get_lang no="641.Üretim İstasyon Grafiği"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.graph_gant')><li><a href="#request.self#?fuseaction=prod.graph_gant"><cf_get_lang no="5.Çizelge"></a></li></cfif>
                        </ul>
                    </li>
                </ul>
            </cfif>
            <cfif structkeyexists(fusebox.circuits,'prod')>
                <div class="pagemenus_clear"></div>
                <ul class="pagemenus">
                    <li><strong><cf_get_lang no='329.Alternatif Yönetimi'>/<cf_get_lang no="330.Revizyon Yönetimi"></strong>
                        <ul>
                            <cfif not listfindnocase(denied_pages,'prod.list_alternative_questions')><li><a href="#request.self#?fuseaction=prod.list_alternative_questions"><cf_get_lang no='645.Alternatif Soruları'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.popup_add_alternative_questions')><li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.popup_add_alternative_questions','medium');"><cf_get_lang no="698.Alternatif Sorusu Ekle"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.demands')><li><a href="#request.self#?fuseaction=prod.manage_alternative_questions"> <cf_get_lang no="329.Alternatif Yönetimi"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.add_prod_order&is_demand=1')><li><a href="#request.self#?fuseaction=prod.manage_product_tree"> <cf_get_lang no="330.Revizyon Yönetimi"></a></li></cfif>
                        </ul>
                    </li>
                </ul>
            </cfif>	
        </div>	
        <div style="float:left;">		
			<cfif structkeyexists(fusebox.circuits,'prod')>
                 <ul class="pagemenus">
                    <li><strong><cf_get_lang no="6.Malzeme"></strong>
                        <ul>
                            <cfif not listfindnocase(denied_pages,'stock.list_departments')><li><a href="#request.self#?fuseaction=stock.list_departments"><cf_get_lang_main no='1351.Depo'> / <cf_get_lang_main no='250.Alan'> / <cf_get_lang no='401.Raf'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'stock.list_stock')><li><a href="#request.self#?fuseaction=stock.list_stock"><cf_get_lang_main no="754.Stoklar"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.list_materials_total')><li><a href="#request.self#?fuseaction=prod.list_materials_total"><cf_get_lang no="250.Üretim Malzeme İhtiyaçları"></a></li></cfif>
                        </ul>
                    </li>
                </ul>
            </cfif>
            <cfif structkeyexists(fusebox.circuits,'prod')>
            	<div class="pagemenus_clear"></div>
                <ul class="pagemenus">
                    <li><strong><cf_get_lang_main no='846.Maliyet'></strong>
                        <ul>
                            <cfif not listfindnocase(denied_pages,'product.list_product_cost')><li><a href="#request.self#?fuseaction=product.list_product_cost"><cf_get_lang no="154.Ürün Maliyetleri"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.product_cost_rate_paper')><li><a href="#request.self#?fuseaction=account.product_cost_rate_paper"><cf_get_lang no="404.Üretim Maliyetleri Yansıtma"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.product_labor_cost_paper')><li><a href="#request.self#?fuseaction=account.product_labor_cost_paper"><cf_get_lang no="410.Üretim İşçilik Maliyetleri Yansıtma"></a></li></cfif>
                        </ul>
                   </li>
               </ul>
            </cfif>
            <cfif structkeyexists(fusebox.circuits,'prod')>
            	<div class="pagemenus_clear"></div>
                <ul class="pagemenus">
                    <li><strong><cf_get_lang_main no='2807.E-Furniture'> <cf_get_lang_main no='365.İşlemler'></strong>
                        <ul>
                            <cfif not listfindnocase(denied_pages,'prod.list_ezgi_product_tree_creative')><li><a href="#request.self#?fuseaction=prod.list_ezgi_product_tree_creative"><cf_get_lang_main no='567.Özel'> <cf_get_lang_main no='1995.Tasarım'></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.product_cost_rate_paper')><li><a href="#request.self#?fuseaction=prod.list_ezgi_master_plan"><cf_get_lang_main no='3044.Master Planlama'> </a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.popup_ezgi_design_default_export')><li><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=prod.popup_ezgi_design_default_export','small');">Default <cf_get_lang_main no='144.Bilgi'> Export</a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.list_ezgi_iflow_order')><li><a href='#request.self#?fuseaction=prod.list_ezgi_iflow_order'>I Flow <cf_get_lang_main no='795.Satış Siparişleri'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.list_ezgi_iflow_production_order')><li><a href='#request.self#?fuseaction=prod.list_ezgi_iflow_master_plan'>I Flow <cf_get_lang_main no='1052.Üretim Planlama'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.list_ezgi_iflow_stocks')><li><a href='#request.self#?fuseaction=prod.list_ezgi_iflow_stocks'>I Flow <cf_get_lang_main no='754.Stoklar'></a></li></cfif>	
			    <cfif not listfindnocase(denied_pages,'prod.list_ezgi_iflow_stock_actions')><li><a href='#request.self#?fuseaction=prod.list_ezgi_iflow_stock_actions'>I Flow <cf_get_lang_main no='3045.Stok Hareketleri'></a></li></cfif>	
			</ul>
                   </li>
               </ul>
            </cfif>
            <cfif structkeyexists(fusebox.circuits,'prod')>
            	<div class="pagemenus_clear"></div>
                <ul class="pagemenus">
                    <li><strong><cf_get_lang_main no='2807.E-Furniture'> <cf_get_lang_main no='117.Tanımlar'> </strong>
                        <ul>
                            <cfif not listfindnocase(denied_pages,'prod.list_ezgi_default_color')><li><a href="#request.self#?fuseaction=prod.list_ezgi_default_color"><cf_get_lang_main no='2835.Renk Tanımları'></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.list_ezgi_default_thickness')><li><a href="#request.self#?fuseaction=prod.list_ezgi_default_thickness"><cf_get_lang_main no='2878.Kalınlık'> <cf_get_lang_main no='2935.Tanımları'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.list_ezgi_default_main')><li><a href="#request.self#?fuseaction=prod.list_ezgi_default_main">Default <cf_get_lang_main no='2944.Modül'> <cf_get_lang_main no='2935.Tanımları'></a></li></cfif>

                            <cfif not listfindnocase(denied_pages,'prod.list_ezgi_default_piece')><li><a href="#request.self#?fuseaction=prod.list_ezgi_default_piece">Default <cf_get_lang_main no='2848.Parça'> <cf_get_lang_main no='2935.Tanımları'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.upd_ezgi_general_default_defination')><li><a href="#request.self#?fuseaction=prod.upd_ezgi_general_default_defination"><cf_get_lang_main no='2157.Genel'> Default <cf_get_lang_main no='117.Tanımlar'></a></li></cfif>
                        </ul>
                   </li>
               </ul>
            </cfif>
        </div>
        <div style="float:left;">
			<cfif structkeyexists(fusebox.circuits,'prod')>
                <ul class="pagemenus">
                    <li><strong><cf_get_lang no="220.Üretim Takibi"></strong>
                        <ul>
                            <cfif not listfindnocase(denied_pages,'prod.in_productions')><li><a href="#request.self#?fuseaction=prod.in_productions"><cf_get_lang_main no="1400.Üretimdekiler"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.list_results')><li><a href="#request.self#?fuseaction=prod.list_results"><cf_get_lang no="563.Üretim Emir Sonuçları"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'production.welcome')><li><a href="#request.self#?fuseaction=production.welcome"><cf_get_lang no="417.Operatör Ekranı"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.graph_gant')><li><a href="#request.self#?fuseaction=prod.graph_gant"><cf_get_lang no="5.Çizelge"></a></li></cfif>
                        </ul>
                    </li>
                </ul>
            </cfif>
            <cfif structkeyexists(fusebox.circuits,'prod')>
            	 <div class="pagemenus_clear"></div>
                 <ul class="pagemenus">
                    <li><strong><cf_get_lang_main no="117.Tanımlar"></strong>
                        <ul>
                            <cfif not listfindnocase(denied_pages,'prod.list_definition')><li><a href="#request.self#?fuseaction=prod.list_definition"><cf_get_lang no="13.İş İstasyonları"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.popup_add_workstation')><li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.popup_add_workstation','wide');"><cf_get_lang no="14.İş İstasyonu Ekle"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.list_operationtype')><li><a href="#request.self#?fuseaction=prod.list_operationtype"><cf_get_lang no="63.Operasyonlar"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.add_operationtype')><li><a href="#request.self#?fuseaction=prod.add_operationtype"><cf_get_lang no="67.Operasyon Ekle"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.list_property')><li><a href="#request.self#?fuseaction=prod.list_property"><cf_get_lang_main no="1498.Özellikler"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.add_property_main')><li><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=prod.popup_add_property_main','small')"><cf_get_lang no="326.Özellik Ekle"></a></li></cfif>					
                            <cfif not listfindnocase(denied_pages,'prod.prod.list_ws_time')><li><a href="#request.self#?fuseaction=prod.list_ws_time"><cf_get_lang no="482.Çalışma Programı"></a></li></cfif>					
                            <cfif not listfindnocase(denied_pages,'ehesap.popup_form_add_shift&is_production=1')><li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_form_add_shift&is_production=1','list');"><cf_get_lang no="419.Vardiya Ekle"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'settings.form_add_prod_pause_cat')><li><a href="#request.self#?fuseaction=settings.form_add_prod_pause_cat"><cf_get_lang_main no='1678.Duraklama Kategorisi'> <cf_get_lang_main no='170.Ekle'></a></li></cfif>					
                            <cfif not listfindnocase(denied_pages,'prod.list_prod_pause_type')><li><a href="#request.self#?fuseaction=prod.list_prod_pause_type"><cf_get_lang no="425.Duraklama Tipleri"></a></li></cfif>					
                            <cfif not listfindnocase(denied_pages,'prod.popup_add_prod_pause_type')><li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.popup_add_prod_pause_type','medium');"><cf_get_lang no="428.Duraklama Tipi Ekle"></a></li></cfif>
                       </ul>
                    </li>
                </ul>
            </cfif>
        </div>
    </cfoutput> 
</div>
<script src="../design/SpryAssets/left_menus/jquery.treeview.js" type="text/javascript"></script>