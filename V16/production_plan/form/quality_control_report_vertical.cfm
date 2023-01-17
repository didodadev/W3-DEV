<cfif not isDefined("attributes.control_amount")><cfset attributes.control_amount = ""></cfif>
<cfif not isDefined("attributes.success_id")><cfset attributes.success_id = ""></cfif>
<cfif isDefined("attributes.or_q_id") and Len(attributes.or_q_id)>
	<cfset attributes.controller_emp_id = get_quality_result.controller_emp_id>
	<cfset attributes.controller_emp = get_emp_info(get_quality_result.controller_emp_id,0,0)>
	<cfset attributes.control_amount = get_quality_result.control_amount>
	<cfset attributes.success_id = get_quality_result.success_id>
	<cf_seperator title="#getLang("","",37444)#" id="quality_control_parameters">
        <div class="col col-12" id="quality_control_parameters">
            <cf_box_elements>
                <cfoutput query="GET_QUALITY_TYPE">
                            <div class="form-group col col-12 col-sm-12 col-xs-12" id="item-table">
                                <cfset _TYPE_ID_ = GET_QUALITY_TYPE.TYPE_ID>
                                <cfquery name="GET_QUALITY_TYPE_ROW" datasource="#dsn3#">
                                    SELECT 
                                        CCR.QUALITY_CONTROL_ROW,
                                        CCR.TOLERANCE,
                                        CCR.TOLERANCE_2,
                                        CCR.QUALITY_CONTROL_ROW_ID,
                                        CCR.QUALITY_ROW_DESCRIPTION,
                                        CCR.QUALITY_VALUE
                                    FROM
                                        QUALITY_CONTROL_ROW CCR
                                    WHERE 
                                        QUALITY_CONTROL_TYPE_ID = #_TYPE_ID_#
                                </cfquery>
                                <cfquery name="GET_QUALITY_RESULT_ROWS" datasource="#dsn3#">
                                    SELECT * FROM ORDER_RESULT_QUALITY_ROW WHERE OR_Q_ID = #attributes.OR_Q_ID# AND CONTROL_TYPE_ID = #_TYPE_ID_#
                                </cfquery>
                                <label class="col col-1 bold">#QUALITY_CONTROL_TYPE#</label>
                                <div class="col col-1">
                                    <cfloop query="GET_QUALITY_TYPE_ROW">
                                            <label><input type="radio" name="QUALITY_CONTROL_ROW_ID_#_TYPE_ID_#" id="QUALITY_CONTROL_ROW_ID_#_TYPE_ID_#" <cfif GET_QUALITY_RESULT_ROWS.recordcount and GET_QUALITY_RESULT_ROWS.CONTROL_ROW_ID eq GET_QUALITY_TYPE_ROW.QUALITY_CONTROL_ROW_ID>checked</cfif> value="#QUALITY_CONTROL_ROW_ID#">#QUALITY_CONTROL_ROW#</label>
                                    </cfloop>
                                </div>
                            </div>
                        <cfif len(GET_QUALITY_TYPE.DEFAULT_VALUE)>
                            <cfset QUALITY_VALUE = GET_QUALITY_TYPE.DEFAULT_VALUE>
                        <cfelseif len(GET_QUALITY_TYPE_ROW.QUALITY_VALUE)>
                            <cfset QUALITY_VALUE = GET_QUALITY_TYPE_ROW.QUALITY_VALUE>
                        <cfelse>
                            <cfset QUALITY_VALUE = 0>
                        </cfif>
                            <cfif xml_show_quality_value eq 1>
                                <div class="form-group col col-3 col-sm-6 col-xs-12" id="item-quality_value">
                                    <label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='36493.Değer'></label>
                                    <div class="col col-7 col-xs-12">
                                        <input type="text" name="quality_value_#_TYPE_ID_#" id="quality_value_#_TYPE_ID_#" value="#quality_value#" style="width:65px;text-align:right;" readonly>
                                    </div>
                                </div>  
                            </cfif>
                            <cfif xml_show_detail eq 1>
                                <div class="form-group col col-3 col-sm-6 col-xs-12" id="item-detail">
                                    <label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                                    <div class="col col-7 col-xs-12">
                                        <input type="text" name="detail_#_TYPE_ID_#" id="detail_#_TYPE_ID_#" value="<cfif GET_QUALITY_RESULT_ROWS.recordcount>#GET_QUALITY_RESULT_ROWS.QUALITY_DETAIL#</cfif>" style="width:65px;" maxlength="500">
                                    </div>
                                </div>
                            </cfif>
                            <cfif xml_show_tolerance>
                                <div class="form-group col col-3 col-sm-6 col-xs-12" id="item-tolerance">
                                    <label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='29443.Tolerans'> (+)</label>
                                    <div class="col col-7 col-xs-12">
                                        <input type="text" name="tolerance_#_TYPE_ID_#" id="tolerance_#_TYPE_ID_#" value="<cfif len(GET_QUALITY_TYPE.TOLERANCE)>#GET_QUALITY_TYPE.TOLERANCE#<cfelse>#GET_QUALITY_TYPE_ROW.TOLERANCE#</cfif>" style="text-align:right;" readonly>
                                    </div>
                                </div>
                            </cfif>
                            <cfif xml_show_result eq 1>
                                <div class="form-group col col-3 col-sm-6 col-xs-12" id="item-quality_rule">
                                    <cfif len(GET_QUALITY_TYPE.TOLERANCE)>
                                        <cfset tolerans_dgr = GET_QUALITY_TYPE.TOLERANCE>
                                    <cfelseif len(GET_QUALITY_TYPE_ROW.TOLERANCE)>
                                        <cfset tolerans_dgr = GET_QUALITY_TYPE_ROW.TOLERANCE>
                                    <cfelse>
                                        <cfset tolerans_dgr = 0>
                                    </cfif>
                                    <cfif len(GET_QUALITY_TYPE.TOLERANCE_2)>
                                        <cfset tolerans_dgr2 = GET_QUALITY_TYPE.TOLERANCE_2>
                                    <cfelseif len(GET_QUALITY_TYPE_ROW.TOLERANCE_2)>
                                        <cfset tolerans_dgr2 = GET_QUALITY_TYPE_ROW.TOLERANCE_2>
                                    <cfelse>
                                        <cfset tolerans_dgr2 = 0>
                                    </cfif> 
                                    <cfset rule_ = 0>
                                    <cfif len(GET_QUALITY_TYPE.quality_rule)>
                                        <cfset rule_ = GET_QUALITY_TYPE.quality_rule>
                                    </cfif> 
                                    <label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='57684.Sonuç'> #QUALITY_VALUE-tolerans_dgr2#-#QUALITY_VALUE+tolerans_dgr#</label>
                                    <div class="col col-7 col-xs-12"><input type="hidden" name="quality_rule_#_TYPE_ID_#" id="quality_rule_#_TYPE_ID_#" value= "#rule_#">
                                        <input type="text" name="result_#_TYPE_ID_#" id="result_#_TYPE_ID_#" value="<cfif GET_QUALITY_RESULT_ROWS.recordcount><cfif rule_ eq 0 and isDefined("GET_QUALITY_RESULT_ROWS.CONTROL_RESULT")>#tlformat(GET_QUALITY_RESULT_ROWS.CONTROL_RESULT,4)# <cfelseif rule_ eq 2 and isDefined("GET_QUALITY_RESULT_ROWS.CONTROL_RESULT_TEXT")>#GET_QUALITY_RESULT_ROWS.CONTROL_RESULT_TEXT#<cfelseif rule_ eq 1 and isDefined("GET_QUALITY_RESULT_ROWS.CONTROL_RESULT_DATE")>#dateformat(GET_QUALITY_RESULT_ROWS.CONTROL_RESULT_DATE,dateformat_style)#</cfif></cfif>"  style="width:65px;text-align:right;">
                                    </div>
                                </div>
                            </cfif>
                            <cfif xml_show_brand eq 1>
                                <div class="form-group col col-3 col-sm-6 col-xs-12" id="item-brand">
                                    <label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='58847.Marka'></label>
                                    <div class="col col-7 col-xs-12">
                                        <cfinput type="text" name="brand_#_TYPE_ID_#" id="brand_#_TYPE_ID_#" value="#GET_QUALITY_RESULT_ROWS.brand#" maxlength="100" style="width:65px;text-align:right;">
                                    </div>
                                </div>
                            </cfif> 
                            <cfif xml_show_model eq 1>	
                                <div class="form-group col col-3 col-sm-6 col-xs-12" id="item-MODEL_ID">
                                    <label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='58225.Model'></label>
                                    <div class="col col-7 col-xs-12">
                                        <cfinput type="text" name="model_#_TYPE_ID_#" id="model_#_TYPE_ID_#" value="#GET_QUALITY_RESULT_ROWS.model#" maxlength="100" style="width:65px;text-align:right;">
                                    </div>
                                </div>
                            </cfif>
                            <cfif xml_show_tolerance>
                                <div class="form-group col col-3 col-sm-6 col-xs-12" id="item-tolerance2">
                                    <label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='29443.Tolerans'> (-)</label>
                                    <div class="col col-7 col-xs-12">
                                        <input type="text" name="tolerance2_#_TYPE_ID_#" id="tolerance2_#_TYPE_ID_#" value="<cfif len(GET_QUALITY_TYPE.TOLERANCE_2)>#GET_QUALITY_TYPE.TOLERANCE_2#<cfelse>#GET_QUALITY_TYPE_ROW.TOLERANCE_2#</cfif>" style="width:65px;text-align:right;" readonly>
                                    </div>
                                </div>
                            </cfif>
                           
                </cfoutput>
            </cf_box_elements>
	</div>
