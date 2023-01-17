<!--- numuneden gelenelr --->
<cfparam name="attributes.q_del_list" default=""> <!--- add_test_parametersda checki kaldırılan testleri silmek için eklendi. --->
<cfquery name="get_prod_id" datasource="#dsn3#">
    SELECT PRODUCT_ID,PRODUCT_CATID FROM #dsn1#.PRODUCT  WHERE P_SAMPLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_sample_id#">
</cfquery>
<cfset upd_current_row_2 = 0>
<cfset upd_rowcount_2 = 0>
<cfset list_row= 0>
<cfif not isDefined("upd_rowcount_")>
    <cfset upd_rowcount = 0>
<cfelse>
    <cfset upd_rowcount_2 = upd_rowcount_ + 1>
</cfif>
<cfif not isDefined("list_row_2")>
    <cfset list_row_2 = 0>
<cfelse>
    <cfset list_row = list_row_2 + 1>
</cfif>
<cfif not isDefined("upd_current_row")>
    <cfset upd_current_row = 0>
<cfelse>
    <cfset upd_current_row_2 = upd_current_row + 1>
</cfif>

<cfset get_q_types_2 = createObject("component","V16.product.cfc.product_quality_control_types").getProductCatQualityTypes(dsn3:dsn3,product_id:get_prod_id.PRODUCT_ID,product_cat_id:get_prod_id.PRODUCT_CATID)>
<cfset parameter_id_list = ''>
<cfset idlist = ''>
<cfset del_main_type_ids=''>  
<cfif get_q_types_2.recordCount>
    <cfloop from="1" to="#listLen(attributes.q_del_list,',')#" index="i">
        <cfoutput>
            <cfset del_main_type = listGetAt(attributes.q_del_list,i)>
            <cfset del_main_type_list = listGetAt(del_main_type,1,";")>
            <cfset del_main_type_ids = listappend(del_main_type_ids,del_main_type_list,",")>
        </cfoutput>
    </cfloop>
    <cfloop query="get_q_types_2">
        <cfif (get_q_types.recordCount neq '' and len(get_q_types.TYPE_ID) and not ListContains(valueList(get_q_types.TYPE_ID),QUALITY_TYPE_ID,',')) or (get_q_types.recordCount eq '') and not listContains(del_main_type_ids,get_q_types_2.QUALITY_TYPE_ID,',')>
            <cfset get_q_sub_types_2 = createObject("component","V16.product.cfc.product_quality_control_types").getProductSubCatQualityTypes(dsn3:dsn3,product_id:get_prod_id.PRODUCT_ID,control_type:get_q_types_2.QUALITY_TYPE_ID)>
            <cfif get_q_sub_types_2.recordcount>
                <div class="ui-info-bottom">
                    <cfif isDefined('content_id') and len(content_id)>
                        <a  target="_blank" href="<cfoutput>#request.self#?fuseaction=content.list_content&event=det&cntid=#get_q_types_2.content_id#</cfoutput>"><i class="fa fa-file-text" style="color:#DAA520" ></i></a>
                    <cfelse>
                        <a href="javascript://"><i class="fa fa-file-text" style="color:#C2B280"></i></a>
                    </cfif>
                    <cfoutput>
                        &nbsp<font color="red">#get_q_types_2.quality_control_type#</font>
                    </cfoutput>
                </div>
                <div class="form-group">
                    <div class="checkbox checbox-switch">
                        <label class="checking">
                            <cfoutput>
                                <input type="checkbox" name="upd_accepted_#currentrow#" id="upd_accepted_#currentrow#" value="1"/>
                            </cfoutput>
                            <span></span>
                        </label>
                    </div>
                </div>
                <cfset list_row = list_row + 1>
                <cf_grid_list id="list_#list_row#">
                    <thead>
                        <tr>
                            <th width="20"><cf_get_lang dictionary_id='57487.No'></th>
                            <th width="150"><cf_get_lang dictionary_id='64052.Parametre'></th>
                            <th width="100" class="text-center"><cf_get_lang dictionary_id='63477.Örneklem'></th>
                            <th width="100"><cf_get_lang dictionary_id='57635.Miktar'></th>
                            <th width="100" class="text-right"><cf_get_lang dictionary_id='52248.Alt Limit'></th>
                            <th width="100" class="text-right"><cf_get_lang dictionary_id='52249.Üst Limit'></th>
                            <th  width="100" class="text-right"><cf_get_lang dictionary_id='33137.Standart'><cf_get_lang dictionary_id='33616.Değer'></th>
                            <th width="25" class="text-center"><=></th>
                            <th><cf_get_lang dictionary_id='59085.Sonuç'></th>
                            <th>&nbsp</th>
                            <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfset upd_rowcount_2 = upd_rowcount_2+ get_q_sub_types_2.recordcount>
                        <cfif get_q_sub_types_2.recordcount>
                            <cfoutput query="get_q_sub_types_2"> 
                                    <cfset idlist= get_q_sub_types_2.QUALITY_CONTROL_TYPE_ID&';'&get_q_sub_types_2.QUALITY_CONTROL_ROW_ID>
                                    <cfset parameter_id_list = listappend(parameter_id_list,idlist,",")>
                                    <cfset get_quality_params = createObject("component","V16.product.cfc.product_quality_control_types").get_quality_id(product_id:get_prod_id.PRODUCT_ID,q_ids:get_q_sub_types_2.QUALITY_CONTROL_ROW_ID)>
                                    <cfset min_limit = get_quality_params.MIN_LIMIT>
                                    <cfset max_limit = get_quality_params.MAX_LIMIT>
                                    <cfset standart_value = get_quality_params.STANDART_VALUE>
                                    <cfset amount= get_quality_params.AMOUNT>
                                    <cfset samp_number= get_quality_params.SAMPLE_NUMBER>
                                    <cfset samp_method= get_quality_params.SAMPLE_METHOD>
                                    <cfset options = get_quality_params.CONTROL_OPERATOR>
                                <cfset upd_current_row_2 = upd_current_row_2 + 1>
                                <cfif (get_q_sub_types.recordCount neq '' and len(get_q_sub_types.PARAMETER_ID) and not ListContains(valueList(get_q_sub_types.PARAMETER_ID),QUALITY_CONTROL_ROW_ID,',')) or (get_q_sub_types.recordCount eq '') and (isDefined("attributes.q_id_list") and not listContains(attributes.q_id_list,idlist,',')) and (not listContains(attributes.q_del_list,idlist,','))>
                                    <tr class="test_rows_">
                                        <td>
                                            <input type="hidden" class="q_row" name="upd_q_row_accept_#upd_current_row_2#" id="upd_q_row_accept_#upd_current_row_2#" value="">
                                            <input type="hidden" name="upd_parameterId#upd_current_row_2#" id="upd_parameterId#upd_current_row_2#" value="#get_q_sub_types_2.QUALITY_CONTROL_ROW_ID#">
                                            <input type="hidden" name="upd_groupId#upd_current_row_2#" id="upd_groupId#upd_current_row_2#" value="#get_q_types_2.QUALITY_TYPE_ID#">
                                            <input type="hidden" name="ref_lab_test_id#upd_current_row_2#" id="ref_lab_test_id#upd_current_row_2#" value="<cfif isDefined('REFINERY_LAB_TEST_ROW_ID')>#REFINERY_LAB_TEST_ROW_ID#</cfif>">
                                            #currentrow#
                                        </td>
                                        <td>#QUALITY_CONTROL_TYPE#</td>
                                        <td>
                                            <div class="form-group">
                                                <div class="col col-8">
                                                    <cfif isDefined('samp_number')><input type="text" name="upd_sample_number_#upd_current_row_2#" id="upd_sample_number_#upd_current_row_2#" value="#TLFormat(samp_number)#" onkeyup="return(FormatCurrency(this,event,4));" class="moneybox"/></cfif>
                                                </div>
                                                <div class="col col-4">
                                                    <cfif isDefined('samp_method')>
                                                        <input type="text" name="upd_samp" id="upd_samp" readonly value="<cfif samp_method eq 1>R<cfelseif samp_method eq 2>%<cfelseif samp_method eq 3>K</cfif>" title="<cfif samp_method eq 1><cf_get_lang dictionary_id='63293.Rastgele'><cfelseif samp_method eq 2><cf_get_lang dictionary_id='52250.Yüzde'><cfelseif samp_method eq 3><cf_get_lang dictionary_id='64043.Katlanarak'></cfif>">
                                                        <input type="hidden" name="upd_sample_method_#upd_current_row_2#" id="upd_sample_method_#upd_current_row_2#" value="#samp_method#">
                                                    </cfif>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="form-group">
                                                <div class="col col-8">
                                                    <input type="text" name="upd_amount_#upd_current_row_2#" id="upd_amount_#upd_current_row_2#" value="#TLFormat(AMOUNT)#" onkeyup="return(FormatCurrency(this,event,4));" class="moneybox"/>
                                                </div>
                                                <div class="col col-4">
                                                    <cfif isDefined('unit')>
                                                        <input type="text" name="upd_units" id="upd_units" readonly value="<cfif unit eq 1>mg<cfelseif unit eq 2>gr <cfelseif unit eq 3>kg <cfelseif unit eq 4>mm³ <cfelseif unit eq 5>cm³ <cfelseif unit eq 6>m³ <cfelseif unit eq 7>ml <cfelseif unit eq 8>cl <cfelseif unit eq 9>lt </cfif>">
                                                        <input type="hidden" name="upd_unit_#upd_current_row_2#" id="upd_unit_#upd_current_row_2#" value="#unit#">
                                                    </cfif>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="text-right"><input type="text" name="upd_minLimit#upd_current_row_2#" id="upd_minLimit#upd_current_row_2#" value="#TLFormat(MIN_LIMIT)#" class="moneybox"/></td>
                                        <td class="text-right"><input type="text" name="upd_maxLimit#upd_current_row_2#" id="upd_maxLimit#upd_current_row_2#" value="#TLFormat(MAX_LIMIT)#" class="moneybox"/></td>
                                        <td class="text-right"><input type="text" name="upd_standart_value_#upd_current_row_2#" id="upd_standart_value_#upd_current_row_2#" value="#TLFormat(STANDART_VALUE)#" class="moneybox"/></td>
                                        <td>
                                            <select name="upd_options#upd_current_row_2#" id="upd_options#upd_current_row_2#" class="text-center"> 
                                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                                <option value="1" <cfif OPTIONS eq 1>selected</cfif>>=</option>
                                                <option value="2" <cfif OPTIONS eq 2>selected</cfif>>></option>
                                                <option value="3" <cfif OPTIONS eq 3>selected</cfif>><</option>
                                                <option value="4" <cfif OPTIONS eq 4>selected</cfif>>=></option>
                                                <option value="5" <cfif OPTIONS eq 5>selected</cfif>>=<</option>
                                            </select>
                                        </td>
                                        <td>
                                            <input type="text" name="upd_result_#upd_current_row_2#" id="upd_result_#upd_current_row_2#" value="" onkeyup="return(FormatCurrency(this,event,4));" class="moneybox">
                                        </td>
                                        <td>
                                            <div class="checkbox checbox-switch">
                                                <label>
                                                    <input type="checkbox" name="upd_accept_#upd_current_row_2#" id="upd_accept_#upd_current_row_2#" value="1"/>
                                                    <span></span>
                                                </label>
                                            </div>
                                        </td>
                                        <td><input type="text" name="upd_type_description_#upd_current_row_2#" id="upd_type_description_#upd_current_row_2#" value=""/></td>
                                    </tr>
                                </cfif>
                            </cfoutput>
                        </cfif>
                    </tbody>
                </cf_grid_list>
                <cfif get_q_sub_types_2.recordcount eq 0>
                    <div class="ui-info-bottom">
                        <p><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</p>
                    </div>
                </cfif>
            </cfif>
        </cfif>
    </cfloop>
</cfif>