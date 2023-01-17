<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="54253.Gider Kalemi Kategorisi Ekle"></cfsavecontent>
    <cf_box title="#message#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="add_expense_cat" method="post" action='#request.self#?fuseaction=ehesap.emptypopup_add_expense_cat#iif(isdefined("attributes.draggable"),DE("&draggable=1"),DE(""))#'>
            <cf_box_elements>
                <div class="col col-6 col-md-6 col-sm-12 col-xs-12">
                    <div class="form-group">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'> *</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="text" name="expense_cat_name" id="expense_cat_name" maxlength="50">
                        </div>                            
                    </div>
                    <div class="form-group">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <textarea name="expense_cat_detail" id="expense_cat_detail" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);"></textarea>
                        </div>
                    </div>                    
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0' add_function="kontrol()">
            </cf_box_footer>
        </cfform>
    </cf_box>
 
</div>
<script type="text/javascript">
function kontrol()
{
	if(add_expense_cat.expense_cat_name.value =='')
	{
		alert("<cf_get_lang dictionary_id='53158.Kategori Girmelisiniz'> !");			
		return false;
	}
	return true;
}
</script>
