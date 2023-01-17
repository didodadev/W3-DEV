<cfsavecontent variable="header"><cf_get_lang dictionary_id='42904.Markalar'></cfsavecontent>
<cf_box title="#header#">
    <cfform name="upd_brand" method="post"  action="#request.self#?fuseaction=settings.emptypopup_add_brand">        
        <input type="hidden" name="brand_id" id="brand_id" value="">
        <cf_box_elements>
            <div class="col col-3 col-xs-12">
                <div class="scrollbar" style="max-height:403px;overflow:auto;">
                    <div id="cc">
                        <cfinclude template="../display/list_brand.cfm">
                    </div>
                </div>
            </div>
            <div class="col col-4 col-xs-12">	
                <div class="form-group" id="item-brand_name">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58847.Marka Adı'>*</label>
                    <div class="col col-8 col-xs-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='42786.Marka Girmelisiniz'>!</cfsavecontent>
                        <cfinput type="text" name="brand_name" value="" maxlength="50" required="yes" message="#message#">
                    </div>
                </div>           
                <div class="form-group" id="item-it_asset">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="42310.IT Varlıkları"></label>
                    <div class="col col-8 col-xs-12">
                        <input type="checkbox" name="it_asset" id="it_asset" value="1">
                    </div>
                </div>
                <div class="form-group" id="item-motorized_vehicle">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='42311.Motorlu Taşıt'></label>
                    <div class="col col-8 col-xs-12">
                        <input type="checkbox" name="motorized_vehicle" id="motorized_vehicle" value="1">
                    </div>
                </div>
                <div class="form-group" id="item-physical_asset">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58833.Fiziki Varlık"></label>
                    <div class="col col-8 col-xs-12">
                        <input type="checkbox" name="physical_asset" id="physical_asset" value="1">
                    </div>
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <cf_workcube_buttons is_upd='0' add_function='control()'>
        </cf_box_footer>
    </cfform>  
</cf_box>
<script type="text/javascript">
function control()
{
	if ((document.upd_brand.it_asset.checked) && (document.upd_brand.motorized_vehicle.checked))
	{  
		alert("<cf_get_lang no='830.Aynı Anda İki Kategoriyi Seçemezsiniz'>!");
		document.upd_brand.it_asset.checked = false;
		document.upd_brand.motorized_vehicle.checked = false;
		document.upd_brand.it_asset.focus();
		return false;
	}
	return true;
}
</script>
