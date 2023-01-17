
<cf_box_elements>
        <input type="hidden" name="welding_id" id="welding_id" value="1">
        <input type="hidden" name="basket_add_parameters" id="basket_add_parameters" value="<cfif isdefined("attributes.basket_add_parameters")><cfoutput>#attributes.basket_add_parameters#</cfoutput></cfif>">
        <input type="hidden" name="url_str_" id="url_str_" value="<cfif isdefined("attributes.url_str_")><cfoutput>#attributes.url_str_#</cfoutput></cfif>">
    <cfif get_conf.ORIGIN eq 3 and len(get_conf.USE_FORM) and get_conf.USE_FORM eq 1 and isdefined("attributes.stock_id")>
        <cfinclude template="../query/product_cats.cfm">
        <cfquery name="CATEGORY" dbtype="query">
            SELECT 
                * 
            FROM 
                PRODUCT_CATS 
        <cfif len(get_conf.USE_CAT_IDS)> WHERE 
                PRODUCT_CATID IN (#get_conf.USE_CAT_IDS#)
                </cfif>
        </cfquery>
    	<cfquery name="get_control_type" datasource="#dsn3#">
            SELECT 
                TYPE_ID, 
                IS_ACTIVE, 
                QUALITY_CONTROL_TYPE, 
                TYPE_DESCRIPTION, 
                STANDART_VALUE, 
                TOLERANCE, 
                QUALITY_MEASURE, 
                TOLERANCE_2, 
                PROCESS_CAT_ID, 
                RECORD_DATE, 
                RECORD_EMP, 
                RECORD_IP, 
                UPDATE_DATE, 
                UPDATE_EMP, 
                UPDATE_IP ,
                CONTENT_ID,
                STOCK_MATERIAL ,
                PROCESS,
                MACHINE_EQUIPMENT,
                SPECIFIC_WEIGHT,
                CODE
            FROM 
                QUALITY_CONTROL_TYPE 
                <cfif len(get_conf.USE_QUALITY_IDS)>
            WHERE 
                TYPE_ID IN (#get_conf.USE_QUALITY_IDS#)
                </cfif>
        </cfquery>
        <cf_seperator id="conf_product" header="#getLang(dictionary_id: 65099)#" closeForGrid="1">
        <div class="row">
            <div class="col col-12" id="conf_product">
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="col col-2 col-md-2 col-xs-12">
                        <label><cf_get_lang dictionary_id="57486.Kategori"></label>
                        <div class="form-group">
                            <select id="cat" name="cat" onclick="calculate_volume()">
                                <option value = "||"><cf_get_lang dictionary_id="57734.seçiniz"></option>
                                <cfoutput query="CATEGORY">
                                    <option value = "#PRODUCT_CATID#|#HIERARCHY#|#FORM_FACTOR#" <cfif isdefined("GET_SPECT.PRODUCT_CAT") and GET_SPECT.PRODUCT_CAT eq PRODUCT_CATID>selected</cfif>>#PRODUCT_CAT#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="col col-2 col-md-2 col-xs-12">
                        <label><cf_get_lang dictionary_id="59157.Kalite"></label>
                        <div class="form-group">
                            <select name="quality" id="quality" onclick="calculate_volume()">
                                <option value = "||"><cf_get_lang dictionary_id="57734.seçiniz"></option>
                                <cfoutput query="get_control_type">
                                    <option value = "#TYPE_ID#|#TLformat(SPECIFIC_WEIGHT)#|#CODE#" <cfif isdefined("GET_SPECT.QUALITY_ID") and GET_SPECT.QUALITY_ID eq TYPE_ID>selected</cfif>>#QUALITY_CONTROL_TYPE#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12" id="dimensions_visible" style="display:none;">
                    <div class="col col-2 col-md-2 col-xs-12" id="diameter_visible">
                        <label><cf_get_lang dictionary_id="65032.Çap"></label>
                        <div class="form-group">
                            <div class="input-group">   
                                <input type="text" name="diameter" id="diameter" onchange="calculate_volume()" <cfif isdefined("GET_SPECT.DIAMETER")>value="<cfoutput>#TLformat(GET_SPECT.DIAMETER)#</cfoutput>"</cfif>>
                                <span class="input-group-addon width" style="width:80px;">
                                    <select id="cap_unit" name="cap_unit" onclick="calculate_volume()">
                                        <cfoutput>
                                            <option value = "1">mm</option>
                                            <option value = "2">cm</option>
                                            <option value = "3"><cf_get_lang dictionary_id="65033.inch"></option>
                                        </cfoutput>
                                    </select>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="col col-1 col-md-1 col-xs-12" id="width_visible">
                        <label><cf_get_lang dictionary_id="57695.Genişlik"></label>
                        <div class="form-group">
                            <input type="text" name="width" id="width" onchange="calculate_volume()" <cfif isdefined("GET_SPECT.WIDTH")>value="<cfoutput>#TLformat(GET_SPECT.WIDTH)#</cfoutput>"</cfif>>
                        </div>
                    </div>
                    <div class="col col-2 col-md-2 col-xs-12" id="height_visible">
                        <label><cf_get_lang dictionary_id="57696.Yükseklik"></label>
                        <div class="form-group">
                            <div class="input-group">   
                                <input type="text" name="height" id="height" onchange="calculate_volume()" <cfif isdefined("GET_SPECT.HEIGHT")>value="<cfoutput>#TLformat(GET_SPECT.HEIGHT)#</cfoutput>"</cfif>>
                                <span class="input-group-addon width" style="width:80px;">     
                                    <select id="width_unit" name="width_unit" onclick="calculate_volume()">
                                        <cfoutput>
                                            <option value = "1">cm</option>
                                            <option value = "2">mm</option>
                                            <option value = "3"><cf_get_lang dictionary_id="65033.inch"></option>
                                        </cfoutput>
                                    </select>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="col col-2 col-md-2 col-xs-12" id="size_visible">
                        <label><cf_get_lang dictionary_id="39511.Boy"></label>
                        <div class="form-group">
                            <div class="input-group">   
                                <input type="text" name="size" id="size" onchange="calculate_volume()" <cfif isdefined("GET_SPECT.SIZE")>value="<cfoutput>#TLformat(GET_SPECT.SIZE)#</cfoutput>"</cfif>>
                                <span class="input-group-addon width" style="width:80px;">
                                    <select id="size_unit" name="size_unit" onclick="calculate_volume()">
                                        <cfoutput>
                                            <option value = "1">cm</option>
                                            <option value = "2">m</option>
                                            <option value = "3"><cf_get_lang dictionary_id="65033.inch"></option>
                                        </cfoutput>
                                    </select>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="col col-2 col-md-2 col-xs-12" id="thickness_visible">
                        <label><cf_get_lang dictionary_id="75.Kalınlık"></label>
                        <div class="form-group">
                            <div class="input-group">   
                                <input type="text" name="thickness" id="thickness" onchange="calculate_volume()" <cfif isdefined("GET_SPECT.THICKNESS")>value="<cfoutput>#TLformat(GET_SPECT.THICKNESS)#</cfoutput>"</cfif>>
                                <span class="input-group-addon width" style="width:80px;">
                                    <select id="thickness_unit" name="thickness_unit" onclick="calculate_volume()">
                                        <cfoutput>
                                            <option value = "1">mm</option>
                                        </cfoutput>
                                    </select>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="col col-1 col-md-1 col-xs-12" id="iccap_visible">
                        <label><cf_get_lang dictionary_id="65034.Rulo İç Çap"></label>
                        <div class="form-group">
                            <input type="text" name="iccap" id="iccap" onchange="calculate_volume()" <cfif isdefined("GET_SPECT.INNER_DIAMETER")>value="<cfoutput>#TLformat(GET_SPECT.INNER_DIAMETER)#</cfoutput>"</cfif>>
                        </div>
                    </div>
                    <div class="col col-2 col-md-2 col-xs-12" id="discap_visible">
                        <label><cf_get_lang dictionary_id="65035.Dış Çap"></label>
                        <div class="form-group">
                            <div class="input-group">   
                                <input type="text" name="discap" id="discap" onchange="calculate_volume()" <cfif isdefined("GET_SPECT.OUTER_DIAMETER")>value="<cfoutput>#TLformat(GET_SPECT.OUTER_DIAMETER)#</cfoutput>"</cfif>>
                                <span class="input-group-addon width" style="width:80px;">     
                                    <select id="icdiscap_unit"  name="icdiscap_unit" onclick="calculate_volume()">
                                        <cfoutput>
                                            <option value = "1">mm</option>
                                            <option value = "2">cm</option>
                                        </cfoutput>
                                    </select>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="col col-2 col-md-2 col-xs-12">
                        <label><cf_get_lang dictionary_id="30114.Hacim"></label>
                        <div class="form-group">
                            <div class="input-group">   
                                <input type="text" name="volume" id="volume">
                                <span class="input-group-addon width" style="width:80px;">
                                    <select name="volume_unit">
                                        <cfoutput>
                                            <option value = "2">cm3</option>
                                        </cfoutput>
                                    </select>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="col col-2 col-md-2 col-xs-12">
                        <label><cf_get_lang dictionary_id="65036.Birim Ağırlık"></label>
                        <div class="form-group">
                            <div class="input-group">   
                                <input type="text" name="weight" id="weight">
                                <span class="input-group-addon width" style="width:80px;">
                                    <select id="weight_unit" name="weight_unit">
                                        <cfoutput>
                                            <option value = "1">kg</option>
                                        </cfoutput>
                                    </select>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="col col-1 col-md-1 col-xs-12">
                        <label><cf_get_lang dictionary_id="58082.Adet"></label>
                        <div class="form-group">
                            <input type="text" name="number" id="number">
                        </div>
                    </div>
                    <div class="col col-2 col-md-2 col-xs-12">
                        <label><cf_get_lang dictionary_id="65037.Toplam Ağırlık"></label>
                        <div class="form-group">
                            <div class="input-group">   
                                <input type="text" name="total_weight" id="total_weight">
                                <span class="input-group-addon width" style="width:80px;">     
                                <select name="weight_unit">
                                    <cfoutput>
                                        <option value = "1">kg</option>
                                    </cfoutput>
                                </select>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="col col-1 col-md-1 col-xs-12">
                        <label><cf_get_lang dictionary_id="65038.Bağ/Adet"></label>
                        <div class="form-group">
                            <input type="text" name="number" id="number">
                        </div>
                    </div>
                    <div class="col col-1 col-md-1 col-xs-12">
                        <label><cf_get_lang dictionary_id="65039.Bağ Sayısı"></label>
                        <div class="form-group">
                            <input type="text" name="number" id="number">
                        </div>
                    </div>
                </div>
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12" style="margin-left:-5px!important;margin-top:20px!important;">
                    <div class="col col-3 col-md-3 col-xs-12">
                        <div class="form-group">
                            <div class="col col-6 col-md-6 col-xs-12">
                                <a href="javascript://" onclick="generate_mpc()" class="ui-btn ui-btn-delete"><cf_get_lang dictionary_id="65041.MPC-Spekt Üret"></a>
                            </div>
                            <div class="col col-6 col-md-6 col-xs-12">
                                <input type="text" placeholder="<cf_get_lang dictionary_id="65040.MPC - SPEC ID">" name="mpc" id="mpc">
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-3 col-xs-12">
                        <div class="form-group">
                            <div class="col col-6 col-md-6 col-xs-12">
                                <a href="javascript://" class="ui-btn ui-btn-success" onclick="control_comp_selected(0,0);"><cf_get_lang dictionary_id="65042.Stok İncele"></a>
                            </div> 
                            <div class="col col-6 col-md-6 col-xs-12">
                                <a href="javascript://" class="ui-btn ui-btn-update"><cf_get_lang dictionary_id="65043.Konfigüre Et"></a>
                            </div> 
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script>
            function calculate_volume(){
                $("#configurator #mpc").val("");
                carpan=1;
                vol=0;
                if(size_unit.value==2){carpan=100;}else if(size_unit.value==3){carpan=2.54;}
                value = cat.value;
                category = value.split("|");
                switch (category[2]) {
                    case '1':
                        document.getElementById("width_visible").style.display = "none";
                        document.getElementById("height_visible").style.display = "none";
                        document.getElementById("iccap_visible").style.display = "none";
                        document.getElementById("discap_visible").style.display = "none";
                        document.getElementById("diameter_visible").style.display = "block";
                        document.getElementById("thickness_visible").style.display = "block";
                        document.getElementById("size_visible").style.display = "block";
                        document.getElementById("dimensions_visible").style.display = "block";
                        if(cap_unit.value==1){carpan=0.1*carpan;}else if(cap_unit.value==3){carpan=2.54*carpan;}
                        carpan=0.1*carpan;
                        vol=carpan*2*3.14*filterNum(diameter.value)*filterNum(thickness.value)*filterNum(size.value)/2;
                        volume.value=commaSplit(vol);
                        break;
                    case '9':
                        document.getElementById("width_visible").style.display = "none";
                        document.getElementById("height_visible").style.display = "none";
                        document.getElementById("iccap_visible").style.display = "none";
                        document.getElementById("discap_visible").style.display = "none";
                        document.getElementById("diameter_visible").style.display = "block";
                        document.getElementById("thickness_visible").style.display = "none";
                        document.getElementById("size_visible").style.display = "block";
                        document.getElementById("dimensions_visible").style.display = "block";
                        if(cap_unit.value==1){carpan=0.1*carpan;}else if(cap_unit.value==3){carpan=2.54*carpan;}
                        vol=carpan*3.14*(filterNum(diameter.value)/2)*(filterNum(diameter.value)/2)*filterNum(size.value);
                        volume.value=commaSplit(vol);
                        break;
                    case '2':
                        document.getElementById("width_visible").style.display = "block";
                        document.getElementById("height_visible").style.display = "block";
                        document.getElementById("iccap_visible").style.display = "none";
                        document.getElementById("discap_visible").style.display = "none";
                        document.getElementById("diameter_visible").style.display = "none";
                        document.getElementById("thickness_visible").style.display = "block";
                        document.getElementById("size_visible").style.display = "block";
                        document.getElementById("dimensions_visible").style.display = "block";
                        if(width_unit.value==2){carpan=0.01*carpan;}else if(width_unit.value==3){carpan=2.54*2.54*carpan;}
                        carpan=0.1*carpan;
                        vol=carpan*filterNum(width.value)*filterNum(height.value)*filterNum(thickness.value)*filterNum(size.value);
                        volume.value=commaSplit(vol);
                        break;
                    case '12': case '13':
                        document.getElementById("width_visible").style.display = "block";
                        document.getElementById("height_visible").style.display = "block";
                        document.getElementById("iccap_visible").style.display = "none";
                        document.getElementById("discap_visible").style.display = "none";
                        document.getElementById("diameter_visible").style.display = "none";
                        document.getElementById("thickness_visible").style.display = "none";
                        document.getElementById("size_visible").style.display = "block";
                        document.getElementById("dimensions_visible").style.display = "block";
                        if(width_unit.value==2){carpan=0.01*carpan;}else if(width_unit.value==3){carpan=2.54*2.54*carpan;}
                        vol=carpan*filterNum(width.value)*filterNum(height.value)*filterNum(size.value);
                        volume.value=commaSplit(vol);
                        break;
                    case '16':
                        document.getElementById("width_visible").style.display = "none";
                        document.getElementById("height_visible").style.display = "none";
                        document.getElementById("iccap_visible").style.display = "block";
                        document.getElementById("discap_visible").style.display = "block";
                        document.getElementById("diameter_visible").style.display = "none";
                        document.getElementById("thickness_visible").style.display = "none";
                        document.getElementById("size_visible").style.display = "block";
                        document.getElementById("dimensions_visible").style.display = "block";
                        if(icdiscap_unit.value==1){carpan=0.01*carpan;}
                        vol=(carpan*3.14*filterNum(discap.value)*filterNum(discap.value)*filterNum(size.value)) - (carpan*3.14*filterNum(iccap.value)*filterNum(iccap.value)*filterNum(size.value));
                        volume.value=commaSplit(vol);
                        break;
                    case '14':
                        document.getElementById("width_visible").style.display = "block";
                        document.getElementById("height_visible").style.display = "block";
                        document.getElementById("iccap_visible").style.display = "none";
                        document.getElementById("discap_visible").style.display = "none";
                        document.getElementById("diameter_visible").style.display = "none";
                        document.getElementById("thickness_visible").style.display = "none";
                        document.getElementById("size_visible").style.display = "block";
                        document.getElementById("dimensions_visible").style.display = "block";
                        if(width_unit.value==2){carpan=0.01*carpan;}else if(width_unit.value==3){carpan=2.54*2.54*carpan;}
                        vol=(carpan*filterNum(width.value)*filterNum(height.value)*filterNum(size.value))/2;
                        volume.value=commaSplit(vol);
                        break;
                    case '11':
                        document.getElementById("width_visible").style.display = "block";
                        document.getElementById("height_visible").style.display = "none";
                        document.getElementById("iccap_visible").style.display = "none";
                        document.getElementById("discap_visible").style.display = "none";
                        document.getElementById("diameter_visible").style.display = "none";
                        document.getElementById("thickness_visible").style.display = "none";
                        document.getElementById("size_visible").style.display = "block";
                        document.getElementById("dimensions_visible").style.display = "block";
                        if(width_unit.value==2){carpan=0.01*carpan;}else if(width_unit.value==3){carpan=2.54*2.54*carpan;}
                        vol=((filterNum(width.value)*filterNum(width.value)*5)/(4*Math.tan(36 * Math.PI / 180)))*filterNum(size.value)*carpan;
                        volume.value=commaSplit(vol);
                        break;
                    case '10':
                        document.getElementById("width_visible").style.display = "block";
                        document.getElementById("height_visible").style.display = "none";
                        document.getElementById("iccap_visible").style.display = "none";
                        document.getElementById("discap_visible").style.display = "none";
                        document.getElementById("diameter_visible").style.display = "none";
                        document.getElementById("thickness_visible").style.display = "none";
                        document.getElementById("size_visible").style.display = "block";
                        document.getElementById("dimensions_visible").style.display = "block";
                        if(width_unit.value==2){carpan=0.1*carpan;}else if(width_unit.value==3){carpan=2.54*carpan;}
                        vol=carpan*filterNum(width.value)*Math.sqrt(3)*3*filterNum(size.value);
                        volume.value=commaSplit(vol);
                        break;
                    default:
                    document.getElementById("width_visible").style.display = "block";
                    document.getElementById("height_visible").style.display = "block";
                    document.getElementById("iccap_visible").style.display = "block";
                    document.getElementById("discap_visible").style.display = "block";
                    document.getElementById("diameter_visible").style.display = "block";
                    document.getElementById("thickness_visible").style.display = "block";
                    document.getElementById("size_visible").style.display = "block";
                    document.getElementById("dimensions_visible").style.display = "none";
                    volume.value=commaSplit(0);
                }
                value = quality.value;
                specific_weight = value.split("|");
                weight.value=commaSplit(vol*filterNum(specific_weight[1]));
            }
            calculate_volume();
        </script>
    </cfif>
</cf_box_elements>
<cfif not isdefined("attributes.main_config")>
    <cfset attributes.type="add">
    <cfset attributes.from_product_config =1>
    <cfif isdefined("attributes.stock_id")>
        <cfif isdefined("attributes.int_basket_id")>
            <cfset attributes.basket_id=attributes.int_basket_id>
        <cfelse>
            <cfset attributes.basket_id=attributes.temp_basket_id>
        </cfif>
        <cfinclude  template="../../objects/form/configurator.cfm">
    </cfif>
</cfif>
