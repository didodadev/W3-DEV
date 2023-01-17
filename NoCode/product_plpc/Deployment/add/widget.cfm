
<cfobject name="product_plpc_component" component="nocode.product_plpc.Deployment.product_plpc">
<cfif not isDefined("attributes.from_product_config")>
     <cfset form_id="add_plpc_configurator">
<cf_xml_page_edit>
<cfelse>
     <cfset form_id="add_spect_variations">
</cfif>
<cfset product_plpc_component.init()>
<!---Temel Bilgi Kategorisi--->
<cfset basic_info_category_list = "">
<cfset basic_info_category_list = Listappend(basic_info_category_list,xml_basic_info_category,',') />
<cfset get_info_category = product_plpc_component.select_product_cat(product_cat_id_list : basic_info_category_list)>
<!---Yaldız Kategorisi--->
<cfset gilding_cat_list = "">
<cfset gilding_cat_list = Listappend(gilding_cat_list,xml_gilding_cat,',') />
<cfset get_gilding_cat = product_plpc_component.select_product_cat(product_cat_id_list : gilding_cat_list)>
<!---Baskı Tekniği Operasyon ID--->
<cfset printing_technique_list = "">
<cfset printing_technique_list = Listappend(printing_technique_list,xml_printing_technique,',') />
<cfset get_printing_technique = product_plpc_component.get_operation_type(operation_type_list : printing_technique_list)>
<!---Uygulama Operasyon ID--->
<cfset application_technique_list = "">
<cfset application_technique_list = Listappend(application_technique_list,xml_application_technique,',') />
<cfset get_application_technique = product_plpc_component.get_operation_type(operation_type_list : application_technique_list)>
<cfset get_money = product_plpc_component.get_money()>
<!---Paket Tipleri--->
<cfset packages_list = "">
<cfset packages_list = Listappend(packages_list,xml_packages_type,',') />
<cfset get_packages_type = product_plpc_component.get_packages_type(list_packages_id : packages_list)>
<cfparam name="attributes.index" default="1">
<cfset objRequest = GetPageContext().GetRequest() />
<cfset strUrl = objRequest.GetRequestUrl().Append( "?" & objRequest.GetQueryString() ).ToString()/>
<cfif not isDefined("attributes.from_product_config")>
<form method="POST" action="<cfoutput>#strUrl#</cfoutput>" id="<cfoutput>#form_id#</cfoutput>" name="<cfoutput>#form_id#</cfoutput>">
</cfif>
<cf_box_elements vertical="1">
<cfif isdefined("attributes.spect_id")>
     
<cfobject name="get_plpc_file" component="WBP.Plpc.Files.product_plpc">
     <cfset get_plpc = get_plpc_file.get_plpc(spect_id : attributes.spect_id)>
