<!---
    File: form_add_bank_type.cfm
    Folder: V16\settings\form\
	Controller:
    Author:
    Date:
    Description:
        Maas Dosya Exportlari standart olarak bankalar tarafindan verilmektedir
        1- Yapı kredi
        2- Teb
        3- İs bank
        4- Denizbank
        5- Akbank
        6- HSBC
        7- Garanti
        8- VakıfBank
        9- HSBC2
        10- HSBC Doviz
        11- ING Bank
    History:
        
    To Do:

--->

<cfquery name="get_bank_type_groups" datasource="#dsn#">
    SELECT * FROM SETUP_BANK_TYPE_GROUPS ORDER BY BANK_TYPE_ID
</cfquery>
<cfsavecontent variable="title"><cf_get_lang dictionary_id="57987.Bankalar"></cfsavecontent>
<cf_box title="#title#" closable="0" collapsed="0">
    <cfform name="add_bank_type"action="#request.self#?fuseaction=settings.emptypopup_add_bank_type" method="post">
        <cf_box_elements>
                <div class="col col-3 col-xs-12">
                    <div class="scrollbar" style="max-height:403px;overflow:auto;">
                        <div id="cc">
                            <cfinclude template="../display/list_bank_types.cfm">
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-xs-12">	
                    <div class="form-group" id="item-bank">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57521.Banka">*</label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58519.Banka adı girmelisiniz'>!</cfsavecontent>
                            <cfinput type="text" name="bank_type" id="bank_type" size="30" value="" required="Yes" message="#message#">
                        </div>
                    </div>
                    <div class="form-group" id="item-export_type">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58520.Dosya Türü"></label>
                        <div class="col col-8 col-xs-12">
                            <select name="export_type" id="export_type">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <option value="5">Akbank</option>
                                <option value="4">Denizbank</option>
                                <option value="7">Garanti</option>
                                <option value="6">HSBC</option>
                                <option value="9">HSBC2</option>
                                <option value="10">HSBC Döviz</option>
                                <option value="11">ING</option>
                                <option value="3">İşbank</option>
                                <option value="2">TEB</option>
                                <option value="8">Vakıfbank</option>
                                <option value="1">Yapı Kredi</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-bank_code">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59006.Banka Kodu"></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="bank_code" value="" maxlength="50">
                        </div>
                    </div>
                    <div class="form-group" id="item-swift_code">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='29530.Swift Kodu'></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="swift_code" id="swift_code" maxlength="50">
                        </div>
                    </div>
                    <div class="form-group" id="item-bank_type_group">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="34102.Banka Tipi"></label>
                        <div class="col col-8 col-xs-12">
                            <select name="bank_type_group" id="bank_type_group">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_bank_type_groups">
                                    <option value="#BANK_TYPE_ID#">#BANK_TYPE#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-detail">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="36199.Açıklama"></label>
                        <div class="col col-8 col-xs-12">
                            <textarea name="detail" id="detail"></textarea>
                        </div>
                    </div>
                    <cfsavecontent variable="head"><cf_get_lang dictionary_id='60741.FTP Bilgileri'></cfsavecontent>
                    <div class="col col-12">
                        <cf_seperator id="ftp_info" header="#head#" is_closed="0">  
                    </div>             
                    <div class="col col-12 padding-0" id="ftp_info">
                        <div class="form-group" id="item-ftp_server">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58031.Server Adı"></label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="text" name="ftp_server" value="" maxlength="50">
                            </div>
                        </div>
                        <div class="form-group" id="item-ftp_file_path">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="49955.Dosya Yolu"></label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="text" name="ftp_file_path" value="" maxlength="50">
                            </div>
                        </div>
                        <div class="form-group" id="item-ftp_username">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57551.Kullanıcı Adı"></label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="text" name="ftp_username" value="" maxlength="50">
                            </div>
                        </div>
                        <div class="form-group" id="item-ftp_password">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57552.Şifre"></label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="password" name="ftp_password" value=""  maxlength="50">
                            </div>
                        </div>
                    </div>
                </div>
        </cf_box_elements>
        <cf_box_footer>
            <cf_workcube_buttons is_upd='0'>
        </cf_box_footer>
    </cfform> 
</cf_box>