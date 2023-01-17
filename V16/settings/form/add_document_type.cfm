<div class="col col-12 col-xs-12">
        <cf_box title="#getLang('','settings',42870)#" add_href="#request.self#?fuseaction=settings.form_add_document_type"><!--- Belge tipleri --->
          <cfform name="add_document_type" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_document_type">
            <cf_box_elements>	
              <div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="1" sort="true">
                <cfinclude template="../display/list_document_type.cfm">
              </div>
              <div class="col col-9 col-md-9 col-sm-9 col-xs-12" type="column" index="2" sort="true">
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                  <div class="form-group" id="item-time_cost_cat">
                    <label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='43282.Belge Adı'> *</label>
                    <div class="col col-8 col-md-6 col-xs-12">
                      <cfsavecontent variable="message"><cf_get_lang dictionary_id='43283.Belge Adı Girmelisiniz'> !</cfsavecontent>
                        <cfinput type="text" name="document_name" maxlength="100" required="yes" message="#message#" style="width:250px;">
                    </div>
                  </div>
                  <div class="form-group" id="item-time_cost_cat">
                    <label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='52734.Wo'>-<cf_get_lang dictionary_id='40574.FuseAction'></label>
                    <div class="col col-8 col-md-6 col-xs-12">
                      <div class="input-group">
                      <textarea name="module_field_name" style="width:250px;height:60px;" id="module_field_name" ><!--- <cfif len(get_process.faction)><cfoutput>#get_process.faction#</cfoutput></cfif> ---></textarea>
                      <span class="input-group-addon icon-pluss btnPointer" onclick="gonder();"></span>                    
                      </div>
                    </div>
                  </div>
                  <div class="form-group" id="item-time_cost_cat">
                    <label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main dictionary_id='57629.Açıklama'></label>
                    <div class="col col-8 col-md-6 col-xs-12">
                      <textarea name="detail" id="detail" style="width:250px;height:60px;" maxlength="250" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" ></textarea>                
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
      </div>
<script type="text/javascript">
function gonder()
{
	if(add_document_type.module_field_name.value=="")
	{
		windowopen('<cfoutput>#request.self#?fuseaction=settings.popup_dsp_faction_list&field_name=add_document_type.module_field_name&is_upd=0</cfoutput>','list');
	}
	else
	{
		windowopen('<cfoutput>#request.self#?fuseaction=settings.popup_dsp_faction_list&field_name=add_document_type.module_field_name&is_upd=1</cfoutput>','list');
	}
}
function kontrol()
	{
		if(document.getElementById("document_name").value == '')
		{
			alert('<cf_get_lang dictionary_id='43283.Belge Adı Girmelisiniz'> !')
			return false;
		}
	}
</script>
