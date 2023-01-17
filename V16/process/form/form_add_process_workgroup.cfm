<cfform action="#request.self#?fuseaction=process.emptypopup_add_process_workgroup" name="form_process_cat" method="post">
    <cfsavecontent variable="message"><cf_get_lang dictionary_id='36206.Yetki Grubu'></cfsavecontent>
	<cf_box title="#message#"popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <input type="hidden" name="process_row_id" id="process_row_id" value="<cfoutput>#attributes.process_row_id#</cfoutput>">
        <div id="cc" style="padding: 10px 5px 10px 5px;">
            <cfsavecontent variable="txt_1">Maker (<cf_get_lang dictionary_id='36167.Yetkili Pozisyonlar'>)</cfsavecontent>
            <cf_workcube_to_cc 
                is_update="0" 
                to_dsp_name="#txt_1#" 
                form_name="form_process_cat" 
                str_list_param="1,2" 
                data_type="1">
        </div>
        <!---
        upd: 15/11/2019 - UH 
        #Süreç aşamasında checker bölümünde 1. ya da 2. amir seçilmişse sadece maker(yetkili pozisyonlar) seçilir.
        ---->
        <cfif not IsDefined("attributes.is_confirm_chief") or not len(attributes.is_confirm_chief)>
            <div id="cc" style="padding: 10px 5px 10px 5px;">
                <cfsavecontent variable="txt_3">Checker (<cf_get_lang dictionary_id='36200.Onay ve Uyarılacaklar'>)</cfsavecontent>
                <cf_workcube_to_cc 
                    is_update="0" 
                    cc2_dsp_name="#txt_3#" 
                    form_name="form_process_cat" 
                    str_list_param="1,2" 
                    data_type="1">
            </div>
            <div id="cc" style="padding: 10px 5px 10px 5px;">
                <cfsavecontent variable="txt_2">CC (<cf_get_lang dictionary_id='58773.Bilgi Verilecekler'>)</cfsavecontent>
                <cf_workcube_to_cc 
                    is_update="0" 
                    cc_dsp_name="#txt_2#" 
                    form_name="form_process_cat_2" 
                    str_list_param="1,2" 
                    data_type="1">
            </div>
        </cfif>
        <cf_box_footer>
            <cf_workcube_buttons is_upd='0'>
        </cf_box_footer>
	</cf_box>
</cfform>