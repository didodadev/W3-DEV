<!--- 
    Author: Uğur Hamurpet
    Date:   11/04/2021
    Desc:   Spekt ve konfigüratör modalı. Basket üzerinden spekt modalı açıldığında çalışır.
            İçerisinde Ürün ağacı, Karma koli, Ürün özellikleri, Kalite-Test Parametrelerini barındırır.
            XML Spec Tipi ayarları göre çalışır. ( x_is_spec_type )
            Aşağıdaki ayarlara göre görüntülenecek bölümler tarif edilmiştir.
            1: Ürün Ağacı ve Özelliklerden Oluşan Spec Sayfası ( Ürün ağacı / Karma Koli, Ürün Özellikleri / Özellikler - İşlemler, Kalite-Test Parametreleri, Özelleştirme ve fiyatlama bilgisi )
            2: Alternatif Sorulardan Oluşan Spec Sayfası ( Alternatif Ürünler, Özelleştirme ve fiyatlama bilgisi )
            3: Özelliklerden Oluşan Spec Sayfası ( Ürün ağacı / Karma Koli, Ürün Özellikleri / Özellikler - İşlemler, Kalite-Test Parametreleri, Özelleştirme ve fiyatlama bilgisi )
            4: Alternatif ve Özelliklerden Oluşan Spec Sayfası ( Ürün ağacı / Karma Koli, Ürün Özellikleri / Özellikler - İşlemler, Kalite-Test Parametreleri, Özelleştirme ve fiyatlama bilgisi )
--->


<cf_xml_page_edit>

<cfparam name="attributes.tab_id" type="string" default="configurator">
<cfparam name="attributes.configuratorWidgetParameter" type="string" default=""><!--- Konfigüratör widget olarak yükleniyorsa, widget'a gönderilecek parametreler string olarak tanımlanır. --->
<cfparam name="no_count" type="numeric" default="0"><!--- configurator_alternative_products.cfm dosyasında kullanılır. Default 0 atanmalıdır --->
<cfparam name="is_mix_product" type="boolean" default="0"><!--- Konfigüratör ayarlarında origin değeri Karma Koliyi yeniden düzenleyerek özelleştir olarak seçilmişse 1 olarak atanır. Amacı; ürün ağacı ve alternatif soruda aranan sadace özelleştirilebilir ürün için spekt oluşturulabilir zorunluluğunu ortadan kaldırmaktır. --->

<cfinclude  template="configurator_definitions.cfm">
<cfif isdefined("attributes.id")>
<cfquery name="get_product_confid" datasource="#dsn3#">
     SELECT PRODUCT_CONFIGURATOR_ID FROM SPECTS 
     WHERE SPECT_VAR_ID= <cfqueryparam value = "#attributes.id#" CFSQLType = "cf_sql_integer">
</cfquery>
</cfif>
<cfquery name="get_conf" datasource="#dsn3#">
    SELECT
        SPC.*,
        W.WIDGET_FRIENDLY_NAME
    FROM SETUP_PRODUCT_CONFIGURATOR AS SPC
    LEFT JOIN #dsn#.WRK_WIDGET AS W ON SPC.WIDGET_ID = W.WIDGETID
    WHERE 
        SPC.IS_ACTIVE = 1 
<cfif attributes.type eq 'upd' and len(get_product_confid.PRODUCT_CONFIGURATOR_ID)>
           AND SPC.PRODUCT_CONFIGURATOR_ID=<cfqueryparam value = "#get_product_confid.PRODUCT_CONFIGURATOR_ID#" CFSQLType = "cf_sql_integer">
<cfelseif not isdefined("attributes.from_product_config") >
        AND 
        (
            SPC.CONFIGURATOR_STOCK_ID = <cfqueryparam value = "#attributes.stock_id#" CFSQLType = "cf_sql_integer">
            <cfif len(GET_PRODUCT.BRAND_ID)><!--- Markaya göre konfigüratör oluşturulmuşsa --->
                OR SPC.BRAND_ID = <cfqueryparam value = "#GET_PRODUCT.BRAND_ID#" CFSQLType = "cf_sql_integer">
            </cfif>
            <cfif len(GET_PRODUCT.PRODUCT_CATID)><!--- Ürün kategorisine göre konfigüratör oluşturulmuşsa --->
                OR SPC.PRODUCT_CAT_ID = <cfqueryparam value = "#GET_PRODUCT.PRODUCT_CATID#" CFSQLType = "cf_sql_integer">
            </cfif>
        )
        <cfelse>
           AND SPC.PRODUCT_CONFIGURATOR_ID=<cfqueryparam value = "#attributes.config_id#" CFSQLType = "cf_sql_integer">
     </cfif>
