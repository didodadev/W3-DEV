<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
  <cfsavecontent variable="head"><cf_get_lang dictionary_id='42647.Etiket Şablonu'></cfsavecontent>
  <cf_box title="#head#" add_href="#request.self#?fuseaction=settings.form_add_sticker_template" is_blank="0">
      <div class="col col-2 col-md-3 col-sm-3 col-xs-12">
        <div class="scrollbar" style="max-height:403px;overflow:auto;">
            <div id="cc">
                <cfinclude template="../display/list_sticker_template.cfm">
            </div>
        </div>
      </div>
      <cfset attributes.STICKER_ID=#attributes.upd_id#>
      <cfinclude template="../query/get_sticker_temp.cfm">
      <cfform action="#request.self#?fuseaction=settings.popup_add_sticker_template&upd_id=1" method="post" name="asset_cat">
        <cf_box_elements>
          <input type="hidden" name="STICKER_ID" id="STICKER_ID" value="<cfoutput>#GET_STICKER.STICKER_ID#</cfoutput>">
          <div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
            <div class="form-group" id="block_group_name">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42542.Etiket Tür Adı'>*</label>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                    <cfinput type="Text" name="sticker_name" size="60" value="#GET_STICKER.STICKER_NAME#" maxlength="50" required="Yes" message="#getLang('','Etiket Tür Adı girmelisiniz',42281)#">
                </div>
            </div>
            <div class="form-group" id="block_group_name">
              <label class="col col-4 col-md-4 col-sm-4 col-xs-12"></label>
              <div class="col col-3 col-md-8 col-sm-8 col-xs-12"> 
                  <label style="text-align:center;"><cf_get_lang dictionary_id='29793.Dikey'></label>
              </div>
              <div class="col col-3 col-md-8 col-sm-8 col-xs-12"> 
                  <label style="text-align:center;"><cf_get_lang dictionary_id='29794.Yatay'></label>
              </div>
            </div>
            <div class="form-group" id="block_group_name">
              <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42543.Etiket Sayısı'></label>
              <div class="col col-3 col-md-3 col-sm-3 col-xs-12"> 
                <input name="ROW_NUMBER" id="ROW_NUMBER" type="text"  value="<cfoutput>#GET_STICKER.ROW_NUMBER#</cfoutput>">
              </div>
              <div class="col col-3 col-md-3 col-sm-3 col-xs-12"> 
                <input name="COLUMN_NUMBER" id="COLUMN_NUMBER" type="text" value="<cfoutput>#GET_STICKER.COLUMN_NUMBER#</cfoutput>">
              </div>
              <div class="col col-2 col-md-2 col-sm-2 col-xs-12"> 
                  (<cf_get_lang dictionary_id='58082.adet'>)
              </div>
            </div>
            <div class="form-group" id="block_group_name">
              <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42544.Etiket boyutları'></label>
              <div class="col col-3 col-md-8 col-sm-8 col-xs-12"> 
                <input name="STICKER_LENGTH" id="STICKER_LENGTH" type="text" value="<cfoutput>#GET_STICKER.STICKER_LENGTH#</cfoutput>">
              </div>
              <div class="col col-3 col-md-8 col-sm-8 col-xs-12"> 
                <input name="STICKER_WIDTH" id="STICKER_WIDTH" type="text" value="<cfoutput>#GET_STICKER.STICKER_WIDTH#</cfoutput>">
              </div>
              <div class="col col-2 col-md-2 col-sm-2 col-xs-12"> 
                  (<cf_get_lang dictionary_id='42549.mm'>)
              </div>
            </div>
            <div class="form-group" id="block_group_name">
              <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57603.Aralık'></label>
              <div class="col col-3 col-md-3 col-sm-3 col-xs-12"> 
                <input name="VERTICAL_GAP" id="VERTICAL_GAP" type="text" value="<cfoutput>#GET_STICKER.VERTICAL_GAP#</cfoutput>">
              </div>
              <div class="col col-3 col-md-3 col-sm-3 col-xs-12"> 
                <input name="HORIZONTAL_GAP" id="HORIZONTAL_GAP" type="text" value="<cfoutput>#GET_STICKER.HORIZONTAL_GAP#</cfoutput>">
              </div>
              <div class="col col-2 col-md-2 col-sm-2 col-xs-12"> 
                  (<cf_get_lang dictionary_id='42549.mm'>)
              </div>
            </div>
            <div class="form-group" id="block_group_name">
              <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43284.Sayfa Genişliği'></label>
              <div class="col col-3 col-md-3 col-sm-3 col-xs-12"> 
                <cfinput name="PAGE_HEIGHT" type="text" maxlength="4" validate="integer" message="#getLang('','Sayfa Yüksekliğini Giriniz',43285)#" value="#get_sticker.page_height#">
              </div>
              <div class="col col-3 col-md-3 col-sm-3 col-xs-12"> 
                <cfinput name="PAGE_WIDTH" type="text" maxlength="4" validate="integer" message="#getLang('','Sayfa Genişiğini Giriniz',43286)#" value="#get_sticker.page_width#">
              </div>
              <div class="col col-2 col-md-2 col-sm-2 col-xs-12"> 
                  (<cf_get_lang dictionary_id='42549.mm'>)
              </div>
            </div>
            <div class="form-group" id="block_group_name">
              <label class="col col-4 col-md-4 col-sm-4 col-xs-12"></label>
              <div class="col col-3 col-md-3 col-sm-3 col-xs-12"> 
                  <label style="text-align:center;"><cf_get_lang dictionary_id='43287.Sayfa Başı'></label>
              </div>
              <div class="col col-3 col-md-3 col-sm-3 col-xs-12"> 
                  <label style="text-align:center;"><cf_get_lang dictionary_id='43288.Sayfa Sonu'></label>
              </div>
            </div>
            <div class="form-group" id="block_group_name">
              <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43289.Sayfa Boşluğu'></label>
              <div class="col col-3 col-md-3 col-sm-3 col-xs-12"> 
                <cfinput name="PAGE_TOP_BLANK" type="text" maxlength="4" validate="integer" message="#getLang('','Sayfa Başı Boşluğunu Giriniz',43290)#" value="#get_sticker.page_top_blank#">
              </div>
              <div class="col col-3 col-md-3 col-sm-3 col-xs-12"> 
                <cfinput name="PAGE_FOT_BLANK" type="text" maxlength="4" validate="integer" message="#getLang('','Sayfa Sonu Boşluğunu Giriniz',43294)#" value="#get_sticker.page_fot_blank#">
              </div>
              <div class="col col-2 col-md-2 col-sm-2 col-xs-12"> 
                  (<cf_get_lang dictionary_id='42549.mm'>)
              </div>
            </div>
            <div class="form-group" id="block_group_name">
              <label class="col col-4 col-md-4 col-sm-4 col-xs-12"></label>
              <div class="col col-3 col-md-8 col-sm-8 col-xs-12"> 
                  <label style="text-align:center;"><cf_get_lang dictionary_id='43291.Sağ'></label>
              </div>
              <div class="col col-3 col-md-8 col-sm-8 col-xs-12"> 
                  <label style="text-align:center;"><cf_get_lang dictionary_id='43292.Sol'></label>
              </div>
            </div>
            <div class="form-group" id="block_group_name">
              <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43289.Sayfa Boşluğu'></label>
              <div class="col col-3 col-md-3 col-sm-3 col-xs-12"> 
                <cfinput name="PAGE_RIGHT_BLANK" type="text" maxlength="4" validate="integer" message="#getLang('','Sayfa Başı Boşluğunu Giriniz',43290)#" value="#get_sticker.page_right_blank#">
              </div>
              <div class="col col-3 col-md-3 col-sm-3 col-xs-12"> 
                <cfinput name="PAGE_LEFT_BLANK" type="text" maxlength="4" validate="integer" message="#getLang('','Sayfa Sonu Boşluğunu Giriniz',43294)#" value="#get_sticker.page_left_blank#">
              </div>
              <div class="col col-2 col-md-2 col-sm-2 col-xs-12"> 
                  (<cf_get_lang dictionary_id='42549.mm'>)
              </div>
            </div>
            <div class="form-group" id="block_group_name">
              <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='43893.Yetkili Görünsün'></label>
              <div class="col col-4 col-md-8 col-sm-8 col-xs-12"> 
                <input name="partner" id="partner" type="checkbox" value="1" <cfif get_sticker.partner eq 1>checked</cfif>>
              </div>
            </div>
          </div>
        </cf_box_elements>
        <cf_box_footer>
          <div class="col col-6">
            <cf_record_info query_name="GET_STICKER">
          </div>
          <div class="col col-6">
            <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.popup_add_sticker_template&del_id=#GET_STICKER.STICKER_ID#'>
          </div>
        </cf_box_footer>
      </cfform>
  </cf_box>
</div>


