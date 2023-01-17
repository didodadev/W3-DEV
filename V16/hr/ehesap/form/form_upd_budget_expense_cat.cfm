<cfparam name="attributes.cat_item_id" default='1'>
<cfparam name="attributes.is_all_cat" default='1'>
<cfinclude template="../query/get_expense_item_static_cat.cfm">
<cfsavecontent variable="message"><cf_get_lang dictionary_id="54254.Gider Kalemi Kategorisi Güncelle"></cfsavecontent>
<cfsavecontent variable="message2"><cf_get_lang dictionary_id="56882.500 Karakterden Fazla Yazmayınız"></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#message#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="upd_expense_cat" method="post" action="#request.self#?fuseaction=ehesap.emptypopup_upd_expense_cat#iif(isdefined("attributes.draggable"),DE("&draggable=1"),DE(""))#'">
            <cf_box_elements>
                <div class="col col-6 col-md-6 col-sm-12 col-xs-12">
                    <div class="form-group">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'> *</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="hidden" name="expense_cat_id" id="expense_cat_id" value="<cfoutput>#url.cat_id#</cfoutput>">
                            <input type="text" name="expense_cat_name" id="expense_cat_name" maxlength="50" value="<cfoutput>#get_expense_item_sta.expense_cat_name#</cfoutput>">	
                        </div>                            
                    </div>
                    <div class="form-group">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <textarea name="expense_cat_detail" id="expense_cat_detail" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message2#</cfoutput>"><cfoutput>#get_expense_item_sta.expense_cat_detail#</cfoutput></textarea>
                        </div>
                    </div>                    
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    <cf_record_info query_name="get_expense_item_sta">
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id ='54255.Bu Gider Kategorisini Siliyorsunuz Emin misiniz'></cfsavecontent>
                    <cf_workcube_buttons is_upd='1' is_delete='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=ehesap.emptypopup_del_expense_cat&cat_id=#url.cat_id##iif(isdefined("attributes.draggable"),DE("&draggable=1"),DE(""))#'>
                </div>            
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
function kontrol()
{
	if(upd_expense_cat.expense_cat_name.value =='')
	{
		alert("<cf_get_lang dictionary_id ='53158.Kategori Girmelisiniz'>");			
		return false;
	}
	return true;
}
</script>