</cfquery>
<cfif x_is_spec_type eq 1 or x_is_spec_type eq 3 or (x_is_spec_type eq 4 and get_product_info.is_production neq 1)>
    <cfset formAction = "#request.self#?fuseaction=objects.emptypopup_upd_spect_query_new#url_str#" />
<cfelse>
    <cfset formAction = "#request.self#?fuseaction=objects.popup_addSpecFromAlternativeProduct#url_str#" />
</cfif>
<cfif not isdefined("attributes.from_product_config")>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title = "#getLang(dictionary_id:34299)#" popup_box = "1">
        <cf_tab defaultOpen="#attributes.tab_id#" divId="configurator,mpc_spect" divLang="#getLang('','Konfigüratör',33920)#;MPC Spekt">
            <div id="unique_configurator" class="uniqueBox">
                <cfform  name="add_spect_variations" action="#formAction#" method="post" enctype="multipart/form-data">
                   <cfoutput>
                        <div class="row">
                            <div class="ui-info-text">
                                <ul>
                                    <li><b><cf_get_lang dictionary_id ='57657.Ürün'>:</b> #_deep_level_main_product_name_0#</li>
                                    <li><b><cf_get_lang dictionary_id ='57647.Spec'>:</b> #main_spec_id_0#<cfif isdefined('attributes.id') and len(attributes.id)> - #attributes.id#</cfif></li>
                                </ul>
                            </div>
                        </div>
                    </cfoutput>
                    <cfset attributes.main_config=1>
                    <cfinclude  template="../../product/form/product_configurator.cfm">
                    <cfif len( get_conf.WIDGET_FRIENDLY_NAME )>
                        <div class="row" id="configurator_widget">
                        </div>
                    </cfif>
                     <cf_box_elements> 
                    <cfif x_is_spec_type eq 1 or x_is_spec_type eq 3 or (x_is_spec_type eq 4 and get_product_info.is_production neq 1)>
                        <cfif get_conf.recordcount>
                            <cfinput type="hidden" name="product_configurator_id" id="product_configurator_id" value="#get_conf.PRODUCT_CONFIGURATOR_ID#">
                          
                                <div class="row">
                                    <cfif get_conf.ORIGIN eq 1 or (len(get_conf.USE_COMPONENT) and get_conf.USE_COMPONENT and get_conf.ORIGIN eq 3)>
                                        <cf_seperator id="conf_product_tree" header="#getLang(dictionary_id: 36365)#" closeForGrid="1">
                                        <div class="col col-12" id="conf_product_tree" style="display:none;">
                                            <cfif attributes.type eq 'add'><!--- spect ekleme --->
                                                <cfinclude  template="add_configurator_spect_new.cfm">
                                            <cfelse><!--- spect güncelle --->
                                                <cfinclude  template="upd_configurator_spect_new.cfm">
                                            </cfif>
                                        </div>
                                    <cfelseif get_conf.ORIGIN eq 2><!--- Karma Koliyi yeniden düzenleyerek özelleştir  --->
                                        <cfset is_mix_product = 1 />
                                        <cf_seperator id="configurator_mixed_parcel" header="#getLang(dictionary_id: 37467)#" closeForGrid="1">
                                        <div class="col col-12" id="configurator_mixed_parcel" <!--- style="display:none;" --->>
                                            <cfif attributes.type eq 'add'><!--- spect ekleme --->
                                                <cfinclude  template="add_configurator_mixed_parcel.cfm">
                                            <cfelse><!--- spect güncelle --->
                                                <cfinclude  template="upd_configurator_mixed_parcel.cfm">
                                            </cfif>
                                        </div>
                                    <cfelse>
                                        <cfinput type="hidden" name="is_tree" id="is_tree" value="0">
                                    </cfif>
                                </div>
                            <cfif get_conf.ORIGIN eq 3 and get_conf.USE_FEATURE eq 1>
                                <div class="row">
                                    <cf_seperator id="configurator_property" header="#getLang('','Özellikler',59106)# / #getLang('','Varyasyonlar',37249)# / #getLang('','İhtiyaçlar',36437)#" closeForGrid="1">
                                    <div id="configurator_property" style="display:none;">
                                        <cfinclude template="configurator_property.cfm">
                                    </div>
                                </div>
                                </cfif>
                                <cfif get_conf.ORIGIN eq 3 and get_conf.USE_TEST_PARAMETER eq 1>
                                <div class="row">
                                    <cf_seperator id="configurator_test_parameter" header="#getLang('','Kalite-Test Parametreleri',62473)#" closeForGrid="1">
                                    <div id="configurator_test_parameter" style="display:none;">
                                        <cfinclude  template="configurator_test_parameter.cfm">
                                    </div>
                                </div>
                            </cfif>
                        <cfelse>
                            <div class="row">
                                <cf_seperator id="conf_product_tree" header="#getLang(dictionary_id: 36365)#" closeForGrid="1">
                                <div class="col col-12" id="conf_product_tree" style="display:none;">
                                    <cfif attributes.type eq 'add'><!--- spect ekleme --->
                                        <cfinclude  template="add_configurator_spect_new.cfm">
                                    <cfelse><!--- spect güncelle --->
                                        <cfinclude  template="upd_configurator_spect_new.cfm">
                                    </cfif>
                                </div>
                            </div>
                        </cfif>
                    <cfelseif x_is_spec_type eq 2 or (x_is_spec_type eq 4 and get_product_info.is_production eq 1)>
                        <div class="row">
                            <cf_seperator id="configurator_alternative_products" header="#GET_PRICE.IS_GIFT_CARD eq 1 ? getLang('', 'Main Spect Seçimi', 33259) : getLang('', 'Alternatif Ürünler', 32776)#">
                            <div id="configurator_alternative_products" style="display:none;">
                                <cfinclude template="configurator_alternative_products.cfm">
                            </div>
                        </div>
                    </cfif>
                    <cfif x_is_spec_type eq 3 and isdefined("is_show_property_and_calculate") and is_show_property_and_calculate eq 1>
                        <div class="row">
                            <input type="hidden" name="is_old_style" id="is_old_style" value="1">
                            <cf_seperator id="configurator_property_old" header="#getLang('','Özellikler/İşlemler',33722)#" closeForGrid="1">
                            <div id="configurator_property_old" style="display:none;">
                                <cfinclude template="configurator_property_calculate.cfm">
                            </div>
                        </div>
                    </cfif>
                    <div class="row">
                        <cf_seperator id="configurator_special_information" header="#getLang('','Özelleştirme ve fiyatlama bilgisi',62509)#" closeForGrid="1">
                        <div id="configurator_special_information" style="display:none;">
                            <cfif attributes.type eq 'add'><!--- spect ekleme --->
                                <cfinclude  template="add_configurator_special_information.cfm">
                            <cfelse><!--- spect güncelle --->
                                <cfinclude  template="upd_configurator_special_information.cfm">
                            </cfif>
                        </div>
                    </div>
                </cf_box_elements>
                    <cf_box_footer>
                        <cfif GET_PRODUCT.IS_PROTOTYPE eq 1 or is_mix_product eq 1>
                            <cfif no_count eq 0>
                                <cfif attributes.type eq 'add'>
                                    <cf_workcube_buttons is_upd='0' is_delete='0' add_function="configurator_control() && loadPopupBox('add_spect_variations','#attributes.modal_id#')">
                                <cfelse>
                                    <div class="col col-8 col-xs-12">
                                        <cf_record_info query_name="GET_SPECT">
                                    </div>
                                    <div class="col col-4 col-xs-12">
                                        <cf_workcube_buttons is_upd='1' is_delete='0' add_function="configurator_control() && loadPopupBox('add_spect_variations','#attributes.modal_id#')">
                                    </div>
                                </cfif>
                            <cfelse>
                                <div class="col col-12 ui-card"><div class="ui-card-item"><font color="FF0000"><cf_get_lang dictionary_id='60232.Eksik Alternatif Tanımları Olduğu için Spec Kaydedemezsiniz'> !</font></div></div>
                            </cfif>
                        <cfelse>
                            <div class="col col-12 ui-card"><div class="ui-card-item"><font color="FF0000"><cf_get_lang dictionary_id="33260.Ürün Özelleştirilebilir Olmadığı İçin Spec Kaydedemezsiniz"> !</font></div></div>
                        </cfif>
                    </cf_box_footer>
                </cfform>
            </div>
            <div id="unique_mpc_spect" class="uniqueBox">
                <div class="row">
                    <cfinclude  template="../display/configurator_spect.cfm">
                </div>
            </div>
        </cf_tab>
    </cf_box>
