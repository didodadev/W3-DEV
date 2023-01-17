<!--- <cfset mail_companies = createObject("component", "V16.settings.cfc.mail_company_settings")> --->
<cfparam name="attributes.coid" default="">
<div class="row">
    <div class="col col-12">
        <h4 class="wrkPageHeader"><cf_get_lang dictionary_id='38340.Mail Gönderim Listesi'> Ekle</h4>
    </div>
</div>
<div class="row">
    <div class="col col-12">
        <cfform name = "addMailRecipient">
            <div class="row">
                <div class="col col-12">
                    <div class="form-group">
                        <label class="col col-2 col-xs-12"><cf_get_lang dictionary_id='58733.Alıcı'><cf_get_lang dictionary_id='30467.Listesi'><cf_get_lang dictionary_id='57897.Adı'></label>
                        <div class="col col-3 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang_main dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='58733.Alıcı'><cf_get_lang dictionary_id='30467.Listesi'><cf_get_lang dictionary_id='57897.Adı'></cfsavecontent>
                            <cfinput type="text" name="list_name" id="list_name" value="" required="yes" message="#message#">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-2 col-xs-12"><cf_get_lang dictionary_id='58733.Alıcı'><cf_get_lang dictionary_id='30467.Listesi'><cf_get_lang dictionary_id='57734.Seçiniz'></label>
                        <div class="col col-3 col-xs-12">
                            <cfinput type="file" value="" name="list_file">
                        </div>
                    </div>
                </div>
            </div>
            <div class="row formContentFooter">
                <div class="pull-right">
                    <cf_workcube_buttons is_upd='0'<!---  add_function="kontrol()" --->>
                </div>
            </div>
        </cfform>
    </div>
</div>
