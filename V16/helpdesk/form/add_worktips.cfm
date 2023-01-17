<cfsavecontent  variable="head"><cf_get_lang dictionary_id='63531.Add Tips'></cfsavecontent>
    <cf_box closable="1" popup_box="1" title="#head#">
    <cfform id="help_tour_form_add">
        <cf_box_elements>
            <input type="hidden" name="recorder_name" value="<cfoutput>#session.ep.name# #session.ep.surname#</cfoutput>" readonly>
            <input type="hidden" name="recorder_email" value="<cfoutput>#session.ep.username#</cfoutput>" readonly>
            <input type="hidden" name="recorder_domain" value="<cfoutput>#HTTP_REFERER#</cfoutput>" readonly>      
    
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-help_head">
                    <label class="col col-4"><cf_get_lang dictionary_id='58810.Question'>*</label>
                    <div class="col col-8">
                        <input type="text" name="help_head" required>
                    </div>
                </div>
                <div class="form-group" id="item-help_content">
                    <label class="col col-4"><cf_get_lang dictionary_id='58654.Reply'></label>
                    <div class="col col-8">
                        <textarea rows="5" name="help_content"></textarea>
                    </div>
                </div>
                <div class="form-group" id="item-help_fuseaction">
                    <label class="col col-4"><cf_get_lang dictionary_id='65419.Wo-Fuseaction'></label>
                    <div class="col col-8">
                        <input type="text" name="help_fuseaction" value="<cfoutput>#attributes.fuseact#</cfoutput>">
                    </div>
                </div>
                <div class="form-group" id="item-is_news">
                    <label class="col col-4"><cf_get_lang dictionary_id='63098.Yenilik Duyurusu'></label>
                    <div class="col col-8">
                        <input type="checkbox" id="is_news" name="is_news" value="1">
                    </div>
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <cf_workcube_buttons add_function='kontrol()'>
            <!--- <input type="submit" id="help_tour_modal_add_item" class="ui-btn ui-btn-success" value="<cfoutput>#getLang('','Ekle',44630)#</cfoutput>"> --->
        </cf_box_footer>
    </cfform>
    </cf_box>
    <script>
        function kontrol() {
            var formObject = {};
            var el_content = $('#help_tour_form_add textarea[name="help_content"]').val();
    
            $.each($("#help_tour_form_add").serializeArray(),function(i, v) {
                formObject[v.name] = v.value;
            });
            var obj = {"active": true, options : {"el_content":el_content}};
           
            formObject.help_topic = JSON.stringify(obj);
           
            formObject.is_news = 0;
            if ($('#is_news').is(':checked')) {formObject.is_news = 1;}
            $.ajax({
                url :'/wex.cfm/tour/insert',
                method: 'post',
                contentType: 'application/json; charset=utf-8',
                dataType: "json",
                data : JSON.stringify(formObject),
                error :  function(response){
                    if(trim(response.responseText) === "Ok"){
                        alert("<cf_get_lang dictionary_id='61777.Yardım Notu Eklendi. Yönlendiriliyorsunuz..'>");
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
    </script>