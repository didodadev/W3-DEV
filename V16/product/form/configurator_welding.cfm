<cf_box_elements>
<cfquery name="get_conf" datasource="#dsn3#">
    SELECT
        *
    FROM SETUP_PRODUCT_CONFIGURATOR AS SPC
    WHERE 
       SPC.PRODUCT_CONFIGURATOR_ID=<cfqueryparam value = "#attributes.config_id#" CFSQLType = "cf_sql_integer">
</cfquery>
<cfif isdefined("attributes.spect_id")>
<cfquery name="GET_SPECT_WELDING" datasource="#dsn3#">
    SELECT * FROM SPECTS 
    WHERE SPECT_VAR_ID= <cfqueryparam value = "#attributes.spect_id#" CFSQLType = "cf_sql_integer">
</cfquery>
<cfset GET_SPECT=deserializeJSON(GET_SPECT_WELDING.WELDING_JSON)>
</cfif>
<cfif get_conf.ORIGIN eq 4 and isdefined("attributes.stock_id")>
    <cf_seperator id="kaynak" header="#getLang(dictionary_id: 65111)#" closeForGrid="1" >
    <div class="row">
    <div class="col col-12" id="kaynak" style="display:none;">
    <div class="col col-7 col-md-7 col-xs-12">
        <style>
        #shapes {border-style: solid; border-color:#E6E6E6;}
        </style>
        <div class="col col-3 col-md-3 col-xs-12" id="shapes">
        <a onclick="change_shape1()" href="javascript://"><img src="images/butt.svg" width="100%" height="100%"></a>
        </div>
        <div class="col col-3 col-md-3 col-xs-12" id="shapes">
        <a onclick="change_shape2()" href="javascript://"><img src="images/single_butt.svg" width="100%" height="100%"></a>
        </div>
        <div class="col col-3 col-md-3 col-xs-12" id="shapes">
        <a onclick="change_shape3()" href="javascript://"><img src="images/double_butt.svg" width="100%" height="100%"></a>
        </div>
        <div class="col col-3 col-md-3 col-xs-12" id="shapes">
        <a onclick="change_shape4()" href="javascript://"><img src="images/fillet.svg" width="100%" height="100%"></a>
    </div>
    <a></a>
    </div>
    <div class="col col-1 col-md-1 col-xs-12"></div>
    <div class="col col-4 col-md-4 col-xs-12">
        <img id="shape1_" src="images/butt_big.svg" width="100%" height="100%">
        <img id="shape2_" src="images/single_butt_big.svg" style="display:none;" width="100%" height="100%">
        <img id="shape3_" src="images/double_butt_big.svg" style="display:none;" width="100%" height="100%">
        <img id="shape4_" src="images/fillet_butt_big.svg" style="display:none;" width="100%" height="100%">
    </div>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12" id="shape_1">
    <div class="col col-3 col-md-3 col-xs-12">
    <label>&nbsp;&nbsp;<cf_get_lang dictionary_id="65116.Saç Kalınlığı">(th)</label>
    <div class="form-group">
    <div class="col col-12 col-md-12 col-xs-12">
    <div class="input-group">
    <input type="text"  id="butt_sheet_thickness" name="butt_sheet_thickness" <cfif isdefined("GET_SPECT.BUTT_SHEET_THICKNESS")>value="<cfoutput>#TLformat(GET_SPECT.BUTT_SHEET_THICKNESS)#</cfoutput>"</cfif>>
    <span class="input-group-addon width">
        <select>
            <option value = "1">mm</option>
        </select>
    </span>
    </div>
    </div>
    </div>
    </div>
    <div class="col col-3 col-md-3 col-xs-12">
    <label>&nbsp;&nbsp;<cf_get_lang dictionary_id="65117.Kenar Nüfuziyeti">(o)</label>
    <div class="form-group">
        <div class="col col-12 col-md-12 col-xs-12">
        <div class="input-group">
            <select id="butt_overlap" name="butt_overlap">
                <option value=""><cf_get_lang dictionary_id="57734.seçiniz"></option>
                <option value="0" <cfif isdefined("GET_SPECT.butt_overlap") and GET_SPECT.butt_overlap eq 0>selected</cfif>>0</option>
                <option value="1" <cfif isdefined("GET_SPECT.butt_overlap") and GET_SPECT.butt_overlap eq 1>selected</cfif>>1</option>
                <option value="2" <cfif isdefined("GET_SPECT.butt_overlap") and GET_SPECT.butt_overlap eq 2>selected</cfif>>2</option>
                <option value="3" <cfif isdefined("GET_SPECT.butt_overlap") and GET_SPECT.butt_overlap eq 3>selected</cfif>>3</option>
                <option value="4" <cfif isdefined("GET_SPECT.butt_overlap") and GET_SPECT.butt_overlap eq 4>selected</cfif>>4</option>
                <option value="5" <cfif isdefined("GET_SPECT.butt_overlap") and GET_SPECT.butt_overlap eq 5>selected</cfif>>5</option>
                <option value="6" <cfif isdefined("GET_SPECT.butt_overlap") and GET_SPECT.butt_overlap eq 6>selected</cfif>>6</option>
                <option value="7" <cfif isdefined("GET_SPECT.butt_overlap") and GET_SPECT.butt_overlap eq 7>selected</cfif>>7</option>
                <option value="8" <cfif isdefined("GET_SPECT.butt_overlap") and GET_SPECT.butt_overlap eq 8>selected</cfif>>8</option>
                <option value="9" <cfif isdefined("GET_SPECT.butt_overlap") and GET_SPECT.butt_overlap eq 9>selected</cfif>>9</option>
                <option value="10" <cfif isdefined("GET_SPECT.butt_overlap") and GET_SPECT.butt_overlap eq 10>selected</cfif>>10</option>
                </select>
                <span class="input-group-addon width">
                    <select>
                        <option value = "1">mm</option>
                    </select>
                </span> 
        </div>
    </div>
    </div>
    </div>
    <div class="col col-3 col-md-3 col-xs-12">
    <label>&nbsp;&nbsp;<cf_get_lang dictionary_id="65120.Kaynak Uzunluğu"></label>
    <div class="form-group" id="item-assetp_dorse_id">
    <div class="col col-12 col-md-12 col-xs-12">
    <div class="input-group">
    <input type="text"  class="form-control calcField" id="butt_seam_length" name="butt_seam_length" <cfif isdefined("GET_SPECT.BUTT_SEAM_LENGTH")>value="<cfoutput>#TLformat(GET_SPECT.BUTT_SEAM_LENGTH)#</cfoutput>"</cfif>>
    <span class="input-group-addon width">
        <select>
            <option value = "1">m</option>
        </select>
    </span> 
    </div>
    </div>
    </div>
    </div>
    <div class="col col-3 col-md-3 col-xs-12">
    <label>&nbsp;&nbsp;<cf_get_lang dictionary_id="65118.Kök Boşluğu">(G)</label>
    <div class="form-group" id="item-assetp_dorse_id">
        <div class="col col-12 col-md-12 col-xs-12">
        <divc class="input-group">
            <select id="butt_root_gap" class="form-control calcField" name="butt_root_gap">
                <option value=""><cf_get_lang dictionary_id="57734.seçiniz"></option>
                <option value="0" <cfif isdefined("GET_SPECT.butt_root_gap") and GET_SPECT.butt_root_gap eq 0>selected</cfif>>0</option>
                <option value="1" <cfif isdefined("GET_SPECT.butt_root_gap") and GET_SPECT.butt_root_gap eq 1>selected</cfif>>1</option>
                <option value="2" <cfif isdefined("GET_SPECT.butt_root_gap") and GET_SPECT.butt_root_gap eq 2>selected</cfif>>2</option>
                <option value="3" <cfif isdefined("GET_SPECT.butt_root_gap") and GET_SPECT.butt_root_gap eq 3>selected</cfif>>3</option>
                <option value="4" <cfif isdefined("GET_SPECT.butt_root_gap") and GET_SPECT.butt_root_gap eq 4>selected</cfif>>4</option>
                <option value="5" <cfif isdefined("GET_SPECT.butt_root_gap") and GET_SPECT.butt_root_gap eq 5>selected</cfif>>5</option>
                <option value="6" <cfif isdefined("GET_SPECT.butt_root_gap") and GET_SPECT.butt_root_gap eq 6>selected</cfif>>6</option>
                <option value="7" <cfif isdefined("GET_SPECT.butt_root_gap") and GET_SPECT.butt_root_gap eq 7>selected</cfif>>7</option>
                <option value="8" <cfif isdefined("GET_SPECT.butt_root_gap") and GET_SPECT.butt_root_gap eq 8>selected</cfif>>8</option>
                <option value="9" <cfif isdefined("GET_SPECT.butt_root_gap") and GET_SPECT.butt_root_gap eq 9>selected</cfif>>9</option>
                <option value="10" <cfif isdefined("GET_SPECT.butt_root_gap") and GET_SPECT.butt_root_gap eq 10>selected</cfif>>10</option>
            </select>
            <span class="input-group-addon width">
                <select>
                    <option value = "1">mm</option>
                </select>
            </span> 
        </div>
    </div>
    </div>
    <div class="col col-3 col-md-3 col-xs-12">
    <label>&nbsp;&nbsp;<cf_get_lang dictionary_id="65119.Kapak Yüksekliği">(c)</label>
    <div class="form-group" id="item-assetp_dorse_id">
        <div class="col col-12 col-md-12 col-xs-12">
        <div class="input-group">
        <select id="butt_cap" class="form-control calcField" name="butt_cap">
            <option value=""><cf_get_lang dictionary_id="57734.seçiniz"></option>
            <option value="0" <cfif isdefined("GET_SPECT.butt_cap") and GET_SPECT.butt_cap eq 0>selected</cfif>>0</option>
            <option value="1" <cfif isdefined("GET_SPECT.butt_cap") and GET_SPECT.butt_cap eq 1>selected</cfif>>1</option>
            <option value="2" <cfif isdefined("GET_SPECT.butt_cap") and GET_SPECT.butt_cap eq 2>selected</cfif>>2</option>
            <option value="3" <cfif isdefined("GET_SPECT.butt_cap") and GET_SPECT.butt_cap eq 3>selected</cfif>>3</option>
            <option value="4" <cfif isdefined("GET_SPECT.butt_cap") and GET_SPECT.butt_cap eq 4>selected</cfif>>4</option>
            <option value="5" <cfif isdefined("GET_SPECT.butt_cap") and GET_SPECT.butt_cap eq 5>selected</cfif>>5</option>
        </select>
        <span class="input-group-addon width">
            <select>
                <option value = "1">mm</option>
            </select>
        </span> 
    </div>
    </div>
    </div>
    </div>
    <div class="col col-3 col-md-3 col-xs-12">
    <label>&nbsp;&nbsp;<cf_get_lang dictionary_id="65121.Penetration">(p)</label>
    <div class="form-group" id="item-assetp_dorse_id">
        <div class="col col-12 col-md-12 col-xs-12">
        <div class="input-group">
        <select id="butt_penetration" class="form-control calcField" name="butt_penetration" >
        <option value=""><cf_get_lang dictionary_id="57734.seçiniz"></option>
        <option value="0" <cfif isdefined("GET_SPECT.butt_penetration") and GET_SPECT.butt_penetration eq 0>selected</cfif>>0</option>
        <option value="1" <cfif isdefined("GET_SPECT.butt_penetration") and GET_SPECT.butt_penetration eq 1>selected</cfif>>1</option>
        <option value="2" <cfif isdefined("GET_SPECT.butt_penetration") and GET_SPECT.butt_penetration eq 2>selected</cfif>>2</option>
        <option value="3" <cfif isdefined("GET_SPECT.butt_penetration") and GET_SPECT.butt_penetration eq 3>selected</cfif>>3</option>
        <option value="4" <cfif isdefined("GET_SPECT.butt_penetration") and GET_SPECT.butt_penetration eq 4>selected</cfif>>4</option>
        <option value="5" <cfif isdefined("GET_SPECT.butt_penetration") and GET_SPECT.butt_penetration eq 5>selected</cfif>>5</option>
        </select>
        <span class="input-group-addon width">
            <select>
                <option value = "1">mm</option>
            </select>
        </span>
    </div>
    </div>
    </div>
    </div>
    <div class="col col-3 col-md-3 col-xs-12">
    <label>&nbsp;&nbsp;<cf_get_lang dictionary_id="65122.Malzeme Yoğunluğu"> </label>        
    <div class="form-group" id="item-assetp_dorse_id">
        <div class="col col-12 col-md-12 col-xs-12">
        <div class="input-group">
        <select value="" id="butt_steel_density" class="form-control calcField" name="butt_steel_density">
            <option value=""><cf_get_lang dictionary_id="57734.seçiniz"></option>
            <option value="2,73" <cfif isdefined("GET_SPECT.butt_steel_density") and GET_SPECT.butt_steel_density eq 2.73>selected</cfif>>2.73 <cf_get_lang dictionary_id="65123.Alüminyum"></option>
            <option value="7,85" <cfif isdefined("GET_SPECT.butt_steel_density") and GET_SPECT.butt_steel_density eq 7.85>selected</cfif>>7.85 <cf_get_lang dictionary_id="65124.Karbon Çelik"></option>
            <option value="7,9" <cfif isdefined("GET_SPECT.butt_steel_density") and GET_SPECT.butt_steel_density eq 7.9>selected</cfif>>7.9 <cf_get_lang dictionary_id="65125.Paslanmaz Çelik"></option>
            <option value="8,96" <cfif isdefined("GET_SPECT.butt_steel_density") and GET_SPECT.butt_steel_density eq 8.96>selected</cfif>>8.96 <cf_get_lang dictionary_id="65126.Bakır"></option>
        </select>
        <span class="input-group-addon width">
            <select>
                <option value = "1">kg/m3</option>
            </select>
        </span>
    </div>
    </div>
    </div>
    </div>
    <div class="col col-3 col-md-3 col-xs-12">
    </div>
    </div>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12" id="shape_2" style="display:none;">
    <div class="col col-3 col-md-3 col-xs-12">
    <label>&nbsp;&nbsp;<cf_get_lang dictionary_id="65116.Saç Kalınlığı">(th)</label>        
    <div class="form-group" id="item-assetp_dorse_id">
        <div class="col col-12 col-md-12 col-xs-12">
        <div class="input-group">
        <input type="text"  class="form-control calcFieldSingle" id="single_butt_sheet_thickness" name="single_butt_sheet_thickness" <cfif isdefined("GET_SPECT.SINGLE_BUTT_SHEET_THICKNESS")>value="<cfoutput>#TLformat(GET_SPECT.SINGLE_BUTT_SHEET_THICKNESS)#</cfoutput>"</cfif>>
        <span class="input-group-addon width">
            <select>
                <option value = "1">mm</option>
            </select>
        </span>
    </div>
    </div>
    </div>
    </div>
    <div class="col col-3 col-md-3 col-xs-12">
    <label>&nbsp;&nbsp;<cf_get_lang dictionary_id="65120.Kaynak Uzunluğu"></label>        
    <div class="form-group" id="item-assetp_dorse_id">
        <div class="col col-12 col-md-12 col-xs-12">
        <div class="input-group">
            <input type="text"  class="form-control calcFieldSingle" id="single_butt_seam_length" name="single_butt_seam_length" <cfif isdefined("GET_SPECT.SINGLE_BUTT_SEAM_LENGTH")>value="<cfoutput>#TLformat(GET_SPECT.SINGLE_BUTT_SEAM_LENGTH)#</cfoutput>"</cfif>>
            <span class="input-group-addon width">
            <select>
                <option value = "1">m</option>
            </select>
        </span>
    </div>
    </div>
    </div>
    </div>
    <div class="col col-3 col-md-3 col-xs-12">
    <label>&nbsp;&nbsp;<cf_get_lang dictionary_id="65118.Kök Boşluğu">(G)</label>        
    <div class="form-group" id="item-assetp_dorse_id">
        <div class="col col-12 col-md-12 col-xs-12">
        <div class="input-group">
            <select id="single_butt_root_gap" class="form-control calcFieldSingle" name="single_butt_root_gap">
                <option value=""><cf_get_lang dictionary_id="57734.seçiniz"></option>
                <option value="0" <cfif isdefined("GET_SPECT.single_butt_root_gap") and GET_SPECT.single_butt_root_gap eq 0>selected</cfif>>0</option>
                <option value="1" <cfif isdefined("GET_SPECT.single_butt_root_gap") and GET_SPECT.single_butt_root_gap eq 1>selected</cfif>>1</option>
                <option value="2" <cfif isdefined("GET_SPECT.single_butt_root_gap") and GET_SPECT.single_butt_root_gap eq 2>selected</cfif>>2</option>
                <option value="3" <cfif isdefined("GET_SPECT.single_butt_root_gap") and GET_SPECT.single_butt_root_gap eq 3>selected</cfif>>3</option>
                <option value="4" <cfif isdefined("GET_SPECT.single_butt_root_gap") and GET_SPECT.single_butt_root_gap eq 4>selected</cfif>>4</option>
                <option value="5" <cfif isdefined("GET_SPECT.single_butt_root_gap") and GET_SPECT.single_butt_root_gap eq 5>selected</cfif>>5</option>
                <option value="6" <cfif isdefined("GET_SPECT.single_butt_root_gap") and GET_SPECT.single_butt_root_gap eq 6>selected</cfif>>6</option>
                <option value="7" <cfif isdefined("GET_SPECT.single_butt_root_gap") and GET_SPECT.single_butt_root_gap eq 7>selected</cfif>>7</option>
                <option value="8" <cfif isdefined("GET_SPECT.single_butt_root_gap") and GET_SPECT.single_butt_root_gap eq 8>selected</cfif>>8</option>
                <option value="9" <cfif isdefined("GET_SPECT.single_butt_root_gap") and GET_SPECT.single_butt_root_gap eq 9>selected</cfif>>9</option>
                <option value="10" <cfif isdefined("GET_SPECT.single_butt_root_gap") and GET_SPECT.single_butt_root_gap eq 10>selected</cfif>>10</option>
                </select>
                <span class="input-group-addon width">
            <select>
                <option value = "1">mm</option>
            </select>
        </span>
    </div>
    </div>
    </div>
    </div>
    <div class="col col-3 col-md-3 col-xs-12">
    <label>&nbsp;&nbsp;<cf_get_lang dictionary_id="65119.Kapak Yüksekliği">(c)</label>        
    <div class="form-group" id="item-assetp_dorse_id">
        <div class="col col-12 col-md-12 col-xs-12">
        <div class="input-group">
            <select id="single_butt_cap" class="form-control calcFieldSingle" name="single_butt_cap">
                <option value=""><cf_get_lang dictionary_id="57734.seçiniz"></option>
                <option value="0" <cfif isdefined("GET_SPECT.single_butt_cap") and GET_SPECT.single_butt_cap eq 0>selected</cfif>>0</option>
                <option value="1" <cfif isdefined("GET_SPECT.single_butt_cap") and GET_SPECT.single_butt_cap eq 1>selected</cfif>>1</option>
                <option value="2" <cfif isdefined("GET_SPECT.single_butt_cap") and GET_SPECT.single_butt_cap eq 2>selected</cfif>>2</option>
                <option value="3" <cfif isdefined("GET_SPECT.single_butt_cap") and GET_SPECT.single_butt_cap eq 3>selected</cfif>>3</option>
                <option value="4" <cfif isdefined("GET_SPECT.single_butt_cap") and GET_SPECT.single_butt_cap eq 4>selected</cfif>>4</option>
                <option value="5" <cfif isdefined("GET_SPECT.single_butt_cap") and GET_SPECT.single_butt_cap eq 5>selected</cfif>>5</option>
                </select>           
                <span class="input-group-addon width">
            <select>
                <option value = "1">mm</option>
            </select>
        </span>
    </div>
    </div>
    </div>
    </div>
    <div class="col col-3 col-md-3 col-xs-12">
    <label>&nbsp;&nbsp;<cf_get_lang dictionary_id="65121.Penetration">(p)</label>        
    <div class="form-group" id="item-assetp_dorse_id">
        <div class="col col-12 col-md-12 col-xs-12">
        <div class="input-group">
            <select id="single_butt_penetration" class="form-control calcFieldSingle" name="single_butt_penetration">
                <option value=""><cf_get_lang dictionary_id="57734.seçiniz"></option>
                <option value="0" <cfif isdefined("GET_SPECT.single_butt_penetration") and GET_SPECT.single_butt_penetration eq 0>selected</cfif>>0</option>
                <option value="1" <cfif isdefined("GET_SPECT.single_butt_penetration") and GET_SPECT.single_butt_penetration eq 1>selected</cfif>>1</option>
                <option value="2" <cfif isdefined("GET_SPECT.single_butt_penetration") and GET_SPECT.single_butt_penetration eq 2>selected</cfif>>2</option>
                <option value="3" <cfif isdefined("GET_SPECT.single_butt_penetration") and GET_SPECT.single_butt_penetration eq 3>selected</cfif>>3</option>
                <option value="4" <cfif isdefined("GET_SPECT.single_butt_penetration") and GET_SPECT.single_butt_penetration eq 4>selected</cfif>>4</option>
                <option value="5" <cfif isdefined("GET_SPECT.single_butt_penetration") and GET_SPECT.single_butt_penetration eq 5>selected</cfif>>5</option>
                </select>                
                <span class="input-group-addon width">
            <select>
                <option value = "1">mm</option>
            </select>
        </span>
    </div>
    </div>
    </div>
    </div>
    <div class="col col-3 col-md-3 col-xs-12">
    <label>&nbsp;&nbsp;<cf_get_lang dictionary_id="65117.Kenar Nüfuziyeti">(o)</label>        
    <div class="form-group" id="item-assetp_dorse_id">
        <div class="col col-12 col-md-12 col-xs-12">
        <div class="input-group">         
            <select id="single_butt_overlap" class="form-control calcFieldSingle" name="single_butt_overlap">
                <option value=""><cf_get_lang dictionary_id="57734.seçiniz"></option>
                <option value="0" <cfif isdefined("GET_SPECT.single_butt_overlap") and GET_SPECT.single_butt_overlap eq 0>selected</cfif>>0</option>
                <option value="1" <cfif isdefined("GET_SPECT.single_butt_overlap") and GET_SPECT.single_butt_overlap eq 1>selected</cfif>>1</option>
                <option value="2" <cfif isdefined("GET_SPECT.single_butt_overlap") and GET_SPECT.single_butt_overlap eq 2>selected</cfif>>2</option>
                <option value="3" <cfif isdefined("GET_SPECT.single_butt_overlap") and GET_SPECT.single_butt_overlap eq 3>selected</cfif>>3</option>
                <option value="4" <cfif isdefined("GET_SPECT.single_butt_overlap") and GET_SPECT.single_butt_overlap eq 4>selected</cfif>>4</option>
                <option value="5" <cfif isdefined("GET_SPECT.single_butt_overlap") and GET_SPECT.single_butt_overlap eq 5>selected</cfif>>5</option>
                <option value="6" <cfif isdefined("GET_SPECT.single_butt_overlap") and GET_SPECT.single_butt_overlap eq 6>selected</cfif>>6</option>
                <option value="7" <cfif isdefined("GET_SPECT.single_butt_overlap") and GET_SPECT.single_butt_overlap eq 7>selected</cfif>>7</option>
                <option value="8" <cfif isdefined("GET_SPECT.single_butt_overlap") and GET_SPECT.single_butt_overlap eq 8>selected</cfif>>8</option>
                <option value="9" <cfif isdefined("GET_SPECT.single_butt_overlap") and GET_SPECT.single_butt_overlap eq 9>selected</cfif>>9</option>
                <option value="10" <cfif isdefined("GET_SPECT.single_butt_overlap") and GET_SPECT.single_butt_overlap eq 10>selected</cfif>>10</option>
                </select>
            <span class="input-group-addon width">
                <select>
                    <option value = "1">mm</option>
                </select>
            </span>
    </div>
    </div>
    </div>
    </div>
    <div class="col col-3 col-md-3 col-xs-12">
    <label>&nbsp;&nbsp;<cf_get_lang dictionary_id="65129.Kök Yüzey Derinliği">(r)</label>        
    <div class="form-group" id="item-assetp_dorse_id">
        <div class="col col-12 col-md-12 col-xs-12">
        <div class="input-group">         
            <select id="single_butt_depth_of_root_face" class="form-control calcFieldSingle" name="single_butt_depth_of_root_face">
                <option value=""><cf_get_lang dictionary_id="57734.seçiniz"></option>
                <option value="0.5" <cfif isdefined("GET_SPECT.single_butt_depth_of_root_face") and GET_SPECT.single_butt_depth_of_root_face eq 0.5>selected</cfif>>0.5</option>
                <option value="1.0" <cfif isdefined("GET_SPECT.single_butt_depth_of_root_face") and GET_SPECT.single_butt_depth_of_root_face eq 1.0>selected</cfif>>1.0</option>
                <option value="1.5" <cfif isdefined("GET_SPECT.single_butt_depth_of_root_face") and GET_SPECT.single_butt_depth_of_root_face eq 1.5>selected</cfif>>1.5</option>
                <option value="2.0" <cfif isdefined("GET_SPECT.single_butt_depth_of_root_face") and GET_SPECT.single_butt_depth_of_root_face eq 2.0>selected</cfif>>2.0</option>
                <option value="2.5" <cfif isdefined("GET_SPECT.single_butt_depth_of_root_face") and GET_SPECT.single_butt_depth_of_root_face eq 2.5>selected</cfif>>2.5</option>
                <option value="3.0" <cfif isdefined("GET_SPECT.single_butt_depth_of_root_face") and GET_SPECT.single_butt_depth_of_root_face eq 3.0>selected</cfif>>3.0</option>
                <option value="3.5" <cfif isdefined("GET_SPECT.single_butt_depth_of_root_face") and GET_SPECT.single_butt_depth_of_root_face eq 3.5>selected</cfif>>3.5</option>
                <option value="4.0" <cfif isdefined("GET_SPECT.single_butt_depth_of_root_face") and GET_SPECT.single_butt_depth_of_root_face eq 4.0>selected</cfif>>4.0</option>
                <option value="4.5" <cfif isdefined("GET_SPECT.single_butt_depth_of_root_face") and GET_SPECT.single_butt_depth_of_root_face eq 4.5>selected</cfif>>4.5</option>
                <option value="5.0" <cfif isdefined("GET_SPECT.single_butt_depth_of_root_face") and GET_SPECT.single_butt_depth_of_root_face eq 5.0>selected</cfif>>5.0</option>
                <option value="5.5" <cfif isdefined("GET_SPECT.single_butt_depth_of_root_face") and GET_SPECT.single_butt_depth_of_root_face eq 5.5>selected</cfif>>5.5</option>
                <option value="6.0" <cfif isdefined("GET_SPECT.single_butt_depth_of_root_face") and GET_SPECT.single_butt_depth_of_root_face eq 6.0>selected</cfif>>6.0</option>
                <option value="6.5" <cfif isdefined("GET_SPECT.single_butt_depth_of_root_face") and GET_SPECT.single_butt_depth_of_root_face eq 6.5>selected</cfif>>6.5</option>
                <option value="7.0" <cfif isdefined("GET_SPECT.single_butt_depth_of_root_face") and GET_SPECT.single_butt_depth_of_root_face eq 7.0>selected</cfif>>7.0</option>
                <option value="7.5" <cfif isdefined("GET_SPECT.single_butt_depth_of_root_face") and GET_SPECT.single_butt_depth_of_root_face eq 7.5>selected</cfif>>7.5</option>
                <option value="8.0" <cfif isdefined("GET_SPECT.single_butt_depth_of_root_face") and GET_SPECT.single_butt_depth_of_root_face eq 8.0>selected</cfif>>8.0</option>
                <option value="8.5" <cfif isdefined("GET_SPECT.single_butt_depth_of_root_face") and GET_SPECT.single_butt_depth_of_root_face eq 8.5>selected</cfif>>8.5</option>
                <option value="9.0" <cfif isdefined("GET_SPECT.single_butt_depth_of_root_face") and GET_SPECT.single_butt_depth_of_root_face eq 9.0>selected</cfif>>9.0</option>
                <option value="9.5" <cfif isdefined("GET_SPECT.single_butt_depth_of_root_face") and GET_SPECT.single_butt_depth_of_root_face eq 9.5>selected</cfif>>9.5</option>
                </select>
            <span class="input-group-addon width">
                <select>
                    <option value = "1">mm</option>
                </select>
            </span>
        </div>
    </div>
    </div>
    </div>
    <div class="col col-3 col-md-3 col-xs-12">
    <label>&nbsp;&nbsp;<cf_get_lang dictionary_id="65131.Alfa">1 (a1)</label>        
    <div class="form-group" id="item-assetp_dorse_id">
        <div class="col col-12 col-md-12 col-xs-12">
        <div class="input-group">         
            <input type="text"  class="form-control calcFieldSingle" id="single_butt_alpha1" name="single_butt_alpha1" <cfif isdefined("GET_SPECT.SINGLE_BUTT_ALPHA1")>value="<cfoutput>#TLformat(GET_SPECT.SINGLE_BUTT_ALPHA1)#</cfoutput>"</cfif>>
            <span class="input-group-addon width">
                <select>
                    <option value = "1">*</option>
                </select>
            </span>
    </div>
    </div>
    </div>
    </div>
    <div class="col col-3 col-md-3 col-xs-12">
    <label>&nbsp;&nbsp;<cf_get_lang dictionary_id="65131.Alfa">2 (a2)</label>        
    <div class="form-group" id="item-assetp_dorse_id">
        <div class="col col-12 col-md-12 col-xs-12">
        <div class="input-group">         
            <input type="text"  class="form-control calcFieldSingle" id="single_butt_alpha2" name="single_butt_alpha2" <cfif isdefined("GET_SPECT.SINGLE_BUTT_ALPHA2")>value="<cfoutput>#TLformat(GET_SPECT.SINGLE_BUTT_ALPHA2)#</cfoutput>"</cfif>>                
            <span class="input-group-addon width">
                <select>
                    <option value = "1">*</option>
                </select>
            </span>
        </div>
    </div>
    </div>
    </div>
    <div class="col col-3 col-md-3 col-xs-12">
    <label>&nbsp;&nbsp;<cf_get_lang dictionary_id="65122.Malzeme Yoğunluğu"></label>        
    <div class="form-group" id="item-assetp_dorse_id">
        <div class="col col-12 col-md-12 col-xs-12">
        <div class="input-group">         
            <select value="" id="single_butt_steel_density" class="form-control calcFieldSingle" name="single_butt_steel_density">
                <option value=""><cf_get_lang dictionary_id="57734.seçiniz"></option>
                    <option value="2,73" <cfif isdefined("GET_SPECT.single_butt_steel_density") and GET_SPECT.single_butt_steel_density eq 2.73>selected</cfif>>2.73 <cf_get_lang dictionary_id="65123.Alüminyum"></option>
                    <option value="7,85" <cfif isdefined("GET_SPECT.single_butt_steel_density") and GET_SPECT.single_butt_steel_density eq 7.85>selected</cfif>>7.85 <cf_get_lang dictionary_id="65124.Karbon Çelik"></option>
                    <option value="7,9" <cfif isdefined("GET_SPECT.single_butt_steel_density") and GET_SPECT.single_butt_steel_density eq 7.9>selected</cfif>>7.9 <cf_get_lang dictionary_id="65125.Paslanmaz Çelik"></option>
                    <option value="8,96" <cfif isdefined("GET_SPECT.single_butt_steel_density") and GET_SPECT.single_butt_steel_density eq 8.96>selected</cfif>>8.96 <cf_get_lang dictionary_id="65126.Bakır"></option>
                </select>                
                <span class="input-group-addon width">
                <select>
                    <option value = "1">kg/m3</option>
                </select>
            </span>
        </div>
    </div>
    </div>
    </div>
    <div class="col col-3 col-md-3 col-xs-12">
    </div>
    </div>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12" id="shape_3" style="display:none;">
    <div class="col col-3 col-md-3 col-xs-12">
    <label>&nbsp;&nbsp;<cf_get_lang dictionary_id="65116.Saç Kalınlığı">(th)</label>        
    <div class="form-group" id="item-assetp_dorse_id">
    <div class="col col-12 col-md-12 col-xs-12">
    <div class="input-group">         
        <input type="text"  class="form-control calcFieldDouble" id="double_butt_sheet_thickness" name="double_butt_sheet_thickness" <cfif isdefined("GET_SPECT.DOUBLE_BUTT_SHEET_THICKNESS")>value="<cfoutput>#TLformat(GET_SPECT.DOUBLE_BUTT_SHEET_THICKNESS)#</cfoutput>"</cfif>>
        <span class="input-group-addon width">
            <select>
                <option value = "1">mm</option>
            </select>
        </span>
    </div>
    </div>
    </div>
    </div>
    <div class="col col-3 col-md-3 col-xs-12">
    <label>&nbsp;&nbsp;<cf_get_lang dictionary_id="65120.Kaynak Uzunluğu"></label>        
    <div class="form-group" id="item-assetp_dorse_id">
    <div class="col col-12 col-md-12 col-xs-12">
    <div class="input-group">         
        <input type="text"  class="form-control calcFieldDouble" id="double_butt_seam_length" name="double_butt_seam_length" <cfif isdefined("GET_SPECT.DOUBLE_BUTT_SEAM_LENGTH")>value="<cfoutput>#TLformat(GET_SPECT.DOUBLE_BUTT_SEAM_LENGTH)#</cfoutput>"</cfif>>
        <span class="input-group-addon width">
            <select>
                <option value = "1">m</option>
            </select>
        </span>
    </div>
    </div>
    </div>
    </div>
    <div class="col col-3 col-md-3 col-xs-12">
    <label>&nbsp;&nbsp;<cf_get_lang dictionary_id="65118.Kök Boşluğu">(G)</label>        
    <div class="form-group" id="item-assetp_dorse_id">
    <div class="col col-12 col-md-12 col-xs-12">
    <div class="input-group">         
        <select id="double_butt_root_gap" class="form-control calcFieldDouble" name="double_butt_root_gap">
            <option value=""><cf_get_lang dictionary_id="57734.seçiniz"></option>
            <option value="0" <cfif isdefined("GET_SPECT.double_butt_root_gap") and GET_SPECT.double_butt_root_gap eq 0>selected</cfif>>0</option>
            <option value="1" <cfif isdefined("GET_SPECT.double_butt_root_gap") and GET_SPECT.double_butt_root_gap eq 1>selected</cfif>>1</option>
            <option value="2" <cfif isdefined("GET_SPECT.double_butt_root_gap") and GET_SPECT.double_butt_root_gap eq 2>selected</cfif>>2</option>
            <option value="3" <cfif isdefined("GET_SPECT.double_butt_root_gap") and GET_SPECT.double_butt_root_gap eq 3>selected</cfif>>3</option>
            <option value="4" <cfif isdefined("GET_SPECT.double_butt_root_gap") and GET_SPECT.double_butt_root_gap eq 4>selected</cfif>>4</option>
            <option value="5" <cfif isdefined("GET_SPECT.double_butt_root_gap") and GET_SPECT.double_butt_root_gap eq 5>selected</cfif>>5</option>
            <option value="6" <cfif isdefined("GET_SPECT.double_butt_root_gap") and GET_SPECT.double_butt_root_gap eq 6>selected</cfif>>6</option>
            <option value="7" <cfif isdefined("GET_SPECT.double_butt_root_gap") and GET_SPECT.double_butt_root_gap eq 7>selected</cfif>>7</option>
            <option value="8" <cfif isdefined("GET_SPECT.double_butt_root_gap") and GET_SPECT.double_butt_root_gap eq 8>selected</cfif>>8</option>
            <option value="9" <cfif isdefined("GET_SPECT.double_butt_root_gap") and GET_SPECT.double_butt_root_gap eq 9>selected</cfif>>9</option>
            <option value="10" <cfif isdefined("GET_SPECT.double_butt_root_gap") and GET_SPECT.double_butt_root_gap eq 10>selected</cfif>>10</option>
            </select>            
            <span class="input-group-addon width">
            <select>
                <option value = "1">mm</option>
            </select>
        </span>
    </div>
    </div>
    </div>
    </div>
    <div class="col col-3 col-md-3 col-xs-12">
    <label>&nbsp;&nbsp;<cf_get_lang dictionary_id="65119.Kapak Yüksekliği">(c)</label>        
    <div class="form-group" id="item-assetp_dorse_id">
    <div class="col col-12 col-md-12 col-xs-12">
    <div class="input-group">         
        <select id="double_butt_cap" class="form-control calcFieldDouble" name="double_butt_cap">
            <option value=""><cf_get_lang dictionary_id="57734.seçiniz"></option>
             <option value="0" <cfif isdefined("GET_SPECT.double_butt_cap") and GET_SPECT.double_butt_cap eq 0>selected</cfif>>0</option>
            <option value="1" <cfif isdefined("GET_SPECT.double_butt_cap") and GET_SPECT.double_butt_cap eq 1>selected</cfif>>1</option>
            <option value="2" <cfif isdefined("GET_SPECT.double_butt_cap") and GET_SPECT.double_butt_cap eq 2>selected</cfif>>2</option>
            <option value="3" <cfif isdefined("GET_SPECT.double_butt_cap") and GET_SPECT.double_butt_cap eq 3>selected</cfif>>3</option>
            <option value="4" <cfif isdefined("GET_SPECT.double_butt_cap") and GET_SPECT.double_butt_cap eq 4>selected</cfif>>4</option>
            <option value="5" <cfif isdefined("GET_SPECT.double_butt_cap") and GET_SPECT.double_butt_cap eq 5>selected</cfif>>5</option>
            </select>          
            <span class="input-group-addon width">
            <select>
                <option value = "1">mm</option>
            </select>
        </span>
    </div>
    </div>
    </div>
    </div>
    <div class="col col-3 col-md-3 col-xs-12">
    <label>&nbsp;&nbsp;<cf_get_lang dictionary_id="65119.Kapak Yüksekliği"> 2 (c)</label>        
    <div class="form-group" id="item-assetp_dorse_id">
    <div class="col col-12 col-md-12 col-xs-12">
    <div class="input-group">         
        <select id="double_butt_cap_2" class="form-control calcFieldDouble" name="double_butt_cap_2">
            <option value=""><cf_get_lang dictionary_id="57734.seçiniz"></option>
            <option value="0" <cfif isdefined("GET_SPECT.double_butt_cap_2") and GET_SPECT.double_butt_cap_2 eq 0>selected</cfif>>0</option>
            <option value="1" <cfif isdefined("GET_SPECT.double_butt_cap_2") and GET_SPECT.double_butt_cap_2 eq 1>selected</cfif>>1</option>
            <option value="2" <cfif isdefined("GET_SPECT.double_butt_cap_2") and GET_SPECT.double_butt_cap_2 eq 2>selected</cfif>>2</option>
            <option value="3" <cfif isdefined("GET_SPECT.double_butt_cap_2") and GET_SPECT.double_butt_cap_2 eq 3>selected</cfif>>3</option>
            <option value="4" <cfif isdefined("GET_SPECT.double_butt_cap_2") and GET_SPECT.double_butt_cap_2 eq 4>selected</cfif>>4</option>
            <option value="5" <cfif isdefined("GET_SPECT.double_butt_cap_2") and GET_SPECT.double_butt_cap_2 eq 5>selected</cfif>>5</option>
            </select>       
            <span class="input-group-addon width">
            <select>
                <option value = "1">mm</option>
            </select>
        </span>
    </div>
    </div>
    </div>
    </div>
    <div class="col col-3 col-md-3 col-xs-12">
    <label>&nbsp;&nbsp;<cf_get_lang dictionary_id="65130.Oluk Derinliği">(d1)</label>        
    <div class="form-group" id="item-assetp_dorse_id">
    <div class="col col-12 col-md-12 col-xs-12">
    <div class="input-group">         
        <input type="text"  class="form-control calcFieldDouble" id="double_butt_seam_groove" name="double_butt_seam_groove" <cfif isdefined("GET_SPECT.DOUBLE_BUTT_SEAM_GROOVE")>value="<cfoutput>#TLformat(GET_SPECT.DOUBLE_BUTT_SEAM_GROOVE)#</cfoutput>"</cfif>>     
            <span class="input-group-addon width">
            <select>
                <option value = "1">mm</option>
            </select>
        </span>
    </div>
    </div>
    </div>
    </div>
    <div class="col col-3 col-md-3 col-xs-12">
    <label>&nbsp;&nbsp;<cf_get_lang dictionary_id="65117.Kenar Nüfuziyeti">(o)</label>        
    <div class="form-group" id="item-assetp_dorse_id">
    <div class="col col-12 col-md-12 col-xs-12">
    <div class="input-group">         
        <select id="double_butt_overlap" class="form-control calcFieldDouble" name="double_butt_overlap">
            <option value=""><cf_get_lang dictionary_id="57734.seçiniz"></option>
            <option value="0" <cfif isdefined("GET_SPECT.double_butt_overlap") and GET_SPECT.double_butt_overlap eq 0>selected</cfif>>0</option>
            <option value="1" <cfif isdefined("GET_SPECT.double_butt_overlap") and GET_SPECT.double_butt_overlap eq 1>selected</cfif>>1</option>
            <option value="2" <cfif isdefined("GET_SPECT.double_butt_overlap") and GET_SPECT.double_butt_overlap eq 2>selected</cfif>>2</option>
            <option value="3" <cfif isdefined("GET_SPECT.double_butt_overlap") and GET_SPECT.double_butt_overlap eq 3>selected</cfif>>3</option>
            <option value="4" <cfif isdefined("GET_SPECT.double_butt_overlap") and GET_SPECT.double_butt_overlap eq 4>selected</cfif>>4</option>
            <option value="5" <cfif isdefined("GET_SPECT.double_butt_overlap") and GET_SPECT.double_butt_overlap eq 5>selected</cfif>>5</option>
            <option value="6" <cfif isdefined("GET_SPECT.double_butt_overlap") and GET_SPECT.double_butt_overlap eq 6>selected</cfif>>6</option>
            <option value="7" <cfif isdefined("GET_SPECT.double_butt_overlap") and GET_SPECT.double_butt_overlap eq 7>selected</cfif>>7</option>
            <option value="8" <cfif isdefined("GET_SPECT.double_butt_overlap") and GET_SPECT.double_butt_overlap eq 8>selected</cfif>>8</option>
            <option value="9" <cfif isdefined("GET_SPECT.double_butt_overlap") and GET_SPECT.double_butt_overlap eq 9>selected</cfif>>9</option>
            <option value="10" <cfif isdefined("GET_SPECT.double_butt_overlap") and GET_SPECT.double_butt_overlap eq 10>selected</cfif>>10</option>
            </select>                
            <span class="input-group-addon width">
            <select>
                <option value = "1">mm</option>
            </select>
        </span>
    </div>
    </div>
    </div>
    </div>
    <div class="col col-3 col-md-3 col-xs-12">
    <label>&nbsp;&nbsp;<cf_get_lang dictionary_id="65129.Kök Yüzey Derinliği">(r)</label>        
    <div class="form-group" id="item-assetp_dorse_id">
    <div class="col col-12 col-md-12 col-xs-12">
    <div class="input-group">         
        <select id="double_butt_depth_of_root_face" class="form-control calcFieldDouble" name="double_butt_depth_of_root_face">
                <option value=""><cf_get_lang dictionary_id="57734.seçiniz"></option>
                <option value="0.5" <cfif isdefined("GET_SPECT.double_butt_depth_of_root_face") and GET_SPECT.double_butt_depth_of_root_face eq 0.5>selected</cfif>>0.5</option>
                <option value="1.0" <cfif isdefined("GET_SPECT.double_butt_depth_of_root_face") and GET_SPECT.double_butt_depth_of_root_face eq 1.0>selected</cfif>>1.0</option>
                <option value="1.5" <cfif isdefined("GET_SPECT.double_butt_depth_of_root_face") and GET_SPECT.double_butt_depth_of_root_face eq 1.5>selected</cfif>>1.5</option>
                <option value="2.0" <cfif isdefined("GET_SPECT.double_butt_depth_of_root_face") and GET_SPECT.double_butt_depth_of_root_face eq 2.0>selected</cfif>>2.0</option>
                <option value="2.5" <cfif isdefined("GET_SPECT.double_butt_depth_of_root_face") and GET_SPECT.double_butt_depth_of_root_face eq 2.5>selected</cfif>>2.5</option>
                <option value="3.0" <cfif isdefined("GET_SPECT.double_butt_depth_of_root_face") and GET_SPECT.double_butt_depth_of_root_face eq 3.0>selected</cfif>>3.0</option>
                <option value="3.5" <cfif isdefined("GET_SPECT.double_butt_depth_of_root_face") and GET_SPECT.double_butt_depth_of_root_face eq 3.5>selected</cfif>>3.5</option>
                <option value="4.0" <cfif isdefined("GET_SPECT.double_butt_depth_of_root_face") and GET_SPECT.double_butt_depth_of_root_face eq 4.0>selected</cfif>>4.0</option>
                <option value="4.5" <cfif isdefined("GET_SPECT.double_butt_depth_of_root_face") and GET_SPECT.double_butt_depth_of_root_face eq 4.5>selected</cfif>>4.5</option>
                <option value="5.0" <cfif isdefined("GET_SPECT.double_butt_depth_of_root_face") and GET_SPECT.double_butt_depth_of_root_face eq 5.0>selected</cfif>>5.0</option>
                <option value="5.5" <cfif isdefined("GET_SPECT.double_butt_depth_of_root_face") and GET_SPECT.double_butt_depth_of_root_face eq 5.5>selected</cfif>>5.5</option>
                <option value="6.0" <cfif isdefined("GET_SPECT.double_butt_depth_of_root_face") and GET_SPECT.double_butt_depth_of_root_face eq 6.0>selected</cfif>>6.0</option>
                <option value="6.5" <cfif isdefined("GET_SPECT.double_butt_depth_of_root_face") and GET_SPECT.double_butt_depth_of_root_face eq 6.5>selected</cfif>>6.5</option>
                <option value="7.0" <cfif isdefined("GET_SPECT.double_butt_depth_of_root_face") and GET_SPECT.double_butt_depth_of_root_face eq 7.0>selected</cfif>>7.0</option>
                <option value="7.5" <cfif isdefined("GET_SPECT.double_butt_depth_of_root_face") and GET_SPECT.double_butt_depth_of_root_face eq 7.5>selected</cfif>>7.5</option>
                <option value="8.0" <cfif isdefined("GET_SPECT.double_butt_depth_of_root_face") and GET_SPECT.double_butt_depth_of_root_face eq 8.0>selected</cfif>>8.0</option>
                <option value="8.5" <cfif isdefined("GET_SPECT.double_butt_depth_of_root_face") and GET_SPECT.double_butt_depth_of_root_face eq 8.5>selected</cfif>>8.5</option>
                <option value="9.0" <cfif isdefined("GET_SPECT.double_butt_depth_of_root_face") and GET_SPECT.double_butt_depth_of_root_face eq 9.0>selected</cfif>>9.0</option>
                <option value="9.5" <cfif isdefined("GET_SPECT.double_butt_depth_of_root_face") and GET_SPECT.double_butt_depth_of_root_face eq 9.5>selected</cfif>>9.5</option>
            </select>
            <span class="input-group-addon width">
            <select>
                <option value = "1">mm</option>
            </select>
        </span>
    </div>
    </div>
    </div>
    </div>
    <div class="col col-3 col-md-3 col-xs-12">
    <label>&nbsp;&nbsp;<cf_get_lang dictionary_id="65131.Alfa">1 (a1)</label>        
    <div class="form-group" id="item-assetp_dorse_id">
    <div class="col col-12 col-md-12 col-xs-12">
    <div class="input-group">         
        <input type="text"  class="form-control calcFieldDouble" id="double_butt_alpha1" name="double_butt_alpha1" <cfif isdefined("GET_SPECT.DOUBLE_BUTT_ALPHA_1")>value="<cfoutput>#TLformat(GET_SPECT.DOUBLE_BUTT_ALPHA_1)#</cfoutput>"</cfif>>
            <span class="input-group-addon width">
            <select>
                <option value = "1">*</option>
            </select>
        </span>
    </div>
    </div>
    </div>
    </div>
    <div class="col col-3 col-md-3 col-xs-12">
    <label>&nbsp;&nbsp;<cf_get_lang dictionary_id="65131.Alfa">2 (a2)</label>        
    <div class="form-group" id="item-assetp_dorse_id">
    <div class="col col-12 col-md-12 col-xs-12">
    <div class="input-group">         
        <input type="text"  class="form-control calcFieldDouble" id="double_butt_alpha2" name="double_butt_alpha2" <cfif isdefined("GET_SPECT.DOUBLE_BUTT_ALPHA_2")>value="<cfoutput>#TLformat(GET_SPECT.DOUBLE_BUTT_ALPHA_2)#</cfoutput>"</cfif>>                
        <span class="input-group-addon width">
            <select>
                <option value = "1">*</option>
            </select>
        </span>
    </div>
    </div>
    </div>
    </div>
    <div class="col col-3 col-md-3 col-xs-12">
    <label>&nbsp;&nbsp;<cf_get_lang dictionary_id="65131.Alfa">3 (a3)</label>        
    <div class="form-group" id="item-assetp_dorse_id">
    <div class="col col-12 col-md-12 col-xs-12">
    <div class="input-group">         
        <input type="text"  class="form-control calcFieldDouble" id="double_butt_alpha3" name="double_butt_alpha3" <cfif isdefined("GET_SPECT.DOUBLE_BUTT_ALPHA_3")>value="<cfoutput>#TLformat(GET_SPECT.DOUBLE_BUTT_ALPHA_3)#</cfoutput>"</cfif>>                
        <span class="input-group-addon width">
            <select>
                <option value = "1">*</option>
            </select>
        </span>
    </div>
    </div>
    </div>
    </div>
    <div class="col col-3 col-md-3 col-xs-12">
    <label>&nbsp;&nbsp;<cf_get_lang dictionary_id="65131.Alfa">4 (a4)</label>        
    <div class="form-group" id="item-assetp_dorse_id">
    <div class="col col-12 col-md-12 col-xs-12">
    <div class="input-group">         
        <input type="text"  class="form-control calcFieldDouble" id="double_butt_alpha4" name="double_butt_alpha4" <cfif isdefined("GET_SPECT.DOUBLE_BUTT_ALPHA_4")>value="<cfoutput>#TLformat(GET_SPECT.DOUBLE_BUTT_ALPHA_4)#</cfoutput>"</cfif>>                    
        <span class="input-group-addon width">
            <select>
                <option value = "1">*</option>
            </select>
        </span>
    </div>
    </div>
    </div>
    </div>
    <div class="col col-3 col-md-3 col-xs-12">
    <label>&nbsp;&nbsp;<cf_get_lang dictionary_id="65122.Malzeme Yoğunluğu"></label>        
    <div class="form-group" id="item-assetp_dorse_id">
    <div class="col col-12 col-md-12 col-xs-12">
    <div class="input-group">         
        <select value="" id="double_butt_steel_density" class="form-control calcFieldDouble" name="double_butt_steel_density">
            <option value=""><cf_get_lang dictionary_id="57734.seçiniz"></option>
                <option value="2,73" <cfif isdefined("GET_SPECT.double_butt_steel_density") and GET_SPECT.double_butt_steel_density eq 2.73>selected</cfif>>2.73 <cf_get_lang dictionary_id="65123.Alüminyum"></option>
                <option value="7,85" <cfif isdefined("GET_SPECT.double_butt_steel_density") and GET_SPECT.double_butt_steel_density eq 7.85>selected</cfif>>7.85 <cf_get_lang dictionary_id="65124.Karbon Çelik"></option>
                <option value="7,9" <cfif isdefined("GET_SPECT.double_butt_steel_density") and GET_SPECT.double_butt_steel_density eq 7.9>selected</cfif>>7.9 <cf_get_lang dictionary_id="65125.Paslanmaz Çelik"></option>
                <option value="8,96" <cfif isdefined("GET_SPECT.double_butt_steel_density") and GET_SPECT.double_butt_steel_density eq 8.96>selected</cfif>>8.96 <cf_get_lang dictionary_id="65126.Bakır"></option>
            </select>           
            <span class="input-group-addon width">
            <select>
                <option value = "1">kg/m3</option>
            </select>
        </span>
    </div>
    </div>
    </div>
    </div>
    <div class="col col-9 col-md-9 col-xs-12">
    </div>
    </div>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12" id="shape_4" style="display:none;">
    <div class="col col-3 col-md-3 col-xs-12">
    <label>&nbsp;&nbsp;<cf_get_lang dictionary_id="65128.Boğaz Kalınlığı">(a)</label>        
    <div class="form-group" id="item-assetp_dorse_id">
        <div class="col col-12 col-md-12 col-xs-12">
        <div class="input-group">         
            <input type="text"  class="form-control calcFieldFillet" id="fillet_butt_sheet_thickness" name="fillet_butt_sheet_thickness" <cfif isdefined("GET_SPECT.FILLET_BUTT_SHEET_THICKNESS")> value="<cfoutput>#TLformat(GET_SPECT.FILLET_BUTT_SHEET_THICKNESS)#</cfoutput>"</cfif>>          
                <span class="input-group-addon width">
                <select>
                    <option value = "1">mm</option>
                </select>
            </span>
        </div>
    </div>
    </div>
    </div>
    <div class="col col-3 col-md-3 col-xs-12">
    <label>&nbsp;&nbsp;<cf_get_lang dictionary_id="65120.Kaynak Uzunluğu"></label>        
    <div class="form-group" id="item-assetp_dorse_id">
        <div class="col col-12 col-md-12 col-xs-12">
        <div class="input-group">         
            <input type="text"  class="form-control calcFieldFillet" id="fillet_butt_seam_length" name="fillet_butt_seam_length" <cfif isdefined("GET_SPECT.FILLET_BUTT_SEAM_LENGTH")> value="<cfoutput>#TLformat(GET_SPECT.FILLET_BUTT_SEAM_LENGTH)#</cfoutput>"</cfif>>
            <span class="input-group-addon width">
                <select>
                    <option value = "1">m</option>
                </select>
            </span>
        </div>
    </div>
    </div>
    </div>
    <div class="col col-3 col-md-3 col-xs-12">
    <label>&nbsp;&nbsp;<cf_get_lang dictionary_id="65119.Kapak Yüksekliği">(c)</label>        
    <div class="form-group" id="item-assetp_dorse_id">
        <div class="col col-12 col-md-12 col-xs-12">
        <div class="input-group">         
            <select id="fillet_butt_cap" class="form-control calcFieldFillet" name="fillet_butt_cap">
                <option value=""><cf_get_lang dictionary_id="57734.seçiniz"></option>
                <option value="0" <cfif isdefined("GET_SPECT.fillet_butt_cap") and GET_SPECT.fillet_butt_cap eq 0>selected</cfif>>0</option>
                <option value="1" <cfif isdefined("GET_SPECT.fillet_butt_cap") and GET_SPECT.fillet_butt_cap eq 1>selected</cfif>>1</option>
                <option value="2" <cfif isdefined("GET_SPECT.fillet_butt_cap") and GET_SPECT.fillet_butt_cap eq 2>selected</cfif>>2</option>
                <option value="3" <cfif isdefined("GET_SPECT.fillet_butt_cap") and GET_SPECT.fillet_butt_cap eq 3>selected</cfif>>3</option>
                <option value="4" <cfif isdefined("GET_SPECT.fillet_butt_cap") and GET_SPECT.fillet_butt_cap eq 4>selected</cfif>>4</option>
                <option value="5" <cfif isdefined("GET_SPECT.fillet_butt_cap") and GET_SPECT.fillet_butt_cap eq 5>selected</cfif>>5</option>
                </select>                <span class="input-group-addon width">
                <select>
                    <option value = "1">mm</option>
                </select>
            </span>
        </div>
    </div>
    </div>
    </div>
    <div class="col col-3 col-md-3 col-xs-12">
    <label>&nbsp;&nbsp;<cf_get_lang dictionary_id="65122.Malzeme Yoğunluğu"></label>        
    <div class="form-group" id="item-assetp_dorse_id">
        <div class="col col-12 col-md-12 col-xs-12">
        <div class="input-group">         
            <select value="" id="fillet_butt_steel_density"  name="fillet_butt_steel_density">
                <option value=""><cf_get_lang dictionary_id="57734.seçiniz"></option>
                    <option value="2,73" <cfif isdefined("GET_SPECT.fillet_butt_steel_density") and GET_SPECT.fillet_butt_steel_density eq 2.73>selected</cfif>>2.73 <cf_get_lang dictionary_id="65123.Alüminyum"></option>
                    <option value="7,85" <cfif isdefined("GET_SPECT.fillet_butt_steel_density") and GET_SPECT.fillet_butt_steel_density eq 7.85>selected</cfif>>7.85 <cf_get_lang dictionary_id="65124.Karbon Çelik"></option>
                    <option value="7,9" <cfif isdefined("GET_SPECT.fillet_butt_steel_density") and GET_SPECT.fillet_butt_steel_density eq 7.9>selected</cfif>>7.9 <cf_get_lang dictionary_id="65125.Paslanmaz Çelik"></option>
                    <option value="8,96" <cfif isdefined("GET_SPECT.fillet_butt_steel_density") and GET_SPECT.fillet_butt_steel_density eq 8.96>selected</cfif>>8.96 <cf_get_lang dictionary_id="65126.Bakır"></option>
                </select>
                <span class="input-group-addon width">
                <select>
                    <option value = "1">kg/m3</option>
                </select>
            </span>
        </div>
    </div>
    </div>
    </div>
    </div>
    <div class="col col-12 col-md-12 col-xs-12">
    <div class="col col-3 col-md-3 col-xs-12">
    <label>&nbsp;&nbsp;<cf_get_lang dictionary_id="65127.Dikiş Ağırlığı"></label>        
    <div class="form-group" id="item-assetp_dorse_id">
    <div class="col col-12 col-md-12 col-xs-12">
    <div class="input-group">         
        <input type="text"  class="form-control calcFieldFillet" id="butt_seam" name="butt_seam">
            <span class="input-group-addon width">
            <select>
                <option value = "1">kg</option>
            </select>
        </span>
    </div>
    </div>
    </div>
    </div>
    <div class="col col-3 col-md-3 col-xs-12">
    <label>&nbsp;&nbsp;<cf_get_lang dictionary_id="30114.Hacim"></label>        
    <div class="form-group" id="item-assetp_dorse_id">
    <div class="col col-12 col-md-12 col-xs-12">
    <div class="input-group">         
        <input type="text"  class="form-control calcFieldFillet" id="Volume" name="Volume">
            <span class="input-group-addon width">
            <select>
                <option value = "1">cm3</option>
            </select>
        </span>
    </div>
    </div>
    </div>
    </div>
    <div class="col col-6 col-md-6 col-xs-12">
    </div>
    </div>
    &nbsp;&nbsp;
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <div class="col col-3 col-md-3 col-xs-12">
    <div class="form-group">
    <div class="col col-6 col-md-6 col-xs-12">
        <a href="javascript://"  class="ui-btn ui-btn-success"  id="single_butt_calc" onclick="calculateButt()"><cf_get_lang dictionary_id="58998.Hesapla"></a>
    </div>
    </div>
    </div>
    </div>
    </div>
    </div>
        <script>
            var m=Math,pow2=function(x){return m.pow(x,2);},sqrt=m.sqrt,mathPI=m.PI,pInt=function(x){return parseInt(x,10)},pFloat=function(x){return parseFloat(x,10)},deg2rad=mathPI*2/360;
    function calculateButt(){var isAllFilled=false;var temp={alpha1:0,alpha2:0,alpha3:0,alpha4:0,grooveDepth:0,depthRootFace:0};var x={th:filterNum($("#butt_sheet_thickness").val())/10,l:filterNum($("#butt_seam_length").val())*100,c:filterNum($("#butt_cap").val())/10,p:filterNum($('#butt_penetration').val())/10,o:filterNum($('#butt_overlap').val())/10,a1:temp.alpha1*deg2rad,a2:temp.alpha2*deg2rad,a3:temp.alpha3*deg2rad,a4:temp.alpha4*deg2rad,d1:temp.grooveDepth/10,r:temp.depthRootFace/10,g:filterNum($('#butt_root_gap').val())/10,density:filterNum($('#butt_steel_density').val())/1000,area:null,volume:null};$('.calcField').each(function(i,val){if($(this).val().length<1){isAllFilled=false;$('#butt_calc').attr('disabled','');return false;}else{isAllFilled=true;}});var alan=x.th*x.g+4/3*(x.o+x.g/2)*x.c+2/3*x.g*x.p;var volume=alan*x.l;var seamWeight=volume*x.density;if(isAllFilled&&!isNaN(volume)&&!isNaN(seamWeight)){$('#butt_calc').removeAttr('disabled');$('#butt_seam').val(commaSplit(parseFloat(seamWeight).toFixed(2)));$('#Volume').val(commaSplit(parseFloat(volume).toFixed(2)));}}
    function calculateSingleButt(){var isAllFilled=false;var temp={alpha1:filterNum($('#single_butt_alpha1').val()),alpha2:filterNum($('#single_butt_alpha2').val()),alpha3:0,alpha4:0,grooveDepth:0,};var x={th:filterNum($("#single_butt_sheet_thickness").val())/10,l:filterNum($("#single_butt_seam_length").val())*100,c:filterNum($("#single_butt_cap").val())/10,p:filterNum($('#single_butt_penetration').val())/10,o:filterNum($('#single_butt_overlap').val())/10,a1:temp.alpha1*deg2rad,a2:temp.alpha2*deg2rad,a3:temp.alpha3*deg2rad,a4:temp.alpha4*deg2rad,d1:temp.grooveDepth/10,r:$('#single_butt_depth_of_root_face').val()/10,g:filterNum($('#single_butt_root_gap').val())/10,density:filterNum($('#single_butt_steel_density').val())/1000,area:null,volume:null};$('.calcFieldSingle').each(function(i,val){if($(this).val().length<1){isAllFilled=false;$('#sinlge_butt_calc').attr('disabled','');return false;}else{isAllFilled=true;}});var alan=x.th*x.g+
    pow2(x.th-x.r)*Math.tan(x.a1)/2+
    pow2(x.th-x.r)*Math.tan(x.a2)/2+
    2/3*x.c*(x.o+x.g/2+(x.th-x.r)*Math.tan(x.a1))+
    2/3*x.c*(x.o+x.g/2+(x.th-x.r)*Math.tan(x.a2));var volume=alan*x.l;var seamWeight=volume*x.density;if(isAllFilled&&!isNaN(volume)&&!isNaN(seamWeight)){$('#single_butt_calc').removeAttr('disabled');$('#butt_seam').val(commaSplit(parseFloat(seamWeight).toFixed(2)));$('#Volume').val(commaSplit(parseFloat(volume).toFixed(2)));}}
    function calculateDoubleButt(){var isAllFilled=false;var x={th:filterNum($("#double_butt_sheet_thickness").val())/10,l:filterNum($("#double_butt_seam_length").val())*100,c:filterNum($("#double_butt_cap").val())/10,p:filterNum($("#double_butt_cap_2").val())/10,o:$('#double_butt_overlap').val()/10,a1:filterNum($('#double_butt_alpha1').val())*deg2rad,a2:filterNum($('#double_butt_alpha2').val())*deg2rad,a3:filterNum($('#double_butt_alpha3').val())*deg2rad,a4:filterNum($('#double_butt_alpha4').val())*deg2rad,d1:filterNum($('#double_butt_seam_groove').val())/10,r:$('#double_butt_depth_of_root_face').val()/10,g:$('#double_butt_root_gap').val()/10,density:filterNum($('#double_butt_steel_density').val())/1000,area:null,volume:null};$('.calcFieldDouble').each(function(i,val){if($(this).val().length<1){isAllFilled=false;$('#double_butt_calc').attr('disabled','');return false;}else{isAllFilled=true;}});var alan=x.th*x.g+
    pow2(x.d1)*Math.tan(x.a1)/2+
    pow2(x.d1)*Math.tan(x.a2)/2+
    pow2(x.th-x.d1-x.r)*Math.tan(x.a3)/2+
    pow2(x.th-x.d1-x.r)*Math.tan(x.a4)/2+
    2/3*x.c*(x.o+x.g/2+x.d1*Math.tan(x.a2))+
    2/3*x.c*(x.o+x.g/2+x.d1*Math.tan(x.a1))+
    2/3*x.p*(x.o+x.g/2+(x.th-x.d1-x.r)*Math.tan(x.a1))+
    2/3*x.p*(x.o+x.g/2+(x.th-x.d1-x.r)*Math.tan(x.a2));var volume=alan*x.l;var seamWeight=volume*x.density;if(isAllFilled&&!isNaN(volume)&&!isNaN(seamWeight)){$('#double_butt_calc').removeAttr('disabled');$('#butt_seam').val(commaSplit(parseFloat(seamWeight).toFixed(2)));$('#Volume').val(commaSplit(parseFloat(volume).toFixed(2)));}}
    function calculateFilletButt(){ var isAllFilled=false;var x={l:filterNum($("#fillet_butt_seam_length").val())*100,c:filterNum($("#fillet_butt_cap").val())/10,g:filterNum($('#fillet_butt_sheet_thickness').val())/10,density:filterNum($('#fillet_butt_steel_density').val())/1000,area:null,volume:null};$('.calcFieldFillet').each(function(i,val){if($(this).val().length<1){}else{isAllFilled=true;}});var alan=pow2(x.g)+4/3*x.c*x.g;var volume=alan*x.l;var seamWeight=volume*x.density;if(isAllFilled&&!isNaN(volume)&&!isNaN(seamWeight)){$('#butt_seam').val(commaSplit(parseFloat(seamWeight).toFixed(2)));$('#Volume').val(commaSplit(parseFloat(volume).toFixed(2)));}}
    function change_shape1(){
        $('#Volume').val(commaSplit(0));
        $('#butt_seam').val(commaSplit(0));
        shape_1.style.display = 'block';shape_2.style.display = 'none';shape_3.style.display = 'none';shape_4.style.display = 'none';document.getElementById("single_butt_calc").onclick = calculateButt;
        shape1_.style.display='block';shape2_.style.display='none';shape3_.style.display='none';shape4_.style.display='none';
        $('#welding_id').val("1");
    }
    function change_shape2(){
        $('#Volume').val(commaSplit(0));
        $('#butt_seam').val(commaSplit(0));
        shape_1.style.display = 'none';shape_2.style.display = 'block';shape_3.style.display = 'none';shape_4.style.display = 'none';document.getElementById("single_butt_calc").onclick = calculateSingleButt;
        shape1_.style.display='none';shape2_.style.display='block';shape3_.style.display='none';shape4_.style.display='none';
        $('#welding_id').val("2");
    }
    function change_shape3(){
        $('#Volume').val(commaSplit(0));
        $('#butt_seam').val(commaSplit(0));
        shape_1.style.display = 'none';shape_2.style.display = 'none';shape_3.style.display = 'block';shape_4.style.display = 'none';document.getElementById("single_butt_calc").onclick = calculateDoubleButt;
        shape1_.style.display='none';shape2_.style.display='none';shape3_.style.display='block';shape4_.style.display='none';
        $('#welding_id').val("3");
    }
    function change_shape4(){
        $('#Volume').val(commaSplit(0));
        $('#butt_seam').val(commaSplit(0));
        shape_1.style.display = 'none';shape_2.style.display = 'none';shape_3.style.display = 'none';shape_4.style.display = 'block';document.getElementById("single_butt_calc").onclick = calculateFilletButt;
        shape1_.style.display='none';shape2_.style.display='none';shape3_.style.display='none';shape4_.style.display='block';
        $('#welding_id').val("4");
    }
    var lastindex=1;
    $(document).on("click","#shapes", function () {
      $('[id="shapes"]').attr("style", "border-color:#E6E6E6;");
      $(this).attr("style", "border-color:#909090;");
      lastindex=$(this).index();
    });
    $('[id="shapes"]').mouseover(function(){
    $(this).css("border-color", "#909090");
  });
  $('[id="shapes"]').mouseout(function(){
    $(this).css("border-color", "#E6E6E6");
    document.querySelectorAll("[id='shapes']")[lastindex-1].style.borderColor = "#909090";
  });
  
  <cfif (isDefined("attributes.stock_id")) or isDefined("GET_SPECT.WELDING_ID")>
                <cfif isdefined("GET_SPECT.WELDING_ID") and GET_SPECT.WELDING_ID eq 2>
                    change_shape2();lastindex=2;
                    document.querySelectorAll("[id='shapes']")[1].style.borderColor = "#909090";
                    calculateSingleButt();
                <cfelseif isdefined("GET_SPECT.WELDING_ID") and GET_SPECT.WELDING_ID eq 3>
                    change_shape3();lastindex=3;
                    document.querySelectorAll("[id='shapes']")[2].style.borderColor = "#909090";
                    calculateDoubleButt();
                <cfelseif isdefined("GET_SPECT.WELDING_ID") and GET_SPECT.WELDING_ID eq 4>
                    change_shape4();lastindex=4;
                    document.querySelectorAll("[id='shapes']")[3].style.borderColor = "#909090";
                    calculateFilletButt();
                <cfelse>
                    change_shape1();lastindex=1;
                    document.querySelectorAll("[id='shapes']")[0].style.borderColor = "#909090";
                    calculateButt();
                </cfif>
            </cfif>
        </script>
    </cfif>
</cf_box_elements>