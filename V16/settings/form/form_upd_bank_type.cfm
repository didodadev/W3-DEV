
<!---
    File: form_upd_bank_type.cfm
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
<cfquery name="get_relation_companies" datasource="#dsn#">
	SELECT 
		OBR.*,
		OC.COMPANY_NAME 
	FROM 
		OUR_COMPANY_BANK_RELATION OBR,
		OUR_COMPANY OC
	WHERE 
		OBR.BANK_ID = #url.bank_id# AND
		OBR.OUR_COMPANY_ID = OC.COMP_ID AND
		OBR.BRANCH_ID IS NULL
</cfquery>
<cfquery name="get_relation_branches" datasource="#dsn#">
	SELECT 
		OBR.*,
		B.BRANCH_NAME,
		OC.COMPANY_NAME
	FROM 
		OUR_COMPANY_BANK_RELATION OBR,
		BRANCH B,
		OUR_COMPANY OC
	WHERE 
		OBR.BANK_ID = #url.bank_id# AND
		OBR.BRANCH_ID = B.BRANCH_ID AND
		B.COMPANY_ID = OC.COMP_ID AND
		OBR.BRANCH_ID IS NOT NULL
</cfquery>
<cfquery name="BANK_TYPES" datasource="#dsn#">
	SELECT * FROM SETUP_BANK_TYPES WHERE BANK_ID = #url.bank_id#
</cfquery>
<cfsavecontent variable="title"><cf_get_lang dictionary_id="57987.Bankalar"></cfsavecontent>
<cfsavecontent variable="img_">
    <a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=settings.popup_add_bank_relation&bank_id=#url.bank_id#&bank_name=#bank_types.bank_name#</cfoutput>','');"><img src="/images/elements.gif" border="0" title="<cf_get_lang_main no='1109.İlişikili Şirket Ekle'>" alt="<cf_get_lang_main no='1109.İlişikili Şirket Ekle'>"></a> 
