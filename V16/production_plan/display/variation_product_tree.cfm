<cfquery name="get_all_product_propert" datasource="#dsn3#">
    SELECT * FROM STOCKS WHERE PRODUCT_ID = #attributes.pid# ORDER BY RECORD_DATE DESC
</cfquery>
<cfquery name="tree_control" datasource="#dsn3#">
    SELECT 
        ISNULL(ALTERNATIVE_PROCESS,1) AS ALTERNATIVE_PROCESS,
        QUESTION_NAME 
    FROM 
        PRODUCT_TREE AS PT 
    LEFT JOIN #dsn#.SETUP_ALTERNATIVE_QUESTIONS AS SAQ ON SAQ.QUESTION_ID = PT.QUESTION_ID 
    WHERE PT.STOCK_ID = #attributes.stock_id# AND QUESTION_NAME IS NOT NULL
</cfquery>
<cfset alt_type_1 = listValueCount(valuelist(tree_control.ALTERNATIVE_PROCESS),1)>
<cfset alt_type_2 = listValueCount(valuelist(tree_control.ALTERNATIVE_PROCESS),2)>
<cfset alt_type_3 = listValueCount(valuelist(tree_control.ALTERNATIVE_PROCESS),3)>
<cfset alternative_questions_name = valueList(tree_control.QUESTION_NAME)>
<cfset alternative_questions_process = valueList(tree_control.ALTERNATIVE_PROCESS)>
<cfinclude template="../../product/query/get_product_stock_detail.cfm">

