<cfparam name="attributes.modal_id" default="">
<cfsavecontent variable="message"><cf_get_lang dictionary_id="56857.Çalışan Grubu"> <cf_get_lang dictionary_id="44630.Ekle"></cfsavecontent>
<cf_box title="#message#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform action="#request.self#?fuseaction=ehesap.emptypopup_add_puantaj_group" name="add_puantaj_group" method="post">
      <cf_box_elements>
        <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
            <div class="form-group require" id="item-process_stage">
              <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="58969.Grup Adı">*</label>
              <div class="col col-8 col-sm-12">
                  <cfsavecontent variable="message"><cf_get_lang dictionary_id="55459.Grup Adı Girmelisiniz"></cfsavecontent>
                  <cfinput type="text" name="group_name" id="group_name" style="width:200px;" required="yes" message="#message#" maxlength="75">
              </div>                
            </div> 
          </div>
        </cf_box_elements>
      <cf_box_footer><cf_workcube_buttons is_upd='0' add_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_puantaj_group' , #attributes.modal_id#)"),DE(""))#"></cf_box_footer>
    </cfform>
</cf_box>
