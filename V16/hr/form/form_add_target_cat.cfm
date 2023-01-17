
<cf_catalystHeader>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box>
            <cfform name="add_target_cat" method="post" action="#request.self#?fuseaction=hr.emptypopup_add_target_cat">
                <cf_box_elements>
                    <div class="col col-3 col-md-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-aktif">    
                            <label class="col col-4 col-xs-12">
                                <cf_get_lang dictionary_id ='57493.Aktif'>
                                <input type="checkbox" name="is_active" id="is_active" value="1">
                            </label>
                        </div>

                        <div class="form-group" id="item-kategori">
                            <label class="col col-4 col-xs-12">
                                <cf_get_lang dictionary_id ='57486.Kategori'>*
                            </label>
                            <div class="col col-8 col-xs-12">  
                                <cfinput type="text" name="targetcat_name"  value="" maxlength="150" required="Yes">
                            </div>
                        </div>

                        <div class="form-group" id="item-aciklama">
                            <label class="col col-4 col-xs-12">
                                <cf_get_lang dictionary_id ='57629.Açıklama'>
                            </label>
                            <div class="col col-8 col-xs-12">
                                <textarea name="targetcat_detail" id="targetcat_detail" ></textarea>
                            </div>
                        </div>

                        <div class="form-group" id="item-agirlik">
                            <label class="col col-4 col-xs-12">
                                <cf_get_lang dictionary_id ='29784.Ağırlık'>
                            </label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="text"  name="targetcat_weight" value="" maxlength="5" validate="float" range="0,100">
                            </div>
                        </div>
                    </div>
                        <div class="col col-12 col-md-12 col-xs-12" type="column" index="2" sort="true">
                       
                        <div class="form-group" id="iliskiler">
                                <label class="col" style="display:none"><cf_get_lang dictionary_id="29718.İlişkiler"></label>
                               <div class="ListContent" >
                                    <cf_relation_segment
                                                    is_upd='0'
                                                    is_form='1'
                                                    table_name='TARGET_CAT'
                                                    action_table_name='RELATION_SEoGMENT'
                                                    select_list='1,2,3,4,5,6,7,8'>
                                </div>
                        
                        </div>
                    </div>        
                </cf_box_elements>
                <cf_box_footer>
                    <div class="col col-12">
                    <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                  </div>
                </cf_box_footer>
            </cfform>
        </cf_box>
    </div>
<script type="text/javascript"> 
	function kontrol()
	{
        if( $("textarea[name='targetcat_detail']").val().length > 250 ){
            alert("259");
            return false;
        }
        if( $("input[name='targetcat_name']").val().length == 0){
            return false;
        }
        return true;
    }
</script>
