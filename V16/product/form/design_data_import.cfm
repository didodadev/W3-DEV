<!---
    File: V16\product\display\design_data.cfm
    Author: file_label R. Uysal <file_labeluysal@workcube.com>
    Date: 2022-04-14
    Description: Design data for product import
--->
<cfset data_component = createObject("component","V16.product.cfc.design_data")>
<cfset product_sample = data_component.get_product_sample(product_sample_id : attributes.product_sample_id)>
<cfset get_design_data = data_component.GET_DESIGN_DATA_SETTINGS_ALL(data_type : attributes.data_type)>
<cfset get_alternative_questions = data_component.GET_ALTERNATIVE_QUESTION()>
<cfset get_tree_types = data_component.get_tree_types()>
<cfset get_design_data_settings = data_component.GET_DESIGN_DATA_SETTINGS_ALL(data_type : attributes.data_type)>
<cfif get_design_data.recordcount>
    <cfset get_design_elements = deserializeJSON(get_design_data.DESIGN_DATA_JSON)>
<cfelse>
    <cfset get_design_elements = structNew()>
</cfif>
<cfset i = 1>


<cf_box title="#getLang('','Design Data Import',65352)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#"
    draggable_icon = 'fa fa-plug' 
    draggable_href = '#request.self#?fuseaction=product.design_data&event=settings&product_sample_id=#attributes.product_sample_id#&data_type=#attributes.data_type#&main_product_id=#attributes.main_product_id#&stock_id=#attributes.stock_id#'
    draggable_size = 'ui-draggable-box-large' 
    draggable_href_title = '#getLang('','Design Data Import',65352)# - #getLang('','Ayarlar',57435)#'
    box_modal_id = '#attributes.modal_id#'>
    
    <cfform name="formimport" enctype="multipart/form-data" method="post" id="formimport" action="#request.self#?fuseaction=product.emptypopup_design_data">
        <cfinput type="hidden" name="from_add" value="1">
        <cfinput type="hidden" name="product_sample_id" value="#attributes.product_sample_id#">
        <cfinput type="hidden" name="product_id" value="#product_sample.REFERENCE_PRODUCT_ID#">
        <cfinput type="hidden" name="product_desing_data_settings_id" value="#get_design_data.PRODUCT_DESIGN_DATA_SETTINGS_ID#">
        <cfinput type="hidden" name="modal_id" value="#attributes.modal_id#">
        <cfinput type="hidden" name="data_type" value="#attributes.data_type#">
        <cfinput type="hidden" name="main_product_id" value="#attributes.main_product_id#">
        <cfinput type="hidden" name="main_stock_id" value="#attributes.stock_id#">
        <cfinput type="hidden" name="history_stock" id="history_stock" value="#attributes.stock_id#">

        <div class="col col-6 col-md-12 col-sm-12 col-xs-12" style="display: flex;align-items: center;">
            <div class="col col-3 col-xs-12">
                <img src="/images/design-data/clo-logo.png" width="" height="" style="width: 100%;">
            </div>
            <div class="col col-3 col-xs-12 " style="display: flex;font-weight: 100;justify-content: center;">,
                <i class="fa fa-random" style="color:#55cc08;font-size: 40px;font-weight: 100!important;text-align: center;"></i>
            </div>
            <div class="col col-6 col-xs-12 align-middle">
                <h3 style="color: #333333;">
                    <cfoutput>#product_sample.product_sample_name#</cfoutput>
                </h3>
            </div>
        </div>
        <div class="col col-6 col-xs-12">
            <cf_box_elements vertical="1">
                <div class="col col-10 col-xs-12">
                    <div class="form-group" id="item-document" class="item-document">
                        <label><cf_get_lang dictionary_id='55076.Import edeceğiniz ürün verisini yükleyin.'></label>
                        <div class="input-group">
                            <input type="text" id="file_label" value="<cfif isdefined('attributes.file_name')><cfoutput>#attributes.file_name#</cfoutput></cfif>">
                            <input type="file" name="template_file" class="hidden" id="template_file" style="width:200px;opacity:0">
                            <input type="hidden" name="doc_req" id="doc_req">
                            <span class="input-group-addon" onclick="document.getElementById('template_file').click(); $('#file_label').html($('#template_file').val());">Upload</span>
                        </div>
                    </div>
                </div>
                <div class="col col-2 col-xs-12">
                    <div class="form-group" id="item-document" class="item-document">
                        <label>&nbsp;</label>
                        <div>                            
                            <a href="javascript://" class="ui-btn ui-btn-success" onclick="pair_function()"><cf_get_lang dictionary_id='61540.Eşleştir'></a>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
        </div>
    </cfform>
    <cfif isdefined("attributes.file_id") and isdefined("attributes.file_name")>
        <cfform name="formimport_settings" enctype="multipart/form-data" method="post" id="formimport_settings">

            <cfinput type="hidden" name="from_add" value="1">
            <cfinput type="hidden" name="product_id" value="#product_sample.REFERENCE_PRODUCT_ID#">
            <cfinput type="hidden" name="product_desing_data_settings_id" value="#get_design_data.PRODUCT_DESIGN_DATA_SETTINGS_ID#">
            <cfinput type="hidden" name="data_type" value="#attributes.data_type#">
            <cfinput type="hidden" name="main_product_id" value="#attributes.main_product_id#">
            <cfinput type="hidden" name="main_stock_id" value="#attributes.stock_id#">
            <cfinput type="hidden" name="history_stock" id="history_stock" value="#attributes.stock_id#">
            <input type = "hidden" name = "row_count" id = "row_count" value = "0">
            <input type = "hidden" name = "product_sample_id" id = "product_sample_id" value = "<cfoutput>#attributes.product_sample_id#</cfoutput>">

            <cfset parseroptions = structnew()>
            <cfset parseroptions.ALLOWEXTERNALENTITIES = false>
            <cfset get_xml = XmlParse("#upload_folder##dir_seperator#Product-Design-Data#dir_seperator##attributes.file_name#", false, parseroptions)>
            <div class="col col-12 col-xs-12">
                <cf_box_elements>
                    <div class="col col-12 col-xs-12">
                        <label style="color: #333333;" class="data-import-label">
                            <b><cf_get_lang dictionary_id='48128.Renk'> : </b>
                            <cfset color_element = XmlSearch(get_xml, "/Pacx/BOM/ColorWay")>
                            <cfloop array="#color_element#" index="color">
                                <cfoutput>#color.XmlAttributes.Name# <cfif i neq arrayLen(color_element)>,</cfif></cfoutput>
                                <cfset i++>
                            </cfloop>
                        </label>
                        <label style="color: #333333;" class="data-import-label">
                            <b><cf_get_lang dictionary_id='37324.Beden'> : </b>
                            <cfset i = 1>
                            <cfset grand_element = XmlSearch(get_xml, "/Pacx/GradingRuleTable/GradingItem/GradingItem_GradingList")>
                            <cfloop array="#grand_element[1].XmlChildren#" index="granding">
                                <cfoutput>#granding.XmlAttributes.Contents# <cfif i neq arrayLen(grand_element[1].XmlChildren)>,</cfif></cfoutput>
                                <cfset i++>
                            </cfloop>
                        </label>
                    </div>
                </cf_box_elements>
            </div>
           
            
            <div class="col col-12 col-xs-12">
                <cf_box_elements>
                    <cf_grid_list>
                        <thead>
                            <tr>
                                <th><cf_get_lang dictionary_id='58577.Sıra'></th>
                                <th><cf_get_lang dictionary_id='63502.Bileşen Tipi'></th>
                                <th><cf_get_lang dictionary_id='36199.Açıklama'></th>
                                <th width="25px"><cf_get_lang dictionary_id='57789.Özel Kod'></th>
                                <th><cf_get_lang dictionary_id='57635.Miktar'></th>
                                <th><cf_get_lang dictionary_id='57692.İşlem'></th>
                                <th><cf_get_lang dictionary_id='36625.Alternatif Soru'></th>
                                <th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>  
                                <th><cf_get_lang dictionary_id='57657.Ürün'> <cf_get_lang dictionary_id='57452.Stok'> - <cf_get_lang dictionary_id='36199.Açıklama'></th>   
                                <th><cf_get_lang dictionary_id='57647.Spekt'></th>  
                                <th><cf_get_lang dictionary_id='57635.Miktar'></th>  
                                <th><cf_get_lang dictionary_id='57636.Birim'></th>  
                                <th><cf_get_lang dictionary_id='57636.Birim'></th>         
                            </tr>
                        </thead>
                        <tbody>
                            <!--- PatterenList(Kalıplar) --->
                            <cfset i = 1>
                            <cfset selectedPatternElements = XmlSearch(get_xml, "/Pacx/BOM/ColorWay/PatternList")>
                            <cfloop array="#selectedPatternElements[1].XmlChildren#" index="PatternList">
                                <cfoutput>
                                    <tr id="tr_#i#">          
                                        <input type="hidden" name="row_#i#" value="1">             
                                        <input type="hidden" name="unit_id_#i#" id="unit_id_#i#" value=""> 
                                        <td>#i#</td>           
                                        <td>
                                            <select name="tree_types_#i#" id="tree_types">
                                                <option value=""><cf_get_lang dictionary_id='63502.Bileşen Tipi'></option>
                                                <cfloop query = "get_tree_types">
                                                    <option value="#get_tree_types.TYPE_ID#" <cfif isdefined("get_design_elements.tree_types_PatternList") and len(get_design_elements.tree_types_PatternList) and get_design_elements.tree_types_PatternList eq get_tree_types.TYPE_ID>selected</cfif>>#get_tree_types.TYPE#</option>
                                                </cfloop>
                                            </select>
                                        </td> 
                                        <td><input type="text" name="detail_#i#" value = "#PatternList.XmlAttributes.Name#" readonly></td>  
                                        <td><input type = "text" value = "" name = "special_code_#i#" id = "special_code_#i#"></td>   
                                        <td><input type = "text" value = "" name = "quantity_#i#" id = "quantity_#i#"></td>   
                                        <td>
                                            <cf_wrkoperationtype control_status='1' fieldName = "operation_type_id_#i#" fieldId = "operation_type_id_#i#" returnInputValue = "operation_type_id_#i#,operation_type_id_#i#" operation_type_id="#isdefined("get_design_elements.operation_type_id_PatternList") and len(get_design_elements.operation_type_id_PatternList) ? get_design_elements.operation_type_id_PatternList: ''#">   
                                        </td>
                                        <td>
                                            <select name="alternative_questions_#i#" id="alternative_questions_#i#" style="width:110px;">
                                                <option value=""><cf_get_lang dictionary_id='36616.Alternatif Soru Seçiniz'>!</option>
                                                <cfloop query="get_alternative_questions">
                                                    <cfoutput><option value="#QUESTION_ID#">#QUESTION_NAME#</option></cfoutput>
                                                </cfloop>
                                            </select>
                                        </td>  
                                        <td><input type = "text" value = "" name = "stock_code_#i#" id = "stock_code_#i#"></td> 
                                        <td>
                                            <div class="input-group">
                                                <input type="hidden" name="stock_id_#i#" id="stock_id_#i#" data-type="stock_id" value="<cfif isdefined("get_design_elements.stock_id_PatternList") and len(get_design_elements.stock_id_PatternList)><cfoutput>#get_design_elements.stock_id_PatternList#</cfoutput></cfif>">
                                                <input type="hidden" name="product_id_#i#" id="product_id_#i#"  data-type="product_id" value="<cfif isdefined("get_design_elements.product_id_PatternList") and len(get_design_elements.product_id_PatternList)><cfoutput>#get_design_elements.product_id_PatternList#</cfoutput></cfif>">
                                                <input type="text" name="product_name_#i#" id="product_name_#i#" data-type="product_name" value="<cfif isdefined("get_design_elements.product_name_PatternList") and len(get_design_elements.product_name_PatternList)><cfoutput>#get_design_elements.product_name_PatternList#</cfoutput></cfif>">
                                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_name=formimport_settings.product_name_#i#&product_id=formimport_settings.product_id_#i#&field_id=formimport_settings.stock_id_#i#&field_unit=formimport_settings.unit_id_#i#')"></span>
                                            </div>
                                        </td>   
                                        <td>
                                            <div class="input-group">
                                                <cfinput type="hidden" name="spect_main_name_#i#" id="spect_main_name_#i#" readonly="yes">
                                                    <input type="text" name="spect_main_id_#i#" id="spect_main_id_#i#" readonly>
                                                <span class="input-group-addon icon-ellipsis btnPoniter" onclick="open_spec(#i#);"></span>
                                            </div>		
                                        </td>   
                                        <td><input type = "text" value = "1" name = "quantity_wrk_#i#" id = "quantity_wrk_#i#"></td>   
                                        <td><input type = "text" value = "" name = "unit_#i#" id = "unit_#i#"></td>   
                                        <td><a onClick="delete_row(#i#)"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='58971.Satır Sil'>" ></i></a></td>
                                    </tr>
                                </cfoutput>
                                <cfset i++>
                            </cfloop>

                            <!--- Garment (Giysi) --->
                            <cfset garmentStruct = StructNew()>
                            <cfset garmentStruct.FabricList = '#getLang('','Kumaş',65368)#'>
                            <cfset garmentStruct.ButtonHeadList = '#getLang('','Düğme',65372)#'>
                            <cfset garmentStruct.ButtonHoleList = '#getLang('','İlik',65373)#'>
                            <cfset garmentStruct.TopStitchList = '#getLang('','Üst Dikiş',65371)#'>

                            <cfset selectedGarmentElements = XmlSearch(get_xml, "/Pacx/BOM/ColorWay/Garment/ColorWay")>
                            <cfloop array="#selectedGarmentElements[1].XmlChildren#" index="Garment">
                                <cfoutput>
                                    <cfloop array="#Garment.XmlChildren#" index="fabric">
                                        <cfif isdefined("fabric.XmlAttributes.Name")>
                                            <tr id="tr_#i#">       
                                                <input type="hidden" name="row_#i#" value="1">             
                                                   
                                                <td>#i#</td>                     
                                                <td>    
                                                    <!--- <cfif structKeyExists(garmentStruct,Garment.XmlName)>
                                                        #garmentStruct[Garment.XmlName]#
                                                    </cfif> --->                                                    
                                                    <select name="tree_types_#i#" id="tree_types">
                                                        <option value=""><cf_get_lang dictionary_id='63502.Bileşen Tipi'></option>
                                                        <cfloop query = "get_tree_types">
                                                            <option value="#get_tree_types.TYPE_ID#" <cfif isdefined("get_design_elements.tree_types_#Garment.XmlName#") and len(evaluate("get_design_elements.tree_types_#Garment.XmlName#")) and evaluate("get_design_elements.tree_types_#Garment.XmlName#") eq get_tree_types.TYPE_ID>selected</cfif>>#get_tree_types.TYPE#</option>
                                                        </cfloop>
                                                    </select>
                                                </td> 
                                                <td><input type="text" name="detail_#i#" value = "#fabric.XmlAttributes.Name#" readonly></td>  
                                                <td><input type = "text" value = "" name = "special_code_#i#" id = "special_code_#i#"></td>   
                                                <td><input type = "text" value = "" name = "quantity_#i#" id = "quantity_#i#"></td>   
                                                <td>
                                                    <cf_wrkoperationtype control_status='1' fieldName = "operation_type_id_#i#" fieldId = "operation_type_id_#i#" returnInputValue = "operation_type_id_#i#,operation_type_id_#i#" operation_type_id="#isdefined("get_design_elements.operation_type_id_#Garment.XmlName#") and len(evaluate("get_design_elements.operation_type_id_#Garment.XmlName#")) ? evaluate("get_design_elements.operation_type_id_#Garment.XmlName#"): ''#">   
                                                </td>
                                                <td>
                                                    <select name="alternative_questions_#i#" id="alternative_questions_#i#" style="width:110px;">
                                                        <option value=""><cf_get_lang dictionary_id='36616.Alternatif Soru Seçiniz'>!</option>
                                                        <cfloop query="get_alternative_questions">
                                                            <cfoutput><option value="#QUESTION_ID#">#QUESTION_NAME#</option></cfoutput>
                                                        </cfloop>
                                                    </select>
                                                </td>  
                                                <td><input type = "text" value = "" name = "stock_code_#i#" id = "stock_code_#i#"></td> 
                                                <td>
                                                    <div class="input-group">
                                                        <input type="hidden" name="unit_id_#i#" id="unit_id_#i#" value="<cfif isdefined("get_design_elements.unit_id_#Garment.XmlName#") and len(evaluate("get_design_elements.unit_id_#Garment.XmlName#"))><cfoutput>#evaluate("get_design_elements.unit_id_#Garment.XmlName#")#</cfoutput></cfif>">       
                                                        <input type="hidden" name="stock_id_#i#" id="stock_id_#i#" data-type="stock_id" value="<cfif isdefined("get_design_elements.stock_id_#Garment.XmlName#") and len(evaluate("get_design_elements.stock_id_#Garment.XmlName#"))><cfoutput>#evaluate("get_design_elements.stock_id_#Garment.XmlName#")#</cfoutput></cfif>">
                                                        <input type="hidden" name="product_id_#i#" id="product_id_#i#"  data-type="product_id" value="<cfif isdefined("get_design_elements.product_id_#Garment.XmlName#") and len(evaluate("get_design_elements.product_id_#Garment.XmlName#"))><cfoutput>#evaluate("get_design_elements.product_id_#Garment.XmlName#")#</cfoutput></cfif>">
                                                        <input type="text" name="product_name_#i#" id="product_name_#i#" data-type="product_name" value="<cfif isdefined("get_design_elements.product_name_#Garment.XmlName#") and len(evaluate("get_design_elements.product_name_#Garment.XmlName#"))><cfoutput>#evaluate("get_design_elements.product_name_#Garment.XmlName#")#</cfoutput></cfif>">
                                                        <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_name=formimport_settings.product_name_#i#&product_id=formimport_settings.product_id_#i#&field_id=formimport_settings.stock_id_#i#&field_unit=formimport_settings.unit_id_#i#')"></span>
                                                    </div>
                                                </td>     
                                                <td>
                                                    <div class="input-group">
                                                        <cfinput type="hidden" name="spect_main_name_#i#" id="spect_main_name_#i#" readonly="yes">
                                                            <input type="text" name="spect_main_id_#i#" id="spect_main_id_#i#" readonly>
                                                        <span class="input-group-addon icon-ellipsis btnPoniter" onclick="open_spec(#i#);"></span>
                                                    </div>		
                                                </td>   
                                                <td><input type = "text" value = "1" name = "quantity_wrk_#i#" id = "quantity_wrk_#i#"></td>   
                                                <td><input type = "text" value = "" name = "unit_#i#" id = "unit_#i#"></td>   
                                                <td><a onClick="delete_row(#i#)"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='58971.Satır Sil'>" ></i></a></td>                
                                            </tr>
                                            <cfset i++>
                                        </cfif>
                                    </cfloop>
                                </cfoutput>
                            </cfloop>

                            <!--- Grafik --->
                            <cfset selectedGraphicListElements = XmlSearch(get_xml, "/Pacx/BOM/ColorWay/GraphicList")>
                            <cfloop array="#selectedGraphicListElements[1].XmlChildren#" index="GraphicList">
                                <cfoutput>
                                    <tr id="tr_#i#"> 
                                        <input type="hidden" name="row_#i#" value="1">
                                        <td>#i#</td>                                   
                                        <td>
                                            <!--- <cf_get_lang dictionary_id='56387.Grafik'> --->
                                            <select name="tree_types_#i#" id="tree_types">
                                                <option value=""><cf_get_lang dictionary_id='63502.Bileşen Tipi'></option>
                                                <cfloop query = "get_tree_types">
                                                    <option value="#get_tree_types.TYPE_ID#" <cfif isdefined("get_design_elements.tree_types_GraphicList") and len(get_design_elements.tree_types_GraphicList) and get_design_elements.tree_types_GraphicList eq get_tree_types.TYPE_ID>selected</cfif>>#get_tree_types.TYPE#</option>
                                                </cfloop>
                                            </select>
                                        </td> 
                                        <td><input type="text" name="detail_#i#" value = "#GraphicList.XmlAttributes.Name#" readonly></td>  
                                        <td><input type = "text" value = "" name = "special_code_#i#" id = "special_code_#i#"></td>   
                                        <td><input type = "text" value = "" name = "quantity_#i#" id = "quantity_#i#"></td>   
                                        <td>
                                            <cf_wrkoperationtype control_status='1' fieldName = "operation_type_id_#i#" fieldId = "operation_type_id_#i#" returnInputValue = "operation_type_id_#i#,operation_type_id_#i#" operation_type_id="#isdefined("get_design_elements.operation_type_id_GraphicList") and len(get_design_elements.operation_type_id_GraphicList) ? get_design_elements.operation_type_id_GraphicList : ''#">   
                                        </td>
                                        <td>
                                            <select name="alternative_questions_#i#" id="alternative_questions_#i#" style="width:110px;">
                                                <option value=""><cf_get_lang dictionary_id='36616.Alternatif Soru Seçiniz'>!</option>
                                                <cfloop query="get_alternative_questions">
                                                    <cfoutput><option value="#QUESTION_ID#">#QUESTION_NAME#</option></cfoutput>
                                                </cfloop>
                                            </select>
                                        </td>  
                                        <td><input type = "text" value = "" name = "stock_code_#i#" id = "stock_code_#i#"></td> 
                                        <td>
                                            <div class="input-group">
                                                <input type="hidden" name="unit_id_#i#" id="unit_id_#i#" value="<cfif isdefined("get_design_elements.unit_id_GraphicList") and len(get_design_elements.unit_id_GraphicList)><cfoutput>#get_design_elements.unit_id_GraphicList#</cfoutput></cfif>">  
                                                <input type="hidden" name="stock_id_#i#" id="stock_id_#i#" data-type="stock_id" value="<cfif isdefined("get_design_elements.stock_id_GraphicList") and len(get_design_elements.stock_id_GraphicList)><cfoutput>#get_design_elements.stock_id_GraphicList#</cfoutput></cfif>">
                                                <input type="hidden" name="product_id_#i#" id="product_id_#i#"  data-type="product_id" value="<cfif isdefined("get_design_elements.product_id_GraphicList") and len(get_design_elements.product_id_GraphicList)><cfoutput>#get_design_elements.product_id_GraphicList#</cfoutput></cfif>">
                                                <input type="text" name="product_name_#i#" id="product_name_#i#" data-type="product_name" value="<cfif isdefined("get_design_elements.product_name_GraphicList") and len(get_design_elements.product_name_GraphicList)><cfoutput>#get_design_elements.product_name_GraphicList#</cfoutput></cfif>">
                                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_name=formimport_settings.product_name_#i#&product_id=formimport_settings.product_id_#i#&field_id=formimport_settings.stock_id_#i#&field_unit=formimport_settings.unit_id_#i#')"></span>
                                            </div>
                                        </td>   
                                        <td>
                                            <div class="input-group">
                                                <cfinput type="hidden" name="spect_main_name_#i#" id="spect_main_name_#i#" readonly="yes">
                                                    <input type="text" name="spect_main_id_#i#" id="spect_main_id_#i#" readonly>
                                                <span class="input-group-addon icon-ellipsis btnPoniter" onclick="open_spec(#i#);"></span>
                                            </div>		
                                        </td>   
                                        <td><input type = "text" value = "1" name = "quantity_wrk_#i#" id = "quantity_wrk_#i#"></td>   
                                        <td><input type = "text" value = "" name = "unit_#i#" id = "unit_#i#"></td>   
                                        <td><a onClick="delete_row(#i#)"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='58971.Satır Sil'>" ></i></a></td>               
                                    </tr>
                                </cfoutput>
                                <cfset i++>
                            </cfloop>

                            <!--- Büzüşme --->
                            <cfset selectedPuckeringListElements = XmlSearch(get_xml, "/Pacx/BOM/ColorWay/PuckeringList")>
                            <cfloop array="#selectedPuckeringListElements[1].XmlChildren#" index="PuckeringList">
                                <cfoutput>
                                    <tr id="tr_#i#">     
                                        <input type="hidden" name="row_#i#" value="1">             
                                        <td>#i#</td>                            
                                        <td>
                                            <!--- <cf_get_lang dictionary_id='65374.Büzüşme'> --->
                                            <select name="tree_types_#i#" id="tree_types">
                                                <option value=""><cf_get_lang dictionary_id='63502.Bileşen Tipi'></option>
                                                <cfloop query = "get_tree_types">
                                                    <option value="#get_tree_types.TYPE_ID#" <cfif isdefined("get_design_elements.tree_types_PuckeringList") and len(get_design_elements.tree_types_PuckeringList) and get_design_elements.tree_types_PuckeringList eq get_tree_types.TYPE_ID>selected</cfif>>#get_tree_types.TYPE#</option>
                                                </cfloop>
                                            </select>
                                        </td> 
                                        <td><input type="text" name="detail_#i#" value = "#PuckeringList.XmlAttributes.Name#" readonly></td>  
                                        <td><input type = "text" value = "" name = "special_code_#i#" id = "special_code_#i#"></td>   
                                        <td><input type = "text" value = "" name = "quantity_#i#" id = "quantity_#i#"></td>   
                                        <td>
                                            <cf_wrkoperationtype control_status='1' fieldName = "operation_type_id_#i#" fieldId = "operation_type_id_#i#" returnInputValue = "operation_type_id_#i#,operation_type_id_#i#" operation_type_id="#isdefined("get_design_elements.operation_type_id_PuckeringList") and len(get_design_elements.operation_type_id_PuckeringList) ? get_design_elements.operation_type_id_PuckeringList : ''#">                                
                                        </td>
                                        <td>
                                            <select name="alternative_questions_#i#" id="alternative_questions_#i#" style="width:110px;">
                                                <option value=""><cf_get_lang dictionary_id='36616.Alternatif Soru Seçiniz'>!</option>
                                                <cfloop query="get_alternative_questions">
                                                    <cfoutput><option value="#QUESTION_ID#">#QUESTION_NAME#</option></cfoutput>
                                                </cfloop>
                                            </select>
                                        </td>  
                                        <td><input type = "text" value = "" name = "stock_code_#i#" id = "stock_code_#i#"></td> 
                                        <td>
                                            <div class="input-group">
                                                <input type="hidden" name="unit_id_#i#" id="unit_id_#i#" value="<cfif isdefined("get_design_elements.unit_id_PuckeringList") and len(get_design_elements.unit_id_PuckeringList)><cfoutput>#get_design_elements.unit_id_PuckeringList#</cfoutput></cfif>">     
                                                <input type="hidden" name="stock_id_#i#" id="stock_id_#i#" data-type="stock_id" value="<cfif isdefined("get_design_elements.stock_id_PuckeringList") and len(get_design_elements.stock_id_PuckeringList)><cfoutput>#get_design_elements.stock_id_PuckeringList#</cfoutput></cfif>">
                                                <input type="hidden" name="product_id_#i#" id="product_id_#i#"  data-type="product_id" value="<cfif isdefined("get_design_elements.product_id_PuckeringList") and len(get_design_elements.product_id_PuckeringList)><cfoutput>#get_design_elements.product_id_PuckeringList#</cfoutput></cfif>">
                                                <input type="text" name="product_name_#i#" id="product_name_#i#" data-type="product_name" value="<cfif isdefined("get_design_elements.product_name_PuckeringList") and len(get_design_elements.product_name_PuckeringList)><cfoutput>#get_design_elements.product_name_PuckeringList#</cfoutput></cfif>">
                                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_name=formimport_settings.product_name_#i#&product_id=formimport_settings.product_id_#i#&field_id=formimport_settings.stock_id_#i#&field_unit=formimport_settings.unit_id_#i#')"></span>
                                            </div>
                                        </td>   
                                        <td>
                                            <div class="input-group">
                                                <cfinput type="hidden" name="spect_main_name_#i#" id="spect_main_name_#i#" readonly="yes">
                                                    <input type="text" name="spect_main_id_#i#" id="spect_main_id_#i#" readonly>
                                                <span class="input-group-addon icon-ellipsis btnPoniter" onclick="open_spec(#i#);"></span>
                                            </div>		
                                        </td>   
                                        <td><input type = "text" value = "1" name = "quantity_wrk_#i#" id = "quantity_wrk_#i#"></td>   
                                        <td><input type = "text" value = "" name = "unit_#i#" id = "unit_#i#"></td>   
                                        <td><a onClick="delete_row(#i#)"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='58971.Satır Sil'>" ></i></a></td>                       
                                    </tr>
                                </cfoutput>
                                <cfset i++>
                            </cfloop>
                        </tbody>
                    </cf_grid_list>
                </cf_box_elements>
            </div>
            
            <cf_box_footer> 
                <cf_workcube_buttons is_upd='0' add_function="control()" data_action ="V16/product/cfc/design_data:ADD_SUB_PRODUCT" insert_info="#getLang('','Verileri Import Et',55789)#" next_page="#request.self#?fuseaction=product.product_sample&event=upd&product_sample_id=#attributes.product_sample_id#"> 
            </cf_box_footer>
            
        </cfform>
    </cfif>
</cf_box>
<script>
    $("#template_file").on("input", function() {
        $("#file_label").val($("#template_file").val());
    });

    function pair_function() 
    {
        if($("#file_label").val() == "")
        {
            alert("<cf_get_lang dictionary_id='55938.Dosya Hatası. Lütfen Dosyanızı Kontrol Ediniz'>");
            return false;
        }
        loadPopupBox('formimport' , <cfoutput>#attributes.modal_id#</cfoutput>);
    }

    function open_spec(row)
    {
        if(document.getElementById("stock_id_"+row).value!='' && document.getElementById("product_id_"+row).value!='')
            windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_name=spect_main_name&field_main_id=spect_main_id_'+row+'&stock_id='+$("#stock_id_"+row).val(),'list')
        else
            alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57657.Ürün'>");
    }

    function delete_row(row)
    {
        $("#tr_"+row).remove();
    }

    function control() {
        $("#row_count").val("<cfoutput>#i#</cfoutput>");
        return true;
    }

</script>