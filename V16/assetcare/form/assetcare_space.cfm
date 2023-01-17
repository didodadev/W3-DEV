<cfset get_queries=createObject("component", "V16/assetcare/cfc/assetcare_space")>
<cfset get_assetp_space=get_queries.GET_ASSETP_SPACE()>
<cfparam  name="attributes.assetp_id" default="">
<cfset assetp_id2=0>
<cfsavecontent variable="head"><cf_get_lang dictionary_id="60367.Mekan Tanımları"></cfsavecontent>
<div class="col col-7 col-md-7 col-sm-12 col-xs-12">
    <cf_box title="#head#" uidrop="1" hide_table_column="1">
        <cf_grid_list sort="1">
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id="58585.Kod"></th>
                    <th><cf_get_lang dictionary_id="57631.Ad"></th>
                    <th><cf_get_lang dictionary_id="57629.Açıklama"></th>
                    <th><cf_get_lang dictionary_id="57662.Alan"></th>
                    <th><cf_get_lang dictionary_id="30114.Hacim"></th>
                    <th width="20"><a href="javascript://"><i class="fa fa-pencil"></i></a></th>
                    <th width="20"><a href="javascript://" onclick="add('','','','','','','');"><i class="fa fa-plus"></i></a></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_assetp_space.recordcount>
                    <cfoutput query="get_assetp_space">
                        <cfset volume=SPACE_LENGTH*SPACE_HEIGHT*SPACE_WIDTH>
                        <cfset area=  2*((SPACE_LENGTH*SPACE_HEIGHT)+(SPACE_WIDTH*SPACE_HEIGHT)+(SPACE_LENGTH*SPACE_WIDTH))>
                        <tr>
                            <td>#SPACE_CODE#</td>
                            <td>#SPACE_NAME#</td>
                            <td>#SPACE_DETAIL#</td>
                            <td class="text-right">#round(area)#</td>
                            <td class="text-right">#round(volume)#</td>
                            <td width="20"><a href="javascript://" onclick="update(#ASSET_P_SPACE_ID#,'#SPACE_CODE#','#SPACE_NAME#','#SPACE_DETAIL#','#SPACE_LENGTH#','#SPACE_HEIGHT#','#SPACE_WIDTH#',#SPACE_MEASURE#,'#IS_HORECA#');"><i class="fa fa-pencil"></i></a></td>
                            <td width="20"><a href="javascript://" onclick="add('#SPACE_CODE#','#SPACE_NAME#','#SPACE_DETAIL#','#SPACE_LENGTH#','#SPACE_HEIGHT#','#SPACE_WIDTH#',#SPACE_MEASURE#,'#IS_HORECA#');"><i class="fa fa-plus"></i></a></td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="8"><cf_get_lang dictionary_id="57484.Kayıt Yok">!</td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
    </cf_box>
