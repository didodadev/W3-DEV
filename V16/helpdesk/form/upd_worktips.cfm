<cfif isnumeric(attributes.worktips_id)>
    <cfset worktips = createObject("component","WEX/sitetour/components/data") />
    <cfset getWorktips = worktips.getitem( attributes.worktips_id ) />
</cfif>
<cfset help_topic = deSerializeJSON(getWorktips.HELP_TOPIC)>
<cfsavecontent  variable="head"><cf_get_lang dictionary_id='63536.Update Tips'></cfsavecontent>
<cf_box closable="1" popup_box="1" title="#head#">
    <cfoutput>  
        <cfform id="help_tour_form_upd">
            <cf_box_elements>
                <input type="hidden" name="recorder_name" value="#getWorktips.RECORDER_NAME#">
                <input type="hidden" name="recorder_email" value="#getWorktips.RECORDER_EMAIL#">
                <input type="hidden" name="recorder_domain" value="#getWorktips.RECORDER_DOMAIN#">      
                <input type="hidden" name="help_id" value="#attributes.worktips_id#">
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-help_head">
                        <label class="col col-4"><cf_get_lang dictionary_id='58810.Question'>*</label>
                        <div class="col col-8">
                            <input type="text" name="help_head" value="#getWorktips.help_head#" required>
                        </div>
                    </div>
                    <div class="form-group" id="item-help_content">
                        <label class="col col-4"><cf_get_lang dictionary_id='58654.Reply'></label>
                        <div class="col col-8">
                            <textarea rows="5" name="help_content">#help_topic.options.el_content#</textarea>
                        </div>
                    </div>
                    <div class="form-group" id="item-help_fuseaction">
                        <label class="col col-4"><cf_get_lang dictionary_id='65419.Wo-Fuseaction'></label>
                        <div class="col col-8">
                            <input type="text" name="help_fuseaction" value="<cfoutput>#getWorktips.help_fuseaction#</cfoutput>">
                        </div>
                    </div>
                    <div class="form-group" id="item-is_new">
                        <label class="col col-4"><cf_get_lang dictionary_id='63098.Yenilik Duyurusu'></label>
                        <div class="col col-8">
                            <input type="checkbox" id="is_new" name="is_new" value="1" #getWorktips.NEWS eq 1 ? 'checked' : ''#>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd="1" add_function='kontrol()' del_function='delete_function()'>
                <!--- <input type="submit" id="help_tour_modal_add_item" class="ui-btn ui-btn-success" value="#getLang('','Ekle',44630)#"> --->
            </cf_box_footer>
        </cfform>       
    </cfoutput>
</cf_box>
<script>
    function kontrol() {
        var formObject = {};
        var el_content = $('#help_tour_form_upd textarea[name="help_content"]').val();

        $.each($("#help_tour_form_upd").serializeArray(),function(i, v) {
            formObject[v.name] = v.value;
        });
        var obj = {"active": true, options : {"el_content":el_content}};
        formObject.help_topic = JSON.stringify(obj);
        formObject.is_new = 0;
        if ($('#is_new').is(':checked')) {formObject.is_new = 1;}
        $.ajax({
            url :'/wex.cfm/tour/update',
            method: 'post',
            contentType: 'application/json; charset=utf-8',
            dataType: "json",
            data : JSON.stringify(formObject),
            
            error :  function(response){
                
                if(trim(response.responseText) === "Ok"){
                    alert("<cf_get_lang dictionary_id='63537.Yardım Notu Güncellendi'>. <cf_get_lang dictionary_id='63538.Yönlendiriliyorsunuz'>..");
                    location.reload();
                }
                else{
                    alert("<cf_get_lang dictionary_id='52126.Bir hata oluştu'>!");
                    location.reload();
                }
            }
        });
        return false;
    }
    function delete_function() {

        $.ajax({
            url :'/wex.cfm/tour/delete',
            method: 'post',
            contentType: 'application/json; charset=utf-8',
            dataType: "json",
            data: JSON.stringify({help_id: $("input[name = help_id]").val()}),
            error :  function(response){
                if(trim(response.responseText) === "Ok"){
                    alert("<cf_get_lang dictionary_id='63539.Yardım Notu Silindi'>. <cf_get_lang dictionary_id='63538.Yönlendiriliyorsunuz'>..");
                    location.reload();
                }
                else{
                    alert("<cf_get_lang dictionary_id='52126.Bir hata oluştu'>!");
                    location.reload();
                }
            }
        });
    }
</script>