<cf_box title="#getLang('','Varyasonlara Göre Ürün Ağaçları',63523)#" closable="1" popup_box="1">
    <cfform name="add_variation_product" method="post" action="#request.self#?fuseaction=prod.emptypopup_copy_product_tree">
        <input type="hidden" name="alternative_count" value="<cfoutput>#listlen(alternative_questions_name)#</cfoutput>">
        <input type="hidden" name="from_stock_id" value="<cfoutput>#attributes.stock_id#</cfoutput>">
        <input type="hidden" name="question_type_1" value="<cfoutput>#alt_type_1#</cfoutput>">
        <input type="hidden" name="question_type_2" value="<cfoutput>#alt_type_2#</cfoutput>">
        <input type="hidden" name="question_type_3" value="<cfoutput>#alt_type_3#</cfoutput>">
        <input type="hidden" name="is_submit">
        <div class="ui-info-bottom">
            <div class="col col-3 col-md-3 col-xs-12">
                <p><b><cf_get_lang dictionary_id='57657.Ürün'> :</b> <cfoutput>#get_all_product_propert.PRODUCT_NAME#</cfoutput></p>
            </div>
            <div class="col col-3 col-md-3 col-xs-12">
                <p><b><cf_get_lang dictionary_id='58800.Ürün Kodu'> :</b> <cfoutput>#get_all_product_propert.PRODUCT_CODE#</cfoutput></p>
            </div>
            <div class="col col-3 col-md-3 col-xs-12">
                <p><b><cf_get_lang dictionary_id='63453.Ana Stok Kodu'> :</b> <cfoutput>#get_all_product_propert.PRODUCT_CODE#</cfoutput></p>
            </div>
            <div class="col col-3 col-md-3 col-xs-12">
                <p><b><cf_get_lang dictionary_id='57633.Barkod'> :</b> <cfoutput>#get_all_product_propert.PRODUCT_BARCOD#</cfoutput></p>
            </div>
        </div>
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='57487.No'></th>
                    <th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
                    <th><cf_get_lang dictionary_id='57789.Özel Kod'></th>
                    <th><cf_get_lang dictionary_id='57647.Spec'></th>
                    <th><cf_get_lang dictionary_id='36199.Açıklama'></th>
                    <cfloop from="1" to="#listlen(alternative_questions_name)#" index="i">
                        <th><cfoutput>#listGetAt(alternative_questions_name,i,',')#</cfoutput></th>
                    </cfloop>
                </tr>
            </thead>
            <tbody>
                <cfset counter = 1>
                <cfoutput query="get_stock_detail">
                    <cfquery name="tree_control" datasource="#dsn3#">
						SELECT COUNT(PRODUCT_TREE_ID) AS CNT FROM PRODUCT_TREE WHERE STOCK_ID = #get_stock_detail.STOCK_ID#
					</cfquery>
                    
                    <cfif tree_control.cnt eq 0>
                        <cfset color_counter = 1>
                        <input type="hidden" name="to_stock_id_#counter#" value="#STOCK_ID#">
                        <tr id="tr_#currentrow#">
                            <td width="10">#counter#</td>
                            <td>#get_stock_detail.stock_code#</td>
                            <td>#get_stock_detail.stock_code_2#</td>
                            <td></td>
                            <td id="td_#color_counter#">
                                <div class="form-group">
                                    <input type="text" name="description_#counter#_#color_counter#" id="description_#color_counter#">
                                </div>
                            </td>
                            <cfloop from="1" to="#listlen(alternative_questions_name)#" index="i">             
                                <td>
                                    <cfif listGetAt(alternative_questions_process,i,',') eq 1 >
                                        <div class="form-group">
                                            <div class="input-group">
                                                <input type="hidden" name="add_stock_id_#counter#_#color_counter#" value="">
                                                <input type="hidden" name="product_id_#counter#_#color_counter#" value="">
                                                <input type="hidden" name="spect_main_name_#counter#_#color_counter#">
                                                <input type="hidden" name="spect_main_id_#counter#_#color_counter#">
                                                <input type="hidden" name="unit_id_#counter#_#color_counter#">
                                                <input type="text" name="product_name_#counter#_#color_counter#">
                                                <span class="input-group-addon icon-ellipsis"  onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_names&stock_and_spect=1&field_spect_main_id=add_variation_product.spect_main_id_#counter#_#color_counter#&field_spect_main_name=add_variation_product.spect_main_name_#counter#_#color_counter#&field_id=add_variation_product.add_stock_id_#counter#_#color_counter#&field_name=add_variation_product.product_name_#counter#_#color_counter#&product_id=add_variation_product.product_id_#counter#_#color_counter#&field_unit=add_variation_product.unit_id_#counter#_#color_counter#')"></span>
                                            </div>
                                        </div>                   
                                    <cfelseif listGetAt(alternative_questions_process,i,',') eq 2 >
                                        <div class="form-group">
                                            
                                            <div class="col col-4 col-xs-12">
                                                <input type="text" name="product_width_#counter#_#color_counter#" placeholder="En">
                                            </div>
                                            <div class="col col-4 col-xs-12">
                                                <input type="text" name="product_length_#counter#_#color_counter#" placeholder="Boy">
                                            </div>
                                            <div class="col col-4 col-xs-12">
                                                <input type="text" name="product_height_#counter#_#color_counter#" placeholder="Yükseklik">
                                            </div>
                                        </div>    
                                    <cfelse>
                                        <div class="form-group">
                                            <div class="input-group">
                                                <input type="hidden" name="property_id_#counter#_#color_counter#">
                                                <input type="text" name="product_property_#counter#_#color_counter#">
                                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=product.popup_product_properties&property_id=add_variation_product.property_id_#counter#_#color_counter#&property=add_variation_product.product_property_#counter#_#color_counter#');"></span>
                                            </div>
                                        </div>
                                    </cfif>
                                    <cfset color_counter++>
                                </td>
                            </cfloop>
                            <cfset counter++>
                        </tr>
                    </cfif>
                </cfoutput>
                <input type="hidden" name="stock_detail_count" value="<cfoutput>#counter-1#</cfoutput>">
            </tbody>
        </cf_grid_list>
        <div class="ui-info-bottom ui-form-list flex-list">
            <div class="form-group">
                <cf_wrk_search_button button_type="2" button_name="#getLang('','Ağaçları Yarat',63525)#" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_variation_product' , #attributes.modal_id#)"),DE(""))#">
            </div>
        </div>
    </cfform>
</cf_box>