    <cf_box title="#getLang('','settings',42167)#"<!--- Öncelik Kategorileri---> add_href="#request.self#?fuseaction=settings.form_add_priority">
          <cfform name="priority" method="post" action="#request.self#?fuseaction=settings.emptypopup_priority_add">
            <cf_box_elements>	
             <div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="1" sort="true">
          <cfinclude template="../display/list_priority.cfm">
             </div>
              <div class="col col-9 col-md-9 col-sm-9 col-xs-12" type="column" index="2" sort="true">
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                  <div class="form-group" id="item-priority">
                    <label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='42457.Öncelik Tipi'>*</label>
                    <div class="col col-8 col-md-6 col-xs-12">
                      <cfsavecontent variable="message"><cf_get_lang dictionary_id='42005.Öncelik Tipi girmelisiniz'></cfsavecontent>
                        <cfinput type="Text" id="priority" name="priority" value="" maxlength="20" required="Yes" message="#message#">
                    </div>
                  </div>
                  <div class="form-group" id="item-colour">
                    <label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='42324.Kategori Rengi'></label>
                    <div class="col col-8 col-md-6 col-xs-12">
                      <cf_workcube_color_picker name="colourp" id="colourp" value="" width="200">
                    </div>
                  </div>
                </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
            <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
          </cf_box_footer>
          </cfform>
    </cf_box>

   