<cfelse>
	<cf_seperator title="#getLang("","",37444)#" id="quality_control_parameters">
        <div class="col col-12" id="quality_control_parameters">
            <cf_box_elements>
                <cfoutput query="get_quality_type">        
                    <div class="form-group col col-12 col-sm-12 col-xs-12" id="item-table">
                        <cfset _TYPE_ID_ = get_quality_type.type_id>
                        <cfquery name="get_quality_type_row" datasource="#dsn3#">
                            SELECT QUALITY_CONTROL_ROW, TOLERANCE, TOLERANCE_2, QUALITY_CONTROL_ROW_ID, QUALITY_ROW_DESCRIPTION, QUALITY_VALUE FROM QUALITY_CONTROL_ROW WHERE QUALITY_CONTROL_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#_TYPE_ID_#">
                        </cfquery>
                        <label class="bold col col-1">#QUALITY_CONTROL_TYPE#</label>
                        <div class="col col-1">
                            <cfloop query="get_quality_type_row">
                                    <label class="col col-12"><input type="radio" name="quality_control_row_id_#_TYPE_ID_#" id="quality_control_row_id_#_TYPE_ID_#" checked value="#quality_control_row_id#">#QUALITY_CONTROL_ROW#</label>
                            </cfloop>
                        </div>
                    </div>
                    <cfif xml_show_quality_value eq 1>
                        <div class="form-group  col col-3 col-sm-6 col-xs-12" id="item-quality_value">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36493.Değer'></label>
                            <div class="col col-7 col-xs-12"><input type="text" name="quality_value_#_TYPE_ID_#" id="quality_value_#_TYPE_ID_#" value="<cfif len(GET_QUALITY_TYPE.DEFAULT_VALUE)>#GET_QUALITY_TYPE.DEFAULT_VALUE#<cfelse>#GET_QUALITY_TYPE_ROW.QUALITY_VALUE#</cfif>" style="width:75px;text-align:right;" readonly></div>
                        </div>
                    </cfif>
                    <cfif xml_show_detail eq 1>
                        <div class="form-group col col-3 col-sm-6 col-xs-12" id="item-detail">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-7 col-xs-12"><input type="text" name="detail_#_TYPE_ID_#" id="detail_#_TYPE_ID_#" value="" style="width:75px;text-align:right;" maxlength="500"></div>
                        </div>
                    </cfif>
                    <cfif xml_show_tolerance>
                        <div class="form-group  col col-3 col-sm-6 col-xs-12" id="item-tolerance">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29443.Tolerans'> (+)</label>
                            <div class="col col-7 col-xs-12"><input type="text" name="tolerance_#_TYPE_ID_#" id="tolerance_#_TYPE_ID_#" value="<cfif len(GET_QUALITY_TYPE.TOLERANCE)>#GET_QUALITY_TYPE.TOLERANCE#<cfelse>#GET_QUALITY_TYPE_ROW.TOLERANCE#</cfif>" style="width:75px;text-align:right;" readonly></div>
                        </div>
                    </cfif>
                    <cfif xml_show_result eq 1>
                        <div class="form-group col col-3 col-sm-6 col-xs-12" id="item-quality_rule">
                            <cfif len(GET_QUALITY_TYPE.DEFAULT_VALUE)>
                                <cfset QUALITY_VALUE = GET_QUALITY_TYPE.DEFAULT_VALUE>
                            <cfelseif len(GET_QUALITY_TYPE_ROW.QUALITY_VALUE)>
                                <cfset QUALITY_VALUE = GET_QUALITY_TYPE_ROW.QUALITY_VALUE>
                            <cfelse>
                                <cfset QUALITY_VALUE = 0>
                            </cfif>
                            <cfif len(GET_QUALITY_TYPE.TOLERANCE)>
                                <cfset tolerans_dgr = GET_QUALITY_TYPE.TOLERANCE>
                            <cfelseif len(GET_QUALITY_TYPE_ROW.TOLERANCE)>
                                <cfset tolerans_dgr = GET_QUALITY_TYPE_ROW.TOLERANCE>
                            <cfelse>
                                <cfset tolerans_dgr = 0>
                            </cfif>
                            <cfif len(GET_QUALITY_TYPE.TOLERANCE_2)>
                                <cfset tolerans_dgr2 = GET_QUALITY_TYPE.TOLERANCE_2>
                            <cfelseif len(GET_QUALITY_TYPE_ROW.TOLERANCE_2)>
                                <cfset tolerans_dgr2 = GET_QUALITY_TYPE_ROW.TOLERANCE_2>
                            <cfelse>
                                <cfset tolerans_dgr2= 0>
                            </cfif>
                            <cfset rule_ = 0>
                            <cfif len(GET_QUALITY_TYPE.quality_rule)>
                                <cfset rule_ = GET_QUALITY_TYPE.quality_rule>
                            </cfif> 
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57684.Sonuc'> #QUALITY_VALUE-tolerans_dgr2#-#QUALITY_VALUE+tolerans_dgr#</label>
                            <div class="col col-7 col-xs-12">
                                <input type="hidden" name="quality_rule_#_TYPE_ID_#" id="quality_rule_#_TYPE_ID_#" value= "#rule_#">
                                <input type="text" name="result_#_TYPE_ID_#" id="result_#_TYPE_ID_#" value="" style="width:75px;text-align:right;" <cfif rule_ eq 0>onKeyup="return(FormatCurrency(this,event,4));"</cfif>>
                            </div>
                        </div>
                    </cfif>
                    <cfif xml_show_brand eq 1>
                        <div class="form-group col col-3 col-sm-6 col-xs-12" id="item-brand">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58847.Marka'></label>
                            <div class="col col-7 col-xs-12">
                                <cf_wrkProductBrand
                                    width="75"
                                    fieldName="brand_#currentrow#"
                                    fieldId="brand_id_#currentrow#"
                                    returnInputValue="brand_id_#currentrow#,brand_#currentrow#"
                                    compenent_name="getProductBrand"               
                                    boxwidth="240"
                                    boxheight="150">
                            </div>
                        </div>
                    </cfif>
                    <cfif xml_show_model eq 1>
                        <div class="form-group col col-3 col-sm-6 col-xs-12" id="item-MODEL_ID">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58225.Model'></label>
                            <div class="col col-7 col-xs-12">
                                <cf_wrkProductModel
                                    returnInputValue="model_id_#currentrow#,model_#currentrow#,model_code_#currentrow#"
                                    returnQueryValue="MODEL_ID,MODEL_NAME"
                                    width="75"
                                    fieldId="model_id_#currentrow#"
                                    fieldName="model_#currentrow#"
                                    fieldcode="model_code_#currentrow#"
                                    compenent_name="getProductModel"            
                                    boxwidth="240"
                                    boxheight="150">
                            </div>
                        </div>
                    </cfif>
                    <cfif xml_show_tolerance>
                        <div class="form-group  col col-3 col-sm-6 col-xs-12" id="item-tolerance2">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29443.Tolerans'> (-)</label>
                            <div class="col col-7 col-xs-12"><input type="text" name="tolerance2_#_TYPE_ID_#" id="tolerance2_#_TYPE_ID_#" value="<cfif len(GET_QUALITY_TYPE.TOLERANCE_2)>#GET_QUALITY_TYPE.TOLERANCE_2#<cfelse>#GET_QUALITY_TYPE_ROW.TOLERANCE_2#</cfif>" style="width:75px;text-align:right;" readonly></div>
                        </div>
                    </cfif>
                </cfoutput>
            </cf_box_elements>
        </div>
    </cfif>