</div>
<cfsavecontent variable="head"><cf_get_lang dictionary_id="57771.Detay"></cfsavecontent>
<div class="col col-5 col-md-5 col-sm-12 col-xs-12 upd hide">
    <cf_box title="#head#">
        <cfform id="assetp_space_upd" name="assetp_space_upd" action="V16/assetcare/cfc/assetcare_space.cfc?method=upd_assetp_space" method="post">
            <input type="hidden" name= "assetp_id" id="assetp_id" value=""> 
            <cf_box_elements vertical="1">
                <div class=" col col-9 col-md-9 col-sm-9 col-xs-12">
                    <div class="form-group">
                        <label><cf_get_lang dictionary_id="58585.Kod">*</label>
                        <input  name="assetp_code" id="assetp_code" type="text" value="" required>
                    </div>
                    <div class="form-group">
                        <label><cf_get_lang dictionary_id="57631.Ad"></label>
                        <div class="input-group">
                            <input name="assetp_name" id="assetp_name" type="text" value="" required>
                            <span class="input-group-addon">
                                <cf_language_info
                                table_name="ASSET_P_SPACE" 
                                column_name="SPACE_NAME" 
                                column_id_value="#get_assetp_space.SPACE_NAME#" 
                                maxlength="500" 
                                datasource="#dsn#" 
                                column_id="ASSET_P_SPACE_ID" 
                                control_type="0"
                                class="change_lang">
                            </span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label><cf_get_lang dictionary_id="57713.Boyut"></label>
                        <div class="col col-3 col-md-3 col-sm-3 col-xs-3 pl-0">
                            <label><cf_get_lang dictionary_id="39470.En"></label>
                            <input name="assetp_width" id="assetp_width" type="text" value="">
                        </div>
                        <div class="col col-3 col-md-3 col-sm-3 col-xs-3 pl-0">
                            <label><cf_get_lang dictionary_id="99.Boy"></label>
                            <input name="assetp_length" id="assetp_length" id="" type="text" value="">
                        </div>
                        <div class="col col-3 col-md-3 col-sm-3 col-xs-3 pl-0">
                            <label><cf_get_lang dictionary_id="57696.Yükseklik"></label>
                            <input name="assetp_height" id="assetp_height" type="text" value="">
                        </div>
                        <div class="col col-3 col-md-3 col-sm-3 col-xs-3 pl-0">
                            <label><cf_get_lang dictionary_id="32073.Birim"></label>
                            <select name="assetp_unit" id="assetp_unit">
                                <option value="1"><cf_get_lang dictionary_id="60387.Metre"></option>
                                <option value="2"><cf_get_lang dictionary_id="60388.Foot"></option>
                                <option value="3"><cf_get_lang dictionary_id="60389.Yard"></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label><cf_get_lang dictionary_id="57629.Açıklama"></label>
                        <div class="input-group">
                            <input name="assetp_detail" id="assetp_detail" type="text" value="" required>
                            <span class="input-group-addon">
                                <cf_language_info
                                    table_name="ASSET_P_SPACE" 
                                    column_name="SPACE_DETAIL" 
                                    column_id_value="#get_assetp_space.SPACE_DETAIL#" 
                                    maxlength="500" 
                                    datasource="#dsn#" 
                                    column_id="ASSET_P_SPACE_ID" 
                                    control_type="0"
                                    class="change_lang_det">
                            </span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-4"><cf_get_lang dictionary_id="65387.Horeka Mekan"></label>
                            <div class="col col-8">
                                <select id="is_horeca" name="is_horeca">
                                <option value="0"><cf_get_lang dictionary_id="57496.Hayır"></option>
                                <option value="1"><cf_get_lang dictionary_id="57495.Evet"></option>
                                </select>
                          </div>
                    </div>
                </div>
            </cf_box_elements>
            <div class="ui-form-list-btn">
                <div class="col col-6">
                    <cf_record_info query_name="get_assetp_space">
                </div>
                <div class="col col-6">
                    <cf_workcube_buttons is_upd='1' is_delete="0">
                </div>
            </div>
        </cfform>
        <!---<cf_workcube_buttons is_upd='1' delete_page_url='V16/assetcare/cfc/assetcare_space.cfc?method=del_assetp_space&assetp_id=#assetp_id#'>--->
    </cf_box>
</div>
<div class="col col-5 col-md-5 col-sm-12 col-xs-12 add">
    <cf_box title="#head#">
        <cfform id="assetp_space_add" name="assetp_space_add" action="V16/assetcare/cfc/assetcare_space.cfc?method=add_assetp_space" method="post">
            <input type="hidden" name= "assetp_id_" id="assetp_id_" value=""> 
            <cf_box_elements vertical="1">
                <div class=" col col-9 col-md-9 col-sm-9 col-xs-12">
                    <div class="form-group">
                        <label><cf_get_lang dictionary_id="58585.Kod"></label>
                        <input  name="assetp_code_" id="assetp_code_" type="text" value="">
                    </div>
                    <div class="form-group">
                        <label><cf_get_lang dictionary_id="57631.Ad"></label>
                        <input name="assetp_name_" id="assetp_name_" type="text" value="">
                    </div>
                    <div class="form-group">
                        <label><cf_get_lang dictionary_id="57713.Boyut"></label>
                        <div class="col col-3 col-md-3 col-sm-3 col-xs-3 pl-0">
                            <label><cf_get_lang dictionary_id="39470.En"></label>
                            <input name="assetp_width_" id="assetp_width_" type="text" value="">
                        </div>
                        <div class="col col-3 col-md-3 col-sm-3 col-xs-3 pl-0">
                            <label><cf_get_lang dictionary_id="99.Boy"></label>
                            <input name="assetp_length_" id="assetp_length_" id="" type="text" value="">
                        </div>
                        <div class="col col-3 col-md-3 col-sm-3 col-xs-3 pl-0">
                            <label><cf_get_lang dictionary_id="57696.Yükseklik"></label>
                            <input name="assetp_height_" id="assetp_height_" type="text" value="">
                        </div>
                        <div class="col col-3 col-md-3 col-sm-3 col-xs-3 pl-0">
                            <label>Birim</label>
                            <select name="assetp_unit_" id="assetp_unit_">
                                <option value="1">Metre</option>
                                <option value="2">Foot</option>
                                <option value="3">Yard</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label><cf_get_lang dictionary_id="57629.Açıklama"></label>
                        <textarea id="assetp_detail_" name="assetp_detail_"></textarea>
                    </div>
                    <div class="form-group">
                        <label class="col col-4"><cf_get_lang dictionary_id="65387.Horeka Mekan"></label>
                            <div class="col col-8">
                                <select id="is_horeca" name="is_horeca">
                                <option value="0"><cf_get_lang dictionary_id="57496.Hayır"></option>
                                <option value="1"><cf_get_lang dictionary_id="57495.Evet"></option>
                                </select>
                          </div>
                    </div>
                </div>
            </cf_box_elements>
            <div class="ui-form-list-btn">
                <cf_workcube_buttons add_function="code_control()">
            </div>
        </cfform>
       
    </cf_box>
