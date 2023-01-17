<cfsavecontent variable="header"><cf_get_lang dictionary_id='42930..Marka Tipi Ekle'></cfsavecontent>
<cf_box title="#header#">
    <cfform name="add_brand_type" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_brand_type">
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
                            <input type="hidden" name="brand_id" id="brand_id" value="">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='42786.Marka Girmelisiniz'>!</cfsavecontent>
                            <cfinput type="text" name="brand_name" value="" maxlength="50" required="yes" message="#message#">
                            <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_brand&field_id=add_brand_type.brand_id&field_name=add_brand_type.brand_name','medium','popup_list_brand');"></span>
                        </div>
                    </div>
                </div>  
                <div class="form-group" id="item-brand_name">
                    <label class="col col-4 col-xs-12"><cf_get_lang_main no='2244.Marka Tip Adı'> *</label>
                    <div class="col col-8 col-xs-12">
                        <cfsavecontent variable="message"><cf_get_lang no='885.Marka Tip Adı Girmelisiniz'> !</cfsavecontent>
                        <cfinput type="text" name="brand_type_name" value="" maxlength="50" required="yes" message="#message#">
                    </div>
                </div>                                
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
		if(document.add_brand_type.brand_id.value == "")
		{
			alert("<cf_get_lang no='803.Marka Seçmelisiniz'> !");
			return false;
		}	
		return true;	
	}
	
	
	/*	function sec()
		{
			add_brand_type.brand_id.value = add_brand_type.brand.options[add_brand_type.brand.options.selectedIndex].value;
			add_brand_type.action = '<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>';
			add_brand_type.submit();		
		}*/
		/*function submit_et()
		{
			add_brand_type.action = '<cfoutput>#request.self#?fuseaction=settings.emptypopup_add_brand_type_type</cfoutput>';
		}*/
</script>

