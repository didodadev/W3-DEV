<cfset gms = createObject("component","V16.settings.cfc.mail_server_settings")/>
<cfset get_mail_server= gms.Select(SERVER_NAME_ID:attributes.cpid)/>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Mail Sunucu Ayarları','44098')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="mailServerSettings">
            <cf_box_elements>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="form-group">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='44173.Mail Sunucu Adresi'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="hidden" name="cpid" id="cpid" value="<cfoutput>#attributes.cpid#</cfoutput>">
                            <input type="text" name="server_name" id="server_name" value="<cfoutput>#get_mail_server.SERVER_NAME#</cfoutput>">
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <div class="col col-6 col-xs-12">
                    <cf_record_info query_name="get_mail_server">
                </div>
                <div class="col col-6 col-xs-12">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='48604.Silmek İstediğinizden Emin misiniz'></cfsavecontent>
                    <cf_workcube_buttons is_upd='1'
                    <!--- delete_page_url='#request.self#?fuseaction=project.emptypopup_del_pro&id=#url.id#' --->
                    add_function='kontrol()'
                    delete_alert='#message#'>
                </div>
            </cf_box_footer>                    
        </cfform>            
    </cf_box>
</div>
<script>
    function kontrol()
    {
        var name = document.getElementById('server_name').value;
        var getMailServers = wrk_safe_query("server_name_kontrol",'dsn',0,name);
        if(getMailServers.SERVER_NAME_ID != undefined)
        {
            alert("<cf_get_lang dictionary_id='57197.Alan Adı'><cf_get_lang dictionary_id='58571.Mevcut'>");
            document.getElementById('server_name').focus();
            return false;
        }
        if(document.getElementById('server_name').value == '' || document.getElementById('server_name').value.indexOf(""))
        {
            alert("<cf_get_lang dictionary_id='57197'><cf_get_lang dictionary_id='30941'>");
            return false;
        }
        var mailformat = /^\w+([\.-]?\w+)*(\.\w{2,3})+$/;
        if(server_name.value.match(mailformat))
        {
            document.mailServerSettings.server_name.focus();
            return true;
        }
        else
        {
            alert("<cf_get_lang dictionary_id='42403.Geçersiz Sunucu Adresi'>");
            return false;
        }
        return true;
    }
</script>