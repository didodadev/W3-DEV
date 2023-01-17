<cfquery name="GET_BRAND_TYPE" datasource="#dsn#">
	SELECT
		SETUP_BRAND_TYPE.BRAND_TYPE_ID,
		SETUP_BRAND_TYPE.BRAND_ID,
		SETUP_BRAND.BRAND_NAME,
		SETUP_BRAND_TYPE.BRAND_TYPE_NAME,
		SETUP_BRAND_TYPE.RECORD_DATE,
		SETUP_BRAND_TYPE.RECORD_EMP,
		SETUP_BRAND_TYPE.RECORD_IP,
		SETUP_BRAND_TYPE.UPDATE_DATE,
		SETUP_BRAND_TYPE.UPDATE_EMP,
		SETUP_BRAND_TYPE.UPDATE_IP
	FROM
		SETUP_BRAND_TYPE,
		SETUP_BRAND
	WHERE
		SETUP_BRAND_TYPE.BRAND_TYPE_ID = #attributes.brand_type_id# AND
		SETUP_BRAND_TYPE.BRAND_ID = SETUP_BRAND.BRAND_ID
</cfquery>
<cfsavecontent variable="header"><cf_get_lang dictionary_id='42211.Marka Tipi Güncelle'></cfsavecontent>
<div class="col col-12 col-xs-12">
  <cf_box title="#header#" add_href="#request.self#?fuseaction=settings.add_brand_type">
    <cfform name="upd_brand_type" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_brand_type">
      <cf_box_elements>
          <div class="col col-3 col-xs-12">
              <div class="scrollbar" style="max-height:403px;overflow:auto;">
                  <div id="cc">
                    <cfinclude template="../display/list_brand_type.cfm">
                  </div>
              </div>
          </div>
          <div class="col col-4 col-xs-12">	
            <div class="form-group" id="item-brand_name">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58847.Marka Adı'>*</label>
                <div class="col col-8 col-xs-12">                          
                    <div class="input-group">
                      <input type="hidden" name="brand_id" id="brand_id" value="<cfoutput>#get_brand_type.brand_id#</cfoutput>">
                      <input type="hidden" name="brand_type_id" id="brand_type_id" value="<cfoutput>#attributes.brand_type_id#</cfoutput>">
                      <input type="text" name="brand_name" id="brand_name" value="<cfoutput>#get_brand_type.brand_name#</cfoutput>" readonly>
                      <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_brand&field_id=upd_brand_type.brand_id&field_name=upd_brand_type.brand_name','medium','popup_list_brand');"></span>
                    </div>
                </div>
            </div>           
            <div class="form-group" id="item-brand_name">
                <label class="col col-4 col-xs-12"><cf_get_lang_main no='2244.Marka Tip Adı'> *</label>
                <div class="col col-8 col-xs-12">
                    <div class="input-group large">
                      <cfsavecontent variable="message"><cf_get_lang_main no='1143.Kategori Adı Girmelisiniz'> !</cfsavecontent>
                        <cfinput type="text" name="brand_type_name" value="#get_brand_type.brand_type_name#" maxlength="50" required="yes" message="#message#">
                        <span class="input-group-addon">
                        <cf_language_info 
                          table_name="SETUP_BRAND_TYPE" 
                          column_name="BRAND_TYPE_NAME" 
                          column_id_value="#attributes.brand_type_id#" 
                          maxlength="500" 
                          datasource="#dsn#" 
                          column_id="BRAND_TYPE_ID" 
                          control_type="0">
                        </span>
                    </div>
                </div>
            </div>    
          </div>
      </cf_box_elements>
      <cf_box_footer>
          <div class="col col-6 col-xs-12">
              <cf_record_info query_name="get_brand_type">
          </div>
          <div class="col col-6 col-xs-12">
              <cf_workcube_buttons is_upd='1' is_delete='0'>
          </div>
      </cf_box_footer>   
    </cfform>
  </cf_box>
</div>