</cfsavecontent>
<cf_box title="#title#" closable="0" collapsed="0" right_images="#img_#" add_href="#request.self#?fuseaction=settings.form_add_bank_type" is_blank="0">
    <cfform name="form" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_bank_type&bank_id=#URL.bank_id#">
        <input type="hidden" name="bank_id" id="bank_id" value="<cfoutput>#url.bank_id#</cfoutput>">
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
                            <cfinput type="text" name="bank_type" id="bank_type" size="30" value="#BANK_TYPES.bank_name#" required="Yes" message="#message#">
                        </div>
                    </div>
                    <div class="form-group" id="item-export_type">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58520.Dosya Türü"></label>
                        <div class="col col-8 col-xs-12">
                            <select name="export_type" id="export_type">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <option value="5" <cfif bank_types.export_type eq 5>selected</cfif>>Akbank</option>
                                <option value="4" <cfif bank_types.export_type eq 4>selected</cfif>>Denizbank</option>
                                <option value="7" <cfif bank_types.export_type eq 7>selected</cfif>>Garanti</option>
                                <option value="6" <cfif bank_types.export_type eq 6>selected</cfif>>HSBC</option>
                                <option value="9" <cfif bank_types.export_type eq 9>selected</cfif>>HSBC2</option>
                                <option value="10" <cfif bank_types.export_type eq 10>selected</cfif>>HSBC Döviz</option>
                                <option value="11" <cfif bank_types.export_type eq 11>selected</cfif>>ING</option>
                                <option value="3" <cfif bank_types.export_type eq 3>selected</cfif>>İşbank</option>
                                <option value="2" <cfif bank_types.export_type eq 2>selected</cfif>>TEB</option>
                                <option value="8" <cfif bank_types.export_type eq 8>selected</cfif>>Vakıfbank</option>
                                <option value="1" <cfif bank_types.export_type eq 1>selected</cfif>>Yapı Kredi</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-bank_code">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59006.Banka Kodu"></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="bank_code" value="#BANK_TYPES.bank_code#" maxlength="50">
                        </div>
                    </div>
                    <div class="form-group" id="item-swift_code">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='29530.Swift Kodu'></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="swift_code" id="swift_code" value ="#BANK_TYPES.swift_code#" maxlength="50">
                        </div>
                    </div>
                    <div class="form-group" id="item-bank_type_group">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="34102.Banka Tipi"></label>
                        <div class="col col-8 col-xs-12">
                            <select name="bank_type_group" id="bank_type_group">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="get_bank_type_groups">
                                    <option value="#BANK_TYPE_ID# <cfif BANK_TYPES.BANK_TYPE_GROUP_ID eq BANK_TYPE_ID>selected</cfif>">#BANK_TYPE#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-detail">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="36199.Açıklama"></label>
                        <div class="col col-8 col-xs-12">
                            <textarea name="detail" id="detail"><cfoutput>#BANK_TYPES.DETAIL#</cfoutput></textarea>
                        </div>
                    </div>
                    <cfsavecontent variable="head"><cf_get_lang dictionary_id='60741.FTP Bilgileri'></cfsavecontent>
                    <div class="col col-12">
                        <cf_seperator id="ftp_info" header="#head#" is_closed="0"> 
                    </div>              
                    <div id="ftp_info" class=" col col-12 padding-0">
                        <div class="form-group" id="item-ftp_server">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58031.Server Adı"></label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="text" name="ftp_server" value="#bank_types.ftp_server_name#" maxlength="50">
                            </div>
                        </div>
                        <div class="form-group" id="item-ftp_file_path">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="49955.Dosya Yolu"></label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="text" name="ftp_file_path" value="#bank_types.ftp_file_path#" maxlength="50">
                            </div>
                        </div>
                        <div class="form-group" id="item-ftp_username">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57551.Kullanıcı Adı"></label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="text" name="ftp_username" value="#bank_types.ftp_username#" maxlength="50">
                            </div>
                        </div>
                        <div class="form-group" id="item-ftp_password">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57552.Şifre"></label>
                            <div class="col col-8 col-xs-12">
                                <cfinput type="password" name="ftp_password" value="#bank_types.ftp_password#"  maxlength="50">
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-xs-12"> 
                    <cfsavecontent variable="company"><cf_get_lang dictionary_id='58017.İlişkili Şirketler'></cfsavecontent>
                    <div class="col col-12">
                        <cf_seperator id="relation_company" header="#company#" is_closed="0">
                    </div>	
                    <div class="form-group col col-12 padding-0" id="relation_company">
                        <cfoutput query="get_relation_companies">
                            <label><i class="fa fa-cube"> <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=settings.popup_upd_bank_relation&relation_id=#relation_id#&bank_name=#bank_types.bank_name#');"  class="tableyazi">#company_name#</i></a> - #relation_number#</label>                       
                        </cfoutput>
                    </div> 
                    <cfsavecontent variable="branch"><cf_get_lang dictionary_id='52063.İlişkili Şubeler'></cfsavecontent>
                    <div class="col col-12">
                        <cf_seperator id="relation_branch" header="#branch#" is_closed="0">
                    </div> 
                    <div class="form-group col col-12 padding-0" id="relation_branch">
                        <cfoutput query="get_relation_branches"> 
                            <label><i class="fa fa-cube"> <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=settings.popup_upd_bank_relation&relation_id=#relation_id#&bank_name=#bank_types.bank_name#');"  class="tableyazi">#company_name# : #branch_name#</i></a> - #relation_number#</label>                       
                        </cfoutput>
                    </div>
                </div>
        </cf_box_elements>
        <cf_box_footer>
            <cf_record_info query_name="BANK_TYPES">
            <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_bank_type&bank_id=#bank_types.bank_id#'>
        </cf_box_footer>
    </cfform> 
</cf_box>