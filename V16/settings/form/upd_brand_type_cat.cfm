<cf_xml_page_edit fuseact="settings.add_brand_type_cat" is_multi_page="1">
<cfquery name="GET_BRAND_TYPE_CAT" datasource="#dsn#">
	SELECT
		SETUP_BRAND_TYPE_CAT.*,
		SETUP_BRAND_TYPE.BRAND_TYPE_NAME,
		SETUP_BRAND.BRAND_NAME
	FROM
		SETUP_BRAND_TYPE_CAT,
		SETUP_BRAND_TYPE,
		SETUP_BRAND
	WHERE
		SETUP_BRAND_TYPE_CAT.BRAND_TYPE_CAT_ID = #attributes.brand_type_cat_id# AND
		SETUP_BRAND_TYPE_CAT.BRAND_TYPE_ID = SETUP_BRAND_TYPE.BRAND_TYPE_ID AND				
		SETUP_BRAND_TYPE.BRAND_ID = SETUP_BRAND.BRAND_ID
</cfquery>
<cfsavecontent variable="header"><cf_get_lang no='873.Marka Tip Kategorisi Güncelle'></cfsavecontent>
<cf_box title="#header#" add_href="#request.self#?fuseaction=settings.add_brand_type_cat">
  <cfform name="upd_brand_type_cat" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_brand_type_cat">
    <input type="hidden" name="brand_type_cat_id" id="brand_type_cat_id" value="<cfoutput>#attributes.brand_type_cat_id#</cfoutput>">
    <cf_box_elements>
            <div class="col col-3 col-xs-12">
                <div class="scrollbar" style="max-height:403px;overflow:auto;">
                    <div id="cc">
                        <cfinclude template="../display/list_brand_type_cat.cfm">
                    </div>
                </div>
            </div>
            <div class="col col-4 col-xs-12">
              <div class="form-group">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30041.Marka Tipi'>*</label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="brand_id" id="brand_id" value="<cfoutput>#get_brand_type_cat.brand_id#</cfoutput>">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='42786.Marka Girmelisiniz'>!</cfsavecontent>
                            <input type="hidden" name="brand_type_id" id="brand_type_id" value="<cfoutput>#get_brand_type_cat.brand_type_id#</cfoutput>">
                            <input type="text" name="brand_type_name" id="brand_type_name" value="<cfoutput>#get_brand_type_cat.brand_name# - #get_brand_type_cat.brand_type_name#</cfoutput>" readonly style="width:175px;">
                            <span class="input-group-addon icon-ellipsis" href="javascript://"  onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_brand_type&field_brand_id=upd_brand_type_cat.brand_id&field_brand_type_id=upd_brand_type_cat.brand_type_id&field_brand_name=upd_brand_type_cat.brand_type_name&cat_id=#brand_type_cat_id#&select_list=4</cfoutput>','medium','popup_list_brand');"></span>
                        </div>
                    </div>
                </div> 
                <div class="form-group">
                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='2243.Marka Tip Kategorisi'> *</label>
                    <div class="col col-8 col-xs-12">
                      <div class="input-group large">
                        <cfinput type="text" name="brand_type_cat_name" value="#get_brand_type_cat.brand_type_cat_name#" maxlength="50" required="yes" message="#message#" style="width:175px;">
                        <span class="input-group-addon">
                          <cf_language_info
                            table_name="SETUP_BRAND_TYPE_CAT"
                            column_name="BRAND_TYPE_CAT_NAME" 
                            column_id_value="#attributes.brand_type_cat_id#" 
                            maxlength="500" 
                            datasource="#dsn#" 
                            column_id="BRAND_TYPE_CAT_ID" 
                            control_type="0">
                        </span>
                      </div>
                    </div>
                </div>
                <cfif isdefined('is_brand_type_cat_specialty') and is_brand_type_cat_specialty eq 1>
                    <cfsavecontent  variable="head"><cf_get_lang_main no='1498.Özellikler'></cfsavecontent>
                    <cf_seperator title="#head#" id="link">
                      <div id="link">
                          <cf_grid_list>
                              <tr>
                                  <td><cf_get_lang no='2843.Loa'></td>
                                  <td><cf_get_lang no='2844.Beam'></td>
                                  <td><cf_get_lang no='2845.Draught'></td>
                                  <td><cf_get_lang no='2846.Net Ton'></td>
                              </tr>
                              <tr>
                                  <td><input type="text" name="type_cat_height" id="type_cat_height" value="<cfoutput>#TLFormat(get_brand_type_cat.BRAND_TYPE_CAT_HEIGHT)#</cfoutput>" style="width:40px;" onkeyup="FormatCurrency(this,event);"></td>
                                  <td><input type="text" name="type_cat_width" id="type_cat_width" value="<cfoutput>#TLFormat(get_brand_type_cat.BRAND_TYPE_CAT_WIDTH)#</cfoutput>" style="width:40px;" onkeyup="FormatCurrency(this,event);"></td>
                                  <td><input type="text" name="type_cat_depth" id="type_cat_depth" value="<cfoutput>#TLFormat(get_brand_type_cat.BRAND_TYPE_CAT_DEPTH)#</cfoutput>" style="width:40px;" onkeyup="FormatCurrency(this,event);"></td>
                                  <td><input type="text" name="type_cat_weight" id="type_cat_weight" value="<cfoutput>#TLFormat(get_brand_type_cat.BRAND_TYPE_CAT_WEIGHT)#</cfoutput>" style="width:40px;" onkeyup="FormatCurrency(this,event);"></td>
                              </tr>
                          </cf_grid_list>
                        </div>
                </cfif>
            </div>
    </cf_box_elements>
    <cf_box_footer>
      <div class="col col-6 col-xs-12">
          <cf_record_info query_name="get_brand_type_cat">
      </div>
      <div class="col col-6 col-xs-12">
          <cf_workcube_buttons is_upd='1' is_delete='0'>
      </div>
    </cf_box_footer>   
  </cfform>
</cf_box>
  
