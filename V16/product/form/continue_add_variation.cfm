<cfoutput>
<cf_box title="Varyasyon Ekle" dragDrop="1" style="width:930px; height:600px;">
<cfset row_count = 1>
<cfset row_count_2 = 1>
<div id="user_message" style="position:absolute;margin-left:125px;margin-top:-10px;"></div>
<!--- <cfdump var="#attributes#"> --->
<table height="600">
	<tr valign="top">
    	<td>
            <table class="color-border" cellpadding="2" cellspacing="1" border="0">
                <tr class="color-header">
                <td><input type="hidden" name="rel_variation_id_0" id="rel_variation_id_0" value="#attributes.variation_id#">
                </td>
                <td nowrap>#getVarCusTag(row_number:0,input_name:'new_tree_variation_name')#</td>
                <td>
                    <select name="new_tree_var_type_0" id="new_tree_var_type_0" style="width:40px;">
                        <option value="1">Checkbox</option>
                        <option value="0">Radio</option>
                    </select>
                </td>
                <td>
                    <select name="new_tree_var_is_value_1_0" id="new_tree_var_is_value_1_0" style="width:40px;">
                        <option value="1"><cf_get_lang dictionary_id='58564.Var'></option>
                        <option value="0"><cf_get_lang dictionary_id='58546.Yok'></option>
                    </select>
                </td>
                <td>
                    <select name="new_tree_var_is_value_2_0" id="new_tree_var_is_value_2_0"  style="width:40px;">
                        <option value="1"><cf_get_lang dictionary_id='58564.Var'></option>
                        <option value="0"><cf_get_lang dictionary_id='58546.Yok'></option>
                    </select>
                </td>
                <td>
                    <select name="new_tree_var_is_tolerance_0" id="new_tree_var_is_tolerance_0" style="width:50px;">
                        <option value="1"><cf_get_lang dictionary_id='58564.Var'></option>
                        <option value="0"><cf_get_lang dictionary_id='58546.Yok'></option>
                    </select>
                </td>
                <td>
                    <select name="new_tree_var_is_unit_0" id="new_tree_var_is_unit_0" style="width:50px;">
                        <option value="1"><cf_get_lang dictionary_id='58564.Var'></option>
                        <option value="0"><cf_get_lang dictionary_id='58546.Yok'></option>
                    </select>
                </td>
                <td><input name="new_tree_var_property_detail_0" id="new_tree_var_property_detail_0" type="text" style="width:100px;" maxlength="200" value=""></td>
                <td>
                    <select name="new_tree_var_max_amount_0" id="new_tree_var_max_amount_0">
                        <option value="0">0</option>
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                    </select>
                </td>
                <td><textarea name="new_tree_var_product_scrpt_0" id="new_tree_var_product_scrpt_0" style="width:140;height:20;"></textarea></td>
                <td>
                    <input type="button" value="Kaydet" onClick="newAddVar(0)">
                </td>
                </tr>
                <cfscript>
                color1="black";color2="red";color3="brown";
                color4="orange";color5="pink";color6="purple";
                color7="blue";color8="darkblue";color9="gray";
                color10="silver";color11="silver";color12="silver";
                sayac=0;
                deep_level=0;
                function get_subs(conf_variation_id){
                queryStr = 'SELECT CONFIGURATOR_VARIATION_ID FROM SETUP_PRODUCT_CONFIGURATOR_VARIATION WHERE RELATION_CONFIGURATOR_VARIATION_ID=#conf_variation_id#';
                queryResult = cfquery(SQLString : queryStr, Datasource : dsn3);
                variation_id_list =ValueList(queryResult.CONFIGURATOR_VARIATION_ID,',');
                return variation_id_list;
                }
                function getConfTree(conf_variation_id)
                {
                    var i = 1;
                    var sub_variation = get_subs(conf_variation_id);
                    deep_level = deep_level + 1;
                    for (i=1; i lte listlen(sub_variation,','); i = i+1){
                        new_variation_id = ListGetAt(sub_variation,i,',');
                        writeTree(new_variation_id);
                        getConfTree(new_variation_id);
                    }
                    deep_level = deep_level-1;
                }
                getConfTree(attributes.VARIATION_ID);//fonksiyon burada çağırılıyor  	
                </cfscript>
                <cffunction name="writeTree" returntype="any">
                <cfargument default="" name="variation_id" type="numeric">
                <cfquery name="variationQueryResult" datasource="#dsn3#">
                    SELECT * FROM SETUP_PRODUCT_CONFIGURATOR_VARIATION WHERE CONFIGURATOR_VARIATION_ID=#variation_id#
                </cfquery>
                <cfset leftSpace = RepeatString('&nbsp;', deep_level*5)>
                <cfset sayac=sayac+1>
                    <tr id="tree_var_#sayac#" class="color-row">
                        <td>
                            <div style="background:#Evaluate("color#deep_level#")#;position:absolute;width:15;bgcolor:red;margin-left:#(deep_level*15)-15#;color:white;">&nbsp;#deep_level#</div>
                            #leftSpace#<a style="cursor:pointer" onclick="delVar(#variation_id#);"><img  src="images/delete12.gif" border="0" ></a>
                            <input type="hidden" name="tree_configurator_variation_id_#sayac#" id="tree_configurator_variation_id_#sayac#" value="#variation_id#">
                        </td>
                        <td nowrap>#getVarCusTag(row_number:sayac,property_detail_id:variationQueryResult.VARIATION_PROPERTY_DETAIL_ID)#</td>
                        <td>
                            <select name="tree_var_type_#sayac#" id="tree_var_type_#sayac#" style="width:40px;">
                                <option value="1" <cfif variationQueryResult.VARIATION_TYPE eq 1>selected</cfif>>Checkbox</option>
                                <option value="0" <cfif variationQueryResult.VARIATION_TYPE eq 0>selected</cfif>>Radio</option>
                            </select>
                        </td>
                        <td>
                            <select name="tree_var_is_value_1_#sayac#"  id="tree_var_is_value_1_#sayac#"style="width:40px;">
                                <option value="1"<cfif variationQueryResult.VARIATON_IS_VALUE_1 eq 1>selected</cfif>><cf_get_lang dictionary_id='58564.Var'></option>
                                <option value="0"<cfif variationQueryResult.VARIATON_IS_VALUE_1 eq 0>selected</cfif>><cf_get_lang dictionary_id='58546.Yok'></option>
                            </select>
                        </td>
                        <td>
                            <select name="tree_var_is_value_2_#sayac#" id="tree_var_is_value_2_#sayac#" style="width:40px;">
                                <option value="1"<cfif variationQueryResult.VARIATON_IS_VALUE_2 eq 1>selected</cfif>><cf_get_lang dictionary_id='58564.Var'></option>
                                <option value="0"<cfif variationQueryResult.VARIATON_IS_VALUE_2 eq 0>selected</cfif>><cf_get_lang dictionary_id='58546.Yok'></option>
                            </select>
                        </td>
                        <td>
                            <select name="tree_var_is_tolerance_#sayac#" id="tree_var_is_tolerance_#sayac#" style="width:50px;">
                                <option value="1"<cfif variationQueryResult.VARIATON_IS_TOLERANCE eq 1>selected</cfif>><cf_get_lang dictionary_id='58564.Var'></option>
                                <option value="0"<cfif variationQueryResult.VARIATON_IS_TOLERANCE eq 0>selected</cfif>><cf_get_lang dictionary_id='58546.Yok'></option>
                            </select>
                        </td>
                        <td>
                            <select name="tree_var_is_unit_#sayac#" id="tree_var_is_unit_#sayac#"  style="width:50px;">
                                <option value="1"<cfif variationQueryResult.VARIATON_IS_UNIT eq 1>selected</cfif>><cf_get_lang dictionary_id='58564.Var'></option>
                                <option value="0"<cfif variationQueryResult.VARIATON_IS_UNIT eq 0>selected</cfif>><cf_get_lang dictionary_id='58546.Yok'></option>
                            </select>
                        </td>
                        <td><input type="text" name="tree_var_property_detail_#sayac#" id="tree_var_property_detail_#sayac#"   style="width:100px;" maxlength="200" value="#variationQueryResult.VARIATON_PROPERTY_DETAIL#"></td>
                        <td>
                            <select name="tree_var_max_amount_#sayac#" id="tree_var_max_amount_#sayac#">
                                <option value="0"<cfif variationQueryResult.VARIATION_PRODUCTS_AMOUNT eq 0>selected</cfif>>0</option>
                                <option value="1"<cfif variationQueryResult.VARIATION_PRODUCTS_AMOUNT eq 1>selected</cfif>>1</option>
                                <option value="2"<cfif variationQueryResult.VARIATION_PRODUCTS_AMOUNT eq 2>selected</cfif>>2</option>
                                <option value="3"<cfif variationQueryResult.VARIATION_PRODUCTS_AMOUNT eq 3>selected</cfif>>3</option>
                                <option value="4"<cfif variationQueryResult.VARIATION_PRODUCTS_AMOUNT eq 4>selected</cfif>>4</option>
                                <option value="5"<cfif variationQueryResult.VARIATION_PRODUCTS_AMOUNT eq 5>selected</cfif>>5</option>
                            </select>
                       </td>
                       <td><textarea name="tree_var_product_scrpt_#sayac#" id="tree_var_product_scrpt_#sayac#" style="width:140;height:20;">#variationQueryResult.VARIATION_SCRIPT#</textarea></td>
                       <td><input type="button" value="Güncelle" onClick="UpdVar(#sayac#);"><a href="javascript://" onClick="gizle_goster(add_var_rel_#sayac#);"><img  style="cursor:pointer;" src="images/content_plus.gif" border="0" align="top"></a></td>
                    </tr>
                    <tr id="add_var_rel_#sayac#" class="color-list" style="display:none;">
                        <td><input type="hidden" name="rel_variation_id_#sayac#" id="rel_variation_id_#sayac#" value="#variation_id#">
                        </td>
                        <td nowrap>#getVarCusTag(row_number:sayac,input_name:'new_tree_variation_name')#</td>
                        <td>
                            <select name="new_tree_var_type_#sayac#" id="new_tree_var_type_#sayac#" style="width:40px;">
                                <option value="1"><cf_get_lang dictionary_id='58564.Var'></option>
                                <option value="0"><cf_get_lang dictionary_id='58546.Yok'></option>
                            </select>
                        </td>
                        <td>
                            <select name="new_tree_var_is_value_1_#sayac#" id="new_tree_var_is_value_1_#sayac#" style="width:40px;">
                                <option value="1"><cf_get_lang dictionary_id='58564.Var'></option>
                                <option value="0"><cf_get_lang dictionary_id='58546.Yok'></option>
                            </select>
                        </td>
                        <td>
                            <select name="new_tree_var_is_value_2_#sayac#" id="new_tree_var_is_value_2_#sayac#"  style="width:40px;">
                                <option value="1"><cf_get_lang dictionary_id='58564.Var'></option>
                                <option value="0"><cf_get_lang dictionary_id='58546.Yok'></option>
                            </select>
                        </td>
                        <td>
                            <select name="new_tree_var_is_tolerance_#sayac#" id="new_tree_var_is_tolerance_#sayac#" style="width:50px;">
                                <option value="1"><cf_get_lang dictionary_id='58564.Var'></option>
                                <option value="0"><cf_get_lang dictionary_id='58546.Yok'></option>
                            </select>
                        </td>
                        <td>
                            <select name="new_tree_var_is_unit_#sayac#" id="new_tree_var_is_unit_#sayac#"  style="width:50px;">
                                <option value="1"><cf_get_lang dictionary_id='58564.Var'></option>
                                <option value="0"><cf_get_lang dictionary_id='58546.Yok'></option>
                            </select>
                        </td>
                        <td><input name="new_tree_var_property_detail_#sayac#" id="new_tree_var_property_detail_#sayac#" type="text" style="width:100px;" maxlength="200" value=""></td>
                        <td>
                            <select name="new_tree_var_max_amount_#sayac#" id="new_tree_var_max_amount_#sayac#">
                                <option value="0">0</option>
                                <option value="1">1</option>
                                <option value="2">2</option>
                                <option value="3">3</option>
                                <option value="4">4</option>
                                <option value="5">5</option>
                            </select>
                        </td>
                        <td><textarea name="new_tree_var_product_scrpt_#sayac#" id="new_tree_var_product_scrpt_#sayac#" style="width:140;height:20;"></textarea></td>
                        <td>
                            <input type="button" value="Kaydet" onClick="newAddVar(#sayac#)">
                        </td>
                    </tr>
                </cffunction>
                <cffunction name="getVarCusTag" returntype="string">
                <cfargument name="row_number" default="1" type="numeric">
                <cfargument name="input_name" default="tree_variation_name" type="string">
                <cfargument name="property_detail_id" default="" type="string">
                <cfargument name="property_detail" default="" type="string">
                <cfif len(arguments.property_detail_id)>
                <cfquery name="get_variation_names_detail_id" datasource="#dsn1#">
                    SELECT PROPERTY_DETAIL FROM PRODUCT_PROPERTY_DETAIL WHERE PROPERTY_DETAIL_ID = #arguments.property_detail_id#
                </cfquery>
                <cfset arguments.property_detail =get_variation_names_detail_id.PROPERTY_DETAIL>
                </cfif>
                <cfsavecontent variable="varCusTag"><cf_wrk_input boxwidth="200" default_name="#arguments.property_detail#" default_id="#arguments.property_detail_id#" table_name="PRODUCT_PROPERTY_DETAIL" input_name="#arguments.input_name#_#row_number#" width="160" column_name="PROPERTY_DETAIL" column_id="PROPERTY_DETAIL_ID" datasource="#dsn1#"></cfsavecontent>
                <cfreturn varCusTag>
                </cffunction>
            </table>
        </td>
    </tr>