<cfset get_queries = createObject("component","V16.production_plan.cfc.get_succes_name")>
<cfset get_quality_success =get_queries.get_succes_name()>
<cf_seperator title="#getLang("","",62321)#" id="check_all_amount">
    <div class="col col-12" id="check_all_amount">
        <cf_box_elements vertical="1">
            <div class="col col-3">
                <div class="form-group" id="item-controller_emp_id">
                    <label><cf_get_lang dictionary_id='57032.Kontrol Eden'></label>
                    <div class="input-group">
                        <cfoutput>
                        <div class="input-group">
                            <input type="hidden" name="quality_type_list" id="quality_type_list" value="#ValueList(get_quality_type.type_id,',')#">
                            <input type="hidden" name="controller_emp_id_" id="controller_emp_id_" value="#attributes.controller_emp_id#">			
                            <input type="text" name="controller_emp_" id="controller_emp_" value="#attributes.controller_emp#" onFocus="AutoComplete_Create('controller_emp_','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','controller_emp_id_','','3','130');" autocomplete="off" style="width:150px;">
                            <cfif isDefined("attributes.or_q_id") and Len(attributes.or_q_id)>

                            <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_emps&field_id=upd_quality.controller_emp_id_&field_name=upd_quality.controller_emp_&select_list=1','list');"></span>
                            <cfelse>
                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_emps&field_id=add_quality.controller_emp_id_&field_name=add_quality.controller_emp_&select_list=1','list');"></span>
                            </cfif>
                        </div>
                        </cfoutput>
                    </div>
                </div>
            </div>
            <div class="col col-3">
                <div class="form-group" id="item-control_amount">
                    <label><cf_get_lang dictionary_id='36657.Kontrol Edilen Miktar'></label>
                    <div class="input-group">
                        <cfinput type="text" name="control_amount" class="moneybox" onKeyup="return(FormatCurrency(this,event,4));" value="#tlformat(attributes.control_amount,4)#">
                    </div>
                </div>
            </div>
            <div class="col col-3">
                <div class="form-group small" id="item-success_id">
                    <label><cf_get_lang dictionary_id='36335.Kalite'></label>
                    <div class="input-group">
                        <select name="success_id" id="success_id">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfoutput query="get_quality_success">
                                <option value="#success_id#" <cfif get_quality_success.success_id eq attributes.success_id>selected</cfif>>#success#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
            </div>
        </cf_box_elements>
	 </div>

