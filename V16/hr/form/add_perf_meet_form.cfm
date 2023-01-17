<cfsavecontent variable="message"><cf_get_lang dictionary_id="56571.Performans Görüşme Formu"></cfsavecontent>
<cf_popup_box title="#message#">
	<cfform name="add_perf_emp_info" method="post" action="#request.self#?fuseaction=hr.emptypopup_add_perf_meet_form" enctype="multipart/form-data"><strong></strong>
        	<cf_seperator id="degerlendirilen" title="#getLang('hr',1487)#">
            <table id="degerlendirilen">
                <tr>
                    <td width="100"><cf_get_lang dictionary_id ='57576.Çalışan'> *</td>
                    <td>
                        <input type="hidden" name="employee_id" id="employee_id" value="">
                        <input type="hidden" name="position_code" id="position_code" value="">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='29498.Çalışan Seçmelisiniz'> !</cfsavecontent>
                        <cfinput type="text" name="emp_name" readonly value="" required="yes" message="#message#" style="width:180px;">
                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_under_position_list&field_emp_id=add_perf_emp_info.employee_id&field_pos_code=add_perf_emp_info.position_code&field_name=add_perf_emp_info.emp_name&up_emp_id='+</cfoutput>document.getElementById('amir_id_1').value,'list')"><img src="/images/plus_thin.gif" border="0"></a>
                    </td>
                </tr>
            </table>
            <cfsavecontent variable="message"><cf_get_lang dictionary_id="55316.Değerlendiren"></cfsavecontent>
            <cf_seperator id="degerlendiren" title="#message#">
            <table id="degerlendiren">
                <tr>
                    <td width="100"><cf_get_lang dictionary_id ='56569.İlk Amir'>*</td>
                    <td>
                        <input type="hidden" name="amir_id_1" id="amir_id_1" value="<cfoutput>#session.ep.userid#</cfoutput>">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='56573.Amir Seçmelisiniz'>!</cfsavecontent>
                        <cfinput type="text" name="amir_name_1" value="#get_emp_info(session.ep.userid,0,0)#" required="yes" message="#message#" style="width:180px;">
                        <cfif session.ep.ehesap><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_perf_emp_info.amir_id_1&field_name=add_perf_emp_info.amir_name_1&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif" border="0"></a></cfif>
                    </td>
                </tr>
                <tr>
                    <td><cf_get_lang dictionary_id='58472.Dönem'>*</td>
                    <td>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57655.Başlangıç Tarihi'></cfsavecontent>
                        <cfinput required="Yes" message="#message#" type="text" name="start_date" validate="#validate_style#" value="01/01/#session.ep.period_year#" style="width:80px;">
                        <cf_wrk_date_image date_field="start_date">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                        <cfinput required="Yes" message="#message#" type="text" name="finish_date" validate="#validate_style#" value="31/12/#session.ep.period_year#" style="width:77px;">
                        <cf_wrk_date_image date_field="finish_date">
                    </td>
                </tr>
            </table>
            <cfsavecontent variable="message"><cf_get_lang dictionary_id="56574.Değerlendirmelere İlişkin Yorumlar"></cfsavecontent>
            <cf_seperator id="yorumlar" title="#message#">
            <table id="yorumlar">
                <tr><cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
                    <td width="100" class="txtbold" valign="top"><cf_get_lang dictionary_id ='56575.Personelin'></td>
                    <td><textarea name="emp_comment" id="emp_comment" style="width:370px;height:60px" maxlength="2000" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea></td>
                </tr>
                <tr>
                    <td colspan="2" class="txtbold"><cf_get_lang dictionary_id ='56576.İlk Amirin'></td>
                </tr>
                <tr>
                    <td valign="top"><cf_get_lang dictionary_id ='57556.Bilgi'>(Know-How)</td>
                    <td><textarea name="boss_comment_1" id="boss_comment_1" style="width:370px;height:60px" maxlength="1000" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea></td>
                </tr>
                <tr>
                    <td valign="top"><cf_get_lang dictionary_id ='56577.İş Organizasyonu/Yönetim'></td>
                    <td><textarea name="boss_comment_2" id="boss_comment_2" style="width:370px;height:60px" maxlength="1000" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea></td>
                </tr>
                <tr>
                    <td valign="top"><cf_get_lang dictionary_id ='56578.Problem Çözme'></td>
                    <td><textarea name="boss_comment_3" id="boss_comment_3" style="width:370px;height:60px" maxlength="1000" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea></td>
                </tr>
                <tr>
                    <td valign="top"><cf_get_lang dictionary_id ='56579.İnsan İlişkileri'></td>
                    <td><textarea name="boss_comment_4" id="boss_comment_4" style="width:370px;height:60px" maxlength="1000" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea></td>
                </tr>
                <tr>
                    <td valign="top"><cf_get_lang dictionary_id ='58580.Başarı'></td>
                    <td><textarea name="boss_comment_5" id="boss_comment_5" style="width:370px;height:60px" maxlength="1000" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea></td>
                </tr>
            </table>
        <cf_popup_box_footer><cf_workcube_buttons is_upd='0'></cf_popup_box_footer>
    </cfform>
</cf_popup_box>