</cfif>
          <div class="col col-6 col-md-6 col-sm-12 col-xs-12" type="column" index="1" sort="true">
               <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='63725.Daha önce yapılmış üretim bie üretim pratiği var ise arayın ve kullanın.'></label>
               <div class="col col-4 col-xs-12">
                    <cfif isdefined("get_plpc.company_id") and len(get_plpc.company_id) > 
                         <cf_duxi type="hidden" name="plp_company_id" id="plp_company_id" value="#get_plpc.consumer_id#">
                         <cf_duxi type="hidden" name="plp_consumer_id" id="plp_consumer_id" value="#get_plpc.consumer_id#">
                         <cf_duxi name="plp_company_name" id="plp_company_name" type="text"  value="#get_par_info(get_plpc.company_id,1,1,0)#" hint="müşteri" label="57457" threepoint="#request.self#?fuseaction=objects.popup_list_all_pars&is_period_kontrol=0&field_comp_id=#form_id#.plp_company_id&field_comp_name=#form_id#.plp_company_name&field_consumer=#form_id#.plp_consumer_id&select_list=7,8" is_vertical="1">          
                    <cfelse>
                         <cf_duxi type="hidden" name="plp_company_id" id="plp_company_id" data="">
                         <cf_duxi type="hidden" name="plp_consumer_id" id="plp_consumer_id" data="">
                         <cf_duxi name="plp_company_name" id="plp_company_name" type="text"  value="" hint="müşteri" label="57457" threepoint="#request.self#?fuseaction=objects.popup_list_all_pars&is_period_kontrol=0&field_comp_id=#form_id#.plp_company_id&field_comp_name=#form_id#.plp_company_name&field_consumer=#form_id#.plp_consumer_id&select_list=7,8" is_vertical="1">
                    </cfif>
                    </div>
               <div class="col col-4 col-xs-12">
                    <cf_duxi type="hidden" name="company_product_id" id="company_product_id" data="">
                    <cf_duxi type="hidden" name="consumer_product_id" id="consumer_product_id" data="">
                    <cf_duxi name="company_product_code" id="company_product_code" type="text"  value="" hint="müşteri" label="57457+58800" threepoint="#request.self#?fuseaction=objects.popup_list_all_pars&is_period_kontrol=0&field_comp_id=#form_id#.company_product_id&field_comp_name=#form_id#.company_product_code&field_consumer=#form_id#.consumer_product_id&select_list=7,8" is_vertical="1">
               </div>
               <div class="col col-4 col-xs-12">
                    <cf_duxi name="company_name_search" id="company_name_search" type="text"  value="" hint="müşteri" label="58800+57629" icon="fa fa-search" is_vertical="1">
               </div>
               <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='63906.Yeni ürün tanımlamak için özellik ve teknik bilgileri giriniz.'></label>
               <div class="col col-6 col-xs-12">
                    <cfif isdefined("get_plpc.DESIGN_NAME")>
                    <cf_duxi value="#get_plpc.DESIGN_NAME#" name="design_name" id="design_name" placeholder="63907" type="text" label="" is_vertical="1">
                    <cfelse>
                    <cf_duxi name="design_name" id="design_name" placeholder="63907" type="text" label="" is_vertical="1">
                    </cfif>
               </div>
              
          </div>
     <input type="hidden" name="submited" value="1">
     <input type="hidden" name="plpc_configurator_id" value="1">
          <!---Temel Bilgiler --->
          <div class="col col-8 col-xs-12">
               <cf_seperator id="basic_info" title="#getLang('','Temel Bilgiler',58131)#">
          </div>
          <div id="basic_info" class="col col-6 col-md-6 col-sm-12 col-xs-12" type="column" index="2" sort="true">
               <div class="col col-4 col-xs-12">
                    <cfif isdefined("get_plpc.category_id")>
                    <cf_duxi name="plpc_category" placeholder="57734" type="selectbox" data="get_plpc.category_id" value="get_info_category.product_catid"   option="get_info_category.product_cat"  label="57486" hint="Kategori" is_vertical="1">
                    <cfelse>
                    <cf_duxi name="plpc_category" placeholder="57734" type="selectbox"  value="get_info_category.product_catid"   option="get_info_category.product_cat"  label="57486" hint="Kategori" is_vertical="1">
                    </cfif>
               </div>
               <div class="col col-4 col-xs-12">
                    <div class="form-group" id="item-width_height">
                         <div class="col col-4 col-xs-12" style="padding-right:0px!important">
                              <label class="col col-12 col-xs-12" style="margin-bottom:0px!important"><cf_get_lang dictionary_id='39470.En'></label>
                              <input type="text"  name="width_basic" id="width_basic" value="<cfif isdefined("get_plpc.width")><cfoutput>#get_plpc.width#</cfoutput></cfif>">
                         </div>
                         <div class="col col-8 col-xs-12" style="padding-left:0px!important">
                              <label class="col col-12 col-xs-12" style="margin-bottom:0px!important"><cf_get_lang dictionary_id='39511.Boy'></label>
                              <div class="input-group">
                                   <input type="text" name="height_basic" id="height_basic" value="<cfif isdefined("get_plpc.height")><cfoutput>#get_plpc.height#</cfoutput></cfif>">
                                   <span class="input-group-addon width">mm</span>
                              </div>
                         </div>
                    </div>
               </div>
               <div class="col col-4 col-xs-12">
                    <cfif isdefined("get_plpc.order_quantity")>
                         <cf_duxi name="order_quantity" id="order_quantity" value="get_plpc.order_quantity" type="text" data_control="width" unit="Adet"  hint="Sipariş Miktarı"  label="38564" is_vertical="1">
                    <cfelse>
                         <cf_duxi name="order_quantity" id="order_quantity" type="text" data_control="width" unit="Adet"  hint="Sipariş Miktarı"  label="38564" is_vertical="1">
                    </cfif>
               </div>
          </div>
          <!---Renk ve Ekstralar --->
          <div class="col col-8 col-xs-12">
           <cf_seperator id="color_and_extra" title="#getLang('','Renk ve Ekstralar',63940)#">
          </div>
          <div class="col col-6 col-md-6 col-sm-12 col-xs-12" id="color_and_extra" type="column" index="3" sort="true">
               <div class="col col-4 col-xs-12">
                    <div class="form-group" id="item-color-palette">
                         <label class="col col-12 col-xs-12"  style="margin-top:7px!important"></label>
                         <div class="col col-3 col-xs-12">
                              <input type="color" name="colour_c" value="<cfif isdefined("get_plpc.colour_c") and len(get_plpc.colour_c)><cfoutput>#get_plpc.colour_c#</cfoutput><cfelse>#00ffff</cfif>" placeholder="C"/>
                         </div>
                         <div class="col col-3 col-xs-12">
                              <input type="color" name="colour_m" value="<cfif isdefined("get_plpc.colour_m") and len(get_plpc.colour_m)><cfoutput>#get_plpc.colour_m#</cfoutput><cfelse>#ff00ff</cfif>" placeholder="M"/>
                         </div>
                         <div class="col col-3 col-xs-12">
                              <input type="color" name="colour_y" value="<cfif isdefined("get_plpc.colour_y") and len(get_plpc.colour_y)><cfoutput>#get_plpc.colour_y#</cfoutput><cfelse>#ffff00</cfif>" placeholder="Y"/>
                         </div>
                         <div class="col col-3 col-xs-12">
                              <input type="color" name="colour_k" value="<cfif isdefined("get_plpc.colour_k") and len(get_plpc.colour_k)><cfoutput>#get_plpc.colour_k#</cfoutput><cfelse>#000000</cfif>" placeholder="K"/>
                         </div>
                    </div>
               </div>
               <div class="col col-8 col-xs-12">
                    <div class="form-group" id="item-width_height">
                         <div class="col col-3 col-xs-12" style="padding-right:0px!important">
                              <label class="col col-12 col-xs-12" style="margin-bottom:0px!important"><cf_get_lang dictionary_id='63995.Yaldız'></label>
                              <cfif isdefined("get_plpc.gilding_id")>
                              <cf_duxi name="gilding_id" placeholder="57734" type="selectbox" data="get_plpc.gilding_id" value="get_gilding_cat.product_catid"  option="get_gilding_cat.product_cat"  label="" hint="Yaldız Kategori" is_vertical="1">
                              <cfelse>
                              <cf_duxi name="gilding_id" placeholder="57734" type="selectbox" value="get_gilding_cat.product_catid"  option="get_gilding_cat.product_cat"  label="" hint="Yaldız Kategori" is_vertical="1">
                              </cfif>
                         </div>
                         <div class="col col-3 col-xs-12" style="padding-left:0px!important;padding-right: 0px!important;">
                              <label class="col col-12 col-xs-12" style="margin-bottom:0px!important"><cf_get_lang dictionary_id='63996.Lak'></label>
                              <select type="text"  name="printing_lacquer" id="printing_lacquer">
                                   <option value="0" <cfif isdefined("get_plpc.IS_LACQUER") and get_plpc.IS_LACQUER eq 0>selected</cfif>><cf_get_lang dictionary_id='58564.Var'></option>
                                   <option value="1" <cfif isdefined("get_plpc.IS_LACQUER") and get_plpc.IS_LACQUER eq 1>selected</cfif>><cf_get_lang dictionary_id='58546.Yok'></option>
                              </select>
                         </div>
                         <div class="col col-3 col-xs-12" style="padding-right:0px!important;padding-left: 0px!important;">
                              <label class="col col-12 col-xs-12" style="margin-bottom:0px!important"><cf_get_lang dictionary_id='63997.Vernik'></label>
                              <select type="text"  name="varnish" id="varnish">
                                   <option value="0" <cfif isdefined("get_plpc.IS_VARNISH") and get_plpc.IS_VARNISH eq 0>selected</cfif>><cf_get_lang dictionary_id='58564.Var'></option>
                                   <option value="1" <cfif isdefined("get_plpc.IS_VARNISH") and get_plpc.IS_VARNISH eq 1>selected</cfif>><cf_get_lang dictionary_id='58546.Yok'></option>
                              </select> 
                         </div>
                         <div class="col col-3 col-xs-12" style="padding-left:0px!important">
                              <label class="col col-12 col-xs-12" style="margin-bottom:0px!important"><cf_get_lang dictionary_id='63998.Selefon'></label>
                              <select type="text"  name="cellophane" id="cellophane">
                                   <option value="0" <cfif isdefined("get_plpc.IS_CELLOPHANE") and get_plpc.IS_CELLOPHANE eq 0>selected</cfif>><cf_get_lang dictionary_id='58564.Var'></option>
                                   <option value="1" <cfif isdefined("get_plpc.IS_CELLOPHANE") and get_plpc.IS_CELLOPHANE eq 1>selected</cfif>><cf_get_lang dictionary_id='58546.Yok'></option>
                              </select>
                         </div>
                    </div>
               </div>
          </div>
          <!---Baskı ve Malzeme Bilgileri--->
          <div class="col col-8 col-xs-12">
           <cf_seperator id="print_and_material" title="#getLang('','Baskı ve Malzeme Bilgileri',63941)#">
          </div>
          <div class="col col-6 col-md-6 col-sm-12 col-xs-12" id="print_and_material" type="column" index="4" sort="true">
                <cf_flat_list>
                     <thead>
                         <th><a onClick="add_row_material();"><i class="fa fa-plus"></i><input type="hidden" name="record_num" id="record_num" value="1"></a></th>
                         <th width="230"><cf_get_lang dictionary_id="63923.Baskı Tekniği"></th>
                         <th><cf_get_lang dictionary_id="32045.Malzeme"></th>
                         <th><cf_get_lang dictionary_id="63924.Miktar/Birim"></th>
                              <th></th>
                     </thead>
                     <tbody id="print_and_material_">
                         <td>
                              <ul class="ui-icon-list">
                                   <input type="hidden" name="row_kontrol0" id="row_kontrol0" value="1">
                                   <li><a href="javascript:void(0)"><i  class="fa fa-minus"></i></a></li>
                                   <li><a href="javascript:void(0)"><i class="fa fa-font"></i></a></li>
                              </ul>
                         </td>
                         <td>
                              <cf_duxi name="printing_technique0" id="printing_technique0" placeholder="57734" type="selectbox" option="get_printing_technique.operation_type" value="get_printing_technique.operation_type_Id"  label="" hint="Baskı Tekniği" is_vertical="1">
                         </td>
                         <td>
                              <cf_duxi type="hidden" name="material_id" id="material_id">
                              <cf_duxi name="material_name" id="material_name" placeholder="32045" hint="Malzeme" is_vertical="1" label="" threepoint="#request.self#?fuseaction=objects.popup_product_names&product_id=#form_id#.material_id&field_name=#form_id#.material_name">
                         </td>
                         <td>
                              <cf_duxi name="quantity_unit0" id="quantity_unit0" type="text" data_control="width" unit="gr/m2"  hint="Sipariş Miktarı"  placeholder="63924" is_vertical="1" label="">  
                         </td>
                         <td><a href="javascript:void(0)" onclick="gizle_goster_info();"><i  class="fa fa-info"></i></a></td>
                     </tbody>
                     <tbody id="info_tab"  style="display:none;">
                         <td></td>
                         <td>
                              <div class="form-group" id="item-width_height">
                                   <div class="col col-6 col-xs-12">
                                             <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='63945.Fireli'><cf_get_lang dictionary_id='39470.En'>X <cf_get_lang dictionary_id='39511.Boy'></label>
                                        <div class="col col-6 col-xs-12"  style="padding-right:0px!important">
                                             <input type="text"  name="width" id="width" value="">
                                        </div>
                                        <div class="col col-6 col-xs-12"  style="padding-left:0px!important">
                                             <input type="text" name="height" id="height" value="">
                                        </div>
                                   </div>
                                   <div class="col col-6 col-xs-12">
                                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="29784.Ağırlık"></label>
                                        <div class="input-group">
                                             <input type="text" name="Weight" id="Weight" value="">
                                             <span class="input-group-addon width">kg</span>
                                        </div>
                                   </div>
                              </div>
                         </td>
                         <td>
                              <cf_duxi name="unit_price" id="unit_price" type="text" data_control="money" currencyname="unit_price_currency" currencyvalue=""  hint="Birim Fiyat"  label="57638" is_vertical="1">                              
                         </td>
                         <td>
                              <cf_duxi name="cost" readonly="yes" type="text" id="cost" label="58258" hint="Maliyet" data="" is_vertical="1">
                         </td>
                    </tbody>
                </cf_flat_list>
          </div>
          <!---Kesim ve Gofraj Bilgileri--->
          <div class="col col-8 col-xs-12">
           <cf_seperator id="cutting_and_embossing" title="#getLang('','Kesim ve Gofraj Bilgileri',63942)#">
          </div>
          <div class="col col-6 col-md-6 col-sm-12 col-xs-12" id="cutting_and_embossing" type="column" index="5" sort="true">
                <cf_flat_list>
                     <thead>
                         <th><a onclick="add_row_embossing()"><i class="fa fa-plus"></i></a></th>
                          <th width="230"><cf_get_lang dictionary_id="63925.Uygulama"></th>
                          <th><cf_get_lang dictionary_id="63926.Kalıp No"></th>
                         <th><cf_get_lang dictionary_id="63927.Kalıp Maliyeti"></th>
                              <th></th>
                     </thead>
                     <tbody id="cutting_and_embossing_">
                         <td>
                              <ul class="ui-icon-list">
                                   <li><a href="javascript:void(0)"><i  class="fa fa-minus"></i></a></li>
                                   <li><a href="javascript:void(0)"><i class="fa fa-font"></i></a></li>
                              </ul>
                         </td>
                         <td>
                              <cf_duxi name="application_technique0" placeholder="57734" type="selectbox" option="get_application_technique.operation_type" value="get_application_technique.operation_type_id"  label="" hint="Uygulama" is_vertical="1">
                         </td>
                         <td>
                              <cf_duxi type="hidden" name="mold_no_id" id="mold_no_id">
                              <cf_duxi name="mold_no" id="mold_no" placeholder="63926" hint="Kalıp No" is_vertical="1" label="" threepoint="#request.self#?fuseaction=assetcare.popup_list_assetps&field_id=#form_id#.mold_no_id&field_name=#form_id#.mold_no" icon="fa-plus" icon_boxhref="">
                         </td>
                         <td>
                              <cf_duxi name="mold_cost" id="mold_cost" type="text" data_control="money" currencyname="mold_cost_currency" currencyvalue="" hint="Kalıp Maliyeti"  placeholder="63927" is_vertical="1">  
                         </td>
                     </tbody>
                </cf_flat_list>
          </div>
          <!---Paket ve Diğer Talimatlar--->
          <div class="col col-8 col-xs-12">
           <cf_seperator id="packet_and_other" title="#getLang('','Paket ve Diğer Talimatlar',63943)#">
          </div>
          <div class="col col-6 col-md-6 col-sm-12 col-xs-12" id="packet_and_other" type="column" index="6" sort="true">
                <cf_flat_list>
                     <thead>
                         <th><a onclick="add_row_package()"><i class="fa fa-plus"></i></a></th>
                          <th width="230"><cf_get_lang dictionary_id="43492.Paket"></th>
                          <th><cf_get_lang dictionary_id="63932.Paket Başına Adet"></th>
                         <th><cf_get_lang dictionary_id="39277.Paket Sayısı"></th>
                              <th></th>
                     </thead>
                     <tbody id="package_">
                         <td>
                              <ul class="ui-icon-list">
                                   <li><a href="javascript:void(0)"><i  class="fa fa-minus"></i></a></li>
                              </ul>
                         </td>
                         <td>
                              <cf_duxi name="package_type" placeholder="57734" type="selectbox" option="get_packages_type.package_type" value="get_packages_type.package_type_id"  label="" hint="Paket tipi" is_vertical="1">
                         </td>
                         <td>
                              <cf_duxi name="pcs_per_pack" id="pcs_per_pack" type="text"  hint="Paket Başına Adet"  placeholder="63932" is_vertical="1">  
                         </td>
                         <td>
                              <cf_duxi name="number_of_packages" id="number_of_packages" type="text"  hint="Paket Sayısı"  placeholder="39277" is_vertical="1">  
                         </td>
                     </tbody>
                </cf_flat_list>
          </div>
          <!---Baskı Öncesi Çalışmalar--->
          <div class="col col-8 col-xs-12">
               <cf_seperator id="prepress_work" title="#getLang('','Baskı Öncesi Çalışmalar',63944)#">
          </div>
          <div class="col col-8 col-md-8 col-sm-12 col-xs-12" id="prepress_work" type="column" index="7" sort="true">
               <div class="col col-4 col-xs-12">
                    <div class="form-group">
                         <label>
                              <input type="checkbox" name="made_in_design" id="made_in_design" value="1" <cfif isdefined("get_plpc.IS_DESIGNED") and get_plpc.IS_DESIGNED eq 1>checked</cfif>>
                              <cf_get_lang dictionary_id='63936.Tasarımı Yapılacak'>
                         </label> 
                    </div>
                    <div class="form-group">
                         <label>
                              <input type="checkbox" name="design_print" id="design_print" value="1" <cfif isdefined("get_plpc.IS_PRINT_DESIGNED") and get_plpc.IS_PRINT_DESIGNED eq 1>checked</cfif>>
                              <cf_get_lang dictionary_id='63937.Tasarım baskıya uygun hale getirilecek.'>
                         </label> 
                    </div>
               </div>
               <div class="col col-4 col-xs-12">
                    <div class="form-group">
                         <div class="col col-3 col-xs-12">
                              <input type="text" name="time_cost_desing" id="time_cost_desing"  <cfif isdefined("get_plpc.TIME_COST_DESIGN")>value="<cfoutput>#get_plpc.TIME_COST_DESIGN#</cfoutput>"</cfif>>
                         </div>
                         <div class="col col-9 col-xs-12">
                              <label>
                                   <cf_get_lang dictionary_id='46464.Öngörülen'><cf_get_lang dictionary_id='32245.Zaman Harcaması'><cf_get_lang dictionary_id='63939.Adam/Saat'>
                              </label> 
                         </div>
                    </div>
                    <div class="form-group">
                         <div class="col col-3 col-xs-12">
                              <input type="text" name="time_cost_print" id="time_cost_print" <cfif isdefined("get_plpc.TIME_COST_PRINT")>value="<cfoutput>#get_plpc.TIME_COST_PRINT#</cfoutput>"</cfif>>
                         </div>
                         <div class="col col-9 col-xs-12">
                              <label>
                                   <cf_get_lang dictionary_id='46464.Öngörülen'><cf_get_lang dictionary_id='32245.Zaman Harcaması'><cf_get_lang dictionary_id='63939.Adam/Saat'>
                              </label> 
                         </div>
                    </div>
               </div>
           
          </div>
          <!---Baskı Öncesi Çalışmalar 2--->
          <div class="col col-8 col-xs-12">
               <cf_seperator id="2_prepress_work" title="#getLang('','Baskı Öncesi Çalışmalar',63944)#">
          </div>
          <div class="col col-6 col-md-8 col-sm-12 col-xs-12" id="2_prepress_work" type="column" index="8" sort="true">
               <cfif isdefined("get_plpc.DETAIL")>
                    <cf_duxi name="other_note" id="other_note" value="#get_plpc.DETAIL#" type="textarea"  hint="Notlar" maxlength="10" placeholder="61801" is_vertical="1">
               <cfelse>
                    <cf_duxi name="other_note" id="other_note" type="textarea"  hint="Notlar" maxlength="10" placeholder="61801" is_vertical="1">
               </cfif>
          <div class="col col-6 col-xs-12">
               <div class="col col-4 col-xs-12">
                    <cfif isdefined("get_plpc.CONFIGURATOR_NO")>
                         <cf_duxi name="configurator_no" value="#get_plpc.CONFIGURATOR_NO#" id="configurator_no" type="text" label="61648+57487" is_vertical="1">
                    <cfelse>
                         <cf_duxi name="configurator_no" id="configurator_no" type="text" label="61648+57487" is_vertical="1">
                    </cfif>
               </div>
               <div class="col col-4 col-xs-12">
                    <cfif isdefined("get_plpc.ORDER_NO")>
                         <cf_duxi name="related_order_no" value="#get_plpc.ORDER_NO#" id="related_order_no" type="text" label="49564+58211" is_vertical="1">
                    <cfelse>
                         <cf_duxi name="related_order_no" id="related_order_no" type="text" label="49564+58211" is_vertical="1">
                    </cfif>
               </div>
          <cfif not isDefined("attributes.from_product_config")>
               <div class="col col-4 col-xs-12">
                    <cf_duxi name="process_stage" type="hidden" label="58859"  required="yes" hint="süreç*" is_vertical="1"> <cf_workcube_process is_upd='0' process_cat_width='140' is_detail='0'></cf_duxi>
               </div>
          </cfif>
          </div>