</div>

<cfelse>
    <cfif len( get_conf.WIDGET_FRIENDLY_NAME )>
        <div class="row" id="configurator_widget">
        </div>
    </cfif>
        <cf_box_elements>
                <cfif get_conf.recordcount>
                    <cfinput type="hidden" name="product_configurator_id" id="product_configurator_id" value="#get_conf.PRODUCT_CONFIGURATOR_ID#">
                        <div class="row">
                            <cfif get_conf.ORIGIN eq 2><!--- Karma Koliyi yeniden düzenleyerek özelleştir  --->
                                <cfset is_mix_product = 1 />
                                <cf_seperator id="configurator_mixed_parcel" header="#getLang(dictionary_id: 37467)#" closeForGrid="1">
                                <div class="col col-12" id="configurator_mixed_parcel" <!--- style="display:none;" --->>
                                    <cfif attributes.type eq 'add'><!--- spect ekleme --->
                                        <cfinclude  template="add_configurator_mixed_parcel.cfm">
                                    <cfelse><!--- spect güncelle --->
                                        <cfinclude  template="upd_configurator_mixed_parcel.cfm">
                                    </cfif>
                                </div>
                            <cfelseif get_conf.ORIGIN eq 1 or (len(get_conf.USE_COMPONENT) and get_conf.USE_COMPONENT and get_conf.ORIGIN eq 3)><!--- Ağacı kullanarak spekt yarat --->
                                    <cf_seperator id="conf_product_tree" header="#getLang(dictionary_id: 36365)#" closeForGrid="1">
                                    <div class="col col-12" id="conf_product_tree" style="display:none;">
                                        <cfif attributes.type eq 'add'><!--- spect ekleme --->
                                            <cfinclude  template="add_configurator_spect_new.cfm">
                                        <cfelse><!--- spect güncelle --->
                                            <cfinclude  template="upd_configurator_spect_new.cfm">
                                        </cfif>
                                    </div>
                            <cfelse>
                                    <cfinput type="hidden" name="is_tree" id="is_tree" value="0">
                            </cfif>
                        </div>
                <cfelse>
                    <div class="row">
                        <cf_seperator id="conf_product_tree" header="#getLang(dictionary_id: 36365)#" closeForGrid="1">
                        <div class="col col-12" id="conf_product_tree" style="display:none;">
                            <cfif attributes.type eq 'add'><!--- spect ekleme --->
                                <cfinclude  template="add_configurator_spect_new.cfm">
                            <cfelse><!--- spect güncelle --->
                                <cfinclude  template="upd_configurator_spect_new.cfm">
                            </cfif>
                        </div>
                    </div>
                </cfif>
         <!---        <div class="row">
                    <cf_seperator id="configurator_alternative_products" header="#GET_PRICE.IS_GIFT_CARD eq 1 ? getLang('', 'Main Spect Seçimi', 33259) : getLang('', 'Alternatif Ürünler', 32776)#">
                    <div id="configurator_alternative_products" style="display:none;">
                        <cfinclude template="configurator_alternative_products.cfm">
                    </div>
                </div> --->
            <cfif get_conf.ORIGIN eq 3 and get_conf.USE_FEATURE eq 1>
                <div class="row">
                    <cf_seperator id="configurator_property" header="#getLang('','Özellikler',59106)# / #getLang('','Varyasyonlar',37249)# / #getLang('','İhtiyaçlar',36437)#" closeForGrid="1">
                    <div id="configurator_property" style="display:none;">
                        <cfinclude template="configurator_property.cfm">
                    </div>
                </div>
                </cfif>
                <cfif get_conf.ORIGIN eq 3 and get_conf.USE_TEST_PARAMETER eq 1>
                <div class="row">
                    <cf_seperator id="configurator_test_parameter" header="#getLang('','Kalite-Test Parametreleri',62473)#" closeForGrid="1">
                    <div id="configurator_test_parameter" style="display:none;">
                        <cfinclude  template="configurator_test_parameter.cfm">
                    </div>
                </div>
            </cfif>
        </cf_box_elements>
            <cfif x_is_spec_type eq 3 and isdefined("is_show_property_and_calculate") and is_show_property_and_calculate eq 1>
        <cf_box_elements>
                <div class="row">
                    <input type="hidden" name="is_old_style" id="is_old_style" value="1">
                    <cf_seperator id="configurator_property_old" header="#getLang('','Özellikler/İşlemler',33722)#" closeForGrid="1">
                    <div id="configurator_property_old" style="display:none;">
                        <cfinclude template="configurator_property_calculate.cfm">
                    </div>
                </div>
        </cf_box_elements>
            </cfif>
            <div class="ui-row">
                <cf_seperator id="configurator_special_information" header="#getLang('','Özelleştirme ve fiyatlama bilgisi',62509)#" closeForGrid="1">
                <div id="configurator_special_information" style="display:none;">
                    <cfif attributes.type eq 'add'><!--- spect ekleme --->
                        <cfinclude  template="add_configurator_special_information.cfm">
                    <cfelse><!--- spect güncelle --->
                        <cfinclude  template="upd_configurator_special_information.cfm">
                    </cfif>
                </div>
            </div>
            <cf_box_footer>
                <cfif GET_PRODUCT.IS_PROTOTYPE eq 1 or is_mix_product eq 1>
                    <cfif no_count eq 0>
                        <cfif attributes.type eq 'add'>
                            <cf_workcube_buttons is_upd='0' is_delete='0' add_function="configurator_control() && loadPopupBox('add_spect_variations','#attributes.modal_id#')">
                        <cfelse>
                            <div class="col col-8 col-xs-12">
                                <cf_record_info query_name="GET_SPECT">
                            </div>
                            <div class="col col-4 col-xs-12">
                                <cf_workcube_buttons is_upd='1' is_delete='0' add_function="configurator_control() && loadPopupBox('add_spect_variations','#attributes.modal_id#')">
                            </div>
                        </cfif>
                    <cfelse>
                        <div class="col col-12 ui-card"><div class="ui-card-item"><font color="FF0000"><cf_get_lang dictionary_id='60232.Eksik Alternatif Tanımları Olduğu için Spec Kaydedemezsiniz'> !</font></div></div>
                    </cfif>
                <cfelse>
                    <div class="col col-12 ui-card"><div class="ui-card-item"><font color="FF0000"><cf_get_lang dictionary_id="33260.Ürün Özelleştirilebilir Olmadığı İçin Spec Kaydedemezsiniz"> !</font></div></div>
                </cfif>
            </cf_box_footer>
