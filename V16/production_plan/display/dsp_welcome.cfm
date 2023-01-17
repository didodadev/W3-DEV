<cfoutput> 
    <div class="pagemenus_container">
        <cf_box>
            <div class="form_group col col-3 col-md-3 col-xs-12">
                <cfif fusebox.circuit contains 'prod'>
                    <ul class="pagemenus">
                        <cfsavecontent variable="head_1"><cf_get_lang dictionary_id="29517.Ürün Tasarım"></cfsavecontent>
                        <cf_box title="#head_1#">
                            <cfif not listfindnocase(denied_pages,'product.list_product')><li><a href="#request.self#?fuseaction=product.list_product"><cf_get_lang dictionary_id="57564.Ürünler"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.product_tree_designer')><li><a href="#request.self#?fuseaction=prod.product_tree_designer"><cf_get_lang dictionary_id='36655.Urun Agacı Tasarımı'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.list_product_tree')><li><a href="#request.self#?fuseaction=prod.list_product_tree"><cf_get_lang dictionary_id="36320.Agaclar"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'objects.popup_list_spect&spec_cat=1&only_list=1')><li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_spect&spec_cat=1&only_list=1','list');"><cf_get_lang dictionary_id='57647.Spec'></a></li></cfif>
                        </cf_box>
                    </ul>
                </cfif>
                <cfif fusebox.circuit contains 'prod'>
                    <div class="pagemenus_clear"></div>
                    <ul class="pagemenus">
                        <cfsavecontent variable="head_2"><cf_get_lang dictionary_id="36335.Kalite"></cfsavecontent>
                        <cf_box title="#head_2#">
                            <cfif not listfindnocase(denied_pages,'settings.list_quality_control_types')><li><a href="#request.self#?fuseaction=settings.list_quality_control_types"><cf_get_lang dictionary_id="36998.Kalite Kontrol Kategorileri"></a></li></cfif>
                
                            <cfif not listfindnocase(denied_pages,'settings.add_production_quality_success')><li><a href="#request.self#?fuseaction=settings.add_production_quality_success"><cf_get_lang dictionary_id='37000.Kalite Başarımı'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.list_quality_controls')><li><a href="#request.self#?fuseaction=prod.list_quality_controls"><cf_get_lang dictionary_id="37001.Kalite İşlemleri"></a></li></cfif>
                        </cf_box>
                    </ul>
                </cfif>
                <cfif get_module_user(40)>
                    <div class="pagemenus_clear"></div>
                    <ul class="pagemenus">
                        <cfsavecontent variable="head_3"><cf_get_lang dictionary_id="37002.Bakım Yönetimi"></cfsavecontent>
                        <cf_box title="#head_3#">
                            <cfif not listfindnocase(denied_pages,'assetcare.list_assetp_period')><li><a href="#request.self#?fuseaction=assetcare.list_assetp_period"><cf_get_lang dictionary_id='29682.Bakım Planı'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'assetcare.form_add_care_period')><li><a href="#request.self#?fuseaction=assetcare.form_add_care_period"><cf_get_lang dictionary_id="37004.Bakım Planı Ekle"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'assetcare.list_asset_care')><li><a href="#request.self#?fuseaction=assetcare.list_asset_care"><cf_get_lang dictionary_id="37005.Bakım Sonuçları"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'assetcare.form_add_asset_care')><li><a href="#request.self#?fuseaction=assetcare.form_add_asset_care"><cf_get_lang dictionary_id="37006.Bakım Sonucu Ekle"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'assetcare.dsp_care_calender')><li><a href="#request.self#?fuseaction=assetcare.dsp_care_calender"><cf_get_lang dictionary_id="30005.Bakım Takvimi"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'assetcare.list_asset_failure')><li><a href="#request.self#?fuseaction=assetcare.list_asset_failure"><cf_get_lang dictionary_id="37008.Arıza Bildirimi"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'assetcare.form_add_asset_failure')><li><a href="#request.self#?fuseaction=assetcare.form_add_asset_failure"><cf_get_lang dictionary_id="37009.Arıza Bildirimi Ekle"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'assetcare.form_add_expense_cost')><li><a href="#request.self#?fuseaction=assetcare.form_add_expense_cost"><cf_get_lang dictionary_id='29644.Bakım Fişi'></a></li></cfif>
                        </cf_box>
                    </ul>
                </cfif>	
            </div>
            <div class="form_group col col-3 col-md-3 col-xs-12">				
                <cfif fusebox.circuit contains 'prod'>
                    <ul class="pagemenus">
                        <cfsavecontent variable="head_4"><cf_get_lang dictionary_id='58123.Planlama'></cfsavecontent>
                        <cf_box title="#head_4#">
                            <cfif not listfindnocase(denied_pages,'prod.tracking')><li><a href="#request.self#?fuseaction=prod.tracking"><cf_get_lang dictionary_id='36315.Siparişler'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.demands')><li><a href="#request.self#?fuseaction=prod.demands"><cf_get_lang dictionary_id='57527.Talepler'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.demands&is_demand=1')><li><a href="#request.self#?fuseaction=prod.demands&event=add&is_demand=1"><cf_get_lang dictionary_id="36389.Talep Ekle"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.demands&is_demand=1&is_collacted=1')><li><a href="#request.self#?fuseaction=prod.demands&event=multi-add&is_demand=1&is_collacted=1"> <cf_get_lang dictionary_id="36531.Toplu Talep Ekle"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.order')><li><a href="#request.self#?fuseaction=prod.order"><cf_get_lang dictionary_id="36368.Üretim Emirleri"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.add_prod_order')><li><a href="#request.self#?fuseaction=production.list_production_orders&event=add"><cf_get_lang dictionary_id="36378.Üretim Emri Ekle"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.add_prod_order&is_collacted=1')><li><a href="#request.self#?fuseaction=production.list_production_orders&event=multi-add&is_collacted=1"> <cf_get_lang dictionary_id="36534.Toplu Üretim Emri Ekle"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.workstation_graph')><li><a href="#request.self#?fuseaction=prod.workstation_graph"> <cf_get_lang dictionary_id="36954.Üretim İstasyon Grafiği"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.graph_gant')><li><a href="#request.self#?fuseaction=prod.graph_gant"><cf_get_lang dictionary_id="36318.Çizelge"></a></li></cfif>
                        </cf_box>
                    </ul>
                </cfif>
                <cfif fusebox.circuit contains 'prod'>
                    <div class="pagemenus_clear"></div>
                    <ul class="pagemenus">
                        <cfsavecontent variable="head_5"><cf_get_lang dictionary_id='36642.Alternatif Yönetimi'>/<cf_get_lang dictionary_id="36643.Revizyon Yönetimi"></cfsavecontent>
                        <cf_box title="#head_5#">
                            <cfif not listfindnocase(denied_pages,'prod.list_alternative_questions')><li><a href="#request.self#?fuseaction=prod.list_alternative_questions"><cf_get_lang dictionary_id='36958.Alternatif Soruları'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.popup_add_alternative_questions')><li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.list_alternative_questions&event=add','medium');"><cf_get_lang dictionary_id="37011.Alternatif Sorusu Ekle"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.demands')><li><a href="#request.self#?fuseaction=prod.manage_alternative_questions"> <cf_get_lang dictionary_id="36642.Alternatif Yönetimi"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.add_prod_order&is_demand=1')><li><a href="#request.self#?fuseaction=prod.manage_product_tree"> <cf_get_lang dictionary_id="36643.Revizyon Yönetimi"></a></li></cfif>
                        </cf_box>
                    </ul>
                </cfif>	
            </div>	
            <div class="form_group col col-3 col-md-3 col-xs-12">		
                <cfif fusebox.circuit contains 'prod'>
                    <ul class="pagemenus">
                        <cfsavecontent variable="head_6"><cf_get_lang dictionary_id="36319.Malzeme"></cfsavecontent>
                        <cf_box title="#head_6#">
                            <cfif not listfindnocase(denied_pages,'stock.list_departments')><li><a href="#request.self#?fuseaction=stock.list_departments"><cf_get_lang dictionary_id='58763.Depo'> / <cf_get_lang dictionary_id='57662.Alan'> / <cf_get_lang dictionary_id='36714.Raf'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'stock.list_stock')><li><a href="#request.self#?fuseaction=stock.list_stock"><cf_get_lang dictionary_id="58166.Stoklar"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.list_materials_total')><li><a href="#request.self#?fuseaction=prod.list_materials_total"><cf_get_lang dictionary_id="36563.Üretim Malzeme İhtiyaçları"></a></li></cfif>
                        </cf_box>
                    </ul>
                </cfif>
                <cfif fusebox.circuit contains 'prod'>
                    <div class="pagemenus_clear"></div>
                    <ul class="pagemenus">
                        <cfsavecontent variable="head_7"><cf_get_lang dictionary_id='58258.Maliyet'></cfsavecontent>
                        <cf_box title="#head_7#">
                            <cfif not listfindnocase(denied_pages,'product.list_product_cost')><li><a href="#request.self#?fuseaction=product.list_product_cost"><cf_get_lang dictionary_id="30074.Ürün Maliyetleri"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.product_cost_rate_paper')><li><a href="#request.self#?fuseaction=account.product_cost_rate_paper"><cf_get_lang dictionary_id="36717.Üretim Maliyetleri Yansıtma"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.product_labor_cost_paper')><li><a href="#request.self#?fuseaction=account.product_labor_cost_paper"><cf_get_lang dictionary_id="36723.Üretim İşçilik Maliyetleri Yansıtma"></a></li></cfif>
                        </cf_box>
                    </ul>
                </cfif>
            </div>
            <div class="form_group col col-3 col-md-3 col-xs-12">
                <cfif fusebox.circuit contains 'prod'>
                    <ul class="pagemenus">
                        <cfsavecontent variable="head_8"><cf_get_lang dictionary_id="36533.Üretim Takibi"></cfsavecontent>
                        <cf_box title="#head_8#">
                            <cfif not listfindnocase(denied_pages,'prod.in_productions')><li><a href="#request.self#?fuseaction=prod.in_productions"><cf_get_lang dictionary_id="58812.Üretimdekiler"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.list_results')><li><a href="#request.self#?fuseaction=prod.list_results"><cf_get_lang dictionary_id="36876.Üretim Emir Sonuçları"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'production.welcome')><li><a href="#request.self#?fuseaction=production.welcome"><cf_get_lang dictionary_id="36730.Operatör Ekranı"></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'prod.graph_gant')><li><a href="#request.self#?fuseaction=prod.graph_gant"><cf_get_lang dictionary_id="36318.Çizelge"></a></li></cfif>
                        </cf_box>
                    </ul>
                </cfif>
                <cfif fusebox.circuit contains 'prod'>
                    <div class="pagemenus_clear"></div>
                        <ul class="pagemenus">
                            <cfsavecontent variable="head_9"><cf_get_lang dictionary_id="57529.Tanımlar"></cfsavecontent>
                            <cf_box title="#head_9#">
                                <cfif not listfindnocase(denied_pages,'prod.list_workstation')><li><a href="#request.self#?fuseaction=prod.list_workstation"><cf_get_lang dictionary_id="36326.İş İstasyonları"></a></li></cfif>
                                <cfif not listfindnocase(denied_pages,'prod.popup_add_workstation')><li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.popup_add_workstation','wide');"><cf_get_lang dictionary_id="36327.İş İstasyonu Ekle"></a></li></cfif>
                                <cfif not listfindnocase(denied_pages,'prod.list_operationtype')><li><a href="#request.self#?fuseaction=prod.list_operationtype"><cf_get_lang dictionary_id="36376.Operasyonlar"></a></li></cfif>
                                <cfif not listfindnocase(denied_pages,'prod.add_operationtype')><li><a href="#request.self#?fuseaction=prod.add_operationtype"><cf_get_lang dictionary_id="36380.Operasyon Ekle"></a></li></cfif>
                                <cfif not listfindnocase(denied_pages,'prod.list_property')><li><a href="#request.self#?fuseaction=prod.list_property"><cf_get_lang dictionary_id="58910.Özellikler"></a></li></cfif>
                                <cfif not listfindnocase(denied_pages,'prod.add_property_main')><li><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=prod.popup_add_property_main','small')"><cf_get_lang dictionary_id="36639.Özellik Ekle"></a></li></cfif>					
                                <cfif not listfindnocase(denied_pages,'prod.prod.list_ws_time')><li><a href="#request.self#?fuseaction=prod.list_ws_time"><cf_get_lang dictionary_id="36795.Çalışma Programı"></a></li></cfif>					
                                <cfif not listfindnocase(denied_pages,'ehesap.popup_form_add_shift&is_production=1')><li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_form_add_shift&is_production=1','list');"><cf_get_lang dictionary_id="36732.Vardiya Ekle"></a></li></cfif>
                                <cfif not listfindnocase(denied_pages,'settings.form_add_prod_pause_cat')><li><a href="#request.self#?fuseaction=settings.form_add_prod_pause_cat"><cf_get_lang dictionary_id='29475.Duraklama Kategorisi'> <cf_get_lang dictionary_id='57582.Ekle'></a></li></cfif>					
                                <cfif not listfindnocase(denied_pages,'prod.list_prod_pause_type')><li><a href="#request.self#?fuseaction=prod.list_prod_pause_type"><cf_get_lang dictionary_id="36738.Duraklama Tipleri"></a></li></cfif>					
                                <cfif not listfindnocase(denied_pages,'prod.popup_add_prod_pause_type')><li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.popup_add_prod_pause_type','medium');"><cf_get_lang dictionary_id="36741.Duraklama Tipi Ekle"></a></li></cfif>
                            </cf_box>
                        </ul>
                </cfif>
            </div>
        </cf_box>   	
    </div>
</cfoutput> 
<script src="../design/SpryAssets/left_menus/jquery.treeview.js" type="text/javascript"></script>
