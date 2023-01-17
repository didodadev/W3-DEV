<!---
    File: V16\product\display\design_data_settings.cfm
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 2022-04-12
    Description: Design data settings for CLO
--->
<cfset data_component = createObject("component","V16.product.cfc.design_data")>
<cfset get_tree_types = data_component.get_tree_types()>
<cfset get_design_data = data_component.GET_DESIGN_DATA_SETTINGS_ALL(data_type : attributes.data_type)>

<cf_box title="#getLang('','Design Data Import',65352)# - #getLang('','Ayarlar',57435)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#" >

    <cfif get_design_data.recordcount>
        <cfset get_design_elements = deserializeJSON(get_design_data.DESIGN_DATA_JSON)>
    <cfelse>
        <cfset get_design_elements = structNew()>
    </cfif>
   
    <cfform method="post" name="clo_w3_setting" id="clo_w3_setting">
        <cfinput type="hidden" name="data_type" value="#attributes.data_type#" />
        <cfinput type="hidden" name="product_sample_id" value="#attributes.product_sample_id#" />
        <cfinput type="hidden" name="modal_id" value="#attributes.modal_id#" />
        <cfif get_design_data.recordcount>
            <cfset get_design_elements = deserializeJSON(get_design_data.DESIGN_DATA_JSON)>
            <cfinput type="hidden" name="product_design_data_settings_id" value="#get_design_data.PRODUCT_DESIGN_DATA_SETTINGS_ID#" />
        <cfelse>
            <cfset get_design_elements = structNew()>
        </cfif>

        <cf_seperator title="#getLang('','Bileşen Tipleri',65365)# " id="component_types" index="1">
        <cf_box_elements id="component_types">
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-3">
                        <div class="form-group"><label class="bold col col-12 col-xs-12">CLO</label></div>
                    </div>
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-3">
                        <div class="form-group"><label class="bold col col-12 col-xs-12"><cf_get_lang dictionary_id='58783.Workcube'> - <cf_get_lang dictionary_id='63502.Bileşen Tipi'></label></div>
                    </div>
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-3">
                        <div class="form-group"><label class="bold col col-12 col-xs-12"><cf_get_lang dictionary_id='58783.Workcube'> - <cf_get_lang dictionary_id='57692.İşlem'></label></div>
                    </div>
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-3">
                        <div class="form-group"><label class="bold col col-12 col-xs-12"> <cf_get_lang dictionary_id='58783.Workcube'> - <cf_get_lang dictionary_id='65367.Şablon Ürün'></label></div>
                    </div>
                </div>                    
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-3">
                        <div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='65368.Kumaş'> - FabricList</label>
                            <div class="col col-3 col-xs-12">
                                <select name="tree_types_FabricList" id="tree_types">
                                    <option value=""><cf_get_lang dictionary_id='63502.Bileşen Tipi'></option>
                                    <cfoutput query = "get_tree_types">
                                        <option value="#TYPE_ID#" <cfif isdefined("get_design_elements.tree_types_FabricList") and len(get_design_elements.tree_types_FabricList) and get_design_elements.tree_types_FabricList eq TYPE_ID>selected</cfif>>#TYPE#</option>
                                    </cfoutput>
                                </select>
                            </div>
                            <div class="col col-3 col-xs-12">
                                <cf_wrkoperationtype control_status='1' fieldName = "operation_type_FabricList" fieldId = "operation_type_id_FabricList" returnInputValue = "operation_type_id_FabricList,operation_type_FabricList" operation_type_id="#isdefined("get_design_elements.operation_type_id_FabricList") and len(get_design_elements.operation_type_id_FabricList) ? get_design_elements.operation_type_id_FabricList : ''#">   
                            </div>
                            <div class="col col-3 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="unit_id_FabricList" id="unit_id_FabricList" value="<cfif isdefined("get_design_elements.unit_id_FabricList") and len(get_design_elements.unit_id_FabricList)><cfoutput>#get_design_elements.unit_id_FabricList#</cfoutput></cfif>">
                                    <input type="hidden" name="stock_id_FabricList" id="stock_id_FabricList" value="<cfif isdefined("get_design_elements.stock_id_FabricList") and len(get_design_elements.stock_id_FabricList)><cfoutput>#get_design_elements.stock_id_FabricList#</cfoutput></cfif>">
                                    <input type="hidden" name="product_id_FabricList" id="product_id_FabricList"  data-type="product_id" value="<cfif isdefined("get_design_elements.product_id_FabricList") and len(get_design_elements.product_id_FabricList)><cfoutput>#get_design_elements.product_id_FabricList#</cfoutput></cfif>">
                                    <input type="text" name="product_name_FabricList" id="product_name_FabricList" data-type="product_name" value="<cfif isdefined("get_design_elements.product_name_FabricList") and len(get_design_elements.product_name_FabricList)><cfoutput>#get_design_elements.product_name_FabricList#</cfoutput></cfif>">
                                    <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_name=clo_w3_setting.product_name_FabricList&product_id=clo_w3_setting.product_id_FabricList&field_id=clo_w3_setting.stock_id_FabricList&field_unit=clo_w3_setting.unit_id_FabricList')"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='65369.Kalıp'> - PatternList</label>
                            <div class="col col-3 col-xs-12">
                                <select name="tree_types_PatternList" id="tree_types">
                                    <option value=""><cf_get_lang dictionary_id='63502.Bileşen Tipi'></option>
                                    <cfoutput query="get_tree_types">
                                        <option value="#TYPE_ID#" <cfif isdefined("get_design_elements.tree_types_PatternList") and len(get_design_elements.tree_types_PatternList) and get_design_elements.tree_types_PatternList eq TYPE_ID>selected</cfif>>#TYPE#</option>
                                    </cfoutput>
                                </select>
                            </div>
                            <div class="col col-3 col-xs-12">
                                <cf_wrkoperationtype control_status='1' fieldName = "operation_type_PatternList" fieldId = "operation_type_id_PatternList" returnInputValue = "operation_type_id_PatternList,operation_type_PatternList" operation_type_id="#isdefined("get_design_elements.operation_type_id_PatternList") and len(get_design_elements.operation_type_id_PatternList) ? get_design_elements.operation_type_id_PatternList : ''#">   
                            </div>
                            <div class="col col-3 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="unit_id_PatternList" id="unit_id_PatternList" value="<cfif isdefined("get_design_elements.unit_id_PatternList") and len(get_design_elements.unit_id_PatternList)><cfoutput>#get_design_elements.unit_id_PatternList#</cfoutput></cfif>">
                                    <input type="hidden" name="stock_id_PatternList" id="stock_id_PatternList" value="<cfif isdefined("get_design_elements.stock_id_PatternList") and len(get_design_elements.stock_id_PatternList)><cfoutput>#get_design_elements.stock_id_PatternList#</cfoutput></cfif>">
                                    <input type="hidden" name="product_id_PatternList" id="product_id_PatternList" data-type="product_id" value="<cfif isdefined("get_design_elements.product_id_PatternList") and len(get_design_elements.product_id_PatternList)><cfoutput>#get_design_elements.product_id_PatternList#</cfoutput></cfif>">
                                    <input type="text" name="product_name_PatternList" id="product_name_PatternList" data-type="product_name" value="<cfif isdefined("get_design_elements.product_name_PatternList") and len(get_design_elements.product_name_PatternList)><cfoutput>#get_design_elements.product_name_PatternList#</cfoutput></cfif>">
                                    <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_name=clo_w3_setting.product_name_PatternList&product_id=clo_w3_setting.product_id_PatternList&field_id=clo_w3_setting.stock_id_PatternList&field_unit=clo_w3_setting.unit_id_PatternList')"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='65370.Dikiş'> - Sewing</label>
                            <div class="col col-3 col-xs-12">
                                <select name="tree_types_SewingList" id="tree_types">
                                    <option value=""><cf_get_lang dictionary_id='63502.Bileşen Tipi'></option>
                                    <cfoutput query="get_tree_types">
                                        <option value="#TYPE_ID#" <cfif isdefined("get_design_elements.tree_types_SewingList") and len(get_design_elements.tree_types_SewingList) and get_design_elements.tree_types_SewingList eq TYPE_ID>selected</cfif>>#TYPE#</option>
                                    </cfoutput>
                                </select>
                            </div>
                            <div class="col col-3 col-xs-12">
                                <cf_wrkoperationtype control_status='1' fieldName = "operation_type_SewingList" fieldId = "operation_type_id_SewingList" returnInputValue = "operation_type_id_SewingList,operation_type_SewingList" operation_type_id="#isdefined("get_design_elements.operation_type_id_SewingList") and len(get_design_elements.operation_type_id_SewingList) ? get_design_elements.operation_type_id_SewingList : ''#">   
                            </div>
                            <div class="col col-3 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="unit_id_SewingList" id="unit_id_SewingList" value="<cfif isdefined("get_design_elements.unit_id_SewingList") and len(get_design_elements.unit_id_SewingList)><cfoutput>#get_design_elements.unit_id_SewingList#</cfoutput></cfif>">
                                    <input type="hidden" name="stock_id_SewingList" id="stock_id_SewingList" value="<cfif isdefined("get_design_elements.stock_id_SewingList") and len(get_design_elements.stock_id_SewingList)><cfoutput>#get_design_elements.stock_id_SewingList#</cfoutput></cfif>">
                                    <input type="hidden" name="product_id_SewingList" id="product_id_SewingList" data-type="product_id" value="<cfif isdefined("get_design_elements.product_id_SewingList") and len(get_design_elements.product_id_SewingList)><cfoutput>#get_design_elements.product_id_SewingList#</cfoutput></cfif>">
                                    <input type="text" name="product_name_SewingList" id="product_name_SewingList" data-type="product_name" value="<cfif isdefined("get_design_elements.product_name_SewingList") and len(get_design_elements.product_name_SewingList)><cfoutput>#get_design_elements.product_name_SewingList#</cfoutput></cfif>">
                                    <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_name=clo_w3_setting.product_name_SewingList&product_id=clo_w3_setting.product_id_SewingList&field_id=clo_w3_setting.stock_id_SewingList&field_unit=clo_w3_setting.unit_id_SewingList')"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='65371.Üst Dikiş'> - TopStitchList</label>
                            <div class="col col-3 col-xs-12">
                                <select name="tree_types_TopStitchList" id="tree_types_TopStitchList">
                                    <option value=""><cf_get_lang dictionary_id='63502.Bileşen Tipi'></option>
                                    <cfoutput query="get_tree_types">
                                        <option value="#TYPE_ID#" <cfif isdefined("get_design_elements.tree_types_TopStitchList") and len(get_design_elements.tree_types_TopStitchList) and get_design_elements.tree_types_TopStitchList eq TYPE_ID>selected</cfif>>#TYPE#</option>
                                    </cfoutput>
                                </select>
                            </div>
                            <div class="col col-3 col-xs-12">
                                <cf_wrkoperationtype control_status='1' fieldName = "operation_type_TopStitchList" fieldId = "operation_type_id_TopStitchList" returnInputValue = "operation_type_id_TopStitchList,operation_type_TopStitchList" operation_type_id="#isdefined("get_design_elements.operation_type_id_TopStitchList") and len(get_design_elements.operation_type_id_TopStitchList) ? get_design_elements.operation_type_id_TopStitchList : ''#">   
                            </div>
                            <div class="col col-3 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="unit_id_TopStitchList" id="unit_id_TopStitchList" value="<cfif isdefined("get_design_elements.unit_id_TopStitchList") and len(get_design_elements.unit_id_TopStitchList)><cfoutput>#get_design_elements.unit_id_TopStitchList#</cfoutput></cfif>">
                                    <input type="hidden" name="stock_id_TopStitchList" id="stock_id_TopStitchList" value="<cfif isdefined("get_design_elements.stock_id_TopStitchList") and len(get_design_elements.stock_id_TopStitchList)><cfoutput>#get_design_elements.stock_id_TopStitchList#</cfoutput></cfif>">
                                    <input type="hidden" name="product_id_TopStitchList" id="product_id_TopStitchList" data-type="product_id" value="<cfif isdefined("get_design_elements.product_id_TopStitchList") and len(get_design_elements.product_id_TopStitchList)><cfoutput>#get_design_elements.product_id_TopStitchList#</cfoutput></cfif>">
                                    <input type="text" name="product_name_TopStitchList" id="product_name_TopStitchList" data-type="product_name" value="<cfif isdefined("get_design_elements.product_name_TopStitchList") and len(get_design_elements.product_name_TopStitchList)><cfoutput>#get_design_elements.product_name_TopStitchList#</cfoutput></cfif>">
                                    <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_name=clo_w3_setting.product_name_TopStitchList&product_id=clo_w3_setting.product_id_TopStitchList&field_id=clo_w3_setting.stock_id_TopStitchList&field_unit=clo_w3_setting.unit_id_TopStitchList')"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='65372.Düğme'> - ButtonHeadList</label>
                            <div class="col col-3 col-xs-12">
                                <select name="tree_types_ButtonHeadList" id="tree_types_ButtonHeadList">
                                    <option value=""><cf_get_lang dictionary_id='63502.Bileşen Tipi'></option>
                                    <cfoutput query="get_tree_types">
                                        <option value="#TYPE_ID#" <cfif isdefined("get_design_elements.tree_types_ButtonHeadList") and len(get_design_elements.tree_types_ButtonHeadList) and get_design_elements.tree_types_ButtonHeadList eq TYPE_ID>selected</cfif>>#TYPE#</option>
                                    </cfoutput>
                                </select>
                            </div>
                            <div class="col col-3 col-xs-12">
                                <cf_wrkoperationtype control_status='1' fieldName = "operation_type_ButtonHeadList" fieldId = "operation_type_id_ButtonHeadList" returnInputValue = "operation_type_id_ButtonHeadList,operation_type_ButtonHeadList" operation_type_id="#isdefined("get_design_elements.operation_type_id_ButtonHeadList") and len(get_design_elements.operation_type_id_ButtonHeadList) ? get_design_elements.operation_type_id_ButtonHeadList : ''#">   
                            </div>
                            <div class="col col-3 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="unit_id_ButtonHeadList" id="unit_id_ButtonHeadList" value="<cfif isdefined("get_design_elements.unit_id_ButtonHeadList") and len(get_design_elements.unit_id_ButtonHeadList)><cfoutput>#get_design_elements.unit_id_ButtonHeadList#</cfoutput></cfif>">
                                    <input type="hidden" name="stock_id_ButtonHeadList" id="stock_id_ButtonHeadList" value="<cfif isdefined("get_design_elements.stock_id_ButtonHeadList") and len(get_design_elements.stock_id_ButtonHeadList)><cfoutput>#get_design_elements.stock_id_ButtonHeadList#</cfoutput></cfif>">
                                    <input type="hidden" name="product_id_ButtonHeadList" id="product_id_ButtonHeadList" data-type="product_id" value="<cfif isdefined("get_design_elements.product_id_ButtonHeadList") and len(get_design_elements.product_id_ButtonHeadList)><cfoutput>#get_design_elements.product_id_ButtonHeadList#</cfoutput></cfif>">
                                    <input type="text" name="product_name_ButtonHeadList" id="product_name_ButtonHeadList" data-type="product_name" value="<cfif isdefined("get_design_elements.product_name_ButtonHeadList") and len(get_design_elements.product_name_ButtonHeadList)><cfoutput>#get_design_elements.product_name_ButtonHeadList#</cfoutput></cfif>">
                                    <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_name=clo_w3_setting.product_name_ButtonHeadList&product_id=clo_w3_setting.product_id_ButtonHeadList&field_id=clo_w3_setting.stock_id_ButtonHeadList&field_unit=clo_w3_setting.unit_id_ButtonHeadList')"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='65373.İlik'> - ButtonHoleList</label>
                            <div class="col col-3 col-xs-12">
                                <select name="tree_types_ButtonHoleList" id="tree_types_ButtonHoleList">
                                    <option value=""><cf_get_lang dictionary_id='63502.Bileşen Tipi'></option>
                                    <cfoutput query="get_tree_types">
                                        <option value="#TYPE_ID#" <cfif isdefined("get_design_elements.tree_types_ButtonHoleList") and len(get_design_elements.tree_types_ButtonHoleList) and get_design_elements.tree_types_ButtonHoleList eq TYPE_ID>selected</cfif>>#TYPE#</option>
                                    </cfoutput>
                                </select>
                            </div>
                            <div class="col col-3 col-xs-12">
                                <cf_wrkoperationtype control_status='1' fieldName = "operation_type_ButtonHoleList" fieldId = "operation_type_id_ButtonHoleList" returnInputValue = "operation_type_id_ButtonHoleList,operation_type_ButtonHoleList" operation_type_id="#isdefined("get_design_elements.operation_type_id_ButtonHoleList") and len(get_design_elements.operation_type_id_ButtonHoleList) ? get_design_elements.operation_type_id_ButtonHoleList : ''#">   
                            </div>
                            <div class="col col-3 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="unit_id_ButtonHoleList" id="unit_id_ButtonHoleList" value="<cfif isdefined("get_design_elements.unit_id_ButtonHoleList") and len(get_design_elements.unit_id_ButtonHoleList)><cfoutput>#get_design_elements.unit_id_ButtonHoleList#</cfoutput></cfif>">
                                    <input type="hidden" name="stock_id_ButtonHoleList" id="stock_id_ButtonHoleList" value="<cfif isdefined("get_design_elements.stock_id_ButtonHoleList") and len(get_design_elements.stock_id_ButtonHoleList)><cfoutput>#get_design_elements.stock_id_ButtonHoleList#</cfoutput></cfif>">
                                    <input type="hidden" name="product_id_ButtonHoleList" id="product_id_ButtonHoleList" data-type="product_id" value="<cfif isdefined("get_design_elements.product_id_ButtonHoleList") and len(get_design_elements.product_id_ButtonHoleList)><cfoutput>#get_design_elements.product_id_ButtonHoleList#</cfoutput></cfif>">
                                    <input type="text" name="product_name_ButtonHoleList" id="product_name_ButtonHoleList" data-type="product_name" value="<cfif isdefined("get_design_elements.product_name_ButtonHoleList") and len(get_design_elements.product_name_ButtonHoleList)><cfoutput>#get_design_elements.product_name_ButtonHoleList#</cfoutput></cfif>">
                                    <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_name=clo_w3_setting.product_name_ButtonHoleList&product_id=clo_w3_setting.product_id_ButtonHoleList&field_id=clo_w3_setting.stock_id_ButtonHoleList&field_unit=clo_w3_setting.unit_id_ButtonHoleList')"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='65374.Büzüşme'> - PuckeringList</label>
                            <div class="col col-3 col-xs-12">
                                <select name="tree_types_PuckeringList" id="tree_types_PuckeringList">
                                    <option value=""><cf_get_lang dictionary_id='63502.Bileşen Tipi'></option>
                                    <cfoutput query="get_tree_types">
                                        <option value="#TYPE_ID#" <cfif isdefined("get_design_elements.tree_types_PuckeringList") and len(get_design_elements.tree_types_PuckeringList) and get_design_elements.tree_types_PuckeringList eq TYPE_ID>selected</cfif>>#TYPE#</option>
                                    </cfoutput>
                                </select>
                            </div>
                            <div class="col col-3 col-xs-12">
                                <cf_wrkoperationtype control_status='1' fieldName = "operation_type_PuckeringList" fieldId = "operation_type_id_PuckeringList" returnInputValue = "operation_type_id_PuckeringList,operation_type_PuckeringList" operation_type_id="#isdefined("get_design_elements.operation_type_id_PuckeringList") and len(get_design_elements.operation_type_id_PuckeringList) ? get_design_elements.operation_type_id_PuckeringList : ''#">   
                            </div>
                            <div class="col col-3 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="unit_id_PuckeringList" id="unit_id_PuckeringList" value="<cfif isdefined("get_design_elements.unit_id_PuckeringList") and len(get_design_elements.unit_id_PuckeringList)><cfoutput>#get_design_elements.unit_id_PuckeringList#</cfoutput></cfif>">
                                    <input type="hidden" name="stock_id_PuckeringList" id="stock_id_PuckeringList" value="<cfif isdefined("get_design_elements.stock_id_PuckeringList") and len(get_design_elements.stock_id_PuckeringList)><cfoutput>#get_design_elements.stock_id_PuckeringList#</cfoutput></cfif>">
                                    <input type="hidden" name="product_id_PuckeringList" id="product_id_PuckeringList" data-type="product_id" value="<cfif isdefined("get_design_elements.product_id_PuckeringList") and len(get_design_elements.product_id_PuckeringList)><cfoutput>#get_design_elements.product_id_PuckeringList#</cfoutput></cfif>">
                                    <input type="text" name="product_name_PuckeringList" id="product_name_PuckeringList" data-type="product_name" value="<cfif isdefined("get_design_elements.product_name_PuckeringList") and len(get_design_elements.product_name_PuckeringList)><cfoutput>#get_design_elements.product_name_PuckeringList#</cfoutput></cfif>">
                                    <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_name=clo_w3_setting.product_name_PuckeringList&product_id=clo_w3_setting.product_id_PuckeringList&field_id=clo_w3_setting.stock_id_PuckeringList&field_unit=clo_w3_setting.unit_id_PuckeringList')"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='56387.Grafik'> - GraphicList</label>
                            <div class="col col-3 col-xs-12">
                                <select name="tree_types_GraphicList" id="tree_types_GraphicList">
                                    <option value=""><cf_get_lang dictionary_id='63502.Bileşen Tipi'></option>
                                    <cfoutput query="get_tree_types">
                                        <option value="#TYPE_ID#" <cfif isdefined("get_design_elements.tree_types_GraphicList") and len(get_design_elements.tree_types_GraphicList) and get_design_elements.tree_types_GraphicList eq TYPE_ID>selected</cfif>>#TYPE#</option>
                                    </cfoutput>
                                </select>
                            </div>
                            <div class="col col-3 col-xs-12">
                                <cf_wrkoperationtype control_status='1' fieldName = "operation_type_GraphicList" fieldId = "operation_type_id_GraphicList" returnInputValue = "operation_type_id_GraphicList,operation_type_GraphicList" operation_type_id="#isdefined("get_design_elements.operation_type_id_GraphicList") and len(get_design_elements.operation_type_id_GraphicList) ? get_design_elements.operation_type_id_GraphicList : ''#">   
                            </div>
                            <div class="col col-3 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="unit_id_GraphicList" id="unit_id_GraphicList" value="<cfif isdefined("get_design_elements.unit_id_GraphicList") and len(get_design_elements.unit_id_GraphicList)><cfoutput>#get_design_elements.unit_id_GraphicList#</cfoutput></cfif>">
                                    <input type="hidden" name="stock_id_GraphicList" id="stock_id_GraphicList" value="<cfif isdefined("get_design_elements.stock_id_GraphicList") and len(get_design_elements.stock_id_GraphicList)><cfoutput>#get_design_elements.stock_id_GraphicList#</cfoutput></cfif>">
                                    <input type="hidden" name="product_id_GraphicList" id="product_id_GraphicList" data-type="product_id" value="<cfif isdefined("get_design_elements.product_id_GraphicList") and len(get_design_elements.product_id_GraphicList)><cfoutput>#get_design_elements.product_id_GraphicList#</cfoutput></cfif>">
                                    <input type="text" name="product_name_GraphicList" id="product_name_GraphicList" data-type="product_name" value="<cfif isdefined("get_design_elements.product_name_GraphicList") and len(get_design_elements.product_name_GraphicList)><cfoutput>#get_design_elements.product_name_GraphicList#</cfoutput></cfif>">
                                    <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_name=clo_w3_setting.product_name_GraphicList&product_id=clo_w3_setting.product_id_GraphicList&field_id=clo_w3_setting.stock_id_GraphicList&field_unit=clo_w3_setting.unit_id_GraphicList')"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='47692.Baskı'> - PrintLayoutList</label>
                            <div class="col col-3 col-xs-12">
                                <select name="tree_types_PrintLayoutList" id="tree_types_PrintLayoutList">
                                    <option value=""><cf_get_lang dictionary_id='63502.Bileşen Tipi'></option>
                                    <cfoutput query="get_tree_types">
                                        <option value="#TYPE_ID#" <cfif isdefined("get_design_elements.tree_types_PrintLayoutList") and len(get_design_elements.tree_types_PrintLayoutList) and get_design_elements.tree_types_PrintLayoutList eq TYPE_ID>selected</cfif>>#TYPE#</option>
                                    </cfoutput>
                                </select>
                            </div>
                            <div class="col col-3 col-xs-12">
                                <cf_wrkoperationtype control_status='1' fieldName = "operation_type_PrintLayoutList" fieldId = "operation_type_id_PrintLayoutList" returnInputValue = "operation_type_id_PrintLayoutList,operation_type_PrintLayoutList" operation_type_id="#isdefined("get_design_elements.operation_type_id_PrintLayoutList") and len(get_design_elements.operation_type_id_PrintLayoutList) ? get_design_elements.operation_type_id_PrintLayoutList : ''#">   
                            </div>
                            <div class="col col-3 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="unit_id_PrintLayoutList" id="unit_id_PrintLayoutList" value="<cfif isdefined("get_design_elements.unit_id_PrintLayoutList") and len(get_design_elements.unit_id_PrintLayoutList)><cfoutput>#get_design_elements.unit_id_PrintLayoutList#</cfoutput></cfif>">
                                    <input type="hidden" name="stock_id_PrintLayoutList" id="stock_id_PrintLayoutList" value="<cfif isdefined("get_design_elements.stock_id_PrintLayoutList") and len(get_design_elements.stock_id_PrintLayoutList)><cfoutput>#get_design_elements.stock_id_PrintLayoutList#</cfoutput></cfif>">
                                    <input type="hidden" name="product_id_PrintLayoutList" id="product_id_PrintLayoutList" data-type="product_id" value="<cfif isdefined("get_design_elements.product_id_PrintLayoutList") and len(get_design_elements.product_id_PrintLayoutList)><cfoutput>#get_design_elements.product_id_PrintLayoutList#</cfoutput></cfif>">
                                    <input type="text" name="product_name_PrintLayoutList" id="product_name_PrintLayoutList" data-type="product_name" value="<cfif isdefined("get_design_elements.product_name_PrintLayoutList") and len(get_design_elements.product_name_PrintLayoutList)><cfoutput>#get_design_elements.product_name_PrintLayoutList#</cfoutput></cfif>">
                                    <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_name=clo_w3_setting.product_name_PrintLayoutList&product_id=clo_w3_setting.product_id_PrintLayoutList&field_id=clo_w3_setting.stock_id_PrintLayoutList&field_unit=clo_w3_setting.unit_id_PrintLayoutList')"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='65375.Fermuar'></label>
                            <div class="col col-3 col-xs-12">
                                <select name="tree_types_zipperList" id="tree_types_zipperList">
                                    <option value=""><cf_get_lang dictionary_id='63502.Bileşen Tipi'></option>
                                    <cfoutput query="get_tree_types">
                                        <option value="#TYPE_ID#" <cfif isdefined("get_design_elements.tree_types_zipperList") and len(get_design_elements.tree_types_zipperList) and get_design_elements.tree_types_zipperList eq TYPE_ID>selected</cfif>>#TYPE#</option>
                                    </cfoutput>
                                </select>
                            </div>
                            <div class="col col-3 col-xs-12">
                                <cf_wrkoperationtype control_status='1' fieldName = "operation_type_zipperList" fieldId = "operation_type_id_zipperList" returnInputValue = "operation_type_id_zipperList,operation_type_zipperList" operation_type_id="#isdefined("get_design_elements.operation_type_id_zipperList") and len(get_design_elements.operation_type_id_zipperList) ? get_design_elements.operation_type_id_zipperList : ''#">   
                            </div>
                            <div class="col col-3 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="unit_id_zipperList" id="unit_id_zipperList" value="<cfif isdefined("get_design_elements.unit_id_zipperList") and len(get_design_elements.unit_id_zipperList)><cfoutput>#get_design_elements.unit_id_zipperList#</cfoutput></cfif>">
                                    <input type="hidden" name="stock_id_zipperList" id="stock_id_zipperList" value="<cfif isdefined("get_design_elements.stock_id_zipperList") and len(get_design_elements.stock_id_zipperList)><cfoutput>#get_design_elements.stock_id_zipperList#</cfoutput></cfif>">
                                    <input type="hidden" name="product_id_zipperList" id="product_id_zipperList" data-type="product_id" value="<cfif isdefined("get_design_elements.product_id_zipperList") and len(get_design_elements.product_id_zipperList)><cfoutput>#get_design_elements.product_id_zipperList#</cfoutput></cfif>">
                                    <input type="text" name="product_name_zipperList" id="product_name_zipperList" data-type="product_name" value="<cfif isdefined("get_design_elements.product_name_zipperList") and len(get_design_elements.product_name_zipperList)><cfoutput>#get_design_elements.product_name_zipperList#</cfoutput></cfif>">
                                    <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_name=clo_w3_setting.product_name_zipperList&product_id=clo_w3_setting.product_id_zipperList&field_id=clo_w3_setting.stock_id_zipperList&field_unit=clo_w3_setting.unit_id_zipperList')"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='91.Accessories'></label>
                            <div class="col col-3 col-xs-12">
                                <select name="tree_types_AccessoriesList" id="tree_types_AccessoriesList">
                                    <option value=""><cf_get_lang dictionary_id='63502.Bileşen Tipi'></option>
                                    <cfoutput query="get_tree_types">
                                        <option value="#TYPE_ID#" <cfif isdefined("get_design_elements.tree_types_AccessoriesList") and len(get_design_elements.tree_types_AccessoriesList) and get_design_elements.tree_types_AccessoriesList eq TYPE_ID>selected</cfif>>#TYPE#</option>
                                    </cfoutput>
                                </select>
                            </div>
                            <div class="col col-3 col-xs-12">
                                <cf_wrkoperationtype control_status='1' fieldName = "operation_type_AccessoriesList" fieldId = "operation_type_id_AccessoriesList" returnInputValue = "operation_type_id_AccessoriesList,operation_type_AccessoriesList" operation_type_id="#isdefined("get_design_elements.operation_type_id_AccessoriesList") and len(get_design_elements.operation_type_id_AccessoriesList) ? get_design_elements.operation_type_id_AccessoriesList : ''#">   
                            </div>
                            <div class="col col-3 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="unit_id_AccessoriesList" id="unit_id_AccessoriesList" value="<cfif isdefined("get_design_elements.unit_id_AccessoriesList") and len(get_design_elements.unit_id_AccessoriesList)><cfoutput>#get_design_elements.unit_id_AccessoriesList#</cfoutput></cfif>">
                                    <input type="hidden" name="stock_id_AccessoriesList" id="stock_id_AccessoriesList" value="<cfif isdefined("get_design_elements.stock_id_AccessoriesList") and len(get_design_elements.stock_id_AccessoriesList)><cfoutput>#get_design_elements.stock_id_AccessoriesList#</cfoutput></cfif>">
                                    <input type="hidden" name="product_id_AccessoriesList" id="product_id_AccessoriesList" data-type="product_id" value="<cfif isdefined("get_design_elements.product_id_AccessoriesList") and len(get_design_elements.product_id_AccessoriesList)><cfoutput>#get_design_elements.product_id_AccessoriesList#</cfoutput></cfif>">
                                    <input type="text" name="product_name_AccessoriesList" id="product_name_AccessoriesList" data-type="product_name" value="<cfif isdefined("get_design_elements.product_name_AccessoriesList") and len(get_design_elements.product_name_AccessoriesList)><cfoutput>#get_design_elements.product_name_AccessoriesList#</cfoutput></cfif>">
                                    <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_name=clo_w3_setting.product_name_AccessoriesList&product_id=clo_w3_setting.product_id_AccessoriesList&field_id=clo_w3_setting.stock_id_AccessoriesList&field_unit=clo_w3_setting.unit_id_AccessoriesList')"></span>
                                </div>
                            </div>
                        </div>
                    </div>  
                </div>
            </div>
        </cf_box_elements>
        
        <cf_seperator title="#getLang('','Renk',199)# " id="color" index="2">
        <cf_box_elements id="colors">
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                <label>ColorWay Name</label>
            </div>
        </cf_box_elements>

        <cf_seperator title="#getLang('','Beden',37324)# " id="granding" index="3">
        <cf_box_elements id="granding">
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                <label>GradingRuleTable --> GradingItem --> GradingItem_GradingList --> GradingItem_Grading</label>
            </div>
        </cf_box_elements>

        <cf_seperator title="#getLang('','Asorti',38015)# " id="assortment" index="4">
        <cf_box_elements id="assortment">
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                <label>GradingItem_Grading x Colorway Name</label>
            </div>
        </cf_box_elements>
            
        <cf_seperator title="#getLang('','Kesim Listesi',51656)# " id="pattern" index="5">
        <cf_box_elements id="pattern">
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                <label>Pattern List x GradingItem_Grading x Colorway Name</label>
            </div>
        </cf_box_elements>

        <cf_box_footer>
            <cfif get_design_data.recordcount>
                <cf_record_info query_name="get_design_data">
                <cf_workcube_buttons 
                    is_upd='1' 
                    add_function="control()" 
                    data_action ="V16/product/cfc/design_data:UPD_DESIGN_DATA_SETTINGS"
                    del_action= 'V16/product/cfc/design_data:DEL_DESIGN_DATA_SETTINGS:product_design_data_settings_id=#get_design_data.product_design_data_settings_id#'
                    del_next_page = '#request.self#?fuseaction=product.product_sample&event=upd&product_sample_id=#attributes.product_sample_id#'>
            <cfelse>
                <cf_workcube_buttons is_upd='0' add_function="control()" data_action ="V16/product/cfc/design_data:ADD_DESIGN_DATA_SETTINGS">
            </cfif>
        </cf_box_footer>
    </cfform>
</cf_box>
<script>

    function control()
    {
        $('input[data-type = product_name]').each(function() {
            if(this.value == '')
            {
                product_name_ = this.name.split("product_name_");
                $("#product_id_"+product_name_[1]).val('');
            }
           
        });
    }

    function openService(code,id) {
        openBoxDraggable('<cfoutput>#request.self#?fuseaction=product.design_data&event=settings&data_type=#attributes.data_type#&product_sample_id=#attributes.product_sample_id#&main_product_id=#attributes.main_product_id#&stock_id=#attributes.stock_id#</cfoutput>');
        closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>');

        return false;
    }
</script>