</div>
</cf_box_elements>
<cfif not isDefined("attributes.from_product_config")>
  <cf_box_footer>
          <div class="col col-12">
               <cf_workcube_buttons extraFunction='' type_format='1' extraButtonClass="ui-wrk-btn ui-wrk-btn-extra" is_upd="0"  add_function='' extraButtonText="Maliyet ve Termin Hesapla"  extraButton="1">
          </div>
     </cf_box_footer>
</form>
</cfif>
<script type="text/javascript">
          row_count_material = 1 ;
          row_count_embossing = 1 ;
          row_count_package = 1 ;
       function gizle_goster_info()
        {
            if(document.getElementById('info_tab').style.display == '' || document.getElementById('info_tab').style.display == 'block' )
            {
                document.getElementById("info_tab").style.display = 'none';
            } else {
                document.getElementById('info_tab').style.display ='';
            }
        }
     function sil_mate(sy)
	{
          var my_element=eval("<cfoutput>#form_id#</cfoutput>.row_kontrol_material"+sy);
          my_element.value=0;
          var my_element=eval("frm_row_material"+sy);
          my_element.style.display="none";
		
	}
     function sil_emb(sy)
	{
          var my_element=eval("<cfoutput>#form_id#</cfoutput>.row_kontrol_embossing"+sy);
          my_element.value=0;
          var my_element=eval("frm_row_emb"+sy);
          my_element.style.display="none";
	}
     function sil_pack(sy)
	{
          var my_element=eval("<cfoutput>#form_id#</cfoutput>.row_kontrol_package"+sy);
          my_element.value=0;
          var my_element=eval("frm_row_pack"+sy);
          my_element.style.display="none";
		
	}
	function add_row_material()
	{		
		row_count_material++;
		var newRow;
		var newCell;
		newRow = document.getElementById("print_and_material_").insertRow(document.getElementById("print_and_material_").rows.length);
		$("#<cfoutput>#form_id#</cfoutput> #record_num").val(row_count_material);
		newRow.setAttribute("name","frm_row_material" + row_count_material);
		newRow.setAttribute("id","frm_row_material" + row_count_material);		
		newRow.setAttribute("NAME","frm_row_material" + row_count_material);
		newRow.setAttribute("ID","frm_row_material" + row_count_material);	
		newCell = newRow.insertCell(newRow.cells.length);	
		newCell.innerHTML = '<ul class="ui-icon-list"><li><a onclick="sil_mate('+ row_count_material +');"><i  class="fa fa-minus"></i></a></li><li><a href="javascript:void(0)"><i class="fa fa-font"></i></a></li></ul>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input  type="hidden" value="1" id="row_kontrol_material' + row_count_material +'" name="row_kontrol_material' + row_count_material +'" ><select name="printing_technique' + row_count_material +'" id="printing_technique' + row_count_material +'"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option><cfoutput query="get_printing_technique"><option value="#operation_type_Id#">#operation_type#</option></cfoutput></select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
          newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="material_id'+ row_count_material +'" value=""><input type="text" name="material_name'+ row_count_material+'" value="" readonly><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="product_open(' + row_count_material + ');"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="quantity_unit' + row_count_material + '"style="width:200px;"><span class="input-group-addon width">gr/m2</span></div></div>';
          newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a href="javascript:void(0)" onclick="gizle_goster_info();"><i  class="fa fa-info"></i></a>';
	}
     function add_row_embossing()
	{		
		row_count_embossing++;
		var newRow;
		var newCell;
		newRow = document.getElementById("cutting_and_embossing_").insertRow(document.getElementById("cutting_and_embossing_").rows.length);
		$("#<cfoutput>#form_id#</cfoutput> #record_num").val(row_count_embossing);
		newRow.setAttribute("name","frm_row_emb" + row_count_embossing);
		newRow.setAttribute("id","frm_row_emb" + row_count_embossing);		
		newRow.setAttribute("NAME","frm_row_emb" + row_count_embossing);
		newRow.setAttribute("ID","frm_row_emb" + row_count_embossing);	
		newCell = newRow.insertCell(newRow.cells.length);	
		newCell.innerHTML = '<ul class="ui-icon-list"><li><a onclick="sil_emb('+ row_count_embossing +');"><i  class="fa fa-minus"></i></a></li><li><a href="javascript:void(0)"><i class="fa fa-font"></i></a></li></ul>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input  type="hidden" value="1" id="row_kontrol_embossing' + row_count_embossing +'" name="row_kontrol_embossing' + row_count_embossing +'" ><select name="application_technique' + row_count_embossing +'" id="application_technique' + row_count_embossing +'"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option><cfoutput query="get_application_technique"><option value="#operation_type_Id#">#operation_type#</option></cfoutput></select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
          newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="mold_no_id'+ row_count_embossing +'" value=""><input type="text" name="mold_no'+ row_count_embossing+'" value=""><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="open_asset(' + row_count_embossing + ');"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="mold_cost' + row_count_embossing + '"><span class="input-group-addon width"><select><cfoutput query="get_money"><option value="#MONEY#">#MONEY#</option></cfoutput></select></span></div></div>';
	}
     function add_row_package()
	{		
		row_count_package++;
		var newRow;
		var newCell;
		newRow = document.getElementById("package_").insertRow(document.getElementById("package_").rows.length);
          $("#<cfoutput>#form_id#</cfoutput> #record_num").val(row_count_package);
		newRow.setAttribute("name","frm_row_pack" + row_count_package);
		newRow.setAttribute("id","frm_row_pack" + row_count_package);		
		newRow.setAttribute("NAME","frm_row_pack" + row_count_package);
		newRow.setAttribute("ID","frm_row_pack" + row_count_package);	
		newCell = newRow.insertCell(newRow.cells.length);	
		newCell.innerHTML = '<a onclick="sil_pack('+ row_count_package +');"><i  class="fa fa-minus"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input  type="hidden" value="1" id="row_kontrol_package' + row_count_package +'" name="row_kontrol_package' + row_count_package +'" ><select name="package_type' + row_count_package +'" id="package_type' + row_count_package +'"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option><cfoutput query="get_packages_type"><option value="#package_type_Id#">#package_type#</option></cfoutput></select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
          newCell.innerHTML = '<div class="form-group"><input type="text" name="pcs_per_pack'+ row_count_package+'" value=""></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="number_of_packages' + row_count_package + '"></div>';
	}
     function product_open(no1)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=<cfoutput>#form_id#</cfoutput>.material_id'+ no1 +'&field_name=<cfoutput>#form_id#</cfoutput>.material_name'+ no1);
	}	
     function open_asset(no1)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_assetps&field_id=<cfoutput>#form_id#</cfoutput>.mold_no_id'+ no1 +'&field_name=<cfoutput>#form_id#</cfoutput>.mold_no'+ no1);
	}	
</script>