</cfif>
<script>
    <cfif get_conf.recordcount>
        AjaxPageLoad('<cfoutput>#request.self#?fuseaction=product.emptypopup_detail_formula_row&product_configurator_id=#get_conf.PRODUCT_CONFIGURATOR_ID#</cfoutput>','configurator_save_divid2','1',"Bekleyiniz!");
        <cfif len( get_conf.WIDGET_FRIENDLY_NAME ) and get_conf.ORIGIN eq 4>
            getWidget();
            function getWidget() {
                <cfset attributes.configuratorWidgetParameter="config_id="&get_conf.PRODUCT_CONFIGURATOR_ID&"&stock_id="&attributes.stock_id&"&xml_basic_info_category="&
                "&xml_gilding_cat=&xml_printing_technique=&xml_application_technique=&xml_packages_type&from_product_config=1">
                <cfif attributes.type eq 'upd'>
                    <cfset attributes.configuratorWidgetParameter=attributes.configuratorWidgetParameter&"&spect_id="&attributes.id>
                </cfif>
                AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects.widget_loader&widget_load=#get_conf.WIDGET_FRIENDLY_NAME##len(attributes.configuratorWidgetParameter) ? '&' & attributes.configuratorWidgetParameter : '' #</cfoutput>','configurator_widget')
                return;
            }
        </cfif>
    </cfif>
</script>
<cfquery name="get_tree_types" datasource="#dsn#">
	SELECT TYPE_ID, #dsn#.Get_Dynamic_Language(TYPE_ID,'#session.ep.language#','PRODUCT_TREE_TYPE','TYPE',NULL,NULL,TYPE) AS TYPE
	 FROM PRODUCT_TREE_TYPE
</cfquery>
<cfinclude  template="configurator_script.cfm">