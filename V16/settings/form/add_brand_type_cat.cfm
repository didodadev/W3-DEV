<cf_xml_page_edit fuseact="settings.add_brand_type_cat" is_multi_page="1">
<cfsavecontent variable="header"><cf_get_lang no='849.Marka Tip Kategorisi Ekle'></cfsavecontent>
    <cf_box title="#header#">
        <cfform name="add_brand_type_cat" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_brand_type_cat">
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
                                <input type="hidden" name="brand_id" id="brand_id" value="">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='42786.Marka Girmelisiniz'>!</cfsavecontent>
                                <input type="hidden" name="brand_type_id" id="brand_type_id" value="">
                                <input type="text" name="brand_type_name" id="brand_type_name" value="" readonly>
                                <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_brand_type&field_brand_id=add_brand_type_cat.brand_id&field_brand_type_id=add_brand_type_cat.brand_type_id&field_brand_name=add_brand_type_cat.brand_type_name&select_list=4','medium','popup_list_brand');"></span>
                            </div>
                        </div>
                    </div> 
                    <div class="form-group">
                        <label class="col col-4 col-xs-12"><cf_get_lang_main no='2243.Marka Tip Kategorisi'> *</label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang no='885.Marka Tip Kategorisi Girmelisiniz'> !</cfsavecontent>
                            <cfinput type="text" name="brand_type_cat_name" maxlength="50" required="yes" message="#message#">
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
                                    <td><input type="text" name="type_cat_height" id="type_cat_height" value="" style="width:40px;" onkeyup="FormatCurrency(this,event);"></td>
                                    <td><input type="text" name="type_cat_width" id="type_cat_width" value="" style="width:40px;" onkeyup="FormatCurrency(this,event);"></td>
                                    <td><input type="text" name="type_cat_depth" id="type_cat_depth" value="" style="width:40px;" onkeyup="FormatCurrency(this,event);"></td>
                                    <td><input type="text" name="type_cat_weight" id="type_cat_weight" value="" style="width:40px;" onkeyup="FormatCurrency(this,event);"></td>
                                </tr>
                            </cf_grid_list>
                        </div>
                    </cfif>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0' is_reset='0' add_function='kontrol()'>
            </cf_box_footer>
        </cfform>
    </cf_box>
<script type="text/javascript">
	function kontrol()
	{
		if(document.add_brand_type_cat.brand_type_id.value == "")
		{
			alert("<cf_get_lang no='885.Marka Tipi Seçmelisiniz'> !");
			return false;
		}	
		return true;	
	}
</script>
