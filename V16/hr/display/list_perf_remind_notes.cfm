<cfsavecontent variable="message"><cf_get_lang dictionary_id="56344.Performans Hatırlatma Notları"></cfsavecontent>
<cf_box title="#message#" scroll="1" closable="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#"z>
<table width="100%">
	<tr>
    	<td>
            <cf_get_workcube_note action_section='PERF_EMPLOYEE_ID' action_id='#attributes.employee_id#' style='1' is_special='1' design_id="0" is_open_det="1">
        </td>
    </tr>
</table>
</cf_box>
