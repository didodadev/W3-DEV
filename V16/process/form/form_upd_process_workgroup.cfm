
<cfform name="form_process_cat" action="#request.self#?fuseaction=process.emptypopup_upd_process_workgroup" method="post">
    <cfsavecontent variable="message"><cf_get_lang dictionary_id='36206.Yetki Grubu'></cfsavecontent>
    <cf_box title="#message#" add_href="openBoxDraggable('#request.self#?fuseaction=process.popup_form_add_process_workgroup&process_row_id=#attributes.process_row_id#','#attributes.modal_id#')" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <input type="hidden" name="process_row_id" id="process_row_id" value="<cfoutput>#attributes.process_row_id#</cfoutput>">
        <input type="hidden" name="workgroup_id" id="workgroup_id" value="<cfoutput>#attributes.workgroup_id#</cfoutput>">
        <div id="cc"  style="padding: 10px 5px 10px 5px;">
            <cfsavecontent variable="txt_1">Maker (<cf_get_lang dictionary_id='36167.Yetkili Pozisyonlar'>)</cfsavecontent>
            <cf_workcube_to_cc
                is_update="1"
                to_dsp_name="#txt_1#"
                form_name="upd_process_cat"
                str_list_param="1,2"
                action_dsn="#dsn#"
                str_action_names = "PRO_POSITION_ID AS TO_POS,PRO_PARTNER_ID AS TO_PAR"
                str_alias_names = ""
                action_table="PROCESS_TYPE_ROWS_POSID"
                action_id_name="WORKGROUP_ID"
                data_type="2"
                action_id="#attributes.workgroup_id#">
        </div>
        <!---
        upd: 15/11/2019 - UH 
        #Süreç aşamasında checker bölümünde 1. ya da 2. amir seçilmişse sadece maker(yetkili pozisyonlar) seçilir.
        ---->
        <cfif not IsDefined("attributes.is_confirm_chief") or not len(attributes.is_confirm_chief)>
            <div id="cc" style="padding: 10px 5px 10px 5px;">
                <cfsavecontent variable="txt_3">Checker (<cf_get_lang dictionary_id='36200.Onay ve Uyarılacaklar'>)</cfsavecontent>
                <cf_workcube_to_cc
                    is_update="1"
                    cc2_dsp_name="#txt_3#"
                    form_name="upd_process_cat"
                    str_list_param="1,2"
                    action_dsn="#dsn#"
                    str_action_names = "CAU_POSITION_ID AS CC2_POS,CAU_PARTNER_ID AS CC2_PAR"
                    str_alias_names = ""
                    action_table="PROCESS_TYPE_ROWS_CAUID"
                    action_id_name="WORKGROUP_ID"
                    data_type="2"
                    action_id="#attributes.workgroup_id#">
            </div>
            <div id="cc" style="padding: 10px 5px 10px 5px;">
                <cfsavecontent variable="txt_2">CC (<cf_get_lang dictionary_id='58773.Bilgi Verilecekler'>)</cfsavecontent>
                <cf_workcube_to_cc
                    is_update="1"
                    cc_dsp_name="#txt_2#" 
                    form_name="upd_process_cat"
                    str_list_param="1,2"
                    action_dsn="#dsn#"
                    str_action_names = "INF_POSITION_ID AS CC_POS,INF_PARTNER_ID AS CC_PAR"
                    str_alias_names = ""
                    action_table="PROCESS_TYPE_ROWS_INFID"
                    action_id_name="WORKGROUP_ID"
                    data_type="2"
                    action_id="#attributes.WORKGROUP_ID#">
            </div>
        </cfif>
        <cf_box_footer>
            <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=process.emptypopup_del_process_workgroup&workgroup_id=#attributes.workgroup_id#&draggable=#iif(isdefined("attributes.draggable"),1,0)#'>
        </cf_box_footer>
    </cf_box>
</cfform>