</table>

</cf_box>
<script type="text/javascript">
	function newAddVar(row_number){
		var tree_variation_name = document.getElementById('new_tree_variation_name_'+row_number).value;
		var tree_variation_id = document.getElementById('new_tree_variation_name_'+row_number+'_id').value;
		if(tree_variation_id=="" || tree_variation_name==""){
			alert("<cf_get_lang dictionary_id='58201.Özellik Seçiniz'>..");
			return false;
		}
		var rel_variation_id = document.getElementById('rel_variation_id_'+row_number).value;
		var tree_var_type = document.getElementById('new_tree_var_type_'+row_number).value;
		var tree_var_is_value_1 = document.getElementById('new_tree_var_is_value_1_'+row_number).value;
		var tree_var_is_value_2 = document.getElementById('new_tree_var_is_value_2_'+row_number).value;
		var tree_var_is_tolerance = document.getElementById('new_tree_var_is_tolerance_'+row_number).value;
		var tree_var_is_unit = document.getElementById('new_tree_var_is_unit_'+row_number).value;
		var tree_var_property_detail = document.getElementById('new_tree_var_property_detail_'+row_number).value;
		var tree_var_max_amount = document.getElementById('new_tree_var_max_amount_'+row_number).value;
		var tree_var_product_scrpt = document.getElementById('new_tree_var_product_scrpt_'+row_number).value;
		var new_var_url_str = '';
		new_var_url_str += '&rel_variation_id='+rel_variation_id+'&tree_var_type='+tree_var_type+'&tree_var_is_value_1='+tree_var_is_value_1+'';
		new_var_url_str += '&tree_var_is_value_2='+tree_var_is_value_2+'&tree_var_is_tolerance='+tree_var_is_tolerance+'&tree_var_is_unit='+tree_var_is_unit+'';
		new_var_url_str += '&tree_var_property_detail='+tree_var_property_detail+'&tree_var_max_amount='+tree_var_max_amount+'&tree_var_product_scrpt='+tree_var_product_scrpt+'';
		new_var_url_str += '&tree_variation_name='+tree_variation_name+'&tree_variation_id='+tree_variation_id+'';
		AjaxPageLoad('#request.self#?fuseaction=product.emptypopup_add_variation_query&sub_variation_id=#attributes.VARIATION_ID#'+new_var_url_str+'&productConfId=#attributes.productConfId#&chapter_id=#attributes.chapter_id#&compenent_id=#attributes.compenent_id#','user_message',1);
	}
	function UpdVar(row_number){
		var tree_variation_name = document.getElementById('tree_variation_name_'+row_number).value;
		var tree_variation_id = document.getElementById('tree_variation_name_'+row_number+'_id').value;
		if(tree_variation_id=="" || tree_variation_name==""){
			alert("<cf_get_lang dictionary_id='58201.Özellik Seçiniz'>");
			return false;
		}
		var configurator_variation_id = document.getElementById('tree_configurator_variation_id_'+row_number).value;
		var tree_var_type = document.getElementById('tree_var_type_'+row_number).value;
		var tree_var_is_value_1 = document.getElementById('tree_var_is_value_1_'+row_number).value;
		var tree_var_is_value_2 = document.getElementById('tree_var_is_value_2_'+row_number).value;
		var tree_var_is_tolerance = document.getElementById('tree_var_is_tolerance_'+row_number).value;
		var tree_var_is_unit = document.getElementById('tree_var_is_unit_'+row_number).value;
		var tree_var_property_detail = document.getElementById('tree_var_property_detail_'+row_number).value;
		var tree_var_max_amount = document.getElementById('tree_var_max_amount_'+row_number).value;
		var tree_var_product_scrpt = document.getElementById('tree_var_product_scrpt_'+row_number).value;
		var var_url_str = '';
		var_url_str += '&configurator_variation_id='+configurator_variation_id+'&tree_var_type='+tree_var_type+'&tree_var_is_value_1='+tree_var_is_value_1+'';
		var_url_str += '&tree_var_is_value_2='+tree_var_is_value_2+'&tree_var_is_tolerance='+tree_var_is_tolerance+'&tree_var_is_unit='+tree_var_is_unit+'';
		var_url_str += '&tree_var_property_detail='+tree_var_property_detail+'&tree_var_max_amount='+tree_var_max_amount+'&tree_var_product_scrpt='+tree_var_product_scrpt+'';
		var_url_str += '&tree_variation_name='+tree_variation_name+'&tree_variation_id='+tree_variation_id+'';
		AjaxPageLoad('#request.self#?fuseaction=product.emptypopup_add_variation_query&sub_variation_id=#attributes.VARIATION_ID#'+var_url_str+'&productConfId=#attributes.productConfId#&chapter_id=#attributes.chapter_id#&compenent_id=#attributes.compenent_id#','user_message',1);
	}
	function delVar(del_variation_id){
		AjaxPageLoad('#request.self#?fuseaction=product.emptypopup_add_variation_query&sub_variation_id=#attributes.VARIATION_ID#&del_variation_id='+del_variation_id+'&productConfId=#attributes.productConfId#&chapter_id=#attributes.chapter_id#&compenent_id=#attributes.compenent_id#','user_message',1);
	}
</script>
</cfoutput>

