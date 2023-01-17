<cfsavecontent variable="message"><cf_get_lang dictionary_id="55165.Pozisyon Görevi Aktar"></cfsavecontent>
<cf_popup_box title="#message#">
    <cfform action="#request.self#?fuseaction=hr.popup_act_transfer_position_works" method="post" name="form_work_transfer">
    <table>
        <tr>
          <td><cf_get_lang dictionary_id='55701.Hangi Pozisyonun Görevleri'></td>
          <td>
            <input type="hidden" name="pos_from" id="pos_from" value="">
            <input type="text" name="pos_from_name" id="pos_from_name" value="" style="width:150px;">
            <a href="javascript://" onclick="javascript:windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_positions&trans=1&field_code=form_work_transfer.pos_from&field_pos_name=form_work_transfer.pos_from_name</cfoutput>','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a> </td>
        </tr>
        <tr>
          <td><cf_get_lang dictionary_id='55702.Hangi Pozisyona'></td>
          <td>
            <input type="hidden" name="pos_to" id="pos_to" value="">
            <input type="text" name="pos_to_name" id="pos_to_name" value="" style="width:150px;">
            <a href="javascript://" onclick="javascript:windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_positions&trans=1&field_code=form_work_transfer.pos_to&field_pos_name=form_work_transfer.pos_to_name</cfoutput>','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a> </td>
        </tr>
    </table>
    <cf_popup_box_footer><cf_workcube_buttons is_upd='0'></cf_popup_box_footer>
    </cfform>
</cf_popup_box>