</div>
<script>
   function add(code,name,detail,length,height,width,unit,is_horeca){
        document.getElementById("assetp_code_").value = code;
        document.getElementById("assetp_name_").value = name;
        document.getElementById("assetp_detail_").value = detail;
        document.getElementById("assetp_length_").value = length;
        document.getElementById("assetp_height_").value = height;
        document.getElementById("assetp_width_").value = width;
        document.getElementById("assetp_unit_").value = unit;
        if(is_horeca == 1){
            $("#assetp_space_add #is_horeca option[value=1]").attr('selected','selected');
            $("#assetp_space_add #is_horeca option[value=0]").removeAttr('selected');
            }
        else{
            $("#assetp_space_add #is_horeca option[value=0]").attr('selected','selected');
            $("#assetp_space_add #is_horeca option[value=1]").removeAttr('selected');
        }
        $('.upd').addClass('hide');
        $('.add').removeClass('hide');
        
    }
    function update(id,code,name,detail,length,height,width,unit,is_horeca){
        document.getElementById("assetp_id").value = id;
        document.getElementById("assetp_code").value = code;
        document.getElementById("assetp_name").value = name;
        document.getElementById("assetp_detail").value = detail;
        document.getElementById("assetp_length").value = length;
        document.getElementById("assetp_height").value = height;
        document.getElementById("assetp_width").value = width;
        document.getElementById("assetp_unit").value = unit;
        if(is_horeca == 1){
            $("#assetp_space_upd #is_horeca option[value=1]").attr('selected','selected');
            $("#assetp_space_upd #is_horeca option[value=0]").removeAttr('selected');
        }
        else{
            $("#assetp_space_upd #is_horeca option[value=0]").attr('selected','selected');
            $("#assetp_space_upd #is_horeca option[value=1]").removeAttr('selected');
        }
        $(".change_lang").attr("onclick","openBoxDraggable('index.cfm?fuseaction=objects.popup_ajax_list_language_info&t_name=ASSET_P_SPACE&c_name=SPACE_NAME&c_id_value="+id+"&c_id=ASSET_P_SPACE_ID&d_alias=<cfoutput>#dsn#</cfoutput>&maxlength=500&c_type=0&input_type=text');");
        $(".change_lang_det").attr("onclick","openBoxDraggable('index.cfm?fuseaction=objects.popup_ajax_list_language_info&t_name=ASSET_P_SPACE&c_name=SPACE_DETAIL&c_id_value="+id+"&c_id=ASSET_P_SPACE_ID&d_alias=<cfoutput>#dsn#</cfoutput>&maxlength=500&c_type=0&input_type=text');");

        $('.add').addClass('hide');
        $('.upd').removeClass('hide');

    }
    var codes = [];
    function code_control(){

        codes = [<cfloop query="get_assetp_space"><cfoutput>"#SPACE_CODE#"</cfoutput>,</cfloop>];
     
        var x=document.getElementById("assetp_code_").value;
        
        if(codes.indexOf(x) != -1){
            alert("Var olan bir kod kaydetmeye çalıştınız. Lütfen farklı bir kod değeri giriniz.!");
            return false;
        } 
        
    }
</script>
