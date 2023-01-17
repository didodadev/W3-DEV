<cfset gma = createObject("component","V16.settings.cfc.mail_accounts_settings")/>
<cfset get_mail_account= gma.Select(MAIL_ACCOUNT_ID:attributes.maid)/>
<cfset GET_MAIL_SERVER= gma.SelectSN()/>

<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="mailServerSettings">
            <cfinput type="hidden" name="maid" id="maid" value="#attributes.maid#">
            <cf_box_elements>
                <div class="col col-4 col-md-12 col-xs-12">
                    <div class="form-group" id="item-server_name_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51238.Sunucu'> <cf_get_lang dictionary_id='57897.Adı'>:</label>
                        <div class="col col-8 col-xs-12">
                            <select name="SERVER_NAME_ID" id="SERVER_NAME_ID">
                                <option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="GET_MAIL_SERVER">
                                    <option value="#SERVER_NAME_ID#" <cfif SERVER_NAME_ID eq get_mail_account.SERVER_NAME_ID> selected </cfif>>#SERVER_NAME#</option>
                                </cfoutput>
                            </select>
                            <!--- <input type="text" name="SERVER_NAME_ID" id="SERVER_NAME_ID" value="#get_mail_account.SERVER_NAME#" readonly> --->
                        </div>
                    </div>
                    <div class="form-group" id="item-mail_account">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57551.Kullanıcı Adı'>:</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="MAIL_ACCOUNT" id="MAIL_ACCOUNT" value="<cfoutput>#get_mail_account.MAIL_ACCOUNT#</cfoutput>" readonly>
                        </div>
                    </div>
                    <!---
                    <div class="form-group">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57552.Şifre'>:</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="MAIL_PASSWORD" id="MAIL_PASSWORD" value="<cfoutput>#get_mail_account.MAIL_PASSWORD#</cfoutput>">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='39718.Kota'>:</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="MAIL_ACCOUNT_QUOTA" id="MAIL_ACCOUNT_QUOTA" value="<cfoutput>#get_mail_account.MAIL_ACCOUNT_QUOTA#</cfoutput>">
                        </div>
                    </div> --->
                    <div class="form-group" id="item-is_active">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='44435.Aktiflik Durumu'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="is_active" id="is_active">
                                <option value='1' <cfoutput><cfif get_mail_account.IS_ACTIVE eq 1></cfoutput>selected="selected"</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                                <option value='2' <cfoutput><cfif get_mail_account.IS_ACTIVE eq 2></cfoutput>selected="selected"</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-is_authorized">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42191.Yetkiler'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="IS_AUTHORIZED" id="IS_AUTHORIZED">
                                <option value='1' <cfoutput><cfif get_mail_account.IS_AUTHORIZED eq 1></cfoutput>selected="selected"</cfif>><cf_get_lang dictionary_id='57930.Kullanıcı'></option>
                                <option value='2' <cfoutput><cfif get_mail_account.IS_AUTHORIZED eq 2></cfoutput>selected="selected"</cfif>><cf_get_lang dictionary_id='29511.Yönetici'></option>
                            </select>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='48604.Silmek İstediğinizden Emin misiniz'></cfsavecontent>
                <cf_workcube_buttons is_upd='1' delete_alert='#message#'>
            </cf_box_footer>
        </cfform> 
    </cf_box>
</div>
<script type="text/javascript">
    function kontrol()
    {
        
        /* theMailAddress = document.getElementById('MAIL_ACCOUNT').value + "*" + document.getElementById('SERVER_NAME_ID').value;
        var getMailAddress = wrk_safe_query("mail_account_kontrol",'dsn',0,theMailAddress);
        if(getMailAddress.MAIL_ACCOUNT_ID != undefined)
        {
            alert("<cf_get_lang dictionary_id='51239.Aynı mail adresi ile başka bir kullanıcı ekleyemezsiniz'>");
            document.getElementById('MAIL_ACCOUNT').focus();
            return false;
        }
        if(document.getElementById('SERVER_NAME_ID').value == '0')
        {
            alert("<cf_get_lang dictionary_id='57471.Eksik Veri'>: <cf_get_lang dictionary_id='51238.Sunucu'><cf_get_lang dictionary_id='57897.Adı'>");
            return false;
        }
        if(document.getElementById('MAIL_ACCOUNT').value == '' || document.getElementById('MAIL_ACCOUNT').value.indexOf(""))
        {
            alert("<cf_get_lang dictionary_id='57471.Eksik Veri'>: <cf_get_lang dictionary_id='55686.E Mail Adresi'>");
            return false;
        }
        if(document.getElementById('MAIL_PASSWORD').value == '' || document.getElementById('MAIL_PASSWORD').value.indexOf(""))
        {
            alert("<cf_get_lang dictionary_id='57471.Eksik Veri'>: <cf_get_lang dictionary_id='57552.Şifre'>");
            return false;
        }
        if(document.getElementById('MAIL_ACCOUNT_QUOTA').value == '' || document.getElementById('MAIL_ACCOUNT_QUOTA').value.indexOf(""))
        {
            alert("<cf_get_lang dictionary_id='57471.Eksik Veri'>: <cf_get_lang dictionary_id='39718.Kota'>");
            return false;
        }

        var mailformat = /^\w+([\.-]?\w+)+$/;
        if(MAIL_ACCOUNT.value.match(mailformat))
        {
            document.mailServerSettings.MAIL_ACCOUNT.focus();
            return true;
        }
        else
        {
            alert("<cf_get_lang dictionary_id='35743.Lütfen farklı bir kullanıcı adı giriniz'>");
            return false;
        } */
        return true;
    }
</script>